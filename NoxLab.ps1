chcp 65001 > $null
[Console]::InputEncoding  = [System.Text.UTF8Encoding]::new()
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()
$OutputEncoding = [System.Text.UTF8Encoding]::new()

$ErrorActionPreference = 'Stop'
$script:Language = 'en'
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()
$OutputEncoding = [System.Text.UTF8Encoding]::new()

Add-Type @"
using System;
using System.Runtime.InteropServices;

public static class NoxLabConsoleMode
{
    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern IntPtr GetStdHandle(int nStdHandle);

    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern bool GetConsoleMode(IntPtr hConsoleHandle, out int lpMode);

    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern bool SetConsoleMode(IntPtr hConsoleHandle, int dwMode);

    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern IntPtr GetConsoleWindow();

    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int X, int Y, int cx, int cy, uint uFlags);
}
"@

function Set-ConsoleLayout {
    try {
        $rawUi = $Host.UI.RawUI

        $bufferSize = $rawUi.BufferSize
        $bufferSize.Width = 400
        $bufferSize.Height = 400
        $rawUi.BufferSize = $bufferSize

        $windowSize = $rawUi.WindowSize
        $windowSize.Width = 170
        $windowSize.Height = 200
        $rawUi.WindowSize = $windowSize
    } catch {
    }
}

function Set-ConsoleScreenPosition {
    try {
        $SWP_NOSIZE = 0x0001
        $SWP_NOZORDER = 0x0004
        $windowHandle = [NoxLabConsoleMode]::GetConsoleWindow()

        if ($windowHandle -ne [IntPtr]::Zero) {
            [void][NoxLabConsoleMode]::SetWindowPos($windowHandle, [IntPtr]::Zero, 18, 18, 0, 0, ($SWP_NOSIZE -bor $SWP_NOZORDER))
        }
    } catch {
    }
}

function Disable-ConsoleSelection {
    try {
        $STD_INPUT_HANDLE = -10
        $ENABLE_QUICK_EDIT_MODE = 0x0040
        $ENABLE_EXTENDED_FLAGS = 0x0080
        $ENABLE_MOUSE_INPUT = 0x0010

        $handle = [NoxLabConsoleMode]::GetStdHandle($STD_INPUT_HANDLE)
        $mode = 0
        if ([NoxLabConsoleMode]::GetConsoleMode($handle, [ref]$mode)) {
            $mode = $mode -band (-bnot $ENABLE_QUICK_EDIT_MODE)
            $mode = $mode -band (-bnot $ENABLE_MOUSE_INPUT)
            $mode = $mode -bor $ENABLE_EXTENDED_FLAGS
            [void][NoxLabConsoleMode]::SetConsoleMode($handle, $mode)
        }
    } catch {
    }
}

