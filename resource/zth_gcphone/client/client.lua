-- Configuration
local tunnel = module("modules/TunnelV2")
gcPhoneServerT = tunnel.getInterface("gcphone_server_t", "gcphone_server_t")

menuIsOpen = false
contacts = {}
messages = {}
isDead = false
hasFocus = false

inCall = false
stoppedPlayingUnreachable = false
secondiRimanenti = 0
NOTIFICATIONS_ENABLED = true
GLOBAL_AIRPLANE = false

currentPlaySound = false

volume = 0.5

radioPower = 0
CAHES_WIFI_MODEMS = {}
WIFI_TEMP_DATA = {}
isConnected = false

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(500)
    end

    ESX.PlayerData = ESX.GetPlayerData()
    gcPhoneServerT.allUpdate()
end)

RegisterNetEvent("esx_ambulancejob:setDeathStatus")
AddEventHandler('esx_ambulancejob:setDeathStatus', function(_isDead) isDead = _isDead end)

--====================================================================================
--  
--====================================================================================
Citizen.CreateThread(function()
    RegisterKeyMapping('+openPhone', Config.Language["SETTINGS_KEY_LABEL"], 'keyboard', Config.KeyToOpenPhone)
    RegisterCommand('+openPhone', function()
        if not IsEntityPlayingAnim(GetPlayerPed(-1), 'mp_arresting', 'idle', 3) then
            if not isDead then
                if gcPhoneServerT.getItemAmount(Config.PhoneItemName) > 0 then
                    TogglePhone()
                else
                    ESX.ShowNotification(Config.Language["NO_PHONE_ITEM"])
                end
            else
                ESX.ShowNotification(Config.Language["NO_PHONE_WHILE_DEAD"])
            end
        else
            ESX.ShowNotification(Config.Language["NO_PHONE_WHILE_ARRESTED"])
        end
    end, false)
    RegisterCommand('-openPhone', function() end, false)

    while true do
        Citizen.Wait(0)

        if menuIsOpen then
            while UpdateOnscreenKeyboard() == 0 do
                Citizen.Wait(100)
            end

            for _, value in ipairs(Config.Keys) do
                if IsControlJustPressed(1, value.code) or IsDisabledControlJustPressed(1, value.code) then
                    SendNUIMessage({ keyUp = value.event })
                end
            end

            if hasFocus then
                SetNuiFocus(false, false)
                hasFocus = false
            end
        else
            if hasFocus then
                SetNuiFocus(false, false)
                hasFocus = false
            end
        end
    end
end)


RegisterNetEvent("gcphone:sendGenericNotification")
AddEventHandler("gcphone:sendGenericNotification", function(data)
    --[[
        Vue.notify({
            message: store.getters.LangString(data.message),
            title: store.getters.LangString(data.title) + ':',
            icon: data.icon,
            backgroundColor: data.color,
            appName: data.appName
        })
    ]]
    SendNUIMessage({ event = "genericNotification", notif = data })
end)


-- utile dal js per l'appstore, non qui :/
--[[
    RegisterNetEvent("gcPhone:forceOpenPhone")
    AddEventHandler("gcPhone:forceOpenPhone", function(_myPhoneNumber)
        if menuIsOpen == false then
            TogglePhone()
        end
    end)
]]

--==================================================================================================================
--------  Funzioni per i suoni
--==================================================================================================================

function PlaySoundJS(sound, v)
    local _volume = v and v or volume
    -- print("riproduco suono", sound, _volume)
    SendNUIMessage({ event = 'playSound', sound = sound, volume = _volume })
end

function SetSoundVolumeJS(sound, v)
    local _volume = v and v or volume
    SendNUIMessage({ event = 'setSoundVolume', sound = sound, volume = _volume })
end

function UpdateGlobalVolume(v)
    volume = v
    SendNUIMessage({ event = 'updateGlobalVolume', volume = volume })
end

function StopSoundJS(sound)
    SendNUIMessage({ event = 'stopSound', sound = sound })
end
 
--====================================================================================
--  Events
--====================================================================================

