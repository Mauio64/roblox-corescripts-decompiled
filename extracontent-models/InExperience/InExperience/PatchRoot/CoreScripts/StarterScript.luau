local CorePackages = game:GetService("CorePackages")
local ScriptContext = game:GetService("ScriptContext")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local VRService = game:GetService("VRService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local Modules = RobloxGui:WaitForChild("Modules")

ScriptContext:AddCoreScriptLocal("CoreScripts/CoreScriptErrorReporter", RobloxGui)

local Roact = require(CorePackages.Packages.Roact)
local Scheduler = require(CorePackages.Packages.Scheduler)
local CachedPolicyService = require(CorePackages.Workspace.Packages.CachedPolicyService)

local FFlagUseRoactGlobalConfigInCoreScripts = require(RobloxGui.Modules.Flags.FFlagUseRoactGlobalConfigInCoreScripts)

local GetFFlagScreenshotHudApi = require(RobloxGui.Modules.Flags.GetFFlagScreenshotHudApi)

local GetFFlagEnableNewInviteMenuIXP = require(Modules.Flags.GetFFlagEnableNewInviteMenuIXP)
local NewInviteMenuExperimentManager = require(Modules.Settings.Pages.ShareGame.NewInviteMenuExperimentManager)
local GetFFlagEnableSoundSessionTelemetry = require(Modules.Flags.GetFFlagEnableSoundSessionTelemetry)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagReportAnythingAnnotationIXP = SharedFlags.GetFFlagReportAnythingAnnotationIXP
local TrustAndSafetyIxp = require(CorePackages.Workspace.Packages.TrustAndSafetyIxp)
local TrustAndSafetyIXPManager = TrustAndSafetyIxp.TrustAndSafetyIXPManager

local GetCoreScriptsLayers = require(Modules.Experiment.GetCoreScriptsLayers)

local GetFFlagRtMessaging = require(RobloxGui.Modules.Flags.GetFFlagRtMessaging)
local defineFastFlag = game:DefineFastFlag("AddPublishAssetPrompt6", false)
local defineFastFlag2 = game:DefineFastFlag("EnablePromptAgeCheckListener", false)
local SharedFlags2 = require(CorePackages.Workspace.Packages.SharedFlags)
local isCharacterNameHandlerEnabled = SharedFlags2.isCharacterNameHandlerEnabled

local SharedFlags3 = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagEnableSocialContextToast = SharedFlags3.GetFFlagEnableSocialContextToast

local SharedFlags4 = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagEnableAppChatInExperience = SharedFlags4.GetFFlagEnableAppChatInExperience

local SharedFlags5 = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagChromeCentralizedConfiguration = SharedFlags5.GetFFlagChromeCentralizedConfiguration
local SharedFlags6 = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagEnableCrossExpVoice = SharedFlags6.GetFFlagEnableCrossExpVoice
local SharedFlags7 = require(CorePackages.Workspace.Packages.SharedFlags)
local FStringReactSchedulingContext = SharedFlags7.FStringReactSchedulingContext

local SharedFlags8 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagFriendsCallingClientGate_DEV = SharedFlags8.FFlagFriendsCallingClientGate_DEV

local defineFastFlag3 = game:DefineFastFlag("LuaAppEnableToastNotificationsCoreScripts4", false)

local defineFastFlag4 = game:DefineFastFlag("DisableLuobuWarningToast", false)

local FFlagDebugDisableExperienceChatMain = require(RobloxGui.Modules.Flags.FFlagDebugDisableExperienceChatMain)

local GetFFlagVoiceUserAgency3 = require(RobloxGui.Modules.Flags.GetFFlagVoiceUserAgency3)

local defineFastFlag5 = game:DefineFastFlag("EnableSendCameraAccessAnalytics", false)

local defineFastFlag6 = game:DefineFastFlag("EnableExperienceNotificationPrompts2", false)
local engineFeature = game:GetEngineFeature("EnableCancelSubscriptionApp")
local defineFastFlag7 = game:DefineFastFlag("EnableCancelSubscriptionAppLua", false)
local engineFeature2 = game:GetEngineFeature("AudioFocusManagement")

local defineFastFlag8 = game:DefineFastFlag("EnableExperienceGenericChallengeRenderingOnLoadingScript", false)
local engineFeature3 = game:GetEngineFeature("EnableRobloxCommerce")
local defineFastFlag9 = game:DefineFastFlag("EnableLinkSharingEvent", false)
local SharedFlags9 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableShareSheet = SharedFlags9.FFlagEnableShareSheet
local SharedFlags10 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagUseUIOverlayForCloudPlay = SharedFlags10.FFlagUseUIOverlayForCloudPlay
local engineFeature4 = game:GetEngineFeature("PlayerFeedbackEnabled")

local SharedFlags11 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagLuaAppInExperienceDetailsPrompt = SharedFlags11.FFlagLuaAppInExperienceDetailsPrompt
local defineFastFlag10 = game:DefineFastFlag("EnableSystemScrim", false)
local defineFastFlag11 = game:DefineFastFlag("EnableCoreUISystemV2", false)
local SharedFlags12 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableNewBackpack = SharedFlags12.FFlagEnableNewBackpack
local defineFastFlag12 = game:DefineFastFlag("EnableCorescriptsProfiler", false)
local defineFastFlag13 = game:DefineFastFlag("CoreScriptsProfilerTelemetryContext", false)
local engineFeature5 = game:DefineFastFlag("SelfieFrontendConsoleDesktop3", false)
	and game:GetEngineFeature("EnableSelfieQRCode")

local SharedFlags13 = require(CorePackages.Workspace.Packages.SharedFlags)
local GetEngineFeatureEnablePromptRobuxTransfer = SharedFlags13.GetEngineFeatureEnablePromptRobuxTransfer
local UIBlox = require(CorePackages.Packages.UIBlox)
local CoreScriptsInitializer = require(CorePackages.Workspace.Packages.CoreScriptsInitializer)
local UIBloxInGameConfig = CoreScriptsInitializer.UIBloxInGameConfig
UIBlox.init(UIBloxInGameConfig)

if defineFastFlag11 then
	require(CorePackages.Workspace.Packages.System)
end

local InExperienceTopBar = require(CorePackages.Workspace.Packages.InExperienceTopBar)
local FFlagTopBarRefactor = InExperienceTopBar.Flags.FFlagTopBarRefactor

local ExperimentCacheManager = require(CorePackages.Workspace.Packages.ExperimentCacheManager)
ExperimentCacheManager.ExperimentCacheManager.default:initialize()

if game:DefineFastFlag("LuaAppUseAppHttpStoreInExperience", false) then
	local HttpStore = require(CorePackages.Workspace.Packages.HttpStore)
	HttpStore.Instance._create({})
end

local SharedFlags14 = require(CorePackages.Workspace.Packages.SharedFlags)
local reactSchedulerIXPConfig = SharedFlags14.GetReactSchedulerIXPConfig()

if reactSchedulerIXPConfig then
	Scheduler.unstable_setSchedulerFlags(reactSchedulerIXPConfig)
end

local SharedFlags15 = require(CorePackages.Workspace.Packages.SharedFlags)

if SharedFlags15.FFlagEnableSchedulerFlagOverrides then
	local SharedFlags16 = require(CorePackages.Workspace.Packages.SharedFlags)
	local v = SharedFlags16.GetSchedulerFlagOverrides.getInExp()

	if v then
		Scheduler.unstable_setSchedulerFlags(v)
	end
end

local SharedFlags16 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableAEGIS2CommsFAEUpsell = SharedFlags16.FFlagEnableAEGIS2CommsFAEUpsell

local SharedFlags17 = require(CorePackages.Workspace.Packages.SharedFlags)

if SharedFlags17.FFlagInitializeSduiForInExperience then
	local initializeSduiForInExperience = require(Modules.ServerDrivenUi.initializeSduiForInExperience)
	initializeSduiForInExperience()
end

local LocalPlayer = Players.LocalPlayer

while not LocalPlayer do
	Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
	LocalPlayer = Players.LocalPlayer
end

local teamCreateUtils = require(CorePackages.Workspace.Packages.BuildExperiencePlaytestLaunch.teamCreateUtils)
local viewer = teamCreateUtils.isViewer()

if viewer then
	local mountTeamCreateViewer = require(CorePackages.Workspace.Packages.BuildExperience.mountTeamCreateViewer)
	mountTeamCreateViewer(game.PlaceId, UserInputService)
end

if game:GetEngineFeature("SoundServiceControlsDefaultListenerLocation") then
	ScriptContext:AddCoreScriptLocal("CoreScripts/DefaultListenerLocation", script.Parent)
end

if GetFFlagEnableAppChatInExperience() then
	ScriptContext:AddCoreScriptLocal("CoreScripts/AppChatMain", RobloxGui)
end

if FFlagFriendsCallingClientGate_DEV then
	ScriptContext:AddCoreScriptLocal("CoreScripts/FriendsCallingMain", RobloxGui)
end

if GetFFlagEnableCrossExpVoice() then
	local CrossExperienceVoice = require(CorePackages.Workspace.Packages.CrossExperienceVoice)
	CrossExperienceVoice.IXPManager.default:initialize()
end

require(CorePackages.Workspace.Packages.InExperienceSessionization)

local Chrome = require(CorePackages.Workspace.Packages.Chrome)

if Chrome.Enabled() then
	local ExpChat = require(CorePackages.Workspace.Packages.ExpChat)
	ExpChat.GlobalFlags.AvatarChatEnabled = false
	ExpChat.GlobalFlags.ChromeEnabled = true
end

local SharedFlags18 = require(CorePackages.Workspace.Packages.SharedFlags)

if SharedFlags18.GetFFlagJoinWithoutMicPermissions() then
	local ExpChat = require(CorePackages.Workspace.Packages.ExpChat)
	ExpChat.GlobalFlags.JoinWithoutMicPermissions = true
end

local defineFastFlag14 = game:DefineFastFlag("InExperienceInterventionApp", false)

local SharedFlags19 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagLuaAppEnableInExperienceDataModelStreamStarter = SharedFlags19.FFlagLuaAppEnableInExperienceDataModelStreamStarter

if FFlagUseRoactGlobalConfigInCoreScripts and RunService:IsStudio() then
	Roact.setGlobalConfig({ propValidation = true, elementTracing = true })
end

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local uiBlox = InGameMenuDependencies.UIBlox

if uiBlox ~= UIBlox then
	uiBlox.init(UIBloxInGameConfig)
end

local sounds = Instance.new("Folder")
sounds.Name = "Sounds"
sounds.Parent = RobloxGui

local function safeRequire(p) -- 15 equivalent calls inferred from this helper
	local success, result = pcall(require, p)

	if success then
		return result
	end

	warn("Failure to Start CoreScript module " .. p.Name .. ".\n" .. result)
end

ScriptContext:AddCoreScriptLocal("CoreScripts/NotificationScript2", RobloxGui)

if FFlagLuaAppEnableInExperienceDataModelStreamStarter then
	ScriptContext:AddCoreScriptLocal("CoreScripts/InExperienceDataModelStreamStarter", script.Parent)
end

if game:GetEngineFeature("ProtocolLaunchPrivateChannelUpdateCheckEngineFeature") then
	local result = safeRequire(Modules.ChannelUpdatePrompt) -- inferred equivalent call

	if result then
		result.init()
	end
end

if not viewer and GetFFlagChromeCentralizedConfiguration() then
	coroutine.wrap(safeRequire)(Modules.Chrome.ConfigureChrome)
end

coroutine.wrap(safeRequire)(Modules.SelfieView)

if not viewer then
	coroutine.wrap(safeRequire)(Modules.TopBar)
end

local v = FFlagUseUIOverlayForCloudPlay
	and not viewer
	and coroutine.wrap(safeRequire)(CorePackages.Workspace.Packages.InExperienceCloudPlay)

if v then
	v.mountCloudPlayUIOverlay()
end

local isSideSheetEnabled = require(CorePackages.Workspace.Packages.InExperienceSideSheetUtils.isSideSheetEnabled)

if not viewer and isSideSheetEnabled then
	coroutine.wrap(safeRequire)(Modules.InExperienceSideSheet)
end

local SharedFlags20 = require(CorePackages.Workspace.Packages.SharedFlags)

if SharedFlags20.FFlagEnableWhatsNew then
	coroutine.wrap(safeRequire)(Modules.InGameWhatsNew)
end

local SharedFlags21 = require(CorePackages.Workspace.Packages.SharedFlags)

if SharedFlags21.FFlagAppNavMyStatsTab then
	local v2 = coroutine.wrap(safeRequire)(CorePackages.Workspace.Packages.BuildExperiencePlaytestLaunch.BuildModeLaunch)
	local v3 = coroutine.wrap(safeRequire)(CorePackages.Workspace.Packages.BuildExperience)
	local v4 = v3 and v2 and v2:hasBuildMode()

	if v3 then
		v3.mountCreatorAgentResumeToastReceiver(v4 == true)
	end

	if v3 and v4 and not viewer then
		local StarterGui = game:GetService("StarterGui")
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)

		local SharedFlags22 = require(CorePackages.Workspace.Packages.SharedFlags)
		local fFlagBuildExperienceInGameCaptureToChat = SharedFlags22.FFlagBuildExperienceInGameCaptureToChat
		v3.mountChatSheet(fFlagBuildExperienceInGameCaptureToChat and {
			takeCapture = function(p)
				local CapturesApp = require(RobloxGui.Modules.Captures.CapturesApp)
				CapturesApp.takeCapture(p)
			end
		} or nil)
	end
