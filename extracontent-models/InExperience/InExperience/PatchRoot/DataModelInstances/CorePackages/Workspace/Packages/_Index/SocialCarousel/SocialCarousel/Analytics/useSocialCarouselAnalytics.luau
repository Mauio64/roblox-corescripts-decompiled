local HttpService = game:GetService("HttpService")
local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local parent = SocialCarousel.Parent
local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)
local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local UIBlox = require(parent.UIBlox)

local useSocialCarouselContext = require(SocialCarousel.Contexts.useSocialCarouselContext)
local initializeSocialCarouselAnalytics = require(SocialCarousel.Analytics.initializeSocialCarouselAnalytics)
local EventNames = require(SocialCarousel.Analytics.EventNames)
local getFriendStatusFromTileType = require(SocialCarousel.Analytics.getFriendStatusFromTileType)
require(SocialCarousel.Common.Types)

local RetrievalStatus = UIBlox.App.Loading.Enum.RetrievalStatus
local Flags = require(SocialCarousel.Flags)
local FFlagSocialCarouselEnableUserSeenEvents = Flags.FFlagSocialCarouselEnableUserSeenEvents

local FFlagSocialCarouselLogNewFriendRequestsBadge = require(SocialCarousel.Flags.FFlagSocialCarouselLogNewFriendRequestsBadge)
local FFlagSocialCarouselShareQREnabled = SharedFlags.FFlagSocialCarouselShareQREnabled
local FFlagLuaAppUserSeenCollectionUnifiedFields = SharedFlags.FFlagLuaAppUserSeenCollectionUnifiedFields
local FFlagSocialCarouselInGamePlayIcon = SharedFlags.FFlagSocialCarouselInGamePlayIcon

local repeatValue = SocialLuaAnalytics.Analytics.Formatters.repeatValue

