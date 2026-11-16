local parent = script:FindFirstAncestor("BuildExperience").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Button = Foundation.Button
local Text = Foundation.Text
local View = Foundation.View

local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize

local function LatestVersionCardView(props)
	local testId = props.testId or "LatestVersionCardView"

	return React.createElement(
		View,
		{
			LayoutOrder = props.layoutOrder,
			tag = "col gap-large size-full-0 auto-y padding-x-large padding-bottom-large padding-top-medium radius-large clip bg-shift-200",
			testId = testId
		},
		{
			Content = React.createElement(
				View,
				{
					LayoutOrder = 1,
					tag = "col gap-xxsmall size-full-0 auto-y",
					testId = `{testId}-content`
				},
				{
					Eyebrow = React.createElement(
						View,
						{
							LayoutOrder = 1,
							tag = "col align-x-left align-y-top gap-xxsmall size-full-0 auto-y",
							testId = `{testId}-eyebrow`
						},
						{
							Version = React.createElement(Text, {
								LayoutOrder = 1,
								Text = props.versionLabel,
								tag = "size-full-0 auto-y text-caption-medium text-align-x-left content-muted",
								testId = `{testId}-version`
							}),
							Title = React.createElement(Text, {
								LayoutOrder = 2,
								Text = props.title,
								tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-left content-emphasis",
								testId = `{testId}-title`
							})
						}
					),
					Description = React.createElement(Text, {
						LayoutOrder = 2,
						Text = props.description,
						tag = "size-full-0 auto-y text-body-small text-wrap text-align-x-left content-emphasis",
						testId = `{testId}-description`
					})
				}
			),
			Actions = React.createElement(
				View,
				{
					LayoutOrder = 2,
					tag = "row gap-small size-full-0 auto-y",
					testId = `{testId}-actions`
				},
				{
					Playtest = React.createElement(Button, {
						LayoutOrder = 1,
						text = props.playtestText,
						icon = IconName.PlaySmall,
						size = InputSize.Small,
						variant = ButtonVariant.SoftEmphasis,
						fillBehavior = FillBehavior.Fill,
						isDisabled = props.isPlaytestDisabled,
						onActivated = props.onPlaytestActivated,
						testId = `{testId}-playtest`
					}),
					Publish = React.createElement(Button, {
						LayoutOrder = 2,
						text = props.publishText,
						size = InputSize.Small,
						variant = ButtonVariant.Standard,
						fillBehavior = FillBehavior.Fill,
						isDisabled = props.isPublishDisabled,
						onActivated = props.onPublishActivated,
						testId = `{testId}-publish`
					})
				}
			)
		}
	)
end

return LatestVersionCardView
