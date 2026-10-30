<# : batch
@echo off
setlocal
set "BOT_PLIK=%~f0"
powershell -NoProfile -STA -Command "iex ([IO.File]::ReadAllText($env:BOT_PLIK))"
echo.
echo  Koniec. To okno zamknie sie za 5 sekund...
timeout /t 5 >nul
exit /b
#>

# ---------------------------- USTAWIENIA -----------------------------

# Tempo: 0.25 = 2x szybciej, 0,5 = normalnie, 1 = 2x wolniej (dla wolnej VM)
$Wolno = 0.5

# Automatyczne tempo: bot mierzy, jak dlugo wczytuja sie przegladarka, nowe okna i filmy,
# i sam dobiera $Wolno (od 0.25 do 1.5; $Wolno powyzej to wartosc bazowa dla "normalnego" komputera).
# Ustaw $false, zeby uzywac stalego $Wolno.
$AutoTempo = $true
$WolnoBazowe = $Wolno

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
        [DllImport("user32.dll")] public static extern int    GetWindowLong(IntPtr hWnd, int nIndex);
        [DllImport("user32.dll")] public static extern int    SetWindowLong(IntPtr hWnd, int nIndex, int dwNewLong);
        [DllImport("user32.dll")] public static extern int    GetSystemMetrics(int index);
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

# MUSI byc wywolane PRZED kazdym GetSystemMetrics/tworzeniem okien (np. przed Start-Pilka nizej) -
# dopoki proces nie jest DPI-aware, Windows wirtualizuje GetSystemMetrics i zwraca mniejsza,
# przeskalowana "logiczna" rozdzielczosc zamiast prawdziwej fizycznej, co psuje wszystkie
# obliczenia oparte na rozmiarze ekranu (granice odbic, rozmiar bitmapy sladu itd.).
[void][Bot.W]::SetProcessDPIAware()

# ---------------- Odskakujaca "karta" (ozdoba): grawitacja + odbicia jak w animacji -------
# ---------------- koncowej pasjansa - spada, odbija sie od dolu/gory/bokow, traci troche ---
# ---------------- energii przy kazdym odbiciu od dolu, a gdy juz ledwo skacze, odrywa sie --
# ---------------- od nowa. WAZNE (optymalizacja): slad to NIE osobne okno na kazda klatke -
# ---------------- animacji (to wlasnie zacinalo caly system - tworzenie okna jest ciezkie) -
# ---------------- - to jeden bitmap rysowany na JEDNEJ przezroczystej planszy na caly ------
# ---------------- ekran. Realnych okien jest cala zycie skryptu tylko dwa: plansza i karta. -
# ---------------- Nieklikalne (WS_EX_TRANSPARENT) i bez taskbara, wiec bot to ignoruje. -----
$GWL_EXSTYLE       = -20
$WS_EX_TRANSPARENT = 0x00000020
$WS_EX_TOOLWINDOW  = 0x00000080
$WS_EX_NOACTIVATE  = 0x08000000

function Ustaw-Nieklikalne($okno) {
    $styl = [Bot.W]::GetWindowLong($okno.Handle, $GWL_EXSTYLE)
    [void][Bot.W]::SetWindowLong($okno.Handle, $GWL_EXSTYLE, ($styl -bor $WS_EX_TRANSPARENT -bor $WS_EX_TOOLWINDOW -bor $WS_EX_NOACTIVATE))
}

function Nowe-Okienko([System.Drawing.Point]$miejsce, [int]$szerokosc, [int]$wysokosc, [System.Drawing.Color]$kolor) {
    $f = New-Object System.Windows.Forms.Form
    $f.AutoScaleMode  = [System.Windows.Forms.AutoScaleMode]::None   # bez tego WinForms samo przeskalowuje rozmiar wg DPI
    $f.FormBorderStyle = 'None'
    $f.ShowInTaskbar  = $false
    $f.TopMost        = $true
    $f.StartPosition  = 'Manual'
    $f.Width  = $szerokosc
    $f.Height = $wysokosc
    $f.BackColor = $kolor
    $f.Location  = $miejsce
    $f.Show()
    Ustaw-Nieklikalne $f
    return $f
}

