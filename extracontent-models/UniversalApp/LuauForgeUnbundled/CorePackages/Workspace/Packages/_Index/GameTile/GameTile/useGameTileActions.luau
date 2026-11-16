local HttpService = game:GetService("HttpService")

require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/AppBlox")
local CentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/CentralOverlay")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Localization")
local Loggers = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Loggers")
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/LoggingProtocol")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/React")
local RoactServiceTags = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RoactServiceTags")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RoactUtils")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RobloxAppEnums")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RobloxAppHooks")
local RobloxAppToastsRodux = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/RobloxAppToastsRodux")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags")
local UserSignals = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/UserSignals")

local AbuseVector = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GenericAbuseReporting/AbuseVector")
local OpenDynamicAbuseReport = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GenericAbuseReporting/OpenDynamicAbuseReport")

local NotInterestedUserSignalTelemetryEventConfigs = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/NotInterestedUserSignalTelemetryEventConfigs")
local activateGameNotInterested = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/activateGameNotInterested")
local sendNotInterestedFeedbackFormAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/sendNotInterestedFeedbackFormAnalytics")
local tileOverflowMenuItems = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/GameTileConstants").TileOverflowMenuItems

local closeCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
local setCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local iconName = Foundation.Enums.IconName
local useLocalization = Localization.Hooks.useLocalization
local flaggedMutedError = Loggers.flaggedMutedError
local mutedError = Loggers.mutedError
local default = LoggingProtocol.default
local roactNetworking = RoactServiceTags.RoactNetworking
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local centralOverlayType = RobloxAppEnums.CentralOverlayType
local useRoactService = RobloxAppHooks.useRoactService
local setNetworkingErrorToast = RobloxAppToastsRodux.Thunks.SetNetworkingErrorToast
local postSendUserSignal = UserSignals.PostSendUserSignal
local userSignalTypes = UserSignals.UserSignalTypes

