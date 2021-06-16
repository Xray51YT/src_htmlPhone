function Reti.loadRetiWifi()
	-- local reti = MySQL.Sync.fetchAll('SELECT * FROM phone_wifi_nets', {})
	-- for i = 1, #CACHED_WIFIS do
	-- 	reti[i].pos = vector3(reti[i].x, reti[i].y, reti[i].z)
	-- end
	for _, v in pairs(CACHED_WIFIS) do
		v.pos = vector3(v.x, v.y, v.z)
	end
	return CACHED_WIFIS
end

function Reti.updateCellTower(tower)
	if tower then
		MySQL.Async.execute("UPDATE phone_cell_towers SET tower_label = @label, x = @x, y = @y, broken = @broken WHERE id = @id", {
			['@label'] = tower.tower_label,
			['@x'] = tower.x,
			['@y'] = tower.y,
			['@broken'] = tower.broken,
			['@id'] = tower.id
		})
	end
end

function Reti.AddReteWifi(source, rete, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('INSERT INTO phone_wifi_nets (steam_id, label, password, x, y, z, due_date) VALUES (@steam_id, @label, @password, @x, @y, @z, @due_date)', {
		['@steam_id'] = xPlayer.identifier,
		['@label'] = rete.label,
		['@password'] = rete.password,
		['@x'] = tonumber(string.format("%." .. 3 .. "f", rete.coords.x)),
		['@y'] = tonumber(string.format("%." .. 3 .. "f", rete.coords.y)),
		['@z'] = tonumber(string.format("%." .. 3 .. "f", rete.coords.z)),
		['@due_date'] = os.date("%Y-%m-%d %H:%m:%S", rete.due_date)
	}, function(rowsChanged)
		if rowsChanged > 0 then
			xPlayer.showNotification(Config.Language["WIFI_MODEM_CREATED_OK"])

			retiWifi = Reti.loadRetiWifi()
			Reti.Debug(Config.Language["WIFI_LOAD_DEBUG_4"])

			if cb ~= nil then cb(true) end
		else
			xPlayer.showNotification(Config.Language["WIFI_MODEM_CREATED_ERROR"])
			if cb ~= nil then cb(false) end
		end
	end)
end

function Reti.RemoveReteWifi(source, rete)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('DELETE * FROM phone_wifi_nets WHERE steam_id = @steam_id', {
		['@steam_id'] = rete.owner_id
	}, function(rowsChanged)
		if rowsChanged > 0 then
			xPlayer.showNotification(Config.Language["WIFI_MODEM_DELETE_OK"])

			retiWifi = Reti.loadRetiWifi()
			Reti.Debug(Config.Language["WIFI_LOAD_DEBUG_4"])
		else
			xPlayer.showNotification(Config.Language["WIFI_MODEM_DELETE_ERROR"])
		end
	end)
end

function Reti.UpdateReteWifi(source, rete, param)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE phone_wifi_nets SET '..param..' = @'..param..' WHERE steam_id = @steam_id', {
		['@steam_id'] = tostring(xPlayer.identifier),
		['@'..param] = rete[param]
	}, function(rowsChanged)
		if rowsChanged > 0 then
			xPlayer.showNotification(Config.Language["WIFI_MODEM_UPDATE_OK"])

			retiWifi = Reti.loadRetiWifi()
			Reti.Debug(Config.Language["WIFI_LOAD_DEBUG_4"])
		else
			xPlayer.showNotification(Config.Language["WIFI_MODEM_UPDATE_ERROR"])
		end
	end)
end

--[[
	function Reti.doesReteExist(retiWifi, owner_id)
		local rete = nil
		for i=1, #retiWifi do
			rete = retiWifi[i]
			if rete.steam_id == owner_id then
				return true
			end
		end

		return false
	end

	function Reti.getRandomWiFiSSID()
		ssid = Config.DefaultRandomSSID
		
		for i = 1, 8 do
			ssid = ssid..tostring(math.random(0,9))
		end
		
		return ssid
	end

	function Reti.getRandomChar()
		randomChar = nil
		
		charValue = 0
		charRangeIndex = math.random(1, 3)
		
		if charRangeIndex == 1 then
			randomChar = string.char(math.random(48, 57))
		elseif charRangeIndex == 2 then
			randomChar = string.char(math.random(65, 90))
		elseif charRangeIndex == 3 then
			randomChar = string.char(math.random(97, 122))
		end
		
		return randomChar
	end


	function Reti.getRandomWiFiPassword()
		password = ""
		
		for i = 1, 8 do
			password = password .. Reti.getRandomChar()
		end
		
		return password
	end


	function Reti.creaReteWifi(identifier, x, y)
		rete = {}
		
		math.randomseed(os.time())
		
		rete.owner_id = identifier
		rete.ssid = Reti.getRandomWiFiSSID()
		rete.password = Reti.getRandomWiFiPassword()
		rete.x = x
		rete.y = y
		
		return rete
	end

	function Reti.RinnovaRete(startingDate)
		local day = 86400
		local days = day * Config.AddDaysOnRenewal

		return os.time(os.date('*t', startingDate)) + days
	end
]]

function Reti.CheckDueDate()
	Reti.Debug(Config.Language["WIFI_LOAD_DEBUG_5"])
	
	for index, rete in pairs(CACHED_WIFIS) do
		if rete.not_expire == 0 then
			local due_date = math.floor(rete.due_date / 1000)
			local created = math.floor(rete.created / 1000)

			if os.difftime(created, due_date) >= 0 then
				Reti.Debug(Config.Language["WIFI_LOAD_DEBUG_6"]:format(rete.steam_id))

				MySQL.Async.execute("DELETE FROM phone_wifi_nets WHERE steam_id = @steam_id AND label = @label", {
					['@steam_id'] = rete.steam_id,
					['@label'] = rete.label
				})
			end
		else
			Reti.Debug(Config.Language["WIFI_LOAD_DEBUG_7"]:format(rete.steam_id))
		end
	end
end