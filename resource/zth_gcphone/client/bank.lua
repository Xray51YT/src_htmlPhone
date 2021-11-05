RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
    local bank, iban = gcPhoneServerT.bank_getBankInfo()
    SendNUIMessage({ event = 'updateBankbalance', soldi = bank, iban = iban })
end)

RegisterNetEvent("gcphone:bank_sendBankMovements")
AddEventHandler("gcphone:bank_sendBankMovements", function(movements)
    SendNUIMessage({ event = "updateBankMovements", movements = movements })
end)

RegisterNUICallback("sendMoneyToIban", function(data, cb)
    gcPhoneServerT.sendMoneyToUser(data)
    cb("ok")
end)

RegisterNUICallback("requestBankInfo", function(data, cb)
    local bank, iban = gcPhoneServerT.bank_getBankInfo()
    SendNUIMessage({ event = 'updateBankbalance', soldi = bank, iban = iban })
    cb("ok")
end)

RegisterNUICallback("requestFatture", function(data, cb)
    ESX.TriggerServerCallback("esx_billing:getBills", function(fatture)
        SendNUIMessage({ event = "receivePlayerFatture", fatture = fatture })
    end)
    cb("ok")
end)

RegisterNUICallback("pagaFattura", function(data, cb)
    ESX.TriggerServerCallback("esx_billing:payBill", function(ok)
        if ok then
            ESX.TriggerServerCallback("esx_billing:getBills", function(fatture) SendNUIMessage({ event = "receivePlayerFatture", fatture = fatture }) end)
        end
    end, data.id)
    cb("ok")
end)

RegisterNetEvent("gcPhone:updateBankAmount")
AddEventHandler("gcPhone:updateBankAmount", function(amount, iban)
    SendNUIMessage({ event = 'updateBankbalance', soldi = amount, iban = iban })
end)

