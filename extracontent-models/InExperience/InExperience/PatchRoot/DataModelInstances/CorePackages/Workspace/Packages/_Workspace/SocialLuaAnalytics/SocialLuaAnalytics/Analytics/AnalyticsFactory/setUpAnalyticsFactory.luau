local Parent = script:FindFirstAncestor("SocialLuaAnalytics").Parent
local Cryo = require(Parent.Cryo)
local AnalyticsFactory = require(script.Parent.AnalyticsFactory)

require(script.Parent.Parent.Types)

local function setUpAnalyticsFactory(t1: {[any]: any}) -- line: 29
	-- upvalues: Cryo (copy), AnalyticsFactory (copy)
	return function(t2: {[any]: any}?) -- line: 30
		-- upvalues: Cryo (copy), t1 (copy), AnalyticsFactory (copy)
		local v7 = Cryo.Dictionary.join(t1.staticInfoForAllEvents or {}, t2 and t2.infoForAllEvents or {})

		return AnalyticsFactory(Cryo.Dictionary.join(t1, {
			infoForAllEvents = v7
		}))
	end
end

return setUpAnalyticsFactory
