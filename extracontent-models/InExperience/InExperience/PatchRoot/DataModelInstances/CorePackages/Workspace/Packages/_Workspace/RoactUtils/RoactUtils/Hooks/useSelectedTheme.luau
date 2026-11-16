local NotificationService = game:GetService("NotificationService")

local parent = script:FindFirstAncestor("RoactUtils").Parent

local React = require(parent.React)

local function useSelectedTheme()
	local state, setState = React.useState(string.lower(NotificationService.SelectedTheme))

	React.useEffect(function()
		local selectedThemeChangedConnection = NotificationService:GetPropertyChangedSignal("SelectedTheme"):Connect(function()
			setState(string.lower(NotificationService.SelectedTheme))
		end)

		return function()
			selectedThemeChangedConnection:Disconnect()
		end
	end)

	return state
end

return useSelectedTheme
