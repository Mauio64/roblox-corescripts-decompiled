local Schools = script:FindFirstAncestor("Schools")
local SchoolsParent = Schools.Parent
local React = require(SchoolsParent.React)
local Foundation = require(SchoolsParent.Foundation)
local useLocalization = require(SchoolsParent.Localization).Hooks.useLocalization
local SchoolsPage = require(Schools.Components.Common.SchoolsPage)
local TextKeys = require(Schools.Common.TextKeys)
local View = Foundation.View
local FoundationText = Foundation.Text
local Button = Foundation.Button
local TextInput = Foundation.TextInput
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize

local function VerifyEmailPage(t1: {[any]: any}) -- line: 30
	-- upvalues: useLocalization (copy), TextKeys (copy), React (copy), SchoolsPage (copy), View (copy), FoundationText (copy), TextInput (copy), InputSize (copy), Button (copy), ButtonVariant (copy)
	local v16 = useLocalization({
		headerTitle = TextKeys.VerifyEmailHeaderTitle,
		heading = TextKeys.VerifyEmailHeading,
		body = TextKeys.VerifyEmailBody,
		learnMore = TextKeys.VerifyEmailLearnMore,
		unidaysTerms = TextKeys.VerifyEmailUnidaysTerms,
		continueAction = TextKeys.VerifyEmailActionContinue,
		termsOfService = TextKeys.TermsOfService,
		privacyPolicy = TextKeys.PrivacyPolicy,
		emailPlaceholder = TextKeys.VerifyEmailPlaceholder
	})

	return React.createElement(SchoolsPage, {
		testId = "schools-verify-email-page",
		title = v16.headerTitle,
		onBack = t1.onBack
	}, {
		HeadingBody = React.createElement(View, {
			LayoutOrder = 1,
			tag = "col align-x-left size-full-0 auto-y"
		}, {
			Heading = React.createElement(FoundationText, {
				LayoutOrder = 1,
				tag = "size-full-0 auto-y padding-bottom-xsmall text-heading-medium text-wrap text-align-x-left content-default",
				Text = v16.heading
			}),
			Body = React.createElement(FoundationText, {
				LayoutOrder = 2,
				tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default",
				Text = v16.body
			}),
			LearnMore = React.createElement(FoundationText, {
				LayoutOrder = 3,
				RichText = true,
				tag = "auto-xy text-body-medium content-default",
				Text = `<u>{ v16.learnMore }</u>`,
				onActivated = t1.onLearnMore
			})
		}),
		Wrapper = React.createElement(View, {
			LayoutOrder = 2,
			tag = "col gap-large size-full-0 auto-y"
		}, {
			EmailInput = React.createElement(TextInput, {
				LayoutOrder = 1,
				label = "",
				text = t1.email,
				placeholder = v16.emailPlaceholder,
				width = UDim.new(1, 0),
				size = InputSize.Medium,
				hasError = t1.errorMessage ~= nil,
				hint = t1.errorMessage,
				onChanged = t1.onEmailChanged
			}),
			UnidaysTerms = React.createElement(FoundationText, {
				LayoutOrder = 2,
				tag = "size-full-0 auto-y text-caption-medium text-wrap text-align-x-left content-muted",
				Text = v16.unidaysTerms
			}),
			Continue = React.createElement(Button, {
				LayoutOrder = 3,
				text = v16.continueAction,
				size = InputSize.Medium,
				variant = ButtonVariant.Emphasis,
				width = UDim.new(1, 0),
				onActivated = t1.onContinue
			}),
			Links = React.createElement(View, {
				LayoutOrder = 4,
				tag = "row align-x-center gap-xlarge size-full-0 auto-y"
			}, {
				TermsOfService = React.createElement(FoundationText, {
					LayoutOrder = 1,
					RichText = true,
					tag = "auto-xy text-body-medium content-emphasis",
					Text = `<u>{ v16.termsOfService }</u>`,
					onActivated = t1.onTermsOfService
				}),
				PrivacyPolicy = React.createElement(FoundationText, {
					LayoutOrder = 2,
					RichText = true,
					tag = "auto-xy text-body-medium content-emphasis",
					Text = `<u>{ v16.privacyPolicy }</u>`,
					onActivated = t1.onPrivacyPolicy
				})
			})
		})
	})
end

return VerifyEmailPage
