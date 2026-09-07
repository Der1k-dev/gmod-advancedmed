-- addons/advanced_medicine/lua/medsystem/core/sh_stimulants.lua
AddCSLuaFile()

AdvMed.StimulantsRegistry = {
    ["adrenaline"] = {
        name = "Адреналін",
        duration = 30,
        description = "Тимчасово знімає біль, підвищує фокус.",
        onApply = function(ply)
            if SERVER then
                ply:EmitSound("items/medshot4.wav")
                if ply.MedData then ply.MedData.Pain = 0 end
            end
        end,
        onExpire = function(ply)
            if SERVER then
                ply:ChatPrint("[Ефект] Дія адреналіну закінчилася. Втома.")
                if ply.MedData then ply.MedData.Pain = math.Clamp(ply.MedData.Pain + 20, 0, 100) end
            end
        end
    },
    ["combat_stim"] = {
        name = "Бойовий стимулятор 'Спартанець'",
        duration = 45,
        description = "Стабілізація в бою, вихід з коми на час дії.",
        onApply = function(ply)
            if SERVER then
                ply:EmitSound("weapons/physcannon/energy_singularity_cue.wav")
                if ply.MedData and ply.MedData.InComa then ply:ReviveFromComa() end
            end
        end,
        onExpire = function(ply)
            if SERVER then ply:ChatPrint("[Ефект] Стимулятор 'Спартанець' вивітрився.") end
        end
    }
}

for id, data in pairs(AdvMed.StimulantsRegistry) do
    AdvMed.ItemsRegistry[id] = { name = data.name, weight = 0.15, maxStack = 5 }
end