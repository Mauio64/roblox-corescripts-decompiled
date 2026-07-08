local Parent = script:FindFirstAncestor("PlayerFeedback").Parent
local Constants = require(script.Parent.Parent.Constants)
local Cryo = require(Parent.Cryo)
local t = require(Parent.t)
local mutedError = require(Parent.Loggers).mutedError
local v6 = t.optional(t.strictInterface({
	categoryType = t.optional(t.string),
	value = t.optional(t.string)
}))

local function gamePlayerFeedbackEvent(p1) -- line: 12
	-- upvalues: v6 (copy), mutedError (copy), Cryo (copy), Constants (copy)
	return function(p2, p3, p4) -- line: 13
		-- upvalues: v6 (copy), mutedError (copy), Cryo (copy), Constants (copy), p1 (copy)
		local v90, v91 = v6(p4)

		if not v90 then
			mutedError(v91)
		end

		local t1 = {
			placeId = p3
		}

		if p4 then
			t1 = Cryo.Dictionary.join(t1, p4)
		end

		p2:sendEventDeferred(Constants.Context.GamePlayerFeedback, p1, t1)
	end
end

local t2 = {}
local ClickPlayerFeedbackPromptCta = Constants.EventNames.ClickPlayerFeedbackPromptCta

function t2.ClickPlayerFeedbackPromptCta(p5, p6, p7) -- line: 13
	-- upvalues: v6 (copy), mutedError (copy), Cryo (copy), Constants (copy), ClickPlayerFeedbackPromptCta (copy)
	local v24, v25 = v6(p7)

	if not v24 then
		mutedError(v25)
	end

	local t3 = {
		placeId = p6
	}

	if p7 then
		t3 = Cryo.Dictionary.join(t3, p7)
	end

	p5:sendEventDeferred(Constants.Context.GamePlayerFeedback, ClickPlayerFeedbackPromptCta, t3)
end

local PlayerFeedbackPromptMounted = Constants.EventNames.PlayerFeedbackPromptMounted

function t2.PlayerFeedbackPromptMounted(p8, p9, p10) -- line: 13
	-- upvalues: v6 (copy), mutedError (copy), Cryo (copy), Constants (copy), PlayerFeedbackPromptMounted (copy)
	local v30, v31 = v6(p10)

	if not v30 then
		mutedError(v31)
	end

	local t4 = {
		placeId = p9
	}

	if p10 then
		t4 = Cryo.Dictionary.join(t4, p10)
	end

	p8:sendEventDeferred(Constants.Context.GamePlayerFeedback, PlayerFeedbackPromptMounted, t4)
end

local DismissPlayerFeedbackPrompt = Constants.EventNames.DismissPlayerFeedbackPrompt

function t2.DismissPlayerFeedbackPrompt(p11, p12, p13) -- line: 13
	-- upvalues: v6 (copy), mutedError (copy), Cryo (copy), Constants (copy), DismissPlayerFeedbackPrompt (copy)
	local v36, v37 = v6(p13)

	if not v36 then
		mutedError(v37)
	end

	local t5 = {
		placeId = p12
	}

	if p13 then
		t5 = Cryo.Dictionary.join(t5, p13)
	end

	p11:sendEventDeferred(Constants.Context.GamePlayerFeedback, DismissPlayerFeedbackPrompt, t5)
end

local PlayerFeedbackFormModalMounted = Constants.EventNames.PlayerFeedbackFormModalMounted

function t2.PlayerFeedbackFormModalMounted(p14, p15, p16) -- line: 13
	-- upvalues: v6 (copy), mutedError (copy), Cryo (copy), Constants (copy), PlayerFeedbackFormModalMounted (copy)
	local v42, v43 = v6(p16)

	if not v42 then
		mutedError(v43)
	end

	local t6 = {
		placeId = p15
	}

	if p16 then
		t6 = Cryo.Dictionary.join(t6, p16)
	end

	p14:sendEventDeferred(Constants.Context.GamePlayerFeedback, PlayerFeedbackFormModalMounted, t6)
end

local DismissPlayerFeedbackFormModal = Constants.EventNames.DismissPlayerFeedbackFormModal

function t2.DismissPlayerFeedbackFormModal(p17, p18, p19) -- line: 13
	-- upvalues: v6 (copy), mutedError (copy), Cryo (copy), Constants (copy), DismissPlayerFeedbackFormModal (copy)
	local v48, v49 = v6(p19)

	if not v48 then
		mutedError(v49)
	end

	local t7 = {
		placeId = p18
	}

	if p19 then
		t7 = Cryo.Dictionary.join(t7, p19)
	end

	p17:sendEventDeferred(Constants.Context.GamePlayerFeedback, DismissPlayerFeedbackFormModal, t7)
