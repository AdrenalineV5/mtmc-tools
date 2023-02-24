fx_version 'cerulean'

lua54 'yes'

games { 'gta5' }

shared_scripts {
    '@qb-core/import.lua',
    'configs/*.*'
}

client_scripts {
    '@PolyZone/client.lua',
	'@PolyZone/CircleZone.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    'client/*.*'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.*'
}

files {
    'ui/*.*'
}

ui_page 'ui/index.html'


escrow_ignore {
    'configs/*.*'
}

dependencies {
    'qb-target'
}