end

local v2 = FFlagTopBarRefactor and coroutine.wrap(safeRequire)(CorePackages.Workspace.Packages.InExperienceOverlay)

if v2 then
	v2.createOverlay()
end

if game:GetEngineFeature("LuobuModerationStatus") then
	coroutine.wrap(function()
		safeRequire(Modules.Watermark) -- inferred equivalent call
	end)()
end

if defineFastFlag14 then
	coroutine.wrap(safeRequire)(CorePackages.Workspace.Packages.InExperienceIntervention)
end

ScriptContext:AddCoreScriptLocal("CoreScripts/MainBotChatScript2", RobloxGui)

if game:GetEngineFeature("ProximityPrompts") then
	ScriptContext:AddCoreScriptLocal("CoreScripts/ProximityPrompt", RobloxGui)
end

if game:GetEngineFeature("ValidateUGCBodyAPIFeature") then
	local UGCValidationFunctionInstaller = require(Modules.Server.UGCValidation.UGCValidationFunctionInstaller)
	UGCValidationFunctionInstaller()
end

coroutine.wrap(function()
	ScriptContext:AddCoreScriptLocal("CoreScripts/ScreenTimeInGame", RobloxGui)
end)()

if not defineFastFlag4 then
	coroutine.wrap(function()
		if CachedPolicyService:IsSubjectToChinaPolicies() then
			if not game:IsLoaded() then
				game.Loaded:Wait()
			end

			safeRequire(Modules.LuobuWarningToast) -- inferred equivalent call
		end
	end)()
