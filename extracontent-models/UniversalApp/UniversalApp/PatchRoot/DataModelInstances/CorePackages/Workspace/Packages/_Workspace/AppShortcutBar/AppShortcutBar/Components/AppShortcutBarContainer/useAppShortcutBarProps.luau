local UserInputService = game:GetService("UserInputService")
local AppShortcutBar = script:FindFirstAncestor("AppShortcutBar")
local AppShortcutBarParent = AppShortcutBar.Parent
local React = require(AppShortcutBarParent.React)
local Cryo = require(AppShortcutBarParent.Cryo)
local FocusNavigationEventNameEnum = require(AppShortcutBarParent.FocusNavigationUtils).FocusNavigationEventNameEnum
local ReactFocusNavigation = require(AppShortcutBarParent.ReactFocusNavigation)

require(AppShortcutBar.Components.AppShortcutBar)

local LocalizationRoactContext = require(AppShortcutBarParent.Localization).LocalizationRoactContext
local UiMode = require(AppShortcutBarParent.RobloxAppEnums).UiMode
local Responsive = require(AppShortcutBarParent.Responsive)
local useHeldProgressByEvent = require(AppShortcutBar.Hooks.AppShortcutBarContext).useHeldProgressByEvent
local useSelector = require(AppShortcutBarParent.RoactUtils).Hooks.RoactRodux.useSelector
local useLastInputMethod = require(AppShortcutBarParent.FocusNavigationUtils).useLastInputMethod
local useUiModeInfo = require(AppShortcutBarParent.RobloxAppHooks).useUiModeInfo
local useDesignTokens = require(AppShortcutBarParent.Style).useDesignTokens
local useIsStickyShortcutBarEnabled = require(AppShortcutBar.Hooks).useIsStickyShortcutBarEnabled
local useAppPolicy = require(AppShortcutBarParent.UniversalAppPolicy).useAppPolicy
local useSignalState = require(AppShortcutBarParent.SignalsReact).useSignalState
local Display = require(AppShortcutBarParent.Display)
local SharedFlags = require(AppShortcutBarParent.SharedFlags)
local FFlagAXMigrateAvatarEditorItemCardInputBindingsToFocusNavigation = SharedFlags.FFlagAXMigrateAvatarEditorItemCardInputBindingsToFocusNavigation
local FFlagAXMigrateAvatarEditorPageInputBindings = SharedFlags.FFlagAXMigrateAvatarEditorPageInputBindings
local FFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad = SharedFlags.FFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad
local FFlagAXMigrateEmoteMenuFromRoactGamepad = SharedFlags.FFlagAXMigrateEmoteMenuFromRoactGamepad
local FFlagAXMigrateSceneGamepadHandlerInputBindings = SharedFlags.FFlagAXMigrateSceneGamepadHandlerInputBindings
local FFlagAXMigratePurchasePromptInteractiveToFocusNavigation = SharedFlags.FFlagAXMigratePurchasePromptInteractiveToFocusNavigation
local FFlagAXMigrateSortAndFiltersScreenInputBindingsToFocusNavigation = SharedFlags.FFlagAXMigrateSortAndFiltersScreenInputBindingsToFocusNavigation
local FFlagAXMigrateFormPeekViewToFocusNavigation = SharedFlags.FFlagAXMigrateFormPeekViewToFocusNavigation
local FFlagAXMigrateAdjustAccessoryViewToFocusNavigation = SharedFlags.FFlagAXMigrateAdjustAccessoryViewToFocusNavigation
local FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation = SharedFlags.FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation
local FFlagAXMigrateItemDetailsInputBindingsToFocusNavigation = SharedFlags.FFlagAXMigrateItemDetailsInputBindingsToFocusNavigation
local FFlagAXMigrateCatalogSearchToFocusNavigation = SharedFlags.FFlagAXMigrateCatalogSearchToFocusNavigation
local FFlagAXMigrateCatalogPageInputBindings = SharedFlags.FFlagAXMigrateCatalogPageInputBindings
local FFlagAXMigrateLookDetailsPeekViewToFocusNavigation = SharedFlags.FFlagAXMigrateLookDetailsPeekViewToFocusNavigation
local FFlagAXMigrateProfilePictureEditorEmotesPageToFocusNavigation = SharedFlags.FFlagAXMigrateProfilePictureEditorEmotesPageToFocusNavigation
local FFlagLuaAppEnableStickyShortcutBar = SharedFlags.FFlagLuaAppEnableStickyShortcutBar
local FFlagLuaAppResponsiveEnginePreferredInput = SharedFlags.FFlagLuaAppResponsiveEnginePreferredInput
local FFlagEnableLeftNavOnConsole = SharedFlags.FFlagEnableLeftNavOnConsole
local FFlagConnectionsToFriendsRename = SharedFlags.FFlagConnectionsToFriendsRename
local FFlagGuacStickyShortcutBarEnabled = SharedFlags.FFlagGuacStickyShortcutBarEnabled
local FFlagSocialCarouselPressXToViewProfile = SharedFlags.FFlagSocialCarouselPressXToViewProfile
local t1 = {
	[Enum.KeyCode.Thumbstick1] = {
		vertical = "rbxasset://textures/ui/Controls/DesignSystem/Thumbstick1Vertical.png",
		horizontal = "rbxasset://textures/ui/Controls/DesignSystem/Thumbstick1Horizontal.png"
	},
	[Enum.KeyCode.Thumbstick2] = {
		vertical = "rbxasset://textures/ui/Controls/DesignSystem/Thumbstick2Vertical.png",
		horizontal = "rbxasset://textures/ui/Controls/DesignSystem/Thumbstick2Horizontal.png"
	}
}
local t2 = {
	Enum.KeyCode.ButtonA,
	Enum.KeyCode.ButtonX,
	Enum.KeyCode.ButtonY,
	Enum.KeyCode.ButtonL3,
	Enum.KeyCode.ButtonR3,
	Enum.KeyCode.Thumbstick1,
	Enum.KeyCode.Thumbstick2,
	Enum.KeyCode.ButtonStart,
	Enum.KeyCode.Slash,
	Enum.KeyCode.Escape,
	Enum.KeyCode.LeftBracket,
	Enum.KeyCode.PageUp,
	Enum.KeyCode.RightBracket,
	Enum.KeyCode.PageDown
}
local t3 = {
	FocusNavigationEventNameEnum.HoldToAcceptFriendRequest,
	FocusNavigationEventNameEnum.HoldToAddFriend,
	FocusNavigationEventNameEnum.HoldToJoinEvent,
	FocusNavigationEventNameEnum.HoldToUnfollowEvent,
	FocusNavigationEventNameEnum.HoldToNotifyMe,
	FocusNavigationEventNameEnum.HoldToPlay,
	FocusNavigationEventNameEnum.HoldToJoinFriend,
	FocusNavigationEventNameEnum.Play,
	FocusNavigationEventNameEnum.Search,
	FocusNavigationEventNameEnum.SeeAll,
	FocusNavigationEventNameEnum.DisplayStatsAndInfo,
	FocusNavigationEventNameEnum.AcceptFriendRequest,
	FocusNavigationEventNameEnum.AddFriend,
	FocusNavigationEventNameEnum.IgnoreFriendRequest,
	FocusNavigationEventNameEnum.ViewProfile,
	FocusNavigationEventNameEnum.OpenQuickMenu,
	FocusNavigationEventNameEnum.NavigateBack,
	FocusNavigationEventNameEnum.ScrollUp,
	FocusNavigationEventNameEnum.ScrollDown
}