# Wymiary jak u karty do gry (proporcje ~0.7 - szersza plansza wyglada jak odwrocona karta)
$script:PilkaSzer = 110
$script:PilkaWys  = 154
$script:Grawitacja = 0.6     # przyspieszenie w dol - kazda klatka dodaje to do PilkaVy
$script:Tlumienie  = 0.78    # ile predkosci zostaje po odbiciu od dolu (reszta = strata energii)

$script:PilkaOkno = $null
$script:PilkaX = 0.0
$script:PilkaY = 0.0
$script:PilkaVx = 10.0
$script:PilkaVy = 0.0

# Plansza sladu: jedno przezroczyste okno na caly ekran + jeden bitmap w pamieci, na ktorym
# dorysowujemy kolejne "duchy" karty. KluczKolor = kolor uznawany za przezroczysty (TransparencyKey).
$script:KluczKolor  = [System.Drawing.Color]::FromArgb(255, 1, 2, 3)
$script:KluczPedzel = $null   # SolidBrush w kolorze "przezroczystosci" - do wymazywania pojedynczych duchow
$script:Plansza     = $null
$script:PlanszaBmp  = $null
$script:PlanszaGfx  = $null

# Kazdy "duch" sladu znika pojedynczo po tylu ms. Kolejka (FIFO) - duchy dodawane sa po kolei,
# wiec najstarszy zawsze jest na poczatku; wygasle usuwamy TYLKO jego, pojedynczym, malym
# FillRectangle w jego wlasnym miejscu - bez czyszczenia/przerysowywania calego ekranu
# (to wlasniezacinalo - pelne Clear() + Invalidate() calej planszy 5x/s to bardzo ciezka operacja).
$script:SladCzasZycia = 16000
$script:SladZegar     = $null
$script:SladElementy  = New-Object 'System.Collections.Generic.Queue[object]'

function Start-Pilka {
    # GetSystemMetrics = fizyczne piksele Win32 - ta sama przestrzen co SetCursorPos/Location,
    # w przeciwienstwie do Screen.Bounds (WinForms), ktore przy skalowaniu DPI bywa mniejsze.
    $szerokoscEkranu = [Bot.W]::GetSystemMetrics(0)   # SM_CXSCREEN
    $wysokoscEkranu  = [Bot.W]::GetSystemMetrics(1)   # SM_CYSCREEN

    $script:PlanszaBmp  = New-Object System.Drawing.Bitmap $szerokoscEkranu, $wysokoscEkranu
    $script:PlanszaGfx  = [System.Drawing.Graphics]::FromImage($script:PlanszaBmp)
    $script:PlanszaGfx.Clear($script:KluczKolor)
    $script:KluczPedzel = New-Object System.Drawing.SolidBrush $script:KluczKolor

    $script:Plansza = New-Object System.Windows.Forms.Form
    $script:Plansza.AutoScaleMode  = [System.Windows.Forms.AutoScaleMode]::None   # bez tego WinForms samo przeskalowuje rozmiar wg DPI
    $script:Plansza.FormBorderStyle = 'None'
    $script:Plansza.ShowInTaskbar   = $false
    $script:Plansza.TopMost         = $true
    $script:Plansza.StartPosition   = 'Manual'
    $script:Plansza.Location = New-Object System.Drawing.Point(0, 0)
    $script:Plansza.Width  = $szerokoscEkranu
    $script:Plansza.Height = $wysokoscEkranu
    $script:Plansza.BackColor       = $script:KluczKolor
    $script:Plansza.TransparencyKey = $script:KluczKolor
    $bmp = $script:PlanszaBmp
    $script:Plansza.Add_Paint({ param($s, $e) $e.Graphics.DrawImageUnscaled($bmp, 0, 0) }.GetNewClosure())
    $script:Plansza.Show()
    Ustaw-Nieklikalne $script:Plansza

    $script:SladZegar = [Diagnostics.Stopwatch]::StartNew()
    $script:SladElementy.Clear()

    $script:PilkaX = Get-Random -Minimum 0 -Maximum ($szerokoscEkranu - $script:PilkaSzer)
    $script:PilkaY = Get-Random -Minimum 0 -Maximum ([int](($wysokoscEkranu - $script:PilkaWys) / 2))   # zacznij w gornej polowie, jak wyrzucona karta
    $script:PilkaVy = -[double](Get-Random -Minimum 20 -Maximum 32)                                      # mocny pierwszy "wyrzut" do gory
    $miejsce = New-Object System.Drawing.Point([int]$script:PilkaX, [int]$script:PilkaY)
    $script:PilkaOkno = Nowe-Okienko $miejsce $script:PilkaSzer $script:PilkaWys ([System.Drawing.Color]::White)
}

