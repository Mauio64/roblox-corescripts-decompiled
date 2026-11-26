local createSduiFriendRecommendationsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/FriendsRecommendations/createSduiFriendRecommendationsStore")

local v5 = {}

return {
	get = function(value)
		local v6 = value or "Home"
		local v7 = v5[v6]

		if v7 == nil then
			v7 = createSduiFriendRecommendationsStore()
			v5[v6] = v7
		end

		return v7
	end,
	dispose = function(p2)
		local v6 = v5[p2]

		if v6 then
			v6.dispose()
			v5[p2] = nil
		end
	end
}
