RegisterCommand("toolmenu",function(src)
    if(QBCore.Functions.HasPermission(src,'god')) then
        TriggerClientEvent("mtmc-tools:client:opentoolmenu",src)
    end
end)