# Przesuwa karte o jedna "klatke" animacji (grawitacja + odbicia jak w pasjansie). Slad
# dorysowuje na istniejacym bitmapie (szybki FillRectangle) - zero nowych okien na klatke.
function Aktualizuj-Pilke {
    if (-not $script:PilkaOkno) { return }
    $maxX = [Bot.W]::GetSystemMetrics(0) - $script:PilkaSzer    # SM_CXSCREEN, fizyczne piksele
    $maxY = [Bot.W]::GetSystemMetrics(1) - $script:PilkaWys     # SM_CYSCREEN, fizyczne piksele

    $script:PilkaVy += $script:Grawitacja
    $script:PilkaX  += $script:PilkaVx
    $script:PilkaY  += $script:PilkaVy

    if ($script:PilkaX -le 0)     { $script:PilkaX = 0;     $script:PilkaVx =  [Math]::Abs($script:PilkaVx) }
    if ($script:PilkaX -ge $maxX) { $script:PilkaX = $maxX; $script:PilkaVx = -[Math]::Abs($script:PilkaVx) }
    if ($script:PilkaY -le 0)     { $script:PilkaY = 0;     $script:PilkaVy =  [Math]::Abs($script:PilkaVy) }
    if ($script:PilkaY -ge $maxY) {
        $script:PilkaY = $maxY
        $script:PilkaVy = -[Math]::Abs($script:PilkaVy) * $script:Tlumienie    # odbicie od dolu, troche energii w strate
        if ([Math]::Abs($script:PilkaVy) -lt 4) {
            # ledwo juz skacze - mocny nowy "wyrzut", jak kolejna karta rzucona na nowo
            $script:PilkaVy = -[double](Get-Random -Minimum 24 -Maximum 34)
            $script:PilkaVx = (Get-Random -Minimum 10 -Maximum 18) * (@(-1, 1) | Get-Random)
        }
    }

    # slad: dorysuj "ducha" w starym miejscu, zapamietujac kiedy powstal (zeby pozniej mogl wygasnac)
    $stareMiejsce = $script:PilkaOkno.Location
    $teraz = $script:SladZegar.ElapsedMilliseconds
    $script:SladElementy.Enqueue([PSCustomObject]@{ X = $stareMiejsce.X; Y = $stareMiejsce.Y; Dodany = $teraz })
    $script:PlanszaGfx.FillRectangle([System.Drawing.Brushes]::Gainsboro, $stareMiejsce.X, $stareMiejsce.Y, $script:PilkaSzer, $script:PilkaWys)
    $script:Plansza.Invalidate((New-Object System.Drawing.Rectangle $stareMiejsce.X, $stareMiejsce.Y, $script:PilkaSzer, $script:PilkaWys))

    # usun (pojedynczo, bez przebudowy calej planszy) te "duchy", ktore wlasnie wygasly. Kolejka
    # jest posortowana wg czasu dodania, wiec zawsze sprawdzamy tylko najstarszy element z przodu.
    while ($script:SladElementy.Count -gt 0 -and ($teraz - $script:SladElementy.Peek().Dodany) -ge $script:SladCzasZycia) {
        $wygasly = $script:SladElementy.Dequeue()
        $script:PlanszaGfx.FillRectangle($script:KluczPedzel, $wygasly.X, $wygasly.Y, $script:PilkaSzer, $script:PilkaWys)
        $script:Plansza.Invalidate((New-Object System.Drawing.Rectangle $wygasly.X, $wygasly.Y, $script:PilkaSzer, $script:PilkaWys))
    }

    $script:PilkaOkno.Location = New-Object System.Drawing.Point([int]$script:PilkaX, [int]$script:PilkaY)
    [System.Windows.Forms.Application]::DoEvents()    # bez tego okno/plansza by sie nie przerysowaly (nie ma Application.Run)
}

