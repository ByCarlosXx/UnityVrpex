local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
fclient = Tunnel.getInterface("nation_tattoos")
func = {}
Tunnel.bindInterface("nation_tattoos", func)

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
    return not permission or vRP.hasPermission(user_id, permission)
end

function func.saveChar(t)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local char = getUserChar(user_id)
        char.tattoos, char.overlay = t.tattoos, t.overlay
        vRP._setUData(user_id, "nation_char", json.encode(char,{indent=false}))
    end
end

function func.tryPay(value)
    local source = source
    local user_id = vRP.getUserId(source)
    if value >= 0 then
        if vRP.tryFullPayment(user_id, value) or value == 0 then
            return true
        end
    end
    return false
end

function func.getTattoos()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local char = getUserChar(user_id)
        return (char.tattoos or {}), (char.overlay or 0)
    end
    return false
end

function getUserChar(user_id)
    local data = vRP.getUData(user_id, "nation_char")
    if data and data ~= "" then
        local char = json.decode(data)
        if char then
            return char
        end
    end
    return {}
end