local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local Localization = require(parent.Localization)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local useLocalization = Localization.Hooks.useLocalization
local useState = React.useState
local useSignalState = SignalsReact.useSignalState

local GetCreationFlowStore = require(MomentsCreation.Stores.GetCreationFlowStore)
local useCreationController = require(MomentsCreation.CreationController.useCreationController)
local fireAnalyticsEvent = require(MomentsCreation.Analytics.fireAnalyticsEvent)
local makeCreationEventFields = require(MomentsCreation.Analytics.makeCreationEventFields)
require(script.Parent.GeneratedTextFeedbackView)

local EventNames = MomentsCommon.Analytics.EventNames
local SessionManager = MomentsCommon.Analytics.SessionManager
local FunnelEventNames = MomentsCommon.Analytics.FunnelEventNames

local v = { disclosure = "Feature.Moments.Description.GenerateTextFeedbackDisclosure" }

local function fireFeedbackEvent(p) -- 3 equivalent calls inferred from this helper
	local sessionId = SessionManager.getSessionId(FunnelEventNames.FunnelTypes.CreationFlow)
	fireAnalyticsEvent(p, makeCreationEventFields.makeCreationBaseFields(sessionId))
end

local function useGeneratedTextFeedbackViewModel(p)
	local creationFlowStore = GetCreationFlowStore(false)
	local v2 = useCreationController()

	local success, result = pcall(useLocalization, v)

	local v3 = useSignalState(creationFlowStore.getGeneratedDescription)
	local state, setState = useState(nil)
	local state2, setState2 = useState(false)
	return {
		visible = v3 ~= nil,
		layoutOrder = p.layoutOrder,
		disclosureText = (not success and {} or result).disclosure or "",
		selectedAction = state,
		showReasonDialog = state2,
		onThumbsUp = function()
			if state == "thumbs_up" then
				return
			end

			setState("thumbs_up")
			fireFeedbackEvent(EventNames.EditingFlowGenerateTextFeedbackThumbsUp) -- inferred equivalent call
			v2.submitGeneratedTextFeedback("thumbs_up")
		end,
		onThumbsDown = function()
			setState2(true)
		end,
		onNotHelpful = function()
			setState("thumbs_down")
			setState2(false)
			fireFeedbackEvent(EventNames.EditingFlowGenerateTextFeedbackThumbsDownNotHelpful) -- inferred equivalent call
			v2.submitGeneratedTextFeedback("not_helpful")
		end,
		onPolicyViolation = function()
			setState("thumbs_down")
			setState2(false)
			fireFeedbackEvent(EventNames.EditingFlowGenerateTextFeedbackThumbsDownPolicy) -- inferred equivalent call
			v2.submitGeneratedTextFeedback("policy_violation")
		end,
		onDismissDialog = function()
			setState2(false)
		end
	}
end

return useGeneratedTextFeedbackViewModel
