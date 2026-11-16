local UserInputService = game:GetService("UserInputService")
local parent = script:FindFirstAncestor("RoactUtils").Parent

local React = require(parent.React)
local useExternalEvent = require(script.Parent.useExternalEvent)
local InputType = require(parent.InputType)
local getInputGroup = InputType.getInputGroup

local function useInputType(p)
	local v = p or UserInputService

	local function getLastInputType()
		return getInputGroup((v:GetLastInputType()))
	end

	local state, setState = React.useState(getLastInputType)

	local v2 = React.useCallback(function(p2)
		local inputGroup = getInputGroup(p2)

		if inputGroup ~= nil then
			setState(inputGroup)
		end
	end)

	useExternalEvent(v.LastInputTypeChanged, v2)

	React.useEffect(function()
		setState(getLastInputType())
	end, {})

	return state
end

return useInputType
