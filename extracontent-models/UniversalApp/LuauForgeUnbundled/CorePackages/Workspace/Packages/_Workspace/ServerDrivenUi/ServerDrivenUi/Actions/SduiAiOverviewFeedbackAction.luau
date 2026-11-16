local HttpService = game:GetService("HttpService")

local CentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/CentralOverlay")
local DiscoveryAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DiscoveryAnalytics")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Foundation")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RobloxAppEnums")
local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local UserSignals = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/UserSignals")

local buttonVariant = Foundation.Enums.ButtonVariant
local centralOverlayType = RobloxAppEnums.CentralOverlayType
local setCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local sduiActionType = SduiCoreSystem.SduiActionType
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local findAnalyticsFieldInAncestors = SduiCoreSystem.findAnalyticsFieldInAncestors

local postSendUserSignal = UserSignals.PostSendUserSignal
local userSignalTypes = UserSignals.UserSignalTypes

local aiOverviewSentiment = DiscoveryAnalytics.Events.aiOverviewSentiment
local aiOverviewExplicitFeedback = DiscoveryAnalytics.Events.aiOverviewExplicitFeedback

local aiOverviewSentiment2 = DiscoveryAnalytics.Constants.AiOverviewSentiment

local set = {
	[aiOverviewSentiment2.ThumbsUp] = true,
	[aiOverviewSentiment2.ThumbsDown] = true
}

local function reportInvalidParam(p2, p3, p4)
	p2.dependencies.logger.reportError(
		sduiErrorType.InvalidActionParams,
		{ name = sduiActionType.AiOverviewFeedback, message = p3, propName = p4 },
		p2.appPage
	)
end

local function sendUserSignal(p2, networking, p3, p4, p5, p6)
	local success, result = pcall(function()
		postSendUserSignal(networking, { stringValue = HttpService:JSONEncode(p6) }, {
			id = p3,
			assetType = userSignalTypes.AssetType.PowerSearch,
			signalOrigin = {
				productSurface = p4,
				topicId = "PowerSearch",
				subIds = { "PowerSearch" }
			}
		}, userSignalTypes.SignalValueType.String, p5):catch(function(p7)
			p2.dependencies.logger.reportError(
				sduiErrorType.ActionNetworkRequestFailed,
				{ name = sduiActionType.AiOverviewFeedback, message = tostring(p7) },
				p2.appPage
			)
		end)
	end)

	if not success then
		p2.dependencies.logger.reportError(
			sduiErrorType.ActionNetworkRequestFailed,
			{ name = sduiActionType.AiOverviewFeedback, message = tostring(result) },
			p2.appPage
		)
	end
end

local function SduiAiOverviewFeedbackAction(p2, p3, p4, p5)
	local actionParams = if p2 then p2.actionParams else nil

	if actionParams == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.AiOverviewFeedback,
				message = "Missing actionParams",
				propName = nil
			},
			p4.appPage
		)

		return
	end

	local sentiment = actionParams.sentiment

	if typeof(sentiment) == "string" and set[sentiment] then
		local productSurface = actionParams.productSurface
		local v5 = (typeof(productSurface) ~= "string" or productSurface == "") and "Unknown"
			or productSurface

		local v6 = findAnalyticsFieldInAncestors("searchSessionId", p3) or ""
		local v7 = findAnalyticsFieldInAncestors("searchQuery", p3) or ""
		local analyticsFieldInAncestors = findAnalyticsFieldInAncestors("universeIds", p3)
		local appPage = p4.appPage
		local networking = p4.dependencies.networking

		sendUserSignal(p4, networking, v6, v5, userSignalTypes.SignalType.AiOverviewSentiment, {
			sentiment = sentiment,
			query = v7,
			universe_ids = analyticsFieldInAncestors
		})

		p4.dependencies.dispatch(setCentralOverlay(centralOverlayType.TextFeedbackFormModal, {
			dialogTitle = actionParams.dialogTitle or "",
			dialogText = actionParams.dialogText,
			placeholderText = actionParams.placeholderText,
			buttonVariant = buttonVariant.Emphasis,
			showTermsOfUseDisclaimer = true,
			onSubmit = function(p6)
				sendUserSignal(
					p4,
					networking,
					v6,
					v5,
					userSignalTypes.SignalType.AiOverviewExplicitFeedback,
					{ sentiment = sentiment, feedback_text = p6, query = v7 }
				)

				aiOverviewExplicitFeedback({
					sentiment = sentiment,
					searchSessionId = v6,
					query = v7,
					didSubmit = true,
					feedbackText = p6
				}, appPage)
			end,
			onClose = function(p6)
				if p6 then
					return
				end

				sendUserSignal(
					p4,
					networking,
					v6,
					v5,
					userSignalTypes.SignalType.AiOverviewExplicitFeedback,
					{ sentiment = sentiment, feedback_text = "", query = v7 }
				)

				aiOverviewExplicitFeedback(
					{
						sentiment = sentiment,
						searchSessionId = v6,
						query = v7,
						didSubmit = false
					},
					appPage
				)
			end
		}))

		aiOverviewSentiment(
			{
				sentiment = sentiment,
				searchSessionId = v6,
				query = v7,
				universeIds = analyticsFieldInAncestors
			},
			appPage
		)
	else
		local formatted = `Invalid or missing sentiment: {tostring(sentiment)}`
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.AiOverviewFeedback,
				message = formatted,
				propName = "sentiment"
			},
			p4.appPage
		)
	end
end

return SduiAiOverviewFeedbackAction
