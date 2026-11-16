local AvatarSwitcher = script:FindFirstAncestor("AvatarSwitcher")
local parent = AvatarSwitcher.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local OutfitTile = require(AvatarSwitcher.Components.OutfitTile)
require(AvatarSwitcher.types)

local function OutfitsRow(props)
	local children = {}

	for k, outfit in props.outfits do
		children["Outfit" .. (outfit.id or k)] = React.createElement(OutfitTile, {
			outfitInfo = outfit,
			disabled = props.disabled,
			LayoutOrder = k,
			gridPosition = { row = props.rowNumber, column = k }
		})
	end

	for i = #props.outfits + 1, props.desiredItemsCount do
		children["Filler" .. i] = React.createElement(Foundation.View, {
			tag = "size-full-0",
			LayoutOrder = i
		})
	end

	return React.createElement(
		Foundation.View,
		{ tag = "row size-full-0 auto-y gap-medium flex-x-fill padding-bottom-large" },
		children
	)
end

return React.memo(OutfitsRow)
