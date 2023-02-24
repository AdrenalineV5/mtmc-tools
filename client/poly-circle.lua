RegisterCommand("createcirclezone",function()
    startCircle()
end)

function startCircle()
    local target = Target:create(function(coords,radius)

    
    local dialog = exports['qb-input']:ShowInput({
        header = "Zone Name",
        submitText = "Export",
        inputs = {
            {
                text = "Name", -- text you want to be displayed as a place holder
                name = "name", -- name of the input should be unique otherwise it might override
                type = "text", -- type of the input
                isRequired = true, -- Optional [accepted values: true | false] but will submit the form if no value is inputted
            },
        }
    })

    if(dialog) then
        local circleData = polyCircleString(dialog.name,coords.x,coords.y,coords.z,radius)
        sendData(circleData)
        QBCore.Functions.Notify("Circle Zone Copied!", "success", 3000)
    end

   
    end,function()
        QBCore.Functions.Notify("Cancelled!", "info", 3000)
    end)
end



function polyCircleString(name,x,y,z,radius)
    local content = [[
        local name = ']] .. name .. [['

        local radius = ]] .. radius .. [[ 

        local coords = vector3(]] .. x .. "," .. y .."," .. z .. ")" .. [[ 

        local isInside = false
        local zone = CircleZone:Create(coords, radius, {
            name = name,
            debugPoly = Config.Debug,
            useZ = true
        })
        
        zone:onPlayerInOut(function(isPointInside, point)
            isInside = isPointInside
        end)
        ]]
        return content
end

Target = {}


function Target:create(cb,cancelCb)
    local self = {}
    self.isRunning = true
    self.retval = false
    self.hit = false
    self.endCoords = false 
    self.surfaceNormal = false 
    self.materialHash = false
    self.entityHit = false
    self.cb = cb
    self.radius = 0.5
    self.cancelCb = cancelCb

    function self:Process(flag)
        

        Citizen.CreateThread(function()
            while self.isRunning do
                Wait(0)
                if(self.endCoords) then
                    if(self.endCoords ~= 1) then
                        local radius = self.radius
                        DrawMarker(28, self.endCoords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, radius, radius, radius, 0, 200, 0, 48, false, false, 2, nil, nil, false)
                        if(IsControlJustPressed(0,38)) then
                            self.isRunning = false
                            self.cb(self.endCoords,self.radius)
                        end
                        if(IsControlJustPressed(0,16)) then
                            self.radius = self.radius + 0.1
                        end
                        if(IsControlJustPressed(0,17)) then
                            self.radius = self.radius - 0.1
                        end
                        if(IsControlJustPressed(0,177)) then
                            self.isRunning = false
                            if(self.cancelCb) then
                                self.cancelCb()
                            end
                        end
                    end
                end
            end
        end)
    
        while self.isRunning do
            Wait(0)
            self.hit, self.entityHit, self.endCoords = RaycastFromCamera(flag)
            entityType = entityHit ~= 0 and GetEntityType(entityHit) or 0
        end

    end

    self:Process(511)

    return self
end


