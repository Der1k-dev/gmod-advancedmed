-- addons/advanced_medicine/weapons/weapon_medscanner.lua
AddCSLuaFile()

SWEP.PrintName       = "Медичний сканер"
SWEP.Author          = "Chief Developer"
SWEP.Instructions    = "LMB: Сканувати пацієнта та відкрити меню"
SWEP.Category        = "Медицина"

SWEP.Spawnable       = true
SWEP.AdminOnly       = false

SWEP.Primary.ClipSize    = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic   = false
SWEP.Primary.Ammo        = "none"

SWEP.Secondary.ClipSize    = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic   = false
SWEP.Secondary.Ammo        = "none"

SWEP.Slot            = 3
SWEP.SlotPos         = 2
SWEP.DrawAmmo        = false
SWEP.DrawCrosshair   = true

SWEP.ViewModel       = "models/weapons/c_arms.mdl"
SWEP.WorldModel      = "models/weapons/w_medkit.mdl"
SWEP.UseHands        = true

function SWEP:PrimaryAttack()
    if CLIENT then return end

    self:SetNextPrimaryFire(CurTime() + 1.0)

    local owner = self:GetOwner()
    owner:LagCompensation(true)
    local trace = util.TraceLine({
        start = owner:GetShootPos(),
        endpos = owner:GetShootPos() + owner:GetAimVector() * 75,
        filter = owner
    })
    owner:LagCompensation(false)

    local target = trace.Entity
    if IsValid(target) and target:IsPlayer() then
        if not target.MedData then target:InitMedData() end
        
        net.Start("AdvMed_OpenMenu")
            net.WriteEntity(target)
        net.Send(owner)

        self:EmitSound("items/medshotno1.wav")
    end
end

function SWEP:SecondaryAttack()
end