end

ScriptContext:AddCoreScriptLocal("CoreScripts/PerformanceStatsManagerScript", RobloxGui)

ScriptContext:AddCoreScriptLocal("CoreScripts/PlayerRagdoll", RobloxGui)

coroutine.wrap(safeRequire)(RobloxGui.Modules.ChatSelector)
coroutine.wrap(safeRequire)(RobloxGui.Modules.PlayerList.PlayerListManager)

local success, result = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserRoactBubbleChatBeta")
end)

if game:GetEngineFeature("EnableBubbleChatFromChatService") or success and result then
	ScriptContext:AddCoreScriptLocal("CoreScripts/PlayerBillboards", RobloxGui)
end

coroutine.wrap(function()
	local result2 = safeRequire(CorePackages.Workspace.Packages.PurchasePrompt) -- inferred equivalent call

	if result2 then
		result2.mountPurchasePrompt()
	end
end)()

if defineFastFlag then
	coroutine.wrap(safeRequire)(Modules.PublishAssetPrompt)
end

coroutine.wrap(safeRequire)(Modules.ExperienceEvents.ExperienceEventsApp)

if engineFeature4 then
	coroutine.wrap(safeRequire)(Modules.PlayerFeedback)
end

coroutine.wrap(safeRequire)(Modules.Groups.GroupsApp)

