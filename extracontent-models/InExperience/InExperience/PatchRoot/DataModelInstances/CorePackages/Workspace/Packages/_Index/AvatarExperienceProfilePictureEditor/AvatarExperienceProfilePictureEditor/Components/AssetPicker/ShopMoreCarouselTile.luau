local parent = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local View = Foundation.View
local Text = Foundation.Text
local Icon = Foundation.Icon
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize

local function ShopMoreCarouselTile(props)
	local onActivated = React.useCallback(function()
		props.onActivated()
	end, { props.onActivated })

	return React.createElement(
		View,
		{
			tag = "col align-x-left gap-small auto-y",
			Size = UDim2.fromOffset(props.tileSize, 0),
			LayoutOrder = props.layoutOrder,
			onActivated = onActivated
		},
		{
			Thumbnail = React.createElement(
				View,
				{
					tag = "align-x-center align-y-center radius-medium bg-surface-100",
					Size = UDim2.fromOffset(props.tileSize, props.tileSize),
					LayoutOrder = 1
				},
				{
					Icon = React.createElement(Icon, {
						name = IconName.ShoppingCart,
						size = IconSize.XXLarge
					})
				}
			),
			Label = React.createElement(Text, {
				tag = "size-full-0 auto-y text-body-small text-align-x-left text-truncate-end content-emphasis",
				Text = props.label,
				LayoutOrder = 2
			})
		}
	)
end

return ShopMoreCarouselTile
