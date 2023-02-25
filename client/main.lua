-- Discord http://discord.gg/FqQFzndxZ4
QBCore = exports['qb-core']:GetCoreObject()

local hasBeenCaught = false
local finalBillingPrice = 0;

function hintToDisplay(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

CreateThread(function()
    for _, info in pairs(Config.blips) do
        if Config.useBlips == true then
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
    end
end)

local function caughtPayIt(playerPed, playerCar, veh, SpeedMPH, playerPos, maxSpeed)

    if SpeedMPH > maxSpeed then
        if IsPedInAnyVehicle(playerPed, false) then
            if (GetPedInVehicleSeat(playerCar, -1) == playerPed) then
                if hasBeenCaught == false then
                    QBCore.Functions.GetPlayerData(function(PlayerData)
                        if PlayerData.job.name == "police" or PlayerData.job.name == "ambulance" then
                        else
                            if alertPolice == true then
                                if SpeedMPH > Config.alertSpeed then
                                    local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), false))
                                    TriggerServerEvent('qb-phone:server:sendNewMail', {
                                        sender = "911/Police",
                                        subject = "Speeding Fine",
                                        message = 'Your vehicle was caught speeding and has been fined. Your vehicle was driving above the speed limit of ' ..
                                            Config.alertSpeed .. ' mph'
                                    })
                                end
                            end

                            if Config.useFlashingScreen == true then
                                TriggerServerEvent('mmo-speedcameras:openGUI')
                            end

                            if Config.useCameraSound == true then
                                TriggerServerEvent("InteractSound_SV:PlayOnSource", "speedcamera", 0.5)
                            end

                            if Config.useFlashingScreen == true then
                                Wait(600)
                                TriggerServerEvent('mmo-speedcameras:closeGUI')
                            end

                            plate = QBCore.Functions.GetPlate(veh)

                            street1, street2 = GetStreetNameAtCoord(playerPos.x, playerPos.y, playerPos.z)
                            street1name = GetStreetNameFromHashKey(street1)
                            street2name = GetStreetNameFromHashKey(street2)

                            local speedDelta = SpeedMPH - maxSpeed

                            local baseFine = Config.defaultPrice[2]

                            local additionalFine = 0
                            for i = 1, #Config.extraZonePrice do
                                if speedDelta >= Config.extraZonePrice[i] then
                                    additionalFine = Config.extraZonePrice[i]
                                end
                            end

                            finalBillingPrice = baseFine + additionalFine

                            if Config.useBilling then
                                TriggerServerEvent('mmo-speedcameras:PayBill', finalBillingPrice, street1name,
                                    street2name, math.floor(SpeedMPH))
                            else
                                QBCore.Functions.Notify(
                                    "Speeding fine of $" .. finalBillingPrice .. " | Your speed: " ..
                                        math.floor(SpeedMPH) .. " mph", 'primary', 7500)
                            end

                            hasBeenCaught = true
                        end
                    end)
                end
            end
        end
    end
end

-- ZONES
CreateThread(function()
    while true do
        Wait(10)

        local playerPed = PlayerPedId()
        local playerCar = GetVehiclePedIsIn(playerPed, false)
        local veh = GetVehiclePedIsIn(playerPed)
        local SpeedMPH = GetEntitySpeed(playerPed) * 2.2369
        local playerPos = GetEntityCoords(playerPed)

        -- 45 zone
        for k, zone in pairs(Config.Speedcamera45Zone) do
            local dist = Vdist(playerPos.x, playerPos.y, playerPos.z, zone.x, zone.y, zone.z)
            if dist <= 20.0 then
                caughtPayIt(playerPed, playerCar, veh, SpeedMPH, playerPos, 46.0) -- THIS IS THE MAX SPEED IN mph
                Wait(5000)
                hasBeenCaught = false
            end
        end

        -- 55 zone
        for k, zone in pairs(Config.Speedcamera55Zone) do
            local dist = Vdist(playerPos.x, playerPos.y, playerPos.z, zone.x, zone.y, zone.z)
            if dist <= 20.0 then
                caughtPayIt(playerPed, playerCar, veh, SpeedMPH, playerPos, 56.0) -- THIS IS THE MAX SPEED IN mph
                Wait(5000)
                hasBeenCaught = false
            end
        end

        -- 70 zone
        for k, zone in pairs(Config.Speedcamera70Zone) do
            local dist = Vdist(playerPos.x, playerPos.y, playerPos.z, zone.x, zone.y, zone.z)
            if dist <= 20.0 then
                caughtPayIt(playerPed, playerCar, veh, SpeedMPH, playerPos, 71.0) -- THIS IS THE MAX SPEED IN mph
                Wait(5000)
                hasBeenCaught = false
            end
        end
    end
end)

local cachedData = nil

RegisterNetEvent('mmo-speedcameras:client:SendBillEmail', function(amount, street1name, street2name, travelSpeed)
    if not cachedData then
        cachedData = QBCore.Functions.GetPlayerData().charinfo
    end

    local gender = cachedData.gender == 1 and "Mrs." or "Mr."
    local speedType = "MPH"
    local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false))

    local message = string.format(
        "Dear %s %s,<br/><br/>Hereby, we inform you that you have received a speeding ticket on <strong>%s / %s</strong>.<br/><br/>Your driving speed was <strong>%d %s</strong><br/><br/>Vehicle license plate: <strong>%s</strong><br/><br/>Total fine: <strong>$%d</strong><br/>",
        gender, cachedData.lastname, street1name, street2name, travelSpeed, speedType, plate, amount)

    SetTimeout(5000, function()
        TriggerServerEvent('qb-phone:server:sendNewMail', {
            sender = "SAS Traffic Control",
            subject = "Speeding Ticket",
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
