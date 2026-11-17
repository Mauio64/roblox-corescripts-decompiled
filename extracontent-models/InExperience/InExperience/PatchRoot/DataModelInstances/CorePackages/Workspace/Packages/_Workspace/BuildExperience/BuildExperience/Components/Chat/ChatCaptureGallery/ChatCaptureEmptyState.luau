local parent = script:FindFirstAncestor("BuildExperience").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local ChatCaptureToolbarIllustration = require(script.Parent.ChatCaptureToolbarIllustration)

local Text = Foundation.Text
local View = Foundation.View

local function renderStep(k: number, howToStep: string)
	return React.createElement(
		View,
		{
			LayoutOrder = k,
			tag = "row align-y-center gap-small size-full-0 auto-y",
			testId = `ChatCaptureEmptyState.Step.{k}`
		},
		{
			Number = React.createElement(
				View,
				{
					LayoutOrder = 1,
					tag = "row align-x-center align-y-center size-600-600 radius-circle bg-shift-200"
				},
				{
					Label = React.createElement(Text, {
						Text = tostring(k),
						tag = "auto-xy text-caption-medium content-emphasis"
					})
				}
			),
			Text = React.createElement(Text, {
				LayoutOrder = 2,
				Text = howToStep,
				tag = "fill auto-y text-body-medium text-wrap text-align-x-left content-default"
			})
		}
	)
end

local function ChatCaptureEmptyState(props)
	local v = {}

	for k, howToStep in props.howToSteps do
		v[`Step-{k}`] = renderStep(k, howToStep)
	end

	return React.createElement(
		View,
		{
			tag = "col gap-large size-full-0 auto-y padding-bottom-medium",
			testId = "ChatCaptureEmptyState"
		},
		{
			Header = React.createElement(
				View,
				{ LayoutOrder = 1, tag = "col align-x-center gap-xsmall size-full-0 auto-y" },
				{
					Title = React.createElement(Text, {
						LayoutOrder = 1,
						Text = props.emptyText,
						tag = "size-full-0 auto-y text-heading-small text-wrap text-align-x-center content-emphasis"
					}),
					Description = React.createElement(Text, {
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
			Steps = React.createElement(View, {
				LayoutOrder = 3,
				tag = "col gap-medium size-full-0 auto-y"
			}, v)
		}
	)
end

return ChatCaptureEmptyState
