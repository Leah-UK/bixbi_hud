--[[----------------------------------
Creation Date:	29/11/21
]]------------------------------------
fx_version 'cerulean'
game 'gta5'
author 'Leah#0001'
version '1.0.0'
versioncheck 'https://raw.githubusercontent.com/Leah-UK/bixbi_hud/main/fxmanifest.lua'
lua54 'yes'

shared_scripts {
	'@es_extended/imports.lua',
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

ui_page 'ui/index.html'
files {
    'ui/*.html',
    'ui/*.js',
    'ui/*.css',
}

escrow_ignore {
	'*'
}