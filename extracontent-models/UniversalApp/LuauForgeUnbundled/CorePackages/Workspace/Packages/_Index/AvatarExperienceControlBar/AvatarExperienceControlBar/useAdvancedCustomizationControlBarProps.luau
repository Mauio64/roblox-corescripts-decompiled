local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/Foundation")
local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/Navigation")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/AvatarExperienceNavigation")
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/RoactUtils").Hooks.RoactRodux.useSelector
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/AvatarExperienceCommon")
local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/AvatarExperienceAnalytics")

local selectColorAdjustmentButtonColor = AvatarExperienceCommon.State.Selectors.selectColorAdjustmentButtonColor
local selectHasDynamicHead = AvatarExperienceCommon.State.Selectors.selectHasDynamicHead
local slotBasedEditorAnalytics = AvatarExperienceAnalytics.Surfaces.SlotBasedEditorAnalytics

local useTokens = Foundation.Hooks.useTokens
local useNavigation = Navigation.useNavigation
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute

local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen

local MenuItemEnum = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/AvatarExperienceControlBar/Enums/MenuItemEnum")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/AvatarExperienceControlBar/ControlBarTypes")

local iconName = Foundation.Enums.IconName
local iconVariant = Foundation.Enums.IconVariant

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/AvatarExperienceFlags")
local fFlagAXMigrateBuilderIcons = AvatarExperienceFlags.FFlagAXMigrateBuilderIcons
local fFlagAXHideHeadAdjustmentForDefaultHead = AvatarExperienceFlags.FFlagAXHideHeadAdjustmentForDefaultHead

