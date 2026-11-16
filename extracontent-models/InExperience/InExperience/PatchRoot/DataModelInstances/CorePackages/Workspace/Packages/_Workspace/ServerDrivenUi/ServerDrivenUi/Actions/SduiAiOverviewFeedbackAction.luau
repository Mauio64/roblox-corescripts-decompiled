local HttpService = game:GetService("HttpService")

local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local CentralOverlay = require(parent.CentralOverlay)
local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local Foundation = require(parent.Foundation)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local SduiCoreSystem = require(parent.SduiCoreSystem)
local UserSignals = require(parent.UserSignals)

local ButtonVariant = Foundation.Enums.ButtonVariant
local CentralOverlayType = RobloxAppEnums.CentralOverlayType
local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local findAnalyticsFieldInAncestors = SduiCoreSystem.findAnalyticsFieldInAncestors

local PostSendUserSignal = UserSignals.PostSendUserSignal
local UserSignalTypes = UserSignals.UserSignalTypes

local aiOverviewSentiment = DiscoveryAnalytics.Events.aiOverviewSentiment
local aiOverviewExplicitFeedback = DiscoveryAnalytics.Events.aiOverviewExplicitFeedback

local AiOverviewSentiment = DiscoveryAnalytics.Constants.AiOverviewSentiment

local set = { [AiOverviewSentiment.ThumbsUp] = true, [AiOverviewSentiment.ThumbsDown] = true }

local function reportInvalidParam(p, message: string, propName: string?) -- 2 equivalent calls inferred from this helper
	p.dependencies.logger.reportError(
		SduiErrorType.InvalidActionParams,
		{ name = SduiActionType.AiOverviewFeedback, message = message, propName = propName },
		p.appPage
	)
end

local function sendUserSignal(p, networking, id: string, productSurface: string, p2, p3)
	local success, result = pcall(function()
		PostSendUserSignal(networking, { stringValue = HttpService:JSONEncode(p3) }, {
			id = id,
			assetType = UserSignalTypes.AssetType.PowerSearch,
			signalOrigin = {
				productSurface = productSurface,
				topicId = "PowerSearch",
				subIds = { "PowerSearch" }
			}
		}, UserSignalTypes.SignalValueType.String, p2):catch(function(p4)
			p.dependencies.logger.reportError(
				SduiErrorType.ActionNetworkRequestFailed,
				{ name = SduiActionType.AiOverviewFeedback, message = tostring(p4) },
				p.appPage
			)
		end)
	end)

	if not success then
		p.dependencies.logger.reportError(
			SduiErrorType.ActionNetworkRequestFailed,
			{ name = SduiActionType.AiOverviewFeedback, message = tostring(result) },
			p.appPage
		)
	end
end

local function SduiAiOverviewFeedbackAction(p, p2, p3, _)
	local actionParams

	if p then
		actionParams = p.actionParams
	end

	if actionParams == nil then
		reportInvalidParam(p3, "Missing actionParams") -- inferred equivalent call
		return
	end

	local sentiment = actionParams.sentiment

	if typeof(sentiment) == "string" and set[sentiment] then
		local productSurface = actionParams.productSurface
		local productSurface2 = (typeof(productSurface) ~= "string" or productSurface == "") and "Unknown"
			or productSurface

		local searchSessionId = findAnalyticsFieldInAncestors("searchSessionId", p2) or ""
		local query = findAnalyticsFieldInAncestors("searchQuery", p2) or ""
		local analyticsFieldInAncestors = findAnalyticsFieldInAncestors("universeIds", p2)
		local appPage = p3.appPage
		local networking = p3.dependencies.networking

		sendUserSignal(
			p3,
			networking,
			searchSessionId,
			productSurface2,
			UserSignalTypes.SignalType.AiOverviewSentiment,
			{ sentiment = sentiment, query = query, universe_ids = analyticsFieldInAncestors }
		)

		p3.dependencies.dispatch(SetCentralOverlay(CentralOverlayType.TextFeedbackFormModal, {
			dialogTitle = actionParams.dialogTitle or "",
			dialogText = actionParams.dialogText,
			placeholderText = actionParams.placeholderText,
			buttonVariant = ButtonVariant.Emphasis,
			showTermsOfUseDisclaimer = true,
			onSubmit = function(p4: string)
				sendUserSignal(
					p3,
					networking,
					searchSessionId,
					productSurface2,
					UserSignalTypes.SignalType.AiOverviewExplicitFeedback,
					{ sentiment = sentiment, feedback_text = p4, query = query }
				)

				aiOverviewExplicitFeedback({
					sentiment = sentiment,
					searchSessionId = searchSessionId,
					query = query,
					didSubmit = true,
					feedbackText = p4
				}, appPage)
			end,
			onClose = function(flag: boolean?)
				if flag then
					return
				end

				sendUserSignal(
					p3,
					networking,
					searchSessionId,
					productSurface2,
					UserSignalTypes.SignalType.AiOverviewExplicitFeedback,
					{ sentiment = sentiment, feedback_text = "", query = query }
				)

				aiOverviewExplicitFeedback(
					{
						sentiment = sentiment,
						searchSessionId = searchSessionId,
						query = query,
						didSubmit = false
					},
					appPage
				)
			end
		}))

		aiOverviewSentiment(
			{
				sentiment = sentiment,
				searchSessionId = searchSessionId,
				query = query,
				universeIds = analyticsFieldInAncestors
			},
			appPage
		)
	else
		reportInvalidParam(p3, `Invalid or missing sentiment: {tostring(sentiment)}`, "sentiment") -- inferred equivalent call
	end
end

return SduiAiOverviewFeedbackAction