coroutine.wrap(safeRequire)(Modules.AvatarGeneration.SelfieConsent)

if engineFeature5 then
	coroutine.wrap(safeRequire)(Modules.AvatarGeneration.SelfieQr)
end

ScriptContext:AddCoreScriptLocal("CoreScripts/BlockPlayerPrompt", RobloxGui)
ScriptContext:AddCoreScriptLocal("CoreScripts/FriendPlayerPrompt", RobloxGui)

if defineFastFlag2 then
	local result2 = safeRequire(Modules.PromptAgeCheckHandler) -- inferred equivalent call

	if result2 then
		result2.init()
	end
end

ScriptContext:AddCoreScriptLocal("CoreScripts/AvatarContextMenu", RobloxGui)

if FFlagEnableNewBackpack then
	require(CorePackages.Workspace.Packages.Backpack)
else
	coroutine.wrap(safeRequire)(RobloxGui.Modules.BackpackScript)
end

coroutine.wrap(safeRequire)(RobloxGui.Modules.KeyboardUINavigation)

coroutine.wrap(safeRequire)(RobloxGui.Modules.EmotesMenu.EmotesMenuMaster)

coroutine.wrap(safeRequire)(RobloxGui.Modules.Captures.CapturesApp)

coroutine.wrap(safeRequire)(Modules.AvatarEditorPrompts)

