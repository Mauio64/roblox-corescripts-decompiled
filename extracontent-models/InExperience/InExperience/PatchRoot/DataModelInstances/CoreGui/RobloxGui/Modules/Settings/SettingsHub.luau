local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableNewBackpack = SharedFlags.FFlagEnableNewBackpack
local features

if FFlagEnableNewBackpack then
	local System = require(CorePackages.Workspace.Packages.System)
	features = System.Features
else
	features = nil
end

local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Symbol = AppCommonLib.Symbol
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local IXPService = game:GetService("IXPService")
local LocalizationService = game:GetService("LocalizationService")
local TelemetryService = game:GetService("TelemetryService")

local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local SharedFlags2 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagResponsiveUnitsDeprecateTenFoot = SharedFlags2.FFlagResponsiveUnitsDeprecateTenFoot
local TenFootInterface = require(RobloxGui.Modules.TenFootInterface)
local isEnabled = TenFootInterface:IsEnabled()
local v = isEnabled and not FFlagResponsiveUnitsDeprecateTenFoot
local Roact = require(CorePackages.Packages.Roact)
local Cryo = require(CorePackages.Packages.Cryo)
local Otter = require(CorePackages.Packages.Otter)
local React = require(CorePackages.Packages.React)
local ReactRoblox = require(CorePackages.Packages.ReactRoblox)

local Foundation = require(CorePackages.Packages.Foundation)
local FoundationProvider = Foundation.FoundationProvider

local CoreScriptsRoactCommon = require(CorePackages.Workspace.Packages.CoreScriptsRoactCommon)
local Traversal = CoreScriptsRoactCommon.Traversal

local PortalWithFoundationStylelink = require(script.Parent.Components.PortalWithFoundationStylelink)
local InExperienceMenuReact = require(script.Parent.InExperienceMenuReact)
local InExperienceMenuReactPage = require(script.Parent.Pages.InExperienceMenuReactPage)
local ReactPageSignal = require(script.Parent.ReactPageSignal)
local Utils = require(script.Parent.Integrations.Utils)
local Utility = require(RobloxGui.Modules.Settings.Utility)
local VrCommon = require(CorePackages.Workspace.Packages.VrCommon)
local VRHub = VrCommon.VRHub
local CachedPolicyService = require(CorePackages.Workspace.Packages.CachedPolicyService)
local PerfUtils = require(RobloxGui.Modules.Common.PerfUtils)
local CoreScriptsCommon = require(CorePackages.Workspace.Packages.CoreScriptsCommon)
local MouseIconOverrideService = CoreScriptsCommon.MouseIconOverrideService
local SharedFlags3 = require(CorePackages.Workspace.Packages.SharedFlags)
local isSubjectToDesktopPolicies = SharedFlags3.isSubjectToDesktopPolicies
local TabHeader = require(RobloxGui.Modules.Settings.Components.TabHeader)
local SwitchTabHint = TabHeader.SwitchTabHint
local Traversal2 = require(RobloxGui.Modules.Settings.Components.Traversal)
local TraversalHistoryMenu = Traversal2.TraversalHistoryMenu
local MenuBackButton = require(RobloxGui.Modules.Settings.Components.MenuBackButton)
local MenuFrontButton = require(RobloxGui.Modules.Settings.Components.MenuFrontButton)
local MenuButtonsContainer = require(RobloxGui.Modules.Settings.Components.MenuButtons.MenuButtonsContainer)
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local IxpServiceWrapper = require(CorePackages.Workspace.Packages.IxpServiceWrapper)
local IXPServiceWrapper = IxpServiceWrapper.IXPServiceWrapper
local Style = require(CorePackages.Workspace.Packages.Style)
local AppFonts = Style.AppFonts
local CapturesInExperience = require(CorePackages.Workspace.Packages.CapturesInExperience)
local CapturesPolicy = CapturesInExperience.CapturesPolicy
local InExperienceCapabilities = require(CorePackages.Workspace.Packages.InExperienceCapabilities)
local inExperienceCapabilities = InExperienceCapabilities.InExperienceCapabilities
local getCamMicPermissions = require(CoreGui.RobloxGui.Modules.Settings.getCamMicPermissions)
local AppCommonLib2 = require(CorePackages.Workspace.Packages.AppCommonLib)
local Create = AppCommonLib2.Create
local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local Stores = CoreGuiCommon.Stores
local Signals = require(CorePackages.Packages.Signals)
local createSignal = Signals.createSignal
local UIBlox = require(CorePackages.Packages.UIBlox)
local AppStyleProvider = UIBlox.App.Style.AppStyleProvider
local Foundation2 = require(CorePackages.Packages.Foundation)
local Dark = Foundation2.Enums.ColorMode.Dark
local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)
local AppCommonLib3 = require(CorePackages.Workspace.Packages.AppCommonLib)
local isSpatial = AppCommonLib3.isSpatial
local HelpPage = require(CorePackages.Workspace.Packages.HelpPage)
local leaveGame = require(RobloxGui.Modules.Settings.leaveGame)

local Theme = require(script.Parent.Theme)

local color = Theme.color("SETTINGS_SHIELD", Color3.new(41 / 255, 41 / 255, 41 / 255))
local transparency = Theme.transparency("SETTINGS_SHIELD_TRANSPARENCY", 0.2)

local SHIELD_INACTIVE_POSITION = Theme.SHIELD_INACTIVE_POSITION

local named = Symbol.named("SettingsHubCursorOverride")

local v2 = v and 32 or Utility:IsSmallTouchScreen() and 24 or 26

local defineFastInt = game:DefineFastInt("CheckLeaveGameUpsellCooldown", 300)
local defineFastInt2 = game:DefineFastInt("GetServerChannelRetries", 10)

local SharedFlags4 = require(CorePackages.Workspace.Packages.SharedFlags)
local Flags = require(script.Parent.Flags)

local v3 = {}
v3.EngineFeatureRbxAnalyticsServiceExposePlaySessionId = game:GetEngineFeature("RbxAnalyticsServiceExposePlaySessionId")
v3.EngineFeatureTeleportHistoryButtons = game:GetEngineFeature("TeleportHistoryButtons")
v3.EngineFeaturePlayerScriptStatusProperty = game:GetEngineFeature("PlayerScriptStatusProperty")
v3.FFlagPreventHiddenSwitchPage = game:DefineFastFlag("PreventHiddenSwitchPage", false)
v3.FFlagFixDisableTopPaddingError = game:DefineFastFlag("FixDisableTopPaddingError", false)
v3.FFlagWaitPlayerModuleStatus = game:DefineFastFlag("WaitPlayerModuleStatus", false)

local GetFFlagEnableInGameMenuDurationLogger = require(RobloxGui.Modules.Common.Flags.GetFFlagEnableInGameMenuDurationLogger)
v3.FFlagEnableInGameMenuDurationLogger = GetFFlagEnableInGameMenuDurationLogger()
v3.isNewInGameMenuEnabled = require(RobloxGui.Modules.isNewInGameMenuEnabled)

v3.GetFFlagRemoveAssetVersionEndpoint = require(RobloxGui.Modules.Flags.GetFFlagRemoveAssetVersionEndpoint)
v3.GetFFlagNewEventIngestPlayerScriptsDimensions = require(RobloxGui.Modules.Flags.GetFFlagNewEventIngestPlayerScriptsDimensions)

v3.GetFFlagReportAbuseMenuEntrypointAnalytics = require(RobloxGui.Modules.Settings.Flags.GetFFlagReportAbuseMenuEntrypointAnalytics)
v3.GetFFlagEnableLeaveGameUpsellEntrypoint = require(RobloxGui.Modules.Settings.Flags.GetFFlagEnableLeaveGameUpsellEntrypoint)
v3.GetFStringInExperienceMenuIXPLayer = require(RobloxGui.Modules.Settings.Flags.GetFStringInExperienceMenuIXPLayer)
v3.GetFStringExitModalIXPLayer = require(RobloxGui.Modules.Settings.Flags.GetFStringExitModalIXPLayer)
v3.GetFStringInExperienceMenuIXPVar = require(RobloxGui.Modules.Settings.Flags.GetFStringInExperienceMenuIXPVar)
v3.FFlagRelocateMobileMenuButtons = require(RobloxGui.Modules.Settings.Flags.FFlagRelocateMobileMenuButtons)
v3.FIntRelocateMobileMenuButtonsVariant = require(RobloxGui.Modules.Settings.Flags.FIntRelocateMobileMenuButtonsVariant)
v3.FFlagMenuButtonsMountWithIEM = require(RobloxGui.Modules.Settings.Flags.FFlagMenuButtonsMountWithIEM)
v3.FFlagSpatialUIFixMenuPanelChatExclusive = require(RobloxGui.Modules.Settings.Flags.FFlagSpatialUIFixMenuPanelChatExclusive)
v3.FFlagRemoveLoadingTimeout = require(RobloxGui.Modules.Flags.FFlagRemoveLoadingTimeout)

v3.FFlagAddNewPlayerListMobileFocusNav = PlayerList.Flags.FFlagAddNewPlayerListMobileFocusNav

local Chrome = require(CorePackages.Workspace.Packages.Chrome)
v3.ChromeEnabled = Chrome.Enabled()
v3.FFlagRespawnChromeShortcutTelemetry = require(RobloxGui.Modules.Chrome.Flags.FFlagRespawnChromeShortcutTelemetry)

v3.FFlagLocalizeVersionLabels = settings():GetFFlag("LocalizeVersionLabels")

local SharedExperimentDefinition = require(CorePackages.Workspace.Packages.SharedExperimentDefinition)
v3.isInExperienceUIVREnabled = SharedExperimentDefinition.isInExperienceUIVREnabled
local SharedExperimentDefinition2 = require(CorePackages.Workspace.Packages.SharedExperimentDefinition)
v3.InExperienceUIVRIXP = SharedExperimentDefinition2.InExperienceUIVRIXP
v3.FFlagAddSwitchTabHintsToIEM = SharedFlags4.FFlagAddSwitchTabHintsToIEM
v3.GetFFlagEnableAppChatInExperience = SharedFlags4.GetFFlagEnableAppChatInExperience
v3.GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints = SharedFlags4.GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints
v3.GetFFlagDisplayServerChannel = SharedFlags4.GetFFlagDisplayServerChannel
v3.FFlagSettingsHubIndependentBackgroundVisibility = SharedFlags4.getFFlagSettingsHubIndependentBackgroundVisibility()
v3.GetFFlagPackagifySettingsShowSignal = SharedFlags4.GetFFlagPackagifySettingsShowSignal
v3.FFlagEnableConsoleExpControls = SharedFlags4.FFlagEnableConsoleExpControls
v3.FFlagIEMTabFocusNav = SharedFlags4.FFlagIEMTabFocusNav
v3.FFlagIEMFocusNavSupportNewButtons = Flags.FFlagIEMFocusNavSupportNewButtons
v3.FFlagAddUILessMode = SharedFlags4.FFlagAddUILessMode
v3.FIntAddUILessModeVariant = SharedFlags4.FIntAddUILessModeVariant
v3.FFlagInExperienceReportClosingBugfix = SharedFlags4.FFlagInExperienceReportClosingBugfix
v3.FFlagEnableSettingsHubUIDelegateRollout = SharedFlags4.FFlagEnableSettingsHubUIDelegateRollout
v3.FFlagAddIEMProfilePage = SharedFlags4.FFlagAddIEMProfilePage
v3.FFlagFixSpatialUICaptures = SharedFlags4.FFlagFixSpatialUICaptures
v3.FFlagVoiceRewarmTelemetry = SharedFlags4.FFlagVoiceRewarmTelemetry

v3.FFlagAddTraversalBackButton = Traversal.Flags.FFlagAddTraversalBackButton
v3.FFlagAddTraversalHistory = Traversal.Flags.FFlagAddTraversalHistory
v3.FFlagEnableSystemScrimInSettingsHub = game:DefineFastFlag("EnableSystemScrimInSettingsHub", false)

v3.FFlagHelpPageIXPExposure = HelpPage.Flags.FFlagHelpPageIXPExposure
v3.FStringHelpPageIXPLayer = HelpPage.Flags.FStringHelpPageIXPLayer

v3.FFlagFixDisabledScrollOnIos = game:DefineFastFlag("FixDisabledScrollOnIos", false)

v3.FFlagSideSheetAndroidBack = game:DefineFastFlag("SideSheetAndroidBack", false)
v3.FFlagAddInviteFriendsIntegration = SharedFlags4.FFlagAddInviteFriendsIntegration
v3.FFlagIntegrateTraversalHistoryInSideSheet = SharedFlags4.FFlagIntegrateTraversalHistoryInSideSheet
v3.FFlagShowSwitchServerButton = SharedFlags4.FFlagShowSwitchServerButton
v3.isExitModalRemoved = require(RobloxGui.Modules.Settings.Flags.isExitModalRemoved)
v3.FFlagEnableExitModalExposure = game:DefineFastFlag("EnableExitModalExposure", false)

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
local gameSettings = UserSettings().GameSettings
local InExperienceSessionization = require(CorePackages.Workspace.Packages.InExperienceSessionization)
local ExperienceMenuSessionManagerInstance = InExperienceSessionization.ExperienceMenuSessionManagerInstance

local v4 = nil
pcall(function()
	local PlatformService = game:GetService("PlatformService")
	v4 = PlatformService
end)

local v5 = nil
pcall(function()
	local PlatformFriendsService = game:GetService("PlatformFriendsService")
	v5 = PlatformFriendsService
end)

local getServerVersion = nil
spawn(function()
	getServerVersion = RobloxReplicatedStorage:WaitForChild("GetServerVersion", 1e999)
end)

local getServerChannel = nil

if v3.GetFFlagDisplayServerChannel() then
	spawn(function()
		getServerChannel = RobloxReplicatedStorage:WaitForChild("GetServerChannel", 1e999)
	end)
end

local v6 = UserInputService.PreferredInput == Enum.PreferredInput.Touch
RobloxGui:WaitForChild("Modules"):WaitForChild("TenFootInterface")
local platform = UserInputService:GetPlatform()

local BaseUrl = ContentProvider.BaseUrl
local visible2 = not string.find(BaseUrl, "www.roblox.com")
local DevConsoleMaster = require(RobloxGui.Modules.DevConsoleMaster)

local lastInputTypeChangedConnection = nil
local v7 = false

local serverVersionBlocking = nil
local serverChannelBlocking = nil

local SettingsFullScreenTitleBar = require(RobloxGui.Modules.Settings.Components.SettingsFullScreenTitleBar)

local MenuLeaveGameTelemetryConfig = require(RobloxGui.Modules.Settings.Analytics.MenuLeaveGameTelemetryConfig)
local MenuResetCharacterTelemetryConfig = require(RobloxGui.Modules.Settings.Analytics.MenuResetCharacterTelemetryConfig)
local MenuResumeTelemetryConfig = require(RobloxGui.Modules.Settings.Analytics.MenuResumeTelemetryConfig)

local ReactPageAnalytics = require(RobloxGui.Modules.Settings.Analytics.ReactPageAnalytics)

local GameInvite = require(CorePackages.Workspace.Packages.GameInvite)
local GameInviteModalManager = GameInvite.GameInviteModalManager
local GameInviteConstants = GameInvite.GameInviteConstants

local CapturesApp = require(RobloxGui.Modules.Captures.CapturesApp)

local Constants = require(RobloxGui.Modules:WaitForChild("InGameMenu"):WaitForChild("Resources"):WaitForChild("Constants"))

local isSubjectToChinaPolicies = CachedPolicyService:IsSubjectToChinaPolicies()

local VoiceChatServiceManager = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager)
local default = VoiceChatServiceManager.default
local Constants2 = require(RobloxGui.Modules.VoiceChat.Constants)
local defineFastFlag = game:DefineFastFlag("SettingsHubRaceConditionFix", false)
local defineFastFlag2 = game:DefineFastFlag("FixReportButtonCutOff", false)

local InExperienceAppChatModal = require(CorePackages.Workspace.Packages.AppChat.InExperienceAppChatModal)
local settingsShowSignal

if v3.GetFFlagPackagifySettingsShowSignal() then
	local CoreScriptsCommon2 = require(CorePackages.Workspace.Packages.CoreScriptsCommon)
	settingsShowSignal = CoreScriptsCommon2.SettingsShowSignal
else
	settingsShowSignal = nil
end

local settingsUtility

if v3.GetFFlagPackagifySettingsShowSignal() then
	local CoreScriptsCommon2 = require(CorePackages.Workspace.Packages.CoreScriptsCommon)
	settingsUtility = CoreScriptsCommon2.SettingsUtility
else
	settingsUtility = nil
end

local v8 = { frequency = 4, dampingRatio = 1 }

local InExperienceSideSheet = require(CorePackages.Workspace.Packages.InExperienceSideSheet)
local getDidSideSheetOpenWithPeoplePage = InExperienceSideSheet.getDidSideSheetOpenWithPeoplePage
local getHasRoomForPeoplePage = InExperienceSideSheet.getHasRoomForPeoplePage
local getIsPeoplePageOpen = InExperienceSideSheet.getIsPeoplePageOpen
local getSideSheetAnimationDuration = InExperienceSideSheet.getSideSheetAnimationDuration
local getSideSheetDrawerWidth = InExperienceSideSheet.getSideSheetDrawerWidth
local getSideSheetMenuPageHeight = InExperienceSideSheet.getSideSheetMenuPageHeight
local getSideSheetMenuPageWidth = InExperienceSideSheet.getSideSheetMenuPageWidth
local toggleSideSheet = InExperienceSideSheet.toggleSideSheet
local getSideSheetVisibility = InExperienceSideSheet.getSideSheetVisibility
local setupInGameMenuPeoplePageActions = InExperienceSideSheet.setupInGameMenuPeoplePageActions
local setupPeoplePageOpenTracking = InExperienceSideSheet.setupPeoplePageOpenTracking
local closePeoplePageWhenNoRoomBesideSideSheet = InExperienceSideSheet.closePeoplePageWhenNoRoomBesideSideSheet
local FFlagSideSheetOpenPeoplePage = InExperienceSideSheet.Flags.FFlagSideSheetOpenPeoplePage

local FFlagClosePeoplePageWhenNoRoomBesideSideSheet = InExperienceSideSheet.Flags.FFlagClosePeoplePageWhenNoRoomBesideSideSheet
local isSideSheetEnabled = require(CorePackages.Workspace.Packages.InExperienceSideSheetUtils.isSideSheetEnabled)
local SwitchServer = require(CorePackages.Workspace.Packages.SwitchServer)
local GetSwitchServerStore = SwitchServer.GetSwitchServerStore
local PioneerUtils = require(CorePackages.Workspace.Packages.PioneerUtils)
local isPioneerLaunch = PioneerUtils.isPioneerLaunch

require(RobloxGui.Modules.Settings.ReactPageFactory)

local InExperienceLocales = require(CorePackages.Workspace.Packages.InExperienceLocales)
local Localization = InExperienceLocales.Localization

local fFlagLocalizeVersionLabels = v3.FFlagLocalizeVersionLabels or isSubjectToChinaPolicies
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local function tryTranslate(p, p2)
	if not RobloxTranslator then
		return p2
	end

	local success, result = pcall(RobloxTranslator.FormatByKey, RobloxTranslator, p)
	return if success then result else p2
end

local ChatSelector = require(RobloxGui.Modules.ChatSelector)
local guiInset, _ = GuiService:GetGuiInset()
local udim = UDim2.new(0, 0, 0, -guiInset.Y)
local udim2 = UDim2.new(1, 0, 1, guiInset.Y)

local function GetServerVersionBlocking() -- 1 equivalent call inferred from this helper
	if serverVersionBlocking then
		return serverVersionBlocking
	end

	if not getServerVersion then
		repeat
			wait()
		until getServerVersion
	end

	serverVersionBlocking = getServerVersion:InvokeServer()
	return serverVersionBlocking
end

local function GetServerChannelBlocking()
	if serverChannelBlocking then
		return serverChannelBlocking
	end

	local v9 = defineFastInt2

	if not getServerChannel then
		repeat
			task.wait()
			v9 -= 1
		until getServerChannel or v9 == 0
	end

	if getServerChannel then
		serverChannelBlocking = getServerChannel:InvokeServer()
	else
		warn("GetServerChannelRemote not available")
		serverChannelBlocking = "Unknown"
	end

	return serverChannelBlocking
end

local function GetPlaceVersionText() -- 1 equivalent call inferred from this helper
	if v3.GetFFlagRemoveAssetVersionEndpoint() then
		return game.PlaceVersion
	end

	local placeVersion = game.PlaceVersion

	pcall(function()
		local versionNumber = HttpService:JSONDecode((HttpRbxApiService:GetAsync(string.format("assets/%d/versions", game.PlaceId))))[1].VersionNumber
		placeVersion = string.format("%s (Latest: %d)", placeVersion, versionNumber)
	end)

	return placeVersion
end

local function createReactPage(parent)
	return Create("Frame")({
		Name = "InExperienceMenuPage",
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(0, 0),
		Visible = false,
		Parent = parent
	})
end

