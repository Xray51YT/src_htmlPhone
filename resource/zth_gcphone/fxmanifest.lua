fx_version "cerulean"

game "gta5"

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/static/css/app.css',
	'html/static/js/app.js',
	'html/static/js/manifest.js',
	'html/static/js/vendor.js',

	'html/static/config/config.json',
	
	'html/static/img/app_dati/*',
	'html/static/img/app_email/*',
	'html/static/img/app_favourites/*',
	'html/static/img/app_instagram/*',
	'html/static/img/app_settings/*',
	'html/static/img/app_whatsapp/*',
	'html/static/img/background/*',
	'html/static/img/cover/*',
	'html/static/img/dati/*',
	'html/static/img/icons_app/*',
	'html/static/img/twitter/*',

	'html/static/img/*.png',
	'html/static/fonts/*',

	'html/static/sound/*',
}

client_script {
	"config.lua",
	"shared.lua",
	"client/animation.lua",
	"client/client.lua",

	"client/photo.lua",
	"client/app_tchat.lua",
	"client/bank.lua",
	"client/twitter.lua",
	"client/instagram.lua",
	"client/whatsapp.lua",
	"client/cover.lua",
	"client/bluetooth.lua",
	"client/suoneria.lua",
	"client/modem.lua",
	"client/darkweb.lua",
	"client/email.lua",
	"client/news.lua"
}

server_script {
	'@mysql-async/lib/MySQL.lua',
	"config.lua",
	"shared.lua",
	"server/server.lua",

	"server/app_tchat.lua",
	"server/twitter.lua",
	"server/instagram.lua",
	"server/bank.lua",
	"server/whatsapp.lua",
	"server/cover.lua",
	"server/bluetooth.lua",
	"server/suoneria.lua",
	"server/modem.lua",
	"server/darkweb.lua",
	"server/email.lua",
	"server/news.lua"
}

data_file 'DLC_ITYP_REQUEST' 'stream/bk_phone.ytyp'
