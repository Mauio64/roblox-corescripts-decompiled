local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/React")

local Players = game:GetService("Players")

local AuthAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/AuthAnalytics")
local authButtonClick = AuthAnalytics.Events.authButtonClick
local authFormInteraction = AuthAnalytics.Events.authFormInteraction
local authModalShown = AuthAnalytics.Events.authModalShown
local authMsgShown = AuthAnalytics.Events.authMsgShown
local authPageload = AuthAnalytics.Events.authPageload

require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/Types")
local OdpAnalyticsConstants = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/OdpAnalyticsConstants")

local function joinTokens(items)
	local v5 = {}

	for k, item in items do
		if item ~= nil and item ~= "" then
			table.insert(v5, (tostring(item)))
		end
	end

	return table.concat(v5, " ")
end

local function buildState(p2, p3, p4)
	return joinTokens({
		p2,
		p3,
		tostring(Players.LocalPlayer and Players.LocalPlayer.UserId or 0),
		p4
	})
end

local function requestDetails(p2)
	local requestDetails2 = if p2 ~= nil then p2.requestDetails else nil

	if type(requestDetails2) == "table" then
		return requestDetails2
	end

	return nil
end

local function settingNameFromRequestDetails(requestDetails2)
	if requestDetails2 == nil then
		return nil
	end

	local v5 = nil

	for k in requestDetails2 do
		if type(k) ~= "string" or k == "" or v5 ~= nil then
			return nil
		end

		v5 = k
	end

	return v5
end

local function buildParentalState(p2, p3, p4, p5, p6, p7)
	if p3 == nil or p3 == "" then
		return nil
	end

	local requestDetails2 = if p5 ~= nil then p5.requestDetails else nil

	if type(requestDetails2) ~= "table" then
		requestDetails2 = nil
	end

	if p2 == OdpAnalyticsConstants.Contexts.GameJoin then
		local universeId = if p5 ~= nil then p5.universeId else nil

		if universeId == nil or tostring(universeId) == "" then
			universeId = if requestDetails2 ~= nil then requestDetails2.universeId else nil
		end

		if universeId == nil or tostring(universeId) == "" then
			return nil
		end

		return buildState(p3, p4, joinTokens({ universeId, "odp", p6 }))
	else
		if p2 ~= OdpAnalyticsConstants.Contexts.Settings then
			return nil
		end

		local v5 = settingNameFromRequestDetails(requestDetails2)

		if v5 == nil then
			return nil
		end

		local v6 = joinTokens({ p7, p6 })
		return `unlockSetting {v5} odp {joinTokens({
			p3,
			p4,
			tostring(Players.LocalPlayer and Players.LocalPlayer.UserId or 0),
			v6
		})}`
	end
end

