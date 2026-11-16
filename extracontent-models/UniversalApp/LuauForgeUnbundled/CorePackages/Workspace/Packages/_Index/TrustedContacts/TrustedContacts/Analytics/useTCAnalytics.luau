local React = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/React")

local AnalyticsSetup = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Analytics/AnalyticsSetup")

local function useTCAnalytics(p2)
	return (React.useMemo(function()
		return AnalyticsSetup({ infoForAllEvents = p2 })
	end, { p2 }))
end

return useTCAnalytics
