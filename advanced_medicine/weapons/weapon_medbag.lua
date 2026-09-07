-- addons/advanced_medicine/weapons/weapon_medbag.lua
AddCSLuaFile()

SWEP.PrintName       = "Медична сумка"
SWEP.Author          = "Chief Developer"
SWEP.Instructions    = "Натисніть E (Use) в руках, щоб відкрити інвентар сумки.\nLMB: Швидке бинтування себе."
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
SWEP.SlotPos         = 3
SWEP.DrawAmmo        = false
SWEP.DrawCrosshair   = true

SWEP.ViewModel       = "models/weapons/c_arms.mdl"
SWEP.WorldModel      = "models/weapons/w_suitcase_passenger.mdl"
SWEP.UseHands        = true

function SWEP:PrimaryAttack()
    if CLIENT then return end
    
    local owner = self:GetOwner()
    if not IsValid(owner) then return end

    self:SetNextPrimaryFire(CurTime() + 2.0)
    
    if not owner.MedBag then owner:InitMedBag() end
    
    local hasBandage = false
    for _, item in ipairs(owner.MedBag.Items) do
        if item.id == "bandage" and item.count > 0 then
            item.count = item.count - 1
            hasBandage = true
            break
        end
    end

    if hasBandage then
        owner:UpdateBagWeight()
        owner:SyncMedBag()
        
        owner.MedData = owner.MedData or {}
        owner.MedData.Pain = math.Clamp((owner.MedData.Pain or 0) - 15, 0, 100)
        
        owner:EmitSound("items/medshotno1.wav")
        owner:ChatPrint("[Медицина] Ви швидко використали бинт із сумки на себе.")
    else
        owner:ChatPrint("[Медицина] У вашій сумці закінчилися бінти!")
    end
end

function SWEP:SecondaryAttack()
end