table.insert(t3, FocusNavigationEventNameEnum.Confirm)
table.insert(t3, FocusNavigationEventNameEnum.SelectItem)
table.insert(t3, FocusNavigationEventNameEnum.OpenItemDetailsPage)

if FFlagAXMigrateCatalogPageInputBindings then
	table.insert(t3, FocusNavigationEventNameEnum.ToggleTryOnManager)
end

local t4 = {
	[Enum.KeyCode.ButtonA] = true,
	[Enum.KeyCode.ButtonB] = true,
	[Enum.KeyCode.ButtonX] = true,
	[Enum.KeyCode.ButtonY] = true,
	[Enum.KeyCode.ButtonL1] = true,
	[Enum.KeyCode.ButtonL2] = true,
	[Enum.KeyCode.ButtonL3] = true,
	[Enum.KeyCode.ButtonR1] = true,
	[Enum.KeyCode.ButtonR2] = true,
	[Enum.KeyCode.ButtonR3] = true,
	[Enum.KeyCode.ButtonSelect] = true,
	[Enum.KeyCode.ButtonStart] = true,
	[Enum.KeyCode.DPadDown] = true,
	[Enum.KeyCode.DPadLeft] = true,
	[Enum.KeyCode.DPadRight] = true,
	[Enum.KeyCode.DPadUp] = true,
	[Enum.KeyCode.Thumbstick1] = true,
	[Enum.KeyCode.Thumbstick2] = true
}
local t5 = {
	[Enum.KeyCode.ButtonB] = true,
	[Enum.KeyCode.ButtonL1] = true,
	[Enum.KeyCode.ButtonR1] = true
}
local t6 = {
	[Enum.KeyCode.ButtonA] = "rbxasset://textures/ui/Controls/DesignSystem/ButtonA.png",
	[Enum.KeyCode.ButtonB] = "rbxasset://textures/ui/Controls/DesignSystem/ButtonB.png",
	[Enum.KeyCode.ButtonY] = "rbxasset://textures/ui/Controls/DesignSystem/ButtonY.png",
	[Enum.KeyCode.ButtonX] = "rbxasset://textures/ui/Controls/DesignSystem/ButtonX.png",
	[Enum.KeyCode.ButtonL3] = "rbxasset://textures/ui/Controls/DesignSystem/ButtonL3.png",
	[Enum.KeyCode.ButtonR3] = "rbxasset://textures/ui/Controls/DesignSystem/ButtonR3.png",
	[Enum.KeyCode.Thumbstick1] = "rbxasset://textures/ui/Controls/DesignSystem/Thumbstick1Directional.png",
	[Enum.KeyCode.Thumbstick2] = "rbxasset://textures/ui/Controls/DesignSystem/Thumbstick2Directional.png",
	[Enum.KeyCode.ButtonStart] = "rbxasset://textures/ui/Controls/DesignSystem/ButtonStart.png"
}
local v48 = if not FFlagLuaAppEnableStickyShortcutBar and not FFlagGuacStickyShortcutBarEnabled then nil else {
	[Enum.KeyCode.ButtonA] = UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonA)
}
local t7 = {
	[Enum.KeyCode.ButtonY] = {
		[FocusNavigationEventNameEnum.Search] = t6[Enum.KeyCode.ButtonY],
		[FocusNavigationEventNameEnum.DisplayStatsAndInfo] = t6[Enum.KeyCode.ButtonY],
		[FocusNavigationEventNameEnum.OpenLayeredClothingSortResetPrompt] = t6[Enum.KeyCode.ButtonY],
		[FocusNavigationEventNameEnum.OpenLayeredMakeupSortResetPrompt] = t6[Enum.KeyCode.ButtonY],
		[FocusNavigationEventNameEnum.SortAndFiltersReset] = if not FFlagAXMigrateSortAndFiltersScreenInputBindingsToFocusNavigation then nil else t6[Enum.KeyCode.ButtonY],
		[FocusNavigationEventNameEnum.WearAfterPurchase] = if not FFlagAXMigratePurchasePromptInteractiveToFocusNavigation then nil else t6[Enum.KeyCode.ButtonY],
		[FocusNavigationEventNameEnum.FormPeekViewReset] = if not FFlagAXMigrateFormPeekViewToFocusNavigation then nil else t6[Enum.KeyCode.ButtonY],
		[FocusNavigationEventNameEnum.AdjustAccessoryViewReset] = if not FFlagAXMigrateAdjustAccessoryViewToFocusNavigation then nil else t6[Enum.KeyCode.ButtonY],
		[FocusNavigationEventNameEnum.ManageOutfitsRename] = if not FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation then nil else t6[Enum.KeyCode.ButtonY],
		[FocusNavigationEventNameEnum.OpenItemDetailsPeekView] = if not FFlagAXMigrateItemDetailsInputBindingsToFocusNavigation then nil else t6[Enum.KeyCode.ButtonY],
		[FocusNavigationEventNameEnum.CloseItemDetailsPeekView] = if not FFlagAXMigrateItemDetailsInputBindingsToFocusNavigation then nil else t6[Enum.KeyCode.ButtonY],
		[FocusNavigationEventNameEnum.ToggleTryOn] = if not FFlagAXMigrateCatalogSearchToFocusNavigation then nil else t6[Enum.KeyCode.ButtonY],
		[FocusNavigationEventNameEnum.ToggleTryOnManager] = if not FFlagAXMigrateLookDetailsPeekViewToFocusNavigation and not FFlagAXMigrateCatalogPageInputBindings then nil else t6[Enum.KeyCode.ButtonY],
		[FocusNavigationEventNameEnum.RemoveClothingTile] = t6[Enum.KeyCode.ButtonY]
	},
	[Enum.KeyCode.ButtonX] = {
		[FocusNavigationEventNameEnum.Play] = t6[Enum.KeyCode.ButtonX],
		[FocusNavigationEventNameEnum.SeeAll] = t6[Enum.KeyCode.ButtonX],
		[FocusNavigationEventNameEnum.AcceptFriendRequest] = t6[Enum.KeyCode.ButtonX],
		[FocusNavigationEventNameEnum.AddFriend] = t6[Enum.KeyCode.ButtonX],
		[FocusNavigationEventNameEnum.OpenBuyCatalogItemPrompt] = if not FFlagAXMigrateAvatarEditorPageInputBindings and not FFlagAXMigrateCatalogSearchToFocusNavigation then nil else t6[Enum.KeyCode.ButtonX],
		[FocusNavigationEventNameEnum.OpenItemDetailsPage] = if not FFlagAXMigrateEmoteMenuFromRoactGamepad then nil else t6[Enum.KeyCode.ButtonX],
		[FocusNavigationEventNameEnum.SortAndFiltersApply] = if not FFlagAXMigrateSortAndFiltersScreenInputBindingsToFocusNavigation then nil else t6[Enum.KeyCode.ButtonX],
		[FocusNavigationEventNameEnum.SaveAsCharacter] = if not FFlagAXMigratePurchasePromptInteractiveToFocusNavigation then nil else t6[Enum.KeyCode.ButtonX],
		[FocusNavigationEventNameEnum.FormPeekViewApply] = if not FFlagAXMigrateFormPeekViewToFocusNavigation then nil else t6[Enum.KeyCode.ButtonX],
		[FocusNavigationEventNameEnum.ManageOutfitsDelete] = if not FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation then nil else t6[Enum.KeyCode.ButtonX],
		[FocusNavigationEventNameEnum.OpenItemDetailsPrompt] = if not FFlagAXMigrateItemDetailsInputBindingsToFocusNavigation then nil else t6[Enum.KeyCode.ButtonX],
		[FocusNavigationEventNameEnum.UpdateOutfit] = t6[Enum.KeyCode.ButtonX],
		[FocusNavigationEventNameEnum.IgnoreFriendRequest] = t6[Enum.KeyCode.ButtonX],
		[FocusNavigationEventNameEnum.ViewProfile] = if not FFlagSocialCarouselPressXToViewProfile then nil else t6[Enum.KeyCode.ButtonX]
	},
	[Enum.KeyCode.ButtonA] = {
		[FocusNavigationEventNameEnum.HoldToAcceptFriendRequest] = t6[Enum.KeyCode.ButtonA],
		[FocusNavigationEventNameEnum.HoldToAddFriend] = t6[Enum.KeyCode.ButtonA],
		[FocusNavigationEventNameEnum.HoldToJoinEvent] = t6[Enum.KeyCode.ButtonA],
		[FocusNavigationEventNameEnum.HoldToUnfollowEvent] = t6[Enum.KeyCode.ButtonA],
		[FocusNavigationEventNameEnum.HoldToNotifyMe] = t6[Enum.KeyCode.ButtonA],
		[FocusNavigationEventNameEnum.HoldToPlay] = t6[Enum.KeyCode.ButtonA],
		[FocusNavigationEventNameEnum.HoldToJoinFriend] = t6[Enum.KeyCode.ButtonA],
		[FocusNavigationEventNameEnum.SelectItem] = t6[Enum.KeyCode.ButtonA],
		[FocusNavigationEventNameEnum.SlotEmote] = if not FFlagAXMigrateAvatarEditorItemCardInputBindingsToFocusNavigation then nil else t6[Enum.KeyCode.ButtonA],
		[FocusNavigationEventNameEnum.UnslotEmote] = if not FFlagAXMigrateAvatarEditorItemCardInputBindingsToFocusNavigation then nil else t6[Enum.KeyCode.ButtonA],
		[FocusNavigationEventNameEnum.EquipSlotsSelectSlot] = if not FFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad then nil else t6[Enum.KeyCode.ButtonA],
		[FocusNavigationEventNameEnum.Confirm] = t6[Enum.KeyCode.ButtonA],
		[FocusNavigationEventNameEnum.SelectOutfit] = if not FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation then nil else t6[Enum.KeyCode.ButtonA],
		[FocusNavigationEventNameEnum.UnselectOutfit] = if not FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation then nil else t6[Enum.KeyCode.ButtonA],
		[FocusNavigationEventNameEnum.SelectClothingTile] = t6[Enum.KeyCode.ButtonA]
	},
	[Enum.KeyCode.ButtonB] = {
		[FocusNavigationEventNameEnum.CancelAndReset] = t6[Enum.KeyCode.ButtonB]
	},
	[Enum.KeyCode.ButtonR3] = {
		[FocusNavigationEventNameEnum.ExitAvatarFullView] = if not FFlagAXMigrateSceneGamepadHandlerInputBindings then nil else t6[Enum.KeyCode.ButtonR3],
		[FocusNavigationEventNameEnum.Fullscreen] = t6[Enum.KeyCode.ButtonR3],
		[FocusNavigationEventNameEnum.ExitFullscreen] = t6[Enum.KeyCode.ButtonR3]
	},
	[Enum.KeyCode.ButtonL3] = {
		[FocusNavigationEventNameEnum.OpenCatalogContextMenu] = if not FFlagAXMigrateAvatarEditorPageInputBindings and (not FFlagAXMigrateCatalogPageInputBindings and (not FFlagAXMigrateItemDetailsInputBindingsToFocusNavigation and not FFlagAXMigrateProfilePictureEditorEmotesPageToFocusNavigation)) then nil else t6[Enum.KeyCode.ButtonL3],
		[FocusNavigationEventNameEnum.OpenItemDetailsPage] = t6[Enum.KeyCode.ButtonL3],
		[FocusNavigationEventNameEnum.ManageOutfitsToggleMultiSelect] = if not FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation then nil else t6[Enum.KeyCode.ButtonL3],
		[FocusNavigationEventNameEnum.ManageOutfitsCancelMultiSelect] = if not FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation then nil else t6[Enum.KeyCode.ButtonL3],
		[FocusNavigationEventNameEnum.OpenEditorDetailsPage] = if not FFlagAXMigrateAvatarEditorItemCardInputBindingsToFocusNavigation then nil else t6[Enum.KeyCode.ButtonL3],
		[FocusNavigationEventNameEnum.Mute] = t6[Enum.KeyCode.ButtonL3],
		[FocusNavigationEventNameEnum.Unmute] = t6[Enum.KeyCode.ButtonL3]
	},
	[Enum.KeyCode.ButtonStart] = {
		[FocusNavigationEventNameEnum.OpenQuickMenu] = t6[Enum.KeyCode.ButtonStart]
	},
	[Enum.KeyCode.Thumbstick1] = {
		[FocusNavigationEventNameEnum.PanAvatar] = if not FFlagAXMigrateSceneGamepadHandlerInputBindings then nil else t6[Enum.KeyCode.Thumbstick1],
		[FocusNavigationEventNameEnum.MoveClothingTile] = t6[Enum.KeyCode.Thumbstick1]
	},
	[Enum.KeyCode.Thumbstick2] = {
		[FocusNavigationEventNameEnum.RotateAndZoomAvatar] = if not FFlagAXMigrateSceneGamepadHandlerInputBindings then nil else t6[Enum.KeyCode.Thumbstick2]
	}
}
local v50 = if not FFlagLuaAppEnableStickyShortcutBar and not FFlagGuacStickyShortcutBarEnabled then nil else {
	[Enum.KeyCode.ButtonA] = {
		[FocusNavigationEventNameEnum.HoldToAcceptFriendRequest] = v48[Enum.KeyCode.ButtonA],
		[FocusNavigationEventNameEnum.HoldToAddFriend] = v48[Enum.KeyCode.ButtonA],
		[FocusNavigationEventNameEnum.HoldToJoinEvent] = v48[Enum.KeyCode.ButtonA],
		[FocusNavigationEventNameEnum.HoldToUnfollowEvent] = v48[Enum.KeyCode.ButtonA],
		[FocusNavigationEventNameEnum.HoldToNotifyMe] = v48[Enum.KeyCode.ButtonA],
		[FocusNavigationEventNameEnum.HoldToPlay] = v48[Enum.KeyCode.ButtonA],
		[FocusNavigationEventNameEnum.HoldToJoinFriend] = v48[Enum.KeyCode.ButtonA]
	}
}
local t8 = {
	[FocusNavigationEventNameEnum.Fullscreen] = "Feature.ExperienceDetails.Action.FullScreen",
	[FocusNavigationEventNameEnum.ExitFullscreen] = "Feature.ExperienceDetails.Action.ExitFullScreen",
	[FocusNavigationEventNameEnum.Mute] = "Feature.ExperienceDetails.Action.Mute",
	[FocusNavigationEventNameEnum.Unmute] = "Feature.ExperienceDetails.Action.Unmute",
	[FocusNavigationEventNameEnum.Search] = "CommonUI.Features.Label.ControllerBar.Search",
	[FocusNavigationEventNameEnum.SeeAll] = "Feature.Home.ActionSeeAll",
	[FocusNavigationEventNameEnum.Play] = "Common.VisitGame.Label.Play",
	[FocusNavigationEventNameEnum.DisplayStatsAndInfo] = "Feature.GameDetails.Label.LearnMore",
	[FocusNavigationEventNameEnum.HoldToPlay] = "CommonUI.Features.Label.ControllerBar.ToPlaySuffix",
	[FocusNavigationEventNameEnum.HoldToJoinFriend] = "Feature.Profile.Action.JoinGame",
	[FocusNavigationEventNameEnum.IgnoreFriendRequest] = not FFlagConnectionsToFriendsRename and "Feature.AddFriends.Action.IgnoreConnectionRequest" or "Feature.AddFriends.Action.IgnoreFriendRequest",
	[FocusNavigationEventNameEnum.AcceptFriendRequest] = not FFlagConnectionsToFriendsRename and "CommonUI.Features.Label.AcceptConnection" or "CommonUI.Features.Label.AcceptFriend",
	[FocusNavigationEventNameEnum.AddFriend] = not FFlagConnectionsToFriendsRename and "CommonUI.Features.Label.AddConnection" or "CommonUI.Features.Label.AddFriend",
	[FocusNavigationEventNameEnum.HoldToAddFriend] = not FFlagConnectionsToFriendsRename and "CommonUI.Features.Label.AddConnection" or "CommonUI.Features.Label.AddFriend",
	[FocusNavigationEventNameEnum.HoldToAcceptFriendRequest] = not FFlagConnectionsToFriendsRename and "CommonUI.Features.Label.AcceptConnection" or "CommonUI.Features.Label.AcceptFriend",
	[FocusNavigationEventNameEnum.HoldToJoinEvent] = "Feature.VirtualEvents.JoinEvent",
	[FocusNavigationEventNameEnum.HoldToUnfollowEvent] = "Feature.VirtualEvents.UnfollowEvent",
	[FocusNavigationEventNameEnum.HoldToNotifyMe] = "Feature.VirtualEvents.NotifyMe",
	[FocusNavigationEventNameEnum.OpenQuickMenu] = "Feature.Catalog.Heading.QuickMenu",
	[FocusNavigationEventNameEnum.ScrollUp] = "Feature.Accessibility.Action.ScrollUp",
	[FocusNavigationEventNameEnum.ScrollDown] = "Feature.Accessibility.Action.ScrollDown",
	[FocusNavigationEventNameEnum.NavigateBack] = "CommonUI.Controls.Action.Back",
	[FocusNavigationEventNameEnum.OpenBuyCatalogItemPrompt] = if not FFlagAXMigrateAvatarEditorPageInputBindings and not FFlagAXMigrateCatalogSearchToFocusNavigation then nil else "Feature.Catalog.Action.Buy",
	[FocusNavigationEventNameEnum.OpenCatalogContextMenu] = if not FFlagAXMigrateAvatarEditorPageInputBindings and (not FFlagAXMigrateItemDetailsInputBindingsToFocusNavigation and not FFlagAXMigrateProfilePictureEditorEmotesPageToFocusNavigation) then nil else "Feature.Catalog.Action.ItemOptions",
	[FocusNavigationEventNameEnum.OpenItemDetailsPage] = "Feature.Catalog.Action.OpenDetails",
	[FocusNavigationEventNameEnum.SelectItem] = "Feature.Avatar.Action.Select",
	[FocusNavigationEventNameEnum.EquipSlotsSelectSlot] = if not FFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad then nil else "Feature.Avatar.Action.SelectSlot",
	[FocusNavigationEventNameEnum.SlotEmote] = if not FFlagAXMigrateAvatarEditorItemCardInputBindingsToFocusNavigation then nil else "Feature.Avatar.Action.SlotEmote",
	[FocusNavigationEventNameEnum.UnslotEmote] = if not FFlagAXMigrateAvatarEditorItemCardInputBindingsToFocusNavigation then nil else "Feature.Avatar.Action.UnslotEmote",
	[FocusNavigationEventNameEnum.OpenEditorDetailsPage] = if not FFlagAXMigrateAvatarEditorItemCardInputBindingsToFocusNavigation then nil else "Feature.Catalog.Action.OpenDetails",
	[FocusNavigationEventNameEnum.PanAvatar] = if not FFlagAXMigrateSceneGamepadHandlerInputBindings then nil else "Feature.Avatar.Action.Pan",
	[FocusNavigationEventNameEnum.RotateAndZoomAvatar] = if not FFlagAXMigrateSceneGamepadHandlerInputBindings then nil else "Feature.Avatar.Action.Rotate",
	[FocusNavigationEventNameEnum.ExitAvatarFullView] = if not FFlagAXMigrateSceneGamepadHandlerInputBindings then nil else "Feature.Avatar.Action.DefaultView",
	[FocusNavigationEventNameEnum.OpenLayeredClothingSortResetPrompt] = "CommonUI.Messages.Action.Reset",
	[FocusNavigationEventNameEnum.OpenLayeredMakeupSortResetPrompt] = "CommonUI.Messages.Action.Reset",
	[FocusNavigationEventNameEnum.SortAndFiltersApply] = if not FFlagAXMigrateSortAndFiltersScreenInputBindingsToFocusNavigation then nil else "CommonUI.Messages.Action.Apply",
	[FocusNavigationEventNameEnum.SortAndFiltersReset] = if not FFlagAXMigrateSortAndFiltersScreenInputBindingsToFocusNavigation then nil else "CommonUI.Messages.Action.Reset",
	[FocusNavigationEventNameEnum.SaveAsCharacter] = if not FFlagAXMigratePurchasePromptInteractiveToFocusNavigation then nil else "Feature.Avatar.Heading.SaveCostume",
	[FocusNavigationEventNameEnum.WearAfterPurchase] = if not FFlagAXMigratePurchasePromptInteractiveToFocusNavigation then nil else "Feature.Avatar.Heading.WearConfirmation",
	[FocusNavigationEventNameEnum.Confirm] = "CommonUI.Controls.Action.Confirm",
	[FocusNavigationEventNameEnum.FormPeekViewApply] = if not FFlagAXMigrateFormPeekViewToFocusNavigation then nil else "CommonUI.Messages.Action.Apply",
	[FocusNavigationEventNameEnum.FormPeekViewReset] = if not FFlagAXMigrateFormPeekViewToFocusNavigation then nil else "CommonUI.Messages.Action.Reset",
	[FocusNavigationEventNameEnum.AdjustAccessoryViewReset] = if not FFlagAXMigrateAdjustAccessoryViewToFocusNavigation then nil else "CommonUI.Messages.Action.Reset",
	[FocusNavigationEventNameEnum.ManageOutfitsToggleMultiSelect] = if not FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation then nil else "Feature.Avatar.Action.SelectMultipleItems",
	[FocusNavigationEventNameEnum.ManageOutfitsCancelMultiSelect] = if not FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation then nil else "Feature.Avatar.Action.CancelSelection",
	[FocusNavigationEventNameEnum.ManageOutfitsDelete] = if not FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation then nil else "Feature.Avatar.Action.Delete",
	[FocusNavigationEventNameEnum.ManageOutfitsRename] = if not FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation then nil else "Feature.Avatar.Action.Rename",
	[FocusNavigationEventNameEnum.SelectOutfit] = if not FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation then nil else "Feature.Avatar.Action.Select",
	[FocusNavigationEventNameEnum.UnselectOutfit] = if not FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation then nil else "Feature.Avatar.Action.Unselect",
	[FocusNavigationEventNameEnum.OpenItemDetailsPeekView] = if not FFlagAXMigrateItemDetailsInputBindingsToFocusNavigation then nil else "Feature.Catalog.Action.OpenDetails",
	[FocusNavigationEventNameEnum.CloseItemDetailsPeekView] = if not FFlagAXMigrateItemDetailsInputBindingsToFocusNavigation then nil else "Feature.Catalog.Action.CloseDetails",
	[FocusNavigationEventNameEnum.OpenItemDetailsPrompt] = if not FFlagAXMigrateItemDetailsInputBindingsToFocusNavigation then nil else "Feature.Catalog.Action.Buy",
	[FocusNavigationEventNameEnum.ToggleTryOn] = if not FFlagAXMigrateCatalogSearchToFocusNavigation then nil else "Feature.Catalog.Label.TryOns",
	[FocusNavigationEventNameEnum.UpdateOutfit] = "Feature.Avatar.Action.Update",
	[FocusNavigationEventNameEnum.ToggleTryOnManager] = if not FFlagAXMigrateLookDetailsPeekViewToFocusNavigation and not FFlagAXMigrateCatalogPageInputBindings then nil else "Feature.Catalog.Label.TryOns",
	[FocusNavigationEventNameEnum.SelectClothingTile] = "Feature.Avatar.Action.Select",
	[FocusNavigationEventNameEnum.MoveClothingTile] = "Feature.Avatar.Title.Move",
	[FocusNavigationEventNameEnum.RemoveClothingTile] = "Feature.Catalog.Action.Remove",
	[FocusNavigationEventNameEnum.CancelAndReset] = "Feature.Catalog.Action.Cancel",
	[FocusNavigationEventNameEnum.ViewProfile] = if not FFlagSocialCarouselPressXToViewProfile then nil else "Feature.Profile.Action.ViewProfile"
}
local t9 = {
	[FocusNavigationEventNameEnum.HoldToPlay] = "Common.VisitGame.Label.Play",
	[FocusNavigationEventNameEnum.HoldToJoinFriend] = "Feature.Profile.Action.JoinGame"
}
local t10 = {
	[FocusNavigationEventNameEnum.HoldToPlay] = "CommonUI.Features.Label.ControllerBar.HoldPrefix"
}
local t11 = {
	[FocusNavigationEventNameEnum.HoldToAcceptFriendRequest] = true,
	[FocusNavigationEventNameEnum.HoldToAddFriend] = true,
	[FocusNavigationEventNameEnum.HoldToJoinEvent] = true,
	[FocusNavigationEventNameEnum.HoldToUnfollowEvent] = true,
	[FocusNavigationEventNameEnum.HoldToNotifyMe] = true,
	[FocusNavigationEventNameEnum.HoldToPlay] = true,
	[FocusNavigationEventNameEnum.HoldToJoinFriend] = true
}

