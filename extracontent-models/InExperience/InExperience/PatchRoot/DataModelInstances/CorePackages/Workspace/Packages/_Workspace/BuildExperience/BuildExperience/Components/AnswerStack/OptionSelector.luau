local parent = script:FindFirstAncestor("BuildExperience").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Text = Foundation.Text
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local v = { affordance = Foundation.Enums.StateLayerAffordance.None }

local function OptionSelector(props)
	local v2 = useTokens()
	local isSelected = props.isSelected == true
	local selectionStyle = props.selectionStyle or "committed"
	local tag = isSelected
		and selectionStyle == "intermediate"
		and "col gap-large size-full-0 auto-y padding-large stroke-standard stroke-contrast radius-large bg-surface-0"
		or "col gap-large size-full-0 auto-y padding-large stroke-standard stroke-default radius-large bg-surface-0"
	local createElement = React.createElement
	local v3 = {
		LayoutOrder = props.LayoutOrder,
		onActivated = props.onActivated,
		stateLayer = 0,
		testId = 0,
		tag = 0,
		ZIndex = 3
	}
	local stateLayer

	if isSelected and selectionStyle == "committed" then
		stateLayer = v
	end

	v3.stateLayer = stateLayer
	v3.testId = props.testId
	v3.tag = tag
	local element = createElement(View, v3, {
		Content = React.createElement(View, { LayoutOrder = 1, tag = "col size-full-0 auto-y" }, {
			Title = React.createElement(Text, {
				LayoutOrder = 1,
				Text = props.title,
				tag = "size-full-0 auto-y text-title-small text-wrap text-align-x-left content-emphasis"
			}),
			Description = React.createElement(Text, {
				LayoutOrder = 2,
				Text = props.description,
				tag = "size-full-0 auto-y text-body-small text-wrap text-align-x-left content-default"
			})
		})
	})

	if isSelected and selectionStyle == "committed" then
		return React.createElement(View, {
			LayoutOrder = props.LayoutOrder,
			tag = "col size-full-0 auto-y"
		}, {
			Card = React.cloneElement(element, { LayoutOrder = 1 }),
			StackLayers = React.createElement(View, {
				LayoutOrder = 2,
				tag = "size-full-400",
				ZIndex = 1
			}, {
				FirstLayer = React.createElement(View, {
					Position = UDim2.new(0, v2.Size.Size_400, 0, -v2.Size.Size_200),
					Size = UDim2.new(1, -2 * v2.Size.Size_400, 0, v2.Size.Size_400),
					tag = "stroke-standard stroke-default radius-medium bg-surface-0",
					ZIndex = 2
				}),
				SecondLayer = React.createElement(View, {
					Position = UDim2.new(0, v2.Size.Size_800, 0, 0),
					Size = UDim2.new(1, -2 * v2.Size.Size_800, 0, v2.Size.Size_400),
					tag = "stroke-standard stroke-default radius-medium bg-surface-0",
					ZIndex = 1
				})
			})
		})
	end

	return element
end

return OptionSelector
