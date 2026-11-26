local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UserTile/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/UserTile/Foundation")
local UserLib = require("@game/CorePackages/Workspace/Packages/_Workspace/UserTile/UserLib")

local image = Foundation.Image
local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local useCumulativeBackground = Foundation.Hooks.useCumulativeBackground
local userPresence = Foundation.Enums.UserPresence
local getStandardSizeAvatarHeadShotRbxthumb = UserLib.Utils.getStandardSizeAvatarHeadShotRbxthumb

local function AvatarPile(props)
	local v5 = useTokens()
	local standardSizeAvatarHeadShotRbxthumb = getStandardSizeAvatarHeadShotRbxthumb(props.primaryUserId)
	local standardSizeAvatarHeadShotRbxthumb2 = getStandardSizeAvatarHeadShotRbxthumb(props.secondUserId)

	local v6 = if props.hover then v5.Color.Shift.Shift_400 else v5.Color.Shift.Shift_300

	local v7 = useCumulativeBackground(props.altSurfaceBackground or v5.Color.Surface.Surface_0, v6)

	local createElement = React.createElement
	local v9 = {
		tag = "aspect-1-1 position-center-center anchor-center-center size-full-full",
		ZIndex = props.ZIndex,
		LayoutOrder = props.layoutOrder
	}
	local v10 = {
		AvatarImage1 = React.createElement(image, {
			LayoutOrder = 1,
			backgroundStyle = v7,
			tag = {
				["aspect-1-1 radius-circle row position-bottom-left anchor-bottom-left"] = true
			},
			Size = UDim2.fromScale(0.7, 0.7),
			Image = standardSizeAvatarHeadShotRbxthumb,
			ZIndex = 2
		}),
		AvatarImage2 = React.createElement(image, {
			LayoutOrder = 2,
			backgroundStyle = v7,
			tag = {
				["aspect-1-1 radius-circle row position-top-right anchor-top-right"] = true
			},
			Size = UDim2.fromScale(0.7, 0.7),
			Image = standardSizeAvatarHeadShotRbxthumb2,
			ZIndex = 1
		}),
		Icon = 0
	}

	local v11 = if props.userPresenceType == userPresence.Active or props.userPresenceType == userPresence.InExperience then React.createElement(image, {
		tag = "bg-surface-100 radius-circle auto-xy position-absolute",
		Image = "component_assets/circle_16",
		Size = UDim2.new(0.125, 4, 0.125, 4),
		Position = UDim2.new(0.8536, v5.Stroke.Thicker, 0.8536, v5.Stroke.Thicker),
		AnchorPoint = Vector2.new(0.5, 0.5),
		stroke = {
			Thickness = v5.Stroke.Thicker,
			Color = v5.Color.Surface.Surface_100.Color3
		},
		imageStyle = v5.Color.System.Success
	}) else nil
	v10.Icon = v11
	return createElement(view, v9, v10)
end

return AvatarPile
