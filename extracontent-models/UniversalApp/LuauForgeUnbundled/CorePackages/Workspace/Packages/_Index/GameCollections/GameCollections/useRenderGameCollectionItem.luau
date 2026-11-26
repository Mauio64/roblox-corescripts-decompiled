local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/React")

local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/Responsive")
local usePreferredInput = Responsive.usePreferredInput
local useBreakpointXOrSmaller = Responsive.useBreakpointXOrSmaller
local GameTile = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/GameTile")
local gameTileConstants = GameTile.GameTileConstants
local gameTileLayoutType = GameTile.GameTileTypes.GameTileLayoutType
local appGameTile = GameTile.AppGameTile
local getTileBadgeByPositionConfigFromEntry = GameTile.getTileBadgeByPositionConfigFromEntry
local useTriggerGameTileFeedbackCallbacks = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/useTriggerGameTileFeedbackCallbacks")
local useTriggerFeedback = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/InteractionFeedback").useTriggerFeedback
local SeeAllTile = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/SeeAllTile")
local useNavigateToGameDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/GameTile").useNavigateToGameDetails
local gameCollectionItemTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/DiscoveryTypes").GameCollectionItemTypes
require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/HoldToPlay")
require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/VideoUtils")

local fFlagLuaAppContinueSortInstantPlay = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagLuaAppContinueSortInstantPlay
local fFlagLuaAppEnableReportExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagLuaAppEnableReportExperience
local fFlagLuaAppNarrowTileHideRating = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagLuaAppNarrowTileHideRating
local fFlagLuaAppNarrowTileHidePlayerCount = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagLuaAppNarrowTileHidePlayerCount
local fFlagLuaAppEnableNxMRoduxApportioning = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagLuaAppEnableNxMRoduxApportioning

local fFlagLuaAppUsePrevalidatedVideoGamePlayability = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagLuaAppUsePrevalidatedVideoGamePlayability
local fFlagLuaAppEmphasisGameTileVideo = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagLuaAppEmphasisGameTileVideo

local fFlagLuaAppSduiGameTileInteractionFeedback = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagLuaAppSduiGameTileInteractionFeedback

local gameCollectionItemType = gameCollectionItemTypes.GameCollectionItemType

