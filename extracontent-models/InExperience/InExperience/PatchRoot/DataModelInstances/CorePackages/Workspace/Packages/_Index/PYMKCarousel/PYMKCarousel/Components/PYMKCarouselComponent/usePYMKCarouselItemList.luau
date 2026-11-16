local parent = script.Parent.Parent.Parent

local dependencies = require(parent.dependencies)

local react = dependencies.React
local Analytics = require(parent.Analytics)
local BtnValues = Analytics.BtnValues

local getFIntPYMKSeeAllTileLimit = require(parent.Flags.getFIntPYMKSeeAllTileLimit)
require(parent.Common.DirectRecommendationTypes)

local function usePYMKCarouselItemList(data)
	return react.useMemo(function()
		if not (data.findFriendsTileEnabled or data.seeAllTileEnabled) then
			return data.recommendationIds
		end

		local clone = table.clone(data.recommendationIds)

		if data.findFriendsTileEnabled then
			table.insert(clone, 1, {
				id = BtnValues.FindFriends.rawValue(),
				isButtonTile = true
			})

			if data.recommendationCount == 0 then
				table.insert(clone, { id = "_findFriendsTooltip", isTooltip = true })
			end
		end

		if data.seeAllTileEnabled and data.recommendationCount > getFIntPYMKSeeAllTileLimit() then
			table.insert(clone, { id = BtnValues.SeeAll.rawValue(), isButtonTile = true })
		end

		return clone
	end, { data.recommendationIds, data.findFriendsTileEnabled })
end

return usePYMKCarouselItemList
