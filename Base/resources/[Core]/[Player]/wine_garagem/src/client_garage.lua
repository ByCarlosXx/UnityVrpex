-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPserver = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
DNext = {}
Tunnel.bindInterface("wine_garagem",DNext)
vSERVER = Tunnel.getInterface("wine_garagem")
local checkauth_wienes = false


-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local GaragesTable = Config.garages
local imagemCarro = Config.imgDiret
local nearestGarages = {}
local inGarage = false
local inAction = false
taxiBlip = nil
npcVeh = nil
vehPed = nil
local renderVehicles = {}
local VehiclesOut = {}
local interiorGarages = {--  

    ["garage_mazebank"] = {
        ["saida"] = { 
            ["blip"] = { -69.17, -814.31, 285.01 },
            ["veiculo"] = { -72.98, -814.01, 285.01, 151.66 }
        },
        ["spawns"] = {
            { -81.3, -825.47, 285.01, 297.33 },
            { -78.18, -826.8, 285.01, 297.33 },
            { -70.09, -821.05, 285.01, 65.65 },
            { -80.01, -812.53, 285.01, 247.46 },
            { -80.29, -816.78, 285.01, 247.96 },
            { -82.27, -821.87, 285.01, 239.86 },
        }
    },
    ["garage_centro"] = {
        ["saida"] = { 
            ["blip"] = { -139.05, -592.24, 167.01 },
            ["veiculo"] = { -141.23, -589.94, 167.01, 122.26 }
        },
        ["spawns"] = {
            { -154.91, -596.53, 167.01, 265.5 },
            { -152.6, -599.37, 167.01, 265.5 },
            { -142.47, -598.46, 167.01, 66.72 },
            { -144.09, -599.5, 167.01, 66.72 },
            { -146.95, -586.68, 167.01, 220.92 },
            { -149.5, -589.24, 167.01, 220.0 },
            { -153.92, -592.9, 167.01, 214.75 },
        }
    },
  
    ["pequena"] = {
        ["saida"] = { 
            ["blip"] = { 179.07,-1000.89,-98.99 },
            ["veiculo"] = { 174.58, -1004.28, -98.87, 2.23 }
         },
        ["spawns"] = {
            { 171.05, -1004.48, -98.87, 180.49 },
            { 174.44, -1004.23, -98.87, 179.37 },
        }
    },
    ["media"] = {
        ["saida"] = { 
            ["blip"] = { 207.05,-999.02,-98.99 },
            ["veiculo"] = { 202.58,-1005.38,-99.42,358.82 }
         },
        ["spawns"] = {
            { 192.71, -996.38, -98.99, 210.49 },
            { 196.59, -996.67, -98.99, 210.49 },
            { 200.18, -996.81, -98.99, 210.49 },

            { 193.3, -1002.49, -98.99, 267.85 },
            { 193.95, -1005.75, -98.99, 267.85 },
        }
    },
    ["grande"] = {
        ["saida"] = { 
            ["blip"] = { 241.01,-1004.85,-98.99 },
            ["veiculo"] = { 224.18,-1004.28,-99.42,358.57 }
         },
        ["spawns"] = {
            { 223.52, -978.67, -98.99, 235.51 },
            { 223.57, -982.09, -98.99, 235.51 },
            { 223.56, -985.12, -98.99, 235.51 },
            { 223.56, -988.78, -98.99, 235.51 },
            { 223.76, -992.55, -98.99, 235.51 },
            { 223.79, -995.58, -98.99, 235.51 },
            { 223.88, -999.28, -98.99, 235.51 },
            { 233.78, -980.08, -98.99, 117.93 },
            { 233.34, -983.61, -98.99, 117.93 },
            { 233.26, -987.2, -98.99, 117.93 },
            { 233.27, -990.57, -98.99, 117.93 },
            { 233.31, -994.21, -98.99, 117.93 },
        }
    },

    ["extra_grande"] = {
        ["saida"] = { 
            ["blip"] = { 1295.23, 217.56, -49.05 },
            ["veiculo"] = { 1254.04, 222.96, -47.93, 260.44 }
         },
        ["spawns"] = {

            { 1309.41, 228.8, -49.05, 83.93 },
            { 1309.05, 231.46, -49.05, 83.93 },
            { 1309.0, 235.04, -49.05, 83.93 },
            { 1309.3, 239.44, -49.05, 83.93 },
            { 1309.15, 242.93, -49.05, 83.93 },
            { 1309.31, 247.58, -49.05, 83.93 },
            { 1309.14, 251.27, -49.05, 83.93 },
            { 1309.07, 255.97, -49.05, 83.93 },
            { 1308.93, 258.93, -49.05, 83.93 },
            { 1296.08, 252.34, -49.05, 83.93 },
            { 1295.79, 248.32, -49.05, 83.93 },
            { 1295.43, 244.03, -49.05, 83.93 },
            { 1295.13, 240.35, -49.05, 83.93 },
            { 1295.29, 234.11, -49.05, 83.93 },
            { 1295.17, 230.35, -49.05, 83.93 },

            { 1280.85, 239.61, -49.05, 275.39 },

            { 1280.83, 243.25, -49.05, 275.39 },
            { 1280.82, 247.47, -49.05, 275.39 },
            { 1281.23, 251.18, -49.05, 275.39 },
            { 1281.08, 256.61, -49.05, 275.39 },
            { 1281.0, 259.83, -49.05, 275.39 }
        },
    },
    ["luxuosa"] = {
        ["saida"] = { 
            ["blip"] = { -1507.36, -3017.11, -79.24,357.60372924805 },
            ["veiculo"] = { -1520.92, -2978.5, -80.44,271.81 }
         },
        ["spawns"] = {
            {-1517.72,-2998.47,-82.63,328.73  },
            {-1512.72,-2998.47,-82.63,328.73  },
            {-1507.72,-2998.47,-82.63,328.73  },
            {-1502.72,-2998.47,-82.63,328.73  },
            {-1497.72,-2998.47,-82.63,328.73  },
            {-1517.33,-2987.74,-82.63,207.87  },
            {-1512.94,-2987.74,-82.63,207.87  },
            {-1507.94,-2987.74,-82.63,207.87  },
            {-1502.94,-2987.74,-82.63,207.87  },
            {-1497.94,-2987.74,-82.63,207.87  },
        }
    },
    ["wine"] = {
        ["saida"] = { 
            ["blip"] = { -315.6, -931.15, -51.05, 176.76 },
            ["veiculo"] = { -315.6, -931.15, -51.05, 176.76 }
         },
        ["spawns"] = {
            {-307.38, -930.63, -51.74,180.78 },
            {-304.17, -930.63, -51.74,180.78 },
            {-300.92, -930.63, -51.05,180.78 },
            {-297.68, -930.63, -51.05,180.78 },
            {-294.68, -930.63, -51.05,180.78 },
            {-291.48, -930.63, -51.05,180.78 },

            {-291.1, -946.06, -51.05,359.62 },
            {-294.1, -946.41, -51.05,359.62 },
            {-297.1, -946.41, -51.05,359.62 },
            {-301.1, -946.41, -51.05,359.62 },
            {-304.1, -946.41, -51.05,359.62 },
            {-307.1, -946.41, -51.05,359.62 },
----
            {-322.2, -946.99, -51.05,359.62 },
            {-326.2, -946.99, -51.05,359.62 },
            {-329.5, -946.99, -51.05,359.62 },
            {-332.7, -946.99, -51.05,359.62 },
            {-335.8, -946.99, -51.05,359.62 },
            {-339.1, -946.99, -51.05,359.62 },

            {-342.1, -946.99, -51.05,359.62 },
            {-345.7, -946.99, -51.05,359.62 },
            {-348.1, -946.99, -51.05,359.62 },
            {-351.1, -946.99, -51.05,359.62 },
            {-354.1, -946.99, -51.05,359.62 },
                       

            {-333.1, -930.54, -51.05,180.78 },
            {-336.4, -930.54, -51.05,180.78 },
            {-339.6, -930.54, -51.05,180.78 },
            {-343.1, -930.54, -51.05,180.78 },
            {-346.1, -930.54, -51.05,180.78 },
            {-349.6, -930.54, -51.05,180.78 },
            {-352.6, -930.54, -51.05,180.78 },
            {-355.6, -930.54, -51.05,180.78 },

            {-336.87, -923.5, -53.49,3.78 },
            {-340.87, -923.5, -53.49,3.78 },
            {-344.87, -923.5, -53.49,3.78 },
            {-348.87, -923.5, -53.49,3.78 },
         
        }
    },

    ["gigante"] = {
        ["saida"] = { 
            ["blip"] = { -2147.04, 1106.23, -24.66 },
            ["veiculo"] = { -2134.4, 1105.93, -26.74, 269.38 }
         },
        ["spawns"] = {

            { -2106.86, 1115.18, -27.29, 90.11 },
            { -2106.19, 1121.92, -27.25, 90.11 },
            { -2105.66, 1126.75, -27.25, 90.11 },
            { -2105.74, 1131.68, -27.29, 90.11 },
            { -2104.14, 1140.39, -27.29, 90.11 },

            { -2105.85, 1106.63, -27.28, 90.11 },
            { -2105.67, 1100.81, -27.28, 90.11 },
            { -2105.37, 1095.96, -27.29, 90.11 },

            { -2103.5, 1068.31, -27.24, 90.11 },
            { -2103.41, 1074.15, -27.24, 90.11 },
            { -2103.27, 1079.94, -27.24, 90.11 },

            { -2124.85, 1115.46, -27.29, 269.38 },
            { -2124.44, 1121.55, -27.29, 269.38 },
            { -2125.29, 1127.09, -27.29, 269.38 },
            { -2124.27, 1133.56, -27.29, 269.38 },
            { -2124.24, 1139.72, -27.25, 269.38 },

            { -2120.81, 1095.78, -27.26, 269.38 },
            { -2120.81, 1088.71, -27.26, 269.38 },
            { -2120.69, 1082.92, -27.24, 269.38 },
            { -2120.55, 1077.03, -27.24, 269.38 },
            { -2120.43, 1071.78, -27.24, 269.38 },
            { -2120.62, 1065.29, -27.25, 269.38 },
            { -2120.67, 1058.95, -27.25, 269.38 }
        },
    },

    
}