function Get-Text {
    param(
        [string]$Key
    )

$aAc  = [char]225   # á
$eAc  = [char]233   # é
$iAc  = [char]237   # í
$oAc  = [char]243   # ó
$uAc  = [char]250   # ú
$oUm  = [char]246   # ö
$uUm  = [char]252   # ü
$oDbl = [char]337   # ő
$uDbl = [char]369   # ű


    $texts = @{
        en = @{
            MainMenu = 'Main Menu'
            MenuPrompt = 'Choose a menu option using your keyboard [1,2,3,4,5,6,7,8,0]'
            LanguageMenu = 'Language Selection'
            LanguagePrompt = 'Choose language [1,2,0]'
            Language1 = '[1] English'
            Language2 = '[2] Hungarian'
            Language0 = '[0] Exit'
            Option1 = '[1] MASSGRAVE                      - opens PowerShell'
            Option2 = '[2] WinCheck                       - show current Windows license status'
            Option3 = '[3] Activate by Product Key        - install and activate with your own key'
            Option4 = '[4] Pause Windows Updates          - choose 1 to 12 months'
            Option5 = '[5] Resume Windows Updates         - remove the pause settings'
            Option6 = '[6] PC Details                     - show hardware and system info'
            Option7 = '[7] Settings                       - power, cleanup, privacy tweaks'
            Option8 = '[8] Power Tools                    - reboot and power settings'
            OptionG = 'GitHub                             - github.com/noxian0'
            OptionD = 'Discord                            - noxian_'
            Exit = '[0] Exit'
            EnterToContinue = ' Press Enter to continue'
            AskMonths = '  How many months do you want to pause Windows updates? [1-12]'
            AskKey = '  Enter your Windows product key'
            WindowsToolbar = 'Windows Toolbar'
            PlaceholderReady = 'This action is scaffolded and ready for implementation.'
            TitleLicense = 'Windows License Status'
            LicenseDetails = 'Windows licensing details:'
            LicenseState = 'Expiration / activation state:'
            LicenseError = 'Could not read license information.'
            TitleActivate = 'Activate Windows by Product Key'
            NoProductKey = 'No product key was entered.'
            NothingChanged = 'Nothing was changed.'
            ActivationRan = 'The product key install and activation commands were run.'
            InstallResult = 'Install result:'
            ActivationResult = 'Activation result:'
            ActivationFailed = 'The official activation command failed.'
            TitlePause = 'Windows Update Pause'
            InvalidNumber = 'Invalid number entered.'
            EnterWholeNumber = 'Please enter a whole number between 1 and 12.'
            PauseRange = 'The pause period must be between 1 and 12 months.'
            PauseSet = 'Windows Update deferral was set to {0} month(s).'
            PauseDays = 'Applied value: {0} day(s), capped at a maximum of 365 days.'
            PauseApplied = 'Feature and quality updates were both deferred using Windows Update policy settings.'
            PauseFailed = 'Could not apply the Windows Update deferral settings.'
            TitleResume = 'Resume Windows Updates'
            ResumeDone = 'Windows Update deferral settings were removed.'
            ResumeState = 'Normal update behavior can resume based on your system policy.'
            ResumeFailed = 'Could not remove the Windows Update deferral settings.'
            TitlePcDetails = 'PC Details'
            PcDetailsError = 'Could not read one or more system details.'
            LabelPcName = 'PC Name'
            LabelOs = 'Windows'
            LabelVersion = 'Version'
            LabelUpdateBuild = 'Build / update'
            LabelMotherboard = 'Motherboard'
            LabelBios = 'BIOS'
            LabelCpu = 'CPU'
            LabelCpuThreads = 'Cores / Threads'
            LabelRam = 'RAM'
            LabelGpu = 'GPU'
            LabelGpuDriver = 'GPU Driver'
            LabelResolution = 'Resolution'
            LabelUpdatePause = 'Windows Update pause'
            UpdatePauseNotPaused = 'Not paused'
            UpdatePausePaused = 'Paused: {0} month(s) / about {1} day(s)'
            LabelDisk = 'Disk {0}'
            SettingsMenu = 'Settings'
            SettingsPrompt = 'Choose a settings option [1,2,3,4,5,6,7,8,9,A,B,C,D,E,0]'
            Settings1 = '[1] Ultimate Power Plan           - enable and activate'
            Settings2 = '[2] Sticky Keys Hotkey            - disable shortcut trigger'
            Settings3 = '[3] Delete Temp Files             - clean user and Windows temp'
            Settings4 = '[4] Disable Telemetry and Ads     - apply common privacy policies'
            Settings5 = '[5] Remove Windows Copilot        - disable and remove app where possible'
            Settings6 = '[6] Classic Context Menu          - toggle Windows 11 classic menu'
            Settings7 = '[7] Dark Theme                    - toggle light and dark mode'
            Settings8 = '[8] Game Mode                     - toggle game mode'
            Settings9 = '[9] Verbose Logon                 - toggle detailed sign-in messages'
            SettingsA = '[A] Windows Error Reporting       - toggle WER'
            SettingsB = '[B] File Extensions               - toggle file extension visibility'
            SettingsC = '[C] Visual Effects                - toggle appearance and performance'
            SettingsD = '[D] Explorer Opens To             - toggle Home and This PC'
            SettingsE = '[E] Reinstall Windows Copilot     - open Microsoft Store listing'
            SettingsBack = '[0] Back'
            TitlePowerPlan = 'Ultimate Power Plan'
            PowerPlanEnabled = 'Ultimate Performance was enabled and set as active.'
            PowerPlanFailed = 'Could not enable Ultimate Performance.'
            TitleStickyKeys = 'Sticky Keys Hotkey'
            StickyKeysDone = 'Sticky Keys hotkey was disabled for the current user.'
            StickyKeysFailed = 'Could not disable the Sticky Keys hotkey.'
            TitleTempCleanup = 'Temp Cleanup'
            TempCleanupDone = 'Temporary files cleanup completed.'
            TempCleanupFailed = 'Could not complete temporary files cleanup.'
            TitleTelemetry = 'Telemetry and Ads'
            TelemetryDone = 'Telemetry and common ad-related suggestions were reduced.'
            TelemetryFailed = 'Could not apply telemetry and ads settings.'
            TitleCopilot = 'Windows Copilot'
            CopilotDone = 'Windows Copilot was disabled and removal was attempted.'
            CopilotFailed = 'Could not fully disable or remove Windows Copilot.'
            CopilotStoreOpened = 'The Microsoft Store was opened to the Windows Copilot page.'
            CopilotStoreFailed = 'Could not open the Microsoft Store Copilot page.'
            TitleContextMenu = 'Classic Context Menu'
            ContextMenuClassic = 'Classic Windows 11 context menu was enabled.'
            ContextMenuModern = 'Default Windows 11 context menu was restored.'
            ContextMenuFailed = 'Could not change the context menu mode.'
            TitleDarkTheme = 'Dark Theme'
            DarkThemeOn = 'Dark theme was enabled.'
            DarkThemeOff = 'Light theme was enabled.'
            DarkThemeFailed = 'Could not toggle the Windows theme.'
            TitleGameMode = 'Game Mode'
            GameModeOn = 'Game Mode was enabled.'
            GameModeOff = 'Game Mode was disabled.'
            GameModeFailed = 'Could not toggle Game Mode.'
            TitleVerboseLogon = 'Verbose Logon'
            VerboseOn = 'Verbose logon messages were enabled.'
            VerboseOff = 'Verbose logon messages were disabled.'
            VerboseFailed = 'Could not toggle verbose logon.'
            TitleWer = 'Windows Error Reporting'
            WerOn = 'Windows Error Reporting was enabled.'
            WerOff = 'Windows Error Reporting was disabled.'
            WerFailed = 'Could not toggle Windows Error Reporting.'
            TitleFileExtensions = 'File Extensions'
            FileExtensionsOn = 'File extensions are now visible.'
            FileExtensionsOff = 'File extensions are now hidden.'
            FileExtensionsFailed = 'Could not toggle file extension visibility.'
            TitleVisualEffects = 'Visual Effects'
            VisualEffectsPerformance = 'Visual effects were set for best performance.'
            VisualEffectsAppearance = 'Visual effects were set for better appearance.'
            VisualEffectsFailed = 'Could not toggle visual effects.'
            TitleExplorerLaunch = 'Explorer Opens To'
            ExplorerLaunchThisPc = 'File Explorer will open to This PC.'
            ExplorerLaunchHome = 'File Explorer will open to Home.'
            ExplorerLaunchFailed = 'Could not toggle the File Explorer start location.'
            TitleMassgrave = 'MASSGRAVE'
            DummyOpened = 'A new elevated PowerShell window was opened.'
            DummyRunning = 'MASSGRAVE is running.'
            DummyOpenFailed = 'The elevated PowerShell window could not be opened.'
            PowerMenu = 'Power Tools'
            PowerPrompt = 'Choose a power option [1,2,3,0]'
            Power1 = '[1] Reboot PC                      - restart Windows normally'
            Power2 = '[2] Reboot to BIOS / UEFI          - restart into firmware settings'
            Power3 = '[3] Open Power Button Settings     - Control Panel power options'
            PowerBack = '[0] Back'
            TitleReboot = 'Reboot PC'
            RebootQueued = 'Windows restart was queued.'
            RebootFailed = 'Could not queue the Windows restart.'
            TitleUefi = 'Reboot to BIOS / UEFI'
            UefiQueued = 'Restart to BIOS / UEFI was queued.'
            UefiFailed = 'Could not queue restart to BIOS / UEFI.'
            TitlePowerSettings = 'Power Button Settings'
            PowerSettingsOpened = 'Control Panel power button settings were opened.'
            PowerSettingsFailed = 'Could not open the Control Panel power button settings.'
        }
        hu = @{
            MainMenu = "F${oDbl}men${uUm}"
            MenuPrompt = "V${aAc}lassz men${uUm}pontot a billenty${uDbl}zettel [1,2,3,4,5,6,7,8,0]"
            LanguageMenu = "Nyelv V${aAc}laszt${aAc}s"
            LanguagePrompt = "V${aAc}lassz nyelvet [1,2,0]"
            Language1 = '[1] Angol'
            Language2 = '[2] Magyar'
            Language0 = "[0] Kil${eAc}p${eAc}s"
            Option1 = "[1] MASSGRAVE                      - PowerShell megnyit${aAc}sa"
            Option2 = "[2] WinCheck                       - Windows licenc${aAc}llapot megjelen${iAc}t${eAc}se"
            Option3 = "[3] Aktiv${aAc}ci${oAc} term${eAc}kkulccsal       - saj${aAc}t kulcs telep${iAc}t${eAc}se ${eAc}s aktiv${aAc}l${aAc}sa"
            Option4 = "[4] Windows friss${iAc}t${eAc}s sz${uUm}net       - 1-12 h${oAc}nap v${aAc}laszt${aAc}sa"
            Option5 = "[5] Windows friss${iAc}t${eAc}s folytat${aAc}sa   - a sz${uUm}net t${oUm}rl${eAc}se"
            Option6 = "[6] PC adatok                      - hardver- ${eAc}s rendszerinform${aAc}ci${oAc}"
            Option7 = "[7] Be${aAc}ll${iAc}t${aAc}sok                  - energia, takar${iAc}t${aAc}s, adatv${eAc}delem"
            Option8 = "[8] Energiakezel${eAc}s             - ${uAc}jraind${iAc}t${aAc}s ${eAc}s t${aAc}pbe${aAc}ll${iAc}t${aAc}sok"
            OptionG = 'GitHub                             - github.com/noxian0'
            OptionD = 'Discord                            - noxian_'
            Exit = "[0] Kil${eAc}p${eAc}s"
            EnterToContinue = " Nyomj Entert a folytat${aAc}shoz"
            AskMonths = "  H${aAc}ny h${oAc}napra akarod sz${uUm}neteltetni a Windows friss${iAc}t${eAc}seket? [1-12]"
            AskKey = "  Add meg a Windows term${eAc}kkulcsot"
            WindowsToolbar = 'Windows Toolbar'
            PlaceholderReady = "Ez a funkci${oAc} m${eAc}g csak el${oDbl}k${eAc}sz${iAc}tett hely${oDbl}rz${oAc}."
            TitleLicense = "Windows licenc${aAc}llapot"
            LicenseDetails = "Windows licencadatok:"
            LicenseState = "Lej${aAc}rat / aktiv${aAc}ci${oAc}s ${aAc}llapot:"
            LicenseError = "Nem siker${uUm}lt beolvasni a licencadatokat."
            TitleActivate = "Windows aktiv${aAc}l${aAc}sa term${eAc}kkulccsal"
            NoProductKey = "Nem adt${aAc}l meg term${eAc}kkulcsot."
            NothingChanged = "Nem t${oDbl}rt${eAc}nt v${aAc}ltoz${aAc}s."
            ActivationRan = "A term${eAc}kkulcs telep${iAc}t${eAc}se ${eAc}s aktiv${aAc}l${aAc}sa lefutott."
            InstallResult = "Telep${iAc}t${eAc}s eredm${eAc}nye:"
            ActivationResult = "Aktiv${aAc}l${aAc}s eredm${eAc}nye:"
            ActivationFailed = "A hivatalos aktiv${aAc}l${aAc}si parancs sikertelen volt."
            TitlePause = "Windows friss${iAc}t${eAc}s sz${uUm}net"
            InvalidNumber = "Hib${aAc}s sz${aAc}mot adt${aAc}l meg."
            EnterWholeNumber = "Adj meg egy eg${eAc}sz sz${aAc}mot 1 ${eAc}s 12 k${oDbl}z${oDbl}tt."
            PauseRange = "A sz${uUm}net id${oDbl}tartama csak 1 ${eAc}s 12 h${oAc}nap k${oDbl}z${oDbl}tt lehet."
            PauseSet = "A Windows Update halaszt${aAc}s be${aAc}ll${iAc}tva erre: {0} h${oAc}nap."
            PauseDays = "Alkalmazott ${eAc}rt${eAc}k: {0} nap, legfeljebb 365 napig."
            PauseApplied = "A funkci${oAc}- ${eAc}s min${oDbl}s${eAc}gi friss${iAc}t${eAc}sek halaszt${aAc}sa be lett kapcsolva a szab${aAc}lyzatban."
            PauseFailed = "Nem siker${uUm}lt alkalmazni a Windows Update halaszt${aAc}si be${aAc}ll${iAc}t${aAc}sokat."
            TitleResume = "Windows friss${iAc}t${eAc}s folytat${aAc}sa"
            ResumeDone = "A Windows Update halaszt${aAc}si be${aAc}ll${iAc}t${aAc}sok t${oDbl}r${oDbl}lve lettek."
            ResumeState = "A norm${aAc}l friss${iAc}t${eAc}si m${uUm}k${oDbl}d${eAc}s mostant${oAc}l ${uAc}jra folytat${oAc}dhat."
            ResumeFailed = "Nem siker${uUm}lt t${oDbl}r${oDbl}lni a Windows Update halaszt${aAc}si be${aAc}ll${iAc}t${aAc}sokat."
            TitlePcDetails = "PC adatok"
            PcDetailsError = "Nem siker${uUm}lt beolvasni egy vagy t${oDbl}bb rendszeradatot."
            LabelPcName = "G${eAc}pn${eAc}v"
            LabelOs = "Windows"
            LabelVersion = "Verzi${oAc}"
            LabelUpdateBuild = "Build / friss${iAc}t${eAc}s"
            LabelMotherboard = "Alaplap"
            LabelBios = "BIOS"
            LabelCpu = "Processzor"
            LabelCpuThreads = "Magok / sz${aAc}lak"
            LabelRam = "Mem${oAc}ria"
            LabelGpu = "Videok${aAc}rtya"
            LabelGpuDriver = "GPU driver"
            LabelResolution = "Felbont${aAc}s"
            LabelUpdatePause = "Windows Update sz${uUm}net"
            UpdatePauseNotPaused = "Nincs sz${uUm}neteltetve"
            UpdatePausePaused = "Sz${uUm}neteltetve: {0} h${oAc}nap / kb. {1} nap"
            LabelDisk = "Lemez {0}"
            SettingsMenu = "Be${aAc}ll${iAc}t${aAc}sok"
            SettingsPrompt = "V${aAc}lassz be${aAc}ll${iAc}t${aAc}st [1,2,3,4,5,6,7,8,9,A,B,C,D,E,0]"
            Settings1 = "[1] Ultimate energiaell${aAc}t${aAc}s    - bekapcsol${aAc}s ${eAc}s aktiv${aAc}l${aAc}s"
            Settings2 = "[2] Sticky Keys gyorsbillenty${uAc}   - tilt${aAc}s"
            Settings3 = "[3] Temp f${aAc}jlok t${oDbl}rl${eAc}se     - felhaszn${aAc}l${oAc}i ${eAc}s Windows temp"
            Settings4 = "[4] Telemetria ${eAc}s rekl${aAc}mok   - gyakori adatv${eAc}delmi szab${aAc}lyok"
            Settings5 = "[5] Windows Copilot t${oDbl}rl${eAc}se   - tilt${aAc}s ${eAc}s elt${aAc}vol${iAc}t${aAc}s"
            Settings6 = "[6] Klasszikus helyi men${uUm}    - Windows 11 men${uUm} v${aAc}lt${aAc}s"
            Settings7 = "[7] S${oDbl}t${eAc}t t${eAc}ma                - vil${aAc}gos / s${oDbl}t${eAc}t v${aAc}lt${aAc}s"
            Settings8 = "[8] J${aAc}t${eAc}k m${oAc}d                  - be / ki"
            Settings9 = "[9] R${eAc}szletes bejelentkez${eAc}s     - ${uAc}zenetek be / ki"
            SettingsA = "[A] Windows hibajelent${eAc}s       - be / ki"
            SettingsB = "[B] F${aAc}jlkiterjeszt${eAc}sek        - megjelen${iAc}t${eAc}s be / ki"
            SettingsC = "[C] Vizu${aAc}lis effektek          - megjelen${eAc}s / teljes${iAc}tm${eAc}ny"
            SettingsD = "[D] Int${eAc}z${oDbl} indul${aAc}si hely      - Kezd${oDbl}lap / Ez a g${eAc}p"
            SettingsE = "[E] Windows Copilot let${oDbl}lt${eAc}se - Microsoft Store megnyit${aAc}sa"
            SettingsBack = "[0] Vissza"
            TitlePowerPlan = "Ultimate energiaell${aAc}t${aAc}s"
            PowerPlanEnabled = "Az Ultimate Performance s${eAc}ma enged${eAc}lyezve lett, ${eAc}s most ez az akt${iAc}v."
            PowerPlanFailed = "Nem siker${uUm}lt enged${eAc}lyezni az Ultimate Performance s${eAc}m${aAc}t."
            TitleStickyKeys = "Sticky Keys gyorsbillenty${uAc}"
            StickyKeysDone = "A Sticky Keys gyorsbillenty${uAc} le lett tiltva enn${eAc}l a felhaszn${aAc}l${oAc}n${aAc}l."
            StickyKeysFailed = "Nem siker${uUm}lt letiltani a Sticky Keys gyorsbillenty${uAc}t."
            TitleTempCleanup = "Temp takar${iAc}t${aAc}s"
            TempCleanupDone = "Az ideiglenes f${aAc}jlok takar${iAc}t${aAc}sa befejez${oAc}d${oAc}tt."
            TempCleanupFailed = "Nem siker${uUm}lt befejezni az ideiglenes f${aAc}jlok takar${iAc}t${aAc}s${aAc}t."
            TitleTelemetry = "Telemetria ${eAc}s rekl${aAc}mok"
            TelemetryDone = "A telemetria ${eAc}s a gyakori rekl${aAc}mjelleg${uAc} aj${aAc}nl${aAc}sok cs${oDbl}kkentve lettek."
            TelemetryFailed = "Nem siker${uUm}lt alkalmazni a telemetria ${eAc}s rekl${aAc}m be${aAc}ll${iAc}t${aAc}sokat."
            TitleCopilot = "Windows Copilot"
            CopilotDone = "A Windows Copilot le lett tiltva, ${eAc}s az elt${aAc}vol${iAc}t${aAc}s meg lett k${iAc}s${eAc}relve."
            CopilotFailed = "Nem siker${uUm}lt teljesen letiltani vagy elt${aAc}vol${iAc}tani a Windows Copilotot."
            CopilotStoreOpened = "A Microsoft Store megny${iAc}lt a Windows Copilot oldal${aAc}n."
            CopilotStoreFailed = "Nem siker${uUm}lt megnyitni a Windows Copilot Microsoft Store oldal${aAc}t."
            TitleContextMenu = "Klasszikus helyi men${uUm}"
            ContextMenuClassic = "A klasszikus Windows 11 helyi men${uUm} enged${eAc}lyezve lett."
            ContextMenuModern = "Az alap${eAc}rtelmezett Windows 11 helyi men${uUm} vissza lett ${aAc}ll${iAc}tva."
            ContextMenuFailed = "Nem siker${uUm}lt m${oAc}dos${iAc}tani a helyi men${uUm} m${oAc}dj${aAc}t."
            TitleDarkTheme = "S${oDbl}t${eAc}t t${eAc}ma"
            DarkThemeOn = "A s${oDbl}t${eAc}t t${eAc}ma be lett kapcsolva."
            DarkThemeOff = "A vil${aAc}gos t${eAc}ma be lett kapcsolva."
            DarkThemeFailed = "Nem siker${uUm}lt ${aAc}tv${aAc}ltani a Windows t${eAc}m${aAc}t."
            TitleGameMode = "J${aAc}t${eAc}k m${oAc}d"
            GameModeOn = "A j${aAc}t${eAc}k m${oAc}d be lett kapcsolva."
            GameModeOff = "A j${aAc}t${eAc}k m${oAc}d ki lett kapcsolva."
            GameModeFailed = "Nem siker${uUm}lt ${aAc}tv${aAc}ltani a j${aAc}t${eAc}k m${oAc}dot."
            TitleVerboseLogon = "R${eAc}szletes bejelentkez${eAc}s"
            VerboseOn = "A r${eAc}szletes bejelentkez${eAc}si ${uAc}zenetek be lettek kapcsolva."
            VerboseOff = "A r${eAc}szletes bejelentkez${eAc}si ${uAc}zenetek ki lettek kapcsolva."
            VerboseFailed = "Nem siker${uUm}lt ${aAc}tv${aAc}ltani a r${eAc}szletes bejelentkez${eAc}st."
            TitleWer = "Windows hibajelent${eAc}s"
            WerOn = "A Windows hibajelent${eAc}s be lett kapcsolva."
            WerOff = "A Windows hibajelent${eAc}s ki lett kapcsolva."
            WerFailed = "Nem siker${uUm}lt ${aAc}tv${aAc}ltani a Windows hibajelent${eAc}st."
            TitleFileExtensions = "F${aAc}jlkiterjeszt${eAc}sek"
            FileExtensionsOn = "A f${aAc}jlkiterjeszt${eAc}sek most l${aAc}that${oAc}k."
            FileExtensionsOff = "A f${aAc}jlkiterjeszt${eAc}sek most rejtve vannak."
            FileExtensionsFailed = "Nem siker${uUm}lt ${aAc}tv${aAc}ltani a f${aAc}jlkiterjeszt${eAc}sek megjelen${iAc}t${eAc}s${eAc}t."
            TitleVisualEffects = "Vizu${aAc}lis effektek"
            VisualEffectsPerformance = "A vizu${aAc}lis effektek a jobb teljes${iAc}tm${eAc}nyre lettek ${aAc}ll${iAc}tva."
            VisualEffectsAppearance = "A vizu${aAc}lis effektek a jobb megjelen${eAc}sre lettek ${aAc}ll${iAc}tva."
            VisualEffectsFailed = "Nem siker${uUm}lt ${aAc}tv${aAc}ltani a vizu${aAc}lis effekteket."
            TitleExplorerLaunch = "Int${eAc}z${oDbl} indul${aAc}si hely"
            ExplorerLaunchThisPc = "A F${aAc}jlkezel${oDbl} mostant${oAc}l az Ez a g${eAc}p n${eAc}zetre ny${iAc}lik."
            ExplorerLaunchHome = "A F${aAc}jlkezel${oDbl} mostant${oAc}l a Kezd${oAc}lapra ny${iAc}lik."
            ExplorerLaunchFailed = "Nem siker${uUm}lt ${aAc}tv${aAc}ltani a F${aAc}jlkezel${oDbl} indul${aAc}si hely${eAc}t."
            TitleMassgrave = 'MASSGRAVE'
            DummyOpened = "Megny${iAc}lt egy ${uAc}j emelt PowerShell ablak."
            DummyRunning = "MASSGRAVE ${eAc}ppen fut."
            DummyOpenFailed = "Nem siker${uUm}lt megnyitni az emelt PowerShell ablakot."
            PowerMenu = "Energiakezel${eAc}s"
            PowerPrompt = "V${aAc}lassz energia opci${oAc}t [1,2,3,0]"
            Power1 = "[1] G${eAc}p ${uAc}jraind${iAc}t${aAc}sa               - norm${aAc}l Windows ${uAc}jraind${iAc}t${aAc}s"
            Power2 = "[2] ${uAc}jraind${iAc}t${aAc}s BIOS / UEFI-be     - firmware be${aAc}ll${iAc}t${aAc}sok"
            Power3 = "[3] F${oDbl}kapcsol${oAc} be${aAc}ll${iAc}t${aAc}sok         - Vez${eAc}rl${oDbl}pult energiabe${aAc}ll${iAc}t${aAc}sok"
            PowerBack = "[0] Vissza"
            TitleReboot = "G${eAc}p ${uAc}jraind${iAc}t${aAc}sa"
            RebootQueued = "A Windows ${uAc}jraind${iAc}t${aAc}sa sorba lett ${aAc}ll${iAc}tva."
            RebootFailed = "Nem siker${uUm}lt sorba ${aAc}ll${iAc}tani a Windows ${uAc}jraind${iAc}t${aAc}s${aAc}t."
            TitleUefi = "${uAc}jraind${iAc}t${aAc}s BIOS / UEFI-be"
            UefiQueued = "A BIOS / UEFI ${uAc}jraind${iAc}t${aAc}s sorba lett ${aAc}ll${iAc}tva."
            UefiFailed = "Nem siker${uUm}lt sorba ${aAc}ll${iAc}tani a BIOS / UEFI ${uAc}jraind${iAc}t${aAc}st."
            TitlePowerSettings = "F${oDbl}kapcsol${oAc} be${aAc}ll${iAc}t${aAc}sok"
            PowerSettingsOpened = "A Vez${eAc}rl${oDbl}pult f${oDbl}kapcsol${oAc}-be${aAc}ll${iAc}t${aAc}sai megny${iAc}ltak."
            PowerSettingsFailed = "Nem siker${uUm}lt megnyitni a Vez${eAc}rl${oDbl}pult f${oDbl}kapcsol${oAc}-be${aAc}ll${iAc}t${aAc}sait."
        }
    }

    return $texts[$script:Language][$Key]
}