RegisterNetEvent("gcPhone:updatePhoneNumber")
AddEventHandler("gcPhone:updatePhoneNumber", function(phone_number)
    -- myPhoneNumber = phone_number
    SendNUIMessage({ event = 'updateMyPhoneNumber', myPhoneNumber = phone_number })
end)

RegisterNetEvent("gcPhone:contactList")
AddEventHandler("gcPhone:contactList", function(_contacts)
    contacts = _contacts
    SendNUIMessage({ event = 'updateContacts', contacts = contacts })
end)

RegisterNetEvent("gcPhone:allMessage")
AddEventHandler("gcPhone:allMessage", function(allmessages, notReceivedMessages)
    SendNUIMessage({ event = 'updateMessages', messages = allmessages, volume = volume })
    messages = allmessages

    if not GLOBAL_AIRPLANE then
        if notReceivedMessages ~= nil and notReceivedMessages > 0 then
            if notReceivedMessages == 1 then
                ESX.ShowNotification(Config.Language["SINGLE_UNREAD_MESSAGE_NOTIFICATION"]:format(notReceivedMessages))
            else
                ESX.ShowNotification(Config.Language["MULTIPLE_UNREAD_MESSAGES_NOTIFICATION"]:format(notReceivedMessages))
            end

            if NOTIFICATIONS_ENABLED then
                DrawNotification(false, false)
                PlaySoundJS('msgnotify.ogg')
                Citizen.Wait(3000)
                StopSoundJS('msgnotify.ogg')
            end
        end
    end
end)

--[[
    RegisterNetEvent("gcPhone:getBourse")
    AddEventHandler("gcPhone:getBourse", function(bourse)
        SendNUIMessage({ event = 'updateBourse', bourse = bourse })
    end)
]]

RegisterNetEvent("gcphone:updateValoriDati")
AddEventHandler("gcphone:updateValoriDati", function(table)
    SendNUIMessage({ event = "updateDati", data = table })
end)

RegisterNetEvent("gcphone:updateRadioSignal")
AddEventHandler("gcphone:updateRadioSignal", function(s_radioPower)
    if radioPower == 0 and radioPower ~= s_radioPower then
        gcPhoneServerT.allUpdate()
    end

    radioPower = s_radioPower
    SendNUIMessage({ event = "updateSegnale", potenza = s_radioPower })
end)

RegisterNetEvent("gcPhone:receiveMessage")
AddEventHandler("gcPhone:receiveMessage", function(message)
    if not message then return end
    if not GLOBAL_AIRPLANE then
        SendNUIMessage({ event = 'newMessage', message = message, notifications = NOTIFICATIONS_ENABLED })
        table.insert(messages, message)

        if message.owner == 0 then
            local text = Config.Language["MESSAGE_NOTIFICATION_NO_TRANSMITTER"]
            if Config.ShowNumberNotification then
                text = Config.Language["MESSAGE_NOTIFICATION_TRANSMITTER"]:format(message.transmitter)

                for _, contact in pairs(contacts) do
                    if contact.number == message.transmitter then
                        text = Config.Language["MESSAGE_NOTIFICATION_TRANSMITTER"]:format(contact.display)
                        break
                    end
                end
            end

            ESX.ShowNotification(text)
            -- if NOTIFICATIONS_ENABLED then
            --     PlaySoundJS('msgnotify.ogg')
            --     Citizen.Wait(3000)
            --     StopSoundJS('msgnotify.ogg')
            -- end
        end
    end
end)

--====================================================================================
--  Function client | Appels
--====================================================================================

RegisterNetEvent("gcPhone:waitingCall")
AddEventHandler("gcPhone:waitingCall", function(infoCall, initiator)
    if inCall then return end
    SendNUIMessage({ event = 'waitingCall', infoCall = infoCall, initiator = initiator })

    if initiator then
        PhonePlayCall()
        if not menuIsOpen then TogglePhone() end
    end
end)

RegisterNetEvent("gcPhone:phoneVoiceMail")
AddEventHandler("gcPhone:phoneVoiceMail", function(infoCall, initiator)
    Citizen.CreateThreadNow(function()
        stoppedPlayingUnreachable = false
        Citizen.Wait(2000)
        infoCall.volume = volume
        SendNUIMessage({ event = 'initVoiceMail', infoCall = infoCall, initiator = initiator })
    end)
end)

