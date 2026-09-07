-- addons/advanced_medicine/lua/medsystem/ui/cl_supplycrate.lua
AddCSLuaFile()

local supplyMenu = nil

net.Receive("AdvMed_OpenSupplyMenu", function()
    if IsValid(supplyMenu) then supplyMenu:Remove() end

    local w, h = 600, 450
    supplyMenu = vgui.Create("DFrame")
    supplyMenu:SetSize(w, h)
    supplyMenu:Center()
    supplyMenu:SetTitle("")
    supplyMenu:SetDraggable(true)
    supplyMenu:MakePopup()
    supplyMenu:ShowCloseButton(false)

    supplyMenu.Alpha = 0
    supplyMenu.Think = function(self)
        self.Alpha = math.Approach(self.Alpha, 255, FrameTime() * 800)
    end

    supplyMenu.Paint = function(self, pw, ph)
        surface.SetDrawColor(20, 20, 25, self.Alpha)
        surface.DrawRect(0, 0, pw, ph)
        surface.SetDrawColor(30, 30, 40, self.Alpha)
        surface.DrawRect(0, 0, pw, 45)
        surface.SetDrawColor(70, 130, 180, self.Alpha)
        surface.DrawOutlinedRect(0, 0, pw, ph)

        draw.SimpleText("СКЛАД МЕДИКАМЕНТІВ", "DermaDefaultBold", 15, 14, Color(240, 240, 240, self.Alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end

    local closeBtn = vgui.Create("DButton", supplyMenu)
    closeBtn:SetSize(35, 30)
    closeBtn:SetPos(w - 40, 8)
    closeBtn:SetText("X")
    closeBtn:SetFont("DermaDefaultBold")
    closeBtn:SetTextColor(Color(200, 200, 200))
    closeBtn.Paint = function(self, bw, bh)
        if self:IsHovered() then surface.SetDrawColor(200, 50, 50, 255) else surface.SetDrawColor(40, 40, 50, 255) end
        surface.DrawRect(0, 0, bw, bh)
    end
    closeBtn.DoClick = function() supplyMenu:Close() end

    local scroll = vgui.Create("DScrollPanel", supplyMenu)
    scroll:SetPos(15, 55)
    scroll:SetSize(w - 30, h - 70)

    for itemID, itemData in pairs(AdvMed.ItemsRegistry) do
        local itemPanel = scroll:Add("DPanel")
        itemPanel:SetDock(TOP)
        itemPanel:SetTall(60)
        itemPanel.Paint = function(self, pw, ph)
            surface.SetDrawColor(30, 30, 40, 255)
            surface.DrawRect(0, 0, pw, ph)
            surface.SetDrawColor(60, 60, 80, 255)
            surface.DrawOutlinedRect(0, 0, pw, ph)
            draw.SimpleText(itemData.name, "DermaDefaultBold", 15, 10, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText("Вага: " .. itemData.weight .. " кг", "DermaDefault", 15, 32, Color(150, 150, 160), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        end

        local takeBtn = vgui.Create("DButton", itemPanel)
        takeBtn:SetSize(100, 36)
        takeBtn:SetPos(w - 145, 12)
        takeBtn:SetText("Взяти")
        takeBtn:SetFont("DermaDefaultBold")
        takeBtn:SetTextColor(Color(255, 255, 255))
        takeBtn.Paint = function(self, bw, bh)
            if self:IsHovered() then surface.SetDrawColor(50, 150, 50, 255) else surface.SetDrawColor(40, 110, 40, 255) end
            surface.DrawRect(0, 0, bw, bh)
        end
        takeBtn.DoClick = function()
            net.Start("AdvMed_RestockItem")
                net.WriteString(itemID)
            net.SendToServer()
            surface.PlaySound("buttons/lever1.wav")
        end
    end
end)