function Test-IsAdministrator {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Get-LineInFrame {
    param(
        [string]$Text,
        [int]$Width = 92
    )

    $content = '   ' + $Text
    if ($content.Length -gt $Width) {
        $content = $content.Substring(0, $Width)
    }

    return '  |' + $content.PadRight($Width) + '|'
}

function Write-FramedLine {
    param(
        [string]$Text,
        [ConsoleColor]$Color = [ConsoleColor]::Gray,
        [int]$Width = 92
    )

    $content = '   ' + $Text
    if ($content.Length -gt $Width) {
        $content = $content.Substring(0, $Width)
    }

    $line = '  |' + $content.PadRight($Width) + '|'
    Write-Host $line -ForegroundColor $Color
}

function Write-Banner {
    Clear-Host

    $art = @(
        '  _   _  _____ __   __ _       ___   ______  ',
        ' | \ | |/  _  \\ \ / /| |     / _ \  | ___ \ ',
        ' |  \| || | | | \ V / | |    / /_\ \ | |_/ / ',
        ' | . ` || | | | /   \ | |    |  _  | | ___ \ ',
        ' | |\  |\ \_/ // /^\ \| |____| | | | | |_/ / ',
        ' \_| \_/ \___/ \/   \/\_____/\_| |_/ \____/  '
    )

    Write-Host ''
    Write-Host '  ==================================================================================================' -ForegroundColor DarkRed
    foreach ($line in $art) {
        Write-Host ('  ' + $line) -ForegroundColor Red
    }
    Write-Host '  ==================================================================================================' -ForegroundColor DarkRed
    $toolLabel = Get-Text 'WindowsToolbar'
    Write-Host ("  [ NoxLab ] " + $toolLabel) -ForegroundColor Gray
    Write-Host '  BUILD v1.0' -ForegroundColor DarkGray
    Write-Host ''
}

function Set-ConsoleLayout {
    try {
        $rawUi = $Host.UI.RawUI

        $bufferSize = $rawUi.BufferSize
        $bufferSize.Width = 220
        $bufferSize.Height = 220
        $rawUi.BufferSize = $bufferSize

        $windowSize = $rawUi.WindowSize
        $windowSize.Width = 220
        $windowSize.Height = 220
        $rawUi.WindowSize = $windowSize
    } catch {
    }
}

function Write-Banner {
    Clear-Host
    $art = @(
        '  _   _  _____ __   __ _       ___   ______  ',
        ' | \ | |/  _  \\ \ / /| |     / _ \  | ___ \ ',
        ' |  \| || | | | \ V / | |    / /_\ \ | |_/ / ',
        ' | . ` || | | | /   \ | |    |  _  | | ___ \ ',
        ' | |\  |\ \_/ // /^\ \| |____| | | | | |_/ / ',
        ' \_| \_/ \___/ \/   \/\_____/\_| |_/ \____/  '
    )

    Write-Host ''
    Write-Host '  ====================================================================================================' -ForegroundColor DarkRed
    foreach ($line in $art) {
        Write-Host ('  ' + $line) -ForegroundColor Red
    }
    Write-Host '  ====================================================================================================' -ForegroundColor DarkRed
    Write-Host '   BUILD v1.0' -ForegroundColor DarkGray
    Write-Host ''
}

function Show-IntroAnimation {
    $logo = @'

                                         @@@                                        
                          @@@@@         @@ @         @@@@@                          
                       @@@@   @         @  @         @   @@@@                       
                     @@@    @@@        @@  @@        @@@    @@@                     
                   @@@   @ @@          @@ @ @          @@ @   @@@                   
                  @@    @ @@          @@  @ @@          @@ @    @@                  
                @@@   @@@ @           @   @  @           @ @@@   @@@                
               @@    @@@  @           @  @@  @           @   @@    @@               
              @@   @ @ @  @@@       @@@     @@@@       @@@  @@@ @   @@              
             @@   @ @@ @@  @@@@    @@  @@  @   @@    @@@@  @@ @@     @@             
            @@    @@    @@@   @@@@@@ @@   @  @@ @@@@@@   @@@ @  @@    @@            
            @@     @@@    @@  @@@@@@@  @@ @@@  @@@@@@@  @@    @@@     @@            
            @   @ @@       @@@        @@@  @@         @@@       @@ @   @            
           @@   @ @ @@@@    @@@@@@      @@ @ @@    @@@@@    @@@@ @ @   @@           
           @     @@ @   @@@ @    @@      @@@ @   @@    @ @ @   @ @@     @           
           @   @ @   @@@@@  @@@@ @   @@    @@@    @@@@@   @@@@@   @     @           
           @   @ @@ @@@  @ @@@  @@   @@@    @@@   @@  @@@ @  @@  @@     @           
           @    @ @ @@ @@@   @@@ @   @ @@@    @   @ @@@   @@@ @@ @ @    @           
           @@   @ @@@ @@       @ @   @  @@@       @ @       @@ @@@ @   @@           
            @   @@ @@  @@      @@@   @@@  @@@     @@@      @@  @@ @@   @            
            @@   @@@ @  @     @   @@   @@  @@@  @@  @      @  @ @@@   @@            
             @@   @@@@  @     @@@@@ @@ @@  @@ @@ @@@@      @  @ @@   @@             
             @@@   @@@  @         @@@ @@    @@ @@@         @  @@@   @@              
              @@@   @@  @@          @@  @  @ @@@          @@  @@   @@               
                @@   @@  @          @          @          @  @@   @@                
                 @@@     @@         @@@@@@@@@@@@        @@@ @   @@@                 
                   @@@    @@@         @ @  @ @         @@@    @@@                   
                     @@@@   @@@       @ @  @ @        @@   @@@@                     
                        @@@@  @       @ @  @ @          @@@@                        
                           @@@@       @ @  @ @       @@@@                           
                                      @ @ @@ @                                      
                                      @ @  @ @                                      
                                      @ @  @ @                                      
                                      @ @@ @ @                                      
                                      @ @  @ @                                      
                                     @@@@@ @@@@                                     
                                     @      @ @                                     
                                    @@ @@  @@ @@                                    
                                    @ @@@@@@@@ @                                    
                                    @@@    @ @@@                                    
                                      @@    @@                                      
                                       @@  @                                                                                                                                                                                                                                                                                                                                                                                          
'@

    $baseFrame = $logo -split "`r?`n"
    $offsets = @(72, 72, 64, 64, 56, 56, 48, 48, 40, 40, 32, 32, 24, 24, 18, 18, 12, 12, 8, 8, 4, 4, 0, 0)
    $statusLine1 = @(
        'Booting NoxLab core',
        'Loading interface map',
        'Linking startup modules',
        'Preparing command grid',
        'Finalizing shell state',
        'NoxLab ready'
    )
    $spinnerFrames = @('◜', '◠', '◝', '◞', '◡', '◟')
    $endTime = (Get-Date).AddSeconds(8)
    $index = 0

    while ((Get-Date) -lt $endTime) {
        $frameIndex = [Math]::Min($index, $offsets.Count - 1)
        $offset = $offsets[$frameIndex]
        $frame = foreach ($line in $baseFrame) {
            if ([string]::IsNullOrWhiteSpace($line)) {
                ''
                continue
            }

            $visibleLength = [Math]::Max(0, $line.Length - $offset)
            if ($visibleLength -le 0) {
                ''
            } else {
                (' ' * $offset) + $line.Substring($offset, $visibleLength)
            }
        }

        Clear-Host
        Write-Host ''
        Write-Host '  ==================================================================================================' -ForegroundColor DarkRed
        foreach ($line in $frame) {
            Write-Host ('  ' + $line) -ForegroundColor Red
        }
        Write-Host '  ==================================================================================================' -ForegroundColor DarkRed
        Write-Host '  BUILD v1.0' -ForegroundColor DarkGray
        Write-Host ''
        $loaderIndex = [Math]::Min([int]([Math]::Floor($frameIndex / 4)), $statusLine1.Count - 1)
        $spinner = $spinnerFrames[$index % $spinnerFrames.Count]
        Write-Host ('  ' + $statusLine1[$loaderIndex]) -ForegroundColor Gray
        Write-Host ('  ' + $spinner + '  loading') -ForegroundColor Green
        Start-Sleep -Milliseconds 260
        if ($index -lt ($offsets.Count - 1)) {
            $index++
        }
    }
}

function Write-MenuFrame {
    param(
        [string]$Header,
        [string[]]$Items,
        [string]$Prompt = 'Choose a menu option'
    )

    $innerWidth = 92
    $top = '  .' + ('=' * $innerWidth) + '.'
    $mid = '  |' + (' ' * $innerWidth) + '|'
    $bottom = "  '" + ('=' * $innerWidth) + "'"
    $titleText = " $Header "
    $titlePad = [Math]::Max(0, [Math]::Floor(($innerWidth - $titleText.Length) / 2))
    $titleLine = '  |' + (' ' * $titlePad) + $titleText + (' ' * ($innerWidth - $titlePad - $titleText.Length)) + '|'

    Write-Banner
    Write-Host $top -ForegroundColor DarkGray
    Write-Host $mid -ForegroundColor DarkGray
    Write-Host $titleLine -ForegroundColor White
    Write-Host $mid -ForegroundColor DarkGray

    foreach ($item in $Items) {
        if ([string]::IsNullOrWhiteSpace($item)) {
            Write-Host $mid -ForegroundColor DarkGray
            continue
        }

        $parts = $item -split '\s+-\s+', 2
        if ($parts.Count -eq 2) {
            Write-FramedLine -Text ('>> ' + $parts[0].Trim()) -Color White -Width $innerWidth
            Write-FramedLine -Text ('   ' + $parts[1].Trim()) -Color Cyan -Width $innerWidth
            Write-Host $mid -ForegroundColor DarkGray
            continue
        }

        Write-FramedLine -Text ('>> ' + $item.Trim()) -Color White -Width $innerWidth
        Write-Host $mid -ForegroundColor DarkGray
    }

    Write-Host $mid -ForegroundColor DarkGray
    Write-Host $bottom -ForegroundColor DarkGray
    Write-Host ''
    Write-Host ('  ' + $Prompt + ': ') -ForegroundColor Green -NoNewline
}

function Pause-NoxLab {
    Write-Host ''
    Read-Host (Get-Text 'EnterToContinue')
}

function Show-MessageScreen {
    param(
        [string]$Title,
        [string[]]$Lines,
        [ConsoleColor]$AccentColor = [ConsoleColor]::Gray
    )

    Write-Banner
    Write-Host '  .==============================================================================================.' -ForegroundColor DarkGray
    Write-Host ('  | ' + $Title.PadRight(92) + '|') -ForegroundColor White
    Write-Host '  |                                                                                              |' -ForegroundColor DarkGray

    foreach ($line in $Lines) {
        Write-Host (Get-LineInFrame -Text $line) -ForegroundColor $AccentColor
    }

    Write-Host '  |                                                                                              |' -ForegroundColor DarkGray
    Write-Host "  '=============================================================================================='" -ForegroundColor DarkGray
    Write-Host ''
    Pause-NoxLab
}

function Invoke-PlaceholderAction {
    param(
        [string]$Title,
        [string]$Description
    )

    Show-MessageScreen -Title $Title -Lines @(
        $Description,
        '',
        (Get-Text 'PlaceholderReady')
    ) -AccentColor Yellow
}

function Get-LicenseStatusText {
    param(
        [int]$Status
    )

    switch ($Status) {
        0 { 'Unlicensed' }
        1 { 'Licensed' }
        2 { 'Out-of-Box Grace' }
        3 { 'Out-of-Tolerance Grace' }
        4 { 'Non-Genuine Grace' }
        5 { 'Notification' }
        6 { 'Extended Grace' }
        default { "Unknown ($Status)" }
    }
}

function Show-WindowsLicenseStatus {
    try {
        $dliOutput = cscript.exe //NoLogo "$env:SystemRoot\System32\slmgr.vbs" /dli 2>&1 | Out-String
        $xprOutput = cscript.exe //NoLogo "$env:SystemRoot\System32\slmgr.vbs" /xpr 2>&1 | Out-String
        $normalizedDli = (($dliOutput -split '\r?\n') | ForEach-Object { $_.Trim() } | Where-Object { $_ }) -join ' '
        $normalizedXpr = (($xprOutput -split '\r?\n') | ForEach-Object { $_.Trim() } | Where-Object { $_ }) -join ' '

        Show-MessageScreen -Title (Get-Text 'TitleLicense') -Lines @(
            (Get-Text 'LicenseDetails'),
            $normalizedDli,
            '',
            (Get-Text 'LicenseState'),
            $normalizedXpr
        ) -AccentColor Cyan
    } catch {
        Show-MessageScreen -Title (Get-Text 'TitleLicense') -Lines @(
            (Get-Text 'LicenseError'),
            $_.Exception.Message
        ) -AccentColor Yellow
    }
}

function Install-WindowsProductKey {
    $productKey = Read-Host (Get-Text 'AskKey')
    $productKey = $productKey.Trim()

    if ([string]::IsNullOrWhiteSpace($productKey)) {
        Show-MessageScreen -Title (Get-Text 'TitleActivate') -Lines @(
            (Get-Text 'NoProductKey'),
            (Get-Text 'NothingChanged')
        ) -AccentColor Yellow
        return
    }

    try {
        $installResult = cscript.exe //NoLogo "$env:SystemRoot\System32\slmgr.vbs" /ipk $productKey 2>&1 | Out-String
        $activateResult = cscript.exe //NoLogo "$env:SystemRoot\System32\slmgr.vbs" /ato 2>&1 | Out-String

        Show-MessageScreen -Title (Get-Text 'TitleActivate') -Lines @(
            (Get-Text 'ActivationRan'),
            '',
            (Get-Text 'InstallResult'),
            ($installResult.Trim() -replace '\r?\n', ' '),
            '',
            (Get-Text 'ActivationResult'),
            ($activateResult.Trim() -replace '\r?\n', ' ')
        ) -AccentColor Green
    } catch {
        Show-MessageScreen -Title (Get-Text 'TitleActivate') -Lines @(
            (Get-Text 'ActivationFailed'),
            $_.Exception.Message
        ) -AccentColor Yellow
    }
}

function Set-WindowsUpdatePause {
    $monthsText = Read-Host (Get-Text 'AskMonths')
    $monthsText = $monthsText.Trim()

    $months = 0
    if (-not [int]::TryParse($monthsText, [ref]$months)) {
        Show-MessageScreen -Title (Get-Text 'TitlePause') -Lines @(
            (Get-Text 'InvalidNumber'),
            (Get-Text 'EnterWholeNumber')
        ) -AccentColor Yellow
        return
    }

    if ($months -lt 1 -or $months -gt 12) {
        Show-MessageScreen -Title (Get-Text 'TitlePause') -Lines @(
            (Get-Text 'PauseRange'),
            (Get-Text 'NothingChanged')
        ) -AccentColor Yellow
        return
    }

    $days = [Math]::Min($months * 30, 365)
    $policyPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate'

    try {
        if (-not (Test-Path $policyPath)) {
            New-Item -Path $policyPath -Force | Out-Null
        }

        New-ItemProperty -Path $policyPath -Name 'DeferFeatureUpdates' -PropertyType DWord -Value 1 -Force | Out-Null
        New-ItemProperty -Path $policyPath -Name 'DeferFeatureUpdatesPeriodInDays' -PropertyType DWord -Value $days -Force | Out-Null
        New-ItemProperty -Path $policyPath -Name 'DeferQualityUpdates' -PropertyType DWord -Value 1 -Force | Out-Null
        New-ItemProperty -Path $policyPath -Name 'DeferQualityUpdatesPeriodInDays' -PropertyType DWord -Value $days -Force | Out-Null

        Show-MessageScreen -Title (Get-Text 'TitlePause') -Lines @(
            ([string]::Format((Get-Text 'PauseSet'), $months)),
            ([string]::Format((Get-Text 'PauseDays'), $days)),
            '',
            (Get-Text 'PauseApplied')
        ) -AccentColor Green
    } catch {
        Show-MessageScreen -Title (Get-Text 'TitlePause') -Lines @(
            (Get-Text 'PauseFailed'),
            $_.Exception.Message
        ) -AccentColor Yellow
    }
}

function Resume-WindowsUpdates {
    $policyPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate'
    $propertyNames = @(
        'DeferFeatureUpdates',
        'DeferFeatureUpdatesPeriodInDays',
        'DeferQualityUpdates',
        'DeferQualityUpdatesPeriodInDays'
    )

    try {
        if (Test-Path $policyPath) {
            foreach ($propertyName in $propertyNames) {
                Remove-ItemProperty -Path $policyPath -Name $propertyName -ErrorAction SilentlyContinue
            }
        }

        Show-MessageScreen -Title (Get-Text 'TitleResume') -Lines @(
            (Get-Text 'ResumeDone'),
            (Get-Text 'ResumeState')
        ) -AccentColor Green
    } catch {
        Show-MessageScreen -Title (Get-Text 'TitleResume') -Lines @(
            (Get-Text 'ResumeFailed'),
            $_.Exception.Message
        ) -AccentColor Yellow
    }
}

function Get-UpdatePauseSummary {
    $policyPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate'

    try {
        if (-not (Test-Path $policyPath)) {
            return Get-Text 'UpdatePauseNotPaused'
        }

        $policy = Get-ItemProperty -Path $policyPath -ErrorAction SilentlyContinue
        $days = [int]($policy.DeferQualityUpdatesPeriodInDays)

        if ($days -le 0) {
            return Get-Text 'UpdatePauseNotPaused'
        }

        $months = [Math]::Round($days / 30.0, 1)
        return [string]::Format((Get-Text 'UpdatePausePaused'), $months, $days)
    } catch {
        return Get-Text 'UpdatePauseNotPaused'
    }
}

function Enable-UltimatePowerPlan {
    try {
        $ultimateGuid = 'e9a42b02-d5df-448d-aa00-03f14749eb61'
        $listOutput = powercfg /list 2>&1 | Out-String
        if ($listOutput -notmatch 'Ultimate Performance') {
            powercfg -duplicatescheme $ultimateGuid | Out-Null
            $listOutput = powercfg /list 2>&1 | Out-String
        }

        $match = [regex]::Match($listOutput, 'Power Scheme GUID:\s*([a-fA-F0-9\-]+)\s*\(Ultimate Performance\)')
        $activeGuid = if ($match.Success) { $match.Groups[1].Value } else { $ultimateGuid }
        powercfg /setactive $activeGuid | Out-Null

        Show-MessageScreen -Title (Get-Text 'TitlePowerPlan') -Lines @(
            (Get-Text 'PowerPlanEnabled')
        ) -AccentColor Green
    } catch {
        Show-MessageScreen -Title (Get-Text 'TitlePowerPlan') -Lines @(
            (Get-Text 'PowerPlanFailed'),
            $_.Exception.Message
        ) -AccentColor Yellow
    }
}

function Disable-StickyKeysHotkey {
    try {
        New-ItemProperty -Path 'HKCU:\Control Panel\Accessibility\StickyKeys' -Name 'Flags' -Value '506' -PropertyType String -Force | Out-Null
        Show-MessageScreen -Title (Get-Text 'TitleStickyKeys') -Lines @(
            (Get-Text 'StickyKeysDone')
        ) -AccentColor Green
    } catch {
        Show-MessageScreen -Title (Get-Text 'TitleStickyKeys') -Lines @(
            (Get-Text 'StickyKeysFailed'),
            $_.Exception.Message
        ) -AccentColor Yellow
    }
}

function Clear-TempFiles {
    try {
        $targets = @(
            $env:TEMP,
            "$env:SystemRoot\Temp"
        )

        foreach ($target in $targets) {
            if (Test-Path $target) {
                Get-ChildItem -LiteralPath $target -Force -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
            }
        }

        Show-MessageScreen -Title (Get-Text 'TitleTempCleanup') -Lines @(
            (Get-Text 'TempCleanupDone')
        ) -AccentColor Green
    } catch {
        Show-MessageScreen -Title (Get-Text 'TitleTempCleanup') -Lines @(
            (Get-Text 'TempCleanupFailed'),
            $_.Exception.Message
        ) -AccentColor Yellow
    }
}

function Disable-TelemetryAndAds {
    try {
        $settings = @(
            @{ Path='HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection'; Name='AllowTelemetry'; Type='DWord'; Value=0 },
            @{ Path='HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo'; Name='Enabled'; Type='DWord'; Value=0 },
            @{ Path='HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager'; Name='SubscribedContent-338388Enabled'; Type='DWord'; Value=0 },
            @{ Path='HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager'; Name='SubscribedContent-338389Enabled'; Type='DWord'; Value=0 },
            @{ Path='HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager'; Name='SubscribedContent-353698Enabled'; Type='DWord'; Value=0 },
            @{ Path='HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager'; Name='SystemPaneSuggestionsEnabled'; Type='DWord'; Value=0 }
        )

        foreach ($setting in $settings) {
            if (-not (Test-Path $setting.Path)) {
                New-Item -Path $setting.Path -Force | Out-Null
            }
            New-ItemProperty -Path $setting.Path -Name $setting.Name -PropertyType $setting.Type -Value $setting.Value -Force | Out-Null
        }

        Show-MessageScreen -Title (Get-Text 'TitleTelemetry') -Lines @(
            (Get-Text 'TelemetryDone')
        ) -AccentColor Green
    } catch {
        Show-MessageScreen -Title (Get-Text 'TitleTelemetry') -Lines @(
            (Get-Text 'TelemetryFailed'),
            $_.Exception.Message
        ) -AccentColor Yellow
    }
}

function Remove-WindowsCopilot {
    try {
        $packageNames = @(
            'Microsoft.Copilot',
            'Microsoft.Windows.Ai.Copilot.Provider'
        )

        foreach ($packageName in $packageNames) {
            Get-AppxPackage -Name $packageName -ErrorAction SilentlyContinue | Remove-AppxPackage -ErrorAction SilentlyContinue
            Get-AppxPackage -AllUsers -Name $packageName -ErrorAction SilentlyContinue | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
        }

        $policies = @(
            @{ Path='HKCU:\Software\Policies\Microsoft\Windows\WindowsCopilot'; Name='TurnOffWindowsCopilot'; Value=1 },
            @{ Path='HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot'; Name='TurnOffWindowsCopilot'; Value=1 }
        )

        foreach ($policy in $policies) {
            if (-not (Test-Path $policy.Path)) {
                New-Item -Path $policy.Path -Force | Out-Null
            }
            New-ItemProperty -Path $policy.Path -Name $policy.Name -PropertyType DWord -Value $policy.Value -Force | Out-Null
        }

        Show-MessageScreen -Title (Get-Text 'TitleCopilot') -Lines @(
            (Get-Text 'CopilotDone')
        ) -AccentColor Green
    } catch {
        Show-MessageScreen -Title (Get-Text 'TitleCopilot') -Lines @(
            (Get-Text 'CopilotFailed'),
            $_.Exception.Message
        ) -AccentColor Yellow
    }
}

function Open-CopilotStorePage {
    try {
        Start-Process 'ms-windows-store://pdp/?ProductId=XP9CXNGPPJ97XX'
        Show-MessageScreen -Title (Get-Text 'TitleCopilot') -Lines @(
            (Get-Text 'CopilotStoreOpened')
        ) -AccentColor Green
    } catch {
        Show-MessageScreen -Title (Get-Text 'TitleCopilot') -Lines @(
            (Get-Text 'CopilotStoreFailed'),
            $_.Exception.Message
        ) -AccentColor Yellow
    }
}

function Toggle-ClassicContextMenu {
    $clsidPath = 'HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32'

    try {
        if (Test-Path $clsidPath) {
            Remove-Item 'HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}' -Recurse -Force -ErrorAction SilentlyContinue
            $message = Get-Text 'ContextMenuModern'
        } else {
            New-Item -Path $clsidPath -Force | Out-Null
            New-ItemProperty -Path $clsidPath -Name '(default)' -Value '' -PropertyType String -Force | Out-Null
            $message = Get-Text 'ContextMenuClassic'
        }

        Show-MessageScreen -Title (Get-Text 'TitleContextMenu') -Lines @(
            $message
        ) -AccentColor Green
    } catch {
        Show-MessageScreen -Title (Get-Text 'TitleContextMenu') -Lines @(
            (Get-Text 'ContextMenuFailed'),
            $_.Exception.Message
        ) -AccentColor Yellow
    }
}

function Toggle-DarkTheme {
    try {
        $path = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize'
        if (-not (Test-Path $path)) {
            New-Item -Path $path -Force | Out-Null
        }

        $current = (Get-ItemProperty -Path $path -Name 'AppsUseLightTheme' -ErrorAction SilentlyContinue).AppsUseLightTheme
        $lightMode = if ($null -eq $current) { 1 } else { [int]$current }

        if ($lightMode -eq 1) {
            $newValue = 0
            $message = Get-Text 'DarkThemeOn'
        } else {
            $newValue = 1
            $message = Get-Text 'DarkThemeOff'
        }

        New-ItemProperty -Path $path -Name 'AppsUseLightTheme' -PropertyType DWord -Value $newValue -Force | Out-Null
        New-ItemProperty -Path $path -Name 'SystemUsesLightTheme' -PropertyType DWord -Value $newValue -Force | Out-Null

        Show-MessageScreen -Title (Get-Text 'TitleDarkTheme') -Lines @(
            $message
        ) -AccentColor Green
    } catch {
        Show-MessageScreen -Title (Get-Text 'TitleDarkTheme') -Lines @(
            (Get-Text 'DarkThemeFailed'),
            $_.Exception.Message
        ) -AccentColor Yellow
    }
}

function Toggle-GameMode {
    try {
        $path = 'HKCU:\Software\Microsoft\GameBar'
        if (-not (Test-Path $path)) {
            New-Item -Path $path -Force | Out-Null
        }

        $current = (Get-ItemProperty -Path $path -Name 'AutoGameModeEnabled' -ErrorAction SilentlyContinue).AutoGameModeEnabled
        $enabled = if ($null -eq $current) { 1 } else { [int]$current }

        if ($enabled -eq 1) {
            $newValue = 0
            $message = Get-Text 'GameModeOff'
        } else {
            $newValue = 1
            $message = Get-Text 'GameModeOn'
        }

        New-ItemProperty -Path $path -Name 'AutoGameModeEnabled' -PropertyType DWord -Value $newValue -Force | Out-Null
        New-ItemProperty -Path $path -Name 'AllowAutoGameMode' -PropertyType DWord -Value $newValue -Force | Out-Null

        Show-MessageScreen -Title (Get-Text 'TitleGameMode') -Lines @(
            $message
        ) -AccentColor Green
    } catch {
        Show-MessageScreen -Title (Get-Text 'TitleGameMode') -Lines @(
            (Get-Text 'GameModeFailed'),
            $_.Exception.Message
        ) -AccentColor Yellow
    }
}

function Toggle-VerboseLogon {
    try {
        $path = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
        $current = (Get-ItemProperty -Path $path -Name 'verbosestatus' -ErrorAction SilentlyContinue).verbosestatus
        $enabled = if ($null -eq $current) { 0 } else { [int]$current }

        if ($enabled -eq 1) {
            $newValue = 0
            $message = Get-Text 'VerboseOff'
        } else {
            $newValue = 1
            $message = Get-Text 'VerboseOn'
        }

        New-ItemProperty -Path $path -Name 'verbosestatus' -PropertyType DWord -Value $newValue -Force | Out-Null

        Show-MessageScreen -Title (Get-Text 'TitleVerboseLogon') -Lines @(
            $message
        ) -AccentColor Green
    } catch {
        Show-MessageScreen -Title (Get-Text 'TitleVerboseLogon') -Lines @(
            (Get-Text 'VerboseFailed'),
            $_.Exception.Message
        ) -AccentColor Yellow
    }
}

function Toggle-WindowsErrorReporting {
    try {
        $path = 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting'
        if (-not (Test-Path $path)) {
            New-Item -Path $path -Force | Out-Null
        }

        $current = (Get-ItemProperty -Path $path -Name 'Disabled' -ErrorAction SilentlyContinue).Disabled
        $disabled = if ($null -eq $current) { 0 } else { [int]$current }

        if ($disabled -eq 1) {
            $newValue = 0
            $message = Get-Text 'WerOn'
        } else {
            $newValue = 1
            $message = Get-Text 'WerOff'
        }

        New-ItemProperty -Path $path -Name 'Disabled' -PropertyType DWord -Value $newValue -Force | Out-Null

        Show-MessageScreen -Title (Get-Text 'TitleWer') -Lines @(
            $message
        ) -AccentColor Green
    } catch {
        Show-MessageScreen -Title (Get-Text 'TitleWer') -Lines @(
            (Get-Text 'WerFailed'),
            $_.Exception.Message
        ) -AccentColor Yellow
    }
}

function Toggle-FileExtensions {
    try {
        $path = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
        $current = (Get-ItemProperty -Path $path -Name 'HideFileExt' -ErrorAction SilentlyContinue).HideFileExt
        $hidden = if ($null -eq $current) { 1 } else { [int]$current }

        if ($hidden -eq 1) {
            $newValue = 0
            $message = Get-Text 'FileExtensionsOn'
        } else {
            $newValue = 1
            $message = Get-Text 'FileExtensionsOff'
        }

        New-ItemProperty -Path $path -Name 'HideFileExt' -PropertyType DWord -Value $newValue -Force | Out-Null

        Show-MessageScreen -Title (Get-Text 'TitleFileExtensions') -Lines @(
            $message
        ) -AccentColor Green
    } catch {
        Show-MessageScreen -Title (Get-Text 'TitleFileExtensions') -Lines @(
            (Get-Text 'FileExtensionsFailed'),
            $_.Exception.Message
        ) -AccentColor Yellow
    }
}

function Toggle-VisualEffects {
    try {
        $path = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects'
        if (-not (Test-Path $path)) {
            New-Item -Path $path -Force | Out-Null
        }

        $current = (Get-ItemProperty -Path $path -Name 'VisualFXSetting' -ErrorAction SilentlyContinue).VisualFXSetting
        $mode = if ($null -eq $current) { 0 } else { [int]$current }

        if ($mode -eq 2) {
            $newValue = 1
            $message = Get-Text 'VisualEffectsAppearance'
        } else {
            $newValue = 2
            $message = Get-Text 'VisualEffectsPerformance'
        }

        New-ItemProperty -Path $path -Name 'VisualFXSetting' -PropertyType DWord -Value $newValue -Force | Out-Null

        Show-MessageScreen -Title (Get-Text 'TitleVisualEffects') -Lines @(
            $message
        ) -AccentColor Green
    } catch {
        Show-MessageScreen -Title (Get-Text 'TitleVisualEffects') -Lines @(
            (Get-Text 'VisualEffectsFailed'),
            $_.Exception.Message
        ) -AccentColor Yellow
    }
}

function Toggle-ExplorerLaunchTarget {
    try {
        $path = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
        $current = (Get-ItemProperty -Path $path -Name 'LaunchTo' -ErrorAction SilentlyContinue).LaunchTo
        $mode = if ($null -eq $current) { 2 } else { [int]$current }

        if ($mode -eq 1) {
            $newValue = 2
            $message = Get-Text 'ExplorerLaunchHome'
        } else {
            $newValue = 1
            $message = Get-Text 'ExplorerLaunchThisPc'
        }

        New-ItemProperty -Path $path -Name 'LaunchTo' -PropertyType DWord -Value $newValue -Force | Out-Null

        Show-MessageScreen -Title (Get-Text 'TitleExplorerLaunch') -Lines @(
            $message
        ) -AccentColor Green
    } catch {
        Show-MessageScreen -Title (Get-Text 'TitleExplorerLaunch') -Lines @(
            (Get-Text 'ExplorerLaunchFailed'),
            $_.Exception.Message
        ) -AccentColor Yellow
    }
}

function Show-SettingsMenu {
    while ($true) {
        $items = @(
            (Get-Text 'Settings1'),
            (Get-Text 'Settings2'),
            (Get-Text 'Settings3'),
            (Get-Text 'Settings4'),
            (Get-Text 'Settings5'),
            (Get-Text 'Settings6'),
            (Get-Text 'Settings7'),
            (Get-Text 'Settings8'),
            (Get-Text 'Settings9'),
            (Get-Text 'SettingsA'),
            (Get-Text 'SettingsB'),
            (Get-Text 'SettingsC'),
            (Get-Text 'SettingsD'),
            (Get-Text 'SettingsE'),
            '',
            (Get-Text 'SettingsBack')
        )

        Write-MenuFrame -Header (Get-Text 'SettingsMenu') -Items $items -Prompt (Get-Text 'SettingsPrompt')
        $choice = (Read-Host).Trim().ToUpperInvariant()
        if ($choice -eq '9') {
            Show-Page2Menu
            continue
        }
        if ($choice -eq '9') {
            Show-DebloatPanel
            continue
        }
        if ($choice -notin @('0','1','2','3','4','5','6','7','8','9')) {
            continue
        }

        switch ($choice) {
            '1' { Enable-UltimatePowerPlan }
            '2' { Disable-StickyKeysHotkey }
            '3' { Clear-TempFiles }
            '4' { Disable-TelemetryAndAds }
            '5' { Remove-WindowsCopilot }
            '6' { Toggle-ClassicContextMenu }
            '7' { Toggle-DarkTheme }
            '8' { Toggle-GameMode }
            '9' { Toggle-VerboseLogon }
            'A' { Toggle-WindowsErrorReporting }
            'B' { Toggle-FileExtensions }
            'C' { Toggle-VisualEffects }
            'D' { Toggle-ExplorerLaunchTarget }
            'E' { Open-CopilotStorePage }
            '0' { return }
            default { }
        }
    }
}

function Show-PCDetails {
    try {
        $cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
        $gpuObjects = Get-CimInstance Win32_VideoController | Where-Object {
            $_.Name -and
            $_.Name -notmatch 'Virtual|Meta|Remote|Basic Render|Software|Mirror|Indirect|Hyper-V'
        }
        if (-not $gpuObjects) {
            $gpuObjects = Get-CimInstance Win32_VideoController | Where-Object { $_.Name }
        }
        $computer = Get-CimInstance Win32_ComputerSystem
        $os = Get-CimInstance Win32_OperatingSystem
        $bios = Get-CimInstance Win32_BIOS | Select-Object -First 1
        $board = Get-CimInstance Win32_BaseBoard | Select-Object -First 1
        $disks = Get-CimInstance Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 }
        $mainGpu = $gpuObjects | Select-Object -First 1
        $resolution = if ($mainGpu.CurrentHorizontalResolution -and $mainGpu.CurrentVerticalResolution) {
            "$($mainGpu.CurrentHorizontalResolution)x$($mainGpu.CurrentVerticalResolution)"
        } else {
            'Unknown'
        }
        $buildText = $os.BuildNumber
        $displayVersion = $null
        try {
            $cv = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
            $displayVersion = if ($cv.DisplayVersion) { $cv.DisplayVersion } elseif ($cv.ReleaseId) { $cv.ReleaseId } else { $null }
            if ($displayVersion) {
                $buildText = "$($os.BuildNumber) / $displayVersion"
            }
        } catch {
        }

        $totalRamGb = [Math]::Round($computer.TotalPhysicalMemory / 1GB, 2)
        $lines = @(
            "$((Get-Text 'LabelPcName')): $($computer.Name)",
            "$((Get-Text 'LabelOs')): $($os.Caption)",
            "$((Get-Text 'LabelVersion')): $($os.Version)",
            "$((Get-Text 'LabelUpdateBuild')): $buildText",
            "$((Get-Text 'LabelMotherboard')): $($board.Manufacturer) $($board.Product)",
            "$((Get-Text 'LabelBios')): $($bios.Manufacturer) $($bios.SMBIOSBIOSVersion)",
            "$((Get-Text 'LabelCpu')): $($cpu.Name)",
            "$((Get-Text 'LabelCpuThreads')): $($cpu.NumberOfCores) / $($cpu.NumberOfLogicalProcessors)",
            "$((Get-Text 'LabelRam')): $totalRamGb GB",
            "$((Get-Text 'LabelGpu')): $(($gpuObjects | Select-Object -ExpandProperty Name) -join ', ')",
            "$((Get-Text 'LabelGpuDriver')): $($mainGpu.DriverVersion)",
            "$((Get-Text 'LabelResolution')): $resolution",
            "$((Get-Text 'LabelUpdatePause')): $(Get-UpdatePauseSummary)"
        )

        foreach ($disk in $disks) {
            $sizeGb = [Math]::Round($disk.Size / 1GB, 2)
            $freeGb = [Math]::Round($disk.FreeSpace / 1GB, 2)
            $diskLabel = [string]::Format((Get-Text 'LabelDisk'), $disk.DeviceID)
            if ($script:Language -eq 'hu') {
                $lines += "${diskLabel}: $sizeGb GB ${oAc}sszesen / $freeGb GB szabad"
            } else {
                $lines += "${diskLabel}: $sizeGb GB total / $freeGb GB free"
            }
        }

        Show-MessageScreen -Title (Get-Text 'TitlePcDetails') -Lines $lines -AccentColor Cyan
    } catch {
        Show-MessageScreen -Title (Get-Text 'TitlePcDetails') -Lines @(
            (Get-Text 'PcDetailsError'),
            $_.Exception.Message
        ) -AccentColor Yellow
    }
}

