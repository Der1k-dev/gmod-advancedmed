-- addons/advanced_medicine/lua/medsystem/ui/cl_hud.lua
AddCSLuaFile()

local blurIntensity = 0

hook.Add("RenderScreenspaceEffects", "AdvMed_VisualEffects", function()
    local ply = LocalPlayer()
    if not IsValid(ply) or not ply.MedData then return end

    local blood = ply:GetBlood()
    local maxBlood = AdvMed.Config.MaxBlood

    if blood < maxBlood * 0.7 then
        local healthFraction = blood / maxBlood
        local tab = {
            ["$pp_colour_addr"] = 0, ["$pp_colour_addg"] = 0, ["$pp_colour_addb"] = 0,
            ["$pp_colour_brightness"] = 0, ["$pp_colour_contrast"] = 1,
            ["$pp_colour_colour"] = healthFraction,
            ["$pp_colour_mulr"] = 0, ["$pp_colour_mulg"] = 0, ["$pp_colour_mulb"] = 0
        }
        DrawColorModify(tab)

        if blood < maxBlood * 0.4 then
            blurIntensity = Lerp(FrameTime() * 2, blurIntensity, 2)
            DrawMotionBlur(0.1, blurIntensity, 0.05)
        else
            blurIntensity = Lerp(FrameTime() * 2, blurIntensity, 0)
        end
    end
end)

hook.Add("HUDPaint", "AdvMed_DrawHUD", function()
    local ply = LocalPlayer()
    if not IsValid(ply) or not ply.MedData then return end

    local blood = ply:GetBlood()
    local scrW, scrH = ScrW(), ScrH()
    local boxW, boxH = 220, 60
    local boxX, boxY = scrW - boxW - 30, scrH - boxH - 40

    surface.SetDrawColor(20, 20, 20, 200)
    surface.DrawRect(boxX, boxY, boxW, boxH)
    surface.SetDrawColor(200, 40, 40, 255)
    surface.DrawOutlinedRect(boxX, boxY, boxW, boxH, 1)

    draw.SimpleText("Кров: " .. blood .. " мл", "DermaDefaultBold", boxX + 15, boxY + 12, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    
    if ply.MedData.InComa then
        draw.SimpleText("СТАН КОМИ (ПОТРІБЕН ДЕФІБРИЛЯТОР)", "DermaDefaultBold", scrW / 2, scrH - 120, Color(255, 50, 50), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end)