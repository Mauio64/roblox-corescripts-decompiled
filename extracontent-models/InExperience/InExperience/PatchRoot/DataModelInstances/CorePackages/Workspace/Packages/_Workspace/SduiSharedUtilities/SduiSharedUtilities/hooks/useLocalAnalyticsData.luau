local parent = script:FindFirstAncestor("SduiSharedUtilities").Parent
local React = require(parent.React)

local function useLocalAnalyticsData(configKey: string, appPage: string, p)
	return React.useMemo(function()
		local selected = not p and {} or p
		selected.configKey = configKey
		selected.appPage = appPage
		return selected
	end, { configKey, appPage, p })
end

return useLocalAnalyticsData
