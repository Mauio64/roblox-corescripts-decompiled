local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local chip = Foundation.Chip
local chipSize = Foundation.Enums.ChipSize
local radius = Foundation.Enums.Radius
local scrollView = Foundation.ScrollView
local skeleton = Foundation.Skeleton
local view = Foundation.View
local visibility = Foundation.Enums.Visibility

local function AnimatedChipSlot(props)
	return React.createElement(view, { LayoutOrder = props.index, tag = "auto-xy" }, {
		Skeleton = React.createElement(skeleton, {
			LayoutOrder = props.index,
			Position = UDim2.fromOffset(0, 0),
			radius = radius.Circle,
			Size = UDim2.fromOffset(props.tokens.Size.Size_2800, props.tokens.Size.Size_800),
			Visible = props.animationState.hasStarted:map(function(p2): boolean
				return not p2
			end),
			testId = `PromptChipGroup.Skeleton{props.index}`
		}),
		Chip = React.createElement(
			view,
			{
				GroupTransparency = props.animationState.groupTransparency,
				Visible = props.animationState.hasStarted,
				tag = "auto-xy",
				testId = `PromptChipGroup.Fade{props.index}`
			},
			{
				Content = React.createElement(chip, {
					leading = props.chip.leading,
					onActivated = props.chip.onActivated,
					size = chipSize.Medium,
					text = props.chip.text,
					testId = `PromptChipGroup.Chips--chip-{props.index}`
				})
			}
		)
	})
end

local function AnimatedChipGroupView(props)
	local children = {}

	for k, chip2 in props.chips do
		children[`Chip{k}`] = React.createElement(AnimatedChipSlot, {
			animationState = props.chipAnimationStates[k],
			chip = chip2,
			index = k,
			tokens = props.tokens
		})
	end

	return React.createElement(
		view,
		{
			tag = "size-full-0 auto-y",
			ref = props.chipGroupRef,
			testId = "PromptChipGroup.Chips"
		},
		{
			Scroll = React.createElement(scrollView, {
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
					scrollBarVisibility = visibility.None
				}
			}, children)
		}
	)
end

return AnimatedChipGroupView
