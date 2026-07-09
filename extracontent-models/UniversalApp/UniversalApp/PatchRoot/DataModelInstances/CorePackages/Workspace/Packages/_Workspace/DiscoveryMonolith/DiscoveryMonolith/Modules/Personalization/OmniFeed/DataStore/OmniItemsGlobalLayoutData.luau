local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local Cryo = require(DiscoveryMonolithParent.Cryo)

require(DiscoveryMonolithParent.DiscoveryTypes)

local AppPage = require(DiscoveryMonolithParent.RobloxAppEnums).AppPage
local Modules = DiscoveryMonolith.Modules
local AddOmniRecommendations = require(Modules.LuaApp.Actions.Games.AddOmniRecommendations)

return function(p1, p2) -- line: 12
	-- upvalues: AddOmniRecommendations (copy), AppPage (copy), Cryo (copy)
	local v9 = p1 or {}

	if p2.type == AddOmniRecommendations.name then
		local recommendations = p2.recommendations

		for k, v in pairs(recommendations) do
			if k == AppPage.Home then
				assert(k == v.pageType, "Should match page type")

				if v.globalLayoutData then
					v9 = if not p2.isAppend then Cryo.Dictionary.join({}, v.globalLayoutData) else Cryo.Dictionary.join(v9, v.globalLayoutData)
				end
			end
		end
	end

	return v9
end
