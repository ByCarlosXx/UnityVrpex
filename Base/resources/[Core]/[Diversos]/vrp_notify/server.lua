local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

RegisterCommand('rr', function(source, args)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    if vRP.hasPermission(user_id, "admin.permissao") then
        if args[1] then
            TriggerClientEvent("Notify", -1, "rr", "Nossa Equipe esteve trabalhando em <b>correções e atualizações</b>. Foi agendado o reinício do servidor daqui a <b>" .. args[1] .. " horas</b>. Desloguem para evitar perdas.")
            Wait(600000)
            -- Kick os jogadores
            local users = vRP.getUsers()
            for k, v in pairs(users) do
                local id = vRP.getUserSource(parseInt(k))
                if id then
                    vRP.kick(id, "Você foi kickado, nossa equipe esteve trabalhando em atualizações.")
                end
            end
            os.exit()
        end
    end
end)

RegisterCommand('anuncio', function(source, args)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    if vRP.hasPermission(user_id, "admin.permissao") then
        local mensagem = vRP.prompt(source, "Mensagem:", "")
        if mensagem then
            TriggerClientEvent("Notify", -1, "anuncio", "Mensagem enviada por administrador " .. identity.name .. " -» <b>" .. mensagem .. "</b>. ")
        end
    end
end)
