local AvatarExperienceControlBar = script:FindFirstAncestor("AvatarExperienceControlBar")

local parent = AvatarExperienceControlBar.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Navigation = require(parent.Navigation)
local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)

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

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXMigrateBuilderIcons = AvatarExperienceFlags.FFlagAXMigrateBuilderIcons
local FFlagAXHideHeadAdjustmentForDefaultHead = AvatarExperienceFlags.FFlagAXHideHeadAdjustmentForDefaultHead

local function useAdvancedCustomizationControlBarProps(p)
	local v = useTokens()
	local v2 = useNavigation()
	local v3 = useAvatarRoute()

	local v4 = useSelector(selectColorAdjustmentButtonColor)

	local size_600 = v.Size.Size_600

	local name = p.avatarRoute and p.avatarRoute.opaque and p.avatarRoute.opaque.name

	local onActivated = React.useCallback(function()
		v2.navigate(AvatarScreen.AccessoryAdjustment)

		if v3 and v3.opaque then
			SlotBasedEditorAnalytics.trackAdvancedCustomizationControlBarClickFromSurface(
				MenuItemEnum.AvatarRefinement.AdjustAccessory,
				v3.opaque.name
			)
		end
	end, { v2, v3 })

	local onActivated2 = React.useCallback(function()
		v2.navigate(AvatarScreen.BodyShape)

		if v3 and v3.opaque then
			SlotBasedEditorAnalytics.trackAdvancedCustomizationControlBarClickFromSurface(
				MenuItemEnum.AvatarRefinement.BodyScale,
				v3.opaque.name
			)
		end
	end, { v2, v3 })

	local onActivated3 = React.useCallback(function()
		v2.navigate(AvatarScreen.HeadRefinement)

		if v3 and v3.opaque then
			SlotBasedEditorAnalytics.trackAdvancedCustomizationControlBarClickFromSurface(
				MenuItemEnum.AvatarRefinement.CustomizeHead,
				v3.opaque.name
			)
		end
	end, { v2, v3 })

	local onActivated4 = React.useCallback(function()
		if v3 and v3.current and v3.current.name == AvatarScreen.LayeredMakeupSort then
			v2.pop()
		end

		v2.navigate(AvatarScreen.LayeredClothingSort)

		if v3 and v3.opaque then
			SlotBasedEditorAnalytics.trackAdvancedCustomizationControlBarClickFromSurface(
				MenuItemEnum.AvatarRefinement.ClothingLayers,
				v3.opaque.name
			)
		end
	end, { v2, v3 })

	local onActivated5 = React.useCallback(function()
		if v3 and v3.current and v3.current.name == AvatarScreen.LayeredClothingSort then
			v2.pop()
		end

		v2.navigate(AvatarScreen.LayeredMakeupSort)

		if v3 and v3.opaque then
			SlotBasedEditorAnalytics.trackAdvancedCustomizationControlBarClickFromSurface(
				MenuItemEnum.AvatarRefinement.MakeupLayers,
				v3.opaque.name
			)
		end
	end, { v2, v3 })

	local onActivated6 = React.useCallback(function()
		v2.navigate(AvatarScreen.ColorAdjustment)

		if v3 and v3.opaque then
			SlotBasedEditorAnalytics.trackAdvancedCustomizationControlBarClickFromSurface(
				MenuItemEnum.AvatarRefinement.ColorAdjustment,
				v3.opaque.name
			)
		end
	end, { v2, v3 })
	local v5

	if FFlagAXHideHeadAdjustmentForDefaultHead then
		v5 = useSelector(selectHasDynamicHead)
	else
		v5 = nil
	end

	local useMemo = React.useMemo
	local function fn()
		local v6 = {
			type = "icon",
			id = MenuItemEnum.AvatarRefinement.AdjustAccessory,
			icon = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/hats_off" or IconName.HatFedora,
			activeIcon = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/hats_on" or IconName.HatFedora,
			activeIconVariant = 0,
			onActivated = 0,
			isActive = 0,
			iconSize = 0
		}
		local activeIconVariant

		if FFlagAXMigrateBuilderIcons then
			activeIconVariant = IconVariant.Filled
		end

		v6.activeIconVariant = activeIconVariant
		v6.onActivated = onActivated
		v6.isActive = name == AvatarScreen.AccessoryAdjustment
		v6.iconSize = size_600

		local v7 = {
			type = "icon",
			id = MenuItemEnum.AvatarRefinement.BodyScale,
			icon = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/build_off" or IconName.PersonStandingDualArrowsVertical,
			activeIcon = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/build_on" or IconName.PersonStandingDualArrowsVertical,
			activeIconVariant = 0,
			onActivated = 0,
			isActive = 0,
			iconSize = 0
		}
		local activeIconVariant2

		if FFlagAXMigrateBuilderIcons then
			activeIconVariant2 = IconVariant.Filled
		end

		v7.activeIconVariant = activeIconVariant2
		v7.onActivated = onActivated2
		v7.isActive = name == AvatarScreen.BodyShape
		v7.iconSize = size_600

		local v8 = {
			type = "icon",
			id = MenuItemEnum.AvatarRefinement.CustomizeHead,
			icon = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/classicHead_off" or IconName.HeadBlank,
			activeIcon = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/classicHead_on" or IconName.HeadBlank,
			activeIconVariant = 0,
			onActivated = 0,
			isActive = 0,
			iconSize = 0,
			visible = 0
		}
		local activeIconVariant3

		if FFlagAXMigrateBuilderIcons then
			activeIconVariant3 = IconVariant.Filled
		end

		v8.activeIconVariant = activeIconVariant3
		v8.onActivated = onActivated3
		v8.isActive = name == AvatarScreen.HeadRefinement
		v8.iconSize = size_600
		local visible

		if FFlagAXHideHeadAdjustmentForDefaultHead then
			visible = v5
		end

		v8.visible = visible

		local v9 = {
			type = "icon",
			id = MenuItemEnum.AvatarRefinement.ClothingLayers,
			icon = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/clothing_off" or IconName.ClothesHanger,
			activeIcon = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/clothing_on" or IconName.ClothesHanger,
			activeIconVariant = 0,
			onActivated = 0,
			isActive = 0,
			iconSize = 0
		}
		local activeIconVariant4

		if FFlagAXMigrateBuilderIcons then
			activeIconVariant4 = IconVariant.Filled
		end

		v9.activeIconVariant = activeIconVariant4
		v9.onActivated = onActivated4
		v9.isActive = name == AvatarScreen.LayeredClothingSort
		v9.iconSize = size_600

		local v10 = {
			type = "icon",
			id = MenuItemEnum.AvatarRefinement.MakeupLayers,
			icon = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/eyelash_on" or IconName.LipsLipstickMakeupBrush,
			activeIcon = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/eyelash_off" or IconName.LipsLipstickMakeupBrush,
			activeIconVariant = 0,
			onActivated = 0,
			isActive = 0,
			iconSize = 0
		}
		local activeIconVariant5

		if FFlagAXMigrateBuilderIcons then
			activeIconVariant5 = IconVariant.Filled
		end

		v10.activeIconVariant = activeIconVariant5
		v10.onActivated = onActivated5
		v10.isActive = name == AvatarScreen.LayeredMakeupSort
		v10.iconSize = size_600
		return {
			v6,
			v7,
			v8,
			v9,
			v10,
			v4 and {
				type = "color",
				id = MenuItemEnum.AvatarRefinement.ColorAdjustment,
				colorSize = size_600,
				colors = { v4 },
				onActivated = onActivated6,
				isActive = name == AvatarScreen.ColorAdjustment,
				Selectable = true
			} or nil
		}
	end

	local v6

	if FFlagAXHideHeadAdjustmentForDefaultHead then
		v6 = v5
	end

	return {
		config = useMemo(fn, {
			name,
			onActivated,
			onActivated2,
			onActivated3,
			onActivated4,
			onActivated5,
			onActivated6,
			v4,
			v6
		})
	}
end

return useAdvancedCustomizationControlBarProps
