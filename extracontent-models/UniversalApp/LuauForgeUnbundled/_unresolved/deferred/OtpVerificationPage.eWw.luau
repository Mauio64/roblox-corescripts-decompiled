local module = require("@luauforge/deferred/egU")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceSideSheet/Foundation")
local useLocalization = require("@luauforge/deferred/ehw").Hooks.useLocalization

local module3 = require("@luauforge/deferred/eUX")
local module4 = require("@luauforge/deferred/eWx")
local module5 = require("@luauforge/deferred/egW")
local module6 = require("@luauforge/deferred/ehb")

local view = Foundation.View
local text = Foundation.Text
local textInput = Foundation.TextInput

local inputSize = Foundation.Enums.InputSize

local function OtpVerificationPage(props)
	local v5 = useLocalization({
		headerTitle = module6.AddSchoolHeading,
		heading = module6.OtpHeading,
		body = {
			module6.OtpBody,
			user_email = props.userEmail
		},
		placeholder = module6.OtpPlaceholder,
		resendPrefix = module6.OtpResendPrefix,
		resendAction = module6.OtpResendAction,
		resendCountdown = {
			module6.OtpResendCountdown,
			time = tostring(props.resendSecondsRemaining)
		},
		errorMismatch = module6.OtpErrorInvalid,
		errorExpired = module6.OtpErrorExpired,
		errorInvalidFormat = module6.OtpErrorInvalidFormat,
		errorAlreadyUsed = module6.OtpErrorAlreadyUsed,
		errorTooManyAttempts = module6.OtpErrorTooManyAttempts,
		errorGeneric = module6.SomethingWentWrong
	})

	local v6 = {
		[module5.VerifyErrorKind.OtpMismatch] = v5.errorMismatch,
		[module5.VerifyErrorKind.OtpExpired] = v5.errorExpired,
		[module5.VerifyErrorKind.OtpInvalidFormat] = v5.errorInvalidFormat,
		[module5.VerifyErrorKind.OtpAlreadyUsed] = v5.errorAlreadyUsed,
		[module5.VerifyErrorKind.OtpTooManyAttempts] = v5.errorTooManyAttempts
	}

	local v7 = if props.errorKind ~= nil then v6[props.errorKind] or v5.errorGeneric else nil

	local v8 = props.canResend and not (props.isResending or props.isVerifying)
	local v9 = `<u>{v5.resendAction}</u>`

	if props.resendSecondsRemaining > 0 then
		v9 = v5.resendCountdown
	end

	local createElement = module.createElement
	local fragment = module.Fragment
	local createElement2 = module.createElement
	local v13 = {
		title = v5.headerTitle,
		onBack = props.onBack,
		testId = "schools-otp-verification-page"
	}

	local v14 = {
		HeadingBody = module.createElement(
			view,
			{ LayoutOrder = 1, tag = "col align-x-left size-full-0 auto-y" },
			{
				Heading = module.createElement(text, {
					LayoutOrder = 1,
					Text = v5.heading,
					tag = "size-full-0 auto-y padding-bottom-xsmall text-heading-medium text-wrap text-align-x-left content-default"
				}),
				Body = module.createElement(text, {
					LayoutOrder = 2,
					Text = v5.body,
					tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default"
				})
			}
		),
		Wrapper = 0
	}

	local createElement3 = module.createElement

	local v17 = {
		CodeInput = module.createElement(textInput, {
			LayoutOrder = 1,
			label = "",
			text = props.code,
			placeholder = v5.placeholder,
			width = UDim.new(1, 0),
			size = inputSize.Medium,
			hasClearButton = true,
			hasError = v7 ~= nil,
			hint = v7,
			isDisabled = (props.isVerifying or props.isVerifyLocked) and true or nil,
			onChanged = props.onCodeChanged,
			textInputType = Enum.TextInputType.OneTimePassword
		}),
		Resend = 0
	}

	local createElement4 = module.createElement

	local v20 = {
		Prefix = module.createElement(text, {
			LayoutOrder = 1,
			Text = v5.resendPrefix,
			tag = "auto-xy text-body-small text-align-x-left content-default"
		}),
		Action = 0
	}

	local createElement5 = module.createElement

	local v23 = if v8 then props.onResend else nil
	v20.Action = createElement5(text, {
		LayoutOrder = 2,
		Text = v9,
		RichText = true,
		onActivated = v23,
		tag = {
			["auto-xy text-body-small text-align-x-left"] = true,
			["content-default"] = v8,
			["content-muted"] = not v8
		}
	})
	v17.Resend = createElement4(
		view,
		{ LayoutOrder = 2, tag = "row align-x-left gap-xsmall size-full-0 auto-y" },
		v20
	)
	v14.Wrapper = createElement3(view, {
		LayoutOrder = 2,
		tag = "col gap-large size-full-0 auto-y"
	}, v17)
	local v11 = {
		Page = createElement2(module3, v13, v14),
		VerificationFailedDialog = 0
	}

	local v24 = if props.showVerificationFailedDialog then module.createElement(module4, {
		onDismiss = props.onDismissVerificationFailed
	}) else nil
	v11.VerificationFailedDialog = v24
	return createElement(fragment, nil, v11)
end

return OtpVerificationPage
