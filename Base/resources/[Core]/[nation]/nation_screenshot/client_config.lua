local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
func = Tunnel.getInterface("nation_screenshot")
fclient = {}
Tunnel.bindInterface("nation_screenshot", fclient)


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
-----------------------ROUPAAS PADRÕES PARA TIRAR AS SCREENSHOTS--------------------------
---------------------------------------------------------------------------

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
            ["shoes"] = { 34, 0, 2 },
            ["bracelets"] = { -1,0 },
            ["tops"] = { 15, 0, 2 },
            ["bags"] = { 0,0,0 },
            ["ears"] = { -1,0 },
            ["decals"] = { 0,0,0 },
            ["legs"] = { 61, 0, 2 },
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


resetHeadOverlays = function()
    local ped = PlayerPedId()
    for _, overlayId in pairs(headOverlays) do
        SetPedHeadOverlay(ped, overlayId, 255, 1.0)
    end
end

---------------------------------------------------------------------------
-----------------------FUNÇÃO DE TIRAR AS SCREENSHOTS--------------------------
---------------------------------------------------------------------------


screenShotWait = 500 -- tempo de espera pra cada screenshot

screenshotTexture = false -- tirar fotos das texturas tamém (nyo)

screenshotHair = true -- tirar fotos do cabelo (tiu muito toxico)

takeAllScreenshots = function(_, args)
    if startedScreenshots or not func.checkPermission({"manager.permissao"}) then return end
    startedScreenshots = true
    screenshots = {}
    local ped = PlayerPedId()
    local allClothes = getAllClothes()
    local gender = getGender()
    toggleScreenshotNui(true)
    SetFacialIdleAnimOverride(ped, "pose_normal_1", 0)
    if #args > 0 then
        if #args > 1 then
            local i, j = tonumber(args[1] or 0), tonumber(args[2] or 0)
            if not i then i = args[1] end
            local name = components[i]
            if name and allClothes[name] and not stop and ((name == "hairs" and screenshotHair) or name ~= "hairs") then
                resetCloths()
                createScreenshotCamera(screenshotCams[name])
                local data = getScreenshotArea(name)
                local componentName, componentsIndex = name, j
                takeScreenshot(ped, gender, data, componentName, componentsIndex)
            elseif args[1] == "tattoo" then
                resetCloths()
                takeScreenshotsFromTattoos(ped, gender, tonumber(args[2]), #getTattooList())
            else
                local i = args[1] 
                local overlayId = headOverlays[i]
                local data = getScreenshotArea(i)
                if overlayId and not stop then
                    resetHeadOverlays()
                    resetCloths()
                    takeScreenshotFromHeadOverlay(ped, gender, data, i, tonumber(args[2]))
                end
            end
        else
            local i = tonumber(args[1] or 0)
            if not i then i = args[1] end
            local name = components[i]
            if name and allClothes[name] and not stop and ((name == "hairs" and screenshotHair) or name ~= "hairs") then
                resetCloths()
                createScreenshotCamera(screenshotCams[name])
                local data = getScreenshotArea(name)
                local componentName, componentsArray = name, allClothes[name]
                takeScreenshotsFromComponent(ped, gender, data, componentName, componentsArray)
            elseif args[1] == "tattoo" then
                resetCloths()
                takeScreenshotsFromTattoos(ped, gender, 1, #getTattooList())
            else
                local i = args[1] 
                local overlayId = headOverlays[i]
                if overlayId and not stop then
                    resetHeadOverlays()
                    resetCloths()
                    createScreenshotCamera(screenshotCams[i])
                    local data = getScreenshotArea(i)
                    local maxOverlays = GetPedHeadOverlayNum(overlayId)
                    if maxOverlays == 0 then
                        maxOverlays = 32
                    end
                    if i == "overlay" then
                        maxOverlays = #getOverlays()+1
                    end
                    takeScreenshotsFromHeadOverlay(ped, gender, data, i, maxOverlays)
                end
            end
        end
    else
        for i = 1,11 do
            local name = components[i]
            if name and allClothes[name] and not stop and ((name == "hairs" and screenshotHair) or name ~= "hairs") then
                resetCloths()
                createScreenshotCamera(screenshotCams[name])
                local data = getScreenshotArea(name)
                local componentName, componentsArray = name, allClothes[name]
                takeScreenshotsFromComponent(ped, gender, data, componentName, componentsArray)
            end
        end
        for i = 0,7 do
            local name = components["p"..i]
            if name and allClothes[name] and not stop then
                resetCloths()
                createScreenshotCamera(screenshotCams[name])
                local data = getScreenshotArea(name)
                local componentName, componentsArray = name, allClothes[name]
                takeScreenshotsFromComponent(ped, gender, data, componentName, componentsArray)
            end
        end
    end
    ped = PlayerPedId()
    DestroyCam(screenshotCam)
    RenderScriptCams(false, true, 500, true, true)
    ClearPedTasksImmediately(ped)
    startedScreenshots = false
    stop = false
    toggleScreenshotNui(false)
    ClearFacialIdleAnimOverride(ped)
    TriggerEvent("cinematicCam:stop")
    TriggerEvent("Notify", "sucesso", "COMPLETED!")
end



stopScreenshots = function()
    if startedScreenshots then
        stop = true
    end
end



screenshotCams = {
    masks = { coords = vec3(0.0, 0.8, 0.6), point = vec3(0.0,0.0,0.68) },
    torsos = { coords = vec3(0.0, 1.8, 0.1), point = vec3(0.0,0.0,0.1) },
    legs = { coords = vec3(0.0, 1.8, -0.4), point = vec3(0.0,0.0,-0.4) }, 
    bags = { coords = vec3(0.0, 1.5, 0.25), point = vec3(0.0,0.0,0.25), h = function() SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId()) - 180) end },
    shoes = { coords = vec3(0.3, 1.1, -0.75), point = vec3(0.0,0.0,-0.75) }, 
    accessories = { coords = vec3(0.0, 1.7, 0.1), point = vec3(0.0,0.0,0.1) },
    undershirts = { coords = vec3(0.0, 1.7, 0.15), point = vec3(0.0,0.0,0.15) },
    bodyArmors = { coords = vec3(0.0, 1.7, 0.15), point = vec3(0.0,0.0,0.15) },
    decals = { coords = vec3(0.0, 1.7, 0.15), point = vec3(0.0,0.0,0.15) },
    tops = { coords = vec3(0.0, 1.7, 0.15), point = vec3(0.0,0.0,0.15) },
    hats = { coords = vec3(0.3, 0.8, 0.9), point = vec3(0.0,0.0,0.68) },
    hairs = { coords = vec3(0.3, 0.8, 0.9), point = vec3(0.0,0.0,0.68) },
    glasses = { coords = vec3(0.2, 0.45, 0.72), point = vec3(0.0,0.0,0.7) },
    ears = { coords = vec3(0.3, 0.25, 0.72), point = vec3(0.09,0.0,0.68) },
    watches = { coords = vec3(-0.8, 0.25, 0.0), point = vec3(-0.45,0.0,-0.03) },
    bracelets = { coords = vec3(0.8, 0.25, 0.0), point = vec3(0.45,0.0,-0.03) },


    makeup = { coords = vec3(0.0, 0.33, 0.67), point = vec3(0.0,0.0,0.65) },
    blush = { coords = vec3(0.0, 0.5, 0.7), point = vec3(0.0,0.0,0.68) },
    blemishes = { coords = vec3(0.0, 0.28, 0.64), point = vec3(0.0,0.0,0.62) },
    complexion = { coords = vec3(0.0, 0.28, 0.64), point = vec3(0.0,0.0,0.62) },
    lipstick = { coords = vec3(0.0, 0.28, 0.64), point = vec3(0.0,0.0,0.62) },
    eyebrows =  { coords = vec3(0.0, 0.27, 0.72), point = vec3(0.0,0.0,0.7) },
    facialHair = { coords = vec3(0.0, 0.5, 0.7), point = vec3(0.0,0.0,0.68) },
    chestHair = { coords = vec3(0.0, 1.7, 0.15), point = vec3(0.0,0.0,0.15) },
    eyes =  { coords = vec3(0.0, 0.27, 0.72), point = vec3(0.0,0.0,0.7) },
    overlay = { coords = vec3(0.3, 0.8, 0.9), point = vec3(0.0,0.0,0.68) },

    tattoo = function()
        TriggerEvent("cinematicCam:start")
    end
}


firstHeading = GetEntityHeading(PlayerPedId())

function createScreenshotCamera(cam)
    if type(cam) == "function" then
        freezeAnim("mp_sleep", "bind_pose_180", 1, true)
        return cam()
    end
    local ped = PlayerPedId()
    if not DoesCamExist(screenshotCam) then
        firstHeading = GetEntityHeading(ped)
    end
    SetEntityHeading(ped, firstHeading)
    freezeAnim("mp_sleep", "bind_pose_180", 1, true)
    local coord = GetOffsetFromEntityInWorldCoords(ped,cam.coords)
    local tempCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coord, 0,0,0, 50.0)
    local pointCoords = GetOffsetFromEntityInWorldCoords(ped,cam.point)
    PointCamAtCoord(tempCam, pointCoords)
    SetCamActive(tempCam, true)
    RenderScriptCams(true, false, 1, true, true)
    if cam.h then cam.h() end
    DestroyCam(screenshotCam)
    screenshotCam = tempCam
end

---------------------------------------------------------------------------
-----------------------COMANDO DE TIRAR AS SCREENSHOTS--------------------------
---------------------------------------------------------------------------

RegisterCommand('screenshot', takeAllScreenshots)

RegisterCommand('stops', stopScreenshots) -- PARAR DE TIRAR AS SCREENSHOTS

---------------------------------------------------------------------------
-----------------------CÂMERAS--------------------------
---------------------------------------------------------------------------


