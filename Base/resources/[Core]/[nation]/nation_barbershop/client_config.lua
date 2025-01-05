local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
func = Tunnel.getInterface("nation_barbershop")
fclient = {}
Tunnel.bindInterface("nation_barbershop", fclient)


startCharLooping = false

---------------------------------------------------------------------------
-----------------------ANIMAÇÃO DE PARADO---------------------------
---------------------------------------------------------------------------

function LoadAnim(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(10)
    end
end

function freezeAnim(dict, anim, flag, keep)
    if not keep then
        ClearPedTasks(PlayerPedId())
    end
    LoadAnim(dict)
    TaskPlayAnim(PlayerPedId(), dict, anim, 2.0, 2.0, -1, flag or 1, 0, false, false, false)
    RemoveAnimDict(dict)
end






---------------------------------------------------------------------------
-----------------------CÂMERAS--------------------------
---------------------------------------------------------------------------

local cameras = {
    body = { coords = vec3(0.0, 1.0, 0.15), bone = "IK_Head" }, 
    head = { coords = vec3(0.0, 0.6, 0.15), bone = "IK_Head" },
    eye = { coords = vec3(0.0, 0.45, 0.05), bone = "IK_Head" },
    mouth = { coords = vec3(0.0, 0.45, -0.05), bone = "IK_Head" },
    chest = { coords = vec3(0.0, 1.0, 0.4), bone = "BONETAG_SPINE3" }, 
}


componentCams = {
    ["chestHair"] = "chest",
    ["hair"] = "head",
    ["facialHair"] = "head",
    ["blush"] = "head",
    ["lipstick"] = "mouth",
    ["makeup"] = "head",
    ["eyes"] = "eye",
    ["bodyBlemishes"] = "chest",
    ["addBodyBlemishes"] = "chest",
    ["complexion"] = "head",
    ["blemishes"] = "head",
    ["sunDamage"] = "head",
    ["freckles"] = "head",
    ["ageing"] = "head",
}


local barberClothes = {
    [GetHashKey("mp_m_freemode_01")] = {
        ["bodyArmors"] = { 0, 0, 0 },
        ["torsos"] = { 15, 0, 2 },
        ["undershirts"] = { 15, 0, 2 },
        ["tops"] = { 15, 0, 2 },
        ["decals"] = { 0,0,0 },
    },

    [GetHashKey("mp_f_freemode_01")] = {
        ["bodyArmors"] = { 0, 0, 0 },
        ["torsos"] = { 15, 0, 2 },
        ["undershirts"] = { 14, 0, 2 },
        ["tops"] = { 15, 0, 2 },
        ["decals"] = { 0,0,0 },
    },
}

local activeCam

function interpCamera(cameraName)
    if cameras[cameraName] and cameraName ~= activeCam then
        local ped = PlayerPedId()
        if cameraName == "chest" then
            local model = GetEntityModel(ped)
            setClothes(barberClothes[model] or {})
        elseif activeCam == "chest" then
            setClothes(myClothes)
        end
        activeCam = cameraName
        local cam = cameras[cameraName]
        local bone = GetEntityBoneIndexByName(ped, cam.bone)
        local boneCoords = GetWorldPositionOfEntityBone(ped, bone)
        local coord = GetOffsetFromEntityInWorldCoords(ped,cam.coords.x, cam.coords.y, 0.0)
        local tempCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coord.x, coord.y, cam.coords.z + boneCoords.z, 0,0,0, 50.0)
        SetCamActive(tempCam, true)
        SetCamActiveWithInterp(tempCam, fixedCam, 600, true, true)
        PointCamAtCoord(tempCam, boneCoords)
        if cam.f then cam.f() end
        maxCamHeading = GetEntityHeading(ped)
        CreateThread(function()
            Wait(600)
            DestroyCam(fixedCam)
            fixedCam = tempCam
        end)
    end
end


maxCamHeading = 0
function changeCamRotation(increase)
    local amount = 5
    if increase then amount = -amount end
    maxCamHeading = maxCamHeading + amount
    if maxCamHeading < 0 then maxCamHeading = f(360 - maxCamHeading) elseif maxCamHeading > 360 then maxCamHeading = f(0 + maxCamHeading) end
    local ped = PlayerPedId()
    local currentHeading = GetEntityHeading(ped)
    SetEntityHeading(ped, maxCamHeading)
    local cam = cameras[activeCam]
    local bone = GetEntityBoneIndexByName(ped, cam.bone)
    local boneCoords = GetWorldPositionOfEntityBone(ped, bone)
    local coord = GetOffsetFromEntityInWorldCoords(ped,cam.coords.x, cam.coords.y, 0.0)
    local tempCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coord.x, coord.y, cam.coords.z + boneCoords.z, 0,0,0, 50.0)
    SetCamActive(tempCam, true)
    SetCamActiveWithInterp(tempCam, fixedCam, 0, true, true)
    PointCamAtCoord(tempCam, boneCoords)
    SetEntityHeading(ped, currentHeading)
    CreateThread(function()
        Wait(1)
        DestroyCam(fixedCam)
        fixedCam = tempCam
    end)
end