local SharedFlags22 = require(CorePackages.Workspace.Packages.SharedFlags)

if SharedFlags22.FFlagVirtualCursorModularization then
	coroutine.wrap(safeRequire)(CorePackages.Workspace.Packages.VirtualCursorModular)
else
	coroutine.wrap(safeRequire)(CorePackages.Workspace.Packages.VirtualCursor)
end

ScriptContext:AddCoreScriptLocal("CoreScripts/VehicleHud", RobloxGui)
ScriptContext:AddCoreScriptLocal("CoreScripts/InviteToGamePrompt", RobloxGui)
local v3

if game:GetEngineFeature("TouchScreenEnabled") then
	v3 = UserInputService.TouchScreenEnabled
else
	v3 = UserInputService.TouchEnabled
end

if v3 then
	ScriptContext:AddCoreScriptLocal("CoreScripts/ContextActionTouch", RobloxGui)

	RobloxGui:WaitForChild("ControlFrame")
	RobloxGui.ControlFrame:WaitForChild("BottomLeftControl")
	RobloxGui.ControlFrame.BottomLeftControl.Visible = false
end

ScriptContext:AddCoreScriptLocal("CoreScripts/InspectAndBuy", RobloxGui)

coroutine.wrap(function()
	if not VRService.VREnabled then
		VRService:GetPropertyChangedSignal("VREnabled"):Wait()
	end

	safeRequire(RobloxGui.Modules.VR.VRAvatarHeightScaling) -- inferred equivalent call
	safeRequire(RobloxGui.Modules.VR.VirtualKeyboard) -- inferred equivalent call
	safeRequire(RobloxGui.Modules.VR.UserGui) -- inferred equivalent call
end)()

coroutine.wrap(safeRequire)(RobloxGui.Modules.VR.VRAvatarGestures.VRAvatarGesturesClient)

ScriptContext:AddCoreScriptLocal("CoreScripts/NetworkPause", RobloxGui)

local SharedFlags23 = require(CorePackages.Workspace.Packages.SharedFlags)

if
	game:GetEngineFeature("GameplayPopOverlay")
	and (SharedFlags23.FFlagEnableGameplayPopLatencyOverlay or SharedFlags23.FFlagEnableGameplayPopLatencyOverlayForAdmins)
then
	ScriptContext:AddCoreScriptLocal("CoreScripts/GameplayPopOverlay", RobloxGui)
end

if GetFFlagScreenshotHudApi() and not CachedPolicyService:IsSubjectToChinaPolicies() then
	ScriptContext:AddCoreScriptLocal("CoreScripts/ScreenshotHud", RobloxGui)
end

ScriptContext:AddCoreScriptLocal("CoreScripts/MicrophoneDevicePermissionsLoggingInitializer", RobloxGui)

if game:GetEngineFeature("VoiceChatSupported") then
	ScriptContext:AddCoreScriptLocal("CoreScripts/VoiceDefaultChannel", RobloxGui)
end

