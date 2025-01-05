-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

strix = {}
local MaxHp = 300
local _currentHp = -1
local _currentArmor = -1
local _currentFuel = -1
local _engineStatus = -1
local _hasCinto = false
local _showRadar = true
local _isInCar = false
local _currentDate
local _currentTime
local _showHud = false
local _timeEnergetic = 0
local _timeEnergeticTotal = 0
local _energeticActive = true
local _otherPed = -1
local IsPlayerSpawned = true
local _currentWeapon = -1
local _currentWeaponAmmo = -1
local _currentWeaponAmmoInClip = -1

local queue = {}

function math.round(num, numDecimalPlaces)
  if numDecimalPlaces and numDecimalPlaces>0 then
    local mult = 10^numDecimalPlaces
    return math.floor(num * mult + 0.5) / mult
  end
  return math.floor(num + 0.5)
end

function strix.Thread(callback, threadDelay)
  CreateThread(function()
      local delay = threadDelay or 0
      while true do
          delay = callback() or delay
          Wait(delay)
      end
  end)
end

--- Create a command and then a keymapping for the specified function
---@param callback function
---@param commandName string
---@param description string
---@param mapper string
---@param binding string
---@param restricted boolean
function strix.KeyMapping(callback, commandName, description, mapper, binding, restricted)
  RegisterCommand(commandName, callback, restricted or false)
  RegisterKeyMapping(commandName, description, mapper or "keyboard", binding or "e")
end

function strix.SendNuiMessage(functionName, functionParameters)
  SendNUIMessage({
      type = functionName,
      detail = functionParameters,
      content = functionParameters
  })
end

local function SetPopupIfood()
  local value = GetResourceKvpInt("ifood-start")
  if value ~= 1 then
    SetNuiFocus(true, true)
    strix.SendNuiMessage("setShowIfoodPopup", true)
    SetResourceKvpInt("ifood-start", 1)
  end
end

AddEventHandler('onClientResourceStart', function(resourceName)
  if (GetCurrentResourceName() ~= resourceName) then
    return
  end
end)



RegisterNetEvent("progress")
AddEventHandler("progress", function(time,text)
  local teste = {}
  teste.Title = text
  teste.Seconds = time / 1000
  strix.SendNuiMessage("startProgress", teste)
end)

RegisterNetEvent("up:playerSpawned")
AddEventHandler("up:playerSpawned", function()
    SetPopupIfood()
end)


RegisterNUICallback("progressResult", function (result, cb)
    local removed = table.remove(queue, 1)
    cb(true)
end)

RegisterNetEvent("hud:progress", function (jsonValue, onStart, onEnd)
  local progressConfig = json.decode(jsonValue)
  OnProgress(progressConfig, onStart, onEnd)
end)

RegisterNetEvent("hud:setInteract", function (jsonValue)
  strix.SendNuiMessage("setInteract", json.decode(jsonValue))
end)

local function OnSetConnected(connected)
  _showHud = connected
  _currentHp = -1
  _currentArmor = -1
  _currentFuel = -1
  _engineStatus = -1
  _hasCinto = false
  _currentDate = ""
  _currentTime = ""
  strix.SendNuiMessage("setShow", connected)
end

RegisterCommand("hud", function ()
  IsPlayerSpawned = true
  OnSetConnected(not _showHud)
end, false)


local function GetMicDesc(mic)
  if mic == 1 then
    return "Sussurrando"
  elseif mic == 2 then
    return "Normal"
  elseif mic == 3 then
    return "Gritando"
  else
    return "Normal"
  end
end


RegisterNetEvent("hud:setShow", OnSetConnected)

RegisterNetEvent("hud:wanted",function (ms)
  strix.SendNuiMessage("setWanted", ms)
end)


RegisterNetEvent("hud:setped", function (nped)
  _otherPed = nped
  _currentHp = -1
  _currentArmor = -1
end)

