local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local AppPage = require(DiscoveryMonolithParent.RobloxAppEnums).AppPage
local OmniFeedConstants = require(DiscoveryMonolithParent.DiscoveryTypes).OmniFeedConstants
local Modules = DiscoveryMonolith.Modules
local ApiFetchOmniRecommendations = require(Modules.LuaApp.Thunks.Omni.ApiFetchOmniRecommendations)

local function refreshOmniRecommendations(p1, p2, p3, p4) -- line: 10
	-- upvalues: ApiFetchOmniRecommendations (copy), AppPage (copy), OmniFeedConstants (copy)
	return p3:dispatch(ApiFetchOmniRecommendations(p1, p2, AppPage.Home, nil, nil, OmniFeedConstants.OmniRecommendationsRequestIntent.GameExit, p4)):catch(function(p5) -- line: 23
		warn("We failed to refresh omni recommendations on game exit!", p5)
	end)
end

return function(p6, p7, p8) -- line: 28
	-- upvalues: refreshOmniRecommendations (copy)
	return function(p9) -- line: 29
		-- upvalues: refreshOmniRecommendations (copy), p6 (copy), p7 (copy), p8 (copy)
		return refreshOmniRecommendations(p6, p7, p9, p8)
	end
end
