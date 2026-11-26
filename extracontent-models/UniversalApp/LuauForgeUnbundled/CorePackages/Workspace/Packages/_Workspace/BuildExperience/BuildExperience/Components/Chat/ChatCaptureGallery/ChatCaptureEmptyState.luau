local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local ChatCaptureToolbarIllustration = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatCaptureGallery/ChatCaptureToolbarIllustration")

local text = Foundation.Text
local view = Foundation.View

local function renderStep(k, howToStep)
	return React.createElement(
		view,
		{
			LayoutOrder = k,
			tag = "row align-y-center gap-small size-full-0 auto-y",
			testId = `ChatCaptureEmptyState.Step.{k}`
		},
		{
			Number = React.createElement(
				view,
				{
					LayoutOrder = 1,
					tag = "row align-x-center align-y-center size-600-600 radius-circle bg-shift-200"
				},
				{
					Label = React.createElement(text, {
						Text = tostring(k),
						tag = "auto-xy text-caption-medium content-emphasis"
					})
				}
			),
			Text = React.createElement(text, {
				LayoutOrder = 2,
				Text = howToStep,
				tag = "fill auto-y text-body-medium text-wrap text-align-x-left content-default"
			})
		}
	)
end

local function ChatCaptureEmptyState(props)
	local v5 = {}

	for k, howToStep in props.howToSteps do
		v5[`Step-{k}`] = renderStep(k, howToStep)
	end

	return React.createElement(
		view,
		{
			tag = "col gap-large size-full-0 auto-y padding-bottom-medium",
			testId = "ChatCaptureEmptyState"
		},
		{
			Header = React.createElement(
				view,
				{
					LayoutOrder = 1,
					tag = "col align-x-center gap-xsmall size-full-0 auto-y"
				},
				{
					Title = React.createElement(text, {
						LayoutOrder = 1,
						Text = props.emptyText,
						tag = "size-full-0 auto-y text-heading-small text-wrap text-align-x-center content-emphasis"
					}),
					Description = React.createElement(text, {
						LayoutOrder = 2,
						Text = props.descriptionText,
						tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-center content-muted"
					})
				}
			),
			Illustration = React.createElement(ChatCaptureToolbarIllustration, {
				LayoutOrder = 2,
				layout = props.toolbarLayout
			}),
			Steps = React.createElement(
				view,
				{ LayoutOrder = 3, tag = "col gap-medium size-full-0 auto-y" },
				v5
			)
		}
	)
end

return ChatCaptureEmptyState
