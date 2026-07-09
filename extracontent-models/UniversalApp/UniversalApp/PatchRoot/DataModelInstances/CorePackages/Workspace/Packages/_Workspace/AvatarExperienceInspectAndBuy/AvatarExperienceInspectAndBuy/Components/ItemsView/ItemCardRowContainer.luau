local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local AvatarExperienceInspectAndBuyParent = AvatarExperienceInspectAndBuy.Parent
local React = require(AvatarExperienceInspectAndBuyParent.React)
local AXCommon = require(AvatarExperienceInspectAndBuyParent.AXCommon)

require(AvatarExperienceInspectAndBuy.Types)

local useItemCardRowProps = require(AvatarExperienceInspectAndBuy.Components.useItemCardRowProps)

require(AvatarExperienceInspectAndBuy.Enums.ViewType)

local CatalogRowItemCard = AXCommon.Components.CatalogItemCard.CatalogRowItemCard

return function(t1: {[any]: any}) -- line: 19
	-- upvalues: useItemCardRowProps (copy), React (copy), CatalogRowItemCard (copy)
	local v8 = useItemCardRowProps(t1.item, t1.LayoutOrder, t1.view, t1.onItemCardActivated, t1.itemCardWidth)

	return React.createElement(CatalogRowItemCard, v8)
end
