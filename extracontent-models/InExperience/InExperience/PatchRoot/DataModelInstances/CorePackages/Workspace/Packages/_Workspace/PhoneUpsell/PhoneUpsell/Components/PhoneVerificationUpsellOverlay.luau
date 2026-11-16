local PhoneUpsell = script:FindFirstAncestor("PhoneUpsell")
local parent = PhoneUpsell.Parent
local UserInputService = game:GetService("UserInputService")

local React = require(parent.React)
local Roact = require(parent.Roact)
local RoactRodux = require(parent.RoactRodux)
local Cryo = require(parent.Cryo)
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local SharedFlags = require(parent.SharedFlags)
local FFlagUseSignalsForCountryCodeList = SharedFlags.FFlagUseSignalsForCountryCodeList
local AuthCommon = require(parent.AuthCommon)
local GetCountryCodeListStore = AuthCommon.Stores.GetCountryCodeListStore

require(parent.LuauPolyfill)
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local RoactServices = require(parent.RoactServices)
local roactServices = RoactServices.RoactServices
local EventStreamConstants = require(PhoneUpsell.DuplicateAnalytics.EventStreamConstants)
local RoactAnalyticsAuthEvents = require(PhoneUpsell.DuplicateAnalytics.RoactAnalyticsAuthEvents)
local debounce = require(PhoneUpsell.Utils.debounce)
local mergeProps = require(PhoneUpsell.Utils.mergeProps)

local PhoneVerificationUpsellState = require(PhoneUpsell.Components.PhoneVerificationUpsellState)
local EntryView = require(PhoneUpsell.Components.EntryView)
local AddPhoneView = require(PhoneUpsell.Components.AddPhoneView)
local VerifyPhoneView = require(PhoneUpsell.Components.VerifyPhoneView)
local PhoneVerificationStatusOverlay = require(PhoneUpsell.Components.PhoneVerificationStatusOverlay)

local Foundation = require(parent.Foundation)
local IconSize = Foundation.Enums.IconSize
local Loading = Foundation.Loading

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local SetPhoneNumber = require(PhoneUpsell.Thunks.SetPhoneNumber)
local VerifyPhoneCode = require(PhoneUpsell.Thunks.VerifyPhoneCode)
local ResendPhoneCode = require(PhoneUpsell.Thunks.ResendPhoneCode)
local ContactImporter = require(parent.ContactImporter)
local SetIsPhoneVerified = ContactImporter.Actions.SetIsPhoneVerified

local GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix = require(PhoneUpsell.Utils.GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix)

local RoactAppExperiment = require(parent.RoactAppExperiment)
local SharedFlags2 = require(parent.SharedFlags)
local GetFStringAndroidPhoneVerificationLayer = SharedFlags2.GetFStringAndroidPhoneVerificationLayer
local SharedFlags3 = require(parent.SharedFlags)
local GetFStringIOSPhoneVerificationLayer = SharedFlags3.GetFStringIOSPhoneVerificationLayer

local GetFFlagLuaUsePhoneNumberTextTypeForPhoneUpsell = require(PhoneUpsell.Flags.GetFFlagLuaUsePhoneNumberTextTypeForPhoneUpsell)
local GetFFlagPhoneUseParentSizeForScreenSize = require(PhoneUpsell.Flags.GetFFlagPhoneUseParentSizeForScreenSize)

local IdentityProtocol = require(parent.IdentityProtocol)
local identityProtocol = IdentityProtocol.IdentityProtocol

local v = { name = "United States", code = "US", prefix = "1", localizedName = "United States" }

local function fn() end

local v2 = {
	onSuccess = fn,
	onFailure = fn,
	onCancelled = fn,
	origin = "",
	eventContext = "",
	addPhoneTitleKey = "Feature.VerificationUpsell.Action.AddPhone",
	addPhoneDescriptionKey = "Feature.VerificationUpsell.Description.VerificationCodeSmsFeesMayApply",
	extraButtonTextKey = "",
	onExtraButtonClick = fn,
	shouldAutofillAndroidPhoneNumberAtLaunch = false,
	isOTPInputTypeEnabled = false,
	isPhoneNumberTextTypeEnabled = false,
	alwaysShowAddPhoneLegalText = false,
	requireAddPhoneLegalTextCheckbox = false,
	closeUpsell = fn,
	showWebpage = function(_) end
}

