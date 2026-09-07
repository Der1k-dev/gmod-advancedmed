-- addons/advanced_medicine/weapons/weapon_defibrillator.lua
AddCSLuaFile()

SWEP.PrintName       = "Дефібрилятор"
SWEP.Author          = "Chief Developer"
SWEP.Instructions    = "LMB: Реанімувати пацієнта в комі"
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

SWEP.Weight          = 5
SWEP.AutoSwitchTo    = false
SWEP.AutoSwitchFrom  = false

SWEP.Slot            = 3
SWEP.SlotPos         = 1
SWEP.DrawAmmo        = false
SWEP.DrawCrosshair   = true

SWEP.ViewModel       = "models/weapons/c_arms.mdl"
SWEP.WorldModel      = "models/weapons/w_medkit.mdl"
SWEP.UseHands        = true

function SWEP:PrimaryAttack()
    if CLIENT then return end

    self:SetNextPrimaryFire(CurTime() + 3.0)

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
        if target.MedData and target.MedData.InComa then
            target:ReviveFromComa()
            owner:EmitSound("items/medshot4.wav")
            self:EmitSound("weapons/physcannon/energy_singularity_cue.wav")
        else
            owner:ChatPrint("[Медицина] Пацієнт не перебуває в комі.")
        end
    end
end

function SWEP:SecondaryAttack()
end