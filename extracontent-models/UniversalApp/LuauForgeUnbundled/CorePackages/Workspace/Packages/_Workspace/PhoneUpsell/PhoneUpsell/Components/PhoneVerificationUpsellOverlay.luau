local UserInputService = game:GetService("UserInputService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/React")
local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Roact")
local RoactRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/RoactRodux")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Cryo")
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/RoactUtils").Hooks.RoactRodux.useSelector
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/SignalsReact").useSignalState
local fFlagUseSignalsForCountryCodeList = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/SharedFlags").FFlagUseSignalsForCountryCodeList
local getCountryCodeListStore = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/AuthCommon").Stores.GetCountryCodeListStore

require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/LuauPolyfill")
local roactNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/RoactServiceTags").RoactNetworking
local roactServices = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/RoactServices").RoactServices
local EventStreamConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/DuplicateAnalytics/EventStreamConstants")
local RoactAnalyticsAuthEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/DuplicateAnalytics/RoactAnalyticsAuthEvents")
local debounce = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Utils/debounce")
local mergeProps = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Utils/mergeProps")

local PhoneVerificationUpsellState = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Components/PhoneVerificationUpsellState")
local EntryView = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Components/EntryView")
local AddPhoneView = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Components/AddPhoneView")
local VerifyPhoneView = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Components/VerifyPhoneView")
local PhoneVerificationStatusOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Components/PhoneVerificationStatusOverlay")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Foundation")
local iconSize = Foundation.Enums.IconSize
local loading = Foundation.Loading

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Localization").Hooks.useLocalization

local SetPhoneNumber = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Thunks/SetPhoneNumber")
local ResendPhoneCode = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Thunks/ResendPhoneCode")
local VerifyPhoneCode = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Thunks/VerifyPhoneCode")
local setIsPhoneVerified = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/ContactImporter").Actions.SetIsPhoneVerified

local GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Utils/GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix")

local RoactAppExperiment = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/RoactAppExperiment")
local getFStringAndroidPhoneVerificationLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/SharedFlags").GetFStringAndroidPhoneVerificationLayer
local getFStringIOSPhoneVerificationLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/SharedFlags").GetFStringIOSPhoneVerificationLayer

local GetFFlagLuaUsePhoneNumberTextTypeForPhoneUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Flags/GetFFlagLuaUsePhoneNumberTextTypeForPhoneUpsell")
local GetFFlagPhoneUseParentSizeForScreenSize = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Flags/GetFFlagPhoneUseParentSizeForScreenSize")

local identityProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/IdentityProtocol").IdentityProtocol

local v5 = {
	name = "United States",
	code = "US",
	prefix = "1",
	localizedName = "United States"
}

local function fn() end

local v6 = {
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
	showWebpage = function(p2) end
}

