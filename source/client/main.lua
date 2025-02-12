local cfg = Config
local cfgstr = Config.strings

local storagepPed = nil

Citizen.CreateThread(function()
    local textcrds = cfg.storageSystem.openStorageCoords
    local pedcrds = cfg.ped.coords
    RequestModel(cfg.ped.model)
    if (not HasModelLoaded(cfg.ped.model)) then
        Citizen.Wait(0)
    end

    storagePed = CreatePed(2, cfg.ped.model, pedcrds.x, pedcrds.y, pedcrds.z - 1, pedcrds.w, true, false)
    SetEntityInvincible(storagePed, true)
    SetBlockingOfNonTemporaryEvents(storagePed, true)
    FreezeEntityPosition(storagePed, true)

    if (storagePed ~= nil) then
        dbug(("Storage ped have loaded and spawned at coords: %s"):format(cfg.ped.coords))
    end

    exports.ox_target:addLocalEntity(storagePed, {
        {
            label = cfgstr.other.targetLabel,
            name = "open_storage_menu",
            icon = "fa-solid fa-warehouse",
            distance = 2,
            onSelect = function()
                TriggerEvent("lurvorx_storage:openMenu")
                dbug("Opened the storage menu.")
            end
        }
    })

    while true do
        local sleep = 1000
        local player = PlayerPedId()
        local playerDist = vec3(GetEntityCoords(player))
        local dist = #(playerDist - textcrds)

        if (dist < 2) then
            Draw3DText(textcrds.x, textcrds.y, textcrds.z, 0.5, cfg.storageSystem.openStorageText)
            if (IsControlJustPressed(0, cfg.storageSystem.openStorageKey)) then
                ESX.TriggerServerCallback("lurvorx_storage:openStorage", function(success, storageId)
                    if success then
                        exports.ox_inventory:openInventory("stash", storageId)
                        print(storageId)
                    else
                        Notify(source, cfgstr.notification.dontHaveStorageUnit, "error")
                    end
                end)
            end
            sleep = 0
        else
            sleep = 1000
        end
        Citizen.Wait(sleep)
    end
end)

RegisterNetEvent("lurvorx_storage:openMenu", function()
    lib.registerContext({
        id = "storage_menu",
        title = cfgstr.menu.title,
        options = {
            {
                title = cfgstr.menu.optionPurchase.title,
                description = cfgstr.menu.optionPurchase.description,
                icon = "fa-solid fa-warehouse",
                event = "lurvorx_storage:beginStorage"
            },
            {
                title = cfgstr.menu.optionSell.title,
                description = cfgstr.menu.optionSell.description,
                icon = "fa-solid fa-xmark",
                event = "lurvorx_storage:sellStorage"
            }
        }
    })

    lib.showContext("storage_menu")
end)

RegisterNetEvent("lurvorx_storage:beginStorage", function()
    ESX.TriggerServerCallback("lurvorx_storage:createStorage", function(success, notifyMessage, storageId)
        if success then
            Notify(source, notifyMessage, "success")
            dbug(("Player have purchased an storage unit with storage ID: %s"):format(storageId))
        else
            Notify(src, notifyMessage, "error")
            dbug("Player failed to purchase an storage unit.")
        end
    end)
end)

RegisterNetEvent("lurvorx_storage:sellStorage", function()
    ESX.TriggerServerCallback("lurvorx_storage:removeStorage", function(success, notifyMessage, storageId)
        if success then
            Notify(source, notifyMessage, "success")
            dbug(("Player sold an storage unit with storage ID: %s"):format(storageId))
        else
            Notify(source, notifyMessage, "error")
            dbug(("Player tried to sell an storage unit but failed. Storage ID: %s"):format(storageId))
        end
    end)
end)

if (cfg.storageSystem.adminCanDelete) then
    RegisterCommand(cfg.storageSystem.deleteCommand, function(source, args)
        local storageIdArgs = args[1]
    
        if (not storageIdArgs) then
            Notify(source, cfgstr.notification.specifyStorageId, "error")
            return
        end
        
        ESX.TriggerServerCallback("lurvorx_storage:deleteStorage", function(success, notifyMessage, storageId)
            if success then
                Notify(source, notifyMessage, "success")
                dbug(("Admin deleted an storage unit with storage ID: %s"):format(storageId))
            else
                Notify(source, notifyMessage, "error")
                dbug(("Player tried to delete an storage unit but failed. Storage ID: %s"):format(storageId))
            end
        end, storageIdArgs)
    end)
end

RegisterCommand("OpenStorage", function()
    exports.ox_inventory:openInventory("stash", 1)
    --exports.ox_inventory:openInventory('stash', 'society_police')
end)

AddEventHandler("onResourceStop", function()
    DeletePed(storagePed)
end)