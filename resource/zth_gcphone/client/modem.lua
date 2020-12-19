Citizen.CreateThread(function()
    while ESX == nil do Citizen.Wait(1000) end

    TriggerEvent('tcm_grids:registerMarker', {
		name = "modem_management",
		type = 20,
		coords = Config.ModemManagement,
		colour = { r = 55, b = 255, g = 55 },
		size =  vector3(0.8, 0.8, 0.8),
        action = function()
            OpenModemManagement()
		end,
		msg = "Premi ~INPUT_CONTEXT~ per acquistare una cover",
	})
end)


RegisterNetEvent("gcphone:modem_chooseCredentials")
AddEventHandler("gcphone:modem_chooseCredentials", function()
    local label = GetResponseText()
    local password = GetResponseText()

    TriggerServerEvent("gcphone:modem_createModem", label, password, GetEntityCoords(GetPlayerPed(-1)))
end)


function OpenModemManagement()
	ESX.TriggerServerCallback("gcphone:modem_getMenuInfo", function(elements)
		onMenuSelect = function(data, _)
			if data.current.value == "aggiorna_password" then
				local password = GetResponseText()
				
				TriggerServerEvent("gcphone:modem_cambiaPassword", password)
			end

			if data.current.value == "rinnova_modem" then
				TriggerServerEvent("gcphone:modem_rinnovaModem")
			end

			if data.current.value == "buy_modem" then
				TriggerServerEvent("gcphone:modem_compraModem")
			end
		end

		onMenuClose = function(data, _)
			ESX.UI.Menu.CloseAll()
		end

		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'modem_management', {
			title = "Informazioni modem",
			elements = elements
		}, onMenuSelect, onMenuClose)
	end)
end