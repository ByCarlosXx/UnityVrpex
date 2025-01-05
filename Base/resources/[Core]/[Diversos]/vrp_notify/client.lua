RegisterNetEvent("Notify")
AddEventHandler("Notify", function(type, string)
    SendNUIMessage({
        NotifyString = string,
        NotifyType = type
    })
end)

RegisterCommand('notify', function()
    TriggerEvent("Notify", "sucesso", "Você vai ser desconectado em <b>60 segundos</b>.")
    Wait(3000)
    TriggerEvent("Notify", "negado", "Você vai ser desconectado em <b>60 segundos</b>.")
    Wait(3000)
    TriggerEvent("Notify", "aviso", "Você vai ser desconectado em <b>60 segundos</b>.")
    Wait(3000)
    TriggerEvent("Notify", "importante", "Você vai ser desconectado em <b>60 segundos</b>.")
end)
