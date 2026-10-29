<# : batch
@echo off
setlocal
set "BOT_PLIK=%~f0"
powershell -NoProfile -STA -Command "iex ([IO.File]::ReadAllText($env:BOT_PLIK))"
echo.
echo  Koniec. To okno zamknie sie za 5 sekund...
rem TYMCZASOWO: okno zostaje otwarte po zatrzymaniu (oryginal: timeout /t 5 >nul)
pause
exit /b
#>

# ---------------------------- USTAWIENIA -----------------------------

# Tempo: 0.25 = 2x szybciej, 0,5 = normalnie, 1 = 2x wolniej (dla wolnej VM)
$Wolno = 0.5

# Ile sekund (razy $Wolno) piosenka gra, zanim bot otworzy kolejne okno
$CzasGrania = 1

# Lista piosenek. Id = kod z linku youtube.com/watch?v=KOD
# Mozesz dopisac wlasna z Id = '' - wtedy bot sam ja wyszuka po tytule.
$Piosenki = @(
    @{ Tytul = 'KlejNuty - Bende Go Zjad!';                    Id = 'w_f0WrvTIk8' }
    @{ Tytul = 'Rick Astley - Never Gonna Give You Up';    	   Id = 'dQw4w9WgXcQ' }
    @{ Tytul = 'PSY - Gangnam Style';                      	   Id = '9bZkp7q19f0' }
    @{ Tytul = 'Ylvis - The Fox (What Does The Fox Say?)'; 	   Id = 'jofNR_WkoCE' }
    @{ Tytul = 'Darude - Sandstorm';                       	   Id = 'y6120QOlsfU' }
    @{ Tytul = 'a-ha - Take On Me';                        	   Id = 'djV11Xbc914' }
    @{ Tytul = 'Smash Mouth - All Star';                   	   Id = 'L_jWHffIx5E' }
    @{ Tytul = 'Europe - The Final Countdown';             	   Id = '9jK-NcRmVcw' }
    @{ Tytul = 'Toto - Africa';                            	   Id = 'FTQbiNvZqaY' }
    @{ Tytul = 'Slawomir - Milosc w Zakopanem';            	   Id = 'n2hJA78YuWw' }
    @{ Tytul = 'Queen - Bohemian Rhapsody';                	   Id = 'fJ9rUzIMcZQ' }
    @{ Tytul = 'Queen - Don''t Stop Me Now';               	   Id = 'HgzGwKwLmgM' }
    @{ Tytul = 'ABBA - Dancing Queen';                     	   Id = 'xFrGuyw1V8s' }
    @{ Tytul = 'ABBA - Gimme Gimme Gimme';                 	   Id = 'XEjLoHdbVeE' }
    @{ Tytul = 'Journey - Don''t Stop Believin''';         	   Id = 'VcjzHMhBtf0' }
    @{ Tytul = 'Survivor - Eye of the Tiger';              	   Id = 'btPJPFnesV4' }
    @{ Tytul = 'Bon Jovi - Livin'' on a Prayer';           	   Id = 'lDK9QqIzhwk' }
    @{ Tytul = 'Guns N'' Roses - Sweet Child O'' Mine';    	   Id = '1w7OgIMMRc4' }
    @{ Tytul = 'AC/DC - Thunderstruck';                    	   Id = 'v2AC41dglnM' }
    @{ Tytul = 'Michael Jackson - Billie Jean';            	   Id = 'Zi_XLOBDo_Y' }
    @{ Tytul = 'Michael Jackson - Thriller';               	   Id = 'sOnqjkJTMaA' }
    @{ Tytul = 'Village People - YMCA';                    	   Id = 'CS9OO0S5w2k' }
    @{ Tytul = 'Bee Gees - Stayin'' Alive';                	   Id = 'fNFzfwLM72c' }
    @{ Tytul = 'Backstreet Boys - I Want It That Way';     	   Id = '4fndeDfaWCg' }
    @{ Tytul = 'Aqua - Barbie Girl';                       	   Id = 'ZyhrYis509A' }
    @{ Tytul = 'Eiffel 65 - Blue (Da Ba Dee)';             	   Id = '68ugkg9RePc' }
    @{ Tytul = 'Haddaway - What Is Love';                  	   Id = 'HEXWRTEbj1I' }
    @{ Tytul = 'Vengaboys - We Like to Party';             	   Id = '6Zbi0XmGtMw' }
    @{ Tytul = 'Nyan Cat';                                 	   Id = '2yJgwwDcgV8' }
    @{ Tytul = 'ELO - Mr. Blue Sky';                       	   Id = 'aQUlA8Hcv4s' }
    @{ Tytul = 'Lady Gaga - Bad Romance';                  	   Id = 'qrO4YZeyl0I' }
    @{ Tytul = 'Pharrell Williams - Happy';                	   Id = 'ZbZSe6N_BXs' }
    @{ Tytul = 'Mark Ronson - Uptown Funk';                	   Id = 'OPf0YbXqDm0' }
    @{ Tytul = 'Boney M. - Rasputin';                      	   Id = '16y1AkoZkmQ' }
    @{ Tytul = 'Kombi - Slodkiego milego zycia';           	   Id = 'xRHeEQM_Kjw' }
    @{ Tytul = 'Budka Suflera - Jolka, Jolka pamietasz';   	   Id = 'fYKfvvwsoAY' }
    @{ Tytul = 'Perfect - Autobiografia';                  	   Id = '1n0MupX-7AM' }
    @{ Tytul = 'Lady Pank - Mniej niz zero';               	   Id = 'Lc-26SnSmok' }
    @{ Tytul = 'Maanam - Kocham cie kochanie moje';        	   Id = 'nIncb6Gy2js' }
    @{ Tytul = 'Czerwone Gitary - Historia jednej znajomosci'; Id = 't9Y5om7VaPQ' }
    @{ Tytul = 'Akcent - Przez twe oczy zielone';          	   Id = 'cxtnot8lY4U' }
    @{ Tytul = 'Bayer Full - Blondyneczka';                	   Id = 'jsCUudTgA9Q' }
    @{ Tytul = 'Boys - Jestes szalona';                    	   Id = 'c2i4h7Q-8sA' }
    @{ Tytul = 'Kayah - Prawy do lewego';                  	   Id = 'cKF2GjRAUtE' }
    @{ Tytul = 'Myslovitz - Dlugosc dzwieku samotnosci';   	   Id = 'A30Fx3wnfwE' }
    @{ Tytul = 'Dzem - Whisky';                            	   Id = 'Qz4jpBh_UMs' }
    @{ Tytul = 'Kult - Arahja';                            	   Id = '_vw2K0AgFF0' }
    @{ Tytul = 'Edyta Gorniak - To nie ja';                	   Id = 'PL5rmmpiHp8' }
    @{ Tytul = 'Piersi - Balkanica';                       	   Id = 'Pqaxe5o2Apo' }
)

