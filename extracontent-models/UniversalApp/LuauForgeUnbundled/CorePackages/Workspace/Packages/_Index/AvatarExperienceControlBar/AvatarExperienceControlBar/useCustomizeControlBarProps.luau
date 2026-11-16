local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/React")
local UserLib = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/UserLib")
local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/Navigation")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/AvatarExperienceNavigation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/Localization")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/AvatarExperienceCommon")
local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/AvatarExperienceAnalytics")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/Foundation")

local selectColorAdjustmentButtonColor = AvatarExperienceCommon.State.Selectors.selectColorAdjustmentButtonColor
local selectHasDynamicHead = AvatarExperienceCommon.State.Selectors.selectHasDynamicHead
local slotBasedEditorAnalytics = AvatarExperienceAnalytics.Surfaces.SlotBasedEditorAnalytics

local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/RoactUtils").Hooks.RoactRodux.useSelector
local useNavigation = Navigation.useNavigation
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local useSemanticTokens = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/AvatarExperienceControlBar/Hooks/useSemanticTokens")
local useLocalization = Localization.Hooks.useLocalization

local useUndoRedoBarViewModel = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/AvatarExperienceControlBar/UndoRedoBar/useUndoRedoBarViewModel")

local iconName = Foundation.Enums.IconName
local popoverAlign = Foundation.Enums.PopoverAlign

local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local constants = UserLib.Utils.Constants

local MenuItemEnum = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/AvatarExperienceControlBar/Enums/MenuItemEnum")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/AvatarExperienceControlBar/ControlBarTypes")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/AvatarExperienceFlags")
local fFlagAXAvatarSharingEntryPoint = AvatarExperienceFlags.FFlagAXAvatarSharingEntryPoint
local fFlagAXMigrateBuilderIcons = AvatarExperienceFlags.FFlagAXMigrateBuilderIcons
local fFlagAXResetAvatarButton = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/AvatarExperienceFlags").FFlagAXResetAvatarButton

local fFlagAXHideHeadAdjustmentForDefaultHead = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/AvatarExperienceFlags").FFlagAXHideHeadAdjustmentForDefaultHead
local fFlagAXFavoritesManagerNavEntry = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/AvatarExperienceFlags").FFlagAXFavoritesManagerNavEntry
local fFlagAXUseProfileIconEntryPoint = AvatarExperienceFlags.FFlagAXUseProfileIconEntryPoint
local fFlagMeProfileEntryTooltipEnabled = AvatarExperienceFlags.FFlagMeProfileEntryTooltipEnabled
local fFlagMeProfileEntryTooltipVerticalCenter = AvatarExperienceFlags.FFlagMeProfileEntryTooltipVerticalCenter
local useMeProfileEntryTooltip = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceControlBar/AvatarExperienceControlBar/Hooks/useMeProfileEntryTooltip")
local fFlagControlBarUseProfileFrameThumbnail = AvatarExperienceFlags.FFlagControlBarUseProfileFrameThumbnail
local fFlagAXPPEReturnToEntrySurface = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/SharedFlags").FFlagAXPPEReturnToEntrySurface
local fFlagEditProfileImageV2Enabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceControlBar/SharedFlags").FFlagEditProfileImageV2Enabled

local avatarHeadShot = constants.RbxthumbTypes.AvatarHeadShot

local set = {
	[avatarScreen.Catalog] = true,
	[avatarScreen.AvatarEditor] = true,
	[avatarScreen.MySharedAvatars] = true,
	[avatarScreen.CatalogSearch] = true,
	[avatarScreen.CatalogSearchLanding] = true,
	[avatarScreen.SearchLandingFocusedWidgetPage] = true
}

local function selectUserId(p2)
	return p2.LocalUserId
end