local function getLegacyInputBindings(p1, p2, p3) -- line: 480
	-- upvalues: t1 (copy), t6 (copy)
	if p2.axes then
		local vertical = p2.axes.vertical
		local horizontal = p2.axes.horizontal
		local v66 = t1[p1]
		local t12 = {}

		if vertical then
			table.insert(t12, {
				icon = v66.vertical,
				text = p3:Format(vertical.key)
			})
		end

		if horizontal then
			table.insert(t12, {
				icon = v66.horizontal,
				text = p3:Format(horizontal.key)
			})
		end

		return t12
	end

	if p2.key then
		return {{
			icon = t6[p1],
			text = p3:Format(p2.key)
		}}
	end

	return {}
end
local function selectRoactGamepadBindings(p4) -- line: 513
	if p4.GamepadBottomBar then
		return p4.GamepadBottomBar.boundInputs
	end

	return nil
end
local function getGamepadItems(p5, p6, p7, p8, p9) -- line: 517
	-- upvalues: t2 (copy), t4 (copy), t5 (copy), getLegacyInputBindings (copy), t7 (copy), FFlagLuaAppEnableStickyShortcutBar (copy), FFlagGuacStickyShortcutBarEnabled (copy), v50 (copy), t9 (copy), t8 (copy), t10 (copy), t11 (copy), FocusNavigationEventNameEnum (copy), t6 (copy)
	local t13 = {}

	for _, v76 in t2 do
		if not t4[v76] or p8 and t5[v76] then
			continue
		end

		if p8 then
			if t5[v76] then
				continue
			end

			local v77 = p8[v76]

			if v77 then
				for _, v79 in (getLegacyInputBindings(v76, v77, p7)) do
					table.insert(t13, v79)
				end
			end
		end

		local v80 = p5[v76]

		if v80 then
			local v81 = t7[v76]
			local v82 = if not FFlagLuaAppEnableStickyShortcutBar and not FFlagGuacStickyShortcutBarEnabled or not p9 then nil else v50[v76]
			local v83 = if not FFlagLuaAppEnableStickyShortcutBar and not FFlagGuacStickyShortcutBarEnabled or (not p9 or not v81) then nil else v81[v80]
			local v84 = if not FFlagLuaAppEnableStickyShortcutBar and not FFlagGuacStickyShortcutBarEnabled or (not p9 or not v82) then nil else v82[v80]
			local v85 = if not FFlagLuaAppEnableStickyShortcutBar and not FFlagGuacStickyShortcutBarEnabled or not p9 then if not v81 then nil else v81[v80] else v84 or v83
			local v86 = if not FFlagLuaAppEnableStickyShortcutBar and not FFlagGuacStickyShortcutBarEnabled or not p9 then nil else t9[v80]
			local v87 = t8[v80]
			local v88 = if not FFlagLuaAppEnableStickyShortcutBar and not FFlagGuacStickyShortcutBarEnabled or not p9 then t8[v80] else v86 or v87
			local v89 = if not v88 then nil else p7:Format(v88)
			local v90 = t10[v80]
			local v91 = if not v90 then nil else p7:Format(v90)
			local v92 = p6[v80]
			local v93 = t11[v80]

			if v85 and v89 then
				table.insert(t13, {
					icon = v85,
					text = v89,
					actionText = if not FFlagLuaAppEnableStickyShortcutBar and not FFlagGuacStickyShortcutBarEnabled or not p9 then v91 else nil,
					progress = v92,
					hasProgress = v93,
					inputKeyCode = if not FFlagLuaAppEnableStickyShortcutBar and not FFlagGuacStickyShortcutBarEnabled or not p9 then nil else v76,
					eventName = if not FFlagLuaAppEnableStickyShortcutBar and not FFlagGuacStickyShortcutBarEnabled or not p9 then nil else v80
				})
			end
		end
	end

	if (FFlagLuaAppEnableStickyShortcutBar or FFlagGuacStickyShortcutBarEnabled) and p9 then
		local v94 = p5[Enum.KeyCode.ButtonB]

		if v94 == FocusNavigationEventNameEnum.NavigateBack then
			table.insert(t13, {
				icon = t6[Enum.KeyCode.ButtonB],
				text = p7:Format(t8[v94]),
				inputKeyCode = Enum.KeyCode.ButtonB,
				eventName = v94
			})
		end
	end

	return t13