function Zamknij-Pilke {
    if ($script:PilkaOkno)   { $script:PilkaOkno.Close();   $script:PilkaOkno.Dispose();   $script:PilkaOkno   = $null }
    if ($script:Plansza)     { $script:Plansza.Close();     $script:Plansza.Dispose();     $script:Plansza     = $null }
    if ($script:PlanszaGfx)  { $script:PlanszaGfx.Dispose(); $script:PlanszaGfx = $null }
    if ($script:PlanszaBmp)  { $script:PlanszaBmp.Dispose(); $script:PlanszaBmp = $null }
    if ($script:KluczPedzel) { $script:KluczPedzel.Dispose(); $script:KluczPedzel = $null }
    $script:SladElementy.Clear()
}

# ---------------- Losowo pojawiajacy/znikajacy obrazek (miku/teto) ------------------------
# ---------------- Jeden na raz, w losowym miejscu, na losowy czas - rownolegle do karty. ---
$script:ObrazkiPliki = @(
    'C:\Users\PawelPoleszak\Desktop\virus\miku.png'
    'C:\Users\PawelPoleszak\Desktop\virus\teto.png'
)
$script:ObrazekMaxWysokosc  = 800       # skalujemy obrazek w dol do tej wysokosci (px), proporcje zachowane
$script:ObrazekCzasWidoczny = 900, 1100    # ms - losowy zakres: jak dlugo obrazek jest widoczny (~1 s)
$script:ObrazekCzasPrzerwy  = 800, 2000    # ms - losowy zakres: przerwa, zanim pojawi sie kolejny

$script:ObrazkiBitmapy  = @()
$script:ObrazekOkno     = $null
$script:ObrazekZegar    = $null
$script:ObrazekNastepna = 0
$script:ObrazekPokazany = $false

function Start-Obrazki {
    $script:ObrazkiBitmapy = @()
    foreach ($plik in $script:ObrazkiPliki) {
        if (-not (Test-Path $plik)) { Write-Host "  Nie znalazlem obrazka: $plik" -ForegroundColor DarkYellow; continue }
        try {
            $oryginal = [System.Drawing.Image]::FromFile($plik)
            $skala = [Math]::Min(1.0, $script:ObrazekMaxWysokosc / $oryginal.Height)
            $w = [Math]::Max(1, [int]($oryginal.Width  * $skala))
            $h = [Math]::Max(1, [int]($oryginal.Height * $skala))
            $script:ObrazkiBitmapy += New-Object System.Drawing.Bitmap $oryginal, $w, $h
            $oryginal.Dispose()
        } catch { Write-Host "  Nie udalo sie wczytac: $plik" -ForegroundColor DarkYellow }
    }
    $script:ObrazekZegar    = [Diagnostics.Stopwatch]::StartNew()
    $script:ObrazekPokazany = $false
    $script:ObrazekNastepna = Get-Random -Minimum $script:ObrazekCzasPrzerwy[0] -Maximum $script:ObrazekCzasPrzerwy[1]
}

