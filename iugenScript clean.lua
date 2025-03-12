--
--▀█▀ ▒█░▒█ ▒█▀▀█ ▒█▀▀▀ ▒█▄░▒█ ▒█▀▀▀█ ▒█▀▀█ ▒█▀▀█ ▀█▀ ▒█▀▀█ ▀▀█▀▀ 
--▒█░ ▒█░▒█ ▒█░▄▄ ▒█▀▀▀ ▒█▒█▒█ ░▀▀▀▄▄ ▒█░░░ ▒█▄▄▀ ▒█░ ▒█▄▄█ ░▒█░░ 
--▄█▄ ░▀▄▄▀ ▒█▄▄█ ▒█▄▄▄ ▒█░░▀█ ▒█▄▄▄█ ▒█▄▄█ ▒█░▒█ ▄█▄ ▒█░░░ ░▒█░░

local ffi = require('ffi')
menu.set_bool( "scripts.allow_file", true )
menu.set_bool( "scripts.allow_http", true )

ffi.cdef[[
    typedef struct mask {
        char m_pDriverName[512];
        unsigned int m_VendorID;
        unsigned int m_DeviceID;
        unsigned int m_SubSysID;
        unsigned int m_Revision;
        int m_nDXSupportLevel;
        int m_nMinDXSupportLevel;
        int m_nMaxDXSupportLevel;
        unsigned int m_nDriverVersionHigh;
        unsigned int m_nDriverVersionLow;
        int64_t pad_0;
        union {
            int xuid;
            struct {
                int xuidlow;
                int xuidhigh;
            };
        };
        char name[128];
        int userid;
        char guid[33];
        unsigned int friendsid;
        char friendsname[128];
        bool fakeplayer;
        bool ishltv;
        unsigned int customfiles[4];
        unsigned char filesdownloaded;
    };
    typedef int(__thiscall* get_current_adapter_fn)(void*);
    typedef void(__thiscall* get_adapters_info_fn)(void*, int adapter, struct mask& info);
    typedef bool(__thiscall* file_exists_t)(void* this, const char* pFileName, const char* pPathID);
    typedef long(__thiscall* get_file_time_t)(void* this, const char* pFileName, const char* pPathID);
]]

local material_system = utils.create_interface('materialsystem.dll', 'VMaterialSystem080')
local material_interface = ffi.cast('void***', material_system)[0]

local get_current_adapter = ffi.cast('get_current_adapter_fn', material_interface[25])
local get_adapter_info = ffi.cast('get_adapters_info_fn', material_interface[26])

local current_adapter = get_current_adapter(material_interface)

local adapter_struct = ffi.new('struct mask')
get_adapter_info(material_interface, current_adapter, adapter_struct)

local driverName = tostring(ffi.string(adapter_struct['m_pDriverName']))
local vendorId = tostring(adapter_struct['m_VendorID'])
local deviceId = tostring(adapter_struct['m_DeviceID'])
class_ptr = ffi.typeof("void***")
rawfilesystem = utils.create_interface("filesystem_stdio.dll", "VBaseFileSystem011")
filesystem = ffi.cast(class_ptr, rawfilesystem)
file_exists = ffi.cast("file_exists_t", filesystem[0][10])
get_file_time = ffi.cast("get_file_time_t", filesystem[0][13])

function bruteforce_directory()
    for i = 65, 90 do
        local directory = string.char(i) .. ":\\Windows\\Setup\\State\\State.ini"

        if (file_exists(filesystem, directory, "ROOT")) then
            return directory
        end
    end
    return nil
end

local directory = bruteforce_directory()
local install_time = get_file_time(filesystem, directory, "ROOT")
local hardwareID = install_time * 2
--((vendorId*deviceId) * 2) + hardwareID

local function missing(x)
    error(x.. " missing")

end

