local HttpService = game:GetService("HttpService")

local GameTile = script:FindFirstAncestor("GameTile")
local parent = GameTile.Parent

require(parent.AppBlox)
local CentralOverlay = require(parent.CentralOverlay)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local Loggers = require(parent.Loggers)
local LoggingProtocol = require(parent.LoggingProtocol)
local React = require(parent.React)
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactUtils = require(parent.RoactUtils)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local RobloxAppToastsRodux = require(parent.RobloxAppToastsRodux)
local SharedFlags = require(parent.SharedFlags)
local UserSignals = require(parent.UserSignals)

local AbuseVector = require(parent.GenericAbuseReporting.AbuseVector)
local OpenDynamicAbuseReport = require(parent.GenericAbuseReporting.OpenDynamicAbuseReport)

local NotInterestedUserSignalTelemetryEventConfigs = require(GameTile.NotInterestedUserSignalTelemetryEventConfigs)
local activateGameNotInterested = require(GameTile.activateGameNotInterested)
local sendNotInterestedFeedbackFormAnalytics = require(GameTile.sendNotInterestedFeedbackFormAnalytics)
local GameTileConstants = require(GameTile.GameTileConstants)
local TileOverflowMenuItems = GameTileConstants.TileOverflowMenuItems

local CloseCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local IconName = Foundation.Enums.IconName
local useLocalization = Localization.Hooks.useLocalization
local flaggedMutedError = Loggers.flaggedMutedError
local mutedError = Loggers.mutedError
local default = LoggingProtocol.default
local RoactNetworking = RoactServiceTags.RoactNetworking
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local CentralOverlayType = RobloxAppEnums.CentralOverlayType
local useRoactService = RobloxAppHooks.useRoactService
local SetNetworkingErrorToast = RobloxAppToastsRodux.Thunks.SetNetworkingErrorToast
local PostSendUserSignal = UserSignals.PostSendUserSignal
local UserSignalTypes = UserSignals.UserSignalTypes