local function PhoneVerificationUpsellOverlay(p)
	local v3 = mergeProps(v2, p)
	local useState = React.useState
	local v4

	if v3.entryConfig then
		v4 = PhoneVerificationUpsellState.Entry
	else
		v4 = PhoneVerificationUpsellState.AddPhone
	end

	local state, setState = useState(v4)

	local state2, setState2 = React.useState("")
	local state3, setState3 = React.useState(v)
	local state4, setState4 = React.useState(false)
	local state5, setState5 = React.useState("")
	local state6, setState6 = React.useState("")
	local state7, setState7 = React.useState("")
	local state8, setState8 = React.useState("")
	local state9, _ = React.useState(false)
	local state10, setState9 = React.useState(false)
	local state11, setState10 = React.useState(false)
	local state12, setState11 = React.useState(false)
	local state13, setState12 = React.useState(0)
	local state14, setState13 = React.useState(Vector2.new(400, 400))
	local ref = React.useRef(false)

	local v5 = useLocalization({
		verifyingKey = "Feature.VerificationUpsell.Label.Verifying",
		invalidPhoneFormatKey = "Feature.VerificationUpsell.Response.ErrorPhoneFormatInvalid",
		invalidPhoneNumberKey = "Feature.VerificationUpsell.Response.InvalidPhoneNumberError",
		invalidVerificationCodeKey = "Feature.VerificationUpsell.Message.InvalidSmsCode",
		tooManyAccountsKey = "Feature.VerificationUpsell.Response.PhoneHasTooManyAssociatedAccounts",
		tooManyAttemptsKey = "Feature.VerificationUpsell.Response.TooManyAttemptsTryAgainLater",
		genericErrorKey = "Feature.VerificationUpsell.Response.ErrorTryAgain"
	})

	local onScreenKeyboardVisibleChangedConnection = nil

	React.useEffect(function()
		if not state4 and v3.countryCodeList and #v3.countryCodeList > 0 then
			for _, countryCode in v3.countryCodeList do
				if countryCode.isDefault then
					setState3(countryCode)
				end
			end

			setState4(true)
		end
	end, { v3.countryCodeList, state4 })

	React.useEffect(function()
		return function()
			ref.current = state10
		end
	end, { state10 })

	local function fn2() -- 2 equivalent calls inferred from this helper
		local default = identityProtocol.default
		default:supportsGetPhoneNumber():andThen(function(flag: boolean?)
			print("PhoneVerification: Autofill phone number supported: {}!", flag)

			if not flag then
				return
			end

			v3.authEventAnalytics.reportModalActionWithSection(
				v3.eventContext,
				"phoneAutofillEligible",
				"autofill",
				v3.origin,
				state
			)

			local phoneNumber = default:getPhoneNumber()

			if not phoneNumber then
				return
			end

			phoneNumber:andThen(function(p2: string?)
				if not p2 or p2 == "" then
					v3.authEventAnalytics.reportModalActionWithSection(
						v3.eventContext,
						"phoneAutofillNull",
						"autofill",
						v3.origin,
						state
					)

					return
				end

				local v6, v7 = GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix(p2, state3.prefix)

				if v6 == v.prefix then
					v3.authEventAnalytics.reportModalActionWithSection(
						v3.eventContext,
						"phoneAutofillUSFound",
						"autofill",
						v3.origin,
						state
					)
				end

				setState2(v7)

				v3.authEventAnalytics.reportModalActionWithSection(
					v3.eventContext,
					"phoneAutofillSuccess",
					"autofill",
					v3.origin,
					state
				)
			end)
		end)
	end

	React.useEffect(function()
		onScreenKeyboardVisibleChangedConnection = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(function()
			setState11(UserInputService.OnScreenKeyboardVisible)
			setState12(UserInputService.OnScreenKeyboardVisible and UserInputService.OnScreenKeyboardSize.Y or 0)
		end)
		v3.authEventAnalytics.reportModalShownWithSection(
			v3.eventContext,
			v3.origin,
			PhoneVerificationUpsellState.AddPhone
		)

		if v3.isAutofillPhoneNumberEnabled then
			fn2() -- inferred equivalent call
		end

		return function()
			if onScreenKeyboardVisibleChangedConnection then
				onScreenKeyboardVisibleChangedConnection:Disconnect()
			end

			onScreenKeyboardVisibleChangedConnection = nil

			if not ref.current then
				v3.onCancelled()
			end
		end
	end, {})

	local screenSize = useSelector(function(p2)
		return p2.ScreenSize
	end)

	local function handleCloseClick()
		v3.authEventAnalytics.reportModalDismissedWithSection(v3.eventContext, v3.origin, state)

		v3.closeUpsell()
	end

	local function handlePhoneErrors(errorCode: number?) -- 3 equivalent calls inferred from this helper
		if errorCode == 2 then
			return v5.invalidPhoneFormatKey
		elseif errorCode == 6 then
			return v5.tooManyAttemptsKey
		elseif errorCode == 7 then
			return v5.invalidVerificationCodeKey
		elseif errorCode == 8 then
			return v5.invalidPhoneNumberKey
		elseif errorCode == 9 then
			return v5.tooManyAccountsKey
		end

		return v5.genericErrorKey
	end

	local function fn3() -- 1 equivalent call inferred from this helper
		local default = identityProtocol.default
		default:supportsGetSMSOTP():andThen(function(flag: boolean?)
			print("PhoneVerification: Autofill OTP supported: {}!", flag)

			if flag then
				v3.authEventAnalytics.reportModalActionWithSection(
					v3.eventContext,
					"codeAutofillEligible",
					"autofill",
					v3.origin,
					state
				)

				local smsotp = default:getSMSOTP()

				if smsotp then
					smsotp:andThen(function(p2: string?)
						if p2 and p2 ~= "" then
							setState5(p2)
							setState6(p2)
							v3.authEventAnalytics.reportModalActionWithSection(
								v3.eventContext,
								"codeAutofillSuccess",
								"autofill",
								v3.origin,
								state
							)
						end
					end)
				end
			end
		end)
	end

	local function handleSetPhone()
		setState10(true)
		local v6 = v3.setPhoneNumber(v3.networking, state3.code, state3.prefix, state2)

		if v6 then
			v6:andThen(function()
				setState(PhoneVerificationUpsellState.VerifyPhone)
				setState10(false)
				v3.authEventAnalytics.reportModalShownWithSection(
					v3.eventContext,
					v3.origin,
					PhoneVerificationUpsellState.VerifyPhone
				)

				if v3.isAutofillSMSOtpEnabled then
					fn3() -- inferred equivalent call
				end
			end):catch(function(p2)
				if p2 then
					if p2.PhoneRegexFailed then
						v3.authEventAnalytics.reportModalShownWithSectionAndError(
							v3.eventContext,
							EventStreamConstants.Field.ErrorMessage,
							v3.origin,
							PhoneVerificationUpsellState.AddPhone,
							""
						)

						setState7(v5.invalidPhoneFormatKey)
					else
						v3.authEventAnalytics.reportModalShownWithSectionAndError(
							v3.eventContext,
							EventStreamConstants.Field.ErrorMessage,
							v3.origin,
							PhoneVerificationUpsellState.AddPhone,
							p2.ErrorCode
						)

						setState7(handlePhoneErrors(p2.ErrorCode)) -- inferred equivalent call
					end
				else
					v3.authEventAnalytics.reportModalShownWithSectionAndError(
						v3.eventContext,
						EventStreamConstants.Field.ErrorMessage,
						v3.origin,
						PhoneVerificationUpsellState.AddPhone,
						""
					)

					setState7(v5.genericErrorKey)
				end

				setState10(false)
			end)
		end

		v3.authEventAnalytics.reportInteractWithActionAndSection(
			v3.eventContext,
			"",
			"",
			v3.origin,
			EventStreamConstants.Button.Continue,
			PhoneVerificationUpsellState.AddPhone
		)
	end

	local function handleVerifyPhone()
		setState10(true)
		local v6 = v3.verifyPhoneCode(v3.networking, state6)

		if v6 then
			v6:andThen(function()
				setState9(true)
			end):catch(function(p2)
				if p2 then
					v3.authEventAnalytics.reportModalShownWithSectionAndError(
						v3.eventContext,
						EventStreamConstants.Field.ErrorMessage,
						v3.origin,
						PhoneVerificationUpsellState.VerifyPhone,
						p2.ErrorCode
					)

					setState8(handlePhoneErrors(p2.ErrorCode)) -- inferred equivalent call
				else
					v3.authEventAnalytics.reportModalShownWithSectionAndError(
						v3.eventContext,
						EventStreamConstants.Field.ErrorMessage,
						v3.origin,
						PhoneVerificationUpsellState.VerifyPhone,
						""
					)

					setState8(v5.genericErrorKey)
				end

				setState10(false)
			end)
		end

		v3.authEventAnalytics.reportInteractWithActionAndSection(
			v3.eventContext,
			"",
			"",
			v3.origin,
			EventStreamConstants.Button.AutoSubmit,
			PhoneVerificationUpsellState.VerifyPhone
		)
	end

	local function handleResendCode()
		local resendPhoneCode = v3.resendPhoneCode(v3.networking)

		if resendPhoneCode then
			resendPhoneCode:andThen(function() end):catch(function(p2)
				if p2 then
					v3.authEventAnalytics.reportModalShownWithSectionAndError(
						v3.eventContext,
						EventStreamConstants.Field.ErrorMessage,
						v3.origin,
						PhoneVerificationUpsellState.VerifyPhone,
						p2.ErrorCode
					)

					setState8(handlePhoneErrors(p2.ErrorCode)) -- inferred equivalent call
				else
					v3.authEventAnalytics.reportModalShownWithSectionAndError(
						v3.eventContext,
						EventStreamConstants.Field.ErrorMessage,
						v3.origin,
						PhoneVerificationUpsellState.VerifyPhone,
						""
					)

					setState8(v5.genericErrorKey)
				end
			end)
		end

		v3.authEventAnalytics.reportInteractWithActionAndSection(
			v3.eventContext,
			"",
			"",
			v3.origin,
			EventStreamConstants.Button.ResendCode,
			PhoneVerificationUpsellState.VerifyPhone
		)
	end

	local function returnToAddPhone()
		setState(PhoneVerificationUpsellState.AddPhone)
		v3.authEventAnalytics.reportInteractWithActionAndSection(
			v3.eventContext,
			"",
			"",
			v3.origin,
			EventStreamConstants.Button.ChangePhoneNumber,
			PhoneVerificationUpsellState.VerifyPhone
		)
	end

	local function proceedToAddPhone()
		setState(PhoneVerificationUpsellState.AddPhone)
		v3.authEventAnalytics.reportInteractWithActionAndSection(
			v3.eventContext,
			"",
			"",
			v3.origin,
			EventStreamConstants.Button.Continue,
			PhoneVerificationUpsellState.Entry
		)
	end

	local function navigateToSMSTerms()
		if not state11 then
			v3.authEventAnalytics.reportModalActionWithSection(
				v3.eventContext,
				EventStreamConstants.Field.TermsOfService,
				"",
				v3.origin,
				state
			)

			v3.showWebpage("https://en.help.roblox.com/hc/articles/9483830673556-Roblox-SMS-Terms-of-Service")
		end
	end

	local function navigateToPrivacy()
		if not state11 then
			v3.authEventAnalytics.reportModalActionWithSection(
				v3.eventContext,
				EventStreamConstants.Field.PrivacyPolicy,
				"",
				v3.origin,
				state
			)

			v3.showWebpage("https://en.help.roblox.com/hc/articles/115004630823")
		end
	end

	local function fn4(p2)
		if not state11 then
			setState7("")
			setState2(p2.Text)
		end
	end

	local function fn5()
		v3.authEventAnalytics.reportInteractWithActionAndSection(
			v3.eventContext,
			EventStreamConstants.Field.CountryPrefix,
			EventStreamConstants.ActionType.Focus,
			v3.origin,
			"",
			PhoneVerificationUpsellState.AddPhone
		)
	end

	local function fn6()
		v3.authEventAnalytics.reportInteractWithActionAndSection(
			v3.eventContext,
			EventStreamConstants.Field.PhoneNumber,
			EventStreamConstants.ActionType.Focus,
			v3.origin,
			"",
			PhoneVerificationUpsellState.AddPhone
		)

		if not v3.shouldAutofillAndroidPhoneNumberAtLaunch then
			fn2() -- inferred equivalent call
		end
	end

	local v6 = debounce(function(p2)
		setState6(p2)
	end, 0.5)

	local function fn7(p2)
		local v7 = string.sub(p2.Text, 1, 6)

		if v7 ~= state5 then
			setState8("")
		end

		setState5(v7)
		v6(v7)
	end

	local function fn8()
		v3.authEventAnalytics.reportInteractWithActionAndSection(
			v3.eventContext,
			EventStreamConstants.Field.VerificationCode,
			EventStreamConstants.ActionType.Focus,
			v3.origin,
			"",
			PhoneVerificationUpsellState.VerifyPhone
		)
	end

	React.useEffect(function()
		if string.len(state6) == 6 then
			handleVerifyPhone()
		end
	end, { state6 })

	React.useEffect(function()
		if state10 then
			v3.setIsPhoneVerified({ isPhoneVerified = true })
			v3.authEventAnalytics.reportModalShownWithSection(
				v3.eventContext,
				v3.origin,
				PhoneVerificationUpsellState.Success
			)

			v3.onSuccess()
		end
	end, { state10 })

	local element = React.createElement(Loading, {
		size = IconSize.Large,
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5)
	})

	local createElement = React.createElement
	local v7 = GetFFlagPhoneUseParentSizeForScreenSize() and "Frame" or React.Fragment
	local v8

	if GetFFlagPhoneUseParentSizeForScreenSize() then
		v8 = {
			["BackgroundTransparency"] = nil,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0)
		}
		v8[Roact.Change.AbsoluteSize] = function(p2)
			setState13(p2.AbsoluteSize)
		end
	end

	local entry

	if state == PhoneVerificationUpsellState.Entry then
		entry = v3.entryConfig

		if entry then
			local createElement2 = React.createElement
			local screenSize2

			if GetFFlagPhoneUseParentSizeForScreenSize() then
				screenSize2 = state14
			else
				screenSize2 = screenSize
			end

			entry = createElement2(EntryView, {
				screenSize = screenSize2,
				onClose = handleCloseClick,
				titleKey = v3.entryConfig.titleKey,
				descriptionKey = v3.entryConfig.descriptionKey,
				buttonKey = v3.entryConfig.buttonKey,
				onButtonClick = proceedToAddPhone,
				extraButtonKey = v3.entryConfig.extraButtonConfig.extraButtonKey,
				onExtraButtonClick = v3.entryConfig.extraButtonConfig.onExtraButtonClick
			})
		end
	else
		entry = false
	end

	local addPhone

	if state == PhoneVerificationUpsellState.AddPhone then
		local createElement2 = React.createElement
		local screenSize2

		if GetFFlagPhoneUseParentSizeForScreenSize() then
			screenSize2 = state14
		else
			screenSize2 = screenSize
		end

		addPhone = createElement2(AddPhoneView, {
			screenSize = screenSize2,
			countryCode = state3,
			setCountryCode = setState3,
			phoneNumber = state2,
			errorMessage = state7,
			isDisabled = state11,
			onPhoneNumberTextChange = fn4,
			onSetPhoneNumber = handleSetPhone,
			onClose = handleCloseClick,
			onTermsOfUseClick = navigateToSMSTerms,
			onPrivacyPolicyClick = navigateToPrivacy,
			onPhoneInputFocus = fn6,
			onCountryCodeSelectorClick = fn5,
			isKeyboardShowing = state12,
			keyboardHeight = state13,
			usePhoneNumberTextType = GetFFlagLuaUsePhoneNumberTextTypeForPhoneUpsell() and v3.isPhoneNumberTextTypeEnabled,
			titleKey = v3.addPhoneTitleKey,
			descriptionKey = v3.addPhoneDescriptionKey,
			buttonKey = v3.addPhoneButtonKey,
			legalTextKey = v3.addPhoneLegalTextKey,
			extraButtonKey = v3.extraButtonTextKey,
			onExtraButtonClick = v3.onExtraButtonClick,
			alwaysShowLegalText = v3.alwaysShowAddPhoneLegalText,
			requireLegalTextCheckbox = v3.requireAddPhoneLegalTextCheckbox
		})
	else
		addPhone = false
	end

	local verifyPhone

	if state == PhoneVerificationUpsellState.VerifyPhone then
		local createElement2 = React.createElement

		if GetFFlagPhoneUseParentSizeForScreenSize() then
			screenSize = state14
		end

		verifyPhone = createElement2(VerifyPhoneView, {
			screenSize = screenSize,
			phoneNumber = state2,
			prefix = state3.prefix,
			code = state5,
			errorMessage = state8,
			onCodeTextChange = fn7,
			onResendPhoneCode = handleResendCode,
			onClose = handleCloseClick,
			returnToAddPhone = returnToAddPhone,
			onCodeInputFocus = fn8,
			isKeyboardShowing = state12,
			keyboardHeight = state13,
			useOTPInputType = v3.isOTPInputTypeEnabled,
			extraButtonKey = v3.verifyPhoneExtraButtonKey,
			onExtraButtonClick = v3.onVerifyPhoneExtraButtonClick
		})
	else
		verifyPhone = false
	end

	return createElement(v7, v8, {
		Entry = entry,
		AddPhone = addPhone,
		VerifyPhone = verifyPhone,
		LoadingOverlay = state9 and React.createElement(PhoneVerificationStatusOverlay, {
			image = element,
			text = v5.verifyingKey
		})
	})