function createCamera()
    local ped = PlayerPedId()
    local groundCam = CreateCam("DEFAULT_SCRIPTED_CAMERA")
    AttachCamToEntity(groundCam, ped, 0.0, -1.5, 0.0)
    SetCamActive(groundCam, true)
    RenderScriptCams(true, false, 1, true, true)
    activeCam = "body"
    local cam = cameras[activeCam]
    local bone = GetEntityBoneIndexByName(ped, cam.bone)
    local boneCoords = GetWorldPositionOfEntityBone(ped, bone)
    local coord = GetOffsetFromEntityInWorldCoords(ped,cam.coords.x, cam.coords.y, 0.0)
    fixedCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coord.x, coord.y, cam.coords.z + boneCoords.z, 0,0,0, 50.0)
    PointCamAtCoord(fixedCam, boneCoords)
    SetCamActive(fixedCam, true)
    SetCamActiveWithInterp(fixedCam, groundCam, 1000, true, true)
    if cam.f then cam.f() end
    maxCamHeading = GetEntityHeading(ped)
    CreateThread(function()
        Wait(1000)
        DestroyCam(groundCam)
    end)
end






getPopupText = function(total) -- TEXTO QUE VAI APARECER NO POPUP NA HORA DE COMPRAR
    return "você deseja pagar o valor de $ <b>"..format(total or 0).."</b> ?"
end




function teleport(ply,x, y, z)
    if type(x) == "vector3" then
        x,y,z = table.unpack(x)
    end
    FreezeEntityPosition(ply, true)
    SetEntityCoords(ply, x + 0.0001, y + 0.0001, z + 0.0001, 1, 0, 0, 1)
    while not HasCollisionLoadedAroundEntity(ply) do
        FreezeEntityPosition(ply, true)
        SetEntityCoords(ply, x + 0.0001, y + 0.0001, z + 0.0001, 1, 0, 0, 1)
        RequestCollisionAtCoord(x, y, z)
        Wait(500)
    end
    SetEntityCoords(ply, x + 0.0001, y + 0.0001, z + 0.0001, 1, 0, 0, 1)
    FreezeEntityPosition(ply, false)
    Wait(1000)
end



function setGender(gender)    
    local model = "mp_m_freemode_01"
    if gender == "female" then
        model = "mp_f_freemode_01"
    elseif gender ~= "male" then
        model = gender
    end
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(100)   
    end
    local ped = PlayerPedId()
    local currentHealth, currentMaxHealth, currentArmour = GetEntityHealth(ped), GetPedMaxHealth(ped), GetPedArmour(ped)
    local weapons = vRP.getWeapons() or {}
    SetPlayerModel(PlayerId(), model)
    ped = PlayerPedId()
    SetPedMaxHealth(ped, currentMaxHealth) -- setar vida maxima 
    SetEntityHealth(ped, currentHealth)
    SetPedArmour(ped, currentArmour)
    vRP.giveWeapons(weapons,true)
end




function parseFloat(num)
    local n = tonumber(num..".0")
    if not n then n = tonumber(num) or num end
    return n
end

function f(num)
    local n = parseFloat(string.format("%.2f", tostring(num)))
    return n
end

function format(n)
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1.'):reverse())..right
end




----------------------------------------------------------------------------
----------------------------------------------------------------------------
----------------------------------------------------------------------------





local barberShops = {
    [1] = { coords = vec3(-34.89,-150.09,57.09), perm = nil },
    [2] = { coords = vec3(1210.24,-474.85,66.22) },
    [3] = { coords = vec3(-281.05,6227.46,31.73) },
    [4] = { coords = vec3(-814.62,-182.79,37.57) },
    [5] = { coords = vec3(137.85,-1710.83,29.3) },
    [6] = { coords = vec3(1934.55,3730.16,32.86) },
    [7] = { coords = vec3(-1284.31,-1119.68,7.01) },
    [8] = { coords = vec3(-2081.74,-507.53,12.82)},
}

function addBlips()
    for _, v in pairs(barberShops) do
        local coords = v.coords
        if coords then
            local blip = AddBlipForCoord(coords)
            SetBlipSprite(blip, v.id or 71)
            SetBlipColour(blip, v.color or 13)
            SetBlipScale(blip, 0.4)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(v.name or "Barbearia")
            EndTextCommandSetBlipName(blip)
        end
    end
end


