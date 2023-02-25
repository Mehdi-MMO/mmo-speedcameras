QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('mmo-speedcameras:PayBill', function(amount, street1name, street2name, SpeedMPH)
    local Player = QBCore.Functions.GetPlayer(source)
    local src = source

    Player.Functions.RemoveMoney('bank', amount)
    exports['qb-management']:AddMoney("police", amount)
    TriggerClientEvent('mmo-speedcameras:client:SendBillEmail', src, amount, street1name, street2name, SpeedMPH)
end)

RegisterServerEvent('mmo-speedcameras:openGUI', function()
    TriggerClientEvent('mmo-speedcameras:openGUI', source)
end)

RegisterServerEvent('mmo-speedcameras:closeGUI', function()
    TriggerClientEvent('mmo-speedcameras:closeGUI', source)
end)
