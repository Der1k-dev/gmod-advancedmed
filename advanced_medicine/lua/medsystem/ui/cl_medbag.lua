-- addons/advanced_medicine/lua/medsystem/ui/cl_medbag.lua
AddCSLuaFile()

local bagMenu = nil
local clientBagData = { Capacity = 10, CurrentWeight = 0, Items = {} }

net.Receive("AdvMed_SyncBag", function()
    clientBagData = net.ReadTable()
end)

net.Receive("AdvMed_OpenBagMenu", function()
    if IsValid(bagMenu) then bagMenu:Remove() end

    local w, h = 500, 400
    bagMenu = vgui.Create("DFrame")
    bagMenu:SetSize(w, h)
    bagMenu:Center()
    bagMenu:SetTitle("")
    bagMenu:SetDraggable(true)
    bagMenu:MakePopup()
    bagMenu:ShowCloseButton(false)

    bagMenu.Alpha = 0
    bagMenu.Think = function(self)
        self.Alpha = math.Approach(self.Alpha, 255, FrameTime() * 800)
    end

    bagMenu.Paint = function(self, pw, ph)
        surface.SetDrawColor(20, 20, 25, self.Alpha)
        surface.DrawRect(0, 0, pw, ph)
        surface.SetDrawColor(30, 30, 40, self.Alpha)
        surface.DrawRect(0, 0, pw, 40)
        surface.SetDrawColor(70, 130, 180, self.Alpha)
        surface.DrawOutlinedRect(0, 0, pw, ph)

        draw.SimpleText("МЕДИЧНА СУМКА", "DermaDefaultBold", 15, 12, Color(240, 240, 240, self.Alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText("Вага: " .. clientBagData.CurrentWeight .. " / " .. clientBagData.Capacity .. " кг", "DermaDefault", pw - 15, 12, Color(150, 150, 160, self.Alpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
    end

    local closeBtn = vgui.Create("DButton", bagMenu)
    closeBtn:SetSize(30, 26)
    closeBtn:SetPos(w - 35, 7)
    closeBtn:SetText("X")
    closeBtn:SetFont("DermaDefaultBold")
    closeBtn:SetTextColor(Color(200, 200, 200))
    closeBtn.Paint = function(self, bw, bh)
        if self:IsHovered() then surface.SetDrawColor(200, 50, 50, 255) else surface.SetDrawColor(40, 40, 50, 255) end
        surface.DrawRect(0, 0, bw, bh)
    end
    closeBtn.DoClick = function() bagMenu:Close() end

    local scroll = vgui.Create("DScrollPanel", bagMenu)
    scroll:SetPos(15, 55)
    scroll:SetSize(w - 30, h - 70)

    for _, item in ipairs(clientBagData.Items) do
        local itemPanel = scroll:Add("DPanel")
        itemPanel:SetDock(TOP)
        itemPanel:SetTall(55)
        itemPanel.Paint = function(self, pw, ph)
            surface.SetDrawColor(30, 30, 40, 255)
            surface.DrawRect(0, 0, pw, ph)
            surface.SetDrawColor(60, 60, 80, 255)
            surface.DrawOutlinedRect(0, 0, pw, ph)
            draw.SimpleText("ID: " .. item.id, "DermaDefaultBold", 15, 10, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            draw.SimpleText("Кількість: " .. item.count, "DermaDefault", 15, 30, Color(180, 180, 190), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        end
    end
end)