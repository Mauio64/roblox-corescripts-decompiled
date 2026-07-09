local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local useOutfitSelectionGridProps = require(script.Parent.useOutfitSelectionGridProps)
local OutfitSelectionGrid = require(script.Parent.OutfitSelectionGrid)

return React.forwardRef(function(t1: {[any]: any}, p1) -- line: 28
	-- upvalues: useOutfitSelectionGridProps (copy), React (copy), OutfitSelectionGrid (copy)
	local v7 = useOutfitSelectionGridProps({
		outfitType = t1.outfitType,
		isEditable = t1.isEditable,
		onToggleOutfitCard = t1.onToggleOutfitCard,
		selectedOutfits = t1.selectedOutfits,
		setSelectedOutfits = t1.setSelectedOutfits,
		setCanScroll = t1.setCanScroll,
		multiSelect = t1.multiSelect,
		goBack = t1.goBack,
		pageOwner = t1.pageOwner,
		forwardRef = p1
	})

	return React.createElement(OutfitSelectionGrid, v7)
end)
