local AvatarSwitcher = script:FindFirstAncestor("AvatarSwitcher")
local AvatarSwitcherParent = AvatarSwitcher.Parent
local React = require(AvatarSwitcherParent.React)
local Foundation = require(AvatarSwitcherParent.Foundation)
local OutfitTile = require(AvatarSwitcher.Components.OutfitTile)

require(AvatarSwitcher.types)

local function OutfitsRow(t1: {[any]: any}) -- line: 22
	-- upvalues: React (copy), OutfitTile (copy), Foundation (copy)
	local t2 = {}

	for v9, v10 in t1.outfits do
		t2["Outfit" .. (v10.id or v9)] = React.createElement(OutfitTile, {
			outfitInfo = v10,
			disabled = t1.disabled,
			LayoutOrder = v9,
			gridPosition = {
				row = t1.rowNumber,
				column = v9
			}
		})
	end

	for i = #t1.outfits + 1, t1.desiredItemsCount do
		t2["Filler" .. i] = React.createElement(Foundation.View, {
			tag = "size-full-0",
			LayoutOrder = i
		})
	end

	return React.createElement(Foundation.View, {
		tag = "row size-full-0 auto-y gap-medium flex-x-fill padding-bottom-large"
	}, t2)
end

return React.memo(OutfitsRow)
