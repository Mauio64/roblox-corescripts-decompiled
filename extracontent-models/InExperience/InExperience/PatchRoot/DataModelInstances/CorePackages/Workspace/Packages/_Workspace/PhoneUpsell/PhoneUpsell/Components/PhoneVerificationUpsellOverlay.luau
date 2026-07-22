local PhoneUpsell = script:FindFirstAncestor("PhoneUpsell")
local PhoneUpsellParent = PhoneUpsell.Parent
local UserInputService = game:GetService("UserInputService")
local React = require(PhoneUpsellParent.React)
local Roact = require(PhoneUpsellParent.Roact)
local RoactRodux = require(PhoneUpsellParent.RoactRodux)
local Cryo = require(PhoneUpsellParent.Cryo)
local useSelector = require(PhoneUpsellParent.RoactUtils).Hooks.RoactRodux.useSelector
local useSignalState = require(PhoneUpsellParent.SignalsReact).useSignalState
local FFlagUseSignalsForCountryCodeList = require(PhoneUpsellParent.SharedFlags).FFlagUseSignalsForCountryCodeList
local GetCountryCodeListStore = require(PhoneUpsellParent.AuthCommon).Stores.GetCountryCodeListStore

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
local IdentityProtocol = require(PhoneUpsellParent.IdentityProtocol).IdentityProtocol
local t1 = {
	name = "United States",
	code = "US",
	prefix = "1",
	localizedName = "United States"
}

local function v39() -- line: 146
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
	onSuccess = v39,
	onFailure = v39,
	onCancelled = v39,
	onExtraButtonClick = v39,
	closeUpsell = v39,
	showWebpage = function(_) -- line: 164
	end
}

