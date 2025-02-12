Config = {
    settings = {
        -- Development mode.
        debug = false,

        -- Choose what framework you are using.
        -- Options: "esx", "auto"
        framework = "auto",

        -- If you want to use webhook logs to log when players purchase and sell their storages.
        webhook = {
            useWebhook = true, -- Set to "true/false" if you want to use.
            webhook = "https://discord.com/api/webhooks/1339059866475565127/6dqsZCEH75n7gHuw4JfJp86Y3LtnuVRedhrxgHgM1vvhKpDl2GZP-M0dEQpf-MiJZ8Xm" -- The webhook link.
        },

        -- Choose what notification type you want to use.
        notification = {
            type = "ox", -- Options: "esx", "ox"
            title = "Storage" -- For ox notification.
        }
    },

    -- Configuration for the ped.
    ped = { -- Ped list can be found in: https://docs.fivem.net/docs/game-references/ped-models/
        model = "a_m_m_business_01", -- The model of the ped.
        coords = vec4(-61.4981, -1218.2451, 28.7019, 269.1013), -- The position of the ped.
    },

    -- Configuration for the storage system.
    storageSystem = {
        price = 1000, -- The price to purchase an storage unit.
        paymentMethod = "bank", -- Options: "bank", "cash"
        slots = 20, -- How many slots the storage unit will have.
        weight = 10000,

        adminCanDelete = true, -- Enable or disable that admins can delete players storage.
        deleteCommand = "deletestorage", -- The command to delete an storage.
        group = "admin", -- What group permission you have to be to execute the delete command.
        
        openStorageCoords = vec3(-61.7119, -1205.2439, 28.1573), -- The position for the 3d text.
        openStorageKey = 38,
        openStorageText = "~g~[E]~w~ Open your storage unit"
    },

    -- Configure the strings under here.
    strings = {
        notification = {
            boughtStorage = "Congratulations! You've bought an storage unit. Go around and find your storage unit.",
            notEnoughtMoney = "You don't have enough money to buy an storage unit.",
            alreadyHave = "You can't buy an new storage unit. You already have one!",
            dontHaveStorageUnit = "You can't open an storage unit because you don't have any. Go buy yourself one!",
            error = "An error occured while you tried to puchase an storage unit.",

            noStorageUnit = "You don't have an storage unit to sell. Instead of selling, buy one!",
            soldStorageUnit = "You've sold your storage unit.",

            specifyStorageId = "Please specify an storage ID.",
            deletedStorage = "You've deleted the storage unit with ID: %s", -- %s is the storage ID
            notFindStorageUnit = "Could not find an storage unit with ID: %s", -- %s is the storage ID

            noPermission = "You don't have permission to execute this command."
        },

        menu = {
            title = "Storage Menu",
            storageTitle = "Your Storage Unit",

            optionPurchase = {
                title = "Purchase Storage",
                description = "Click here to purchase an storage unit."
            },
            optionSell = {
                title = "Sell Storage",
                description = "If you don't need your storage, sell it here."
            }
        },

        other = {
            targetLabel = "Open Storage Menu"
        }
    }
}