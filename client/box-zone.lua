BoxTarget = {}

RegisterCommand("createboxzone",function()
    startBox()
end)

function startBox()
    local target = BoxTarget:create(function(coords,length,width,heading)


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
        local boxData = boxString(dialog.name,coords.x,coords.y,coords.z,length,width,heading)
        sendData(boxData)
        QBCore.Functions.Notify("BoxZone Copied!", "success", 3000)
    end


    end,function()
        QBCore.Functions.Notify("Cancelled!", "info", 3000)
    end)
end

function boxString(name,x,y,z,length,width,heading)
    local content = [[
        local name = ']] .. name .. [['

        local length = ]] .. length .. [[

        local width = ]] .. width .. [[

        local heading = ]] .. heading .. [[

        local coords = vector3(]] .. x .. "," .. y .."," .. z .. ")" .. [[

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
        ]]
        return content
end


function BoxTarget:create(cb,cancelCb)
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
    self.zone = nil
    self.length = 5.0
    self.width = 5.0
    self.maxZOffset = 5.0
    self.savedCoords = nil
    self.heading = GetEntityHeading(PlayerPedId())

    function self:Process(flag)
        self:renderZone()

        Citizen.CreateThread(function()
            while self.isRunning do
                Wait(0)
                if(self.endCoords) then
                    if(self.endCoords ~= 1) then
                        local radius = self.radius
                        if(self.zone) then
                            self.zone:destroy()
                        end

                        DrawMarker(28, self.endCoords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, radius, radius, radius, 0, 200, 0, 48, false, false, 2, nil, nil, false)
                        if(IsControlJustPressed(0,38)) then
                            self.savedCoords = self.endCoords
                            if(self.zone) then
                                self.zone:destroy()
                            end
                            self.zone = BoxZone:Create(self.savedCoords, self.length, self.width, {
                                name='zone',
                                heading=self.heading,
                                debugPoly=false,
                                minZ=self.savedCoords.z,
                                maxZ=self.savedCoords.z + self.maxZOffset
                            })
                        end

                        if IsControlPressed(0, 19) then -- alt held down & right arrow
                            if(self.zone) then
                                if(IsControlPressed(0,175)) then -- right arrow
                                    if(self.zone) then
                                        self.zone:setLength(self.zone.length + 0.2)
                                        self.length = self.zone.length
                                        Wait(100)
                                    end
                                end
                                if(IsControlPressed(0,174)) then -- left arrow
                                    if(self.zone) then
                                        if(self.zone.length > 1) then
                                            self.zone:setLength(self.zone.length - 0.2)
                                            self.length = self.zone.length
                                        end
                                        Wait(100)
                                    end
                                end
                                if(IsControlPressed(0,172)) then -- up arrow
                                    if(self.zone) then
                                        self.zone:setWidth(self.zone.width + 0.2)
                                        self.width = self.zone.width
                                        Wait(100)
                                    end
                                end
                                if(IsControlPressed(0,173)) then -- down arrow
                                    if(self.zone) then
                                        self.zone:setWidth(self.zone.width - 0.2)
                                        self.width = self.zone.width
                                        Wait(100)
                                    end
                                end
                            end
                        elseif(IsControlJustPressed(0,16)) then -- scroll down
                            if(self.zone) then
                                if((self.zone.maxZ - 2) > self.zone.minZ) then
                                    self.maxZOffset = self.maxZOffset - 1
                                    self.zone.maxZ = self.savedCoords.z + self.maxZOffset
                                end
                            end
                        elseif(IsControlJustPressed(0,17)) then -- scroll up
                            if(self.zone) then
                                self.maxZOffset = self.maxZOffset + 1
                                self.zone.maxZ = self.savedCoords.z + self.maxZOffset
                            end
                        elseif(IsControlPressed(0,175)) then -- right arrow
                            if(self.zone) then
                                self.heading = self.heading + 1.0
                                self.zone:setHeading(self.heading)
                            end
                        elseif(IsControlPressed(0,174)) then -- left arrow
                            if(self.zone) then
                                self.heading = self.heading - 1.0
                                self.zone:setHeading(self.heading)
                            end
                        end
                        if(IsControlJustPressed(0,177)) then -- escape
                            self.isRunning = false
                            if(self.cancelCb) then
                                self.cancelCb()
                            end
                        end
                        if(IsControlJustPressed(0,18)) then -- enter
                            self.isRunning = false
                            self.cb(self.savedCoords,self.length,self.width,self.heading)
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

    function self:renderZone()
        Citizen.CreateThread(function()
            while self.isRunning do
                Wait(0)
                if(self.zone) then
                    self.zone:draw()
                end
            end
        end)
    end

    self:Process(511)

    return self
end
