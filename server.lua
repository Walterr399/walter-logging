ESX = exports['es_extended']:getSharedObject()

function sendLog(message, src)
    local identifier = "Anon"
    if src and src ~= 0 then
        local xWalter = ESX.GetPlayerFromId(src)
        if xWalter then
            identifier = xWalter.identifier or "Anon"
        end        
    end

    local embed = {
        {
            ["color"] = Config.Color, 
            ["title"] = "Walter Logging - Example Roleplay",
            ["description"] = message, 
            ["footer"] = {
                ["text"] = "Speler: " .. identifier,
            },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }
    }    

    local payLoad = {
        embeds = embed
    }

    PerformHttpRequest(Config.Webhook, function(err, text, headers)
        if err ~= 200 then
            print("Error while sending webhook HTTP Error: " .. tostring(err))
        end
    end, "POST", json.encode(payLoad), { ["Content-Type"] = "application/json" })    
end

RegisterNetEvent('walter-logging:sendLog')
AddEventHandler('walter-logging:sendLog', function(message)
    local src = source
    sendLog(message, src)
end)

exports("sendLog", sendLog)

-- Example usage:
--[[ESX.RegisterCommand('setjob', 'admin', function(xPlayer, args, showError)
        if ESX.DoesJobExist(args.job, args.grade) then
            args.playerId.setJob(args.job, args.grade)
            exports['walter-logging']:sendLog(string.format(
                "Admin %s [%s] set job for %s [%s] to %s (Grade: %d)",
                xPlayer.getName(), xPlayer.identifier,
                args.playerId.getName(), args.playerId.identifier,
                args.job, args.grade
            ))
        else
            showError(_U('command_setjob_invalid'))
        end
    end, true, {help = _U('command_setjob'), validate = true, arguments = {
        {name = 'playerId', help = _U('commandgeneric_playerid'), type = 'player'},
        {name = 'job', help = _U('command_setjob_job'), type = 'string'},
        {name = 'grade', help = _U('command_setjob_grade'), type = 'number'}
    }})]]