local AvatarExperienceUIKit = script:FindFirstAncestor("AvatarExperienceUIKit")
local AvatarExperienceUIKitParent = AvatarExperienceUIKit.Parent
local React = require(AvatarExperienceUIKitParent.React)
local Foundation = require(AvatarExperienceUIKitParent.Foundation)
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local BackgroundLayers = require(AvatarExperienceUIKit.BackgroundLayers.BackgroundLayers)

local function ItemCardBackgroundsWrapper(t1: {[any]: any}) -- line: 17
	-- upvalues: useTokens (copy), React (copy), BackgroundLayers (copy), View (copy)
	local v10 = useTokens()

	return React.createElement(React.Fragment, nil, {
		ItemCardBackgrounds = React.createElement(BackgroundLayers, {
			ZIndex = 0,
			backgroundLayers = t1.backgroundLayers,
			cornerRadius = UDim.new(0, v10.Radius.Medium),
			imageScaleType = t1.imageScaleType
		}),
		ItemCardContent = React.createElement(View, {
			tag = "col gap-small size-full-0 auto-y padding-small",
			ZIndex = 1
		}, {
			ItemCardHeaderSlot = t1.headerSlot,
			ItemCardFooterSlot = t1.footerSlot
		})
	})
end

return ItemCardBackgroundsWrapper
