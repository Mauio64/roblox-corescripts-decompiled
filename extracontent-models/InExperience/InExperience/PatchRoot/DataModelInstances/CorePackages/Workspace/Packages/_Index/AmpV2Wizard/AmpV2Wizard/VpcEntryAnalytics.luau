local AmpV2Wizard = script:FindFirstAncestor("AmpV2Wizard")
local parent = AmpV2Wizard.Parent

local React = require(parent.React)

local AuthAnalytics = require(parent.AuthAnalytics)
local authButtonClick = AuthAnalytics.Events.authButtonClick
local authFormInteraction = AuthAnalytics.Events.authFormInteraction
local authModalShown = AuthAnalytics.Events.authModalShown
local authMsgShown = AuthAnalytics.Events.authMsgShown
local authPageload = AuthAnalytics.Events.authPageload

require(AmpV2Wizard.Types)
local OdpAnalytics = require(AmpV2Wizard.OdpAnalytics)
local OdpAnalyticsConstants = require(AmpV2Wizard.OdpAnalyticsConstants)

local v = {
	WizardLaunch = "ampWizard",
	Prologue = "odpPrologue",
	RemoteParentRequest = "remoteParentEmailRequest"
}

local _ = {
	AskParent = "askParent",
	EmailModal = "emailModal",
	Email = "email",
	ErrorMessage = "errorMessage",
	RequestSent = "requestSent"
}

local _ = { Submit = "submit", Retry = "retry", Ok = "ok" }

local _ = { OdpAndRemote = "odpAndRemote", RemoteOnly = "remoteOnly", OdpOnly = "odpOnly" }

local _ = {
	WizardLaunch = "AMP wizard launch",
	Prologue = "Ask your parent - You need parent approval to {takeChildAction}.",
	AskInPerson = "Ask in person",
	AskViaEmail = "Send an email",
	AskParent = "Ask my parent",
	Close = "X icon",
	EmailScreen = "Enter parent's email - Ask your parents to help you with this step. We'll send an email to your parent to verify their age and link them to your account. Parents, after linking, you'll get access to parental controls and insights on your child's screen time, spending, and more.",
	ParentEmail = "Parent's email",
	SendEmail = "Send Email",
	RequestSent = "Email sent",
	Ok = "Email sent > OK",
	Retry = "Something went wrong > Retry",
	Cancel = "Something went wrong > Cancel"
}

local v2 = { btn = OdpAnalyticsConstants.Buttons.AskParent, associatedText = "Ask my parent" }
local cancel2 = { btn = OdpAnalyticsConstants.Buttons.Close, associatedText = "X icon" }

local v3 = {
	odpAndRemote = {
		ODP = { btn = OdpAnalyticsConstants.Buttons.AskInPerson, associatedText = "Ask in person" },
		Remote = {
			btn = OdpAnalyticsConstants.Buttons.EmailParent,
			associatedText = "Send an email"
		},
		Cancel = cancel2
	},
	remoteOnly = { Remote = v2, Cancel = cancel2 },
	odpOnly = { ODP = v2, Cancel = cancel2 }
}

local function buildState(p: string?, p2: string?, p3: string?, p4: string?) -- 2 equivalent calls inferred from this helper
	return OdpAnalytics.joinTokens({ p, p2, OdpAnalytics.childUserId(), p3, p4 })
end

