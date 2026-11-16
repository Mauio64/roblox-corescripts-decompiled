local parent = script:FindFirstAncestor("AvatarExperienceInspectAndBuy").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)

local function TwoPanelLabelWithDivider(props)
	local createElement = React.createElement
	local view = Foundation.View
	local v = {
		tag = "auto-y size-full-0 padding-top-medium col align-x-left align-y-top gap-small",
		LayoutOrder = props.LayoutOrder
	}

	local createElement2 = React.createElement
	local view2 = Foundation.View

	local v3 = {
		LeftLabel = React.createElement(Foundation.Text, {
			LayoutOrder = 1,
			tag = "auto-xy text-title-medium content-default text-align-x-left",
			Text = props.labelProps.leftLabel
		}),
		RightLabel = 0
	}
	local rightLabel

	if type(props.labelProps.rightLabel) == "string" then
		rightLabel = React.createElement(Foundation.Text, {
			LayoutOrder = 2,
			tag = "auto-xy text-title-medium content-default text-align-x-right",
			Text = props.labelProps.rightLabel
		})
	else
		rightLabel = props.labelProps.rightLabel
	end

	v3.RightLabel = rightLabel
	local v2 = {
		LabelContainer = createElement2(
			view2,
			{
				tag = "auto-y size-full-0 row align-x-center align-y-center gap-small flex-x-between",
				LayoutOrder = 1
			},
			v3
		),
		Divider = 0
	}
	local divider

	if props.showDivider then
		divider = React.createElement(Foundation.Divider, {
			LayoutOrder = 2,
			Orientation = Enum.FillDirection.Horizontal,
			Size = UDim2.new(1, 0, 0, 1)
		})
	end

	v2.Divider = divider
	return createElement(view, v, v2)
end

return TwoPanelLabelWithDivider
