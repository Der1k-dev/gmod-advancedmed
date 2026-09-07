-- addons/advanced_medicine/lua/medsystem/core/sh_bag_interaction.lua
AddCSLuaFile()

hook.Add("PlayerBindPress", "AdvMed_OpenBagByKey", function(ply, bind, pressed)
    if not IsValid(ply) or not ply:Alive() then return end
    
    if string.find(bind, "+use") and pressed then
        local activeWeapon = ply:GetActiveWeapon()
        
        if IsValid(activeWeapon) and activeWeapon:GetClass() == "weapon_medbag" then
            if not CLIENT then
                if not ply.MedBag then ply:InitMedBag() end
                ply:SyncMedBag()
                
                net.Start("AdvMed_OpenBagMenu")
                net.Send(ply)
            end
            
            ply:EmitSound("items/ammocrate_open.wav")
            return true
        end
    end
end)