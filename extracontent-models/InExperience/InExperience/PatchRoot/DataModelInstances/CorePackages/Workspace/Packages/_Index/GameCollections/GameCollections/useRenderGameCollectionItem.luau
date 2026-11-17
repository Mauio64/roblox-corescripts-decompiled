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
local InteractionFeedback = require(parent.InteractionFeedback)
local useTriggerFeedback = InteractionFeedback.useTriggerFeedback
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
local FFlagLuaAppEnableNxMRoduxApportioning = SharedFlags5.FFlagLuaAppEnableNxMRoduxApportioning

local SharedFlags6 = require(parent.SharedFlags)
local FFlagLuaAppUsePrevalidatedVideoGamePlayability = SharedFlags6.FFlagLuaAppUsePrevalidatedVideoGamePlayability
local SharedFlags7 = require(parent.SharedFlags)
local FFlagLuaAppEmphasisGameTileVideo = SharedFlags7.FFlagLuaAppEmphasisGameTileVideo

local SharedFlags8 = require(parent.SharedFlags)
local FFlagLuaAppSduiGameTileInteractionFeedback = SharedFlags8.FFlagLuaAppSduiGameTileInteractionFeedback

local GameCollectionItemType = GameCollectionItemTypes.GameCollectionItemType

local function useRenderGameCollectionItem(playerCountStyle, isSponsoredFooterAllowed: boolean?, gameTileLayoutType, friendFooterEnabled: boolean?, showFriendActivity: boolean?, impressionsTag: string, flag: boolean?, reportGameDetailOpened, reportExperienceLaunched, launchExperienceEventContext: string?, referralSource: string?, source: string?, onActivated, topicId: string?, p: number?, hideGameStats: boolean?, playButtonStyle: string?, isContained: boolean?, hideTitle: boolean?, hideMetadata: boolean?, onSelectionGained, onSelectionLost, callback, textSizeOffset: number?, contentTextLineCount: number?, useExperienceTileMetadata: boolean?, forceHideAgeRatings: boolean?, videoAnalytics, onPeekViewClosed, p2: number?, enableExplicitFeedback: boolean?, p3, setGameHidden, appPage: string?, sponsoredUserCohort: string?, enableSponsoredFeedback: boolean?, enableReportAd: boolean?, flag2: boolean?, maxItemIndex: number?, isSponsoredRatingFooterAllowed: boolean?, _: string?, _: boolean?, _: boolean?, compactMetadataFormat: boolean?, flag3: boolean?, flag4: boolean?, videoPlaybackContext, flag5: boolean?, flag6: boolean?, p4: string?)
	local v = usePreferredInput()
	local navigateToGameDetails = useNavigateToGameDetails()
	local v2

	if FFlagLuaAppSduiGameTileInteractionFeedback then
		v2 = useTriggerFeedback()
	end

	if not FFlagLuaAppSduiGameTileInteractionFeedback then
		v2 = nil
	end

	local onGuiStateChanged, onActivated2 = useTriggerGameTileFeedbackCallbacks(v2)

	local v3 = flag and v == Responsive.Input.Pointer
	local v4

	if FFlagLuaAppContinueSortInstantPlay then
		v4 = v == Responsive.Input.Touch
	else
		v4 = nil
	end

	local useGridTile = gameTileLayoutType == "Wide" or gameTileLayoutType == "Event"

	local v5 = useBreakpointXOrSmaller(Responsive.Keys.Small)
	local isNarrowScreenXSmall = useBreakpointXOrSmaller(Responsive.Keys.XSmall)
	local v6 = FFlagLuaAppNarrowTileHideRating and flag3 or FFlagLuaAppNarrowTileHidePlayerCount and flag4

	if v5 then
		if textSizeOffset > 0 then
			v5 = not v6
		else
			v5 = false
		end
	end

	local metadataTextLineCount

	if v5 then
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
			local v7 = {}
			v7.item = entry
			v7.index = layoutOrder
			v7.itemSize = p5
			v7.rowNum = rowNum
			v7.zIndex = -layoutOrder
			v7.maxItemIndex = maxItemIndex
			v7.SelectionOrder = selectionOrder
			v7.isDisabled = isDisabled
			v7.onSelectionGained = onSelectionGained
			v7.onSelectionLost = onSelectionLost
			v7.topicId = topicId
			v7.source = source
			v7.referralSource = referralSource
			v7.playerCountStyle = playerCountStyle
			v7.hideGameStats = hideGameStats
			v7.gameTileLayoutType = gameTileLayoutType
			v7.hoverTileEnabled = v3
			v7.isContained = isContained
			v7.reportGameDetailOpened = reportGameDetailOpened
			v7.reportExperienceLaunched = reportExperienceLaunched
			v7.launchExperienceEventContext = launchExperienceEventContext
			v7.onPeekViewClosed = onPeekViewClosed
			v7.navigateToGameDetails = navigateToGameDetails
			v7.impressionsTag = impressionsTag
			v7.textSizeOffset = textSizeOffset
			v7.appPage = appPage
			v7.setGameHidden = setGameHidden
			v7.isHidden = isHidden
			v7.sponsoredUserCohort = sponsoredUserCohort
			v7.enableSponsoredFeedback = enableSponsoredFeedback
			v7.enableReportAd = enableReportAd
			local enableReportExperience

			if FFlagLuaAppEnableReportExperience then
				enableReportExperience = flag2
			end

			v7.enableReportExperience = enableReportExperience
			v7.enableExplicitFeedback = enableExplicitFeedback
			v7.videoPlaybackContext = videoPlaybackContext
			local videoAnalytics2

			if FFlagLuaAppEmphasisGameTileVideo or FFlagLuaAppEnableNxMRoduxApportioning then
				videoAnalytics2 = videoAnalytics
			end

			v7.videoAnalytics = videoAnalytics2
			return customRenderFunction(v7)
		else
			local tileBadgeByPositionConfigFromEntry = getTileBadgeByPositionConfigFromEntry(entry)

			local createElement = React.createElement
			local v7 = {
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
				useHoverTile = v3,
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

			v7.enableReportExperience = enableReportExperience
			v7.isSponsoredRatingFooterAllowed = isSponsoredRatingFooterAllowed
			v7.badgeOverride = tileBadgeByPositionConfigFromEntry
			v7.compactMetadataFormat = compactMetadataFormat
			local hideRating

			if FFlagLuaAppNarrowTileHideRating then
				hideRating = flag3
			end

			v7.hideRating = hideRating
			local hidePlayerCount

			if FFlagLuaAppNarrowTileHidePlayerCount then
				hidePlayerCount = flag4
			end

			v7.hidePlayerCount = hidePlayerCount
			local hasPrevalidatedVideoGamePlayability

			if FFlagLuaAppUsePrevalidatedVideoGamePlayability then
				hasPrevalidatedVideoGamePlayability = flag5
			end

			v7.hasPrevalidatedVideoGamePlayability = hasPrevalidatedVideoGamePlayability

			v7.videoPlaybackContext = videoPlaybackContext
			local enableInstantPlay

			if FFlagLuaAppContinueSortInstantPlay then
				enableInstantPlay = flag6
			end

			v7.enableInstantPlay = enableInstantPlay
			local instantPlayTreatment

			if FFlagLuaAppContinueSortInstantPlay then
				instantPlayTreatment = p4
			end

			v7.instantPlayTreatment = instantPlayTreatment
			local isTouchPreferredInput

			if FFlagLuaAppContinueSortInstantPlay then
				isTouchPreferredInput = v4
			end

			v7.isTouchPreferredInput = isTouchPreferredInput
			return createElement(AppGameTile, v7), GameCollectionItemType.GameTile
		end
	end

	local v7 = {
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
		v3,
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
	local v8

	if FFlagLuaAppEnableReportExperience then
		v8 = flag2
	end

	local v9

	if FFlagLuaAppNarrowTileHideRating then
		v9 = flag3
	end

	local v10

	if FFlagLuaAppNarrowTileHidePlayerCount then
		v10 = flag4
	end

	v7[33], v7[34], v7[35], v7[36], v7[37], v7[38], v7[39], v7[40], v7[41], v7[42], v7[43], v7[44], v7[45], v7[46], v7[47], v7[48] = p2, metadataTextLineCount, enableExplicitFeedback, p3, setGameHidden, appPage, isNarrowScreenXSmall, sponsoredUserCohort, enableSponsoredFeedback, enableReportAd, v8, navigateToGameDetails, isSponsoredRatingFooterAllowed, compactMetadataFormat, v9, v10
	local v11

	if FFlagLuaAppUsePrevalidatedVideoGamePlayability then
		v11 = flag5
	end

	local v12

	if FFlagLuaAppContinueSortInstantPlay then
		v12 = flag6
	end

	local v13

	if FFlagLuaAppContinueSortInstantPlay then
		v13 = p4
	end

	local v14

	if FFlagLuaAppContinueSortInstantPlay then
		v14 = v4
	end

	v7[49], v7[50], v7[51], v7[52], v7[53] = v11, videoPlaybackContext, v12, v13, v14
	return (useCallback(fn, v7))
end

return useRenderGameCollectionItem
