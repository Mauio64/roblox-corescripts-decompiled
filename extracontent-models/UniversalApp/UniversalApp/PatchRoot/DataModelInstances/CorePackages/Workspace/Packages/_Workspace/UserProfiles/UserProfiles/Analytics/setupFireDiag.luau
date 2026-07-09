local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local SocialLuaAnalytics = require(ParentParentParent.SocialLuaAnalytics)
local fireDiagCounter = SocialLuaAnalytics.Analytics.FireEvent.fireDiagCounter
local fireDiag = SocialLuaAnalytics.Analytics.FireEvent.fireDiag
local FFlagUserProfilesLogErrorCodes = require(ParentParent.Flags.FFlagUserProfilesLogErrorCodes)
local DiagCountersList = require(script.Parent.DiagCountersList)

require(script.Parent.EventNames)

return function(t1: {[any]: any}) -- line: 14
	-- upvalues: FFlagUserProfilesLogErrorCodes (copy), fireDiag (copy), DiagCountersList (copy), fireDiagCounter (copy)
	if FFlagUserProfilesLogErrorCodes then
		local v9 = fireDiag({
			diagImpl = t1.analytics.Diag,
			eventList = DiagCountersList
		})

		return function(p1, p2) -- line: 23
			-- upvalues: DiagCountersList (copy), v9 (copy)
			if DiagCountersList[p1] then
				return v9(p1, p2)
			end

			return p1
		end
	end

	local v10 = fireDiagCounter({
		diagImpl = t1.analytics.Diag,
		eventList = DiagCountersList
	})

	return function(p3) -- line: 36
		-- upvalues: DiagCountersList (copy), v10 (copy)
		if DiagCountersList[p3] then
			return v10(p3)
		end

		return p3
	end
end
