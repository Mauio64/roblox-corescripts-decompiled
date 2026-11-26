local CentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/CentralOverlay")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Localization")
local Loggers = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Loggers")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/React")
local RoactServiceTags = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RoactServiceTags")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RoactUtils")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RobloxAppEnums")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RobloxAppHooks")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags")

local AbuseVector = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GenericAbuseReporting/AbuseVector")
local OpenDynamicAbuseReport = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GenericAbuseReporting/OpenDynamicAbuseReport")

local activateGameNotInterested = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/activateGameNotInterested")
local tileOverflowMenuItems = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/GameTileConstants").TileOverflowMenuItems

local closeCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
local setCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local iconName = Foundation.Enums.IconName
local useLocalization = Localization.Hooks.useLocalization
local flaggedMutedError = Loggers.flaggedMutedError
local roactNetworking = RoactServiceTags.RoactNetworking
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local centralOverlayType = RobloxAppEnums.CentralOverlayType
local useRoactService = RobloxAppHooks.useRoactService

local fFlagLuaAppEnableReportExperience = SharedFlags.FFlagLuaAppEnableReportExperience
local fFlagEnableNewReportFlowGameTile = SharedFlags.FFlagEnableNewReportFlowGameTile
local fFlagAddThumbnailSelectorReport = SharedFlags.FFlagAddThumbnailSelectorReport
local fFlagLuaAppEnableNxMRoduxApportioning = SharedFlags.FFlagLuaAppEnableNxMRoduxApportioning
local fFlagLuaAppContinueSortInstantPlay = SharedFlags.FFlagLuaAppContinueSortInstantPlay

