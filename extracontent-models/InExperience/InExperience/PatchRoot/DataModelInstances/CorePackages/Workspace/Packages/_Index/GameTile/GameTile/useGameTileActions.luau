local GameTile = script:FindFirstAncestor("GameTile")
local parent = GameTile.Parent

local CentralOverlay = require(parent.CentralOverlay)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local Loggers = require(parent.Loggers)
local React = require(parent.React)
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactUtils = require(parent.RoactUtils)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local SharedFlags = require(parent.SharedFlags)

local AbuseVector = require(parent.GenericAbuseReporting.AbuseVector)
local OpenDynamicAbuseReport = require(parent.GenericAbuseReporting.OpenDynamicAbuseReport)

local activateGameNotInterested = require(GameTile.activateGameNotInterested)
local GameTileConstants = require(GameTile.GameTileConstants)
local TileOverflowMenuItems = GameTileConstants.TileOverflowMenuItems

local CloseCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local IconName = Foundation.Enums.IconName
local useLocalization = Localization.Hooks.useLocalization
local flaggedMutedError = Loggers.flaggedMutedError
local RoactNetworking = RoactServiceTags.RoactNetworking
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local CentralOverlayType = RobloxAppEnums.CentralOverlayType
local useRoactService = RobloxAppHooks.useRoactService

local FFlagLuaAppEnableReportExperience = SharedFlags.FFlagLuaAppEnableReportExperience
local FFlagEnableNewReportFlowGameTile = SharedFlags.FFlagEnableNewReportFlowGameTile
local FFlagAddThumbnailSelectorReport = SharedFlags.FFlagAddThumbnailSelectorReport
local FFlagLuaAppEnableNxMRoduxApportioning = SharedFlags.FFlagLuaAppEnableNxMRoduxApportioning
local FFlagLuaAppContinueSortInstantPlay = SharedFlags.FFlagLuaAppContinueSortInstantPlay

