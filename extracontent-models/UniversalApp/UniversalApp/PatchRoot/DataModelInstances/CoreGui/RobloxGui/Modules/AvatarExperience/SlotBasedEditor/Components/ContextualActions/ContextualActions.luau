local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local AvatarExperienceControlBar = require(CorePackages.Workspace.Packages.AvatarExperienceControlBar)
local AvatarExperienceAnalytics = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics)
local AvatarExperienceCatalog = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)
local AvatarExperienceUIKit = require(CorePackages.Workspace.Packages.AvatarExperienceUIKit)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local AvatarExperienceSlotBasedEditor = require(CorePackages.Workspace.Packages.AvatarExperienceSlotBasedEditor)
local Constants2 = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Constants
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local GetCatalogCategoriesStore = require(Modules.AvatarExperience.Catalog.Stores.GetCatalogCategoriesStore)
local CatalogCategories = AvatarExperienceCommon.Enums.CatalogCategories
local CatalogSubcategories = AvatarExperienceCommon.Enums.CatalogSubcategories
local ContextualActionButton = AvatarExperienceCommon.Components.ContextualActionButton
local ColorGradientCircle = AvatarExperienceCommon.Components.ColorGradientCircle
local SlotBasedEditorAnalytics = AvatarExperienceAnalytics.Surfaces.SlotBasedEditorAnalytics
local SelectOutfitTryOnMostRecentAssetId = require(Modules.AvatarExperience.Common.Selectors.SelectOutfitTryOnMostRecentAssetId)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local IconOnlyMenu = AvatarExperienceControlBar.IconOnlyMenu
local MenuItemEnum = AvatarExperienceControlBar.Enums.MenuItemEnum
local IconName = Foundation.Enums.IconName
local AXTooltip = AvatarExperienceUIKit.AXTooltipComponents.AXTooltip
local useTokens = Foundation.Hooks.useTokens
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local useMakeupLayeringTooltip = AvatarExperienceCatalog.Hooks.useMakeupLayeringTooltip
local FFlagAXColorAdjustmentButtonShouldAccountForTryOns = AvatarExperienceFlags.FFlagAXColorAdjustmentButtonShouldAccountForTryOns
local FFlagAXShowHeadAdjustmentInRightControlBar = AvatarExperienceFlags.FFlagAXShowHeadAdjustmentInRightControlBar
local FFlagAXMigrateBuilderIcons = AvatarExperienceFlags.FFlagAXMigrateBuilderIcons
local FFlagDynamicHeadsMigration = AvatarExperienceFlags.FFlagDynamicHeadsMigration
local FFlagAXMakeupEquipping = AvatarExperienceFlags.FFlagAXMakeupEquipping
local FFlagHeadRefinementFacialAnimationToggle = AvatarExperienceFlags.FFlagHeadRefinementFacialAnimationToggle
local FFlagAXMakeupLayeringTooltipFTUX = AvatarExperienceFlags.FFlagAXMakeupLayeringTooltipFTUX
local v43 = game:DefineFastFlag("AXFixContextualButtonVisibilityLogic", false)
local v44 = game:DefineFastFlag("AXFixDynamicHeadsContextualButtonVisibilityLogic", false)
local selectColorAdjustmentButtonColor = AvatarExperienceCommon.State.Selectors.selectColorAdjustmentButtonColor
local v46 = if not FFlagAXColorAdjustmentButtonShouldAccountForTryOns then require(Modules.AvatarExperience.Common.Selectors.selectShowColorQuickButton) else AvatarExperienceCommon.State.Selectors.selectShowColorQuickButton
local selectCurrentAvatarEditorCategory = AvatarExperienceCommon.State.Selectors.selectCurrentAvatarEditorCategory
local selectHasMakeupTryOn = AvatarExperienceCommon.State.Selectors.selectHasMakeupTryOn
local selectTotalLayeredMakeupAssets = AvatarExperienceCommon.State.Selectors.selectTotalLayeredMakeupAssets
local selectIsInMakeupCategoryWithMultipleItems = require(Modules.AvatarExperience.Common.Selectors.selectIsInMakeupCategoryWithMultipleItems)
local GetAvatarEditorCategories = require(Modules.AvatarExperience.AvatarEditor.GetAvatarEditorCategories)
local AvatarEditorSubcategories = AvatarExperienceSlotBasedEditor.Enums.AvatarEditorSubcategories
local SetSelectedAccessory = require(Modules.AvatarExperience.AccessoryAdjustment.Actions.SetSelectedAccessory)
local SetEntryPage = require(Modules.AvatarExperience.LayeredClothingSort.Actions.SetEntryPage)
local GetFFlagAXFixAccessoryAdjustmentAnalyticsEntryPage = require(Modules.AvatarExperience.Flags.GetFFlagAXFixAccessoryAdjustmentAnalyticsEntryPage)
local AXEnableAccessoryAdjustmentDuringTryOnIXP = require(CorePackages.Workspace.Packages.AvatarExperienceExperiments).AXEnableAccessoryAdjustmentDuringTryOnIXP
local useAccessoryAdjustmentQuickButtonDuringTryOn = require(Modules.AvatarExperience.Common.Hooks.useAccessoryAdjustmentQuickButtonDuringTryOn)
local MIN_MAKEUP_ITEMS_FOR_LAYERING_BUTTON = Constants2.MIN_MAKEUP_ITEMS_FOR_LAYERING_BUTTON

