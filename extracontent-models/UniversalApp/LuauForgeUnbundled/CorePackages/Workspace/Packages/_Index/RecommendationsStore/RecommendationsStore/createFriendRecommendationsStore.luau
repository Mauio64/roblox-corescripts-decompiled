local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/RecommendationsStore/DataHydration")
require("@game/CorePackages/Workspace/Packages/_Index/RecommendationsStore/RecommendationsStore/FriendRecommendationTypes")
local RecommendationType = require("@game/CorePackages/Workspace/Packages/_Index/RecommendationsStore/RecommendationsStore/RecommendationType")

local function createFriendRecommendationsStore()
	local dataCache = DataHydration.createDataCache()
	local set = {}

	return {
		getFriendRecommendation = function(p2)
			local item = dataCache.getItem(p2)
			return {
				data = function(p3)
					local data = item.data(p3)

					if data and data.recommendationType ~= RecommendationType.Invalid then
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
					dataCache.replaceItem(k, { recommendationType = RecommendationType.Invalid })
				end
			end

			dataCache.replaceItems(items)
			set = {}

			for k in items do
				set[k] = true
			end
		end,
		dispose = function()
			set = {}
			dataCache.dispose()
		end
	}
end

return createFriendRecommendationsStore