overlays = {
    [GetHashKey("mp_m_freemode_01")] = {
        { collection = 'mpbeach_overlays', overlay = 'FM_Hair_Fuzz' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_001' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_002' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_003' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_004' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_005' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_006' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_007' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_008' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_009' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_013' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_002' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_011' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_012' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_014' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_015' },
        { collection = 'multiplayer_overlays', overlay = 'NGBea_M_Hair_000' },
        { collection = 'multiplayer_overlays', overlay = 'NGBea_M_Hair_001' },
        { collection = 'multiplayer_overlays', overlay = 'NGBus_M_Hair_000' },
        { collection = 'multiplayer_overlays', overlay = 'NGBus_M_Hair_001' },
        { collection = 'multiplayer_overlays', overlay = 'NGHip_M_Hair_000' },
        { collection = 'multiplayer_overlays', overlay = 'NGHip_M_Hair_001' },
        { collection = 'multiplayer_overlays', overlay = 'NGInd_M_Hair_000' },
        { collection = 'mplowrider_overlays', overlay = 'LR_M_Hair_000' },
        { collection = 'mplowrider_overlays', overlay = 'LR_M_Hair_001' },
        { collection = 'mplowrider_overlays', overlay = 'LR_M_Hair_002' },
        { collection = 'mplowrider_overlays', overlay = 'LR_M_Hair_003' },
        { collection = 'mplowrider2_overlays', overlay = 'LR_M_Hair_004' },
        { collection = 'mplowrider2_overlays', overlay = 'LR_M_Hair_005' },
        { collection = 'mplowrider2_overlays', overlay = 'LR_M_Hair_006' },
        { collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_000_M' },
        { collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_001_M' },
        { collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_002_M' },
        { collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_003_M' },
        { collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_004_M' },
        { collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_005_M' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_001' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_002' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_003' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_004' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_005' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_006' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_007' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_008' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_009' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_013' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_002' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_011' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_012' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_014' },
        { collection = 'multiplayer_overlays', overlay = 'NG_M_Hair_015' },
        { collection = 'multiplayer_overlays', overlay = 'NGBea_M_Hair_000' },
        { collection = 'multiplayer_overlays', overlay = 'NGBea_M_Hair_001' },
        { collection = 'multiplayer_overlays', overlay = 'NGBus_M_Hair_000' },
        { collection = 'multiplayer_overlays', overlay = 'NGBus_M_Hair_001' },
        { collection = 'multiplayer_overlays', overlay = 'NGHip_M_Hair_000' },
        { collection = 'multiplayer_overlays', overlay = 'NGHip_M_Hair_001' },
        { collection = 'multiplayer_overlays', overlay = 'NGInd_M_Hair_000' },
        { collection = 'mplowrider_overlays', overlay = 'LR_M_Hair_000' },
        { collection = 'mplowrider_overlays', overlay = 'LR_M_Hair_001' },
        { collection = 'mplowrider_overlays', overlay = 'LR_M_Hair_002' },
        { collection = 'mplowrider_overlays', overlay = 'LR_M_Hair_003' },
        { collection = 'mplowrider2_overlays', overlay = 'LR_M_Hair_004' },
        { collection = 'mplowrider2_overlays', overlay = 'LR_M_Hair_005' },
        { collection = 'mplowrider2_overlays', overlay = 'LR_M_Hair_006' },
        { collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_000_M' },
        { collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_001_M' },
        { collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_002_M' },
        { collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_003_M' },
        { collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_004_M' },
        { collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_005_M' },
        { collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Hair_M_000_M'},
        { collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Hair_M_001_M'}
    },

    [GetHashKey("mp_f_freemode_01")] = {
        { collection = 'mpbeach_overlays', overlay = 'FM_Hair_Fuzz' },
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
        { collection = 'multiplayer_overlays', overlay = 'NG_F_Hair_007' },
        { collection = 'multiplayer_overlays', overlay = 'NGBus_F_Hair_000' },
        { collection = 'multiplayer_overlays', overlay = 'NGBus_F_Hair_001' },
        { collection = 'multiplayer_overlays', overlay = 'NGBea_F_Hair_001' },
        { collection = 'multiplayer_overlays', overlay = 'NGHip_F_Hair_000' },
        { collection = 'multiplayer_overlays', overlay = 'NGInd_F_Hair_000' },
        { collection = 'mplowrider_overlays', overlay = 'LR_F_Hair_000' },
        { collection = 'mplowrider_overlays', overlay = 'LR_F_Hair_001' },
        { collection = 'mplowrider_overlays', overlay = 'LR_F_Hair_002' },
        { collection = 'mplowrider2_overlays', overlay = 'LR_F_Hair_003' },
        { collection = 'mplowrider2_overlays', overlay = 'LR_F_Hair_003' },
        { collection = 'mplowrider2_overlays', overlay = 'LR_F_Hair_004' },
        { collection = 'mplowrider2_overlays', overlay = 'LR_F_Hair_006' },
        { collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_000_F' },
        { collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_001_F' },
        { collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_002_F' },
        { collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_003_F' },
        { collection = 'multiplayer_overlays', overlay = 'NG_F_Hair_003' },
        { collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_006_F' },
        { collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_004_F' },
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
        { collection = 'multiplayer_overlays', overlay = 'NG_F_Hair_007' },
        { collection = 'multiplayer_overlays', overlay = 'NGBus_F_Hair_000' },
        { collection = 'multiplayer_overlays', overlay = 'NGBus_F_Hair_001' },
        { collection = 'multiplayer_overlays', overlay = 'NGBea_F_Hair_001' },
        { collection = 'multiplayer_overlays', overlay = 'NGHip_F_Hair_000' },
        { collection = 'multiplayer_overlays', overlay = 'NGInd_F_Hair_000' },
        { collection = 'mplowrider_overlays', overlay = 'LR_F_Hair_000' },
        { collection = 'mplowrider_overlays', overlay = 'LR_F_Hair_001' },
        { collection = 'mplowrider_overlays', overlay = 'LR_F_Hair_002' },
        { collection = 'mplowrider2_overlays', overlay = 'LR_F_Hair_003' },
        { collection = 'mplowrider2_overlays', overlay = 'LR_F_Hair_003' },
        { collection = 'mplowrider2_overlays', overlay = 'LR_F_Hair_004' },
        { collection = 'mplowrider2_overlays', overlay = 'LR_F_Hair_006' },
        { collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_000_F' },
        { collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_001_F' },
        { collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_002_F' },
        { collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_003_F' },
        { collection = 'multiplayer_overlays', overlay = 'NG_F_Hair_003' },
        { collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_006_F' },
        { collection = 'mpbiker_overlays', overlay = 'MP_Biker_Hair_004_F' },
        { collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Hair_F_000_F' },
        { collection = 'mpgunrunning_overlays', overlay = 'MP_Gunrunning_Hair_F_001_F' }
    }
}


function getOverlays()
    local model = GetEntityModel(PlayerPedId())
    return overlays[model] or {}
end

function getOverlayByIndex(index)
    return getOverlays()[index]
end



tattoos =  {
    [GetHashKey("mp_m_freemode_01")] = {
        [1] = {
            {overlay = 'MP_Airraces_Tattoo_000_M', name = 'Turbulence', collection = 'mpairraces_overlays'},                
            {overlay = 'MP_Airraces_Tattoo_001_M', name = 'Pilot Skull', collection = 'mpairraces_overlays'},
            {overlay = 'MP_Airraces_Tattoo_002_M', name = 'Winged Bombshell', collection = 'mpairraces_overlays'},
            {overlay = 'MP_Airraces_Tattoo_004_M', name = 'Balloon Pioneer', collection = 'mpairraces_overlays'},
            {overlay = 'MP_Airraces_Tattoo_005_M', name = 'Parachute Belle', collection = 'mpairraces_overlays'},
            {overlay = 'MP_Airraces_Tattoo_006_M', name = 'Bombs Away', collection = 'mpairraces_overlays'},
            {overlay = 'MP_Airraces_Tattoo_007_M', name = 'Eagle Eyes', collection = 'mpairraces_overlays'},
            {overlay = 'MP_Bea_M_Back_000', name = 'Ship Arms', collection = 'mpbeach_overlays'},
            {overlay = 'MP_Bea_M_Chest_000', name = 'Tribal Hammerhead', collection = 'mpbeach_overlays'},
            {overlay = 'MP_Bea_M_Chest_001', name = 'Tribal Shark', collection = 'mpbeach_overlays'},
            {overlay = 'MP_Bea_M_Stom_000', name = 'Swordfish', collection = 'mpbeach_overlays'},
            {overlay = 'MP_Bea_M_Stom_001', name = 'Wheel', collection = 'mpbeach_overlays'},
            {overlay = 'MP_MP_Biker_Tat_000_M', name = 'Demon Rider', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_001_M', name = 'Both Barrels', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_003_M', name = 'Web Rider', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_005_M', name = 'Made In America', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_006_M', name = 'Chopper Freedom', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_008_M', name = 'Freedom Wheels', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_010_M', name = 'Skull Of Taurus', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_011_M', name = 'R.I.P. My Brothers', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_013_M', name = 'Demon Crossbones', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_017_M', name = 'Clawed Beast', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_018_M', name = 'Skeletal Chopper', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_019_M', name = 'Gruesome Talons', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_021_M', name = 'Flaming Reaper', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_023_M', name = 'Western MC', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_026_M', name = 'American Dream', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_029_M', name = 'Bone Wrench', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_030_M', name = 'Brothers For Life', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_031_M', name = 'Gear Head', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_032_M', name = 'Western Eagle', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_034_M', name = 'Brotherhood of Bikes', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_039_M', name = 'Gas Guzzler', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_041_M', name = 'No Regrets', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_043_M', name = 'Ride Forever', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_050_M', name = 'Unforgiven', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_052_M', name = 'Biker Mount', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_058_M', name = 'Reaper Vulture', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_059_M', name = 'Faggio', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_060_M', name = 'We Are The Mods!', collection = 'mpbiker_overlays'},
            {overlay = 'MP_Buis_M_Stomach_000', name = 'Refined Hustler', collection = 'mpbusiness_overlays'},
            {overlay = 'MP_Buis_M_Chest_000', name = 'Rich', collection = 'mpbusiness_overlays'},
            {overlay = 'MP_Buis_M_Chest_001', name = '$$$', collection = 'mpbusiness_overlays'},
            {overlay = 'MP_Buis_M_Back_000', name = 'Makin Paper', collection = 'mpbusiness_overlays'},
            
            {overlay = 'MP_Christmas2017_Tattoo_000_M', name = 'Thor & Goblin', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Christmas2017_Tattoo_002_M', name = 'Kabuto', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Christmas2017_Tattoo_003_M', name = 'Native Warrior', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Christmas2017_Tattoo_005_M', name = 'Ghost Dragon', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Christmas2017_Tattoo_008_M', name = 'Spartan Warrior', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Christmas2017_Tattoo_009_M', name = 'Norse Rune', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Christmas2017_Tattoo_010_M', name = 'Spartan Shield', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Christmas2017_Tattoo_011_M', name = 'Weathered Skull', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Christmas2017_Tattoo_015_M', name = 'Samurai Combat', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Christmas2017_Tattoo_016_M', name = 'Odin & Raven', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Christmas2017_Tattoo_019_M', name = 'Strike Force', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Christmas2017_Tattoo_020_M', name = 'Medusa Gaze', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Christmas2017_Tattoo_021_M', name = 'Spartan & Lion', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Christmas2017_Tattoo_022_M', name = 'Spartan & Horse', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Christmas2017_Tattoo_024_M', name = 'Dragon Slayer', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Christmas2017_Tattoo_026_M', name = 'Spartan Skull', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Christmas2017_Tattoo_027_M', name = 'Molon Labe', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Christmas2018_Tat_000_M', name = '????', collection = 'mpchristmas2018_overlays'},
            
            {overlay = 'MP_Xmas2_M_Tat_005', name = 'Carp Outline', collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Xmas2_M_Tat_006', name = 'Carp Shaded', collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Xmas2_M_Tat_009', name = 'Time To Die', collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Xmas2_M_Tat_011', name = 'Roaring Tiger', collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Xmas2_M_Tat_013', name = 'Lizard', collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Xmas2_M_Tat_015', name = 'Japanese Warrior', collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Xmas2_M_Tat_016', name = 'Loose Lips Outline', collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Xmas2_M_Tat_017', name = 'Loose Lips Color', collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Xmas2_M_Tat_018', name = 'Royal Dagger Outline', collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Xmas2_M_Tat_019', name = 'Royal Dagger Color', collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Xmas2_M_Tat_028', name = 'Executioner', collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_000_M', name = 'Bullet Proof', collection = 'mpgunrunning_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_001_M', name = 'Crossed Weapons', collection = 'mpgunrunning_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_009_M', name = 'Butterfly Knife', collection = 'mpgunrunning_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_010_M', name = 'Cash Money', collection = 'mpgunrunning_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_012_M', name = 'Dollar Daggers', collection = 'mpgunrunning_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_013_M', name = 'Wolf Insignia', collection = 'mpgunrunning_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_014_M', name = 'Backstabber', collection = 'mpgunrunning_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_017_M', name = 'Dog Tags', collection = 'mpgunrunning_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_018_M', name = 'Dual Wield Skull', collection = 'mpgunrunning_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_019_M', name = 'Pistol Wings', collection = 'mpgunrunning_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_020_M', name = 'Crowned Weapons', collection = 'mpgunrunning_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_022_M', name = 'Explosive Heart', collection = 'mpgunrunning_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_028_M', name = 'Micro SMG Chain', collection = 'mpgunrunning_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_029_M', name = 'Win Some Lose Some', collection = 'mpgunrunning_overlays'},
            {overlay = 'FM_Hip_M_Tat_000', name = 'Crossed Arrows', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_M_Tat_002', name = 'Chemistry', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_M_Tat_006', name = 'Feather Birds', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_M_Tat_011', name = 'Infinity', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_M_Tat_012', name = 'Antlers', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_M_Tat_013', name = 'Boombox', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_M_Tat_024', name = 'Pyramid', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_M_Tat_025', name = 'Watch Your Step', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_M_Tat_029', name = 'Sad', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_M_Tat_030', name = 'Shark Fin', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_M_Tat_031', name = 'Skateboard', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_M_Tat_032', name = 'Paper Plane', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_M_Tat_033', name = 'Stag', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_M_Tat_035', name = 'Sewn Heart', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_M_Tat_041', name = 'Tooth', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_M_Tat_046', name = 'Triangles', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_M_Tat_047', name = 'Cassette', collection = 'mphipster_overlays'},
            {overlay = 'MP_MP_ImportExport_Tat_000_M', name = 'Block Back', collection = 'mpimportexport_overlays'},
            {overlay = 'MP_MP_ImportExport_Tat_001_M', name = 'Power Plant', collection = 'mpimportexport_overlays'},
            {overlay = 'MP_MP_ImportExport_Tat_002_M', name = 'Tuned to Death', collection = 'mpimportexport_overlays'},
            {overlay = 'MP_MP_ImportExport_Tat_009_M', name = 'Serpents of Destruction', collection = 'mpimportexport_overlays'},
            {overlay = 'MP_MP_ImportExport_Tat_010_M', name = 'Take the Wheel', collection = 'mpimportexport_overlays'},
            {overlay = 'MP_MP_ImportExport_Tat_011_M', name = 'Talk Shit Get Hit', collection = 'mpimportexport_overlays'},
            {overlay = 'MP_LR_Tat_000_M', name = 'SA Assault', collection = 'mplowrider2_overlays'},
            {overlay = 'MP_LR_Tat_008_M', name = 'Love the Game', collection = 'mplowrider2_overlays'},
            {overlay = 'MP_LR_Tat_011_M', name = 'Lady Liberty', collection = 'mplowrider2_overlays'},
            {overlay = 'MP_LR_Tat_012_M', name = 'Royal Kiss', collection = 'mplowrider2_overlays'},
            {overlay = 'MP_LR_Tat_016_M', name = 'Two Face', collection = 'mplowrider2_overlays'},
            {overlay = 'MP_LR_Tat_019_M', name = 'Death Behind', collection = 'mplowrider2_overlays'},
            {overlay = 'MP_LR_Tat_031_M', name = 'Dead Pretty', collection = 'mplowrider2_overlays'},
            {overlay = 'MP_LR_Tat_032_M', name = 'Reign Over', collection = 'mplowrider2_overlays'},
            {overlay = 'MP_LR_Tat_001_M', name = 'King Fight', collection = 'mplowrider_overlays'},
            {overlay = 'MP_LR_Tat_002_M', name = 'Holy Mary', collection = 'mplowrider_overlays'},
            {overlay = 'MP_LR_Tat_004_M', name = 'Gun Mic', collection = 'mplowrider_overlays'},
            {overlay = 'MP_LR_Tat_009_M', name = 'Amazon', collection = 'mplowrider_overlays'},
            {overlay = 'MP_LR_Tat_010_M', name = 'Bad Angel', collection = 'mplowrider_overlays'},
            {overlay = 'MP_LR_Tat_013_M', name = 'Love Gamble', collection = 'mplowrider_overlays'},
            {overlay = 'MP_LR_Tat_014_M', name = 'Love is Blind', collection = 'mplowrider_overlays'},
            {overlay = 'MP_LR_Tat_021_M', name = 'Sad Angel', collection = 'mplowrider_overlays'},
            {overlay = 'MP_LR_Tat_026_M', name = 'Royal Takeover', collection = 'mplowrider_overlays'},
            {overlay = 'MP_LUXE_TAT_002_M', name = 'The Howler', collection = 'mpluxe2_overlays'},
            {overlay = 'MP_LUXE_TAT_012_M', name = 'Geometric Galaxy', collection = 'mpluxe2_overlays'},
            {overlay = 'MP_LUXE_TAT_022_M', name = 'Cloaked Angel', collection = 'mpluxe2_overlays'},
            {overlay = 'MP_LUXE_TAT_025_M', name = 'Reaper Sway', collection = 'mpluxe2_overlays'},
            {overlay = 'MP_LUXE_TAT_027_M', name = 'Cobra Dawn', collection = 'mpluxe2_overlays'},
            {overlay = 'MP_LUXE_TAT_029_M', name = 'Geometric Design', collection = 'mpluxe2_overlays'},
            {overlay = 'MP_LUXE_TAT_003_M', name = 'Abstract Skull', collection = 'mpluxe_overlays'},
            {overlay = 'MP_LUXE_TAT_006_M', name = 'Adorned Wolf', collection = 'mpluxe_overlays'},
            {overlay = 'MP_LUXE_TAT_007_M', name = 'Eye of the Griffin', collection = 'mpluxe_overlays'},
            {overlay = 'MP_LUXE_TAT_008_M', name = 'Flying Eye', collection = 'mpluxe_overlays'},
            {overlay = 'MP_LUXE_TAT_014_M', name = 'Ancient Queen', collection = 'mpluxe_overlays'},
            {overlay = 'MP_LUXE_TAT_015_M', name = 'Smoking Sisters', collection = 'mpluxe_overlays'},
            {overlay = 'MP_LUXE_TAT_024_M', name = 'Feather Mural', collection = 'mpluxe_overlays'},
            {overlay = 'MP_Smuggler_Tattoo_000_M', name = 'Bless The Dead', collection = 'mpsmuggler_overlays'},
            {overlay = 'MP_Smuggler_Tattoo_002_M', name = 'Dead Lies', collection = 'mpsmuggler_overlays'},
            {overlay = 'MP_Smuggler_Tattoo_003_M', name = 'Give Nothing Back', collection = 'mpsmuggler_overlays'},
            {overlay = 'MP_Smuggler_Tattoo_006_M', name = 'Never Surrender', collection = 'mpsmuggler_overlays'},
            {overlay = 'MP_Smuggler_Tattoo_007_M', name = 'No Honor', collection = 'mpsmuggler_overlays'},
            {overlay = 'MP_Smuggler_Tattoo_009_M', name = 'Tall Ship Conflict', collection = 'mpsmuggler_overlays'},
            {overlay = 'MP_Smuggler_Tattoo_010_M', name = 'See You In Hell', collection = 'mpsmuggler_overlays'},
            {overlay = 'MP_Smuggler_Tattoo_013_M', name = 'Torn Wings', collection = 'mpsmuggler_overlays'},
            {overlay = 'MP_Smuggler_Tattoo_015_M', name = 'Jolly Roger', collection = 'mpsmuggler_overlays'},
            {overlay = 'MP_Smuggler_Tattoo_016_M', name = 'Skull Compass', collection = 'mpsmuggler_overlays'},
            {overlay = 'MP_Smuggler_Tattoo_017_M', name = 'Framed Tall Ship', collection = 'mpsmuggler_overlays'},
            {overlay = 'MP_Smuggler_Tattoo_018_M', name = 'Finders Keepers', collection = 'mpsmuggler_overlays'},
            {overlay = 'MP_Smuggler_Tattoo_019_M', name = 'Lost At Sea', collection = 'mpsmuggler_overlays'},
            {overlay = 'MP_Smuggler_Tattoo_021_M', name = 'Dead Tales', collection = 'mpsmuggler_overlays'},
            {overlay = 'MP_Smuggler_Tattoo_022_M', name = 'X Marks The Spot', collection = 'mpsmuggler_overlays'},
            {overlay = 'MP_Smuggler_Tattoo_024_M', name = 'Pirate Captain', collection = 'mpsmuggler_overlays'},
            {overlay = 'MP_Smuggler_Tattoo_025_M', name = 'Claimed By The Beast', collection = 'mpsmuggler_overlays'},
            {overlay = 'MP_MP_Stunt_tat_011_M', name = 'Wheels of Death', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_012_M', name = 'Punk Biker', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_014_M', name = 'Bat Cat of Spades', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_018_M', name = 'Vintage Bully', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_019_M', name = 'Engine Heart', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_024_M', name = 'Road Kill', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_026_M', name = 'Winged Wheel', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_027_M', name = 'Punk Road Hog', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_029_M', name = 'Majestic Finish', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_030_M', name = "Man's Ruin", collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_033_M', name = 'Sugar Skull Trucker', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_034_M', name = 'Feather Road Kill', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_037_M', name = 'Big Grills', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_040_M', name = 'Monkey Chopper', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_041_M', name = 'Brapp', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_044_M', name = 'Ram Skull', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_046_M', name = 'Full Throttle', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_048_M', name = 'Racing Doll', collection = 'mpstunt_overlays'},
            {overlay = 'FM_Tat_Award_M_003', name = 'Blackjack', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_Award_M_004', name = 'Hustler', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_Award_M_005', name = 'Angel', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_Award_M_008', name = 'Los Santos Customs', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_Award_M_011', name = 'Blank Scroll', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_Award_M_012', name = 'Embellished Scroll', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_Award_M_013', name = 'Seven Deadly Sins', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_Award_M_014', name = 'Trust No One', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_Award_M_016', name = 'Clown', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_Award_M_017', name = 'Clown and Gun', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_Award_M_018', name = 'Clown Dual Wield', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_Award_M_019', name = 'Clown Dual Wield Dollars', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_M_004', name = 'Faith', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_M_009', name = 'kull on the Cross', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_M_010', name = 'LS Flames', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_M_011', name = 'LS Script', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_M_012', name = 'Los Santos Bills', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_M_013', name = 'Eagle and Serpent', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_M_016', name = 'Evil Clown', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_M_019', name = 'The Wages of Sin', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_M_020', name = 'Dragon', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_M_024', name = 'Flaming Cross', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_M_025', name = 'LS Bold', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_M_029', name = 'Trinity Knot', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_M_030', name = 'Lucky Celtic Dogs', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_M_034', name = 'Flaming Shamrock', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_M_036', name = 'Way of the Gun', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_M_044', name = 'Stone Cross', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_M_045', name = 'Skulls and Rose', collection = 'multiplayer_overlays'},
        },
        [2] = {
            {overlay = 'MP_Bea_M_Head_000', name = 'Pirate Skull', collection = 'mpbeach_overlays'},                
            {overlay = 'MP_Bea_M_Neck_000', name = 'Little Fish', collection = 'mpbeach_overlays'},
            {overlay = 'MP_Bea_M_Neck_001', name = 'Surfs Up', collection = 'mpbeach_overlays'},
            {overlay = 'MP_MP_Biker_Tat_009_M', name = 'Morbid Arachnid', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_038_M', name = 'FTW', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_051_M', name = 'Western Stylized', collection = 'mpbiker_overlays'},
            {overlay = 'MP_Buis_M_Neck_000', name = 'Cash is King', collection = 'mpbusiness_overlays'},
            {overlay = 'MP_Buis_M_Neck_001', name = 'Bold Dollar Sign', collection = 'mpbusiness_overlays'},
            {overlay = 'MP_Buis_M_Neck_002', name = 'Script Dollar Sign', collection = 'mpbusiness_overlays'},
            {overlay = 'MP_Buis_M_Neck_003', name = '$100', collection = 'mpbusiness_overlays'},
            {overlay = 'MP_Xmas2_M_Tat_007', name = 'Los Muertos', collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Xmas2_M_Tat_024', name = 'Snake Head Outline', collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Xmas2_M_Tat_025', name = 'Snake Head Color', collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Xmas2_M_Tat_029', name = 'Beautiful Death', collection = 'mpchristmas2_overlays'},
            {overlay = 'FM_Hip_M_Tat_005', name = 'Beautiful Eye', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_M_Tat_021', name = 'Geo Fox', collection = 'mphipster_overlays'},
            {overlay = 'MP_Smuggler_Tattoo_011_M', name = 'Sinner', collection = 'mpsmuggler_overlays'},
            {overlay = 'MP_Smuggler_Tattoo_012_M', name = 'Thief', collection = 'mpsmuggler_overlays'},
            {overlay = 'MP_MP_Stunt_Tat_000_M', name = 'Stunt Skull', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_004_M', name = 'Scorpion', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_006_M', name = 'Toxic Spider', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_017_M', name = 'Bat Wheel', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_042_M', name = 'Flaming Quad', collection = 'mpstunt_overlays'},
            {overlay = 'FM_Tat_Award_M_000', name = 'Skull', collection = 'multiplayer_overlays'},
        },
        [3] = {
            {overlay = 'MP_Airraces_Tattoo_003_M', name = 'Toxic Trails', collection = 'mpairraces_overlays'},                
            {overlay = 'MP_Bea_M_LArm_000', name = 'Tiki Tower', collection = 'mpbeach_overlays'},
            {overlay = 'MP_Bea_M_LArm_001', name = 'Mermaid L.S.', collection = 'mpbeach_overlays'},
            {overlay = 'MP_MP_Biker_Tat_012_M', name = 'Urban Stunter', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_016_M', name = 'Macabre Tree', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_020_M', name = 'Cranial Rose', collection = 'mpbiker_overlays'},                    
            {overlay = 'MP_MP_Biker_Tat_024_M', name = 'Live to Ride', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_025_M', name = 'Good Luck', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_035_M', name = 'Chain Fist', collection = 'mpbiker_overlays'},                    
            {overlay = 'MP_MP_Biker_Tat_045_M', name = 'Ride Hard Die Fast', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_053_M', name = 'Muffler Helmet', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_055_M', name = 'Poison Scorpion', collection = 'mpbiker_overlays'},
            {overlay = 'MP_Buis_M_LeftArm_000', name = '$100 Bill', collection = 'mpbusiness_overlays'},
            {overlay = 'MP_Buis_M_LeftArm_001', name = 'All-Seeing Eye', collection = 'mpbusiness_overlays'},
            
            {overlay = 'MP_Christmas2017_Tattoo_001_M', name = 'Viking Warrior', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Christmas2017_Tattoo_004_M', name = 'Tiger & Mask', collection = 'mpchristmas2017_overlays'},                   
            {overlay = 'MP_Christmas2017_Tattoo_007_M', name = 'Spartan Combat', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Christmas2017_Tattoo_013_M', name = 'Katana', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Christmas2017_Tattoo_025_M', name = 'Winged Serpent', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Christmas2017_Tattoo_029_M', name = 'Cerberus', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Xmas2_M_Tat_000', name = 'Skull Rider', collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Xmas2_M_Tat_010', name = 'Electric Snake', collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Xmas2_M_Tat_012', name = '8 Ball Skull', collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Xmas2_M_Tat_020', name = 'Times Up Outline', collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Xmas2_M_Tat_021', name = 'Times Up Color', collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_004_M', name = 'Sidearm', collection = 'mpgunrunning_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_008_M', name = 'Bandolier', collection = 'mpgunrunning_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_015_M', name = 'Spiked Skull', collection = 'mpgunrunning_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_016_M', name = 'Blood Money', collection = 'mpgunrunning_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_025_M', name = 'Praying Skull', collection = 'mpgunrunning_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_027_M', name = 'Serpent Revolver', collection = 'mpgunrunning_overlays'},
            {overlay = 'FM_Hip_M_Tat_003', name = 'Diamond Sparkle', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_M_Tat_007', name = 'Bricks', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_M_Tat_015', name = 'Mustache', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_M_Tat_016', name = 'Lightning Bolt', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_M_Tat_026', name = 'Pizza', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_M_Tat_027', name = 'Padlock', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_M_Tat_028', name = 'Thorny Rose', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_M_Tat_034', name = 'Stop', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_M_Tat_037', name = 'Sunrise', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_M_Tat_039', name = 'Sleeve', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_M_Tat_043', name = 'Triangle White', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_M_Tat_048', name = 'Peace', collection = 'mphipster_overlays'},
            {overlay = 'MP_MP_ImportExport_Tat_004_M', name = 'Piston Sleeve', collection = 'mpimportexport_overlays'},
            {overlay = 'MP_MP_ImportExport_Tat_008_M', name = 'Scarlett', collection = 'mpimportexport_overlays'},
            {overlay = 'MP_LR_Tat_006_M', name = 'Love Hustle', collection = 'mplowrider2_overlays'},
            {overlay = 'MP_LR_Tat_018_M', name = 'Skeleton Party', collection = 'mplowrider2_overlays'},
            {overlay = 'MP_LR_Tat_022_M', name = 'My Crazy Life', collection = 'mplowrider2_overlays'},
            {overlay = 'MP_LR_Tat_005_M', name = 'No Evil', collection = 'mplowrider_overlays'},
            {overlay = 'MP_LR_Tat_027_M', name = 'Los Santos Life', collection = 'mplowrider_overlays'},
            {overlay = 'MP_LR_Tat_033_M', name = 'City Sorrow', collection = 'mplowrider_overlays'},
            {overlay = 'MP_LUXE_TAT_005_M', name = 'Fatal Dagger', collection = 'mpluxe2_overlays'},
            {overlay = 'MP_LUXE_TAT_016_M', name = 'Egyptian Mural', collection = 'mpluxe2_overlays'},
            {overlay = 'MP_LUXE_TAT_018_M', name = 'Divine Goddess', collection = 'mpluxe2_overlays'},
            {overlay = 'MP_LUXE_TAT_028_M', name = 'Python Skull', collection = 'mpluxe2_overlays'},
            {overlay = 'MP_LUXE_TAT_031_M', name = 'Geometric Design', collection = 'mpluxe2_overlays'},
            {overlay = 'MP_LUXE_TAT_009_M', name = 'Floral Symmetry', collection = 'mpluxe_overlays'},
            {overlay = 'MP_LUXE_TAT_020_M', name = 'Archangel & Mary', collection = 'mpluxe_overlays'},
            {overlay = 'MP_LUXE_TAT_021_M', name = 'Gabriel', collection = 'mpluxe_overlays'},
            {overlay = 'MP_Smuggler_Tattoo_004_M', name = 'Honor', collection = 'mpsmuggler_overlays'},
            {overlay = 'MP_Smuggler_Tattoo_008_M', name = 'Horrors Of The Deep', collection = 'mpsmuggler_overlays'},
            {overlay = 'MP_Smuggler_Tattoo_014_M', name = "Mermaid's Curse", collection = 'mpsmuggler_overlays'},
            {overlay = 'MP_MP_Stunt_tat_001_M', name = '8 Eyed Skull', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_002_M', name = 'Big Cat', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_008_M', name = 'Moonlight Ride', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_022_M', name = 'Piston Head', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_023_M', name = 'Tanked', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_035_M', name = "Stuntman's End", collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_039_M', name = 'Kaboom', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_043_M', name = 'Engine Arm', collection = 'mpstunt_overlays'},
            {overlay = 'FM_Tat_Award_M_001', name = 'Burning Heart', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_Award_M_007', name = 'Racing Blonde', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_Award_M_015', name = 'Racing Brunette', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_M_005', name = 'Serpents', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_M_006', name = 'Oriental Mural', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_M_015', name = 'Zodiac Skull', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_M_031', name = 'Lady M', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_M_041', name = 'Dope Skull', collection = 'multiplayer_overlays'},
        },
        [4] = {
            {overlay = 'MP_Bea_M_RArm_000', name = 'Tribal Sun', collection = 'mpbeach_overlays'},                
            {overlay = 'MP_Bea_M_RArm_001', name = 'Vespucci Beauty', collection = 'mpbeach_overlays'},
            {overlay = 'MP_MP_Biker_Tat_007_M', name = 'Swooping Eagle', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_014_M', name = 'Lady Mortality', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_033_M', name = 'Eagle Emblem', collection = 'mpbiker_overlays'},                    
            {overlay = 'MP_MP_Biker_Tat_042_M', name = 'Grim Rider', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_046_M', name = 'Skull Chain', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_047_M', name = 'Snake Bike', collection = 'mpbiker_overlays'},                    
            {overlay = 'MP_MP_Biker_Tat_049_M', name = 'These Colors Dont Run', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_054_M', name = 'Mum', collection = 'mpbiker_overlays'},
            {overlay = 'MP_Buis_M_RightArm_000', name = 'Dollar Skull', collection = 'mpbusiness_overlays'},
            {overlay = 'MP_Buis_M_RightArm_001', name = 'Green', collection = 'mpbusiness_overlays'},                    
            
            {overlay = 'MP_Christmas2017_Tattoo_006_M', name = 'Medusa', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Christmas2017_Tattoo_012_M', name = 'Tiger Headdress', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Christmas2017_Tattoo_014_M', name = 'Celtic Band', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Christmas2017_Tattoo_017_M', name = 'Feather Sleeve', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Christmas2017_Tattoo_018_M', name = 'Muscle Tear', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Christmas2017_Tattoo_023_M', name = 'Samurai Tallship', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Christmas2017_Tattoo_028_M', name = 'Spartan Mural', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Xmas2_M_Tat_003', name = 'Snake Outline', collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Xmas2_M_Tat_004', name = 'Snake Shaded', collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Xmas2_M_Tat_008', name = 'Death Before Dishonor', collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Xmas2_M_Tat_022', name = "You're Next Outline", collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Xmas2_M_Tat_023', name = "You're Next Color", collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Xmas2_M_Tat_026', name = 'Fuck Luck Outline', collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Xmas2_M_Tat_027', name = 'Fuck Luck Color', collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_002_M', name = 'Single', collection = 'mpgunrunning_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_021_M', name = 'Have a Nice Day', collection = 'mpgunrunning_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_024_M', name = 'Combat Reaper', collection = 'mpgunrunning_overlays'},
            {overlay = 'FM_Hip_M_Tat_001', name = 'Single Arrow', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_M_Tat_004', name = 'Bone', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_M_Tat_008', name = 'Cube', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_M_Tat_010', name = 'Horseshoe', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_M_Tat_014', name = 'Spray Can', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_M_Tat_017', name = 'Eye Triangle', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_M_Tat_018', name = 'Origami', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_M_Tat_020', name = 'Geo Pattern', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_M_Tat_022', name = 'Pencil', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_M_Tat_023', name = 'Smiley', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_M_Tat_036', name = 'Shapes', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_M_Tat_044', name = 'Triangle Black', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_M_Tat_045', name = 'Mesh Band', collection = 'mphipster_overlays'},
            {overlay = 'MP_LR_Tat_003_M', name = 'Lady Vamp', collection = 'mplowrider2_overlays'},
            {overlay = 'MP_LR_Tat_028_M', name = 'Loving Los Muertos', collection = 'mplowrider2_overlays'},
            {overlay = 'MP_LR_Tat_035_M', name = 'Black Tears', collection = 'mplowrider2_overlays'},
            {overlay = 'MP_LR_Tat_015_M', name = 'Seductress', collection = 'mplowrider_overlays'},
            {overlay = 'MP_LUXE_TAT_010_M', name = 'Intrometric', collection = 'mpluxe2_overlays'},
            {overlay = 'MP_LUXE_TAT_017_M', name = 'Heavenly Deity', collection = 'mpluxe2_overlays'},
            {overlay = 'MP_LUXE_TAT_026_M', name = 'Floral Print', collection = 'mpluxe2_overlays'},
            {overlay = 'MP_LUXE_TAT_030_M', name = 'Geometric Design', collection = 'mpluxe2_overlays'},
            {overlay = 'MP_LUXE_TAT_004_M', name = 'Floral Raven', collection = 'mpluxe_overlays'},
            {overlay = 'MP_LUXE_TAT_013_M', name = 'Mermaid Harpist', collection = 'mpluxe_overlays'},
            {overlay = 'MP_LUXE_TAT_019_M', name = 'Geisha Bloom', collection = 'mpluxe_overlays'},
            {overlay = 'MP_Smuggler_Tattoo_001_M', name = 'Crackshot', collection = 'mpsmuggler_overlays'},
            {overlay = 'MP_Smuggler_Tattoo_005_M', name = 'Mutiny', collection = 'mpsmuggler_overlays'},
            {overlay = 'MP_Smuggler_Tattoo_023_M', name = 'Stylized Kraken', collection = 'mpsmuggler_overlays'},
            {overlay = 'MP_MP_Stunt_tat_003_M', name = 'Poison Wrench', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_009_M', name = 'Arachnid of Death', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_010_M', name = 'Grave Vulture', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_016_M', name = 'Coffin Racer', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_036_M', name = 'Biker Stallion', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_038_M', name = 'One Down Five Up', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_049_M', name = 'Seductive Mechanic', collection = 'mpstunt_overlays'},
            {overlay = 'FM_Tat_Award_M_002', name = 'Grim Reaper Smoking Gun', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_Award_M_010', name = 'Ride or Die', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_M_000', name = 'Brotherhood', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_M_001', name = 'Dragons', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_M_003', name = 'Dragons and Skull', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_M_014', name = 'Flower Mural', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_M_018', name = 'Serpent Skull', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_M_027', name = 'Virgin Mary', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_M_028', name = 'Mermaid', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_M_038', name = 'Dagger', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_M_047', name = 'Lion', collection = 'multiplayer_overlays'},
        },
        [5] = {
            {overlay = 'MP_Bea_M_Lleg_000', name = 'Tribal Star', collection = 'mpbeach_overlays'},  
            {overlay = 'MP_MP_Biker_Tat_002_M', name = 'Rose Tribute', collection = 'mpbiker_overlays'},  
            {overlay = 'MP_MP_Biker_Tat_015_M', name = 'Ride or Die', collection = 'mpbiker_overlays'},  
            {overlay = 'MP_MP_Biker_Tat_027_M', name = 'Bad Luck', collection = 'mpbiker_overlays'},  
            {overlay = 'MP_MP_Biker_Tat_036_M', name = 'Engulfed Skull', collection = 'mpbiker_overlays'},  
            {overlay = 'MP_MP_Biker_Tat_037_M', name = 'Scorched Soul', collection = 'mpbiker_overlays'},  
            {overlay = 'MP_MP_Biker_Tat_044_M', name = 'Ride Free', collection = 'mpbiker_overlays'},  
            {overlay = 'MP_MP_Biker_Tat_056_M', name = 'Bone Cruiser', collection = 'mpbiker_overlays'},  
            {overlay = 'MP_MP_Biker_Tat_057_M', name = 'Laughing Skull', collection = 'mpbiker_overlays'}, 
            {overlay = 'MP_Xmas2_M_Tat_001', name = 'Spider Outline', collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Xmas2_M_Tat_002', name = 'Spider Color', collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_005_M', name = 'Patriot Skull', collection = 'mpgunrunning_overlays'},                   
            {overlay = 'MP_Gunrunning_Tattoo_007_M', name = 'Stylized Tiger', collection = 'mpgunrunning_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_011_M', name = 'Death Skull', collection = 'mpgunrunning_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_023_M', name = 'Rose Revolver', collection = 'mpgunrunning_overlays'},
            {overlay = 'FM_Hip_M_Tat_009', name = 'Squares', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_M_Tat_019', name = 'Charm', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_M_Tat_040', name = 'Black Anchor', collection = 'mphipster_overlays'},
            {overlay = 'MP_LR_Tat_029_M', name = 'Death Us Do Part', collection = 'mplowrider2_overlays'},
            {overlay = 'MP_LR_Tat_007_M', name = 'LS Serpent', collection = 'mplowrider_overlays'},
            {overlay = 'MP_LR_Tat_020_M', name = 'Presidents', collection = 'mplowrider_overlays'},
            {overlay = 'MP_LUXE_TAT_011_M', name = 'Cross of Roses', collection = 'mpluxe2_overlays'},
            {overlay = 'MP_LUXE_TAT_000_M', name = 'Serpent of Death', collection = 'mpluxe_overlays'},
            {overlay = 'MP_MP_Stunt_tat_007_M', name = 'Dagger Devil', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_013_M', name = 'Dirt Track Hero', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_021_M', name = 'Golden Cobra', collection = 'mpstunt_overlays'},
            {overlay = 'FM_Tat_Award_M_009', name = 'Dragon and Dagger', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_M_002', name = 'Melting Skull', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_M_008', name = 'Dragon Mural', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_M_021', name = 'Serpent Skull', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_M_023', name = 'Hottie', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_M_026', name = 'Smoking Dagger', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_M_032', name = 'Faith', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_M_033', name = 'Chinese Dragon', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_M_035', name = 'Dragon', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_M_037', name = 'Grim Reaper', collection = 'multiplayer_overlays'}, 
        },
        [6] = {
            {overlay = 'MP_Bea_M_Rleg_000', name = 'Tribal Tiki Tower', collection = 'mpbeach_overlays'},    
            {overlay = 'MP_MP_Biker_Tat_004_M', name = 'Dragons Fury', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_022_M', name = 'Western Insignia', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_028_M', name = 'Dusk Rider', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_040_M', name = 'American Made', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_048_M', name = 'STFU', collection = 'mpbiker_overlays'},
            {overlay = 'MP_Xmas2_M_Tat_014', name = 'Floral Dagger', collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_006_M', name = 'Combat Skull', collection = 'mpgunrunning_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_026_M', name = 'Restless Skull', collection = 'mpgunrunning_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_030_M', name = 'Pistol Ace', collection = 'mpgunrunning_overlays'},
            {overlay = 'FM_Hip_M_Tat_038', name = 'Grub', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_M_Tat_042', name = 'Sparkplug', collection = 'mphipster_overlays'},
            {overlay = 'MP_LR_Tat_030_M', name = 'San Andreas Prayer', collection = 'mplowrider2_overlays'},
            {overlay = 'MP_LR_Tat_017_M', name = 'Ink Me', collection = 'mplowrider_overlays'},
            {overlay = 'MP_LR_Tat_023_M', name = 'Dance of Hearts', collection = 'mplowrider_overlays'},
            {overlay = 'MP_LUXE_TAT_023_M', name = 'Starmetric', collection = 'mpluxe2_overlays'},
            {overlay = 'MP_LUXE_TAT_001_M', name = 'Elaborate Los Muertos', collection = 'mpluxe_overlays'},
            {overlay = 'MP_Smuggler_Tattoo_020_M', name = 'Homeward Bound', collection = 'mpsmuggler_overlays'},
            {overlay = 'MP_MP_Stunt_tat_005_M', name = 'Demon Spark Plug', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_015_M', name = 'Praying Gloves', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_020_M', name = 'Piston Angel', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_025_M', name = 'Speed Freak', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_032_M', name = 'Wheelie Mouse', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_045_M', name = 'Severed Hand', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_047_M', name = 'Brake Knife', collection = 'mpstunt_overlays'},
            {overlay = 'FM_Tat_M_043', name = 'Indian Ram', collection = 'multiplayer_overlays'},
        }
    },
    [GetHashKey("mp_f_freemode_01")] = {
        [1] = {
            {overlay = 'MP_Airraces_Tattoo_000_F', name = 'Turbulence', collection = 'mpairraces_overlays'},                
            {overlay = 'MP_Airraces_Tattoo_001_F', name = 'Pilot Skull', collection = 'mpairraces_overlays'},
            {overlay = 'MP_Airraces_Tattoo_002_F', name = 'Winged Bombshell', collection = 'mpairraces_overlays'},
            {overlay = 'MP_Airraces_Tattoo_004_F', name = 'Balloon Pioneer', collection = 'mpairraces_overlays'},
            {overlay = 'MP_Airraces_Tattoo_005_F', name = 'Parachute Belle', collection = 'mpairraces_overlays'},
            {overlay = 'MP_Airraces_Tattoo_006_F', name = 'Bombs Away', collection = 'mpairraces_overlays'},
            {overlay = 'MP_Airraces_Tattoo_007_F', name = 'Eagle Eyes', collection = 'mpairraces_overlays'},
            {overlay = 'MP_Bea_F_Back_000', name = 'Rock Solid', collection = 'mpbeach_overlays'},
            {overlay = 'MP_Bea_F_Back_001', name = 'Hibiscus Flower Duo', collection = 'mpbeach_overlays'},
            {overlay = 'MP_Bea_F_Back_002', name = 'Shrimp', collection = 'mpbeach_overlays'},
            {overlay = 'MP_Bea_F_Chest_000', name = 'Anchor', collection = 'mpbeach_overlays'},
            {overlay = 'MP_Bea_F_Chest_001', name = 'Anchor 2', collection = 'mpbeach_overlays'},
            {overlay = 'MP_Bea_F_Chest_002', name = 'Los Santos Wreath', collection = 'mpbeach_overlays'},
            {overlay = 'MP_Bea_F_RSide_000', name = 'Love Dagger', collection = 'mpbeach_overlays'},
            {overlay = 'MP_Bea_F_Should_000', name = 'Sea Horses', collection = 'mpbeach_overlays'},
            {overlay = 'MP_Bea_F_Should_001', name = 'Catfish', collection = 'mpbeach_overlays'},
            {overlay = 'MP_Bea_F_Stom_000', name = 'Swallow', collection = 'mpbeach_overlays'},
            {overlay = 'MP_Bea_F_Stom_001', name = 'Hibiscus Flower', collection = 'mpbeach_overlays'},
            {overlay = 'MP_Bea_F_Stom_002', name = 'Dolphin', collection = 'mpbeach_overlays'},
            {overlay = 'MP_MP_Biker_Tat_000_F', name = 'Demon Rider', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_001_F', name = 'Both Barrels', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_003_F', name = 'Web Rider', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_005_F', name = 'Made In America', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_006_F', name = 'Chopper Freedom', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_008_F', name = 'Freedom Wheels', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_010_F', name = 'Skull Of Taurus', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_011_F', name = 'R.I.P. My Brothers', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_013_F', name = 'Demon Crossbones', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_017_F', name = 'Clawed Beast', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_018_F', name = 'Skeletal Chopper', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_019_F', name = 'Gruesome Talons', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_021_F', name = 'Flaming Reaper', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_023_F', name = 'Western MC', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_026_F', name = 'American Dream', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_029_F', name = 'Bone Wrench', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_030_F', name = 'Brothers For Life', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_031_F', name = 'Gear Head', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_032_F', name = 'Western Eagle', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_034_F', name = 'Brotherhood of Bikes', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_039_F', name = 'Gas Guzzler', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_041_F', name = 'No Regrets', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_043_F', name = 'Ride Forever', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_050_F', name = 'Unforgiven', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_052_F', name = 'Biker Mount', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_058_F', name = 'Reaper Vulture', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_059_F', name = 'Faggio', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_060_F', name = 'We Are The Mods!', collection = 'mpbiker_overlays'},
            {overlay = 'MP_Buis_F_Chest_000', name = 'High Roller', collection = 'mpbusiness_overlays'},
            {overlay = 'MP_Buis_F_Chest_001', name = 'Makin Money', collection = 'mpbusiness_overlays'},
            {overlay = 'MP_Buis_F_Chest_002', name = 'Love Money', collection = 'mpbusiness_overlays'},
            {overlay = 'MP_Buis_F_Stom_000', name = 'Diamond Back', collection = 'mpbusiness_overlays'},
            {overlay = 'MP_Buis_F_Stom_001', name = 'Santo Capra Logo', collection = 'mpbusiness_overlays'},
            {overlay = 'MP_Buis_F_Stom_002', name = 'Money Bag', collection = 'mpbusiness_overlays'},
            {overlay = 'MP_Buis_F_Back_000', name = 'Respect', collection = 'mpbusiness_overlays'},
            {overlay = 'MP_Buis_F_Back_001', name = 'Gold Digger', collection = 'mpbusiness_overlays'},
            {overlay = 'MP_Christmas2017_Tattoo_000_F', name = 'Thor & Goblin', collection = 'mpchristmas2017_overlays'},                    
            {overlay = 'MP_Christmas2017_Tattoo_002_F', name = 'Kabuto', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Christmas2017_Tattoo_003_F', name = 'Native Warrior', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Christmas2017_Tattoo_005_F', name = 'Ghost Dragon', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Christmas2017_Tattoo_008_F', name = 'Spartan Warrior', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Christmas2017_Tattoo_009_F', name = 'Norse Rune', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Christmas2017_Tattoo_010_F', name = 'Spartan Shield', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Christmas2017_Tattoo_011_F', name = 'Weathered Skull', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Christmas2017_Tattoo_015_F', name = 'Samurai Combat', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Christmas2017_Tattoo_016_F', name = 'Odin & Raven', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Christmas2017_Tattoo_019_F', name = 'Strike Force', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Christmas2017_Tattoo_020_F', name = 'Medusa Gaze', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Christmas2017_Tattoo_021_F', name = 'Spartan & Lion', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Christmas2017_Tattoo_022_F', name = 'Spartan & Horse', collection = 'mpchristmas2017_overlays'}, 
            {overlay = 'MP_Christmas2017_Tattoo_024_F', name = 'Dragon Slayer', collection = 'mpchristmas2017_overlays'},                   
            {overlay = 'MP_Christmas2017_Tattoo_026_F', name = 'Spartan Skull', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Christmas2017_Tattoo_027_F', name = 'Molon Labe', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Christmas2018_Tat_000_F', name = '????', collection = 'mpchristmas2018_overlays'},
            {overlay = 'MP_Xmas2_F_Tat_005', name = 'Carp Outline', collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Xmas2_F_Tat_006', name = 'Carp Shaded', collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Xmas2_F_Tat_009', name = 'Time To Die', collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Xmas2_F_Tat_011', name = 'Roaring Tiger', collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Xmas2_F_Tat_013', name = 'Lizard', collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Xmas2_F_Tat_015', name = 'Japanese Warrior', collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Xmas2_F_Tat_016', name = 'Loose Lips Outline', collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Xmas2_F_Tat_017', name = 'Loose Lips Color', collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Xmas2_F_Tat_018', name = 'Royal Dagger Outline', collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Xmas2_F_Tat_019', name = 'Royal Dagger Color', collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Xmas2_F_Tat_028', name = 'Executioner', collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_000_F', name = 'Bullet Proof', collection = 'mpgunrunning_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_001_F', name = 'Crossed Weapons', collection = 'mpgunrunning_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_009_F', name = 'Butterfly Knife', collection = 'mpgunrunning_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_010_F', name = 'Cash Money', collection = 'mpgunrunning_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_012_F', name = 'Dollar Daggers', collection = 'mpgunrunning_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_013_F', name = 'Wolf Insignia', collection = 'mpgunrunning_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_014_F', name = 'Backstabber', collection = 'mpgunrunning_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_017_F', name = 'Dog Tags', collection = 'mpgunrunning_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_018_F', name = 'Dual Wield Skull', collection = 'mpgunrunning_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_019_F', name = 'Pistol Wings', collection = 'mpgunrunning_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_020_F', name = 'Crowned Weapons', collection = 'mpgunrunning_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_022_F', name = 'Explosive Heart', collection = 'mpgunrunning_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_028_F', name = 'Micro SMG Chain', collection = 'mpgunrunning_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_029_F', name = 'Win Some Lose Some', collection = 'mpgunrunning_overlays'},
            {overlay = 'FM_Hip_F_Tat_000', name = 'Crossed Arrows', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_F_Tat_002', name = 'Chemistry', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_F_Tat_006', name = 'Feather Birds', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_F_Tat_011', name = 'Infinity', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_F_Tat_012', name = 'Antlers', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_F_Tat_013', name = 'Boombox', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_F_Tat_024', name = 'Pyramid', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_F_Tat_025', name = 'Watch Your Step', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_F_Tat_029', name = 'Sad', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_F_Tat_030', name = 'Shark Fin', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_F_Tat_031', name = 'Skateboard', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_F_Tat_032', name = 'Paper Plane', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_F_Tat_033', name = 'Stag', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_F_Tat_035', name = 'Sewn Heart', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_F_Tat_041', name = 'Tooth', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_F_Tat_046', name = 'Triangles', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_F_Tat_047', name = 'Cassette', collection = 'mphipster_overlays'},
            {overlay = 'MP_MP_ImportExport_Tat_000_F', name = 'Block Back', collection = 'mpimportexport_overlays'},
            {overlay = 'MP_MP_ImportExport_Tat_001_F', name = 'Power Plant', collection = 'mpimportexport_overlays'},
            {overlay = 'MP_MP_ImportExport_Tat_002_F', name = 'Tuned to Death', collection = 'mpimportexport_overlays'},
            {overlay = 'MP_MP_ImportExport_Tat_009_F', name = 'Serpents of Destruction', collection = 'mpimportexport_overlays'},
            {overlay = 'MP_MP_ImportExport_Tat_010_F', name = 'Take the Wheel', collection = 'mpimportexport_overlays'},
            {overlay = 'MP_MP_ImportExport_Tat_011_F', name = 'Talk Shit Get Hit', collection = 'mpimportexport_overlays'},
            {overlay = 'MP_LR_Tat_000_F', name = 'SA Assault', collection = 'mplowrider2_overlays'},
            {overlay = 'MP_LR_Tat_008_F', name = 'Love the Game', collection = 'mplowrider2_overlays'},
            {overlay = 'MP_LR_Tat_011_F', name = 'Lady Liberty', collection = 'mplowrider2_overlays'},
            {overlay = 'MP_LR_Tat_012_F', name = 'Royal Kiss', collection = 'mplowrider2_overlays'},
            {overlay = 'MP_LR_Tat_016_F', name = 'Two Face', collection = 'mplowrider2_overlays'},
            {overlay = 'MP_LR_Tat_019_F', name = 'Death Behind', collection = 'mplowrider2_overlays'},
            {overlay = 'MP_LR_Tat_031_F', name = 'Dead Pretty', collection = 'mplowrider2_overlays'},
            {overlay = 'MP_LR_Tat_032_F', name = 'Reign Over', collection = 'mplowrider2_overlays'},
            {overlay = 'MP_LR_Tat_001_F', name = 'King Fight', collection = 'mplowrider_overlays'},
            {overlay = 'MP_LR_Tat_002_F', name = 'Holy Mary', collection = 'mplowrider_overlays'},
            {overlay = 'MP_LR_Tat_004_F', name = 'Gun Mic', collection = 'mplowrider_overlays'},
            {overlay = 'MP_LR_Tat_009_F', name = 'Amazon', collection = 'mplowrider_overlays'},
            {overlay = 'MP_LR_Tat_010_F', name = 'Bad Angel', collection = 'mplowrider_overlays'},
            {overlay = 'MP_LR_Tat_013_F', name = 'Love Gamble', collection = 'mplowrider_overlays'},
            {overlay = 'MP_LR_Tat_014_F', name = 'Love is Blind', collection = 'mplowrider_overlays'},
            {overlay = 'MP_LR_Tat_021_F', name = 'Sad Angel', collection = 'mplowrider_overlays'},
            {overlay = 'MP_LR_Tat_026_F', name = 'Royal Takeover', collection = 'mplowrider_overlays'},
            {overlay = 'MP_LUXE_TAT_002_F', name = 'The Howler', collection = 'mpluxe2_overlays'},
            {overlay = 'MP_LUXE_TAT_012_F', name = 'Geometric Galaxy', collection = 'mpluxe2_overlays'},
            {overlay = 'MP_LUXE_TAT_022_F', name = 'Cloaked Angel', collection = 'mpluxe2_overlays'},
            {overlay = 'MP_LUXE_TAT_025_F', name = 'Reaper Sway', collection = 'mpluxe2_overlays'},
            {overlay = 'MP_LUXE_TAT_027_F', name = 'Cobra Dawn', collection = 'mpluxe2_overlays'},
            {overlay = 'MP_LUXE_TAT_029_F', name = 'Geometric Design', collection = 'mpluxe2_overlays'},
            {overlay = 'MP_LUXE_TAT_003_F', name = 'Abstract Skull', collection = 'mpluxe_overlays'},
            {overlay = 'MP_LUXE_TAT_006_F', name = 'Adorned Wolf', collection = 'mpluxe_overlays'},
            {overlay = 'MP_LUXE_TAT_007_F', name = 'Eye of the Griffin', collection = 'mpluxe_overlays'},
            {overlay = 'MP_LUXE_TAT_008_F', name = 'Flying Eye', collection = 'mpluxe_overlays'},
            {overlay = 'MP_LUXE_TAT_014_F', name = 'Ancient Queen', collection = 'mpluxe_overlays'},
            {overlay = 'MP_LUXE_TAT_015_F', name = 'Smoking Sisters', collection = 'mpluxe_overlays'},
            {overlay = 'MP_LUXE_TAT_024_F', name = 'Feather Mural', collection = 'mpluxe_overlays'},
            {overlay = 'MP_Smuggler_Tattoo_000_F', name = 'Bless The Dead', collection = 'mpsmuggler_overlays'},
            {overlay = 'MP_Smuggler_Tattoo_002_F', name = 'Dead Lies', collection = 'mpsmuggler_overlays'},
            {overlay = 'MP_Smuggler_Tattoo_003_F', name = 'Give Nothing Back', collection = 'mpsmuggler_overlays'},
            {overlay = 'MP_Smuggler_Tattoo_006_F', name = 'Never Surrender', collection = 'mpsmuggler_overlays'},
            {overlay = 'MP_Smuggler_Tattoo_007_F', name = 'No Honor', collection = 'mpsmuggler_overlays'},
            {overlay = 'MP_Smuggler_Tattoo_009_F', name = 'Tall Ship Conflict', collection = 'mpsmuggler_overlays'},
            {overlay = 'MP_Smuggler_Tattoo_010_F', name = 'See You In Hell', collection = 'mpsmuggler_overlays'},
            {overlay = 'MP_Smuggler_Tattoo_013_F', name = 'Torn Wings', collection = 'mpsmuggler_overlays'},
            {overlay = 'MP_Smuggler_Tattoo_015_F', name = 'Jolly Roger', collection = 'mpsmuggler_overlays'},
            {overlay = 'MP_Smuggler_Tattoo_016_F', name = 'Skull Compass', collection = 'mpsmuggler_overlays'},
            {overlay = 'MP_Smuggler_Tattoo_017_F', name = 'Framed Tall Ship', collection = 'mpsmuggler_overlays'},
            {overlay = 'MP_Smuggler_Tattoo_018_F', name = 'Finders Keepers', collection = 'mpsmuggler_overlays'},
            {overlay = 'MP_Smuggler_Tattoo_019_F', name = 'Lost At Sea', collection = 'mpsmuggler_overlays'},
            {overlay = 'MP_Smuggler_Tattoo_021_F', name = 'Dead Tales', collection = 'mpsmuggler_overlays'},
            {overlay = 'MP_Smuggler_Tattoo_022_F', name = 'X Marks The Spot', collection = 'mpsmuggler_overlays'},
            {overlay = 'MP_Smuggler_Tattoo_024_F', name = 'Pirate Captain', collection = 'mpsmuggler_overlays'},
            {overlay = 'MP_Smuggler_Tattoo_025_F', name = 'Claimed By The Beast', collection = 'mpsmuggler_overlays'},
            {overlay = 'MP_MP_Stunt_tat_011_F', name = 'Wheels of Death', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_012_F', name = 'Punk Biker', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_014_F', name = 'Bat Cat of Spades', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_018_F', name = 'Vintage Bully', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_019_F', name = 'Engine Heart', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_024_F', name = 'Road Kill', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_026_F', name = 'Winged Wheel', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_027_F', name = 'Punk Road Hog', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_029_F', name = 'Majestic Finish', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_030_F', name = "Man's Ruin", collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_033_F', name = 'Sugar Skull Trucker', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_034_F', name = 'Feather Road Kill', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_037_F', name = 'Big Grills', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_040_F', name = 'Monkey Chopper', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_041_F', name = 'Brapp', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_044_F', name = 'Ram Skull', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_046_F', name = 'Full Throttle', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_048_F', name = 'Racing Doll', collection = 'mpstunt_overlays'},
            {overlay = 'FM_Tat_Award_F_003', name = 'Blackjack', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_Award_F_004', name = 'Hustler', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_Award_F_005', name = 'Angel', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_Award_F_008', name = 'Los Santos Customs', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_Award_F_011', name = 'Blank Scroll', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_Award_F_012', name = 'Embellished Scroll', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_Award_F_013', name = 'Seven Deadly Sins', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_Award_F_014', name = 'Trust No One', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_Award_F_016', name = 'Clown', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_Award_F_017', name = 'Clown and Gun', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_Award_F_018', name = 'Clown Dual Wield', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_Award_F_019', name = 'Clown Dual Wield Dollars', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_F_004', name = 'Faith', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_F_009', name = 'kull on the Cross', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_F_010', name = 'LS Flames', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_F_011', name = 'LS Script', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_F_012', name = 'Los Santos Bills', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_F_013', name = 'Eagle and Serpent', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_F_016', name = 'Evil Clown', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_F_019', name = 'The Wages of Sin', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_F_020', name = 'Dragon', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_F_024', name = 'Flaming Cross', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_F_025', name = 'LS Bold', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_F_029', name = 'Trinity Knot', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_F_030', name = 'Lucky Celtic Dogs', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_F_034', name = 'Flaming Shamrock', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_F_036', name = 'Way of the Gun', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_F_044', name = 'Stone Cross', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_F_045', name = 'Skulls and Rose', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Hip_F_Tat_047', name = 'Cassette', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Hip_F_Tat_047', name = 'Cassette', collection = 'multiplayer_overlays'},
        },
        [2] = {
            {overlay = 'MP_Bea_F_Neck_000', name = 'Tribal Butterfly', collection = 'mpbeach_overlays'},    
            {overlay = 'MP_MP_Biker_Tat_009_F', name = 'Morbid Arachnid', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_038_F', name = 'FTW', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_051_F', name = 'Western Stylized', collection = 'mpbiker_overlays'},
            {overlay = 'MP_Buis_F_Neck_000', name = 'Val-de-Grace Logo', collection = 'mpbusiness_overlays'},
            {overlay = 'MP_Buis_F_Neck_001', name = 'Money Rose', collection = 'mpbusiness_overlays'},
            {overlay = 'MP_Xmas2_F_Tat_007', name = 'Los Muertos', collection = 'mpbusiness_overlays'},
            {overlay = 'MP_Xmas2_F_Tat_024', name = 'Snake Head Outline', collection = 'mpbusiness_overlays'},
            {overlay = 'MP_Xmas2_F_Tat_025', name = 'Snake Head Color', collection = 'mpbusiness_overlays'},
            {overlay = 'MP_Xmas2_F_Tat_029', name = 'Beautiful Death', collection = 'mpbusiness_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_003_F', name = 'Lock & Load', collection = 'mpgunrunning_overlays'},
            {overlay = 'FM_Hip_F_Tat_005', name = 'Beautiful Eye', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_F_Tat_021', name = 'Geo Fox', collection = 'mphipster_overlays'},
            {overlay = 'MP_Smuggler_Tattoo_011_F', name = 'Sinner', collection = 'mpsmuggler_overlays'},
            {overlay = 'MP_Smuggler_Tattoo_012_F', name = 'Thief', collection = 'mpsmuggler_overlays'},
            {overlay = 'MP_MP_Stunt_Tat_000_F', name = 'Stunt Skull', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_004_F', name = 'Scorpion', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_006_F', name = 'Toxic Spider', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_017_F', name = 'Bat Wheel', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_042_F', name = 'Flaming Quad', collection = 'mpstunt_overlays'},
            {overlay = 'FM_Tat_Award_F_000', name = 'Skull', collection = 'multiplayer_overlays'},
        },
        [3] = {
            {overlay = 'MP_Airraces_Tattoo_003_F', name = 'Toxic Trails', collection = 'mpairraces_overlays'},                
            {overlay = 'MP_Bea_F_LArm_000', name = 'Tribal Flower', collection = 'mpbeach_overlays'},
            {overlay = 'MP_Bea_F_LArm_001', name = 'Parrot', collection = 'mpbeach_overlays'},
            {overlay = 'MP_MP_Biker_Tat_012_F', name = 'Urban Stunter', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_016_F', name = 'Macabre Tree', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_020_F', name = 'Cranial Rose', collection = 'mpbiker_overlays'},                    
            {overlay = 'MP_MP_Biker_Tat_024_F', name = 'Live to Ride', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_025_F', name = 'Good Luck', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_035_F', name = 'Chain Fist', collection = 'mpbiker_overlays'},                    
            {overlay = 'MP_MP_Biker_Tat_045_F', name = 'Ride Hard Die Fast', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_053_F', name = 'Muffler Helmet', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_055_F', name = 'Poison Scorpion', collection = 'mpbiker_overlays'},
            {overlay = 'MP_Buis_F_LArm_000', name = 'Greed is Good', collection = 'mpbusiness_overlays'},
            {overlay = 'MP_Christmas2017_Tattoo_001_F', name = 'Viking Warrior', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Christmas2017_Tattoo_004_F', name = 'Tiger & Mask', collection = 'mpchristmas2017_overlays'},                   
            {overlay = 'MP_Christmas2017_Tattoo_007_F', name = 'Spartan Combat', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Christmas2017_Tattoo_013_F', name = 'Katana', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Christmas2017_Tattoo_025_F', name = 'Winged Serpent', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Christmas2017_Tattoo_029_F', name = 'Cerberus', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Xmas2_F_Tat_000', name = 'Skull Rider', collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Xmas2_F_Tat_010', name = 'Electric Snake', collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Xmas2_F_Tat_012', name = '8 Ball Skull', collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Xmas2_F_Tat_020', name = 'Times Up Outline', collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Xmas2_F_Tat_021', name = 'Times Up Color', collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_004_F', name = 'Sidearm', collection = 'mpgunrunning_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_008_F', name = 'Bandolier', collection = 'mpgunrunning_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_015_F', name = 'Spiked Skull', collection = 'mpgunrunning_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_016_F', name = 'Blood Money', collection = 'mpgunrunning_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_025_F', name = 'Praying Skull', collection = 'mpgunrunning_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_027_F', name = 'Serpent Revolver', collection = 'mpgunrunning_overlays'},
            {overlay = 'FM_Hip_F_Tat_003', name = 'Diamond Sparkle', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_F_Tat_007', name = 'Bricks', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_F_Tat_015', name = 'Mustache', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_F_Tat_016', name = 'Lightning Bolt', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_F_Tat_026', name = 'Pizza', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_F_Tat_027', name = 'Padlock', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_F_Tat_028', name = 'Thorny Rose', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_F_Tat_034', name = 'Stop', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_F_Tat_037', name = 'Sunrise', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_F_Tat_039', name = 'Sleeve', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_F_Tat_043', name = 'Triangle White', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_F_Tat_048', name = 'Peace', collection = 'mphipster_overlays'},
            {overlay = 'MP_MP_ImportExport_Tat_004_F', name = 'Piston Sleeve', collection = 'mpimportexport_overlays'},
            {overlay = 'MP_MP_ImportExport_Tat_008_F', name = 'Scarlett', collection = 'mpimportexport_overlays'},
            {overlay = 'MP_LR_Tat_006_F', name = 'Love Hustle', collection = 'mplowrider2_overlays'},
            {overlay = 'MP_LR_Tat_018_F', name = 'Skeleton Party', collection = 'mplowrider2_overlays'},
            {overlay = 'MP_LR_Tat_022_F', name = 'My Crazy Life', collection = 'mplowrider2_overlays'},
            {overlay = 'MP_LR_Tat_005_F', name = 'No Evil', collection = 'mplowrider_overlays'},
            {overlay = 'MP_LR_Tat_027_F', name = 'Los Santos Life', collection = 'mplowrider_overlays'},
            {overlay = 'MP_LR_Tat_033_F', name = 'City Sorrow', collection = 'mplowrider_overlays'},
            {overlay = 'MP_LUXE_TAT_005_F', name = 'Fatal Dagger', collection = 'mpluxe2_overlays'},
            {overlay = 'MP_LUXE_TAT_016_F', name = 'Egyptian Mural', collection = 'mpluxe2_overlays'},
            {overlay = 'MP_LUXE_TAT_018_F', name = 'Divine Goddess', collection = 'mpluxe2_overlays'},
            {overlay = 'MP_LUXE_TAT_028_F', name = 'Python Skull', collection = 'mpluxe2_overlays'},
            {overlay = 'MP_LUXE_TAT_031_F', name = 'Geometric Design', collection = 'mpluxe2_overlays'},
            {overlay = 'MP_LUXE_TAT_009_F', name = 'Floral Symmetry', collection = 'mpluxe_overlays'},
            {overlay = 'MP_LUXE_TAT_020_F', name = 'Archangel & Mary', collection = 'mpluxe_overlays'},
            {overlay = 'MP_LUXE_TAT_021_F', name = 'Gabriel', collection = 'mpluxe_overlays'},
            {overlay = 'MP_Smuggler_Tattoo_004_F', name = 'Honor', collection = 'mpsmuggler_overlays'},
            {overlay = 'MP_Smuggler_Tattoo_008_F', name = 'Horrors Of The Deep', collection = 'mpsmuggler_overlays'},
            {overlay = 'MP_Smuggler_Tattoo_014_F', name = "Mermaid's Curse", collection = 'mpsmuggler_overlays'},
            {overlay = 'MP_MP_Stunt_tat_001_F', name = '8 Eyed Skull', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_002_F', name = 'Big Cat', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_008_F', name = 'Moonlight Ride', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_022_F', name = 'Piston Head', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_023_F', name = 'Tanked', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_035_F', name = "Stuntman's End", collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_039_F', name = 'Kaboom', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_043_F', name = 'Engine Arm', collection = 'mpstunt_overlays'},
            {overlay = 'FM_Tat_Award_F_001', name = 'Burning Heart', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_Award_F_007', name = 'Racing Blonde', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_Award_F_015', name = 'Racing Brunette', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_F_005', name = 'Serpents', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_F_006', name = 'Oriental Mural', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_F_015', name = 'Zodiac Skull', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_F_031', name = 'Lady M', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_F_041', name = 'Dope Skull', collection = 'multiplayer_overlays'},
        },
        [4] = {
            {overlay = 'MP_Bea_F_RArm_001', name = 'Tribal Fish', collection = 'mpbeach_overlays'},
            {overlay = 'MP_MP_Biker_Tat_007_F', name = 'Swooping Eagle', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_014_F', name = 'Lady Mortality', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_033_F', name = 'Eagle Emblem', collection = 'mpbiker_overlays'},                    
            {overlay = 'MP_MP_Biker_Tat_042_F', name = 'Grim Rider', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_046_F', name = 'Skull Chain', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_047_F', name = 'Snake Bike', collection = 'mpbiker_overlays'},                    
            {overlay = 'MP_MP_Biker_Tat_049_F', name = 'These Colors Dont Run', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_054_F', name = 'Mum', collection = 'mpbiker_overlays'},
            {overlay = 'MP_Buis_F_RArm_000', name = 'Dollar Sign', collection = 'mpbusiness_overlays'},
            {overlay = 'MP_Christmas2017_Tattoo_006_F', name = 'Medusa', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Christmas2017_Tattoo_012_F', name = 'Tiger Headdress', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Christmas2017_Tattoo_014_F', name = 'Celtic Band', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Christmas2017_Tattoo_017_F', name = 'Feather Sleeve', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Christmas2017_Tattoo_018_F', name = 'Muscle Tear', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Christmas2017_Tattoo_023_F', name = 'Samurai Tallship', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Christmas2017_Tattoo_028_F', name = 'Spartan Mural', collection = 'mpchristmas2017_overlays'},
            {overlay = 'MP_Xmas2_F_Tat_003', name = 'Snake Outline', collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Xmas2_F_Tat_004', name = 'Snake Shaded', collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Xmas2_F_Tat_008', name = 'Death Before Dishonor', collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Xmas2_F_Tat_022', name = "You're Next Outline", collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Xmas2_F_Tat_023', name = "You're Next Color", collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Xmas2_F_Tat_026', name = 'Fuck Luck Outline', collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Xmas2_F_Tat_027', name = 'Fuck Luck Color', collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_002_F', name = 'Grenade', collection = 'mpgunrunning_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_021_F', name = 'Have a Nice Day', collection = 'mpgunrunning_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_024_F', name = 'Combat Reaper', collection = 'mpgunrunning_overlays'},
            {overlay = 'FM_Hip_F_Tat_001', name = 'Single Arrow', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_F_Tat_004', name = 'Bone', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_F_Tat_008', name = 'Cube', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_F_Tat_010', name = 'Horseshoe', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_F_Tat_014', name = 'Spray Can', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_F_Tat_017', name = 'Eye Triangle', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_F_Tat_018', name = 'Origami', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_F_Tat_020', name = 'Geo Pattern', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_F_Tat_022', name = 'Pencil', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_F_Tat_023', name = 'Smiley', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_F_Tat_036', name = 'Shapes', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_F_Tat_044', name = 'Triangle Black', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_F_Tat_045', name = 'Mesh Band', collection = 'mphipster_overlays'},
            {overlay = 'MP_MP_ImportExport_Tat_003_M', name = 'Mechanical Sleeve', collection = 'mpimportexport_overlays'},
            {overlay = 'MP_MP_ImportExport_Tat_005_M', name = 'Dialed In', collection = 'mpimportexport_overlays'},
            {overlay = 'MP_MP_ImportExport_Tat_006_M', name = 'Engulfed Block', collection = 'mpimportexport_overlays'},
            {overlay = 'MP_MP_ImportExport_Tat_007_M', name = 'Drive Forever', collection = 'mpimportexport_overlays'},
            {overlay = 'MP_LR_Tat_003_F', name = 'Lady Vamp', collection = 'mplowrider2_overlays'},
            {overlay = 'MP_LR_Tat_028_F', name = 'Loving Los Muertos', collection = 'mplowrider2_overlays'},
            {overlay = 'MP_LR_Tat_035_F', name = 'Black Tears', collection = 'mplowrider2_overlays'},
            {overlay = 'MP_LR_Tat_015_F', name = 'Seductress', collection = 'mplowrider_overlays'},
            {overlay = 'MP_LUXE_TAT_010_F', name = 'Intrometric', collection = 'mpluxe2_overlays'},
            {overlay = 'MP_LUXE_TAT_017_F', name = 'Heavenly Deity', collection = 'mpluxe2_overlays'},
            {overlay = 'MP_LUXE_TAT_026_F', name = 'Floral Print', collection = 'mpluxe2_overlays'},
            {overlay = 'MP_LUXE_TAT_030_F', name = 'Geometric Design', collection = 'mpluxe2_overlays'},
            {overlay = 'MP_LUXE_TAT_004_F', name = 'Floral Raven', collection = 'mpluxe_overlays'},
            {overlay = 'MP_LUXE_TAT_013_F', name = 'Mermaid Harpist', collection = 'mpluxe_overlays'},
            {overlay = 'MP_LUXE_TAT_019_F', name = 'Geisha Bloom', collection = 'mpluxe_overlays'},
            {overlay = 'MP_Smuggler_Tattoo_001_F', name = 'Crackshot', collection = 'mpsmuggler_overlays'},
            {overlay = 'MP_Smuggler_Tattoo_005_F', name = 'Mutiny', collection = 'mpsmuggler_overlays'},
            {overlay = 'MP_Smuggler_Tattoo_023_F', name = 'Stylized Kraken', collection = 'mpsmuggler_overlays'},
            {overlay = 'MP_MP_Stunt_tat_003_F', name = 'Poison Wrench', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_009_F', name = 'Arachnid of Death', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_010_F', name = 'Grave Vulture', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_016_F', name = 'Coffin Racer', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_036_F', name = 'Biker Stallion', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_038_F', name = 'One Down Five Up', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_049_F', name = 'Seductive Mechanic', collection = 'mpstunt_overlays'},
            {overlay = 'FM_Tat_Award_F_002', name = 'Grim Reaper Smoking Gun', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_Award_F_010', name = 'Ride or Die', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_F_001', name = 'Dragons', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_F_003', name = 'Dragons and Skull', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_F_014', name = 'Flower Mural', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_F_018', name = 'Serpent Skull', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_F_027', name = 'Virgin Mary', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_F_028', name = 'Mermaid', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_F_038', name = 'Dagger', collection = 'multiplayer_overlays'},                    
            {overlay = 'FM_Tat_F_047', name = 'Lion', collection = 'multiplayer_overlays'},
        },
        [5] = { 
            {overlay = 'MP_MP_Biker_Tat_002_F', name = 'Rose Tribute', collection = 'mpbiker_overlays'},  
            {overlay = 'MP_MP_Biker_Tat_015_F', name = 'Ride or Die', collection = 'mpbiker_overlays'},  
            {overlay = 'MP_MP_Biker_Tat_027_F', name = 'Bad Luck', collection = 'mpbiker_overlays'},  
            {overlay = 'MP_MP_Biker_Tat_036_F', name = 'Engulfed Skull', collection = 'mpbiker_overlays'},  
            {overlay = 'MP_MP_Biker_Tat_037_F', name = 'Scorched Soul', collection = 'mpbiker_overlays'},  
            {overlay = 'MP_MP_Biker_Tat_044_F', name = 'Ride Free', collection = 'mpbiker_overlays'},  
            {overlay = 'MP_MP_Biker_Tat_056_F', name = 'Bone Cruiser', collection = 'mpbiker_overlays'},  
            {overlay = 'MP_MP_Biker_Tat_057_F', name = 'Laughing Skull', collection = 'mpbiker_overlays'}, 
            {overlay = 'MP_Xmas2_F_Tat_001', name = 'Spider Outline', collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Xmas2_F_Tat_002', name = 'Spider Color', collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_005_F', name = 'Patriot Skull', collection = 'mpgunrunning_overlays'},                   
            {overlay = 'MP_Gunrunning_Tattoo_007_F', name = 'Stylized Tiger', collection = 'mpgunrunning_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_011_F', name = 'Death Skull', collection = 'mpgunrunning_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_023_F', name = 'Rose Revolver', collection = 'mpgunrunning_overlays'},
            
            {overlay = 'MP_Buis_F_LLeg_000', name = 'Single', collection = 'mpbusiness_overlays'},
            {overlay = 'FM_Hip_F_Tat_009', name = 'Squares', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_F_Tat_019', name = 'Charm', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_F_Tat_040', name = 'Black Anchor', collection = 'mphipster_overlays'},
            {overlay = 'MP_LR_Tat_029_F', name = 'Death Us Do Part', collection = 'mplowrider2_overlays'},
            {overlay = 'MP_LR_Tat_007_F', name = 'LS Serpent', collection = 'mplowrider_overlays'},
            {overlay = 'MP_LR_Tat_020_F', name = 'Presidents', collection = 'mplowrider_overlays'},
            {overlay = 'MP_LUXE_TAT_011_F', name = 'Cross of Roses', collection = 'mpluxe2_overlays'},
            {overlay = 'MP_LUXE_TAT_000_F', name = 'Serpent of Death', collection = 'mpluxe_overlays'},
            {overlay = 'MP_MP_Stunt_tat_007_F', name = 'Dagger Devil', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_013_F', name = 'Dirt Track Hero', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_021_F', name = 'Golden Cobra', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_028_F', name = 'Quad Goblin', collection = 'mphipster_overlays'},
            {overlay = 'MP_MP_Stunt_tat_031_F', name = 'Stunt Jesus', collection = 'mphipster_overlays'},
            {overlay = 'FM_Tat_Award_F_009', name = 'Dragon and Dagger', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_F_002', name = 'Melting Skull', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_F_008', name = 'Dragon Mural', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_F_021', name = 'Serpent Skull', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_F_023', name = 'Hottie', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_F_026', name = 'Smoking Dagger', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_F_032', name = 'Faith', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_F_033', name = 'Chinese Dragon', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_F_035', name = 'Dragon', collection = 'multiplayer_overlays'},
            {overlay = 'FM_Tat_F_037', name = 'Grim Reaper', collection = 'multiplayer_overlays'},
        },
        [6] = {
            {overlay = 'MP_MP_Biker_Tat_004_F', name = 'Dragons Fury', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_022_F', name = 'Western Insignia', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_028_F', name = 'Dusk Rider', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_040_F', name = 'American Made', collection = 'mpbiker_overlays'},
            {overlay = 'MP_MP_Biker_Tat_048_F', name = 'STFU', collection = 'mpbiker_overlays'},
            {overlay = 'MP_Xmas2_F_Tat_014', name = 'Floral Dagger', collection = 'mpchristmas2_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_006_F', name = 'Combat Skull', collection = 'mpgunrunning_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_026_f', name = 'Restless Skull', collection = 'mpgunrunning_overlays'},
            {overlay = 'MP_Gunrunning_Tattoo_030_F', name = 'Pistol Ace', collection = 'mpgunrunning_overlays'},
            {overlay = 'MP_Bea_F_RLeg_000', name = 'School of Fish', collection = 'mpbeach_overlays'},
            {overlay = 'MP_Buis_F_RLeg_000', name = 'Diamond Crown', collection = 'mpbusiness_overlays'},
            {overlay = 'FM_Hip_F_Tat_038', name = 'Grub', collection = 'mphipster_overlays'},
            {overlay = 'FM_Hip_F_Tat_042', name = 'Sparkplug', collection = 'mphipster_overlays'},
            {overlay = 'MP_LR_Tat_030_F', name = 'San Andreas Prayer', collection = 'mplowrider2_overlays'},
            {overlay = 'MP_LR_Tat_017_F', name = 'Ink Me', collection = 'mplowrider_overlays'},
            {overlay = 'MP_LR_Tat_023_F', name = 'Dance of Hearts', collection = 'mplowrider_overlays'},
            {overlay = 'MP_LUXE_TAT_023_F', name = 'Starmetric', collection = 'mpluxe2_overlays'},
            {overlay = 'MP_LUXE_TAT_001_F', name = 'Elaborate Los Muertos', collection = 'mpluxe_overlays'},
            {overlay = 'MP_Smuggler_Tattoo_020_F', name = 'Homeward Bound', collection = 'mpsmuggler_overlays'},
            {overlay = 'MP_MP_Stunt_tat_005_F', name = 'Demon Spark Plug', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_015_F', name = 'Praying Gloves', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_020_F', name = 'Piston Angel', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_025_F', name = 'Speed Freak', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_032_F', name = 'Wheelie Mouse', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_045_F', name = 'Severed Hand', collection = 'mpstunt_overlays'},
            {overlay = 'MP_MP_Stunt_tat_047_F', name = 'Brake Knife', collection = 'mpstunt_overlays'},
            {overlay = 'FM_Tat_F_043', name = 'Indian Ram', collection = 'multiplayer_overlays'},
        }
    },
}


function getTattoos()
    return tattoos[GetEntityModel(PlayerPedId())] or {}
end


function getTattooList()
    local t = getTattoos()
    local tattoos = {}
    for zone, v in ipairs(t) do
        for i,j in ipairs(v) do
            table.insert(tattoos, j)
        end
    end
    return tattoos
end

function getTattooIndex(overlay)
    local list = getTattooList()
    for k,v in ipairs(list) do
        if v.overlay == overlay then
            return k
        end
    end
end

function getTattooByIndex(index, zone)
    local t = getTattoos()
    if zone then
        return t[zone][index]
    else
        return getTattooList()[index]
    end
end