function Restart-ComputerNormal {
    try {
        shutdown.exe /r /t 0
        Show-MessageScreen -Title (Get-Text 'TitleReboot') -Lines @(
            (Get-Text 'RebootQueued')
        ) -AccentColor Green
    } catch {
        Show-MessageScreen -Title (Get-Text 'TitleReboot') -Lines @(
            (Get-Text 'RebootFailed'),
            $_.Exception.Message
        ) -AccentColor Yellow
    }
}

function Restart-ToUefi {
    try {
        shutdown.exe /r /fw /t 0
        Show-MessageScreen -Title (Get-Text 'TitleUefi') -Lines @(
            (Get-Text 'UefiQueued')
        ) -AccentColor Green
    } catch {
        Show-MessageScreen -Title (Get-Text 'TitleUefi') -Lines @(
            (Get-Text 'UefiFailed'),
            $_.Exception.Message
        ) -AccentColor Yellow
    }
}

function Open-PowerButtonSettings {
    try {
        Start-Process 'control.exe' -ArgumentList '/name Microsoft.PowerOptions /page pageGlobalSettings'
        Show-MessageScreen -Title (Get-Text 'TitlePowerSettings') -Lines @(
            (Get-Text 'PowerSettingsOpened')
        ) -AccentColor Green
    } catch {
        Show-MessageScreen -Title (Get-Text 'TitlePowerSettings') -Lines @(
            (Get-Text 'PowerSettingsFailed'),
            $_.Exception.Message
        ) -AccentColor Yellow
    }
}

