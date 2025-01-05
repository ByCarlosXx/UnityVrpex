
fx_version "bodacious"
game "gta5"

author 'Wine Store' -- eunext_
contact 'https://discord.gg/PNZZnFXNG9'
version '3.6'

--##[ NÃO MECHA ABAIXO ]##- 

ui_page "src/front-end/index.html" -- html code

client_scripts { -- client codes 
	"@vrp/lib/utils.lua",
    "config/config_garage.lua",  -- config code
	"config/config_hash.lua", -- config car hash code
	"src/module/module_cl.lua",
	"src/client_garage.lua"
}

server_scripts { -- server codes
	"@vrp/lib/utils.lua",
    "config/config_garage.lua",  -- config code
	"config/config_hash.lua", -- config car hash code
	"src/server_garage.lua"
}

escrow_ignore { -- config code
	"config/config_garage.lua",
}

files { -- files 
	"src/front-end/*",
	"src/front-end/*.*",
	"src/front-end/**/*",
	"src/front-end/files-front/*.css",
	"src/front-end/files-front/*.js"
}

