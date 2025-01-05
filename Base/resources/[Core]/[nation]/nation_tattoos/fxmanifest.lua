fx_version "adamant"
game "gta5"

ui_page_preload 'yes'

ui_page "nui/index.html"

files {
	"nui/**",
	"addons/**",
}

client_scripts {
	"@vrp/lib/utils.lua",
	"client_config.lua",
	"client.lua"
} 

server_script {
	"@vrp/lib/utils.lua",
	"server_config.lua",
	"server.lua"
}


data_file 'TATTOO_SHOP_DLC_FILE' 'addons/mpheist3/shop_tattoo.meta'
data_file 'PED_OVERLAY_FILE' 'addons/mpheist3/mpheist3_overlays.xml'
data_file 'TATTOO_SHOP_DLC_FILE' 'addons/mpvinewood/shop_tattoo.meta'
data_file 'PED_OVERLAY_FILE' 'addons/mpvinewood/mpvinewood_overlays.xml'
data_file 'TATTOO_SHOP_DLC_FILE' 'addons/mpheist4/shop_tattoo.meta'
data_file 'PED_OVERLAY_FILE' 'addons/mpheist4/mpheist4_overlays.xml'