local barberChairs = {
    [1] = {
        { coords = vec3(-34.78,-150.17,57.31), h = 65.31, offset = vec3(0.0, -0.6, -0.35) },
        { coords = vec3(-35.84,-152.91,57.27), h = 65.71,  offset = vec3(0.02, -0.6, -0.35) },
    },
    [2] = {
        { coords = vec3(1210.33,-474.77,66.51), h = 164.41, offset = vec3(-0.1, -0.6, -0.3) }, 
        { coords = vec3(1214.25,-475.75,66.59), h = 164.41, offset = vec3(-0.05, -0.6, -0.3) },
    },
    [3] = {
        { coords = vec3(-280.44,6226.99,32.05), h = 141.74, offset = vec3(-0.02, -0.6, -0.35) },     
        { coords = vec3(-278.12,6224.68,32.07), h = 136.07, offset = vec3(-0.05, -0.6, -0.35) },
    },
    [4] = {
        { coords = vec3(-813.06,-180.41,37.47), h = 28.83, offset = vec3(-0.04, -0.6, -0.25), dict = "anim@amb@clubhouse@boardroom@crew@female@var_a@base@", anim = "base"  },     
        { coords = vec3(-814.8,-181.37,37.57), h = 28.83, offset = vec3(-0.04, -0.6, -0.35), dict = "anim@amb@clubhouse@boardroom@crew@female@var_a@base@", anim = "base" },
        { coords = vec3(-816.54,-182.32,37.57), h = 28.83, offset = vec3(-0.08, -0.6, -0.35), dict = "anim@amb@clubhouse@boardroom@crew@female@var_a@base@", anim = "base" }, 
        { coords = vec3(-818.3,-183.29,37.57), h = 28.83, offset = vec3(-0.08, -0.6, -0.35), dict = "anim@amb@clubhouse@boardroom@crew@female@var_a@base@", anim = "base" }, 
    },
    [5] = {
        { coords = vec3(138.28,-1710.19,29.64), h = 226.78, offset = vec3(-0.02, -0.6, -0.35) }, 
        { coords = vec3(140.4,-1707.66,29.66), h = 235.28, offset = vec3(-0.05, -0.6, -0.35) },
    },
    [6] = {
        { coords = vec3(1934.13,3730.83,33.19), h = 308.98, offset = vec3(-0.02, -0.6, -0.35) },   
        { coords = vec3(1932.48,3733.68,33.23), h = 308.98, offset = vec3(-0.05, -0.6, -0.35) },
    },
    [7] = {
        { coords = vec3(-1283.53,-1119.61,7.35), h = 184.26, offset = vec3(-0.02, -0.6, -0.35) },   
        { coords = vec3(-1280.26,-1119.61,7.36), h = 187.09, offset = vec3(-0.05, -0.6, -0.35) }, 
    },
    [8] = {
        { coords = vec3(-2079.52,-509.89,12.96), h = 145.0, offset = vec3(-0.02, -0.6, -0.35) },
        { coords = vec3(-2081.02,-508.65,12.96), h = 145.0, offset = vec3(-0.02, -0.6, -0.35) },
        { coords = vec3(-2082.68,-507.24,12.96), h = 135.0, offset = vec3(-0.02, -0.6, -0.35) },
        { coords = vec3(-2085.69,-504.73,12.96), h = 145.0, offset = vec3(-0.02, -0.6, -0.35) },
    },
    -- [9] = {
    --     { coords = vec3(-796.66,326.0,243.38), h = 0.0, offset = vec3(-0.02, -0.6, -0.35) },
    --     { coords = vec3(-796.66,326.0,243.38), h = 0.0, offset = vec3(-0.02, -0.6, -0.35) },
    -- },
    -- [10] = {
    --     { coords = vec3(2517.34,-345.25,101.89), h = 0.0, offset = vec3(-0.02, -0.6, -0.35) },
    --     { coords = vec3(2517.34,-345.25,101.89), h = 0.0, offset = vec3(-0.02, -0.6, -0.35) },
    -- },
    -- [11] = {
    --     { coords = vec3(1402.17,1154.13,114.38), h = 0.0, offset = vec3(-0.02, -0.6, -0.35) },
    --     { coords = vec3(1402.17,1154.13,114.38), h = 0.0, offset = vec3(-0.02, -0.6, -0.35) },
    -- },
    -- [12] = {
    --     { coords = vec3(-330.89,1544.02,370.83), h = 0.0, offset = vec3(-0.02, -0.6, -0.35) },
    --     { coords = vec3(-330.89,1544.02,370.83), h = 0.0, offset = vec3(-0.02, -0.6, -0.35) },
    -- },
    -- [13] = {
    --     { coords = vec3(3015.9,3058.22,115.0), h = 0.0, offset = vec3(-0.02, -0.6, -0.35) },
    --     { coords = vec3(3015.9,3058.22,115.0), h = 0.0, offset = vec3(-0.02, -0.6, -0.35) },
    -- }
    --[[[8] = {
        { coords = vec3(-795.25,880.99,204.99), h = 93.55, offset = vec3(-0.15, -0.9, -0.30), dict = "anim@amb@clubhouse@boardroom@crew@female@var_a@base@", anim = "base" },   
        { coords = vec3(-797.7,878.97,204.99), h = 266.46, offset = vec3(-0.15, -0.9, -0.30), dict = "anim@amb@clubhouse@boardroom@crew@female@var_a@base@", anim = "base" },
        { coords = vec3(-797.88,877.35,205.16), h = 266.46, offset = vec3(-0.08, -0.65, -0.30), dict = "anim@amb@clubhouse@boardroom@crew@female@var_a@base@", anim = "base" }, 
        { coords = vec3(-797.82,880.82,204.99), h = 272.13, offset = vec3(-0.15, -0.9, -0.30), dict = "anim@amb@clubhouse@boardroom@crew@female@var_a@base@", anim = "base" }, 
        { coords = vec3(-795.21,877.42,204.99), h = 93.55, offset = vec3(-0.15, -0.9, -0.30), dict = "anim@amb@clubhouse@boardroom@crew@female@var_a@base@", anim = "base" },
        { coords = vec3(-795.27,879.22,204.99), h = 93.55, offset = vec3(-0.15, -0.9, -0.30), dict = "anim@amb@clubhouse@boardroom@crew@female@var_a@base@", anim = "base" },
    }]]
}


