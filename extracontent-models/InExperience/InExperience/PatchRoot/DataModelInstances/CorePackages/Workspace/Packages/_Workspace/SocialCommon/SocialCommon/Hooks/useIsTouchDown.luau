local parent = script.Parent.Parent
local parent2 = parent.Parent
local ReactUtils = require(parent2.ReactUtils)

local UserInputService = game:GetService("UserInputService")

local React = require(parent2.React)

local useEventConnection = ReactUtils.useEventConnection

local InputUtilities = require(parent.Utils.InputUtilities)

return function()
	local state, setState = React.useState(false)

	local v = React.useCallback(function(p)
		if InputUtilities.isTouchInput(p) then
			setState(true)
		end
	end, { setState })

	local v2 = React.useCallback(function(p)
		if InputUtilities.isTouchInput(p) then
			setState(false)
		end
	end, { setState })

	useEventConnection(UserInputService.InputBegan, v)
	useEventConnection(UserInputService.InputEnded, v2)

	return state
end