local ExclusiveInteriorGarages = {  

}


local ClientGaragebyWineStore = false


Citizen.CreateThread(function() 

	while true do

			ClientGaragebyWineStore = true
            for _id,_data in pairs(GaragesTable) do
                if interiorGarages[_data.name] or (_data.interior and (interiorGarages[_data.interior])) then
                    if _data.publica == true then
                        print()
                        blip = AddBlipForCoord(_data.entrada['blip'][1],_data.entrada['blip'][2],_data.entrada['blip'][3])
                        SetBlipSprite(blip,Config.BlipsGarage['BlipInMapa'])
                        SetBlipScale(blip,Config.BlipsGarage['TamanhoBlip'])
                        SetBlipColour(blip,Config.BlipsGarage['CorBlip'])
                        SetBlipDisplay(blip, 4)
                        SetBlipAsShortRange(blip, true)
                        BeginTextCommandSetBlipName("STRING")
                        AddTextComponentString(_data['nameGarage'])
                        EndTextCommandSetBlipName(blip)
                    end
                end
            end
			break
		Citizen.Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------

local function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.3, 0.3)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.005+ factor, 0.03, 41, 11, 41, 68)
end

local function CountTable(tab)
    local i = 0
    for _,_ in pairs(tab) do i = i + 1 end
    return i
end

local function isEmptyTable(tab)
    if type(tab) ~= "table" then return false end
    if not next(tab) then return true end
    return false
end

local function deepCopy(table)
	local final_table = {}
	for k, v in pairs(table) do
		if type(v) == "table" then
			v = deepCopy(v)
		end
		final_table[k] = v
	end
	return final_table
end

function table.clone(table)
	return deepCopy(table)
end

local function requestingCollision(x,y,z)
    RequestCollisionAtCoord(x,y,z)
    while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
        RequestCollisionAtCoord(x,y,z)
        Citizen.Wait(10)
    end
end

local function loadModel(modelo,cb)
    Citizen.CreateThread(function()

        if not IsModelInCdimage(modelo) then 
           -- --print("Model vehicle ("..tostring(modelo)..") it was not found.")
            cb(false) return
        end
        RequestModel(modelo)
        local i = 0
        while not HasModelLoaded(modelo) and i < 20000 do
            i = i + 1
            RequestModel(modelo)
            Citizen.Wait(10)
        end
        if i >= 20000 then cb(false) return end
        cb(true) return
    end)
end

local function checkBlackList(garageIndex,vehicle)
    if Config.blacklistCar[garageIndex] then
        for k,v in pairs(Config.blacklistCar[garageIndex]) do
            if v == vehicle then
                return false
            end
        end
    end
    if ExclusiveInteriorGarages[garageIndex] then
        for k,v in pairs(ExclusiveInteriorGarages[garageIndex]) do
            if v == vehicle then
                return true
            end
        end
    else
        return true
    end
end

local function reqControl(entity) NetworkRequestControlOfEntity(entity) cpt = 0 while not (NetworkHasControlOfEntity(entity)) do Wait(0) NetworkRequestControlOfEntity(entity) cpt = cpt +1 if cpt > 50 then break; end end end

local function HasVehClosestFromCoords(x,y,z,range)
    local handle, veh = FindFirstVehicle()
    local pointSpawn = vec3(x,y,z)
    local success
    repeat
        local pos = GetEntityCoords(veh)
        local distance = Vdist2(pointSpawn, pos, true)
        if distance <= range then
            EndFindVehicle(handle)
            return true
        end
    success, veh = FindNextVehicle(handle)
    until not success
    EndFindVehicle(handle)
    return false
end

--########################################################--
--# SPAWNAR VEICULO ######################################--
--########################################################--

local function spawnVeh(vname,plate,x,y,z,h,cb)
    Citizen.CreateThread(function()
  	
        if not HasVehClosestFromCoords(x,y,z,0.25) then
            local hash = vname
            if type(vname) == "string" then hash = GetHashKey(vname) end
            local _bol
            loadModel(hash,function(data) _bol = data end)
            while type(_bol) == "nil" and inGarage do Wait(0) end
            if _bol and inGarage then
                local vehicle = CreateVehicle(hash,x,y,z+0.1,h,true,false)

                NetworkRegisterEntityAsNetworked(vehicle)
                while not NetworkGetEntityIsNetworked(vehicle) do
                    NetworkRegisterEntityAsNetworked(vehicle)
                    Citizen.Wait(1)
                end

                SetVehicleNumberPlateText(vehicle,plate)
                NetworkRegisterEntityAsNetworked(vehicle)
                SetEntityAsMissionEntity(vehicle,true,true)
                SetVehicleNeedsToBeHotwired(verhicle,false)
                SetVehicleOnGroundProperly(vehicle)
                SetVehRadioStation(vehicle,"OFF")
                SetVehicleDoorsLocked(vehicle,1)
                
                SetNetworkIdCanMigrate(VehToNet(vehicle),true)
                NetworkSetNetworkIdDynamic(VehToNet(vehicle),false)
                SetNetworkIdExistsOnAllMachines(VehToNet(vehicle),true)
                SetVehicleOnGroundProperly(vehicle)
                SetVehicleDoorsLocked(vehicle,1)
                SetModelAsNoLongerNeeded(hash)
                cb(VehToNet(vehicle)) return
            end
        end
        cb(false) return
    end)
end


local function rendernizeVehicles(vehList,_interiorConfig,flags)
    local createdInVaga = {}
    local inLoading = {}
    local function totalLoaded()
        local c=0
        for _,status in pairs(inLoading) do
            if status == 'created' or status == 'canceled' then
                c = c + 1
            end
        end
        return c
    end
    Citizen.CreateThread(function()
 
        repeat
            vSERVER.updateVehiclesInBucket(renderVehicles)
            Wait(1000)
        until (CountTable(vehList) == totalLoaded())
        vSERVER.updateVehiclesInBucket(renderVehicles)
    end)
    for _,_data in pairs(vehList) do
            if (_data.work and _data.work == "false") or (_data.work == nil) then
                if not VehiclesOut[flags.garage] or (VehiclesOut[flags.garage] and not VehiclesOut[flags.garage][_data.name]) then

                    local _garageConfig = GaragesTable[inGarage]
                    if (_garageConfig.interior and checkBlackList(_garageConfig.interior,_data.name) or _garageConfig.name and checkBlackList(_garageConfig.name,_data.name)) and _data.detido ~= 3 then
                    -- if checkBlackList(inGarage,flags.name) and _data.detido ~= 3 then
                        local checkSlot = CountTable(createdInVaga) + 1
                        createdInVaga[checkSlot] = true
                        inLoading[checkSlot] = 'started'
                        if checkSlot > flags.maxSlots then 
                            break
                        else
                            Citizen.CreateThread(function()
       
                                local x,y,z,h = _interiorConfig['spawns'][checkSlot][1],_interiorConfig['spawns'][checkSlot][2],_interiorConfig['spawns'][checkSlot][3],_interiorConfig['spawns'][checkSlot][4]
                                local _bol,nveh
                                spawnVeh(_data.name,vRP.getRegistrationNumber(),x,y,z,h,function(data)
                                    if data == false then
                                        _bol = false
                                    else
                                        _bol = true
                                        nveh = data
                                    end
                                end)
                                while type(_bol) == "nil" and type(nveh) == "nil" and inGarage do 
                                    DrawMarker(32, x,y,z+1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.25, 1.25, 1.25, 158, 52, 235, 150, false, true, 2, nil, nil, false)
                                    Wait(0) 
                                end
                                
                                if _bol and inGarage then
                                   -- --print("1")
                                    inLoading[checkSlot] = 'created'
                                    if _data.detido and _data.detido ~= 0 then
                                        SetEntityAlpha(NetToVeh(nveh),200,false)
                                    end
                                    if not _data.inGarage then
                                        SetEntityAlpha(NetToVeh(nveh),50,false)
                                    end
                                    ----print("5")
                                    ----print(json.encode(_data))
                                    applyModifiesVeh(NetToVeh(nveh),_data.engine,_data.body,_data.fuel,_data.tuning,_data.plate,_data.vehDoors,_data.vehWindows,_data.vehTyres,_data.name)
                                    if nveh ~= nil then 
                                        if _data.inGarage then 
                                            table.insert(renderVehicles,{nveh = nveh,inGarage = inGarage}) 
                                        else
                                            table.insert(renderVehicles,{nveh = nveh,inGarage = false}) 
                                        end
                                    end
                                else
                                    inLoading[checkSlot] = 'canceled'
                                    createdInVaga[checkSlot] = nil
                                end
                            end)
                        end
                    end
                end
            end
    end
    
end

local function clearGarages(exceptNveh)
    for _id,_data in pairs(renderVehicles) do
        if NetworkDoesNetworkIdExist(_data.nveh) and _data.nveh ~= exceptNveh then

            if _data.inGarage then
                DNext.deleteVehicle(NetToVeh(_data.nveh),nil,_data.inGarage)
            else
                DNext.deleteVehicle(NetToVeh(_data.nveh),nil)
            end
            renderVehicles[_id] = nil
        end
    end
    if CountTable(renderVehicles) == 0 then renderVehicles = {} end
    vSERVER.updateVehiclesInBucket(renderVehicles)
end

local function exitGarages()
    if inGarage then
        DoScreenFadeOut(300)
        Citizen.Wait(300)
        local _id = inGarage
        inGarage = nil
        local _garageConfig = GaragesTable[_id]
        clearGarages()
        vSERVER.exitBucket()
        local x2,y2,z2
        if _garageConfig then
            if _garageConfig.entrada then
                x2,y2,z2 = _garageConfig.entrada['blip'][1],_garageConfig.entrada['blip'][2],_garageConfig.entrada['blip'][3]
            elseif type(_garageConfig[4]) == "string" then
                x2,y2,z2 = _garageConfig[1], _garageConfig[2], _garageConfig[3]
            elseif _garageConfig[1] then
                x2,y2,z2 = _garageConfig[1].x,_garageConfig[1].y,_garageConfig[1].z
            else
                x2,y2,z2 = 50.72,-874.15,30.43
            end
            SetEntityCoords(PlayerPedId(),x2,y2,z2)
            requestingCollision(x2,y2,z2)
            SetEntityCoords(PlayerPedId(),x2,y2,z2)
        end
        Citizen.Wait(400)
        DoScreenFadeIn(300)
    end
