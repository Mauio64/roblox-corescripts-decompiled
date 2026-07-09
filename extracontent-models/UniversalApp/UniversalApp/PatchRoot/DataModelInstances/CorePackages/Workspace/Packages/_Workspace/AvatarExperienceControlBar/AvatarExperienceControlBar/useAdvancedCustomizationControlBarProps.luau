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
local FFlagAXCustomizeMakeupSupport = AvatarExperienceFlags.FFlagAXCustomizeMakeupSupport
local FFlagAXHideHeadAdjustmentForDefaultHead = AvatarExperienceFlags.FFlagAXHideHeadAdjustmentForDefaultHead

local function useAdvancedCustomizationControlBarProps(p1) -- line: 42
	-- upvalues: useTokens (copy), useNavigation (copy), useAvatarRoute (copy), useSelector (copy), selectColorAdjustmentButtonColor (copy), React (copy), AvatarScreen (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy), FFlagAXCustomizeMakeupSupport (copy), FFlagAXHideHeadAdjustmentForDefaultHead (copy), selectHasDynamicHead (copy), AXEnableAccessoryAdjustmentDuringTryOnIXP (copy), IXPUtils (copy), FFlagAXMigrateBuilderIcons (copy), IconName (copy), IconVariant (copy)
	local v28 = useTokens()
	local v29 = useNavigation()
	local v30 = useAvatarRoute()
	local v31 = useSelector(selectColorAdjustmentButtonColor)
	local Size_600 = v28.Size.Size_600
	local v33 = p1.avatarRoute and (p1.avatarRoute.opaque and p1.avatarRoute.opaque.name)
	local v34 = React.useCallback(function() -- line: 53
		-- upvalues: v29 (copy), AvatarScreen (copy), v30 (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
		v29.navigate(AvatarScreen.AccessoryAdjustment)

		if v30 and v30.opaque then
			SlotBasedEditorAnalytics.trackAdvancedCustomizationControlBarClickFromSurface(MenuItemEnum.AvatarRefinement.AdjustAccessory, v30.opaque.name)
		end
	end, {
		v29,
		v30
	})
	local v35 = React.useCallback(function() -- line: 63
		-- upvalues: v29 (copy), AvatarScreen (copy), v30 (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
		v29.navigate(AvatarScreen.BodyShape)

		if v30 and v30.opaque then
			SlotBasedEditorAnalytics.trackAdvancedCustomizationControlBarClickFromSurface(MenuItemEnum.AvatarRefinement.BodyScale, v30.opaque.name)
		end
	end, {
		v29,
		v30
	})
	local v36 = React.useCallback(function() -- line: 73
		-- upvalues: v29 (copy), AvatarScreen (copy), v30 (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
		v29.navigate(AvatarScreen.HeadRefinement)

		if v30 and v30.opaque then
			SlotBasedEditorAnalytics.trackAdvancedCustomizationControlBarClickFromSurface(MenuItemEnum.AvatarRefinement.CustomizeHead, v30.opaque.name)
		end
	end, {
		v29,
		v30
	})
	local v37 = React.useCallback(function() -- line: 83
		-- upvalues: FFlagAXCustomizeMakeupSupport (copy), v30 (copy), AvatarScreen (copy), v29 (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
		if FFlagAXCustomizeMakeupSupport and (v30 and v30.current and v30.current.name == AvatarScreen.LayeredMakeupSort) then
			v29.pop()
		end

		v29.navigate(AvatarScreen.LayeredClothingSort)

		if v30 and v30.opaque then
			SlotBasedEditorAnalytics.trackAdvancedCustomizationControlBarClickFromSurface(MenuItemEnum.AvatarRefinement.ClothingLayers, v30.opaque.name)
		end
	end, {
		v29,
		v30
	})
	local v38 = if not FFlagAXCustomizeMakeupSupport then nil else React.useCallback(function() -- line: 104
		-- upvalues: v30 (copy), AvatarScreen (copy), v29 (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
		if v30 and (v30.current and v30.current.name == AvatarScreen.LayeredClothingSort) then
			v29.pop()
		end

		v29.navigate(AvatarScreen.LayeredMakeupSort)

		if v30 and v30.opaque then
			SlotBasedEditorAnalytics.trackAdvancedCustomizationControlBarClickFromSurface(MenuItemEnum.AvatarRefinement.MakeupLayers, v30.opaque.name)
		end
	end, {
		v29,
		v30
	})
	local v39 = React.useCallback(function() -- line: 120
		-- upvalues: v29 (copy), AvatarScreen (copy), v30 (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
		v29.navigate(AvatarScreen.ColorAdjustment)

		if v30 and v30.opaque then
			SlotBasedEditorAnalytics.trackAdvancedCustomizationControlBarClickFromSurface(MenuItemEnum.AvatarRefinement.ColorAdjustment, v30.opaque.name)
		end
	end, {
		v29,
		v30
	})
	local v40 = if not FFlagAXHideHeadAdjustmentForDefaultHead then nil else useSelector(selectHasDynamicHead)
	local v41 = if not AXEnableAccessoryAdjustmentDuringTryOnIXP.isEnabled() then nil else IXPUtils.readTestVariable(AXEnableAccessoryAdjustmentDuringTryOnIXP.EnabledForUser)

	return {
		config = React.useMemo(function() -- line: 137
			-- upvalues: MenuItemEnum (copy), v41 (copy), FFlagAXMigrateBuilderIcons (copy), IconName (copy), IconVariant (copy), v34 (copy), v33 (copy), AvatarScreen (copy), Size_600 (copy), v35 (copy), v36 (copy), FFlagAXHideHeadAdjustmentForDefaultHead (copy), v40 (copy), v37 (copy), FFlagAXCustomizeMakeupSupport (copy), v38 (copy), v31 (copy), v39 (copy)
			return {
				{
					type = "icon",
					id = MenuItemEnum.AvatarRefinement.AdjustAccessory,
					icon = if not v41 then not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/hats_off" or IconName.HatFedora else "icons/menu/transform-small",
					activeIcon = if not v41 then not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/hats_on" or IconName.HatFedora else "icons/menu/transform-small",
					activeIconVariant = if not FFlagAXMigrateBuilderIcons then nil else IconVariant.Filled,
					onActivated = v34,
					isActive = v33 == AvatarScreen.AccessoryAdjustment,
					iconSize = Size_600
				},
				{
					type = "icon",
					id = MenuItemEnum.AvatarRefinement.BodyScale,
					icon = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/build_off" or IconName.PersonStandingDualArrowsVertical,
					activeIcon = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/build_on" or IconName.PersonStandingDualArrowsVertical,
					activeIconVariant = if not FFlagAXMigrateBuilderIcons then nil else IconVariant.Filled,
					onActivated = v35,
					isActive = v33 == AvatarScreen.BodyShape,
					iconSize = Size_600
				},
				{
					type = "icon",
					id = MenuItemEnum.AvatarRefinement.CustomizeHead,
					icon = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/classicHead_off" or IconName.HeadBlank,
					activeIcon = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/classicHead_on" or IconName.HeadBlank,
					activeIconVariant = if not FFlagAXMigrateBuilderIcons then nil else IconVariant.Filled,
					onActivated = v36,
					isActive = v33 == AvatarScreen.HeadRefinement,
					iconSize = Size_600,
					visible = if not FFlagAXHideHeadAdjustmentForDefaultHead then nil else v40
				},
				{
					type = "icon",
					id = MenuItemEnum.AvatarRefinement.ClothingLayers,
					icon = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/clothing_off" or IconName.ClothesHanger,
					activeIcon = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/clothing_on" or IconName.ClothesHanger,
					activeIconVariant = if not FFlagAXMigrateBuilderIcons then nil else IconVariant.Filled,
					onActivated = v37,
					isActive = v33 == AvatarScreen.LayeredClothingSort,
					iconSize = Size_600
				},
				if not FFlagAXCustomizeMakeupSupport then nil else {
					type = "icon",
					id = MenuItemEnum.AvatarRefinement.MakeupLayers,
					icon = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/eyelash_on" or IconName.LipsLipstickMakeupBrush,
					activeIcon = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/eyelash_off" or IconName.LipsLipstickMakeupBrush,
					activeIconVariant = if not FFlagAXMigrateBuilderIcons then nil else IconVariant.Filled,
					onActivated = v38,
					isActive = v33 == AvatarScreen.LayeredMakeupSort,
					iconSize = Size_600
				},
				if not v31 then nil else {
					type = "color",
					Selectable = true,
					id = MenuItemEnum.AvatarRefinement.ColorAdjustment,
					colorSize = Size_600,
					colors = { v31 },
					onActivated = v39,
					isActive = v33 == AvatarScreen.ColorAdjustment
				}
			}
		end, {
			v33,
			v34,
			v35,
			v36,
			v37,
			if not FFlagAXCustomizeMakeupSupport then nil else v38,
			v39,
			v31,
			if not FFlagAXHideHeadAdjustmentForDefaultHead then nil else v40
		})
	}
end

return useAdvancedCustomizationControlBarProps
