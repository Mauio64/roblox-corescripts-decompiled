local UiShellEvents = script:FindFirstAncestor("UiShellEvents")
local UserInputService = game:GetService("UserInputService")
local parent = UiShellEvents.Parent
local React = require(parent.React)
local logInputTypeChanged = require(UiShellEvents.Analytics.logInputTypeChanged)
local RoactUtils = require(parent.RoactUtils)
local useInputType = RoactUtils.Hooks.useInputType
local RoactUtils2 = require(parent.RoactUtils)
local useIsTvRemoteDevice = RoactUtils2.Hooks.useIsTvRemoteDevice

local defineFastFlag = game:DefineFastFlag("LogInputTypeChangedTvRemote1", false)

local function getConnectedGamepadTypes(connectedGamepads)
	if connectedGamepads == nil then
		return nil
	end

	local result = {}

	for _, item in connectedGamepads do
		if UserInputService:GamepadSupports(item, Enum.KeyCode.Return) then
			table.insert(result, "tv_remote")
		else
			table.insert(result, "full_gamepad")
		end
	end

	return result
end

local function anyFullGamepadConnected(connectedGamepads): nil | boolean
	if connectedGamepads == nil then
		return nil
	end

	for _, item in connectedGamepads do
		if not UserInputService:GamepadSupports(item, Enum.KeyCode.Return) then
			return true
		end
	end

	return false
end

local function useLogInputTypeChanged(p, playSessionId: string?)
	local inputType = useInputType()
	local isTvRemote

	if defineFastFlag then
		isTvRemote = useIsTvRemoteDevice()
	else
		isTvRemote = nil
	end

	local connectedGamepads

	if defineFastFlag then
		connectedGamepads = UserInputService:GetConnectedGamepads()
	end

	local anyFullGamepadConnected2

	if defineFastFlag then
		anyFullGamepadConnected2 = anyFullGamepadConnected(connectedGamepads)
	else
		anyFullGamepadConnected2 = nil
	end

	local v

	if defineFastFlag then
		v = getConnectedGamepadTypes(connectedGamepads)
	end

	local joined

	if v then
		joined = table.concat(v, ",")
	else
		joined = nil
	end

	React.useEffect(function()
		logInputTypeChanged(p, "inputTypeChanged", {
			inputType = inputType,
			gamepadConnected = UserInputService:GetGamepadConnected(Enum.UserInputType.Gamepad1),
			anyFullGamepadConnected = anyFullGamepadConnected2,
			connectedGamepads = joined,
			isTvRemote = isTvRemote,
			playSessionId = playSessionId
		})
	end, { inputType, joined })
end

return useLogInputTypeChanged
