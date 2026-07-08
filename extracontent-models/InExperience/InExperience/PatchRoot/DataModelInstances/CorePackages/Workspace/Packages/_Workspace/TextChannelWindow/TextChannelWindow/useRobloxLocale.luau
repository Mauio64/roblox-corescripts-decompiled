local LocalizationService = game:GetService("LocalizationService")
local ParentParent = script.Parent.Parent
local React = require(ParentParent.React)
local useEventConnection = require(ParentParent.ReactUtils).useEventConnection

local function useRobloxLocale() -- line: 7
	-- upvalues: React (copy), LocalizationService (copy), useEventConnection (copy)
	local v6, v7 = React.useState(LocalizationService.RobloxLocaleId)

	useEventConnection(LocalizationService:GetPropertyChangedSignal("RobloxLocaleId"), function() -- line: 10
		-- upvalues: v7 (copy), LocalizationService (copy)
		v7(LocalizationService.RobloxLocaleId)
	end, {})

	return v6
end

return useRobloxLocale
