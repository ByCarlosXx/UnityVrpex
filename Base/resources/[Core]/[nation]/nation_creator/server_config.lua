local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
fclient = Tunnel.getInterface("nation_creator")
func = {}
Tunnel.bindInterface("nation_creator", func)


multiCharacter = true

---------------------------------------------------------------------------
-----------------------VERIFICAÇÃO DE PERMISSÃO--------------------------
---------------------------------------------------------------------------

if multiCharacter then
    vRP._prepare("nation_creator/createAgeColumn","ALTER TABLE vrp_user_identities ADD IF NOT EXISTS age INT(11) NOT NULL DEFAULT 20")
    vRP._prepare("nation_creator/update_user_first_spawn","UPDATE vrp_user_identities SET firstname = @firstname, name = @name, age = @age WHERE user_id = @user_id")
    vRP._prepare("nation_creator/create_characters","INSERT INTO vrp_users(steam) VALUES(@steam)")
    vRP._prepare("nation_creator/remove_characters","UPDATE vrp_users SET deleted = 1 WHERE id = @id")
    vRP._prepare("nation_creator/get_characters","SELECT * FROM vrp_users WHERE steam = @steam and deleted = 0")
    vRP._prepare("nation_creator/get_character","SELECT * FROM vrp_users WHERE steam = @steam and deleted = 0 and id = @user_id")
    vRP._prepare("nation_creator/get_charinfo","SELECT * FROM vrp_user_identities WHERE user_id = @user_id")
    CreateThread(function() vRP.execute("nation_creator/createAgeColumn") end) -- criar coluna idade na db
else
    vRP._prepare("nation_creator/update_user_first_spawn","UPDATE vrp_user_identities SET firstname = @firstname, name = @name, age = @age WHERE user_id = @user_id")
end


function func.checkPermission(permission, src)
    local source = src or source
    local user_id = vRP.getUserId(source)
    if type(permission) == "table" then
        for i, perm in pairs(permission) do
            if vRP.hasPermission(user_id, perm) then
                return true
            end
        end
        return false
    end
    return vRP.hasPermission(user_id, permission)
end


function func.saveChar(name, lastName, age, char, id)
    local source = source
    local user_id = id or vRP.getUserId(source)
    if char then
        vRP.setUData(user_id, "nation_char", json.encode(char,{indent=false}))
    end
    if name and lastName and age then
        vRP.execute("nation_creator/update_user_first_spawn",{ user_id = user_id, firstname = lastName, name = name, age = age })
    end
    TriggerClientEvent("nation_barbershop:init", source, char)
    vRP._updateSelectSkin(user_id, GetEntityModel(GetPlayerPed(source)))
    return true
end


function getUserChar(user_id, source, nation)
    local char
    local data = vRP.getUData(user_id, "nation_char")
    if data and data ~= "" then
        char = json.decode(data)
        char.gender = getGender(user_id) or char.gender
    elseif not nation then
        data = vRP.getUData(user_id, "currentCharacterMode")
        if data and data ~= "" then 
            local gender = "male"
            local char = json.decode(data)
            if char and char.gender and char.gender == 1 then
                gender = "female"
            else 
                gender = getGender(user_id) or "male"
            end
            char = fclient.setOldChar(source, char, getUserClothes(user_id), gender, user_id)
        end
    end
    return char
end


local userlogin = {}
function playerSpawn(user_id, source, first_spawn)
    if first_spawn then
        print ("2")
        vRP.addUserGroup(1,"owner")
        Wait(1000)
		processSpawnController(source,getUserChar(user_id, source),user_id)
	end
end

AddEventHandler("vRP:playerSpawn",playerSpawn)

