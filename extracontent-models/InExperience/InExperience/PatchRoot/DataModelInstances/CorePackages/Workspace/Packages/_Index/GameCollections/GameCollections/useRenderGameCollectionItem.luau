local GameCollections = script:FindFirstAncestor("GameCollections")
local parent = GameCollections.Parent

local React = require(parent.React)

local Responsive = require(parent.Responsive)
local usePreferredInput = Responsive.usePreferredInput
local useBreakpointXOrSmaller = Responsive.useBreakpointXOrSmaller
local GameTile = require(parent.GameTile)
local GameTileConstants = GameTile.GameTileConstants
local GameTileLayoutType = GameTile.GameTileTypes.GameTileLayoutType
local AppGameTile = GameTile.AppGameTile
local getTileBadgeByPositionConfigFromEntry = GameTile.getTileBadgeByPositionConfigFromEntry
local useTriggerGameTileFeedbackCallbacks = require(GameCollections.useTriggerGameTileFeedbackCallbacks)
local SeeAllTile = require(GameCollections.SeeAllTile)
local GameTile2 = require(parent.GameTile)
local useNavigateToGameDetails = GameTile2.useNavigateToGameDetails
local DiscoveryTypes = require(parent.DiscoveryTypes)
local GameCollectionItemTypes = DiscoveryTypes.GameCollectionItemTypes
require(parent.HoldToPlay)
require(parent.VideoUtils)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppContinueSortInstantPlay = SharedFlags.FFlagLuaAppContinueSortInstantPlay
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppEnableReportExperience = SharedFlags2.FFlagLuaAppEnableReportExperience
local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppNarrowTileHideRating = SharedFlags3.FFlagLuaAppNarrowTileHideRating
local SharedFlags4 = require(parent.SharedFlags)
local FFlagLuaAppNarrowTileHidePlayerCount = SharedFlags4.FFlagLuaAppNarrowTileHidePlayerCount
local SharedFlags5 = require(parent.SharedFlags)
local FFlagLuaAppEnableHomepageOneByTwoTile = SharedFlags5.FFlagLuaAppEnableHomepageOneByTwoTile

local SharedFlags6 = require(parent.SharedFlags)
local FFlagLuaAppUsePrevalidatedVideoGamePlayability = SharedFlags6.FFlagLuaAppUsePrevalidatedVideoGamePlayability
local SharedFlags7 = require(parent.SharedFlags)
local FFlagLuaAppEmphasisGameTileVideo = SharedFlags7.FFlagLuaAppEmphasisGameTileVideo

local GameCollectionItemType = GameCollectionItemTypes.GameCollectionItemType

