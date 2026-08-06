local AvatarExperienceControlBar = script:FindFirstAncestor("AvatarExperienceControlBar")
local AvatarExperienceControlBarParent = AvatarExperienceControlBar.Parent
local React = require(AvatarExperienceControlBarParent.React)
local Foundation = require(AvatarExperienceControlBarParent.Foundation)
local Navigation = require(AvatarExperienceControlBarParent.Navigation)
local AvatarExperienceNavigation = require(AvatarExperienceControlBarParent.AvatarExperienceNavigation)
local useSelector = require(AvatarExperienceControlBarParent.RoactUtils).Hooks.RoactRodux.useSelector
local AvatarExperienceCommon = require(AvatarExperienceControlBarParent.AvatarExperienceCommon)
local AvatarExperienceAnalytics = require(AvatarExperienceControlBarParent.AvatarExperienceAnalytics)
local selectColorAdjustmentButtonColor = AvatarExperienceCommon.State.Selectors.selectColorAdjustmentButtonColor
local selectHasDynamicHead = AvatarExperienceCommon.State.Selectors.selectHasDynamicHead
local SlotBasedEditorAnalytics = AvatarExperienceAnalytics.Surfaces.SlotBasedEditorAnalytics
local useTokens = Foundation.Hooks.useTokens
local useNavigation = Navigation.useNavigation
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local MenuItemEnum = require(AvatarExperienceControlBar.Enums.MenuItemEnum)

require(AvatarExperienceControlBar.ControlBarTypes)

local IconName = Foundation.Enums.IconName
local IconVariant = Foundation.Enums.IconVariant
local AvatarExperienceFlags = require(AvatarExperienceControlBarParent.AvatarExperienceFlags)
local FFlagAXMigrateBuilderIcons = AvatarExperienceFlags.FFlagAXMigrateBuilderIcons
local FFlagAXHideHeadAdjustmentForDefaultHead = AvatarExperienceFlags.FFlagAXHideHeadAdjustmentForDefaultHead