local function useRenderGameCollectionItem(p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, onActivated, p14, p15, p16, p17, p18, p19, p20, onSelectionGained, onSelectionLost, callback, p21, p22, p23, p24, p25, onPeekViewClosed, p26, enableExplicitFeedback, p27, setGameHidden, p28, p29, p30, p31, p32, p33, isSponsoredRatingFooterAllowed, p34, p35, p36, compactMetadataFormat, p37, p38, videoPlaybackContext, p39, p40, p41)
	local v5 = usePreferredInput()
	local v6 = useNavigateToGameDetails()
	local v7 = if fFlagLuaAppSduiGameTileInteractionFeedback then useTriggerFeedback() else nil

	if not fFlagLuaAppSduiGameTileInteractionFeedback then
		v7 = nil
	end

	local v9, v10 = useTriggerGameTileFeedbackCallbacks(v7)

	local v13 = p8 and v5 == Responsive.Input.Pointer

	local v14 = if fFlagLuaAppContinueSortInstantPlay then v5 == Responsive.Input.Touch else nil

	local v15 = p4 == "Wide" or p4 == "Event"

	local v16 = useBreakpointXOrSmaller(Responsive.Keys.Small)
	local v17 = useBreakpointXOrSmaller(Responsive.Keys.XSmall)
	local v18 = fFlagLuaAppNarrowTileHideRating and p37 or fFlagLuaAppNarrowTileHidePlayerCount and p38

	if v16 then
		v16 = p21 > 0 and not v18
	end

	local v19

	if v16 then
		v19 = gameTileConstants.TileTextLines[p4 or gameTileLayoutType.Narrow].largeMetadataTextLines
	else
		v19 = gameTileConstants.TileTextLines[p4 or gameTileLayoutType.Narrow].metadataTextLines
	end

	local useCallback = React.useCallback
	local function fn(p42, p43, p44, p45)
		if p15 and p43 == p15 and onActivated then
			return
				React.createElement(SeeAllTile, {
					onActivated = onActivated,
					size = p44,
					layoutOrder = p43
				}),
				gameCollectionItemType.SeeAllTile
		end

		local v20 = if callback then callback(p43) else nil

		local v21 = p27 and p27[p42.universeId]
		local v22 = if p26 then p26 + p43 else nil

		if p42.customRenderFunction then
			local customRenderFunction = p42.customRenderFunction
			local v23 = {
				item = p42,
				index = p43,
				itemSize = p44,
				rowNum = p45,
				zIndex = -p43,
				maxItemIndex = p33,
				SelectionOrder = v22,
				isDisabled = v20,
				onSelectionGained = onSelectionGained,
				onSelectionLost = onSelectionLost,
				topicId = p14,
				source = p13,
				referralSource = p12,
				playerCountStyle = p2,
				hideGameStats = p16,
				gameTileLayoutType = p4,
				hoverTileEnabled = v13,
				isContained = p18,
				reportGameDetailOpened = p9,
				reportExperienceLaunched = p10,
				launchExperienceEventContext = p11,
				onPeekViewClosed = onPeekViewClosed,
				navigateToGameDetails = v6,
				impressionsTag = p7,
				textSizeOffset = p21,
				appPage = p28,
				setGameHidden = setGameHidden,
				isHidden = v21,
				sponsoredUserCohort = p29,
				enableSponsoredFeedback = p30,
				enableReportAd = p31,
				enableReportExperience = if fFlagLuaAppEnableReportExperience then p32 else nil,
				enableExplicitFeedback = enableExplicitFeedback,
				videoPlaybackContext = videoPlaybackContext
			}
			local v25 = if fFlagLuaAppEmphasisGameTileVideo or fFlagLuaAppEnableNxMRoduxApportioning then p25 else nil
			v23.videoAnalytics = v25
			return customRenderFunction(v23)
		else
			local tileBadgeByPositionConfigFromEntry = getTileBadgeByPositionConfigFromEntry(p42)

			return React.createElement(appGameTile, {
				Size = p44,
				entry = p42,
				layoutOrder = p43,
				ZIndex = -p43,
				reportGameDetailOpened = p9,
				reportExperienceLaunched = p10,
				index = p43,
				friendFooterEnabled = p5,
				showFriendActivity = p6,
				impressionsTag = p7,
				useGridTile = v15,
				playerCountStyle = p2,
				isSponsoredFooterAllowed = p3,
				gameTileLayoutType = p4,
				useHoverTile = v13,
				topicId = p14,
				launchExperienceEventContext = p11,
				referralSource = p12,
				source = p13,
				rowNum = p45,
				navigateToGameDetails = v6,
				hideGameStats = p16,
				playButtonStyle = p17,
				isContained = p18,
				hideTitle = p19,
				hideMetadata = p20,
				onGuiStateChanged = v9,
				onActivated = v10,
				isDisabled = v20,
				onSelectionGained = onSelectionGained,
				onSelectionLost = onSelectionLost,
				textSizeOffset = p21,
				contentTextLineCount = p22,
				metadataTextLineCount = v19,
				useExperienceTileMetadata = p23,
				forceHideAgeRatings = p24,
				videoAnalytics = p25,
				onPeekViewClosed = onPeekViewClosed,
				SelectionOrder = v22,
				enableExplicitFeedback = enableExplicitFeedback,
				setGameHidden = setGameHidden,
				appPage = p28,
				isHidden = v21,
				isNarrowScreenXSmall = v17,
				sponsoredUserCohort = p29,
				enableSponsoredFeedback = p30,
				enableReportAd = p31,
				enableReportExperience = if fFlagLuaAppEnableReportExperience then p32 else nil,
				isSponsoredRatingFooterAllowed = isSponsoredRatingFooterAllowed,
				badgeOverride = tileBadgeByPositionConfigFromEntry,
				compactMetadataFormat = compactMetadataFormat,
				hideRating = if fFlagLuaAppNarrowTileHideRating then p37 else nil,
				hidePlayerCount = if fFlagLuaAppNarrowTileHidePlayerCount then p38 else nil,
				hasPrevalidatedVideoGamePlayability = if fFlagLuaAppUsePrevalidatedVideoGamePlayability then p39 else nil,
				videoPlaybackContext = videoPlaybackContext,
				enableInstantPlay = if fFlagLuaAppContinueSortInstantPlay then p40 else nil,
				instantPlayTreatment = if fFlagLuaAppContinueSortInstantPlay then p41 else nil,
				isTouchPreferredInput = if fFlagLuaAppContinueSortInstantPlay then v14 else nil
			}), gameCollectionItemType.GameTile
		end
	end

	local v20 = {
		v15,
		p5,
		p16,
		p6,
		p7,
		p2,
		p3,
		p4,
		p14,
		p9,
		p10,
		onActivated,
		p11,
		p13,
		p12,
		p15,
		v13,
		p17,
		p18,
		p19,
		p20,
		p21,
		v9,
		v10,
		onSelectionGained,
		onSelectionLost,
		callback,
		p22,
		p23,
		p24,
		p25,
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
	local v22 = if fFlagLuaAppEnableReportExperience then p32 else nil
	local v23 = if fFlagLuaAppNarrowTileHideRating then p37 else nil
	v20[33], v20[34], v20[35], v20[36], v20[37], v20[38], v20[39], v20[40], v20[41], v20[42], v20[43], v20[44], v20[45], v20[46], v20[47], v20[48] = p26, v19, enableExplicitFeedback, p27, setGameHidden, p28, v17, p29, p30, p31, v22, v6, isSponsoredRatingFooterAllowed, compactMetadataFormat, v23, if fFlagLuaAppNarrowTileHidePlayerCount then p38 else nil
	local v25 = if fFlagLuaAppUsePrevalidatedVideoGamePlayability then p39 else nil
	local v26 = if fFlagLuaAppContinueSortInstantPlay then p40 else nil
	local v27 = if fFlagLuaAppContinueSortInstantPlay then p41 else nil
	v20[49], v20[50], v20[51], v20[52], v20[53] = v25, videoPlaybackContext, v26, v27, if fFlagLuaAppContinueSortInstantPlay then v14 else nil
	return (useCallback(fn, v20))
end

return useRenderGameCollectionItem
