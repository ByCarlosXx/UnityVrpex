local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
func = Tunnel.getInterface("nation_tattoos")
fclient = {}
Tunnel.bindInterface("nation_tattoos", fclient)


tattoos,overlay = {}, 0
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

handsUp = false
handsup = function()
    handsUp = not handsUp
    if handsUp then
        freezeAnim("random@mugging3", "handsup_standing_base", 49)
    else
        freezeAnim("move_f@multiplayer", "idle")
    end
end


resetCloths = function()
    local clothes = {
        [GetHashKey("mp_m_freemode_01")] = {
            ["gender"] = "male",
            ["bodyArmors"] = { 0, 0, 0 },
            ["torsos"] = { 15, 0, 2 },
            ["accessories"] = { -1, 0, 2 },
            ["hats"] = { -1,0 },
            ["masks"] = { 0,0,0 },
            ["undershirts"] = { 15, 0, 2 },
            ["shoes"] = { 5, 0, 2 },
            ["bracelets"] = { -1,0 },
            ["tops"] = { 15, 0, 2 },
            ["bags"] = { 0,0,0 },
            ["ears"] = { -1,0 },
            ["decals"] = { 0,0,0 },
            ["legs"] = { 29, 0, 2 },
            ["watches"] = { -1,0 },
            ["glasses"] = { -1,0 },
        },

        [GetHashKey("mp_f_freemode_01")] = {
            ["gender"] = "female",
            ["bodyArmors"] = { 0, 0, 0 },
            ["torsos"] = { 15, 0, 2 },
            ["accessories"] = { -1, 0, 2 },
            ["hats"] = { -1,0 },
            ["masks"] = { 0,0,0 },
            ["undershirts"] = { 14, 0, 2 },
            ["shoes"] = { 35, 0, 2 },
            ["bracelets"] = { -1,0 },
            ["tops"] = { 15, 0, 2 },
            ["bags"] = { 0,0,0 },
            ["ears"] = { -1,0 },
            ["decals"] = { 0,0,0 },
            ["legs"] = { 15, 0, 2 },
            ["watches"] = { -1,0 },
            ["glasses"] = { -1,0 },
        },
    }
    local model = GetEntityModel(PlayerPedId())
    setClothes(clothes[model] or {})
end




---------------------------------------------------------------------------
-----------------------CÂMERAS--------------------------
---------------------------------------------------------------------------

local cameras = {
    body = { coords = vec3(0.4, 2.1, 0.9), point = vec3(-0.7,-0.1,-0.2) }, 
    head = { coords = vec3(0.0, 0.6, 0.2), point = vec3(-0.1,0.0,0.6) },
    chest = { coords = vec3(0.0, 1.2, 0.7), point = vec3(-0.4,0.0,0.2) },
    rightArm = { coords = vec3(1.2, 0.6, 0.2), point = vec3(-0.95,0.0,0.0) },
    leftArm = { coords = vec3(-1.3, 0.4, 0.2), point = vec3(-0.55,-0.1,0.2) },
    leftLeg = { coords = vec3(-1.2, 0.8, -0.05), point = vec3(-0.35,-0.1,-0.55) },
    rightLeg = { coords = vec3(1.1, 0.9, 0.01), point = vec3(-0.85,-0.1,-0.51) },
}


componentCams = {
    ["torso"] = "chest",
    ["head"] = "head",
    ["overlay"] = "head",
    ["leftArm"] = "leftArm",
    ["leftLeg"] = "leftLeg",
    ["rightArm"] = "rightArm",
    ["rightLeg"] = "rightLeg",
}


local activeCam
function interpCamera(cameraName)
    if cameras[cameraName] and cameraName ~= activeCam then
        local ped = PlayerPedId()
        activeCam = cameraName
        local cam = cameras[cameraName]
        local pointCoords = vec(0.0, 0.0, 0.0)
        if cam.bone then
            local bone = GetEntityBoneIndexByName(ped, cam.bone)
            pointCoords = GetWorldPositionOfEntityBone(ped, bone)
        else
            pointCoords = GetOffsetFromEntityInWorldCoords(ped,cam.point)
        end
        local coord = GetOffsetFromEntityInWorldCoords(ped,cam.coords.x, cam.coords.y, cam.coords.z)
        local tempCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coord.x, coord.y, cam.coords.z + pointCoords.z, 0,0,0, 50.0)
        SetCamActive(tempCam, true)
        SetCamActiveWithInterp(tempCam, fixedCam, 600, true, true)
        PointCamAtCoord(tempCam, pointCoords)
        if cam.f then cam.f() end
        CreateThread(function()
            Wait(600)
            DestroyCam(fixedCam)
            fixedCam = tempCam
        end)
    end
end




function createCamera()
    local ped = PlayerPedId()
    local groundCam = CreateCam("DEFAULT_SCRIPTED_CAMERA")
    AttachCamToEntity(groundCam, ped, 0.0, -1.5, 0.0)
    SetCamActive(groundCam, true)
    RenderScriptCams(true, false, 1, true, true)
    activeCam = "body"
    local cam = cameras[activeCam]
    local pointCoords = vec(0.0, 0.0, 0.0)
    if cam.bone then
        local bone = GetEntityBoneIndexByName(ped, cam.bone)
        pointCoords = GetWorldPositionOfEntityBone(ped, bone)
    else
        pointCoords = GetOffsetFromEntityInWorldCoords(ped,cam.point)
    end
    local coord = GetOffsetFromEntityInWorldCoords(ped,cam.coords.x, cam.coords.y, cam.coords.z)
    fixedCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coord.x, coord.y, cam.coords.z + pointCoords.z, 0,0,0, 50.0)
    PointCamAtCoord(fixedCam, pointCoords)
    SetCamActive(fixedCam, true)
    SetCamActiveWithInterp(fixedCam, groundCam, 1000, true, true)
    if cam.f then cam.f() end
    CreateThread(function()
        Wait(1000)
        DestroyCam(groundCam)
    end)
end






getPopupText = function(total) -- TEXTO QUE VAI APARECER NO POPUP NA HORA DE COMPRAR
    return "você deseja pagar o valor de $ <b>"..format(total or 0).."</b> ?"
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




local tattooShops = {
    [1] = { coords = vec3(1321.37, -1655.36, 52.28), h = 35.24, perm = nil },
    [2] = { coords = vec3(-1155.9, -1428.82, 4.96), h = 33.89 },
    [3] = { coords = vec3(325.92, 180.74, 103.59), h = 151.48 },
    [4] = { coords = vec3(-3169.7, 1079.14, 20.84), h = 246.71 },
    [5] = { coords = vec3(1865.99, 3746.25, 33.03), h = 296.08 },
    [6] = { coords = vec3(-295.95, 6201.12, 31.49), h = 144.56 },
    [7] = { coords = vec3(-332.99, 7188.11, 6.48), h = 189.53 },
	[8] = { coords = vec3(-2100.39,-524.4,13.36), h = 249.53 },
	[9] = { coords = vec3(-2094.67,-515.51,12.82), h = 149.53 },
}

function addBlips()
    for _, v in pairs(tattooShops) do
        if v.blip ~= false then
            local blip = AddBlipForCoord(v.coords)
            SetBlipSprite(blip, v.id or 75)
            SetBlipColour(blip, v.color or 13)
            SetBlipScale(blip, 0.5)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(v.name or "Loja de Tattoos")
            EndTextCommandSetBlipName(blip)
        end
    end
end



local defaultPrices = {
    ["torso"] = 150,
    ["head"] = 100,
    ["leftLeg"] = 200,
    ["rightLeg"] = 200,
    ["rightArm"] = 200,
    ["leftArm"] = 200,
    ["overlay"] = 100,
}

