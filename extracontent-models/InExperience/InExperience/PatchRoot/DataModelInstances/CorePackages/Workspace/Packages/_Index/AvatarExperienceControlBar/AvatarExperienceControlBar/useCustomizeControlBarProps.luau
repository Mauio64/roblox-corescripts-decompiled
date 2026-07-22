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
local FFlagAXHideHeadAdjustmentForDefaultHead = require(AvatarExperienceControlBarParent.AvatarExperienceFlags).FFlagAXHideHeadAdjustmentForDefaultHead
local FFlagAXFavoritesManagerNavEntry = require(AvatarExperienceControlBarParent.AvatarExperienceFlags).FFlagAXFavoritesManagerNavEntry
local AvatarHeadShot = Constants.RbxthumbTypes.AvatarHeadShot

local function selectUserId(p1) -- line: 50
	return p1.LocalUserId
end
local function useCustomizeControlBarProps(p2) -- line: 64
	-- upvalues: useSemanticTokens (copy), useNavigation (copy), useSelector (copy), selectColorAdjustmentButtonColor (copy), Responsive (copy), selectUserId (copy), useLocalization (copy), FFlagAXAvatarSharingEntryPoint (copy), FFlagAXPhotoboothFunctionality (copy), React (copy), AvatarScreen (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy), FFlagAXFavoritesManagerNavEntry (copy), AXEnableAccessoryAdjustmentDuringTryOnIXP (copy), IXPUtils (copy), FFlagAXHideHeadAdjustmentForDefaultHead (copy), selectHasDynamicHead (copy), FFlagAXResetAvatarButton (copy), useUndoRedoBarViewModel (copy), getRbxthumbWithTypeSizeAndOptions (copy), AvatarHeadShot (copy), FFlagAXRootSlotBasedEditorFlag (copy), FFlagAXMigrateBuilderIcons (copy), IconName (copy)
	local v40 = useSemanticTokens()
	local v41 = useNavigation()
	local v42 = useSelector(selectColorAdjustmentButtonColor)
	local v43 = Responsive.useOrientation() == Responsive.Keys.Portrait
	local v44 = useSelector(selectUserId)
	local v45 = useLocalization({
		adjustAccessory = "Feature.Avatar.Label.Title.AccessoryAdjustment",
		bodyShape = "Feature.Avatar.Label.Title.BodyShape",
		clothingLayering = "Feature.Avatar.Label.Title.ClothingLayering",
		makeupLayering = "Feature.Avatar.Label.Title.MakeupLayering",
		headAdjustment = "Feature.Avatar.Label.Title.HeadAdjustment",
		inventory = "Feature.Avatar.Label.Title.Inventory",
		emotes = "Feature.Avatar.Label.Title.Emotes",
		profilePhoto = "Feature.Avatar.Label.Title.ProfilePhoto",
		skinColor = "Feature.Avatar.ColorAdjustmentPage.Title",
		shareAvatar = if not FFlagAXAvatarSharingEntryPoint then nil else "Feature.Avatar.Action.ShareAvatar",
		myPublishedAvatars = if not FFlagAXAvatarSharingEntryPoint then nil else "Feature.Avatar.Action.MyPublishedAvatars",
		photobooth = if not FFlagAXPhotoboothFunctionality then nil else "Feature.Avatar.Label.Photobooth"
	})
	local v46 = React.useCallback(function() -- line: 87
		-- upvalues: v41 (copy), AvatarScreen (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
		v41.navigate(AvatarScreen.AvatarSwitcher)
		SlotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.Main.AvatarSwitcher)
	end, { v41 })
	local v47 = React.useCallback(function() -- line: 93
		-- upvalues: v41 (copy), AvatarScreen (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
		v41.navigate(AvatarScreen.AccessoryAdjustment)
		SlotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.AvatarRefinement.AdjustAccessory)
	end, { v41 })
	local v48 = React.useCallback(function() -- line: 98
		-- upvalues: v41 (copy), AvatarScreen (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
		v41.navigate(AvatarScreen.BodyShape)
		SlotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.AvatarRefinement.BodyScale)
	end, { v41 })
	local v49 = React.useCallback(function() -- line: 103
		-- upvalues: v41 (copy), AvatarScreen (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
		v41.navigate(AvatarScreen.HeadRefinement)
		SlotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.AvatarRefinement.CustomizeHead)
	end, { v41 })
	local v50 = React.useCallback(function() -- line: 108
		-- upvalues: v41 (copy), AvatarScreen (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
		v41.navigate(AvatarScreen.LayeredClothingSort)
		SlotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.AvatarRefinement.ClothingLayers)
	end, { v41 })
	local v51 = React.useCallback(function() -- line: 113
		-- upvalues: v41 (copy), AvatarScreen (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
		v41.navigate(AvatarScreen.LayeredMakeupSort)
		SlotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.AvatarRefinement.MakeupLayers)
	end, { v41 })
	local v52 = React.useCallback(function() -- line: 118
		-- upvalues: v41 (copy), AvatarScreen (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
		v41.navigate(AvatarScreen.ColorAdjustment)
		SlotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.AvatarRefinement.ColorAdjustment)
	end, { v41 })
	local u53 = nil
	local u54 = nil

	if FFlagAXAvatarSharingEntryPoint then
		u53 = React.useCallback(function() -- line: 125
			-- upvalues: v41 (copy), AvatarScreen (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
			local v63 = if not v41.state or not v41.state.key then nil else v41.state.key

			v41.navigate(AvatarScreen.LookComposerPage, {
				prevNavPage = v63
			})
			SlotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.SharedCommunityAvatars.ShareAvatar)
		end, { v41 })
		u54 = React.useCallback(function() -- line: 133
			-- upvalues: v41 (copy), AvatarScreen (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
			v41.navigate(AvatarScreen.MySharedAvatars)
			SlotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.SharedCommunityAvatars.MyPublishedAvatars)
		end, { v41 })
	end

	local v55 = React.useCallback(function() -- line: 139
		-- upvalues: p2 (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
		if p2.onInventoryActivated then
			p2.onInventoryActivated()
		end

		SlotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.More.Inventory)
	end, { p2.onInventoryActivated })
	local v56 = React.useCallback(function() -- line: 146
		-- upvalues: v41 (copy), AvatarScreen (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
		v41.navigate(AvatarScreen.EditEmotes)
		SlotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.More.Emotes)
	end, { v41 })
	local v57 = React.useCallback(function() -- line: 151
		-- upvalues: v41 (copy), AvatarScreen (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
		local v64 = if not v41.state or not v41.state.key then nil else v41.state.key

		v41.navigate(AvatarScreen.ProfilePictureEditorEmotes, {
			prevNavPage = v64
		})
		SlotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.More.ProfilePhoto)
	end, { v41 })
	local u58 = nil

	if FFlagAXPhotoboothFunctionality then
		u58 = React.useCallback(function() -- line: 162
			-- upvalues: v41 (copy), AvatarScreen (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
			v41.navigate(AvatarScreen.Photobooth)
			SlotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.Photobooth.Photobooth)
		end, { v41 })
	end

	local u59 = nil

	if FFlagAXFavoritesManagerNavEntry then
		u59 = React.useCallback(function() -- line: 170
			-- upvalues: v41 (copy), AvatarScreen (copy), SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
			v41.navigate(AvatarScreen.FavoritesSaved)
			SlotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.Main.Favorites)
		end, { v41 })
	end

	local v60 = if not AXEnableAccessoryAdjustmentDuringTryOnIXP.isEnabled() then nil else IXPUtils.readTestVariable(AXEnableAccessoryAdjustmentDuringTryOnIXP.EnabledForUser)
	local v61 = if not FFlagAXHideHeadAdjustmentForDefaultHead then nil else useSelector(selectHasDynamicHead)
	local v62 = if not FFlagAXResetAvatarButton then nil else useUndoRedoBarViewModel()

	return {
		config = React.useMemo(function() -- line: 190
			-- upvalues: MenuItemEnum (copy), p2 (copy), getRbxthumbWithTypeSizeAndOptions (copy), v44 (copy), AvatarHeadShot (copy), FFlagAXRootSlotBasedEditorFlag (copy), v57 (copy), v46 (copy), FFlagAXMigrateBuilderIcons (copy), IconName (copy), SlotBasedEditorAnalytics (copy), v45 (copy), v60 (copy), v40 (copy), v47 (copy), v48 (copy), v49 (copy), FFlagAXHideHeadAdjustmentForDefaultHead (copy), v61 (copy), v50 (copy), v51 (copy), v42 (copy), v52 (copy), FFlagAXAvatarSharingEntryPoint (copy), u53 (ref), u54 (ref), v55 (copy), v43 (copy), v56 (copy), FFlagAXPhotoboothFunctionality (copy), u58 (ref), FFlagAXFavoritesManagerNavEntry (copy), u59 (ref), FFlagAXResetAvatarButton (copy), v62 (copy)
			local t1 = {
				{
					type = "image",
					id = MenuItemEnum.Main.AvatarSwitcher,
					thumbnailUrl = if not p2.thumbnailUrl then getRbxthumbWithTypeSizeAndOptions(v44, AvatarHeadShot, 150, true, true) else p2.thumbnailUrl,
					onActivated = if not FFlagAXRootSlotBasedEditorFlag then v46 else v57,
					hideIndicator = not not FFlagAXRootSlotBasedEditorFlag or nil,
					enableFocusAnimation = if not p2.focusAnimation then nil else p2.focusAnimation.enabled and p2.focusAnimation.menuItemId == MenuItemEnum.Main.AvatarSwitcher
				},
				{
					type = "icon",
					id = MenuItemEnum.Main.AvatarRefinement,
					icon = not FFlagAXMigrateBuilderIcons and "icons/menu/customize" or IconName.PersonStandingGear,
					onActivated = function() -- line: 217
						-- upvalues: SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
						SlotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.Main.AvatarRefinement)
					end,
					children = {
						{
							type = "icon",
							id = MenuItemEnum.AvatarRefinement.AdjustAccessory,
							text = v45.adjustAccessory,
							icon = if not v60 then not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/hats_off" or IconName.HatFedora else "icons/menu/transform-small",
							iconSize = v40.defaultLegacyIconSize,
							onActivated = v47
						},
						{
							type = "icon",
							id = MenuItemEnum.AvatarRefinement.BodyScale,
							text = v45.bodyShape,
							icon = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/build_off" or IconName.PersonStandingDualArrowsVertical,
							iconSize = v40.defaultLegacyIconSize,
							onActivated = v48
						},
						{
							type = "icon",
							id = MenuItemEnum.AvatarRefinement.CustomizeHead,
							text = v45.headAdjustment,
							icon = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/classicHead_off" or IconName.HeadBlank,
							iconSize = v40.defaultLegacyIconSize,
							onActivated = v49,
							visible = if not FFlagAXHideHeadAdjustmentForDefaultHead then nil else v61
						},
						{
							type = "icon",
							id = MenuItemEnum.AvatarRefinement.ClothingLayers,
							text = v45.clothingLayering,
							icon = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/clothing_off" or IconName.ClothesHanger,
							iconSize = v40.defaultLegacyIconSize,
							onActivated = v50
						},
						{
							type = "icon",
							id = MenuItemEnum.AvatarRefinement.MakeupLayers,
							text = v45.makeupLayering,
							icon = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/eyelash_off" or IconName.LipsLipstickMakeupBrush,
							iconSize = v40.defaultLegacyIconSize,
							onActivated = v51
						},
						if not v42 then nil else {
							type = "color",
							id = MenuItemEnum.AvatarRefinement.ColorAdjustment,
							text = v45.skinColor,
							colors = { v42 },
							colorSize = v40.defaultLegacyIconSize,
							onActivated = v52
						}
					}
				},
				if not FFlagAXAvatarSharingEntryPoint then nil else {
					type = "icon",
					id = MenuItemEnum.Main.SharedCommunityAvatars,
					icon = not FFlagAXMigrateBuilderIcons and "icons/actions/edit/add" or IconName.CirclePlus,
					onActivated = function() -- line: 291
						-- upvalues: SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
						SlotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.Main.SharedCommunityAvatars)
					end,
					children = {
						{
							type = "icon",
							id = MenuItemEnum.SharedCommunityAvatars.ShareAvatar,
							text = v45.shareAvatar,
							icon = not FFlagAXMigrateBuilderIcons and "icons/common/plus_heavy" or IconName.PlusLarge,
							iconSize = v40.defaultLegacyIconSize,
							onActivated = u53
						},
						{
							type = "icon",
							id = MenuItemEnum.SharedCommunityAvatars.MyPublishedAvatars,
							text = v45.myPublishedAvatars,
							icon = not FFlagAXMigrateBuilderIcons and "icons/actions/friend_sort/my_profile" or IconName.Person,
							iconSize = v40.defaultLegacyIconSize,
							onActivated = u54
						}
					}
				},
				if FFlagAXRootSlotBasedEditorFlag then nil else {
					type = "icon",
					id = MenuItemEnum.Main.More,
					icon = not FFlagAXMigrateBuilderIcons and "icons/common/hamburgermenu" or IconName.ThreeBarsHorizontal,
					onActivated = function() -- line: 325
						-- upvalues: SlotBasedEditorAnalytics (copy), MenuItemEnum (copy)
						SlotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.Main.More)
					end,
					visible = not FFlagAXRootSlotBasedEditorFlag,
					children = {
						{
							type = "icon",
							id = MenuItemEnum.More.Inventory,
							text = v45.inventory,
							icon = not FFlagAXMigrateBuilderIcons and "icons/menu/inventoryOff" or IconName.Backpack,
							onActivated = v55,
							visible = v43
						},
						if FFlagAXRootSlotBasedEditorFlag then nil else {
							type = "icon",
							icon = "icons/controls/emoteOff",
							id = MenuItemEnum.More.Emotes,
							text = v45.emotes,
							onActivated = v56
						},
						if not FFlagAXPhotoboothFunctionality then nil else {
							type = "icon",
							icon = "icons/controls/screenshot",
							id = MenuItemEnum.Photobooth.Photobooth,
							text = not v45.photobooth and "Photobooth" or v45.photobooth,
							onActivated = u58
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
					onActivated = u59
				})
			end

			if FFlagAXResetAvatarButton and p2.showUndoRedo then
				table.insert(t1, {
					type = "divider",
					id = MenuItemEnum.UndoRedoDivider
				})

				for _, v67 in v62.items do
					table.insert(t1, v67)
				end
			end

			return t1
		end, {
			v44,
			v46,
			v47,
			v48,
			v49,
			v50,
			v55,
			v56,
			v57,
			v52,
			v42,
			v43,
			p2.thumbnailUrl,
			p2.focusAnimation,
			if not FFlagAXResetAvatarButton then nil else p2.showUndoRedo,
			if not FFlagAXResetAvatarButton then nil else v62,
			if not FFlagAXHideHeadAdjustmentForDefaultHead then nil else v61
		})
	}
end

return useCustomizeControlBarProps