end

local ClickPlayerFeedbackFormModalDisclaimer = Constants.EventNames.ClickPlayerFeedbackFormModalDisclaimer

function t2.ClickPlayerFeedbackFormModalDisclaimer(p20, p21, p22) -- line: 13
	-- upvalues: v6 (copy), mutedError (copy), Cryo (copy), Constants (copy), ClickPlayerFeedbackFormModalDisclaimer (copy)
	local v54, v55 = v6(p22)

	if not v54 then
		mutedError(v55)
	end

	local t8 = {
		placeId = p21
	}

	if p22 then
		t8 = Cryo.Dictionary.join(t8, p22)
	end

	p20:sendEventDeferred(Constants.Context.GamePlayerFeedback, ClickPlayerFeedbackFormModalDisclaimer, t8)
end

local ClickPlayerFeedbackFormAbuseReportPrompt = Constants.EventNames.ClickPlayerFeedbackFormAbuseReportPrompt

function t2.ClickPlayerFeedbackFormAbuseReportPrompt(p23, p24, p25) -- line: 13
	-- upvalues: v6 (copy), mutedError (copy), Cryo (copy), Constants (copy), ClickPlayerFeedbackFormAbuseReportPrompt (copy)
	local v60, v61 = v6(p25)

	if not v60 then
		mutedError(v61)
	end

	local t9 = {
		placeId = p24
	}

	if p25 then
		t9 = Cryo.Dictionary.join(t9, p25)
	end

	p23:sendEventDeferred(Constants.Context.GamePlayerFeedback, ClickPlayerFeedbackFormAbuseReportPrompt, t9)
end

local TogglePlayerFeedbackFormModalReason = Constants.EventNames.TogglePlayerFeedbackFormModalReason

function t2.TogglePlayerFeedbackFormModalReason(p26, p27, p28) -- line: 13
	-- upvalues: v6 (copy), mutedError (copy), Cryo (copy), Constants (copy), TogglePlayerFeedbackFormModalReason (copy)
	local v66, v67 = v6(p28)

	if not v66 then
		mutedError(v67)
	end

	local t10 = {
		placeId = p27
	}

	if p28 then
		t10 = Cryo.Dictionary.join(t10, p28)
	end

	p26:sendEventDeferred(Constants.Context.GamePlayerFeedback, TogglePlayerFeedbackFormModalReason, t10)
end

local FocusPlayerFeedbackFormModalComment = Constants.EventNames.FocusPlayerFeedbackFormModalComment

function t2.FocusPlayerFeedbackFormModalComment(p29, p30, p31) -- line: 13
	-- upvalues: v6 (copy), mutedError (copy), Cryo (copy), Constants (copy), FocusPlayerFeedbackFormModalComment (copy)
	local v72, v73 = v6(p31)

	if not v72 then
		mutedError(v73)
	end

	local t11 = {
		placeId = p30
	}

	if p31 then
		t11 = Cryo.Dictionary.join(t11, p31)
	end

	p29:sendEventDeferred(Constants.Context.GamePlayerFeedback, FocusPlayerFeedbackFormModalComment, t11)
end

local ClickPlayerFeedbackFormModalSubmit = Constants.EventNames.ClickPlayerFeedbackFormModalSubmit

function t2.ClickPlayerFeedbackFormModalSubmit(p32, p33, p34) -- line: 13
	-- upvalues: v6 (copy), mutedError (copy), Cryo (copy), Constants (copy), ClickPlayerFeedbackFormModalSubmit (copy)
	local v78, v79 = v6(p34)

	if not v78 then
		mutedError(v79)
	end

	local t12 = {
		placeId = p33
	}

	if p34 then
		t12 = Cryo.Dictionary.join(t12, p34)
	end

	p32:sendEventDeferred(Constants.Context.GamePlayerFeedback, ClickPlayerFeedbackFormModalSubmit, t12)
end

local SubmitPlayerFeedbackFailCommentValidation = Constants.EventNames.SubmitPlayerFeedbackFailCommentValidation

function t2.SubmitPlayerFeedbackFailCommentValidation(p35, p36, p37) -- line: 13
	-- upvalues: v6 (copy), mutedError (copy), Cryo (copy), Constants (copy), SubmitPlayerFeedbackFailCommentValidation (copy)
	local v84, v85 = v6(p37)

	if not v84 then
		mutedError(v85)
	end

	local t13 = {
		placeId = p36
	}

	if p37 then
		t13 = Cryo.Dictionary.join(t13, p37)
	end

	p35:sendEventDeferred(Constants.Context.GamePlayerFeedback, SubmitPlayerFeedbackFailCommentValidation, t13)
end

return t2