local function PhoneVerificationUpsellOverlay(t3: {[any]: any}) -- line: 167
	-- upvalues: mergeProps (copy), t2 (copy), React (copy), PhoneVerificationUpsellState (copy), t1 (copy), useLocalization (copy), IdentityProtocol (copy), GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix (copy), UserInputService (copy), useSelector (copy), EventStreamConstants (copy), debounce (copy), Loading (copy), IconSize (copy), GetFFlagPhoneUseParentSizeForScreenSize (copy), Roact (copy), EntryView (copy), AddPhoneView (copy), GetFFlagLuaUsePhoneNumberTextTypeForPhoneUpsell (copy), VerifyPhoneView (copy), PhoneVerificationStatusOverlay (copy)
	local v47 = mergeProps(t2, t3)
	local v48, v49 = React.useState(if not v47.entryConfig then PhoneVerificationUpsellState.AddPhone else PhoneVerificationUpsellState.Entry)
	local v50, v51 = React.useState("")
	local v52, v53 = React.useState(t1)
	local v54, v55 = React.useState(false)
	local v56, v57 = React.useState("")
	local v58, v59 = React.useState("")
	local v60, v61 = React.useState("")
	local v62, v63 = React.useState("")
	local v64, _ = React.useState(false)
	local v66, v67 = React.useState(false)
	local v68, v69 = React.useState(false)
	local v70, v71 = React.useState(false)
	local v72, v73 = React.useState(0)
	local v74, v75 = React.useState(Vector2.new(400, 400))
	local v76 = React.useRef(false)
	local v77 = useLocalization({
		verifyingKey = "Feature.VerificationUpsell.Label.Verifying",
		invalidPhoneFormatKey = "Feature.VerificationUpsell.Response.ErrorPhoneFormatInvalid",
		invalidPhoneNumberKey = "Feature.VerificationUpsell.Response.InvalidPhoneNumberError",
		invalidVerificationCodeKey = "Feature.VerificationUpsell.Message.InvalidSmsCode",
		tooManyAccountsKey = "Feature.VerificationUpsell.Response.PhoneHasTooManyAssociatedAccounts",
		tooManyAttemptsKey = "Feature.VerificationUpsell.Response.TooManyAttemptsTryAgainLater",
		genericErrorKey = "Feature.VerificationUpsell.Response.ErrorTryAgain"
	})
	local connection = nil

	React.useEffect(function() -- line: 200
		-- upvalues: v54 (copy), v47 (copy), v53 (copy), v55 (copy)
		if not v54 and (v47.countryCodeList and #v47.countryCodeList > 0) then
			for _, v100 in v47.countryCodeList do
				if v100.isDefault then
					v53(v100)
				end
			end

			v55(true)
		end
	end, {
		v47.countryCodeList,
		v54
	})
	React.useEffect(function() -- line: 298
		-- upvalues: v76 (copy), v66 (copy)
		return function() -- line: 299
			-- upvalues: v76 (copy), v66 (copy)
			v76.current = v66
		end
	end, { v66 })
	React.useEffect(function() -- line: 304
		-- upvalues: connection (ref), UserInputService (copy), v71 (copy), v73 (copy), v47 (copy), PhoneVerificationUpsellState (copy), IdentityProtocol (copy), v48 (copy), GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix (copy), v52 (copy), t1 (copy), v51 (copy), v76 (copy)
		connection = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(function() -- line: 306
			-- upvalues: v71 (copy), UserInputService (copy), v73 (copy)
			v71(UserInputService.OnScreenKeyboardVisible)
			v73(UserInputService.OnScreenKeyboardVisible and UserInputService.OnScreenKeyboardSize.Y or 0)
		end)
		v47.authEventAnalytics.reportModalShownWithSection(v47.eventContext, v47.origin, PhoneVerificationUpsellState.AddPhone)

		if v47.isAutofillPhoneNumberEnabled then
			local default = IdentityProtocol.default

			default:supportsGetPhoneNumber():andThen(function(b1: boolean?) -- line: 214
				-- upvalues: v47 (copy), v48 (copy), default (copy), GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix (copy), v52 (copy), t1 (copy), v51 (copy)
				print("PhoneVerification: Autofill phone number supported: {}!", b1)

				if not b1 then
					return
				end

				v47.authEventAnalytics.reportModalActionWithSection(v47.eventContext, "phoneAutofillEligible", "autofill", v47.origin, v48)

				local v128 = default:getPhoneNumber()

				if not v128 then
					return
				end

				v128:andThen(function(s1: string?) -- line: 230
					-- upvalues: GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix (copy), v52 (copy), t1 (copy), v47 (copy), v48 (copy), v51 (copy)
					if s1 and s1 ~= "" then
						local v146, v147 = GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix(s1, v52.prefix)

						if v146 == t1.prefix then
							v47.authEventAnalytics.reportModalActionWithSection(v47.eventContext, "phoneAutofillUSFound", "autofill", v47.origin, v48)
						end

						v51(v147)
						v47.authEventAnalytics.reportModalActionWithSection(v47.eventContext, "phoneAutofillSuccess", "autofill", v47.origin, v48)

						return
					end

					v47.authEventAnalytics.reportModalActionWithSection(v47.eventContext, "phoneAutofillNull", "autofill", v47.origin, v48)
				end)
			end)
		end

		return function() -- line: 321
			-- upvalues: connection (ref), v76 (copy), v47 (copy)
			if connection then
				connection:Disconnect()
			end

			connection = nil

			if not v76.current then
				v47.onCancelled()
			end
		end
	end, {})

	local v79 = useSelector(function(p2) -- line: 332
		return p2.ScreenSize
	end)

	local function handleCloseClick() -- line: 336
		-- upvalues: v47 (copy), v48 (copy)
		v47.authEventAnalytics.reportModalDismissedWithSection(v47.eventContext, v47.origin, v48)
		v47.closeUpsell()
	end
	local function handlePhoneErrors(n1: number?) -- line: 345
		-- upvalues: v77 (copy)
		if n1 == 2 then
			return v77.invalidPhoneFormatKey
		end

		if n1 == 6 then
			return v77.tooManyAttemptsKey
		end

		if n1 == 7 then
			return v77.invalidVerificationCodeKey
		end

		if n1 == 8 then
			return v77.invalidPhoneNumberKey
		end

		if n1 == 9 then
			return v77.tooManyAccountsKey
		end

		return v77.genericErrorKey
	end
	local function handleSetPhone() -- line: 361
		-- upvalues: v69 (copy), v47 (copy), v52 (copy), v50 (copy), v49 (copy), PhoneVerificationUpsellState (copy), IdentityProtocol (copy), v48 (copy), v57 (copy), v59 (copy), EventStreamConstants (copy), v61 (copy), v77 (copy)
		v69(true)

		local v106 = v47.setPhoneNumber(v47.networking, v52.code, v52.prefix, v50)

		if v106 then
			v106:andThen(function() -- line: 366
				-- upvalues: v49 (copy), PhoneVerificationUpsellState (copy), v69 (copy), v47 (copy), IdentityProtocol (copy), v48 (copy), v57 (copy), v59 (copy)
				v49(PhoneVerificationUpsellState.VerifyPhone)
				v69(false)
				v47.authEventAnalytics.reportModalShownWithSection(v47.eventContext, v47.origin, PhoneVerificationUpsellState.VerifyPhone)

				if v47.isAutofillSMSOtpEnabled then
					local default = IdentityProtocol.default

					default:supportsGetSMSOTP():andThen(function(b2: boolean?) -- line: 268
						-- upvalues: v47 (copy), v48 (copy), default (copy), v57 (copy), v59 (copy)
						print("PhoneVerification: Autofill OTP supported: {}!", b2)

						if b2 then
							v47.authEventAnalytics.reportModalActionWithSection(v47.eventContext, "codeAutofillEligible", "autofill", v47.origin, v48)

							local v149 = default:getSMSOTP()

							if v149 then
								v149:andThen(function(s2: string?) -- line: 280
									-- upvalues: v57 (copy), v59 (copy), v47 (copy), v48 (copy)
									if s2 and s2 ~= "" then
										v57(s2)
										v59(s2)
										v47.authEventAnalytics.reportModalActionWithSection(v47.eventContext, "codeAutofillSuccess", "autofill", v47.origin, v48)
									end
								end)
							end
						end
					end)
				end
			end):catch(function(t4: {[any]: any}) -- line: 380
				-- upvalues: v47 (copy), EventStreamConstants (copy), PhoneVerificationUpsellState (copy), v61 (copy), v77 (copy), v69 (copy)
				if not t4 then
					v47.authEventAnalytics.reportModalShownWithSectionAndError(v47.eventContext, EventStreamConstants.Field.ErrorMessage, v47.origin, PhoneVerificationUpsellState.AddPhone, "")
					v61(v77.genericErrorKey)
				elseif t4.PhoneRegexFailed then
					v47.authEventAnalytics.reportModalShownWithSectionAndError(v47.eventContext, EventStreamConstants.Field.ErrorMessage, v47.origin, PhoneVerificationUpsellState.AddPhone, "")
					v61(v77.invalidPhoneFormatKey)
				else
					v47.authEventAnalytics.reportModalShownWithSectionAndError(v47.eventContext, EventStreamConstants.Field.ErrorMessage, v47.origin, PhoneVerificationUpsellState.AddPhone, t4.ErrorCode)

					local v131 = v61
					local ErrorCode = t4.ErrorCode

					v131(if ErrorCode ~= 2 then if ErrorCode ~= 6 then if ErrorCode ~= 7 then if ErrorCode ~= 8 then if ErrorCode ~= 9 then v77.genericErrorKey else v77.tooManyAccountsKey else v77.invalidPhoneNumberKey else v77.invalidVerificationCodeKey else v77.tooManyAttemptsKey else v77.invalidPhoneFormatKey)
				end

				v69(false)
			end)
		end

		v47.authEventAnalytics.reportInteractWithActionAndSection(v47.eventContext, "", "", v47.origin, EventStreamConstants.Button.Continue, PhoneVerificationUpsellState.AddPhone)
	end
	local function handleVerifyPhone() -- line: 422
		-- upvalues: v69 (copy), v47 (copy), v58 (copy), v67 (copy), EventStreamConstants (copy), PhoneVerificationUpsellState (copy), v63 (copy), v77 (copy)
		v69(true)

		local v107 = v47.verifyPhoneCode(v47.networking, v58)

		if v107 then
			v107:andThen(function() -- line: 427
				-- upvalues: v67 (copy)
				v67(true)
			end):catch(function(t5: {[any]: any}) -- line: 430
				-- upvalues: v47 (copy), EventStreamConstants (copy), PhoneVerificationUpsellState (copy), v63 (copy), v77 (copy), v69 (copy)
				if not t5 then
					v47.authEventAnalytics.reportModalShownWithSectionAndError(v47.eventContext, EventStreamConstants.Field.ErrorMessage, v47.origin, PhoneVerificationUpsellState.VerifyPhone, "")
					v63(v77.genericErrorKey)
				else
					v47.authEventAnalytics.reportModalShownWithSectionAndError(v47.eventContext, EventStreamConstants.Field.ErrorMessage, v47.origin, PhoneVerificationUpsellState.VerifyPhone, t5.ErrorCode)

					local v134 = v63
					local ErrorCode = t5.ErrorCode

					v134(if ErrorCode ~= 2 then if ErrorCode ~= 6 then if ErrorCode ~= 7 then if ErrorCode ~= 8 then if ErrorCode ~= 9 then v77.genericErrorKey else v77.tooManyAccountsKey else v77.invalidPhoneNumberKey else v77.invalidVerificationCodeKey else v77.tooManyAttemptsKey else v77.invalidPhoneFormatKey)
				end

				v69(false)
			end)
		end

		v47.authEventAnalytics.reportInteractWithActionAndSection(v47.eventContext, "", "", v47.origin, EventStreamConstants.Button.AutoSubmit, PhoneVerificationUpsellState.VerifyPhone)
	end
	local function handleResendCode() -- line: 463
		-- upvalues: v47 (copy), EventStreamConstants (copy), PhoneVerificationUpsellState (copy), v63 (copy), v77 (copy)
		local v108 = v47.resendPhoneCode(v47.networking)

		if v108 then
			v108:andThen(function() -- line: 466
			end):catch(function(t6: {[any]: any}) -- line: 466
				-- upvalues: v47 (copy), EventStreamConstants (copy), PhoneVerificationUpsellState (copy), v63 (copy), v77 (copy)
				if not t6 then
					v47.authEventAnalytics.reportModalShownWithSectionAndError(v47.eventContext, EventStreamConstants.Field.ErrorMessage, v47.origin, PhoneVerificationUpsellState.VerifyPhone, "")
					v63(v77.genericErrorKey)

					return
				end

				v47.authEventAnalytics.reportModalShownWithSectionAndError(v47.eventContext, EventStreamConstants.Field.ErrorMessage, v47.origin, PhoneVerificationUpsellState.VerifyPhone, t6.ErrorCode)

				local v137 = v63
				local ErrorCode = t6.ErrorCode

				v137(if ErrorCode ~= 2 then if ErrorCode ~= 6 then if ErrorCode ~= 7 then if ErrorCode ~= 8 then if ErrorCode ~= 9 then v77.genericErrorKey else v77.tooManyAccountsKey else v77.invalidPhoneNumberKey else v77.invalidVerificationCodeKey else v77.tooManyAttemptsKey else v77.invalidPhoneFormatKey)
			end)
		end

		v47.authEventAnalytics.reportInteractWithActionAndSection(v47.eventContext, "", "", v47.origin, EventStreamConstants.Button.ResendCode, PhoneVerificationUpsellState.VerifyPhone)
	end
	local function proceedToAddPhone() -- line: 510
		-- upvalues: v49 (copy), PhoneVerificationUpsellState (copy), v47 (copy), EventStreamConstants (copy)
		v49(PhoneVerificationUpsellState.AddPhone)
		v47.authEventAnalytics.reportInteractWithActionAndSection(v47.eventContext, "", "", v47.origin, EventStreamConstants.Button.Continue, PhoneVerificationUpsellState.Entry)
	end
	local function navigateToSMSTerms() -- line: 522
		-- upvalues: v68 (copy), v47 (copy), EventStreamConstants (copy), v48 (copy)
		if not v68 then
			v47.authEventAnalytics.reportModalActionWithSection(v47.eventContext, EventStreamConstants.Field.TermsOfService, "", v47.origin, v48)
			v47.showWebpage("https://en.help.roblox.com/hc/articles/9483830673556-Roblox-SMS-Terms-of-Service")
		end
	end
	local function navigateToPrivacy() -- line: 535
		-- upvalues: v68 (copy), v47 (copy), EventStreamConstants (copy), v48 (copy)
		if not v68 then
			v47.authEventAnalytics.reportModalActionWithSection(v47.eventContext, EventStreamConstants.Field.PrivacyPolicy, "", v47.origin, v48)
			v47.showWebpage("https://en.help.roblox.com/hc/articles/115004630823")
		end
	end

	local v88 = debounce(function(p3) -- line: 581
		-- upvalues: v59 (copy)
		v59(p3)
	end, 0.5)

	React.useEffect(function() -- line: 606
		-- upvalues: v58 (copy), handleVerifyPhone (copy)
		if string.len(v58) == 6 then
			handleVerifyPhone()
		end
	end, { v58 })
	React.useEffect(function() -- line: 613
		-- upvalues: v66 (copy), v47 (copy), PhoneVerificationUpsellState (copy)
		if v66 then
			v47.setIsPhoneVerified({
				isPhoneVerified = true
			})
			v47.authEventAnalytics.reportModalShownWithSection(v47.eventContext, v47.origin, PhoneVerificationUpsellState.Success)
			v47.onSuccess()
		end
	end, { v66 })

	local v89 = React.createElement(Loading, {
		size = IconSize.Large,
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5)
	})

	return React.createElement(if not GetFFlagPhoneUseParentSizeForScreenSize() then React.Fragment else "Frame", if not GetFFlagPhoneUseParentSizeForScreenSize() then nil else {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		[Roact.Change.AbsoluteSize] = function(p4) -- line: 637
			-- upvalues: v75 (copy)
			v75(p4.AbsoluteSize)
		end
	}, {
		Entry = v48 == PhoneVerificationUpsellState.Entry and (v47.entryConfig and React.createElement(EntryView, {
			screenSize = if not GetFFlagPhoneUseParentSizeForScreenSize() then v79 else v74,
			onClose = handleCloseClick,
			titleKey = v47.entryConfig.titleKey,
			descriptionKey = v47.entryConfig.descriptionKey,
			buttonKey = v47.entryConfig.buttonKey,
			onButtonClick = proceedToAddPhone,
			extraButtonKey = v47.entryConfig.extraButtonConfig.extraButtonKey,
			onExtraButtonClick = v47.entryConfig.extraButtonConfig.onExtraButtonClick
		})),
		AddPhone = v48 == PhoneVerificationUpsellState.AddPhone and React.createElement(AddPhoneView, {
			screenSize = if not GetFFlagPhoneUseParentSizeForScreenSize() then v79 else v74,
			countryCode = v52,
			setCountryCode = v53,
			phoneNumber = v50,
			errorMessage = v60,
			isDisabled = v68,
			onPhoneNumberTextChange = function(p5) -- line: 549
				-- upvalues: v68 (copy), v61 (copy), v51 (copy)
				if not v68 then
					v61("")
					v51(p5.Text)
				end
			end,
			onSetPhoneNumber = handleSetPhone,
			onClose = handleCloseClick,
			onTermsOfUseClick = navigateToSMSTerms,
			onPrivacyPolicyClick = navigateToPrivacy,
			onPhoneInputFocus = function() -- line: 567
				-- upvalues: v47 (copy), EventStreamConstants (copy), PhoneVerificationUpsellState (copy), IdentityProtocol (copy), v48 (copy), GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix (copy), v52 (copy), t1 (copy), v51 (copy)
				v47.authEventAnalytics.reportInteractWithActionAndSection(v47.eventContext, EventStreamConstants.Field.PhoneNumber, EventStreamConstants.ActionType.Focus, v47.origin, "", PhoneVerificationUpsellState.AddPhone)

				if not v47.shouldAutofillAndroidPhoneNumberAtLaunch then
					local default = IdentityProtocol.default

					default:supportsGetPhoneNumber():andThen(function(b3: boolean?) -- line: 214
						-- upvalues: v47 (copy), v48 (copy), default (copy), GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix (copy), v52 (copy), t1 (copy), v51 (copy)
						print("PhoneVerification: Autofill phone number supported: {}!", b3)

						if not b3 then
							return
						end

						v47.authEventAnalytics.reportModalActionWithSection(v47.eventContext, "phoneAutofillEligible", "autofill", v47.origin, v48)

						local v140 = default:getPhoneNumber()

						if not v140 then
							return
						end

						v140:andThen(function(s3: string?) -- line: 230
							-- upvalues: GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix (copy), v52 (copy), t1 (copy), v47 (copy), v48 (copy), v51 (copy)
							if s3 and s3 ~= "" then
								local v151, v152 = GetPrefixAndNationalNumberFromRawPhoneAndDefaultPrefix(s3, v52.prefix)

								if v151 == t1.prefix then
									v47.authEventAnalytics.reportModalActionWithSection(v47.eventContext, "phoneAutofillUSFound", "autofill", v47.origin, v48)
								end

								v51(v152)
								v47.authEventAnalytics.reportModalActionWithSection(v47.eventContext, "phoneAutofillSuccess", "autofill", v47.origin, v48)

								return
							end

							v47.authEventAnalytics.reportModalActionWithSection(v47.eventContext, "phoneAutofillNull", "autofill", v47.origin, v48)
						end)
					end)
				end
			end,
			onCountryCodeSelectorClick = function() -- line: 556
				-- upvalues: v47 (copy), EventStreamConstants (copy), PhoneVerificationUpsellState (copy)
				v47.authEventAnalytics.reportInteractWithActionAndSection(v47.eventContext, EventStreamConstants.Field.CountryPrefix, EventStreamConstants.ActionType.Focus, v47.origin, "", PhoneVerificationUpsellState.AddPhone)
			end,
			isKeyboardShowing = v70,
			keyboardHeight = v72,
			usePhoneNumberTextType = GetFFlagLuaUsePhoneNumberTextTypeForPhoneUpsell() and v47.isPhoneNumberTextTypeEnabled,
			titleKey = v47.addPhoneTitleKey,
			descriptionKey = v47.addPhoneDescriptionKey,
			buttonKey = v47.addPhoneButtonKey,
			legalTextKey = v47.addPhoneLegalTextKey,
			extraButtonKey = v47.extraButtonTextKey,
			onExtraButtonClick = v47.onExtraButtonClick,
			alwaysShowLegalText = v47.alwaysShowAddPhoneLegalText,
			requireLegalTextCheckbox = v47.requireAddPhoneLegalTextCheckbox
		}),
		VerifyPhone = v48 == PhoneVerificationUpsellState.VerifyPhone and React.createElement(VerifyPhoneView, {
			screenSize = if not GetFFlagPhoneUseParentSizeForScreenSize() then v79 else v74,
			phoneNumber = v50,
			prefix = v52.prefix,
			code = v56,
			errorMessage = v62,
			onCodeTextChange = function(p6) -- line: 585
				-- upvalues: v56 (copy), v63 (copy), v57 (copy), v88 (copy)
				local v113 = string.sub(p6.Text, 1, 6)

				if v113 ~= v56 then
					v63("")
				end

				v57(v113)
				v88(v113)
			end,
			onResendPhoneCode = handleResendCode,
			onClose = handleCloseClick,
			returnToAddPhone = function() -- line: 498
				-- upvalues: v49 (copy), PhoneVerificationUpsellState (copy), v47 (copy), EventStreamConstants (copy)
				v49(PhoneVerificationUpsellState.AddPhone)
				v47.authEventAnalytics.reportInteractWithActionAndSection(v47.eventContext, "", "", v47.origin, EventStreamConstants.Button.ChangePhoneNumber, PhoneVerificationUpsellState.VerifyPhone)
			end,
			onCodeInputFocus = function() -- line: 594
				-- upvalues: v47 (copy), EventStreamConstants (copy), PhoneVerificationUpsellState (copy)
				v47.authEventAnalytics.reportInteractWithActionAndSection(v47.eventContext, EventStreamConstants.Field.VerificationCode, EventStreamConstants.ActionType.Focus, v47.origin, "", PhoneVerificationUpsellState.VerifyPhone)
			end,
			isKeyboardShowing = v70,
			keyboardHeight = v72,
			useOTPInputType = v47.isOTPInputTypeEnabled,
			extraButtonKey = v47.verifyPhoneExtraButtonKey,
			onExtraButtonClick = v47.onVerifyPhoneExtraButtonClick
		}),
		LoadingOverlay = v64 and React.createElement(PhoneVerificationStatusOverlay, {
			image = v89,
			text = v77.verifyingKey
		})
	})
