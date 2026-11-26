local module = require("@luauforge/deferred/eko")
local useSignalState = require("@luauforge/deferred/eky").useSignalState
local localUserIdStore = require("@luauforge/deferred/ekA").LocalUserIdStore

local module2 = require("@luauforge/deferred/fdv")
local module3 = require("@luauforge/deferred/elh")
local useSchoolVerificationFlow = require("@luauforge/deferred/eln").useSchoolVerificationFlow
local module4 = require("@luauforge/deferred/fbx")
local module5 = require("@luauforge/deferred/fbK")
local module6 = require("@luauforge/deferred/fbE")
local module7 = require("@luauforge/deferred/elp")

local eventNames = module4.EventNames

local function OtpVerificationContainer(p2)
	local navigation = p2.navigation
	local v6 = useSignalState(useSchoolVerificationFlow().getEmail)

	local v7 = useSignalState(localUserIdStore.getCurrentUserId)

	local v8 = module4.useSchoolsAnalytics()

	module.useEffect(function(): nil
		if module7 or not module6 then
			return nil
		end

		v8(eventNames.OtpVerificationPageLoad)
		return nil
	end, { v8 })

	local v11 = module3({
		userId = v7,
		navigation = navigation,
		onCodeSubmitted = module.useCallback(function()
			if module6 then
				v8(eventNames.OtpVerificationEnterCodeClick)
			end
		end, { v8 }),
		onResendRequested = module.useCallback(function()
			if module6 then
				v8(eventNames.OtpVerificationResendCodeClick)
			end
		end, { v8 })
	})

	local v12 = module.useCallback(function()
		navigation.pop()
	end, { navigation })

	local element = module.createElement(module2, {
		userEmail = v6 or "",
		onBack = v12,
		code = v11.code,
		onCodeChanged = v11.onCodeChanged,
		errorKind = v11.errorKind,
		isVerifying = v11.isVerifying,
		isVerifyLocked = v11.isVerifyLocked,
		canResend = v11.canResend,
		resendSecondsRemaining = v11.resendSecondsRemaining,
		isResending = v11.isResending,
		onResend = v11.onResend,
		showVerificationFailedDialog = v11.showVerificationFailedDialog,
		onDismissVerificationFailed = v11.onDismissVerificationFailed
	})

	if module7 and module6 then
		return module.createElement(module.Fragment, nil, {
			PageLoad = module.createElement(module5, {
				eventName = eventNames.OtpVerificationPageLoad
			}),
			Page = element
		})
	end

	return element
end

return OtpVerificationContainer
