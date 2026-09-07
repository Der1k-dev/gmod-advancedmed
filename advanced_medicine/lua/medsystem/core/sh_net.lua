-- addons/advanced_medicine/lua/medsystem/core/sh_net.lua
AddCSLuaFile()

if SERVER then
    util.AddNetworkString("AdvMed_SyncData")
    util.AddNetworkString("AdvMed_OpenMenu")
    util.AddNetworkString("AdvMed_UseItem")
    util.AddNetworkString("AdvMed_OpenBagMenu")
    util.AddNetworkString("AdvMed_TakeFromBag")
    util.AddNetworkString("AdvMed_SyncBag")
    util.AddNetworkString("AdvMed_OpenSupplyMenu")
    util.AddNetworkString("AdvMed_RestockItem")
    util.AddNetworkString("AdvMed_UseStimulant")
    util.AddNetworkString("AdvMed_SyncStimulant")
else
    net.Receive("AdvMed_SyncData", function()
        local data = net.ReadTable()
        if LocalPlayer().MedData then
            LocalPlayer().MedData = data
        end
    end)
end