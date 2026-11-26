local react = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/dependencies").React
local btnValues = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Analytics").BtnValues

local getFIntPYMKSeeAllTileLimit = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Flags/getFIntPYMKSeeAllTileLimit")
require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Common/DirectRecommendationTypes")

local function usePYMKCarouselItemList(data)
	return react.useMemo(function()
		if not (data.findFriendsTileEnabled or data.seeAllTileEnabled) then
			return data.recommendationIds
		end

		local clone = table.clone(data.recommendationIds)

		if data.findFriendsTileEnabled then
			table.insert(clone, 1, {
				id = btnValues.FindFriends.rawValue(),
				isButtonTile = true
			})

			if data.recommendationCount == 0 then
				table.insert(clone, { id = "_findFriendsTooltip", isTooltip = true })
			end
		end

		if data.seeAllTileEnabled and data.recommendationCount > getFIntPYMKSeeAllTileLimit() then
			table.insert(clone, {
				id = btnValues.SeeAll.rawValue(),
				isButtonTile = true
			})
		end

		return clone
	end, { data.recommendationIds, data.findFriendsTileEnabled })
end

return usePYMKCarouselItemList