RegisterCommand("notifys", function ()
  TriggerEvent("notify","sucess","Carro trancado com <b>sucesso</b>.",8000,"Alerta")
  TriggerEvent("notify","info","Carro trancado com <b>sucesso</b>.",8000,"Alerta")
  TriggerEvent("notify","error","Carro trancado com <b>sucesso</b>.",8000,"Alerta")
  TriggerEvent("notify","warning","Carro trancado com <b>sucesso</b>.",8000,"Alerta")
end, false)

RegisterCommand("energitcos", function ()
  strix.SendNuiMessage("setEnergetic", 100)
end, false)

RegisterNetEvent("notifyItem", function (type, mensagem, time, image, title)
  local teste2 = {}
  teste2.Description = mensagem or ""
  teste2.Image = "http://167.114.223.179/inventory/"..image..".png" or ""
  teste2.Type = type or "success"
  teste2.Title = title or ""
  teste2.Timeout = time or 5000
  strix.SendNuiMessage("createNotification", teste2)
end)

RegisterNetEvent("notify", function (type, mensagem, time, title)
  local teste2 = {}
  teste2.Description = mensagem
  teste2.Type = type or "success"
  teste2.Title = title or ""
  teste2.Timeout = time or 5000
  strix.SendNuiMessage("createNotification", teste2)
end)

RegisterNetEvent("cda:setMic", function (mic)
  strix.SendNuiMessage("setMic", GetMicDesc(mic))
end)

RegisterNetEvent("cda:setRadio", function (radio)
  strix.SendNuiMessage("setRadio", radio)
end)

RegisterNetEvent("cda:setTalkingMode", function (talking)
  strix.SendNuiMessage("setTalkingMode", talking)
end)

RegisterNetEvent("cda:cinto", function (hasCintoSeguranca)
  if (_hasCinto ~= hasCintoSeguranca) then  
    _hasCinto = hasCintoSeguranca
    strix.SendNuiMessage("setCinto", hasCintoSeguranca)
  end
end)

RegisterNetEvent("isEletricVehicle", function (isEletric)
  strix.SendNuiMessage("setVehEletric", isEletric)
end)

RegisterNetEvent("cda:energetic", function (timeInMileSeconds)
  _energeticActive = true
  _timeEnergeticTotal = timeInMileSeconds / 1000
  _timeEnergetic = timeInMileSeconds / 1000
  SetRunSprintMultiplierForPlayer(PlayerId(), 1.2)
end)

RegisterNetEvent("cda:setHungry", function (hungry)
  strix.SendNuiMessage("setHungry", hungry)
end)

RegisterNetEvent("cda:setThirst", function (thirst)
  strix.SendNuiMessage("setThirsty", thirst)
end)

RegisterNetEvent("vrp_hud:update")
AddEventHandler("vrp_hud:update", function(rHunger, rThirst)
  local hunger = 100 - rHunger
  local thirst = 100 - rThirst
  strix.SendNuiMessage("setHungry", hunger)
  strix.SendNuiMessage("setThirsty", thirst)

  if (hunger > 15 and hunger <= 25) or (thirst > 15 and thirst <= 25) then
    SetTimecycleModifier("BlackOut")
    SetTimecycleModifierStrength(0.7)
  elseif (hunger > 5 and hunger <= 15) or (thirst > 5 and thirst <= 15) then
    SetTimecycleModifier("BlackOut")
    SetTimecycleModifierStrength(0.8) 
  elseif (hunger > 0 and hunger <= 5) or (thirst > 0 and thirst <= 5) then
    SetTimecycleModifier("BlackOut")
    SetTimecycleModifierStrength(0.9) 
  elseif (hunger == 0) or (thirst == 0) then
    SetTimecycleModifier("BlackOut")
    SetTimecycleModifierStrength(1.0) 
  else
    if not on_fps then
      SetTimecycleModifier("")
    end
    SetTimecycleModifierStrength(1.0) 
  end
end)


RegisterNetEvent("cda:showradar", function (value)
  _showRadar = value
end)

RegisterNetEvent("cda:setDisplayHud", function (value)
  strix.SendNuiMessage("setDisplayHud", value)
end)


RegisterNetEvent("hud:specracemod", function (value)
    strix.SendNuiMessage("setShowHungerThirst", value)
    strix.SendNuiMessage("setShowInfo", value)
end)

