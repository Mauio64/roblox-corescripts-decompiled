local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local parent = SocialCarousel.Parent
local React = require(parent.React)
local Impressions = require(parent.Impressions)
local SharedFlags = require(parent.SharedFlags)
local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)

local getFriendStatusFromTileType = require(SocialCarousel.Analytics.getFriendStatusFromTileType)
local useSocialCarouselAnalytics = require(SocialCarousel.Analytics.useSocialCarouselAnalytics)
local Enums = require(SocialCarousel.Common.Enums)
local Tile = Enums.Tile
local buildUserSeenCollectionPayload = SocialLuaAnalytics.Analytics.buildUserSeenCollectionPayload
local useBatchedImpressions = Impressions.useBatchedImpressions
local FIntUserSeenCollectionBatchTimeMs = SharedFlags.FIntUserSeenCollectionBatchTimeMs
local FFlagLuaAppPYMKSendUserSeenCollection = SharedFlags.FFlagLuaAppPYMKSendUserSeenCollection
local FFlagLuaAppUserSeenCollectionUnifiedFields = SharedFlags.FFlagLuaAppUserSeenCollectionUnifiedFields
local FFlagShowRequestsInCarouselForAllUsers = SharedFlags.FFlagShowRequestsInCarouselForAllUsers

local function useTilesSeenCollection()
	local v = useSocialCarouselAnalytics()

	if FFlagLuaAppPYMKSendUserSeenCollection then
		local mapItem = React.useCallback(function(userId: string, p: number, data)
			return {
				userId = userId,
				index = p,
				presence = not (data and data.presence) and "Offline" or data.presence.userPresenceType,
				friendStatus = getFriendStatusFromTileType(data and data.tileType).Name,
				recommendationContextType = not (data and data.recommendationContextType) and "None" or data.recommendationContextType,
				recommendationRank = not (data and data.recommendationRank) and -1 or data.recommendationRank,
				isRecommendation = data and data.tileType == Tile.Recommendation,
				universeId = (not data or not data.presence or not data.presence.universeId or data.presence.universeId == "") and -1 or data.presence.universeId
			}
		end, {})

		local tilesSeenCollection = v.tilesSeenCollection
		local onFlush = React.useCallback(function(p, p2: number)
			if not tilesSeenCollection then
				return
			end

			tilesSeenCollection(buildUserSeenCollectionPayload(p, p2))
		end, { tilesSeenCollection })

		local v2 = {
			batchTimeMs = FIntUserSeenCollectionBatchTimeMs,
			mapItem = mapItem,
			onFlush = nil
		}

		if not tilesSeenCollection then
			onFlush = nil
		end

		v2.onFlush = onFlush
		local v3 = useBatchedImpressions(v2)

		local addTileToCollection = React.useCallback(function(p: string, p2: number, p3)
			if
				FFlagShowRequestsInCarouselForAllUsers
				and p3
				and p3.tileType == Tile.FriendRequest
				and not p3.presence
			then
				return
			end

			v3.addImpression(p, p2, p3)
		end, { v3.addImpression })

		return React.useMemo(function()
			return { addTileToCollection = addTileToCollection }
		end, { addTileToCollection })
	else
		local ref = React.useRef({})
		local ref2 = React.useRef(nil)
		local ref3 = React.useRef({})
		local ref4 = React.useRef({})
		local ref5 = React.useRef(0)

		local v2 = React.useCallback(function()
			local current = ref.current

			if #current == 0 then
				return
			end

			local userIds = {}
			local indices = {}

			local friendStatuses = {}

			local isRecommendations = {}
			local presences = {}

			local universeIds = {}
			local recommendationContextTypes = {}
			local recommendationRanks = {}

			for _, v2 in current do
				if not (v2 and v2.userId and v2.index) then
					continue
				end

				ref3.current[v2.userId] = true

				table.insert(userIds, (tostring(v2.userId)))
				table.insert(indices, (tostring(v2.index)))
				table.insert(friendStatuses, v2.friendStatus)
				table.insert(isRecommendations, (tostring(v2.isRecommendation)))
				table.insert(presences, (tostring(v2.presence)))
				table.insert(universeIds, (tostring(v2.universeId)))
				table.insert(recommendationContextTypes, (tostring(v2.recommendationContextType)))
				table.insert(recommendationRanks, (tostring(v2.recommendationRank)))
			end

			if v.tilesSeenCollection then
				ref5.current += 1
				local v2

				if FFlagLuaAppUserSeenCollectionUnifiedFields then
					v2 = buildUserSeenCollectionPayload(current, ref5.current)
				else
					v2 = {
						userIds = table.concat(userIds, ","),
						absolutePositions = table.concat(indices, ","),
						presences = table.concat(presences, ","),
						recommendationRanks = table.concat(recommendationRanks, ","),
						friendStatuses = table.concat(friendStatuses, ","),
						recommendationContextTypes = table.concat(recommendationContextTypes, ","),
						isRecommendations = table.concat(isRecommendations, ","),
						universeIds = table.concat(universeIds, ","),
						tileCount = #userIds,
						sessionEventCount = ref5.current
					}
				end

				v.tilesSeenCollection(v2)
			end

			ref.current = {}
			ref4.current = {}
		end, { v })

		local addTileToCollection = React.useCallback(function(userId: string, p: number, data)
			if not userId or not p or ref3.current[userId] or ref4.current[userId] then
				return
			end

			if
				FFlagShowRequestsInCarouselForAllUsers
				and data
				and data.tileType == Tile.FriendRequest
				and not data.presence
			then
				return
			end

			ref4.current[userId] = true
			table.insert(ref.current, {
				userId = userId,
				index = p,
				presence = not (data and data.presence) and "Offline" or data.presence.userPresenceType,
				friendStatus = getFriendStatusFromTileType(data and data.tileType).Name,
				recommendationContextType = not (data and data.recommendationContextType) and "None" or data.recommendationContextType,
				recommendationRank = not (data and data.recommendationRank) and -1 or data.recommendationRank,
				isRecommendation = data and data.tileType == Tile.Recommendation,
				universeId = (not data or not data.presence or not data.presence.universeId or data.presence.universeId == "") and -1 or data.presence.universeId
			})

			if ref2.current then
				pcall(task.cancel, ref2.current)
			end

			ref2.current = task.delay(FIntUserSeenCollectionBatchTimeMs * 0.001, v2)
		end, { v2 })

		React.useEffect(function()
			return function()
				if ref2.current then
					pcall(task.cancel, ref2.current)
				end

				ref2.current = nil
				v2()
			end
		end, {})

		return { addTileToCollection = addTileToCollection }
	end
end

return useTilesSeenCollection