# Co klatke: albo pokazuje nowy obrazek (gdy minela przerwa), albo chowa pokazany (gdy minal jego czas).
function Aktualizuj-Obrazki {
    if ($script:ObrazkiBitmapy.Count -eq 0) { return }
    $teraz = $script:ObrazekZegar.ElapsedMilliseconds

    if (-not $script:ObrazekPokazany) {
        if ($teraz -lt $script:ObrazekNastepna) { return }
        $bmp = $script:ObrazkiBitmapy | Get-Random
        $szerokoscEkranu = [Bot.W]::GetSystemMetrics(0)   # SM_CXSCREEN, fizyczne piksele
        $wysokoscEkranu  = [Bot.W]::GetSystemMetrics(1)   # SM_CYSCREEN, fizyczne piksele
        $x = Get-Random -Minimum 0 -Maximum ([Math]::Max(1, $szerokoscEkranu - $bmp.Width))
        $y = Get-Random -Minimum 0 -Maximum ([Math]::Max(1, $wysokoscEkranu  - $bmp.Height))

        $script:ObrazekOkno = New-Object System.Windows.Forms.Form
        $script:ObrazekOkno.AutoScaleMode   = [System.Windows.Forms.AutoScaleMode]::None
        $script:ObrazekOkno.FormBorderStyle = 'None'
        $script:ObrazekOkno.ShowInTaskbar   = $false
        $script:ObrazekOkno.TopMost         = $true
        $script:ObrazekOkno.StartPosition   = 'Manual'
        $script:ObrazekOkno.Width  = $bmp.Width
        $script:ObrazekOkno.Height = $bmp.Height
        $script:ObrazekOkno.Location = New-Object System.Drawing.Point($x, $y)
        $script:ObrazekOkno.BackColor       = $script:KluczKolor    # ten sam klucz co plansza -
        $script:ObrazekOkno.TransparencyKey = $script:KluczKolor    # przezroczyste tlo PNG zostaje przezroczyste
        $script:ObrazekOkno.BackgroundImage = $bmp
        $script:ObrazekOkno.BackgroundImageLayout = 'Stretch'
        $script:ObrazekOkno.Show()
        Ustaw-Nieklikalne $script:ObrazekOkno

        $script:ObrazekPokazany = $true
        $script:ObrazekNastepna = $teraz + (Get-Random -Minimum $script:ObrazekCzasWidoczny[0] -Maximum $script:ObrazekCzasWidoczny[1])
    } else {
        if ($teraz -lt $script:ObrazekNastepna) { return }
        $script:ObrazekOkno.Close(); $script:ObrazekOkno.Dispose(); $script:ObrazekOkno = $null
        $script:ObrazekPokazany = $false
        $script:ObrazekNastepna = $teraz + (Get-Random -Minimum $script:ObrazekCzasPrzerwy[0] -Maximum $script:ObrazekCzasPrzerwy[1])
    }
}

function Zamknij-Obrazki {
    if ($script:ObrazekOkno) { $script:ObrazekOkno.Close(); $script:ObrazekOkno.Dispose(); $script:ObrazekOkno = $null }
    foreach ($b in $script:ObrazkiBitmapy) { $b.Dispose() }
    $script:ObrazkiBitmapy = @()
}

# NA SAM START: blokada calego inputu poza DELETE (bot dalej steruje mysza i klawiatura).
# 1. DELETE wycisza dzwiek, 2. DELETE zatrzymuje bota i zdejmuje blokade; sama znika najpozniej po 30 minutach.
[Bot.Blokada]::Wlacz(1800)
Start-Pilka
Start-Obrazki

# Zapamietaj glosnosc z samego poczatku (przywroci ja 1. DELETE)
$script:GlosnoscStart = [Bot.Glosnosc]::Odczytaj()