local defaultPrices = {
    ["blemishes"] = 10,
    ["blemishes-opacity"] = 5,
    ["facialHair"] = 30,
    ["facialHair-color"] = 20,
    ["facialHair-opacity"] = 10,
    ["eyebrows"] = 10,
    ["eyebrows-color"] = 5,
    ["eyebrows-opacity"] = 5,
    ["ageing"] = 10,
    ["ageing-opacity"] = 5,
    ["makeup"] = 20,
    ["makeup-color"] = 20,
    ["makeup-opacity"] = 5,
    ["blush"] = 15,
    ["blush-color"] = 10,
    ["blush-opacity"] = 5,
    ["complexion"] = 10,
    ["complexion-opacity"] = 5,
    ["sunDamage"] = 10,
    ["sunDamage-opacity"] = 10,
    ["lipstick"] = 15,
    ["lipstick-color"] = 10,
    ["lipstick-opacity"] = 5,
    ["freckles"] = 10,
    ["freckles-opacity"] = 5,
    ["chestHair"] = 15,
    ["chestHair-color"] = 10,
    ["chestHair-opacity"] = 5,
    ["bodyBlemishes"] = 10,
    ["bodyBlemishes-opacity"] = 5,
    ["addBodyBlemishes"] = 10,
    ["addBodyBlemishes-opacity"] = 5,
    ["eyes"] = 100,
    ["noseWidth"] = 5,    
    ["nosePeakHeight"] = 5,
    ["nosePeakLength"] = 5,
    ["noseBoneHigh"] = 5,
    ["nosePeakLowering"] = 5,
    ["noseBoneTwist"] = 5,
    ["eyeBrownHigh"] = 5,
    ["eyeBrownForward"] = 5,
    ["cheeksBoneHigh"] = 5,
    ["cheeksBoneWidth"] = 5,
    ["cheeksWidth"] = 5,
    ["eyesOpenning"] = 5,
    ["lipsThickness"] = 5,
    ["jawBoneWidth"] = 5,
    ["jawBoneBackLength"] = 5,
    ["chinBoneLowering"] = 5,
    ["chinBoneLength"] = 5,
    ["chinBoneWidth"] = 5,
    ["chinHole"] = 5,
    ["neckThickness"] = 5,
    ["hair"] = 250,
    ["hair-color"] = 40,
    ["hair-highlightcolor"] = 40,
    ["overlay"] = 100,
}

local customBarbers = {
    --[[ ["admin"] = {
        ["eyes"] = {
            blocked = true,
            male = {
                type = "remove",
                [2] = 500
            }
        },
        ["skin"] = {
            blocked = true,
        },
        ["overlay"] = {
            blocked = true,
        },
    }, ]]
}




function isComponentBlocked(id, component)
    return customBarbers[id] and customBarbers[id][component] and customBarbers[id][component].blocked
end

function isItemBlocked(id, component, index, gender)
    if customBarbers[id] and customBarbers[id][component] and customBarbers[id][component][gender] then
        local c = customBarbers[id][component][gender]
        if not c.type then c.type = "remove" end
        return (c.type == "insert" and (not c[index] or (type(c[index]) == "table" and c[index].blocked))) or (c.type == "remove" and c[index] and (type(c[index]) == "boolean" or (type(c[index]) == "table" and c[index].blocked)))
    end
    return false
end



function getItemPrice(id, key, value, gender)
    local price = defaultPrices[key] or 0
    if customBarbers[id] and customBarbers[id][key] and customBarbers[id][key][gender] then
        local c = customBarbers[id][key][gender]
        if c[value] then
            price = c[value]
            if type(price) == "table" then
                price = price.price or c.defaultPrice or defaultPrices[key]
            elseif type(price) == "boolean" then
                price = c.defaultPrice or defaultPrices[key]
            end
        else 
            price = c.defaultPrice or defaultPrices[key]
        end
    end
    if key == "overlay" and value == 0 then price = 0 end
    return price, "$ "..format(price)
end




function getItemsInfo(id)
    local items = getAllItems()
    local gender = getGender()
    for k, v in pairs(items) do
        v.blocked = isComponentBlocked(id, k)
        v.price = getItemPrice(id, k, 0, gender)
        if not v.blocked then
            for index, j in pairs(v) do
                if type(index) == "number" then
                    local price, priceStr = getItemPrice(id, k, index, gender)
                    j.hidePrice = price == 0
                    j.price = priceStr
                    j.blocked = isItemBlocked(id, k, index, gender)
                end
            end
        end
    end
    return items
end

function getCartTotal(cart, oldPlayer, id)
    local total = 0
    local gender = getGender()
    for key, value in pairs(cart) do
        if oldPlayer[key] then
            local v = oldPlayer[key]
            if value >= 0 and value ~= v then
                total = math.floor(total + getItemPrice(id, key, value, gender))
            end
        end
    end
    return total, "valor: $ "..format(total)
end

function getNearestBarberShop()
    local ped = PlayerPedId()
    local myCoords = GetEntityCoords(ped)
    for i, v in ipairs(barberShops) do
        local coords = v.coords
        local distance = #(myCoords - coords)
        if distance < 3 then
            return i, v
        end
    end
end

function getNearestBarberChair()
    local ped = PlayerPedId()
    local myCoords = GetEntityCoords(ped)
    local chair, chairIndex
    local d = 100
    for i, object in ipairs(barberChairs[barberId] or {}) do
        local objectCoords = object.coords
        local distance = #(myCoords - objectCoords)
        if distance < 2 and distance < d then
            chair = object
            d = distance
            chairIndex = i
        end
    end
    return chair, chairIndex
end

function drawChairMarkers()
    if not barberId or not barberChairs[barberId] then return end
    for k,v in ipairs(barberChairs[barberId]) do
        local x,y,z = table.unpack(v.coords)
        DrawMarker(0,x,y,z+0.5,0,0,0,0,0,0,0.25,0.25,0.25,255, 255, 255,50,1,1,1,1)
    end
end