end

local v42 = RoactRodux.connect(not FFlagUseSignalsForCountryCodeList and function(p7, _) -- line: 712
	return {
		countryCodeList = p7.CountryCodeList
	}
end or nil, function(p9) -- line: 717
	-- upvalues: SetPhoneNumber (copy), VerifyPhoneCode (copy), ResendPhoneCode (copy), SetIsPhoneVerified (copy)
	return {
		setPhoneNumber = function(p10, p11, p12, p13) -- line: 719
			-- upvalues: p9 (copy), SetPhoneNumber (copy)
			return p9(SetPhoneNumber(p10, p11, p12, p13, nil))
		end,
		verifyPhoneCode = function(p14, p15) -- line: 722
			-- upvalues: p9 (copy), VerifyPhoneCode (copy)
			return p9(VerifyPhoneCode(p14, p15))
		end,
		resendPhoneCode = function(p16) -- line: 725
			-- upvalues: p9 (copy), ResendPhoneCode (copy)
			return p9(ResendPhoneCode(p16))
		end,
		setIsPhoneVerified = function(p17) -- line: 728
			-- upvalues: p9 (copy), SetIsPhoneVerified (copy)
			return p9(SetIsPhoneVerified(p17))
		end
	}
end)(PhoneVerificationUpsellOverlay)

