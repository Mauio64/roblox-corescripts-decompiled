local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local module2 = require("@luauforge/bundled/dPt")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local module5 = require("@luauforge/deferred/gTu")
local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")
local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
local module8 = require("@luauforge/deferred/gPt")
local module9 = require("@luauforge/bundled/dPN")
local constants = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Constants
local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local module11 = require("@luauforge/bundled/dSW")
local catalogCategories = module2.Enums.CatalogCategories
local catalogSubcategories = AvatarExperienceCommon.Enums.CatalogSubcategories

local contextualActionButton = AvatarExperienceCommon.Components.ContextualActionButton
local colorGradientCircle = AvatarExperienceCommon.Components.ColorGradientCircle
local slotBasedEditorAnalytics = AvatarExperienceAnalytics.Surfaces.SlotBasedEditorAnalytics

local module12 = require("@luauforge/bundled/gUX")

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

local fFlagAXShowHeadAdjustmentInRightControlBar = AvatarExperienceFlags.FFlagAXShowHeadAdjustmentInRightControlBar
local fFlagAXMigrateBuilderIcons = AvatarExperienceFlags.FFlagAXMigrateBuilderIcons
local fFlagHeadRefinementFacialAnimationToggle = AvatarExperienceFlags.FFlagHeadRefinementFacialAnimationToggle
local fFlagAXMakeupLayeringTooltipFTUX = AvatarExperienceFlags.FFlagAXMakeupLayeringTooltipFTUX

local defineFastFlag = game:DefineFastFlag("AXFixDynamicHeadsContextualButtonVisibilityLogic", false)

local selectColorAdjustmentButtonColor = AvatarExperienceCommon.State.Selectors.selectColorAdjustmentButtonColor
local selectShowColorQuickButton = AvatarExperienceCommon.State.Selectors.selectShowColorQuickButton

local selectCurrentAvatarEditorCategory = AvatarExperienceCommon.State.Selectors.selectCurrentAvatarEditorCategory
local selectHasMakeupTryOn = AvatarExperienceCommon.State.Selectors.selectHasMakeupTryOn
local selectTotalLayeredMakeupAssets = AvatarExperienceCommon.State.Selectors.selectTotalLayeredMakeupAssets

local module13 = require("@luauforge/deferred/gVl")

local module14 = require("@luauforge/bundled/dRz")
local avatarEditorSubcategories = module2.Enums.AvatarEditorSubcategories

local MIN_MAKEUP_ITEMS_FOR_LAYERING_BUTTON = constants.MIN_MAKEUP_ITEMS_FOR_LAYERING_BUTTON

local function selectDeviceOrientation(p2)
	return p2.DeviceOrientation
end

local function selectIsInHeadsSubcategory(p2): boolean
	local v5 = selectCurrentAvatarEditorCategory(p2)
	local v6 = module14()[v5]

	if not (v6 and v6.Subcategories) then
		return false
	end

	local subcategory = p2.AvatarExperience.AvatarEditor.Categories.subcategory

	if not subcategory then
		return false
	end

	local subcategory2 = v6.Subcategories[subcategory]
	return subcategory2 ~= nil and subcategory2.Id == avatarEditorSubcategories.Heads
end

