local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/Foundation")

local enums = Foundation.Enums
local icon = Foundation.Icon
local view = Foundation.View
local text = Foundation.Text
local iconButton = Foundation.IconButton
local iconName = enums.IconName
local iconSize = enums.IconSize
local iconVariant = enums.IconVariant

local function UserListHeader(props)
	local createElement = React.createElement
	local v6 = {
		tag = "size-full-0 auto-y col gap-xxsmall align-x-left",
		LayoutOrder = props.layoutOrder
	}

	local createElement2 = React.createElement

	local createElement3 = React.createElement

	local v13 = if props.onTitleActivated then props.onTitleActivated else nil
	return createElement(view, v6, {
		HeaderRow = createElement2(
			view,
			{
				tag = "size-full-0 auto-y row align-y-center flex-x-between padding-right-xsmall",
				LayoutOrder = 1
			},
			{
				TitleRow = createElement3(
					view,
					{
						tag = "auto-xy row align-y-center gap-xxsmall",
						onActivated = v13,
						LayoutOrder = 1
					},
					{
						Title = props.title and React.createElement(text, {
							tag = "text-title-large auto-xy text-align-x-left content-emphasis",
							Text = props.title,
							stateLayer = {
								affordance = enums.StateLayerAffordance.None
							},
							LayoutOrder = 1
						}),
						Chevron = props.hasChevron and React.createElement(icon, {
							name = iconName.ChevronLargeRight,
							size = iconSize.Small,
							variant = iconVariant.Filled,
							LayoutOrder = 2
						})
					}
				),
				TrailingIcon = props.trailingIcon and props.onTrailingIconActivated and React.createElement(iconButton, {
					icon = props.trailingIcon,
					size = iconSize.Small,
					onActivated = props.onTrailingIconActivated,
					LayoutOrder = 2,
					ref = props.trailingIconRef
				})
			}
		),
		Subtitle = props.subtitle and React.createElement(text, {
			tag = "text-body-medium auto-xy text-align-x-left content-default text-wrap",
			Text = props.subtitle,
			LayoutOrder = 2
		})
	})
end

return UserListHeader
