local parent = script:FindFirstAncestor("PlayerFeedback").Parent
local Constants = require(script.Parent.Parent.Constants)
local Cryo = require(parent.Cryo)
local t = require(parent.t)
local Loggers = require(parent.Loggers)
local mutedError = Loggers.mutedError

local optional = t.optional(t.strictInterface({
	categoryType = t.optional(t.string),
	value = t.optional(t.string)
}))

local function gamePlayerFeedbackEvent(p) -- 11 equivalent calls inferred from this helper
	return function(object, placeId, p2)
		local v, v2 = optional(p2)

		if not v then
			mutedError(v2)
		end

		local joined = { placeId = placeId }

		if p2 then
			joined = Cryo.Dictionary.join(joined, p2)
		end

		object:sendEventDeferred(Constants.Context.GamePlayerFeedback, p, joined)
	end
end

return {
	ClickPlayerFeedbackPromptCta = gamePlayerFeedbackEvent(Constants.EventNames.ClickPlayerFeedbackPromptCta), -- inferred equivalent call
	PlayerFeedbackPromptMounted = gamePlayerFeedbackEvent(Constants.EventNames.PlayerFeedbackPromptMounted), -- inferred equivalent call
	DismissPlayerFeedbackPrompt = gamePlayerFeedbackEvent(Constants.EventNames.DismissPlayerFeedbackPrompt), -- inferred equivalent call
	PlayerFeedbackFormModalMounted = gamePlayerFeedbackEvent(Constants.EventNames.PlayerFeedbackFormModalMounted), -- inferred equivalent call
	DismissPlayerFeedbackFormModal = gamePlayerFeedbackEvent(Constants.EventNames.DismissPlayerFeedbackFormModal), -- inferred equivalent call
	ClickPlayerFeedbackFormModalDisclaimer = gamePlayerFeedbackEvent(Constants.EventNames.ClickPlayerFeedbackFormModalDisclaimer), -- inferred equivalent call
	ClickPlayerFeedbackFormAbuseReportPrompt = gamePlayerFeedbackEvent(Constants.EventNames.ClickPlayerFeedbackFormAbuseReportPrompt), -- inferred equivalent call
	TogglePlayerFeedbackFormModalReason = gamePlayerFeedbackEvent(Constants.EventNames.TogglePlayerFeedbackFormModalReason), -- inferred equivalent call
	FocusPlayerFeedbackFormModalComment = gamePlayerFeedbackEvent(Constants.EventNames.FocusPlayerFeedbackFormModalComment), -- inferred equivalent call
	ClickPlayerFeedbackFormModalSubmit = gamePlayerFeedbackEvent(Constants.EventNames.ClickPlayerFeedbackFormModalSubmit), -- inferred equivalent call
	SubmitPlayerFeedbackFailCommentValidation = gamePlayerFeedbackEvent(Constants.EventNames.SubmitPlayerFeedbackFailCommentValidation) -- inferred equivalent call
}
