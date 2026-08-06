local GameCollections = script:FindFirstAncestor("GameCollections")
local GameCollectionsParent = GameCollections.Parent
local React = require(GameCollectionsParent.React)
local Responsive = require(GameCollectionsParent.Responsive)
local usePreferredInput = Responsive.usePreferredInput
local useBreakpointXOrSmaller = Responsive.useBreakpointXOrSmaller
local GameTile = require(GameCollectionsParent.GameTile)
local GameTileConstants = GameTile.GameTileConstants
local GameTileLayoutType = GameTile.GameTileTypes.GameTileLayoutType
local AppGameTile = GameTile.AppGameTile
local getTileBadgeByPositionConfigFromEntry = GameTile.getTileBadgeByPositionConfigFromEntry
local useTriggerGameTileFeedbackCallbacks = require(GameCollections.useTriggerGameTileFeedbackCallbacks)
local SeeAllTile = require(GameCollections.SeeAllTile)
local useNavigateToGameDetails = require(GameCollectionsParent.GameTile).useNavigateToGameDetails
local GameCollectionItemTypes = require(GameCollectionsParent.DiscoveryTypes).GameCollectionItemTypes

require(GameCollectionsParent.HoldToPlay)
require(GameCollectionsParent.VideoUtils)

local FFlagLuaAppGameTileInteractionFeedback = require(GameCollectionsParent.SharedFlags).FFlagLuaAppGameTileInteractionFeedback
local FFlagLuaAppEnableSponsoredReportAd = require(GameCollectionsParent.SharedFlags).FFlagLuaAppEnableSponsoredReportAd
local FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone = require(GameCollectionsParent.SharedFlags).FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone
local FFlagLuaAppNarrowTileSmallerFooterFont = require(GameCollectionsParent.SharedFlags).FFlagLuaAppNarrowTileSmallerFooterFont
local FFlagLuaAppNarrowTileHideRating = require(GameCollectionsParent.SharedFlags).FFlagLuaAppNarrowTileHideRating
local FFlagLuaAppNarrowTileHidePlayerCount = require(GameCollectionsParent.SharedFlags).FFlagLuaAppNarrowTileHidePlayerCount
local FFlagLuaAppUsePrevalidatedVideoGamePlayability = require(GameCollectionsParent.SharedFlags).FFlagLuaAppUsePrevalidatedVideoGamePlayability
local GameCollectionItemType = GameCollectionItemTypes.GameCollectionItemType

