ESX = exports['es_extended']:getSharedObject()

print("^2walter-logging started successfully! Created by: https://github.com/Walterr399^7")

--# Functon
function sendLog(message, src)
    local identifier = "Anon"
    if src and src ~= 0 then
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer then
            identifier = xPlayer.identifier
        end        
    end

    local embed = {
        {
            ["color"] = Config.Color, 
            ["title"] = "Walter Logging - Github",
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

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        print("^1walter-logging stopped. Thanks for using it! Created by: https://github.com/Walterr399^7")
    end
end)