function Show-PowerToolsMenu {
    while ($true) {
        $items = @(
            (Get-Text 'Power1'),
            (Get-Text 'Power2'),
            (Get-Text 'Power3'),
            '',
            (Get-Text 'PowerBack')
        )

        Write-MenuFrame -Header (Get-Text 'PowerMenu') -Items $items -Prompt (Get-Text 'PowerPrompt')
        $choice = (Read-Host).Trim().ToUpperInvariant()

        switch ($choice) {
            '1' { Restart-ComputerNormal }
            '2' { Restart-ToUefi }
            '3' { Open-PowerButtonSettings }
            '0' { return }
            default { }
        }
    }
}

function Start-DummyAdminWindow {
    $masscommand = @'
    irm https://get.activated.win/ | iex
Write-Host "MASSGRAVE" -ForegroundColor Green
Write-Host ""
Write-Host "Original Massgrave command." -ForegroundColor Gray
Pause
'@

    $encodedCommand = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($masscommand))

    try {
        Start-Process -FilePath 'powershell.exe' -Verb RunAs -ArgumentList @(
            '-NoExit',
            '-EncodedCommand',
            $encodedCommand
        )

        Show-MessageScreen -Title (Get-Text 'TitleMassgrave') -Lines @(
            (Get-Text 'DummyOpened'),
            (Get-Text 'DummyRunning')
        ) -AccentColor Green
    } catch {
        Show-MessageScreen -Title (Get-Text 'TitleMassgrave') -Lines @(
            (Get-Text 'DummyOpenFailed'),
            $_.Exception.Message
        ) -AccentColor Yellow
    }
}

