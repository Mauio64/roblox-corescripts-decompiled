local UserInputService = game:GetService("UserInputService")

local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)

local useEventConnection = ReactUtils.useEventConnection

local function resolveLayoutMode(data): string -- 1 equivalent call inferred from this helper
	if data.PreferredInput == Enum.PreferredInput.Gamepad then
		return "FlyOut"
	end

	if data.TouchEnabled and not data.MouseEnabled then
		return "Tray"
	end

	return "FlyOut"
end

local function useLayoutMode(p)
	local v = p or UserInputService
	local state, setState = React.useState(function()
		return resolveLayoutMode(v) -- inferred equivalent call
	end)

	local v2 = React.useCallback(function()
		local v2 = v
		setState(v2.PreferredInput == Enum.PreferredInput.Gamepad and "FlyOut" or v2.TouchEnabled and not v2.MouseEnabled and "Tray" or "FlyOut")
	end, { v })
	useEventConnection(v:GetPropertyChangedSignal("PreferredInput"), v2)

	return state
end

return useLayoutMode