local function selectDeviceOrientation(p1) -- line: 81
	return p1.DeviceOrientation
end
local function selectIsInHeadsSubcategory(p2) -- line: 85
	-- upvalues: selectCurrentAvatarEditorCategory (copy), GetAvatarEditorCategories (copy), AvatarEditorSubcategories (copy)
	local v65 = selectCurrentAvatarEditorCategory(p2)
	local v66 = GetAvatarEditorCategories()[v65]

	if not v66 or not v66.Subcategories then
		return false
	end

	local subcategory = p2.AvatarExperience.AvatarEditor.Categories.subcategory

	if not subcategory then
		return false
	end

	local v68 = v66.Subcategories[subcategory]

	return v68 ~= nil and v68.Id == AvatarEditorSubcategories.Heads
end
local function selectEquippedDynamicHeadAndTryOnBundle(p3) -- line: 101
	-- upvalues: Constants (copy), SelectOutfitTryOnMostRecentAssetId (copy), FFlagDynamicHeadsMigration (copy), FFlagHeadRefinementFacialAnimationToggle (copy)
	local v70 = nil
	local v71 = nil
	local v72 = p3.AvatarExperience and (p3.AvatarExperience.AvatarEditor and (p3.AvatarExperience.AvatarEditor.Character and p3.AvatarExperience.AvatarEditor.Character.EquippedAssets))

	if v72 and v72[Constants.AssetTypeIdStrings.DynamicHead] then
		v70 = next(v72[Constants.AssetTypeIdStrings.DynamicHead])
	end

	local v73 = p3.AvatarExperience and (p3.AvatarExperience.Common and p3.AvatarExperience.Common.AssetInfos)

	if v70 and v73 then
		v71 = v73[v70]
	end

	local v74, _ = SelectOutfitTryOnMostRecentAssetId(p3, Constants.AssetTypeIdStrings.DynamicHead)
	local v76 = nil

	if v74 and v73 then
		v76 = v73[v74]
	end

	local v77 = false

	if FFlagDynamicHeadsMigration then
		local v78 = p3.AvatarExperience.AvatarScene.OutfitTryOn and p3.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
		local itemId = nil
		local v80 = nil

		if v78 and v74 then
			for _, v82 in v78 do
				if v82.itemType ~= Constants.ItemType.Bundle or not v82.bundleInfo then
					if v82.itemType ~= Constants.ItemType.Asset or v74 ~= v82.itemId then
						continue
					end

					itemId = v82.itemId
					v80 = v82

					break
				end

				if v82.bundleInfo[v74] then
					itemId = v82.itemId
					v80 = v82

					break
				end
			end
		end

		local v83 = p3.AvatarExperience and (p3.AvatarExperience.Common and p3.AvatarExperience.Common.BundleInfos)
		local v84 = nil

		if itemId and v83 then
			v84 = v83[itemId]
		end

		local v85 = nil

		if v80 and v80.itemSubType == Constants.BundleTypeIdStrings.DynamicHead and v80.bundleInfo then
			for v86, _ in v80.bundleInfo do
				local v88 = if not v73 then nil else v73[v86]

				if v88 and v88.supportsHeadShapes == true then
					v85 = true

					break
				end
			end
		end

		if v76 and v76.supportsHeadShapes ~= nil then
			v77 = v76.supportsHeadShapes
		elseif v84 and v84.supportsHeadShapes ~= nil then
			v77 = v84.supportsHeadShapes
		elseif v85 ~= nil then
			v77 = v85
		elseif v74 == nil and v71 and v71.supportsHeadShapes ~= nil then
			v77 = v71.supportsHeadShapes
		end
	elseif v76 then
		v77 = v76.supportsHeadShapes ~= nil and v76.supportsHeadShapes
	elseif v71 then
		v77 = v71.supportsHeadShapes ~= nil and v71.supportsHeadShapes
	end

	return {
		equippedDynamicHeadId = v70,
		equippedDynamicHeadInfo = v71,
		tryOnAssetId = v74,
		tryOnDynamicHeadAssetInfo = v76,
		supportsHeadShapes = v77,
		hasDynamicHead = if not FFlagHeadRefinementFacialAnimationToggle then nil else v70 ~= nil or v74 ~= nil
	}