local function useGameTileActions(data, callback)
	local v5 = useDispatch()
	local v6 = useRoactService(roactNetworking)
	local v7 = useLocalization({
		notInterested = "Feature.GameDetails.Action.NotInterested",
		whyThisAd = "Feature.GameDetails.Action.WhyThisAd",
		reportAd = "Feature.GameDetails.Action.ReportAd",
		reportExperience = fFlagLuaAppEnableReportExperience and "Feature.GameDetails.Action.Report" or nil,
		gameDetails = fFlagLuaAppContinueSortInstantPlay and "Feature.GameDetails.Action.GameDetails" or nil,
		dialogTitle = "Feature.GameDetails.Label.ProvideFeedbackTitle",
		dialogText = "Feature.GameDetails.Message.HelpImproveExperience",
		checkboxListTitle = "Feature.GameDetails.Message.HidingExperienceQuestion",
		tooRepetitive = "Feature.GameDetails.Label.TooRepetitive",
		dontLikeGame = "Feature.GameDetails.Label.DontLikeGame",
		dontLikeImage = "Feature.GameDetails.Label.DontLikeImage",
		inappropriateContent = "Feature.GameDetails.Label.InappropriateContent",
		somethingElse = "Feature.GameDetails.Label.SomethingElse"
	})

	local collectionId = data.collectionId or ""
	local v8

	if fFlagLuaAppContinueSortInstantPlay then
		v8 = React.useCallback(function()
			if data.onGameDetailsActivated then
				data.onGameDetailsActivated()
			end

			if callback then
				callback(tileOverflowMenuItems.GameDetails)
			end
		end, { data.onGameDetailsActivated, callback })
	else
		v8 = nil
	end

	local v9 = React.useCallback(function()
		if activateGameNotInterested({
			appPage = data.appPage,
			collectionId = collectionId,
			dispatch = v5,
			isSponsored = data.isSponsored,
			localizedStrings = v7,
			networking = v6,
			placeId = data.placeId,
			setGameHidden = data.setGameHidden,
			universeId = data.universeId
		}) and callback then
			callback(tileOverflowMenuItems.NotInterested)
		end
	end, {
		collectionId,
		v5,
		v7,
		v6,
		callback,
		data.appPage,
		data.isSponsored,
		data.placeId,
		data.setGameHidden,
		data.universeId
	})

	local useCallback = React.useCallback
	local function fn()
		local whyThisAdModal = centralOverlayType.WhyThisAdModal
		local v12 = {
			universeId = data.universeId,
			payerName = data.payerName,
			sponsoredUserCohort = data.sponsoredUserCohort,
			contentType = 0
		}
		local v13 = if fFlagLuaAppEnableNxMRoduxApportioning then data.contentType else nil
		v12.contentType = v13
		v5(setCentralOverlay(whyThisAdModal, v12))

		if callback then
			callback(tileOverflowMenuItems.WhyThisAd)
		end
	end

	local universeId = data.universeId
	local payerName = data.payerName
	local sponsoredUserCohort = data.sponsoredUserCohort
	local v11 = if fFlagLuaAppEnableNxMRoduxApportioning then data.contentType else nil
	local v12 = useCallback(fn, {
		v5,
		universeId,
		payerName,
		sponsoredUserCohort,
		v11,
		callback
	})

	local v13 = React.useCallback(function()
		if not data.adId then
			flaggedMutedError("ReportSponsoredAdError", "Report ad clicked without valid target ad id")
			return
		end

		v5(OpenDynamicAbuseReport({
			abuseVector = AbuseVector.AdV2,
			targetId = data.adId,
			onClose = function()
				v5(closeCentralOverlay())
			end
		}))

		if callback then
			callback(tileOverflowMenuItems.ReportAd)
		end
	end, { v5, data.adId, callback })
	local v14

	if fFlagLuaAppEnableReportExperience then
		v14 = React.useCallback(function()
			if not data.placeId then
				flaggedMutedError(
					"ReportExperienceError",
					"Report experience clicked without valid target place id"
				)

				return
			end

			local v18 = if fFlagEnableNewReportFlowGameTile then AbuseVector.GameTile else AbuseVector.Place
			v5(OpenDynamicAbuseReport({
				abuseVector = v18,
				targetId = data.placeId,
				custom = fFlagAddThumbnailSelectorReport and {
					universeId = data.universeId
				} or nil,
				onClose = function()
					v5(closeCentralOverlay())
				end
			}))

			if callback then
				callback(tileOverflowMenuItems.ReportExperience)
			end
		end, { v5, data.placeId, data.universeId, callback })
	else
		v14 = nil
	end

	local useMemo = React.useMemo
	local function fn2()
		local v15 = {}

		if
			fFlagLuaAppContinueSortInstantPlay
			and data.availableMenuItems[tileOverflowMenuItems.GameDetails]
		then
			table.insert(v15, {
				icon = "icons/actions/info",
				id = tileOverflowMenuItems.GameDetails,
				text = v7.gameDetails,
				onActivated = v8
			})
		end

		if data.availableMenuItems[tileOverflowMenuItems.NotInterested] then
			table.insert(v15, {
				icon = "icons/actions/block",
				id = tileOverflowMenuItems.NotInterested,
				text = v7.notInterested,
				onActivated = v9
			})
		end

		if data.availableMenuItems[tileOverflowMenuItems.WhyThisAd] then
			table.insert(v15, {
				icon = "icons/actions/info",
				id = tileOverflowMenuItems.WhyThisAd,
				text = v7.whyThisAd,
				onActivated = v12
			})
		end

		if data.availableMenuItems[tileOverflowMenuItems.ReportAd] then
			table.insert(v15, {
				icon = iconName.Flag,
				id = tileOverflowMenuItems.ReportAd,
				text = v7.reportAd,
				onActivated = v13
			})
		end

		if
			fFlagLuaAppEnableReportExperience
			and data.availableMenuItems[tileOverflowMenuItems.ReportExperience]
		then
			table.insert(v15, {
				icon = iconName.Flag,
				id = tileOverflowMenuItems.ReportExperience,
				text = v7.reportExperience,
				onActivated = v14
			})
		end

		return v15
	end

	local v16 = if fFlagLuaAppContinueSortInstantPlay then v8 else nil
	return (useMemo(fn2, {
		v16,
		v9,
		v7,
		v12,
		data.isSponsored,
		data.availableMenuItems,
		v13,
		if fFlagLuaAppEnableReportExperience then v14 else nil
	}))
end

return useGameTileActions
