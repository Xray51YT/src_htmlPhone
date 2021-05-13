ESX = nil

torriRadio, torriRadioRotte = {}, {}
retiWifi = {}

local playerCaricato = false
local blipCaricati = false

Citizen.CreateThread(function()
	while ESX == nil do
		Citizen.Wait(100)
		ESX = exports["es_extended"]:getSharedObject()
	end

	while ESX.GetPlayerData().job == nil do Citizen.Wait(500) end

	playerCaricato = true

	Reti:InitScript()
end)

RegisterNetEvent('esx_wifi:riceviTorriRadio')
AddEventHandler('esx_wifi:riceviTorriRadio', function(torriRadioServer, torriRadioServerRotte)
	torriRadio = torriRadioServer
	torriRadioRotte = torriRadioServerRotte
end)

RegisterNetEvent('esx_wifi:riceviRetiWifi')
AddEventHandler('esx_wifi:riceviRetiWifi', function(retiWifiServer)
	retiWifi = retiWifiServer
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(source) playerCaricato = true end)

function Reti:InitScript()
	-- init variabili generali
	self.ped = nil
	self.p_coords = nil
	self.idPlayer = GetPlayerServerId(PlayerId())

	-- thread per salvataggio coordinate
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(1000)

			self.ped = GetPlayerPed(-1)
			self.p_coords = GetEntityCoords(self.ped)
		end
	end)

	-- thread per controllo distanza torri
	Citizen.CreateThread(function()
		
		local distanza = nil
		self.torre = nil
		self.potenzaSegnale = 0
		self.torrePiuVicina = 0

		self.connectedTorreIndex = nil
		self.agganciato = false
		self.vecchiaPotenzaSegnale = 0

		TriggerServerEvent('esx_wifi:richiediTorriRadio')

		while #torriRadio == 0 do Citizen.Wait(100) end
		blipCaricati = self.mostraBlip()

		while not playerCaricato do Citizen.Wait(500) end
		while not blipCaricati do Citizen.Wait(500) end

		while true do
			Citizen.Wait(Config.CheckDistanceWaitTowers * 1000)

			self.torrePiuVicina, distanza = Reti.getLowestDistanceTIndex(self.p_coords)

			if self.torrePiuVicina ~= 0 then
				self.torre = torriRadio[self.torrePiuVicina]
				self.potenzaSegnale = self.getPotenzaSegnale(distanza)

				if self.connectedTorreIndex == nil then
					self.agganciato = true
					self.vecchiaPotenzaSegnale = self.potenzaSegnale
					self.connectedTorreIndex = self.torrePiuVicina
					-- TriggerServerEvent("esx_wifi:connettiAllaTorre", self.idPlayer, self.torre.tower_label, self.potenzaSegnale)
				else
					if self.torrePiuVicina ~= self.connectedTorreIndex then
						self.vecchiaPotenzaSegnale = self.potenzaSegnale
						-- TriggerServerEvent("esx_wifi:cambiaTorreRadio", self.idPlayer, self.torre.tower_label, self.potenzaSegnale)
					else
						if self.potenzaSegnale ~= self.vecchiaPotenzaSegnale then
							self.vecchiaPotenzaSegnale = self.potenzaSegnale
							-- TriggerServerEvent("esx_wifi:cambiaTorreRadio", self.idPlayer, self.torre.tower_label, self.potenzaSegnale)
						end
					end
				end
			else
				if self.agganciato then
					self.agganciato = false
					self.connectedTorreIndex = nil
					self.vecchiaPotenzaSegnale = 0
					self.potenzaSegnale = 0
					-- TriggerServerEvent("esx_wifi:disconnettiDallaTorre", self.idPlayer)
				end
			end

			if Config.EnableSyncThread then TriggerServerEvent('esx_wifi:richiediTorriRadio') end

			TriggerEvent('gcphone:aggiornameAConnessione', self.potenzaSegnale)
		end
	end)

	-- thread per controllo distanza reti wifi
	Citizen.CreateThread(function()
		TriggerServerEvent('esx_wifi:richiediRetiWifi')

		local distanza = 0

		while true do
			Citizen.Wait(Config.CheckDistanceWaitWifi * 1000)

			self.retiWifiVicine = {}

			for i = 1, #retiWifi do
				distanza = Vdist(retiWifi[i].x, retiWifi[i].y, retiWifi[i].z, self.p_coords.x, self.p_coords.y, self.p_coords.z)

				if distanza < Config.RaggioWifi then
					if #self.retiWifiVicine > 0 then
						for reverseI = #self.retiWifiVicine, 1, -1 do
							if distanza > self.retiWifiVicine[reverseI].distanza then
								retiWifi[i].distanza = distanza
								table.insert(self.retiWifiVicine, retiWifi[i])
								break
							else
								if reverseI == #self.retiWifiVicine - 1 then
									retiWifi[i].distanza = distanza
									table.insert(self.retiWifiVicine, reverseI, retiWifi[i])
									break
								end
							end
						end
					else
						retiWifi[i].distanza = distanza
						table.insert(self.retiWifiVicine, retiWifi[i])
					end
				end
			end

			if Config.EnableSyncThread then TriggerServerEvent('esx_wifi:richiediRetiWifi') end

			TriggerEvent('gcphone:aggiornaRetiWifi', self.retiWifiVicine)
		end
	end)
end