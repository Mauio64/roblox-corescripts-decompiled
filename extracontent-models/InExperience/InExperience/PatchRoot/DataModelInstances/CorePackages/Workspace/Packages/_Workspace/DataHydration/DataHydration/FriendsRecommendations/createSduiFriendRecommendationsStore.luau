local DataHydration = script:FindFirstAncestor("DataHydration")

local createDataCache = require(DataHydration.createDataCache)
require(DataHydration.DataHydrationTypes)
require(script.Parent.SduiFriendRecommendationTypes)
local SduiRecommendationType = require(script.Parent.SduiRecommendationType)

local function createFriendRecommendationsStore()
	local dataCache = createDataCache()
	local set = {}

	return {
		getFriendRecommendation = function(p: string)
			local item = dataCache.getItem(p)
			return {
				data = function(p2)
					local data = item.data(p2)

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
					dataCache.replaceItem(k, { recommendationType = SduiRecommendationType.Invalid })
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
