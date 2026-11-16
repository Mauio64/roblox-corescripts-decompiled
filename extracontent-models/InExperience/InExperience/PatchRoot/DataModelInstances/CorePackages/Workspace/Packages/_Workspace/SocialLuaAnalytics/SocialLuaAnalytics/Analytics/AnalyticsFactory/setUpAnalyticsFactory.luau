local parent = script:FindFirstAncestor("SocialLuaAnalytics").Parent

local Cryo = require(parent.Cryo)

local AnalyticsFactory = require(script.Parent.AnalyticsFactory)

require(script.Parent.Parent.Types)

local function setUpAnalyticsFactory(p)
	return function(p2)
		local joined = Cryo.Dictionary.join(p.staticInfoForAllEvents or {}, p2 and p2.infoForAllEvents or {})

		return AnalyticsFactory(Cryo.Dictionary.join(p, { infoForAllEvents = joined }))
	end
end

return setUpAnalyticsFactory