function processSpawnController(source,char,user_id)
    getUserLastPosition(source, user_id)
	local source = source
	if char then
		if not userlogin[user_id] then
			userlogin[user_id] = true
			fclient._spawnPlayer(source,false)
		else
			fclient._spawnPlayer(source,true)
		end
        fclient.setPlayerChar(source, char, true)
        TriggerClientEvent("nation_barbershop:init", source, char)
        setPlayerTattoos(source, user_id)
        fclient._setClothing(source, getUserClothes(user_id))
	else
        userlogin[user_id] = true
        local data = vRP.getUData(user_id, "currentCharacterMode")
        if data and data ~= "" then 
            local gender = "male"
            local char = json.decode(data)
            if char and char.gender and char.gender == 1 then
                gender = "female"
            else 
                gender = getGender(user_id)
            end
            fclient._spawnPlayer(source,false)
            fclient._setOldChar(source, char, getUserClothes(user_id), gender, user_id)
        else
		    fclient._startCreator(source)
        end
	end
end




function setPlayerTattoos(source, user_id)
    TriggerClientEvent("forcereloadtattos", source)
end


function func.setPlayerTattoos(id)
    local source = source
    local user_id = id or vRP.getUserId(source)
    if user_id then
        print ("3")
        setPlayerTattoos(source, user_id)
    end
end

function getUserLastPosition(source, user_id)
    local coords = {402.76,-996.28,-99.00}
    local datatable = vRP.getUserDataTable(user_id)
    if datatable and datatable.position then
        local p = datatable.position
        coords = { p.x, p.y, p.z }
    else
        local data = vRP.getUData(user_id, "Datatable")
        if data and data ~= "" then
            local p = json.decode(data).position
            coords = { p.x, p.y, p.z }
        end
    end
    fclient._setPlayerLastCoords(source, coords)
    return coords
end


function func.getUserLastPosition()
    local source = source
    local user_id = vRP.getUserId(source)
    getUserLastPosition(source, user_id)
end


function format(n)
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1.'):reverse())..right
end


function func.changeSession(session)
    local source = source
    SetPlayerRoutingBucket(source, session)
end

function func.updateLogin()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        userlogin[user_id] = true
        local char = getUserChar(user_id, source)
        if char then 
            TriggerClientEvent("nation_barbershop:init", source, char)
            setPlayerTattoos(source, user_id)
        end
    end
end



function func.getCharsInfo()
    local source = source
    local steam = getPlayerSteam(source)
    local data = vRP.query("nation_creator/get_characters",{ steam = steam })
    local info = { chars = {} }
    for k,v in ipairs(data) do
        local teste = vRP.query("nation_creator/get_charinfo",{ user_id = v.id })
        local bank = vRP.getBankMoney(v.id)
        local char = getUserChar(v.id, source) or {}
        local clothes = getUserClothes(v.id)
        local gender = "masculino"
        if char.gender and char.gender == "female" then
            gender = "feminino"
        elseif char.gender ~= "male" then
            gender = "outros"
        end
        info.chars[k] = {
            name = teste[1].name.." "..teste[1].firstname, age = teste[1].age.." anos", bank = "$ "..format(bank), clothes = clothes,
            registration = teste[1].registration, phone = teste[1].phone, user_id = v.id, id = "#"..v.id, gender = gender, char = char
        }
    end
    info.maxChars = getUserMaxChars(source) 
    return info
end

function getUserMaxChars(source)
    local steam = getPlayerSteam(source)
    local infos = vRP.getInfos(steam)
    if infos and infos[1] and infos[1].chars then
        return infos[1].chars -- máximo de chars para criar
    end
    return 1
end

function getUserClothes(user_id)
    local data = vRP.getUData(user_id, "Clothings")
    if data and data ~= "" then
        local clothes = json.decode(data)
        if clothes then
            return clothes
        end
    end
    data = vRP.getUData(user_id, "vRP:datatable")
    if data and data ~= "" then
        local datatable = json.decode(data)
        if datatable and datatable.customization then
            return datatable.customization
        end
    end
    local datatable = vRP.getUserDataTable(user_id) or {}
    return datatable.customization or {}
end

