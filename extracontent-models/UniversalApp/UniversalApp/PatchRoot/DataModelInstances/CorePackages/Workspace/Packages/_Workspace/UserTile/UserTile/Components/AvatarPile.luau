local Parent = script:FindFirstAncestor("UserTile").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local UserLib = require(Parent.UserLib)
local FoundationImage = Foundation.Image
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local useCumulativeBackground = Foundation.Hooks.useCumulativeBackground
local UserPresence = Foundation.Enums.UserPresence
local getStandardSizeAvatarHeadShotRbxthumb = UserLib.Utils.getStandardSizeAvatarHeadShotRbxthumb

local function AvatarPile(t1: {[any]: any}) -- line: 24
	-- upvalues: useTokens (copy), getStandardSizeAvatarHeadShotRbxthumb (copy), useCumulativeBackground (copy), React (copy), View (copy), FoundationImage (copy), UserPresence (copy)
	local v13 = useTokens()
	local v14 = getStandardSizeAvatarHeadShotRbxthumb(t1.primaryUserId)
	local v15 = getStandardSizeAvatarHeadShotRbxthumb(t1.secondUserId)
	local v16 = if not t1.hover then v13.Color.Shift.Shift_300 else v13.Color.Shift.Shift_400
	local v17 = useCumulativeBackground(t1.altSurfaceBackground or v13.Color.Surface.Surface_0, v16)

	return React.createElement(View, {
		tag = "aspect-1-1 position-center-center anchor-center-center size-full-full",
		ZIndex = t1.ZIndex,
		LayoutOrder = t1.layoutOrder
	}, {
		AvatarImage1 = React.createElement(FoundationImage, {
			LayoutOrder = 1,
			ZIndex = 2,
			backgroundStyle = v17,
			tag = {
				["aspect-1-1 radius-circle row position-bottom-left anchor-bottom-left"] = true
			},
			Size = UDim2.fromScale(0.7, 0.7),
			Image = v14
		}),
		AvatarImage2 = React.createElement(FoundationImage, {
			LayoutOrder = 2,
			ZIndex = 1,
			backgroundStyle = v17,
			tag = {
				["aspect-1-1 radius-circle row position-top-right anchor-top-right"] = true
			},
			Size = UDim2.fromScale(0.7, 0.7),
			Image = v15
		}),
		Icon = if t1.userPresenceType ~= UserPresence.Active and t1.userPresenceType ~= UserPresence.InExperience then nil else React.createElement(FoundationImage, {
			tag = "bg-surface-100 radius-circle auto-xy position-absolute",
			Image = "component_assets/circle_16",
			Size = UDim2.new(0.125, 4, 0.125, 4),
			Position = UDim2.new(0.8536, v13.Stroke.Thicker, 0.8536, v13.Stroke.Thicker),
			AnchorPoint = Vector2.new(0.5, 0.5),
			stroke = {
				Thickness = v13.Stroke.Thicker,
				Color = v13.Color.Surface.Surface_100.Color3
			},
			imageStyle = v13.Color.System.Success
		})
	})
end

return AvatarPile