strix.Thread(function ()
  if (_timeEnergeticTotal == 0 or _timeEnergetic == 0) then
      strix.SendNuiMessage("setEnergetic", 0)
      _timeEnergetic = -1
      _timeEnergeticTotal = -1
      if(_energeticActive) then
          _energeticActive = false
          SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
      end
  end
  if (_timeEnergetic > 0) then
      RestorePlayerStamina(PlayerId(), 1.0)
      local percent = _timeEnergetic * 100 / _timeEnergeticTotal
      strix.SendNuiMessage("setEnergetic", percent)
      _timeEnergetic = _timeEnergetic - 1
      return 1000
  else
      return 500
  end
end, 500)

function strix.Position()
  return table.unpack(GetEntityCoords(PlayerPedId()))
end

function string.lpad(str, len, char)
  if char == nil then char = ' ' end
  return string.rep(char, len - #str)..str
end

strix.Thread(function ()
  if (IsPlayerSpawned) then
      local x,y,z = strix.Position()
      local street, _ = GetStreetNameAtCoord(x,y,z)
      local formattedDate = GetStreetNameFromHashKey(street)
      if (formattedDate ~= _currentDate) then
          _currentDate = formattedDate
          strix.SendNuiMessage("setDate", _currentDate)
      end
      local hours = tostring(GetClockHours())
      local minutes = tostring(GetClockMinutes())

      local formattedTime = string.lpad(hours, 2, "0")..":"..string.lpad(minutes, 2, "0")
      if (formattedTime ~= _currentTime) then
          _currentTime = formattedTime
          strix.SendNuiMessage("setTime", _currentTime)
      end
  end
end, 1000)



strix.Thread(function ()
  local delay = 500
  local ped = 0 
  if _otherPed ~= -1 then
    ped = _otherPed
  else 
    ped = PlayerPedId()
  end
  if (IsPlayerSpawned and IsPedInAnyVehicle(ped, false)) then
      delay = 50
      local vehicle = GetVehiclePedIsIn(ped, false)
      local isLocked = GetVehicleDoorsLockedForPlayer(vehicle,ped) == 1
      local totalSpeed = GetEntitySpeed(vehicle)
      local currentSpeed = math.ceil(totalSpeed * 3.6)
      local rpm = GetVehicleCurrentRpm(vehicle) * 100
      local fuel = math.ceil(math.round(GetVehicleFuelLevel(vehicle), 1))
      local currentEngineStatus = GetVehicleEngineHealth(vehicle)

      if (_currentFuel ~= fuel) then
          _currentFuel = fuel
          strix.SendNuiMessage("setFuelLevel", fuel)
      end
      if (currentEngineStatus ~=_engineStatus) then
          _engineStatus = currentEngineStatus
          local percent = ((_engineStatus - 100) * 100) / 900
          strix.SendNuiMessage("setEngineLevel", percent)
      end
      local gear = GetVehicleCurrentGear(vehicle)
      strix.SendNuiMessage("setSpeed", currentSpeed)
      strix.SendNuiMessage("setRpm", rpm > 100 and 100 or rpm)
      local shift = tostring(gear)
      if currentSpeed == 0 then
        shift = "N"
      end
      if gear == 0 then
        shift = "R"
      end
      strix.SendNuiMessage("setShift", shift)
      strix.SendNuiMessage("setLocked", isLocked)
  end
  return delay
end, 500)

local weapon_types = {
	"WEAPON_DAGGER",
	"WEAPON_BAT",
	"WEAPON_BOTTLE",
	"WEAPON_CROWBAR",
	"WEAPON_FLASHLIGHT",
	"WEAPON_GOLFCLUB",
	"WEAPON_HAMMER",
	"WEAPON_WEAPON_HATCHET",
	"WEAPON_WEAPON_KNUCKLES",
	"WEAPON_KNIFE",
	"WEAPON_MACHETE",
	"WEAPON_SWITCHBLADE",
	"WEAPON_NIGHTSTICK",
	"WEAPON_WHENCH",
	"WEAPON_BATTLEAXE",
	"WEAPON_POOLCUE",
	"WEAPON_STONE_HATCHET",

	"WEAPON_PISTOL",
	"WEAPON_PISTOL_MK2",
	"WEAPON_COMBATPISTOL",
	"WEAPON_APPISTOL",
	"WEAPON_STUNGUN",
	"WEAPON_PISTOL50",
	"WEAPON_SNSPISTOL",
	"WEAPON_SNSPISTOL_MK2",
	"WEAPON_HEAVYPISTOL",
	"WEAPON_VINTAGEPISTOL",
	"WEAPON_FLAREGUN",
	"WEAPON_MARKSMANPISTOL",
	"WEAPON_REVOLVER",
	"WEAPON_REVOLVER_MK2",
	"WEAPON_DOUBLEACTION",
	"WEAPON_RAYPISTOL",
	"WEAPON_CERAMICPISTOL",
	"WEAPON_NAVYREVOLVER",

	"WEAPON_MICROSMG",
	"WEAPON_SMG",
	"WEAPON_SMG_MK2",
	"WEAPON_ASSAULTSMG",
	"WEAPON_COMBATPDW",
	"WEAPON_MACHINEPISTOL",
	"WEAPON_MINISMG",
	"WEAPON_RAYCARBINE",

	"WEAPON_PUMPSHOTGUN",
	"WEAPON_PUMPSHOTGUN_MK2",
	"WEAPON_SAWNOFFSHOTGUN",
	"WEAPON_ASSAULTSHOTGUN",
	"WEAPON_BULLPUPSHOTGUN",
	"WEAPON_MUSKET",
	"WEAPON_HEAVYSHOTGUN",
	"WEAPON_DBSHOTGUN",
	"WEAPON_AUTOSHOTGUN",

	"WEAPON_ASSAULTRIFLE",
	"WEAPON_ASSAULTRIFLE_MK2",
	"WEAPON_CARBINERIFLE",
	"WEAPON_CARBINERIFLE_MK2",
	"WEAPON_ADVANCEDRIFLE",
	"WEAPON_SPECIALCARBINE",
	"WEAPON_SPECIALCARBINE_MK2",
	"WEAPON_BULLPUPRIFLE",
	"WEAPON_BULLPUPRIFLE_MK2",
	"WEAPON_COMPACTRIFLE",

	"WEAPON_MG",
	"WEAPON_COMBATMG",
	"WEAPON_COMBATMG_MK2",
	"WEAPON_GUSENBERG",

	"WEAPON_SNIPERRIFLE",
	"WEAPON_HEAVYSNIPER",
	"WEAPON_HEAVYSNIPER_MK2",
	"WEAPON_MASKMANRIFLE",
	"WEAPON_MASKMANRIFLE_MK2",

	"WEAPON_RPG",
	"WEAPON_GRENADELAUNCHER",
	"WEAPON_GRENADELAUNCHER_SMOKE",
	"WEAPON_MINIGUN",
	"WEAPON_FIREWORK",
	"WEAPON_RAILGUN",
	"WEAPON_HOMINGLAUNCHER",
	"WEAPON_COMPACTLAUNCHER",
	"WEAPON_RAYMINIGUN",

	"WEAPON_GRANADE",
	"WEAPON_BZGAS",
	"WEAPON_MOLOTOV",
	"WEAPON_STICKYBOMB",
	"WEAPON_PROXMINE",
	"WEAPON_SNOWBALL",
	"WEAPON_PIPEBOMB",
	"WEAPON_BALL",
	"WEAPON_SMOKEGRENADE",
	"WEAPON_FLARE",

	"WEAPON_PETROLCAN",
	"GADGET_PARACHUTE",
	"WEAPON_FIREEXTINGUISHER"
}

strix.Thread(function ()
  local delay = 500

  if (IsPlayerSpawned) then
      delay = 50
      local ped = 0 
      if _otherPed ~= -1 then
        ped = _otherPed
      else 
        ped = PlayerPedId()
      end
      local health = GetEntityHealth(ped)
      local armour = GetPedArmour(ped)

      if (_currentHp ~= health) then
          _currentHp = health
          local percentValue = ((_currentHp - 100) * 100) / (MaxHp)
          strix.SendNuiMessage("setHp", percentValue)
      end

      if (_currentArmor ~= armour) then
          _currentArmor = armour
          local percentValue = _currentArmor > 100 and 100 or _currentArmor
          strix.SendNuiMessage("setArmor", percentValue)
      end

      local weapon = GetSelectedPedWeapon(ped)

      if weapon ~= -1569615261 then
        local _, weaponammoinclip = GetAmmoInClip(ped, weapon)
        local weaponammo = GetAmmoInPedWeapon(ped, weapon) - weaponammoinclip

        for k, v in pairs(weapon_types) do
          if weapon == GetHashKey(v) then
            strix.SendNuiMessage("setCurrentWeaponModel", v)
            strix.SendNuiMessage("setCurrentWeaponAmmoInClip", weaponammoinclip)
            strix.SendNuiMessage("setCurrentWeaponAmmo", weaponammo)
          end 
        end

        -- if (_currentWeapon ~= weapon) then
        --   _currentWeapon = weapon
        --   for k, v in pairs(weapon_types) do
        --     if _currentWeapon == GetHashKey(v) then
        --       strix.SendNuiMessage("setCurrentWeaponModel", v)
        --     end 
        --   end
        -- end

        -- if (_currentWeaponAmmoInClip ~= weaponammoinclip) then
        --   _currentWeaponAmmoInClip = weaponammoinclip
        --   strix.SendNuiMessage("setCurrentWeaponAmmoInClip", _currentWeaponAmmoInClip)
        -- end

        -- if (_currentWeaponAmmo ~= weaponammo) then
        --   _currentWeaponAmmo = weaponammo
        --   strix.SendNuiMessage("setCurrentWeaponAmmo", _currentWeaponAmmo)
        -- end

        --print(weaponammoinclip)
      else
        strix.SendNuiMessage("setCurrentWeaponModel", nil)
        strix.SendNuiMessage("setCurrentWeaponAmmoInClip", 0)
        strix.SendNuiMessage("setCurrentWeaponAmmo", 0)
      end

      --strix.SendNuiMessage("setCurrentWeaponModel", weapon)

      --print(weapon)
  end
  return delay
end, 500)


strix.Thread(function ()
  if (IsPlayerSpawned) then
    local ped = 0 
    if _otherPed ~= -1 then
      ped = _otherPed
    else 
      ped = PlayerPedId()
    end
    if (IsPedInAnyVehicle(ped, false)) then
        SetRadarZoom(1000)
        DisplayRadar(_showRadar)
        if (not _isInCar) then
            _isInCar = true
            strix.SendNuiMessage("setInCar", true)
        end
    else
        if (_isInCar) then
            _isInCar = false
            strix.SendNuiMessage("setInCar", false)
        end
        DisplayRadar(false)
    end
  else
      DisplayRadar(false)
  end
end, 500)

RegisterNetEvent("hud:setCupom", function (jsonCupom)
  if jsonCupom then
    jsonCupom = json.decode(jsonCupom)
  end
  strix.SendNuiMessage("setCupom", jsonCupom)
end)

RegisterNUICallback("close", function(_,cb) 
  SetNuiFocus(false, false)
  strix.SendNuiMessage("setShowIfoodPopup", false)
  cb()
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local sBuffer = {}
local vBuffer = {}
local CintoSeguranca = false
local ExNoCarro = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		NetworkClearVoiceChannel()
		NetworkSetTalkerProximity(1)
	end
end)

IsCar = function(veh)
	local vc = GetVehicleClass(veh)
	return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 17 and vc <= 20)
