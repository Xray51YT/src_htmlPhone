--====================================================================================
-- #Author: Jonathan D @ Gannon
--====================================================================================
 
-- Configuration
local KeyToucheCloseEvent = {
    { code = 172, event = 'ArrowUp' },
    { code = 173, event = 'ArrowDown' },
    { code = 174, event = 'ArrowLeft' },
    { code = 175, event = 'ArrowRight' },
    { code = 176, event = 'Enter' },
    { code = 177, event = 'Backspace' },
}

local menuIsOpen = false
local contacts = {}
local messages = {}
local isDead = false
local USE_RTC = false
local useMouse = false
local ignoreFocus = false
hasFocus = false

local inCall = false
local stoppedPlayingUnreachable = false
secondiRimanenti = 0
enabeGlobalNotification = true

local PhoneInCall = {}
local currentPlaySound = false
local soundDistanceMax = 8.0

segnaleRadio = 0
retiWifi = {}
retiConosciute = {}
tempDataWifi = {}
isConnected = false
myPhoneNumber = ''

ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
    end

    TriggerServerEvent("gcPhone:allUpdate")
end)


function hasPhone(cb)
    if ESX == nil then return cb(false) end

    ESX.TriggerServerCallback('gcphone:getItemAmount', function(amount)
        cb(amount > 0)
    end, 'tel')
end

--====================================================================================
--  
--====================================================================================
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if IsControlJustPressed(1, 311) then -- K
            hasPhone(function(hasPhone)
                if hasPhone == true then
                    TooglePhone()
                else
                    ESX.ShowNotification("~r~Non hai un telefono con te")
                end
            end)
        end

        if menuIsOpen == true then

            for _, value in ipairs(KeyToucheCloseEvent) do
                if IsControlJustPressed(1, value.code) then
                    SendNUIMessage({keyUp = value.event})
                end
            end

            if useMouse == true and hasFocus == ignoreFocus then
                local nuiFocus = not hasFocus
                SetNuiFocus(nuiFocus, nuiFocus)
                hasFocus = nuiFocus
            elseif useMouse == false and hasFocus == true then
                SetNuiFocus(false, false)
                hasFocus = false
            end
        else
            if hasFocus == true then
                SetNuiFocus(false, false)
                hasFocus = false
            end
        end
    end
end)



--====================================================================================
--  Active ou Deactive une application (appName => config.json)
--====================================================================================

RegisterNetEvent('gcPhone:setEnableApp')
AddEventHandler('gcPhone:setEnableApp', function(appName, enable)
    SendNUIMessage({event = 'setEnableApp', appName = appName, enable = enable })
end)

RegisterNUICallback("updateNotifications", function(data, cb)
    print(data)
    enabeGlobalNotification = data
end)

--==================================================================================================================
--------  Funzioni per i suoni
--==================================================================================================================

function PlaySoundJS (sound, volume)
    SendNUIMessage({ event = 'playSound', sound = sound, volume = volume })
end


function SetSoundVolumeJS (sound, volume)
    SendNUIMessage({ event = 'setSoundVolume', sound = sound, volume = volume})
end


function StopSoundJS (sound)
    SendNUIMessage({ event = 'stopSound', sound = sound})
end


RegisterNetEvent("gcPhone:forceOpenPhone")
AddEventHandler("gcPhone:forceOpenPhone", function(_myPhoneNumber)
    if menuIsOpen == false then
        TooglePhone()
    end
end)
 
--====================================================================================
--  Events
--====================================================================================

RegisterNetEvent("gcPhone:updatePhoneNumber")
AddEventHandler("gcPhone:updatePhoneNumber", function(phone_number)
    myPhoneNumber = phone_number
    SendNUIMessage({event = 'updateMyPhoneNumber', myPhoneNumber = myPhoneNumber})
end)


RegisterNetEvent("gcPhone:contactList")
AddEventHandler("gcPhone:contactList", function(_contacts)
    contacts = _contacts
    SendNUIMessage({event = 'updateContacts', contacts = contacts})
end)


RegisterNetEvent("gcPhone:allMessage")
AddEventHandler("gcPhone:allMessage", function(allmessages, notReceivedMessages)
    SendNUIMessage({event = 'updateMessages', messages = allmessages})
    messages = allmessages

    if notReceivedMessages ~= nil then
        if notReceivedMessages > 0 then
            if notReceivedMessages == 1 then
                ESX.ShowNotification("Hai "..notReceivedMessages.." nuovo messaggo")
            else
                ESX.ShowNotification("Hai "..notReceivedMessages.." nuovi messaggi")
            end

            if enabeGlobalNotification then
                DrawNotification(false, false)
                PlaySoundJS('msgnotify.ogg', 0.05)
                Citizen.Wait(3000)
                StopSoundJS('msgnotify.ogg')
            end
        end
    end
end)