end

local v3 = RoactRodux.connect(not FFlagUseSignalsForCountryCodeList and function(p, _)
	return { countryCodeList = p.CountryCodeList }
end or nil, function(callback)
	return {
		setPhoneNumber = function(p, p2, p3, p4)
			return callback(SetPhoneNumber(p, p2, p3, p4, nil))
		end,
		verifyPhoneCode = function(p, p2)
			return callback(VerifyPhoneCode(p, p2))
		end,
		resendPhoneCode = function(p)
			return callback(ResendPhoneCode(p))
		end,
		setIsPhoneVerified = function(p)
			return callback(SetIsPhoneVerified(p))
		end
	}
end)(PhoneVerificationUpsellOverlay)
local v4

if FFlagUseSignalsForCountryCodeList then
	v4 = React.memo(function(p)
		local countryCodeList = useSignalState(GetCountryCodeListStore(false).getCountryCodeList)
		return React.createElement(v3, Cryo.Dictionary.union(p, {
			countryCodeList = countryCodeList
		}))
	end)
else
	v4 = v3
end

local v5 = roactServices.connect({
	networking = RoactNetworking,
	authEventAnalytics = RoactAnalyticsAuthEvents
})(v4)

return (RoactAppExperiment.connectUserLayer(
	{ GetFStringAndroidPhoneVerificationLayer(), GetFStringIOSPhoneVerificationLayer() },
	function(p, _)
		local v6 = p[GetFStringAndroidPhoneVerificationLayer()] or {}
		local v7 = p[GetFStringIOSPhoneVerificationLayer()] or {}
		return {
			isAutofillPhoneNumberEnabled = v6.IsAutofillPhoneNumberEnabled,
			isAutofillSMSOtpEnabled = v6.IsAutofillSMSOtpEnabled,
			isOTPInputTypeEnabled = v7.IsAutofillSMSOtpEnabled,
			isPhoneNumberTextTypeEnabled = v7.IsAutofillPhoneNumberEnabled
		}
	end
)(v5))
