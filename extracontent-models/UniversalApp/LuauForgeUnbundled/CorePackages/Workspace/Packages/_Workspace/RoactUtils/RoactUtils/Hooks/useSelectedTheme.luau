local NotificationService = game:GetService("NotificationService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/React")

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
