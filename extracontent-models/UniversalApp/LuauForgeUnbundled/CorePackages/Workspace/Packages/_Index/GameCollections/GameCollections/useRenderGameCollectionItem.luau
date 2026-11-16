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
local SeeAllTile = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/SeeAllTile")
local useNavigateToGameDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/GameTile").useNavigateToGameDetails
local gameCollectionItemTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/DiscoveryTypes").GameCollectionItemTypes
require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/HoldToPlay")
require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/VideoUtils")

local fFlagLuaAppContinueSortInstantPlay = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagLuaAppContinueSortInstantPlay
local fFlagLuaAppEnableReportExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagLuaAppEnableReportExperience
local fFlagLuaAppNarrowTileHideRating = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagLuaAppNarrowTileHideRating
local fFlagLuaAppNarrowTileHidePlayerCount = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagLuaAppNarrowTileHidePlayerCount
local fFlagLuaAppEnableHomepageOneByTwoTile = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagLuaAppEnableHomepageOneByTwoTile

local fFlagLuaAppUsePrevalidatedVideoGamePlayability = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagLuaAppUsePrevalidatedVideoGamePlayability
local fFlagLuaAppEmphasisGameTileVideo = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagLuaAppEmphasisGameTileVideo

local gameCollectionItemType = gameCollectionItemTypes.GameCollectionItemType

local function useRenderGameCollectionItem(p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, onActivated, p14, p15, p16, p17, p18, p19, p20, onSelectionGained, onSelectionLost, callback, p21, p22, p23, p24, p25, onPeekViewClosed, p26, enableExplicitFeedback, p27, setGameHidden, p28, p29, p30, p31, p32, p33, isSponsoredRatingFooterAllowed, p34, p35, p36, compactMetadataFormat, p37, p38, videoPlaybackContext, p39, p40, p41)
	local v5 = usePreferredInput()
	local v6 = useNavigateToGameDetails()

	local v7, v8 = useTriggerGameTileFeedbackCallbacks()

	local v11 = p8 and v5 == Responsive.Input.Pointer

	local v12 = if fFlagLuaAppContinueSortInstantPlay then v5 == Responsive.Input.Touch else nil

	local v13 = p4 == "Wide" or p4 == "Event"

	local v14 = useBreakpointXOrSmaller(Responsive.Keys.Small)
	local v15 = useBreakpointXOrSmaller(Responsive.Keys.XSmall)
	local v16 = fFlagLuaAppNarrowTileHideRating and p37 or fFlagLuaAppNarrowTileHidePlayerCount and p38

	if v14 then
		v14 = p21 > 0 and not v16
	end

	local v17

	if v14 then
		v17 = gameTileConstants.TileTextLines[p4 or gameTileLayoutType.Narrow].largeMetadataTextLines
	else
		v17 = gameTileConstants.TileTextLines[p4 or gameTileLayoutType.Narrow].metadataTextLines
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

		local v18 = if callback then callback(p43) else nil

		local v19 = p27 and p27[p42.universeId]
		local v20 = if p26 then p26 + p43 else nil

		if p42.customRenderFunction then
			local customRenderFunction = p42.customRenderFunction
			local v21 = {
				item = p42,
				index = p43,
				itemSize = p44,
				rowNum = p45,
				zIndex = -p43,
				maxItemIndex = p33,
				SelectionOrder = v20,
				isDisabled = v18,
				onSelectionGained = onSelectionGained,
				onSelectionLost = onSelectionLost,
				topicId = p14,
				source = p13,
				referralSource = p12,
				playerCountStyle = p2,
				hideGameStats = p16,
				gameTileLayoutType = p4,
				hoverTileEnabled = v11,
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
				isHidden = v19,
				sponsoredUserCohort = p29,
				enableSponsoredFeedback = p30,
				enableReportAd = p31,
				enableReportExperience = if fFlagLuaAppEnableReportExperience then p32 else nil,
				enableExplicitFeedback = enableExplicitFeedback,
				videoPlaybackContext = videoPlaybackContext
			}
			local v23 = if fFlagLuaAppEmphasisGameTileVideo or fFlagLuaAppEnableHomepageOneByTwoTile then p25 else nil
			v21.videoAnalytics = v23
			return customRenderFunction(v21)
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
				useGridTile = v13,
				playerCountStyle = p2,
				isSponsoredFooterAllowed = p3,
				gameTileLayoutType = p4,
				useHoverTile = v11,
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
				onGuiStateChanged = v7,
				onActivated = v8,
				isDisabled = v18,
				onSelectionGained = onSelectionGained,
				onSelectionLost = onSelectionLost,
				textSizeOffset = p21,
				contentTextLineCount = p22,
				metadataTextLineCount = v17,
				useExperienceTileMetadata = p23,
				forceHideAgeRatings = p24,
				videoAnalytics = p25,
				onPeekViewClosed = onPeekViewClosed,
				SelectionOrder = v20,
				enableExplicitFeedback = enableExplicitFeedback,
				setGameHidden = setGameHidden,
				appPage = p28,
				isHidden = v19,
				isNarrowScreenXSmall = v15,
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
				isTouchPreferredInput = if fFlagLuaAppContinueSortInstantPlay then v12 else nil
			}), gameCollectionItemType.GameTile
		end
	end

	local v18 = {
		v13,
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
		v11,
		p17,
		p18,
		p19,
		p20,
		p21,
		v7,
		v8,
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
	local v20 = if fFlagLuaAppEnableReportExperience then p32 else nil
	local v21 = if fFlagLuaAppNarrowTileHideRating then p37 else nil
	v18[33], v18[34], v18[35], v18[36], v18[37], v18[38], v18[39], v18[40], v18[41], v18[42], v18[43], v18[44], v18[45], v18[46], v18[47], v18[48] = p26, v17, enableExplicitFeedback, p27, setGameHidden, p28, v15, p29, p30, p31, v20, v6, isSponsoredRatingFooterAllowed, compactMetadataFormat, v21, if fFlagLuaAppNarrowTileHidePlayerCount then p38 else nil
	local v23 = if fFlagLuaAppUsePrevalidatedVideoGamePlayability then p39 else nil
	local v24 = if fFlagLuaAppContinueSortInstantPlay then p40 else nil
	local v25 = if fFlagLuaAppContinueSortInstantPlay then p41 else nil
	v18[49], v18[50], v18[51], v18[52], v18[53] = v23, videoPlaybackContext, v24, v25, if fFlagLuaAppContinueSortInstantPlay then v12 else nil
	return (useCallback(fn, v18))
end

return useRenderGameCollectionItem
