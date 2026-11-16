local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/Localization").Hooks.useLocalization

local icon = Foundation.Icon
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local text = Foundation.Text
local view = Foundation.View

local InlineSurveyLocalizationKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/OnPlatformSurveys/OnPlatformSurveys/Constants/InlineSurveyLocalizationKeys")

local function InviteBanner(p2)
	local v5 = useLocalization({
		title = InlineSurveyLocalizationKeys.inviteTitle,
		body = InlineSurveyLocalizationKeys.inviteBody
	})

	return React.createElement(
		view,
		{
			tag = "row align-y-center gap-medium size-full-0 auto-y padding-medium stroke-standard stroke-default radius-medium bg-surface-100",
			onActivated = p2.onAccept,
			testId = "InlineSurveyInviteBanner"
		},
		{
			Copy = React.createElement(view, {
				tag = "col fill gap-xsmall auto-y",
				LayoutOrder = 1
			}, {
				Title = React.createElement(text, {
					Text = v5.title,
					tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-left content-emphasis",
					LayoutOrder = 1
				}),
				Body = React.createElement(text, {
					Text = v5.body,
					tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default",
					LayoutOrder = 2
				})
			}),
			Chevron = React.createElement(icon, {
				name = iconName.ChevronLargeRight,
				size = iconSize.Medium,
				LayoutOrder = 2
			})
		}
	)
end

return React.memo(InviteBanner)
