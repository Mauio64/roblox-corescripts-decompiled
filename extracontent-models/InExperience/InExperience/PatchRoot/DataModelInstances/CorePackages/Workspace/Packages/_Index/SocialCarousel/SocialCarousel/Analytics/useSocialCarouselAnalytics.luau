local HttpService = game:GetService("HttpService")
local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local SocialCarouselParent = SocialCarousel.Parent
local React = require(SocialCarouselParent.React)
local UIBlox = require(SocialCarouselParent.UIBlox)
local useSocialCarouselContext = require(SocialCarousel.Contexts.useSocialCarouselContext)
local initializeSocialCarouselAnalytics = require(SocialCarousel.Analytics.initializeSocialCarouselAnalytics)
local EventNames = require(SocialCarousel.Analytics.EventNames)
local Tile = require(SocialCarousel.Common.Enums).Tile

require(SocialCarousel.Common.Types)

local RetrievalStatus = UIBlox.App.Loading.Enum.RetrievalStatus
local FFlagSocialCarouselEnableUserSeenEvents = require(SocialCarousel.Flags).FFlagSocialCarouselEnableUserSeenEvents
local FFlagLuaAppAddSortDataToSocialCarouselClicks = require(SocialCarouselParent.SharedFlags).FFlagLuaAppAddSortDataToSocialCarouselClicks
local FFlagSocialCarouselShareQREnabled = require(SocialCarouselParent.SharedFlags).FFlagSocialCarouselShareQREnabled