RegisterNetEvent("gcPhone:getBourse")
AddEventHandler("gcPhone:getBourse", function(bourse)
    SendNUIMessage({ event = 'updateBourse', bourse = bourse })
end)


RegisterNetEvent("gcphone:updateValoriDati")
AddEventHandler("gcphone:updateValoriDati", function(table)
    SendNUIMessage({ event = "updateDati", data = table })
end)


RegisterNetEvent("gcphone:aggiornameAConnessione")
AddEventHandler("gcphone:aggiornameAConnessione", function(potenzaSegnale)
    if segnaleRadio == 0 and segnaleRadio ~= potenzaSegnale then
        TriggerServerEvent("gcPhone:allUpdate")
    end

    segnaleRadio = potenzaSegnale
    local data = { potenza = potenzaSegnale }
    SendNUIMessage({event = "updateSegnale", data = data})
    TriggerServerEvent('gcPhone:updateSegnaleTelefono', potenzaSegnale)
end)


RegisterNetEvent("gcPhone:receiveMessage")
AddEventHandler("gcPhone:receiveMessage", function(message)

    SendNUIMessage({event = 'newMessage', message = message})
    table.insert(messages, message)

    if message.owner == 0 then
        local text = 'Hai ricevuto un messaggio'

        if ShowNumberNotification == true then
            text = 'Hai ricevuto un messaggio da '..message.transmitter

            for _,contact in pairs(contacts) do
                if contact.number == message.transmitter then
                    text = 'Hai ricevuto un messaggio da '..contact.display

                    break
                end
            end
        end

        ESX.ShowNotification(text)
        if enabeGlobalNotification then
            PlaySoundJS('msgnotify.ogg', 0.05)
            Citizen.Wait(3000)
            StopSoundJS('msgnotify.ogg')
        end
    end
end)


--====================================================================================
--  Function client | Contacts
--====================================================================================

function addContact(display, num) 
    TriggerServerEvent('gcPhone:addContact', display, num)
end


function deleteContact(num) 
    TriggerServerEvent('gcPhone:deleteContact', num)
end


--====================================================================================
--  Function client | Messages
--====================================================================================

function sendMessage(num, message)
    TriggerServerEvent('gcPhone:sendMessage', num, message)
end


function deleteMessage(msgId)
    TriggerServerEvent('gcPhone:deleteMessage', msgId)

    for k, v in ipairs(messages) do
        if v.id == msgId then
            table.remove(messages, k)
            SendNUIMessage({event = 'updateMessages', messages = messages})
            return
        end
    end
end


function deleteMessageContact(num)
    TriggerServerEvent('gcPhone:deleteMessageNumber', num)
end


function deleteAllMessage()
    TriggerServerEvent('gcPhone:deleteAllMessage')
end


function setReadMessageNumber(num)
    TriggerServerEvent('gcPhone:setReadMessageNumber', num)

    for k, v in ipairs(messages) do 
        if v.transmitter == num then
            v.isRead = 1
        end
    end
end


function requestAllMessages()
    TriggerServerEvent('gcPhone:requestAllMessages')
end


function requestAllContact()
    TriggerServerEvent('gcPhone:requestAllContact')
end

--====================================================================================
--  Function client | Appels
--====================================================================================


RegisterNetEvent("gcPhone:waitingCall")
AddEventHandler("gcPhone:waitingCall", function(infoCall, initiator)
    if inCall then return end

    SendNUIMessage({event = 'waitingCall', infoCall = infoCall, initiator = initiator})

    if initiator == true then
        PhonePlayCall()

        if menuIsOpen == false then
            TooglePhone()
        end
    end
end)


