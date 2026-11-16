local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local UserInputService = game:GetService("UserInputService")

local React = require(parent.React)

local ReactUtils = require(parent.ReactUtils)
local useEventConnection = ReactUtils.useEventConnection

require(Foundation.Utility.Input.InputMode)
local getInputMode = require(Foundation.Utility.Input.getInputMode)

local function getLastInputMode()
	return getInputMode(UserInputService:GetLastInputType())
end

local function useLastInputMode()
	local state, setState = React.useState(getLastInputMode)

	useEventConnection(UserInputService.LastInputTypeChanged, function()
		setState(getLastInputMode())
	end)

	return state
end

return useLastInputMode
