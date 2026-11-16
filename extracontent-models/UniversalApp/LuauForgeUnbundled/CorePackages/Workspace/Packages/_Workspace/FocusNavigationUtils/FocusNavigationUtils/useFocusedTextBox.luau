local UserInputService = game:GetService("UserInputService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/React")

return function(callback, callback2)
	local state, setState = React.useState(nil)
	React.useEffect(function()
		local textBoxFocusedConnection = UserInputService.TextBoxFocused:Connect(function(p2)
			setState(p2)

			if callback then
				callback(p2)
			end
		end)

		local textBoxFocusReleasedConnection = UserInputService.TextBoxFocusReleased:Connect(function(p2)
			setState(nil)

			if callback2 then
				callback2(p2)
			end
		end)

		return function()
			textBoxFocusedConnection:Disconnect()
			textBoxFocusReleasedConnection:Disconnect()
		end
	end, { setState })

	return state
end
