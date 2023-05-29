RMenu.Add("CXAnnounce","main",RageUI.CreateMenu("","~b~Aqua Announcement Menu",1300,100,"banners","announcement"))
local a = {}
RageUI.CreateWhile(1.0, RMenu:Get("CXAnnounce", "main"), nil, function()
    RageUI.IsVisible(RMenu:Get("CXAnnounce", "main"), true, false, true, function()
        for b, c in pairs(a) do
            RageUI.ButtonWithStyle(c.name, string.format("%s Price: £%s", c.desc, getMoneyStringFormatted(c.price)), {RightLabel = "→→→"}, true, function(d, e, f)
                if f then
                    TriggerServerEvent("CX:serviceAnnounce", c.name)
                end
            end)
        end
    end)
end)

RegisterNetEvent("CX:buildAnnounceMenu",function(g)
    a = g
    RageUI.Visible(RMenu:Get("CXAnnounce", "main"), not RageUI.Visible(RMenu:Get("CXAnnounce", "main")))
end)

RegisterCommand("announcemenu",function()
    TriggerServerEvent('CX:getAnnounceMenu')
end)
