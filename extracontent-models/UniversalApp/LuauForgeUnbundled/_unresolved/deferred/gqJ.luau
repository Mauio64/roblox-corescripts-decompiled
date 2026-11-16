local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local module2 = require("@luauforge/bundled/dMd")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local module5 = require("@luauforge/deferred/goR")
local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")
local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
local module8 = require("@luauforge/deferred/gkN")
local module9 = require("@luauforge/bundled/dMx")
local constants = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Constants
local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local module11 = require("@luauforge/bundled/dPG")
local catalogCategories = module2.Enums.CatalogCategories
local catalogSubcategories = AvatarExperienceCommon.Enums.CatalogSubcategories

local contextualActionButton = AvatarExperienceCommon.Components.ContextualActionButton
local colorGradientCircle = AvatarExperienceCommon.Components.ColorGradientCircle
local slotBasedEditorAnalytics = AvatarExperienceAnalytics.Surfaces.SlotBasedEditorAnalytics

local module12 = require("@luauforge/bundled/gqw")

local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local iconOnlyMenu = module5.IconOnlyMenu
local menuItemEnum = module5.Enums.MenuItemEnum
local iconName = Foundation.Enums.IconName
local axTooltip = module8.AXTooltipComponents.AXTooltip

local useTokens = Foundation.Hooks.useTokens
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local useMakeupLayeringTooltip = AvatarExperienceCatalog.Hooks.useMakeupLayeringTooltip

local fFlagAXColorAdjustmentButtonShouldAccountForTryOns = AvatarExperienceFlags.FFlagAXColorAdjustmentButtonShouldAccountForTryOns
local fFlagAXShowHeadAdjustmentInRightControlBar = AvatarExperienceFlags.FFlagAXShowHeadAdjustmentInRightControlBar
local fFlagAXMigrateBuilderIcons = AvatarExperienceFlags.FFlagAXMigrateBuilderIcons
local fFlagHeadRefinementFacialAnimationToggle = AvatarExperienceFlags.FFlagHeadRefinementFacialAnimationToggle
local fFlagAXMakeupLayeringTooltipFTUX = AvatarExperienceFlags.FFlagAXMakeupLayeringTooltipFTUX

local defineFastFlag = game:DefineFastFlag("AXFixDynamicHeadsContextualButtonVisibilityLogic", false)

local selectColorAdjustmentButtonColor = AvatarExperienceCommon.State.Selectors.selectColorAdjustmentButtonColor
local v5

if fFlagAXColorAdjustmentButtonShouldAccountForTryOns then
	v5 = AvatarExperienceCommon.State.Selectors.selectShowColorQuickButton
else
	v5 = require("@luauforge/deferred/gqi")
end

local selectCurrentAvatarEditorCategory = AvatarExperienceCommon.State.Selectors.selectCurrentAvatarEditorCategory
local selectHasMakeupTryOn = AvatarExperienceCommon.State.Selectors.selectHasMakeupTryOn
local selectTotalLayeredMakeupAssets = AvatarExperienceCommon.State.Selectors.selectTotalLayeredMakeupAssets

local module13 = require("@luauforge/deferred/gqK")

local module14 = require("@luauforge/bundled/dOj")
local avatarEditorSubcategories = module2.Enums.AvatarEditorSubcategories

local MIN_MAKEUP_ITEMS_FOR_LAYERING_BUTTON = constants.MIN_MAKEUP_ITEMS_FOR_LAYERING_BUTTON

local function selectDeviceOrientation(p2)
	return p2.DeviceOrientation
end

local function selectIsInHeadsSubcategory(p2): boolean
	local v6 = selectCurrentAvatarEditorCategory(p2)
	local v7 = module14()[v6]

	if not (v7 and v7.Subcategories) then
		return false
	end

	local subcategory = p2.AvatarExperience.AvatarEditor.Categories.subcategory

	if not subcategory then
		return false
	end

	local subcategory2 = v7.Subcategories[subcategory]
	return subcategory2 ~= nil and subcategory2.Id == avatarEditorSubcategories.Heads
end

