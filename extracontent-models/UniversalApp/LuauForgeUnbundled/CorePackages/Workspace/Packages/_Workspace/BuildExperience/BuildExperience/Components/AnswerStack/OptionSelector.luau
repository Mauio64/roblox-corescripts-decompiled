local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local text = Foundation.Text
local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local v5 = { affordance = Foundation.Enums.StateLayerAffordance.None }

local function OptionSelector(props)
	local v6 = useTokens()
	local isSelected = props.isSelected == true
	local selectionStyle = props.selectionStyle or "committed"
	local v7 = isSelected
		and selectionStyle == "intermediate"
		and "col gap-large size-full-0 auto-y padding-large stroke-standard stroke-contrast radius-large bg-surface-0"
		or "col gap-large size-full-0 auto-y padding-large stroke-standard stroke-default radius-large bg-surface-0"
	local createElement = React.createElement
	local v9 = {
		LayoutOrder = props.LayoutOrder,
		onActivated = props.onActivated,
		stateLayer = 0,
		testId = 0,
		tag = 0,
		ZIndex = 3
	}
	local v10 = if isSelected and selectionStyle == "committed" then v5 else nil
	v9.stateLayer = v10
	v9.testId = props.testId
	v9.tag = v7
	local element = createElement(view, v9, {
		Content = React.createElement(view, {
			LayoutOrder = 1,
			tag = "col size-full-0 auto-y"
		}, {
			Title = React.createElement(text, {
				LayoutOrder = 1,
				Text = props.title,
				tag = "size-full-0 auto-y text-title-small text-wrap text-align-x-left content-emphasis"
			}),
			Description = React.createElement(text, {
				LayoutOrder = 2,
				Text = props.description,
				tag = "size-full-0 auto-y text-body-small text-wrap text-align-x-left content-default"
			})
		})
	})

	if isSelected and selectionStyle == "committed" then
		return React.createElement(
			view,
			{ LayoutOrder = props.LayoutOrder, tag = "col size-full-0 auto-y" },
			{
				Card = React.cloneElement(element, { LayoutOrder = 1 }),
				StackLayers = React.createElement(
					view,
					{ LayoutOrder = 2, tag = "size-full-400", ZIndex = 1 },
					{
						FirstLayer = React.createElement(view, {
							Position = UDim2.new(0, v6.Size.Size_400, 0, -v6.Size.Size_200),
							Size = UDim2.new(1, -2 * v6.Size.Size_400, 0, v6.Size.Size_400),
							tag = "stroke-standard stroke-default radius-medium bg-surface-0",
							ZIndex = 2
						}),
						SecondLayer = React.createElement(view, {
							Position = UDim2.new(0, v6.Size.Size_800, 0, 0),
							Size = UDim2.new(1, -2 * v6.Size.Size_800, 0, v6.Size.Size_400),
							tag = "stroke-standard stroke-default radius-medium bg-surface-0",
							ZIndex = 1
						})
					}
				)
			}
		)
	end

	return element
end

return OptionSelector
