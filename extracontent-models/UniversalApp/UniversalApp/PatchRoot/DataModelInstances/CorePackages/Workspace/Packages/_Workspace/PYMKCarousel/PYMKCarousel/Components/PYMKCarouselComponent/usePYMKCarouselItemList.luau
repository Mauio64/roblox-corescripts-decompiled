local ParentParent = script.Parent.Parent.Parent
local React = require(ParentParent.dependencies).React
local BtnValues = require(ParentParent.Analytics).BtnValues
local getFIntPYMKSeeAllTileLimit = require(ParentParent.Flags.getFIntPYMKSeeAllTileLimit)

local function usePYMKCarouselItemList(t1: {[any]: any}) -- line: 26
	-- upvalues: React (copy), BtnValues (copy), getFIntPYMKSeeAllTileLimit (copy)
	return React.useMemo(function() -- line: 32
		-- upvalues: t1 (copy), BtnValues (copy), getFIntPYMKSeeAllTileLimit (copy)
		if not t1.findFriendsTileEnabled and not t1.seeAllTileEnabled then
			return t1.recommendationIds
		end

		local v7 = table.clone(t1.recommendationIds)

		if t1.findFriendsTileEnabled then
			table.insert(v7, 1, {
				isButtonTile = true,
				id = BtnValues.FindFriends.rawValue()
			})

			if t1.recommendationCount == 0 then
				table.insert(v7, {
					id = "_findFriendsTooltip",
					isTooltip = true
				})
			end
		end

		if t1.seeAllTileEnabled and t1.recommendationCount > getFIntPYMKSeeAllTileLimit() then
			table.insert(v7, {
				isButtonTile = true,
				id = BtnValues.SeeAll.rawValue()
			})
		end

		return v7
	end, {
		t1.recommendationIds,
		t1.findFriendsTileEnabled
	})
end

return usePYMKCarouselItemList
