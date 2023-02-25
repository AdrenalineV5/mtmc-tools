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
        

/createpolyzone

Starts the polyzone creator
E : adds points to zone vectors
Delete : removes last point from vectors


Press enter/return to copy the following to the clipboard

    local name = 'test'

    local vectors = 

    {

    vector2(-78.894836425781,-1084.9809570313),

    vector2(-81.515068054199,-1087.6856689453),

    vector2(-84.180816650391,-1091.7683105469),

    vector2(-82.564666748047,-1097.3762207031),

    vector2(-76.743995666504,-1100.9362792969),

    vector2(-69.348655700684,-1096.087890625),

    vector2(-67.446556091309,-1088.1253662109),

    }
    local minZ = 15.174879074097
    local maxZ = 30.174879074097
    local isInside = false
    local zone = PolyZone:Create(vectors, {
    name="zone",
    minZ=minZ,
    maxZ=maxZ,
    debugGrid=true,
    gridDivisions=25,
    useZ = true
    })

    zone:onPlayerInOut(function(isPointInside, point)
        isInside = isPointInside
    end)