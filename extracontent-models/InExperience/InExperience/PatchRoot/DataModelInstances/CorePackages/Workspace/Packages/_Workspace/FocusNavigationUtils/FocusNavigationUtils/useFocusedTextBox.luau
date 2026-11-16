local UserInputService = game:GetService("UserInputService")
local parent = script:FindFirstAncestor("FocusNavigationUtils").Parent
local React = require(parent.React)

return function(callback, callback2)
	local state, setState = React.useState(nil)
	React.useEffect(function()
		local textBoxFocusedConnection = UserInputService.TextBoxFocused:Connect(function(p)
			setState(p)

			if callback then
				callback(p)
			end
		end)

		local textBoxFocusReleasedConnection = UserInputService.TextBoxFocusReleased:Connect(function(p)
			setState(nil)

			if callback2 then
				callback2(p)
			end
		end)

		return function()
			textBoxFocusedConnection:Disconnect()
			textBoxFocusReleasedConnection:Disconnect()
		end
	end, { setState })

	return state
end