local function useRenderGameCollectionItem(p1, b1: boolean?, p2, b2: boolean?, b3: boolean?, s1: string, b4: boolean?, p3: ((...any) -> ...any), p4: ((...any) -> ...any), s2: string?, s3: string?, s4: string?, p5: ((...any) -> ...any)?, s5: string?, n1: number?, b5: boolean?, s6: string?, b6: boolean?, b7: boolean?, b8: boolean?, p6, p7, p8, n2: number?, n3: number?, b9: boolean?, b10: boolean?, p9, p10: ((...any) -> ...any)?, n4: number?, b11: boolean?, t1: {[any]: any}?, p11: ((...any) -> ...any)?, s7: string?, s8: string?, b12: boolean?, b13: boolean?, n5: number?, b14: boolean?, _: string?, _: boolean?, _: boolean?, p12: ((...any) -> ...any)?, b17: boolean?, b18: boolean?, b19: boolean?, p13, b20: boolean?) -- line: 37
	-- upvalues: usePreferredInput (copy), useNavigateToGameDetails (copy), FFlagLuaAppGameTileInteractionFeedback (copy), useTriggerGameTileFeedbackCallbacks (copy), Responsive (copy), useBreakpointXOrSmaller (copy), FFlagLuaAppNarrowTileHideRating (copy), FFlagLuaAppNarrowTileHidePlayerCount (copy), GameTileConstants (copy), GameTileLayoutType (copy), React (copy), SeeAllTile (copy), GameCollectionItemType (copy), FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone (copy), getTileBadgeByPositionConfigFromEntry (copy), AppGameTile (copy), FFlagLuaAppEnableSponsoredReportAd (copy), FFlagLuaAppNarrowTileSmallerFooterFont (copy), FFlagLuaAppUsePrevalidatedVideoGamePlayability (copy)
	local v73 = usePreferredInput()
	local v74 = useNavigateToGameDetails()
	local u75 = nil
	local u76 = nil

	if FFlagLuaAppGameTileInteractionFeedback then
		local v77, v78 = useTriggerGameTileFeedbackCallbacks()

		u75 = v77
		u76 = v78
	end

	local v79 = b4 and v73 == Responsive.Input.Pointer
	local v80 = p2 == "Wide" or p2 == "Event"
	local v81 = useBreakpointXOrSmaller(Responsive.Keys.Small)
	local v82 = useBreakpointXOrSmaller(Responsive.Keys.XSmall)
	local v83 = FFlagLuaAppNarrowTileHideRating and b18 or FFlagLuaAppNarrowTileHidePlayerCount and b19
	local u84 = if not (v81 and (n2 > 0 and not v83)) then GameTileConstants.TileTextLines[p2 or GameTileLayoutType.Narrow].metadataTextLines else GameTileConstants.TileTextLines[p2 or GameTileLayoutType.Narrow].largeMetadataTextLines

	return (React.useCallback(function(p14, n6: number, p15, n7: number?) -- line: 166
		-- upvalues: n1 (copy), p5 (copy), React (copy), SeeAllTile (copy), GameCollectionItemType (copy), p8 (copy), t1 (copy), n4 (copy), n5 (copy), p6 (copy), p7 (copy), s5 (copy), s4 (copy), s3 (copy), p1 (copy), b5 (copy), p2 (copy), v79 (copy), b6 (copy), p3 (copy), p4 (copy), s2 (copy), p10 (copy), v74 (copy), s1 (copy), n2 (copy), s7 (copy), p11 (copy), s8 (copy), b12 (copy), b13 (copy), b11 (copy), FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone (copy), p12 (copy), p13 (copy), getTileBadgeByPositionConfigFromEntry (copy), AppGameTile (copy), b2 (copy), b3 (copy), v80 (copy), b1 (copy), s6 (copy), b7 (copy), b8 (copy), FFlagLuaAppGameTileInteractionFeedback (copy), u75 (ref), u76 (ref), n3 (copy), u84 (ref), b9 (copy), b10 (copy), p9 (copy), v82 (copy), FFlagLuaAppEnableSponsoredReportAd (copy), b14 (copy), FFlagLuaAppNarrowTileSmallerFooterFont (copy), b17 (copy), FFlagLuaAppNarrowTileHideRating (copy), b18 (copy), FFlagLuaAppNarrowTileHidePlayerCount (copy), b19 (copy), FFlagLuaAppUsePrevalidatedVideoGamePlayability (copy), b20 (copy)
		if n1 and (n6 == n1 and p5) then
			return React.createElement(SeeAllTile, {
				onActivated = p5,
				size = p15,
				layoutOrder = n6
			}), GameCollectionItemType.SeeAllTile
		end

		local v89 = nil

		if p8 then
			v89 = p8(n6)
		end

		local v90 = t1 and t1[p14.universeId]
		local v91 = if not n4 then nil else n4 + n6

		if p14.customRenderFunction then
			return p14.customRenderFunction({
				item = p14,
				index = n6,
				itemSize = p15,
				rowNum = n7,
				zIndex = -n6,
				maxItemIndex = n5,
				SelectionOrder = v91,
				isDisabled = v89,
				onSelectionGained = p6,
				onSelectionLost = p7,
				topicId = s5,
				source = s4,
				referralSource = s3,
				playerCountStyle = p1,
				hideGameStats = b5,
				gameTileLayoutType = p2,
				hoverTileEnabled = v79,
				isContained = b6,
				reportGameDetailOpened = p3,
				reportExperienceLaunched = p4,
				launchExperienceEventContext = s2,
				onPeekViewClosed = p10,
				navigateToGameDetails = v74,
				impressionsTag = s1,
				textSizeOffset = n2,
				appPage = s7,
				setGameHidden = p11,
				isHidden = v90,
				sponsoredUserCohort = s8,
				enableSponsoredFeedback = b12,
				enableReportAd = b13,
				enableExplicitFeedback = b11,
				onTileImageLoaded = if not FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone or (not p12 or v90) then nil else p12,
				videoPlaybackContext = p13
			})
		end

		local v92 = getTileBadgeByPositionConfigFromEntry(p14)

		return React.createElement(AppGameTile, {
			Size = p15,
			entry = p14,
			layoutOrder = n6,
			ZIndex = -n6,
			reportGameDetailOpened = p3,
			reportExperienceLaunched = p4,
			index = n6,
			friendFooterEnabled = b2,
			showFriendActivity = b3,
			impressionsTag = s1,
			useGridTile = v80,
			playerCountStyle = p1,
			isSponsoredFooterAllowed = b1,
			gameTileLayoutType = p2,
			useHoverTile = v79,
			topicId = s5,
			launchExperienceEventContext = s2,
			referralSource = s3,
			source = s4,
			rowNum = n7,
			navigateToGameDetails = v74,
			hideGameStats = b5,
			playButtonStyle = s6,
			isContained = b6,
			hideTitle = b7,
			hideMetadata = b8,
			onGuiStateChanged = if not FFlagLuaAppGameTileInteractionFeedback then nil else u75,
			onActivated = if not FFlagLuaAppGameTileInteractionFeedback then nil else u76,
			isDisabled = v89,
			onSelectionGained = p6,
			onSelectionLost = p7,
			textSizeOffset = n2,
			contentTextLineCount = n3,
			metadataTextLineCount = u84,
			useExperienceTileMetadata = b9,
			forceHideAgeRatings = b10,
			videoAnalytics = p9,
			onPeekViewClosed = p10,
			SelectionOrder = v91,
			enableExplicitFeedback = b11,
			setGameHidden = p11,
			appPage = s7,
			isHidden = v90,
			isNarrowScreenXSmall = v82,
			sponsoredUserCohort = s8,
			enableSponsoredFeedback = b12,
			enableReportAd = if not FFlagLuaAppEnableSponsoredReportAd then nil else b13,
			isSponsoredRatingFooterAllowed = b14,
			badgeOverride = v92,
			onTileImageLoaded = if not FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone or (not p12 or v90) then nil else p12,
			compactMetadataFormat = if not FFlagLuaAppNarrowTileSmallerFooterFont then nil else b17,
			hideRating = if not FFlagLuaAppNarrowTileHideRating then nil else b18,
			hidePlayerCount = if not FFlagLuaAppNarrowTileHidePlayerCount then nil else b19,
			hasPrevalidatedVideoGamePlayability = if not FFlagLuaAppUsePrevalidatedVideoGamePlayability then nil else b20,
			videoPlaybackContext = p13
		}), GameCollectionItemType.GameTile
	end, {
		v80,
		b2,
		b5,
		b3,
		s1,
		p1,
		b1,
		p2,
		s5,
		p3,
		p4,
		p5,
		s2,
		s4,
		s3,
		n1,
		v79,
		s6,
		b6,
		b7,
		b8,
		n2,
		if not FFlagLuaAppGameTileInteractionFeedback then nil else u75,
		if not FFlagLuaAppGameTileInteractionFeedback then nil else u76,
		p6,
		p7,
		p8,
		n3,
		b9,
		b10,
		p9,
		p10,
		n4,
		u84,
		b11,
		t1,
		p11,
		s7,
		v82,
		s8,
		b12,
		if not FFlagLuaAppEnableSponsoredReportAd then nil else b13,
		v74,
		b14,
		if not FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone then nil else p12,
		if not FFlagLuaAppNarrowTileSmallerFooterFont then nil else b17,
		if not FFlagLuaAppNarrowTileHideRating then nil else b18,
		if not FFlagLuaAppNarrowTileHidePlayerCount then nil else b19,
		if not FFlagLuaAppUsePrevalidatedVideoGamePlayability then nil else b20,
		p13
	}))
end

return useRenderGameCollectionItem
