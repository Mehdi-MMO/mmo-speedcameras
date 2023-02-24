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
    for _, info in pairs(Config.Blips) do
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

-- ZONES
CreateThread(function()
    while true do
        Wait(10)

        -- 45 zone
        for k in pairs(Config.Speedcamera45Zone) do
            local plyCoords = GetEntityCoords(PlayerPedId(), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.Speedcamera45Zone[k].x, Config.Speedcamera45Zone[k].y,
                Config.Speedcamera45Zone[k].z)

            if dist <= 20.0 then
                local playerPed = PlayerPedId()
                local playerCar = GetVehiclePedIsIn(playerPed, false)
                local veh = GetVehiclePedIsIn(playerPed)
                local SpeedMPH = GetEntitySpeed(playerPed) * 2.2369
                local playerPos = GetEntityCoords(myPed)
                local maxSpeed = 46.0 -- THIS IS THE MAX SPEED IN mph

                if SpeedMPH > maxSpeed then
                    if IsPedInAnyVehicle(playerPed, false) then
                        if (GetPedInVehicleSeat(playerCar, -1) == playerPed) then
                            if hasBeenCaught == false then
                                QBCore.Functions.GetPlayerData(function(PlayerData)
                                    if PlayerData.job.name == "police" or PlayerData.job.name == "ambulance" then
                                    else
                                        -- ALERT POLICE (START)
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
                                        -- ALERT POLICE (END)								

                                        -- FLASHING EFFECT (START)
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
                                        -- FLASHING EFFECT (END)

                                        plate = QBCore.Functions.GetPlate(veh)

                                        street1, street2 = GetStreetNameAtCoord(playerPos.x, playerPos.y, playerPos.z)
                                        street1name = GetStreetNameFromHashKey(street1)
                                        street2name = GetStreetNameFromHashKey(street2)

                                        -- Normal Notifications
                                        -- QBCore.Functions.Notify("Speeding fine (45 mph zone) - Your speed: " .. math.floor(SpeedMPH) .. " MPH", 'primary', 7500)

                                        if Config.useBilling == true then
                                            if SpeedMPH >= maxSpeed + 30 then
                                                finalBillingPrice = defaultPrice45 + Config.extraZonePrice30
                                            elseif SpeedMPH >= maxSpeed + 20 then
                                                finalBillingPrice = defaultPrice45 + Config.extraZonePrice20
                                            elseif SpeedMPH >= maxSpeed + 10 then
                                                finalBillingPrice = defaultPrice45 + Config.extraZonePrice10
                                            else
                                                finalBillingPrice = defaultPrice45
                                            end

                                            TriggerServerEvent('mmo-speedcameras:PayBill45Zone', finalBillingPrice,
                                                street1name, street2name, math.floor(SpeedMPH))
                                        else
                                            TriggerServerEvent('mmo-speedcameras:PayBill45Zone', finalBillingPrice,
                                                street1name, street2name, math.floor(SpeedMPH))
                                        end

                                        hasBeenCaught = true
                                        Wait(5000) -- This is here to make sure the player won't get fined over and over again by the same camera
                                    end
                                end)
                            end
                        end
                    end

                    hasBeenCaught = false
                end
            end
        end

        -- 55 zone
        for k in pairs(Config.Speedcamera55Zone) do
            local plyCoords = GetEntityCoords(PlayerPedId(), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.Speedcamera55Zone[k].x, Config.Speedcamera55Zone[k].y,
                Config.Speedcamera55Zone[k].z)

            if dist <= 20.0 then
                local playerPed = PlayerPedId()
                local playerCar = GetVehiclePedIsIn(playerPed, false)
                local veh = GetVehiclePedIsIn(playerPed)
                local SpeedMPH = GetEntitySpeed(playerPed) * 2.2369
                local playerPos = GetEntityCoords(myPed)
                local maxSpeed = 56.0 -- THIS IS THE MAX SPEED IN mph

                if SpeedMPH > maxSpeed then
                    if IsPedInAnyVehicle(playerPed, false) then
                        if (GetPedInVehicleSeat(playerCar, -1) == playerPed) then
                            if hasBeenCaught == false then
                                QBCore.Functions.GetPlayerData(function(PlayerData)
                                    if PlayerData.job.name == "police" or PlayerData.job.name == "ambulance" then
                                    else
                                        -- ALERT POLICE (START)
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
                                        -- ALERT POLICE (END)								

                                        -- FLASHING EFFECT (START)
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
                                        -- FLASHING EFFECT (END)		

                                        plate = QBCore.Functions.GetPlate(veh)

                                        street1, street2 = GetStreetNameAtCoord(playerPos.x, playerPos.y, playerPos.z)
                                        street1name = GetStreetNameFromHashKey(street1)
                                        street2name = GetStreetNameFromHashKey(street2)

                                        -- Normal Notifications
                                        -- QBCore.Functions.Notify("Speeding fine (55 mph zone) - Your speed: " .. math.floor(SpeedMPH) .. " mph", 'primary', 7500)

                                        if Config.useBilling == true then
                                            if SpeedMPH >= maxSpeed + 30 then
                                                finalBillingPrice = Config.defaultPrice55 + Config.extraZonePrice30
                                            elseif SpeedMPH >= maxSpeed + 20 then
                                                finalBillingPrice = Config.defaultPrice55 + Config.extraZonePrice20
                                            elseif SpeedMPH >= maxSpeed + 10 then
                                                finalBillingPrice = Config.defaultPrice55 + Config.extraZonePrice10
                                            else
                                                finalBillingPrice = Config.defaultPrice55
                                            end

                                            TriggerServerEvent('mmo-speedcameras:PayBill55Zone', finalBillingPrice,
                                                street1name, street2name, math.floor(SpeedMPH))
                                        else
                                            TriggerServerEvent('mmo-speedcameras:PayBill55Zone', finalBillingPrice,
                                                street1name, street2name, math.floor(SpeedMPH))
                                        end

                                        hasBeenCaught = true
                                        Wait(5000) -- This is here to make sure the player won't get fined over and over again by the same camera!
                                    end
                                end)
                            end
                        end
                    end

                    hasBeenCaught = false
                end
            end
        end

        -- 70 zone
        for k in pairs(Config.Speedcamera70Zone) do
            local plyCoords = GetEntityCoords(PlayerPedId(), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.Speedcamera70Zone[k].x, Config.Speedcamera70Zone[k].y,
                Config.Speedcamera70Zone[k].z)

            if dist <= 20.0 then
                local playerPed = PlayerPedId()
                local playerCar = GetVehiclePedIsIn(playerPed, false)
                local veh = GetVehiclePedIsIn(playerPed)
                local SpeedMPH = GetEntitySpeed(playerPed) * 2.2369
                local playerPos = GetEntityCoords(myPed)
                local maxSpeed = 71.0 -- THIS IS THE MAX SPEED IN mph

                if SpeedMPH > maxSpeed then
                    if IsPedInAnyVehicle(playerPed, false) then
                        if (GetPedInVehicleSeat(playerCar, -1) == playerPed) then
                            if hasBeenCaught == false then
                                QBCore.Functions.GetPlayerData(function(PlayerData)
                                    if PlayerData.job.name == "police" or PlayerData.job.name == "ambulance" then
                                    else
                                        -- ALERT POLICE (START)
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
                                        -- ALERT POLICE (END)

                                        -- FLASHING EFFECT (START)
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
                                        -- FLASHING EFFECT (END)

                                        plate = QBCore.Functions.GetPlate(veh)

                                        street1, street2 = GetStreetNameAtCoord(playerPos.x, playerPos.y, playerPos.z)
                                        street1name = GetStreetNameFromHashKey(street1)
                                        street2name = GetStreetNameFromHashKey(street2)

                                        -- Normal Notifications
                                        -- QBCore.Functions.Notify("Speeding fine (70 mph zone) - Your speed: " .. math.floor(SpeedMPH) .. " mph", 'primary', 7500)

                                        if Config.useBilling == true then
                                            if SpeedMPH >= maxSpeed + 30 then
                                                finalBillingPrice = Config.defaultPrice70 + Config.extraZonePrice30
                                            elseif SpeedMPH >= maxSpeed + 20 then
                                                finalBillingPrice = Config.defaultPrice70 + Config.extraZonePrice20
                                            elseif SpeedMPH >= maxSpeed + 10 then
                                                finalBillingPrice = Config.defaultPrice70 + Config.extraZonePrice10
                                            else
                                                finalBillingPrice = Config.defaultPrice70
                                            end

                                            TriggerServerEvent('mmo-speedcameras:PayBill70Zone', finalBillingPrice,
                                                street1name, street2name, math.floor(SpeedMPH))
                                        else
                                            TriggerServerEvent('mmo-speedcameras:PayBill70Zone', finalBillingPrice,
                                                street1name, street2name, math.floor(SpeedMPH))
                                        end

                                        hasBeenCaught = true
                                        Wait(5000) -- This is here to make sure the player won't get fined over and over again by the same camera!
                                    end
                                end)
                            end
                        end
                    end

                    hasBeenCaught = false
                end
            end
        end
    end
end)

RegisterNetEvent('mmo-speedcameras:client:SendBillEmail', function(amount, street1name, street2name, travelSpeed)
    SetTimeout(math.random(5000, 7000), function()
        local gender = "Mr."
        if QBCore.Functions.GetPlayerData().charinfo.gender == 1 then
            gender = "Mrs."
        end

        local speedType = "MPH"

        local charinfo = QBCore.Functions.GetPlayerData().charinfo
        TriggerServerEvent('qb-phone:server:sendNewMail', {
            sender = "SAS Traffic Control",
            subject = "Speeding Ticket",
            message = "Dear " .. gender .. " " .. charinfo.lastname ..
                "<br/><br/>Hereby, we inform you that you have received a speeding ticket on <strong>" .. street1name ..
                " / " .. street2name .. "</strong>.<br/><br/>Your driving speed was <strong>" .. travelSpeed .. " " ..
                speedType .. "</strong><br/><br/>Vehicle license plate: <strong>" .. plate ..
                "</strong><br/><br/>Total fine: <strong>$" .. amount .. "</strong><br/>"
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
