local module = require("@luauforge/deferred/eko")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceSideSheet/Foundation")
local useLocalization = require("@luauforge/deferred/ekQ").Hooks.useLocalization

local module3 = require("@luauforge/deferred/fbW")
local module4 = require("@luauforge/deferred/fcs")
local module5 = require("@luauforge/deferred/ekv")
local module6 = require("@luauforge/deferred/ekL")
local module7 = require("@luauforge/deferred/fct")

local view = Foundation.View
local text = Foundation.Text
local button = Foundation.Button
local textInput = Foundation.TextInput

local buttonVariant = Foundation.Enums.ButtonVariant
local inputSize = Foundation.Enums.InputSize

local function VerifyEmailPage(props)
	local v6 = {
		headerTitle = module5.AddSchoolHeading,
		heading = module5.VerifyEmailHeading,
		body = module5.VerifyEmailBody,
		unidaysTerms = module5.VerifyEmailUnidaysTerms,
		continueAction = module5.ActionContinue,
		termsOfService = module5.VerifyEmailUnidaysTermsOfService,
		privacyPolicy = module5.VerifyEmailUnidaysPrivacyPolicy,
		emailPlaceholder = module5.VerifyEmailPlaceholder,
		noSchoolEmailAction = 0
	}

	local v7 = if module7 then module5.VerifyEmailNoSchoolEmailAction else nil
	v6.noSchoolEmailAction = v7
	local v8 = useLocalization(v6)

	local v9 = props.email:match("%S") ~= nil
	local createElement = module.createElement
	local v11 = {
		title = v8.headerTitle,
		onBack = props.onBack,
		testId = "schools-verify-email-page"
	}

	local v12 = {
		HeadingBody = module.createElement(
			view,
			{ LayoutOrder = 1, tag = "col align-x-left size-full-0 auto-y" },
			{
				Heading = module.createElement(text, {
					LayoutOrder = 1,
					Text = v8.heading,
					tag = "size-full-0 auto-y padding-bottom-xsmall text-heading-medium text-wrap text-align-x-left content-default"
				}),
				Body = module.createElement(text, {
					LayoutOrder = 2,
					Text = v8.body,
					tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default"
				})
			}
		),
		Wrapper = 0
	}

	local createElement2 = module.createElement

	local v15 = {
		EmailInput = module.createElement(textInput, {
			LayoutOrder = 1,
			label = "",
			text = props.email,
			placeholder = v8.emailPlaceholder,
			width = UDim.new(1, 0),
			size = inputSize.Medium,
			hasError = props.errorMessage ~= nil,
			hint = props.errorMessage or props.suggestedEmailMessage,
			hasClearButton = true,
			onChanged = props.onEmailChanged,
			onReturnPressed = props.onContinue
		}),
		UnidaysTerms = module.createElement(text, {
			LayoutOrder = 2,
			Text = v8.unidaysTerms,
			tag = "size-full-0 auto-y text-caption-medium text-wrap text-align-x-left content-muted"
		}),
		Continue = module.createElement(button, {
			LayoutOrder = 3,
			text = v8.continueAction,
			size = inputSize.Medium,
			variant = buttonVariant.Emphasis,
			width = UDim.new(1, 0),
			isLoading = props.isSubmitting,
			isDisabled = props.isSubmitting or not v9,
			onActivated = props.onContinue
		}),
		Links = module.createElement(
			view,
			{
				LayoutOrder = 4,
				tag = "row wrap align-x-center gap-xlarge size-full-0 auto-y"
			},
			{
				TermsOfService = module.createElement(text, {
					LayoutOrder = 1,
					Text = `<u>{v8.termsOfService}</u>`,
					RichText = true,
					onActivated = props.onTermsOfService,
					tag = "auto-xy text-body-small content-emphasis"
				}),
				PrivacyPolicy = module.createElement(text, {
					LayoutOrder = 2,
					Text = `<u>{v8.privacyPolicy}</u>`,
					RichText = true,
					onActivated = props.onPrivacyPolicy,
					tag = "auto-xy text-body-small content-emphasis"
				})
			}
		),
		NoSchoolEmail = 0,
		SchoolInterestSheet = 0
	}

	local v16 = if module7 and props.onNoSchoolEmail then module.createElement(
		view,
		{ LayoutOrder = 5, tag = "row align-x-center size-full-0 auto-y" },
		{
			Action = module.createElement(text, {
				Text = v8.noSchoolEmailAction,
				onActivated = props.onNoSchoolEmail,
				testId = "schools-verify-email-no-school-email",
				tag = "auto-xy text-title-medium content-emphasis"
			})
		}
	) else nil
	v15.NoSchoolEmail = v16

	local v17 = if module7 then props.schoolInterestSheet else nil
	v15.SchoolInterestSheet = v17
	v12.Wrapper = createElement2(view, {
		LayoutOrder = 2,
		tag = "col gap-large size-full-0 auto-y"
	}, v15)
	local element = createElement(module3, v11, v12)

	if not module6 then
		return element
	end

	local createElement3 = module.createElement
	local fragment = module.Fragment

	local v20 = if props.showSchoolUnavailableDialog and props.onDismissSchoolUnavailable then module.createElement(module4, {
		onDismiss = props.onDismissSchoolUnavailable
	}) else nil
	return createElement3(fragment, nil, {
		Page = element,
		SchoolUnavailableDialog = v20
	})
end

return VerifyEmailPage