return function()
	local v = useSocialCarouselContext()

	local v2 = React.useMemo(function()
		local sortAnalyticsData = v.sortAnalyticsData
		local sortIndex

		if sortAnalyticsData then
			sortIndex = sortAnalyticsData.sortIndex or nil
		end

		local sortId

		if sortAnalyticsData then
			sortId = sortAnalyticsData.sortId or nil
		end

		local appPage

		if sortAnalyticsData then
			appPage = sortAnalyticsData.appPage or nil
		end

		return initializeSocialCarouselAnalytics({
			infoForAllEvents = {
				sortIndex = sortIndex,
				sortId = sortId,
				appPage = appPage,
				rowNumber = 1,
				feedRowNumber = sortAnalyticsData and sortAnalyticsData.startRow or nil
			}
		})
	end, { v.sortAnalyticsData })

	local source = v.source or ""

	local userPressed = React.useCallback(function(data, p)
		local fireAnalyticsEvent = v2.fireAnalyticsEvent
		local userPressed = EventNames.UserPressed
		local v3 = {
			presence = not data.presence and "Offline" or data.presence.userPresenceType,
			absolutePosition = p.absolutePosition,
			positionInRow = p.absolutePosition,
			friendId = data.id,
			friendStatus = getFriendStatusFromTileType(data.tileType),
			recommendationContextType = data.contextType,
			recommendationRank = data.rank,
			isRecommendation = data.contextType and true or false,
			universeId = 0,
			source = 0,
			interactionUuid = 0,
			tileClickTarget = 0
		}
		local universeId

		if data.presence then
			universeId = data.presence.universeId
		end

		v3.universeId = universeId
		v3.source = source
		v3.interactionUuid = HttpService:GenerateGUID(false)
		local tileClickTarget

		if FFlagSocialCarouselInGamePlayIcon then
			tileClickTarget = p.tileClickTarget
		end

		v3.tileClickTarget = tileClickTarget
		fireAnalyticsEvent(userPressed, v3)
	end, { source, v2 })
	local userSeen2

	if FFlagSocialCarouselEnableUserSeenEvents then
		userSeen2 = React.useCallback(function(data, p)
			local fireAnalyticsEvent = v2.fireAnalyticsEvent
			local userSeen = EventNames.UserSeen
			local v3 = {
				userId = data.id,
				presence = not data.presence and "Offline" or data.presence.userPresenceType,
				absolutePosition = p.absolutePosition,
				friendStatus = getFriendStatusFromTileType(data.tileType),
				recommendationContextType = data.contextType,
				recommendationRank = 0,
				isRecommendation = 0,
				source = 0,
				universeId = 0
			}
			local recommendationRank

			if data.contextType then
				recommendationRank = data.rank
			end

			v3.recommendationRank = recommendationRank
			v3.isRecommendation = data.contextType and true or false
			v3.source = source
			local universeId

			if data.presence then
				universeId = data.presence.universeId
			end

			v3.universeId = universeId
			fireAnalyticsEvent(userSeen, v3)
		end, { source })
	end

	local tilesSeenCollection = React.useCallback(function(data)
		local sortAnalyticsData

		if FFlagLuaAppUserSeenCollectionUnifiedFields then
			sortAnalyticsData = v.sortAnalyticsData
		end

		local startRow

		if FFlagLuaAppUserSeenCollectionUnifiedFields and sortAnalyticsData then
			startRow = sortAnalyticsData.startRow
		end

		local fireAnalyticsEvent = v2.fireAnalyticsEvent
		local tilesSeenCollection = EventNames.TilesSeenCollection
		local v3 = {
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
		local contentType

		if FFlagLuaAppUserSeenCollectionUnifiedFields then
			contentType = data.contentType
		end

		v3.contentType = contentType
		local interactionUuid

		if FFlagLuaAppUserSeenCollectionUnifiedFields then
			interactionUuid = HttpService:GenerateGUID(false)
		end

		v3.interactionUuid = interactionUuid
		local collectionId

		if FFlagLuaAppUserSeenCollectionUnifiedFields and sortAnalyticsData then
			collectionId = sortAnalyticsData.sortId
		end

		v3.collectionId = collectionId
		local collectionPosition

		if FFlagLuaAppUserSeenCollectionUnifiedFields and sortAnalyticsData then
			collectionPosition = sortAnalyticsData.sortIndex
		end

		v3.collectionPosition = collectionPosition
		local positionsInRow

		if FFlagLuaAppUserSeenCollectionUnifiedFields then
			positionsInRow = data.absolutePositions
		end

		v3.positionsInRow = positionsInRow
		local rowNumbers

		if FFlagLuaAppUserSeenCollectionUnifiedFields then
			rowNumbers = repeatValue(1, data.tileCount)
		end

		v3.rowNumbers = rowNumbers
		local feedRowNumbers

		if FFlagLuaAppUserSeenCollectionUnifiedFields and startRow then
			feedRowNumbers = repeatValue(startRow, data.tileCount)
		end

		v3.feedRowNumbers = feedRowNumbers

		v3.totalNumberOfItems = FFlagLuaAppUserSeenCollectionUnifiedFields and #v.tiles or nil
		fireAnalyticsEvent(tilesSeenCollection, v3)
	end, { source, v2, v.sortAnalyticsData, v.tiles })

	local startSquadPressed = React.useCallback(function(absolutePosition: number)
		v2.fireAnalyticsEvent(EventNames.StartSquadPressed, {
			absolutePosition = absolutePosition,
			source = source
		})
	end, { source, v2 })
	local shareQRPressed

	if FFlagSocialCarouselShareQREnabled then
		shareQRPressed = React.useCallback(function(absolutePosition: number)
			v2.fireAnalyticsEvent(EventNames.ShareQRPressed, {
				absolutePosition = absolutePosition,
				source = source
			})
		end, { source, v2 })
	end

	local addFriendsPressed = React.useCallback(function(p: number)
		v2.fireAnalyticsEvent(EventNames.ViewAddFriends, {
			friendCount = v.friendCount,
			absolutePosition = p,
			positionInRow = p,
			recommendationCount = v.recommendationCount,
			requestCount = v.friendRequestCount,
			source = source,
			interactionUuid = HttpService:GenerateGUID(false)
		})
	end, { v.friendCount, v.recommendationCount, v.friendRequestCount, source, v2 })
	local addFriendsTileSeen

	if FFlagSocialCarouselLogNewFriendRequestsBadge then
		addFriendsTileSeen = React.useCallback(function(data)
			v2.fireAnalyticsEvent(EventNames.AddFriendsTileSeen, {
				newRequestCount = data.newRequestCount,
				previousCount = data.previousCount,
				trigger = data.trigger,
				badgeEnabled = data.badgeEnabled,
				badgeShown = data.badgeShown,
				badgeCapped = data.badgeCapped,
				absolutePosition = data.absolutePosition,
				source = source
			})
		end, { source, v2 })
	end

	local friendsHeaderPressed = React.useCallback(function()
		v2.fireAnalyticsEvent(EventNames.ViewAllFriends, {
			friendCount = v.friendCount,
			recommendationCount = v.recommendationCount,
			source = source
		})
	end, { v.friendCount, v.recommendationCount, source, v2 })

	local reportLoadingEvent = React.useCallback(function(fetch: string, value: number)
		local loadingTime = (not value or typeof(value) ~= "number" or value < 0) and 0 or value

		v2.fireAnalyticsEvent(EventNames.FriendsCarouselUILoadingTime, {
			loadingTime = loadingTime,
			fetch = fetch,
			status = RetrievalStatus.Done.rawValue(),
			source = source
		})
	end, { source, v2 })

	if not FFlagSocialCarouselEnableUserSeenEvents then
		userSeen2 = nil
	end

	if not FFlagSocialCarouselLogNewFriendRequestsBadge then
		addFriendsTileSeen = nil
	end

	if not FFlagSocialCarouselShareQREnabled then
		shareQRPressed = nil
	end

	return {
		userPressed = userPressed,
		userSeen = userSeen2,
		tilesSeenCollection = tilesSeenCollection,
		addFriendsPressed = addFriendsPressed,
		addFriendsTileSeen = addFriendsTileSeen,
		friendsHeaderPressed = friendsHeaderPressed,
		reportLoadingEvent = reportLoadingEvent,
		startSquadPressed = startSquadPressed,
		shareQRPressed = shareQRPressed
	}
end
