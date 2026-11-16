local module = require("@luauforge/deferred/ejq")

local AnalyticsSetup = require("@game/CorePackages/Workspace/Packages/_Workspace/UserRelationshipModals/UserRelationshipModals/Analytics/AnalyticsSetup")

local function useCoHubAnalytics(p2)
	return (module.useMemo(function()
		return AnalyticsSetup({ infoForAllEvents = p2 })
	end, { p2 }))
end

return useCoHubAnalytics