function Start-NoxLab {
    while ($true) {
        $items = @(
            (Get-Text 'Option1'),
            (Get-Text 'Option2'),
            (Get-Text 'Option3'),
            (Get-Text 'Option4'),
            (Get-Text 'Option5'),
            (Get-Text 'Option6'),
            (Get-Text 'Option7'),
            (Get-Text 'Option8'),
            '[9] Page 2',
            'GitHub: github.com/noxian0  |  Discord: noxian_',
            (Get-Text 'Exit')
        )

        Write-MenuFrame -Header (Get-Text 'MainMenu') -Items $items -Prompt 'Choose a menu option using your keyboard [1,2,3,4,5,6,7,8,9,0]'
        $choice = (Read-Host).Trim().ToUpperInvariant()

        switch ($choice) {
            '1' { Start-DummyAdminWindow }
            '2' { Show-WindowsLicenseStatus }
            '3' { Install-WindowsProductKey }
            '4' { Set-WindowsUpdatePause }
            '5' { Resume-WindowsUpdates }
            '6' { Show-PCDetails }
            '7' { Show-SettingsMenu }
            '8' { Show-PowerToolsMenu }
            '0' { exit }
            default { }
        }
    }
}

function Select-Language {
    while ($true) {
        $items = @(
            '[1] English',
            '[2] Magyar',
            "    Csak Cascadia vagy Consolas fonttal jelennek meg helyesen a karakterek.",
            '',
            '[0] Exit'
        )

        Write-MenuFrame -Header 'Language Selection' -Items $items -Prompt 'Choose language [1,2,0]'
        $choice = (Read-Host).Trim().ToUpperInvariant()

        switch ($choice) {
            '1' {
                $script:Language = 'en'
                return
            }
            '2' {
                $script:Language = 'hu'
                return
            }
            '0' { exit }
            default { }
        }
    }
}

