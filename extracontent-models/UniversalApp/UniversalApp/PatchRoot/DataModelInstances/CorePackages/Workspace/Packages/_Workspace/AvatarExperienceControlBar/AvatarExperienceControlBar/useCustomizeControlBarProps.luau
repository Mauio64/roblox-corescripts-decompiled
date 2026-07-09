local AvatarExperienceControlBar = script:FindFirstAncestor("AvatarExperienceControlBar")
local AvatarExperienceControlBarParent = AvatarExperienceControlBar.Parent
local React = require(AvatarExperienceControlBarParent.React)
local UserLib = require(AvatarExperienceControlBarParent.UserLib)
local Navigation = require(AvatarExperienceControlBarParent.Navigation)
local AvatarExperienceNavigation = require(AvatarExperienceControlBarParent.AvatarExperienceNavigation)
local Responsive = require(AvatarExperienceControlBarParent.Responsive)
local Localization = require(AvatarExperienceControlBarParent.Localization)
local AvatarExperienceCommon = require(AvatarExperienceControlBarParent.AvatarExperienceCommon)
local AvatarExperienceAnalytics = require(AvatarExperienceControlBarParent.AvatarExperienceAnalytics)
local IXPUtils = require(AvatarExperienceControlBarParent.IXPUtils)
local Foundation = require(AvatarExperienceControlBarParent.Foundation)
local selectColorAdjustmentButtonColor = AvatarExperienceCommon.State.Selectors.selectColorAdjustmentButtonColor
local selectHasDynamicHead = AvatarExperienceCommon.State.Selectors.selectHasDynamicHead
local SlotBasedEditorAnalytics = AvatarExperienceAnalytics.Surfaces.SlotBasedEditorAnalytics
local useSelector = require(AvatarExperienceControlBarParent.RoactUtils).Hooks.RoactRodux.useSelector
local useNavigation = Navigation.useNavigation
local useSemanticTokens = require(AvatarExperienceControlBar.Hooks.useSemanticTokens)
local useLocalization = Localization.Hooks.useLocalization
local useUndoRedoBarViewModel = require(script.Parent.UndoRedoBar.useUndoRedoBarViewModel)
local IconName = Foundation.Enums.IconName
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local Constants = UserLib.Utils.Constants
local MenuItemEnum = require(AvatarExperienceControlBar.Enums.MenuItemEnum)

require(AvatarExperienceControlBar.ControlBarTypes)

local AvatarExperienceFlags = require(AvatarExperienceControlBarParent.AvatarExperienceFlags)
local FFlagAXAvatarSharingEntryPoint = AvatarExperienceFlags.FFlagAXAvatarSharingEntryPoint
local FFlagAXPhotoboothFunctionality = AvatarExperienceFlags.FFlagAXPhotoboothFunctionality
local FFlagAXMigrateBuilderIcons = AvatarExperienceFlags.FFlagAXMigrateBuilderIcons
local AXEnableAccessoryAdjustmentDuringTryOnIXP = require(AvatarExperienceControlBarParent.AvatarExperienceExperiments).AXEnableAccessoryAdjustmentDuringTryOnIXP
local FFlagAXRootSlotBasedEditorFlag = require(AvatarExperienceControlBarParent.AvatarExperienceFlags).FFlagAXRootSlotBasedEditorFlag
local FFlagAXResetAvatarButton = require(AvatarExperienceControlBarParent.AvatarExperienceFlags).FFlagAXResetAvatarButton
local FFlagAXCustomizeMakeupSupport = require(AvatarExperienceControlBarParent.AvatarExperienceFlags).FFlagAXCustomizeMakeupSupport
local FFlagAXHideHeadAdjustmentForDefaultHead = require(AvatarExperienceControlBarParent.AvatarExperienceFlags).FFlagAXHideHeadAdjustmentForDefaultHead
local FFlagAXFavoritesManagerNavEntry = require(AvatarExperienceControlBarParent.AvatarExperienceFlags).FFlagAXFavoritesManagerNavEntry
local AvatarHeadShot = Constants.RbxthumbTypes.AvatarHeadShot

local function selectUserId(p1) -- line: 51
	return p1.LocalUserId
