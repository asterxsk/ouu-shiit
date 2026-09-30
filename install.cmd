@echo off
rem ouu-shiit installer for Windows.
rem
rem Built on the skills CLI from vercel-labs - https://skills.sh
rem
rem   install.cmd                 install everything, for Claude Code, globally
rem   set AGENT=* & install.cmd   install for every agent detected on the machine
rem   set SCOPE= & install.cmd    install into the current project instead of the user dir
rem   set SKILL=0 & install.cmd   skip the companion skills, install ouu-shiit only
rem
rem Git Bash users can run ./install.sh instead.

setlocal enabledelayedexpansion

if "%AGENT%"=="" set AGENT=claude-code
if not defined SCOPE set SCOPE=-g
if "%SKILL%"=="" set SKILL=1

where npx >nul 2>nul
if errorlevel 1 (
  echo npx not found. Install Node.js 18 or newer first: https://nodejs.org
  exit /b 1
)

echo.
echo ouu-shiit - GPU effects and scroll layers for the web
echo agent: %AGENT%   scope: %SCOPE%

echo.
echo [1/4] npx skills add asterxsk/ouu-shiit --skill ouu-shiit
call npx -y skills add asterxsk/ouu-shiit --skill ouu-shiit %SCOPE% -a %AGENT% -y
if errorlevel 1 exit /b 1

if not "%SKILL%"=="0" (
  echo.
  echo [2/4] npx skills add pbakaus/impeccable --skill impeccable
  call npx -y skills add pbakaus/impeccable --skill impeccable %SCOPE% -a %AGENT% -y
  if errorlevel 1 exit /b 1

  echo.
  echo [3/4] npx skills add Leonxlnx/taste-skill --skill design-taste-frontend
  call npx -y skills add Leonxlnx/taste-skill --skill design-taste-frontend %SCOPE% -a %AGENT% -y
  if errorlevel 1 exit /b 1

  echo.
  echo [4/4] npx skills add vercel-labs/agent-skills --skill web-design-guidelines
  call npx -y skills add vercel-labs/agent-skills --skill web-design-guidelines %SCOPE% -a %AGENT% -y
  if errorlevel 1 exit /b 1
)

echo.
echo ------------------------------------------------------------------
echo Done.
echo.
echo   ouu-shiit              the effect layer (this repo)
echo   impeccable             visual direction and craft
echo   design-taste-frontend  brief inference, motion budget, pre-flight check
echo   web-design-guidelines  interface audit
echo.
echo Optional, not installable - it is reference material, not a skill:
echo.
echo   awesome-design-md      74 analysed brand DESIGN.md systems
echo.
echo     git clone --depth 1 https://github.com/VoltAgent/awesome-design-md
echo.
echo   Copy a single brand file into a project root when a brief names one.
echo   See skills\ouu-shiit\reference\design-references.md.
echo.
echo Restart your agent so the new skills are picked up.
echo.
echo Docs:  https://skills.sh
echo ------------------------------------------------------------------

endlocal
