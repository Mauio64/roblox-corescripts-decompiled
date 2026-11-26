local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Localization")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/SignalsReact")

local useLocalization = Localization.Hooks.useLocalization
local useState = React.useState
local useSignalState = SignalsReact.useSignalState

local GetCreationFlowStore = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Stores/GetCreationFlowStore")
local useCreationController = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/CreationController/useCreationController")
local fireAnalyticsEvent = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Analytics/fireAnalyticsEvent")
local makeCreationEventFields = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Analytics/makeCreationEventFields")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/GeneratedTextFeedback/GeneratedTextFeedbackView")

local eventNames = MomentsCommon.Analytics.EventNames
local sessionManager = MomentsCommon.Analytics.SessionManager
local funnelEventNames = MomentsCommon.Analytics.FunnelEventNames

local v5 = { disclosure = "Feature.Moments.Description.GenerateTextFeedbackDisclosure" }

local function fireFeedbackEvent(p2)
	local sessionId = sessionManager.getSessionId(funnelEventNames.FunnelTypes.CreationFlow)
	fireAnalyticsEvent(p2, makeCreationEventFields.makeCreationBaseFields(sessionId))
end

local function useGeneratedTextFeedbackViewModel(p2)
	local v6 = GetCreationFlowStore(false)
	local v7 = useCreationController()

	local success, result = pcall(useLocalization, v5)

	local v8 = useSignalState(v6.getGeneratedDescription)
	local state, setState = useState(nil)
	local state2, setState2 = useState(false)
	return {
		visible = v8 ~= nil,
		layoutOrder = p2.layoutOrder,
		disclosureText = (not success and {} or result).disclosure or "",
		selectedAction = state,
		showReasonDialog = state2,
		onThumbsUp = function()
			if state == "thumbs_up" then
				return
			end

			setState("thumbs_up")
			local editingFlowGenerateTextFeedbackThumbsUp = eventNames.EditingFlowGenerateTextFeedbackThumbsUp
			local sessionId = sessionManager.getSessionId(funnelEventNames.FunnelTypes.CreationFlow)
			fireAnalyticsEvent(editingFlowGenerateTextFeedbackThumbsUp, makeCreationEventFields.makeCreationBaseFields(sessionId))

			v7.submitGeneratedTextFeedback("thumbs_up")
		end,
		onThumbsDown = function()
			setState2(true)
		end,
		onNotHelpful = function()
			setState("thumbs_down")
			setState2(false)
			local editingFlowGenerateTextFeedbackThumbsDownNotHelpful = eventNames.EditingFlowGenerateTextFeedbackThumbsDownNotHelpful
			local sessionId = sessionManager.getSessionId(funnelEventNames.FunnelTypes.CreationFlow)
			fireAnalyticsEvent(
				editingFlowGenerateTextFeedbackThumbsDownNotHelpful,
				makeCreationEventFields.makeCreationBaseFields(sessionId)
			)

			v7.submitGeneratedTextFeedback("not_helpful")
		end,
		onPolicyViolation = function()
			setState("thumbs_down")
			setState2(false)
			local editingFlowGenerateTextFeedbackThumbsDownPolicy = eventNames.EditingFlowGenerateTextFeedbackThumbsDownPolicy
			local sessionId = sessionManager.getSessionId(funnelEventNames.FunnelTypes.CreationFlow)
			fireAnalyticsEvent(
				editingFlowGenerateTextFeedbackThumbsDownPolicy,
				makeCreationEventFields.makeCreationBaseFields(sessionId)
			)

			v7.submitGeneratedTextFeedback("policy_violation")
		end,
		onDismissDialog = function()
			setState2(false)
		end
	}
end

return useGeneratedTextFeedbackViewModel
