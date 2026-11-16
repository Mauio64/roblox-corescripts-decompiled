local module = require("@luauforge/bundled/gvb")

local module2 = require("@luauforge/bundled/gvm")
local authButtonClick = module2.Events.authButtonClick
local authFormInteraction = module2.Events.authFormInteraction
local authModalShown = module2.Events.authModalShown
local authMsgShown = module2.Events.authMsgShown
local authPageload = module2.Events.authPageload

require("@luauforge/bundled/gvc")
local module3 = require("@luauforge/bundled/gvl")
local module4 = require("@luauforge/bundled/gvn")

local v5 = {
	WizardLaunch = "ampWizard",
	Prologue = "odpPrologue",
	RemoteParentRequest = "remoteParentEmailRequest"
}

local v6 = {
	AskParent = "askParent",
	EmailModal = "emailModal",
	Email = "email",
	ErrorMessage = "errorMessage",
	RequestSent = "requestSent"
}

local v7 = { Submit = "submit", Retry = "retry", Ok = "ok" }

local v8 = {
	OdpAndRemote = "odpAndRemote",
	RemoteOnly = "remoteOnly",
	OdpOnly = "odpOnly"
}

local v9 = {
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

local v10 = { btn = module4.Buttons.AskParent, associatedText = "Ask my parent" }
local v11 = { btn = module4.Buttons.Close, associatedText = "X icon" }

local v12 = {
	odpAndRemote = {
		ODP = { btn = module4.Buttons.AskInPerson, associatedText = "Ask in person" },
		Remote = { btn = module4.Buttons.EmailParent, associatedText = "Send an email" },
		Cancel = v11
	},
	remoteOnly = { Remote = v10, Cancel = v11 },
	odpOnly = { ODP = v10, Cancel = v11 }
}

local function buildState(p2, p3, p4, p5)
	return module3.joinTokens({ p2, p3, module3.childUserId(), p4, p5 })
end

local function createVpcEntryAnalytics(analyticsStrings, analyticsSessionId, surface, p2)
	local v13 = if analyticsStrings ~= nil then analyticsStrings[module4.AGE_GROUP_KEY] else nil
	local function prologueState(p3)
		return module3.joinTokens({
			module3.joinTokens({
				analyticsSessionId,
				v13,
				module3.childUserId(),
				surface,
				nil
			}),
			p3
		})
	end

	local joinTokens = module3.joinTokens({
		analyticsSessionId,
		v13,
		module3.childUserId(),
		surface,
		p2
	})

	local function remoteButtonClick(p3, p4)
		authButtonClick("remoteParentEmailRequest", p3, joinTokens, nil, nil, nil, nil, p4)
	end

	return {
		prologueShown = function(p3)
			authModalShown(
				"odpPrologue",
				module3.joinTokens({
					module3.joinTokens({
						analyticsSessionId,
						v13,
						module3.childUserId(),
						surface,
						nil
					}),
					p3
				}),
				"askParent",
				nil,
				"Ask your parent - You need parent approval to {takeChildAction}."
			)
		end,
		prologueButtonClick = function(p3, p4)
			local v14 = v12[p4]
			local v15 = if v14 ~= nil then v14[p3] else nil

			if v15 == nil then
				return
			end

			authButtonClick(
				"odpPrologue",
				v15.btn,
				module3.joinTokens({
					module3.joinTokens({
						analyticsSessionId,
						v13,
						module3.childUserId(),
						surface,
						nil
					}),
					p4
				}),
				nil,
				nil,
				nil,
				nil,
				v15.associatedText
			)
		end,
		remoteEmailShown = function()
			authModalShown(
				"remoteParentEmailRequest",
				joinTokens,
				"emailModal",
				nil,
				"Enter parent's email - Ask your parents to help you with this step. We'll send an email to your parent to verify their age and link them to your account. Parents, after linking, you'll get access to parental controls and insights on your child's screen time, spending, and more."
			)
		end,
		remoteEmailEntered = function()
			authFormInteraction("remoteParentEmailRequest", "email", joinTokens, nil, nil, "Parent's email")
		end,
		remoteEmailSubmit = function()
			authButtonClick(v5.RemoteParentRequest, "submit", joinTokens, nil, nil, nil, nil, "Send Email")
		end,
		remoteRequestSent = function()
			authMsgShown("remoteParentEmailRequest", joinTokens, "requestSent", nil, "Email sent")
		end,
		remoteRequestOk = function()
			authButtonClick(v5.RemoteParentRequest, "ok", joinTokens, nil, nil, nil, nil, "Email sent > OK")
		end,
		remoteRequestError = function(value)
			authMsgShown("remoteParentEmailRequest", joinTokens, "errorMessage", value or "unknown")
		end,
		remoteRequestRetry = function()
			authButtonClick(
				v5.RemoteParentRequest,
				"retry",
				joinTokens,
				nil,
				nil,
				nil,
				nil,
				"Something went wrong > Retry"
			)
		end,
		remoteRequestCancel = function()
			local cancel = module4.Buttons.Cancel
			authButtonClick(
				v5.RemoteParentRequest,
				cancel,
				joinTokens,
				nil,
				nil,
				nil,
				nil,
				"Something went wrong > Cancel"
			)
		end,
		remoteRequestClose = function()
			local close = module4.Buttons.Close
			authButtonClick(v5.RemoteParentRequest, close, joinTokens, nil, nil, nil, nil, "X icon")
		end
	}
end

return {
	getPrologueType = function(p2, p3): string
		if p2 ~= 1 then
			return "odpAndRemote"
		end

		if p3 == "ODP" then
			return "odpOnly"
		end

		return "remoteOnly"
	end,
	sendWizardLaunch = function(p2, p3, p4, p5, p6, p7)
		local v13 = if p2 ~= nil then p2[module4.AGE_GROUP_KEY] else nil
		authPageload(
			"ampWizard",
			module3.joinTokens({ p3, v13, module3.childUserId(), p4, p5, p6, p7 }),
			nil,
			nil,
			nil,
			"AMP wizard launch"
		)
	end,
	createVpcEntryAnalytics = createVpcEntryAnalytics,
	useVpcEntryAnalytics = function(data, p2)
		local surface = data.analytics.surface
		return module.useMemo(function()
			return createVpcEntryAnalytics(data.analyticsStrings, data.analyticsSessionId, surface, p2)
		end, { data.analyticsStrings, data.analyticsSessionId, surface, p2 })
	end
}
