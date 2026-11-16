local HttpService = game:GetService("HttpService")

local GameTile = script:FindFirstAncestor("GameTile")
local parent = GameTile.Parent

local CentralOverlay = require(parent.CentralOverlay)
local Foundation = require(parent.Foundation)
local Loggers = require(parent.Loggers)
local LoggingProtocol = require(parent.LoggingProtocol)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local RobloxAppToastsRodux = require(parent.RobloxAppToastsRodux)
local SharedFlags = require(parent.SharedFlags)
local UserSignals = require(parent.UserSignals)

local AbuseVector = require(parent.GenericAbuseReporting.AbuseVector)
local CircleMinus = Foundation.Enums.IconName.CircleMinus
local CentralOverlayType = RobloxAppEnums.CentralOverlayType
local CloseCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
local default = LoggingProtocol.default
local OpenDynamicAbuseReport = require(parent.GenericAbuseReporting.OpenDynamicAbuseReport)
local PostSendUserSignal = UserSignals.PostSendUserSignal
local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local SetNetworkingErrorToast = RobloxAppToastsRodux.Thunks.SetNetworkingErrorToast
local UserSignalTypes = UserSignals.UserSignalTypes
local flaggedMutedError = Loggers.flaggedMutedError
local mutedError = Loggers.mutedError

local NotInterestedUserSignalTelemetryEventConfigs = require(GameTile.NotInterestedUserSignalTelemetryEventConfigs)
local sendNotInterestedFeedbackFormAnalytics = require(GameTile.sendNotInterestedFeedbackFormAnalytics)

local FFlagLuaAppMakeDisclaimerOptInForFeedbackForm = SharedFlags.FFlagLuaAppMakeDisclaimerOptInForFeedbackForm
local FFlagLuaAppNotInterestedFeedbackFormTelemetry = SharedFlags.FFlagLuaAppNotInterestedFeedbackFormTelemetry

local function sendFeedbackFormAnalytics(p: string, universeId: string, sortId: string, actionType: string) -- 3 equivalent calls inferred from this helper
	if not FFlagLuaAppNotInterestedFeedbackFormTelemetry then
		return
	end

	sendNotInterestedFeedbackFormAnalytics({
		universeId = universeId,
		sortId = sortId,
		actionType = actionType
	}, p)
end

local function onFeedbackFormClosed(flag: boolean?, appPage: string, universeId: string, collectionId: string) -- 1 equivalent call inferred from this helper
	if flag then
		return
	end

	sendFeedbackFormAnalytics(appPage, universeId, collectionId, "NotInterestedFeedbackFormClosedWithoutSubmit") -- inferred equivalent call
end

local function onFeedbackFormSubmitted(p, textResponse: string, items, appPage: string, collectionId: string, dispatch, networking, placeId: string?, isSponsored: boolean?, universeId: string)
	local assetType

	if isSponsored then
		assetType = UserSignalTypes.AssetType.SponsoredGame
	else
		assetType = UserSignalTypes.AssetType.Game
	end

	local items2 = {}
	local flag = false

	for _, item in items do
		local selected = p[item.id] or false
		table.insert(items2, { id = item.id, selected = selected })

		if item.id == UserSignalTypes.NotInterestedFeedbackItem.InappropriateContent and selected then
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
					dispatch(CloseCentralOverlay())
				end
			}))
		end
	end

	local success, result = pcall(function()
		PostSendUserSignal(networking, {
			stringValue = HttpService:JSONEncode({
				formId = UserSignalTypes.NotInterestedFeedbackFormId.NotInterestedFeedback1,
				titleId = UserSignalTypes.NotInterestedFeedbackFormTitleId.WhyHideExperience,
				textResponse = textResponse,
				items = items2
			})
		}, {
			id = universeId,
			assetType = assetType,
			signalOrigin = {
				productSurface = appPage,
				topicId = collectionId,
				subIds = { collectionId }
			}
		}, UserSignalTypes.SignalValueType.String, UserSignalTypes.SignalType.NotInterestedFeedback):catch(function(p2)
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

	sendFeedbackFormAnalytics(appPage, universeId, collectionId, "NotInterestedFeedbackFormSubmitted") -- inferred equivalent call
end

local function activateGameNotInterested(data): boolean
	local appPage = data.appPage

	if appPage then
		local collectionId = data.collectionId
		local dispatch = data.dispatch
		local networking = data.networking
		local placeId = data.placeId
		local universeId = data.universeId
		local assetType

		if data.isSponsored then
			assetType = UserSignalTypes.AssetType.SponsoredGame
		else
			assetType = UserSignalTypes.AssetType.Game
		end

		local localizedStrings = data.localizedStrings
		local checkboxItems = {
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

		data.setGameHidden(universeId, true)
		dispatch(SetCentralOverlay(CentralOverlayType.ProvideFeedbackToast, {
			feedbackFormProps = {
				dialogTitle = localizedStrings.dialogTitle,
				dialogText = localizedStrings.dialogText,
				checkboxListTitle = localizedStrings.checkboxListTitle,
				checkboxItems = checkboxItems,
				onSubmit = function(p, textResponse)
					onFeedbackFormSubmitted(
						p,
						textResponse,
						checkboxItems,
						appPage,
						collectionId,
						dispatch,
						networking,
						placeId,
						data.isSponsored,
						universeId
					)
				end,
				onClose = FFlagLuaAppNotInterestedFeedbackFormTelemetry and function(p)
					onFeedbackFormClosed(p, appPage, universeId, collectionId) -- inferred equivalent call
				end or nil,
				showTermsOfUseDisclaimer = not FFlagLuaAppMakeDisclaimerOptInForFeedbackForm and nil
			},
			toastIcon = CircleMinus,
			onToastActivated = FFlagLuaAppNotInterestedFeedbackFormTelemetry and function()
				sendFeedbackFormAnalytics(appPage, universeId, collectionId, "NotInterestedFeedbackFormOpened") -- inferred equivalent call
			end or nil
		}))

		local success, result = pcall(function()
			PostSendUserSignal(networking, { boolValue = true }, {
				id = universeId,
				assetType = assetType,
				signalOrigin = {
					productSurface = appPage,
					topicId = collectionId,
					subIds = { collectionId }
				}
			}, UserSignalTypes.SignalValueType.Bool, UserSignalTypes.SignalType.NotInterested):catch(function(p)
				data.setGameHidden(universeId, false)
				dispatch(SetNetworkingErrorToast(p))
				default:logRobloxTelemetryCounter(
					NotInterestedUserSignalTelemetryEventConfigs.NotInterestedUserSignalFailed,
					1
				)
			end)
		end)

		if not success then
			data.setGameHidden(universeId, false)
			mutedError(result)
		end

		return true
	end

	default:logRobloxTelemetryCounter(NotInterestedUserSignalTelemetryEventConfigs.NotInterestedMissingAppPage, 1)

	data.dispatch(SetNetworkingErrorToast())
	return false
end

return activateGameNotInterested
