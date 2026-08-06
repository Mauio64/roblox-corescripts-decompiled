local UserTile = script:FindFirstAncestor("UserTile")
local UserTileParent = UserTile.Parent
local React = require(UserTileParent.React)
local Foundation = require(UserTileParent.Foundation)
local UserLib = require(UserTileParent.UserLib)
local useTokens = Foundation.Hooks.useTokens
local UserPresence = Foundation.Enums.UserPresence
local FoundationImage = Foundation.Image
local View = Foundation.View
local getStandardSizeAvatarHeadShotRbxthumb = UserLib.Utils.getStandardSizeAvatarHeadShotRbxthumb
local FFlagUserTileShowShimmerWhenLoading = require(UserTile.Flags.FFlagUserTileShowShimmerWhenLoading)
local FFlagAddBackplateSupportToUserTile = require(UserTileParent.SharedFlags).FFlagAddBackplateSupportToUserTile
local FFlagUserTileUseProfileFrameThumbnail = require(UserTile.Flags.FFlagUserTileUseProfileFrameThumbnail)

local function Avatar(t1: {[any]: any}) -- line: 28
	-- upvalues: FFlagUserTileShowShimmerWhenLoading (copy), getStandardSizeAvatarHeadShotRbxthumb (copy), FFlagUserTileUseProfileFrameThumbnail (copy), useTokens (copy), React (copy), View (copy), FFlagAddBackplateSupportToUserTile (copy), FoundationImage (copy), UserPresence (copy)
	local v16 = if not FFlagUserTileShowShimmerWhenLoading or not t1.avatarThumbnailUrl then getStandardSizeAvatarHeadShotRbxthumb(t1.userId, FFlagUserTileUseProfileFrameThumbnail) else t1.avatarThumbnailUrl
	local v17 = useTokens()
	local v18 = if not t1.hover then v17.Color.Shift.Shift_300 else v17.Color.Shift.Shift_400

	return React.createElement(View, {
		tag = "aspect-1-1 position-center-center anchor-center-center size-full-full",
		ZIndex = t1.ZIndex,
		LayoutOrder = t1.layoutOrder
	}, {
		Backplate = if not FFlagAddBackplateSupportToUserTile or not t1.backplateStyle then nil else React.createElement(View, {
			tag = "position-center-center anchor-center-center radius-circle",
			ZIndex = 0,
			backgroundStyle = t1.backplateStyle,
			Size = UDim2.new(1, 14, 1, 14)
		}),
		AvatarThumbnail = React.createElement(View, {
			tag = "size-full position-center-center anchor-center-center"
		}, {
			AvatarImage = React.createElement(FoundationImage, {
				LayoutOrder = 1,
				tag = "size-full aspect-1-1 radius-circle align-x-center align-y-center row position-center-center anchor-center-center",
				ZIndex = 3,
				backgroundStyle = v18,
				Image = v16
			})
		}),
		Icon = if t1.userPresenceType ~= UserPresence.Active and t1.userPresenceType ~= UserPresence.InExperience then nil else React.createElement(FoundationImage, {
			tag = "bg-surface-100 radius-circle auto-xy position-absolute",
			Image = "component_assets/circle_16",
			Size = UDim2.new(0.125, 4, 0.125, 4),
			Position = UDim2.new(0.8536, v17.Stroke.Thicker, 0.8536, v17.Stroke.Thicker),
			AnchorPoint = Vector2.new(0.5, 0.5),
			stroke = {
				Thickness = v17.Stroke.Thicker,
				Color = v17.Color.Surface.Surface_100.Color3
			},
			imageStyle = v17.Color.System.Success
		})
	})
end

return Avatar
