local parent = script:FindFirstAncestor("EditProfile").Parent

local React = require(parent.React)

local Foundation = require(parent.Foundation)
local Radius = Foundation.Enums.Radius
local Skeleton = Foundation.Skeleton

local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local Icon = Foundation.Icon
local Text = Foundation.Text
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function EditComponentRow(props)
	local v = useTokens()
	local text = string.gsub(props.currentValue, "\n", " ")

	local createElement = React.createElement
	local v2 = {
		tag = "row size-full-1100 padding-medium align-y-center flex-x-between gap-medium",
		LayoutOrder = props.layoutOrder,
		onActivated = props.onActivated,
		ref = props.forwardRef
	}
	local v3 = {
		TitleText = React.createElement(Text, {
			tag = "text-title-medium content-emphasis auto-xy",
			Text = props.label,
			LayoutOrder = 1
		}),
		EditButton = 0
	}
	local editButton

	if props.shouldShimmer then
		editButton = React.createElement(Skeleton, {
			LayoutOrder = 3,
			Size = UDim2.new(0.3, 0, 0, v.Size.Size_400),
			radius = Radius.Medium
		})
	else
		editButton = React.createElement(
			View,
			{
				tag = "row size-0-full fill align-y-center align-x-right gap-xsmall",
				LayoutOrder = 2
			},
			{
				CurrentText = React.createElement(
					View,
					{ tag = "row size-0-full fill align-y-center align-x-right", LayoutOrder = 1 },
					{ React.createElement(Text, {
							tag = "text-body-small text-truncate-end size-0-full auto-x",
							Text = text
						}) }
				),
				EditIcon = React.createElement(Icon, {
					name = IconName.ChevronLargeRight,
					size = IconSize.Medium,
					LayoutOrder = 2
				})
			}
		)
	end

	v3.EditButton = editButton
	return createElement(View, v2, v3)
end

return EditComponentRow
