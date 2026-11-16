local OnPlatformSurveys = script:FindFirstAncestor("OnPlatformSurveys")
local parent = OnPlatformSurveys.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local Icon = Foundation.Icon
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local Text = Foundation.Text
local View = Foundation.View

local InlineSurveyLocalizationKeys = require(OnPlatformSurveys.Constants.InlineSurveyLocalizationKeys)

local function InviteBanner(p)
	local v = useLocalization({
		title = InlineSurveyLocalizationKeys.inviteTitle,
		body = InlineSurveyLocalizationKeys.inviteBody
	})

	return React.createElement(
		View,
		{
			tag = "row align-y-center gap-medium size-full-0 auto-y padding-medium stroke-standard stroke-default radius-medium bg-surface-100",
			onActivated = p.onAccept,
			testId = "InlineSurveyInviteBanner"
		},
		{
			Copy = React.createElement(View, { tag = "col fill gap-xsmall auto-y", LayoutOrder = 1 }, {
				Title = React.createElement(Text, {
					Text = v.title,
					tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-left content-emphasis",
					LayoutOrder = 1
				}),
				Body = React.createElement(Text, {
					Text = v.body,
					tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default",
					LayoutOrder = 2
				})
			}),
			Chevron = React.createElement(Icon, {
				name = IconName.ChevronLargeRight,
				size = IconSize.Medium,
				LayoutOrder = 2
			})
		}
	)
end

return React.memo(InviteBanner)