# ------------------------- KONIEC USTAWIEN ---------------------------

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
using System.Threading;
namespace Bot {
    [StructLayout(LayoutKind.Sequential)]
    public struct RECT { public int Left, Top, Right, Bottom; }
    public static class W {
        [DllImport("user32.dll")] public static extern short  GetAsyncKeyState(int vKey);
        [DllImport("user32.dll")] public static extern bool   SetCursorPos(int x, int y);
        [DllImport("user32.dll")] public static extern void   mouse_event(uint flags, int dx, int dy, int data, UIntPtr extra);
        [DllImport("user32.dll")] public static extern void   keybd_event(byte vk, byte scan, uint flags, UIntPtr extra);
        [DllImport("user32.dll")] public static extern IntPtr GetForegroundWindow();
        [DllImport("user32.dll")] public static extern bool   SetForegroundWindow(IntPtr hWnd);
        [DllImport("user32.dll")] public static extern bool   ShowWindow(IntPtr hWnd, int cmd);
        [DllImport("user32.dll")] public static extern bool   IsIconic(IntPtr hWnd);
        [DllImport("user32.dll")] public static extern bool   GetWindowRect(IntPtr hWnd, out RECT r);
        [DllImport("user32.dll")] public static extern uint   GetWindowThreadProcessId(IntPtr hWnd, out uint pid);
        [DllImport("user32.dll")] public static extern uint   GetDpiForWindow(IntPtr hWnd);
        [DllImport("user32.dll")] public static extern bool   SetProcessDPIAware();
        [DllImport("kernel32.dll")] public static extern IntPtr GetStdHandle(int n);
        [DllImport("kernel32.dll")] public static extern bool   GetConsoleMode(IntPtr h, out uint m);
        [DllImport("kernel32.dll")] public static extern bool   SetConsoleMode(IntPtr h, uint m);
    }

