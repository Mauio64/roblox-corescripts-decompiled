local AvatarExperienceUIKit = script:FindFirstAncestor("AvatarExperienceUIKit")
local parent = AvatarExperienceUIKit.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local BackgroundLayers = require(AvatarExperienceUIKit.BackgroundLayers.BackgroundLayers)

local function ItemCardBackgroundsWrapper(props)
	local v = useTokens()
	return React.createElement(React.Fragment, nil, {
		ItemCardBackgrounds = React.createElement(BackgroundLayers, {
			backgroundLayers = props.backgroundLayers,
			cornerRadius = UDim.new(0, v.Radius.Medium),
			ZIndex = 0,
			imageScaleType = props.imageScaleType
		}),
		ItemCardContent = React.createElement(
			View,
			{ tag = "col gap-small size-full-0 auto-y padding-small", ZIndex = 1 },
			{ ItemCardHeaderSlot = props.headerSlot, ItemCardFooterSlot = props.footerSlot }
		)
	})
end

return ItemCardBackgroundsWrapper
