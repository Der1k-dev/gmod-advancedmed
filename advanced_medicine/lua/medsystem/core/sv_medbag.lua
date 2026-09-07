-- addons/advanced_medicine/lua/medsystem/core/sv_medbag.lua
AddCSLuaFile()

local plyMeta = FindMetaTable("Player")

function plyMeta:InitMedBag()
    self.MedBag = {
        Capacity = 10.0,
        CurrentWeight = 0,
        Items = {
            {id = "bandage", count = 3},
            {id = "tourniquet", count = 2},
            {id = "morphine", count = 2},
        }
    }
    self:UpdateBagWeight()
end

function plyMeta:UpdateBagWeight()
    if not self.MedBag then self:InitMedBag() end
    local weight = 0
    for _, item in ipairs(self.MedBag.Items) do
        local itemData = AdvMed.ItemsRegistry[item.id]
        if itemData then weight = weight + (itemData.weight * item.count) end
    end
    self.MedBag.CurrentWeight = math.Round(weight, 2)
end

function plyMeta:SyncMedBag()
    if not self.MedBag then self:InitMedBag() end
    net.Start("AdvMed_SyncBag")
        net.WriteTable(self.MedBag)
    net.Send(self)
end

hook.Add("PlayerSpawn", "AdvMed_InitBagOnSpawn", function(ply)
    ply:InitMedBag()
end)