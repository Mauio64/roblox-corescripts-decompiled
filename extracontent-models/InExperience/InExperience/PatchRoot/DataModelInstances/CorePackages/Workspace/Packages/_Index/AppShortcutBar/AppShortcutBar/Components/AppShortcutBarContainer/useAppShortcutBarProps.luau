local UserInputService = game:GetService("UserInputService")

local AppShortcutBar = script:FindFirstAncestor("AppShortcutBar")
local parent = AppShortcutBar.Parent
local React = require(parent.React)
local Cryo = require(parent.Cryo)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
require(AppShortcutBar.Components.AppShortcutBar)
local Localization = require(parent.Localization)
local LocalizationRoactContext = Localization.LocalizationRoactContext
local Responsive = require(parent.Responsive)

local AppShortcutBarContext = require(AppShortcutBar.Hooks.AppShortcutBarContext)
local useHeldProgressByEvent = AppShortcutBarContext.useHeldProgressByEvent
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local FocusNavigationUtils2 = require(parent.FocusNavigationUtils)
local useLastInputMethod = FocusNavigationUtils2.useLastInputMethod
local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local RoactUtils2 = require(parent.RoactUtils)
local useIsTvRemoteDevice = RoactUtils2.Hooks.useIsTvRemoteDevice
local RoactUtils3 = require(parent.RoactUtils)
local useIsRealGamepadConnected = RoactUtils3.Hooks.useIsRealGamepadConnected
local RoactUtils4 = require(parent.RoactUtils)
local useExternalEvent = RoactUtils4.Hooks.useExternalEvent
local Display = require(parent.Display)

local defineFastFlag = game:DefineFastFlag("NoShortcutBarWithTvRemote", false)
local Flags = require(AppShortcutBar.Flags)
local FFlagStickyShortcutBarTvRemoteWithGamepad = Flags.FFlagStickyShortcutBarTvRemoteWithGamepad
local Flags2 = require(AppShortcutBar.Flags)
local FFlagShortcutBarPlatformGamepadIcons = Flags2.FFlagShortcutBarPlatformGamepadIcons

local SharedFlags = require(parent.SharedFlags)

local FFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad = SharedFlags.FFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad
local FFlagAXMigrateEmoteMenuFromRoactGamepad = SharedFlags.FFlagAXMigrateEmoteMenuFromRoactGamepad

local FFlagAXMigrateAdjustAccessoryViewToFocusNavigation = SharedFlags.FFlagAXMigrateAdjustAccessoryViewToFocusNavigation

local FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation = SharedFlags.FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation
local FFlagLuaAppResponsiveEnginePreferredInput = SharedFlags.FFlagLuaAppResponsiveEnginePreferredInput
local FFlagLuaAppMediaGalleryGamepadSupport = SharedFlags.FFlagLuaAppMediaGalleryGamepadSupport
local FFlagEnableStickyShortcutBarOnAllPlatforms = SharedFlags.FFlagEnableStickyShortcutBarOnAllPlatforms
local FFlagEnableSplitPane = SharedFlags.FFlagEnableSplitPane

local v = {
	[Enum.KeyCode.Thumbstick1] = {
		vertical = "rbxasset://textures/ui/Controls/DesignSystem/Thumbstick1Vertical.png",
		horizontal = "rbxasset://textures/ui/Controls/DesignSystem/Thumbstick1Horizontal.png"
	},
	[Enum.KeyCode.Thumbstick2] = {
		vertical = "rbxasset://textures/ui/Controls/DesignSystem/Thumbstick2Vertical.png",
		horizontal = "rbxasset://textures/ui/Controls/DesignSystem/Thumbstick2Horizontal.png"
	}
}