local function selectEquippedDynamicHeadAndTryOnBundle(p2)
	local v6 = nil
	local equippedAssets = p2.AvatarExperience
		and p2.AvatarExperience.AvatarEditor
		and p2.AvatarExperience.AvatarEditor.Character
		and p2.AvatarExperience.AvatarEditor.Character.EquippedAssets
	local v7

	if equippedAssets and equippedAssets[module9.AssetTypeIdStrings.DynamicHead] then
		v7 = next(equippedAssets[module9.AssetTypeIdStrings.DynamicHead])
	end

	local assetInfos = p2.AvatarExperience
		and p2.AvatarExperience.Common
		and p2.AvatarExperience.Common.AssetInfos

	if v7 and assetInfos then
		v6 = assetInfos[v7]
	end

	local v8, v9 = module12(p2, module9.AssetTypeIdStrings.DynamicHead)

	local v10 = if v8 and assetInfos then assetInfos[v8] else nil

	local v11 = false

	local tryOnItems = p2.AvatarExperience.AvatarScene.OutfitTryOn
		and p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems

	local itemId = nil
	local v12 = nil

	if tryOnItems and v8 then
		for k, tryOnItem in tryOnItems do
			if tryOnItem.itemType == module9.ItemType.Bundle and tryOnItem.bundleInfo then
				if tryOnItem.bundleInfo[v8] then
					itemId = tryOnItem.itemId
					v12 = tryOnItem
					break
				end
			elseif tryOnItem.itemType == module9.ItemType.Asset and tryOnItem.itemId == v8 then
				itemId = tryOnItem.itemId
				v12 = tryOnItem
				break
			end
		end
	end

	local bundleInfos = p2.AvatarExperience
		and p2.AvatarExperience.Common
		and p2.AvatarExperience.Common.BundleInfos

	local v13 = if itemId and bundleInfos then bundleInfos[itemId] else nil

	local v14 = nil

	if v12 and v12.itemSubType == module9.BundleTypeIdStrings.DynamicHead and v12.bundleInfo then
		for k, v16 in v12.bundleInfo do
			local v17 = if assetInfos then assetInfos[k] else nil

			if v17 and v17.supportsHeadShapes == true then
				v14 = true
				break
			end
		end
	end

	if v10 and v10.supportsHeadShapes ~= nil then
		v11 = v10.supportsHeadShapes
	elseif v13 and v13.supportsHeadShapes ~= nil then
		v11 = v13.supportsHeadShapes
	elseif v14 == nil then
		if v8 == nil and v6 and v6.supportsHeadShapes ~= nil then
			v11 = v6.supportsHeadShapes
		end
	else
		v11 = v14
	end

	local v15 = if fFlagHeadRefinementFacialAnimationToggle then v7 ~= nil or v8 ~= nil else nil
	return {
		equippedDynamicHeadId = v7,
		equippedDynamicHeadInfo = v6,
		tryOnAssetId = v8,
		tryOnDynamicHeadAssetInfo = v10,
		supportsHeadShapes = v11,
		hasDynamicHead = v15
	}
end