local function selectEquippedDynamicHeadAndTryOnBundle(p2)
	local v5 = nil
	local equippedAssets = p2.AvatarExperience
		and p2.AvatarExperience.AvatarEditor
		and p2.AvatarExperience.AvatarEditor.Character
		and p2.AvatarExperience.AvatarEditor.Character.EquippedAssets
	local v6

	if equippedAssets and equippedAssets[module9.AssetTypeIdStrings.DynamicHead] then
		v6 = next(equippedAssets[module9.AssetTypeIdStrings.DynamicHead])
	end

	local assetInfos = p2.AvatarExperience
		and p2.AvatarExperience.Common
		and p2.AvatarExperience.Common.AssetInfos

	if v6 and assetInfos then
		v5 = assetInfos[v6]
	end

	local v7, v8 = module12(p2, module9.AssetTypeIdStrings.DynamicHead)

	local v9 = if v7 and assetInfos then assetInfos[v7] else nil

	local v10 = false

	local tryOnItems = p2.AvatarExperience.AvatarScene.OutfitTryOn
		and p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems

	local itemId = nil
	local v11 = nil

	if tryOnItems and v7 then
		for k, tryOnItem in tryOnItems do
			if tryOnItem.itemType == module9.ItemType.Bundle and tryOnItem.bundleInfo then
				if tryOnItem.bundleInfo[v7] then
					itemId = tryOnItem.itemId
					v11 = tryOnItem
					break
				end
			elseif tryOnItem.itemType == module9.ItemType.Asset and tryOnItem.itemId == v7 then
				itemId = tryOnItem.itemId
				v11 = tryOnItem
				break
			end
		end
	end

	local bundleInfos = p2.AvatarExperience
		and p2.AvatarExperience.Common
		and p2.AvatarExperience.Common.BundleInfos

	local v12 = if itemId and bundleInfos then bundleInfos[itemId] else nil

	local v13 = nil

	if v11 and v11.itemSubType == module9.BundleTypeIdStrings.DynamicHead and v11.bundleInfo then
		for k, v15 in v11.bundleInfo do
			local v16 = if assetInfos then assetInfos[k] else nil

			if v16 and v16.supportsHeadShapes == true then
				v13 = true
				break
			end
		end
	end

	if v9 and v9.supportsHeadShapes ~= nil then
		v10 = v9.supportsHeadShapes
	elseif v12 and v12.supportsHeadShapes ~= nil then
		v10 = v12.supportsHeadShapes
	elseif v13 == nil then
		if v7 == nil and v5 and v5.supportsHeadShapes ~= nil then
			v10 = v5.supportsHeadShapes
		end
	else
		v10 = v13
	end

	local v14 = if fFlagHeadRefinementFacialAnimationToggle then v6 ~= nil or v7 ~= nil else nil
	return {
		equippedDynamicHeadId = v6,
		equippedDynamicHeadInfo = v5,
		tryOnAssetId = v7,
		tryOnDynamicHeadAssetInfo = v9,
		supportsHeadShapes = v10,
		hasDynamicHead = v14
	}
end

