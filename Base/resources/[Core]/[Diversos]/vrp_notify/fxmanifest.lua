fx_version 'adamant'
game 'gta5'

client_scripts {
	"@vrp/lib/utils.lua",
	'client.lua',
}

server_scripts {
	"@vrp/lib/utils.lua",
	'server.lua',
}

files {
	"html/main.js",
	"html/index.html",
	"html/main.css",
	"html/assets/demo.ogg",
	"html/assets/lock.wav",
	"html/assets/*.png"
}

ui_page 'html/index.html'