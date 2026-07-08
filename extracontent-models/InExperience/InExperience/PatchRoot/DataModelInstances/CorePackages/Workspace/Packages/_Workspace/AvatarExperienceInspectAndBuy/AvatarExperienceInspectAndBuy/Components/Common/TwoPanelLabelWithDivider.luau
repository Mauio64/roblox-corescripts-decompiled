local Parent = script:FindFirstAncestor("AvatarExperienceInspectAndBuy").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)

local function TwoPanelLabelWithDivider(t1: {[any]: any}) -- line: 26
	-- upvalues: React (copy), Foundation (copy)
	return React.createElement(Foundation.View, {
		tag = "auto-y size-full-0 padding-top-medium col align-x-left align-y-top gap-small",
		LayoutOrder = t1.LayoutOrder
	}, {
		LabelContainer = React.createElement(Foundation.View, {
			tag = "auto-y size-full-0 row align-x-center align-y-center gap-small flex-x-between",
			LayoutOrder = 1
		}, {
			LeftLabel = React.createElement(Foundation.Text, {
				LayoutOrder = 1,
				tag = "auto-xy text-title-medium content-default text-align-x-left",
				Text = t1.labelProps.leftLabel
			}),
			RightLabel = if type(t1.labelProps.rightLabel) ~= "string" then t1.labelProps.rightLabel else React.createElement(Foundation.Text, {
				LayoutOrder = 2,
				tag = "auto-xy text-title-medium content-default text-align-x-right",
				Text = t1.labelProps.rightLabel
			})
		}),
		Divider = if not t1.showDivider then nil else React.createElement(Foundation.Divider, {
			LayoutOrder = 2,
			Orientation = Enum.FillDirection.Horizontal,
			Size = UDim2.new(1, 0, 0, 1)
		})
	})
end

return TwoPanelLabelWithDivider
