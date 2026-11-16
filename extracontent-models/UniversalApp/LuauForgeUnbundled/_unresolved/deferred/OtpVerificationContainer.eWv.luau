local module = require("@luauforge/deferred/egU")
local useSignalState = require("@luauforge/deferred/ehe").useSignalState
local localUserIdStore = require("@luauforge/deferred/ehg").LocalUserIdStore

local module2 = require("@luauforge/deferred/eWw")
local module3 = require("@luauforge/deferred/ehN")
local useSchoolVerificationFlow = require("@luauforge/deferred/ehT").useSchoolVerificationFlow
local module4 = require("@luauforge/deferred/eUy")
local module5 = require("@luauforge/deferred/eUL")
local module6 = require("@luauforge/deferred/eUF")
local module7 = require("@luauforge/deferred/ehV")

local eventNames = module4.EventNames

local function OtpVerificationContainer(p2)
	local navigation = p2.navigation
	local v5 = useSignalState(useSchoolVerificationFlow().getEmail)

	local v6 = useSignalState(localUserIdStore.getCurrentUserId)

	local v7 = module4.useSchoolsAnalytics()

	module.useEffect(function(): nil
		if module7 or not module6 then
			return nil
		end

		v7(eventNames.OtpVerificationPageLoad)
		return nil
	end, { v7 })

	local v8 = module3({
		userId = v6,
		navigation = navigation,
		onCodeSubmitted = module.useCallback(function()
			if module6 then
				v7(eventNames.OtpVerificationEnterCodeClick)
			end
		end, { v7 }),
		onResendRequested = module.useCallback(function()
			if module6 then
				v7(eventNames.OtpVerificationResendCodeClick)
			end
		end, { v7 })
	})

	local v9 = module.useCallback(function()
		navigation.pop()
	end, { navigation })

	local element = module.createElement(module2, {
		userEmail = v5 or "",
		onBack = v9,
		code = v8.code,
		onCodeChanged = v8.onCodeChanged,
		errorKind = v8.errorKind,
		isVerifying = v8.isVerifying,
		isVerifyLocked = v8.isVerifyLocked,
		canResend = v8.canResend,
		resendSecondsRemaining = v8.resendSecondsRemaining,
		isResending = v8.isResending,
		onResend = v8.onResend,
		showVerificationFailedDialog = v8.showVerificationFailedDialog,
		onDismissVerificationFailed = v8.onDismissVerificationFailed
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
