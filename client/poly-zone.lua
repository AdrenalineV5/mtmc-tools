RegisterCommand("createpolyzone",function(args)
    print("sdasd")
    createPoly()
end)

function createPoly()
    local target = Poly:create(function(vectors,maxZ,minZ)


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
            local boxData = polyString(dialog.name,vectors,maxZ,minZ)
            sendData(boxData)
            QBCore.Functions.Notify("BoxZone Copied!", "success", 3000)
        end
    
    
        end,function()
            QBCore.Functions.Notify("Cancelled!", "info", 3000)
        end)
end

function polyString(name,vectors,maxZ,minZ)
    local content = [[
        local name = ']] .. name .. [['

        local vectors = ]] .. vectorsToString(vectors) .. [[

        local minZ = ]] .. minZ .. [[

        local maxZ = ]] .. maxZ .. [[

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
        ]]
        return content
end

function vectorsToString(vectors)
    local vString = '\n\r{\n\r'
    for i, v in pairs(vectors) do
        vString = vString .. "vector2(" .. v.x .. ","..v.y.."),\n\r"
    end
    vString = vString .. "}"
    return vString
end

Poly = {}


function Poly:create(cb,cancelCb)
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
    self.vectors = {}
    self.zone = nil
    self.maxZOffset = 15.0
    self.currentMinZ = nil
    function self:Process(flag)
        

        Citizen.CreateThread(function()
            while self.isRunning do
                Wait(0)
                if(self.endCoords) then
                    if(self.endCoords ~= 1) then
                        local radius = self.radius
                        DrawMarker(28, self.endCoords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.2, 0.2, 0, 200, 0, 48, false, false, 2, nil, nil, false)
                        if(IsControlJustPressed(0,38)) then
                            if(not self.currentMinZ) then
                                self.currentMinZ = self.endCoords.z - 10.0
                            else
                                if(self.endCoords.z - 10.0 < self.currentMinZ) then
                                    self.currentMinZ = self.endCoords.z - 10.0
                                end
                            end
                            table.insert(self.vectors,vector2(self.endCoords.x,self.endCoords.y))
                            self:redraw()
                        end

                        if(IsControlJustPressed(0,18)) then -- enter
                            self.isRunning = false
                            if(self.zone) then
                                self.zone:destroy()
                            end
                            self.cb(self.vectors,self.currentMinZ + self.maxZOffset,self.currentMinZ)
                        end

                        if(IsControlJustPressed(0,16)) then -- scroll down
                            if(self.zone) then
                                if((self.zone.maxZ - 2) > self.zone.minZ) then
                                    self.maxZOffset = self.maxZOffset - 1
                                    self.zone.maxZ = self.currentMinZ + self.maxZOffset
                                end
                            end
                        end
                        if(IsControlJustPressed(0,17)) then -- scroll up
                            if(self.zone) then
                                self.maxZOffset = self.maxZOffset + 1
                                self.zone.maxZ = self.currentMinZ + self.maxZOffset
                            end
                        end
                        if(IsControlJustPressed(0,178)) then
                            if(#self.vectors > 0) then
                                table.remove(self.vectors,#self.vectors)
                                self:redraw()
                            end
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

    function self:redraw()
        if(self.zone) then
            self.zone:destroy()
        end
        if(#self.vectors > 0) then
            local maxZ = self.currentMinZ + self.maxZOffset
            self.zone = PolyZone:Create(self.vectors, {
                name="zone",
                minZ=self.currentMinZ,
                maxZ=maxZ,
                debugGrid=true,
                gridDivisions=25,
                useZ = true
            })
        end
    end

    self:Process(511)

    return self
end
