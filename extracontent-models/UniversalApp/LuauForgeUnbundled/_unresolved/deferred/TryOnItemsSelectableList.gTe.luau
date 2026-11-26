local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local module = require("@luauforge/deferred/gTb")
local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local itemTypeEnum = require("@luauforge/bundled/dPt").Enums.ItemTypeEnum

local module3 = require("@luauforge/bundled/gxM")
local module4 = require("@luauforge/deferred/gTd")
local module5 = require("@luauforge/deferred/gSv")

local selectableItemCardList = module.Components.SelectableItemCardList
local constants = AvatarExperienceCatalog.Constants

local ASSET_TYPE_LOCALIZED = constants.ASSET_TYPE_LOCALIZED
local BUNDLE_TYPE_LOCALIZED = constants.BUNDLE_TYPE_LOCALIZED

local function TryOnItemsSelectableList(props)
	local v5 = module4()
	local v6 = useDispatch()

	local v7 = module3(ASSET_TYPE_LOCALIZED)
	local v8 = module3(BUNDLE_TYPE_LOCALIZED)
	local v9 = { [itemTypeEnum.Asset] = v7, [itemTypeEnum.Bundle] = v8 }

	local v10 = React.useCallback(function(p2, p3)
		v6(module5(p2.id, p3, nil, p2.itemType, avatarScreen.TryOnItem))
	end, { v6 })

	return React.createElement(selectableItemCardList, {
		rows = v5,
		itemCardWidth = props.itemCardWidth,
		priceStatusLabels = props.priceStatusLabels,
		itemSubTypeLabels = v9,
		onSelectionChanged = v10,
		LayoutOrder = props.LayoutOrder
	})
end

return TryOnItemsSelectableList