local customTattooShops = {
    ["test"] = { -- exemplo de como bloquear componentes, tattoos e alterar preços de cada tattoo individualmente
        ["leftLeg"] = {
            male = {
                type = "remove",
                [1] = true,
                [2] = 500,
                [3] = true,
                [4] = true
            },
            female = {
                type = "remove",
                [1] = true,
                [2] = 500,
                [3] = true,
                [4] = true
            }
        },
        ["torso"] = {
            male = {
                type = "insert",
                [2] = 500
            }
        },
        ["head"] = {
            blocked = true,
        },
        ["overlay"] = {
            blocked = true,
        },
    },
}




function isComponentBlocked(id, component)
    return customTattooShops[id] and customTattooShops[id][component] and customTattooShops[id][component].blocked
end

function isItemBlocked(id, component, index, gender)
    if customTattooShops[id] and customTattooShops[id][component] and customTattooShops[id][component][gender] then
        local c = customTattooShops[id][component][gender]
        if not c.type then c.type = "remove" end
        return (c.type == "insert" and (not c[index] or (type(c[index]) == "table" and c[index].blocked))) or (c.type == "remove" and c[index] and (type(c[index]) == "boolean" or (type(c[index]) == "table" and c[index].blocked)))
    end
    return false
end



function getItemPrice(id, key, value, gender)
    local price = defaultPrices[key] or 0
    if customTattooShops[id] and customTattooShops[id][key] and customTattooShops[id][key][gender] then
        local c = customTattooShops[id][key][gender]
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

function getCartTotal(cart, oldTattoos, oldOverlay, id)
    local total = 0
    local gender = getGender()
    local hasValue = function(t, value)
        for k,v in pairs(t) do 
            if v == value then return k end
        end
    end
    for key, value in pairs(cart) do
        if key == "tattoos" then
            for i, v in ipairs(value) do 
                if not hasValue(oldTattoos, v) then
                    local index,k = getTattooIndex(v)
                    total = math.floor(total + getItemPrice(id, k, index, gender))
                end
            end
        elseif key == "overlay" then
            if value > 0 and value ~= oldOverlay then
                total = math.floor(total + getItemPrice(id, key, value, gender))
            end
        end
    end
    return total, "valor: $ "..format(total)
end

function getNearestTattooShop()
    local ped = PlayerPedId()
    local myCoords = GetEntityCoords(ped)
    for i, v in ipairs(tattooShops) do
        local coords = v.coords
        local distance = #(myCoords - coords)
        if distance < 2 then
            return i, v
        end
    end
end


function drawMarkers()
    if not tattooId then return end
    local x,y,z = table.unpack(nearestTattooShop.coords)
    DrawMarker(1,x,y,z-0.9,0,0,0,0,0,0,0.75,0.75,1.75,90, 135, 242,50,0,1,1,1)
end

function nearTattooShop()
    local idle = 500
    while nearestTattooShop do
        if not inMenu then
            idle = 0
            local ped = PlayerPedId()
            local myCoords = GetEntityCoords(ped)
            local distance = #(myCoords - nearestTattooShop.coords)
            if distance >= 2 or GetEntityHealth(ped) <= 101 then
                nearestTattooShop = nil
                tattooId = nil
                if inMenu then
                    closeMenu()
                end
                break
            end
            drawMarkers()
            if distance < 1.5 then
                if IsControlJustPressed(0, 38) and GetEntityHealth(ped) > 101 and func.checkPermission(nearestTattooShop.perm) then
                    startTattoos(tattooId)
                end
            end
        end
        Wait(idle)
    end
end



local function mainThread()
    while true do
        if not inMenu then
            tattooId, nearestTattooShop = getNearestTattooShop()
            if tattooId then
                nearTattooShop()
            end
        end
        Wait(1000)  
    end
end

CreateThread(mainThread)


function setPlayersVisible(bool)
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, not bool)
    if bool then
        for _, player in ipairs(GetActivePlayers()) do
            local otherPlayer = GetPlayerPed(player)
            if ped ~= otherPlayer then
                SetEntityVisible(otherPlayer, bool)
            end
        end
    else
        CreateThread(function()
            while inMenu do
                for _, player in ipairs(GetActivePlayers()) do
                    local otherPlayer = GetPlayerPed(player)
                    if ped ~= otherPlayer then
                        SetEntityVisible(otherPlayer, bool)
                    end
                end
                InvalidateIdleCam()
                Wait(1)
            end
        end)
    end
end

function initTattooShop()
    DoScreenFadeOut(1000)
    Wait(1000)
    TriggerEvent('nation_hud:updateHud', false)
    local ped = PlayerPedId()
    myClothes = getMyClothes()
    resetCloths()
    setPlayersVisible(false)
    if nearestTattooShop then
        SetEntityCoordsNoOffset(ped, nearestTattooShop.coords)
        SetEntityHeading(ped, nearestTattooShop.h)
    end
    freezeAnim("move_f@multiplayer", "idle")
    SetFacialIdleAnimOverride(ped, "pose_normal_1", 0)
    DoScreenFadeIn(2500)
end

function finishTattooShop()
    local ped = PlayerPedId()
    setClothes(myClothes)
    ClearPedTasks(ped)
    ClearFacialIdleAnimOverride(ped)
    TriggerEvent('nation_hud:updateHud', true)
    setPlayersVisible(true)
end