local function str_to_sub(input, sep)
	local t = {}
	for str in  string.gmatch(input, "([^"..sep.."]+)") do
		t[#t + 1] = string.gsub(str, "\n", "")
        --print(str)
	end
	return t
end

ffi.cdef[[
	bool CreateDirectoryA(const char *path, void *lpSecurityAttributes);
    int AddFontResourceA(const char* unnamedParam1);
    bool DeleteUrlCacheEntryA(const char* lpszUrlName);
    void* __stdcall URLDownloadToFileA(void* LPUNKNOWN, const char* LPCSTR, const char* LPCSTR2, int a, int LPBINDSTATUSCALLBACK); 
]]
local user32 = ffi.load("user32")   -- Load User32 DLL handle

ffi.cdef[[
enum{
    MB_OK = 0x00000000L,
    MB_ICONINFORMATION = 0x00000040L,
    MB_ICONWARNING = 0x00000030L,
    MB_ICONERROR = 0x00000010L
};

typedef void* HANDLE;
typedef HANDLE HWND;
typedef const char* LPCSTR;
typedef unsigned UINT;

int MessageBoxA(HWND, LPCSTR, LPCSTR, UINT);
]] -- Define C -> Lua interpretation

   -- Call C function 'MessageBoxA' from User32
local urlmon = ffi.load 'UrlMon'
local wininet = ffi.load 'WinInet'
local gdi = ffi.load 'Gdi32'

local clantag_backup = menu.get_bool("misc.clan_tag")
menu.set_bool("misc.clan_tag", false)
key="82b4c614a6fc79963145ece4260655ede2c08ca4"
local path, index, files = "C:/iugenScript", 0, {}
ffi.C.CreateDirectoryA(path, nil)
ffi.C.CreateDirectoryA(path.."/Fonts", nil)
--loadstring(http.get( "https://pastebin.com", "/raw/fmzMWsvC"))() idk what this is





--Beginning of important stuff

beta = false
version = 1.41
last_update = "05/03/2023"

local info = debug.getinfo(1,'S')
local filepath = tostring(info.source:sub(2))
local position_start, position_end = string.find(filepath, "\\Scripts\\")

--blacklist
blacklist = http.get( "https://gist.githubusercontent.com", "/whyisiugentaken/1b947ecb5df89c138bcf20cd124be146/raw/blacklist.lua" )
loadstring(blacklist)()

if blacklist == "" then
    --client.log("Both HTTP request and file edit are required for the script to work properly!")
    user32.MessageBoxA(nil, "Please allow both file edit and HTTP request in the \"Lua\" tab!", "iugenScript", ffi.C.MB_OK + ffi.C.MB_ICONWARNING)
    client.unload_script( string.sub(filepath, position_end+1) )
    return
end

if menu.get_bool( "misc.clan_tag" ) then
    menu.set_bool("misc.clan_tag", clantag_backup)
    client.log("Oops! It seems like you have been blacklisted from iugenScript!")
    user32.MessageBoxA(nil, "Oops! It seems like you have been blacklisted from iugenScript!", "iugenScript", ffi.C.MB_OK + ffi.C.MB_ICONERROR)
    client.unload_script( string.sub(filepath, position_end+1) )
end

betalist = http.get( "https://gist.githubusercontent.com", "/whyisiugentaken/1b947ecb5df89c138bcf20cd124be146/raw/betalist.lua" )
loadstring(betalist)()
if menu.get_bool( "misc.clan_tag" ) then
    menu.set_bool("misc.clan_tag", clantag_backup)
    client.log("Congratulations, you're a beta user of iugenScript!")
    beta = true
end

--old userlist
--loadstring(http.get("https://pastebin.com","/raw/dHYcJ9B5"))()
userlist = http.get("https://gist.githubusercontent.com", "/whyisiugentaken/1b947ecb5df89c138bcf20cd124be146/raw/userlist.lua")
loadstring(userlist)()


file.write("C:/iugenScript/probe.txt", " ")
if file.read("C:/iugenScript/probe.txt") ~= " " then
    --client.log( "Both HTTP request and file edit are required for the script to work properly!" )
    user32.MessageBoxA(nil, "Please allow both file edit and HTTP request in the \"Lua\" tab!", "iugenScript", ffi.C.MB_OK + ffi.C.MB_ICONWARNING)
    client.unload_script( string.sub(filepath, position_end+1) )
    return
end
file.write("C:/iugenScript/probe.txt", "")
loginget = http.get("https://iugen.000webhostapp.com", "/login.php?hwid="..((vendorId*deviceId) * 2) + hardwareID.."&user="..globals.get_username())
requestget = http.get("https://iugen.000webhostapp.com", "/request.php?hwid="..((vendorId*deviceId) * 2) + hardwareID.."&user="..globals.get_username())

--user login (for turkish users with no vpn)
if menu.get_bool("misc.clan_tag") then
    goto turkishmode
end

--magic skip
secretswitch = http.get( "https://gist.githubusercontent.com", "/whyisiugentaken/1b947ecb5df89c138bcf20cd124be146/raw/secretswitch.lua" )
if secretswitch == "true" then
    goto turkishmode
elseif secretswitch == "off" then
    client.log("This script is currently disabled by the developer.")
    return
end

--database connection check
if loginget == "" or requestget == "" then
    user32.MessageBoxA(nil, "Connection to the database failed! Please contact the owner on the iugenScript Discord server or at eugen#6647.", "iugenScript", ffi.C.MB_OK + ffi.C.MB_ICONWARNING)
    client.log("Connection to the database failed! Please contact the owner on the iugenScript Discord server or at eugen#6647.")
    client.unload_script( string.sub(filepath, position_end+1) )
    --http.post( "https://pastebin.com/api/api_post.php", "api_option=paste", "cdPr_RmoU42olclejC5wV3DA5V8G35n9", "api_paste_code=test" )
    return
end

if menu.get_bool("misc.clan_tag") ~= true then
    if loginget == "pending" and requestget == "pending" then
        client.log("Your HWID change reset is pending, please wait! For more details open a ticket on the iugenScript Discord server.")
        client.unload_script( string.sub(filepath, position_end+1) )
        return
    elseif requestget == "sent" then
        client.log("Your HWID change reset has been sent successfully and is waiting approval! For more details open a ticket on the iugenScript Discord server.")
        client.unload_script( string.sub(filepath, position_end+1) )
        return
    elseif loginget ~= "true" then
        client.log("Access denied! If you have purchased the script, please open a ticket on the iugenScript Discord server.")
        client.unload_script( string.sub(filepath, position_end+1) )
        return
    end
end

::turkishmode::
menu.set_bool("misc.clan_tag", clantag_backup)

--verdownload
--loadstring(http.get("https://pastebin.com", "/raw/WBatHzK8"))()
loadstring(http.get("https://gist.githubusercontent.com", "/whyisiugentaken/1b947ecb5df89c138bcf20cd124be146/raw/verdownload.lua"))()
if beta then loadstring(http.get("https://gist.githubusercontent.com", "/whyisiugentaken/1b947ecb5df89c138bcf20cd124be146/raw/betaverdownload.lua"))() end
latest_download = file.read( "C:/iugenScript/probe.txt" )
file.write( "C:/iugenScript/probe.txt", "" )

aspectratio_backup = menu.get_float( "misc.aspect_ratio_value" )
version = tonumber(string.format("%.2f",version))
--local changelog = http.get( "https://pastebin.com", "/raw/0gW6w6QN" )

--changelog
changelog = http.get("https://gist.githubusercontent.com", "/whyisiugentaken/1b947ecb5df89c138bcf20cd124be146/raw/changelog")
--loadstring(http.get("https://pastebin.com", "/raw/pnmyMS7f"))()

--vercheck
loadstring(http.get("https://gist.githubusercontent.com", "/whyisiugentaken/1b947ecb5df89c138bcf20cd124be146/raw/vercheck.lua"))()
if beta then loadstring(http.get("https://gist.githubusercontent.com", "/whyisiugentaken/1b947ecb5df89c138bcf20cd124be146/raw/betavercheck.lua"))() end
latest_version = tonumber(string.format("%.2f",tostring(menu.get_float( "misc.aspect_ratio_value" ))))
if globals.get_username() == "eugen" then
    client.log( "Latest version: V"..tostring(latest_version) )
    client.log( "Current version: V"..tostring(version))
end
if latest_version > version then
    --client.log("pls update men")
    client.log( "Updating to the latest version of iugenScript..." )
    wininet.DeleteUrlCacheEntryA(latest_download)
    urlmon.URLDownloadToFileA(nil, latest_download, filepath, 0,0)
    user32.MessageBoxA(nil, "Updated iugenScript to the latest version, please reload the script/config!", "iugenScript", ffi.C.MB_OK + ffi.C.MB_ICONINFORMATION)
    client.log( "Updated iugenScript to the latest version, please reload the script/config!" )
    menu.set_float( "misc.aspect_ratio_value", aspectratio_backup )
    client.unload_script( string.sub(filepath, position_end+1) )
    --client.log(tostring(latest_download))
    return
end
menu.set_float( "misc.aspect_ratio_value", aspectratio_backup )

keybind_pos_file_generated = false
if io.open("C:/iugenScript/keybind_pos.txt") ~= nil then
    keybind_pos_file_generated = true
end
if not keybind_pos_file_generated then file.write( "C:/iugenScript/keybind_pos.txt", "345 215" ) end
if file.read( "C:/iugenScript/keybind_pos.txt" ) == "" then file.write( "C:/iugenScript/keybind_pos.txt", "345 215" ) end

spectator_pos_file_generated = false
if io.open("C:/iugenScript/spectator_pos.txt") ~= nil then
    spectator_pos_file_generated = true
end
if not spectator_pos_file_generated then file.write( "C:/iugenScript/spectator_pos.txt", "695 215" ) end
if file.read( "C:/iugenScript/spectator_pos.txt" ) == "" then file.write( "C:/iugenScript/spectator_pos.txt", "695 215" ) end
font1gen = false
font2gen = false
font3gen = false
font4gen = false
font5gen = false
font6gen = false
font7gen = false
downloading = false
DownloadFont = function(from, to)
    wininet.DeleteUrlCacheEntryA(from)
    if io.open('C:\\iugenScript\\Fonts\\'..to) == nil then
    downloading = true    
    urlmon.URLDownloadToFileA(nil, from, 'C:\\iugenScript\\Fonts\\'..to, 0,0)
    end
end
DownloadFile = function(from, to)
    wininet.DeleteUrlCacheEntryA(from)
    if io.open('C:\\iugenScript\\'..to) == nil then
    downloading = true  
    urlmon.URLDownloadToFileA(nil, from, 'C:\\iugenScript\\'..to, 0,0)
    end
end
DownloadFont("https://github.com/whyisiugentaken/iugenscript-resources/blob/main/fonts/LW-LOGO.ttf?raw=true", "LW-LOGO.ttf")
DownloadFont("https://github.com/whyisiugentaken/iugenscript-resources/blob/main/fonts/Arrows.ttf?raw=true", "Arrows.ttf")
DownloadFont("https://github.com/whyisiugentaken/iugenscript-resources/blob/main/fonts/Product%20Sans%20Regular.ttf?raw=true", "Product Sans Regular.ttf")
DownloadFont("https://github.com/whyisiugentaken/iugenscript-resources/blob/main/fonts/Product%20Sans%20Italic.ttf?raw=true", "Product Sans Italic.ttf")
DownloadFont("https://github.com/whyisiugentaken/iugenscript-resources/blob/main/fonts/Product%20Sans%20Bold.ttf?raw=true", "Product Sans Bold.ttf")
DownloadFont("https://github.com/whyisiugentaken/iugenscript-resources/blob/main/fonts/Product%20Sans%20Bold%20Italic.ttf?raw=true", "Product Sans Bold Italic.ttf")
DownloadFont("https://github.com/whyisiugentaken/iugenscript-resources/blob/main/fonts/smallest_pixel-7.ttf?raw=true", "smallest_pixel-7.ttf")
DownloadFont("https://github.com/whyisiugentaken/iugenscript-resources/blob/main/fonts/Exo2-Bold.ttf?raw=true", "Exo2-Bold.ttf")
DownloadFont("https://github.com/whyisiugentaken/iugenscript-resources/blob/main/fonts/iugenIcons.ttf?raw=true", "iugenIcons.ttf")
DownloadFont("https://github.com/whyisiugentaken/iugenscript-resources/blob/main/fonts/MuseoSans-500.ttf?raw=true", "MuseoSans-500.ttf")
DownloadFile("https://github.com/whyisiugentaken/iugenscript-resources/blob/main/clash_mvp.wav?raw=true", "clash_mvp.wav")
DownloadFile("https://github.com/whyisiugentaken/iugenscript-resources/blob/main/heheheha.wav?raw=true", "heheheha.wav")
gdi.AddFontResourceA("C:/iugenScript/Fonts/LW-LOGO.ttf")
gdi.AddFontResourceA("C:/iugenScript/Fonts/Arrows.ttf")
gdi.AddFontResourceA("C:/iugenScript/Fonts/Product Sans Regular.ttf")
gdi.AddFontResourceA("C:/iugenScript/Fonts/Product Sans Italic.ttf")
gdi.AddFontResourceA("C:/iugenScript/Fonts/Product Sans Bold.ttf")
gdi.AddFontResourceA("C:/iugenScript/Fonts/Product Sans Bold Italic.ttf")
gdi.AddFontResourceA("C:/iugenScript/Fonts/smallest_pixel-7.ttf")
gdi.AddFontResourceA("C:/iugenScript/Fonts/Exo2-Bold.ttf")
gdi.AddFontResourceA("C:/iugenScript/Fonts/iugenIcons.ttf")
gdi.AddFontResourceA("C:/iugenScript/Fonts/MuseoSans-500.ttf")
ffi.cdef[[ struct c_color { unsigned char clr[4]; }; ]]
console_color = ffi.new('struct c_color'); console_color.clr[3] = 255;
console_blue = ffi.new('struct c_color'); console_blue.clr[3] = 255;
engine_cvar = ffi.cast("void***", utils.create_interface("vstdlib.dll", "VEngineCvar007"))
console_print = ffi.cast("void(__cdecl*)(void*, const struct c_color&, const char*, ...)", engine_cvar[0][25])
console_color.clr[0] = 255
console_color.clr[1] = 255
console_color.clr[2] = 255
console_blue.clr[0] = 130
console_blue.clr[1] = 200
console_blue.clr[2] = 255
console.execute( "clear" )
if beta then
    console_print(engine_cvar, console_color, "\n" )
    console_print(engine_cvar, console_color, "     _                       ")
    console_print(engine_cvar, console_blue, "_____           _       __     ____       __       \n")
    console_print(engine_cvar, console_color, "    (_)_  ______ ____  ____ ")
    console_print(engine_cvar, console_blue, "/ ___/__________(_)___  / /_   / __ )___  / /_____ _\n")
    console_print(engine_cvar, console_color, "   / / / / / __ `/ _ \\/ __ \\")
    console_print(engine_cvar, console_blue, "\\__ \\/ ___/ ___/ / __ \\/ __/  / __  / _ \\/ __/ __ `/\n")
    console_print(engine_cvar, console_color, "  / / /_/ / /_/ /  __/ / / /")
    console_print(engine_cvar, console_blue, "__/ / /__/ /  / / /_/ / /_   / /_/ /  __/ /_/ /_/ / \n")
    console_print(engine_cvar, console_color, " /_/\\__,_/\\__, /\\___/_/ /_/")
    console_print(engine_cvar, console_blue, "____/\\___/_/  /_/ .___/\\__/  /_____/\\___/\\__/\\__,_/  \n")
    console_print(engine_cvar, console_color, "         /____/                           ")
    console_print(engine_cvar, console_blue, "/_/           \n")
else
    console_print(engine_cvar, console_color, "\n" )
    console_print(engine_cvar, console_color, "     _                       ")
    console_print(engine_cvar, console_blue, "_____           _       __  \n")
    console_print(engine_cvar, console_color, "    (_)_  ______ ____  ____ ")
    console_print(engine_cvar, console_blue, "/ ___/__________(_)___  / /_\n")
    console_print(engine_cvar, console_color, "   / / / / / __ `/ _ \\/ __ \\")
    console_print(engine_cvar, console_blue, "\\__ \\/ ___/ ___/ / __ \\/ __/\n")
    console_print(engine_cvar, console_color, "  / / /_/ / /_/ /  __/ / / /")
    console_print(engine_cvar, console_blue, "__/ / /__/ /  / / /_/ / /_  \n")
    console_print(engine_cvar, console_color, " /_/\\__,_/\\__, /\\___/_/ /_/")
    console_print(engine_cvar, console_blue, "____/\\___/_/  /_/ .___/\\__/  \n")
    console_print(engine_cvar, console_color, "         /____/                           ")
    console_print(engine_cvar, console_blue, "/_/           \n")
end
console_color.clr[0] = 130
console_color.clr[1] = 200
console_color.clr[2] = 255
--console_print(engine_cvar, console_color, "\n▀█▀ ▒█░▒█ ▒█▀▀█ ▒█▀▀▀ ▒█▄░▒█ ▒█▀▀▀█ ▒█▀▀█ ▒█▀▀█ ▀█▀ ▒█▀▀█ ▀▀█▀▀\n▒█░ ▒█░▒█ ▒█░▄▄ ▒█▀▀▀ ▒█▒█▒█ ░▀▀▀▄▄ ▒█░░░ ▒█▄▄▀ ▒█░ ▒█▄▄█ ░▒█░░\n▄█▄ ░▀▄▄▀ ▒█▄▄█ ▒█▄▄▄ ▒█░░▀█ ▒█▄▄▄█ ▒█▄▄█ ▒█░▒█ ▄█▄ ▒█░░░ ░▒█░░\n")
--client.log( "" )
--client.log("     _                       _____           _       __  ")
--client.log("    (_)_  ______ ____  ____ / ___/__________(_)___  / /_")
--client.log("   / / / / / __ `/ _ \\/ __ \\\\__ \\/ ___/ ___/ / __ \\/ __/")
--client.log("  / / /_/ / /_/ /  __/ / / /__/ / /__/ /  / / /_/ / /_  ")
--client.log(" /_/\\__,_/\\__, /\\___/_/ /_/____/\\___/_/  /_/ .___/\\__/  ")
--client.log("         /____/                           /_/           ")
--client.log( "" )
--client.log( "" )
client.log( "" )
if downloading then
    client.log( "Downloaded all missing resources!" )
    downloading = false
end
if beta then
    client.log("Congratulations, you are a beta user!")
end
client.log( "Loaded succesfully! Welcome to iugenScript V"..tostring(version)..", "..tostring(globals.get_username()).."!" )
console_color.clr[0] = 130
console_color.clr[1] = 200
console_color.clr[2] = 255
console_print(engine_cvar, console_color, "\n"..changelog.."\n")
--client.log( "" )
--client.log( "" )
client.log( "" )

print_intro = true
intro_time = globals.get_curtime()
intro_alpha = 0
function math.lerp(a, b, t) return a + (b - a) * t end

introfont = render.create_font("Product Sans Italic", 48, 500, true, true)
introfontbold = render.create_font("Product Sans Bold Italic", 48, 500, true, true)
introfontsmall = render.create_font("Product Sans Italic", 35, 500, true, true)

local function intro()
    if globals.get_curtime() < intro_time + 5 and print_intro and not engine.is_in_game() then

        if globals.get_curtime() < intro_time + 2 then
            intro_alpha = math.floor(math.lerp(intro_alpha, 255, 0.01))
        else intro_alpha = math.floor(math.lerp(intro_alpha, 0, 0.01))
        end
        --render.draw_text_centered( font, engine.get_screen_width() / 2, engine.get_screen_height() - 300, color.new(255, 255, 255, intro_alpha), true, true, "iugenScript" )
        --if downloading then
        --    render.draw_text_centered( introfont, engine.get_screen_width() / 2, engine.get_screen_height() - 100, color.new(255, 255, 255), true, true, "Downloading missing files..." )
        --end
        render.draw_text_centered(introfont, engine.get_screen_width() / 2 - render.get_text_width( introfont, "iugen" ) - 6, engine.get_screen_height() - 105, color.new(255, 255, 255, intro_alpha), false, true, "iugen" )
        render.draw_text_centered(introfontbold, engine.get_screen_width() / 2 - 6, engine.get_screen_height() - 105, color.new(130, 200, 255, intro_alpha), false, true, "Script" )
        render.draw_text_centered( introfontsmall, engine.get_screen_width() / 2, engine.get_screen_height() - 65, color.new(255, 255, 255, intro_alpha), true, true, "Welcome back, "..globals.get_username().."!" )
    else print_intro = false end
end

items = {}
items.general = {}
items.aa = {}
items.rage = {}
items.visuals = {}
items.misc = {}
--menu.add_combo_box( "Tab", {"General", "Anti-Aim", "Rage", "Visuals", "Misc"} )

menu.next_line()
menu.add_slider_int("|    |    |    |    |    |    |    |    |    |    |    |    |    |    |    ", 0, 0)
menu.add_slider_int("                          Anti-Aim", 0, 0)
menu:next_line()

menu.add_check_box( "Knife round mode" )
menu.add_combo_box( "Presets", {"Custom", "Cheat settings", "iugen's preset", "iugen's preset v2", "Tank AA", "Adaptive Desync", "Adaptive Jitter", "Experimental"} )
menu.add_slider_int( "Tank AA Range", 10, 60 )
menu.next_line()

menu.add_combo_box("                 -----Normal-----", {"Disabled", "Static", "Jitter", "Random"})
menu.add_slider_int( "Minimum/Static", 1, 60 )
menu.add_slider_int( "Maximum", 1, 60 )
--menu.add_check_box( "Desync type" )
menu.add_combo_box("Desync type", {"Static", "Default Jitter", "Random Jitter", "Flick"} )
menu.add_slider_int( "Yaw Jitter", 0, 180 )
menu.add_slider_int( "Randomize Jitter", 0, 180 )
menu.add_combo_box("Jitter type", {"Static", "Three-way"} )
menu.add_combo_box("                -----Jumping-----", {"Disabled", "Static", "Jitter", "Random"})
menu.add_slider_int( "Minimum/Static ", 1, 60 )
menu.add_slider_int( "Maximum ", 1, 60 )
--menu.add_check_box( "Desync type while jumping" )
menu.add_combo_box("Desync type while jumping", {"Static", "Default Jitter", "Random Jitter", "Flick"} )
menu.add_slider_int( "Yaw Jitter while jumping", 0, 180 )
menu.add_slider_int( "Randomize Jitter ", 0, 180 )
menu.add_combo_box("Jitter type ", {"Static", "Three-way"} )
menu.add_combo_box("                -----Running-----", {"Disabled", "Static", "Jitter", "Random"} )
menu.add_slider_int( "Minimum/Static  ", 1, 60 )
menu.add_slider_int( "Maximum  ", 1, 60 )
--menu.add_check_box( "Desync type while running" )
menu.add_combo_box("Desync type while running", {"Static", "Default Jitter", "Random Jitter", "Flick"} )
menu.add_slider_int( "Yaw Jitter while running", 0, 180 )
menu.add_slider_int( "Randomize Jitter  ", 0, 180 )
menu.add_combo_box("Jitter type  ", {"Static", "Three-way"} )
menu.add_combo_box("               -----Slow walk-----", {"Disabled", "Static", "Jitter", "Random"} )
menu.add_slider_int( "Minimum/Static   ", 1, 60 )
menu.add_slider_int( "Maximum   ", 1, 60 )
--menu.add_check_box( "Desync type on slow walk" )
menu.add_combo_box("Desync type on slow walk", {"Static", "Default Jitter", "Random Jitter", "Flick"} )
menu.add_slider_int( "Yaw Jitter on slow walk", 0, 180 )
menu.add_slider_int( "Randomize Jitter   ", 0, 180 )
menu.add_combo_box("Jitter type   ", {"Static", "Three-way"} )
menu.next_line()
menu.add_combo_box("               -----Roll AA-----", {" ↓   ↓   ↓   ↓   ↓   ↓   ↓"} )
menu.add_key_bind( "Roll Bind" )
menu.add_check_box( "Disable on high velocity" )
menu.add_combo_box("Roll range", {"Static", "Jitter", "Random"} )
menu.add_slider_int( "Minimum/Static    ", 1, 50 )
menu.add_slider_int( "Maximum    ", 1, 50 )
menu.add_combo_box("Desync range", {"Disabled", "Static", "Jitter", "Random"} )
menu.add_slider_int( "Minimum/Static     ", 1, 60 )
menu.add_slider_int( "Maximum     ", 1, 60 )
--menu.add_check_box( "Desync type on slow walk" )
menu.add_combo_box("Desync type while using roll", {"Static", "Default Jitter", "Random Jitter", "Flick"} )
menu.add_slider_int( "Yaw Jitter while using roll", 0, 180 )
menu.add_slider_int( "Randomize Jitter    ", 0, 180 )
menu.add_combo_box("Jitter type    ", {"Static", "Three-way"} )
menu.next_line()
menu.add_slider_int( "                  -----Others-----", 0, 0 )
menu.next_line()
menu.add_slider_int( "Yaw left offset", -180, 180 )
menu.add_slider_int( "Yaw right offset", -180, 180 )
menu.add_key_bind( "Legit AA" )
menu.add_slider_int( "Range", 1, 60 )
menu.add_check_box( "Freestanding on key" )
menu.next_line()
menu.add_key_bind( "Freestanding Bind" )
menu.next_line()
menu.add_combo_box( "Onshot Desync type", {"Disabled", "Switch", "Jitter", "Jitter + Switch"} )
menu.add_check_box( "Only use Yaw Jitter on DT" )
menu.add_check_box( "Disable Fake Lag on DT" )
menu.add_check_box( "Disable Fake Lag on shot" )
menu.add_slider_int( "Randomize Fake Lag", 0, 16 )
menu.add_slider_int( "      ", 0, 16 )
edge_active = false
--menu.add_slider_int("Low delta range", 0, 60 )
--local slowwalk = false

speed = 0
force_dt = 0
tankrange = 60
desync = 50
roll_range = 50
yaw_jitter = 0
randomize_jitter = 0
jitter_type = 1
force_modifier = 0
modifier = 0
yaw_offset = 0
yaw_offset_backup = 0
player_jumping = 0
player_crouching = 0
seed_jitter = 0
jitter_allowed = 1
lag_proced = 0
tickcount = 0
tankproc = false
invertspam = false
onshot_active = 0
onshot_jittering = 0
onshot_backup = 0
onshot_ticker = 0
ideal_tick_fl_off = false
ideal_tick_freestanding = false

pitch_backup = menu.get_int("anti_aim.pitch")
yaw_backup = menu.get_int("anti_aim.yaw_offset")
yaw_modifier_backup = menu.get_int("anti_aim.yaw_modifier")
yaw_base_backup = menu.get_int("anti_aim.target_yaw")
freestanding_backup = menu.get_bool( "anti_aim.freestanding")
pitch_backup_2 = menu.get_int("anti_aim.pitch")
yaw_backup_2 = menu.get_int("anti_aim.yaw_offset")
yaw_modifier_backup_2 = menu.get_int("anti_aim.yaw_modifier")
yaw_base_backup_2 = menu.get_int("anti_aim.target_yaw")
freestanding_backup_2 = menu.get_bool( "anti_aim.freestanding")
in_use_ticks = 0
legit_aa_active = false
knife_round_active = false

verdana = render.create_font("Product Sans", 18, 700, true)

function mod(a, b)
    return a - (math.floor(a/b)*b)
end
script_loaded = true

local player_shots = {}
for i = 0, 64 do player_shots[i] = 0.0 end
proccount = 0
antiaim_counter = 0
exp_desync_type = 1

events.register_event("player_hurt", function(event)
    local entity_id = engine.get_player_for_user_id( event:get_int("userid") )
    local lc = entitylist.get_local_player()
    if not lc then return end
    if entity_id == lc:get_index() then
        if menu.get_key_bind_state("anti_aim.invert_desync_key") then
            menu.set_bool("anti_aim.invert_desync_key", false)
        else
            menu.set_bool("anti_aim.invert_desync_key", true)
        end
        proccount = proccount + 1
        antiaim_counter = antiaim_counter + 1
        exp_desync_type = math.random(1, 2)
    end
    player_shots[engine.get_player_for_user_id(event:get_int("userid"))] = globals.get_curtime()
end)

local function aa(cmd)

    if not script_loaded then return end

    math.randomseed(cmd.command_number)

    if mod(cmd.command_number, math.random(3, 5)) == 0 then
    --if math.random(3, 5) == 4 then
        if seed_jitter == 1 then
            seed_jitter = 0
        else
            seed_jitter = 1
        end
    end

    local localplayer = entitylist.get_local_player()
    local velocity = localplayer:get_velocity()
    speed = velocity:length_2d()

    flag = localplayer:get_prop_int("CBasePlayer", "m_fFlags")
    --client.log(tostring(flag))
    if flag == 256 or flag == 262 then
        player_jumping = 1
    else player_jumping = 0 end
    if flag == 261 or flag == 263 then
        player_crouching = 1
    else player_crouching = 0 end

    local defusing = localplayer:get_prop_bool("CCSPlayer", "m_bIsDefusing")
    local rescuing = localplayer:get_prop_bool("CCSPlayer", "m_bIsGrabbingHostage")
    --client.log("ammo: "..tostring(localplayer:get_prop_int("CCSPlayer", "m_iAmmo")))
    --client.log("pose: "..tostring(localplayer:get_prop_int("CCSPlayer", "m_flPoseParameter")))
    --localplayer:set_prop_int("CCSPlayer", "m_flPoseParameter", 0)
    local havec4 = false
    local weap = entitylist.get_weapon_by_player(localplayer)
    if weap then
        local idx = weap:get_prop_int("CBaseCombatWeapon", "m_iItemDefinitionIndex")
        havec4 = idx == 49
    end
    if menu.get_key_bind_state("Legit AA") then
        in_use_ticks = in_use_ticks + 1
        if in_use_ticks > 5 then
            if defusing or rescuing or havec4 then
                in_use_ticks = 0
                return
            end

            legit_aa_active = true

            cmd.buttons = bit.band(cmd.buttons, bit.bnot(32))

            menu.set_int("anti_aim.pitch", 0)
            menu.set_int("anti_aim.yaw_offset", 180)
            menu.set_int("anti_aim.target_yaw", 0)
            menu.set_int("anti_aim.desync_type", 1)
            menu.set_int("anti_aim.yaw_modifier", 0)
            menu.set_bool( "anti_aim.freestanding", false )
            menu.set_int("anti_aim.desync_range", menu.get_int("Range"))
            menu.set_int("anti_aim.desync_range_inverted", menu.get_int("Range"))
            menu.set_bool( "anti_aim.roll", false )
        end
    end
    if menu.get_bool("Knife round mode") and not legit_aa_active then

        legit_aa_active = true

        menu.set_int("anti_aim.pitch", 0)
        menu.set_int("anti_aim.yaw_offset", 180)
        menu.set_int("anti_aim.target_yaw", 1)
        menu.set_int("anti_aim.desync_type", 1)
        menu.set_bool( "anti_aim.freestanding", false )

    end
    
    local tickphase = globals.get_tickcount() % 4
    if globals.get_tickcount() % 4 == 0 or globals.get_tickcount() % 4 == 1 then
        tickphase = 0
    else tickphase = 1 end

    if not legit_aa_active then
    if menu.get_int( "Presets" ) == 0 then
        normal = menu.get_int( "                 -----Normal-----" )
        normal_min = menu.get_int( "Minimum/Static" )
        normal_max = menu.get_int( "Maximum" )

        jumping = menu.get_int( "                -----Jumping-----" )
        jumping_min = menu.get_int( "Minimum/Static " )
        jumping_max = menu.get_int( "Maximum " )

        running = menu.get_int( "                -----Running-----" )
        running_min = menu.get_int( "Minimum/Static  " )
        running_max = menu.get_int( "Maximum  " )

        slowwalk = menu.get_int( "               -----Slow walk-----" )
        slowwalk_min = menu.get_int( "Minimum/Static   " )
        slowwalk_max = menu.get_int( "Maximum   " )

        roll = menu.get_key_bind_state( "Roll Bind" )
        roll_type = menu.get_int( "Roll range" )
        roll_min = menu.get_int( "Minimum/Static    " )
        roll_max = menu.get_int( "Maximum    " )
        roll_desync_type = menu.get_int( "Desync range" )
        roll_desync_min = menu.get_int( "Minimum/Static     " )
        roll_desync_max = menu.get_int( "Maximum     " )

        --Roll
        if roll then
            if roll_type == 0 then
                roll_range = roll_min
            elseif roll_type == 1 then
                if tickphase == 0 then
                    roll_range = roll_min
                else
                    roll_range = roll_max
                end
            elseif roll_type == 2 then
                roll_range = math.random(roll_min, roll_max)
            end
            if roll_desync_type == 1 then
                desync = roll_desync_min
            elseif roll_desync_type == 2 then
                if tickphase == 0 then
                    desync = roll_desync_min
                else
                    desync = roll_desync_max
                end
            elseif roll_desync_type == 3 then
                desync = math.random(roll_desync_min, roll_desync_max)
            end
        --Jumping
        elseif player_jumping == 1 and jumping ~= 0 then
            if jumping == 1 then
                desync = jumping_min
            elseif jumping == 2 then
                if tickphase == 0 then
                    desync = jumping_min
                else
                    desync = jumping_max
                end
            elseif jumping == 3 then
                desync = math.random(jumping_min, jumping_max)
            end
        --Running
        elseif speed > 150 and running ~= 0 then
            if running == 1 then
                desync = running_min
            elseif running == 2 then
                if tickphase == 0 then
                    desync = running_min
                else
                    desync = running_max
                end
            elseif running == 3 then
                desync = math.random(running_min, running_max)
            end
        --Slow walk
        elseif menu.get_key_bind_state("misc.slow_walk_key") and slowwalk ~= 0 then
            if slowwalk == 1 then
                desync = slowwalk_min
            elseif slowwalk == 2 then
                if tickphase == 0 then
                    desync = slowwalk_min
                else
                    desync = slowwalk_max
                end
            elseif slowwalk == 3 then
                desync = math.random(slowwalk_min, slowwalk_max)
            end
        --Normal
        elseif normal ~= 0 then
            if normal == 1 then
                desync = normal_min
            elseif normal == 2 then
                if tickphase == 0 then
                    desync = normal_min
                else
                    desync = normal_max
                end
            elseif normal == 3 then
                desync = math.random(normal_min, normal_max)
            end
        end

        menu.set_int("anti_aim.desync_range", desync)
        menu.set_int("anti_aim.desync_range_inverted", desync)
        menu.set_bool("anti_aim.roll", roll)
        menu.set_bool("anti_aim.disable_on_high_velocity", menu.get_bool("Disable on high velocity"))
        menu.set_int("anti_aim.roll_range", roll_range)

        if roll and menu.get_int("Desync type while using roll") ~= 0 then
            if menu.get_int("Desync type while using roll") == 1 then
                menu.set_int("anti_aim.desync_type", 2)
                invertspam = false
            elseif menu.get_int("Desync type while using roll") == 2 then
                menu.set_int("anti_aim.desync_type", 1)
                menu.set_int("anti_aim.invert_desync_key", seed_jitter)
                invertspam = true
            elseif menu.get_int("Desync type while using roll") == 3 then
                menu.set_int("anti_aim.desync_type", 3)
                invertspam = false
            end
        elseif player_jumping == 1 and menu.get_int("Desync type while jumping") ~= 0 then
            if menu.get_int("Desync type while jumping") == 1 then
                menu.set_int("anti_aim.desync_type", 2)
                invertspam = false
            elseif menu.get_int("Desync type while jumping") == 2 then
                menu.set_int("anti_aim.desync_type", 1)
                menu.set_int("anti_aim.invert_desync_key", seed_jitter)
                invertspam = true
            elseif menu.get_int("Desync type while jumping") == 3 then
                menu.set_int("anti_aim.desync_type", 3)
                invertspam = false
            end
        elseif speed > 150 and menu.get_int("Desync type while running") ~= 0 and player_jumping == 0 then
            if menu.get_int("Desync type while running") == 1 then
                menu.set_int("anti_aim.desync_type", 2)
                invertspam = false
            elseif menu.get_int("Desync type while running") == 2 then
                menu.set_int("anti_aim.desync_type", 1)
                menu.set_int("anti_aim.invert_desync_key", seed_jitter)
                invertspam = true
            elseif menu.get_int("Desync type while running") == 3 then
                menu.set_int("anti_aim.desync_type", 3)
                invertspam = false
            end
        elseif menu.get_key_bind_state("misc.slow_walk_key") and menu.get_int("Desync type on slow walk") ~= 0 and player_jumping == 0 then
            if menu.get_int("Desync type on slow walk") == 1 then
                menu.set_int("anti_aim.desync_type", 2)
                invertspam = false
            elseif menu.get_int("Desync type on slow walk") == 2 then
                menu.set_int("anti_aim.desync_type", 1)
                menu.set_int("anti_aim.invert_desync_key", seed_jitter)
                invertspam = true
            elseif menu.get_int("Desync type on slow walk") == 3 then
                menu.set_int("anti_aim.desync_type", 3)
                invertspam = false
            end
        elseif menu.get_int("Desync type") ~= 0 and speed <= 150 and player_jumping == 0 and not menu.get_key_bind_state("misc.slow_walk_key") then
            if menu.get_int("Desync type") == 1 then
                menu.set_int("anti_aim.desync_type", 2)
            elseif menu.get_int("Desync type") == 2 then
                menu.set_int("anti_aim.desync_type", 1)
                menu.set_int("anti_aim.invert_desync_key", seed_jitter)
                invertspam = true
            elseif menu.get_int("Desync type") == 3 then
                menu.set_int("anti_aim.desync_type", 3)
                invertspam = false
            end
        else menu.set_int("anti_aim.desync_type", 1)
            invertspam = false
        end

        if roll then
            yaw_jitter = menu.get_int("Yaw Jitter while using roll")
            randomize_jitter = menu.get_int("Randomize Jitter    ")
            jitter_type = menu.get_int("Jitter type    ")
        elseif player_jumping == 1 then
            yaw_jitter = menu.get_int("Yaw Jitter while jumping")
            randomize_jitter = menu.get_int("Randomize Jitter ")
            jitter_type = menu.get_int("Jitter type ")
        elseif speed > 150 then
            yaw_jitter = menu.get_int("Yaw Jitter while running")
            randomize_jitter = menu.get_int("Randomize Jitter  ")
            jitter_type = menu.get_int("Jitter type  ")
        elseif menu.get_key_bind_state("misc.slow_walk_key") then
            yaw_jitter = menu.get_int("Yaw Jitter on slow walk")
            randomize_jitter = menu.get_int("Randomize Jitter   ")
            jitter_type = menu.get_int("Jitter type   ")
        elseif menu.get_int("Yaw Jitter") > 0 and speed <= 150 and not menu.get_key_bind_state("misc.slow_walk_key") then
            yaw_jitter = menu.get_int("Yaw Jitter")
            randomize_jitter = menu.get_int("Randomize Jitter")
            jitter_type = menu.get_int("Jitter type")
        else
            yaw_jitter = 0
            jitter_type = 0
        end
    elseif menu.get_int( "Presets" ) == 2 then

        invertspam = false
        --Jumping
        if player_jumping == 1 then
            desync = 20
            yaw_jitter = 0
        --Running
        elseif speed > 150 then
            desync = 35
            yaw_jitter = math.random(10, 15)
        --Slow walk
        elseif menu.get_key_bind_state("misc.slow_walk_key") then
            desync = math.random(20, 30)
            yaw_jitter = 0
        --Normal
        else
            desync = 45
            yaw_jitter = math.random(5, 10)
        end

        if speed > 150 then
            menu.set_int("anti_aim.desync_type", 2)
        else menu.set_int("anti_aim.desync_type", 1) end

        menu.set_int("anti_aim.desync_range", desync)
        menu.set_int("anti_aim.desync_range_inverted", desync)
        menu.set_bool("anti_aim.roll", menu.get_key_bind_state( "Roll Bind" ))
        menu.set_bool("anti_aim.disable_on_high_velocity", true)
        menu.set_int("anti_aim.roll_range", 50)

    elseif menu.get_int( "Presets" ) == 3 then
        --iugen's preset v2

        invertspam = false
        --Jumping
        if player_jumping == 1 then
            if tickphase == 0 then
                desync = 15 --was 1
            else
                desync = 22 -- was 15
            end
            yaw_jitter = 5 -- was 50
        --Running
        elseif speed > 150 then
            desync = 60
            yaw_jitter = 30
        --Slow walk
        elseif menu.get_key_bind_state("misc.slow_walk_key") then
            if tickphase == 0 then
                desync = 8
            else
                desync = 18
            end
            yaw_jitter = 20
        --Normal
        else
            if tickphase == 0 then
                desync = 45
            else
                desync = 20
            end
            yaw_jitter = 40
        end

        menu.set_int("anti_aim.desync_range", desync)
        menu.set_int("anti_aim.desync_range_inverted", desync)
        menu.set_int("anti_aim.desync_type", 1 )
        menu.set_bool("anti_aim.roll", menu.get_key_bind_state( "Roll Bind" ))
        menu.set_bool("anti_aim.disable_on_high_velocity", true)
        menu.set_int("anti_aim.roll_range", 50)

    elseif menu.get_int( "Presets" ) == 4 then
        --invertspam = true
        --tankrange = menu.get_int( "Tank AA Range" )
        --local assist1 = math.floor(tankrange / 3)
        --local assist2 = math.floor(tankrange / 2)
        --if globals.get_tickcount() % 3 == 1 then
        --    tankrange = assist1
        --elseif globals.get_tickcount() % 3 == 2 then
        --    tankrange = assist2
        --end
        if speed < 150 then
            tankrange = menu.get_int( "Tank AA Range" )
            menu.set_int( "anti_aim.yaw_modifier_range", math.random(20, 30) )
            menu.set_int("anti_aim.desync_range", math.floor(tankrange * 9 / 10))
            menu.set_int("anti_aim.desync_range_inverted", math.floor(tankrange * 9 / 10))
        else menu.set_int( "anti_aim.yaw_modifier_range", math.random(35, 45) )
            if globals.get_tickcount() % 4 == 0 or globals.get_tickcount() % 4 == 1 then
                tankrange = 18
            else
                tankrange = menu.get_int( "Tank AA Range" )
            end
            menu.set_int("anti_aim.desync_range", tankrange)
            menu.set_int("anti_aim.desync_range_inverted", tankrange)
        end
        
        if not menu.get_key_bind_state("misc.automatic_peek_key") then
            menu.set_int( "anti_aim.yaw_modifier", 1 )
            menu.set_int( "anti_aim.desync_type", 2 )
        else
            menu.set_int("anti_aim.desync_range", 60)
            menu.set_int("anti_aim.desync_range_inverted", 60)
            menu.set_int( "anti_aim.yaw_modifier", 0 )
            menu.set_int( "anti_aim.desync_type", 1 )
        end
        menu.set_bool("anti_aim.roll", menu.get_key_bind_state( "Roll Bind" ))
        menu.set_bool("anti_aim.disable_on_high_velocity", true)
        menu.set_int("anti_aim.roll_range", 50)
    elseif menu.get_int( "Presets" ) == 5 then
        invertspam = false
        if speed < 300 then
            desync = math.floor(speed / 5)
        end

        if desync < 10 then desync = 10 end

        menu.set_int("anti_aim.desync_range", desync)
        menu.set_int("anti_aim.desync_range_inverted", desync)
        menu.set_int("anti_aim.desync_type", 1)
        yaw_jitter = 0
        menu.set_bool("anti_aim.roll", menu.get_key_bind_state( "Roll Bind" ))
        menu.set_bool("anti_aim.disable_on_high_velocity", true)
        menu.set_int("anti_aim.roll_range", 50)
    elseif menu.get_int( "Presets" ) == 6 then
        invertspam = false
        if speed < 300 then
            desync = math.floor(speed / 5)
            yaw_jitter = math.floor(speed / 20)
        end

        if desync < 10 then desync = 10 end
        if yaw_jitter < 5 then yaw_jitter = 5 end

        if player_jumping == 1 then yaw_jitter = 5 end

        menu.set_int("anti_aim.desync_range", desync)
        menu.set_int("anti_aim.desync_range_inverted", desync)
        menu.set_int("anti_aim.desync_type", 1)
        menu.set_bool("anti_aim.roll", menu.get_key_bind_state( "Roll Bind" ))
        menu.set_bool("anti_aim.disable_on_high_velocity", true)
        menu.set_int("anti_aim.roll_range", 50)
    elseif menu.get_int( "Presets" ) == 7 then
        --To do
        maxspeed = localplayer:get_prop_float( "CBasePlayer", "m_flMaxspeed" ) 
        if antiaim_counter == 0 then
            desync = 45
            yaw_jitter = 30
        elseif antiaim_counter == 1 then
            desync = 18 --make static?
            yaw_jitter = 45
        elseif antiaim_counter == 2 then
            desync = 58
            yaw_jitter = 25
        elseif antiaim_counter == 3 then
            desync = 27
            yaw_jitter = 35
        elseif antiaim_counter == 4 then antiaim_counter = 0 end
        desync = math.floor(desync * (1-(speed/maxspeed/2)))
        menu.set_int( "anti_aim.desync_type", exp_desync_type )
        if player_jumping == 1 then
            if tickphase == 0 then
                desync = 15
            else
                desync = 22
            end
            yaw_jitter = 5
        end
        if player_crouching == 1 then
            menu.set_int( "anti_aim.desync_type", 2 )
        end
        if menu.get_int( "anti_aim.desync_type" ) == 2 and desync > 45 then desync = 45 end
        menu.set_int( "anti_aim.desync_range", desync )
        menu.set_int( "anti_aim.desync_range_inverted", desync )
        menu.set_bool("anti_aim.roll", menu.get_key_bind_state( "Roll Bind" ))
        menu.set_bool("anti_aim.disable_on_high_velocity", true)
        menu.set_int("anti_aim.roll_range", 50)
    end

    if menu.get_int( "Presets" ) == 1 then
        yaw_jitter = 0
    end

    if menu.get_bool( "Only use Yaw Jitter on DT" ) then
        if not menu.get_key_bind_state( "rage.double_tap_key" ) then
            yaw_jitter = 0
        end
    end

    if force_modifier == 0 then
        modifier = menu.get_int("anti_aim.yaw_modifier")
    end
    local jitter_set = jitter_type == 1 and 3 or 1
    if yaw_jitter > 0 then
        force_modifier = 1
        if menu.get_int("anti_aim.yaw_modifier") ~= jitter_set then
            menu.set_int("anti_aim.yaw_modifier", jitter_set)
        end
        if randomize_jitter ~= 0 then
            menu.set_int("anti_aim.yaw_modifier_range", math.random(yaw_jitter, randomize_jitter))
        else menu.set_int("anti_aim.yaw_modifier_range", yaw_jitter) end
    elseif force_modifier == 1 and modifier ~= 1 then
        menu.set_int("anti_aim.yaw_modifier", modifier)
        force_modifier = 0
    elseif force_modifier == 1 then
        menu.set_int("anti_aim.yaw_modifier", 0)
        force_modifier = 0
    end

    if menu.get_key_bind_state( "anti_aim.invert_desync_key" ) then
        yaw_offset = menu.get_int( "Yaw right offset" )
    else
        yaw_offset = menu.get_int( "Yaw left offset" )
    end

    --if menu.get_int( "anti_aim.desync_type" ) == 2 then yaw_offset = 0 end

    if force_yaw == 0 then
        yaw_offset_backup = menu.get_int( "anti_aim.yaw_offset" )
    end
    if yaw_offset ~= -180 then
        force_yaw = 1
        menu.set_int( "anti_aim.yaw_offset", yaw_offset )
    elseif force_yaw == 1 then
        menu.set_int( "anti_aim.yaw_offset", yaw_offset_backup )
        force_yaw = 0
    end
    end

    if menu.get_int("Randomize Fake Lag") > 0 then
        menu.set_int( "anti_aim.fake_lag_limit", math.random(menu.get_int("      "), menu.get_int("Randomize Fake Lag")) )
    end
        
    if menu.get_bool( "Freestanding on key" ) and not ideal_tick_freestanding then
        if not legit_aa_active and not menu.get_key_bind_state("anti_aim.manual_back_key") and not menu.get_key_bind_state("anti_aim.manual_left_key") and not menu.get_key_bind_state("anti_aim.manual_right_key") and not menu.get_key_bind_state("anti_aim.manual_forward_key") then
            if menu.get_key_bind_state( "Freestanding Bind" ) then
                menu.set_bool("anti_aim.freestanding", true)
            else
                menu.set_bool("anti_aim.freestanding", false)
            end
        end
    end
    if force_dt == 0 then
        if menu.get_int( "Onshot Desync type" ) == 1 then
            if onshot_active == 1 then
                if menu.get_key_bind_state("anti_aim.invert_desync_key") then
                    menu.set_bool("anti_aim.invert_desync_key", false)
                else
                    menu.set_bool("anti_aim.invert_desync_key", true)
                end
                onshot_active = 0
            end
        elseif menu.get_int( "Onshot Desync type" ) == 2 or menu.get_int( "Onshot Desync type" ) == 3 then
            if not onshot_jittering then
                onshot_backup = menu.get_int( "anti_aim.desync_type" )
            end
            if onshot_active == 1 then
                invertspam = true
                onshot_jittering = 1
                if menu.get_key_bind_state("anti_aim.invert_desync_key") then
                    menu.set_bool("anti_aim.invert_desync_key", false)
                else
                    menu.set_bool("anti_aim.invert_desync_key", true)
                end
                menu.set_int( "anti_aim.desync_type", 2 )
                onshot_ticker = onshot_ticker + 1
                if onshot_ticker == 32 then
                    onshot_ticker = 0
                    onshot_active = 0
                end
            elseif onshot_jittering == 1 then
                onshot_jittering = 0
                menu.set_int( "anti_aim.desync_type", onshot_backup )
                if menu.get_int( "Onshot Desync type" ) == 3 then
                    if menu.get_key_bind_state("anti_aim.invert_desync_key") then
                        menu.set_bool("anti_aim.invert_desync_key", false)
                    else
                        menu.set_bool("anti_aim.invert_desync_key", true)
                    end
                end
                invertspam = false
            end
        end
    end
end

--client.add_callback("create_move", aa)

local function legitaabackup()

    if not script_loaded then return end

    if not menu.get_key_bind_state("Legit AA") then
        if not legit_aa_active then
            pitch_backup = menu.get_int("anti_aim.pitch")
            yaw_backup = menu.get_int("anti_aim.yaw_offset")
            yaw_modifier_backup = menu.get_int("anti_aim.yaw_modifier")
            yaw_base_backup = menu.get_int("anti_aim.target_yaw")
            freestanding_backup = menu.get_bool( "anti_aim.freestanding" )
        end
        if in_use_ticks > 0 then
            in_use_ticks = 0
        end
        if legit_aa_active then
            menu.set_int("anti_aim.pitch", pitch_backup)
            menu.set_int("anti_aim.yaw_offset", yaw_backup)
            menu.set_int("anti_aim.yaw_modifier", yaw_modifier_backup)
            menu.set_int("anti_aim.target_yaw", yaw_base_backup)
            menu.set_bool( "anti_aim.freestanding", freestanding_backup)
            legit_aa_active = false
        end
    end
end

local function kniferoundbackup()

    if not script_loaded then return end
    if legit_aa_active then return end

    if not menu.get_bool("Knife round mode") then
        if not knife_round_active then
            pitch_backup_2 = menu.get_int("anti_aim.pitch")
            yaw_backup_2 = menu.get_int("anti_aim.yaw_offset")
            yaw_modifier_backup_2 = menu.get_int("anti_aim.yaw_modifier")
            yaw_base_backup_2 = menu.get_int("anti_aim.target_yaw")
            freestanding_backup_2 = menu.get_bool( "anti_aim.freestanding" )
        end
        if knife_round_active then
            menu.set_int("anti_aim.pitch", pitch_backup_2)
            menu.set_int("anti_aim.yaw_offset", yaw_backup_2)
            menu.set_int("anti_aim.yaw_modifier", yaw_modifier_backup_2)
            menu.set_int("anti_aim.target_yaw", yaw_base_backup_2)
            menu.set_bool( "anti_aim.freestanding", freestanding_backup_2)
            knife_round_active = false
        end
    end
end

local function flprocer()

    if not script_loaded then return end

    if menu.get_bool( "Disable Fake Lag on DT" ) or ideal_tick_fl_off then
        local me = entitylist.get_local_player()
        local wep = entitylist.get_weapon_by_player(me)

        local local_player = entitylist.get_local_player()
        if local_player == nil then return end
        local me = engine.get_local_player_index()
        local weapon = entitylist.get_weapon_by_player(local_player)
        if weapon then
            current_weapon = weapon:get_prop_int('CBaseCombatWeapon', 'm_iItemDefinitionIndex');
        end

        if current_weapon == 31 then
            tazer = true
        else tazer = false end

        if lag_proced == 0 then
            fl = menu.get_bool("anti_aim.enable_fake_lag")
        end
        if menu.get_key_bind_state("rage.double_tap_key") and not tazer then
            lag_proced = 1
            menu.set_bool("anti_aim.enable_fake_lag", false)
        elseif lag_proced == 1 then
            if fl then
                menu.set_bool("anti_aim.enable_fake_lag", true)
            end
            lag_proced = 0
        end
    elseif lag_proced == 1 then
        if fl then
            menu.set_bool("anti_aim.enable_fake_lag", true)
        end
        lag_proced = 0
    end
end

antios_enabled = false
osproced = false
os_ticker = 0

local function antios_starter(event)

    if not script_loaded then return end

    if not antios_enabled then return end
    local localplayer = entitylist.get_local_player()
    if not localplayer then return end
    local attacker = engine.get_player_for_user_id(event:get_int("userid"))
    if attacker == localplayer:get_index() and menu.get_bool("anti_aim.enable_fake_lag") and not menu.get_key_bind_state("rage.hide_shots_key") then
        osproced = true
    end
end

local function antios()

    if not script_loaded then return end

    antios_enabled = menu.get_bool( "Disable Fake Lag on shot" )
    if osproced then
        menu.set_bool("anti_aim.enable_fake_lag", false)
        os_ticker = os_ticker + 1
    end
    if os_ticker == 3 then
        osproced = false
        os_ticker = 0
        menu.set_bool("anti_aim.enable_fake_lag", true)
    end
end

--client.add_callback( "on_paint", flprocer )
--
--client.add_callback("on_paint", legitaabackup)

menu.next_line()
menu.add_slider_int("|    |    |    |    |    |    |    |    |    |    |    |    |    |    |     ", 0, 0)
menu.add_slider_int("                               Rage", 0, 0)
menu:next_line()
events.register_event( "weapon_reload", function(event)
    local localplayer = entitylist.get_local_player()
    if not localplayer then return end
    local reloader = engine.get_player_for_user_id(event:get_int("userid"))
    if reloader == localplayer:get_index() then
        --client.log("reloading")
    end
end )
events.register_event( "ammo_refill", function(event)
    local localplayer = entitylist.get_local_player()
    if not localplayer then return end
    local reloader = engine.get_player_for_user_id(event:get_int("userid"))
    if reloader == localplayer:get_index() then
        --client.log("reloaded")
    end
end )
menu.add_check_box( "Anti-Exploit" )
menu.add_slider_int("            -----Ideal Tick-----", 0, 0 )
menu.add_check_box("Ideal Tick on Autopeek")
menu.add_check_box("Disable Fake Lag on Ideal Tick")
menu.add_check_box("Freestanding on Ideal Tick")
menu.add_slider_int("Prefer Body-Aim on Force DMG:", 0, 0 )
menu.add_check_box("On Scout")
menu.add_combo_box("Mode:", {"Default", "Prefer", "Force"} )
menu.add_check_box("On Auto")
menu.add_combo_box("Mode: ", {"Default", "Prefer", "Force"} )
menu.add_check_box("On AWP")
menu.add_combo_box("Mode:  ", {"Default", "Prefer", "Force"} )
menu:next_line()

team = 0
time = globals.get_curtime()
impact = true
once2 = true
once1 = true
button_pressed = false
button_triggered = false
button_bak = menu.get_bool( "Anti-Exploit" )
local function ax()

    lc = entitylist.get_local_player()
    --if not lc then return end

    if button_bak ~= menu.get_bool( "Anti-Exploit" ) then
        impact = true
    else impact = false end
    if menu.get_bool( "Anti-Exploit" ) then
        button_bak = true
    else button_bak = false end
    if impact then
        time = globals.get_curtime()
        if lc then team = lc:get_team() end
        once2 = true
        once1 = true
        if not button_triggered then button_triggered = true end
        if menu.get_bool( "Anti-Exploit" ) then
            button_pressed = true
        else button_pressed = false end
        button_triggered = true
    end
    if button_pressed and button_triggered then
        if once1 then
            if console.get_int( "cl_lagcompensation" ) == 0 then return end
            if lc then console.execute( "jointeam 1" ) end
            if console.get_int( "cl_lagcompensation" ) == 1 then
                console.set_int( "cl_lagcompensation", 0 )
            end
            once1 = false
            client.log("Please wait...")
        end
        if (globals.get_curtime() > time + 1) and once2 then
            if lc then console.execute( "jointeam "..team.." 1" ) end
            once2 = false
            client.log("Anti-Exploit is now enabled!")
            button_triggered = false
        end
    elseif button_triggered then
        if once1 then
            if console.get_int( "cl_lagcompensation" ) == 1 then return end
            if lc then console.execute( "jointeam 1" ) end
            if console.get_int( "cl_lagcompensation" ) == 0 then
                console.set_int( "cl_lagcompensation", 1 )
            end
            once1 = false
            client.log("Please wait...")
        end
        if (globals.get_curtime() > time + 1) and once2 then
            if lc then console.execute( "jointeam "..team.." 1" ) end
            once2 = false
            client.log("Anti-Exploit is now disabled!")
            button_triggered = false
        end
    end
end

local function telepeek()
    if not script_loaded then return end
    if force_dt == 0 then
        dt = menu.get_key_bind_state("rage.double_tap_key")
        edge_active = menu.get_bool( "anti_aim.freestanding" )
    end
    if menu.get_bool("Ideal Tick on Autopeek") and menu.get_key_bind_state("misc.automatic_peek_key") then
        force_dt = 1
        menu.set_int("rage.double_tap_key", 1)
        if menu.get_bool( "Freestanding on Ideal Tick" ) and not legit_aa_active then
            menu.set_bool( "anti_aim.freestanding", true )
            ideal_tick_freestanding = true
        end
        if menu.get_bool("Disable Fake Lag on Ideal Tick") and menu.get_key_bind_state("misc.automatic_peek_key") then
            ideal_tick_fl_off = true
        end
    elseif force_dt == 1 then
        if not dt then
            menu.set_int("rage.double_tap_key", 0)
        end
        if not edge_active then
            menu.set_bool( "anti_aim.freestanding", false )
        end
        force_dt = 0
        ideal_tick_fl_off = false
        ideal_tick_freestanding = false
    end
end

force_baim_scout = 0
force_baim_auto = 0
force_baim_awp = 0
backup_scout = 0
backup_auto = 0
backup_awp = 0

local function baim()

    if not script_loaded then return end

    local me = entitylist.get_local_player()
    local wep = entitylist.get_weapon_by_player(me)

    local local_player = entitylist.get_local_player()
    if local_player == nil then return end
    local me = engine.get_local_player_index()
    local weapon = entitylist.get_weapon_by_player(local_player)
    if weapon then
        definition_index = weapon:get_prop_int('CBaseCombatWeapon', 'm_iItemDefinitionIndex');
    end

    --client.log(tostring(weapon:can_fire()))
    --local gun = 0

    if me and definition_index == 40 then --scout
        --gun = 3
        mode = menu.get_int("Mode:")
    elseif me and definition_index == 38 or definition_index == 11 then --auto
        --gun = 2
        mode = menu.get_int("Mode: ")
    elseif me and definition_index == 9 then --awp
        --gun = 4
        mode = menu.get_int("Mode:  ")
    end

    if menu.get_bool("On Scout") and me and definition_index == 40 then
        if force_baim_scout == 0 then
            backup_scout = menu.get_int("rage.weapon[3].body_aim")
        end
        if menu.get_key_bind_state("rage.force_damage_key") and mode ~= 0 then
            force_baim_scout = 1
            menu.set_int("rage.weapon[3].body_aim", mode)
        elseif force_baim_scout == 1 then
            menu.set_int("rage.weapon[3].body_aim", backup_scout)
            force_baim_scout = 0
        end
    end

    if menu.get_bool("On Auto") and me and definition_index == 38 or definition_index == 11 then
        if force_baim_auto == 0 then
            backup_auto = menu.get_int("rage.weapon[2].body_aim")
        end
        if menu.get_key_bind_state("rage.force_damage_key") and mode ~= 0 then
            force_baim_auto = 1
            menu.set_int("rage.weapon[2].body_aim", mode)
        elseif force_baim_auto == 1 then
            menu.set_int("rage.weapon[2].body_aim", backup_auto)
            force_baim_auto = 0
        end
    end

    if menu.get_bool("On AWP") and me and definition_index == 9 then
        if force_baim_awp == 0 then
            backup_awp = menu.get_int("rage.weapon[4].body_aim")
        end
        if menu.get_key_bind_state("rage.force_damage_key") and mode ~= 0 then
            force_baim_awp = 1
            menu.set_int("rage.weapon[4].body_aim", mode)
        elseif force_baim_awp == 1 then
            menu.set_int("rage.weapon[4].body_aim", backup_awp)
            force_baim_awp = 0
        end
    end
end

menu.next_line()
menu.add_slider_int("Hitchance helper:", 0, 0 )
menu.add_combo_box( "Jumpscout helper:" , {"Disabled", "Always", "Low velocity only"} )
menu.add_slider_int( "Jumpscout hitchance", 0, 100 )

jumpscouting = false
jumpscout_backup = 0
force_jumpscout_hc = 0
local function jumpscout()

    if not script_loaded then return end

    local localplayer = entitylist.get_local_player()
    if localplayer == nil then return end
    local velocity = localplayer:get_velocity()
    local speed = velocity:length_2d()
    local flag = localplayer:get_prop_int("CBasePlayer", "m_fFlags")
    if (flag == 256 or flag == 262) and (localplayer:get_health() > 0) then
        if menu.get_int( "Jumpscout helper:" ) == 2 and speed < 100 then
            jumpscouting = true
        elseif menu.get_int( "Jumpscout helper:" ) == 1 then
            jumpscouting = true
        elseif menu.get_int( "Jumpscout helper:" ) == 0 then
            jumpscouting = false
        end
    else jumpscouting = false end

    local Jumpscout_hc = menu.get_int( "Jumpscout hitchance" )
    
    if menu.get_int( "Jumpscout helper:" ) ~= 0 then
        if force_jumpscout_hc == 0 and not jumpscouting then
            jumpscout_backup = menu.get_int("rage.weapon[3].hit_chance")
        end
        if jumpscouting then
            force_jumpscout_hc = 1
            menu.set_int("rage.weapon[3].hit_chance", Jumpscout_hc)
        elseif force_jumpscout_hc == 1 then
            menu.set_int("rage.weapon[3].hit_chance", jumpscout_backup)
            force_jumpscout_hc = 0
        end
    end

    --client.log("force_jumpscout_hc "..tostring(force_jumpscout_hc))
    --client.log( "jumpscout_backup "..tostring(jumpscout_backup) )
    --client.log( "jumpscouting "..tostring(jumpscouting) )
end

--client.add_callback("create_move", telepeek)
--client.add_callback("on_paint", baim)
--client.add_callback("on_paint", jumpscout)

menu.next_line()
menu.add_slider_int("|    |    |    |    |    |    |    |    |    |    |    |    |    |    |      ", 0, 0)
menu.add_slider_int("                             Visuals", 0, 0)
menu:next_line()

menu.add_slider_int( "  -----Watermark/Keybinds-----", 0, 0 )

screensizex, screensizey = engine.get_screen_width(), engine.get_screen_height()
productsansbak = render.create_font("Product Sans", 18, 700, true)
productsans = render.create_font("Product Sans", 18, 700, true)
exobig = render.create_font("Exo 2 Bold", 18, 700, true)
logo = render.create_font("Lw Logo", 21, 0, true)
icons_small = render.create_font("iugenIcons", 14, 0, true)
icons = render.create_font("iugenIcons", 15, 0, true)
username = globals.get_username()

local function font_big_select()
    if not script_loaded then return end
    if menu.get_int( "Theme" ) == 1 then
        productsans = exobig
    else productsans = productsansbak end
    screensizex, screensizey = engine.get_screen_width(), engine.get_screen_height()
end

ffi.cdef[[
    int MessageBoxA(void *w, const char *txt, const char *cap, int type);
    bool CreateDirectoryA(const char* lpPathName, void* lpSecurityAttributes);
    int exit(int arg);

    void* __stdcall URLDownloadToFileA(void* LPUNKNOWN, const char* LPCSTR, const char* LPCSTR2, int a, int LPBINDSTATUSCALLBACK);        
    void* __stdcall ShellExecuteA(void* hwnd, const char* op, const char* file, const char* params, const char* dir, int show_cmd);

    int AddFontResourceA(const char* unnamedParam1);

    bool DeleteUrlCacheEntryA(const char* lpszUrlName);

    short GetAsyncKeyState(
        int vKey
    );

    void* GetProcAddress(void* hModule, const char* lpProcName);
    void* GetModuleHandleA(const char* lpModuleName);
 
    typedef struct {
        uint8_t r;
        uint8_t g;
        uint8_t b;
        uint8_t a;
    } color_struct_t;

    typedef void (*console_color_print)(const color_struct_t&, const char*, ...);

    typedef unsigned long DWORD, *PDWORD, *LPDWORD;  

    typedef void (__cdecl* chat_printf)(void*, int, int, const char*, ...);

    typedef struct {
        float x,y;
    } vec2_t;

    typedef struct {
        vec2_t m_Position;
        vec2_t m_TexCoord;
    } Vertex_t;

]]

local g_VGuiSurface = ffi.cast(ffi.typeof("void***"), utils.create_interface("vguimatsurface.dll", "VGUI_Surface031"))
local native_Surface_DrawSetColor = ffi.cast(ffi.typeof("void(__thiscall*)(void*, int, int, int, int)"), g_VGuiSurface[0][15])
local native_Surface_DrawFilledRectFade = ffi.cast(ffi.typeof("void(__thiscall*)(void*, int, int, int, int, unsigned int, unsigned int, bool)"), g_VGuiSurface[0][123])

local gradientRender = function(x, y, w, h, r0, g0, b0, a0, r1, g1, b1, a1, horizontal)
    native_Surface_DrawSetColor(g_VGuiSurface,r0, g0, b0, a0)
    native_Surface_DrawFilledRectFade(g_VGuiSurface,x, y, x + w, y + h, 255, 0, horizontal)
    native_Surface_DrawSetColor(g_VGuiSurface,r1, g1, b1, a1)
    return native_Surface_DrawFilledRectFade(g_VGuiSurface,x, y, x + w, y + h, 0, 255, horizontal)
end

local GradientRect = function(x, y, w, h, color, color2, horizontal)
    local r0, g0, b0, a0 = color:r(), color:g(), color:b(), color:a()
    local r1, g1, b1, a1 = color2:r(), color2:g(), color2:b(), color2:a()

    native_Surface_DrawSetColor(g_VGuiSurface,r0, g0, b0, a0)
    native_Surface_DrawFilledRectFade(g_VGuiSurface,x, y, x + w, y + h, 255, 0, horizontal)
    native_Surface_DrawSetColor(g_VGuiSurface,r1, g1, b1, a1)
    return native_Surface_DrawFilledRectFade(g_VGuiSurface,x, y, x + w, y + h, 0, 255, horizontal)
end
local GradientRectSec = function(x, y, w, h, color, color2, horizontal)
    local r0, g0, b0, a0 = color:r(), color:g(), color:b(), color:a()
    local r1, g1, b1, a1 = color2:r(), color2:g(), color2:b(), color2:a()

    native_Surface_DrawSetColor(g_VGuiSurface,r0, g0, b0, a0)
    native_Surface_DrawFilledRectFade(g_VGuiSurface,x, y, x + w, y + h, 0, 255, horizontal)
    native_Surface_DrawSetColor(g_VGuiSurface,r1, g1, b1, a1)
    return native_Surface_DrawFilledRectFade(g_VGuiSurface,x, y, x + w, y + h, 255, 0, horizontal)
end

local keycache = {}

--[[local GetCursorPos = function()
    local pointer = ffi.new("POINT[1]")
    ffi.C.GetCursorPos(pointer)
    return pointer[0]
end]]

ffi.cdef[[
    typedef int BOOL;
    typedef long LONG;
    typedef unsigned long HWND;
    typedef struct{
        LONG x, y;
    }POINT, *LPPOINT;
    
    typedef unsigned long DWORD, *PDWORD, *LPDWORD;  

    void* GetProcAddress(void* hModule, const char* lpProcName);
    void* GetModuleHandleA(const char* lpModuleName);

    short GetAsyncKeyState(int vKey);
    BOOL GetCursorPos(LPPOINT);
    HWND GetForegroundWindow();
    BOOL IsChild(HWND hWndParent, HWND hWnd);
    BOOL ScreenToClient(HWND hWnd, LPPOINT lpPoint);
    HWND FindWindowA(const char* lpClassName, const char* lpWindowName );

]]

local csgo_window = ffi.C.FindWindowA("Valve001", nil)

local function GetCursorPos()
    local hActiveWindow = ffi.C.GetForegroundWindow()
    if hActiveWindow == 0 then
        return vector.new(0,0,0)
    end

    if hActiveWindow ~= csgo_window and not ffi.C.IsChild(hActiveWindow, csgo_window) then
        return vector.new(0,0,0)
    end

    local ppoint = ffi.new("POINT[1]")
    if ffi.C.GetCursorPos(ppoint) == 0 then
        return vector.new(0,0,0)
        --error("Couldn't get cursor position!", 2)
    end

    if not ffi.C.ScreenToClient(csgo_window, ppoint) then
        return vector.new(0,0,0)
    end

    return vector.new(ppoint[0].x, ppoint[0].y, 0)
end

local KeyRelease = function(code)
    if ffi.C.GetAsyncKeyState(code) ~= 0 then
        keycache[code] = true
    else
        if keycache[code] then
            keycache[code] = false
            return true
        end
    end
end

menu.add_combo_box( "Theme", {"Default", "Modern", "Classic", "Side-Line (Bold)", "Side-Line (Slim)", "Rounded", "Rounded (Fade)"} )
menu.add_combo_box( "Watermark style", {"Disabled", "Default", "Classic", "Classic+"} )
menu.add_check_box("Text shadow")
menu.add_check_box( "Enable spectators list" )
menu.add_check_box( "Spectators background" )
menu.add_check_box( "Enable keybinds list" )
watermarkname = legendware
watermarkusername = globals.get_username()
menu.add_check_box( "Keybinds background" )
menu.add_check_box("Animated keybinds")
menu.add_check_box("Auto resize")
menu.add_combo_box("Line style", { "Static", "Fade", "Double Fade", "Reverse fade", "Gradient", "Skeet", "Chroma" })
menu.add_combo_box("Chroma direction", { "Left", "Right", "Static" })
menu.add_color_picker("Accent color")
menu.add_color_picker("Secondary color")

defaultfont = render.create_font( "Verdana", 12, 0, true)
tahoma = render.create_font( "Tahoma", 12, 300, true)
prodsanssmall = render.create_font( "Product Sans", 15, 700, true)
exo = render.create_font( "Exo 2 Bold", 17, 900, true)
local types = { "always", "hold", "toggle", "disabled" }
local last_choke = {[0] = 0, [1] = 0, [2] = 0, [3] = 0, [4] = 0}
local desynctext = ""
local fakelagtext = ""

local function font_select()
    if not script_loaded then return end
    if menu.get_int( "Theme" ) == 4 then
        verdana = tahoma
    elseif menu.get_int( "Theme" ) == 0 or menu.get_int( "Theme" ) == 3 then
        verdana = prodsanssmall
    elseif menu.get_int( "Theme" ) == 1 then
        verdana = exo
    else verdana = defaultfont
    end
end

--client.add_callback( "on_paint", font_select )

menu.add_slider_int( "            -----AA Indicators----- ", 0, 0 )

arrowsfont = render.create_font("ActaSymbolsW95-Arrows", 20, 900, true, false, false)
arrowsfontsmall = render.create_font("ActaSymbolsW95-Arrows", 8, 900, true, false, false)
indicator_font = render.create_font("Verdana", 23, 550, true, false, false)
--local dynamic_font = render.create_font("Verdana", 26, 200, true, false, false)
dynamic_font = render.create_font("ActaSymbolsW95-Arrows", 18, 100, true, true, false)
manual_font = render.create_font("Verdana", 44, 900, true, false, false)
textsize = render.get_text_width(arrowsfont, "Q")
menu.add_combo_box( "AA Arrows Style", {"Disabled", "Default", "Classic", "Dynamic"} )
menu.add_combo_box( "AA Indicators style", {"Disabled", "Default", "Small", "Acatel style", "Basic"} )
menu.add_check_box( "Holo panel" )

pixel = render.create_font("Smallest Pixel-7", 14, 0, true, true, true)
pixelsmall = render.create_font("Smallest Pixel-7", 11, 0, true, true, true)
pixelsmall2 = render.create_font("Smallest Pixel-7", 11, 300, true, true, true, true)
pixelbig = render.create_font("Smallest Pixel-7", 16, 300, true, true, false)
pixel0 = render.create_font("Smallest Pixel-7", 14, 300, true, true, false)
--pixel = render.create_font("Tahoma", 10, 0, false, true, true)
font = render.create_font("Product Sans", 24, 500, true, true)
fontsmall = render.create_font("Product Sans", 18, 500, true, true)
fontbold = render.create_font("Product Sans Bold", 24, 500, true, true)
fontitalic = render.create_font("Product Sans Italic", 24, 500, true, true)
fontbolditalic = render.create_font("Product Sans Bold Italic", 24, 500, true, true)
leftcolor = color.new(255, 255, 255, 255)
rightcolor = color.new(255, 255, 255, 255)
menu.next_line()
menu.add_color_picker("Script color")
menu.add_check_box( "Fully colored logo" )
menu.next_line()
menu.add_check_box("Show desync range")
menu.add_check_box("Show minimum damage")
menu.add_check_box("Show other indicators")
menu.next_line()
menu.add_slider_int( "          -----Custom scope----- ", 0, 0 )
menu.add_check_box( "Enable custom scope" )
menu.add_check_box( "Show inaccuracy" )
menu.next_line()
menu.add_color_picker("Primary scope color")
menu.add_color_picker("Secondary scope color")
menu.add_slider_int("Scope animation speed", 5, 20)
menu.add_slider_int("Scope offset", 0, 300)
menu.add_slider_int("Scope length", 0, 400)
menu.add_slider_int("Scope thickness", 1, 3)
menu.next_line()
menu.add_slider_int( "                     -----Logs----- ", 0, 0 )
menu.add_combo_box( "Logs style", {"Disabled", "Neverlose V1", "Neverlose V1.5", "Under-Crosshair (Simple)", "Under-Crosshair (Box)"} )
menu.add_check_box( "Console logs" )
menu.next_line()
menu.add_color_picker( "Logs color" )
menu.next_line()

local function hsv2rgb(h, s, v, a)
    local r, g, b = 0, 0, 0

    local i = math.floor(h * 6);
	--local i = 3
    local f = h * 6 - i;
    local p = v * (1 - s);
    local q = v * (1 - f * s);
    local t = v * (1 - (1 - f) * s);

    i = i % 6

    if i == 0 then r, g, b = v, t, p
    elseif i == 1 then r, g, b = q, v, p
    elseif i == 2 then r, g, b = p, v, t
    elseif i == 3 then r, g, b = p, q, v
    elseif i == 4 then r, g, b = t, p, v
    elseif i == 5 then r, g, b = v, p, q
    end

	return color.new(math.floor(r * 255), math.floor(g * 255), math.floor(b * 255), math.floor(a * 255))
end

rainbowvalue = 0.00

local function filledbox(x, y, w, h, al)
    --rainbowvalue = rainbowvalue + (globals.get_frametime() * 0.1)
    --if rainbowvalue > 1.0 then 
    --    rainbowvalue = 0.0
    --end
    --local rgb = hsv2rgb(rainbowvalue, 1, 1, 1)
    local rgb = hsv2rgb(globals.get_realtime() / 4, 1, 1, 1)
	local chromd = menu.get_int("Chroma direction")
	local col = menu.get_color("Accent color")
	local col2 = menu.get_color("Secondary color")
	local stl = menu.get_int("Line style")

    if menu.get_int( "Theme" ) == 2 then
	    if stl ~= 5 then
	        render.draw_rect_filled(x, y, w, h, color.new(15, 15, 15, math.floor(col:a() * al / 255)))
	    else
	        render.draw_rect_filled(x, y-2, w, h + 2, color.new(30, 30, 30, math.floor(col:a() * al / 255)))
	        GradientRect(x + 1, y - 1, w / 2, 1, color.new(0, 213, 255, al), color.new(204, 18, 204, al), true)
	        GradientRect(x + (w / 2), y - 1, w / 2 - 1, 1, color.new(204, 18, 204, al), color.new(255, 250, 0, al), true)
	    end
    
	    gradient_color = stl == 0 and color.new(col:r(), col:g(), col:b(), al) or stl == 1 and color.new(0, 0, 0, math.floor(col:a() * al / 255)) or stl == 3 and color.new(col:r(), col:g(), col:b(), al) or stl == 4 and color.new(0, 213, 255, al) or stl == 6 and color.new(chromd==1 and rgb:g() or rgb:r(), chromd==1 and rgb:b() or rgb:g(), chromd ==1 and rgb:g() or rgb:b(), al) or color.new(0, 0, 0, 0)
	    gradient_color1 = stl == 0 and color.new(col:r(), col:g(), col:b(), al) or stl == 1 and color.new(col:r(), col:g(), col:b(), al) or stl == 3 and color.new(0, 0, 0, math.floor(col:a() * al / 255)) or stl == 4 and color.new(204, 18, 204, al) or stl == 6 and color.new(chromd==2 and rgb:r() or rgb:b(), chromd==2 and rgb:g() or rgb:r(), chromd==2 and rgb:b() or rgb:g(), al) or color.new(0, 0, 0, 0)
	    gradient_color2 = stl == 0 and color.new(col:r(), col:g(), col:b(), al) or stl == 1 and color.new(0, 0, 0, math.floor(col:a() * al / 255)) or stl == 3 and color.new(col:r(), col:g(), col:b(), al) or stl == 4 and color.new(255, 250, 0, al) or stl == 6 and color.new(chromd==0 and rgb:g() or rgb:r(), chromd==0 and rgb:b() or rgb:g(), chromd ==0 and rgb:g() or rgb:b(), al) or color.new(0, 0, 0, 0)

	    if stl ~= 5 then
	    	if stl == 4 or stl == 6 then
	    	GradientRect(x, y - 2, w / 2, 2, gradient_color, gradient_color1, true)
	    	GradientRect(x + ( w / 2), y - 2, w / 2, 2, gradient_color1, gradient_color2, true)
	    	elseif stl == 2 then
	    	GradientRect(x, y - 2, w, 2, color.new(col:r(), col:g(), col:b(), al), color.new(col2:r(), col2:g(), col2:b(), al), true)
	    	else
	    	GradientRect(x, y - 2, w / 2, 2, gradient_color, gradient_color1, true)
	    	GradientRectSec(x + ( w / 2), y - 2, w / 2, 2, gradient_color, gradient_color1, true)
	    	end
	    end
    elseif menu.get_int( "Theme" ) == 0 or menu.get_int( "Theme" ) == 1 then
        if stl ~= 5 then
            if menu.get_int( "Theme" ) == 1 then
                render.draw_rect_filled(x, y, w, h + 4, color.new(35, 35, 35, math.floor(col:a() * al / 255)))
            else render.draw_rect_filled(x, y, w, h, color.new(20, 20, 20, math.floor(col:a() * al / 255))) end
        else
            if menu.get_int( "Theme" ) == 1 then
                render.draw_rect_filled(x, y-2, w, h + 6, color.new(30, 30, 30, math.floor(col:a() * al / 255)))
            else render.draw_rect_filled(x, y-2, w, h + 2, color.new(30, 30, 30, math.floor(col:a() * al / 255))) end
            GradientRect(x + 1, y - 1, w / 2, 1, color.new(0, 213, 255, al), color.new(204, 18, 204, al), true)
            GradientRect(x + (w / 2), y - 1, w / 2 - 1, 1, color.new(204, 18, 204, al), color.new(255, 250, 0, al), true)
        end
        
            gradient_color = stl == 0 and color.new(col:r(), col:g(), col:b(), al) or stl == 1 and color.new(0, 0, 0, math.floor(col:a() * al / 255)) or stl == 3 and color.new(col:r(), col:g(), col:b(), al) or stl == 4 and color.new(0, 213, 255, al) or stl == 6 and color.new(chromd==1 and rgb:g() or rgb:r(), chromd==1 and rgb:b() or rgb:g(), chromd ==1 and rgb:g() or rgb:b(), al) or color.new(0, 0, 0, 0)
            gradient_color1 = stl == 0 and color.new(col:r(), col:g(), col:b(), al) or stl == 1 and color.new(col:r(), col:g(), col:b(), al) or stl == 3 and color.new(0, 0, 0, math.floor(col:a() * al / 255)) or stl == 4 and color.new(204, 18, 204, al) or stl == 6 and color.new(chromd==2 and rgb:r() or rgb:b(), chromd==2 and rgb:g() or rgb:r(), chromd==2 and rgb:b() or rgb:g(), al) or color.new(0, 0, 0, 0)
            gradient_color2 = stl == 0 and color.new(col:r(), col:g(), col:b(), al) or stl == 1 and color.new(0, 0, 0, math.floor(col:a() * al / 255)) or stl == 3 and color.new(col:r(), col:g(), col:b(), al) or stl == 4 and color.new(255, 250, 0, al) or stl == 6 and color.new(chromd==0 and rgb:g() or rgb:r(), chromd==0 and rgb:b() or rgb:g(), chromd ==0 and rgb:g() or rgb:b(), al) or color.new(0, 0, 0, 0)
    
            local t = 2
            if menu.get_int( "Theme" ) == 1 then
                --gradient_color = color.new(30, 30, 30, 0)
                --gradient_color1 = color.new(30, 30, 30, 0)
                --gradient_color2 = color.new(30, 30, 30, 0)
                --t = t + 2
            end
            if stl ~= 5 then
                if menu.get_int( "Theme" ) == 1 then
                    if stl == 4 or stl == 6 then
                    GradientRect(x, y, w / 2, t, gradient_color, gradient_color1, true)
                    GradientRect(x + ( w / 2), y, w / 2, t, gradient_color1, gradient_color2, true)
                    --elseif stl == 2 then
                    --GradientRect(x, y + h, w, t, color.new(col:r(), col:g(), col:b(), al), color.new(col2:r(), col2:g(), col2:b(), al), true)
                    --else
                    --GradientRect(x, y + h, w / 2, t, gradient_color, gradient_color1, true)
                    --GradientRectSec(x + ( w / 2), y + h, w / 2, t, gradient_color, gradient_color1, true)
                    end
                elseif menu.get_int( "Theme" ) == 0 then
                    if stl == 4 or stl == 6 then
                        GradientRect(x, y + h, w / 2, t, gradient_color, gradient_color1, true)
                        GradientRect(x + ( w / 2), y + h, w / 2, t, gradient_color1, gradient_color2, true)
                    elseif stl == 2 then
                        GradientRect(x, y + h, w, t, color.new(col:r(), col:g(), col:b(), al), color.new(col2:r(), col2:g(), col2:b(), al), true)
                    else
                        GradientRect(x, y + h, w / 2, t, gradient_color, gradient_color1, true)
                        GradientRectSec(x + ( w / 2), y + h, w / 2, t, gradient_color, gradient_color1, true)
                    end
                end
            end
        elseif menu.get_int( "Theme" ) == 3 or menu.get_int( "Theme" ) == 4 then
            if menu.get_int( "Theme" ) == 3 then x = x - 2; w = w + 1 end
            if stl ~= 5 then
                render.draw_rect_filled(x, y, w, h, color.new(20, 20, 20, math.floor(col:a() * al / 255)))
            else
                render.draw_rect_filled(x, y-2, w, h + 2, color.new(30, 30, 30, math.floor(col:a() * al / 255)))
                GradientRect(x + 1, y - 1, w / 2, 1, color.new(0, 213, 255, al), color.new(204, 18, 204, al), true)
                GradientRect(x + (w / 2), y - 1, w / 2 - 1, 1, color.new(204, 18, 204, al), color.new(255, 250, 0, al), true)
            end
            
                gradient_color = stl == 0 and color.new(col:r(), col:g(), col:b(), al) or stl == 1 and color.new(0, 0, 0, math.floor(col:a() * al / 255)) or stl == 3 and color.new(col:r(), col:g(), col:b(), al) or stl == 4 and color.new(0, 213, 255, al) or stl == 6 and color.new(chromd==1 and rgb:g() or rgb:r(), chromd==1 and rgb:b() or rgb:g(), chromd ==1 and rgb:g() or rgb:b(), al) or color.new(0, 0, 0, 0)
                gradient_color1 = stl == 0 and color.new(col:r(), col:g(), col:b(), al) or stl == 1 and color.new(col:r(), col:g(), col:b(), al) or stl == 3 and color.new(0, 0, 0, math.floor(col:a() * al / 255)) or stl == 4 and color.new(204, 18, 204, al) or stl == 6 and color.new(chromd==2 and rgb:r() or rgb:b(), chromd==2 and rgb:g() or rgb:r(), chromd==2 and rgb:b() or rgb:g(), al) or color.new(0, 0, 0, 0)
                gradient_color2 = stl == 0 and color.new(col:r(), col:g(), col:b(), al) or stl == 1 and color.new(0, 0, 0, math.floor(col:a() * al / 255)) or stl == 3 and color.new(col:r(), col:g(), col:b(), al) or stl == 4 and color.new(255, 250, 0, al) or stl == 6 and color.new(chromd==0 and rgb:g() or rgb:r(), chromd==0 and rgb:b() or rgb:g(), chromd ==0 and rgb:g() or rgb:b(), al) or color.new(0, 0, 0, 0)
        
                if stl ~= 5 then
                    if stl == 4 or stl == 6 then
                    GradientRect(x, y, 3, h / 2, gradient_color, gradient_color1, false)
                    GradientRect(x, y + (h / 2), 3, h / 2, gradient_color1, gradient_color2, false)
                    elseif stl == 2 then
                    GradientRect(x, y, 3, h, color.new(col:r(), col:g(), col:b(), al), color.new(col2:r(), col2:g(), col2:b(), al), false)
                    else
                    GradientRect(x, y, 3, h / 2, gradient_color, gradient_color1, false)
                    GradientRectSec(x, y + (h / 2), 3, h / 2, gradient_color, gradient_color1, false)
                    end
                end
            elseif menu.get_int( "Theme" ) == 5 or menu.get_int( "Theme" ) == 6 then
                if stl ~= 5 then
                    render.draw_rect_filled(x, y, w, h, color.new(15, 15, 15, math.floor(col:a() * al / 255)))
                else
                    render.draw_rect_filled(x, y-2, w, h + 2, color.new(30, 30, 30, math.floor(col:a() * al / 255)))
                    GradientRect(x + 1, y - 1, w / 2, 1, color.new(0, 213, 255, al), color.new(204, 18, 204, al), true)
                    GradientRect(x + (w / 2), y - 1, w / 2 - 1, 1, color.new(204, 18, 204, al), color.new(255, 250, 0, al), true)
                end
            
                gradient_color = stl == 0 and color.new(col:r(), col:g(), col:b(), al) or stl == 1 and color.new(0, 0, 0, math.floor(col:a() * al / 255)) or stl == 3 and color.new(col:r(), col:g(), col:b(), al) or stl == 4 and color.new(0, 213, 255, al) or stl == 6 and color.new(chromd==1 and rgb:g() or rgb:r(), chromd==1 and rgb:b() or rgb:g(), chromd ==1 and rgb:g() or rgb:b(), al) or color.new(0, 0, 0, 0)
                gradient_color1 = stl == 0 and color.new(col:r(), col:g(), col:b(), al) or stl == 1 and color.new(col:r(), col:g(), col:b(), al) or stl == 3 and color.new(0, 0, 0, math.floor(col:a() * al / 255)) or stl == 4 and color.new(204, 18, 204, al) or stl == 6 and color.new(chromd==2 and rgb:r() or rgb:b(), chromd==2 and rgb:g() or rgb:r(), chromd==2 and rgb:b() or rgb:g(), al) or color.new(0, 0, 0, 0)
                gradient_color2 = stl == 0 and color.new(col:r(), col:g(), col:b(), al) or stl == 1 and color.new(0, 0, 0, math.floor(col:a() * al / 255)) or stl == 3 and color.new(col:r(), col:g(), col:b(), al) or stl == 4 and color.new(255, 250, 0, al) or stl == 6 and color.new(chromd==0 and rgb:g() or rgb:r(), chromd==0 and rgb:b() or rgb:g(), chromd ==0 and rgb:g() or rgb:b(), al) or color.new(0, 0, 0, 0)
        
                --render.draw_rect_filled( x-1, y-1, w+2, 1, color.new(100, 130, 255) )
                --render.draw_rect_filled( x, y-2, w, 2, color.new(100, 130, 255) )
                --GradientRect(x-2, y, 2, h, color.new(100, 130, 255, 100), color.new(0, 0, 0, 0), false)
                --GradientRect(x+w, y, 2, h, color.new(100, 130, 255, 100), color.new(0, 0, 0, 0), false)

                if stl ~= 5 then
                    if stl == 4 or stl == 6 then
                    --GradientRect(x-1, y - 1, w / 2 + 1, 1, gradient_color, gradient_color1, true)
                    --GradientRectSec(x + ( w / 2), y - 1, w / 2 + 1, 1, gradient_color, gradient_color1, true)
                    if menu.get_int( "Theme" ) == 6 then
                        local kol = color.new(gradient_color:r(), gradient_color:g(), gradient_color:b(), math.floor(col:a() * al / 255 / 6))
                        GradientRect(x, y, w, h, kol, color.new(0, 0, 0, 0), false)
                    end
                    render.draw_rect_filled( x-1, y-1, 2, 2, gradient_color )
                    render.draw_rect_filled( x+w-1, y-1, 2, 2, gradient_color2 )
                    GradientRect(x-2, y, 2, h, gradient_color, color.new(0, 0, 0, 0), false)
                    GradientRect(x+w, y, 2, h, gradient_color2, color.new(0, 0, 0, 0), false)
                    GradientRect(x, y - 2, w / 2, 2, gradient_color, gradient_color1, true)
                    GradientRect(x + ( w / 2), y - 2, w / 2, 2, gradient_color1, gradient_color2, true)
                    elseif stl == 2 then
                    --GradientRect(x-1, y - 1, w / 2 + 1, 1, gradient_color, gradient_color1, true)
                    --GradientRectSec(x + ( w / 2), y - 1, w / 2 + 1, 1, gradient_color, gradient_color1, true)
                    if menu.get_int( "Theme" ) == 6 then
                        local kol = color.new(gradient_color:r(), gradient_color:g(), gradient_color:b(), math.floor(col:a() * al / 255 / 6))
                        GradientRect(x, y, w, h, kol, color.new(0, 0, 0, 0), false)
                    end
                    render.draw_rect_filled( x-1, y-1, 2, 2, gradient_color )
                    render.draw_rect_filled( x+w-1, y-1, 2, 2, gradient_color1 )
                    GradientRect(x-2, y, 2, h, color.new(col:r(), col:g(), col:b(), al), color.new(0, 0, 0, 0), false)
                    GradientRect(x+w, y, 2, h, color.new(col2:r(), col2:g(), col2:b(), al), color.new(0, 0, 0, 0), false)
                    GradientRect(x, y - 2, w, 2, color.new(col:r(), col:g(), col:b(), al), color.new(col2:r(), col2:g(), col2:b(), al), true)
                    else
                    --GradientRect(x-1, y - 1, w / 2 + 1, 1, gradient_color, gradient_color1, true)
                    --GradientRectSec(x + ( w / 2), y - 1, w / 2 + 1, 1, gradient_color, gradient_color1, true)
                    --render.draw_rect_filled(x, y, w, h, color.new(15, 15, 15, math.floor(col:a() * al / 255)))
                    if menu.get_int( "Theme" ) == 6 then
                        local kol = color.new(gradient_color:r(), gradient_color:g(), gradient_color:b(), math.floor(col:a() * al / 255 / 6))
                        GradientRect(x, y, w, h, kol, color.new(0, 0, 0, 0), false)
                    end
                    render.draw_rect_filled( x-1, y-1, 2, 2, gradient_color )
                    render.draw_rect_filled( x+w-1, y-1, 2, 2, gradient_color )
                    GradientRect(x-2, y, 2, h, gradient_color, color.new(0, 0, 0, 0), false)
                    GradientRect(x+w, y, 2, h, gradient_color, color.new(0, 0, 0, 0), false)
                    GradientRect(x, y - 2, w / 2, 2, gradient_color, gradient_color1, true)
                    GradientRectSec(x + ( w / 2), y - 2, w / 2, 2, gradient_color, gradient_color1, true)
                    end
                end
            end
end

--indicators

local function booltoint(value)
	if value then
		return 1
	else return 0
	end
end

local item = { 0, 0, 0 }
local animwidth = 0;
local alpha = { 0 }
local types = {"always", "holding", "toggled"}

local get_state, get_mode = menu.get_key_bind_state, menu.get_key_bind_mode
screen_x, screen_y = screensizex, screensizey
count = 0
alpha = 0
width = 25
width1 = 25
maxwidth = 25
local active_index = {}
local active_name = {}
local bindalpha = {}
local animspacing = {}
for i=1,15 do
	bindalpha[i] = 0
	animspacing[i] = 10
end
spacing = 15
kbbg_height = 19
fontproc1 = 0
totalspacing = 0
animcount = 0

local function add_bind(name, bind_name, x, y, i)

    --if i == 1 and menu.get_bool( "Ideal Tick on Autopeek" ) and menu.get_key_bind_state( "misc.automatic_peek_key" ) then return end
    if i == 6 and invertspam == true then return end

    if menu.get_int( "Theme" ) == 0 or menu.get_int( "Theme" ) == 1 then
        fontproc1 = 0
    else fontproc1 = 1 end

    --if menu.get_bool( "Animated keybinds" ) then
    --    if animcount < count - 1 then
    --        animcount = animcount + 0.1
    --    end
    --else animcount = count - 1 end
    --totalspacing = 15 * (animcount)
    --totalspacing = 15 * (count - 1)
    
	if get_state(bind_name) then
        --if i == 1 and menu.get_bool( "Ideal Tick on Autopeek" ) and menu.get_key_bind_state( "misc.automatic_peek_key" ) then return end
        if i == 8 and menu.get_bool( "Ideal Tick on Autopeek" ) and menu.get_key_bind_state( "rage.double_tap_key" ) then return end
        if menu.get_bool( "Auto resize" ) then
		    if active_index[i] ~= bind_name then
		    	active_index[i] = bind_name
		    	active_name[i] = name
		    end
        end
		if menu.get_bool("Animated keybinds") then
			animspacing[i] = math.lerp(animspacing[i], 15, globals.get_frametime() * 10)
			if math.floor(animspacing[i]) == 14 then animspacing[i] = 15 end
            if count == 0 then
                bindalpha[i] = math.lerp(bindalpha[i], 255, globals.get_frametime() * 4)
            else
			    bindalpha[i] = math.lerp(bindalpha[i], 255, globals.get_frametime() * 8)
            end
			if math.floor(bindalpha[i]) == 254 then bindalpha[i] = 255 end
		else animspacing[i] = 15
			bindalpha[i] = 255
		end
    else
        if menu.get_bool( "Auto resize" ) then
            active_index[i] = 0
		    active_name[i] = 0
        end
        if menu.get_bool("Animated keybinds") then
            animspacing[i] = math.floor(math.lerp(animspacing[i], 0, globals.get_frametime() * 10))
			bindalpha[i] = math.floor(math.lerp(bindalpha[i], 0, globals.get_frametime() * 8))
        else
		    bindalpha[i] = 0
		    animspacing[i] = 0
        end
	end
    if bindalpha[i] > 0 then
        if i == 1 and menu.get_bool( "Ideal Tick on Autopeek" ) and menu.get_key_bind_state( "misc.automatic_peek_key" ) then
            name = "Ideal tick"
        end
        --if i == 8 and menu.get_bool( "Ideal Tick on Autopeek" ) then
        --    name = "Ideal tick"
        --end
        if i == 11 then
            mode = "Back"
        elseif i == 12 then
            mode = "Forward"
        elseif i == 13 then
            mode = "Left"
        elseif i == 14 then
            mode = "Right"
        elseif i == 15 then
            if menu.get_key_bind_state("anti_aim.manual_back_key") or menu.get_key_bind_state("anti_aim.manual_left_key") or menu.get_key_bind_state("anti_aim.manual_right_key") or menu.get_key_bind_state("anti_aim.manual_forward_key") then return end
            mode = "Edge"
        else mode = types[get_mode(bind_name) + 1] end
        if menu.get_int( "Theme" ) ~= 1 then mode = "["..mode.."]" end
		if menu.get_bool("Text shadow") then
			render.draw_text(verdana, x + 1, y + 23 - 15 + totalspacing, color.new(0, 0, 0, math.floor(bindalpha[i])), name)   
			render.draw_text(verdana, x, y + 22 - 15 + totalspacing, color.new(255, 255, 255, math.floor(bindalpha[i])), name)   
			text_width = render.get_text_width(verdana, mode)
			
			render.draw_text(verdana, x + width + fontproc1 + 1 - text_width - 6, y + 23 - 15 + totalspacing, color.new(0, 0, 0, math.floor(bindalpha[i])), mode)  
			render.draw_text(verdana, x + width + fontproc1 - text_width - 6, y + 22 - 15 + totalspacing, color.new(255, 255, 255, math.floor(bindalpha[i])), mode)     
		else
			render.draw_text(verdana, x, y + 22 - 15 + totalspacing, color.new(255, 255, 255, math.floor(bindalpha[i])), name)     
			text_width = render.get_text_width(verdana, mode)
			
			render.draw_text(verdana, x + width + fontproc1 - text_width - 6, y + 22 - 15 + totalspacing, color.new(255, 255, 255, math.floor(bindalpha[i])), mode)     	 
		end
        totalspacing = totalspacing + animspacing[i]
        kbbg_height = totalspacing - 8
		count = count + 1
	end
end

local function resize()
    if not script_loaded then return end
	if menu.get_bool("Auto resize") then
		width = 70 + maxwidth
		for i=1,14 do
            if i == 6 and invertspam == true then maxwidth = render.get_text_width( verdana, "Invert desync" ) return end
			if active_index[i] ~= 0 then
				if render.get_text_width( verdana, tostring(active_name[i]) ) > maxwidth then
					maxwidth = render.get_text_width( verdana, tostring(active_name[i]) )
					active_index[0]=active_index[i]
				end
			end
			if active_index[0] ~= nil then
				if not menu.get_key_bind_state( active_index[0] ) and maxwidth ~= 25 then
					maxwidth = 25
				end
			end
		end
		if animwidth == 0 then animwidth = width end;
		if menu.get_bool("Animated keybinds") then
 			animwidth = math.lerp(animwidth, width, globals.get_frametime() * 8)
			floor = math.floor(animwidth)
			width = floor
		end
	else width = 150 end
end

local unlocked = 0
local move_x = 0
local move_y = 0
local pos_received = 0
io.input("C:/iugenScript/keybind_pos.txt")
pos_x, pos_y = io.read("*number", "*number")
--local pos_x = 345
--local pos_y = 425

local function drag()
    cursor_x = GetCursorPos().x
    cursor_y = GetCursorPos().y
    if ffi.C.GetAsyncKeyState(1) ~= 0 then
        if pos_x < cursor_x and cursor_x < pos_x + width and pos_y < cursor_y - 2 and cursor_y < pos_y + 19 and pos_received == 0 then
            unlocked = 1
            move_x = pos_x - cursor_x
            move_y = pos_y - cursor_y
            pos_received = 1
        end
    else pos_received = 0
        unlocked = 0
    end
    if unlocked == 1 then
        pos_x = cursor_x + move_x
        pos_y = cursor_y + move_y
    end
    if KeyRelease(1) then
        file.write( "C:/iugenScript/keybind_pos.txt", tostring(pos_x).." "..tostring(pos_y) )
    end
end

--client.add_callback( "on_paint", resize )

--get fakelag choke

ffi.cdef[[
    typedef struct
    {
        float x;
        float y;
        float z;
    } Vector_t;

    typedef struct
    {
        float m_ClockOffsets[ 16 ];
        int m_iCurClockOffset;
	    int m_nServerTick;
	    int	m_nClientTick;
    } CClockDriftMgr;

    typedef struct
    {
        char pad_0000 [ 156 ];
	    void* m_NetChannel;
	    int m_nChallengeNr;
	    char pad_00A4 [ 100 ];
	    int m_nSignonState;
	    int signon_pads [ 2 ];
	    float m_flNextCmdTime;
	    int m_nServerCount;
	    int m_nCurrentSequence;
	    int musor_pads [ 2 ];
	    CClockDriftMgr m_ClockDriftMgr;
	    int m_nDeltaTick;
	    bool m_bPaused;
	    char paused_align [ 3 ];
	    int m_nViewEntity;
	    int m_nPlayerSlot;
	    int bruh;
	    char m_szLevelName [ 260 ];
	    char m_szLevelNameShort [ 80 ];
	    char m_szGroupName [ 80 ];
	    char pad_032 [ 92 ];
	    int m_nMaxClients;
	    char pad_0314 [ 18828 ];
	    float m_iLastServerTickTime;
	    bool m_bInSimulation;
	    char pad_4C9D [ 3 ];
	    int oldtickcount;
	    float m_tickRemainder;
	    float m_frameTime;
	    int lastoutgoingcommand;
	    int chokedcommands;
	    int last_command_ack;
	    int last_server_tick;
	    int command_ack;
	    int m_nSoundSequence;
	    char pad_4CCD [ 76 ];
	    Vector_t viewangles;
	    int pads [ 54 ];
	    void* events;
    } CClientState;
]]

local Client_t = {}
Client_t.address = utils.find_signature( "engine.dll" , "A1 ? ? ? ? 33 D2 6A 00 6A 00 33 C9 89 B0" ) + 1
Client_t.GetChokedCommands = function()
    return ffi.cast("CClientState***", Client_t.address)[0][0][0].chokedcommands
end

--max fakelag
--[[local fakelag = 0
local send_packet = false

local function getmaxfakelag()

    --if send_packet == true then
        --client.log("proc")
    --end

    if (menu.get_int("anti_aim.fake_lag_limit") <= Client_t.GetChokedCommands()) then
        send_packet = false
    else
        send_packet = true
    end

    if send_packet then
        return 0
    else
        return Client_t.GetChokedCommands()
    end
    
end
maxfakelag = 0
client.add_callback( "on_paint", function()

    if not script_loaded then return end

    if (menu.get_int("anti_aim.fake_lag_limit") <= Client_t.GetChokedCommands()) then
        send_packet = false
    else
        send_packet = true
    end

    local maxfakelag = getmaxfakelag()
    if maxfakelag == 1 then maxfakelag = 0 end

    render.draw_rect_filled( 100, 100, 160, 10, color.new(20, 20, 20, 100) )
    render.draw_rect_filled( 100, 100, maxfakelag * 10, 10, color.new(100, 100, 255) )
end )
]]

local function watermark()
    if not script_loaded then return end
        --Watermark
        if menu.get_int( "Watermark style" ) == 1 then
            if menu.get_int( "Theme" ) ~= 1 then
                local hour = os.date("%H", os.time())
                local minute = os.date("%M", os.time())
                local time = hour..":"..minute
                local latency = globals.get_ping()
                local ping = latency .. "ms"
                local text_size_a = render.get_text_width(productsans, username)
                local text_size_b = render.get_text_width(productsans, time)
                local text_size_c = render.get_text_width(productsans, ping)
                local x = screensizex - 55
                local y = 18
                bg_col = color.new(20, 20, 20, 255)
                --end
                local border = menu.get_color("Accent color")
                local col2 = menu.get_color("Secondary color")

                if engine.is_in_game() then
                
                    render.draw_rect_filled(x, y + 36, 40, 4, color.new(border:r(), border:g(), border:b(), 255) )
                    render.draw_rect_filled(x, y, 40, 36, color.new(20, 20, 20, border:a()) )
                    render.draw_text_centered( logo, x + 20, y + 18, color.new(255, 255, 255, 255), true, true, "a" )
                
                    render.draw_rect_filled( x - text_size_c - 32, y + 36, text_size_c + 26, 4, color.new(border:r(), border:g(), border:b(), 255) )
                    render.draw_rect_filled( x - text_size_c - 32, y, text_size_c + 26, 36, color.new(20, 20, 20, border:a()) )
                    render.draw_text( productsans, x - text_size_c - 19, y + 9, color.new(255, 255, 255, 255), ping )
                
                    local m = x - text_size_c - 32
                    render.draw_rect_filled( m - text_size_b - 32, y + 36, text_size_b + 26, 4, color.new(border:r(), border:g(), border:b(), 255) )
                    render.draw_rect_filled( m - text_size_b - 32, y, text_size_b + 26, 36, color.new(20, 20, 20, border:a()) )
                    render.draw_text( productsans, m - text_size_b - 19, y + 9, color.new(255, 255, 255, 255), time )

                    local n = m - text_size_b - 32
                    render.draw_rect_filled( n - text_size_a - 32, y + 36, text_size_a + 26, 4, color.new(border:r(), border:g(), border:b(), 255) )
                    render.draw_rect_filled( n - text_size_a - 32, y, text_size_a + 26, 36, color.new(20, 20, 20, border:a()) )
                    render.draw_text( productsans, n - text_size_a - 19, y + 9, color.new(255, 255, 255, 255), username )

                else
                    x = screensizex - 55
                    local procx = x + 40 - render.get_text_width( fontitalic, "iugen" ) - render.get_text_width( fontbolditalic, "Script" ) - 16 - text_size_b - 32
                    local procsize = render.get_text_width( fontitalic, "iugen" ) + render.get_text_width( fontbolditalic, "Script" ) + 16
                    render.draw_rect_filled(procx, y + 36, procsize, 4, color.new(border:r(), border:g(), border:b(), 255) )
                    render.draw_rect_filled(procx, y, procsize, 36, color.new(20, 20, 20, border:a()) )
                    render.draw_text_centered(fontitalic, x - render.get_text_width( fontitalic, "iugen" ) - 20 - text_size_b - 32, y + 20, color.new(255, 255, 255, 255), false, true, "iugen" )
                    local fontkolor = menu.get_color("Script color")
                    render.draw_text_centered(fontbolditalic, x - 20 - text_size_b - 32, y + 20, fontkolor, false, true, "Script" )
                    x = screensizex - 9
                    render.draw_rect_filled( x - text_size_b - 32, y + 36, text_size_b + 26, 4, color.new(border:r(), border:g(), border:b(), 255) )
                    render.draw_rect_filled( x - text_size_b - 32, y, text_size_b + 26, 36, color.new(20, 20, 20, border:a()) )
                    render.draw_text( productsans, x - text_size_b - 19, y + 9, color.new(255, 255, 255, 255), time )

                end
            else
                local hour = os.date("%H", os.time())
                local minute = os.date("%M", os.time())
                local time = hour..":"..minute
                local latency = globals.get_ping()
                local ping = latency .. "ms"
                local text_size_a = render.get_text_width(productsans, username)
                local text_size_b = render.get_text_width(productsans, time)
                local text_size_c = render.get_text_width(productsans, ping)
                local x = screensizex - 55
                local y = 18
                bg_col = color.new(20, 20, 20, 255)
                --end
                local border = menu.get_color("Accent color")
                local col2 = menu.get_color("Secondary color")
    
                if engine.is_in_game() then
                
                    --render.draw_rect_filled(x, y + 36, 40, 4, color.new(border:r(), border:g(), border:b(), 255) )
                    render.draw_rect_filled(x, y, 40, 36, color.new(35, 35, 35, border:a()) )
                    render.draw_text_centered( logo, x + 20, y + 18, color.new(border:r(), border:g(), border:b(), 255), true, true, "a" )
                
                    --render.draw_rect_filled( x - text_size_c - 32, y + 36, text_size_c + 26, 4, color.new(border:r(), border:g(), border:b(), 255) )
                    render.draw_rect_filled( x - text_size_c - 32 - render.get_text_width( icons, "@" ) - 2, y, text_size_c + 26 + render.get_text_width( icons, "@" ), 36, color.new(35, 35, 35, border:a()) )
                    render.draw_text( productsans, x - text_size_c - 18, y + 8, color.new(255, 255, 255, 255), ping )
                    render.draw_text( icons, x - text_size_c - 25 - render.get_text_width( icons, "@" ), y + 10, color.new(border:r(), border:g(), border:b(), 255), "@")
                
                    local m = x - text_size_c - 32 - render.get_text_width( icons, "@" ) - 2
                    --render.draw_rect_filled( m - text_size_b - 32, y + 36, text_size_b + 26, 4, color.new(border:r(), border:g(), border:b(), 255) )
                    render.draw_rect_filled( m - text_size_b - 32 - render.get_text_width( icons, "A" ) - 2, y, text_size_b + 26 + render.get_text_width( icons, "A" ), 36, color.new(35, 35, 35, border:a()) )
                    render.draw_text( productsans, m - text_size_b - 18, y + 8, color.new(255, 255, 255, 255), time )
                    render.draw_text( icons, m - text_size_b - 25 - render.get_text_width( icons, "A" ), y + 10, color.new(border:r(), border:g(), border:b(), 255), "A")
    
                    local n = m - text_size_b - 32 - render.get_text_width( icons, "A" ) - 2
                    --render.draw_rect_filled( n - text_size_a - 32, y + 36, text_size_a + 26, 4, color.new(border:r(), border:g(), border:b(), 255) )
                    render.draw_rect_filled( n - text_size_a - 32 - render.get_text_width( icons, "C" ) - 2, y, text_size_a + 26 + render.get_text_width( icons, "C" ), 36, color.new(35, 35, 35, border:a()) )
                    render.draw_text( productsans, n - text_size_a - 18, y + 8, color.new(255, 255, 255, 255), username )
                    render.draw_text( icons, n - text_size_a - 25 - render.get_text_width( icons, "C" ), y + 10, color.new(border:r(), border:g(), border:b(), 255), "C")
    
                else
                    x = screensizex - 55
                    local procx = x + 40 - render.get_text_width( fontitalic, "iugen" ) - render.get_text_width( fontbolditalic, "Script" ) - 16 - text_size_b - 32
                    local procsize = render.get_text_width( fontitalic, "iugen" ) + render.get_text_width( fontbolditalic, "Script" ) + 16
                    --render.draw_rect_filled(procx, y + 36, procsize, 4, color.new(border:r(), border:g(), border:b(), 255) )
                    render.draw_rect_filled(procx, y, procsize, 36, color.new(35, 35, 35, border:a()) )
                    render.draw_text_centered(fontitalic, x - render.get_text_width( fontitalic, "iugen" ) - 20 - text_size_b - 32, y + 20, color.new(255, 255, 255, 255), false, true, "iugen" )
                    local fontkolor = menu.get_color("Script color")
                    render.draw_text_centered(fontbolditalic, x - 20 - text_size_b - 32, y + 20, fontkolor, false, true, "Script" )
                    x = screensizex - 9
                    --render.draw_rect_filled( x - text_size_b - 32, y + 36, text_size_b + 26, 4, color.new(border:r(), border:g(), border:b(), 255) )
                    render.draw_rect_filled( x - text_size_b - 32, y, text_size_b + 26, 36, color.new(35, 35, 35, border:a()) )
                    render.draw_text( productsans, x - text_size_b - 19, y + 8, color.new(255, 255, 255, 255), time )
                    
                end
            end
        elseif menu.get_int( "Watermark style" ) == 2 or menu.get_int( "Watermark style" ) == 3 then
            if menu.get_int( "Theme" ) == 5 or menu.get_int( "Theme" ) == 6 then
                local wtname = "iugenScript"
			    local username = globals.get_username()
			    local ping = globals.get_ping()
			    local tickcount = 1 / globals.get_intervalpertick()
			    local text = ""
                if engine.is_connected() then
                    text = "   " .. username .. "   delay: " .. ping .. "ms   " .. tickcount .. "tick   " .. os.date("%X") else 
                    text = "   " .. username .. "   " .. os.date("%X") end
			    local screenx = screensizex
			    local screeny = screensizey
                local iugenscriptlength = render.get_text_width( verdana, "iugenScript" )
                local iugenlength = render.get_text_width( verdana, "iugen" )
                local scriptlength = render.get_text_width( verdana, "Script" )
			    local w = iugenscriptlength + render.get_text_width( verdana, text ) + 10
			    local h = 19
			    local x = screenx - w - 10
                if menu.get_int( "Theme" ) ~= 4 then
			        filledbox(x, 8, w, h, 255)
                else filledbox(x - 3, 8, w + 3, h, 255) end
                local color = color.new(255, 255, 255, 255)
                local color = menu.get_color( "Accent color" )
                local color = color.new(color:r(), color:g(), color:b())
			    if menu.get_bool("Text shadow") then
                    render.draw_text( verdana, x + 6, 12, color.new(0, 0, 0, 255), "iugen" )
                    render.draw_text( verdana, x + iugenlength + 6, 12, color.new(0, 0, 0, 255), "Script" )
                    render.draw_text( verdana, x + iugenscriptlength + 6, 12, color.new(0, 0, 0, 255), text )
                    render.draw_text( verdana, x + 5, 11, color.new(255, 255, 255, 255), "iugen" )
			    	render.draw_text( verdana, x + iugenlength + 5, 11, color, "Script" )
			    	render.draw_text( verdana, x + iugenscriptlength + 5, 11, color.new(255, 255, 255, 255), text )
			    else
                    render.draw_text( verdana, x + 5, 11, color.new(255, 255, 255, 255), "iugen" )
			    	render.draw_text( verdana, x + iugenlength + 5, 11, color, "Script" )
			    	render.draw_text( verdana, x + iugenscriptlength + 5, 11, color.new(255, 255, 255, 255), text )
			    end
            else
                local wtname = "iugenScript"
			    local username = globals.get_username()
			    local ping = globals.get_ping()
			    local tickcount = 1 / globals.get_intervalpertick()
			    local text = ""
			    if engine.is_connected() then
			    text = wtname .. " | " .. username .. " | delay: " .. ping .. "ms | " .. tickcount .. "tick | " .. os.date("%X") else 
			    text = wtname .. " | " .. username .. " | " .. os.date("%X") end
			    local screenx = screensizex
			    local screeny = screensizey
			    local w = render.get_text_width( verdana, text ) + 10
			    local h = 19
			    local x = screenx - w - 10
                if menu.get_int( "Theme" ) ~= 4 then
			        filledbox(x, 8, w, h, 255)
                else filledbox(x - 3, 8, w + 3, h, 255) end
			    if menu.get_bool("Text shadow") then
			    	render.draw_text( verdana, x + 6, 12, color.new(0, 0, 0, 255), text )
			    	render.draw_text( verdana, x + 5, 11, color.new(255, 255, 255, 255), text )
			    else
			    	render.draw_text( verdana, x + 5, 11, color.new(255, 255, 255, 255), text )
			    end
            end
            if menu.get_int( "Watermark style" ) == 3 then
            if engine.is_in_game() then
                local local_player = entitylist.get_local_player()
                local local_health = local_player:get_health()
                if local_health > 0 then
                local screenx = screensizex
			    local screeny = screensizey
                local h = 19
                local procpad = 0
                if menu.get_int("Theme") == 1 or menu.get_int("Theme") == 4 then
                    procpad = -10
                end
                local procpad2 = 0
                if menu.get_int("Theme") == 4 then
                    procpad2 = 2
                end
                local w = 154 + procpad
			    local x = screenx - w - 10
                filledbox(x, 34, w, h, 255)
                --local fakelagtext = ""
                if globals.get_tickcount() % 4 == 0 then
                    maxfakelag = menu.get_int("anti_aim.fake_lag_limit")
                end
                if menu.get_bool( "anti_aim.enable_fake_lag" ) then
                    if menu.get_key_bind_state( "rage.double_tap_key" ) then
                        fakelagtext = "FL | SHIFTING (1)"
                    elseif menu.get_key_bind_state( "rage.hide_shots_key" ) then
                        fakelagtext = "FL | SHIFTING (6)"
                    else
                        fakelagtext = "FL | CHOKING ("..tostring(maxfakelag)..")"
                    end
                else
                    if menu.get_key_bind_state( "rage.hide_shots_key" ) then
                        fakelagtext = "FL | SHIFTING (0)"
                    elseif menu.get_key_bind_state( "rage.double_tap_key" ) then
                        fakelagtext = "FL | SHIFTING (0)"
                    else
                        fakelagtext = "FL | OFF"
                    end
                end
                if menu.get_key_bind_state( "anti_aim.fake_duck_key" ) then
                    fakelagtext = "FL | CHOKING (14)"
                end
                delay = delay + 1
                if delay == 32 then
                    last_choke[4] = last_choke[3]
                    last_choke[3] = last_choke[2]
                    last_choke[2] = last_choke[1]
                    last_choke[1] = last_choke[0]
                    last_choke[0] = menu.get_int("anti_aim.fake_lag_limit")
                    if menu.get_bool("anti_aim.enable_fake_lag") == false then
                      last_choke[0] = 0
                    end
                    if menu.get_key_bind_state("rage.double_tap_key") then
                      last_choke[0] = 0
                    end
                    if menu.get_key_bind_state("rage.hide_shots_key") then
                      if last_choke[0] > 6 then
                        last_choke[0] = 6
                      end
                    end
                    if menu.get_key_bind_state("anti_aim.fake_duck_key") then
                        last_choke[0] = 14
                    end
                    delay = 0
                end
                render.draw_text_centered( verdana, x + 6 + procpad2, 37, color.new(255, 255, 255), false, false, fakelagtext )
                render.draw_line( x + 108 + procpad + 6 , 46 - math.floor(last_choke[4] * 0.5), x + 108 + procpad + 14, 46 - math.floor(last_choke[3] * 0.5), color.new(255, 255, 255) )
                render.draw_line( x + 108 + procpad + 14, 46 - math.floor(last_choke[3] * 0.5), x + 108 + procpad + 22, 46 - math.floor(last_choke[2] * 0.5), color.new(255, 255, 255) )
                render.draw_line( x + 108 + procpad + 22, 46 - math.floor(last_choke[2] * 0.5), x + 108 + procpad + 30, 46 - math.floor(last_choke[1] * 0.5), color.new(255, 255, 255) )
                render.draw_line( x + 108 + procpad + 30, 46 - math.floor(last_choke[1] * 0.5), x + 108 + procpad + 38, 46 - math.floor(last_choke[0] * 0.5), color.new(255, 255, 255) )
                if menu.get_int( "anti_aim.desync_type" ) == 0 or not menu.get_bool( "anti_aim.enable" ) then
                    desynctext = "REAL (0°)"
                else
                    if globals.get_tickcount() % 8 == 0 then
                        if menu.get_int( "anti_aim.desync_type" ) == 2 then
                            local desync = menu.get_int( "anti_aim.desync_range" )
                            desynctext = "FAKE ("..tostring(desync).."°)"
                        else
                            if menu.get_key_bind_state( "anti_aim.invert_desync_key" ) then
                                local desync = menu.get_int( "anti_aim.desync_range_inverted" )
                                desynctext = "FAKE ("..tostring(desync).."°)"
                                --render.draw_rect_filled( holoposx + 6 + render.get_text_width( pixelbig, "AA STATUS: FAKE (-XX°)" ) + 40, holotexty, math.floor(desync / 2), 14, color )
                            else
                                local desync = menu.get_int( "anti_aim.desync_range" )
                                desynctext = "FAKE (".."-"..tostring(desync).."°)"
                                --render.draw_rect_filled( holoposx + 6 + render.get_text_width( pixelbig, "AA Status: FAKE (-XX°)" ) + 40 - math.floor(desync / 2), holotexty, math.floor(desync / 2), 14, color )
                            end
                        end
                    end
                end
                w = render.get_text_width( verdana, desynctext ) + 12
                x = x - w - 10
                filledbox(x, 34, w, h, 255)
                render.draw_text_centered( verdana, x + 6 + procpad2, 37, color.new(255, 255, 255), false, false, desynctext )
            end
            end
            end
        end
end

local menu_opened = true
local bindtextposadd = 0
local bindtextyadd = 0

local function keybinds()
    if not script_loaded then return end

        --if KeyRelease(45) or KeyRelease(46) then
        --    if menu_opened then
        --        menu_opened = false
        --    else menu_opened = true end
        --end
        menu_opened = false
    
		if not menu.get_bool("Enable keybinds list") then
			return
		end
	
		--if not engine.is_in_game() then
		--	return
		--end
		
		count = 0
        totalspacing = 15
	 
        local col = menu.get_color("Accent color")
        local stl = menu.get_int("Line style")
        if menu.get_bool( "Keybinds background" ) then
            if stl ~= 5 then
                if menu.get_int( "Theme" ) == 0 then
                    render.draw_rect_filled( pos_x, pos_y + 19, width, kbbg_height, color.new(20, 20, 20, math.floor(col:a() * alpha / 1.5 / 255)) )
                elseif menu.get_int( "Theme" ) == 1 then
                    render.draw_rect_filled( pos_x, pos_y + 23, width, kbbg_height - 1, color.new(35, 35, 35, math.floor(col:a() * alpha / 1.5 / 255)) )
                else render.draw_rect_filled( pos_x, pos_y + 19, width, kbbg_height, color.new(15, 15, 15, math.floor(col:a() * alpha / 1.5 / 255)) ) end
            else render.draw_rect_filled( pos_x, pos_y + 19, width, kbbg_height, color.new(30, 30, 30, math.floor(col:a() * alpha / 1.5 / 255)) )
            end
        end

        if engine.is_in_game() then
		    add_bind("Double tap", "rage.double_tap_key", pos_x + 3, pos_y + 1, 1)
		    add_bind("Hide shots", "rage.hide_shots_key", pos_x + 3, pos_y + 1, 2)
		    add_bind("Edge jump", "misc.edge_jump_key", pos_x + 3, pos_y + 1, 3)
		    add_bind("Slow walk", "misc.slow_walk_key", pos_x + 3, pos_y + 1, 4)
		    add_bind("Force damage", "rage.force_damage_key", pos_x + 3, pos_y + 1, 5)
		    add_bind("Invert desync", "anti_aim.invert_desync_key", pos_x + 3, pos_y + 1, 6)
		    add_bind("Fake duck", "anti_aim.fake_duck_key", pos_x + 3, pos_y + 1, 7)
		    add_bind("Automatic peek", "misc.automatic_peek_key", pos_x + 3, pos_y + 1, 8)
		    add_bind("Third person", "misc.third_person_key", pos_x + 3, pos_y + 1, 9)
            add_bind("Roll AA", "Roll Bind", pos_x + 3, pos_y + 1, 10)
            add_bind("Yaw Base", "anti_aim.manual_back_key", pos_x + 3, pos_y + 1, 11)
            add_bind("Yaw Base", "anti_aim.manual_forward_key", pos_x + 3, pos_y + 1, 12)
            add_bind("Yaw Base", "anti_aim.manual_left_key", pos_x + 3, pos_y + 1, 13)
            add_bind("Yaw Base", "anti_aim.manual_right_key", pos_x + 3, pos_y + 1, 14)
            add_bind("Yaw Base", "Freestanding Bind", pos_x + 3, pos_y + 1, 15)
        end

		if menu.get_bool("Animated keybinds") then
			if count > 0 or menu_opened then
				alpha = math.lerp(alpha, 255, globals.get_frametime() * 8)
				if math.floor(alpha) == 254 then alpha = 255 end
			else alpha = math.lerp(alpha, 0, globals.get_frametime() * 8)
			end
		else 
			if count > 0 or menu_opened then
				alpha = 255
			else alpha = 0
			end
		end

		drag()

        if menu.get_int("Theme") ~= 1 then
            bindtextposadd = width / 2
            bindtextyadd = 0
        else
            bindtextposadd = render.get_text_width( verdana, "keybinds" ) + 1
            bindtextyadd = 0
        end

		if alpha > 0 then
			filledbox(pos_x, pos_y, width, 19, math.floor(alpha))
			if menu.get_bool("Text shadow") then
				render.draw_text_centered(verdana, pos_x + bindtextposadd + 1, pos_y + bindtextyadd + 4, color.new(0, 0, 0, math.floor(alpha)), true, false, "keybinds")
				render.draw_text_centered(verdana, pos_x + bindtextposadd, pos_y + bindtextyadd + 3, color.new(255, 255, 255, math.floor(alpha)), true, false, "keybinds")
			else
				render.draw_text_centered(verdana, pos_x + bindtextposadd, pos_y + bindtextyadd + 3, color.new(255, 255, 255, math.floor(alpha)), true, false, "keybinds")
			end
            if menu.get_int("Theme") == 1 then
                render.draw_text_centered( icons_small, pos_x + 5, pos_y + 5, color.new(col:r(), col:g(), col:b(), math.floor(alpha)), false, false, "B" )
            end
		end

end

fontsspectators = render.create_font( "Verdana", 12, 0, true)
local players = {}
local screen = {
    w = screensizex,
    h = screensizey
}
spec_unlocked = 0
spec_move_x = 0
spec_move_y = 0
spec_pos_received = 0
io.input("C:/iugenScript/spectator_pos.txt")
spec_pos_x, spec_pos_y = io.read("*number", "*number")
--spec_pos_x, spec_pos_y = 100, 100
--local pos_x = 345
--local pos_y = 425

ffi.cdef[[
    typedef uintptr_t (__thiscall* GetClientEntity_4242425_t)(void*, int);
    typedef uintptr_t (__thiscall* GetClientEntityHandle_4242425_t)(void*, int);
]]

local entity_list_ptr = ffi.cast("void***", utils.create_interface("client.dll", "VClientEntityList003"))
local get_client_entity_fn = ffi.cast("GetClientEntity_4242425_t", entity_list_ptr[0][3])
local get_client_entity_by_handle_fn= ffi.cast("GetClientEntityHandle_4242425_t", entity_list_ptr[0][4])

local ffi_helpers = {
    get_entity_address = function(ent_index)
        local addr = get_client_entity_fn(entity_list_ptr, ent_index)
        return addr
    end,

    get_entity_address_by_handle = function(ent_handle)
        local addr = get_client_entity_by_handle_fn(entity_list_ptr, ent_handle)
        return addr
    end
}

local function specdrag()
    fontsspectators = verdana
    cursor_x = GetCursorPos().x
    cursor_y = GetCursorPos().y
    if ffi.C.GetAsyncKeyState(1) ~= 0 then
        if spec_pos_x < cursor_x and cursor_x < spec_pos_x + specwidth and spec_pos_y < cursor_y - 2 and cursor_y < spec_pos_y + 19 and spec_pos_received == 0 then
            spec_unlocked = 1
            spec_move_x = spec_pos_x - cursor_x
            spec_move_y = spec_pos_y - cursor_y
            spec_pos_received = 1
        end
    else spec_pos_received = 0
        spec_unlocked = 0
    end
    if spec_unlocked == 1 then
        spec_pos_x = cursor_x + spec_move_x
        spec_pos_y = cursor_y + spec_move_y
    end
    if KeyRelease(1) then
        file.write( "C:/iugenScript/spectator_pos.txt", tostring(spec_pos_x).." "..tostring(spec_pos_y) )
    end
end
local function get_spectating_players()
    if not menu.get_bool("Enable spectators list") then return end
    players = {}
    players.name = ""
    local localplayer = entitylist.get_local_player()

    for i = 1, globals.get_maxclients(), 1 do
        local ent = entitylist.get_player_by_index(i)
        local toplayer = entitylist.entity_to_player(ent)
        if not ent or toplayer:get_health() > 0 or toplayer:get_dormant() then goto continue end
        local spectating = ent:get_prop_int("CBasePlayer", "m_hObserverTarget")
        local lc_spectating = localplayer:get_prop_int("CBasePlayer", "m_hObserverTarget")
        if ffi_helpers.get_entity_address_by_handle(spectating) == ffi_helpers.get_entity_address(localplayer:get_index()) or ffi_helpers.get_entity_address_by_handle(spectating) == ffi_helpers.get_entity_address_by_handle(lc_spectating) then
            table.insert(players, {name = engine.get_player_info(i).name})
        end
        ::continue::
    end
end
function paintspec()
    local localplayer = entitylist.get_local_player()
    if not localplayer or not menu.get_bool("Enable spectators list") then return end
    local spacing = 0
    local watermark_space = 0
    local screen = {
        w = screensizex,
        h = screensizey
    }
    local specx = spec_pos_x
    local specy = spec_pos_y
    --watermark_space = 270
    specwidth = 150
    if menu.get_int("Theme") ~= 1 then
        spectextposadd = specwidth / 2
        spectextyadd = 0
    else
        spectextposadd = render.get_text_width( fontsspectators, "spectators" ) - 3
        spectextyadd = -1
    end
    local stl = menu.get_int("Line style")
    local col = menu.get_color("Accent color")
    if #players > 0 and localplayer ~= nil and menu.get_bool("Enable spectators list") then
        --client.log(tostring(players))
        if menu.get_bool( "Spectators background" ) then
            if stl ~= 5 then
                if menu.get_int( "Theme" ) == 0 then
                    render.draw_rect_filled( specx, specy + 19, specwidth, 4, color.new(20, 20, 20, math.floor(col:a() * 255 / 1.5 / 255)) )
                elseif menu.get_int( "Theme" ) == 1 then
                    render.draw_rect_filled( specx, specy + 23, specwidth, 3, color.new(35, 35, 35, math.floor(col:a() * 255 / 1.5 / 255)) )
                else render.draw_rect_filled( specx, specy + 19, specwidth, 4, color.new(15, 15, 15, math.floor(col:a() * 255 / 1.5 / 255)) ) end
            else render.draw_rect_filled( specx, specy + 19, specwidth, 4, color.new(30, 30, 30, math.floor(col:a() * 255 / 1.5 / 255)) )
            end
        end
        filledbox(specx, specy, specwidth, 19, 255)
        if menu.get_bool("Text shadow") then
            render.draw_text_centered(fontsspectators, specx + spectextposadd + 1, specy + spectextyadd + 4, color.new(0, 0, 0, 255), true, false, "spectators")
            render.draw_text_centered(fontsspectators, specx + spectextposadd, specy + spectextyadd + 3, color.new(255, 255, 255, 255), true, false, "spectators")
        else
            render.draw_text_centered(fontsspectators, specx + spectextposadd, specy + spectextyadd + 3, color.new(255, 255, 255, 255), true, false, "spectators")
        end
        if menu.get_int("Theme") == 1 then
            render.draw_text_centered( icons_small, specx + 5, specy + 5, color.new(col:r(), col:g(), col:b(), 255), false, false, "G" )
        end
        for i = 1, #players, 1 do
            if menu.get_bool( "Spectators background" ) then
                if stl ~= 5 then
                    if menu.get_int( "Theme" ) == 0 then
                        render.draw_rect_filled( specx, specy + 23 + spacing, specwidth, 15, color.new(20, 20, 20, math.floor(col:a() * 255 / 1.5 / 255)) )
                    elseif menu.get_int( "Theme" ) == 1 then
                        render.draw_rect_filled( specx, specy + 26 + spacing, specwidth, 15, color.new(35, 35, 35, math.floor(col:a() * 255 / 1.5 / 255)) )
                    else render.draw_rect_filled( specx, specy + 23 + spacing, specwidth, 15, color.new(15, 15, 15, math.floor(col:a() * 255 / 1.5 / 255)) ) end
                else render.draw_rect_filled( specx, specy + 23 + spacing, specwidth, 15, color.new(30, 30, 30, math.floor(col:a() * 255 / 1.5 / 255)) )
                end
            end
            if menu.get_bool("Text shadow") then
                render.draw_text(fontsspectators, specx + 4, specy + 23 + spacing, color.new(0,0,0),  players[i].name)
                render.draw_text(fontsspectators, specx + 3, specy + 22 + spacing, color.new(255,255,255),  players[i].name)
            else
                render.draw_text(fontsspectators, specx + 3, specy + 22 + spacing, color.new(255,255,255),  players[i].name)
            end

            spacing = spacing + 15
        end
        specdrag() 
    end
end

--client.add_callback( "on_paint", function()
--    get_spectating_players()
--    paintspec()
--end )









--#region requirings
--require('betterapi')
--ffi = require("ffi")
--#endregion

--#region vmt hook library
ffi.cdef[[
    int VirtualProtect(void* lpAddress, unsigned long dwSize, unsigned long flNewProtect, unsigned long* lpflOldProtect);
    void* VirtualAlloc(void* lpAddress, unsigned long dwSize, unsigned long  flAllocationType, unsigned long flProtect);
    int VirtualFree(void* lpAddress, unsigned long dwSize, unsigned long dwFreeType);
]]
local function copy(dst, src, len)
    return ffi.copy(ffi.cast('void*', dst), ffi.cast('const void*', src), len)
end
local buff = {free = {}}
local function VirtualProtect(lpAddress, dwSize, flNewProtect, lpflOldProtect)
    return ffi.C.VirtualProtect(ffi.cast('void*', lpAddress), dwSize, flNewProtect, lpflOldProtect)
end
local function VirtualAlloc(lpAddress, dwSize, flAllocationType, flProtect, blFree)
    local alloc = ffi.C.VirtualAlloc(lpAddress, dwSize, flAllocationType, flProtect)
    if blFree then
        table.insert(buff.free, alloc)
    end
    return ffi.cast('intptr_t', alloc)
end
vmt_hook = {
    __index = {
        hookMethod = function(h, cast, func, method)
            h.hook[method] = func
            jit.off(h.hook[method], true)
            h.orig[method] = h.vt[method]
            VirtualProtect(h.vt + method, 4, 0x4, h.prot)
            h.vt[method] = ffi.cast('intptr_t', ffi.cast(cast, h.hook[method]))
            VirtualProtect(h.vt + method, 4, h.prot[0], h.prot)
            return ffi.cast(cast, h.orig[method])
        end,
        unHookMethod = function(h, method)
            if not h.orig[method] then return end
            h.hook[method] = function() end
            VirtualProtect(h.vt + method, 4, 0x4, h.prot)
            local alloc_addr = VirtualAlloc(nil, 5, 0x1000, 0x40, false)
            if not alloc_addr then return end
            local trampoline_bytes = ffi.new('uint8_t[?]', 5, 0x90)
            trampoline_bytes[0] = 0xE9
            ffi.cast('int32_t*', trampoline_bytes + 1)[0] = h.orig[method] - tonumber(alloc_addr) - 5
            copy(alloc_addr, trampoline_bytes, 5)
            h.vt[method] = ffi.cast('intptr_t', alloc_addr)
            VirtualProtect(h.vt + method, 4, h.prot[0], h.prot)
            h.orig[method] = nil
        end,
        unHookAll = function(h)
            for method, _ in pairs(h.orig) do h:unHookMethod(method) end
        end
    },
    new = function(vt)
        return setmetatable({
            orig = {},
            vt = ffi.cast('intptr_t**', vt)[0],
            prot = ffi.new('unsigned long[1]'),
            hook = {}
        }, vmt_hook)
    end
}
--#endregion

--#region api extensions and variables
math.round = function(a) return math.floor(a + 0.5) end
function col(r, g, b, a)
    if a == nil then a = 255 end
    return color.new(r, g, b, a)
end
color.alpha = function(s, a)
    return col(s:r(), s:g(), s:b(), math.round(a))
end
color.alp_self = function(s, a) return s:alpha((a * s:a() / 255) * 255) end
local lerp = function(a, b, t)
    return a + (b - a) * t
end
local unloaded = false
local scoped = false
local ss = {
    x = engine.get_screen_width(),
    y = engine.get_screen_height(),
}
local anim = 0
--#endregion

--#region menu

--lol

--#endregion

--#region vmt hook
local VClient = vmt_hook.new(ffi.cast("void*", utils.create_interface("client.dll", "VClient018")))
function FrameStageNotify_hk(stage)
    pcall(function()
        if unloaded then return end
        if stage ~= 5 then return end
        if not engine.is_in_game() then return end
        local lp = entitylist.get_local_player()
        scoped = lp:is_scoped()
        if not menu.get_bool( "Enable custom scope" ) then return end
        lp:set_prop_int("CCSPlayer", "m_bIsScoped", 0)
    end)
    return FrameStageNotify_o(stage)
end
FrameStageNotify_o = VClient:hookMethod("void(__stdcall*)(int)", FrameStageNotify_hk, 37)
--#endregion

--#region draw callback
client.add_callback("on_paint", function()
    if not script_loaded then return end
    if unloaded then return end
    local lp = entitylist.get_local_player()
    if not engine.is_in_game() then return end
    if not lp then return end
    if not (lp:get_health() > 0) then return end
    local x, y = ss.x / 2 + 1, ss.y / 2 + 1
    local weapon = entitylist.get_weapon_by_player( lp )
    if not weapon then return end
    local inacc = weapon:get_inaccuracy()
    local inaccuracy = menu.get_bool( "Show inaccuracy" ) and inacc or 0
    local o = (menu.get_int("Scope offset") + inaccuracy * 80 )* anim
    local s = menu.get_int("Scope length") * anim
    local w = menu.get_int("Scope thickness") / 2
    local c0 = menu.get_color("Primary scope color"):alp_self(anim)
    local c1 = menu.get_color("Secondary scope color"):alp_self(anim)
    local active = scoped and lp:get_health() > 0
    anim = math.max(lerp(anim, active and 1 or 0, menu.get_int("Scope animation speed") * globals.get_frametime()), 0)
    if anim == 0 then return end
    if not menu.get_bool( "Enable custom scope" ) then return end
    local r = gradientRender
    local r0, g0, b0, a0 = c0:r(), c0:g(), c0:b(), c0:a()
    local r1, g1, b1, a1 = c1:r(), c1:g(), c1:b(), c1:a()

    r(x - o - s, y - w, s, w * 2, r1, g1, b1, a1, r0, g0, b0, a0, true)
    r(x + o - 1, y - w, s, w * 2, r0, g0, b0, a0, r1, g1, b1, a1, true)
    r(x - w, y + o - 1, w * 2, s, r0, g0, b0, a0, r1, g1, b1, a1, false)
    r(x - w, y - o - s, w * 2, s, r1, g1, b1, a1, r0, g0, b0, a0, false)
end)
--#endregion

--#region unload callback
client.add_callback("unload", function()
    unloaded = true
    VClient:unHookAll()
end)
--#endregion












arrows_alpha = 0
local swap = 0
local desyncrange = menu.get_int("anti_aim.desync_range")
local new_desyncrange = menu.get_int("anti_aim.desync_range")
local old_curtime = globals.get_curtime() * 100
local ticktime = 0
local dynamic_color_left = color.new(255, 255, 255, arrows_alpha)
local dynamic_color_right = color.new(255, 255, 255, arrows_alpha)

local function Arrows()
    if not script_loaded then return end
    if menu.get_int( "AA Arrows Style" ) == 0 then return end
    local accentcol = menu.get_color("Accent color")
    local not_anim = 1 - anim
    local arrow_color = color.new(accentcol:r(), accentcol:g(), accentcol:b(), math.floor(255 * not_anim))
    local color = color.new(accentcol:r(), accentcol:g(), accentcol:b(), 255)

    if globals.get_tickcount() % 4 == 0 then
        ticktime = ticktime + 1
    end

    if ticktime == 10 then
        new_desyncrange = menu.get_int("anti_aim.desync_range")
        ticktime = 0
    end

    if menu.get_int("anti_aim.desync_type") == 2 then

        if globals.get_tickcount() % 4 == 0 then
            swap = 1
        elseif globals.get_tickcount() % 4 == 2 then swap = 0 end
    end

    --local curtime = globals.get_curtime() * 100

    if menu.get_int("AA Arrows Style") == 3 then

        if desyncrange < new_desyncrange then
            desyncrange = desyncrange + 1
        elseif desyncrange > new_desyncrange then
            desyncrange = desyncrange - 1
        end

        if desyncrange > 30 then
            arrows_alpha = math.floor(not_anim * math.lerp(arrows_alpha, 255, globals.get_frametime() * 3))
        else arrows_alpha = math.floor(not_anim * math.lerp(arrows_alpha, 0, globals.get_frametime() * 3)) end

    end
        
        if engine.is_in_game() then
            local local_player = entitylist.get_local_player()
            local local_health = local_player:get_health()
            if local_health > 0 then
                if menu.get_int("AA Arrows Style") == 1 then
                    if menu.get_key_bind_state("anti_aim.manual_left_key") then
                        render.draw_text( arrowsfont, screensizex / 2 + 56, screensizey / 2 - 10, color.new(55, 55, 55, math.floor(150 * not_anim)), "R" )
                        render.draw_text( arrowsfont, screensizex / 2 - 56 - textsize, screensizey / 2 - 10, arrow_color, "Q" )
                    elseif menu.get_key_bind_state("anti_aim.manual_right_key") then
                        render.draw_text( arrowsfont, screensizex / 2 - 56 - textsize, screensizey / 2 - 10, color.new(55, 55, 55, math.floor(150 * not_anim)), "Q" )
                        render.draw_text( arrowsfont, screensizex / 2 + 56, screensizey / 2 - 10, arrow_color, "R" )
                    else
                        render.draw_text( arrowsfont, screensizex / 2 + 56, screensizey / 2 - 10, color.new(55, 55, 55, math.floor(150 * not_anim)), "R" )
                        render.draw_text( arrowsfont, screensizex / 2 - 56 - textsize, screensizey / 2 - 10, color.new(55, 55, 55, math.floor(150 * not_anim)), "Q" )
                    end
                    if menu.get_int("anti_aim.desync_type") ~= 2 then
                        if menu.get_key_bind_state("anti_aim.invert_desync_key") then
                            render.draw_rect_filled( screensizex / 2 + 53, screensizey / 2 - 10, 3, 21, arrow_color )
                            render.draw_rect_filled( screensizex / 2 - 53 - 3, screensizey / 2 - 10, 3, 21, color.new(55, 55, 55, math.floor(150 * not_anim)) )
                        else
                            render.draw_rect_filled( screensizex / 2 - 53 - 3, screensizey / 2 - 10, 3, 21, arrow_color )
                            render.draw_rect_filled( screensizex / 2 + 53, screensizey / 2 - 10, 3, 21, color.new(55, 55, 55, math.floor(150 * not_anim)) )
                        end
                    elseif menu.get_int("anti_aim.desync_type") == 2 then
                        if swap == 0 then
                            render.draw_rect_filled( screensizex / 2 + 53, screensizey / 2 - 10, 3, 21, arrow_color )
                            render.draw_rect_filled( screensizex / 2 - 53 - 3, screensizey / 2 - 10, 3, 21, color.new(55, 55, 55, math.floor(150 * not_anim)) )
                        else
                            render.draw_rect_filled( screensizex / 2 - 53 - 3, screensizey / 2 - 10, 3, 21, arrow_color )
                            render.draw_rect_filled( screensizex / 2 + 53, screensizey / 2 - 10, 3, 21, color.new(55, 55, 55, math.floor(150 * not_anim)) )
                        end
                    end
                elseif menu.get_int("AA Arrows Style") == 2 then
                    if menu.get_key_bind_state("anti_aim.manual_left_key") then
                        render.draw_text( manual_font, screensizex / 2 + 60 - 10, screensizey / 2 - 25, color.new(0, 0, 0, math.floor(100 * not_anim)), "▶" )
                        render.draw_text( manual_font, screensizex / 2 - 80 + 10, screensizey / 2 - 25, arrow_color, "◀" )
                    elseif menu.get_key_bind_state("anti_aim.manual_right_key") then
                        render.draw_text( manual_font, screensizex / 2 + 60 - 10, screensizey / 2 - 25, arrow_color, "▶" )
                        render.draw_text( manual_font, screensizex / 2 - 80 + 10, screensizey / 2 - 25, color.new(0, 0, 0, math.floor(100 * not_anim)), "◀" )
                    else
                        render.draw_text( manual_font, screensizex / 2 + 60 - 10, screensizey / 2 - 25, color.new(0, 0, 0, math.floor(100 * not_anim)), "▶" )
                        render.draw_text( manual_font, screensizex / 2 - 80 + 10, screensizey / 2 - 25, color.new(0, 0, 0, math.floor(100 * not_anim)), "◀" )
                    end
                    if menu.get_int("anti_aim.desync_type") ~= 2 then
                        if menu.get_key_bind_state("anti_aim.invert_desync_key") then
                            render.draw_text( indicator_font, screensizex / 2 + 53 - 10, screensizey / 2 - 15, arrow_color, "|" )
                            render.draw_text( indicator_font, screensizex / 2 - 65 + 10, screensizey / 2 - 15, color.new(0, 0, 0, math.floor(100 * not_anim)), "|" )
                        else
                            render.draw_text( indicator_font, screensizex / 2 - 65 + 10, screensizey / 2 - 15, arrow_color, "|" )
                            render.draw_text( indicator_font, screensizex / 2 + 53 - 10, screensizey / 2 - 15, color.new(0, 0, 0, math.floor(100 * not_anim)), "|" )
                        end
                    elseif menu.get_int("anti_aim.desync_type") == 2 then
                        if swap == 0 then
                            render.draw_text( indicator_font, screensizex / 2 + 53 - 10, screensizey / 2 - 15, arrow_color, "|" )
                            render.draw_text( indicator_font, screensizex / 2 - 65 + 10, screensizey / 2 - 15, color.new(0, 0, 0, math.floor(100 * not_anim)), "|" )
                        else
                            render.draw_text( indicator_font, screensizex / 2 - 65 + 10, screensizey / 2 - 15, arrow_color, "|" )
                            render.draw_text( indicator_font, screensizex / 2 + 53 - 10, screensizey / 2 - 15, color.new(0, 0, 0, math.floor(100 * not_anim)), "|" )
                        end
                    end
                elseif menu.get_int("AA Arrows Style") == 3 then
                    inactive_rgb = math.floor((color:r() + color:g() + color:b()) / 4)
                    inactive_col = color.new(inactive_rgb, inactive_rgb, inactive_rgb, arrows_alpha)
                    if menu.get_int("anti_aim.desync_type") ~= 2 then
                        if menu.get_key_bind_state("anti_aim.invert_desync_key") then
                            dynamic_color_left = inactive_col
                            dynamic_color_right = color.new(color:r(), color:g(), color:b(), arrows_alpha)
                        else
                            dynamic_color_left = color.new(color:r(), color:g(), color:b(), arrows_alpha)
                            dynamic_color_right = inactive_col
                        end
                    else
                        dynamic_color_right = color.new(color:r(), color:g(), color:b(), arrows_alpha)
                        dynamic_color_left = color.new(color:r(), color:g(), color:b(), arrows_alpha)
                    end
                    if menu.get_key_bind_state("anti_aim.manual_left_key") then
                        render.draw_text_centered( dynamic_font, screensizex / 2 + desyncrange, screensizey / 2, dynamic_color_right, true, true, "x" )
                        render.draw_text_centered( dynamic_font, screensizex / 2 - desyncrange, screensizey / 2, arrow_color, true, true, "w" )
                        render.draw_text_centered( dynamic_font, screensizex / 2 + desyncrange + 7, screensizey / 2, color.new(255, 255, 255, math.floor(255 * not_anim)), true, true, "x" )
                        render.draw_text_centered( dynamic_font, screensizex / 2 - desyncrange - 7, screensizey / 2, arrow_color, true, true, "w" )
                    elseif menu.get_key_bind_state("anti_aim.manual_right_key") then
                        render.draw_text_centered( dynamic_font, screensizex / 2 + desyncrange, screensizey / 2, arrow_color, true, true, "x" )
                        render.draw_text_centered( dynamic_font, screensizex / 2 - desyncrange, screensizey / 2, dynamic_color_left, true, true, "w" )
                        render.draw_text_centered( dynamic_font, screensizex / 2 + desyncrange + 7, screensizey / 2, arrow_color, true, true, "x" )
                        render.draw_text_centered( dynamic_font, screensizex / 2 - desyncrange - 7, screensizey / 2, color.new(255, 255, 255, math.floor(255 * not_anim)), true, true, "w" )
                    else
                        render.draw_text_centered( dynamic_font, screensizex / 2 + desyncrange, screensizey / 2, dynamic_color_right, true, true, "x" )
                        render.draw_text_centered( dynamic_font, screensizex / 2 - desyncrange, screensizey / 2, dynamic_color_left, true, true, "w" )
                        render.draw_text_centered( dynamic_font, screensizex / 2 + desyncrange + 7, screensizey / 2, color.new(255, 255, 255, math.floor(255 * not_anim)), true, true, "x" )
                        render.draw_text_centered( dynamic_font, screensizex / 2 - desyncrange - 7, screensizey / 2, color.new(255, 255, 255, math.floor(255 * not_anim)), true, true, "w" )
                    end
                end
            end
        end
end

acatel_alpha = 0
acatel_direction = 0

local function gunpaint()

    if not script_loaded then return end

    local me = entitylist.get_local_player()
    local wep = entitylist.get_weapon_by_player(me)

    local local_player = entitylist.get_local_player()
    if local_player == nil then return end
    local me = engine.get_local_player_index()
    local weapon = entitylist.get_weapon_by_player(local_player)
    if weapon then
        definition_index = weapon:get_prop_int('CBaseCombatWeapon', 'm_iItemDefinitionIndex');
    end

    gun = 0

    if me and definition_index == 40 then
        gun = 3 --scout
    elseif me and definition_index == 38 or definition_index == 11 then
        gun = 2 --auto
    elseif me and definition_index == 9 then
        gun = 4 --awp
    elseif me and definition_index == 1 or definition_index == 64 then
        gun = 0 -- r8/deagle
    elseif me and definition_index == 2 or definition_index == 3 or definition_index == 4 or definition_index == 30 or definition_index == 32 or definition_index == 36 or definition_index == 262205 or definition_index == 63 then
        gun = 1 --pistols
    elseif me and definition_index == 7 or definition_index == 8 or definition_index == 10 or definition_index == 13 or definition_index == 16 or definition_index == 39 or definition_index == 60 then
        gun = 5 --rifles
    elseif me and definition_index == 17 or definition_index == 19 or definition_index == 23 or definition_index == 24 or definition_index == 26 or definition_index == 33 or definition_index == 34 then
        gun = 6 --smg
    elseif me and definition_index == 25 or definition_index == 27 or definition_index == 29 or definition_index == 35 then
        gun = 7 --shotgun
    elseif me and definition_index == 14 or definition_index == 28 then
        gun = 8 --mg
    end

end

--client.add_callback( "on_paint", gun )

local function lighten(kolor)
    local r = kolor:r()
    local g = kolor:g()
    local b = kolor:b()
    local a = kolor:a()

    r = math.floor((r+255)*0.5)
    g = math.floor((g+255)*0.5)
    b = math.floor((b+255)*0.5)

    return color.new(r, g, b, a)
end

--menu.add_check_box( "scope test" )
--anim = 0

local function indicator()
    if not script_loaded then return end
    if menu.get_int( "AA Indicators style" ) == 0 then return end
    if entitylist.get_local_player() == nil then return end

    --client.log(tostring(definition_index))

    if menu.get_int( "AA Indicators style" ) == 1 then
        if engine.is_in_game() then
            local local_player = entitylist.get_local_player()
            local local_health = local_player:get_health()
            if local_health > 0 then
                local desyncrange = menu.get_int("anti_aim.desync_range")
                local mindmg = menu.get_int("rage.weapon["..gun.."].minimum_damage")
                local mindmg_override = menu.get_int("rage.weapon["..gun.."].force_damage_value")
                local accentcol = menu.get_color("Accent color")
                local color = color.new(accentcol:r(), accentcol:g(), accentcol:b(), 255)
                local scriptcol = menu.get_color("Script color")
                local fontcolor = color.new(scriptcol:r(), scriptcol:g(), scriptcol:b(), 255)
                local seccolor = menu.get_bool( "Fully colored logo" ) and lighten(fontcolor) or color.new(255, 255, 255, 255)
                if menu.get_key_bind_state( "anti_aim.invert_desync_key" ) then
                    rightcolor = fontcolor
                    --leftcolor = color.new(255, 255, 255, 255)
                    leftcolor = seccolor
                else
                    --rightcolor = color.new(255, 255, 255, 255)
                    rightcolor = seccolor
                    leftcolor = fontcolor
                end
                local pad0 = math.floor(anim * (6 + (render.get_text_width( fontitalic, "iugen" ) + render.get_text_width( fontbolditalic, "Script" )) / 2 + 1))
                local pad1 = math.floor(anim * (6 + math.floor(desyncrange)))
                local pad2 = math.floor(anim * (6 + render.get_text_width( font, tostring(desyncrange).."°" ) / 2 - 2))
                local padroll = math.floor(anim * (6 + render.get_text_width( fontsmall, "ROLL" ) / 2))
                local pad3 = math.floor(anim * (6 + render.get_text_width( fontsmall, "DT" ) / 2))
                local pad4 = math.floor(anim * (6 + render.get_text_width( fontsmall, "HS" ) / 2))
                local pad5 = math.floor(anim * (6 + render.get_text_width( fontsmall, "AP" ) / 2))
                local pad6 = math.floor(anim * (6 + render.get_text_width( fontsmall, "AP+DMG: "..tostring(mindmg_override) ) / 2))
                local pad7 = math.floor(anim * (6 + render.get_text_width( fontsmall, "DMG: "..tostring(mindmg_override) ) / 2))
                render.draw_text_centered(fontitalic, screensizex / 2 - render.get_text_width( fontitalic, "iugen" ) - 3 + pad0, screensizey / 2 + 25, leftcolor, false, true, "iugen" )
                render.draw_text_centered(fontbolditalic, screensizex / 2 - 3 + pad0, screensizey / 2 + 25, rightcolor, false, true, "Script" )
                local ind = 0
                local indspace = 20
                local indy = screensizey / 2 + 45
                if menu.get_bool("Show desync range") then
                    indy = indy + 7
                    gradientRender(screensizex / 2 - desyncrange + pad1, screensizey / 2 + 36, desyncrange - pad1, 3,0,0,0,0,color:r(),color:g(),color:b(),color:a(),true)
                    gradientRender(screensizex / 2 + 6 * anim, screensizey / 2 + 36, desyncrange, 3,color:r(),color:g(),color:b(),color:a(),200,200,255,0,true)
                    render.draw_text_centered(font, screensizex / 2 + 2 + pad2, indy + indspace * ind, color.new(255, 255, 255, 255), true, true, tostring(desyncrange).."°" )
                    ind = ind + 1
                end
                if menu.get_bool("Show other indicators") then
                    if menu.get_bool("anti_aim.roll") then
                        render.draw_text_centered(fontsmall, screensizex / 2 + padroll, indy + indspace * ind, color.new(255, 255, 255, 255), true, true, "ROLL" )
                        ind = ind + 1
                    end
                    if menu.get_key_bind_state("rage.double_tap_key") then
                        render.draw_text_centered(fontsmall, screensizex / 2 + pad3, indy + indspace * ind, color.new(255, 255, 255, 255), true, true, "DT" )
                        ind = ind + 1
                    end
                    if menu.get_key_bind_state("rage.hide_shots_key") then
                        render.draw_text_centered(fontsmall, screensizex / 2 + pad4, indy + indspace * ind, color.new(255, 255, 255, 255), true, true, "HS" )
                        ind = ind + 1
                    end
                    if menu.get_key_bind_state("misc.automatic_peek_key") then
                        if not menu.get_bool("Show minimum damage") then
                            render.draw_text_centered(fontsmall, screensizex / 2 + pad5, indy + indspace * ind, color.new(255, 255, 255, 255), true, true, "AP" )
                        elseif not menu.get_key_bind_state("rage.force_damage_key") then
                            render.draw_text_centered(fontsmall, screensizex / 2 + pad5, indy + indspace * ind, color.new(255, 255, 255, 255), true, true, "AP" )
                        end
                    end
                end
                if menu.get_bool("Show minimum damage") and menu.get_key_bind_state("rage.force_damage_key") then
                    if menu.get_bool("Show other indicators") and menu.get_key_bind_state("misc.automatic_peek_key") then
                        render.draw_text_centered(fontsmall, screensizex / 2 + pad6, indy + indspace * ind, color.new(255, 255, 255, 255), true, true, "AP+DMG: "..tostring(mindmg_override) )
                    else render.draw_text_centered(fontsmall, screensizex / 2 + pad7, indy + indspace * ind, color.new(255, 255, 255, 255), true, true, "DMG: "..tostring(mindmg_override) ) end
                    ind = ind + 1
                end
            end
        end
    elseif menu.get_int( "AA Indicators style" ) == 2 then
        if engine.is_in_game() then
            local local_player = entitylist.get_local_player()
            local local_health = local_player:get_health()
            if local_health > 0 then
                local desyncrange = menu.get_int("anti_aim.desync_range")
                local mindmg = menu.get_int("rage.weapon["..gun.."].minimum_damage")
                local mindmg_override = menu.get_int("rage.weapon["..gun.."].force_damage_value")
                local accentcol = menu.get_color("Accent color")
                local color = color.new(accentcol:r(), accentcol:g(), accentcol:b(), 255)
                local scriptcol = menu.get_color("Script color")
                local fontcolor = color.new(scriptcol:r(), scriptcol:g(), scriptcol:b(), 255)
                local seccolor = menu.get_bool( "Fully colored logo" ) and lighten(fontcolor) or color.new(255, 255, 255, 255)
                if menu.get_key_bind_state( "anti_aim.invert_desync_key" ) then
                    rightcolor = fontcolor
                    --leftcolor = color.new(255, 255, 255, 255)
                    leftcolor = seccolor
                else
                    --rightcolor = color.new(255, 255, 255, 255)
                    rightcolor = seccolor
                    leftcolor = fontcolor
                end
                local pad0 = math.floor(anim * (6 + render.get_text_width( pixelbig, "iugenScript" ) / 2 - 1))
                local pad1 = math.floor(anim * (6 + math.floor(desyncrange/2)))
                local pad2 = math.floor(anim * (6 + render.get_text_width( pixel0, tostring(desyncrange).."°" ) / 2 - 2))
                local padroll = math.floor(anim * (6 + render.get_text_width( pixel0, "ROLL" ) / 2))
                local pad3 = math.floor(anim * (6 + render.get_text_width( pixel0, "DT" ) / 2))
                local pad4 = math.floor(anim * (6 + render.get_text_width( pixel0, "HS" ) / 2))
                local pad5 = math.floor(anim * (6 + render.get_text_width( pixel0, "AP" ) / 2))
                local pad6 = math.floor(anim * (6 + render.get_text_width( pixel0, "AP+DMG: "..tostring(mindmg_override) ) / 2))
                local pad7 = math.floor(anim * (6 + render.get_text_width( pixel0, "DMG: "..tostring(mindmg_override) ) / 2))
                render.draw_text_centered(pixelbig, screensizex / 2 - render.get_text_width( pixelbig, "iugenScript" ) / 2 + 1 + pad0, screensizey / 2 + 25, leftcolor, false, true, "iugen" )
                render.draw_text_centered(pixelbig, screensizex / 2 - 2 + pad0, screensizey / 2 + 25, rightcolor, false, true, "Script" )
                local ind = 0
                local indspace = 12
                local indy = screensizey / 2 + 38
                if menu.get_bool("Show desync range") then
                    indy = indy + 5
                    gradientRender(screensizex / 2 - math.floor(desyncrange/2) + pad1, screensizey / 2 + 33, math.floor(desyncrange/2) - pad1, 2,0,0,0,0,color:r(),color:g(),color:b(),color:a(),true)
                    gradientRender(screensizex / 2 + 6 * anim, screensizey / 2 + 33, math.floor(desyncrange/2) + 6 * anim, 2,color:r(),color:g(),color:b(),color:a(),200,200,255,0,true)
                    render.draw_text_centered(pixel0, screensizex / 2 + 2 + pad2, indy + indspace * ind, color.new(255, 255, 255, 255), true, true, tostring(desyncrange).."°" )
                    ind = ind + 1
                end
                if menu.get_bool("Show other indicators") then
                    if menu.get_bool("anti_aim.roll") then
                        render.draw_text_centered(pixel0, screensizex / 2+ padroll, indy + indspace * ind, color.new(255, 255, 255, 255), true, true, "ROLL" )
                        ind = ind + 1
                    end
                    if menu.get_key_bind_state("rage.double_tap_key") then
                        render.draw_text_centered(pixel0, screensizex / 2+ pad3, indy + indspace * ind, color.new(255, 255, 255, 255), true, true, "DT" )
                        ind = ind + 1
                    end
                    if menu.get_key_bind_state("rage.hide_shots_key") then
                        render.draw_text_centered(pixel0, screensizex / 2 + pad4, indy + indspace * ind, color.new(255, 255, 255, 255), true, true, "HS" )
                        ind = ind + 1
                    end
                    if menu.get_key_bind_state("misc.automatic_peek_key") then
                        if not menu.get_bool("Show minimum damage") then
                            render.draw_text_centered(pixel0, screensizex / 2 + pad5, indy + indspace * ind, color.new(255, 255, 255, 255), true, true, "AP" )
                        elseif not menu.get_key_bind_state("rage.force_damage_key") then
                            render.draw_text_centered(pixel0, screensizex / 2 + pad5, indy + indspace * ind, color.new(255, 255, 255, 255), true, true, "AP" )
                        end
                    end
                end
                if menu.get_bool("Show minimum damage") and menu.get_key_bind_state("rage.force_damage_key") then
                    if menu.get_bool("Show other indicators") and menu.get_key_bind_state("misc.automatic_peek_key") then
                        render.draw_text_centered(pixel0, screensizex / 2 + pad6, indy + indspace * ind, color.new(255, 255, 255, 255), true, true, "AP+DMG: "..tostring(mindmg_override) )
                    else render.draw_text_centered(pixel0, screensizex / 2 + pad7, indy + indspace * ind, color.new(255, 255, 255, 255), true, true, "DMG: "..tostring(mindmg_override) ) end
                    ind = ind + 1
                end
            end
        end
    --elseif menu.get_int( "AA Indicators style" ) == 3 then
    --    if engine.is_in_game() then
    --        local local_player = entitylist.get_local_player()
    --        local local_health = local_player:get_health()
    --        if local_health > 0 then
    --            local desyncrange = menu.get_int("anti_aim.desync_range")
    --            local mindmg = menu.get_int("rage.weapon["..gun.."].minimum_damagegee")
    --            local mindmg_override = menu.get_int("rage.weapon["..gun.."].force_damage_valuelue")
    --            local accentcol = menu.get_color("Accent color")
    --            local color = color.new(accentcol:r(), accentcol:g(), accentcol:b(), 255)
    --            local scriptcol = menu.get_color("Script color")
    --            local fontcolor = color.new(scriptcol:r(), scriptcol:g(), scriptcol:b(), 255)
    --            render.draw_text(pixel, screensizex / 2, screensizey / 2 + 20, color.new(255, 255, 255, 255), "IUGEN" )
    --            render.draw_text(pixel, screensizex / 2 + render.get_text_width( pixel, "IUGEN" ) + 1, screensizey / 2 + 20, fontcolor, "SCRIPT" )
    --            local ind = 0
    --            local indspace = 12
    --            local indy = screensizey / 2 + 27 + 5
    --            local indspace2 = 0
    --            if menu.get_bool("Show desync range") then
    --                render.draw_text(pixel, screensizex / 2, indy + indspace * ind, color.new(255, 255, 255, 255), "Desync: "..tostring(desyncrange).."°" )
    --                ind = ind + 1
    --                if menu.get_key_bind_state( "anti_aim.invert_desync_key" ) then
    --                    render.draw_text(pixel, screensizex / 2, indy + indspace * ind, color.new(255, 255, 255, 255), "Fake Yaw: R" )
    --                else render.draw_text(pixel, screensizex / 2, indy + indspace * ind, color.new(255, 255, 255, 255), "Fake Yaw: L" )
    --                end
    --                ind = ind + 1
    --            end
    --            if menu.get_bool("Show minimum damage") then
    --                render.draw_text(pixel, screensizex / 2, indy + indspace * ind, color.new(255, 255, 255, 255), "MINDMG: " )
    --                if menu.get_key_bind_state("rage.force_damage_key") then
    --                    render.draw_text(pixel, screensizex / 2 + render.get_text_width( pixel, "MINDMG: " ), indy + indspace * ind, color.new(255, 0, 0, 255), tostring(mindmg_override) )
    --                else render.draw_text(pixel, screensizex / 2 + render.get_text_width( pixel, "MINDMG: " ), indy + indspace * ind, color.new(255, 255, 255, 255), tostring(mindmg) )
    --                end
    --                ind = ind + 1
    --            end --FIX MINDMG
    --            if menu.get_bool("Show other indicators") then
    --                if menu.get_key_bind_state("rage.double_tap_key") then
    --                    render.draw_text(pixel, screensizex / 2, indy + indspace * ind, color.new(255, 150, 0, 255), "DT" )
    --                else render.draw_text(pixel, screensizex / 2, indy + indspace * ind, color.new(150, 150, 150, 255), "DT" )
    --                end
    --                --ind = ind + 1
    --                indspace2 = indspace2 + render.get_text_width( pixel, "DT" ) + 10
    --                if menu.get_key_bind_state("rage.hide_shots_key") then
    --                    render.draw_text(pixel, screensizex / 2 + indspace2, indy + indspace * ind, color.new(150, 255, 0, 255), "HS" )
    --                else render.draw_text(pixel, screensizex / 2 + indspace2, indy + indspace * ind, color.new(150, 150, 150, 255), "HS" )
    --                end
    --                indspace2 = indspace2 + render.get_text_width( pixel, "HS" ) + 10
    --                if menu.get_int("rage.weapon["..gun.."].body_aim") == 0 then
    --                    render.draw_text(pixel, screensizex / 2 + indspace2, indy + indspace * ind, color.new(150, 150, 150, 255), "BAIM" )
    --                elseif menu.get_int("rage.weapon["..gun.."].body_aim") == 1 then
    --                    render.draw_text(pixel, screensizex / 2 + indspace2, indy + indspace * ind, color.new(255, 150, 0, 255), "BAIM" )
    --                elseif menu.get_int("rage.weapon["..gun.."].body_aim") == 2 then
    --                    render.draw_text(pixel, screensizex / 2 + indspace2, indy + indspace * ind, color.new(255, 0, 0, 255), "BAIM" )
    --                end
    --                indspace2 = indspace2 + render.get_text_width( pixel, "BAIM" ) + 10
    --                render.draw_text(pixel, screensizex / 2 + indspace2, indy + indspace * ind, color.new(150, 150, 150, 255), "SP" )
    --                indspace2 = indspace2 + render.get_text_width( pixel, "SP" ) + 10
    --                --ind = ind + 1
    --            end
    --            --MAKE SP
    --        end
    --    end
    elseif menu.get_int( "AA Indicators style" ) == 3 then
        if engine.is_in_game() then
            local local_player = entitylist.get_local_player()
            local local_health = local_player:get_health()
            if local_health > 0 then
                local desyncrange = menu.get_int("anti_aim.desync_range")
                local mindmg = menu.get_int("rage.weapon["..gun.."].minimum_damage")
                local mindmg_override = menu.get_int("rage.weapon["..gun.."].force_damage_value")
                local accentcol = menu.get_color("Accent color")
                local color = color.new(accentcol:r(), accentcol:g(), accentcol:b(), 255)
                local scriptcol = menu.get_color("Script color")
                local scopepad = math.floor(6 * anim)
                if acatel_alpha < 10 then
                    acatel_direction = 1
                elseif acatel_alpha > 254 then
                    acatel_direction = 0
                end
                if acatel_direction == 1 then
                    acatel_alpha = math.lerp(acatel_alpha, 255, globals.get_frametime() * 1.1)
                elseif acatel_direction == 0 then
                    acatel_alpha = math.lerp(acatel_alpha, 0, globals.get_frametime() * 1.1)
                end
                --client.log( tostring(acatel_alpha) )
                --client.log( tostring(acatel_direction) )
                local fontcolor = color.new(scriptcol:r(), scriptcol:g(), scriptcol:b(), math.floor(acatel_alpha))
                render.draw_text(pixelsmall, screensizex / 2 + scopepad, screensizey / 2 + 20, color.new(255, 255, 255, 255), "IUGEN" )
                render.draw_text(pixelsmall, screensizex / 2 + render.get_text_width( pixelsmall, "IUGEN" ) + 1 + scopepad, screensizey / 2 + 20, fontcolor, "SCRIPT" )
                local ind = 0
                local indspace = 8
                local indy = screensizey / 2 + 28
                local indspace2 = 0
                if menu.get_bool("Show desync range") then
                    render.draw_text(pixelsmall, screensizex / 2 + scopepad, indy + indspace * ind, color.new(255, 255, 255, 255), "Desync: "..tostring(desyncrange).."°" )
                    ind = ind + 1
                    if menu.get_key_bind_state( "anti_aim.invert_desync_key" ) then
                        render.draw_text(pixelsmall, screensizex / 2 + scopepad, indy + indspace * ind, color.new(255, 255, 255, 255), "Fake Yaw: R" )
                    else render.draw_text(pixelsmall, screensizex / 2 + scopepad, indy + indspace * ind, color.new(255, 255, 255, 255), "Fake Yaw: L" )
                    end
                    ind = ind + 1
                    render.draw_text(pixelsmall, screensizex / 2 + scopepad, indy + indspace * ind, color.new(255, 255, 255, 255), "Roll: "..tostring(menu.get_bool( "anti_aim.roll" )) )
                    ind = ind + 1
                end
                if menu.get_bool("Show minimum damage") then
                    render.draw_text(pixelsmall, screensizex / 2 + scopepad, indy + indspace * ind, color.new(255, 255, 255, 255), "MINDMG: " )
                    if menu.get_key_bind_state("rage.force_damage_key") then
                        render.draw_text(pixelsmall, screensizex / 2 + render.get_text_width( pixelsmall, "MINDMG: " ) + scopepad, indy + indspace * ind, color.new(255, 0, 0, 255), tostring(mindmg_override) )
                    else render.draw_text(pixelsmall, screensizex / 2 + render.get_text_width( pixelsmall, "MINDMG: " ) + scopepad, indy + indspace * ind, color.new(255, 200, 200, 255), tostring(mindmg) )
                    end
                    ind = ind + 1
                end --FIX MINDMG
                if menu.get_bool("Show other indicators") then
                    if menu.get_key_bind_state("rage.double_tap_key") then
                        render.draw_text(pixelsmall, screensizex / 2 + scopepad, indy + indspace * ind, color.new(150, 255, 0, 255), "DT" )
                    else render.draw_text(pixelsmall, screensizex / 2 + scopepad, indy + indspace * ind, color.new(150, 150, 150, 255), "DT" )
                    end
                    --ind = ind + 1
                    indspace2 = indspace2 + render.get_text_width( pixelsmall, "DT" ) + 8 + scopepad
                    if menu.get_key_bind_state("rage.hide_shots_key") then
                        render.draw_text(pixelsmall, screensizex / 2 + indspace2, indy + indspace * ind, color.new(255, 200, 0, 255), "HS" )
                    else render.draw_text(pixelsmall, screensizex / 2 + indspace2, indy + indspace * ind, color.new(150, 150, 150, 255), "HS" )
                    end
                    indspace2 = indspace2 + render.get_text_width( pixelsmall, "HS" ) + 8
                    if console.get_int( "cl_lagcompensation" ) == 0 then
                        render.draw_text(pixelsmall, screensizex / 2 + indspace2, indy + indspace * ind, color.new(0, 150, 255, 255), "AX" )
                    else
                        render.draw_text(pixelsmall, screensizex / 2 + indspace2, indy + indspace * ind, color.new(150, 150, 150, 255), "AX" )
                    end
                    indspace2 = indspace2 + render.get_text_width( pixelsmall, "AX" ) + 8
                    if menu.get_int("rage.weapon["..gun.."].body_aim") == 0 then
                        render.draw_text(pixelsmall, screensizex / 2 + indspace2, indy + indspace * ind, color.new(150, 150, 150, 255), "BAIM" )
                    elseif menu.get_int("rage.weapon["..gun.."].body_aim") == 1 then
                        render.draw_text(pixelsmall, screensizex / 2 + indspace2, indy + indspace * ind, color.new(255, 150, 0, 255), "BAIM" )
                    elseif menu.get_int("rage.weapon["..gun.."].body_aim") == 2 then
                        render.draw_text(pixelsmall, screensizex / 2 + indspace2, indy + indspace * ind, color.new(255, 0, 0, 255), "BAIM" )
                    end
                    indspace2 = indspace2 + render.get_text_width( pixelsmall, "BAIM" ) + 8
                    render.draw_text(pixelsmall, screensizex / 2 + indspace2, indy + indspace * ind, color.new(150, 150, 150, 255), "SP" )
                    indspace2 = indspace2 + render.get_text_width( pixelsmall, "SP" ) + 8
                    --ind = ind + 1
                end
                --MAKE SP
            end
        end
    elseif menu.get_int( "AA Indicators style" ) == 4 then
        if engine.is_in_game() then
            local local_player = entitylist.get_local_player()
            local local_health = local_player:get_health()
            if local_health > 0 then
                local desyncrange = menu.get_int("anti_aim.desync_range")
                local mindmg = menu.get_int("rage.weapon["..gun.."].minimum_damage")
                local mindmg_override = menu.get_int("rage.weapon["..gun.."].force_damage_value")
                local accentcol = menu.get_color("Accent color")
                local color = color.new(accentcol:r(), accentcol:g(), accentcol:b(), 255)
                local scriptcol = menu.get_color("Script color")
                local scopepad = math.floor(6 * anim)
                if acatel_alpha < 10 then
                    acatel_direction = 1
                elseif acatel_alpha > 254 then
                    acatel_direction = 0
                end
                if acatel_direction == 1 then
                    acatel_alpha = math.lerp(acatel_alpha, 255, globals.get_frametime() * 1.1)
                elseif acatel_direction == 0 then
                    acatel_alpha = math.lerp(acatel_alpha, 0, globals.get_frametime() * 1.1)
                end
                --client.log( tostring(acatel_alpha) )
                --client.log( tostring(acatel_direction) )
                local aastate = "Default"
                 --Jumping
                if player_jumping == 1 then
                    aastate = "Jumping"
                --Running
                elseif speed > 150 then
                    aastate = "Running"
                --Slow walk
                elseif flag == 261 or flag == 263 then
                    aastate = "Crouching"
                elseif menu.get_key_bind_state("misc.slow_walk_key") then
                    aastate = "Slow Walk"
                --Normal
                elseif speed < 5 then
                    aastate = "Standing"
                else
                    aastate = "Walking"
                end
                local fontcolor = color.new(scriptcol:r(), scriptcol:g(), scriptcol:b(), math.floor(acatel_alpha))

                local pad0 = math.floor(anim * (6 + render.get_text_width( pixelsmall2, "iugenScript" ) / 2 - 1))
                local pad1 = math.floor(anim * (6 + math.floor(desyncrange/2)))
                local pad2 = math.floor(anim * (6 + render.get_text_width( pixelsmall2, tostring(desyncrange).."°" ) / 2 - 2))
                local pad3 = math.floor(anim * (6 + render.get_text_width( pixelsmall2, "~"..aastate.."~" ) / 2))
                local padroll = math.floor(anim * (6 + render.get_text_width( pixelsmall2, "ROLL" ) / 2))
                local pad4 = math.floor(anim * (6 + render.get_text_width( pixelsmall2, "LETHAL" ) / 2))
                local pad5 = math.floor(anim * (6 + render.get_text_width( pixelsmall2, "DT HS AX BA" ) / 2 - 2))
                --local pad3 = math.floor(anim * (6 + render.get_text_width( pixelsmall2, "DT" ) / 2))
                --local pad4 = math.floor(anim * (6 + render.get_text_width( pixelsmall2, "HS" ) / 2))
                --local pad5 = math.floor(anim * (6 + render.get_text_width( pixelsmall2, "AP" ) / 2))
                local pad6 = math.floor(anim * (6 + render.get_text_width( pixelsmall2, "AP+DMG: "..tostring(mindmg_override) ) / 2))
                local pad7 = math.floor(anim * (6 + render.get_text_width( pixelsmall2, "DMG "..tostring(mindmg_override) ) / 2))
                
                local ind = 0
                local indspace = 10
                local indy = screensizey / 2 + 20
                local indspace2 = - render.get_text_width( pixelsmall2, "DT HS AX BA" ) / 2 + 2
                if menu.get_bool("Show desync range") then
                    render.draw_text(pixelsmall2, screensizex / 2 - render.get_text_width( pixelsmall2, tostring(desyncrange) ) / 2 + pad2, indy + indspace * ind, color.new(255, 255, 255, 255), tostring(desyncrange).."°" )
                    ind = ind + 1
                end
                render.draw_text_centered(pixelsmall2, screensizex / 2 - render.get_text_width( pixelsmall2, "IUGEN" ) / 2 - 1 + pad0, indy + indspace * ind, color.new(255, 255, 255, 255), true, false, "IUGEN" )
                render.draw_text_centered(pixelsmall2, screensizex / 2 + render.get_text_width( pixelsmall2, "SCRIPT" ) / 2 - 1 + pad0, indy + indspace * ind, fontcolor, true, false, "SCRIPT" )
                ind = ind + 1
                render.draw_text_centered(pixelsmall2, screensizex / 2 + pad3, indy + indspace * ind, color.new(255, 255, 255, 255), true, false, "~"..aastate.."~" )
                ind = ind + 1
                if (local_health <= 92) then
                    render.draw_text_centered(pixelsmall2, screensizex / 2 + pad4, indy + indspace * ind, color.new(255, math.floor(255 * local_health * 0.01), math.floor(255 * local_health * 0.01), 255), true, false, "LETHAL" )
                    ind = ind + 1
                end
                --[[if menu.get_bool("Show desync range") then
                    if menu.get_int( "anti_aim.desync_type" ) == 2 then
                        render.draw_text_centered(pixelsmall2, screensizex / 2 + scopepad, indy + indspace * ind, color.new(255, 255, 255, 255), true, false, "SIDE JITTER" )
                    elseif menu.get_key_bind_state( "anti_aim.invert_desync_key" ) then
                        render.draw_text_centered(pixelsmall2, screensizex / 2 + scopepad, indy + indspace * ind, color.new(255, 255, 255, 255), true, false, "SIDE R" )
                    else render.draw_text_centered(pixelsmall2, screensizex / 2 + scopepad, indy + indspace * ind, color.new(255, 255, 255, 255), true, false, "SIDE L" )
                    end
                    ind = ind + 1
                end]]
                if menu.get_bool("Show minimum damage") then
                    
                    if menu.get_key_bind_state("rage.force_damage_key") then
                        render.draw_text(pixelsmall2, screensizex / 2 - render.get_text_width( pixelsmall2, "DMG "..tostring(mindmg_override) ) / 2 + pad7, indy + indspace * ind, color.new(255, 255, 255, 255), "DMG" )
                        render.draw_text(pixelsmall2, screensizex / 2 + render.get_text_width( pixelsmall2, tostring(mindmg_override) ) / 2 + pad7, indy + indspace * ind, color.new(200, 55, 55, 255), tostring(mindmg_override) )
                        ind = ind + 1
                    --else
                    --    render.draw_text(pixelsmall2, screensizex / 2 - render.get_text_width( pixelsmall2, "DMG "..tostring(mindmg) ) / 2 + scopepad, indy + indspace * ind, color.new(255, 255, 255, 255), "DMG" )
                    --    render.draw_text(pixelsmall2, screensizex / 2 + render.get_text_width( pixelsmall2, tostring(mindmg) ) / 2 + scopepad, indy + indspace * ind, color.new(255, 200, 200, 255), tostring(mindmg) )
                    end
                    --ind = ind + 1
                end --FIX MINDMG
                if menu.get_bool("Show other indicators") then
                    if menu.get_bool("anti_aim.roll") then
                        render.draw_text_centered(pixelsmall2, screensizex / 2 + padroll, indy + indspace * ind, color.new(255, 255, 255, 255), true, false, "ROLL" )
                        ind = ind + 1
                    end
                    if menu.get_key_bind_state("rage.double_tap_key") then
                        render.draw_text(pixelsmall2, screensizex / 2 + indspace2 + pad5, indy + indspace * ind, color.new(255, 255, 255, 255), "DT" )
                    else render.draw_text(pixelsmall2, screensizex / 2 + indspace2 + pad5, indy + indspace * ind, color.new(150, 150, 150, 255), "DT" )
                    end
                    --ind = ind + 1
                    indspace2 = indspace2 + render.get_text_width( pixelsmall2, "DT " ) + pad5
                    if menu.get_key_bind_state("rage.hide_shots_key") then
                        render.draw_text(pixelsmall2, screensizex / 2 + indspace2, indy + indspace * ind, color.new(255, 255, 255, 255), "HS" )
                    else render.draw_text(pixelsmall2, screensizex / 2 + indspace2, indy + indspace * ind, color.new(150, 150, 150, 255), "HS" )
                    end
                    indspace2 = indspace2 + render.get_text_width( pixelsmall2, "HS " )
                    if console.get_int( "cl_lagcompensation" ) == 0 then
                        render.draw_text(pixelsmall2, screensizex / 2 + indspace2, indy + indspace * ind, color.new(0, 150, 255, 255), "AX" )
                    else
                        render.draw_text(pixelsmall2, screensizex / 2 + indspace2, indy + indspace * ind, color.new(150, 150, 150, 255), "AX" )
                    end
                    indspace2 = indspace2 + render.get_text_width( pixelsmall2, "AX " )
                    if menu.get_int("rage.weapon["..gun.."].body_aim") == 0 then
                        render.draw_text(pixelsmall2, screensizex / 2 + indspace2, indy + indspace * ind, color.new(150, 150, 150, 255), "BA" )
                    elseif menu.get_int("rage.weapon["..gun.."].body_aim") == 1 then
                        render.draw_text(pixelsmall2, screensizex / 2 + indspace2, indy + indspace * ind, color.new(255, 150, 0, 255), "BA" )
                    elseif menu.get_int("rage.weapon["..gun.."].body_aim") == 2 then
                        render.draw_text(pixelsmall2, screensizex / 2 + indspace2, indy + indspace * ind, color.new(255, 0, 0, 255), "BA" )
                    end
                    indspace2 = indspace2 + render.get_text_width( pixelsmall2, "BA " )
                    --render.draw_text(pixelsmall2, screensizex / 2 + indspace2, indy + indspace * ind, color.new(150, 150, 150, 255), "SP" )
                    --indspace2 = indspace2 + render.get_text_width( pixelsmall2, "SP " )
                    --ind = ind + 1
                end
                --MAKE SP
            end
        end
    end
end

--[[ffi.cdef[[
    // HITBOXPOS START

    typedef unsigned char byte;

    typedef struct
    {
        float x,y,z;
    } Vector;

    typedef struct
    {
        int id;                     //0x0000
        int version;                //0x0004
        long    checksum;               //0x0008
        char    szName[64];             //0x000C
        int length;                 //0x004C
        Vector  vecEyePos;              //0x0050
        Vector  vecIllumPos;            //0x005C
        Vector  vecHullMin;             //0x0068
        Vector  vecHullMax;             //0x0074
        Vector  vecBBMin;               //0x0080
        Vector  vecBBMax;               //0x008C
        int pad[5];
        int numhitboxsets;          //0x00AC
        int hitboxsetindex;         //0x00B0
    } studiohdr_t;

    typedef struct
    {
        void*   fnHandle;               //0x0000
        char    szName[260];            //0x0004
        int nLoadFlags;             //0x0108
        int nServerCount;           //0x010C
        int type;                   //0x0110
        int flags;                  //0x0114
        Vector  vecMins;                //0x0118
        Vector  vecMaxs;                //0x0124
        float   radius;                 //0x0130
        char    pad[28];              //0x0134
    } model_t;

    typedef struct
    {
        int     m_bone;                 // 0x0000
        int     m_group;                // 0x0004
        Vector  m_mins;                 // 0x0008
        Vector  m_maxs;                 // 0x0014
        int     m_name_id;                // 0x0020
        Vector  m_angle;                // 0x0024
        float   m_radius;               // 0x0030
        int        pad2[4];
    } mstudiobbox_t;
    
    typedef struct
    {
        int sznameindex;
    
        int numhitboxes;
        int hitboxindex;
    } mstudiohitboxset_t;

    typedef struct {
        float m_flMatVal[3][4];
    } matrix3x4_t;

    typedef bool(__fastcall* cbaseanim_setupbones)(matrix3x4_t *pBoneToWorldOut, int nMaxBones, int boneMask, float currentTime);

    // HITBOXPOS END
]]
--[[
function player:is_alive()
    if not self then return false end
    return self:get_health() > 0
end

local ModelInfo = ffi.cast(ffi.typeof("void***"), utils.create_interface("engine.dll", "VModelInfoClient004"))
local GetStudioModel = ffi.cast(ffi.typeof("studiohdr_t*(__thiscall*)(void*, model_t*)"), ModelInfo[0][32])

local IClientEntityList = ffi.cast(ffi.typeof("void***"), utils.create_interface("client.dll", "VClientEntityList003"))
local GetHighestEntityIndex = ffi.cast(ffi.typeof("int(__thiscall*)(void*)"), IClientEntityList[0][6])
local GetClientEntity = ffi.cast(ffi.typeof("unsigned long(__thiscall*)(void*, int)"), IClientEntityList[0][3])

local Typeof_tbl = {
    ClientRenderable = ffi.typeof("void***"),
    GetModel = ffi.typeof("model_t*(__thiscall*)(void*)"),
    SetupBones = ffi.typeof("bool(__thiscall*)(void*, matrix3x4_t* pBoneToWorldOut, int nMaxBones, int boneMask, float currentTime)")
}

local ClientRenderable_tbl = {}
function vector:add(a)
    return vector.new(self.x + a.x, self.y + a.y, self.z + a.z)
  end
  
function vector:divide(a)
  return vector.new(self.x / a, self.y / a, self.z / a)
end
local pHitboxSet = function(i, stdmdl)
    if i < 0 or i > stdmdl.numhitboxsets then return nil end
    return ffi.cast("mstudiohitboxset_t*", ffi.cast("byte*", stdmdl) + stdmdl.hitboxsetindex) + i
end
  
local pHitbox = function(i, stdmdl)
  if i > stdmdl.numhitboxes then return nil end
  return ffi.cast("mstudiobbox_t*", ffi.cast("byte*", stdmdl) + stdmdl.hitboxindex) + i
end
local DotProduct = function(a, b)
    return a.x * b.x + a.y * b.y + a.z * b.z
  end
    
  local VectorTransform = function(in1, in2)
    return vector.new(
        DotProduct(in1, vector.new(in2[0][0], in2[0][1], in2[0][2])) + in2[0][3],
        DotProduct(in1, vector.new(in2[1][0], in2[1][1], in2[1][2])) + in2[1][3],
        DotProduct(in1, vector.new(in2[2][0], in2[2][1], in2[2][2])) + in2[2][3]
    )
  end
function player:gethitboxpos(hitbox_id)
    local hitbox_id = hitbox_id or 0
    if not self or not self:is_alive() then return end

    local index = self:get_index()

    local matrix = ffi.new('matrix3x4_t[128]')
    if ClientRenderable_tbl[index] == nil then
        ClientRenderable_tbl[index] = {}
        ClientRenderable_tbl[index].ClientRenderable = ffi.cast(Typeof_tbl.ClientRenderable, GetClientEntity(IClientEntityList, index) + 0x4)
        ClientRenderable_tbl[index].GetModel = ffi.cast(Typeof_tbl.GetModel, ClientRenderable_tbl[index].ClientRenderable[0][8])
        ClientRenderable_tbl[index].SetupBones = ffi.cast(Typeof_tbl.SetupBones, ClientRenderable_tbl[index].ClientRenderable[0][13])
    end
    local sbool = ClientRenderable_tbl[index].SetupBones(ClientRenderable_tbl[index].ClientRenderable, matrix, 128, 0x0007FF00, globals.get_curtime())
    if not matrix or not sbool then return end

    local model = ClientRenderable_tbl[index].GetModel(ClientRenderable_tbl[index].ClientRenderable)

    if not model then return end

    local studio_model = GetStudioModel(ModelInfo, model)

    if not studio_model then return end

    local set = pHitboxSet( 0, studio_model)

    if not set then return end

    local hitbox = pHitbox(hitbox_id, set)

    if not hitbox then return end
    local mins = VectorTransform(hitbox.m_mins, matrix[hitbox.m_bone].m_flMatVal)
    local maxs = VectorTransform(hitbox.m_maxs, matrix[hitbox.m_bone].m_flMatVal)

    return mins:add(maxs):divide(2)
end
]]
function vector:__add(_vector)
    if not self or not self:is_valid() then
      return self end
    return vector.new(self.x + _vector.x, self.y + _vector.y, self.z + _vector.z)
  end
  
  function player:get_eye_position()
    if not self or not self:is_player() or not (self:get_health() > 0) then
      return end
    
    local origin = self:get_origin()
    local eye_offset = vector.new(
      self:get_prop_float('CBasePlayer', 'm_vecViewOffset[0]'),
      self:get_prop_float('CBasePlayer', 'm_vecViewOffset[1]'),
      self:get_prop_float('CBasePlayer', 'm_vecViewOffset[2]')
    )
    return origin + eye_offset
  end
--local verdana = render.create_font( "Smallest Pixel-7", 21, 0, true )
function math.lerp(a, b, t) return a + (b - a) * t end
holoposx = screensizex / 2
holoposy = screensizey / 2
updateposx = holoposx
updateposy = holoposy
maxfakelag = 0
--local last_choke = {[0] = 0, [1] = 0, [2] = 0, [3] = 0, [4] = 0}
delay = 0
local function holopanel()
    if not script_loaded then return end
    logcol = menu.get_color( "Logs color" )
    if not menu.get_bool( "Holo panel" ) then return end
    if not engine.is_in_game() then return end
    local lp = entitylist.get_local_player()
    if not lp then return end
    local hp = lp:get_health()
    if not (hp > 0) then return end
    local velocity = lp:get_velocity()
    local speed = velocity:length_2d()
    --local hitbox = lp:gethitboxpos(0)
    local hitbox = lp:get_origin()
    if not hitbox then return end
    hitbox.z = hitbox.z + 50
    local hitboxpos = render.world_to_screen( hitbox )
    if not menu.get_key_bind_state( "misc.third_person_key" ) then return end
    if globals.get_tickcount() % 4 == 0 then
        updateposx = hitboxpos.x
        updateposy = hitboxpos.y
        maxfakelag = menu.get_int("anti_aim.fake_lag_limit")
    end
    --maxfakelag = getmaxfakelag()
    holoposx = math.lerp(holoposx, updateposx + 125, globals.get_frametime() * 2)
    holoposy = math.lerp(holoposy, updateposy + 125, globals.get_frametime() * 2)
    --the delay was 0.02
    local accentcol = menu.get_color("Accent color")
    local color = color.new(accentcol:r(), accentcol:g(), accentcol:b(), 255)
    render.draw_line( hitboxpos.x + 25, hitboxpos.y + 25, holoposx, holoposy, color.new(30, 30, 30, 150) )
    --render.draw_rect_filled( holoposx, holoposy, 200, 150, color.new(30, 30, 30, 150) )
    if menu.get_int( "Theme" ) == 1 then
        filledbox(holoposx, holoposy, 228, 100, 255)
    else
        filledbox(holoposx, holoposy + 6, 228, 100, 255)
    end
    --render.draw_text_centered( verdana, holoposx + 100, holoposy + 75, color.new(255, 255, 255), true, true, "Desync: "..tostring(menu.get_int( "anti_aim.desync_range" )) )
    local holotexty = 0
    local holotextcount = 0
    if menu.get_int( "Theme" ) == 1 then
        holotexty = holoposy + 6
    else
        holotexty = holoposy + 10
    end
    local yawbase = ""
    local yawmanual = false
    if legit_aa_active then
        yawbase = "Legit AA"
    elseif menu.get_key_bind_state( "anti_aim.manual_left_key" ) then
        yawbase = "Q"
        yawmanual = true
    elseif menu.get_key_bind_state( "anti_aim.manual_right_key" ) then
        yawbase = "R"
        yawmanual = true
    elseif menu.get_key_bind_state( "anti_aim.manual_forward_key" ) then
        yawbase = "O"
        yawmanual = true
    elseif menu.get_key_bind_state( "anti_aim.manual_back_key" ) then
        yawbase = "P"
        yawmanual = true
    elseif menu.get_bool( "anti_aim.freestanding" ) then
        yawbase = "Edge"
    elseif menu.get_int( "anti_aim.target_yaw" ) == 1 then
        yawbase = "AT"
    else yawbase = tostring(menu.get_int( "anti_aim.yaw_offset" )) end
    local aastate = "Default"
     --Jumping
    if player_jumping == 1 then
        aastate = "Jumping"
    --Running
    elseif speed > 150 then
        aastate = "Running"
    --Slow walk
    elseif flag == 261 or flag == 263 then
        aastate = "Crouching"
    elseif menu.get_key_bind_state("misc.slow_walk_key") then
        aastate = "Slow Walk"
    --Normal
    elseif speed < 5 then
        aastate = "Standing"
    else
        aastate = "Walking"
    end
    local desyncstate = ""
    if menu.get_int( "anti_aim.desync_type" ) == 0 then
        desyncstate = "Disabled"
    elseif menu.get_int( "anti_aim.desync_type" ) == 1 then
        desyncstate = "Static"
    elseif menu.get_int( "anti_aim.desync_type" ) == 2 or (menu.get_int( "anti_aim.desync_type" ) == 1 and tankproc) then
        desyncstate = "Jitter"
    elseif menu.get_int( "anti_aim.desync_type" ) == 3 then
        desyncstate = "Flick"
    end
    if menu.get_int( "anti_aim.desync_type" ) == 0 then
        render.draw_text( pixelbig, holoposx + 6, holotexty, color.new(255, 255, 255), "AA Status: REAL" )
    else
        if menu.get_key_bind_state( "anti_aim.invert_desync_key" ) then
            local desync = menu.get_int( "anti_aim.desync_range_inverted" )
            render.draw_text( pixelbig, holoposx + 6, holotexty, color.new(255, 255, 255), "AA Status: FAKE ("..tostring(desync).."°)" )
            render.draw_rect_filled( holoposx + 6 + render.get_text_width( pixelbig, "AA STATUS: FAKE (-XX°)" ) + 40, holotexty, math.floor(desync / 2), 14, color )
        else
            local desync = menu.get_int( "anti_aim.desync_range" )
            render.draw_text( pixelbig, holoposx + 6, holotexty, color.new(255, 255, 255), "AA Status: FAKE (".."-"..tostring(desync).."°)" )
            render.draw_rect_filled( holoposx + 6 + render.get_text_width( pixelbig, "AA Status: FAKE (-XX°)" ) + 40 - math.floor(desync / 2), holotexty, math.floor(desync / 2), 14, color )
        end
    end
    local fakelagtext = ""
    if menu.get_bool( "anti_aim.enable_fake_lag" ) then
        if menu.get_key_bind_state( "rage.double_tap_key" ) then
            fakelagtext = "FAKELAG: SHIFTING (1)"
        elseif menu.get_key_bind_state( "rage.hide_shots_key" ) then
            fakelagtext = "FAKELAG: SHIFTING (6)"
        else
            fakelagtext = "FAKELAG: CHOKING ("..tostring(maxfakelag)..")"
        end
    else
        if menu.get_key_bind_state( "rage.hide_shots_key" ) then
            fakelagtext = "FAKELAG: SHIFTING (0)"
        elseif menu.get_key_bind_state( "rage.double_tap_key" ) then
            fakelagtext = "FAKELAG: SHIFTING (0)"
        else
            fakelagtext = "FAKELAG: OFF"
        end
    end
    if menu.get_key_bind_state( "anti_aim.fake_duck_key" ) then
        fakelagtext = "FAKELAG: CHOKING (14)"
    end
    delay = delay + 1
    if delay == 32 then
        last_choke[4] = last_choke[3]
        last_choke[3] = last_choke[2]
        last_choke[2] = last_choke[1]
        last_choke[1] = last_choke[0]
        last_choke[0] = menu.get_int("anti_aim.fake_lag_limit")
        --if send_packet == false then
            --last_choke[0] = getmaxfakelag()
        --end
        if menu.get_bool("anti_aim.enable_fake_lag") == false then
          last_choke[0] = 0
        end
        if menu.get_key_bind_state("rage.double_tap_key") then
          last_choke[0] = 0
        end
        if menu.get_key_bind_state("rage.hide_shots_key") then
          if last_choke[0] > 6 then
            last_choke[0] = 6
          end
        end
        if menu.get_key_bind_state("anti_aim.fake_duck_key") then
            last_choke[0] = 14
        end
        delay = 0
    end
    render.draw_text( pixelbig, holoposx + 6, holotexty + 16, color.new(255, 255, 255), fakelagtext )
    render.draw_text( verdana, holoposx + 6, holotexty + 32 + 14 * holotextcount, color.new(255, 255, 255), "State: "..aastate )
    holotextcount = holotextcount + 1
    render.draw_text( verdana, holoposx + 6, holotexty + 32 + 14 * holotextcount, color.new(255, 255, 255), "Desync type: "..desyncstate )
    holotextcount = holotextcount + 1
    if yawmanual then
        render.draw_text( verdana, holoposx + 6, holotexty + 32 + 14 * holotextcount, color.new(255, 255, 255), "Yaw Base: " )
        render.draw_text_centered( arrowsfontsmall, holoposx + 6 + render.get_text_width( pixel, "Yaw Base: " ), holotexty + 32 + 7 + 14 * holotextcount, color.new(255, 255, 255), true, true, yawbase )
    else
        render.draw_text( verdana, holoposx + 6, holotexty + 32 + 14 * holotextcount, color.new(255, 255, 255), "Yaw Base: "..yawbase )
    end
    holotextcount = holotextcount + 1
    render.draw_line( holoposx + 123 + 16, holotexty + 32 + 14 * holotextcount - math.floor(last_choke[4] * 1.5), holoposx + 123 + 32, holotexty + 32 + 14 * holotextcount - math.floor(last_choke[3] * 1.5), color.new(255, 255, 255) )
    render.draw_line( holoposx + 123 + 32, holotexty + 32 + 14 * holotextcount - math.floor(last_choke[3] * 1.5), holoposx + 123 + 48, holotexty + 32 + 14 * holotextcount - math.floor(last_choke[2] * 1.5), color.new(255, 255, 255) )
    render.draw_line( holoposx + 123 + 48, holotexty + 32 + 14 * holotextcount - math.floor(last_choke[2] * 1.5), holoposx + 123 + 64, holotexty + 32 + 14 * holotextcount - math.floor(last_choke[1] * 1.5), color.new(255, 255, 255) )
    render.draw_line( holoposx + 123 + 64, holotexty + 32 + 14 * holotextcount - math.floor(last_choke[1] * 1.5), holoposx + 123 + 80, holotexty + 32 + 14 * holotextcount - math.floor(last_choke[0] * 1.5), color.new(255, 255, 255) )
    local ind = 0
    local indspace = 8
    local indy = holoposy + 90
    local indspace2 = 0
    if menu.get_key_bind_state("rage.double_tap_key") then
        render.draw_text(pixelsmall, holoposx + 6, indy + indspace * ind, color.new(150, 255, 0, 255), "DT" )
    else render.draw_text(pixelsmall, holoposx + 6, indy + indspace * ind, color.new(150, 150, 150, 255), "DT" )
    end
    --ind = ind + 1
    indspace2 = indspace2 + render.get_text_width( pixelsmall, "DT" ) + 8
    if menu.get_key_bind_state("rage.hide_shots_key") then
        render.draw_text(pixelsmall, holoposx + 6 + indspace2, indy + indspace * ind, color.new(255, 200, 0, 255), "HS" )
    else render.draw_text(pixelsmall, holoposx + 6 + indspace2, indy + indspace * ind, color.new(150, 150, 150, 255), "HS" )
    end
    indspace2 = indspace2 + render.get_text_width( pixelsmall, "HS" ) + 8
    if console.get_int( "cl_lagcompensation" ) == 0 then
        render.draw_text(pixelsmall, holoposx + 6 + indspace2, indy + indspace * ind, color.new(0, 150, 255, 255), "AX" )
    else
        render.draw_text(pixelsmall, holoposx + 6 + indspace2, indy + indspace * ind, color.new(150, 150, 150, 255), "AX" )
    end
    indspace2 = indspace2 + render.get_text_width( pixelsmall, "AX" ) + 8
    if menu.get_int("rage.weapon["..gun.."].body_aim") == 0 then
        render.draw_text(pixelsmall, holoposx + 6 + indspace2, indy + indspace * ind, color.new(150, 150, 150, 255), "BAIM" )
    elseif menu.get_int("rage.weapon["..gun.."].body_aim") == 1 then
        render.draw_text(pixelsmall, holoposx + 6 + indspace2, indy + indspace * ind, color.new(255, 150, 0, 255), "BAIM" )
    elseif menu.get_int("rage.weapon["..gun.."].body_aim") == 2 then
        render.draw_text(pixelsmall, holoposx + 6 + indspace2, indy + indspace * ind, color.new(255, 0, 0, 255), "BAIM" )
    end
    indspace2 = indspace2 + render.get_text_width( pixelsmall, "BAIM" ) + 8
    render.draw_text(pixelsmall, holoposx + 6 + indspace2, indy + indspace * ind, color.new(150, 150, 150, 255), "SP" )
    indspace2 = indspace2 + render.get_text_width( pixelsmall, "SP" ) + 8
end

--client.add_callback( "on_paint", indicator )
--
--client.add_callback("on_paint", Arrows)
--
--client.add_callback("on_paint", watermark)
--client.add_callback("on_paint", keybinds)

logfont = render.create_font( "Tahoma", 13, 550, true )
--nllogsfont = render.create_font( "Tahoma", 13, 550, true )
nllogsfont = render.create_font( "MuseoSans-500", 13, 0, true, true, true)
--nllogsbold = render.create_font( "Tahoma", 13, 650, true )
nllogsbold = render.create_font( "MuseoSans-500", 13, 500, true, true, true)
smalllogs = render.create_font("Verdana", 12, 0, false, true, true)

local logcol = menu.get_color( "Logs color" )

updated = false

function add_colored_message( text, once )

    local logcol = menu.get_color( "Logs color" )

    if not updated then
        engine_cvar = ffi.cast("void***", utils.create_interface("vstdlib.dll", "VEngineCvar007"))
        console_print = ffi.cast("void(__cdecl*)(void*, const struct c_color&, const char*, ...)", engine_cvar[0][25])
    end

    if not once then
        return
    end

    console_color.clr[0] = logcol:r()
    console_color.clr[1] = logcol:g()
    console_color.clr[2] = logcol:b()

    console_print(engine_cvar, console_color, "[iugenScript] ")
    console_color.clr[0] = 255
    console_color.clr[1] = 255
    console_color.clr[2] = 255
    console_print(engine_cvar, console_color, tostring(text).."\n")

    updated = true

end

messages = {}
messages.text = ""
messages.time = globals.get_curtime() + 2.5
messages.bg_position = 0
messages.alpha = 0
messages.once = true

function add_message( text )
    table.insert(messages, { text=tostring(text), time=globals.get_curtime() + 2.5, bg_position=0, alpha=0, once=true })
end

function math.lerp(a, b, t) return a + (b - a) * t end

local console_logs = false

local function nllogs()
    if not script_loaded then return end

    console_logs = menu.get_bool( "Console logs" )

    if menu.get_int( "Logs style" ) == 1 then
        logfont = nllogsfont
    elseif menu.get_int( "Logs style" ) == 2 then
        logfont = nllogsbold
    elseif menu.get_int( "Logs style" ) == 3 then
        logfont = smalllogs
    end

    if menu.get_int( "Logs style" ) == 1 or menu.get_int( "Logs style" ) == 2 then

        if not (#messages > 0) then return end

        if not engine.is_connected() then updated = false end
        
        local current_time = globals.get_curtime()

        local last_y_position = 0
        logcol = menu.get_color( "Logs color" )
        

        for i = 1,#messages do

            local msg = messages[i]

            if msg == nil then return end

            msg.bg_position = math.floor((msg.time - globals.get_curtime()) > 1.35 and math.lerp(msg.bg_position + 1, screensizex / 3.15, globals.get_frametime() * 2 ) or (msg.time - globals.get_curtime()) < 0.15 and math.lerp(msg.bg_position - 1, 0, globals.get_frametime() ) or screensizex / 3.15)
            msg.alpha = math.floor((msg.time - globals.get_curtime()) > 1.35 and math.lerp(msg.alpha + 1, logcol:a(), globals.get_frametime() * 2 ) or (msg.time - globals.get_curtime()) < 0.15 and math.lerp(msg.alpha - 1, 0, globals.get_frametime() * 2 ) or logcol:a())
            --client.log( tostring(msg.time - globals.get_curtime()) )

            if msg.time - globals.get_curtime() > 0 then
                render_message( msg.text, last_y_position, msg.bg_position, msg.alpha )
                --add_colored_message( msg.text, msg.once )
                msg.once = false
            else
                table.remove(messages, i)
            end

            last_y_position = last_y_position + 15

        end
    end

end

function render_message( text, y_position, bg_position, alpha )

    if menu.get_int( "Logs style" ) == 1 then
        filled_rect( false, y_position, color.new( 5, 20, 39, alpha ), bg_position )
        filled_rect( true, y_position, color.new( 32, 213, 225, alpha ), bg_position )
    elseif menu.get_int( "Logs style" ) == 2 then
        filled_rect( false, y_position, color.new( 20, 20, 20, alpha ), bg_position )
        filled_rect( true, y_position, color.new( logcol:r(), logcol:g(), logcol:b(), alpha ), bg_position )
    end
    message( text, y_position, bg_position, alpha )

end

function filled_rect( is_end, y_position, color, bg_position )
    render.draw_rect_filled(  is_end and bg_position - 5 or 0, y_position ,   is_end and 5 or bg_position,  15 , color )
end

function message( text, y_position, bg_position, alpha )
    render.draw_text( logfont, -(screensizex / 3.15) + 10 + bg_position, y_position + 1, color.new( 255, 255, 255, 255 ), text )
end

local function logs_text(info)
    if not script_loaded then return end

    local shot_result = info.result
    local shot_target = info.target_index
    local target_hitbox = info.client_hitbox
    local server_hitbox = info.server_hitbox
    local client_damage = info.client_damage
    local shot_damage = info.server_damage
    local hitchance = info.hitchance

    if shot_result == "" then
        return
    end

    local temp_name = engine.get_player_info( shot_target ).name
    local target_name = string.len(temp_name) > 40 and string.lower( string.sub( temp_name, 0, 40 ) ).."..." or string.lower(temp_name)

    --local message_text = string.format('missed shot due to %s (%s)', shot_result, get_hitbox(target_hitbox))
    --
    --if shot_result == 'Hit' then
    --    message_text = string.format('did %d in %s', shot_damage, get_hitbox(target_hitbox))
    --end
    if shot_result == "Resolver" then
        message_text = tostring("Missed shot due to animation desync")
    end

    if shot_result == "Hit" then
        message_text = tostring("You did "..shot_damage.." to "..temp_name.." in "..target_hitbox)
    end

    if shot_result == "Spread" then
        message_text = tostring("Missed shot due to spread")
    end

    if shot_result == "None" then
        message_text = tostring("Missed shot due to death")
    end

    if shot_result == "Occlusion" then
        message_text = tostring("Missed shot due to occlusion")
    end

    if menu.get_int( "Logs style" ) == 1 then
        add_message( message_text )
    end

    if menu.get_int( "Logs style" ) == 2 or console_logs then
        if shot_result == "Resolver" then
            message_text = tostring("Missed "..temp_name.." due to resolver ("..target_hitbox..")")
        end
    
        if shot_result == "Hit" then
            if target_hitbox ~= server_hitbox or shot_damage ~= client_damage then
                message_text = tostring("Hit " .. temp_name .." in the " .. server_hitbox .. " for " .. shot_damage .. " (aimed at "..target_hitbox.." for "..client_damage..") (hitchance: "..hitchance..")")
            else message_text = tostring("Hit " .. temp_name .." in the " .. server_hitbox .. " for " .. shot_damage .. " (hitchance: "..hitchance..")") end
        end
    
        if shot_result == "Spread" then
            message_text = tostring("Missed "..temp_name.." due to spread ("..target_hitbox..") (hitchance: "..hitchance..")")
        end
    
        if shot_result == "None" then
            message_text = tostring("Missed "..temp_name.." due to death")
        end
    
        if shot_result == "Occlusion" then
            message_text = tostring("Missed "..temp_name.." due to occlusion ("..target_hitbox..")")
        end
    end

    if menu.get_int( "Logs style" ) == 2 then
        add_message( message_text )
    end
    
    if console_logs then
        add_colored_message( message_text, true )
    end

end

--se.register_event("item_purchase") --flshbang, incgrenade, smokegrenade, hegrenade, decoy

hitboxes = {
    "head",
    "neck",
    "pelvis",
    "belly",
    "thorax",
    "lower chest",
    "upper chest",
    "right thigh",
    "left thigh",
    "right calf",
    "left calf",
    "right foot",
    "left foot",
    "right hand",
    "left hand",
    "right upper arm",
    "right forearm",
    "left upper arm",
    "left forearm",
    "hitbox max"
}

function get_hitbox(hitbox)
    return hitboxes[hitbox]
end

function get_weapon(event_weapon)

    if event_weapon == "usp_silencer" then
        return "usp-s"
    elseif event_weapon == "m4a1_silencer" then
        return "m4a1-s"
    elseif event_weapon == "vlar" then
        return "armor"
    elseif event_weapon == "saultsuit" then
        return "helmet + armor"
    end

    return event_weapon

end

local misses = 0
local notify, notify_list = {}, {}

local lerp = function(a, b, percentage)return a + (b - a) * percentage;end
local get_screen_size = function() return screensizex, screensizey end

menu.add_slider_int( "Under-Crosshair Logs offset", 0, screensizey - 50 )
menu.next_line()
menu.add_slider_int( "                  -----Others----- ", 0, 0 )
menu.next_line()

menu.add_check_box("Info Bar")
menu.add_check_box( "Slowed Down Indicator" )
menu.add_check_box( "Sunset mode" )
menu.add_check_box("Fog Effect")
menu.add_color_picker("Fog Color")
menu.add_slider_int("Start Distance", 0, 2500)
menu.add_slider_int("End Distance", 0, 2500)
menu.add_slider_int("Density", 0, 100 )

local local_player = entitylist.get_local_player()
local infobarf = render.create_font("verdana", 14, 400, true, true, false)
local infobarftext = render.create_font("verdana", 11, 350, true, true, true)
--local screen_x, screen_y = engine.get_screen_width(), engine.get_screen_height()
local fpscolor = color.new(255, 255, 255)
local pingcolor = color.new(255, 255, 255)
local fps = 0


local function infobar()
    if not script_loaded then return end
    if not engine.is_in_game() then
        return
    end

    local local_player = entitylist.get_local_player()
    if local_player == nil then return end

    if menu.get_bool("Info Bar") then
        local PosX1 = screensizex
        local PosY1 = screensizey
        --local line_color3 = menu.get_color("color3")
        --local line_color3 = color.new(line_color3:r(), line_color3:g(), line_color3:b(), 255)
        local user = globals.get_username()
        local ping1 = tostring(globals.get_ping())
        local tickrate1 = math.floor(1.0 / globals.get_intervalpertick())
        local fps1 = math.floor(1 / globals.get_frametime())
        if globals.get_tickcount() % tickrate1 == 0 then
            fps = fps1
        end
        local velocity = local_player:get_velocity()
        local total_velocity = velocity:length_2d()
        local velocity_text = tostring("" .. math.floor(total_velocity) .. "")
        local pingpos = render.get_text_width( infobarf, ""..".00".."" ) - render.get_text_width( infobarf, ""..ping1.."" )
        local fpspos = render.get_text_width( infobarf, "".."000".."" ) - render.get_text_width( infobarf, ""..fps.."" )
        local velocitypos = render.get_text_width( infobarf, "".."000".."" ) - render.get_text_width( infobarf, velocity_text )
        if fps > 60 then
            fpscolor = color.new(180, 255, 0)
        elseif fps > 30 then
            fpscolor = color.new(255, 150, 0)
        else
            fpscolor = color.new(255, 0, 0)
        end
        local ping_r = math.floor(180 + ping1 / 189 * 30 * 3.42105263158)
        local ping_g = math.floor(255 - ping1 / 189 * 60 * 2.29824561404)
        local ping_b = math.floor(ping1 / 189 * 60 * 0.22807017543)
        if ping_r < 256 and ping_g < 256 and ping_b < 256 then
            pingcolor = color.new(ping_r, ping_g, ping_b)
        else pingcolor = color.new(255, 0, 0) end


        --render.draw_rect_filled(PosX1 /2 -270, PosY1 - 27, 550, 27, color.new(25, 25, 25, 100))
        GradientRect(PosX1 /2 -370, PosY1 - 27, 370, 27, color.new(0, 0, 0, 0), color.new(25, 25, 25, 100), true)
        GradientRect(PosX1 /2, PosY1 - 27, 370, 27, color.new(25, 25, 25, 100), color.new(0, 0, 0, 0), true)
        GradientRect(PosX1 /2 -370, PosY1 - 27, 370, 27, color.new(0, 0, 0, 0), color.new(25, 25, 25, 50), true)
        GradientRect(PosX1 /2, PosY1 - 27, 370, 27, color.new(25, 25, 25, 50), color.new(0, 0, 0, 0), true)
        render.draw_text(infobarf,PosX1 /2 -85 + fpspos, PosY1 - 21, fpscolor, ""..fps.."" )
        render.draw_text(infobarftext,PosX1 /2 -60, PosY1 - 17, color.new(255,255,255), "  FPS" )
        render.draw_text(infobarf,PosX1 /2 -205 + pingpos, PosY1 - 21, pingcolor, ""..ping1.."" )
        render.draw_text(infobarftext,PosX1 /2 -185, PosY1 - 17, color.new(255,255,255), "  PING" )
        render.draw_text(infobarf,PosX1 /2 + 40, PosY1 - 21, color.new(180, 255, 0), ""..tickrate1.."" )
        render.draw_text(infobarftext,PosX1 /2 + 55, PosY1 - 17, color.new(255,255,255), "  TICK" )
        render.draw_text(infobarf,PosX1 /2 + 145 + velocitypos, PosY1 - 21, color.new(255,255,255), velocity_text )
        render.draw_text(infobarftext,PosX1 /2 + 170, PosY1 - 17, color.new(255,255,255), "  SPEED" )


    end

end

local velocity_font = render.create_font( "tahoma", 11, 600, false, true )

local function rgb_health_based(percentage)
    local r = math.floor(124*2 - 124 * percentage)
    local g = math.floor(195 * percentage)
    local b = 13
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
    render.draw_rect(x, y, w, s, color.new(r, g, b, a)) -- top
    render.draw_rect(x, y+h-s, w, s, color.new(r, g, b, a)) -- bottom
    render.draw_rect(x, y+s, s, h-s*2, color.new(r, g, b, a)) -- left
    render.draw_rect(x+w-s, y+s, s, h-s*2, color.new(r, g, b, a)) -- right
end

local native_Surface_DrawSetTexture = ffi.cast(ffi.typeof("void(__thiscall*)(void*, int)"), g_VGuiSurface[0][38])
local native_Surface_DrawTexturedPolygon = ffi.cast(ffi.typeof("void(__thiscall*)(void*, int, Vertex_t*, bool)"), g_VGuiSurface[0][106])

local new_vert = ffi.typeof('Vertex_t[?]')
local new_vec2 = ffi.typeof('vec2_t')
local zerovec = new_vec2()
zerovec.x, zerovec.y = 0,0
draw_polygon = function(vertices, clipvertices, r, g, b, a)
    local a = a or 255
    local numvert = #vertices
    local buf = new_vert(numvert)
    local i = 0
    for k,v in pairs(vertices) do
        local vec = new_vec2()
        vec.x, vec.y = v.x, v.y
        buf[i].m_Position = vec
        buf[i].m_TexCoord = zerovec
        i = i + 1
    end
    native_Surface_DrawSetColor(g_VGuiSurface, r, g, b, a)
    native_Surface_DrawSetTexture(g_VGuiSurface, -1)
    native_Surface_DrawTexturedPolygon(g_VGuiSurface, numvert, buf, clipvertices)
end

vec2 = {}
vec2.new = function(x,y)
    return ffi.new(new_vec2, {x,y})
end

local lerp = function(a, b, t)
    return a + (b - a) * t
end

exclamanim = 0
exclamdirection = true

local function drawBar(modifier, r, g, b, a, text)
    local text_width = 95
    local sw = engine.get_screen_width()
    local sh = engine.get_screen_height()
    local x, y = sw/2-text_width, sh*0.35

    --if a > 0.7 then
    --    render.draw_rect(x+13, y+11, 8, 20, color.new(16, 16, 16, math.floor(255*a)))
    --end

    --render.draw_text(x+8, y+3, string.format("%s %.f", text, modifier * 100.0), color.new(255, 255, 255, 255*a))
    render.draw_text( velocity_font, x+8, y+5, color.new(255, 255, 255, math.floor(255*a)), string.format("%s %.f", text, modifier * 100.0).."%%" )

    local rx, ry, rw, rh = x+8, y+3+17, text_width, 9
    rectangle_outline(rx, ry, rw, rh, 0, 0, 0, math.floor(255*a), 1)
    render.draw_rect_filled(rx+1, ry+1, rw-2, rh-2, color.new(16, 16, 16, math.floor(180*a)))
    render.draw_rect_filled(rx+1, ry+1, math.floor((rw-2)*modifier), rh-2, color.new(r, g, b, math.floor(180*a)))
    vertices = {vec2.new(x-11, y+5), vec2.new(x-26, y+31), vec2.new(x+4, y+31)}
    draw_polygon(vertices, false, 0, 0, 0, math.floor(255 * a))
    vertices = {vec2.new(x-11, y+8), vec2.new(x-23, y+29), vec2.new(x+1, y+29)}
    draw_polygon(vertices, false, r, g, b, math.floor(255 * a))
    exclamanim = math.max(lerp(exclamanim, exclamdirection and 1 or 0, 3 * globals.get_frametime()), 0)
    if exclamanim > 0.95 then exclamdirection = false
    elseif exclamanim < 0.05 then exclamdirection = true end
    render.draw_rect_filled( x-12, y+14, 2, 8, color.new(0, 0, 0, math.floor(255 * exclamanim * a)) )
    render.draw_rect_filled( x-12, y+24, 2, 2, color.new(0, 0, 0, math.floor(255 * exclamanim * a)) )
end

local function velocitybar()

    local lp = entitylist.get_local_player()
    if lp == nil then return end
    lp = entitylist.entity_to_player(lp)
    if not (lp:get_health() > 0) then return end

    local modifier = lp:get_prop_float("CCSPlayer", "m_flVelocityModifier")
    --modifier = 0.81
    if modifier == 1 then return end

    local r, g, b = rgb_health_based(modifier)
    local a = remap(modifier, 1, 0, 0.85, 1)

    if menu.get_bool( "Slowed Down Indicator" ) then
        drawBar(modifier, r, g, b, a, "Slowed down")
    end
end

--client.add_callback("on_paint", infobar)
fogcucked = 0
local function fog()
    if not script_loaded then return end
    if menu.get_bool("Fog Effect") then
        if entitylist.get_local_player() ~= nil and globals.get_server_address() ~= nil then
            fog_color = menu.get_color("Fog Color")
            distance1 = menu.get_int("Start Distance")
            distance2 = menu.get_int("End Distance")
            density = menu.get_int("Density")
            if console.get_int( "fog_override" ) ~= 1 then
                console.set_int("fog_override", 1)   
            end
            if console.get_int( "fog_color" ) ~= string.format("%i %i %i", fog_color:r(), fog_color:g(), fog_color:b()) then
                console.set_string("fog_color", string.format("%i %i %i", fog_color:r(), fog_color:g(), fog_color:b()))
            end
            if console.get_int( "fog_start" ) ~= distance1 then
                console.set_int("fog_start" , distance1 )
            end
            if console.get_int( "fog_end" ) ~= distance2 then
                console.set_int("fog_end" , distance2 )
            end
            if console.get_float( "fog_maxdensity" ) ~= (density * 0.01) then
                console.set_float("fog_maxdensity" , density * 0.01 )
            end
            fogcucked = 1
        end
    elseif fogcucked == 1 then
        console.set_int("fog_override", 0)   
        console.set_int("fog_color", -1);
        console.set_int("fog_override", 0)
        console.set_int("fog_start", -1)
        console.set_int("fog_end", -1)
        console.set_float("fog_maxdensity", -1)
        fogcucked = 0
    end
end

local function fog_unload()
    console.set_int("fog_color", -1, -1, -1)
    console.set_int("fog_override", 0)
    console.set_int("fog_start", -1)
    console.set_int("fog_end", -1)
    console.set_float("fog_maxdensity", -1)
end

ffi.cdef[[
    typedef struct
    {
        float x,y,z;
    } Vector;
]]

local IClientEntityList = ffi.cast(ffi.typeof("void***"), utils.create_interface("client.dll", "VClientEntityList003"))
local GetHighestEntityIndex = ffi.cast(ffi.typeof("int(__thiscall*)(void*)"), IClientEntityList[0][6])
local GetClientEntity = ffi.cast(ffi.typeof("unsigned long(__thiscall*)(void*, int)"), IClientEntityList[0][3])

if not IClientEntityList or not GetHighestEntityIndex then return end

local entlist = {}

entlist.find_by_class = function(class)
    for i=64, GetHighestEntityIndex(IClientEntityList) do
        local ent = entitylist.get_player_by_index(i)
        
        if ent ~= nil then
            if ent:get_class_name() == class then
                return GetClientEntity(IClientEntityList, i)
            end
        end
    end
end

local typeof_tbl = {
    vector = ffi.typeof('Vector*')
}

local map = nil
sun_backup = {
    x = 0,
    y = 0,
    z = 0,
}

local function sunset()

    if not script_loaded then return end

    if not engine.is_in_game() then return end
    Cast_m_envLightShadowDirection = ffi.cast( typeof_tbl.vector, entlist.find_by_class('CCascadeLight') + 0x9e4)
    if map ~= engine.get_level_name() then
        map = engine.get_level_name()
        sun_backup = {
            x = Cast_m_envLightShadowDirection.x,
            y = Cast_m_envLightShadowDirection.y,
            z = Cast_m_envLightShadowDirection.z,
        }
    end   
    if menu.get_bool( "Sunset mode" ) then
        Cast_m_envLightShadowDirection.x = -0.5
        Cast_m_envLightShadowDirection.y = -1.0
        Cast_m_envLightShadowDirection.z = -0.3
    else
        Cast_m_envLightShadowDirection.x = sun_backup.x
        Cast_m_envLightShadowDirection.y = sun_backup.y
        Cast_m_envLightShadowDirection.z = sun_backup.z
    end
end

local function reset_sun()
    Cast_m_envLightShadowDirection.x = sun_backup.x
    Cast_m_envLightShadowDirection.y = sun_backup.y
    Cast_m_envLightShadowDirection.z = sun_backup.z
end

notify.run = function(text, ms, color) return table.insert(notify_list, 1, {text = text, ms = ms, alpha = 0, heightproc = 0, asx = -10, frametime = globals.get_frametime(), color = color}) end

local function resolver(shot_info)
    local shot_result = shot_info.result
    local shot_damage = shot_info.server_damage
    local client_hitbox = shot_info.client_hitbox
    local server_hitbox = shot_info.server_hitbox
    local shot_hitchance = shot_info.hitchance
	local player_info = engine.get_player_info
	local target = shot_info.target_index
	local target_name = player_info(target).name
    local hitchance = shot_info.hitchance
    local backtrack = shot_info.backtrack_ticks

    --if not menu.get_int( "Logs style" ) == 3 or menu.get_int( "Logs style" ) == 4 then return end

if shot_result == "Resolver" then
    misses = misses + 1
    notify.run("Missed shot due to resolver ("..client_hitbox..")", 7, {255, 0, 0})
elseif shot_result == "Occlusion" then
    notify.run("Missed "..target_name.." due to occlusion ("..client_hitbox..")", 7, {255, 0, 0})
elseif shot_result == "Spread" then
    notify.run("Missed "..target_name.." due to spread", 7, {255, 0, 0})
elseif shot_result == "None" then
    notify.run("Missed "..target_name.." due to death", 7, {255, 0, 0})
elseif shot_result == "Hit" then
    misses = misses + 1
    notify.run("Hit " .. target_name .." in the " .. server_hitbox .. " for " .. shot_damage .. " (hitchance: "..hitchance..")", 7)
end
end

--client.add_callback("on_shot", resolver)

notify.on_paint = function()

    if not script_loaded then return end

    local offset = menu.get_int( "Under-Crosshair Logs offset" )

    if not (#notify_list > 0) then return end

    local height_offset = 23
    
    local sx, sy = get_screen_size()
    sy = sy / 2 + 50 + offset
    logcol = menu.get_color( "Logs color" )
    --logcol = color.new(logcol:r(), logcol:g(), logcol:b(), 255)
    
    for c_name, c_data in pairs(notify_list) do
        c_data.ms = c_data.ms - globals.get_frametime()
        c_data.alpha = math.lerp(c_data.alpha, c_data.ms <= 0 and 0 or 1, globals.get_frametime() * 3)
        c_data.heightproc = math.lerp(c_data.heightproc, 1, globals.get_frametime() * 3)
        c_data.asx = math.lerp(c_data.asx, c_data.ms <= 0 and 10 or 0, globals.get_frametime() * 8)
        c_data.color = c_data.color == nil and {255, 255, 255} or c_data.color

        if not (math.floor(c_data.alpha * 255) > 0) then table.remove(notify_list) goto logskip end
        
        --logs_x = ((sx / 2) - (render.get_text_width(logfont, c_data.text) / 2)) + math.floor(120 * c_data.asx)
        if menu.get_int( "Logs style" ) == 4 then
            logs_x = ((sx / 2) - (render.get_text_width(logfont, c_data.text) / 2)) - render.get_text_width( logfont, "(iugenScript) " ) / 2
        else
            logs_x = ((sx / 2) - (render.get_text_width(logfont, c_data.text) / 2)) + math.floor(120 * c_data.asx)
        end
        if menu.get_int( "Logs style" ) == 3 then
            render.draw_text(logfont, logs_x, math.floor(sy + height_offset), color.new(logcol:r(), logcol:g(), logcol:b(), math.floor(c_data.alpha * 255)), c_data.text)
            height_offset = height_offset + 13 * c_data.heightproc
        elseif menu.get_int( "Logs style" ) == 4 then
            filledbox(logs_x - 6, math.floor(sy + height_offset) - 2, render.get_text_width( logfont, c_data.text ) + render.get_text_width( logfont, "(iugenScript) " ) + 12, 19, math.floor(c_data.alpha * 255))
            if menu.get_int( "Theme" ) == 1 then
                render.draw_text(logfont, logs_x, math.floor(sy + height_offset) + 3, color.new(logcol:r(), logcol:g(), logcol:b(), math.floor(c_data.alpha * 255)), "(iugenScript) ")
                render.draw_text(logfont, logs_x + render.get_text_width( logfont, "(iugenScript) " ), math.floor(sy + height_offset) + 3, color.new(255, 255, 255, math.floor(c_data.alpha * 255)), c_data.text)
            else
                render.draw_text(logfont, logs_x, math.floor(sy + height_offset) + 1, color.new(logcol:r(), logcol:g(), logcol:b(), math.floor(c_data.alpha * 255)), "(iugenScript) ")
                render.draw_text(logfont, logs_x + render.get_text_width( logfont, "(iugenScript) " ), math.floor(sy + height_offset) + 1, color.new(255, 255, 255, math.floor(c_data.alpha * 255)), c_data.text)
            end
            height_offset = height_offset + 27 * c_data.heightproc
        end
        ::logskip::
        --height_offset = height_offset + 13 * c_data.alpha
        --height_offset = height_offset + 13 * c_data.heightproc
    end
    

end

--client.add_callback("on_paint", notify.on_paint)

menu.next_line()
menu.add_slider_int("|    |    |    |    |    |    |    |    |    |    |    |    |    |    |       ", 0, 0)
menu.add_slider_int("                                Misc", 0, 0)
menu:next_line()

menu.add_combo_box( "Console filter", {"Disabled", "Full", "Partial"} )
menu.add_combo_box( "Clantag Mode", {"Disabled", "Terminal", "Typing", "Smooth", "Box", "GiPSYBLASTER", "SQUiD GAMES", "TRAP HOUSE MOB", "Balkansense", "AX WARRIOR", "AX animated", "Empty"} )
menu.add_combo_box( "Nickname exploits", {"None", "Hide nick", "Flip nick", "Replacer"} )
menu.add_check_box("Ragdoll gravity")
menu.add_slider_int("Gravity value", -200, 200)
menu.add_check_box( "Remove panorama blur" )
--menu.add_check_box( "Rainbow enemy chams" )
--menu.add_check_box( "Visible" )
--menu.add_color_picker( "Visible " )
--menu.add_check_box( "Invisible" )
--menu.add_color_picker( "Invisible " )
--menu.add_check_box( "Glow" )
--menu.add_color_picker( "Glow " )
--menu.add_check_box( "Party mode" )
--menu.add_color_picker( "Party mode " )
menu.next_line()

local function confilter()
    
    if not script_loaded then return end

    if console.get_int( "con_filter_enable" ) ~= menu.get_int( "Console filter" ) then
        console.execute( "con_filter_text iugenScript; con_filter_enable "..menu.get_int( "Console filter" ).."; clear" )
    end
end

ffi.cdef[[
    typedef int(__fastcall* clantag_t)(const char*, const char*);
]]
set_clantag = ffi.cast("clantag_t", utils.find_signature("engine.dll", "53 56 57 8B DA 8B F9 FF 15"))

clantagproc = false
local animation = {}

clantag0 = {
    "‎",
}

clantag1 = {
    "  ",
    "_",
    "  ",
    "_",
    "  ",
    "_",
    "i_",
    "iu_",
    "iug_",
    "iuge_",
    "iugen_",
    "iugenS_",
    "iugenSc_",
    "iugenScr_",
    "iugenScri_",
    "iugenScrip_",
    "iugenScript ",
    "iugenScript_",
    "iugenScript ",
    "iugenScript_",
    "iugenScript ",
    "iugenScrip_",
    "iugenScri_",
    "iugenScr_",
    "iugenSc_",
    "iugenS_",
    "iugen_",
    "iuge_",
    "iug_",
    "iu_",
    "i_",
    "  ",
    "_",
    "  ",
}

clantag2 = {
    "  ",
    "|",
    "  ",
    "|",
    "  ",
    "|",
    "i|",
    "iu|",
    "iug|",
    "iuge|",
    "iugen|",
    "iugenS|",
    "iugenSc|",
    "iugenScr|",
    "iugenScri|",
    "iugenScrip|",
    "iugenScript ",
    "iugenScript|",
    "iugenScript ",
    "iugenScript|",
    "iugenScript ",
    "iugenScrip|",
    "iugenScri|",
    "iugenScr|",
    "iugenSc|",
    "iugenS|",
    "iugen|",
    "iuge|",
    "iug|",
    "iu|",
    "i|",
    "  ",
    "|",
    "  ",
}

clantag3 = {
    " ",
    "i",
    "iu",
    "iug",
    "iuge",
    "iugen",
    "iugenS",
    "iugenSc",
    "iugenScr",
    "iugenScri",
    "iugenScrip",
    "iugenScript",
    "iugenScript",
    "iugenScript",
    "iugenScript",
    "iugenScript",
    "ugenScript",
    "genScript",
    "enScript",
    "nScript",
    "Script",
    "cript",
    "ript",
    "ipt",
    "pt",
    "t",
    " ",
}

clantag4 = {
    "[=============]",
    "[t============]",
    "[pt===========]",
    "[ipt==========]",
    "[ript=========]",
    "[cript========]",
    "[Script=======]",
    "[nScript======]",
    "[enScript=====]",
    "[genScript====]",
    "[ugenScript===]",
    "[iugenScript==]",
    "[=iugenScript=]",
    "[==iugenScript]",
    "[====iugenScri]",
    "[=====iugenScr]",
    "[======iugenSc]",
    "[=======iugenS]",
    "[========iugen]",
    "[=========iuge]",
    "[==========iug]",
    "[===========iu]",
    "[============i]",
}

clantag5 = {
    " ",
    "G",
    "Gi",
    "GiP",
    "GiPS",
    "GiPSY",
    "GiPSYB",
    "GiPSYBL",
    "GiPSYBLA",
    "GiPSYBLAS",
    "GiPSYBLAST",
    "GiPSYBLASTE",
    "GiPSYBLASTER",
    "GiPSYBLASTER",
    "GiPSYBLASTER",
    "GiPSYBLASTER",
    "GiPSYBLASTER",
    "GiPSYBLASTER",
    "iPSYBLASTER",
    "PSYBLASTER",
    "SYBLASTER",
    "YBLASTER",
    "BLASTER",
    "ASTER",
    "STER",
    "TER",
    "ER",
    "R",
    " ",
}

clantag6 = {
    " ",
    "S",
    "SQ",
    "SQU",
    "SQUiD",
    "SQUiD ",
    "SQUiD G",
    "SQUiD GA",
    "SQUiD GAM",
    "SQUiD GAME",
    "SQUiD GAMES",
    "SQUiD GAMES？",
    "SQUiD GAMES？？",
    "SQUiD GAMES？？",
    "SQUiD GAMES？？",
    "SQUiD GAMES？？",
    "SQUiD GAMES？？",
    "QUiD GAMES？？",
    "UiD GAMES？？",
    "iD GAMES？？",
    "D GAMES？？",
    " GAMES？？",
    "GAMES？？",
    "AMES？？",
    "MES？？",
    "ES？？",
    "S？？",
    "？？",
    "？",
    " ",
}

clantag7 = {
    " ",
    "T",
    "TR",
    "TRA",
    "TRAP",
    "TRAP ",
    "TRAP H",
    "TRAP HO",
    "TRAP HOU",
    "TRAP HOUS",
    "TRAP HOUSE",
    "TRAP HOUSE ",
    "TRAP HOUSE M",
    "TRAP HOUSE MO",
    "TRAP HOUSE MOB",
    "TRAP HOUSE MOB",
    "TRAP HOUSE MOB",
    "TRAP HOUSE MOB",
    "TRAP HOUSE MOB",
    "RAP HOUSE MOB",
    "AP HOUSE MOB",
    "P HOUSE MOB",
    " HOUSE MOB",
    "HOUSE MOB",
    "OUSE MOB",
    "USE MOB",
    "SE MOB",
    "E MOB",
    " MOB",
    "MOB",
    "OB",
    "B",
    " ",
}

clantag8 = {
    " ",
    "B",
    "Ba",
    "Bal",
    "Balk",
    "Balka",
    "Balkan",
    "Balkans",
    "Balkanse",
    "Balkansen",
    "Balkansens",
    "Balkansense",
    "Balkansense",
    "Balkansense",
    "Balkansense",
    "Balkansense",
    "alkansense",
    "lkansense",
    "kansense",
    "ansense",
    "nsense",
    "sense",
    "ense",
    "nse",
    "se",
    "e",
    " ",
}

clantag9 = {
    "☠ AX WARRIOR",
}

clantag10 = {
    "☠ ",
    "☠ A",
    "☠ AX",
    "☠ AX ",
    "☠ AX W",
    "☠ AX WA",
    "☠ AX WAR",
    "☠ AX WARR",
    "☠ AX WARRI",
    "☠ AX WARRIO",
    "☠ AX WARRIOR",
    "☠ AX WARRIOR",
    "☠ AX WARRIOR",
    "☠ AX WARRIOR",
    "☠ AX WARRIOR",
    "☠ X WARRIOR",
    "☠  WARRIOR",
    "☠ WARRIOR",
    "☠ ARRIOR",
    "☠ RRIOR",
    "☠ RIOR",
    "☠ IOR",
    "☠ OR",
    "☠ R",
    "☠ ",
}

local animation2 = {
  "   ",
}

old_time = 0

local function clantag()

    if not script_loaded then return end
    if engine.is_in_game() then
        if menu.get_int( "Clantag Mode" ) ~= 0 then
            if menu.get_int( "Clantag Mode" ) == 1 then
                animation = clantag1
            elseif menu.get_int( "Clantag Mode" ) == 2 then
                animation = clantag2
            elseif menu.get_int( "Clantag Mode" ) == 3 then
                animation = clantag3
            elseif menu.get_int( "Clantag Mode" ) == 4 then
                animation = clantag4
            elseif menu.get_int( "Clantag Mode" ) == 5 then
                animation = clantag5
            elseif menu.get_int( "Clantag Mode" ) == 6 then
                animation = clantag6
            elseif menu.get_int( "Clantag Mode" ) == 7 then
                animation = clantag7
            elseif menu.get_int( "Clantag Mode" ) == 8 then
                animation = clantag8
            elseif menu.get_int( "Clantag Mode" ) == 9 then
                animation = clantag9
            elseif menu.get_int( "Clantag Mode" ) == 10 then
                animation = clantag10
            elseif menu.get_int( "Clantag Mode" ) == 11 then
                animation = clantag0
            end
            local curtime = math.floor(globals.get_curtime()*3)
            if old_time ~= curtime then
                if menu.get_int( "Nickname exploits" ) == 0 then
                    set_clantag(animation[curtime % #animation+1], animation[curtime % #animation+1])
                elseif menu.get_int( "Nickname exploits" ) == 1 then
                    set_clantag(animation[curtime % #animation+1].."\n", animation[curtime % #animation+1].."\n")
                elseif menu.get_int( "Nickname exploits" ) == 2 then
                    set_clantag(animation[curtime % #animation+1].." ".."‮", animation[curtime % #animation+1].." ".."‮")
                elseif menu.get_int( "Nickname exploits" ) == 3 then
                    set_clantag("‮"..string.reverse(animation[curtime % #animation+1]), "‮"..string.reverse(animation[curtime % #animation+1]))
                end
            end
            old_time = curtime
            clantagproc = true
        else
            if clantagproc then
                set_clantag(animation2[1], animation2[1])
            end
            clantagproc = false
        end
    end

end

local function clantag_unload()
    set_clantag(animation2[1], animation2[1])
end

local function gravity()
    if not script_loaded then return end
    if menu.get_bool("Ragdoll gravity") then
        local gravity = menu.get_int("Gravity value")
        if gravity ~= console.get_int("cl_ragdoll_gravity") then
            console.set_int("cl_ragdoll_gravity", gravity * 10)
        end
    end
end

local function removeblur()
    if not script_loaded then return end
    if menu.get_bool("Remove panorama blur") then
        console.set_string( "@panorama_disable_blur", "1" )
    elseif console.get_string( "@panorama_disable_blur") == "1" then
        console.set_string( "@panorama_disable_blur", "0" )
    end
end

local path, index, files = "./csgo/sound", 2, {"game folder/csgo/sound:"}
ffi.C.CreateDirectoryA(path, nil)
for line in io.popen("dir \"" .. path .. "\" /a /b", "r"):lines() do
    if string.find(line, ".wav") then
        current_file = line:match("[^/]*.wav$")
        files[index] = current_file:sub(0, #current_file - 4)
        index = index + 1
    end
end
if #files == 0 then
    client.log("no sounds were found.");
    return
end
menu.add_check_box("Enable Hitsound")
menu.add_combo_box("Hitsound", files)
menu.add_check_box("Enable Killsound")
menu.add_combo_box("Killsound", files)
menu.add_combo_box( "Killsay", {"Disabled", "Acatel but better", "Squid Games.lua"} )
chinese_killsay = {"黑科技.lua IUGENSCRIPT BOTOSANI 可以吃的吗？？？ GAME HACK LEGENDARY 好用的吗？？ 100% HACK 黑科技.lua IUGENSCRIPT。ROMENIA!!!! 的科技", "WOW IUGENSCRIPT .。ROMENIA 的科技 (TECHNOLOGY) ？", "ANGRY ？ GET GOOD GET IUGENSCRIPT。RUMANIA 的科技 @ eugen#6647"}
bingiling_killsay = {"SQUID GAMES LUA ？？ 我没有太多的时间请帮我， 我再说一遍， 请帮我， 我是认真的， 我已经被中国政府抓获了， 请帮我， 我的球不见了， 我像狗一样被割伤了 ！！！SQUIDGAME.JS  ！！", "POWERED BY 鱿鱼游戏.lua ！！鱿鱼游戏.lua ？？？ SQUIDGAME LUA ！！！快， 他们走了， 你必须来快， 我觉得结束是接近第一我的球旁边我的阴茎， 最后我的生活", "SQUID GAME ! ! ! #速度与激情9# 早上好中国 现在我有冰激淋 我很喜欢冰激淋 IUGENSCRIPT X SQUIDGAME ? ? ? 他们走了， 你必须来快， 我觉得结束是接近第一我的球旁边我的阴茎， 最后我的生活 :c"}
menu.add_slider_float( "Healthshot effect duration", 0, 1.5 )
menu.add_slider_int( "Clash Royale FX", 0, 0 )
menu.add_check_box("Heheheha on kill")
menu.add_check_box( "Victory theme on win" )
menu.add_check_box("Force stop")

ffi.cdef[[
	int CopyFileA(const char* lpExistingFileName, const char* lpNewFileName, int bFailIfExists);
]]

voice_inputfromfile = console.get_int("voice_inputfromfile")
voice_loopback = console.get_int("voice_loopback")

estimated_end_time = -1

killsay = 0
heheheha_on_kill = false
victory_theme = false
health_duration = 0

local function estimate_length(filename)
	local file = io.open(filename)
	local estimated_time = file:seek("end") / 44100
	file:close()
	return estimated_time
end

local function replace_file(with, at)
	ffi.C.CopyFileA(with, at, 0)
end

local function play_file(filename)
	replace_file(filename, "voice_input.wav")
	console.set_int("voice_inputfromfile", 1)
	console.execute("+voicerecord")
	console.set_int("voice_loopback", 1)
	estimated_end_time = globals.get_curtime() + estimate_length("voice_input.wav")
end

local function on_paint()
    if not script_loaded then return end
    if menu.get_bool( "Enable Hitsound" ) then
        local sound = files[menu.get_int("Hitsound")+1]
    end
    if menu.get_bool( "Enable Killsound" ) then
        local killsound = files[menu.get_int("Killsound")+1]
    end
end

local function hurt(event)
    if not script_loaded then return end
	
	local player = engine.get_local_player_index()
    local sac = engine.get_player_for_user_id(event:get_int("attacker"))
    local sound = files[menu.get_int("Hitsound")+1]

    if hitsound_enabled and sac == player then
        console.execute("play "..sound)
    end
end

local function death(event)
    if not script_loaded then return end
	
	local player = engine.get_local_player_index()
    local sac = engine.get_player_for_user_id(event:get_int("attacker"))
    local killsound = files[menu.get_int("Killsound")+1]

    if killsound_enabled and sac == player then
        console.execute("play "..killsound)
    end

    if killsay == 1 and sac == player then
        i = math.random(1, 3)
        console.execute( "say "..chinese_killsay[i] )
    elseif killsay == 2 and sac == player then
        i = math.random(1, 3)
        console.execute( "say "..bingiling_killsay[i] )
    end

    if heheheha_on_kill and sac == player then
        play_file("C:/iugenScript/heheheha.wav")
    end

    if health_duration > 0 and sac == player then
        local localplayer = entitylist.get_local_player()
        if not localplayer then return end
        curtime = globals.get_curtime()
        localplayer:set_prop_float("CCSPlayer", "m_flHealthShotBoostExpirationTime", curtime+health_duration)
    end
end

local function win(event)
    if not script_loaded then return end
    local player = engine.get_local_player_index()
    local team = entitylist.get_local_player():get_team()
    local sac = engine.get_player_for_user_id(event:get_int("winner"))
    local winnerteam = event:get_int("winner")
    --client.log( "WINNER proc WINNER proc WINNER proc WOW IUGENSCRIPT SO GOOD!!!" )

    if victory_theme and (sac == player or team == winnerteam) then
        play_file("C:/iugenScript/clash_mvp.wav")
    end
end

--events.register_event( "round_end", win )

local function heheheha_end()
    if not script_loaded then return end
    killsay = menu.get_int( "Killsay" )
    heheheha_on_kill = menu.get_bool("Heheheha on kill")
    victory_theme = menu.get_bool("Victory theme on win")
    health_duration = menu.get_float( "Healthshot effect duration" )
    hitsound_enabled = menu.get_bool("Enable Hitsound")
    killsound_enabled = menu.get_bool("Enable Killsound")
	if menu.get_bool("Force stop") == true then
		estimated_end_time = 0
	end
	if estimated_end_time ~= -1 and globals.get_curtime() > estimated_end_time then
		console.set_int("voice_inputfromfile", 0)
        console.execute("-voicerecord")
        console.set_int("voice_inputfromfile", 0)
		os.remove("./voice_input.wav")
		console.set_int("voice_loopback", 0)
		estimated_end_time = -1
	end
end
local function stop_heheheha()
    if not script_loaded then return end
    console.set_int("voice_inputfromfile", 0)
    console.execute("-voicerecord")
    console.set_int("voice_inputfromfile", 0)
	os.remove("./voice_input.wav")
	console.set_int("voice_loopback", 0)
	estimated_end_time = -1
end
--client.add_callback( "unload", stop_heheheha )
--client.add_callback( "on_paint", heheheha_end )

--[[local chamsbak01 = menu.get_color( "visuals.enemy.chams_clr_visible" )
local chamsbak02 = menu.get_color( "visuals.enemy.chams_clr_invisible" )
local chamsbak03 = menu.get_color( "visuals.enemy.glow_clr" )
local chamsbak04 = menu.get_color( "visuals.world.world_color_modulate.world_clr" )
local forcechams01 = 0
local forcechams02 = 0
local forcechams03 = 0
local forcechams04 = 0

local function rgbchams()
    rainbowvalue = rainbowvalue + (globals.get_frametime() * 0.1)
    if rainbowvalue > 1.0 then 
        rainbowvalue = 0.0
    end
    local rgbchams = hsv2rgb(rainbowvalue, 1, 1, 1)
    local visible = menu.get_color( "Visible " )
    local invisible = menu.get_color( "Invisible " )
    local glow = menu.get_color( "Glow " )
    local world = menu.get_color( "Party mode " )
    if menu.get_bool( "Rainbow enemy chams" ) then
        if forcechams01 == 0 then
            chamsbak01 = menu.get_color( "visuals.enemy.chams_clr_visible" )
        end
        if forcechams02 == 0 then
            chamsbak02 = menu.get_color( "visuals.enemy.chams_clr_invisible" )
        end
        if forcechams03 == 0 then
            chamsbak01 = menu.get_color( "visuals.enemy.glow_clr" )
        end
        
        if menu.get_bool( "Visible" ) then
            forcechams01 = 1
            menu.set_color( "visuals.enemy.chams_clr_visible", color.new(rgbchams:r(), rgbchams:g(), rgbchams:b(), visible:a()) )
        elseif forcechams01 == 1 then
            menu.set_color( "visuals.enemy.chams_clr_visible", chamsbak01 )
            forcechams01 = 0
        end

        if menu.get_bool( "Invisible" ) then
            forcechams02 = 1
            menu.set_color( "visuals.enemy.chams_clr_invisible", color.new(rgbchams:r(), rgbchams:g(), rgbchams:b(), invisible:a()) )
        elseif forcechams02 == 1 then
            menu.set_color( "visuals.enemy.chams_clr_invisible", chamsbak02 )
            forcechams02 = 0
        end

        if menu.get_bool( "Glow" ) then
            menu.set_color( "visuals.enemy.glow_clr", color.new(rgbchams:r(), rgbchams:g(), rgbchams:b(), glow:a()) )
        elseif forcechams03 == 1 then
            menu.set_color( "visuals.enemy.glow_clr", chamsbak03 )
            forcechams03 = 0
        end
    else
        if forcechams01 == 1 then
            menu.set_color( "visuals.enemy.chams_clr_visible", chamsbak01 )
            forcechams01 = 0
        end
        if forcechams02 == 1 then
            menu.set_color( "visuals.enemy.chams_clr_invisible", chamsbak02 )
            forcechams02 = 0
        end
        if forcechams03 == 1 then
            menu.set_color( "visuals.enemy.glow_clr", chamsbak03 )
            forcechams03 = 0
        end
    end

    if forcechams04 == 0 then
        chamsbak04 = menu.get_color( "visuals.world.world_color_modulate.world_clr" )
    end
    
    if menu.get_bool( "Party mode" ) then
        menu.set_color( "visuals.world.world_color_modulate.world_clr", color.new(rgbchams:r(), rgbchams:g(), rgbchams:b(), world:a()) )
    elseif forcechams04 == 1 then
        menu.set_color( "visuals.world.world_color_modulate.world_clr", chamsbak04 )
        forcechams04 = 0
    end
end
]]

menu.add_slider_int("  ", 0, 0)
menu.next_line()

local function unload()
    arrows_alpha = 0
    if force_dt == 1 and not dt then
        menu.set_int("rage.double_tap_key", 0)
    end
    menu.set_bool("anti_aim.enable_fake_lag", fl)
    script_loaded = false
    --menu.set_int( "AA Indicators style", 0 )
    --menu.set_color( "Accent color", 0 )
    --menu.set_color( "Desync indicator color", 0 )
    --menu.set_color( "Arrow color", 0 )
    --menu.set_color( "Background color", 0 )
    --menu.set_color( "Accent color", 0 )
    file.write( "C:/iugenScript/keybind_pos.txt", tostring(pos_x).." "..tostring(pos_y) )
    file.write( "C:/iugenScript/spectator_pos.txt", tostring(spec_pos_x).." "..tostring(spec_pos_y) )
    --console.execute( "clear" )
    --console_print(engine_cvar, console_blue, "iugenScript unloaded!")
    return
end

menu.add_check_box( "Safely unload script" )
client.add_callback( "on_paint", function()
if not script_loaded then return end
if menu.get_bool( "Safely unload script" ) then
    script_loaded = false
    menu.set_bool( "Safely unload script", false )
    client.unload_script( string.sub(filepath, position_end+1) )
end
end)

--client.add_callback( "unload", unload )
--client.add_callback( "on_paint", on_paint )
--client.add_callback("create_move", gravity )
--client.add_callback("on_paint", removeblur )

--menu.add_check_box( "INTRO" )
--menu.add_check_box( "AA DEBUG" )
--menu.add_check_box( "RAGE DEBUG" )
--menu.add_check_box( "VISUALS DEBUG" )
--menu.add_check_box( "font select" )
--menu.add_check_box( "resize" )
--menu.add_check_box( "spec" )
--menu.add_check_box( "indicators" )
--menu.add_check_box( "logs info fog" )
--menu.add_check_box( "MISC DEBUG" )

client.add_callback( "unload", function()
    fog_unload()
    clantag_unload()
    stop_heheheha()
    reset_sun()
    console.execute( "con_filter_enable 0" )
    unload()
end)
--client.add_callback( "create_move", aa)
client.add_callback( "create_move", function(cmd)
    if not script_loaded then return end
    --if menu.get_bool( "AA DEBUG" ) then
        --aa(cmd)
        aa(cmd)
        antios()
    --end
    telepeek()
    sunset()
    gravity()
end)
client.add_callback( "on_shot", logs_text)
client.add_callback( "on_shot", resolver)

menu_funnies = {
    "send Cookie52#7070 your feet pics",
    "message Poe#8165 for free robux",
    "spam ogif#0001 for win on hvh",
    "\"ugenscript x amogus soontm\" - ogif",
    "Romanian hvh technology activated ◣_◢",
    "Making gipsies miss desync since 2021",
    "HvH boss detected, have many win in hvh ⸨◺_◿⸩",
    "You're mega sexy for using this",
    "Have a beautiful day!",
    "tag 5 friends in the comments section",
    "Thanks for choosing the sexiest script on the market!",
}

funny_string = ""
string_chance = math.random(0, 100)
string_index = math.random(1, #menu_funnies)
menu_state = menu.get_visible()

menudecor = function()
    if not script_loaded then return end
    local alpha = 255
    local pos = menu.get_position()
    local size = menu.get_size()
    if menu.get_visible() then
        menu_state = true
    elseif menu_state and not menu.get_visible() then
        string_chance = math.random(0, 100)
        string_index = math.random(1, #menu_funnies)
        menu_state = false
    end
    if string_chance > 95 then
        funny_string = " "..menu_funnies[string_index]
    else
        funny_string = " Last update: "..last_update
    end
    local beta_text = beta and " beta" or ""
    local text = " v"..string.format("%.2f",version)..beta_text.." loaded!"..funny_string
    local textsize = render.get_text_width( verdana, text ) + 12
    local iugenscriptlength = render.get_text_width( verdana, "iugenScript" )
    local iugenlength = render.get_text_width( verdana, "iugen" )
    local scriptlength = render.get_text_width( verdana, "Script" )
    local textsize = iugenscriptlength + render.get_text_width( verdana, text ) + 12
    size.x = (menu.get_int( "Theme" ) == 5 or menu.get_int( "Theme" ) == 6) and size.x - 2 or size.x
    local acc = menu.get_color( "Accent color" )
    local scriptcol = color.new(acc:r(), acc:g(), acc:b(), alpha)
    if menu.get_visible() then
        filledbox(pos.x + (size.x - textsize), pos.y + size.y + 6, textsize, 19, alpha)
        render.draw_text( verdana, pos.x + (size.x - textsize) + 6, pos.y + size.y + 9, color.new(255, 255, 255, alpha), "iugen" )
        render.draw_text( verdana, pos.x + (size.x - textsize) + iugenlength + 6, pos.y + size.y + 9, scriptcol, "Script" )
        render.draw_text( verdana, pos.x + (size.x - textsize) + iugenscriptlength + 6, pos.y + size.y + 9, color.new(255, 255, 255, alpha), text )
    end
end

client.add_callback( "on_paint", function()
    if not script_loaded then return end
    --First load
    intro()
    --AA
    --if menu.get_bool( "AA DEBUG" ) then
    flprocer()
    legitaabackup()
    kniferoundbackup()
    --end
    --Rage
    --if menu.get_bool( "RAGE DEBUG" ) then
    ax()
    baim()
    jumpscout()
    --end
    --Visuals
    --if menu.get_bool( "VISUALS DEBUG" ) then
    --if menu.get_bool( "font select" ) then
    font_big_select()
    font_select()
    --end
    --if menu.get_bool( "resize" ) then
    resize()
    --end
    --if menu.get_bool( "spec" ) then
    get_spectating_players()
    paintspec()
    --end
    --if menu.get_bool( "indicators" ) then
    gunpaint()
    holopanel()
    indicator()
    Arrows()
    watermark()
    keybinds()
    --end
    --if menu.get_bool( "logs info fog" ) then
    nllogs()
    infobar()
    velocitybar()
    fog()
    notify.on_paint()
    --end
    --end
    --Misc
    --if menu.get_bool( "MISC DEBUG" ) then
    confilter()
    clantag()
    heheheha_end()
    on_paint()
    removeblur()
    menudecor()
    --end
end)

events.register_event("weapon_fire", function(event)

    if not script_loaded then return end

    local localplayer = entitylist.get_local_player()
    if not localplayer then return end
    local attacker = engine.get_player_for_user_id(event:get_int("userid"))
    if attacker == localplayer:get_index() and force_dt == 0 then
        onshot_active = 1
    end

    antios_starter(event)
end)
events.register_event( "round_end", win )
events.register_event("player_hurt", hurt)
events.register_event( "player_death", death )

--client.add_callback("on_paint", rgbchams )