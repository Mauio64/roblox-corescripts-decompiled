local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/React")
local Impressions = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Impressions")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags")
local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SocialLuaAnalytics")

local getFriendStatusFromTileType = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Analytics/getFriendStatusFromTileType")
local useSocialCarouselAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Analytics/useSocialCarouselAnalytics")
local tile = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Common/Enums").Tile
local buildUserSeenCollectionPayload = SocialLuaAnalytics.Analytics.buildUserSeenCollectionPayload
local useBatchedImpressions = Impressions.useBatchedImpressions
local fIntUserSeenCollectionBatchTimeMs = SharedFlags.FIntUserSeenCollectionBatchTimeMs
local fFlagLuaAppPYMKSendUserSeenCollection = SharedFlags.FFlagLuaAppPYMKSendUserSeenCollection
local fFlagLuaAppUserSeenCollectionUnifiedFields = SharedFlags.FFlagLuaAppUserSeenCollectionUnifiedFields
local fFlagShowRequestsInCarouselForAllUsers = SharedFlags.FFlagShowRequestsInCarouselForAllUsers

local function useTilesSeenCollection()
	local v5 = useSocialCarouselAnalytics()

	if fFlagLuaAppPYMKSendUserSeenCollection then
		local v6 = React.useCallback(function(p2, p3, data)
			return {
				userId = p2,
				index = p3,
				presence = not (data and data.presence) and "Offline" or data.presence.userPresenceType,
				friendStatus = getFriendStatusFromTileType(data and data.tileType).Name,
				recommendationContextType = not (data and data.recommendationContextType) and "None" or data.recommendationContextType,
				recommendationRank = not (data and data.recommendationRank) and -1 or data.recommendationRank,
				isRecommendation = data and data.tileType == tile.Recommendation,
				universeId = (not data or not data.presence or not data.presence.universeId or data.presence.universeId == "") and -1 or data.presence.universeId
			}
		end, {})

		local tilesSeenCollection = v5.tilesSeenCollection
		local v7 = React.useCallback(function(p2, p3)
			if not tilesSeenCollection then
				return
			end

			tilesSeenCollection(buildUserSeenCollectionPayload(p2, p3))
		end, { tilesSeenCollection })

		local v9 = {
			batchTimeMs = fIntUserSeenCollectionBatchTimeMs,
			mapItem = v6,
			onFlush = nil
		}

		if not tilesSeenCollection then
			v7 = nil
		end

		v9.onFlush = v7
		local v10 = useBatchedImpressions(v9)

		local v11 = React.useCallback(function(p2, p3, p4)
			if
				fFlagShowRequestsInCarouselForAllUsers
				and p4
				and p4.tileType == tile.FriendRequest
				and not p4.presence
			then
				return
			end

			v10.addImpression(p2, p3, p4)
		end, { v10.addImpression })

		return React.useMemo(function()
			return { addTileToCollection = v11 }
		end, { v11 })
	else
		local ref = React.useRef({})
		local ref2 = React.useRef(nil)
		local ref3 = React.useRef({})
		local ref4 = React.useRef({})
		local ref5 = React.useRef(0)

		local v6 = React.useCallback(function()
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

			for k, v7 in current do
				if not (v7 and v7.userId and v7.index) then
					continue
				end

				ref3.current[v7.userId] = true

				table.insert(userIds, (tostring(v7.userId)))
				table.insert(indices, (tostring(v7.index)))
				table.insert(friendStatuses, v7.friendStatus)
				table.insert(isRecommendations, (tostring(v7.isRecommendation)))
				table.insert(presences, (tostring(v7.presence)))
				table.insert(universeIds, (tostring(v7.universeId)))
				table.insert(recommendationContextTypes, (tostring(v7.recommendationContextType)))
				table.insert(recommendationRanks, (tostring(v7.recommendationRank)))
			end

			if v5.tilesSeenCollection then
				ref5.current += 1

				local v7 = if fFlagLuaAppUserSeenCollectionUnifiedFields then buildUserSeenCollectionPayload(current, ref5.current) else {
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

				v5.tilesSeenCollection(v7)
			end

			ref.current = {}
			ref4.current = {}
		end, { v5 })

		local v7 = React.useCallback(function(p2, p3, data)
			if not p2 or not p3 or ref3.current[p2] or ref4.current[p2] then
				return
			end

			if
				fFlagShowRequestsInCarouselForAllUsers
				and data
				and data.tileType == tile.FriendRequest
				and not data.presence
			then
				return
			end

			ref4.current[p2] = true
			table.insert(ref.current, {
				userId = p2,
				index = p3,
				presence = not (data and data.presence) and "Offline" or data.presence.userPresenceType,
				friendStatus = getFriendStatusFromTileType(data and data.tileType).Name,
				recommendationContextType = not (data and data.recommendationContextType) and "None" or data.recommendationContextType,
				recommendationRank = not (data and data.recommendationRank) and -1 or data.recommendationRank,
				isRecommendation = data and data.tileType == tile.Recommendation,
				universeId = (not data or not data.presence or not data.presence.universeId or data.presence.universeId == "") and -1 or data.presence.universeId
			})

			if ref2.current then
				pcall(task.cancel, ref2.current)
			end

			ref2.current = task.delay(fIntUserSeenCollectionBatchTimeMs * 0.001, v6)
		end, { v6 })

		React.useEffect(function()
			return function()
				if ref2.current then
					pcall(task.cancel, ref2.current)
				end

				ref2.current = nil
				v6()
			end
		end, {})

		return { addTileToCollection = v7 }
	end
end

return useTilesSeenCollection
