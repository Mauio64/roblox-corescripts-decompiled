local UserInputService = game:GetService("UserInputService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/Cryo")
local focusNavigationEventNameEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/FocusNavigationUtils").FocusNavigationEventNameEnum
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/ReactFocusNavigation")
require("@game/CorePackages/Workspace/Packages/_Index/AppShortcutBar/AppShortcutBar/Components/AppShortcutBar")
local localizationRoactContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/Localization").LocalizationRoactContext
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/Responsive")

local useHeldProgressByEvent = require("@game/CorePackages/Workspace/Packages/_Index/AppShortcutBar/AppShortcutBar/Hooks/AppShortcutBarContext").useHeldProgressByEvent
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/RoactUtils").Hooks.RoactRodux.useSelector
local useLastInputMethod = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/FocusNavigationUtils").useLastInputMethod
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/Style").useDesignTokens
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/UniversalAppPolicy").useAppPolicy
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/SignalsReact").useSignalState
local useIsTvRemoteDevice = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/RoactUtils").Hooks.useIsTvRemoteDevice
local useIsRealGamepadConnected = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/RoactUtils").Hooks.useIsRealGamepadConnected
local useExternalEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/RoactUtils").Hooks.useExternalEvent
local Display = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/Display")

local defineFastFlag = game:DefineFastFlag("NoShortcutBarWithTvRemote", false)
local fFlagStickyShortcutBarTvRemoteWithGamepad = require("@game/CorePackages/Workspace/Packages/_Index/AppShortcutBar/AppShortcutBar/Flags").FFlagStickyShortcutBarTvRemoteWithGamepad
local fFlagShortcutBarPlatformGamepadIcons = require("@game/CorePackages/Workspace/Packages/_Index/AppShortcutBar/AppShortcutBar/Flags").FFlagShortcutBarPlatformGamepadIcons

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/SharedFlags")

local fFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad = SharedFlags.FFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad
local fFlagAXMigrateEmoteMenuFromRoactGamepad = SharedFlags.FFlagAXMigrateEmoteMenuFromRoactGamepad

local fFlagAXMigrateAdjustAccessoryViewToFocusNavigation = SharedFlags.FFlagAXMigrateAdjustAccessoryViewToFocusNavigation

local fFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation = SharedFlags.FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation
local fFlagLuaAppResponsiveEnginePreferredInput = SharedFlags.FFlagLuaAppResponsiveEnginePreferredInput
local fFlagLuaAppMediaGalleryGamepadSupport = SharedFlags.FFlagLuaAppMediaGalleryGamepadSupport
local fFlagEnableStickyShortcutBarOnAllPlatforms = SharedFlags.FFlagEnableStickyShortcutBarOnAllPlatforms
local fFlagEnableSplitPane = SharedFlags.FFlagEnableSplitPane

local v5 = {
	[Enum.KeyCode.Thumbstick1] = {
		vertical = "rbxasset://textures/ui/Controls/DesignSystem/Thumbstick1Vertical.png",
		horizontal = "rbxasset://textures/ui/Controls/DesignSystem/Thumbstick1Horizontal.png"
	},
	[Enum.KeyCode.Thumbstick2] = {
		vertical = "rbxasset://textures/ui/Controls/DesignSystem/Thumbstick2Vertical.png",
		horizontal = "rbxasset://textures/ui/Controls/DesignSystem/Thumbstick2Horizontal.png"
	}
}

