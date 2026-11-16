local LocalizationService = game:GetService("LocalizationService")

local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)
local useEventConnection = ReactUtils.useEventConnection

local function useRobloxLocale()
	local state, setState = React.useState(LocalizationService.RobloxLocaleId)

	useEventConnection(LocalizationService:GetPropertyChangedSignal("RobloxLocaleId"), function()
		setState(LocalizationService.RobloxLocaleId)
	end, {})

	return state
end

return useRobloxLocale