local tattooList =  {
	[GetHashKey("mp_m_freemode_01")] = {
		[0] = {
			{ collection = 'mpairraces_overlays', overlay = 'MP_Airraces_Tattoo_000_M' },
			{ collection = 'mpairraces_overlays', overlay = 'MP_Airraces_Tattoo_001_M' },
			{ collection = 'mpairraces_overlays', overlay = 'MP_Airraces_Tattoo_002_M' },
			{ collection = 'mpairraces_overlays', overlay = 'MP_Airraces_Tattoo_004_M' },
			{ collection = 'mpairraces_overlays', overlay = 'MP_Airraces_Tattoo_005_M' },
			{ collection = 'mpairraces_overlays', overlay = 'MP_Airraces_Tattoo_006_M' },
			{ collection = 'mpairraces_overlays', overlay = 'MP_Airraces_Tattoo_007_M' },
			{ collection = 'mpbeach_overlays', overlay = 'MP_Bea_M_Back_000' },
			{ collection = 'mpbeach_overlays', overlay = 'MP_Bea_M_Chest_000' },
			{ collection = 'mpbeach_overlays', overlay = 'MP_Bea_M_Chest_001' },
			{ collection = 'mpbeach_overlays', overlay = 'MP_Bea_M_Stom_000' },
			{ collection = 'mpbeach_overlays', overlay = 'MP_Bea_M_Stom_001' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_000_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_001_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_003_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_005_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_006_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_008_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_010_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_011_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_013_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_017_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_018_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_019_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_021_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_023_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_026_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_029_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_030_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_031_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_032_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_034_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_039_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_041_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_043_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_050_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_052_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_058_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_059_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_060_M' },
			{ collection = 'mpbusiness_overlays', overlay = 'MP_Buis_M_Stomach_000' },
			{ collection = 'mpbusiness_overlays', overlay = 'MP_Buis_M_Chest_000' },
			{ collection = 'mpbusiness_overlays', overlay = 'MP_Buis_M_Chest_001' },
			{ collection = 'mpbusiness_overlays', overlay = 'MP_Buis_M_Back_000' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_000_M' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_002_M' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_003_M' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_005_M' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_008_M' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_009_M' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_010_M' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_011_M' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_015_M' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_016_M' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_019_M' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_020_M' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_021_M' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_022_M' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_024_M' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_026_M' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_027_M' },
			{ collection = 'mpchristmas2018_overlays', overlay = 'MP_Christmas2018_Tat_000_M' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_M_Tat_005' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_M_Tat_006' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_M_Tat_009' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_M_Tat_011' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_M_Tat_013' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_M_Tat_015' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_M_Tat_016' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_M_Tat_017' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_M_Tat_018' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_M_Tat_019' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_M_Tat_028' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_000_M' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_001_M' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_009_M' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_010_M' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_012_M' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_013_M' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_014_M' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_017_M' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_018_M' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_019_M' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_020_M' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_022_M' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_028_M' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_029_M' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_023_M' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_024_M' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_025_M' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_026_M' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_027_M' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_028_M' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_029_M' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_030_M' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_033_M' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_035_M' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_036_M' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_037_M' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_038_M' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_039_M' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_004_M' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_013_M' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_014_M' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_015_M' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_016_M' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_017_M' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_018_M' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_019_M' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_020_M' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_021_M' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_022_M' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_023_M' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_030_M' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Tat_000' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Tat_002' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Tat_006' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Tat_011' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Tat_012' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Tat_013' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Tat_024' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Tat_025' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Tat_029' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Tat_030' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Tat_031' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Tat_032' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Tat_033' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Tat_035' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Tat_041' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Tat_046' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Tat_047' },
			{ collection = 'mpimportexport_overlays', overlay = 'MP_MP_ImportExport_Tat_000_M' },
			{ collection = 'mpimportexport_overlays', overlay = 'MP_MP_ImportExport_Tat_001_M' },
			{ collection = 'mpimportexport_overlays', overlay = 'MP_MP_ImportExport_Tat_002_M' },
			{ collection = 'mpimportexport_overlays', overlay = 'MP_MP_ImportExport_Tat_009_M' },
			{ collection = 'mpimportexport_overlays', overlay = 'MP_MP_ImportExport_Tat_010_M' },
			{ collection = 'mpimportexport_overlays', overlay = 'MP_MP_ImportExport_Tat_011_M' },
			{ collection = 'mplowrider2_overlays', overlay = 'MP_LR_Tat_000_M' },
			{ collection = 'mplowrider2_overlays', overlay = 'MP_LR_Tat_008_M' },
			{ collection = 'mplowrider2_overlays', overlay = 'MP_LR_Tat_011_M' },
			{ collection = 'mplowrider2_overlays', overlay = 'MP_LR_Tat_012_M' },
			{ collection = 'mplowrider2_overlays', overlay = 'MP_LR_Tat_016_M' },
			{ collection = 'mplowrider2_overlays', overlay = 'MP_LR_Tat_019_M' },
			{ collection = 'mplowrider2_overlays', overlay = 'MP_LR_Tat_031_M' },
			{ collection = 'mplowrider2_overlays', overlay = 'MP_LR_Tat_032_M' },
			{ collection = 'mplowrider_overlays', overlay = 'MP_LR_Tat_001_M' },
			{ collection = 'mplowrider_overlays', overlay = 'MP_LR_Tat_002_M' },
			{ collection = 'mplowrider_overlays', overlay = 'MP_LR_Tat_004_M' },
			{ collection = 'mplowrider_overlays', overlay = 'MP_LR_Tat_009_M' },
			{ collection = 'mplowrider_overlays', overlay = 'MP_LR_Tat_010_M' },
			{ collection = 'mplowrider_overlays', overlay = 'MP_LR_Tat_013_M' },
			{ collection = 'mplowrider_overlays', overlay = 'MP_LR_Tat_014_M' },
			{ collection = 'mplowrider_overlays', overlay = 'MP_LR_Tat_021_M' },
			{ collection = 'mplowrider_overlays', overlay = 'MP_LR_Tat_026_M' },
			{ collection = 'mpluxe2_overlays', overlay = 'MP_LUXE_TAT_002_M' },
			{ collection = 'mpluxe2_overlays', overlay = 'MP_LUXE_TAT_012_M' },
			{ collection = 'mpluxe2_overlays', overlay = 'MP_LUXE_TAT_022_M' },
			{ collection = 'mpluxe2_overlays', overlay = 'MP_LUXE_TAT_025_M' },
			{ collection = 'mpluxe2_overlays', overlay = 'MP_LUXE_TAT_027_M' },
			{ collection = 'mpluxe2_overlays', overlay = 'MP_LUXE_TAT_029_M' },
			{ collection = 'mpluxe_overlays', overlay = 'MP_LUXE_TAT_003_M' },
			{ collection = 'mpluxe_overlays', overlay = 'MP_LUXE_TAT_006_M' },
			{ collection = 'mpluxe_overlays', overlay = 'MP_LUXE_TAT_007_M' },
			{ collection = 'mpluxe_overlays', overlay = 'MP_LUXE_TAT_008_M' },
			{ collection = 'mpluxe_overlays', overlay = 'MP_LUXE_TAT_014_M' },
			{ collection = 'mpluxe_overlays', overlay = 'MP_LUXE_TAT_015_M' },
			{ collection = 'mpluxe_overlays', overlay = 'MP_LUXE_TAT_024_M' },
			{ collection = 'mpsmuggler_overlays', overlay = 'MP_Smuggler_Tattoo_000_M' },
			{ collection = 'mpsmuggler_overlays', overlay = 'MP_Smuggler_Tattoo_002_M' },
			{ collection = 'mpsmuggler_overlays', overlay = 'MP_Smuggler_Tattoo_003_M' },
			{ collection = 'mpsmuggler_overlays', overlay = 'MP_Smuggler_Tattoo_006_M' },
			{ collection = 'mpsmuggler_overlays', overlay = 'MP_Smuggler_Tattoo_007_M' },
			{ collection = 'mpsmuggler_overlays', overlay = 'MP_Smuggler_Tattoo_009_M' },
			{ collection = 'mpsmuggler_overlays', overlay = 'MP_Smuggler_Tattoo_010_M' },
			{ collection = 'mpsmuggler_overlays', overlay = 'MP_Smuggler_Tattoo_013_M' },
			{ collection = 'mpsmuggler_overlays', overlay = 'MP_Smuggler_Tattoo_015_M' },
			{ collection = 'mpsmuggler_overlays', overlay = 'MP_Smuggler_Tattoo_016_M' },
			{ collection = 'mpsmuggler_overlays', overlay = 'MP_Smuggler_Tattoo_017_M' },
			{ collection = 'mpsmuggler_overlays', overlay = 'MP_Smuggler_Tattoo_018_M' },
			{ collection = 'mpsmuggler_overlays', overlay = 'MP_Smuggler_Tattoo_019_M' },
			{ collection = 'mpsmuggler_overlays', overlay = 'MP_Smuggler_Tattoo_021_M' },
			{ collection = 'mpsmuggler_overlays', overlay = 'MP_Smuggler_Tattoo_022_M' },
			{ collection = 'mpsmuggler_overlays', overlay = 'MP_Smuggler_Tattoo_024_M' },
			{ collection = 'mpsmuggler_overlays', overlay = 'MP_Smuggler_Tattoo_025_M' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_011_M' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_012_M' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_014_M' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_018_M' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_019_M' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_024_M' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_026_M' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_027_M' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_029_M' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_030_M' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_033_M' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_034_M' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_037_M' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_040_M' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_041_M' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_044_M' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_046_M' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_048_M' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_000_M' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_001_M' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_003_M' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_006_M' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_007_M' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_008_M' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_009_M' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_010_M' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_011_M' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_012_M' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_015_M' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_016_M' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_017_M' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_021_M' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_022_M' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_023_M' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_024_M' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_029_M' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_030_M' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_031_M' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_032_M' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_Award_M_003' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_Award_M_004' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_Award_M_005' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_Award_M_008' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_Award_M_011' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_Award_M_012' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_Award_M_013' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_Award_M_014' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_Award_M_016' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_Award_M_017' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_Award_M_018' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_Award_M_019' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_M_004' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_M_009' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_M_010' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_M_011' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_M_012' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_M_013' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_M_016' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_M_019' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_M_020' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_M_024' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_M_025' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_M_029' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_M_030' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_M_034' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_M_036' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_M_044' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_M_045' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_M_046' },
		},
		[1] = {
			{ collection = 'mpbeach_overlays', overlay = 'MP_Bea_M_Head_000' },
			{ collection = 'mpbeach_overlays', overlay = 'MP_Bea_M_Head_001' },
			{ collection = 'mpbeach_overlays', overlay = 'MP_Bea_M_Head_002' },
			{ collection = 'mpbeach_overlays', overlay = 'MP_Bea_M_Neck_000' },
			{ collection = 'mpbeach_overlays', overlay = 'MP_Bea_M_Neck_001' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_009_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_038_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_051_M' },
			{ collection = 'mpbusiness_overlays', overlay = 'MP_Buis_M_Neck_000' },
			{ collection = 'mpbusiness_overlays', overlay = 'MP_Buis_M_Neck_001' },
			{ collection = 'mpbusiness_overlays', overlay = 'MP_Buis_M_Neck_002' },
			{ collection = 'mpbusiness_overlays', overlay = 'MP_Buis_M_Neck_003' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_M_Tat_007' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_M_Tat_024' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_M_Tat_025' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_M_Tat_029' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_003_M' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_000_M' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_001_M' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_002_M' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_003_M' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_004_M' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_005_M' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_006_M' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_007_M' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_008_M' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_009_M' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_010_M' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_011_M' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_012_M' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_013_M' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_014_M' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_015_M' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_016_M' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_017_M' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_018_M' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_019_M' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_020_M' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_021_M' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_022_M' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_042_M' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_043_M' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_044_M' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Tat_005' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Tat_021' },
			{ collection = 'mpsmuggler_overlays', overlay = 'MP_Smuggler_Tattoo_011_M' },
			{ collection = 'mpsmuggler_overlays', overlay = 'MP_Smuggler_Tattoo_012_M' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_Tat_000_M' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_004_M' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_006_M' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_017_M' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_042_M' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_Award_M_000' },
		},
		[2] = {
			{ collection = 'mpairraces_overlays', overlay = 'MP_Airraces_Tattoo_003_M' },
			{ collection = 'mpbeach_overlays', overlay = 'MP_Bea_M_LArm_000' },
			{ collection = 'mpbeach_overlays', overlay = 'MP_Bea_M_LArm_001' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_012_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_016_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_020_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_024_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_025_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_035_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_045_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_053_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_055_M' },
			{ collection = 'mpbusiness_overlays', overlay = 'MP_Buis_M_LeftArm_000' },
			{ collection = 'mpbusiness_overlays', overlay = 'MP_Buis_M_LeftArm_001' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_001_M' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_004_M' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_007_M' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_013_M' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_025_M' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_029_M' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_M_Tat_000' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_M_Tat_010' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_M_Tat_012' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_M_Tat_020' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_M_Tat_021' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_004_M' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_008_M' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_015_M' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_016_M' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_025_M' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_027_M' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_040_M' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_041_M' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_009_M' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Tat_003' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Tat_007' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Tat_015' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Tat_016' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Tat_026' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Tat_027' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Tat_028' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Tat_034' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Tat_037' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Tat_039' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Tat_043' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Tat_048' },
			{ collection = 'mpimportexport_overlays', overlay = 'MP_MP_ImportExport_Tat_004_M' },
			{ collection = 'mpimportexport_overlays', overlay = 'MP_MP_ImportExport_Tat_008_M' },
			{ collection = 'mplowrider2_overlays', overlay = 'MP_LR_Tat_006_M' },
			{ collection = 'mplowrider2_overlays', overlay = 'MP_LR_Tat_018_M' },
			{ collection = 'mplowrider2_overlays', overlay = 'MP_LR_Tat_022_M' },
			{ collection = 'mplowrider_overlays', overlay = 'MP_LR_Tat_005_M' },
			{ collection = 'mplowrider_overlays', overlay = 'MP_LR_Tat_027_M' },
			{ collection = 'mplowrider_overlays', overlay = 'MP_LR_Tat_033_M' },
			{ collection = 'mpluxe2_overlays', overlay = 'MP_LUXE_TAT_005_M' },
			{ collection = 'mpluxe2_overlays', overlay = 'MP_LUXE_TAT_016_M' },
			{ collection = 'mpluxe2_overlays', overlay = 'MP_LUXE_TAT_018_M' },
			{ collection = 'mpluxe2_overlays', overlay = 'MP_LUXE_TAT_028_M' },
			{ collection = 'mpluxe2_overlays', overlay = 'MP_LUXE_TAT_031_M' },
			{ collection = 'mpluxe_overlays', overlay = 'MP_LUXE_TAT_009_M' },
			{ collection = 'mpluxe_overlays', overlay = 'MP_LUXE_TAT_020_M' },
			{ collection = 'mpluxe_overlays', overlay = 'MP_LUXE_TAT_021_M' },
			{ collection = 'mpsmuggler_overlays', overlay = 'MP_Smuggler_Tattoo_004_M' },
			{ collection = 'mpsmuggler_overlays', overlay = 'MP_Smuggler_Tattoo_008_M' },
			{ collection = 'mpsmuggler_overlays', overlay = 'MP_Smuggler_Tattoo_014_M' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_001_M' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_002_M' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_008_M' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_022_M' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_023_M' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_035_M' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_039_M' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_043_M' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_002_M' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_005_M' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_014_M' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_019_M' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_026_M' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_Award_M_001' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_Award_M_007' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_Award_M_015' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_M_005' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_M_006' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_M_015' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_M_031' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_M_041' },
		},
		[3] = {
			{ collection = 'mpbeach_overlays', overlay = 'MP_Bea_M_RArm_000' },
			{ collection = 'mpbeach_overlays', overlay = 'MP_Bea_M_RArm_001' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_007_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_014_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_033_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_042_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_046_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_047_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_049_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_054_M' },
			{ collection = 'mpbusiness_overlays', overlay = 'MP_Buis_M_RightArm_000' },
			{ collection = 'mpbusiness_overlays', overlay = 'MP_Buis_M_RightArm_001' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_006_M' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_012_M' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_014_M' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_017_M' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_018_M' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_023_M' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_028_M' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_M_Tat_003' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_M_Tat_004' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_M_Tat_008' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_M_Tat_022' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_M_Tat_023' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_M_Tat_026' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_M_Tat_027' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_002_M' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_021_M' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_024_M' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_034_M' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_000_M' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_001_M' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_002_M' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_003_M' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_005_M' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_006_M' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_007_M' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_008_M' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_011_M' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_012_M' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_026_M' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_031_M' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_032_M' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Tat_001' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Tat_004' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Tat_008' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Tat_010' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Tat_014' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Tat_017' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Tat_018' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Tat_020' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Tat_022' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Tat_023' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Tat_036' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Tat_044' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Tat_045' },
			{ collection = 'mpimportexport_overlays', overlay = 'MP_MP_ImportExport_Tat_003_M' },
			{ collection = 'mpimportexport_overlays', overlay = 'MP_MP_ImportExport_Tat_005_M' },
			{ collection = 'mpimportexport_overlays', overlay = 'MP_MP_ImportExport_Tat_006_M' },
			{ collection = 'mpimportexport_overlays', overlay = 'MP_MP_ImportExport_Tat_007_M' },
			{ collection = 'mplowrider2_overlays', overlay = 'MP_LR_Tat_003_M' },
			{ collection = 'mplowrider2_overlays', overlay = 'MP_LR_Tat_028_M' },
			{ collection = 'mplowrider2_overlays', overlay = 'MP_LR_Tat_035_M' },
			{ collection = 'mplowrider_overlays', overlay = 'MP_LR_Tat_015_M' },
			{ collection = 'mpluxe2_overlays', overlay = 'MP_LUXE_TAT_010_M' },
			{ collection = 'mpluxe2_overlays', overlay = 'MP_LUXE_TAT_017_M' },
			{ collection = 'mpluxe2_overlays', overlay = 'MP_LUXE_TAT_026_M' },
			{ collection = 'mpluxe2_overlays', overlay = 'MP_LUXE_TAT_030_M' },
			{ collection = 'mpluxe_overlays', overlay = 'MP_LUXE_TAT_004_M' },
			{ collection = 'mpluxe_overlays', overlay = 'MP_LUXE_TAT_013_M' },
			{ collection = 'mpluxe_overlays', overlay = 'MP_LUXE_TAT_019_M' },
			{ collection = 'mpsmuggler_overlays', overlay = 'MP_Smuggler_Tattoo_001_M' },
			{ collection = 'mpsmuggler_overlays', overlay = 'MP_Smuggler_Tattoo_005_M' },
			{ collection = 'mpsmuggler_overlays', overlay = 'MP_Smuggler_Tattoo_023_M' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_003_M' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_009_M' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_010_M' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_016_M' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_036_M' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_038_M' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_049_M' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_004_M' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_018_M' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_025_M' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_028_M' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_Award_M_002' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_Award_M_010' },
            { collection = 'multiplayer_overlays', overlay = 'FM_Tat_M_000' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_M_001' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_M_003' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_M_014' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_M_018' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_M_027' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_M_028' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_M_038' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_M_047' },
		},
		[4] = {
			{ collection = 'mpbeach_overlays', overlay = 'MP_Bea_M_Lleg_000' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_002_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_015_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_027_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_036_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_037_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_044_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_056_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_057_M' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_M_Tat_001' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_M_Tat_002' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_005_M' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_007_M' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_011_M' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_023_M' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_032_M' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_010_M' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_024_M' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_025_M' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_028_M' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_029_M' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Tat_009' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Tat_019' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Tat_040' },
			{ collection = 'mplowrider2_overlays', overlay = 'MP_LR_Tat_029_M' },
			{ collection = 'mplowrider_overlays', overlay = 'MP_LR_Tat_007_M' },
			{ collection = 'mplowrider_overlays', overlay = 'MP_LR_Tat_020_M' },
			{ collection = 'mpluxe2_overlays', overlay = 'MP_LUXE_TAT_011_M' },
			{ collection = 'mpluxe_overlays', overlay = 'MP_LUXE_TAT_000_M' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_007_M' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_013_M' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_021_M' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_028_M' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_031_M' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_013_M' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_027_M' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_Award_M_009' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_M_002' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_M_008' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_M_021' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_M_023' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_M_026' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_M_032' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_M_033' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_M_035' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_M_037' },
		},
		[5] = {
			{ collection = 'mpbeach_overlays', overlay = 'MP_Bea_M_Rleg_000' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_004_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_022_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_028_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_040_M' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_048_M' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_M_Tat_014' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_006_M' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_026_M' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_030_M' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_031_M' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_027_M' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Tat_038' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_M_Tat_042' },
			{ collection = 'mplowrider2_overlays', overlay = 'MP_LR_Tat_030_M' },
			{ collection = 'mplowrider_overlays', overlay = 'MP_LR_Tat_017_M' },
			{ collection = 'mplowrider_overlays', overlay = 'MP_LR_Tat_023_M' },
			{ collection = 'mpluxe2_overlays', overlay = 'MP_LUXE_TAT_023_M' },
			{ collection = 'mpluxe_overlays', overlay = 'MP_LUXE_TAT_001_M' },
			{ collection = 'mpsmuggler_overlays', overlay = 'MP_Smuggler_Tattoo_020_M' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_005_M' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_015_M' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_020_M' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_025_M' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_032_M' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_045_M' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_047_M' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_020_M' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_Award_M_006' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_M_007' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_M_017' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_M_022' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_M_039' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_M_040' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_M_042' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_M_043' },
		},
	},
	[GetHashKey("mp_f_freemode_01")] = {
		[0] = {
			{ collection = 'mpairraces_overlays', overlay = 'MP_Airraces_Tattoo_000_F' },
			{ collection = 'mpairraces_overlays', overlay = 'MP_Airraces_Tattoo_001_F' },
			{ collection = 'mpairraces_overlays', overlay = 'MP_Airraces_Tattoo_002_F' },
			{ collection = 'mpairraces_overlays', overlay = 'MP_Airraces_Tattoo_004_F' },
			{ collection = 'mpairraces_overlays', overlay = 'MP_Airraces_Tattoo_005_F' },
			{ collection = 'mpairraces_overlays', overlay = 'MP_Airraces_Tattoo_006_F' },
			{ collection = 'mpairraces_overlays', overlay = 'MP_Airraces_Tattoo_007_F' },
			{ collection = 'mpbeach_overlays', overlay = 'MP_Bea_F_Back_000' },
			{ collection = 'mpbeach_overlays', overlay = 'MP_Bea_F_Back_001' },
			{ collection = 'mpbeach_overlays', overlay = 'MP_Bea_F_Back_002' },
			{ collection = 'mpbeach_overlays', overlay = 'MP_Bea_F_Chest_000' },
			{ collection = 'mpbeach_overlays', overlay = 'MP_Bea_F_Chest_001' },
			{ collection = 'mpbeach_overlays', overlay = 'MP_Bea_F_Chest_002' },
			{ collection = 'mpbeach_overlays', overlay = 'MP_Bea_F_RSide_000' },
			{ collection = 'mpbeach_overlays', overlay = 'MP_Bea_F_Should_000' },
			{ collection = 'mpbeach_overlays', overlay = 'MP_Bea_F_Should_001' },
			{ collection = 'mpbeach_overlays', overlay = 'MP_Bea_F_Stom_000' },
			{ collection = 'mpbeach_overlays', overlay = 'MP_Bea_F_Stom_001' },
			{ collection = 'mpbeach_overlays', overlay = 'MP_Bea_F_Stom_002' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_000_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_001_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_003_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_005_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_006_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_008_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_010_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_011_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_013_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_017_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_018_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_019_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_021_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_023_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_026_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_029_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_030_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_031_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_032_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_034_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_039_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_041_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_043_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_050_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_052_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_058_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_059_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_060_F' },
			{ collection = 'mpbusiness_overlays', overlay = 'MP_Buis_F_Chest_000' },
			{ collection = 'mpbusiness_overlays', overlay = 'MP_Buis_F_Chest_001' },
			{ collection = 'mpbusiness_overlays', overlay = 'MP_Buis_F_Chest_002' },
			{ collection = 'mpbusiness_overlays', overlay = 'MP_Buis_F_Stom_000' },
			{ collection = 'mpbusiness_overlays', overlay = 'MP_Buis_F_Stom_001' },
			{ collection = 'mpbusiness_overlays', overlay = 'MP_Buis_F_Stom_002' },
			{ collection = 'mpbusiness_overlays', overlay = 'MP_Buis_F_Back_000' },
			{ collection = 'mpbusiness_overlays', overlay = 'MP_Buis_F_Back_001' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_000_F' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_002_F' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_003_F' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_005_F' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_008_F' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_009_F' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_010_F' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_011_F' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_015_F' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_016_F' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_019_F' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_020_F' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_021_F' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_022_F' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_024_F' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_026_F' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_027_F' },
			{ collection = 'mpchristmas2018_overlays', overlay = 'MP_Christmas2018_Tat_000_F' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_F_Tat_005' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_F_Tat_006' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_F_Tat_009' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_F_Tat_011' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_F_Tat_013' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_F_Tat_015' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_F_Tat_016' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_F_Tat_017' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_F_Tat_018' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_F_Tat_019' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_F_Tat_028' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_000_F' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_001_F' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_009_F' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_010_F' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_012_F' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_013_F' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_014_F' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_017_F' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_018_F' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_019_F' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_020_F' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_022_F' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_028_F' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_029_F' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_023_F' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_024_F' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_025_F' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_026_F' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_027_F' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_028_F' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_029_F' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_030_F' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_033_F' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_035_F' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_036_F' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_037_F' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_038_F' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_039_F' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_004_F' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_013_F' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_014_F' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_015_F' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_016_F' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_017_F' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_018_F' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_019_F' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_020_F' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_021_F' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_022_F' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_023_F' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_030_F' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Tat_000' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Tat_002' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Tat_006' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Tat_011' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Tat_012' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Tat_013' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Tat_024' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Tat_025' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Tat_029' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Tat_030' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Tat_031' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Tat_032' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Tat_033' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Tat_035' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Tat_041' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Tat_046' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Tat_047' },
			{ collection = 'mpimportexport_overlays', overlay = 'MP_MP_ImportExport_Tat_000_F' },
			{ collection = 'mpimportexport_overlays', overlay = 'MP_MP_ImportExport_Tat_001_F' },
			{ collection = 'mpimportexport_overlays', overlay = 'MP_MP_ImportExport_Tat_002_F' },
			{ collection = 'mpimportexport_overlays', overlay = 'MP_MP_ImportExport_Tat_009_F' },
			{ collection = 'mpimportexport_overlays', overlay = 'MP_MP_ImportExport_Tat_010_F' },
			{ collection = 'mpimportexport_overlays', overlay = 'MP_MP_ImportExport_Tat_011_F' },
			{ collection = 'mplowrider2_overlays', overlay = 'MP_LR_Tat_000_F' },
			{ collection = 'mplowrider2_overlays', overlay = 'MP_LR_Tat_008_F' },
			{ collection = 'mplowrider2_overlays', overlay = 'MP_LR_Tat_011_F' },
			{ collection = 'mplowrider2_overlays', overlay = 'MP_LR_Tat_012_F' },
			{ collection = 'mplowrider2_overlays', overlay = 'MP_LR_Tat_016_F' },
			{ collection = 'mplowrider2_overlays', overlay = 'MP_LR_Tat_019_F' },
			{ collection = 'mplowrider2_overlays', overlay = 'MP_LR_Tat_031_F' },
			{ collection = 'mplowrider2_overlays', overlay = 'MP_LR_Tat_032_F' },
			{ collection = 'mplowrider_overlays', overlay = 'MP_LR_Tat_001_F' },
			{ collection = 'mplowrider_overlays', overlay = 'MP_LR_Tat_002_F' },
			{ collection = 'mplowrider_overlays', overlay = 'MP_LR_Tat_004_F' },
			{ collection = 'mplowrider_overlays', overlay = 'MP_LR_Tat_009_F' },
			{ collection = 'mplowrider_overlays', overlay = 'MP_LR_Tat_010_F' },
			{ collection = 'mplowrider_overlays', overlay = 'MP_LR_Tat_013_F' },
			{ collection = 'mplowrider_overlays', overlay = 'MP_LR_Tat_014_F' },
			{ collection = 'mplowrider_overlays', overlay = 'MP_LR_Tat_021_F' },
			{ collection = 'mplowrider_overlays', overlay = 'MP_LR_Tat_026_F' },
			{ collection = 'mpluxe2_overlays', overlay = 'MP_LUXE_TAT_002_F' },
			{ collection = 'mpluxe2_overlays', overlay = 'MP_LUXE_TAT_012_F' },
			{ collection = 'mpluxe2_overlays', overlay = 'MP_LUXE_TAT_022_F' },
			{ collection = 'mpluxe2_overlays', overlay = 'MP_LUXE_TAT_025_F' },
			{ collection = 'mpluxe2_overlays', overlay = 'MP_LUXE_TAT_027_F' },
			{ collection = 'mpluxe2_overlays', overlay = 'MP_LUXE_TAT_029_F' },
			{ collection = 'mpluxe_overlays', overlay = 'MP_LUXE_TAT_003_F' },
			{ collection = 'mpluxe_overlays', overlay = 'MP_LUXE_TAT_006_F' },
			{ collection = 'mpluxe_overlays', overlay = 'MP_LUXE_TAT_007_F' },
			{ collection = 'mpluxe_overlays', overlay = 'MP_LUXE_TAT_008_F' },
			{ collection = 'mpluxe_overlays', overlay = 'MP_LUXE_TAT_014_F' },
			{ collection = 'mpluxe_overlays', overlay = 'MP_LUXE_TAT_015_F' },
			{ collection = 'mpluxe_overlays', overlay = 'MP_LUXE_TAT_024_F' },
			{ collection = 'mpsmuggler_overlays', overlay = 'MP_Smuggler_Tattoo_000_F' },
			{ collection = 'mpsmuggler_overlays', overlay = 'MP_Smuggler_Tattoo_002_F' },
			{ collection = 'mpsmuggler_overlays', overlay = 'MP_Smuggler_Tattoo_003_F' },
			{ collection = 'mpsmuggler_overlays', overlay = 'MP_Smuggler_Tattoo_006_F' },
			{ collection = 'mpsmuggler_overlays', overlay = 'MP_Smuggler_Tattoo_007_F' },
			{ collection = 'mpsmuggler_overlays', overlay = 'MP_Smuggler_Tattoo_009_F' },
			{ collection = 'mpsmuggler_overlays', overlay = 'MP_Smuggler_Tattoo_010_F' },
			{ collection = 'mpsmuggler_overlays', overlay = 'MP_Smuggler_Tattoo_013_F' },
			{ collection = 'mpsmuggler_overlays', overlay = 'MP_Smuggler_Tattoo_015_F' },
			{ collection = 'mpsmuggler_overlays', overlay = 'MP_Smuggler_Tattoo_016_F' },
			{ collection = 'mpsmuggler_overlays', overlay = 'MP_Smuggler_Tattoo_017_F' },
			{ collection = 'mpsmuggler_overlays', overlay = 'MP_Smuggler_Tattoo_018_F' },
			{ collection = 'mpsmuggler_overlays', overlay = 'MP_Smuggler_Tattoo_019_F' },
			{ collection = 'mpsmuggler_overlays', overlay = 'MP_Smuggler_Tattoo_021_F' },
			{ collection = 'mpsmuggler_overlays', overlay = 'MP_Smuggler_Tattoo_022_F' },
			{ collection = 'mpsmuggler_overlays', overlay = 'MP_Smuggler_Tattoo_024_F' },
			{ collection = 'mpsmuggler_overlays', overlay = 'MP_Smuggler_Tattoo_025_F' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_011_F' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_012_F' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_014_F' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_018_F' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_019_F' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_024_F' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_026_F' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_027_F' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_029_F' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_030_F' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_033_F' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_034_F' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_037_F' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_040_F' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_041_F' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_044_F' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_046_F' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_048_F' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_000_F' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_001_F' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_003_F' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_006_F' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_007_F' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_008_F' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_009_F' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_010_F' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_011_F' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_012_F' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_015_F' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_016_F' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_017_F' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_021_F' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_022_F' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_023_F' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_024_F' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_029_F' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_030_F' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_031_F' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_032_F' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_Award_F_003' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_Award_F_004' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_Award_F_005' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_Award_F_008' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_Award_F_011' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_Award_F_012' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_Award_F_013' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_Award_F_014' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_Award_F_016' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_Award_F_017' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_Award_F_018' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_Award_F_019' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_F_004' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_F_009' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_F_010' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_F_011' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_F_012' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_F_013' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_F_016' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_F_019' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_F_020' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_F_024' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_F_025' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_F_029' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_F_030' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_F_034' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_F_036' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_F_044' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_F_045' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_F_046' },
		},
		[1] = {
			{ collection = 'mpbeach_overlays', overlay = 'MP_Bea_F_Neck_000' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_009_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_038_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_051_F' },
			{ collection = 'mpbusiness_overlays', overlay = 'MP_Buis_F_Neck_000' },
			{ collection = 'mpbusiness_overlays', overlay = 'MP_Buis_F_Neck_001' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_F_Tat_007' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_F_Tat_024' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_F_Tat_025' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_F_Tat_029' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_003_F' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_000_F' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_001_F' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_002_F' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_003_F' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_004_F' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_005_F' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_006_F' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_007_F' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_008_F' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_009_F' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_010_F' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_011_F' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_012_F' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_013_F' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_014_F' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_015_F' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_016_F' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_017_F' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_018_F' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_019_F' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_020_F' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_021_F' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_022_F' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_042_F' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_043_F' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_044_F' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Tat_005' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Tat_021' },
			{ collection = 'mpsmuggler_overlays', overlay = 'MP_Smuggler_Tattoo_011_F' },
			{ collection = 'mpsmuggler_overlays', overlay = 'MP_Smuggler_Tattoo_012_F' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_Tat_000_F' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_004_F' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_006_F' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_017_F' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_042_F' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_Award_F_000' },
		},
		[2] = {
			{ collection = 'mpairraces_overlays', overlay = 'MP_Airraces_Tattoo_003_F' },
			{ collection = 'mpbeach_overlays', overlay = 'MP_Bea_F_LArm_000' },
			{ collection = 'mpbeach_overlays', overlay = 'MP_Bea_F_LArm_001' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_012_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_016_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_020_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_024_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_025_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_035_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_045_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_053_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_055_F' },
			{ collection = 'mpbusiness_overlays', overlay = 'MP_Buis_F_LArm_000' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_001_F' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_004_F' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_007_F' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_013_F' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_025_F' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_029_F' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_F_Tat_000' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_F_Tat_010' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_F_Tat_012' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_F_Tat_020' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_F_Tat_021' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_004_F' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_008_F' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_015_F' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_016_F' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_025_F' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_027_F' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_040_F' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_041_F' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_009_F' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Tat_003' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Tat_007' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Tat_015' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Tat_016' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Tat_026' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Tat_027' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Tat_028' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Tat_034' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Tat_037' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Tat_039' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Tat_043' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Tat_048' },
			{ collection = 'mpimportexport_overlays', overlay = 'MP_MP_ImportExport_Tat_004_F' },
			{ collection = 'mpimportexport_overlays', overlay = 'MP_MP_ImportExport_Tat_008_F' },
			{ collection = 'mplowrider2_overlays', overlay = 'MP_LR_Tat_006_F' },
			{ collection = 'mplowrider2_overlays', overlay = 'MP_LR_Tat_018_F' },
			{ collection = 'mplowrider2_overlays', overlay = 'MP_LR_Tat_022_F' },
			{ collection = 'mplowrider_overlays', overlay = 'MP_LR_Tat_005_F' },
			{ collection = 'mplowrider_overlays', overlay = 'MP_LR_Tat_027_F' },
			{ collection = 'mplowrider_overlays', overlay = 'MP_LR_Tat_033_F' },
			{ collection = 'mpluxe2_overlays', overlay = 'MP_LUXE_TAT_005_F' },
			{ collection = 'mpluxe2_overlays', overlay = 'MP_LUXE_TAT_016_F' },
			{ collection = 'mpluxe2_overlays', overlay = 'MP_LUXE_TAT_018_F' },
			{ collection = 'mpluxe2_overlays', overlay = 'MP_LUXE_TAT_028_F' },
			{ collection = 'mpluxe2_overlays', overlay = 'MP_LUXE_TAT_031_F' },
			{ collection = 'mpluxe_overlays', overlay = 'MP_LUXE_TAT_009_F' },
			{ collection = 'mpluxe_overlays', overlay = 'MP_LUXE_TAT_020_F' },
			{ collection = 'mpluxe_overlays', overlay = 'MP_LUXE_TAT_021_F' },
			{ collection = 'mpsmuggler_overlays', overlay = 'MP_Smuggler_Tattoo_004_F' },
			{ collection = 'mpsmuggler_overlays', overlay = 'MP_Smuggler_Tattoo_008_F' },
			{ collection = 'mpsmuggler_overlays', overlay = 'MP_Smuggler_Tattoo_014_F' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_001_F' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_002_F' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_008_F' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_022_F' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_023_F' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_035_F' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_039_F' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_043_F' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_002_F' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_005_F' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_014_F' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_019_F' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_026_F' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_Award_F_001' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_Award_F_007' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_Award_F_015' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_F_005' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_F_006' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_F_015' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_F_031' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_F_041' },
		},
		[3] = {
			{ collection = 'mpbeach_overlays', overlay = 'MP_Bea_F_RArm_001' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_007_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_014_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_033_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_042_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_046_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_047_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_049_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_054_F' },
			{ collection = 'mpbusiness_overlays', overlay = 'MP_Buis_F_RArm_000' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_006_F' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_012_F' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_014_F' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_017_F' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_018_F' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_023_F' },
			{ collection = 'mpchristmas2017_overlays', overlay = 'MP_Christmas2017_Tattoo_028_F' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_F_Tat_003' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_F_Tat_004' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_F_Tat_008' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_F_Tat_022' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_F_Tat_023' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_F_Tat_026' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_F_Tat_027' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_002_F' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_021_F' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_024_F' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_034_F' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_000_F' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_001_F' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_002_F' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_003_F' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_005_F' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_006_F' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_007_F' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_008_F' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_011_F' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_012_F' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_026_F' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_031_F' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_032_F' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Tat_001' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Tat_004' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Tat_008' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Tat_010' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Tat_014' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Tat_017' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Tat_018' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Tat_020' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Tat_022' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Tat_023' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Tat_036' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Tat_044' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Tat_045' },
			{ collection = 'mpimportexport_overlays', overlay = 'MP_MP_ImportExport_Tat_003_F' },
			{ collection = 'mpimportexport_overlays', overlay = 'MP_MP_ImportExport_Tat_005_F' },
			{ collection = 'mpimportexport_overlays', overlay = 'MP_MP_ImportExport_Tat_006_F' },
			{ collection = 'mpimportexport_overlays', overlay = 'MP_MP_ImportExport_Tat_007_F' },
            { collection = 'mpimportexport_overlays', overlay = 'MP_MP_ImportExport_Tat_003_M' },
            { collection = 'mpimportexport_overlays', overlay = 'MP_MP_ImportExport_Tat_005_M' },
            { collection = 'mpimportexport_overlays', overlay = 'MP_MP_ImportExport_Tat_006_M' },
            { collection = 'mpimportexport_overlays', overlay = 'MP_MP_ImportExport_Tat_007_M' },
			{ collection = 'mplowrider2_overlays', overlay = 'MP_LR_Tat_003_F' },
			{ collection = 'mplowrider2_overlays', overlay = 'MP_LR_Tat_028_F' },
			{ collection = 'mplowrider2_overlays', overlay = 'MP_LR_Tat_035_F' },
			{ collection = 'mplowrider_overlays', overlay = 'MP_LR_Tat_015_F' },
			{ collection = 'mpluxe2_overlays', overlay = 'MP_LUXE_TAT_010_F' },
			{ collection = 'mpluxe2_overlays', overlay = 'MP_LUXE_TAT_017_F' },
			{ collection = 'mpluxe2_overlays', overlay = 'MP_LUXE_TAT_026_F' },
			{ collection = 'mpluxe2_overlays', overlay = 'MP_LUXE_TAT_030_F' },
			{ collection = 'mpluxe_overlays', overlay = 'MP_LUXE_TAT_004_F' },
			{ collection = 'mpluxe_overlays', overlay = 'MP_LUXE_TAT_013_F' },
			{ collection = 'mpluxe_overlays', overlay = 'MP_LUXE_TAT_019_F' },
			{ collection = 'mpsmuggler_overlays', overlay = 'MP_Smuggler_Tattoo_001_F' },
			{ collection = 'mpsmuggler_overlays', overlay = 'MP_Smuggler_Tattoo_005_F' },
			{ collection = 'mpsmuggler_overlays', overlay = 'MP_Smuggler_Tattoo_023_F' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_003_F' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_009_F' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_010_F' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_016_F' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_036_F' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_038_F' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_049_F' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_004_F' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_018_F' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_025_F' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_028_F' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_Award_F_002' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_Award_F_010' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_F_001' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_F_003' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_F_014' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_F_018' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_F_027' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_F_028' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_F_038' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_F_047' },
		},
		[4] = {
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_002_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_015_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_027_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_036_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_037_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_044_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_056_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_057_F' },
			{ collection = 'mpbusiness_overlays', overlay = 'MP_Buis_F_LLeg_000' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_F_Tat_001' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_F_Tat_002' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_005_F' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_007_F' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_011_F' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_023_F' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_032_F' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_010_F' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_024_F' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_025_F' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_028_F' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_029_F' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Tat_009' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Tat_019' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Tat_040' },
			{ collection = 'mplowrider2_overlays', overlay = 'MP_LR_Tat_029_F' },
			{ collection = 'mplowrider_overlays', overlay = 'MP_LR_Tat_007_F' },
			{ collection = 'mplowrider_overlays', overlay = 'MP_LR_Tat_020_F' },
			{ collection = 'mpluxe2_overlays', overlay = 'MP_LUXE_TAT_011_F' },
			{ collection = 'mpluxe_overlays', overlay = 'MP_LUXE_TAT_000_F' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_007_F' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_013_F' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_021_F' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_028_F' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_031_F' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_013_F' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_027_F' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_Award_F_009' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_F_002' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_F_008' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_F_021' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_F_023' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_F_026' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_F_032' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_F_033' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_F_035' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_F_037' },
		},
		[5] = {
			{ collection = 'mpbeach_overlays', overlay = 'MP_Bea_F_RLeg_000' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_004_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_022_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_028_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_040_F' },
			{ collection = 'mpbiker_overlays', overlay = 'MP_MP_Biker_Tat_048_F' },
			{ collection = 'mpbusiness_overlays', overlay = 'MP_Buis_F_RLeg_000' },
			{ collection = 'mpchristmas2_overlays', overlay = 'MP_Xmas2_F_Tat_014' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_006_F' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_026_F' },
			{ collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Tattoo_030_F' },
			{ collection = 'mpheist3_overlays', overlay = 'mpHeist3_Tat_031_F' },
			{ collection = 'mpheist4_overlays', overlay = 'MP_Heist4_Tat_027_F' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Tat_038' },
			{ collection = 'mphipster_overlays', overlay = 'FM_Hip_F_Tat_042' },
			{ collection = 'mplowrider2_overlays', overlay = 'MP_LR_Tat_030_F' },
			{ collection = 'mplowrider_overlays', overlay = 'MP_LR_Tat_017_F' },
			{ collection = 'mplowrider_overlays', overlay = 'MP_LR_Tat_023_F' },
			{ collection = 'mpluxe2_overlays', overlay = 'MP_LUXE_TAT_023_F' },
			{ collection = 'mpluxe_overlays', overlay = 'MP_LUXE_TAT_001_F' },
			{ collection = 'mpsmuggler_overlays', overlay = 'MP_Smuggler_Tattoo_020_F' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_005_F' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_015_F' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_020_F' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_025_F' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_032_F' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_045_F' },
			{ collection = 'mpstunt_overlays', overlay = 'MP_MP_Stunt_tat_047_F' },
			{ collection = 'mpvinewood_overlays', overlay = 'MP_Vinewood_Tat_020_F' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_Award_F_006' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_F_007' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_F_017' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_F_022' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_F_039' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_F_040' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_F_042' },
			{ collection = 'multiplayer_overlays', overlay = 'FM_Tat_F_043' },
		},
	},
}

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
    return overlays[GetEntityModel(PlayerPedId())] or {}
end

function getOverlayByIndex(index)
    return getOverlays()[index]
end

exports("getOverlays", getOverlays) 
exports("getOverlayByIndex", getOverlayByIndex)

function getTattoos()
    return tattooList[GetEntityModel(PlayerPedId())] or {}
end

function getTattooList()
    local t = getTattoos()
    local tattooParts = {}
    tattooParts.torso = t[0]
    tattooParts.head = t[1]
    tattooParts.leftArm = t[2]
    tattooParts.rightArm = t[3]
    tattooParts.leftLeg = t[4]
    tattooParts.rightLeg = t[5]
    tattooParts.overlay = getOverlays()
    return tattooParts
end

function getTattooIndex(overlay)
    local list = getTattooList()
    for k,v in pairs(list) do
        for i,j in ipairs(v) do 
            if j.overlay == overlay then
                return i, k, j
            end
        end
    end
end





RegisterCommand("tattoos", function() -- abrir menu do tattooshop (admin)
    if func.checkPermission({"manager.permissao"}) then
        startTattoos("admin")
    end
end)


function reloadTattoos(data)
	if not setPlayerTattoos then return end
    if data then
        tattoos, overlay = data.tattoos or {}, data.overlay or 0
    elseif GetResourceState("nation_barbershop") ~= "started" and GetResourceState("nation_creator") ~= "started" then
        return forceReloadTattoos()
    end
    setPlayerTattoos()
end

function forceReloadTattoos()
    local t, o = func.getTattoos()
    if t then
        tattoos, overlay = t, o
    else 
        return
    end
    setPlayerTattoos()
end



CreateThread(function()
    local currentPed = PlayerPedId()
    local oldPed = currentPed
    while true do
        currentPed = PlayerPedId()
        if currentPed ~= oldPed then
            reloadTattoos()
        end
        oldPed = currentPed
        Wait(0)
    end
end)


RegisterNetEvent("reloadtattos") AddEventHandler("reloadtattos", reloadTattoos)
RegisterNetEvent("forcereloadtattos") AddEventHandler("forcereloadtattos", forceReloadTattoos)

exports("setTattoos", reloadTattoos)

exports("getTattoos", function()
    return tattoos, overlay
end)