coroutine.wrap(function()
	local IxpServiceWrapper = require(CorePackages.Workspace.Packages.IxpServiceWrapper)
	IxpServiceWrapper.IXPServiceWrapper:InitializeAsync(LocalPlayer.UserId, GetCoreScriptsLayers())

	if GetFFlagEnableNewInviteMenuIXP() then
		NewInviteMenuExperimentManager.default:initialize()
	end

	if GetFFlagReportAnythingAnnotationIXP() then
		TrustAndSafetyIXPManager.default:initialize()
	end
end)()

if not FFlagDebugDisableExperienceChatMain then
	ScriptContext:AddCoreScriptLocal("CoreScripts/ExperienceChatMain", RobloxGui)
end

ScriptContext:AddCoreScriptLocal("CoreScripts/ChatEmoteUsage", script.Parent)

if defineFastFlag3 then
	ScriptContext:AddCoreScriptLocal("CoreScripts/ToastNotificationGUI", script.Parent)
end

if GetFFlagRtMessaging() then
	game:GetService("RtMessagingService")
end

if game:GetEngineFeature("FacialAnimationStreaming2") then
	ScriptContext:AddCoreScriptLocal("CoreScripts/FacialAnimationStreaming", script.Parent)
end

ScriptContext:AddCoreScriptLocal("CoreScripts/AvatarMood", script.Parent)

ScriptContext:AddCoreScriptLocal("CoreScripts/PortalTeleportGUI", RobloxGui)

coroutine.wrap(function()
	local result2 = safeRequire(CorePackages.Workspace.Packages.AdsEudsa) -- inferred equivalent call

	if result2 and result2.starterScript then
		result2.starterScript()
	end
end)()

if game:GetEngineFeature("EnableAdGuiInteractivityControlRefactor") then
	coroutine.wrap(function()
		local result2 = safeRequire(CorePackages.Workspace.Packages.AdGuiInteractivity) -- inferred equivalent call

		if result2 and result2.starterScript then
			result2.starterScript()
		end
	end)()
end

coroutine.wrap(function()
	local result2 = safeRequire(CorePackages.Workspace.Packages.EnhancedVideo) -- inferred equivalent call

	if result2 and result2.starterScript then
		result2.starterScript()
	end
end)()

coroutine.wrap(function()
	local result2 = safeRequire(CorePackages.Workspace.Packages.InExperienceClickout) -- inferred equivalent call

	if result2 and result2.starterScript then
		result2.starterScript()
	end
end)()

if game:GetEngineFeature("EnableLuaAdPlayer") then
	safeRequire(CorePackages.Workspace.Packages.AdPlayer).init() -- inferred equivalent call
end

if game:GetEngineFeature("EnableVoiceAttention") then
	ScriptContext:AddCoreScriptLocal("CoreScripts/VoiceAttention", script.Parent)
end

if GetFFlagEnableSoundSessionTelemetry() then
	ScriptContext:AddCoreScriptLocal("CoreScripts/SoundTelemetry", script.Parent)
end

coroutine.wrap(safeRequire)(Modules.ApolloClient)

if isCharacterNameHandlerEnabled() then
	ScriptContext:AddCoreScriptLocal("CoreScripts/CharacterNameHandler", script.Parent)
end

if GetFFlagVoiceUserAgency3() then
	ScriptContext:AddCoreScriptLocal("CoreScripts/VoiceUserAgency", RobloxGui)
end

ScriptContext:AddCoreScriptLocal("CoreScripts/CoreScriptsGlobalEffects", script.Parent)

local SoundManager = require(CorePackages.Workspace.Packages.SoundManager)
SoundManager.SoundManager.init()

if GetFFlagEnableSocialContextToast() then
	ScriptContext:AddCoreScriptLocal("CoreScripts/SocialContextToast", RobloxGui)
end

ScriptContext:AddCoreScriptLocal("CoreScripts/GameInviteModalGUI", script.Parent)

if defineFastFlag6 then
	ScriptContext:AddCoreScriptLocal("CoreScripts/ExperienceNotifications", script.Parent)
end

local Achievements = require(CorePackages.Workspace.Packages.Achievements)
Achievements.InExpAchievementManager.new():startUp()

