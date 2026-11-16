local UserTile = script:FindFirstAncestor("UserTile")
local parent = UserTile.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local UserLib = require(parent.UserLib)
local useTokens = Foundation.Hooks.useTokens
local UserPresence = Foundation.Enums.UserPresence
local IconSize = Foundation.Enums.IconSize
local IconVariant = Foundation.Enums.IconVariant
local Icon = Foundation.Icon
local Image = Foundation.Image
local View = Foundation.View

local getStandardSizeAvatarHeadShotRbxthumb = UserLib.Utils.getStandardSizeAvatarHeadShotRbxthumb
local FFlagUserTileShowShimmerWhenLoading = require(UserTile.Flags.FFlagUserTileShowShimmerWhenLoading)
local SharedFlags = require(parent.SharedFlags)
local FFlagAddBackplateSupportToUserTile = SharedFlags.FFlagAddBackplateSupportToUserTile
local SharedFlags2 = require(parent.SharedFlags)
local FFlagUserTileAvatarOverlayIcon = SharedFlags2.FFlagUserTileAvatarOverlayIcon
local FFlagUserTileUseProfileFrameThumbnail = require(UserTile.Flags.FFlagUserTileUseProfileFrameThumbnail)
local FFlagUserTileIncludeProfileFrameProp = require(UserTile.Flags.FFlagUserTileIncludeProfileFrameProp)

local function Avatar(props)
	local v = FFlagUserTileUseProfileFrameThumbnail

	if FFlagUserTileIncludeProfileFrameProp and props.includeProfileFrame ~= nil then
		v = v and props.includeProfileFrame
	end

	local image

	if FFlagUserTileShowShimmerWhenLoading and props.avatarThumbnailUrl then
		image = props.avatarThumbnailUrl
	else
		image = getStandardSizeAvatarHeadShotRbxthumb(props.userId, v)
	end

	local v2 = useTokens()
	local backgroundStyle

	if props.hover then
		backgroundStyle = v2.Color.Shift.Shift_400
	else
		backgroundStyle = v2.Color.Shift.Shift_300
	end

	local createElement = React.createElement
	local v3 = {
		tag = "aspect-1-1 position-center-center anchor-center-center size-full-full",
		ZIndex = props.ZIndex,
		LayoutOrder = props.layoutOrder
	}
	local backplate

	if FFlagAddBackplateSupportToUserTile and props.backplateStyle then
		backplate = React.createElement(View, {
			backgroundStyle = props.backplateStyle,
			tag = "position-center-center anchor-center-center radius-circle",
			Size = UDim2.new(1, 14, 1, 14),
			ZIndex = 0
		})
	end

	local createElement2 = React.createElement

	local v4 = {
		AvatarImage = React.createElement(Image, {
			LayoutOrder = 1,
			backgroundStyle = backgroundStyle,
			tag = "size-full aspect-1-1 radius-circle align-x-center align-y-center row position-center-center anchor-center-center",
			Image = image,
			ZIndex = 3
		}),
		GradientOverlay = 0
	}
	local gradientOverlay

	if FFlagUserTileAvatarOverlayIcon and props.overlayIcon then
		gradientOverlay = React.createElement(
			View,
			{
				backgroundStyle = v2.Color.Surface.Surface_0,
				tag = "position-center-center anchor-center-center size-full aspect-1-1 radius-circle",
				ZIndex = 4
			},
			{
				Gradient = React.createElement("UIGradient", {
					Rotation = 90,
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 1),
						NumberSequenceKeypoint.new(0.6027, 1),
						NumberSequenceKeypoint.new(0.7682, 0.53),
						NumberSequenceKeypoint.new(1, 0)
					})
				}),
				OverlayIconContainer = React.createElement(
					View,
					{
						tag = "position-bottom-center anchor-bottom-center auto-xy padding-bottom-medium",
						ZIndex = 5
					},
					{
						OverlayIcon = React.createElement(Icon, {
							name = props.overlayIcon,
							variant = IconVariant.Filled,
							size = IconSize.Medium,
							style = v2.Color.Content.Emphasis,
							ZIndex = 5
						})
					}
				)
			}
		)
	end

	v4.GradientOverlay = gradientOverlay
	local v5 = {
		Backplate = backplate,
		AvatarThumbnail = createElement2(View, {
			tag = "size-full position-center-center anchor-center-center"
		}, v4),
		Icon = 0
	}
	local icon

	if props.userPresenceType == UserPresence.Active or props.userPresenceType == UserPresence.InExperience then
		icon = React.createElement(Image, {
			tag = "bg-surface-100 radius-circle auto-xy position-absolute",
			Image = "component_assets/circle_16",
			Size = UDim2.new(0.125, 4, 0.125, 4),
			Position = UDim2.new(0.8536, v2.Stroke.Thicker, 0.8536, v2.Stroke.Thicker),
			AnchorPoint = Vector2.new(0.5, 0.5),
			ZIndex = FFlagUserTileAvatarOverlayIcon and 5 or nil,
			stroke = { Thickness = v2.Stroke.Thicker, Color = v2.Color.Surface.Surface_100.Color3 },
			imageStyle = v2.Color.System.Success
		})
	end

	v5.Icon = icon
	return createElement(View, v3, v5)
end

return Avatar
