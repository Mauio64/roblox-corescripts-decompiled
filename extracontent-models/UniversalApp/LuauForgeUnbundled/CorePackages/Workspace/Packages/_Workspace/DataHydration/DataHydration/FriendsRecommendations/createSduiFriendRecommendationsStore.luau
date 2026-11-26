local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/FriendsRecommendations/SduiFriendRecommendationTypes")
local SduiRecommendationType = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/FriendsRecommendations/SduiRecommendationType")

local function createFriendRecommendationsStore()
	local v5 = createDataCache()
	local set = {}

	return {
		getFriendRecommendation = function(p2)
			local item = v5.getItem(p2)
			return {
				data = function(p3)
					local data = item.data(p3)

					if data and data.recommendationType ~= SduiRecommendationType.Invalid then
						return data
					end

					return nil
				end,
				status = item.status
			}
		end,
		replaceFriendRecommendations = function(items)
			for k in set do
				if items[k] == nil then
					v5.replaceItem(k, { recommendationType = SduiRecommendationType.Invalid })
				end
			end

			v5.replaceItems(items)
			set = {}

			for k in items do
				set[k] = true
			end
		end,
		dispose = function()
			set = {}
			v5.dispose()
		end
	}
end

return createFriendRecommendationsStore