local function useCustomizeControlBarProps(data)
	local v5 = useSemanticTokens()
	local v6 = useNavigation()
	local v7

	if fFlagAXUseProfileIconEntryPoint or fFlagAXPPEReturnToEntrySurface then
		v7 = useAvatarRoute()
	else
		v7 = nil
	end

	local v8 = fFlagAXUseProfileIconEntryPoint

	if v8 then
		v8 = not (v7 == nil) and v7.opaque.name == avatarScreen.Profile
	end

	local v9 = useSelector(selectColorAdjustmentButtonColor)
	local v10 = useSelector(selectUserId)
	local v11

	if fFlagMeProfileEntryTooltipEnabled then
		local v13

		if v7 == nil then
			v13 = false
		else
			v13 = v7.isVisible and not v7.isOverlayVisible

			if v13 then
				v13 = v7.current.key == v6.state.key and set[v7.current.name] == true
			end
		end

		local v14 = if v7 then v7.current.key else nil
		v11 = useMeProfileEntryTooltip(v13, v14)
	else
		v11 = nil
	end

	local v12 = useLocalization({
		profileTooltip = fFlagMeProfileEntryTooltipEnabled and "Feature.Avatar.profile.tooltip" or nil,
		adjustAccessory = "Feature.Avatar.Label.Title.AccessoryAdjustment",
		bodyShape = "Feature.Avatar.Label.Title.BodyShape",
		clothingLayering = "Feature.Avatar.Label.Title.ClothingLayering",
		makeupLayering = "Feature.Avatar.Label.Title.MakeupLayering",
		headAdjustment = "Feature.Avatar.Label.Title.HeadAdjustment",
		profilePhoto = "Feature.Avatar.Label.Title.ProfilePhoto",
		skinColor = "Feature.Avatar.ColorAdjustmentPage.Title",
		shareAvatar = fFlagAXAvatarSharingEntryPoint and "Feature.Avatar.Action.ShareAvatar" or nil,
		myPublishedAvatars = fFlagAXAvatarSharingEntryPoint and "Feature.Avatar.Action.MyPublishedAvatars" or nil
	})

	local v13 = React.useCallback(function()
		v6.navigate(avatarScreen.AccessoryAdjustment)
		slotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.AvatarRefinement.AdjustAccessory)
	end, { v6 })

	local v14 = React.useCallback(function()
		v6.navigate(avatarScreen.BodyShape)
		slotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.AvatarRefinement.BodyScale)
	end, { v6 })

	local v15 = React.useCallback(function()
		v6.navigate(avatarScreen.HeadRefinement)
		slotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.AvatarRefinement.CustomizeHead)
	end, { v6 })

	local v16 = React.useCallback(function()
		v6.navigate(avatarScreen.LayeredClothingSort)
		slotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.AvatarRefinement.ClothingLayers)
	end, { v6 })

	local v17 = React.useCallback(function()
		v6.navigate(avatarScreen.LayeredMakeupSort)
		slotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.AvatarRefinement.MakeupLayers)
	end, { v6 })

	local v18 = React.useCallback(function()
		v6.navigate(avatarScreen.ColorAdjustment)
		slotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.AvatarRefinement.ColorAdjustment)
	end, { v6 })
	local v19, v20

	if fFlagAXAvatarSharingEntryPoint then
		v19 = React.useCallback(function()
			local v21 = if v6.state and v6.state.key then v6.state.key else nil
			v6.navigate(avatarScreen.LookComposerPage, { prevNavPage = v21 })

			slotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.SharedCommunityAvatars.ShareAvatar)
		end, { v6 })

		v20 = React.useCallback(function()
			v6.navigate(avatarScreen.MySharedAvatars)
			slotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.SharedCommunityAvatars.MyPublishedAvatars)
		end, { v6 })
	else
		v19 = nil
		v20 = nil
	end

	local useCallback = React.useCallback
	local function fn()
		local key = if v6.state and v6.state.key then v6.state.key else nil

		if fFlagEditProfileImageV2Enabled then
			local v21 = if v7 then v7.opaque.name else key

			if fFlagAXUseProfileIconEntryPoint and set[v21] then
				local navigate = v6.navigate
				local profile = avatarScreen.Profile

				local v24 = if v7 then v7.opaque.params else nil
				navigate(profile, {
					entryOrigin = { screenName = v21, screenParams = v24 }
				})

				if fFlagMeProfileEntryTooltipEnabled and v11 then
					v11.dismiss()
				end
			elseif fFlagAXPPEReturnToEntrySurface then
				v6.navigate(avatarScreen.EditProfileImage, {
					entryOrigin = v7 and {
						screenName = v7.opaque.name,
						screenParams = v7.opaque.params
					} or nil
				})
			else
				v6.navigate(avatarScreen.EditProfileImage, { prevNavPage = key })
			end
		else
			local v21 = if v7 then v7.opaque.name else key
			local v22

			if fFlagAXUseProfileIconEntryPoint and set[v21] then
				v22 = avatarScreen.Profile
			else
				v22 = avatarScreen.ProfilePictureEditorEmotes
			end

			local v23

			if v22 == avatarScreen.Profile then
				v23 = { entryOrigin = 0 }

				local v25 = if v7 then v7.opaque.params else nil
				v23.entryOrigin = { screenName = v21, screenParams = v25 }
			else
				v23 = fFlagAXPPEReturnToEntrySurface and {
					entryOrigin = v7 and {
						screenName = v7.opaque.name,
						screenParams = v7.opaque.params
					} or nil
				} or { prevNavPage = key }
			end

			v6.navigate(v22, v23)

			if fFlagMeProfileEntryTooltipEnabled and v11 and v22 == avatarScreen.Profile then
				v11.dismiss()
			end
		end

		slotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.More.ProfilePhoto)
	end

	local v22 = if fFlagAXUseProfileIconEntryPoint or fFlagAXPPEReturnToEntrySurface then v7 else nil
	local v23 = if fFlagMeProfileEntryTooltipEnabled and v11 then v11.dismiss else nil
	local v24 = useCallback(fn, { v6, v22, v23 })
	local v25

	if fFlagAXFavoritesManagerNavEntry then
		v25 = React.useCallback(function()
			v6.navigate(avatarScreen.FavoritesSaved)
			slotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.Main.Favorites)
		end, { v6 })
	else
		v25 = nil
	end

	local v26 = if fFlagAXHideHeadAdjustmentForDefaultHead then useSelector(selectHasDynamicHead) else nil

	local v27 = if fFlagAXResetAvatarButton then useUndoRedoBarViewModel() else nil

	local useMemo = React.useMemo
	local function fn2()
		local v28 = {
			type = "image",
			id = MenuItemEnum.Main.AvatarSwitcher,
			thumbnailUrl = 0,
			onActivated = 0,
			visible = 0,
			hideIndicator = true,
			toolTipConfig = 0,
			enableFocusAnimation = 0
		}
		local v29 = if data.thumbnailUrl then data.thumbnailUrl else getRbxthumbWithTypeSizeAndOptions(
			v10,
			avatarHeadShot,
			150,
			true,
			true,
			fFlagControlBarUseProfileFrameThumbnail
		)
		v28.thumbnailUrl = v29

		v28.onActivated = v24
		v28.visible = if fFlagAXUseProfileIconEntryPoint then not v8 else nil
		local v31

		if fFlagMeProfileEntryTooltipEnabled and v11 then
			v31 = {
				align = 0,
				bodyText = 0,
				open = 0,
				compact = true,
				onShown = 0,
				onDismiss = 0
			}
			local v32 = if fFlagMeProfileEntryTooltipVerticalCenter then popoverAlign.Center else nil
			v31.align = v32
			v31.bodyText = v12.profileTooltip
			v31.open = v11.showTooltip

			v31.onShown = v11.onShown
			v31.onDismiss = v11.dismiss
		end

		v28.toolTipConfig = v31

		local v32 = if data.focusAnimation then data.focusAnimation.enabled and data.focusAnimation.menuItemId == MenuItemEnum.Main.AvatarSwitcher else nil
		v28.enableFocusAnimation = v32
		local result = {
			v28,
			{
				type = "icon",
				id = MenuItemEnum.Main.AvatarRefinement,
				icon = not fFlagAXMigrateBuilderIcons and "icons/menu/customize" or iconName.PersonStandingGear,
				onActivated = function()
					slotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.Main.AvatarRefinement)
				end,
				children = {
					{
						type = "icon",
						id = MenuItemEnum.AvatarRefinement.AdjustAccessory,
						text = v12.adjustAccessory,
						icon = not fFlagAXMigrateBuilderIcons and "icons/menu/clothing/hats_off" or iconName.HatFedora,
						iconSize = v5.defaultLegacyIconSize,
						onActivated = v13
					},
					{
						type = "icon",
						id = MenuItemEnum.AvatarRefinement.BodyScale,
						text = v12.bodyShape,
						icon = not fFlagAXMigrateBuilderIcons and "icons/menu/clothing/build_off" or iconName.PersonStandingDualArrowsVertical,
						iconSize = v5.defaultLegacyIconSize,
						onActivated = v14
					},
					{
						type = "icon",
						id = MenuItemEnum.AvatarRefinement.CustomizeHead,
						text = v12.headAdjustment,
						icon = not fFlagAXMigrateBuilderIcons and "icons/menu/clothing/classicHead_off" or iconName.HeadBlank,
						iconSize = v5.defaultLegacyIconSize,
						onActivated = v15,
						visible = if fFlagAXHideHeadAdjustmentForDefaultHead then v26 else nil
					},
					{
						type = "icon",
						id = MenuItemEnum.AvatarRefinement.ClothingLayers,
						text = v12.clothingLayering,
						icon = not fFlagAXMigrateBuilderIcons and "icons/menu/clothing/clothing_off" or iconName.ClothesHanger,
						iconSize = v5.defaultLegacyIconSize,
						onActivated = v16
					},
					{
						type = "icon",
						id = MenuItemEnum.AvatarRefinement.MakeupLayers,
						text = v12.makeupLayering,
						icon = not fFlagAXMigrateBuilderIcons and "icons/menu/clothing/eyelash_off" or iconName.LipsLipstickMakeupBrush,
						iconSize = v5.defaultLegacyIconSize,
						onActivated = v17
					},
					v9 and {
						type = "color",
						id = MenuItemEnum.AvatarRefinement.ColorAdjustment,
						text = v12.skinColor,
						colors = { v9 },
						colorSize = v5.defaultLegacyIconSize,
						onActivated = v18
					} or nil
				}
			},
			fFlagAXAvatarSharingEntryPoint and {
				type = "icon",
				id = MenuItemEnum.Main.SharedCommunityAvatars,
				icon = not fFlagAXMigrateBuilderIcons and "icons/actions/edit/add" or iconName.CirclePlus,
				onActivated = function()
					slotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.Main.SharedCommunityAvatars)
				end,
				children = {
					{
						type = "icon",
						id = MenuItemEnum.SharedCommunityAvatars.ShareAvatar,
						text = v12.shareAvatar,
						icon = not fFlagAXMigrateBuilderIcons and "icons/common/plus_heavy" or iconName.PlusLarge,
						iconSize = v5.defaultLegacyIconSize,
						onActivated = v19
					},
					{
						type = "icon",
						id = MenuItemEnum.SharedCommunityAvatars.MyPublishedAvatars,
						text = v12.myPublishedAvatars,
						icon = not fFlagAXMigrateBuilderIcons and "icons/actions/friend_sort/my_profile" or iconName.Person,
						iconSize = v5.defaultLegacyIconSize,
						onActivated = v20
					}
				}
			} or nil
		}

		if fFlagAXFavoritesManagerNavEntry then
			table.insert(result, {
				type = "icon",
				id = MenuItemEnum.Main.Favorites,
				icon = iconName.Star,
				onActivated = v25,
				isActive = false
			})
		end

		if fFlagAXResetAvatarButton and data.showUndoRedo then
			table.insert(result, { type = "divider", id = MenuItemEnum.UndoRedoDivider })

			for k, item in v27.items do
				table.insert(result, item)
			end
		end

		return result
	end

	local thumbnailUrl = data.thumbnailUrl
	local focusAnimation = data.focusAnimation
	local showUndoRedo = if fFlagAXResetAvatarButton then data.showUndoRedo else nil
	local v29 = if fFlagAXResetAvatarButton then v27 else nil
	local v30 = if fFlagAXHideHeadAdjustmentForDefaultHead then v26 else nil
	local v31 = if fFlagAXUseProfileIconEntryPoint then v8 else nil
	local showTooltip = if fFlagMeProfileEntryTooltipEnabled and v11 then v11.showTooltip else nil
	local v32 = if fFlagMeProfileEntryTooltipEnabled and v7 then v7.opaque.name else nil
	return {
		config = useMemo(fn2, {
			v10,
			v13,
			v14,
			v15,
			v16,
			v24,
			v18,
			v9,
			thumbnailUrl,
			focusAnimation,
			showUndoRedo,
			v29,
			v30,
			v31,
			showTooltip,
			v32,
			if fFlagMeProfileEntryTooltipEnabled then v12.profileTooltip else nil
		})
	}
end

return useCustomizeControlBarProps
