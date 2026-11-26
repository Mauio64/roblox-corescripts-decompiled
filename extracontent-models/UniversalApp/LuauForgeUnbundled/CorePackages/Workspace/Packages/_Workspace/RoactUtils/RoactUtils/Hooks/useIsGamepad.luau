local UserInputService = game:GetService("UserInputService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/React")
local useExternalEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/RoactUtils/Hooks/useExternalEvent")
local isGamepadInput = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/RoactUtils/isGamepadInput")

local function useIsGamepad(p2)
	local v5 = p2 or UserInputService

	local function wasLastInputGamepad()
		return isGamepadInput((v5:GetLastInputType()))
	end

	local state, setState = React.useState(wasLastInputGamepad)

	local v6 = React.useCallback(function(p3)
		local v7 = isGamepadInput(p3)

		if v7 ~= nil then
			setState(v7)
		end
	end)

	useExternalEvent(v5.LastInputTypeChanged, v6)

	React.useEffect(function()
		setState(wasLastInputGamepad())
	end, {})

	return state
end

return useIsGamepad
