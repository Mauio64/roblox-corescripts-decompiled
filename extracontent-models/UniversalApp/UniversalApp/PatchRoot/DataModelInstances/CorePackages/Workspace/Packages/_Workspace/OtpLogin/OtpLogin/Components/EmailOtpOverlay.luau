local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local dependencies = require(ParentParent.dependencies)
local React = dependencies.React
local RoactRodux = dependencies.RoactRodux
local RoactServiceTags = dependencies.RoactServiceTags
local RobloxAppHooks = dependencies.RobloxAppHooks
local useLocalization = dependencies.Localization.Hooks.useLocalization
local NavigateDown = dependencies.NavigationRodux.Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = dependencies.SharedFlags.FFlagSignalsNavP3Dispatch
local v11 = if not FFlagSignalsNavP3Dispatch then nil else require(ParentParentParent.RobloxAppNavigation).NavigationCommands
local CloseCentralOverlay = dependencies.CentralOverlay.Thunks.CloseCentralOverlay
local UserInputService = game:GetService("UserInputService")

require(ParentParent.Common.otpLoginTypes)

local otpLoginConstants = require(ParentParent.Common.otpLoginConstants)
local isStringValidEmail = require(ParentParent.Utils.isStringValidEmail)
local debounce = require(ParentParent.Utils.debounce)
local EnterEmailView = require(script.Parent.EnterEmailView)
local EnterCodeView = require(script.Parent.EnterCodeView)
local SendCode = require(ParentParent.Thunks.SendCode)
local ResendCode = require(ParentParent.Thunks.ResendCode)
local AnalyticsEvents = require(ParentParent.Analytics.AnalyticsEvents)
local EventConstants = require(ParentParent.Analytics.EventConstants)
local v23 = game:DefineFastFlag("ShouldEnableOtpSignup", false)
local useState = React.useState
local _ = {
	EnterEmail = "sendOtp",
	EnterCode = "enterOtp"
}

