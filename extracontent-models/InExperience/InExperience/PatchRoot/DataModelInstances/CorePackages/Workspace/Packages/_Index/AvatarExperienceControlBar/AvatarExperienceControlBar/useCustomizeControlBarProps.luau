local AvatarExperienceControlBar = script:FindFirstAncestor("AvatarExperienceControlBar")

local parent = AvatarExperienceControlBar.Parent
local React = require(parent.React)
local UserLib = require(parent.UserLib)
local Navigation = require(parent.Navigation)
local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local Localization = require(parent.Localization)
local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)
local Foundation = require(parent.Foundation)

local selectColorAdjustmentButtonColor = AvatarExperienceCommon.State.Selectors.selectColorAdjustmentButtonColor
local selectHasDynamicHead = AvatarExperienceCommon.State.Selectors.selectHasDynamicHead
local SlotBasedEditorAnalytics = AvatarExperienceAnalytics.Surfaces.SlotBasedEditorAnalytics

local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useNavigation = Navigation.useNavigation
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local useSemanticTokens = require(AvatarExperienceControlBar.Hooks.useSemanticTokens)
local useLocalization = Localization.Hooks.useLocalization

local useUndoRedoBarViewModel = require(script.Parent.UndoRedoBar.useUndoRedoBarViewModel)

local IconName = Foundation.Enums.IconName
local PopoverAlign = Foundation.Enums.PopoverAlign

local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local Constants = UserLib.Utils.Constants

local MenuItemEnum = require(AvatarExperienceControlBar.Enums.MenuItemEnum)
require(AvatarExperienceControlBar.ControlBarTypes)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXAvatarSharingEntryPoint = AvatarExperienceFlags.FFlagAXAvatarSharingEntryPoint
local FFlagAXMigrateBuilderIcons = AvatarExperienceFlags.FFlagAXMigrateBuilderIcons
local AvatarExperienceFlags2 = require(parent.AvatarExperienceFlags)
local FFlagAXResetAvatarButton = AvatarExperienceFlags2.FFlagAXResetAvatarButton

local AvatarExperienceFlags3 = require(parent.AvatarExperienceFlags)
local FFlagAXHideHeadAdjustmentForDefaultHead = AvatarExperienceFlags3.FFlagAXHideHeadAdjustmentForDefaultHead
local AvatarExperienceFlags4 = require(parent.AvatarExperienceFlags)
local FFlagAXFavoritesManagerNavEntry = AvatarExperienceFlags4.FFlagAXFavoritesManagerNavEntry
local FFlagAXUseProfileIconEntryPoint = AvatarExperienceFlags.FFlagAXUseProfileIconEntryPoint
local FFlagMeProfileEntryTooltipEnabled = AvatarExperienceFlags.FFlagMeProfileEntryTooltipEnabled
local FFlagMeProfileEntryTooltipVerticalCenter = AvatarExperienceFlags.FFlagMeProfileEntryTooltipVerticalCenter
local useMeProfileEntryTooltip = require(AvatarExperienceControlBar.Hooks.useMeProfileEntryTooltip)
local FFlagControlBarUseProfileFrameThumbnail = AvatarExperienceFlags.FFlagControlBarUseProfileFrameThumbnail
local SharedFlags = require(parent.SharedFlags)
local FFlagAXPPEReturnToEntrySurface = SharedFlags.FFlagAXPPEReturnToEntrySurface
local SharedFlags2 = require(parent.SharedFlags)
local FFlagEditProfileImageV2Enabled = SharedFlags2.FFlagEditProfileImageV2Enabled

local AvatarHeadShot = Constants.RbxthumbTypes.AvatarHeadShot

local set = {
	[AvatarScreen.Catalog] = true,
	[AvatarScreen.AvatarEditor] = true,
	[AvatarScreen.MySharedAvatars] = true,
	[AvatarScreen.CatalogSearch] = true,
	[AvatarScreen.CatalogSearchLanding] = true,
	[AvatarScreen.SearchLandingFocusedWidgetPage] = true
}

local function selectUserId(p)
	return p.LocalUserId
end

