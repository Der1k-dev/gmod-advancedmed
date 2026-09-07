-- addons/advanced_medicine/lua/medsystem/entities/ent_medical_crate/shared.lua
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Склад медикаментів"
ENT.Author = "Chief Developer"
ENT.Category = "Медицина"
ENT.Spawnable = true
ENT.AdminOnly = false

function ENT:Initialize()
    if SERVER then
        self:SetModel("models/items/item_item_crate.mdl")
        self:SetSolid(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:PhysicsInit(SOLID_VPHYSICS)
        local phys = self:GetPhysicsObject()
        if IsValid(phys) then phys:Wake() end
    end
end

function ENT:Use(activator, caller)
    if not IsValid(caller) or not caller:IsPlayer() then return end
    if caller:GetPos():DistToSqr(self:GetPos()) > 15000 then return end

    if SERVER then
        caller:SyncMedBag()
        net.Start("AdvMed_OpenSupplyMenu")
        net.WriteEntity(self)
        net.Send(caller)
    end
end