local function createVpcEntryAnalytics(analyticsStrings, analyticsSessionId: string?, surface: string?, p: string?)
	local v4

	if analyticsStrings == nil then
		v4 = nil
	else
		v4 = analyticsStrings[OdpAnalyticsConstants.AGE_GROUP_KEY]
	end

	local function prologueState(p2: string) -- 2 equivalent calls inferred from this helper
		return OdpAnalytics.joinTokens({ buildState(analyticsSessionId, v4, surface), p2 }) -- inferred equivalent call
	end

	local state = buildState(analyticsSessionId, v4, surface, p) -- inferred equivalent call

	local function remoteButtonClick(p2: string, p3: string)
		authButtonClick("remoteParentEmailRequest", p2, state, nil, nil, nil, nil, p3)
	end

	return {
		prologueShown = function(p2: string)
			authModalShown(
				"odpPrologue",
				prologueState(p2), -- inferred equivalent call
				"askParent",
				nil,
				"Ask your parent - You need parent approval to {takeChildAction}."
			)
		end,
		prologueButtonClick = function(p2: string, p3: string)
			local v5 = v3[p3]
			local v6

			if v5 ~= nil then
				v6 = v5[p2]
			end

			if v6 == nil then
				return
			end

			authButtonClick("odpPrologue", v6.btn, prologueState(p3), nil, nil, nil, nil, v6.associatedText) -- inferred equivalent call
		end,
		remoteEmailShown = function()
			authModalShown(
				"remoteParentEmailRequest",
				state,
				"emailModal",
				nil,
				"Enter parent's email - Ask your parents to help you with this step. We'll send an email to your parent to verify their age and link them to your account. Parents, after linking, you'll get access to parental controls and insights on your child's screen time, spending, and more."
			)
		end,
		remoteEmailEntered = function()
			authFormInteraction("remoteParentEmailRequest", "email", state, nil, nil, "Parent's email")
		end,
		remoteEmailSubmit = function()
			authButtonClick(v.RemoteParentRequest, "submit", state, nil, nil, nil, nil, "Send Email")
		end,
		remoteRequestSent = function()
			authMsgShown("remoteParentEmailRequest", state, "requestSent", nil, "Email sent")
		end,
		remoteRequestOk = function()
			authButtonClick(v.RemoteParentRequest, "ok", state, nil, nil, nil, nil, "Email sent > OK")
		end,
		remoteRequestError = function(value: string?)
			authMsgShown("remoteParentEmailRequest", state, "errorMessage", value or "unknown")
		end,
		remoteRequestRetry = function()
			authButtonClick(v.RemoteParentRequest, "retry", state, nil, nil, nil, nil, "Something went wrong > Retry")
		end,
		remoteRequestCancel = function()
			local cancel = OdpAnalyticsConstants.Buttons.Cancel
			authButtonClick(v.RemoteParentRequest, cancel, state, nil, nil, nil, nil, "Something went wrong > Cancel")
		end,
		remoteRequestClose = function()
			local close = OdpAnalyticsConstants.Buttons.Close
			authButtonClick(v.RemoteParentRequest, close, state, nil, nil, nil, nil, "X icon")
		end
	}
end

local VpcEntryAnalytics = {}

function VpcEntryAnalytics.getPrologueType(p: number, p2: string?): string
	if p ~= 1 then
		return "odpAndRemote"
	end

	return if p2 == "ODP" then "odpOnly" else "remoteOnly"
end

function VpcEntryAnalytics.sendWizardLaunch(p, p2: string?, p3: string?, p4: string?, p5: string?, p6: string?)
	local v4

	if p ~= nil then
		v4 = p[OdpAnalyticsConstants.AGE_GROUP_KEY]
	end

	authPageload(
		"ampWizard",
		OdpAnalytics.joinTokens({ p2, v4, OdpAnalytics.childUserId(), p3, p4, p5, p6 }),
		nil,
		nil,
		nil,
		"AMP wizard launch"
	)
end

VpcEntryAnalytics.createVpcEntryAnalytics = createVpcEntryAnalytics

function VpcEntryAnalytics.useVpcEntryAnalytics(data, p: string?)
	local surface = data.analytics.surface
	return React.useMemo(function()
		return createVpcEntryAnalytics(data.analyticsStrings, data.analyticsSessionId, surface, p)
	end, { data.analyticsStrings, data.analyticsSessionId, surface, p })
end

return VpcEntryAnalytics
