local PhoneUpsell = script:FindFirstAncestor("PhoneUpsell")
local PhoneUpsellParent = PhoneUpsell.Parent
local UserInputService = game:GetService("UserInputService")
local React = require(PhoneUpsellParent.React)
local Roact = require(PhoneUpsellParent.Roact)
local RoactRodux = require(PhoneUpsellParent.RoactRodux)
local useSelector = require(PhoneUpsellParent.RoactUtils).Hooks.RoactRodux.useSelector

require(PhoneUpsellParent.LuauPolyfill)

local RoactNetworking = require(PhoneUpsellParent.RoactServiceTags).RoactNetworking
local RoactServices = require(PhoneUpsellParent.RoactServices).RoactServices
local EventStreamConstants = require(PhoneUpsell.DuplicateAnalytics.EventStreamConstants)
local RoactAnalyticsAuthEvents = require(PhoneUpsell.DuplicateAnalytics.RoactAnalyticsAuthEvents)
local debounce = require(PhoneUpsell.Utils.debounce)
local mergeProps = require(PhoneUpsell.Utils.mergeProps)
local PhoneVerificationUpsellState = require(PhoneUpsell.Components.PhoneVerificationUpsellState)
local EntryView = require(PhoneUpsell.Components.EntryView)
local AddPhoneView = require(PhoneUpsell.Components.AddPhoneView)
local VerifyPhoneView = require(PhoneUpsell.Components.VerifyPhoneView)
local PhoneVerificationStatusOverlay = require(PhoneUpsell.Components.PhoneVerificationStatusOverlay)
local Foundation = require(PhoneUpsellParent.Foundation)
local IconSize = Foundation.Enums.IconSize
local Loading = Foundation.Loading
local useLocalization = require(PhoneUpsellParent.Localization).Hooks.useLocalization
local SetPhoneNumber = require(PhoneUpsell.Thunks.SetPhoneNumber)
local VerifyPhoneCode = require(PhoneUpsell.Thunks.VerifyPhoneCode)
local ResendPhoneCode = require(PhoneUpsell.Thunks.ResendPhoneCode)
local SetIsPhoneVerified = require(PhoneUpsellParent.ContactImporter).Actions.SetIsPhoneVerified
local GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix = require(PhoneUpsell.Utils.GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix)
local RoactAppExperiment = require(PhoneUpsellParent.RoactAppExperiment)
local GetFStringAndroidPhoneVerificationLayer = require(PhoneUpsellParent.SharedFlags).GetFStringAndroidPhoneVerificationLayer
local GetFStringIOSPhoneVerificationLayer = require(PhoneUpsellParent.SharedFlags).GetFStringIOSPhoneVerificationLayer
local GetFFlagLuaUsePhoneNumberTextTypeForPhoneUpsell = require(PhoneUpsell.Flags.GetFFlagLuaUsePhoneNumberTextTypeForPhoneUpsell)
local GetFFlagPhoneUseParentSizeForScreenSize = require(PhoneUpsell.Flags.GetFFlagPhoneUseParentSizeForScreenSize)
local FFlagPhoneUpsellEnforceCodeInputLimit = require(PhoneUpsellParent.SharedFlags).FFlagPhoneUpsellEnforceCodeInputLimit
local IdentityProtocol = require(PhoneUpsellParent.IdentityProtocol).IdentityProtocol
local t1 = {
	name = "United States",
	code = "US",
	prefix = "1",
	localizedName = "United States"
}

local function v36() -- line: 143
end

local t2 = {
	origin = "",
	eventContext = "",
	addPhoneTitleKey = "Feature.VerificationUpsell.Action.AddPhone",
	addPhoneDescriptionKey = "Feature.VerificationUpsell.Description.VerificationCodeSmsFeesMayApply",
	extraButtonTextKey = "",
	shouldAutofillAndroidPhoneNumberAtLaunch = false,
	isOTPInputTypeEnabled = false,
	isPhoneNumberTextTypeEnabled = false,
	alwaysShowAddPhoneLegalText = false,
	requireAddPhoneLegalTextCheckbox = false,
	onSuccess = v36,
	onFailure = v36,
	onCancelled = v36,
	onExtraButtonClick = v36,
	closeUpsell = v36,
	showWebpage = function(_) -- line: 161
	end
}