return function() -- line: 22
	-- upvalues: FFlagLuaAppAddSortDataToSocialCarouselClicks (copy), useSocialCarouselContext (copy), React (copy), initializeSocialCarouselAnalytics (copy), EventNames (copy), Tile (copy), HttpService (copy), FFlagSocialCarouselEnableUserSeenEvents (copy), FFlagSocialCarouselShareQREnabled (copy), RetrievalStatus (copy)
	local u14, u15

	if FFlagLuaAppAddSortDataToSocialCarouselClicks then
		u14 = useSocialCarouselContext()
		u15 = React.useMemo(function() -- line: 28
			-- upvalues: u14 (ref), initializeSocialCarouselAnalytics (copy)
			local sortAnalyticsData = u14.sortAnalyticsData

			return initializeSocialCarouselAnalytics({
				infoForAllEvents = {
					rowNumber = 1,
					sortIndex = sortAnalyticsData and sortAnalyticsData.sortIndex or nil,
					sortId = sortAnalyticsData and sortAnalyticsData.sortId or nil,
					appPage = sortAnalyticsData and sortAnalyticsData.appPage or nil,
					feedRowNumber = sortAnalyticsData and sortAnalyticsData.startRow or nil
				}
			})
		end, { u14.sortAnalyticsData })
	else
		u15 = initializeSocialCarouselAnalytics()
		u14 = useSocialCarouselContext()
	end

	local v16 = u14.source or ""
	local v17 = React.useCallback(function(p1, p2) -- line: 53
		-- upvalues: u15 (ref), EventNames (copy), FFlagLuaAppAddSortDataToSocialCarouselClicks (copy), Tile (copy), v16 (copy), HttpService (copy)
		u15.fireAnalyticsEvent(EventNames.UserPressed, {
			presence = not p1.presence and "Offline" or p1.presence.userPresenceType,
			absolutePosition = p2.absolutePosition,
			positionInRow = if not FFlagLuaAppAddSortDataToSocialCarouselClicks then nil else p2.absolutePosition,
			friendId = p1.id,
			friendStatus = if p1.tileType ~= Tile.Friend then Enum.FriendStatus.NotFriend else Enum.FriendStatus.Friend,
			recommendationContextType = p1.contextType,
			recommendationRank = p1.rank,
			isRecommendation = not not p1.contextType,
			universeId = if not p1.presence then nil else p1.presence.universeId,
			source = v16,
			interactionUuid = HttpService:GenerateGUID(false)
		})
	end, {
		v16,
		if not FFlagLuaAppAddSortDataToSocialCarouselClicks then nil else u15
	})
	local v18 = if not FFlagSocialCarouselEnableUserSeenEvents then nil else React.useCallback(function(p3, p4) -- line: 79
		-- upvalues: u15 (ref), EventNames (copy), Tile (copy), v16 (copy)
		u15.fireAnalyticsEvent(EventNames.UserSeen, {
			userId = p3.id,
			presence = not p3.presence and "Offline" or p3.presence.userPresenceType,
			absolutePosition = p4.absolutePosition,
			friendStatus = if p3.tileType ~= Tile.Friend then Enum.FriendStatus.NotFriend else Enum.FriendStatus.Friend,
			recommendationContextType = p3.contextType,
			recommendationRank = if not p3.contextType then nil else p3.rank,
			isRecommendation = not not p3.contextType,
			source = v16,
			universeId = if not p3.presence then nil else p3.presence.universeId
		})
	end, { v16 })
	local v19 = React.useCallback(function(t1: {[any]: any}) -- line: 97
		-- upvalues: u15 (ref), EventNames (copy), v16 (copy)
		u15.fireAnalyticsEvent(EventNames.TilesSeenCollection, {
			userId = t1.userIds,
			absolutePosition = t1.absolutePositions,
			presence = t1.presences,
			recommendationRank = t1.recommendationRanks,
			friendStatus = t1.friendStatuses,
			recommendationContextType = t1.recommendationContextTypes,
			isRecommendation = t1.isRecommendations,
			universeId = t1.universeIds,
			tileCount = t1.tileCount,
			source = v16,
			sessionEventCount = t1.sessionEventCount
		})
	end, {
		v16,
		if not FFlagLuaAppAddSortDataToSocialCarouselClicks then nil else u15
	})
	local v20 = React.useCallback(function(n1: number) -- line: 130
		-- upvalues: u15 (ref), EventNames (copy), v16 (copy)
		u15.fireAnalyticsEvent(EventNames.StartSquadPressed, {
			absolutePosition = n1,
			source = v16
		})
	end, {
		v16,
		if not FFlagLuaAppAddSortDataToSocialCarouselClicks then nil else u15
	})
	local v21 = if not FFlagSocialCarouselShareQREnabled then nil else React.useCallback(function(n2: number) -- line: 144
		-- upvalues: u15 (ref), EventNames (copy), v16 (copy)
		u15.fireAnalyticsEvent(EventNames.ShareQRPressed, {
			absolutePosition = n2,
			source = v16
		})
	end, {
		v16,
		u15
	})
	local v22 = React.useCallback(function(n3: number) -- line: 158
		-- upvalues: u15 (ref), EventNames (copy), u14 (ref), v16 (copy), HttpService (copy)
		u15.fireAnalyticsEvent(EventNames.ViewAddFriends, {
			friendCount = u14.friendCount,
			absolutePosition = n3,
			positionInRow = n3,
			recommendationCount = u14.recommendationCount,
			requestCount = u14.friendRequestCount,
			source = v16,
			interactionUuid = HttpService:GenerateGUID(false)
		})
	end, {
		u14.friendCount,
		u14.recommendationCount,
		u14.friendRequestCount,
		v16,
		if not FFlagLuaAppAddSortDataToSocialCarouselClicks then nil else u15
	})
	local v23 = React.useCallback(function() -- line: 179
		-- upvalues: u15 (ref), EventNames (copy), u14 (ref), v16 (copy)
		u15.fireAnalyticsEvent(EventNames.ViewAllFriends, {
			friendCount = u14.friendCount,
			recommendationCount = u14.recommendationCount,
			source = v16
		})
	end, {
		u14.friendCount,
		u14.recommendationCount,
		v16,
		if not FFlagLuaAppAddSortDataToSocialCarouselClicks then nil else u15
	})
	local v24 = React.useCallback(function(s1: string, n4: number) -- line: 195
		-- upvalues: u15 (ref), EventNames (copy), RetrievalStatus (copy), v16 (copy)
		local v36 = if not not n4 and (typeof(n4) == "number" and not (n4 < 0)) then n4 else 0

		u15.fireAnalyticsEvent(EventNames.FriendsCarouselUILoadingTime, {
			loadingTime = v36,
			fetch = s1,
			status = RetrievalStatus.Done.rawValue(),
			source = v16
		})
	end, {
		v16,
		if not FFlagLuaAppAddSortDataToSocialCarouselClicks then nil else u15
	})

	return {
		userPressed = v17,
		userSeen = if not FFlagSocialCarouselEnableUserSeenEvents then nil else v18,
		tilesSeenCollection = v19,
		addFriendsPressed = v22,
		friendsHeaderPressed = v23,
		reportLoadingEvent = v24,
		startSquadPressed = v20,
		shareQRPressed = if not FFlagSocialCarouselShareQREnabled then nil else v21
	}
end
