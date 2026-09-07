-- addons/advanced_medicine/lua/medsystem/core/sv_stimulants.lua
AddCSLuaFile()

local plyMeta = FindMetaTable("Player")

function plyMeta:ApplyStimulant(stimID)
    local stimData = AdvMed.StimulantsRegistry[stimID]
    if not stimData then return end

    stimData.onApply(self)

    net.Start("AdvMed_SyncStimulant")
        net.WriteString(stimID)
        net.WriteFloat(CurTime() + stimData.duration)
    net.Send(self)

    timer.Create("AdvMed_Stim_" .. self:SteamID64(), stimData.duration, 1, function()
        if IsValid(self) then stimData.onExpire(self) end
    end)
end

net.Receive("AdvMed_UseStimulant", function(len, ply)
    if not IsValid(ply) or not ply:Alive() then return end
    local stimID = net.ReadString()
    if not AdvMed.StimulantsRegistry[stimID] then return end

    if not ply.MedBag then ply:InitMedBag() end
    local hasItem = false
    for _, item in ipairs(ply.MedBag.Items) do
        if item.id == stimID and item.count > 0 then
            item.count = item.count - 1
            hasItem = true
            break
        end
    end

    if hasItem then
        ply:UpdateBagWeight()
        ply:SyncMedBag()
        ply:ApplyStimulant(stimID)
        ply:ChatPrint("[Медицина] Використано стимулятор: " .. AdvMed.StimulantsRegistry[stimID].name)
    else
        ply:ChatPrint("[Медицина] Предмет відсутній у сумці!")
    end
end)