RegisterNetEvent("gcPhone:phoneNoSignal")
AddEventHandler("gcPhone:phoneNoSignal", function(infoCall, initiator)
    SendNUIMessage({ event = 'noSignal', infoCall = infoCall })
end)

-- questo evento viene chiamato dal server quando un giocatore
-- entra in chiamata con un altro. Questo permette allo script di rimuovere
-- i minuti mentre si è in chiamata
RegisterNetEvent("gcPhone:acceptCall")
AddEventHandler("gcPhone:acceptCall", function(infoCall, initiator)
    if not inCall then
        inCall = true

        Citizen.CreateThread(function()
            local coords, distance = nil, nil
            -- print("Accetto la chiamata chicco, infoCall.updateMinuti", infoCall.updateMinuti, "secondiRimanenti", secondiRimanenti)

            while inCall do
                Citizen.Wait(1000)
                if initiator then
                    infoCall.secondiRimanenti = infoCall.secondiRimanenti - 1
                    if infoCall.secondiRimanenti == 0 then gcPhoneServerT.rejectCall(infoCall) end
                end

                if Config.PhoneBoxes[infoCall.receiver_num] then
                    if not initiator then
                        coords = GetEntityCoords(GetPlayerPed(-1))
                        distance = Vdist(infoCall.coords.x, infoCall.coords.y, infoCall.coords.z, coords.x, coords.y, coords.z)
                        if distance > 1.0 then gcPhoneServerT.rejectCall(infoCall) end
                    end
                else
                    if radioPower == 0 then gcPhoneServerT.rejectCall(infoCall) end
                end
            end
        end)
        
        if Config.EnableTokoVoip then
            -- print("aggiungo in canale "..infoCall.id)
            TokovoipEnstablishCall(infoCall.id)
        elseif Config.EnableSaltyChat then
            if infoCall then
                gcPhoneServerT.setEndpointSource(infoCall.receiver_src)
                gcPhoneServerT.EstablishCall(infoCall.receiver_src)
            end
        elseif Config.EnableVoiceRTC then
            -- noting for now :P
        end
    end

    if not menuIsOpen then 
        TogglePhone()
    end

    PhonePlayCall()
    SendNUIMessage({ event = 'acceptCall', infoCall = infoCall, initiator = initiator })
end)

RegisterNetEvent("gcPhone:rejectCall")
AddEventHandler("gcPhone:rejectCall", function(infoCall, callDropper)
    infoCall.callDropped = callDropper
    if infoCall and infoCall.updateMinuti then
        infoCall.callTime = infoCall.endCall_time - infoCall.startCall_time
        if not inCall then infoCall.callTime = 0 end
        -- print(secondi)
        -- print(DumpTable(infoCall))
        gcPhoneServerT.updateParametroTariffa(infoCall.transmitter_num, "minuti", (infoCall.secondiRimanenti - infoCall.callTime))
    end

    if not stoppedPlayingUnreachable then stoppedPlayingUnreachable = true end

    if inCall then
        inCall = false
        -- Citizen.InvokeNative(0xE036A705F989E049)
        -- NetworkClearVoiceChannel
        -- NetworkSetTalkerProximity(2.5)
        -- print("rimuovo canale "..TokoVoipID)
        if Config.EnableTokoVoip then
            -- print("aggiungo in canale "..infoCall.id)
            TokovoipEndCall(TokoVoipID)
        elseif Config.EnableSaltyChat then
            local endPoint = gcPhoneServerT.getEndpointSource()
            -- print(endPoint, GetPlayerServerId(PlayerId()))
            if endPoint then
                gcPhoneServerT.EndCall(endPoint)
                gcPhoneServerT.removeEndpointSource()
            end
        elseif Config.EnableVoiceRTC then
            -- nothing for now :P
        end
    end

    PhonePlayText()
    SendNUIMessage({ event = 'rejectCall', infoCall = infoCall })
end)

