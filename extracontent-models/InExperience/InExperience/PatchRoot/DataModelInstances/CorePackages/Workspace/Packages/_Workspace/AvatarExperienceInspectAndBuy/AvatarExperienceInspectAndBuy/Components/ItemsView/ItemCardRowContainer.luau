local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local parent = AvatarExperienceInspectAndBuy.Parent
local React = require(parent.React)
local AXCommon = require(parent.AXCommon)
require(AvatarExperienceInspectAndBuy.Types)
local useItemCardRowProps = require(AvatarExperienceInspectAndBuy.Components.useItemCardRowProps)
require(AvatarExperienceInspectAndBuy.Enums.ViewType)

local CatalogRowItemCard = AXCommon.Components.CatalogItemCard.CatalogRowItemCard

return function(props)
	local v = useItemCardRowProps(
		props.item,
		props.LayoutOrder,
		props.view,
		props.onItemCardActivated,
		props.itemCardWidth
	)
	return React.createElement(CatalogRowItemCard, v)
end
