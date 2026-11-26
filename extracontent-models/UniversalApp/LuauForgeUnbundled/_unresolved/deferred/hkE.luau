local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Foundation = require(CorePackages.Packages.Foundation)

local useTokens = Foundation.Hooks.useTokens
local catalogItemCard = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Components.CatalogItemCard.CatalogItemCard
local itemCardThumbnail = require("@luauforge/deferred/gPt").ItemCardComponents.ItemCardThumbnail
require("@luauforge/deferred/hkF")

local function EmoteTile(props, p2)
	local v5 = useTokens()
	return React.createElement(catalogItemCard, {
		onActivated = props.onActivated,
		presentationSlot = React.createElement(
			RoactGamepad.Focusable.Frame,
			{
				Size = UDim2.fromScale(1, 1),
				ClipsDescendants = true,
				BackgroundTransparency = 1,
				BorderSizePixel = 0
			},
			{
				CornerRadius = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, v5.Radius.Medium)
				}),
				EmoteTileThumbnail = React.createElement(itemCardThumbnail, {
					url = `rbxthumb://type=Asset&id={props.itemId}&w=150&h=150&filters=0`
				})
			}
		),
		title = props.item.name,
		isSelected = props.isSelected,
		Size = UDim2.fromOffset(props.itemWidth, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		ref = p2,
		LayoutOrder = props.index,
		tag = props.impressionsTag,
		gridInformation = props.gridInformation
	})
end

return React.forwardRef(EmoteTile)