local function PhoneVerificationUpsellOverlay(p2)
	local v7 = mergeProps(v6, p2)
	local useState = React.useState
	local v8 = if v7.entryConfig then PhoneVerificationUpsellState.Entry else PhoneVerificationUpsellState.AddPhone
	local state, setState = useState(v8)

	local state2, setState2 = React.useState("")
	local state3, setState3 = React.useState(v5)
	local state4, setState4 = React.useState(false)
	local state5, setState5 = React.useState("")
	local state6, setState6 = React.useState("")
	local state7, setState7 = React.useState("")
	local state8, setState8 = React.useState("")
	local state9, setState9 = React.useState(false)
	local state10, setState10 = React.useState(false)
	local state11, setState11 = React.useState(false)
	local state12, setState12 = React.useState(false)
	local state13, setState13 = React.useState(0)
	local state14, setState14 = React.useState(Vector2.new(400, 400))
	local ref = React.useRef(false)

	local v9 = useLocalization({
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
		if not state4 and v7.countryCodeList and #v7.countryCodeList > 0 then
			for k, countryCode in v7.countryCodeList do
				if countryCode.isDefault then
					setState3(countryCode)
				end
			end

			setState4(true)
		end
	end, { v7.countryCodeList, state4 })

	React.useEffect(function()
		return function()
			ref.current = state10
		end
	end, { state10 })

	React.useEffect(function()
		onScreenKeyboardVisibleChangedConnection = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(function()
			setState12(UserInputService.OnScreenKeyboardVisible)
			setState13(UserInputService.OnScreenKeyboardVisible and UserInputService.OnScreenKeyboardSize.Y or 0)
		end)
		v7.authEventAnalytics.reportModalShownWithSection(v7.eventContext, v7.origin, PhoneVerificationUpsellState.AddPhone)

		if v7.isAutofillPhoneNumberEnabled then
			local default = identityProtocol.default
			default:supportsGetPhoneNumber():andThen(function(p3)
				print("PhoneVerification: Autofill phone number supported: {}!", p3)

				if not p3 then
					return
				end

				v7.authEventAnalytics.reportModalActionWithSection(
					v7.eventContext,
					"phoneAutofillEligible",
					"autofill",
					v7.origin,
					state
				)

				local phoneNumber = default:getPhoneNumber()

				if not phoneNumber then
					return
				end

				phoneNumber:andThen(function(p4)
					if not p4 or p4 == "" then
						v7.authEventAnalytics.reportModalActionWithSection(
							v7.eventContext,
							"phoneAutofillNull",
							"autofill",
							v7.origin,
							state
						)

						return
					end

					local v10, v11 = GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix(p4, state3.prefix)

					if v10 == v5.prefix then
						v7.authEventAnalytics.reportModalActionWithSection(
							v7.eventContext,
							"phoneAutofillUSFound",
							"autofill",
							v7.origin,
							state
						)
					end

					setState2(v11)

					v7.authEventAnalytics.reportModalActionWithSection(
						v7.eventContext,
						"phoneAutofillSuccess",
						"autofill",
						v7.origin,
						state
					)
				end)
			end)
		end

		return function()
			if onScreenKeyboardVisibleChangedConnection then
				onScreenKeyboardVisibleChangedConnection:Disconnect()
			end

			onScreenKeyboardVisibleChangedConnection = nil

			if not ref.current then
				v7.onCancelled()
			end
		end
	end, {})

	local v10 = useSelector(function(p3)
		return p3.ScreenSize
	end)

	local function handleCloseClick()
		v7.authEventAnalytics.reportModalDismissedWithSection(v7.eventContext, v7.origin, state)

		v7.closeUpsell()
	end

	local function handlePhoneErrors(p3)
		if p3 == 2 then
			return v9.invalidPhoneFormatKey
		elseif p3 == 6 then
			return v9.tooManyAttemptsKey
		elseif p3 == 7 then
			return v9.invalidVerificationCodeKey
		elseif p3 == 8 then
			return v9.invalidPhoneNumberKey
		elseif p3 == 9 then
			return v9.tooManyAccountsKey
		end

		return v9.genericErrorKey
	end

	local function handleSetPhone()
		setState11(true)
		local v11 = v7.setPhoneNumber(v7.networking, state3.code, state3.prefix, state2)

		if v11 then
			v11:andThen(function()
				setState(PhoneVerificationUpsellState.VerifyPhone)
				setState11(false)
				v7.authEventAnalytics.reportModalShownWithSection(
					v7.eventContext,
					v7.origin,
					PhoneVerificationUpsellState.VerifyPhone
				)

				if v7.isAutofillSMSOtpEnabled then
					local default = identityProtocol.default
					default:supportsGetSMSOTP():andThen(function(p3)
						print("PhoneVerification: Autofill OTP supported: {}!", p3)

						if p3 then
							v7.authEventAnalytics.reportModalActionWithSection(
								v7.eventContext,
								"codeAutofillEligible",
								"autofill",
								v7.origin,
								state
							)

							local smsotp = default:getSMSOTP()

							if smsotp then
								smsotp:andThen(function(p4)
									if p4 and p4 ~= "" then
										setState5(p4)
										setState6(p4)
										v7.authEventAnalytics.reportModalActionWithSection(
											v7.eventContext,
											"codeAutofillSuccess",
											"autofill",
											v7.origin,
											state
										)
									end
								end)
							end
						end
					end)
				end
			end):catch(function(p3)
				if p3 then
					if p3.PhoneRegexFailed then
						v7.authEventAnalytics.reportModalShownWithSectionAndError(
							v7.eventContext,
							EventStreamConstants.Field.ErrorMessage,
							v7.origin,
							PhoneVerificationUpsellState.AddPhone,
							""
						)

						setState7(v9.invalidPhoneFormatKey)
					else
						v7.authEventAnalytics.reportModalShownWithSectionAndError(
							v7.eventContext,
							EventStreamConstants.Field.ErrorMessage,
							v7.origin,
							PhoneVerificationUpsellState.AddPhone,
							p3.ErrorCode
						)

						local errorCode = p3.ErrorCode
						local v13

						if errorCode == 2 then
							v13 = v9.invalidPhoneFormatKey
						elseif errorCode == 6 then
							v13 = v9.tooManyAttemptsKey
						elseif errorCode == 7 then
							v13 = v9.invalidVerificationCodeKey
						elseif errorCode == 8 then
							v13 = v9.invalidPhoneNumberKey
						else
							v13 = if errorCode == 9 then v9.tooManyAccountsKey else v9.genericErrorKey
						end

						setState7(v13)
					end
				else
					v7.authEventAnalytics.reportModalShownWithSectionAndError(
						v7.eventContext,
						EventStreamConstants.Field.ErrorMessage,
						v7.origin,
						PhoneVerificationUpsellState.AddPhone,
						""
					)

					setState7(v9.genericErrorKey)
				end

				setState11(false)
			end)
		end

		v7.authEventAnalytics.reportInteractWithActionAndSection(
			v7.eventContext,
			"",
			"",
			v7.origin,
			EventStreamConstants.Button.Continue,
			PhoneVerificationUpsellState.AddPhone
		)
	end

	local function handleVerifyPhone()
		setState11(true)
		local v11 = v7.verifyPhoneCode(v7.networking, state6)

		if v11 then
			v11:andThen(function()
				setState10(true)
			end):catch(function(p3)
				if p3 then
					v7.authEventAnalytics.reportModalShownWithSectionAndError(
						v7.eventContext,
						EventStreamConstants.Field.ErrorMessage,
						v7.origin,
						PhoneVerificationUpsellState.VerifyPhone,
						p3.ErrorCode
					)

					local errorCode = p3.ErrorCode
					local v13

					if errorCode == 2 then
						v13 = v9.invalidPhoneFormatKey
					elseif errorCode == 6 then
						v13 = v9.tooManyAttemptsKey
					elseif errorCode == 7 then
						v13 = v9.invalidVerificationCodeKey
					elseif errorCode == 8 then
						v13 = v9.invalidPhoneNumberKey
					else
						v13 = if errorCode == 9 then v9.tooManyAccountsKey else v9.genericErrorKey
					end

					setState8(v13)
				else
					v7.authEventAnalytics.reportModalShownWithSectionAndError(
						v7.eventContext,
						EventStreamConstants.Field.ErrorMessage,
						v7.origin,
						PhoneVerificationUpsellState.VerifyPhone,
						""
					)

					setState8(v9.genericErrorKey)
				end

				setState11(false)
			end)
		end

		v7.authEventAnalytics.reportInteractWithActionAndSection(
			v7.eventContext,
			"",
			"",
			v7.origin,
			EventStreamConstants.Button.AutoSubmit,
			PhoneVerificationUpsellState.VerifyPhone
		)
	end

	local function handleResendCode()
		local resendPhoneCode = v7.resendPhoneCode(v7.networking)

		if resendPhoneCode then
			resendPhoneCode:andThen(function() end):catch(function(p3)
				if p3 then
					v7.authEventAnalytics.reportModalShownWithSectionAndError(
						v7.eventContext,
						EventStreamConstants.Field.ErrorMessage,
						v7.origin,
						PhoneVerificationUpsellState.VerifyPhone,
						p3.ErrorCode
					)

					local errorCode = p3.ErrorCode
					local v12

					if errorCode == 2 then
						v12 = v9.invalidPhoneFormatKey
					elseif errorCode == 6 then
						v12 = v9.tooManyAttemptsKey
					elseif errorCode == 7 then
						v12 = v9.invalidVerificationCodeKey
					elseif errorCode == 8 then
						v12 = v9.invalidPhoneNumberKey
					else
						v12 = if errorCode == 9 then v9.tooManyAccountsKey else v9.genericErrorKey
					end

					setState8(v12)
				else
					v7.authEventAnalytics.reportModalShownWithSectionAndError(
						v7.eventContext,
						EventStreamConstants.Field.ErrorMessage,
						v7.origin,
						PhoneVerificationUpsellState.VerifyPhone,
						""
					)

					setState8(v9.genericErrorKey)
				end
			end)
		end

		v7.authEventAnalytics.reportInteractWithActionAndSection(
			v7.eventContext,
			"",
			"",
			v7.origin,
			EventStreamConstants.Button.ResendCode,
			PhoneVerificationUpsellState.VerifyPhone
		)
	end

	local function returnToAddPhone()
		setState(PhoneVerificationUpsellState.AddPhone)
		v7.authEventAnalytics.reportInteractWithActionAndSection(
			v7.eventContext,
			"",
			"",
			v7.origin,
			EventStreamConstants.Button.ChangePhoneNumber,
			PhoneVerificationUpsellState.VerifyPhone
		)
	end

	local function proceedToAddPhone()
		setState(PhoneVerificationUpsellState.AddPhone)
		v7.authEventAnalytics.reportInteractWithActionAndSection(
			v7.eventContext,
			"",
			"",
			v7.origin,
			EventStreamConstants.Button.Continue,
			PhoneVerificationUpsellState.Entry
		)
	end

	local function navigateToSMSTerms()
		if not state11 then
			v7.authEventAnalytics.reportModalActionWithSection(
				v7.eventContext,
				EventStreamConstants.Field.TermsOfService,
				"",
				v7.origin,
				state
			)

			v7.showWebpage("https://en.help.roblox.com/hc/articles/9483830673556-Roblox-SMS-Terms-of-Service")
		end
	end

	local function navigateToPrivacy()
		if not state11 then
			v7.authEventAnalytics.reportModalActionWithSection(
				v7.eventContext,
				EventStreamConstants.Field.PrivacyPolicy,
				"",
				v7.origin,
				state
			)

			v7.showWebpage("https://en.help.roblox.com/hc/articles/115004630823")
		end
	end

	local function fn2(p3)
		if not state11 then
			setState7("")
			setState2(p3.Text)
		end
	end

	local function fn3()
		v7.authEventAnalytics.reportInteractWithActionAndSection(
			v7.eventContext,
			EventStreamConstants.Field.CountryPrefix,
			EventStreamConstants.ActionType.Focus,
			v7.origin,
			"",
			PhoneVerificationUpsellState.AddPhone
		)
	end

	local function fn4()
		v7.authEventAnalytics.reportInteractWithActionAndSection(
			v7.eventContext,
			EventStreamConstants.Field.PhoneNumber,
			EventStreamConstants.ActionType.Focus,
			v7.origin,
			"",
			PhoneVerificationUpsellState.AddPhone
		)

		if not v7.shouldAutofillAndroidPhoneNumberAtLaunch then
			local default = identityProtocol.default
			default:supportsGetPhoneNumber():andThen(function(p3)
				print("PhoneVerification: Autofill phone number supported: {}!", p3)

				if not p3 then
					return
				end

				v7.authEventAnalytics.reportModalActionWithSection(
					v7.eventContext,
					"phoneAutofillEligible",
					"autofill",
					v7.origin,
					state
				)

				local phoneNumber = default:getPhoneNumber()

				if not phoneNumber then
					return
				end

				phoneNumber:andThen(function(p4)
					if not p4 or p4 == "" then
						v7.authEventAnalytics.reportModalActionWithSection(
							v7.eventContext,
							"phoneAutofillNull",
							"autofill",
							v7.origin,
							state
						)

						return
					end

					local v11, v12 = GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix(p4, state3.prefix)

					if v11 == v5.prefix then
						v7.authEventAnalytics.reportModalActionWithSection(
							v7.eventContext,
							"phoneAutofillUSFound",
							"autofill",
							v7.origin,
							state
						)
					end

					setState2(v12)

					v7.authEventAnalytics.reportModalActionWithSection(
						v7.eventContext,
						"phoneAutofillSuccess",
						"autofill",
						v7.origin,
						state
					)
				end)
			end)
		end
	end

	local v11 = debounce(function(p3)
		setState6(p3)
	end, 0.5)

	local function fn5(p3)
		local v12 = string.sub(p3.Text, 1, 6)

		if v12 ~= state5 then
			setState8("")
		end

		setState5(v12)
		v11(v12)
	end

	local function fn6()
		v7.authEventAnalytics.reportInteractWithActionAndSection(
			v7.eventContext,
			EventStreamConstants.Field.VerificationCode,
			EventStreamConstants.ActionType.Focus,
			v7.origin,
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
			v7.setIsPhoneVerified({ isPhoneVerified = true })
			v7.authEventAnalytics.reportModalShownWithSection(v7.eventContext, v7.origin, PhoneVerificationUpsellState.Success)

			v7.onSuccess()
		end
	end, { state10 })

	local element = React.createElement(loading, {
		size = iconSize.Large,
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5)
	})

	local createElement = React.createElement
	local v12 = GetFFlagPhoneUseParentSizeForScreenSize() and "Frame" or React.Fragment
	local v13

	if GetFFlagPhoneUseParentSizeForScreenSize() then
		v13 = {
			["BackgroundTransparency"] = nil,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0)
		}
		v13[Roact.Change.AbsoluteSize] = function(p3)
			setState14(p3.AbsoluteSize)
		end
	end

	local v15

	if state == PhoneVerificationUpsellState.Entry then
		v15 = v7.entryConfig

		if v15 then
			local createElement2 = React.createElement
			local v18 = if GetFFlagPhoneUseParentSizeForScreenSize() then state14 else v10
			v15 = createElement2(EntryView, {
				screenSize = v18,
				onClose = handleCloseClick,
				titleKey = v7.entryConfig.titleKey,
				descriptionKey = v7.entryConfig.descriptionKey,
				buttonKey = v7.entryConfig.buttonKey,
				onButtonClick = proceedToAddPhone,
				extraButtonKey = v7.entryConfig.extraButtonConfig.extraButtonKey,
				onExtraButtonClick = v7.entryConfig.extraButtonConfig.onExtraButtonClick
			})
		end
	else
		v15 = false
	end

	local v16

	if state == PhoneVerificationUpsellState.AddPhone then
		local createElement2 = React.createElement
		local v19 = if GetFFlagPhoneUseParentSizeForScreenSize() then state14 else v10
		v16 = createElement2(AddPhoneView, {
			screenSize = v19,
			countryCode = state3,
			setCountryCode = setState3,
			phoneNumber = state2,
			errorMessage = state7,
			isDisabled = state11,
			onPhoneNumberTextChange = fn2,
			onSetPhoneNumber = handleSetPhone,
			onClose = handleCloseClick,
			onTermsOfUseClick = navigateToSMSTerms,
			onPrivacyPolicyClick = navigateToPrivacy,
			onPhoneInputFocus = fn4,
			onCountryCodeSelectorClick = fn3,
			isKeyboardShowing = state12,
			keyboardHeight = state13,
			usePhoneNumberTextType = GetFFlagLuaUsePhoneNumberTextTypeForPhoneUpsell() and v7.isPhoneNumberTextTypeEnabled,
			titleKey = v7.addPhoneTitleKey,
			descriptionKey = v7.addPhoneDescriptionKey,
			buttonKey = v7.addPhoneButtonKey,
			legalTextKey = v7.addPhoneLegalTextKey,
			extraButtonKey = v7.extraButtonTextKey,
			onExtraButtonClick = v7.onExtraButtonClick,
			alwaysShowLegalText = v7.alwaysShowAddPhoneLegalText,
			requireLegalTextCheckbox = v7.requireAddPhoneLegalTextCheckbox
		})
	else
		v16 = false
	end

	local v17

	if state == PhoneVerificationUpsellState.VerifyPhone then
		local createElement2 = React.createElement

		if GetFFlagPhoneUseParentSizeForScreenSize() then
			v10 = state14
		end

		v17 = createElement2(VerifyPhoneView, {
			screenSize = v10,
			phoneNumber = state2,
			prefix = state3.prefix,
			code = state5,
			errorMessage = state8,
			onCodeTextChange = fn5,
			onResendPhoneCode = handleResendCode,
			onClose = handleCloseClick,
			returnToAddPhone = returnToAddPhone,
			onCodeInputFocus = fn6,
			isKeyboardShowing = state12,
			keyboardHeight = state13,
			useOTPInputType = v7.isOTPInputTypeEnabled,
			extraButtonKey = v7.verifyPhoneExtraButtonKey,
			onExtraButtonClick = v7.onVerifyPhoneExtraButtonClick
		})
	else
		v17 = false
	end

	return createElement(v12, v13, {
		Entry = v15,
		AddPhone = v16,
		VerifyPhone = v17,
		LoadingOverlay = state9 and React.createElement(PhoneVerificationStatusOverlay, {
			image = element,
			text = v9.verifyingKey
		})
	})