local function ContextualActions(p2)
	local v6 = useTokens()
	local v7 = useNavigation()
	local v8 = useAvatarRoute()

	local catalogSelectionStore = module11.getCatalogSelectionStore()
	local v9 = useSignalState(catalogSelectionStore.selectedCategoryId)
	local v10 = useSignalState(catalogSelectionStore.selectedSubcategoryId)

	local v11 = useSelector(selectColorAdjustmentButtonColor)
	local v12 = useSelector(v5)
	local v13

	if fFlagAXShowHeadAdjustmentInRightControlBar then
		v13 = useSelector(selectEquippedDynamicHeadAndTryOnBundle)
	end

	local v14

	if fFlagAXShowHeadAdjustmentInRightControlBar then
		v14 = useSelector(selectIsInHeadsSubcategory)
	end

	local v15 = useSelector(selectHasMakeupTryOn)
	local v16 = useSelector(selectTotalLayeredMakeupAssets)
	local v17 = useSelector(module13)

	local v18 = v8.opaque.name == avatarScreen.AvatarEditor

	local v19 = v15 and MIN_MAKEUP_ITEMS_FOR_LAYERING_BUTTON <= v16
	local v20 = v9 == catalogCategories.Makeup:rawValue() and v19 or v18 and v17
	local v21

	if fFlagAXMakeupLayeringTooltipFTUX then
		v21 = useLocalization({
			makeupLayeringTooltipText = "Feature.Avatar.Text.MakeupLayeringTooltip"
		})
	end

	local v22 = if fFlagAXMakeupLayeringTooltipFTUX then useMakeupLayeringTooltip(v20) else nil

	local v23 = fFlagAXMakeupLayeringTooltipFTUX
		and (useSelector(selectDeviceOrientation) == Responsive.Keys.Portrait and "Left" or "Right")
		or nil

	local function fn()
		if fFlagAXMakeupLayeringTooltipFTUX then
			v22.dismissTooltip()
		end

		v7.navigate(avatarScreen.LayeredMakeupSort)

		if v8 and v8.opaque then
			slotBasedEditorAnalytics.trackAdvancedCustomizationControlBarClickFromSurface(
				menuItemEnum.AvatarRefinement.MakeupLayers,
				v8.opaque.name
			)
		end
	end

	local v26 = React.useCallback(fn, { v7, v8, if fFlagAXMakeupLayeringTooltipFTUX then v22 else nil })
	local v27

	if fFlagAXShowHeadAdjustmentInRightControlBar then
		v27 = React.useCallback(function()
			v7.navigate(avatarScreen.HeadRefinement)

			if v8 and v8.opaque then
				slotBasedEditorAnalytics.trackAdvancedCustomizationControlBarClickFromSurface(
					menuItemEnum.AvatarRefinement.CustomizeHead,
					v8.opaque.name
				)
			end
		end, { v7, v8 })
	end

	local v28

	if fFlagAXShowHeadAdjustmentInRightControlBar then
		local v29

		if fFlagHeadRefinementFacialAnimationToggle then
			v29 = v13 and v13.hasDynamicHead
		else
			v29 = if v13 then v13.supportsHeadShapes or false else false
		end

		local v30 = v14 and v29
		local v31 = v13 and v13.tryOnAssetId ~= nil

		if defineFastFlag then
			v28 = v30 and v18
		else
			local v32 = v10 == catalogSubcategories.Heads:rawValue()
			v28 = v30 or v31 and v32
		end
	end

	local createElement = React.createElement
	local view = Foundation.View
	local v29 = { LayoutOrder = p2.LayoutOrder, tag = "col gap-small auto-xy" }
	local v31

	if v12 and v11 then
		v31 = React.createElement(contextualActionButton, {
			size = UDim.new(0, v6.Size.Size_1100),
			onActivated = function()
				v7.navigate(avatarScreen.ColorAdjustment)
			end,
			LayoutOrder = 1,
			Selectable = true
		}, React.createElement(colorGradientCircle, {
			Colors = { v11 },
			Size = UDim2.fromOffset(v6.Size.Size_500, v6.Size.Size_500),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5)
		}))
	end

	local v32 = if fFlagAXShowHeadAdjustmentInRightControlBar and v28 then React.createElement(iconOnlyMenu, {
		LayoutOrder = 3,
		items = {
			{
				type = "icon",
				id = menuItemEnum.AvatarRefinement.CustomizeHead,
				icon = not fFlagAXMigrateBuilderIcons and "icons/menu/clothing/classicHead_off" or iconName.HeadBlank,
				iconSize = v6.Size.Size_600,
				onActivated = v27
			}
		}
	}) else nil
	local v33

	if v20 then
		local createElement2 = React.createElement
		local view2 = Foundation.View

		local v35 = {
			MakeupLayeringButton = React.createElement(iconOnlyMenu, {
				items = {
					{
						type = "icon",
						id = menuItemEnum.AvatarRefinement.MakeupLayers,
						icon = not fFlagAXMigrateBuilderIcons and "icons/menu/clothing/eyelash_off" or iconName.LipsLipstickMakeupBrush,
						iconSize = v6.Size.Size_600,
						onActivated = v26
					}
				}
			}),
			MakeupLayeringTooltip = 0
		}

		local v36 = if fFlagAXMakeupLayeringTooltipFTUX then React.createElement(axTooltip, {
			isOpen = v22.showTooltip,
			popoverSide = v23,
			tooltipText = v21.makeupLayeringTooltipText,
			onTooltipActivated = v22.dismissTooltip
		}) else nil
		v35.MakeupLayeringTooltip = v36
		v33 = createElement2(view2, { tag = "auto-xy", LayoutOrder = 2 }, v35)
	end

	return createElement(view, v29, {
		SkinColorButton = v31,
		HeadAdjustmentButton = v32,
		MakeupLayering = v33
	})
end

return React.memo(React.forwardRef(ContextualActions))
