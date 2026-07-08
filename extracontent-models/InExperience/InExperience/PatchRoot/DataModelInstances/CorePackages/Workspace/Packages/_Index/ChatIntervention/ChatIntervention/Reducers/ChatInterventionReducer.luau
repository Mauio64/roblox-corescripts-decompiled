local ChatIntervention = script:FindFirstAncestor("ChatIntervention")
local ChatInterventionParent = ChatIntervention.Parent
local Rodux = require(ChatInterventionParent.Rodux)
local Actions = ChatIntervention.Actions
local Dictionary = require(ChatInterventionParent.llama).Dictionary
local UpdateShowChatFeedbackModalAction = require(Actions.UpdateShowChatFeedbackModalAction)
local UpdateShowChatFeedbackPillAction = require(Actions.UpdateShowChatFeedbackPillAction)
local UpdateShowChatNudgeModalAction = require(Actions.UpdateShowChatNudgeModalAction)
local UpdateShowChatTimeoutModalAction = require(Actions.UpdateShowChatTimeoutModalAction)
local t1 = {
	isShowChatFeedbackModal = false,
	isShowChatFeedbackPill = false,
	isShowChatNudgeModal = false,
	isShowChatTimeoutModal = false
}

local function setIsShowChatTimeoutModal(t2: {[any]: any}, p1) -- line: 27
	-- upvalues: Dictionary (copy)
	return Dictionary.set(t2, "isShowChatTimeoutModal", p1.isShow)
end
local function setIsShowChatNudgeModal(t3: {[any]: any}, p2) -- line: 31
	-- upvalues: Dictionary (copy)
	return Dictionary.set(t3, "isShowChatNudgeModal", p2.isShow)
end
local function setIsShowChatFeedbackModal(t4: {[any]: any}, p3) -- line: 35
	-- upvalues: Dictionary (copy)
	return Dictionary.set(t4, "isShowChatFeedbackModal", p3.isShow)
end
local function setIsShowChatFeedbackPill(t5: {[any]: any}, p4) -- line: 39
	-- upvalues: Dictionary (copy)
	return Dictionary.set(t5, "isShowChatFeedbackPill", p4.isShow)
end

return Rodux.createReducer(t1, {
	[UpdateShowChatFeedbackModalAction.name] = setIsShowChatFeedbackModal,
	[UpdateShowChatFeedbackPillAction.name] = setIsShowChatFeedbackPill,
	[UpdateShowChatNudgeModalAction.name] = setIsShowChatNudgeModal,
	[UpdateShowChatTimeoutModalAction.name] = setIsShowChatTimeoutModal
})
