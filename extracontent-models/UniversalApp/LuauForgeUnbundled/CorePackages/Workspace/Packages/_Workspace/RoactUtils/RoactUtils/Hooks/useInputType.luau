local UserInputService = game:GetService("UserInputService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/React")
local useExternalEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/RoactUtils/Hooks/useExternalEvent")
local getInputGroup = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/InputType").getInputGroup

local function useInputType(p2)
	local v5 = p2 or UserInputService

	local function getLastInputType()
		return getInputGroup((v5:GetLastInputType()))
	end

	local state, setState = React.useState(getLastInputType)

	local v6 = React.useCallback(function(p3)
		local inputGroup = getInputGroup(p3)

		if inputGroup ~= nil then
			setState(inputGroup)
		end
	end)

	useExternalEvent(v5.LastInputTypeChanged, v6)

	React.useEffect(function()
		setState(getLastInputType())
	end, {})

	return state
end

return useInputType
