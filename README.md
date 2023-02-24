**MTMC Tools**

*WIP* Currently work in progress

A tool to making code blocks a little easier...

**/createcirclezone**

Use the scroll wheel to increase/decrease the radius. 
Once you'e happy press 'E' to finish, this will copy the following to the clipboard

        local name = 'test'

        local radius = 1.9 

        local coords = vector3(245.32063293457,-1401.8787841797,29.584491729736) 

        local isInside = false
        local zone = CircleZone:Create(coords, radius, {
            name = name,
            debugPoly = Config.Debug,
            useZ = true
        })
        
        zone:onPlayerInOut(function(isPointInside, point)
            isInside = isPointInside
        end)
        

/createboxzone

Starts the boxzone creator use the following keys to adjust the zone
Scroll Up : Increase Z
Scroll Down : Decrease Z
Alt + Left Arrow : Decrease length
Alt + Right Arrow : Increase length
Alt + Down Arrow: Decrease Width
Alt + Up Arrow : Increase Width

Press enter/return to copy the following to the clipboard


        local name = 'test'

        local length = 2.6
        local width = 3.2
        local heading = 326.94802856445
        local coords = vector3(246.21980285645,-1405.1639404297,29.587503433228)
        local isInside = false
        local zone = BoxZone:Create(coords, length, width, {
            name='zone',
            heading=heading,
            debugPoly=false,
            minZ=coords.z - 10,
            maxZ=coords.z + 10
        })

        zone:onPlayerInOut(function(isPointInside, point)
            isInside = isPointInside
        end)
        