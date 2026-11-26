local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/Foundation")

local function TwoPanelLabelWithDivider(props)
	local createElement = React.createElement
	local view = Foundation.View
	local v5 = {
		tag = "auto-y size-full-0 padding-top-medium col align-x-left align-y-top gap-small",
		LayoutOrder = props.LayoutOrder
	}

	local createElement2 = React.createElement
	local view2 = Foundation.View

	local v8 = {
		LeftLabel = React.createElement(Foundation.Text, {
			LayoutOrder = 1,
			tag = "auto-xy text-title-medium content-default text-align-x-left",
			Text = props.labelProps.leftLabel
		}),
		RightLabel = 0
	}

	local v9 = if type(props.labelProps.rightLabel) == "string" then React.createElement(Foundation.Text, {
		LayoutOrder = 2,
		tag = "auto-xy text-title-medium content-default text-align-x-right",
		Text = props.labelProps.rightLabel
	}) else props.labelProps.rightLabel
	v8.RightLabel = v9
	local v6 = {
		LabelContainer = createElement2(
			view2,
			{
				tag = "auto-y size-full-0 row align-x-center align-y-center gap-small flex-x-between",
				LayoutOrder = 1
			},
			v8
		),
		Divider = 0
	}

	local v10 = if props.showDivider then React.createElement(Foundation.Divider, {
		LayoutOrder = 2,
		Orientation = Enum.FillDirection.Horizontal,
		Size = UDim2.new(1, 0, 0, 1)
	}) else nil
	v6.Divider = v10
	return createElement(view, v5, v6)
end

return TwoPanelLabelWithDivider
