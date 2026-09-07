-- addons/advanced_medicine/lua/medsystem/core/sv_bleeding.lua
AddCSLuaFile()

timer.Create("AdvMed_GlobalProcessingTimer", 1, 0, function()
    for _, ply in ipairs(player.GetAll()) do
        if not IsValid(ply) or not ply:Alive() then continue end
        if not ply.MedData then ply:InitMedData() end

        local totalBleed = 0
        for hitgroup, wounds in pairs(ply.MedData.Wounds) do
            for _, woundType in ipairs(wounds) do
                if woundType == AdvMed.WOUND_BLEEDING then
                    totalBleed = totalBleed + (AdvMed.Config.BleedRates[hitgroup] or 10)
                end
            end
        end

        if totalBleed > 0 then
            ply.MedData.Blood = math.Clamp(ply.MedData.Blood - totalBleed, 0, AdvMed.Config.MaxBlood)
        end

        if ply.MedData.Blood <= AdvMed.Config.ComaBloodLevel and not ply.MedData.InComa then
            ply:EnterComa()
        end

        if ply.MedData.Blood <= AdvMed.Config.DeathBloodLevel and not ply.MedData.InComa then
            ply:Kill()
        end
    end
end)

local plyMeta = FindMetaTable("Player")

function plyMeta:EnterComa()
    if self.MedData.InComa then return end
    self.MedData.InComa = true
    self:Freeze(true)
    self:ChatPrint("[Медицина] Ви втратили свідомість від крововтрати!")
end

function plyMeta:ReviveFromComa()
    if not self.MedData.InComa then return end
    self.MedData.Blood = AdvMed.Config.ComaBloodLevel + 500
    self.MedData.InComa = false
    self:Freeze(false)
    self:ChatPrint("[Медицина] Вас успішно реанімували!")
end