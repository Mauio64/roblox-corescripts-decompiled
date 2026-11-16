local LocalizationService = game:GetService("LocalizationService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

local function useRobloxLocale()
	local state, setState = React.useState(LocalizationService.RobloxLocaleId)

	React.useEffect(function()
		local robloxLocaleIdChangedConnection = LocalizationService:GetPropertyChangedSignal("RobloxLocaleId"):Connect(function()
			setState(LocalizationService.RobloxLocaleId)
		end)

		return function()
			robloxLocaleIdChangedConnection:Disconnect()
		end
	end, {})

	return state
end

return useRobloxLocale
