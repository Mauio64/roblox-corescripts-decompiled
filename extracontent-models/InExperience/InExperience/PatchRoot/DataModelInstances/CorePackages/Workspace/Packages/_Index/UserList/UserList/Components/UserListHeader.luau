local parent = script:FindFirstAncestor("UserList").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local Enums = Foundation.Enums
local Icon = Foundation.Icon
local View = Foundation.View
local Text = Foundation.Text
local IconButton = Foundation.IconButton
local IconName = Enums.IconName
local IconSize = Enums.IconSize
local IconVariant = Enums.IconVariant

local function UserListHeader(props)
	local createElement = React.createElement
	local v = {
		tag = "size-full-0 auto-y col gap-xxsmall align-x-left",
		LayoutOrder = props.layoutOrder
	}

	local createElement2 = React.createElement

	local createElement3 = React.createElement
	local onActivated

	if props.onTitleActivated then
		onActivated = props.onTitleActivated
	end

	return createElement(View, v, {
		HeaderRow = createElement2(
			View,
			{
				tag = "size-full-0 auto-y row align-y-center flex-x-between padding-right-xsmall",
				LayoutOrder = 1
			},
			{
				TitleRow = createElement3(
					View,
					{
						tag = "auto-xy row align-y-center gap-xxsmall",
						onActivated = onActivated,
						LayoutOrder = 1
					},
					{
						Title = props.title and React.createElement(Text, {
							tag = "text-title-large auto-xy text-align-x-left content-emphasis",
							Text = props.title,
							stateLayer = { affordance = Enums.StateLayerAffordance.None },
							LayoutOrder = 1
						}),
						Chevron = props.hasChevron and React.createElement(Icon, {
							name = IconName.ChevronLargeRight,
							size = IconSize.Small,
							variant = IconVariant.Filled,
							LayoutOrder = 2
						})
					}
				),
				TrailingIcon = props.trailingIcon and props.onTrailingIconActivated and React.createElement(IconButton, {
					icon = props.trailingIcon,
					size = IconSize.Small,
					onActivated = props.onTrailingIconActivated,
					LayoutOrder = 2,
					ref = props.trailingIconRef
				})
			}
		),
		Subtitle = props.subtitle and React.createElement(Text, {
			tag = "text-body-medium auto-xy text-align-x-left content-default text-wrap",
			Text = props.subtitle,
			LayoutOrder = 2
		})
	})
end

return UserListHeader
