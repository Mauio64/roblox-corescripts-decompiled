local AmpV2Wizard = script:FindFirstAncestor("AmpV2Wizard")
local parent = AmpV2Wizard.Parent

local React = require(parent.React)

local Players = game:GetService("Players")

local AuthAnalytics = require(parent.AuthAnalytics)
local authButtonClick = AuthAnalytics.Events.authButtonClick
local authFormInteraction = AuthAnalytics.Events.authFormInteraction
local authModalShown = AuthAnalytics.Events.authModalShown
local authMsgShown = AuthAnalytics.Events.authMsgShown
local authPageload = AuthAnalytics.Events.authPageload

require(AmpV2Wizard.Types)
local OdpAnalyticsConstants = require(AmpV2Wizard.OdpAnalyticsConstants)

local function childUserId() -- 1 equivalent call inferred from this helper
	return (tostring(Players.LocalPlayer and Players.LocalPlayer.UserId or 0))
end

local function joinTokens(items)
	local v = {}

	for _, item in items do
		if item ~= nil and item ~= "" then
			table.insert(v, (tostring(item)))
		end
	end

	return table.concat(v, " ")
end

local function buildState(p: string?, p2: string?, p3: string?) -- 13 equivalent calls inferred from this helper
	return joinTokens({ p, p2, childUserId(), p3 }) -- inferred equivalent call
end

local function requestDetails(p) -- 1 equivalent call inferred from this helper
	local requestDetails2

	if p ~= nil then
		requestDetails2 = p.requestDetails
	end

	if type(requestDetails2) == "table" then
		return requestDetails2
	end

	return nil
end

local function settingNameFromRequestDetails(items)
	if items == nil then
		return nil
	end

	local v = nil

	for k in items do
		if type(k) ~= "string" or k == "" or v ~= nil then
			return nil
		end

		v = k
	end

	return v
end

local function buildParentalState(p: string, p2: string?, p3: string?, p4, p5: string?, p6: string?)
	if p2 == nil or p2 == "" then
		return nil
	end

	local requestDetails2 = requestDetails(p4) -- inferred equivalent call

	if p == OdpAnalyticsConstants.Contexts.GameJoin then
		local universeId

		if p4 ~= nil then
			universeId = p4.universeId
		end

		if universeId == nil or tostring(universeId) == "" then
			if requestDetails2 == nil then
				universeId = nil
			else
				universeId = requestDetails2.universeId
			end
		end

		if universeId == nil or tostring(universeId) == "" then
			return nil
		end

		return buildState(p2, p3, joinTokens({ universeId, "odp", p5 }))
	else
		if p ~= OdpAnalyticsConstants.Contexts.Settings then
			return nil
		end

		local v = settingNameFromRequestDetails(requestDetails2)

		if v == nil then
			return nil
		end

		return `unlockSetting {v} odp {buildState(p2, p3, joinTokens({ p6, p5 }))}` -- inferred equivalent call
	end
end