local function PhoneVerificationUpsellOverlay(t3: {[any]: any}) -- line: 164
	-- upvalues: mergeProps (copy), t2 (copy), React (copy), PhoneVerificationUpsellState (copy), t1 (copy), useLocalization (copy), IdentityProtocol (copy), GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix (copy), UserInputService (copy), useSelector (copy), EventStreamConstants (copy), debounce (copy), FFlagPhoneUpsellEnforceCodeInputLimit (copy), Loading (copy), IconSize (copy), GetFFlagPhoneUseParentSizeForScreenSize (copy), Roact (copy), EntryView (copy), AddPhoneView (copy), GetFFlagLuaUsePhoneNumberTextTypeForPhoneUpsell (copy), VerifyPhoneView (copy), PhoneVerificationStatusOverlay (copy)
	local v43 = mergeProps(t2, t3)
	local v44, v45 = React.useState(if not v43.entryConfig then PhoneVerificationUpsellState.AddPhone else PhoneVerificationUpsellState.Entry)
	local v46, v47 = React.useState("")
	local v48, v49 = React.useState(t1)
	local v50, v51 = React.useState(false)
	local v52, v53 = React.useState("")
	local v54, v55 = React.useState("")
	local v56, v57 = React.useState("")
	local v58, v59 = React.useState("")
	local v60, _ = React.useState(false)
	local v62, v63 = React.useState(false)
	local v64, v65 = React.useState(false)
	local v66, v67 = React.useState(false)
	local v68, v69 = React.useState(0)
	local v70, v71 = React.useState(Vector2.new(400, 400))
	local v72 = React.useRef(false)
	local v73 = useLocalization({
		verifyingKey = "Feature.VerificationUpsell.Label.Verifying",
		invalidPhoneFormatKey = "Feature.VerificationUpsell.Response.ErrorPhoneFormatInvalid",
		invalidPhoneNumberKey = "Feature.VerificationUpsell.Response.InvalidPhoneNumberError",
		invalidVerificationCodeKey = "Feature.VerificationUpsell.Message.InvalidSmsCode",
		tooManyAccountsKey = "Feature.VerificationUpsell.Response.PhoneHasTooManyAssociatedAccounts",
		tooManyAttemptsKey = "Feature.VerificationUpsell.Response.TooManyAttemptsTryAgainLater",
		genericErrorKey = "Feature.VerificationUpsell.Response.ErrorTryAgain"
	})
	local connection = nil

	React.useEffect(function() -- line: 197
		-- upvalues: v50 (copy), v43 (copy), v49 (copy), v51 (copy)
		if not v50 and (v43.countryCodeList and #v43.countryCodeList > 0) then
			for _, v94 in v43.countryCodeList do
				if v94.isDefault then
					v49(v94)
				end
			end

			v51(true)
		end
	end, {
		v43.countryCodeList,
		v50
	})
	React.useEffect(function() -- line: 295
		-- upvalues: v72 (copy), v62 (copy)
		return function() -- line: 296
			-- upvalues: v72 (copy), v62 (copy)
			v72.current = v62
		end
	end, { v62 })
	React.useEffect(function() -- line: 301
		-- upvalues: connection (ref), UserInputService (copy), v67 (copy), v69 (copy), v43 (copy), PhoneVerificationUpsellState (copy), IdentityProtocol (copy), v44 (copy), GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix (copy), v48 (copy), t1 (copy), v47 (copy), v72 (copy)
		connection = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(function() -- line: 303
			-- upvalues: v67 (copy), UserInputService (copy), v69 (copy)
			v67(UserInputService.OnScreenKeyboardVisible)
			v69(UserInputService.OnScreenKeyboardVisible and UserInputService.OnScreenKeyboardSize.Y or 0)
		end)
		v43.authEventAnalytics.reportModalShownWithSection(v43.eventContext, v43.origin, PhoneVerificationUpsellState.AddPhone)

		if v43.isAutofillPhoneNumberEnabled then
			local default = IdentityProtocol.default

			default:supportsGetPhoneNumber():andThen(function(b1: boolean?) -- line: 211
				-- upvalues: v43 (copy), v44 (copy), default (copy), GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix (copy), v48 (copy), t1 (copy), v47 (copy)
				print("PhoneVerification: Autofill phone number supported: {}!", b1)

				if not b1 then
					return
				end

				v43.authEventAnalytics.reportModalActionWithSection(v43.eventContext, "phoneAutofillEligible", "autofill", v43.origin, v44)

				local v122 = default:getPhoneNumber()

				if not v122 then
					return
				end

				v122:andThen(function(s1: string?) -- line: 227
					-- upvalues: GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix (copy), v48 (copy), t1 (copy), v43 (copy), v44 (copy), v47 (copy)
					if s1 and s1 ~= "" then
						local v140, v141 = GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix(s1, v48.prefix)

						if v140 == t1.prefix then
							v43.authEventAnalytics.reportModalActionWithSection(v43.eventContext, "phoneAutofillUSFound", "autofill", v43.origin, v44)
						end

						v47(v141)
						v43.authEventAnalytics.reportModalActionWithSection(v43.eventContext, "phoneAutofillSuccess", "autofill", v43.origin, v44)

						return
					end

					v43.authEventAnalytics.reportModalActionWithSection(v43.eventContext, "phoneAutofillNull", "autofill", v43.origin, v44)
				end)
			end)
		end

		return function() -- line: 318
			-- upvalues: connection (ref), v72 (copy), v43 (copy)
			if connection then
				connection:Disconnect()
			end

			connection = nil

			if not v72.current then
				v43.onCancelled()
			end
		end
	end, {})

	local v75 = useSelector(function(p2) -- line: 329
		return p2.ScreenSize
	end)

	local function handleCloseClick() -- line: 333
		-- upvalues: v43 (copy), v44 (copy)
		v43.authEventAnalytics.reportModalDismissedWithSection(v43.eventContext, v43.origin, v44)
		v43.closeUpsell()
	end
	local function handlePhoneErrors(n1: number?) -- line: 342
		-- upvalues: v73 (copy)
		if n1 == 2 then
			return v73.invalidPhoneFormatKey
		end

		if n1 == 6 then
			return v73.tooManyAttemptsKey
		end

		if n1 == 7 then
			return v73.invalidVerificationCodeKey
		end

		if n1 == 8 then
			return v73.invalidPhoneNumberKey
		end

		if n1 == 9 then
			return v73.tooManyAccountsKey
		end

		return v73.genericErrorKey
	end
	local function handleSetPhone() -- line: 358
		-- upvalues: v65 (copy), v43 (copy), v48 (copy), v46 (copy), v45 (copy), PhoneVerificationUpsellState (copy), IdentityProtocol (copy), v44 (copy), v53 (copy), v55 (copy), EventStreamConstants (copy), v57 (copy), v73 (copy)
		v65(true)

		local v100 = v43.setPhoneNumber(v43.networking, v48.code, v48.prefix, v46)

		if v100 then
			v100:andThen(function() -- line: 363
				-- upvalues: v45 (copy), PhoneVerificationUpsellState (copy), v65 (copy), v43 (copy), IdentityProtocol (copy), v44 (copy), v53 (copy), v55 (copy)
				v45(PhoneVerificationUpsellState.VerifyPhone)
				v65(false)
				v43.authEventAnalytics.reportModalShownWithSection(v43.eventContext, v43.origin, PhoneVerificationUpsellState.VerifyPhone)

				if v43.isAutofillSMSOtpEnabled then
					local default = IdentityProtocol.default

					default:supportsGetSMSOTP():andThen(function(b2: boolean?) -- line: 265
						-- upvalues: v43 (copy), v44 (copy), default (copy), v53 (copy), v55 (copy)
						print("PhoneVerification: Autofill OTP supported: {}!", b2)

						if b2 then
							v43.authEventAnalytics.reportModalActionWithSection(v43.eventContext, "codeAutofillEligible", "autofill", v43.origin, v44)

							local v143 = default:getSMSOTP()

							if v143 then
								v143:andThen(function(s2: string?) -- line: 277
									-- upvalues: v53 (copy), v55 (copy), v43 (copy), v44 (copy)
									if s2 and s2 ~= "" then
										v53(s2)
										v55(s2)
										v43.authEventAnalytics.reportModalActionWithSection(v43.eventContext, "codeAutofillSuccess", "autofill", v43.origin, v44)
									end
								end)
							end
						end
					end)
				end
			end):catch(function(t4: {[any]: any}) -- line: 377
				-- upvalues: v43 (copy), EventStreamConstants (copy), PhoneVerificationUpsellState (copy), v57 (copy), v73 (copy), v65 (copy)
				if not t4 then
					v43.authEventAnalytics.reportModalShownWithSectionAndError(v43.eventContext, EventStreamConstants.Field.ErrorMessage, v43.origin, PhoneVerificationUpsellState.AddPhone, "")
					v57(v73.genericErrorKey)
				elseif t4.PhoneRegexFailed then
					v43.authEventAnalytics.reportModalShownWithSectionAndError(v43.eventContext, EventStreamConstants.Field.ErrorMessage, v43.origin, PhoneVerificationUpsellState.AddPhone, "")
					v57(v73.invalidPhoneFormatKey)
				else
					v43.authEventAnalytics.reportModalShownWithSectionAndError(v43.eventContext, EventStreamConstants.Field.ErrorMessage, v43.origin, PhoneVerificationUpsellState.AddPhone, t4.ErrorCode)

					local v125 = v57
					local ErrorCode = t4.ErrorCode

					v125(if ErrorCode ~= 2 then if ErrorCode ~= 6 then if ErrorCode ~= 7 then if ErrorCode ~= 8 then if ErrorCode ~= 9 then v73.genericErrorKey else v73.tooManyAccountsKey else v73.invalidPhoneNumberKey else v73.invalidVerificationCodeKey else v73.tooManyAttemptsKey else v73.invalidPhoneFormatKey)
				end

				v65(false)
			end)
		end

		v43.authEventAnalytics.reportInteractWithActionAndSection(v43.eventContext, "", "", v43.origin, EventStreamConstants.Button.Continue, PhoneVerificationUpsellState.AddPhone)
	end
	local function handleVerifyPhone() -- line: 419
		-- upvalues: v65 (copy), v43 (copy), v54 (copy), v63 (copy), EventStreamConstants (copy), PhoneVerificationUpsellState (copy), v59 (copy), v73 (copy)
		v65(true)

		local v101 = v43.verifyPhoneCode(v43.networking, v54)

		if v101 then
			v101:andThen(function() -- line: 424
				-- upvalues: v63 (copy)
				v63(true)
			end):catch(function(t5: {[any]: any}) -- line: 427
				-- upvalues: v43 (copy), EventStreamConstants (copy), PhoneVerificationUpsellState (copy), v59 (copy), v73 (copy), v65 (copy)
				if not t5 then
					v43.authEventAnalytics.reportModalShownWithSectionAndError(v43.eventContext, EventStreamConstants.Field.ErrorMessage, v43.origin, PhoneVerificationUpsellState.VerifyPhone, "")
					v59(v73.genericErrorKey)
				else
					v43.authEventAnalytics.reportModalShownWithSectionAndError(v43.eventContext, EventStreamConstants.Field.ErrorMessage, v43.origin, PhoneVerificationUpsellState.VerifyPhone, t5.ErrorCode)

					local v128 = v59
					local ErrorCode = t5.ErrorCode

					v128(if ErrorCode ~= 2 then if ErrorCode ~= 6 then if ErrorCode ~= 7 then if ErrorCode ~= 8 then if ErrorCode ~= 9 then v73.genericErrorKey else v73.tooManyAccountsKey else v73.invalidPhoneNumberKey else v73.invalidVerificationCodeKey else v73.tooManyAttemptsKey else v73.invalidPhoneFormatKey)
				end

				v65(false)
			end)
		end

		v43.authEventAnalytics.reportInteractWithActionAndSection(v43.eventContext, "", "", v43.origin, EventStreamConstants.Button.AutoSubmit, PhoneVerificationUpsellState.VerifyPhone)
	end
	local function handleResendCode() -- line: 460
		-- upvalues: v43 (copy), EventStreamConstants (copy), PhoneVerificationUpsellState (copy), v59 (copy), v73 (copy)
		local v102 = v43.resendPhoneCode(v43.networking)

		if v102 then
			v102:andThen(function() -- line: 463
			end):catch(function(t6: {[any]: any}) -- line: 463
				-- upvalues: v43 (copy), EventStreamConstants (copy), PhoneVerificationUpsellState (copy), v59 (copy), v73 (copy)
				if not t6 then
					v43.authEventAnalytics.reportModalShownWithSectionAndError(v43.eventContext, EventStreamConstants.Field.ErrorMessage, v43.origin, PhoneVerificationUpsellState.VerifyPhone, "")
					v59(v73.genericErrorKey)

					return
				end

				v43.authEventAnalytics.reportModalShownWithSectionAndError(v43.eventContext, EventStreamConstants.Field.ErrorMessage, v43.origin, PhoneVerificationUpsellState.VerifyPhone, t6.ErrorCode)

				local v131 = v59
				local ErrorCode = t6.ErrorCode

				v131(if ErrorCode ~= 2 then if ErrorCode ~= 6 then if ErrorCode ~= 7 then if ErrorCode ~= 8 then if ErrorCode ~= 9 then v73.genericErrorKey else v73.tooManyAccountsKey else v73.invalidPhoneNumberKey else v73.invalidVerificationCodeKey else v73.tooManyAttemptsKey else v73.invalidPhoneFormatKey)
			end)
		end

		v43.authEventAnalytics.reportInteractWithActionAndSection(v43.eventContext, "", "", v43.origin, EventStreamConstants.Button.ResendCode, PhoneVerificationUpsellState.VerifyPhone)
	end
	local function proceedToAddPhone() -- line: 507
		-- upvalues: v45 (copy), PhoneVerificationUpsellState (copy), v43 (copy), EventStreamConstants (copy)
		v45(PhoneVerificationUpsellState.AddPhone)
		v43.authEventAnalytics.reportInteractWithActionAndSection(v43.eventContext, "", "", v43.origin, EventStreamConstants.Button.Continue, PhoneVerificationUpsellState.Entry)
	end
	local function navigateToSMSTerms() -- line: 519
		-- upvalues: v64 (copy), v43 (copy), EventStreamConstants (copy), v44 (copy)
		if not v64 then
			v43.authEventAnalytics.reportModalActionWithSection(v43.eventContext, EventStreamConstants.Field.TermsOfService, "", v43.origin, v44)
			v43.showWebpage("https://en.help.roblox.com/hc/articles/9483830673556-Roblox-SMS-Terms-of-Service")
		end
	end
	local function navigateToPrivacy() -- line: 532
		-- upvalues: v64 (copy), v43 (copy), EventStreamConstants (copy), v44 (copy)
		if not v64 then
			v43.authEventAnalytics.reportModalActionWithSection(v43.eventContext, EventStreamConstants.Field.PrivacyPolicy, "", v43.origin, v44)
			v43.showWebpage("https://en.help.roblox.com/hc/articles/115004630823")
		end
	end

	local v84 = debounce(function(p3) -- line: 578
		-- upvalues: v55 (copy)
		v55(p3)
	end, 0.5)

	React.useEffect(function() -- line: 609
		-- upvalues: v54 (copy), handleVerifyPhone (copy)
		if string.len(v54) == 6 then
			handleVerifyPhone()
		end
	end, { v54 })
	React.useEffect(function() -- line: 616
		-- upvalues: v62 (copy), v43 (copy), PhoneVerificationUpsellState (copy)
		if v62 then
			v43.setIsPhoneVerified({
				isPhoneVerified = true
			})
			v43.authEventAnalytics.reportModalShownWithSection(v43.eventContext, v43.origin, PhoneVerificationUpsellState.Success)
			v43.onSuccess()
		end
	end, { v62 })

	local v85 = React.createElement(Loading, {
		size = IconSize.Large,
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5)
	})

	return React.createElement(if not GetFFlagPhoneUseParentSizeForScreenSize() then React.Fragment else "Frame", if not GetFFlagPhoneUseParentSizeForScreenSize() then nil else {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		[Roact.Change.AbsoluteSize] = function(p4) -- line: 640
			-- upvalues: v71 (copy)
			v71(p4.AbsoluteSize)
		end
	}, {
		Entry = v44 == PhoneVerificationUpsellState.Entry and (v43.entryConfig and React.createElement(EntryView, {
			screenSize = if not GetFFlagPhoneUseParentSizeForScreenSize() then v75 else v70,
			onClose = handleCloseClick,
			titleKey = v43.entryConfig.titleKey,
			descriptionKey = v43.entryConfig.descriptionKey,
			buttonKey = v43.entryConfig.buttonKey,
			onButtonClick = proceedToAddPhone,
			extraButtonKey = v43.entryConfig.extraButtonConfig.extraButtonKey,
			onExtraButtonClick = v43.entryConfig.extraButtonConfig.onExtraButtonClick
		})),
		AddPhone = v44 == PhoneVerificationUpsellState.AddPhone and React.createElement(AddPhoneView, {
			screenSize = if not GetFFlagPhoneUseParentSizeForScreenSize() then v75 else v70,
			countryCode = v48,
			setCountryCode = v49,
			phoneNumber = v46,
			errorMessage = v56,
			isDisabled = v64,
			onPhoneNumberTextChange = function(p5) -- line: 546
				-- upvalues: v64 (copy), v57 (copy), v47 (copy)
				if not v64 then
					v57("")
					v47(p5.Text)
				end
			end,
			onSetPhoneNumber = handleSetPhone,
			onClose = handleCloseClick,
			onTermsOfUseClick = navigateToSMSTerms,
			onPrivacyPolicyClick = navigateToPrivacy,
			onPhoneInputFocus = function() -- line: 564
				-- upvalues: v43 (copy), EventStreamConstants (copy), PhoneVerificationUpsellState (copy), IdentityProtocol (copy), v44 (copy), GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix (copy), v48 (copy), t1 (copy), v47 (copy)
				v43.authEventAnalytics.reportInteractWithActionAndSection(v43.eventContext, EventStreamConstants.Field.PhoneNumber, EventStreamConstants.ActionType.Focus, v43.origin, "", PhoneVerificationUpsellState.AddPhone)

				if not v43.shouldAutofillAndroidPhoneNumberAtLaunch then
					local default = IdentityProtocol.default

					default:supportsGetPhoneNumber():andThen(function(b3: boolean?) -- line: 211
						-- upvalues: v43 (copy), v44 (copy), default (copy), GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix (copy), v48 (copy), t1 (copy), v47 (copy)
						print("PhoneVerification: Autofill phone number supported: {}!", b3)

						if not b3 then
							return
						end

						v43.authEventAnalytics.reportModalActionWithSection(v43.eventContext, "phoneAutofillEligible", "autofill", v43.origin, v44)

						local v134 = default:getPhoneNumber()

						if not v134 then
							return
						end

						v134:andThen(function(s3: string?) -- line: 227
							-- upvalues: GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix (copy), v48 (copy), t1 (copy), v43 (copy), v44 (copy), v47 (copy)
							if s3 and s3 ~= "" then
								local v145, v146 = GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix(s3, v48.prefix)

								if v145 == t1.prefix then
									v43.authEventAnalytics.reportModalActionWithSection(v43.eventContext, "phoneAutofillUSFound", "autofill", v43.origin, v44)
								end

								v47(v146)
								v43.authEventAnalytics.reportModalActionWithSection(v43.eventContext, "phoneAutofillSuccess", "autofill", v43.origin, v44)

								return
							end

							v43.authEventAnalytics.reportModalActionWithSection(v43.eventContext, "phoneAutofillNull", "autofill", v43.origin, v44)
						end)
					end)
				end
			end,
			onCountryCodeSelectorClick = function() -- line: 553
				-- upvalues: v43 (copy), EventStreamConstants (copy), PhoneVerificationUpsellState (copy)
				v43.authEventAnalytics.reportInteractWithActionAndSection(v43.eventContext, EventStreamConstants.Field.CountryPrefix, EventStreamConstants.ActionType.Focus, v43.origin, "", PhoneVerificationUpsellState.AddPhone)
			end,
			isKeyboardShowing = v66,
			keyboardHeight = v68,
			usePhoneNumberTextType = GetFFlagLuaUsePhoneNumberTextTypeForPhoneUpsell() and v43.isPhoneNumberTextTypeEnabled,
			titleKey = v43.addPhoneTitleKey,
			descriptionKey = v43.addPhoneDescriptionKey,
			buttonKey = v43.addPhoneButtonKey,
			legalTextKey = v43.addPhoneLegalTextKey,
			extraButtonKey = v43.extraButtonTextKey,
			onExtraButtonClick = v43.onExtraButtonClick,
			alwaysShowLegalText = v43.alwaysShowAddPhoneLegalText,
			requireLegalTextCheckbox = v43.requireAddPhoneLegalTextCheckbox
		}),
		VerifyPhone = v44 == PhoneVerificationUpsellState.VerifyPhone and React.createElement(VerifyPhoneView, {
			screenSize = if not GetFFlagPhoneUseParentSizeForScreenSize() then v75 else v70,
			phoneNumber = v46,
			prefix = v48.prefix,
			code = v52,
			errorMessage = v58,
			onCodeTextChange = function(p6) -- line: 582
				-- upvalues: FFlagPhoneUpsellEnforceCodeInputLimit (copy), v52 (copy), v59 (copy), v53 (copy), v84 (copy)
				local v107 = string.sub(p6.Text, 1, 6)

				if FFlagPhoneUpsellEnforceCodeInputLimit then
					if v107 ~= v52 then
						v59("")
					end
				elseif string.len(p6.Text) <= 6 then
					v59("")
				end

				v53(v107)
				v84(v107)
			end,
			onResendPhoneCode = handleResendCode,
			onClose = handleCloseClick,
			returnToAddPhone = function() -- line: 495
				-- upvalues: v45 (copy), PhoneVerificationUpsellState (copy), v43 (copy), EventStreamConstants (copy)
				v45(PhoneVerificationUpsellState.AddPhone)
				v43.authEventAnalytics.reportInteractWithActionAndSection(v43.eventContext, "", "", v43.origin, EventStreamConstants.Button.ChangePhoneNumber, PhoneVerificationUpsellState.VerifyPhone)
			end,
			onCodeInputFocus = function() -- line: 597
				-- upvalues: v43 (copy), EventStreamConstants (copy), PhoneVerificationUpsellState (copy)
				v43.authEventAnalytics.reportInteractWithActionAndSection(v43.eventContext, EventStreamConstants.Field.VerificationCode, EventStreamConstants.ActionType.Focus, v43.origin, "", PhoneVerificationUpsellState.VerifyPhone)
			end,
			isKeyboardShowing = v66,
			keyboardHeight = v68,
			useOTPInputType = v43.isOTPInputTypeEnabled,
			extraButtonKey = v43.verifyPhoneExtraButtonKey,
			onExtraButtonClick = v43.onVerifyPhoneExtraButtonClick
		}),
		LoadingOverlay = v60 and React.createElement(PhoneVerificationStatusOverlay, {
			image = v85,
			text = v73.verifyingKey
		})
	})
