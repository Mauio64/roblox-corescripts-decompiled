local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local Cryo = require(DiscoveryMonolithParent.Cryo)
local Modules = DiscoveryMonolith.Modules
local SetOmniRecommendationsRefreshTime = require(Modules.LuaApp.Actions.Games.SetOmniRecommendationsRefreshTime)

return function(p1, p2) -- line: 9
	-- upvalues: SetOmniRecommendationsRefreshTime (copy), Cryo (copy)
	local v8 = p1 or {}

	if p2.type == SetOmniRecommendationsRefreshTime.name then
		v8 = Cryo.Dictionary.join(v8, {
			[p2.pageType] = p2.refreshTime
		})
	end

	return v8
end
