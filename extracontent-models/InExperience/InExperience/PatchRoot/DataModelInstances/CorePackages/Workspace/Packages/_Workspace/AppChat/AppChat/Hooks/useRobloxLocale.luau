local LocalizationService = game:GetService("LocalizationService")

local parent = script:FindFirstAncestor("AppChat").Parent
local React = require(parent.React)

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