RegisterNetEvent("gcPhone:historyCalls")
AddEventHandler("gcPhone:historyCalls", function(history)
    -- print(DumpTable(history))
    SendNUIMessage({ event = 'historyCalls', history = history })
end)

--====================================================================================
--  Event NUI - Appels
--====================================================================================

RegisterNetEvent("gcPhone:sendRequestedOfferta")
AddEventHandler("gcPhone:sendRequestedOfferta", function(dati, label)
    ESX.TriggerServerCallback("esx_cartesim:getPianoTariffario", function(massimo)
        -- print("Tariffa telefono", massimo.minuti, massimo.messaggi, massimo.dati)
        -- local info = 
        SendNUIMessage({ event = "updateOfferta", data = {
            current = dati,
            max = {
                massimo.minuti,
                massimo.messaggi,
                massimo.dati
            }
        } })
    end, label)
end)

RegisterNetEvent("gcPhone:candidates")
AddEventHandler("gcPhone:candidates", function(candidates)
    SendNUIMessage({ event = 'candidatesAvailable', candidates = candidates })
end)

function GetResponseText(d)
    local limit = d.limit or 255
    local text = d.text or ''
    local title = d.title or "NO_LABEL_DEFINED"
    
    AddTextEntry('CUSTOM_PHONE_TITLE', title)
    DisplayOnscreenKeyboard(1, "CUSTOM_PHONE_TITLE", "", text, "", "", "", limit)
    while UpdateOnscreenKeyboard() == 0 do
        DisableAllControlActions(0)
        DisableAllControlActions(1)
        DisableAllControlActions(2)
        Wait(0)
    end

    if GetOnscreenKeyboardResult() then
        text = GetOnscreenKeyboardResult()
    end

    return text
end

function TogglePhone()
    ESX.PlayerData = ESX.GetPlayerData()

    menuIsOpen = not menuIsOpen
    SendNUIMessage({ show = menuIsOpen })

    if needAuth then
        gcPhoneServerT.authServer()
    end
    
    local firstname, lastname = gcPhoneServerT.getFirstnameAndLastname()
    local firstjob, secondjob = gcPhoneServerT.getFirstAndSecondJob()
    SendNUIMessage({
        event = "sendParametersValues",
        job = firstjob.label,
        job2 = secondjob and secondjob.label or "None",
        firstname = firstname,
        lastname = lastname
    })

    if menuIsOpen then 
        PhonePlayIn()
    else
        PhonePlayOut()
    end
end

---------------------------------------------------------------------------------
-- CALLBACK DELLE RETI WIFI
---------------------------------------------------------------------------------

function AggiornaRetiWifi(r)
    -- print("sto aggiornando retiwifi")
    -- print(json.encode(retiWifiServer))
    CAHES_WIFI_MODEMS = r

    -- aggiorna la lista del wifi
    SendNUIMessage({ event = "updateRetiWifi", data = CAHES_WIFI_MODEMS })
    -- aggiorna l'icona del wifi
    SendNUIMessage({ event = "updateWifi", data = { hasWifi = isConnected } })
end

RegisterNetEvent("gcphone:updateWifi")
AddEventHandler("gcphone:updateWifi", function(connected, rete)
    -- print("updating isConnected")
    isConnected = connected
    SendNUIMessage({ event = "updateWifi", data = {hasWifi = isConnected} })
    gcPhoneServerT.updateReteWifi(isConnected, rete)
end)

-- funzione che controlla se sei nel range o no
-- quando ti connetti al wifi
function StartWifiRangeCheck()
    local found = false

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(2000)
            found = false

            if isConnected then
                -- print("sei connesso")
                for k, v in pairs(CAHES_WIFI_MODEMS) do
                    -- print(v.label, WIFI_TEMP_DATA.label, v.password, WIFI_TEMP_DATA.password)
                    if v.label == WIFI_TEMP_DATA.label and v.password == WIFI_TEMP_DATA.password then
                        found = true
                        -- print("rete trovata")
                        break
                    end
                end
                -- print(found)
                if not found then
                    isConnected = false
                    WIFI_TEMP_DATA = {}
                    gcPhoneServerT.updateReteWifi(isConnected, nil)
                end
            else
                return
            end
        end
    end)
end