-- Discord http://discord.gg/FqQFzndxZ4
if Config.useNDCore then
    NDCore = exports["ND_Core"]:GetCoreObject()
else
    QBCore = exports['qb-core']:GetCoreObject()
end

local hasBeenCaught = false
local finalBillingPrice = 0;

function hintToDisplay(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

CreateThread(function()
    if not Config.useBlips then
        return
    end
    for _, info in ipairs(Config.blips) do
        info.blip = AddBlipForCoord(info.x, info.y, info.z)
        SetBlipSprite(info.blip, info.id)
        SetBlipDisplay(info.blip, 4)
        SetBlipScale(info.blip, 0.5)
        SetBlipColour(info.blip, info.colour)
        SetBlipAsShortRange(info.blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(info.title)
        EndTextCommandSetBlipName(info.blip)
    end
end)

local function caughtCheck(finalBillingPrice, street1name, street2name, SpeedMPH)
    if Config.useFlashingScreen then
        TriggerServerEvent('mmo-speedcameras:openGUI')
        Citizen.Wait(600)
        TriggerServerEvent('mmo-speedcameras:closeGUI')
    end

    if Config.useCameraSound then
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "speedcamera", 0.5)
    end

    if alertPolice and SpeedMPH > Config.alertSpeed then
        local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), false))
    end

    if Config.useBilling == 0 then
        finalBillingPrice = 0
    end
    TriggerServerEvent('mmo-speedcameras:PayBill', finalBillingPrice, street1name, street2name, math.floor(SpeedMPH))
end

local function caughtPayIt(playerPed, playerCar, veh, SpeedMPH, playerPos, maxSpeed)
    if SpeedMPH <= maxSpeed or hasBeenCaught then
        return
    end

    local driverPed = GetPedInVehicleSeat(playerCar, -1)
    if playerPed ~= driverPed then
        return
    end

    hasBeenCaught = true
    local plate = QBCore.Functions.GetPlate(veh)

    if Config.useNDCore then
        plate = GetVehicleNumberPlateText(veh)
    end

    local street1, street2 = GetStreetNameAtCoord(playerPos.x, playerPos.y, playerPos.z)
    local street1name = GetStreetNameFromHashKey(street1)
    local street2name = GetStreetNameFromHashKey(street2)

    local speedDelta = SpeedMPH - maxSpeed
    local baseFine = Config.defaultPrice[2]

    local additionalFine = 0
    for i = 1, #Config.extraZonePrice do
        if speedDelta >= Config.extraZonePrice[i] then
            additionalFine = Config.extraZonePrice[i]
        end
    end

    local finalBillingPrice = baseFine + additionalFine

    if Config.useNDCore then
        local playerData = NDCore.Functions.GetSelectedCharacter()
        if not Config.byPassedJobs[playerData.job] then
            if Config.useBilling then
                caughtCheck(finalBillingPrice, street1name, street2name, SpeedMPH)
            else
                caughtCheck(finalBillingPrice, street1name, street2name, SpeedMPH)
            end
        end
    else
        QBCore.Functions.GetPlayerData(function(playerData)
            if not Config.byPassedJobs[playerData.job.name] then
                if Config.useBilling then
                    caughtCheck(finalBillingPrice, street1name, street2name, SpeedMPH)
                else
                    caughtCheck(finalBillingPrice, street1name, street2name, SpeedMPH)
                end
            end
        end)
    end

end

-- Define a function to handle speed cameras for a given zone and maximum speed
local function handleSpeedCameraZone(zone, maxSpeed)
    local playerPed = PlayerPedId()
    local playerPos = GetEntityCoords(playerPed)
    for k, cameraPos in pairs(zone) do
        local distanceToZone = Vdist(playerPos.x, playerPos.y, playerPos.z, cameraPos.x, cameraPos.y, cameraPos.z)
        if distanceToZone <= 20.0 then
            caughtPayIt(playerPed, GetVehiclePedIsIn(playerPed), GetVehiclePedIsIn(playerPed),
                GetEntitySpeed(playerPed) * 2.2369, playerPos, maxSpeed)
            Wait(5000)
            hasBeenCaught = false
        end
    end
end

-- Main loop
CreateThread(function()
    while true do
        Wait(10)
        handleSpeedCameraZone(Config.Speedcamera45Zone, 46.0)
        handleSpeedCameraZone(Config.Speedcamera55Zone, 56.0)
        handleSpeedCameraZone(Config.Speedcamera70Zone, 71.0)
    end
end)

local cachedData = nil

RegisterNetEvent('mmo-speedcameras:client:SendBillEmail', function(amount, street1name, street2name, travelSpeed)
    if not cachedData then
        cachedData = QBCore.Functions.GetPlayerData().charinfo
    end

    local gender = cachedData.gender == 1 and "Mrs." or "Mr."
    local speedType = "MPH"
    local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false))

    local message = string.format(
        "Dear %s %s,<br/><br/>Hereby, we inform you that you have received a speeding ticket on <strong>%s / %s</strong>.<br/><br/>Your driving speed was <strong>%d %s</strong><br/><br/>Vehicle license plate: <strong>%s</strong>",
        gender, cachedData.lastname, street1name, street2name, travelSpeed, speedType, plate)

    if Config.useBilling then
        message = message .. string.format("<br/><br/>Total fine: <strong>$%d</strong><br/>", amount)
    end

    SetTimeout(5000, function()
        TriggerServerEvent('qb-phone:server:sendNewMail', {
            sender = "SAS Traffic Control",
            subject = "Speeding Fine",
            message = message
        })
    end)
end)

RegisterNetEvent('mmo-speedcameras:openGUI', function()
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = 'openSpeedcamera'
    })
end)

RegisterNetEvent('mmo-speedcameras:closeGUI', function()
    SendNUIMessage({
        type = 'closeSpeedcamera'
    })
end)
