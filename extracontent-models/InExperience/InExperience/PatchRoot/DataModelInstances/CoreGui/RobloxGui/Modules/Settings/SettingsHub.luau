local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local FFlagEnableNewBackpack = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableNewBackpack
local v5 = if not FFlagEnableNewBackpack then nil else require(CorePackages.Workspace.Packages.System).Features
local Symbol = require(CorePackages.Workspace.Packages.AppCommonLib).Symbol
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local IXPService = game:GetService("IXPService")
local LocalizationService = game:GetService("LocalizationService")
local TelemetryService = game:GetService("TelemetryService")
local EngineFeature = game:GetEngineFeature("DeprecateOldGuiObjectProperties")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local v14 = require(RobloxGui.Modules.TenFootInterface):IsEnabled()
local Roact = require(CorePackages.Packages.Roact)
local Cryo = require(CorePackages.Packages.Cryo)
local Otter = require(CorePackages.Packages.Otter)
local React = require(CorePackages.Packages.React)
local ReactRoblox = require(CorePackages.Packages.ReactRoblox)
local Foundation = require(CorePackages.Packages.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local Traversal = require(CorePackages.Workspace.Packages.CoreScriptsRoactCommon).Traversal
local PortalWithFoundationStylelink = require(script.Parent.Components.PortalWithFoundationStylelink)
local InExperienceMenuReact = require(script.Parent.InExperienceMenuReact)
local InExperienceMenuReactPage = require(script.Parent.Pages.InExperienceMenuReactPage)
local ReactPageSignal = require(script.Parent.ReactPageSignal)
local Utils = require(script.Parent.Integrations.Utils)
local Utility = require(RobloxGui.Modules.Settings.Utility)
local VRHub = require(CorePackages.Workspace.Packages.VrCommon).VRHub
local CachedPolicyService = require(CorePackages.Workspace.Packages.CachedPolicyService)
local PerfUtils = require(RobloxGui.Modules.Common.PerfUtils)
local MouseIconOverrideService = require(CorePackages.Workspace.Packages.CoreScriptsCommon).MouseIconOverrideService
local isSubjectToDesktopPolicies = require(CorePackages.Workspace.Packages.SharedFlags).isSubjectToDesktopPolicies
local SwitchTabHint = require(RobloxGui.Modules.Settings.Components.TabHeader).SwitchTabHint
local TraversalHistoryMenu = require(RobloxGui.Modules.Settings.Components.Traversal).TraversalHistoryMenu
local MenuBackButton = require(RobloxGui.Modules.Settings.Components.MenuBackButton)
local MenuFrontButton = require(RobloxGui.Modules.Settings.Components.MenuFrontButton)
local MenuButtonsContainer = require(RobloxGui.Modules.Settings.Components.MenuButtons.MenuButtonsContainer)
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local IXPServiceWrapper = require(CorePackages.Workspace.Packages.IxpServiceWrapper).IXPServiceWrapper
local AppFonts = require(CorePackages.Workspace.Packages.Style).AppFonts
local CapturesPolicy = require(CorePackages.Workspace.Packages.CapturesInExperience).CapturesPolicy
local InExperienceCapabilities = require(CorePackages.Workspace.Packages.InExperienceCapabilities).InExperienceCapabilities
local getCamMicPermissions = require(CoreGui.RobloxGui.Modules.Settings.getCamMicPermissions)
local Create = require(CorePackages.Workspace.Packages.AppCommonLib).Create
local Stores = require(CorePackages.Workspace.Packages.CoreGuiCommon).Stores
local Signals = require(CorePackages.Packages.Signals)
local createSignal = Signals.createSignal
local AppStyleProvider = require(CorePackages.Packages.UIBlox).App.Style.AppStyleProvider
local Dark = require(CorePackages.Packages.UIBlox).App.Style.Constants.ThemeName.Dark
local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)
local isSpatial = require(CorePackages.Workspace.Packages.AppCommonLib).isSpatial
local HelpPage = require(CorePackages.Workspace.Packages.HelpPage)
local Theme = require(script.Parent.Theme)
local v55 = Theme.color("SETTINGS_SHIELD", Color3.new(0.1607843137254902, 0.1607843137254902, 0.1607843137254902))
local v56 = Theme.transparency("SETTINGS_SHIELD_TRANSPARENCY", 0.2)
local SHIELD_INACTIVE_POSITION = Theme.SHIELD_INACTIVE_POSITION
local v58 = Symbol.named("SettingsHubCursorOverride")
local v59 = if not v14 then not Utility:IsSmallTouchScreen() and 26 or 24 else 32
local v60 = game:DefineFastInt("CheckLeaveGameUpsellCooldown", 300)
local v61 = game:DefineFastInt("GetServerChannelRetries", 10)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local Flags = require(script.Parent.Flags)
local FFlagIEMFocusNavPeoplePageToButtons = SharedFlags.FFlagIEMFocusNavPeoplePageToButtons
local t1 = {
	EngineFeatureRbxAnalyticsServiceExposePlaySessionId = game:GetEngineFeature("RbxAnalyticsServiceExposePlaySessionId"),
	EngineFeatureTeleportHistoryButtons = game:GetEngineFeature("TeleportHistoryButtons"),
	EngineFeaturePlayerScriptStatusProperty = game:GetEngineFeature("PlayerScriptStatusProperty"),
	FFlagRemoveRecordPage = game:DefineFastFlag("RemoveRecordPage", false),
	FFlagPreventHiddenSwitchPage = game:DefineFastFlag("PreventHiddenSwitchPage", false),
	FFlagLuaEnableGameInviteModalSettingsHub = game:DefineFastFlag("LuaEnableGameInviteModalSettingsHub", false),
	FFlagFixDisableTopPaddingError = game:DefineFastFlag("FixDisableTopPaddingError", false),
	GetFFlagLuaInExperienceCoreScriptsGameInviteUnification = require(RobloxGui.Modules.Flags.GetFFlagLuaInExperienceCoreScriptsGameInviteUnification),
	FFlagEnableInGameMenuDurationLogger = require(RobloxGui.Modules.Common.Flags.GetFFlagEnableInGameMenuDurationLogger)(),
	isNewInGameMenuEnabled = require(RobloxGui.Modules.isNewInGameMenuEnabled),
	GetFFlagRemoveAssetVersionEndpoint = require(RobloxGui.Modules.Flags.GetFFlagRemoveAssetVersionEndpoint),
	GetFFlagNewEventIngestPlayerScriptsDimensions = require(RobloxGui.Modules.Flags.GetFFlagNewEventIngestPlayerScriptsDimensions),
	GetFFlagReportAbuseMenuEntrypointAnalytics = require(RobloxGui.Modules.Settings.Flags.GetFFlagReportAbuseMenuEntrypointAnalytics),
	GetFFlagEnableLeaveGameUpsellEntrypoint = require(RobloxGui.Modules.Settings.Flags.GetFFlagEnableLeaveGameUpsellEntrypoint),
	GetFStringInExperienceMenuIXPLayer = require(RobloxGui.Modules.Settings.Flags.GetFStringInExperienceMenuIXPLayer),
	GetFStringInExperienceMenuIXPVar = require(RobloxGui.Modules.Settings.Flags.GetFStringInExperienceMenuIXPVar),
	FFlagRelocateMobileMenuButtons = require(RobloxGui.Modules.Settings.Flags.FFlagRelocateMobileMenuButtons),
	FIntRelocateMobileMenuButtonsVariant = require(RobloxGui.Modules.Settings.Flags.FIntRelocateMobileMenuButtonsVariant),
	FFlagMenuButtonsMountWithIEM = require(RobloxGui.Modules.Settings.Flags.FFlagMenuButtonsMountWithIEM),
	FFlagSpatialUIFixMenuPanelChatExclusive = require(RobloxGui.Modules.Settings.Flags.FFlagSpatialUIFixMenuPanelChatExclusive),
	FFlagRemoveLoadingTimeout = require(RobloxGui.Modules.Flags.FFlagRemoveLoadingTimeout),
	FFlagAddNextUpContainer = require(RobloxGui.Modules.Settings.Pages.LeaveGameWithNextUp.Flags.FFlagAddNextUpContainer),
	FFlagAddNewPlayerListMobileFocusNav = PlayerList.Flags.FFlagAddNewPlayerListMobileFocusNav,
	ChromeEnabled = require(CorePackages.Workspace.Packages.Chrome).Enabled(),
	FFlagRespawnChromeShortcutTelemetry = require(RobloxGui.Modules.Chrome.Flags.FFlagRespawnChromeShortcutTelemetry),
	FFlagLocalizeVersionLabels = settings():GetFFlag("LocalizeVersionLabels"),
	isInExperienceUIVREnabled = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).isInExperienceUIVREnabled,
	InExperienceUIVRIXP = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).InExperienceUIVRIXP,
	FFlagAddSwitchTabHintsToIEM = SharedFlags.FFlagAddSwitchTabHintsToIEM,
	GetFStringGameInviteMenuLayer = SharedFlags.GetFStringGameInviteMenuLayer,
	GetFFlagEnableAppChatInExperience = SharedFlags.GetFFlagEnableAppChatInExperience,
	GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints = SharedFlags.GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints,
	GetFFlagDisplayServerChannel = SharedFlags.GetFFlagDisplayServerChannel,
	FFlagSettingsHubIndependentBackgroundVisibility = SharedFlags.getFFlagSettingsHubIndependentBackgroundVisibility(),
	GetFFlagPackagifySettingsShowSignal = SharedFlags.GetFFlagPackagifySettingsShowSignal,
	FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls,
	FFlagIEMFocusNavToButtons = SharedFlags.FFlagIEMFocusNavToButtons,
	FFlagIEMTabFocusNav = SharedFlags.FFlagIEMTabFocusNav,
	FFlagIEMFocusNavSupportNewButtons = Flags.FFlagIEMFocusNavSupportNewButtons,
	FFlagIEMResumeButtonPressBugfix = SharedFlags.FFlagIEMResumeButtonPressBugfix,
	FFlagAddUILessMode = SharedFlags.FFlagAddUILessMode,
	FIntAddUILessModeVariant = SharedFlags.FIntAddUILessModeVariant,
	FFlagInExperienceReportClosingBugfix = SharedFlags.FFlagInExperienceReportClosingBugfix,
	FFlagEnableSettingsHubUIDelegateRollout = SharedFlags.FFlagEnableSettingsHubUIDelegateRollout,
	FFlagAddIEMProfilePage = SharedFlags.FFlagAddIEMProfilePage,
	FFlagFixSpatialUICaptures = SharedFlags.FFlagFixSpatialUICaptures,
	FFlagVoiceRewarmTelemetry = SharedFlags.FFlagVoiceRewarmTelemetry,
	FFlagAddTraversalBackButton = Traversal.Flags.FFlagAddTraversalBackButton,
	FFlagAddTraversalHistory = Traversal.Flags.FFlagAddTraversalHistory,
	FFlagCreateInExperienceMenuReact = Flags.FFlagCreateInExperienceMenuReact,
	FFlagEnableSystemScrimInSettingsHub = game:DefineFastFlag("EnableSystemScrimInSettingsHub", false),
	FFlagHelpPageIXPExposure = HelpPage.Flags.FFlagHelpPageIXPExposure,
	FStringHelpPageIXPLayer = HelpPage.Flags.FStringHelpPageIXPLayer,
	FFlagAddAbilityToDisableIGMScroll = SharedFlags.FFlagAddAbilityToDisableIGMScroll,
	FFlagFixDisabledScrollOnIos = game:DefineFastFlag("FixDisabledScrollOnIos", false),
	FFlagEnableSideSheet = SharedFlags.FFlagEnableSideSheet,
	FFlagAddInviteFriendsIntegration = SharedFlags.FFlagAddInviteFriendsIntegration,
	FFlagIntegrateTraversalHistoryInSideSheet = SharedFlags.FFlagIntegrateTraversalHistoryInSideSheet,
	FFlagImprovePageTitleCloseButton = game:DefineFastFlag("ImprovePageTitleCloseButton", false),
	FFlagIGMSelectionGroup = game:DefineFastFlag("IGMSelectionGroup", false)
}
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local ContentProvider = game:GetService("ContentProvider")
local StarterGui = game:GetService("StarterGui")
local StarterPlayer = game:GetService("StarterPlayer")
local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VRService = game:GetService("VRService")
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local HttpService = game:GetService("HttpService")
local GameSettings = UserSettings().GameSettings
local ExperienceMenuSessionManagerInstance = require(CorePackages.Workspace.Packages.InExperienceSessionization).ExperienceMenuSessionManagerInstance
local PlatformService = nil

pcall(function() -- line: 198
	-- upvalues: PlatformService (ref)
	PlatformService = game:GetService("PlatformService")
end)

local PlatformFriendsService = nil

pcall(function() -- line: 201
	-- upvalues: PlatformFriendsService (ref)
	PlatformFriendsService = game:GetService("PlatformFriendsService")
end)

local GetServerVersion = nil

spawn(function() -- line: 205
	-- upvalues: GetServerVersion (ref), RobloxReplicatedStorage (copy)
	GetServerVersion = RobloxReplicatedStorage:WaitForChild("GetServerVersion", 1e999)
end)

local GetServerChannel = nil

if t1.GetFFlagDisplayServerChannel() then
	spawn(function() -- line: 211
		-- upvalues: GetServerChannel (ref), RobloxReplicatedStorage (copy)
		GetServerChannel = RobloxReplicatedStorage:WaitForChild("GetServerChannel", 1e999)
	end)
end

local v83 = UserInputService.PreferredInput == Enum.PreferredInput.Touch

RobloxGui:WaitForChild("Modules"):WaitForChild("TenFootInterface")

local Platform = UserInputService:GetPlatform()
local BaseUrl = ContentProvider.BaseUrl
local v86 = not string.find(BaseUrl, "www.roblox.com")
local DevConsoleMaster = require(RobloxGui.Modules.DevConsoleMaster)
local u88 = nil
local u89 = false
local u90 = nil
local u91 = nil
local SettingsFullScreenTitleBar = require(RobloxGui.Modules.Settings.Components.SettingsFullScreenTitleBar)
local MenuLeaveGameTelemetryConfig = require(RobloxGui.Modules.Settings.Analytics.MenuLeaveGameTelemetryConfig)
local MenuResetCharacterTelemetryConfig = require(RobloxGui.Modules.Settings.Analytics.MenuResetCharacterTelemetryConfig)
local MenuResumeTelemetryConfig = require(RobloxGui.Modules.Settings.Analytics.MenuResumeTelemetryConfig)
local ReactPageAnalytics = require(RobloxGui.Modules.Settings.Analytics.ReactPageAnalytics)
local GameInviteAnalytics = require(CorePackages.Workspace.Packages.GameInvite).GameInviteAnalytics
local GameInviteModalManager = nil
local GameInviteInviteExperimentVariant = nil
local GameInviteConstants = nil

if t1.GetFFlagLuaInExperienceCoreScriptsGameInviteUnification() then
	local GameInvite = require(CorePackages.Workspace.Packages.GameInvite)

	GameInviteModalManager = GameInvite.GameInviteModalManager
	GameInviteInviteExperimentVariant = GameInvite.GameInviteInviteExperimentVariant
	GameInviteConstants = GameInvite.GameInviteConstants
end

local CapturesApp = require(RobloxGui.Modules.Captures.CapturesApp)
local Constants = require(RobloxGui.Modules:WaitForChild("InGameMenu"):WaitForChild("Resources"):WaitForChild("Constants"))
local v104 = CachedPolicyService:IsSubjectToChinaPolicies()
local default = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager).default
local Constants2 = require(RobloxGui.Modules.VoiceChat.Constants)
local v107 = game:DefineFastFlag("SettingsHubRaceConditionFix", false)
local v108 = game:DefineFastFlag("FixReportButtonCutOff", false)
local InExperienceAppChatModal = require(CorePackages.Workspace.Packages.AppChat.InExperienceAppChatModal)
local v110 = if not t1.GetFFlagPackagifySettingsShowSignal() then nil else require(CorePackages.Workspace.Packages.CoreScriptsCommon).SettingsShowSignal
local v111 = if not t1.GetFFlagPackagifySettingsShowSignal() then nil else require(CorePackages.Workspace.Packages.CoreScriptsCommon).SettingsUtility
local t2 = {
	frequency = 4,
	dampingRatio = 1
}
local InExperienceSideSheet = require(CorePackages.Workspace.Packages.InExperienceSideSheet)
local toggleSideSheet = InExperienceSideSheet.toggleSideSheet
local getSideSheetVisibility = InExperienceSideSheet.getSideSheetVisibility

require(RobloxGui.Modules.Settings.ReactPageFactory)

local Localization = require(CorePackages.Workspace.Packages.InExperienceLocales).Localization
local v117 = t1.FFlagLocalizeVersionLabels or v104
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local function tryTranslate(p1, p2) -- line: 296
	-- upvalues: RobloxTranslator (copy)
	if not RobloxTranslator then
		return p2
	end

	local ok, result = pcall(RobloxTranslator.FormatByKey, RobloxTranslator, p1)

	if ok then
		return result
	end

	return p2
end

local ChatSelector = require(RobloxGui.Modules.ChatSelector)
local v121, _ = GuiService:GetGuiInset()
local uDim2 = UDim2.new(0, 0, 0, -v121.Y)
local uDim2_2 = UDim2.new(1, 0, 1, v121.Y)

local function GetCorePackagesLoaded(p3) -- line: 312
	local CorePackages2 = game:GetService("CorePackages")

	for _, v in pairs(p3) do
		if not CorePackages2:FindFirstChild(v) then
			return false
		end
	end

	return true
end
local function GetServerVersionBlocking() -- line: 322
	-- upvalues: u90 (ref), GetServerVersion (ref)
	if u90 then
		return u90
	end

	if not GetServerVersion then
		repeat
			wait()
		until GetServerVersion
	end

	u90 = GetServerVersion:InvokeServer()

	return u90
end
local function GetServerChannelBlocking() -- line: 335
	-- upvalues: u91 (ref), v61 (copy), GetServerChannel (ref)
	if u91 then
		return u91
	end

	local v141 = v61

	if not GetServerChannel then
		repeat
			task.wait()
			v141 -= 1
		until GetServerChannel or v141 == 0
	end

	if GetServerChannel then
		u91 = GetServerChannel:InvokeServer()
	else
		warn("GetServerChannelRemote not available")
		u91 = "Unknown"
	end

	return u91
end
local function GetPlaceVersionText() -- line: 356
	-- upvalues: t1 (copy), HttpRbxApiService (copy), HttpService (copy)
	if t1.GetFFlagRemoveAssetVersionEndpoint() then
		return game.PlaceVersion
	end

	local PlaceVersion = game.PlaceVersion

	pcall(function() -- line: 363
		-- upvalues: HttpRbxApiService (copy), HttpService (copy), PlaceVersion (ref)
		local Async = HttpRbxApiService:GetAsync(string.format("assets/%d/versions", game.PlaceId))
		local VersionNumber = HttpService:JSONDecode(Async)[1].VersionNumber

		PlaceVersion = string.format("%s (Latest: %d)", PlaceVersion, VersionNumber)
	end)

	return PlaceVersion
end
local function createReactPage(p4) -- line: 373
	-- upvalues: Create (copy)
	return Create("Frame")({
		Name = "InExperienceMenuPage",
		BackgroundTransparency = 1,
		Visible = false,
		Size = UDim2.fromScale(0, 0),
		Parent = p4
	})