RegisterNetEvent("gcPhone:phoneUnreachable")
AddEventHandler("gcPhone:phoneUnreachable", function(infoCall, initiator)
    secondiRimanenti = infoCall.secondiRimanenti
    count = 0

    Citizen.CreateThreadNow(function()
        stoppedPlayingUnreachable = false
        Citizen.Wait(2000)
        SendNUIMessage({event = 'acceptCall', infoCall = infoCall, initiator = initiator})

        if stoppedPlayingUnreachable == false then
            PlaySoundJS('phoneunreachable.ogg', 0.25)
            count = 0
                
            while true do
                if count == 11 then rejectCall(infoCall) end

                if stoppedPlayingUnreachable == true then
                    stoppedPlayingUnreachable = false
                    StopSoundJS('phoneunreachable.ogg')
                    return
                end

                Citizen.Wait(1000)
                count = count + 1
            end
        else
            stoppedPlayingUnreachable = false
        end
    end)
end)


RegisterNetEvent("gcPhone:phoneNoSignal")
AddEventHandler("gcPhone:phoneNoSignal", function(infoCall, initiator)
    secondiRimanenti = infoCall.secondiRimanenti
    count = 0

    Citizen.CreateThreadNow(function()
        stoppedPlayingUnreachable = false
        Citizen.Wait(2000)

        if stoppedPlayingUnreachable == false then
            PlaySoundJS('phonenosignal.ogg', 0.25)
            count = 0
            
            while true do
                if count == 1 then
                    rejectCall(infoCall)
                end

                if stoppedPlayingUnreachable == true then
                    stoppedPlayingUnreachable = false
                    StopSoundJS('phonenosignal.ogg')
                    return
                end
                
                Citizen.Wait(1000)
                count = count + 1
            end
        else
            stoppedPlayingUnreachable = false
        end
    end)
end)


playerCoords = GetEntityCoords(GetPlayerPed(-1))
distance = nil

RegisterNetEvent("gcPhone:acceptCall")
AddEventHandler("gcPhone:acceptCall", function(infoCall, initiator)

    if inCall == false then
        inCall = true

        Citizen.CreateThread(function()
            secondiRimanenti = infoCall.secondiRimanenti
            if not infoCall.updateMinuti then secondiRimanenti = 1000000 end
            -- print("Accetto la chiamata chicco", infoCall.updateMinuti, secondiRimanenti)

            while inCall do
                Citizen.Wait(1000)
                if initiator then
                    secondiRimanenti = secondiRimanenti - 1
                    if secondiRimanenti == 0 then rejectCall(infoCall) end
                end

                if Config.TelefoniFissi[infoCall.receiver_num] then
                    if not initiator then
                        playerCoords = GetEntityCoords(GetPlayerPed(-1))
                        distance = Vdist(infoCall.coords.x, infoCall.coords.y, infoCall.coords.z, playerCoords.x, playerCoords.y, playerCoords.z)
                        if distance > 1.0 then rejectCall(infoCall) end
                    end
                else
                    if segnaleRadio == 0 then
                        rejectCall(infoCall)
                    end
                end
            end
        
            PlaySoundJS('callend.ogg', 0.25)
            Wait(2000)
            StopSoundJS('callend.ogg')
        end)
    
        --exports.tokovoip_script:addPlayerToPhoneCall(infoCall.id)
        TokoVoipID = infoCall.id
    end

    if menuIsOpen == false then 
        TooglePhone()
    end

    PhonePlayCall()
    SendNUIMessage({event = 'acceptCall', infoCall = infoCall, initiator = initiator})
end)


RegisterNetEvent("gcPhone:rejectCall")
AddEventHandler("gcPhone:rejectCall", function(infoCall)

    if infoCall and infoCall.updateMinuti then
        if not inCall then secondiRimanenti = infoCall.secondiRimanenti end
        -- print("Sto nel reject da parte del chiamante", infoCall.secondiRimanenti, secondiRimanenti, infoCall.updateMinuti)
        TriggerServerEvent("gcPhone:updateParametroTariffa", infoCall.transmitter_num, "minuti", secondiRimanenti)
    end

    if stoppedPlayingUnreachable == false then
        stoppedPlayingUnreachable = true
    end

    if inCall == true then
        inCall = false
        Citizen.InvokeNative(0xE036A705F989E049)
        -- NetworkClearVoiceChannel
        -- NetworkSetTalkerProximity(2.5)
        --exports.tokovoip_script:removePlayerFromPhoneCall(TokoVoipID)
        TokoVoipID = nil
    end

    PhonePlayText()
    SendNUIMessage({event = 'rejectCall', infoCall = infoCall})
end)


RegisterNetEvent("gcPhone:historiqueCall")
AddEventHandler("gcPhone:historiqueCall", function(historique)
    SendNUIMessage({event = 'historiqueCall', historique = historique})
end)


function acceptCall(infoCall, rtcAnswer)
    TriggerServerEvent('gcPhone:acceptCall', infoCall, rtcAnswer)
