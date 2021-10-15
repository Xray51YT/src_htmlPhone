local enabled = true
local HUD_ELEMENTS = {
    HUD = 0,
    HUD_WANTED_STARS = 1,
    HUD_WEAPON_ICON = 2,
    HUD_CASH = 3,
    HUD_MP_CASH = 4,
    HUD_MP_MESSAGE = 5,
    HUD_VEHICLE_NAME = 6,
    HUD_AREA_NAME = 7,
    HUD_VEHICLE_CLASS = 8,
    HUD_STREET_NAME = 9,
    HUD_HELP_TEXT = 10,
    HUD_FLOATING_HELP_TEXT_1 = 11,
    HUD_FLOATING_HELP_TEXT_2 = 12,
    HUD_CASH_CHANGE = 13,
    HUD_RETICLE = 14,
    HUD_SUBTITLE_TEXT = 15,
    HUD_RADIO_STATIONS = 16,
    HUD_SAVING_GAME = 17,
    HUD_GAME_STREAM = 18,
    HUD_WEAPON_WHEEL = 19,
    HUD_WEAPON_WHEEL_STATS = 20,
    MAX_HUD_COMPONENTS = 21,
    MAX_HUD_WEAPONS = 22,
    MAX_SCRIPTED_HUD_COMPONENTS = 141
}

local CellFrontCamActivate = function(activate)
	return Citizen.InvokeNative(0x2491A93618B7D838, activate)
end

local function HideHudLoop()
    Citizen.CreateThreadNow(function()
        while enabled do
            for _, id in pairs(HUD_ELEMENTS) do HideHudComponentThisFrame(id) end
            HideHudAndRadarThisFrame()
            Citizen.Wait(0)
        end
    end)
end

local function OpenFakeCamera(data, cb)
    enabled = true
	local frontCam = false
	CreateMobilePhone(1)
	CellCamActivate(true, true)
    HideHudLoop()
    -- if ignore controls is true, then send a callback to js
    -- to let the code continue with its things
    if data.ignoreControls then cb("ok") end
	while enabled do
		if IsControlJustPressed(1, 172) then -- ARROW UP
			frontCam = not frontCam
			CellFrontCamActivate(frontCam)
		elseif IsControlJustPressed(1, 177) and not data.ignoreControls then -- CANCEL
            cb(false)
        elseif IsControlJustPressed(1, 176) and not data.ignoreControls then -- ENTER
            cb(true)
		end
        Citizen.Wait(0)
	end
    -- destroy and delete fake camera effect
    DestroyMobilePhone()
    CellCamActivate(false, false)
    -- play animation to player :)
	PhonePlayOut()
	ClearPedTasksImmediately(GetPlayerPed(-1))
	Citizen.Wait(100)
	PhonePlayText()
end

RegisterNUICallback('openFakeCamera', function(data, cb) Citizen.CreateThreadNow(function() OpenFakeCamera(data, cb) end) end)
RegisterNUICallback('setEnabledFakeCamera', function(data, cb) enabled = data end)