local fFlagLuaAppMakeDisclaimerOptInForFeedbackForm = SharedFlags.FFlagLuaAppMakeDisclaimerOptInForFeedbackForm
local fFlagLuaAppNotInterestedFeedbackFormTelemetry = SharedFlags.FFlagLuaAppNotInterestedFeedbackFormTelemetry
local fFlagLuaAppEnableReportExperience = SharedFlags.FFlagLuaAppEnableReportExperience
local fFlagEnableNewReportFlowGameTile = SharedFlags.FFlagEnableNewReportFlowGameTile
local fFlagAddThumbnailSelectorReport = SharedFlags.FFlagAddThumbnailSelectorReport
local fFlagLuaAppEnableHomepageOneByTwoTile = SharedFlags.FFlagLuaAppEnableHomepageOneByTwoTile
local fFlagLuaAppContinueSortInstantPlay = SharedFlags.FFlagLuaAppContinueSortInstantPlay
local fFlagLuaAppExtractNotInterestedHelper = SharedFlags.FFlagLuaAppExtractNotInterestedHelper

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

	local v8 = React.useMemo(function()
		return {
			{
				id = userSignalTypes.NotInterestedFeedbackItem.TooRepetitive,
				text = v7.tooRepetitive
			},
			{
				id = userSignalTypes.NotInterestedFeedbackItem.DontLikeGame,
				text = v7.dontLikeGame
			},
			{
				id = userSignalTypes.NotInterestedFeedbackItem.DontLikeImage,
				text = v7.dontLikeImage
			},
			{
				id = userSignalTypes.NotInterestedFeedbackItem.InappropriateContent,
				text = v7.inappropriateContent
			},
			{
				id = userSignalTypes.NotInterestedFeedbackItem.SomethingElse,
				text = v7.somethingElse,
				triggersOtherTextbox = true
			}
		}
	end, { v7 })

	local v9 = React.useCallback(function(p2, p3)
		local v10 = {}
		local flag = false

		for k, v11 in v8 do
			table.insert(v10, {
				id = v11.id,
				selected = p2[v11.id] or false
			})

			if v11.id == userSignalTypes.NotInterestedFeedbackItem.InappropriateContent and p2[v11.id] then
				flag = true
			end
		end

		if flag then
			if data.placeId and data.placeId ~= "" then
				v5(OpenDynamicAbuseReport({
					abuseVector = AbuseVector.Place,
					targetId = data.placeId,
					onClose = function()
						v5(closeCentralOverlay())
					end
				}))
			else
				flaggedMutedError(
					"NotInterestedReportPlaceIdMissing",
					"Place report opened without a place id"
				)
			end
		end

		if data.appPage then
			local success, result = pcall(function()
				local v13 = {
					stringValue = HttpService:JSONEncode({
						formId = userSignalTypes.NotInterestedFeedbackFormId.NotInterestedFeedback1,
						titleId = userSignalTypes.NotInterestedFeedbackFormTitleId.WhyHideExperience,
						textResponse = p3,
						items = v10
					})
				}

				local v14 = { id = data.universeId, assetType = 0, signalOrigin = 0 }
				local v15 = if data.isSponsored then userSignalTypes.AssetType.SponsoredGame else userSignalTypes.AssetType.Game
				v14.assetType = v15

				v14.signalOrigin = {
					productSurface = data.appPage,
					topicId = collectionId,
					subIds = { collectionId }
				}
				postSendUserSignal(
					v6,
					v13,
					v14,
					userSignalTypes.SignalValueType.String,
					userSignalTypes.SignalType.NotInterestedFeedback
				):catch(function(p4)
					v5(setNetworkingErrorToast(p4))
					default:logRobloxTelemetryCounter(NotInterestedUserSignalTelemetryEventConfigs.NotInterestedUserSignalFailed, 1)
				end)
			end)

			if not success then
				mutedError(result)
			end

			if fFlagLuaAppNotInterestedFeedbackFormTelemetry then
				sendNotInterestedFeedbackFormAnalytics(
					{
						universeId = data.universeId,
						sortId = collectionId,
						actionType = "NotInterestedFeedbackFormSubmitted"
					},
					data.appPage
				)
			end
		else
			default:logRobloxTelemetryCounter(NotInterestedUserSignalTelemetryEventConfigs.NotInterestedMissingAppPage, 1)

			v5(setNetworkingErrorToast())
		end
	end, {
		v6,
		v8,
		v7,
		data.universeId,
		data.placeId,
		data.appPage,
		collectionId,
		v5,
		data.isSponsored
	})
	local v10, v11

	if fFlagLuaAppNotInterestedFeedbackFormTelemetry then
		v10 = React.useCallback(function(p2)
			if p2 then
				return
			end

			sendNotInterestedFeedbackFormAnalytics(
				{
					universeId = data.universeId,
					sortId = collectionId,
					actionType = "NotInterestedFeedbackFormClosedWithoutSubmit"
				},
				data.appPage
			)
		end, { data.appPage, data.universeId, collectionId })

		v11 = React.useCallback(function()
			sendNotInterestedFeedbackFormAnalytics(
				{
					universeId = data.universeId,
					sortId = collectionId,
					actionType = "NotInterestedFeedbackFormOpened"
				},
				data.appPage
			)
		end, { data.appPage, data.universeId, collectionId })
	else
		v10 = nil
		v11 = nil
	end

	local function fn()
		return {
			dialogTitle = v7.dialogTitle,
			dialogText = v7.dialogText,
			checkboxListTitle = v7.checkboxListTitle,
			checkboxItems = v8,
			onSubmit = v9,
			onClose = if fFlagLuaAppNotInterestedFeedbackFormTelemetry then v10 else nil,
			showTermsOfUseDisclaimer = if fFlagLuaAppMakeDisclaimerOptInForFeedbackForm then false else nil
		}
	end

	local v14 = React.useMemo(fn, {
		v7,
		v8,
		v9,
		if fFlagLuaAppNotInterestedFeedbackFormTelemetry then v10 else nil
	})
	local v15

	if fFlagLuaAppContinueSortInstantPlay then
		v15 = React.useCallback(function()
			if data.onGameDetailsActivated then
				data.onGameDetailsActivated()
			end

			if callback then
				callback(tileOverflowMenuItems.GameDetails)
			end
		end, { data.onGameDetailsActivated, callback })
	else
		v15 = nil
	end

	local v16

	if fFlagLuaAppExtractNotInterestedHelper then
		v16 = React.useCallback(function()
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
	else
		local function fn2()
			if data.appPage then
				data.setGameHidden(data.universeId, true)
				v5(setCentralOverlay(centralOverlayType.ProvideFeedbackToast, {
					feedbackFormProps = v14,
					toastIcon = iconName.CircleMinus,
					onToastActivated = if fFlagLuaAppNotInterestedFeedbackFormTelemetry then v11 else nil
				}))

				local success, result = pcall(function()
					local v24 = {
						id = data.universeId,
						assetType = 0,
						signalOrigin = 0
					}
					local v25 = if data.isSponsored then userSignalTypes.AssetType.SponsoredGame else userSignalTypes.AssetType.Game
					v24.assetType = v25

					v24.signalOrigin = {
						productSurface = data.appPage,
						topicId = collectionId,
						subIds = { collectionId }
					}
					postSendUserSignal(
						v6,
						{ boolValue = true },
						v24,
						userSignalTypes.SignalValueType.Bool,
						userSignalTypes.SignalType.NotInterested
					):catch(function(p2)
						data.setGameHidden(data.universeId, false)
						v5(setNetworkingErrorToast(p2))
						default:logRobloxTelemetryCounter(NotInterestedUserSignalTelemetryEventConfigs.NotInterestedUserSignalFailed, 1)
					end)
				end)

				if not success then
					data.setGameHidden(data.universeId, false)
					mutedError(result)
				end

				if callback then
					callback(tileOverflowMenuItems.NotInterested)
				end
			else
				default:logRobloxTelemetryCounter(NotInterestedUserSignalTelemetryEventConfigs.NotInterestedMissingAppPage, 1)

				v5(setNetworkingErrorToast())
			end
		end

		v16 = React.useCallback(fn2, {
			v6,
			data.setGameHidden,
			v5,
			v14,
			data.universeId,
			collectionId,
			data.appPage,
			callback,
			data.isSponsored,
			if fFlagLuaAppNotInterestedFeedbackFormTelemetry then v11 else nil
		})
	end

	local useCallback = React.useCallback
	local function fn2()
		local whyThisAdModal = centralOverlayType.WhyThisAdModal
		local v19 = {
			universeId = data.universeId,
			payerName = data.payerName,
			sponsoredUserCohort = data.sponsoredUserCohort,
			contentType = 0
		}
		local v20 = if fFlagLuaAppEnableHomepageOneByTwoTile then data.contentType else nil
		v19.contentType = v20
		v5(setCentralOverlay(whyThisAdModal, v19))

		if callback then
			callback(tileOverflowMenuItems.WhyThisAd)
		end
	end

	local universeId = data.universeId
	local payerName = data.payerName
	local sponsoredUserCohort = data.sponsoredUserCohort
	local v18 = if fFlagLuaAppEnableHomepageOneByTwoTile then data.contentType else nil
	local v19 = useCallback(fn2, {
		v5,
		universeId,
		payerName,
		sponsoredUserCohort,
		v18,
		callback
	})

	local v20 = React.useCallback(function()
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
	local v21

	if fFlagLuaAppEnableReportExperience then
		v21 = React.useCallback(function()
			if not data.placeId then
				flaggedMutedError(
					"ReportExperienceError",
					"Report experience clicked without valid target place id"
				)

				return
			end

			local v25 = if fFlagEnableNewReportFlowGameTile then AbuseVector.GameTile else AbuseVector.Place
			v5(OpenDynamicAbuseReport({
				abuseVector = v25,
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
		v21 = nil
	end

	local useMemo2 = React.useMemo
	local function fn3()
		local v22 = {}

		if
			fFlagLuaAppContinueSortInstantPlay
			and data.availableMenuItems[tileOverflowMenuItems.GameDetails]
		then
			table.insert(v22, {
				icon = "icons/actions/info",
				id = tileOverflowMenuItems.GameDetails,
				text = v7.gameDetails,
				onActivated = v15
			})
		end

		if data.availableMenuItems[tileOverflowMenuItems.NotInterested] then
			table.insert(v22, {
				icon = "icons/actions/block",
				id = tileOverflowMenuItems.NotInterested,
				text = v7.notInterested,
				onActivated = v16
			})
		end

		if data.availableMenuItems[tileOverflowMenuItems.WhyThisAd] then
			table.insert(v22, {
				icon = "icons/actions/info",
				id = tileOverflowMenuItems.WhyThisAd,
				text = v7.whyThisAd,
				onActivated = v19
			})
		end

		if data.availableMenuItems[tileOverflowMenuItems.ReportAd] then
			table.insert(v22, {
				icon = iconName.Flag,
				id = tileOverflowMenuItems.ReportAd,
				text = v7.reportAd,
				onActivated = v20
			})
		end

		if
			fFlagLuaAppEnableReportExperience
			and data.availableMenuItems[tileOverflowMenuItems.ReportExperience]
		then
			table.insert(v22, {
				icon = iconName.Flag,
				id = tileOverflowMenuItems.ReportExperience,
				text = v7.reportExperience,
				onActivated = v21
			})
		end

		return v22
	end

	local v23 = if fFlagLuaAppContinueSortInstantPlay then v15 else nil
	return (useMemo2(fn3, {
		v23,
		v16,
		v7,
		v19,
		data.isSponsored,
		data.availableMenuItems,
		v20,
		if fFlagLuaAppEnableReportExperience then v21 else nil
	}))
end

return useGameTileActions
