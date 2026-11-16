local useLocalUserId = require("@luauforge/deferred/efV").useLocalUserId
local useRealtimeNamespace = require("@luauforge/deferred/eiN").useRealtimeNamespace

local module = require("@luauforge/deferred/eiz")

local module2 = require("@luauforge/deferred/eiW")
local friendsRecommendationsStore = module2.FriendsRecommendationsStore
local dataSource = module2.Enums.DataSource

local function useFriendRecommendationsSectionConnectToRTE()
	local v5 = tostring(useLocalUserId())

	useRealtimeNamespace("FriendshipNotifications", function(p2)
		if not p2.EventArgs then
			return
		end

		if p2.Type == "FriendshipCreated" and not module then
			local v6 = tostring(p2.EventArgs.UserId1)
			local userId2 = tostring(p2.EventArgs.UserId2)

			if v5 == v6 then
				v6 = userId2
			end

			friendsRecommendationsStore.get().removeFriendsRecommendationByUserId(
				dataSource.AddFriendsPage,
				v6
			)
		end
	end, { v5 })
end

return useFriendRecommendationsSectionConnectToRTE