function Select-Language {
    while ($true) {
        $innerWidth = 92
        $top = '  .' + ('=' * $innerWidth) + '.'
        $mid = '  |' + (' ' * $innerWidth) + '|'
        $bottom = "  '" + ('=' * $innerWidth) + "'"
        $titleText = ' Language Selection '
        $titlePad = [Math]::Max(0, [Math]::Floor(($innerWidth - $titleText.Length) / 2))
        $titleLine = '  |' + (' ' * $titlePad) + $titleText + (' ' * ($innerWidth - $titlePad - $titleText.Length)) + '|'

        Write-Banner
        Write-Host $top -ForegroundColor DarkGray
        Write-Host $mid -ForegroundColor DarkGray
        Write-Host $titleLine -ForegroundColor White
        Write-Host $mid -ForegroundColor DarkGray
        Write-FramedLine -Text '>> [1] English' -Color White -Width $innerWidth
        Write-Host $mid -ForegroundColor DarkGray
        Write-FramedLine -Text '>> [2] Magyar' -Color White -Width $innerWidth
        Write-FramedLine -Text '   Csak Cascadia vagy Consolas fonttal jelennek meg helyesen a karakterek..' -Color Cyan -Width $innerWidth
        Write-Host $mid -ForegroundColor DarkGray
        Write-FramedLine -Text '>> [0] Exit' -Color White -Width $innerWidth
        Write-Host $mid -ForegroundColor DarkGray
        Write-Host $bottom -ForegroundColor DarkGray
        Write-Host ''
        Write-Host '  Choose language [1,2,0]: ' -ForegroundColor Green -NoNewline
        $choice = (Read-Host).Trim().ToUpperInvariant()

        switch ($choice) {
            '1' {
                $script:Language = 'en'
                return
            }
            '2' {
                $script:Language = 'hu'
                return
            }
            '0' { exit }
            default { }
        }
    }
}

function Get-DebloatApps {
    @(
        @{ Key = '1'; Name = 'Microsoft Store'; Package = 'Microsoft.WindowsStore'; StoreId = '9WZDNCRFJBMP' }
        @{ Key = '2'; Name = 'Xbox'; Package = 'Microsoft.Xbox'; StoreId = '9MV0B5HZVK9Z' }
        @{ Key = '3'; Name = 'Xbox TCUI'; Package = 'Microsoft.Xbox.TCUI'; StoreId = '9NKNC0LD5NN6' }
        @{ Key = '4'; Name = 'Phone Link'; Package = 'Microsoft.YourPhone'; StoreId = '9NMPJ99VJBWV' }
        @{ Key = '5'; Name = 'Clipchamp'; Package = 'Clipchamp.Clipchamp'; StoreId = '9P1J8S7CCWWT' }
        @{ Key = '6'; Name = 'Windows Maps'; Package = 'Microsoft.WindowsMaps'; StoreId = '9WZDNCRDTBVB' }
        @{ Key = '7'; Name = 'Solitaire'; Package = 'Microsoft.MicrosoftSolitaireCollection'; StoreId = '9WZDNCRFHWD2' }
        @{ Key = '8'; Name = 'Movies and TV'; Package = 'Microsoft.ZuneVideo'; StoreId = '9WZDNCRFJ3P2' }
        @{ Key = '9'; Name = 'Groove Music'; Package = 'Microsoft.ZuneMusic'; StoreId = '9WZDNCRFJ3PT' }
        @{ Key = 'A'; Name = 'Feedback Hub'; Package = 'Microsoft.WindowsFeedbackHub'; StoreId = '9NBLGGH4R32N' }
        @{ Key = 'B'; Name = 'Microsoft 3D Viewer'; Package = 'Microsoft.Microsoft3DViewer'; StoreId = '9NBLGGH42THS' }
        @{ Key = 'C'; Name = 'Paint 3D'; Package = 'Microsoft.MSPaint'; StoreId = '9NBLGGH5FV99' }
        @{ Key = 'D'; Name = 'News'; Package = 'Microsoft.BingNews'; StoreId = '9WZDNCRFHVFW' }
        @{ Key = 'E'; Name = 'Weather'; Package = 'Microsoft.BingWeather'; StoreId = '9WZDNCRFJ3Q2' }
    )
}

function Invoke-DebloatRemoval {
    param(
        [array]$SelectedApps
    )

    $results = @()
    foreach ($app in $SelectedApps) {
        try {
            $packages = Get-AppxPackage -AllUsers | Where-Object { $_.Name -like "*$($app.Package)*" }
            if (-not $packages) {
                $results += "$($app.Name): not installed."
                continue
            }

            foreach ($package in $packages) {
                Remove-AppxPackage -Package $package.PackageFullName -AllUsers -ErrorAction SilentlyContinue
            }

            $results += "$($app.Name): removal command sent."
        } catch {
            $results += "$($app.Name): $($_.Exception.Message)"
        }
    }

    Show-MessageScreen -Title 'Debloat Remove Results' -Lines $results -AccentColor Yellow
}

function Invoke-DebloatReinstall {
    param(
        [array]$SelectedApps
    )

    $results = @()
    foreach ($app in $SelectedApps) {
        try {
            Start-Process "ms-windows-store://pdp/?productid=$($app.StoreId)"
            $results += "$($app.Name): Microsoft Store page opened."
        } catch {
            $results += "$($app.Name): $($_.Exception.Message)"
        }
    }

    Show-MessageScreen -Title 'Debloat Reinstall Results' -Lines $results -AccentColor Green
}

$script:aAc  = [char]225
$script:eAc  = [char]233
$script:iAc  = [char]237
$script:oAc  = [char]243
$script:uAc  = [char]250
$script:oUm  = [char]246
$script:uUm  = [char]252
$script:oDbl = [char]337
$script:uDbl = [char]369

function Show-DebloatSelectionScreen {
    param(
        [string]$Mode
    )

    $apps = Get-DebloatApps
    $items = @()
    foreach ($app in $apps) {
        $items += "[$($app.Key)] $($app.Name)"
    }
    $items += ''
    $items += '[0] Back'

    if ($script:Language -eq 'hu') {
        $title = if ($Mode -eq 'remove') { 'Debloat Eltavolitas' } else { 'Debloat Ujratelepites' }
        $prompt = if ($Mode -eq 'remove') { "Add meg az elt${aAc}vol${iAc}tand${oAc} appokat (p${eAc}lda: 1,4,7)" } else { "Add meg az ujratelepitando appokat (pelda: 1,4,7)" }
    } else {
        $title = if ($Mode -eq 'remove') { 'Debloat Remove' } else { 'Debloat Reinstall' }
        $prompt = if ($Mode -eq 'remove') { 'Enter app keys to remove (example: 1,4,7)' } else { 'Enter app keys to reinstall (example: 1,4,7)' }
    }

    Write-MenuFrame -Header $title -Items $items -Prompt $prompt
    $raw = (Read-Host).Trim().ToUpperInvariant()
    if ($raw -eq '0' -or [string]::IsNullOrWhiteSpace($raw)) {
        return
    }

    $keys = $raw -split '[, ]+' | Where-Object { $_ }
    $selected = @($apps | Where-Object { $keys -contains $_.Key })
    if (-not $selected) {
        if ($script:Language -eq 'hu') {
            Show-MessageScreen -Title $title -Lines @('Nem adtal meg ervenyes alkalmazas valasztast.') -AccentColor Yellow
        } else {
            Show-MessageScreen -Title $title -Lines @('No valid app selection was entered.') -AccentColor Yellow
        }
        return
    }

    if ($Mode -eq 'remove') {
        Invoke-DebloatRemoval -SelectedApps $selected
    } else {
        Invoke-DebloatReinstall -SelectedApps $selected
    }
}

function Show-DebloatPanel {
    while ($true) {
        if ($script:Language -eq 'hu') {
            $items = @(
                "[1] Kijel${oUm}lt appok t${oUm}rl${eAc}se         - v${aAC}laszd ki mit t${oUm}r${oUm}lj${uUm}nk",
                "[2] Kijel${oUm}lt appok ${uAc}jratelep${iAc}t${eAc}se  - v${aAC}laszd ki mit ${aAc}ll${iAc}tsunk vissza",
                '',
                '[0] Vissza'
            )
            Write-MenuFrame -Header 'Debloat Panel' -Items $items -Prompt 'Valassz [1,2,0]'
        } else {
            $items = @(
                '[1] Remove Selected Apps           - choose what to uninstall',
                '[2] Reinstall Selected Apps        - choose what to restore',
                '',
                '[0] Back'
            )
            Write-MenuFrame -Header 'Debloat Panel' -Items $items -Prompt 'Choose [1,2,0]'
        }

        $choice = (Read-Host).Trim().ToUpperInvariant()

        switch ($choice) {
            '1' { Show-DebloatSelectionScreen -Mode 'remove' }
            '2' { Show-DebloatSelectionScreen -Mode 'reinstall' }
            '0' { return }
            default { }
        }
    }
}

function Show-Page2Menu {
    while ($true) {
        if ($script:Language -eq 'hu') {
            $items = @(
                "[1] Debloat Panel                  - alkalmaz${aAc}sok t${oUm}rl${eAc}se vagy ${uAc}jratelep${iAc}t${eAc}se",
                '',
                '[0] Vissza'
            )
            Write-MenuFrame -Header '2. oldal' -Items $items -Prompt "V${aAc}lassz [1,0]"
        } else {
            $items = @(
                '[1] Debloat Panel                  - remove or reinstall selected apps',
                '',
                '[0] Back'
            )
            Write-MenuFrame -Header 'Page 2' -Items $items -Prompt 'Choose [1,0]'
        }
        $choice = (Read-Host).Trim().ToUpperInvariant()

        switch ($choice) {
            '1' { Show-DebloatPanel }
            '0' { return }
            default { }
        }
    }
}

function Start-NoxLab {
    while ($true) {
        $option9 = if ($script:Language -eq 'hu') { '[9] 2. oldal' } else { '[9] Page 2' }
        $items = @(
            (Get-Text 'Option1'),
            (Get-Text 'Option2'),
            (Get-Text 'Option3'),
            (Get-Text 'Option4'),
            (Get-Text 'Option5'),
            (Get-Text 'Option6'),
            (Get-Text 'Option7'),
            (Get-Text 'Option8'),
            $option9,
            'GitHub: github.com/noxian0  |  Discord: noxian_',
            (Get-Text 'Exit')
        )

        $promptText = if ($script:Language -eq 'hu') {
            "Val${aAc}ssz men${uUm}pontot a billenty${uDbl}zettel [1,2,3,4,5,6,7,8,9,0]"
        } else {
            'Choose a menu option using your keyboard [1,2,3,4,5,6,7,8,9,0]'
        }
        Write-MenuFrame -Header (Get-Text 'MainMenu') -Items $items -Prompt $promptText
        $choice = (Read-Host).Trim().ToUpperInvariant()

        switch ($choice) {
            '1' { Start-DummyAdminWindow }
            '2' { Show-WindowsLicenseStatus }
            '3' { Activate-WindowsByProductKey }
            '4' { Pause-WindowsUpdates }
            '5' { Resume-WindowsUpdates }
            '6' { Show-PCDetails }
            '7' { Show-SettingsMenu }
            '8' { Show-PowerToolsMenu }
            '9' { Show-Page2Menu }
            '0' { return }
            default { }
        }
    }
}