local v6 = {
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

local v7 = {
	focusNavigationEventNameEnum.HoldToAcceptTrustedFriendRequest,
	focusNavigationEventNameEnum.HoldToAcceptFriendRequest,
	focusNavigationEventNameEnum.HoldToAddFriend,
	focusNavigationEventNameEnum.HoldToJoinEvent,
	focusNavigationEventNameEnum.HoldToUnfollowEvent,
	focusNavigationEventNameEnum.HoldToNotifyMe,
	focusNavigationEventNameEnum.HoldToPlay,
	focusNavigationEventNameEnum.HoldToJoinFriend,
	focusNavigationEventNameEnum.Play,
	focusNavigationEventNameEnum.Search,
	focusNavigationEventNameEnum.SeeAll,
	focusNavigationEventNameEnum.DisplayStatsAndInfo,
	focusNavigationEventNameEnum.AcceptFriendRequest,
	focusNavigationEventNameEnum.AddFriend,
	focusNavigationEventNameEnum.IgnoreTrustedFriendRequest,
	focusNavigationEventNameEnum.IgnoreFriendRequest,
	focusNavigationEventNameEnum.ViewProfile,
	focusNavigationEventNameEnum.OpenQuickMenu,
	focusNavigationEventNameEnum.NavigateBack,
	focusNavigationEventNameEnum.ScrollUp,
	focusNavigationEventNameEnum.ScrollDown
}

table.insert(v7, focusNavigationEventNameEnum.Confirm)
table.insert(v7, focusNavigationEventNameEnum.SelectItem)
table.insert(v7, focusNavigationEventNameEnum.OpenItemDetailsPage)
table.insert(v7, focusNavigationEventNameEnum.ToggleTryOnManager)

if fFlagEnableSplitPane then
	table.insert(v7, focusNavigationEventNameEnum.CollapseAvatar)
	table.insert(v7, focusNavigationEventNameEnum.ExpandAvatar)
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

local v8 = {
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

local v9 = {}
local buttonY = Enum.KeyCode.ButtonY
local v10 = {
	[focusNavigationEventNameEnum.Search] = v8[Enum.KeyCode.ButtonY],
	[focusNavigationEventNameEnum.DisplayStatsAndInfo] = v8[Enum.KeyCode.ButtonY],
	[focusNavigationEventNameEnum.OpenLayeredClothingSortResetPrompt] = v8[Enum.KeyCode.ButtonY],
	[focusNavigationEventNameEnum.OpenLayeredMakeupSortResetPrompt] = v8[Enum.KeyCode.ButtonY],
	[focusNavigationEventNameEnum.SortAndFiltersReset] = v8[Enum.KeyCode.ButtonY],
	[focusNavigationEventNameEnum.WearAfterPurchase] = v8[Enum.KeyCode.ButtonY],
	[focusNavigationEventNameEnum.FormPeekViewReset] = v8[Enum.KeyCode.ButtonY]
}
local adjustAccessoryViewReset = focusNavigationEventNameEnum.AdjustAccessoryViewReset
local v11 = if fFlagAXMigrateAdjustAccessoryViewToFocusNavigation then v8[Enum.KeyCode.ButtonY] else nil
v10[adjustAccessoryViewReset] = v11

local manageOutfitsRename = focusNavigationEventNameEnum.ManageOutfitsRename
local v12 = if fFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation then v8[Enum.KeyCode.ButtonY] else nil
v10[manageOutfitsRename] = v12

v10[focusNavigationEventNameEnum.OpenItemDetailsPeekView] = v8[Enum.KeyCode.ButtonY]
v10[focusNavigationEventNameEnum.CloseItemDetailsPeekView] = v8[Enum.KeyCode.ButtonY]
v10[focusNavigationEventNameEnum.ToggleTryOn] = v8[Enum.KeyCode.ButtonY]
v10[focusNavigationEventNameEnum.ToggleTryOnManager] = v8[Enum.KeyCode.ButtonY]
v10[focusNavigationEventNameEnum.RemoveClothingTile] = v8[Enum.KeyCode.ButtonY]
v9[buttonY] = v10

local buttonX = Enum.KeyCode.ButtonX
local v13 = {
	[focusNavigationEventNameEnum.Play] = v8[Enum.KeyCode.ButtonX],
	[focusNavigationEventNameEnum.SeeAll] = v8[Enum.KeyCode.ButtonX],
	[focusNavigationEventNameEnum.AcceptFriendRequest] = v8[Enum.KeyCode.ButtonX],
	[focusNavigationEventNameEnum.AddFriend] = v8[Enum.KeyCode.ButtonX],
	[focusNavigationEventNameEnum.OpenBuyCatalogItemPrompt] = v8[Enum.KeyCode.ButtonX]
}
local openItemDetailsPage = focusNavigationEventNameEnum.OpenItemDetailsPage
local v14 = if fFlagAXMigrateEmoteMenuFromRoactGamepad then v8[Enum.KeyCode.ButtonX] else nil
v13[openItemDetailsPage] = v14

v13[focusNavigationEventNameEnum.SortAndFiltersApply] = v8[Enum.KeyCode.ButtonX]
v13[focusNavigationEventNameEnum.SaveAsCharacter] = v8[Enum.KeyCode.ButtonX]
v13[focusNavigationEventNameEnum.FormPeekViewApply] = v8[Enum.KeyCode.ButtonX]
local manageOutfitsDelete = focusNavigationEventNameEnum.ManageOutfitsDelete
local v15 = if fFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation then v8[Enum.KeyCode.ButtonX] else nil
v13[manageOutfitsDelete] = v15

v13[focusNavigationEventNameEnum.OpenItemDetailsPrompt] = v8[Enum.KeyCode.ButtonX]
v13[focusNavigationEventNameEnum.UpdateOutfit] = v8[Enum.KeyCode.ButtonX]
v13[focusNavigationEventNameEnum.IgnoreTrustedFriendRequest] = v8[Enum.KeyCode.ButtonX]
v13[focusNavigationEventNameEnum.IgnoreFriendRequest] = v8[Enum.KeyCode.ButtonX]
v13[focusNavigationEventNameEnum.ViewProfile] = v8[Enum.KeyCode.ButtonX]
v9[buttonX] = v13

local buttonA = Enum.KeyCode.ButtonA
local playVideo = focusNavigationEventNameEnum.PlayVideo
local v17 = if fFlagLuaAppMediaGalleryGamepadSupport then v8[Enum.KeyCode.ButtonA] else nil
local v16 = { [playVideo] = v17 }

local pauseVideo = focusNavigationEventNameEnum.PauseVideo
local v18 = if fFlagLuaAppMediaGalleryGamepadSupport then v8[Enum.KeyCode.ButtonA] else nil
v16[pauseVideo] = v18

v16[focusNavigationEventNameEnum.HoldToAcceptTrustedFriendRequest] = v8[Enum.KeyCode.ButtonA]
v16[focusNavigationEventNameEnum.HoldToAcceptFriendRequest] = v8[Enum.KeyCode.ButtonA]
v16[focusNavigationEventNameEnum.HoldToAddFriend] = v8[Enum.KeyCode.ButtonA]
v16[focusNavigationEventNameEnum.HoldToJoinEvent] = v8[Enum.KeyCode.ButtonA]
v16[focusNavigationEventNameEnum.HoldToUnfollowEvent] = v8[Enum.KeyCode.ButtonA]
v16[focusNavigationEventNameEnum.HoldToNotifyMe] = v8[Enum.KeyCode.ButtonA]
v16[focusNavigationEventNameEnum.HoldToPlay] = v8[Enum.KeyCode.ButtonA]
v16[focusNavigationEventNameEnum.HoldToJoinFriend] = v8[Enum.KeyCode.ButtonA]
v16[focusNavigationEventNameEnum.SelectItem] = v8[Enum.KeyCode.ButtonA]
v16[focusNavigationEventNameEnum.SlotEmote] = v8[Enum.KeyCode.ButtonA]
v16[focusNavigationEventNameEnum.UnslotEmote] = v8[Enum.KeyCode.ButtonA]
local equipSlotsSelectSlot = focusNavigationEventNameEnum.EquipSlotsSelectSlot
local v19 = if fFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad then v8[Enum.KeyCode.ButtonA] else nil
v16[equipSlotsSelectSlot] = v19

v16[focusNavigationEventNameEnum.Confirm] = v8[Enum.KeyCode.ButtonA]
local selectOutfit = focusNavigationEventNameEnum.SelectOutfit
local v20 = if fFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation then v8[Enum.KeyCode.ButtonA] else nil
v16[selectOutfit] = v20

local unselectOutfit = focusNavigationEventNameEnum.UnselectOutfit
local v21 = if fFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation then v8[Enum.KeyCode.ButtonA] else nil
v16[unselectOutfit] = v21

v16[focusNavigationEventNameEnum.SelectClothingTile] = v8[Enum.KeyCode.ButtonA]
v9[buttonA] = v16

local buttonB = Enum.KeyCode.ButtonB
v9[buttonB] = {
	[focusNavigationEventNameEnum.CancelAndReset] = v8[Enum.KeyCode.ButtonB]
}

local buttonR3 = Enum.KeyCode.ButtonR3
local v23 = {
	[focusNavigationEventNameEnum.ExitAvatarFullView] = v8[Enum.KeyCode.ButtonR3],
	[focusNavigationEventNameEnum.Fullscreen] = v8[Enum.KeyCode.ButtonR3],
	[focusNavigationEventNameEnum.ExitFullscreen] = v8[Enum.KeyCode.ButtonR3]
}
local collapseAvatar = focusNavigationEventNameEnum.CollapseAvatar
local v24 = if fFlagEnableSplitPane then v8[Enum.KeyCode.ButtonR3] else nil
v23[collapseAvatar] = v24

local expandAvatar = focusNavigationEventNameEnum.ExpandAvatar
local v25 = if fFlagEnableSplitPane then v8[Enum.KeyCode.ButtonR3] else nil
v23[expandAvatar] = v25
v9[buttonR3] = v23

local buttonL3 = Enum.KeyCode.ButtonL3
local v26 = {
	[focusNavigationEventNameEnum.OpenCatalogContextMenu] = v8[Enum.KeyCode.ButtonL3],
	[focusNavigationEventNameEnum.OpenItemDetailsPage] = v8[Enum.KeyCode.ButtonL3]
}
local manageOutfitsToggleMultiSelect = focusNavigationEventNameEnum.ManageOutfitsToggleMultiSelect
local v27 = if fFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation then v8[Enum.KeyCode.ButtonL3] else nil
v26[manageOutfitsToggleMultiSelect] = v27

local manageOutfitsCancelMultiSelect = focusNavigationEventNameEnum.ManageOutfitsCancelMultiSelect
local v28 = if fFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation then v8[Enum.KeyCode.ButtonL3] else nil
v26[manageOutfitsCancelMultiSelect] = v28

v26[focusNavigationEventNameEnum.OpenEditorDetailsPage] = v8[Enum.KeyCode.ButtonL3]
v26[focusNavigationEventNameEnum.Mute] = v8[Enum.KeyCode.ButtonL3]
v26[focusNavigationEventNameEnum.Unmute] = v8[Enum.KeyCode.ButtonL3]
v9[buttonL3] = v26

local buttonStart = Enum.KeyCode.ButtonStart
v9[buttonStart] = {
	[focusNavigationEventNameEnum.OpenQuickMenu] = v8[Enum.KeyCode.ButtonStart]
}

local thumbstick1 = Enum.KeyCode.Thumbstick1
v9[thumbstick1] = {
	[focusNavigationEventNameEnum.PanAvatar] = v8[Enum.KeyCode.Thumbstick1],
	[focusNavigationEventNameEnum.MoveClothingTile] = v8[Enum.KeyCode.Thumbstick1]
}

local thumbstick2 = Enum.KeyCode.Thumbstick2
v9[thumbstick2] = {
	[focusNavigationEventNameEnum.RotateAndZoomAvatar] = v8[Enum.KeyCode.Thumbstick2]
}

local v32 = {}
local buttonA2 = Enum.KeyCode.ButtonA
v32[buttonA2] = {
	[focusNavigationEventNameEnum.HoldToAcceptTrustedFriendRequest] = imageForKeyCodesByButtonA[Enum.KeyCode.ButtonA],
	[focusNavigationEventNameEnum.HoldToAcceptFriendRequest] = imageForKeyCodesByButtonA[Enum.KeyCode.ButtonA],
	[focusNavigationEventNameEnum.HoldToAddFriend] = imageForKeyCodesByButtonA[Enum.KeyCode.ButtonA],
	[focusNavigationEventNameEnum.HoldToJoinEvent] = imageForKeyCodesByButtonA[Enum.KeyCode.ButtonA],
	[focusNavigationEventNameEnum.HoldToUnfollowEvent] = imageForKeyCodesByButtonA[Enum.KeyCode.ButtonA],
	[focusNavigationEventNameEnum.HoldToNotifyMe] = imageForKeyCodesByButtonA[Enum.KeyCode.ButtonA],
	[focusNavigationEventNameEnum.HoldToPlay] = imageForKeyCodesByButtonA[Enum.KeyCode.ButtonA],
	[focusNavigationEventNameEnum.HoldToJoinFriend] = imageForKeyCodesByButtonA[Enum.KeyCode.ButtonA]
}

local v34 = {
	[focusNavigationEventNameEnum.Fullscreen] = "Feature.ExperienceDetails.Action.FullScreen",
	[focusNavigationEventNameEnum.ExitFullscreen] = "Feature.ExperienceDetails.Action.ExitFullScreen",
	[focusNavigationEventNameEnum.Mute] = "Feature.ExperienceDetails.Action.Mute",
	[focusNavigationEventNameEnum.Unmute] = "Feature.ExperienceDetails.Action.Unmute",
	[focusNavigationEventNameEnum.PlayVideo] = fFlagLuaAppMediaGalleryGamepadSupport and "Feature.GameDetails.Action.PlayVideo" or nil,
	[focusNavigationEventNameEnum.PauseVideo] = fFlagLuaAppMediaGalleryGamepadSupport and "Feature.GameDetails.Action.PauseVideo" or nil,
	[focusNavigationEventNameEnum.Search] = "CommonUI.Features.Label.ControllerBar.Search",
	[focusNavigationEventNameEnum.SeeAll] = "Feature.Home.ActionSeeAll",
	[focusNavigationEventNameEnum.Play] = "Common.VisitGame.Label.Play",
	[focusNavigationEventNameEnum.DisplayStatsAndInfo] = "Feature.GameDetails.Label.LearnMore",
	[focusNavigationEventNameEnum.HoldToPlay] = "CommonUI.Features.Label.ControllerBar.ToPlaySuffix",
	[focusNavigationEventNameEnum.HoldToJoinFriend] = "Feature.Profile.Action.JoinGame",
	[focusNavigationEventNameEnum.IgnoreTrustedFriendRequest] = "Feature.AddFriends.Action.IgnoreTrustedFriendRequest",
	[focusNavigationEventNameEnum.IgnoreFriendRequest] = "Feature.AddFriends.Action.IgnoreFriendRequest",
	[focusNavigationEventNameEnum.AcceptFriendRequest] = "CommonUI.Features.Label.AcceptFriend",
	[focusNavigationEventNameEnum.AddFriend] = "CommonUI.Features.Label.AddFriend",
	[focusNavigationEventNameEnum.HoldToAddFriend] = "CommonUI.Features.Label.AddFriend",
	[focusNavigationEventNameEnum.HoldToAcceptFriendRequest] = "CommonUI.Features.Label.AcceptFriend",
	[focusNavigationEventNameEnum.HoldToAcceptTrustedFriendRequest] = "Feature.Friends.TrustedFriend.AcceptTrustedRequest",
	[focusNavigationEventNameEnum.HoldToJoinEvent] = "Feature.VirtualEvents.JoinEvent",
	[focusNavigationEventNameEnum.HoldToUnfollowEvent] = "Feature.VirtualEvents.UnfollowEvent",
	[focusNavigationEventNameEnum.HoldToNotifyMe] = "Feature.VirtualEvents.NotifyMe",
	[focusNavigationEventNameEnum.OpenQuickMenu] = "Feature.Catalog.Heading.QuickMenu",
	[focusNavigationEventNameEnum.ScrollUp] = "Feature.Accessibility.Action.ScrollUp",
	[focusNavigationEventNameEnum.ScrollDown] = "Feature.Accessibility.Action.ScrollDown",
	[focusNavigationEventNameEnum.NavigateBack] = "CommonUI.Controls.Action.Back",
	[focusNavigationEventNameEnum.OpenBuyCatalogItemPrompt] = "Feature.Catalog.Action.Buy",
	[focusNavigationEventNameEnum.OpenCatalogContextMenu] = "Feature.Catalog.Action.ItemOptions",
	[focusNavigationEventNameEnum.OpenItemDetailsPage] = "Feature.Catalog.Action.OpenDetails",
	[focusNavigationEventNameEnum.SelectItem] = "Feature.Avatar.Action.Select",
	[focusNavigationEventNameEnum.EquipSlotsSelectSlot] = fFlagAXMigrateEquipSlotsInputBindingsToRoactGamepad and "Feature.Avatar.Action.SelectSlot" or nil,
	[focusNavigationEventNameEnum.SlotEmote] = "Feature.Avatar.Action.SlotEmote",
	[focusNavigationEventNameEnum.UnslotEmote] = "Feature.Avatar.Action.UnslotEmote",
	[focusNavigationEventNameEnum.OpenEditorDetailsPage] = "Feature.Catalog.Action.OpenDetails",
	[focusNavigationEventNameEnum.PanAvatar] = "Feature.Avatar.Action.Pan",
	[focusNavigationEventNameEnum.RotateAndZoomAvatar] = "Feature.Avatar.Action.Rotate",
	[focusNavigationEventNameEnum.ExitAvatarFullView] = "Feature.Avatar.Action.DefaultView",
	[focusNavigationEventNameEnum.OpenLayeredClothingSortResetPrompt] = "CommonUI.Messages.Action.Reset",
	[focusNavigationEventNameEnum.OpenLayeredMakeupSortResetPrompt] = "CommonUI.Messages.Action.Reset",
	[focusNavigationEventNameEnum.SortAndFiltersApply] = "CommonUI.Messages.Action.Apply",
	[focusNavigationEventNameEnum.SortAndFiltersReset] = "CommonUI.Messages.Action.Reset",
	[focusNavigationEventNameEnum.SaveAsCharacter] = "Feature.Avatar.Heading.SaveCostume",
	[focusNavigationEventNameEnum.WearAfterPurchase] = "Feature.Avatar.Heading.WearConfirmation",
	[focusNavigationEventNameEnum.Confirm] = "CommonUI.Controls.Action.Confirm",
	[focusNavigationEventNameEnum.FormPeekViewApply] = "CommonUI.Messages.Action.Apply",
	[focusNavigationEventNameEnum.FormPeekViewReset] = "CommonUI.Messages.Action.Reset",
	[focusNavigationEventNameEnum.AdjustAccessoryViewReset] = fFlagAXMigrateAdjustAccessoryViewToFocusNavigation and "CommonUI.Messages.Action.Reset" or nil,
	[focusNavigationEventNameEnum.ManageOutfitsToggleMultiSelect] = fFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation and "Feature.Avatar.Action.SelectMultipleItems" or nil,
	[focusNavigationEventNameEnum.ManageOutfitsCancelMultiSelect] = fFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation and "Feature.Avatar.Action.CancelSelection" or nil,
	[focusNavigationEventNameEnum.ManageOutfitsDelete] = fFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation and "Feature.Avatar.Action.Delete" or nil,
	[focusNavigationEventNameEnum.ManageOutfitsRename] = fFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation and "Feature.Avatar.Action.Rename" or nil,
	[focusNavigationEventNameEnum.SelectOutfit] = fFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation and "Feature.Avatar.Action.Select" or nil,
	[focusNavigationEventNameEnum.UnselectOutfit] = fFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation and "Feature.Avatar.Action.Unselect" or nil,
	[focusNavigationEventNameEnum.OpenItemDetailsPeekView] = "Feature.Catalog.Action.OpenDetails",
	[focusNavigationEventNameEnum.CloseItemDetailsPeekView] = "Feature.Catalog.Action.CloseDetails",
	[focusNavigationEventNameEnum.OpenItemDetailsPrompt] = "Feature.Catalog.Action.Buy",
	[focusNavigationEventNameEnum.ToggleTryOn] = "Feature.Catalog.Label.TryOns",
	[focusNavigationEventNameEnum.UpdateOutfit] = "Feature.Avatar.Action.Update",
	[focusNavigationEventNameEnum.ToggleTryOnManager] = "Feature.Catalog.Label.TryOns",
	[focusNavigationEventNameEnum.SelectClothingTile] = "Feature.Avatar.Action.Select",
	[focusNavigationEventNameEnum.MoveClothingTile] = "Feature.Avatar.Title.Move",
	[focusNavigationEventNameEnum.RemoveClothingTile] = "Feature.Catalog.Action.Remove",
	[focusNavigationEventNameEnum.CancelAndReset] = "Feature.Catalog.Action.Cancel",
	[focusNavigationEventNameEnum.ViewProfile] = "Feature.Profile.Action.ViewProfile",
	[focusNavigationEventNameEnum.CollapseAvatar] = fFlagEnableSplitPane and "Feature.SplitPane.Label.CollapseAvatar" or nil,
	[focusNavigationEventNameEnum.ExpandAvatar] = fFlagEnableSplitPane and "Feature.SplitPane.Label.ExpandAvatar" or nil
}

local v35 = {
	[focusNavigationEventNameEnum.HoldToPlay] = "Common.VisitGame.Label.Play",
	[focusNavigationEventNameEnum.HoldToJoinFriend] = "Feature.Profile.Action.JoinGame"
}

local v36 = {
	[focusNavigationEventNameEnum.HoldToPlay] = "CommonUI.Features.Label.ControllerBar.HoldPrefix"
}

local set3 = {
	[focusNavigationEventNameEnum.HoldToAcceptTrustedFriendRequest] = true,
	[focusNavigationEventNameEnum.HoldToAcceptFriendRequest] = true,
	[focusNavigationEventNameEnum.HoldToAddFriend] = true,
	[focusNavigationEventNameEnum.HoldToJoinEvent] = true,
	[focusNavigationEventNameEnum.HoldToUnfollowEvent] = true,
	[focusNavigationEventNameEnum.HoldToNotifyMe] = true,
	[focusNavigationEventNameEnum.HoldToPlay] = true,
	[focusNavigationEventNameEnum.HoldToJoinFriend] = true
}

local function applyPlatformGamepadIcon(p2, p3, p4)
	local v37 = p4[p3]

	if v37 then
		p2.icon = v37
		p2.isPlatformIcon = true
	end
end

local function getLegacyInputBindings(p2, p3, object, p4)
	if p3.axes then
		local vertical = p3.axes.vertical
		local horizontal = p3.axes.horizontal
		local v37 = v5[p2]

		local v38 = {}

		if vertical then
			table.insert(v38, {
				icon = v37.vertical,
				text = object:Format(vertical.key)
			})
		end

		if horizontal then
			table.insert(v38, {
				icon = v37.horizontal,
				text = object:Format(horizontal.key)
			})
		end

		return v38
	else
		if not p3.key then
			return {}
		end

		local v37 = { icon = v8[p2], text = object:Format(p3.key) }
		local v38 = fFlagShortcutBarPlatformGamepadIcons and p4 and p4[p2]

		if v38 then
			v37.icon = v38
			v37.isPlatformIcon = true
		end

		return { v37 }
	end
end

local function selectRoactGamepadBindings(p2)
	if p2.GamepadBottomBar then
		return p2.GamepadBottomBar.boundInputs
	end

	return nil
end

local function getPlatformGamepadImages()
	local imageForKeyCodes = {}

	for k in v8 do
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

	local v37 = React.useCallback(function()
		setState(getPlatformGamepadImages())
	end, {})

	useExternalEvent(UserInputService.GamepadConnected, v37)
	useExternalEvent(UserInputService.GamepadDisconnected, v37)

	return state
end

local function getGamepadItems(p2, p3, object, p4, p5, p6)
	local gamepadItems = {}

	for k, v37 in v6 do
		if not set[v37] or p4 and set2[v37] then
			continue
		end

		if p4 then
			if set2[v37] then
				continue
			end

			local v38 = p4[v37]

			if v38 then
				local legacyInputBindings = getLegacyInputBindings(v37, v38, object, p6)

				for k2, legacyInputBinding in legacyInputBindings do
					table.insert(gamepadItems, legacyInputBinding)
				end
			end
		end

		local v38 = p2[v37]

		if not v38 then
			continue
		end

		local v39 = v9[v37]
		local v40 = if p5 then v32[v37] else nil
		local v41 = if p5 and v39 then v39[v38] else nil

		local v42 = if p5 and v40 then v40[v38] else nil

		local v43 = if p5 then v42 or v41 elseif v39 then v39[v38] else nil

		local v44 = if p5 then v35[v38] else nil

		local v45 = v34[v38]

		local v46 = if p5 then v44 or v45 else v34[v38]
		local v47 = if v46 then object:Format(v46) else nil
		local v48 = v36[v38]
		local v49 = if v48 then object:Format(v48) else nil
		local v50 = p3[v38]
		local v51 = set3[v38]

		if not (v43 and v47) then
			continue
		end

		if p5 then
			v49 = nil
		end

		local v52 = {
			icon = v43,
			text = v47,
			actionText = v49,
			progress = v50,
			hasProgress = v51,
			inputKeyCode = if p5 then v37 else nil,
			eventName = nil
		}

		if not p5 then
			v38 = nil
		end

		v52.eventName = v38
		local v54 = fFlagShortcutBarPlatformGamepadIcons and p6 and p6[v37]

		if v54 then
			v52.icon = v54
			v52.isPlatformIcon = true
		end

		table.insert(gamepadItems, v52)
	end

	if not p5 then
		return gamepadItems
	end

	local v37 = p2[Enum.KeyCode.ButtonB]

	if v37 ~= focusNavigationEventNameEnum.NavigateBack then
		return gamepadItems
	end

	local v38 = {
		icon = v8[Enum.KeyCode.ButtonB],
		text = object:Format(v34[v37]),
		inputKeyCode = Enum.KeyCode.ButtonB,
		eventName = v37
	}
	local v39 = fFlagShortcutBarPlatformGamepadIcons and p6 and p6[Enum.KeyCode.ButtonB]

	if v39 then
		v38.icon = v39
		v38.isPlatformIcon = true
	end

	table.insert(gamepadItems, v38)

	return gamepadItems
end

local function getKeyboardItems(items, p2, object, p3)
	local v37 = {}
	local keyboardItems = {}

	for k, item in items do
		if set[k] then
			continue
		end

		if typeof(v37[item]) == "table" then
			table.insert(v37[item], k)
		else
			v37[item] = { k }
		end
	end

	for k, v38 in v7 do
		local v39 = v37[v38]

		if not v39 then
			continue
		end

		local v40 = v34[v38]
		local v41 = if v40 then object:Format(v40) else nil
		local v42 = v36[v38]
		local v43 = if v42 then object:Format(v42) else nil
		local v44 = p2[v38]
		local v45 = set3[v38]

		if not v41 then
			continue
		end

		if p3 then
			v43 = nil
		end

		local v47 = if p3 then v39[1] else nil

		if not p3 then
			v38 = nil
		end

		table.insert(keyboardItems, {
			icon = v39,
			text = v41,
			actionText = v43,
			progress = v44,
			hasProgress = v45,
			inputKeyCode = v47,
			eventName = v38
		})
	end

	return keyboardItems
end

local function useShortcutBarFrameProps()
	local v37 = useDesignTokens()

	local v38 = useSignalState(Display.GetDisplayStore().getDeviceSafePadding)

	return {
		Position = UDim2.new(0.5, 0, 1, not v37 and 0 or -v37.Size.Size_200 + v38.bottom),
		AnchorPoint = Vector2.new(0.5, 1)
	}
end

local function useShortcutBarItems()
	local v37 = ReactFocusNavigation.useActiveEventMap()
	local v38 = React.useContext(localizationRoactContext)
	local v39 = useHeldProgressByEvent()
	local v40 = useLastInputMethod()
	local v41 = if fFlagLuaAppResponsiveEnginePreferredInput then Responsive.usePreferredInput() else nil
	local v42 = if defineFastFlag then useIsTvRemoteDevice() else nil

	local v43 = if fFlagStickyShortcutBarTvRemoteWithGamepad then useIsRealGamepadConnected() else false

	local v44 = if fFlagShortcutBarPlatformGamepadIcons then usePlatformGamepadImages() else nil

	local v45 = useSelector(selectRoactGamepadBindings)

	local v46 = useAppPolicy(function(p2)
		return p2.getStickyShortcutBarEnabled()
	end) or fFlagEnableStickyShortcutBarOnAllPlatforms

	if fFlagShortcutBarPlatformGamepadIcons and not v46 then
		v44 = nil
	end

	local v47

	if fFlagLuaAppResponsiveEnginePreferredInput then
		v47 = v41 == Responsive.Input.Directional
	else
		v47 = v40 == "Gamepad"
	end

	if not v47 then
		return getKeyboardItems(v37, v39, v38, v46)
	end

	if v42 and not v43 then
		return {}
	end

	return getGamepadItems(v37, v39, v38, v45, v46, v44)
end

function LUAUFORGE_MODULE_GLOBALS_bSG_useAppShortcutBarProps()
	local v37 = useShortcutBarFrameProps()
	local v38 = useShortcutBarItems()

	return Cryo.Dictionary.union(v37, { items = v38 })
end

return LUAUFORGE_MODULE_GLOBALS_bSG_useAppShortcutBarProps
