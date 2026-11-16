local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/UserProfiles/SocialLuaAnalytics")
local fireDiagCounter = SocialLuaAnalytics.Analytics.FireEvent.fireDiagCounter
local fireDiag = SocialLuaAnalytics.Analytics.FireEvent.fireDiag

local FFlagUserProfilesLogErrorCodes = require("@game/CorePackages/Workspace/Packages/_Workspace/UserProfiles/UserProfiles/Flags/FFlagUserProfilesLogErrorCodes")

local DiagCountersList = require("@game/CorePackages/Workspace/Packages/_Workspace/UserProfiles/UserProfiles/Analytics/DiagCountersList")
require("@game/CorePackages/Workspace/Packages/_Workspace/UserProfiles/UserProfiles/Analytics/EventNames")

return function(p2)
	if FFlagUserProfilesLogErrorCodes then
		local v5 = fireDiag({ diagImpl = p2.analytics.Diag, eventList = DiagCountersList })

		return function(p3, p4)
			if DiagCountersList[p3] then
				return v5(p3, p4)
			end

			return p3
		end
	end

	local v5 = fireDiagCounter({ diagImpl = p2.analytics.Diag, eventList = DiagCountersList })

	return function(p3)
		if DiagCountersList[p3] then
			return v5(p3)
		end

		return p3
	end
end
