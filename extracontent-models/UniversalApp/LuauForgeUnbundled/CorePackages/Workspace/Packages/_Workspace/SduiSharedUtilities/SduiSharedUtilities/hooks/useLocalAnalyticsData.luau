local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/React")

local function useLocalAnalyticsData(configKey, appPage, p2)
	return React.useMemo(function()
		local v5 = not p2 and {} or p2
		v5.configKey = configKey
		v5.appPage = appPage
		return v5
	end, { configKey, appPage, p2 })
end

return useLocalAnalyticsData
