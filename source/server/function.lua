local cfg = Config

-- DEBUG
function dbug(dbug)
    if cfg.settings.debug then
        print("^5[DEBUG]^7 " .. dbug)
    end
end

-- FRAMEWORK
if cfg.settings.framework == "esx" then
    ESX = exports.es_extended:getSharedObject()
elseif cfg.settings.framework == "auto" then
    if (GetResourceState("es_extended") == "started") then
        ESX = exports.es_extended:getSharedObject()
    end
else
    print("^1[ERROR]^7 Could not find the framework provided, please check the config file.")
end

-- NOTIFICATION
function Notify(source, text, type)
    if cfg.settings.notification.type == "esx" then
        TriggerClientEvent("esx:showNotification", source, text, type, 5 * 1000)
    elseif cfg.settings.notification.type == "ox" then
        lib.notify({
            title = cfg.settings.notification.title,
            description = text,
            type = type
        })
    else
        print("^1[ERROR]^7 Could not find the notification provided, please check the config file.")
    end
end

-- SENDLOG
function SendLog(source, message)
    for k,v in pairs(GetPlayerIdentifiers(source)) do
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steamid = v
        elseif string.sub(v, 1, string.len("license:")) == "license:" then
            license = v
        elseif string.sub(v, 1, string.len("license2:")) == "license2:" then
            license2 = v
        elseif string.sub(v, 1, string.len("fivem:")) == "fivem:" then
            fivem = v
        elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            discord = v
        end
    end
    
    steamhex = steamid or "N/A"
    fivemlicense = license or "N/A"
    fivemlicense2 = license2 or "N/A"
    fivemid = fivem or "N/A"
    discordid = string.gsub(discord, "discord:", "") or "N/A"
    playerName = GetPlayerName(source)
    
    local dcLogMessage = "\n\n`👤` **PLAYER:** `" .. playerName .. "`\n`🔢` **SERVER ID:** `" .. source .. "`\n`💬` **DISCORD:** " .. "<@" .. discordid .. "> [||" .. discordid .. "||]" .. "\n`🎮` **STEAM HEX:** ||" .. steamhex .. "||\n`🎮` **FIVEM:** ||" .. fivemid .. "||\n`💿` **LICENSE:** ||" .. fivemlicense .. "||\n`📀` **LICENSE 2:** ||" .. fivemlicense2 .. "||"

    local embeds = {
        {
            ["type"] = 'rich',
            ["title"] = '`📦` STORAGE LOGS',
            ["description"] = message .. dcLogMessage,
            ["color"] = 3447003,
            ["footer"] = {
                ["text"] = "Lurvorx Scripts | " .. os.date(),
                ["icon_url"] = "https://r2.fivemanage.com/wzlj71mzMVF3Y2yG2tMKq/images/LurvorxScriptsLogga.png"
            }
        }
    }

    PerformHttpRequest(cfg.settings.webhook.webhook, function(err, text, headers) end, 'POST', json.encode({username = "Lurvorx Scripts", avatar_url = "https://r2.fivemanage.com/wzlj71mzMVF3Y2yG2tMKq/images/LurvorxScriptsLogga.png", embeds = embeds}), { ['Content-Type'] = 'application/json' })
end