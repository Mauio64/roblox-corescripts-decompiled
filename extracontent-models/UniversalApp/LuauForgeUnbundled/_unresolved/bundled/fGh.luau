local module = require("@luauforge/bundled/fGi")
local react = module.React
local roactRodux = module.RoactRodux
local roactServiceTags = module.RoactServiceTags
local robloxAppHooks = module.RobloxAppHooks
local useLocalization = module.Localization.Hooks.useLocalization
local navigateDown = module.NavigationRodux.Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = module.SharedFlags.FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/fGy").NavigationCommands else nil

local closeCentralOverlay = module.CentralOverlay.Thunks.CloseCentralOverlay
local UserInputService = game:GetService("UserInputService")

require("@luauforge/bundled/fGz")
local module2 = require("@luauforge/bundled/fGA")

local module3 = require("@luauforge/bundled/fGB")
local module4 = require("@luauforge/bundled/fGC")

local module5 = require("@luauforge/bundled/fGD")
local module6 = require("@luauforge/bundled/fGH")
local module7 = require("@luauforge/bundled/fGI")
local module8 = require("@luauforge/bundled/fGM")

local module9 = require("@luauforge/bundled/fGF")
local module10 = require("@luauforge/bundled/fGG")
local defineFastFlag = game:DefineFastFlag("ShouldEnableOtpSignup", false)

local useState = react.useState

local v5 = { EnterEmail = "sendOtp", EnterCode = "enterOtp" }

