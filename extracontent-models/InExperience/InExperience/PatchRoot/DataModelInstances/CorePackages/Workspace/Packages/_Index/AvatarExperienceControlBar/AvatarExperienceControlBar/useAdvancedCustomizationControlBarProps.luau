local AvatarExperienceControlBar = script:FindFirstAncestor("AvatarExperienceControlBar")
local AvatarExperienceControlBarParent = AvatarExperienceControlBar.Parent
local React = require(AvatarExperienceControlBarParent.React)
local Foundation = require(AvatarExperienceControlBarParent.Foundation)
local Navigation = require(AvatarExperienceControlBarParent.Navigation)
local AvatarExperienceNavigation = require(AvatarExperienceControlBarParent.AvatarExperienceNavigation)
local useSelector = require(AvatarExperienceControlBarParent.RoactUtils).Hooks.RoactRodux.useSelector
local AvatarExperienceCommon = require(AvatarExperienceControlBarParent.AvatarExperienceCommon)
local AvatarExperienceAnalytics = require(AvatarExperienceControlBarParent.AvatarExperienceAnalytics)
local IXPUtils = require(AvatarExperienceControlBarParent.IXPUtils)
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
local AXEnableAccessoryAdjustmentDuringTryOnIXP = require(AvatarExperienceControlBarParent.AvatarExperienceExperiments).AXEnableAccessoryAdjustmentDuringTryOnIXP
local AvatarExperienceFlags = require(AvatarExperienceControlBarParent.AvatarExperienceFlags)
local FFlagAXMigrateBuilderIcons = AvatarExperienceFlags.FFlagAXMigrateBuilderIcons
local FFlagAXHideHeadAdjustmentForDefaultHead = AvatarExperienceFlags.FFlagAXHideHeadAdjustmentForDefaultHead