end
local function ContextualActions(t1: {[any]: any}) -- line: 235
	-- upvalues: useTokens (copy), useNavigation (copy), useAvatarRoute (copy), useDispatch (copy), v43 (copy), GetCatalogCategoriesStore (copy), useSignalState (copy), useSelector (copy), selectColorAdjustmentButtonColor (copy), v46 (copy), AXEnableAccessoryAdjustmentDuringTryOnIXP (copy), useAccessoryAdjustmentQuickButtonDuringTryOn (copy), FFlagAXShowHeadAdjustmentInRightControlBar (copy), selectEquippedDynamicHeadAndTryOnBundle (copy), selectIsInHeadsSubcategory (copy), FFlagAXMakeupEquipping (copy), selectHasMakeupTryOn (copy), selectTotalLayeredMakeupAssets (copy), selectIsInMakeupCategoryWithMultipleItems (copy), v44 (copy), AvatarScreen (copy), MIN_MAKEUP_ITEMS_FOR_LAYERING_BUTTON (copy), CatalogCategories (copy), FFlagAXMakeupLayeringTooltipFTUX (copy), useLocalization (copy), useMakeupLayeringTooltip (copy), selectDeviceOrientation (copy), Responsive (copy), React (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy), FFlagHeadRefinementFacialAnimationToggle (copy), CatalogSubcategories (copy), Foundation (copy), ContextualActionButton (copy), ColorGradientCircle (copy), IconOnlyMenu (copy), FFlagAXMigrateBuilderIcons (copy), IconName (copy), AXTooltip (copy), GetFFlagAXFixAccessoryAdjustmentAnalyticsEntryPage (copy), SetEntryPage (copy), SetSelectedAccessory (copy)
	local v90 = useTokens()
	local v91 = useNavigation()
	local v92 = useAvatarRoute()
	local v93 = useDispatch()
	local v94 = nil
	local v95 = nil

	if v43 then
		local v96 = GetCatalogCategoriesStore.getCatalogSelectionStore()

		v94 = useSignalState(v96.selectedCategoryId)
		v95 = useSignalState(v96.selectedSubcategoryId)
	end

	local v97 = useSelector(selectColorAdjustmentButtonColor)
	local v98 = useSelector(v46)
	local shouldEnableAccessoryAdjustmentDuringTryOn = nil
	local adjustableLastTryOnItemId = nil
	local accessoryAdjustmentQuickButtonFtux = nil

	if AXEnableAccessoryAdjustmentDuringTryOnIXP.isEnabled() then
		local v102 = useAccessoryAdjustmentQuickButtonDuringTryOn()

		shouldEnableAccessoryAdjustmentDuringTryOn = v102.shouldEnableAccessoryAdjustmentDuringTryOn
		adjustableLastTryOnItemId = v102.adjustableLastTryOnItemId
		accessoryAdjustmentQuickButtonFtux = v102.accessoryAdjustmentQuickButtonFtux
	end

	local v103 = if not FFlagAXShowHeadAdjustmentInRightControlBar then nil else useSelector(selectEquippedDynamicHeadAndTryOnBundle)
	local v104 = if not FFlagAXShowHeadAdjustmentInRightControlBar then nil else useSelector(selectIsInHeadsSubcategory)
	local v105 = not not FFlagAXMakeupEquipping and useSelector(selectHasMakeupTryOn)
	local v106 = if not FFlagAXMakeupEquipping then nil else useSelector(selectTotalLayeredMakeupAssets)
	local v107 = not not FFlagAXMakeupEquipping and useSelector(selectIsInMakeupCategoryWithMultipleItems)
	local v108 = (FFlagAXMakeupEquipping or not not v44) and v92.opaque.name == AvatarScreen.AvatarEditor
	local v109 = if not FFlagAXMakeupEquipping then nil else v105 and v106 >= MIN_MAKEUP_ITEMS_FOR_LAYERING_BUTTON
	local v111

	if v43 then
		local v110 = v94 == CatalogCategories.Makeup:rawValue()

		v111 = not not FFlagAXMakeupEquipping and (v110 and v109 or v108 and v107)
	else
		v111 = not not FFlagAXMakeupEquipping and (v109 or v108 and v107)
	end

	local v112 = if not FFlagAXMakeupLayeringTooltipFTUX then nil else useLocalization({
		makeupLayeringTooltipText = "Feature.Avatar.Text.MakeupLayeringTooltip"
	})
	local v113 = if not FFlagAXMakeupLayeringTooltipFTUX then nil else useMakeupLayeringTooltip(v111)
	local v114 = nil

	if FFlagAXMakeupLayeringTooltipFTUX then
		v114 = useSelector(selectDeviceOrientation) ~= Responsive.Keys.Portrait and "Right" or "Left"
	end

	local v115 = if not FFlagAXMakeupEquipping then nil else React.useCallback(function() -- line: 314
		-- upvalues: FFlagAXMakeupLayeringTooltipFTUX (copy), v113 (copy), v91 (copy), AvatarScreen (copy), v92 (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
		if FFlagAXMakeupLayeringTooltipFTUX then
			v113.dismissTooltip()
		end

		v91.navigate(AvatarScreen.LayeredMakeupSort)

		if v92 and v92.opaque then
			SlotBasedEditorAnalytics.trackAdvancedCustomizationControlBarClickFromSurface(MenuItemEnum.AvatarRefinement.MakeupLayers, v92.opaque.name)
		end
	end, {
		v91,
		v92,
		if not FFlagAXMakeupLayeringTooltipFTUX then nil else v113
	})
	local v116 = if not FFlagAXShowHeadAdjustmentInRightControlBar then nil else React.useCallback(function() -- line: 334
		-- upvalues: v91 (copy), AvatarScreen (copy), v92 (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
		v91.navigate(AvatarScreen.HeadRefinement)

		if v92 and v92.opaque then
			SlotBasedEditorAnalytics.trackAdvancedCustomizationControlBarClickFromSurface(MenuItemEnum.AvatarRefinement.CustomizeHead, v92.opaque.name)
		end
	end, {
		v91,
		v92
	})
	local v117 = nil

	if FFlagAXShowHeadAdjustmentInRightControlBar then
		local v118 = if not FFlagHeadRefinementFacialAnimationToggle then not not v103 and (v103.supportsHeadShapes or false) else v103 and v103.hasDynamicHead
		local v119 = v104 and v118
		local v120 = v103 and v103.tryOnAssetId ~= nil

		if v44 then
			v117 = v119 and v108
		elseif v43 then
			local v121 = v95 == CatalogSubcategories.Heads:rawValue()

			v117 = v119 or v120 and v121
		else
			v117 = v119 or v120
		end
	end

	return React.createElement(Foundation.View, {
		tag = "col gap-small auto-xy",
		LayoutOrder = t1.LayoutOrder
	}, {
		SkinColorButton = if not v98 or not v97 then nil else React.createElement(ContextualActionButton, {
			LayoutOrder = 1,
			Selectable = true,
			size = UDim.new(0, v90.Size.Size_1100),
			onActivated = function() -- line: 369
				-- upvalues: v91 (copy), AvatarScreen (copy)
				v91.navigate(AvatarScreen.ColorAdjustment)
			end
		}, React.createElement(ColorGradientCircle, {
			Colors = { v97 },
			Size = UDim2.fromOffset(v90.Size.Size_500, v90.Size.Size_500),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5)
		})),
		HeadAdjustmentButton = if not FFlagAXShowHeadAdjustmentInRightControlBar or not v117 then nil else React.createElement(IconOnlyMenu, {
			LayoutOrder = 3,
			items = {{
				type = "icon",
				id = MenuItemEnum.AvatarRefinement.CustomizeHead,
				icon = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/classicHead_off" or IconName.HeadBlank,
				iconSize = v90.Size.Size_600,
				onActivated = v116
			}}
		}),
		MakeupLayering = if not FFlagAXMakeupEquipping or not v111 then nil else React.createElement(Foundation.View, {
			tag = "auto-xy",
			LayoutOrder = 2
		}, {
			MakeupLayeringButton = React.createElement(IconOnlyMenu, {
				items = {{
					type = "icon",
					id = MenuItemEnum.AvatarRefinement.MakeupLayers,
					icon = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/eyelash_off" or IconName.LipsLipstickMakeupBrush,
					iconSize = v90.Size.Size_600,
					onActivated = v115
				}}
			}),
			MakeupLayeringTooltip = if not FFlagAXMakeupLayeringTooltipFTUX then nil else React.createElement(AXTooltip, {
				isOpen = v113.showTooltip,
				popoverSide = v114,
				tooltipText = v112.makeupLayeringTooltipText,
				onTooltipActivated = v113.dismissTooltip
			})
		}),
		AccessoryAdjustmentButton = if not shouldEnableAccessoryAdjustmentDuringTryOn or (v92.opaque.name ~= AvatarScreen.Catalog or not adjustableLastTryOnItemId) then nil else React.createElement(ContextualActionButton, {
			LayoutOrder = 4,
			Selectable = true,
			GroupTransparencyOverwrite = 0,
			size = UDim.new(0, v90.Size.Size_1100),
			onActivated = function() -- line: 432
				-- upvalues: accessoryAdjustmentQuickButtonFtux (ref), GetFFlagAXFixAccessoryAdjustmentAnalyticsEntryPage (copy), v93 (copy), SetEntryPage (copy), v92 (copy), v91 (copy), AvatarScreen (copy), SetSelectedAccessory (copy), adjustableLastTryOnItemId (ref)
				if accessoryAdjustmentQuickButtonFtux and accessoryAdjustmentQuickButtonFtux.shouldShowFirstTimeGlow() then
					accessoryAdjustmentQuickButtonFtux.completeFirstTimeGlow()
				end

				if GetFFlagAXFixAccessoryAdjustmentAnalyticsEntryPage() then
					v93(SetEntryPage(v92.opaque.name))
				end

				v91.navigate(AvatarScreen.AdjustAccessoryView, {
					fromRoute = v92.opaque.name
				})
				v93(SetSelectedAccessory(adjustableLastTryOnItemId))
			end,
			enableFocusAnimation = accessoryAdjustmentQuickButtonFtux and accessoryAdjustmentQuickButtonFtux.shouldShowFirstTimeGlow()
		}, {
			Icon = React.createElement(Foundation.View, {
				Visible = true,
				tag = "radius-circle position-center-center anchor-center-center clip",
				Size = UDim2.fromScale(1, 1)
			}, {
				IconImage = React.createElement(Foundation.Image, {
					Image = "icons/menu/transform",
					tag = "position-center-center anchor-center-center radius-circle content-emphasis",
					Size = UDim2.fromOffset(v90.Size.Size_800, v90.Size.Size_800),
					imageStyle = {
						Color3 = v90.Color.Content.Emphasis.Color3,
						Transparency = v90.Color.Content.Emphasis.Transparency
					}
				})
			})
		})
	})
end

return React.memo(React.forwardRef(ContextualActions))