end


function rejectCall(infoCall)
    TriggerServerEvent('gcPhone:rejectCall', infoCall)
end


function ignoreCall(infoCall)
    TriggerServerEvent('gcPhone:ignoreCall', infoCall)
end


function requestHistoriqueCall() 
    TriggerServerEvent('gcPhone:getHistoriqueCall')
end


function appelsDeleteHistorique (num)
    TriggerServerEvent('gcPhone:appelsDeleteHistorique', num)
end


function appelsDeleteAllHistorique ()
    TriggerServerEvent('gcPhone:appelsDeleteAllHistorique')
end

--====================================================================================
--  Event NUI - Appels
--====================================================================================

RegisterNUICallback('startCall', function (data, cb)
    if data.rtcOffer == nil then data.rtcOffer = '' end
    TriggerServerEvent('gcPhone:startCall', data.numero, data.rtcOffer, data.extraData)
    cb("ok")
end)


RegisterNUICallback('acceptCall', function (data, cb)
    acceptCall(data.infoCall, data.rtcAnswer)
    cb("ok")
end)


RegisterNUICallback('rejectCall', function (data, cb)
    rejectCall(data.infoCall)
    cb("ok")
end)


RegisterNUICallback('ignoreCall', function (data, cb)
    ignoreCall(data.infoCall)
    cb("ok")
end)


RegisterNUICallback('notififyUseRTC', function (use, cb)
    USE_RTC = use
    if USE_RTC == true and inCall == true then
        inCall = false
        Citizen.InvokeNative(0xE036A705F989E049)
        NetworkSetTalkerProximity(2.5)
    end
    cb("ok")
end)


RegisterNUICallback('onCandidates', function (data, cb)
    TriggerServerEvent('gcPhone:candidates', data.id, data.candidates)
    cb("ok")
end)


RegisterNUICallback("requestOfferta", function(data, cb)
    TriggerServerEvent("gcPhone:requestOffertaFromDatabase")
    cb("ok")
end)


RegisterNetEvent("gcPhone:sendRequestedOfferta")
AddEventHandler("gcPhone:sendRequestedOfferta", function(dati, label)
    ESX.TriggerServerCallback("esx_cartesim:getPianoTariffario", function(massimo)
        -- print("Tariffa telefono", massimo.minuti, massimo.messaggi, massimo.dati)
        local info = {
            current = dati,
            max = {
                massimo.minuti,
                massimo.messaggi,
                massimo.dati
            }
        }
        SendNUIMessage({event = "updateOfferta", data = info})
    end, label)
end)


RegisterNetEvent("gcPhone:candidates")
AddEventHandler("gcPhone:candidates", function(candidates)
    SendNUIMessage({event = 'candidatesAvailable', candidates = candidates})
end)


RegisterNetEvent('gcphone:autoCall')
AddEventHandler('gcphone:autoCall', function(number, extraData)
    if number ~= nil then
        SendNUIMessage({ event = "autoStartCall", number = number, extraData = extraData})
    end
end)


RegisterNetEvent('gcphone:autoCallNumber')
AddEventHandler('gcphone:autoCallNumber', function(data)
    TriggerEvent('gcphone:autoCall', data.number)
end)


--====================================================================================
--  Gestion des evenements NUI
--==================================================================================== 
RegisterNUICallback('log', function(data, cb)
    print(data)
    cb("ok")
end)


RegisterNUICallback('focus', function(data, cb)
    cb("ok")
end)


RegisterNUICallback('blur', function(data, cb)
    cb("ok")
end)


RegisterNUICallback('reponseText', function(data, cb)
    local limit = data.limit or 255
    local text = data.text or ''
    
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", text, "", "", "", limit)
    while UpdateOnscreenKeyboard() == 0 do
        DisableAllControlActions(0);
        Wait(0);
    end

    if GetOnscreenKeyboardResult() then
        text = GetOnscreenKeyboardResult()
    end
    cb(json.encode({text = text}))
end)
--====================================================================================
--  Event - Messages
--====================================================================================
RegisterNUICallback('getMessages', function(data, cb)
    cb(json.encode(messages))
end)


RegisterNUICallback('sendMessage', function(data, cb)
    if data.message == '%pos%' then
        local myPos = GetEntityCoords(PlayerPedId())
        data.message = 'GPS: ' .. myPos.x .. ', ' .. myPos.y
    end

    TriggerServerEvent('gcPhone:sendMessage', data.phoneNumber, data.message)
    cb("ok")
end)