end

local v39 = RoactRodux.connect(function(p7, _) -- line: 712
	return {
		countryCodeList = p7.CountryCodeList
	}
end, function(p9) -- line: 716
	-- upvalues: SetPhoneNumber (copy), VerifyPhoneCode (copy), ResendPhoneCode (copy), SetIsPhoneVerified (copy)
	return {
		setPhoneNumber = function(p10, p11, p12, p13) -- line: 718
			-- upvalues: p9 (copy), SetPhoneNumber (copy)
			return p9(SetPhoneNumber(p10, p11, p12, p13, nil))
		end,
		verifyPhoneCode = function(p14, p15) -- line: 721
			-- upvalues: p9 (copy), VerifyPhoneCode (copy)
			return p9(VerifyPhoneCode(p14, p15))
		end,
		resendPhoneCode = function(p16) -- line: 724
			-- upvalues: p9 (copy), ResendPhoneCode (copy)
			return p9(ResendPhoneCode(p16))
		end,
		setIsPhoneVerified = function(p17) -- line: 727
			-- upvalues: p9 (copy), SetIsPhoneVerified (copy)
			return p9(SetIsPhoneVerified(p17))
		end
	}
end)(PhoneVerificationUpsellOverlay)
local v40 = RoactServices.connect({
	networking = RoactNetworking,
	authEventAnalytics = RoactAnalyticsAuthEvents
})(v39)

return (RoactAppExperiment.connectUserLayer({
	GetFStringAndroidPhoneVerificationLayer(),
	GetFStringIOSPhoneVerificationLayer()
}, function(p18, _) -- line: 741
	-- upvalues: GetFStringAndroidPhoneVerificationLayer (copy), GetFStringIOSPhoneVerificationLayer (copy)
	local v91 = p18[GetFStringAndroidPhoneVerificationLayer()] or {}
	local v92 = p18[GetFStringIOSPhoneVerificationLayer()] or {}

	return {
		isAutofillPhoneNumberEnabled = v91.IsAutofillPhoneNumberEnabled,
		isAutofillSMSOtpEnabled = v91.IsAutofillSMSOtpEnabled,
		isOTPInputTypeEnabled = v92.IsAutofillSMSOtpEnabled,
		isPhoneNumberTextTypeEnabled = v92.IsAutofillPhoneNumberEnabled
	}
end)(v40))
