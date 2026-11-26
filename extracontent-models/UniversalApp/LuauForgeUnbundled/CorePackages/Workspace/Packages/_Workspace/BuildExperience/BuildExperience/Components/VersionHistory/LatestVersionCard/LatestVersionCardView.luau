local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local button = Foundation.Button
local text = Foundation.Text
local view = Foundation.View

local buttonVariant = Foundation.Enums.ButtonVariant
local fillBehavior = Foundation.Enums.FillBehavior
local iconName = Foundation.Enums.IconName
local inputSize = Foundation.Enums.InputSize

local function LatestVersionCardView(props)
	local testId = props.testId or "LatestVersionCardView"

	return React.createElement(
		view,
		{
			LayoutOrder = props.layoutOrder,
			tag = "col gap-large size-full-0 auto-y padding-x-large padding-bottom-large padding-top-medium radius-large clip bg-shift-200",
			testId = testId
		},
		{
			Content = React.createElement(
				view,
				{
					LayoutOrder = 1,
					tag = "col gap-xxsmall size-full-0 auto-y",
					testId = `{testId}-content`
				},
				{
					Eyebrow = React.createElement(
						view,
						{
							LayoutOrder = 1,
							tag = "col align-x-left align-y-top gap-xxsmall size-full-0 auto-y",
							testId = `{testId}-eyebrow`
						},
						{
							Version = React.createElement(text, {
								LayoutOrder = 1,
								Text = props.versionLabel,
								tag = "size-full-0 auto-y text-caption-medium text-align-x-left content-muted",
								testId = `{testId}-version`
							}),
							Title = React.createElement(text, {
								LayoutOrder = 2,
								Text = props.title,
								tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-left content-emphasis",
								testId = `{testId}-title`
							})
						}
					),
					Description = React.createElement(text, {
						LayoutOrder = 2,
						Text = props.description,
						tag = "size-full-0 auto-y text-body-small text-wrap text-align-x-left content-emphasis",
						testId = `{testId}-description`
					})
				}
			),
			Actions = React.createElement(
				view,
				{
					LayoutOrder = 2,
					tag = "row gap-small size-full-0 auto-y",
					testId = `{testId}-actions`
				},
				{
					Playtest = React.createElement(button, {
						LayoutOrder = 1,
						text = props.playtestText,
						icon = iconName.PlaySmall,
						size = inputSize.Small,
						variant = buttonVariant.SoftEmphasis,
						fillBehavior = fillBehavior.Fill,
						isDisabled = props.isPlaytestDisabled,
						onActivated = props.onPlaytestActivated,
						testId = `{testId}-playtest`
					}),
					Publish = React.createElement(button, {
						LayoutOrder = 2,
						text = props.publishText,
						size = inputSize.Small,
						variant = buttonVariant.Standard,
						fillBehavior = fillBehavior.Fill,
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
