--[[events.config_state:set(function(type)
    print(type)
    if type == "load" then
        common.reload_script()
    end
end
)]]

local menu_groups = {}
local menu_items = {}
local menu_colored_items = {}
local menu_lists = {}
local color_callbacks = {}
local menu_cfg_labels = {["Anti Aim"] = {access = true}, ["Rage"] = {access = true}}

local add_functions = function(group)

    --Base menu functionality

    function group:visibility(value)
        group[1]:visibility(value)
    end
    function group:switch_e(...)
        local item = self[1]:switch(...)
        local args = {...}
        local id = args[1]
        if menu_items[id] then
            id = id..item:id()
        end
        menu_items[id] = item
        return item
    end
    function group:slider_e(...)
        local item = self[1]:slider(...)
        local args = {...}
        local id = args[1]
        if menu_items[id] then
            id = id..item:id()
        end
        menu_items[id] = item
        return item
    end
    function group:combo_e(...)
        local item = self[1]:combo(...)
        local args = {...}
        local id = args[1]
        if menu_items[id] then
            id = id..item:id()
        end
        menu_items[id] = item
        return item
    end
    function group:selectable_e(...)
        local item = self[1]:selectable(...)
        local args = {...}
        local id = args[1]
        if menu_items[id] then
            id = id..item:id()
        end
        menu_items[id] = item
        return item
    end
    function group:color_picker_e(...)
        local item = self[1]:color_picker(...)
        local args = {...}
        local id = args[1]
        if menu_items[id] then
            id = id..item:id()
        end
        menu_items[id] = item
        return item
    end
    function group:button_e(...)
        local item = self[1]:button(...)
        local args = {...}
        local id = args[1]
        if menu_items[id] then
            id = id..item:id()
        end
        menu_items[id] = item
        return item
    end
    function group:hotkey_e(...)
        local item = self[1]:hotkey(...)
        local args = {...}
        local id = args[1]
        if menu_items[id] then
            id = id..item:id()
        end
        menu_items[id] = item
        return item
    end
    function group:input_e(...)
        local item = self[1]:input(...)
        local args = {...}
        local id = args[1]
        if menu_items[id] then
            id = id..item:id()
        end
        menu_items[id] = item
        return item
    end
    function group:list_e(...)
        local item = self[1]:list(...)
        local args = {...}
        local id = args[1]
        if menu_items[id] then
            id = id..item:id()
        end
        menu_items[id] = item
        return item
    end
    function group:listable_e(...)
        local item = self[1]:listable(...)
        local args = {...}
        local id = args[1]
        if menu_items[id] then
            id = id..item:id()
        end
        menu_items[id] = item
        return item
    end
    function group:label_e(...)
        local item = self[1]:label(...)
        local args = {...}
        local id = args[1]
        if menu_items[id] then
            id = id..item:id()
        end
        menu_items[id] = item
        return item
    end
    function group:texture_e(...)
        local item = self[1]:texture(...)
        local args = {...}
        local id = "texture"
        if menu_items[id] then
            id = id..item:id()
        end
        menu_items[id] = item
        return item
    end

    --Other helpful functions

    function group:menu_select(list, tabs)
        local item = self[1]:list("", {})
        --[[local id = ""
        if menu_items[id] then
            id = id..item:id()
        end
        menu_items[id] = item]]
        table.insert(menu_lists, {list = list, tabs = tabs, item = item})
        return item
    end
    function group:list_col(name, list)
        local item = self[1]:list(name and name or "", {})
        local id = name and name or ""
        if menu_items[id] then
            id = id..item:id()
        end
        menu_items[id] = item
        table.insert(menu_colored_items, {list = list, item = item})
        return item
    end
    function group:button_col(name_col, name_noncol, ...)
        local name = "\aFFFFFFFF"..name_col.."\aDEFAULT"..name_noncol
        local item = self[1]:button(name, ...)
        local id = tostring(name_col..name_noncol)
        if menu_items[id] then
            id = id..item:id()
        end
        menu_items[id] = item
        table.insert(menu_colored_items, {name_col = name_col, name_noncol = name_noncol, item = item})
        return item
    end
    function group:label_cfg(tab)
        local item = self[1]:label("")
        local id = "label"
        if menu_items[id] then
            id = id..item:id()
        end
        menu_items[id] = item
        table.insert(menu_cfg_labels[tab], item)
    end
end

ui.create_sub = function(item)
    menu_groups[item] = {}
    menu_groups[item][1] = item:create()
    local sub = menu_groups[item]
    add_functions(sub)
    return sub
end

ui.color_picker_e = function(item, ...)
    local col = item:color_picker(...)
    table.insert(menu_items, col)
    return col
end

ui.create_e = function(...)
    local id = ""
    local args = {...}
    for i = 1, #args do
        id = id..args[i]..";"
    end
    while menu_groups[id] do
        id = id.."+"
    end
    menu_groups[id] = {}
    local group = menu_groups[id]
    add_functions(group)
    menu_groups[id][1] = ui.create(...)
    return group
end

cvars_ref = ui.find("Miscellaneous", "Main", "Other", "Unlock Hidden Cvars")

local loaded = cvars_ref:get_override() and true or false
cvars_ref:override(true)

if common.get_username() == "iugen" then _DEBUG = true end

math.randomseed(common.get_system_time().hours + common.get_system_time().minutes + common.get_system_time().seconds)

local discord_webhooks = require("neverlose/discord_webhooks")

local FILE_SHARE_READ = 0x00000001
local OPEN_ALWAYS = 4
local FILE_ATTRIBUTE_READONLY = 0x1

--[[enum{
        OF_READ = 0x00000000
    };
    enum{
        FILE_SHARE_READ = 0x00000001,
        OPEN_ALWAYS = 4,
        FILE_ATTRIBUTE_READONLY = 0x1,
    };]]

ffi = require 'ffi'
local effects = require("neverlose/effects")
local gradient = require("neverlose/gradient")
local interface = require("neverlose/rich_presence")

local function pcdef(...)
  local ok, err = pcall( ffi.cdef, ... )
  if not ok then return nil, err end
  return err
end

local function pack(n, str)
  return [[
  #pragma pack(push)
  #pragma pack(1)
  ]] .. str ..[[
  #pragma pack(pop)
  ]]
end

ffi.cdef [[
  //static const int 260 = 260;
  typedef uint32_t DWORD;
  typedef char    CHAR;
  typedef wchar_t WCHAR;
  typedef uint32_t DEVICE_TYPE;
  typedef uint32_t ULONG;
  typedef void*    HANDLE;
  typedef void*    HLOCAL;
  typedef void*    LPVOID;
  typedef uint32_t BOOL;
]]

pcdef(pack(1, [[ // FILETIME
  typedef struct _FILETIME {
    DWORD dwLowDateTime;
    DWORD dwHighDateTime;
  } FILETIME, *PFILETIME;
]]))

pcdef(pack(1, [[ // WIN32_FIND_DATAA
  typedef struct _WIN32_FIND_DATAA {
    DWORD    dwFileAttributes;
    FILETIME ftCreationTime;
    FILETIME ftLastAccessTime;
    FILETIME ftLastWriteTime;
    DWORD    nFileSizeHigh;
    DWORD    nFileSizeLow;
    DWORD    dwReserved0;
    DWORD    dwReserved1;
    CHAR     cFileName[260];
    CHAR     cAlternateFileName[14];
  } WIN32_FIND_DATAA, *PWIN32_FIND_DATAA;
]]))

ffi.cdef[[
    
    typedef int(__thiscall* get_current_adapter_fn)(void*);
    typedef void(__thiscall* get_adapters_info_fn)(void*, int adapter, struct mask& info);
    typedef bool(__thiscall* file_exists_t)(void* this, const char* pFileName, const char* pPathID);
    typedef long(__thiscall* get_file_time_t)(void* this, const char* pFileName, const char* pPathID);
    typedef unsigned UINT;
    typedef unsigned DWORD;
    typedef struct {
        int cBytes;
        int fFixedDisk;
        char nErrCode;
        char Reserved1;
        char Reserved2;
        char szPathName;
    }OFSTRUCT, *LPOFSTRUCT, *POFSTRUCT;
    /*typedef struct _FILETIME {
        DWORD dwLowDateTime;
        DWORD dwHighDateTime;
    } FILETIME, *PFILETIME;
    typedef struct _WIN32_FIND_DATAA {
        DWORD    dwFileAttributes;
        FILETIME ftCreationTime;
        FILETIME ftLastAccessTime;
        FILETIME ftLastWriteTime;
        DWORD    nFileSizeHigh;
        DWORD    nFileSizeLow;
        DWORD    dwReserved0;
        DWORD    dwReserved1;
        char     cFileName[260];
        char     cAlternateFileName[14];
      } WIN32_FIND_DATAA, *PWIN32_FIND_DATAA;*/
    bool CreateDirectoryA(const char *path, void *lpSecurityAttributes);
    bool DeleteFileA(const char* lpFileName);
    int CopyFileA(const char* lpExistingFileName, const char* lpNewFileName, int bFailIfExists);
    unsigned int GetFileSize(unsigned int HFile, void* FileSizeHigh);
    unsigned int OpenFile(const char* lpFileName, OFSTRUCT lpReOpenBuff, UINT uStyle);
    unsigned int CreateFileA(const char* lpFileName, DWORD dwDesiredAccess, DWORD dwShareMode, void* lpSecurityAttributes, DWORD dwCreationDisposition, DWORD dwFlagsAndAttributes, void* hTemplateFile);
    unsigned int __stdcall FindFirstFileA(const char* pattern, WIN32_FIND_DATAA* fd);
    int    __stdcall FindNextFileA(unsigned int ff, WIN32_FIND_DATAA* fd);
    int    __stdcall FindClose(unsigned int ff);
    int AddFontResourceA(const char* unnamedParam1);
    bool RemoveFontResourceA(const char* lpFileName);
    bool DeleteUrlCacheEntryA(const char* lpszUrlName);
    void* __stdcall URLDownloadToFileA(void* LPUNKNOWN, const char* LPCSTR, const char* LPCSTR2, int a, int LPBINDSTATUSCALLBACK); 
]]

--[[local ret = ffi.new("WIN32_FIND_DATAA")
--local x = ffi.C.FindFirstFileA("D:\\Program Files (x86)\\Steam\\steamapps\\common\\Counter-Strike Global Offensive\\Opium\\Sounds\\Player\\*", ret)
local x = ffi.C.FindFirstFileA(".\\Opium\\Sounds\\Player\\*", ret)
local y = ffi.C.FindNextFileA(x, ret)
local last = ""

while last ~= ffi.string(ret.cFileName) do
  last = ffi.string(ret.cFileName)
  y = ffi.C.FindNextFileA(x, ret)
  if last ~= ffi.string(ret.cFileName) then
    print(ffi.string(ret.cFileName))
  end
end

ffi.C.FindClose(x)]]

local urlmon = ffi.load 'UrlMon'
local wininet = ffi.load 'WinInet'
local gdi = ffi.load 'Gdi32'
general = {}
general.version = "v1.01"
general.date = "17.10.2023"
general.downloaded = 0
general.all_down = 0
intro = {}
intro.string = "Preparing..."
intro.color = "FFFFFFFF"
notf = {}
notf.array = {}
notf.add = function(icon, ...)
    table.insert(notf.array, 1, {icon = ui.get_icon(icon), segments = {...}, duration = 7, alpha = 0.1, pos = 0})
end
--notf.add("barcode", {"This is a ", false}, {"notification", true}, {" testing sequence", false})
notf.distance = 0
notf.offset = 0

DownloadFile = function(from, to)
    if loaded then return end
    wininet.DeleteUrlCacheEntryA(from)
    general.all_down = general.all_down + 1
    --utils.execute_after(0.1, function()
        general.downloaded = general.downloaded + 1
        --print_raw("\aFFFFFFFFDownloaded \a"..intro.color..general.downloaded.."\aFFFFFFFF out of \a"..intro.color..general.all_down.."\aFFFFFFFF files...")
        --intro.string = "\aFFFFFFFFDownloaded \a"..intro.color..general.downloaded.."\aFFFFFFFF out of \a"..intro.color..general.all_down.."\aFFFFFFFF files..."
        if files.read(to) == nil then
            urlmon.URLDownloadToFileA(nil, from, to, 0,0)
        end
        if general.downloaded == general.all_down then
            --print_raw("\a"..intro.color.."All files downloaded. Welcome to Opium.sys "..general.version.."!")
            intro.string = "Welcome to ".."\a"..intro.color.."Opium".."\aDEFAULT (".."\a"..intro.color..general.version.."\aDEFAULT), ".."\a"..intro.color..common.get_username().."\aDEFAULT!"
        end
    --end)
end
files.create_folder("Opium")
files.create_folder("Opium/Configs")
files.create_folder("Opium/Fonts")
files.create_folder("Opium/Sounds")
files.create_folder("Opium/Sounds/Death")
files.create_folder("Opium/Sounds/Kill")
files.create_folder("Opium/Sounds/Miss")
files.create_folder("Opium/Sounds/Music")
files.create_folder("Opium/Clantags")
files.create_folder("Opium/Messages")
files.create_folder("Opium/Messages/Death")
files.create_folder("Opium/Messages/Kill")
files.create_folder("Opium/Messages/Miss")

DownloadFile("https://github.com/whyisiugentaken/iugenscript-resources/blob/main/fonts/smallest_pixel-7.ttf?raw=true", "Opium/Fonts/smallest_pixel-7.ttf")
DownloadFile("https://github.com/whyisiugentaken/opium-resources/raw/main/fonts/BaseNeueTrial-WideMedium.ttf", "Opium/Fonts/BaseNeueTrial-WideMedium.ttf")
DownloadFile("https://github.com/whyisiugentaken/opium-resources/raw/main/fonts/Gothic War.otf", "Opium/Fonts/Gothic War.otf")
DownloadFile("https://github.com/whyisiugentaken/opium-resources/raw/main/fonts/weaponicons.ttf", "Opium/Fonts/weaponicons.ttf")
DownloadFile("https://github.com/whyisiugentaken/opium-resources/raw/main/fonts/weaponfont.ttf", "Opium/Fonts/bombfont.ttf")
DownloadFile("https://github.com/whyisiugentaken/opium-resources/raw/main/fonts/AudiTypeExtendedBold.ttf", "Opium/Fonts/AudiTypeExtendedBold.ttf")
DownloadFile("https://github.com/whyisiugentaken/opium-resources/raw/main/fonts/AudiTypeVF.ttf", "Opium/Fonts/AudiTypeVF.ttf")
DownloadFile("https://github.com/whyisiugentaken/opium-resources/raw/main/fonts/Helvetica.ttf", "Opium/Fonts/Helvetica.ttf")

DownloadFile("https://github.com/whyisiugentaken/opium-resources/blob/main/vwhs.wav?raw=true", "csgo/sound/vwhs.wav")
DownloadFile("https://github.com/whyisiugentaken/opium-resources/blob/main/vwbaim.wav?raw=true", "csgo/sound/vwbaim.wav")

DownloadFile("https://github.com/whyisiugentaken/opium-resources/blob/main/logo.png?raw=true", "Opium/logo.png")

DownloadFile("https://github.com/whyisiugentaken/opium-resources/raw/main/Sounds/Death/chat%202.wav", "Opium/Sounds/Death/chat 2.wav")
DownloadFile("https://github.com/whyisiugentaken/opium-resources/raw/main/Sounds/Kill/chat%201.wav", "Opium/Sounds/Kill/chat 1.wav")
DownloadFile("https://github.com/whyisiugentaken/opium-resources/raw/main/Sounds/Miss/whizzing.wav", "Opium/Sounds/Miss/whizzing.wav")
DownloadFile("https://github.com/whyisiugentaken/opium-resources/raw/main/Sounds/Music/tacobell_short.wav", "Opium/Sounds/Music/tacobell_short.wav")

--[[::wait::
if general.downloaded ~= general.all_down then goto wait end]]

--[[gdi.AddFontResourceA("Opium/Fonts/smallest_pixel-7.ttf")
gdi.AddFontResourceA("Opium/Fonts/BaseNeueTrial-WideMedium.ttf")
gdi.AddFontResourceA("Opium/Fonts/Gothic War.otf")
--gdi.AddFontResourceA("Opium/Fonts/bahnschrift.ttf")
--gdi.AddFontResourceA("Opium/Fonts/ebrima.ttf")

events.shutdown:set(function()
    gdi.RemoveFontResourceA("Opium/Fonts/smallest_pixel-7.ttf")
    gdi.RemoveFontResourceA("Opium/Fonts/BaseNeueTrial-WideMedium.ttf")
    gdi.RemoveFontResourceA("Opium/Fonts/Gothic War.otf")
    --gdi.RemoveFontResourceA("Opium/Fonts/bahnschrift.ttf")
    --gdi.RemoveFontResourceA("Opium/Fonts/ebrima.ttf")
end)]]

local WeaponDefinitionIndex = {
    [1] = {0, 'Deagle', 'A'},
    [2] = {1, 'Dual Berettas', 'B'},
    [3] = {1, 'Five-Seven', 'C'},
    [4] = {1, 'Glock-18', 'D'},
    [7] = {5, 'AK-47', 'W'},
    [8] = {5, 'AUG', 'U'},
    [9] = {4, 'AWP', 'Z'},
    [10] = {5, 'Famas', 'R'},
    [11] = {2, 'G3SG1', 'X'},
    [13] = {5, 'Galil AR', 'Q'},
    [14] = {8, 'M249', 'g'},
    [16] = {5, 'M4A4', 'S'},
    [17] = {6, 'MAC-10', 'K'},
    [19] = {6, 'P90', 'P'},
    [20] = {nil, 'Repulsor Device'},
    [23] = {6, 'MP5-SD'},
    [24] = {6, 'UMP-45', 'L'},
    [25] = {7, 'XM1014', 'b'},
    [26] = {6, 'PP-Bizon', 'M'},
    [27] = {7, 'MAG-7', 'd'},
    [28] = {8, 'Negev', 'f'},
    [29] = {7, 'Sawed-Off', 'c'},
    [30] = {1, 'Tec-9', 'H'},
    [31] = {nil, 'Zeus x27', 'h'},
    [32] = {1, 'P2000', 'F'},
    [33] = {6, 'MP7', 'N'},
    [34] = {6, 'MP9', 'O'},
    [35] = {7, 'Nova', 'e'},
    [36] = {1, 'P250', 'E'},
    [37] = {nil, 'Riot Shield'},
    [38] = {2, 'SCAR-20', 'Y'},
    [39] = {5, 'SG 553', 'V'},
    [40] = {3, 'SSG 08', 'a'},
    [41] = {nil, 'Knife', '['},
    [42] = {nil, 'Knife', '['},
    [43] = {nil, 'Flashbang', 'i'},
    [44] = {nil, 'High Explosive Grenade', 'j'},
    [45] = {nil, 'Smoke Grenade', 'k'},
    [46] = {nil, 'Molotov', 'l'},
    [47] = {nil, 'Decoy Grenade', 'm'},
    [48] = {nil, 'Incendiary Grenade', 'n'},
    [49] = {nil, 'C4 Explosive', 'o'},
    [50] = {nil, 'Kevlar Vest'},
    [51] = {nil, 'Kevlar + Helmet'},
    [52] = {nil, 'Heavy Assault Suit'},
    [54] = {nil, 'item_nvg'},
    [55] = {nil, 'Defuse Kit'},
    [56] = {nil, 'Rescue Kit'},
    [57] = {nil, 'Medi-Shot'},
    [58] = {nil, 'Music Kit'},
    [59] = {nil, 'Knife'},
    [60] = {5, 'M4A1-S', 'T'},
    [61] = {1, 'USP-S', 'G'},
    [62] = {nil, 'Trade Contract'},
    [63] = {1, 'CZ75', 'I'},
    [64] = {0, 'R8 Revolver', 'J'},
    [68] = {nil, 'Tactical Awareness Grenade'},
    [69] = {nil, 'Bare Hands'},
    [70] = {nil, 'Breach Charge'},
    [72] = {nil, 'Tablet'},
    [74] = {nil, 'Knife'},
    [75] = {nil, 'Axe'},
    [76] = {nil, 'Hammer'},
    [78] = {nil, 'Wrench'},
    [80] = {nil, 'Spectral Shiv'},
    [81] = {nil, 'Fire Bomb'},
    [82] = {nil, 'Diversion Device'},
    [83] = {nil, 'Frag Grenade'},
    [84] = {nil, 'Snowball'},
    [85] = {nil, 'Bump Mine'},
    [500] = {nil, 'Bayonet', '1'},
    [503] = {nil, 'Classic Knife', ']'},
    [505] = {nil, 'Flip Knife', '2'},
    [506] = {nil, 'Gut Knife', '3'},
    [507] = {nil, 'Karambit', '4'},
    [508] = {nil, 'M9 Bayonet', '5'},
    [509] = {nil, 'Huntsman Knife', '6'},
    [512] = {nil, 'Falchion Knife', '0'},
    [514] = {nil, 'Bowie Knife', '7'},
    [515] = {nil, 'Butterfly Knife', '8'},
    [516] = {nil, 'Shadow Daggers', '9'},
    [517] = {nil, 'Paracord Knife', ']'},
    [518] = {nil, 'Survival Knife', ']'},
    [519] = {nil, 'Ursus Knife', ']'},
    [520] = {nil, 'Navaja Knife', ']'},
    [521] = {nil, 'Nomad Knife', ']'},
    [522] = {nil, 'Stiletto Knife', ']'},
    [523] = {nil, 'Talon Knife', ']'},
    [525] = {nil, 'Skeleton Knife', ']'}
}

local function vmt_entry(instance, index, type)
    return ffi.cast(type, (ffi.cast("void***", instance)[0])[index])
end

local function vmt_thunk(index, typestring)
    local t = ffi.typeof(typestring)
    return function(instance, ...)
        assert(instance ~= nil)
        if instance then
            return vmt_entry(instance, index, t)(instance, ...)
        end
    end
end

function clamp(val, lower, upper)
    --assert(val and lower and upper, "not very useful error message here")
    if lower > upper then lower, upper = upper, lower end -- swap if boundaries supplied the wrong way
    return math.max(lower, math.min(upper, val))
end

function sign(val)
    if val < 0 then
        return -1
    elseif val >= 0 then
        return 1
    end
end

local lerp = function(a, b, t)
    local t2 = math.min(t * globals.frametime, 10)
    if (b > a and a > (b * 0.98)) then return b end
    if (a > b and a < (b * 0.02)) then return b end
    return clamp(a + (b - a) * t2, a, b)
    --return a + (b - a) * t2
end

local lerp2 = function(a, b, t)
    return a + (b - a) * t
end

local lerp_color = function(start, end_pos, time)
    local r, g, b, a = start.r, start.g, start.b, start.a
    local e_r, e_g, e_b, e_a = end_pos.r, end_pos.g, end_pos.b, end_pos.a
    r = math.floor(lerp(r, e_r, time))
    g = math.floor(lerp(g, e_g, time))
    b = math.floor(lerp(b, e_b, time))
    a = math.floor(lerp(a, e_a, time))
    return color(r, g, b, a)
end

--[[local function lighten(kolor, value)
    local r = kolor.r
    local g = kolor.g
    local b = kolor.b
    local a = kolor.a

    r = math.min(255, math.floor((r + 255) * (value * 0.01)))
    g = math.min(255, math.floor((g + 255) * (value * 0.01)))
    b = math.min(255, math.floor((b + 255) * (value * 0.01)))
    --r = math.min(r+value, 255)
    --g = math.min(g+value, 255)
    --b = math.min(b+value, 255)

    return color(r, g, b, a)
end]] --generaly using value = 45 or 60

local lighten = function(kolor, value, sat)
    local h, s, l = kolor:to_hsl()
    local sat = sat and sat or 0
    --s = s + sat * 0.01
    l = l + (1-l) * 0.01 * value
    local col = color(255, 255, 255, kolor.a)
    local col = col:as_hsl(h, s, l)
    return color(col.r, col.g, col.b, kolor.a)
end --generally using value = 15 or 20
--changed to 50

local lighten_hsv = function(kolor, value, sat)
    local h, s, v = kolor:to_hsv()
    local sat = sat and sat or 0
    --s = s + sat * 0.01
    v = v + v * 0.01 * value
    local col = color(255, 255, 255, kolor.a)
    local col = col:as_hsv(h, s, v)
    return color(col.r, col.g, col.b, kolor.a)
end

local function grayscale(kolor)
    local h, s, v = kolor:to_hsv()
    local col = color(255, 255, 255, kolor.a)
    local col = col:as_hsv(h, 0, v * 0.5)
    return color(col.r, col.g, col.b, kolor.a)
end

local function darken(kolor, value)
    local r = kolor.r
    local g = kolor.g
    local b = kolor.b
    local a = kolor.a

    r = math.max(0, math.floor(r * (value * 0.01)))
    g = math.max(0, math.floor(g * (value * 0.01)))
    b = math.max(0, math.floor(b * (value * 0.01)))
    --r = math.min(r+value, 255)
    --g = math.min(g+value, 255)
    --b = math.min(b+value, 255)

    return color(r, g, b, a)
end

local function concolor(kolor)
    return string.sub(kolor:to_hex(), 1, 6)
end

local function changecol(kolor)
    local h, s, v = kolor:to_hsv()
    h = h - 0.15
    if (h<0) then h = 1 - h elseif (h>1) then h = h - 1 end
    local col = color(255, 255, 255)
    local col = col:as_hsv(h, s, v)
    return color(col:unpack())
end

local function textcol(kolor)
    return "\a"..kolor:to_hex()
end

local function ticks_to_time(value)
    return value * globals.tickinterval
end

local titles = {}

ui.create_gr = function(tab, name, column)
    local item = ui.create_e(tab, name, column)
    table.insert(titles, {item = item[1], name = name})
    return item
end

local fonts = {
    --default_font = render.load_font("tahoma", 13),
    --default_font = render.load_font("verdana", 11, "d"),
    --header_font = render.load_font("verdana", 11, "d"),
    default_font_bak = render.load_font("arial", vector(11, 11, 0), "ad"),
    default_font = render.load_font("arial", vector(11, 11, 0), "ad"),
    header_font = render.load_font("arial", vector(11, 11, 0), "ad"),
    --default_font_bak = 1,
    --grunge = render.load_font("grunge", vector(19, 19, 0), "a d"),
    --default_font_bak = render.load_font("angel wish", vector(15, 15, 0), "ad"),
    edgy = render.load_font("Opium/Fonts/Gothic War.otf", vector(18, 17, 0), "ad"),
    indedgybig = render.load_font("Opium/Fonts/Gothic War.otf", vector(18, 17, 0), "ad"),
    indedgysmall = render.load_font("Opium/Fonts/Gothic War.otf", vector(16, 15, 0), "ad"),
    asterisk = render.load_font("bahnschrift", 72, "a"),
    modern_header = render.load_font("Arial Bold", 13, "a"),
    modern_ind = render.load_font("Opium/Fonts/Helvetica.ttf", vector(15, 10, -1), "ab"),
    modern = render.load_font("Bahnschrift", vector(13, 12, 0), "a"),
    audi_wide = render.load_font("Opium/Fonts/AudiTypeExtendedBold.ttf", 11, "a"),
    audi = render.load_font("Opium/Fonts/AudiTypeVF.ttf", vector(12, 11, 0), "a"),
    modern_dmg = render.load_font("Arial", vector(8, 9, 0), "a b"),
    --modern_icons = render.load_font("OpiumIcons", 18, "a"),
    modern_icons = render.load_font("Arial", 18, "a"),
    ebrimabig = render.load_font("Ebrima", vector(14, 13, 0)),
    ebrimasmall = render.load_font("Ebrima", 12),
    --noto_semi_bold = render.load_font( "Noto Sans SemiBold", 18, "a d" ),
    pixel = render.load_font("Opium/Fonts/smallest_pixel-7.ttf", 14, "a d o"),
    pixelretro = render.load_font("Opium/Fonts/smallest_pixel-7.ttf", 13, "a d"),
    pixelretro_o = render.load_font("Opium/Fonts/smallest_pixel-7.ttf", 13, "o d"),
    pixelretromed = render.load_font("Opium/Fonts/smallest_pixel-7.ttf", vector(11, 10, 0), "o d"),
    pixelretrosmall = render.load_font("Opium/Fonts/smallest_pixel-7.ttf", vector(11, 10, 0), "a d"),
    pixelsmall = render.load_font("Opium/Fonts/smallest_pixel-7.ttf", vector(11, 10, 0), "a d o"),
    smallind_main = render.load_font("Opium/Fonts/BaseNeueTrial-WideMedium.ttf", vector(8, 8, 3), "a d o"),
    smallind = render.load_font("Opium/Fonts/BaseNeueTrial-WideMedium.ttf", vector(8, 8, 1), "a d o"),
    velocity_font = render.load_font( "tahoma", vector(11, 10, 0), "d" ),
    modern_velocity_font = render.load_font( "Calibri", vector(13, 12, 0), "b a" ),
    skeetind = render.load_font("Calibri Bold", vector(23, 22, 0), "a"),
    bomb = render.load_font("Opium/Fonts/bombfont.ttf", 26, "a"),
    wep_icons = render.load_font("Opium/Fonts/weaponicons.ttf", 16, "a"),
}

local_player = {}

local square = math.sqrt;

function length(self)
    local x, y, z = self.x, self.y, self.z
    return square(x*x+y*y+z*z)
end

function dist_to(a, b)
    local x, y, z = a.x-b.x, a.y-b.y, a.z-b.z
    return square(x*x+y*y+z*z)
end

math_closest_point_on_ray = function(ray_from, ray_to, desired_point)
    local to = desired_point - ray_from
    local direction = ray_to - ray_from
    local ray_length = length(direction)

    direction.x = direction.x / ray_length
    direction.y = direction.y / ray_length
    direction.z = direction.z / ray_length

    local direction_along = direction.x * to.x + direction.y * to.y + direction.z * to.z
    if direction_along < 0 then return ray_from end
    if direction_along > ray_length then return ray_to end

    return vector(ray_from.x + direction.x * direction_along, ray_from.y + direction.y * direction_along, ray_from.z + direction.z * direction_along)
end

get_trace = function(length)
    local player = entity.get_local_player()
    if not player then 
        return end
        
    local x, y, z = player["m_vecOrigin"].x, player["m_vecOrigin"].y, player["m_vecOrigin"].z

    for a = 0, math.pi * 2, math.pi * 2 / 8 do
        local ptX, ptY = ((10 * math.cos( a ) ) + x), ((10 * math.sin( a ) ) + y)
        local trace = utils.trace_line(vector(ptX, ptY, z), vector(ptX, ptY, z-length), entity.get_local_player())
        local fraction, entity = trace.fraction, trace.entity

        if fraction ~= 1 then 
            return true
        end
    end
    return false
end

local function ListFiles(path)
    local second_time_load = false
    ::try_again::
    local works, ret = pcall(function()
        local ret = second_time_load and ffi.new("WIN32_FIND_DATAA") or ffi.new("struct WIN32_FIND_DATAA")
        local x = ffi.C.FindFirstFileA(path.."/*", ret)
        local y = ffi.C.FindNextFileA(x, ret)
        local last, index, tab = "", 1, {}
        
        while last ~= ffi.string(ret.cFileName) do
          last = ffi.string(ret.cFileName)
          y = ffi.C.FindNextFileA(x, ret)
          if last ~= ffi.string(ret.cFileName) then
            tab[index] = ffi.string(ret.cFileName)
            index = index + 1
          end
        end

        ffi.C.FindClose(x)
        return tab
    end)

    --[[if (_DEBUG and (not works or second_time_load)) then
        print((second_time_load and '2' or '1') .. ', ' .. (works and 'true' or 'false') .. ': ' .. tostring(ret))
    end]]

    if second_time_load and not works then return end
    if works then return ret end
    second_time_load = true
    goto try_again
end

local voice_inputfromfile = cvar.voice_inputfromfile:int()
local voice_loopback = cvar.voice_loopback:int()
local voice_mixer_volume = cvar.voice_mixer_volume:float()

local estimated_end_time = -1

local function estimate_length(filename)
	--local file1, file2 = readfile(filename, "t")
    ----local toolvar = ffi.new("OFSTRUCT")
    ----local file = ffi.C.OpenFile(filename, toolvar, ffi.C.OF_READ)
    local file = ffi.C.CreateFileA(filename, 0, FILE_SHARE_READ, nil, OPEN_ALWAYS, FILE_ATTRIBUTE_READONLY, nil)
    --print(ffi.C.GetFileSize(file, nil))
    --print(file2)
	local estimated_time = ffi.C.GetFileSize(file, nil) / 44100
	--file:close()
	return estimated_time
    --return 50
end

local function replace_file(with, at)
	ffi.C.CopyFileA(with, at, 0)
end

local function play_file(filename)
    if not globals.is_in_game then return end
	replace_file(filename, "voice_input.wav")
	cvar.voice_inputfromfile:int(1)
	utils.console_exec("+voicerecord")
	cvar.voice_loopback:int(1)
    cvar.voice_mixer_volume:float(misc.music_volume:get()/100)
	estimated_end_time = globals.curtime + estimate_length("voice_input.wav")
    misc.music_playing = true
    misc.music_play:name("   "..ui.get_icon("stop").."   ")
end

entity_helpers = {}
entity_helpers.local_player = {}

entity_helpers.local_player.last_time = -1
entity_helpers.local_player.cached = {ptr = nil, index = -1}
entity_helpers.local_player.pointer = function()

    if entity_helpers.local_player.last_time == globals.tickcount then
        return entity_helpers.local_player.cached.ptr
    end

    entity_helpers.local_player.cached.ptr = entity.get_local_player()

    if entity_helpers.local_player.cached.ptr then
        entity_helpers.local_player.cached.index = entity_helpers.local_player.cached.ptr:get_index()
    else
        entity_helpers.local_player.cached.index = -1
    end

    entity_helpers.local_player.last_time = globals.tickcount

    return entity_helpers.local_player.cached.ptr
end

local_player.desync_angle = function(round)

    local ptr = entity.get_local_player()

    if not ptr then
        return 0
    end

    local degree = math.normalize(rage.antiaim:get_rotation() - ptr.m_angEyeAngles.y)

    if not round then
        return tonumber(string.format("%.2f", (clamp(degree, -rage.antiaim:get_max_desync(), rage.antiaim:get_max_desync()))))
    end

    return math.round(tonumber(string.format("%.2f", (clamp(degree, -rage.antiaim:get_max_desync(), rage.antiaim:get_max_desync())))))
end

ffi.cdef[[
    typedef struct {
        float x, y, z;
    } vector_struct_t;

    typedef int(__thiscall* c_weapon_get_muzzle_attachment_index_first_person_t)(uintptr_t*, uintptr_t*);
    typedef bool(__thiscall* c_entity_get_attachment_t)(uintptr_t*, int, vector_struct_t*);
]]

get_muzzle_position = function()
    local lp = entity.get_local_player()
    if not lp then return vector(0,0,0) end
    if not lp.m_hActiveWeapon then return vector(0,0,0) end
    local Weapon_Address = lp.m_hActiveWeapon[0]
    if not lp.m_hViewModel then return vector(0,0,0) end
    local wep = lp:get_player_weapon():get_weapon_index()
    if not WeaponDefinitionIndex[wep][1] then return vector(0,0,0) end
    local Viewmodel_Address = lp.m_hViewModel[0][0]
    local Position = ffi.new("vector_struct_t[1]")
    local c_entity_get_attachment_t = ffi.cast("c_entity_get_attachment_t", ffi.cast(ffi.typeof("uintptr_t**"), Viewmodel_Address)[0][84])
    local c_weapon_get_muzzle_attachment_index_first_person_t = ffi.cast("c_weapon_get_muzzle_attachment_index_first_person_t", ffi.cast(ffi.typeof("uintptr_t**"), Weapon_Address)[0][468])
    local first_person_ret = c_weapon_get_muzzle_attachment_index_first_person_t(ffi.cast('uintptr_t*', Weapon_Address), ffi.cast('uintptr_t*', Viewmodel_Address))
    c_entity_get_attachment_t(ffi.cast('uintptr_t*', Viewmodel_Address), first_person_ret, Position)
    return render.world_to_screen(vector(Position[0].x, Position[0].y, Position[0].z))
end

local clipboard = require("neverlose/clipboard")
local base64 = require("neverlose/base64")

local update_aa_cfgs = function()
    local list  = {
        [1] = {ui.get_icon("empty-set"), "   Cheat settings"}
    }
    if menu_cfg_labels["Anti Aim"].access then
        list[2] = {ui.get_icon("wrench"), "   Custom builder"}
    else
        list[2] = {ui.get_icon("file-shield"), "   "..cfg.hidname:get()}
    end
    for k, v in pairs(menu_colored_items) do
        if v.item == aa.cfg then
            v.list = list
            aa.cfg:set(aa.cfg:get())
            return
        end
    end
end

local update_cfg_labels = function()
    for x, y in pairs(menu_cfg_labels) do
        y.access = not (((x == "Rage" and cfg.hidaim:get()) or (x == "Anti Aim" and cfg.hidaa:get())) and common.get_username() ~= cfg.hidusername:get())
        for k, v in pairs(y) do
            if k ~= "access" and ((x == "Rage" and cfg.hidaim:get()) or (x == "Anti Aim" and cfg.hidaa:get())) then
                v:visibility(true)
                if common.get_username() == cfg.hidusername:get() then
                    v:name("  "..ui.get_icon("info").."  You can see this menu because you're the creator of this config.")
                else
                    v:name("  "..(ui.get_icon("info").."  Some settings have been locked by the config creator."))
                end
            else
                if k ~= "access" then v:visibility(false) end
            end
        end
    end
end

function string.crypt(string,key,mode)
	local new_string = ""
	local pass = 0 
	for c_key = 1, #key do 
		pass = pass + string.byte(string.sub(key,c_key,c_key))
	end 

	if pass > 255 then
		pass =  math.floor(pass / (pass/255 +1))
	end

	if mode == 0 then 
		for encrypt = 1,#string do 
		    add_byte = string.byte(string.sub(string,encrypt,encrypt)) 
		    if add_byte + pass > 255 then 
		    	add_byte = add_byte + pass - 255
		    else
		    	add_byte = add_byte + pass
		    end
		    add_string = string.char(add_byte) 
		    new_string = new_string..add_string
	    end 
    elseif mode == 1 then 
		for decrypt = 1,#string do 
		    add_byte = string.byte(string.sub(string,decrypt,decrypt)) 
		    if add_byte - pass  < 0 then 
		    	add_byte = 255 + add_byte-pass 
		    else
		    	add_byte = add_byte - pass
		    end
		    add_string = string.char(add_byte) 
		    new_string = new_string..add_string
		end
	end
	string = nil 
	return new_string
end

local figkey = "69420"

files.write("Opium/Configs/default.fig", "default")

local config_export = function(name, username, operation)
    cfg.hidname:set(name)
    cfg.hidusername:set(common.get_username())
    local encoded_config = ""
    local protected = function()
        local cfg_data = {}
        for key, value in pairs(menu_items) do
            local itype = value:type()
            if itype ~= "button" and itype ~= "hotkey" and itype ~= "label" and itype ~= "image" then
                local ui_value = value:get()
                if type(ui_value) == "userdata" then
                    cfg_data[tostring(key)] = ui_value:to_hex()
                else
                    cfg_data[tostring(key)] = ui_value
                end
            end
        end
        cfg_data["loadusername"] = username
        cfg_data["loadname"] = name
        cfg_data["changedate"] = common.get_system_time().day..'.'..common.get_system_time().month..'.'..common.get_system_time().year
        local json_config = json.stringify(cfg_data)
        encoded_config = string.crypt(base64.encode(json_config), figkey, 0)--
        --print(string.crypt(encoded_config, figkey, 1))
        --clipboard.set("opiumsys_"..encoded_config)
        local past = operation == "save" and "saved" or operation == "export" and "exported"
        notf.add("check", {"Config ", false}, {name, true}, {" by ", false}, {username, true}, {" "..past.." successfully!", false})
    end
    --protected()
    local status, message = pcall(protected)
    if not status then
        notf.add("xmark", {"Config "..operation.." failed!", false})
        return
    end
    return "opiumsys_"..encoded_config
end

local config_load = function(text, operation)
    cfg.once = false
    local cfgname = ""
    local protected = function()
        if text == "default" then
            for key, value in pairs(menu_items) do
                local item = menu_items[tostring(key)]
                if item ~= nil then
                    item:reset()
                end
            end
            update_cfg_labels()
            notf.add("check", {"Default config loaded succesfully!", false})
        else
            local text = base64.decode(string.crypt(text, figkey, 1))
            local cfg_data = json.parse(text)
            if cfg_data ~= nil then
                for key, value in pairs(cfg_data) do
                    local item = menu_items[tostring(key)]
                    if item ~= nil then
                        local invalue = value
                        item:set(invalue)
                    end
                end
                cfgname = cfg_data["loadname"]
                cfg.name:set(cfgname)
                cfg.hidname:set(cfgname)
                cfg.hidusername:set(cfg_data["loadusername"])
                cfg.hiddate:set(cfg_data["changedate"])
                update_cfg_labels()
                notf.add("check", {"Config ", false}, {cfg_data["loadname"], true}, {" by ", false}, {cfg_data["loadusername"], true}, {" "..operation.."ed successfully!", false})
            end
        end
    end

    local status, message = pcall(protected)
    if not status then
        notf.add("xmark", {"Config "..operation.." failed!", false})
        return
    end

    return cfgname
end

menucolor = color(180, 140, 255)
menucolor2 = changecol(menucolor)

general.opium = ui.create_gr(ui.get_icon("house").." General", "> Opium")
local pic = render.load_image_from_file("./Opium/logo.png", vector(1000, 1000))
general.opium:texture_e(pic, vector(275, 275))
general.tabs = {ui.create_gr(ui.get_icon("house").." General", "> General info"), ui.create_gr(ui.get_icon("house").." General", "> Configurations", 2)}
general.vertab = general.tabs[1]
general.cfgtab = general.tabs[2]
general.items = {
    {ui.get_icon("circle-info"), "   General info"},
    {ui.get_icon("wrench"), "   Configurations"}
}
general.mlist = general.opium:menu_select(general.items, general.tabs)
--general.tab:label_e("helo")
--local pic = render.load_image(network.get("https://i.imgur.com/CvRVMbI.png"), vector(100, 100))
--local pic = render.load_image_from_file("C:/Users/corla/Downloads/bancuta.jpg", vector(300, 225))
general.welcome = general.vertab:label_e(textcol(menucolor)..ui.get_icon("loader")..gradient.text("   Opium "..general.version, false, {menucolor, menucolor2}).."\aDEFAULT loaded!")
general.update = general.vertab:label_e(textcol(menucolor)..ui.get_icon("calendar-days").."\aDEFAULT   Last update: "..gradient.text(general.date, false, {menucolor, menucolor2}))
general.idk = general.vertab:label_e(textcol(menucolor)..ui.get_icon("rocket-launch").."\aDEFAULT   Enjoy inginerie romaneasca!")
general.warn = general.vertab:label_e("\aFF5F15FF"..ui.get_icon("triangle-exclamation").."   Product in development. Some features may not work as intended.")
general.warn:tooltip("\aFF5F15FF".."Report any bugs encountered on the Discord server.")
general.spacer = general.vertab:label_e("")
general.auth = string.format("%x", math.random(1000000000000000, 4503599627370496))
general.discord = general.vertab:button_e(" \a7289DAFF"..ui.get_icon("discord").." Discord ", function()
    panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/KRqKv7qPmr")
    local data = discord_webhooks.new_data()
    local embeds = discord_webhooks.new_embed()

    data:set_avatar("https://github.com/whyisiugentaken/opium-resources/blob/main/logo_discord.jpg?raw=true")
    data:set_username("Opium.sys")
    data:set_content("Authentication code for user **"..common.get_username().."**")

    embeds:set_color(7973872) --- @note: only decimal colors
    embeds:set_description(general.auth)
    embeds:set_thumbnail("https://en.neverlose.cc/static/avatars/" ..common.get_username().. ".png", "", 64, 64)

    local url = "https://discord.com/api/webhooks/1148542039890341898/jHU-2vWxn0ugp5uNE06QLbzGgoFWS6fpfye--ZV0e37BdgyUraiwTihKXndIuOZJHNE8"
    discord_webhooks.new(url):send(data, embeds)
    clipboard.set(general.auth)
    notf.add("discord", {"Discord authentication code copied to clipboard and in console!", false})
    print_raw("Your Discord authentification code is \a7289DAFF"..general.auth.."\aDEFAULT.")
end, true)
general.youtube = general.vertab:button_e(" \aFF0000FF"..ui.get_icon("youtube").." iugen ", function() panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://www.youtube.com/channel/UCX64Qxe3kc5yCkAbViLwvvQ") end, true)
general.changelog = general.vertab:button_e(textcol(menucolor).." "..ui.get_icon("clipboard").."\aDEFAULT Changelog ", function() panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.com/channels/1148540509904711720/1160479360432750633") end, true)
--[[local cfg = ""
local vtypes = {}
general.export = general.vertab:button_e("export", function()
    for _, v in pairs(menu_items) do
        local itype = v:type()
        if itype ~= "button" and itype ~= "hotkey" and itype ~= "label" and itype ~= "image" then
            local value = v:get()
            local vtype = type(value)
            if vtype == "table" then
                cfg = cfg..'{'
                for _, y in pairs(value) do
                    cfg = cfg.."\""..y.."\""..", "
                end
                cfg = cfg..'}'..'\n'
            end
            vtypes[vtype] = v
            --cfg = cfg..v:get()..'\n'
        end
    end
    for k, v in pairs(vtypes) do
        if k == "userdata" then
            --print(v:get())
        end
    end
    print(cfg)
    --files.write("Opium/Configs/cfg.txt", cfg)
end)]]

cfg = {}
cfg.once = false

cfg.list = general.cfgtab:list_e("Select config:", {})
cfg.load = general.cfgtab:button_col("  "..ui.get_icon("download"), "  Load  ", function() config_load(files.read("Opium/Configs/"..cfg.list:list()[cfg.list:get()]..".fig"):gsub("opiumsys_", ""), "load") end, true)
cfg.save = general.cfgtab:button_col("  "..ui.get_icon("floppy-disk"), "  Save  ", nil, true)
cfg.refresh = general.cfgtab:button_col("  "..ui.get_icon("arrows-rotate"), "  Refresh  ", nil, true)
cfg.delete = general.cfgtab:button_col("  "..ui.get_icon("trash"), "  Delete config  ", nil, true)
cfg.delete_sure = general.cfgtab:label_e("Are you sure?")
cfg.delete_yes = general.cfgtab:button_col("  "..ui.get_icon("check"), "   Yes  ", nil, true)
cfg.delete_no = general.cfgtab:button_col("  "..ui.get_icon("xmark"), "   No  ", nil, true)
cfg.delete_sure:visibility(false)
cfg.delete_yes:visibility(false)
cfg.delete_no:visibility(false)
cfg.restrict = general.cfgtab:selectable_e("Lock settings", {})
cfg.restrict:visibility(false)
cfg.name = general.cfgtab:input_e("Name:", common.get_username().."'s config")
cfg.hidname = general.cfgtab:input_e("[DEBUG] Config name", common.get_username().."'s config")
cfg.hidname:visibility(false)
cfg.hidusername = general.cfgtab:input_e("[DEBUG] Config username", common.get_username())
cfg.hidusername:visibility(false)
cfg.hiddate = general.cfgtab:input_e("[DEBUG] Date", common.get_system_time().day..'.'..common.get_system_time().month..'.'..common.get_system_time().year)
cfg.hiddate:visibility(false)
cfg.hidaa = general.cfgtab:switch_e("[DEBUG] Lock AA")
cfg.hidaa:visibility(false)
cfg.hidaim = general.cfgtab:switch_e("[DEBUG] Lock Rage")
cfg.hidaim:visibility(false)
cfg.create = general.cfgtab:button_col(" "..ui.get_icon("file-plus"), "  Create ", function() files.write("Opium/Configs/"..cfg.name:get()..".fig", "default") end, true)
cfg.export = general.cfgtab:button_col(" "..ui.get_icon("file-export"), "  Export ", function() clipboard.set(config_export(cfg.name:get(), cfg.hidusername:get(), "export")) end, true)
cfg.import = general.cfgtab:button_col(" "..ui.get_icon("file-import"), "  Import ", function() cfg.name:set(config_load(clipboard.get():gsub("opiumsys_", "")), "import") end, true)

cfg.save:set_callback(function()
    local name = cfg.name:get()
    if cfg.list:list()[cfg.list:get()] ~= name then
        ffi.C.DeleteFileA("./Opium/Configs/"..cfg.list:list()[cfg.list:get()]..".fig")
    end
    files.write("Opium/Configs/"..name..".fig", config_export(name, cfg.hidusername:get(), "save"))
end)

cfg.delete:set_callback(function()
    cfg.delete_sure:visibility(true)
    cfg.delete_yes:visibility(true)
    cfg.delete_no:visibility(true)
    cfg.delete:visibility(false)
end)

cfg.delete_yes:set_callback(function()
    cfg.delete_sure:visibility(false)
    cfg.delete_yes:visibility(false)
    cfg.delete_no:visibility(false)
    cfg.delete:visibility(true)
    ffi.C.DeleteFileA("./Opium/Configs/"..cfg.list:list()[cfg.list:get()]..".fig")
end)

cfg.delete_no:set_callback(function()
    cfg.delete_sure:visibility(false)
    cfg.delete_yes:visibility(false)
    cfg.delete_no:visibility(false)
    cfg.delete:visibility(true)
end)

cfg.restrict_update_func = function()
    if common.get_username() == cfg.hidusername:get() then
        cfg.restrict:update({"Anti Aim", "Rage"})
        cfg.restrict:visibility(true)
    else
        local list = {}
        if not cfg.hidaa:get() then list[#list+1] = "Anti Aim" end
        if not cfg.hidaim:get() then list[#list+1] = "Rage" end
        cfg.restrict:update(list)
        cfg.restrict:set({})
        if #list == 0 then cfg.restrict:visibility(false) else cfg.restrict:visibility(true) end
    end
end

cfg.restrict:set_callback(function(ref)
    local list = ref:list()
    for k, v in pairs(list) do
        if v == "Anti Aim" then cfg.hidaa:set(ref:get("Anti Aim"))
        elseif v == "Rage" then cfg.hidaim:set(ref:get("Rage")) end
    end
end, true)

--cfg.restrict_update_func()

cfg.refresh_func = function()
    local filestab = ListFiles("./Opium/Configs")
    if not filestab then return end
    local list = {}
    for i=1, #filestab do
        local s = filestab[i]:sub(-4)
        if s == ".fig" then
            list[#list+1] = filestab[i]:sub(1, -5)
        end
    end
    cfg.list:update(list)
end
cfg.list:set_callback(function() cfg.refresh_func() end, true)
cfg.load:set_callback(function() cfg.refresh_func() end, true)
cfg.save:set_callback(function() cfg.refresh_func() end, true)
cfg.refresh:set_callback(function() cfg.refresh_func() end, true)
cfg.delete_yes:set_callback(function() cfg.refresh_func() end, true)
cfg.delete_no:set_callback(function() cfg.refresh_func() end, true)
cfg.restrict:set_callback(function() update_cfg_labels() end, true)
cfg.hidaa:set_callback(function() update_cfg_labels() end, true)
cfg.hidaim:set_callback(function() update_cfg_labels() end, true)
cfg.create:set_callback(function() cfg.refresh_func() end, true)
cfg.export:set_callback(function() cfg.refresh_func() end, true)
cfg.import:set_callback(function() cfg.refresh_func() end, true)

--[[cfg.list:set_callback(function(ref)
    if not ref:list()[1] then 
        local filestab = ListFiles("./Opium/Configs")
        if not filestab then return end
        ref:update(filestab) 
    end
    if not ref:list()[1] then return end
    local index = 1
    local list = files.read("Opium/Configs/"..ref:list()[ref:get()])
    ffi.C.CreateDirectoryA(".Opium/Configs/", nil)
end, true)]]

--ui.sidebar(gradient.text("Opium (pre-alpha)", false, {menucolor, menucolor2}), "bolt")
sidetext = gradient.text_animate("Opium ("..general.version..")", 1, {menucolor, menucolor2})
--sidetext = gradient.text("Opium ("..general.version..")", false, {menucolor, menucolor2})
--welcome_text = ""

local update_texts = function(uicol)
    local menucol = color(uicol:unpack())
    menucol.a = 255
    local menucol2 = lighten(menucol, 50)
    local name = ""
    for i=1, #titles do
        name = gradient.text(titles[i].name, false, {menucol, lighten(menucol, 45)})
        titles[i].item:name(name)
    end
    --sidetext = gradient.text("Opium ("..general.version..")", false, {menucol, menucol2})
    sidetext:set_colors({lighten_hsv(menucol, -30), menucol2})
    general.welcome:name(textcol(menucol)..ui.get_icon("loader")..gradient.text("   Opium "..general.version, false, {menucol, menucol2}).."\aDEFAULT loaded!")
    general.update:name(textcol(menucol)..ui.get_icon("calendar-days").."\aDEFAULT   Last update: "..gradient.text(general.date, false, {menucol, menucol2}))
    general.idk:name(textcol(menucol)..ui.get_icon("rocket-launch").."\aDEFAULT   Enjoy inginerie romaneasca!")
    general.changelog:name(textcol(menucol)..ui.get_icon("clipboard").."\aDEFAULT Changelog")
end

local run_callbacks = function(uicol)
    local uicol = (visuals.uicol_select:get() == "Theme") and color(visuals.themecol:get().r, visuals.themecol:get().g, visuals.themecol:get().b) or visuals.uicol
    update_texts(uicol)
    for _, v in pairs(color_callbacks) do
        v()
    end
end

--update_texts(menucolor, menucolor2)

screensizex = render.screen_size().x
screensizey = render.screen_size().y

refs = {
    --binds
    thirdperson = ui.find("Visuals", "World", "Main", "Force Thirdperson"),
    scope = ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay"),
    --rage
    dormant = ui.find("Aimbot", "Ragebot" ,"Main", "Enabled", "Dormant Aimbot"),
    dt = {
        on = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"),
        lag = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"),
        max = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Fake Lag Limit"),
        tp = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Immediate Teleport"),
        qs = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Quick-Switch"),
    },
    hs = {
        on = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"),
        mode = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"),
    },
    ap = {
        on = ui.find("Aimbot", "Ragebot", "Main", "Peek Assist"),
        color = ui.find("Aimbot", "Ragebot", "Main", "Peek Assist", "Style"),
    },
    hitbox = ui.find("Aimbot", "Ragebot", "Selection", "Hitboxes"),
    multipoint = ui.find("Aimbot", "Ragebot", "Selection", "Multipoint"),
    mp_head = ui.find("Aimbot", "Ragebot", "Selection", "Multipoint", "Head Scale"),
    mp_body = ui.find("Aimbot", "Ragebot", "Selection", "Multipoint", "Body Scale"),
    dmg = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage"),
    delay = ui.find("Aimbot", "Ragebot", "Selection", "Min. Damage", "Delay Shot"),
    hc = ui.find("Aimbot", "Ragebot", "Selection", "Hit Chance"),
    hc_dt = ui.find("Aimbot", "Ragebot", "Selection", "Hit Chance", "Double Tap"),
    baim = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim"),
    baim_disablers = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim", "Disablers"),
    baim_fp = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim", "Force on Peek"),
    sp = ui.find("Aimbot", "Ragebot", "Safety", "Safe Points"),
    sp_force = ui.find("Aimbot", "Ragebot", "Safety", "Ensure Hitbox Safety"),
    strafe = ui.find("Miscellaneous", "Main", "Movement", "Air Strafe"),
    clantag = ui.find("Miscellaneous", "Main", "In-Game", "Clan Tag"),
    ping = ui.find("Miscellaneous", "Main", "Other", "Fake Latency"),
    --override = ui.find("Miscellaneous", "Main", "Movement", "Air Duck"),
    --antiaim
    aa = ui.find("Aimbot", "Anti Aim", "Angles", "Enabled"),
    sw = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"),
    fd = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"),
    pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"),
    legs = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"),
    yaw = {
        type = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"),
        base = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"),
        offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"),
        avoid = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab"),
        hidden = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden"),
    },
    modifier = {
        type = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"),
        offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"),
    },
    desync = {
        on = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"),
        invert = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"),
        limit_left = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"),
        limit_right = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"),
        options = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"),
        fs = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding"),
    },
    extend = {
        on = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles"),
        pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles", "Extended Pitch"),
        roll = ui.find("Aimbot", "Anti Aim", "Angles", "Extended Angles", "Extended Roll"),
    },
    fs = {
        on = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"),
        mod = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers"),
        body = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding"),
    },
    fl = ui.find("Aimbot", "Anti Aim", "Fake Lag", "Limit"),
    is_overriding_dmg = 0,
    is_overriding_hc = 0,
    is_overriding_baim = 0,
    is_overriding_sp = 0,
}

refs.check_ov = function()
    local binds = ui.get_binds()
    if refs.dmg:get_override() then return true end
    for i=1, #binds do
        if binds[i].name == "Min. Damage" and binds[i].active then return true end
    end
    return false
end
refs.check_ov_hc = function()
    local binds = ui.get_binds()
    if refs.hc:get_override() then return true end
    for i=1, #binds do
        if binds[i].name == "Hitchance" and binds[i].active then return true end
    end
    return false
end
refs.check_baim = function()
    local binds = ui.get_binds()
    if refs.dmg:get_override() then return true end
    for i=1, #binds do
        if binds[i].name == "Body Aim" and binds[i].active then return true end
    end
    return false
end
refs.check_sp = function()
    local binds = ui.get_binds()
    if refs.dmg:get_override() then return true end
    for i=1, #binds do
        if binds[i].name == "Safe Points" and binds[i].active then return true end
    end
    return false
end

visuals = {}

vs_debug = ui.create_gr(ui.get_icon("image").." Visuals", "> Visuals [DEBUG]")

visuals.items = {
    {ui.get_icon("palette"), "   Theme"},
    {ui.get_icon("window"), "   Panels"}, 
    {ui.get_icon("crosshairs"), "   Crosshair zone"}, 
    {ui.get_icon("scroll"), "   Logs"}, 
    {ui.get_icon("hourglass"), "   Effects"}, 
    {ui.get_icon("ellipsis"), "   Other settings"}, 
}

visuals.mselect = ui.create_gr(ui.get_icon("image").." Visuals", "> Menu selection")
visuals.tabs = {
    ui.create_gr(ui.get_icon("image").." Visuals", "> Theme"),
    ui.create_gr(ui.get_icon("image").." Visuals", "> Panels"),
    ui.create_gr(ui.get_icon("image").." Visuals", "> Crosshair zone"),
    ui.create_gr(ui.get_icon("image").." Visuals", "> Logs"),
    ui.create_e(ui.get_icon("image").." Visuals", gradient.text("> ⏳ Effects", false, {color(194, 154, 164), lighten(color(194, 154, 164), 45)})),
    ui.create_gr(ui.get_icon("image").." Visuals", "> Other settings"),
}

visuals.mlist = visuals.mselect:menu_select(visuals.items, visuals.tabs)

visuals.once = false
visuals.font_pad = 0
visuals.uicol = color(255, 255, 255)

theme_gr = visuals.tabs[1]--ui.create_gr(ui.get_icon("image").." Visuals", "> Theme")
visuals.theme = theme_gr:combo_e("General theme", {"Default ", "Alpha ", "Solus v2", "Modern ", "Vamp "})
visuals.uicol_select = theme_gr:combo_e("UI accent color", {"Theme", "Menu style"})
visuals.crosscol_select = theme_gr:switch_e("Apply theme color to crosshair")
theme_sub = ui.create_sub(visuals.theme)
visuals.solus_styles = {"Default", "Alt", "Retro"}
visuals.modern_styles = {"Solid", "Gradient"}
visuals.style = theme_sub:combo_e("Style", {})
visuals.theme_check = function()
    if visuals.theme:get() == "Modern " then
        visuals.style:update(visuals.modern_styles)
    elseif visuals.theme:get() == "Solus v2" then
        visuals.style:update(visuals.solus_styles)
    end
    visuals.style:visibility((visuals.theme:get() == "Solus v2" or visuals.theme:get() == "Modern "))
end
visuals.theme_check()
visuals.theme:set_callback(visuals.theme_check, true)
visuals.themecol = theme_sub:color_picker_e("Theme color", color(165, 65, 85, 175))
visuals.themecol:set_callback(function(ref)
    local uicol = (visuals.uicol_select:get() == "Theme") and visuals.themecol:get() or visuals.uicol
    update_texts(uicol)
end, true)
visuals.uicol_select:set_callback(function(ref)
    local uicol = (visuals.uicol_select:get() == "Theme") and color(visuals.themecol:get().r, visuals.themecol:get().g, visuals.themecol:get().b) or visuals.uicol
    update_texts(uicol)
end, true)
visuals.themecol2_select = theme_sub:combo_e("Secondary color", {"Default", "Custom"})
visuals.themecol2 = ui.color_picker_e(visuals.themecol2_select, color(150, 150, 150))
visuals.solus_thickness = theme_sub:slider_e("Line thickness", 0, 2, 2, 1.0, "px")
panels = visuals.tabs[2]--ui.create_gr(ui.get_icon("image").." Visuals", "> Panels")
--visuals.watermark = panels:switch_e("\a"..textcol(menucolor)..ui.get_icon("tag").."\aDEFAULT".."   Watermark")
visuals.watermark = panels:switch_e("Watermark")
visuals.wm_gr = ui.create_sub(visuals.watermark)
visuals.watermark:set_callback(function(ref)
    visuals.wm_gr:visibility(ref:get())
end, true)
visuals.wm_align = visuals.wm_gr:combo_e("Alignment", {"Left", "Right"})
visuals.wm_style = visuals.wm_gr:combo_e("Style", {"Default", "Modern"})
visuals.wm_elements = visuals.wm_gr:selectable_e("Elements", {"Username", "Latency", "Tickrate", "FPS", "Clock"})
visuals.wm_separator = visuals.wm_gr:combo_e("Separator", {"Space", "Dot", "Line", "🞩"})
visuals.wm_seconds = visuals.wm_gr:switch_e("Show clock seconds")
visuals.wm_pfp = visuals.wm_gr:switch_e("Show profile picture")
visuals.wm_namecol_type = visuals.wm_gr:combo_e("Script name color", {"Follow theme", "Static", "Animated"})
visuals.wm_namecol = ui.color_picker_e(visuals.wm_namecol_type, {
	["Simple"] = {
		color(255, 255, 255)
	},
	["Double"] = {
		color(255, 255, 255),
		color(0, 0, 0)
	},
})
visuals.wm_style:set_callback(function(ref) 
    visuals.wm_elements:visibility(ref:get() == "Default")
    visuals.wm_separator:visibility(ref:get() == "Default")
    visuals.wm_pfp:visibility(ref:get() == "Modern")
    visuals.wm_namecol_type:visibility(ref:get() == "Default")
end, true)
visuals.keybinds = panels:switch_e("Keybinds")
visuals.keybinds_header = ui.create_sub(visuals.keybinds):switch_e("Show header", true)
visuals.keybinds:set_callback(function(ref) visuals.keybinds_header:visibility(ref:get()) end, true)
visuals.spectators = panels:switch_e("Spectators list")
visuals.spec_gr = ui.create_sub(visuals.spectators)
visuals.spectators:set_callback(function(ref) visuals.spec_gr:visibility(ref:get()) end, true)
visuals.spec_header = visuals.spec_gr:switch_e("Show header", true)
visuals.spec_avatars = visuals.spec_gr:switch_e("Show avatars", true)
visuals.velocity_alert = panels:combo_e("Slowed indicator", {"Disabled", "Modern", "Classic"})
visuals.velocity_color = ui.create_sub(visuals.velocity_alert):combo_e("Indicator color", {"Adaptive", "Follow theme"})
visuals.velocity_alert:set_callback(function(ref)
    visuals.velocity_color:visibility(ref:get() ~= "Disabled")
end, true)
visuals.infopanel = panels:combo_e("Info panel", {"Disabled", "AA Console", "Info menu"})
visuals.infopanel_gr = ui.create_sub(visuals.infopanel)
visuals.infopanel_box = visuals.infopanel_gr:switch_e("Show box", false)
visuals.infopanel_muzzle = visuals.infopanel_gr:switch_e("Hover from weapon muzzle", false)
visuals.infopanel_muzzle_line = visuals.infopanel_gr:color_picker_e("Muzzle line color", color(255, 255, 255))
visuals.infopanel_muzzle_x = visuals.infopanel_gr:slider_e("Horizontal offset", -200, 200, 100)
visuals.infopanel_muzzle_y = visuals.infopanel_gr:slider_e("Vertical offset", -200, 200, 100)
visuals.ip_circle_style = visuals.infopanel_gr:combo_e("Circle style", {"Regular", "Gradient"})
visuals.ip_bg_color = visuals.infopanel_gr:color_picker_e("Circle background color", color(150, 150, 150, 150))
visuals.ip_real_color = visuals.infopanel_gr:color_picker_e("Real angle color")
visuals.ip_fake_color = visuals.infopanel_gr:color_picker_e("Fake angle color")
visuals.old_rage = visuals.infopanel_gr:switch_e("Use original rage tab")
visuals.infopanel:set_callback(function(ref)
    visuals.infopanel_gr:visibility(ref:get() ~= "Disabled")
    visuals.ip_circle_style:visibility(ref:get() == "Info menu")
    visuals.ip_bg_color:visibility(ref:get() == "Info menu")
    visuals.ip_real_color:visibility(ref:get() == "Info menu")
    visuals.ip_fake_color:visibility(ref:get() == "Info menu")
    visuals.old_rage:visibility(ref:get() == "Info menu")
end, true)
visuals.infobar = panels:combo_e("Info bar", {"Disabled", "Themed", "Classic"})
visuals.infobar_color = ui.color_picker_e(visuals.infobar ,color(180, 255, 0))
visuals.infobar:set_callback(function(ref)
    visuals.infobar_color:visibility(ref:get() ~= "Disabled")
end, true)

crs_tab = visuals.tabs[3]--ui.create_gr(ui.get_icon("image").." Visuals", "> Crosshair zone")
visuals.indicator = crs_tab:combo_e("Indicator style", {"Disabled", "Default", "Pre-alpha", "Modern", "Pixel", "Vamp"})
visuals.ind_gr = ui.create_sub(visuals.indicator)
visuals.ind_elements = {"Text cover", "Desync bar", "Desync range", "Movement state", "Anti bruteforce stage", "Minimum damage", "Other indicators"}
visuals.def_elements = {"Text cover", "Desync bar", "Desync range", "Anti bruteforce stage", "Minimum damage", "Other indicators"}
visuals.pix_elements = {"Desync bar", "Desync range", "Movement state", "Anti bruteforce stage", "Minimum damage", "Other indicators"}
visuals.elements = visuals.ind_gr:selectable_e("Indicator elements", {})
--visuals.elements:visibility(false)
visuals.indicatorcol = visuals.ind_gr:color_picker_e("Indicator color", color(165, 65, 85))
visuals.fullcol = visuals.ind_gr:switch_e("Fully colored logo", false)
visuals.fullcolind = visuals.ind_gr:switch_e("Fully colored indicator", false)
visuals.indicator:set_callback(function(item)
    --visuals.elements:visibility((item:get() == "Pre-alpha" or item:get() ~= "Pixel"))
    visuals.elements:visibility(( item:get() ~= "Modern"))
    visuals.indicatorcol:visibility(item:get() ~= "Disabled")
    visuals.fullcol:visibility(item:get() == "Pre-alpha")
    visuals.fullcolind:visibility(item:get() == "Pixel" or item:get() == "Default")
    if item:get() == "Pre-alpha" then
        visuals.elements:update(visuals.def_elements)
    elseif item:get() == "Pixel" then
        visuals.elements:update(visuals.pix_elements)
    else
        visuals.elements:update(visuals.pix_elements)
    end
end, true)
visuals.arrows = crs_tab:combo_e("Antiaim arrows", {"Disabled", "Simple", "Simple (Alt)", "TS", "TS Dynamic", "Modern"})
visuals.arrows_gr = ui.create_sub(visuals.arrows)
visuals.arrows_col = visuals.arrows_gr:color_picker_e("Arrows color", color(165, 65, 85))
visuals.arrows_col_2 = visuals.arrows_gr:color_picker_e("Secondary color", color(165, 65, 85))
visuals.arrows_mm = visuals.arrows_gr:combo_e("Color mode", {"Light", "Dark"})
visuals.arrows:set_callback(function(ref)
    visuals.arrows_gr:visibility(ref:get() ~= "Disabled")
    visuals.arrows_col_2:visibility((ref:get() == "TS") or (ref:get() == "TS Dynamic"))
    visuals.arrows_mm:visibility(ref:get() == "Modern")
end, true)
--scope_gr = ui.create_gr(ui.get_icon("image").." Visuals", "> Scope customisation")

visuals.customscope = crs_tab:switch_e("Custom scope lines", false)
visuals.scope_gr = ui.create_sub(visuals.customscope)
visuals.customscope:set_callback(function(ref)
    visuals.scope_gr:visibility(ref:get())
end, true)
visuals.scope_inaccuracy = visuals.scope_gr:switch_e("Show inaccuracy", false)
visuals.scope_color_primary = visuals.scope_gr:color_picker_e("Primary color")
visuals.scope_color_secondary = visuals.scope_gr:color_picker_e("Secondary color", color(255, 255, 255, 0))
visuals.scope_length = visuals.scope_gr:slider_e("Scope length", 0, screensizex / 2, 100, 1.0, "px")
visuals.scope_offset = visuals.scope_gr:slider_e("Scope offset", 0, screensizex / 2, 10, 1.0, "px")
visuals.scope_type = visuals.scope_gr:combo_e("Scope type", {"Static", "Animated"})
visuals.scope_rotation = visuals.scope_gr:slider_e("Scope rotation", 0, 90, 0, 1.0, "°")
visuals.scope_speed = visuals.scope_gr:slider_e("Rotation speed", -100, 100, 1, 1.0)
visuals.scope_type:set_callback(function(ref)
    visuals.scope_speed:visibility(ref:get() == "Animated")
end, true)

vis_others_gr = visuals.tabs[6]--ui.create_gr(ui.get_icon("image").." Visuals", "> Other settings")
visuals.viewmodel = vis_others_gr:switch_e("Custom viewmodel")
visuals.viewmodel_gr = ui.create_sub(visuals.viewmodel)
visuals.viewmodel:set_callback(function(ref)
    visuals.viewmodel_gr:visibility(ref:get())
end, true)
visuals.viewx = visuals.viewmodel_gr:slider_e("X", -200, 200, 10, 0.1)
visuals.viewy = visuals.viewmodel_gr:slider_e("Y", -200, 200, 10, 0.1)
visuals.viewz = visuals.viewmodel_gr:slider_e("Z", -200, 200, -10, 0.1)
visuals.fov = visuals.viewmodel_gr:slider_e("FOV", 0, 200, 68, 1.0)
visuals.aspect = visuals.viewmodel_gr:slider_e("Aspect ratio", 0, 200, 0, 0.1)
visuals.gs_specs = vis_others_gr:switch_e("\a63B114FF500\aFFFFFFFFUSD\aDEFAULT Spectators list")
visuals.gs_inds = vis_others_gr:switch_e("\a63B114FF500\aFFFFFFFFUSD\aDEFAULT Indicators")
visuals.gs_inds_elems = ui.create_sub(visuals.gs_inds):selectable_e("Feature indicators", {"Force safe point", "Force body aim", "Ping spike", "Double tap", "Duck peek assist", "Freestanding", "On shot anti-aim", "Minimum damage override", "Dormant aimbot", "Lag compensation", "Bomb plant"})

logs_gr = visuals.tabs[4]--ui.create_gr(ui.get_icon("image").." Visuals", "> Logs")
visuals.logs = logs_gr:selectable_e("Ragebot logs", {"On screen", "In console"})
visuals.logs_shown = ui.create_sub(visuals.logs):selectable_e("Shown for:", {"Hits", "Misses", "Enemy hits", "Round summary"})
--visuals.logs_style = logs_gr:selectable_e("On screen logs style", {"Under crosshair"})
visuals.logs_style = logs_gr:label_e("On screen logs settings")
visuals.logs:set_callback(function(ref)
    visuals.logs_shown:visibility((ref:get("On screen") or ref:get("In console")))
    visuals.logs_style:visibility(ref:get("On screen"))
end, true)
visuals.screen_logs = ui.create_sub(visuals.logs_style)
visuals.logs_bg = visuals.screen_logs:switch_e("Show box", true)
visuals.logs_duration = visuals.screen_logs:slider_e("Duration", 0, 15, 7, 1.0, "s")
visuals.logs_offset = visuals.screen_logs:slider_e("Offset", 0, screensizey / 2, 275, 1.0, "px")

visuals.prim = visuals.tabs[5]--ui.create_e(ui.get_icon("image").." Visuals", gradient.text("> ⏳ Effects", false, {color(194, 154, 164), lighten(color(194, 154, 164), 45)}))
visuals.sparks = visuals.prim:switch_e("Sparks hit effect")
visuals.sparkscol = ui.color_picker_e(visuals.sparks, color(194, 154, 164))
visuals.ap = visuals.prim:switch_e("Custom autopeek")
visuals.apcol = ui.color_picker_e(visuals.ap, color(194, 154, 164))

--[[visuals.mlist:set_callback(function(ref)
    --if not loaded then return end
    local table = {}
    local color = concolor(lighten(visuals.themecol:get(), 20)).."FF"
    for i = 1, #visuals.items do
        if ref:get() == i then
            table[i] = "\a"..color..visuals.items[i][1].."\aDEFAULT"..visuals.items[i][2]
            visuals.tabs[i]:visibility(true)
        else
            table[i] = visuals.items[i][1]..visuals.items[i][2]
            visuals.tabs[i]:visibility(false)
        end
    end
    ref:update(table)
end, true)]]

visuals.desync_range = 0
visuals.cur_theme = "Default"
mindmg_override = 0

watermark = {}
watermark.width = 0
watermark.current_width = 0
watermark.text = ""
watermark.text_size = vector(5000, 0)
watermark.fps = 0
watermark.alpha = 0
watermark.name = gradient.text_animate("Opium", 1, {
    color(148, 110, 242), 
    color(70, 52, 115)
})
watermark.separators = {
    ["Space"] = "   ",
    ["Dot"] = " • ",
    ["Line"] = " | ",
    ["🞩"] = " 🞩 ",
}

aa = {}

aa.conditionslist = {"(Closed)", "Base", "Standing", "Running", "Slow walking", "Crouching", "Jumping", "Autopeek/Ideal tick", "Manual direction", "Legit AA", "Hidden (base)", "Safety"}
aa.conditionslist_ab = {"Standing", "Running", "Slow walking", "Crouching", "Jumping", "Autopeek/Ideal tick", "Manual direction", "Legit AA", "Hidden (base)", "Safety"}
aa.conditionslist_safety = {"Standing", "Running", "Slow walking", "Crouching", "Jumping", "Autopeek/Ideal tick", "Manual direction", "Legit AA", "Anti Bruteforce"}
aa.conditions_short = {"(Closed)", "Base", "Stand", "Run", "Slow walk", "Crouch", "Jump", "Autopeek/Ideal tick", "Manual", "Legit AA", "Hidden (base)", "Safety"}
aa.conditionslist_icons = {
    --ui.get_icon("empty-set").."   (Closed)",
    {ui.get_icon("earth-europe"), "   Base"},
    {ui.get_icon("person"), "   Standing"}, 
    {ui.get_icon("person-running"), "   Running"}, 
    {ui.get_icon("turtle"), "   Slow walking"}, 
    {ui.get_icon("face-disguise"), "   Crouching"}, 
    {ui.get_icon("pump"), "   Jumping"}, 
    {ui.get_icon("rabbit-running"), "   Autopeek/Ideal tick"}, 
    {ui.get_icon("arrows-up-down-left-right"), "   Manual direction"}, 
    {ui.get_icon("restroom"), "   Legit AA"},
    {ui.get_icon("user-ninja"), "   Hidden (base)"},
    {ui.get_icon("helmet-safety"), "   Safety"},
}
aa.once = false
aa.current_state = 2
aa.move_state = 2
aa.real_state = 2
aa.backup_state = 2
aa.manual_state = 0
aa.antibrute_stages_items = {}
aa.antibrute_current_stage = 0
aa.antibrute_counter = 0
aa.antibrute_index = 2
aa.antibrute_yaw_offset = -181
aa.antibrute_active = false

aa.configs = {
    [1] = {ui.get_icon("empty-set"), "   Cheat settings"},
    [2] = {ui.get_icon("wrench"), "   Custom builder"},
    [3] = {ui.get_icon("file-shield"), "   Config name"},
}

aa.tab = ui.create_gr(ui.get_icon("user-shield").." Anti Aim", " > AA Configurator", 1)
aa.cfg = aa.tab:list_col("AA configuration", aa.configs)
cfg.hidaa:set_callback(function() update_aa_cfgs() end, true)
--[[aa.cfg:set_callback(function(ref)
    local table = {}
    local color = concolor(lighten(visuals.themecol:get(), 20)).."FF"
    local cfgs = aa.configs
    for i=1, #cfgs do
        if ref:get() == i then
            table[i] = "\a"..color..cfgs[i][1].."\aDEFAULT"..cfgs[i][2]
        else
            table[i] = cfgs[i][1]..cfgs[i][2]
        end
    end
    ref:update(table)
end, true)]]
aa.tab:label_cfg("Anti Aim")
aa.hidelabel = aa.tab:label_e("Hidden AA settings")
aa.hide_is_open = false
aa.hide_button = aa.tab:button_e("    "..ui.get_icon("angle-right").."    ", function(ref)
    aa.hide_is_open = not aa.hide_is_open
    ref:name(aa.hide_is_open and "    "..ui.get_icon("angle-left").."    " or "    "..ui.get_icon("angle-right").."    ")
end, true)
aa.condlabel = aa.tab:label_e("Conditions editor")
--aa.condselect = ui.create_sub(aa.condlabel):list_e("Conditions list", aa.conditionslist_icons)
aa.cond_is_open = false
aa.cond_button = aa.tab:button_e("    "..ui.get_icon("angle-down").."    ", function(ref)
    aa.cond_is_open = not aa.cond_is_open
    ref:name(aa.cond_is_open and "    "..ui.get_icon("angle-up").."    " or "    "..ui.get_icon("angle-down").."    ")
end, true)
--aa.cond_open = aa.tab:button_e("    "..ui.get_icon("angle-down").."    ", function() aa.cond_is_open = true end, true)
aa.condselect = aa.tab:list_col("Conditions list", aa.conditionslist_icons)
--[[aa.condselect:set_callback(function(ref)
    local table = {}
    local color = concolor(lighten(visuals.themecol:get(), 20)).."FF"
    for i = 1, #aa.conditionslist_icons do
        if ref:get() == i then
            table[i] = "\a"..color..aa.conditionslist_icons[i][1].."\aDEFAULT"..aa.conditionslist_icons[i][2]
        else
            table[i] = aa.conditionslist_icons[i][1]..aa.conditionslist_icons[i][2]
        end
    end
    ref:update(table)
end, true)]]
aa.conditions = {}

aa.abtab = ui.create_gr(ui.get_icon("user-shield").." Anti Aim", " > Antibrute configurator", 1)
aa.antibrute = aa.abtab:switch_e("Enable anti bruteforce")
aa.abgr = ui.create_sub(aa.antibrute)
aa.antibrute_timer = aa.abgr:slider_e("Stage timer", 0, 10, 0, 1.0, "s")
aa.antibrute_timer:tooltip("Setting this to \"0\" will only reset the stage in the next round")
aa.antibrute_ignore = aa.abgr:selectable_e("Excluded conditions", aa.conditionslist_ab)
--aa.antibrute_manager = aa.abtab:switch_e("Show stage manager")
aa.antibrute_stagemg = aa.abtab:label_e("Stage manager")
aa.brute_is_open = false
aa.antibrute_stagemg_button = aa.abtab:button_e("    "..ui.get_icon("angle-down").."    ", function(ref)
    aa.brute_is_open = not aa.brute_is_open
    ref:name(aa.brute_is_open and "    "..ui.get_icon("angle-up").."    " or "    "..ui.get_icon("angle-down").."    ")
end, true)
aa.antibrute_stage_count = aa.abtab:slider_e("[DEBUG] Stage count", 1, 10, 1, 1)
aa.antibrute_stage_count:visibility(false)
aa.antibrute_stage_table = {}
aa.antibrute_stages = aa.abtab:list_e("Stage list", aa.antibrute_stage_table)

aa.hidden_tab = ui.create_gr(ui.get_icon("user-shield").." Anti Aim", " > Hidden AA settings", 2)
aa.h_pitch = aa.hidden_tab:combo_e(" » Pitch", {"Default", "Static", "Jitter", "Sway", "Random"})
aa.hp_gr = ui.create_sub(aa.h_pitch)
aa.hp_cond = aa.hp_gr:selectable_e("Apply on:", {"Double tap", "Hide shots"})
aa.hp_base = aa.hp_gr:slider_e("Base", -89, 89, 0, 1, "°")
aa.hp_up = aa.hp_gr:slider_e("Top limit", -89, 89, 0, 1, "°")
aa.hp_down = aa.hp_gr:slider_e("Bottom limit", -89, 89, 0, 1, "°")
aa.hp_sway_direction = aa.hp_gr:combo_e("Sway direction", {"Unidirectional", "Bidirectional"})
aa.hp_sway_speed = aa.hp_gr:slider_e("Speed", 1, 100, 1, 1)
aa.hp_rj = aa.hp_gr:switch_e("Jitter side")

aa.h_pitch:set_callback(function(ref)
    aa.hp_gr:visibility(ref:get() ~= "Default")
    aa.hp_base:visibility(ref:get() == "Static")
    aa.hp_up:visibility(ref:get() ~= "Static")
    aa.hp_down:visibility(ref:get() ~= "Static")
    aa.hp_sway_direction:visibility(ref:get() == "Sway")
    aa.hp_sway_speed:visibility(ref:get() == "Sway")
    aa.hp_rj:visibility(ref:get() == "Random")
end, true)
--aa.hp_info = aa.hp_gr:label_e("\aFF5F15FF"..ui.get_icon("triangle-exclamation").." Setting values of 90°/-90° will apply fake pitch and only work on specific servers, with \"Anti Untrusted\" turned off.")
aa.h_yaw = aa.hidden_tab:combo_e(" » Yaw", {"Default", "Static", "Jitter", "Sway", "Random"})
aa.hy_gr = ui.create_sub(aa.h_yaw)
aa.hy_cond = aa.hy_gr:selectable_e("Apply on:", {"Double tap", "Hide shots"})
aa.hy_base = aa.hy_gr:slider_e("Base", -180, 180, 0, 1, "°")
aa.hy_left = aa.hy_gr:slider_e("Left limit", -180, 180, 0, 1, "°")
aa.hy_right = aa.hy_gr:slider_e("Right limit", -180, 180, 0, 1, "°")
aa.hy_sway_direction = aa.hy_gr:combo_e("Sway direction", {"Unidirectional", "Bidirectional"})
aa.hy_sway_speed = aa.hy_gr:slider_e("Speed", 1, 100, 1, 1)
aa.hy_rj = aa.hy_gr:switch_e("Jitter side")

aa.h_yaw:set_callback(function(ref)
    aa.hy_gr:visibility(ref:get() ~= "Default")
    aa.hy_base:visibility(ref:get() == "Static")
    aa.hy_left:visibility(ref:get() ~= "Static")
    aa.hy_right:visibility(ref:get() ~= "Static")
    aa.hy_sway_direction:visibility(ref:get() == "Sway")
    aa.hy_sway_speed:visibility(ref:get() == "Sway")
    aa.hy_rj:visibility(ref:get() == "Random")
end, true)
aa.hidden_base = aa.hidden_tab:switch_e("Use dedicated base settings")

for i=1, 11 do
    aa.antibrute_stages_items[i] = {group = ui.create_gr(ui.get_icon("user-shield").." Anti Aim", " > Antibrute Settings - Stage "..i, 2)}
    local cond = aa.antibrute_stages_items[i]
    --cond.defensive = cond.group:switch_e("Force defensive")
    cond.yaw = cond.group:switch_e(" » Yaw")
    cond.yaw_left = cond.group:slider_e("Left additive", -180, 180, 0, 1, "°")
    cond.yaw_right = cond.group:slider_e("Right additive", -180, 180, 0, 1, "°")
    cond.mod_select = cond.group:combo_e("Yaw modifier", {"None", "Jitter", "Random", "Spin", "Sway"})
    cond.mod_range = ui.create_sub(cond.mod_select):slider_e("Offset", -180, 180, 0, 1, "°")
    cond.jit_select = cond.group:combo_e("Jitter type", {"Center", "Offset", "3-Way", "5-Way", "Custom sequence"})
    cond.jit_group = ui.create_sub(cond.jit_select)
    --cond.jit_update = cond.jit_group:combo_e("Jitter switch", {"On updated tick", "On fixed timer"})
    cond.jit_update_timer = cond.jit_group:slider_e("Switch delay", 1, 14, 1, 1)
    cond.jit_update_chance = cond.jit_group:slider_e("Update chance", 0, 100, 100, 1, "%")
    cond.jit_open = cond.group:switch_e("Open jitter manager")
    cond.jit_count = ui.create_sub(cond.jit_open):slider_e("Jitter stages", 2, 9, 2, 1)
    cond.jit_order = ui.create_sub(cond.jit_open):combo_e("Stage succesion", {"Unidirectional", "Bidirectional", "Random"})
    cond.jit_custom = {}
    for j=1, 9 do
        cond.jit_custom[j] = {label = cond.group:label_e("Stage "..j)}
        local stage = cond.jit_custom[j]
        stage.group = ui.create_sub(cond.jit_custom[j].label)
        stage.yaw = stage.group:slider_e("Yaw base", -180, 180, 0, 1)
        stage.duration = stage.group:slider_e("Duration", 1, 14, 1, 1)
        stage.chance = stage.group:slider_e("Update chance", 0, 100, 100, 1, "%")
        stage.label:visibility(false)
    end
    cond.sway_dir = cond.group:combo_e("Sway direction", {"Unidirectional", "Bidirectional", "Random switch"})
    cond.sway_group = ui.create_sub(cond.sway_dir)
    cond.sway_left = cond.sway_group:slider_e("Left limit", -180, 180, 0, 1, "°")
    cond.sway_right = cond.sway_group:slider_e("Right limit", -180, 180, 0, 1, "°")
    cond.sway_speed = cond.sway_group:slider_e("Speed", 1, 100, 1, 1)
    cond.sway_switch = cond.sway_group:slider_e("Switch chance", 0, 100, 0, 1, "%")
    cond.sway_jitter = cond.sway_group:switch_e("Jitter side")

    cond.desync = cond.group:switch_e(" » Desync")
    cond.desync_group = ui.create_sub(cond.desync)
    cond.desync_inverter = cond.desync_group:switch_e("Inverter")
    cond.desync_mode = cond.desync_group:combo_e("Mode", {"Static", "Random", "Sway", "Custom sequence"})
    cond.desync_l_left = cond.desync_group:slider_e("Left limit", 0, 60, 60, 1, "°")
    cond.desync_l_right = cond.desync_group:slider_e("Right limit", 0, 60, 60, 1, "°")
    cond.desync_left = cond.desync_group:slider_e("Left limit", -60, 60, 0, 1, "°")
    cond.desync_right = cond.desync_group:slider_e("Right limit", -60, 60, 0, 1, "°")
    cond.desync_sway = cond.group:combo_e("Sway direction", {"Unidirectional", "Bidirectional", "Random switch"})
    cond.ds_sway_gr = ui.create_sub(cond.desync_sway)
    cond.ds_sway_speed = cond.ds_sway_gr:slider_e("Speed", 1, 100, 1, 1)
    cond.ds_sway_switch = cond.ds_sway_gr:slider_e("Switch chance", 0, 100, 0, 1, "%")
    cond.desync_options = cond.desync_group:selectable_e("Options", {"Avoid overlap", "Jitter", "Randomize jitter"})
    cond.desync_fs = cond.desync_group:combo_e("Freestanding", {"Off", "Peek fake", "Peek real"})
    cond.ds_open = cond.group:switch_e("Open desync manager")
    cond.ds_count = ui.create_sub(cond.ds_open):slider_e("Desync stages", 2, 9, 2, 1)
    cond.ds_order = ui.create_sub(cond.ds_open):combo_e("Stage succesion", {"Unidirectional", "Bidirectional", "Random"})
    cond.ds_custom = {}
    for j=1, 9 do
        cond.ds_custom[j] = {label = cond.group:label_e("Stage "..j)}
        local stage = cond.ds_custom[j]
        stage.group = ui.create_sub(cond.ds_custom[j].label)
        stage.yaw = stage.group:slider_e("Body yaw", -60, 60, 0, 1)
        stage.duration = stage.group:slider_e("Duration", 1, 14, 1, 1)
        stage.chance = stage.group:slider_e("Update chance", 0, 100, 100, 1, "%")
        stage.label:visibility(false)
    end
    cond.group:visibility(false)
end

aa.antibrute_add_stage = aa.abtab:button_e("Add stage", function() 
    if #aa.antibrute_stage_table < 10 then
        aa.antibrute_stage_table[#aa.antibrute_stage_table+1] = "Stage "..#aa.antibrute_stage_table+1
        aa.antibrute_stages:update(aa.antibrute_stage_table)
        aa.antibrute_stage_count:set(#aa.antibrute_stage_table)
    end
end, true)

aa.antibrute_delete_stage = aa.abtab:button_e("Delete stage", function()
    if #aa.antibrute_stage_table > 1 then
        for i = aa.antibrute_stages:get(), #aa.antibrute_stage_table - 1 do
            for k in pairs(aa.antibrute_stages_items[i]) do
                if type(aa.antibrute_stages_items[i][k]) == "userdata" then
                    if string.find(tostring(aa.antibrute_stages_items[i][k]), "menu_item") ~= nil then
                        aa.antibrute_stages_items[i][k]:set(aa.antibrute_stages_items[i+1][k]:get())
                        aa.antibrute_stages_items[i+1][k]:set(aa.antibrute_stages_items[11][k]:get())
                    end
                elseif type(aa.antibrute_stages_items[i][k]) == "table" then
                    for j in pairs(aa.antibrute_stages_items[i][k]) do
                        if type(aa.antibrute_stages_items[i][k][j]) == "userdata" then
                            aa.antibrute_stages_items[i][k][j]:set(aa.antibrute_stages_items[i+1][k][j]:get())
                            aa.antibrute_stages_items[i+1][k][j]:set(aa.antibrute_stages_items[11][k][j]:get())
                        end
                    end
                end
            end
        end
        for k in pairs(aa.antibrute_stages_items[#aa.antibrute_stage_table]) do
            if type(aa.antibrute_stages_items[#aa.antibrute_stage_table][k]) == "userdata" then
                if string.find(tostring(aa.antibrute_stages_items[#aa.antibrute_stage_table][k]), "menu_item") ~= nil then
                    aa.antibrute_stages_items[#aa.antibrute_stage_table][k]:set(aa.antibrute_stages_items[11][k]:get())
                end
            elseif type(aa.antibrute_stages_items[#aa.antibrute_stage_table][k]) == "table" then
                for j in pairs(aa.antibrute_stages_items[#aa.antibrute_stage_table][k]) do
                    if type(aa.antibrute_stages_items[#aa.antibrute_stage_table][k][j]) == "userdata" then
                        aa.antibrute_stages_items[#aa.antibrute_stage_table][k][j]:set(aa.antibrute_stages_items[11][k][j]:get())
                    end
                end
            end
        end
        table.remove(aa.antibrute_stage_table, #aa.antibrute_stage_table)
        aa.antibrute_stages:update(aa.antibrute_stage_table)
        --aa.antibrute_stages:remove_item("Stage "..#aa.antibrute_stage_table - 1)
        aa.antibrute_stage_count:set(#aa.antibrute_stage_table)
    end
end, true)


aa.antibrute_increase_stage = aa.abgr:button_e("[DEBUG] Increase current stage", function()
    aa.antibrute_counter = 0
    aa.antibrute_current_stage = aa.antibrute_current_stage + 1
end)
aa.antibrute_increase_stage:visibility(_DEBUG)

aa.gen = ui.create_gr(ui.get_icon("user-shield").." Anti Aim", " > Global AA settings", 1)
aa.pitch = aa.gen:combo_e("Pitch", {"Disabled", "Down", "Fake down", "Fake up"})
aa.pitch_g = ui.create_sub(aa.pitch)
--aa.fake_pitch = aa.pitch_g:switch_e("Use defensive pitch")
--aa.pitch_warning = aa.pitch_g:label_e("\aFF5F15FF"..ui.get_icon("triangle-exclamation").." This option optimally requires disabling \"Anti Untrusted\" from the \"Main\" cheat tab, which can cause issues on some servers.")
aa.yaw = aa.gen:combo_e("Yaw", {"Disabled", "Backward", "Static"})
aa.yaw_gr = ui.create_sub(aa.yaw)
aa.base = aa.yaw_gr:combo_e("Base", {"Local View", "At Target"})
aa.avoid = aa.yaw_gr:switch_e("Avoid backstab")
--aa.hidden = aa.yaw_gr:switch_e("Hidden")
aa.invert = aa.gen:switch_e("Desync inverter")
--aa.sync_jit = aa.gen:switch_e("Sync real/fake jitter")
aa.fs = aa.gen:switch_e("Freestanding")
aa.fs_g = ui.create_sub(aa.fs)
aa.fs_mod = aa.fs_g:switch_e("Disable yaw modifiers")
aa.fs_body = aa.fs_g:switch_e("Body freestanding")
aa.fs_ignore = aa.fs_g:selectable_e("Excluded conditions", aa.conditionslist_ab)
aa.fs_warning = aa.fs_g:label_e("\aFF5F15FF"..ui.get_icon("triangle-exclamation").." Some yaw modifiers will not be applied while freestanding is active.")
aa.extend = aa.gen:switch_e("Extended angles")
aa.extend_g = ui.create_sub(aa.extend)
aa.ext_pitch = aa.extend_g:slider_e("Extended pitch", -180, 180, 180, 1.0, "°")
aa.ext_roll = aa.extend_g:slider_e("Extended roll", 0, 90, 90, 1.0, "°")
aa.manual = aa.gen:label_e("Manual yaw base")
aa.manual_sub = ui.create_sub(aa.manual)
aa.left = aa.manual_sub:switch_e("Left")
aa.left:set_callback(function(item)
    if item:get() then
        aa.right:set(false)
        aa.back:set(false)
    end
end)
aa.right = aa.manual_sub:switch_e("Right")
aa.right:set_callback(function(item)
    if item:get() then
        aa.left:set(false)
        aa.back:set(false)
    end
end)
--aa.front = aa.manual_sub:switch_e("Forward")
aa.back = aa.manual_sub:switch_e("Back")
aa.back:set_callback(function(item)
    if item:get() then
        aa.right:set(false)
        aa.left:set(false)
    end
end)

for i = 2, #aa.conditionslist do
    aa.conditions[i] = {group = ui.create_gr(ui.get_icon("user-shield").." Anti Aim", " > AA Settings - "..aa.conditionslist[i], 2)}
    local cond = aa.conditions[i]
    if i ~= 2 then
        if i == 12 then cond.s_override = cond.group:selectable_e("Use safety on:", {"Knife", "Tazer", "Height advantage"}) end
        cond.override = i == 12 and cond.group:selectable_e("Override following:", aa.conditionslist_safety) or cond.group:switch_e("Override "..aa.conditionslist[i]..(i ~= 10 and " AA" or ""), i == 11 and true or false)
        if i == 11 then cond.override:visibility(false) end
        cond.list = {"None"}
        for n = 2, #aa.conditionslist do
            if i ~= 2 then
                if aa.conditionslist[n] == aa.conditionslist[i] then
                    cond.list[n] = "(Current condition)"
                else
                    cond.list[n] = aa.conditionslist[n]
                end
            end
        end
        cond.inherit = cond.group:combo_e("Inherit settings", cond.list)
    end
    cond.defensive_aa = cond.group:switch_e("Defensive AA")
    cond.def_gr = ui.create_sub(cond.defensive_aa)
    cond.defensive = cond.def_gr:switch_e("Force defensive")
    cond.hidden_pitch = cond.def_gr:switch_e("Apply hidden pitch")
    cond.hidden_yaw = cond.def_gr:switch_e("Apply hidden yaw")
    cond.yaw = (i == 2 or i == 11) and cond.group:label_e(" » Yaw") or cond.group:switch_e(" » Yaw")
    cond.yaw_left = cond.group:slider_e("Left additive", -180, 180, 0, 1, "°")
    cond.yaw_right = cond.group:slider_e("Right additive", -180, 180, 0, 1, "°")
    cond.mod_select = cond.group:combo_e("Yaw modifier", {"None", "Jitter", "Random", "Spin", "Sway"})
    cond.mod_range = ui.create_sub(cond.mod_select):slider_e("Offset", -180, 180, 0, 1, "°")
    cond.jit_select = cond.group:combo_e("Jitter type", {"Center", "Offset", "3-Way", "5-Way", "Custom sequence"})
    cond.jit_group = ui.create_sub(cond.jit_select)
    --cond.jit_update = cond.jit_group:combo_e("Jitter switch", {"On updated tick", "On fixed timer"})
    cond.jit_update_timer = cond.jit_group:slider_e("Switch delay", 1, 14, 1, 1)
    cond.jit_update_chance = cond.jit_group:slider_e("Update chance", 0, 100, 100, 1, "%")
    cond.jit_open = cond.group:switch_e("Open jitter manager")
    cond.jit_count = ui.create_sub(cond.jit_open):slider_e("Jitter stages", 2, 9, 2, 1)
    cond.jit_order = ui.create_sub(cond.jit_open):combo_e("Stage succesion", {"Unidirectional", "Bidirectional", "Random"})
    cond.jit_custom = {}
    for j=1, 9 do
        cond.jit_custom[j] = {label = cond.group:label_e("Stage "..j)}
        local stage = cond.jit_custom[j]
        stage.group = ui.create_sub(cond.jit_custom[j].label)
        stage.yaw = stage.group:slider_e("Yaw base", -180, 180, 0, 1)
        stage.duration = stage.group:slider_e("Duration", 1, 14, 1, 1)
        stage.chance = stage.group:slider_e("Update chance", 0, 100, 100, 1, "%")
        stage.label:visibility(false)
    end
    cond.sway_dir = cond.group:combo_e("Sway direction", {"Unidirectional", "Bidirectional", "Random switch"})
    cond.sway_group = ui.create_sub(cond.sway_dir)
    cond.sway_left = cond.sway_group:slider_e("Left limit", -180, 180, 0, 1, "°")
    cond.sway_right = cond.sway_group:slider_e("Right limit", -180, 180, 0, 1, "°")
    cond.sway_speed = cond.sway_group:slider_e("Speed", 1, 100, 1, 1)
    cond.sway_switch = cond.sway_group:slider_e("Switch chance", 0, 100, 0, 1, "%")
    cond.sway_jitter = cond.sway_group:switch_e("Jitter side")

    cond.desync = (i == 2 or i == 11) and cond.group:label_e(" » Desync") or cond.group:switch_e(" » Desync")
    cond.desync_group = ui.create_sub(cond.desync)
    cond.desync_inverter = cond.desync_group:switch_e("Inverter")
    cond.desync_mode = cond.desync_group:combo_e("Mode", {"Static", "Random", "Sway", "Custom sequence"})
    cond.desync_l_left = cond.desync_group:slider_e("Left limit", 0, 60, 60, 1, "°")
    cond.desync_l_right = cond.desync_group:slider_e("Right limit", 0, 60, 60, 1, "°")
    cond.desync_left = cond.desync_group:slider_e("Left limit", -60, 60, 0, 1, "°")
    cond.desync_right = cond.desync_group:slider_e("Right limit", -60, 60, 0, 1, "°")
    cond.desync_sway = cond.group:combo_e("Sway direction", {"Unidirectional", "Bidirectional", "Random switch"})
    cond.ds_sway_gr = ui.create_sub(cond.desync_sway)
    cond.ds_sway_speed = cond.ds_sway_gr:slider_e("Speed", 1, 100, 1, 1)
    cond.ds_sway_switch = cond.ds_sway_gr:slider_e("Switch chance", 0, 100, 0, 1, "%")
    cond.desync_options = cond.desync_group:selectable_e("Options", {"Avoid overlap", "Jitter", "Randomize jitter"})
    cond.desync_fs = cond.desync_group:combo_e("Freestanding", {"Off", "Peek fake", "Peek real"})
    cond.ds_open = cond.group:switch_e("Open desync manager")
    cond.ds_count = ui.create_sub(cond.ds_open):slider_e("Desync stages", 2, 9, 2, 1)
    cond.ds_order = ui.create_sub(cond.ds_open):combo_e("Stage succesion", {"Unidirectional", "Bidirectional", "Random"})
    cond.ds_custom = {}
    for j=1, 9 do
        cond.ds_custom[j] = {label = cond.group:label_e("Stage "..j)}
        local stage = cond.ds_custom[j]
        stage.group = ui.create_sub(cond.ds_custom[j].label)
        stage.yaw = stage.group:slider_e("Body yaw", -60, 60, 0, 1)
        stage.duration = stage.group:slider_e("Duration", 1, 14, 1, 1)
        stage.chance = stage.group:slider_e("Update chance", 0, 100, 100, 1, "%")
        stage.label:visibility(false)
    end

    --cond.extend = i ==2 and cond.group:label_e(" » Extended Angles") or cond.group:switch_e(" » Extended Angles")

end

-- » this retarded ahh sign is called a guillemet

aa.get_manual_override = function()
    return aa.left:get() and 1 or aa.back:get() and 2 or aa.right:get() and 3 or 0
end

aa.get_desync_side = function()
    return ((local_player.desync_angle()) < 0 or not rage.antiaim:inverter()) and 1 or ((local_player.desync_angle() > 0) or rage.antiaim:inverter()) and 2 or 0
end

aa.get_vars = function(cmd)

    local lp = entity.get_local_player()
    if not lp then return end
    local flag = lp.m_fFlags
    local velocity = math.sqrt( math.pow( lp.m_vecVelocity.x, 2 ) + math.pow( lp.m_vecVelocity.y, 2 ) )
    local animstate = lp:get_anim_state()
    local wep = lp:get_player_weapon()
    local safety = false
    local threat = entity.get_threat()
    if threat and aa.conditions[12].s_override:get()[3] then
        local lp_pos = lp:get_origin()
        local threat_pos = threat:get_origin()
        if (lp_pos.z > threat_pos.z + 75) then safety = true end
    end
    if wep then
        local name = wep:get_weapon_info().weapon_name
        if string.find(name, "knife") and aa.conditions[12].s_override:get()[1] then
            safety = true
        elseif string.find(name, "taser") and aa.conditions[12].s_override:get()[2] then
            safety = true
        end
    end

   --aa states: "(Closed)", "Base", "Standing", "Running", "Slow walking", "Crouching", "Jumping", "Autopeek/Ideal tick", "Manual direction", "Legit AA", "Hidden (base)", "Safety"
    --[[if (aa.hidden_pitch_active or aa.hidden_yaw_active) and aa.hidden_base:get() then
        aa.current_state = 11
    else]]
    if cmd.in_use then
            aa.current_state = 10
    elseif aa.get_manual_override() ~= 0 then
        aa.current_state = 9
    elseif (refs.ap.on:get() or aim.tick:get()) then
        aa.current_state = 8
    elseif cmd.in_jump or not animstate.on_ground then
        aa.current_state = 7
    elseif (animstate.anim_duck_amount > 0.5) then
        aa.current_state = 6
    elseif refs.sw:get() then
        aa.current_state = 5
    elseif velocity > 120 then
        aa.current_state = 4
    else
        aa.current_state = 3
    end

    if safety and aa.conditions[12].override:get(aa.current_state - 2) then aa.current_state = 12 end

    if aa.current_state == 12 then
        aa.move_state = 12
    elseif cmd.in_use and antiaim_on_use.enabled then
        aa.move_state = 10
    elseif aa.get_manual_override() ~= 0 then
        aa.move_state = 9
    elseif cmd.in_jump or not animstate.on_ground then
        aa.move_state = 7
    elseif (animstate.anim_duck_amount > 0.5) then
        aa.move_state = 6
    elseif refs.sw:get() then
        aa.move_state = 5
    elseif velocity > 120 then
        aa.move_state = 4
    else
        aa.move_state = 3
    end

    aa.real_state = aa.current_state

end

events.createmove:set(aa.get_vars)
aa.yaw_offset = 0
aa.jitter = 0
aa.jitter_counter = 0
aa.jitter_modifier = 1
aa.jitter_stage = 1
aa.jitter_next_stage = 1
aa.sway_direction = 1
aa.sway_jitter = 1
aa.desync = 60
aa.desync_counter = 0
aa.desync_modifier = 1
aa.desync_stage = 1
aa.desync_next_stage = 1
aa.ds_sway_direction = 1
aa.antibrute_jitter = -181
aa.antibrute_jitter_mode = 0
aa.antibrute_jitter_type = 0
aa.antibrute_jitter_add = 0
aa.antibrute_lean_mode = -1
aa.antibrute_lean_range = -51
aa.antibrute_lean_jitter = -1
aa.antibrute_override_desync = false

function indexOf(array, value)
    for i, v in ipairs(array) do
        if v == value then
            return i
        end
    end
    return nil
end

aa.to_state = function(value) return indexOf(aa.conditionslist, value) end

aa.state_index = {}

for k, v in pairs(aa.conditionslist) do
    aa.state_index[v]=k
end

local prev_simulation_time = 0

local function time_to_ticks(t)
    return math.floor(0.5 + (t / globals.tickinterval))
end
local diff_sim = 0
sim_diff = function()
    local current_simulation_time = time_to_ticks(entity.get_local_player().m_flSimulationTime)
    local diff = current_simulation_time - prev_simulation_time
    prev_simulation_time = current_simulation_time
    diff_sim = diff
    return diff_sim
end

sim_time_dt = 0
aa.pitch_set = "Disabled"
aa.fake_pitch_set = false
aa.fake_pitch_up = false
aa.fake_pitch_ticks = 0
aa.forcing_def = false
aa.hidden_pitch_active = false
aa.hidden_yaw_active = false
tbl = {defensive = 0, checker = 0}
antiaim_on_use = {}
antiaim_on_use.enabled = false
antiaim_on_use.start_time = globals.realtime

aa.override = function(item, value)
    if not menu_cfg_labels["Anti Aim"].access and (ui.get_alpha() > 0) then
        item:override()
    else
        item:override(value)
    end
end

aa.set_general = function()
    if aa.current_cfg == 1 then return end
    --if not aa.fake_pitch:get() then aa.pitch_set = aa.pitch:get()
    --else
        local lp = entity.get_local_player()
	    if lp then
            local tickbase = lp.m_nTickBase
            tbl.defensive = math.abs(tickbase - tbl.checker)
            tbl.checker = math.max(tickbase, tbl.checker or 0)
        end

        --aa.fake_pitch_up = (tbl.defensive > 2 and tbl.defensive < 14) and true or false
        if (tbl.defensive > 3 and (tbl.defensive % 2 == 1)--[[(tbl.defensive > 2 and tbl.defensive <= 14) or aa.forcing_def]]) and (refs.dt.on:get() or refs.hs.on:get()) then
            aa.is_defensive = true
        else 
            aa.is_defensive = false
        end

        --[[local diff = sim_diff()
        if diff <= -1 then
            aa.fake_pitch_set = true
            aa.fake_pitch_up = true
        end

        aa.fake_pitch_ticks = aa.fake_pitch_ticks + 1
        if aa.fake_pitch_ticks == 27 then
            aa.fake_pitch_ticks = 0
            aa.fake_pitch_up = false
            aa.fake_pitch_set = false
        end

        aa.pitch_set = aa.pitch:get()
        if aa.fake_pitch_up then
            aa.pitch_set = "Fake Up"
            if not refs.dt.on:get() and not refs.hs.on:get() then
                aa.fake_pitch_up = false
            end
        end
    end]]
    aa.override(refs.pitch, antiaim_on_use.enabled and "Disabled" or aa.pitch:get())
    aa.override(refs.yaw.type, antiaim_on_use.enabled and "Backward" or aa.yaw:get())
    aa.override(refs.yaw.base, antiaim_on_use.enabled and "Local View" or aa.base:get())
    aa.override(refs.yaw.avoid, aa.avoid:get())
    --refs.yaw.hidden:override(aa.hidden:get())
    if not (aim.tick:get() and aim.tick_fs:get()) then aa.override(refs.fs.on, aa.fs:get() and not aa.fs_ignore:get(aa.real_state-2)) end
    aa.override(refs.fs.mod, aa.fs_mod:get())
    aa.override(refs.fs.body, aa.fs_body:get())
    aa.override(refs.extend.on, aa.extend:get())
    aa.override(refs.extend.pitch, aa.ext_pitch:get())
    aa.override(refs.extend.roll, aa.ext_roll:get())
end

aa.cfg:set_callback(function(item)
    if item:get() == 1 then

        refs.aa:override()
        refs.pitch:override()
        refs.dt.lag:override()
        refs.hs.mode:override()
        
        for k in pairs(refs.yaw) do
            refs.yaw[k]:override()
        end

        for k in pairs(refs.modifier) do
            refs.modifier[k]:override()
        end

        for k in pairs(refs.desync) do
            refs.desync[k]:override()
        end

        for k in pairs(refs.extend) do
            refs.extend[k]:override()
        end

        for k in pairs(refs.fs) do
            refs.fs[k]:override()
        end

    end
end)

events.createmove:set(aa.set_general)

antiaim_on_use.handle = function(cmd)

    antiaim_on_use.enabled = false

    if aa.current_cfg == 1 then
        return
    end

    if not aa.conditions[10].override:get() then
        return
    end

    if not cmd.in_use then
        antiaim_on_use.start_time = globals.realtime
        return
    end

    local player = entity.get_local_player()

    if player == nil then
        return
    end

    local player_origin = player:get_origin()

    local CPlantedC4 = entity.get_entities("CPlantedC4")
    local dist_to_bomb = 999

    if #CPlantedC4 > 0 then
        local bomb = CPlantedC4[1]

        local bomb_origin = bomb:get_origin()

        dist_to_bomb = player_origin:dist(bomb_origin)
    end

    local CHostage = entity.get_entities("CHostage")
    local dist_to_hostage = 999

    if #CHostage > 0 then
        local hostage_origin = {CHostage[1]:get_origin(), CHostage[2]:get_origin()}

        dist_to_hostage = math.min(player_origin:dist(hostage_origin[1]), player_origin:dist(hostage_origin[2]))
    end

    if dist_to_hostage < 65 and player.m_iTeamNum ~= 2 then
        return
    end

    if dist_to_bomb < 65 and player.m_iTeamNum ~= 2 then
        return
    end

    if cmd.in_use then
        if globals.realtime - antiaim_on_use.start_time < 0.02 then
            return
        end
    end

    cmd.in_use = false
    antiaim_on_use.enabled = true
    
end

events.createmove:set(function(cmd) antiaim_on_use.handle(cmd) end)

aa.set_custom = function(cmd)

    if aa.current_cfg == 1 then return end

    refs.aa:override(true)

    if (aa.antibrute_current_stage > 0 and not aa.antibrute_ignore:get(aa.real_state-2) and not (aa.current_state == 12 and aa.conditions[12].override:get(9))) then aa.antibrute_active = true else aa.antibrute_active = false end

    local cond = aa.conditions[aa.current_state]

    aa.current_state = (aa.current_state ~= 2 and cond.override:get()) and aa.current_state or 2
    local cond = aa.conditions[aa.current_state]
    aa.current_state = (aa.current_state ~= 2 and aa.state_index[cond.inherit:get()] ~= 1 and aa.state_index[cond.inherit:get()] ~= aa.current_state ~= 2) and aa.state_index[cond.inherit:get()] or aa.current_state
    local cond = aa.antibrute_active and aa.antibrute_stages_items[aa.antibrute_current_stage] or aa.conditions[aa.current_state]

    --[[if aa.conditions[aa.real_state].override:get() and aa.conditions[aa.real_state].defensive_aa:get() then
        aa.forcing_def = aa.conditions[aa.real_state].defensive:get()
        aa.hidden_pitch_active = aa.conditions[aa.real_state].hidden_pitch:get()
        aa.hidden_yaw_active = aa.conditions[aa.real_state].hidden_yaw:get()
    else]]if aa.conditions[aa.current_state].defensive_aa:get() then
        aa.forcing_def = aa.conditions[aa.current_state].defensive:get()
        aa.hidden_pitch_active = aa.conditions[aa.current_state].hidden_pitch:get() and ((refs.dt.on:get() and aa.hp_cond:get(1)) or (refs.hs.on:get() and aa.hp_cond:get(2)))
        aa.hidden_yaw_active = aa.conditions[aa.current_state].hidden_yaw:get() and ((refs.dt.on:get() and aa.hy_cond:get(1)) or (refs.hs.on:get() and aa.hy_cond:get(2)))
    else
        aa.forcing_def = false
        aa.hidden_pitch_active = false
        aa.hidden_yaw_active = false
    end

    --yaw

    --print((aa.is_defensive))
    --print(tbl.defensive)
    aa.current_state = (aa.is_defensive and (aa.hidden_pitch_active or aa.hidden_yaw_active) and aa.hidden_base:get()) and 11 or aa.current_state

    aa.backup_state = aa.current_state

    if aa.current_state ~= 2 and not cond.yaw:get() then
        aa.current_state = 2
    end
    local cond = (aa.antibrute_active and aa.antibrute_stages_items[aa.antibrute_current_stage].yaw:get()) and aa.antibrute_stages_items[aa.antibrute_current_stage] or aa.conditions[aa.current_state]
    
    aa.yaw_offset = 0
    aa.yaw_offset = aa.get_desync_side() == 1 and cond.yaw_left:get() or aa.get_desync_side() == 2 and cond.yaw_right:get() or 0
    aa.yaw_offset = aa.manual_state ~= 0 and 0 or aa.yaw_offset
    if aa.manual_state ~= 0 or antiaim_on_use.enabled then aa.override(refs.yaw.base, "Local View") else aa.override(refs.yaw.base, aa.base:get()) end

    if cond.mod_select:get() == "Jitter" then
        if cond.jit_select:get() == "3-Way" or cond.jit_select:get() == "5-Way" then
            --set jitter, type and offset
            aa.override(refs.modifier.type, cond.jit_select:get())
            aa.override(refs.modifier.offset, cond.mod_range:get())
            aa.jitter = 0
        else
            aa.override(refs.modifier.type, "Disabled")
            aa.override(refs.modifier.offset, 0)
            if cond.jit_select:get() == "Custom sequence" then
                aa.jitter_counter = aa.jitter_counter + 1
                if aa.jitter_stage >= cond.jit_count:get() then
                    aa.jitter_next_stage = cond.jit_order:get() == "Bidirectional" and -1 or 1
                    aa.jitter_stage = cond.jit_order:get() == "Bidirectional" and cond.jit_count:get() or 1
                elseif aa.jitter_stage <= 1 then
                    aa.jitter_next_stage = 1
                    aa.jitter_stage = 1
                end
                if globals.choked_commands == 0 and (aa.jitter_counter >= cond.jit_custom[aa.jitter_stage].duration:get()) and (math.random(1, 100) <= cond.jit_custom[aa.jitter_stage].chance:get()) then
                    aa.jitter_stage = cond.jit_order:get() ~= "Random" and aa.jitter_stage + aa.jitter_next_stage or math.random(1, cond.jit_count:get())
                    aa.jitter_counter = 0
                end
                aa.jitter = cond.jit_custom[aa.jitter_stage].yaw:get()
            else
                aa.jitter_counter = aa.jitter_counter + 1
                if (globals.choked_commands == 0) and (aa.jitter_counter >= cond.jit_update_timer:get()) and (math.random(1, 100) <= cond.jit_update_chance:get()) then
                    aa.jitter_modifier = - aa.jitter_modifier
                    aa.jitter_counter = 0
                end
                if cond.jit_select:get() == "Center" then
                    aa.jitter = cond.mod_range:get() * aa.jitter_modifier / 2
                elseif cond.jit_select:get() == "Offset" then
                    aa.jitter = aa.jitter_modifier == 1 and cond.mod_range:get() or 0
                end
                --aa.jitter = rage.antiaim:inverter() and -aa.jitter or aa.jitter
                --print(rage.antiaim:inverter())
            end
        end
    elseif cond.mod_select:get() == "Sway" then
        aa.override(refs.modifier.type, "Disabled")
        aa.override(refs.modifier.offset, 0)
        local sway_left = cond.sway_left:get()
        local sway_right = cond.sway_right:get()
        if sway_left > sway_right then
            sway_left, sway_right = sway_right, sway_left
        end
        if globals.choked_commands == 0 then
            aa.jitter = aa.jitter + cond.sway_speed:get() * aa.sway_direction
            aa.sway_direction = (cond.sway_dir:get() == "Random switch" and math.random(cond.sway_switch:get(), 100) == 100) and -aa.sway_direction or aa.sway_direction
            if (aa.jitter >= sway_right) or (aa.jitter <= sway_left) then
                aa.sway_direction = (cond.sway_dir:get() == "Bidirectional") and -aa.sway_direction or (cond.sway_dir:get() == "Unidirectional") and aa.sway_direction or aa.sway_direction * sign(math.random(-1, 1))
            end
            if cond.sway_dir:get() == "Unidirectional" then
                if aa.jitter >= sway_right and aa.sway_direction == 1 then aa.jitter = sway_left end
                if aa.jitter <= sway_left and aa.sway_direction == -1 then aa.jitter = sway_right end
            end
            aa.sway_jitter = cond.sway_jitter:get() and -aa.sway_jitter or 1
        end
        --print(aa.jitter)
        aa.jitter = clamp(aa.jitter, sway_left, sway_right)
    elseif cond.mod_select:get() == "Random" or cond.mod_select:get() == "Spin" then
        aa.override(refs.modifier.type, cond.mod_select:get())
        aa.override(refs.modifier.offset, cond.mod_range:get())
    else
        aa.jitter = 0
        aa.override(refs.modifier.type, "Disabled")
        aa.override(refs.modifier.offset, 0)
        --refs.modifier.typeaa.override()
        --refs.modifier.offsetaa.override()
    end

    aa.sway_jitter = cond.mod_select:get() == "Sway" and aa.sway_jitter or 1

    --aa.yaw_offset = (aa.antibrute_active and aa.antibrute_yaw_offset > -181) and aa.antibrute_yaw_offset or aa.yaw_offset
    
    --aa.jitter = (aa.antibrute_active and aa.antibrute_jitter > -181) and aa.antibrute_jitter or aa.jitter

    aa.yaw_offset = aa.yaw_offset + aa.jitter * aa.sway_jitter

    aa.yaw_offset = aa.manual_state == 1 and aa.yaw_offset - 90 or aa.manual_state == 3 and aa.yaw_offset + 90 or aa.yaw_offset
    aa.yaw_offset = antiaim_on_use.enabled and 180 - aa.yaw_offset or aa.yaw_offset

    aa.override(refs.yaw.offset, aa.yaw_offset)

    --desync

    aa.current_state = aa.backup_state
    cond = aa.conditions[aa.current_state]

    if aa.current_state ~= 2 and not cond.desync:get() then
        --aa.backup_state = aa.current_state
        aa.current_state = 2
    --else
    --    aa.current_state = aa.backup_state
    end

    local cond = (aa.antibrute_active and aa.antibrute_stages_items[aa.antibrute_current_stage].desync:get()) and aa.antibrute_stages_items[aa.antibrute_current_stage] or aa.conditions[aa.current_state]

    --print(aa.conditionslist[aa.current_state].." "..aa.conditionslist[aa.backup_state])

    if cond.desync_mode:get() == "Sway" then
        local sway_left = cond.desync_left:get()
        local sway_right = cond.desync_right:get()
        if sway_left > sway_right then
            sway_left, sway_right = sway_right, sway_left
        end
        if globals.choked_commands == 0 then
            aa.desync = aa.desync + cond.ds_sway_speed:get() * aa.ds_sway_direction
            aa.ds_sway_direction = (cond.desync_sway:get() == "Random switch" and math.random(cond.ds_sway_switch:get(), 100) == 100) and -aa.ds_sway_direction or aa.ds_sway_direction
            if (aa.desync >= sway_right) or (aa.desync <= sway_left) then
                aa.ds_sway_direction = cond.desync_sway:get() == "Bidirectional" and -aa.ds_sway_direction or cond.desync_sway:get() == "Unidirectional" and aa.ds_sway_direction or aa.ds_sway_direction * sign(math.random(-1, 1))
            end
            if cond.desync_sway:get() == "Unidirectional" then
                if aa.desync >= sway_right and aa.ds_sway_direction == 1 then aa.desync = sway_left end
                if aa.desync <= sway_left and aa.ds_sway_direction == -1 then aa.desync = sway_right end
            end
        end
        --[[if globals.choked_commands == 0 then
            aa.sway_jitter = cond.sway_jitter:get() and -aa.sway_jitter or 1
        end
        --print(aa.jitter)]]
        aa.desync = clamp(aa.desync, sway_left, sway_right)
    elseif cond.desync_mode:get() == "Random" then
        if globals.choked_commands == 0 then
            aa.desync = math.random(cond.desync_left:get(), cond.desync_right:get())
        end
        --add jitter
    elseif cond.desync_mode:get() == "Custom sequence" then
        aa.desync_counter = aa.desync_counter + 1
        if aa.desync_stage >= cond.ds_count:get() then
            aa.desync_next_stage = cond.ds_order:get() == "Bidirectional" and -1 or 1
            aa.desync_stage = cond.ds_order:get() == "Bidirectional" and cond.ds_count:get() or 1
        elseif aa.desync_stage <= 1 then
            aa.desync_next_stage = 1
            aa.desync_stage = 1
        end
        if globals.choked_commands == 0 and (aa.desync_counter >= cond.ds_custom[aa.desync_stage].duration:get()) and (math.random(1, 100) <= cond.ds_custom[aa.desync_stage].chance:get()) then
            aa.desync_stage = cond.ds_order:get() ~= "Random" and aa.desync_stage + aa.desync_next_stage or math.random(1, cond.ds_count:get())
            aa.desync_counter = 0
        end
        aa.desync = cond.ds_custom[aa.desync_stage].yaw:get()
    end
  
    if cond.desync_mode:get() == "Static" then
        aa.override(refs.desync.limit_left, math.abs(cond.desync_l_left:get()))
        aa.override(refs.desync.limit_right, math.abs(cond.desync_l_right:get()))
    else
        aa.override(refs.desync.limit_left, math.abs(aa.desync))
        aa.override(refs.desync.limit_right, math.abs(aa.desync))
        if aa.desync > 0 then
            rage.antiaim:inverter(true)
        elseif aa.desync < 0 then
            rage.antiaim:inverter(false)
        end
    end
    
    aa.override(refs.desync.invert, aa.invert:get() and not cond.desync_inverter:get() or cond.desync_inverter:get())
    aa.override(refs.desync.options, cond.desync_options:get())
    aa.override(refs.desync.fs, cond.desync_fs:get())

end

events.createmove:set(function(cmd) aa.set_custom(cmd) end)

aa.hidden_pitch = 0
aa.hp_sway_dir = 1
aa.hidden_yaw = 0
aa.hy_sway_dir = 1
aa.hidden_jit_sign = -1

aa.set_hidden = function(cmd)
    if aa.current_cfg == 1 then return end
    if aa.forcing_def then
        --rage.exploit:allow_defensive(refs.dt.on:get() and false or true)
        --cmd.force_defensive = true
        refs.dt.lag:override("Always On")
        refs.hs.mode:override("Break LC")
    else
        aim.forcing_def = false
        --rage.exploit:allow_defensive(true)
        refs.dt.lag:override()
        refs.hs.mode:override()
    end

    if globals.choked_commands == 0 then aa.hidden_jit_sign = -aa.hidden_jit_sign end

    if aa.h_pitch:get() == "Static" then
        aa.hidden_pitch = aa.hp_base:get()
    elseif aa.h_pitch:get() == "Jitter" then
        aa.hidden_pitch = aa.hidden_jit_sign == -1 and aa.hp_up:get() or aa.hp_down:get()
    elseif aa.h_pitch:get() == "Sway" then
        local sway_left = aa.hp_up:get()
        local sway_right = aa.hp_down:get()
        if sway_left > sway_right then
            sway_left, sway_right = sway_right, sway_left
        end
        if globals.choked_commands == 0 then
            aa.hidden_pitch = aa.hidden_pitch + aa.hp_sway_speed:get() * aa.hp_sway_dir
            if (aa.hidden_pitch >= sway_right) or (aa.hidden_pitch <= sway_left) then
                aa.hp_sway_dir = aa.hp_sway_direction:get() == "Bidirectional" and -aa.hp_sway_dir or aa.hp_sway_direction:get() == "Unidirectional" and aa.hp_sway_dir
            end
            if aa.hp_sway_direction:get() == "Unidirectional" then
                if aa.hidden_pitch >= sway_right and aa.hp_sway_dir == 1 then aa.hidden_pitch = sway_left end
                if aa.hidden_pitch <= sway_left and aa.hp_sway_dir == -1 then aa.hidden_pitch = sway_right end
            end
        end
        aa.hidden_pitch = clamp(aa.hidden_pitch, sway_left, sway_right)
    elseif aa.h_pitch:get() == "Random" then
        if globals.choked_commands == 0 then
            aa.hidden_pitch = math.random(aa.hp_up:get(), aa.hp_down:get())
        end
        if aa.hp_rj:get() then aa.hidden_pitch = aa.hidden_pitch * aa.hidden_jit_sign end
    end
    
    if aa.h_yaw:get() == "Static" then
        aa.hidden_yaw= aa.hy_base:get()
    elseif aa.h_yaw:get() == "Jitter" then
        aa.hidden_yaw = aa.hidden_jit_sign == -1 and aa.hy_left:get() or aa.hy_right:get()
    elseif aa.h_yaw:get() == "Sway" then
        local sway_left = aa.hy_left:get()
        local sway_right = aa.hy_right:get()
        if sway_left > sway_right then
            sway_left, sway_right = sway_right, sway_left
        end
        if globals.choked_commands == 0 then
            aa.hidden_yaw = aa.hidden_yaw + aa.hy_sway_speed:get() * aa.hy_sway_dir
            if (aa.hidden_yaw >= sway_right) or (aa.hidden_yaw <= sway_left) then
                aa.hy_sway_dir = aa.hy_sway_direction:get() == "Bidirectional" and -aa.hy_sway_dir or aa.hy_sway_direction:get() == "Unidirectional" and aa.hy_sway_dir
            end
            if aa.hy_sway_direction:get() == "Unidirectional" then
                if aa.hidden_yaw >= sway_right and aa.hy_sway_dir == 1 then aa.hidden_yaw = sway_left end
                if aa.hidden_yaw <= sway_left and aa.hy_sway_dir == -1 then aa.hidden_yaw = sway_right end
            end
        end
        aa.hidden_yaw = clamp(aa.hidden_yaw, sway_left, sway_right)
    elseif aa.h_yaw:get() == "Random" then
        if globals.choked_commands == 0 then
            aa.hidden_yaw = math.random(aa.hy_left:get(), aa.hy_right:get())
        end
        if aa.hy_rj:get() then aa.hidden_yaw = aa.hidden_yaw * aa.hidden_jit_sign end
    end

    --aa.hidden_yaw = -aa.hidden_yaw

    if aa.hidden_pitch_active or aa.hidden_yaw_active then aa.override(refs.yaw.hidden, true) else refs.yaw.hidden:override() end

    if aa.hidden_pitch_active and aa.h_pitch:get() ~= "Default" then
        rage.antiaim:override_hidden_pitch(aa.hidden_pitch)
    end
    if aa.h_yaw:get() ~= "Default" then
        if aa.hidden_yaw_active then
            rage.antiaim:override_hidden_yaw_offset(aa.hidden_yaw)
        else
            rage.antiaim:override_hidden_yaw_offset(0)
        end
    end
end

events.createmove:set(aa.set_hidden)

aa.antibrute_handler = function()
    if not aa.antibrute:get() then
        aa.antibrute_counter = 0
        aa.antibrute_current_stage = 0
        return
    end

    if aa.antibrute_current_stage > 0 then
        aa.antibrute_counter = aa.antibrute_counter + 1
    end

    if (ticks_to_time(aa.antibrute_counter) >= aa.antibrute_timer:get() and aa.antibrute_timer:get() > 0) or aa.antibrute_current_stage > (#aa.antibrute_stage_table) then
        aa.antibrute_counter = 0
        aa.antibrute_current_stage = aa.antibrute_current_stage > (#aa.antibrute_stage_table) and 1 or 0
    end

    --[[if aa.antibrute_current_stage > 0 then aa.antibrute_active = true else aa.antibrute_active = false end

    if not aa.antibrute_active then return end]]

end

events.createmove:set(aa.antibrute_handler)

--[[aa.antibrute_reset = function(event)
    if event.name == "round_end" or (event.name == "player_death" and entity.get(event.userid, true) == entity.get_local_player()) then
        aa.antibrute_counter = 0
        aa.antibrute_current_stage = 0
    end
end

callbacks.add(e_callbacks.EVENT, aa.antibrute_reset)]]

events.round_end:set(function()
    aa.antibrute_counter = 0
    aa.antibrute_current_stage = 0
end)

events.player_death:set(function(ev)
    if entity.get(ev.userid, true) == entity.get_local_player() then
        aa.antibrute_counter = 0
        aa.antibrute_current_stage = 0
    end
end)

aa.antibrute_work_distance = 75
aa.antibrute_last_tick_triggered = 0

aa.antibrute_bullet_impact = function(...)

    local args = {...}
    local local_pos = args[3]

    local distance = dist_to(math_closest_point_on_ray(...), local_pos)

    if distance > aa.antibrute_work_distance then
        return
    end

    aa.antibrute_counter = 0
    aa.antibrute_current_stage = aa.antibrute_current_stage + 1
    misc.miss_trigger = true

    aa.antibrute_last_tick_triggered = globals.tickcount
end

aa.antibrute_pre_bullet_impact = function(ev)

    if not (aa.antibrute:get() or (misc.miss:get() ~= "Disabled") or misc.s_miss:get()) --[[or #aa.antibrute_stage_table == 1]] then return end

    if aa.antibrute_last_tick_triggered == globals.tickcount then
        return
    end

    local me = entity_helpers.local_player.pointer()

    if not me or me.m_iHealth <= 0 then
        return
    end

    local userid = ev.userid

    if userid == nil then
        return
    end


    local player_object = entity.get(userid, true)

    if not player_object or player_object:is_dormant() or (not player_object:is_enemy()) then
        return
    end

    local eye_position = me:get_eye_position()

    if not eye_position then
        return
    end

    local enemy_eye_position = player_object:get_eye_position()

    if not enemy_eye_position then
        return
    end

    local x = ev.x
    local y = ev.y
    local z = ev.z

    if x == nil or y == nil or z == nil then
        return
    end

    local impact_vector = vector(x, y, z)
    misc.last_shooter = userid

    return aa.antibrute_bullet_impact(impact_vector, enemy_eye_position, eye_position)
end

events.bullet_impact:set(function(ev) aa.antibrute_pre_bullet_impact(ev) end)

aim = {}

aim.items = {
    {ui.get_icon("transporter"), "   Ideal tick"},
    {ui.get_icon("gears"), "   Exploit tweaks"}, 
    {ui.get_icon("suitcase-medical"), "   Helpers"}, 
}

aim.mselect = ui.create_gr(ui.get_icon("crosshairs-simple").." Rage", "> Menu selection")
aim.tabs = {
    ui.create_gr(ui.get_icon("crosshairs-simple").." Rage", " > Ideal tick"),
    ui.create_gr(ui.get_icon("crosshairs-simple").." Rage", " > Exploit tweaks"),
    ui.create_gr(ui.get_icon("crosshairs-simple").." Rage", " > Helpers"),
}

aim.mlist = aim.mselect:menu_select(aim.items, aim.tabs)

aim.tick_g = aim.tabs[1]--ui.create_gr(ui.get_icon("crosshairs-simple").." Rage", " > Ideal tick")
aim.tick = aim.tick_g:switch_e("Ideal tick")
aim.tick_g:label_e("Override:")
aim.tick_dt = aim.tick_g:switch_e("Double tap")
aim.tick_dt_g = ui.create_sub(aim.tick_dt)
aim.tick_dt_lag = aim.tick_dt_g:combo_e("Lag Options", {"Disabled", "On peek", "Always on"})
aim.tick_dt_max = aim.tick_dt_g:slider_e("Fake lag limit", 1, 10)
aim.tick_dt_tp = aim.tick_dt_g:switch_e("Immediate teleport")
aim.tick_dt_qs = aim.tick_dt_g:switch_e("Quick switch")
aim.tick_fs = aim.tick_g:switch_e("Freestanding")
aim.tick:tooltip("Set this on a bind!")

aim.dt_g = aim.tabs[2]--ui.create_gr(ui.get_icon("crosshairs-simple").." Rage", " > Exploit tweaks")
aim.force_tp = aim.dt_g:hotkey_e("Force teleport")
--[[aim.force_tp:tooltip("Set this on a bind!")
aim.force_tp:set_callback(function(ref)
    if ref:get() and (rage.exploit:get() ~= 0) then
        rage.exploit:force_teleport()
    end
    aim.force_tp:set(false)
end)]]
--aim.force_def = aim.dt_g:switch_e("Force defensive in air")

aim.ideal_tp = false
aim.tp_tick = 0

aim.forcing_def = false

aim.current_wep = 0
aim.current_wep_state = nil
aim.helpers_g = aim.tabs[3]
aim.weapon_list = {{"SSG-08", ""}, {"Autosnipers", ""}, {"AWP", ""}, {"Revolver", ""}, {"Desert Eagle", ""}}
aim.weapon_select = aim.helpers_g:list_col("Weapon selection", aim.weapon_list)
aim.cur_wep_tab = 1
aim.weapon_table = {}
aim.wep_cond_translate = {
    ["In air"] = "air", ["No scope"] = "noscope", ["Height disadvantage"] = "low", ["Distance"] = "far", ["Lethal target"] = "lethal", ["Ideal tick"] = "tick",
}
aim.wep_ov_translate = {
    ["hitbox"] = "Hitboxes",
    ["multipoint"] = "Multipoint",
    ["mp_gr"] = "Multipoint",
    ["mp_head"] = "Multipoint",
    ["mp_body"] = "Multipoint",
    ["hc"] = "Hitchance",
    ["hc_dt"] = "Hitchance",
    ["md"] = "Min. Damage",
    ["delay"] = "Min. Damage",
    ["baim"] = "Body Aim",
    ["baim_gr"] = "Body Aim",
    ["baim_disablers"] = "Body Aim",
    ["baim_fp"] = "Body Aim",
    ["sp"] = "Safe Points",
    ["sp_force"] = "Ensure Hitbox Safety",
}
aim.wep_cond_scoped = {"In air", "No scope", "Height disadvantage", "Distance", "Lethal target", "Ideal tick"}
aim.wep_cond = {"In air", "Height disadvantage", "Distance", "Lethal target", "Ideal tick"}

for i=1, #aim.weapon_list do
    aim.weapon_table[i] = {group = ui.create_gr(ui.get_icon("crosshairs-simple").." Rage", " > Weapon settings - "..aim.weapon_list[i][1], 2)}
    local wep = aim.weapon_table[i]
    local wep_gr = wep.group
    wep_gr:visibility(false)
    wep.autotp = wep_gr:switch_e("Auto teleport in air")
    if (i == 2) or (i == 5) then
        wep.hp = wep_gr:switch_e("Min. Damage = HP/2")
    end
    wep.cfglabel = wep_gr:label_cfg("Rage")
    wep.conditions = wep_gr:combo_e("Current condition", (i < 4) and aim.wep_cond_scoped or aim.wep_cond)
    wep.air = {
        on = wep_gr:switch_e("» In air"),
        overrides = wep_gr:selectable_e("Overrides", {"Hitboxes", "Multipoint", "Hitchance", "Min. Damage", "Body Aim", "Safe Points", "Ensure Hitbox Safety"}),
        hitbox = wep_gr:selectable_e("Hitboxes", {"Head", "Chest", "Stomach", "Arms", "Legs", "Feet"}),
        multipoint = wep_gr:selectable_e("Multipoint", {"Head", "Chest", "Stomach", "Arms", "Legs", "Feet"}),
        hc = wep_gr:slider_e("Hitchance", 0, 100, 65, 1.0, function(raw) if raw == 0 then return "Auto" else return raw.."%" end end),
        md = wep_gr:slider_e("Min. Damage", 0, 130, 0, 1.0, function(raw) if raw == 0 then return "Auto" elseif raw > 100 then return "+"..raw-100 else return end end),
        baim = wep_gr:combo_e("Body Aim", {"Default", "Prefer", "Force"}),
        sp = wep_gr:combo_e("Safe Points", {"Default", "Prefer", "Force"}),
        sp_force = wep_gr:selectable_e("Ensure Hitbox Safety", {"Head", "Chest", "Stomach", "Arms", "Legs", "Feet"}),
    }
    local gr = wep.air
    gr.mp_gr = ui.create_sub(gr.multipoint)
    gr.mp_head = gr.mp_gr:slider_e("Head Scale", 0, 100, 0, 1.0, function(raw) if raw == 0 then return "Auto" else return end end)
    gr.mp_body = gr.mp_gr:slider_e("Body Scale", 0, 100, 0, 1.0, function(raw) if raw == 0 then return "Auto" else return end end)
    gr.hc_dt = ui.create_sub(gr.hc):slider_e("Double Tap", 0, 100, 0, 1.0, function(raw) if raw == 0 then return "Auto" else return raw.."%" end end)
    gr.delay = ui.create_sub(gr.md):switch_e("Delay Shot")
    gr.baim_gr = ui.create_sub(gr.baim)
    gr.baim_disablers = gr.baim_gr:selectable_e("Disablers", {"Target Resolved", "Target Shooting", "Head Safepoint", "Low Damage"})
    gr.baim_fp = gr.baim_gr:switch_e("Force on Peek")
    --[[gr.on:set_callback(function(ref)
        for k in pairs(gr) do
            if k ~= "on" then
                gr[k]:visibility(ref:get() and ((k ~= "overrides" and k ~= "min" and k ~= "max" and gr.overrides:get(aim.wep_ov_translate[k])) or k == "overrides" or k == "min" or k == "max"))
            end
        end
    end, true)
    gr.overrides:set_callback(function(ref)
        for k in pairs(gr) do
            if k ~= "on" then
                gr[k]:visibility(gr.on:get() and ((k ~= "overrides" and k ~= "min" and k ~= "max" and ref:get(aim.wep_ov_translate[k])) or k == "overrides" or k == "min" or k == "max"))
            end
        end
    end, true)]]
    if i < 4 then
        wep.noscope = {
            on = wep_gr:switch_e("» No scope"),
            overrides = wep_gr:selectable_e("Overrides", {"Hitboxes", "Multipoint", "Hitchance", "Min. Damage", "Body Aim", "Safe Points", "Ensure Hitbox Safety"}),
            hitbox = wep_gr:selectable_e("Hitboxes", {"Head", "Chest", "Stomach", "Arms", "Legs", "Feet"}),
            multipoint = wep_gr:selectable_e("Multipoint", {"Head", "Chest", "Stomach", "Arms", "Legs", "Feet"}),
            hc = wep_gr:slider_e("Hitchance", 0, 100, 65, 1.0, function(raw) if raw == 0 then return "Auto" else return raw.."%" end end),
            md = wep_gr:slider_e("Min. Damage", 0, 130, 0, 1.0, function(raw) if raw == 0 then return "Auto" elseif raw > 100 then return "+"..raw-100 else return end end),
            baim = wep_gr:combo_e("Body Aim", {"Default", "Prefer", "Force"}),
            sp = wep_gr:combo_e("Safe Points", {"Default", "Prefer", "Force"}),
            sp_force = wep_gr:selectable_e("Ensure Hitbox Safety", {"Head", "Chest", "Stomach", "Arms", "Legs", "Feet"}),
        }
        local gr = wep.noscope
        gr.mp_gr = ui.create_sub(gr.multipoint)
        gr.mp_head = gr.mp_gr:slider_e("Head Scale", 0, 100, 0, 1.0, function(raw) if raw == 0 then return "Auto" else return end end)
        gr.mp_body = gr.mp_gr:slider_e("Body Scale", 0, 100, 0, 1.0, function(raw) if raw == 0 then return "Auto" else return end end)
        gr.hc_dt = ui.create_sub(gr.hc):slider_e("Double Tap", 0, 100, 0, 1.0, function(raw) if raw == 0 then return "Auto" else return raw.."%" end end)
        gr.delay = ui.create_sub(gr.md):switch_e("Delay Shot")
        gr.baim_gr = ui.create_sub(gr.baim)
    gr.baim_disablers = gr.baim_gr:selectable_e("Disablers", {"Target Resolved", "Target Shooting", "Head Safepoint", "Low Damage"})
    gr.baim_fp = gr.baim_gr:switch_e("Force on Peek")
        --[[gr.on:set_callback(function(ref)
            for k in pairs(gr) do
                if k ~= "on" then
                    gr[k]:visibility(ref:get() and ((k ~= "overrides" and k ~= "min" and k ~= "max" and gr.overrides:get(aim.wep_ov_translate[k])) or k == "overrides" or k == "min" or k == "max"))
                end
            end
        end, true)
        gr.overrides:set_callback(function(ref)
            for k in pairs(gr) do
                if k ~= "on" then
                    gr[k]:visibility(gr.on:get() and ((k ~= "overrides" and k ~= "min" and k ~= "max" and ref:get(aim.wep_ov_translate[k])) or k == "overrides" or k == "min" or k == "max"))
                end
            end
        end, true)]]
    end
    wep.low = {
        on = wep_gr:switch_e("» Height disadvantage"),
        overrides = wep_gr:selectable_e("Overrides", {"Hitboxes", "Multipoint", "Hitchance", "Min. Damage", "Body Aim", "Safe Points", "Ensure Hitbox Safety"}),
        hitbox = wep_gr:selectable_e("Hitboxes", {"Head", "Chest", "Stomach", "Arms", "Legs", "Feet"}),
        multipoint = wep_gr:selectable_e("Multipoint", {"Head", "Chest", "Stomach", "Arms", "Legs", "Feet"}),
        hc = wep_gr:slider_e("Hitchance", 0, 100, 65, 1.0, function(raw) if raw == 0 then return "Auto" else return raw.."%" end end),
        md = wep_gr:slider_e("Min. Damage", 0, 130, 0, 1.0, function(raw) if raw == 0 then return "Auto" elseif raw > 100 then return "+"..raw-100 else return end end),
        baim = wep_gr:combo_e("Body Aim", {"Default", "Prefer", "Force"}),
        sp = wep_gr:combo_e("Safe Points", {"Default", "Prefer", "Force"}),
        sp_force = wep_gr:selectable_e("Ensure Hitbox Safety", {"Head", "Chest", "Stomach", "Arms", "Legs", "Feet"}),
    }
    local gr = wep.low
    gr.mp_gr = ui.create_sub(gr.multipoint)
    gr.mp_head = gr.mp_gr:slider_e("Head Scale", 0, 100, 0, 1.0, function(raw) if raw == 0 then return "Auto" else return end end)
    gr.mp_body = gr.mp_gr:slider_e("Body Scale", 0, 100, 0, 1.0, function(raw) if raw == 0 then return "Auto" else return end end)
    gr.hc_dt = ui.create_sub(gr.hc):slider_e("Double Tap", 0, 100, 0, 1.0, function(raw) if raw == 0 then return "Auto" else return raw.."%" end end)
    gr.delay = ui.create_sub(gr.md):switch_e("Delay Shot")
    gr.baim_gr = ui.create_sub(gr.baim)
    gr.baim_disablers = gr.baim_gr:selectable_e("Disablers", {"Target Resolved", "Target Shooting", "Head Safepoint", "Low Damage"})
    gr.baim_fp = gr.baim_gr:switch_e("Force on Peek")
    --[[gr.on:set_callback(function(ref)
        for k in pairs(gr) do
            if k ~= "on" then
                gr[k]:visibility(ref:get() and ((k ~= "overrides" and k ~= "min" and k ~= "max" and gr.overrides:get(aim.wep_ov_translate[k])) or k == "overrides" or k == "min" or k == "max"))
            end
        end
    end, true)
    gr.overrides:set_callback(function(ref)
        for k in pairs(gr) do
            if k ~= "on" then
                gr[k]:visibility(gr.on:get() and ((k ~= "overrides" and k ~= "min" and k ~= "max" and ref:get(aim.wep_ov_translate[k])) or k == "overrides" or k == "min" or k == "max"))
            end
        end
    end, true)]]
    wep.far = {
        on = wep_gr:switch_e("» Distance"),
        overrides = wep_gr:selectable_e("Overrides", {"Hitboxes", "Multipoint", "Hitchance", "Min. Damage", "Body Aim", "Safe Points", "Ensure Hitbox Safety"}),
        hitbox = wep_gr:selectable_e("Hitboxes", {"Head", "Chest", "Stomach", "Arms", "Legs", "Feet"}),
        multipoint = wep_gr:selectable_e("Multipoint", {"Head", "Chest", "Stomach", "Arms", "Legs", "Feet"}),
        hc = wep_gr:slider_e("Hitchance", 0, 100, 65, 1.0, function(raw) if raw == 0 then return "Auto" else return raw.."%" end end),
        md = wep_gr:slider_e("Min. Damage", 0, 130, 0, 1.0, function(raw) if raw == 0 then return "Auto" elseif raw > 100 then return "+"..raw-100 else return end end),
        baim = wep_gr:combo_e("Body Aim", {"Default", "Prefer", "Force"}),
        sp = wep_gr:combo_e("Safe Points", {"Default", "Prefer", "Force"}),
        sp_force = wep_gr:selectable_e("Ensure Hitbox Safety", {"Head", "Chest", "Stomach", "Arms", "Legs", "Feet"}),
    }
    local gr = wep.far
    gr.min = ui.create_sub(gr.on):slider_e("Minimum distance", 0, 10000, 1500, 1.0, " m")
    gr.mp_gr = ui.create_sub(gr.multipoint)
    gr.mp_head = gr.mp_gr:slider_e("Head Scale", 0, 100, 0, 1.0, function(raw) if raw == 0 then return "Auto" else return end end)
    gr.mp_body = gr.mp_gr:slider_e("Body Scale", 0, 100, 0, 1.0, function(raw) if raw == 0 then return "Auto" else return end end)
    gr.hc_dt = ui.create_sub(gr.hc):slider_e("Double Tap", 0, 100, 0, 1.0, function(raw) if raw == 0 then return "Auto" else return raw.."%" end end)
    gr.delay = ui.create_sub(gr.md):switch_e("Delay Shot")
    gr.baim_gr = ui.create_sub(gr.baim)
    gr.baim_disablers = gr.baim_gr:selectable_e("Disablers", {"Target Resolved", "Target Shooting", "Head Safepoint", "Low Damage"})
    gr.baim_fp = gr.baim_gr:switch_e("Force on Peek")
    --[[gr.on:set_callback(function(ref)
        for k in pairs(gr) do
            if k ~= "on" then
                gr[k]:visibility(ref:get() and ((k ~= "overrides" and k ~= "min" and k ~= "max" and gr.overrides:get(aim.wep_ov_translate[k])) or k == "overrides" or k == "min" or k == "max"))
            end
        end
    end, true)
    gr.overrides:set_callback(function(ref)
        for k in pairs(gr) do
            if k ~= "on" then
                gr[k]:visibility(gr.on:get() and ((k ~= "overrides" and k ~= "min" and k ~= "max" and ref:get(aim.wep_ov_translate[k])) or k == "overrides" or k == "min" or k == "max"))
            end
        end
    end, true)]]
    wep.lethal = {
        on = wep_gr:switch_e("» Lethal target"),
        overrides = wep_gr:selectable_e("Overrides", {"Hitboxes", "Multipoint", "Hitchance", "Min. Damage", "Body Aim", "Safe Points", "Ensure Hitbox Safety"}),
        hitbox = wep_gr:selectable_e("Hitboxes", {"Head", "Chest", "Stomach", "Arms", "Legs", "Feet"}),
        multipoint = wep_gr:selectable_e("Multipoint", {"Head", "Chest", "Stomach", "Arms", "Legs", "Feet"}),
        hc = wep_gr:slider_e("Hitchance", 0, 100, 65, 1.0, function(raw) if raw == 0 then return "Auto" else return raw.."%" end end),
        md = wep_gr:slider_e("Min. Damage", 0, 130, 0, 1.0, function(raw) if raw == 0 then return "Auto" elseif raw > 100 then return "+"..raw-100 else return end end),
        baim = wep_gr:combo_e("Body Aim", {"Default", "Prefer", "Force"}),
        sp = wep_gr:combo_e("Safe Points", {"Default", "Prefer", "Force"}),
        sp_force = wep_gr:selectable_e("Ensure Hitbox Safety", {"Head", "Chest", "Stomach", "Arms", "Legs", "Feet"}),
    }
    local gr = wep.lethal
    gr.max = ui.create_sub(gr.on):slider_e("Maximum health", 0, 100, 80, 1.0, " hp")
    gr.mp_gr = ui.create_sub(gr.multipoint)
    gr.mp_head = gr.mp_gr:slider_e("Head Scale", 0, 100, 0, 1.0, function(raw) if raw == 0 then return "Auto" else return end end)
    gr.mp_body = gr.mp_gr:slider_e("Body Scale", 0, 100, 0, 1.0, function(raw) if raw == 0 then return "Auto" else return end end)
    gr.hc_dt = ui.create_sub(gr.hc):slider_e("Double Tap", 0, 100, 0, 1.0, function(raw) if raw == 0 then return "Auto" else return raw.."%" end end)
    gr.delay = ui.create_sub(gr.md):switch_e("Delay Shot")
    gr.baim_gr = ui.create_sub(gr.baim)
    gr.baim_disablers = gr.baim_gr:selectable_e("Disablers", {"Target Resolved", "Target Shooting", "Head Safepoint", "Low Damage"})
    gr.baim_fp = gr.baim_gr:switch_e("Force on Peek")
    --[[gr.on:set_callback(function(ref)
        for k in pairs(gr) do
            if k ~= "on" then
                gr[k]:visibility(ref:get() and ((k ~= "overrides" and k ~= "min" and k ~= "max" and gr.overrides:get(aim.wep_ov_translate[k])) or k == "overrides" or k == "min" or k == "max"))
            end
        end
    end, true)
    gr.overrides:set_callback(function(ref)
        for k in pairs(gr) do
            if k ~= "on" then
                gr[k]:visibility(gr.on:get() and ((k ~= "overrides" and k ~= "min" and k ~= "max" and ref:get(aim.wep_ov_translate[k])) or k == "overrides" or k == "min" or k == "max"))
            end
        end
    end, true)]]
    --wep.air_hc = wep_gr:slider_e("Hit chance in air", 0, 100, 65, 1.0, "%")
    --[[wep.conditions:set_callback(function()
        for k, v in pairs(aim.wep_cond_translate) do
            local yes = k == wep.conditions:get()
            local cond = wep[v]
            if cond then
                for x in pairs(cond) do
                    if x ~= "on" then
                        cond[x]:visibility(yes and cond.on:get() and ((x ~= "overrides" and x ~= "min" and x ~= "max" and cond.overrides:get(aim.wep_ov_translate[x])) or x == "overrides" or x == "min" or x == "max"))
                    else
                        cond[x]:visibility(yes)
                    end
                end
            end
        end
    end, true)]]
    wep.tick = {
        on = wep_gr:switch_e("» Ideal tick"),
        overrides = wep_gr:selectable_e("Overrides", {"Hitboxes", "Multipoint", "Hitchance", "Min. Damage", "Body Aim", "Safe Points", "Ensure Hitbox Safety"}),
        hitbox = wep_gr:selectable_e("Hitboxes", {"Head", "Chest", "Stomach", "Arms", "Legs", "Feet"}),
        multipoint = wep_gr:selectable_e("Multipoint", {"Head", "Chest", "Stomach", "Arms", "Legs", "Feet"}),
        hc = wep_gr:slider_e("Hitchance", 0, 100, 65, 1.0, function(raw) if raw == 0 then return "Auto" else return raw.."%" end end),
        md = wep_gr:slider_e("Min. Damage", 0, 130, 0, 1.0, function(raw) if raw == 0 then return "Auto" elseif raw > 100 then return "+"..raw-100 else return end end),
        baim = wep_gr:combo_e("Body Aim", {"Default", "Prefer", "Force"}),
        sp = wep_gr:combo_e("Safe Points", {"Default", "Prefer", "Force"}),
        sp_force = wep_gr:selectable_e("Ensure Hitbox Safety", {"Head", "Chest", "Stomach", "Arms", "Legs", "Feet"}),
    }
    local gr = wep.tick
    gr.mp_gr = ui.create_sub(gr.multipoint)
    gr.mp_head = gr.mp_gr:slider_e("Head Scale", 0, 100, 0, 1.0, function(raw) if raw == 0 then return "Auto" else return end end)
    gr.mp_body = gr.mp_gr:slider_e("Body Scale", 0, 100, 0, 1.0, function(raw) if raw == 0 then return "Auto" else return end end)
    gr.hc_dt = ui.create_sub(gr.hc):slider_e("Double Tap", 0, 100, 0, 1.0, function(raw) if raw == 0 then return "Auto" else return raw.."%" end end)
    gr.delay = ui.create_sub(gr.md):switch_e("Delay Shot")
    gr.baim_gr = ui.create_sub(gr.baim)
    gr.baim_disablers = gr.baim_gr:selectable_e("Disablers", {"Target Resolved", "Target Shooting", "Head Safepoint", "Low Damage"})
    gr.baim_fp = gr.baim_gr:switch_e("Force on Peek")
end

aim.helpers_visibility = function()
    if not (ui.get_alpha() > 0) then return end
    for i=1, #aim.weapon_list do
        local wep = aim.weapon_table[i]
        for k, v in pairs(aim.wep_cond_translate) do
            local yes = k == wep.conditions:get()
            local cond = wep[v]
            if cond then
                for x in pairs(cond) do
                    local yesyes = true
                    if x ~= "autotp" and x ~= "hp" and x ~= "cfglabel" then
                        yesyes = menu_cfg_labels["Rage"].access
                        --print(yesyes)
                    end
                    wep.conditions:visibility(yesyes)
                    if x ~= "on" then
                        cond[x]:visibility(yesyes and (yes and cond.on:get() and ((x ~= "overrides" and x ~= "min" and x ~= "max" and cond.overrides:get(aim.wep_ov_translate[x])) or x == "overrides" or x == "min" or x == "max")))
                    else
                        cond[x]:visibility(yesyes and yes)
                    end
                end
            end
        end
    end
end

events.render:set(aim.helpers_visibility)

aim.weapon_select:set_callback(function(ref)

    local yesyes = aim.mlist:get() == 3
    for i = 1, #aim.weapon_table do
        if ref:get() == i then
            aim.weapon_table[i].group:visibility(yesyes)
        else
            aim.weapon_table[i].group:visibility(false)
        end
    end
    aim.cur_wep_tab = ref:get()
end, true)

aim.mlist:set_callback(function(ref)
    aim.weapon_table[aim.cur_wep_tab].group:visibility(ref:get() == 3)
end, true)

aim.get_vars = function()
    
    local lp = entity.get_local_player()
    if not lp then return end
    local wep = lp:get_player_weapon()
    if not wep then return end
    local wep_index = wep:get_weapon_index()
    aim.current_wep = wep_index == 40 and 1 or (wep_index == 11 or wep_index == 38) and 2 or wep_index == 9 and 3 or wep_index == 64 and 4 or wep_index == 1 and 5 or 0
    if aim.current_wep == 0 then return end
    local threat = entity.get_threat()
    local low = false
    local dist = 0
    local hp = 101
    if threat then
        hp = threat.m_iHealth
        local lp_pos = lp:get_origin()
        local threat_pos = threat:get_origin()
        dist = lp_pos:dist(threat_pos)
        if (lp_pos.z < threat_pos.z - 75) then low = true end
    end

    local fig = aim.weapon_table[aim.current_wep]

    if fig.tick.on:get() and aim.tick:get() then
        aim.current_wep_state = "tick"
    elseif fig.lethal.on:get() and (hp <= fig.lethal.max:get()) then
        aim.current_wep_state = "lethal"
    elseif fig.far.on:get() and (dist >= fig.far.min:get()) then
        aim.current_wep_state = "far"
    elseif fig.air.on:get() and not lp:get_anim_state().on_ground then --add jumping
        aim.current_wep_state = "air"
    elseif fig.low.on:get() and low then
        aim.current_wep_state = "low"   
    elseif (aim.current_wep < 4) and fig.noscope.on:get() and not lp.m_bIsScoped then
        aim.current_wep_state = "noscope"
    else
        aim.current_wep_state = nil
    end

    --print(aim.current_wep..' '..aim.current_wep_state)
end

events.createmove:set(aim.get_vars)

aim.apply_wep_overrides = function()
    if (aim.current_wep == 2 or aim.current_wep == 5) and aim.weapon_table[aim.current_wep].hp:get() then
        local threat = entity.get_threat(true)
        if threat then
            local threat_hp = threat.m_iHealth
            refs.dmg:override(threat_hp * 0.5)
        end
    end
    if aim.current_wep ~= 0 and aim.current_wep_state and not (not menu_cfg_labels["Rage"].access and (ui.get_alpha() > 0)) then
        local cond = aim.weapon_table[aim.current_wep][aim.current_wep_state]
        refs.hitbox:override(cond.overrides:get(aim.wep_ov_translate["hitbox"]) and cond.hitbox:get() or nil)
        refs.multipoint:override(cond.overrides:get(aim.wep_ov_translate["multipoint"]) and cond.multipoint:get() or nil)
        refs.hc:override(cond.overrides:get(aim.wep_ov_translate["hc"]) and cond.hc:get() or nil)
        refs.dmg:override(cond.overrides:get(aim.wep_ov_translate["md"]) and cond.md:get() or nil)
        refs.baim:override(cond.overrides:get(aim.wep_ov_translate["baim"]) and cond.baim:get() or nil)
        refs.sp:override(cond.overrides:get(aim.wep_ov_translate["sp"]) and cond.sp:get() or nil)
        refs.sp_force:override(cond.overrides:get(aim.wep_ov_translate["sp_force"]) and cond.sp_force:get() or nil)
        refs.mp_head:override(cond.overrides:get(aim.wep_ov_translate["mp_head"]) and cond.mp_head:get() or nil)
        refs.mp_body:override(cond.overrides:get(aim.wep_ov_translate["mp_body"]) and cond.mp_body:get() or nil)
        refs.hc_dt:override(cond.overrides:get(aim.wep_ov_translate["hc_dt"]) and cond.hc_dt:get() or nil)
        refs.delay:override(cond.overrides:get(aim.wep_ov_translate["delay"]) and cond.delay:get() or nil)
        refs.baim_disablers:override(cond.overrides:get(aim.wep_ov_translate["baim_disablers"]) and cond.baim_disablers:get() or nil)
        refs.baim_fp:override(cond.overrides:get(aim.wep_ov_translate["baim_fp"]) and cond.baim_fp:get() or nil)
    else
        refs.hitbox:override()
        refs.multipoint:override()
        refs.hc:override()
        refs.dmg:override()
        refs.baim:override()
        refs.sp:override()
        refs.sp_force:override()
        refs.mp_head:override()
        refs.mp_body:override()
        refs.hc_dt:override()
        refs.delay:override()
        refs.baim_disablers:override()
        refs.baim_fp:override()
    end
end

events.createmove:set(aim.apply_wep_overrides)

aim.auto_tped = false
aim.auto_tp = function()

    local player = entity.get_local_player()

    if player == nil then
        return
    end

    local weapon = player:get_player_weapon()

    if weapon == nil then
        return
    end

    local weapon_id = weapon:get_weapon_index()

    if weapon_id == nil then
        return
    end

    local players = entity.get_players(true)

    if players == nil or #players == 0 then
        return
    end

    local can_hit = function(entity)
        local damage, trace = utils.trace_bullet(entity, entity:get_hitbox_position(3), player:get_hitbox_position(3))
    
        if damage > 0 then
            if trace.entity and trace.entity == player then
                return true
            end
        end
    
        return false
    end

    local in_air = aa.real_state == 7

    local allow_teleport = (aim.current_wep ~= 0) and aim.weapon_table[aim.current_wep].autotp:get()--[[false
    for k, v in pairs(defines.teleport_weapons_id) do
        if ui_handler.elements["features"]["aim_weapons"][k] then
            for i = 1, #v do
                if v[i] == weapon_id then
                    allow_teleport = true
                else
                    aim.auto_tped = false 
                end
            end
        end
    end]]
    if not allow_teleport then aim.auto_tped = false end

    local teleport_ready = false

    if allow_teleport then
        for k, enemy in pairs(players) do
            if enemy == local_player then
                return
            end

            if can_hit(enemy) then
                teleport_ready = true
            else
                aim.auto_tped = false
            end
        end
    end

    if (refs.dt.on:get() or refs.dt.on:get_override()) and in_air then
        if teleport_ready and not aim.auto_tped then
            rage.exploit:force_teleport()
            aim.auto_tped = true
        end
    end
end

events.createmove:set(aim.auto_tp)

events.shutdown:set(function()
    cvars_ref:override()
    refs.hitbox:override()
    refs.multipoint:override()
    refs.hc:override()
    refs.dmg:override()
    refs.baim:override()
    refs.sp:override()
    refs.sp_force:override()
    refs.mp_head:override()
    refs.mp_body:override()
    refs.hc_dt:override()
    refs.delay:override()
    refs.baim_disablers:override()
    refs.baim_fp:override()
end)

local maxticks = 16

aim.tick_func = function(item)
    if item:get() then
        local net = utils.net_channel()
        local ping = net.avg_latency[0] * 1000
        refs.fl:override(0)
        if ping >= 60 then
            refs.fl:override(8)
        elseif ping <= 30 then
            refs.fl:override(0)
        else
            refs.fl:override(4)
        end

        refs.ap.on:override(true)
        refs.dt.on:override(aim.tick_dt:get() and true or nil)
        refs.dt.lag:override(aim.tick_dt:get() and aim.tick_dt_lag:get() or aim.forcing_def and "Always On" or nil)
        refs.dt.max:override(aim.tick_dt:get() and aim.tick_dt_max:get() or nil)
        refs.dt.tp:override(aim.tick_dt:get() and aim.tick_dt_tp:get() or nil)
        refs.dt.qs:override(aim.tick_dt:get() and aim.tick_dt_qs:get() or nil)
        refs.fs.on:override(aim.tick_fs:get() and true or nil)

        if refs.dt.on:get() or refs.dt.on:get_override() then
            if aim.ideal_tp then
                aim.tp_tick = aim.tp_tick + 1
                if aim.tp_tick > 1 then
                    aim.ideal_tp = false
                    aim.tp_tick = 0
                end
                cvar.sv_maxusrcmdprocessticks:int(23)
            end
        else
            cvar.sv_maxusrcmdprocessticks:int(maxticks)
        end
    else
        refs.fl:override()
        refs.ap.on:override()
        refs.dt.on:override()
        refs.dt.lag:override()
        refs.dt.max:override()
        refs.dt.tp:override()
        refs.dt.qs:override()
        refs.fs.on:override()
        cvar.sv_maxusrcmdprocessticks:int(maxticks)
    end
end

--[[aim.exploit_tweaks = function(cmd)
    if aim.force_def:get() then--and aa.move_state == 7 then
        aim.forcing_def = true
        rage.exploit:allow_defensive(refs.dt.on:get() and false or true)
        --cmd.force_defensive = true
        refs.dt.lag:override("Always")
        refs.hs.mode:override("Break LC")
    else
        aim.forcing_def = false
        rage.exploit:allow_defensive(true)
        refs.dt.lag:override()
        refs.hs.mode:override()
    end
end]]

--events.createmove:set(function(cmd) aim.exploit_tweaks(cmd) end)

aim.tick:set_callback(function(item) aim.tick_func(item) end)

general.artab_function = function()
    if aim.force_tp:get() then rage.exploit:force_teleport() end
    --render.text(fonts.default_font, vector(100, 100), color(255, 255, 255), nil, aa.conditionslist[aa.current_state])
    --render.text(fonts.default_font, vector(100, 100), color(255, 255, 255), nil, aa.yaw_offset)
    --render.text(fonts.modern_icons, vector(100, 100), color(255, 255, 255), nil, globals.choked_commands == 0 and "toolvar" or "")

    if aa.left:get() then
        aa.manual_state = 1
    elseif aa.back:get() then
        aa.manual_state = 2
    elseif aa.right:get() then
        aa.manual_state = 3
    else
        aa.manual_state = 0
    end

    if not (ui.get_alpha() > 0) then return end

    sidetext:animate()
    ui.sidebar(sidetext:get_animated_text(), "tablets")

    aa.hidelabel:visibility(aa.current_cfg == 2)
    aa.hide_button:visibility(aa.current_cfg == 2)
    aa.condlabel:visibility(aa.current_cfg == 2)
    aa.cond_button:visibility(aa.current_cfg == 2)
    --aa.cond_open:visibility(not aa.cond_is_open)
    --aa.cond_close:visibility(aa.cond_is_open)
    aa.condselect:visibility((aa.current_cfg == 2 and aa.cond_is_open) and true or false)
    aa.hidden_tab:visibility((aa.current_cfg == 2 and aa.hide_is_open) and true or false)
    aa.gen:visibility(aa.current_cfg ~= 1)
    aa.abtab:visibility(aa.current_cfg == 2)

    for i = 2, #aa.conditionslist do
        local cond = aa.conditions[i]

        local toolvar = ((i ~= 2 and i ~= 11) and (cond.inherit:get() == "None" or cond.inherit:get() == "(Current condition)")) and true or (i == 2 or i == 11) and true or false

        if aa.cond_is_open and (i == 2 or i == 11 or (i == 12 and #cond.s_override:get() > 0) or (i ~= 12 and cond.override:get())) then
            if (i ~= 2 and i ~= 11) then cond.inherit:visibility(true) elseif i == 11 then cond.inherit:visibility(false) end
            cond.defensive_aa:visibility(toolvar and i ~= 11)
            cond.yaw:visibility(toolvar)
            toolvar = (i ~= 2 and i ~= 11) and (toolvar and cond.yaw:get()) or (i == 2 or i == 11) and toolvar
            cond.yaw_left:visibility(toolvar)
            cond.yaw_right:visibility(toolvar)
            cond.mod_select:visibility(toolvar)
            cond.mod_range:visibility(toolvar and ((cond.mod_select:get() == "Jitter" and cond.jit_select:get() ~= "Custom sequence") or cond.mod_select:get() == "Random" or cond.mod_select:get() == "Spin") and true or false)
            toolvar = toolvar and cond.mod_select:get() == "Jitter" and true or false
            cond.jit_select:visibility(toolvar and true or false)
            --cond.jit_group:visibility((toolvar and (cond.jit_select:get() == "Center" or cond.jit_select:get() == "Offset" or cond.jit_select:get() == "Custom sequence")) and true or false)
            cond.jit_group:visibility(toolvar and true or false)
            cond.jit_update_timer:visibility((toolvar and (cond.jit_select:get() == "Center" or cond.jit_select:get() == "Offset")) and true or false)
            cond.jit_update_chance:visibility((toolvar and (cond.jit_select:get() == "Center" or cond.jit_select:get() == "Offset")) and true or false)
            cond.jit_open:visibility((toolvar and cond.jit_select:get() == "Custom sequence") and true or false)
            for j=1, 9 do
                local stage = cond.jit_custom[j]
                stage.label:visibility((toolvar and cond.jit_select:get() == "Custom sequence" and cond.jit_open:get() and (cond.jit_count:get() >= j)) and true or false)
            end
            toolvar = ((i ~= 2 and i ~= 11) and (cond.inherit:get() == "None" or cond.inherit:get() == "(Current condition)")) and true or (i == 2 or i == 11) and true or false
            toolvar = toolvar and cond.mod_select:get() == "Sway"
            cond.sway_dir:visibility(toolvar)
            cond.sway_switch:visibility(toolvar and (cond.sway_dir:get() == "Random switch"))

            toolvar = ((i ~= 2 and i ~= 11) and (cond.inherit:get() == "None" or cond.inherit:get() == "(Current condition)")) and true or (i == 2 or i == 11) and true or false
            cond.desync:visibility(toolvar)
            toolvar = (i ~= 2 and i ~= 11) and (toolvar and cond.desync:get()) or (i == 2 or i == 11) and toolvar
            cond.desync_l_left:visibility(toolvar and cond.desync_mode:get() == "Static")
            cond.desync_l_right:visibility(toolvar and cond.desync_mode:get() == "Static")
            cond.desync_left:visibility(toolvar and (cond.desync_mode:get() ~= "Static" and cond.desync_mode:get() ~= "Custom sequence"))
            cond.desync_right:visibility(toolvar and (cond.desync_mode:get() ~= "Static" and cond.desync_mode:get() ~= "Custom sequence"))
            cond.desync_sway:visibility(toolvar and cond.desync_mode:get() == "Sway")
            cond.ds_open:visibility(toolvar and cond.desync_mode:get() == "Custom sequence")
            for j=1,9 do
                local stage = cond.ds_custom[j]
                stage.label:visibility((toolvar and cond.desync_mode:get() == "Custom sequence" and cond.ds_open:get() and (cond.ds_count:get() >= j)) and true or false)
            end

            --cond.extend:visibility(toolvar)
        else
            if (i ~= 2 and i ~= 11) then cond.inherit:visibility(false) end
            cond.defensive_aa:visibility(false)
            cond.yaw:visibility(false)
            cond.yaw_left:visibility(false)
            cond.yaw_right:visibility(false)
            cond.mod_select:visibility(false)
            cond.mod_range:visibility(false)
            cond.jit_select:visibility(false)
            cond.jit_group:visibility(false)
            cond.jit_open:visibility(false)
            for j=1, 9 do
                local stage = cond.jit_custom[j]
                stage.label:visibility(false)
                local stage = cond.ds_custom[j]
                stage.label:visibility(false)
            end
            cond.sway_dir:visibility(false)

            cond.desync:visibility(false)
            cond.desync_l_left:visibility(false)
            cond.desync_l_right:visibility(false)
            cond.desync_left:visibility(false)
            cond.desync_right:visibility(false)
            cond.desync_sway:visibility(false)
            cond.ds_open:visibility(false)

            --cond.extend:visibility(false)
        end
            
        if aa.condselect:get() + 1 == i and aa.current_cfg == 2 and aa.cond_is_open then
            cond.group:visibility(true)
        else
            cond.group:visibility(false)
        end
    end

    local toolvar = aa.current_cfg == 2 and aa.antibrute:get()
    aa.antibrute_stagemg:visibility(toolvar)
    aa.antibrute_stagemg_button:visibility(toolvar)
    aa.abgr:visibility(toolvar)
    toolvar = toolvar and aa.brute_is_open
    aa.antibrute_stages:visibility(toolvar)
    aa.antibrute_add_stage:visibility(toolvar)
    aa.antibrute_delete_stage:visibility(toolvar)

    for i = 1, 10 do
        local cond = aa.antibrute_stages_items[i]

        local toolvar = true

        if aa.brute_is_open then
            --cond.defensive:visibility(toolvar)
            cond.yaw:visibility(toolvar)
            toolvar = toolvar and cond.yaw:get()
            cond.yaw_left:visibility(toolvar)
            cond.yaw_right:visibility(toolvar)
            cond.mod_select:visibility(toolvar)
            cond.mod_range:visibility(toolvar and ((cond.mod_select:get() == "Jitter" and cond.jit_select:get() ~= "Custom sequence") or cond.mod_select:get() == "Random" or cond.mod_select:get() == "Spin") and true or false)
            toolvar = toolvar and cond.mod_select:get() == "Jitter" and true or false
            cond.jit_select:visibility(toolvar and true or false)
            --cond.jit_group:visibility((toolvar and (cond.jit_select:get() == "Center" or cond.jit_select:get() == "Offset" or cond.jit_select:get() == "Custom sequence")) and true or false)
            cond.jit_group:visibility(toolvar and true or false)
            cond.jit_update_timer:visibility((toolvar and (cond.jit_select:get() == "Center" or cond.jit_select:get() == "Offset")) and true or false)
            cond.jit_update_chance:visibility((toolvar and (cond.jit_select:get() == "Center" or cond.jit_select:get() == "Offset")) and true or false)
            cond.jit_open:visibility((toolvar and cond.jit_select:get() == "Custom sequence") and true or false)
            for j=1, 9 do
                local stage = cond.jit_custom[j]
                stage.label:visibility((toolvar and cond.jit_select:get() == "Custom sequence" and cond.jit_open:get() and (cond.jit_count:get() >= j)) and true or false)
            end
            toolvar = true
            toolvar = toolvar and cond.mod_select:get() == "Sway"
            cond.sway_dir:visibility(toolvar)
            cond.sway_switch:visibility(toolvar and (cond.sway_dir:get() == "Random switch"))

            toolvar = true

            cond.desync:visibility(toolvar)
            toolvar = cond.desync:get()
            cond.desync_l_left:visibility(toolvar and cond.desync_mode:get() == "Static")
            cond.desync_l_right:visibility(toolvar and cond.desync_mode:get() == "Static")
            cond.desync_left:visibility(toolvar and (cond.desync_mode:get() ~= "Static" and cond.desync_mode:get() ~= "Custom sequence"))
            cond.desync_right:visibility(toolvar and (cond.desync_mode:get() ~= "Static" and cond.desync_mode:get() ~= "Custom sequence"))
            cond.desync_sway:visibility(toolvar and cond.desync_mode:get() == "Sway")
            cond.ds_open:visibility(toolvar and cond.desync_mode:get() == "Custom sequence")
            for j=1,9 do
                local stage = cond.ds_custom[j]
                stage.label:visibility((toolvar and cond.desync_mode:get() == "Custom sequence" and cond.ds_open:get() and (cond.ds_count:get() >= j)) and true or false)
            end

            --cond.extend:visibility(toolvar)
        else
            --cond.defensive:visibility(false)
            cond.yaw:visibility(false)
            cond.yaw_left:visibility(false)
            cond.yaw_right:visibility(false)
            cond.mod_select:visibility(false)
            cond.mod_range:visibility(false)
            cond.jit_select:visibility(false)
            cond.jit_group:visibility(false)
            cond.jit_open:visibility(false)
            for j=1, 9 do
                local stage = cond.jit_custom[j]
                stage.label:visibility(false)
                local stage = cond.ds_custom[j]
                stage.label:visibility(false)
            end
            cond.sway_dir:visibility(false)

            cond.desync:visibility(false)
            cond.desync_l_left:visibility(false)
            cond.desync_l_right:visibility(false)
            cond.desync_left:visibility(false)
            cond.desync_right:visibility(false)
            cond.desync_sway:visibility(false)
            cond.ds_open:visibility(false)

            --cond.extend:visibility(false)
        end
            
        if aa.antibrute_stages:get() == i and aa.antibrute:get() and aa.brute_is_open then
            cond.group:visibility(true)
        else
            cond.group:visibility(false)
        end
    end

end

events.render:set(general.artab_function)

misc = {}

misc.items = {
    {ui.get_icon("location-dot"), "   Local"},
    {ui.get_icon("circle-play"), "   Media"}, 
    {ui.get_icon("biohazard"), "   Communication"}, 
}

misc.mselect = ui.create_gr(ui.get_icon("cloud-bolt").." Misc", "> Menu selection")
misc.tabs = {
    ui.create_gr(ui.get_icon("cloud-bolt").." Misc", "> Local"),
    ui.create_gr(ui.get_icon("cloud-bolt").." Misc", "> Media"),
    ui.create_gr(ui.get_icon("cloud-bolt").." Misc", "> Communication"),
}

misc.mlist = misc.mselect:menu_select(misc.items, misc.tabs)
--[[misc.mlist:set_callback(function(ref)
    local table = {}
    local color = concolor(lighten(visuals.themecol:get(), 20)).."FF"
    for i = 1, #misc.items do
        if ref:get() == i then
            table[i] = "\a"..color..misc.items[i][1].."\aDEFAULT"..misc.items[i][2]
            misc.tabs[i]:visibility(true)
        else
            table[i] = misc.items[i][1]..misc.items[i][2]
            misc.tabs[i]:visibility(false)
        end
    end
    ref:update(table)
end, true)]]

--misc.mtab = ui.create_gr(ui.get_icon("cloud-bolt").." Misc", "> Main")

misc.clantag = misc.tabs[1]:switch_e("Clantag")
misc.clantag_sub = ui.create_sub(misc.clantag)
misc.clantag_prefix = misc.clantag_sub:combo_e("Prefix", {"None", "Lightning", "Skull", "Biohazard", "Cross"})
misc.clantag_style = misc.clantag_sub:combo_e("Style", {"OPIUM *", "Opium.sys", "Text", "File"})
misc.clantag_text = misc.clantag_sub:input_e("Text")
misc.clantag_anim = misc.clantag_sub:combo_e("Animation", {"Static", "Simple"})
misc.clantag_list = misc.clantag_sub:list_e("Clantag file", {})
misc.clantag_refresh = misc.clantag_sub:button_e("Refresh list")
misc.clantag_style:set_callback(function(ref)
    misc.clantag_text:visibility(ref:get() == "Text")
    misc.clantag_anim:visibility(ref:get() == "Text")
    misc.clantag_list:visibility(ref:get() == "File")
    misc.clantag_refresh:visibility(ref:get() == "File")
end, true)
misc.utils = misc.tabs[1]:selectable_e("Utilities", {"No fall damage", "Fast ladder climb"})
misc.breaker = misc.tabs[1]:selectable_e("Animation breaker", {"Pitch 0 on land", "Static legs in air", "Running legs in air", "Moonwalk", "Lean"})
misc.legbreaker = misc.tabs[1]:combo_e("Leg breaker", {"Disabled", "Backward", "Forward", "Jitter"})
misc.ragdoll = ui.create_sub(misc.tabs[1]:label_e("Ragdoll settings"))
misc.noragdoll = misc.ragdoll:switch_e("Physics", true)
misc.noragdoll:set_callback(function(ref) cvar.cl_ragdoll_physics_enable:int(ref:get() and 1 or 0) end, true)
misc.ragdollgrav = misc.ragdoll:slider_e("Gravity", -10000, 10000, 600, 0.1)
misc.ragdollgrav:set_callback(function(ref) cvar.cl_ragdoll_gravity:int(ref:get()) end, true)
misc.ragdolltime = misc.ragdoll:slider_e("Timescale", 0, 100, 10.0, 0.1)
misc.ragdolltime:set_callback(function(ref) cvar.cl_phys_timescale:float(ref:get() / 10) end, true)
misc.vw = misc.tabs[1]:switch_e("VW sounds when hurt")
misc.suicide = misc.tabs[1]:switch_e("Suicide button")
misc.js_fix = misc.tabs[1]:switch_e("Jumpscout autostrafer fix")
misc.bot = misc.tabs[1]:button_e("     Infinite bot match     ", function() utils.console_exec("mp_autoteambalance 0;mp_limitteams 0;mp_warmuptime 234124235;mp_freezetime 0;mp_roundtime_defuse 60;mp_roundtime_hostage 60;mp_roundtime 60;mp_restartgame 1;mp_buy_anywhere 1;mp_buytime 60000;mp_maxmoney 65535;mp_startmoney 65535;mp_afterroundmoney 65535;mp_restartgame 1") end, true)
misc.clear = misc.tabs[1]:button_e("     Clear chat     ", function() utils.console_exec("say ﷽﷽ ﷽﷽﷽ ﷽﷽﷽ ﷽﷽﷽ ﷽﷽﷽ ﷽﷽﷽ ﷽﷽﷽ ﷽﷽﷽ ﷽﷽﷽﷽ ﷽﷽﷽ ﷽﷽﷽ ﷽﷽﷽ ﷽﷽") end, true)
misc.ticks = misc.tabs[1]:slider_e("[DEBUG] sv_maxusrcmdprocessticks", 0, 23, 16)
misc.ticks:set_callback(function(ref) maxticks = ref:get() end, true)
misc.ticks:visibility(_DEBUG)

--misc.stab = ui.create_gr(ui.get_icon("cloud-bolt").." Misc", "> Media player")
misc.tabs[2]:label_e("» Music player")
misc.music_file = misc.tabs[2]:combo_e("Select file:", {})
misc.music_volume = ui.create_sub(misc.music_file):slider_e("Volume", 0, 100, 100, 1.0, "%")
misc.music_shuffle = misc.tabs[2]:button_e(" "..ui.get_icon("shuffle").." ", nil, true)
misc.music_left = misc.tabs[2]:button_e("   "..ui.get_icon("backward-step").."   ", nil, true)
misc.music_play = misc.tabs[2]:button_e("   "..ui.get_icon("play").."   ", nil, true)
misc.music_stop = misc.tabs[2]:button_e("   "..ui.get_icon("stop").."   ", nil, true)
misc.music_right = misc.tabs[2]:button_e("   "..ui.get_icon("forward-step").."   ", nil, true)
misc.music_repeat = misc.tabs[2]:button_e(" "..ui.get_icon("arrows-repeat").." ", nil, true)
misc.music_refresh = misc.tabs[2]:button_e(" Refresh ", nil, true)

--misc.ttab = ui.create_gr(ui.get_icon("cloud-bolt").." Misc", "> Communication")
--misc.tabs[3]:label_e("he is a toolvar")
misc.tabs[3]:label_e("» Chat interactions")
misc.killsay = misc.tabs[3]:combo_e("Killsay", {"Disabled", "Kill count", "Custom"})
misc.killsay:tooltip("Sends when you kill someone (in-game).")
misc.killsay_gr = ui.create_sub(misc.killsay)
misc.killsay_line = misc.killsay_gr:input_e("Kill count line", "^p, it seems like I killed you ^n times so far! How embarassing!")
misc.killsay_line:tooltip("\"^p\" represents the killed player's name, and \"^n\" represents the number of times you killed the player.")
misc.killsay_flist = misc.killsay_gr:list_e("Select killsay file:", {})
misc.killsay_r = misc.killsay_gr:button_e("Refresh list")
misc.death = misc.tabs[3]:combo_e("Death message", {"Disabled", "Text", "Custom"})
misc.death:tooltip("Sends when you die (in-game).")
misc.death_gr = ui.create_sub(misc.death)
misc.death_line = misc.death_gr:input_e("Death message", "^p, I'm [respecting] your mother ^n times tonight!")
misc.death_line:tooltip("\"^p\" represents the attacker's name, and \"^n\" represents the number of times the player has killed you.")
misc.death_flist = misc.death_gr:list_e("Select death message file:", {})
misc.death_r = misc.death_gr:button_e("Refresh list")
misc.miss = misc.tabs[3]:combo_e("Enemy miss", {"Disabled", "Miss count", "Custom"})
misc.miss:tooltip("Sends when someone misses you (in-game).")
misc.miss_gr = ui.create_sub(misc.miss)
misc.miss_line = misc.miss_gr:input_e("Miss message", "^p, you missed me ^n times! What a [shame]! Your mom [always] loved you, you were a [gift]!")
misc.miss_line:tooltip("\"^p\" represents the attacker's name, and \"^n\" represents the number of times the player has missed you.")
misc.miss_flist = misc.miss_gr:list_e("Select miss message file:", {})
misc.miss_r = misc.miss_gr:button_e("Refresh list")
misc.tabs[3]:label_e("» VOIP interactions")
misc.s_killsay = misc.tabs[3]:switch_e("Kill")
misc.s_killsay:tooltip("Plays when you kill someone (in-game).")
misc.s_killsay_gr = ui.create_sub(misc.s_killsay)
misc.s_killsay_flist = misc.s_killsay_gr:list_e("Select kill sound:", {})
misc.s_killsay_r = misc.s_killsay_gr:button_e("Refresh list")
misc.s_death = misc.tabs[3]:switch_e("Death")
misc.s_death:tooltip("Plays when you die (in-game).")
misc.s_death_gr = ui.create_sub(misc.s_death)
misc.s_death_flist = misc.s_death_gr:list_e("Select death sound:", {})
misc.s_death_r = misc.s_death_gr:button_e("Refresh list")
misc.s_miss = misc.tabs[3]:switch_e("Enemy miss")
misc.s_miss:tooltip("Plays when someone misses you (in-game).")
misc.s_miss_gr = ui.create_sub(misc.s_miss)
misc.s_miss_flist = misc.s_miss_gr:list_e("Select miss sound:", {})
misc.s_miss_r = misc.s_miss_gr:button_e("Refresh list")

visuals.rect_fade_round_box = function(start_pos, end_pos, start_color, end_color, width, round)
    -- up
    render.gradient(vector(start_pos.x + round, start_pos.y), vector(start_pos.x + end_pos.x - round, start_pos.y + end_pos.y - end_pos.y + width), start_color, start_color, start_color, start_color)
    -- left
    render.gradient(vector(start_pos.x, start_pos.y + round), vector(start_pos.x + width, start_pos.y + end_pos.y - round), start_color, start_color, (visuals.cur_theme == "Alt") and start_color or end_color, (visuals.cur_theme == "Alt") and start_color or end_color)
    -- right
    render.gradient(vector(start_pos.x + end_pos.x - width, start_pos.y + round), vector(start_pos.x + end_pos.x, start_pos.y + end_pos.y - round), start_color, start_color, (visuals.cur_theme == "Alt") and start_color or end_color, (visuals.cur_theme == "Alt") and start_color or end_color)
    -- down
    render.gradient(vector(start_pos.x + round, start_pos.y + end_pos.y - width), vector(start_pos.x + end_pos.x - round, start_pos.y + end_pos.y), end_color, end_color, end_color, end_color)
    if visuals.cur_theme == "Alt" then
        render.gradient(vector(start_pos.x + round, start_pos.y + end_pos.y - width), vector(start_pos.x + 2 * round, start_pos.y + end_pos.y), (visuals.cur_theme == "Alt") and start_color or end_color, end_color, (visuals.cur_theme == "Alt") and start_color or end_color, end_color)
        render.gradient(vector(start_pos.x + end_pos.x - round * 2, start_pos.y + end_pos.y - width), vector(start_pos.x + end_pos.x - round, start_pos.y + end_pos.y), end_color, (visuals.cur_theme == "Alt") and start_color or end_color, end_color, (visuals.cur_theme == "Alt") and start_color or end_color)
    end
    if round ~= 0 and width ~= 0 then
        -- right down
        render.circle_outline(vector(start_pos.x + end_pos.x - round, start_pos.y + end_pos.y - round), (visuals.cur_theme == "Alt") and start_color or end_color, round, 0, 0.25, width)
        -- right up
        render.circle_outline(vector(start_pos.x + end_pos.x - round, start_pos.y + round), start_color, round, 270, 0.25, width)
        -- left down
        render.circle_outline(vector(start_pos.x + round, start_pos.y + end_pos.y - round), (visuals.cur_theme == "Alt") and start_color or end_color, round, 90, 0.25, width)
        -- left up
        render.circle_outline(vector(start_pos.x + round, start_pos.y + round), color(start_color.r, start_color.g, start_color.b, start_color.a), round,  180, 0.25, width)
    end
end

visuals.draw_modern_box = function(start, stop, alpha, kolor, alt)
    --local kolor = visuals.themecol:get()
    --local kolor = color(kolor.r, kolor.g, kolor.b, math.floor(255*alpha))
    local color1 = kolor and color(kolor.r, kolor.g, kolor.b, visuals.themecol:get().a) or visuals.themecol:get()
    local sec = visuals.themecol2_select:get() == "Custom" and visuals.themecol2:get() or lighten(color1, 20)
    render.shadow(start, vector(start.x + stop.x, start.y + stop.y), color(color1.r, color1.g, color1.b, math.min(255, alpha*0.35)), 100, 0, 8)
    render.blur(vector(start.x, start.y), vector(start.x + stop.x, start.y + stop.y + 1), 0.5, math.min((color1.a * 8 / 255), 255) * (alpha / 255), 8)
    render.rect(start, vector(start.x + stop.x, start.y + stop.y), color(45, 45, 45, math.floor(color1.a*alpha/255)), 8)
    if not alt then
        render.gradient(vector(start.x+4, start.y+4), vector(start.x + stop.x - 4, start.y + stop.y - 4), color(sec.r, sec.g, sec.b, alpha), color(sec.r, sec.g, sec.b, alpha), color(color1.r, color1.g, color1.b, alpha), color(color1.r, color1.g, color1.b, alpha), 5.5)
    end
end

visuals.draw_custom_box = function(position, size, alpha, bg_height, kolor, theme, kolor2, no_shadow)
    local theme = theme and theme or visuals.theme:get()
    if theme == "Vamp " then return end
    local style = visuals.style:get()
    local theme = (theme == "Solus v2" and style ~= "Default") and style or theme
    local color1 = kolor and color(kolor.r, kolor.g, kolor.b, visuals.themecol:get().a) or visuals.themecol:get()
    local color2 = ((theme == "Solus v2" or theme == "Retro") and visuals.themecol2_select:get() == "Custom") and visuals.themecol2:get() or theme == "Solus v2" and darken(color1, 50) or color1
    color2 = visuals.themecol2_select:get() == "Default" and color(color2.r, color2.g, color2.b, 255) or color2
    if theme == "Alpha " then
        render.push_clip_rect(vector(position.x - 2, position.y - 2), vector(position.x + size.x + 2, position.y + (size.y + 4) / 2))
        render.rect(vector(position.x - 2, position.y - 2), vector(position.x + size.x + 2, position.y + size.y + 4), color(25, 25, 25, math.floor(color1.a * alpha / 255 / 2)), 12 )
        render.pop_clip_rect()
        render.push_clip_rect(vector(position.x - 2, position.y + (size.y + 4) / 2), vector(position.x + size.x + 2, position.y + bg_height + 2))
        render.rect(vector(position.x - 2, position.y - 2), vector(position.x + size.x + 2, position.y + bg_height + 2), color(25, 25, 25, math.floor(color1.a * alpha / 255 / 2)), 12 )
        render.pop_clip_rect()
        render.rect_outline(vector(position.x - 2, position.y - 2), vector(position.x + size.x + 2, position.y + size.y + 2), color(25, 25, 25, math.floor(color1.a * alpha / 255)), 0, 12 )
        render.rect(vector(position.x + 1, position.y + 1), vector(position.x + size.x - 1, position.y + size.y - 1), color(25, 25, 25, math.floor(color1.a * alpha / 255)), 10 )
    elseif theme == "Modern " then
        local tp = 255--local tp = visuals.themecol2_select:get() == "Custom" and visuals.themecol2:get().a or 255
        local h = bg_height + 1
        local sec = visuals.themecol2_select:get() == "Custom" and visuals.themecol2:get() or lighten(color1, 20)
        sec = style == "Gradient" and sec or color1
        --local sec = color1
        if not no_shadow then
            render.shadow(vector(position.x + 1, position.y + 1), vector(position.x + size.x - 1, position.y + h - 1), color(color1.r, color1.g, color1.b, math.min(255, tp*alpha*0.35/255)), 100, 0, 8)
        end
        render.blur(vector(position.x, position.y), vector(position.x + size.x, position.y + h), 0.5, math.min((color1.a * 8 / 255), 255) * (alpha / 255), 8) --blur was 100, alpha was *2 not *8
        render.rect(vector(position.x, position.y), vector(position.x + size.x, position.y + h), color(45, 45, 45, math.floor(color1.a*alpha/255)), 8)
        --render.rect(vector(position.x+4, position.y+4), vector(position.x + size.x - 4, position.y + size.y - 4), color(color1.r, color1.g, color1.b, math.min((tp / 255), 255) * alpha), 5.5)
        --render.gradient(vector(position.x+4, position.y+4), vector(position.x + size.x - 4, position.y + size.y - 4), color(color1.r, color1.g, color1.b, math.min((tp / 255), 255) * alpha), color(color1.r, color1.g, color1.b, math.min((tp / 255), 255) * alpha), color(sec.r, sec.g, sec.b, math.min((tp / 255), 255) * alpha), color(sec.r, sec.g, sec.b, math.min((tp / 255), 255) * alpha), 5.5)
        render.gradient(vector(position.x+4, position.y+4), vector(position.x + size.x - 4, position.y + size.y - 4), color(sec.r, sec.g, sec.b, math.min((tp / 255), 255) * alpha), color(sec.r, sec.g, sec.b, math.min((tp / 255), 255) * alpha), color(color1.r, color1.g, color1.b, math.min((tp / 255), 255) * alpha), color(color1.r, color1.g, color1.b, math.min((tp / 255), 255) * alpha), 5.5)
    elseif theme == "Default " then
        local h = bg_height + 1
        local prim = lighten_hsv(color1, -30)--color(color1:unpack())
        prim.a = math.floor(150*alpha*0.75/255)--kolor and math.floor(alpha * color1.a * 0.5 / 255) or alpha * 0.5
        local sec = lighten_hsv(color1, -90)
        sec.a = math.floor(150*alpha/255)
        local prim_light = lighten_hsv(color1, -15)
        prim_light.a = math.floor(150*alpha/255)
        --[[if not no_shadow then
            render.shadow(vector(position.x + 1, position.y + 1), vector(position.x + size.x - 1, position.y + h - 1), color(color1.r, color1.g, color1.b, math.min(255, 255*alpha*0.35/255)), 100, 0, 8)
        end]]
        render.blur(vector(position.x, position.y), vector(position.x + size.x, position.y + h), 0.5, math.min((prim.a * 8 / 255), 255) * (alpha / 255), 8) --blur was 100, alpha was *2 not *8
        render.rect(vector(position.x, position.y), vector(position.x + size.x, position.y + h), sec, 8)
        if (bg_height > size.y) then
            render.line(vector(position.x + 6, position.y + size.y - 1), vector(position.x + size.x - 6, position.y + size.y - 1), prim)
            --render.gradient(vector(position.x + 6, position.y + size.y - 1), vector(position.x + size.x / 2, position.y + size.y), color(0, 0, 0, 0), prim, color(0, 0, 0, 0), prim)
            --render.gradient(vector(position.x + size.x / 2, position.y + size.y - 1), vector(position.x + size.x - 6, position.y + size.y), prim, color(0, 0, 0, 0), prim, color(0, 0, 0, 0))
        end
        --render.rect_outline(vector(position.x, position.y), vector(position.x + size.x, position.y + h), prim, 1, 8)
        visuals.rect_fade_round_box(vector(position.x, position.y), vector(size.x, h), prim_light, prim, 1, 6)
        --render.gradient(vector(position.x+4, position.y+4), vector(position.x + size.x - 4, position.y + size.y - 4), color(sec.r, sec.g, sec.b, 255 * alpha), color(sec.r, sec.g, sec.b, 255 * alpha), color(color1.r, color1.g, color1.b, 255 * alpha), color(color1.r, color1.g, color1.b, 255 * alpha), 5.5)
    else
        if not no_shadow then
            render.shadow(vector(position.x + 1, position.y + 1), vector(position.x + size.x - 1, position.y + size.y - 1), color(color1.r, color1.g, color1.b, alpha * 0.69), 42, 0, theme == "Retro" and 0 or 6) -- 24 turned to 50, alpha / 2 turned to *0.75
        end
        render.blur(vector(position.x + 1, position.y + 1), vector(position.x + size.x - 1, position.y + size.y - 1), 0.5, math.min(255, (color1.a * 8 / 255)) * (alpha / 255), theme == "Retro" and 0 or 6)
        render.rect(vector(position.x + 1, position.y + 1), vector(position.x + size.x - 2, position.y + size.y - 2), color(20, 20, 20, math.floor(color1.a * 0.75 * alpha / 255)), theme == "Retro" and 0 or 4 )
        render.rect_outline(vector(position.x + 1, position.y + 1), vector(position.x + size.x - 1, position.y + size.y - 1), color(70, 70, 70, math.floor(color1.a * alpha / 255)), 0, theme == "Retro" and 0 or 6 )
        color1 = kolor and kolor or color1
        color2 = kolor2 and kolor2 or color2
        visuals.rect_fade_round_box(vector(position.x, position.y), vector(size.x, size.y), color(color1.r, color1.g, color1.b, kolor and math.floor(alpha * color1.a / 255) or alpha), color(color2.r, color2.g, color2.b, theme == "Solus v2" and math.floor(alpha * color2.a / 255) or theme == "Retro" and alpha or 0), visuals.solus_thickness:get(), theme == "Retro" and 0 or 6)
    end
end

is_mouse_in_bounds = function(x1, y1, x2, y2)
    local m = ui.get_mouse_position()
    if(x1 <= m.x and y1 <= m.y and m.x <= x1+x2 and m.y <= y1+y2) then
        return true
    else
        return false
    end
end

keys_cache = {}
key_state = function(key)
    if common.is_button_released(key) then return false
    else return true end
end

register_click = function(key)
    if keys_cache[key] == nil then
        keys_cache[key] = {key_state(key), key_state(key)}
    end

    if keys_cache[key][1] == false and common.is_button_down(key) then
        keys_cache[key][1] = true
        return true
    elseif keys_cache[key][1] and not common.is_button_down(key) then
        keys_cache[key][1] = false
    end

    return false

end

register_unclick = function(key)
    if keys_cache[key] == nil then
        keys_cache[key] = {key_state(key), key_state(key)}
    end

    if keys_cache[key][2] == true and common.is_button_released(key) then
        keys_cache[key][2] = false
        return true
    elseif keys_cache[key][2] == false and not common.is_button_released(key) then
        keys_cache[key][2] = true
    end

    return false

end

is_hovering = false

drag = function(pos, size, off)
    if not off then off = vector(0, 0) end
    if not is_mouse_in_bounds(pos.x + off.x, pos.y + off.y, size.x, size.y) and (pos.unlocked == 0) then return end
    if not (ui.get_alpha() > 0) then return end
    is_hovering = true
    local cursor_x = ui.get_mouse_position().x
    local cursor_y = ui.get_mouse_position().y
    if common.is_button_down(0x01) then
        if is_mouse_in_bounds(pos.x + off.x, pos.y + off.y, size.x, size.y) and pos.received == 0 then
            pos.unlocked = 1
            pos.move_x = pos.x - cursor_x
            pos.move_y = pos.y - cursor_y
            pos.received = 1
        end
    else
        pos.received = 0
        pos.unlocked = 0
    end
    if pos.unlocked == 1 then
        --render.text(fonts.default_font, "dragging", vector(keybinds.pos.x + keybinds.width / 2 + 4, keybinds.pos.y - 27), color(255, 255, 255, math.floor(keybinds.drag_alpha)), true)
        pos.x = cursor_x + pos.move_x
        pos.y = cursor_y + pos.move_y
    end
    if register_unclick(0x01) then
        if is_mouse_in_bounds(pos.x + off.x, pos.y + off.y, size.x, size.y) then
            pos.x_slider:set(pos.x)
            pos.y_slider:set(pos.y)
        end
    end
end

general.draw_notifs = function()
    if not (#notf.array > 0) then return end
    pad = (visuals.cur_theme == "Solus v2" or visuals.cur_theme == "Default " or visuals.cur_theme == "Alt") and 1 or 0
    notf.distance = lerp2(notf.distance, 36, globals.frametime * 7)
    for i = 1, #notf.array do
        if (notf.array[i] == nil or (notf.array[i].alpha <= 0)) then table.remove(notf.array) goto skipnotf end
        local log = notf.array[i]
        --print(log.client_hitbox)
        log.duration = log.duration - globals.frametime
        local duration = log.duration / 7
        log.alpha = lerp2(log.alpha, log.duration >= 0 and 255 or -0.1, globals.frametime * 7)
        local kolor = visuals.themecol:get()
        kolor.a = math.max(math.floor(log.alpha), 0)
        local white = visuals.cur_theme ~= "Modern " and color(255, 255, 255, kolor.a) or lighten(kolor, 75, -30)
        log.pos = lerp2(log.pos, log.duration >= 0 and i or i + 1, globals.frametime * 7)
        local pos = math.floor(log.pos * notf.distance)
        if (screensizey / 2 + notf.offset + pos + 54 > screensizey) then log.duration = -1 end
        local segments = log.segments
        local log_width = 3
        local log_pad = 0
        for n = 1, #segments do
            log_width = log_width + render.measure_text(fonts.default_font, nil, tostring(segments[n][1])).x
        end
        if visuals.cur_theme == "Modern " then
            visuals.draw_modern_box(vector(screensizex / 2 - log_width / 2 - 6 - 10, screensizey * 0.15 + notf.offset + pos - 4), vector(- 2 + log_width + 14 + 20, 29), kolor.a, nil, true)
        else
            visuals.draw_custom_box(vector(screensizex / 2 - log_width / 2 - 7 - 10, screensizey * 0.15 + notf.offset + pos - 3), vector(log_width + 14 + 20, 28), math.floor(kolor.a), 28, kolor)
        end
        for n = 1, #segments do
            render.text(fonts.default_font, vector(screensizex / 2 - log_width / 2 + log_pad + 10, screensizey * 0.15 + notf.offset + pos + pad + 4), segments[n][2] and kolor or white, nil, tostring(segments[n][1]))
            log_pad = log_pad + render.measure_text(fonts.default_font, nil, tostring(segments[n][1])).x
        end
        --render.circle_outline(vector(screensizex / 2 + log_width / 2 + 2, screensizey * 0.15 + logs.offset + pos + 11), kolor, 6, 0, duration, 2)
        render.text(fonts.default_font, vector(screensizex / 2 - log_width / 2 - render.measure_text(fonts.default_font, nil, tostring(icon)).x * 0.5, screensizey * 0.15 + notf.offset + pos + pad + 4), kolor, nil, log.icon)
        ::skipnotf::
    end
end

events.render:set(general.draw_notifs)

intro.time = globals.realtime + 10
intro.alpha = 0.2
intro.pad = 0
intro.width = 0
intro.once = false
intro.draw = function()
    if intro.once or loaded then return end
    --intro.alpha = lerp2(intro.alpha, intro.time > globals.realtime and 255 or 0, 0.05)
    intro.alpha = lerp(intro.alpha, intro.time > globals.realtime and 255 or 0, 15)
    if intro.alpha > 0.1 then
        intro.pad = 0
        --local kolor = "\a"..concolor(color(visuals.themecol:get().r, visuals.themecol:get().g, visuals.themecol:get().b, math.floor(intro.alpha))).."FF"
        local kolor = visuals.themecol:get()
        local light = lighten(kolor, 50)
        local text_color = visuals.cur_theme == "Modern " and color(45, 45, 45, math.floor(intro.alpha)) or visuals.cur_theme == "Alpha " and color(light.r, light.g, light.b, math.floor(intro.alpha)) or color(255, 255, 255, math.floor(intro.alpha))
        --local kolor = "\a"..intro.color
        --intro.string = "Welcome to "..kolor.."Opium".."\aDEFAULT ("..kolor..general.version.."\aDEFAULT), "..kolor..common.get_username().."\aDEFAULT!"
        intro.width = render.measure_text(fonts.default_font, nil, intro.string).x
        visuals.draw_custom_box(vector(screensizex / 2 - 7 - 9 - intro.width / 2, screensizey * 0.15 - 7), vector(intro.width + 14 + 18, 28), math.floor(intro.alpha), 28)
        render.text(fonts.default_font, vector(screensizex / 2 + intro.pad - intro.width / 2 + 9, screensizey * 0.15 + 1), text_color, nil, intro.string)
        render.circle_outline(vector(screensizex / 2 + intro.pad - intro.width / 2 - 2, screensizey * 0.15 + 7), visuals.cur_theme == "Modern " and color(45, 45, 45, math.floor(intro.alpha)) or color(visuals.themecol:get().r, visuals.themecol:get().g, visuals.themecol:get().b, math.floor(intro.alpha)), 6, 0, general.downloaded/general.all_down, 2)
        --[[local kolor = color(visuals.themecol:get().r, visuals.themecol:get().g, visuals.themecol:get().b, math.floor(intro.alpha))
        render.text(fonts.default_font, vector(screensizex / 2 + intro.pad - intro.width / 2, screensizey * 0.15), color(255, 255, 255, math.floor(intro.alpha)), nil, "Welcome to ")
        intro.pad = intro.pad + render.measure_text(fonts.default_font, nil, "Welcome to ").x
        render.text(fonts.default_font, vector(screensizex / 2 + intro.pad - intro.width / 2, screensizey * 0.15), kolor, nil, "Opium ")
        intro.pad = intro.pad + render.measure_text(fonts.default_font, nil, "Opium ").x
        render.text(fonts.default_font, vector(screensizex / 2 + intro.pad - intro.width / 2, screensizey * 0.15), color(255, 255, 255, math.floor(intro.alpha)), nil, "("..general.version.."), ")
        intro.pad = intro.pad + render.measure_text(fonts.default_font, nil, "("..general.version.."), ").x
        render.text(fonts.default_font, vector(screensizex / 2 + intro.pad - intro.width / 2, screensizey * 0.15), kolor, nil, common.get_username())
        intro.pad = intro.pad + render.measure_text(fonts.default_font, nil, common.get_username()).x
        render.text(fonts.default_font, vector(screensizex / 2 + intro.pad - intro.width / 2, screensizey * 0.15), color(255, 255, 255, math.floor(intro.alpha)), nil, "!")]]
    end
    if intro.alpha == 0.1 then
        intro.once = true
    end
end
events.render:set(intro.draw)

visuals.draw_watermark_classic = function()

    if visuals.wm_style:get() ~= "Default" then return end

    if visuals.watermark:get() then
        watermark.alpha = lerp(watermark.alpha, 1, 15)
    else
        watermark.alpha = lerp(watermark.alpha, 0, 15)
    end
    if not (watermark.alpha > 0.1) then return end

    local kolor = visuals.themecol:get()
    if visuals.cur_theme == "Modern " then
        visuals.draw_custom_box(vector(visuals.wm_align:get() == "Left" and 10 or screensizex - math.floor(watermark.width) - 32, 10), vector(math.floor(watermark.width) + 22, 30), math.floor(watermark.alpha * 255), 30)
    else
        visuals.draw_custom_box(vector(visuals.wm_align:get() == "Left" and 14 or screensizex - math.floor(watermark.width) - 28, 13), vector(math.floor(watermark.width) + 13, 24), math.floor(watermark.alpha * 255), 24)
    end
    local light = lighten(kolor, 50)
    local text_color = visuals.cur_theme == "Modern " and color(45, 45, 45, math.floor(watermark.alpha * 255)) or visuals.cur_theme == "Alpha " and color(light.r, light.g, light.b, math.floor(watermark.alpha * 255)) or color(255, 255, 255, math.floor(watermark.alpha * 255))
    render.text(fonts.header_font, vector( visuals.wm_align:get() == "Left" and 21 + math.floor(watermark.width / 2) or screensizex - math.floor(watermark.width / 2) - 21, 25 + visuals.font_pad), text_color, "c", watermark.text)

    local tickrate = math.floor(1.0 / globals.tickinterval)
    local fps1 = math.floor(1 / globals.frametime)
    if globals.tickcount % tickrate == 0 then
        watermark.fps = clamp(fps1, 0, 99999)
    end

    local lp = entity.get_local_player()
    local time = visuals.wm_seconds:get() and string.format("%.2d:%.2d:%.2d", common.get_system_time().hours, common.get_system_time().minutes, common.get_system_time().seconds) or string.format("%.2d:%.2d", common.get_system_time().hours, common.get_system_time().minutes)
    local net = utils.net_channel()
    local separator = watermark.separators[visuals.wm_separator:get()]
    local kolor2 = color(kolor.r, kolor.g, kolor.b)
    local mode, colors = visuals.wm_namecol:get()
    if visuals.wm_namecol_type:get() == "Follow theme" then
        watermark.text = "Opium ("..general.version..")"
    elseif mode ~= "Simple" then
        for k, v in pairs(colors) do v.a = 255 end
        if visuals.wm_namecol_type:get() == "Animated" then
            watermark.name:set_colors(colors)
            watermark.name:animate()
            watermark.text = watermark.name:get_animated_text().."\aDEFAULT ("..general.version..")"
        else
            watermark.text = gradient.text("Opium", false, colors).."\aDEFAULT ("..general.version..")"
        end
    else
        watermark.text = "\a"..concolor(colors).."FF".."Opium".."\aDEFAULT ("..general.version..")"
    end
    if visuals.wm_elements:get(1) then
        watermark.text = watermark.text..separator..common.get_username()
    end
    if lp then
        if visuals.wm_elements:get(2) then
            watermark.text = watermark.text..separator..math.floor(net.avg_latency[1] * 1000).." ms"
        end
        if visuals.wm_elements:get(3) then
            watermark.text = watermark.text..separator..tickrate.." tick"
        end
        if visuals.wm_elements:get(4) then
            watermark.text = watermark.text..separator..watermark.fps.." fps"
        end
    end
    if visuals.wm_elements:get(5) then
        watermark.text = watermark.text..separator..time
    end

    watermark.text_size = render.measure_text(fonts.header_font, "nil", watermark.text)
    watermark.current_width = watermark.text_size.x + 4
    watermark.width = math.max(lerp2(watermark.width, watermark.current_width, 0.4), 0)

end

events.render:set(visuals.draw_watermark_classic)

watermark.picture = render.load_image(network.get("https://en.neverlose.cc/static/avatars/" ..common.get_username().. ".png"), vector(36, 36))

visuals.draw_watermark_modern = function()

    if visuals.wm_style:get() ~= "Modern" then return end

    if visuals.watermark:get() then
        watermark.alpha = lerp(watermark.alpha, 1, 15)
    else
        watermark.alpha = lerp(watermark.alpha, 0, 15)
    end
    if not (watermark.alpha > 0.1) then return end

    local kolor = visuals.themecol:get()
    --[[if visuals.cur_theme == "Modern " then
        visuals.draw_custom_box(vector(screensizex - math.floor(watermark.width) - 32, 10), vector(math.floor(watermark.width) + 22, 30), math.floor(watermark.alpha * 255), 30)
    else
        visuals.draw_custom_box(vector(screensizex - math.floor(watermark.width) - 28, 13), vector(math.floor(watermark.width) + 13, 24), math.floor(watermark.alpha * 255), 24)
    end]]
    local light = lighten(kolor, 50)
    local text_color = visuals.cur_theme == "Modern " and color(45, 45, 45, math.floor(watermark.alpha * 255)) or visuals.cur_theme == "Alpha " and color(light.r, light.g, light.b, math.floor(watermark.alpha * 255)) or color(255, 255, 255, math.floor(watermark.alpha * 255))
    --render.text(fonts.header_font, vector( screensizex - math.floor(watermark.width / 2) - 21, 25 + visuals.font_pad), text_color, "c", watermark.text)

    local tickrate = math.floor(1.0 / globals.tickinterval)
    local fps1 = math.floor(1 / globals.frametime)
    if globals.tickcount % tickrate == 0 then
        watermark.fps = clamp(fps1, 0, 99999)
    end

    local lp = entity.get_local_player()
    local time = visuals.wm_seconds:get() and string.format("%.2d:%.2d:%.2d", common.get_system_time().hours, common.get_system_time().minutes, common.get_system_time().seconds) or string.format("%.2d:%.2d", common.get_system_time().hours, common.get_system_time().minutes)
    local net = utils.net_channel()
    local separator = watermark.separators[visuals.wm_separator:get()]
    local mode, colors = visuals.wm_namecol:get()
    --[[if visuals.wm_namecol_type:get() == "Follow theme" then
        watermark.text = "Opium ("..general.version..")"
    elseif mode ~= "Simple" then
        for k, v in pairs(colors) do v.a = 255 end
        if visuals.wm_namecol_type:get() == "Animated" then
            watermark.name:set_colors(colors)
            watermark.name:animate()
            watermark.text = watermark.name:get_animated_text().."\aDEFAULT ("..general.version..")"
        else
            watermark.text = gradient.text("Opium", false, colors).."\aDEFAULT ("..general.version..")"
        end
    else
        watermark.text = "\a"..concolor(colors).."FF".."Opium".."\aDEFAULT ("..general.version..")"
    end
    if visuals.wm_elements:get(1) then
        watermark.text = watermark.text..separator..common.get_username()
    end
    if lp then
        if visuals.wm_elements:get(2) then
            watermark.text = watermark.text..separator..math.floor(net.avg_latency[1] * 1000).." ms"
        end
        if visuals.wm_elements:get(3) then
            watermark.text = watermark.text..separator..tickrate.." tick"
        end
        if visuals.wm_elements:get(4) then
            watermark.text = watermark.text..separator..watermark.fps.." fps"
        end
    end
    if visuals.wm_elements:get(5) then
        watermark.text = watermark.text..separator..time
    end]]

    --[[local width = math.max(render.measure_text(fonts.header_font, nil, common.get_username()).x, render.measure_text(fonts.header_font, nil, time).x)
    visuals.draw_custom_box(vector(20, 20), vector(2 * height + 4, 2 * height + 4), math.floor(watermark.alpha * 255), 2 * height + 4, color1, nil, color1)
    render.text(fonts.asterisk, vector(20 + height + 2, 40 + height + 2), text_color, "c", "*")
    visuals.draw_custom_box(vector(20 + 2 * height + 8, 20), vector(16 + width, height), math.floor(watermark.alpha * 255), height, color1, nil, color2)
    render.text(fonts.header_font, vector(20 + 2.5 * height + 4 + width * 0.5, 20 + height * 0.5), text_color, "c", common.get_username())
    visuals.draw_custom_box(vector(20 + 2 * height + 8, 20 + height + 4), vector(16 + width, height), math.floor(watermark.alpha * 255), height, color2, nil, color1)
    render.text(fonts.header_font, vector(20 + 2.5 * height + 4 + width * 0.5, 20 + 1.5 * height + 4), text_color, "c", time)]]

    local color1 = color(kolor.r, kolor.g, kolor.b)
    local theme = visuals.cur_theme
    local color2 = ((theme == "Solus v2" or theme == "Retro") and visuals.themecol2_select:get() == "Custom") and visuals.themecol2:get() or theme == "Solus v2" and darken(color1, 50) or color1
    --local color2 = color(kolor.r, kolor.g, kolor.b, 0)
    local width = math.max(render.measure_text(fonts.header_font, nil, common.get_username()).x, render.measure_text(fonts.header_font, nil, time).x)
    local old_width = 0
    if visuals.wm_align:get() == "Left" then
        visuals.draw_custom_box(vector(20, 12), vector(52, 52), math.floor(watermark.alpha * 255), 52, color1, nil, color1)
        if visuals.cur_theme == "Modern " then
            visuals.draw_modern_box(vector(76, 12), vector(16 + width, 24), math.floor(watermark.alpha * 255), nil, true)
            visuals.draw_modern_box(vector(76, 40), vector(16 + width, 24), math.floor(watermark.alpha * 255), nil, true)
        else
            visuals.draw_custom_box(vector(76, 12), vector(16 + width, 24), math.floor(watermark.alpha * 255), 24, color1, nil, color2)
            visuals.draw_custom_box(vector(76, 40), vector(16 + width, 24), math.floor(watermark.alpha * 255), 24, color2, nil, color1)
        end
        render.text(fonts.asterisk, vector(46, 58), text_color, "c", "*")
        local text_color = (visuals.cur_theme == "Modern " or visuals.cur_theme == "Alpha ") and color(light.r, light.g, light.b, math.floor(watermark.alpha * 255)) or color(255, 255, 255, math.floor(watermark.alpha * 255))
        render.text(fonts.header_font, vector(84 + width * 0.5, 24), text_color, "c", common.get_username())
        render.text(fonts.header_font, vector(84 + width * 0.5, 52), text_color, "c", time)
        
        if lp then
            local latency = math.floor(net.avg_latency[1] * 1000)
            old_width = width
            width = math.max(render.measure_text(fonts.header_font, nil, watermark.fps.." fps").x, render.measure_text(fonts.header_font, nil, latency.." ms").x)
            if visuals.cur_theme == "Modern " then
                visuals.draw_modern_box(vector(96 + old_width, 12), vector(16 + width, 24), math.floor(watermark.alpha * 255), nil, true)
                visuals.draw_modern_box(vector(96 + old_width, 40), vector(16 + width, 24), math.floor(watermark.alpha * 255), nil, true)
            else
                visuals.draw_custom_box(vector(96 + old_width, 12), vector(16 + width, 24), math.floor(watermark.alpha * 255), 24, color1, nil, color2)
                visuals.draw_custom_box(vector(96 + old_width, 40), vector(16 + width, 24), math.floor(watermark.alpha * 255), 24, color2, nil, color1)
            end
            render.text(fonts.header_font, vector(104 + old_width + width * 0.5, 24), text_color, "c", watermark.fps.." fps")
            render.text(fonts.header_font, vector(104 + old_width + width * 0.5, 52), text_color, "c", latency.." ms")
            width = width + 20
        end

        if visuals.wm_pfp:get() then
            --visuals.draw_custom_box(vector(96 + old_width + width, 12), vector(52, 52), math.floor(watermark.alpha * 255), 52, color1, nil, color1)
            if visuals.theme:get() == "Default " then
                render.rect_outline(vector(102 + old_width + width, 18), vector(142 + old_width + width, 58), color(kolor.r, kolor.g, kolor.b, watermark.alpha * 150), 1, 24)
            elseif visuals.theme:get() == "Alpha " then
                render.rect(vector(100 + old_width + width, 16), vector(144 + old_width + width, 60), color(25, 25, 25, math.floor(watermark.alpha * visuals.themecol:get().a * 0.5)), 24)
                render.rect_outline(vector(100 + old_width + width, 16), vector(144 + old_width + width, 60), color(25, 25, 25, math.floor(watermark.alpha * visuals.themecol:get().a)), 0, 24)
            elseif visuals.theme:get() == "Modern " then
                render.shadow(vector(100 + old_width + width, 16), vector(144 + old_width + width, 60), color(kolor.r, kolor.g, kolor.b, watermark.alpha * 0.35 * 255), 100, 0, 24)
                render.blur(vector(100 + old_width + width, 16), vector(144 + old_width + width, 60), 0.5, math.min((visuals.themecol:get().a * 8), 255) * watermark.alpha, 24)
                render.rect(vector(100 + old_width + width, 16), vector(144 + old_width + width, 60), color(45, 45, 45, math.floor(visuals.themecol:get().a * watermark.alpha)), 24)
            elseif visuals.theme:get() == "Solus v2" then
                render.shadow(vector(100 + old_width + width, 16), vector(144 + old_width + width, 60), color(kolor.r, kolor.g, kolor.b, watermark.alpha * 0.69 * 255), 100, 0, 24)
                render.blur(vector(100 + old_width + width, 16), vector(144 + old_width + width, 60), 0.5, math.min((visuals.themecol:get().a * 8), 255) * watermark.alpha, 24)
                render.rect(vector(100 + old_width + width, 16), vector(144 + old_width + width, 60), color(20, 20, 20, math.floor(visuals.themecol:get().a * 0.75 * watermark.alpha)), 24)
                render.rect_outline(vector(100 + old_width + width, 16), vector(144 + old_width + width, 60), color(kolor.r, kolor.g, kolor.b, watermark.alpha * 255), 2, 24)

            end
            render.texture(watermark.picture, vector(104 + old_width + width, 20), vector(36, 36), color(255, 255, 255, math.floor(watermark.alpha * 255)), nil, 0)
        end
    else
        visuals.draw_custom_box(vector(screensizex - 72, 12), vector(52, 52), math.floor(watermark.alpha * 255), 52, color1, nil, color1)
        if visuals.cur_theme == "Modern " then
            visuals.draw_modern_box(vector(screensizex - 92 - width, 12), vector(16 + width, 24), math.floor(watermark.alpha * 255), nil, true)
            visuals.draw_modern_box(vector(screensizex - 92 - width, 40), vector(16 + width, 24), math.floor(watermark.alpha * 255), nil, true)
        else
            visuals.draw_custom_box(vector(screensizex - 92 - width, 12), vector(16 + width, 24), math.floor(watermark.alpha * 255), 24, color1, nil, color2)
            visuals.draw_custom_box(vector(screensizex - 92 - width, 40), vector(16 + width, 24), math.floor(watermark.alpha * 255), 24, color2, nil, color1)
        end
        render.text(fonts.asterisk, vector(screensizex - 46, 58), text_color, "c", "*")
        local text_color = (visuals.cur_theme == "Modern " or visuals.cur_theme == "Alpha ") and color(light.r, light.g, light.b, math.floor(watermark.alpha * 255)) or color(255, 255, 255, math.floor(watermark.alpha * 255))
        render.text(fonts.header_font, vector(screensizex - 84 - width * 0.5, 24), text_color, "c", common.get_username())
        render.text(fonts.header_font, vector(screensizex - 84 - width * 0.5, 52), text_color, "c", time)

        if lp then
            local latency = math.floor(net.avg_latency[1] * 1000)
            old_width = width
            width = math.max(render.measure_text(fonts.header_font, nil, watermark.fps.." fps").x, render.measure_text(fonts.header_font, nil, latency.." ms").x)
            if visuals.cur_theme == "Modern " then
                visuals.draw_modern_box(vector(screensizex - 112 - old_width - width, 12), vector(16 + width, 24), math.floor(watermark.alpha * 255), nil, true)
                visuals.draw_modern_box(vector(screensizex - 112 - old_width - width, 40), vector(16 + width, 24), math.floor(watermark.alpha * 255), nil, true)
            else
                visuals.draw_custom_box(vector(screensizex - 112 - old_width - width, 12), vector(16 + width, 24), math.floor(watermark.alpha * 255), 24, color1, nil, color2)
                visuals.draw_custom_box(vector(screensizex - 112 - old_width - width, 40), vector(16 + width, 24), math.floor(watermark.alpha * 255), 24, color2, nil, color1)
            end
            render.text(fonts.header_font, vector(screensizex - 104 - old_width - width * 0.5, 24), text_color, "c", watermark.fps.." fps")
            render.text(fonts.header_font, vector(screensizex - 104 - old_width - width * 0.5, 52), text_color, "c", latency.." ms")
            width = width + 20
        end

        if visuals.wm_pfp:get() then
            --visuals.draw_custom_box(vector(screensizex - 148 - old_width - width, 12), vector(52, 52), math.floor(watermark.alpha * 255), 52, color1, nil, color1)
            if visuals.theme:get() == "Default " then
                render.rect_outline(vector(screensizex - 142 - old_width - width, 18), vector(screensizex - 100 - old_width - width - 2, 58), color(kolor.r, kolor.g, kolor.b, watermark.alpha * 150), 1, 24)
            elseif visuals.theme:get() == "Alpha " then
                render.rect(vector(screensizex - 144 - old_width - width, 16), vector(screensizex - 100 - old_width - width, 60), color(25, 25, 25, math.floor(watermark.alpha * visuals.themecol:get().a * 0.5)), 24)
                render.rect_outline(vector(screensizex - 144 - old_width - width, 16), vector(screensizex - 100 - old_width - width, 60), color(25, 25, 25, math.floor(watermark.alpha * visuals.themecol:get().a)), 0, 24)
            elseif visuals.theme:get() == "Modern " then
                render.shadow(vector(screensizex - 144 - old_width - width, 16), vector(screensizex - 100 - old_width - width, 60), color(kolor.r, kolor.g, kolor.b, watermark.alpha * 0.35 * 255), 100, 0, 24)
                render.blur(vector(screensizex - 144 - old_width - width, 16), vector(screensizex - 100 - old_width - width, 60), 0.5, math.min((visuals.themecol:get().a * 8), 255) * watermark.alpha, 24)
                render.rect(vector(screensizex - 144 - old_width - width, 16), vector(screensizex - 100 - old_width - width, 60), color(45, 45, 45, math.floor(visuals.themecol:get().a * watermark.alpha)), 24)
            elseif visuals.theme:get() == "Solus v2" then
                render.shadow(vector(screensizex - 144 - old_width - width, 16), vector(screensizex - 100 - old_width - width, 60), color(kolor.r, kolor.g, kolor.b, watermark.alpha * 0.69 * 255), 100, 0, 24)
                render.blur(vector(screensizex - 144 - old_width - width, 16), vector(screensizex - 100 - old_width - width, 60), 0.5, math.min((visuals.themecol:get().a * 8), 255) * watermark.alpha, 24)
                render.rect(vector(screensizex - 144 - old_width - width, 16), vector(screensizex - 100 - old_width - width, 60), color(20, 20, 20, math.floor(visuals.themecol:get().a * 0.75 * watermark.alpha)), 24)
                render.rect_outline(vector(screensizex - 144 - old_width - width, 16), vector(screensizex - 100 - old_width - width, 60), color(kolor.r, kolor.g, kolor.b, watermark.alpha * 255), 2, 24)
            end
            render.texture(watermark.picture, vector(screensizex - 140 - old_width - width, 20), vector(36, 36), color(255, 255, 255, math.floor(watermark.alpha * 255)), nil, 0)
        end
    end

    watermark.text_size = render.measure_text(fonts.header_font, "nil", watermark.text)
    watermark.current_width = watermark.text_size.x + 4
    watermark.width = math.max(lerp2(watermark.width, watermark.current_width, 0.4), 0)

end

events.render:set(visuals.draw_watermark_modern)

math.round = function(a) return math.floor(a + 0.5) end
math.normalize = function(ang)
    while (ang > 180.0) do
        ang = ang - 360.0
    end
    while (ang < -180.0) do
        ang = ang + 360.0
    end
    return ang
end
math.calc_angle = function(local_x, local_y, enemy_x, enemy_y)
    local ydelta = local_y - enemy_y
    local xdelta = local_x - enemy_x
    local relativeyaw = math.atan(ydelta / xdelta)
    relativeyaw = math.normalize(relativeyaw * 180 / math.pi)
    if xdelta >= 0 then
        relativeyaw = math.normalize(relativeyaw + 180)
    end
    return relativeyaw
end
alpha = function(s, a)
    return color(s.r, s.g, s.b, math.round(a))
end
alp_self = function(s, a) return alpha(s, (a * s.a / 255) * 255) end

visuals.changing_scope = false
visuals.scope_cache = refs.scope:get()

local anim = 0
local scopeanim = 0

local infobar = {}
infobar.infobarf = render.load_font("verdana", 14, "a d")
infobar.infobarftext = render.load_font("verdana", 11, "a o d")
fonts.infobarf_bak = infobar.infobarf
fonts.infobarftext_bak = infobar.infobarftext
infobar.fpscolor = color(255, 255, 255)
infobar.pingcolor = color(255, 255, 255)
infobar.fps = 0
infobar.animate = 0
infobar.pad = 0

fonts.update = function()
    if visuals.cur_theme == "Retro" then
        fonts.default_font = fonts.pixelretromed
        fonts.header_font = fonts.default_font
        infobar.infobarftext = fonts.pixelretromed
        infobar.infobarf = fonts.pixelretro_o
        infobar.pad = -10
        --visuals.font_pad = -2
    elseif visuals.cur_theme == "Modern " then
        fonts.default_font = fonts.modern
        fonts.header_font = fonts.modern_header
        --infobar.infobarftext = visuals.infobar:get() == "Simple" and fonts.modern or fonts.infobarftext_bak
        --infobar.infobarf = visuals.infobar:get() == "Simple" and fonts.modern or fonts.infobarf_bak
    elseif visuals.cur_theme == "Default " then
        fonts.default_font = fonts.audi
        fonts.header_font = fonts.audi_wide
        visuals.font_pad = 1
    elseif visuals.cur_theme == "Vamp " then
        fonts.default_font = fonts.edgy
        fonts.header_font = fonts.edgy
    else
        fonts.default_font = visuals.cur_theme == "Alpha " and fonts.modern or fonts.default_font_bak
        fonts.header_font = fonts.default_font
        infobar.infobarftext = fonts.infobarftext_bak
        infobar.infobarf = fonts.infobarf_bak
        infobar.pad = 0
    end
end

fonts.update()
--ui.get_alpha() = 0

local function on_paint()

    --ui.get_alpha() = lerp(ui.get_alpha(), (ui.get_alpha() > 0) and 1 or 0, 15)
    local uicol = (visuals.uicol_select:get() == "Theme") and color(visuals.themecol:get().r, visuals.themecol:get().g, visuals.themecol:get().b) or visuals.uicol
    local kolor = color(uicol.r, uicol.g, uicol.b, math.floor(ui.get_alpha() * 255))
    intro.color = visuals.cur_theme == "Modern " and "2D2D2DFF" or concolor(color(visuals.themecol:get().r, visuals.themecol:get().g, visuals.themecol:get().b, math.floor(intro.alpha))).."FF"
    local kolor_hex = concolor(kolor).."FF"
    local white = color(255, 255, 255, math.floor(ui.get_alpha() * 255))
    if ui.get_alpha() > 0.1 then
        local welcometext = "Welcome to \a"..kolor_hex.."Opium ("..general.version..")\aDEFAULT, "..common.get_username().."!\nLoaded config: \a"..kolor_hex..cfg.hidname:get().."\aDEFAULT\nOriginal creator: \a"..kolor_hex..cfg.hidusername:get().."\aDEFAULT\nLast updated: \a"..kolor_hex..cfg.hiddate:get()
        local textsize = render.measure_text(fonts.default_font_bak, nil, welcometext)
        local posy = ui.get_position().y - 33 - textsize.y
        --print(posy + 18 + 26)
        --render.rect_filled(vector(ui.get_position().x, ui.get_position().y + ui.get_size().y + 4), vector(ui.get_size().x / 2, 48), color(0, 0, 0, math.floor(ui.get_alpha() * 255)), 8)
        --render.rect_filled(vector(ui.get_position().x + 1, ui.get_position().y + ui.get_size().y + 4 + 1), vector(ui.get_size().x / 2 - 2, 48 - 2), color(45, 45, 45, math.floor(ui.get_alpha() * 255)), 8)
        --render.rect_filled(vector(ui.get_position().x + 1, ui.get_position().y + ui.get_size().y + 4 + 1 + 48 - 10), vector(ui.get_size().x / 2 - 2, 1), color)
        --render.text(fonts.default_font, "Frailty", vector(ui.get_position().x + 4 + 9, ui.get_position().y + ui.get_size().y + 4 + 9), color)
        --render.text(fonts.default_font, " loaded! Welcome, "..common.get_username().."!", vector(ui.get_position().x + 13 + render.measure_text(fonts.default_font, "Frailty").x, ui.get_position().y + ui.get_size().y + 13), color(255, 255, 255, math.floor(ui.get_alpha() * 255)))
        render.rect(vector(ui.get_position().x + ui.get_size().x - (textsize.x + 12), posy - 1), vector(ui.get_position().x + ui.get_size().x, ui.get_position().y - 1), color(0, 0, 0, math.floor(ui.get_alpha() * 255)), 10)
        render.rect(vector(ui.get_position().x + ui.get_size().x + 1 - (textsize.x + 12), posy), vector(ui.get_position().x + ui.get_size().x + 1 - 2,  ui.get_position().y - 2), color(45, 45, 45, math.floor(ui.get_alpha() * 255)), 10)
        render.push_clip_rect(vector(ui.get_position().x + ui.get_size().x + 1 - (textsize.x + 12), posy + 20), vector(ui.get_position().x + ui.get_size().x + 1 - 2, ui.get_position().y))
        render.rect(vector(ui.get_position().x + ui.get_size().x + 1 - (textsize.x + 12), posy), vector(ui.get_position().x + ui.get_size().x + 1 - 2, ui.get_position().y - 2), color(28, 28, 28, math.floor(ui.get_alpha() * 255)), 10)
        render.pop_clip_rect()
        render.rect(vector(ui.get_position().x + ui.get_size().x + 1 - (textsize.x + 12), posy + 18), vector(ui.get_position().x + ui.get_size().x + 1 - 2, posy + 19), kolor)
        render.text(fonts.default_font_bak, vector(ui.get_position().x + ui.get_size().x + 1 - (textsize.x + 12) / 2, posy + 9), kolor, "c", "Opium")
        render.text(fonts.default_font_bak, vector(ui.get_position().x + ui.get_size().x + 1 + 6 - (textsize.x + 12), posy + 24), white, nil, welcometext)
    end

    --local cond = (visuals.cur_theme ~= "Alpha " and visuals.cur_theme ~= "Alt" and not (visuals.cur_theme == "Modern" and visuals.style:get() == "Solid")) and false or true
    --local cond = (visuals.cur_theme == "Solus v2" or visuals.cur_theme == "Retro" or (visuals.cur_theme == "Modern " and visuals.style:get() == "Gradient")) and true or false
    local cond = (visuals.cur_theme ~= "Default " and visuals.cur_theme ~= "Alpha " and visuals.cur_theme ~= "Alt" and visuals.cur_theme ~= "Vamp " and not (visuals.cur_theme == "Modern " and visuals.style:get() == "Solid"))

    if not (ui.get_alpha() > 0) then goto others end

    fonts.update()
    if visuals.uicol ~= ui.get_style("Link Active") then
        visuals.uicol = ui.get_style("Link Active")
        run_callbacks(visuals.uicol)
    end
    visuals.themecol2_select:visibility(cond)
    visuals.themecol2:visibility(cond and visuals.themecol2_select:get() == "Custom")
    visuals.solus_thickness:visibility(visuals.theme:get() == "Solus v2" and true or false)

    if not cfg.once then
        cfg.restrict_update_func()
        cfg.once = true
    end

    if not aa.once then
        aa.once = true
        for i=1, aa.antibrute_stage_count:get() do
            aa.antibrute_stage_table[i] = "Stage "..i
        end
        aa.antibrute_stages:update(aa.antibrute_stage_table)
        aa.condselect:set(1)
        for i=1, 10 do
            local cond = aa.antibrute_stages_items[i]
            cond.jit_open:set(false)
            cond.ds_open:set(false)
        end
        for i=2, #aa.conditionslist do
            local cond = aa.conditions[i]
            cond.jit_open:set(false)
            cond.ds_open:set(false)
        end
    end

    ::others::

    visuals.desync_range = math.floor(lerp(visuals.desync_range, math.abs(math.floor(local_player.desync_angle())), 15))
    local theme = visuals.theme:get()
    local style = visuals.style:get()
    visuals.cur_theme = (theme == "Solus v2" and style ~= "Default") and style or theme
    if not visuals.once then
        visuals.once = true
        fonts.update()
        visuals.mlist:set(1)
        aim.mlist:set(1)
        misc.mlist:set(1)
    end
    screensizex = render.screen_size().x
    screensizey = render.screen_size().y
    refs.is_overriding_dmg = refs.check_ov()
    refs.is_overriding_hc = refs.check_ov_hc()
    refs.is_overriding_baim = refs.check_baim()
    refs.is_overriding_sp = refs.check_sp()
    --refs.override = menu.find("aimbot", weapon_tabs[ragebot.get_active_cfg() + 1], "target overrides", "force min. damage")
    aa.current_cfg = (menu_cfg_labels["Anti Aim"].access and aa.cfg:get() == 2) and 2 or aa.cfg:get() == 2 and 3 or 1
    local lp = entity.get_local_player()
    if not lp then return end
    active = (lp.m_bIsScoped == true and lp.m_iHealth > 0)
    scopeanim = math.max(lerp(scopeanim, active and 1 or 0, 10), 0)
    anim = (visuals.scope_type:get() == "Static" and visuals.scope_rotation:get() == 0) and scopeanim or 0
    if not visuals.crosscol_applied then visuals.crosscol_bak = color(visuals.crosscol.r:float(), visuals.crosscol.g:float(), visuals.crosscol.b:float()) end
end

events.render:set(on_paint)

aainfo = {}
aainfo.width = 0
aainfo.height = 0
aainfo.maxwidth = 0
aainfo.alpha = 0
aainfo.drag_alpha = 0
aainfo.pos = {
    x = 20,
    y = screensizey * 0.5,
    x_slider = vs_debug:slider_e("Info Panel X", 0, render.screen_size().x, 20),
    y_slider = vs_debug:slider_e("Info Panel Y", 0, render.screen_size().x, screensizey * 0.5),
    tab = vs_debug:slider_e("Info Panel Tab", 1, 3, 1),
    move_x = 0,
    move_y = 0,
    unlocked = 0,
    received = 0,
}
aainfo.pos.x_slider:visibility(false)
aainfo.pos.y_slider:visibility(false)
aainfo.pos.tab:visibility(false)

aainfo.pos.x = aainfo.pos.x_slider:get()
aainfo.pos.y = aainfo.pos.y_slider:get()

visuals.infopanel_muzzle:set_callback(function(ref)
    if not ref:get() then
        aainfo.pos.x = aainfo.pos.x_slider:get()
        aainfo.pos.y = aainfo.pos.y_slider:get()
    end
    visuals.infopanel_muzzle_line:visibility(ref:get())
    visuals.infopanel_muzzle_x:visibility(ref:get())
    visuals.infopanel_muzzle_y:visibility(ref:get())
end, true)

aainfo.tabs = {
    {name = "Antiaim", alpha = 0, width = 147, height = 110},
    {name = "Rage", alpha = 0, width = 185, height = 150},
    {name = "Logs", alpha = 0, width = 185, height = 150},
}
aainfo.alpha = 0
aainfo.padding = 0
aainfo.brute_circle = 0
aainfo.duck = 0
visuals.yaw = 0
visuals.infopanel_anim = 0
aainfo.anims = {
    exp = 0,
    exp_charge = 0,
    ap = 0,
}
aainfo.logs_array = {}
button_col_left = color(255, 255, 255)
button_col_right = color(255, 255, 255)

local real_yaw, abs_yaw = 0, 0
local view_y = 0

events.createmove:set(function(cmd)
    local me = entity.get_local_player()
    local anim_state = me:get_anim_state()

    if not anim_state or cmd.choked_commands > 0 then
        return
    end

    real_yaw = anim_state.eye_yaw
    abs_yaw = anim_state.abs_yaw
    view_y = cmd.view_angles.y
end)

visuals.draw_info_circle = function(position, kolor, radius, offset, range, width, bg)
    local style = visuals.ip_circle_style:get()
    local kolor2 = bg and color(0, 0, 0, 0) or color(kolor.r, kolor.g, kolor.b, 0)
    if style == "Regular" then
        render.circle_outline(position, kolor, radius, offset, range, width)
    elseif style == "Gradient" then
        render.circle_gradient(position, kolor, kolor2, radius, offset, range)
    end
end

local fakelag = 0
local last_choke = 0
local cur_choke = 0

local function getmaxfakelag()

    if globals.choked_commands == 0 then
        send_packet = true
    else
        send_packet = false
    end

    last_choke = cur_choke
    
    if send_packet then
        fakelag = last_choke
    else cur_choke = globals.choked_commands end
    return fakelag

end

visuals.draw_aainfo = function()

    if visuals.infopanel:get() == "Disabled" then return end

    local me = entity.get_local_player()

    aainfo.alpha = lerp(aainfo.alpha, ((me and me.m_iHealth > 0 and aainfo.tab ~= 3) or (aainfo.tab == 3 and #aainfo.logs_array > 0) or (ui.get_alpha() > 0)) and 1 or 0, 15)

    local posy = aainfo.pos.y + 32
    local hovering = false

    if visuals.infopanel_muzzle:get() then
        local muzpos = vector(aainfo.pos.x_slider:get(), aainfo.pos.y_slider:get())

        muzzle = get_muzzle_position()

        --if not (me and me.m_iHealth > 0) or refs.thirdperson:get() then
        if not muzzle or muzzle == vector(0, 0, 0) or not (me and me.m_iHealth > 0) or refs.thirdperson:get() then
            muzzle = vector(aainfo.pos.x_slider:get() + 150 + aainfo.width, aainfo.pos.y_slider:get() + 150 + aainfo.height)
            --drag(aainfo.pos, vector(aainfo.width + 8, 32))
        else
            --muzzle = get_muzzle_position()
            hovering = true
            muzpos.x = muzzle.x + visuals.infopanel_muzzle_x:get() - aainfo.width
            muzpos.y = muzzle.y + visuals.infopanel_muzzle_y:get() - aainfo.height
            local muzcol = color(visuals.infopanel_muzzle_line:get().r, visuals.infopanel_muzzle_line:get().g, visuals.infopanel_muzzle_line:get().b, visuals.infopanel_muzzle_line:get().a * aainfo.alpha)
            render.poly_line(muzcol, vector(muzzle.x - 30, muzzle.y + 30 * sign(visuals.infopanel_muzzle_y:get())), vector(aainfo.pos.x + (visuals.infopanel_muzzle_x:get() < 0 and aainfo.width or 0), aainfo.pos.y + aainfo.height))
        end
        if aainfo.pos.unlocked == 0 then
            aainfo.pos.x = lerp2(aainfo.pos.x, muzpos.x, 5 * globals.frametime)
            aainfo.pos.y = lerp2(aainfo.pos.y, muzpos.y, 5 * globals.frametime)
        end
    else
        --drag(aainfo.pos, vector(aainfo.width + 8, 32))
    end

    if aainfo.tab == nil then aainfo.tab = aainfo.pos.tab:get() end

    --if aainfo.alpha == 0 then goto skip end

    local header_alpha = visuals.infopanel_box:get() and 1 or ui.get_alpha()

    if visuals.infopanel:get() == "AA Console" then
        local extended_string = aa.extend:get() and aa.ext_pitch:get().."° pitch, "..aa.ext_roll:get().."° roll " or "none"
        local maxwidth = 10 + math.max(render.measure_text(fonts.default_font, nil, "   Extended angles : "..extended_string).x, render.measure_text(fonts.default_font, nil, "> opium.sys (user: "..common.get_username()..") : status").x)
        --aainfo.width = lerp(aainfo.width, (visuals.cur_theme == "Retro" and 200 or 185) + render.measure_text(fonts.default_font, nil, extended_string).x * 0.5, 15)
        aainfo.width = lerp(aainfo.width, maxwidth, 15)
        if (header_alpha > 0) then
            if visuals.cur_theme == "Modern " then
                visuals.draw_custom_box(vector(aainfo.pos.x - 4, aainfo.pos.y - 3), vector(aainfo.width, 30), 255 * header_alpha, 41 + 12 * 8)
            elseif visuals.cur_theme == "Vamp " then
                visuals.draw_edgy_line(vector(aainfo.pos.x + 2, aainfo.pos.y + 24), aainfo.width - 12, 255 * header_alpha)
            else
                visuals.draw_custom_box(vector(aainfo.pos.x - 4, aainfo.pos.y), vector(aainfo.width, 24), 255 * header_alpha, 34 + 12 * 8)
            end
            local themecol = color(visuals.themecol:get().r, visuals.themecol:get().g, visuals.themecol:get().b, 255 * header_alpha)
            local header_text = "Console"
            local header_color = visuals.cur_theme == "Modern " and color(45, 45, 45, 255 * header_alpha) or visuals.cur_theme == "Alpha " and lighten(themecol, 50) or color(255, 255, 255, 255 * header_alpha)
            render.text(fonts.header_font, vector(aainfo.pos.x + aainfo.width / 2, aainfo.pos.y + 12), header_color, "c", header_text)
        end
        if visuals.infopanel_anim < posy + 12 * 7 then visuals.infopanel_anim = visuals.infopanel_anim + 0.8 end
        render.push_clip_rect(vector(aainfo.pos.x, posy), vector(aainfo.pos.x+screensizex, posy+visuals.infopanel_anim))
        local kolor = color(visuals.themecol:get().r, visuals.themecol:get().g, visuals.themecol:get().b, 255)
        local white = (visuals.cur_theme == "Modern " or visuals.cur_theme == "Alpha ") and lighten(kolor, 50) or color(255, 255, 255)
        local ind = 0
        --visuals.desync_range = math.floor(lerp(visuals.desync_range, math.abs(math.floor(local_player.desync_angle())), 15))
        render.text(fonts.default_font, vector(aainfo.pos.x, posy + 12 * ind), white, nil, "> opium.sys (user: "..common.get_username()..") : status")
        ind = ind + 1
        render.text(fonts.default_font, vector(aainfo.pos.x, posy + 12 * ind), white, nil, "   ")
        render.text(fonts.default_font, vector(aainfo.pos.x + render.measure_text(fonts.default_font, nil, "   ").x, posy + 12 * ind), kolor, nil, "Opium ("..general.version..")")
        render.text(fonts.default_font, vector(aainfo.pos.x + render.measure_text(fonts.default_font, nil, "   Opium ("..general.version..")").x, posy + 12 * ind), white, nil, " loaded!")
        ind = ind + 1
        --visuals.yaw = (globals.tickcount % 2 == 0) and (refs.yaw.offset:get_override() + refs.modifier.offset:get_override() * aa.jitter_modifier) or visuals.yaw
        --FIX THIS AFTER ANTIAIM
        visuals.yaw = (globals.tickcount % 2 == 0) and refs.yaw.offset:get_override() or visuals.yaw
        render.text(fonts.default_font, vector(aainfo.pos.x, posy + 12 * ind), white, nil, "   Yaw angle : ")
        render.text(fonts.default_font, vector(aainfo.pos.x + render.measure_text(fonts.default_font, nil, "   Yaw angle : ").x, posy + 12 * ind), (visuals.yaw < 0) and kolor or white, nil, "<<")
        render.text(fonts.default_font, vector(aainfo.pos.x + render.measure_text(fonts.default_font, nil, "   Yaw angle : << ").x, posy + 12 * ind), white, nil, " "..math.abs(visuals.yaw).."°")
        render.text(fonts.default_font, vector(aainfo.pos.x + render.measure_text(fonts.default_font, nil, "  Yaw angle : << "..math.abs(visuals.yaw).."° ").x, posy + 12 * ind), visuals.yaw > 0 and kolor or white, nil, "   >>")
        ind = ind + 1
        render.text(fonts.default_font, vector(aainfo.pos.x, posy + 12 * ind), white, nil, "   Desync : ")
        render.text(fonts.default_font, vector(aainfo.pos.x + render.measure_text(fonts.default_font, nil, "   Desync : ").x, posy + 12 * ind), (local_player.desync_angle() < 0) and kolor or white, nil, "<<")
        render.text(fonts.default_font, vector(aainfo.pos.x + render.measure_text(fonts.default_font, nil, "   Desync : << ").x, posy + 12 * ind), white, nil, " "..visuals.desync_range.."°")
        render.text(fonts.default_font, vector(aainfo.pos.x + render.measure_text(fonts.default_font, nil, "  Desync : << "..visuals.desync_range.."° ").x, posy + 12 * ind), (local_player.desync_angle() > 0) and kolor or white, nil, "   >>")
        ind = ind + 1
        --local extended_string = (refs.lean_mode:get() == 1 and "none" or refs.lean_mode:get() == 2 and "static" or refs.lean_mode:get() == 3 and "static jitter" or refs.lean_mode:get() == 4 and "random jitter" or refs.lean_mode:get() == 5 and "sway" or "")
        --extended_string = extended_string..((refs.lean_mode:get() ~= 1 and refs.lean_mode:get() ~= 5) and " | "..(refs.lean_mode:get() == 2 and refs.lean_range:get().."°" or (refs.lean_mode:get() == 3 or refs.lean_mode:get() == 4) and refs.lean_jitter:get().."%" or "") or "")
        render.text(fonts.default_font, vector(aainfo.pos.x, posy + 12 * ind), white, nil, "   Extended angles : "..extended_string)
        ind = ind + 1
        render.text(fonts.default_font, vector(aainfo.pos.x, posy + 12 * ind), white, nil, "   Antibrute stage : "..aa.antibrute_current_stage)
        ind = ind + 1
        --ALSO FIX THIS AFTER AA
        render.text(fonts.default_font, vector(aainfo.pos.x, posy + 12 * ind), white, nil, ">")
        if math.floor(globals.curtime) % 2 == 0 then
            render.text(fonts.default_font, vector(aainfo.pos.x + render.measure_text(fonts.default_font, nil, "> ").x, posy + 12 * ind), white, nil, "_")
        end
        render.pop_clip_rect()
    elseif visuals.infopanel:get() == "Info menu" then
        aainfo.width = lerp(aainfo.width, aainfo.tabs[aainfo.tab].width, 15)
        aainfo.height = lerp(aainfo.height, aainfo.tabs[aainfo.tab].height, 15)
        local yaw = rage.antiaim:get_rotation()
        local body_yaw = rage.antiaim:get_rotation(true)
        local desync_range = visuals.desync_range / 60 * 0.2
        local kolor = color(visuals.themecol:get().r, visuals.themecol:get().g, visuals.themecol:get().b, aainfo.alpha * 255)
        local kolor_dark = lighten_hsv(kolor, -60)
        local white = (visuals.cur_theme == "Modern " or visuals.cur_theme == "Alpha ") and lighten(kolor, 50) or color(255, 255, 255, aainfo.alpha * 255)
        aainfo.brute_circle = lerp(aainfo.brute_circle, aa.antibrute_current_stage / aa.antibrute_stage_count:get(), 15)
        local duck = me and me.m_flDuckAmount or 0
        aainfo.duck = lerp(aainfo.duck, duck, 15)
        local antibrute_timer = (aa.antibrute_current_stage > 0) and (aa.antibrute_timer:get() - ticks_to_time(aa.antibrute_counter)) / aa.antibrute_timer:get() or 0
        --local desync_range = 0.1
        --render.circle_outline(vector(200, 500), color(150, 150, 150, 150), 20, 0, 1, 4)
        --render.circle_outline(vector(200, 500), color(255, 255, 255), 20, 90 - 0.1 * 360, 0.2, 4) range from bottom
        --[[if visuals.ip_circle_style:get() == "Regular" then
            
        elseif visuals.ip_circle_style:get() == "Gradient" then
            render.circle_gradient(vector(200, 500), bg, color(0, 0, 0, 0), 20, 0, 1)
            render.circle_gradient(vector(200, 500), real, color(real.r, real.g, real.b, 0), 20, 270 - 0.1 * 360 - math.normalize(yaw - view_y), 0.2)
            render.circle_gradient(vector(200, 500), fake, color(fake.r, fake.g, fake.b, 0), 20, 270 - desync_range * 0.5 * 360 - math.normalize(body_yaw - view_y), desync_range)
        end]]

        local click = 0
        local button_hover = color(white.r, white.g, white.b, aainfo.alpha * ui.get_alpha() * 255)
        local button_click = color(visuals.themecol:get().r, visuals.themecol:get().g, visuals.themecol:get().b, aainfo.alpha * ui.get_alpha() * 255)
        local button_inactive = grayscale(button_click)
        if visuals.cur_theme == "Modern " then
            if (header_alpha > 0) then
                render.shadow(vector(aainfo.pos.x - 2, aainfo.pos.y + aainfo.height + 7), vector(aainfo.pos.x - 4 + 34, aainfo.pos.y + aainfo.height + 39), color(kolor.r, kolor.g, kolor.b, math.min(255, kolor.a*0.35 * aainfo.alpha * ui.get_alpha())), 100, 0, 8)
                render.blur(vector(aainfo.pos.x - 3, aainfo.pos.y + aainfo.height + 6), vector(aainfo.pos.x - 3 + 34, aainfo.pos.y + aainfo.height + 40), 0.5, math.min((kolor.a * 8 / 255 * aainfo.alpha * ui.get_alpha()), 255), 8)
                render.rect(vector(aainfo.pos.x - 3, aainfo.pos.y + aainfo.height + 6), vector(aainfo.pos.x - 3 + 34, aainfo.pos.y + aainfo.height + 40), color(45, 45, 45, math.floor(kolor.a * visuals.themecol:get().a/255 * aainfo.alpha * ui.get_alpha())), 8)
                render.shadow(vector(aainfo.pos.x - 2 + aainfo.width - 33, aainfo.pos.y + aainfo.height + 7), vector(aainfo.pos.x - 4 + aainfo.width, aainfo.pos.y + aainfo.height + 39), color(kolor.r, kolor.g, kolor.b, math.min(255, kolor.a*0.35 * aainfo.alpha * ui.get_alpha())), 100, 0, 8)
                render.blur(vector(aainfo.pos.x - 3 + aainfo.width - 34, aainfo.pos.y + aainfo.height + 6), vector(aainfo.pos.x - 3 + aainfo.width, aainfo.pos.y + aainfo.height + 40), 0.5, math.min((kolor.a * 8 / 255 * aainfo.alpha * ui.get_alpha()), 255), 8)
                render.rect(vector(aainfo.pos.x - 3 + aainfo.width - 34, aainfo.pos.y + aainfo.height + 6), vector(aainfo.pos.x - 3 + aainfo.width, aainfo.pos.y + aainfo.height + 40), color(45, 45, 45, math.floor(kolor.a * visuals.themecol:get().a/255 * aainfo.alpha * ui.get_alpha())), 8)
            end
            if is_mouse_in_bounds(aainfo.pos.x - 3, aainfo.pos.y + aainfo.height + 6, aainfo.pos.x - 3 + 34, 34) then is_hovering = true end
            if is_mouse_in_bounds(aainfo.pos.x - 3 + aainfo.width - 34, aainfo.pos.y + aainfo.height + 6, aainfo.pos.x - 3 + aainfo.width, 34) then is_hovering = true end
            click = is_mouse_in_bounds(aainfo.pos.x - 3 + aainfo.width - 34, aainfo.pos.y + aainfo.height + 6, 34, 34) and 1 or is_mouse_in_bounds(aainfo.pos.x - 3, aainfo.pos.y + aainfo.height + 6, 34, 34) and -1 or 0
            render.text(fonts.default_font, vector(aainfo.pos.x + 14, aainfo.pos.y + aainfo.height + 23), button_col_left, "c", "<")
            render.text(fonts.default_font, vector(aainfo.pos.x + aainfo.width - 20, aainfo.pos.y + aainfo.height + 23), button_col_right, "c", ">")
        else
            if (header_alpha > 0) then
                visuals.draw_custom_box(vector(aainfo.pos.x - 3, aainfo.pos.y + aainfo.height + 6), vector(28, 28), math.floor(kolor.a * aainfo.alpha * ui.get_alpha()), 28, kolor)
                visuals.draw_custom_box(vector(aainfo.pos.x - 3 + aainfo.width - 28, aainfo.pos.y + aainfo.height + 6), vector(28, 28), math.floor(kolor.a * aainfo.alpha * ui.get_alpha()), 28, kolor)
            end
            if is_mouse_in_bounds(aainfo.pos.x - 3, aainfo.pos.y + aainfo.height + 6, 28, 28) then is_hovering = true end
            if is_mouse_in_bounds(aainfo.pos.x - 3 + aainfo.width - 28, aainfo.pos.y + aainfo.height + 6, 28, 28) then is_hovering = true end
            click = is_mouse_in_bounds(aainfo.pos.x - 3 + aainfo.width - 28, aainfo.pos.y + aainfo.height + 6, 28, 28) and 1 or is_mouse_in_bounds(aainfo.pos.x - 3, aainfo.pos.y + aainfo.height + 6, 28, 28) and -1 or 0
            render.text(fonts.default_font, vector(aainfo.pos.x + 11, aainfo.pos.y + aainfo.height + 20), button_col_left, "c", "<")
            render.text(fonts.default_font, vector(aainfo.pos.x + aainfo.width - 17, aainfo.pos.y + aainfo.height + 20), button_col_right, "c", ">")
        end
        button_col_left = lerp_color(button_col_left, click == -1 and button_hover or button_inactive, 15)
        button_col_right = lerp_color(button_col_right, click == 1 and button_hover or button_inactive, 15)
        click = (ui.get_alpha() > 0 and register_click(0x01)) and click or 0
        button_col_left = click == -1 and button_click or button_col_left
        button_col_right = click == -1 and button_click or button_col_right
        if click == -1 then
            aainfo.tab = aainfo.tab - 1
        elseif click == 1 then
            aainfo.tab = aainfo.tab + 1
        end
        if aainfo.tab > #aainfo.tabs then aainfo.tab = 1 elseif aainfo.tab < 1 then aainfo.tab = #aainfo.tabs end
        aainfo.pos.tab:set(aainfo.tab)

        if header_alpha > 0 then
            if visuals.cur_theme == "Modern " then
                visuals.draw_custom_box(vector(aainfo.pos.x - 3, aainfo.pos.y - 3), vector(aainfo.width, 30), 255 * aainfo.alpha * header_alpha, aainfo.height)
            elseif visuals.cur_theme == "Vamp " then
                visuals.draw_edgy_line(vector(aainfo.pos.x + 3, aainfo.pos.y + 24), aainfo.width - 12, 255 * aainfo.alpha * header_alpha)
            else
                visuals.draw_custom_box(vector(aainfo.pos.x - 3, aainfo.pos.y), vector(aainfo.width, 24), 255 * aainfo.alpha * header_alpha, aainfo.height - 4)
            end
        end
        local header_color = visuals.cur_theme == "Modern " and color(45, 45, 45, aainfo.alpha * 255 * header_alpha) or visuals.cur_theme == "Alpha " and lighten(kolor, 50) or color(255, 255, 255 * aainfo.alpha * header_alpha)
        --local header_text = aainfo.tabs[aainfo.tab].name
        --render.text(fonts.default_font, vector(aainfo.pos.x + aainfo.width / 2, aainfo.pos.y + 12), header_color, "c", header_text)
        for i=1, #aainfo.tabs do
            local tab = aainfo.tabs[i]
            tab.alpha = lerp(tab.alpha, aainfo.tab == i and 1 or 0, 15)
            tab.name = string.lower(tab.name)
            if visuals.theme:get() ~= "Solus v2" then tab.name = tab.name:sub(1, 1):upper()..tab.name:sub(2) end
            if visuals.infopanel_box:get() or (ui.get_alpha() > 0) then
                render.text(fonts.header_font, vector(aainfo.pos.x + aainfo.width / 2, aainfo.pos.y + 12), color(header_color.r, header_color.g, header_color.b, 255 * aainfo.alpha * tab.alpha * header_alpha), "c", tab.name)
            end
        end

        --AA panel
        if aainfo.tabs[1].alpha > 0.1 then
            local alpha = aainfo.alpha * aainfo.tabs[1].alpha
            local bg = color(visuals.ip_bg_color:get().r, visuals.ip_bg_color:get().g, visuals.ip_bg_color:get().b, 255 * alpha)
            local real = color(visuals.ip_real_color:get().r, visuals.ip_real_color:get().g, visuals.ip_real_color:get().b, alpha * 255)
            local fake = color(visuals.ip_fake_color:get().r, visuals.ip_fake_color:get().g, visuals.ip_fake_color:get().b, alpha * 255)
            local kolor = color(visuals.themecol:get().r, visuals.themecol:get().g, visuals.themecol:get().b, alpha * 255)
            local kolor_dark = lighten_hsv(kolor, -60)
            local white = (visuals.cur_theme == "Modern " or visuals.cur_theme == "Alpha ") and lighten(kolor, 50) or color(255, 255, 255, alpha * 255)
            if me and me.m_iHealth > 0 then
                render.rect(vector(aainfo.pos.x + 10, aainfo.pos.y + 34), vector(aainfo.pos.x + 18, aainfo.pos.y + 94), bg, 2)
                render.rect(vector(aainfo.pos.x + 10, aainfo.pos.y + 34 + aainfo.duck * 60), vector(aainfo.pos.x + 18, aainfo.pos.y + 94), kolor, 2)

                visuals.draw_info_circle(vector(aainfo.pos.x + 47, aainfo.pos.y + 54), bg, 20, 0, 1, 4, true)
                visuals.draw_info_circle(vector(aainfo.pos.x + 47, aainfo.pos.y + 54), real, 20, 270 - 0.1 * 360 - math.normalize(yaw - view_y), 0.2, 4)
                visuals.draw_info_circle(vector(aainfo.pos.x + 47, aainfo.pos.y + 54), fake, 20, 270 - desync_range * 0.5 * 360 - math.normalize(body_yaw - view_y), desync_range, 4)
                render.text(fonts.default_font, vector(aainfo.pos.x + 47, aainfo.pos.y + 89), white, "c", "Yaw")

                render.line(vector(aainfo.pos.x + 76, aainfo.pos.y + 34), vector(aainfo.pos.x + 76, aainfo.pos.y + 94), white)

                visuals.draw_info_circle(vector(aainfo.pos.x + 120, aainfo.pos.y + 44), bg, 8, 0, 1, 4, true)
                visuals.draw_info_circle(vector(aainfo.pos.x + 120, aainfo.pos.y + 44), kolor_dark, 8, 270, aainfo.brute_circle, 4)
                visuals.draw_info_circle(vector(aainfo.pos.x + 120, aainfo.pos.y + 44), kolor, 6, 270, antibrute_timer, 4)
                render.text(fonts.default_font, vector(aainfo.pos.x + 95, aainfo.pos.y + 45), white, "c", "AB")

                visuals.draw_info_circle(vector(aainfo.pos.x + 120, aainfo.pos.y + 69), bg, 8, 0, 1, 4, true)
                visuals.draw_info_circle(vector(aainfo.pos.x + 120, aainfo.pos.y + 69), kolor, 8, 270, globals.choked_commands / getmaxfakelag(), 4)
                render.text(fonts.default_font, vector(aainfo.pos.x + 95, aainfo.pos.y + 69), white, "c", "FL")

                render.text(fonts.pixelsmall, vector(aainfo.pos.x + 85, aainfo.pos.y + 85), refs.hs.on:get() and kolor or white, nil, "OS")
                render.text(fonts.pixelsmall, vector(aainfo.pos.x + 101, aainfo.pos.y + 85), aa.is_defensive and kolor or white, nil, "DF")
                local velocity = (me.m_iHealth > 0) and math.sqrt( math.pow( me.m_vecVelocity.x, 2 ) + math.pow( me.m_vecVelocity.y, 2 ) ) or 0
                if bit.band(me.m_fFlags, bit.lshift(1,0)) == 0 then
                    render.text(fonts.pixelsmall, vector(aainfo.pos.x + 117, aainfo.pos.y + 85), refs.dt.on:get() and rage.exploit:get() == 1 and color(255, 0, 0, white.a) or velocity/globals.choked_commands >= 20.84 and color(132, 195, 16, white.a) or color(255, 0, 0, white.a), nil, "LC")
                else
                    render.text(fonts.pixelsmall, vector(aainfo.pos.x + 117, aainfo.pos.y + 85), white, nil, "LC")
                end
            else
                render.text(fonts.default_font, vector(aainfo.pos.x + aainfo.tabs[1].width / 2, aainfo.pos.y + 9 + aainfo.tabs[1].height / 2), white, "c", "Your antiaim info\nwill appear here.")
            end
        end
        --Rage panel
        if aainfo.tabs[2].alpha > 0.1 then
            local exploit = (refs.dt.on:get() or refs.dt.on:get_override()) and "DT" or refs.hs.on:get() and "HS" or ""
            local ap = (refs.ap.on:get_override() or refs.ap.on:get()) and "true" or "false"
            local showcond = me ~= nil and me.m_iHealth > 0
            --aainfo.tabs[2].width = lerp(aainfo.tabs[2].width, (showcond and exploit ~= "") and 205 or 175, 15)
            local ind = 0
            if me ~= nil then
                local alpha = aainfo.alpha * aainfo.tabs[2].alpha
                local bg = color(visuals.ip_bg_color:get().r, visuals.ip_bg_color:get().g, visuals.ip_bg_color:get().b, 255 * alpha * aainfo.anims.exp)
                local kolor = color(visuals.themecol:get().r, visuals.themecol:get().g, visuals.themecol:get().b, alpha * 255)
                local kolor_light = lighten(kolor, 50)
                local kolor_dark = lighten_hsv(kolor, -60)
                local white = (visuals.cur_theme == "Modern " or visuals.cur_theme == "Alpha ") and lighten(kolor, 50) or color(255, 255, 255, alpha * 255)
                local wep = me:get_player_weapon()
                if wep ~= nil then
                    local wep_data = wep:get_weapon_info()
                    local icon = wep:get_weapon_icon()
                    local ovdmgtext = refs.is_overriding_dmg and " (override)" or ""
                    local dmg = refs.dmg:get_override() and refs.dmg:get_override() or refs.dmg:get()
                    local dmg = dmg ~= 0 and dmg or "auto"
                    local ovhctext = refs.is_overriding_hc and " (override)" or ""
                    local hc = refs.hc:get_override() and refs.hc:get_override() or refs.hc:get()
                    local ax = cvar.cl_lagcompensation:int() and "false" or "true"
                    local target = rage.antiaim:get_target() and rage.antiaim:get_target() or "none"
                    --render.texture(icon, vector(aainfo.pos.x + 10, aainfo.pos.y + 34))
                    local wep_index = wep:get_weapon_index()
                    --visuals.draw_info_circle(vector(aainfo.pos.x + 170, aainfo.pos.y + 58), kolor, 20, 270, aainfo.anims.exp_charge, 4)
                    --render.text(fonts.default_font, vector(aainfo.pos.x + 170 + 1, aainfo.pos.y + 58), color(kolor_light.r, kolor_light.g, kolor_light.b, 255 * aainfo.anims.exp), "c", exploit)
                    --visuals.draw_info_circle(vector(aainfo.pos.x + 170, aainfo.pos.y + 112), kolor, 20, 270, aainfo.anims.ap, 4)
                    --render.text(fonts.default_font, vector(aainfo.pos.x + 170 + 1, aainfo.pos.y + 112), color(kolor_light.r, kolor_light.g, kolor_light.b, 255 * aainfo.anims.ap), "c", ap)
                    local pad = 12
                    --local wep_class = get_classes(wep_data.weapon_class)
                    --string.sub(wep_data.weapon_name, 8)
                    aainfo.anims.exp = lerp(aainfo.anims.exp, exploit ~= "" and 1 or 0, 15)
                    aainfo.anims.exp_charge = lerp(aainfo.anims.exp_charge, rage.exploit:get(), 15)
                    if visuals.old_rage:get() then
                        render.text(fonts.wep_icons, vector(aainfo.pos.x + 10, aainfo.pos.y + 34), kolor, nil, WeaponDefinitionIndex[wep_index][3])
                        render.text(fonts.default_font, vector(aainfo.pos.x + 10, aainfo.pos.y + 74 + ind * pad), white, nil, "Weapon name: "..WeaponDefinitionIndex[wep_index][2])
                        ind = ind + 1
                        if aim.current_wep ~= 0 then
                            local p = (aim.current_wep_state ~= nil) and aim.current_wep_state or "default"
                            render.text(fonts.default_font, vector(aainfo.pos.x + 10, aainfo.pos.y + 74 + ind * pad), white, nil, "State: "..p)
                            ind = ind + 1
                        end
                        if WeaponDefinitionIndex[wep_index][1] then
                            render.text(fonts.default_font, vector(aainfo.pos.x + 10, aainfo.pos.y + 74 + ind * pad), white, nil, "Min. damage: "..dmg..ovdmgtext)
                            ind = ind + 1
                            render.text(fonts.default_font, vector(aainfo.pos.x + 10, aainfo.pos.y + 74 + ind * pad), white, nil, "Hitchance: "..hc..ovhctext)
                            ind = ind + 1
                        end
                        render.text(fonts.default_font, vector(aainfo.pos.x + 10, aainfo.pos.y + 74 + ind * pad), white, nil, "Force prediction: "..ax)
                        ind = ind + 1
                        render.text(fonts.default_font, vector(aainfo.pos.x + 10, aainfo.pos.y + 74 + ind * pad), white, nil, "Autopeek: "..ap)
                        ind = ind + 1
                        render.text(fonts.default_font, vector(aainfo.pos.x + aainfo.tabs[2].width - 21, aainfo.pos.y + 40), white, "c", exploit)
                        local exp_color = color(kolor.r, kolor.g, kolor.b, 255 * alpha * aainfo.anims.exp)
                        render.rect(vector(aainfo.pos.x + aainfo.tabs[2].width - 25, aainfo.pos.y + 52), vector(aainfo.pos.x + aainfo.tabs[2].width - 17, aainfo.pos.y + 52 + math.max(58, 80 * ind * 0.2)), bg, 2)
                        render.rect(vector(aainfo.pos.x + aainfo.tabs[2].width - 25, aainfo.pos.y + 52 + (1 - aainfo.anims.exp_charge) * math.max(58, 80 * ind * 0.2)), vector(aainfo.pos.x + aainfo.tabs[2].width - 17, aainfo.pos.y + 52 + math.max(58, 80 * ind * 0.2)), exp_color, 2)
                        aainfo.anims.ap = lerp(aainfo.anims.ap, (refs.ap.on:get_override() or refs.ap.on:get()) and 1 or 0, 15)
                        aainfo.tabs[2].width = lerp(aainfo.tabs[2].width, 27 + 19 * aainfo.anims.exp + math.max(render.measure_text(fonts.default_font, nil, "Min. damage: "..dmg..ovdmgtext).x, render.measure_text(fonts.default_font, nil, "Force prediction: "..ax).x, render.measure_text(fonts.default_font, nil, "Weapon name: "..WeaponDefinitionIndex[wep_index][2]).x), 15)
                    else
                        aainfo.tabs[2].width = 185
                        local w = render.measure_text(fonts.wep_icons, nil, WeaponDefinitionIndex[wep_index][3]).x + render.measure_text(fonts.header_font, nil, WeaponDefinitionIndex[wep_index][2]).x + 6
                        local p = (aim.current_wep_state ~= nil) and aim.current_wep_state or "default"
                        render.text(fonts.wep_icons, vector(aainfo.pos.x + 92 - w / 2, aainfo.pos.y + 34), kolor, nil, WeaponDefinitionIndex[wep_index][3])
                        render.text(fonts.header_font, vector(aainfo.pos.x + 6 + 92 - w / 2 + render.measure_text(fonts.wep_icons, nil, WeaponDefinitionIndex[wep_index][3]).x, aainfo.pos.y + 34), kolor, nil, WeaponDefinitionIndex[wep_index][2])
                        render.circle_outline(vector(aainfo.pos.x + 92, aainfo.pos.y + 84), kolor, 26, 0, 1, 4)
                        render.circle_gradient(vector(aainfo.pos.x + 92, aainfo.pos.y + 84), color(kolor.r, kolor.g, kolor.b, kolor.a * aainfo.anims.exp_charge), color(0, 0), 26, 0, 1)
                        --render.circle_outline(vector(aainfo.pos.x + 92, aainfo.pos.y + 84), kolor, 26, 0, aainfo.anims.exp_charge, 4)
                        render.line(vector(aainfo.pos.x + 112, aainfo.pos.y + 67), vector(aainfo.pos.x + 120, aainfo.pos.y + 60), kolor)
                        render.line(vector(aainfo.pos.x + 120, aainfo.pos.y + 60), vector(aainfo.pos.x + 128, aainfo.pos.y + 60), kolor)
                        render.text(fonts.default_font, vector(aainfo.pos.x + 132, aainfo.pos.y + 55), kolor, nil, hc)
                        render.text(fonts.pixelsmall, vector(aainfo.pos.x + 134 + render.measure_text(fonts.default_font, nil, hc).x, aainfo.pos.y + 50), refs.is_overriding_hc and kolor or kolor_dark, nil, "hc")
                        render.line(vector(aainfo.pos.x + 118, aainfo.pos.y + 84), vector(aainfo.pos.x + 128, aainfo.pos.y + 84), kolor)
                        render.text(fonts.default_font, vector(aainfo.pos.x + 132, aainfo.pos.y + 79), kolor, nil, "SP")
                        render.text(fonts.pixelsmall, vector(aainfo.pos.x + 134 + render.measure_text(fonts.default_font, nil, "SP").x, aainfo.pos.y + 74), refs.is_overriding_sp and kolor or kolor_dark, nil, ((refs.sp:get_override() == "Force") or (refs.sp:get() == "Force")) and "fc" or ((refs.sp:get_override() == "Prefer") or (refs.sp:get() == "Prefer")) and "pref" or "def")
                        render.line(vector(aainfo.pos.x + 112, aainfo.pos.y + 99), vector(aainfo.pos.x + 120, aainfo.pos.y + 106), kolor)
                        render.line(vector(aainfo.pos.x + 120, aainfo.pos.y + 106), vector(aainfo.pos.x + 128, aainfo.pos.y + 106), kolor)
                        render.text(fonts.default_font, vector(aainfo.pos.x + 132, aainfo.pos.y + 101), kolor, nil, "AP")
                        render.text(fonts.pixelsmall, vector(aainfo.pos.x + 134 + render.measure_text(fonts.default_font, nil, "AP").x, aainfo.pos.y + 96), (refs.ap.on:get_override() or refs.ap.on:get()) and kolor or kolor_dark, nil, (refs.ap.on:get_override() or refs.ap.on:get()) and "on" or "off")
                        render.line(vector(aainfo.pos.x + 71, aainfo.pos.y + 67), vector(aainfo.pos.x + 63, aainfo.pos.y + 60), kolor)
                        render.line(vector(aainfo.pos.x + 63, aainfo.pos.y + 60), vector(aainfo.pos.x + 55, aainfo.pos.y + 60), kolor)
                        render.text(fonts.default_font, vector(aainfo.pos.x + 52 - render.measure_text(fonts.default_font, nil, dmg).x, aainfo.pos.y + 55), kolor, nil, dmg)
                        render.text(fonts.pixelsmall, vector(aainfo.pos.x + 52 - render.measure_text(fonts.default_font, nil, dmg).x - render.measure_text(fonts.pixelsmall, nil, "md").x, aainfo.pos.y + 50), refs.is_overriding_dmg and kolor or kolor_dark, nil, "md")
                        render.line(vector(aainfo.pos.x + 55, aainfo.pos.y + 84), vector(aainfo.pos.x + 65, aainfo.pos.y + 84), kolor)
                        render.text(fonts.default_font, vector(aainfo.pos.x + 52 - render.measure_text(fonts.default_font, nil, "BA").x, aainfo.pos.y + 79), kolor, nil, "BA")
                        local b = ((refs.baim:get_override() == "Force") or (refs.baim:get() == "Force")) and "fc" or ((refs.baim:get_override() == "Prefer") or (refs.baim:get() == "Prefer")) and "pref" or "def"
                        render.text(fonts.pixelsmall, vector(aainfo.pos.x + 52 - render.measure_text(fonts.default_font, nil, "BA").x - render.measure_text(fonts.pixelsmall, nil, b).x, aainfo.pos.y + 74), refs.is_overriding_baim and kolor or kolor_dark, nil, b)
                        render.text(fonts.default_font, vector(aainfo.pos.x + 92, aainfo.pos.y + 84), kolor, "c", exploit)
                        render.line(vector(aainfo.pos.x + 71, aainfo.pos.y + 99), vector(aainfo.pos.x + 63, aainfo.pos.y + 106), kolor)
                        render.line(vector(aainfo.pos.x + 63, aainfo.pos.y + 106), vector(aainfo.pos.x + 55, aainfo.pos.y + 106), kolor)
                        render.text(fonts.default_font, vector(aainfo.pos.x + 52 - render.measure_text(fonts.default_font, nil, p).x, aainfo.pos.y + 101), kolor, nil, p)
                        --aainfo.tabs[2].height = 130
                    end
                end
            end
            aainfo.tabs[2].height = visuals.old_rage:get() and 74 + (ind + 1) * 12 or 130
            if me == nil or me:get_player_weapon() == nil then
                render.text(fonts.default_font, vector(aainfo.pos.x + aainfo.tabs[2].width / 2, aainfo.pos.y + 9 + aainfo.tabs[2].height / 2), white, "c", "Your weapon info\nwill appear here.")
            end
        end
    else visuals.infopanel_anim = 0 end

    ::skip::

    if aainfo.drag_alpha > 0.1 then
        render.rect_outline(vector(aainfo.pos.x - 8, posy - 4 - 32), vector(aainfo.pos.x + aainfo.width, posy - 4), color(255, 255, 255, math.floor(255 * aainfo.drag_alpha)), 1, visuals.cur_theme == "Retro" and 0 or 6)
        render.text(fonts.default_font, vector(aainfo.pos.x + aainfo.width / 2, posy - 13 - 32), color(255, 255, 255, math.floor(255 * aainfo.drag_alpha)), "c", "hold to drag")
    end

    if (ui.get_alpha() > 0) and is_mouse_in_bounds(aainfo.pos.x - 3 - 4, posy - 3 - 32, aainfo.width + 8, 32) and not hovering then
        aainfo.drag_alpha = lerp(aainfo.drag_alpha, 1, 15)
    else
        aainfo.drag_alpha = lerp(aainfo.drag_alpha, 0, 15)
    end

    --aainfo.drag()
    --[[local pos = {x = aainfo.pos.x,
    y = aainfo.pos.y - 32,
    move_x = aainfo.pos.move_x,
    move_y = aainfo.pos.move_y,
    unlocked = aainfo.pos.unlocked,
    received = aainfo.pos.received,
    x_slider = aainfo.pos.x_slider,
    y_slider = aainfo.pos.y_slider,
    }]]
    if not hovering then
        drag(aainfo.pos, vector(aainfo.width + 8, 32))
    end

end

events.render:set(visuals.draw_aainfo)

visuals.crosscol = {r = cvar.cl_crosshaircolor_r, g = cvar.cl_crosshaircolor_g, b = cvar.cl_crosshaircolor_b}
visuals.crosscol_bak = color(visuals.crosscol.r:float(), visuals.crosscol.g:float(), visuals.crosscol.b:float())
visuals.crosscol_applied = false

visuals.crosscol_set = function()
    visuals.crosscol_applied = true
    visuals.crosscol.r:float(visuals.themecol:get().r)
    visuals.crosscol.g:float(visuals.themecol:get().g)
    visuals.crosscol.b:float(visuals.themecol:get().b)
end

visuals.crosscol_reset = function()
    visuals.crosscol.r:float(visuals.crosscol_bak.r)
    visuals.crosscol.g:float(visuals.crosscol_bak.g)
    visuals.crosscol.b:float(visuals.crosscol_bak.b)
    visuals.crosscol_applied = false
end

visuals.crosscol_select:set_callback(function(ref)
    if ref:get() then
        visuals.crosscol_set()
    else
        visuals.crosscol_reset()
    end
end, true)

local banan = 0

visuals.draw_scope = function()

    --[[if visuals.changing_scope then
        refs.scope:set(visuals.scope_cache)
        visuals.changing_scope = false
    end

    if visuals.customscope:get_override() == false or not visuals.customscope:get() then return end

    if not visuals.changing_scope then
        visuals.scope_cache = refs.scope:get()
    end

    visuals.changing_scope = true
    refs.scope:set("Remove All")]]

    if not visuals.customscope:get() then refs.scope:override() return end

    refs.scope:override("Remove All")

    local lp = entity.get_local_player()
    if not globals.is_in_game then return end
    if not lp then return end
    if not (lp.m_iHealth > 0) then return end
    local weap = lp:get_player_weapon()
    if weap == nil then return end
    --local is_scoped = weap.m_zoomLevel
    --local in_scope = scoped_prop == true and true or false

    local scoped = lp.m_bIsScoped
    
    local x, y = screensizex / 2 + 1, screensizey / 2 + 1
    local weapon = lp:get_player_weapon()
    if not weapon then return end
    local inacc = weapon:get_inaccuracy()
    if inacc == nil then inacc = 0 end
    local inaccuracy = visuals.scope_inaccuracy:get() and inacc or 0
    local o = (visuals.scope_offset:get() + inaccuracy * 80 )* scopeanim
    local s = visuals.scope_length:get() * scopeanim
    local w = 1 / 2
    local c0 = alp_self(visuals.scope_color_primary:get(), scopeanim)
    local c1 = alp_self(visuals.scope_color_secondary:get(), scopeanim)
    --local active = scoped and lp.m_iHealth > 0
    scopeanim = math.max(lerp(scopeanim, active and 1 or 0, 10), 0)
    if scopeanim < 0.1 then return end
    local r = render.gradient
    local r0, g0, b0, a0 = c0.r, c0.g, c0.b, c0.a
    local r1, g1, b1, a1 = c1.r, c1.g, c1.b, c1.a

    banan = banan - visuals.scope_speed:get() * 0.1
    math.clamp(banan, -360, 360)
    render.push_rotation(visuals.scope_type:get() == "Static" and visuals.scope_rotation:get() or banan)
    r(vector(x - o - s, y - w), vector(x - o, y + w * 2), color(r1, g1, b1, a1), color(r0, g0, b0, a0), color(r1, g1, b1, a1), color(r0, g0, b0, a0))
    r(vector(x + o, y - w), vector(x + s + o, y + w * 2), color(r0, g0, b0, a0), color(r1, g1, b1, a1), color(r0, g0, b0, a0), color(r1, g1, b1, a1))
    r(vector(x - w, y + o), vector(x + w * 2, y + o + s), color(r0, g0, b0, a0), color(r0, g0, b0, a0), color(r1, g1, b1, a1), color(r1, g1, b1, a1))
    r(vector(x - w, y - o - s), vector(x + w * 2, y - o - 1), color(r1, g1, b1, a1), color(r1, g1, b1, a1), color(r0, g0, b0, a0), color(r0, g0, b0, a0))
    render.pop_rotation()

end

events.render:set(visuals.draw_scope)

--visuals.reset_scope = function()
--    refs.scope:set(visuals.scope_cache)
--end
--
--events.config_state(function(state) if state == "pre_save" then visuals.customscope:override(false) elseif state == "post_save" then visuals.customscope:override() end end)
--events.shutdown:set(visuals.reset_scope)

local function rgb_health_based(percentage)
    local kolor = visuals.themecol:get()
    local r = kolor.r
    local g = kolor.g
    local b = kolor.b
    if visuals.velocity_color:get() == "Adaptive" then
        r = math.floor(124*2 - 124 * percentage)
        g = math.floor(195 * percentage)
        b = 13
    end
    return r, g, b
end

local function remap(val, newmin, newmax, min, max, clamp)
    min = min or 0
    max = max or 1

    local pct = (val-min)/(max-min)

    if clamp ~= false then
        pct = math.min(1, math.max(0, pct))
    end

    return newmin+(newmax-newmin)*pct
end

local function rectangle_outline(x, y, w, h, r, g, b, a, s)
    s = s or 1
    render.rect(vector(x, y), vector(x+w, y+s), color(r, g, b, a)) -- top
    render.rect(vector(x, y+h-s), vector(x+w, y+h), color(r, g, b, a)) -- bottom
    render.rect(vector(x, y+s), vector(x+s, y+h-s), color(r, g, b, a)) -- left
    render.rect(vector(x+w-s, y+s), vector(x+w, y+h-s), color(r, g, b, a)) -- right
end

exclamanim = 0
exclamdirection = true
modifier = 1

bar = {}

bar.drag_alpha = 0

--bar.x = screensizex/2 - render.measure_text(fonts.modern_velocity_font, nil, text).x - 10

bar.pos = {
    x = screensizex/2 - 46,
    y = screensizey*0.32,
    x_slider = vs_debug:slider_e("Slowed bar X", 0, render.screen_size().x, screensizex/2 - 46),
    y_slider = vs_debug:slider_e("Slowed bar Y", 0, render.screen_size().y, screensizey*0.32),
    move_x = 0,
    move_y = 0,
    unlocked = 0,
    received = 0,
}
bar.pos.x_slider:visibility(false)
bar.pos.y_slider:visibility(false)

bar.pos.x = bar.pos.x_slider:get()
bar.pos.y = bar.pos.y_slider:get()

local function drawBar(modifier, r, g, b, a, text)
    local text_width = 95
    local x, y = bar.pos.x, bar.pos.y

    if (ui.get_alpha() > 0) and (a>0) and is_mouse_in_bounds(bar.pos.x-32, bar.pos.y, 141, 38) then
        bar.drag_alpha = lerp(bar.drag_alpha, 1, 15)
    else
        bar.drag_alpha = lerp(bar.drag_alpha, 0, 15)
    end

    if bar.drag_alpha then
        render.rect_outline(vector(bar.pos.x-32, y), vector(bar.pos.x+112, bar.pos.y+38), color(255, 255, 255, math.floor(255 * bar.drag_alpha * a)), 1, 8)
        render.text(fonts.default_font, vector(bar.pos.x + 40, bar.pos.y - 10), color(255, 255, 255, math.floor(255 * bar.drag_alpha * a)), "c", "hold to drag")
    end

    is_hovering = false
    drag(bar.pos, vector(142, 38), vector(-32, 0))

    --if a > 0.7 then
    --    render.draw_rect(x+13, y+11, 8, 20, color.new(16, 16, 16, math.floor(255*a)))
    --end

    --render.draw_text(x+8, y+3, string.format("%s %.f", text, modifier * 100.0), color.new(255, 255, 255, 255*a))
    render.text( fonts.velocity_font, vector(x+8, y+5), color(255, 255, 255, math.floor(255*a)), nil, string.format("%s %.f", text, modifier * 100.0).."%" )

    local rx, ry, rw, rh = x+8, y+3+17, text_width, 9
    render.rect(vector(rx+1, ry+1), vector(rx+1+rw-2, ry+1+rh-2), color(16, 16, 16, math.floor(180*a)))
    render.rect(vector(rx+1, ry+1), vector(rx+1+math.floor((rw-2)*modifier), ry+1+rh-2), color(r, g, b, math.floor(180*a)))
    rectangle_outline(rx, ry, rw, rh, 0, 0, 0, math.floor(255*a), 1)
    vertices = {vector(x-11, y+5), vector(x-26, y+31), vector(x+4, y+31)}
    render.poly(color(0, 0, 0, math.floor(255 * a)), vector(x-11, y+5), vector(x-26, y+31), vector(x+4, y+31))
    vertices = {vector(x-11, y+8), vector(x-23, y+29), vector(x+1, y+29)}
    render.poly(color(r, g, b, math.floor(255 * a)), vector(x-11, y+8), vector(x-23, y+29), vector(x+1, y+29))
    exclamanim = math.max(lerp2(exclamanim, exclamdirection and 1 or 0, 5 * globals.frametime), 0)
    if exclamanim > 0.95 then exclamdirection = false
    elseif exclamanim < 0.05 then exclamdirection = true end
    render.rect( vector(x-12, y+14), vector(x-10, y+22), color(0, 0, 0, math.floor(255 * exclamanim * a)) )
    render.rect( vector(x-12, y+24), vector(x-10, y+26), color(0, 0, 0, math.floor(255 * exclamanim * a)) )
end

local function rounded_gradient(x, y, w, h, color1, color2, round)
    render.push_clip_rect(vector(x, y), vector(x + round, y + h))
    render.rect(vector(x, y), vector(x + round * 2, y + h), color1, round)
    render.pop_clip_rect()
    render.push_clip_rect(vector(x + w - round, y), vector(x + w, y + h))
    render.rect(vector(x + w - round * 2, y), vector(x + w, y + h), color2, round)
    render.pop_clip_rect()
    render.gradient(vector(x + round, y), vector(x + w - round, y + h), color1, color2, color1, color2)
end

--local function drawModernBar(modifier, r, g, b, a, text)
--
--    local x, y = bar.pos.x + 4, bar.pos.y + 4
--    local kolor = color(r, g, b, math.floor(255*a))
--
--    if (ui.get_alpha() > 0) and (a>0) and is_mouse_in_bounds(bar.pos.x, bar.pos.y, 92, 48) then
--        bar.drag_alpha = lerp(bar.drag_alpha, 1, 15)
--    else
--        bar.drag_alpha = lerp(bar.drag_alpha, 0, 15)
--    end
--
--    if bar.drag_alpha then
--        render.rect_outline(vector(bar.pos.x, bar.pos.y), vector(bar.pos.x+92, bar.pos.y+48), color(255, 255, 255, math.floor(255 * bar.drag_alpha * a)), 1, 8)
--        render.text(fonts.default_font, vector(bar.pos.x + 46, bar.pos.y - 10), color(255, 255, 255, math.floor(255 * bar.drag_alpha * a)), "c", "hold to drag")
--    end
--
--    is_hovering = false
--    drag(bar.pos, vector(92, 48))
--
--    --[[render.shadow(vector(x, y), vector(x+40, y+40), color(r, g, b, math.floor(255*a*0.35)), 100, 0, 8)
--    render.rect(vector(x, y), vector(x+40, y+40), color(45, 45, 45, math.floor(255*a)), 8)
--    render.rect(vector(x+4, y+4), vector(x+36, y+36), kolor, 6)]]
--    visuals.draw_custom_box(vector(x, y), vector(40, 40), math.floor(255*a), 40, kolor, "Modern ")
--    --drawModernBox(vector(x, y), vector(x+40, y+40), a)
--    exclamanim = math.max(lerp2(exclamanim, exclamdirection and 1 or 0, 5 * globals.frametime), 0)
--    if exclamanim > 0.95 then exclamdirection = false
--    elseif exclamanim < 0.05 then exclamdirection = true end
--    --render.rect( vector(x+19, y+10), vector(x+19+3, y+10+13), color(45, 45, 45, math.floor(255 * exclamanim * a)) )
--    --render.rect( vector(x+19, y+18+8), vector(x+19+3, y+18+11), color(45, 45, 45, math.floor(255 * exclamanim * a)) )
--    render.text(fonts.modern_icons, vector(x+20, y+21), color(45, 45, 45, math.floor(255 * exclamanim * a)), "c", ui.get_icon("person-running"))
--    x=x+44
--    --[[render.shadow(vector(x, y), vector(x+40, y+40), color(r, g, b, math.floor(255*a*0.35)), 100, 0, 8)
--    render.rect(vector(x, y), vector(x+40, y+40), color(45, 45, 45, math.floor(255*a)), 8)
--    render.rect(vector(x+4, y+4), vector(x+36, y+36), kolor, 6)]]
--    visuals.draw_custom_box(vector(x, y), vector(40, 40), math.floor(255*a), 40, kolor, "Modern ")
--    render.circle_outline(vector(x+20, y+20), color(45, 45, 45, math.floor(255*a)), 10, 360*(1-modifier), 1-modifier, 3)
--end

local function drawModernBar(modifier, r, g, b, a, text)

    local x, y = bar.pos.x + 4, bar.pos.y + 4
    local kolor = color(r, g, b, math.floor(255*a))
    local sec = (visuals.themecol2_select:get() == "Custom" and visuals.velocity_color:get() ~= "Adaptive") and visuals.themecol2:get() or lighten(kolor, 20)

    if (ui.get_alpha() > 0) and (a>0) and is_mouse_in_bounds(bar.pos.x, bar.pos.y, 92, 48) then
        bar.drag_alpha = lerp(bar.drag_alpha, 1, 15)
    else
        bar.drag_alpha = lerp(bar.drag_alpha, 0, 15)
    end

    if bar.drag_alpha then
        render.rect_outline(vector(bar.pos.x, bar.pos.y), vector(bar.pos.x+152, bar.pos.y+48), color(255, 255, 255, math.floor(255 * bar.drag_alpha * a)), 1, 8)
        render.text(fonts.default_font, vector(bar.pos.x + 76, bar.pos.y - 10), color(255, 255, 255, math.floor(255 * bar.drag_alpha * a)), "c", "hold to drag")
    end

    is_hovering = false
    drag(bar.pos, vector(92, 48))

    visuals.draw_custom_box(vector(x, y), vector(40, 40), math.floor(255*a), 40, kolor, "Modern ")
    exclamanim = math.max(lerp2(exclamanim, exclamdirection and 1 or 0, 5 * globals.frametime), 0)
    if exclamanim > 0.95 then exclamdirection = false
    elseif exclamanim < 0.05 then exclamdirection = true end
    render.text(fonts.modern_icons, vector(x+20, y+21), color(45, 45, 45, math.floor(255 * exclamanim * a)), "c", ui.get_icon("person-running"))
    x=x+44
    --visuals.draw_custom_box(vector(x, y + 10), vector(80, 20), math.floor(255*a), 20, kolor, "Modern ")
    render.shadow(vector(x + 1, y + 1), vector(x + 100 - 1, y + 41 - 1), color(kolor.r, kolor.g, kolor.b, math.min(255, 255*a*0.35)), 100, 0, 8)
    render.blur(vector(x, y), vector(x + 100, y + 41), 0.5, math.min((visuals.themecol:get().a * 8 / 255), 255) * a, 8)
    render.rect(vector(x, y), vector(x + 100, y + 41), color(45, 45, 45, math.floor(visuals.themecol:get().a*a)), 8)
    render.gradient(vector(x+4, y + 20+4), vector(x + math.max(100 * (1 - modifier) - 4, 5), y + 40 - 4), color(sec.r, sec.g, sec.b, 255*a), color(sec.r, sec.g, sec.b, 255*a), color(kolor.r, kolor.g, kolor.b, 255*a), color(kolor.r, kolor.g, kolor.b, 255*a), 5.5)
    render.text(fonts.modern, vector(x + 6, y + 6), sec, nil, string.format("%s %.f", "Slowed", (1-modifier) * 100.0).."%")
    render.circle_outline(vector(x+88, y+12), sec, 6, 360*(1-modifier), 1-modifier, 2)
end

events.render:set(function()

    local lp = entity.get_local_player()
    --if lp == nil then return end
    --if not (lp.m_iHealth > 0) then modifier = 1 end

    local theme = visuals.velocity_alert:get()

    if lp and (lp.m_iHealth > 0) then
        modifier = (theme == "Classic" and (ui.get_alpha() == 0)) and lerp(modifier, lp.m_flVelocityModifier, 10) or lp.m_flVelocityModifier
        --modifier = lp.m_flVelocityModifier
    else modifier = 1 end
    if (ui.get_alpha() > 0) and modifier == 1 then
        modifier = 1 - ui.get_alpha()
        modifier = (modifier > 0.99) and 1 or modifier
    end
    if modifier == 1 then return end

    local r, g, b = rgb_health_based(modifier)
    local a = remap(modifier, 1, 0, 0.85, 1)

    if theme == "Classic" then
        drawBar(modifier, r, g, b, a, "Slowed down")
    end
    --modifier = lp.m_flVelocityModifier
    if theme == "Modern" then
        drawModernBar(modifier, r, g, b, a, "Slowed down")
    end

end)

arrows = {}
arrows.desync = 30
arrows.left_color = color(20, 20, 20, 100)
arrows.right_color = color(20, 20, 20, 100)
arrows.left_manual = color(20, 20, 20, 100)
arrows.right_manual = color(20, 20, 20, 100)
fonts.arrow_font = render.load_font( "Verdana", 24, "a" )
fonts.modern_arrows = render.load_font( "Verdana", 20, "a" )

visuals.draw_simple_arrows = function()
    if visuals.arrows:get() ~= "Simple" then return end
    local lp = entity.get_local_player()
    if not lp then return end
    if (lp.m_iHealth <= 0) then return end
    local inactive_col = color(20, 20, 20, 100)
    local inactive_manual = color(20, 20, 20, 0)
    local active_col = visuals.arrows_col:get()
    active_col.a = 255
    local angle = local_player.desync_angle(true)
    if not lp.m_bIsScoped then
        arrows.left_color = lerp_color(arrows.left_color, (angle < 0) and active_col or inactive_col, 20)
        arrows.right_color = lerp_color(arrows.right_color, (angle > 0) and active_col or inactive_col, 20)
        arrows.left_manual = lerp_color(arrows.left_manual, aa.left:get() and active_col or inactive_manual, 20)
        arrows.right_manual = lerp_color(arrows.right_manual, aa.right:get() and active_col or inactive_manual, 20)
    end
    arrows.left_color.a = lp.m_bIsScoped and math.floor(lerp(arrows.left_color.a, 0, 15)) or arrows.left_color.a
    arrows.right_color.a = lp.m_bIsScoped and math.floor(lerp(arrows.left_color.a, 0, 15)) or arrows.right_color.a
    arrows.left_manual.a = lp.m_bIsScoped and math.floor(lerp(arrows.left_manual.a, 0, 15)) or arrows.left_manual.a
    arrows.right_manual.a = lp.m_bIsScoped and math.floor(lerp(arrows.right_manual.a, 0, 15)) or arrows.right_manual.a
    render.poly(arrows.left_color, vector(screensizex / 2 - 35, screensizey / 2), vector(screensizex / 2 - 24, screensizey / 2 - 5), vector(screensizex / 2 - 24, screensizey / 2 + 6)) -- left
    render.text(fonts.arrow_font, vector(screensizex / 2 - 36, screensizey / 2 - 1), arrows.left_manual, "c", "<")
    render.text(fonts.arrow_font, vector(screensizex / 2 + 37, screensizey / 2 - 1), arrows.right_manual, "c", ">")
    render.poly(arrows.right_color, vector(screensizex / 2 + 35, screensizey / 2), vector(screensizex / 2 + 24, screensizey / 2 + 6), vector(screensizex / 2 + 24, screensizey / 2 - 5)) -- right
end

visuals.draw_simple_arrows_alt = function()
    if visuals.arrows:get() ~= "Simple (Alt)" then return end
    local lp = entity.get_local_player()
    if not lp then return end
    if (lp.m_iHealth <= 0) then return end
    local inactive_col = color(20, 20, 20, 100)
    local inactive_manual = color(20, 20, 20, 100)
    local active_col = visuals.arrows_col:get()
    active_col.a = 255
    local angle = local_player.desync_angle()
    if not lp.m_bIsScoped then
        arrows.left_color = lerp_color(arrows.left_color, (angle < 0) and active_col or inactive_col, 20)
        arrows.right_color = lerp_color(arrows.right_color, (angle > 0) and active_col or inactive_col, 20)
        --arrows.left_manual = lerp_color(arrows.left_manual, aa.left:get() and active_col or inactive_manual, 20)
        --arrows.right_manual = lerp_color(arrows.right_manual, aa.right:get() and active_col or inactive_manual, 20)
        arrows.left_manual = lerp_color(arrows.left_manual, aa.left:get() and active_col or inactive_manual, 20)
        arrows.right_manual = lerp_color(arrows.right_manual, aa.right:get() and active_col or inactive_manual, 20)
    end
    arrows.left_color.a = lp.m_bIsScoped and math.floor(lerp(arrows.left_color.a, 0, 15)) or arrows.left_color.a
    arrows.right_color.a = lp.m_bIsScoped and math.floor(lerp(arrows.left_color.a, 0, 15)) or arrows.right_color.a
    arrows.left_manual.a = lp.m_bIsScoped and math.floor(lerp(arrows.left_manual.a, 0, 15)) or arrows.left_manual.a
    arrows.right_manual.a = lp.m_bIsScoped and math.floor(lerp(arrows.right_manual.a, 0, 15)) or arrows.right_manual.a
    render.poly(arrows.left_manual, vector(screensizex / 2 - 37, screensizey / 2), vector(screensizex / 2 - 26, screensizey / 2 - 5), vector(screensizex / 2 - 26, screensizey / 2 + 6)) -- left
    render.rect(vector(screensizex / 2 - 25, screensizey / 2 - 5), vector(screensizex / 2 - 24, screensizey / 2 + 6), arrows.left_color)
    render.rect(vector(screensizex / 2 + 25, screensizey / 2 - 6), vector(screensizex / 2 + 26, screensizey / 2 + 5), arrows.right_color)
    --render.poly(arrows.left_color, vector(screensizex / 2 - 25, screensizey / 2 - 5), vector(screensizex / 2 - 25, screensizey / 2 + 6), vector(screensizex / 2 - 24, screensizey / 2 + 6), vector(screensizex / 2 - 24, screensizey / 2 - 5))
    --render.poly(arrows.right_color, vector(screensizex / 2 + 24, screensizey / 2 - 6), vector(screensizex / 2 + 24, screensizey / 2 + 5), vector(screensizex / 2 + 25, screensizey / 2 + 5), vector(screensizex / 2 + 25, screensizey / 2 - 6))
    render.poly(arrows.right_manual, vector(screensizex / 2 + 38, screensizey / 2), vector(screensizex / 2 + 27, screensizey / 2 + 5), vector(screensizex / 2 + 27, screensizey / 2 - 6))
end

visuals.draw_modern_arrows = function()
    if visuals.arrows:get() ~= "Modern" then return end
    local lp = entity.get_local_player()
    if not lp then return end
    if (lp.m_iHealth <= 0) then return end
    local active_col = visuals.arrows_col:get()
    active_col.a = 255
    local inactive_col = visuals.arrows_mm:get() == "Dark" and lighten_hsv(active_col, -55) or lighten(active_col, 50)
    local angle = local_player.desync_angle()
    if not lp.m_bIsScoped then
        arrows.left_color = lerp_color(arrows.left_color, (angle < 0) and active_col or inactive_col, 20)
        arrows.right_color = lerp_color(arrows.right_color, (angle > 0) and active_col or inactive_col, 20)
        arrows.left_manual = lerp_color(arrows.left_manual, aa.left:get() and active_col or inactive_col, 20)
        arrows.right_manual = lerp_color(arrows.right_manual, aa.right:get() and active_col or inactive_col, 20)
    end
    arrows.left_color.a = lp.m_bIsScoped and math.floor(lerp(arrows.left_color.a, 0, 15)) or arrows.left_color.a
    arrows.right_color.a = lp.m_bIsScoped and math.floor(lerp(arrows.left_color.a, 0, 15)) or arrows.right_color.a
    arrows.left_manual.a = lp.m_bIsScoped and math.floor(lerp(arrows.left_manual.a, 0, 15)) or arrows.left_manual.a
    arrows.right_manual.a = lp.m_bIsScoped and math.floor(lerp(arrows.right_manual.a, 0, 15)) or arrows.right_manual.a
    arrows.desync = lerp(arrows.desync, visuals.desync_range, 15)
    local desync = 30 + arrows.desync / 2
    render.text(fonts.modern_arrows, vector(screensizex / 2 - desync, screensizey / 2), arrows.left_color, "c", ui.get_icon("chevron-left"))
    render.text(fonts.modern_arrows, vector(screensizex / 2 + desync, screensizey / 2), arrows.right_color, "c", ui.get_icon("chevron-right"))
    render.text(fonts.modern_arrows, vector(screensizex / 2 - desync - 5, screensizey / 2), arrows.left_manual, "c", ui.get_icon("chevron-left"))
    render.text(fonts.modern_arrows, vector(screensizex / 2 + desync + 5, screensizey / 2), arrows.right_manual, "c", ui.get_icon("chevron-right"))
    --render.poly(arrows.left_manual, vector(screensizex / 2 - 37, screensizey / 2), vector(screensizex / 2 - 26, screensizey / 2 - 5), vector(screensizex / 2 - 26, screensizey / 2 + 6)) -- left
    --render.rect(vector(screensizex / 2 - 25, screensizey / 2 - 5), vector(screensizex / 2 - 24, screensizey / 2 + 6), arrows.left_color)
    --render.rect(vector(screensizex / 2 + 25, screensizey / 2 - 6), vector(screensizex / 2 + 26, screensizey / 2 + 5), arrows.right_color)
    --render.poly(arrows.right_manual, vector(screensizex / 2 + 38, screensizey / 2), vector(screensizex / 2 + 27, screensizey / 2 + 5), vector(screensizex / 2 + 27, screensizey / 2 - 6))
end

local function rotate_point(x, y, rot, size)
    return math.cos(math.rad(rot)) * size + x, math.sin(math.rad(rot)) * size + y
end

local function renderer_arrow(x, y, r, g, b, a, rotation, size)
    local x0, y0 = rotate_point(x, y, rotation, 45)
    local x1, y1 = rotate_point(x, y, rotation + (size / 3.5), 45 - (size / 4))
    local x2, y2 = rotate_point(x, y, rotation - (size / 3.5), 45 - (size / 4))
    render.poly(color(r, g, b, a), vector(x0, y0), vector(x1, y1), vector(x2, y2))
end

arrows.tsa = 0

visuals.draw_ts_arrows = function()
    if (visuals.arrows:get() ~= "TS") and (visuals.arrows:get() ~= "TS Dynamic") then return end
    local lp = entity.get_local_player()
    if not lp then return end
    if (lp.m_iHealth <= 0) then return end
    local cam = render.camera_angles()
    local cx, cy = screensizex / 2, screensizey / 2 - 2

    local h = lp:get_hitbox_position(0)
    local p = lp:get_hitbox_position(2)

    local yaw = math.normalize(math.calc_angle(p.x, p.y, h.x, h.y) - cam.y + 120)
    local bodyyaw = lp.m_flPoseParameter[11] * 120 - 60

    local fakeangle = math.normalize(yaw + bodyyaw)
    local r, g, b, a = visuals.arrows_col:get():unpack()
    local r1, g1, b1, a1 = visuals.arrows_col_2:get():unpack()
    arrows.tsa = lerp(arrows.tsa, lp.m_bIsScoped and 0 or 1, 15)
    a = a * arrows.tsa
    a1 = a1 * arrows.tsa
    local inactivea = 150 * arrows.tsa
    if visuals.arrows:get() == "TS Dynamic" then
        renderer_arrow(cx, cy, r, g, b, a, (yaw - 25) * -1, 45)
        renderer_arrow(cx, cy, r1, g1, b1, a1, (fakeangle - 25) * -1, 25)
    else
        render.poly(color(
        aa.right:get() and r1 or 35, 
        aa.right:get() and g1 or 35, 
        aa.right:get() and b1 or 35, 
        aa.right:get() and a1 or inactivea), vector(cx + 55, cy + 2), vector(cx + 42, cy - 7), vector(cx + 42, cy + 11))

        render.poly(color(
        aa.left:get() and r1 or 35, 
        aa.left:get() and g1 or 35, 
        aa.left:get() and b1 or 35, 
        aa.left:get() and a1 or inactivea), vector(cx - 55, cy + 2), vector(cx - 42, cy - 7), vector(cx - 42, cy + 11))
        
        render.rect(vector(cx + 38, cy - 7), vector(cx + 40, cy + 11), color(
        bodyyaw < -10 and r or 35,
        bodyyaw < -10 and g or 35,
        bodyyaw < -10 and b or 35,
        bodyyaw < -10 and a or inactivea))
        render.rect(vector(cx - 40, cy - 7), vector(cx - 38, cy + 11), color(
        bodyyaw > 10 and r or 35,
        bodyyaw > 10 and g or 35,
        bodyyaw > 10 and b or 35,
        bodyyaw > 10 and a or inactivea))
    end
end

events.render:set(visuals.draw_simple_arrows)
events.render:set(visuals.draw_simple_arrows_alt)
events.render:set(visuals.draw_modern_arrows)
events.render:set(visuals.draw_ts_arrows)

visuals.draw_info_bar = function()

    infobar.animate = lerp(infobar.animate, visuals.infobar:get() ~= "Disabled" and 1 or 0, 10)

    if not (infobar.animate * 255 > 0.1) then return end

    if not globals.is_in_game then return end

    local lp = entity.get_local_player()
    if lp == nil then return end
    
    local kolor = visuals.infobar_color:get()
    kolor.a = math.floor(255 * infobar.animate)
    local PosX1 = screensizex
    local PosY1 = screensizey
    local user = common.get_username()
    local net = utils.net_channel()
    local ping1 = tostring(math.floor(net.avg_latency[1] * 1000))
    local tickrate1 = math.floor(1.0 / globals.tickinterval)
    local fps1 = math.floor(1 / globals.frametime)
    if globals.tickcount % tickrate1 == 0 then
        infobar.fps = fps1
    end
    --local velocity = local_player:get_velocity()
    --local total_velocity = velocity:length_2d()
    local velocity = (lp.m_iHealth > 0) and math.sqrt( math.pow( lp.m_vecVelocity.x, 2 ) + math.pow( lp.m_vecVelocity.y, 2 ) ) or 0
    local total_velocity = velocity
    local velocity_text = tostring("" .. math.floor(total_velocity) .. "")
    local pingpos = render.measure_text( infobar.infobarf, "nil", ""..".00".."" ).x - render.measure_text( infobar.infobarf, "nil", ""..ping1.."" ).x
    --local pingpos = 0
    local fpspos = render.measure_text( infobar.infobarf, "nil", "".."000".."" ).x - render.measure_text( infobar.infobarf, "nil", ""..infobar.fps.."" ).x
    local velocitypos = render.measure_text( infobar.infobarf, "nil", "".."000".."" ).x - render.measure_text( infobar.infobarf, "nil", velocity_text ).x
    if infobar.fps > 60 then
        infobar.fpscolor = kolor
    elseif infobar.fps > 30 then
        infobar.fpscolor = color(255, 150, 0, math.floor(255 * infobar.animate))
    else
        infobar.fpscolor = color(255, 0, 0, math.floor(255 * infobar.animate))
    end
    --local ping_r = math.floor(180 + ping1 / 189 * 30 * 3.42105263158)
    --local ping_g = math.floor(255 - ping1 / 189 * 60 * 2.29824561404)
    --local ping_b = math.floor(ping1 / 189 * 60 * 0.22807017543)
    local ping_r = math.floor(lerp2(kolor.r, 255, ping1 / 125))
    local ping_g = math.floor(lerp2(kolor.g, 0,   ping1 / 125))
    local ping_b = math.floor(lerp2(kolor.b, 0,   ping1 / 125))
    local ping_a = math.floor(255 * infobar.animate)
    if ping_r < 256 and ping_g < 256 and ping_b < 256 then
        pingcolor = color(ping_r, ping_g, ping_b, ping_a)
    else pingcolor = color(255, 0, 0, math.floor(255 * infobar.animate)) end

    if visuals.infobar:get() == "Themed" then
        PosY1 = PosY1 - 5
        if visuals.cur_theme ~= "Modern " then
            visuals.draw_custom_box(vector(PosX1 /2 -220, PosY1 - 27), vector(440, 27), kolor.a, 27)
            render.text(infobar.infobarf, vector(PosX1 /2 -83 + fpspos, PosY1 - 21), infobar.fpscolor, nil, ""..infobar.fps.."")
            render.text(infobar.infobarftext, vector(PosX1 /2 -62 + infobar.pad, PosY1 - 20),  color(255,255,255, math.floor(255 * infobar.animate)), "nil", "  FPS" )
            render.text(infobar.infobarf,vector(PosX1 /2 -203 + pingpos, PosY1 - 21), pingcolor, "nil", ""..ping1.."" )
            render.text(infobar.infobarftext, vector(PosX1 /2 -186 + infobar.pad, PosY1 - 20), color(255,255,255, math.floor(255 * infobar.animate)) , "nil", "  PING" )
            render.text(infobar.infobarf, vector(PosX1 /2 + 41, PosY1 - 21), kolor, "nil", ""..tickrate1.."" )
            render.text(infobar.infobarftext, vector(PosX1 /2 + 57 + infobar.pad, PosY1 - 20), color(255,255,255, math.floor(255 * infobar.animate)), "nil", "  TICK" )
            render.text(infobar.infobarf, vector(PosX1 /2 + 146 + velocitypos, PosY1 - 21), kolor, "nil", velocity_text )
            render.text(infobar.infobarftext, vector(PosX1 /2 + 167 + infobar.pad, PosY1 - 20), color(255,255,255, math.floor(255 * infobar.animate)), "nil", "  SPEED" )
        else
            visuals.draw_custom_box(vector(PosX1 /2 -220, PosY1 - 30), vector(440, 30), kolor.a, 30)
            local text_color = color(45, 45, 45, math.floor(255 * infobar.animate))
            if infobar.fps > 60 then infobar.fpscolor = text_color else infobar.fpscolor = darken(infobar.fpscolor, 45) end
            PosX1 = PosX1 * 0.5 - 8
            render.text(fonts.modern, vector(PosX1 -83 + fpspos, PosY1 - 21), text_color, nil, ""..infobar.fps.."")
            render.text(fonts.modern, vector(PosX1 -62 + infobar.pad, PosY1 - 21),  text_color, "nil", "  FPS" )
            render.text(fonts.modern, vector(PosX1 -203 + pingpos + 2, PosY1 - 21), text_color, "nil", ""..ping1.."" )
            render.text(fonts.modern, vector(PosX1 -186 + infobar.pad + 2, PosY1 - 21), text_color , "nil", "  PING" )
            render.text(fonts.modern, vector(PosX1 + 41, PosY1 - 21), text_color, "nil", ""..tickrate1.."" )
            render.text(fonts.modern, vector(PosX1 + 57 + infobar.pad, PosY1 - 21), text_color, "nil", "  TICK" )
            render.text(fonts.modern, vector(PosX1 + 146 + velocitypos, PosY1 - 21), text_color, "nil", velocity_text )
            render.text(fonts.modern, vector(PosX1 + 167 + infobar.pad, PosY1 - 21), text_color, "nil", "  SPEED" )
        end
    elseif visuals.infobar:get() == "Classic" then
        render.gradient(vector(PosX1 /2 -370, PosY1 - 27), vector(PosX1 /2, PosY1), color(0, 0, 0, 0), color(0, 0, 0, math.floor(65 * infobar.animate)--[[color(25, 25, 25, math.floor(100 * infobar.animate)]]), color(0, 0, 0, 0), color(0, 0, 0, math.floor(65 * infobar.animate)))
        render.gradient(vector(PosX1 /2,      PosY1 - 27), vector(PosX1 /2 + 370, PosY1), color(0, 0, 0, math.floor(65 * infobar.animate)), color(0, 0, 0, 0), color(0, 0, 0, math.floor(65 * infobar.animate)), color(0, 0, 0, 0))
        render.text(infobar.infobarf, vector(PosX1 /2 -83 + fpspos, PosY1 - 21), infobar.fpscolor, nil, ""..infobar.fps.."")
        render.text(infobar.infobarftext, vector(PosX1 /2 -62 + infobar.pad, PosY1 - 20),  color(255,255,255, math.floor(255 * infobar.animate)), "nil", "  FPS" )
        render.text(infobar.infobarf,vector(PosX1 /2 -203 + pingpos, PosY1 - 21), pingcolor, "nil", ""..ping1.."" )
        render.text(infobar.infobarftext, vector(PosX1 /2 -186 + infobar.pad, PosY1 - 20), color(255,255,255, math.floor(255 * infobar.animate)) , "nil", "  PING" )
        render.text(infobar.infobarf, vector(PosX1 /2 + 41, PosY1 - 21), kolor, "nil", ""..tickrate1.."" )
        render.text(infobar.infobarftext, vector(PosX1 /2 + 57 + infobar.pad, PosY1 - 20), color(255,255,255, math.floor(255 * infobar.animate)), "nil", "  TICK" )
        render.text(infobar.infobarf, vector(PosX1 /2 + 146 + velocitypos, PosY1 - 21), kolor, "nil", velocity_text )
        render.text(infobar.infobarftext, vector(PosX1 /2 + 167 + infobar.pad, PosY1 - 20), color(255,255,255, math.floor(255 * infobar.animate)), "nil", "  SPEED" )
    end

end

events.render:set(visuals.draw_info_bar)

keybinds = {}

keybinds.count = 0
keybinds.width = 100
keybinds.maxwidth = 0
keybinds.alpha = 0
keybinds.drag_alpha = 0
keybinds.pos = {
    x = 215,
    y = 325,
    x_slider = vs_debug:slider_e("Keybinds X", 0, render.screen_size().x, 215),
    y_slider = vs_debug:slider_e("Keybinds Y", 0, render.screen_size().y, 315),
    move_x = 0,
    move_y = 0,
    unlocked = 0,
    received = 0,
}
keybinds.pos.x_slider:visibility(false)
keybinds.pos.y_slider:visibility(false)

keybinds.pos.x = keybinds.pos.x_slider:get()
keybinds.pos.y = keybinds.pos.y_slider:get()

keybinds.modes = {"hold", "toggled"}
--keybinds.modes_m = {"» hold", "» toggled"}

keybinds.padding = 0

keybinds.list = {}

--visuals.draw_keybinds = function()
--
--    --keybinds.list[5].ref = refs.override
--
--    if keybinds.pos.unlocked == 0 then
--        keybinds.pos.x = keybinds.pos.x_slider:get()
--        keybinds.pos.y = keybinds.pos.y_slider:get()
--    end
--
--    keybinds.padding = (visuals.theme:get() == "Default" or visuals.theme:get() == "Retro") and 2 or 0
--
--    if keybinds.alpha > 0.1 then
--
--        local kolor = color(visuals.themecol:get().r, visuals.themecol:get().g, visuals.themecol:get().b, math.floor(visuals.themecol:get().a * keybinds.alpha))
--        local light = lighten(kolor, 45)
--        local text_color = visuals.theme:get() == "Default" and color(light.r, light.g, light.b, math.floor(255 * keybinds.alpha)) or color(255, 255, 255, math.floor(255 * keybinds.alpha))
--        keybinds.maxwidth = visuals.theme:get() == "Retro" and 170 or 160
--        keybinds.width = lerp(keybinds.width, keybinds.maxwidth, 15)
--        local squarepad = (visuals.solus_thickness:get() ~= 0) and 1 or 0
--
--        if visuals.theme:get() == 1 then
--            --local Material = FindMaterial(Materials[1], 'Other textures')
--            --Render.MaterialRect(keybinds.pos.x, keybinds.pos.y, keybinds.width, 32 + 14 * keybinds.count, Material)
--            --render.rect_filled( vector(keybinds.pos.x, keybinds.pos.y + 24), vector(keybinds.width, 8 + 14 * keybinds.count), color(20, 20, 20, math.floor(visuals.themecol:get().a * keybinds.alpha)) )
--            visuals.draw_custom_box(vector(keybinds.pos.x, keybinds.pos.y), vector(keybinds.width, 24), math.floor(255 * keybinds.alpha), 34 + 14 * keybinds.count)
--        elseif visuals.theme:get() == 4 then
--            --render.rect_filled( vector(keybinds.pos.x + 1 - squarepad, keybinds.pos.y + 24 - 1), vector(keybinds.width - 2 + squarepad * 2, 8 + 14 * keybinds.count + 2 * squarepad), color(20, 20, 20, math.floor(visuals.themecol:get().a * keybinds.alpha)) )
--            visuals.draw_custom_box(vector(keybinds.pos.x, keybinds.pos.y), vector(keybinds.width, 24), math.floor(255 * keybinds.alpha), 24)
--        else
--            visuals.draw_custom_box(vector(keybinds.pos.x, keybinds.pos.y), vector(keybinds.width, 24), math.floor(255 * keybinds.alpha), 24)
--        end
--        render.text(fonts.default_font, vector(keybinds.pos.x + keybinds.width / 2, keybinds.pos.y + (visuals.theme:get() == "Retro" and 13 or 12)), text_color, "c", "keybinds")
--
--    end
--
--    keybinds.count = 0
--
--    if keybinds.drag_alpha > 0.1 then
--        render.rect(vector(keybinds.pos.x - 4, keybinds.pos.y - 4), vector(keybinds.width + 8, 32), color(255, 255, 255, math.floor(255 * keybinds.drag_alpha)))
--        render.text(fonts.default_font, vector(keybinds.pos.x + keybinds.width / 2 + 4, keybinds.pos.y - 13), color(255, 255, 255, math.floor(255 * keybinds.drag_alpha)), "c", "hold to drag")
--    end
--
--    local momma = ui.get_binds()
--
--    local toolvar = 0
--
--    for i = 1, #momma do
--        render.text(fonts.default_font, vector(1000, 1000 + 12 * toolvar), color(255, 255, 255), nil, momma[i].name..' '..tostring(momma[i].active))
--        toolvar = toolvar + 1
--    end
--
--    toolvar = 0
--
--    --if #keybinds.list > #momma then table.remove(keybinds.list) end
--
--    for i = 1, #keybinds.list do
--        render.text(fonts.default_font, vector(1200, 1000 + 12 * toolvar), color(255, 255, 255), nil, keybinds.list[i].name..' '..tostring(keybinds.list[i].active)..' '..keybinds.list[i].anim)
--        toolvar = toolvar + 1
--    end
--
--    for i = 1, #momma do
--        --if keybinds.list[i] == nil then table.insert(keybinds.list, i, {name = momma[i].name, mode = momma[i].mode, active = momma[i].active, anim = 0}) end
--        --print(momma[i].name..' '..keybinds.list[i].name..'\n')
--        if keybinds.list[i] == nil then keybinds.list[i] = {name = momma[i].name, mode = momma[i].mode, active = momma[i].active, anim = 0} end
--        keybinds.list[i].name = momma[i].name
--        keybinds.list[i].mode = momma[i].mode
--        keybinds.list[i].active = momma[i].active
--        --keybinds.list[i].anim = lerp(keybinds.list[i].anim, keybinds.list[i].active and 1 or 0, 10)
--        if (keybinds.list[i].anim <= 0.5 and not keybinds.list[i].active) then table.remove(keybinds.list, i) end
--    end
--
--    for i = 1, #keybinds.list do
--        --if keybinds.list[i] == nil then goto bindskip end
--        keybinds.list[i].anim = lerp(keybinds.list[i].anim, keybinds.list[i].active and 1 or 0, 1)
--        render.text(fonts.default_font, vector(keybinds.pos.x + 6, keybinds.pos.y + keybinds.padding + 27 + 14 * keybinds.count), color(255, 255, 255, math.floor(255 * keybinds.alpha * keybinds.list[i].anim)), "nil", keybinds.list[i].name)
--        local mode_text = keybinds.modes[keybinds.list[i].mode]
--        render.text(fonts.default_font, vector(keybinds.pos.x + keybinds.width - render.measure_text(fonts.default_font, "nil", mode_text).x - 6, keybinds.pos.y + keybinds.padding + 27 + 14 * keybinds.count), color(255, 255, 255, math.floor(255 * keybinds.alpha * keybinds.list[i].anim)), "nil", mode_text)
--        keybinds.count = keybinds.count + keybinds.list[i].anim
--        --::bindskip::
--    end
--        --[[if keybinds.list[i].ref[2]:get() or (keybinds.list[i].name == "yaw base" and antiaim.get_manual_override() ~= 0) then
--            keybinds.list[i].anim = lerp(keybinds.list[i].anim, 1, 15)
--        else
--            keybinds.list[i].anim = lerp(keybinds.list[i].anim, 0, 15)
--        end
--        if keybinds.list[i].anim > 0.1 then
--            local color = lighten(visuals.themecol:get(), 45)
--            local bind_color = visuals.theme:get() == 1 and color(color.r, color.g, color.b, math.floor(255 * keybinds.alpha * keybinds.list[i].anim)) or color(255, 255, 255, math.floor(255 * keybinds.alpha * keybinds.list[i].anim))
--            render.text(fonts.default_font, keybinds.list[i].name, vector(keybinds.pos.x + 6, keybinds.pos.y + keybinds.padding + 27 + 14 * keybinds.count), bind_color)
--            local mode_text = keybinds.list[i].name == "yaw base" and keybinds.modes[antiaim.get_manual_override() + 5] or keybinds.modes[keybinds.list[i].ref[2]:get_mode() + 1]
--            render.text(fonts.default_font, mode_text, vector(keybinds.pos.x + keybinds.width - render.measure_text(fonts.default_font, mode_text).x - 6, keybinds.pos.y + keybinds.padding + 27 + 14 * keybinds.count), bind_color)
--            keybinds.count = keybinds.count + keybinds.list[i].anim
--        end
--    end]]
--
--    if visuals.keybinds:get() and ((keybinds.count > 0 and globals.is_in_game)) then
--        keybinds.alpha = lerp(keybinds.alpha, 1, 15)
--    elseif visuals.keybinds:get() then
--        --keybinds.alpha = lerp(keybinds.alpha, 0, 15)
--        keybinds.alpha = lerp(keybinds.alpha, ui.get_alpha(), 15)
--    end
--
--    --[[if visuals.keybinds:get() and ui.get_alpha() > 0 and input.is_mouse_in_bounds(vector(keybinds.pos.x - 3, keybinds.pos.y - 3), vector(keybinds.width + 8, 32)) then
--        keybinds.drag_alpha = lerp(keybinds.drag_alpha, 1, 15)
--    else
--        keybinds.drag_alpha = lerp(keybinds.drag_alpha, 0, 15)
--    end]]
--
--    --keybinds.drag()
--
--end

local binds = {}

--[[
    Position structure:
    pos.x,
    pos.y,
    pos.move_x,
    pos.move_y,
    pos.x_slider,
    pos.y_slider,
    pos.received,
    pos.unlocked,

    example:
    {
        x = keybinds.pos.x - 3,
        y = keybinds.pos.y - 3,
        move_x = keybinds.pos.move_x,
        move_y = keybinds.pos.move_y,
        x_slider = keybinds.pos.x_slider,
        y_slider = keybinds.pos.x_slider,
        received = keybinds.pos.received,
        unlocked = keybinds.pos.unlocked,
    }
]]

--[[keybinds.drag = function()
    local cursor_x = ui.get_mouse_position().x
    local cursor_y = ui.get_mouse_position().y
    if common.is_button_down(0x01) then
        if is_mouse_in_bounds(keybinds.pos.x - 3, keybinds.pos.y - 3, keybinds.width + 8, 32) and keybinds.pos.received == 0 then
            keybinds.pos.unlocked = 1
            keybinds.pos.move_x = keybinds.pos.x - cursor_x
            keybinds.pos.move_y = keybinds.pos.y - cursor_y
            keybinds.pos.received = 1
        end
    else
        keybinds.pos.received = 0
        keybinds.pos.unlocked = 0
    end
    if keybinds.pos.unlocked == 1 then
        --render.text(fonts.default_font, "dragging", vector(keybinds.pos.x + keybinds.width / 2 + 4, keybinds.pos.y - 27), color(255, 255, 255, math.floor(keybinds.drag_alpha)), true)
        keybinds.pos.x = cursor_x + keybinds.pos.move_x
        keybinds.pos.y = cursor_y + keybinds.pos.move_y
    end
    if common.is_button_released(0x01) and is_mouse_in_bounds(keybinds.pos.x - 3, keybinds.pos.y - 3, keybinds.width + 8, 32) then
        keybinds.pos.x_slider:set(keybinds.pos.x)
        keybinds.pos.y_slider:set(keybinds.pos.y)
    end
end]]

function maxbind(t)
    if #t == 0 then return nil end
    local name = (t[1].name == "Left" or t[1].name == "Back" or t[1].name == "Right") and "Manual Yaw Base" or t[1].name
    local value = render.measure_text(fonts.default_font, nil, name).x
    for i = 2, #t do
        local name = (t[i].name == "Left" or t[i].name == "Back" or t[i].name == "Right") and "Manual Yaw Base" or t[i].name
        if value < render.measure_text(fonts.default_font, nil, name).x then
            value = render.measure_text(fonts.default_font, nil, name).x
        end
    end
    return value
end

visuals.draw_edgy_line = function(pos, width, alpha, height)
    local height = height and height or 2
    local vertices = {}
	local number = 6
	vertices[1] = vector(pos.x, pos.y + height)
	for i=2, number do
		vertices[i] = vector(pos.x + width / number * (i - 1), pos.y + height - height * 2 * (1 - i%2))
	end
	vertices[number+1] = vector(pos.x + width, pos.y + height)
	render.poly_line(color(255, 255, 255, alpha), unpack(vertices))
end

visuals.draw_keybinds = function()

    --keybinds.list[5].ref = refs.override

    --[[if keybinds.pos.unlocked == 0 then
        keybinds.pos.x = keybinds.pos.x_slider:get()
        keybinds.pos.y = keybinds.pos.y_slider:get()
    end]]

    keybinds.padding = (visuals.cur_theme == "Modern ") and 4 or (visuals.cur_theme == "Alpha " or visuals.cur_theme == "Retro" or visuals.cur_theme == "Vamp ") and 2 or 0

    local kolor = color(visuals.themecol:get().r, visuals.themecol:get().g, visuals.themecol:get().b, math.floor(visuals.themecol:get().a * keybinds.alpha))
    local light = lighten(kolor, 50)

    if keybinds.alpha > 0.1 then

        local header_alpha = visuals.keybinds_header:get() and 1 or ui.get_alpha()
        local text_color = visuals.cur_theme == "Modern " and color(45, 45, 45, math.floor(255 * keybinds.alpha * header_alpha)) or visuals.cur_theme == "Alpha " and color(light.r, light.g, light.b, math.floor(255 * keybinds.alpha * header_alpha)) or color(255, 255, 255, math.floor(255 * keybinds.alpha * header_alpha))
        --keybinds.maxwidth = visuals.theme:get() == "Retro" and 170 or 160
        --keybinds.width = lerp(keybinds.width, visuals.keybinds:get() and keybinds.maxwidth or 100, 15)
        local squarepad = (visuals.solus_thickness:get() ~= 0) and 1 or 0

        if (header_alpha > 0) then
            if visuals.cur_theme == "Alpha " then
                --local Material = FindMaterial(Materials[1], 'Other textures')
                --Render.MaterialRect(keybinds.pos.x, keybinds.pos.y, keybinds.width, 32 + 14 * keybinds.count, Material)
                --render.rect_filled( vector(keybinds.pos.x, keybinds.pos.y + 24), vector(keybinds.width, 8 + 14 * keybinds.count), color(20, 20, 20, math.floor(visuals.themecol:get().a * keybinds.alpha)) )
                visuals.draw_custom_box(vector(keybinds.pos.x, keybinds.pos.y), vector(keybinds.width, 24), math.floor(255 * keybinds.alpha * header_alpha), 34 + 14 * keybinds.count)
            elseif visuals.cur_theme == "Modern " then
                visuals.draw_custom_box(vector(keybinds.pos.x, keybinds.pos.y - 3), vector(keybinds.width, 30), math.floor(255 * keybinds.alpha * header_alpha), 41 + 14 * keybinds.count)
            elseif visuals.cur_theme == "Retro" then
                --render.rect_filled( vector(keybinds.pos.x + 1 - squarepad, keybinds.pos.y + 24 - 1), vector(keybinds.width - 2 + squarepad * 2, 8 + 14 * keybinds.count + 2 * squarepad), color(20, 20, 20, math.floor(visuals.themecol:get().a * keybinds.alpha)) )
                visuals.draw_custom_box(vector(keybinds.pos.x, keybinds.pos.y), vector(keybinds.width, 24), math.floor(255 * keybinds.alpha * header_alpha), 24)
            elseif visuals.cur_theme == "Vamp " then
                visuals.draw_edgy_line(vector(keybinds.pos.x + 6, keybinds.pos.y + 24), keybinds.width - 18, math.floor(255 * keybinds.alpha * header_alpha))
            elseif visuals.cur_theme == "Default " then
                visuals.draw_custom_box(vector(keybinds.pos.x, keybinds.pos.y), vector(keybinds.width, 24), math.floor(255 * keybinds.alpha * header_alpha), 30 + 14 * keybinds.count)
            else
                visuals.draw_custom_box(vector(keybinds.pos.x, keybinds.pos.y), vector(keybinds.width, 24), math.floor(255 * keybinds.alpha * header_alpha), 24)
            end
            local header_text = visuals.theme:get() == "Solus v2" and "keybinds" or "Keybinds"
            render.text(fonts.header_font, vector(keybinds.pos.x + keybinds.width / 2, keybinds.pos.y + 12 + visuals.font_pad), text_color, "c", header_text)
        end

    end

    keybinds.count = 0

    if keybinds.drag_alpha > 0.1 then
        render.rect_outline(vector(keybinds.pos.x - 4, keybinds.pos.y - 4), vector(keybinds.pos.x + keybinds.width + 4, keybinds.pos.y + 28), color(255, 255, 255, math.floor(255 * keybinds.drag_alpha)), 1, visuals.cur_theme == "Retro" and 0 or 6)
        render.text(fonts.default_font, vector(keybinds.pos.x + keybinds.width / 2 + 4, keybinds.pos.y - 13), color(255, 255, 255, math.floor(255 * keybinds.drag_alpha)), "c", "hold to drag")
    end

    local binds = ui.get_binds()
    keybinds.maxwidth = (#binds > 0) and maxbind(binds) or 0
    keybinds.maxwidth = keybinds.maxwidth + 100
    keybinds.width = lerp2(keybinds.width, keybinds.maxwidth, 15 * globals.frametime)
    keybinds.width = math.max(keybinds.width, 150)

    for i = 1, #binds do
        local bind = binds[i]
        if not keybinds.list[bind.name] then 
            keybinds.list[bind.name] = 0
        end
        keybinds.list[bind.name] = lerp(keybinds.list[bind.name], (bind.active and visuals.keybinds:get()) and 1 or 0, 10)
            
        if keybinds.list[bind.name] <0.01 then goto bindskip end

        local bind_color = (visuals.cur_theme == "Alpha " or visuals.cur_theme == "Modern ") and color(light.r, light.g, light.b, math.floor(255 * keybinds.alpha * keybinds.list[bind.name])) or color(255, 255, 255, math.floor(255 * keybinds.alpha * keybinds.list[bind.name]))
        local bind_text = (bind.name == "Left" or bind.name == "Back" or bind.name == "Right") and "Manual Yaw Base" or bind.name
        bind_text = string.lower(bind_text)
        bind_text = bind_text:sub(1, 1):upper()..bind_text:sub(2)
        
        render.text(fonts.default_font, vector(keybinds.pos.x + 6, keybinds.pos.y + keybinds.padding + 27 + 14 * keybinds.count), bind_color, "nil", bind_text)
        local l = (visuals.cur_theme == "Default " or visuals.cur_theme == "Alpha " or visuals.cur_theme == "Modern ") and "» " or "["
        local r = (visuals.cur_theme == "Default " or visuals.cur_theme == "Alpha " or visuals.cur_theme == "Modern ") and "" or "]"
        local mode_text = bind.reference:type() == "slider" and bind.value or bind_text == "Manual Yaw Base" and string.lower(bind.name) or keybinds.modes[bind.mode]
        local mode_text = l..mode_text..r
        render.text(fonts.default_font, vector(keybinds.pos.x + keybinds.width - render.measure_text(fonts.default_font, "nil", mode_text).x - 6, keybinds.pos.y + keybinds.padding + 27 + 14 * keybinds.count), bind_color, "nil", mode_text)
        keybinds.count = keybinds.count + keybinds.list[bind.name]

        ::bindskip::
    end

    if visuals.keybinds:get() and ((keybinds.count > 0 and globals.is_in_game)) then
        keybinds.alpha = lerp(keybinds.alpha, 1, 15)
    elseif visuals.keybinds:get() then
        keybinds.alpha = lerp(keybinds.alpha, ui.get_alpha(), 15)
    else
        keybinds.alpha = lerp(keybinds.alpha, 0, 15)
    end

    if visuals.keybinds:get() and (ui.get_alpha() > 0) and (keybinds.alpha>0) and is_mouse_in_bounds(keybinds.pos.x - 3, keybinds.pos.y - 3, keybinds.width + 8, 32) then
        keybinds.drag_alpha = lerp(keybinds.drag_alpha, 1, 15)
    else
        keybinds.drag_alpha = lerp(keybinds.drag_alpha, 0, 15)
    end

    --keybinds.drag()
    drag(keybinds.pos, vector(keybinds.width + 8, 32))

end

events.render:set(visuals.draw_keybinds)

spectators = {}

spectators.count = 0
spectators.width = 150
spectators.maxwidth = 0
spectators.alpha = 0
spectators.drag_alpha = 0
spectators.pos = {
    x = 515,
    y = 325,
    x_slider = vs_debug:slider_e("Spectators X", 0, render.screen_size().x, 515),
    y_slider = vs_debug:slider_e("Spectators Y", 0, render.screen_size().y, 315),
    move_x = 0,
    move_y = 0,
    unlocked = 0,
    received = 0,
}
spectators.pos.x_slider:visibility(false)
spectators.pos.y_slider:visibility(false)

spectators.pos.x = spectators.pos.x_slider:get()
spectators.pos.y = spectators.pos.y_slider:get()

spectators.padding = 0
spectators.avapad = 0

spectators.list = {}
specs = {}

local limit_text = function(text, size, font)
    local txtsize = render.measure_text(font, nil, text).x
    if txtsize <= size then return text end
    for i=string.len(text), 1, -1 do
        local subtext = string.sub(text, 1, i).."..."
        if render.measure_text(font, nil, subtext).x <= size then return subtext end
    end
end

visuals.draw_spectators = function()

    --spectators.list[5].ref = refs.override

    --[[if spectators.pos.unlocked == 0 then
        spectators.pos.x = spectators.pos.x_slider:get()
        spectators.pos.y = spectators.pos.y_slider:get()
    end]]

    --spectators.padding = visuals.theme:get() == "Modern " and 4 or (visuals.theme:get() == "Default" or visuals.theme:get() == "Retro") and 4 or 4
    spectators.padding = 4

    local kolor = color(visuals.themecol:get().r, visuals.themecol:get().g, visuals.themecol:get().b, math.floor(visuals.themecol:get().a * spectators.alpha))
    local light = lighten(kolor, 50)

    if spectators.alpha > 0.1 then

        local header_alpha = visuals.spec_header:get() and 1 or ui.get_alpha()
        local text_color = visuals.cur_theme == "Modern " and color(45, 45, 45, math.floor(255 * spectators.alpha * header_alpha)) or visuals.cur_theme == "Alpha " and color(light.r, light.g, light.b, math.floor(255 * spectators.alpha * header_alpha)) or color(255, 255, 255, math.floor(255 * spectators.alpha * header_alpha))
        --spectators.maxwidth = visuals.theme:get() == "Retro" and 170 or 160
        --spectators.width = lerp(spectators.width, visuals.spectators:get() and spectators.maxwidth or 100, 15)
        local squarepad = (visuals.solus_thickness:get() ~= 0) and 1 or 0

        if (header_alpha > 0) then
            if visuals.cur_theme == "Alpha " then
                --local Material = FindMaterial(Materials[1], 'Other textures')
                --Render.MaterialRect(spectators.pos.x, spectators.pos.y, spectators.width, 32 + 14 * spectators.count, Material)
                --render.rect_filled( vector(spectators.pos.x, spectators.pos.y + 24), vector(spectators.width, 8 + 14 * spectators.count), color(20, 20, 20, math.floor(visuals.themecol:get().a * spectators.alpha)) )
                visuals.draw_custom_box(vector(spectators.pos.x, spectators.pos.y), vector(spectators.width, 24), math.floor(255 * spectators.alpha * header_alpha), 26 + 22 * spectators.count)
            elseif visuals.cur_theme == "Default " then
                visuals.draw_custom_box(vector(spectators.pos.x, spectators.pos.y), vector(spectators.width, 24), math.floor(255 * spectators.alpha * header_alpha), 30 + 22 * spectators.count)
            elseif visuals.cur_theme == "Modern " then
                visuals.draw_custom_box(vector(spectators.pos.x, spectators.pos.y - 3), vector(spectators.width, 30), math.floor(255 * spectators.alpha * header_alpha), 33 + 22 * spectators.count)
            elseif visuals.cur_theme == "Retro" then
                --render.rect_filled( vector(spectators.pos.x + 1 - squarepad, spectators.pos.y + 24 - 1), vector(spectators.width - 2 + squarepad * 2, 8 + 14 * spectators.count + 2 * squarepad), color(20, 20, 20, math.floor(visuals.themecol:get().a * spectators.alpha)) )
                visuals.draw_custom_box(vector(spectators.pos.x, spectators.pos.y), vector(spectators.width, 24), math.floor(255 * spectators.alpha * header_alpha), 24)
            elseif visuals.cur_theme == "Vamp " then
                visuals.draw_edgy_line(vector(spectators.pos.x + 6, spectators.pos.y + 24), spectators.width - 12, math.floor(255 * spectators.alpha * header_alpha))
            else
                visuals.draw_custom_box(vector(spectators.pos.x, spectators.pos.y), vector(spectators.width, 24), math.floor(255 * spectators.alpha * header_alpha), 24)
            end
            local header_text = visuals.theme:get() == "Solus v2" and "spectators" or "Spectators"
            render.text(fonts.header_font, vector(spectators.pos.x + spectators.width / 2, spectators.pos.y + 12 + visuals.font_pad), text_color, "c", header_text)
        end
    end

    spectators.count = 0

    if spectators.drag_alpha > 0.1 then
        render.rect_outline(vector(spectators.pos.x - 4, spectators.pos.y - 4), vector(spectators.pos.x + spectators.width + 4, spectators.pos.y + 28), color(255, 255, 255, math.floor(255 * spectators.drag_alpha)), 1, visuals.cur_theme == "Retro" and 0 or 6)
        render.text(fonts.default_font, vector(spectators.pos.x + spectators.width / 2 + 4, spectators.pos.y - 13), color(255, 255, 255, math.floor(255 * spectators.drag_alpha)), "c", "hold to drag")
    end

    --local lp = entity.get(entity.get_local_player().m_hObserverTarget)
    local specs = {}
    local lp = entity.get_local_player()
    if not lp then goto skip end
    --[[local ent = entity.get_local_player()
    if ent then 
        if ent.m_iHealth < 1 then
            ent = ent.m_hObserverTarget
        end
        if ent then
            specs = ent:get_spectators()
        end
    end]]
    obs = lp.m_iHealth <=0 and lp.m_hObserverTarget or lp
    specs = obs:get_spectators()
    if visuals.gs_specs:get() and specs and #specs then
        for i=1, #specs do
            local name = specs[i]:get_name()
            render.text(fonts.default_font_bak, vector(screensizex - 8 - render.measure_text(fonts.default_font_bak, nil, name).x, 8 + 20 * (i - 1)), color(255, 255, 255), nil, name)
        end
    end
    spectators.width = 150

    if specs then
        for i = 1, #specs do
            local spec = specs[i]:get_player_info().userid
            local spechand = specs[i]
            if not spectators.list[spec] then 
                spectators.list[spec] = {anim = 0, handle = spechand}
            end
        end
    end

    for k in pairs(spectators.list) do
        spectators.list[k].handle = entity.get(k, true)
        if not lp or not spectators.list[k].handle or not spectators.list[k].handle:is_player() then table.remove(spectators.list, k) goto specskip end
        local name = spectators.list[k].handle:get_name()
        --if string.len(name) > 15 then name = string.sub(name, 1, 15).."..." end
        local avatars = visuals.spec_avatars:get()
        name = limit_text(name, avatars and 118 or 140, fonts.default_font)
        spectators.list[k].anim = lerp(spectators.list[k].anim, (spectators.list[k].handle.m_hObserverTarget == lp.m_hObserverTarget and not (spectators.list[k].handle.m_iHealth > 0)) and 1 or 0, 10)
        if spectators.list[k].anim < 0.01 then goto specskip end
        spectators.avapad = lerp(spectators.avapad, avatars and 22 or 0, 10)
        if avatars then
            local image = spectators.list[k].handle:get_steam_avatar()
            render.texture(image, vector(spectators.pos.x + 6, spectators.pos.y + spectators.padding + 25 + 22 * spectators.count), vector(16, 16), color(255, 255, 255, math.floor(255 * spectators.alpha * spectators.list[k].anim)), nil, visuals.cur_theme == "Retro" and 0 or 4)
        end
        local bind_color = (visuals.cur_theme == "Alpha " or visuals.cur_theme == "Modern ") and color(light.r, light.g, light.b, math.floor(255 * spectators.alpha * spectators.list[k].anim)) or color(255, 255, 255, math.floor(255 * spectators.alpha * spectators.list[k].anim))
        render.text(fonts.default_font, vector(spectators.pos.x + 6 + spectators.avapad, spectators.pos.y + spectators.padding + 27 + 22 * spectators.count), bind_color, "nil", name)
        spectators.count = spectators.count + spectators.list[k].anim
        ::specskip::
    end

    ::skip::

    if visuals.spectators:get() and ((spectators.count > 0 and globals.is_in_game)) then
        spectators.alpha = lerp(spectators.alpha, 1, 15)
    elseif visuals.spectators:get() then
        spectators.alpha = lerp(spectators.alpha, ui.get_alpha(), 15)
    else
        spectators.alpha = lerp(spectators.alpha, 0, 15)
    end

    if visuals.spectators:get() and (ui.get_alpha() > 0) and (spectators.alpha>0) and is_mouse_in_bounds(spectators.pos.x - 3, spectators.pos.y - 3, spectators.width + 8, 32) then
        spectators.drag_alpha = lerp(spectators.drag_alpha, 1, 15)
    else
        spectators.drag_alpha = lerp(spectators.drag_alpha, 0, 15)
    end

    --spectators.drag()
    drag(spectators.pos, vector(spectators.width + 8, 32))

end

events.render:set(visuals.draw_spectators)

currentcolor = color(255, 255, 255, 255)
iugencolor = color(255, 255, 255, 255)
scriptcolor = color(255, 255, 255, 255)
leftcolor = color(255, 255, 255, 255)
rightcolor = color(255, 255, 255, 255)

indanimations = {
    ebrima = 0,
    pixel = 0,
    modern = 0,
    small = 0,
    edgy = 0,
    open = 0,
    mleft = 0,
    mright = 0,
    mload = 0,
    mwarning = 0,
    textcover = 0,
    coverwidth = 0,
    idealtext = 0,
    yawtext = 0,
    yawtextalpha = 0,
    desyncbar = 0,
    desynctext = 0,
    movetext = 0,
    antibrute = 0,
    dt = 0,
    dttext = 0,
    hs = 0,
    hstext = 0,
    aptext = 0,
    dmgtext = 0
}

left_ind = color(255, 255, 255, 255)
right_ind = color(255, 255, 255, 255)
direction = 1
small_text = gradient.text_animate("OPIUM.SYS", 1, {
    color(148, 110, 242), 
    color(70, 52, 115)
})
small_text_ideal = gradient.text_animate("IDEAL TICK", 1, {
    color(148, 110, 242), 
    color(70, 52, 115)
})

visuals.draw_indicators = function()
    --if not script_loaded then return end
    if not (visuals.indicator:get() ~= "Disabled") then return end
    if entity.get_local_player() == nil then return end

    --print(ragebot.get_active_cfg())
    --if global_vars.frame_count() % 64 == 0 then
    --    print(math.floor(math.floor(antiaim.get_fake_angle())))
    --    stringtoolvar = math.floor(math.floor(antiaim.get_fake_angle()))
    --end
    --render.text(fonts.ebrimabig, tostring(stringtoolvar) , vector(200, 200), color(255, 255, 255))

    local yaw_text = "OPIUM YAW"
    if aim.tick:get() then
        yaw_text = "IDEAL TICK"
    end

    indanimations.ebrima = lerp(indanimations.ebrima, (visuals.indicator:get() == "Pre-alpha") and 1 or 0, 10)
    indanimations.pixel = lerp(indanimations.pixel, (visuals.indicator:get() == "Pixel") and 1 or 0, 10)
    indanimations.modern = lerp(indanimations.modern, (visuals.indicator:get() == "Modern") and 1 or 0, 10)
    indanimations.small = lerp(indanimations.small, (visuals.indicator:get() == "Default") and 1 or 0, 10)
    indanimations.edgy = lerp(indanimations.edgy, (visuals.indicator:get() == "Vamp") and 1 or 0, 10)
    indanimations.mleft = lerp(indanimations.mleft, (refs.hs.on:get() or refs.dt.on:get() or refs.dt.on:get_override()) and 1 or 0, 10)
    indanimations.mright = lerp(indanimations.mright, ((refs.ap.on:get() or aim.tick:get()) or refs.is_overriding_dmg) and 1 or 0, 10)
    indanimations.mload = lerp(indanimations.mload, (rage.exploit:get() ~= 1) and 1 or 0, 10)
    --indanimations.open = lerp(indanimations.open, ((indanimations.mleft + indanimations.mright) > 0.1) and 1 or 0, 10)
    indanimations.open = math.max(indanimations.mleft, indanimations.mright)
    indanimations.yawtext = lerp(indanimations.yawtext, visuals.indicator:get() ~= "Disabled" and 1 or 0, 15)
    indanimations.yawtextalpha = lerp(indanimations.yawtextalpha, yaw_text == "OPIUM YAW" and 1 or 0, 15)
    indanimations.idealtext = lerp(indanimations.idealtext, yaw_text == "IDEAL TICK" and 1 or 0, 15)
    indanimations.desyncbar = lerp(indanimations.desyncbar, visuals.elements:get("Desync bar") and 1 or 0, 15)
    indanimations.desynctext = lerp(indanimations.desynctext, visuals.elements:get("Desync range") and 1 or 0, 15)
    indanimations.movetext = lerp(indanimations.movetext, visuals.elements:get("Movement state") and 1 or 0, 15)
    indanimations.antibrute = lerp(indanimations.antibrute, (visuals.elements:get(5) and aa.antibrute_current_stage > 0) and 1 or 0, 15)
    indanimations.mwarning = lerp(indanimations.mwarning, (rage.exploit:get() == 0 and visuals.elements:get("Other indicators") and (refs.dt.on:get() or refs.dt.on:get_override() or refs.hs.on:get())) and 1 or 0, 15)
    indanimations.dt = lerp(indanimations.dt, (rage.exploit:get() == 1 and visuals.elements:get("Other indicators") and (refs.dt.on:get() or refs.dt.on:get_override())) and 1 or 0, 15)
    indanimations.dttext = lerp(indanimations.dttext, (visuals.elements:get("Other indicators") and (refs.dt.on:get() or refs.dt.on:get_override())) and 1 or 0, 15)
    indanimations.hs = lerp(indanimations.hs, (rage.exploit:get() == 1 and visuals.elements:get("Other indicators") and refs.hs.on:get() and not (refs.dt.on:get() or refs.dt.on:get_override())) and 1 or 0, 15)
    indanimations.hstext = lerp(indanimations.hstext, (visuals.elements:get("Other indicators") and refs.hs.on:get()) and 1 or 0, 15)
    indanimations.aptext = lerp(indanimations.aptext, (visuals.elements:get("Other indicators") and (refs.ap.on:get() or aim.tick:get())) and 1 or 0, 15)
    indanimations.dmgtext = lerp(indanimations.dmgtext, (visuals.elements:get("Minimum damage") and refs.is_overriding_dmg) and 1 or 0, 15)
    mindmg_override = refs.dmg:get_override() and refs.dmg:get_override() or refs.is_overriding_dmg and refs.dmg:get() or mindmg_override

    if indanimations.ebrima > 0.1 then
        if globals.is_in_game then
            local lp = entity.get_local_player()
            local local_health = lp.m_iHealth
            if local_health > 0 then
                local angle = local_player.desync_angle()
                --visuals.desync_range = math.floor(lerp(visuals.desync_range, math.abs(math.floor(angle)), 15))
                --local mindmg_ref = menu.find("aimbot", weapon_tabs[ragebot.get_active_cfg() + 1] , "targeting", "min. damage")
                --local mindmg = ragebot.get_active_cfg() < 7 and mindmg_ref:get() or 0
                local mindmg = 0
                --local mindmg_override = ragebot.get_active_cfg() < 7 and refs.override[1]:get() or 0
                local scriptcol = visuals.indicatorcol:get()
                local kolor = scriptcol
                local light = lighten(kolor, 50)
                local fontcolor = color(scriptcol.r, scriptcol.g, scriptcol.b, math.floor(255 * indanimations.ebrima * indanimations.yawtextalpha))
                local idealcolor = color(light.r, light.g, light.b, math.floor(255 * indanimations.ebrima * indanimations.idealtext))
                --rightcolor = fontcolor
                local seccolor = visuals.fullcol:get() and lighten(fontcolor, 50) or color(255, 255, 255, math.floor(255 * indanimations.ebrima * indanimations.yawtextalpha))
                --leftcolor = color(255, 255, 255, 255)
                if angle > 0 then
                    rightcolor = lerp_color(rightcolor, fontcolor, 10)
                    --print(rightcolor)
                    leftcolor = lerp_color(leftcolor, seccolor, 10)
                elseif angle < 0 then
                    rightcolor = lerp_color(rightcolor, seccolor, 10)
                    leftcolor = lerp_color(leftcolor, fontcolor, 10)
                else
                    rightcolor = lerp_color(rightcolor, fontcolor, 10)
                    leftcolor = lerp_color(leftcolor, fontcolor, 10)
                end
                local pad0 = math.floor(anim * (6 + render.measure_text( fonts.ebrimabig, nil, "OPIUM YAW" ).x / 2))
                local pad01 = math.floor(anim * (6 + render.measure_text( fonts.ebrimabig, nil, ".IDEAL TICK" ).x / 2))
                local pad1 = math.floor(anim * (6 + math.floor(visuals.desync_range/2)))
                local pad2 = math.floor(anim * (6 + render.measure_text( fonts.ebrimasmall, nil, tostring(visuals.desync_range).."°" ).x / 2 - 2))
                local pad3 = math.floor(anim * (6 + render.measure_text( fonts.ebrimasmall, nil, "DT" ).x / 2))
                local pad4 = math.floor(anim * (6 + render.measure_text( fonts.ebrimasmall, nil, "HS" ).x / 2))
                local pad5 = math.floor(anim * (6 + render.measure_text( fonts.ebrimasmall, nil, "AP" ).x / 2))
                local pad6 = math.floor(anim * (6 + render.measure_text( fonts.ebrimasmall, nil, "AP+DMG: "..tostring(mindmg_override) ).x / 2))
                local pad7 = math.floor(anim * (6 + render.measure_text( fonts.ebrimasmall, nil, "DMG: "..tostring(mindmg_override) ).x / 2))
                local pad_antibrute_text = math.floor(anim * (6 + render.measure_text( fonts.ebrimasmall, nil, "AB X" ).x / 2))
                --render.text(fonts.ebrimabig, "OPIUM YAW", vector(screensizex / 2 + pad0, screensizey / 2 + 25), leftcolor, true)
                if indanimations.textcover > 0.1 then
                    visuals.rect_fade_round_box(vector(screensizex / 2 - indanimations.coverwidth / 2 - 8 + pad0, screensizey / 2 + indanimations.yawtext * 12 + 10 * indanimations.textcover), vector(indanimations.coverwidth + 18, 25), color(kolor.r, kolor.g, kolor.b, math.floor(indanimations.textcover * (1 - anim) * 255 * indanimations.ebrima)), color(0, 0, 0, 0), 2, 6)
                end
                render.text(fonts.ebrimabig, vector(screensizex / 2 + pad0 - render.measure_text( fonts.ebrimabig, nil, "YAW" ).x / 2 + 1, screensizey / 2 + indanimations.yawtext * 25 + 10 * indanimations.textcover * indanimations.ebrima), leftcolor, "c", "OPIUM ")
                render.text(fonts.ebrimabig, vector(screensizex / 2 + render.measure_text( fonts.ebrimabig, nil, "OPIUM " ).x / 2 + pad0, screensizey / 2 + indanimations.yawtext * 25 + 10 * indanimations.textcover * indanimations.ebrima), rightcolor, "c", "YAW")

                if indanimations.idealtext > 0.1 then
                    render.text(fonts.ebrimabig, vector(screensizex / 2 + pad01, screensizey / 2 + indanimations.yawtext * 25 + 10 * indanimations.textcover * indanimations.ebrima), idealcolor, "c", "IDEAL TICK")
                end
                
                --render.text(fonts.ebrimabig, "IUGEN", vector(screensizex / 2 - render.measure_text( fonts.ebrimabig, "SCRIPT" ).x / 2 + 1 + pad0, screensizey / 2 + 25), leftcolor, true)
                --render.text(fonts.ebrimabig, "SCRIPT", vector(screensizex / 2 - 2 + render.measure_text( fonts.ebrimabig, "IUGEN " ).x / 2 + pad0, screensizey / 2 + 25), rightcolor, true)
                --Product sans 16-700
                --render.text(fonts.ebrimabig, "IUGEN", vector(screensizex / 2 - render.measure_text( fonts.ebrimabig, "SCRIPT" ).x / 2 + pad0, screensizey / 2 + 25), leftcolor, true)
                --render.text(fonts.ebrimabig, "SCRIPT", vector(screensizex / 2 - 2 + render.measure_text( fonts.ebrimabig, "IUGEN  " ).x / 2 + pad0, screensizey / 2 + 25), rightcolor, true)

                local ind = 0
                local indspace = 10
                local indy_pad = (visuals.elements:get("Text cover") and 40 or 38)
                local indy = screensizey / 2 + indy_pad + 10 * indanimations.textcover
                local antibrute_timer = (aa.antibrute_current_stage > 0) and (aa.antibrute_timer:get() - ticks_to_time(aa.antibrute_counter)) / aa.antibrute_timer:get() or 0
                local antibrute_timer = math.max(antibrute_timer, 0)

                indanimations.textcover = lerp(indanimations.textcover, visuals.elements:get("Text cover") and 1 or 0, 15)
                indanimations.coverwidth = lerp(indanimations.coverwidth, visuals.elements:get("Text cover") and render.measure_text( fonts.ebrimabig, nil, yaw_text ).x or 0, 15)

                if indanimations.desyncbar > 0.1 then
                    indy = indy + indanimations.desyncbar * 5
                    --render.rect_fade(vector(screensizex / 2 - math.floor(visuals.desync_range/2) + pad1, indy - 18 + indanimations.desyncbar * 8), vector(math.floor(visuals.desync_range/2) - pad1, 2), color(0, 0, 0, 0), color(kolor.r, kolor.g, kolor.b, math.floor(indanimations.desyncbar * (1 - anim) * 255 * indanimations.ebrima)), true)
                    render.gradient(vector(screensizex / 2 - math.floor(visuals.desync_range/2) + pad1, indy - 18 + indanimations.desyncbar * 8), vector(screensizex / 2 + pad1, indy - 16 + indanimations.desyncbar * 8), color(0, 0, 0, 0), color(kolor.r, kolor.g, kolor.b, math.floor(indanimations.desyncbar * (1 - anim) * 255 * indanimations.ebrima)), color(0, 0, 0, 0), color(kolor.r, kolor.g, kolor.b, math.floor(indanimations.desyncbar * (1 - anim) * 255 * indanimations.ebrima)))
                    render.gradient(vector(screensizex / 2 + 6 * anim, indy - 18 + indanimations.desyncbar * 8), vector(screensizex / 2 + math.floor(visuals.desync_range/2) + 6 * anim + pad1, indy - 16 + indanimations.desyncbar * 8), color(kolor.r, kolor.g, kolor.b, math.floor(indanimations.desyncbar * 255 * indanimations.ebrima)), color(0, 0, 0, 0), color(kolor.r, kolor.g, kolor.b, math.floor(indanimations.desyncbar * 255 * indanimations.ebrima)), color(0, 0, 0, 0))
                    --render.rect_fade(vector(screensizex / 2 + 6 * anim, indy - 18 + indanimations.desyncbar * 8), vector(math.floor(visuals.desync_range/2) + 6 * anim, 2), color(color.r, color.g, color.b, math.floor(indanimations.desyncbar * 255 * indanimations.ebrima)), color(0, 0, 0, 0), true)
                    indy = indy + (visuals.elements:get("Text cover") and 2 or 0)
                end
                if indanimations.desynctext > 0.1 then
                    render.text(fonts.ebrimasmall, vector(screensizex / 2 + pad2 + render.measure_text( fonts.ebrimasmall, nil, "°" ).x/2, indy + indspace * ind), color(255, 255, 255, math.floor(255 * indanimations.desynctext * indanimations.ebrima)), "c", tostring(visuals.desync_range).."°")
                    ind = ind + indanimations.desynctext
                end
                if indanimations.antibrute > 0.1 then
                    render.text(fonts.ebrimasmall, vector(screensizex / 2 + pad_antibrute_text, indy + indspace * ind), color(255, 255, 255, math.floor(255 * indanimations.antibrute * indanimations.ebrima)), "c", "AB "..aa.antibrute_current_stage)
                    if aa.antibrute_timer:get() > 0 then
                        --ind = ind + 0.5 * indanimations.antibrute
                        --render.rect_filled(vector(screensizex / 2 - render.measure_text( fonts.ebrimasmall, "AB X" ).x / 2 + pad_antibrute_text, indy + indspace * ind + 1), vector(render.measure_text( fonts.ebrimasmall, "AB X" ).x, 3), color(0, 0, 0, math.floor(indanimations.antibrute * 150 * indanimations.ebrima)) )
                        render.rect(vector(screensizex / 2 - render.measure_text( fonts.ebrimasmall, nil, "AB X" ).x / 2 + pad_antibrute_text, indy + indspace * ind + render.measure_text(fonts.ebrimasmall, nil, "AB X").y * 0.45), vector(screensizex / 2 - render.measure_text( fonts.ebrimasmall, nil, "AB X" ).x / 2 + pad_antibrute_text + math.floor(antibrute_timer * render.measure_text( fonts.ebrimasmall, nil, "AB X" ).x - 2), indy + indspace * ind + render.measure_text(fonts.ebrimasmall, nil, "AB X").y * 0.45 + 1), color(255, 255, 255, math.floor(indanimations.antibrute * 255 * indanimations.ebrima)))
                        --ind = ind + 0.5 * indanimations.antibrute
                    end
                    ind = ind + (antibrute_timer > 0 and 1.2 or 1) * indanimations.antibrute
                end
                
                if indanimations.dttext > 0.1 then
                    if (rage.exploit:get() < 1) and (refs.dt.on:get() or refs.dt.on:get_override()) then
                        render.text(fonts.ebrimasmall, vector(screensizex / 2 + pad3, indy + indspace * ind), color(255, 0, 0, math.floor(255 * indanimations.dttext * indanimations.ebrima)), "c", "DT")
                    else
                        render.text(fonts.ebrimasmall, vector(screensizex / 2 + pad3, indy + indspace * ind), color(255, 255, 255, math.floor(255 * indanimations.dttext * indanimations.ebrima)), "c", "DT")
                    end
                    --render.rect_filled(vector(screensizex / 2 + pad3 - render.measure_text(fonts.ebrimasmall, nil, "DT").x * 0.5, indy + (indspace) * ind + render.measure_text(fonts.ebrimasmall, nil, "DT").y * 0.45), vector(math.min(math.floor(render.measure_text(fonts.ebrimasmall, nil, "DT").x * rage.exploit:get()), render.measure_text(fonts.ebrimasmall, nil, "DT").x), 1), color(255, 255, 255, math.floor(255 * indanimations.dttext * indanimations.ebrima)))
                    ind = ind + 1 * indanimations.dttext
                end
                if indanimations.hstext > 0.1 then
                    render.text(fonts.ebrimasmall, vector(screensizex / 2 + pad4, indy + indspace * ind), color(255, 255, 255, math.floor(255 * indanimations.hstext * indanimations.ebrima)), "c", "HS")
                    ind = ind + indanimations.hstext
                end
                if indanimations.aptext > 0.1 then
                    if not visuals.elements:get("Minimum damage") then
                        render.text(fonts.ebrimasmall, vector(screensizex / 2 + pad5, indy + indspace * ind), color(255, 255, 255, math.floor(255 * indanimations.aptext * indanimations.ebrima)), "c", "AP")
                    elseif not refs.is_overriding_dmg then
                        render.text(fonts.ebrimasmall, vector(screensizex / 2 + pad5, indy + indspace * ind), color(255, 255, 255, math.floor(255 * indanimations.aptext * indanimations.ebrima)), "c", "AP")
                    end
                end
                if indanimations.dmgtext > 0.1 then
                    if visuals.elements:get("Other indicators") and (refs.ap.on:get() or aim.tick:get()) then
                        render.text(fonts.ebrimasmall, vector(screensizex / 2 + pad6, indy + indspace * ind), color(255, 255, 255, math.floor(255 * indanimations.dmgtext * indanimations.ebrima)), "c", "AP+DMG: "..tostring(mindmg_override))
                    else render.text(fonts.ebrimasmall, vector(screensizex / 2 + pad7, indy + indspace * ind), color(255, 255, 255, math.floor(255 * indanimations.dmgtext * indanimations.ebrima)), "c", "DMG: "..tostring(mindmg_override)) end
                    ind = ind + indanimations.dmgtext
                end
            end
        end
    elseif indanimations.pixel > 0.1 then
        if globals.is_in_game then
            local lp = entity.get_local_player()
            local local_health = lp.m_iHealth
            if local_health > 0 then
                local angle = local_player.desync_angle()
                --visuals.desync_range = math.floor(lerp(visuals.desync_range, math.abs(math.floor(angle)), 15))
                --local mindmg_ref = menu.find("aimbot", weapon_tabs[ragebot.get_active_cfg() + 1] , "targeting", "min. damage")
                --local mindmg = ragebot.get_active_cfg() < 7 and mindmg_ref:get() or 0
                --local mindmg_override = ragebot.get_active_cfg() < 7 and refs.override[1]:get() or 0
                local mindmg = 0
                local scriptcol = visuals.indicatorcol:get()
                local kolor = visuals.fullcolind:get() and scriptcol or color(255, 255, 255)
                local fontcolor = color(scriptcol.r, scriptcol.g, scriptcol.b, math.floor(255 * indanimations.pixel))
                --rightcolor = fontcolor
                local seccolor = visuals.fullcol:get() and lighten(fontcolor, 50) or color(255, 255, 255, math.floor(255 * indanimations.pixel))
                --leftcolor = color(255, 255, 255, 255)
                if angle > 0 then
                    rightcolor = lerp_color(rightcolor, fontcolor, 10)
                    --print(rightcolor)
                    leftcolor = lerp_color(leftcolor, seccolor, 10)
                elseif angle < 0 then
                    rightcolor = lerp_color(rightcolor, seccolor, 10)
                    leftcolor = lerp_color(leftcolor, fontcolor, 10)
                else
                    rightcolor = lerp_color(rightcolor, fontcolor, 10)
                    leftcolor = lerp_color(leftcolor, fontcolor, 10)
                end

                local movetext = aa.conditionslist[aa.move_state]
                local pad0 = math.floor(anim * (6 + render.measure_text( fonts.pixelretrosmall, nil, "OPIUM.YAW" ).x / 2))
                local pad01 = math.floor(anim * (6 + render.measure_text( fonts.pixelretrosmall, nil, "IDEAL TICK" ).x / 2))
                local pad1 = math.floor(anim * (6 + render.measure_text( fonts.pixelretrosmall, nil, "OPIUM.YAW" ).x / 2 - 1))
                local pad2 = pad1
                local padmove = math.floor(anim * (6 + render.measure_text( fonts.pixelretrosmall, nil, movetext ).x / 2 + 0.5))
                local pad3 = math.floor(anim * (6 + render.measure_text( fonts.pixelretrosmall, nil, (rage.exploit:get() < 1 and (refs.dt.on:get() or refs.dt.on:get_override())) and ".DOUBLETAP<!>" or "DOUBLETAP" ).x / 2) + 1)
                local pad4 = math.floor(anim * (6 + render.measure_text( fonts.pixelretrosmall, nil, "HIDESHOTS" ).x / 2))
                local pad5 = math.floor(anim * (6 + render.measure_text( fonts.pixelretrosmall, nil, "AUTOPEEK" ).x / 2))
                local pad6 = math.floor(anim * (6 + render.measure_text( fonts.pixelretrosmall, nil, "AP DMG HP"..tostring(mindmg_override) ).x / 2))
                local pad7 = math.floor(anim * (6 + render.measure_text( fonts.pixelretrosmall, nil, "DAMAGE HP"..tostring(mindmg_override) ).x / 2))
                local pad_antibrute_text = math.floor(anim * (6 + render.measure_text( fonts.pixelretrosmall, nil, "BRUTE STX" ).x / 2 - 1))
                local indcolor = color(kolor.r, kolor.g, kolor.b, math.floor(255 * indanimations.pixel * indanimations.yawtextalpha))
                local indcolor_dark = darken(indcolor, 30)
                --left_ind = color(255, 255, 255)
                --[[if left_ind.a < 5 then
                    left_ind.a = lerp(left_ind.a, 255, 5)
                elseif left_ind.a > 250 then
                    left_ind.a = lerp(left_ind.a, 0, 5)
                end]]
                left_ind.r, left_ind.g, left_ind.b = indcolor.r, indcolor.g, indcolor.b
                right_ind.r, right_ind.g, right_ind.b = indcolor.r, indcolor.g, indcolor.b
                if left_ind.a < 5 then
                    direction = 1
                elseif left_ind.a > 250 then
                    direction = -1
                end
                --left_ind.a = math.floor(lerp(left_ind.a, left_ind.a + direction, 1))
                left_ind.a = left_ind.a + direction
                right_ind.a = 255 - left_ind.a

                render.text(fonts.pixelretrosmall, vector(screensizex / 2 + pad0, screensizey / 2 + indanimations.yawtext * 27), indcolor_dark, "c", "OPIUM.YAW")
                --gradient.text_multi("OPIUM.YAW", false, left_ind, right_ind, left_ind)
                render.text(fonts.pixelretrosmall, vector(screensizex / 2 + pad0, screensizey / 2 + indanimations.yawtext * 27), indcolor, "c", "OPIUM.YAW")
                if indanimations.idealtext > 0.1 then
                    render.text(fonts.pixelretrosmall, vector(screensizex / 2 + pad01, screensizey / 2 + indanimations.yawtext * 27), color(kolor.r, kolor.g, kolor.b, math.floor(255 * indanimations.pixel * indanimations.idealtext)), "c", "IDEAL TICK")
                end

                local ind = 1
                local indspace = 9
                local indy_pad = 20
                local indy = screensizey / 2 + indy_pad + 7
                local antibrute_timer = (aa.antibrute_current_stage > 0) and (aa.antibrute_timer:get() - ticks_to_time(aa.antibrute_counter)) / aa.antibrute_timer:get() or 0
                --local antibrute_timer = math.max(antibrute_timer, 0)
                --local antibrute_timer = 0
    
                if indanimations.desyncbar > 0.1 then
                    --indy = indy + indanimations.desyncbar * 5
                    render.rect(vector(screensizex / 2 - render.measure_text( fonts.pixelretrosmall, nil, "OPIUM.YAW" ).x / 2 + pad1, indy - 11 + indanimations.desyncbar * 8 + indspace * (ind)), vector(screensizex / 2 + render.measure_text( fonts.pixelretrosmall, nil, "OPIUM.YAW" ).x / 2 + pad1, indy - 3 + indanimations.desyncbar * 8 + indspace * (ind)), color(0, 0, 0, math.floor(indanimations.desyncbar * 100 * indanimations.pixel)) )
                    render.gradient(vector(screensizex / 2 - render.measure_text( fonts.pixelretrosmall, nil, "OPIUM.YAW" ).x / 2 + pad1 + 1, indy - 10 + indanimations.desyncbar * 8 + indspace * (ind)), vector(screensizex / 2 + visuals.desync_range / 60 * render.measure_text( fonts.pixelretrosmall, nil, "OPIUM.YAW" ).x / 2 + pad1 - 2, indy - 4 + indanimations.desyncbar * 8 + indspace * (ind)), color(scriptcol.r, scriptcol.g, scriptcol.b, math.floor(indanimations.desyncbar * 255 * indanimations.pixel)), color(0, 0, 0, 0), color(scriptcol.r, scriptcol.g, scriptcol.b, math.floor(indanimations.desyncbar * 255 * indanimations.pixel)), color(0, 0, 0, 0))
                    --render.rect_fade(vector(screensizex / 2 - render.measure_text( fonts.pixelretrosmall, nil, "OPIUM.YAW" ).x / 2 + 1 + pad1, indy - 20 + indanimations.desyncbar * 8), vector(math.floor(visuals.desync_range / 60 * render.measure_text( fonts.pixelretrosmall, nil, "OPIUM.YAW" ).x - 2), 6), color(scriptcol.r, scriptcol.g, scriptcol.b, math.floor(indanimations.desyncbar * 255 * indanimations.pixel)), color(0, 0, 0, 0), true)
                    ind = ind + indanimations.desyncbar
                --[[else indy = indy + 5]] end
                if indanimations.desynctext > 0.1 then
                    render.text(fonts.pixelretrosmall, vector(screensizex / 2 + pad2 + render.measure_text( fonts.pixelretro, nil, "OPIUM.YAW   °" ).x/2, indy + indspace * (ind - 1)), color(kolor.r, kolor.g, kolor.b, math.floor(255 * indanimations.desynctext * indanimations.pixel)), "c", tostring(visuals.desync_range).."°")
                    --ind = ind + indanimations.desynctext
                end
                if indanimations.movetext > 0.1 then
                    render.text(fonts.pixelretrosmall, vector(screensizex / 2 + padmove, indy + indspace * (ind)), color(kolor.r, kolor.g, kolor.b, math.floor(255 * indanimations.movetext * indanimations.pixel)), "c", movetext)
                    ind = ind + indanimations.movetext
                end
                if indanimations.antibrute > 0.1 then
                    render.text(fonts.pixelretrosmall, vector(screensizex / 2 + pad_antibrute_text + 1, indy + indspace * ind), color(kolor.r, kolor.g, kolor.b, math.floor(255 * indanimations.antibrute * indanimations.pixel)), "c", "BRUTE ST"..aa.antibrute_current_stage)
                    if (aa.antibrute_timer:get() > 0) then
                        ind = ind + 0.5 * indanimations.antibrute
                        render.rect(vector(screensizex / 2 - render.measure_text( fonts.pixelretrosmall, nil, "BRUTE STX" ).x / 2 + pad_antibrute_text, indy + indspace * ind + 1), vector(screensizex / 2 + render.measure_text( fonts.pixelretrosmall, nil, "BRUTE STX" ).x / 2 + pad_antibrute_text, indy + indspace * ind + 4), color(0, 0, 0, math.floor(indanimations.antibrute * 150 * indanimations.pixel)))
                        --render.gradient(vector(screensizex / 2 - render.measure_text( fonts.pixelretrosmall, nil, "BRUTE STX" ).x / 2 + 1 + pad_antibrute_text, indy + indspace * ind + 2), vector(screensizex / 2 - render.measure_text( fonts.pixelretrosmall, nil, "BRUTE STX" ).x / 2 + math.floor(antibrute_timer * render.measure_text( fonts.pixelretrosmall, nil, "BRUTE STX" ).x - 1) + pad_antibrute_text, indy + indspace * ind + 3), color(scriptcol.r, scriptcol.g, scriptcol.b, math.floor(indanimations.antibrute * 255 * indanimations.pixel)), color(0, 0, 0, 0), color(scriptcol.r, scriptcol.g, scriptcol.b, math.floor(indanimations.antibrute * 255 * indanimations.pixel)), color(0, 0, 0, 0))
                        render.rect(vector(screensizex / 2 - render.measure_text( fonts.pixelretrosmall, nil, "BRUTE STX" ).x / 2 + 1 + pad_antibrute_text, indy + indspace * ind + 2), vector(screensizex / 2 - render.measure_text( fonts.pixelretrosmall, nil, "BRUTE STX" ).x / 2 + math.floor(antibrute_timer * render.measure_text( fonts.pixelretrosmall, nil, "BRUTE STX" ).x - 1) + pad_antibrute_text, indy + indspace * ind + 3), color(scriptcol.r, scriptcol.g, scriptcol.b, math.floor(indanimations.antibrute * 255 * indanimations.pixel)))
                        --render.rect_filled(vector(screensizex / 2 - render.measure_text( fonts.pixelretrosmall, nil, "BRUTE STX" ).x / 2 + pad_antibrute_text, indy + indspace * ind + 1), vector(render.measure_text( fonts.pixelretrosmall, nil, "BRUTE STX" ).x, 3), color(0, 0, 0, math.floor(indanimations.antibrute * 150 * indanimations.pixel)) )
                        --render.rect_fade(vector(screensizex / 2 - render.measure_text( fonts.pixelretrosmall, nil, "BRUTE STX" ).x / 2 + 1 + pad_antibrute_text, indy + indspace * ind + 2), vector(math.floor(antibrute_timer * render.measure_text( fonts.pixelretrosmall, nil, "BRUTE STX" ).x - 2), 1), color(scriptcol.r, scriptcol.g, scriptcol.b, math.floor(indanimations.antibrute * 255 * indanimations.pixel)), color(0, 0, 0, 0), true)
                    end
                    ind = ind + indanimations.antibrute
                end
                
                if indanimations.dttext > 0.1 then
                    if rage.exploit:get() < 1 and (refs.dt.on:get() or refs.dt.on:get_override()) then
                        render.text(fonts.pixelretrosmall, vector(screensizex / 2 + pad3, indy + indspace * ind), color(200, 0, 0, math.floor(255 * indanimations.dttext * indanimations.pixel)), "c", "DOUBLETAP<!>")
                    else
                        render.text(fonts.pixelretrosmall, vector(screensizex / 2 + pad3, indy + indspace * ind), color(kolor.r, kolor.g, kolor.b, math.floor(255 * indanimations.dttext * indanimations.pixel)), "c", "DOUBLETAP")
                    end
                    --render.rect_filled(vector(screensizex / 2 + pad3 - render.measure_text(fonts.pixelretrosmall, "DOUBLE TAP").x * 0.5, indy + (indspace + 1) * ind + render.measure_text(fonts.pixelretrosmall, "DOUBLE TAP").y * 0.4), vector(math.floor(render.measure_text(fonts.pixelretrosmall, "DOUBLE TAP").x / exploits.get_max_charge() * exploits.get_charge()), 1), color(255, 255, 255, math.floor(255 * indanimations.dttext * indanimations.pixel)))
                    ind = ind + 1 * indanimations.dttext
                end
                if indanimations.hstext > 0.1 then
                    render.text(fonts.pixelretrosmall, vector(screensizex / 2 + pad4, indy + indspace * ind), color(kolor.r, kolor.g, kolor.b, math.floor(255 * indanimations.hstext * indanimations.pixel)), "c", "HIDESHOTS")
                    ind = ind + indanimations.hstext
                end
                if indanimations.aptext > 0.1 then
                    if not visuals.elements:get("Minimum damage") then
                        render.text(fonts.pixelretrosmall, vector(screensizex / 2 + pad5 + 1, indy + indspace * ind), color(kolor.r, kolor.g, kolor.b, math.floor(255 * indanimations.aptext * indanimations.pixel)), "c", "AUTOPEEK")
                    elseif not refs.is_overriding_dmg then
                        render.text(fonts.pixelretrosmall, vector(screensizex / 2 + pad5 + 1, indy + indspace * ind), color(kolor.r, kolor.g, kolor.b, math.floor(255 * indanimations.aptext * indanimations.pixel)), "c", "AUTOPEEK")
                    end
                end
    
                if indanimations.dmgtext > 0.1 then
                    if visuals.elements:get("Other indicators") and (refs.ap.on:get() or aim.tick:get()) then
                        render.text(fonts.pixelretrosmall, vector(screensizex / 2 + pad6 + 1, indy + indspace * ind), color(kolor.r, kolor.g, kolor.b, math.floor(255 * indanimations.dmgtext * indanimations.pixel)), "c", "AP DMG "..tostring(mindmg_override).."HP")
                    else render.text(fonts.pixelretrosmall, vector(screensizex / 2 + pad7, indy + indspace * ind), color(kolor.r, kolor.g, kolor.b, math.floor(255 * indanimations.dmgtext * indanimations.pixel)), "c", "DAMAGE "..tostring(mindmg_override).."HP") end
                    ind = ind + indanimations.dmgtext
                end
            end
        end
    elseif indanimations.modern > 0.1 then
        if not globals.is_in_game then return end
        local lp = entity.get_local_player()
        local local_health = lp.m_iHealth
        if not (local_health > 0) then return end
        local indcol = visuals.indicatorcol:get()
        local indcol = color(indcol.r, indcol.g, indcol.b, 255)
        local exp = rage.exploit:get()

        local pad0 = math.floor(anim * (30 + render.measure_text( fonts.modern_ind, nil, "OPIUM" ).x / 2))
        
        local text_size = render.measure_text( fonts.modern_ind, nil, "OPIUM" )
        visuals.draw_custom_box(vector(screensizex / 2 + pad0 - text_size.x / 2 - 15, screensizey / 2 + indanimations.yawtext * 12 + 10 * indanimations.modern), vector(text_size.x + 30, 30), math.floor(255 * indanimations.modern), 30 + 26 * indanimations.open, indcol, "Modern ")
        render.text(fonts.modern_ind, vector(screensizex / 2 + pad0, screensizey / 2 + indanimations.yawtext * 28.5 + 10 * indanimations.modern), color(45, 45, 45, math.floor(255 * indanimations.modern * indanimations.yawtextalpha)), "c", "OPIUM")
        render.text(fonts.modern_ind, vector(screensizex / 2 + pad0, screensizey / 2 + indanimations.yawtext * 28.5 + 10 * indanimations.modern), color(45, 45, 45, math.floor(255 * indanimations.modern * indanimations.idealtext)), "c", "IDEAL")
        render.circle_outline(vector(screensizex / 2 + pad0 - 16 * indanimations.mright, screensizey / 2 + indanimations.yawtext * 27 + 10 * indanimations.modern + 26), color(indcol.r, indcol.g, indcol.b, indcol.a * indanimations.mload), 8 * indanimations.mload, 360*exp, exp, 2)
        --render.texture(dt_icon, vector(screensizex / 2 + pad0 - 20 * indanimations.mright, screensizey / 2 + indanimations.yawtext * 27 + 10 * indanimations.modern + 28), vector(14, 14), indcolor)
        render.circle_gradient(vector(screensizex / 2 + pad0 + 16 * indanimations.mleft, screensizey / 2 + indanimations.yawtext * 27 + 10 * indanimations.modern + 26), indcol, color(0, 0, 0, 0), 8 * indanimations.aptext, 360*indanimations.aptext, indanimations.aptext)
        if indanimations.dttext > 0.1 then
            render.text(fonts.modern_icons, vector(screensizex / 2 + pad0 - 16 * indanimations.mright, screensizey / 2 + indanimations.yawtext * 27 + 10 * indanimations.modern + 26), color(indcol.r, indcol.g, indcol.b, indcol.a * indanimations.dt), "c", ui.get_icon("check-double"))
        end
        if indanimations.hs > 0.1 then
            render.text(fonts.modern_icons, vector(screensizex / 2 + pad0 - 16 * indanimations.mright, screensizey / 2 + indanimations.yawtext * 27 + 10 * indanimations.modern + 26), color(indcol.r, indcol.g, indcol.b, indcol.a * indanimations.hs), "c", ui.get_icon("shield-check"))
        end
        if indanimations.mwarning > 0.1 then
            render.text(fonts.modern_icons, vector(screensizex / 2 + pad0 - 16 * indanimations.mright, screensizey / 2 + indanimations.yawtext * 27 + 10 * indanimations.modern + 26), color(indcol.r, indcol.g, indcol.b, indcol.a * indanimations.mwarning), "c", ui.get_icon("engine-warning"))
        end
        render.text(fonts.modern_dmg, vector(screensizex / 2 + pad0 + 16 * indanimations.mleft, screensizey / 2 + indanimations.yawtext * 27 + 10 * indanimations.modern + 26), color(indcol.r, indcol.g, indcol.b, math.floor(255 * indanimations.modern * indanimations.dmgtext)), "c", mindmg_override)
    elseif indanimations.small > 0.1 then
        if not globals.is_in_game then return end
        local lp = entity.get_local_player()
        local local_health = lp.m_iHealth
        if not (local_health > 0) then return end
        local movetext = ""
        local movetext = aa.conditions_short[aa.move_state]
        local scriptcol = visuals.indicatorcol:get()
        local kolor = visuals.fullcolind:get() and scriptcol or color(255, 255, 255)
        local fontcolor = color(scriptcol.r, scriptcol.g, scriptcol.b, math.floor(255 * indanimations.small))
        local fontcolor_dark = lighten_hsv(fontcolor, -60)
        small_text:set_colors({fontcolor, fontcolor_dark})
        small_text:animate()
        small_text_ideal:set_colors({fontcolor, fontcolor_dark})
        small_text_ideal:animate()
        local pad = 2
        local txtsize = render.measure_text( fonts.smallind_main, nil, "OPIUM.SYS" ).x
        local pad0 = math.floor(anim * (6 + txtsize / 2))
        local pad00 = math.floor(anim * (6 + render.measure_text( fonts.smallind, nil, "DAMAGE "..mindmg_override ).x / 2 + 1) + 1)
        local pad1 = math.floor(anim * (6 + math.floor(visuals.desync_range/2) + 1))
        local pad2 = math.floor(anim * (6 + render.measure_text( fonts.smallind, nil, tostring(visuals.desync_range).."°" ).x / 2))
        local pad3 = math.floor(anim * (6 + render.measure_text( fonts.smallind, nil, "DT" ).x / 2 + 1) + 1)
        local pad4 = math.floor(anim * (6 + render.measure_text( fonts.smallind, nil, "HS" ).x / 2 + 1) + 0.5)
        local pad5 = math.floor(anim * (6 + render.measure_text( fonts.smallind, nil, "AP" ).x / 2 + 1) + 1)
        local pad11 = math.floor(anim * (6 + render.measure_text( fonts.smallind_main, nil, "OPIUM.SYS" ).x / 2))
        local padmove = math.floor(anim * (6 + render.measure_text( fonts.smallind, nil, movetext ).x / 2 + 1) + 1.5)
        local indy_pad = 13 * math.max(indanimations.dmgtext, indanimations.desynctext)
        if indanimations.dmgtext > 0.1 then
            render.text(fonts.smallind, vector(screensizex / 2 + pad00, screensizey / 2 + indanimations.yawtext * 27), color(kolor.r, kolor.g, kolor.b, math.floor(255 * indanimations.dmgtext * indanimations.small)), "c", "DAMAGE "..mindmg_override)
        end
        if indanimations.desynctext > 0.1 then
            render.text(fonts.smallind, vector(screensizex / 2 + pad2 + render.measure_text( fonts.smallind, nil, "°" ).x / 2, screensizey / 2 + indanimations.yawtext * 27 + 13 * indanimations.dmgtext), color(kolor.r, kolor.g, kolor.b, math.floor(255 * (indanimations.desynctext - indanimations.dmgtext) * indanimations.small)), "c", tostring(visuals.desync_range).."°")
        end
        render.rect(vector(screensizex / 2 - math.floor(visuals.desync_range / 2) + pad1, screensizey / 2 + indanimations.yawtext * 27 + indy_pad - 3), vector(screensizex / 2 + math.floor(visuals.desync_range / 2) + pad1 + 1, screensizey / 2 + indanimations.yawtext * 27 + indy_pad), color(0, 0, 0, math.floor(255 * indanimations.desyncbar * indanimations.small)))
        render.rect(vector(screensizex / 2 - math.floor(visuals.desync_range / 2) + pad1 + 1, screensizey / 2 + indanimations.yawtext * 27 + indy_pad - 2), vector(screensizex / 2 + math.floor(visuals.desync_range / 2) + pad1, screensizey / 2 + indanimations.yawtext * 27 + indy_pad - 1), color(kolor.r, kolor.g, kolor.b, math.floor(255 * indanimations.desyncbar * indanimations.small)))
        local indy_pad = indy_pad + 9 * indanimations.desyncbar
        render.shadow(vector(screensizex / 2 + pad0 - txtsize * 0.5 - pad, screensizey / 2 + indanimations.yawtext * 27 + indy_pad + 1), vector(screensizex / 2 + pad0 + txtsize * 0.5 + 1, screensizey / 2 + indanimations.yawtext * 27 + indy_pad + 1), fontcolor, 72, 0, 0)
        render.text(fonts.smallind_main, vector(screensizex / 2 + pad0 + pad, screensizey / 2 + indanimations.yawtext * 27 + indy_pad), color(255, 255, 255, 255 * indanimations.small * indanimations.yawtextalpha), "c", small_text:get_animated_text())
        render.text(fonts.smallind_main, vector(screensizex / 2 + pad0 + pad, screensizey / 2 + indanimations.yawtext * 27 + indy_pad), color(255, 255, 255, 255 * indanimations.small * indanimations.idealtext), "c", small_text_ideal:get_animated_text())
        local ind = 0
        local indspace = 9
        local indy_pad = indy_pad + 40
        local indy = screensizey / 2 + indy_pad
        local indx = -10 * indanimations.hstext * (1 - anim) -10 * indanimations.aptext * (1 - anim)
        local pad_row = pad3 * indanimations.dttext - anim * indx
        local pad_row = 0
        local antibrute_timer = (aa.antibrute_current_stage > 0) and (aa.antibrute_timer:get() - ticks_to_time(aa.antibrute_counter)) / aa.antibrute_timer:get() or 0
        local antibrute_timer = math.clamp(antibrute_timer, 0.04, 1)
        if indanimations.antibrute > 0.1 then
            render.rect(vector(screensizex / 2 - txtsize / 2 + pad11 + 1, indy + indspace * ind - 3), vector(screensizex / 2 + txtsize / 2 + pad11 + 1, indy + indspace * ind), color(0, 0, 0, math.floor(255 * indanimations.antibrute * indanimations.small)))
            render.rect(vector(screensizex / 2 - txtsize / 2 + pad11 + 2, indy + indspace * ind - 2), vector(screensizex / 2 - txtsize / 2 + pad11 + antibrute_timer * txtsize, indy + indspace * ind - 1), color(kolor.r, kolor.g, kolor.b, math.floor(255 * indanimations.antibrute * indanimations.small)))
            ind = ind + indanimations.antibrute
        end 
        if indanimations.movetext > 0.1 then
            render.text(fonts.smallind, vector(screensizex / 2 + padmove, indy + indspace * ind), color(kolor.r, kolor.g, kolor.b, math.floor(255 * indanimations.movetext * indanimations.small)), "c", string.upper(movetext))
            ind = ind + 1.3 * indanimations.movetext
        end
        if indanimations.dttext > 0.1 then
            if rage.exploit:get() < 1 and (refs.dt.on:get() or refs.dt.on:get_override()) then
                render.text(fonts.smallind, vector(screensizex / 2 + indx + pad3, indy + indspace * ind), color(200, 0, 0, math.floor(255 * indanimations.dttext * indanimations.small)), "c", "DT")
            else
                render.text(fonts.smallind, vector(screensizex / 2 + indx + pad3, indy + indspace * ind), color(kolor.r, kolor.g, kolor.b, math.floor(255 * indanimations.dttext * indanimations.small)), "c", "DT")
            end
            --render.rect_filled(vector(screensizex / 2 + pad3 - render.measure_text(fonts.pixelretrosmall, "DOUBLE TAP").x * 0.5, indy + (indspace + 1) * ind + render.measure_text(fonts.pixelretrosmall, "DOUBLE TAP").y * 0.4), vector(math.floor(render.measure_text(fonts.pixelretrosmall, "DOUBLE TAP").x / exploits.get_max_charge() * exploits.get_charge()), 1), color(255, 255, 255, math.floor(255 * indanimations.dttext * indanimations.pixel)))
            --ind = ind + 1 * indanimations.dttext
        end
        local indx = indx + 10 * indanimations.hstext * (1 - anim) + 10 * indanimations.dttext * (1 - anim) + 20 * indanimations.dttext * anim
        --local pad_row = pad4 * indanimations.hstext + 10 * indanimations.hstext
        if indanimations.hstext > 0.1 then
            local hscol = color(kolor.r, kolor.g, kolor.b, math.floor(255 * indanimations.hstext * indanimations.small))
            local hscol = (refs.dt.on:get() or refs.dt.on:get_override()) and grayscale(hscol) or hscol
            render.text(fonts.smallind, vector(screensizex / 2 + indx + pad4, indy + indspace * ind), hscol, "c", "HS")
            --ind = ind + indanimations.hstext
        end
        local indx = indx + 10 * indanimations.hstext * (1 - anim) + 10 * indanimations.aptext * (1 - anim) + 20 * indanimations.hstext * anim
        if indanimations.aptext > 0.1 then
            render.text(fonts.smallind, vector(screensizex / 2 + indx + pad5, indy + indspace * ind), color(kolor.r, kolor.g, kolor.b, math.floor(255 * indanimations.aptext * indanimations.small)), "c", "AP")
            --ind = ind + indanimations.hstext
        end
    elseif indanimations.edgy > 0.1 then
        if globals.is_in_game then
            local lp = entity.get_local_player()
            local local_health = lp.m_iHealth
            if local_health > 0 then
                local angle = local_player.desync_angle()
                --visuals.desync_range = math.floor(lerp(visuals.desync_range, math.abs(math.floor(angle)), 15))
                --local mindmg_ref = menu.find("aimbot", weapon_tabs[ragebot.get_active_cfg() + 1] , "targeting", "min. damage")
                --local mindmg = ragebot.get_active_cfg() < 7 and mindmg_ref:get() or 0
                local mindmg = 0
                --local mindmg_override = ragebot.get_active_cfg() < 7 and refs.override[1]:get() or 0
                local scriptcol = visuals.indicatorcol:get()
                local kolor = scriptcol
                local light = lighten(kolor, 50)
                local fontcolor = color(scriptcol.r, scriptcol.g, scriptcol.b, math.floor(255 * indanimations.edgy * indanimations.yawtextalpha))
                local idealcolor = color(scriptcol.r, scriptcol.g, scriptcol.b, math.floor(255 * indanimations.edgy * indanimations.idealtext))
                --rightcolor = fontcolor
                local seccolor = visuals.fullcol:get() and lighten(fontcolor, 50) or color(255, 255, 255, math.floor(255 * indanimations.edgy * indanimations.yawtextalpha))
                --leftcolor = color(255, 255, 255, 255)
                if angle > 0 then
                    rightcolor = lerp_color(rightcolor, fontcolor, 10)
                    --print(rightcolor)
                    leftcolor = lerp_color(leftcolor, seccolor, 10)
                elseif angle < 0 then
                    rightcolor = lerp_color(rightcolor, seccolor, 10)
                    leftcolor = lerp_color(leftcolor, fontcolor, 10)
                else
                    rightcolor = lerp_color(rightcolor, fontcolor, 10)
                    leftcolor = lerp_color(leftcolor, fontcolor, 10)
                end
                local pad0 = math.floor(anim * (6 + render.measure_text( fonts.indedgybig, nil, "OPIUM" ).x / 2))
                local pad00 = math.floor(anim * (6 + render.measure_text( fonts.indedgysmall, nil, "DAMAGE "..mindmg_override ).x / 2) - 1)
                local pad01 = math.floor(anim * (6 + render.measure_text( fonts.indedgybig, nil, "IDEAL TICK" ).x / 2))
                local pad1 = math.floor(anim * (6 + math.floor(visuals.desync_range/4)))
                local pad2 = math.floor(anim * (6 + render.measure_text( fonts.indedgysmall, nil, tostring(visuals.desync_range) ).x / 2))
                local pad3 = math.floor(anim * (6 + render.measure_text( fonts.indedgysmall, nil, "DT" ).x / 2))
                local pad4 = math.floor(anim * (6 + render.measure_text( fonts.indedgysmall, nil, "HS" ).x / 2))
                local pad5 = math.floor(anim * (6 + render.measure_text( fonts.indedgysmall, nil, "AP" ).x / 2))
                local pad6 = math.floor(anim * (6 + render.measure_text( fonts.indedgysmall, nil, "AP+DMG: "..tostring(mindmg_override) ).x / 2))
                local pad7 = math.floor(anim * (6 + render.measure_text( fonts.indedgysmall, nil, "DMG: "..tostring(mindmg_override) ).x / 2))
                local pad_antibrute_text = math.floor(anim * (6 + render.measure_text( fonts.indedgysmall, nil, "AB X" ).x / 2 + 1))
                --render.text(fonts.indedgybig, "OPIUM YAW", vector(screensizex / 2 + pad0, screensizey / 2 + 25), leftcolor, true)
                local indy_pad = 15 * indanimations.dmgtext
                if indanimations.dmgtext > 0.1 then
                    render.text(fonts.indedgysmall, vector(screensizex / 2 + pad00, screensizey / 2 + indanimations.yawtext * 25), color(kolor.r, kolor.g, kolor.b, math.floor(255 * indanimations.dmgtext * indanimations.edgy)), "c", "DAMAGE "..mindmg_override)
                end
                render.text(fonts.indedgybig, vector(screensizex / 2 + pad0, screensizey / 2 + indanimations.yawtext * 25 + indy_pad), fontcolor, "c", "OPIUM")

                if indanimations.idealtext > 0.1 then
                    render.text(fonts.indedgybig, vector(screensizex / 2 + pad01, screensizey / 2 + indanimations.yawtext * 25 + indy_pad), idealcolor, "c", "IDEAL TICK")
                end
                
                --render.text(fonts.indedgybig, "IUGEN", vector(screensizex / 2 - render.measure_text( fonts.indedgybig, "SCRIPT" ).x / 2 + 1 + pad0, screensizey / 2 + 25), leftcolor, true)
                --render.text(fonts.indedgybig, "SCRIPT", vector(screensizex / 2 - 2 + render.measure_text( fonts.indedgybig, "IUGEN " ).x / 2 + pad0, screensizey / 2 + 25), rightcolor, true)
                --Product sans 16-700
                --render.text(fonts.indedgybig, "IUGEN", vector(screensizex / 2 - render.measure_text( fonts.indedgybig, "SCRIPT" ).x / 2 + pad0, screensizey / 2 + 25), leftcolor, true)
                --render.text(fonts.indedgybig, "SCRIPT", vector(screensizex / 2 - 2 + render.measure_text( fonts.indedgybig, "IUGEN  " ).x / 2 + pad0, screensizey / 2 + 25), rightcolor, true)

                local ind = 0
                local indspace = 13
                local indy_pad = indy_pad + 38
                local indy = screensizey / 2 + indy_pad
                local indx = -8 * indanimations.hstext * (1 - anim) -8 * indanimations.aptext * (1 - anim)
                local antibrute_timer = (aa.antibrute_current_stage > 0) and (aa.antibrute_timer:get() - ticks_to_time(aa.antibrute_counter)) / aa.antibrute_timer:get() or 0
                local antibrute_timer = math.max(antibrute_timer, 0)

                if indanimations.desyncbar > 0.1 then
                    indy = indy + indanimations.desyncbar * 5
                    --render.rect_fade(vector(screensizex / 2 - math.floor(visuals.desync_range/2) + pad1, indy - 18 + indanimations.desyncbar * 8), vector(math.floor(visuals.desync_range/2) - pad1, 2), color(0, 0, 0, 0), color(kolor.r, kolor.g, kolor.b, math.floor(indanimations.desyncbar * (1 - anim) * 255 * indanimations.edgy)), true)
                    render.gradient(vector(screensizex / 2 - math.floor(visuals.desync_range/4) + pad1, indy - 18 + indanimations.desyncbar * 8), vector(screensizex / 2 + pad1, indy - 16 + indanimations.desyncbar * 8), color(kolor.r, kolor.g, kolor.b, math.floor(indanimations.desyncbar * 255 * indanimations.edgy)), color(kolor.r, kolor.g, kolor.b, math.floor(indanimations.desyncbar) * 255 * indanimations.edgy), color(kolor.r, kolor.g, kolor.b, math.floor(indanimations.desyncbar * 255 * indanimations.edgy)), color(kolor.r, kolor.g, kolor.b, math.floor(indanimations.desyncbar * 255 * indanimations.edgy)))
                    render.gradient(vector(screensizex / 2 + 6 * anim, indy - 18 + indanimations.desyncbar * 8), vector(screensizex / 2 + math.floor(visuals.desync_range/4) + 6 * anim + pad1, indy - 16 + indanimations.desyncbar * 8), color(kolor.r, kolor.g, kolor.b, math.floor(indanimations.desyncbar * (1 - anim) * 255 * indanimations.edgy)), color(kolor.r, kolor.g, kolor.b, math.floor(indanimations.desyncbar * (1 - anim) * 255 * indanimations.edgy)), color(kolor.r, kolor.g, kolor.b, math.floor(indanimations.desyncbar * (1 - anim) * 255 * indanimations.edgy)), color(kolor.r, kolor.g, kolor.b, math.floor(indanimations.desyncbar * (1 - anim) * 255 * indanimations.edgy)))
                    --visuals.draw_edgy_line(vector(screensizex / 2 - 15 + pad1, indy - 16 + indanimations.desyncbar * 8), 30, math.floor(indanimations.desyncbar * (1 - anim) * 255 * indanimations.edgy), 1)
                    --render.rect_fade(vector(screensizex / 2 + 6 * anim, indy - 18 + indanimations.desyncbar * 8), vector(math.floor(visuals.desync_range/2) + 6 * anim, 2), color(color.r, color.g, color.b, math.floor(indanimations.desyncbar * 255 * indanimations.edgy)), color(0, 0, 0, 0), true)
                end
                if indanimations.desynctext > 0.1 then
                    render.text(fonts.indedgysmall, vector(screensizex / 2 + pad2, indy + indspace * ind), color(kolor.r, kolor.g, kolor.b, math.floor(255 * indanimations.desynctext * indanimations.edgy)), "c", tostring(visuals.desync_range))
                    ind = ind + indanimations.desynctext
                end
                if indanimations.antibrute > 0.1 then
                    render.text(fonts.indedgysmall, vector(screensizex / 2 + pad_antibrute_text, indy + indspace * ind), color(kolor.r, kolor.g, kolor.b, math.floor(255 * indanimations.antibrute * indanimations.edgy)), "c", "AB "..aa.antibrute_current_stage)
                    if aa.antibrute_timer:get() > 0 then
                        --ind = ind + 0.5 * indanimations.antibrute
                        --render.rect_filled(vector(screensizex / 2 - render.measure_text( fonts.indedgysmall, "AB X" ).x / 2 + pad_antibrute_text, indy + indspace * ind + 1), vector(render.measure_text( fonts.indedgysmall, "AB X" ).x, 3), color(0, 0, 0, math.floor(indanimations.antibrute * 150 * indanimations.edgy)) )
                        render.rect(vector(screensizex / 2 - render.measure_text( fonts.indedgysmall, nil, "AB X" ).x / 2 + pad_antibrute_text, indy + indspace * ind + render.measure_text(fonts.indedgysmall, nil, "AB X").y * 0.45), vector(screensizex / 2 - render.measure_text( fonts.indedgysmall, nil, "AB X" ).x / 2 + pad_antibrute_text + math.floor(antibrute_timer * render.measure_text( fonts.indedgysmall, nil, "AB X" ).x - 2), indy + indspace * ind + render.measure_text(fonts.indedgysmall, nil, "AB X").y * 0.45 + 1), color(kolor.r, kolor.g, kolor.b, math.floor(indanimations.antibrute * 255 * indanimations.edgy)))
                        --ind = ind + 0.5 * indanimations.antibrute
                    end
                    ind = ind + (antibrute_timer > 0 and 1.4 or 1.2) * indanimations.antibrute
                end
                
                --[[if indanimations.dttext > 0.1 then
                    if (rage.exploit:get() < 1) and (refs.dt.on:get() or refs.dt.on:get_override()) then
                        render.text(fonts.indedgysmall, vector(screensizex / 2 + pad3, indy + indspace * ind), color(255, 0, 0, math.floor(255 * indanimations.dttext * indanimations.edgy)), "c", "DT")
                    else
                        render.text(fonts.indedgysmall, vector(screensizex / 2 + pad3, indy + indspace * ind), color(255, 255, 255, math.floor(255 * indanimations.dttext * indanimations.edgy)), "c", "DT")
                    end
                    --render.rect_filled(vector(screensizex / 2 + pad3 - render.measure_text(fonts.indedgysmall, nil, "DT").x * 0.5, indy + (indspace) * ind + render.measure_text(fonts.indedgysmall, nil, "DT").y * 0.45), vector(math.min(math.floor(render.measure_text(fonts.indedgysmall, nil, "DT").x * rage.exploit:get()), render.measure_text(fonts.indedgysmall, nil, "DT").x), 1), color(255, 255, 255, math.floor(255 * indanimations.dttext * indanimations.edgy)))
                    ind = ind + 1 * indanimations.dttext
                end
                if indanimations.hstext > 0.1 then
                    render.text(fonts.indedgysmall, vector(screensizex / 2 + pad4, indy + indspace * ind), color(255, 255, 255, math.floor(255 * indanimations.hstext * indanimations.edgy)), "c", "HS")
                    ind = ind + indanimations.hstext
                end
                if indanimations.aptext > 0.1 then
                    if not visuals.elements:get("Minimum damage") then
                        render.text(fonts.indedgysmall, vector(screensizex / 2 + pad5, indy + indspace * ind), color(255, 255, 255, math.floor(255 * indanimations.aptext * indanimations.edgy)), "c", "AP")
                    elseif not refs.is_overriding_dmg then
                        render.text(fonts.indedgysmall, vector(screensizex / 2 + pad5, indy + indspace * ind), color(255, 255, 255, math.floor(255 * indanimations.aptext * indanimations.edgy)), "c", "AP")
                    end
                end
                if indanimations.dmgtext > 0.1 then
                    if visuals.elements:get("Other indicators") and (refs.ap.on:get() or aim.tick:get()) then
                        render.text(fonts.indedgysmall, vector(screensizex / 2 + pad6, indy + indspace * ind), color(255, 255, 255, math.floor(255 * indanimations.dmgtext * indanimations.edgy)), "c", "AP+DMG: "..tostring(mindmg_override))
                    else render.text(fonts.indedgysmall, vector(screensizex / 2 + pad7, indy + indspace * ind), color(255, 255, 255, math.floor(255 * indanimations.dmgtext * indanimations.edgy)), "c", "DMG: "..tostring(mindmg_override)) end
                    ind = ind + indanimations.dmgtext
                end]]
                if indanimations.dttext > 0.1 then
                    if rage.exploit:get() < 1 and (refs.dt.on:get() or refs.dt.on:get_override()) then
                        render.text(fonts.indedgysmall, vector(screensizex / 2 + indx + pad3, indy + indspace * ind), color(200, 0, 0, math.floor(255 * indanimations.dttext * indanimations.edgy)), "c", "DT")
                    else
                        render.text(fonts.indedgysmall, vector(screensizex / 2 + indx + pad3, indy + indspace * ind), color(kolor.r, kolor.g, kolor.b, math.floor(255 * indanimations.dttext * indanimations.edgy)), "c", "DT")
                    end
                    --render.rect_filled(vector(screensizex / 2 + pad3 - render.measure_text(fonts.pixelretrosmall, "DOUBLE TAP").x * 0.5, indy + (indspace + 1) * ind + render.measure_text(fonts.pixelretrosmall, "DOUBLE TAP").y * 0.4), vector(math.floor(render.measure_text(fonts.pixelretrosmall, "DOUBLE TAP").x / exploits.get_max_charge() * exploits.get_charge()), 1), color(255, 255, 255, math.floor(255 * indanimations.dttext * indanimations.pixel)))
                    --ind = ind + 1 * indanimations.dttext
                end
                local indx = indx + 8 * indanimations.hstext * (1 - anim) + 8 * indanimations.dttext * (1 - anim) + 16 * indanimations.dttext * anim
                --local pad_row = pad4 * indanimations.hstext + 10 * indanimations.hstext
                if indanimations.hstext > 0.1 then
                    local hscol = color(kolor.r, kolor.g, kolor.b, math.floor(255 * indanimations.hstext * indanimations.edgy))
                    local hscol = (refs.dt.on:get() or refs.dt.on:get_override()) and grayscale(hscol) or hscol
                    render.text(fonts.indedgysmall, vector(screensizex / 2 + indx + pad4, indy + indspace * ind), hscol, "c", "HS")
                    --ind = ind + indanimations.hstext
                end
                local indx = indx + 8 * indanimations.hstext * (1 - anim) + 8 * indanimations.aptext * (1 - anim) + 16 * indanimations.hstext * anim
                if indanimations.aptext > 0.1 then
                    render.text(fonts.indedgysmall, vector(screensizex / 2 + indx + pad5, indy + indspace * ind), color(kolor.r, kolor.g, kolor.b, math.floor(255 * indanimations.aptext * indanimations.edgy)), "c", "AP")
                    --ind = ind + indanimations.hstext
                end
            end
        end
    end
end

events.render:set(visuals.draw_indicators)

logs = {}

logs.array = {}
    --{target = "BigCurcan123", hit = true, cause = "", client_damage = 420, server_damage = 420, server_hitbox = 1, client_hitbox = 1, remaining = 69, duration = 7, alpha = 0.1, pos = 0},
    --{target = "BigCurcan456", hit = false, cause = "spread", client_damage = 420, server_damage = 420, server_hitbox = 1, client_hitbox = 1, remaining = 1024, duration = 7, alpha = 0.1, pos = 0},
--}

logs.add = function(target, hit, cause, client_damage, server_damage, client_hitbox, server_hitbox, hitchance, remaining)
    table.insert(logs.array, 1, {target = target, hit = hit, cause = cause, client_damage = client_damage, server_damage = server_damage, client_hitbox = client_hitbox, server_hitbox = server_hitbox, hitchance = hitchance, remaining = remaining, duration = visuals.logs_duration:get(), alpha = 0.1, pos = 0})
    table.insert(aainfo.logs_array, 1, {target = target, hit = hit, cause = cause, client_damage = client_damage, server_damage = server_damage, client_hitbox = client_hitbox, server_hitbox = server_hitbox, hitchance = hitchance, remaining = remaining, duration = visuals.logs_duration:get(), alpha = 0.1, pos = 0})
end

--[[logs.button = vs_debug:button_e("[DEBUG] Add new log", function()
    logs.add("BigCurcan123", true,  "",  420,  420,  0, 0, 69, 69)
end)]]
--logs.add("BigCurcan123", true,  "",  420,  420,  0, 0, 69, 69)

logs.offset = 0

--[[logs.draw_side_logs = function()
    logs.offset = 175
    local hit_color = visuals.themecol:get()
    local miss_color = color(200, 10, 10)
    for i = 1, #logs.array do
        local pad = 0
        local dist = 0
        local color = logs.array[i].hit and hit_color or miss_color
        render.rect_filled(vector(screensizex / 2 + 50 + logs.offset * i, screensizey / 2 - 24), vector(150, 74), color(45, 45, 45), 8)
        render.rect_filled(vector(screensizex / 2 + 50 + logs.offset * i + 8, screensizey / 2 + 74 - 24 - 10), vector(134, 4), color, 2)
        render.text(fonts.noto_semi_bold, "Target: ", vector(screensizex / 2 + 50 + logs.offset * i + 12, screensizey / 2 - 24 - 4 + 12 + pad * 14), color(255, 255, 255))
        dist = render.measure_text(fonts.noto_semi_bold, "Target: ").x
        render.text(fonts.noto_semi_bold, logs.array[i].target, vector(screensizex / 2 + 50 + logs.offset * i + 12 + dist, screensizey / 2 - 24 - 4 + 12 + pad * 14), color)
        pad = pad + 1
        render.text(fonts.noto_semi_bold, "Hit: ", vector(screensizex / 2 + 50 + logs.offset * i + 12, screensizey / 2 - 24 - 4 + 12 + pad * 14), color(255, 255, 255))
        dist = render.measure_text(fonts.noto_semi_bold, "Hit: ").x
        render.text(fonts.noto_semi_bold, tostring(logs.array[i].hit), vector(screensizex / 2 + 50 + logs.offset * i + 12 + dist, screensizey / 2 - 24 - 4 + 12 + pad * 14), color)
        pad = pad + 1
        if logs.array[i].hit then
            render.text(fonts.noto_semi_bold, "Damage: ", vector(screensizex / 2 + 50 + logs.offset * i + 12, screensizey / 2 - 24 - 4 + 12 + pad * 14), color(255, 255, 255))
            dist = render.measure_text(fonts.noto_semi_bold, "Damage: ").x
            render.text(fonts.noto_semi_bold, logs.array[i].damage, vector(screensizex / 2 + 50 + logs.offset * i + 12 + dist, screensizey / 2 - 24 - 4 + 12 + pad * 14), color)
            dist = dist + render.measure_text(fonts.noto_semi_bold, logs.array[i].damage).x
            render.text(fonts.noto_semi_bold, " in ", vector(screensizex / 2 + 50 + logs.offset * i + 12 + dist, screensizey / 2 - 24 - 4 + 12 + pad * 14), color(255, 255, 255))
            dist = dist + render.measure_text(fonts.noto_semi_bold, " in ").x
            render.text(fonts.noto_semi_bold, logs.array[i].hitbox, vector(screensizex / 2 + 50 + logs.offset * i + 12 + dist, screensizey / 2 - 24 - 4 + 12 + pad * 14), color)
        else
            render.text(fonts.noto_semi_bold, "Cause: ", vector(screensizex / 2 + 50 + logs.offset * i + 12, screensizey / 2 - 24 - 4 + 12 + pad * 14), color(255, 255, 255))
            dist = render.measure_text(fonts.noto_semi_bold, "Cause: ").x
            render.text(fonts.noto_semi_bold, logs.array[i].cause, vector(screensizex / 2 + 50 + logs.offset * i + 12 + dist, screensizey / 2 - 24 - 4 + 12 + pad * 14), color)
        end
    end
end

callbacks.add(e_callbacks.PAINT, logs.draw_side_logs)]]

local hitgroup_name = {
    [0] = 'generic',
    [1] = 'head',
    [2] = 'chest',
    [3] = 'stomach',
    [4] = 'left arm',
    [5] = 'right arm',
    [6] = 'left leg',
    [7] = 'right leg',
    [8] = 'neck',
    [9] = 'generic',
    [10] = 'gear'
}

--[[logs.last_hitchance = 0

logs.shot_listener = function(shot)
    if visuals.logs:get() == 1 then return end
    logs.last_hitchance =  shot.hitchance
end

callbacks.add(e_callbacks.AIMBOT_SHOOT, logs.shot_listener)

logs.hit_listener = function(shot)
    if visuals.logs:get() == 1 then return end
    logs.add(shot.player:get_name(), true, "", shot.aim_damage, shot.damage, hitgroup_name[shot.aim_hitgroup], hitgroup_name[shot.hitgroup], logs.last_hitchance, shot.player:get_prop("m_iHealth"))
end

callbacks.add(e_callbacks.AIMBOT_HIT, logs.hit_listener)

logs.miss_listener = function(shot)
    if visuals.logs:get() == 1 then return end
    logs.add(shot.player:get_name(), false, shot.reason_string, 0, shot.aim_damage, 0, hitgroup_name[shot.aim_hitgroup], logs.last_hitchance, shot.player:get_prop("m_iHealth"))
end

callbacks.add(e_callbacks.AIMBOT_MISS, logs.miss_listener)

logs.hurt_listener = function(shot)
    if visuals.logs:get() == 1 then return end
    local lp = entity_list.get_local_player()
    if not lp then return end
    if (lp:get_prop("m_iHealth") <= 0) then return end
    if entity_list.get_player_from_userid(shot.userid) == nil or entity_list.get_player_from_userid(shot.attacker) == nil then return end
    if not (entity_list.get_player_from_userid(shot.userid):get_name() == lp:get_name()) then return end
    local attacker = entity_list.get_player_from_userid(shot.attacker):get_name()
    logs.add(attacker, "hurt", "", shot.dmg_health, shot.dmg_health, hitgroup_name[shot.hitgroup], hitgroup_name[shot.hitgroup], 0, shot.health)
end

callbacks.add(e_callbacks.EVENT, logs.hurt_listener, "player_hurt")]]

--[[local segments = {
        {" | Opium.sys » ", true},
        {hit == true and "Hit " or (hit == "hurt") and "Harmed by " or "Missed ", false},
        {target, true},
        {" in the ", false},
        {server_hitbox, true},
        {" for ", false},
        {server_damage, true},
        {((hit and (remaining > 0)) or not hit) and " (" or "", false},
        {(hit and (remaining > 0) and (server_damage ~= client_damage or server_hitbox ~= client_hitbox)) and "aimed" or "", false},
        {(hit and (remaining > 0) and server_hitbox ~= client_hitbox) and " at " or "", false},
        {(hit and (remaining > 0) and server_hitbox ~= client_hitbox) and client_hitbox or "", true},
        {(hit and (remaining > 0) and server_damage ~= client_damage) and " for " or "", false},
        {(hit and (remaining > 0) and server_damage ~= client_damage) and client_damage or "", true},
        {(hit and (remaining > 0) and (server_damage ~= client_damage or server_hitbox ~= client_hitbox)) and ", " or "", false},
        {hit and (remaining > 0) and "remaining: " or "", false},
        {hit and (remaining > 0) and remaining or "", true},
        {(not hit) and "cause: " or "", false},
        {(not hit) and cause or "", true},
        {(not hit and (cause == "spread" or cause == "spread (missed safe)")) and ", hitchance: " or "", false},
        {(not hit and (cause == "spread" or cause == "spread (missed safe)")) and hitchance or "", true},
        {((hit and (remaining > 0)) or not hit) and ")" or "", false},
    }]]

logs.print_log = function(target, hit, cause, client_damage, server_damage, client_hitbox, server_hitbox, hitchance, spread, backtrack, remaining)
    local white = concolor(color(255, 255, 255)).."FF"
    local hit_color = concolor(visuals.themecol:get()).."FF"
    local miss_color = concolor(color(200, 10, 10)).."FF"
    --local action = (hit == true) and "Hit " or (hit == false) and "Missed " or (hit == "hurt") and "Hurt by"
    --local logstring = "\a"..kolor.."Opium.sys » ".."\a"..white..action.."\a"..kolor..target
    --local backtrack = ticks_to_time(backtrack*100).."ms"
    local backtrack = backtrack.." ticks"
    local segments = {
        {" | Opium.sys » ", true},
        {hit == true and "Hit " or (hit == "hurt") and "Harmed by " or "Missed ", false},
        {target, true},
        {" in the ", false},
        {server_hitbox, true},
        {" for ", false},
        {server_damage, true},
        {(hit == "hurt" and remaining <= 0) and "" or " (", false},
        {(hit and (remaining > 0) and (server_damage ~= client_damage or server_hitbox ~= client_hitbox)) and "aimed" or "", false},
        {(hit and (remaining > 0) and server_hitbox ~= client_hitbox) and " at " or "", false},
        {(hit and (remaining > 0) and server_hitbox ~= client_hitbox) and client_hitbox or "", true},
        {(hit and (remaining > 0) and server_damage ~= client_damage) and " for " or "", false},
        {(hit and (remaining > 0) and server_damage ~= client_damage) and client_damage or "", true},
        {(hit and (remaining > 0) and (server_damage ~= client_damage or server_hitbox ~= client_hitbox)) and ", " or "", false},
        {hit and (remaining > 0) and "remaining: " or "", false},
        {hit and (remaining > 0) and remaining or "", true},
        {(not hit) and "cause: " or "", false},
        {(not hit) and cause or "", true},
        {hit ~= "hurt" and ((hit and (remaining > 0) or not hit)) and ", " or "", false},
        {hit == "hurt" and "" or "hitchance: " or "", false},
        {hit == "hurt" and "" or hitchance or "", true},
        {hit == "hurt" and "" or ", backtrack: ", false},
        {hit == "hurt" and "" or backtrack, true},
        {(hit == "hurt" and remaining <= 0) and "" or ")", false},
    }
    local logstring = ""
    for i = 1, #segments do
        kolor = segments[i][2] and (hit == true and hit_color or miss_color) or white
        logstring = logstring.."\a"..kolor..segments[i][1]
    end
    print_raw(logstring)
end

logs.sum = {}
logs.sum_timer = -1
logs.summed = false

logs.print_summary = function()
    if logs.sum_timer < 0 then return end
    logs.sum_timer = logs.sum_timer + 1
    if logs.sum_timer < 10 then return end
    if not visuals.logs_shown:get(3) then return end
    kolor = visuals.themecol:get()
    local kolor = "\a"..concolor(kolor).."FF"
    local white = "\aFFFFFFFF"
    --if not (#logs.sum > 0) then return end
    if not logs.summed then return end
    print_raw(kolor.." | Opium.sys » "..white.."Round summary:")
    for k in pairs(logs.sum) do
        local log = logs.sum[k]
        kolor = (log.killer == 1) and "\aFF0000FF" or kolor
        print_raw(kolor.."  » "..white..k)
        print_raw(kolor.."      - "..white.."Misses: "..kolor..log.misses)
        --print_raw(kolor.."      - "..white.."Hits: "..kolor.."9")
        if log.dmg_g > 0 then
            print_raw(kolor.."      - "..white.."Damage given: "..kolor..log.dmg_g..white.." in "..kolor..log.hits_g..white.." hits")
        end
        if log.dmg_r > 0 then
            print_raw(kolor.."      - "..white.."Damage taken: "..kolor..log.dmg_r..white.." in "..kolor..log.hits_r..white.." hits")
        end
    end
    logs.sum = {}
    logs.sum_timer = -1
    logs.summed = false
end

events.render:set(logs.print_summary)

--logs.print_summary(visuals.themecol:get())

--logs.print_log("Bigtoolvarer420", false, "spread", 420, 1337, hitgroup_name[1], hitgroup_name[2], 69, 100, 30, 1)
--logs.print_log("Bigtoolvarer420", true, "", 420, 1337, hitgroup_name[1], hitgroup_name[2], 69, 100, 30, 1)
--logs.print_log("Bigtoolvarer420", "hurt", "", 420, 1337, hitgroup_name[1], hitgroup_name[2], 69, 100, 30, 1)

logs.shot_listener = function(shot)
    if shot.state == nil and (visuals.logs_shown:get(1) or visuals.infopanel:get() == "Info menu") then
        if visuals.logs:get(1) then
            logs.add(shot.target:get_name(), true, "", shot.wanted_damage, shot.damage, hitgroup_name[shot.wanted_hitgroup], hitgroup_name[shot.hitgroup], shot.hitchance, shot.target.m_iHealth)
        end
        if visuals.logs:get(2) then
            logs.print_log(shot.target:get_name(), true, "", shot.wanted_damage, shot.damage, hitgroup_name[shot.wanted_hitgroup], hitgroup_name[shot.hitgroup], shot.hitchance, shot.spread, shot.backtrack, shot.target.m_iHealth)
        end
    elseif visuals.logs_shown:get(2) then
        if visuals.logs:get(1) then
            logs.add(shot.target:get_name(), false, shot.state, 0, shot.wanted_damage, 0, hitgroup_name[shot.wanted_hitgroup], shot.hitchance, shot.target.m_iHealth)
        end
        if visuals.logs:get(2) then
            logs.print_log(shot.target:get_name(), false, shot.state, 0, shot.wanted_damage, 0, hitgroup_name[shot.wanted_hitgroup], shot.hitchance, shot.spread, shot.backtrack, shot.target.m_iHealth)
        end
    end
    if not logs.sum[shot.target:get_name()] then
        logs.summed = true
        logs.sum[shot.target:get_name()] = {
            misses = 0,
            dmg_g = 0,
            hits_g = 0,
            dmg_r = 0,
            hits_r = 0,
            killer = 0,
        }
    end
    if shot.state == nil then
        logs.sum[shot.target:get_name()].hits_g = logs.sum[shot.target:get_name()].hits_g + 1
        logs.sum[shot.target:get_name()].dmg_g = logs.sum[shot.target:get_name()].dmg_g + shot.damage
    else
        logs.sum[shot.target:get_name()].misses = logs.sum[shot.target:get_name()].misses + 1
    end
end

events.aim_ack:set(function(shot)
    if aim.tick:get() and (refs.dt.on:get() or refs.dt.on:get_override()) then
        rage.exploit:force_teleport()
        rage.exploit:force_charge()
        aim.ideal_tp = true
        aim.tp_tick = 0
    end
    logs.shot_listener(shot)
    if visuals.sparks:get() and not shot.state then effects.sparks(shot.aim, 3, 1, visuals.sparkscol:get()) end
end)

logs.hurt_listener = function(shot)
    local lp = entity.get_local_player()
    if not lp then return end
    --if (lp.m_iHealth <= 0) then return end
    if entity.get(shot.userid, true) == nil or entity.get(shot.attacker, true) == nil then return end
    if not (entity.get(shot.userid, true):get_name() == lp:get_name()) then return end
    local attacker = entity.get(shot.attacker, true):get_name()
    if visuals.logs:get(1) or visuals.infopanel:get() == "Info menu" then
        logs.add(attacker, "hurt", "", shot.dmg_health, shot.dmg_health, hitgroup_name[shot.hitgroup], hitgroup_name[shot.hitgroup], 0, shot.health)
    end
    if visuals.logs:get(2) then
        logs.print_log(attacker, "hurt", "", shot.dmg_health, shot.dmg_health, hitgroup_name[shot.hitgroup], hitgroup_name[shot.hitgroup], 0, 0, 0, shot.health)
    end
    if misc.vw:get() then
        if shot.hitgroup == 1 then
            utils.console_exec("play vwhs.wav")
        else
            utils.console_exec("play vwbaim.wav")
        end
    end
    if not logs.sum[attacker] then
        logs.summed = true
        logs.sum[attacker] = {
            misses = 0,
            dmg_g = 0,
            hits_g = 0,
            dmg_r = 0,
            hits_r = 0,
            killer = 0,
        }
    end
    logs.sum[attacker].hits_r = logs.sum[attacker].hits_r + 1
    logs.sum[attacker].dmg_r = logs.sum[attacker].dmg_r + shot.dmg_health
end

events.player_hurt:set(function(shot)
    logs.hurt_listener(shot)
end)

events.player_death:set(function(ev)
    if entity.get(ev.userid, true) == entity.get_local_player() and logs.sum[entity.get(ev.attacker, true):get_name()] then
        logs.sum[entity.get(ev.attacker, true):get_name()].killer = 1
        --logs.print_summary()
        logs.sum_timer = 0
    end
end)

events.round_end:set(function(ev)
    if entity.get_local_player():is_alive() then
        --logs.print_summary()
        logs.sum_timer = 0
    end
end)

logs.distance = 0

--logs.add("BigCurcan123", true,  "",  420,  420,  0, 0, 69, 69)

logs.draw_crosshair_logs = function()
    if not globals.is_in_game then return end
    if not visuals.logs:get(1) then return end
    if not (#logs.array > 0) then return end
    logs.offset = visuals.logs_offset:get()
    pad = (visuals.cur_theme == "Solus v2" or visuals.cur_theme == "Default " or visuals.cur_theme == "Alt") and 1 or 0
    logs.distance = lerp2(logs.distance, visuals.logs_bg:get() and 36 or 18, globals.frametime * 7)
    for i = 1, #logs.array do
        if (logs.array[i] == nil or (logs.array[i].alpha <= 0)) then table.remove(logs.array) goto skiplog end
        local log = logs.array[i]
        --print(log.client_hitbox)
        log.duration = log.duration - globals.frametime
        local duration = log.duration / visuals.logs_duration:get()
        log.alpha = lerp2(log.alpha, log.duration >= 0 and 255 or -0.1, globals.frametime * 7)
        local hit_color = visuals.themecol:get()
        local miss_color = color(200, 10, 10)
        --hit_color.a = math.max(math.floor(log.alpha), 0)
        --miss_color.a = math.max(math.floor(log.alpha), 0)
        local kolor = log.hit == true and hit_color or miss_color
        kolor.a = math.max(math.floor(log.alpha), 0)
        local white = visuals.cur_theme ~= "Modern " and color(255, 255, 255, kolor.a) or lighten(kolor, 75, -30)
        --local white = color(255, 255, 255, kolor.a)
        --if log.alpha <= 0 then table.remove(logs.array) end
        log.pos = lerp2(log.pos, log.duration >= 0 and i or i + 1, globals.frametime * 7)
        local pos = math.floor(log.pos * logs.distance)
        if (screensizey / 2 + logs.offset + pos + 54 > screensizey) then log.duration = -1 end
        --print(duration)
        local segments = {
            (visuals.cur_theme ~= "Modern " and visuals.cur_theme ~= "Default " and visuals.cur_theme ~= "Alpha ") and {"(", false} or {"", false},
            --{"(", false},
            {"Opium", true},
            --{") ", false},
            (visuals.cur_theme ~= "Modern " and visuals.cur_theme ~= "Default " and visuals.cur_theme ~= "Alpha ") and {") ", false} or {" » ", true},
            {log.hit == true and "Hit " or (log.hit == "hurt") and "Harmed by " or "Missed ", false},
            {log.target, true},
            {" in the ", false},
            {log.server_hitbox, true},
            {" for ", false},
            {log.server_damage, true},
            {((log.hit and (log.remaining > 0)) or not log.hit) and " (" or "", false},
            {(log.hit and (log.remaining > 0) and (log.server_damage ~= log.client_damage or log.server_hitbox ~= log.client_hitbox)) and "aimed" or "", false},
            {(log.hit and (log.remaining > 0) and log.server_hitbox ~= log.client_hitbox) and " at " or "", false},
            {(log.hit and (log.remaining > 0) and log.server_hitbox ~= log.client_hitbox) and log.client_hitbox or "", true},
            {(log.hit and (log.remaining > 0) and log.server_damage ~= log.client_damage) and " for " or "", false},
            {(log.hit and (log.remaining > 0) and log.server_damage ~= log.client_damage) and log.client_damage or "", true},
            {(log.hit and (log.remaining > 0) and (log.server_damage ~= log.client_damage or log.server_hitbox ~= log.client_hitbox)) and ", " or "", false},
            {log.hit and (log.remaining > 0) and "remaining: " or "", false},
            {log.hit and (log.remaining > 0) and log.remaining or "", true},
            {(not log.hit) and "cause: " or "", false},
            {(not log.hit) and log.cause or "", true},
            {(not log.hit and (log.cause == "spread" or log.cause == "spread (missed safe)")) and ", hitchance: " or "", false},
            {(not log.hit and (log.cause == "spread" or log.cause == "spread (missed safe)")) and log.hitchance or "", true},
            {((log.hit and (log.remaining > 0)) or not log.hit) and ")" or "", false},
        }
        local log_width = 0
        local log_pad = 0
        for n = 1, #segments do
            log_width = log_width + render.measure_text(fonts.default_font, nil, tostring(segments[n][1])).x
        end
        --render.rect_filled(vector(screensizex / 2 - log_width / 2 - 7, screensizey / 2 + logs.offset + 32 * i - 3), vector(log_width + 14, 28), color(45, 45, 45), 8)
        if visuals.logs_bg:get() then
            if visuals.cur_theme == "Modern " then
                visuals.draw_modern_box(vector(screensizex / 2 - log_width / 2 - 6 - 10, screensizey / 2 + logs.offset + pos - 4), vector(- 2 + log_width + 14 + 20, 29), kolor.a, nil, true)
                --render.shadow(vector(screensizex / 2 - log_width / 2 - 6 - 10, screensizey / 2 + logs.offset + pos - 4), vector(screensizex / 2 - log_width / 2 - 8 - 10 + log_width + 14 + 20, screensizey / 2 + logs.offset + pos - 4 + 29), color(kolor.r, kolor.g, kolor.b, math.min(255, kolor.a*0.35)), 100, 0, 8)
                --render.blur(vector(screensizex / 2 - log_width / 2 - 7 - 10, screensizey / 2 + logs.offset + pos - 3), vector(screensizex / 2 - log_width / 2 - 7 - 10 + log_width + 14 + 20, screensizey / 2 + logs.offset + pos - 3 + 29), 0.5, math.min((kolor.a * 8 / 255), 255), 8)
                --render.rect(vector(screensizex / 2 - log_width / 2 - 7 - 10, screensizey / 2 + logs.offset + pos - 3), vector(screensizex / 2 - log_width / 2 - 7 - 10 + log_width + 14 + 20, screensizey / 2 + logs.offset + pos - 3 + 29), color(45, 45, 45, math.floor(kolor.a)), 8)
            else
                visuals.draw_custom_box(vector(screensizex / 2 - log_width / 2 - 7 - 10, screensizey / 2 + logs.offset + pos - 3), vector(log_width + 14 + 20, 28), math.floor(kolor.a), 28, kolor)
            end
        end
        for n = 1, #segments do
            render.text(fonts.default_font, vector(screensizex / 2 - log_width / 2 + log_pad - 10, screensizey / 2 + logs.offset + pos + pad + 4), segments[n][2] and kolor or white, nil, tostring(segments[n][1]))
            log_pad = log_pad + render.measure_text(fonts.default_font, nil, tostring(segments[n][1])).x
        end
        --render.progress_circle(vector(screensizex / 2 + log_width / 2 + 2, screensizey / 2 + logs.offset + pos + 10), 4, color, 2, duration)
        render.circle_outline(vector(screensizex / 2 + log_width / 2 + 2, screensizey / 2 + logs.offset + pos + 11), kolor, 6, 0, duration, 2)
        ::skiplog::
        --fonts.noto_semi_bold
    end
end

logs.draw_panel_logs = function()
    
    if not (visuals.infopanel:get() == "Info menu") then return end
    if not (aainfo.tab == 3) then return end
    if not (#aainfo.logs_array > 0) then
        local kolor = color(visuals.themecol:get().r, visuals.themecol:get().g, visuals.themecol:get().b, aainfo.alpha * 255)
        local white = (visuals.cur_theme == "Modern " or visuals.cur_theme == "Alpha ") and lighten(kolor, 50) or color(255, 255, 255, aainfo.alpha * 255)
        render.text(fonts.default_font, vector(aainfo.pos.x + aainfo.tabs[3].width / 2, aainfo.pos.y + 9 + aainfo.tabs[3].height / 2), white, "c", "Your ragebot logs\nwill appear here.")    
        return
    end
    if not globals.is_in_game then aainfo.logs_array = {} return end
    logs.offset = visuals.logs_offset:get()
    logs.distance = lerp2(logs.distance, visuals.logs_bg:get() and 36 or 18, globals.frametime * 7)
    for i = 1, #aainfo.logs_array do
        if (aainfo.logs_array[i] == nil or (aainfo.logs_array[i].alpha <= 0)) then table.remove(aainfo.logs_array) goto skiplog end
        local log = aainfo.logs_array[i]
        --print(log.client_hitbox)
        --log.duration = log.duration - globals.frametime
        --local duration = log.duration / visuals.logs_duration:get()
        log.alpha = lerp2(log.alpha, log.duration >= 0 and 255 or -0.1, globals.frametime * 7)
        local hit_color = visuals.themecol:get()
        local miss_color = color(200, 10, 10)
        hit_color.a = math.max(math.floor(log.alpha), 0)
        miss_color.a = math.max(math.floor(log.alpha), 0)
        --local kolor = hit_color
        local kolor = log.hit == true and hit_color or miss_color
        kolor.a = math.max(math.floor(log.alpha), 0)
        local white = (visuals.cur_theme ~= "Modern " and visuals.cur_theme ~= "Alpha ") and color(255, 255, 255, kolor.a) or lighten(kolor, 50)
        --local white = color(255, 255, 255, kolor.a)
        --if log.alpha <= 0 then table.remove(logs.array) end
        if (i > 2) then log.duration = -1 end
        --print(duration)
        local segments = {}
        --[[local segments = {
            (visuals.cur_theme ~= "Modern " and visuals.cur_theme ~= "Alpha ") and {"(", false} or {"", false},
            --{"(", false},
            {"Opium", true},
            --{") ", false},
            (visuals.cur_theme ~= "Modern " and visuals.cur_theme ~= "Alpha ") and {") ", false} or {" » ", true},
            {log.hit == true and "Hit " or (log.hit == "hurt") and "Harmed by " or "Missed ", false},
            {log.target, true},
            {" in the ", false},
            {log.server_hitbox, true},
            {" for ", false},
            {log.server_damage, true},
            {((log.hit and (log.remaining > 0)) or not log.hit) and " (" or "", false},
            {(log.hit and (log.remaining > 0) and (log.server_damage ~= log.client_damage or log.server_hitbox ~= log.client_hitbox)) and "aimed" or "", false},
            {(log.hit and (log.remaining > 0) and log.server_hitbox ~= log.client_hitbox) and " at " or "", false},
            {(log.hit and (log.remaining > 0) and log.server_hitbox ~= log.client_hitbox) and log.client_hitbox or "", true},
            {(log.hit and (log.remaining > 0) and log.server_damage ~= log.client_damage) and " for " or "", false},
            {(log.hit and (log.remaining > 0) and log.server_damage ~= log.client_damage) and log.client_damage or "", true},
            {(log.hit and (log.remaining > 0) and (log.server_damage ~= log.client_damage or log.server_hitbox ~= log.client_hitbox)) and ", " or "", false},
            {log.hit and (log.remaining > 0) and "remaining: " or "", false},
            {log.hit and (log.remaining > 0) and log.remaining or "", true},
            {(not log.hit) and "cause: " or "", false},
            {(not log.hit) and log.cause or "", true},
            {(not log.hit and (log.cause == "spread" or log.cause == "spread (missed safe)")) and ", hitchance: " or "", false},
            {(not log.hit and (log.cause == "spread" or log.cause == "spread (missed safe)")) and log.hitchance or "", true},
            {((log.hit and (log.remaining > 0)) or not log.hit) and ")" or "", false},
        }
        local log_width = 0
        local log_pad = 0
        for n = 1, #segments do
            log_width = log_width + render.measure_text(fonts.default_font, nil, tostring(segments[n][1])).x
        end]]
        --render.rect_filled(vector(screensizex / 2 - log_width / 2 - 7, screensizey / 2 + logs.offset + 32 * i - 3), vector(log_width + 14, 28), color(45, 45, 45), 8)
        local log_width = 0
        local log_pad = 0
        local ind = 0
        local indpad = 12
        log.pos = 5 * indpad
        log.pos = (log.remaining > 0) and log.pos + indpad or log.pos
        log.pos = (not log.hit) and log.pos + indpad or log.pos
        local pos = i > 1 and aainfo.logs_array[i-1].pos or 0
        render.text(fonts.default_font, vector(aainfo.pos.x + 10, aainfo.pos.y + 32 + pos + ind), white, nil, "target: ")
        render.text(fonts.default_font, vector(aainfo.pos.x + 10 + render.measure_text(fonts.default_font, nil, "target: ").x, aainfo.pos.y + 32 + pos + ind), kolor, nil, log.target)
        ind = ind + indpad
        render.text(fonts.default_font, vector(aainfo.pos.x + 10, aainfo.pos.y + 32 + pos + ind), white, nil, "result: ")
        render.text(fonts.default_font, vector(aainfo.pos.x + 10 + render.measure_text(fonts.default_font, nil, "result: ").x, aainfo.pos.y + 32 + pos + ind), kolor, nil, tostring(log.hit))
        ind = ind + indpad
        render.text(fonts.default_font, vector(aainfo.pos.x + 10, aainfo.pos.y + 32 + pos + ind), white, nil, "hitgroup: ")
        render.text(fonts.default_font, vector(aainfo.pos.x + 10 + render.measure_text(fonts.default_font, nil, "hitgroup: ").x, aainfo.pos.y + 32 + pos + ind), kolor, nil, log.server_hitbox)
        ind = ind + indpad
        render.text(fonts.default_font, vector(aainfo.pos.x + 10, aainfo.pos.y + 32 + pos + ind), white, nil, "damage: ")
        render.text(fonts.default_font, vector(aainfo.pos.x + 10 + render.measure_text(fonts.default_font, nil, "damage: ").x, aainfo.pos.y + 32 + pos + ind), kolor, nil, log.server_damage)
        ind = ind + indpad
        if log.remaining > 0 then
            render.text(fonts.default_font, vector(aainfo.pos.x + 10, aainfo.pos.y + 32 + pos + ind), white, nil, "remaining: ")
            render.text(fonts.default_font, vector(aainfo.pos.x + 10 + render.measure_text(fonts.default_font, nil, "remaining: ").x, aainfo.pos.y + 32 + pos + ind), kolor, nil, log.remaining)
            ind = ind + indpad
        end
        if(not log.hit) then
            render.text(fonts.default_font, vector(aainfo.pos.x + 10, aainfo.pos.y + 32 + pos + ind), white, nil, "cause: ")
            render.text(fonts.default_font, vector(aainfo.pos.x + 10 + render.measure_text(fonts.default_font, nil, "cause: ").x, aainfo.pos.y + 32 + pos + ind), kolor, nil, log.cause)
            ind = ind + indpad
        end
        if i == #aainfo.logs_array then
            aainfo.tabs[3].height = 32 + pos + ind + indpad
        end
        if i == #aainfo.logs_array then
            aainfo.tabs[3].width = lerp(aainfo.tabs[3].width, math.max(100, render.measure_text(fonts.default_font, nil, "target: "..log.target).x, render.measure_text(fonts.default_font, nil, "cause: "..log.cause).x, render.measure_text(fonts.default_font, nil, "hitgroup: "..log.server_hitbox).x, render.measure_text(fonts.default_font, nil, "target: "..aainfo.logs_array[1].target).x, render.measure_text(fonts.default_font, nil, "cause: "..aainfo.logs_array[1].cause).x, render.measure_text(fonts.default_font, nil, "hitgroup: "..aainfo.logs_array[1].server_hitbox).x) + 25, 15)
        end
        --[[if visuals.logs_bg:get() then
            if visuals.cur_theme == "Modern " then
                render.shadow(vector(screensizex / 2 - log_width / 2 - 7 - 10, screensizey / 2 + logs.offset + pos - 3), vector(screensizex / 2 - log_width / 2 - 7 - 10 + log_width + 14, screensizey / 2 + logs.offset + pos - 3 + 29), color(kolor.r, kolor.g, kolor.b, math.min(255, kolor.a*0.35)), 100, 0, 8)
                render.blur(vector(screensizex / 2 - log_width / 2 - 7 - 10, screensizey / 2 + logs.offset + pos - 3), vector(screensizex / 2 - log_width / 2 - 7 - 10 + log_width + 14, screensizey / 2 + logs.offset + pos - 3 + 29), 100, math.min((kolor.a * 2 / 255), 255), 8)
                render.rect(vector(screensizex / 2 - log_width / 2 - 7 - 10, screensizey / 2 + logs.offset + pos - 3), vector(screensizex / 2 - log_width / 2 - 7 - 10 + log_width + 14, screensizey / 2 + logs.offset + pos - 3 + 29), color(45, 45, 45, math.floor(kolor.a/255)), 8)
            else
                visuals.draw_custom_box(vector(screensizex / 2 - log_width / 2 - 7 - 10, screensizey / 2 + logs.offset + pos - 3), vector(log_width + 14, 28), math.floor(kolor.a), 28, kolor)
            end
        end
        for n = 1, #segments do
            render.text(fonts.default_font, vector(screensizex / 2 - log_width / 2 + log_pad - 10, screensizey / 2 + logs.offset + pos + 4), segments[n][2] and kolor or white, nil, tostring(segments[n][1]))
            log_pad = log_pad + render.measure_text(fonts.default_font, nil, tostring(segments[n][1])).x
        end]]
        --render.progress_circle(vector(screensizex / 2 + log_width / 2 + 2, screensizey / 2 + logs.offset + pos + 10), 4, color, 2, duration)
        --render.circle_outline(vector(screensizex / 2 + log_width / 2 + 2, screensizey / 2 + logs.offset + pos + 11), kolor, 6, 0, duration, 2)
        ::skiplog::
        --fonts.noto_semi_bold
    end
end

events.render:set(logs.draw_crosshair_logs)
events.render:set(logs.draw_panel_logs)

local on_plant_time, fill, planting_site, planting = 0, 0, "", false

visuals.draw_gs_ind = function(text, ay, kolor, size, font)
    local x, y = screensizex/100 + 10, screensizey/1.41 - 38
    ts = render.measure_text(font, nil, text)
    render.gradient(vector(0, y + ay), vector(x, y + ay + 33), color(0, 0, 0, 0), color(0, 0, 0, 65), color(0, 0, 0, 0), color(0, 0, 0, 65))
    render.gradient(vector(x, y + ay), vector(2*x + (ts.x), y + ay + 33), color(0, 0, 0, 65), color(0, 0, 0, 0), color(0, 0, 0, 65), color(0, 0, 0, 0))
    render.text(font, vector(x+1, y + 9 + ay), color(0, 0, 0, 100), nil, text)
    render.text(font, vector(x, y + 8 + ay), kolor, nil, text)
end

events.render:set(function()

    if not visuals.gs_inds:get() then return end

    local lp = entity.get_local_player()
    if not lp then return end

    local x, y = screensizex/100 + 10, screensizey/1.41 - 38
    local ay = 0
    local dmg = refs.is_overriding_dmg
    local hc = refs.is_overriding_hc

    if refs.ping:get() > 0 and visuals.gs_inds_elems:get(3) then
        local net = utils.net_channel()
        local outgoing, incoming = net.latency[0], net.latency[1]
        local ping = math.max(0, (incoming-outgoing)*1000)
        local ping = entity.get_player_resource().m_iPing[lp:get_index()] - ping - 5
        --local ping = 165
        local pingcol = color(math.floor(255 - ((ping / refs.ping:get() * 60) * 2.29824561404)), math.floor((ping / refs.ping:get() * 60) * 3.42105263158), math.floor((ping / refs.ping:get() * 60) * 0.22807017543), 255)
        visuals.draw_gs_ind("PING", ay, pingcol, 22, fonts.skeetind)
        ay = ay - 41
    end

    if refs.fd:get() and visuals.gs_inds_elems:get(5) then
        visuals.draw_gs_ind("DUCK", ay, color(220, 220, 220, 255), 22, fonts.skeetind)
        ay = ay - 41
    end

    if not refs.fd:get() and not refs.dt.on:get() and refs.hs.on:get() and visuals.gs_inds_elems:get(7) then
        visuals.draw_gs_ind("OSAA", ay, color(220, 220, 220, 255), 22, fonts.skeetind)
        ay = ay - 41
    end

    if not refs.fd:get() and refs.dt.on:get() and visuals.gs_inds_elems:get(4) then
        visuals.draw_gs_ind("DT", ay, rage.exploit:get() == 1 and color(220, 220, 220, 255) or color(255, 0, 50, 255), 22, fonts.skeetind)
        ay = ay - 41
    end

    if refs.sp:get() == "Force" and visuals.gs_inds_elems:get(1) then
        visuals.draw_gs_ind("SAFE", ay, color(220, 220, 220, 255), 22, fonts.skeetind)
        ay = ay - 41
    end

    if refs.dormant:get() and visuals.gs_inds_elems:get(9) then
        local t = entity.get_threat()
        local c = color(220, 220, 220, 255)
        if t then
            c = t:is_dormant() and color(255, 0, 50, 255) or c
        end
        visuals.draw_gs_ind("DA", ay, c, 22, fonts.skeetind)
        ay = ay - 41
    end   

    if refs.baim:get() == "Force" and visuals.gs_inds_elems:get(2) then
        visuals.draw_gs_ind("BODY", ay, color(220, 220, 220, 255), 22, fonts.skeetind)
        ay = ay - 41
    end

    if visuals.gs_inds_elems:get(8) then
        if dmg == true then
            visuals.draw_gs_ind("MD", ay, color(220, 220, 220, 255), 22, fonts.skeetind)
            ay = ay - 41
        end
    end

    if (refs.fs.on:get() or refs.fs.on:get_override()) and visuals.gs_inds_elems:get(6) then
        visuals.draw_gs_ind("FS", ay, color(220, 220, 220, 255), 22, fonts.skeetind)
        ay = ay - 41
    end

    if bit.band(lp.m_fFlags, bit.lshift(1,0)) == 0 and lp:is_alive() and visuals.gs_inds_elems:get(10) then 
        visuals.draw_gs_ind("LC", ay, ((refs.dt.on:get() or refs.dt.on:get_override()) and rage.exploit:get() == 1) and color(255, 0, 0, 255) or math.sqrt( math.pow( lp.m_vecVelocity.x, 2 ) + math.pow( lp.m_vecVelocity.y, 2 ) )/globals.choked_commands >= 20.84 and color(132, 195, 16, 255) or color(255, 0, 0, 255), 22, fonts.skeetind)
        ay = ay - 41
    end 

    local c4 = entity.get_entities("CPlantedC4")[1]
    if c4 ~= nil and visuals.gs_inds_elems:get(11) then
        local time = ((c4.m_flC4Blow - globals.curtime)*10) / 10
        local timer = string.format("%.1f", time)
        local defused = c4.m_bBombDefused
        if math.floor(timer) > 0 and not defused then
            local defusestart = c4.m_hBombDefuser ~= 4294967295
            local defuselength = c4.m_flDefuseLength
            local defusetimer = defusestart and math.floor((c4.m_flDefuseCountDown - globals.curtime)*10) / 10 or -1
            if defusetimer > 0 then
                local kolor = math.floor(timer) > defusetimer and color(58, 191, 54, 160) or color(252, 18, 19, 125)
                
                local barlength = (((screensizey - 50) / defuselength) * (defusetimer))
                render.rect(vector(0.0, 0.0), vector(16, screensizey), color(25, 25, 25, 160))
                render.rect_outline(vector(0.0, 0.0), vector(16, screensizey), color(25, 25, 25, 160))
                
                render.rect(vector(0, screensizey - barlength), vector(16, screensizey), kolor)
            end
            
            local bombsite = c4.m_nBombSite == 0 and "A" or "B"
            local health = lp.m_iHealth
            local armor = lp.m_ArmorValue
            local willKill = false
            local eLoc = c4.m_vecOrigin
            local lLoc = lp.m_vecOrigin
            local distance = eLoc:dist(lLoc)
            local a = 450.7
            local b = 75.68
            local c = 789.2
            local d = (distance - b) / c;

            local damage = a * math.exp(-d * d)
            if armor > 0 then
                local newDmg = damage * 0.5;

                local armorDmg = (damage - newDmg) * 0.5
                if armorDmg > armor then
                    armor = armor * (1 / .5)
                    newDmg = damage - armorDmg
                end
                damage = newDmg;
            end
            local dmg = math.ceil(damage)
                if dmg >= health then
                willKill = true
            else
                willKill = false
            end
            visuals.draw_gs_ind("      "..bombsite.." - "..string.format("%.1f", timer).."s", ay, color(220, 220, 220, 255), 22, fonts.skeetind)
            render.text(fonts.bomb, vector(x + 1, y + 4 + ay), color(0, 0, 0, 100), "nil", "[")
            render.text(fonts.bomb, vector(x, y + 3 + ay), color(220, 220, 220, 255), "nil", "[")
            ay = ay - 41
            if lp then
                if willKill == true then
                    visuals.draw_gs_ind("FATAL", ay, color(255, 0, 0, 255), 22, fonts.skeetind)
                    ay = ay - 41
                elseif damage > 0.5 then
                    visuals.draw_gs_ind("-"..dmg.." HP", ay, color(210, 216, 112, 255), 22, fonts.skeetind)
                    ay = ay - 41
                end
            end
        end
    end
    if planting and visuals.gs_inds_elems:get(11) then
        visuals.draw_gs_ind(planting_site, ay, color(210, 216, 112, 255), 22, fonts.skeetind)
        fill = 3.125 - (3.125 + on_plant_time - globals.curtime)
        if(fill > 3.125) then
            fill = 3.125
        end
        ts = render.measure_text(fonts.skeetind, nil, planting_site)
        render.text(fonts.bomb, vector(x + 1, y + 4 + ay), color(0, 0, 0, 100), "nil", "[")
        render.text(fonts.bomb, vector(x, y + 3 + ay), color(210, 216, 112, 255), "nil", "[")
        render.circle_outline(vector(x + ts.x+18, y+ay+ts.y/2+6), color(0, 0, 0, 255), 8, 0, 1, 4)
        render.circle_outline(vector(x + ts.x+18, y+ay+ts.y/2+6), color(220, 220, 220, 255), 8, 0, (fill/3.3), 3)
        ay = ay - 41
    end
        
end)

local reset_plant = function()
    planting = false
    fill = 0
    on_plant_time = 0
    planting_site = ""
end

events.bomb_abortplant:set(reset_plant)
events.bomb_defused:set(reset_plant)
events.bomb_planted:set(reset_plant)
events.round_prestart:set(reset_plant)
events.bomb_beginplant:set(function(ev)
    local player_resource = entity.get_player_resource()
    on_plant_time = globals.curtime
    planting = true
    local m_bombsiteCenterA = player_resource.m_bombsiteCenterA
    local m_bombsiteCenterB = player_resource.m_bombsiteCenterB
    
    local player = entity.get(ev.userid, true)
    local localPos = player:get_origin()
    local dist_to_a = localPos:dist(m_bombsiteCenterA)
    local dist_to_b = localPos:dist(m_bombsiteCenterB)
    
    planting_site = dist_to_a < dist_to_b and "      A" or "      B"
end)

visuals.ap_ground = 0

visuals.draw_autopeek = function()
    if not visuals.ap:get() then return end
    local lp = entity.get_local_player()
    if not lp then return end
    if lp:get_anim_state().on_ground then
        visuals.ap_ground = lp.m_vecOrigin.z
    end
    --visuals.ap_ground = lp:get_anim_state().left_ground_height
    local rad = math.rad(globals.tickcount * 5 * (64 / (1 / globals.tickinterval)))
    if (refs.ap.on:get_override() or refs.ap.on:get()) then
        if not visuals.ap_pos then
            visuals.ap_pos = vector(lp.m_vecOrigin.x, lp.m_vecOrigin.y, visuals.ap_ground)
        end
        local origin = visuals.ap_pos + vector(math.cos(rad) * 30, math.sin(rad) * 30, 0)
        effects.energy_splash(origin, nil, nil, visuals.apcol:get())
    else visuals.ap_pos = nil end
end

events.render:set(visuals.draw_autopeek)

misc.clantag_time = 0
misc.clantag_stage = 0
misc.clantag_var = 0
misc.clantag_custom = {}
misc.clantag_opm = {
" ",
" ",
"0",
"00",
"O/",
"O/°",
"OP:",
"OP|",
"OPIV",
"OPIU^",
"OPIU^^",
"OPIUM ",
"OPIUM ",
"OPIUM ˙",
"OPIUM *",
"OPIUM *",
"OPIUM *",
"OPIUM *",
"OPIUM *",
"OPIUM ˙",
"OPIUM ",
"0PIUM",
".PIUM",
"./°IUM",
"..iUM",
"..:UM",
"...vM",
"....M",
"...^^",
"..^",
"..",
".",
" ",
" ",
" ",
}

misc.clantag:set_callback(function(ref)
    if not ref:get() then common.set_clan_tag("") refs.clantag:override() else refs.clantag:override(false) end
end, true)

misc.clantag_refresh:set_callback(function()
    local filestab = ListFiles("./Opium/Clantags")
    if not filestab then return end
    misc.clantag_list:update(filestab)
end, true)

misc.clantag_list:set_callback(function(ref)
    if not ref:list()[1] then 
        local filestab = ListFiles("./Opium/Clantags")
        if not filestab then return end
        ref:update(filestab) 
    end
    if not ref:list()[1] then return end
    local index = 1
    local list = files.read("Opium/Clantags/"..ref:list()[ref:get()])
    ffi.C.CreateDirectoryA(".Opium/Clantags/", nil)
    --for line in io.popen("dir \"" .. path .. "\" /a /b", "r"):lines() do
    for line in string.gmatch(list, '([^\n]+)') do
        misc.clantag_custom[index] = line
        index = index + 1
    end
end, true)

misc.clantag_set = function()

    if not globals.is_in_game then return end
    if not misc.clantag:get() then return end

    local str = ""
    local text = misc.clantag_style:get() == "Text" and misc.clantag_text:get() or misc.clantag_style:get()
    local pref = ""
    if misc.clantag_prefix:get() == "Lightning" then
        pref = " ϟ "
    elseif misc.clantag_prefix:get() == "Skull" then
        pref = " ☠ "
    elseif misc.clantag_prefix:get() == "Biohazard" then
        pref = " ☣ "
    elseif misc.clantag_prefix:get() == "Cross" then
        pref = "⛧ "
    end

    local time = math.floor(globals.curtime * 3)
    if time ~= misc.clantag_time then
        if misc.clantag_style:get() == "OPIUM *" then
            str = misc.clantag_opm[time % #misc.clantag_opm +1]
        elseif misc.clantag_style:get() == "File" then
            if misc.clantag_custom[1] then
                str = misc.clantag_custom[time % #misc.clantag_custom +1]
            end
            --print(misc.clantag_custom[time % #misc.clantag_custom +1])
        elseif misc.clantag_anim:get() == "Simple" then
            if misc.clantag_var == 18 then
                misc.clantag_var = string.len(text)
            end
            if misc.clantag_var == -1 then
                misc.clantag_stage = 0
            elseif misc.clantag_var == (string.len(text) + 3) then
                misc.clantag_stage = 1
            end
            if misc.clantag_stage == 0 then
                str = string.sub(text, 1, clamp(misc.clantag_var, 0, string.len(text)))
                misc.clantag_var = misc.clantag_var + 1
            else
                str = string.sub(text, clamp(string.len(text) - misc.clantag_var, 0, string.len(text)), string.len(text))
                misc.clantag_var = misc.clantag_var - 1
            end
        else str = text end
        str = pref..str
        common.set_clan_tag(str)
    end
    misc.clantag_time = time
end

events.render:set(misc.clantag_set)

ffi.cdef[[
    typedef uintptr_t (__thiscall* GetClientEntity_4242425_t)(void*, int);

    typedef struct
    {
        float   m_anim_time;		
        float   m_fade_out_time;	
        int     m_flags;			
        int     m_activity;			
        int     m_priority;			
        int     m_order;			
        int     m_sequence;			
        float   m_prev_cycle;		
        float   m_weight;			
        float   m_weight_delta_rate;
        float   m_playback_rate;	
        float   m_cycle;			
        void* m_owner;			
        int     m_bits;				
    } C_AnimationLayer;

    typedef struct
    {
        float x;
        float y;
        float z;
    } vec3_t;

    typedef struct
    {
        char        pad0[0x60]; // 0x00
        void*       pEntity; // 0x60
        void*       pActiveWeapon; // 0x64
        void*       pLastActiveWeapon; // 0x68
        float        flLastUpdateTime; // 0x6C
        int            iLastUpdateFrame; // 0x70
        float        flLastUpdateIncrement; // 0x74
        float        flEyeYaw; // 0x78
        float        flEyePitch; // 0x7C
        float        flGoalFeetYaw; // 0x80
        float        flLastFeetYaw; // 0x84
        float        flMoveYaw; // 0x88
        float        flLastMoveYaw; // 0x8C // changes when moving/jumping/hitting ground
        float        flLeanAmount; // 0x90
        char        pad1[0x4]; // 0x94
        float        flFeetCycle; // 0x98 0 to 1
        float        flMoveWeight; // 0x9C 0 to 1
        float        flMoveWeightSmoothed; // 0xA0
        float        flDuckAmount; // 0xA4
        float        flHitGroundCycle; // 0xA8
        float        flRecrouchWeight; // 0xAC
        vec3_t    vecOrigin; // 0xB0
        vec3_t    vecLastOrigin;// 0xBC
        vec3_t    vecVelocity; // 0xC8
        vec3_t    vecVelocityNormalized; // 0xD4
        vec3_t    vecVelocityNormalizedNonZero; // 0xE0
        float        flVelocityLenght2D; // 0xEC
        float        flJumpFallVelocity; // 0xF0
        float        flSpeedNormalized; // 0xF4 // clamped velocity from 0 to 1
        float        flRunningSpeed; // 0xF8
        float        flDuckingSpeed; // 0xFC
        float        flDurationMoving; // 0x100
        float        flDurationStill; // 0x104
        bool        bOnGround; // 0x108
        bool        bHitGroundAnimation; // 0x109
        char        pad2[0x2]; // 0x10A
        float        flNextLowerBodyYawUpdateTime; // 0x10C
        float        flDurationInAir; // 0x110
        float        flLeftGroundHeight; // 0x114
        float        flHitGroundWeight; // 0x118 // from 0 to 1, is 1 when standing
        float        flWalkToRunTransition; // 0x11C // from 0 to 1, doesnt change when walking or crouching, only running
        char        pad3[0x4]; // 0x120
        float        flAffectedFraction; // 0x124 // affected while jumping and running, or when just jumping, 0 to 1
        char        pad4[0x208]; // 0x128
        char pad_because_yes[0x4]; // 0x330
        float        flMinBodyYaw; // 0x330 + 0x4
        float        flMaxBodyYaw; // 0x334 + 0x4
        float        flMinPitch; //0x338 + 0x4
        float        flMaxPitch; // 0x33C + 0x4
        int            iAnimsetVersion; // 0x340 + 0x4
    } CCSGOPlayerAnimationState_t;
]]

local entity_list_ptr = ffi.cast("void***", utils.create_interface("client.dll", "VClientEntityList003"))
local get_client_entity_fn = ffi.cast("GetClientEntity_4242425_t", entity_list_ptr[0][3])

entity.get_address = function(index)
    if not index then return end
    return get_client_entity_fn(entity_list_ptr, index)
end

local m_playeranimstate = ffi.cast("uintptr_t*", utils.opcode_scan("client.dll", "8B 8E ? ? ? ? F3 0F 10 48 04 E8 ? ? ? ? E9", 2))[0]

entity.get_anim_layers = function(address)
    if not address then return end

    return ffi.cast("C_AnimationLayer**", ffi.cast('uintptr_t', address) + 0x2990)[0]
end

local is_lp_jumping = false
misc.legjitter = 0
events.post_update_clientside_animation:set(function(ent)
    if not ent then return end
    local m_iIndex = ent:get_index()

    if m_iIndex ~= entity.get_local_player():get_index() then
        return
    end

    local m_iAddress = entity.get_address(m_iIndex)
    if not m_iAddress then return end

    local pAnimLayers = entity.get_anim_layers(m_iAddress)
    local pAnimState = ffi.cast("CCSGOPlayerAnimationState_t**", ffi.cast("uintptr_t", m_iAddress) + m_playeranimstate)[0]
    if not pAnimLayers or not pAnimState then return end

    --ent.m_flPoseParameter[12] = 89
    --if (refs.dt.on:get() or refs.hs.on:get()) and (ent.m_flPoseParameter[12] == 1) then print(tbl.defensive) end
    --if tbl.defensive == 0 then print(ent.m_flPoseParameter[12]) end
    if misc.breaker:get(1) and pAnimState.bHitGroundAnimation and pAnimState.bOnGround and not is_lp_jumping then
        ent.m_flPoseParameter[12] = 0.5
    end
    if misc.breaker:get(2) then
        ent.m_flPoseParameter[6] = 1
    end
    if misc.breaker:get(4) then
        ent.m_flPoseParameter[7] = 1
    end

    if misc.legbreaker:get() == "Backward" then
        ent.m_flPoseParameter[0] = 1
        refs.legs:override("Sliding")
    elseif misc.legbreaker:get() == "Forward" then
        ent.m_flPoseParameter[0] = 0.5
        refs.legs:override("Sliding")
    elseif misc.legbreaker:get() == "Jitter" then
        if misc.legjitter then
            ent.m_flPoseParameter[0] = 1
        else
            ent.m_flPoseParameter[0] = 0.5
        end
        refs.legs:override("Sliding")
    else refs.legs:override() end

    if not pAnimState.bOnGround then
        if misc.breaker:get(5) then
            pAnimLayers[12].m_weight = 1
        end
        if misc.breaker:get(3) then
            pAnimLayers[6].m_weight = 1
        end
    end
end)

events.createmove:set(function(cmd)
    if globals.choked_commands == 0 then
        misc.legjitter = not misc.legjitter
    end
    if misc.breaker:get(5) then
        cmd.animate_move_lean = true
    end
    is_lp_jumping = cmd.in_jump
end)

visuals.viewbak = {
    x = cvar.viewmodel_offset_x:float(),
    y = cvar.viewmodel_offset_y:float(),
    z = cvar.viewmodel_offset_z:float(),
    fov = cvar.fov_cs_debug:int(),
    aspect = cvar.r_aspectratio:float(),
}

visuals.setview = function()
    cvar.sv_competitive_minspec:int(0)
    cvar.viewmodel_offset_x:float(visuals.viewx:get()/10)
    cvar.viewmodel_offset_y:float(visuals.viewy:get()/10)
    cvar.viewmodel_offset_z:float(visuals.viewz:get()/10)
    cvar.fov_cs_debug:int(visuals.fov:get())
    cvar.r_aspectratio:float(visuals.aspect:get()/10)
end

visuals.resetview = function()
    local v = visuals.viewbak
    cvar.sv_competitive_minspec:int(1)
    cvar.viewmodel_offset_x:float(v.x)
    cvar.viewmodel_offset_y:float(v.y)
    cvar.viewmodel_offset_z:float(v.z)
    cvar.viewmodel_fov:int(v.fov)
    cvar.r_aspectratio:float(v.aspect)
end

visuals.viewx:set_callback(function(ref)
    if not visuals.viewmodel:get() then return end
    cvar.viewmodel_offset_x:float(ref:get()/10)
end)
visuals.viewy:set_callback(function(ref)
    if not visuals.viewmodel:get() then return end
    cvar.viewmodel_offset_y:float(ref:get()/10)
end)
visuals.viewz:set_callback(function(ref)
    if not visuals.viewmodel:get() then return end
    cvar.viewmodel_offset_z:float(ref:get()/10)
end)
visuals.fov:set_callback(function(ref)
    if not visuals.viewmodel:get() then return end
    cvar.viewmodel_fov:float(ref:get())
end)
visuals.aspect:set_callback(function(ref)
    if not visuals.viewmodel:get() then return end
    cvar.r_aspectratio:float(ref:get()/10)
end)

visuals.viewmodel:set_callback(function(ref)
    if ref:get() then visuals.setview() else visuals.resetview() end
end)

if visuals.viewmodel:get() then visuals.setview() end

events.shutdown:set(visuals.resetview)

misc.suicide:tooltip("Yes, it works on a bind.")
misc.suicide:set_callback(function(ref)
    if ref:get() then
        utils.console_exec("kill")
    end
    ref:set(false)
end)

misc.js_fix_func = function()
    if not misc.js_fix:get() then return end
    local lp = entity.get_local_player()
    if not lp then return end
    local flag = lp.m_fFlags
    local velocity = math.sqrt( math.pow( lp.m_vecVelocity.x, 2 ) + math.pow( lp.m_vecVelocity.y, 2 ) )
    if velocity < 15 then
        refs.strafe:override(false)
    else
        refs.strafe:override()
    end
end

events.render:set(misc.js_fix_func)

--local function file:flines()
--    local table, index = {}, 1;

--end

local path, index, filestab = "./Opium/Sounds/Music", 1, {}

misc.music_playing = false
misc.music_repeater = false
misc.music_shuffler = false

misc.music_repeat:set_callback(function() 
    misc.music_repeater = not misc.music_repeater
    misc.music_shuffler = false
    local color = concolor(lighten(visuals.themecol:get(), 20)).."FF"
    misc.music_repeat:name(misc.music_repeater and "\a"..color.." "..ui.get_icon("arrows-repeat").." " or " "..ui.get_icon("arrows-repeat").." ")
    misc.music_shuffle:name(" "..ui.get_icon("shuffle").." ")
end)

misc.music_shuffle:set_callback(function() 
    misc.music_shuffler = not misc.music_shuffler
    misc.music_repeater = false
    local color = concolor(lighten(visuals.themecol:get(), 20)).."FF"
    misc.music_shuffle:name(misc.music_shuffler and "\a"..color.." "..ui.get_icon("shuffle").." " or " "..ui.get_icon("shuffle").." ")
    misc.music_repeat:name(" "..ui.get_icon("arrows-repeat").." ")
end)

misc.music_refresh:set_callback(function()
    --[[index = 0
    local list = files.read(path.."/list.txt")
    --print(list)
    ffi.C.CreateDirectoryA(path, nil)
    --for line in io.popen("dir \"" .. path .. "\" /a /b", "r"):lines() do
    for line in string.gmatch(list, '([^\n]+)') do
        if string.find(line, ".wav") then
           filestab[index] = line
           index = index + 1
       end
    end]]
    filestab = ListFiles("./Opium/Sounds/Music")
    if not filestab then return end
    misc.music_file:update(filestab)
end, true)

misc.music_handler = function()
	if estimated_end_time ~= -1 and globals.curtime > estimated_end_time then
		cvar.voice_inputfromfile:int(0)
        utils.console_exec("-voicerecord")
        cvar.voice_loopback:int(0)
        cvar.voice_mixer_volume:float(voice_mixer_volume)
		ffi.C.DeleteFileA("./voice_input.wav")
        if misc.music_repeater then
            play_file(path .. "\\" .. misc.music_file:get())
        elseif misc.music_shuffler then
            play_file(path .. "\\" .. filestab[math.random(1, #filestab)])
        else
            --misc.music_play:visibility(true)
            --misc.music_stop:visibility(false)
            misc.music_play:name("   "..ui.get_icon("play").."   ")
            misc.music_playing = false
		    estimated_end_time = -1
        end
    end
end
events.render:set(misc.music_handler)

events.shutdown:set(function()
    cvar.voice_inputfromfile:int(0)
    utils.console_exec("-voicerecord")
    cvar.voice_loopback:int(0)
    cvar.voice_mixer_volume:float(voice_mixer_volume)
	ffi.C.DeleteFileA("./voice_input.wav")
end)

misc.music_play:set_callback(function()
    --play_file(path .. "\\" .. misc.music_file:get())
    --misc.music_play:visibility(false)
    --misc.music_stop:visibility(true)
    --misc.music_playing = true

    if not misc.music_playing then
        play_file(path .. "\\" .. misc.music_file:get())
    else
        cvar.voice_inputfromfile:int(0)
        utils.console_exec("-voicerecord")
        cvar.voice_loopback:int(0)
        cvar.voice_mixer_volume:float(voice_mixer_volume)
	    ffi.C.DeleteFileA("./voice_input.wav")
        estimated_end_time = -1
        misc.music_playing = false
        misc.music_play:name("   "..ui.get_icon("play").."   ")
    end
end)

misc.music_left:set_callback(function()
    if misc.music_file:get() == filestab[1] then
        play_file(path .. "\\" .. filestab[#filestab])
        misc.music_file:set(filestab[#filestab])
    else
        local index = indexOf(filestab, misc.music_file:get())
        play_file(path .. "\\" .. filestab[index-1])
        misc.music_file:set(filestab[index-1])
    end
end)

misc.music_right:set_callback(function()
    if misc.music_file:get() == filestab[#filestab] then
        play_file(path .. "\\" .. filestab[1])
        misc.music_file:set(filestab[1])
    else
        local index = indexOf(filestab, misc.music_file:get())
        play_file(path .. "\\" .. filestab[index+1])
        misc.music_file:set(filestab[index+1])
    end
end)

--[[misc.music_stop:set_callback(function()
    cvar.voice_inputfromfile:int(0)
    utils.console_exec("-voicerecord")
    cvar.voice_loopback:int(0)
    cvar.voice_mixer_volume:float(voice_mixer_volume)
	ffi.C.DeleteFileA("./voice_input.wav")
    estimated_end_time = -1
    misc.music_playing = false
    --misc.music_play:visibility(true)
    --misc.music_stop:visibility(false)
end)]]

misc.music_stop:visibility(false)

misc.killsay_array = {}
misc.killcount = {}
misc.killsay_array_custom = {}

misc.killsay_handler = function()
    if misc.killsay:get() == "Disabled" then return end
    if misc.killsay:get() == "Custom" then misc.killsay_array = misc.killsay_array_custom end
end

events.render:set(misc.killsay_handler)

misc.killsay:set_callback(function(ref)
    misc.killsay_line:visibility(ref:get() == "Kill count")
    misc.killsay_flist:visibility(ref:get() == "Custom")
    misc.killsay_r:visibility(ref:get() == "Custom")
end, true)

misc.s_killsay:set_callback(function(ref)
    misc.s_killsay_gr:visibility(ref:get())
end, true)

misc.killsay_r:set_callback(function()
    local filestab = ListFiles("./Opium/Messages/Kill")
    if not filestab then return end
    misc.killsay_flist:update(filestab)
end, true)

misc.s_killsay_r:set_callback(function()
    local filestab = ListFiles("./Opium/Sounds/Kill")
    if not filestab then return end
    misc.s_killsay_flist:update(filestab)
end, true)

misc.killsay_flist:set_callback(function(ref)
    if not ref:list()[1] then 
        local filestab = ListFiles("./Opium/Messages/Kill")
        if not filestab then return end
        ref:update(filestab) 
    end
    if not ref:list()[1] then return end
    local index = 1
    local list = files.read("Opium/Messages/Kill/"..ref:list()[ref:get()])
    --print(list)
    ffi.C.CreateDirectoryA(".Opium/Messages/Kill/", nil)
    --for line in io.popen("dir \"" .. path .. "\" /a /b", "r"):lines() do
    for line in string.gmatch(list, '([^\n]+)') do
        misc.killsay_array_custom[index] = line
        index = index + 1
    end
end, true)

misc.killsay_execute = function(ev)
    if not (entity.get(ev.attacker, true) == entity.get_local_player()) then return end
    if misc.s_killsay:get() then play_file("Opium/Sounds/Kill/"..misc.s_killsay_flist:list()[misc.s_killsay_flist:get()]) end
    if misc.killsay:get() == "Disabled" then return end
    if misc.killsay:get() == "Kill count" then
        local id = entity.get(ev.userid, true):get_xuid()
        if not misc.killcount[id] then
            misc.killcount[id] = 1
        else
            misc.killcount[id] = misc.killcount[id] + 1
            local killstring = misc.killsay_line:get()
            local name = entity.get(ev.userid, true):get_name():gsub('%;', '')
            killstring = killstring:gsub("%^p", name)
            killstring = killstring:gsub("%^n", misc.killcount[id])
            utils.console_exec("say "..killstring)
        end
        return
    end
    utils.console_exec("say "..misc.killsay_array[math.random(1, #misc.killsay_array)])
end

events.cs_game_disconnected:set(function() misc.killcount = {} end)

events.player_death:set(function(ev) misc.killsay_execute(ev) end)

misc.death_array = {}
misc.deathcount = {}
misc.death_array_custom = {}

misc.death_handler = function()
    if misc.death:get() == "Disabled" then return end
    if misc.death:get() == "Custom" then misc.death_array = misc.death_array_custom end
end

events.render:set(misc.death_handler)

misc.death:set_callback(function(ref)
    misc.death_line:visibility(ref:get() == "Text")
    misc.death_flist:visibility(ref:get() == "Custom")
    misc.death_r:visibility(ref:get() == "Custom")
end, true)

misc.s_death:set_callback(function(ref)
    misc.s_death_gr:visibility(ref:get())
end, true)

misc.death_r:set_callback(function()
    local filestab = ListFiles("./Opium/Messages/Death")
    if not filestab then return end
    misc.death_flist:update(filestab)
end, true)

misc.s_death_r:set_callback(function()
    local filestab = ListFiles("./Opium/Sounds/Death")
    if not filestab then return end
    misc.s_death_flist:update(filestab)
end, true)

misc.death_flist:set_callback(function(ref)
    if not ref:list()[1] then 
        local filestab = ListFiles("./Opium/Messages/Death")
        if not filestab then return end
        ref:update(filestab) 
    end
    if not ref:list()[1] then return end
    local index = 1
    local list = files.read("Opium/Messages/Death/"..ref:list()[ref:get()])
    --print(list)
    ffi.C.CreateDirectoryA(".Opium/Messages/Death/", nil)
    --for line in io.popen("dir \"" .. path .. "\" /a /b", "r"):lines() do
    for line in string.gmatch(list, '([^\n]+)') do
        misc.death_array_custom[index] = line
        index = index + 1
    end
end, true)

misc.death_execute = function(ev)
    if not (entity.get(ev.userid, true) == entity.get_local_player()) then return end
    if misc.s_death:get() then play_file("Opium/Sounds/Death/"..misc.s_death_flist:list()[misc.s_death_flist:get()]) end
    if misc.death:get() == "Disabled" then return end
    if misc.death:get() == "Text" then
        local id = entity.get(ev.attacker, true):get_xuid()
        if not misc.deathcount[id] then
            misc.deathcount[id] = 1
        else
            misc.deathcount[id] = misc.deathcount[id] + 1
            local deathstring = misc.death_line:get()
            local name = entity.get(ev.attacker, true):get_name():gsub('%;', '')
            deathstring = deathstring:gsub("%^p", name)
            deathstring = deathstring:gsub("%^n", misc.deathcount[id])
            utils.console_exec("say "..deathstring)
        end
        return
    end
    utils.console_exec("say "..misc.death_array[math.random(1, #misc.death_array)])
end

events.player_death:set(function(ev) misc.death_execute(ev) end)

misc.miss_trigger = false
misc.miss_checked = false
misc.last_shooter = 0
misc.miss_array = {}
misc.misscount = {}
misc.miss_array_custom = {}

misc.miss_handler = function()
    if misc.miss:get() == "Disabled" then return end
    if misc.miss:get() == "Custom" then misc.miss_array = misc.miss_array_custom end
end

events.render:set(misc.miss_handler)

misc.miss:set_callback(function(ref)
    misc.miss_line:visibility(ref:get() == "Miss count")
    misc.miss_flist:visibility(ref:get() == "Custom")
    misc.miss_r:visibility(ref:get() == "Custom")
end, true)

misc.s_miss:set_callback(function(ref)
    misc.s_miss_gr:visibility(ref:get())
end, true)

misc.miss_r:set_callback(function()
    local filestab = ListFiles("./Opium/Messages/Miss")
    if not filestab then return end
    misc.miss_flist:update(filestab)
end, true)

misc.s_miss_r:set_callback(function()
    local filestab = ListFiles("./Opium/Sounds/Miss")
    if not filestab then return end
    misc.s_miss_flist:update(filestab)
end, true)

misc.miss_flist:set_callback(function(ref)
    if not ref:list()[1] then 
        local filestab = ListFiles("./Opium/Messages/Miss")
        if not filestab then return end
        ref:update(filestab) 
    end
    if not ref:list()[1] then return end
    local index = 1
    local list = files.read("Opium/Messages/Miss/"..ref:list()[ref:get()])
    --print(list)
    ffi.C.CreateDirectoryA(".Opium/Messages/Miss/", nil)
    --for line in io.popen("dir \"" .. path .. "\" /a /b", "r"):lines() do
    for line in string.gmatch(list, '([^\n]+)') do
        misc.miss_array_custom[index] = line
        index = index + 1
    end
end, true)

misc.s_miss_player_check = function(ev)
    -- and ev.attacker == misc.last_shooter
    if entity.get(ev.userid, true) == entity.get_local_player() then --gotta improve this with a counter also don't forget to make it work without sound enabled
        misc.miss_trigger = false
        misc.miss_checked = false
    else
        misc.miss_checked = true
    end
end

events.player_hurt:set(function(ev) misc.s_miss_player_check(ev) end)

misc.miss_execute = function()
    if not (misc.miss_trigger and misc.miss_checked) then return end

    if misc.s_miss:get() and misc.s_miss_flist:list()[1] then
        play_file("Opium/Sounds/Miss/"..misc.s_miss_flist:list()[misc.s_miss_flist:get()])
    end
    
    --[[if entity.get_local_player():get_player_weapon():get_weapon_reload() >= 0 and entity.get_local_player():get_player_weapon():get_weapon_reload() <= 0.11 then
        utils.console_exec("play bullets.wav")
    end]]

    if misc.miss:get() == "Disabled" then goto untrigger end
    if misc.miss:get() == "Miss count" then
        local id = entity.get(misc.last_shooter, true):get_xuid()
        if not misc.misscount[id] then
            misc.misscount[id] = 1
        else
            misc.misscount[id] = misc.misscount[id] + 1
            local missstring = misc.miss_line:get()
            local name = entity.get(misc.last_shooter, true):get_name():gsub('%;', '')
            missstring = missstring:gsub("%^p", name)
            missstring = missstring:gsub("%^n", misc.misscount[id])
            utils.console_exec("say "..missstring)
        end
        goto untrigger
    end
    utils.console_exec("say "..misc.miss_array[math.random(1, #misc.miss_array)])

    ::untrigger::
    misc.miss_trigger = false
    misc.miss_checked = false
end

events.render:set(misc.miss_execute)

misc.utils_execute = function(cmd)
	local player = entity.get_local_player()
	if not player then
		return end
			
	if misc.utils:get("No fall damage") then
		if player.m_vecVelocity.z >= -500 then
			nd_state = false
		else
			if get_trace(15) then
				nd_state = false
			elseif get_trace(75) then
				nd_state = true
			end
		end

		if player.m_vecVelocity.z < -500 then
			if nd_state then
				cmd.in_duck = 1
			else
				cmd.in_duck = 0
			end
		end
	end
	
    if misc.utils:get("Fast ladder climb") then
		if player.m_MoveType == 9 and common.is_button_down(0x57) then
			cmd.view_angles.y = math.floor(cmd.view_angles.y+0.5)
			cmd.roll = 0

			if cmd.view_angles.x < 45 then
				cmd.view_angles.x = 89
				cmd.in_moveright = 1
				cmd.in_moveleft = 0
				cmd.in_forward = 0
				cmd.in_back = 1
				if cmd.sidemove == 0 then
					cmd.view_angles.y = cmd.view_angles.y + 90
				end
				if cmd.sidemove < 0 then
					cmd.view_angles.y = cmd.view_angles.y + 150
				end
				if cmd.sidemove > 0 then
					cmd.view_angles.y = cmd.view_angles.y + 30
				end
			end
		end
    end
end

events.createmove:set(function(cmd) misc.utils_execute(cmd) end)

--[[local shitbitch = color(visuals.themecol:get().r, visuals.themecol:get().g, visuals.themecol:get().b, 255)
update_texts(shitbitch, changecol(shitbitch))]]

events.mouse_input:set(function()
    if is_hovering and (ui.get_alpha() > 0) then
        return false
    end
end)

local add_callbacks = function()
    for _, v in pairs(menu_colored_items) do
        local uicol = (visuals.uicol_select:get() == "Theme") and color(visuals.themecol:get().r, visuals.themecol:get().g, visuals.themecol:get().b) or visuals.uicol
        local kolor = concolor(lighten(uicol, 20)).."FF"
        local func = nil
        if v.item:type() == "list" then
            func = function()
                local table = {}
                local list = v.list
                local uicol = (visuals.uicol_select:get() == "Theme") and color(visuals.themecol:get().r, visuals.themecol:get().g, visuals.themecol:get().b) or visuals.uicol
                kolor = concolor(lighten(uicol, 20)).."FF"
                for i = 1, #list do
                    if v.item:get() == i then
                        table[i] = "\a"..kolor..list[i][1].."\aDEFAULT"..list[i][2]
                    else
                        table[i] = list[i][1]..list[i][2]
                    end
                end
                v.item:update(table)
            end
        elseif v.item:type() == "button" then
            func = function()
                local uicol = (visuals.uicol_select:get() == "Theme") and color(visuals.themecol:get().r, visuals.themecol:get().g, visuals.themecol:get().b) or visuals.uicol
                kolor = concolor(lighten(uicol, 20)).."FF"
                v.item:name("\a"..kolor..v.name_col.."\aDEFAULT"..v.name_noncol)
            end
        end
        color_callbacks[#color_callbacks+1] = func
        v.item:set_callback(function() func() end, true)
        --[[visuals.themecol:set_callback(function() func() end, true)
        visuals.uicol_select:set_callback(function() func() end, true)]]
    end
    for _, v in pairs(menu_lists) do
        local func = function()
            local table = {}
            local uicol = (visuals.uicol_select:get() == "Theme") and color(visuals.themecol:get().r, visuals.themecol:get().g, visuals.themecol:get().b) or visuals.uicol
            local kolor = concolor(lighten(uicol, 20)).."FF"
            local list = v.list
            local tabs = v.tabs
            for i = 1, #list do
                if v.item:get() == i then
                    table[i] = "\a"..kolor..list[i][1].."\aDEFAULT"..list[i][2]
                    tabs[i]:visibility(true)
                else
                    table[i] = list[i][1]..list[i][2]
                    tabs[i]:visibility(false)
                end
            end
            v.item:update(table)
        end
        color_callbacks[#color_callbacks+1] = func
        v.item:set_callback(function() func() end, true)
        --[[visuals.themecol:set_callback(function() func() end, true)
        visuals.uicol_select:set_callback(function() func() end, true)]]
    end
end

add_callbacks()

visuals.themecol:set_callback(function() run_callbacks(visuals.uicol) end, true)
visuals.uicol_select:set_callback(function() run_callbacks(visuals.uicol) end, true)

update_cfg_labels()

local MySteam64 = panorama.MyPersonaAPI.GetXuid()
interface.SetKey("00piumDisciple")
interface.SetRequestDelay(10)
local SearchHave = interface.GetRichSearch(MySteam64, "00piumDisciple")
events.render:set(function()
   local local_player = entity.get_local_player()
   if not globals.is_in_game then
      return
    end

  local SearchPlayers = {}
  local RichSearchKey = "00piumDisciple"
  for _, ptr in pairs(entity.get_players()) do
    --if ptr ~= local_player then
      local player_xuid = ptr:get_xuid()
      if interface.GetRichSearch(player_xuid, RichSearchKey) then
        table.insert(SearchPlayers, ptr)
        ptr:set_icon("https://github.com/whyisiugentaken/opium-resources/blob/main/asterisk.png?raw=true")
      end
    --end
  end
end)

events.shutdown:set(function()

    if not globals.is_in_game then
        return
    end
    entity.get_local_player():set_icon()
    for _, ptr in pairs(entity.get_players()) do
      --if ptr ~= local_player then
        local player_xuid = ptr:get_xuid()
        if interface.GetRichSearch(player_xuid, RichSearchKey) then
          ptr:set_icon()
        end
      --end
    end
end)

--[[for k, v in pairs(menu_items) do
    print(k..' '..tostring(v))
end]]