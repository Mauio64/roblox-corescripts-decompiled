local React = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/Foundation")
local radius = Foundation.Enums.Radius
local skeleton = Foundation.Skeleton

local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local icon = Foundation.Icon
local text = Foundation.Text
local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function EditComponentRow(props)
	local v5 = useTokens()
	local v6 = string.gsub(props.currentValue, "\n", " ")

	local createElement = React.createElement
	local v8 = {
		tag = "row size-full-1100 padding-medium align-y-center flex-x-between gap-medium",
		LayoutOrder = props.layoutOrder,
		onActivated = props.onActivated,
		ref = props.forwardRef
	}
	local v9 = {
		TitleText = React.createElement(text, {
			tag = "text-title-medium content-emphasis auto-xy",
			Text = props.label,
			LayoutOrder = 1
		}),
		EditButton = 0
	}

	local v10 = if props.shouldShimmer then React.createElement(skeleton, {
		LayoutOrder = 3,
		Size = UDim2.new(0.3, 0, 0, v5.Size.Size_400),
		radius = radius.Medium
	}) else React.createElement(
		view,
		{
			tag = "row size-0-full fill align-y-center align-x-right gap-xsmall",
			LayoutOrder = 2
		},
		{
			CurrentText = React.createElement(
				view,
				{
					tag = "row size-0-full fill align-y-center align-x-right",
					LayoutOrder = 1
				},
				{ React.createElement(text, {
						tag = "text-body-small text-truncate-end size-0-full auto-x",
						Text = v6
					}) }
			),
			EditIcon = React.createElement(icon, {
				name = iconName.ChevronLargeRight,
				size = iconSize.Medium,
				LayoutOrder = 2
			})
		}
	)
	v9.EditButton = v10
	return createElement(view, v8, v9)
end

return EditComponentRow
