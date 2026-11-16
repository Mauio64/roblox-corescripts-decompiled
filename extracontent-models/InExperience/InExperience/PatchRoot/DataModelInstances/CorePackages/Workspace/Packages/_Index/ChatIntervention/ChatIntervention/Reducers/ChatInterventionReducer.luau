local ChatIntervention = script:FindFirstAncestor("ChatIntervention")
local parent = ChatIntervention.Parent
local Rodux = require(parent.Rodux)
local Actions = ChatIntervention.Actions
local llama = require(parent.llama)
local dictionary = llama.Dictionary

local UpdateShowChatFeedbackModalAction = require(Actions.UpdateShowChatFeedbackModalAction)
local UpdateShowChatFeedbackPillAction = require(Actions.UpdateShowChatFeedbackPillAction)
local UpdateShowChatNudgeModalAction = require(Actions.UpdateShowChatNudgeModalAction)
local UpdateShowChatTimeoutModalAction = require(Actions.UpdateShowChatTimeoutModalAction)

local function setIsShowChatTimeoutModal(p, p2)
	return dictionary.set(p, "isShowChatTimeoutModal", p2.isShow)
end

local function setIsShowChatNudgeModal(p, p2)
	return dictionary.set(p, "isShowChatNudgeModal", p2.isShow)
end

local function setIsShowChatFeedbackModal(p, p2)
	return dictionary.set(p, "isShowChatFeedbackModal", p2.isShow)
end

local function setIsShowChatFeedbackPill(p, p2)
	return dictionary.set(p, "isShowChatFeedbackPill", p2.isShow)
end

return Rodux.createReducer(
	{
		isShowChatFeedbackModal = false,
		isShowChatFeedbackPill = false,
		isShowChatNudgeModal = false,
		isShowChatTimeoutModal = false
	},
	{
		[UpdateShowChatFeedbackModalAction.name] = setIsShowChatFeedbackModal,
		[UpdateShowChatFeedbackPillAction.name] = setIsShowChatFeedbackPill,
		[UpdateShowChatNudgeModalAction.name] = setIsShowChatNudgeModal,
		[UpdateShowChatTimeoutModalAction.name] = setIsShowChatTimeoutModal
	}
)
