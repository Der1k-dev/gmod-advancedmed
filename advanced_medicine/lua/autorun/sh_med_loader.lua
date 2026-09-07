-- addons/advanced_medicine/lua/autorun/sh_med_loader.lua
AddCSLuaFile()

AdvMed = AdvMed or {}

local function IncludeFiles(folder)
    local files, folders = file.Find(folder .. "/*", "LUA")
    for _, v in ipairs(files) do
        if string.StartWith(v, "sh_") or string.StartWith(v, "cl_") or string.StartWith(v, "sv_") then
            if SERVER then
                if string.StartWith(v, "sh_") or string.StartWith(v, "cl_") then
                    AddCSLuaFile(folder .. "/" .. v)
                end
                if string.StartWith(v, "sh_") or string.StartWith(v, "sv_") then
                    include(folder .. "/" .. v)
                end
            else
                if string.StartWith(v, "sh_") or string.StartWith(v, "cl_") then
                    include(folder .. "/" .. v)
                end
            end
        end
    end
    
    for _, dir in ipairs(folders) do
        IncludeFiles(folder .. "/" .. dir)
    end
end

IncludeFiles("medsystem")