local GetFFlagPlayerViewRemoteEnabled = require(RobloxGui.Modules.Common.Flags.GetFFlagPlayerViewRemoteEnabled)

if GetFFlagPlayerViewRemoteEnabled() then
	ScriptContext:AddCoreScriptLocal("CoreScripts/PlayerView", RobloxGui)
end

if defineFastFlag5 then
	ScriptContext:AddCoreScriptLocal("CoreScripts/SendCameraAccessAnalytics", RobloxGui)
end

ScriptContext:AddCoreScriptLocal("CoreScripts/BulkPurchaseApp", RobloxGui)

if GetEngineFeatureEnablePromptRobuxTransfer() then
	ScriptContext:AddCoreScriptLocal("CoreScripts/InExperienceTransferApp", RobloxGui)
end

if engineFeature2 then
	ScriptContext:AddCoreScriptLocal("CoreScripts/ExperienceAudioFocusBinder", RobloxGui)
end

if engineFeature and defineFastFlag7 then
	ScriptContext:AddCoreScriptLocal("CoreScripts/CancelSubscriptionApp", RobloxGui)
end

if engineFeature3 then
	ScriptContext:AddCoreScriptLocal("CoreScripts/CommercePurchaseApp", RobloxGui)
end

if defineFastFlag10 then
	ScriptContext:AddCoreScriptLocal("CoreScripts/SystemScrim", RobloxGui)
end

ScriptContext:AddCoreScriptLocal("CoreScripts/CoreGuiEnableAnalytics", RobloxGui)

if defineFastFlag9 then
	ScriptContext:AddCoreScriptLocal("CoreScripts/OpenShareSheetWithLink", RobloxGui)
end

if FFlagEnableShareSheet then
	ScriptContext:AddCoreScriptLocal("CoreScripts/UniversalShareSheetScreenGui", RobloxGui)
end

if FFlagLuaAppInExperienceDetailsPrompt then
	ScriptContext:AddCoreScriptLocal("CoreScripts/InExperienceDetailsPrompt", RobloxGui)
end

if not defineFastFlag8 then
	coroutine.wrap(function()
		local GenericChallenges = require(CorePackages.Workspace.Packages.GenericChallenges)
		GenericChallenges.Middleware.InitExperienceChallengeInterceptor()
	end)()
end

local ReactPerfTracker = require(Modules.Common.ReactPerfTracker)

if ReactPerfTracker then
	local v4 = ReactPerfTracker.new()

	task.delay(5, function()
		v4:start()
	end)
end

local v4 = game:DefineFastInt("ReactSchedulingTrackerStartUpDelayMs", 5000) / 1000

local ReactSchedulingTracker = require(Modules.Common.ReactSchedulingTracker)

task.delay(v4, function()
	ReactSchedulingTracker:start()
end)

local Memory = require(CorePackages.Workspace.Packages.Memory)
Memory.start(true, FStringReactSchedulingContext, Memory.MemoryScope.InExperience)

if game:GetEngineFeature("RecordingServicePlaybackApiLua") then
	coroutine.wrap(safeRequire)(CorePackages.Workspace.Packages.ExperienceStateReplay)
end

if FFlagEnableAEGIS2CommsFAEUpsell then
	coroutine.wrap(function()
		local result2 = safeRequire(CorePackages.Workspace.Packages.SocialUpsell) -- inferred equivalent call

		if result2 then
			result2.Overlay.initializeInExpOverlay()
		end
	end)()
end

coroutine.wrap(function()
	local result2 = safeRequire(CorePackages.Workspace.Packages.Display) -- inferred equivalent call
	GuiService:GetPropertyChangedSignal("TopbarInset"):Connect(function()
		result2.GetDisplayStore().setTopBarHeight(GuiService.TopbarInset.Height)
	end)
end)()

if defineFastFlag12 then
	local CoreScriptsProfiler = require(CorePackages.Workspace.Packages.CoreScriptsProfiler)
	local coreScriptsProfilerTelemetry = CoreScriptsProfiler.CoreScriptsProfilerTelemetry

	if coreScriptsProfilerTelemetry then
		if not defineFastFlag13 then
			FStringReactSchedulingContext = nil
		end

		coreScriptsProfilerTelemetry(FStringReactSchedulingContext):start()
	end
end