end
local function useCustomizeControlBarProps(p2) -- line: 65
	-- upvalues: useSemanticTokens (copy), useNavigation (copy), useSelector (copy), selectColorAdjustmentButtonColor (copy), Responsive (copy), selectUserId (copy), useLocalization (copy), FFlagAXCustomizeMakeupSupport (copy), FFlagAXAvatarSharingEntryPoint (copy), FFlagAXPhotoboothFunctionality (copy), React (copy), AvatarScreen (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy), FFlagAXFavoritesManagerNavEntry (copy), AXEnableAccessoryAdjustmentDuringTryOnIXP (copy), IXPUtils (copy), FFlagAXHideHeadAdjustmentForDefaultHead (copy), selectHasDynamicHead (copy), FFlagAXResetAvatarButton (copy), useUndoRedoBarViewModel (copy), getRbxthumbWithTypeSizeAndOptions (copy), AvatarHeadShot (copy), FFlagAXRootSlotBasedEditorFlag (copy), FFlagAXMigrateBuilderIcons (copy), IconName (copy)
	local v41 = useSemanticTokens()
	local v42 = useNavigation()
	local v43 = useSelector(selectColorAdjustmentButtonColor)
	local v44 = Responsive.useOrientation() == Responsive.Keys.Portrait
	local v45 = useSelector(selectUserId)
	local v46 = useLocalization({
		adjustAccessory = "Feature.Avatar.Label.Title.AccessoryAdjustment",
		bodyShape = "Feature.Avatar.Label.Title.BodyShape",
		clothingLayering = "Feature.Avatar.Label.Title.ClothingLayering",
		headAdjustment = "Feature.Avatar.Label.Title.HeadAdjustment",
		inventory = "Feature.Avatar.Label.Title.Inventory",
		emotes = "Feature.Avatar.Label.Title.Emotes",
		profilePhoto = "Feature.Avatar.Label.Title.ProfilePhoto",
		skinColor = "Feature.Avatar.ColorAdjustmentPage.Title",
		makeupLayering = if not FFlagAXCustomizeMakeupSupport then nil else "Feature.Avatar.Label.Title.MakeupLayering",
		shareAvatar = if not FFlagAXAvatarSharingEntryPoint then nil else "Feature.Avatar.Action.ShareAvatar",
		myPublishedAvatars = if not FFlagAXAvatarSharingEntryPoint then nil else "Feature.Avatar.Action.MyPublishedAvatars",
		photobooth = if not FFlagAXPhotoboothFunctionality then nil else "Feature.Avatar.Label.Photobooth"
	})
	local v47 = React.useCallback(function() -- line: 88
		-- upvalues: v42 (copy), AvatarScreen (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
		v42.navigate(AvatarScreen.AvatarSwitcher)
		SlotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.Main.AvatarSwitcher)
	end, { v42 })
	local v48 = React.useCallback(function() -- line: 94
		-- upvalues: v42 (copy), AvatarScreen (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
		v42.navigate(AvatarScreen.AccessoryAdjustment)
		SlotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.AvatarRefinement.AdjustAccessory)
	end, { v42 })
	local v49 = React.useCallback(function() -- line: 99
		-- upvalues: v42 (copy), AvatarScreen (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
		v42.navigate(AvatarScreen.BodyShape)
		SlotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.AvatarRefinement.BodyScale)
	end, { v42 })
	local v50 = React.useCallback(function() -- line: 104
		-- upvalues: v42 (copy), AvatarScreen (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
		v42.navigate(AvatarScreen.HeadRefinement)
		SlotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.AvatarRefinement.CustomizeHead)
	end, { v42 })
	local v51 = React.useCallback(function() -- line: 109
		-- upvalues: v42 (copy), AvatarScreen (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
		v42.navigate(AvatarScreen.LayeredClothingSort)
		SlotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.AvatarRefinement.ClothingLayers)
	end, { v42 })
	local v52 = if not FFlagAXCustomizeMakeupSupport then nil else React.useCallback(function() -- line: 115
		-- upvalues: v42 (copy), AvatarScreen (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
		v42.navigate(AvatarScreen.LayeredMakeupSort)
		SlotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.AvatarRefinement.MakeupLayers)
	end, { v42 })
	local v53 = React.useCallback(function() -- line: 121
		-- upvalues: v42 (copy), AvatarScreen (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
		v42.navigate(AvatarScreen.ColorAdjustment)
		SlotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.AvatarRefinement.ColorAdjustment)
	end, { v42 })
	local u54 = nil
	local u55 = nil

	if FFlagAXAvatarSharingEntryPoint then
		u54 = React.useCallback(function() -- line: 128
			-- upvalues: v42 (copy), AvatarScreen (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
			local v64 = if not v42.state or not v42.state.key then nil else v42.state.key

			v42.navigate(AvatarScreen.LookComposerPage, {
				prevNavPage = v64
			})
			SlotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.SharedCommunityAvatars.ShareAvatar)
		end, { v42 })
		u55 = React.useCallback(function() -- line: 136
			-- upvalues: v42 (copy), AvatarScreen (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
			v42.navigate(AvatarScreen.MySharedAvatars)
			SlotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.SharedCommunityAvatars.MyPublishedAvatars)
		end, { v42 })
	end

	local v56 = React.useCallback(function() -- line: 142
		-- upvalues: p2 (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
		if p2.onInventoryActivated then
			p2.onInventoryActivated()
		end

		SlotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.More.Inventory)
	end, { p2.onInventoryActivated })
	local v57 = React.useCallback(function() -- line: 149
		-- upvalues: v42 (copy), AvatarScreen (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
		v42.navigate(AvatarScreen.EditEmotes)
		SlotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.More.Emotes)
	end, { v42 })
	local v58 = React.useCallback(function() -- line: 154
		-- upvalues: v42 (copy), AvatarScreen (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
		local v65 = if not v42.state or not v42.state.key then nil else v42.state.key

		v42.navigate(AvatarScreen.ProfilePictureEditorEmotes, {
			prevNavPage = v65
		})
		SlotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.More.ProfilePhoto)
	end, { v42 })
	local u59 = nil

	if FFlagAXPhotoboothFunctionality then
		u59 = React.useCallback(function() -- line: 165
			-- upvalues: v42 (copy), AvatarScreen (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
			v42.navigate(AvatarScreen.Photobooth)
			SlotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.Photobooth.Photobooth)
		end, { v42 })
	end

	local u60 = nil

	if FFlagAXFavoritesManagerNavEntry then
		u60 = React.useCallback(function() -- line: 173
			-- upvalues: v42 (copy), AvatarScreen (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
			v42.navigate(AvatarScreen.FavoritesSaved)
			SlotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.Main.Favorites)
		end, { v42 })
	end

	local v61 = if not AXEnableAccessoryAdjustmentDuringTryOnIXP.isEnabled() then nil else IXPUtils.readTestVariable(AXEnableAccessoryAdjustmentDuringTryOnIXP.EnabledForUser)
	local v62 = if not FFlagAXHideHeadAdjustmentForDefaultHead then nil else useSelector(selectHasDynamicHead)
	local v63 = if not FFlagAXResetAvatarButton then nil else useUndoRedoBarViewModel()

	return {
		config = React.useMemo(function() -- line: 193
			-- upvalues: MenuItemEnum (copy), p2 (copy), getRbxthumbWithTypeSizeAndOptions (copy), v45 (copy), AvatarHeadShot (copy), FFlagAXRootSlotBasedEditorFlag (copy), v58 (copy), v47 (copy), FFlagAXMigrateBuilderIcons (copy), IconName (copy), SlotBasedEditorAnalytics (copy), v46 (copy), v61 (copy), v41 (copy), v48 (copy), v49 (copy), v50 (copy), FFlagAXHideHeadAdjustmentForDefaultHead (copy), v62 (copy), v51 (copy), FFlagAXCustomizeMakeupSupport (copy), v52 (copy), v43 (copy), v53 (copy), FFlagAXAvatarSharingEntryPoint (copy), u54 (ref), u55 (ref), v56 (copy), v44 (copy), v57 (copy), FFlagAXPhotoboothFunctionality (copy), u59 (ref), FFlagAXFavoritesManagerNavEntry (copy), u60 (ref), FFlagAXResetAvatarButton (copy), v63 (copy)
			local t1 = {
				{
					type = "image",
					id = MenuItemEnum.Main.AvatarSwitcher,
					thumbnailUrl = if not p2.thumbnailUrl then getRbxthumbWithTypeSizeAndOptions(v45, AvatarHeadShot, 150, true, true) else p2.thumbnailUrl,
					onActivated = if not FFlagAXRootSlotBasedEditorFlag then v47 else v58,
					hideIndicator = not not FFlagAXRootSlotBasedEditorFlag or nil,
					enableFocusAnimation = if not p2.focusAnimation then nil else p2.focusAnimation.enabled and p2.focusAnimation.menuItemId == MenuItemEnum.Main.AvatarSwitcher
				},
				{
					type = "icon",
					id = MenuItemEnum.Main.AvatarRefinement,
					icon = not FFlagAXMigrateBuilderIcons and "icons/menu/customize" or IconName.PersonStandingGear,
					onActivated = function() -- line: 220
						-- upvalues: SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
						SlotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.Main.AvatarRefinement)
					end,
					children = {
						{
							type = "icon",
							id = MenuItemEnum.AvatarRefinement.AdjustAccessory,
							text = v46.adjustAccessory,
							icon = if not v61 then not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/hats_off" or IconName.HatFedora else "icons/menu/transform-small",
							iconSize = v41.defaultLegacyIconSize,
							onActivated = v48
						},
						{
							type = "icon",
							id = MenuItemEnum.AvatarRefinement.BodyScale,
							text = v46.bodyShape,
							icon = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/build_off" or IconName.PersonStandingDualArrowsVertical,
							iconSize = v41.defaultLegacyIconSize,
							onActivated = v49
						},
						{
							type = "icon",
							id = MenuItemEnum.AvatarRefinement.CustomizeHead,
							text = v46.headAdjustment,
							icon = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/classicHead_off" or IconName.HeadBlank,
							iconSize = v41.defaultLegacyIconSize,
							onActivated = v50,
							visible = if not FFlagAXHideHeadAdjustmentForDefaultHead then nil else v62
						},
						{
							type = "icon",
							id = MenuItemEnum.AvatarRefinement.ClothingLayers,
							text = v46.clothingLayering,
							icon = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/clothing_off" or IconName.ClothesHanger,
							iconSize = v41.defaultLegacyIconSize,
							onActivated = v51
						},
						if not FFlagAXCustomizeMakeupSupport then nil else {
							type = "icon",
							id = MenuItemEnum.AvatarRefinement.MakeupLayers,
							text = v46.makeupLayering,
							icon = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/eyelash_off" or IconName.LipsLipstickMakeupBrush,
							iconSize = v41.defaultLegacyIconSize,
							onActivated = v52
						},
						if not v43 then nil else {
							type = "color",
							id = MenuItemEnum.AvatarRefinement.ColorAdjustment,
							text = v46.skinColor,
							colors = { v43 },
							colorSize = v41.defaultLegacyIconSize,
							onActivated = v53
						}
					}
				},
				if not FFlagAXAvatarSharingEntryPoint then nil else {
					type = "icon",
					id = MenuItemEnum.Main.SharedCommunityAvatars,
					icon = not FFlagAXMigrateBuilderIcons and "icons/actions/edit/add" or IconName.CirclePlus,
					onActivated = function() -- line: 296
						-- upvalues: SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
						SlotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.Main.SharedCommunityAvatars)
					end,
					children = {
						{
							type = "icon",
							id = MenuItemEnum.SharedCommunityAvatars.ShareAvatar,
							text = v46.shareAvatar,
							icon = not FFlagAXMigrateBuilderIcons and "icons/common/plus_heavy" or IconName.PlusLarge,
							iconSize = v41.defaultLegacyIconSize,
							onActivated = u54
						},
						{
							type = "icon",
							id = MenuItemEnum.SharedCommunityAvatars.MyPublishedAvatars,
							text = v46.myPublishedAvatars,
							icon = not FFlagAXMigrateBuilderIcons and "icons/actions/friend_sort/my_profile" or IconName.Person,
							iconSize = v41.defaultLegacyIconSize,
							onActivated = u55
						}
					}
				},
				if FFlagAXRootSlotBasedEditorFlag then nil else {
					type = "icon",
					id = MenuItemEnum.Main.More,
					icon = not FFlagAXMigrateBuilderIcons and "icons/common/hamburgermenu" or IconName.ThreeBarsHorizontal,
					onActivated = function() -- line: 330
						-- upvalues: SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
						SlotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.Main.More)
					end,
					visible = not FFlagAXRootSlotBasedEditorFlag,
					children = {
						{
							type = "icon",
							id = MenuItemEnum.More.Inventory,
							text = v46.inventory,
							icon = not FFlagAXMigrateBuilderIcons and "icons/menu/inventoryOff" or IconName.Backpack,
							onActivated = v56,
							visible = v44
						},
						if FFlagAXRootSlotBasedEditorFlag then nil else {
							type = "icon",
							icon = "icons/controls/emoteOff",
							id = MenuItemEnum.More.Emotes,
							text = v46.emotes,
							onActivated = v57
						},
						if not FFlagAXPhotoboothFunctionality then nil else {
							type = "icon",
							icon = "icons/controls/screenshot",
							id = MenuItemEnum.Photobooth.Photobooth,
							text = not v46.photobooth and "Photobooth" or v46.photobooth,
							onActivated = u59
						}
					}
				}
			}

			if FFlagAXFavoritesManagerNavEntry then
				table.insert(t1, {
					type = "icon",
					isActive = false,
					id = MenuItemEnum.Main.Favorites,
					icon = IconName.Star,
					onActivated = u60
				})
			end

			if FFlagAXResetAvatarButton and p2.showUndoRedo then
				table.insert(t1, {
					type = "divider",
					id = MenuItemEnum.UndoRedoDivider
				})

				for _, v68 in v63.items do
					table.insert(t1, v68)
				end
			end

			return t1
		end, {
			v45,
			v47,
			v48,
			v49,
			v50,
			v51,
			v56,
			v57,
			v58,
			v53,
			v43,
			v44,
			p2.thumbnailUrl,
			p2.focusAnimation,
			if not FFlagAXResetAvatarButton then nil else p2.showUndoRedo,
			if not FFlagAXResetAvatarButton then nil else v63,
			if not FFlagAXHideHeadAdjustmentForDefaultHead then nil else v62
		})
	}
end

return useCustomizeControlBarProps
