local HttpService = game:GetService("HttpService")
local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local CentralOverlay = require(Parent.CentralOverlay)
local DiscoveryAnalytics = require(Parent.DiscoveryAnalytics)
local Foundation = require(Parent.Foundation)
local RobloxAppEnums = require(Parent.RobloxAppEnums)
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local UserSignals = require(Parent.UserSignals)
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
local t1 = {
	[AiOverviewSentiment.ThumbsUp] = true,
	[AiOverviewSentiment.ThumbsDown] = true
}

local function reportInvalidParam(p1, s1: string, s2: string?) -- line: 43
	-- upvalues: SduiErrorType (copy), SduiActionType (copy)
	p1.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
		name = SduiActionType.AiOverviewFeedback,
		message = s1,
		propName = s2
	}, p1.appPage)
end
local function sendUserSignal(p2, p3, s3: string, s4: string, p4, t2: {[any]: any}) -- line: 51
	-- upvalues: PostSendUserSignal (copy), HttpService (copy), UserSignalTypes (copy), SduiErrorType (copy), SduiActionType (copy)
	local ok, result = pcall(function() -- line: 59
		-- upvalues: PostSendUserSignal (copy), p3 (copy), HttpService (copy), t2 (copy), s3 (copy), UserSignalTypes (copy), s4 (copy), p4 (copy), p2 (copy), SduiErrorType (copy), SduiActionType (copy)
		PostSendUserSignal(p3, {
			stringValue = HttpService:JSONEncode(t2)
		}, {
			id = s3,
			assetType = UserSignalTypes.AssetType.PowerSearch,
			signalOrigin = {
				topicId = "PowerSearch",
				productSurface = s4,
				subIds = { "PowerSearch" }
			}
		}, UserSignalTypes.SignalValueType.String, p4):catch(function(p5) -- line: 70
			-- upvalues: p2 (copy), SduiErrorType (copy), SduiActionType (copy)
			p2.dependencies.logger.reportError(SduiErrorType.ActionNetworkRequestFailed, {
				name = SduiActionType.AiOverviewFeedback,
				message = tostring(p5)
			}, p2.appPage)
		end)
	end)

	if not ok then
		p2.dependencies.logger.reportError(SduiErrorType.ActionNetworkRequestFailed, {
			name = SduiActionType.AiOverviewFeedback,
			message = tostring(result)
		}, p2.appPage)
	end
end
local function SduiAiOverviewFeedbackAction(p6, p7, p8, _) -- line: 86
	-- upvalues: SduiErrorType (copy), SduiActionType (copy), t1 (copy), findAnalyticsFieldInAncestors (copy), sendUserSignal (copy), UserSignalTypes (copy), SetCentralOverlay (copy), CentralOverlayType (copy), ButtonVariant (copy), aiOverviewExplicitFeedback (copy), aiOverviewSentiment (copy)
	local v39 = if not p6 then nil else p6.actionParams

	if v39 == nil then
		p8.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			message = "Missing actionParams",
			propName = nil,
			name = SduiActionType.AiOverviewFeedback
		}, p8.appPage)

		return
	end

	local sentiment = v39.sentiment

	if typeof(sentiment) ~= "string" or not t1[sentiment] then
		local v41 = `Invalid or missing sentiment: { tostring(sentiment) }`

		p8.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			propName = "sentiment",
			name = SduiActionType.AiOverviewFeedback,
			message = v41
		}, p8.appPage)

		return
	end

	local productSurface = v39.productSurface
	local v43 = (typeof(productSurface) ~= "string" or productSurface == "") and "Unknown" or productSurface
	local v44 = findAnalyticsFieldInAncestors("searchSessionId", p7) or ""
	local v45 = findAnalyticsFieldInAncestors("searchQuery", p7) or ""
	local v46 = findAnalyticsFieldInAncestors("universeIds", p7)
	local appPage = p8.appPage
	local networking = p8.dependencies.networking

	sendUserSignal(p8, networking, v44, v43, UserSignalTypes.SignalType.AiOverviewSentiment, {
		sentiment = sentiment,
		query = v45,
		universe_ids = v46
	})
	p8.dependencies.dispatch(SetCentralOverlay(CentralOverlayType.TextFeedbackFormModal, {
		showTermsOfUseDisclaimer = true,
		dialogTitle = v39.dialogTitle or "",
		dialogText = v39.dialogText,
		placeholderText = v39.placeholderText,
		buttonVariant = ButtonVariant.Emphasis,
		onSubmit = function(s5: string) -- line: 135
			-- upvalues: sendUserSignal (copy), p8 (copy), networking (copy), v44 (copy), v43 (copy), UserSignalTypes (copy), sentiment (copy), v45 (copy), aiOverviewExplicitFeedback (copy), appPage (copy)
			sendUserSignal(p8, networking, v44, v43, UserSignalTypes.SignalType.AiOverviewExplicitFeedback, {
				sentiment = sentiment,
				feedback_text = s5,
				query = v45
			})
			aiOverviewExplicitFeedback({
				didSubmit = true,
				sentiment = sentiment,
				searchSessionId = v44,
				query = v45,
				feedbackText = s5
			}, appPage)
		end,
		onClose = function(b1: boolean?) -- line: 157
			-- upvalues: sendUserSignal (copy), p8 (copy), networking (copy), v44 (copy), v43 (copy), UserSignalTypes (copy), sentiment (copy), v45 (copy), aiOverviewExplicitFeedback (copy), appPage (copy)
			if b1 then
				return
			end

			sendUserSignal(p8, networking, v44, v43, UserSignalTypes.SignalType.AiOverviewExplicitFeedback, {
				feedback_text = "",
				sentiment = sentiment,
				query = v45
			})
			aiOverviewExplicitFeedback({
				didSubmit = false,
				sentiment = sentiment,
				searchSessionId = v44,
				query = v45
			}, appPage)
		end
	}))
	aiOverviewSentiment({
		sentiment = sentiment,
		searchSessionId = v44,
		query = v45,
		universeIds = v46
	}, appPage)
end

return SduiAiOverviewFeedbackAction
