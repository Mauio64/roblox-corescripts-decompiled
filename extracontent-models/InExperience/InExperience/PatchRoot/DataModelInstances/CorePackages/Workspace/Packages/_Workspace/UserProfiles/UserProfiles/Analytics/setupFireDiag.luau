local parent = script.Parent.Parent
local parent2 = parent.Parent

local SocialLuaAnalytics = require(parent2.SocialLuaAnalytics)
local fireDiagCounter = SocialLuaAnalytics.Analytics.FireEvent.fireDiagCounter
local fireDiag = SocialLuaAnalytics.Analytics.FireEvent.fireDiag

local FFlagUserProfilesLogErrorCodes = require(parent.Flags.FFlagUserProfilesLogErrorCodes)

local DiagCountersList = require(script.Parent.DiagCountersList)
require(script.Parent.EventNames)

return function(p)
	if FFlagUserProfilesLogErrorCodes then
		local v = fireDiag({ diagImpl = p.analytics.Diag, eventList = DiagCountersList })

		return function(p2, p3)
			if DiagCountersList[p2] then
				return v(p2, p3)
			end

			return p2
		end
	end

	local v = fireDiagCounter({ diagImpl = p.analytics.Diag, eventList = DiagCountersList })

	return function(p2)
		if DiagCountersList[p2] then
			return v(p2)
		end

		return p2
	end
end
