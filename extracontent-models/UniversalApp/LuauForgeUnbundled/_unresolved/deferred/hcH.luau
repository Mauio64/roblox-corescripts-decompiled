local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector

local module = require("@luauforge/deferred/hcI")
local module2 = require("@luauforge/deferred/hek")
local module3 = require("@luauforge/bundled/fCe")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXAddInventoryItemsListProps = AvatarExperienceFlags.FFlagAXAddInventoryItemsListProps

local fFlagAXBackgroundsHidePlusUpsellsWhenGuacDisabled = AvatarExperienceFlags.FFlagAXBackgroundsHidePlusUpsellsWhenGuacDisabled

local fFlagAXBackgroundsHideCreateTileWithoutAiEntitlement = AvatarExperienceFlags.FFlagAXBackgroundsHideCreateTileWithoutAiEntitlement

local module5 = require("@luauforge/deferred/hcO")
local categories = require("@luauforge/bundled/fCn").Enums.Categories

local function DefaultInventoryItemsList(p2)
	if fFlagAXBackgroundsHideCreateTileWithoutAiEntitlement then
		module5.usePrefetchAiBackgroundEntitlement()
	end

	local v5 = module2(p2)
	return React.createElement(module, v5)
end

local function BackgroundsInventoryItemsList(p2)
	local backgroundVariants = module5.useBackgroundsPlusAccess().backgroundVariants
	local showExclusiveWithPlusSection = backgroundVariants.showExclusiveWithPlusSection
	local v5

	if fFlagAXBackgroundsHideCreateTileWithoutAiEntitlement then
		v5 = backgroundVariants.showInventoryCreateTile
	end

	local v6 = module2(p2, showExclusiveWithPlusSection, v5)
	return React.createElement(module, v6)
end

local function renderForNavigationKey(p2, p3)
	if p3 == categories.Backgrounds then
		return React.createElement(BackgroundsInventoryItemsList, p2)
	end

	return React.createElement(DefaultInventoryItemsList, p2)
end

local function StoreRoutedInventoryItemsList()
	return renderForNavigationKey(nil, useSelector(function(p2)
		return module3.getAvatarEditorCategoryInfoFromState(p2).NavigationKey
	end))
end

local function InventoryItemsListContainer(p2)
	if fFlagAXBackgroundsHidePlusUpsellsWhenGuacDisabled then
		if fFlagAXAddInventoryItemsListProps then
			return renderForNavigationKey(p2, p2.categoryInfo.NavigationKey)
		end

		return React.createElement(StoreRoutedInventoryItemsList)
	elseif fFlagAXAddInventoryItemsListProps then
		return React.createElement(DefaultInventoryItemsList, p2)
	else
		return React.createElement(DefaultInventoryItemsList)
	end
end

return React.memo(InventoryItemsListContainer)
