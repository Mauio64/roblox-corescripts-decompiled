local parent = script:FindFirstAncestor("Moments").Parent

local UserInputService = game:GetService("UserInputService")

local React = require(parent.React)

return function()
	local state, setState = React.useState(UserInputService.PreferredInput)

	React.useEffect(function()
		local preferredInputChangedConnection = UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function()
			setState(UserInputService.PreferredInput)
		end)

		return function()
			preferredInputChangedConnection:Disconnect()
		end
	end, {})

	return state
end
