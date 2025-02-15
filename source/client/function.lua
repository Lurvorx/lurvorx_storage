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
    print("[ERROR] Could not find the framework provided, please check the config file.")
end

-- NOTIFICATION
function Notify(source, text, type)
    if cfg.settings.notification.type == "esx" then
        ESX.ShowNotification(text, type, 5 * 1000)
    elseif cfg.settings.notification.type == "ox" then
        lib.notify({
            title = cfg.settings.notification.title,
            description = text,
            type = type
        })
    else
        print("[ERROR] Could not find the notification provided, please check the config file.")
    end
end

-- DRAW3DTEXT
function Draw3DText(x, y, z, scl_factor, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov * scl_factor
    if onScreen then
        SetTextScale(0.0, scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end