function nearBarber()
    local idle = 500
    while nearestBarbershop do
        if not inMenu then
            idle = 0
            local ped = PlayerPedId()
            local myCoords = GetEntityCoords(ped)
            local distance = #(myCoords - nearestBarbershop.coords)
            if distance >= 6 or GetEntityHealth(ped) <= 101 then
                nearestBarbershop = nil
                barberId = nil
                if inMenu then
                    closeMenu()
                end
                break
            end
            drawChairMarkers()
            nearestChair, chairIndex = getNearestBarberChair()
            if nearestChair then
                if IsDisabledControlJustPressed(0, 38) and GetEntityHealth(ped) > 101 and func.checkChair(barberId, chairIndex, nearestBarbershop.perm) then
                    startBarbershop(barberId)
                end
            end
        end
        Wait(idle)
    end
end


mainThread = function()
   -- addBlips() -- comentar caso nao queria os blips no mapa
    while true do
        local idle = 500
        if not inMenu then
            barberId, nearestBarbershop = getNearestBarberShop()
            if barberId then
                nearBarber()
            end
        end
        Wait(idle)
    end
end

CreateThread(mainThread)

function initBarbershop()
    TriggerEvent('nation_hud:updateHud', false)
    local ped = PlayerPedId()
    myClothes = getMyClothes()
    local dict, anim = "misshair_shop@barbers", "player_base"
    freezeAnim("move_f@multiplayer", "idle")
    if nearestChair then
        FreezeEntityPosition(ped, true)
        SetEntityCoordsNoOffset(ped, nearestChair.coords)
        SetEntityHeading(ped, nearestChair.h)
        if nearestChair.offset then
            local startCoords = GetOffsetFromEntityInWorldCoords(ped, 0.45, -0.7, 0.0)
            local coords = GetOffsetFromEntityInWorldCoords(ped, nearestChair.offset)
            SetEntityCoordsNoOffset(ped, startCoords)
            freezeAnim("misshair_shop@barbers", "player_enterchair", 1, true)
            Wait(1700)
            SetEntityCoordsNoOffset(ped, coords)
            maxCamHeading = GetEntityHeading(ped)
            if nearestChair.dict then
                dict, anim = nearestChair.dict, nearestChair.anim
            end
            freezeAnim(dict, anim, 1, true)
        end
    end
    SetFacialIdleAnimOverride(ped, "pose_normal_1", 0)
    Wait(500)
end


function finishBarbershop()
    local ped = PlayerPedId()
    setClothes(myClothes)
    if nearestChair and nearestChair.offset then
        local coord = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.7, 0.0)
        freezeAnim("misshair_shop@barbers", "player_exitchair", 1, true)
        Wait(1800)
        SetEntityCoordsNoOffset(ped, coord)
    end
    FreezeEntityPosition(ped, false)
    ClearPedTasks(ped)
    ClearFacialIdleAnimOverride(ped)
    TriggerEvent('nation_hud:updateHud', true)
    func._leaveChar()
    func._setPlayerTattoos()
end

