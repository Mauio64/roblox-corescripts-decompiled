local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UserTile/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/UserTile/Foundation")
local UserLib = require("@game/CorePackages/Workspace/Packages/_Workspace/UserTile/UserLib")
local useTokens = Foundation.Hooks.useTokens
local userPresence = Foundation.Enums.UserPresence
local iconSize = Foundation.Enums.IconSize
local iconVariant = Foundation.Enums.IconVariant
local icon = Foundation.Icon
local image = Foundation.Image
local view = Foundation.View

local getStandardSizeAvatarHeadShotRbxthumb = UserLib.Utils.getStandardSizeAvatarHeadShotRbxthumb
local FFlagUserTileShowShimmerWhenLoading = require("@game/CorePackages/Workspace/Packages/_Index/UserTile/UserTile/Flags/FFlagUserTileShowShimmerWhenLoading")
local fFlagAddBackplateSupportToUserTile = require("@game/CorePackages/Workspace/Packages/_Workspace/UserTile/SharedFlags").FFlagAddBackplateSupportToUserTile
local fFlagUserTileAvatarOverlayIcon = require("@game/CorePackages/Workspace/Packages/_Workspace/UserTile/SharedFlags").FFlagUserTileAvatarOverlayIcon
local FFlagUserTileUseProfileFrameThumbnail = require("@game/CorePackages/Workspace/Packages/_Index/UserTile/UserTile/Flags/FFlagUserTileUseProfileFrameThumbnail")
local FFlagUserTileIncludeProfileFrameProp = require("@game/CorePackages/Workspace/Packages/_Index/UserTile/UserTile/Flags/FFlagUserTileIncludeProfileFrameProp")

local function Avatar(props)
	local v5 = FFlagUserTileUseProfileFrameThumbnail

	if FFlagUserTileIncludeProfileFrameProp and props.includeProfileFrame ~= nil then
		v5 = v5 and props.includeProfileFrame
	end

	local v6

	if FFlagUserTileShowShimmerWhenLoading and props.avatarThumbnailUrl then
		v6 = props.avatarThumbnailUrl
	else
		v6 = getStandardSizeAvatarHeadShotRbxthumb(props.userId, v5)
	end

	local v7 = useTokens()

	local v8 = if props.hover then v7.Color.Shift.Shift_400 else v7.Color.Shift.Shift_300

	local createElement = React.createElement
	local v10 = {
		tag = "aspect-1-1 position-center-center anchor-center-center size-full-full",
		ZIndex = props.ZIndex,
		LayoutOrder = props.layoutOrder
	}

	local v12 = if fFlagAddBackplateSupportToUserTile and props.backplateStyle then React.createElement(view, {
		backgroundStyle = props.backplateStyle,
		tag = "position-center-center anchor-center-center radius-circle",
		Size = UDim2.new(1, 14, 1, 14),
		ZIndex = 0
	}) else nil

	local createElement2 = React.createElement

	local v15 = {
		AvatarImage = React.createElement(image, {
			LayoutOrder = 1,
			backgroundStyle = v8,
			tag = "size-full aspect-1-1 radius-circle align-x-center align-y-center row position-center-center anchor-center-center",
			Image = v6,
			ZIndex = 3
		}),
		GradientOverlay = 0
	}

	local v16 = if fFlagUserTileAvatarOverlayIcon and props.overlayIcon then React.createElement(
		view,
		{
			backgroundStyle = v7.Color.Surface.Surface_0,
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
				view,
				{
					tag = "position-bottom-center anchor-bottom-center auto-xy padding-bottom-medium",
					ZIndex = 5
				},
				{
					OverlayIcon = React.createElement(icon, {
						name = props.overlayIcon,
						variant = iconVariant.Filled,
						size = iconSize.Medium,
						style = v7.Color.Content.Emphasis,
						ZIndex = 5
					})
				}
			)
		}
	) else nil
	v15.GradientOverlay = v16
	local v11 = {
		Backplate = v12,
		AvatarThumbnail = createElement2(
			view,
			{ tag = "size-full position-center-center anchor-center-center" },
			v15
		),
		Icon = 0
	}

	local v17 = if props.userPresenceType == userPresence.Active or props.userPresenceType == userPresence.InExperience then React.createElement(image, {
		tag = "bg-surface-100 radius-circle auto-xy position-absolute",
		Image = "component_assets/circle_16",
		Size = UDim2.new(0.125, 4, 0.125, 4),
		Position = UDim2.new(0.8536, v7.Stroke.Thicker, 0.8536, v7.Stroke.Thicker),
		AnchorPoint = Vector2.new(0.5, 0.5),
		ZIndex = fFlagUserTileAvatarOverlayIcon and 5 or nil,
		stroke = {
			Thickness = v7.Stroke.Thicker,
			Color = v7.Color.Surface.Surface_100.Color3
		},
		imageStyle = v7.Color.System.Success
	}) else nil
	v11.Icon = v17
	return createElement(view, v10, v11)
end

return Avatar