local function useAdvancedCustomizationControlBarProps(p1) -- line: 37
	-- upvalues: useTokens (copy), useNavigation (copy), useAvatarRoute (copy), useSelector (copy), selectColorAdjustmentButtonColor (copy), React (copy), AvatarScreen (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy), FFlagAXHideHeadAdjustmentForDefaultHead (copy), selectHasDynamicHead (copy), FFlagAXMigrateBuilderIcons (copy), IconName (copy), IconVariant (copy)
	local v25 = useTokens()
	local v26 = useNavigation()
	local v27 = useAvatarRoute()
	local v28 = useSelector(selectColorAdjustmentButtonColor)
	local Size_600 = v25.Size.Size_600
	local v30 = p1.avatarRoute and (p1.avatarRoute.opaque and p1.avatarRoute.opaque.name)
	local v31 = React.useCallback(function() -- line: 48
		-- upvalues: v26 (copy), AvatarScreen (copy), v27 (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
		v26.navigate(AvatarScreen.AccessoryAdjustment)

		if v27 and v27.opaque then
			SlotBasedEditorAnalytics.trackAdvancedCustomizationControlBarClickFromSurface(MenuItemEnum.AvatarRefinement.AdjustAccessory, v27.opaque.name)
		end
	end, {
		v26,
		v27
	})
	local v32 = React.useCallback(function() -- line: 58
		-- upvalues: v26 (copy), AvatarScreen (copy), v27 (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
		v26.navigate(AvatarScreen.BodyShape)

		if v27 and v27.opaque then
			SlotBasedEditorAnalytics.trackAdvancedCustomizationControlBarClickFromSurface(MenuItemEnum.AvatarRefinement.BodyScale, v27.opaque.name)
		end
	end, {
		v26,
		v27
	})
	local v33 = React.useCallback(function() -- line: 68
		-- upvalues: v26 (copy), AvatarScreen (copy), v27 (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
		v26.navigate(AvatarScreen.HeadRefinement)

		if v27 and v27.opaque then
			SlotBasedEditorAnalytics.trackAdvancedCustomizationControlBarClickFromSurface(MenuItemEnum.AvatarRefinement.CustomizeHead, v27.opaque.name)
		end
	end, {
		v26,
		v27
	})
	local v34 = React.useCallback(function() -- line: 78
		-- upvalues: v27 (copy), AvatarScreen (copy), v26 (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
		if v27 and (v27.current and v27.current.name == AvatarScreen.LayeredMakeupSort) then
			v26.pop()
		end

		v26.navigate(AvatarScreen.LayeredClothingSort)

		if v27 and v27.opaque then
			SlotBasedEditorAnalytics.trackAdvancedCustomizationControlBarClickFromSurface(MenuItemEnum.AvatarRefinement.ClothingLayers, v27.opaque.name)
		end
	end, {
		v26,
		v27
	})
	local v35 = React.useCallback(function() -- line: 93
		-- upvalues: v27 (copy), AvatarScreen (copy), v26 (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
		if v27 and (v27.current and v27.current.name == AvatarScreen.LayeredClothingSort) then
			v26.pop()
		end

		v26.navigate(AvatarScreen.LayeredMakeupSort)

		if v27 and v27.opaque then
			SlotBasedEditorAnalytics.trackAdvancedCustomizationControlBarClickFromSurface(MenuItemEnum.AvatarRefinement.MakeupLayers, v27.opaque.name)
		end
	end, {
		v26,
		v27
	})
	local v36 = React.useCallback(function() -- line: 108
		-- upvalues: v26 (copy), AvatarScreen (copy), v27 (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
		v26.navigate(AvatarScreen.ColorAdjustment)

		if v27 and v27.opaque then
			SlotBasedEditorAnalytics.trackAdvancedCustomizationControlBarClickFromSurface(MenuItemEnum.AvatarRefinement.ColorAdjustment, v27.opaque.name)
		end
	end, {
		v26,
		v27
	})
	local v37 = if not FFlagAXHideHeadAdjustmentForDefaultHead then nil else useSelector(selectHasDynamicHead)

	return {
		config = React.useMemo(function() -- line: 121
			-- upvalues: MenuItemEnum (copy), FFlagAXMigrateBuilderIcons (copy), IconName (copy), IconVariant (copy), v31 (copy), v30 (copy), AvatarScreen (copy), Size_600 (copy), v32 (copy), v33 (copy), FFlagAXHideHeadAdjustmentForDefaultHead (copy), v37 (copy), v34 (copy), v35 (copy), v28 (copy), v36 (copy)
			return {
				{
					type = "icon",
					id = MenuItemEnum.AvatarRefinement.AdjustAccessory,
					icon = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/hats_off" or IconName.HatFedora,
					activeIcon = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/hats_on" or IconName.HatFedora,
					activeIconVariant = if not FFlagAXMigrateBuilderIcons then nil else IconVariant.Filled,
					onActivated = v31,
					isActive = v30 == AvatarScreen.AccessoryAdjustment,
					iconSize = Size_600
				},
				{
					type = "icon",
					id = MenuItemEnum.AvatarRefinement.BodyScale,
					icon = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/build_off" or IconName.PersonStandingDualArrowsVertical,
					activeIcon = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/build_on" or IconName.PersonStandingDualArrowsVertical,
					activeIconVariant = if not FFlagAXMigrateBuilderIcons then nil else IconVariant.Filled,
					onActivated = v32,
					isActive = v30 == AvatarScreen.BodyShape,
					iconSize = Size_600
				},
				{
					type = "icon",
					id = MenuItemEnum.AvatarRefinement.CustomizeHead,
					icon = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/classicHead_off" or IconName.HeadBlank,
					activeIcon = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/classicHead_on" or IconName.HeadBlank,
					activeIconVariant = if not FFlagAXMigrateBuilderIcons then nil else IconVariant.Filled,
					onActivated = v33,
					isActive = v30 == AvatarScreen.HeadRefinement,
					iconSize = Size_600,
					visible = if not FFlagAXHideHeadAdjustmentForDefaultHead then nil else v37
				},
				{
					type = "icon",
					id = MenuItemEnum.AvatarRefinement.ClothingLayers,
					icon = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/clothing_off" or IconName.ClothesHanger,
					activeIcon = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/clothing_on" or IconName.ClothesHanger,
					activeIconVariant = if not FFlagAXMigrateBuilderIcons then nil else IconVariant.Filled,
					onActivated = v34,
					isActive = v30 == AvatarScreen.LayeredClothingSort,
					iconSize = Size_600
				},
				{
					type = "icon",
					id = MenuItemEnum.AvatarRefinement.MakeupLayers,
					icon = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/eyelash_on" or IconName.LipsLipstickMakeupBrush,
					activeIcon = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/eyelash_off" or IconName.LipsLipstickMakeupBrush,
					activeIconVariant = if not FFlagAXMigrateBuilderIcons then nil else IconVariant.Filled,
					onActivated = v35,
					isActive = v30 == AvatarScreen.LayeredMakeupSort,
					iconSize = Size_600
				},
				if not v28 then nil else {
					type = "color",
					Selectable = true,
					id = MenuItemEnum.AvatarRefinement.ColorAdjustment,
					colorSize = Size_600,
					colors = { v28 },
					onActivated = v36,
					isActive = v30 == AvatarScreen.ColorAdjustment
				}
			}
		end, {
			v30,
			v31,
			v32,
			v33,
			v34,
			v35,
			v36,
			v28,
			if not FFlagAXHideHeadAdjustmentForDefaultHead then nil else v37
		})
	}
end

return useAdvancedCustomizationControlBarProps
