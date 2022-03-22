local MODEM_TIMEOUT = {}

ESX.RegisterUsableItem(Config.ModemItemName, function(source)
    TriggerClientEvent("gcphone:modem_chooseCredentials", source)
end)

gcPhoneT.modem_createModem = function(label, password, coords)
    local player = source
    local xPlayer = ESX.GetPlayerFromId(player)

    if MODEM_TIMEOUT[player] == nil or not MODEM_TIMEOUT[player] then
        local day = 86400
        local days = day * Config.AddDaysOnRenewal
        local currentTime = os.time(os.date("!*t"))

        Reti.AddReteWifi(player, {
            label = label,
            password = password, 
            coords = coords,
            due_date = os.time(os.date('*t', currentTime)) + days
        }, function(ok)
            if ok then xPlayer.removeInventoryItem(Config.ModemItemName, 1) end
        end)

        MODEM_TIMEOUT[player] = true

        Citizen.CreateThreadNow(function()
            local cachedPlayer = player
    
            SetTimeout(Config.WaitBeforeCreatingAgaing * 1000, function()
                MODEM_TIMEOUT[cachedPlayer] = nil
            end)
        end)
    else
        showXNotification(xPlayer, translate("MODEM_CREATION_TIMEOUT_MESSAGE"):format(Config.WaitBeforeCreatingAgaing))
    end
end

gcPhoneT.modem_rinnovaModem = function()
    local player = source
    local xPlayer = ESX.GetPlayerFromId(player)

    if xPlayer.getAccount("bank").money >= Config.RenewModemPrice then
        MySQL.Async.fetchAll("SELECT * FROM phone_wifi_nets WHERE steam_id = @identifier", {
            ['@identifier'] = xPlayer.identifier
        }, function(result)
            if #result > 0 then
                local day = 86400
                local days = day * Config.AddDaysOnRenewal
                local new_date = os.time(os.date('*t', math.floor(result[1].due_date / 1000))) + days

                Reti.UpdateReteWifi(player, { due_date = os.date("%Y-%m-%d %H:%m:%S", new_date) }, "due_date")
                TriggerClientEvent("gcphone:modem_updateMenu", player)

                xPlayer.removeAccountMoney("bank", Config.RenewModemPrice)
            end
        end)
    else
        showXNotification(xPlayer, translate("MODEM_CREATION_NOT_ENOUGH_MONEY"))
    end
end

gcPhoneT.modem_cambiaPassword = function(password)
    local player = source
    local xPlayer = ESX.GetPlayerFromId(player)

    if xPlayer.getAccount("bank").money >= Config.ChangePasswordPoints then
        xPlayer.removeAccountMoney("bank", Config.ChangePasswordPoints)

        Reti.UpdateReteWifi(player, { password = password }, "password")
        TriggerClientEvent("gcphone:modem_updateMenu", player)
    else
        showXNotification(xPlayer, translate("MODEM_CREATION_NOT_ENOUGH_MONEY"))
    end
end

gcPhoneT.modem_compraModem = function()
    local player = source
    local xPlayer = ESX.GetPlayerFromId(player)

    if xPlayer.getAccount("bank").money >= Config.BuyModemPrice then
        xPlayer.addInventoryItem(Config.ModemItemName, 1)
        showXNotification(xPlayer, translate("MODEM_BOUGHT_OK"))

        xPlayer.removeAccountMoney("bank", Config.BuyModemPrice)
        TriggerClientEvent("gcphone:modem_updateMenu", player)
    else
        showXNotification(xPlayer, translate("MODEM_CREATION_NOT_ENOUGH_MONEY"))
    end
end

ESX.RegisterServerCallback("gcphone:modem_getMenuInfo", function(source, cb)
    local elements = {}
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchAll("SELECT * FROM phone_wifi_nets WHERE steam_id = @identifier", {
        ['@identifier'] = xPlayer.identifier
    }, function(result)
        if #result > 0 then
            local createdString = os.date("%d/%m/%Y - %X", math.floor(result[1].created / 1000))
            local dueString = os.date("%d/%m/%Y - %X", math.floor(result[1].due_date / 1000))
            table.insert(elements, { label = translate("MODEM_MENU_ARGS_1"):format(createdString) })
            if result[1].not_expire == 1 then
                table.insert(elements, { label = translate("MODEM_MENU_ARGS_2") })
            else
                table.insert(elements, { label = translate("MODEM_MENU_ARGS_3"):format(dueString) })
            end

            local password = result[1].password
            local label = result[1].label
            table.insert(elements, { label = translate("MODEM_MENU_ARGS_4"):format(label) })
            table.insert(elements, { label = translate("MODEM_MENU_ARGS_5"):format(password), value = "aggiorna_password" })

            table.insert(elements, { label = translate("MODEM_MENU_ARGS_6"):format(Config.RenewModemPrice), value = "rinnova_modem" })
        else
            table.insert(elements, { label = translate("MODEM_MENU_ARGS_7") })
            table.insert(elements, { label = translate("MODEM_MENU_ARGS_8"):format(Config.BuyModemPrice), value = "buy_modem" })
        end

        cb(elements)
    end)
end)