RegisterNUICallback('deleteMessage', function(data, cb)
    deleteMessage(data.id)
    cb("ok")
end)


RegisterNUICallback('deleteMessageNumber', function (data, cb)
    deleteMessageContact(data.number)
    cb("ok")
end)


RegisterNUICallback('deleteAllMessage', function (data, cb)
    deleteAllMessage()
    cb("ok")
end)


RegisterNUICallback('setReadMessageNumber', function (data, cb)
    setReadMessageNumber(data.number)
    cb("ok")
end)


--====================================================================================
--  Event - Contacts
--====================================================================================
RegisterNUICallback('addContact', function(data, cb) 
    TriggerServerEvent('gcPhone:addContact', data.display, data.phoneNumber)
    cb("ok")
end)


RegisterNUICallback('updateContact', function(data, cb)
    TriggerServerEvent('gcPhone:updateContact', data.id, data.display, data.phoneNumber)
    cb("ok")
end)


RegisterNUICallback('deleteContact', function(data, cb)
    TriggerServerEvent('gcPhone:deleteContact', data.id)
    cb("ok")
end)


RegisterNUICallback('aggiornaAvatarContatto', function(data, cb)
    -- data.id
    -- data.number
    -- data.display
    -- data.icon
    TriggerServerEvent("gcPhone:updateAvatarContatto", data)
    cb("ok")
end)


RegisterNUICallback('getContacts', function(data, cb)
    cb(json.encode(contacts))
end)


RegisterNUICallback('setGPS', function(data, cb)
    SetNewWaypoint(tonumber(data.x), tonumber(data.y))
    cb("ok")
end)


-- Add security for event (leuit#0100)
RegisterNUICallback('callEvent', function(data, cb)
    local eventName = data.eventName or ''

    if string.match(eventName, 'gcphone') then
        if data.data ~= nil then 
            TriggerEvent(data.eventName, data.data)
        else
            TriggerEvent(data.eventName)
        end
    end

    cb("ok")
end)


RegisterNUICallback('chiamataEmergenza', function(data, cb)
    local eventName = data.eventName or ''

    if string.match(eventName, 'gcphone') then
        if data.type ~= nil then 
            TriggerEvent(data.eventName, data)
        else
            TriggerEvent(data.eventName)
        end
    end

    cb("ok")
end)


RegisterNUICallback('deleteALL', function(data, cb)
    TriggerServerEvent('gcPhone:deleteALL')
    cb("ok")
end)


function TooglePhone()
    menuIsOpen = not menuIsOpen
    SendNUIMessage({show = menuIsOpen})

    if menuIsOpen == true then 
        PhonePlayIn()
    else
        PhonePlayOut()
    end
end


RegisterNUICallback('faketakePhoto', function(data, cb)
    menuIsOpen = false
    SendNUIMessage({show = false})
    cb("ok")
    TriggerEvent('camera:open')
end)


RegisterNUICallback('closePhone', function(data, cb)
    menuIsOpen = false
    SendNUIMessage({show = false})
    PhonePlayOut()
    cb("ok")
end)

----------------------------------
---------- GESTION APPEL ---------
----------------------------------
RegisterNUICallback('appelsDeleteHistorique', function (data, cb)
    appelsDeleteHistorique(data.numero)
    cb("ok")
end)



RegisterNUICallback('appelsDeleteAllHistorique', function (data, cb)
    appelsDeleteAllHistorique(data.infoCall)
    cb("ok")
end)


RegisterNUICallback('setIgnoreFocus', function(data, cb)
    ignoreFocus = data.ignoreFocus
    cb("ok")
end)


---------------------------------------------------------------------------------
-- CALLBACK DELLE RETI WIFI
---------------------------------------------------------------------------------


RegisterNetEvent("gcphone:aggiornaRetiWifi")
AddEventHandler("gcphone:aggiornaRetiWifi", function(retiWifiServer)
    -- print("sto aggiornando retiwifi")
    -- print(json.encode(retiWifiServer))
    retiWifi = retiWifiServer

    -- aggiorna la lista del wifi
    SendNUIMessage({event = "updateRetiWifi", data = retiWifi})
    -- aggiorna l'icona del wifi
    SendNUIMessage({event = "updateWifi", data = {hasWifi = isConnected}})
end)


RegisterNUICallback('connettiAllaRete', function(data, cb)
    if data == false then
        ESX.ShowNotification("Password errata!", "error")
        return
    end

    tempDataWifi = {label = data.label, password = data.password}
    ESX.ShowNotification("Password corretta!", "success")

    TriggerEvent("gcphone:updateWifi", true, tempDataWifi)
    startCheck()
    cb("ok")
end)


RegisterNUICallback('soundLockscreen', function(data, cb)
	PlaySoundJS('phoneUnlock.ogg', 0.25)
    Wait(1000)
    StopSoundJS('phoneUnlock.ogg')
    cb("ok")
end)


RegisterNetEvent("gcphone:updateWifi")
AddEventHandler("gcphone:updateWifi", function(connected, rete)
    -- print("updating isConnected")

    isConnected = connected
    SendNUIMessage({event = "updateWifi", data = {hasWifi = isConnected}})
    TriggerServerEvent('gcPhone:updateReteWifi', isConnected, rete)
end)


-- funzione che controlla se sei nel range o no
function startCheck()
    local found = false

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(2000)
            found = false

            if isConnected then
                -- print("sei connesso")

                for k, v in pairs(retiWifi) do
                    -- print(v.label, tempDataWifi.label, v.password, tempDataWifi.password)

                    if v.label == tempDataWifi.label and v.password == tempDataWifi.password then
                        found = true
                        -- print("rete trovata")
                        break
                    end
                end

                -- print(found)

                if not found then
                    isConnected = false
                    tempDataWifi = {}
                    TriggerServerEvent('gcPhone:updateReteWifi', isConnected, nil)
                end
            else
                return
            end
        end
    end)