end
local function getKeyboardItems(p10, p11, p12, p13) -- line: 621
	-- upvalues: t4 (copy), t3 (copy), t8 (copy), t10 (copy), t11 (copy), FFlagLuaAppEnableStickyShortcutBar (copy), FFlagGuacStickyShortcutBarEnabled (copy)
	local t14 = {}
	local t15 = {}

	for v101, v102 in p10 do
		if not t4[v101] then
			if typeof(t15[v102]) == "table" then
				table.insert(t15[v102], v101)
			else
				t15[v102] = { v101 }
			end
		end
	end

	for _, v104 in t3 do
		local v105 = t15[v104]

		if v105 then
			local v106 = t8[v104]
			local v107 = if not v106 then nil else p12:Format(v106)
			local v108 = t10[v104]
			local v109 = if not v108 then nil else p12:Format(v108)
			local v110 = p11[v104]
			local v111 = t11[v104]

			if v107 then
				table.insert(t14, {
					icon = v105,
					text = v107,
					actionText = if not FFlagLuaAppEnableStickyShortcutBar and not FFlagGuacStickyShortcutBarEnabled or not p13 then v109 else nil,
					progress = v110,
					hasProgress = v111,
					inputKeyCode = if not FFlagLuaAppEnableStickyShortcutBar and not FFlagGuacStickyShortcutBarEnabled or not p13 then nil else v105[1],
					eventName = if not FFlagLuaAppEnableStickyShortcutBar and not FFlagGuacStickyShortcutBarEnabled or not p13 then nil else v104
				})
			end
		end
	end

	return t14
