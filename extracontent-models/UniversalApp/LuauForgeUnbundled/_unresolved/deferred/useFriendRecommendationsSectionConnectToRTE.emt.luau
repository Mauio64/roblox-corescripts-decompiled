local useLocalUserId = require("@luauforge/deferred/eiQ").useLocalUserId
local useRealtimeNamespace = require("@luauforge/deferred/emi").useRealtimeNamespace

local module = require("@luauforge/deferred/elU")

local module2 = require("@luauforge/deferred/emr")
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