local function useCustomizeControlBarProps(data)
	local v = useSemanticTokens()
	local v2 = useNavigation()
	local v3

	if FFlagAXUseProfileIconEntryPoint or FFlagAXPPEReturnToEntrySurface then
		v3 = useAvatarRoute()
	else
		v3 = nil
	end

	local v4 = FFlagAXUseProfileIconEntryPoint

	if v4 then
		if v3 == nil then
			v4 = false
		else
			v4 = v3.opaque.name == AvatarScreen.Profile
		end
	end

	local v5 = useSelector(selectColorAdjustmentButtonColor)
	local v6 = useSelector(selectUserId)
	local v7

	if FFlagMeProfileEntryTooltipEnabled then
		local v8

		if v3 == nil then
			v8 = false
		else
			v8 = v3.isVisible and not v3.isOverlayVisible

			if v8 then
				if v3.current.key == v2.state.key then
					v8 = set[v3.current.name] == true
				else
					v8 = false
				end
			end
		end

		local v9

		if v3 then
			v9 = v3.current.key
		end

		v7 = useMeProfileEntryTooltip(v8, v9)
	else
		v7 = nil
	end

	local v8 = useLocalization({
		profileTooltip = FFlagMeProfileEntryTooltipEnabled and "Feature.Avatar.profile.tooltip" or nil,
		adjustAccessory = "Feature.Avatar.Label.Title.AccessoryAdjustment",
		bodyShape = "Feature.Avatar.Label.Title.BodyShape",
		clothingLayering = "Feature.Avatar.Label.Title.ClothingLayering",
		makeupLayering = "Feature.Avatar.Label.Title.MakeupLayering",
		headAdjustment = "Feature.Avatar.Label.Title.HeadAdjustment",
		profilePhoto = "Feature.Avatar.Label.Title.ProfilePhoto",
		skinColor = "Feature.Avatar.ColorAdjustmentPage.Title",
		shareAvatar = FFlagAXAvatarSharingEntryPoint and "Feature.Avatar.Action.ShareAvatar" or nil,
		myPublishedAvatars = FFlagAXAvatarSharingEntryPoint and "Feature.Avatar.Action.MyPublishedAvatars" or nil
	})

	local onActivated = React.useCallback(function()
		v2.navigate(AvatarScreen.AccessoryAdjustment)
		SlotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.AvatarRefinement.AdjustAccessory)
	end, { v2 })

	local onActivated2 = React.useCallback(function()
		v2.navigate(AvatarScreen.BodyShape)
		SlotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.AvatarRefinement.BodyScale)
	end, { v2 })

	local onActivated3 = React.useCallback(function()
		v2.navigate(AvatarScreen.HeadRefinement)
		SlotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.AvatarRefinement.CustomizeHead)
	end, { v2 })

	local onActivated4 = React.useCallback(function()
		v2.navigate(AvatarScreen.LayeredClothingSort)
		SlotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.AvatarRefinement.ClothingLayers)
	end, { v2 })

	local onActivated5 = React.useCallback(function()
		v2.navigate(AvatarScreen.LayeredMakeupSort)
		SlotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.AvatarRefinement.MakeupLayers)
	end, { v2 })

	local onActivated6 = React.useCallback(function()
		v2.navigate(AvatarScreen.ColorAdjustment)
		SlotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.AvatarRefinement.ColorAdjustment)
	end, { v2 })
	local onActivated7, onActivated8

	if FFlagAXAvatarSharingEntryPoint then
		onActivated7 = React.useCallback(function()
			local prevNavPage

			if v2.state and v2.state.key then
				prevNavPage = v2.state.key
			end

			v2.navigate(AvatarScreen.LookComposerPage, { prevNavPage = prevNavPage })

			SlotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.SharedCommunityAvatars.ShareAvatar)
		end, { v2 })

		onActivated8 = React.useCallback(function()
			v2.navigate(AvatarScreen.MySharedAvatars)
			SlotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.SharedCommunityAvatars.MyPublishedAvatars)
		end, { v2 })
	else
		onActivated7 = nil
		onActivated8 = nil
	end

	local useCallback = React.useCallback
	local function fn()
		local key

		if v2.state and v2.state.key then
			key = v2.state.key
		end

		if FFlagEditProfileImageV2Enabled then
			local screenName = if v3 then v3.opaque.name else key

			if FFlagAXUseProfileIconEntryPoint and set[screenName] then
				local navigate = v2.navigate
				local profile = AvatarScreen.Profile
				local screenParams

				if v3 then
					screenParams = v3.opaque.params
				end

				navigate(profile, {
					entryOrigin = { screenName = screenName, screenParams = screenParams }
				})

				if FFlagMeProfileEntryTooltipEnabled and v7 then
					v7.dismiss()
				end
			elseif FFlagAXPPEReturnToEntrySurface then
				v2.navigate(AvatarScreen.EditProfileImage, {
					entryOrigin = v3 and {
						screenName = v3.opaque.name,
						screenParams = v3.opaque.params
					} or nil
				})
			else
				v2.navigate(AvatarScreen.EditProfileImage, { prevNavPage = key })
			end
		else
			local screenName = if v3 then v3.opaque.name else key
			local v9

			if FFlagAXUseProfileIconEntryPoint and set[screenName] then
				v9 = AvatarScreen.Profile
			else
				v9 = AvatarScreen.ProfilePictureEditorEmotes
			end

			local v10

			if v9 == AvatarScreen.Profile then
				v10 = { entryOrigin = 0 }
				local screenParams

				if v3 then
					screenParams = v3.opaque.params
				end

				v10.entryOrigin = { screenName = screenName, screenParams = screenParams }
			else
				v10 = FFlagAXPPEReturnToEntrySurface and {
					entryOrigin = v3 and {
						screenName = v3.opaque.name,
						screenParams = v3.opaque.params
					} or nil
				} or { prevNavPage = key }
			end

			v2.navigate(v9, v10)

			if FFlagMeProfileEntryTooltipEnabled and v7 and v9 == AvatarScreen.Profile then
				v7.dismiss()
			end
		end

		SlotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.More.ProfilePhoto)
	end

	local v9

	if FFlagAXUseProfileIconEntryPoint or FFlagAXPPEReturnToEntrySurface then
		v9 = v3
	end

	local v10

	if FFlagMeProfileEntryTooltipEnabled and v7 then
		v10 = v7.dismiss
	end

	local onActivated9 = useCallback(fn, { v2, v9, v10 })
	local onActivated10

	if FFlagAXFavoritesManagerNavEntry then
		onActivated10 = React.useCallback(function()
			v2.navigate(AvatarScreen.FavoritesSaved)
			SlotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.Main.Favorites)
		end, { v2 })
	else
		onActivated10 = nil
	end

	local v11

	if FFlagAXHideHeadAdjustmentForDefaultHead then
		v11 = useSelector(selectHasDynamicHead)
	else
		v11 = nil
	end

	local v12

	if FFlagAXResetAvatarButton then
		v12 = useUndoRedoBarViewModel()
	else
		v12 = nil
	end

	local useMemo = React.useMemo
	local function fn2()
		local v13 = {
			type = "image",
			id = MenuItemEnum.Main.AvatarSwitcher,
			thumbnailUrl = 0,
			onActivated = 0,
			visible = 0,
			hideIndicator = true,
			toolTipConfig = 0,
			enableFocusAnimation = 0
		}
		local thumbnailUrl

		if data.thumbnailUrl then
			thumbnailUrl = data.thumbnailUrl
		else
			thumbnailUrl = getRbxthumbWithTypeSizeAndOptions(
				v6,
				AvatarHeadShot,
				150,
				true,
				true,
				FFlagControlBarUseProfileFrameThumbnail
			)
		end

		v13.thumbnailUrl = thumbnailUrl

		v13.onActivated = onActivated9
		local visible

		if FFlagAXUseProfileIconEntryPoint then
			visible = not v4
		end

		v13.visible = visible
		local toolTipConfig

		if FFlagMeProfileEntryTooltipEnabled and v7 then
			toolTipConfig = {
				align = 0,
				bodyText = 0,
				open = 0,
				compact = true,
				onShown = 0,
				onDismiss = 0
			}
			local align

			if FFlagMeProfileEntryTooltipVerticalCenter then
				align = PopoverAlign.Center
			end

			toolTipConfig.align = align
			toolTipConfig.bodyText = v8.profileTooltip
			toolTipConfig.open = v7.showTooltip

			toolTipConfig.onShown = v7.onShown
			toolTipConfig.onDismiss = v7.dismiss
		end

		v13.toolTipConfig = toolTipConfig
		local enableFocusAnimation

		if data.focusAnimation then
			enableFocusAnimation = data.focusAnimation.enabled
				and data.focusAnimation.menuItemId == MenuItemEnum.Main.AvatarSwitcher
		end

		v13.enableFocusAnimation = enableFocusAnimation

		local v14 = {
			type = "icon",
			id = MenuItemEnum.Main.AvatarRefinement,
			icon = not FFlagAXMigrateBuilderIcons and "icons/menu/customize" or IconName.PersonStandingGear,
			onActivated = function()
				SlotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.Main.AvatarRefinement)
			end,
			children = 0
		}

		local v15 = {
			type = "icon",
			id = MenuItemEnum.AvatarRefinement.AdjustAccessory,
			text = v8.adjustAccessory,
			icon = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/hats_off" or IconName.HatFedora,
			iconSize = v.defaultLegacyIconSize,
			onActivated = onActivated
		}

		local v16 = {
			type = "icon",
			id = MenuItemEnum.AvatarRefinement.BodyScale,
			text = v8.bodyShape,
			icon = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/build_off" or IconName.PersonStandingDualArrowsVertical,
			iconSize = v.defaultLegacyIconSize,
			onActivated = onActivated2
		}

		local v17 = {
			type = "icon",
			id = MenuItemEnum.AvatarRefinement.CustomizeHead,
			text = v8.headAdjustment,
			icon = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/classicHead_off" or IconName.HeadBlank,
			iconSize = v.defaultLegacyIconSize,
			onActivated = onActivated3,
			visible = 0
		}
		local visible2

		if FFlagAXHideHeadAdjustmentForDefaultHead then
			visible2 = v11
		end

		v17.visible = visible2
		v14.children = {
			v15,
			v16,
			v17,
			{
				type = "icon",
				id = MenuItemEnum.AvatarRefinement.ClothingLayers,
				text = v8.clothingLayering,
				icon = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/clothing_off" or IconName.ClothesHanger,
				iconSize = v.defaultLegacyIconSize,
				onActivated = onActivated4
			},
			{
				type = "icon",
				id = MenuItemEnum.AvatarRefinement.MakeupLayers,
				text = v8.makeupLayering,
				icon = not FFlagAXMigrateBuilderIcons and "icons/menu/clothing/eyelash_off" or IconName.LipsLipstickMakeupBrush,
				iconSize = v.defaultLegacyIconSize,
				onActivated = onActivated5
			},
			v5 and {
				type = "color",
				id = MenuItemEnum.AvatarRefinement.ColorAdjustment,
				text = v8.skinColor,
				colors = { v5 },
				colorSize = v.defaultLegacyIconSize,
				onActivated = onActivated6
			} or nil
		}
		local result = {
			v13,
			v14,
			FFlagAXAvatarSharingEntryPoint and {
				type = "icon",
				id = MenuItemEnum.Main.SharedCommunityAvatars,
				icon = not FFlagAXMigrateBuilderIcons and "icons/actions/edit/add" or IconName.CirclePlus,
				onActivated = function()
					SlotBasedEditorAnalytics.trackControlBarClick(MenuItemEnum.Main.SharedCommunityAvatars)
				end,
				children = {
					{
						type = "icon",
						id = MenuItemEnum.SharedCommunityAvatars.ShareAvatar,
						text = v8.shareAvatar,
						icon = not FFlagAXMigrateBuilderIcons and "icons/common/plus_heavy" or IconName.PlusLarge,
						iconSize = v.defaultLegacyIconSize,
						onActivated = onActivated7
					},
					{
						type = "icon",
						id = MenuItemEnum.SharedCommunityAvatars.MyPublishedAvatars,
						text = v8.myPublishedAvatars,
						icon = not FFlagAXMigrateBuilderIcons and "icons/actions/friend_sort/my_profile" or IconName.Person,
						iconSize = v.defaultLegacyIconSize,
						onActivated = onActivated8
					}
				}
			} or nil
		}

		if FFlagAXFavoritesManagerNavEntry then
			table.insert(result, {
				type = "icon",
				id = MenuItemEnum.Main.Favorites,
				icon = IconName.Star,
				onActivated = onActivated10,
				isActive = false
			})
		end

		if FFlagAXResetAvatarButton and data.showUndoRedo then
			table.insert(result, { type = "divider", id = MenuItemEnum.UndoRedoDivider })

			for _, item in v12.items do
				table.insert(result, item)
			end
		end

		return result
	end

	local thumbnailUrl = data.thumbnailUrl
	local focusAnimation = data.focusAnimation
	local showUndoRedo

	if FFlagAXResetAvatarButton then
		showUndoRedo = data.showUndoRedo
	end

	local v13

	if FFlagAXResetAvatarButton then
		v13 = v12
	end

	local v14

	if FFlagAXHideHeadAdjustmentForDefaultHead then
		v14 = v11
	end

	local v15

	if FFlagAXUseProfileIconEntryPoint then
		v15 = v4
	end

	local showTooltip

	if FFlagMeProfileEntryTooltipEnabled and v7 then
		showTooltip = v7.showTooltip
	end

	local v16

	if FFlagMeProfileEntryTooltipEnabled and v3 then
		v16 = v3.opaque.name
	end

	local v17 = {
		v6,
		onActivated,
		onActivated2,
		onActivated3,
		onActivated4,
		onActivated9,
		onActivated6,
		v5,
		thumbnailUrl,
		focusAnimation,
		showUndoRedo,
		v13,
		v14,
		v15,
		showTooltip,
		v16,
		nil
	}
	local v18

	if FFlagMeProfileEntryTooltipEnabled then
		v18 = v8.profileTooltip
	end

	v17[17] = v18
	return { config = useMemo(fn2, v17) }
end

return useCustomizeControlBarProps