local v2 = {
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

local v3 = {
	FocusNavigationEventNameEnum.HoldToAcceptTrustedFriendRequest,
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
	FocusNavigationEventNameEnum.IgnoreTrustedFriendRequest,
	FocusNavigationEventNameEnum.IgnoreFriendRequest,
	FocusNavigationEventNameEnum.ViewProfile,
	FocusNavigationEventNameEnum.OpenQuickMenu,
	FocusNavigationEventNameEnum.NavigateBack,
	FocusNavigationEventNameEnum.ScrollUp,
	FocusNavigationEventNameEnum.ScrollDown
}

table.insert(v3, FocusNavigationEventNameEnum.Confirm)
table.insert(v3, FocusNavigationEventNameEnum.SelectItem)
table.insert(v3, FocusNavigationEventNameEnum.OpenItemDetailsPage)
table.insert(v3, FocusNavigationEventNameEnum.ToggleTryOnManager)

if FFlagEnableSplitPane then
	table.insert(v3, FocusNavigationEventNameEnum.CollapseAvatar)
	table.insert(v3, FocusNavigationEventNameEnum.ExpandAvatar)
end

local set = {
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

local set2 = {
	[Enum.KeyCode.ButtonB] = true,
	[Enum.KeyCode.ButtonL1] = true,
	[Enum.KeyCode.ButtonR1] = true
}

local v4 = {
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

local imageForKeyCodesByButtonA = {
	[Enum.KeyCode.ButtonA] = UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonA)
}

local v5 = {}
local ButtonY = Enum.KeyCode.ButtonY
local v6 = {
	[FocusNavigationEventNameEnum.Search] = v4[Enum.KeyCode.ButtonY],
	[FocusNavigationEventNameEnum.DisplayStatsAndInfo] = v4[Enum.KeyCode.ButtonY],
	[FocusNavigationEventNameEnum.OpenLayeredClothingSortResetPrompt] = v4[Enum.KeyCode.ButtonY],
	[FocusNavigationEventNameEnum.OpenLayeredMakeupSortResetPrompt] = v4[Enum.KeyCode.ButtonY],
	[FocusNavigationEventNameEnum.SortAndFiltersReset] = v4[Enum.KeyCode.ButtonY],
	[FocusNavigationEventNameEnum.WearAfterPurchase] = v4[Enum.KeyCode.ButtonY],
	[FocusNavigationEventNameEnum.FormPeekViewReset] = v4[Enum.KeyCode.ButtonY]
}
local AdjustAccessoryViewReset = FocusNavigationEventNameEnum.AdjustAccessoryViewReset
local v7

if FFlagAXMigrateAdjustAccessoryViewToFocusNavigation then
	v7 = v4[Enum.KeyCode.ButtonY]
end

v6[AdjustAccessoryViewReset] = v7

local ManageOutfitsRename = FocusNavigationEventNameEnum.ManageOutfitsRename
local v8

if FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation then
	v8 = v4[Enum.KeyCode.ButtonY]
end

v6[ManageOutfitsRename] = v8

v6[FocusNavigationEventNameEnum.OpenItemDetailsPeekView] = v4[Enum.KeyCode.ButtonY]
v6[FocusNavigationEventNameEnum.CloseItemDetailsPeekView] = v4[Enum.KeyCode.ButtonY]
v6[FocusNavigationEventNameEnum.ToggleTryOn] = v4[Enum.KeyCode.ButtonY]
v6[FocusNavigationEventNameEnum.ToggleTryOnManager] = v4[Enum.KeyCode.ButtonY]
v6[FocusNavigationEventNameEnum.RemoveClothingTile] = v4[Enum.KeyCode.ButtonY]
v5[ButtonY] = v6

local ButtonX = Enum.KeyCode.ButtonX
local v9 = {
	[FocusNavigationEventNameEnum.Play] = v4[Enum.KeyCode.ButtonX],
	[FocusNavigationEventNameEnum.SeeAll] = v4[Enum.KeyCode.ButtonX],
	[FocusNavigationEventNameEnum.AcceptFriendRequest] = v4[Enum.KeyCode.ButtonX],
	[FocusNavigationEventNameEnum.AddFriend] = v4[Enum.KeyCode.ButtonX],
	[FocusNavigationEventNameEnum.OpenBuyCatalogItemPrompt] = v4[Enum.KeyCode.ButtonX]
}
local OpenItemDetailsPage = FocusNavigationEventNameEnum.OpenItemDetailsPage
local v10

if FFlagAXMigrateEmoteMenuFromRoactGamepad then
	v10 = v4[Enum.KeyCode.ButtonX]
end

v9[OpenItemDetailsPage] = v10

v9[FocusNavigationEventNameEnum.SortAndFiltersApply] = v4[Enum.KeyCode.ButtonX]
v9[FocusNavigationEventNameEnum.SaveAsCharacter] = v4[Enum.KeyCode.ButtonX]
v9[FocusNavigationEventNameEnum.FormPeekViewApply] = v4[Enum.KeyCode.ButtonX]
local ManageOutfitsDelete = FocusNavigationEventNameEnum.ManageOutfitsDelete
local v11

if FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation then
	v11 = v4[Enum.KeyCode.ButtonX]
end

v9[ManageOutfitsDelete] = v11

v9[FocusNavigationEventNameEnum.OpenItemDetailsPrompt] = v4[Enum.KeyCode.ButtonX]
v9[FocusNavigationEventNameEnum.UpdateOutfit] = v4[Enum.KeyCode.ButtonX]
v9[FocusNavigationEventNameEnum.IgnoreTrustedFriendRequest] = v4[Enum.KeyCode.ButtonX]
v9[FocusNavigationEventNameEnum.IgnoreFriendRequest] = v4[Enum.KeyCode.ButtonX]
v9[FocusNavigationEventNameEnum.ViewProfile] = v4[Enum.KeyCode.ButtonX]
v5[ButtonX] = v9

local ButtonA = Enum.KeyCode.ButtonA
local PlayVideo = FocusNavigationEventNameEnum.PlayVideo
local v13

if FFlagLuaAppMediaGalleryGamepadSupport then
	v13 = v4[Enum.KeyCode.ButtonA]
end

local v12 = { [PlayVideo] = v13 }

local PauseVideo = FocusNavigationEventNameEnum.PauseVideo
local v14

if FFlagLuaAppMediaGalleryGamepadSupport then
	v14 = v4[Enum.KeyCode.ButtonA]
end

v12[PauseVideo] = v14

v12[FocusNavigationEventNameEnum.HoldToAcceptTrustedFriendRequest] = v4[Enum.KeyCode.ButtonA]
v12[FocusNavigationEventNameEnum.HoldToAcceptFriendRequest] = v4[Enum.KeyCode.ButtonA]
v12[FocusNavigationEventNameEnum.HoldToAddFriend] = v4[Enum.KeyCode.ButtonA]
v12[FocusNavigationEventNameEnum.HoldToJoinEvent] = v4[Enum.KeyCode.ButtonA]
v12[FocusNavigationEventNameEnum.HoldToUnfollowEvent] = v4[Enum.KeyCode.ButtonA]
v12[FocusNavigationEventNameEnum.HoldToNotifyMe] = v4[Enum.KeyCode.ButtonA]
v12[FocusNavigationEventNameEnum.HoldToPlay] = v4[Enum.KeyCode.ButtonA]
v12[FocusNavigationEventNameEnum.HoldToJoinFriend] = v4[Enum.KeyCode.ButtonA]
v12[FocusNavigationEventNameEnum.SelectItem] = v4[Enum.KeyCode.ButtonA]
v12[FocusNavigationEventNameEnum.SlotEmote] = v4[Enum.KeyCode.ButtonA]
v12[FocusNavigationEventNameEnum.UnslotEmote] = v4[Enum.KeyCode.ButtonA]
local EquipSlotsSelectSlot = FocusNavigationEventNameEnum.EquipSlotsSelectSlot
local v15

if FFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad then
	v15 = v4[Enum.KeyCode.ButtonA]
end

v12[EquipSlotsSelectSlot] = v15

v12[FocusNavigationEventNameEnum.Confirm] = v4[Enum.KeyCode.ButtonA]
local SelectOutfit = FocusNavigationEventNameEnum.SelectOutfit
local v16

if FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation then
	v16 = v4[Enum.KeyCode.ButtonA]
end

v12[SelectOutfit] = v16

local UnselectOutfit = FocusNavigationEventNameEnum.UnselectOutfit
local v17

if FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation then
	v17 = v4[Enum.KeyCode.ButtonA]
end

v12[UnselectOutfit] = v17

v12[FocusNavigationEventNameEnum.SelectClothingTile] = v4[Enum.KeyCode.ButtonA]
v5[ButtonA] = v12

local ButtonB = Enum.KeyCode.ButtonB
v5[ButtonB] = { [FocusNavigationEventNameEnum.CancelAndReset] = v4[Enum.KeyCode.ButtonB] }

local ButtonR3 = Enum.KeyCode.ButtonR3
local v18 = {
	[FocusNavigationEventNameEnum.ExitAvatarFullView] = v4[Enum.KeyCode.ButtonR3],
	[FocusNavigationEventNameEnum.Fullscreen] = v4[Enum.KeyCode.ButtonR3],
	[FocusNavigationEventNameEnum.ExitFullscreen] = v4[Enum.KeyCode.ButtonR3]
}
local CollapseAvatar = FocusNavigationEventNameEnum.CollapseAvatar
local v19

if FFlagEnableSplitPane then
	v19 = v4[Enum.KeyCode.ButtonR3]
end

v18[CollapseAvatar] = v19

local ExpandAvatar = FocusNavigationEventNameEnum.ExpandAvatar
local v20

if FFlagEnableSplitPane then
	v20 = v4[Enum.KeyCode.ButtonR3]
end

v18[ExpandAvatar] = v20
v5[ButtonR3] = v18

local ButtonL3 = Enum.KeyCode.ButtonL3
local v21 = {
	[FocusNavigationEventNameEnum.OpenCatalogContextMenu] = v4[Enum.KeyCode.ButtonL3],
	[FocusNavigationEventNameEnum.OpenItemDetailsPage] = v4[Enum.KeyCode.ButtonL3]
}
local ManageOutfitsToggleMultiSelect = FocusNavigationEventNameEnum.ManageOutfitsToggleMultiSelect
local v22

if FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation then
	v22 = v4[Enum.KeyCode.ButtonL3]
end

v21[ManageOutfitsToggleMultiSelect] = v22

local ManageOutfitsCancelMultiSelect = FocusNavigationEventNameEnum.ManageOutfitsCancelMultiSelect
local v23

if FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation then
	v23 = v4[Enum.KeyCode.ButtonL3]
end

v21[ManageOutfitsCancelMultiSelect] = v23

v21[FocusNavigationEventNameEnum.OpenEditorDetailsPage] = v4[Enum.KeyCode.ButtonL3]
v21[FocusNavigationEventNameEnum.Mute] = v4[Enum.KeyCode.ButtonL3]
v21[FocusNavigationEventNameEnum.Unmute] = v4[Enum.KeyCode.ButtonL3]
v5[ButtonL3] = v21

local ButtonStart = Enum.KeyCode.ButtonStart
v5[ButtonStart] = { [FocusNavigationEventNameEnum.OpenQuickMenu] = v4[Enum.KeyCode.ButtonStart] }

local Thumbstick1 = Enum.KeyCode.Thumbstick1
v5[Thumbstick1] = {
	[FocusNavigationEventNameEnum.PanAvatar] = v4[Enum.KeyCode.Thumbstick1],
	[FocusNavigationEventNameEnum.MoveClothingTile] = v4[Enum.KeyCode.Thumbstick1]
}

local Thumbstick2 = Enum.KeyCode.Thumbstick2
v5[Thumbstick2] = {
	[FocusNavigationEventNameEnum.RotateAndZoomAvatar] = v4[Enum.KeyCode.Thumbstick2]
}

local v24 = {}
local buttonA = Enum.KeyCode.ButtonA
v24[buttonA] = {
	[FocusNavigationEventNameEnum.HoldToAcceptTrustedFriendRequest] = imageForKeyCodesByButtonA[Enum.KeyCode.ButtonA],
	[FocusNavigationEventNameEnum.HoldToAcceptFriendRequest] = imageForKeyCodesByButtonA[Enum.KeyCode.ButtonA],
	[FocusNavigationEventNameEnum.HoldToAddFriend] = imageForKeyCodesByButtonA[Enum.KeyCode.ButtonA],
	[FocusNavigationEventNameEnum.HoldToJoinEvent] = imageForKeyCodesByButtonA[Enum.KeyCode.ButtonA],
	[FocusNavigationEventNameEnum.HoldToUnfollowEvent] = imageForKeyCodesByButtonA[Enum.KeyCode.ButtonA],
	[FocusNavigationEventNameEnum.HoldToNotifyMe] = imageForKeyCodesByButtonA[Enum.KeyCode.ButtonA],
	[FocusNavigationEventNameEnum.HoldToPlay] = imageForKeyCodesByButtonA[Enum.KeyCode.ButtonA],
	[FocusNavigationEventNameEnum.HoldToJoinFriend] = imageForKeyCodesByButtonA[Enum.KeyCode.ButtonA]
}

local v25 = {
	[FocusNavigationEventNameEnum.Fullscreen] = "Feature.ExperienceDetails.Action.FullScreen",
	[FocusNavigationEventNameEnum.ExitFullscreen] = "Feature.ExperienceDetails.Action.ExitFullScreen",
	[FocusNavigationEventNameEnum.Mute] = "Feature.ExperienceDetails.Action.Mute",
	[FocusNavigationEventNameEnum.Unmute] = "Feature.ExperienceDetails.Action.Unmute",
	[FocusNavigationEventNameEnum.PlayVideo] = FFlagLuaAppMediaGalleryGamepadSupport and "Feature.GameDetails.Action.PlayVideo" or nil,
	[FocusNavigationEventNameEnum.PauseVideo] = FFlagLuaAppMediaGalleryGamepadSupport and "Feature.GameDetails.Action.PauseVideo" or nil,
	[FocusNavigationEventNameEnum.Search] = "CommonUI.Features.Label.ControllerBar.Search",
	[FocusNavigationEventNameEnum.SeeAll] = "Feature.Home.ActionSeeAll",
	[FocusNavigationEventNameEnum.Play] = "Common.VisitGame.Label.Play",
	[FocusNavigationEventNameEnum.DisplayStatsAndInfo] = "Feature.GameDetails.Label.LearnMore",
	[FocusNavigationEventNameEnum.HoldToPlay] = "CommonUI.Features.Label.ControllerBar.ToPlaySuffix",
	[FocusNavigationEventNameEnum.HoldToJoinFriend] = "Feature.Profile.Action.JoinGame",
	[FocusNavigationEventNameEnum.IgnoreTrustedFriendRequest] = "Feature.AddFriends.Action.IgnoreTrustedFriendRequest",
	[FocusNavigationEventNameEnum.IgnoreFriendRequest] = "Feature.AddFriends.Action.IgnoreFriendRequest",
	[FocusNavigationEventNameEnum.AcceptFriendRequest] = "CommonUI.Features.Label.AcceptFriend",
	[FocusNavigationEventNameEnum.AddFriend] = "CommonUI.Features.Label.AddFriend",
	[FocusNavigationEventNameEnum.HoldToAddFriend] = "CommonUI.Features.Label.AddFriend",
	[FocusNavigationEventNameEnum.HoldToAcceptFriendRequest] = "CommonUI.Features.Label.AcceptFriend",
	[FocusNavigationEventNameEnum.HoldToAcceptTrustedFriendRequest] = "Feature.Friends.TrustedFriend.AcceptTrustedRequest",
	[FocusNavigationEventNameEnum.HoldToJoinEvent] = "Feature.VirtualEvents.JoinEvent",
	[FocusNavigationEventNameEnum.HoldToUnfollowEvent] = "Feature.VirtualEvents.UnfollowEvent",
	[FocusNavigationEventNameEnum.HoldToNotifyMe] = "Feature.VirtualEvents.NotifyMe",
	[FocusNavigationEventNameEnum.OpenQuickMenu] = "Feature.Catalog.Heading.QuickMenu",
	[FocusNavigationEventNameEnum.ScrollUp] = "Feature.Accessibility.Action.ScrollUp",
	[FocusNavigationEventNameEnum.ScrollDown] = "Feature.Accessibility.Action.ScrollDown",
	[FocusNavigationEventNameEnum.NavigateBack] = "CommonUI.Controls.Action.Back",
	[FocusNavigationEventNameEnum.OpenBuyCatalogItemPrompt] = "Feature.Catalog.Action.Buy",
	[FocusNavigationEventNameEnum.OpenCatalogContextMenu] = "Feature.Catalog.Action.ItemOptions",
	[FocusNavigationEventNameEnum.OpenItemDetailsPage] = "Feature.Catalog.Action.OpenDetails",
	[FocusNavigationEventNameEnum.SelectItem] = "Feature.Avatar.Action.Select",
	[FocusNavigationEventNameEnum.EquipSlotsSelectSlot] = FFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad and "Feature.Avatar.Action.SelectSlot" or nil,
	[FocusNavigationEventNameEnum.SlotEmote] = "Feature.Avatar.Action.SlotEmote",
	[FocusNavigationEventNameEnum.UnslotEmote] = "Feature.Avatar.Action.UnslotEmote",
	[FocusNavigationEventNameEnum.OpenEditorDetailsPage] = "Feature.Catalog.Action.OpenDetails",
	[FocusNavigationEventNameEnum.PanAvatar] = "Feature.Avatar.Action.Pan",
	[FocusNavigationEventNameEnum.RotateAndZoomAvatar] = "Feature.Avatar.Action.Rotate",
	[FocusNavigationEventNameEnum.ExitAvatarFullView] = "Feature.Avatar.Action.DefaultView",
	[FocusNavigationEventNameEnum.OpenLayeredClothingSortResetPrompt] = "CommonUI.Messages.Action.Reset",
	[FocusNavigationEventNameEnum.OpenLayeredMakeupSortResetPrompt] = "CommonUI.Messages.Action.Reset",
	[FocusNavigationEventNameEnum.SortAndFiltersApply] = "CommonUI.Messages.Action.Apply",
	[FocusNavigationEventNameEnum.SortAndFiltersReset] = "CommonUI.Messages.Action.Reset",
	[FocusNavigationEventNameEnum.SaveAsCharacter] = "Feature.Avatar.Heading.SaveCostume",
	[FocusNavigationEventNameEnum.WearAfterPurchase] = "Feature.Avatar.Heading.WearConfirmation",
	[FocusNavigationEventNameEnum.Confirm] = "CommonUI.Controls.Action.Confirm",
	[FocusNavigationEventNameEnum.FormPeekViewApply] = "CommonUI.Messages.Action.Apply",
	[FocusNavigationEventNameEnum.FormPeekViewReset] = "CommonUI.Messages.Action.Reset",
	[FocusNavigationEventNameEnum.AdjustAccessoryViewReset] = FFlagAXMigrateAdjustAccessoryViewToFocusNavigation and "CommonUI.Messages.Action.Reset" or nil,
	[FocusNavigationEventNameEnum.ManageOutfitsToggleMultiSelect] = FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation and "Feature.Avatar.Action.SelectMultipleItems" or nil,
	[FocusNavigationEventNameEnum.ManageOutfitsCancelMultiSelect] = FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation and "Feature.Avatar.Action.CancelSelection" or nil,
	[FocusNavigationEventNameEnum.ManageOutfitsDelete] = FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation and "Feature.Avatar.Action.Delete" or nil,
	[FocusNavigationEventNameEnum.ManageOutfitsRename] = FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation and "Feature.Avatar.Action.Rename" or nil,
	[FocusNavigationEventNameEnum.SelectOutfit] = FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation and "Feature.Avatar.Action.Select" or nil,
	[FocusNavigationEventNameEnum.UnselectOutfit] = FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation and "Feature.Avatar.Action.Unselect" or nil,
	[FocusNavigationEventNameEnum.OpenItemDetailsPeekView] = "Feature.Catalog.Action.OpenDetails",
	[FocusNavigationEventNameEnum.CloseItemDetailsPeekView] = "Feature.Catalog.Action.CloseDetails",
	[FocusNavigationEventNameEnum.OpenItemDetailsPrompt] = "Feature.Catalog.Action.Buy",
	[FocusNavigationEventNameEnum.ToggleTryOn] = "Feature.Catalog.Label.TryOns",
	[FocusNavigationEventNameEnum.UpdateOutfit] = "Feature.Avatar.Action.Update",
	[FocusNavigationEventNameEnum.ToggleTryOnManager] = "Feature.Catalog.Label.TryOns",
	[FocusNavigationEventNameEnum.SelectClothingTile] = "Feature.Avatar.Action.Select",
	[FocusNavigationEventNameEnum.MoveClothingTile] = "Feature.Avatar.Title.Move",
	[FocusNavigationEventNameEnum.RemoveClothingTile] = "Feature.Catalog.Action.Remove",
	[FocusNavigationEventNameEnum.CancelAndReset] = "Feature.Catalog.Action.Cancel",
	[FocusNavigationEventNameEnum.ViewProfile] = "Feature.Profile.Action.ViewProfile",
	[FocusNavigationEventNameEnum.CollapseAvatar] = FFlagEnableSplitPane and "Feature.SplitPane.Label.CollapseAvatar" or nil,
	[FocusNavigationEventNameEnum.ExpandAvatar] = FFlagEnableSplitPane and "Feature.SplitPane.Label.ExpandAvatar" or nil
}

local v26 = {
	[FocusNavigationEventNameEnum.HoldToPlay] = "Common.VisitGame.Label.Play",
	[FocusNavigationEventNameEnum.HoldToJoinFriend] = "Feature.Profile.Action.JoinGame"
}

local v27 = {
	[FocusNavigationEventNameEnum.HoldToPlay] = "CommonUI.Features.Label.ControllerBar.HoldPrefix"
}

local set3 = {
	[FocusNavigationEventNameEnum.HoldToAcceptTrustedFriendRequest] = true,
	[FocusNavigationEventNameEnum.HoldToAcceptFriendRequest] = true,
	[FocusNavigationEventNameEnum.HoldToAddFriend] = true,
	[FocusNavigationEventNameEnum.HoldToJoinEvent] = true,
	[FocusNavigationEventNameEnum.HoldToUnfollowEvent] = true,
	[FocusNavigationEventNameEnum.HoldToNotifyMe] = true,
	[FocusNavigationEventNameEnum.HoldToPlay] = true,
	[FocusNavigationEventNameEnum.HoldToJoinFriend] = true
}

local function applyPlatformGamepadIcon(p, p2, p3)
	local icon = p3[p2]

	if icon then
		p.icon = icon
		p.isPlatformIcon = true
	end
end

local function getLegacyInputBindings(p, p2, object, p3)
	if p2.axes then
		local vertical = p2.axes.vertical
		local horizontal = p2.axes.horizontal
		local v28 = v[p]

		local v29 = {}

		if vertical then
			table.insert(v29, { icon = v28.vertical, text = object:Format(vertical.key) })
		end

		if horizontal then
			table.insert(v29, { icon = v28.horizontal, text = object:Format(horizontal.key) })
		end

		return v29
	else
		if not p2.key then
			return {}
		end

		local v28 = { icon = v4[p], text = object:Format(p2.key) }
		local icon = FFlagShortcutBarPlatformGamepadIcons and p3 and p3[p]

		if icon then
			v28.icon = icon
			v28.isPlatformIcon = true
		end

		return { v28 }
	end
end

local function selectRoactGamepadBindings(p)
	if p.GamepadBottomBar then
		return p.GamepadBottomBar.boundInputs
	end

	return nil
end

local function getPlatformGamepadImages()
	local imageForKeyCodes = {}

	for k in v4 do
		if not (k ~= Enum.KeyCode.Thumbstick1 and k ~= Enum.KeyCode.Thumbstick2) then
			continue
		end

		local imageForKeyCode = UserInputService:GetImageForKeyCode(k)

		if imageForKeyCode ~= "" then
			imageForKeyCodes[k] = imageForKeyCode
		end
	end

	return imageForKeyCodes
end

local function usePlatformGamepadImages()
	local state, setState = React.useState(getPlatformGamepadImages)

	local v28 = React.useCallback(function()
		setState(getPlatformGamepadImages())
	end, {})

	useExternalEvent(UserInputService.GamepadConnected, v28)
	useExternalEvent(UserInputService.GamepadDisconnected, v28)

	return state
end

local function getGamepadItems(p, p2, object, p3, p4, p5)
	local gamepadItems = {}

	for _, v28 in v2 do
		if not set[v28] or p3 and set2[v28] then
			continue
		end

		if p3 then
			if set2[v28] then
				continue
			end

			local v29 = p3[v28]

			if v29 then
				local legacyInputBindings = getLegacyInputBindings(v28, v29, object, p5)

				for _, legacyInputBinding in legacyInputBindings do
					table.insert(gamepadItems, legacyInputBinding)
				end
			end
		end

		local eventName = p[v28]

		if not eventName then
			continue
		end

		local v29 = v5[v28]
		local v30

		if p4 then
			v30 = v24[v28]
		end

		local v31

		if p4 and v29 then
			v31 = v29[eventName]
		end

		local v32

		if p4 and v30 then
			v32 = v30[eventName]
		end

		local icon

		if p4 then
			icon = v32 or v31
		elseif v29 then
			icon = v29[eventName]
		end

		local v40

		if p4 then
			v40 = v26[eventName]
		end

		local v41 = v25[eventName]
		local v42

		if p4 then
			v42 = v40 or v41
		else
			v42 = v25[eventName]
		end

		local text

		if v42 then
			text = object:Format(v42)
		end

		local v44 = v27[eventName]
		local actionText

		if v44 then
			actionText = object:Format(v44)
		end

		local progress = p2[eventName]
		local hasProgress = set3[eventName]

		if not (icon and text) then
			continue
		end

		if p4 then
			actionText = nil
		end

		local inputKeyCode

		if p4 then
			inputKeyCode = v28
		end

		if not p4 then
			eventName = nil
		end

		local v48 = {
			icon = icon,
			text = text,
			actionText = actionText,
			progress = progress,
			hasProgress = hasProgress,
			inputKeyCode = inputKeyCode,
			eventName = eventName
		}
		local icon2 = FFlagShortcutBarPlatformGamepadIcons and p5 and p5[v28]

		if icon2 then
			v48.icon = icon2
			v48.isPlatformIcon = true
		end

		table.insert(gamepadItems, v48)
	end

	if not p4 then
		return gamepadItems
	end

	local eventName = p[Enum.KeyCode.ButtonB]

	if eventName ~= FocusNavigationEventNameEnum.NavigateBack then
		return gamepadItems
	end

	local v28 = {
		icon = v4[Enum.KeyCode.ButtonB],
		text = object:Format(v25[eventName]),
		inputKeyCode = Enum.KeyCode.ButtonB,
		eventName = eventName
	}
	local icon = FFlagShortcutBarPlatformGamepadIcons and p5 and p5[Enum.KeyCode.ButtonB]

	if icon then
		v28.icon = icon
		v28.isPlatformIcon = true
	end

	table.insert(gamepadItems, v28)

	return gamepadItems
end

local function getKeyboardItems(items, p, object, p2)
	local v28 = {}
	local keyboardItems = {}

	for k, item in items do
		if set[k] then
			continue
		end

		if typeof(v28[item]) == "table" then
			table.insert(v28[item], k)
		else
			v28[item] = { k }
		end
	end

	for _, eventName in v3 do
		local icon = v28[eventName]

		if not icon then
			continue
		end

		local v29 = v25[eventName]
		local text

		if v29 then
			text = object:Format(v29)
		end

		local v30 = v27[eventName]
		local actionText

		if v30 then
			actionText = object:Format(v30)
		end

		local progress = p[eventName]
		local hasProgress = set3[eventName]

		if not text then
			continue
		end

		if p2 then
			actionText = nil
		end

		local inputKeyCode

		if p2 then
			inputKeyCode = icon[1]
		end

		if not p2 then
			eventName = nil
		end

		table.insert(keyboardItems, {
			icon = icon,
			text = text,
			actionText = actionText,
			progress = progress,
			hasProgress = hasProgress,
			inputKeyCode = inputKeyCode,
			eventName = eventName
		})
	end

	return keyboardItems
end

local function useShortcutBarFrameProps()
	local v28 = useDesignTokens()

	local v29 = useSignalState(Display.GetDisplayStore().getDeviceSafePadding)

	return {
		Position = UDim2.new(0.5, 0, 1, not v28 and 0 or -v28.Size.Size_200 + v29.bottom),
		AnchorPoint = Vector2.new(0.5, 1)
	}
end

local function useShortcutBarItems()
	local v28 = ReactFocusNavigation.useActiveEventMap()
	local v29 = React.useContext(LocalizationRoactContext)
	local v30 = useHeldProgressByEvent()
	local v31 = useLastInputMethod()
	local v32

	if FFlagLuaAppResponsiveEnginePreferredInput then
		v32 = Responsive.usePreferredInput()
	end

	local v38

	if defineFastFlag then
		v38 = useIsTvRemoteDevice()
	end

	local v39

	if FFlagStickyShortcutBarTvRemoteWithGamepad then
		v39 = useIsRealGamepadConnected()
	else
		v39 = false
	end

	local v40

	if FFlagShortcutBarPlatformGamepadIcons then
		v40 = usePlatformGamepadImages()
	end

	local v41 = useSelector(selectRoactGamepadBindings)

	local v42 = useAppPolicy(function(p)
		return p.getStickyShortcutBarEnabled()
	end) or FFlagEnableStickyShortcutBarOnAllPlatforms

	if FFlagShortcutBarPlatformGamepadIcons and not v42 then
		v40 = nil
	end

	local v43

	if FFlagLuaAppResponsiveEnginePreferredInput then
		v43 = v32 == Responsive.Input.Directional
	else
		v43 = v31 == "Gamepad"
	end

	if not v43 then
		return getKeyboardItems(v28, v30, v29, v42)
	end

	if v38 and not v39 then
		return {}
	end

	return getGamepadItems(v28, v30, v29, v41, v42, v40)
end

function useAppShortcutBarProps()
	local v28 = useShortcutBarFrameProps()
	local items = useShortcutBarItems()

	return Cryo.Dictionary.union(v28, { items = items })
end

return useAppShortcutBarProps
