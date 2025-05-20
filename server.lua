-- [[ FUNCTION ]] --
function sendLog(message, src)
    local fields = {}
    local footerText = "Anon"
    local Player = nil

    if src and src ~= 0 then
        Player = vx.framework.getPlayer(src)
        if not Player then
            return vx.print.error("vx_lib is not initialized or player could not be fetched.")
        end

        local identifiers = GetPlayerIdentifiers(src)
        local idMap = {}
        for _, id in pairs(identifiers) do
            local key, value = string.match(id, "([^:]+):(.+)")
            if key and value then
                idMap[key] = value
            end
        end

        if Config.LogOptions.ShowPlayerName then
            table.insert(fields, {
                name = "Name",
                value = GetPlayerName(src) or "N/A",
                inline = true
            })
        end

        if Config.LogOptions.ShowSteamID and idMap["steam"] then
            table.insert(fields, {
                name = "Steam ID",
                value = idMap["steam"],
                inline = true
            })
        end

        if Config.LogOptions.ShowLicense and idMap["license"] then
            table.insert(fields, {
                name = "License",
                value = idMap["license"],
                inline = true
            })
        end

        if Config.LogOptions.ShowIP then
            local ip = GetPlayerEndpoint(src)
            table.insert(fields, {
                name = "IP Address",
                value = ip or "N/A",
                inline = true
            })
        end

        if Config.LogOptions.ShowSource then
            table.insert(fields, {
                name = "Source ID",
                value = tostring(src),
                inline = true
            })
        end

        footerText = Player.identifier or "Unknown"
    end

    local embed = {{
        color = Config.Color,
        title = "Walter Logging - Github",
        description = message,
        fields = fields,
        footer = {
            text = footerText,
        },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }}

    PerformHttpRequest(Config.Webhook, function(err, text, headers)
        if err ~= 200 then
            return vx.print.error("Error sending webhook: " .. tostring(err))
        end
    end, "POST", json.encode({ embeds = embed }), {
        ["Content-Type"] = "application/json"
    })
end

-- [[ EXPORT ]] --
exports("sendLog", sendLog)