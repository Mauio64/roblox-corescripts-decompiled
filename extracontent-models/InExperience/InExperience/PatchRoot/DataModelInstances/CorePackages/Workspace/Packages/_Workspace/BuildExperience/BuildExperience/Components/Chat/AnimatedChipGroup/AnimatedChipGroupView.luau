local parent = script:FindFirstAncestor("BuildExperience").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Chip = Foundation.Chip
local ChipSize = Foundation.Enums.ChipSize
local Radius = Foundation.Enums.Radius
local ScrollView = Foundation.ScrollView
local Skeleton = Foundation.Skeleton
local View = Foundation.View
local Visibility = Foundation.Enums.Visibility

local function AnimatedChipSlot(props)
	return React.createElement(View, { LayoutOrder = props.index, tag = "auto-xy" }, {
		Skeleton = React.createElement(Skeleton, {
			LayoutOrder = props.index,
			Position = UDim2.fromOffset(0, 0),
			radius = Radius.Circle,
			Size = UDim2.fromOffset(props.tokens.Size.Size_2800, props.tokens.Size.Size_800),
			Visible = props.animationState.hasStarted:map(function(p): boolean
				return not p
			end),
			testId = `PromptChipGroup.Skeleton{props.index}`
		}),
		Chip = React.createElement(
			View,
			{
				GroupTransparency = props.animationState.groupTransparency,
				Visible = props.animationState.hasStarted,
				tag = "auto-xy",
				testId = `PromptChipGroup.Fade{props.index}`
			},
			{
				Content = React.createElement(Chip, {
					leading = props.chip.leading,
					onActivated = props.chip.onActivated,
					size = ChipSize.Medium,
					text = props.chip.text,
					testId = `PromptChipGroup.Chips--chip-{props.index}`
				})
			}
		)
	})
end

local function AnimatedChipGroupView(props)
	local children = {}

	for k, chip in props.chips do
		children[`Chip{k}`] = React.createElement(AnimatedChipSlot, {
			animationState = props.chipAnimationStates[k],
			chip = chip,
			index = k,
			tokens = props.tokens
		})
	end

	return React.createElement(
		View,
		{ tag = "size-full-0 auto-y", ref = props.chipGroupRef, testId = "PromptChipGroup.Chips" },
		{
			Scroll = React.createElement(ScrollView, {
				tag = "size-full-0 auto-y",
				layout = {
					FillDirection = Enum.FillDirection.Horizontal,
					Padding = UDim.new(0, props.tokens.Padding.Small)
				},
				scroll = {
					AutomaticSize = Enum.AutomaticSize.Y,
					AutomaticCanvasSize = Enum.AutomaticSize.X,
					CanvasSize = UDim2.fromScale(0, 1),
					ScrollingDirection = Enum.ScrollingDirection.X,
					scrollBarVisibility = Visibility.None
				}
			}, children)
		}
	)
end

return AnimatedChipGroupView
