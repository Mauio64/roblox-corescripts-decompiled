local HttpService = game:GetService("HttpService")

local CentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/CentralOverlay")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Foundation")
local Loggers = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Loggers")
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/LoggingProtocol")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RobloxAppEnums")
local RobloxAppToastsRodux = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/RobloxAppToastsRodux")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags")
local UserSignals = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/UserSignals")

local AbuseVector = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GenericAbuseReporting/AbuseVector")
local circleMinus = Foundation.Enums.IconName.CircleMinus
local centralOverlayType = RobloxAppEnums.CentralOverlayType
local closeCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
local default = LoggingProtocol.default
local OpenDynamicAbuseReport = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GenericAbuseReporting/OpenDynamicAbuseReport")
local postSendUserSignal = UserSignals.PostSendUserSignal
local setCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local setNetworkingErrorToast = RobloxAppToastsRodux.Thunks.SetNetworkingErrorToast
local userSignalTypes = UserSignals.UserSignalTypes
local flaggedMutedError = Loggers.flaggedMutedError
local mutedError = Loggers.mutedError

local NotInterestedUserSignalTelemetryEventConfigs = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/NotInterestedUserSignalTelemetryEventConfigs")
local sendNotInterestedFeedbackFormAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/sendNotInterestedFeedbackFormAnalytics")

local fFlagLuaAppMakeDisclaimerOptInForFeedbackForm = SharedFlags.FFlagLuaAppMakeDisclaimerOptInForFeedbackForm
local fFlagLuaAppNotInterestedFeedbackFormTelemetry = SharedFlags.FFlagLuaAppNotInterestedFeedbackFormTelemetry

local function sendFeedbackFormAnalytics(p2, p3, p4, p5)
	if not fFlagLuaAppNotInterestedFeedbackFormTelemetry then
		return
	end

	sendNotInterestedFeedbackFormAnalytics({ universeId = p3, sortId = p4, actionType = p5 }, p2)
end

local function onFeedbackFormClosed(p2, p3, p4, p5)
	if p2 or not fFlagLuaAppNotInterestedFeedbackFormTelemetry then
		return
	end

	sendNotInterestedFeedbackFormAnalytics(
		{
			universeId = p4,
			sortId = p5,
			actionType = "NotInterestedFeedbackFormClosedWithoutSubmit"
		},
		p3
	)
end

local function onFeedbackFormSubmitted(p2, p3, items, appPage, collectionId, dispatch, networking, placeId, isSponsored, universeId)
	local v5

	if isSponsored then
		v5 = userSignalTypes.AssetType.SponsoredGame
	else
		v5 = userSignalTypes.AssetType.Game
	end

	local v6 = {}
	local flag = false

	for k, item in items do
		local v7 = p2[item.id] or false
		table.insert(v6, { id = item.id, selected = v7 })

		if item.id == userSignalTypes.NotInterestedFeedbackItem.InappropriateContent and v7 then
			flag = true
		end
	end

	if flag then
		if placeId == nil or placeId == "" then
			flaggedMutedError("NotInterestedReportPlaceIdMissing", "Place report opened without a place id")
		else
			dispatch(OpenDynamicAbuseReport({
				abuseVector = AbuseVector.Place,
				targetId = placeId,
				onClose = function()
					dispatch(closeCentralOverlay())
				end
			}))
		end
	end

	local success, result = pcall(function()
		postSendUserSignal(networking, {
			stringValue = HttpService:JSONEncode({
				formId = userSignalTypes.NotInterestedFeedbackFormId.NotInterestedFeedback1,
				titleId = userSignalTypes.NotInterestedFeedbackFormTitleId.WhyHideExperience,
				textResponse = p3,
				items = v6
			})
		}, {
			id = universeId,
			assetType = v5,
			signalOrigin = {
				productSurface = appPage,
				topicId = collectionId,
				subIds = { collectionId }
			}
		}, userSignalTypes.SignalValueType.String, userSignalTypes.SignalType.NotInterestedFeedback):catch(function(p4)
			dispatch(setNetworkingErrorToast(p4))
			default:logRobloxTelemetryCounter(NotInterestedUserSignalTelemetryEventConfigs.NotInterestedUserSignalFailed, 1)
		end)
	end)

	if not success then
		mutedError(result)
	end

	if not fFlagLuaAppNotInterestedFeedbackFormTelemetry then
		return
	end

	sendNotInterestedFeedbackFormAnalytics(
		{
			universeId = universeId,
			sortId = collectionId,
			actionType = "NotInterestedFeedbackFormSubmitted"
		},
		appPage
	)