# Glosnosc na maksa: od razu, jednym wywolaniem (Core Audio) - a nie stopniowo klawiszami
if (-not [Bot.Glosnosc]::Ustaw(1.0)) {
    # awaryjnie (gdy Core Audio nie dziala): tak samo jak przy wyciszaniu - bez opoznien miedzy wcisnieciami
    for ($v = 0; $v -lt 50; $v++) {
        [Bot.W]::keybd_event(0xAF, 0, 1, [UIntPtr]::Zero)    # VK_VOLUME_UP wcisnij
        [Bot.W]::keybd_event(0xAF, 0, 3, [UIntPtr]::Zero)    # VK_VOLUME_UP pusc
    }
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

    Aktualizuj-Pilke
    Aktualizuj-Obrazki

    if ([Bot.Blokada]::Stop) {
        [Bot.Blokada]::Wylacz()
        Zamknij-Pilke
        Zamknij-Obrazki
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

# Pisanie tekstu od razu, calosc jednym wywolaniem (bez odczekiwania miedzy znakami)
function Pisz([string]$tekst) {
    if ([Console]::CapsLock) { [System.Windows.Forms.SendKeys]::SendWait('{CAPSLOCK}') }  # ID filmu rozroznia wielkie litery
    $uciekly = -join ($tekst.ToCharArray() | ForEach-Object {
        $z = [string]$_
        if ('+^%~(){}[]'.Contains($z)) { '{' + $z + '}' } else { $z }   # znaki specjalne dla SendKeys
    })
    [System.Windows.Forms.SendKeys]::SendWait($uciekly)
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

# --- Automatyczne tempo ---
$script:Wspolczynniki = New-Object 'System.Collections.Generic.List[double]'
$script:LimitFilm = 12000      # ile ms maksymalnie czekac, az film ruszy sam (potem bot kliknie)

# Zapisuje pomiar (ms) i porownuje go z czasem na szybkim komputerze ($wzorzec, ms).
# $Wolno = baza * srednia z ostatnich 6 pomiarow, wiec wolny komputer = dluzsze pauzy.
function Zapisz-Pomiar([string]$co, [double]$ms, [double]$wzorzec) {
    if (-not $AutoTempo) { return }
    $script:Wspolczynniki.Add([Math]::Min(4.0, $ms / $wzorzec))
    $ost = @($script:Wspolczynniki | Select-Object -Last 6)
    $sr = ($ost | Measure-Object -Average).Average
    $script:Wolno = [Math]::Min(1.5, [Math]::Max(0.25, $WolnoBazowe * $sr))
}

function Przegladarka-Na-Wierzchu {
    $h = [Bot.W]::GetForegroundWindow()
    [uint32]$procId = 0
    [void][Bot.W]::GetWindowThreadProcessId($h, [ref]$procId)
    $proc = Get-Process -Id $procId -ErrorAction SilentlyContinue
    return [bool]($proc -and $proc.ProcessName -eq $Przegladarka.Proc)
}

# Czeka, az film sam ruszy (obraz sie zmienia) i mierzy, ile to trwalo.
# Jesli nie ruszy w limicie - po prostu wraca (bot nie klika w odtwarzacz).
function Czekaj-Na-Film([int]$x, [int]$y, [int]$w, [int]$h) {
    $zegar = [Diagnostics.Stopwatch]::StartNew()
    while ($zegar.ElapsedMilliseconds -lt $script:LimitFilm) {
        if (Czy-Gra $x $y $w $h) {
            Zapisz-Pomiar 'film' $zegar.ElapsedMilliseconds 3000
            $script:LimitFilm = [Math]::Min(12000, [Math]::Max(4000, 2.5 * $zegar.ElapsedMilliseconds))
            return
        }
    }
    Write-Host '    - film nie ruszyl sam' -ForegroundColor DarkYellow
    $script:LimitFilm = [Math]::Max(5000, $script:LimitFilm * 0.7)
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
        $zegarStart = [Diagnostics.Stopwatch]::StartNew()
        while (-not (Przegladarka-Na-Wierzchu) -and $zegarStart.ElapsedMilliseconds -lt 30000) { Czekaj 100 -Dokladnie }
        Zapisz-Pomiar 'start przegladarki' $zegarStart.ElapsedMilliseconds 1500
        Czekaj 6000                                 # ok. 3 s przy tempie 0.5, zeby przegladarka spokojnie wstala
    } else {
        Write-Host '    - Ctrl+N: nowe okno'
        $stare = Aktywuj-Przegladarke
        $zegarOkna = [Diagnostics.Stopwatch]::StartNew()
        [System.Windows.Forms.SendKeys]::SendWait('^n')
        # czekaj, az nowe okno naprawde sie pojawi (zeby nie pisac w starym) i zmierz, ile to trwa
        while ([Bot.W]::GetForegroundWindow() -eq $stare -and $zegarOkna.ElapsedMilliseconds -lt 10000) { Czekaj 100 -Dokladnie }
        Zapisz-Pomiar 'nowe okno' $zegarOkna.ElapsedMilliseconds 400
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

    # srodek odtwarzacza
    $cx = $r.Left + ($r.Right - $r.Left) * 0.35
    $cy = $gora + ($r.Bottom - $gora) * 0.45

    # obszar do sprawdzania, czy film gra (z lewej strony odtwarzacza, z dala od srodka i paskow sterowania)
    $sx = [int]($r.Left + ($r.Right - $r.Left) * 0.08)
    $sy = [int]($gora + ($r.Bottom - $gora) * 0.30)
    $sw = [int](200 * $skala)
    $sh = [int](120 * $skala)

    # czekaj, az film sam ruszy (mierzy czas wczytywania)
    Czekaj-Na-Film $sx $sy $sw $sh

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
Zamknij-Pilke
Zamknij-Obrazki
Write-Host ''
Write-Host '  Gotowe! Wszystkie piosenki leca. Mysz i klawiatura odblokowane.' -ForegroundColor Green