    // Odczyt i ustawianie glosnosci systemu (Core Audio) - zeby wrocic do poziomu z poczatku.
    [ComImport, Guid("BCDE0395-E52F-467C-8E3D-C4579291692E")] class MMDeviceEnumeratorCom { }
    [ComImport, Guid("A95664D2-9614-4F35-A746-DE8DB63617E6"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    interface IMMDeviceEnumerator {
        int EnumAudioEndpoints(int flow, int mask, out IntPtr devices);
        int GetDefaultAudioEndpoint(int flow, int role, out IMMDevice device);
    }
    [ComImport, Guid("D666063F-1587-4E43-81F1-B948E807363F"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    interface IMMDevice {
        int Activate(ref Guid iid, int ctx, IntPtr p, [MarshalAs(UnmanagedType.IUnknown)] out object o);
    }
    [ComImport, Guid("5CDF2C82-841E-4546-9722-0CF74078229A"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    interface IAudioEndpointVolume {
        int RegisterControlChangeNotify(IntPtr p);
        int UnregisterControlChangeNotify(IntPtr p);
        int GetChannelCount(out uint n);
        int SetMasterVolumeLevel(float l, ref Guid ctx);
        int SetMasterVolumeLevelScalar(float l, ref Guid ctx);
        int GetMasterVolumeLevel(out float l);
        int GetMasterVolumeLevelScalar(out float l);
    }
    public static class Glosnosc {
        static IAudioEndpointVolume Pobierz() {
            IMMDeviceEnumerator e = (IMMDeviceEnumerator)new MMDeviceEnumeratorCom();
            IMMDevice d; e.GetDefaultAudioEndpoint(0, 1, out d);
            Guid iid = typeof(IAudioEndpointVolume).GUID; object o;
            d.Activate(ref iid, 23, IntPtr.Zero, out o);
            return (IAudioEndpointVolume)o;
        }
        // zwraca 0..1, albo -1 gdy sie nie uda
        public static float Odczytaj() {
            try { float v; Pobierz().GetMasterVolumeLevelScalar(out v); return v; } catch { return -1; }
        }
        public static bool Ustaw(float v) {
            try { Guid g = Guid.Empty; Pobierz().SetMasterVolumeLevelScalar(v, ref g); return true; } catch { return false; }
        }
    }

    // Blokada prawdziwej myszy i klawiatury. Ruchy bota (wstrzykniete) przechodza dalej,
    // DELETE: 1. raz wycisza dzwiek, 2. raz zdejmuje blokade. Ctrl+Alt+Del Windows zawsze przepuszcza.
    public static class Blokada {
        public static volatile bool Stop = false;
        public static volatile bool Wycisz = false;
        static volatile int Nacisniecia = 0;
        delegate IntPtr HookProc(int n, IntPtr w, IntPtr l);
        [StructLayout(LayoutKind.Sequential)]
        struct MSG { public IntPtr hwnd; public uint message; public IntPtr wParam; public IntPtr lParam; public uint time; public int x; public int y; }
        [DllImport("user32.dll")]   static extern IntPtr SetWindowsHookEx(int id, HookProc fn, IntPtr mod, uint thread);
        [DllImport("user32.dll")]   static extern bool   UnhookWindowsHookEx(IntPtr h);
        [DllImport("user32.dll")]   static extern IntPtr CallNextHookEx(IntPtr h, int n, IntPtr w, IntPtr l);
        [DllImport("user32.dll")]   static extern int    GetMessage(out MSG m, IntPtr h, uint min, uint max);
        [DllImport("user32.dll")]   static extern bool   PostThreadMessage(uint thread, uint msg, IntPtr w, IntPtr l);
        [DllImport("kernel32.dll")] static extern uint   GetCurrentThreadId();
        [DllImport("kernel32.dll")] static extern IntPtr GetModuleHandle(string name);
        static HookProc kb = Klawiatura;
        static HookProc ms = Mysz;
        static volatile uint watek = 0;

        public static void Wlacz(int maxSekund) {
            Thread t = new Thread(() => {
                watek = GetCurrentThreadId();
                IntPtr mod = GetModuleHandle(null);
                IntPtr hk = SetWindowsHookEx(13, kb, mod, 0);    // WH_KEYBOARD_LL
                IntPtr hm = SetWindowsHookEx(14, ms, mod, 0);    // WH_MOUSE_LL
                MSG m;
                while (GetMessage(out m, IntPtr.Zero, 0, 0) > 0) { }
                UnhookWindowsHookEx(hk);
                UnhookWindowsHookEx(hm);
            });
            t.IsBackground = true;
            t.Start();
            Thread bezpiecznik = new Thread(() => { Thread.Sleep(maxSekund * 1000); Wylacz(); });
            bezpiecznik.IsBackground = true;
            bezpiecznik.Start();
        }
        public static void Wylacz() {
            if (watek != 0) PostThreadMessage(watek, 0x0012, IntPtr.Zero, IntPtr.Zero);    // WM_QUIT
        }
        // 1. DELETE -> wycisz dzwiek, 2. DELETE -> pelny stop
        public static void ObsluzDelete() {
            Nacisniecia++;
            if (Nacisniecia == 1) { Wycisz = true; }
            else { Stop = true; Wylacz(); }
        }
        static IntPtr Klawiatura(int n, IntPtr w, IntPtr l) {
            if (n >= 0 && (Marshal.ReadInt32(l, 8) & 0x10) == 0) {               // prawdziwy klawisz, nie od bota
                int wp = w.ToInt32();
                if (Marshal.ReadInt32(l) == 0x2E && (wp == 0x100 || wp == 0x104)) { ObsluzDelete(); }   // DELETE wcisniety (keydown)
                return (IntPtr)1;                                                // zablokuj
            }
            return CallNextHookEx(IntPtr.Zero, n, w, l);
        }
        static IntPtr Mysz(int n, IntPtr w, IntPtr l) {
            if (n >= 0 && (Marshal.ReadInt32(l, 12) & 0x01) == 0) return (IntPtr)1;   // prawdziwa mysz -> zablokuj
            return CallNextHookEx(IntPtr.Zero, n, w, l);
        }
    }
}
'@
# wylacz zamrazanie okna po kliknieciu w nie (QuickEdit)
$hIn = [Bot.W]::GetStdHandle(-10); [uint32]$tryb = 0
if ([Bot.W]::GetConsoleMode($hIn, [ref]$tryb)) {
    $nowy = $tryb
    if ($nowy -band 0x40) { $nowy = $nowy - 0x40 }
    [void][Bot.W]::SetConsoleMode($hIn, ($nowy -bor 0x80))
}

# NA SAM START: blokada calego inputu poza DELETE (bot dalej steruje mysza i klawiatura).
# 1. DELETE wycisza dzwiek, 2. DELETE zatrzymuje bota i zdejmuje blokade; sama znika najpozniej po 30 minutach.
[Bot.Blokada]::Wlacz(1800)

# Zapamietaj glosnosc z samego poczatku (przywroci ja 1. DELETE)
$script:GlosnoscStart = [Bot.Glosnosc]::Odczytaj()

# Glosnosc na maksa: 50 x "glosnosc w gore" (kazde to +2%, odcisza tez wyciszony dzwiek)
for ($v = 0; $v -lt 50; $v++) {
    [Bot.W]::keybd_event(0xAF, 0, 1, [UIntPtr]::Zero)    # VK_VOLUME_UP wcisnij
    [Bot.W]::keybd_event(0xAF, 0, 3, [UIntPtr]::Zero)    # VK_VOLUME_UP pusc
    Start-Sleep -Milliseconds 20
}
Write-Host '  Glosnosc: 100%'
Write-Host '  Gotowe do startu.'

# DELETE: 1. raz -> wyciszenie, 2. raz -> natychmiastowy stop (liczy wylacznie hook, bez duplikatow)
$script:Wyciszono = $false
function Sprawdz-Stop {
    if ([Bot.Blokada]::Wycisz -and -not $script:Wyciszono) {
        $script:Wyciszono = $true
        Write-Host ''
        if ($script:GlosnoscStart -ge 0 -and [Bot.Glosnosc]::Ustaw($script:GlosnoscStart)) {
            Write-Host ("  Glosnosc: {0}%" -f [int]($script:GlosnoscStart * 100))
        } else {
            # awaryjnie (gdy Core Audio nie dziala): wycisz jak dawniej
            for ($v = 0; $v -lt 50; $v++) {
                [Bot.W]::keybd_event(0xAE, 0, 1, [UIntPtr]::Zero)    # VK_VOLUME_DOWN wcisnij
                [Bot.W]::keybd_event(0xAE, 0, 3, [UIntPtr]::Zero)    # VK_VOLUME_DOWN pusc
                Start-Sleep -Milliseconds 20
            }
        }
    }
    if ([Bot.Blokada]::Stop) {
        [Bot.Blokada]::Wylacz()
        Write-Host ''
        exit
    }
}

# Czekanie (razy $Wolno) - caly czas pilnuje klawisza DELETE
function Czekaj([double]$ms, [switch]$Dokladnie) {
    if (-not $Dokladnie) { $ms = $ms * $Wolno }
    $zegar = [Diagnostics.Stopwatch]::StartNew()
    do { Sprawdz-Stop; Start-Sleep -Milliseconds 30 } while ($zegar.ElapsedMilliseconds -lt $ms)
}

# Skrot klawiszowy: '^n' = Ctrl+N, '^l' = Ctrl+L, '{ENTER}' = Enter
function Klawisz([string]$k) {
    [System.Windows.Forms.SendKeys]::SendWait($k)
    Czekaj 300
}

# Pisanie tekstu litera po literze
function Pisz([string]$tekst) {
    if ([Console]::CapsLock) { [System.Windows.Forms.SendKeys]::SendWait('{CAPSLOCK}') }  # ID filmu rozroznia wielkie litery
    foreach ($c in $tekst.ToCharArray()) {
        $z = [string]$c
        if ('+^%~(){}[]'.Contains($z)) { $z = '{' + $z + '}' }   # znaki specjalne dla SendKeys
        [System.Windows.Forms.SendKeys]::SendWait($z)
        Czekaj 50
    }
}

# Plynny ruch myszki do punktu (x, y)
function Mysz-Do([double]$x, [double]$y) {
    $start = [System.Windows.Forms.Cursor]::Position
    for ($k = 1; $k -le 10; $k++) {
        $t = $k / 10
        $t = $t * $t * (3 - 2 * $t)                              # lagodny start i hamowanie
        [void][Bot.W]::SetCursorPos([int]($start.X + ($x - $start.X) * $t), [int]($start.Y + ($y - $start.Y) * $t))
        Czekaj 30
    }
}

# Klik lewym przyciskiem myszy
function Kliknij {
    [Bot.W]::mouse_event(0x0002, 0, 0, 0, [UIntPtr]::Zero)      # wcisnij
    Start-Sleep -Milliseconds 80
    [Bot.W]::mouse_event(0x0004, 0, 0, 0, [UIntPtr]::Zero)      # pusc
    Czekaj 500
}

# Zrzut kawalka ekranu: jasnosc probek co 8 px (do wykrywania, czy obraz sie rusza)
function Probki([int]$x, [int]$y, [int]$w, [int]$h) {
    $bmp = New-Object System.Drawing.Bitmap $w, $h
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.CopyFromScreen($x, $y, 0, 0, $bmp.Size)
    $g.Dispose()
    $wyn = New-Object 'System.Collections.Generic.List[int]'
    for ($py = 0; $py -lt $h; $py += 8) {
        for ($px = 0; $px -lt $w; $px += 8) {
            $c = $bmp.GetPixel($px, $py)
            $wyn.Add([int]$c.R + [int]$c.G + [int]$c.B)
        }
    }
    $bmp.Dispose()
    return ,$wyn
}

# Czy film sie rusza? Dwa zrzuty w odstepie 0,7 s - jesli obraz sie zmienia, to gra
function Czy-Gra([int]$x, [int]$y, [int]$w, [int]$h) {
    try {
        $a = Probki $x $y $w $h
        Czekaj 700 -Dokladnie
        $b = Probki $x $y $w $h
        $ile = 0
        for ($n = 0; $n -lt $a.Count; $n++) { if ([Math]::Abs($a[$n] - $b[$n]) -gt 30) { $ile++ } }
        return ($ile -ge 3)
    } catch { return $false }
}

# Jesli film nie gra - klika w niego (srodek odtwarzacza). Do 3 prob: film z nieruchomym
# obrazkiem wyglada jak "nie gra", wiec pierwszy klik moze go zatrzymac - drugi wznowi.
function Wlacz-Film([double]$cx, [double]$cy, [int]$sx, [int]$sy, [int]$sw, [int]$sh) {
    for ($proba = 1; $proba -le 3; $proba++) {
        if (Czy-Gra $sx $sy $sw $sh) { Write-Host '    - film gra'; return }
        Write-Host '    - film nie gra - klikam w niego'
        Mysz-Do $cx $cy
        Kliknij
        Czekaj 1000
    }
}

# Pilnuje, zeby na wierzchu byla przegladarka (zwraca jej okno)
function Aktywuj-Przegladarke {
    for ($proba = 1; $proba -le 20; $proba++) {
        $h = [Bot.W]::GetForegroundWindow()
        [uint32]$procId = 0
        [void][Bot.W]::GetWindowThreadProcessId($h, [ref]$procId)
        $proc = Get-Process -Id $procId -ErrorAction SilentlyContinue
        if ($proc -and $proc.ProcessName -eq $Przegladarka.Proc) { return $h }

        $okno = Get-Process -Name $Przegladarka.Proc -ErrorAction SilentlyContinue |
                Where-Object { $_.MainWindowHandle -ne 0 } | Select-Object -First 1
        if ($okno) {
            $w = $okno.MainWindowHandle
            if ([Bot.W]::IsIconic($w)) { [void][Bot.W]::ShowWindow($w, 9) }
            [Bot.W]::keybd_event(0x12, 0, 0, [UIntPtr]::Zero)    # szybki Alt - dzieki temu Windows
            [Bot.W]::keybd_event(0x12, 0, 2, [UIntPtr]::Zero)    # pozwala przelaczyc okno
            [void][Bot.W]::SetForegroundWindow($w)
        }
        Czekaj 1000 -Dokladnie
    }
    Write-Host '  Nie moge przelaczyc sie na przegladarke - przerywam.' -ForegroundColor Red
    exit
}

# Szuka na YouTube i zwraca ID pierwszego filmu ('' jesli sie nie uda)
function Znajdz-Film([string]$fraza) {
    $ProgressPreference = 'SilentlyContinue'
    $ua = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36'
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
        $sesja = New-Object Microsoft.PowerShell.Commands.WebRequestSession
        $sesja.Cookies.Add((New-Object Net.Cookie('SOCS', 'CAI', '/', '.youtube.com')))   # bez okienka zgody na cookies
        $url = 'https://www.youtube.com/results?search_query=' + [uri]::EscapeDataString($fraza)
        $html = (Invoke-WebRequest -Uri $url -UseBasicParsing -WebSession $sesja -UserAgent $ua).Content
        $m = [regex]::Match($html, '"videoRenderer":\{"videoId":"([\w-]{11})"')
        if ($m.Success) { return $m.Groups[1].Value }
    } catch { }
    return ''
}

# ------------------------------ START --------------------------------

[void][Bot.W]::SetProcessDPIAware()     # dokladne wspolrzedne przy skalowaniu ekranu
[void][Bot.W]::GetAsyncKeyState(0x2E)   # wyzeruj stan klawisza DELETE

# Przegladarka: Chrome, a jesli go nie ma - Edge (jest w kazdym Windowsie)
$Przegladarka = @(
    @{ Exe = "$env:ProgramFiles\Google\Chrome\Application\chrome.exe";         Proc = 'chrome' }
    @{ Exe = "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe";  Proc = 'chrome' }
    @{ Exe = "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe";         Proc = 'chrome' }
    @{ Exe = "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe"; Proc = 'msedge' }
    @{ Exe = "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe";        Proc = 'msedge' }
) | Where-Object { Test-Path $_.Exe } | Select-Object -First 1
if (-not $Przegladarka) { Write-Host '  Nie znalazlem Chrome ani Edge!' -ForegroundColor Red; exit }

Write-Host ''
Write-Host '  ===================== MUZYCZNY VIRUS =====================' -ForegroundColor Cyan
Write-Host "  Przegladarka: $($Przegladarka.Exe)"
Write-Host ''

foreach ($p in $Piosenki) {
    if (-not $p.Id) {
        Write-Host "  Szukam na YouTube: $($p.Tytul)"
        $p.Id = Znajdz-Film $p.Tytul
        if (-not $p.Id) { Write-Host '    nie znalazlem - otworze wyniki wyszukiwania' -ForegroundColor DarkYellow }
    }
}

for ($s = 3; $s -ge 1; $s--) { Write-Host "  Start za $s..."; Czekaj 1000 -Dokladnie }

for ($i = 0; $i -lt $Piosenki.Count; $i++) {
    $p = $Piosenki[$i]
    Write-Host ''
    Write-Host ("  [{0}/{1}] {2}" -f ($i + 1), $Piosenki.Count, $p.Tytul) -ForegroundColor Green

    if ($i -eq 0) {
        Write-Host '    - wlaczam przegladarke z YouTube'
        Start-Process -FilePath $Przegladarka.Exe -ArgumentList '--new-window --start-maximized --no-first-run --no-default-browser-check --autoplay-policy=no-user-gesture-required https://www.youtube.com'
        Czekaj 3000 -Dokladnie                      # 3 s, zeby przegladarka spokojnie wstala
    } else {
        Write-Host '    - Ctrl+N: nowe okno'
        $stare = Aktywuj-Przegladarke
        Klawisz '^n'
        # czekaj, az nowe okno naprawde sie pojawi (zeby nie pisac w starym)
        $zegar = [Diagnostics.Stopwatch]::StartNew()
        while ([Bot.W]::GetForegroundWindow() -eq $stare -and $zegar.ElapsedMilliseconds -lt 10000) { Czekaj 100 -Dokladnie }
        Czekaj 2000
    }

    $okno = Aktywuj-Przegladarke
    [void][Bot.W]::ShowWindow($okno, 3)            # 3 = maksymalizuj
    Czekaj 1000

    Write-Host '    - myszka -> pasek adresu'
    $r = New-Object Bot.RECT
    [void][Bot.W]::GetWindowRect($okno, [ref]$r)
    $skala = 1.0
    try { $dpi = [Bot.W]::GetDpiForWindow($okno); if ($dpi -gt 0) { $skala = $dpi / 96.0 } } catch { }
    $gora = [Math]::Max($r.Top, 0)
    Mysz-Do (($r.Left + $r.Right) / 2) ($gora + 60 * $skala)
    Kliknij
    Klawisz '^l'                                   # Ctrl+L = na pewno pasek adresu

    if ($p.Id) { $adres = 'youtube.com/watch?v=' + $p.Id }
    else       { $adres = 'youtube.com/results?search_query=' + [uri]::EscapeDataString($p.Tytul) }
    Write-Host "    - pisze: $adres"
    [void](Aktywuj-Przegladarke)                   # pisz tylko do przegladarki!
    Pisz $adres
    Klawisz '{ENTER}'

    Write-Host '    - czekam, az film sie zaladuje'
    Czekaj 5000

    # srodek odtwarzacza
    $cx = $r.Left + ($r.Right - $r.Left) * 0.35
    $cy = $gora + ($r.Bottom - $gora) * 0.45

    # sprawdz, czy film gra (obszar z lewej strony odtwarzacza, z dala od srodka i paskow sterowania)
    $sx = [int]($r.Left + ($r.Right - $r.Left) * 0.08)
    $sy = [int]($gora + ($r.Bottom - $gora) * 0.30)
    Wlacz-Film $cx $cy $sx $sy ([int](200 * $skala)) ([int](120 * $skala))

    # kolko myszka nad filmem
    Mysz-Do ($cx + 80) $cy
    for ($k = 0; $k -le 18; $k++) {
        $kat = $k * 20 * [Math]::PI / 180
        [void][Bot.W]::SetCursorPos([int]($cx + 80 * [Math]::Cos($kat)), [int]($cy + 80 * [Math]::Sin($kat)))
        Czekaj 30
    }

    if ($i -lt $Piosenki.Count - 1) {
        Write-Host "    - gra... nastepna za ok. $([int]($CzasGrania * $Wolno)) s"
        Czekaj ($CzasGrania * 1000)
    }
}

[Bot.Blokada]::Wylacz()                         # oddaj mysz i klawiature
Write-Host ''
Write-Host '  Gotowe! Wszystkie piosenki leca. Mysz i klawiatura odblokowane.' -ForegroundColor Green