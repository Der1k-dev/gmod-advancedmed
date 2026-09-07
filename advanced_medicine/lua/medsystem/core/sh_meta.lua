-- addons/advanced_medicine/lua/medsystem/core/sh_meta.lua
local plyMeta = FindMetaTable("Player")

function plyMeta:InitMedData()
    self.MedData = {
        Blood = AdvMed.Config.MaxBlood,
        Pain = 0,
        InComa = false,
        Wounds = {
            [HITGROUP_HEAD] = {}, [HITGROUP_CHEST] = {}, [HITGROUP_STOMACH] = {},
            [HITGROUP_LEFTARM] = {}, [HITGROUP_RIGHTARM] = {},
            [HITGROUP_LEFTLEG] = {}, [HITGROUP_RIGHTLEG] = {}
        }
    }
end

function plyMeta:GetBlood()
    return self.MedData and self.MedData.Blood or AdvMed.Config.MaxBlood
end

function plyMeta:AddWound(hitgroup, woundType)
    if not self.MedData or not self.MedData.Wounds[hitgroup] then return end
    if not table.HasValue(self.MedData.Wounds[hitgroup], woundType) then
        table.insert(self.MedData.Wounds[hitgroup], woundType)
    end
end