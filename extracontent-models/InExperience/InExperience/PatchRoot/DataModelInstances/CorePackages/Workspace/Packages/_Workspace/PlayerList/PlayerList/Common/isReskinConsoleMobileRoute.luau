local parent = script.Parent.Parent
local parent2 = parent.Parent

local FFlagPlayerListReskin = require(parent.Flags.FFlagPlayerListReskin)
local FFlagEnableMobilePlayerListOnConsole = require(parent.Flags.FFlagEnableMobilePlayerListOnConsole)
local FFlagEnableMobilePlayerListOnGamepad = require(parent.Flags.FFlagEnableMobilePlayerListOnGamepad)

local SharedFlags = require(parent2.SharedFlags)
local FFlagLuaSupportMicroGamepadPreferredInput = SharedFlags.FFlagLuaSupportMicroGamepadPreferredInput

local function isGamepadPreferredInput(preferredInput, flag: boolean) -- 1 equivalent call inferred from this helper
	return preferredInput == Enum.PreferredInput.Gamepad or flag and preferredInput == Enum.PreferredInput.MicroGamepad
end

local function isReskinConsoleMobileRoute(p, data)
	local v

	if data == nil then
		v = FFlagPlayerListReskin
	else
		v = data.isReskinEnabled
	end

	local v2

	if data == nil then
		v2 = FFlagEnableMobilePlayerListOnConsole
	else
		v2 = data.isConsoleMobileEnabled
	end

	local v3

	if data == nil then
		v3 = FFlagEnableMobilePlayerListOnGamepad
	else
		v3 = data.isGamepadMobileEnabled
	end

	local v4

	if data == nil then
		v4 = FFlagLuaSupportMicroGamepadPreferredInput
	else
		v4 = data.isMicroGamepadEnabled
	end

	if not v then
		return false
	end

	local gamepadPreferredInput = isGamepadPreferredInput(p.preferredInput, v4) -- inferred equivalent call
	local v5 = p.preferredInput == Enum.PreferredInput.Touch or gamepadPreferredInput

	if v2 and v5 and p.displaySize == Enum.DisplaySize.Large then
		return true
	end

	return v3 and gamepadPreferredInput
end

return isReskinConsoleMobileRoute
