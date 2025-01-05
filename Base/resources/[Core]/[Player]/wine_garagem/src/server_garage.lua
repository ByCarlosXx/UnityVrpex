-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
---------------------------------------------------------------------- -------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
local DNext = {}
Tunnel.bindInterface("wine_garagem",DNext)
Proxy.addInterface("wine_garagem",DNext)
vCLIENT = Tunnel.getInterface("wine_garagem")
local banco_de_dados = Config.tabela 
local Autenticado_01022016_wine_garagem = true




vRP.prepare('garage/create_colunas',
  [[
	CREATE TABLE IF NOT EXISTS `vrp_user_vehicles` (
	`user_id` int(11) NOT NULL,
	`vehicle` varchar(100) NOT NULL,
	`detido` int(1) NOT NULL DEFAULT 0,
	`time` varchar(24) NOT NULL DEFAULT '0',
	`engine` int(4) NOT NULL DEFAULT 1000,
	`body` int(4) NOT NULL DEFAULT 1000,
	`fuel` int(3) NOT NULL DEFAULT 100,
	`ipva` varchar(50) DEFAULT NULL,
	`doors` varchar(254) NOT NULL,
	`windows` varchar(254) NOT NULL,
	`tyres` varchar(254) NOT NULL,
	`stoled_by` text DEFAULT NULL,
	`stoled_at` text DEFAULT NULL,
	`last_garage` text DEFAULT NULL,
	PRIMARY KEY (`user_id`,`vehicle`),
	CONSTRAINT `FK_vrp_user_vehicles_vrp_chars` FOREIGN KEY (`user_id`) REFERENCES `vrp_users` (`id`) ON DELETE CASCADE
	) ENGINE=InnoDB DEFAULT CHARSET=latin1;
  ]]
)

-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE
-----------------------------------------------------------------------------------------------------------------------------------------
vRP._prepare("wine_garagem/add_vehicle","INSERT IGNORE INTO "..banco_de_dados.."(user_id,vehicle,engine,body,fuel) VALUES(@user_id,@vehicle,@engine,@body,@fuel)")
vRP._prepare("wine_garagem/rem_vehicle","DELETE FROM "..banco_de_dados.." WHERE user_id = @user_id AND vehicle = @vehicle")
vRP._prepare("wine_garagem/get_vehicle","SELECT * FROM "..banco_de_dados.." WHERE user_id = @user_id AND vehicle = @vehicle")
vRP._prepare("wine_garagem/get_vehicles","SELECT * FROM "..banco_de_dados.." WHERE user_id = @user_id")
vRP._prepare("wine_garagem/get_vehicles_stoled","SELECT * FROM "..banco_de_dados.." WHERE stoled_by = @user_id")
vRP._prepare("wine_garagem/get_vehicle_stoled","SELECT vehicle FROM "..banco_de_dados.." WHERE stoled_by = @user_id AND user_id = @owner AND vehicle = @vehicle;")
-- vRP._prepare("wine_garagem/get_vehicles","SELECT * FROM vrp_user_vehicles WHERE user_id = @user_id AND (last_garage IS NULL OR last_garage = @last_garage)")
vRP._prepare("wine_garagem/update_vehicles","UPDATE "..banco_de_dados.." SET engine = @engine, body = @body, fuel = @fuel, doors = @doors, windows = @windows, tyres = @tyres WHERE user_id = @user_id AND vehicle = @vehicle")
vRP._prepare("wine_garagem/update_vehicles_lastGarages","UPDATE "..banco_de_dados.." SET last_garage = @garageId WHERE user_id = @user_id AND vehicle = @vehicle")
vRP._prepare("wine_garagem/update_vehicles_withGarage","UPDATE "..banco_de_dados.." SET last_garage = @garageId, engine = @engine, body = @body, fuel = @fuel, doors = @doors, windows = @windows, tyres = @tyres WHERE user_id = @user_id AND vehicle = @vehicle")
vRP._prepare("wine_garagem/update_Svehicles","UPDATE "..banco_de_dados.." SET engine = @engine, body = @body, fuel = @fuel, doors = @doors, windows = @windows, tyres = @tyres WHERE user_id = @user_id AND vehicle = @vehicle")
vRP._prepare("wine_garagem/move_vehicle","UPDATE "..banco_de_dados.." SET user_id = @nuser_id WHERE user_id = @user_id AND vehicle = @vehicle")
vRP._prepare("wine_garagem/get_stoled_vehs","SELECT * FROM "..banco_de_dados.." WHERE stoled_by != 'NULL'")
vRP._prepare("wine_garagem/check_vehicle_stoled","SELECT true FROM "..banco_de_dados.." WHERE user_id = @user_id AND vehicle = @vehicle AND (stoled_by IS NOT NULL)")
vRP._prepare("wine_garagem/set_veh_stoled","UPDATE "..banco_de_dados.." SET stoled_by = @stoled_by, stoled_at = @stoled_at WHERE user_id = @user_id AND vehicle = @vehicle")
vRP._prepare("wine_garagem/update_veh_stoled","UPDATE "..banco_de_dados.." SET stoled_by = @stoled_by WHERE user_id = @user_id AND vehicle = @vehicle")
vRP._prepare("wine_garagem/rem_veh_stoled","UPDATE "..banco_de_dados.." SET stoled_by = NULL, stoled_at = NULL WHERE user_id = @user_id AND vehicle = @vehicle")
vRP._prepare("wine_garagem/rem_veh_last_garage","UPDATE "..banco_de_dados.." SET last_garage = NULL WHERE user_id = @user_id and vehicle = @vehicle")
vRP._prepare("wine_garagem/clear_expire_stoled","UPDATE "..banco_de_dados.." SET last_garage = NULL, stoled_at = NULL, stoled_by = NULL WHERE ( stoled_at IS NOT NULL and stoled_at+@stoled_time < (UNIX_TIMESTAMP(CURRENT_TIMESTAMP)))")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
-- DECLARE VARIABLES
local playerVehs = {}
local VehsInfo = {}
--local autenticado = true
local bucketList = {}
local userBucket = {}
local use_plate_system = false