local FFlagLuaAppMakeDisclaimerOptInForFeedbackForm = SharedFlags.FFlagLuaAppMakeDisclaimerOptInForFeedbackForm
local FFlagLuaAppNotInterestedFeedbackFormTelemetry = SharedFlags.FFlagLuaAppNotInterestedFeedbackFormTelemetry
local FFlagLuaAppEnableReportExperience = SharedFlags.FFlagLuaAppEnableReportExperience
local FFlagEnableNewReportFlowGameTile = SharedFlags.FFlagEnableNewReportFlowGameTile
local FFlagAddThumbnailSelectorReport = SharedFlags.FFlagAddThumbnailSelectorReport
local FFlagLuaAppEnableHomepageOneByTwoTile = SharedFlags.FFlagLuaAppEnableHomepageOneByTwoTile
local FFlagLuaAppContinueSortInstantPlay = SharedFlags.FFlagLuaAppContinueSortInstantPlay
local FFlagLuaAppExtractNotInterestedHelper = SharedFlags.FFlagLuaAppExtractNotInterestedHelper

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

	local checkboxItems = React.useMemo(function()
		return {
			{
				id = UserSignalTypes.NotInterestedFeedbackItem.TooRepetitive,
				text = localizedStrings.tooRepetitive
			},
			{
				id = UserSignalTypes.NotInterestedFeedbackItem.DontLikeGame,
				text = localizedStrings.dontLikeGame
			},
			{
				id = UserSignalTypes.NotInterestedFeedbackItem.DontLikeImage,
				text = localizedStrings.dontLikeImage
			},
			{
				id = UserSignalTypes.NotInterestedFeedbackItem.InappropriateContent,
				text = localizedStrings.inappropriateContent
			},
			{
				id = UserSignalTypes.NotInterestedFeedbackItem.SomethingElse,
				text = localizedStrings.somethingElse,
				triggersOtherTextbox = true
			}
		}
	end, { localizedStrings })

	local onSubmit = React.useCallback(function(p, textResponse: string)
		local items = {}
		local flag = false

		for _, v in checkboxItems do
			table.insert(items, {
				id = v.id,
				selected = p[v.id] or false
			})

			if v.id == UserSignalTypes.NotInterestedFeedbackItem.InappropriateContent and p[v.id] then
				flag = true
			end
		end

		if flag then
			if data.placeId and data.placeId ~= "" then
				dispatch(OpenDynamicAbuseReport({
					abuseVector = AbuseVector.Place,
					targetId = data.placeId,
					onClose = function()
						dispatch(CloseCentralOverlay())
					end
				}))
			else
				flaggedMutedError("NotInterestedReportPlaceIdMissing", "Place report opened without a place id")
			end
		end

		if data.appPage then
			local success, result = pcall(function()
				local v = {
					stringValue = HttpService:JSONEncode({
						formId = UserSignalTypes.NotInterestedFeedbackFormId.NotInterestedFeedback1,
						titleId = UserSignalTypes.NotInterestedFeedbackFormTitleId.WhyHideExperience,
						textResponse = textResponse,
						items = items
					})
				}

				local v2 = { id = data.universeId, assetType = 0, signalOrigin = 0 }
				local assetType

				if data.isSponsored then
					assetType = UserSignalTypes.AssetType.SponsoredGame
				else
					assetType = UserSignalTypes.AssetType.Game
				end

				v2.assetType = assetType

				v2.signalOrigin = {
					productSurface = data.appPage,
					topicId = collectionId,
					subIds = { collectionId }
				}
				PostSendUserSignal(
					networking,
					v,
					v2,
					UserSignalTypes.SignalValueType.String,
					UserSignalTypes.SignalType.NotInterestedFeedback
				):catch(function(p2)
					dispatch(SetNetworkingErrorToast(p2))
					default:logRobloxTelemetryCounter(
						NotInterestedUserSignalTelemetryEventConfigs.NotInterestedUserSignalFailed,
						1
					)
				end)
			end)

			if not success then
				mutedError(result)
			end

			if FFlagLuaAppNotInterestedFeedbackFormTelemetry then
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
			default:logRobloxTelemetryCounter(
				NotInterestedUserSignalTelemetryEventConfigs.NotInterestedMissingAppPage,
				1
			)

			dispatch(SetNetworkingErrorToast())
		end
	end, {
		networking,
		checkboxItems,
		localizedStrings,
		data.universeId,
		data.placeId,
		data.appPage,
		collectionId,
		dispatch,
		data.isSponsored
	})
	local v, v2

	if FFlagLuaAppNotInterestedFeedbackFormTelemetry then
		v = React.useCallback(function(flag: boolean?)
			if flag then
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

		v2 = React.useCallback(function()
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
		v = nil
		v2 = nil
	end

	local useMemo = React.useMemo
	local function fn()
		local v3 = {
			dialogTitle = localizedStrings.dialogTitle,
			dialogText = localizedStrings.dialogText,
			checkboxListTitle = localizedStrings.checkboxListTitle,
			checkboxItems = checkboxItems,
			onSubmit = onSubmit,
			onClose = 0,
			showTermsOfUseDisclaimer = 0
		}
		local onClose

		if FFlagLuaAppNotInterestedFeedbackFormTelemetry then
			onClose = v
		end

		v3.onClose = onClose
		v3.showTermsOfUseDisclaimer = not FFlagLuaAppMakeDisclaimerOptInForFeedbackForm and nil
		return v3
	end

	local v3

	if FFlagLuaAppNotInterestedFeedbackFormTelemetry then
		v3 = v
	end

	local feedbackFormProps = useMemo(fn, { localizedStrings, checkboxItems, onSubmit, v3 })
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

	local onActivated2

	if FFlagLuaAppExtractNotInterestedHelper then
		onActivated2 = React.useCallback(function()
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
	else
		local useCallback = React.useCallback
		local function fn2()
			if data.appPage then
				data.setGameHidden(data.universeId, true)
				local provideFeedbackToast = CentralOverlayType.ProvideFeedbackToast
				local v4 = {
					feedbackFormProps = feedbackFormProps,
					toastIcon = IconName.CircleMinus,
					onToastActivated = 0
				}
				local onToastActivated

				if FFlagLuaAppNotInterestedFeedbackFormTelemetry then
					onToastActivated = v2
				end

				v4.onToastActivated = onToastActivated
				dispatch(SetCentralOverlay(provideFeedbackToast, v4))

				local success, result = pcall(function()
					local v5 = { id = data.universeId, assetType = 0, signalOrigin = 0 }
					local assetType

					if data.isSponsored then
						assetType = UserSignalTypes.AssetType.SponsoredGame
					else
						assetType = UserSignalTypes.AssetType.Game
					end

					v5.assetType = assetType

					v5.signalOrigin = {
						productSurface = data.appPage,
						topicId = collectionId,
						subIds = { collectionId }
					}
					PostSendUserSignal(
						networking,
						{ boolValue = true },
						v5,
						UserSignalTypes.SignalValueType.Bool,
						UserSignalTypes.SignalType.NotInterested
					):catch(function(p)
						data.setGameHidden(data.universeId, false)
						dispatch(SetNetworkingErrorToast(p))
						default:logRobloxTelemetryCounter(
							NotInterestedUserSignalTelemetryEventConfigs.NotInterestedUserSignalFailed,
							1
						)
					end)
				end)

				if not success then
					data.setGameHidden(data.universeId, false)
					mutedError(result)
				end

				if callback then
					callback(TileOverflowMenuItems.NotInterested)
				end
			else
				default:logRobloxTelemetryCounter(
					NotInterestedUserSignalTelemetryEventConfigs.NotInterestedMissingAppPage,
					1
				)

				dispatch(SetNetworkingErrorToast())
			end
		end

		local setGameHidden = data.setGameHidden

		local universeId = data.universeId

		local appPage = data.appPage

		local isSponsored = data.isSponsored
		local v4

		if FFlagLuaAppNotInterestedFeedbackFormTelemetry then
			v4 = v2
		end

		onActivated2 = useCallback(fn2, {
			networking,
			setGameHidden,
			dispatch,
			feedbackFormProps,
			universeId,
			collectionId,
			appPage,
			callback,
			isSponsored,
			v4
		})
	end

	local useCallback = React.useCallback
	local function fn2()
		local whyThisAdModal = CentralOverlayType.WhyThisAdModal
		local v4 = {
			universeId = data.universeId,
			payerName = data.payerName,
			sponsoredUserCohort = data.sponsoredUserCohort,
			contentType = 0
		}
		local contentType

		if FFlagLuaAppEnableHomepageOneByTwoTile then
			contentType = data.contentType
		end

		v4.contentType = contentType
		dispatch(SetCentralOverlay(whyThisAdModal, v4))

		if callback then
			callback(TileOverflowMenuItems.WhyThisAd)
		end
	end

	local universeId = data.universeId
	local payerName = data.payerName
	local sponsoredUserCohort = data.sponsoredUserCohort
	local v4

	if FFlagLuaAppEnableHomepageOneByTwoTile then
		v4 = data.contentType
	end

	local onActivated3 = useCallback(fn2, {
		dispatch,
		universeId,
		payerName,
		sponsoredUserCohort,
		v4,
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

	local useMemo2 = React.useMemo
	local function fn3()
		local v5 = {}

		if FFlagLuaAppContinueSortInstantPlay and data.availableMenuItems[TileOverflowMenuItems.GameDetails] then
			table.insert(v5, {
				icon = "icons/actions/info",
				id = TileOverflowMenuItems.GameDetails,
				text = localizedStrings.gameDetails,
				onActivated = onActivated
			})
		end

		if data.availableMenuItems[TileOverflowMenuItems.NotInterested] then
			table.insert(v5, {
				icon = "icons/actions/block",
				id = TileOverflowMenuItems.NotInterested,
				text = localizedStrings.notInterested,
				onActivated = onActivated2
			})
		end

		if data.availableMenuItems[TileOverflowMenuItems.WhyThisAd] then
			table.insert(v5, {
				icon = "icons/actions/info",
				id = TileOverflowMenuItems.WhyThisAd,
				text = localizedStrings.whyThisAd,
				onActivated = onActivated3
			})
		end

		if data.availableMenuItems[TileOverflowMenuItems.ReportAd] then
			table.insert(v5, {
				icon = IconName.Flag,
				id = TileOverflowMenuItems.ReportAd,
				text = localizedStrings.reportAd,
				onActivated = onActivated4
			})
		end

		if FFlagLuaAppEnableReportExperience and data.availableMenuItems[TileOverflowMenuItems.ReportExperience] then
			table.insert(v5, {
				icon = IconName.Flag,
				id = TileOverflowMenuItems.ReportExperience,
				text = localizedStrings.reportExperience,
				onActivated = onActivated5
			})
		end

		return v5
	end

	local v5

	if FFlagLuaAppContinueSortInstantPlay then
		v5 = onActivated
	end

	local isSponsored = data.isSponsored
	local availableMenuItems = data.availableMenuItems
	local v6

	if FFlagLuaAppEnableReportExperience then
		v6 = onActivated5
	end

	return (useMemo2(fn3, {
		v5,
		onActivated2,
		localizedStrings,
		onActivated3,
		isSponsored,
		availableMenuItems,
		onActivated4,
		v6
	}))
end

return useGameTileActions
