local cfg = Config
local cfgstr = Config.strings
local ox_inventory = exports.ox_inventory

ESX.RegisterServerCallback("lurvorx_storage:createStorage", function(source, cb)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local playerName = GetPlayerName(src)
    local playerIdentifier = xPlayer.getIdentifier()
    local storageId = ("storage_%s"):format(playerIdentifier)

    local playerAccMoney = nil
    local playerMoney = nil

    if (cfg.storageSystem.paymentMethod == "bank") then
        playerAccMoney = xPlayer.getAccount("bank")
    elseif (cfg.storageSystem.paymentMethod == "cash") then
        playerMoney = xPlayer.getMoney()
    end

    local storageData = {
        slots = cfg.storageSystem.slots,
        weight = cfg.storageSystem.weight
    }

    local storageExists = MySQL.scalar.await("SELECT COUNT(*) FROM ox_inventory WHERE name = ?", {storageId})

    if (storageExists > 0) then
        cb(false, cfgstr.notification.alreadyHave)
        return
    end

    if (playerMoney ~= nil) and (playerMoney >= cfg.storageSystem.price) then
        xPlayer.removeMoney(cfg.storageSystem.price)
        MySQL.insert("INSERT INTO ox_inventory (name, owner, data) VALUES (?, ?, ?)",
        {storageId, playerIdentifier, json.encode(storageData)}
        )
        
        cb(true, cfgstr.notification.boughtStorage, storageId)
        SendLog(source, ("**%s** have purchased an storage unit.\n**STORAGE ID:** %s"):format(playerName, storageId))
    elseif (playerAccMoney ~= nil) and (playerAccMoney.money >= cfg.storageSystem.price) then
        xPlayer.removeAccountMoney("bank", cfg.storageSystem.price)
        MySQL.insert("INSERT INTO ox_inventory (name, owner, data) VALUES (?, ?, ?)",
        {storageId, playerIdentifier, json.encode(storageData)}
        )
        
        cb(true, cfgstr.notification.boughtStorage, storageId)
        SendLog(source, ("**%s** have purchased an storage unit.\n**STORAGE ID:** %s"):format(playerName, storageId))
    elseif (playerMoney < cfg.storageSystem.price) or (playerAccMoney.money < cfg.storageSystem.price) then
        cb(false, cfgstr.notification.notEnoughtMoney)
    end
end)

ESX.RegisterServerCallback("lurvorx_storage:removeStorage", function(source, cb)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local playerName = GetPlayerName(src)
    local playerIdentifier = xPlayer.getIdentifier()
    local storageId = ("storage_%s"):format(playerIdentifier)

    local storageExists = MySQL.scalar.await("SELECT COUNT(*) FROM ox_inventory WHERE name = ?", {storageId})

    if (storageExists == 0) then
        cb(false, cfgstr.notification.noStorageUnit, storageId)
        return
    end

    MySQL.update("DELETE FROM ox_inventory WHERE name = ?", {storageId})
    cb(true, cfgstr.notification.soldStorageUnit, storageId)
    SendLog(source, ("**%s** have sold an storage unit.\n**STORAGE ID:** %s"):format(playerName, storageId))
end)

ESX.RegisterServerCallback("lurvorx_storage:deleteStorage", function(source, cb, storageId)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local playerGroup = xPlayer.getGroup()

    if (playerGroup == cfg.storageSystem.group) then
        local storageExists = MySQL.scalar.await("SELECT COUNT(*) FROM ox_inventory WHERE name = ?", {storageId})

        if (storageExists == 0) then
            cb(false, (cfgstr.notification.notFindStorageUnit):format(storageId), storageId)
            return
        end

        MySQL.update("DELETE FROM ox_inventory WHERE name = ?", {storageId})
    
        cb(true, (cfgstr.notification.deletedStorage):format(storageId), storageId)
        SendLog(source, ("Admin **%s** have deleted an storage unit.\n**STORAGE ID:** %s"):format(playerName, storageId))
    else
        cb(false, cfgstr.notification.noPermission)
    end
end)

ESX.RegisterServerCallback("lurvorx_storage:openStorage", function(source, cb, storageId)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local playerIdentifier = xPlayer.getIdentifier()
    local storageId = ("storage_%s"):format(playerIdentifier)

    local storageExists = MySQL.scalar.await("SELECT COUNT(*) FROM ox_inventory WHERE name = ?", {storageId})

    if (storageExists == 0) then
        cb(false)
        return
    end

    exports.ox_inventory:RegisterStash(storageId, cfgstr.menu.storageTitle, cfg.storageSystem.slots, cfg.storageSystem.weight)
    cb(true, storageId)
end)