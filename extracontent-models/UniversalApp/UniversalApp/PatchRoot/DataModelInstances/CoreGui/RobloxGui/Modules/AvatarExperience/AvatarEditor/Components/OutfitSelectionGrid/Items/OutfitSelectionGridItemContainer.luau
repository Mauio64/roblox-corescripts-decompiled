local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useOutfitSelectionGridItemProps = require(script.Parent.useOutfitSelectionGridItemProps)
local OutfitSelectionGridItem = require(script.Parent.OutfitSelectionGridItem)

return function(p1) -- line: 8
	-- upvalues: useOutfitSelectionGridItemProps (copy), React (copy), OutfitSelectionGridItem (copy)
	local v6 = useOutfitSelectionGridItemProps(p1)

	return React.createElement(OutfitSelectionGridItem, v6)
end