function Show-DebloatSelectionScreen {
    param(
        [string]$Mode
    )

    $apps = Get-DebloatApps
    $items = @()
    foreach ($app in $apps) {
        $items += "[$($app.Key)] $($app.Name)"
    }
    $items += ''
    $items += '[0] Back'

    if ($script:Language -eq 'hu') {
        $title = if ($Mode -eq 'remove') { "Debloat Elt${aAc}vol${iAc}t${aAc}s" } else { "Debloat ${uAc}jratelep${iAc}t${eAc}s" }
        $prompt = if ($Mode -eq 'remove') { "Add meg az elt${aAc}vol${iAc}tand${oAc} appokat (p${eAc}lda: 1,4,7)" } else { "Add meg az ${uAc}jratelep${iAc}tend${oAc} appokat (p${eAc}lda: 1,4,7)" }
    } else {
        $title = if ($Mode -eq 'remove') { 'Debloat Remove' } else { 'Debloat Reinstall' }
        $prompt = if ($Mode -eq 'remove') { 'Enter app keys to remove (example: 1,4,7)' } else { 'Enter app keys to reinstall (example: 1,4,7)' }
    }

    Write-MenuFrame -Header $title -Items $items -Prompt $prompt
    $raw = (Read-Host).Trim().ToUpperInvariant()
    if ($raw -eq '0' -or [string]::IsNullOrWhiteSpace($raw)) {
        return
    }

    $keys = $raw -split '[, ]+' | Where-Object { $_ }
    $selected = @($apps | Where-Object { $keys -contains $_.Key })
    if (-not $selected) {
        if ($script:Language -eq 'hu') {
            Show-MessageScreen -Title $title -Lines @("Nem adt${aAc}l meg ${eAc}rv${eAc}nyes alkalmaz${aAc}s v${aAc}laszt${aAc}st.") -AccentColor Yellow
        } else {
            Show-MessageScreen -Title $title -Lines @('No valid app selection was entered.') -AccentColor Yellow
        }
        return
    }

    if ($Mode -eq 'remove') {
        Invoke-DebloatRemoval -SelectedApps $selected
    } else {
        Invoke-DebloatReinstall -SelectedApps $selected
    }
}

function Show-DebloatPanel {
    while ($true) {
        if ($script:Language -eq 'hu') {
            $items = @(
                "[1] Kijel${oUm}lt appok t${oUm}rl${eAc}se         - v${aAc}laszd ki mit t${oUm}r${oUm}lj${uUm}nk",
                "[2] Kijel${oUm}lt appok ${uAc}jratelep${iAc}t${eAc}se  - v${aAc}laszd ki mit ${aAc}ll${iAc}tsunk vissza",
                '',
                '[0] Vissza'
            )
            Write-MenuFrame -Header 'Debloat Panel' -Items $items -Prompt "V${aAc}lassz [1,2,0]"
        } else {
            $items = @(
                '[1] Remove Selected Apps           - choose what to uninstall',
                '[2] Reinstall Selected Apps        - choose what to restore',
                '',
                '[0] Back'
            )
            Write-MenuFrame -Header 'Debloat Panel' -Items $items -Prompt 'Choose [1,2,0]'
        }

        $choice = (Read-Host).Trim().ToUpperInvariant()

        switch ($choice) {
            '1' { Show-DebloatSelectionScreen -Mode 'remove' }
            '2' { Show-DebloatSelectionScreen -Mode 'reinstall' }
            '0' { return }
            default { }
        }
    }
}

function Show-Page2Menu {
    while ($true) {
        if ($script:Language -eq 'hu') {
            $items = @(
                "[1] Debloat Panel                  - alkalmaz${aAc}sok t${oUm}rl${eAc}se vagy ${uAc}jratelep${iAc}t${eAc}se",
                '',
                '[0] Vissza'
            )
            Write-MenuFrame -Header '2. oldal' -Items $items -Prompt "V${aAc}lassz [1,0]"
        } else {
            $items = @(
                '[1] Debloat Panel                  - remove or reinstall selected apps',
                '',
                '[0] Back'
            )
            Write-MenuFrame -Header 'Page 2' -Items $items -Prompt 'Choose [1,0]'
        }

        $choice = (Read-Host).Trim().ToUpperInvariant()

        switch ($choice) {
            '1' { Show-DebloatPanel }
            '0' { return }
            default { }
        }
    }
}

function Start-NoxLab {
    while ($true) {
        $option9 = if ($script:Language -eq 'hu') { '[9] 2. oldal' } else { '[9] Page 2' }
        $promptText = if ($script:Language -eq 'hu') {
            "V${aAc}lassz men${uUm}pontot a billenty${uDbl}zettel [1,2,3,4,5,6,7,8,9,0]"
        } else {
            'Choose a menu option using your keyboard [1,2,3,4,5,6,7,8,9,0]'
        }

        $items = @(
            (Get-Text 'Option1'),
            (Get-Text 'Option2'),
            (Get-Text 'Option3'),
            (Get-Text 'Option4'),
            (Get-Text 'Option5'),
            (Get-Text 'Option6'),
            (Get-Text 'Option7'),
            (Get-Text 'Option8'),
            $option9,
            'GitHub: github.com/noxian0  |  Discord: noxian_',
            (Get-Text 'Exit')
        )

        Write-MenuFrame -Header (Get-Text 'MainMenu') -Items $items -Prompt $promptText
        $choice = (Read-Host).Trim().ToUpperInvariant()

        switch ($choice) {
            '1' { Start-DummyAdminWindow }
            '2' { Show-WindowsLicenseStatus }
            '3' { Activate-WindowsByProductKey }
            '4' { Pause-WindowsUpdates }
            '5' { Resume-WindowsUpdates }
            '6' { Show-PCDetails }
            '7' { Show-SettingsMenu }
            '8' { Show-PowerToolsMenu }
            '9' { Show-Page2Menu }
            '0' { return }
            default { }
        }
    }
}

function Test-IsAdministrator {
    try {
        $currentIdentity = [Security.Principal.WindowsIdentity]::GetCurrent()
        $principal = New-Object Security.Principal.WindowsPrincipal($currentIdentity)
        return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    } catch {
        return $false
    }
}

function Invoke-DebloatRemoval {
    param(
        [array]$SelectedApps
    )

    if (-not (Test-IsAdministrator)) {
        if ($script:Language -eq 'hu') {
            Show-MessageScreen -Title 'Debloat Panel' -Lines @(
                'Ehhez a muvelethez rendszergazdai jogosultsag kell.',
                'Inditsd a NoxLabot rendszergazdakent, majd probald ujra.'
            ) -AccentColor Yellow
        } else {
            Show-MessageScreen -Title 'Debloat Panel' -Lines @(
                'This action requires administrator privileges.',
                'Start NoxLab as administrator and try again.'
            ) -AccentColor Yellow
        }
        return
    }

    $results = @()
    foreach ($app in $SelectedApps) {
        $hadAction = $false

        try {
            $packages = Get-AppxPackage -AllUsers | Where-Object { $_.Name -like "*$($app.Package)*" }
            foreach ($package in $packages) {
                try {
                    Remove-AppxPackage -Package $package.PackageFullName -AllUsers -ErrorAction Stop
                    $hadAction = $true
                } catch {
                    $results += "$($app.Name): installed package removal failed - $($_.Exception.Message)"
                }
            }
        } catch {
            $results += "$($app.Name): package lookup failed - $($_.Exception.Message)"
        }

        try {
            $provisioned = Get-AppxProvisionedPackage -Online | Where-Object {
                $_.DisplayName -like "*$($app.Package)*"
            }
            foreach ($prov in $provisioned) {
                try {
                    Remove-AppxProvisionedPackage -Online -PackageName $prov.PackageName -ErrorAction Stop | Out-Null
                    $hadAction = $true
                } catch {
                    $results += "$($app.Name): provisioned package removal failed - $($_.Exception.Message)"
                }
            }
        } catch {
            $results += "$($app.Name): provisioned package lookup failed - $($_.Exception.Message)"
        }

        if ($hadAction) {
            $results += "$($app.Name): removal command completed."
        } elseif (-not ($results | Where-Object { $_ -like "$($app.Name):*" })) {
            $results += "$($app.Name): nothing matched on this system."
        }
    }

    if (-not $results) {
        $results = @('No actions were performed.')
    }

    Show-MessageScreen -Title 'Debloat Remove Results' -Lines $results -AccentColor Yellow
}

function Open-LatestGpuDriverPage {
    try {
        $gpu = Get-CimInstance Win32_VideoController | Where-Object {
            $_.Name -and
            $_.Name -notmatch 'Microsoft Basic|Remote Display|RDP|Hyper-V|Virtual|VMware|VirtualBox|Citrix|Parsec|Mirage'
        } | Select-Object -First 1

        if (-not $gpu) {
            if ($script:Language -eq 'hu') {
                Show-MessageScreen -Title 'GPU Driver' -Lines @(
                    'Nem talaltam tamogatott fizikai videokartyat.',
                    'Probald meg kezzel megnyitni a gyarto oldalat.'
                ) -AccentColor Yellow
            } else {
                Show-MessageScreen -Title 'GPU Driver' -Lines @(
                    'No supported physical GPU was detected.',
                    'Please open your GPU vendor support page manually.'
                ) -AccentColor Yellow
            }
            return
        }

        $gpuName = $gpu.Name
        if ($gpuName -match 'NVIDIA') {
            Start-Process 'https://www.nvidia.com/Download/index.aspx'
            if ($script:Language -eq 'hu') {
                Show-MessageScreen -Title 'GPU Driver' -Lines @(
                    "Detektalt GPU: $gpuName",
                    "Megnyitottam az NVIDIA driver oldal${aAc}t."
                ) -AccentColor Green
            } else {
                Show-MessageScreen -Title 'GPU Driver' -Lines @(
                    "Detected GPU: $gpuName",
                    'Opened the NVIDIA driver page.'
                ) -AccentColor Green
            }
            return
        }

        if ($gpuName -match 'AMD|Radeon') {
            Start-Process 'https://www.amd.com/en/support/download/drivers.html'
            if ($script:Language -eq 'hu') {
                Show-MessageScreen -Title 'GPU Driver' -Lines @(
                    "Detektalt GPU: $gpuName",
                    "Megnyitottam az AMD driver oldal${aAc}t."
                ) -AccentColor Green
            } else {
                Show-MessageScreen -Title 'GPU Driver' -Lines @(
                    "Detected GPU: $gpuName",
                    'Opened the AMD driver page.'
                ) -AccentColor Green
            }
            return
        }

        if ($gpuName -match 'Intel') {
            Start-Process 'https://www.intel.com/content/www/us/en/download-center/home.html'
            if ($script:Language -eq 'hu') {
                Show-MessageScreen -Title 'GPU Driver' -Lines @(
                    "Detektalt GPU: $gpuName",
                    "Megnyitottam az Intel driver oldal${aAc}t."
                ) -AccentColor Green
            } else {
                Show-MessageScreen -Title 'GPU Driver' -Lines @(
                    "Detected GPU: $gpuName",
                    'Opened the Intel driver page.'
                ) -AccentColor Green
            }
            return
        }

        if ($script:Language -eq 'hu') {
            Show-MessageScreen -Title 'GPU Driver' -Lines @(
                "Detektalt GPU: $gpuName",
                "Ehhez a gy${aAc}rt${oAc}hoz nincs k${uUm}l${oUm}n gyorslink be${aAc}llitva."
            ) -AccentColor Yellow
        } else {
            Show-MessageScreen -Title 'GPU Driver' -Lines @(
                "Detected GPU: $gpuName",
                'No quick driver link is configured for this vendor yet.'
            ) -AccentColor Yellow
        }
    } catch {
        Show-MessageScreen -Title 'GPU Driver' -Lines @($_.Exception.Message) -AccentColor Yellow
    }
}

function Show-Page2Menu {
    while ($true) {
        if ($script:Language -eq 'hu') {
            $items = @(
                "[1] Debloat Panel                  - alkalmaz${aAc}sok t${oUm}rl${eAc}se vagy ${uAc}jratelep${iAc}t${eAc}se",
                "[2] GPU driver oldal              - leg${uAc}jabb driver oldal megnyit${aAc}sa",
                '',
                '[0] Vissza'
            )
            Write-MenuFrame -Header '2. oldal' -Items $items -Prompt "V${aAc}lassz [1,2,0]"
        } else {
            $items = @(
                '[1] Debloat Panel                  - remove or reinstall selected apps',
                '[2] GPU Driver Page                - open the latest driver page',
                '',
                '[0] Back'
            )
            Write-MenuFrame -Header 'Page 2' -Items $items -Prompt 'Choose [1,2,0]'
        }

        $choice = (Read-Host).Trim().ToUpperInvariant()

        switch ($choice) {
            '1' { Show-DebloatPanel }
            '2' { Open-LatestGpuDriverPage }
            '0' { return }
            default { }
        }
    }
}

Set-ConsoleLayout
Set-ConsoleScreenPosition
Disable-ConsoleSelection
Show-IntroAnimation
Select-Language
Start-NoxLab
exit