local function useAdvancedCustomizationControlBarProps(p2)
	local v5 = useTokens()
	local v6 = useNavigation()
	local v7 = useAvatarRoute()

	local v8 = useSelector(selectColorAdjustmentButtonColor)

	local size_600 = v5.Size.Size_600

	local name = p2.avatarRoute and p2.avatarRoute.opaque and p2.avatarRoute.opaque.name

	local v9 = React.useCallback(function()
		v6.navigate(avatarScreen.AccessoryAdjustment)

		if v7 and v7.opaque then
			slotBasedEditorAnalytics.trackAdvancedCustomizationControlBarClickFromSurface(
				MenuItemEnum.AvatarRefinement.AdjustAccessory,
				v7.opaque.name
			)
		end
	end, { v6, v7 })

	local v10 = React.useCallback(function()
		v6.navigate(avatarScreen.BodyShape)

		if v7 and v7.opaque then
			slotBasedEditorAnalytics.trackAdvancedCustomizationControlBarClickFromSurface(
				MenuItemEnum.AvatarRefinement.BodyScale,
				v7.opaque.name
			)
		end
	end, { v6, v7 })

	local v11 = React.useCallback(function()
		v6.navigate(avatarScreen.HeadRefinement)

		if v7 and v7.opaque then
			slotBasedEditorAnalytics.trackAdvancedCustomizationControlBarClickFromSurface(
				MenuItemEnum.AvatarRefinement.CustomizeHead,
				v7.opaque.name
			)
		end
	end, { v6, v7 })

	local v12 = React.useCallback(function()
		if v7 and v7.current and v7.current.name == avatarScreen.LayeredMakeupSort then
			v6.pop()
		end

		v6.navigate(avatarScreen.LayeredClothingSort)

		if v7 and v7.opaque then
			slotBasedEditorAnalytics.trackAdvancedCustomizationControlBarClickFromSurface(
				MenuItemEnum.AvatarRefinement.ClothingLayers,
				v7.opaque.name
			)
		end
	end, { v6, v7 })

	local v13 = React.useCallback(function()
		if v7 and v7.current and v7.current.name == avatarScreen.LayeredClothingSort then
			v6.pop()
		end

		v6.navigate(avatarScreen.LayeredMakeupSort)

		if v7 and v7.opaque then
			slotBasedEditorAnalytics.trackAdvancedCustomizationControlBarClickFromSurface(
				MenuItemEnum.AvatarRefinement.MakeupLayers,
				v7.opaque.name
			)
		end
	end, { v6, v7 })

	local v14 = React.useCallback(function()
		v6.navigate(avatarScreen.ColorAdjustment)

		if v7 and v7.opaque then
			slotBasedEditorAnalytics.trackAdvancedCustomizationControlBarClickFromSurface(
				MenuItemEnum.AvatarRefinement.ColorAdjustment,
				v7.opaque.name
			)
		end
	end, { v6, v7 })

	local v15 = if fFlagAXHideHeadAdjustmentForDefaultHead then useSelector(selectHasDynamicHead) else nil

	local function fn()
		local v17 = {
			type = "icon",
			id = MenuItemEnum.AvatarRefinement.AdjustAccessory,
			icon = not fFlagAXMigrateBuilderIcons and "icons/menu/clothing/hats_off" or iconName.HatFedora,
			activeIcon = not fFlagAXMigrateBuilderIcons and "icons/menu/clothing/hats_on" or iconName.HatFedora,
			activeIconVariant = 0,
			onActivated = 0,
			isActive = 0,
			iconSize = 0
		}

		local v18 = if fFlagAXMigrateBuilderIcons then iconVariant.Filled else nil
		v17.activeIconVariant = v18
		v17.onActivated = v9
		v17.isActive = name == avatarScreen.AccessoryAdjustment
		v17.iconSize = size_600

		local v19 = {
			type = "icon",
			id = MenuItemEnum.AvatarRefinement.BodyScale,
			icon = not fFlagAXMigrateBuilderIcons and "icons/menu/clothing/build_off" or iconName.PersonStandingDualArrowsVertical,
			activeIcon = not fFlagAXMigrateBuilderIcons and "icons/menu/clothing/build_on" or iconName.PersonStandingDualArrowsVertical,
			activeIconVariant = 0,
			onActivated = 0,
			isActive = 0,
			iconSize = 0
		}

		local v20 = if fFlagAXMigrateBuilderIcons then iconVariant.Filled else nil
		v19.activeIconVariant = v20
		v19.onActivated = v10
		v19.isActive = name == avatarScreen.BodyShape
		v19.iconSize = size_600

		local v21 = {
			type = "icon",
			id = MenuItemEnum.AvatarRefinement.CustomizeHead,
			icon = not fFlagAXMigrateBuilderIcons and "icons/menu/clothing/classicHead_off" or iconName.HeadBlank,
			activeIcon = not fFlagAXMigrateBuilderIcons and "icons/menu/clothing/classicHead_on" or iconName.HeadBlank,
			activeIconVariant = 0,
			onActivated = 0,
			isActive = 0,
			iconSize = 0,
			visible = 0
		}

		local v22 = if fFlagAXMigrateBuilderIcons then iconVariant.Filled else nil
		v21.activeIconVariant = v22
		v21.onActivated = v11
		v21.isActive = name == avatarScreen.HeadRefinement
		v21.iconSize = size_600
		v21.visible = if fFlagAXHideHeadAdjustmentForDefaultHead then v15 else nil

		local v24 = {
			type = "icon",
			id = MenuItemEnum.AvatarRefinement.ClothingLayers,
			icon = not fFlagAXMigrateBuilderIcons and "icons/menu/clothing/clothing_off" or iconName.ClothesHanger,
			activeIcon = not fFlagAXMigrateBuilderIcons and "icons/menu/clothing/clothing_on" or iconName.ClothesHanger,
			activeIconVariant = 0,
			onActivated = 0,
			isActive = 0,
			iconSize = 0
		}

		local v25 = if fFlagAXMigrateBuilderIcons then iconVariant.Filled else nil
		v24.activeIconVariant = v25
		v24.onActivated = v12
		v24.isActive = name == avatarScreen.LayeredClothingSort
		v24.iconSize = size_600

		local v26 = {
			type = "icon",
			id = MenuItemEnum.AvatarRefinement.MakeupLayers,
			icon = not fFlagAXMigrateBuilderIcons and "icons/menu/clothing/eyelash_on" or iconName.LipsLipstickMakeupBrush,
			activeIcon = not fFlagAXMigrateBuilderIcons and "icons/menu/clothing/eyelash_off" or iconName.LipsLipstickMakeupBrush,
			activeIconVariant = 0,
			onActivated = 0,
			isActive = 0,
			iconSize = 0
		}

		local v27 = if fFlagAXMigrateBuilderIcons then iconVariant.Filled else nil
		v26.activeIconVariant = v27
		v26.onActivated = v13
		v26.isActive = name == avatarScreen.LayeredMakeupSort
		v26.iconSize = size_600
		return {
			v17,
			v19,
			v21,
			v24,
			v26,
			v8 and {
				type = "color",
				id = MenuItemEnum.AvatarRefinement.ColorAdjustment,
				colorSize = size_600,
				colors = { v8 },
				onActivated = v14,
				isActive = name == avatarScreen.ColorAdjustment,
				Selectable = true
			} or nil
		}
	end

	return {
		config = React.useMemo(fn, {
			name,
			v9,
			v10,
			v11,
			v12,
			v13,
			v14,
			v8,
			if fFlagAXHideHeadAdjustmentForDefaultHead then v15 else nil
		})
	}
end

return useAdvancedCustomizationControlBarProps
