RegisterCommand("support", function()
    msg("Aquas Support Discord - #support-discord in main discord!")
    msg("Aquas Store - www.Aquafivem.co.uk")
end, false)

function msg()
    TriggerEvent("chatMessage", "[AQUA] Aquas Support Discord - #support-discord in main discord!", {255,0,0}, text)
    TriggerEvent("chatMessage", "[AQUA] Aquas Store - www.Aquafivem.co.uk", {255,0,0}, text)
    end 
