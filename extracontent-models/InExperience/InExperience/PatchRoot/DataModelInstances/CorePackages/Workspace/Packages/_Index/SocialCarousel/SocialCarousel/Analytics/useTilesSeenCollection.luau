local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local SocialCarouselParent = SocialCarousel.Parent
local React = require(SocialCarouselParent.React)
local useSocialCarouselAnalytics = require(SocialCarousel.Analytics.useSocialCarouselAnalytics)
local Tile = require(SocialCarousel.Common.Enums).Tile
local v6 = game:DefineFastInt("UserSeenCollectionBatchTimeMs", 200)
local _ = {
	Friend = "Friend",
	NotFriend = "NotFriend"
}

local function useTilesSeenCollection() -- line: 42
	-- upvalues: useSocialCarouselAnalytics (copy), React (copy), Tile (copy), v6 (copy)
	local v9 = useSocialCarouselAnalytics()
	local v10 = React.useRef({})
	local v11 = React.useRef(nil)
	local v12 = React.useRef({})
	local v13 = React.useRef({})
	local v14 = React.useRef(0)
	local v15 = React.useCallback(function() -- line: 52
		-- upvalues: v10 (copy), v12 (copy), v9 (copy), v14 (copy), v13 (copy)
		local current = v10.current

		if #current == 0 then
			return
		end

		local t1 = {}
		local t2 = {}
		local t3 = {}
		local t4 = {}
		local t5 = {}
		local t6 = {}
		local t7 = {}
		local t8 = {}

		for _, v27 in current do
			if v27 and v27.userId and v27.index then
				v12.current[v27.userId] = true
				table.insert(t1, (tostring(v27.userId)))
				table.insert(t2, (tostring(v27.index)))
				table.insert(t5, v27.friendStatus)
				table.insert(t7, (tostring(v27.isRecommendation)))
				table.insert(t3, (tostring(v27.presence)))
				table.insert(t8, (tostring(v27.universeId)))
				table.insert(t6, (tostring(v27.recommendationContextType)))
				table.insert(t4, (tostring(v27.recommendationRank)))
			end
		end

		if v9.tilesSeenCollection then
			v14.current = v14.current + 1
			v9.tilesSeenCollection({
				userIds = table.concat(t1, ","),
				absolutePositions = table.concat(t2, ","),
				presences = table.concat(t3, ","),
				recommendationRanks = table.concat(t4, ","),
				friendStatuses = table.concat(t5, ","),
				recommendationContextTypes = table.concat(t6, ","),
				isRecommendations = table.concat(t7, ","),
				universeIds = table.concat(t8, ","),
				tileCount = #t1,
				sessionEventCount = v14.current
			})
		end

		v10.current = {}
		v13.current = {}
	end, { v9 })
	local v16 = React.useCallback(function(s1: string, n1: number, t9: {[any]: any}?) -- line: 108
		-- upvalues: v12 (copy), v13 (copy), v10 (copy), Tile (copy), v11 (copy), v6 (copy), v15 (copy)
		if not s1 or (not n1 or v12.current[s1] or v13.current[s1]) then
			return
		end

		v13.current[s1] = true
		table.insert(v10.current, {
			userId = s1,
			index = n1,
			presence = (not t9 or not t9.presence) and "Offline" or t9.presence.userPresenceType,
			friendStatus = (not t9 or t9.tileType ~= Tile.Friend) and "NotFriend" or "Friend",
			recommendationContextType = (not t9 or not t9.recommendationContextType) and "None" or t9.recommendationContextType,
			recommendationRank = (not t9 or not t9.recommendationRank) and -1 or t9.recommendationRank,
			isRecommendation = t9 and t9.tileType == Tile.Recommendation,
			universeId = (not t9 or (not t9.presence or (not t9.presence.universeId or t9.presence.universeId == ""))) and -1 or t9.presence.universeId
		})

		if v11.current then
			pcall(task.cancel, v11.current)
		end

		v11.current = task.delay(v6 * 0.001, v15)
	end, { v15 })

	React.useEffect(function() -- line: 148
		-- upvalues: v11 (copy), v15 (copy)
		return function() -- line: 149
			-- upvalues: v11 (copy), v15 (copy)
			if v11.current then
				pcall(task.cancel, v11.current)
			end

			v11.current = nil
			v15()
		end
	end, {})

	return {
		addTileToCollection = v16
	}
end

return useTilesSeenCollection
