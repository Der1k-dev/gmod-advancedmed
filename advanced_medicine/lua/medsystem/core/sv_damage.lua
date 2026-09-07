-- addons/advanced_medicine/lua/medsystem/core/sv_damage.lua
AddCSLuaFile()

hook.Add("ScalePlayerDamage", "AdvMed_DamageProcessor", function(ply, hitgroup, dmginfo)
    if not ply.MedData then ply:InitMedData() end
    if ply.MedData.InComa then return true end

    local dmgType = dmginfo:GetDamageType()
    local dmgAmount = dmginfo:GetDamage()

    if bit.band(dmgType, DMG_BULLET) ~= 0 or bit.band(dmgType, DMG_SLASH) ~= 0 then
        ply:AddWound(hitgroup, AdvMed.WOUND_BLEEDING)
    end

    if bit.band(dmgType, DMG_FALL) ~= 0 or bit.band(dmgType, DMG_CLUB) ~= 0 then
        if hitgroup >= HITGROUP_LEFTLEG and hitgroup <= HITGROUP_RIGHTLEG and dmgAmount > 15 and math.random(1, 100) > 40 then
            ply:AddWound(hitgroup, AdvMed.WOUND_FRACTURE)
        end
    end

    if bit.band(dmgType, DMG_BLAST) ~= 0 then
        ply:AddWound(HITGROUP_HEAD, AdvMed.WOUND_CONTUSION)
        ply:AddWound(hitgroup, AdvMed.WOUND_BURN)
    end

    if bit.band(dmgType, DMG_BURN) ~= 0 then
        ply:AddWound(hitgroup, AdvMed.WOUND_BURN)
    end

    ply.MedData.Pain = math.Clamp(ply.MedData.Pain + (dmgAmount * 0.5), 0, 100)
end)