end

local function exitGarageWithVehicle(nveh)
    DoScreenFadeOut(300)
    Citizen.Wait(300)
    local _id = inGarage 
    local _garageConfig = GaragesTable[_id]
    local _interiorConfig 
    if _garageConfig.interior then
        _interiorConfig = interiorGarages[_garageConfig.interior]
    else
        _interiorConfig = interiorGarages[_garageConfig.name]
    end
    clearGarages(nveh)
    vSERVER.exitBucket(nveh)
    local x2,y2,z2,h2
    if _garageConfig.saida then
        x2,y2,z2,h2 = _garageConfig.saida[1],_garageConfig.saida[2],_garageConfig.saida[3],_garageConfig.saida[4]
    elseif _garageConfig.entrada then
        x2,y2,z2,h2 = _garageConfig.entrada['veiculo'][1],_garageConfig.entrada['veiculo'][2],_garageConfig.entrada['veiculo'][3],_garageConfig.entrada['veiculo'][4]
    elseif type(_garageConfig[4]) == "string" then
        x2,y2,z2 = _garageConfig[1], _garageConfig[2], _garageConfig[3]
    elseif _garageConfig[1] then
        x2,y2,z2,h2 = _garageConfig[1].x,_garageConfig[1].y,_garageConfig[1].z,_garageConfig[1].h
    end 
    if h2 == nil then h2 = 0.0 end
    DecorSetInt(NetToVeh(nveh),'rCollisionTime',GetNetworkTime()+Config.personalize['TempoColisao']*1000)
    SetEntityCoords(NetToVeh(nveh),x2,y2,z2)
    SetEntityHeading(NetToVeh(nveh),h2 or 0.0)
    requestingCollision(x2,y2,z2)
    SetEntityCoords(NetToVeh(nveh),x2,y2,z2)
    SetEntityHeading(NetToVeh(nveh),h2 or 0.0)
    SetPedIntoVehicle(PlayerPedId(),NetToVeh(nveh),-1)
    vSERVER._refreshOwnerVehicle(nveh)
    Citizen.Wait(400)
    DoScreenFadeIn(300)
    inGarage = nil
    SetTimeout(1000,function()
        SetPedIntoVehicle(PlayerPedId(),NetToVeh(nveh),-1)
        Citizen.CreateThread(function()
     
            local x2,y2,z2 = x2,y2,z2
            while #(GetEntityCoords(PlayerPedId()) - vec3(x2,y2,z2)) < Config.personalize['VoltarColisao'] and IsPedInAnyVehicle(PlayerPedId(),false) and DecorExistOn(GetVehiclePedIsIn(PlayerPedId(),false),'rCollisionTime') do
                Citizen.Wait(250) 
            end
            if NetworkDoesNetworkIdExist(nveh) then
                local ent = NetworkGetEntityFromNetworkId(nveh)
                if ent and DoesEntityExist(ent) then
                    if DecorExistOn(ent,'rCollisionTime') then
                        DecorRemove(ent,'rCollisionTime')
                    end
                end
            end
        end)
    end)

end

local function drawTxtS(x,y ,width,height,scale, text, r,g,b,a,flags)
    local _scale = {0.25,0.25}
    if type(scale) == "table" then _scale = {scale[1],scale[2]} else _scale = {scale,scale} end
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(_scale[1], _scale[2])
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    if not flags or flags and flags.font == nil then SetTextFont(7) else 
        if type(flags.font) == "string" then
            SetTextFont(exports['core_stream']:GetAddonFont(flags.font))
        else
            SetTextFont(flags.font) 
        end
    end
    if not flags or flags and flags.outline == nil or flags.outline == true then SetTextOutline() end
    if not flags or flags and flags.shadow == nil or flags.shadow == true then SetTextDropShadow(0, 0, 0, 0,255) end
    if flags and flags.justify then SetTextJustification(flags.justify) end
    DrawText(x - width/2, y - height/2 + 0.005)
end

local rad, cos, sin = math.rad, math.cos, math.sin
local function rotate(origin, point, theta)
  if theta == 0.0 then return point end

  local p = point - origin
  local pX, pY = p.x, p.y
  theta = rad(theta)
  local cosTheta = cos(theta)
  local sinTheta = sin(theta)
  local x = pX * cosTheta - pY * sinTheta
  local y = pX * sinTheta + pY * cosTheta
  return vector2(x, y) + origin
end

local _thread_inGarages = false
function thread_inGarages(enter_x,enter_y)
    if _thread_inGarages then return end
    _thread_inGarages = true
    local _id = inGarage
    local exitingBlip = false
    local _garageConfig = GaragesTable[_id]
    local _interiorConfig 
    if _garageConfig.interior then
        _interiorConfig = interiorGarages[_garageConfig.interior]
    else
        _interiorConfig = interiorGarages[_garageConfig.name]
    end
    local interiorId = GetInteriorAtCoords(_interiorConfig.saida['blip'][1],_interiorConfig.saida['blip'][2],_interiorConfig.saida['blip'][3])
    while interiorId == nil or interiorId == 0 or interiorId == '' or interiorId == "nil" do
        interiorId = GetInteriorAtCoords(_interiorConfig.saida['blip'][1],_interiorConfig.saida['blip'][2],_interiorConfig.saida['blip'][3])
        Wait(10)
    end
    local CenterPos,rotX,rotY,rotZ,rotW,minX,minY,minZ,maxX,maxY,maxZ
    if interiorId ~= parseInt(0) then
        minX, minY, minZ, maxX, maxY, maxZ = GetInteriorEntitiesExtents(interiorId)
        CenterPos = vec3((minX+maxX)/parseInt(2), (minY+maxY)/parseInt(2),(minZ+maxZ)/parseInt(2))
        rotX,rotY,rotZ,rotW = GetInteriorRotation(interiorId)
    end

    Citizen.CreateThread(function()
    
        local breakIt = false
        while _thread_inGarages and inGarage and not breakIt do
            --// VERIFY USE EXIT HIT BOX GARAGES
            local coords = GetEntityCoords(PlayerPedId())
            local rotatedPoint = rotate(CenterPos.xy, coords.xy, -(rotZ or parseInt(0)))
            local pX, pY, pZ = rotatedPoint.x, rotatedPoint.y, coords.z
            if pX < minX or pX > maxX or pY < minY or pY > maxY then breakIt = true end
            if (minZ and pZ < minZ) or (maxZ and pZ > maxZ) then breakIt = true end

            if not IsMinimapInInterior() then
                SetPlayerBlipPositionThisFrame(enter_x,enter_y)
                HideMinimapInteriorMapThisFrame()
            else
                SetRadarZoomToDistance(parseInt(200))
                HideMinimapExteriorMapThisFrame()
            end
            Wait(4)
        end
        if _thread_inGarages and inGarage and breakIt and not exitingBlip then exitGarages() end
    end)

    Citizen.CreateThread(function()

        while _thread_inGarages and inGarage do
            local idle = 1000
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)

            if GetEntityHealth(ped) <= 101 then exitingBlip = true exitGarages() end
            if IsPedInAnyVehicle(ped,false) or GetVehiclePedIsTryingToEnter(ped) ~= 0 then
                DisableControlAction(0,86,true)
                local veh = GetVehiclePedIsUsing(ped,false)
                idle = 4
                local alpha = GetEntityAlpha(veh)
                if alpha == 255 then
                    if IsDisabledControlPressed(0,86) and not inAction and GetPedInVehicleSeat(veh,-1) == ped then
                        inAction = true
                        exitingBlip = true
                        exitGarageWithVehicle(VehToNet(veh))
                        SetTimeout(1500,function() inAction = false end)
                    end
                elseif alpha == 50 then
                    if GetIsVehicleEngineRunning(veh) then SetVehicleEngineOn(veh,false,true,true) end
                    DisableAllControlActions(0)
                    EnableControlAction(0,0,true)
                    EnableControlAction(0,1,true)
                    EnableControlAction(0,2,true)
                    EnableControlAction(0,3,true)
                    EnableControlAction(0,4,true)
                    EnableControlAction(0,5,true)
                    EnableControlAction(0,6,true)
                    EnableControlAction(0,75,true)
                    if not inAction then
                        drawTxtS(0.485,0.95,0.0,0.0,0.4,"Veiculo em outra ~r~Garagem~w~.", 255, 255, 255, 255,{justify = 0, font = 4})
                    end
                else
                    if GetIsVehicleEngineRunning(veh) then SetVehicleEngineOn(veh,false,true,true) end
                    DisableAllControlActions(0)
                    EnableControlAction(0,0,true)
                    EnableControlAction(0,1,true)
                    EnableControlAction(0,2,true)
                    EnableControlAction(0,3,true)
                    EnableControlAction(0,4,true)
                    EnableControlAction(0,5,true)
                    EnableControlAction(0,6,true)
                    EnableControlAction(0,75,true)
                    if not inAction then
                        drawTxtS(0.485,0.5,0.0,0.0,0.5,"Veiculo ~r~Desmanchado~w~", 255, 255, 255, 255,{justify = 0, font = 4})
                        drawTxtS(0.485,0.95,0.0,0.0,0.4,"Pressione ~p~E~w~ para quita-lo.", 255, 255, 255, 255,{justify = 0, font = 4})
                    end
                    if IsDisabledControlPressed(0,86) and not inAction then
                        inAction = true
                        Citizen.CreateThread(function()
    	
                            if vSERVER.paymentArrestVehicle(GetDisplayNameFromVehicleModel(GetEntityModel(veh))) then
                                ResetEntityAlpha(veh)
                                SetVehicleEngineOn(veh,true,true,false)
                                SetTimeout(1500,function()
                                    inAction = false
                                end)
                            else
                                SetTimeout(1500,function()
                                    inAction = false
                                end)
                            end
                        end)
                    end
                end
            else
                local _coords = vec3(_interiorConfig.saida['blip'][1],_interiorConfig.saida['blip'][2],_interiorConfig.saida['blip'][3])
                local dist = #(coords - _coords)
                if (dist < Config.personalize['DistanciaBlip']) and (not IsPedInAnyVehicle(ped,false)) then
                    idle = 4
                   -- DrawText3D(_coords.x,_coords.y,_coords.z, Config.drawMaker["Exit_garage"])
                    DrawMarker(Config.drawMaker["Sair"],_coords.x,_coords.y,_coords.z-0.2,0,0,0,0.0,0,0,0.5,0.5,0.5,Config.drawMaker["CorR"],Config.drawMaker["CorG"],Config.drawMaker["CorB"],100,0,0,0,1)
                    if IsControlJustPressed(1,38) and not inAction then
                        if ClientGaragebyWineStore == true then 
                            inAction = true
                            exitingBlip = true
                            exitGarages()
                            inAction = false
                        else
                            TriggerEvent('Notify','negado','Garagem não foi autenticada! fale com alguém da Wine Store!',5000)
                        end
                    end
                end
            end
            Citizen.Wait(idle)
        end
        _thread_inGarages = false
    end)