end
local function useShortcutBarFrameProps() -- line: 675
	-- upvalues: useUiModeInfo (copy), useDesignTokens (copy), UiMode (copy), FFlagEnableLeftNavOnConsole (copy), useSignalState (copy), Display (copy)
	local v112 = useUiModeInfo()
	local v113 = if not v112 then nil else v112.uiMode
	local v114 = useDesignTokens()

	if v113 == UiMode.TenFoot and not FFlagEnableLeftNavOnConsole then
		return {}
	end

	local v115 = if not FFlagEnableLeftNavOnConsole then nil else useSignalState(Display.GetDisplayStore().getDeviceSafePadding)

	return {
		Position = UDim2.new(0.5, 0, 1, not v114 and 0 or -v114.Size.Size_200 + (not FFlagEnableLeftNavOnConsole and 0 or v115.bottom)),
		AnchorPoint = Vector2.new(0.5, 1)
	}
end
local function useShortcutBarItems() -- line: 705
	-- upvalues: ReactFocusNavigation (copy), React (copy), LocalizationRoactContext (copy), useHeldProgressByEvent (copy), useLastInputMethod (copy), FFlagLuaAppResponsiveEnginePreferredInput (copy), Responsive (copy), useSelector (copy), selectRoactGamepadBindings (copy), FFlagGuacStickyShortcutBarEnabled (copy), useAppPolicy (copy), FFlagLuaAppEnableStickyShortcutBar (copy), useIsStickyShortcutBarEnabled (copy), getGamepadItems (copy), getKeyboardItems (copy)
	local v116 = ReactFocusNavigation.useActiveEventMap()
	local v117 = React.useContext(LocalizationRoactContext)
	local v118 = useHeldProgressByEvent()
	local v119 = useLastInputMethod()
	local v120 = if not FFlagLuaAppResponsiveEnginePreferredInput then nil else Responsive.usePreferredInput()
	local v121 = useSelector(selectRoactGamepadBindings)
	local v122 = if not FFlagGuacStickyShortcutBarEnabled then if not FFlagLuaAppEnableStickyShortcutBar then nil else useIsStickyShortcutBarEnabled() else useAppPolicy(function(p14) -- line: 717
		return p14.getStickyShortcutBarEnabled()
	end)

	if if not FFlagLuaAppResponsiveEnginePreferredInput then v119 == "Gamepad" else v120 == Responsive.Input.Directional then
		return (getGamepadItems(v116, v118, v117, v121, if not FFlagLuaAppEnableStickyShortcutBar and not FFlagGuacStickyShortcutBarEnabled then nil else v122))
	end

	return (getKeyboardItems(v116, v118, v117, if not FFlagLuaAppEnableStickyShortcutBar and not FFlagGuacStickyShortcutBarEnabled then nil else v122))
end

function useAppShortcutBarProps() -- line: 752
	-- upvalues: useShortcutBarFrameProps (copy), useShortcutBarItems (copy), Cryo (copy)
	local v123 = useShortcutBarFrameProps()
	local v124 = useShortcutBarItems()

	return Cryo.Dictionary.union(v123, {
		items = v124
	})
end

return useAppShortcutBarProps
