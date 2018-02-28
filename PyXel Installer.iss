#include <idp.iss>
; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "PyXel IDE"
#define MyAppVersion "Alpha - 0.3.1"
#define MyAppPublisher "Axel M. (amacz13)"
#define MyAppURL "https://pyxel.amacz13.fr"
#define MyAppExeName "PyXel.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{B9A19320-7067-45C2-BB13-C2E99490BD0F}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={pf}\{#MyAppName}
DisableProgramGroupPage=yes
DisableWelcomePage=no
UserInfoPage=yes
MinVersion=6.1
WizardImageFile=installerBanner.bmp
WizardSmallImageFile=installerLogo.bmp
LicenseFile=D:\Documents\PyXel\licence.txt
OutputDir=D:\Documents\PyXel\Installers
OutputBaseFilename=PyXel.IDE.Setup
SetupIconFile=D:\Images\PyXel\icon.ico
Compression=lzma
SolidCompression=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "french"; MessagesFile: "compiler:Languages\French.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 0,6.1

[Files]
Source: "C:\Users\axelm\source\repos\PyXel-IDE\PyXel\bin\Release\PyXel.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\axelm\source\repos\PyXel-IDE\PyXel\bin\Release\ComponentFactory.Krypton.Design.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\axelm\source\repos\PyXel-IDE\PyXel\bin\Release\ComponentFactory.Krypton.Docking.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\axelm\source\repos\PyXel-IDE\PyXel\bin\Release\ComponentFactory.Krypton.Navigator.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\axelm\source\repos\PyXel-IDE\PyXel\bin\Release\ComponentFactory.Krypton.Ribbon.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\axelm\source\repos\PyXel-IDE\PyXel\bin\Release\ComponentFactory.Krypton.Toolkit.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\axelm\source\repos\PyXel-IDE\PyXel\bin\Release\ComponentFactory.Krypton.Workspace.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\axelm\source\repos\PyXel-IDE\PyXel\bin\Release\FastColoredTextBox.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\axelm\source\repos\PyXel-IDE\PyXel\bin\Release\Jacksonsoft.CustomTabControl.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\axelm\source\repos\PyXel-IDE\PyXel\bin\Release\PyXel.exe.config"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\axelm\source\repos\PyXel-IDE\PyXel\bin\Release\PyXel.pdb"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\axelm\source\repos\PyXel-IDE\PyXel\bin\Release\PyXel.xml"; DestDir: "{app}"; Flags: ignoreversion
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{commonprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: quicklaunchicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[Code]
function Framework45IsNotInstalled(): Boolean;
var
  bSuccess: Boolean;
  regVersion: Cardinal;
begin
  Result := True;

  bSuccess := RegQueryDWordValue(HKLM, 'Software\Microsoft\NET Framework Setup\NDP\v4\Full', 'Release', regVersion);
  if (True = bSuccess) and (regVersion >= 378389) then begin
    Result := False;
  end;
end;

procedure InitializeWizard;
begin
  if Framework45IsNotInstalled() then
  begin
    idpAddFile('http://go.microsoft.com/fwlink/?LinkId=852104', ExpandConstant('{tmp}\NetFrameworkInstaller.exe'));
    idpAddFile('https://www.python.org/ftp/python/3.6.4/python-3.6.4.exe', ExpandConstant('{tmp}\Python3.6.exe'));
    idpDownloadAfter(wpReady);
  end;
  
end;

procedure InstallFramework;
var
  StatusText: string;
  ResultCode: Integer;
begin
  StatusText := WizardForm.StatusLabel.Caption;
  WizardForm.StatusLabel.Caption := 'Installing .NET Framework 4.5.2. This might take a few minutes...';
  WizardForm.ProgressGauge.Style := npbstMarquee;
  try
    if not Exec(ExpandConstant('{tmp}\NetFrameworkInstaller.exe'), '/passive /norestart', '', SW_SHOW, ewWaitUntilTerminated, ResultCode) then
    begin
      MsgBox('.NET installation failed with code: ' + IntToStr(ResultCode) + '.', mbError, MB_OK);
    end;
  finally
    WizardForm.StatusLabel.Caption := StatusText;
    WizardForm.ProgressGauge.Style := npbstNormal;

    DeleteFile(ExpandConstant('{tmp}\NetFrameworkInstaller.exe'));
  end;
end;

procedure InstallPython;
var
  StatusText: string;
  ResultCode: Integer;
begin
  StatusText := WizardForm.StatusLabel.Caption;
  WizardForm.StatusLabel.Caption := 'Installing Python 3.6. This might take a few minutes...';
  WizardForm.ProgressGauge.Style := npbstMarquee;
  try
    if not Exec(ExpandConstant('{tmp}\Python3.6.exe'), '/passive InstallAllUsers=1', '', SW_SHOW, ewWaitUntilTerminated, ResultCode) then
    begin
      MsgBox('Python installation failed with code: ' + IntToStr(ResultCode) + '.', mbError, MB_OK);
    end;
  finally
    WizardForm.StatusLabel.Caption := StatusText;
    WizardForm.ProgressGauge.Style := npbstNormal;

    DeleteFile(ExpandConstant('{tmp}\Python3.6.exe'));
  end;
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
  PythonInstalled: Boolean;
  Result1: Boolean;
begin
  case CurStep of
    ssPostInstall:
      begin
        if Framework45IsNotInstalled() then
        begin
          InstallFramework();
        end;
        PythonInstalled := RegKeyExists(HKLM, 'SOFTWARE\Wow6432Node\Python\PythonCore\3.6\InstallPath');
        if not PythonInstalled then
          Result1 := MsgBox('This tool requires python Runtime Environment  to run.  Do you want to install it now ?', mbConfirmation, MB_YESNO) = IDYES;
          if Result1 then
            InstallPython();
          end;
        end; 
      end;
  end.
end;