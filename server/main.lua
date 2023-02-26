-- Discord http://discord.gg/FqQFzndxZ4
if Config.useNDCore then
    NDCore = exports["ND_Core"]:GetCoreObject()
else
    QBCore = exports['qb-core']:GetCoreObject()
end

RegisterServerEvent('mmo-speedcameras:PayBill', function(amount, street1name, street2name, SpeedMPH)
    if Config.useNDCore then
        NDCore.Functions.DeductMoney(amount, source, "bank", "Speed Fine")
    else
        local player = QBCore.Functions.GetPlayer(source)
        if not player then
            return
        end

        player.Functions.RemoveMoney('bank', amount)
        exports['qb-management']:AddMoney('police', amount)
        TriggerClientEvent('mmo-speedcameras:client:SendBillEmail', source, amount, street1name, street2name, SpeedMPH)
    end
end)

RegisterServerEvent('mmo-speedcameras:openGUI', function()
    TriggerClientEvent('mmo-speedcameras:openGUI', source)
end)

RegisterServerEvent('mmo-speedcameras:closeGUI', function()
    TriggerClientEvent('mmo-speedcameras:closeGUI', source)
end)
