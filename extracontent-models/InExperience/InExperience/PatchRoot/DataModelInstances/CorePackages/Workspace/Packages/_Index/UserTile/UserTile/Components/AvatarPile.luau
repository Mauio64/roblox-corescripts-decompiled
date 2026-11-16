local parent = script:FindFirstAncestor("UserTile").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local UserLib = require(parent.UserLib)

local Image = Foundation.Image
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local useCumulativeBackground = Foundation.Hooks.useCumulativeBackground
local UserPresence = Foundation.Enums.UserPresence
local getStandardSizeAvatarHeadShotRbxthumb = UserLib.Utils.getStandardSizeAvatarHeadShotRbxthumb

local function AvatarPile(props)
	local v = useTokens()
	local standardSizeAvatarHeadShotRbxthumb = getStandardSizeAvatarHeadShotRbxthumb(props.primaryUserId)
	local standardSizeAvatarHeadShotRbxthumb2 = getStandardSizeAvatarHeadShotRbxthumb(props.secondUserId)
	local v2

	if props.hover then
		v2 = v.Color.Shift.Shift_400
	else
		v2 = v.Color.Shift.Shift_300
	end

	local backgroundStyle = useCumulativeBackground(props.altSurfaceBackground or v.Color.Surface.Surface_0, v2)

	local createElement = React.createElement
	local v3 = {
		tag = "aspect-1-1 position-center-center anchor-center-center size-full-full",
		ZIndex = props.ZIndex,
		LayoutOrder = props.layoutOrder
	}
	local v4 = {
		AvatarImage1 = React.createElement(Image, {
			LayoutOrder = 1,
			backgroundStyle = backgroundStyle,
			tag = {
				["aspect-1-1 radius-circle row position-bottom-left anchor-bottom-left"] = true
			},
			Size = UDim2.fromScale(0.7, 0.7),
			Image = standardSizeAvatarHeadShotRbxthumb,
			ZIndex = 2
		}),
		AvatarImage2 = React.createElement(Image, {
			LayoutOrder = 2,
			backgroundStyle = backgroundStyle,
			tag = { ["aspect-1-1 radius-circle row position-top-right anchor-top-right"] = true },
			Size = UDim2.fromScale(0.7, 0.7),
			Image = standardSizeAvatarHeadShotRbxthumb2,
			ZIndex = 1
		}),
		Icon = 0
	}
	local icon

	if props.userPresenceType == UserPresence.Active or props.userPresenceType == UserPresence.InExperience then
		icon = React.createElement(Image, {
			tag = "bg-surface-100 radius-circle auto-xy position-absolute",
			Image = "component_assets/circle_16",
			Size = UDim2.new(0.125, 4, 0.125, 4),
			Position = UDim2.new(0.8536, v.Stroke.Thicker, 0.8536, v.Stroke.Thicker),
			AnchorPoint = Vector2.new(0.5, 0.5),
			stroke = { Thickness = v.Stroke.Thicker, Color = v.Color.Surface.Surface_100.Color3 },
			imageStyle = v.Color.System.Success
		})
	end

	v4.Icon = icon
	return createElement(View, v3, v4)
end

return AvatarPile
