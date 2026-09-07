-- addons/advanced_medicine/lua/medsystem/core/sh_config.lua
AdvMed = AdvMed or {}
AdvMed.Config = AdvMed.Config or {}

AdvMed.Config.MaxBlood = 5000
AdvMed.Config.ComaBloodLevel = 2500
AdvMed.Config.DeathBloodLevel = 1000

AdvMed.WOUND_BLEEDING = 1
AdvMed.WOUND_FRACTURE = 2
AdvMed.WOUND_BURN     = 3
AdvMed.WOUND_CONTUSION= 4

AdvMed.Config.BleedRates = {
    [HITGROUP_HEAD]     = 15,
    [HITGROUP_CHEST]    = 20,
    [HITGROUP_STOMACH]  = 15,
    [HITGROUP_LEFTARM]  = 5,
    [HITGROUP_RIGHTARM] = 5,
    [HITGROUP_LEFTLEG]  = 10,
    [HITGROUP_RIGHTLEG] = 10,
}

AdvMed.ItemsRegistry = {
    ["bandage"] = {name = "Медичний бинт", weight = 0.2, maxStack = 5},
    ["tourniquet"] = {name = "Кровоспинний джгут", weight = 0.3, maxStack = 3},
    ["morphine"] = {name = "Ампула морфіну", weight = 0.1, maxStack = 10},
    ["blood_bag"] = {name = "Пакет крові (500мл)", weight = 1.0, maxStack = 2},
    ["defibrillator"] = {name = "Портативний дефібрилятор", weight = 3.5, maxStack = 1},
}