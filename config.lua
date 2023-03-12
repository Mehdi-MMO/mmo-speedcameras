-- Discord http://discord.gg/FqQFzndxZ4
Config = {}

-- OPTIONS: (true/false)
Config.useNDCore = false -- false for qbcore
Config.byPassedJobs = {
    ["LSPD"] = true,
    ["EMS"] = true,
    ["police"] = true,
    ["ambulance"] = true
}
Config.useBilling = true
Config.SendEmail = true
Config.useCameraSound = true
Config.useFlashingScreen = true
Config.useBlips = true
Config.alertSpeed = 150 -- (1-1000 MPH)

-- The speeding ticket price range
-- 45, 55, 70
Config.defaultPrice = {math.random(30, 45) , math.random(50, 75) , math.random(80, 90)}
-- Over Limit Price Adds
Config.extraZonePrice = {10, 20, 30}

Config.blips = { -- 45 MPH ZONES
{
    title = "Speedcamera (45)",
    colour = 1,
    id = 1,
    x = -524.2645,
    y = -1776.3569,
    z = 21.3384
}, -- 55 MPH ZONES
{
    title = "Speedcamera (55)",
    colour = 1,
    id = 1,
    x = 2506.0671,
    y = 4145.2431,
    z = 38.1054
}, {
    title = "Speedcamera (55)",
    colour = 1,
    id = 1,
    x = 1258.2006,
    y = 789.4199,
    z = 104.2190
}, {
    title = "Speedcamera (55)",
    colour = 1,
    id = 1,
    x = 980.9982,
    y = 407.4164,
    z = 92.2374
}, -- 70MPH ZONES
{
    title = "Speedcamera (70)",
    colour = 1,
    id = 1,
    x = 1584.9281,
    y = -993.4557,
    z = 59.3923
}, {
    title = "Speedcamera (70)",
    colour = 1,
    id = 1,
    x = 2442.2006,
    y = -134.6004,
    z = 88.7765
}, {
    title = "Speedcamera (70)",
    colour = 1,
    id = 1,
    x = 2871.7951,
    y = 3540.5795,
    z = 53.0930
}}

-- 45 MPH ZONES
Config.Speedcamera45Zone = {{
    x = -524.2645,
    y = -1776.3569,
    z = 21.3384
}, {
    x = 224.24,
    y = -626.12,
    z = 39.79
} -- PB Hospital
}

-- 55 MPH ZONES
Config.Speedcamera55Zone = {{
    x = 2506.0671,
    y = 4145.2431,
    z = 38.1054
}, {
    x = 1258.2006,
    y = 789.4199,
    z = 103.2190
}, {
    x = 980.9982,
    y = 407.4164,
    z = 92.2374
}}

-- 70MPH ZONES
Config.Speedcamera70Zone = {{
    x = 1584.9281,
    y = -993.4557,
    z = 59.3923
}, {
    x = 2442.2006,
    y = -134.6004,
    z = 88.7765
}, {
    x = 2871.7951,
    y = 3540.5795,
    z = 53.0930
}}
