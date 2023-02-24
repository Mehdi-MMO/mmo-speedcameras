fx_version 'cerulean'
game 'gta5'
lua54 'yes'

title "mmo-speedcameras"
author "Mehdi MMO - Sweet Vibes#7561"
description "A QBCore Based SpeedCameras Script "
version "1.0.0"

-- Discord http://discord.gg/FqQFzndxZ4

shared_scripts {'config.lua'}

server_scripts {'server/*.lua'}

client_scripts {'client/*.lua'}

ui_page('html/index.html')

files {'html/*.html'}