local function createOdpAnalytics(analyticsStrings, analyticsSessionId: string?)
	local v

	if analyticsStrings == nil then
		v = nil
	else
		v = analyticsStrings[OdpAnalyticsConstants.AGE_GROUP_KEY]
	end

	local v2

	if analyticsStrings == nil then
		v2 = nil
	else
		v2 = analyticsStrings[OdpAnalyticsConstants.ASK_COPY_VARIANT_KEY]
	end

	local v3

	if analyticsStrings == nil then
		v3 = nil
	else
		v3 = analyticsStrings[OdpAnalyticsConstants.PARENT_SUPERVISION_STATE_KEY]
	end

	local v4

	if analyticsStrings == nil then
		v4 = nil
	else
		v4 = analyticsStrings[OdpAnalyticsConstants.INTRO_COPY_VARIANT_KEY]
	end

	local function agreementState(p: string?) -- 5 equivalent calls inferred from this helper
		return buildState(analyticsSessionId, v, p or v4 or OdpAnalyticsConstants.DEFAULT_INTRO_COPY_VARIANT)
	end

	local v5

	if analyticsStrings == nil then
		v5 = nil
	else
		v5 = analyticsStrings[OdpAnalyticsConstants.PIN_PURPOSE_KEY]
	end

	local v6

	if analyticsStrings ~= nil then
		v6 = analyticsStrings[OdpAnalyticsConstants.REVERIFY_REASON_KEY]
	end

	local v7

	if v6 == nil then
		v7 = nil
	else
		v7 = OdpAnalyticsConstants.ReverifyVariants[v6]
	end

	local function pinEntryState(p: string?) -- 1 equivalent call inferred from this helper
		if v5 ~= nil and v5 ~= "" then
			if p == nil then
				p = v5
			else
				p = `{v5} {p}`
			end
		end

		return buildState(analyticsSessionId, v, p)
	end

	return {
		handoffShown = function()
			authPageload(OdpAnalyticsConstants.Contexts.Handoff, buildState(analyticsSessionId, v))
		end,
		handoffContinue = function()
			authButtonClick(
				OdpAnalyticsConstants.Contexts.Handoff,
				OdpAnalyticsConstants.Buttons.ContinueAsParent,
				buildState(analyticsSessionId, v)
			)
		end,
		handoffBack = function()
			authButtonClick(
				OdpAnalyticsConstants.Contexts.Handoff,
				OdpAnalyticsConstants.Buttons.Back,
				buildState(analyticsSessionId, v)
			)
		end,
		agreementShown = function(p: string?)
			authPageload(
				OdpAnalyticsConstants.Contexts.Intro,
				agreementState(p), -- inferred equivalent call
				nil,
				nil,
				nil,
				OdpAnalyticsConstants.AssociatedText.AgreementScreen
			)
		end,
		agreementContinue = function(p: string?)
			authButtonClick(
				OdpAnalyticsConstants.Contexts.Intro,
				OdpAnalyticsConstants.Buttons.Continue,
				agreementState(p), -- inferred equivalent call
				nil,
				nil,
				nil,
				nil,
				OdpAnalyticsConstants.AssociatedText.AgreementContinue
			)
		end,
		agreementBack = function(p: string?)
			authButtonClick(
				OdpAnalyticsConstants.Contexts.Intro,
				OdpAnalyticsConstants.Buttons.Back,
				agreementState(p), -- inferred equivalent call
				nil,
				nil,
				nil,
				nil,
				OdpAnalyticsConstants.AssociatedText.AgreementBack
			)
		end,
		agreementTerms = function(p: string?)
			authButtonClick(
				OdpAnalyticsConstants.Contexts.Intro,
				OdpAnalyticsConstants.Buttons.Terms,
				agreementState(p), -- inferred equivalent call
				nil,
				nil,
				nil,
				nil,
				OdpAnalyticsConstants.AssociatedText.AgreementTerms
			)
		end,
		agreementPrivacy = function(p: string?)
			authButtonClick(
				OdpAnalyticsConstants.Contexts.Intro,
				OdpAnalyticsConstants.Buttons.Privacy,
				agreementState(p), -- inferred equivalent call
				nil,
				nil,
				nil,
				nil,
				OdpAnalyticsConstants.AssociatedText.AgreementPrivacy
			)
		end,
		verificationMethodSelectorShown = function(p: string?)
			authPageload(
				OdpAnalyticsConstants.Contexts.VerifyMethod,
				buildState(analyticsSessionId, v), -- inferred equivalent call
				nil,
				nil,
				p,
				OdpAnalyticsConstants.AssociatedText.VerificationMethodSelector
			)
		end,
		verificationMethodSelected = function(p: string)
			authFormInteraction(
				OdpAnalyticsConstants.Contexts.VerifyMethod,
				OdpAnalyticsConstants.Fields.VerifyMethod,
				buildState(analyticsSessionId, v, p), -- inferred equivalent call
				nil,
				nil,
				OdpAnalyticsConstants.AssociatedText.VerificationMethodOptions
			)
		end,
		verificationMethodContinue = function(p: string)
			authButtonClick(
				OdpAnalyticsConstants.Contexts.VerifyMethod,
				OdpAnalyticsConstants.Buttons.Continue,
				buildState(analyticsSessionId, v, p), -- inferred equivalent call
				nil,
				nil,
				nil,
				nil,
				OdpAnalyticsConstants.AssociatedText.VerificationMethodContinue
			)
		end,
		verificationMethodBack = function()
			authButtonClick(
				OdpAnalyticsConstants.Contexts.VerifyMethod,
				OdpAnalyticsConstants.Buttons.Back,
				buildState(analyticsSessionId, v), -- inferred equivalent call
				nil,
				nil,
				nil,
				nil,
				OdpAnalyticsConstants.AssociatedText.VerificationMethodBack
			)
		end,
		verificationFailed = function(p: string, p2: string?)
			authModalShown(
				OdpAnalyticsConstants.Contexts.VerifyMethod,
				buildState(analyticsSessionId, v, p), -- inferred equivalent call
				OdpAnalyticsConstants.Fields.VerificationFailed,
				nil,
				OdpAnalyticsConstants.AssociatedText.VerificationFailed,
				p2
			)
		end,
		prologueShown = function(p: string, p2: string?, p3)
			if p ~= OdpAnalyticsConstants.Contexts.GameJoin then
				return
			end

			local parentalState = buildParentalState(p, p2, v, p3, v2, nil)

			if parentalState ~= nil then
				authModalShown(
					p,
					parentalState,
					OdpAnalyticsConstants.Fields.AskParent,
					nil,
					OdpAnalyticsConstants.AssociatedText.AskParent
				)
			end
		end,
		prologueButtonClick = function(p: string, p2: string?, p3, p4: string)
			local v8 = p == OdpAnalyticsConstants.Contexts.Settings
			local v9

			if p4 == "ODP" then
				v9 = OdpAnalyticsConstants.Buttons.AskInPerson
			elseif p4 == "Remote" then
				if v8 then
					v9 = OdpAnalyticsConstants.Buttons.EmailParent
				else
					v9 = OdpAnalyticsConstants.Buttons.AskParent
				end
			elseif p4 == "Cancel" then
				if v8 then
					v9 = OdpAnalyticsConstants.Buttons.Cancel
				else
					v9 = OdpAnalyticsConstants.Buttons.CancelAskParent
				end
			end

			if v9 == nil then
				return
			end

			local v10

			if p4 == "ODP" then
				v10 = OdpAnalyticsConstants.AssociatedText.AskInPerson
			elseif p4 == "Remote" then
				v10 = OdpAnalyticsConstants.AssociatedText.EmailParent
			else
				v10 = OdpAnalyticsConstants.AssociatedText.Cancel
			end

			local v11

			if not (v8 or p4 == "Cancel") then
				v11 = v2
			end

			local v12

			if v8 and p4 == "ODP" then
				v12 = v3
			end

			local parentalState = buildParentalState(p, p2, v, p3, v11, v12)

			if parentalState ~= nil then
				authButtonClick(p, v9, parentalState, nil, nil, nil, nil, v10)
			end
		end,
		remoteRequestSent = function(p: string?, p2: string?, p3)
			if p == nil then
				return
			end

			local parentalState = buildParentalState(p, p2, v, p3, nil, nil)

			if parentalState ~= nil then
				authMsgShown(
					p,
					parentalState,
					OdpAnalyticsConstants.Fields.RequestSentToast,
					nil,
					OdpAnalyticsConstants.AssociatedText.RequestSent
				)
			end
		end,
		pinEntryShown = function()
			local pinEntry = OdpAnalyticsConstants.Contexts.PinEntry
			local v8

			if not (v5 == nil or v5 == "") then
				v8 = v5
			end

			local state = buildState(analyticsSessionId, v, v8) -- inferred equivalent call
			local v9

			if not (v5 == nil or v5 == "") then
				v9 = OdpAnalyticsConstants.AssociatedText.PinEntryShown
			end

			authPageload(pinEntry, state, nil, nil, nil, v9)
		end,
		pinEntryDigitsChanged = function(p: number)
			local pinEntry = OdpAnalyticsConstants.Contexts.PinEntry
			local pinEntry2 = OdpAnalyticsConstants.Fields.PinEntry
			local v8 = tostring(p)

			if v5 ~= nil and v5 ~= "" then
				if v8 == nil then
					v8 = v5
				else
					v8 = `{v5} {v8}`
				end
			end

			authFormInteraction(
				pinEntry,
				pinEntry2,
				buildState(analyticsSessionId, v, v8), -- inferred equivalent call
				nil,
				nil,
				OdpAnalyticsConstants.AssociatedText.PinEntry
			)
		end,
		pinEntryRevealToggled = function(flag: boolean)
			local pinEntry = OdpAnalyticsConstants.Contexts.PinEntry
			local pinShowToggle = OdpAnalyticsConstants.Fields.PinShowToggle
			local v8

			if flag then
				v8 = OdpAnalyticsConstants.PinRevealStates.Shown
			else
				v8 = OdpAnalyticsConstants.PinRevealStates.Hidden
			end

			local v9 = pinEntryState(v8) -- inferred equivalent call
			local v10

			if flag then
				v10 = OdpAnalyticsConstants.AssociatedText.PinShowToggle
			else
				v10 = OdpAnalyticsConstants.AssociatedText.PinHideToggle
			end

			authFormInteraction(pinEntry, pinShowToggle, v9, nil, nil, v10)
		end,
		pinEntryForgotPin = function()
			local pinEntry = OdpAnalyticsConstants.Contexts.PinEntry
			local forgotPin = OdpAnalyticsConstants.Buttons.ForgotPin
			local v8

			if not (v5 == nil or v5 == "") then
				v8 = v5
			end

			authButtonClick(
				pinEntry,
				forgotPin,
				buildState(analyticsSessionId, v, v8), -- inferred equivalent call
				nil,
				nil,
				nil,
				nil,
				OdpAnalyticsConstants.AssociatedText.ForgotPin
			)
		end,
		pinEntryIncorrect = function()
			local pinEntry = OdpAnalyticsConstants.Contexts.PinEntry
			local v8

			if not (v5 == nil or v5 == "") then
				v8 = v5
			end

			authMsgShown(pinEntry, buildState(analyticsSessionId, v, v8), OdpAnalyticsConstants.Fields.PinIncorrect) -- inferred equivalent call
		end,
		reverifyShown = function()
			if v7 == nil then
				return
			end

			authModalShown(
				OdpAnalyticsConstants.Contexts.PinRecovery,
				buildState(analyticsSessionId, v), -- inferred equivalent call
				v7.field,
				nil,
				v7.associatedText
			)
		end,
		reverifyButtonClick = function(p: string)
			local v8

			if v7 ~= nil then
				v8 = v7.buttons[p]
			end

			if v8 == nil then
				return
			end

			authButtonClick(
				OdpAnalyticsConstants.Contexts.PinRecovery,
				v8.btn,
				buildState(analyticsSessionId, v), -- inferred equivalent call
				nil,
				nil,
				nil,
				nil,
				v8.associatedText
			)
		end,
		reverifyClose = function()
			if v7 == nil then
				return
			end

			authButtonClick(
				OdpAnalyticsConstants.Contexts.PinRecovery,
				OdpAnalyticsConstants.Buttons.Close,
				buildState(analyticsSessionId, v), -- inferred equivalent call
				nil,
				nil,
				nil,
				nil,
				OdpAnalyticsConstants.AssociatedText.PinRecoveryClose
			)
		end
	}
end

return {
	childUserId = childUserId,
	joinTokens = joinTokens,
	createOdpAnalytics = createOdpAnalytics,
	useOdpAnalytics = function(p)
		return React.useMemo(function()
			return createOdpAnalytics(p.analyticsStrings, p.analyticsSessionId)
		end, { p.analyticsStrings, p.analyticsSessionId })
	end
}