function getUserTattoos(user_id)
    local data = vRP.getUData(user_id,"vRP:tattoos")
    if data and data ~= '' then
       local custom = json.decode(data)  
       return custom or {}
    end
    data = vRP.getUData(user_id,"Tattoos")
    if data and data ~= '' then
       local custom = json.decode(data)  
       return custom or {}
    end
    return {}
end


function getGender(user_id)
    local datatable = vRP.getUserDataTable(user_id) or json.decode(vRP.getUData(user_id, "Datatable")) or {}
    if type(datatable) == "table" then
        local model = datatable.skin or datatable.customization
        if model then
            if type(model) == "table" then
                model = model.modelhash or model.model
            end
            if model == GetHashKey("mp_m_freemode_01") then
                return "male"
            elseif model == GetHashKey("mp_f_freemode_01") then
                return "female"
            else
                return model
            end
        end
    end
end

function func.getOverlay()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local char = getUserChar(user_id, source, true)
        if char and char.overlay then
            return char.overlay
        end
    end
    return 0
end




function func.playChar(info)
    local source = source
    local steam = getPlayerSteam(source)
    local data = vRP.query("nation_creator/get_character",{ steam = steam, user_id = info.user_id })
    if #data > 0 then
        TriggerEvent("baseModule:idLoaded",source,info.user_id,nil)
      --  playerSpawn(info.user_id, source, true)
    end
end


function func.tryDeleteChar(info)
    local source = source
    local steam = getPlayerSteam(source)
    local data = vRP.query("nation_creator/get_character",{ steam = steam, user_id = info.user_id })
    if #data > 0 then
        vRP._execute("nation_creator/remove_characters",{ id = info.user_id })
        return true, ""
    end
    return false, "error"
end

function func.tryCreateChar()
    local source = source
    local steam = getPlayerSteam(source)
    local data = vRP.query("nation_creator/get_characters",{ steam = steam })
    if #data < getUserMaxChars(source)  then -- limite de personagens
        vRP.execute("nation_creator/create_characters",{ steam = steam })
        local myChars = vRP.query("nation_creator/get_characters",{ steam = steam })
        local user_id = myChars[#myChars].id

        TriggerEvent("baseModule:idLoaded",source,user_id,"mp_m_freemode_01","Individuo","Indigente",20)
        return true
    end
end


function getPlayerSteam(source)
    local identifiers = GetPlayerIdentifiers(source)
	for k,v in ipairs(identifiers) do
		if string.sub(v,1,5) == "steam" then
			return v
		end
	end
end


RegisterCommand("char", function(source) -- setar as customizações dnv (tipo bvida)
    local user_id = vRP.getUserId(source)
    local char = getUserChar(user_id, source)
    if char then
        fclient._setPlayerChar(source, char, true)
        TriggerClientEvent("nation_barbershop:init", source, char)
        setPlayerTattoos(source, user_id)
        fclient._setClothing(source, getUserClothes(user_id))
    end
end)

RegisterCommand('resetchar',function(source, args) -- COMANDO DE ADMIN PARA RESETAR PERSONAGEM
    if func.checkPermission({"admin.permissao", "manager.permissao", "Admin"}, source) then
        if args[1] then 
            local id = tonumber(args[1])
            if id then
                local src = vRP.getUserSource(id)
                if src and vRP.request(source, "Deseja resetar o id "..id.." ?", 30) then
                    fclient._startCreator(src)
                end
            end
        elseif vRP.request(source, "Deseja resetar seu personagem ?", 30) then
            fclient._startCreator(source)
        end
    end
end)

RegisterCommand('spawn',function(source) -- COMANDO DE ADMIN PARA SIMULAR O SPAWN
    if func.checkPermission({"admin.permissao", "mod.permissao", "Admin"}, source) or not vRP.getUserId(source) then
        if multiCharacter then
            TriggerClientEvent("spawn:setupChars", source)
        else
            playerSpawn(vRP.getUserId(source), source, true)
        end
    end
end)