local function ContextualActions(p2)
	local v5 = useTokens()
	local v6 = useNavigation()
	local v7 = useAvatarRoute()

	local catalogSelectionStore = module11.getCatalogSelectionStore()
	local v8 = useSignalState(catalogSelectionStore.selectedCategoryId)
	local v9 = useSignalState(catalogSelectionStore.selectedSubcategoryId)

	local v10 = useSelector(selectColorAdjustmentButtonColor)
	local v11 = useSelector(selectShowColorQuickButton)
	local v12

	if fFlagAXShowHeadAdjustmentInRightControlBar then
		v12 = useSelector(selectEquippedDynamicHeadAndTryOnBundle)
	end

	local v13

	if fFlagAXShowHeadAdjustmentInRightControlBar then
		v13 = useSelector(selectIsInHeadsSubcategory)
	end

	local v14 = useSelector(selectHasMakeupTryOn)
	local v15 = useSelector(selectTotalLayeredMakeupAssets)
	local v16 = useSelector(module13)

	local v17 = v7.opaque.name == avatarScreen.AvatarEditor

	local v18 = v14 and MIN_MAKEUP_ITEMS_FOR_LAYERING_BUTTON <= v15
	local v19 = v8 == catalogCategories.Makeup:rawValue() and v18 or v17 and v16
	local v20

	if fFlagAXMakeupLayeringTooltipFTUX then
		v20 = useLocalization({
			makeupLayeringTooltipText = "Feature.Avatar.Text.MakeupLayeringTooltip"
		})
	end

	local v21 = if fFlagAXMakeupLayeringTooltipFTUX then useMakeupLayeringTooltip(v19) else nil

	local v22 = fFlagAXMakeupLayeringTooltipFTUX
		and (useSelector(selectDeviceOrientation) == Responsive.Keys.Portrait and "Left" or "Right")
		or nil

	local function fn()
		if fFlagAXMakeupLayeringTooltipFTUX then
			v21.dismissTooltip()
		end

		v6.navigate(avatarScreen.LayeredMakeupSort)

		if v7 and v7.opaque then
			slotBasedEditorAnalytics.trackAdvancedCustomizationControlBarClickFromSurface(
				menuItemEnum.AvatarRefinement.MakeupLayers,
				v7.opaque.name
			)
		end
	end

	local v25 = React.useCallback(fn, { v6, v7, if fFlagAXMakeupLayeringTooltipFTUX then v21 else nil })
	local v26

	if fFlagAXShowHeadAdjustmentInRightControlBar then
		v26 = React.useCallback(function()
			v6.navigate(avatarScreen.HeadRefinement)

			if v7 and v7.opaque then
				slotBasedEditorAnalytics.trackAdvancedCustomizationControlBarClickFromSurface(
					menuItemEnum.AvatarRefinement.CustomizeHead,
					v7.opaque.name
				)
			end
		end, { v6, v7 })
	end

	local v27

	if fFlagAXShowHeadAdjustmentInRightControlBar then
		local v28

		if fFlagHeadRefinementFacialAnimationToggle then
			v28 = v12 and v12.hasDynamicHead
		else
			v28 = if v12 then v12.supportsHeadShapes or false else false
		end

		local v29 = v13 and v28
		local v30 = v12 and v12.tryOnAssetId ~= nil

		if defineFastFlag then
			v27 = v29 and v17
		else
			local v31 = v9 == catalogSubcategories.Heads:rawValue()
			v27 = v29 or v30 and v31
		end
	end

	local createElement = React.createElement
	local view = Foundation.View
	local v28 = { LayoutOrder = p2.LayoutOrder, tag = "col gap-small auto-xy" }
	local v30

	if v11 and v10 then
		v30 = React.createElement(contextualActionButton, {
			size = UDim.new(0, v5.Size.Size_1100),
			onActivated = function()
				v6.navigate(avatarScreen.ColorAdjustment)
			end,
			LayoutOrder = 1,
			Selectable = true
		}, React.createElement(colorGradientCircle, {
			Colors = { v10 },
			Size = UDim2.fromOffset(v5.Size.Size_500, v5.Size.Size_500),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5)
		}))
	end

	local v31 = if fFlagAXShowHeadAdjustmentInRightControlBar and v27 then React.createElement(iconOnlyMenu, {
		LayoutOrder = 3,
		items = {
			{
				type = "icon",
				id = menuItemEnum.AvatarRefinement.CustomizeHead,
				icon = not fFlagAXMigrateBuilderIcons and "icons/menu/clothing/classicHead_off" or iconName.HeadBlank,
				iconSize = v5.Size.Size_600,
				onActivated = v26
			}
		}
	}) else nil
	local v32

	if v19 then
		local createElement2 = React.createElement
		local view2 = Foundation.View

		local v34 = {
			MakeupLayeringButton = React.createElement(iconOnlyMenu, {
				items = {
					{
						type = "icon",
						id = menuItemEnum.AvatarRefinement.MakeupLayers,
						icon = not fFlagAXMigrateBuilderIcons and "icons/menu/clothing/eyelash_off" or iconName.LipsLipstickMakeupBrush,
						iconSize = v5.Size.Size_600,
						onActivated = v25
					}
				}
			}),
			MakeupLayeringTooltip = 0
		}

		local v35 = if fFlagAXMakeupLayeringTooltipFTUX then React.createElement(axTooltip, {
			isOpen = v21.showTooltip,
			popoverSide = v22,
			tooltipText = v20.makeupLayeringTooltipText,
			onTooltipActivated = v21.dismissTooltip
		}) else nil
		v34.MakeupLayeringTooltip = v35
		v32 = createElement2(view2, { tag = "auto-xy", LayoutOrder = 2 }, v34)
	end

	return createElement(view, v28, {
		SkinColorButton = v30,
		HeadAdjustmentButton = v31,
		MakeupLayering = v32
	})
end

return React.memo(React.forwardRef(ContextualActions))
