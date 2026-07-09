local OnPlatformSurveys = script:FindFirstAncestor("OnPlatformSurveys")
local OnPlatformSurveysParent = OnPlatformSurveys.Parent
local Foundation = require(OnPlatformSurveysParent.Foundation)
local React = require(OnPlatformSurveysParent.React)
local useLocalization = require(OnPlatformSurveysParent.Localization).Hooks.useLocalization
local Icon = Foundation.Icon
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local FoundationText = Foundation.Text
local View = Foundation.View
local InlineSurveyLocalizationKeys = require(OnPlatformSurveys.Constants.InlineSurveyLocalizationKeys)

local function InviteBanner(t1: {[any]: any}) -- line: 21
	-- upvalues: useLocalization (copy), InlineSurveyLocalizationKeys (copy), React (copy), View (copy), FoundationText (copy), Icon (copy), IconName (copy), IconSize (copy)
	local v14 = useLocalization({
		title = InlineSurveyLocalizationKeys.inviteTitle,
		body = InlineSurveyLocalizationKeys.inviteBody
	})

	return React.createElement(View, {
		tag = "row align-y-center gap-medium size-full-0 auto-y padding-medium stroke-standard stroke-default radius-medium bg-surface-100",
		testId = "InlineSurveyInviteBanner",
		onActivated = t1.onAccept
	}, {
		Copy = React.createElement(View, {
			tag = "col fill gap-xsmall auto-y",
			LayoutOrder = 1
		}, {
			Title = React.createElement(FoundationText, {
				tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-left content-emphasis",
				LayoutOrder = 1,
				Text = v14.title
			}),
			Body = React.createElement(FoundationText, {
				tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default",
				LayoutOrder = 2,
				Text = v14.body
			})
		}),
		Chevron = React.createElement(Icon, {
			LayoutOrder = 2,
			name = IconName.ChevronLargeRight,
			size = IconSize.Medium
		})
	})
end

return React.memo(InviteBanner)