end

local function activateGameNotInterested(data): boolean
	local appPage = data.appPage

	if appPage then
		local collectionId = data.collectionId
		local dispatch = data.dispatch
		local networking = data.networking
		local placeId = data.placeId
		local universeId = data.universeId
		local v5

		if data.isSponsored then
			v5 = userSignalTypes.AssetType.SponsoredGame
		else
			v5 = userSignalTypes.AssetType.Game
		end

		local localizedStrings = data.localizedStrings
		local v6 = {
			{
				id = userSignalTypes.NotInterestedFeedbackItem.TooRepetitive,
				text = localizedStrings.tooRepetitive
			},
			{
				id = userSignalTypes.NotInterestedFeedbackItem.DontLikeGame,
				text = localizedStrings.dontLikeGame
			},
			{
				id = userSignalTypes.NotInterestedFeedbackItem.DontLikeImage,
				text = localizedStrings.dontLikeImage
			},
			{
				id = userSignalTypes.NotInterestedFeedbackItem.InappropriateContent,
				text = localizedStrings.inappropriateContent
			},
			{
				id = userSignalTypes.NotInterestedFeedbackItem.SomethingElse,
				text = localizedStrings.somethingElse,
				triggersOtherTextbox = true
			}
		}

		data.setGameHidden(universeId, true)
		dispatch(setCentralOverlay(centralOverlayType.ProvideFeedbackToast, {
			feedbackFormProps = {
				dialogTitle = localizedStrings.dialogTitle,
				dialogText = localizedStrings.dialogText,
				checkboxListTitle = localizedStrings.checkboxListTitle,
				checkboxItems = v6,
				onSubmit = function(p2, p3)
					onFeedbackFormSubmitted(
						p2,
						p3,
						v6,
						appPage,
						collectionId,
						dispatch,
						networking,
						placeId,
						data.isSponsored,
						universeId
					)
				end,
				onClose = fFlagLuaAppNotInterestedFeedbackFormTelemetry and function(p2)
					if p2 or not fFlagLuaAppNotInterestedFeedbackFormTelemetry then
						return
					end

					sendNotInterestedFeedbackFormAnalytics(
						{
							universeId = universeId,
							sortId = collectionId,
							actionType = "NotInterestedFeedbackFormClosedWithoutSubmit"
						},
						appPage
					)
				end or nil,
				showTermsOfUseDisclaimer = if fFlagLuaAppMakeDisclaimerOptInForFeedbackForm then false else nil
			},
			toastIcon = circleMinus,
			onToastActivated = fFlagLuaAppNotInterestedFeedbackFormTelemetry and function()
				if not fFlagLuaAppNotInterestedFeedbackFormTelemetry then
					return
				end

				sendNotInterestedFeedbackFormAnalytics(
					{
						universeId = universeId,
						sortId = collectionId,
						actionType = "NotInterestedFeedbackFormOpened"
					},
					appPage
				)
			end or nil
		}))

		local success, result = pcall(function()
			postSendUserSignal(networking, { boolValue = true }, {
				id = universeId,
				assetType = v5,
				signalOrigin = {
					productSurface = appPage,
					topicId = collectionId,
					subIds = { collectionId }
				}
			}, userSignalTypes.SignalValueType.Bool, userSignalTypes.SignalType.NotInterested):catch(function(p2)
				data.setGameHidden(universeId, false)
				dispatch(setNetworkingErrorToast(p2))
				default:logRobloxTelemetryCounter(NotInterestedUserSignalTelemetryEventConfigs.NotInterestedUserSignalFailed, 1)
			end)
		end)

		if not success then
			data.setGameHidden(universeId, false)
			mutedError(result)
		end

		return true
	end

	default:logRobloxTelemetryCounter(NotInterestedUserSignalTelemetryEventConfigs.NotInterestedMissingAppPage, 1)

	data.dispatch(setNetworkingErrorToast())
	return false
end

return activateGameNotInterested
