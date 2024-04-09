fx_version 'cerulean'
game 'gta5'
lua54 'yes'
description 'dirk-adBoards | discord.gg/dirkscripts | https://www.dirkscripts.com |'
version '1.0.0'

shared_scripts {
  '@ox_lib/init.lua',
  'config.lua',
}

client_scripts {
  'client.lua',
}

server_scripts  {
  'server.lua',
}

dependencies {
  'ox_lib',
  'dirk-core',
}

