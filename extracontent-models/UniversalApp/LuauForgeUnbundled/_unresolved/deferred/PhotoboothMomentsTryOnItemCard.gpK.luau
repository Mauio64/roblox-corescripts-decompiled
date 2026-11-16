local module = require("@luauforge/deferred/gpo")
local module2 = require("@luauforge/deferred/gpq")
local module3 = require("@luauforge/deferred/gpr")
local module4 = require("@luauforge/deferred/gpJ")

local catalogItemCard = module3.Components.CatalogItemCard.CatalogItemCard
local itemCardThumbnail = module4.ItemCardComponents.ItemCardThumbnail

local function PhotoboothMomentsTryOnItemCard(props)
	local itemId = props.itemId
	local onActivated = props.onActivated

	local v5 = module.useCallback(function()
		onActivated(itemId)
	end, { itemId, onActivated })

	local createElement = module.createElement
	local v7 = {
		Size = UDim2.fromOffset(props.itemWidth, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		headerAspectRatio = props.thumbnailAspectRatio or 1,
		title = 0,
		onActivated = 0,
		isSelected = 0,
		LayoutOrder = 0,
		presentationSlot = 0
	}
	local v8 = if not props.hideTitle then props.itemName else nil
	v7.title = v8
	v7.onActivated = v5
	v7.isSelected = props.isSelected
	v7.LayoutOrder = props.LayoutOrder
	local createElement2 = module.createElement
	local view = module2.View

	local v10 = {
		Thumbnail = module.createElement(itemCardThumbnail, { url = props.thumbnailUrl }),
		Tag = 0
	}

	local v11 = if props.tagText then module.createElement(
		module2.View,
		{ tag = "size-full-full padding-small", ZIndex = 2 },
		{
			Label = module.createElement(
				module2.View,
				{
					tag = "auto-xy padding-x-small padding-y-xsmall radius-small bg-over-media-100",
					testId = "PhotoboothMomentsTryOnItemCard_Tag"
				},
				{
					Text = module.createElement(module2.Text, {
						tag = "auto-xy text-caption-medium content-emphasis",
						Text = props.tagText
					})
				}
			)
		}
	) else nil
	v10.Tag = v11
	v7.presentationSlot = createElement2(
		view,
		{
			tag = "size-full-full radius-medium clip",
			testId = "PhotoboothMomentsTryOnItemCard_Thumbnail"
		},
		v10
	)
	return createElement(catalogItemCard, v7)
end

return PhotoboothMomentsTryOnItemCard
