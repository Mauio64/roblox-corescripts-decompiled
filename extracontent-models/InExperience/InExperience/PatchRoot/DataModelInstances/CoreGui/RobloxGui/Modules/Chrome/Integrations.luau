local CorePackages = game:GetService("CorePackages")

local SharedExperimentDefinition = require(CorePackages.Workspace.Packages.SharedExperimentDefinition)
local isInExperienceUIVREnabled = SharedExperimentDefinition.isInExperienceUIVREnabled
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local isSpatial = AppCommonLib.isSpatial
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableInExperienceAvatarSwitcher = SharedFlags.FFlagEnableInExperienceAvatarSwitcher
local FFlagAddInviteFriendsIntegration = SharedFlags.FFlagAddInviteFriendsIntegration
local FFlagAppNavMyStatsTab = SharedFlags.FFlagAppNavMyStatsTab
local isSideSheetEnabled = require(CorePackages.Workspace.Packages.InExperienceSideSheetUtils.isSideSheetEnabled)
local FFlagEnableInExperienceShop = SharedFlags.FFlagEnableInExperienceShop
local FFlagEnableOffersPrefetch = SharedFlags.FFlagEnableOffersPrefetch
local FFlagIntegrateTraversalHistoryInSideSheet = SharedFlags.FFlagIntegrateTraversalHistoryInSideSheet
local FFlagRemoveFriendsChatUnibarEntrypoints = SharedFlags.FFlagRemoveFriendsChatUnibarEntrypoints
local FFlagExpChatCanShowFriendsTab = SharedFlags.FFlagExpChatCanShowFriendsTab
local FFlagShowSwitchServerButton = SharedFlags.FFlagShowSwitchServerButton
local PioneerUtils = require(CorePackages.Workspace.Packages.PioneerUtils)
local isPioneerLaunch = PioneerUtils.isPioneerLaunch
local FFlagEnableSideSheetRobuxWidget = require(script.Parent.Flags.FFlagEnableSideSheetRobuxWidget)

local CoreScriptsRoactCommon = require(CorePackages.Workspace.Packages.CoreScriptsRoactCommon)
local FFlagAddTraversalHistory = CoreScriptsRoactCommon.Traversal.Flags.FFlagAddTraversalHistory

local Integrations = {
	OverflowMenu = require(script.OverflowMenu),
	AssistantBuild = 0,
	Chat = 0,
	ConnectDropdown = 0,
	TrustAndSafety = 0,
	DummyWindow = 0,
	DummyWindow2 = 0,
	ToggleMic = 0,
	JoinVoice = 0,
	SelfieView = 0,
	CapturesEntrypoint = 0,
	AvatarSwitcherEntryPoint = 0,
	MusicEntrypoint = 0,
	PartyEntrypoint = 0,
	PartyMic = 0,
	VRToggleButton = 0,
	VRSafeBubble = 0,
	People = 0,
	InviteFriends = 0,
	Settings = 0,
	Gallery = 0,
	Help = 0,
	TraversalHistory = 0,
	LeaveConfirmation = 0,
	RespawnConfirmation = 0,
	RobuxWidget = 0,
	ShopEntrypoint = 0,
	InitOffersPrefetch = 0,
	SwitchServer = 0,
	AccountUpsell = 0
}
local assistantBuild

if FFlagAppNavMyStatsTab then
	assistantBuild = require(script.AssistantBuild)
end

Integrations.AssistantBuild = assistantBuild
Integrations.Chat = require(script.ExpChat.ChatChromeIntegration)
local connectDropdown

if not (FFlagRemoveFriendsChatUnibarEntrypoints and FFlagExpChatCanShowFriendsTab) then
	connectDropdown = require(script.Connect.ConnectIconDropdown)
end

Integrations.ConnectDropdown = connectDropdown

Integrations.TrustAndSafety = require(script.TrustAndSafety)
Integrations.DummyWindow = require(script.DummyWindow)
Integrations.DummyWindow2 = require(script.DummyWindow2)
Integrations.ToggleMic = require(script.ToggleMic)
Integrations.JoinVoice = require(script.JoinVoice)
Integrations.SelfieView = require(script.SelfieView)
Integrations.CapturesEntrypoint = require(script.Captures.CapturesEntrypoint)
local avatarSwitcherEntryPoint

if FFlagEnableInExperienceAvatarSwitcher then
	avatarSwitcherEntryPoint = require(script.AvatarSwitcher.AvatarSwitcherEntrypoint)
end

Integrations.AvatarSwitcherEntryPoint = avatarSwitcherEntryPoint

Integrations.MusicEntrypoint = require(script.MusicUtility.MusicEntrypoint)
Integrations.PartyEntrypoint = require(script.Party.PartyEntrypoint)
Integrations.PartyMic = require(script.Party.PartyMic)
local vrToggleButton

if isInExperienceUIVREnabled and isSpatial() then
	vrToggleButton = require(script.VRToggleButton)
end

Integrations.VRToggleButton = vrToggleButton
local vrSafeBubble

if isInExperienceUIVREnabled and isSpatial() then
	vrSafeBubble = require(script.VRSafeBubble)
end

Integrations.VRSafeBubble = vrSafeBubble
Integrations.People = require(script.Pages.People)
local inviteFriends

if FFlagAddInviteFriendsIntegration then
	inviteFriends = require(script.Pages.InviteFriends)
end

Integrations.InviteFriends = inviteFriends
Integrations.Settings = require(script.Pages.Settings)
Integrations.Gallery = require(script.Pages.Gallery)
Integrations.Help = require(script.Pages.Help)
local traversalHistory

if FFlagAddTraversalHistory and FFlagIntegrateTraversalHistoryInSideSheet then
	traversalHistory = require(script.Pages.TraversalHistory)
end

Integrations.TraversalHistory = traversalHistory
local leaveConfirmation

if isSideSheetEnabled then
	leaveConfirmation = require(script.Pages.LeaveConfirmation)
end

Integrations.LeaveConfirmation = leaveConfirmation
local respawnConfirmation

if isSideSheetEnabled then
	respawnConfirmation = require(script.Pages.RespawnConfirmation)
end

Integrations.RespawnConfirmation = respawnConfirmation
local robuxWidget

if FFlagEnableSideSheetRobuxWidget and isSideSheetEnabled then
	robuxWidget = require(script.RobuxWidget)
end

Integrations.RobuxWidget = robuxWidget
local shopEntrypoint

if FFlagEnableInExperienceShop then
	shopEntrypoint = require(script.InExperienceShop.ShopEntrypoint)
end

Integrations.ShopEntrypoint = shopEntrypoint
local initOffersPrefetch

if FFlagEnableOffersPrefetch then
	initOffersPrefetch = require(script.InExperienceOffers.initOffersPrefetch)
end

Integrations.InitOffersPrefetch = initOffersPrefetch
local switchServer

if isSideSheetEnabled and (isPioneerLaunch() or FFlagShowSwitchServerButton) then
	switchServer = require(script.SwitchServer)
end

Integrations.SwitchServer = switchServer
local accountUpsell

if isPioneerLaunch() then
	accountUpsell = require(script.AccountUpsell)
end

Integrations.AccountUpsell = accountUpsell
return Integrations