local function useRenderGameCollectionItem(playerCountStyle, isSponsoredFooterAllowed: boolean?, gameTileLayoutType, friendFooterEnabled: boolean?, showFriendActivity: boolean?, impressionsTag: string, flag: boolean?, reportGameDetailOpened, reportExperienceLaunched, launchExperienceEventContext: string?, referralSource: string?, source: string?, onActivated, topicId: string?, p: number?, hideGameStats: boolean?, playButtonStyle: string?, isContained: boolean?, hideTitle: boolean?, hideMetadata: boolean?, onSelectionGained, onSelectionLost, callback, textSizeOffset: number?, contentTextLineCount: number?, useExperienceTileMetadata: boolean?, forceHideAgeRatings: boolean?, videoAnalytics, onPeekViewClosed, p2: number?, enableExplicitFeedback: boolean?, p3, setGameHidden, appPage: string?, sponsoredUserCohort: string?, enableSponsoredFeedback: boolean?, enableReportAd: boolean?, flag2: boolean?, maxItemIndex: number?, isSponsoredRatingFooterAllowed: boolean?, _: string?, _: boolean?, _: boolean?, compactMetadataFormat: boolean?, flag3: boolean?, flag4: boolean?, videoPlaybackContext, flag5: boolean?, flag6: boolean?, p4: string?)
	local v = usePreferredInput()
	local navigateToGameDetails = useNavigateToGameDetails()

	local onGuiStateChanged, onActivated2 = useTriggerGameTileFeedbackCallbacks()

	local v2 = flag and v == Responsive.Input.Pointer
	local v3

	if FFlagLuaAppContinueSortInstantPlay then
		v3 = v == Responsive.Input.Touch
	else
		v3 = nil
	end

	local useGridTile = gameTileLayoutType == "Wide" or gameTileLayoutType == "Event"

	local v4 = useBreakpointXOrSmaller(Responsive.Keys.Small)
	local isNarrowScreenXSmall = useBreakpointXOrSmaller(Responsive.Keys.XSmall)
	local v5 = FFlagLuaAppNarrowTileHideRating and flag3 or FFlagLuaAppNarrowTileHidePlayerCount and flag4

	if v4 then
		if textSizeOffset > 0 then
			v4 = not v5
		else
			v4 = false
		end
	end

	local metadataTextLineCount

	if v4 then
		metadataTextLineCount = GameTileConstants.TileTextLines[gameTileLayoutType or GameTileLayoutType.Narrow].largeMetadataTextLines
	else
		metadataTextLineCount = GameTileConstants.TileTextLines[gameTileLayoutType or GameTileLayoutType.Narrow].metadataTextLines
	end

	local useCallback = React.useCallback
	local function fn(entry, layoutOrder: number, p5, rowNum: number?)
		if p and layoutOrder == p and onActivated then
			return
				React.createElement(SeeAllTile, {
					onActivated = onActivated,
					size = p5,
					layoutOrder = layoutOrder
				}),
				GameCollectionItemType.SeeAllTile
		end

		local isDisabled

		if callback then
			isDisabled = callback(layoutOrder)
		end

		local isHidden = p3 and p3[entry.universeId]
		local selectionOrder

		if p2 then
			selectionOrder = p2 + layoutOrder
		end

		if entry.customRenderFunction then
			local customRenderFunction = entry.customRenderFunction
			local v6 = {}
			v6.item = entry
			v6.index = layoutOrder
			v6.itemSize = p5
			v6.rowNum = rowNum
			v6.zIndex = -layoutOrder
			v6.maxItemIndex = maxItemIndex
			v6.SelectionOrder = selectionOrder
			v6.isDisabled = isDisabled
			v6.onSelectionGained = onSelectionGained
			v6.onSelectionLost = onSelectionLost
			v6.topicId = topicId
			v6.source = source
			v6.referralSource = referralSource
			v6.playerCountStyle = playerCountStyle
			v6.hideGameStats = hideGameStats
			v6.gameTileLayoutType = gameTileLayoutType
			v6.hoverTileEnabled = v2
			v6.isContained = isContained
			v6.reportGameDetailOpened = reportGameDetailOpened
			v6.reportExperienceLaunched = reportExperienceLaunched
			v6.launchExperienceEventContext = launchExperienceEventContext
			v6.onPeekViewClosed = onPeekViewClosed
			v6.navigateToGameDetails = navigateToGameDetails
			v6.impressionsTag = impressionsTag
			v6.textSizeOffset = textSizeOffset
			v6.appPage = appPage
			v6.setGameHidden = setGameHidden
			v6.isHidden = isHidden
			v6.sponsoredUserCohort = sponsoredUserCohort
			v6.enableSponsoredFeedback = enableSponsoredFeedback
			v6.enableReportAd = enableReportAd
			local enableReportExperience

			if FFlagLuaAppEnableReportExperience then
				enableReportExperience = flag2
			end

			v6.enableReportExperience = enableReportExperience
			v6.enableExplicitFeedback = enableExplicitFeedback
			v6.videoPlaybackContext = videoPlaybackContext
			local videoAnalytics2

			if FFlagLuaAppEmphasisGameTileVideo or FFlagLuaAppEnableHomepageOneByTwoTile then
				videoAnalytics2 = videoAnalytics
			end

			v6.videoAnalytics = videoAnalytics2
			return customRenderFunction(v6)
		else
			local tileBadgeByPositionConfigFromEntry = getTileBadgeByPositionConfigFromEntry(entry)

			local createElement = React.createElement
			local v6 = {
				Size = p5,
				entry = entry,
				layoutOrder = layoutOrder,
				ZIndex = -layoutOrder,
				reportGameDetailOpened = reportGameDetailOpened,
				reportExperienceLaunched = reportExperienceLaunched,
				index = layoutOrder,
				friendFooterEnabled = friendFooterEnabled,
				showFriendActivity = showFriendActivity,
				impressionsTag = impressionsTag,
				useGridTile = useGridTile,
				playerCountStyle = playerCountStyle,
				isSponsoredFooterAllowed = isSponsoredFooterAllowed,
				gameTileLayoutType = gameTileLayoutType,
				useHoverTile = v2,
				topicId = topicId,
				launchExperienceEventContext = launchExperienceEventContext,
				referralSource = referralSource,
				source = source,
				rowNum = rowNum,
				navigateToGameDetails = navigateToGameDetails,
				hideGameStats = hideGameStats,
				playButtonStyle = playButtonStyle,
				isContained = isContained,
				hideTitle = hideTitle,
				hideMetadata = hideMetadata,
				onGuiStateChanged = onGuiStateChanged,
				onActivated = onActivated2,
				isDisabled = isDisabled,
				onSelectionGained = onSelectionGained,
				onSelectionLost = onSelectionLost,
				textSizeOffset = textSizeOffset,
				contentTextLineCount = contentTextLineCount,
				metadataTextLineCount = metadataTextLineCount,
				useExperienceTileMetadata = useExperienceTileMetadata,
				forceHideAgeRatings = forceHideAgeRatings,
				videoAnalytics = videoAnalytics,
				onPeekViewClosed = onPeekViewClosed,
				SelectionOrder = selectionOrder,
				enableExplicitFeedback = enableExplicitFeedback,
				setGameHidden = setGameHidden,
				appPage = appPage,
				isHidden = isHidden,
				isNarrowScreenXSmall = isNarrowScreenXSmall,
				sponsoredUserCohort = sponsoredUserCohort,
				enableSponsoredFeedback = enableSponsoredFeedback,
				enableReportAd = enableReportAd
			}
			local enableReportExperience

			if FFlagLuaAppEnableReportExperience then
				enableReportExperience = flag2
			end

			v6.enableReportExperience = enableReportExperience
			v6.isSponsoredRatingFooterAllowed = isSponsoredRatingFooterAllowed
			v6.badgeOverride = tileBadgeByPositionConfigFromEntry
			v6.compactMetadataFormat = compactMetadataFormat
			local hideRating

			if FFlagLuaAppNarrowTileHideRating then
				hideRating = flag3
			end

			v6.hideRating = hideRating
			local hidePlayerCount

			if FFlagLuaAppNarrowTileHidePlayerCount then
				hidePlayerCount = flag4
			end

			v6.hidePlayerCount = hidePlayerCount
			local hasPrevalidatedVideoGamePlayability

			if FFlagLuaAppUsePrevalidatedVideoGamePlayability then
				hasPrevalidatedVideoGamePlayability = flag5
			end

			v6.hasPrevalidatedVideoGamePlayability = hasPrevalidatedVideoGamePlayability

			v6.videoPlaybackContext = videoPlaybackContext
			local enableInstantPlay

			if FFlagLuaAppContinueSortInstantPlay then
				enableInstantPlay = flag6
			end

			v6.enableInstantPlay = enableInstantPlay
			local instantPlayTreatment

			if FFlagLuaAppContinueSortInstantPlay then
				instantPlayTreatment = p4
			end

			v6.instantPlayTreatment = instantPlayTreatment
			local isTouchPreferredInput

			if FFlagLuaAppContinueSortInstantPlay then
				isTouchPreferredInput = v3
			end

			v6.isTouchPreferredInput = isTouchPreferredInput
			return createElement(AppGameTile, v6), GameCollectionItemType.GameTile
		end
	end

	local v6 = {
		useGridTile,
		friendFooterEnabled,
		hideGameStats,
		showFriendActivity,
		impressionsTag,
		playerCountStyle,
		isSponsoredFooterAllowed,
		gameTileLayoutType,
		topicId,
		reportGameDetailOpened,
		reportExperienceLaunched,
		onActivated,
		launchExperienceEventContext,
		source,
		referralSource,
		p,
		v2,
		playButtonStyle,
		isContained,
		hideTitle,
		hideMetadata,
		textSizeOffset,
		onGuiStateChanged,
		onActivated2,
		onSelectionGained,
		onSelectionLost,
		callback,
		contentTextLineCount,
		useExperienceTileMetadata,
		forceHideAgeRatings,
		videoAnalytics,
		onPeekViewClosed,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil
	}
	local v7

	if FFlagLuaAppEnableReportExperience then
		v7 = flag2
	end

	local v8

	if FFlagLuaAppNarrowTileHideRating then
		v8 = flag3
	end

	local v9

	if FFlagLuaAppNarrowTileHidePlayerCount then
		v9 = flag4
	end

	v6[33], v6[34], v6[35], v6[36], v6[37], v6[38], v6[39], v6[40], v6[41], v6[42], v6[43], v6[44], v6[45], v6[46], v6[47], v6[48] = p2, metadataTextLineCount, enableExplicitFeedback, p3, setGameHidden, appPage, isNarrowScreenXSmall, sponsoredUserCohort, enableSponsoredFeedback, enableReportAd, v7, navigateToGameDetails, isSponsoredRatingFooterAllowed, compactMetadataFormat, v8, v9
	local v10

	if FFlagLuaAppUsePrevalidatedVideoGamePlayability then
		v10 = flag5
	end

	local v11

	if FFlagLuaAppContinueSortInstantPlay then
		v11 = flag6
	end

	local v12

	if FFlagLuaAppContinueSortInstantPlay then
		v12 = p4
	end

	local v13

	if FFlagLuaAppContinueSortInstantPlay then
		v13 = v3
	end

	v6[49], v6[50], v6[51], v6[52], v6[53] = v10, videoPlaybackContext, v11, v12, v13
	return (useCallback(fn, v6))
end

return useRenderGameCollectionItem
