local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent
local React = require(parent.React)

local Services = require(Foundation.Utility.Wrappers.Services)
local UserInputService = Services.UserInputService

local function usePreferredInput()
	local state, setState = React.useState(UserInputService.PreferredInput)

	React.useEffect(function()
		local preferredInputChangedConnection = UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function()
			setState(UserInputService.PreferredInput)
		end)

		setState(UserInputService.PreferredInput)

		return function()
			if preferredInputChangedConnection then
				preferredInputChangedConnection:Disconnect()
			end
		end
	end, {})

	return state
end

return usePreferredInput
