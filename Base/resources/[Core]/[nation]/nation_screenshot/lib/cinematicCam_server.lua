--------------------------------------------------
---------------------- EVENTS --------------------
--------------------------------------------------

RegisterServerEvent('CinematicCam:requestPermissions')
AddEventHandler('CinematicCam:requestPermissions', function()
    local user_id = vRP.getUserId(source)
    local isWhitelisted = vRP.hasPermission(user_id,"admin.permissao")
	TriggerClientEvent('CinematicCam:receivePermissions', source, isWhitelisted)
end)
