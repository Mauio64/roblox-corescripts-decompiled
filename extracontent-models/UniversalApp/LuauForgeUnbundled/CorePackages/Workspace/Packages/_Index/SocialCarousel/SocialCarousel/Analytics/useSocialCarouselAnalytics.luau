local HttpService = game:GetService("HttpService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/React")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags")
local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SocialLuaAnalytics")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/UIBlox")

local useSocialCarouselContext = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Contexts/useSocialCarouselContext")
local initializeSocialCarouselAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Analytics/initializeSocialCarouselAnalytics")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Analytics/EventNames")
local getFriendStatusFromTileType = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Analytics/getFriendStatusFromTileType")
require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Common/Types")

local retrievalStatus = UIBlox.App.Loading.Enum.RetrievalStatus
local fFlagSocialCarouselEnableUserSeenEvents = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Flags").FFlagSocialCarouselEnableUserSeenEvents

local FFlagSocialCarouselLogNewFriendRequestsBadge = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Flags/FFlagSocialCarouselLogNewFriendRequestsBadge")
local fFlagSocialCarouselShareQREnabled = SharedFlags.FFlagSocialCarouselShareQREnabled
local fFlagLuaAppUserSeenCollectionUnifiedFields = SharedFlags.FFlagLuaAppUserSeenCollectionUnifiedFields

local repeatValue = SocialLuaAnalytics.Analytics.Formatters.repeatValue

