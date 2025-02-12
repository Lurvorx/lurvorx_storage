-----------------------------------------------------------
--                                                       --
--                    Lurvorx Scripts                    --
--      Providing high-quality scripts just for you      --
--                   -----------------                   --
--                 Website: Coming soon                  --
--            Discord: discord.gg/nGv4gZzRBJ             --
--                                                       --
-----------------------------------------------------------

fx_version "cerulean"
game "gta5"
lua54 "yes"

author "Lurvorx Scripts"
description "An easy manageable storage system with ox_lib."
version "1.0.0"

client_script {
    "source/client/function.lua",
    "source/client/main.lua"
}

server_script {
    "source/server/function.lua",
    "source/server/main.lua",
    "@oxmysql/lib/MySQL.lua"
}

shared_scripts {
    "shared/config.lua",
    "@ox_lib/init.lua"
}

escrow_ignore {
    "shared/config.lua",
    "fxmanifest.lua"
}

dependencies {
    "ox_lib",
    "ox_inventory",
    "ox_target"
}