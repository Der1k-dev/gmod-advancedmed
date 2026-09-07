-- addons/advanced_medicine/lua/medsystem/core/sv_actions.lua
AddCSLuaFile()

net.Receive("AdvMed_UseItem", function(len, ply)
    if not IsValid(ply) or not ply:Alive() then return end

    local target = net.ReadEntity()
    local action = net.ReadString()

    if not IsValid(target) or not target:IsPlayer() then return end
    if ply:GetPos():DistToSqr(target:GetPos()) > 10000 then return end
    if not target.MedData then target:InitMedData() end

    if action == "tourniquet" then
        local hasBleeding = false
        for hitgroup, wounds in pairs(target.MedData.Wounds) do
            for i, wType in ipairs(wounds) do
                if wType == AdvMed.WOUND_BLEEDING then
                    table.remove(target.MedData.Wounds[hitgroup], i)
                    hasBleeding = true
                    break
                end
            end
            if hasBleeding then break end
        end

        if hasBleeding then
            ply:EmitSound("items/medshot4.wav")
            target:ChatPrint("[Медицина] Накладено турнікет, кровотечу зупинено.")
        else
            ply:ChatPrint("[Медицина] У пацієнта немає активних кровотеч.")
        end
    elseif action == "bandage" then
        target.MedData.Pain = math.Clamp(target.MedData.Pain - 15, 0, 100)
        ply:EmitSound("items/medshotno1.wav")
        target:ChatPrint("[Медицина] Рани перев'язано.")
    elseif action == "morphine" then
        target.MedData.Pain = 0
        ply:EmitSound("player/pl_pain7.wav")
        target:ChatPrint("[Медицина] Введено морфін.")
    elseif action == "cpr" then
        if target.MedData.InComa then
            ply:EmitSound("weapons/medkit/medkit_success.wav")
            target:ChatPrint("[Медицина] Проводиться СЛР...")
        end
    end
end)