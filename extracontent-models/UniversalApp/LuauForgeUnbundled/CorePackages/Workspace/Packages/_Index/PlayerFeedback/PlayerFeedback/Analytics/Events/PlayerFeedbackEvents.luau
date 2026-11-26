local Constants = require("@game/CorePackages/Workspace/Packages/_Index/PlayerFeedback/PlayerFeedback/Analytics/Constants")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerFeedback/Cryo")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerFeedback/t")
local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerFeedback/Loggers").mutedError

local optional = t.optional(t.strictInterface({
	categoryType = t.optional(t.string),
	value = t.optional(t.string)
}))

local function gamePlayerFeedbackEvent(p2)
	return function(object, p3, p4)
		local v5, v6 = optional(p4)

		if not v5 then
			mutedError(v6)
		end

		local joined = { placeId = p3 }

		if p4 then
			joined = Cryo.Dictionary.join(joined, p4)
		end

		object:sendEventDeferred(Constants.Context.GamePlayerFeedback, p2, joined)
	end
end

local clickPlayerFeedbackPromptCta = Constants.EventNames.ClickPlayerFeedbackPromptCta
local v5 = {
	ClickPlayerFeedbackPromptCta = function(object, p2, p3)
		local v6, v7 = optional(p3)

		if not v6 then
			mutedError(v7)
		end

		local joined = { placeId = p2 }

		if p3 then
			joined = Cryo.Dictionary.join(joined, p3)
		end

		object:sendEventDeferred(Constants.Context.GamePlayerFeedback, clickPlayerFeedbackPromptCta, joined)
	end,
	PlayerFeedbackPromptMounted = 0,
	DismissPlayerFeedbackPrompt = 0,
	PlayerFeedbackFormModalMounted = 0,
	DismissPlayerFeedbackFormModal = 0,
	ClickPlayerFeedbackFormModalDisclaimer = 0,
	ClickPlayerFeedbackFormAbuseReportPrompt = 0,
	TogglePlayerFeedbackFormModalReason = 0,
	FocusPlayerFeedbackFormModalComment = 0,
	ClickPlayerFeedbackFormModalSubmit = 0,
	SubmitPlayerFeedbackFailCommentValidation = 0
}

local playerFeedbackPromptMounted = Constants.EventNames.PlayerFeedbackPromptMounted

function v5.PlayerFeedbackPromptMounted(object, p2, p3)
	local v6, v7 = optional(p3)

	if not v6 then
		mutedError(v7)
	end

	local joined = { placeId = p2 }

	if p3 then
		joined = Cryo.Dictionary.join(joined, p3)
	end

	object:sendEventDeferred(Constants.Context.GamePlayerFeedback, playerFeedbackPromptMounted, joined)
end
local dismissPlayerFeedbackPrompt = Constants.EventNames.DismissPlayerFeedbackPrompt

function v5.DismissPlayerFeedbackPrompt(object, p2, p3)
	local v6, v7 = optional(p3)

	if not v6 then
		mutedError(v7)
	end

	local joined = { placeId = p2 }

	if p3 then
		joined = Cryo.Dictionary.join(joined, p3)
	end

	object:sendEventDeferred(Constants.Context.GamePlayerFeedback, dismissPlayerFeedbackPrompt, joined)
end
local playerFeedbackFormModalMounted = Constants.EventNames.PlayerFeedbackFormModalMounted

function v5.PlayerFeedbackFormModalMounted(object, p2, p3)
	local v6, v7 = optional(p3)

	if not v6 then
		mutedError(v7)
	end

	local joined = { placeId = p2 }

	if p3 then
		joined = Cryo.Dictionary.join(joined, p3)
	end

	object:sendEventDeferred(Constants.Context.GamePlayerFeedback, playerFeedbackFormModalMounted, joined)
end
local dismissPlayerFeedbackFormModal = Constants.EventNames.DismissPlayerFeedbackFormModal