end	

Fwv = function (entity)
	local hr = GetEntityHeading(entity) + 90.0
	if hr < 0.0 then
		hr = 360.0 + hr
	end
	hr = hr * 0.0174533
	return { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
end


RegisterNetEvent("vrp_carhud:seatBelt")
AddEventHandler("vrp_carhud:seatBelt", function()
	if CintoSeguranca then
		return
	end

	CintoSeguranca = true
	TriggerEvent("cda:cinto", CintoSeguranca)
end)

Citizen.CreateThread(function()
	local lastVeh = nil
	local hash = nil
	while true do
		local ped = PlayerPedId()
		local car = GetVehiclePedIsIn(ped)

		local idle = 500

		if car ~= 0 and (ExNoCarro or IsCar(car)) then
			idle = 5
			ExNoCarro = true
			if CintoSeguranca then
				DisableControlAction(0,75)
			end

			sBuffer[2] = sBuffer[1]
			sBuffer[1] = GetEntitySpeed(car)

			if sBuffer[2] ~= nil and not CintoSeguranca and GetEntitySpeedVector(car,true).y > 1.0 and sBuffer[1] > 10.25 and (sBuffer[2] - sBuffer[1]) > (sBuffer[1] * 0.255) then
				local co = GetEntityCoords(ped)
				local fw = Fwv(ped)
				SetEntityHealth(ped,GetEntityHealth(ped)-100)
				SetEntityCoords(ped,co.x+fw.x,co.y+fw.y,co.z-0.47,true,true,true)
				SetEntityVelocity(ped,vBuffer[2].x,vBuffer[2].y,vBuffer[2].z)
			end

			vBuffer[2] = vBuffer[1]
			vBuffer[1] = GetEntityVelocity(car)

			if IsControlJustReleased(1,105) then
				if CintoSeguranca then
					CintoSeguranca = false					
				else
					CintoSeguranca = true
				end
				TriggerEvent("cda:cinto", CintoSeguranca);
			end
		elseif ExNoCarro then
			ExNoCarro = false
			CintoSeguranca = false
			TriggerEvent("cda:cinto", CintoSeguranca);
			sBuffer[1],sBuffer[2] = 0.0,0.0
		end
		Citizen.Wait(idle)
	end
end)

local currentPos
local isPause = false
local uiHidden = false

RegisterNetEvent('refreshMinimap')
AddEventHandler('refreshMinimap', function(type, time) 
    currentPos = type
    if type == 'left' then
        Citizen.Wait(time)
        print('refreshing left minimap')
        uiHidden = true
        RequestStreamedTextureDict("circlemap", false)
        while not HasStreamedTextureDictLoaded("circlemap") do
            Wait(100)
        end
        AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "circlemap", "radarmasksm")
        SetMinimapClipType(1)
        SetMinimapComponentPosition('minimap', 'L', 'B', -0.005, 0.0, 0.160, 0.26)
        SetMinimapComponentPosition('minimap_mask', 'L', 'B', 0.07, 0.00, 0.1, 0.14)
        SetMinimapComponentPosition('minimap_blur', 'L', 'B', 0.01, 0.025, 0.200, 0.300)
        local minimap = RequestScaleformMovie("minimap")
        SetRadarBigmapEnabled(true, false)
        Wait(0)
        SetRadarBigmapEnabled(false, false)
    elseif type == 'right' then
        Citizen.Wait(time)
        print('refreshing right minimap')
        uiHidden = true
        RequestStreamedTextureDict("circlemap", false)
        while not HasStreamedTextureDictLoaded("circlemap") do
            Wait(100)
        end
        AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "circlemap", "radarmasksm")
        SetMinimapClipType(1)
        SetMinimapComponentPosition('minimap', 'R', 'B', 0.0, 0.0, 0.150, 0.26)
        SetMinimapComponentPosition('minimap_mask', 'R', 'B', 0.0, 0.00, 0.1, 0.14)
        SetMinimapComponentPosition('minimap_blur', 'R', 'B', 0.09+0.007, 0.025, 0.200, 0.300)
        local minimap = RequestScaleformMovie("minimap")
        SetRadarBigmapEnabled(true, false)
        Wait(0)
        SetRadarBigmapEnabled(false, false)
    end
end)

AddEventHandler('onResourceStart', function(resource)
  if resource == GetCurrentResourceName() then
    Wait(1000)
    IsPlayerSpawned = true
    OnSetConnected(not _showHud)
    TriggerEvent('refreshMinimap', 'left', 500)
  end
end)