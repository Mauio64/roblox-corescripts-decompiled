local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local InventoryItemsListContainer = require(Modules.AvatarExperience.SlotBasedEditor.Components.InventoryItemsList.InventoryItemsListContainer)
local TryOnItemCardContainer = require(Modules.AvatarExperience.Photobooth.Components.TryOnItemCard.TryOnItemCardContainer)
local photoboothCategories = require(Modules.AvatarExperience.Photobooth.photoboothCategories)
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization

require(Modules.AvatarExperience.Photobooth.Components.Animations.usePhotoboothAnimationsProps)

local PhotoboothAnimationsPillBar = require(Modules.AvatarExperience.Photobooth.Components.Animations.PhotoboothAnimationsPillBar)
local FFlagAXPhotoboothBugBashFixes = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXPhotoboothBugBashFixes

local function PhotoboothAnimations(p1) -- line: 25
	-- upvalues: useLocalization (copy), React (copy), photoboothCategories (copy), TryOnItemCardContainer (copy), FFlagAXPhotoboothBugBashFixes (copy), Foundation (copy), PhotoboothAnimationsPillBar (copy), InventoryItemsListContainer (copy)
	local v13 = useLocalization({
		animations = "Feature.Avatar.Heading.Animations"
	})
	local v14 = React.useMemo(function() -- line: 31
		-- upvalues: photoboothCategories (copy), p1 (copy)
		return photoboothCategories[p1.animationFilter]
	end, { p1.animationFilter })
	local v15 = React.useCallback(function(p2, p3) -- line: 35
		-- upvalues: React (copy), TryOnItemCardContainer (copy), FFlagAXPhotoboothBugBashFixes (copy), p1 (copy)
		return React.createElement(TryOnItemCardContainer, {
			inventoryItemType = p2.item.inventoryItemType,
			itemId = p2.item.itemId,
			isSelected = p2.item.itemId ~= nil and p3.ownedItemIdToIsWearing[p2.item.itemId] == true,
			impressionsTag = p3.impressionsTag,
			onTileClicked = if not FFlagAXPhotoboothBugBashFixes then nil else p1.onTileClicked
		})
	end, if not FFlagAXPhotoboothBugBashFixes then {} else { p1.onTileClicked })

	return React.createElement(Foundation.View, {
		tag = "col gap-small size-full-full",
		LayoutOrder = 1,
		Position = p1.position
	}, {
		Heading = React.createElement(Foundation.Text, {
			tag = "text-color-primary text-heading-medium text-align-x-left text-align-y-top auto-xy",
			LayoutOrder = 1,
			Text = v13.animations
		}),
		PillBarScrollContainer = React.createElement(Foundation.View, {
			tag = "size-full-0 auto-y",
			LayoutOrder = 2
		}, {
			PillBar = React.createElement(PhotoboothAnimationsPillBar, {
				tokens = p1.tokens,
				animationFilter = p1.animationFilter,
				onAnimationFilterChanged = p1.onAnimationFilterChanged
			})
		}),
		ScrollViewContainer = React.createElement(Foundation.View, {
			tag = "grow-1 size-full-0",
			LayoutOrder = 3
		}, {
			ItemsList = React.createElement(InventoryItemsListContainer, {
				showRecommendedItems = false,
				disableSortsAndFilters = true,
				categoryInfo = v14,
				renderItem = v15
			})
		})
	})
end

return PhotoboothAnimations
