local FriendsCarousel = script:FindFirstAncestor("FriendsCarousel")
local dependencies = require(FriendsCarousel.dependencies)
local beforeAll = require(FriendsCarousel.devDependencies).JestGlobals.beforeAll

require(FriendsCarousel.Flags.getFIntShowFriendRecommendationsLimit)
beforeAll(function(_) -- line: 10
	-- upvalues: dependencies (copy)
	game:SetFastIntForTesting("ShowFriendRecommendationsLimit", 6)
	dependencies.RoduxNetworking.setNetworkImpl(function(p2) -- line: 13
		error(string.format("Should have replaced network implementation for url: %s", (tostring(p2))))
	end)
end)