local function EmailOtpOverlay(t1: {[any]: any}) -- line: 59
	-- upvalues: useLocalization (copy), otpLoginConstants (copy), useState (copy), React (copy), RobloxAppHooks (copy), RoactServiceTags (copy), AnalyticsEvents (copy), EventConstants (copy), debounce (copy), isStringValidEmail (copy), v23 (copy), UserInputService (copy), EnterEmailView (copy), EnterCodeView (copy)
	local v28 = useLocalization({
		enterEmailTitle = t1.enterEmailTitleKey,
		enterEmailDescription = t1.enterEmailDescriptionKey,
		enterCodeTitle = t1.enterCodeTitleKey,
		enterCodeDescription = t1.enterCodeDescriptionKey
	})
	local v29 = useLocalization(otpLoginConstants.errorMessageKeys)
	local v30, v31 = useState("sendOtp")
	local v32, v33 = useState("")
	local v34, v35 = useState("")
	local v36, v37 = useState("")
	local v38, v39 = useState(false)
	local v40, v41 = useState(false)
	local v42, v43 = useState(0)
	local v44 = React.useRef(false)
	local v45 = RobloxAppHooks.useRoactService(RoactServiceTags.RoactNetworking)
	local connection = nil
	local v47 = React.useCallback(function() -- line: 80
		-- upvalues: AnalyticsEvents (copy), EventConstants (copy), t1 (copy), v31 (copy)
		AnalyticsEvents.sendButtonClickEvent(EventConstants.ctx.enterOtp, t1.origin, EventConstants.btn.changeEmail)
		v31("sendOtp")
	end, {
		v31,
		t1.origin
	})
	local v48 = React.useCallback(function() -- line: 85
		-- upvalues: t1 (copy)
		t1.navigateToPage({
			name = "GenericWebPage",
			detail = "https://en.help.roblox.com/hc/articles/11014749736980",
			extraProps = {
				title = "",
				transitionAnimation = "SlideInFromBottom"
			}
		})
	end, { t1.navigateToPage })
	local v49 = React.useCallback(function() -- line: 96
		-- upvalues: v37 (copy)
		v37("")
	end, { v37 })
	local v50 = React.useCallback(debounce(function(p1) -- line: 101
		-- upvalues: AnalyticsEvents (copy), EventConstants (copy), t1 (copy), v49 (copy), v33 (copy), isStringValidEmail (copy), v37 (copy), v29 (copy)
		AnalyticsEvents.sendFormInteractionEvent(EventConstants.ctx.sendOtp, t1.origin, EventConstants.field.email)
		v49()

		if p1.Text then
			v33(p1.Text)

			if not isStringValidEmail(p1.Text) then
				v37(v29.InvalidEmail)
			end
		end
	end, 0.5), {
		v33,
		t1.origin
	})

	local function v51(n1: number?) -- line: 114
		-- upvalues: otpLoginConstants (copy), v29 (copy), v37 (copy), v30 (copy), AnalyticsEvents (copy), t1 (copy), EventConstants (copy)
		local v63 = nil

		if n1 then
			v63 = otpLoginConstants.statusCodeMap[n1]
		end

		if v63 and v29[v63] then
			v37(v29[v63])

			if v30 == "sendOtp" then
				AnalyticsEvents.sendMsgShownEvent(v30, t1.origin, EventConstants.field.errorMessage, n1)

				return
			end

			AnalyticsEvents.sendMsgShownEvent(v30, t1.origin, EventConstants.field.resendErrorMessage, n1)

			return
		end

		v37(v29.Unknown)

		if v30 == "sendOtp" then
			AnalyticsEvents.sendMsgShownEvent(v30, t1.origin, EventConstants.field.errorMessage, 1)

			return
		end

		AnalyticsEvents.sendMsgShownEvent(v30, t1.origin, EventConstants.field.resendErrorMessage, 1)
	end
	local function v52(s1: string) -- line: 150
		-- upvalues: v39 (copy), t1 (copy), otpLoginConstants (copy), v45 (copy), v35 (copy), v31 (copy), v51 (copy)
		v39(true)

		local t2 = {
			origin = t1.origin == "signup" and otpLoginConstants.otpServiceOriginSignup or otpLoginConstants.otpServiceOrigin,
			contactType = otpLoginConstants.otpServiceContactType,
			contactValue = s1
		}
		local v67 = t1.sendCode(v45, t2)

		if v67 then
			v67:andThen(function(p2) -- line: 160
				-- upvalues: v39 (copy), v35 (copy), v31 (copy)
				v39(false)
				v35(p2.otpSessionToken)
				v31("enterOtp")
			end):catch(function(p3) -- line: 165
				-- upvalues: v39 (copy), v51 (copy)
				v39(false)
				v51((tonumber(p3)))
			end)
		end
	end

	local v53 = React.useCallback(function() -- line: 172
		-- upvalues: AnalyticsEvents (copy), EventConstants (copy), t1 (copy), v52 (copy), v32 (copy)
		AnalyticsEvents.sendButtonClickEvent(EventConstants.ctx.sendOtp, t1.origin, EventConstants.btn.sendCode)
		v52(v32)
	end, {
		v32,
		t1.origin
	})

	local function v54(s2: string) -- line: 177
		-- upvalues: t1 (copy), otpLoginConstants (copy), v45 (copy), v35 (copy), v51 (copy)
		local t3 = {
			origin = t1.origin == "signup" and otpLoginConstants.otpServiceOriginSignup or otpLoginConstants.otpServiceOrigin,
			contactType = otpLoginConstants.otpServiceContactType,
			otpSessionToken = s2
		}
		local v70 = t1.resendCode(v45, t3)

		if v70 then
			v70:andThen(function(p4) -- line: 186
				-- upvalues: v35 (copy)
				v35(p4.otpSessionToken)
			end):catch(function(p5) -- line: 189
				-- upvalues: v51 (copy)
				v51((tonumber(p5)))
			end)
		end
	end

	local v55 = React.useCallback(function() -- line: 195
		-- upvalues: AnalyticsEvents (copy), EventConstants (copy), t1 (copy), v54 (copy), v34 (copy)
		AnalyticsEvents.sendButtonClickEvent(EventConstants.ctx.enterOtp, t1.origin, EventConstants.btn.resendCode)
		v54(v34)
	end, {
		v34,
		t1.origin
	})
	local v56 = React.useCallback(function(s3: string) -- line: 200
		-- upvalues: AnalyticsEvents (copy), EventConstants (copy), t1 (copy), v39 (copy), v44 (copy), v34 (copy), v23 (copy), otpLoginConstants (copy), v51 (copy), v37 (copy), v29 (copy)
		AnalyticsEvents.sendButtonClickEvent(EventConstants.ctx.enterOtp, t1.origin, EventConstants.btn.login)
		v39(true)
		v44.current = true

		local v72 = t1.onSubmitCode(v34, s3)

		if v23 then
			if v72 then
				if t1.origin == otpLoginConstants.otpServiceOriginSignup then
					v72:andThen(function() -- line: 214
					end):catch(function(p6) -- line: 217
						-- upvalues: v51 (copy), v44 (copy)
						v51((tonumber(p6)))
						v44.current = false
					end)
				end

				v39(false)

				return
			end
		else
			v72:andThen(function(p7) -- line: 227
				-- upvalues: otpLoginConstants (copy), v37 (copy), v29 (copy), v44 (copy), v39 (copy)
				if p7 and type(p7) == "string" then
					for v84, v85 in otpLoginConstants.errorMessageKeys do
						if p7 == v85 then
							v37(v29[v84])
						end
					end

					v44.current = false
				end

				v39(false)
			end)
		end
	end, {
		v34,
		t1.origin
	})

	local function v57() -- line: 241
		-- upvalues: AnalyticsEvents (copy), v30 (copy), t1 (copy), EventConstants (copy)
		AnalyticsEvents.sendButtonClickEvent(v30, t1.origin, EventConstants.btn.cancel)
		t1.closeCentralOverlay()
	end

	React.useEffect(function() -- line: 246
		-- upvalues: connection (ref), UserInputService (copy), v41 (copy), v43 (copy), v44 (copy), t1 (copy)
		connection = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(function() -- line: 248
			-- upvalues: v41 (copy), UserInputService (copy), v43 (copy)
			v41(UserInputService.OnScreenKeyboardVisible)
			v43(UserInputService.OnScreenKeyboardVisible and UserInputService.OnScreenKeyboardSize.Y or 0)
		end)

		return function() -- line: 255
			-- upvalues: connection (ref), v44 (copy), t1 (copy)
			if connection then
				connection:Disconnect()
			end

			connection = nil

			if not v44.current then
				t1.onModalAbandoned()
			end
		end
	end, {})

	return React.createElement(React.Fragment, nil, {
		EnterEmail = v30 == "sendOtp" and React.createElement(EnterEmailView, {
			origin = t1.origin,
			enterEmailTitle = v28.enterEmailTitle,
			enterEmailDescription = v28.enterEmailDescription,
			email = v32,
			onEmailTextChange = v50,
			errorMessage = v36,
			handleContinue = v53,
			onClose = v57,
			isDisabled = v38,
			isKeyboardShowing = v40,
			keyboardHeight = v42,
			screenSize = t1.screenSize
		}),
		EnterCode = v30 == "enterOtp" and React.createElement(EnterCodeView, {
			origin = t1.origin,
			enterCodeTitle = v28.enterCodeTitle,
			enterCodeDescription = v28.enterCodeDescription,
			email = v32,
			errorMessage = v36,
			clearErrorMessage = v49,
			onResendCode = v55,
			onSubmitCode = v56,
			complianceCheckboxMessageKey = t1.complianceCheckboxMessageKey,
			returnToEnterEmail = v47,
			navigateToHelp = v48,
			onClose = v57,
			isDisabled = v38,
			isKeyboardShowing = v40,
			keyboardHeight = v42,
			screenSize = t1.screenSize
		})
	})
end

return (RoactRodux.connect(function(p8, _) -- line: 302
	return {
		screenSize = p8.screenSize
	}
end, function(p10) -- line: 306
	-- upvalues: SendCode (copy), ResendCode (copy), FFlagSignalsNavP3Dispatch (copy), v11 (copy), NavigateDown (copy), CloseCentralOverlay (copy)
	return {
		sendCode = function(p11, p12) -- line: 308
			-- upvalues: p10 (copy), SendCode (copy)
			return p10(SendCode(p11, p12))
		end,
		resendCode = function(p13, p14) -- line: 311
			-- upvalues: p10 (copy), ResendCode (copy)
			return p10(ResendCode(p13, p14))
		end,
		navigateToPage = function(p15) -- line: 314
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v11 (copy), p10 (copy), NavigateDown (copy)
			if FFlagSignalsNavP3Dispatch then
				return v11.down(v11.fromLegacyPage(p15))
			end

			return p10(NavigateDown(p15))
		end,
		closeCentralOverlay = function() -- line: 321
			-- upvalues: p10 (copy), CloseCentralOverlay (copy)
			return p10(CloseCentralOverlay())
		end
	}
end)(EmailOtpOverlay))