return function()
	local v5 = useSocialCarouselContext()

	local v6 = React.useMemo(function()
		local sortAnalyticsData = v5.sortAnalyticsData

		local v10 = if sortAnalyticsData then sortAnalyticsData.sortIndex or nil else nil
		local v11 = if sortAnalyticsData then sortAnalyticsData.sortId or nil else nil
		local v12 = if sortAnalyticsData then sortAnalyticsData.appPage or nil else nil
		return initializeSocialCarouselAnalytics({
			infoForAllEvents = {
				sortIndex = v10,
				sortId = v11,
				appPage = v12,
				rowNumber = 1,
				feedRowNumber = sortAnalyticsData and sortAnalyticsData.startRow or nil
			}
		})
	end, { v5.sortAnalyticsData })

	local source = v5.source or ""

	local v7 = React.useCallback(function(data, p2)
		local fireAnalyticsEvent = v6.fireAnalyticsEvent
		local userPressed = EventNames.UserPressed
		local v8 = {
			presence = not data.presence and "Offline" or data.presence.userPresenceType,
			absolutePosition = p2.absolutePosition,
			positionInRow = p2.absolutePosition,
			friendId = data.id,
			friendStatus = getFriendStatusFromTileType(data.tileType),
			recommendationContextType = data.contextType,
			recommendationRank = data.rank,
			isRecommendation = data.contextType and true or false,
			universeId = 0,
			source = 0,
			interactionUuid = 0
		}
		local v9 = if data.presence then data.presence.universeId else nil
		v8.universeId = v9
		v8.source = source
		v8.interactionUuid = HttpService:GenerateGUID(false)
		fireAnalyticsEvent(userPressed, v8)
	end, { source, v6 })
	local v8

	if fFlagSocialCarouselEnableUserSeenEvents then
		v8 = React.useCallback(function(data, p2)
			local fireAnalyticsEvent = v6.fireAnalyticsEvent
			local userSeen = EventNames.UserSeen
			local v9 = {
				userId = data.id,
				presence = not data.presence and "Offline" or data.presence.userPresenceType,
				absolutePosition = p2.absolutePosition,
				friendStatus = getFriendStatusFromTileType(data.tileType),
				recommendationContextType = data.contextType,
				recommendationRank = 0,
				isRecommendation = 0,
				source = 0,
				universeId = 0
			}
			local v10 = if data.contextType then data.rank else nil
			v9.recommendationRank = v10
			v9.isRecommendation = data.contextType and true or false
			v9.source = source
			local v11 = if data.presence then data.presence.universeId else nil
			v9.universeId = v11
			fireAnalyticsEvent(userSeen, v9)
		end, { source })
	end

	local v9 = React.useCallback(function(data)
		local sortAnalyticsData = if fFlagLuaAppUserSeenCollectionUnifiedFields then v5.sortAnalyticsData else nil
		local startRow

		if fFlagLuaAppUserSeenCollectionUnifiedFields and sortAnalyticsData then
			startRow = sortAnalyticsData.startRow
		end

		local fireAnalyticsEvent = v6.fireAnalyticsEvent
		local tilesSeenCollection = EventNames.TilesSeenCollection
		local v10 = {
			userId = data.userIds,
			absolutePosition = data.absolutePositions,
			presence = data.presences,
			recommendationRank = data.recommendationRanks,
			friendStatus = data.friendStatuses,
			recommendationContextType = data.recommendationContextTypes,
			isRecommendation = data.isRecommendations,
			universeId = data.universeIds,
			tileCount = data.tileCount,
			source = source,
			sessionEventCount = data.sessionEventCount,
			contentType = 0,
			interactionUuid = 0,
			collectionId = 0,
			collectionPosition = 0,
			positionsInRow = 0,
			rowNumbers = 0,
			feedRowNumbers = 0,
			totalNumberOfItems = 0
		}
		local v11 = if fFlagLuaAppUserSeenCollectionUnifiedFields then data.contentType else nil
		v10.contentType = v11

		local v12 = if fFlagLuaAppUserSeenCollectionUnifiedFields then HttpService:GenerateGUID(false) else nil
		v10.interactionUuid = v12

		local v13 = if fFlagLuaAppUserSeenCollectionUnifiedFields and sortAnalyticsData then sortAnalyticsData.sortId else nil
		v10.collectionId = v13

		local v14 = if fFlagLuaAppUserSeenCollectionUnifiedFields and sortAnalyticsData then sortAnalyticsData.sortIndex else nil
		v10.collectionPosition = v14

		local v15 = if fFlagLuaAppUserSeenCollectionUnifiedFields then data.absolutePositions else nil
		v10.positionsInRow = v15

		local v16 = if fFlagLuaAppUserSeenCollectionUnifiedFields then repeatValue(1, data.tileCount) else nil
		v10.rowNumbers = v16

		local v17 = if fFlagLuaAppUserSeenCollectionUnifiedFields and startRow then repeatValue(startRow, data.tileCount) else nil
		v10.feedRowNumbers = v17

		v10.totalNumberOfItems = fFlagLuaAppUserSeenCollectionUnifiedFields and #v5.tiles or nil
		fireAnalyticsEvent(tilesSeenCollection, v10)
	end, { source, v6, v5.sortAnalyticsData, v5.tiles })

	local v10 = React.useCallback(function(p2)
		v6.fireAnalyticsEvent(EventNames.StartSquadPressed, {
			absolutePosition = p2,
			source = source
		})
	end, { source, v6 })
	local v11

	if fFlagSocialCarouselShareQREnabled then
		v11 = React.useCallback(function(p2)
			v6.fireAnalyticsEvent(EventNames.ShareQRPressed, {
				absolutePosition = p2,
				source = source
			})
		end, { source, v6 })
	end

	local v12 = React.useCallback(function(p2)
		v6.fireAnalyticsEvent(EventNames.ViewAddFriends, {
			friendCount = v5.friendCount,
			absolutePosition = p2,
			positionInRow = p2,
			recommendationCount = v5.recommendationCount,
			requestCount = v5.friendRequestCount,
			source = source,
			interactionUuid = HttpService:GenerateGUID(false)
		})
	end, { v5.friendCount, v5.recommendationCount, v5.friendRequestCount, source, v6 })
	local v13

	if FFlagSocialCarouselLogNewFriendRequestsBadge then
		v13 = React.useCallback(function(data)
			v6.fireAnalyticsEvent(EventNames.AddFriendsTileSeen, {
				newRequestCount = data.newRequestCount,
				previousCount = data.previousCount,
				trigger = data.trigger,
				badgeEnabled = data.badgeEnabled,
				badgeShown = data.badgeShown,
				badgeCapped = data.badgeCapped,
				absolutePosition = data.absolutePosition,
				source = source
			})
		end, { source, v6 })
	end

	local v14 = React.useCallback(function()
		v6.fireAnalyticsEvent(EventNames.ViewAllFriends, {
			friendCount = v5.friendCount,
			recommendationCount = v5.recommendationCount,
			source = source
		})
	end, { v5.friendCount, v5.recommendationCount, source, v6 })

	local v15 = React.useCallback(function(p2, value)
		local v16 = (not value or typeof(value) ~= "number" or value < 0) and 0 or value

		v6.fireAnalyticsEvent(EventNames.FriendsCarouselUILoadingTime, {
			loadingTime = v16,
			fetch = p2,
			status = retrievalStatus.Done.rawValue(),
			source = source
		})
	end, { source, v6 })

	if not fFlagSocialCarouselEnableUserSeenEvents then
		v8 = nil
	end

	if not FFlagSocialCarouselLogNewFriendRequestsBadge then
		v13 = nil
	end

	if not fFlagSocialCarouselShareQREnabled then
		v11 = nil
	end

	return {
		userPressed = v7,
		userSeen = v8,
		tilesSeenCollection = v9,
		addFriendsPressed = v12,
		addFriendsTileSeen = v13,
		friendsHeaderPressed = v14,
		reportLoadingEvent = v15,
		startSquadPressed = v10,
		shareQRPressed = v11
	}
end