local overlays =  {
	[GetHashKey("mp_m_freemode_01")] = {
        { collection = 'mpbeach_overlays', overlay = 'FM_Hair_Fuzz' },
		{ collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_000_M' },
		{ collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_001_M' },
		{ collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_002_M' },
		{ collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_003_M' },
		{ collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_004_M' },
		{ collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_005_M' },
		{ collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_006_M' },
		{ collection = 'mpbusiness_overlays', overlay = 'FM_Bus_M_Hair_000_a' },
		{ collection = 'mpbusiness_overlays', overlay = 'FM_Bus_M_Hair_000_b' },
		{ collection = 'mpbusiness_overlays', overlay = 'FM_Bus_M_Hair_000_c' },
		{ collection = 'mpbusiness_overlays', overlay = 'FM_Bus_M_Hair_000_d' },
		{ collection = 'mpbusiness_overlays', overlay = 'FM_Bus_M_Hair_000_e' },
		{ collection = 'mpbusiness_overlays', overlay = 'FM_Bus_M_Hair_001_a' },
		{ collection = 'mpbusiness_overlays', overlay = 'FM_Bus_M_Hair_001_b' },
		{ collection = 'mpbusiness_overlays', overlay = 'FM_Bus_M_Hair_001_c' },
		{ collection = 'mpbusiness_overlays', overlay = 'FM_Bus_M_Hair_001_d' },
		{ collection = 'mpbusiness_overlays', overlay = 'FM_Bus_M_Hair_001_e' },
		{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Hair_M_000_M' },
		{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Hair_M_001_M' },
		{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Hair_000_a' },
		{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Hair_000_b' },
		{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Hair_000_c' },
		{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Hair_000_d' },
		{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Hair_000_e' },
		{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Hair_001_a' },
		{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Hair_001_b' },
		{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Hair_001_c' },
		{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Hair_001_d' },
		{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Hair_001_e' },
		{ collection = 'mphipster_overlays', overlay = 'FM_Disc_M_Hair_001_a' },
		{ collection = 'mphipster_overlays', overlay = 'FM_Disc_M_Hair_001_b' },
		{ collection = 'mphipster_overlays', overlay = 'FM_Disc_M_Hair_001_c' },
		{ collection = 'mphipster_overlays', overlay = 'FM_Disc_M_Hair_001_d' },
		{ collection = 'mphipster_overlays', overlay = 'FM_Disc_M_Hair_001_e' },
		{ collection = 'mplowrider2_overlays', overlay = 'LR_M_Hair_004' },
		{ collection = 'mplowrider2_overlays', overlay = 'LR_M_Hair_005' },
		{ collection = 'mplowrider2_overlays', overlay = 'LR_M_Hair_006' },
		{ collection = 'mplowrider_overlays', overlay = 'LR_M_Hair_000' },
		{ collection = 'mplowrider_overlays', overlay = 'LR_M_Hair_001' },
		{ collection = 'mplowrider_overlays', overlay = 'LR_M_Hair_002' },
		{ collection = 'mplowrider_overlays', overlay = 'LR_M_Hair_003' },
		{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Hair_M_000_M' },
		{ collection = 'multiplayer_overlays', overlay = 'FM_M_Hair_001_a' },
		{ collection = 'multiplayer_overlays', overlay = 'FM_M_Hair_001_b' },
		{ collection = 'multiplayer_overlays', overlay = 'FM_M_Hair_001_c' },
		{ collection = 'multiplayer_overlays', overlay = 'FM_M_Hair_001_d' },
		{ collection = 'multiplayer_overlays', overlay = 'FM_M_Hair_001_e' },
		{ collection = 'multiplayer_overlays', overlay = 'FM_M_Hair_003_a' },
		{ collection = 'multiplayer_overlays', overlay = 'FM_M_Hair_003_b' },
		{ collection = 'multiplayer_overlays', overlay = 'FM_M_Hair_003_c' },
		{ collection = 'multiplayer_overlays', overlay = 'FM_M_Hair_003_d' },
		{ collection = 'multiplayer_overlays', overlay = 'FM_M_Hair_003_e' },
		{ collection = 'multiplayer_overlays', overlay = 'FM_M_Hair_006_a' },
		{ collection = 'multiplayer_overlays', overlay = 'FM_M_Hair_006_b' },
		{ collection = 'multiplayer_overlays', overlay = 'FM_M_Hair_006_c' },
		{ collection = 'multiplayer_overlays', overlay = 'FM_M_Hair_006_d' },
		{ collection = 'multiplayer_overlays', overlay = 'FM_M_Hair_006_e' },
		{ collection = 'multiplayer_overlays', overlay = 'FM_M_Hair_008_a' },
		{ collection = 'multiplayer_overlays', overlay = 'FM_M_Hair_008_b' },
		{ collection = 'multiplayer_overlays', overlay = 'FM_M_Hair_008_c' },
		{ collection = 'multiplayer_overlays', overlay = 'FM_M_Hair_008_d' },
		{ collection = 'multiplayer_overlays', overlay = 'FM_M_Hair_008_e' },
		{ collection = 'multiplayer_overlays', overlay = 'FM_M_Hair_long_a' },
		{ collection = 'multiplayer_overlays', overlay = 'FM_M_Hair_long_b' },
		{ collection = 'multiplayer_overlays', overlay = 'FM_M_Hair_long_c' },
		{ collection = 'multiplayer_overlays', overlay = 'FM_M_Hair_long_d' },
		{ collection = 'multiplayer_overlays', overlay = 'FM_M_Hair_long_e' },
        { collection = 'multiplayer_overlays', overlay = 'NG_F_Hair_013'},
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_001' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_002' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_003' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_004' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_005' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_006' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_007' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_008' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_009' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_011' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_012' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_013' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_014' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_015' },
        -- { collection = 'multiplayer_overlays', overlay = 'NGBea_M_Hair_000' },
        -- { collection = 'multiplayer_overlays', overlay = 'NGBea_M_Hair_001' },
        { collection = 'multiplayer_overlays', overlay = 'NGBus_M_Hair_000' },
        { collection = 'multiplayer_overlays', overlay = 'NGBus_M_Hair_001' },
        { collection = 'multiplayer_overlays', overlay = 'NGHip_M_Hair_000' },
        { collection = 'multiplayer_overlays', overlay = 'NGHip_M_Hair_001' },
        { collection = 'multiplayer_overlays', overlay = 'NGInd_M_Hair_000' },
	},
	[GetHashKey("mp_f_freemode_01")] = {
        { collection = 'mpbeach_overlays', overlay = 'FM_Hair_Fuzz' },
		{ collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_000_F' },
		{ collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_001_F' },
		{ collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_002_F' },
		{ collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_003_F' },
		{ collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_004_F' },
		{ collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_005_F' },
		{ collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_006_F' },
		{ collection = 'mpbusiness_overlays', overlay = 'FM_Bus_F_Hair_a' },
		{ collection = 'mpbusiness_overlays', overlay = 'FM_Bus_F_Hair_b' },
		{ collection = 'mpbusiness_overlays', overlay = 'FM_Bus_F_Hair_c' },
		{ collection = 'mpbusiness_overlays', overlay = 'FM_Bus_F_Hair_d' },
		{ collection = 'mpbusiness_overlays', overlay = 'FM_Bus_F_Hair_e' },
		{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Hair_F_000_F' },
		{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Hair_F_001_F' },
		{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Hair_000_a' },
		{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Hair_000_b' },
		{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Hair_000_c' },
		{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Hair_000_d' },
		{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Hair_000_e' },
		{ collection = 'mphipster_overlays', overlay = 'FM_F_Hair_017_a' },
		{ collection = 'mphipster_overlays', overlay = 'FM_F_Hair_017_b' },
		{ collection = 'mphipster_overlays', overlay = 'FM_F_Hair_017_c' },
		{ collection = 'mphipster_overlays', overlay = 'FM_F_Hair_017_d' },
		{ collection = 'mphipster_overlays', overlay = 'FM_F_Hair_017_e' },
		{ collection = 'mphipster_overlays', overlay = 'FM_F_Hair_020_a' },
		{ collection = 'mphipster_overlays', overlay = 'FM_F_Hair_020_b' },
		{ collection = 'mphipster_overlays', overlay = 'FM_F_Hair_020_c' },
		{ collection = 'mphipster_overlays', overlay = 'FM_F_Hair_020_d' },
		{ collection = 'mphipster_overlays', overlay = 'FM_F_Hair_020_e' },
		{ collection = 'mplowrider2_overlays', overlay = 'LR_F_Hair_003' },
		{ collection = 'mplowrider2_overlays', overlay = 'LR_F_Hair_004' },
		{ collection = 'mplowrider2_overlays', overlay = 'LR_F_Hair_006' },
		{ collection = 'mplowrider_overlays', overlay = 'LR_F_Hair_000' },
		{ collection = 'mplowrider_overlays', overlay = 'LR_F_Hair_001' },
		{ collection = 'mplowrider_overlays', overlay = 'LR_F_Hair_002' },
		{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Hair_F_000_F' },
		{ collection = 'multiplayer_overlays', overlay = 'FM_F_Hair_005_a' },
		{ collection = 'multiplayer_overlays', overlay = 'FM_F_Hair_005_b' },
		{ collection = 'multiplayer_overlays', overlay = 'FM_F_Hair_005_c' },
		{ collection = 'multiplayer_overlays', overlay = 'FM_F_Hair_005_d' },
		{ collection = 'multiplayer_overlays', overlay = 'FM_F_Hair_005_e' },
		{ collection = 'multiplayer_overlays', overlay = 'FM_F_Hair_006_a' },
		{ collection = 'multiplayer_overlays', overlay = 'FM_F_Hair_006_b' },
		{ collection = 'multiplayer_overlays', overlay = 'FM_F_Hair_006_c' },
		{ collection = 'multiplayer_overlays', overlay = 'FM_F_Hair_006_d' },
		{ collection = 'multiplayer_overlays', overlay = 'FM_F_Hair_006_e' },
		{ collection = 'multiplayer_overlays', overlay = 'FM_F_Hair_013_a' },
		{ collection = 'multiplayer_overlays', overlay = 'FM_F_Hair_013_b' },
		{ collection = 'multiplayer_overlays', overlay = 'FM_F_Hair_013_c' },
		{ collection = 'multiplayer_overlays', overlay = 'FM_F_Hair_013_d' },
		{ collection = 'multiplayer_overlays', overlay = 'FM_F_Hair_013_e' },
		{ collection = 'multiplayer_overlays', overlay = 'FM_F_Hair_014_a' },
		{ collection = 'multiplayer_overlays', overlay = 'FM_F_Hair_014_b' },
		{ collection = 'multiplayer_overlays', overlay = 'FM_F_Hair_014_c' },
		{ collection = 'multiplayer_overlays', overlay = 'FM_F_Hair_014_d' },
		{ collection = 'multiplayer_overlays', overlay = 'FM_F_Hair_014_e' },
		{ collection = 'multiplayer_overlays', overlay = 'FM_F_Hair_long_a' },
		{ collection = 'multiplayer_overlays', overlay = 'FM_F_Hair_long_b' },
		{ collection = 'multiplayer_overlays', overlay = 'FM_F_Hair_long_c' },
		{ collection = 'multiplayer_overlays', overlay = 'FM_F_Hair_long_d' },
		{ collection = 'multiplayer_overlays', overlay = 'FM_F_Hair_long_e' },
        { collection = 'multiplayer_overlays', overlay = 'NG_F_Hair_001' },
        { collection = 'multiplayer_overlays', overlay = 'NG_F_Hair_002' },
        { collection = 'multiplayer_overlays', overlay = 'NG_F_Hair_003' },
        { collection = 'multiplayer_overlays', overlay = 'NG_F_Hair_004' },
        { collection = 'multiplayer_overlays', overlay = 'NG_F_Hair_005' },
        { collection = 'multiplayer_overlays', overlay = 'NG_F_Hair_006' },
        { collection = 'multiplayer_overlays', overlay = 'NG_F_Hair_007' },
        { collection = 'multiplayer_overlays', overlay = 'NG_F_Hair_008' },
        { collection = 'multiplayer_overlays', overlay = 'NG_F_Hair_009' },
        { collection = 'multiplayer_overlays', overlay = 'NG_F_Hair_010' },
        { collection = 'multiplayer_overlays', overlay = 'NG_F_Hair_011' },
        { collection = 'multiplayer_overlays', overlay = 'NG_F_Hair_012' },
        { collection = 'multiplayer_overlays', overlay = 'NG_F_Hair_013' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_014' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_015' },
        { collection = 'multiplayer_overlays', overlay = 'NGBea_F_Hair_000' },
        { collection = 'multiplayer_overlays', overlay = 'NGBea_F_Hair_001' },
        { collection = 'multiplayer_overlays', overlay = 'NGBus_F_Hair_000' },
        { collection = 'multiplayer_overlays', overlay = 'NGBus_F_Hair_001' },
        { collection = 'multiplayer_overlays', overlay = 'NGHip_F_Hair_000' },
        { collection = 'multiplayer_overlays', overlay = 'NGInd_F_Hair_000' },
	},
}

function getOverlays()
    if GetResourceState("nation_tattoos") == "started" then
        return exports["nation_tattoos"].getOverlays()
    end
    return overlays[GetEntityModel(PlayerPedId())] or {}
end

function getOverlayByIndex(index)
    if GetResourceState("nation_tattoos") == "started" then
        return exports["nation_tattoos"].getOverlayByIndex(index)
    end
    return getOverlays()[index]
end

exports("getOverlays", getOverlays)
exports("getOverlayByIndex", getOverlayByIndex)


RegisterNetEvent("nation_barbershop:init")
AddEventHandler("nation_barbershop:init", function(char)
    if char then
        player = char
    end
    startCharLooping = true
end)

RegisterNetEvent("nation_barbershop:stop")
AddEventHandler("nation_barbershop:stop", function()
    startCharLooping = false
end)

RegisterNetEvent("nation_barbershop:reloadOverlay")
AddEventHandler("nation_barbershop:reloadOverlay", function()
    local ped = PlayerPedId()
    if player.overlay and player.overlay > 0 then
        local decoration = getOverlayByIndex(player.overlay)
        if decoration then
            local collection = GetHashKey(decoration.collection)
            local overlay = GetHashKey(decoration.overlay)
            AddPedDecorationFromHashesInCorona(ped, collection, overlay)
        end
    end
end)

function setClothing(data)
	local ped = PlayerPedId()
    if not data then
        return
    end
    if not data.pants then
        return setClothes(data)
    end

    local components = { mask = 1, arms = 3, pants = 4, backpack = 5, shoes = 6, accessory = 7, tshirt = 8, vest = 9, decals = 10, torso = 11 }
    local props = { hat = 0, glass = 1, ear = 2, watch = 6, bracelet = 7 }
    for comp, i in pairs(components) do
        if data[comp] then
            SetPedComponentVariation(ped,i,data[comp].item,data[comp].texture,2)
        end
    end
    for prop, i in pairs(props) do
        if data[prop] and data[prop].item > 0 then
            SetPedPropIndex(ped,i,data[prop].item,data[prop].texture,2)
        else
            ClearPedProp(ped,i)
        end
    end
end

fclient.setClothing = setClothing

function GetHeadBlendData(ped)
    local p = {Citizen.InvokeNative(0x2746BD9D88C5C5D0, ped, Citizen.PointerValueIntInitialized(0), Citizen.PointerValueIntInitialized(0), Citizen.PointerValueIntInitialized(0), Citizen.PointerValueIntInitialized(0), Citizen.PointerValueIntInitialized(0), Citizen.PointerValueIntInitialized(0), Citizen.PointerValueFloatInitialized(0), Citizen.PointerValueFloatInitialized(0), Citizen.PointerValueFloatInitialized(0))}
    local headBlendData = {
        shapeFirst = p[1],
        shapeSecond = p[2],
        shapeThird = p[3],
        skinFirst = p[4],
        skinSecond = p[5],
        skinThird = p[6],
        shapeMix = p[7],
        skinMix = p[8],
        thirdMix = p[9]
    }
    return headBlendData
end

RegisterCommand("barbershop", function() -- abrir menu do barbershop (admin)
    if func.checkPermission({"manager.permissao"}) then
        startBarbershop("admin")
    end
end)



charThread = function()
    local headOverlays = {
        [0] = "blemishes",
        [1] = "facialHair",
        [2] = "eyebrows",
        [3] = "ageing",
        [4] = "makeup",
        [5] = "blush",
        [6] = "complexion",
        [7] = "sunDamage",
        [8] = "lipstick",
        [9] = "freckles",
        [10] = "chestHair",
        [11] = "bodyBlemishes",
        [12] = "addBodyBlemishes",
    }
    local faceFeatures = {
        [0] = "noseWidth",
        [1] = "nosePeakHeight",
        [2] = "nosePeakLength",
        [3] = "noseBoneHigh",
        [4] = "nosePeakLowering",
        [5] = "noseBoneTwist",
        [6] = "eyeBrownHigh",
        [7] = "eyeBrownForward",
        [8] = "cheeksBoneHigh",
        [9] = "cheeksBoneWidth",
        [10] = "cheeksWidth",
        [11] = "eyesOpenning",
        [12] = "lipsThickness",
        [13] = "jawBoneWidth",
        [14] = "jawBoneBackLength",
        [15] = "chinBoneLowering",
        [16] = "chinBoneLength",
        [17] = "chinBoneWidth",
        [18] = "chinHole",
        [19] = "neckThickness"
    }
    while true do
        if startCharLooping and player then
            local ped = PlayerPedId()
            SetPedHeadBlendData(ped, player.shapeFirst, player.shapeSecond, player.shapeThird or 0, player.skinFirst, player.skinSecond, player.skinThird or 0, player.shapeMix, player.skinMix, player.thirdMix or f(0), false)
            SetPedComponentVariation(ped, 2, player["hair"], 0, 0)
            SetPedHairColor(ped, player["hair-color"], player["hair-highlightcolor"])
            SetPedEyeColor(ped, player.eyes)
            for overlayId, key in pairs(headOverlays) do
                local colourType = 0
                if key:find("eyebrows") or key:find("facialHair") or key:find("chestHair") then
                    colourType = 1
                elseif key:find("blush") or key:find("lipstick") or key:find("makeup") then
                    colourType = 2
                end
                SetPedHeadOverlay(ped, overlayId, player[key], player[key.."-opacity"])
                SetPedHeadOverlayColor(ped, overlayId, colourType, player[key.."-color"], player[key.."-color"])
            end
            for index, key in pairs(faceFeatures) do
                SetPedFaceFeature(ped, index, player[key])
            end
        end
        Wait(1000) -- tempo do looping para setar as customizações
    end 
end

CreateThread(charThread)


