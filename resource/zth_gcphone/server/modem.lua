Reti = nil
TriggerEvent("esx_wifi:getSharedObject", function(obj) Reti = obj end)


local creationTimeout = {}
RegisterServerEvent("gcphone:modem_createModem")
AddEventHandler("gcphone:modem_createModem", function(label, password, coords)
    local player = source
    local xPlayer = ESX.GetPlayerFromId(player)

    if creationTimeout[player] == nil or not creationTimeout[player] then
        local day = 86400
        local days = day * Config.AddDaysOnRenewal
        local currentTime = os.time(os.date("!*t"))

        Reti.AddReteWifi(player, {
            label = label,
            password = password, 
            coords = coords,
            due_date = os.time(os.date('*t', currentTime)) + days
        })

        creationTimeout[player] = true
        xPlayer.removeInventoryItem("modem", 1)

        Citizen.CreateThreadNow(function()
            local cachedPlayer = player
    
            SetTimeout(Config.WaitBeforeCreatingAgaing * 1000, function()
                creationTimeout[cachedPlayer] = nil
            end)
        end)
    end
end)


RegisterServerEvent("gcphone:modem_rinnovaModem")
AddEventHandler("gcphone:modem_rinnovaModem", function()
    local player = source
    local points = exports["vip_points"]:getPoints(source)
    local xPlayer = ESX.GetPlayerFromId(player)

    if points >= Config.RinnovaModemPoints then

        MySQL.Async.fetchAll("SELECT * FROM home_wifi_nets WHERE steam_id = @identifier", {
            ['@identifier'] = xPlayer.identifier
        }, function(result)
            if #result > 0 then
                local day = 86400
                local days = day * Config.AddDaysOnRenewal
                local new_date = os.time(os.date('*t', math.floor(result[1].due_date / 1000))) + days

                Reti.UpdateReteWifi(player, { due_date = os.date("%Y-%m-%d %H:%m:%S", new_date) }, "due_date")
                TriggerClientEvent("gcphone:modem_updateMenu", player)

                exports["vip_points"]:removePoints(source, Config.RinnovaModemPoints)
            end
        end)
    else
        xPlayer.showNotification("~r~Non hai abbastanza punti")
    end
end)


RegisterServerEvent("gcphone:modem_cambiaPassword")
AddEventHandler("gcphone:modem_cambiaPassword", function(password)
    local player = source
    local points = exports["vip_points"]:getPoints(source)
    local xPlayer = ESX.GetPlayerFromId(player)

    if points >= Config.ChangePasswordPoints then
        exports["vip_points"]:removePoints(source, Config.ChangePasswordPoints)

        Reti.UpdateReteWifi(player, { password = password }, "password")
        TriggerClientEvent("gcphone:modem_updateMenu", player)
    else
        xPlayer.showNotification("~r~Non hai abbastanza punti")
    end
end)


RegisterServerEvent("gcphone:modem_compraModem")
AddEventHandler("gcphone:modem_compraModem", function()
    local player = source
    local points = exports["vip_points"]:getPoints(source)
    local xPlayer = ESX.GetPlayerFromId(player)

    if points >= Config.BuyModemPoints then
        xPlayer.addInventoryItem("modem", 1)
        xPlayer.showNotification("~g~Hai comprato un modem nuovo di zecca")

        exports["vip_points"]:removePoints(source, Config.BuyModemPoints)
        TriggerClientEvent("gcphone:modem_updateMenu", player)
    else
        xPlayer.showNotification("~r~Non hai abbastanza punti per poter comprare un modem")
    end
end)


ESX.RegisterServerCallback("gcphone:modem_getMenuInfo", function(source, cb)
    local elements = {}
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchAll("SELECT * FROM home_wifi_nets WHERE steam_id = @identifier", {
        ['@identifier'] = xPlayer.identifier
    }, function(result)
        local points = exports["vip_points"]:getPoints(source)

        if #result > 0 then
            table.insert(elements, { label = "Punti vip: "..points })

            local createdString = os.date("%d/%m/%Y - %X", math.floor(result[1].created / 1000))
            local dueString = os.date("%d/%m/%Y - %X", math.floor(result[1].due_date / 1000))
            table.insert(elements, { label = "Comprato il "..createdString })
            table.insert(elements, { label = "Scade il "..dueString })
            if result[1].not_expire then
                table.insert(elements, { label = "Il tuo modem non scadrà" })
            end

            local password = result[1].password
            local label = result[1].label
            table.insert(elements, { label = "SSID "..label })
            table.insert(elements, { label = "Password "..password, value = "aggiorna_password" })

            table.insert(elements, { label = "Rinnova il modem per "..Config.RinnovaModemPoints.." punti", value = "rinnova_modem" })
        else
            table.insert(elements, { label = "Punti vip: "..points })
            
            table.insert(elements, { label = "Non hai acquistato un modem" })
            table.insert(elements, { label = "Compra un modem per "..Config.BuyModemPoints.." punti", value = "buy_modem" })
        end

        cb(elements)
    end)
end)