end

local v7 = RoactRodux.connect(not fFlagUseSignalsForCountryCodeList and function(p2, p3)
	return { countryCodeList = p2.CountryCodeList }
end or nil, function(callback)
	return {
		setPhoneNumber = function(p2, p3, p4, p5)
			return callback(SetPhoneNumber(p2, p3, p4, p5, nil))
		end,
		verifyPhoneCode = function(p2, p3)
			return callback(ResendPhoneCode(p2, p3))
		end,
		resendPhoneCode = function(p2)
			return callback(VerifyPhoneCode(p2))
		end,
		setIsPhoneVerified = function(p2)
			return callback(setIsPhoneVerified(p2))
		end
	}
end)(PhoneVerificationUpsellOverlay)
local v8

if fFlagUseSignalsForCountryCodeList then
	v8 = React.memo(function(p2)
		local v9 = useSignalState(getCountryCodeListStore(false).getCountryCodeList)
		return React.createElement(v7, Cryo.Dictionary.union(p2, {
			countryCodeList = v9
		}))
	end)
else
	v8 = v7
end

local v9 = roactServices.connect({
	networking = roactNetworking,
	authEventAnalytics = RoactAnalyticsAuthEvents
})(v8)

return (RoactAppExperiment.connectUserLayer(
	{ getFStringAndroidPhoneVerificationLayer(), getFStringIOSPhoneVerificationLayer() },
	function(p2, p3)
		local v10 = p2[getFStringAndroidPhoneVerificationLayer()] or {}
		local v11 = p2[getFStringIOSPhoneVerificationLayer()] or {}
		return {
			isAutofillPhoneNumberEnabled = v10.IsAutofillPhoneNumberEnabled,
			isAutofillSMSOtpEnabled = v10.IsAutofillSMSOtpEnabled,
			isOTPInputTypeEnabled = v11.IsAutofillSMSOtpEnabled,
			isPhoneNumberTextTypeEnabled = v11.IsAutofillPhoneNumberEnabled
		}
	end
)(v9))