if FFlagUseSignalsForCountryCodeList then
	local v43 = v42

	v42 = React.memo(function(p18) -- line: 739
		-- upvalues: useSignalState (copy), GetCountryCodeListStore (copy), React (copy), v43 (copy), Cryo (copy)
		local v94 = useSignalState(GetCountryCodeListStore(false).getCountryCodeList)

		return React.createElement(v43, Cryo.Dictionary.union(p18, {
			countryCodeList = v94
		}))
	end)
end

local v44 = RoactServices.connect({
	networking = RoactNetworking,
	authEventAnalytics = RoactAnalyticsAuthEvents
})(v42)

return (RoactAppExperiment.connectUserLayer({
	GetFStringAndroidPhoneVerificationLayer(),
	GetFStringIOSPhoneVerificationLayer()
}, function(p19, _) -- line: 759
	-- upvalues: GetFStringAndroidPhoneVerificationLayer (copy), GetFStringIOSPhoneVerificationLayer (copy)
	local v97 = p19[GetFStringAndroidPhoneVerificationLayer()] or {}
	local v98 = p19[GetFStringIOSPhoneVerificationLayer()] or {}

	return {
		isAutofillPhoneNumberEnabled = v97.IsAutofillPhoneNumberEnabled,
		isAutofillSMSOtpEnabled = v97.IsAutofillSMSOtpEnabled,
		isOTPInputTypeEnabled = v98.IsAutofillSMSOtpEnabled,
		isPhoneNumberTextTypeEnabled = v98.IsAutofillPhoneNumberEnabled
	}
end)(v44))
