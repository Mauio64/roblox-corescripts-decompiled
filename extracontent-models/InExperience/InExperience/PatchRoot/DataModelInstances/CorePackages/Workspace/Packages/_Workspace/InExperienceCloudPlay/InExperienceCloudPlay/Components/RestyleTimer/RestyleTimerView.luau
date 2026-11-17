local parent = script:FindFirstAncestor("InExperienceCloudPlay").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local InputSize = Foundation.Enums.InputSize
local Popover = Foundation.Popover
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide
local Text = Foundation.Text
local Toggle = Foundation.Toggle
local View = Foundation.View
local useScaledValue = Foundation.Hooks.useScaledValue
local useTokens = Foundation.Hooks.useTokens

local function RestyleTimerView(props)
	local v = useTokens()
	local v2 = useScaledValue(233)

	local createElement = React.createElement
	local root = Popover.Root
	local v3 = { isOpen = props.isPopoverOpen, testId = "restyle-timer-popover" }

	local createElement2 = React.createElement
	local anchor = Popover.Anchor
	local v4 = { LayoutOrder = props.layoutOrder }

	local createElement3 = React.createElement
	local v5 = {
		tag = "row align-y-center gap-xsmall auto-x padding-x-medium radius-circle bg-over-media-0",
		Size = UDim2.fromOffset(0, props.buttonSize),
		onActivated = props.onChipActivated,
		onAbsoluteSizeChanged = props.onAreaChanged,
		onAbsolutePositionChanged = props.onAreaChanged,
		testId = "restyle-timer"
	}

	local v6 = {
		Label = React.createElement(Text, {
			tag = "auto-xy text-label-small content-emphasis",
			Text = "Restyle",
			LayoutOrder = 1
		}),
		TimeLeft = 0
	}
	local timeLeft

	if props.timeLeft then
		timeLeft = React.createElement(View, { tag = "auto-xy", LayoutOrder = 2 }, {
			Sizer = React.createElement(Text, {
				tag = "auto-xy text-label-small",
				Text = string.gsub(props.timeLeft, "%d", "0"),
				textStyle = { Color3 = v.Color.Content.Muted.Color3, Transparency = 1 },
				testId = "restyle-timer--time-sizer"
			}),
			Value = React.createElement(Text, {
				tag = "size-full text-label-small text-align-x-right content-muted",
				Text = props.timeLeft,
				testId = "restyle-timer--time"
			})
		})
	end

	v6.TimeLeft = timeLeft
	local children = {
		Anchor = createElement2(anchor, v4, { Chip = createElement3(View, v5, v6) }),
		Content = 0
	}

	local createElement4 = React.createElement
	local content = Popover.Content
	local v7 = {
		side = { position = PopoverSide.Bottom, offset = v.Size.Size_300 },
		align = PopoverAlign.Start,
		hasArrow = false,
		backgroundStyle = v.Color.Surface.Surface_200,
		onPressedOutside = props.onPopoverClosed
	}

	local createElement5 = React.createElement
	local v8 = {
		tag = "col gap-small auto-y padding-medium stroke-standard stroke-default radius-medium",
		Size = UDim2.fromOffset(v2, 0)
	}
	local v9 = {
		Description = React.createElement(Text, {
			tag = "size-full-0 auto-y text-caption-small text-wrap text-align-x-left content-muted",
			Text = "Restyle is an early preview. Things may look different from the original game.",
			LayoutOrder = 1
		}),
		TimeLeft = 0,
		Restyle = 0
	}
	local timeLeft2

	if props.timeLeft then
		timeLeft2 = React.createElement(
			View,
			{
				tag = "row flex-x-between align-y-center size-full-0 auto-y padding-medium radius-medium bg-shift-100",
				LayoutOrder = 2
			},
			{
				Label = React.createElement(Text, {
					tag = "auto-xy text-label-small content-default",
					Text = "Time left",
					LayoutOrder = 1
				}),
				Value = React.createElement(Text, {
					tag = "auto-xy text-label-medium content-default",
					Text = props.timeLeft,
					LayoutOrder = 2
				})
			}
		)
	end

	v9.TimeLeft = timeLeft2

	v9.Restyle = React.createElement(
		View,
		{
			tag = "row flex-x-between align-y-center size-full-0 auto-y padding-medium radius-medium bg-shift-100",
			LayoutOrder = 3
		},
		{
			Label = React.createElement(Text, {
				tag = "auto-xy text-label-small content-default",
				Text = "Restyle",
				LayoutOrder = 1
			}),
			Toggle = React.createElement(Toggle, {
				label = "",
				size = InputSize.XSmall,
				isChecked = props.isRestyleEnabled,
				onActivated = props.onRestyleToggled,
				LayoutOrder = 2,
				testId = "restyle-timer-toggle"
			})
		}
	)
	children.Content = createElement4(content, v7, { Body = createElement5(View, v8, v9) })
	return createElement(root, v3, children)
end

return RestyleTimerView