local function createOdpAnalytics(analyticsStrings, analyticsSessionId)
	local v5 = if analyticsStrings ~= nil then analyticsStrings[OdpAnalyticsConstants.AGE_GROUP_KEY] else nil
	local v6 = if analyticsStrings ~= nil then analyticsStrings[OdpAnalyticsConstants.ASK_COPY_VARIANT_KEY] else nil
	local v7

	if analyticsStrings == nil then
		v7 = nil
	else
		v7 = analyticsStrings[OdpAnalyticsConstants.PARENT_SUPERVISION_STATE_KEY]
	end

	local v8 = if analyticsStrings ~= nil then analyticsStrings[OdpAnalyticsConstants.INTRO_COPY_VARIANT_KEY] else nil
	local function agreementState(p2)
		return buildState(analyticsSessionId, v5, p2 or v8 or OdpAnalyticsConstants.DEFAULT_INTRO_COPY_VARIANT)
	end

	local v9 = if analyticsStrings ~= nil then analyticsStrings[OdpAnalyticsConstants.PIN_PURPOSE_KEY] else nil
	local v10 = if analyticsStrings ~= nil then analyticsStrings[OdpAnalyticsConstants.REVERIFY_REASON_KEY] else nil
	local v11 = if v10 ~= nil then OdpAnalyticsConstants.ReverifyVariants[v10] else nil

	local function pinEntryState(p2)
		if v9 ~= nil and v9 ~= "" then
			p2 = if p2 == nil then v9 else `{v9} {p2}`
		end

		return buildState(analyticsSessionId, v5, p2)
	end

	return {
		handoffShown = function()
			authPageload(OdpAnalyticsConstants.Contexts.Handoff, buildState(analyticsSessionId, v5))
		end,
		handoffContinue = function()
			authButtonClick(
				OdpAnalyticsConstants.Contexts.Handoff,
				OdpAnalyticsConstants.Buttons.ContinueAsParent,
				buildState(analyticsSessionId, v5)
			)
		end,
		handoffBack = function()
			authButtonClick(
				OdpAnalyticsConstants.Contexts.Handoff,
				OdpAnalyticsConstants.Buttons.Back,
				buildState(analyticsSessionId, v5)
			)
		end,
		agreementShown = function(p2)
			local intro = OdpAnalyticsConstants.Contexts.Intro
			local v15 = p2 or v8 or OdpAnalyticsConstants.DEFAULT_INTRO_COPY_VARIANT
			authPageload(intro, joinTokens({
				analyticsSessionId,
				v5,
				tostring(Players.LocalPlayer and Players.LocalPlayer.UserId or 0),
				v15
			}), nil, nil, nil, OdpAnalyticsConstants.AssociatedText.AgreementScreen)
		end,
		agreementContinue = function(p2)
			local intro = OdpAnalyticsConstants.Contexts.Intro
			local continue = OdpAnalyticsConstants.Buttons.Continue
			local v15 = p2 or v8 or OdpAnalyticsConstants.DEFAULT_INTRO_COPY_VARIANT
			authButtonClick(intro, continue, joinTokens({
				analyticsSessionId,
				v5,
				tostring(Players.LocalPlayer and Players.LocalPlayer.UserId or 0),
				v15
			}), nil, nil, nil, nil, OdpAnalyticsConstants.AssociatedText.AgreementContinue)
		end,
		agreementBack = function(p2)
			local intro = OdpAnalyticsConstants.Contexts.Intro
			local back = OdpAnalyticsConstants.Buttons.Back
			local v15 = p2 or v8 or OdpAnalyticsConstants.DEFAULT_INTRO_COPY_VARIANT
			authButtonClick(intro, back, joinTokens({
				analyticsSessionId,
				v5,
				tostring(Players.LocalPlayer and Players.LocalPlayer.UserId or 0),
				v15
			}), nil, nil, nil, nil, OdpAnalyticsConstants.AssociatedText.AgreementBack)
		end,
		agreementTerms = function(p2)
			local intro = OdpAnalyticsConstants.Contexts.Intro
			local terms = OdpAnalyticsConstants.Buttons.Terms
			local v15 = p2 or v8 or OdpAnalyticsConstants.DEFAULT_INTRO_COPY_VARIANT
			authButtonClick(intro, terms, joinTokens({
				analyticsSessionId,
				v5,
				tostring(Players.LocalPlayer and Players.LocalPlayer.UserId or 0),
				v15
			}), nil, nil, nil, nil, OdpAnalyticsConstants.AssociatedText.AgreementTerms)
		end,
		agreementPrivacy = function(p2)
			local intro = OdpAnalyticsConstants.Contexts.Intro
			local privacy = OdpAnalyticsConstants.Buttons.Privacy
			local v15 = p2 or v8 or OdpAnalyticsConstants.DEFAULT_INTRO_COPY_VARIANT
			authButtonClick(intro, privacy, joinTokens({
				analyticsSessionId,
				v5,
				tostring(Players.LocalPlayer and Players.LocalPlayer.UserId or 0),
				v15
			}), nil, nil, nil, nil, OdpAnalyticsConstants.AssociatedText.AgreementPrivacy)
		end,
		verificationMethodSelectorShown = function(p2)
			authPageload(OdpAnalyticsConstants.Contexts.VerifyMethod, joinTokens({
				analyticsSessionId,
				v5,
				tostring(Players.LocalPlayer and Players.LocalPlayer.UserId or 0),
				nil
			}), nil, nil, p2, OdpAnalyticsConstants.AssociatedText.VerificationMethodSelector)
		end,
		verificationMethodSelected = function(p2)
			authFormInteraction(OdpAnalyticsConstants.Contexts.VerifyMethod, OdpAnalyticsConstants.Fields.VerifyMethod, joinTokens({
				analyticsSessionId,
				v5,
				tostring(Players.LocalPlayer and Players.LocalPlayer.UserId or 0),
				p2
			}), nil, nil, OdpAnalyticsConstants.AssociatedText.VerificationMethodOptions)
		end,
		verificationMethodContinue = function(p2)
			authButtonClick(OdpAnalyticsConstants.Contexts.VerifyMethod, OdpAnalyticsConstants.Buttons.Continue, joinTokens({
				analyticsSessionId,
				v5,
				tostring(Players.LocalPlayer and Players.LocalPlayer.UserId or 0),
				p2
			}), nil, nil, nil, nil, OdpAnalyticsConstants.AssociatedText.VerificationMethodContinue)
		end,
		verificationMethodBack = function()
			authButtonClick(OdpAnalyticsConstants.Contexts.VerifyMethod, OdpAnalyticsConstants.Buttons.Back, joinTokens({
				analyticsSessionId,
				v5,
				tostring(Players.LocalPlayer and Players.LocalPlayer.UserId or 0),
				nil
			}), nil, nil, nil, nil, OdpAnalyticsConstants.AssociatedText.VerificationMethodBack)
		end,
		verificationFailed = function(p2, p3)
			authModalShown(OdpAnalyticsConstants.Contexts.VerifyMethod, joinTokens({
				analyticsSessionId,
				v5,
				tostring(Players.LocalPlayer and Players.LocalPlayer.UserId or 0),
				p2
			}), OdpAnalyticsConstants.Fields.VerificationFailed, nil, OdpAnalyticsConstants.AssociatedText.VerificationFailed, p3)
		end,
		prologueShown = function(p2, p3, p4)
			if p2 ~= OdpAnalyticsConstants.Contexts.GameJoin then
				return
			end

			local parentalState = buildParentalState(p2, p3, v5, p4, v6, nil)

			if parentalState ~= nil then
				authModalShown(
					p2,
					parentalState,
					OdpAnalyticsConstants.Fields.AskParent,
					nil,
					OdpAnalyticsConstants.AssociatedText.AskParent
				)
			end
		end,
		prologueButtonClick = function(p2, p3, p4, p5)
			local v12 = p2 == OdpAnalyticsConstants.Contexts.Settings
			local v13

			if p5 == "ODP" then
				v13 = OdpAnalyticsConstants.Buttons.AskInPerson
			elseif p5 == "Remote" then
				v13 = if v12 then OdpAnalyticsConstants.Buttons.EmailParent else OdpAnalyticsConstants.Buttons.AskParent
			elseif p5 == "Cancel" then
				v13 = if v12 then OdpAnalyticsConstants.Buttons.Cancel else OdpAnalyticsConstants.Buttons.CancelAskParent
			end

			if v13 == nil then
				return
			end

			local v14

			if p5 == "ODP" then
				v14 = OdpAnalyticsConstants.AssociatedText.AskInPerson
			elseif p5 == "Remote" then
				v14 = OdpAnalyticsConstants.AssociatedText.EmailParent
			else
				v14 = OdpAnalyticsConstants.AssociatedText.Cancel
			end

			local v17 = if not (v12 or p5 == "Cancel") then v6 else nil
			local v18 = if v12 and p5 == "ODP" then v7 else nil
			local v19 = buildParentalState(p2, p3, v5, p4, v17, v18)

			if v19 ~= nil then
				authButtonClick(p2, v13, v19, nil, nil, nil, nil, v14)
			end
		end,
		remoteRequestSent = function(p2, p3, p4)
			if p2 == nil then
				return
			end

			local parentalState = buildParentalState(p2, p3, v5, p4, nil, nil)

			if parentalState ~= nil then
				authMsgShown(
					p2,
					parentalState,
					OdpAnalyticsConstants.Fields.RequestSentToast,
					nil,
					OdpAnalyticsConstants.AssociatedText.RequestSent
				)
			end
		end,
		pinEntryShown = function()
			local pinEntry = OdpAnalyticsConstants.Contexts.PinEntry
			local v13 = if not (v9 == nil or v9 == "") then v9 else nil
			local v14 = joinTokens({
				analyticsSessionId,
				v5,
				tostring(Players.LocalPlayer and Players.LocalPlayer.UserId or 0),
				v13
			})

			local v18 = if v9 ~= nil and v9 ~= "" then OdpAnalyticsConstants.AssociatedText.PinEntryShown else nil
			authPageload(pinEntry, v14, nil, nil, nil, v18)
		end,
		pinEntryDigitsChanged = function(p2)
			local pinEntry = OdpAnalyticsConstants.Contexts.PinEntry
			local pinEntry2 = OdpAnalyticsConstants.Fields.PinEntry
			local v13 = tostring(p2)

			if v9 ~= nil and v9 ~= "" then
				v13 = if v13 == nil then v9 else `{v9} {v13}`
			end

			authFormInteraction(pinEntry, pinEntry2, joinTokens({
				analyticsSessionId,
				v5,
				tostring(Players.LocalPlayer and Players.LocalPlayer.UserId or 0),
				v13
			}), nil, nil, OdpAnalyticsConstants.AssociatedText.PinEntry)
		end,
		pinEntryRevealToggled = function(p2)
			local pinEntry = OdpAnalyticsConstants.Contexts.PinEntry
			local pinShowToggle = OdpAnalyticsConstants.Fields.PinShowToggle
			local v13 = if p2 then OdpAnalyticsConstants.PinRevealStates.Shown else OdpAnalyticsConstants.PinRevealStates.Hidden

			if v9 ~= nil and v9 ~= "" then
				v13 = if v13 == nil then v9 else `{v9} {v13}`
			end

			local v14 = joinTokens({
				analyticsSessionId,
				v5,
				tostring(Players.LocalPlayer and Players.LocalPlayer.UserId or 0),
				v13
			})

			local v17 = if p2 then OdpAnalyticsConstants.AssociatedText.PinShowToggle else OdpAnalyticsConstants.AssociatedText.PinHideToggle
			authFormInteraction(pinEntry, pinShowToggle, v14, nil, nil, v17)
		end,
		pinEntryForgotPin = function()
			local pinEntry = OdpAnalyticsConstants.Contexts.PinEntry
			local forgotPin = OdpAnalyticsConstants.Buttons.ForgotPin
			local v13 = if not (v9 == nil or v9 == "") then v9 else nil
			authButtonClick(pinEntry, forgotPin, joinTokens({
				analyticsSessionId,
				v5,
				tostring(Players.LocalPlayer and Players.LocalPlayer.UserId or 0),
				v13
			}), nil, nil, nil, nil, OdpAnalyticsConstants.AssociatedText.ForgotPin)
		end,
		pinEntryIncorrect = function()
			local pinEntry = OdpAnalyticsConstants.Contexts.PinEntry
			local v13 = if not (v9 == nil or v9 == "") then v9 else nil
			authMsgShown(pinEntry, joinTokens({
				analyticsSessionId,
				v5,
				tostring(Players.LocalPlayer and Players.LocalPlayer.UserId or 0),
				v13
			}), OdpAnalyticsConstants.Fields.PinIncorrect)
		end,
		reverifyShown = function()
			if v11 == nil then
				return
			end

			authModalShown(OdpAnalyticsConstants.Contexts.PinRecovery, joinTokens({
				analyticsSessionId,
				v5,
				tostring(Players.LocalPlayer and Players.LocalPlayer.UserId or 0),
				nil
			}), v11.field, nil, v11.associatedText)
		end,
		reverifyButtonClick = function(p2)
			local v12 = if v11 ~= nil then v11.buttons[p2] else nil

			if v12 == nil then
				return
			end

			authButtonClick(OdpAnalyticsConstants.Contexts.PinRecovery, v12.btn, joinTokens({
				analyticsSessionId,
				v5,
				tostring(Players.LocalPlayer and Players.LocalPlayer.UserId or 0),
				nil
			}), nil, nil, nil, nil, v12.associatedText)
		end,
		reverifyClose = function()
			if v11 == nil then
				return
			end

			authButtonClick(OdpAnalyticsConstants.Contexts.PinRecovery, OdpAnalyticsConstants.Buttons.Close, joinTokens({
				analyticsSessionId,
				v5,
				tostring(Players.LocalPlayer and Players.LocalPlayer.UserId or 0),
				nil
			}), nil, nil, nil, nil, OdpAnalyticsConstants.AssociatedText.PinRecoveryClose)
		end
	}
end

return {
	childUserId = function()
		return (tostring(Players.LocalPlayer and Players.LocalPlayer.UserId or 0))
	end,
	joinTokens = joinTokens,
	createOdpAnalytics = createOdpAnalytics,
	useOdpAnalytics = function(p2)
		return React.useMemo(function()
			return createOdpAnalytics(p2.analyticsStrings, p2.analyticsSessionId)
		end, { p2.analyticsStrings, p2.analyticsSessionId })
	end
}
