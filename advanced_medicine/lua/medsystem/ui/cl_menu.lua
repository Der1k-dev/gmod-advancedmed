-- addons/advanced_medicine/lua/medsystem/ui/cl_menu.lua
AddCSLuaFile()

local medMenu = nil
local blurMat = Material("pp/blurscreen")

function AdvMed:OpenMedicalMenu(targetPly)
    if IsValid(medMenu) then medMenu:Remove() end
    if not IsValid(targetPly) or not targetPly:IsPlayer() then return end

    local scrW, scrH = ScrW(), ScrH()
    local w, h = 800, 520

    medMenu = vgui.Create("DFrame")
    medMenu:SetSize(w, h)
    medMenu:Center()
    medMenu:SetTitle("")
    medMenu:SetDraggable(false)
    medMenu:MakePopup()
    medMenu:ShowCloseButton(false)

    medMenu.AnimAlpha = 0
    medMenu.ScaleAnim = 0.95
    
    medMenu.Think = function(self)
        self.AnimAlpha = math.Approach(self.AnimAlpha, 255, FrameTime() * 1200)
    end

    medMenu.Paint = function(self, pw, ph)
        local alphaFrac = self.AnimAlpha / 255

        -- ААА Розмиття фону
        surface.SetMaterial(blurMat)
        surface.SetDrawColor(255, 255, 255, 255)
        for i = 1, 3 do
            blurMat:SetFloat("$blur", i * 2)
            blurMat:Recompute()
            render.UpdateScreenEffectTexture()
            surface.DrawTexturedRect(0, 0, scrW, scrH)
        end

        surface.SetDrawColor(10, 12, 18, 220 * alphaFrac)
        surface.DrawRect(0, 0, pw, ph)

        surface.SetDrawColor(0, 160, 255, 100 * alphaFrac)
        surface.DrawOutlinedRect(0, 0, pw, ph, 1)

        surface.SetDrawColor(0, 200, 255, 200 * alphaFrac)
        surface.DrawRect(0, 0, 15, 2)
        surface.DrawRect(0, 0, 2, 15)
        surface.DrawRect(pw - 15, ph - 2, 15, 2)
        surface.DrawRect(pw - 2, ph - 15, 2, 15)

        surface.SetDrawColor(15, 20, 30, 250 * alphaFrac)
        surface.DrawRect(0, 0, pw, 50)
        
        surface.SetDrawColor(0, 160, 255, 150 * alphaFrac)
        surface.DrawRect(0, 50, pw, 1)

        draw.SimpleText("ADVANCED TRAUMA SYSTEM v2.4 // BIOMETRIC SCAN", "DermaDefaultBold", 20, 17, Color(0, 200, 255, 255 * alphaFrac), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText("SUBJECT: " .. string.upper(targetPly:Nick()), "DermaDefaultBold", pw - 20, 17, Color(255, 255, 255, 255 * alphaFrac), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
    end

    local closeBtn = vgui.Create("DButton", medMenu)
    closeBtn:SetSize(40, 30)
    closeBtn:SetPos(w - 45, 10)
    closeBtn:SetText("✕")
    closeBtn:SetFont("DermaDefaultBold")
    closeBtn:SetTextColor(Color(200, 200, 200))
    closeBtn.Paint = function(self, bw, bh)
        if self:IsHovered() then
            surface.SetDrawColor(255, 50, 50, 200)
            surface.DrawRect(0, 0, bw, bh)
            self:SetTextColor(Color(255, 255, 255))
        else
            surface.SetDrawColor(30, 40, 50, 150)
            surface.DrawRect(0, 0, bw, bh)
            self:SetTextColor(Color(180, 180, 180))
        end
    end
    closeBtn.DoClick = function() 
        surface.PlaySound("buttons/combine_button7.wav")
        medMenu:Close() 
    end

    local bodyPanel = vgui.Create("DPanel", medMenu)
    bodyPanel:SetPos(20, 65)
    bodyPanel:SetSize(340, 435)
    bodyPanel.Paint = function(self, pw, ph)
        surface.SetDrawColor(12, 16, 24, 180)
        surface.DrawRect(0, 0, pw, ph)
        surface.SetDrawColor(40, 60, 90, 100)
        surface.DrawOutlinedRect(0, 0, pw, ph, 1)

        draw.SimpleText("БІОМЕТРИЧНА КАРТА ТІЛА", "DermaDefaultBold", 15, 15, Color(150, 180, 220), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

        local blood = targetPly:GetBlood() or 5000
        local bloodFrac = blood / 5000
        local pulse = math.abs(math.sin(CurTime() * 4)) * 50

        draw.SimpleText("Загальний об'єм крові:", "DermaDefault", 15, 380, Color(150, 150, 150), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        
        surface.SetDrawColor(20, 30, 45, 255)
        surface.DrawRect(15, 400, pw - 30, 16)
        
        local barColor = bloodFrac < 0.5 and Color(255, 50 + pulse, 50) or Color(0, 200, 100)
        surface.SetDrawColor(barColor)
        surface.DrawRect(15, 400, (pw - 30) * bloodFrac, 16)

        surface.SetDrawColor(255, 255, 255, 30)
        surface.DrawOutlinedRect(15, 400, pw - 30, 16, 1)

        draw.SimpleText(blood .. " мл / 5000 мл (" .. math.Round(bloodFrac * 100) .. "%)", "DermaDefaultBold", pw / 2, 401, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    end

    local actionPanel = vgui.Create("DPanel", medMenu)
    actionPanel:SetPos(370, 65)
    actionPanel:SetSize(410, 435)
    actionPanel.Paint = function(self, pw, ph)
        surface.SetDrawColor(12, 16, 24, 180)
        surface.DrawRect(0, 0, pw, ph)
        surface.SetDrawColor(40, 60, 90, 100)
        surface.DrawOutlinedRect(0, 0, pw, ph, 1)

        draw.SimpleText("ПРОТОКОЛИ ВТРУЧАННЯ", "DermaDefaultBold", 15, 15, Color(150, 180, 220), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end

    local scroll = vgui.Create("DScrollPanel", actionPanel)
    scroll:SetPos(15, 45)
    scroll:SetSize(380, 375)

    local procedures = {
        {name = "НАКЛАСТИ ТУРНІКЕТ", desc = "Блокування артеріальної кровотечі на кінцівках", action = "tourniquet"},
        {name = "ХІРУРГІЧНИЙ БИНТ", desc = "Зниження больового шоку та стабілізація ран", action = "bandage"},
        {name = "ІН'ЄКЦІЯ МОРФІНУ", desc = "Повне знеболювання та стимуляція нервової системи", action = "morphine"},
        {name = "СЕРЦЕВО-ЛЕГЕНЕВА РЕАНІМАЦІЯ", desc = "Відновлення серцевого ритму з стану коми", action = "cpr"},
    }

    for _, proc in ipairs(procedures) do
        local btn = scroll:Add("DButton")
        btn:SetText("")
        btn:SetDock(TOP)
        btn:SetTall(60)
        btn:SetMargin(Margins and Margins(0, 0, 0, 10) or 5)

        btn.HoverLerp = 0

        btn.Paint = function(self, bw, bh)
            local targetHover = self:IsHovered() and 1 or 0
            self.HoverLerp = Lerp(FrameTime() * 15, self.HoverLerp, targetHover)

            local r = math.Lerp(self.HoverLerp, 20, 25)
            local g = math.Lerp(self.HoverLerp, 30, 50)
            local b = math.Lerp(self.HoverLerp, 45, 80)
            
            surface.SetDrawColor(r, g, b, 220)
            surface.DrawRect(0, 0, bw, bh)

            surface.SetDrawColor(0, 160, 255, 255 * self.HoverLerp)
            surface.DrawRect(0, 0, 3, bh)

            surface.SetDrawColor(40, 70, 100, 150)
            surface.DrawOutlinedRect(0, 0, bw, bh, 1)

            local textColor = Color(220, 230, 240)
            if self:IsHovered() then textColor = Color(255, 255, 255) end

            draw.SimpleText(proc.name, "DermaDefaultBold", 15, 10, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText(proc.desc, "DermaDefault", 15, 32, Color(130, 150, 170), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        end

        btn.DoClick = function()
            net.Start("AdvMed_UseItem")
                net.WriteEntity(targetPly)
                net.WriteString(proc.action)
            net.SendToServer()
            
            surface.PlaySound("buttons/combine_button1.wav")
        end
    end
end

net.Receive("AdvMed_OpenMenu", function()
    local target = net.ReadEntity()
    AdvMed:OpenMedicalMenu(target)
end)