local function EmailOtpOverlay(props)
	local v6 = useLocalization({
		enterEmailTitle = props.enterEmailTitleKey,
		enterEmailDescription = props.enterEmailDescriptionKey,
		enterCodeTitle = props.enterCodeTitleKey,
		enterCodeDescription = props.enterCodeDescriptionKey
	})

	local v7 = useLocalization(module2.errorMessageKeys)
	local state, setState = useState("sendOtp")
	local state2, setState2 = useState("")
	local state3, setState3 = useState("")
	local state4, setState4 = useState("")
	local state5, setState5 = useState(false)
	local state6, setState6 = useState(false)
	local state7, setState7 = useState(0)
	local ref = react.useRef(false)

	local v8 = robloxAppHooks.useRoactService(roactServiceTags.RoactNetworking)

	local onScreenKeyboardVisibleChangedConnection = nil

	local v9 = react.useCallback(function()
		module9.sendButtonClickEvent(module10.ctx.enterOtp, props.origin, module10.btn.changeEmail)
		setState("sendOtp")
	end, { setState, props.origin })

	local v10 = react.useCallback(function()
		props.navigateToPage({
			name = "GenericWebPage",
			detail = "https://en.help.roblox.com/hc/articles/11014749736980",
			extraProps = { title = "", transitionAnimation = "SlideInFromBottom" }
		})
	end, { props.navigateToPage })

	local v11 = react.useCallback(function()
		setState4("")
	end, { setState4 })

	local v12 = react.useCallback(module4(function(p2)
		module9.sendFormInteractionEvent(module10.ctx.sendOtp, props.origin, module10.field.email)
		v11()

		if p2.Text then
			setState2(p2.Text)

			if not module3(p2.Text) then
				setState4(v7.InvalidEmail)
			end
		end
	end, 0.5), { setState2, props.origin })

	local function fn(p2)
		local v13 = if p2 then module2.statusCodeMap[p2] else nil

		if v13 and v7[v13] then
			setState4(v7[v13])

			if state == "sendOtp" then
				module9.sendMsgShownEvent(state, props.origin, module10.field.errorMessage, p2)
			else
				module9.sendMsgShownEvent(state, props.origin, module10.field.resendErrorMessage, p2)
			end
		else
			setState4(v7.Unknown)

			if state == "sendOtp" then
				module9.sendMsgShownEvent(state, props.origin, module10.field.errorMessage, 1)
			else
				module9.sendMsgShownEvent(state, props.origin, module10.field.resendErrorMessage, 1)
			end
		end
	end

	local function fn2(state8)
		setState5(true)
		local v13 = {
			origin = props.origin == "signup" and module2.otpServiceOriginSignup or module2.otpServiceOrigin,
			contactType = module2.otpServiceContactType,
			contactValue = state8
		}

		local v14 = props.sendCode(v8, v13)

		if v14 then
			v14:andThen(function(p2)
				setState5(false)
				setState3(p2.otpSessionToken)
				setState("enterOtp")
			end):catch(function(p2)
				setState5(false)
				fn(tonumber(p2))
			end)
		end
	end

	local v13 = react.useCallback(function()
		module9.sendButtonClickEvent(module10.ctx.sendOtp, props.origin, module10.btn.sendCode)
		fn2(state2)
	end, { state2, props.origin })

	local function fn3(state8)
		local v14 = {
			origin = props.origin == "signup" and module2.otpServiceOriginSignup or module2.otpServiceOrigin,
			contactType = module2.otpServiceContactType,
			otpSessionToken = state8
		}

		local resendCode = props.resendCode(v8, v14)

		if resendCode then
			resendCode:andThen(function(p2)
				setState3(p2.otpSessionToken)
			end):catch(function(p2)
				fn(tonumber(p2))
			end)
		end
	end

	local v14 = react.useCallback(function()
		module9.sendButtonClickEvent(module10.ctx.enterOtp, props.origin, module10.btn.resendCode)
		fn3(state3)
	end, { state3, props.origin })

	local v15 = react.useCallback(function(p2)
		module9.sendButtonClickEvent(module10.ctx.enterOtp, props.origin, module10.btn.login)
		setState5(true)
		ref.current = true
		local v16 = props.onSubmitCode(state3, p2)

		if defineFastFlag then
			if v16 then
				if props.origin == module2.otpServiceOriginSignup then
					v16:andThen(function() end):catch(function(p3)
						fn(tonumber(p3))
						ref.current = false
					end)
				end

				setState5(false)
			end
		else
			v16:andThen(function(value)
				if value and type(value) == "string" then
					for k, errorMessageKey in module2.errorMessageKeys do
						if value == errorMessageKey then
							setState4(v7[k])
						end
					end

					ref.current = false
				end

				setState5(false)
			end)
		end
	end, { state3, props.origin })

	local function onClose()
		module9.sendButtonClickEvent(state, props.origin, module10.btn.cancel)
		props.closeCentralOverlay()
	end

	react.useEffect(function()
		onScreenKeyboardVisibleChangedConnection = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(function()
			setState6(UserInputService.OnScreenKeyboardVisible)
			setState7(UserInputService.OnScreenKeyboardVisible and UserInputService.OnScreenKeyboardSize.Y or 0)
		end)

		return function()
			if onScreenKeyboardVisibleChangedConnection then
				onScreenKeyboardVisibleChangedConnection:Disconnect()
			end

			onScreenKeyboardVisibleChangedConnection = nil

			if not ref.current then
				props.onModalAbandoned()
			end
		end
	end, {})

	return react.createElement(react.Fragment, nil, {
		EnterEmail = state == "sendOtp" and react.createElement(module5, {
			origin = props.origin,
			enterEmailTitle = v6.enterEmailTitle,
			enterEmailDescription = v6.enterEmailDescription,
			email = state2,
			onEmailTextChange = v12,
			errorMessage = state4,
			handleContinue = v13,
			onClose = onClose,
			isDisabled = state5,
			isKeyboardShowing = state6,
			keyboardHeight = state7,
			screenSize = props.screenSize
		}),
		EnterCode = state == "enterOtp" and react.createElement(module6, {
			origin = props.origin,
			enterCodeTitle = v6.enterCodeTitle,
			enterCodeDescription = v6.enterCodeDescription,
			email = state2,
			errorMessage = state4,
			clearErrorMessage = v11,
			onResendCode = v14,
			onSubmitCode = v15,
			complianceCheckboxMessageKey = props.complianceCheckboxMessageKey,
			returnToEnterEmail = v9,
			navigateToHelp = v10,
			onClose = onClose,
			isDisabled = state5,
			isKeyboardShowing = state6,
			keyboardHeight = state7,
			screenSize = props.screenSize
		})
	})
end

return (roactRodux.connect(function(p2, p3)
	return { screenSize = p2.screenSize }
end, function(callback)
	return {
		sendCode = function(p2, p3)
			return callback(module7(p2, p3))
		end,
		resendCode = function(p2, p3)
			return callback(module8(p2, p3))
		end,
		navigateToPage = function(p2)
			if fFlagSignalsNavP3Dispatch then
				return navigationCommands.down(navigationCommands.fromLegacyPage(p2))
			end

			return callback(navigateDown(p2))
		end,
		closeCentralOverlay = function()
			return callback(closeCentralOverlay())
		end
	}
end)(EmailOtpOverlay))