end

-- FUNCTION DE ENTRAR NA GARAGEM
local function enterGarage(_id,veh,vehList)
    if inGarage then return end
    inGarage = _id
    local ped = PlayerPedId()
    local _garageConfig = GaragesTable[_id]
    local _interiorConfig 
    if _garageConfig.interior then
        _interiorConfig = interiorGarages[_garageConfig.interior]
    else
        _interiorConfig = interiorGarages[_garageConfig.name]
    end
    -- local _workConfig = Config.workgarage[_garageConfig.name]
    local teleportCoords
    local teleportHeading

    if not vehList or isEmptyTable(vehList) then
        vehList = vSERVER.myVehicles(_id) or {}
    else
        local vehicles_service = vehList
        vehList = {}
        for k,v in pairs(vehicles_service) do
            table.insert(vehList,{ inGarage = true, name = v, vname = v, plate = nil, engine = 1000, body = 1000, fuel = 100, tuning = {} })
            -- vehList[k] = { name = v, vname = v, plate = nil, engine = 1000, body = 1000, fuel = 100, tuning = {} }
        end
        vehList = vSERVER.filterList(vehList)
    end
    local _garageConfig = GaragesTable[_id]
    for _vehId,_dataVeh in pairs(vehList) do
        if (_garageConfig.interior and not checkBlackList(_garageConfig.interior,_dataVeh.name) or _garageConfig.name and not checkBlackList(_garageConfig.name,_dataVeh.name)) then
            table.remove(vehList,_vehId)
        end 
    end


    local selected_Vehs = {}

    if vehList and CountTable(vehList) > CountTable(_interiorConfig['spawns']) then
        --print("aqui")
        -- DESENHAR NUI
        local nui_vehList = {}

        
        local plate = vRP.getRegistrationNumber()
        for _id,data in pairs(vehList) do
            local vname = GetDisplayNameFromVehicleModel(data.name)
            local _vname = (vname and vname.modelo) or data.name
            vehList[_id].vname = _vname
        
            
            table.insert(nui_vehList,data)
            if plate ~= nui_vehList[#nui_vehList].plate then 
                nui_vehList[#nui_vehList].vname2 = nui_vehList[#nui_vehList].vname
                
                nui_vehList[#nui_vehList].vname = nui_vehList[#nui_vehList].vname.." (Roubado)"
            end
            nui_vehList[#nui_vehList].name = nui_vehList[#nui_vehList].name.."#"..nui_vehList[#nui_vehList].plate
            nui_vehList[#nui_vehList].id = _id
        end
        --print(json.encode(nui_vehList))
        local ending = false
        SetNuiFocus(true,true)
        vRP._CarregarObjeto("amb@code_human_in_bus_passenger_idles@female@tablet@idle_a","idle_b","prop_cs_tablet",49,28422)
        
        SendNUIMessage({ action = "OpenTablet", vehicles = nui_vehList, type = "myvehicles", imgDiret = imagemCarro, fuel = GetVehicleFuelLevel(carroSpawnado), body = GetVehicleBodyHealth(carroSpawnado), engine = GetVehicleEngineHealth(carroSpawnado) })
        RegisterNUICallback("SelectCars",function(data,cb)
            SetNuiFocus(false,false)
            deletAnim()
            SendNUIMessage({ action = "CloseTablet" })
            
            ending = true

            local valor = string.sub(data.vehicles, 1, string.find(data.vehicles, "#")-1)
            for n,c in pairs(nui_vehList) do 
                if valor == c.vname then
                    selected_Vehs = {c.vname, c.id} 
                end
            end
        end)
        RegisterNUICallback("close",function(data,cb)
            SetNuiFocus(false,false)
            ending = "close"
        end)
        
        while not ending do Citizen.Wait(100) end
        UnregisterRawNuiCallback("SelectCars")
        UnregisterRawNuiCallback("close")
        deletAnim()
        if ending == "close" then
            return false
        end


        if #selected_Vehs > 0 then
            local _vehList = table.clone(vehList)
            vehList = {}
            for _,_vehicle in pairs(selected_Vehs) do
                for _id,_data in pairs(nui_vehList) do
                    if tonumber(_vehicle) == _id then 
                        table.insert(vehList, _vehList[_data.id] ) 
                        break 
                    end
                end
            end
        end
        for _id,_data in pairs(vehList) do
            local args = splitString(_data.name,'#')
            _data.name = args[1]
            if _data.vname2 then
                _data.vname = _data.vname2
                _data.vname2 = nil
            end
        end
    end
    Wait(1)
    local x2,y2,z2
    if _garageConfig.blip then
        x2,y2,z2 = _garageConfig.blip[1],_garageConfig.blip[2],_garageConfig.blip[3]
    elseif not _garageConfig.blip and _garageConfig.entrada then
        x2,y2,z2 = _garageConfig.entrada['blip'][1],_garageConfig.entrada['blip'][2],_garageConfig.entrada['blip'][3]
    elseif _garageConfig[1] then
        x2,y2,z2 = _garageConfig[1].x,_garageConfig[1].y,_garageConfig[1].z
    end

    if veh and DoesEntityExist(veh) then
        -- ENTER IN GARAGE WITH VEHICLE
       print("a")
        ped = veh
        teleportCoords = vec3(_interiorConfig.saida['veiculo'][1],_interiorConfig.saida['veiculo'][2],_interiorConfig.saida['veiculo'][3])
        teleportHeading = _interiorConfig.saida['veiculo'][4]
        local carID = GetVehiclePedIsIn(PlayerPedId(),false)
        local NomeDoCarro = GetDisplayNameFromVehicleModel(GetEntityModel(carID))
        -- --print(NomeDoCarro)
        vSERVER.SetVehicleInGarage(VehToNet(veh),_id,NomeDoCarro)
        vSERVER.placeInNewBucket(VehToNet(veh),vec3(x2,y2,z2))

        local nveh = VehToNet(veh)
        renderVehicles = {}

        table.insert(renderVehicles,{nveh = VehToNet(veh), inGarage = _id})
    else
        -- ENTER IN GARAGE WITHOUT VEHICLE
        teleportCoords = vec3(_interiorConfig.saida['blip'][1],_interiorConfig.saida['blip'][2],_interiorConfig.saida['blip'][3])
        vSERVER.placeInNewBucket({},vec3(x2,y2,z2))
    end
    local flags = {}
    flags.name = _garageConfig.name
    flags.maxSlots = CountTable(_interiorConfig['spawns'])
    if Config.workgarage[_garageConfig.name] then flags.garage = _garageConfig 
    else
        flags.garage = "personal"
    end
    DoScreenFadeOut(300)
	Citizen.Wait(300)
    requestingCollision(table.unpack(teleportCoords))
    SetEntityCoordsNoOffset(ped,teleportCoords + vec3(0.0,0.0,0.1),0,0,1)
    if teleportHeading then SetEntityHeading(ped,teleportHeading) end
    rendernizeVehicles(vehList,_interiorConfig,flags)

    thread_inGarages(teleportCoords.x,teleportCoords.y)
    Citizen.Wait(500)
    DoScreenFadeIn(400)
    return true
end

local function isServiceGarages(garageId)
    local _garageConfig = GaragesTable[garageId]
    if Config.workgarage[_garageConfig.name] then return true else return false end
end

local function isPublicGarages(garageId)
    local _garageConfig = GaragesTable[garageId]
    if not _garageConfig.interior and not Config.workgarage[_garageConfig.name] then 
        return true
    end
    return false
    -- if Config.workgarage[_garageConfig.name] then return true else return false end
end

local function isResidencialGaragesAndHasAccess(garageId)
    local _garageConfig = GaragesTable[garageId]
    if _garageConfig.interior and vSERVER.checkHasPermInHouse(_garageConfig.name) then
        return true
    end
    return false
end

-- FUNCTION DE DESENHAR A OPÇÃO DE ENTRAR (COM VEICULO)
local function enterDrawInVehicle(ped,veh,coords,_id,_data,vehList)
    local dist = #(vec3(_data.entrada['veiculo'][1],_data.entrada['veiculo'][2],_data.entrada['veiculo'][3]) - coords)
    if (dist <= Config.personalize['DistanciaBlip'] ) then
        idle = 4
        DrawMarker(Config.drawMaker["Entrar"],_data.entrada['veiculo'][1],_data.entrada['veiculo'][2],_data.entrada['veiculo'][3]-0.2,0,0,0,0.0,0,0,1.0,1.0,1.0,Config.drawMaker["CorR"],Config.drawMaker["CorG"],Config.drawMaker["CorB"],100,0,0,0,1)
      --  DrawText3D(_data.entrada['veiculo'][1],_data.entrada['veiculo'][2],_data.entrada['veiculo'][3],Config.drawMaker["Enter_garage"])
        DisableControlAction(0,86,true)
        if IsDisabledControlPressed(0,86) and not inAction and (isPublicGarages(_id) or isServiceGarages(_id) or isResidencialGaragesAndHasAccess(_id)) then
        -- if IsDisabledControlPressed(0,86) and not inAction and (not _data.interior or (_data.interior and (flags.garage == "personal" or vSERVER.checkHasPermInHouse(_data.name)) )) then
            inAction = true
            local veh = GetVehiclePedIsIn(ped,false)
            if not vSERVER.checkSearch() then
                if not _data.perm or vSERVER.checkPermission(_data.perm) then
                   -- --print(GetDisplayNameFromVehicleModel(GetEntityModel(veh)))
                    if vehList == nil and vSERVER.isOwnerOrStoledVehicle(GetDisplayNameFromVehicleModel(GetEntityModel(veh)),GetVehicleNumberPlateText(veh)) then
                        if not enterGarage(_id,veh,vehList) then inGarage = false end
                    else
                        if NetworkGetEntityIsNetworked(veh) then 
                            if vehList == nil then 
                                if vSERVER.requestStoledVehicle(GetDisplayNameFromVehicleModel(GetEntityModel(veh)),GetVehicleNumberPlateText(veh)) then
                                    DNext.deleteVehicle(veh,nil,_id) 
                                    SetTimeout(500,function()
                                        TriggerEvent("Notify","sucesso","Você roubou o veiculo com sucesso!",5000)
                                    end)
                                else
                                    DNext.deleteVehicle(veh,nil,_id) 
                                    SetTimeout(500,function()
                                        TriggerEvent("Notify","sucesso","Você devolveu o veiculo com sucesso!",5000)
                                    end)
                                end
                            else 
                                DNext.deleteVehicle(veh,nil) 
                                SetTimeout(500,function()
                                    TriggerEvent("Notify","sucesso","Você devolveu o veiculo com sucesso!",5000)
                                end)
                            end
                        end
                        if not enterGarage(_id,nil,vehList) then inGarage = false end
                    end
                    
                end
            end
            SetTimeout(1500,function()
                inAction = false
            end)
        end
    end
end

-- FUNCTION DE DESENHAR A OPÇÃO DE ENTRAR (SEM VEICULO)
local function enterDrawOutVehicle(ped,coords,_id,_data,vehList)
    local _garageConfig = GaragesTable[_id]
    local flags = {}
    flags.name = _garageConfig.name
    -- flags.maxSlots = CountTable(_interiorConfig['spawns'])
    if Config.workgarage[_garageConfig.name] then flags.garage = _garageConfig 
    else
        flags.garage = "personal"
    end

    local dist,xyz
    if _data.blip and _data.blip[1] then
        dist,xyz = #(vec3(_data.blip[1],_data.blip[2],_data.blip[3]) - coords),vec3(_data.blip[1],_data.blip[2],_data.blip[3]) 
    elseif _data.entrada and _data.entrada['blip'] then
        dist,xyz = #(vec3(_data.entrada['blip'][1],_data.entrada['blip'][2],_data.entrada['blip'][3]) - coords),vec3(_data.entrada['blip'][1],_data.entrada['blip'][2],_data.entrada['blip'][3])
    elseif (_data.x and _data.y and _data.z) then
        dist,xyz = #(vec3(_data.x,_data.y,_data.z) - coords),vec3(_data.x,_data.y,_data.z) 
    end
    if (dist <= Config.personalize['DistanciaBlip'] ) then
        idle = 4
        DrawMarker(Config.drawMaker["Entrar"],xyz.x,xyz.y,xyz.z-0.2,0,0,0,0.0,0,0,1.0,1.0,1.0,Config.drawMaker["CorR"],Config.drawMaker["CorG"],Config.drawMaker["CorB"],100,0,0,0,1)
        --DrawText3D(xyz.x,xyz.y,xyz.z,Config.drawMaker["Enter_garage"])
        if IsControlJustPressed(1,38) and not inAction and (isPublicGarages(_id) or isServiceGarages(_id) or isResidencialGaragesAndHasAccess(_id)) then
            if ClientGaragebyWineStore == true then 
            -- if IsControlJustPressed(1,38) and not inAction and (not _data.interior or (_data.interior and (flags.garage ~= "nil" or vSERVER.checkHasPermInHouse(_data.name)) )) then
                inAction = true
                if not vSERVER.checkSearch() then
                    if not _data.perm or vSERVER.checkPermission(_data.perm) then
                        if not enterGarage(_id,nil,vehList) then inGarage = false end
                    end
                end
                SetTimeout(1500,function()
                    inAction = false
                end)
            else
                TriggerEvent('Notify','negado','Garagem não foi autenticada! fale com alguém da Wine Store!',5000)
            end
        end
    end
end

-- FUNCTION DE DESENHAR A OPÇÃO DE INTERAGIR (GARAGEM SEM INTERIOR)
local function interactGarages(_id,_data,vehList,hasNPC,pessoalVehicles)
   
    if not vSERVER.checkSearch() and not _data.perm or vSERVER.checkPermission(_data.perm) and (not _data.payment or vSERVER.payGarage(_data.payment)) then

        local vehsService = {}
        local carroSpawnado = {}
        if not pessoalVehicles then
            for k,v in pairs(vehList) do
                local _garageConfig = GaragesTable[inGarage]
                local vname = GetDisplayNameFromVehicleModel(GetHashKey(v))
             
                vname = (vname and vname.modelo) or v
                vehsService[k] = { name = v, vname = vname }
                
            end
        else
            local plate = vRP.getRegistrationNumber()
            for k,v in pairs(vehList) do
                if v.inGarage then
                    table.insert(vehsService,v)
                    if plate ~= vehsService[#vehsService].plate then
                        carroSpawnado = vehsService[#vehsService].vname
                        vehsService[#vehsService].vname2 = vehsService[#vehsService].vname
                        vehsService[#vehsService].vname = vehsService[#vehsService].vname.." (Roubado)"
                    end
                    vehsService[#vehsService].id = k
                end
            end
        end
        local ending = false
        local selectedVeh
       -- --print(selectedVeh)
       -- local carroSpawn = GetHashKey(carroSpawnado) or carroSpawnado

      --  local carroSpawn = carroSpawn
        vRP._CarregarObjeto("amb@code_human_in_bus_passenger_idles@female@tablet@idle_a","idle_b","prop_cs_tablet",49,28422)
        SendNUIMessage({ action = "OpenTablet", vehicles = vehsService, type = "work", imgDiret = imagemCarro, fuel = 100, body = GetVehicleBodyHealth(selectedVeh), engine = GetVehicleEngineHealth(selectedVeh) })
        SetNuiFocus(true,true)
        RegisterNUICallback("SpawnVeh",function(data)
          --  SendNUIMessage({ action = "closeMenu" })
            deletAnim()
            SendNUIMessage({ action = "CloseTablet" })
            
            SetNuiFocus(false,false)
            ending = true
            local _sdata = vehList[tonumber(data.name)]
            if _sdata then 
                selectedVeh = {_sdata.name,_sdata.plate,data.name} 
            else 
                selectedVeh = {data.name} 
            end
        end)
        RegisterNUICallback("close",function(data,cb)
            SetNuiFocus(false,false)
            ending = "close"
        end)
        while not ending do Wait(100) end
        UnregisterRawNuiCallback("SpawnVeh")
        UnregisterRawNuiCallback("close")
        deletAnim()
        if ending == 'close' or not selectedVeh then return false end

        if not vSERVER.verifyIsHashOutGarages(GetHashKey(selectedVeh[1]),selectedVeh[2] or vRP.getRegistrationNumber()) then
            local selectedVehId = selectedVeh[3]
            selectedVeh = selectedVeh[1]
            if ending and selectedVeh then 
                inGarage = _id
                local playerPed = PlayerPedId()
                local coords = _data.spawnar
                local to = _data.pointSpawn
                local x,y,z,h = {}
                local x1,y1,z1 = {}

                if coords == nil then 
                    x,y,z,h = _data.x,_data.y,_data.z
                    x1,y1,z1 = _data.x,_data.y,_data.z
                else
                    x,y,z,h = coords[1],coords[2],coords[3],coords[4]
                    x1,y1,z1 = to[1],to[2],to[3]
                end
              
                local npc = _data.npc
                if hasNPC then 
                    if not InGarage then
                        npcVeh = spawnVehPed(selectedVeh,x,y,z,h )
                        applyModifiesVeh(NetToVeh(nveh),1000.0,1000.0,100.0,{},nil,{},{},{},npcVeh)
                        while not DoesEntityExist(npcVeh) do
                            inGarage = false
                        return false
                        end
                       
                        vehPed = CreatevehPed(npcVeh, npc)
                        while not DoesEntityExist(vehPed) do
                            TriggerEvent("Notify","aviso","Erro.")
                            inGarage = false
                            return false
                        end

                        if IsPedInAnyHeli(vehPed) then
                            stopCarroB = 1
                            TaskHeliMission(vehPed,npcVeh,0,0,x1,y1,z1,4,5.0,-1.0,-1.0,10,10,5.0,32)
                            SetPedKeepTask(vehPed, true)
                            stopCarB(to, npcVeh , vehPed)
                        elseif IsPedInAnyBoat(vehPed) then
                           stopCarroB = 1
                           SetDriverAbility(vehPed, 1.0)        
                           SetDriverAggressiveness(vehPed, 0.0) 
                           TaskVehicleDriveToCoordLongrange(vehPed, npcVeh,  x1,y1,z1, 8.0, 0, 8.0);
                           SetPedKeepTask(vehPed, true)
                           stopCarB(to, npcVeh , vehPed)
                        else
                            stopCarroB = 1
                            SetDriverAbility(vehPed, 1.0)
                            SetDriverAggressiveness(vehPed, 0.0)
                            TaskVehicleDriveToCoordLongrange(vehPed, npcVeh ,x1,y1,z1, 2500.0*3.6, 500, GetEntityModel(npcVeh), 16777216, 1.0, 1)
                            SetPedKeepTask(vehPed, true)
                            SetDriveTaskMaxCruiseSpeed(vehPed, 15.0)
                            stopCarB(to, npcVeh , vehPed)
                        end
                    else
                        inGarage = false
                        return false
                    end
                else
                    -- DONT USING NPC
                    local _bol,nveh

                    if _data['pointSpawn'] and _data['pointSpawn'][1] then
                        if (type(_data['pointSpawn'][1]) == 'number') then
                            local x,y,z,h = _data['pointSpawn'][1], _data['pointSpawn'][2], _data['pointSpawn'][3], _data['pointSpawn'][4]
                            spawnVeh(selectedVeh,vRP.getRegistrationNumber(),x,y,z,h,function(data)
                                if data == false then
                                    _bol = false
                                else
                                    _bol = true
                                    nveh = data
                                end
                             --   --print('3')
                                SetPedIntoVehicle(PlayerPedId(), NetToVeh(nveh), -1)
                            end)
                            while type(_bol) == "nil" do Wait(100) end
                            if _bol then
                                ----print("2")
                                applyModifiesVeh(NetToVeh(nveh),1000.0,1000.0,100.0,{},nil,{},{},{},selectedVeh)
                                ----print('2')
                            else
                                inGarage = false
                                return false
                            end
                        else
                            local spawning = false
                            for _slotId,_dSlot in pairs(_data['pointSpawn']) do
                                local x,y,z,h = _dSlot[1], _dSlot[2], _dSlot[3], _dSlot[4]
                                if not HasVehClosestFromCoords(x,y,z,2.0) then
                                    local nveh
                                    spawning = true
                                    spawnVeh(selectedVeh,vRP.getRegistrationNumber(),x,y,z,h,function(data)
                                        if data == false then
                                            _bol = false
                                        else
                                            _bol = true
                                            nveh = data
                                        end
                                     --   --print('4')
                                    end)
                                   -- --print('1')
                                   -- SetPedIntoVehicle(PlayerPedId(), nveh, -1)
                                    while type(_bol) == "nil" do Wait(100) end
                                    if _bol then
                                       -- --print("3")
                                        applyModifiesVeh(NetToVeh(nveh),1000.0,1000.0,100.0,{},nil,{},{},{},selectedVeh)
                                       -- --print('5')
                                    else
                                        inGarage = false
                                        return false
                                    end
                                end
                            end
                            if not spawning then
                                TriggerEvent("Notify","aviso","Não há Vagas para retirar o veiculo.")
                                inGarage = false
                                return false
                            end
                        end
                    elseif #_data > 0 then
                        local spawning = false
                        for _slotId,data in pairs(_data) do
                            if type(_slotId) == "number" then
                                local x,y,z,h = data.x,data.y,data.z,data.h
                                if not HasVehClosestFromCoords(x,y,z,2.0) then
                                    local nveh
                                    spawning = true
                                    spawnVeh(selectedVeh,vRP.getRegistrationNumber(),x,y,z,h,function(data)
                                        if data == false then
                                            _bol = false
                                        else
                                            _bol = true
                                            nveh = data
                                        end
                                    end)
                                    while type(_bol) == "nil" do Wait(100) end
                                    if _bol then
                                        local data = vehList
                                        local dat = vehList
                                        for k,v in pairs(dat) do
                                          data = v
                                        end
                                        if dat then
                                            for _k,_v in pairs(vehList) do
                                         
                                            if _v.name == selectedVeh then
                                            --print(json.encode(_v.name))
                                            applyModifiesVeh(NetToVeh(nveh),_v.engine,_v.body,_v.fuel,_v.tuning,_v.plate,_v.vehDoors,_v.vehWindows,_v.vehTyres,_v.name) end
                                            end
                                            --applyModifiesVeh(NetToVeh(nveh),_v.engine,_v.body,_v.fuel,_v.tuning,_v.plate,_v.vehDoors,_v.vehWindows,_v.vehTyres,selectedVeh) end
                                            --applyModifiesVeh(NetToVeh(nveh),data.engine,data.body,data.fuel,data.tuning,data.plate,data.vehDoors,data.vehWindows,data.vehTyres,selectedVeh) end
                                            end
                                            --termina aqui
                                    else
                                        inGarage = false
                                        return false
                                    end
                                end
                            end
                        end
                        if not spawning then
                            TriggerEvent("Notify","aviso","Não há Vagas para retirar o veiculo.")
                            inGarage = false
                            return false
                        end
                    end

                end
                inGarage = false
            else
                return false
            end
        else
            TriggerEvent("Notify","negado","Você já tem um veiculo desse modelo fora da garagem!",5000)
            return false
        end
    else
        return false
    end
end

-- THREAD START NEAREST GARAGENS
local _thread = false
function thread(tab)
    nearestGarages = tab
    if _thread then return end
    _thread = true
    local _nearestGarages = nearestGarages
    Citizen.CreateThread(function()
 
        while _thread and not isEmptyTable(_nearestGarages) and not inGarage do
            local idle = 1000
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            _nearestGarages = nearestGarages or {}
            for _id,_data in pairs(_nearestGarages) do
                if Config.workgarage[_data.name] then 
                    -- GARAGEM DE SERVIÇO (THREAD)
                    if _data.interior then
                        -- USING INTERIOR
                        if IsPedInAnyVehicle(ped) and GetPedInVehicleSeat(GetVehiclePedIsIn(ped,false),-1) == ped then
                            idle = 4
                            enterDrawInVehicle(ped,veh,coords,_id,_data,Config.workgarage[_data.name])
                        else
                            idle = 4
                            enterDrawOutVehicle(ped,coords,_id,_data,Config.workgarage[_data.name])
                        end
                    else
                        -- DON'T USING INTERIOR
                        if not IsPedInAnyVehicle(ped) then
                            local dist = #(vec3(_data.blip[1],_data.blip[2],_data.blip[3]) - coords)
                            if (dist <= Config.personalize['DistanciaBlip'] ) then
                                idle = 4
                               -- DrawText3D(_data.blip[1],_data.blip[2],_data.blip[3], "[~g~E~w~] ".._data.text)
                                DrawMarker(_data.drawM,_data.blip[1],_data.blip[2],_data.blip[3]-0.2,0,0,0,0.0,0,0,1.0,1.0,1.0,Config.drawMaker["CorR"],Config.drawMaker["CorG"],Config.drawMaker["CorB"],100,0,0,0,1)
                                if IsControlJustPressed(1,38) and not inAction then
                                    if ClientGaragebyWineStore == true then 
                                        inAction = true
                                        interactGarages(_id,_data,Config.workgarage[_data.name],_data.npc)
                                        SetTimeout(1500,function()
                                            inAction = false
                                        end)
                                    else
                                        TriggerEvent('Notify','negado','Garagem não foi autenticada! fale com alguém da Wine Store!',5000)
                                    end
                                end
                            end
                        else
                            if type(_data.pointSpawn[1]) == 'number' then
                                local dist = #(vec3(_data.pointSpawn[1],_data.pointSpawn[2],_data.pointSpawn[3]) - coords)
                                if (dist <= Config.personalize['DistanciaBlipInCar'] ) and GetPedInVehicleSeat(GetVehiclePedIsIn(ped,false),-1) == ped then
                                    idle = 4
                                    -- não é aqui
                                    --print("a")
                                    DrawMarker(Config.drawMaker["Guardar"],_data.pointSpawn[1],_data.pointSpawn[2],_data.pointSpawn[3]-0.2,0,0,0,0.0,0,0,1.0,1.0,1.0,Config.drawMaker["CorR"],Config.drawMaker["CorG"],Config.drawMaker["CorB"],100,0,0,0,1)
                                   -- DrawText3D(_data.pointSpawn[1],_data.pointSpawn[2],_data.pointSpawn[3], Config.drawMaker["Del_vehicle"])
                                    if IsControlJustPressed(0,38) and not inAction then
                                        if ClientGaragebyWineStore == true then 
                                            inAction = true
                                            DoScreenFadeOut(300)
                                            Citizen.Wait(600)

                                            DNext.deleteVehicle(GetVehiclePedIsIn(ped,false))
                                            SetEntityCoords(PlayerPedId(),_data.blip[1],_data.blip[2],_data.blip[3])
                                            Citizen.Wait(500)
                                            DoScreenFadeIn(400)
                                            inAction = false
                                        else
                                            TriggerEvent('Notify','negado','Garagem não foi autenticada! fale com alguém da Wine Store!',5000)
                                        end
                                    end
                                end
                            else
                                for _slotId,dSlot in pairs(_data.pointSpawn) do
                                    local dist = #(vec3(dSlot[1],dSlot[2],dSlot[3]) - coords)
                                    if (dist <= Config.personalize['DistanciaBlipInCar'] ) and GetPedInVehicleSeat(GetVehiclePedIsIn(ped,false),-1) == ped then
                                        idle = 4
                                        --nem aq
                                        --print("b")
                                        DrawMarker(Config.drawMaker["Guardar"],dSlot[1],dSlot[2],dSlot[3]-0.2,0,0,0,0.0,0,0,1.0,1.0,1.0,Config.drawMaker["CorR"],Config.drawMaker["CorG"],Config.drawMaker["CorB"],100,0,0,0,1)
                                      --  DrawText3D(dSlot[1],dSlot[2],dSlot[3], Config.drawMaker["Del_vehicle"])
                                        if IsControlJustPressed(0,38) and not inAction then
                                            if ClientGaragebyWineStore == true then 
                                                inAction = true
                                                DoScreenFadeOut(300)
                                                Citizen.Wait(600)
                                                -- vSERVER.deleteVehicleSync(VehToNet(GetVehiclePedIsIn(ped,false)))
                                                DNext.deleteVehicle(GetVehiclePedIsIn(ped,false))
                                                SetEntityCoords(PlayerPedId(),_data.blip[1],_data.blip[2],_data.blip[3])
                                                Citizen.Wait(500)
                                                DoScreenFadeIn(400)
                                                inAction = false
                                            else
                                                TriggerEvent('Notify','negado','Garagem não foi autenticada! fale com alguém da Wine Store!',5000)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                elseif interiorGarages[_data.name] or (_data.interior and (interiorGarages[_data.interior])) then
                    -- GARAGEM DE PUBLICA (THREAD) [INTERIOR]
                    if IsPedInAnyVehicle(ped) and GetPedInVehicleSeat(GetVehiclePedIsIn(ped,false),-1) == ped then
                        -- IN CAR
                        local dist = #(vec3(_data.entrada['veiculo'][1],_data.entrada['veiculo'][2],_data.entrada['veiculo'][3]) - coords)
                        if (dist <= Config.personalize['DistanciaBlip'] ) then
                            idle = 4
                            enterDrawInVehicle(ped,veh,coords,_id,_data)
                        end
                    else
                        -- OUT CAR
                        idle = 4
                        enterDrawOutVehicle(ped,coords,_id,_data)
                    end

                else
                    if not IsPedInAnyVehicle(ped) then
                        local dist = #(vec3(_data.x,_data.y,_data.z) - coords)
                        if (dist <= Config.personalize['DistanciaBlip'] ) then
                            idle = 4
                           -- DrawText3D(_data.x,_data.y,_data.z,Config.drawMaker["Enter_garage"])
                            DrawMarker(Config.drawMaker["Entrar"],_data.x,_data.y,_data.z-0.2,0,0,0,0.0,0,0,1.0,1.0,1.0,Config.drawMaker["CorR"],Config.drawMaker["CorG"],Config.drawMaker["CorB"],100,0,0,0,1)
                            if IsControlJustPressed(0,38) and not inAction then
                                if ClientGaragebyWineStore == true then 
                                    inAction = true 
                                    if _data.name == "publica" or vSERVER.checkHasPermInHouse(_data.name) then
                                    -- --print(_data.x,_data.y,_data.z)
                                        interactGarages(_id,_data,vSERVER.myVehicles(_id) or {},nil,true)
                                    end
                                    SetTimeout(1500,function() inAction = false end)
                                else
                                    TriggerEvent('Notify','negado','Garagem não foi autenticada! fale com alguém da Wine Store!',5000)
                                end
                            end
                        end
                    elseif #_data > 0 and GetEntitySpeed(GetVehiclePedIsIn(ped))*3.6 < 20.0 then
                        for _slotId,data in pairs(_data) do
                            if type(_slotId) == "number" then 
                                local dist = #(vec3(data.x,data.y,data.z) - coords)
                                if (dist <= Config.personalize['DistanciaBlipInCar'] ) and GetPedInVehicleSeat(GetVehiclePedIsIn(ped,false),-1) == ped then
                                    
                                    idle = 4
                              
                                    DrawMarker(Config.drawMaker["Guardar"],data.x,data.y,data.z-0.2,0,0,0,0.0,0,0,1.0,1.0,1.0,Config.drawMaker["CorR"],Config.drawMaker["CorG"],Config.drawMaker["CorB"],100,0,0,0,1)
                                   
                                    if IsControlJustPressed(0,38) and not inAction and vSERVER.checkHasPermInHouse(_data.name) then
                                        if ClientGaragebyWineStore == true then 
                                            inAction = true
                                            DoScreenFadeOut(300)
                                            Citizen.Wait(600)

                                            local veh = GetVehiclePedIsIn(ped,false)
                                        
                                            if vSERVER.isOwnerOrStoledVehicle(GetDisplayNameFromVehicleModel(GetEntityModel(veh)),GetVehicleNumberPlateText(veh)) then
                                                DNext.deleteVehicle(veh,nil,_id)
                                            else
                                                if vSERVER.requestStoledVehicle(GetDisplayNameFromVehicleModel(GetEntityModel(veh)),GetVehicleNumberPlateText(veh)) then
                                                    DNext.deleteVehicle(veh,nil,_id) 
                                                    SetTimeout(500,function()
                                                        TriggerEvent("Notify","sucesso","Você roubou o veiculo com sucesso!",5000)
                                                    end)
                                                else
                                                    DNext.deleteVehicle(veh,nil) 
                                                    SetTimeout(500,function()
                                                        TriggerEvent("Notify","sucesso","Você devolveu o veiculo com sucesso!",5000)
                                                    end)
                                                end
                                            end

                                            SetEntityCoords(PlayerPedId(),_data.x,_data.y,_data.z)
                                            Citizen.Wait(500)
                                            DoScreenFadeIn(400)
                                            inAction = false
                                        else
                                            TriggerEvent('Notify','negado','Garagem não foi autenticada! fale com alguém da Wine Store!',5000)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            Citizen.Wait(idle)
        end
        _thread = false
    end)
end

-- GET NEAREST GARAGES
Citizen.CreateThread(function()
	
    DoScreenFadeIn(400)
    while true do   
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local __nearestGarages = {}
        if not inGarage then
            local i = 100
            for _id,_data in pairs(GaragesTable) do
                if Config.workgarage[_data.name] then
                    local dist = #(vec3(_data.blip[1],_data.blip[2],_data.blip[3]) - coords)
                    if (dist < 100.0) then
                        __nearestGarages[_id] = _data
                    end
                elseif interiorGarages[_data.name] or (_data.interior and (interiorGarages[_data.interior])) then
                    if _data.entrada then
                        local dist = #(vec3(_data.entrada['blip'][1],_data.entrada['blip'][2],_data.entrada['blip'][3]) - coords)
                        local dist2 = #(vec3(_data.entrada['veiculo'][1],_data.entrada['veiculo'][2],_data.entrada['veiculo'][3]) - coords)
                        if (dist < 100.0) or (IsPedInAnyVehicle(ped) and (dist2 < 100.0)) then
                            __nearestGarages[_id] = _data
                        end
                    end
                else
                    if (_data.x and _data.y and _data.z) then
                        local dist = #(vec3(_data.x,_data.y,_data.z) - coords)
                        if (dist < 100.0) then
                            __nearestGarages[_id] = _data
                        end
                    end
                end
                i = i - 1
                if i <= 0 then i = 100 Wait(1) end 
            end
        end
        if not isEmptyTable(__nearestGarages) then thread(__nearestGarages) end
        Citizen.Wait(2000)
    end
end)

function getNearestVehiclesHasDecor(radius)
	local r = {}
	local px,py,pz = table.unpack(GetEntityCoords(PlayerPedId()))

	local vehs = {}
	local it,veh = FindFirstVehicle()
	if veh then
		table.insert(vehs,veh)
	end
	local ok
	repeat
		ok,veh = FindNextVehicle(it)
		if ok and veh then
			table.insert(vehs,veh)
		end
	until not ok
	EndFindVehicle(it)
    local networkTime = GetNetworkTime()
	for _,veh in pairs(vehs) do
		local x,y,z = table.unpack(GetEntityCoords(veh))
		local distance = #(vec3(x,y,z) - vec3(px,py,pz))
		if distance <= radius and DecorExistOn(veh,'rCollisionTime') then
            if networkTime > DecorGetInt(veh,'rCollisionTime') then 
                DecorRemove(veh,'rCollisionTime') 
            else
                r[veh] = distance
            end
		end
	end
	return r
end

-- THREAD REMOVE COLLISION (VISUAL SYNC)
local vehListDecor = {}
local vehAlphaList = {}
local _thread_alpha = false
local function thread_alpha()
    if _thread_alpha then return end
    _thread_alpha = true
    Citizen.CreateThread(function()

        while CountTable(vehAlphaList) > 0 do
            local networkTime = GetNetworkTime()
            for _veh,data in pairs(vehAlphaList) do
                if DoesEntityExist(_veh) then
                    if data[2] and networkTime > data[2] or not DecorExistOn(_veh,'rCollisionTime') then
                        vehAlphaList[_veh] = nil
                        ResetEntityAlpha(_veh)
                    else
                        if GetEntityAlpha(_veh) ~= 255 then
                            ResetEntityAlpha(_veh)
                        else
                            SetEntityAlpha(_veh, 50, false)
                        end
                    end
                else
                    vehAlphaList[_veh] = nil
                end
            end
            Wait(250)
        end
        _thread_alpha = false
    end)
end

local _thread_collision = false
local function thread_collision()
    if _thread_collision then return end
    _thread_collision = true
    local _vehDecor = vehListDecor
    Citizen.CreateThread(function()
    
        while CountTable(_vehDecor) > 0 do
            _vehDecor = vehListDecor
            if CountTable(_vehDecor) == 0 then break end
            local idle = 10
            for _veh01,_ in pairs(_vehDecor) do
                if not vehAlphaList[_veh01] then vehAlphaList[_veh01] = {true,DecorGetInt(_veh01,'rCollisionTime')} thread_alpha() end
                local vehs = vRP.getNearestVehicles(10.0)
                for _veh02,_ in pairs(vehs) do
                    SetEntityNoCollisionEntity(_veh01, _veh02, true)
                    SetEntityNoCollisionEntity(_veh02, _veh01, true)
                end
            end
            Citizen.Wait(idle)
        end
        _thread_collision = false
    end)
end

Citizen.CreateThread(function()
 
    DecorRegister('rCollisionTime',3)
    while true do
        vehListDecor = getNearestVehiclesHasDecor(500.0)
        if CountTable(vehListDecor) > 0 then thread_collision() end
        Citizen.Wait(500)
    end
end)

local function getVehDamage(vehicle)
    local vehDoors = {}
    for i = 0,5 do
        vehDoors[i] = IsVehicleDoorDamaged(vehicle,i)
    end
    local vehWindows = {}
    for i = 0,7 do
        vehWindows[i] = IsVehicleWindowIntact(vehicle,i)
    end
    local vehTyres = {}
    for i = 0,7 do
        local tyre_state = 2
        if IsVehicleTyreBurst(vehicle,i,true) then
            tyre_state = 1
        elseif IsVehicleTyreBurst(vehicle,i,false) then
            tyre_state = 0
        end
        vehTyres[i] = tyre_state
    end
    return vehDoors, vehWindows, vehTyres
end

function DNext.deleteVehicle(vehicle,bydv,garageId)
	if vehicle and IsEntityAVehicle(vehicle) then
        local vehplate = GetVehicleNumberPlateText(vehicle)
        local vehDoors, vehWindows, vehTyres = getVehDamage(vehicle)
        local hashCar = GetHashKey(vehicle)
        local NameCarro = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))

         
        if vehplate then
            -- --print(json.encode(vehplate))
            vSERVER.tryDeletes(VehToNet(vehicle),GetVehicleEngineHealth(vehicle),GetVehicleBodyHealth(vehicle),GetVehicleFuelLevel(vehicle),vehplate,vehDoors,vehWindows,vehTyres,bydv,garageId,NameCarro)
        end

        if DecorExistOn(vehicle,'DependencyVehs') and DecorGetInt(vehicle,'DependencyVehs') ~= 0 then
            local _vehicle = NetToVeh(DecorGetInt(vehicle,'DependencyVehs'))
            if DoesEntityExist(_vehicle) then DNext.deleteVehicle(_vehicle,true) end
        end
	end
end


function DNext.delVehicle(vehicle)
    if IsEntityAVehicle(vehicle) then
        local fuel = GetVehicleFuelLevel(vehicle)
        local bodyhealth = GetVehicleBodyHealth(vehicle)
        local enginehealth = GetVehicleEngineHealth(vehicle)
        TransitionFromBlurred(500)
        SetNuiFocus(false, false)
        SendNUIMessage({action = 'hideMenu'})
        vSERVER.tryDelete(VehToNet(vehicle), enginehealth, bodyhealth, fuel)
    end
end




function DNext.tryDeleteNearestVehicle()
    local vehicle = vRP.getNearestVehicle(7)
    if vehicle then
        DNext.deleteVehicle(vehicle,nil)
    end
end

local vehblips = {}

function DNext.syncNameDelete(vehname)
    if vehicle[vehname] then
        vehicle[vehname] = nil
        if DoesBlipExist(vehblips[vehname]) then
            RemoveBlip(vehblips[vehname])
            vehblips[vehname] = nil
        end
    end
end

function DNext.getModel(nveh)
    return GetEntityModel(NetToVeh(nveh))
end

RegisterNetEvent('_handle:4sa4h12')
AddEventHandler('_handle:4sa4h12',function(p0)
    local ent = NetToVeh(p0)
    DNext.deleteVehicle(ent,true)
end)


--###################################################

RegisterCommand('wn:lock',function(source, args, rawCmd)
    local ped = PlayerPedId()
    if GetEntityHealth(ped) > 101 then
        vSERVER.vehicleLock()
    end
end)
RegisterKeyMapping('wn:lock', 'Trancar o veículo', 'keyboard', 'l')

function DNext.vehicleClientLock(vehid, lock)
    if NetworkDoesNetworkIdExist(vehid) then
        local v = NetToVeh(vehid)
        if DoesEntityExist(v) and IsEntityAVehicle(v) then
            if lock == 1 then
                SetVehicleDoorsLocked(v, 2)
            else
                SetVehicleDoorsLocked(v, 1)
            end
            SetVehicleLights(v, 2)
            Wait(200)
            SetVehicleLights(v, 0)
            Wait(200)
            SetVehicleLights(v, 2)
            Wait(200)
            SetVehicleLights(v, 0)
        end
    end
end


--###################################################

RegisterNetEvent('wine_garagem:spawn')
AddEventHandler(
    'wine_garagem:spawn',
    function(name, plate)
        local mHash = GetHashKey(name)

        RequestModel(mHash)
        while not HasModelLoaded(mHash) do
            RequestModel(mHash)
            Citizen.Wait(10)
        end

        if HasModelLoaded(mHash) then
            local ped = PlayerPedId()
            local nveh = CreateVehicle(mHash, GetEntityCoords(ped), GetEntityHeading(ped), true, false)

            SetVehicleDirtLevel(nveh, 0.0)
            SetVehRadioStation(nveh, 'OFF')
            SetVehicleNumberPlateText(nveh, plate)
            SetEntityAsMissionEntity(nveh, true, true)

            SetPedIntoVehicle(ped, nveh, -1)

            if nveh then
                SetVehicleFuelLevel(nveh, 100.0)
            else
                SetVehicleFuelLevel(nveh, 100.0)
            end

            SetModelAsNoLongerNeeded(mHash)
        end
    end
)

RegisterNetEvent('reparar')
AddEventHandler('reparar',function()
    local vehicle = vRP.getNearestVehicle(3)
    if IsEntityAVehicle(vehicle) then
        TriggerServerEvent('tryreparar', VehToNet(vehicle))
    end
end)


function stopCarB(to, npcVeh , vehPed)
    while stopCarroB == 1 do
        local tx, ty, tz = GetEntityCoords(npcVeh)
        local distance = GetDistanceBetweenCoords(to[1],to[2],to[3], tx, ty, tz, true)
        local vehicle = npcVeh
        local vehped = vehPed
        if distance <= 1 then
               if vehPed then
                if IsPedInAnyHeli(vehPed) then
                    Citizen.Wait(10000)
                    EndTaskPed(to,vehPed, npcVeh)
                else
                    EndTaskPed(to,vehPed, npcVeh)
                end
               
              end
            stopCarroB = 0
        end
        Citizen.Wait(0)
    end

end
function spawnVehPed(name,x,y,z,h)
	----print("chegou")
	local mhash = GetHashKey(name)
    ----print(nveh)
	if not veh then
	while not HasModelLoaded(mhash) do
		RequestModel(mhash)
		Citizen.Wait(10)
	end
   -- --print("criou")
		nveh = CreateVehicle(mhash, x,y,z+0.5,h,true,false)

		SetVehicleIsStolen(nveh,false)
		SetVehicleOnGroundProperly(nveh)
		SetEntityInvincible(nveh,false)
		SetVehicleNumberPlateText(nveh,vRP.getRegistrationNumber())
		Citizen.InvokeNative(0xAD738C3085FE7E11,nveh,true,true)
		SetVehicleHasBeenOwnedByPlayer(nveh,true)
		SetVehicleDirtLevel(nveh,0.0)
		SetVehRadioStation(nveh,"OFF")
		--SetVehicleEngineOn(GetVehiclePedIsIn(ped,false),true)
        return nveh
	end
   -- --print("gerou")
	return nveh
end
function CreatevehPed(vehicle, npc)
	local model = GetHashKey(npc)

	if DoesEntityExist(vehicle) then
		if IsModelValid(model) then
			RequestModel(model)
			while not HasModelLoaded(model) do
				Wait(1)
			end

			local ped = CreatePedInsideVehicle(vehicle, 26, model, -1, true, false)
			SetAmbientVoiceName(ped, "A_M_M_EASTSA_02_LATINO_FULL_01")	
			SetBlockingOfNonTemporaryEvents(ped, true)
			SetEntityAsMissionEntity(ped, true, true)

			SetModelAsNoLongerNeeded(model)
			return ped
		end
	end
end

function deletAnim()
	vRP._DeletarObjeto()
	vRP._stopAnim(false)
end

function EndTaskPed(to,vehPed, npcVeh)
    TaskLeaveVehicle(vehPed, npcVeh, 0)
    ClearPedTasks(vehPed)
    SetEntityAsMissionEntity(vehPed, true, true) 
    TaskGoToCoordAnyMeans(vehPed, to[1]+10,to[2],to[3], 1.0, 0, 0, 786603, 0xbf800000)
    Citizen.Wait(10000)
    DeleteEntity(vehPed)
end


RegisterNetEvent("wine_garagem:repairVehicle")
AddEventHandler("wine_garagem:repairVehicle",function(index,status)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToEnt(index)
		if DoesEntityExist(v) then
			local fuel = GetVehicleFuelLevel(v)
			if status then
				SetVehicleFixed(v)
				SetVehicleDeformationFixed(v)
			end
			SetVehicleBodyHealth(v,1000.0)
			SetVehicleEngineHealth(v,1000.0)
			SetVehiclePetrolTankHealth(v,1000.0)
			SetVehicleFuelLevel(v,fuel)
		end
	end
end)

RegisterNetEvent('reparar')
AddEventHandler('reparar',function()
	local vehicle = vRP.getNearestVehicle(3)
	if IsEntityAVehicle(vehicle) then
		TriggerServerEvent("tryreparar",VehToNet(vehicle))
	end
end)

RegisterNetEvent('syncreparar')
AddEventHandler('syncreparar',function(index)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToVeh(index)
		local fuel = GetVehicleFuelLevel(v)
		if DoesEntityExist(v) then
			if IsEntityAVehicle(v) then
				SetVehicleFixed(v)
				SetVehicleDirtLevel(v,0.0)
				SetVehicleUndriveable(v,false)
				Citizen.InvokeNative(0xAD738C3085FE7E11,v,true,true)
				SetVehicleOnGroundProperly(v)
				SetVehicleFuelLevel(v,fuel)
			end
		end
	end
end)


Citizen.CreateThread(function()
	
	LoadMpDlcMaps()
	EnableMpDlcMaps(true)
    -- ipl garage
	RequestIpl("imp_dt1_02_cargarage_a") -- -191.0133, -579.1428, 135.0000
    RequestIpl("imp_dt1_02_cargarage_b") -- -117.4989, -568.1132, 135.0000
    RequestIpl("imp_dt1_02_cargarage_c") -- -136.0780, -630.1852, 135.0000
    RequestIpl("imp_dt1_02_modgarage") -- -146.6166, -596.6301, 166.0000
    -- ipl garage
    RequestIpl("imp_dt1_11_cargarage_a") -- -84.2193, -823.0851, 221.0000
    RequestIpl("imp_dt1_11_cargarage_b") -- -69.8627, -824.7498, 221.0000
    RequestIpl("imp_dt1_11_cargarage_c") -- -80.4318, -813.2536, 221.0000
    RequestIpl("imp_dt1_11_modgarage") -- -73.9039, -821.6204, 284.0000
    -- ipl cassino
    RequestIpl("vw_casino_garage")
	RequestIpl("vw_casino_carpark")
end)



