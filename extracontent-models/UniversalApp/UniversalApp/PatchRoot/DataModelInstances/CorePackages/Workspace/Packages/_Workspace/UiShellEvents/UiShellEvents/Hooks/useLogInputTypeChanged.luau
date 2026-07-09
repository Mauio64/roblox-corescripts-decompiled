local UiShellEvents = script:FindFirstAncestor("UiShellEvents")
local UserInputService = game:GetService("UserInputService")
local UiShellEventsParent = UiShellEvents.Parent
local React = require(UiShellEventsParent.React)
local logInputTypeChanged = require(UiShellEvents.Analytics.logInputTypeChanged)
local useInputType = require(UiShellEventsParent.RoactUtils).Hooks.useInputType
local useIsTvRemoteDevice = require(UiShellEventsParent.RoactUtils).Hooks.useIsTvRemoteDevice
local v8 = game:DefineFastFlag("LogInputTypeChangedTvRemote1", false)

local function getConnectedGamepadTypes(p1) -- line: 11
	-- upvalues: UserInputService (copy)
	if p1 == nil then
		return nil
	end

	local t1 = {}

	for _, v15 in p1 do
		if not UserInputService:GamepadSupports(v15, Enum.KeyCode.Return) then
			table.insert(t1, "full_gamepad")
		else
			table.insert(t1, "tv_remote")
		end
	end

	return t1
end
local function anyFullGamepadConnected(p2) -- line: 27
	-- upvalues: UserInputService (copy)
	if p2 == nil then
		return nil
	end

	for _, v18 in p2 do
		if not UserInputService:GamepadSupports(v18, Enum.KeyCode.Return) then
			return true
		end
	end

	return false
end
local function useLogInputTypeChanged(p3, s1: string?) -- line: 40
	-- upvalues: useInputType (copy), v8 (copy), useIsTvRemoteDevice (copy), UserInputService (copy), anyFullGamepadConnected (copy), getConnectedGamepadTypes (copy), React (copy), logInputTypeChanged (copy)
	local v21 = useInputType()
	local v22 = if not v8 then nil else useIsTvRemoteDevice()
	local v23 = if not v8 then nil else UserInputService:GetConnectedGamepads()
	local v24 = if not v8 then nil else anyFullGamepadConnected(v23)
	local v25 = if not v8 then nil else getConnectedGamepadTypes(v23)
	local v26 = if not v25 then nil else table.concat(v25, ",")

	React.useEffect(function() -- line: 57
		-- upvalues: UserInputService (copy), logInputTypeChanged (copy), p3 (copy), v21 (copy), v24 (copy), v26 (copy), v22 (copy), s1 (copy)
		local GamepadConnected = UserInputService:GetGamepadConnected(Enum.UserInputType.Gamepad1)

		logInputTypeChanged(p3, "inputTypeChanged", {
			inputType = v21,
			gamepadConnected = GamepadConnected,
			anyFullGamepadConnected = v24,
			connectedGamepads = v26,
			isTvRemote = v22,
			playSessionId = s1
		})
	end, {
		v21,
		v26
	})
end

return useLogInputTypeChanged