local function useAdvancedCustomizationControlBarProps(p1) -- line: 41
	-- upvalues: useTokens (copy), useNavigation (copy), useAvatarRoute (copy), useSelector (copy), selectColorAdjustmentButtonColor (copy), React (copy), AvatarScreen (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy), FFlagAXHideHeadAdjustmentForDefaultHead (copy), selectHasDynamicHead (copy), AXEnableAccessoryAdjustmentDuringTryOnIXP (copy), IXPUtils (copy), FFlagAXMigrateBuilderIcons (copy), IconName (copy), IconVariant (copy)
	local v27 = useTokens()
	local v28 = useNavigation()
	local v29 = useAvatarRoute()
	local v30 = useSelector(selectColorAdjustmentButtonColor)
	local Size_600 = v27.Size.Size_600
	local v32 = p1.avatarRoute and (p1.avatarRoute.opaque and p1.avatarRoute.opaque.name)
	local v33 = React.useCallback(function() -- line: 52
		-- upvalues: v28 (copy), AvatarScreen (copy), v29 (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
		v28.navigate(AvatarScreen.AccessoryAdjustment)

		if v29 and v29.opaque then
			SlotBasedEditorAnalytics.trackAdvancedCustomizationControlBarClickFromSurface(MenuItemEnum.AvatarRefinement.AdjustAccessory, v29.opaque.name)
		end
	end, {
		v28,
		v29
	})
	local v34 = React.useCallback(function() -- line: 62
		-- upvalues: v28 (copy), AvatarScreen (copy), v29 (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
		v28.navigate(AvatarScreen.BodyShape)

		if v29 and v29.opaque then
			SlotBasedEditorAnalytics.trackAdvancedCustomizationControlBarClickFromSurface(MenuItemEnum.AvatarRefinement.BodyScale, v29.opaque.name)
		end
	end, {
		v28,
		v29
	})
	local v35 = React.useCallback(function() -- line: 72
		-- upvalues: v28 (copy), AvatarScreen (copy), v29 (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
		v28.navigate(AvatarScreen.HeadRefinement)

		if v29 and v29.opaque then
			SlotBasedEditorAnalytics.trackAdvancedCustomizationControlBarClickFromSurface(MenuItemEnum.AvatarRefinement.CustomizeHead, v29.opaque.name)
		end
	end, {
		v28,
		v29
	})
	local v36 = React.useCallback(function() -- line: 82
		-- upvalues: v29 (copy), AvatarScreen (copy), v28 (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
		if v29 and (v29.current and v29.current.name == AvatarScreen.LayeredMakeupSort) then
			v28.pop()
		end

		v28.navigate(AvatarScreen.LayeredClothingSort)

		if v29 and v29.opaque then
			SlotBasedEditorAnalytics.trackAdvancedCustomizationControlBarClickFromSurface(MenuItemEnum.AvatarRefinement.ClothingLayers, v29.opaque.name)
		end
	end, {
		v28,
		v29
	})
	local v37 = React.useCallback(function() -- line: 97
		-- upvalues: v29 (copy), AvatarScreen (copy), v28 (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
		if v29 and (v29.current and v29.current.name == AvatarScreen.LayeredClothingSort) then
			v28.pop()
		end

		v28.navigate(AvatarScreen.LayeredMakeupSort)

		if v29 and v29.opaque then
			SlotBasedEditorAnalytics.trackAdvancedCustomizationControlBarClickFromSurface(MenuItemEnum.AvatarRefinement.MakeupLayers, v29.opaque.name)
		end
	end, {
		v28,
		v29
	})
	local v38 = React.useCallback(function() -- line: 112
		-- upvalues: v28 (copy), AvatarScreen (copy), v29 (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
		v28.navigate(AvatarScreen.ColorAdjustment)

		if v29 and v29.opaque then
			SlotBasedEditorAnalytics.trackAdvancedCustomizationControlBarClickFromSurface(MenuItemEnum.AvatarRefinement.ColorAdjustment, v29.opaque.name)
		end
	end, {
		v28,
		v29
	})
	local v39 = if not FFlagAXHideHeadAdjustmentForDefaultHead then nil else useSelector(selectHasDynamicHead)
	local v40 = if not AXEnableAccessoryAdjustmentDuringTryOnIXP.isEnabled() then nil else IXPUtils.readTestVariable(AXEnableAccessoryAdjustmentDuringTryOnIXP.EnabledForUser)

	return {
		config = React.useMemo(function() -- line: 129
			-- upvalues: MenuItemEnum (copy), v40 (copy), FFlagAXMigrateBuilderIcons (copy), IconName (copy), IconVariant (copy), v33 (copy), v32 (copy), AvatarScreen (copy), Size_600 (copy), v34 (copy), v35 (copy), FFlagAXHideHeadAdjustmentForDefaultHead (copy), v39 (copy), v36 (copy), v37 (copy), v30 (copy), v38 (copy)
			return {
				{
					type = "icon",
					id = MenuItemEnum.AvatarRefinement.AdjustAccessory,
					icon = if not v40 then not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/hats_off" or IconName.HatFedora else "icons/menu/transform-small",
					activeIcon = if not v40 then not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/hats_on" or IconName.HatFedora else "icons/menu/transform-small",
					activeIconVariant = if not FFlagAXMigrateBuilderIcons then nil else IconVariant.Filled,
					onActivated = v33,
					isActive = v32 == AvatarScreen.AccessoryAdjustment,
					iconSize = Size_600
				},
				{
					type = "icon",
					id = MenuItemEnum.AvatarRefinement.BodyScale,
					icon = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/build_off" or IconName.PersonStandingDualArrowsVertical,
					activeIcon = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/build_on" or IconName.PersonStandingDualArrowsVertical,
					activeIconVariant = if not FFlagAXMigrateBuilderIcons then nil else IconVariant.Filled,
					onActivated = v34,
					isActive = v32 == AvatarScreen.BodyShape,
					iconSize = Size_600
				},
				{
					type = "icon",
					id = MenuItemEnum.AvatarRefinement.CustomizeHead,
					icon = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/classicHead_off" or IconName.HeadBlank,
					activeIcon = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/classicHead_on" or IconName.HeadBlank,
					activeIconVariant = if not FFlagAXMigrateBuilderIcons then nil else IconVariant.Filled,
					onActivated = v35,
					isActive = v32 == AvatarScreen.HeadRefinement,
					iconSize = Size_600,
					visible = if not FFlagAXHideHeadAdjustmentForDefaultHead then nil else v39
				},
				{
					type = "icon",
					id = MenuItemEnum.AvatarRefinement.ClothingLayers,
					icon = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/clothing_off" or IconName.ClothesHanger,
					activeIcon = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/clothing_on" or IconName.ClothesHanger,
					activeIconVariant = if not FFlagAXMigrateBuilderIcons then nil else IconVariant.Filled,
					onActivated = v36,
					isActive = v32 == AvatarScreen.LayeredClothingSort,
					iconSize = Size_600
				},
				{
					type = "icon",
					id = MenuItemEnum.AvatarRefinement.MakeupLayers,
					icon = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/eyelash_on" or IconName.LipsLipstickMakeupBrush,
					activeIcon = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/eyelash_off" or IconName.LipsLipstickMakeupBrush,
					activeIconVariant = if not FFlagAXMigrateBuilderIcons then nil else IconVariant.Filled,
					onActivated = v37,
					isActive = v32 == AvatarScreen.LayeredMakeupSort,
					iconSize = Size_600
				},
				if not v30 then nil else {
					type = "color",
					Selectable = true,
					id = MenuItemEnum.AvatarRefinement.ColorAdjustment,
					colorSize = Size_600,
					colors = { v30 },
					onActivated = v38,
					isActive = v32 == AvatarScreen.ColorAdjustment
				}
			}
		end, {
			v32,
			v33,
			v34,
			v35,
			v36,
			v37,
			v38,
			v30,
			if not FFlagAXHideHeadAdjustmentForDefaultHead then nil else v39
		})
	}
end

return useAdvancedCustomizationControlBarProps
