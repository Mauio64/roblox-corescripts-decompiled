local Parent = script:FindFirstAncestor("UserList").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local Enums = Foundation.Enums
local Icon = Foundation.Icon
local View = Foundation.View
local FoundationText = Foundation.Text
local IconButton = Foundation.IconButton
local IconName = Enums.IconName
local IconSize = Enums.IconSize
local IconVariant = Enums.IconVariant

local function UserListHeader(t1: {[any]: any}) -- line: 26
	-- upvalues: React (copy), View (copy), FoundationText (copy), Enums (copy), Icon (copy), IconName (copy), IconSize (copy), IconVariant (copy), IconButton (copy)
	return React.createElement(View, {
		tag = "size-full-0 auto-y col gap-xxsmall align-x-left",
		LayoutOrder = t1.layoutOrder
	}, {
		HeaderRow = React.createElement(View, {
			tag = "size-full-0 auto-y row align-y-center flex-x-between padding-right-xsmall",
			LayoutOrder = 1
		}, {
			TitleRow = React.createElement(View, {
				tag = "auto-xy row align-y-center gap-xxsmall",
				LayoutOrder = 1,
				onActivated = if not t1.onTitleActivated then nil else t1.onTitleActivated
			}, {
				Title = t1.title and React.createElement(FoundationText, {
					tag = "text-title-large auto-xy text-align-x-left content-emphasis",
					LayoutOrder = 1,
					Text = t1.title,
					stateLayer = {
						affordance = Enums.StateLayerAffordance.None
					}
				}),
				Chevron = t1.hasChevron and React.createElement(Icon, {
					LayoutOrder = 2,
					name = IconName.ChevronLargeRight,
					size = IconSize.Small,
					variant = IconVariant.Filled
				})
			}),
			TrailingIcon = t1.trailingIcon and (t1.onTrailingIconActivated and React.createElement(IconButton, {
				LayoutOrder = 2,
				icon = t1.trailingIcon,
				size = IconSize.Small,
				onActivated = t1.onTrailingIconActivated
			}))
		}),
		Subtitle = t1.subtitle and React.createElement(FoundationText, {
			tag = "text-body-medium auto-xy text-align-x-left content-default text-wrap",
			LayoutOrder = 2,
			Text = t1.subtitle
		})
	})
end

return UserListHeader
