-- addons/advanced_medicine/lua/medsystem/core/sv_crate_handler.lua
AddCSLuaFile()

net.Receive("AdvMed_RestockItem", function(len, ply)
    if not IsValid(ply) or not ply:Alive() then return end
    local itemID = net.ReadString()
    local itemData = AdvMed.ItemsRegistry[itemID]
    if not itemData then return end
    if not ply.MedBag then ply:InitMedBag() end

    if (ply.MedBag.CurrentWeight + itemData.weight) > ply.MedBag.Capacity then
        ply:ChatPrint("[Склад] Перевищено ліміт ваги сумки!")
        return
    end

    local found = false
    for _, item in ipairs(ply.MedBag.Items) do
        if item.id == itemID then
            if item.count < itemData.maxStack then
                item.count = item.count + 1
                found = true
            else
                ply:ChatPrint("[Склад] Досягнуто ліміт стопки предмета!")
                return
            end
            break
        end
    end

    if not found then table.insert(ply.MedBag.Items, {id = itemID, count = 1}) end

    ply:UpdateBagWeight()
    ply:SyncMedBag()
    ply:EmitSound("items/ammo_pickup.wav")
    ply:ChatPrint("[Склад] Взято предмет: " .. itemData.name)
end)