local function useGameTileActions(data, callback)
	local dispatch = useDispatch()
	local networking = useRoactService(RoactNetworking)
	local localizedStrings = useLocalization({
		notInterested = "Feature.GameDetails.Action.NotInterested",
		whyThisAd = "Feature.GameDetails.Action.WhyThisAd",
		reportAd = "Feature.GameDetails.Action.ReportAd",
		reportExperience = FFlagLuaAppEnableReportExperience and "Feature.GameDetails.Action.Report" or nil,
		gameDetails = FFlagLuaAppContinueSortInstantPlay and "Feature.GameDetails.Action.GameDetails" or nil,
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
	local onActivated

	if FFlagLuaAppContinueSortInstantPlay then
		onActivated = React.useCallback(function()
			if data.onGameDetailsActivated then
				data.onGameDetailsActivated()
			end

			if callback then
				callback(TileOverflowMenuItems.GameDetails)
			end
		end, { data.onGameDetailsActivated, callback })
	else
		onActivated = nil
	end

	local onActivated2 = React.useCallback(function()
		if activateGameNotInterested({
			appPage = data.appPage,
			collectionId = collectionId,
			dispatch = dispatch,
			isSponsored = data.isSponsored,
			localizedStrings = localizedStrings,
			networking = networking,
			placeId = data.placeId,
			setGameHidden = data.setGameHidden,
			universeId = data.universeId
		}) and callback then
			callback(TileOverflowMenuItems.NotInterested)
		end
	end, {
		collectionId,
		dispatch,
		localizedStrings,
		networking,
		callback,
		data.appPage,
		data.isSponsored,
		data.placeId,
		data.setGameHidden,
		data.universeId
	})

	local useCallback = React.useCallback
	local function fn()
		local whyThisAdModal = CentralOverlayType.WhyThisAdModal
		local v = {
			universeId = data.universeId,
			payerName = data.payerName,
			sponsoredUserCohort = data.sponsoredUserCohort,
			contentType = 0
		}
		local contentType

		if FFlagLuaAppEnableNxMRoduxApportioning then
			contentType = data.contentType
		end

		v.contentType = contentType
		dispatch(SetCentralOverlay(whyThisAdModal, v))

		if callback then
			callback(TileOverflowMenuItems.WhyThisAd)
		end
	end

	local universeId = data.universeId
	local payerName = data.payerName
	local sponsoredUserCohort = data.sponsoredUserCohort
	local v

	if FFlagLuaAppEnableNxMRoduxApportioning then
		v = data.contentType
	end

	local onActivated3 = useCallback(fn, {
		dispatch,
		universeId,
		payerName,
		sponsoredUserCohort,
		v,
		callback
	})

	local onActivated4 = React.useCallback(function()
		if not data.adId then
			flaggedMutedError("ReportSponsoredAdError", "Report ad clicked without valid target ad id")
			return
		end

		dispatch(OpenDynamicAbuseReport({
			abuseVector = AbuseVector.AdV2,
			targetId = data.adId,
			onClose = function()
				dispatch(CloseCentralOverlay())
			end
		}))

		if callback then
			callback(TileOverflowMenuItems.ReportAd)
		end
	end, { dispatch, data.adId, callback })
	local onActivated5

	if FFlagLuaAppEnableReportExperience then
		onActivated5 = React.useCallback(function()
			if not data.placeId then
				flaggedMutedError("ReportExperienceError", "Report experience clicked without valid target place id")

				return
			end

			local abuseVector

			if FFlagEnableNewReportFlowGameTile then
				abuseVector = AbuseVector.GameTile
			else
				abuseVector = AbuseVector.Place
			end

			dispatch(OpenDynamicAbuseReport({
				abuseVector = abuseVector,
				targetId = data.placeId,
				custom = FFlagAddThumbnailSelectorReport and { universeId = data.universeId } or nil,
				onClose = function()
					dispatch(CloseCentralOverlay())
				end
			}))

			if callback then
				callback(TileOverflowMenuItems.ReportExperience)
			end
		end, { dispatch, data.placeId, data.universeId, callback })
	else
		onActivated5 = nil
	end

	local useMemo = React.useMemo
	local function fn2()
		local v2 = {}

		if FFlagLuaAppContinueSortInstantPlay and data.availableMenuItems[TileOverflowMenuItems.GameDetails] then
			table.insert(v2, {
				icon = "icons/actions/info",
				id = TileOverflowMenuItems.GameDetails,
				text = localizedStrings.gameDetails,
				onActivated = onActivated
			})
		end

		if data.availableMenuItems[TileOverflowMenuItems.NotInterested] then
			table.insert(v2, {
				icon = "icons/actions/block",
				id = TileOverflowMenuItems.NotInterested,
				text = localizedStrings.notInterested,
				onActivated = onActivated2
			})
		end

		if data.availableMenuItems[TileOverflowMenuItems.WhyThisAd] then
			table.insert(v2, {
				icon = "icons/actions/info",
				id = TileOverflowMenuItems.WhyThisAd,
				text = localizedStrings.whyThisAd,
				onActivated = onActivated3
			})
		end

		if data.availableMenuItems[TileOverflowMenuItems.ReportAd] then
			table.insert(v2, {
				icon = IconName.Flag,
				id = TileOverflowMenuItems.ReportAd,
				text = localizedStrings.reportAd,
				onActivated = onActivated4
			})
		end

		if FFlagLuaAppEnableReportExperience and data.availableMenuItems[TileOverflowMenuItems.ReportExperience] then
			table.insert(v2, {
				icon = IconName.Flag,
				id = TileOverflowMenuItems.ReportExperience,
				text = localizedStrings.reportExperience,
				onActivated = onActivated5
			})
		end

		return v2
	end

	local v2

	if FFlagLuaAppContinueSortInstantPlay then
		v2 = onActivated
	end

	local isSponsored = data.isSponsored
	local availableMenuItems = data.availableMenuItems
	local v3

	if FFlagLuaAppEnableReportExperience then
		v3 = onActivated5
	end

	return (useMemo(fn2, {
		v2,
		onActivated2,
		localizedStrings,
		onActivated3,
		isSponsored,
		availableMenuItems,
		onActivated4,
		v3
	}))
end

return useGameTileActions