end


---------------------------------------------------------------------------------
-- TELEFONI FISSI
---------------------------------------------------------------------------------


function startFixeCall (fixeNumber)
    local number = ''
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 10)
    while UpdateOnscreenKeyboard() == 0 do
        DisableAllControlActions(0);
        Wait(0);
    end

    if GetOnscreenKeyboardResult() then
        number =  GetOnscreenKeyboardResult()
    end

    if number ~= '' then
        TriggerEvent('gcphone:autoCall', number, { useNumber = fixeNumber })
        PhonePlayCall(true)
    end
end


function TakeAppel(infoCall)
    TooglePhone()
    SendNUIMessage({event = 'waitingCall', infoCall = infoCall, initiator = initiator})
    acceptCall(infoCall, nil)
end


RegisterNetEvent("gcPhone:notifyFixePhoneChange")
AddEventHandler("gcPhone:notifyFixePhoneChange", function(_PhoneInCall)
    PhoneInCall = _PhoneInCall
end)


RegisterNetEvent('gcPhone:register_FixePhone')
AddEventHandler('gcPhone:register_FixePhone', function(phone_number, data)
    Config.TelefoniFissi[phone_number] = data
end)


Citizen.CreateThread(function ()
    local mod = 0
    local inRangeToActivePhone = false
    local inRangedist = 0

    while true do 
        local coords = GetEntityCoords(GetPlayerPed(-1))

        for i, _ in pairs(PhoneInCall) do 
            local dist = GetDistanceBetweenCoords( PhoneInCall[i].coords.x, PhoneInCall[i].coords.y, PhoneInCall[i].coords.z, coords.x, coords.y, coords.z, 1)

            if dist <= soundDistanceMax then
                inRangeToActivePhone = true
                inRangedist = dist

                if dist <= 1.0 then 
                    SetTextComponentFormat("STRING")
                    AddTextComponentString('Premi ~INPUT_CONTEXT~ per rispondere al telefono')
                    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                    if IsControlJustPressed(1, Config.KeyTakeCall) then
                        TakeAppel(PhoneInCall[i])
                        PhoneInCall = {}
                        StopSoundJS('ring2.ogg')
                    end
                end

                break
            end
        end

        if inRangeToActivePhone == true and currentPlaySound == false then
            PlaySoundJS('ring2.ogg', 0.2 + (inRangedist - soundDistanceMax) / -soundDistanceMax * 0.8 )
            currentPlaySound = true
        elseif inRangeToActivePhone == true then
            mod = mod + 1
            if mod == 15 then
                mod = 0
                SetSoundVolumeJS('ring2.ogg', 0.2 + (inRangedist - soundDistanceMax) / -soundDistanceMax * 0.8 )
            end
        elseif inRangeToActivePhone == false and currentPlaySound == true then
            currentPlaySound = false
            StopSoundJS('ring2.ogg')
        end
        Citizen.Wait(1)
    end
end)