function v5.DismissPlayerFeedbackFormModal(object, p2, p3)
	local v6, v7 = optional(p3)

	if not v6 then
		mutedError(v7)
	end

	local joined = { placeId = p2 }

	if p3 then
		joined = Cryo.Dictionary.join(joined, p3)
	end

	object:sendEventDeferred(Constants.Context.GamePlayerFeedback, dismissPlayerFeedbackFormModal, joined)
end

local clickPlayerFeedbackFormModalDisclaimer = Constants.EventNames.ClickPlayerFeedbackFormModalDisclaimer

function v5.ClickPlayerFeedbackFormModalDisclaimer(object, p2, p3)
	local v6, v7 = optional(p3)

	if not v6 then
		mutedError(v7)
	end

	local joined = { placeId = p2 }

	if p3 then
		joined = Cryo.Dictionary.join(joined, p3)
	end

	object:sendEventDeferred(
		Constants.Context.GamePlayerFeedback,
		clickPlayerFeedbackFormModalDisclaimer,
		joined
	)
end

local clickPlayerFeedbackFormAbuseReportPrompt = Constants.EventNames.ClickPlayerFeedbackFormAbuseReportPrompt

function v5.ClickPlayerFeedbackFormAbuseReportPrompt(object, p2, p3)
	local v6, v7 = optional(p3)

	if not v6 then
		mutedError(v7)
	end

	local joined = { placeId = p2 }

	if p3 then
		joined = Cryo.Dictionary.join(joined, p3)
	end

	object:sendEventDeferred(
		Constants.Context.GamePlayerFeedback,
		clickPlayerFeedbackFormAbuseReportPrompt,
		joined
	)
end

local togglePlayerFeedbackFormModalReason = Constants.EventNames.TogglePlayerFeedbackFormModalReason

function v5.TogglePlayerFeedbackFormModalReason(object, p2, p3)
	local v6, v7 = optional(p3)

	if not v6 then
		mutedError(v7)
	end

	local joined = { placeId = p2 }

	if p3 then
		joined = Cryo.Dictionary.join(joined, p3)
	end

	object:sendEventDeferred(Constants.Context.GamePlayerFeedback, togglePlayerFeedbackFormModalReason, joined)
end

local focusPlayerFeedbackFormModalComment = Constants.EventNames.FocusPlayerFeedbackFormModalComment

function v5.FocusPlayerFeedbackFormModalComment(object, p2, p3)
	local v6, v7 = optional(p3)

	if not v6 then
		mutedError(v7)
	end

	local joined = { placeId = p2 }

	if p3 then
		joined = Cryo.Dictionary.join(joined, p3)
	end

	object:sendEventDeferred(Constants.Context.GamePlayerFeedback, focusPlayerFeedbackFormModalComment, joined)
end

local clickPlayerFeedbackFormModalSubmit = Constants.EventNames.ClickPlayerFeedbackFormModalSubmit

function v5.ClickPlayerFeedbackFormModalSubmit(object, p2, p3)
	local v6, v7 = optional(p3)

	if not v6 then
		mutedError(v7)
	end

	local joined = { placeId = p2 }

	if p3 then
		joined = Cryo.Dictionary.join(joined, p3)
	end

	object:sendEventDeferred(Constants.Context.GamePlayerFeedback, clickPlayerFeedbackFormModalSubmit, joined)
end

local submitPlayerFeedbackFailCommentValidation = Constants.EventNames.SubmitPlayerFeedbackFailCommentValidation

function v5.SubmitPlayerFeedbackFailCommentValidation(object, p2, p3)
	local v6, v7 = optional(p3)

	if not v6 then
		mutedError(v7)
	end

	local joined = { placeId = p2 }

	if p3 then
		joined = Cryo.Dictionary.join(joined, p3)
	end

	object:sendEventDeferred(
		Constants.Context.GamePlayerFeedback,
		submitPlayerFeedbackFailCommentValidation,
		joined
	)
end
return v5
