local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
fclient = Tunnel.getInterface("nation_screenshot")
func = {}
Tunnel.bindInterface("nation_screenshot", func)



---------------------------------------------------------------------------
-----------------------REQUEST DA SCREENSHOT--------------------------
---------------------------------------------------------------------------

function func.takeScreenshot(gender, key, component, data, texture)
    local source = source
    local fileName = 'nation_screenshot/'..gender..'/'..key..'/'..component..'.png'
    if texture then
        fileName = 'nation_screenshot/'..gender..'/'..key..'/'..component..'_'..texture..'.png'
    end
    exports['screenshot-basic']:requestClientScreenshot(source, {
        fileName = fileName,
        encoding = 'png',
        quality = 1.0,
        crop = {
            offsetX = data.offsetX,
            offsetY = data.offsetY,
            width = data.width,
            height = data.height
        }
        }, function(err, data)
            print('data', data, not err)
            fclient._requestScreenshot(source, gender, key, component, not err, texture or "")
        end
    )
end


---------------------------------------------------------------------------
-----------------------VERIFICAÇÃO DE PERMISSÃO--------------------------
---------------------------------------------------------------------------


function func.checkPermission(permission)
    local source = source
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


