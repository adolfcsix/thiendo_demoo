@echo off
setlocal EnableExtensions DisableDelayedExpansion
cd /d "%~dp0"
set "LOGDIR=%CD%\v11150-evidence"
if not exist "%LOGDIR%" mkdir "%LOGDIR%"
if not exist "%LOGDIR%" (echo ERROR: Cannot create evidence folder.& exit /b 2)
> "%LOGDIR%\summary.txt" echo V11.150 Windows dependency and local verification report
set "FAILURES=0"
set "BLOCKED=0"
echo Thien Do V11.150 - logs: "%LOGDIR%"
echo WARNING: Redact any proxy credentials or local secrets before sharing logs.
call :run "01-node" "node --version"
call :run "02-npm" "npm.cmd --version"
call :run "03-registry" "npm.cmd config get registry"
call :run "04-offline" "npm.cmd config get offline"
call :run "05-npm-ping" "npm.cmd ping --fetch-retries=0 --fetch-timeout=15000"
call :run "06-lockfile" "npm.cmd run check:lockfile"
call :run "07-npm-ci" "npm.cmd ci --no-audit --no-fund"
if errorlevel 1 goto :install_blocked
call :run "08-typecheck" "npm.cmd run typecheck"
call :run "09-lint" "npm.cmd run lint --if-present"
call :run "10-build" "npm.cmd run build"
call :run "11-tests" "npm.cmd test"
call :run "12-stability" "npm.cmd run audit:stability:150"
call :run "13-environment" "npm.cmd run check:environment"
rem Database and browser checks must only run against an explicitly verified test target.
call :run "14-e2e-target" "npm.cmd run check:e2e-target"
if errorlevel 1 goto :db_blocked
call :run "15-e2e" "npm.cmd run test:e2e"
call :run "16-browser" "npm.cmd run test:browser:acceptance"
goto :summary
:install_blocked
>> "%LOGDIR%\summary.txt" echo BLOCKED: npm ci failed; typecheck/build/tests not attempted.
set "BLOCKED=1"
goto :summary
:db_blocked
>> "%LOGDIR%\summary.txt" echo BLOCKED: PostgreSQL target not proven; E2E/browser skipped.
set "BLOCKED=1"
goto :summary
:run
set "STEP=%~1"
set "COMMAND=%~2"
echo [RUN] %STEP%
call %COMMAND% > "%LOGDIR%\%STEP%.log" 2>&1
set "RC=%ERRORLEVEL%"
>> "%LOGDIR%\summary.txt" echo %STEP% exit=%RC%
if not "%RC%"=="0" (
  echo [FAIL] %STEP% exit=%RC%
  set /a FAILURES+=1 >nul
)
exit /b %RC%
:summary
echo.>> "%LOGDIR%\summary.txt"
>> "%LOGDIR%\summary.txt" echo FAILURES=%FAILURES% BLOCKED=%BLOCKED%
if not "%FAILURES%"=="0" (echo INCOMPLETE: %FAILURES% failure(s). See summary.txt.& exit /b 1)
if not "%BLOCKED%"=="0" (echo INCOMPLETE: prerequisites blocked. See summary.txt.& exit /b 2)
echo LOCAL CHECKS PASS. Browser/production acceptance requires separate evidence.
exit /b 0