Citizen.CreateThread(function()
	while true do
		vRP.execute("wine_garagem/clear_expire_stoled",{ stoled_time = Config['personalize'].DiaCarroRoubado*24*60*60 })
		Citizen.Wait(1*60*60000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
local function CountTable(tab)
    local i = 0
    for _,_ in pairs(tab) do i = i + 1 end
    return i
end

function DNext.returnGarageNameById(id)
	return Config.garages[tonumber(id)] and Config.garages[tonumber(id)].name
end

function DNext.checkSearch()
    local source = source
    local user_id = vRP.getUserId(source)
    if vRP.searchReturn(source,user_id,true,false) then
        return true 
    end
    return false
end

function DNext.checkPermission(perm)
	if Autenticado_01022016_wine_garagem == true then
		local source = source
		local user_id = vRP.getUserId(source)
		if vRP.hasPermission(user_id,perm) then
			return true
		else
			TriggerClientEvent("Notify",source,"negado","Você não tem permissão",5000)
			return false
		end
	end
end


vRP._prepare("wine_garagem/get_homeuseridowner","SELECT * FROM vrp_homes_permissions WHERE home = @home AND owner = 1")
local casas_config = {
    ["interior"] = "pequena"
}



function DNext.checkHasPermInHouse(houseType)
	if Autenticado_01022016_wine_garagem == true then
		local interior = json.encode(casas_config)
		local resultOwner = vRP.query("wine_garagem/get_homeuseridowner",{ home = houseType })
		----print(json.encode(resultOwner[1]))
		if resultOwner[1] or houseType == "publica" then
			return true,interior
		end
	end
end


function DNext.isOwnerOrStoledVehicle(vname,plate)
	----print(vname,plate)
	local source = source
	local user_id = vRP.getUserId(source)
	local nuser_id = vRP.getUserByRegistration(plate)
	if nuser_id and user_id == nuser_id then
		local sdata = vRP.query("wine_garagem/get_vehicle",{ user_id = parseInt(user_id), vehicle = vname })
		local data = sdata[1]
		if data then
			vRP.execute("wine_garagem/rem_veh_stoled",{ user_id = parseInt(user_id), vehicle = vname })
			return true
		end
	else
		if nuser_id then
			local sdata = vRP.query("wine_garagem/get_vehicle_stoled",{ user_id = parseInt(user_id), owner = parseInt(nuser_id), vehicle = vname })
			local data = sdata[1]
			if data then
				return true
			end
		end
	end
	return false
end

function DNext.requestStoledVehicle(vname,plate)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local ok = vRP.request(source,"Você gostaria de guardar o veiculo?",30)
		if ok then
			local nuser_id = vRP.getUserByRegistration(plate)
			if nuser_id then
				local sdata = vRP.query("wine_garagem/check_vehicle_stoled",{ user_id = parseInt(nuser_id), vehicle = vname })
				local data = sdata[1]
				if data then
					vRP.execute('wine_garagem/update_veh_stoled',{stoled_by = user_id, vehicle = vname, user_id = nuser_id})
				else
					vRP.execute('wine_garagem/set_veh_stoled',{stoled_by = user_id, stoled_at = os.time(), vehicle = vname, user_id = nuser_id})
				end
				Citizen.Wait(100)
				return true
			end
		else
			return false
		end
	end
	return false
end

function DNext.payGarage(payment)
	local source = source
	return PaymentGarage(source,payment)
end

-- BUCKET FUNCTIONS 
function DNext.placeInNewBucket(ents,escapeCoords)
	local source = source
	SetPlayerRoutingBucket(source,parseInt(source))

	if ents and type(ents) == 'table' then 
		for _,NetEnt in pairs(ents) do
			local ent = NetworkGetEntityFromNetworkId(NetEnt)
			SetEntityRoutingBucket(ent,parseInt(source))
		end
	else
		local ent = NetworkGetEntityFromNetworkId(ents)
		SetEntityRoutingBucket(ent,parseInt(source))
	end

	while GetPlayerRoutingBucket(source) == 0 do
		local timeDistance = 25
		SetPlayerRoutingBucket(source,parseInt(source))
		if ents and type(ents) == 'table' then 
			for _,NetEnt in pairs(ents) do
				local ent = NetworkGetEntityFromNetworkId(NetEnt)
				SetEntityRoutingBucket(ent,parseInt(source))
				bucketList[GetPlayerRoutingBucket(source)].ents[NetEnt] = true

			end
		else
			local ent = NetworkGetEntityFromNetworkId(ents)
			SetEntityRoutingBucket(ent,parseInt(source))
			bucketList[GetPlayerRoutingBucket(source)].ents[ents] = true
		end
		l = l + 1
		if l >= 200 then
			timeDistance = 30000
			print("^8--------------------------------------------------------------\n\n-> ^8SERVIDOR COM ONESYNC DESATIVADO <-\n\n^8--------------------------------------------------------------\n^7")
		end
		Citizen.Wait(timeDistance)
	end

	if not bucketList[GetPlayerRoutingBucket(source)] then bucketList[GetPlayerRoutingBucket(source)] = {} end
	bucketList[GetPlayerRoutingBucket(source)].escapeCoords = {x=escapeCoords.x,y=escapeCoords.y,z=escapeCoords.z}
	userBucket[source] = GetPlayerRoutingBucket(source)
end

function DNext.exitBucket(ents)
	local source = source
	bucketList[GetPlayerRoutingBucket(source)] = nil
	userBucket[source] = nil
	SetPlayerRoutingBucket(source,0)
	if ents and type(ents) == 'table' then 
		for _,NetEnt in pairs(ents) do
			local ent = NetworkGetEntityFromNetworkId(NetEnt)
			SetEntityRoutingBucket(ent,0)
		end
	else
		local ent = NetworkGetEntityFromNetworkId(ents)
		SetEntityRoutingBucket(ent,0)
	end
	while GetPlayerRoutingBucket(source) ~= 0 do
		if ents and type(ents) == 'table' then 
			for _,NetEnt in pairs(ents) do
				local ent = NetworkGetEntityFromNetworkId(NetEnt)
				SetEntityRoutingBucket(ent,0)
			end
		else
			local ent = NetworkGetEntityFromNetworkId(ents)
			SetEntityRoutingBucket(ent,0)
		end
		SetPlayerRoutingBucket(source,0)
		Citizen.Wait(50)
	end
end

function DNext.updateVehiclesInBucket(ents)
	local source = source
	local userBucket = GetPlayerRoutingBucket(source)
	if (type(ents) == "nil" or CountTable(ents) == 0) and bucketList[userBucket] and bucketList[userBucket].ents then bucketList[userBucket].ents = nil end
	if not bucketList[userBucket] then bucketList[userBucket] = {ents={}} end
	bucketList[userBucket].ents = {}
	if ents then
		for _,_data in pairs(ents) do
			if (not bucketList[userBucket].ents[_data.nveh]) then
				bucketList[userBucket].ents[_data.nveh] = true
			end
		end
	end

end
-- ADQUIRIR CARROS DO USUARIO
function DNext.myVehicles(garageId)
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if user_id then
		DNext.refreshUserVehicles(user_id)
		local myvehicles = {}
		local tuning = {}
		local veh = vRP.query("wine_garagem/get_vehicles",{ user_id = parseInt(user_id) })
		local veh_stoled = vRP.query("wine_garagem/get_vehicles_stoled",{ user_id = parseInt(user_id) })
		for k,v in ipairs(veh) do
			if v.detido ~= 3 then 
				if v.detido ~= 0 then
					vRP.execute("wine_garagem/rem_veh_stoled",{ user_id = parseInt(user_id), vehicle = v.vehicle })
					v.stoled_by = nil
				end
				if (v.stoled_by == 'NULL' or v.stoled_by == nil or v.stoled_by == 0 or v.stoled_by == user_id) then
					local name = v.vehicle
					if not playerVehs[user_id] or (playerVehs[user_id] and not playerVehs[user_id][GetHashKey(name)]) then
						tuning = InfoTuning(v.user_id,name)
						local inGarage = true
						if Config.useLastGarage then 
						if garageId and tonumber(v.last_garage) ~= nil and tonumber(v.last_garage) ~= garageId then 
							inGarage = false 
						end
						else 
							if garageId and tonumber(v.last_garage) ~= nil and tonumber(v.last_garage) ~= garageId then 
								inGarage = true 
							end

						-- if v.stoled_by ~= nil and v.stoled_by ~= 0 then isStoled = true end
						end
						if Config.useLastGarage then 
						if tonumber(v.last_garage) == garageId or not v.last_garage then
							if use_plate_system then
								table.insert(myvehicles, { inGarage = inGarage, detido = v.detido, name = name, vname = vRP.vehicleName(name) or name, plate = v.plate, engine = v.engine, body = v.body, fuel = v.fuel, tuning = tuning, work = v.work, vehDoors = json.decode(v.doors), vehWindows = json.decode(v.windows), vehTyres = json.decode(v.tyres) })
							else
								table.insert(myvehicles, { inGarage = inGarage, detido = v.detido, name = name, vname = vRP.vehicleName(name) or name, plate = identity.registration, engine = v.engine, body = v.body, fuel = v.fuel, tuning = tuning, work = v.work, vehDoors = json.decode(v.doors), vehWindows = json.decode(v.windows), vehTyres = json.decode(v.tyres) })
							end
						end
					else 
						if use_plate_system then
							table.insert(myvehicles, { inGarage = inGarage, detido = v.detido, name = name, vname = vRP.vehicleName(name) or name, plate = v.plate, engine = v.engine, body = v.body, fuel = v.fuel, tuning = tuning, work = v.work, vehDoors = json.decode(v.doors), vehWindows = json.decode(v.windows), vehTyres = json.decode(v.tyres) })
						else
							table.insert(myvehicles, { inGarage = inGarage, detido = v.detido, name = name, vname = vRP.vehicleName(name) or name, plate = identity.registration, engine = v.engine, body = v.body, fuel = v.fuel, tuning = tuning, work = v.work, vehDoors = json.decode(v.doors), vehWindows = json.decode(v.windows), vehTyres = json.decode(v.tyres) })
						end
					end
					end
				end
			end
		end

		for k,v in ipairs(veh_stoled) do
			if v.detido == 0 then
				local name = v.vehicle
				local identity = vRP.getUserIdentity(v.user_id)
				if not playerVehs[v.user_id] or (playerVehs[v.user_id] and not playerVehs[v.user_id][GetHashKey(name)]) then
					tuning = InfoTuning(v.user_id,name)
					local inGarage = true
					if garageId and tonumber(v.last_garage) ~= nil and tonumber(v.last_garage) ~= garageId then 
						inGarage = false 
					end
					if use_plate_system then
						table.insert(myvehicles, { inGarage = inGarage, detido = v.detido, name = name, vname = vRP.vehicleName(name) or name, plate = v.plate, engine = v.engine, body = v.body, fuel = v.fuel, tuning = tuning, work = v.work, vehDoors = json.decode(v.doors), vehWindows = json.decode(v.windows), vehTyres = json.decode(v.tyres) })
					else
						table.insert(myvehicles, { inGarage = inGarage, detido = v.detido, name = name, vname = vRP.vehicleName(name) or name, plate = identity.registration, engine = v.engine, body = v.body, fuel = v.fuel, tuning = tuning, work = v.work, vehDoors = json.decode(v.doors), vehWindows = json.decode(v.windows), vehTyres = json.decode(v.tyres) })
					end
				end
			end
		end
		return myvehicles
	end
end

vRP.prepare("reborn/reset_detido","UPDATE vrp_user_vehicles SET detido = 0, time = 0 WHERE vehicle = @vehicle AND user_id = @user_id ")
function DNext.paymentArrestVehicle(vname)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and vname then
		local valordetido = 10/100
		local sdata = vRP.query("wine_garagem/get_vehicle",{ user_id = parseInt(user_id), vehicle = vname })
		local data = sdata[1]
		if parseInt(data.detido) == 1 or parseInt(data.detido) == 2 then
			if vRP.vehicleType(tostring(vname)) == "cars" or vRP.vehicleType(tostring(vname)) == "bikes" or vRP.vehicleType(tostring(vname)) == nil then
                valordetido = 3/100
            elseif vRP.vehicleType(tostring(vname)) == "donate" then
                valordetido = 5/100
            end
			local status = vRP.request(source,"O veículo "..vname.." está detido, deseja acionar o seguro pagando <b>R$"..vRP.format(parseInt(vRP.vehiclePrice(vname)*valordetido)).."</b>?",60)
			if status then
                if vRP.tryFullPayment(user_id,parseInt(vRP.vehiclePrice(vname)*valordetido)) then
					-- vRP.execute("vRP/setDetido",{ user_id = parseInt(user_id), vehicle = vname, detido = 0, time = 0 })
					vRP.execute("reborn/reset_detido",{ user_id = parseInt(user_id), vehicle = vname})
					-- --print('SETOU O DETIDO COMO 0',user_id,vname)
                    return true
                else
                    TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.",5000)
                    return false
                end
            end
		else
			return true
		end	
	end
end

-- UNLOCK/LOCK VEHICLE (SYNC FUNCTION)
function DNext.tryDoorVehicle()
	local source = source
    local user_id = vRP.getUserId(source)
    local vehicle,vehNet,vehPlate,vehName = vRPclient.vehList(source,7)
    if vehPlate then
        vehPlate = string.gsub(vehPlate, "%s+", "")
        local plateOwnerId = vRP.getVehiclePlate(vehPlate) or vRP.getUserByRegistration(vehPlate)
        if plateOwnerId and (user_id == plateOwnerId) then
            DNext.syncTryLockDoors(vehNet,nil,source)
            TriggerClientEvent("vrp_sound:source",source,'lock',0.1)
        end
    end
end

function DNext.syncTryLockDoors(nveh,stats,source)
	if stats == nil then stats = 'toggle' end
	vCLIENT.syncStatsDoors(-1,nveh,stats,source)
end

function DNext.filterList(vehList)
	local source = source
	local user_id = vRP.getUserId(source)
	local tab = {}
	if user_id then
		for _,_data in pairs(vehList) do
			if not playerVehs[user_id] or (playerVehs[user_id] and not playerVehs[user_id][GetHashKey(_data.name)]) then
				table.insert(tab,_data)
			end
		end
	end
	return tab
end

function DNext.verifyIsHashOutGarages(hash,plate)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if plate then 
			user_id = vRP.getUserByRegistration(plate)
		end
		if playerVehs[user_id] and playerVehs[user_id][hash] then 
			return true
		end
	end
	return false
end

function DNext.refreshUserVehicles(user_id)
	if playerVehs[user_id] then
		for hash,vnet in pairs(playerVehs[user_id]) do
			local ent = NetworkGetEntityFromNetworkId(vnet)
			if ent and not DoesEntityExist(ent) or (DoesEntityExist(ent) and GetEntityModel(ent) ~= hash) then
				VehsInfo[playerVehs[user_id][hash]] = nil
				playerVehs[user_id][hash] = nil
			end
		end
	end
end

AddEventHandler('entityRemoved', function (veh)
	local vehbody = GetVehicleEngineHealth(veh)
	local vehengine = GetVehicleBodyHealth(veh)

	local nveh = NetworkGetNetworkIdFromEntity(veh)
	local plate = GetVehicleNumberPlateText(veh)
	local hash = GetEntityModel(veh)
	if vRP.getUserByRegistration(plate) then
		local nuser_id = vRP.getUserByRegistration(plate)
		if nuser_id then
			if playerVehs[nuser_id] and playerVehs[nuser_id][hash] then

				VehsInfo[playerVehs[nuser_id][hash]] = nil
				playerVehs[nuser_id][hash] = nil
				if CountTable(playerVehs[nuser_id]) == 0 then 
					playerVehs[nuser_id] = nil 
				end
				
			end
		end
	end
end)

AddEventHandler('entityCreated', function (veh)
	if veh and DoesEntityExist(veh) then
		local nveh = NetworkGetNetworkIdFromEntity(veh)
		local plate = GetVehicleNumberPlateText(veh)
		if vRP.getUserByRegistration(plate) then
			local nuser_id = vRP.getUserByRegistration(plate)
			if nuser_id then
				local nsource = vRP.getUserSource(nuser_id)
				local hash = vCLIENT.getModel(nsource,nveh)
				if not playerVehs[nuser_id] then playerVehs[nuser_id] = {} end
				playerVehs[nuser_id][hash] = nveh
				VehsInfo[nveh] = {nuser_id,hash}
			end
		end
	end
end)

local global_Vehicles = {}
local cooldown_time
local function _GetAllVehicles()
	if cooldown_time == nil or GetGameTimer() > cooldown_time then
		cooldown_time = ( GetGameTimer() + 250 )
		global_Vehicles = GetAllVehicles()
	end
	return global_Vehicles
end
local function checkPersonalVehiclePlayerExist(user_id,hash)
	local result
	for _,veh in pairs(_GetAllVehicles()) do
		if veh and DoesEntityExist(veh) then
			local plate = GetVehicleNumberPlateText(veh)
			if plate then
				local nuser_id = vRP.getUserByRegistration(plate)
				if nuser_id and veh and DoesEntityExist(veh) then
					if user_id == nuser_id and GetEntityModel(veh) == hash then
						result = NetworkGetNetworkIdFromEntity(veh)
						break
					end
				end
			end
		end
	end
	return result
end

function DNext.refreshOwnerVehicle(nveh)
	if nveh then
		local veh = NetworkGetEntityFromNetworkId(nveh)
		if veh and DoesEntityExist(veh) then
			local plate = GetVehicleNumberPlateText(veh)
			local nuser_id = vRP.getUserByRegistration(plate)
			if nuser_id then
				if VehsInfo[nveh] then
					local old_owner,hash = VehsInfo[nveh][1],VehsInfo[nveh][2]
					local old_nveh = (playerVehs[old_owner] and playerVehs[old_owner][hash]) or nil

					if old_nveh then 
						local __nveh = checkPersonalVehiclePlayerExist(old_owner,hash)
						VehsInfo[old_nveh] = nil 
						if __nveh then
							VehsInfo[__nveh] = {old_owner,hash} 
							playerVehs[old_owner][hash] = __nveh
						else
							playerVehs[old_owner][hash] = nil
						end
					end
					-- if playerVehs[old_owner] then playerVehs[old_owner][hash] = nil end
					if not playerVehs[nuser_id] then playerVehs[nuser_id] = {} end
					playerVehs[nuser_id][hash] = nveh
					VehsInfo[nveh] = {nuser_id,hash}
				else
					local hash = GetEntityModel(veh)
					if not playerVehs[nuser_id] then playerVehs[nuser_id] = {} end
					playerVehs[nuser_id][hash] = nveh
					VehsInfo[nveh] = {nuser_id,hash}
				end
			end
		end
	end
end

AddEventHandler('onResourceStart', function (resourceName)
	if GetCurrentResourceName() ~= resourceName then return end
	print("Qualquer duvida entre em contato com Wine Store - suporte free <3")
	print("https://discord.gg/PNZZnFXNG9")
	for _,veh in pairs(GetAllVehicles()) do
		if veh and DoesEntityExist(veh) then
			local plate = GetVehicleNumberPlateText(veh)
			if vRP.getUserByRegistration(plate) and veh and DoesEntityExist(veh) then
				local nveh = NetworkGetNetworkIdFromEntity(veh)
				local nuser_id = vRP.getUserByRegistration(plate)
				if nuser_id and DoesEntityExist(veh) then
					local hash = GetEntityModel(veh)
					if not playerVehs[nuser_id] then playerVehs[nuser_id] = {} end
					if not playerVehs[nuser_id][hash] then 
						playerVehs[nuser_id][hash] = nveh 
						VehsInfo[nveh] = {nuser_id,hash}
					end
				end
			end
		end
	end
end)

-- EXIT PLAYER GARAGES IF STOP RESOURCE
AddEventHandler('onResourceStop', function (resourceName)
	if GetCurrentResourceName() ~= resourceName then return end
	local userBucket = userBucket
	local bucketList = bucketList
	local vRPclient = vRPclient
	local SetTimeout = SetTimeout
	for source,_ in pairs(userBucket) do
		if bucketList[userBucket[source]] then
			local ped = GetPlayerPed(source)
			if ped and DoesEntityExist(ped) and IsPedAPlayer(ped) then
				SetPlayerRoutingBucket(source,0)
				if bucketList[userBucket[source]].escapeCoords then
					local x,y,z = bucketList[userBucket[source]].escapeCoords.x,bucketList[userBucket[source]].escapeCoords.y,bucketList[userBucket[source]].escapeCoords.z
					vRPclient.teleport(source,x,y,z)
				end
			end
		end
	end
end)

-- EXIT DELETE PLAYER RENDER VEHICLE IF STOP RESOURCE
AddEventHandler('onResourceStop', function (resourceName)
	if GetCurrentResourceName() ~= resourceName then return end
	local userBucket = userBucket
	local bucketList = bucketList
	local vRPclient = vRPclient
	for source,_ in pairs(userBucket) do
		if bucketList[userBucket[source]] and bucketList[userBucket[source]].ents then
			for nveh,_ in pairs(bucketList[userBucket[source]].ents) do
				local veh = NetworkGetEntityFromNetworkId(nveh)
				if DoesEntityExist(veh) then DeleteEntity(veh) end
			end
		end
	end
end)

AddEventHandler('vRP:playerLeave', function (user_id,source)
	local source = source
	if userBucket[source] and type(bucketList[userBucket[source]].escapeCoords) ~= nil then
		SetTimeout(10000,function()
			local data = vRP.getUData(user_id,"vRP:datatable")
			data = json.decode(data)
			if data and data.position then
				data.position = {x=bucketList[userBucket[source]].escapeCoords.x,y=bucketList[userBucket[source]].escapeCoords.y,z=bucketList[userBucket[source]].escapeCoords.z}
				vRP.setUData(user_id,"vRP:datatable",json.encode(data))
			end
		end)
		if bucketList[userBucket[source]].ents then
			for nveh,_ in pairs(bucketList[userBucket[source]].ents) do
				local veh = NetworkGetEntityFromNetworkId(nveh)
				if DoesEntityExist(veh) then DeleteEntity(veh) end
			end
		end
	end
end)

function DNext.deleteVehicleSync(vnet)
	if vnet and NetworkGetEntityFromNetworkId(vnet) then
		local veh = NetworkGetEntityFromNetworkId(vnet)
		if DoesEntityExist(veh) then DeleteEntity(veh) end
	end
end

function DNext.SetVehicleInGarage(vehid,garageId,NomeDoCarro)
	local source = source
	-- --print(vehid)
	if VehsInfo[vehid] and garageId then
		local user_id,vehname = VehsInfo[vehid][1],vRPclient.getVehicleNameFromHash(source,VehsInfo[vehid][2])
		-- --print(NomeDoCarro)
		local row = vRP.query("wine_garagem/get_vehicle",{ user_id = parseInt(user_id), vehicle = NomeDoCarro })
		if row[1] ~= nil then
		--	--print(NomeDoCarro)
			vRP.execute("wine_garagem/update_vehicles_lastGarages",{ user_id = parseInt(user_id), vehicle = tostring(NomeDoCarro), garageId = garageId })
		end
	end
end

vRP._prepare("wine_garagem/set_update_vehicles","UPDATE vrp_user_vehicles SET engine = @engine, body = @body, fuel = @fuel WHERE user_id = @user_id AND vehicle = @vehicle")
function DNext.tryDelete(vehid,vehengine,vehbody,vehfuel)
	if vehlist[vehid] and vehid ~= 0 then
		local user_id = vehlist[vehid][1]
		local vehname = vehlist[vehid][2]
		local player = vRP.getUserSource(user_id)
		if player then
			vCLIENT.syncNameDelete(player,vehname)
		end

		if vehengine <= 100 then
			vehengine = 100
		end

		if vehbody <= 100 then
			vehbody = 100
		end

		if vehfuel >= 100 then
			vehfuel = 100
		end

		local vehicle = vRP.query("wine_garagem/get_vehicles",{ user_id = parseInt(user_id), vehicle = vehname })
		if vehicle[1] ~= nil then
			vRP.execute("wine_garagem/set_update_vehicles",{ user_id = parseInt(user_id), vehicle = vehname, engine = parseInt(vehengine), body = parseInt(vehbody), fuel = parseInt(vehfuel) })
		end
	end
	vCLIENT.syncVehicle(-1,vehid)
end

function DNext.tryDeletes(vehid,vehengine,vehbody,vehfuel,vehPlate,vehDoors,vehWindows,vehTyres,bydv,garageId,NameCarro)
	local source = source
	----print(NameCarro)
	----print(json.encode(VehsInfo[vehid]))
	if VehsInfo[vehid] then
		-- --print('foi 1')
		local user_id,vehname = VehsInfo[vehid][1],vRPclient.getVehicleNameFromHash(source,VehsInfo[vehid][2])
		if parseInt(vehengine) <= 100 then vehengine = 100 end
		if parseInt(vehbody) <= 100 then vehbody = 100 end
		if parseInt(vehfuel) >= 100 then vehfuel = 100 end
		if parseInt(vehfuel) <= 5 then vehfuel = 5 end
	
		local row = vRP.query("wine_garagem/get_vehicle",{ user_id = parseInt(user_id), vehicle = NameCarro })
		----print(json.encode(NameCarro))
		if row[1] ~= nil then
		--	--print(garageId)
			if garageId then
				vRP.execute("wine_garagem/update_vehicles_withGarage",{ garageId = garageId, user_id = parseInt(user_id), vehicle = tostring(NameCarro), engine = parseInt(vehengine), body = parseInt(vehbody), fuel = parseInt(vehfuel), doors = json.encode(vehDoors), windows = json.encode(vehWindows), tyres = json.encode(vehTyres) })
			else
				vRP.execute("wine_garagem/update_vehicles",{ user_id = parseInt(user_id), vehicle = tostring(NameCarro), engine = parseInt(vehengine), body = parseInt(vehbody), fuel = parseInt(vehfuel), doors = json.encode(vehDoors), windows = json.encode(vehWindows), tyres = json.encode(vehTyres) })
			end

			if VehsInfo[vehid] then
				local hash = VehsInfo[vehid][2]
				if playerVehs[user_id] and playerVehs[user_id][hash] then 
					playerVehs[user_id][hash] = nil 
					if CountTable(playerVehs[user_id]) == 0 then 
						playerVehs[user_id] = nil 
					end
				end
			end
		end
		VehsInfo[vehid] = nil
		DNext.deleteVehicleSync(vehid)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end

RegisterNetEvent('trydeleteveh32569800')
AddEventHandler('trydeleteveh32569800',function(vnet)
	local ent = NetworkGetEntityFromNetworkId(vnet)
	if ent and DoesEntityExist(ent) then
		local source = NetworkGetEntityOwner(ent)
		TriggerClientEvent('_handle:4sa4h12',source,vnet)
	end
end)


--#####################################################

local trydoors = {}

RegisterServerEvent("setPlateEveryone")
AddEventHandler("setPlateEveryone",function(placa)
	trydoors[placa] = true
end)

--#####################################################
--#[ COMANDOS ]########################################

RegisterCommand(Config['Comandos'].commandCar,function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		local identity = vRP.getUserIdentity(user_id)
		if vRP.hasPermission(user_id,Config['Comandos'].permCar) then
			if args[1] then
				TriggerClientEvent("wine_garagem:spawn",source,args[1],identity.registration)
				TriggerEvent("setPlateEveryone",identity.registration)
				TriggerEvent("setPlatePlayers",identity.registration,user_id)
				PerformHttpRequest(Config['Comandos'].webhookCar, function(err, text, headers) end, 'POST', json.encode({
					embeds = {
						{ 	------------------------------------------------------------
							title = "LOG DE SPAWN DE CARRO :\n⠀",
							thumbnail = {
							url = Config.LogoServidor
							}, 
							fields = {
								{ 
									name = "**[ STAFF ]**", 
									value = " *PASSAPORTE :*  **"..user_id.."**"
								},
								{
									name = "**DEU O COMANDO** /"..Config['Comandos'].commandCar.."** E PEGOU UM : **",
									value = " "..args[1].." "
								}
							}, 
							footer = { 
								text = Config.NomeServidor..os.date("%d/%m/%Y |: %H:%M:%S"), 
								icon_url = Config.LogoServidor
							},
							color = 16431885 
						}
					}
				}), { ['Content-Type'] = 'application/json' })
			end
		end
	end
end)

RegisterCommand(Config['Comandos'].commandDv,function(source,args,rawCommand) 
	if Autenticado_01022016_wine_garagem then
		local user_id = vRP.getUserId(source)
		if vRP.hasPermission(user_id,Config['Comandos'].permDv) then
			local vehicle = vRPclient.getNearestVehicle(source,7)
			if vehicle then
				
				vCLIENT.deleteVehicle(source,vehicle)
				PerformHttpRequest(Config['Comandos'].webhookDv, function(err, text, headers) end, 'POST', json.encode({
					embeds = {
						{ 	------------------------------------------------------------
							title = "LOG DE DELETAR O CARRO :\n⠀",
							thumbnail = {
							url = Config.LogoServidor
							}, 
							fields = {
								{ 
									name = "**[ STAFF ]**", 
									value = " *PASSAPORTE :*  **"..user_id.."**"
								},
								{
									name = "**DEU O COMANDO /**"..Config['Comandos'].commandDv,
									value = "  "
								}
							}, 
							footer = { 
								text = Config.NomeServidor..os.date("%d/%m/%Y |: %H:%M:%S"), 
								icon_url = Config.LogoServidor
							},
							color = 16431885 
						}
					}
				}), { ['Content-Type'] = 'application/json' })
			end
		end
	end
end)
RegisterCommand(Config['Comandos'].commandDvall,function(source,args,rawCommand) 
	if Autenticado_01022016_wine_garagem then
		local user_id = vRP.getUserId(source)
		if vRP.hasPermission(user_id,Config['Comandos'].permDvall) then
			if tonumber(args[1]) then
				local vehicles = vRPclient.getNearestVehicles(source,tonumber(args[1]))
					for k,v in pairs(vehicles) do
						vCLIENT.deleteVehicle(source,k)
					end
				TriggerClientEvent('Notify',source, 'sucesso', '<b>Você deletou '.. tablelen(vehicles) ..'x veículos')
				PerformHttpRequest(Config['Comandos'].webhookDv, function(err, text, headers) end, 'POST', json.encode({
					embeds = {
						{ 	------------------------------------------------------------
							title = "LOG DE DELETAR VEICULOS :\n⠀",
							thumbnail = {
							url = Config.LogoServidor
							}, 
							fields = {
								{ 
									name = "**[ STAFF ]**", 
									value = " *PASSAPORTE :*  **"..user_id.."**"
								},
								{
									name = "**DEU O COMANDO /**"..Config['Comandos'].commandDvall,
									value = "  "
								}
							}, 
							footer = { 
								text = Config.NomeServidor..os.date("%d/%m/%Y |: %H:%M:%S"), 
								icon_url = Config.LogoServidor
							},
							color = 16431885 
						}
					}
				}), { ['Content-Type'] = 'application/json' })
			else
				TriggerClientEvent('Notify',source, 'negado', 'Comando dado de forma incorreta, use a estrutura /dvall [raio]')
			end
		end
	end
end)

RegisterCommand(Config['Comandos'].commandFix,function(source,args,rawCommand)
	if Autenticado_01022016_wine_garagem then
		local user_id = vRP.getUserId(source)
		local vehicle = vRPclient.getNearestVehicle(source,11)
		if vehicle then
			if vRP.hasPermission(user_id,Config['Comandos'].permFix) then
				TriggerClientEvent('reparar',source)
				PerformHttpRequest(Config['Comandos'].webhookFix, function(err, text, headers) end, 'POST', json.encode({
					embeds = {
						{ 	------------------------------------------------------------
							title = "LOG DE FIXAR CARRO :\n⠀",
							thumbnail = {
							url = Config.LogoServidor
							}, 
							fields = {
								{ 
									name = "**[ STAFF ]**", 
									value = " *PASSAPORTE :*  **"..user_id.."**"
								},
								{
									name = "**DEU O COMANDO /**"..Config['Comandos'].commandFix,
									value = "  "
								}
							}, 
							footer = { 
								text = Config.NomeServidor..os.date("%d/%m/%Y |: %H:%M:%S"), 
								icon_url = Config.LogoServidor
							},
							color = 16431885 
						}
					}
				}), { ['Content-Type'] = 'application/json' })
			end
		end
	end
end)
RegisterServerEvent("tryreparar")
AddEventHandler("tryreparar",function(nveh)
	TriggerClientEvent("syncreparar",-1,nveh)
end)
RegisterCommand(Config['Comandos'].commandVehs,function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
 	if user_id then
        local source = vRP.getUserSource(user_id)
		if args1 == "transferir" and parseInt(nuser_id) > 0 then
			local myvehicles = vRP.query("wine_garagem/get_vehicle",{ user_id = parseInt(user_id), vehicle = tostring(vehicle) })
			if myvehicles[1] then
				local identity = vRP.getUserIdentity(parseInt(nuser_id))
				if vRP.request(source,"Deseja transferir o veículo <b>"..vRP.vehicleName(tostring(vehicle)).."</b> para <b>"..identity.name.."</b>?",30) then
					local vehicle = vRP.query("wine_garagem/get_vehicle",{ user_id = parseInt(nuser_id), vehicle = tostring(vehicle) })
					if vehicle[1] then
						TriggerClientEvent("Notify",source,"negado","<b>"..identity.name.." "..identity.name2.."</b> já possui este modelo de veículo.",5000)
					else
                        vRP.execute("wine_garagem/move_vehicle",{ user_id = parseInt(user_id), nuser_id = parseInt(nuser_id), vehicle = tostring(vehicle) })
						
                        local custom = InfoTuning(user_id,vehicle)
						local custom2 = json.decode(custom) or {}
						if custom and custom2 ~= nil then
							vRP.setSData("custom:u"..parseInt(nuser_id).."veh_"..tostring(vehicle),json.encode(custom2))
							vRP.execute("vRP/rem_srv_data",{ dkey = "custom:u"..parseInt(user_id).."veh_"..tostring(vehicle) })
						end

						local chest = vRP.getSData("chest:u"..parseInt(user_id).."veh_"..tostring(vehicle))
						local chest2 = json.decode(chest) or {}
						if chest and chest2 ~= nil then
							vRP.setSData("chest:u"..parseInt(nuser_id).."veh_"..tostring(vehicle),json.encode(chest2))
							vRP.execute("vRP/rem_srv_data",{ dkey = "chest:u"..parseInt(user_id).."veh_"..tostring(vehicle) })
						end

						TriggerClientEvent("Notify",source,"sucesso","Transferência concluída com sucesso.",5000)
						PerformHttpRequest(Config['Comandos'].webhookVehs, function(err, text, headers) end, 'POST', json.encode({
							embeds = {
								{ 	------------------------------------------------------------
									title = "LOG DE COMANDO PARA TRANSFERIR CARRO :\n⠀",
									thumbnail = {
									url = Config.LogoServidor
									}, 
									fields = {
										{ 
											name = "**[ TRANSFERENCIA DE CARRO ]**", 
											value = " *PASSAPORTE :*  **"..user_id.."**"
										},
										{
											name = "*transferiu o : *"..vRP.vehicleName(tostring(vehicle)).."* para o *",
											value =  " *PASSAPORTE :*  **"..nuser_id.."**"
										}
									}, 
									footer = { 
										text = Config.NomeServidor..os.date("%d/%m/%Y |: %H:%M:%S"), 
										icon_url = Config.LogoServidor
									},
									color = 16431885 
								}
							}
						}), { ['Content-Type'] = 'application/json' })
					end
				end
			end
		else
			local vehicle = vRP.query("wine_garagem/get_vehicles",{ user_id = parseInt(user_id) })
			for k,v in ipairs(vehicle) do
				TriggerClientEvent("Notify",source,"importante","<b>Modelo:</b> "..v.vehicle.." ( "..v.vehicle.." )",20000)
			end
		end
    end
end)

--#####################
--#[SISTEMA DE TRANCA]#

function DNext.vehicleLock()
	if Autenticado_01022016_wine_garagem then
		local source = source
		local user_id = vRP.getUserId(source)
		if user_id then
			local vehicle,vnetid,placa,vname,lock,banned = vRPclient.vehList(source,7)
			if vehicle and placa then
				local placa_user_id = vRP.getUserByRegistration(placa)
				if user_id == placa_user_id then
					vCLIENT.vehicleClientLock(-1,vnetid,lock)
					TriggerClientEvent("vrp_sound:source",source,'lock',0.5)
					vRPclient.playAnim(source,true,{{"anim@mp_player_intmenu@key_fob@","fob_click"}},false)
					if lock == 1 then
						TriggerClientEvent("Notify",source,"importante","Veículo trancado com sucesso.",8000)
					else
						TriggerClientEvent("Notify",source,"importante","Veículo destrancado com sucesso.",8000)
					end
				end
			end
		end
	end
end


RegisterServerEvent("tryreparar")
AddEventHandler("tryreparar",function(nveh)
	local source = source
	local vehicle,vnetid,placa,vname,lock,banned,work = vRPclient.vehList(source,3)
	if vehicle and placa then
		local puser_id = vRP.getUserByRegistration(placa)
		if puser_id then
			local vehicle = vRP.query("wine_garagem/get_vehicles",{ user_id = parseInt(puser_id), vehicle = vname })
			if vehicle[1] then
				if parseInt(vehicle[1].detido) == 1 then
					TriggerClientEvent("Notify",source,"negado","Veículo desmanchado.",8000)
				else
					TriggerClientEvent("wine_garagem:repairVehicle",-1,nveh)
				end
			else 
				TriggerClientEvent("wine_garagem:repairVehicle",-1,nveh)
			end	
		end
	else 
		TriggerClientEvent("wine_garagem:repairVehicle",-1,nveh)
	end
end)