local function CreateSettingsHub()
	local children = {}
	children.Visible = false
	children.Active = true
	children.Pages = { CurrentPage = nil, PageTable = {} }
	children.MenuStack = {}
	children.TabHeaders = {}
	children.BottomBarButtons = {}
	children.BottomBarButtonsComponents = {}
	children.ResizedConnection = nil
	children.BackBarVisibleConnection = nil

	if v3.EngineFeatureTeleportHistoryButtons then
		children.FrontBarVisibleConnection = nil
	end

	children.PreferredTransparencyChangedConnection = nil
	children.TabConnection = nil

	children.LeaveGamePage = require(RobloxGui.Modules.Settings.Pages.LeaveGame)
	local leaveGameUpsellPage

	if v3.GetFFlagEnableLeaveGameUpsellEntrypoint() then
		leaveGameUpsellPage = require(RobloxGui.Modules.Settings.Pages.LeaveGameUpsell.LeaveGameUpsell)
	end

	children.LeaveGameUpsellPage = leaveGameUpsellPage
	children.ResetCharacterPage = require(RobloxGui.Modules.Settings.Pages.ResetCharacter)
	local settingsShowSignal2

	if v3.GetFFlagPackagifySettingsShowSignal() then
		settingsShowSignal2 = settingsShowSignal
	else
		settingsShowSignal2 = Utility:CreateSignal()
	end

	children.SettingsShowSignal = settingsShowSignal2
	local currentPageSignal

	if v3.GetFFlagPackagifySettingsShowSignal() then
		currentPageSignal = settingsUtility.CreateSignal()
	else
		currentPageSignal = Utility:CreateSignal()
	end

	children.CurrentPageSignal = currentPageSignal
	local signal, setShowBottomBarSignal = createSignal(false)
	children.showBottomBarSignal = signal
	children.setShowBottomBarSignal = setShowBottomBarSignal
	children.OpenStateChangedCount = 0
	children.BottomButtonFrame = nil

	if v3.FFlagRelocateMobileMenuButtons then
		children.addMenuKeyBindings = nil
		children.removeMenuKeyBindings = nil
	end

	if v3.FFlagIEMFocusNavSupportNewButtons then
		children.ResumeMenuButton = nil
	end

	children.hasMicPermissions = false

	if v3.GetFFlagEnableLeaveGameUpsellEntrypoint() then
		children.checkedUpsell = false
		children.leaveGameUpsellProp = Constants2.PHONE_UPSELL_VALUE_PROP.None
		children.sessionStartTime = os.time()
	end

	children.isFetchingMicPermissions = true

	if v3.FFlagAddUILessMode and v3.FIntAddUILessModeVariant ~= 0 then
		children.uiLessStore = Stores.GetUILessStore(false)
	end

	children.PageTitleLabel = nil
	children.PageTitleCloseButton = nil
	children.PageTitleHeader = nil

	children.isMuted = nil
	children.lastVoiceRecordingIndicatorTextUpdated = nil

	children.playSessionId = ""

	if v3.EngineFeatureRbxAnalyticsServiceExposePlaySessionId then
		children.playSessionId = RbxAnalyticsService:GetPlaySessionId()
	end

	children.reactPageAnalytics = ReactPageAnalytics.new()

	local changedConnection = nil
	local canvasPositionChangedConnection = nil

	local poppedMenu = Instance.new("BindableEvent")
	poppedMenu.Name = "PoppedMenu"
	children.PoppedMenu = poppedMenu.Event

	children.ReactPage = nil
	children.ReactPage = createReactPage()

	local function shouldShowHubBar(p): boolean -- 4 equivalent calls inferred from this helper
		local v9 = p or children.Pages.CurrentPage

		if isSideSheetEnabled then
			return v9.ShouldShowHubBar == true
		end

		return v9.ShouldShowBottomBar == true
	end

	local function updatePageTitleHeader(currentPage) -- 2 equivalent calls inferred from this helper
		if shouldShowHubBar(currentPage) and currentPage.TabHeader then -- inferred equivalent call
			children.PageTitleLabel.Text = currentPage.TabHeader.TabLabel.Title.Text
		else
			children.PageTitleLabel.Text = ""
		end
	end

	local function setTabHeaderSelection(object) -- 3 equivalent calls inferred from this helper
		if not v3.FFlagIEMTabFocusNav then
			return
		end

		local tabHeader = object:GetTabHeader()

		if not tabHeader then
			return
		end

		for _, firstSelectableObject in object.FirstSelectableObjects do
			firstSelectableObject.NextSelectionUp = tabHeader
			tabHeader.NextSelectionDown = firstSelectableObject
		end
	end

	local function updateTabHeaderWrapping() -- 2 equivalent calls inferred from this helper
		if not v3.FFlagIEMTabFocusNav then
			return
		end

		for _, tabHeader in children.TabHeaders do
			tabHeader.NextSelectionLeft = nil
			tabHeader.NextSelectionRight = nil
		end

		local count = #children.TabHeaders

		if count < 2 then
			return
		end

		children.TabHeaders[1].NextSelectionLeft = children.TabHeaders[count]
		children.TabHeaders[count].NextSelectionRight = children.TabHeaders[1]
	end

	local function setBottomBarSelection(object)
		if
			not children.BottomButtonFrame
			and not object
			and (not v3.FFlagRelocateMobileMenuButtons or v3.FIntRelocateMobileMenuButtonsVariant == 0 or v3.FIntRelocateMobileMenuButtonsVariant == 2)
		then
			return
		end

		if children.ResumeButton then
			object.PageNextSelectionDown = children.ResumeButton
		elseif
			v3.FFlagIEMFocusNavSupportNewButtons
			and v3.FIntRelocateMobileMenuButtonsVariant == 2
			and children.ResumeMenuButton
		then
			object.PageNextSelectionDown = children.ResumeMenuButton
		end

		if v3.FFlagIEMTabFocusNav and children.BottomButtonFrame then
			local tabHeader = object:GetTabHeader()

			local resumeButton = children.ResumeButton or children.ResumeMenuButton

			if resumeButton then
				for k, _ in pairs(children.Pages.PageTable) do
					local tabHeader2 = k:GetTabHeader()

					if tabHeader2 then
						tabHeader2.NextSelectionUp = resumeButton
					end
				end
			end

			for _, guiObject in children.BottomButtonFrame:GetDescendants() do
				if guiObject:IsA("GuiObject") and guiObject.Selectable then
					guiObject.NextSelectionDown = tabHeader
				end
			end
		end

		for _, lastSelectableObject in object.LastSelectableObjects do
			children.BottomButtonFrame.SelectionBehaviorUp = Enum.SelectionBehavior.Escape
			children.BottomButtonFrame.NextSelectionUp = lastSelectableObject
			lastSelectableObject.NextSelectionDown = object.PageNextSelectionDown

			local leaveGameButton = children.LeaveGameButton

			if leaveGameButton then
				leaveGameButton.NextSelectionUp = lastSelectableObject
			end

			if not (v3.FFlagIEMFocusNavSupportNewButtons and v3.FIntRelocateMobileMenuButtonsVariant == 2) then
				continue
			end

			for _, guiObject in children.BottomButtonFrame:GetDescendants() do
				if guiObject:IsA("GuiObject") and guiObject.Selectable then
					guiObject.NextSelectionUp = lastSelectableObject
				end
			end
		end

		if #object.LastSelectableObjects < 1 then
			children.BottomButtonFrame.SelectionBehaviorUp = Enum.SelectionBehavior.Stop
			children.BottomButtonFrame.NextSelectionUp = nil
			local leaveGameButton = children.LeaveGameButton

			if leaveGameButton then
				leaveGameButton.NextSelectionUp = nil
			end

			if v3.FFlagIEMFocusNavSupportNewButtons and v3.FIntRelocateMobileMenuButtonsVariant == 2 then
				for _, guiObject in children.BottomButtonFrame:GetDescendants() do
					if not (guiObject:IsA("GuiObject") and guiObject.Selectable) then
						continue
					end

					local nextSelectionUp

					if v3.FFlagIEMTabFocusNav then
						nextSelectionUp = object:GetTabHeader()
					end

					guiObject.NextSelectionUp = nextSelectionUp
				end
			end
		end
	end

	local function shouldShowBottomBar(p): boolean
		local v9 = p or children.Pages.CurrentPage

		if
			(not v3.FFlagRelocateMobileMenuButtons or v3.FIntRelocateMobileMenuButtonsVariant == 0 or v3.FIntRelocateMobileMenuButtonsVariant == 2)
			and (Utility:IsPortrait() or Utility:IsSmallTouchScreen())
			and not Theme.AlwaysShowBottomBar()
		then
			return false
		end

		return v9 ~= nil and v9.ShouldShowBottomBar == true
	end

	local function shouldDisableDefaultScroll(p): boolean -- 2 equivalent calls inferred from this helper
		local v9 = p or children.Pages.CurrentPage
		return v9 ~= nil and v9.ShouldDisableDefaultScroll == true
	end

	local function setBottomBarBindings()
		if not children.Visible then
			return
		end

		if v3.FFlagRelocateMobileMenuButtons and v3.FIntRelocateMobileMenuButtonsVariant ~= 0 then
			if children.addMenuKeyBindings then
				children.addMenuKeyBindings()
			end
		else
			for i = 1, #children.BottomBarButtons do
				local bottomBarButton = children.BottomBarButtons[i]
				local v9 = bottomBarButton[1]
				local v10 = bottomBarButton[2]
				ContextActionService:BindCoreAction(v9, v10[1], false, unpack(v10[2]))
			end
		end

		if children.BottomButtonFrame then
			children.BottomButtonFrame.Visible = true
		end
	end

	local function removeBottomBarBindings(p)
		if v3.FFlagRelocateMobileMenuButtons and v3.FIntRelocateMobileMenuButtonsVariant ~= 0 then
			if children.removeMenuKeyBindings then
				children.removeMenuKeyBindings()
			end
		else
			for _, bottomBarButton in pairs(children.BottomBarButtons) do
				ContextActionService:UnbindCoreAction(bottomBarButton[1])
			end
		end

		local openStateChangedCount = children.OpenStateChangedCount
		local function fn() -- 1 equivalent call inferred from this helper
			if children.OpenStateChangedCount == openStateChangedCount and children.BottomButtonFrame then
				children.BottomButtonFrame.Visible = false
			end
		end

		if p then
			delay(p, fn)
			return
		end

		fn() -- inferred equivalent call
	end

	local function updateButtonPosition(p, position, size)
		if not v3.FFlagRelocateMobileMenuButtons or v3.FIntRelocateMobileMenuButtonsVariant == 0 then
			local child = children.BottomButtonFrame:FindFirstChild(p .. "ButtonButton", true)

			if not child then
				return
			end

			child.Position = position
			child.Size = size
		end
	end

	local robloxLocaleId = LocalizationService.RobloxLocaleId
	local v9 = Localization.new(robloxLocaleId)

	local function hideVoiceUx()
		local muteButtonButton = children.MuteButtonButton

		if muteButtonButton then
			muteButtonButton.Visible = false
			muteButtonButton:Destroy()
		end

		local udim3

		if v then
			udim3 = UDim2.new(0, 320, 0, 72)
		else
			udim3 = UDim2.new(0, 260, 0, Theme.LargeButtonHeight)
		end

		if not v3.FFlagRelocateMobileMenuButtons or v3.FIntRelocateMobileMenuButtonsVariant == 0 then
			local udim4 = UDim2.new(0.5, v and -160 or -130, 0.5, -25)
			local leaveGameButtonButton = (not v3.FFlagRelocateMobileMenuButtons or v3.FIntRelocateMobileMenuButtonsVariant == 0)
				and children.BottomButtonFrame:FindFirstChild("LeaveGameButtonButton", true)

			if leaveGameButtonButton then
				leaveGameButtonButton.Position = udim4
				leaveGameButtonButton.Size = udim3
			end

			local udim5 = UDim2.new(0.5, v and -550 or -400, 0.5, -25)
			local resetCharacterButtonButton = (not v3.FFlagRelocateMobileMenuButtons or v3.FIntRelocateMobileMenuButtonsVariant == 0)
				and children.BottomButtonFrame:FindFirstChild("ResetCharacterButtonButton", true)

			if resetCharacterButtonButton then
				resetCharacterButtonButton.Position = udim5
				resetCharacterButtonButton.Size = udim3
			end

			local udim6 = UDim2.new(0.5, v and 200 or 140, 0.5, -25)

			if not v3.FFlagRelocateMobileMenuButtons or v3.FIntRelocateMobileMenuButtonsVariant == 0 then
				local resumeButtonButton = children.BottomButtonFrame:FindFirstChild("ResumeButtonButton", true)

				if not resumeButtonButton then
					return
				end

				resumeButtonButton.Position = udim6
				resumeButtonButton.Size = udim3
			end
		end
	end

	local function addBottomBarButtonOld(p, p2, image, image2, position, fn, p3, fn2)
		if not v3.FFlagRelocateMobileMenuButtons or v3.FIntRelocateMobileMenuButtonsVariant == 0 then
			local v10 = p .. "Button"
			local v11 = p .. "Text"

			local udim3 = UDim2.new(0, 260, 0, Theme.LargeButtonHeight)

			if v then
				udim3 = UDim2.new(0, 320, 0, 72)
			end

			local styledButton, v12 = Utility:MakeStyledButton(p .. "Button", p2, udim3, fn, nil, children)
			children[v10] = styledButton
			children[v11] = v12
			Create("UIListLayout")({
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Parent = children[v10]
			})

			Create("UIPadding")({ PaddingLeft = UDim.new(0.025, 0), Parent = children[v10] })

			children[v11].Size = UDim2.new(0, 0, 1, 0)

			Create("UIFlexItem")({ FlexMode = Enum.UIFlexMode.Grow, Parent = children[v11] })

			children[v10].Position = position
			children[v10].Parent = children.BottomButtonFrame

			if v then
				children[v10].ImageTransparency = 1
			end

			children[v11].FontSize = Enum.FontSize.Size24
			local v13

			if v6 then
				v13 = nil
			else
				local name = p .. "Hint"
				local image3

				if
					UserInputService:GetGamepadConnected(Enum.UserInputType.Gamepad1)
					or platform == Enum.Platform.XBoxOne
				then
					image3 = image
				else
					image3 = image2
				end

				v13 = Create("ImageLabel")({
					Name = name,
					ZIndex = children.Shield.ZIndex + 2,
					BackgroundTransparency = 1,
					Image = image3,
					LayoutOrder = -1,
					Parent = children[v10]
				})

				if image3 == image2 then
					v13.ImageColor3 = Theme.color("WhiteButtonText", Color3.new(1, 1, 1))
					v13.ImageTransparency = Theme.transparency("WhiteButtonText", 1)
				end

				v13.Position = UDim2.new(0, 9, 0.5, 0)
				v13.Size = UDim2.new(0, 33, 0, 33)
				v13.AnchorPoint = Vector2.new(0, 0.5)
			end

			if v then
				children[v11].FontSize = Enum.FontSize.Size36
			end

			UserInputService.InputBegan:connect(function(p4)
				if
					p4.UserInputType == Enum.UserInputType.Gamepad1
					or p4.UserInputType == Enum.UserInputType.Gamepad2
					or p4.UserInputType == Enum.UserInputType.Gamepad3
					or p4.UserInputType == Enum.UserInputType.Gamepad4
				then
					if v13 then
						v13.Image = image
					end
				elseif p4.UserInputType == Enum.UserInputType.Keyboard and v13 then
					v13.Image = image2
				end
			end)

			children.BottomBarButtons[#children.BottomBarButtons + 1] = {
				v10,
				{
					function(_, p4, _)
						if p4 == Enum.UserInputState.Begin then
							fn2()
						end
					end,
					p3
				}
			}
		end
	end

	local v10 = v and "@2x" or ""
	local v11, v12, v13

	if v3.FFlagEnableConsoleExpControls then
		v11 = UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonB)
		v12 = UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonX)
		v13 = UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonY)
	else
		v11 = "rbxasset://textures/ui/Controls/DesignSystem/ButtonB" .. v10 .. ".png"
		v12 = "rbxasset://textures/ui/Controls/DesignSystem/ButtonX" .. v10 .. ".png"
		v13 = "rbxasset://textures/ui/Controls/DesignSystem/ButtonY" .. v10 .. ".png"
	end

	local imageForKeyCode = UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonStart)

	local v14 = false
	local eventConnection = nil

	local function setupVoiceListeners()
		if game:GetEngineFeature("VoiceChatSupported") and not v14 then
			v14 = true
			local function showUI()
				children.VoiceRecordingText.Visible = true
				default:getService().StateChanged:Connect(function(_, p)
					if p == Enum.VoiceChatState.Joined then
						children.VoiceRecordingText.Visible = true
					end
				end)
				default:SetupParticipantListeners()
				getCamMicPermissions(function(p)
					children.hasMicPermissions = p.hasMicPermissions
				end, nil, true, "PermissionsButtons.getPermissions")
				eventConnection = default.muteChanged.Event:Connect(function(isMuted)
					children.isMuted = isMuted
					children.lastVoiceRecordingIndicatorTextUpdated = tick()
					children.voiceRecordingIndicatorTextMotor:setGoal(Otter.instant(0))

					if children.isMuted then
						local voiceRecordingText = children.VoiceRecordingText
						local text

						if RobloxTranslator then
							local success, result = pcall(
								RobloxTranslator.FormatByKey,
								RobloxTranslator,
								"InGame.CommonUI.Label.MicOff"
							)
							text = not success and "Mic Off" or result
						else
							text = "Mic Off"
						end

						voiceRecordingText.Text = text
					else
						local voiceRecordingText = children.VoiceRecordingText
						local text

						if RobloxTranslator then
							local success, result = pcall(
								RobloxTranslator.FormatByKey,
								RobloxTranslator,
								"InGame.CommonUI.Label.MicOnRecording"
							)
							text = not success and "Mic On (recording audio)" or result
						else
							text = "Mic On (recording audio)"
						end

						voiceRecordingText.Text = text
					end
				end)
			end
			local function hideUI()
				children.VoiceRecordingText.Visible = false
				hideVoiceUx()

				if eventConnection then
					eventConnection:Disconnect()
				end
			end

			if default.voiceUIVisible then
				showUI()
			end

			default.showVoiceUI.Event:Connect(showUI)
			default.hideVoiceUI.Event:Connect(hideUI)
		end
	end

	if not defineFastFlag then
		setupVoiceListeners()
	end

	local v15 = true
	local function setResetEnabled(p)
		v15 = p

		if children.ResetCharacterButton then
			children.ResetCharacterButton.Selectable = p
			children.ResetCharacterButton.Active = p
			children.ResetCharacterButton.Enabled.Value = p
			local resetCharacterHint = children.ResetCharacterButton:FindFirstChild("ResetCharacterHint")

			if resetCharacterHint then
				resetCharacterHint.ImageColor3 = p and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(100, 100, 100)
			end

			local resetCharacterButtonTextLabel = children.ResetCharacterButton:FindFirstChild("ResetCharacterButtonTextLabel")

			if resetCharacterButtonTextLabel then
				resetCharacterButtonTextLabel.TextColor3 = p and Color3.fromRGB(255, 255, 255)
					or Color3.fromRGB(100, 100, 100)
			end
		end
	end

	local v16 = nil
	function children:GetRespawnBehaviour()
		if v3.FFlagRelocateMobileMenuButtons and v3.FIntRelocateMobileMenuButtonsVariant ~= 0 then
			return
				children:GetExperienceControlStore().getCanRespawn(false),
				children:GetExperienceControlStore().getCustomRespawnCallback(false)
		end

		return v15, v16
	end

	children.RespawnBehaviourChangedEvent = Instance.new("BindableEvent")

	StarterGui:RegisterSetCore("ResetButtonCallback", function(bindableEvent)
		local v17

		if typeof(bindableEvent) == "Instance" then
			v17 = bindableEvent:IsA("BindableEvent")
		else
			v17 = false
		end

		if v17 or type(bindableEvent) == "boolean" then
			children.ResetCharacterPage:SetResetCallback(bindableEvent)
		else
			warn("ResetButtonCallback must be set to a BindableEvent or a boolean")
		end

		local v18

		if v3.FFlagRelocateMobileMenuButtons and v3.FIntRelocateMobileMenuButtonsVariant ~= 0 then
			v18 = children:GetExperienceControlStore().getCanRespawn(false)
		else
			v18 = v15
		end

		if bindableEvent == false then
			if v3.FFlagRelocateMobileMenuButtons and v3.FIntRelocateMobileMenuButtonsVariant ~= 0 then
				children:GetExperienceControlStore().setCanRespawn(false)
			else
				setResetEnabled(false)
			end

			if isSideSheetEnabled then
				InExperienceSideSheet.setIsRespawnEnabled(false)
			end
		elseif not v18 and (v17 or bindableEvent == true) then
			if v3.FFlagRelocateMobileMenuButtons and v3.FIntRelocateMobileMenuButtonsVariant ~= 0 then
				children:GetExperienceControlStore().setCanRespawn(true)
			else
				setResetEnabled(true)
			end

			if isSideSheetEnabled then
				InExperienceSideSheet.setIsRespawnEnabled(true)
			end
		end

		if v17 then
			if v3.FFlagRelocateMobileMenuButtons and v3.FIntRelocateMobileMenuButtonsVariant ~= 0 then
				children:GetExperienceControlStore().setCustomRespawnCallback(bindableEvent)
			else
				v16 = bindableEvent
			end
		end

		if v3.FFlagRelocateMobileMenuButtons and v3.FIntRelocateMobileMenuButtonsVariant ~= 0 then
			children.RespawnBehaviourChangedEvent:Fire(
				children:GetExperienceControlStore().getCanRespawn(false),
				children:GetExperienceControlStore().getCustomRespawnCallback(false)
			)
		else
			children.RespawnBehaviourChangedEvent:Fire(v15, v16)
		end
	end)

	StarterGui:RegisterGetCore("ResetButtonCallback", function()
		local respawnBehaviour, _ = children:GetRespawnBehaviour()
		return respawnBehaviour
	end)

	local setVisibilityInternal

	local signal2, v17 = createSignal(true)
	local signal3, setCustomRespawnCallback = createSignal(nil)

	function children:GetExperienceControlStore()
		return {
			getCanRespawn = signal2,
			getCustomRespawnCallback = signal3,
			setCanRespawn = function(flag: boolean)
				v17(flag)

				if children.ResetCharacterButton then
					children.ResetCharacterButton.Selectable = flag
					children.ResetCharacterButton.Active = flag
					children.ResetCharacterButton.Enabled.Value = flag
					local resetCharacterHint = children.ResetCharacterButton:FindFirstChild("ResetCharacterHint")

					if resetCharacterHint then
						resetCharacterHint.ImageColor3 = flag and Color3.fromRGB(255, 255, 255)
							or Color3.fromRGB(100, 100, 100)
					end

					local resetCharacterButtonTextLabel = children.ResetCharacterButton:FindFirstChild("ResetCharacterButtonTextLabel")

					if resetCharacterButtonTextLabel then
						resetCharacterButtonTextLabel.TextColor3 = flag and Color3.fromRGB(255, 255, 255)
							or Color3.fromRGB(100, 100, 100)
					end
				end
			end,
			setCustomRespawnCallback = setCustomRespawnCallback,
			onLeaveGame = function(source: string)
				if not children:GetVisibility() then
					return
				end

				children:AddToMenuStack(children.Pages.CurrentPage)
				children.HubBar.Visible = false

				if
					v3.GetFFlagEnableLeaveGameUpsellEntrypoint()
					and children.leaveGameUpsellProp ~= Constants2.PHONE_UPSELL_VALUE_PROP.None
				then
					children:SwitchToPage(children.LeaveGameUpsellPage, false)
				else
					children:SwitchToPage(children.LeaveGamePage, false, nil, true)
				end

				TelemetryService:LogCounter(MenuLeaveGameTelemetryConfig, {
					customFields = { source = source }
				})
			end,
			onRespawn = function(source: string)
				if not signal2(false) then
					return
				end

				children:AddToMenuStack(children.Pages.CurrentPage)
				children.HubBar.Visible = false
				children:SwitchToPage(children.ResetCharacterPage, false, nil, true)

				TelemetryService:LogCounter(MenuResetCharacterTelemetryConfig, {
					customFields = { source = source }
				})
			end,
			onResume = function(source: string)
				if v3.FFlagAddUILessMode then
					children:SetVisibility(false, nil, nil, nil, source)
				else
					children:SetVisibility(false)
				end

				if
					v3.FFlagAddUILessMode
					and v3.FIntAddUILessModeVariant ~= 0
					and children.uiLessStore.getUILessModeEnabled(false)
				then
					children.uiLessStore.setUIVisible(false)
				end

				RbxAnalyticsService:SetRBXEventStream(
					Constants.AnalyticsTargetName,
					Constants.AnalyticsResumeGameName,
					Constants.AnalyticsMenuActionName,
					{
						source = source,
						playsessionid = children.playSessionId,
						universeid = tostring(game.GameId)
					}
				)

				TelemetryService:LogCounter(MenuResumeTelemetryConfig, {
					customFields = { source = source }
				})
			end
		}
	end

	local fn = v3.FFlagRelocateMobileMenuButtons and v3.FIntRelocateMobileMenuButtonsVariant ~= 0 and function()
		if children.BottomButtonFrameRoot then
			return
		end

		local experienceControlStore = children:GetExperienceControlStore()

		children.BottomButtonFrameRoot = ReactRoblox.createRoot(children.BottomButtonFrame)
		local bottomButtonFrameRoot = children.BottomButtonFrameRoot
		local createElement = React.createElement
		local v18 = {
			onLeaveGame = experienceControlStore.onLeaveGame,
			onRespawn = experienceControlStore.onRespawn,
			onResume = experienceControlStore.onResume,
			setAddMenuKeyBindings = function(addMenuKeyBindings)
				children.addMenuKeyBindings = addMenuKeyBindings
			end,
			setRemoveMenuKeyBindings = function(removeMenuKeyBindings)
				children.removeMenuKeyBindings = removeMenuKeyBindings
			end,
			getVisibility = function()
				return children.GetVisibility()
			end,
			getCanRespawn = experienceControlStore.getCanRespawn,
			currentPageChangeSignal = 0,
			setResumeMenuButton = 0
		}
		local currentPageChangeSignal

		if Flags.FFlagAddTraversalHistoryReactMenuButtons then
			currentPageChangeSignal = children.CurrentPageSignal
		end

		v18.currentPageChangeSignal = currentPageChangeSignal
		v18.setResumeMenuButton = v3.FFlagIEMFocusNavSupportNewButtons and function(p)
			children.ResumeMenuButton = p

			if
				v3.FFlagIEMFocusNavSupportNewButtons
				and not (GuiService.SelectedCoreObject and GuiService.SelectedCoreObject:IsDescendantOf(children.Shield))
			then
				GuiService.SelectedCoreObject = p
			end
		end or nil
		bottomButtonFrameRoot:render(createElement(MenuButtonsContainer, v18))
	end or nil

	local fn2 = v3.FFlagRelocateMobileMenuButtons and v3.FIntRelocateMobileMenuButtonsVariant ~= 0 and function()
		if children.BottomButtonFrameRoot then
			children.BottomButtonFrameRoot:unmount()
			children.BottomButtonFrameRoot = nil
		end
	end or nil

	local function createGui()
		local v18 = Utility:IsSmallTouchScreen() and 5 or 0

		children.ClippingShield = Create("Frame")({
			Name = "SettingsClippingShield",
			Size = udim2,
			Position = udim,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			BackgroundTransparency = 1,
			Visible = true,
			ZIndex = 2,
			Parent = RobloxGui
		})

		children.CanvasGroup = Create("CanvasGroup")({
			Name = "CanvasGroup",
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			GroupTransparency = 0,
			Visible = false,
			Parent = children.ClippingShield
		})

		children.Shield = Create("ImageButton")({
			Name = "SettingsShield",
			Size = UDim2.new(1, 0, 1, 0),
			Position = SHIELD_INACTIVE_POSITION,
			BackgroundTransparency = transparency,
			BackgroundColor3 = color,
			BorderSizePixel = 0,
			Visible = false,
			Active = true,
			ZIndex = 2,
			Parent = children.ClippingShield
		})

		children.VRShield = Create("Frame")({
			Name = "VRBackground",
			Parent = children.Shield,
			BackgroundColor3 = color,
			BackgroundTransparency = transparency,
			Position = UDim2.new(0, -4, 0, 24),
			Size = UDim2.new(1, 8, 1, -40),
			BorderSizePixel = 0,
			Visible = false
		})

		local engineFeature = game:GetEngineFeature("CoreScriptVersionEnabled")

		if engineFeature then
			children.VersionContainer = Create("ScrollingFrame")({
				Name = "VersionContainer",
				Parent = children.Shield,
				CanvasSize = UDim2.new(0, 0, 0, v2),
				BackgroundColor3 = color,
				BackgroundTransparency = transparency,
				Position = UDim2.new(0, 0, 1, 0),
				Size = UDim2.new(1, 0, 0, v2),
				AnchorPoint = Vector2.new(0, 1),
				BorderSizePixel = 0,
				AutoLocalize = false,
				ScrollingDirection = Enum.ScrollingDirection.X,
				ScrollBarThickness = 0,
				ZIndex = 5,
				Visible = false
			})
		else
			children.VersionContainer = Create("Frame")({
				Name = "VersionContainer",
				Parent = children.Shield,
				BackgroundColor3 = color,
				BackgroundTransparency = transparency,
				Position = UDim2.new(0, 0, 1, 0),
				Size = UDim2.new(1, 0, 0, v2),
				AnchorPoint = Vector2.new(0, 1),
				BorderSizePixel = 0,
				AutoLocalize = false,
				ZIndex = 5,
				Visible = false
			})
		end

		local v19 = Create("UIListLayout")({
			Name = "VersionContainer",
			Parent = children.VersionContainer,
			Padding = UDim.new(0, 6),
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		})

		local function addSizeToLabel(p) -- 8 equivalent calls inferred from this helper
			local udim3 = UDim2.new(0.2, -6, 1, 0)
			udim3 = engineFeature and UDim2.new(0, p.TextBounds.X + 6, 0, v2) or udim3
			p.Size = udim3
		end

		if v3.GetFFlagDisplayServerChannel() then
			children.ServerChannelLabel = Create("TextLabel")({
				Name = "ServerChannelLabel",
				Parent = children.VersionContainer,
				LayoutOrder = 3,
				BackgroundTransparency = 1,
				TextColor3 = Color3.new(1, 1, 1),
				TextSize = Theme.textSize(v and 28 or Utility:IsSmallTouchScreen() and 14 or 20),
				Text = "Server Channel: ...",
				Font = Theme.font(Enum.Font.SourceSans, "SettingsHub"),
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				ZIndex = 5
			})

			spawn(function()
				local v20

				if fFlagLocalizeVersionLabels and RobloxTranslator then
					local success, result = pcall(
						RobloxTranslator.FormatByKey,
						RobloxTranslator,
						"InGame.HelpMenu.Label.ServerChannel"
					)
					v20 = not success and "Server Channel: " or result
				else
					v20 = "Server Channel: "
				end

				children.ServerChannelLabel.Text = v20 .. GetServerChannelBlocking()
				addSizeToLabel(children.ServerChannelLabel) -- inferred equivalent call
				children.ServerChannelLabel.TextScaled = not (engineFeature or children.ServerChannelLabel.TextFits)
			end)
		end

		children.ServerVersionLabel = Create("TextLabel")({
			Name = "ServerVersionLabel",
			Parent = children.VersionContainer,
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			TextColor3 = Color3.new(1, 1, 1),
			TextSize = Theme.textSize(v and 28 or Utility:IsSmallTouchScreen() and 14 or 20),
			Text = "Server Version: ...",
			Font = Theme.font(Enum.Font.SourceSans, "SettingsHub"),
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			ZIndex = 5
		})

		spawn(function()
			local v20

			if fFlagLocalizeVersionLabels and RobloxTranslator then
				local success, result = pcall(
					RobloxTranslator.FormatByKey,
					RobloxTranslator,
					"InGame.HelpMenu.Label.ServerVersion"
				)
				v20 = not success and "Server Version: " or result
			else
				v20 = "Server Version: "
			end

			local serverVersionLabel = children.ServerVersionLabel
			serverVersionLabel.Text = v20 .. GetServerVersionBlocking() -- inferred equivalent call
			addSizeToLabel(children.ServerVersionLabel) -- inferred equivalent call
			children.ServerVersionLabel.TextScaled = not (engineFeature or children.ServerVersionLabel.TextFits)
		end)
		local v20

		if fFlagLocalizeVersionLabels and RobloxTranslator then
			local success, result = pcall(
				RobloxTranslator.FormatByKey,
				RobloxTranslator,
				"InGame.HelpMenu.Label.ClientVersion"
			)
			v20 = not success and "Client Version: " or result
		else
			v20 = "Client Version: "
		end

		local robloxVersion = RunService:GetRobloxVersion()
		local success, result = pcall(function()
			return RunService.ClientGitHash
		end)

		if success then
			robloxVersion = string.format("%s (%.6s)", robloxVersion, result)
		end

		children.ClientVersionLabel = Create("TextLabel")({
			Name = "ClientVersionLabel",
			Parent = children.VersionContainer,
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			TextColor3 = Color3.new(1, 1, 1),
			TextSize = Theme.textSize(v and 28 or Utility:IsSmallTouchScreen() and 14 or 20),
			Text = v20 .. robloxVersion,
			Font = Theme.font(Enum.Font.SourceSans, "SettingsHub"),
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			ZIndex = 5
		})

		addSizeToLabel(children.ClientVersionLabel) -- inferred equivalent call
		children.ClientVersionLabel.TextScaled = not (engineFeature or children.ClientVersionLabel.TextFits)

		children.PlaceVersionLabel = Create("TextLabel")({
			Name = "PlaceVersionLabel",
			Parent = children.VersionContainer,
			BackgroundTransparency = 1,
			LayoutOrder = 3,
			TextColor3 = Color3.new(1, 1, 1),
			TextSize = Theme.textSize(v and 28 or Utility:IsSmallTouchScreen() and 14 or 20),
			Text = "Place Version: ...",
			Font = Theme.font(Enum.Font.SourceSans, "SettingsHub"),
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			ZIndex = 5
		})

		local function setPlaceVersionText()
			local v21

			if fFlagLocalizeVersionLabels and RobloxTranslator then
				local success2, result2 = pcall(
					RobloxTranslator.FormatByKey,
					RobloxTranslator,
					"InGame.HelpMenu.Label.PlaceVersion"
				)
				v21 = not success2 and "Place Version: " or result2
			else
				v21 = "Place Version: "
			end

			local placeVersionLabel = children.PlaceVersionLabel
			placeVersionLabel.Text = v21 .. GetPlaceVersionText() -- inferred equivalent call
			addSizeToLabel(children.PlaceVersionLabel) -- inferred equivalent call
			children.PlaceVersionLabel.TextScaled = not (engineFeature or children.PlaceVersionLabel.TextFits)
		end
		game:GetPropertyChangedSignal("PlaceVersion"):Connect(setPlaceVersionText)
		spawn(setPlaceVersionText)

		if not CachedPolicyService:IsSubjectToChinaPolicies() then
			children.EnvironmentLabel = Create("TextLabel")({
				Name = "EnvironmentLabel",
				Parent = children.VersionContainer,
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundTransparency = 1,
				TextColor3 = Color3.new(1, 1, 1),
				LayoutOrder = 4,
				TextSize = Theme.textSize(v and 28 or Utility:IsSmallTouchScreen() and 14 or 20),
				Text = BaseUrl,
				Font = Theme.font(Enum.Font.SourceSans, "SettingsHub"),
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				ZIndex = 5,
				Visible = visible2
			})

			addSizeToLabel(children.EnvironmentLabel) -- inferred equivalent call
			children.EnvironmentLabel.TextScaled = not (engineFeature or children.EnvironmentLabel.TextFits)
		end

		if game:GetEngineFeature("GetPlaySessionIdEnabled") then
			local playSessionId = game:GetPlaySessionId()

			if playSessionId ~= "" then
				local text = "PlaySessionId: " .. playSessionId

				if RobloxTranslator then
					text = RobloxTranslator:FormatByKey("InGame.HelpMenu.Label.PlaySessionId", {
						RBX_STR = playSessionId
					})
				end

				children.PlaySessionIdLabel = Create("TextLabel")({
					Name = "PlaySessionIdLabel",
					Parent = children.VersionContainer,
					BackgroundTransparency = 1,
					LayoutOrder = 5,
					TextColor3 = Color3.new(1, 1, 1),
					TextSize = Theme.textSize(v and 28 or Utility:IsSmallTouchScreen() and 14 or 20),
					Text = text,
					Font = Theme.font(Enum.Font.SourceSans, "SettingsHub"),
					TextXAlignment = Enum.TextXAlignment.Center,
					TextYAlignment = Enum.TextYAlignment.Center,
					ZIndex = 5
				})

				addSizeToLabel(children.PlaySessionIdLabel) -- inferred equivalent call
				children.PlaySessionIdLabel.TextScaled = not children.PlaySessionIdLabel.TextFits
			end
		end

		local function getOverridesPlayerScripts()
			if v3.EngineFeaturePlayerScriptStatusProperty then
				return ({
					[0] = "Unknown",
					[1] = "v3 Custom",
					[2] = "v3 Default",
					[3] = "v1 Custom",
					[4] = "v2 Default",
					[5] = "v2 Custom"
				})[StarterPlayer.PlayerModuleStatus]
			end

			local starterPlayerScripts = StarterPlayer:WaitForChild(
				"StarterPlayerScripts",
				v3.FFlagRemoveLoadingTimeout and 1e999 or nil
			)
			local playerScriptsLoader = starterPlayerScripts:FindFirstChild("PlayerScriptsLoader")
			local playerModule = starterPlayerScripts:FindFirstChild("PlayerModule")

			if playerModule and playerScriptsLoader and not playerModule.Archivable then
				if playerScriptsLoader.Archivable then
					if not (fFlagLocalizeVersionLabels and RobloxTranslator) then
						return "Possibly Custom"
					end

					local success2, result2 = pcall(
						RobloxTranslator.FormatByKey,
						RobloxTranslator,
						"InGame.CommonUI.Label.PossiblyCustom"
					)

					if success2 then
						return result2
					end

					return "Possibly Custom"
				else
					if not (fFlagLocalizeVersionLabels and RobloxTranslator) then
						return "Default"
					end

					local success2, result2 = pcall(
						RobloxTranslator.FormatByKey,
						RobloxTranslator,
						"InGame.CommonUI.Label.Default"
					)
					return if success2 then result2 else "Default"
				end
			else
				local cameraScript = starterPlayerScripts:FindFirstChild("CameraScript")
				local controlScript = starterPlayerScripts:FindFirstChild("ControlScript")

				if cameraScript or controlScript then
					if not (fFlagLocalizeVersionLabels and RobloxTranslator) then
						return "Custom Old"
					end

					local success2, result2 = pcall(
						RobloxTranslator.FormatByKey,
						RobloxTranslator,
						"InGame.CommonUI.Label.CustomOld"
					)
					return if success2 then result2 else "Custom Old"
				else
					if not (fFlagLocalizeVersionLabels and RobloxTranslator) then
						return "Custom"
					end

					local success2, result2 = pcall(
						RobloxTranslator.FormatByKey,
						RobloxTranslator,
						"InGame.CommonUI.Label.Custom"
					)
					return if success2 then result2 else "Custom"
				end
			end
		end

		children.OverridesPlayerScriptsLabel = Create("TextLabel")({
			Name = "OverridesPlayerScriptsLabel",
			Parent = children.VersionContainer,
			AnchorPoint = Vector2.new(0.5, 0),
			BackgroundTransparency = 1,
			TextColor3 = Color3.new(1, 1, 1),
			LayoutOrder = 5,
			TextSize = Theme.textSize(v and 28 or Utility:IsSmallTouchScreen() and 14 or 20),
			Text = "PlayerScripts: ",
			Font = Theme.font(Enum.Font.SourceSans, "SettingsHub"),
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			ZIndex = 5,
			Visible = false
		})

		spawn(function()
			local PlayerPermissionsModule = require(RobloxGui.Modules.PlayerPermissionsModule)

			if not Players.LocalPlayer then
				Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
			end

			if v3.FFlagWaitPlayerModuleStatus and StarterPlayer.PlayerModuleStatus == 0 then
				StarterPlayer:GetPropertyChangedSignal("PlayerModuleStatus"):Wait()
			end

			local v21

			if fFlagLocalizeVersionLabels and RobloxTranslator then
				local success2, result2 = pcall(
					RobloxTranslator.FormatByKey,
					RobloxTranslator,
					"InGame.HelpMenu.Label.PlayerScripts"
				)
				v21 = not success2 and "PlayerScripts: " or result2
			else
				v21 = "PlayerScripts: "
			end

			local overridesPlayerScripts = getOverridesPlayerScripts()
			local defaultPlayerScripts

			if v3.EngineFeaturePlayerScriptStatusProperty then
				defaultPlayerScripts = overridesPlayerScripts == "v3 Default"
			else
				defaultPlayerScripts = overridesPlayerScripts == "Default"
			end

			local analyticsTargetName = Constants.AnalyticsTargetName
			local v22 = {
				defaultPlayerScripts = defaultPlayerScripts,
				placeID = tostring(game.PlaceId),
				rawValue = 0,
				context = 0
			}
			local rawValue

			if v3.GetFFlagNewEventIngestPlayerScriptsDimensions() then
				rawValue = overridesPlayerScripts
			end

			v22.rawValue = rawValue
			v22.context = v3.GetFFlagNewEventIngestPlayerScriptsDimensions() and "IGMv1" or nil
			RbxAnalyticsService:setRBXEventStream(
				analyticsTargetName,
				"player_scripts_status",
				"player_scripts_status_action",
				v22
			)

			children.OverridesPlayerScriptsLabel.Text = v21 .. overridesPlayerScripts
			children.OverridesPlayerScriptsLabel.Visible = visible2
				or PlayerPermissionsModule.IsPlayerAdminAsync(Players.LocalPlayer)
			addSizeToLabel(children.OverridesPlayerScriptsLabel) -- inferred equivalent call
			children.OverridesPlayerScriptsLabel.TextScaled = not (engineFeature or children.OverridesPlayerScriptsLabel.TextFits)
		end)

		if engineFeature then
			local v21

			if fFlagLocalizeVersionLabels and RobloxTranslator then
				local success2, result2 = pcall(
					RobloxTranslator.FormatByKey,
					RobloxTranslator,
					"InGame.HelpMenu.Label.ClientCoreScriptVersion"
				)
				v21 = not success2 and "Client CoreScript Version: " or result2
			else
				v21 = "Client CoreScript Version: "
			end

			children.CoreScriptVersionLabel = Create("TextLabel")({
				Name = "CoreScriptVersionLabel",
				Parent = children.VersionContainer,
				LayoutOrder = 6,
				BackgroundTransparency = 1,
				TextColor3 = Color3.new(1, 1, 1),
				TextSize = Theme.textSize(v and 28 or Utility:IsSmallTouchScreen() and 14 or 20),
				Text = v21 .. RunService:GetCoreScriptVersion(),
				Font = Theme.font(Enum.Font.SourceSans, "SettingsHub"),
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				ZIndex = 5
			})

			addSizeToLabel(children.CoreScriptVersionLabel) -- inferred equivalent call

			local versionContainer = children.VersionContainer
			v19:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				versionContainer.CanvasSize = UDim2.new(0, v19.AbsoluteContentSize.X, 0, v2)
			end)
		end

		children.Modal = Create("TextButton")({
			Name = "Modal",
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 0, 1, -1),
			Size = UDim2.new(1, 0, 1, 0),
			Modal = true,
			Text = "",
			Parent = children.Shield,
			Selectable = false
		})

		if v3.FFlagSettingsHubIndependentBackgroundVisibility then
			local create = Create("ImageButton")
			local darkenBackground = {
				Name = "DarkenBackground",
				ZIndex = children.Shield.ZIndex - 1,
				BackgroundTransparency = 1,
				BackgroundColor3 = 0,
				Size = 0,
				Parent = 0,
				AutoButtonColor = false,
				Visible = false
			}
			local backgroundColor

			if v3.isInExperienceUIVREnabled then
				backgroundColor = children.SettingsUIDelegate:getDarkBackgroundTheme().Color
			else
				backgroundColor = Theme.color("DarkenBackground")
			end

			darkenBackground.BackgroundColor3 = backgroundColor

			darkenBackground.Size = UDim2.new(1, 0, 1, 0)
			darkenBackground.Parent = children.ClippingShield
			children.DarkenBackground = create(darkenBackground)
		else
			children.DarkenBackground = Create("Frame")({
				Name = "DarkenBackground",
				ZIndex = children.Shield.ZIndex - 1,
				BackgroundTransparency = 1,
				BackgroundColor3 = Theme.color("DarkenBackground"),
				Size = UDim2.new(1, 0, 1, 0),
				Parent = children.ClippingShield
			})
		end

		local menuContainerPosition = Theme.MenuContainerPosition(children.SettingsUIDelegate)
		children.MenuContainer = Create("ImageButton")({
			Name = "MenuContainer",
			ZIndex = children.Shield.ZIndex,
			BackgroundTransparency = Theme.transparency("MenuContainer", 1),
			BackgroundColor3 = Theme.color("MenuContainer"),
			Position = menuContainerPosition.Position,
			Size = menuContainerPosition.Size,
			AnchorPoint = menuContainerPosition.AnchorPoint,
			AutomaticSize = menuContainerPosition.AutomaticSize,
			Parent = children.Shield
		})

		children.ReactPage.Parent = children.MenuContainer

		children.Page = Create("Frame")({
			Name = "Page",
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY,
			Parent = children.MenuContainer
		})

		children.Page.SelectionGroup = true
		children.Page.SelectionBehaviorUp = Enum.SelectionBehavior.Stop
		children.Page.SelectionBehaviorDown = Enum.SelectionBehavior.Stop
		children.Page.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop
		children.Page.SelectionBehaviorRight = Enum.SelectionBehavior.Stop

		local page = children.Page
		children.MenuContainerPadding = Create("UIPadding")({ Parent = page })

		if not v then
			local _ = GuiService:GetGuiInset().Y

			children.MenuContainerPadding.PaddingTop = UDim.new(0, 0)
		end

		local hubPadding = Theme.HubPadding()
		children.MenuContainer.AutoButtonColor = false
		children.MenuContainerPadding.PaddingLeft = hubPadding.PaddingLeft
		children.MenuContainerPadding.PaddingRight = hubPadding.PaddingRight
		children.MenuContainerPadding.PaddingBottom = hubPadding.PaddingBottom
		children.MenuContainerPadding.PaddingTop = hubPadding.PaddingTop

		Create("UICorner")({
			CornerRadius = Theme.MenuContainerCornerRadius,
			Parent = children.MenuContainer
		})

		getCamMicPermissions(function(p)
			children.hasMicPermissions = p.hasMicPermissions
			children.isFetchingMicPermissions = false
		end, nil, true)

		children.SettingsShowSignal:connect(function(p)
			if p then
				if default:IsSeamlessVoice() and not default.voiceUIVisible then
					if v3.FFlagVoiceRewarmTelemetry then
						local connectDisconnectButtonAnalyticsData, v21, v22, v23 = default:GetConnectDisconnectButtonAnalyticsData(true)
						default.Analytics:reportJoinVoiceButtonEventWithVoiceSessionId(
							"shown",
							connectDisconnectButtonAnalyticsData,
							v21,
							v22,
							v23,
							default.joinVoiceButtonContext
						)
					else
						default.Analytics:reportJoinVoiceButtonEventWithVoiceSessionId(
							"shown",
							default:GetConnectDisconnectButtonAnalyticsData(true)
						)
					end
				elseif default:IsSeamlessVoice() and default.voiceUIVisible then
					default.Analytics:reportLeaveVoiceButtonEvent(
						"shown",
						default:GetConnectDisconnectButtonAnalyticsData(true)
					)
				end

				if
					default:UserVoiceEnabled() and children.isFetchingMicPermissions
					or not default:UserOnlyEligibleForVoice()
					and (not default:UserVoiceEnabled() or children.hasMicPermissions)
				then
					return
				end
			end
		end)

		children.MenuListLayout = Create("UIListLayout")({
			Name = "MenuListLayout",
			FillDirection = Enum.FillDirection.Vertical,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = page
		})

		children.HubBar = Create("ImageLabel")({
			Name = "HubBar",
			BackgroundColor3 = Theme.color("HubBarContainer"),
			BackgroundTransparency = Theme.transparency("HubBarContainerTransparency"),
			ZIndex = children.Shield.ZIndex + 1,
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0.5, 0),
			LayoutOrder = 0,
			Parent = page
		})

		if not isSideSheetEnabled then
			Create("Frame")({
				BackgroundColor3 = Theme.color("Divider"),
				BackgroundTransparency = Theme.transparency("Divider"),
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 1),
				Position = UDim2.new(0, 0, 1, 0),
				AnchorPoint = Vector2.new(0, 1),
				Parent = children.HubBar
			})
		end

		if isSideSheetEnabled then
			children.PageTitleHeader = Create("Frame")({
				Name = "PageTitleHeader",
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				LayoutOrder = 0,
				Parent = children.HubBar,
				ZIndex = children.Shield.ZIndex + 1
			})

			Create("UIPadding")({
				PaddingLeft = UDim.new(0, 12),
				PaddingRight = UDim.new(0, 12),
				Parent = children.PageTitleHeader
			})

			children.PageTitleLabel = Create("TextLabel")({
				Name = "Title",
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -36, 0, 0),
				Position = UDim2.new(0, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				AutomaticSize = Enum.AutomaticSize.Y,
				Text = "",
				TextXAlignment = Enum.TextXAlignment.Left,
				TextColor3 = Color3.new(1, 1, 1),
				Font = Theme.font(Enum.Font.SourceSansBold, "Confirmation"),
				FontSize = Theme.fontSize(Enum.FontSize.Size36, "Confirmation"),
				Parent = children.PageTitleHeader
			})
		end

		children.HubBarListLayout = Create("UIListLayout")({
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = children.HubBar
		})

		if not v3.FFlagAddTraversalBackButton then
			if v3.EngineFeatureTeleportHistoryButtons then
				children.BackBarRef = Roact.createRef()
				children.FrontBarRef = Roact.createRef()
				children.BackBar = Roact.createElement(RoactAppExperiment.Provider, {
					value = IXPService
				}, {
					AppStyleProvider = Roact.createElement(AppStyleProvider, {
						style = { themeName = Dark }
					}, {
						ButtonsFrame = Roact.createElement(
							"Frame",
							{
								BackgroundTransparency = 1,
								LayoutOrder = -1,
								AutomaticSize = Enum.AutomaticSize.Y,
								Size = UDim2.new(1, 0, 0, 0)
							},
							{
								BackButton = Roact.createElement(MenuBackButton, {
									BackBarRef = children.BackBarRef,
									HubBar = children.HubBar,
									LayoutOrder = 1
								}),
								FrontButton = Roact.createElement(MenuFrontButton, {
									FrontBarRef = children.FrontBarRef,
									HubBar = children.HubBar,
									LayoutOrder = 2
								})
							}
						)
					})
				})
			else
				children.BackBarRef = Roact.createRef()
				children.BackBar = Roact.createElement(RoactAppExperiment.Provider, {
					value = IXPService
				}, {
					AppStyleProvider = Roact.createElement(AppStyleProvider, {
						style = { themeName = Dark }
					}, {
						BackButton = Roact.createElement(MenuBackButton, {
							BackBarRef = children.BackBarRef,
							HubBar = children.HubBar
						})
					})
				})
			end

			Roact.mount(children.BackBar, page, "BackBar")
		end

		if Utility:IsSmallTouchScreen() then
			children.HubBar.Size = UDim2.new(0, RobloxGui.AbsoluteSize.X - 100, 0, 50)
			children.HubBar.Position = UDim2.new(0.5, 0, 0, 6)
		else
			if v then
				children.HubBar.Size = UDim2.new(0, 1200, 0, 100)
			else
				children.HubBar.Size = UDim2.new(0, 800, 0, 60)
			end

			children.HubBar.Position = UDim2.new(0.5, 0, 0.1, 0)
		end

		local create = Create("Frame")
		local size

		if v3.ChromeEnabled then
			size = UDim2.new(1, 0, 0, 100)
		else
			size = UDim2.fromOffset(0, 100)
		end

		children.VoiceRecordingIndicatorFrame = create({
			Size = size,
			Position = UDim2.new(0, 0, 0, 0),
			Parent = children.HubBar,
			BackgroundTransparency = 1
		})

		children.VoiceRecordingText = Create("TextLabel")({
			Parent = children.VoiceRecordingIndicatorFrame,
			Text = "",
			Visible = false,
			Position = UDim2.new(0, 60, 0, 0),
			TextSize = 12,
			Font = AppFonts.default:getMedium(),
			Size = UDim2.fromScale(1, 1),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1
		})

		if Utility:IsSmallTouchScreen() then
			children.VoiceRecordingText.Size = UDim2.fromScale(1, 1)
			children.VoiceRecordingText.AnchorPoint = Vector2.new(0, 0)

			if v3.ChromeEnabled then
				children.VoiceRecordingText.TextXAlignment = Enum.TextXAlignment.Right
				children.VoiceRecordingText.Position = UDim2.new(0, 0, 0, -60)
			else
				children.VoiceRecordingText.Position = UDim2.new(0, 60, 0, -60)
			end
		elseif v then
			children.VoiceRecordingText.AnchorPoint = Vector2.new(0, 1)

			if v3.ChromeEnabled then
				children.VoiceRecordingText.TextXAlignment = Enum.TextXAlignment.Right
				children.VoiceRecordingText.Size = UDim2.new(1, 0, 0, 100)
				children.VoiceRecordingText.Position = UDim2.new(0, 0, 0.1, 0)
			else
				children.VoiceRecordingText.Size = UDim2.new(0, 1200, 0, 100)
				children.VoiceRecordingText.Position = UDim2.new(0.5, 0, 0.1, 0)
			end
		else
			children.VoiceRecordingText.AnchorPoint = Vector2.new(0, 1)

			if v3.ChromeEnabled then
				children.VoiceRecordingText.TextXAlignment = Enum.TextXAlignment.Right
				children.VoiceRecordingText.Size = UDim2.new(1, 0, 0, 60)
				children.VoiceRecordingText.Position = UDim2.new(0, 0, 0.1, 0)
			else
				children.VoiceRecordingText.Size = UDim2.new(0, 800, 0, 60)
				children.VoiceRecordingText.Position = UDim2.new(0.5, 0, 0.1, 0)
			end
		end

		children.voiceRecordingIndicatorTextMotor = Otter.createSingleMotor(0)
		children.voiceRecordingIndicatorTextMotor:onStep(function(textTransparency)
			children.VoiceRecordingText.TextTransparency = textTransparency
		end)

		spawn(function()
			RunService:BindToRenderStep("VoiceRecordingIndicator", 1, function()
				if
					children.isMuted ~= nil
					and children.lastVoiceRecordingIndicatorTextUpdated ~= nil
					and tick() - children.lastVoiceRecordingIndicatorTextUpdated >= 5
					and children.isMuted
				then
					children.voiceRecordingIndicatorTextMotor:setGoal(Otter.spring(1, v8))
					children.voiceRecordingIndicatorTextMotor:start()
				end
			end)
		end)

		children.PageViewClipper = Create("Frame")({
			Name = "PageViewClipper",
			BackgroundTransparency = 1,
			Size = UDim2.new(
				children.HubBar.Size.X.Scale,
				children.HubBar.Size.X.Offset,
				1,
				-children.HubBar.Size.Y.Offset - children.HubBar.Position.Y.Offset - v18
			),
			Position = UDim2.new(
				children.HubBar.Position.X.Scale,
				children.HubBar.Position.X.Offset,
				children.HubBar.Position.Y.Scale,
				children.HubBar.Position.Y.Offset + children.HubBar.Size.Y.Offset + 1
			),
			AnchorPoint = Vector2.new(0.5, 0),
			ClipsDescendants = true,
			LayoutOrder = 1,
			Parent = page,
			SelectionGroup = true,
			SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
			SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
			SelectionBehaviorDown = Enum.SelectionBehavior.Escape,
			SelectionBehaviorUp = Enum.SelectionBehavior.Escape
		})

		if v3.FFlagEnableConsoleExpControls and v3.ChromeEnabled then
			children.PageViewPadding = Create("UIPadding")({ Parent = children.PageViewClipper })

			local Service = require(RobloxGui.Modules.Chrome.Service)
			Service:onShortcutBarChanged():connect(function()
				if Utility:IsSmallTouchScreen() and Service:getCurrentShortcutBar():get() ~= nil then
					children.PageViewPadding.PaddingBottom = UDim.new(0, Theme.ExtraPageBottomPaddingMobile)
				else
					children.PageViewPadding.PaddingBottom = UDim.new(0, 0)
				end
			end)
		end

		children.PageView = Create("ScrollingFrame")({
			Name = "PageView",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 2),
			Size = UDim2.new(1, 0, 1, -20),
			CanvasSize = UDim2.new(1, 0, 1, 0),
			ZIndex = children.Shield.ZIndex,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Selectable = false,
			ScrollBarThickness = Theme.DefaultScrollBarThickness,
			Parent = children.PageViewClipper
		})

		children.PageView.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar

		children.PageViewInnerFrame = Create("Frame")({
			Name = "PageViewInnerFrame",
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 1, 0),
			ZIndex = children.Shield.ZIndex,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Selectable = false,
			Parent = children.PageView,
			LayoutOrder = 1
		})

		Create("UIPadding")({ PaddingTop = UDim.new(0, 5), Parent = children.PageViewInnerFrame })

		children.InnerCanvasGroupShow = Create("CanvasGroup")({
			Name = "InnerCanvasGroupShow",
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			GroupTransparency = 0,
			Visible = false,
			Parent = children.PageViewInnerFrame
		})

		children.InnerCanvasGroupHide = Create("CanvasGroup")({
			Name = "InnerCanvasGroupHide",
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			GroupTransparency = 0,
			Visible = false,
			Parent = children.PageViewInnerFrame
		})

		if UserInputService.MouseEnabled then
			children.PageViewClipper.Size = UDim2.new(
				children.HubBar.Size.X.Scale,
				children.HubBar.Size.X.Offset,
				0.5,
				-(children.HubBar.Position.Y.Offset - children.HubBar.Size.Y.Offset)
			)
		end

		children.BottomButtonFrame = Create("Frame")({
			Name = "BottomButtonFrame",
			Size = children.HubBar.Size,
			Position = UDim2.new(
				0.5,
				-children.HubBar.Size.X.Offset / 2,
				1 - children.HubBar.Position.Y.Scale - children.HubBar.Size.Y.Scale,
				-children.HubBar.Position.Y.Offset - children.HubBar.Size.Y.Offset
			),
			ZIndex = children.Shield.ZIndex + 1,
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Parent = page,
			Selectable = false,
			SelectionGroup = true,
			SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
			SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
			SelectionBehaviorDown = Enum.SelectionBehavior.Stop
		})

		children.BottomButtonFrame:GetPropertyChangedSignal("Visible"):Connect(function()
			children.setShowBottomBarSignal(children.BottomButtonFrame.Visible)
		end)

		local function fn3(source)
			if v3.FFlagAddUILessMode then
				setVisibilityInternal(false, nil, nil, nil, source)
			else
				setVisibilityInternal(false)
			end

			if
				v3.FFlagAddUILessMode
				and v3.FIntAddUILessModeVariant ~= 0
				and children.uiLessStore.getUILessModeEnabled(false)
			then
				children.uiLessStore.setUIVisible(false)
			end

			RbxAnalyticsService:SetRBXEventStream(
				Constants.AnalyticsTargetName,
				Constants.AnalyticsResumeGameName,
				Constants.AnalyticsMenuActionName,
				{
					source = source,
					playsessionid = children.playSessionId,
					universeid = tostring(game.GameId)
				}
			)

			GuiService.SelectedCoreObject = nil
		end

		if isSideSheetEnabled then
			children.PageTitleCloseButton = Utility:MakeStyledImageButton(
				"PageTitleClose",
				"rbxasset://textures/ui/InspectMenu/x.png",
				UDim2.new(0, 40, 0, 40),
				UDim2.new(0, 16, 0, 16),
				function()
					fn3(Constants.AnalyticsResumeXButtonSource)
				end,
				nil,
				children,
				"DefaultButton"
			)

			children.PageTitleCloseButton.AnchorPoint = Vector2.new(1, 0.5)
			children.PageTitleCloseButton.Position = UDim2.new(1, 0, 0.5, 0)

			local border = children.PageTitleCloseButton:FindFirstChild("Border")

			if border then
				border.Parent = nil
			end

			children.PageTitleCloseButton.Parent = children.PageTitleHeader
		end

		if
			not v3.FFlagMenuButtonsMountWithIEM
			and v3.FFlagRelocateMobileMenuButtons
			and (v3.FIntRelocateMobileMenuButtonsVariant == 1 or v3.FIntRelocateMobileMenuButtonsVariant == 3 or v3.FIntRelocateMobileMenuButtonsVariant == 2 and not Utility:IsSmallTouchScreen())
		then
			fn()
		end

		if
			not v3.FFlagRelocateMobileMenuButtons
			or v3.FIntRelocateMobileMenuButtonsVariant == 0
			or v3.FIntRelocateMobileMenuButtonsVariant == 2 and Utility:IsSmallTouchScreen()
		then
			children.BottomButtonFrame.Size = UDim2.new(1, 0, 0, 80)
		end

		children.MenuListLayout = Create("UIListLayout")({
			Padding = UDim.new(0, 12),
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = children.BottomButtonFrame
		})

		if v3.FFlagEnableSystemScrimInSettingsHub then
			local SystemScrim = require(CorePackages.Workspace.Packages.SystemScrim)
			local systemScrimSignalStore = SystemScrim.SystemScrimSignalStore(false)
			systemScrimSignalStore.backgroundScrimActivated.Event:Connect(function()
				if v3.FFlagRelocateMobileMenuButtons and v3.FIntRelocateMobileMenuButtonsVariant ~= 0 then
					children:GetExperienceControlStore().onResume(Constants.AnalyticsResumeShieldSource)
				else
					fn3(Constants.AnalyticsResumeShieldSource)
				end
			end)

			children.Shield:GetPropertyChangedSignal("Visible"):Connect(function()
				systemScrimSignalStore.setTransparency(1)
				systemScrimSignalStore.setAutoDismiss(true)
				systemScrimSignalStore.setVisibility(children.Shield.Visible)
			end)
		end

		children.Shield.Activated:Connect(function()
			if v3.FFlagRelocateMobileMenuButtons and v3.FIntRelocateMobileMenuButtonsVariant ~= 0 then
				children:GetExperienceControlStore().onResume(Constants.AnalyticsResumeShieldSource)
			else
				fn3(Constants.AnalyticsResumeShieldSource)
			end
		end)

		if v3.FFlagSettingsHubIndependentBackgroundVisibility then
			children.DarkenBackground.Activated:Connect(function()
				if v3.FFlagRelocateMobileMenuButtons and v3.FIntRelocateMobileMenuButtonsVariant ~= 0 then
					children:GetExperienceControlStore().onResume(Constants.AnalyticsResumeShieldSource)
				else
					fn3(Constants.AnalyticsResumeShieldSource)
				end

				InExperienceAppChatModal.default:setVisible(false)
			end)
		end

		if not v3.FFlagRelocateMobileMenuButtons or v3.FIntRelocateMobileMenuButtonsVariant == 0 then
			local function fn4()
				if v3.FFlagPreventHiddenSwitchPage and children:GetVisibility() == false then
					return
				end

				children:AddToMenuStack(children.Pages.CurrentPage)
				children.HubBar.Visible = false
				removeBottomBarBindings()

				if
					v3.GetFFlagEnableLeaveGameUpsellEntrypoint()
					and children.leaveGameUpsellProp ~= Constants2.PHONE_UPSELL_VALUE_PROP.None
				then
					children:SwitchToPage(children.LeaveGameUpsellPage, nil, 1, true)
				else
					children:SwitchToPage(children.LeaveGamePage, nil, 1, true)
				end
			end

			if inExperienceCapabilities.canNavigateHome then
				local udim3 = UDim2.new(0.5, v and -160 or -130, 0.5, -25)
				local l = Enum.KeyCode.L
				local v21

				if not (v3.FFlagEnableConsoleExpControls and v3.ChromeEnabled) then
					v21 = Enum.KeyCode.ButtonX
				end

				addBottomBarButtonOld(
					"LeaveGame",
					"Leave",
					v12,
					"rbxasset://textures/ui/Settings/Help/LeaveIcon.png",
					udim3,
					fn4,
					{ l, v21 },
					fn4
				)
			end

			local function fn5()
				if v15 then
					children:AddToMenuStack(children.Pages.CurrentPage)
					children.HubBar.Visible = false
					removeBottomBarBindings()
					children:SwitchToPage(children.ResetCharacterPage, nil, 1, true)
				end
			end

			local formatted = v9:Format(Constants.RespawnLocalizedKey)

			local udim3 = UDim2.new(0.5, v and -550 or -400, 0.5, -25)
			local r = Enum.KeyCode.R
			local v21

			if not (v3.FFlagEnableConsoleExpControls and v3.ChromeEnabled) then
				v21 = Enum.KeyCode.ButtonY
			end

			addBottomBarButtonOld(
				"ResetCharacter",
				formatted,
				v13,
				"rbxasset://textures/ui/Settings/Help/ResetIcon.png",
				udim3,
				fn5,
				{ r, v21 },
				fn5
			)

			local function fn6()
				fn3(Constants.AnalyticsResumeButtonSource)
			end
			local function fn7()
				fn3(Constants.AnalyticsResumeGamepadSource)
			end

			local v22

			if v3.FFlagEnableConsoleExpControls then
				v22 = imageForKeyCode
			else
				v22 = v11
			end

			addBottomBarButtonOld(
				"Resume",
				"Resume",
				v22,
				"rbxasset://textures/ui/Settings/Help/EscapeIcon.png",
				UDim2.new(0.5, v and 200 or 140, 0.5, -25),
				fn6,
				v3.FFlagEnableConsoleExpControls and v3.ChromeEnabled and {} or {
					Enum.KeyCode.ButtonB,
					Enum.KeyCode.ButtonStart
				},
				fn7
			)
		end

		if v3.FFlagAddSwitchTabHintsToIEM then
			local function MountSwitchTabHint(props)
				local v21 = Create("Frame")({
					Name = "SwitchTabHintContainer",
					Size = UDim2.fromScale(0, 1),
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.X,
					LayoutOrder = props.layoutOrder,
					Parent = props.parent
				})

				ReactRoblox.createRoot(v21):render(React.createElement(
					React.Fragment,
					nil,
					React.createElement("UIListLayout", {
						Name = "SwitchTabHintCenterAlign",
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center
					}),
					React.createElement(
						FoundationProvider,
						{
							colorMode = Foundation.Enums.ColorMode.Dark,
							device = Utils.getDeviceType()
						},
						{
							["SwitchTabHint" .. props.keycode.Name] = React.createElement(SwitchTabHint, {
								keycode = props.keycode
							})
						}
					)
				))
			end

			children.TabHeaderContainer = Create("Frame")({
				Name = "TabHeaderContainer",
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				Parent = children.HubBar,
				Visible = not isSideSheetEnabled
			})

			children.TabHeaderContainerListLayout = Create("UIListLayout")({
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalFlex = Enum.UIFlexAlignment.Fill,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Parent = children.TabHeaderContainer
			})

			MountSwitchTabHint({
				keycode = Enum.KeyCode.ButtonL1,
				parent = children.TabHeaderContainer,
				layoutOrder = -999
			})

			MountSwitchTabHint({
				keycode = Enum.KeyCode.ButtonR1,
				parent = children.TabHeaderContainer,
				layoutOrder = 999
			})
		end

		local create2 = Create("ImageLabel")
		local hubBarContainer = {
			Name = "HubBarContainer",
			ZIndex = children.Shield.ZIndex + 2,
			BorderSizePixel = 0,
			BackgroundColor3 = Theme.color("HubBarContainer"),
			BackgroundTransparency = Theme.transparency("HubBarContainerTransparency"),
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			Parent = 0,
			Selectable = 0,
			SelectionGroup = 0,
			SelectionBehaviorUp = 0,
			SelectionBehaviorLeft = 0,
			SelectionBehaviorRight = 0
		}
		local parent

		if v3.FFlagAddSwitchTabHintsToIEM then
			parent = children.TabHeaderContainer
		else
			parent = children.HubBar
		end

		hubBarContainer.Parent = parent
		hubBarContainer.Selectable = not v3.FFlagIEMTabFocusNav and nil
		hubBarContainer.SelectionGroup = v3.FFlagIEMTabFocusNav and true or nil
		local selectionBehaviorUp

		if v3.FFlagIEMTabFocusNav then
			selectionBehaviorUp = Enum.SelectionBehavior.Stop
		end

		hubBarContainer.SelectionBehaviorUp = selectionBehaviorUp
		local selectionBehaviorLeft

		if v3.FFlagIEMTabFocusNav then
			selectionBehaviorLeft = Enum.SelectionBehavior.Stop
		end

		hubBarContainer.SelectionBehaviorLeft = selectionBehaviorLeft
		local selectionBehaviorRight

		if v3.FFlagIEMTabFocusNav then
			selectionBehaviorRight = Enum.SelectionBehavior.Stop
		end

		hubBarContainer.SelectionBehaviorRight = selectionBehaviorRight
		children.HubBarContainer = create2(hubBarContainer)

		children.HubBar.ImageTransparency = 1
		children.HubBarListLayout.Parent = children.HubBarContainer

		if isSubjectToDesktopPolicies() then
			children.FullScreenTitleBar = SettingsFullScreenTitleBar.mount({}, children.Shield, "FullScreenTitleBar")
		end

		local function cameraViewportChanged() -- 1 equivalent call inferred from this helper
			Theme.viewportResized()
			Utility:FireOnResized()
		end

		local viewportSizeChangedConnection = nil
		local function onWorkspaceChanged(p) -- 1 equivalent call inferred from this helper
			if p == "CurrentCamera" then
				cameraViewportChanged() -- inferred equivalent call

				if viewportSizeChangedConnection then
					viewportSizeChangedConnection:disconnect()
				end

				viewportSizeChangedConnection = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(cameraViewportChanged)
			end
		end

		onWorkspaceChanged("CurrentCamera") -- inferred equivalent call
		workspace.Changed:Connect(onWorkspaceChanged)
	end

	local function resizeBottomBarButtons()
		local v18 = children.BottomButtonFrame.AbsoluteSize.X

		local count = #children.BottomBarButtons

		if count == 4 then
			v18 = v18 - 48 - 12
			count = 4 - 1
		end

		local v19 = (v18 - (count - 1) * 12 - 12) / count

		if v3.isInExperienceUIVREnabled then
			v19 = children.SettingsUIDelegate:getBottomButtonSize(v19)
		end

		for i = 1, #children.BottomBarButtons do
			local bottomBarButton = children.BottomBarButtons[i]
			local v20 = bottomBarButton[1]

			if v20 ~= "MuteButtonButton" then
				children[v20].Size = UDim2.fromOffset(v19, children[bottomBarButton[1]].Size.Y.Offset)
			end
		end
	end

	local function isSideSheetPairedWithPeoplePage() -- 6 equivalent calls inferred from this helper
		return FFlagSideSheetOpenPeoplePage and getDidSideSheetOpenWithPeoplePage()
	end

	local function shouldAndroidBackUseSideSheet() -- 1 equivalent call inferred from this helper
		return FFlagSideSheetOpenPeoplePage and (getSideSheetVisibility() or getHasRoomForPeoplePage())
	end

	local function shouldUseSideSheetPeoplePageLayout() -- 8 equivalent calls inferred from this helper
		return isSideSheetPairedWithPeoplePage() and getSideSheetVisibility() and getIsPeoplePageOpen() -- inferred equivalent call
	end

	local function shouldShowSettingsHubModal() -- 2 equivalent calls inferred from this helper
		return children.Visible and not shouldUseSideSheetPeoplePageLayout() -- inferred equivalent call
	end

	local function getShieldOpenTweenTime(p: number) -- 2 equivalent calls inferred from this helper
		if isSideSheetPairedWithPeoplePage() and getSideSheetVisibility() then -- inferred equivalent call
			return getSideSheetAnimationDuration()
		end

		return p
	end

	local function shouldCloseShieldWithSideSheet(flag: boolean?) -- 3 equivalent calls inferred from this helper
		if flag == nil then
			return shouldUseSideSheetPeoplePageLayout() -- inferred equivalent call
		end

		return flag
	end

	local function getShieldCloseTweenTime(p: number, flag: boolean?) -- 1 equivalent call inferred from this helper
		flag = shouldCloseShieldWithSideSheet(flag) -- inferred equivalent call

		if flag then
			return getSideSheetAnimationDuration()
		end

		return p
	end

	local function getSideSheetMenuInset() -- 4 equivalent calls inferred from this helper
		if shouldUseSideSheetPeoplePageLayout() then -- inferred equivalent call
			return getSideSheetDrawerWidth()
		end

		return 0
	end

	local function constrainMenuWidthForSideSheet(p: number) -- 4 equivalent calls inferred from this helper
		local sideSheetMenuInset = getSideSheetMenuInset() -- inferred equivalent call

		if sideSheetMenuInset <= 0 then
			return p
		end

		local hubPadding = Theme.HubPadding()
		return (math.max(
			150,
			(math.min(
				p,
				(getSideSheetMenuPageWidth(
					RobloxGui.AbsoluteSize.X,
					sideSheetMenuInset,
					hubPadding.PaddingLeft.Offset + hubPadding.PaddingRight.Offset
				))
			))
		))
	end

	local function getSideSheetMenuReservedHeight(p: number, p2: number) -- 1 equivalent call inferred from this helper
		local hubPadding = Theme.HubPadding()
		return p + hubPadding.PaddingTop.Offset + hubPadding.PaddingBottom.Offset + p2
	end

	local function applySideSheetLayoutToMenuContainer(udim3: UDim2, vector2: Vector2)
		local sideSheetMenuInset = getSideSheetMenuInset() -- inferred equivalent call

		if sideSheetMenuInset <= 0 then
			return udim3, vector2
		end

		local halfSideSheetMenuInset = sideSheetMenuInset / 2

		return UDim2.new(udim3.X.Scale, udim3.X.Offset + halfSideSheetMenuInset, 0.5, 0), Vector2.new(vector2.X, 0.5)
	end

	local function onScreenSizeChanged()
		if
			FFlagClosePeoplePageWhenNoRoomBesideSideSheet
			and shouldUseSideSheetPeoplePageLayout() -- inferred equivalent call
			and closePeoplePageWhenNoRoomBesideSideSheet(RobloxGui.AbsoluteSize.X)
		then
			return
		end

		local function getBackBarVisible() -- 2 equivalent calls inferred from this helper
			if children.BackBarRef:getValue() then
				return children.BackBarRef:getValue().Visible
			end

			return false
		end

		local function getFrontBarVisible() -- 2 equivalent calls inferred from this helper
			if children.FrontBarRef:getValue() then
				return children.FrontBarRef:getValue().Visible
			end

			return false
		end

		if v3.FFlagRelocateMobileMenuButtons and v3.FIntRelocateMobileMenuButtonsVariant == 2 and children.Visible then
			if (Utility:IsPortrait() or Utility:IsSmallTouchScreen()) and not Theme.AlwaysShowBottomBar() then
				if children.BottomButtonFrameRoot then
					fn2()
				end

				if children.PlayersPage then
					children.PlayersPage:CreateMenuButtonsContainer()
				end
			else
				if not children.BottomButtonFrameRoot then
					fn()
				end

				if children.PlayersPage then
					children.PlayersPage:UnmountMenuButtonsContainer()
				end
			end
		end

		local menuContainerPosition = Theme.MenuContainerPosition(children.SettingsUIDelegate)
		local v18 = 600
		local v19

		if v3.isInExperienceUIVREnabled then
			v19 = children.SettingsUIDelegate:getFullScreenSize()
		else
			v19 = RobloxGui.AbsoluteSize.y
		end

		local v20 = 0.050000000000000044 * v19
		local isPortrait = Utility:IsPortrait()

		if v then
			v20 = 0.07 * v19
			v18 = 800
		elseif Utility:IsSmallTouchScreen() then
			v20 = math.min(10, 0.010000000000000009 * v19)
		elseif v3.isInExperienceUIVREnabled and VRService.VREnabled then
			v20 = 0
		end

		local position = menuContainerPosition.Position
		local anchorPoint = menuContainerPosition.AnchorPoint
		local sideSheetMenuInset = getSideSheetMenuInset() -- inferred equivalent call

		if not (sideSheetMenuInset <= 0) then
			local halfSideSheetMenuInset = sideSheetMenuInset / 2

			position = UDim2.new(position.X.Scale, position.X.Offset + halfSideSheetMenuInset, 0.5, 0)
			anchorPoint = Vector2.new(anchorPoint.X, 0.5)
		end

		children.MenuContainer.Size = menuContainerPosition.Size
		children.MenuContainer.Position = position
		children.MenuContainer.AnchorPoint = anchorPoint

		local offset = children.HubBar.Size.Y.Offset
		local _ = v20 * 2 + offset * 2

		local v21 = 0

		if not v3.FFlagAddTraversalBackButton then
			if getBackBarVisible() and children.BackBarRef:getValue() then -- inferred equivalent call
				v21 = children.BackBarRef:getValue().Size.Y.Offset
			end

			if v3.EngineFeatureTeleportHistoryButtons and getFrontBarVisible() and children.FrontBarRef:getValue() then -- inferred equivalent call
				v21 += children.FrontBarRef:getValue().Size.Y.Offset
			end
		end

		if isPortrait then
			children.HubBar.Position = UDim2.new(0.5, 0, 0, 10)
			local hubBar = children.HubBar
			hubBar.Size = UDim2.new(0, constrainMenuWidthForSideSheet(RobloxGui.AbsoluteSize.X - 40), 0, 54) -- inferred equivalent call
		elseif v then
			children.HubBar.Size = UDim2.new(0, 1200, 0, 100)
		elseif Utility:IsSmallTouchScreen() then
			local hubBar = children.HubBar
			hubBar.Size = UDim2.new(0, constrainMenuWidthForSideSheet(RobloxGui.AbsoluteSize.X - 60), 0, 52) -- inferred equivalent call
		elseif v3.isInExperienceUIVREnabled then
			local hubBar = children.HubBar
			hubBar.Size = UDim2.new(
				0,
				constrainMenuWidthForSideSheet(children.SettingsUIDelegate:getHubBarSize()), -- inferred equivalent call
				0,
				60
			)
		else
			local hubBar = children.HubBar
			hubBar.Size = UDim2.new(0, constrainMenuWidthForSideSheet(800), 0, 60) -- inferred equivalent call
		end

		local v22

		if isSideSheetEnabled or not Theme.AlwaysShowBottomBar() then
			v22 = children.HubBar.Size.Y.Offset
		else
			v22 = children.HubBar.Size.Y.Offset + children.BottomButtonFrame.Size.Y.Offset
		end

		local v23 = v20 * 2
		local v24

		if v3.FFlagFixDisableTopPaddingError and children.Pages.CurrentPage == nil then
			v24 = v22
		else
			v24 = children.Pages.CurrentPage.DisableTopPadding and 0 or v22
		end

		local v25 = v23 + v24

		if not v3.FFlagAddTraversalBackButton then
			v21 = not (getBackBarVisible() and children.BackBarRef:getValue()) and 0 -- inferred equivalent call
				or children.BackBarRef:getValue().Size.Y.Offset

			if v3.EngineFeatureTeleportHistoryButtons and getFrontBarVisible() and children.FrontBarRef:getValue() then -- inferred equivalent call
				v21 += children.FrontBarRef:getValue().Size.Y.Offset
			end
		end

		RunService.Heartbeat:wait()

		if shouldShowBottomBar() then
			setBottomBarBindings()
			setBottomBarSelection(children.Pages.CurrentPage)
		else
			removeBottomBarBindings()
		end

		if v3.isInExperienceUIVREnabled then
			v25 += children.SettingsUIDelegate:getMenuContainerExtraSpace()
		end

		local v26 = v19 - v25 - v21

		if
			v3.FFlagRelocateMobileMenuButtons
			and (v3.FIntRelocateMobileMenuButtonsVariant == 1 or v3.FIntRelocateMobileMenuButtonsVariant == 3)
			and Utility:IsSmallTouchScreen()
		then
			v26 -= Theme.ExtraHubBottomPaddingMobile
		end

		if shouldUseSideSheetPeoplePageLayout() then -- inferred equivalent call
			v26 = getSideSheetMenuPageHeight(children.Shield.AbsoluteSize.Y, getSideSheetMenuReservedHeight(v22, v21)) -- inferred equivalent call
		end

		if FFlagSideSheetOpenPeoplePage then
			local pageView = children.PageView
			local verticalScrollBarInset

			if shouldUseSideSheetPeoplePageLayout() then -- inferred equivalent call
				verticalScrollBarInset = Enum.ScrollBarInset.Always
			else
				verticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
			end

			pageView.VerticalScrollBarInset = verticalScrollBarInset
		end

		if isPortrait then
			v18 = v26
		elseif v18 < v26 then
			children.HubBar.Position = UDim2.new(
				children.HubBar.Position.X.Scale,
				children.HubBar.Position.X.Offset,
				0.5,
				-v18 / 2 - children.HubBar.Size.Y.Offset
			)

			if children.BottomButtonFrame then
				children.BottomButtonFrame.Position = UDim2.new(
					children.BottomButtonFrame.Position.X.Scale,
					children.BottomButtonFrame.Position.X.Offset,
					0.5,
					v18 / 2
				)
			end
		elseif v26 < 150 then
			v18 = 150
			children.HubBar.Position = UDim2.new(
				children.HubBar.Position.X.Scale,
				children.HubBar.Position.X.Offset,
				0.5,
				-75 - children.HubBar.Size.Y.Offset
			)

			if children.BottomButtonFrame then
				children.BottomButtonFrame.Position = UDim2.new(
					children.BottomButtonFrame.Position.X.Scale,
					children.BottomButtonFrame.Position.X.Offset,
					0.5,
					75
				)
			end
		else
			children.HubBar.Position = UDim2.new(
				children.HubBar.Position.X.Scale,
				children.HubBar.Position.X.Offset,
				0,
				v20
			)

			if children.BottomButtonFrame then
				children.BottomButtonFrame.Position = UDim2.new(
					children.BottomButtonFrame.Position.X.Scale,
					children.BottomButtonFrame.Position.X.Offset,
					1,
					-(v20 + v22)
				)
			end

			v18 = v26
		end

		local udim3

		if v then
			udim3 = UDim2.new(0, children.HubBar.AbsoluteSize.X, 0, v18)
		elseif Utility:IsSmallTouchScreen() then
			if
				v3.FFlagRelocateMobileMenuButtons
				and (v3.FIntRelocateMobileMenuButtonsVariant == 1 or v3.FIntRelocateMobileMenuButtonsVariant == 3)
			then
				udim3 = UDim2.new(
					0,
					children.HubBar.AbsoluteSize.X,
					0,
					v18 + 0 + 0 - children.BottomButtonFrame.Size.Y.Offset
				)
			else
				udim3 = UDim2.new(0, children.HubBar.AbsoluteSize.X, 0, v18 + 0 + 0)
			end
		else
			udim3 = UDim2.new(0, children.HubBar.AbsoluteSize.X, 0, v18)
		end

		if
			v3.FFlagRelocateMobileMenuButtons
			and v3.FIntRelocateMobileMenuButtonsVariant ~= 0
			and children.BottomButtonFrame
		then
			children.BottomButtonFrame.Size = UDim2.new(
				0,
				children.HubBar.Size.X.Offset,
				0,
				children.HubBar.Size.Y.Offset
			)
		end

		local hubPadding = Theme.HubPadding()
		local v27 = hubPadding.PaddingLeft.Offset + hubPadding.PaddingRight.Offset
		local v28 = hubPadding.PaddingTop.Offset + hubPadding.PaddingBottom.Offset
		children.ReactPage.Size = UDim2.new(0, children.HubBar.AbsoluteSize.X + v27, 0, v18 + v22 + v28)

		children.PageViewClipper.Size = udim3

		if isPortrait then
			children.PageViewClipper.Position = UDim2.new(
				0.5,
				0,
				0,
				children.HubBar.Position.Y.Offset + children.HubBar.AbsoluteSize.Y
			)
		else
			children.PageViewClipper.Position = UDim2.new(
				children.PageViewClipper.Position.X.Scale,
				children.PageViewClipper.Position.X.Offset,
				0.5,
				-v18 / 2
			)
		end
	end

	if FFlagSideSheetOpenPeoplePage then
		local function scheduleSideSheetPeoplePageLayoutRefresh()
			if isSideSheetPairedWithPeoplePage() and not getSideSheetVisibility() and getIsPeoplePageOpen() then -- inferred equivalent call
				return
			end

			local selectionBehaviorLeft

			if shouldUseSideSheetPeoplePageLayout() then -- inferred equivalent call
				selectionBehaviorLeft = Enum.SelectionBehavior.Escape
			else
				selectionBehaviorLeft = Enum.SelectionBehavior.Stop
			end

			if children.Modal then
				local modal = children.Modal
				modal.Visible = shouldShowSettingsHubModal() -- inferred equivalent call
			end

			if children.Page then
				children.Page.SelectionBehaviorLeft = selectionBehaviorLeft
			end

			if children.PageViewClipper then
				children.PageViewClipper.SelectionBehaviorLeft = selectionBehaviorLeft
			end

			if children._sideSheetLayoutRefreshScheduled then
				return
			end

			children._sideSheetLayoutRefreshScheduled = true
			task.defer(function()
				children._sideSheetLayoutRefreshScheduled = false

				if children.Visible and children.MenuContainer then
					onScreenSizeChanged()
				end
			end)
		end

		children._sideSheetLayoutEffectDispose = Signals.createEffect(function(p)
			getSideSheetVisibility(p)
			getSideSheetDrawerWidth(p)
			getIsPeoplePageOpen(p)
			getDidSideSheetOpenWithPeoplePage(p)
			scheduleSideSheetPeoplePageLayoutRefresh()
		end)
	end

	local function onPreferredTransparencyChanged() -- 3 equivalent calls inferred from this helper
		children.MenuContainer.BackgroundTransparency = Theme.transparency("MenuContainer", 1) * GuiService.PreferredTransparency
	end

	local function toggleQuickProfilerFromHotkey(p, p2, _)
		if
			(UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl))
			and p == "Show Quick Profiler"
			and p2
			and p2 == Enum.UserInputState.Begin
		then
			gameSettings.PerformanceStatsVisible = not gameSettings.PerformanceStatsVisible
		end
	end

	local function toggleDevConsole(p, p2, _)
		if p == "Open Dev Console" and p2 and p2 == Enum.UserInputState.Begin then
			DevConsoleMaster:ToggleVisibility()
		end
	end

	local v18 = isEnabled

	local v19 = {
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

	UserInputService.InputBegan:connect(function(p)
		if p.UserInputType and v19[p.UserInputType] ~= nil then
			v18 = v19[p.UserInputType]
		elseif p.KeyCode and v19[p.KeyCode] then
			v18 = v19[p.KeyCode]
		end
	end)
	UserInputService.InputChanged:connect(function(data)
		if data.KeyCode == Enum.KeyCode.Thumbstick1 or data.KeyCode == Enum.KeyCode.Thumbstick2 then
			if data.Position.magnitude >= 0.25 then
				v18 = true
			end
		elseif
			data.UserInputType == Enum.UserInputType.Touch
			or data.UserInputType == Enum.UserInputType.MouseMovement
		then
			v18 = false
		end
	end)

	local GetHeaderPosition

	local function fn3(p, p2)
		if v3.FFlagInExperienceReportClosingBugfix and not children.HubBar.Visible then
			return
		end

		local headerPosition = GetHeaderPosition(children.Pages.CurrentPage)

		if headerPosition < 0 then
			return
		end

		local v20 = headerPosition + p

		if p2 then
			v20 = #children.TabHeaders < v20 and 1 or v20 < 1 and #children.TabHeaders or v20
		end

		local tabHeader = children.TabHeaders[v20]

		if tabHeader then
			for k, _ in pairs(children.Pages.PageTable) do
				if k:GetTabHeader() == tabHeader then
					children:SwitchToPage(k, true, p)
					return
				end
			end
		end
	end

	local function fn4(_, p, p2)
		if p ~= Enum.UserInputState.Begin then
			return
		end

		fn3(p2.KeyCode == Enum.KeyCode.ButtonR1 and 1 or p2.KeyCode == Enum.KeyCode.ButtonL1 and -1 or 0, true)
	end

	local function fn5(p)
		if p.KeyCode == Enum.KeyCode.Tab then
			fn3(
				(UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)) and -1 or 1,
				true
			)
		end
	end

	local function fn6(_, p, p2)
		if p ~= Enum.UserInputState.Begin then
			return
		end

		children:ScrollPixels(p2.KeyCode == Enum.KeyCode.PageUp and -100 or p2.KeyCode == Enum.KeyCode.PageDown and 100 or 0)
	end

	if v3.isInExperienceUIVREnabled or v3.FFlagEnableSettingsHubUIDelegateRollout then
		local SettingsUIDelegate = require(RobloxGui.Modules.Settings.SettingsUIDelegate)
		children.SettingsUIDelegate = SettingsUIDelegate.new(children)
	end

	createGui()

	if defineFastFlag then
		setupVoiceListeners()
	end

	GetHeaderPosition = function(currentPage)
		local tabHeader = currentPage:GetTabHeader()

		if not tabHeader then
			return -1
		end

		for k, tabHeader2 in pairs(children.TabHeaders) do
			if tabHeader2 == tabHeader then
				return k
			end
		end

		return -1
	end

	local function fn7(zIndex, guiObject)
		if guiObject:IsA("GuiObject") then
			guiObject.ZIndex = zIndex
			local children2 = guiObject:GetChildren()

			for i = 1, #children2 do
				fn7(zIndex, children2[i])
			end
		end
	end

	local function AddHeader(tabHeader, object)
		if not tabHeader then
			return
		end

		table.insert(children.TabHeaders, tabHeader)
		object.TabPosition = #children.TabHeaders

		local v20 = 1 / #children.TabHeaders

		for i = 1, #children.TabHeaders do
			children.TabHeaders[i].Size = UDim2.new(v20, 0, 1, 0)
		end

		fn7(3, tabHeader)
		tabHeader.Parent = children.HubBarContainer
	end

	local function RemoveHeader(tabHeader)
		local v20 = nil

		for i = 1, #children.TabHeaders do
			if children.TabHeaders[i] == tabHeader then
				table.remove(children.TabHeaders, i)
				v20 = i
				break
			end
		end

		if v20 then
			for i = v20, #children.TabHeaders do
				local tabHeader2 = children.TabHeaders[i]
				tabHeader2.Position = UDim2.new(
					tabHeader2.Position.X.Scale,
					tabHeader2.Position.X.Offset - tabHeader.AbsoluteSize.X,
					tabHeader2.Position.Y.Scale,
					tabHeader2.Position.Y.Offset
				)
			end
		end

		tabHeader.Parent = nil
	end

	function children:AddPage(object)
		children.Pages.PageTable[object] = true
		AddHeader(object:GetTabHeader(), object)
		object.Page.Position = UDim2.new(object.TabPosition - 1, 0, 0, 0)
		object.LastSelectableObjectsUpdated:connect(function()
			setBottomBarSelection(object)
		end)

		if v3.FFlagIEMTabFocusNav then
			setTabHeaderSelection(object) -- inferred equivalent call
			updateTabHeaderWrapping() -- inferred equivalent call
			object.FirstSelectableObjectsUpdated:connect(function()
				setTabHeaderSelection(object) -- inferred equivalent call
			end)
		end
	end

	function children.RemovePage(_, object)
		children.Pages.PageTable[object] = nil
		RemoveHeader(object:GetTabHeader())
		object.LastSelectableObjectsUpdated:disconnect()

		if v3.FFlagIEMTabFocusNav then
			object.FirstSelectableObjectsUpdated:disconnect()
			updateTabHeaderWrapping() -- inferred equivalent call
		end
	end

	function children.HideBar(_)
		children.HubBar.Visible = false
		children.PageViewClipper.Visible = false

		if children.BottomButtonFrame then
			removeBottomBarBindings()
		end
	end

	function children.ShowBar(_)
		children.HubBar.Visible = true
		children.PageViewClipper.Visible = true

		if children.BottomButtonFrame and shouldShowBottomBar() then
			setBottomBarBindings()
			setBottomBarSelection(children.Pages.CurrentPage)
		end
	end

	function children:ScrollPixels(p)
		local y = children.PageView.CanvasPosition.Y
		local v20 = children.PageView.CanvasSize.Y.Offset - children.PageViewClipper.AbsoluteSize.y
		local v21 = math.max(0, (math.min(y + p, v20)))
		children.PageView.CanvasPosition = Vector2.new(0, v21)
	end

	function children.ScrollToFrame(_, p, p2)
		if v18 or p2 then
			local v20 = p.AbsolutePosition.y - children.Pages.CurrentPage.Page.AbsolutePosition.y
			local v21 = v20 + p.AbsoluteSize.y

			if v20 < children.PageView.CanvasPosition.y then
				children.PageView.CanvasPosition = Vector2.new(0, v20)
			elseif
				children.Pages.CurrentPage.Page.Name == Constants.PeoplePageKey
				and v21 - children.PageView.CanvasPosition.y > children.PageView.AbsoluteSize.Y - Constants.PeoplePageScrollBuffer
			then
				children.PageView.CanvasPosition = Vector2.new(
					0,
					v21 - children.PageView.AbsoluteSize.Y + Constants.PeoplePageScrollBuffer
				)
			elseif v21 - children.PageView.CanvasPosition.y > children.PageViewClipper.Size.Y.Offset then
				children.PageView.CanvasPosition = Vector2.new(0, v21 - children.PageViewClipper.Size.Y.Offset)
			end
		end
	end

	function children:GetFirstPageWithTabHeader()
		local v20 = nil

		for k, _ in pairs(children.Pages.PageTable) do
			if k:GetTabHeader() ~= nil and k.TabPosition == 1 then
				v20 = k
				break
			end
		end

		if v20 ~= nil then
			return v20
		end

		error("No page with tab header found")
		return nil
	end

	function children:InitInPage(currentPage)
		local tabPosition = currentPage.TabPosition

		for k, _ in pairs(children.Pages.PageTable) do
			if k ~= currentPage then
				k:Hide(-1, tabPosition, true, nil, children.PageViewInnerFrame)
			end
		end

		if
			(not v3.FFlagRelocateMobileMenuButtons or v3.FIntRelocateMobileMenuButtonsVariant == 0 or v3.FIntRelocateMobileMenuButtonsVariant == 2 and Utility:IsSmallTouchScreen())
			and children.BottomButtonFrame
		then
			if shouldShowBottomBar(currentPage) then
				setBottomBarBindings()
				setBottomBarSelection(currentPage)
			else
				children.BottomButtonFrame.Visible = false
			end

			local hubBar = children.HubBar
			hubBar.Visible = shouldShowHubBar(currentPage) -- inferred equivalent call
		end

		local isPageClipped = currentPage.IsPageClipped == true
		children.PageViewClipper.ClipsDescendants = isPageClipped
		children.PageView.ClipsDescendants = isPageClipped

		children.PageViewInnerFrame.ClipsDescendants = isPageClipped

		children.Pages.CurrentPage = currentPage
		children.Pages.CurrentPage.Active = true
		children.CurrentPageSignal:fire(children.Pages.CurrentPage and children.Pages.CurrentPage.Page.Name or nil)

		if isSideSheetEnabled then
			updatePageTitleHeader(children.Pages.CurrentPage) -- inferred equivalent call
		end

		local size = children.Pages.CurrentPage:GetSize()
		children.PageView.CanvasSize = UDim2.new(0, 0, 0, size.Y)

		changedConnection = children.Pages.CurrentPage.Page.Changed:connect(function(p)
			if p == "AbsoluteSize" then
				local size2 = children.Pages.CurrentPage:GetSize()
				children.PageView.CanvasSize = UDim2.new(0, 0, 0, size2.Y)
			end
		end)
	end

	function children:SwitchToPage(currentPage, p, p2, p3, _, p4)
		if
			children.Pages.PageTable[currentPage] == nil
			or v3.FFlagPreventHiddenSwitchPage and children:GetVisibility() == false
		then
			return
		end

		if defineFastFlag2 then
			if currentPage.Page.Name == "ReportAbuseMenuNewContainerPage" then
				children.PageViewInnerFrame.UIPadding.PaddingTop = UDim.new(0, 0)
			else
				children.PageViewInnerFrame.UIPadding.PaddingTop = UDim.new(0, 5)
			end
		end

		local udim3 = UDim.new(0, 0)
		local udim4 = UDim.new(0, 0)
		local v20 = not (Utility:IsPortrait() or Utility:IsSmallTouchScreen()) or Theme.AlwaysShowBottomBar()
		local v21 = v3.FFlagRelocateMobileMenuButtons
			and (v3.FIntRelocateMobileMenuButtonsVariant == 1 or v3.FIntRelocateMobileMenuButtonsVariant == 3 or v3.FIntRelocateMobileMenuButtonsVariant == 2 and not Utility:IsSmallTouchScreen())
			and true
			or v20

		if children.HubBar and not (shouldShowHubBar(currentPage) or currentPage.DisableTopPadding) then -- inferred equivalent call
			udim3 = UDim.new(0, children.HubBar.AbsoluteSize.Y)
		end

		if not isSideSheetEnabled and children.BottomButtonFrame and v21 and not shouldShowBottomBar(currentPage) then
			udim4 = UDim.new(0, children.BottomButtonFrame.AbsoluteSize.Y)
		end

		local hubPadding = Theme.HubPadding()
		children.MenuContainerPadding.PaddingLeft = hubPadding.PaddingLeft
		children.MenuContainerPadding.PaddingRight = hubPadding.PaddingRight
		children.MenuContainerPadding.PaddingBottom = hubPadding.PaddingBottom + udim4
		children.MenuContainerPadding.PaddingTop = hubPadding.PaddingTop + udim3

		local menuContainerPosition = Theme.MenuContainerPosition(children.SettingsUIDelegate)

		local position = menuContainerPosition.Position
		local anchorPoint = menuContainerPosition.AnchorPoint
		local sideSheetMenuInset = getSideSheetMenuInset() -- inferred equivalent call

		if not (sideSheetMenuInset <= 0) then
			local halfSideSheetMenuInset = sideSheetMenuInset / 2

			position = UDim2.new(position.X.Scale, position.X.Offset + halfSideSheetMenuInset, 0.5, 0)
			anchorPoint = Vector2.new(anchorPoint.X, 0.5)
		end

		children.MenuContainer.Position = position
		children.MenuContainer.Size = menuContainerPosition.Size
		children.MenuContainer.AnchorPoint = anchorPoint

		local v22 = p2 == nil
			and children.Pages.CurrentPage
			and children.Pages.CurrentPage.TabHeader
			and currentPage
			and currentPage.TabHeader
			and (children.Pages.CurrentPage.TabHeader.AbsolutePosition.x < currentPage.TabHeader.AbsolutePosition.x and 1 or -1)
			or p2

		local v23 = v22 == nil and 1 or v22

		if children.Pages.CurrentPage and changedConnection ~= nil then
			changedConnection:disconnect()
			children.Pages.CurrentPage.Active = false
		end

		if v3.FFlagFixDisabledScrollOnIos and canvasPositionChangedConnection ~= nil then
			canvasPositionChangedConnection:Disconnect()
			canvasPositionChangedConnection = nil
		end

		local tabPosition = currentPage.TabPosition

		for k, _ in pairs(children.Pages.PageTable) do
			if k ~= currentPage then
				k:Hide(-v23, tabPosition, p3, nil, children.PageViewInnerFrame, k == children.Pages.CurrentPage)
			end
		end

		if children.BottomButtonFrame then
			if shouldShowBottomBar(currentPage) then
				setBottomBarBindings()
				setBottomBarSelection(currentPage)
			else
				children.BottomButtonFrame.Visible = false
			end

			local hubBar = children.HubBar
			hubBar.Visible = shouldShowHubBar(currentPage) -- inferred equivalent call
		end

		if v3.FFlagIEMTabFocusNav then
			setTabHeaderSelection(currentPage) -- inferred equivalent call
		end

		local isPageClipped = currentPage.IsPageClipped == true
		children.PageViewClipper.ClipsDescendants = isPageClipped
		children.PageView.ClipsDescendants = isPageClipped
		children.PageViewInnerFrame.ClipsDescendants = isPageClipped

		children.Pages.CurrentPage = currentPage
		children.Pages.CurrentPage:Display(children.PageViewInnerFrame, p3)
		children.Pages.CurrentPage.Active = true
		children.CurrentPageSignal:fire(children.Pages.CurrentPage and children.Pages.CurrentPage.Page.Name or nil)

		if isSideSheetEnabled then
			updatePageTitleHeader(children.Pages.CurrentPage) -- inferred equivalent call
		end

		if shouldDisableDefaultScroll(nil) then -- inferred equivalent call
			children.PageView.ScrollBarThickness = 0
			children.PageView.ScrollingEnabled = false
			children.PageView.CanvasPosition = Vector2.new(0, 0)
			children.PageView.CanvasSize = UDim2.new(1, 0, 1, 0)

			if v3.FFlagFixDisabledScrollOnIos then
				canvasPositionChangedConnection = children.PageView:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
					if children.PageView.CanvasPosition.Magnitude > 0 then
						children.PageView.CanvasPosition = Vector2.new(0, 0)
					end
				end)
			end
		else
			children.PageView.ScrollBarThickness = Theme.DefaultScrollBarThickness
			children.PageView.ScrollingEnabled = true
			local size = children.Pages.CurrentPage:GetSize()
			children.PageView.CanvasSize = UDim2.new(0, 0, 0, size.Y)
		end

		changedConnection = children.Pages.CurrentPage.Page.Changed:connect(function(p5)
			if p5 == "AbsoluteSize" and not shouldDisableDefaultScroll(nil) then -- inferred equivalent call
				local size = children.Pages.CurrentPage:GetSize()
				children.PageView.CanvasSize = UDim2.new(0, 0, 0, size.Y)
			end
		end)

		if children.MenuStack[#children.MenuStack] ~= children.Pages.CurrentPage and not p then
			children.MenuStack[#children.MenuStack + 1] = children.Pages.CurrentPage
		end

		if currentPage.DisableTopPadding then
			onScreenSizeChanged()
		end

		local joined = {}
		joined.universeid = tostring(game.GameId)

		if v3.GetFFlagReportAbuseMenuEntrypointAnalytics() and p4 then
			joined = Cryo.Dictionary.join(joined, p4)
		end

		if v3.FFlagRespawnChromeShortcutTelemetry and joined.used_shortcut == nil then
			joined.used_shortcut = false
		end

		if joined.playsessionid == nil then
			joined.playsessionid = children.playSessionId
		end

		if currentPage then
			if v3.FFlagHelpPageIXPExposure and children.HelpPage == currentPage and not children.HelpPageIXPFetched then
				IXPServiceWrapper:LogUserLayerExposure(v3.FStringHelpPageIXPLayer)
				children.HelpPageIXPFetched = true
			end

			if children.GameSettingsPage == currentPage then
				RbxAnalyticsService:SetRBXEventStream(
					Constants.AnalyticsTargetName,
					"open_GameSettings_tab",
					Constants.AnalyticsMenuActionName,
					joined
				)

				if Flags.FFlagIEMSettingsLogExposureIXPFlags and not children.GameSettingsPageReorderIXPFetched then
					IXPServiceWrapper:LogFlagLinkedUserLayerExposure(v3.GetFStringInExperienceMenuIXPLayer())
					children.GameSettingsPageReorderIXPFetched = true
				end
			else
				RbxAnalyticsService:SetRBXEventStream(
					Constants.AnalyticsTargetName,
					"open_" .. currentPage.Page.Name .. "_tab",
					Constants.AnalyticsMenuActionName,
					joined
				)
			end

			ExperienceMenuSessionManagerInstance:MenuSwitchToPage(currentPage.Page)
		else
			RbxAnalyticsService:SetRBXEventStream(
				Constants.AnalyticsTargetName,
				"open_unknown_tab",
				Constants.AnalyticsMenuActionName,
				joined
			)
			ExperienceMenuSessionManagerInstance:CloseOpenedMenuTab()
		end

		if v3.FFlagAddTraversalHistory and v3.FFlagIntegrateTraversalHistoryInSideSheet then
			ReactPageSignal(false).setCurrentReactPage(nil)
		end
	end

	function children.SetActive(_, active)
		children.Active = active

		if children.Pages.CurrentPage then
			children.Pages.CurrentPage.Active = active
		end
	end

	function clearMenuStack()
		while children.MenuStack and #children.MenuStack > 0 do
			children:PopMenu()
		end
	end

	function setOverrideMouseIconBehavior()
		if not children.Visible then
			return
		end

		if UserInputService:GetLastInputType() == Enum.UserInputType.Gamepad1 or VRService.VREnabled then
			MouseIconOverrideService.push(named, Enum.OverrideMouseIconBehavior.ForceHide)
		else
			MouseIconOverrideService.push(named, Enum.OverrideMouseIconBehavior.ForceShow)
		end
	end

	function checkLeaveGameUpsell()
		if not v3.GetFFlagEnableLeaveGameUpsellEntrypoint() then
			return
		end

		if not children.sessionStartTime then
			children.sessionStartTime = os.time()
		end

		if not children.sessionStartTime then
			return
		end

		if children.checkedUpsell or children.leaveGameUpsellProp ~= Constants2.PHONE_UPSELL_VALUE_PROP.None then
			if children.checkedUpsell then
				local phoneVerificationUpsell = default:FetchPhoneVerificationUpsell(
					Constants2.EXIT_CONFIRMATION_PHONE_UPSELL_IXP_LAYER,
					children.sessionStartTime,
					false
				)

				if children.leaveGameUpsellProp ~= phoneVerificationUpsell then
					children.leaveGameUpsellProp = phoneVerificationUpsell
					children.LeaveGameUpsellPage:SetUpsellProp(children.leaveGameUpsellProp)
				end
			end
		else
			children.checkedUpsell = true
			children.leaveGameUpsellProp = default:FetchPhoneVerificationUpsell(
				Constants2.EXIT_CONFIRMATION_PHONE_UPSELL_IXP_LAYER,
				children.sessionStartTime,
				true
			)

			children.LeaveGameUpsellPage:SetUpsellProp(children.leaveGameUpsellProp)
			task.delay(defineFastInt, function()
				children.checkedUpsell = false
			end)
		end
	end

	local fn8 = v3.FFlagSettingsHubIndependentBackgroundVisibility and function(visible, p, p2)
		if
			not children.DarkenBackground
			or not visible
			and children.DarkenBackground.Visible
			and (InExperienceAppChatModal:getVisible() or children.Visible)
		then
			return
		end

		local backgroundTransparency = 1
		local v20 = Enum.EasingStyle.Quart

		local shieldCloseTweenTime = getShieldCloseTweenTime( -- inferred equivalent call
			not Constants and 0.4 or Constants.ShieldCloseAnimationTweenTime,
			p2
		)

		if visible then
			if v3.isInExperienceUIVREnabled then
				backgroundTransparency = children.SettingsUIDelegate:getDarkBackgroundTheme().Transparency
			else
				backgroundTransparency = Theme.transparency("DarkenBackground")
			end

			v20 = Enum.EasingStyle.Quad
			shieldCloseTweenTime = not Constants and 0.5 or Constants.ShieldOpenAnimationTweenTime
			shieldCloseTweenTime = getShieldOpenTweenTime(shieldCloseTweenTime) -- inferred equivalent call
		end

		if p then
			if children.DarkenBackgroundTween then
				children.DarkenBackgroundTween:Cancel()
				children.DarkenBackgroundTween = nil
			end

			children.DarkenBackground.BackgroundTransparency = backgroundTransparency
		else
			local tweenInfo = TweenInfo.new(shieldCloseTweenTime, v20, Enum.EasingDirection.Out)

			if children.DarkenBackgroundTween then
				children.DarkenBackgroundTween:Cancel()
			end

			children.DarkenBackgroundTween = TweenService:Create(children.DarkenBackground, tweenInfo, {
				BackgroundTransparency = backgroundTransparency
			})
			children.DarkenBackgroundTween:Play()
		end

		children.DarkenBackground.Visible = visible
	end or nil

	setVisibilityInternal = function(visible, p, p2, _, source)
		local v20 = shouldUseSideSheetPeoplePageLayout() -- inferred equivalent call

		if
			FFlagSideSheetOpenPeoplePage
			and getDidSideSheetOpenWithPeoplePage()
			and not visible
			and children.Visible
		then
			toggleSideSheet(false)
		end

		if v3.isInExperienceUIVREnabled then
			p = p or not children.SettingsUIDelegate:isOpenCloseAnimationAllowed()
		end

		children.OpenStateChangedCount += 1

		local v21 = visible ~= children.Visible
		children.Visible = visible

		if v3.FFlagEnableInGameMenuDurationLogger and v21 and not visible then
			PerfUtils.menuClose()
		end

		if children.ResizedConnection then
			children.ResizedConnection:disconnect()
			children.ResizedConnection = nil
		end

		if children.BackBarVisibleConnection then
			children.BackBarVisibleConnection:disconnect()
			children.BackBarVisibleConnection = nil
		end

		if v3.EngineFeatureTeleportHistoryButtons and children.FrontBarVisibleConnection then
			children.FrontBarVisibleConnection:disconnect()
			children.FrontBarVisibleConnection = nil
		end

		if children.PreferredTransparencyChangedConnection then
			children.PreferredTransparencyChangedConnection:disconnect()
			children.PreferredTransparencyChangedConnection = nil
		end

		local modal = children.Modal
		local visible3

		if FFlagSideSheetOpenPeoplePage then
			visible3 = shouldShowSettingsHubModal() -- inferred equivalent call
		else
			visible3 = children.Visible
		end

		modal.Visible = visible3

		if children.TabConnection then
			children.TabConnection:disconnect()
			children.TabConnection = nil
		end

		local PlayerListManager = require(RobloxGui.Modules.PlayerList.PlayerListManager)

		if v3.FFlagSettingsHubIndependentBackgroundVisibility then
			fn8(children.Visible, p, v20)
		end

		if children.Visible then
			children.ResizedConnection = RobloxGui.Changed:connect(function(p3)
				if p3 == "AbsoluteSize" then
					onScreenSizeChanged()
				end
			end)

			if v3.FFlagMenuButtonsMountWithIEM then
				if
					v3.FFlagRelocateMobileMenuButtons
					and (v3.FIntRelocateMobileMenuButtonsVariant == 1 or v3.FIntRelocateMobileMenuButtonsVariant == 3 or v3.FIntRelocateMobileMenuButtonsVariant == 2 and not Utility:IsSmallTouchScreen())
				then
					fn()
				end

				if
					v3.FFlagRelocateMobileMenuButtons
					and v3.FIntRelocateMobileMenuButtonsVariant == 2
					and Utility:IsSmallTouchScreen()
					and children.PlayersPage
				then
					children.PlayersPage:CreateMenuButtonsContainer()
				end
			end

			if not v3.FFlagAddTraversalBackButton then
				if children.BackBarRef:getValue() then
					children.BackBarVisibleConnection = children.BackBarRef:getValue():GetPropertyChangedSignal("Visible"):connect(function()
						onScreenSizeChanged()
					end)
				end

				if v3.EngineFeatureTeleportHistoryButtons and children.FrontBarRef:getValue() then
					children.FrontBarVisibleConnection = children.FrontBarRef:getValue():GetPropertyChangedSignal("Visible"):connect(function()
						onScreenSizeChanged()
					end)
				end
			end

			onScreenSizeChanged()

			children.PreferredTransparencyChangedConnection = GuiService:GetPropertyChangedSignal("PreferredTransparency"):connect(function()
				onPreferredTransparencyChanged() -- inferred equivalent call
			end)
			onPreferredTransparencyChanged() -- inferred equivalent call
			children.SettingsShowSignal:fire(children.Visible)

			GuiService:SetMenuIsOpen(true, "SettingsHub")
			ExperienceMenuSessionManagerInstance:OpenExperienceMenu()
			children.Shield.Visible = children.Visible
			GuiService:CloseInspectMenu()

			if p or not children.Shield:IsDescendantOf(game) then
				children.Shield.Position = UDim2.new(0, 0, 0, 0)

				if not v3.FFlagSettingsHubIndependentBackgroundVisibility and children.DarkenBackground then
					if children.DarkenBackgroundTween then
						children.DarkenBackgroundTween:Cancel()
						children.DarkenBackgroundTween = nil
					end

					children.DarkenBackground.BackgroundTransparency = Theme.transparency("DarkenBackground")
				end
			else
				local shieldOpenTweenTime = getShieldOpenTweenTime(not Constants and 0.5 or Constants.ShieldOpenAnimationTweenTime) -- inferred equivalent call

				if gameSettings.ReducedMotion then
					if children.ReducedMotionOpenTween then
						children.ReducedMotionOpenTween:Cancel()
						children.ReducedMotionOpenTween = nil
					end

					if children.ReducedMotionCloseTween then
						children.ReducedMotionCloseTween:Cancel()
						children.ReducedMotionCloseTween = nil
					end

					children.Shield.Parent = children.CanvasGroup
					children.CanvasGroup.GroupTransparency = 1
					children.CanvasGroup.Visible = true
					children.Shield.Position = UDim2.new(0, 0, 0, 0)

					local tweenInfo = TweenInfo.new(0.25)
					children.ReducedMotionOpenTween = TweenService:Create(children.CanvasGroup, tweenInfo, {
						GroupTransparency = 0
					})
					children.ReducedMotionOpenTween:Play()

					children.ReducedMotionOpenTween.Completed:Connect(function(p3)
						if p3 == Enum.PlaybackState.Completed then
							children.Shield.Parent = children.ClippingShield
							children.ReducedMotionOpenTween = nil
						end

						children.CanvasGroup.Visible = false
					end)

					if v3.FFlagEnableInGameMenuDurationLogger then
						PerfUtils.menuOpenComplete()
					end
				else
					children.Shield:TweenPositionInternal(
						UDim2.new(0, 0, 0, 0),
						Enum.EasingDirection.InOut,
						Enum.EasingStyle.Quart,
						shieldOpenTweenTime,
						true,
						function()
							if v3.FFlagEnableInGameMenuDurationLogger then
								PerfUtils.menuOpenComplete()
							end
						end
					)
				end

				if not v3.FFlagSettingsHubIndependentBackgroundVisibility and children.DarkenBackground then
					local tweenInfo = TweenInfo.new(
						shieldOpenTweenTime,
						Enum.EasingStyle.Quad,
						Enum.EasingDirection.Out
					)

					if children.DarkenBackgroundTween then
						children.DarkenBackgroundTween:Cancel()
					end

					children.DarkenBackgroundTween = TweenService:Create(children.DarkenBackground, tweenInfo, {
						BackgroundTransparency = Theme.transparency("DarkenBackground")
					})
					children.DarkenBackgroundTween:Play()
				end
			end

			local fn9 = v3.isInExperienceUIVREnabled and function(p3, p4, p5)
				if children.SettingsUIDelegate:isInputEventNeededBySettings(p3, p4, p5) then
					return Enum.ContextActionResult.Pass
				end

				return nil
			end or function() end

			ContextActionService:BindCoreAction(
				"RbxSettingsHubStopCharacter",
				fn9,
				false,
				Enum.PlayerActions.CharacterForward,
				Enum.PlayerActions.CharacterBackward,
				Enum.PlayerActions.CharacterLeft,
				Enum.PlayerActions.CharacterRight,
				Enum.PlayerActions.CharacterJump,
				Enum.KeyCode.LeftShift,
				Enum.KeyCode.RightShift,
				Enum.KeyCode.Tab,
				Enum.UserInputType.Gamepad1,
				Enum.UserInputType.Gamepad2,
				Enum.UserInputType.Gamepad3,
				Enum.UserInputType.Gamepad4
			)

			if not isSideSheetEnabled then
				ContextActionService:BindCoreAction(
					"RbxSettingsHubSwitchTab",
					fn4,
					false,
					Enum.KeyCode.ButtonR1,
					Enum.KeyCode.ButtonL1
				)
			end

			ContextActionService:BindCoreAction(
				"RbxSettingsScrollHotkey",
				fn6,
				false,
				Enum.KeyCode.PageUp,
				Enum.KeyCode.PageDown
			)

			if shouldShowBottomBar() then
				setBottomBarBindings()
				setBottomBarSelection(children.Pages.CurrentPage)
			end

			if v3.ChromeEnabled and v3.FFlagEnableConsoleExpControls then
				local Service = require(RobloxGui.Modules.Chrome.Service)
				local Constants3 = require(RobloxGui.Modules.Chrome.ChromeShared.Unibar.Constants)
				Service:setShortcutBar(Constants3.TILTMENU_SHORTCUTBAR_ID)
			end

			if not isSideSheetEnabled then
				children.TabConnection = UserInputService.InputBegan:connect(fn5)
			end

			setOverrideMouseIconBehavior()
			lastInputTypeChangedConnection = UserInputService.LastInputTypeChanged:connect(setOverrideMouseIconBehavior)

			if UserInputService.MouseEnabled and not VRService.VREnabled then
				MouseIconOverrideService.push(named, Enum.OverrideMouseIconBehavior.ForceShow)
			end

			children:CloseReactPage()

			if p2 then
				removeBottomBarBindings()
				children:SwitchToPage(p2, nil, 1, true)
			else
				children:SwitchToPage(children:GetFirstPageWithTabHeader(), nil, 1, true)
			end

			if
				not v3.isInExperienceUIVREnabled
				or v3.InExperienceUIVRIXP:isMovePanelToCenter()
				or not VRService.VREnabled
			then
				if v3.FFlagAddNewPlayerListMobileFocusNav then
					if PlayerListManager:GetIsModal() then
						PlayerListManager:SetVisibility(false)
					else
						PlayerListManager:HideTemp("SettingsMenu", true)
					end
				else
					PlayerListManager:HideTemp("SettingsMenu", true)
				end

				if not (v3.isInExperienceUIVREnabled and v3.InExperienceUIVRIXP:isMovePanelToCenter() and v3.FFlagSpatialUIFixMenuPanelChatExclusive and VRService.VREnabled) then
					ChatSelector:HideTemp("SettingsMenu", true)
				end

				if FFlagEnableNewBackpack then
					features.setVisibility(features.FeatureName.Backpack, false)
				else
					local BackpackScript = require(RobloxGui.Modules.BackpackScript)

					if BackpackScript.IsOpen then
						BackpackScript:OpenClose()
					end
				end
			end

			if v3.GetFFlagEnableAppChatInExperience() and InExperienceAppChatModal:getVisible() then
				v7 = true
				InExperienceAppChatModal.default:setVisible(false)
			end

			if not v3.isInExperienceUIVREnabled then
				if FFlagEnableNewBackpack then
					features.setVisibility(features.FeatureName.Backpack, false)
				else
					local BackpackScript = require(RobloxGui.Modules.BackpackScript)

					if BackpackScript.IsOpen then
						BackpackScript:OpenClose()
					end
				end
			end

			children.GameSettingsPage:OpenSettingsPage()
		else
			children.CurrentPageSignal:fire("")

			if v3.FFlagMenuButtonsMountWithIEM and v3.FFlagRelocateMobileMenuButtons then
				if v3.FIntRelocateMobileMenuButtonsVariant ~= 0 then
					fn2()
				end

				if v3.FIntRelocateMobileMenuButtonsVariant == 2 and children.PlayersPage then
					children.PlayersPage:UnmountMenuButtonsContainer()
				end
			end

			if v3.ChromeEnabled and v3.FFlagEnableConsoleExpControls then
				local Service = require(RobloxGui.Modules.Chrome.Service)
				Service:setShortcutBar(nil)
			end

			if v3.GetFFlagEnableAppChatInExperience() and v7 then
				v7 = false
			end

			if v3.isInExperienceUIVREnabled and v3.InExperienceUIVRIXP:isMovePanelToCenter() then
				PlayerListManager:HideTemp("SettingsMenu", false)

				if not (v3.FFlagSpatialUIFixMenuPanelChatExclusive and VRService.VREnabled) then
					ChatSelector:HideTemp("SettingsMenu", false)
				end
			end

			if p then
				children.Shield.Position = SHIELD_INACTIVE_POSITION
				children.Shield.Visible = children.Visible
				children.SettingsShowSignal:fire(children.Visible)
				GuiService:SetMenuIsOpen(false, "SettingsHub")
				ExperienceMenuSessionManagerInstance:CloseExperienceMenu()

				if v3.FFlagEnableInGameMenuDurationLogger then
					PerfUtils.menuCloseComplete()
				end

				if not v3.FFlagSettingsHubIndependentBackgroundVisibility and children.DarkenBackground then
					if children.DarkenBackgroundTween then
						children.DarkenBackgroundTween:Cancel()
						children.DarkenBackgroundTween = nil
					end

					children.DarkenBackground.BackgroundTransparency = 1
				end
			else
				local v22 = not Constants and 0.4 or Constants.ShieldCloseAnimationTweenTime

				if shouldCloseShieldWithSideSheet(v20) then -- inferred equivalent call
					v22 = getSideSheetAnimationDuration()
				end

				local function handleShieldClose()
					if not v3.FFlagAddTraversalBackButton then
						children.SettingsShowSignal:fire(children.Visible)
					end

					if not children.Visible then
						GuiService:SetMenuIsOpen(false, "SettingsHub")
						ExperienceMenuSessionManagerInstance:CloseExperienceMenu()
					end

					if v3.FFlagEnableInGameMenuDurationLogger then
						PerfUtils.menuCloseComplete()
					end
				end

				if v3.FFlagAddTraversalBackButton then
					children.SettingsShowSignal:fire(children.Visible)
				end

				if gameSettings.ReducedMotion then
					if children.ReducedMotionOpenTween then
						children.ReducedMotionOpenTween:Cancel()
						children.ReducedMotionOpenTween = nil
					end

					if children.ReducedMotionCloseTween then
						children.ReducedMotionCloseTween:Cancel()
						children.ReducedMotionCloseTween = nil
					end

					children.Shield.Parent = children.CanvasGroup
					children.CanvasGroup.Visible = true

					local tweenInfo = TweenInfo.new(0.25)
					children.ReducedMotionCloseTween = TweenService:Create(children.CanvasGroup, tweenInfo, {
						GroupTransparency = 1
					})
					children.ReducedMotionCloseTween:Play()
					children.ReducedMotionCloseTween.Completed:Connect(function(p3)
						if p3 == Enum.PlaybackState.Completed then
							children.Shield.Position = SHIELD_INACTIVE_POSITION

							children.Shield.Visible = children.Visible
							children.Shield.Parent = children.ClippingShield
							children.ReducedMotionCloseTween = nil
						end

						children.CanvasGroup.Visible = false
					end)

					handleShieldClose()
				else
					if v3.ChromeEnabled and v3.FFlagEnableConsoleExpControls then
						local Service = require(RobloxGui.Modules.Chrome.Service)
						Service:setShortcutBar(nil)
					end

					local v23 = Enum.EasingDirection.In
					local v24 = Enum.EasingStyle.Quad
					v20 = shouldCloseShieldWithSideSheet(v20) -- inferred equivalent call

					if v20 then
						v23 = Enum.EasingDirection.Out
						v24 = Enum.EasingStyle.Quart
					end

					children.Shield:TweenPositionInternal(SHIELD_INACTIVE_POSITION, v23, v24, v22, true, function()
						children.Shield.Visible = children.Visible
						handleShieldClose()
					end)
				end

				if not v3.FFlagSettingsHubIndependentBackgroundVisibility and children.DarkenBackground then
					local tweenInfo = TweenInfo.new(v22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

					if children.DarkenBackgroundTween then
						children.DarkenBackgroundTween:Cancel()
					end

					children.DarkenBackgroundTween = TweenService:Create(children.DarkenBackground, tweenInfo, {
						BackgroundTransparency = 1
					})
					children.DarkenBackgroundTween:Play()
				end
			end

			if lastInputTypeChangedConnection then
				lastInputTypeChangedConnection:disconnect()
			end

			if v3.isInExperienceUIVREnabled then
				if not (v3.InExperienceUIVRIXP:isMovePanelToCenter() or VRService.VREnabled) then
					PlayerListManager:HideTemp("SettingsMenu", false)
					ChatSelector:HideTemp("SettingsMenu", false)
				end
			else
				PlayerListManager:HideTemp("SettingsMenu", false)

				ChatSelector:HideTemp("SettingsMenu", false)
			end

			if not VRService.VREnabled then
				MouseIconOverrideService.pop(named)
			end

			children:CloseReactPage()

			clearMenuStack()

			if not isSideSheetEnabled then
				ContextActionService:UnbindCoreAction("RbxSettingsHubSwitchTab")
			end

			ContextActionService:UnbindCoreAction("RbxSettingsHubStopCharacter")
			ContextActionService:UnbindCoreAction("RbxSettingsScrollHotkey")

			removeBottomBarBindings(0.4)
			GuiService.SelectedCoreObject = nil

			children.GameSettingsPage:CloseSettingsPage()
		end

		local v22 = {
			source = source,
			playsessionid = children.playSessionId,
			universeid = tostring(game.GameId)
		}

		if v21 then
			if visible then
				RbxAnalyticsService:SetRBXEventStream(
					Constants.AnalyticsTargetName,
					Constants.AnalyticsMenuOpenName,
					Constants.AnalyticsMenuActionName,
					v22
				)

				if v3.GetFFlagEnableLeaveGameUpsellEntrypoint() then
					task.spawn(checkLeaveGameUpsell)
				end
			else
				RbxAnalyticsService:SetRBXEventStream(
					Constants.AnalyticsTargetName,
					Constants.AnalyticsMenuCloseName,
					Constants.AnalyticsMenuActionName,
					v22
				)
			end
		end
	end

	function children:SetVisibility(p, p2, p3, p4, p5)
		if children.Visible == p then
			return
		end

		setVisibilityInternal(p, p2, p3, p4, p5)
	end

	function children:SetBackgroundVisibility(p, p2)
		if children.DarkenBackground.Visible == p then
			return
		end

		fn8(p, p2)
	end

	function children.GetVisibility(_)
		return children.Visible
	end

	function children:ToggleVisibility(p, p2)
		setVisibilityInternal(not children.Visible, nil, nil, p, p2)
	end

	function children:AddToMenuStack(p)
		if children.MenuStack[#children.MenuStack] ~= p then
			children.MenuStack[#children.MenuStack + 1] = p
		end
	end

	function children:InviteToGame()
		if game:GetEngineFeature("PlatformFriendsService") and v5 and v5:IsInviteFriendsEnabled() then
			v5:ShowInviteFriendsUI()
		elseif UserInputService:GetPlatform() == Enum.Platform.XBoxOne then
			if v4 then
				v4:PopupGameInviteUI()
			end
		else
			if not v3.FFlagAddInviteFriendsIntegration or children.Visible then
				children:ToggleVisibility()
			end

			GameInviteModalManager:openModal({ trigger = GameInviteConstants.Triggers.GameMenu })

			if v3.FFlagEnableConsoleExpControls and v3.ChromeEnabled then
				local Service = require(RobloxGui.Modules.Chrome.Service)
				Service:setShortcutBar(nil)
			end
		end

		if isSideSheetPairedWithPeoplePage() then -- inferred equivalent call
			toggleSideSheet(false)
		end
	end

	function children:PopMenu(_, p, p2)
		if children.MenuStack and #children.MenuStack > 0 then
			local v20 = children.MenuStack[#children.MenuStack]

			if type(v20) ~= "table" then
				poppedMenu:Fire(v20)
			end

			table.remove(children.MenuStack, #children.MenuStack)
			children:SwitchToPage(children.MenuStack[#children.MenuStack], true, 1, p)

			if #children.MenuStack == 0 then
				if v3.FFlagAddUILessMode then
					children:SetVisibility(false, nil, nil, nil, p2)
				else
					children:SetVisibility(false)
				end

				children.Pages.CurrentPage:Hide(0, 0, nil, nil, children.PageViewInnerFrame)
			elseif v3.ChromeEnabled and v3.FFlagEnableConsoleExpControls then
				local Service = require(RobloxGui.Modules.Chrome.Service)
				local Constants3 = require(RobloxGui.Modules.Chrome.ChromeShared.Unibar.Constants)
				Service:setShortcutBar(Constants3.TILTMENU_SHORTCUTBAR_ID)
			end
		else
			children.MenuStack = {}
			poppedMenu:Fire()

			if v3.FFlagAddUILessMode then
				children:ToggleVisibility(nil, p2)
			else
				children:ToggleVisibility(p2)
			end
		end
	end

	function children:ShowShield()
		local backgroundTransparency = UserInputService.VREnabled and 1 or transparency

		children.Shield.BackgroundTransparency = backgroundTransparency
	end

	function children:HideShield()
		children.Shield.BackgroundTransparency = 1
	end

	function children:ShowReactPage()
		if children.reactPage then
			children.reactPageAnalytics:openPage(children.reactPage.name)
		end

		children.ReactPage.Visible = true
		children.Page.Visible = false
	end

	function children:HideReactPage()
		if children.reactPage then
			children.reactPageAnalytics:closePage(children.reactPage.name)
		end

		local visible = children.ReactPage.Visible
		children.ReactPage.Visible = false
		children.Page.Visible = true

		if children.Pages.CurrentPage and visible and children.Visible then
			children.Pages.CurrentPage:SelectARow(true)
		end
	end

	function children:MountReactPage()
		ReactPageSignal(false).setCurrentReactPage(nil)

		if children.reactPageRoot then
			children:UnmountReactPage()
		end

		children.reactPageRoot = ReactRoblox.createRoot(children.ReactPage)
	end

	function children:UnmountReactPage()
		if children.reactPageRoot then
			children.reactPageRoot:unmount()
			children.reactPageRoot = nil
		end
	end

	function children:CloseReactPage()
		children:HideReactPage()
		children:UnmountReactPage()
	end

	function children:SwitchToReactPage(reactPage, p, flag: boolean?)
		if flag then
			children:UnmountReactPage()
		elseif reactPage then
			children.reactPage = reactPage

			if not children.reactPageRoot then
				children:MountReactPage()
			end

			children.reactPageRoot:render(reactPage:createPage(p))
		end

		children:ShowReactPage()
	end

	children.GameSettingsPageReorderIXPFetched = false
	local settingsShowSignalConnection = nil
	local v20 = nil
	local function enableVR()
		local VrCommon2 = require(CorePackages.Workspace.Packages.VrCommon)
		local vrHub = VrCommon2.VRHub
		local VrCommon3 = require(CorePackages.Workspace.Packages.VrCommon)
		local panel3D = VrCommon3.Panel3D
		local settingsMenu = panel3D.Get("SettingsMenu")
		settingsMenu:ResizeStuds(4, 4, 250)
		settingsMenu:SetType(panel3D.Type.Standard)
		settingsMenu:SetVisible(false)
		settingsMenu:SetCanFade(false)

		children.ClippingShield.Parent = settingsMenu:GetGUI()
		children.Shield.Parent.ClipsDescendants = false
		children.VRShield.Visible = true
		children:HideShield()

		settingsShowSignalConnection = children.SettingsShowSignal:connect(function(p)
			if p then
				settingsMenu:SetVisible(true)

				vrHub:FireModuleOpened("SettingsMenu")
			else
				settingsMenu:SetVisible(false)

				vrHub:FireModuleClosed("SettingsMenu")
			end
		end)

		vrHub.ModuleOpened.Event:connect(function(p)
			if p ~= "SettingsMenu" then
				children:SetVisibility(false)
			end
		end)
	end
	local function disableVR()
		children.ClippingShield.Parent = RobloxGui
		children.Shield.Parent.ClipsDescendants = true
		children.VRShield.Visible = false
		children:ShowShield()

		if settingsShowSignalConnection then
			settingsShowSignalConnection:disconnect()
			settingsShowSignalConnection = nil
		end

		if v20 then
			v20:disconnect()
			v20 = nil
		end

		local VrCommon2 = require(CorePackages.Workspace.Packages.VrCommon)
		VrCommon2.Panel3D.Get("SettingsMenu"):SetVisible(false)
	end

	local function refreshForSpatialUI() -- 2 equivalent calls inferred from this helper
		onScreenSizeChanged()
		onPreferredTransparencyChanged() -- inferred equivalent call
		resizeBottomBarButtons()
	end

	local function OnVREnabled(p)
		if p == "VREnabled" then
			if UserInputService.VREnabled then
				if not v3.isInExperienceUIVREnabled then
					enableVR()
					return
				end

				children.SettingsUIDelegate:enableVR()
				refreshForSpatialUI() -- inferred equivalent call
			elseif v3.isInExperienceUIVREnabled then
				children.SettingsUIDelegate:disableVR()
				refreshForSpatialUI() -- inferred equivalent call
			else
				disableVR()
			end
		end
	end
	UserInputService.Changed:connect(OnVREnabled)
	OnVREnabled("VREnabled")

	children.ResetCharacterPage:SetHub(children)

	if inExperienceCapabilities.canNavigateHome then
		children.LeaveGamePage:SetHub(children)
	end

	if v3.GetFFlagEnableLeaveGameUpsellEntrypoint() then
		children.LeaveGameUpsellPage:SetHub(children)
	end

	children.GameSettingsPage = require(RobloxGui.Modules.Settings.Pages.GameSettingsWrapper)
	children.GameSettingsPage:SetHub(children)

	children.ReportAbusePage = require(RobloxGui.Modules.Settings.Pages.ReportAbuseMenuContainerPage)
	children.ReportAbusePage:SetHub(children)

	children.ReportSentPage = require(RobloxGui.Modules.Settings.Pages.ReportSentPage)
	children.ReportSentPage:SetHub(children)

	children.ReportSentPageV2 = require(RobloxGui.Modules.Settings.Pages.ReportSentPageV2)
	children.ReportSentPageV2:SetHub(children)

	children.HelpPage = require(RobloxGui.Modules.Settings.Pages.HelpWrapper)
	children.HelpPage:SetHub(children)

	if v3.FFlagHelpPageIXPExposure then
		children.HelpPageIXPFetched = false
	end

	if inExperienceCapabilities.canListPeopleInSameServer then
		children.PlayersPage = require(RobloxGui.Modules.Settings.Pages.PeopleWrapper)
		children.PlayersPage:SetHub(children)

		if
			not v3.FFlagMenuButtonsMountWithIEM
			and v3.FFlagRelocateMobileMenuButtons
			and v3.FIntRelocateMobileMenuButtonsVariant == 2
			and Utility:IsSmallTouchScreen()
		then
			children.PlayersPage:CreateMenuButtonsContainer()
		end
	end

	if v3.FFlagAddIEMProfilePage then
		children.PlayerProfilePage = require(RobloxGui.Modules.Settings.Pages.PlayerProfile)
	end

	if not v3.isExitModalRemoved and isSubjectToDesktopPolicies() then
		children.ExitModalPage = require(RobloxGui.Modules.Settings.Pages.ExitModal)
		children.ExitModalPage:SetHub(children)
	end

	if isSubjectToDesktopPolicies() and inExperienceCapabilities.canNavigateHome then
		children.LeaveGameToHomePage = require(RobloxGui.Modules.Settings.Pages.LeaveGameToHome)
		children.LeaveGameToHomePage:SetHub(children)
	end

	local v21 = CapturesPolicy.PolicyImplementation.read()
	local v22

	if v21 then
		v22 = CapturesPolicy.Mapper(v21).eligibleForCapturesFeature()
	else
		v22 = false
	end

	local fFlagFixSpatialUICaptures = v3.isInExperienceUIVREnabled and v3.FFlagFixSpatialUICaptures

	if v22 and not (fFlagFixSpatialUICaptures and isSpatial()) then
		local CapturesPageWrapper = require(RobloxGui.Modules.Settings.Pages.CapturesPageWrapper)

		local function closeSettingsMenu()
			children:SetVisibility(false, true)
		end

		children.CapturesApp = CapturesApp
		children.CapturesApp.mountMenuPage(CapturesPageWrapper.Page, closeSettingsMenu, v3.ChromeEnabled)

		children.CapturesPage = CapturesPageWrapper
		children.CapturesPage:ConnectHubToApp(children, children.PageViewClipper, children.CapturesApp)
	end

	if v3.FFlagIntegrateTraversalHistoryInSideSheet then
		local TraversalHistoryWrapper = require(RobloxGui.Modules.Settings.Pages.TraversalHistoryWrapper)
		children.TraversalHistoryPage = TraversalHistoryWrapper()
		children.TraversalHistoryPage:SetHub(children)
	end

	if children.PlayersPage then
		children:AddPage(children.PlayersPage)
	end

	children:AddPage(children.ResetCharacterPage)

	if children.LeaveGamePage then
		children:AddPage(children.LeaveGamePage)
	end

	if v3.GetFFlagEnableLeaveGameUpsellEntrypoint() and children.LeaveGameUpsellPage then
		children:AddPage(children.LeaveGameUpsellPage)
	end

	children:AddPage(children.GameSettingsPage)

	if children.CapturesPage then
		children:AddPage(children.CapturesPage)
	end

	if children.ReportAbusePage then
		children:AddPage(children.ReportAbusePage)
	end

	if children.ReportSentPage then
		children:AddPage(children.ReportSentPage)
	end

	if children.ReportSentPageV2 then
		children:AddPage(children.ReportSentPageV2)
	end

	children:AddPage(children.HelpPage)

	if not v3.isExitModalRemoved and children.ExitModalPage then
		children:AddPage(children.ExitModalPage)
	end

	if children.LeaveGameToHomePage then
		children:AddPage(children.LeaveGameToHomePage)
	end

	if children.TraversalHistoryPage then
		children:AddPage(children.TraversalHistoryPage)
	end

	children:InitInPage(children:GetFirstPageWithTabHeader())

	if not v3.isNewInGameMenuEnabled() and (not v3.FFlagAddUILessMode or v3.FIntAddUILessModeVariant == 0) then
		ContextActionService:BindCoreAction("RBXEscapeMainMenu", function(_, p, _)
			if
				p ~= Enum.UserInputState.Begin
				or (v3.FFlagShowSwitchServerButton or isPioneerLaunch())
				and GetSwitchServerStore(false).isConfirmationOpen(false)
			then
				return
			end

			if isSideSheetEnabled then
				if getSideSheetVisibility() then
					if isSideSheetPairedWithPeoplePage() and getIsPeoplePageOpen() then -- inferred equivalent call
						children:SetVisibility(false)
					else
						toggleSideSheet(false)
					end
				elseif not (children.MenuStack and #children.MenuStack > 0) then
					toggleSideSheet(true)
				elseif v3.FFlagAddUILessMode then
					children:PopMenu(false, true, Constants.AnalyticsMenuOpenTypes.Keyboard)
				else
					children:PopMenu(false, true)
				end
			elseif v3.FFlagAddUILessMode then
				children:PopMenu(false, true, Constants.AnalyticsMenuOpenTypes.Keyboard)
			else
				children:PopMenu(false, true)
			end
		end, false, Enum.KeyCode.Escape)
	end

	local teamCreateUtils = require(CorePackages.Workspace.Packages.BuildExperiencePlaytestLaunch.teamCreateUtils)
	local viewer = teamCreateUtils.isViewer()
	GuiService.ShowLeaveConfirmation:connect(function()
		if viewer then
			return
		end

		if isSideSheetEnabled and (v3.FFlagSideSheetAndroidBack or shouldAndroidBackUseSideSheet()) then -- inferred equivalent call
			if getSideSheetVisibility() then
				if isSideSheetPairedWithPeoplePage() and getIsPeoplePageOpen() then -- inferred equivalent call
					children:SetVisibility(false)
				else
					toggleSideSheet(false)
				end
			elseif #children.MenuStack > 0 then
				children:PopMenu(false, true)
			else
				toggleSideSheet(true)
			end
		else
			if #children.MenuStack ~= 0 then
				children:PopMenu(false, true)

				return
			end

			children:SetVisibility(true, nil, nil, nil, Constants.AnalyticsMenuOpenTypes.GamepadLeaveGame)
			children:SwitchToPage(children:GetFirstPageWithTabHeader(), nil, 1)
		end
	end)

	ContextActionService:BindCoreAction("Open Dev Console", toggleDevConsole, false, Enum.KeyCode.F9)

	ContextActionService:BindCoreAction("Show Quick Profiler", toggleQuickProfilerFromHotkey, false, Enum.KeyCode.F7)

	UserInputService.InputBegan:connect(function(p)
		if
			(p.KeyCode == Enum.KeyCode.Left or p.KeyCode == Enum.KeyCode.Right or p.KeyCode == Enum.KeyCode.Up or p.KeyCode == Enum.KeyCode.Down)
			and children.Visible
			and children.Active
			and children.Pages.CurrentPage
			and GuiService.SelectedCoreObject == nil
		then
			children.Pages.CurrentPage:SelectARow()
		end
	end)

	local flag = false
	local function logExitModalIXPExposureOnce() -- 3 equivalent calls inferred from this helper
		if flag then
			return
		end

		flag = true
		IXPServiceWrapper:LogFlagLinkedUserLayerExposure(v3.GetFStringExitModalIXPLayer())
	end

	if v3.isExitModalRemoved and isSubjectToDesktopPolicies() then
		local GuiService2 = game:GetService("GuiService")
		GuiService2.NativeClose:Connect(function()
			if v3.FFlagEnableExitModalExposure then
				logExitModalIXPExposureOnce() -- inferred equivalent call
			end

			leaveGame(false, { shouldNativeExit = true })
		end)

		if children.FullScreenTitleBar then
			children.FullScreenTitleBar = SettingsFullScreenTitleBar.update(children.FullScreenTitleBar, {
				onClose = function()
					if v3.FFlagEnableExitModalExposure then
						logExitModalIXPExposureOnce() -- inferred equivalent call
					end

					leaveGame(false, { shouldNativeExit = true })
				end
			})
		end
	elseif children.ExitModalPage then
		local function showExitModal()
			if v3.FFlagEnableExitModalExposure then
				logExitModalIXPExposureOnce() -- inferred equivalent call
			end

			children.HubBar.Visible = false
			removeBottomBarBindings()

			if not children:GetVisibility() then
				children:SetVisibility(true, nil, children.ExitModalPage, false)

				return
			end

			children:AddToMenuStack(children.Pages.CurrentPage)
			children:SwitchToPage(children.ExitModalPage, nil, 1, true)
		end
		local function handleNativeExit()
			if not children:GetVisibility() or children.Pages.CurrentPage ~= children.ExitModalPage then
				showExitModal()

				return
			end

			if v3.FFlagEnableInGameMenuDurationLogger then
				PerfUtils.leavingGame()
			end

			if v3.FFlagRelocateMobileMenuButtons and v3.FIntRelocateMobileMenuButtonsVariant ~= 0 then
				fn2()

				if
					v3.FFlagMenuButtonsMountWithIEM
					and v3.FIntRelocateMobileMenuButtonsVariant == 2
					and children.PlayersPage
				then
					children.PlayersPage:UnmountMenuButtonsContainer()
				end
			end

			children.ExitModalPage.LeaveAppFunc(true)
		end

		local GuiService2 = game:GetService("GuiService")
		GuiService2.NativeClose:Connect(handleNativeExit)

		if children.FullScreenTitleBar then
			children.FullScreenTitleBar = SettingsFullScreenTitleBar.update(children.FullScreenTitleBar, {
				onClose = handleNativeExit
			})
		end
	end

	if v3.GetFFlagEnableAppChatInExperience() then
		local eventConnection2 = nil

		children.SettingsShowSignal:connect(function(p)
			if p then
				eventConnection2 = InExperienceAppChatModal.default.visibilitySignal.Event:Connect(function(p2)
					if p2 and children.Visible then
						children:SetVisibility(false, true)
					end
				end)
			elseif eventConnection2 then
				eventConnection2:Disconnect()
				eventConnection2 = nil
			end
		end)
	end

	children.InExperienceMenuReact = Create("Folder")({
		Name = "InExperienceMenuReact",
		Parent = children.ClippingShield
	})

	local buttonsContainer = children.PlayersPage.ButtonsContainer
	local leaveButtonButton

	if buttonsContainer then
		leaveButtonButton = buttonsContainer:FindFirstChild("LeaveButtonButton", true)
	end

	local leaveGameButton

	if v3.FFlagAddTraversalHistory then
		leaveGameButton = children.LeaveGameButton
	end

	local function fn9(props)
		local state, setState = React.useState(props.showSignal(false) and children.Visible)
		React.useEffect(function()
			local effect = Signals.createEffect(function(p)
				setState(props.showSignal(p) and children.Visible)
			end)
			local settingsShowSignalConnection2 = children.SettingsShowSignal:connect(function(p)
				setState(props.showSignal(false) and p)
			end)

			return function()
				effect()
				settingsShowSignalConnection2:Disconnect()
			end
		end, {})

		return v3.FFlagAddTraversalHistory
			and not (v3.isInExperienceUIVREnabled and isSpatial())
			and props.parent
			and state
			and React.createElement(PortalWithFoundationStylelink, { parent = props.parent }, {
				TraversalHistoryMenu = React.createElement(TraversalHistoryMenu, {
					anchorParent = props.parent,
					currentPageChangeSignal = props.currentPageChangeSignal,
					menuSide = props.menuSide
				})
			})
	end

	ReactRoblox.createRoot(children.InExperienceMenuReact):render(React.createElement(InExperienceMenuReact, nil, {
		InExperienceMenuReactPage = React.createElement(InExperienceMenuReactPage, {
			onMount = function()
				children:SwitchToReactPage(nil, nil, true)
			end,
			onUnmount = function()
				children:CloseReactPage()
				ReactPageSignal(false).setCurrentReactPage(nil)
			end,
			mountTo = children.ReactPage
		}),
		TraversalHistoryMenuBottomBar = React.createElement(fn9, {
			showSignal = children.showBottomBarSignal,
			parent = leaveGameButton,
			menuSide = Foundation.Enums.PopoverSide.Top,
			currentPageChangeSignal = children.CurrentPageSignal
		}),
		TraversalHistoryMenuMobileButton = React.createElement(fn9, {
			showSignal = Signals.createComputed(function(p): boolean
				return not children.showBottomBarSignal(p)
			end),
			parent = leaveButtonButton,
			menuSide = Foundation.Enums.PopoverSide.Bottom,
			currentPageChangeSignal = children.CurrentPageSignal
		})
	}))

	return children
end

local SettingsHub = {}
SettingsHub.ModuleName = "SettingsMenu"
SettingsHub.KeepVRTopbarOpen = true
SettingsHub.VRIsExclusive = true
SettingsHub.VRClosesNonExclusive = true
SettingsHub.SetVisibility = nil
VRHub:RegisterModule(SettingsHub)

VRHub.ModuleOpened.Event:connect(function(p)
	if p ~= SettingsHub.ModuleName and VRHub:GetModule(p).VRIsExclusive then
		SettingsHub:SetVisibility(false)
	end
end)

local instance = CreateSettingsHub()

if FFlagSideSheetOpenPeoplePage then
	setupPeoplePageOpenTracking(instance)
	setupInGameMenuPeoplePageActions(instance)
end

function SettingsHub:GetExperienceControlStore()
	return instance:GetExperienceControlStore()
end

function SettingsHub:SetVisibility(p, p2, p3, p4, p5)
	instance:SetVisibility(p, p2, p3, p4, p5)
end

function SettingsHub:SetBackgroundVisibility(p, p2)
	instance:SetBackgroundVisibility(p, p2)
end

function SettingsHub:ToggleVisibility(p, p2)
	instance:ToggleVisibility(p, p2)
end

function SettingsHub:SwitchToPage(p, p2)
	instance:SwitchToPage(p, p2, 1)
end

if v3.FFlagAddUILessMode and v3.FIntAddUILessModeVariant ~= 0 then
	function SettingsHub:PopMenu(p, p2, p3)
		return instance:PopMenu(p, p2, p3)
	end
end

function SettingsHub.GetVisibility(_)
	return instance.Visible
end

function SettingsHub:ShowShield()
	instance:ShowShield()
end

function SettingsHub:HideShield()
	instance:HideShield()
end

function SettingsHub:GetRespawnBehaviour()
	return instance:GetRespawnBehaviour()
end

function SettingsHub:CloseReactPage()
	instance:CloseReactPage()
end

function SettingsHub:SwitchToReactPage(p, p2, p3)
	instance:SwitchToReactPage(p, p2, p3)
end

if v3.FFlagAddInviteFriendsIntegration then
	function SettingsHub:InviteToGame()
		instance:InviteToGame()
	end
end

SettingsHub.RespawnBehaviourChangedEvent = instance.RespawnBehaviourChangedEvent

SettingsHub.SettingsShowSignal = instance.SettingsShowSignal

SettingsHub.CurrentPageSignal = instance.CurrentPageSignal

SettingsHub.SettingsShowEvent = Instance.new("BindableEvent")

instance.SettingsShowSignal:connect(function(p)
	SettingsHub.SettingsShowEvent:Fire(p)
end)

SettingsHub.Instance = instance

return SettingsHub
