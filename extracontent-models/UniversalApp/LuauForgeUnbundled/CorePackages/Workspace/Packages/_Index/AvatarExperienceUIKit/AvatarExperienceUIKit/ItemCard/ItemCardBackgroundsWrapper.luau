local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/Foundation")
local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local BackgroundLayers = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/BackgroundLayers/BackgroundLayers")

local function ItemCardBackgroundsWrapper(props)
	local v5 = useTokens()
	return React.createElement(React.Fragment, nil, {
		ItemCardBackgrounds = React.createElement(BackgroundLayers, {
			backgroundLayers = props.backgroundLayers,
			cornerRadius = UDim.new(0, v5.Radius.Medium),
			ZIndex = 0,
			imageScaleType = props.imageScaleType
		}),
		ItemCardContent = React.createElement(
			view,
			{ tag = "col gap-small size-full-0 auto-y padding-small", ZIndex = 1 },
			{
				ItemCardHeaderSlot = props.headerSlot,
				ItemCardFooterSlot = props.footerSlot
			}
		)
	})
end

return ItemCardBackgroundsWrapper