end
local function CreateSettingsHub() -- line: 384
	-- upvalues: t1 (copy), RobloxGui (copy), v110 (copy), Utility (copy), v111 (copy), createSignal (copy), Constants2 (copy), Stores (copy), RbxAnalyticsService (copy), ReactPageAnalytics (copy), createReactPage (copy), Theme (copy), ContextActionService (copy), LocalizationService (copy), Localization (copy), v14 (copy), Create (copy), v83 (copy), UserInputService (copy), Platform (copy), default (copy), getCamMicPermissions (copy), Otter (copy), RobloxTranslator (copy), v107 (copy), StarterGui (copy), InExperienceSideSheet (copy), TelemetryService (copy), MenuLeaveGameTelemetryConfig (copy), MenuResetCharacterTelemetryConfig (copy), Constants (copy), MenuResumeTelemetryConfig (copy), ReactRoblox (copy), React (copy), MenuButtonsContainer (copy), Flags (copy), GuiService (copy), uDim2_2 (copy), uDim2 (copy), SHIELD_INACTIVE_POSITION (copy), v56 (copy), v55 (copy), v59 (copy), v117 (copy), GetServerChannelBlocking (copy), u90 (ref), GetServerVersion (ref), RunService (copy), HttpRbxApiService (copy), HttpService (copy), CachedPolicyService (copy), BaseUrl (copy), v86 (copy), StarterPlayer (copy), Players (copy), FFlagIEMFocusNavPeoplePageToButtons (copy), Roact (copy), RoactAppExperiment (copy), IXPService (copy), AppStyleProvider (copy), Dark (copy), MenuBackButton (copy), MenuFrontButton (copy), AppFonts (copy), t2 (copy), CorePackages (copy), InExperienceAppChatModal (copy), InExperienceCapabilities (copy), FoundationProvider (copy), Foundation (copy), Utils (copy), SwitchTabHint (copy), isSubjectToDesktopPolicies (copy), SettingsFullScreenTitleBar (copy), VRService (copy), GameSettings (copy), DevConsoleMaster (copy), v108 (copy), Cryo (copy), IXPServiceWrapper (copy), ExperienceMenuSessionManagerInstance (copy), ReactPageSignal (copy), MouseIconOverrideService (copy), v58 (copy), v60 (copy), TweenService (copy), PerfUtils (copy), EngineFeature (copy), u88 (ref), ChatSelector (copy), FFlagEnableNewBackpack (copy), v5 (copy), u89 (ref), GameInviteInviteExperimentVariant (ref), PlatformFriendsService (ref), PlatformService (ref), GameInviteModalManager (ref), GameInviteConstants (ref), GetCorePackagesLoaded (copy), GameInviteAnalytics (copy), CapturesPolicy (copy), isSpatial (copy), CapturesApp (copy), getSideSheetVisibility (copy), toggleSideSheet (copy), Signals (copy), PortalWithFoundationStylelink (copy), TraversalHistoryMenu (copy), InExperienceMenuReact (copy), InExperienceMenuReactPage (copy)
	local t3 = {
		Visible = false,
		Active = true,
		Pages = {
			CurrentPage = nil,
			PageTable = {}
		},
		MenuStack = {},
		TabHeaders = {},
		BottomBarButtons = {},
		BottomBarButtonsComponents = {},
		ResizedConnection = nil,
		BackBarVisibleConnection = nil
	}

	if t1.EngineFeatureTeleportHistoryButtons then
		t3.FrontBarVisibleConnection = nil
	end

	t3.PreferredTransparencyChangedConnection = nil
	t3.TabConnection = nil

	if t1.FFlagAddNextUpContainer then
		t3.LeaveGamePage = require(RobloxGui.Modules.Settings.Pages.LeaveGameWithNextUp)
	else
		t3.LeaveGamePage = require(RobloxGui.Modules.Settings.Pages.LeaveGame)
	end

	t3.LeaveGameUpsellPage = if not t1.GetFFlagEnableLeaveGameUpsellEntrypoint() then nil else require(RobloxGui.Modules.Settings.Pages.LeaveGameUpsell.LeaveGameUpsell)
	t3.ResetCharacterPage = require(RobloxGui.Modules.Settings.Pages.ResetCharacter)
	t3.SettingsShowSignal = if not t1.GetFFlagPackagifySettingsShowSignal() then Utility:CreateSignal() else v110
	t3.CurrentPageSignal = if not t1.GetFFlagPackagifySettingsShowSignal() then Utility:CreateSignal() else v111.CreateSignal()

	local v145, v146 = createSignal(false)

	t3.showBottomBarSignal = v145
	t3.setShowBottomBarSignal = v146
	t3.OpenStateChangedCount = 0
	t3.BottomButtonFrame = nil

	if t1.FFlagRelocateMobileMenuButtons then
		t3.addMenuKeyBindings = nil
		t3.removeMenuKeyBindings = nil
	end

	if t1.FFlagIEMFocusNavSupportNewButtons then
		t3.ResumeMenuButton = nil
	end

	t3.hasMicPermissions = false

	if t1.GetFFlagEnableLeaveGameUpsellEntrypoint() then
		t3.checkedUpsell = false
		t3.leaveGameUpsellProp = Constants2.PHONE_UPSELL_VALUE_PROP.None
		t3.sessionStartTime = os.time()
	end

	t3.isFetchingMicPermissions = true

	if t1.FFlagAddUILessMode and t1.FIntAddUILessModeVariant ~= 0 then
		t3.uiLessStore = Stores.GetUILessStore(false)
	end

	t3.PageTitleLabel = nil
	t3.PageTitleCloseButton = nil
	t3.PageTitleHeader = nil
	t3.isMuted = nil
	t3.lastVoiceRecordingIndicatorTextUpdated = nil
	t3.playSessionId = ""

	if t1.EngineFeatureRbxAnalyticsServiceExposePlaySessionId then
		t3.playSessionId = RbxAnalyticsService:GetPlaySessionId()
	end

	t3.reactPageAnalytics = ReactPageAnalytics.new()

	local u147 = nil
	local u148 = nil
	local BindableEvent = Instance.new("BindableEvent")

	BindableEvent.Name = "PoppedMenu"
	t3.PoppedMenu = BindableEvent.Event
	t3.ReactPage = nil

	if t1.FFlagCreateInExperienceMenuReact then
		t3.ReactPage = createReactPage()
	end

	local function shouldShowHubBar(p5) -- line: 460
		-- upvalues: t3 (copy), t1 (copy)
		local v258 = p5 or t3.Pages.CurrentPage

		if t1.FFlagEnableSideSheet then
			return v258.ShouldShowHubBar == true
		end

		return v258.ShouldShowBottomBar == true
	end
	local function updatePageTitleHeader(p6) -- line: 465
		-- upvalues: t3 (copy), t1 (copy)
		local v260 = p6 or t3.Pages.CurrentPage

		if not (if not t1.FFlagEnableSideSheet then v260.ShouldShowBottomBar == true else v260.ShouldShowHubBar == true) or not p6.TabHeader then
			t3.PageTitleLabel.Text = ""

			return
		end

		t3.PageTitleLabel.Text = p6.TabHeader.TabLabel.Title.Text
	end
	local function setTabHeaderSelection(p7) -- line: 474
		-- upvalues: t1 (copy)
		if not t1.FFlagIEMTabFocusNav then
			return
		end

		local TabHeader = p7:GetTabHeader()

		if not TabHeader then
			return
		end

		for _, v264 in p7.FirstSelectableObjects do
			v264.NextSelectionUp = TabHeader
			TabHeader.NextSelectionDown = v264
		end
	end
	local function updateTabHeaderWrapping() -- line: 488
		-- upvalues: t1 (copy), t3 (copy)
		if not t1.FFlagIEMTabFocusNav then
			return
		end

		for _, v266 in t3.TabHeaders do
			v266.NextSelectionLeft = nil
			v266.NextSelectionRight = nil
		end

		local v267 = #t3.TabHeaders

		if v267 < 2 then
			return
		end

		t3.TabHeaders[1].NextSelectionLeft = t3.TabHeaders[v267]
		t3.TabHeaders[v267].NextSelectionRight = t3.TabHeaders[1]
	end
	local function setBottomBarSelection(p8) -- line: 500
		-- upvalues: t3 (copy), t1 (copy)
		if not t3.BottomButtonFrame and (t1.FFlagIEMFocusNavToButtons and not p8) and (not t1.FFlagRelocateMobileMenuButtons or t1.FIntRelocateMobileMenuButtonsVariant == 0 or t1.FIntRelocateMobileMenuButtonsVariant == 2) then
			return
		end

		if t3.ResumeButton then
			p8.PageNextSelectionDown = t3.ResumeButton
		elseif t1.FFlagIEMFocusNavSupportNewButtons and t1.FIntRelocateMobileMenuButtonsVariant == 2 and t3.ResumeMenuButton then
			p8.PageNextSelectionDown = t3.ResumeMenuButton
		end

		if t1.FFlagIEMTabFocusNav and t3.BottomButtonFrame then
			local TabHeader = p8:GetTabHeader()
			local v270 = t3.ResumeButton or t3.ResumeMenuButton

			if v270 then
				for k, _ in pairs(t3.Pages.PageTable) do
					local TabHeader2 = k:GetTabHeader()

					if TabHeader2 then
						TabHeader2.NextSelectionUp = v270
					end
				end
			end

			for _, descendant in t3.BottomButtonFrame:GetDescendants() do
				if descendant:IsA("GuiObject") and descendant.Selectable then
					descendant.NextSelectionDown = TabHeader
				end
			end
		end

		for _, v277 in p8.LastSelectableObjects do
			t3.BottomButtonFrame.SelectionBehaviorUp = Enum.SelectionBehavior.Escape
			t3.BottomButtonFrame.NextSelectionUp = v277
			v277.NextSelectionDown = p8.PageNextSelectionDown

			local LeaveGameButton = t3.LeaveGameButton

			if LeaveGameButton then
				LeaveGameButton.NextSelectionUp = v277
			end

			if t1.FFlagIEMFocusNavSupportNewButtons and t1.FIntRelocateMobileMenuButtonsVariant == 2 then
				for _, descendant in t3.BottomButtonFrame:GetDescendants() do
					if descendant:IsA("GuiObject") and descendant.Selectable then
						descendant.NextSelectionUp = v277
					end
				end
			end
		end

		if #p8.LastSelectableObjects < 1 then
			t3.BottomButtonFrame.SelectionBehaviorUp = Enum.SelectionBehavior.Stop
			t3.BottomButtonFrame.NextSelectionUp = nil

			local LeaveGameButton = t3.LeaveGameButton

			if LeaveGameButton then
				LeaveGameButton.NextSelectionUp = nil
			end

			if t1.FFlagIEMFocusNavSupportNewButtons and t1.FIntRelocateMobileMenuButtonsVariant == 2 then
				for _, descendant in t3.BottomButtonFrame:GetDescendants() do
					if descendant:IsA("GuiObject") and descendant.Selectable then
						descendant.NextSelectionUp = if not t1.FFlagIEMTabFocusNav then nil else p8:GetTabHeader()
					end
				end
			end
		end
	end
	local function shouldShowBottomBar(p9) -- line: 569
		-- upvalues: t3 (copy), t1 (copy), Utility (copy), Theme (copy)
		local v285 = p9 or t3.Pages.CurrentPage

		if (not t1.FFlagRelocateMobileMenuButtons or (t1.FIntRelocateMobileMenuButtonsVariant == 0 or t1.FIntRelocateMobileMenuButtonsVariant == 2)) and ((Utility:IsPortrait() or Utility:IsSmallTouchScreen()) and not Theme.AlwaysShowBottomBar()) then
			return false
		end

		return v285 ~= nil and v285.ShouldShowBottomBar == true
	end
	local function shouldDisableDefaultScroll(p10) -- line: 583
		-- upvalues: t3 (copy)
		local v287 = p10 or t3.Pages.CurrentPage

		return v287 ~= nil and v287.ShouldDisableDefaultScroll == true
	end
	local function setBottomBarBindings() -- line: 588
		-- upvalues: t3 (copy), t1 (copy), ContextActionService (copy)
		if not t3.Visible then
			return
		end

		if not t1.FFlagRelocateMobileMenuButtons or t1.FIntRelocateMobileMenuButtonsVariant == 0 then
			for i = 1, #t3.BottomBarButtons do
				local v289 = t3.BottomBarButtons[i]
				local v290 = v289[1]
				local v291 = v289[2]

				ContextActionService:BindCoreAction(v290, v291[1], false, unpack(v291[2]))
			end
		elseif t3.addMenuKeyBindings then
			t3.addMenuKeyBindings()
		end

		if t3.BottomButtonFrame then
			t3.BottomButtonFrame.Visible = true
		end
	end
	local function removeBottomBarBindings(p11) -- line: 611
		-- upvalues: t1 (copy), t3 (copy), ContextActionService (copy)
		if not t1.FFlagRelocateMobileMenuButtons or t1.FIntRelocateMobileMenuButtonsVariant == 0 then
			for _, v in pairs(t3.BottomBarButtons) do
				ContextActionService:UnbindCoreAction(v[1])
			end
		elseif t3.removeMenuKeyBindings then
			t3.removeMenuKeyBindings()
		end

		local OpenStateChangedCount = t3.OpenStateChangedCount

		if p11 then
			delay(p11, function() -- line: 623
				-- upvalues: t3 (copy), OpenStateChangedCount (copy)
				if t3.OpenStateChangedCount == OpenStateChangedCount and t3.BottomButtonFrame then
					t3.BottomButtonFrame.Visible = false
				end
			end)

			return
		end

		if OpenStateChangedCount == t3.OpenStateChangedCount and t3.BottomButtonFrame then
			t3.BottomButtonFrame.Visible = false
		end
	end
	local function updateButtonPosition(p12, p13, p14) -- line: 636
		-- upvalues: t1 (copy), t3 (copy)
		if not t1.FFlagRelocateMobileMenuButtons or t1.FIntRelocateMobileMenuButtonsVariant == 0 then
			local v299 = t3.BottomButtonFrame:FindFirstChild(p12 .. "ButtonButton", true)

			if not v299 then
				return
			end

			v299.Position = p13
			v299.Size = p14
		end
	end

	local RobloxLocaleId = LocalizationService.RobloxLocaleId
	local v161 = Localization.new(RobloxLocaleId)

	local function hideVoiceUx() -- line: 652
		-- upvalues: t3 (copy), v14 (copy), Theme (copy), t1 (copy)
		local MuteButtonButton = t3.MuteButtonButton

		if MuteButtonButton then
			MuteButtonButton.Visible = false
			MuteButtonButton:Destroy()
		end

		local v301 = if not v14 then UDim2.new(0, 260, 0, Theme.LargeButtonHeight) else UDim2.new(0, 320, 0, 72)

		if not t1.FFlagRelocateMobileMenuButtons or t1.FIntRelocateMobileMenuButtonsVariant == 0 then
			local uDim2_3 = UDim2.new(0.5, not v14 and -130 or -160, 0.5, -25)

			if not t1.FFlagRelocateMobileMenuButtons or t1.FIntRelocateMobileMenuButtonsVariant == 0 then
				local LeaveGameButtonButton = t3.BottomButtonFrame:FindFirstChild("LeaveGameButtonButton", true)

				if LeaveGameButtonButton then
					LeaveGameButtonButton.Position = uDim2_3
					LeaveGameButtonButton.Size = v301
				end
			end

			local uDim2_4 = UDim2.new(0.5, not v14 and -400 or -550, 0.5, -25)

			if not t1.FFlagRelocateMobileMenuButtons or t1.FIntRelocateMobileMenuButtonsVariant == 0 then
				local ResetCharacterButtonButton = t3.BottomButtonFrame:FindFirstChild("ResetCharacterButtonButton", true)

				if ResetCharacterButtonButton then
					ResetCharacterButtonButton.Position = uDim2_4
					ResetCharacterButtonButton.Size = v301
				end
			end

			local uDim2_5 = UDim2.new(0.5, not v14 and 140 or 200, 0.5, -25)

			if not t1.FFlagRelocateMobileMenuButtons or t1.FIntRelocateMobileMenuButtonsVariant == 0 then
				local ResumeButtonButton = t3.BottomButtonFrame:FindFirstChild("ResumeButtonButton", true)

				if not ResumeButtonButton then
					return
				end

				ResumeButtonButton.Position = uDim2_5
				ResumeButtonButton.Size = v301
			end
		end
	end
	local function addBottomBarButtonOld(p15, p16, p17, p18, p19, p20, p21, p22) -- line: 668
		-- upvalues: t1 (copy), Theme (copy), v14 (copy), t3 (copy), Utility (copy), Create (copy), v83 (copy), UserInputService (copy), Platform (copy)
		if not t1.FFlagRelocateMobileMenuButtons or t1.FIntRelocateMobileMenuButtonsVariant == 0 then
			local v316 = p15 .. "Button"
			local v317 = p15 .. "Text"
			local uDim2_6 = UDim2.new(0, 260, 0, Theme.LargeButtonHeight)

			if v14 then
				uDim2_6 = UDim2.new(0, 320, 0, 72)
			end

			local v319 = t3
			local v320 = t3
			local v321, v322 = Utility:MakeStyledButton(p15 .. "Button", p16, uDim2_6, p20, nil, t3)

			v319[v316] = v321
			v320[v317] = v322
			Create("UIListLayout")({
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Parent = t3[v316]
			})
			Create("UIPadding")({
				PaddingLeft = UDim.new(0.025, 0),
				Parent = t3[v316]
			})
			t3[v317].Size = UDim2.new(0, 0, 1, 0)
			Create("UIFlexItem")({
				FlexMode = Enum.UIFlexMode.Grow,
				Parent = t3[v317]
			})
			t3[v316].Position = p19
			t3[v316].Parent = t3.BottomButtonFrame

			if v14 then
				t3[v316].ImageTransparency = 1
			end

			t3[v317].FontSize = Enum.FontSize.Size24

			local u323 = nil

			if not v83 then
				local v324 = p15 .. "Hint"
				local v325 = if not UserInputService:GetGamepadConnected(Enum.UserInputType.Gamepad1) and Platform ~= Enum.Platform.XBoxOne then p18 else p17

				u323 = Create("ImageLabel")({
					BackgroundTransparency = 1,
					LayoutOrder = -1,
					Name = v324,
					ZIndex = t3.Shield.ZIndex + 2,
					Image = v325,
					Parent = t3[v316]
				})

				if v325 == p18 then
					u323.ImageColor3 = Theme.color("WhiteButtonText", Color3.new(1, 1, 1))
					u323.ImageTransparency = Theme.transparency("WhiteButtonText", 1)
				end

				u323.Position = UDim2.new(0, 9, 0.5, 0)
				u323.Size = UDim2.new(0, 33, 0, 33)
				u323.AnchorPoint = Vector2.new(0, 0.5)
			end

			if v14 then
				t3[v317].FontSize = Enum.FontSize.Size36
			end

			UserInputService.InputBegan:connect(function(p23) -- line: 741
				-- upvalues: u323 (ref), p17 (copy), p18 (copy)
				if p23.UserInputType == Enum.UserInputType.Gamepad1 or (p23.UserInputType == Enum.UserInputType.Gamepad2 or p23.UserInputType == Enum.UserInputType.Gamepad3 or p23.UserInputType == Enum.UserInputType.Gamepad4) then
					if u323 then
						u323.Image = p17

						return
					end
				elseif p23.UserInputType == Enum.UserInputType.Keyboard and u323 then
					u323.Image = p18
				end
			end)
			t3.BottomBarButtons[#t3.BottomBarButtons + 1] = {
				v316,
				{
					function(_, p25, _) -- line: 764
						-- upvalues: p22 (copy)
						if p25 == Enum.UserInputState.Begin then
							p22()
						end
					end,
					p21
				}
			}
		end
	end

	local s1 = ""

	if v14 then
		s1 = "@2x"
	end

	local ImageForKeyCode, ImageForKeyCode2, ImageForKeyCode3

	if t1.FFlagEnableConsoleExpControls then
		ImageForKeyCode = UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonB)
		ImageForKeyCode2 = UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonX)
		ImageForKeyCode3 = UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonY)
	else
		ImageForKeyCode = "rbxasset://textures/ui/Controls/DesignSystem/ButtonB" .. s1 .. ".png"
		ImageForKeyCode2 = "rbxasset://textures/ui/Controls/DesignSystem/ButtonX" .. s1 .. ".png"
		ImageForKeyCode3 = "rbxasset://textures/ui/Controls/DesignSystem/ButtonY" .. s1 .. ".png"
	end

	local ImageForKeyCode4 = UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonStart)
	local u169 = false
	local connection = nil

	local function setupVoiceListeners() -- line: 798
		-- upvalues: u169 (ref), t3 (copy), default (copy), getCamMicPermissions (copy), connection (ref), Otter (copy), RobloxTranslator (copy), hideVoiceUx (copy)
		if game:GetEngineFeature("VoiceChatSupported") and not u169 then
			u169 = true

			local function showUI() -- line: 803
				-- upvalues: t3 (copy), default (copy), getCamMicPermissions (copy), connection (ref), Otter (copy), RobloxTranslator (copy)
				t3.VoiceRecordingText.Visible = true
				default:getService().StateChanged:Connect(function(_, newState) -- line: 806
					-- upvalues: t3 (copy)
					if newState == Enum.VoiceChatState.Joined then
						t3.VoiceRecordingText.Visible = true
					end
				end)
				default:SetupParticipantListeners()
				getCamMicPermissions(function(p28) -- line: 813
					-- upvalues: t3 (copy)
					t3.hasMicPermissions = p28.hasMicPermissions
				end, nil, true, "PermissionsButtons.getPermissions")
				connection = default.muteChanged.Event:Connect(function(p29) -- line: 817
					-- upvalues: t3 (copy), Otter (copy), RobloxTranslator (copy)
					t3.isMuted = p29
					t3.lastVoiceRecordingIndicatorTextUpdated = tick()
					t3.voiceRecordingIndicatorTextMotor:setGoal(Otter.instant(0))

					if t3.isMuted then
						local VoiceRecordingText = t3.VoiceRecordingText
						local s2

						if not RobloxTranslator then
							s2 = "Mic Off"
						else
							local ok, result = pcall(RobloxTranslator.FormatByKey, RobloxTranslator, "InGame.CommonUI.Label.MicOff")

							s2 = not ok and "Mic Off" or result
						end

						VoiceRecordingText.Text = s2

						return
					end

					local VoiceRecordingText = t3.VoiceRecordingText
					local s3

					if not RobloxTranslator then
						s3 = "Mic On (recording audio)"
					else
						local ok, result = pcall(RobloxTranslator.FormatByKey, RobloxTranslator, "InGame.CommonUI.Label.MicOnRecording")

						s3 = not ok and "Mic On (recording audio)" or result
					end

					VoiceRecordingText.Text = s3
				end)
			end
			local function hideUI() -- line: 828
				-- upvalues: t3 (copy), hideVoiceUx (copy), connection (ref)
				t3.VoiceRecordingText.Visible = false
				hideVoiceUx()

				if connection then
					connection:Disconnect()
				end
			end

			if default.voiceUIVisible then
				showUI()
			end

			default.showVoiceUI.Event:Connect(showUI)
			default.hideVoiceUI.Event:Connect(hideUI)
		end
	end

	if not v107 then
		setupVoiceListeners()
	end

	local u172 = true

	local function setResetEnabled(p30) -- line: 852
		-- upvalues: u172 (ref), t3 (copy)
		u172 = p30

		if t3.ResetCharacterButton then
			t3.ResetCharacterButton.Selectable = p30
			t3.ResetCharacterButton.Active = p30
			t3.ResetCharacterButton.Enabled.Value = p30

			local ResetCharacterHint = t3.ResetCharacterButton:FindFirstChild("ResetCharacterHint")

			if ResetCharacterHint then
				ResetCharacterHint.ImageColor3 = p30 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(100, 100, 100)
			end

			local ResetCharacterButtonTextLabel = t3.ResetCharacterButton:FindFirstChild("ResetCharacterButtonTextLabel")

			if ResetCharacterButtonTextLabel then
				ResetCharacterButtonTextLabel.TextColor3 = p30 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(100, 100, 100)
			end
		end
	end

	local u174 = nil

	function t3.GetRespawnBehaviour(_) -- line: 870
		-- upvalues: t1 (copy), t3 (copy), u172 (ref), u174 (ref)
		if t1.FFlagRelocateMobileMenuButtons and t1.FIntRelocateMobileMenuButtonsVariant ~= 0 then
			return t3:GetExperienceControlStore().getCanRespawn(false), t3:GetExperienceControlStore().getCustomRespawnCallback(false)
		end

		return u172, u174
	end

	t3.RespawnBehaviourChangedEvent = Instance.new("BindableEvent")
	StarterGui:RegisterSetCore("ResetButtonCallback", function(p32) -- line: 880
		-- upvalues: t3 (copy), t1 (copy), u172 (ref), setResetEnabled (copy), InExperienceSideSheet (copy), u174 (ref)
		local v333 = typeof(p32) == "Instance" and p32:IsA("BindableEvent")

		if v333 or type(p32) == "boolean" then
			t3.ResetCharacterPage:SetResetCallback(p32)
		else
			warn("ResetButtonCallback must be set to a BindableEvent or a boolean")
		end

		local v334 = if not t1.FFlagRelocateMobileMenuButtons or t1.FIntRelocateMobileMenuButtonsVariant == 0 then u172 else t3:GetExperienceControlStore().getCanRespawn(false)

		if p32 == false then
			if t1.FFlagRelocateMobileMenuButtons and t1.FIntRelocateMobileMenuButtonsVariant ~= 0 then
				t3:GetExperienceControlStore().setCanRespawn(false)
			else
				setResetEnabled(false)
			end

			if t1.FFlagEnableSideSheet then
				InExperienceSideSheet.setIsRespawnEnabled(false)
			end
		elseif not v334 and (v333 or p32 == true) then
			if t1.FFlagRelocateMobileMenuButtons and t1.FIntRelocateMobileMenuButtonsVariant ~= 0 then
				t3:GetExperienceControlStore().setCanRespawn(true)
			else
				setResetEnabled(true)
			end

			if t1.FFlagEnableSideSheet then
				InExperienceSideSheet.setIsRespawnEnabled(true)
			end
		end

		if v333 then
			if t1.FFlagRelocateMobileMenuButtons and t1.FIntRelocateMobileMenuButtonsVariant ~= 0 then
				t3:GetExperienceControlStore().setCustomRespawnCallback(p32)
			else
				u174 = p32
			end
		end

		if t1.FFlagRelocateMobileMenuButtons and t1.FIntRelocateMobileMenuButtonsVariant ~= 0 then
			t3.RespawnBehaviourChangedEvent:Fire(t3:GetExperienceControlStore().getCanRespawn(false), t3:GetExperienceControlStore().getCustomRespawnCallback(false))

			return
		end

		t3.RespawnBehaviourChangedEvent:Fire(u172, u174)
	end)
	StarterGui:RegisterGetCore("ResetButtonCallback", function() -- line: 921
		-- upvalues: t3 (copy)
		local v335, _ = t3:GetRespawnBehaviour()

		return v335
	end)

	local setVisibilityInternal = nil
	local v176, v177 = createSignal(true)
	local v178, v179 = createSignal(nil)

	function t3.GetExperienceControlStore(_) -- line: 931
		-- upvalues: v177 (copy), t3 (copy), v176 (copy), v178 (copy), v179 (copy), t1 (copy), Constants2 (copy), TelemetryService (copy), MenuLeaveGameTelemetryConfig (copy), MenuResetCharacterTelemetryConfig (copy), RbxAnalyticsService (copy), Constants (copy), MenuResumeTelemetryConfig (copy)
		return {
			getCanRespawn = v176,
			getCustomRespawnCallback = v178,
			setCanRespawn = function(b1: boolean) -- line: 932
				-- upvalues: v177 (copy), t3 (copy)
				v177(b1)

				if t3.ResetCharacterButton then
					t3.ResetCharacterButton.Selectable = b1
					t3.ResetCharacterButton.Active = b1
					t3.ResetCharacterButton.Enabled.Value = b1

					local ResetCharacterHint = t3.ResetCharacterButton:FindFirstChild("ResetCharacterHint")

					if ResetCharacterHint then
						ResetCharacterHint.ImageColor3 = b1 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(100, 100, 100)
					end

					local ResetCharacterButtonTextLabel = t3.ResetCharacterButton:FindFirstChild("ResetCharacterButtonTextLabel")

					if ResetCharacterButtonTextLabel then
						ResetCharacterButtonTextLabel.TextColor3 = b1 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(100, 100, 100)
					end
				end
			end,
			setCustomRespawnCallback = v179,
			onLeaveGame = function(s4: string) -- line: 954
				-- upvalues: t3 (copy), t1 (copy), Constants2 (copy), TelemetryService (copy), MenuLeaveGameTelemetryConfig (copy)
				if not t3:GetVisibility() then
					return
				end

				t3:AddToMenuStack(t3.Pages.CurrentPage)
				t3.HubBar.Visible = false

				if t1.GetFFlagEnableLeaveGameUpsellEntrypoint() and t3.leaveGameUpsellProp ~= Constants2.PHONE_UPSELL_VALUE_PROP.None then
					t3:SwitchToPage(t3.LeaveGameUpsellPage, false)
				else
					t3:SwitchToPage(t3.LeaveGamePage, false, nil, true)
				end

				TelemetryService:LogCounter(MenuLeaveGameTelemetryConfig, {
					customFields = {
						source = s4
					}
				})
			end,
			onRespawn = function(s5: string) -- line: 973
				-- upvalues: v176 (copy), t3 (copy), TelemetryService (copy), MenuResetCharacterTelemetryConfig (copy)
				if not v176(false) then
					return
				end

				t3:AddToMenuStack(t3.Pages.CurrentPage)
				t3.HubBar.Visible = false
				t3:SwitchToPage(t3.ResetCharacterPage, false, nil, true)
				TelemetryService:LogCounter(MenuResetCharacterTelemetryConfig, {
					customFields = {
						source = s5
					}
				})
			end,
			onResume = function(s6: string) -- line: 988
				-- upvalues: t1 (copy), t3 (copy), RbxAnalyticsService (copy), Constants (copy), TelemetryService (copy), MenuResumeTelemetryConfig (copy)
				if t1.FFlagAddUILessMode then
					t3:SetVisibility(false, nil, nil, nil, s6)
				else
					t3:SetVisibility(false)
				end

				if t1.FFlagAddUILessMode and t1.FIntAddUILessModeVariant ~= 0 and t3.uiLessStore.getUILessModeEnabled(false) then
					t3.uiLessStore.setUIVisible(false)
				end

				RbxAnalyticsService:SetRBXEventStream(Constants.AnalyticsTargetName, Constants.AnalyticsResumeGameName, Constants.AnalyticsMenuActionName, {
					source = s6,
					playsessionid = t3.playSessionId,
					universeid = tostring(game.GameId)
				})
				TelemetryService:LogCounter(MenuResumeTelemetryConfig, {
					customFields = {
						source = s6
					}
				})
			end
		}
	end

	local v180 = if not t1.FFlagRelocateMobileMenuButtons or t1.FIntRelocateMobileMenuButtonsVariant == 0 then nil else function() -- line: 1020
		-- upvalues: t3 (copy), ReactRoblox (copy), React (copy), MenuButtonsContainer (copy), Flags (copy), t1 (copy), GuiService (copy)
		if t3.BottomButtonFrameRoot then
			return
		end

		local ExperienceControlStore = t3:GetExperienceControlStore()

		t3.BottomButtonFrameRoot = ReactRoblox.createRoot(t3.BottomButtonFrame)
		t3.BottomButtonFrameRoot:render(React.createElement(MenuButtonsContainer, {
			onLeaveGame = ExperienceControlStore.onLeaveGame,
			onRespawn = ExperienceControlStore.onRespawn,
			onResume = ExperienceControlStore.onResume,
			setAddMenuKeyBindings = function(p34: ((...any) -> ...any)) -- line: 1032
				-- upvalues: t3 (copy)
				t3.addMenuKeyBindings = p34
			end,
			setRemoveMenuKeyBindings = function(p35: ((...any) -> ...any)) -- line: 1036
				-- upvalues: t3 (copy)
				t3.removeMenuKeyBindings = p35
			end,
			getVisibility = function() -- line: 1040
				-- upvalues: t3 (copy)
				return t3.GetVisibility()
			end,
			getCanRespawn = ExperienceControlStore.getCanRespawn,
			currentPageChangeSignal = if not Flags.FFlagAddTraversalHistoryReactMenuButtons then nil else t3.CurrentPageSignal,
			setResumeMenuButton = if not t1.FFlagIEMFocusNavSupportNewButtons then nil else function(p36) -- line: 1045
				-- upvalues: t3 (copy), t1 (copy), GuiService (copy)
				t3.ResumeMenuButton = p36

				if t1.FFlagIEMFocusNavSupportNewButtons and (not GuiService.SelectedCoreObject or not GuiService.SelectedCoreObject:IsDescendantOf(t3.Shield)) then
					GuiService.SelectedCoreObject = p36
				end
			end
		}))
	end
	local v181 = if not t1.FFlagRelocateMobileMenuButtons or t1.FIntRelocateMobileMenuButtonsVariant == 0 then nil else function() -- line: 1056
		-- upvalues: t3 (copy)
		if t3.BottomButtonFrameRoot then
			t3.BottomButtonFrameRoot:unmount()
			t3.BottomButtonFrameRoot = nil
		end
	end

	local function createGui() -- line: 1064
		-- upvalues: Utility (copy), t3 (copy), Create (copy), uDim2_2 (copy), uDim2 (copy), RobloxGui (copy), SHIELD_INACTIVE_POSITION (copy), v56 (copy), v55 (copy), v59 (copy), t1 (copy), Theme (copy), v14 (copy), v117 (copy), RobloxTranslator (copy), GetServerChannelBlocking (copy), u90 (ref), GetServerVersion (ref), RunService (copy), HttpRbxApiService (copy), HttpService (copy), CachedPolicyService (copy), BaseUrl (copy), v86 (copy), StarterPlayer (copy), Players (copy), RbxAnalyticsService (copy), Constants (copy), createReactPage (copy), FFlagIEMFocusNavPeoplePageToButtons (copy), GuiService (copy), getCamMicPermissions (copy), default (copy), Roact (copy), RoactAppExperiment (copy), IXPService (copy), AppStyleProvider (copy), Dark (copy), MenuBackButton (copy), MenuFrontButton (copy), AppFonts (copy), Otter (copy), t2 (copy), UserInputService (copy), setVisibilityInternal (ref), v180 (copy), CorePackages (copy), InExperienceAppChatModal (copy), removeBottomBarBindings (copy), Constants2 (copy), InExperienceCapabilities (copy), addBottomBarButtonOld (copy), ImageForKeyCode2 (ref), u172 (ref), v161 (copy), ImageForKeyCode3 (ref), ImageForKeyCode4 (copy), ImageForKeyCode (ref), ReactRoblox (copy), React (copy), FoundationProvider (copy), Foundation (copy), Utils (copy), SwitchTabHint (copy), isSubjectToDesktopPolicies (copy), SettingsFullScreenTitleBar (copy)
		local n1 = 0

		if Utility:IsSmallTouchScreen() then
			n1 = 5
		end

		t3.ClippingShield = Create("Frame")({
			Name = "SettingsClippingShield",
			BorderSizePixel = 0,
			ClipsDescendants = true,
			BackgroundTransparency = 1,
			Visible = true,
			ZIndex = 2,
			Size = uDim2_2,
			Position = uDim2,
			Parent = RobloxGui
		})
		t3.CanvasGroup = Create("CanvasGroup")({
			Name = "CanvasGroup",
			BackgroundTransparency = 1,
			GroupTransparency = 0,
			Visible = false,
			Size = UDim2.fromScale(1, 1),
			Parent = t3.ClippingShield
		})
		t3.Shield = Create("ImageButton")({
			Name = "SettingsShield",
			BorderSizePixel = 0,
			Visible = false,
			Active = true,
			ZIndex = 2,
			Size = UDim2.new(1, 0, 1, 0),
			Position = SHIELD_INACTIVE_POSITION,
			BackgroundTransparency = v56,
			BackgroundColor3 = v55,
			Parent = t3.ClippingShield
		})
		t3.VRShield = Create("Frame")({
			Name = "VRBackground",
			BorderSizePixel = 0,
			Visible = false,
			Parent = t3.Shield,
			BackgroundColor3 = v55,
			BackgroundTransparency = v56,
			Position = UDim2.new(0, -4, 0, 24),
			Size = UDim2.new(1, 8, 1, -40)
		})

		local EngineFeature2 = game:GetEngineFeature("CoreScriptVersionEnabled")

		if EngineFeature2 then
			t3.VersionContainer = Create("ScrollingFrame")({
				Name = "VersionContainer",
				BorderSizePixel = 0,
				AutoLocalize = false,
				ScrollBarThickness = 0,
				ZIndex = 5,
				Visible = false,
				Parent = t3.Shield,
				CanvasSize = UDim2.new(0, 0, 0, v59),
				BackgroundColor3 = v55,
				BackgroundTransparency = v56,
				Position = UDim2.new(0, 0, 1, 0),
				Size = UDim2.new(1, 0, 0, v59),
				AnchorPoint = Vector2.new(0, 1),
				ScrollingDirection = Enum.ScrollingDirection.X
			})
		else
			t3.VersionContainer = Create("Frame")({
				Name = "VersionContainer",
				BorderSizePixel = 0,
				AutoLocalize = false,
				ZIndex = 5,
				Visible = false,
				Parent = t3.Shield,
				BackgroundColor3 = v55,
				BackgroundTransparency = v56,
				Position = UDim2.new(0, 0, 1, 0),
				Size = UDim2.new(1, 0, 0, v59),
				AnchorPoint = Vector2.new(0, 1)
			})
		end

		local v341 = Create("UIListLayout")({
			Name = "VersionContainer",
			Parent = t3.VersionContainer,
			Padding = UDim.new(0, 6),
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		})

		local function addSizeToLabel(p37) -- line: 1174
			-- upvalues: EngineFeature2 (copy), v59 (copy)
			local uDim2_7 = UDim2.new(0.2, -6, 1, 0)

			p37.Size = EngineFeature2 and UDim2.new(0, p37.TextBounds.X + 6, 0, v59) or uDim2_7
		end

		if t1.GetFFlagDisplayServerChannel() then
			t3.ServerChannelLabel = Create("TextLabel")({
				Name = "ServerChannelLabel",
				LayoutOrder = 3,
				BackgroundTransparency = 1,
				Text = "Server Channel: ...",
				ZIndex = 5,
				Parent = t3.VersionContainer,
				TextColor3 = Color3.new(1, 1, 1),
				TextSize = Theme.textSize(if not v14 then not Utility:IsSmallTouchScreen() and 20 or 14 else 28),
				Font = Theme.font(Enum.Font.SourceSans, "SettingsHub"),
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center
			})
			spawn(function() -- line: 1193
				-- upvalues: v117 (copy), RobloxTranslator (copy), t3 (copy), GetServerChannelBlocking (copy), EngineFeature2 (copy), v59 (copy)
				local s7 = "Server Channel: "

				if v117 then
					if not RobloxTranslator then
						s7 = "Server Channel: "
					else
						local ok, result = pcall(RobloxTranslator.FormatByKey, RobloxTranslator, "InGame.HelpMenu.Label.ServerChannel")

						s7 = not ok and "Server Channel: " or result
					end
				end

				t3.ServerChannelLabel.Text = s7 .. GetServerChannelBlocking()

				local ServerChannelLabel = t3.ServerChannelLabel
				local uDim2_8 = UDim2.new(0.2, -6, 1, 0)

				ServerChannelLabel.Size = EngineFeature2 and UDim2.new(0, ServerChannelLabel.TextBounds.X + 6, 0, v59) or uDim2_8
				t3.ServerChannelLabel.TextScaled = not (EngineFeature2 or t3.ServerChannelLabel.TextFits)
			end)
		end

		t3.ServerVersionLabel = Create("TextLabel")({
			Name = "ServerVersionLabel",
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Text = "Server Version: ...",
			ZIndex = 5,
			Parent = t3.VersionContainer,
			TextColor3 = Color3.new(1, 1, 1),
			TextSize = Theme.textSize(if not v14 then not Utility:IsSmallTouchScreen() and 20 or 14 else 28),
			Font = Theme.font(Enum.Font.SourceSans, "SettingsHub"),
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center
		})
		spawn(function() -- line: 1217
			-- upvalues: v117 (copy), RobloxTranslator (copy), t3 (copy), u90 (ref), GetServerVersion (ref), EngineFeature2 (copy), v59 (copy)
			local s8 = "Server Version: "

			if v117 then
				if not RobloxTranslator then
					s8 = "Server Version: "
				else
					local ok, result = pcall(RobloxTranslator.FormatByKey, RobloxTranslator, "InGame.HelpMenu.Label.ServerVersion")

					s8 = not ok and "Server Version: " or result
				end
			end

			local ServerVersionLabel = t3.ServerVersionLabel
			local v621

			if u90 then
				v621 = u90
			else
				if not GetServerVersion then
					repeat
						wait()
					until GetServerVersion
				end

				u90 = GetServerVersion:InvokeServer()
				v621 = u90
			end

			ServerVersionLabel.Text = s8 .. v621

			local ServerVersionLabel2 = t3.ServerVersionLabel
			local uDim2_9 = UDim2.new(0.2, -6, 1, 0)

			ServerVersionLabel2.Size = EngineFeature2 and UDim2.new(0, ServerVersionLabel2.TextBounds.X + 6, 0, v59) or uDim2_9
			t3.ServerVersionLabel.TextScaled = not (EngineFeature2 or t3.ServerVersionLabel.TextFits)
		end)

		local s9 = "Client Version: "

		if v117 then
			if not RobloxTranslator then
				s9 = "Client Version: "
			else
				local ok, result = pcall(RobloxTranslator.FormatByKey, RobloxTranslator, "InGame.HelpMenu.Label.ClientVersion")

				s9 = not ok and "Client Version: " or result
			end
		end

		local RobloxVersion = RunService:GetRobloxVersion()
		local ok, result = pcall(function() -- line: 1233
			-- upvalues: RunService (copy)
			return RunService.ClientGitHash
		end)

		if ok then
			RobloxVersion = string.format("%s (%.6s)", RobloxVersion, result)
		end

		t3.ClientVersionLabel = Create("TextLabel")({
			Name = "ClientVersionLabel",
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			ZIndex = 5,
			Parent = t3.VersionContainer,
			TextColor3 = Color3.new(1, 1, 1),
			TextSize = Theme.textSize(if not v14 then not Utility:IsSmallTouchScreen() and 20 or 14 else 28),
			Text = s9 .. RobloxVersion,
			Font = Theme.font(Enum.Font.SourceSans, "SettingsHub"),
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center
		})

		local ClientVersionLabel = t3.ClientVersionLabel
		local uDim2_10 = UDim2.new(0.2, -6, 1, 0)

		ClientVersionLabel.Size = EngineFeature2 and UDim2.new(0, ClientVersionLabel.TextBounds.X + 6, 0, v59) or uDim2_10
		t3.ClientVersionLabel.TextScaled = not (EngineFeature2 or t3.ClientVersionLabel.TextFits)
		t3.PlaceVersionLabel = Create("TextLabel")({
			Name = "PlaceVersionLabel",
			BackgroundTransparency = 1,
			LayoutOrder = 3,
			Text = "Place Version: ...",
			ZIndex = 5,
			Parent = t3.VersionContainer,
			TextColor3 = Color3.new(1, 1, 1),
			TextSize = Theme.textSize(if not v14 then not Utility:IsSmallTouchScreen() and 20 or 14 else 28),
			Font = Theme.font(Enum.Font.SourceSans, "SettingsHub"),
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center
		})

		local function setPlaceVersionText() -- line: 1270
			-- upvalues: v117 (copy), RobloxTranslator (copy), t3 (copy), t1 (copy), HttpRbxApiService (copy), HttpService (copy), EngineFeature2 (copy), v59 (copy)
			local s10 = "Place Version: "

			if v117 then
				if not RobloxTranslator then
					s10 = "Place Version: "
				else
					local ok2, result2 = pcall(RobloxTranslator.FormatByKey, RobloxTranslator, "InGame.HelpMenu.Label.PlaceVersion")

					s10 = not ok2 and "Place Version: " or result2
				end
			end

			local PlaceVersionLabel = t3.PlaceVersionLabel
			local PlaceVersion

			if t1.GetFFlagRemoveAssetVersionEndpoint() then
				PlaceVersion = game.PlaceVersion
			else
				local PlaceVersion2 = game.PlaceVersion

				pcall(function() -- line: 363
					-- upvalues: HttpRbxApiService (copy), HttpService (copy), PlaceVersion2 (ref)
					local Async = HttpRbxApiService:GetAsync(string.format("assets/%d/versions", game.PlaceId))
					local VersionNumber = HttpService:JSONDecode(Async)[1].VersionNumber

					PlaceVersion2 = string.format("%s (Latest: %d)", PlaceVersion2, VersionNumber)
				end)
				PlaceVersion = PlaceVersion2
			end

			PlaceVersionLabel.Text = s10 .. PlaceVersion

			local PlaceVersionLabel2 = t3.PlaceVersionLabel
			local uDim2_11 = UDim2.new(0.2, -6, 1, 0)

			PlaceVersionLabel2.Size = EngineFeature2 and UDim2.new(0, PlaceVersionLabel2.TextBounds.X + 6, 0, v59) or uDim2_11
			t3.PlaceVersionLabel.TextScaled = not (EngineFeature2 or t3.PlaceVersionLabel.TextFits)
		end

		game:GetPropertyChangedSignal("PlaceVersion"):Connect(setPlaceVersionText)
		spawn(setPlaceVersionText)

		if not CachedPolicyService:IsSubjectToChinaPolicies() then
			t3.EnvironmentLabel = Create("TextLabel")({
				Name = "EnvironmentLabel",
				BackgroundTransparency = 1,
				LayoutOrder = 4,
				ZIndex = 5,
				Parent = t3.VersionContainer,
				AnchorPoint = Vector2.new(0.5, 0),
				TextColor3 = Color3.new(1, 1, 1),
				TextSize = Theme.textSize(if not v14 then not Utility:IsSmallTouchScreen() and 20 or 14 else 28),
				Text = BaseUrl,
				Font = Theme.font(Enum.Font.SourceSans, "SettingsHub"),
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				Visible = v86
			})

			local EnvironmentLabel = t3.EnvironmentLabel
			local uDim2_12 = UDim2.new(0.2, -6, 1, 0)

			EnvironmentLabel.Size = EngineFeature2 and UDim2.new(0, EnvironmentLabel.TextBounds.X + 6, 0, v59) or uDim2_12
			t3.EnvironmentLabel.TextScaled = not (EngineFeature2 or t3.EnvironmentLabel.TextFits)
		end

		if game:GetEngineFeature("GetPlaySessionIdEnabled") then
			local PlaySessionId = game:GetPlaySessionId()

			if PlaySessionId ~= "" then
				local v355 = "PlaySessionId: " .. PlaySessionId

				if RobloxTranslator then
					v355 = RobloxTranslator:FormatByKey("InGame.HelpMenu.Label.PlaySessionId", {
						RBX_STR = PlaySessionId
					})
				end

				t3.PlaySessionIdLabel = Create("TextLabel")({
					Name = "PlaySessionIdLabel",
					BackgroundTransparency = 1,
					LayoutOrder = 5,
					ZIndex = 5,
					Parent = t3.VersionContainer,
					TextColor3 = Color3.new(1, 1, 1),
					TextSize = Theme.textSize(if not v14 then not Utility:IsSmallTouchScreen() and 20 or 14 else 28),
					Text = v355,
					Font = Theme.font(Enum.Font.SourceSans, "SettingsHub"),
					TextXAlignment = Enum.TextXAlignment.Center,
					TextYAlignment = Enum.TextYAlignment.Center
				})

				local PlaySessionIdLabel = t3.PlaySessionIdLabel
				local uDim2_13 = UDim2.new(0.2, -6, 1, 0)

				PlaySessionIdLabel.Size = EngineFeature2 and UDim2.new(0, PlaySessionIdLabel.TextBounds.X + 6, 0, v59) or uDim2_13
				t3.PlaySessionIdLabel.TextScaled = not t3.PlaySessionIdLabel.TextFits
			end
		end

		local function getOverridesPlayerScripts() -- line: 1332
			-- upvalues: t1 (copy), StarterPlayer (copy), v117 (copy), RobloxTranslator (copy)
			if t1.EngineFeaturePlayerScriptStatusProperty then
				return ({
					[0] = "Unknown",
					[1] = "v3 Custom",
					[2] = "v3 Default",
					[3] = "v1 Custom",
					[4] = "v2 Default",
					[5] = "v2 Custom"
				})[StarterPlayer.PlayerModuleStatus]
			end

			local StarterPlayerScripts = StarterPlayer:WaitForChild("StarterPlayerScripts", if not t1.FFlagRemoveLoadingTimeout then nil else 1e999)
			local PlayerScriptsLoader = StarterPlayerScripts:FindFirstChild("PlayerScriptsLoader")
			local PlayerModule = StarterPlayerScripts:FindFirstChild("PlayerModule")

			if PlayerModule and PlayerScriptsLoader and not PlayerModule.Archivable then
				if PlayerScriptsLoader.Archivable then
					if v117 then
						if not RobloxTranslator then
							return "Possibly Custom"
						end

						local ok3, result3 = pcall(RobloxTranslator.FormatByKey, RobloxTranslator, "InGame.CommonUI.Label.PossiblyCustom")

						if ok3 then
							return result3
						end

						return "Possibly Custom"
					end

					return "Possibly Custom"
				end

				if v117 then
					if not RobloxTranslator then
						return "Default"
					end

					local ok4, result4 = pcall(RobloxTranslator.FormatByKey, RobloxTranslator, "InGame.CommonUI.Label.Default")

					if ok4 then
						return result4
					end

					return "Default"
				end

				return "Default"
			end

			local CameraScript = StarterPlayerScripts:FindFirstChild("CameraScript")
			local ControlScript = StarterPlayerScripts:FindFirstChild("ControlScript")

			if CameraScript or ControlScript then
				if v117 then
					if not RobloxTranslator then
						return "Custom Old"
					end

					local ok5, result5 = pcall(RobloxTranslator.FormatByKey, RobloxTranslator, "InGame.CommonUI.Label.CustomOld")

					if ok5 then
						return result5
					end

					return "Custom Old"
				end

				return "Custom Old"
			end

			if v117 then
				if not RobloxTranslator then
					return "Custom"
				end

				local ok6, result6 = pcall(RobloxTranslator.FormatByKey, RobloxTranslator, "InGame.CommonUI.Label.Custom")

				if ok6 then
					return result6
				end

				return "Custom"
			end

			return "Custom"
		end

		t3.OverridesPlayerScriptsLabel = Create("TextLabel")({
			Name = "OverridesPlayerScriptsLabel",
			BackgroundTransparency = 1,
			LayoutOrder = 5,
			Text = "PlayerScripts: ",
			ZIndex = 5,
			Visible = false,
			Parent = t3.VersionContainer,
			AnchorPoint = Vector2.new(0.5, 0),
			TextColor3 = Color3.new(1, 1, 1),
			TextSize = Theme.textSize(if not v14 then not Utility:IsSmallTouchScreen() and 20 or 14 else 28),
			Font = Theme.font(Enum.Font.SourceSans, "SettingsHub"),
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center
		})
		spawn(function() -- line: 1399
			-- upvalues: RobloxGui (copy), Players (copy), v117 (copy), RobloxTranslator (copy), getOverridesPlayerScripts (copy), t1 (copy), RbxAnalyticsService (copy), Constants (copy), t3 (copy), v86 (copy), EngineFeature2 (copy), v59 (copy)
			local PlayerPermissionsModule = require(RobloxGui.Modules.PlayerPermissionsModule)

			if not Players.LocalPlayer then
				Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
			end

			local s11 = "PlayerScripts: "

			if v117 then
				if not RobloxTranslator then
					s11 = "PlayerScripts: "
				else
					local ok7, result7 = pcall(RobloxTranslator.FormatByKey, RobloxTranslator, "InGame.HelpMenu.Label.PlayerScripts")

					s11 = not ok7 and "PlayerScripts: " or result7
				end
			end

			local v649 = getOverridesPlayerScripts()
			local v650 = if not t1.EngineFeaturePlayerScriptStatusProperty then v649 == "Default" else v649 == "v3 Default"

			RbxAnalyticsService:setRBXEventStream(Constants.AnalyticsTargetName, "player_scripts_status", "player_scripts_status_action", {
				defaultPlayerScripts = v650,
				placeID = tostring(game.PlaceId),
				rawValue = if not t1.GetFFlagNewEventIngestPlayerScriptsDimensions() then nil else v649,
				context = if not t1.GetFFlagNewEventIngestPlayerScriptsDimensions() then nil else "IGMv1"
			})
			t3.OverridesPlayerScriptsLabel.Text = s11 .. v649
			t3.OverridesPlayerScriptsLabel.Visible = v86 or PlayerPermissionsModule.IsPlayerAdminAsync(Players.LocalPlayer)

			local OverridesPlayerScriptsLabel = t3.OverridesPlayerScriptsLabel
			local uDim2_14 = UDim2.new(0.2, -6, 1, 0)

			OverridesPlayerScriptsLabel.Size = EngineFeature2 and UDim2.new(0, OverridesPlayerScriptsLabel.TextBounds.X + 6, 0, v59) or uDim2_14
			t3.OverridesPlayerScriptsLabel.TextScaled = not (EngineFeature2 or t3.OverridesPlayerScriptsLabel.TextFits)
		end)

		if EngineFeature2 then
			local s12 = "Client CoreScript Version: "

			if v117 then
				if not RobloxTranslator then
					s12 = "Client CoreScript Version: "
				else
					local ok8, result8 = pcall(RobloxTranslator.FormatByKey, RobloxTranslator, "InGame.HelpMenu.Label.ClientCoreScriptVersion")

					s12 = not ok8 and "Client CoreScript Version: " or result8
				end
			end

			t3.CoreScriptVersionLabel = Create("TextLabel")({
				Name = "CoreScriptVersionLabel",
				LayoutOrder = 6,
				BackgroundTransparency = 1,
				ZIndex = 5,
				Parent = t3.VersionContainer,
				TextColor3 = Color3.new(1, 1, 1),
				TextSize = Theme.textSize(if not v14 then not Utility:IsSmallTouchScreen() and 20 or 14 else 28),
				Text = s12 .. RunService:GetCoreScriptVersion(),
				Font = Theme.font(Enum.Font.SourceSans, "SettingsHub"),
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center
			})

			local CoreScriptVersionLabel = t3.CoreScriptVersionLabel
			local uDim2_15 = UDim2.new(0.2, -6, 1, 0)

			CoreScriptVersionLabel.Size = EngineFeature2 and UDim2.new(0, CoreScriptVersionLabel.TextBounds.X + 6, 0, v59) or uDim2_15

			local VersionContainer = t3.VersionContainer

			v341:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- line: 1449
				-- upvalues: VersionContainer (copy), v341 (copy), v59 (copy)
				VersionContainer.CanvasSize = UDim2.new(0, v341.AbsoluteContentSize.X, 0, v59)
			end)
		end

		t3.Modal = Create("TextButton")({
			Name = "Modal",
			BackgroundTransparency = 1,
			Modal = true,
			Text = "",
			Selectable = false,
			Position = UDim2.new(0, 0, 1, -1),
			Size = UDim2.new(1, 0, 1, 0),
			Parent = t3.Shield
		})

		if t1.FFlagSettingsHubIndependentBackgroundVisibility then
			t3.DarkenBackground = Create("ImageButton")({
				Name = "DarkenBackground",
				BackgroundTransparency = 1,
				AutoButtonColor = false,
				Visible = false,
				ZIndex = t3.Shield.ZIndex - 1,
				BackgroundColor3 = if not t1.isInExperienceUIVREnabled then Theme.color("DarkenBackground") else t3.SettingsUIDelegate:getDarkBackgroundTheme().Color,
				Size = UDim2.new(1, 0, 1, 0),
				Parent = t3.ClippingShield
			})
		else
			t3.DarkenBackground = Create("Frame")({
				Name = "DarkenBackground",
				BackgroundTransparency = 1,
				ZIndex = t3.Shield.ZIndex - 1,
				BackgroundColor3 = Theme.color("DarkenBackground"),
				Size = UDim2.new(1, 0, 1, 0),
				Parent = t3.ClippingShield
			})
		end

		local v365 = Theme.MenuContainerPosition(t3.SettingsUIDelegate)

		t3.MenuContainer = Create("ImageButton")({
			Name = "MenuContainer",
			ZIndex = t3.Shield.ZIndex,
			BackgroundTransparency = Theme.transparency("MenuContainer", 1),
			BackgroundColor3 = Theme.color("MenuContainer"),
			Position = v365.Position,
			Size = v365.Size,
			AnchorPoint = v365.AnchorPoint,
			AutomaticSize = v365.AutomaticSize,
			Parent = t3.Shield
		})

		if t1.FFlagCreateInExperienceMenuReact then
			t3.ReactPage.Parent = t3.MenuContainer
		else
			t3.ReactPage = createReactPage(t3.MenuContainer)
		end

		t3.Page = Create("Frame")({
			Name = "Page",
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY,
			Parent = t3.MenuContainer
		})

		if FFlagIEMFocusNavPeoplePageToButtons then
			t3.Page.SelectionGroup = true
			t3.Page.SelectionBehaviorUp = Enum.SelectionBehavior.Stop
			t3.Page.SelectionBehaviorDown = Enum.SelectionBehavior.Stop
			t3.Page.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop
			t3.Page.SelectionBehaviorRight = Enum.SelectionBehavior.Stop
		end

		local Page = t3.Page

		t3.MenuContainerPadding = Create("UIPadding")({
			Parent = Page
		})

		if not v14 then
			local _ = GuiService:GetGuiInset().Y

			t3.MenuContainerPadding.PaddingTop = UDim.new(0, 0)
		end

		local v368 = Theme.HubPadding()

		t3.MenuContainer.AutoButtonColor = false
		t3.MenuContainerPadding.PaddingLeft = v368.PaddingLeft
		t3.MenuContainerPadding.PaddingRight = v368.PaddingRight
		t3.MenuContainerPadding.PaddingBottom = v368.PaddingBottom
		t3.MenuContainerPadding.PaddingTop = v368.PaddingTop
		Create("UICorner")({
			CornerRadius = Theme.MenuContainerCornerRadius,
			Parent = t3.MenuContainer
		})
		getCamMicPermissions(function(p38) -- line: 1559
			-- upvalues: t3 (copy)
			t3.hasMicPermissions = p38.hasMicPermissions
			t3.isFetchingMicPermissions = false
		end, nil, true)
		t3.SettingsShowSignal:connect(function(p39) -- line: 1565
			-- upvalues: default (copy), t1 (copy), t3 (copy)
			if p39 then
				if default:IsSeamlessVoice() and not default.voiceUIVisible then
					if t1.FFlagVoiceRewarmTelemetry then
						local v655, v656, v657, v658 = default:GetConnectDisconnectButtonAnalyticsData(true)

						default.Analytics:reportJoinVoiceButtonEventWithVoiceSessionId("shown", v655, v656, v657, v658, default.joinVoiceButtonContext)
					else
						default.Analytics:reportJoinVoiceButtonEventWithVoiceSessionId("shown", default:GetConnectDisconnectButtonAnalyticsData(true))
					end
				elseif default:IsSeamlessVoice() and default.voiceUIVisible then
					default.Analytics:reportLeaveVoiceButtonEvent("shown", default:GetConnectDisconnectButtonAnalyticsData(true))
				end

				if default:UserVoiceEnabled() and t3.isFetchingMicPermissions then
					return
				end

				if not default:UserOnlyEligibleForVoice() and (not default:UserVoiceEnabled() or t3.hasMicPermissions) then
					return
				end
			end
		end)
		t3.MenuListLayout = Create("UIListLayout")({
			Name = "MenuListLayout",
			FillDirection = Enum.FillDirection.Vertical,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = Page
		})
		t3.HubBar = Create("ImageLabel")({
			Name = "HubBar",
			BorderSizePixel = 0,
			LayoutOrder = 0,
			BackgroundColor3 = Theme.color("HubBarContainer"),
			BackgroundTransparency = Theme.transparency("HubBarContainerTransparency"),
			ZIndex = t3.Shield.ZIndex + 1,
			AnchorPoint = Vector2.new(0.5, 0),
			Parent = Page
		})

		if not t1.FFlagEnableSideSheet then
			Create("Frame")({
				BorderSizePixel = 0,
				BackgroundColor3 = Theme.color("Divider"),
				BackgroundTransparency = Theme.transparency("Divider"),
				Size = UDim2.new(1, 0, 0, 1),
				Position = UDim2.new(0, 0, 1, 0),
				AnchorPoint = Vector2.new(0, 1),
				Parent = t3.HubBar
			})
		end

		if t1.FFlagEnableSideSheet then
			t3.PageTitleHeader = Create("Frame")({
				Name = "PageTitleHeader",
				BackgroundTransparency = 1,
				LayoutOrder = 0,
				Size = UDim2.new(1, 0, 1, 0),
				Parent = t3.HubBar,
				ZIndex = t3.Shield.ZIndex + 1
			})
			Create("UIPadding")({
				PaddingLeft = UDim.new(0, 12),
				PaddingRight = UDim.new(0, 12),
				Parent = t3.PageTitleHeader
			})

			if not t1.FFlagImprovePageTitleCloseButton then
				t3.PageTitleCloseButton = Create("ImageButton")({
					Name = "PageTitleCloseButton",
					BackgroundTransparency = 1,
					Image = "rbxasset://textures/ui/InspectMenu/x.png",
					Size = UDim2.new(0, 16, 0, 16),
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, 0, 0.5, 0),
					Parent = t3.PageTitleHeader
				})
			end

			t3.PageTitleLabel = Create("TextLabel")({
				Name = "Title",
				BackgroundTransparency = 1,
				Text = "",
				Size = UDim2.new(1, -36, 0, 0),
				Position = UDim2.new(0, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				AutomaticSize = Enum.AutomaticSize.Y,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextColor3 = Color3.new(1, 1, 1),
				Font = Theme.font(Enum.Font.SourceSansBold, "Confirmation"),
				FontSize = Theme.fontSize(Enum.FontSize.Size36, "Confirmation"),
				Parent = t3.PageTitleHeader
			})
		end

		t3.HubBarListLayout = Create("UIListLayout")({
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = t3.HubBar
		})

		if not t1.FFlagAddTraversalBackButton then
			if t1.EngineFeatureTeleportHistoryButtons then
				t3.BackBarRef = Roact.createRef()
				t3.FrontBarRef = Roact.createRef()
				t3.BackBar = Roact.createElement(RoactAppExperiment.Provider, {
					value = IXPService
				}, {
					AppStyleProvider = Roact.createElement(AppStyleProvider, {
						style = {
							themeName = Dark
						}
					}, {
						ButtonsFrame = Roact.createElement("Frame", {
							BackgroundTransparency = 1,
							LayoutOrder = -1,
							AutomaticSize = Enum.AutomaticSize.Y,
							Size = UDim2.new(1, 0, 0, 0)
						}, {
							BackButton = Roact.createElement(MenuBackButton, {
								LayoutOrder = 1,
								BackBarRef = t3.BackBarRef,
								HubBar = t3.HubBar
							}),
							FrontButton = Roact.createElement(MenuFrontButton, {
								LayoutOrder = 2,
								FrontBarRef = t3.FrontBarRef,
								HubBar = t3.HubBar
							})
						})
					})
				})
				Roact.mount(t3.BackBar, Page, "BackBar")
			else
				t3.BackBarRef = Roact.createRef()
				t3.BackBar = Roact.createElement(RoactAppExperiment.Provider, {
					value = IXPService
				}, {
					AppStyleProvider = Roact.createElement(AppStyleProvider, {
						style = {
							themeName = Dark
						}
					}, {
						BackButton = Roact.createElement(MenuBackButton, {
							BackBarRef = t3.BackBarRef,
							HubBar = t3.HubBar
						})
					})
				})
				Roact.mount(t3.BackBar, Page, "BackBar")
			end
		end

		if Utility:IsSmallTouchScreen() then
			t3.HubBar.Size = UDim2.new(0, RobloxGui.AbsoluteSize.X - 100, 0, 50)
			t3.HubBar.Position = UDim2.new(0.5, 0, 0, 6)
		elseif v14 then
			t3.HubBar.Size = UDim2.new(0, 1200, 0, 100)
			t3.HubBar.Position = UDim2.new(0.5, 0, 0.1, 0)
		else
			t3.HubBar.Size = UDim2.new(0, 800, 0, 60)
			t3.HubBar.Position = UDim2.new(0.5, 0, 0.1, 0)
		end

		t3.VoiceRecordingIndicatorFrame = Create("Frame")({
			BackgroundTransparency = 1,
			Size = if not t1.ChromeEnabled then UDim2.fromOffset(0, 100) else UDim2.new(1, 0, 0, 100),
			Position = UDim2.new(0, 0, 0, 0),
			Parent = t3.HubBar
		})
		t3.VoiceRecordingText = Create("TextLabel")({
			Text = "",
			Visible = false,
			TextSize = 12,
			BackgroundTransparency = 1,
			Parent = t3.VoiceRecordingIndicatorFrame,
			Position = UDim2.new(0, 60, 0, 0),
			Font = AppFonts.default:getMedium(),
			Size = UDim2.fromScale(1, 1),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextColor3 = Color3.fromRGB(255, 255, 255)
		})

		if Utility:IsSmallTouchScreen() then
			t3.VoiceRecordingText.Size = UDim2.fromScale(1, 1)
			t3.VoiceRecordingText.AnchorPoint = Vector2.new(0, 0)

			if t1.ChromeEnabled then
				t3.VoiceRecordingText.TextXAlignment = Enum.TextXAlignment.Right
				t3.VoiceRecordingText.Position = UDim2.new(0, 0, 0, -60)
			else
				t3.VoiceRecordingText.Position = UDim2.new(0, 60, 0, -60)
			end
		elseif v14 then
			t3.VoiceRecordingText.AnchorPoint = Vector2.new(0, 1)

			if t1.ChromeEnabled then
				t3.VoiceRecordingText.TextXAlignment = Enum.TextXAlignment.Right
				t3.VoiceRecordingText.Size = UDim2.new(1, 0, 0, 100)
				t3.VoiceRecordingText.Position = UDim2.new(0, 0, 0.1, 0)
			else
				t3.VoiceRecordingText.Size = UDim2.new(0, 1200, 0, 100)
				t3.VoiceRecordingText.Position = UDim2.new(0.5, 0, 0.1, 0)
			end
		else
			t3.VoiceRecordingText.AnchorPoint = Vector2.new(0, 1)

			if t1.ChromeEnabled then
				t3.VoiceRecordingText.TextXAlignment = Enum.TextXAlignment.Right
				t3.VoiceRecordingText.Size = UDim2.new(1, 0, 0, 60)
				t3.VoiceRecordingText.Position = UDim2.new(0, 0, 0.1, 0)
			else
				t3.VoiceRecordingText.Size = UDim2.new(0, 800, 0, 60)
				t3.VoiceRecordingText.Position = UDim2.new(0.5, 0, 0.1, 0)
			end
		end

		t3.voiceRecordingIndicatorTextMotor = Otter.createSingleMotor(0)
		t3.voiceRecordingIndicatorTextMotor:onStep(function(p40) -- line: 1806
			-- upvalues: t3 (copy)
			t3.VoiceRecordingText.TextTransparency = p40
		end)
		spawn(function() -- line: 1810
			-- upvalues: RunService (copy), t3 (copy), Otter (copy), t2 (copy)
			RunService:BindToRenderStep("VoiceRecordingIndicator", 1, function() -- line: 1811
				-- upvalues: t3 (copy), Otter (copy), t2 (copy)
				if t3.isMuted ~= nil and (t3.lastVoiceRecordingIndicatorTextUpdated ~= nil and tick() - t3.lastVoiceRecordingIndicatorTextUpdated >= 5 and t3.isMuted) then
					t3.voiceRecordingIndicatorTextMotor:setGoal(Otter.spring(1, t2))
					t3.voiceRecordingIndicatorTextMotor:start()
				end
			end)
		end)
		t3.PageViewClipper = Create("Frame")({
			Name = "PageViewClipper",
			BackgroundTransparency = 1,
			Size = UDim2.new(t3.HubBar.Size.X.Scale, t3.HubBar.Size.X.Offset, 1, -t3.HubBar.Size.Y.Offset - t3.HubBar.Position.Y.Offset - n1),
			Position = UDim2.new(t3.HubBar.Position.X.Scale, t3.HubBar.Position.X.Offset, t3.HubBar.Position.Y.Scale, t3.HubBar.Position.Y.Offset + t3.HubBar.Size.Y.Offset + 1),
			AnchorPoint = Vector2.new(0.5, 0),
			ClipsDescendants = true,
			LayoutOrder = 1,
			Parent = Page,
			SelectionGroup = not not t1.FFlagIGMSelectionGroup or nil,
			SelectionBehaviorLeft = if not t1.FFlagIGMSelectionGroup then nil else Enum.SelectionBehavior.Stop,
			SelectionBehaviorRight = if not t1.FFlagIGMSelectionGroup then nil else Enum.SelectionBehavior.Stop,
			SelectionBehaviorDown = if not t1.FFlagIGMSelectionGroup then nil else Enum.SelectionBehavior.Escape,
			SelectionBehaviorUp = if not t1.FFlagIGMSelectionGroup then nil else Enum.SelectionBehavior.Escape,
			if not t1.FFlagIGMSelectionGroup then Create("ImageButton")({
				Name = "InputCapture",
				BackgroundTransparency = 1,
				Image = "",
				Size = UDim2.new(1, 0, 1, 0)
			}) else nil
		})

		if t1.FFlagEnableConsoleExpControls and t1.ChromeEnabled then
			t3.PageViewPadding = Create("UIPadding")({
				Parent = t3.PageViewClipper
			})

			local Service = require(RobloxGui.Modules.Chrome.Service)

			Service:onShortcutBarChanged():connect(function() -- line: 1857
				-- upvalues: Utility (copy), Service (copy), t3 (copy), Theme (copy)
				if Utility:IsSmallTouchScreen() and Service:getCurrentShortcutBar():get() ~= nil then
					t3.PageViewPadding.PaddingBottom = UDim.new(0, Theme.ExtraPageBottomPaddingMobile)

					return
				end

				t3.PageViewPadding.PaddingBottom = UDim.new(0, 0)
			end)
		end

		t3.PageView = Create("ScrollingFrame")({
			Name = "PageView",
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Selectable = false,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 2),
			Size = UDim2.new(1, 0, 1, -20),
			CanvasSize = UDim2.new(1, 0, 1, 0),
			ZIndex = t3.Shield.ZIndex,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			ScrollBarThickness = Theme.DefaultScrollBarThickness,
			Parent = t3.PageViewClipper
		})
		t3.PageView.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
		t3.PageViewInnerFrame = Create("Frame")({
			Name = "PageViewInnerFrame",
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Selectable = false,
			LayoutOrder = 1,
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 1, 0),
			ZIndex = t3.Shield.ZIndex,
			Parent = t3.PageView
		})
		Create("UIPadding")({
			PaddingTop = UDim.new(0, 5),
			Parent = t3.PageViewInnerFrame
		})
		t3.InnerCanvasGroupShow = Create("CanvasGroup")({
			Name = "InnerCanvasGroupShow",
			BackgroundTransparency = 1,
			GroupTransparency = 0,
			Visible = false,
			Size = UDim2.fromScale(1, 1),
			Parent = t3.PageViewInnerFrame
		})
		t3.InnerCanvasGroupHide = Create("CanvasGroup")({
			Name = "InnerCanvasGroupHide",
			BackgroundTransparency = 1,
			GroupTransparency = 0,
			Visible = false,
			Size = UDim2.fromScale(1, 1),
			Parent = t3.PageViewInnerFrame
		})

		if UserInputService.MouseEnabled then
			t3.PageViewClipper.Size = UDim2.new(t3.HubBar.Size.X.Scale, t3.HubBar.Size.X.Offset, 0.5, -(t3.HubBar.Position.Y.Offset - t3.HubBar.Size.Y.Offset))
		end

		t3.BottomButtonFrame = Create("Frame")({
			Name = "BottomButtonFrame",
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = t3.HubBar.Size,
			Position = UDim2.new(0.5, -t3.HubBar.Size.X.Offset / 2, 1 - t3.HubBar.Position.Y.Scale - t3.HubBar.Size.Y.Scale, -t3.HubBar.Position.Y.Offset - t3.HubBar.Size.Y.Offset),
			ZIndex = t3.Shield.ZIndex + 1,
			Parent = Page,
			Selectable = not t1.FFlagIEMFocusNavToButtons and nil,
			SelectionGroup = not not t1.FFlagIEMFocusNavToButtons or nil,
			SelectionBehaviorLeft = if not t1.FFlagIEMFocusNavToButtons then nil else Enum.SelectionBehavior.Stop,
			SelectionBehaviorRight = if not t1.FFlagIEMFocusNavToButtons then nil else Enum.SelectionBehavior.Stop,
			SelectionBehaviorDown = if not t1.FFlagIEMFocusNavToButtons then nil else Enum.SelectionBehavior.Stop
		})
		t3.BottomButtonFrame:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 1942
			-- upvalues: t3 (copy)
			t3.setShowBottomBarSignal(t3.BottomButtonFrame.Visible)
		end)

		local function v370(p41) -- line: 1946
			-- upvalues: t1 (copy), setVisibilityInternal (ref), t3 (copy), RbxAnalyticsService (copy), Constants (copy), GuiService (copy)
			if t1.FFlagAddUILessMode then
				setVisibilityInternal(false, nil, nil, nil, p41)
			else
				setVisibilityInternal(false)
			end

			if t1.FFlagAddUILessMode and t1.FIntAddUILessModeVariant ~= 0 and t3.uiLessStore.getUILessModeEnabled(false) then
				t3.uiLessStore.setUIVisible(false)
			end

			RbxAnalyticsService:SetRBXEventStream(Constants.AnalyticsTargetName, Constants.AnalyticsResumeGameName, Constants.AnalyticsMenuActionName, {
				source = p41,
				playsessionid = t3.playSessionId,
				universeid = tostring(game.GameId)
			})

			if t1.FFlagIEMResumeButtonPressBugfix then
				GuiService.SelectedCoreObject = nil
			end
		end

		if t1.FFlagEnableSideSheet then
			if t1.FFlagImprovePageTitleCloseButton then
				t3.PageTitleCloseButton = Utility:MakeStyledImageButton("PageTitleClose", "rbxasset://textures/ui/InspectMenu/x.png", UDim2.new(0, 40, 0, 40), UDim2.new(0, 16, 0, 16), function() -- line: 1979
					-- upvalues: v370 (copy), Constants (copy)
					v370(Constants.AnalyticsResumeXButtonSource)
				end, nil, t3, "DefaultButton")
				t3.PageTitleCloseButton.AnchorPoint = Vector2.new(1, 0.5)
				t3.PageTitleCloseButton.Position = UDim2.new(1, 0, 0.5, 0)

				local Border = t3.PageTitleCloseButton:FindFirstChild("Border")

				if Border then
					Border.Parent = nil
				end

				t3.PageTitleCloseButton.Parent = t3.PageTitleHeader
			else
				t3.PageTitleCloseButton.Activated:Connect(function() -- line: 1996
					-- upvalues: v370 (copy), Constants (copy)
					v370(Constants.AnalyticsResumeXButtonSource)
				end)
			end
		end

		if not t1.FFlagMenuButtonsMountWithIEM and t1.FFlagRelocateMobileMenuButtons and (t1.FIntRelocateMobileMenuButtonsVariant == 1 or t1.FIntRelocateMobileMenuButtonsVariant == 3 or t1.FIntRelocateMobileMenuButtonsVariant == 2 and not Utility:IsSmallTouchScreen()) then
			v180()
		end

		if not t1.FFlagRelocateMobileMenuButtons or t1.FIntRelocateMobileMenuButtonsVariant == 0 or t1.FIntRelocateMobileMenuButtonsVariant == 2 and Utility:IsSmallTouchScreen() then
			t3.BottomButtonFrame.Size = UDim2.new(1, 0, 0, 80)
		end

		t3.MenuListLayout = Create("UIListLayout")({
			Padding = UDim.new(0, 12),
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = t3.BottomButtonFrame
		})

		if t1.FFlagEnableSystemScrimInSettingsHub then
			local v372 = require(CorePackages.Workspace.Packages.SystemScrim).SystemScrimSignalStore(false)

			v372.backgroundScrimActivated.Event:Connect(function() -- line: 2024
				-- upvalues: t1 (copy), t3 (copy), Constants (copy), v370 (copy)
				if t1.FFlagRelocateMobileMenuButtons and t1.FIntRelocateMobileMenuButtonsVariant ~= 0 then
					t3:GetExperienceControlStore().onResume(Constants.AnalyticsResumeShieldSource)

					return
				end

				v370(Constants.AnalyticsResumeShieldSource)
			end)
			t3.Shield:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 2032
				-- upvalues: v372 (copy), t3 (copy)
				v372.setTransparency(1)
				v372.setAutoDismiss(true)
				v372.setVisibility(t3.Shield.Visible)
			end)
		end

		t3.Shield.Activated:Connect(function() -- line: 2039
			-- upvalues: t1 (copy), t3 (copy), Constants (copy), v370 (copy)
			if t1.FFlagRelocateMobileMenuButtons and t1.FIntRelocateMobileMenuButtonsVariant ~= 0 then
				t3:GetExperienceControlStore().onResume(Constants.AnalyticsResumeShieldSource)

				return
			end

			v370(Constants.AnalyticsResumeShieldSource)
		end)

		if t1.FFlagSettingsHubIndependentBackgroundVisibility then
			t3.DarkenBackground.Activated:Connect(function() -- line: 2049
				-- upvalues: t1 (copy), t3 (copy), Constants (copy), v370 (copy), InExperienceAppChatModal (copy)
				if t1.FFlagRelocateMobileMenuButtons and t1.FIntRelocateMobileMenuButtonsVariant ~= 0 then
					t3:GetExperienceControlStore().onResume(Constants.AnalyticsResumeShieldSource)
				else
					v370(Constants.AnalyticsResumeShieldSource)
				end

				InExperienceAppChatModal.default:setVisible(false)
			end)
		end

		if not t1.FFlagRelocateMobileMenuButtons or t1.FIntRelocateMobileMenuButtonsVariant == 0 then
			local function v373() -- line: 2060
				-- upvalues: t1 (copy), t3 (copy), removeBottomBarBindings (copy), Constants2 (copy)
				if t1.FFlagPreventHiddenSwitchPage and t3:GetVisibility() == false then
					return
				end

				t3:AddToMenuStack(t3.Pages.CurrentPage)
				t3.HubBar.Visible = false
				removeBottomBarBindings()

				if t1.GetFFlagEnableLeaveGameUpsellEntrypoint() and t3.leaveGameUpsellProp ~= Constants2.PHONE_UPSELL_VALUE_PROP.None then
					t3:SwitchToPage(t3.LeaveGameUpsellPage, nil, 1, true)

					return
				end

				t3:SwitchToPage(t3.LeaveGamePage, nil, 1, true)
			end

			if InExperienceCapabilities.canNavigateHome then
				addBottomBarButtonOld("LeaveGame", "Leave", ImageForKeyCode2, "rbxasset://textures/ui/Settings/Help/LeaveIcon.png", UDim2.new(0.5, not v14 and -130 or -160, 0.5, -25), v373, {
					Enum.KeyCode.L,
					if not not t1.FFlagEnableConsoleExpControls and t1.ChromeEnabled then nil else Enum.KeyCode.ButtonX
				}, v373)
			end

			local function v374() -- line: 2084
				-- upvalues: u172 (ref), t3 (copy), removeBottomBarBindings (copy)
				if u172 then
					t3:AddToMenuStack(t3.Pages.CurrentPage)
					t3.HubBar.Visible = false
					removeBottomBarBindings()
					t3:SwitchToPage(t3.ResetCharacterPage, nil, 1, true)
				end
			end

			local v375 = v161:Format(Constants.RespawnLocalizedKey)

			addBottomBarButtonOld("ResetCharacter", v375, ImageForKeyCode3, "rbxasset://textures/ui/Settings/Help/ResetIcon.png", UDim2.new(0.5, not v14 and -400 or -550, 0.5, -25), v374, {
				Enum.KeyCode.R,
				if not not t1.FFlagEnableConsoleExpControls and t1.ChromeEnabled then nil else Enum.KeyCode.ButtonY
			}, v374)
			addBottomBarButtonOld("Resume", "Resume", if not t1.FFlagEnableConsoleExpControls then ImageForKeyCode else ImageForKeyCode4, "rbxasset://textures/ui/Settings/Help/EscapeIcon.png", UDim2.new(0.5, not v14 and 140 or 200, 0.5, -25), function() -- line: 2100
				-- upvalues: v370 (copy), Constants (copy)
				v370(Constants.AnalyticsResumeButtonSource)
			end, if not not t1.FFlagEnableConsoleExpControls and t1.ChromeEnabled then {} else {
				Enum.KeyCode.ButtonB,
				Enum.KeyCode.ButtonStart
			}, function() -- line: 2103
				-- upvalues: v370 (copy), Constants (copy)
				v370(Constants.AnalyticsResumeGamepadSource)
			end)
		end

		if t1.FFlagAddSwitchTabHintsToIEM then
			local function MountSwitchTabHint(t4: {[any]: any}) -- line: 2113
				-- upvalues: Create (copy), ReactRoblox (copy), React (copy), FoundationProvider (copy), Foundation (copy), Utils (copy), SwitchTabHint (copy)
				local v662 = Create("Frame")({
					Name = "SwitchTabHintContainer",
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(0, 1),
					AutomaticSize = Enum.AutomaticSize.X,
					LayoutOrder = t4.layoutOrder,
					Parent = t4.parent
				})

				ReactRoblox.createRoot(v662):render(React.createElement(React.Fragment, nil, React.createElement("UIListLayout", {
					Name = "SwitchTabHintCenterAlign",
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center
				}), React.createElement(FoundationProvider, {
					theme = Foundation.Enums.Theme.Dark,
					device = Utils.getDeviceType()
				}, {
					["SwitchTabHint" .. t4.keycode.Name] = React.createElement(SwitchTabHint, {
						keycode = t4.keycode
					})
				})))
			end

			t3.TabHeaderContainer = Create("Frame")({
				Name = "TabHeaderContainer",
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				Parent = t3.HubBar,
				Visible = not t1.FFlagEnableSideSheet
			})
			t3.TabHeaderContainerListLayout = Create("UIListLayout")({
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalFlex = Enum.UIFlexAlignment.Fill,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Parent = t3.TabHeaderContainer
			})
			MountSwitchTabHint({
				layoutOrder = -999,
				keycode = Enum.KeyCode.ButtonL1,
				parent = t3.TabHeaderContainer
			})
			MountSwitchTabHint({
				layoutOrder = 999,
				keycode = Enum.KeyCode.ButtonR1,
				parent = t3.TabHeaderContainer
			})
		end

		t3.HubBarContainer = Create("ImageLabel")({
			Name = "HubBarContainer",
			BorderSizePixel = 0,
			ZIndex = t3.Shield.ZIndex + 2,
			BackgroundColor3 = Theme.color("HubBarContainer"),
			BackgroundTransparency = Theme.transparency("HubBarContainerTransparency"),
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			Parent = if not t1.FFlagAddSwitchTabHintsToIEM then t3.HubBar else t3.TabHeaderContainer,
			Selectable = not t1.FFlagIEMTabFocusNav and nil,
			SelectionGroup = not not t1.FFlagIEMTabFocusNav or nil,
			SelectionBehaviorUp = if not t1.FFlagIEMTabFocusNav then nil else Enum.SelectionBehavior.Stop,
			SelectionBehaviorLeft = if not t1.FFlagIEMTabFocusNav then nil else Enum.SelectionBehavior.Stop,
			SelectionBehaviorRight = if not t1.FFlagIEMTabFocusNav then nil else Enum.SelectionBehavior.Stop
		})
		t3.HubBar.ImageTransparency = 1
		t3.HubBarListLayout.Parent = t3.HubBarContainer

		if isSubjectToDesktopPolicies() then
			t3.FullScreenTitleBar = SettingsFullScreenTitleBar.mount({}, t3.Shield, "FullScreenTitleBar")
		end

		local function cameraViewportChanged() -- line: 2200
			-- upvalues: Theme (copy), Utility (copy)
			Theme.viewportResized()
			Utility:FireOnResized()
		end

		local connection2 = nil

		local function onWorkspaceChanged(p42) -- line: 2206
			-- upvalues: Theme (copy), Utility (copy), connection2 (ref), cameraViewportChanged (copy)
			if p42 == "CurrentCamera" then
				Theme.viewportResized()
				Utility:FireOnResized()

				if connection2 then
					connection2:disconnect()
				end

				connection2 = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(cameraViewportChanged)
			end
		end

		Theme.viewportResized()
		Utility:FireOnResized()

		if connection2 then
			connection2:disconnect()
		end

		connection2 = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(cameraViewportChanged)
		workspace.Changed:Connect(onWorkspaceChanged)
	end
	local function resizeBottomBarButtons() -- line: 2218
		-- upvalues: t3 (copy), t1 (copy)
		local AbsoluteSizeX = t3.BottomButtonFrame.AbsoluteSize.X
		local v381 = #t3.BottomBarButtons

		if v381 == 4 then
			AbsoluteSizeX = AbsoluteSizeX - 48 - 12
			v381 -= 1
		end

		local v382 = (AbsoluteSizeX - (v381 - 1) * 12 - 12) / v381

		if t1.isInExperienceUIVREnabled then
			v382 = t3.SettingsUIDelegate:getBottomButtonSize(v382)
		end

		for i = 1, #t3.BottomBarButtons do
			local v384 = t3.BottomBarButtons[i]
			local v385 = v384[1]

			if v385 ~= "MuteButtonButton" then
				t3[v385].Size = UDim2.fromOffset(v382, t3[v384[1]].Size.Y.Offset)
			end
		end
	end
	local function onScreenSizeChanged() -- line: 2241
		-- upvalues: t3 (copy), t1 (copy), Utility (copy), Theme (copy), v180 (copy), v181 (copy), RobloxGui (copy), v14 (copy), VRService (copy), RunService (copy), shouldShowBottomBar (copy), setBottomBarBindings (copy), setBottomBarSelection (copy), removeBottomBarBindings (copy)
		local function getBackBarVisible() -- line: 2242
			-- upvalues: t3 (copy)
			if not t3.BackBarRef:getValue() then
				return false
			end

			return t3.BackBarRef:getValue().Visible
		end
		local function getFrontBarVisible() -- line: 2249
			-- upvalues: t3 (copy)
			if not t3.FrontBarRef:getValue() then
				return false
			end

			return t3.FrontBarRef:getValue().Visible
		end

		if t1.FFlagRelocateMobileMenuButtons and (t1.FIntRelocateMobileMenuButtonsVariant == 2 and t3.Visible) then
			if not Utility:IsPortrait() and not Utility:IsSmallTouchScreen() or Theme.AlwaysShowBottomBar() then
				if not t3.BottomButtonFrameRoot then
					v180()
				end

				if t3.PlayersPage then
					t3.PlayersPage:UnmountMenuButtonsContainer()
				end
			else
				if t3.BottomButtonFrameRoot then
					v181()
				end

				if t3.PlayersPage then
					t3.PlayersPage:CreateMenuButtonsContainer()
				end
			end
		end

		local v388 = Theme.MenuContainerPosition(t3.SettingsUIDelegate)
		local n2 = 600
		local v390 = if not t1.isInExperienceUIVREnabled then RobloxGui.AbsoluteSize.y else t3.SettingsUIDelegate:getFullScreenSize()
		local v391 = 0.050000000000000044 * v390
		local v392 = Utility:IsPortrait()

		if v14 then
			n2 = 800
			v391 = 0.07 * v390
		elseif Utility:IsSmallTouchScreen() then
			v391 = math.min(10, 0.010000000000000009 * v390)
		elseif t1.isInExperienceUIVREnabled and VRService.VREnabled then
			v391 = 0
		end

		if t1.FFlagAddNextUpContainer and t3.Pages.CurrentPage and t3.Pages.CurrentPage.DisableTopPadding and t3.Pages.CurrentPage.MaintainVerticalSize then
			n2 += t3.HubBar.AbsoluteSize.Y
		end

		t3.MenuContainer.Size = v388.Size
		t3.MenuContainer.Position = v388.Position
		t3.MenuContainer.AnchorPoint = v388.AnchorPoint

		local YOffset = t3.HubBar.Size.Y.Offset
		local _ = v391 * 2 + YOffset * 2
		local n3 = 0

		if not t1.FFlagAddTraversalBackButton then
			if ((if t3.BackBarRef:getValue() then t3.BackBarRef:getValue().Visible else false)) and t3.BackBarRef:getValue() then
				n3 = t3.BackBarRef:getValue().Size.Y.Offset
			end

			if t1.EngineFeatureTeleportHistoryButtons and (if t3.FrontBarRef:getValue() then t3.FrontBarRef:getValue().Visible else false) and t3.FrontBarRef:getValue() then
				n3 += t3.FrontBarRef:getValue().Size.Y.Offset
			end
		end

		if v392 then
			t3.HubBar.Position = UDim2.new(0.5, 0, 0, 10)
			t3.HubBar.Size = UDim2.new(0, RobloxGui.AbsoluteSize.X - 40, 0, 54)
		elseif v14 then
			t3.HubBar.Size = UDim2.new(0, 1200, 0, 100)
		elseif Utility:IsSmallTouchScreen() then
			t3.HubBar.Size = UDim2.new(0, RobloxGui.AbsoluteSize.X - 60, 0, 52)
		elseif t1.isInExperienceUIVREnabled then
			t3.HubBar.Size = UDim2.new(0, t3.SettingsUIDelegate:getHubBarSize(), 0, 60)
		else
			t3.HubBar.Size = UDim2.new(0, 800, 0, 60)
		end

		local v396 = if not t1.FFlagEnableSideSheet and Theme.AlwaysShowBottomBar() then t3.HubBar.Size.Y.Offset + t3.BottomButtonFrame.Size.Y.Offset else t3.HubBar.Size.Y.Offset
		local v397 = v391 * 2 + if t1.FFlagFixDisableTopPaddingError and t3.Pages.CurrentPage == nil or not t3.Pages.CurrentPage.DisableTopPadding then v396 else 0

		if not t1.FFlagAddTraversalBackButton then
			n3 = (not (if t3.BackBarRef:getValue() then t3.BackBarRef:getValue().Visible else false) or not t3.BackBarRef:getValue()) and 0 or t3.BackBarRef:getValue().Size.Y.Offset

			if t1.EngineFeatureTeleportHistoryButtons and (if t3.FrontBarRef:getValue() then t3.FrontBarRef:getValue().Visible else false) and t3.FrontBarRef:getValue() then
				n3 += t3.FrontBarRef:getValue().Size.Y.Offset
			end
		end

		if not t1.FFlagAddNextUpContainer then
			RunService.Heartbeat:wait()
		end

		if shouldShowBottomBar() then
			setBottomBarBindings()

			if t1.FFlagIEMFocusNavToButtons then
				setBottomBarSelection(t3.Pages.CurrentPage)
			end
		else
			removeBottomBarBindings()
		end

		if t1.isInExperienceUIVREnabled then
			v397 += t3.SettingsUIDelegate:getMenuContainerExtraSpace()
		end

		local v398 = v390 - v397 - n3

		if t1.FFlagRelocateMobileMenuButtons and ((t1.FIntRelocateMobileMenuButtonsVariant == 1 or t1.FIntRelocateMobileMenuButtonsVariant == 3) and Utility:IsSmallTouchScreen()) then
			v398 -= Theme.ExtraHubBottomPaddingMobile
		end

		if not v392 then
			if n2 < v398 then
				t3.HubBar.Position = UDim2.new(t3.HubBar.Position.X.Scale, t3.HubBar.Position.X.Offset, 0.5, -n2 / 2 - t3.HubBar.Size.Y.Offset)

				if t3.BottomButtonFrame then
					t3.BottomButtonFrame.Position = UDim2.new(t3.BottomButtonFrame.Position.X.Scale, t3.BottomButtonFrame.Position.X.Offset, 0.5, n2 / 2)
				end
			elseif v398 < 150 then
				n2 = 150
				t3.HubBar.Position = UDim2.new(t3.HubBar.Position.X.Scale, t3.HubBar.Position.X.Offset, 0.5, -75 - t3.HubBar.Size.Y.Offset)

				if t3.BottomButtonFrame then
					t3.BottomButtonFrame.Position = UDim2.new(t3.BottomButtonFrame.Position.X.Scale, t3.BottomButtonFrame.Position.X.Offset, 0.5, 75)
				end
			else
				n2 = v398
				t3.HubBar.Position = UDim2.new(t3.HubBar.Position.X.Scale, t3.HubBar.Position.X.Offset, 0, v391)

				if t3.BottomButtonFrame then
					t3.BottomButtonFrame.Position = UDim2.new(t3.BottomButtonFrame.Position.X.Scale, t3.BottomButtonFrame.Position.X.Offset, 1, -(v391 + v396))
				end
			end
		else
			n2 = v398
		end

		local v399 = if v14 then UDim2.new(0, t3.HubBar.AbsoluteSize.X, 0, n2) else if not Utility:IsSmallTouchScreen() then UDim2.new(0, t3.HubBar.AbsoluteSize.X, 0, n2) else if not t1.FFlagRelocateMobileMenuButtons or t1.FIntRelocateMobileMenuButtonsVariant ~= 1 and t1.FIntRelocateMobileMenuButtonsVariant ~= 3 then UDim2.new(0, t3.HubBar.AbsoluteSize.X, 0, n2 + 0 + 0) else UDim2.new(0, t3.HubBar.AbsoluteSize.X, 0, n2 + 0 + 0 - t3.BottomButtonFrame.Size.Y.Offset)

		if t1.FFlagRelocateMobileMenuButtons and t1.FIntRelocateMobileMenuButtonsVariant ~= 0 and t3.BottomButtonFrame then
			t3.BottomButtonFrame.Size = UDim2.new(0, t3.HubBar.Size.X.Offset, 0, t3.HubBar.Size.Y.Offset)
		end

		if t1.FFlagAddNextUpContainer and t3.Pages.CurrentPage and t3.Pages.CurrentPage.ShrinkwrapPageViewClipper and not Utility:IsSmallTouchScreen() then
			local Size = t3.Pages.CurrentPage:GetSize()

			v399 = UDim2.new(v399.X.Scale, v399.X.Offset, v399.Y.Scale, (math.min(Size.Y - t3.PageView.Size.Y.Offset, n2)))
		end

		local v401 = Theme.HubPadding()
		local v402 = v401.PaddingLeft.Offset + v401.PaddingRight.Offset
		local v403 = v401.PaddingTop.Offset + v401.PaddingBottom.Offset

		t3.ReactPage.Size = UDim2.new(0, t3.HubBar.AbsoluteSize.X + v402, 0, n2 + v396 + v403)
		t3.PageViewClipper.Size = v399

		if not v392 then
			t3.PageViewClipper.Position = UDim2.new(t3.PageViewClipper.Position.X.Scale, t3.PageViewClipper.Position.X.Offset, 0.5, -n2 / 2)

			return
		end

		t3.PageViewClipper.Position = UDim2.new(0.5, 0, 0, t3.HubBar.Position.Y.Offset + t3.HubBar.AbsoluteSize.Y)
	end
	local function onPreferredTransparencyChanged() -- line: 2513
		-- upvalues: t3 (copy), Theme (copy), GuiService (copy)
		t3.MenuContainer.BackgroundTransparency = Theme.transparency("MenuContainer", 1) * GuiService.PreferredTransparency
	end
	local function toggleQuickProfilerFromHotkey(p43, p44, _) -- line: 2517
		-- upvalues: UserInputService (copy), GameSettings (copy)
		if not UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and not UserInputService:IsKeyDown(Enum.KeyCode.RightControl) then
			return
		end

		if p43 == "Show Quick Profiler" and p44 and p44 == Enum.UserInputState.Begin then
			GameSettings.PerformanceStatsVisible = not GameSettings.PerformanceStatsVisible
		end
	end
	local function toggleDevConsole(p46, p47, _) -- line: 2533
		-- upvalues: DevConsoleMaster (copy)
		if p46 == "Open Dev Console" and (p47 and p47 == Enum.UserInputState.Begin) then
			DevConsoleMaster:ToggleVisibility()
		end
	end

	local u188 = v14
	local t5 = {
		[Enum.UserInputType.Gamepad1] = true,
		[Enum.UserInputType.Gamepad2] = true,
		[Enum.UserInputType.Gamepad3] = true,
		[Enum.UserInputType.Gamepad4] = true,
		[Enum.KeyCode.Left] = true,
		[Enum.KeyCode.Right] = true,
		[Enum.KeyCode.Up] = true,
		[Enum.KeyCode.Down] = true,
		[Enum.KeyCode.Tab] = true,
		[Enum.UserInputType.Touch] = false,
		[Enum.UserInputType.MouseButton1] = false,
		[Enum.UserInputType.MouseButton2] = false
	}

	UserInputService.InputBegan:connect(function(p49) -- line: 2559
		-- upvalues: t5 (copy), u188 (ref)
		if p49.UserInputType and t5[p49.UserInputType] ~= nil then
			u188 = t5[p49.UserInputType]

			return
		end

		if p49.KeyCode and t5[p49.KeyCode] then
			u188 = t5[p49.KeyCode]
		end
	end)
	UserInputService.InputChanged:connect(function(p50) -- line: 2566
		-- upvalues: u188 (ref)
		if p50.KeyCode == Enum.KeyCode.Thumbstick1 or p50.KeyCode == Enum.KeyCode.Thumbstick2 then
			if p50.Position.magnitude >= 0.25 then
				u188 = true

				return
			end
		elseif p50.UserInputType == Enum.UserInputType.Touch or p50.UserInputType == Enum.UserInputType.MouseMovement then
			u188 = false
		end
	end)

	local GetHeaderPosition = nil

	local function v191(p51, p52) -- line: 2578
		-- upvalues: t1 (copy), t3 (copy), GetHeaderPosition (ref)
		if t1.FFlagInExperienceReportClosingBugfix and not t3.HubBar.Visible then
			return
		end

		local v414 = GetHeaderPosition(t3.Pages.CurrentPage)

		if v414 < 0 then
			return
		end

		local v415 = v414 + p51

		if p52 then
			if v415 > #t3.TabHeaders then
				v415 = 1
			elseif v415 < 1 then
				v415 = #t3.TabHeaders
			end
		end

		local v416 = t3.TabHeaders[v415]

		if v416 then
			for k, _ in pairs(t3.Pages.PageTable) do
				if v416 == k:GetTabHeader() then
					t3:SwitchToPage(k, true, p51)

					return
				end
			end
		end
	end
	local function v192(_, p54, p55) -- line: 2605
		-- upvalues: v191 (copy)
		if p54 ~= Enum.UserInputState.Begin then
			return
		end

		local n4 = 0

		if p55.KeyCode == Enum.KeyCode.ButtonR1 then
			n4 = 1
		elseif p55.KeyCode == Enum.KeyCode.ButtonL1 then
			n4 = -1
		end

		v191(n4, true)
	end
	local function v193(p56) -- line: 2618
		-- upvalues: UserInputService (copy), v191 (copy)
		if p56.KeyCode == Enum.KeyCode.Tab then
			local v424 = not UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and not UserInputService:IsKeyDown(Enum.KeyCode.RightShift) and 1 or -1

			v191(v424, true)
		end
	end
	local function v194(_, p58, p59) -- line: 2631
		-- upvalues: t3 (copy)
		if p58 ~= Enum.UserInputState.Begin then
			return
		end

		local n5 = 0

		if p59.KeyCode == Enum.KeyCode.PageUp then
			n5 = -100
		elseif p59.KeyCode == Enum.KeyCode.PageDown then
			n5 = 100
		end

		t3:ScrollPixels(n5)
	end

	if t1.isInExperienceUIVREnabled or t1.FFlagEnableSettingsHubUIDelegateRollout then
		t3.SettingsUIDelegate = require(RobloxGui.Modules.Settings.SettingsUIDelegate).new(t3)
	end

	createGui()

	if v107 then
		setupVoiceListeners()
	end

	function GetHeaderPosition(p60) -- line: 2655
		-- upvalues: t3 (copy)
		local TabHeader = p60:GetTabHeader()

		if not TabHeader then
			return -1
		end

		for k, v in pairs(t3.TabHeaders) do
			if v == TabHeader then
				return k
			end
		end

		return -1
	end

	local function u195(p61, p62) -- line: 2669
		-- upvalues: u195 (ref)
		if p62:IsA("GuiObject") then
			p62.ZIndex = p61

			local children = p62:GetChildren()

			for i = 1, #children do
				u195(p61, children[i])
			end
		end
	end
	local function AddHeader(p63, p64) -- line: 2679
		-- upvalues: t3 (copy), u195 (ref)
		if not p63 then
			return
		end

		table.insert(t3.TabHeaders, p63)
		p64.TabPosition = #t3.TabHeaders

		local v439 = 1 / #t3.TabHeaders

		for i = 1, #t3.TabHeaders do
			t3.TabHeaders[i].Size = UDim2.new(v439, 0, 1, 0)
		end

		u195(3, p63)
		p63.Parent = t3.HubBarContainer
	end
	local function RemoveHeader(p65) -- line: 2695
		-- upvalues: t3 (copy)
		local v442 = nil

		for i = 1, #t3.TabHeaders do
			if p65 == t3.TabHeaders[i] then
				v442 = i
				table.remove(t3.TabHeaders, i)

				break
			end
		end

		if v442 then
			for i = v442, #t3.TabHeaders do
				local v445 = t3.TabHeaders[i]

				v445.Position = UDim2.new(v445.Position.X.Scale, v445.Position.X.Offset - p65.AbsoluteSize.X, v445.Position.Y.Scale, v445.Position.Y.Offset)
			end
		end

		p65.Parent = nil
	end

	function t3.AddPage(_, p67) -- line: 2718
		-- upvalues: t3 (copy), AddHeader (copy), t1 (copy), setBottomBarSelection (copy)
		t3.Pages.PageTable[p67] = true
		AddHeader(p67:GetTabHeader(), p67)
		p67.Page.Position = UDim2.new(p67.TabPosition - 1, 0, 0, 0)

		if t1.FFlagIEMFocusNavToButtons then
			p67.LastSelectableObjectsUpdated:connect(function() -- line: 2723
				-- upvalues: setBottomBarSelection (copy), p67 (copy)
				setBottomBarSelection(p67)
			end)
		end

		if t1.FFlagIEMTabFocusNav then
			if t1.FFlagIEMTabFocusNav then
				local TabHeader = p67:GetTabHeader()

				if TabHeader then
					for _, v450 in p67.FirstSelectableObjects do
						v450.NextSelectionUp = TabHeader
						TabHeader.NextSelectionDown = v450
					end
				end
			end

			if t1.FFlagIEMTabFocusNav then
				for _, v452 in t3.TabHeaders do
					v452.NextSelectionLeft = nil
					v452.NextSelectionRight = nil
				end

				local v453 = #t3.TabHeaders

				if not (v453 < 2) then
					t3.TabHeaders[1].NextSelectionLeft = t3.TabHeaders[v453]
					t3.TabHeaders[v453].NextSelectionRight = t3.TabHeaders[1]
				end
			end

			p67.FirstSelectableObjectsUpdated:connect(function() -- line: 2730
				-- upvalues: p67 (copy), t1 (copy)
				local v664 = p67

				if not t1.FFlagIEMTabFocusNav then
					return
				end

				local TabHeader = v664:GetTabHeader()

				if not TabHeader then
					return
				end

				for _, v667 in v664.FirstSelectableObjects do
					v667.NextSelectionUp = TabHeader
					TabHeader.NextSelectionDown = v667
				end
			end)
		end
	end
	function t3.RemovePage(_, p69) -- line: 2736
		-- upvalues: t3 (copy), RemoveHeader (copy), t1 (copy)
		t3.Pages.PageTable[p69] = nil
		RemoveHeader(p69:GetTabHeader())

		if t1.FFlagIEMFocusNavToButtons then
			p69.LastSelectableObjectsUpdated:disconnect()
		end

		if t1.FFlagIEMTabFocusNav then
			p69.FirstSelectableObjectsUpdated:disconnect()

			if not t1.FFlagIEMTabFocusNav then
				return
			end

			for _, v457 in t3.TabHeaders do
				v457.NextSelectionLeft = nil
				v457.NextSelectionRight = nil
			end

			local v458 = #t3.TabHeaders

			if v458 < 2 then
				return
			end

			t3.TabHeaders[1].NextSelectionLeft = t3.TabHeaders[v458]
			t3.TabHeaders[v458].NextSelectionRight = t3.TabHeaders[1]
		end
	end
	function t3.HideBar(_) -- line: 2748
		-- upvalues: t3 (copy), removeBottomBarBindings (copy)
		t3.HubBar.Visible = false
		t3.PageViewClipper.Visible = false

		if t3.BottomButtonFrame then
			removeBottomBarBindings()
		end
	end
	function t3.ShowBar(_) -- line: 2756
		-- upvalues: t3 (copy), shouldShowBottomBar (copy), setBottomBarBindings (copy), t1 (copy), setBottomBarSelection (copy)
		t3.HubBar.Visible = true
		t3.PageViewClipper.Visible = true

		if t3.BottomButtonFrame and shouldShowBottomBar() then
			setBottomBarBindings()

			if t1.FFlagIEMFocusNavToButtons then
				setBottomBarSelection(t3.Pages.CurrentPage)
			end
		end
	end
	function t3.ScrollPixels(_, p73) -- line: 2767
		-- upvalues: t3 (copy)
		local CanvasPositionY = t3.PageView.CanvasPosition.Y
		local v464 = t3.PageView.CanvasSize.Y.Offset - t3.PageViewClipper.AbsoluteSize.y
		local v465 = math.max(0, (math.min(CanvasPositionY + p73, v464)))

		t3.PageView.CanvasPosition = Vector2.new(0, v465)
	end
	function t3.ScrollToFrame(_, p75, p76) -- line: 2775
		-- upvalues: u188 (ref), t3 (copy), Constants (copy)
		if u188 or p76 then
			local v469 = p75.AbsolutePosition.y - t3.Pages.CurrentPage.Page.AbsolutePosition.y
			local v470 = v469 + p75.AbsoluteSize.y

			if v469 < t3.PageView.CanvasPosition.y then
				t3.PageView.CanvasPosition = Vector2.new(0, v469)

				return
			end

			if t3.Pages.CurrentPage.Page.Name == Constants.PeoplePageKey and v470 - t3.PageView.CanvasPosition.y > t3.PageView.AbsoluteSize.Y - Constants.PeoplePageScrollBuffer then
				t3.PageView.CanvasPosition = Vector2.new(0, v470 - t3.PageView.AbsoluteSize.Y + Constants.PeoplePageScrollBuffer)

				return
			end

			if v470 - t3.PageView.CanvasPosition.y > t3.PageViewClipper.Size.Y.Offset then
				t3.PageView.CanvasPosition = Vector2.new(0, v470 - t3.PageViewClipper.Size.Y.Offset)
			end
		end
	end
	function t3.GetFirstPageWithTabHeader(_) -- line: 2790
		-- upvalues: t3 (copy)
		local v472 = nil

		for k, _ in pairs(t3.Pages.PageTable) do
			if k:GetTabHeader() ~= nil and k.TabPosition == 1 then
				v472 = k

				break
			end
		end

		if v472 == nil then
			error("No page with tab header found")

			return nil
		end

		return v472
	end
	function t3.InitInPage(_, p79) -- line: 2809
		-- upvalues: t3 (copy), t1 (copy), Utility (copy), shouldShowBottomBar (copy), setBottomBarBindings (copy), setBottomBarSelection (copy), u147 (ref)
		local TabPosition = p79.TabPosition

		for k, _ in pairs(t3.Pages.PageTable) do
			if k ~= p79 then
				k:Hide(-1, TabPosition, true, nil, t3.PageViewInnerFrame)
			end
		end

		if (not t1.FFlagRelocateMobileMenuButtons or t1.FIntRelocateMobileMenuButtonsVariant == 0 or t1.FIntRelocateMobileMenuButtonsVariant == 2 and Utility:IsSmallTouchScreen()) and t3.BottomButtonFrame then
			if shouldShowBottomBar(p79) then
				setBottomBarBindings()

				if t1.FFlagIEMFocusNavToButtons then
					setBottomBarSelection(p79)
				end
			else
				t3.BottomButtonFrame.Visible = false
			end

			local HubBar = t3.HubBar
			local v481 = p79 or t3.Pages.CurrentPage

			HubBar.Visible = if not t1.FFlagEnableSideSheet then v481.ShouldShowBottomBar == true else v481.ShouldShowHubBar == true
		end

		local v482 = p79.IsPageClipped == true

		t3.PageViewClipper.ClipsDescendants = v482
		t3.PageView.ClipsDescendants = v482
		t3.PageViewInnerFrame.ClipsDescendants = v482
		t3.Pages.CurrentPage = p79
		t3.Pages.CurrentPage.Active = true
		t3.CurrentPageSignal:fire(t3.Pages.CurrentPage and t3.Pages.CurrentPage.Page.Name or nil)

		if t1.FFlagEnableSideSheet then
			local CurrentPage = t3.Pages.CurrentPage
			local v484 = CurrentPage or t3.Pages.CurrentPage

			if not (if not t1.FFlagEnableSideSheet then v484.ShouldShowBottomBar == true else v484.ShouldShowHubBar == true) or not CurrentPage.TabHeader then
				t3.PageTitleLabel.Text = ""
			else
				t3.PageTitleLabel.Text = CurrentPage.TabHeader.TabLabel.Title.Text
			end
		end

		local Size = t3.Pages.CurrentPage:GetSize()

		t3.PageView.CanvasSize = UDim2.new(0, 0, 0, Size.Y)
		u147 = t3.Pages.CurrentPage.Page.Changed:connect(function(p80) -- line: 2852
			-- upvalues: t3 (copy)
			if p80 == "AbsoluteSize" then
				local Size2 = t3.Pages.CurrentPage:GetSize()

				t3.PageView.CanvasSize = UDim2.new(0, 0, 0, Size2.Y)
			end
		end)
	end
	function t3.SwitchToPage(_, p82, p83, p84, p85, _, p87) -- line: 2860
		-- upvalues: t3 (copy), t1 (copy), v108 (copy), Utility (copy), Theme (copy), shouldShowBottomBar (copy), u147 (ref), u148 (ref), setBottomBarBindings (copy), setBottomBarSelection (copy), onScreenSizeChanged (copy), Cryo (copy), IXPServiceWrapper (copy), RbxAnalyticsService (copy), Constants (copy), Flags (copy), ExperienceMenuSessionManagerInstance (copy), ReactPageSignal (copy)
		if t3.Pages.PageTable[p82] == nil then
			return
		end

		if t1.FFlagPreventHiddenSwitchPage and t3:GetVisibility() == false then
			return
		end

		if v108 then
			if p82.Page.Name == "ReportAbuseMenuNewContainerPage" then
				t3.PageViewInnerFrame.UIPadding.PaddingTop = UDim.new(0, 0)
			else
				t3.PageViewInnerFrame.UIPadding.PaddingTop = UDim.new(0, 5)
			end
		end

		local uDim = UDim.new(0, 0)
		local uDim3 = UDim.new(0, 0)
		local v495 = not (Utility:IsPortrait() or Utility:IsSmallTouchScreen()) or Theme.AlwaysShowBottomBar()

		if t1.FFlagRelocateMobileMenuButtons and (t1.FIntRelocateMobileMenuButtonsVariant == 1 or t1.FIntRelocateMobileMenuButtonsVariant == 3 or t1.FIntRelocateMobileMenuButtonsVariant == 2 and not Utility:IsSmallTouchScreen()) then
			v495 = true
		end

		if t3.HubBar then
			local v496 = p82 or t3.Pages.CurrentPage

			if not (if not t1.FFlagEnableSideSheet then v496.ShouldShowBottomBar == true else v496.ShouldShowHubBar == true) and not p82.DisableTopPadding then
				uDim = UDim.new(0, t3.HubBar.AbsoluteSize.Y)
			end
		end

		if not t1.FFlagEnableSideSheet and t3.BottomButtonFrame and v495 and not shouldShowBottomBar(p82) and (not t1.FFlagAddNextUpContainer or not p82.ShrinkwrapPageViewClipper) then
			uDim3 = UDim.new(0, t3.BottomButtonFrame.AbsoluteSize.Y)
		end

		local v497 = Theme.HubPadding()

		t3.MenuContainerPadding.PaddingLeft = v497.PaddingLeft
		t3.MenuContainerPadding.PaddingRight = v497.PaddingRight
		t3.MenuContainerPadding.PaddingBottom = v497.PaddingBottom + uDim3
		t3.MenuContainerPadding.PaddingTop = v497.PaddingTop + uDim

		local v498 = Theme.MenuContainerPosition(t3.SettingsUIDelegate)

		t3.MenuContainer.Position = v498.Position
		t3.MenuContainer.Size = v498.Size
		t3.MenuContainer.AnchorPoint = v498.AnchorPoint

		if t1.FFlagAddNextUpContainer and p82.ShrinkwrapPageViewClipper then
			local PageViewClipperSize = t3.PageViewClipper.Size
			local Size = p82:GetSize()

			t3.PageViewClipper.Size = UDim2.new(PageViewClipperSize.X.Scale, t3.HubBar.Size.X.Offset, PageViewClipperSize.Y.Scale, Size.Y)
		end

		if p84 == nil and t3.Pages.CurrentPage and t3.Pages.CurrentPage.TabHeader and p82 and p82.TabHeader then
			p84 = not (t3.Pages.CurrentPage.TabHeader.AbsolutePosition.x < p82.TabHeader.AbsolutePosition.x) and -1 or 1
		end

		if p84 == nil then
			p84 = 1
		end

		if t3.Pages.CurrentPage and u147 ~= nil then
			u147:disconnect()
			t3.Pages.CurrentPage.Active = false
		end

		if t1.FFlagFixDisabledScrollOnIos and u148 ~= nil then
			u148:Disconnect()
			u148 = nil
		end

		local TabPosition = p82.TabPosition

		for k, _ in pairs(t3.Pages.PageTable) do
			if k ~= p82 then
				k:Hide(-p84, TabPosition, p85, nil, t3.PageViewInnerFrame, k == t3.Pages.CurrentPage)
			end
		end

		if t3.BottomButtonFrame then
			if shouldShowBottomBar(p82) then
				setBottomBarBindings()

				if t1.FFlagIEMFocusNavToButtons then
					setBottomBarSelection(p82)
				end
			else
				t3.BottomButtonFrame.Visible = false
			end

			local HubBar = t3.HubBar
			local v505 = p82 or t3.Pages.CurrentPage

			HubBar.Visible = if not t1.FFlagEnableSideSheet then v505.ShouldShowBottomBar == true else v505.ShouldShowHubBar == true
		end

		if t1.FFlagIEMTabFocusNav and t1.FFlagIEMTabFocusNav then
			local TabHeader = p82:GetTabHeader()

			if TabHeader then
				for _, v508 in p82.FirstSelectableObjects do
					v508.NextSelectionUp = TabHeader
					TabHeader.NextSelectionDown = v508
				end
			end
		end

		local v509 = p82.IsPageClipped == true

		t3.PageViewClipper.ClipsDescendants = v509
		t3.PageView.ClipsDescendants = v509
		t3.PageViewInnerFrame.ClipsDescendants = v509
		t3.Pages.CurrentPage = p82
		t3.Pages.CurrentPage:Display(t3.PageViewInnerFrame, p85)
		t3.Pages.CurrentPage.Active = true
		t3.CurrentPageSignal:fire(t3.Pages.CurrentPage and t3.Pages.CurrentPage.Page.Name or nil)

		if t1.FFlagEnableSideSheet then
			local CurrentPage = t3.Pages.CurrentPage
			local v511 = CurrentPage or t3.Pages.CurrentPage

			if not (if not t1.FFlagEnableSideSheet then v511.ShouldShowBottomBar == true else v511.ShouldShowHubBar == true) or not CurrentPage.TabHeader then
				t3.PageTitleLabel.Text = ""
			else
				t3.PageTitleLabel.Text = CurrentPage.TabHeader.TabLabel.Title.Text
			end
		end

		if t1.FFlagAddAbilityToDisableIGMScroll then
			local v512 = nil or t3.Pages.CurrentPage

			if v512 ~= nil and v512.ShouldDisableDefaultScroll == true then
				t3.PageView.ScrollBarThickness = 0
				t3.PageView.ScrollingEnabled = false
				t3.PageView.CanvasPosition = Vector2.new(0, 0)
				t3.PageView.CanvasSize = UDim2.new(1, 0, 1, 0)

				if t1.FFlagFixDisabledScrollOnIos then
					u148 = t3.PageView:GetPropertyChangedSignal("CanvasPosition"):Connect(function() -- line: 2980
						-- upvalues: t3 (copy)
						if t3.PageView.CanvasPosition.Magnitude > 0 then
							t3.PageView.CanvasPosition = Vector2.new(0, 0)
						end
					end)
				end
			else
				t3.PageView.ScrollBarThickness = Theme.DefaultScrollBarThickness
				t3.PageView.ScrollingEnabled = true
			end
		end

		if t1.FFlagAddAbilityToDisableIGMScroll then
			local v513 = nil or t3.Pages.CurrentPage

			if v513 == nil or v513.ShouldDisableDefaultScroll ~= true then
				local Size = t3.Pages.CurrentPage:GetSize()

				t3.PageView.CanvasSize = UDim2.new(0, 0, 0, Size.Y)
			end
		else
			local Size = t3.Pages.CurrentPage:GetSize()

			t3.PageView.CanvasSize = UDim2.new(0, 0, 0, Size.Y)
		end

		u147 = t3.Pages.CurrentPage.Page.Changed:connect(function(p88) -- line: 3002
			-- upvalues: t1 (copy), t3 (copy), onScreenSizeChanged (copy)
			if p88 == "AbsoluteSize" then
				if t1.FFlagAddAbilityToDisableIGMScroll then
					local v671 = nil or t3.Pages.CurrentPage

					if v671 ~= nil and v671.ShouldDisableDefaultScroll == true then
						return
					end
				end

				local Size = t3.Pages.CurrentPage:GetSize()

				t3.PageView.CanvasSize = UDim2.new(0, 0, 0, Size.Y)

				if t1.FFlagAddNextUpContainer and t3.Pages.CurrentPage.ShrinkwrapPageViewClipper then
					onScreenSizeChanged()
				end
			end
		end)

		if t3.MenuStack[#t3.MenuStack] ~= t3.Pages.CurrentPage and not p83 then
			t3.MenuStack[#t3.MenuStack + 1] = t3.Pages.CurrentPage
		end

		if t1.FFlagAddNextUpContainer then
			onScreenSizeChanged()
		elseif p82.DisableTopPadding then
			onScreenSizeChanged()
		end

		local t6 = {
			universeid = tostring(game.GameId)
		}

		if t1.GetFFlagReportAbuseMenuEntrypointAnalytics() and p87 then
			t6 = Cryo.Dictionary.join(t6, p87)
		end

		if t1.FFlagRespawnChromeShortcutTelemetry and t6.used_shortcut == nil then
			t6.used_shortcut = false
		end

		if t6.playsessionid == nil then
			t6.playsessionid = t3.playSessionId
		end

		if p82 then
			if t1.FFlagHelpPageIXPExposure and p82 == t3.HelpPage and not t3.HelpPageIXPFetched then
				IXPServiceWrapper:LogUserLayerExposure(t1.FStringHelpPageIXPLayer)
				t3.HelpPageIXPFetched = true
			end

			if p82 == t3.GameSettingsPage then
				RbxAnalyticsService:SetRBXEventStream(Constants.AnalyticsTargetName, "open_GameSettings_tab", Constants.AnalyticsMenuActionName, t6)

				if Flags.FFlagIEMSettingsLogExposureIXPFlags and not t3.GameSettingsPageReorderIXPFetched then
					IXPServiceWrapper:LogFlagLinkedUserLayerExposure(t1.GetFStringInExperienceMenuIXPLayer())
					t3.GameSettingsPageReorderIXPFetched = true
				end
			else
				RbxAnalyticsService:SetRBXEventStream(Constants.AnalyticsTargetName, "open_" .. p82.Page.Name .. "_tab", Constants.AnalyticsMenuActionName, t6)
			end

			ExperienceMenuSessionManagerInstance:MenuSwitchToPage(p82.Page)
		else
			RbxAnalyticsService:SetRBXEventStream(Constants.AnalyticsTargetName, "open_unknown_tab", Constants.AnalyticsMenuActionName, t6)
			ExperienceMenuSessionManagerInstance:CloseOpenedMenuTab()
		end

		if t1.FFlagAddTraversalHistory and t1.FFlagIntegrateTraversalHistoryInSideSheet then
			ReactPageSignal(false).setCurrentReactPage(nil)
		end
	end
	function t3.SetActive(_, p90) -- line: 3070
		-- upvalues: t3 (copy)
		t3.Active = p90

		if t3.Pages.CurrentPage then
			t3.Pages.CurrentPage.Active = p90
		end
	end
	function clearMenuStack() -- line: 3078
		-- upvalues: t3 (copy)
		while t3.MenuStack and #t3.MenuStack > 0 do
			t3:PopMenu()
		end
	end
	function setOverrideMouseIconBehavior() -- line: 3084
		-- upvalues: t3 (copy), UserInputService (copy), VRService (copy), MouseIconOverrideService (copy), v58 (copy)
		if not t3.Visible then
			return
		end

		if UserInputService:GetLastInputType() == Enum.UserInputType.Gamepad1 or VRService.VREnabled then
			MouseIconOverrideService.push(v58, Enum.OverrideMouseIconBehavior.ForceHide)

			return
		end

		MouseIconOverrideService.push(v58, Enum.OverrideMouseIconBehavior.ForceShow)
	end
	function checkLeaveGameUpsell() -- line: 3096
		-- upvalues: t1 (copy), t3 (copy), Constants2 (copy), default (copy), v60 (copy)
		if not t1.GetFFlagEnableLeaveGameUpsellEntrypoint() then
			return
		end

		if not t3.sessionStartTime then
			t3.sessionStartTime = os.time()
		end

		if not t3.sessionStartTime then
			return
		end

		if not t3.checkedUpsell and t3.leaveGameUpsellProp == Constants2.PHONE_UPSELL_VALUE_PROP.None then
			t3.checkedUpsell = true
			t3.leaveGameUpsellProp = default:FetchPhoneVerificationUpsell(Constants2.EXIT_CONFIRMATION_PHONE_UPSELL_IXP_LAYER, t3.sessionStartTime, true)
			t3.LeaveGameUpsellPage:SetUpsellProp(t3.leaveGameUpsellProp)
			task.delay(v60, function() -- line: 3117
				-- upvalues: t3 (copy)
				t3.checkedUpsell = false
			end)

			return
		end

		if t3.checkedUpsell then
			local v519 = default:FetchPhoneVerificationUpsell(Constants2.EXIT_CONFIRMATION_PHONE_UPSELL_IXP_LAYER, t3.sessionStartTime, false)

			if v519 ~= t3.leaveGameUpsellProp then
				t3.leaveGameUpsellProp = v519
				t3.LeaveGameUpsellPage:SetUpsellProp(t3.leaveGameUpsellProp)
			end
		end
	end

	local u198 = nil

	if t1.FFlagSettingsHubIndependentBackgroundVisibility then
		function u198(p91, p92) -- line: 3132
			-- upvalues: t3 (copy), InExperienceAppChatModal (copy), Constants (copy), t1 (copy), Theme (copy), TweenService (copy)
			if not t3.DarkenBackground then
				return
			end

			if not p91 and t3.DarkenBackground.Visible and (InExperienceAppChatModal:getVisible() or t3.Visible) then
				return
			end

			local n6 = 1
			local Quart = Enum.EasingStyle.Quart
			local v524 = not Constants and 0.4 or Constants.ShieldCloseAnimationTweenTime

			if p91 then
				n6 = if not t1.isInExperienceUIVREnabled then Theme.transparency("DarkenBackground") else t3.SettingsUIDelegate:getDarkBackgroundTheme().Transparency
				Quart = Enum.EasingStyle.Quad
				v524 = not Constants and 0.5 or Constants.ShieldOpenAnimationTweenTime
			end

			if p92 then
				if t3.DarkenBackgroundTween then
					t3.DarkenBackgroundTween:Cancel()
					t3.DarkenBackgroundTween = nil
				end

				t3.DarkenBackground.BackgroundTransparency = n6
			else
				local tweenInfo = TweenInfo.new(v524, Quart, Enum.EasingDirection.Out)

				if t3.DarkenBackgroundTween then
					t3.DarkenBackgroundTween:Cancel()
				end

				t3.DarkenBackgroundTween = TweenService:Create(t3.DarkenBackground, tweenInfo, {
					BackgroundTransparency = n6
				})
				t3.DarkenBackgroundTween:Play()
			end

			t3.DarkenBackground.Visible = p91
		end
	end

	function setVisibilityInternal(p93, p94, p95, _, p97) -- line: 3179
		-- upvalues: t1 (copy), t3 (copy), PerfUtils (copy), RobloxGui (copy), u198 (ref), onScreenSizeChanged (copy), Utility (copy), v180 (copy), GuiService (copy), Theme (copy), ExperienceMenuSessionManagerInstance (copy), Constants (copy), GameSettings (copy), TweenService (copy), EngineFeature (copy), ContextActionService (copy), v192 (copy), v194 (copy), shouldShowBottomBar (copy), setBottomBarBindings (copy), setBottomBarSelection (copy), UserInputService (copy), v193 (copy), u88 (ref), VRService (copy), MouseIconOverrideService (copy), v58 (copy), removeBottomBarBindings (copy), ChatSelector (copy), FFlagEnableNewBackpack (copy), v5 (copy), InExperienceAppChatModal (copy), u89 (ref), v181 (copy), SHIELD_INACTIVE_POSITION (copy), RbxAnalyticsService (copy)
		local v531 = if not t1.isInExperienceUIVREnabled then p94 else p94 or not t3.SettingsUIDelegate:isOpenCloseAnimationAllowed()

		t3.OpenStateChangedCount = t3.OpenStateChangedCount + 1

		local v532 = p93 ~= t3.Visible

		t3.Visible = p93

		if t1.FFlagEnableInGameMenuDurationLogger and (v532 and not p93) then
			PerfUtils.menuClose()
		end

		if t3.ResizedConnection then
			t3.ResizedConnection:disconnect()
			t3.ResizedConnection = nil
		end

		if t3.BackBarVisibleConnection then
			t3.BackBarVisibleConnection:disconnect()
			t3.BackBarVisibleConnection = nil
		end

		if t1.EngineFeatureTeleportHistoryButtons and t3.FrontBarVisibleConnection then
			t3.FrontBarVisibleConnection:disconnect()
			t3.FrontBarVisibleConnection = nil
		end

		if t3.PreferredTransparencyChangedConnection then
			t3.PreferredTransparencyChangedConnection:disconnect()
			t3.PreferredTransparencyChangedConnection = nil
		end

		t3.Modal.Visible = t3.Visible

		if t3.TabConnection then
			t3.TabConnection:disconnect()
			t3.TabConnection = nil
		end

		local PlayerListManager = require(RobloxGui.Modules.PlayerList.PlayerListManager)

		if t1.FFlagSettingsHubIndependentBackgroundVisibility then
			u198(t3.Visible, v531)
		end

		if t3.Visible then
			t3.ResizedConnection = RobloxGui.Changed:connect(function(p98) -- line: 3229
				-- upvalues: onScreenSizeChanged (copy)
				if p98 == "AbsoluteSize" then
					onScreenSizeChanged()
				end
			end)

			if t1.FFlagMenuButtonsMountWithIEM then
				if t1.FFlagRelocateMobileMenuButtons and (t1.FIntRelocateMobileMenuButtonsVariant == 1 or t1.FIntRelocateMobileMenuButtonsVariant == 3 or t1.FIntRelocateMobileMenuButtonsVariant == 2 and not Utility:IsSmallTouchScreen()) then
					v180()
				end

				if t1.FFlagRelocateMobileMenuButtons and t1.FIntRelocateMobileMenuButtonsVariant == 2 and Utility:IsSmallTouchScreen() and t3.PlayersPage then
					t3.PlayersPage:CreateMenuButtonsContainer()
				end
			end

			if not t1.FFlagAddTraversalBackButton then
				if t3.BackBarRef:getValue() then
					t3.BackBarVisibleConnection = t3.BackBarRef:getValue():GetPropertyChangedSignal("Visible"):connect(function() -- line: 3249
						-- upvalues: onScreenSizeChanged (copy)
						onScreenSizeChanged()
					end)
				end

				if t1.EngineFeatureTeleportHistoryButtons and t3.FrontBarRef:getValue() then
					t3.FrontBarVisibleConnection = t3.FrontBarRef:getValue():GetPropertyChangedSignal("Visible"):connect(function() -- line: 3254
						-- upvalues: onScreenSizeChanged (copy)
						onScreenSizeChanged()
					end)
				end
			end

			onScreenSizeChanged()
			t3.PreferredTransparencyChangedConnection = GuiService:GetPropertyChangedSignal("PreferredTransparency"):connect(function() -- line: 3261
				-- upvalues: t3 (copy), Theme (copy), GuiService (copy)
				t3.MenuContainer.BackgroundTransparency = Theme.transparency("MenuContainer", 1) * GuiService.PreferredTransparency
			end)
			t3.MenuContainer.BackgroundTransparency = Theme.transparency("MenuContainer", 1) * GuiService.PreferredTransparency
			t3.SettingsShowSignal:fire(t3.Visible)
			GuiService:SetMenuIsOpen(true, "SettingsHub")
			ExperienceMenuSessionManagerInstance:OpenExperienceMenu()
			t3.Shield.Visible = t3.Visible
			GuiService:CloseInspectMenu()

			if v531 or not t3.Shield:IsDescendantOf(game) then
				t3.Shield.Position = UDim2.new(0, 0, 0, 0)

				if not t1.FFlagSettingsHubIndependentBackgroundVisibility and t3.DarkenBackground then
					if t3.DarkenBackgroundTween then
						t3.DarkenBackgroundTween:Cancel()
						t3.DarkenBackgroundTween = nil
					end

					t3.DarkenBackground.BackgroundTransparency = Theme.transparency("DarkenBackground")
				end
			else
				local v534 = not Constants and 0.5 or Constants.ShieldOpenAnimationTweenTime

				if GameSettings.ReducedMotion then
					if t3.ReducedMotionOpenTween then
						t3.ReducedMotionOpenTween:Cancel()
						t3.ReducedMotionOpenTween = nil
					end

					if t3.ReducedMotionCloseTween then
						t3.ReducedMotionCloseTween:Cancel()
						t3.ReducedMotionCloseTween = nil
					end

					t3.Shield.Parent = t3.CanvasGroup
					t3.CanvasGroup.GroupTransparency = 1
					t3.CanvasGroup.Visible = true
					t3.Shield.Position = UDim2.new(0, 0, 0, 0)

					local tweenInfo = TweenInfo.new(0.25)
					local t7 = {
						GroupTransparency = 0
					}

					t3.ReducedMotionOpenTween = TweenService:Create(t3.CanvasGroup, tweenInfo, t7)
					t3.ReducedMotionOpenTween:Play()
					t3.ReducedMotionOpenTween.Completed:Connect(function(p99) -- line: 3310
						-- upvalues: t3 (copy)
						if p99 == Enum.PlaybackState.Completed then
							t3.Shield.Parent = t3.ClippingShield
							t3.ReducedMotionOpenTween = nil
						end

						t3.CanvasGroup.Visible = false
					end)

					if t1.FFlagEnableInGameMenuDurationLogger then
						PerfUtils.menuOpenComplete()
					end
				elseif EngineFeature then
					t3.Shield:TweenPositionInternal(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quart, v534, true, function() -- line: 3330
						-- upvalues: t1 (copy), PerfUtils (copy)
						if t1.FFlagEnableInGameMenuDurationLogger then
							PerfUtils.menuOpenComplete()
						end
					end)
				else
					t3.Shield:TweenPosition(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quart, v534, true, function() -- line: 3343
						-- upvalues: t1 (copy), PerfUtils (copy)
						if t1.FFlagEnableInGameMenuDurationLogger then
							PerfUtils.menuOpenComplete()
						end
					end)
				end

				if not t1.FFlagSettingsHubIndependentBackgroundVisibility and t3.DarkenBackground then
					local tweenInfo = TweenInfo.new(v534, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

					if t3.DarkenBackgroundTween then
						t3.DarkenBackgroundTween:Cancel()
					end

					t3.DarkenBackgroundTween = TweenService:Create(t3.DarkenBackground, tweenInfo, {
						BackgroundTransparency = Theme.transparency("DarkenBackground")
					})
					t3.DarkenBackgroundTween:Play()
				end
			end

			local function v538() -- line: 3368
			end

			if t1.isInExperienceUIVREnabled then
				function v538(p100, p101, p102) -- line: 3370
					-- upvalues: t3 (copy)
					if t3.SettingsUIDelegate:isInputEventNeededBySettings(p100, p101, p102) then
						return Enum.ContextActionResult.Pass
					end

					return nil
				end
			end

			ContextActionService:BindCoreAction("RbxSettingsHubStopCharacter", v538, false, Enum.PlayerActions.CharacterForward, Enum.PlayerActions.CharacterBackward, Enum.PlayerActions.CharacterLeft, Enum.PlayerActions.CharacterRight, Enum.PlayerActions.CharacterJump, Enum.KeyCode.LeftShift, Enum.KeyCode.RightShift, Enum.KeyCode.Tab, Enum.UserInputType.Gamepad1, Enum.UserInputType.Gamepad2, Enum.UserInputType.Gamepad3, Enum.UserInputType.Gamepad4)

			if not t1.FFlagEnableSideSheet then
				ContextActionService:BindCoreAction("RbxSettingsHubSwitchTab", v192, false, Enum.KeyCode.ButtonR1, Enum.KeyCode.ButtonL1)
			end

			ContextActionService:BindCoreAction("RbxSettingsScrollHotkey", v194, false, Enum.KeyCode.PageUp, Enum.KeyCode.PageDown)

			if shouldShowBottomBar() then
				setBottomBarBindings()

				if t1.FFlagIEMFocusNavToButtons then
					setBottomBarSelection(t3.Pages.CurrentPage)
				end
			end

			if t1.ChromeEnabled and t1.FFlagEnableConsoleExpControls then
				require(RobloxGui.Modules.Chrome.Service):setShortcutBar(require(RobloxGui.Modules.Chrome.ChromeShared.Unibar.Constants).TILTMENU_SHORTCUTBAR_ID)
			end

			if not t1.FFlagEnableSideSheet then
				t3.TabConnection = UserInputService.InputBegan:connect(v193)
			end

			setOverrideMouseIconBehavior()
			u88 = UserInputService.LastInputTypeChanged:connect(setOverrideMouseIconBehavior)

			if UserInputService.MouseEnabled and not VRService.VREnabled then
				MouseIconOverrideService.push(v58, Enum.OverrideMouseIconBehavior.ForceShow)
			end

			t3:CloseReactPage()

			if p95 then
				removeBottomBarBindings()
				t3:SwitchToPage(p95, nil, 1, true)
			else
				t3:SwitchToPage(t3:GetFirstPageWithTabHeader(), nil, 1, true)
			end

			if not t1.isInExperienceUIVREnabled or (t1.InExperienceUIVRIXP:isMovePanelToCenter() and true or not VRService.VREnabled) then
				if t1.FFlagAddNewPlayerListMobileFocusNav then
					if PlayerListManager:GetIsModal() then
						PlayerListManager:SetVisibility(false)
					else
						PlayerListManager:HideTemp("SettingsMenu", true)
					end
				else
					PlayerListManager:HideTemp("SettingsMenu", true)
				end

				if not t1.isInExperienceUIVREnabled or not t1.InExperienceUIVRIXP:isMovePanelToCenter() or not t1.FFlagSpatialUIFixMenuPanelChatExclusive or not VRService.VREnabled then
					ChatSelector:HideTemp("SettingsMenu", true)
				end

				if FFlagEnableNewBackpack then
					v5.setVisibility(v5.FeatureName.Backpack, false)
				else
					local BackpackScript = require(RobloxGui.Modules.BackpackScript)

					if BackpackScript.IsOpen then
						BackpackScript:OpenClose()
					end
				end
			end

			if t1.GetFFlagEnableAppChatInExperience() and InExperienceAppChatModal:getVisible() then
				u89 = true
				InExperienceAppChatModal.default:setVisible(false)
			end

			if not t1.isInExperienceUIVREnabled then
				if FFlagEnableNewBackpack then
					v5.setVisibility(v5.FeatureName.Backpack, false)
				else
					local BackpackScript = require(RobloxGui.Modules.BackpackScript)

					if BackpackScript.IsOpen then
						BackpackScript:OpenClose()
					end
				end
			end

			t3.GameSettingsPage:OpenSettingsPage()
		else
			t3.CurrentPageSignal:fire("")

			if t1.FFlagMenuButtonsMountWithIEM and t1.FFlagRelocateMobileMenuButtons then
				if t1.FIntRelocateMobileMenuButtonsVariant ~= 0 then
					v181()
				end

				if t1.FIntRelocateMobileMenuButtonsVariant == 2 and t3.PlayersPage then
					t3.PlayersPage:UnmountMenuButtonsContainer()
				end
			end

			if t1.ChromeEnabled and t1.FFlagEnableConsoleExpControls then
				require(RobloxGui.Modules.Chrome.Service):setShortcutBar(nil)
			end

			if t1.GetFFlagEnableAppChatInExperience() and u89 then
				u89 = false
			end

			if t1.isInExperienceUIVREnabled and t1.InExperienceUIVRIXP:isMovePanelToCenter() then
				PlayerListManager:HideTemp("SettingsMenu", false)

				if not t1.FFlagSpatialUIFixMenuPanelChatExclusive or not VRService.VREnabled then
					ChatSelector:HideTemp("SettingsMenu", false)
				end
			end

			if v531 then
				t3.Shield.Position = SHIELD_INACTIVE_POSITION
				t3.Shield.Visible = t3.Visible
				t3.SettingsShowSignal:fire(t3.Visible)
				GuiService:SetMenuIsOpen(false, "SettingsHub")
				ExperienceMenuSessionManagerInstance:CloseExperienceMenu()

				if t1.FFlagEnableInGameMenuDurationLogger then
					PerfUtils.menuCloseComplete()
				end

				if not t1.FFlagSettingsHubIndependentBackgroundVisibility and t3.DarkenBackground then
					if t3.DarkenBackgroundTween then
						t3.DarkenBackgroundTween:Cancel()
						t3.DarkenBackgroundTween = nil
					end

					t3.DarkenBackground.BackgroundTransparency = 1
				end
			else
				local v541 = not Constants and 0.4 or Constants.ShieldCloseAnimationTweenTime

				local function handleShieldClose() -- line: 3529
					-- upvalues: t1 (copy), t3 (copy), GuiService (copy), ExperienceMenuSessionManagerInstance (copy), PerfUtils (copy)
					if not t1.FFlagAddTraversalBackButton then
						t3.SettingsShowSignal:fire(t3.Visible)
					end

					if not t3.Visible then
						GuiService:SetMenuIsOpen(false, "SettingsHub")
						ExperienceMenuSessionManagerInstance:CloseExperienceMenu()
					end

					if t1.FFlagEnableInGameMenuDurationLogger then
						PerfUtils.menuCloseComplete()
					end
				end

				if t1.FFlagAddTraversalBackButton then
					t3.SettingsShowSignal:fire(t3.Visible)
				end

				if GameSettings.ReducedMotion then
					if t3.ReducedMotionOpenTween then
						t3.ReducedMotionOpenTween:Cancel()
						t3.ReducedMotionOpenTween = nil
					end

					if t3.ReducedMotionCloseTween then
						t3.ReducedMotionCloseTween:Cancel()
						t3.ReducedMotionCloseTween = nil
					end

					t3.Shield.Parent = t3.CanvasGroup
					t3.CanvasGroup.Visible = true

					local tweenInfo = TweenInfo.new(0.25)
					local t8 = {
						GroupTransparency = 1
					}

					t3.ReducedMotionCloseTween = TweenService:Create(t3.CanvasGroup, tweenInfo, t8)
					t3.ReducedMotionCloseTween:Play()
					t3.ReducedMotionCloseTween.Completed:Connect(function(p103) -- line: 3565
						-- upvalues: t3 (copy), SHIELD_INACTIVE_POSITION (copy)
						if p103 == Enum.PlaybackState.Completed then
							t3.Shield.Position = SHIELD_INACTIVE_POSITION
							t3.Shield.Visible = t3.Visible
							t3.Shield.Parent = t3.ClippingShield
							t3.ReducedMotionCloseTween = nil
						end

						t3.CanvasGroup.Visible = false
					end)
					handleShieldClose()
				else
					if t1.ChromeEnabled and t1.FFlagEnableConsoleExpControls then
						require(RobloxGui.Modules.Chrome.Service):setShortcutBar(nil)
					end

					if EngineFeature then
						t3.Shield:TweenPositionInternal(SHIELD_INACTIVE_POSITION, Enum.EasingDirection.In, Enum.EasingStyle.Quad, v541, true, function() -- line: 3589
							-- upvalues: t3 (copy), handleShieldClose (copy)
							t3.Shield.Visible = t3.Visible
							handleShieldClose()
						end)
					else
						t3.Shield:TweenPosition(SHIELD_INACTIVE_POSITION, Enum.EasingDirection.In, Enum.EasingStyle.Quad, v541, true, function() -- line: 3601
							-- upvalues: t3 (copy), handleShieldClose (copy)
							t3.Shield.Visible = t3.Visible
							handleShieldClose()
						end)
					end
				end

				if not t1.FFlagSettingsHubIndependentBackgroundVisibility and t3.DarkenBackground then
					local tweenInfo = TweenInfo.new(v541, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

					if t3.DarkenBackgroundTween then
						t3.DarkenBackgroundTween:Cancel()
					end

					t3.DarkenBackgroundTween = TweenService:Create(t3.DarkenBackground, tweenInfo, {
						BackgroundTransparency = 1
					})
					t3.DarkenBackgroundTween:Play()
				end
			end

			if u88 then
				u88:disconnect()
			end

			if t1.isInExperienceUIVREnabled then
				if not t1.InExperienceUIVRIXP:isMovePanelToCenter() and not VRService.VREnabled then
					PlayerListManager:HideTemp("SettingsMenu", false)
					ChatSelector:HideTemp("SettingsMenu", false)
				end
			else
				PlayerListManager:HideTemp("SettingsMenu", false)
				ChatSelector:HideTemp("SettingsMenu", false)
			end

			if not VRService.VREnabled then
				MouseIconOverrideService.pop(v58)
			end

			t3:CloseReactPage()
			clearMenuStack()

			if not t1.FFlagEnableSideSheet then
				ContextActionService:UnbindCoreAction("RbxSettingsHubSwitchTab")
			end

			ContextActionService:UnbindCoreAction("RbxSettingsHubStopCharacter")
			ContextActionService:UnbindCoreAction("RbxSettingsScrollHotkey")
			removeBottomBarBindings(0.4)
			GuiService.SelectedCoreObject = nil
			t3.GameSettingsPage:CloseSettingsPage()

			if t3.ShareGamePage then
				t3.ShareGamePage:ClearShareInviteLink(t3.ShareGameApp)
			end
		end

		local t9 = {
			source = p97,
			playsessionid = t3.playSessionId,
			universeid = tostring(game.GameId)
		}

		if v532 then
			if p93 then
				RbxAnalyticsService:SetRBXEventStream(Constants.AnalyticsTargetName, Constants.AnalyticsMenuOpenName, Constants.AnalyticsMenuActionName, t9)

				if t1.GetFFlagEnableLeaveGameUpsellEntrypoint() then
					task.spawn(checkLeaveGameUpsell)

					return
				end
			else
				RbxAnalyticsService:SetRBXEventStream(Constants.AnalyticsTargetName, Constants.AnalyticsMenuCloseName, Constants.AnalyticsMenuActionName, t9)
			end
		end
	end
	function t3.SetVisibility(_, p105, p106, p107, p108, p109) -- line: 3684
		-- upvalues: t3 (copy), setVisibilityInternal (ref)
		if p105 == t3.Visible then
			return
		end

		setVisibilityInternal(p105, p106, p107, p108, p109)
	end
	function t3.SetBackgroundVisibility(_, p111, p112) -- line: 3690
		-- upvalues: t3 (copy), u198 (ref)
		if p111 == t3.DarkenBackground.Visible then
			return
		end

		u198(p111, p112)
	end
	function t3.GetVisibility(_) -- line: 3696
		-- upvalues: t3 (copy)
		return t3.Visible
	end
	function t3.ToggleVisibility(_, p115, p116) -- line: 3700
		-- upvalues: setVisibilityInternal (ref), t3 (copy)
		setVisibilityInternal(not t3.Visible, nil, nil, p115, p116)
	end
	function t3.AddToMenuStack(_, p118) -- line: 3704
		-- upvalues: t3 (copy)
		if p118 ~= t3.MenuStack[#t3.MenuStack] then
			t3.MenuStack[#t3.MenuStack + 1] = p118
		end
	end
	function t3.InviteToGame(_) -- line: 3710
		-- upvalues: t1 (copy), IXPServiceWrapper (copy), GameInviteInviteExperimentVariant (ref), PlatformFriendsService (ref), UserInputService (copy), PlatformService (ref), t3 (copy), GameInviteModalManager (ref), GameInviteConstants (ref), RobloxGui (copy)
		local v563 = false

		if t1.GetFFlagLuaInExperienceCoreScriptsGameInviteUnification() and t1.FFlagLuaEnableGameInviteModalSettingsHub then
			local v564 = t1.GetFStringGameInviteMenuLayer()
			local LayerData = IXPServiceWrapper:GetLayerData(v564)

			IXPServiceWrapper:LogUserLayerExposure(v564)
			v563 = not not LayerData and (LayerData.inExperienceGameInviteUXRefresh2023 == GameInviteInviteExperimentVariant.UxRefresh or LayerData.inExperienceGameInviteUXRefresh2023 == GameInviteInviteExperimentVariant.InviteLimit)
		end

		if game:GetEngineFeature("PlatformFriendsService") and PlatformFriendsService and PlatformFriendsService:IsInviteFriendsEnabled() then
			PlatformFriendsService:ShowInviteFriendsUI()

			return
		end

		if UserInputService:GetPlatform() == Enum.Platform.XBoxOne then
			if PlatformService then
				PlatformService:PopupGameInviteUI()

				return
			end
		elseif v563 then
			if not t1.FFlagAddInviteFriendsIntegration or t3.Visible then
				t3:ToggleVisibility()
			end

			GameInviteModalManager:openModal({
				trigger = GameInviteConstants.Triggers.GameMenu
			})

			if t1.FFlagEnableConsoleExpControls and t1.ChromeEnabled then
				require(RobloxGui.Modules.Chrome.Service):setShortcutBar(nil)

				return
			end
		else
			t3:AddToMenuStack(t3.Pages.CurrentPage)
			t3:SwitchToPage(t3.ShareGamePage, nil, 1, true)
		end
	end
	function t3.PopMenu(_, _, p122, p123) -- line: 3743
		-- upvalues: t3 (copy), BindableEvent (copy), t1 (copy), RobloxGui (copy)
		if t3.MenuStack and #t3.MenuStack > 0 then
			local v570 = t3.MenuStack[#t3.MenuStack]

			if type(v570) ~= "table" then
				BindableEvent:Fire(v570)
			end

			table.remove(t3.MenuStack, #t3.MenuStack)
			t3:SwitchToPage(t3.MenuStack[#t3.MenuStack], true, 1, p122)

			if #t3.MenuStack == 0 then
				if t1.FFlagAddUILessMode then
					t3:SetVisibility(false, nil, nil, nil, p123)
				else
					t3:SetVisibility(false)
				end

				t3.Pages.CurrentPage:Hide(0, 0, nil, nil, t3.PageViewInnerFrame)

				return
			end

			if t1.ChromeEnabled and t1.FFlagEnableConsoleExpControls then
				require(RobloxGui.Modules.Chrome.Service):setShortcutBar(require(RobloxGui.Modules.Chrome.ChromeShared.Unibar.Constants).TILTMENU_SHORTCUTBAR_ID)

				return
			end
		else
			t3.MenuStack = {}
			BindableEvent:Fire()

			if t1.FFlagAddUILessMode then
				t3:ToggleVisibility(nil, p123)

				return
			end

			t3:ToggleVisibility(p123)
		end
	end
	function t3.ShowShield(_) -- line: 3777
		-- upvalues: UserInputService (copy), v56 (copy), t3 (copy)
		local v572 = if not UserInputService.VREnabled then v56 else 1

		t3.Shield.BackgroundTransparency = v572
	end
	function t3.HideShield(_) -- line: 3787
		-- upvalues: t3 (copy)
		t3.Shield.BackgroundTransparency = 1
	end
	function t3.ShowReactPage(_) -- line: 3791
		-- upvalues: t3 (copy)
		if t3.reactPage then
			t3.reactPageAnalytics:openPage(t3.reactPage.name)
		end

		t3.ReactPage.Visible = true
		t3.Page.Visible = false
	end
	function t3.HideReactPage(_) -- line: 3800
		-- upvalues: t3 (copy), t1 (copy)
		if t3.reactPage then
			t3.reactPageAnalytics:closePage(t3.reactPage.name)
		end

		local ReactPageVisible = t3.ReactPage.Visible

		t3.ReactPage.Visible = false
		t3.Page.Visible = true

		if t1.FFlagCreateInExperienceMenuReact and t1.FFlagIEMFocusNavToButtons and t3.Pages.CurrentPage and ReactPageVisible and t3.Visible then
			t3.Pages.CurrentPage:SelectARow(true)
		end
	end
	function t3.MountReactPage(_) -- line: 3814
		-- upvalues: t1 (copy), ReactPageSignal (copy), t3 (copy), ReactRoblox (copy)
		if t1.FFlagCreateInExperienceMenuReact then
			ReactPageSignal(false).setCurrentReactPage(nil)
		end

		if t3.reactPageRoot then
			t3:UnmountReactPage()
		end

		t3.reactPageRoot = ReactRoblox.createRoot(t3.ReactPage)
	end
	function t3.UnmountReactPage(_) -- line: 3824
		-- upvalues: t3 (copy)
		if t3.reactPageRoot then
			t3.reactPageRoot:unmount()
			t3.reactPageRoot = nil
		end
	end
	function t3.CloseReactPage(_) -- line: 3831
		-- upvalues: t3 (copy)
		t3:HideReactPage()
		t3:UnmountReactPage()
	end
	function t3.SwitchToReactPage(_: {[any]: any}, p131, p132, b2: boolean?) -- line: 3836
		-- upvalues: t1 (copy), t3 (copy)
		if t1.FFlagCreateInExperienceMenuReact and b2 then
			t3:UnmountReactPage()
		elseif p131 then
			t3.reactPage = p131

			if not t3.reactPageRoot then
				t3:MountReactPage()
			end

			t3.reactPageRoot:render(p131:createPage(p132))
		end

		t3:ShowReactPage()
	end

	t3.GameSettingsPageReorderIXPFetched = false

	local u199 = nil
	local u200 = nil

	local function enableVR() -- line: 3854
		-- upvalues: CorePackages (copy), t3 (copy), u199 (ref)
		local VRHub2 = require(CorePackages.Workspace.Packages.VrCommon).VRHub
		local Panel3D = require(CorePackages.Workspace.Packages.VrCommon).Panel3D
		local v586 = Panel3D.Get("SettingsMenu")

		v586:ResizeStuds(4, 4, 250)
		v586:SetType(Panel3D.Type.Standard)
		v586:SetVisible(false)
		v586:SetCanFade(false)
		t3.ClippingShield.Parent = v586:GetGUI()
		t3.Shield.Parent.ClipsDescendants = false
		t3.VRShield.Visible = true
		t3:HideShield()
		u199 = t3.SettingsShowSignal:connect(function(p133) -- line: 3868
			-- upvalues: v586 (copy), VRHub2 (copy)
			if p133 then
				v586:SetVisible(true)
				VRHub2:FireModuleOpened("SettingsMenu")

				return
			end

			v586:SetVisible(false)
			VRHub2:FireModuleClosed("SettingsMenu")
		end)
		VRHub2.ModuleOpened.Event:connect(function(p134) -- line: 3880
			-- upvalues: t3 (copy)
			if p134 ~= "SettingsMenu" then
				t3:SetVisibility(false)
			end
		end)
	end
	local function disableVR() -- line: 3886
		-- upvalues: t3 (copy), RobloxGui (copy), u199 (ref), u200 (ref), CorePackages (copy)
		t3.ClippingShield.Parent = RobloxGui
		t3.Shield.Parent.ClipsDescendants = true
		t3.VRShield.Visible = false
		t3:ShowShield()

		if u199 then
			u199:disconnect()
			u199 = nil
		end

		if u200 then
			u200:disconnect()
			u200 = nil
		end

		require(CorePackages.Workspace.Packages.VrCommon).Panel3D.Get("SettingsMenu"):SetVisible(false)
	end
	local function refreshForSpatialUI() -- line: 3906
		-- upvalues: onScreenSizeChanged (copy), t3 (copy), Theme (copy), GuiService (copy), resizeBottomBarButtons (copy)
		onScreenSizeChanged()
		t3.MenuContainer.BackgroundTransparency = Theme.transparency("MenuContainer", 1) * GuiService.PreferredTransparency
		resizeBottomBarButtons()
	end
	local function OnVREnabled(p135) -- line: 3912
		-- upvalues: UserInputService (copy), t1 (copy), t3 (copy), onScreenSizeChanged (copy), Theme (copy), GuiService (copy), resizeBottomBarButtons (copy), enableVR (copy), disableVR (copy)
		if p135 == "VREnabled" then
			if UserInputService.VREnabled then
				if t1.isInExperienceUIVREnabled then
					t3.SettingsUIDelegate:enableVR()
					onScreenSizeChanged()
					t3.MenuContainer.BackgroundTransparency = Theme.transparency("MenuContainer", 1) * GuiService.PreferredTransparency
					resizeBottomBarButtons()

					return
				end

				enableVR()

				return
			end

			if t1.isInExperienceUIVREnabled then
				t3.SettingsUIDelegate:disableVR()
				onScreenSizeChanged()
				t3.MenuContainer.BackgroundTransparency = Theme.transparency("MenuContainer", 1) * GuiService.PreferredTransparency
				resizeBottomBarButtons()

				return
			end

			disableVR()
		end
	end

	UserInputService.Changed:connect(OnVREnabled)
	OnVREnabled("VREnabled")
	t3.ResetCharacterPage:SetHub(t3)

	if InExperienceCapabilities.canNavigateHome then
		t3.LeaveGamePage:SetHub(t3)
	end

	if t1.GetFFlagEnableLeaveGameUpsellEntrypoint() then
		t3.LeaveGameUpsellPage:SetHub(t3)
	end

	t3.GameSettingsPage = require(RobloxGui.Modules.Settings.Pages.GameSettingsWrapper)
	t3.GameSettingsPage:SetHub(t3)
	t3.ReportAbusePage = require(RobloxGui.Modules.Settings.Pages.ReportAbuseMenuNewContainerPage)
	t3.ReportAbusePage:SetHub(t3)
	t3.ReportSentPage = require(RobloxGui.Modules.Settings.Pages.ReportSentPage)
	t3.ReportSentPage:SetHub(t3)
	t3.ReportSentPageV2 = require(RobloxGui.Modules.Settings.Pages.ReportSentPageV2)
	t3.ReportSentPageV2:SetHub(t3)
	t3.HelpPage = require(RobloxGui.Modules.Settings.Pages.HelpWrapper)
	t3.HelpPage:SetHub(t3)

	if t1.FFlagHelpPageIXPExposure then
		t3.HelpPageIXPFetched = false
	end

	if not t1.FFlagRemoveRecordPage then
		local v205 = CachedPolicyService:IsSubjectToChinaPolicies()

		if Platform == Enum.Platform.Windows and not v205 then
			t3.RecordPage = require(RobloxGui.Modules.Settings.Pages.Record)
			t3.RecordPage:SetHub(t3)
		end
	end

	if InExperienceCapabilities.canListPeopleInSameServer then
		t3.PlayersPage = require(RobloxGui.Modules.Settings.Pages.PeopleWrapper)
		t3.PlayersPage:SetHub(t3)

		if not t1.FFlagMenuButtonsMountWithIEM and t1.FFlagRelocateMobileMenuButtons and t1.FIntRelocateMobileMenuButtonsVariant == 2 and Utility:IsSmallTouchScreen() then
			t3.PlayersPage:CreateMenuButtonsContainer()
		end
	end

	if t1.FFlagAddIEMProfilePage then
		t3.PlayerProfilePage = require(RobloxGui.Modules.Settings.Pages.PlayerProfile)
	end

	if isSubjectToDesktopPolicies() then
		t3.ExitModalPage = require(RobloxGui.Modules.Settings.Pages.ExitModal)
		t3.ExitModalPage:SetHub(t3)
	end

	if isSubjectToDesktopPolicies() and InExperienceCapabilities.canNavigateHome then
		t3.LeaveGameToHomePage = require(RobloxGui.Modules.Settings.Pages.LeaveGameToHome)
		t3.LeaveGameToHomePage:SetHub(t3)
	end

	if not v14 and GetCorePackagesLoaded({
		"Roact",
		"Rodux",
		"RoactRodux"
	}) then
		local CorePackages3 = game:GetService("CorePackages")
		local EventStream = require(CorePackages3.Workspace.Packages.Analytics).AnalyticsReporters.EventStream
		local Diag = require(CorePackages3.Workspace.Packages.Analytics).AnalyticsReporters.Diag
		local v209 = EventStream.new(RbxAnalyticsService)
		local v210 = GameInviteAnalytics.new():withEventStream(v209):withDiag(Diag.new(RbxAnalyticsService)):withButtonName(GameInviteAnalytics.ButtonName.SettingsHub)

		t3.ShareGameApp = require(RobloxGui.Modules.Settings.ShareGameMaster).createApp(t3.PageViewClipper, v210)
		t3.ShareGamePage = require(RobloxGui.Modules.Settings.Pages.ShareGamePlaceholderPage)
		t3.ShareGamePage:ConnectHubToApp(t3, t3.ShareGameApp)
		t3:AddPage(t3.ShareGamePage)
	end

	local v211 = CapturesPolicy.PolicyImplementation.read()
	local v212 = not not v211 and CapturesPolicy.Mapper(v211).eligibleForCapturesFeature()
	local v213 = t1.isInExperienceUIVREnabled and t1.FFlagFixSpatialUICaptures

	if v212 and (not v213 or not isSpatial()) then
		local CapturesPageWrapper = require(RobloxGui.Modules.Settings.Pages.CapturesPageWrapper)

		local function closeSettingsMenu() -- line: 4035
			-- upvalues: t3 (copy)
			t3:SetVisibility(false, true)
		end

		t3.CapturesApp = CapturesApp
		t3.CapturesApp.mountMenuPage(CapturesPageWrapper.Page, closeSettingsMenu, t1.ChromeEnabled)
		t3.CapturesPage = CapturesPageWrapper
		t3.CapturesPage:ConnectHubToApp(t3, t3.PageViewClipper, t3.CapturesApp)
	end

	if t1.FFlagIntegrateTraversalHistoryInSideSheet then
		t3.TraversalHistoryPage = require(RobloxGui.Modules.Settings.Pages.TraversalHistoryWrapper)()
		t3.TraversalHistoryPage:SetHub(t3)
	end

	if t3.PlayersPage then
		t3:AddPage(t3.PlayersPage)
	end

	t3:AddPage(t3.ResetCharacterPage)

	if t3.LeaveGamePage then
		t3:AddPage(t3.LeaveGamePage)
	end

	if t1.GetFFlagEnableLeaveGameUpsellEntrypoint() and t3.LeaveGameUpsellPage then
		t3:AddPage(t3.LeaveGameUpsellPage)
	end

	t3:AddPage(t3.GameSettingsPage)

	if t3.CapturesPage then
		t3:AddPage(t3.CapturesPage)
	end

	if t3.ReportAbusePage then
		t3:AddPage(t3.ReportAbusePage)
	end

	if t3.ReportSentPage then
		t3:AddPage(t3.ReportSentPage)
	end

	if t3.ReportSentPageV2 then
		t3:AddPage(t3.ReportSentPageV2)
	end

	t3:AddPage(t3.HelpPage)

	if not t1.FFlagRemoveRecordPage and t3.RecordPage and not t3.CapturesPage then
		t3:AddPage(t3.RecordPage)
	end

	if t3.ExitModalPage then
		t3:AddPage(t3.ExitModalPage)
	end

	if t3.LeaveGameToHomePage then
		t3:AddPage(t3.LeaveGameToHomePage)
	end

	if t3.TraversalHistoryPage then
		t3:AddPage(t3.TraversalHistoryPage)
	end

	t3:InitInPage(t3:GetFirstPageWithTabHeader())

	if not t1.isNewInGameMenuEnabled() and (not t1.FFlagAddUILessMode or t1.FIntAddUILessModeVariant == 0) then
		ContextActionService:BindCoreAction("RBXEscapeMainMenu", function(_, p137, _) -- line: 4105
			-- upvalues: t1 (copy), getSideSheetVisibility (copy), toggleSideSheet (copy), t3 (copy), Constants (copy)
			if p137 ~= Enum.UserInputState.Begin then
				return
			end

			if t1.FFlagEnableSideSheet then
				if getSideSheetVisibility() then
					toggleSideSheet(false)

					return
				end

				if t3.MenuStack and #t3.MenuStack > 0 then
					if t1.FFlagAddUILessMode then
						t3:PopMenu(false, true, Constants.AnalyticsMenuOpenTypes.Keyboard)

						return
					end

					t3:PopMenu(false, true)

					return
				end

				toggleSideSheet(true)

				return
			end

			if t1.FFlagAddUILessMode then
				t3:PopMenu(false, true, Constants.AnalyticsMenuOpenTypes.Keyboard)

				return
			end

			t3:PopMenu(false, true)
		end, false, Enum.KeyCode.Escape)
	end

	GuiService.ShowLeaveConfirmation:connect(function() -- line: 4136
		-- upvalues: t3 (copy), Constants (copy)
		if #t3.MenuStack == 0 then
			t3:SetVisibility(true, nil, nil, nil, Constants.AnalyticsMenuOpenTypes.GamepadLeaveGame)
			t3:SwitchToPage(t3:GetFirstPageWithTabHeader(), nil, 1)

			return
		end

		t3:PopMenu(false, true)
	end)
	ContextActionService:BindCoreAction("Open Dev Console", toggleDevConsole, false, Enum.KeyCode.F9)
	ContextActionService:BindCoreAction("Show Quick Profiler", toggleQuickProfilerFromHotkey, false, Enum.KeyCode.F7)
	UserInputService.InputBegan:connect(function(p139) -- line: 4162
		-- upvalues: t3 (copy), GuiService (copy)
		if (p139.KeyCode == Enum.KeyCode.Left or (p139.KeyCode == Enum.KeyCode.Right or p139.KeyCode == Enum.KeyCode.Up or p139.KeyCode == Enum.KeyCode.Down)) and (t3.Visible and t3.Active and t3.Pages.CurrentPage and GuiService.SelectedCoreObject == nil) then
			t3.Pages.CurrentPage:SelectARow()
		end
	end)

	if t3.ExitModalPage then
		local function showExitModal() -- line: 4176
			-- upvalues: t3 (copy), removeBottomBarBindings (copy)
			t3.HubBar.Visible = false
			removeBottomBarBindings()

			if t3:GetVisibility() then
				t3:AddToMenuStack(t3.Pages.CurrentPage)
				t3:SwitchToPage(t3.ExitModalPage, nil, 1, true)

				return
			end

			t3:SetVisibility(true, nil, t3.ExitModalPage, false)
		end
		local function handleNativeExit() -- line: 4186
			-- upvalues: t3 (copy), t1 (copy), PerfUtils (copy), v181 (copy), showExitModal (copy)
			if t3:GetVisibility() and t3.Pages.CurrentPage == t3.ExitModalPage then
				if t1.FFlagEnableInGameMenuDurationLogger then
					PerfUtils.leavingGame()
				end

				if t1.FFlagRelocateMobileMenuButtons and t1.FIntRelocateMobileMenuButtonsVariant ~= 0 then
					v181()

					if t1.FFlagMenuButtonsMountWithIEM and t1.FIntRelocateMobileMenuButtonsVariant == 2 and t3.PlayersPage then
						t3.PlayersPage:UnmountMenuButtonsContainer()
					end
				end

				t3.ExitModalPage.LeaveAppFunc(true)

				return
			end

			showExitModal()
		end

		game:GetService("GuiService").NativeClose:Connect(handleNativeExit)

		if t3.FullScreenTitleBar then
			t3.FullScreenTitleBar = SettingsFullScreenTitleBar.update(t3.FullScreenTitleBar, {
				onClose = handleNativeExit
			})
		end
	end

	if t1.GetFFlagEnableAppChatInExperience() then
		local connection3 = nil

		t3.SettingsShowSignal:connect(function(p140) -- line: 4215
			-- upvalues: connection3 (ref), InExperienceAppChatModal (copy), t3 (copy)
			if p140 then
				connection3 = InExperienceAppChatModal.default.visibilitySignal.Event:Connect(function(p141) -- line: 4217
					-- upvalues: t3 (copy)
					if p141 and t3.Visible then
						t3:SetVisibility(false, true)
					end
				end)

				return
			end

			if connection3 then
				connection3:Disconnect()
				connection3 = nil
			end
		end)
	end

	if t1.FFlagCreateInExperienceMenuReact then
		t3.InExperienceMenuReact = Create("Folder")({
			Name = "InExperienceMenuReact",
			Parent = t3.ClippingShield
		})

		local ButtonsContainer = t3.PlayersPage.ButtonsContainer
		local v220 = if not ButtonsContainer then nil else ButtonsContainer:FindFirstChild("LeaveButtonButton", true)
		local LeaveGameButton = nil

		if t1.FFlagAddTraversalHistory then
			LeaveGameButton = t3.LeaveGameButton
		end

		local function v222(p142) -- line: 4245
			-- upvalues: React (copy), t3 (copy), Signals (copy), t1 (copy), isSpatial (copy), PortalWithFoundationStylelink (copy), TraversalHistoryMenu (copy)
			local v594, v595 = React.useState(p142.showSignal(false) and t3.Visible)

			React.useEffect(function() -- line: 4247
				-- upvalues: Signals (copy), v595 (copy), p142 (copy), t3 (copy)
				local v682 = Signals.createEffect(function(p143) -- line: 4248
					-- upvalues: v595 (copy), p142 (copy), t3 (copy)
					v595(p142.showSignal(p143) and t3.Visible)
				end)
				local v683 = t3.SettingsShowSignal:connect(function(p144) -- line: 4251
					-- upvalues: v595 (copy), p142 (copy)
					v595(p142.showSignal(false) and p144)
				end)

				return function() -- line: 4255
					-- upvalues: v682 (copy), v683 (copy)
					v682()
					v683:Disconnect()
				end
			end, {})

			return t1.FFlagAddTraversalHistory and (not (t1.isInExperienceUIVREnabled and isSpatial()) and (p142.parent and (v594 and React.createElement(PortalWithFoundationStylelink, {
				parent = p142.parent
			}, {
				TraversalHistoryMenu = React.createElement(TraversalHistoryMenu, {
					anchorParent = p142.parent,
					currentPageChangeSignal = p142.currentPageChangeSignal,
					menuSide = p142.menuSide
				})
			}))))
		end

		ReactRoblox.createRoot(t3.InExperienceMenuReact):render(React.createElement(InExperienceMenuReact, nil, {
			InExperienceMenuReactPage = React.createElement(InExperienceMenuReactPage, {
				onMount = function() -- line: 4276
					-- upvalues: t3 (copy)
					t3:SwitchToReactPage(nil, nil, true)
				end,
				onUnmount = function() -- line: 4277
					-- upvalues: t3 (copy), ReactPageSignal (copy)
					t3:CloseReactPage()
					ReactPageSignal(false).setCurrentReactPage(nil)
				end,
				mountTo = t3.ReactPage
			}),
			TraversalHistoryMenuBottomBar = React.createElement(v222, {
				showSignal = t3.showBottomBarSignal,
				parent = LeaveGameButton,
				menuSide = Foundation.Enums.PopoverSide.Top,
				currentPageChangeSignal = t3.CurrentPageSignal
			}),
			TraversalHistoryMenuMobileButton = React.createElement(v222, {
				showSignal = Signals.createComputed(function(p145) -- line: 4290
					-- upvalues: t3 (copy)
					return not t3.showBottomBarSignal(p145)
				end),
				parent = v220,
				menuSide = Foundation.Enums.PopoverSide.Bottom,
				currentPageChangeSignal = t3.CurrentPageSignal
			})
		}))
	end

	return t3
end

local t11 = {
	ModuleName = "SettingsMenu",
	KeepVRTopbarOpen = true,
	VRIsExclusive = true,
	VRClosesNonExclusive = true,
	SetVisibility = nil
}

VRHub:RegisterModule(t11)
VRHub.ModuleOpened.Event:connect(function(p146) -- line: 4315
	-- upvalues: t11 (copy), VRHub (copy)
	if p146 ~= t11.ModuleName and VRHub:GetModule(p146).VRIsExclusive then
		t11:SetVisibility(false)
	end
end)

local v132 = CreateSettingsHub()

function t11.GetExperienceControlStore(_) -- line: 4326
	-- upvalues: v132 (copy)
	return v132:GetExperienceControlStore()
end
function t11.SetVisibility(_, p149, p150, p151, p152, p153) -- line: 4330
	-- upvalues: v132 (copy)
	v132:SetVisibility(p149, p150, p151, p152, p153)
end
function t11.SetBackgroundVisibility(_, p155, p156) -- line: 4334
	-- upvalues: v132 (copy)
	v132:SetBackgroundVisibility(p155, p156)
end
function t11.ToggleVisibility(_, p158, p159) -- line: 4338
	-- upvalues: v132 (copy)
	v132:ToggleVisibility(p158, p159)
end
function t11.SwitchToPage(_, p161, p162) -- line: 4342
	-- upvalues: v132 (copy)
	v132:SwitchToPage(p161, p162, 1)
end

if t1.FFlagAddUILessMode and t1.FIntAddUILessModeVariant ~= 0 then
	function t11.PopMenu(_, p164, p165, p166) -- line: 4347
		-- upvalues: v132 (copy)
		return v132:PopMenu(p164, p165, p166)
	end
end

function t11.GetVisibility(_) -- line: 4352
	-- upvalues: v132 (copy)
	return v132.Visible
end
function t11.ShowShield(_) -- line: 4356
	-- upvalues: v132 (copy)
	v132:ShowShield()
end
function t11.HideShield(_) -- line: 4360
	-- upvalues: v132 (copy)
	v132:HideShield()
end
function t11.GetRespawnBehaviour(_) -- line: 4364
	-- upvalues: v132 (copy)
	return v132:GetRespawnBehaviour()
end
function t11.CloseReactPage(_) -- line: 4368
	-- upvalues: v132 (copy)
	v132:CloseReactPage()
end
function t11.SwitchToReactPage(_, p173, p174, p175) -- line: 4372
	-- upvalues: v132 (copy)
	v132:SwitchToReactPage(p173, p174, p175)
end

if t1.FFlagAddInviteFriendsIntegration then
	function t11.InviteToGame(_) -- line: 4377
		-- upvalues: v132 (copy)
		v132:InviteToGame()
	end
end

t11.RespawnBehaviourChangedEvent = v132.RespawnBehaviourChangedEvent
t11.SettingsShowSignal = v132.SettingsShowSignal
t11.CurrentPageSignal = v132.CurrentPageSignal
t11.SettingsShowEvent = Instance.new("BindableEvent")
v132.SettingsShowSignal:connect(function(p177) -- line: 4390
	-- upvalues: t11 (copy)
	t11.SettingsShowEvent:Fire(p177)
end)
t11.Instance = v132

return t11
