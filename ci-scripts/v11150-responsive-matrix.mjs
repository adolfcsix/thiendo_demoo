import {pathToFileURL} from 'node:url';
import {mkdir,writeFile} from 'node:fs/promises';
import {resolve} from 'node:path';
const modulePath=process.env.THIENDO_PLAYWRIGHT_MODULE;
if(!modulePath)throw Error('BLOCKED: pinned Chromium/Playwright not installed');
const {chromium}=await import(pathToFileURL(modulePath).href);
const origin=process.env.NEXT_BASE_URL||'http://127.0.0.1:3000';
if(!/^http:\/\/127\.0\.0\.1:\d+$/.test(origin))throw Error('BLOCKED: browser checks require loopback Next.js');
const widths=[320,375,390,768,1024,1440,1920],routes=['/','/huyen-hoc','/tarot','/login','/bazi'];
const out=resolve(process.env.THIENDO_BROWSER_REPORT_DIR||'browser-evidence','responsive-matrix');
await mkdir(out,{recursive:true});
const checks=[],browser=await chromium.launch({headless:true});
try{
 for(const width of widths){
  const context=await browser.newContext({viewport:{width,height:900}});
  await context.route('**/api/auth/me',r=>r.fulfill({json:{user:null}}));
  await context.route('**/api/auth/google/config',r=>r.fulfill({json:{enabled:false,clientId:null}}));
  const page=await context.newPage(),pageErrors=[];
  page.on('pageerror',e=>pageErrors.push(e.message));
  for(const route of routes){
   const item={width,route,status:'PASS',overflowPx:0,problem:null};
   try{
    const response=await page.goto(origin+route,{waitUntil:'domcontentloaded',timeout:30000});
    if(!response||response.status()>=500)throw Error('Missing page or HTTP 5xx');
    await page.locator('#main-content').waitFor({timeout:15000});
    await page.waitForTimeout(180);
    const dimensions=await page.evaluate(()=>({width:innerWidth,document:document.documentElement.scrollWidth,body:document.body.scrollWidth}));
    item.overflowPx=Math.max(dimensions.document,dimensions.body)-dimensions.width;
    if(item.overflowPx>2)throw Error('Horizontal overflow +'+item.overflowPx+'px');
    if(pageErrors.length)throw Error('Uncaught page error: '+pageErrors.join('; ').slice(0,500));
    if(route==='/'){
     const search=page.getByRole('button',{name:'Tìm nhanh trang và công cụ'});
     if(await search.count()!==1)throw Error('Expected a single primary search trigger');
     await search.click();
     const modal=page.getByRole('dialog',{name:'Tìm nhanh trang và công cụ'});
     await modal.waitFor();
     const box=await modal.boundingBox();
     if(!box||box.x< -2||box.x+box.width>width+2)throw Error('Search dialog exceeds viewport');
     await page.keyboard.press('Escape');await modal.waitFor({state:'hidden'});
     if(width<=970){
      await page.getByRole('button',{name:'Mở menu',exact:true}).first().click();
      await page.getByRole('dialog',{name:'Thanh điều hướng'}).waitFor();
      await page.getByRole('button',{name:'Đóng điều hướng'}).click();
     }
    }
   }catch(error){
    item.status='FAIL';item.problem=String(error.message||error);
    await page.screenshot({path:resolve(out,'fail-'+width+'-'+(route.slice(1).replaceAll('/','-')||'home')+'.png')}).catch(()=>{});
   }
   checks.push(item);console.log(item.status,width+'px',route,item.problem||'overflow='+item.overflowPx);
   pageErrors.length=0;
  }
  await context.close();
 }
}finally{await browser.close();}
const failures=checks.filter(x=>x.status==='FAIL');
await writeFile(resolve(out,'results.json'),JSON.stringify({scope:'Chromium anonymous-only responsive navigation, mocks /api/auth; not proof of real OAuth/SQL/payment',checks},null,2)+'\n');
console.log('RESPONSIVE',checks.length-failures.length+'/'+checks.length,'PASS');
if(failures.length)process.exitCode=1;
