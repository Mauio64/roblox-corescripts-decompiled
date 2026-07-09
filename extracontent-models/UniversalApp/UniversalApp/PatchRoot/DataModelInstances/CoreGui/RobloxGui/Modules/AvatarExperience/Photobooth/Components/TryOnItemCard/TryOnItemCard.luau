local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local CatalogItemCard = AvatarExperienceCommon.Components.CatalogItemCard.CatalogItemCard
local CatalogItemCardItemInfoEnum = AvatarExperienceCommon.Components.CatalogItemCard.CatalogItemCardItemInfoEnum
local ItemCardThumbnail = require(CorePackages.Workspace.Packages.AvatarExperienceUIKit).ItemCardComponents.ItemCardThumbnail
local InventoryItemType = require(CorePackages.Workspace.Packages.AvatarExperienceSlotBasedEditor).Enums.InventoryItemType

local function TryOnItemCard(t1: {[any]: any}) -- line: 29
	-- upvalues: InventoryItemType (copy), React (copy), CatalogItemCard (copy), CatalogItemCardItemInfoEnum (copy), Foundation (copy), ItemCardThumbnail (copy)
	local v11 = if t1.inventoryItemType ~= InventoryItemType.Asset then if t1.inventoryItemType ~= InventoryItemType.Outfit then nil else "Outfit" else "Asset"
	local tokens = t1.tokens
	local Size_50 = tokens.Size.Size_50

	return React.createElement(CatalogItemCard, {
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		isSelected = t1.isSelected,
		title = t1.itemName,
		ref = t1.ref,
		itemInfo = if not t1.showDynamicHeadIcon then nil else CatalogItemCardItemInfoEnum.DynamicHead,
		onActivated = t1.onActivated,
		presentationSlot = React.createElement(Foundation.View, {
			tag = "size-full-full",
			ref = t1.thumbnailRef
		}, {
			UIPadding = if not t1.isSelected then nil else React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, Size_50),
				PaddingBottom = UDim.new(0, Size_50),
				PaddingLeft = UDim.new(0, Size_50),
				PaddingRight = UDim.new(0, Size_50)
			}),
			InnerContent = React.createElement(Foundation.View, {
				Size = UDim2.fromScale(1, 1),
				tag = `clip radius-medium { t1.impressionsTag }`,
				backgroundStyle = {
					Transparency = 1
				}
			}, {
				UIStroke = if not t1.isSelected then nil else React.createElement("UIStroke", {
					Transparency = 0,
					Thickness = Size_50,
					Color = tokens.Color.ActionSubEmphasis.Background.Color3
				}),
				Thumbnail = v11 and React.createElement(ItemCardThumbnail, {
					url = `rbxthumb://type={ v11 }&id={ t1.itemId }&w=150&h=150&filter=0`
				})
			})
		})
	})
end

return TryOnItemCard
