local CorePackages = game:GetService("CorePackages")
local ScriptContext = game:GetService("ScriptContext")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local VRService = game:GetService("VRService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
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
local GetFFlagReportAnythingAnnotationIXP = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagReportAnythingAnnotationIXP
local TrustAndSafetyIXPManager = require(CorePackages.Workspace.Packages.TrustAndSafetyIxp).TrustAndSafetyIXPManager
local GetCoreScriptsLayers = require(Modules.Experiment.GetCoreScriptsLayers)
local GetFFlagRtMessaging = require(RobloxGui.Modules.Flags.GetFFlagRtMessaging)
local v22 = game:DefineFastFlag("AddPublishAssetPrompt6", false)
local v23 = game:DefineFastFlag("EnablePromptAgeCheckListener", false)
local isCharacterNameHandlerEnabled = require(CorePackages.Workspace.Packages.SharedFlags).isCharacterNameHandlerEnabled
local GetFFlagEnableSocialContextToast = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableSocialContextToast
local GetFFlagEnableAppChatInExperience = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableAppChatInExperience
local GetFFlagChromeCentralizedConfiguration = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagChromeCentralizedConfiguration
local GetFFlagEnableCrossExpVoice = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableCrossExpVoice
local FStringReactSchedulingContext = require(CorePackages.Workspace.Packages.SharedFlags).FStringReactSchedulingContext
local v30 = game:DefineFastFlag("LuaAppEnableToastNotificationsCoreScripts4", false)
local v31 = game:DefineFastFlag("DisableLuobuWarningToast", false)
local GetFFlagVoiceUserAgency3 = require(RobloxGui.Modules.Flags.GetFFlagVoiceUserAgency3)
local GetFFlagLuaInExperienceCoreScriptsGameInviteUnification = require(RobloxGui.Modules.Flags.GetFFlagLuaInExperienceCoreScriptsGameInviteUnification)
local v34 = game:DefineFastFlag("EnableSendCameraAccessAnalytics", false)
local v35 = game:DefineFastFlag("EnableExperienceNotificationPrompts2", false)
local EngineFeature = game:GetEngineFeature("EnableCancelSubscriptionApp")
local v37 = game:DefineFastFlag("EnableCancelSubscriptionAppLua", false)
local EngineFeature2 = game:GetEngineFeature("AudioFocusManagement")
local v39 = game:DefineFastFlag("EnableExperienceGenericChallengeRenderingOnLoadingScript", false)
local EngineFeature3 = game:GetEngineFeature("EnableRobloxCommerce")
local v41 = game:DefineFastFlag("EnableLinkSharingEvent", false)
local FFlagEnableShareSheet = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableShareSheet
local EngineFeature4 = game:GetEngineFeature("PlayerFeedbackEnabled")
local FFlagLuaAppInExperienceDetailsPrompt = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppInExperienceDetailsPrompt
local v45 = game:DefineFastFlag("EnableSystemScrim", false)
local v46 = game:DefineFastFlag("EnableCoreUISystemV2", false)
local FFlagEnableNewBackpack = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableNewBackpack
local v48 = game:DefineFastFlag("EnableCorescriptsProfiler", false)
local v49 = game:DefineFastFlag("CoreScriptsProfilerTelemetryContext", false)
local v50 = game:DefineFastFlag("SelfieFrontendConsoleDesktop3", false) and game:GetEngineFeature("EnableSelfieQRCode")
local GetEngineFeatureEnablePromptRobuxTransfer = require(CorePackages.Workspace.Packages.SharedFlags).GetEngineFeatureEnablePromptRobuxTransfer
local UIBlox = require(CorePackages.Packages.UIBlox)
local UIBloxInGameConfig = require(CorePackages.Workspace.Packages.CoreScriptsInitializer).UIBloxInGameConfig

UIBlox.init(UIBloxInGameConfig)

if v46 then
	require(CorePackages.Workspace.Packages.System)
end

local FFlagTopBarRefactor = require(CorePackages.Workspace.Packages.InExperienceTopBar).Flags.FFlagTopBarRefactor

require(CorePackages.Workspace.Packages.ExperimentCacheManager).ExperimentCacheManager.default:initialize()

if require(CorePackages.Workspace.Packages.SharedFlags).FFlagReactTelemetryEnabled then
	require(CorePackages.Packages.ReactTelemetry).customFields.context = "in_experience"
end

if game:DefineFastFlag("LuaAppUseAppHttpStoreInExperience", false) then
	require(CorePackages.Workspace.Packages.HttpStore).Instance._create({})
end

local v55 = require(CorePackages.Workspace.Packages.SharedFlags).GetReactSchedulerIXPConfig()

if v55 then
	Scheduler.unstable_setSchedulerFlags(v55)
end

if require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableSchedulerFlagOverrides then
	local v56 = require(CorePackages.Workspace.Packages.SharedFlags).GetSchedulerFlagOverrides.getInExp()

	if v56 then
		Scheduler.unstable_setSchedulerFlags(v56)
	end
end

local FFlagEnableAEGIS2CommsFAEUpsell = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableAEGIS2CommsFAEUpsell
local LocalPlayer = Players.LocalPlayer

while not LocalPlayer do
	Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
	LocalPlayer = Players.LocalPlayer
end

if game:GetEngineFeature("SoundServiceControlsDefaultListenerLocation") then
	ScriptContext:AddCoreScriptLocal("CoreScripts/DefaultListenerLocation", script.Parent)
end

if GetFFlagEnableAppChatInExperience() then
	ScriptContext:AddCoreScriptLocal("CoreScripts/AppChatMain", RobloxGui)
end

if GetFFlagEnableCrossExpVoice() then
	require(CorePackages.Workspace.Packages.CrossExperienceVoice).IXPManager.default:initialize()
end

require(CorePackages.Workspace.Packages.InExperienceSessionization)

if require(CorePackages.Workspace.Packages.Chrome).Enabled() then
	local ExpChat = require(CorePackages.Workspace.Packages.ExpChat)

	ExpChat.GlobalFlags.AvatarChatEnabled = false
	ExpChat.GlobalFlags.ChromeEnabled = true
end

if require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagJoinWithoutMicPermissions() then
	require(CorePackages.Workspace.Packages.ExpChat).GlobalFlags.JoinWithoutMicPermissions = true
end

local v60 = game:DefineFastFlag("InExperienceInterventionApp", false)
local FFlagLuaAppEnableInExperienceDataModelStreamStarter = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEnableInExperienceDataModelStreamStarter

if FFlagUseRoactGlobalConfigInCoreScripts and RunService:IsStudio() then
	Roact.setGlobalConfig({
		propValidation = true,
		elementTracing = true
	})
end

local UIBlox2 = require(CorePackages.Packages.InGameMenuDependencies).UIBlox

if UIBlox2 ~= UIBlox then
	UIBlox2.init(UIBloxInGameConfig)
end

local Folder = Instance.new("Folder")

Folder.Name = "Sounds"
Folder.Parent = RobloxGui

local function safeRequire(p1) -- line: 192
	local ok, result = pcall(require, p1)

	if ok then
		return result
	end

	warn("Failure to Start CoreScript module " .. p1.Name .. ".\n" .. result)
end

ScriptContext:AddCoreScriptLocal("CoreScripts/NotificationScript2", RobloxGui)

if FFlagLuaAppEnableInExperienceDataModelStreamStarter then
	ScriptContext:AddCoreScriptLocal("CoreScripts/InExperienceDataModelStreamStarter", script.Parent)
end

if game:GetEngineFeature("ProtocolLaunchPrivateChannelUpdateCheckEngineFeature") then
	local ChannelUpdatePrompt = Modules.ChannelUpdatePrompt
	local ok, result = pcall(require, ChannelUpdatePrompt)

	if ok then
	else
		warn("Failure to Start CoreScript module " .. ChannelUpdatePrompt.Name .. ".\n" .. result)
		result = nil
	end

	if result then
		result.init()
	end
end

if GetFFlagChromeCentralizedConfiguration() then
	coroutine.wrap(safeRequire)(Modules.Chrome.ConfigureChrome)
end

coroutine.wrap(safeRequire)(Modules.SelfieView)
coroutine.wrap(safeRequire)(Modules.TopBar)

if require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableSideSheet then
	coroutine.wrap(safeRequire)(Modules.InExperienceSideSheet)
end

if require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableWhatsNew then
	coroutine.wrap(safeRequire)(Modules.InGameWhatsNew)
end

if require(CorePackages.Workspace.Packages.SharedFlags).FFlagAppNavMyStatsTab then
	local v68 = coroutine.wrap(safeRequire)(CorePackages.Workspace.Packages.BuildExperience)
	local v69 = v68 and v68.BuildModeLaunch:hasBuildMode()

	if v68 then
		v68.mountCreatorAgentResumeToastReceiver(v69 == true)
	end

	if v68 and v69 then
		game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
		v68.mountBuildControls()
		v68.mountChatSheet()
		v68.mountPublishGameSheet()
	end
end

if FFlagTopBarRefactor then
	local v70 = coroutine.wrap(safeRequire)(CorePackages.Workspace.Packages.InExperienceOverlay)

	if v70 then
		v70.createOverlay()
	end
end

if game:GetEngineFeature("LuobuModerationStatus") then
	coroutine.wrap(function() -- line: 263
		-- upvalues: Modules (copy)
		local Watermark = Modules.Watermark
		local ok, result = pcall(require, Watermark)

		if ok then
			return
		end

		warn("Failure to Start CoreScript module " .. Watermark.Name .. ".\n" .. result)
	end)()
end

if v60 then
	coroutine.wrap(safeRequire)(CorePackages.Workspace.Packages.InExperienceIntervention)
end

ScriptContext:AddCoreScriptLocal("CoreScripts/MainBotChatScript2", RobloxGui)

if game:GetEngineFeature("ProximityPrompts") then
	ScriptContext:AddCoreScriptLocal("CoreScripts/ProximityPrompt", RobloxGui)
end

if game:GetEngineFeature("ValidateUGCBodyAPIFeature") then
	require(Modules.Server.UGCValidation.UGCValidationFunctionInstaller)()
end

coroutine.wrap(function() -- line: 284
	-- upvalues: ScriptContext (copy), RobloxGui (copy)
	ScriptContext:AddCoreScriptLocal("CoreScripts/ScreenTimeInGame", RobloxGui)
end)()

if not v31 then
	coroutine.wrap(function() -- line: 289
		-- upvalues: CachedPolicyService (copy), Modules (copy)
		if CachedPolicyService:IsSubjectToChinaPolicies() then
			if not game:IsLoaded() then
				game.Loaded:Wait()
			end

			local LuobuWarningToast = Modules.LuobuWarningToast
			local ok, result = pcall(require, LuobuWarningToast)

			if ok then
				return
			end

			warn("Failure to Start CoreScript module " .. LuobuWarningToast.Name .. ".\n" .. result)
		end
	end)()
end

ScriptContext:AddCoreScriptLocal("CoreScripts/PerformanceStatsManagerScript", RobloxGui)
ScriptContext:AddCoreScriptLocal("CoreScripts/PlayerRagdoll", RobloxGui)
coroutine.wrap(safeRequire)(RobloxGui.Modules.ChatSelector)
coroutine.wrap(safeRequire)(RobloxGui.Modules.PlayerList.PlayerListManager)

local ok, result = pcall(function() -- line: 311
	return UserSettings():IsUserFeatureEnabled("UserRoactBubbleChatBeta")
end)
local v73 = ok and result

if game:GetEngineFeature("EnableBubbleChatFromChatService") or v73 then
	ScriptContext:AddCoreScriptLocal("CoreScripts/PlayerBillboards", RobloxGui)
end

coroutine.wrap(function() -- line: 322
	-- upvalues: CorePackages (copy)
	local PurchasePrompt = CorePackages.Workspace.Packages.PurchasePrompt
	local ok2, result2 = pcall(require, PurchasePrompt)

	if ok2 then
	else
		warn("Failure to Start CoreScript module " .. PurchasePrompt.Name .. ".\n" .. result2)
		result2 = nil
	end

	if result2 then
		result2.mountPurchasePrompt()
	end
end)()

if v22 then
	coroutine.wrap(safeRequire)(Modules.PublishAssetPrompt)
end

coroutine.wrap(safeRequire)(Modules.ExperienceEvents.ExperienceEventsApp)

if EngineFeature4 then
	coroutine.wrap(safeRequire)(Modules.PlayerFeedback)
end

coroutine.wrap(safeRequire)(Modules.Groups.GroupsApp)
coroutine.wrap(safeRequire)(Modules.AvatarGeneration.SelfieConsent)

if v50 then
	coroutine.wrap(safeRequire)(Modules.AvatarGeneration.SelfieQr)
end

ScriptContext:AddCoreScriptLocal("CoreScripts/BlockPlayerPrompt", RobloxGui)
ScriptContext:AddCoreScriptLocal("CoreScripts/FriendPlayerPrompt", RobloxGui)

if v23 then
	local PromptAgeCheckHandler = Modules.PromptAgeCheckHandler
	local ok3, result3 = pcall(require, PromptAgeCheckHandler)

	if ok3 then
	else
		warn("Failure to Start CoreScript module " .. PromptAgeCheckHandler.Name .. ".\n" .. result3)
		result3 = nil
	end

	if result3 then
		result3.init()
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

if require(CorePackages.Workspace.Packages.SharedFlags).FFlagVirtualCursorModularization then
	coroutine.wrap(safeRequire)(CorePackages.Workspace.Packages.VirtualCursorModular)
else
	coroutine.wrap(safeRequire)(CorePackages.Workspace.Packages.VirtualCursor)
end

ScriptContext:AddCoreScriptLocal("CoreScripts/VehicleHud", RobloxGui)
ScriptContext:AddCoreScriptLocal("CoreScripts/InviteToGamePrompt", RobloxGui)

if if not game:GetEngineFeature("TouchScreenEnabled") then UserInputService.TouchEnabled else UserInputService.TouchScreenEnabled then
	ScriptContext:AddCoreScriptLocal("CoreScripts/ContextActionTouch", RobloxGui)
	RobloxGui:WaitForChild("ControlFrame")
	RobloxGui.ControlFrame:WaitForChild("BottomLeftControl")
	RobloxGui.ControlFrame.BottomLeftControl.Visible = false
end

ScriptContext:AddCoreScriptLocal("CoreScripts/InspectAndBuy", RobloxGui)
coroutine.wrap(function() -- line: 408
	-- upvalues: VRService (copy), RobloxGui (copy)
	if not VRService.VREnabled then
		VRService:GetPropertyChangedSignal("VREnabled"):Wait()
	end

	local VRAvatarHeightScaling = RobloxGui.Modules.VR.VRAvatarHeightScaling
	local ok4, result4 = pcall(require, VRAvatarHeightScaling)

	if not ok4 then
		warn("Failure to Start CoreScript module " .. VRAvatarHeightScaling.Name .. ".\n" .. result4)
	end

	local VirtualKeyboard = RobloxGui.Modules.VR.VirtualKeyboard
	local ok5, result5 = pcall(require, VirtualKeyboard)

	if not ok5 then
		warn("Failure to Start CoreScript module " .. VirtualKeyboard.Name .. ".\n" .. result5)
	end

	local UserGui = RobloxGui.Modules.VR.UserGui
	local ok6, result6 = pcall(require, UserGui)

	if ok6 then
		return
	end

	warn("Failure to Start CoreScript module " .. UserGui.Name .. ".\n" .. result6)
end)()
coroutine.wrap(safeRequire)(RobloxGui.Modules.VR.VRAvatarGestures.VRAvatarGesturesClient)
ScriptContext:AddCoreScriptLocal("CoreScripts/NetworkPause", RobloxGui)

if GetFFlagScreenshotHudApi() and not CachedPolicyService:IsSubjectToChinaPolicies() then
	ScriptContext:AddCoreScriptLocal("CoreScripts/ScreenshotHud", RobloxGui)
end

ScriptContext:AddCoreScriptLocal("CoreScripts/MicrophoneDevicePermissionsLoggingInitializer", RobloxGui)

if game:GetEngineFeature("VoiceChatSupported") then
	ScriptContext:AddCoreScriptLocal("CoreScripts/VoiceDefaultChannel", RobloxGui)
end

coroutine.wrap(function() -- line: 431
	-- upvalues: CorePackages (copy), LocalPlayer (ref), GetCoreScriptsLayers (copy), GetFFlagEnableNewInviteMenuIXP (copy), NewInviteMenuExperimentManager (copy), GetFFlagReportAnythingAnnotationIXP (copy), TrustAndSafetyIXPManager (copy)
	require(CorePackages.Workspace.Packages.IxpServiceWrapper).IXPServiceWrapper:InitializeAsync(LocalPlayer.UserId, GetCoreScriptsLayers())

	if GetFFlagEnableNewInviteMenuIXP() then
		NewInviteMenuExperimentManager.default:initialize()
	end

	if GetFFlagReportAnythingAnnotationIXP() then
		TrustAndSafetyIXPManager.default:initialize()
	end
end)()
ScriptContext:AddCoreScriptLocal("CoreScripts/ExperienceChatMain", RobloxGui)
ScriptContext:AddCoreScriptLocal("CoreScripts/ChatEmoteUsage", script.Parent)

if v30 then
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
coroutine.wrap(function() -- line: 464
	-- upvalues: CorePackages (copy)
	local AdsEudsa = CorePackages.Workspace.Packages.AdsEudsa
	local ok7, result7 = pcall(require, AdsEudsa)

	if ok7 then
	else
		warn("Failure to Start CoreScript module " .. AdsEudsa.Name .. ".\n" .. result7)
		result7 = nil
	end

	if result7 and result7.starterScript then
		result7.starterScript()
	end
end)()

if game:GetEngineFeature("EnableAdGuiInteractivityControlRefactor") then
	coroutine.wrap(function() -- line: 473
		-- upvalues: CorePackages (copy)
		local AdGuiInteractivity = CorePackages.Workspace.Packages.AdGuiInteractivity
		local ok8, result8 = pcall(require, AdGuiInteractivity)

		if ok8 then
		else
			warn("Failure to Start CoreScript module " .. AdGuiInteractivity.Name .. ".\n" .. result8)
			result8 = nil
		end

		if result8 and result8.starterScript then
			result8.starterScript()
		end
	end)()
end

coroutine.wrap(function() -- line: 481
	-- upvalues: CorePackages (copy)
	local EnhancedVideo = CorePackages.Workspace.Packages.EnhancedVideo
	local ok9, result9 = pcall(require, EnhancedVideo)

	if ok9 then
	else
		warn("Failure to Start CoreScript module " .. EnhancedVideo.Name .. ".\n" .. result9)
		result9 = nil
	end

	if result9 and result9.starterScript then
		result9.starterScript()
	end
end)()
coroutine.wrap(function() -- line: 489
	-- upvalues: CorePackages (copy)
	local InExperienceClickout = CorePackages.Workspace.Packages.InExperienceClickout
	local ok10, result10 = pcall(require, InExperienceClickout)

	if ok10 then
	else
		warn("Failure to Start CoreScript module " .. InExperienceClickout.Name .. ".\n" .. result10)
		result10 = nil
	end

	if result10 and result10.starterScript then
		result10.starterScript()
	end
end)()

if game:GetEngineFeature("EnableLuaAdPlayer") then
	local AdPlayer = CorePackages.Workspace.Packages.AdPlayer
	local ok11, result11 = pcall(require, AdPlayer)

	if ok11 then
	else
		warn("Failure to Start CoreScript module " .. AdPlayer.Name .. ".\n" .. result11)
		result11 = nil
	end

	result11.init()
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
require(CorePackages.Workspace.Packages.SoundManager).SoundManager.init()

if GetFFlagEnableSocialContextToast() then
	ScriptContext:AddCoreScriptLocal("CoreScripts/SocialContextToast", RobloxGui)
end

if GetFFlagLuaInExperienceCoreScriptsGameInviteUnification() then
	ScriptContext:AddCoreScriptLocal("CoreScripts/GameInviteModalGUI", script.Parent)
end

if v35 then
	ScriptContext:AddCoreScriptLocal("CoreScripts/ExperienceNotifications", script.Parent)
end

require(CorePackages.Workspace.Packages.Achievements).InExpAchievementManager.new():startUp()

if require(RobloxGui.Modules.Common.Flags.GetFFlagPlayerViewRemoteEnabled)() then
	ScriptContext:AddCoreScriptLocal("CoreScripts/PlayerView", RobloxGui)
end

if v34 then
	ScriptContext:AddCoreScriptLocal("CoreScripts/SendCameraAccessAnalytics", RobloxGui)
end

ScriptContext:AddCoreScriptLocal("CoreScripts/BulkPurchaseApp", RobloxGui)

if GetEngineFeatureEnablePromptRobuxTransfer() then
	ScriptContext:AddCoreScriptLocal("CoreScripts/InExperienceTransferApp", RobloxGui)
end

if EngineFeature2 then
	ScriptContext:AddCoreScriptLocal("CoreScripts/ExperienceAudioFocusBinder", RobloxGui)
end

if EngineFeature and v37 then
	ScriptContext:AddCoreScriptLocal("CoreScripts/CancelSubscriptionApp", RobloxGui)
end

if EngineFeature3 then
	ScriptContext:AddCoreScriptLocal("CoreScripts/CommercePurchaseApp", RobloxGui)
end

if v45 then
	ScriptContext:AddCoreScriptLocal("CoreScripts/SystemScrim", RobloxGui)
end

ScriptContext:AddCoreScriptLocal("CoreScripts/CoreGuiEnableAnalytics", RobloxGui)

if v41 then
	ScriptContext:AddCoreScriptLocal("CoreScripts/OpenShareSheetWithLink", RobloxGui)
end

if FFlagEnableShareSheet then
	ScriptContext:AddCoreScriptLocal("CoreScripts/UniversalShareSheetScreenGui", RobloxGui)
end

if FFlagLuaAppInExperienceDetailsPrompt then
	ScriptContext:AddCoreScriptLocal("CoreScripts/InExperienceDetailsPrompt", RobloxGui)
end

if not v39 then
	coroutine.wrap(function() -- line: 590
		-- upvalues: CorePackages (copy)
		require(CorePackages.Workspace.Packages.GenericChallenges).Middleware.InitExperienceChallengeInterceptor()
	end)()
end

local ReactPerfTracker = require(Modules.Common.ReactPerfTracker)

if ReactPerfTracker then
	local v81 = ReactPerfTracker.new()

	task.delay(5, function() -- line: 601
		-- upvalues: v81 (copy)
		v81:start()
	end)
end

local v82 = game:DefineFastInt("ReactSchedulingTrackerStartUpDelayMs", 5000) / 1000
local ReactSchedulingTracker = require(Modules.Common.ReactSchedulingTracker)

task.delay(v82, function() -- line: 611
	-- upvalues: ReactSchedulingTracker (copy)
	ReactSchedulingTracker:start()
end)

local Memory = require(CorePackages.Workspace.Packages.Memory)

Memory.start(true, FStringReactSchedulingContext, Memory.MemoryScope.InExperience)

if game:GetEngineFeature("RecordingServicePlaybackApiLua") then
	coroutine.wrap(safeRequire)(CorePackages.Workspace.Packages.ExperienceStateReplay)
end

if FFlagEnableAEGIS2CommsFAEUpsell then
	coroutine.wrap(function() -- line: 623
		-- upvalues: CorePackages (copy)
		local SocialUpsell = CorePackages.Workspace.Packages.SocialUpsell
		local ok12, result12 = pcall(require, SocialUpsell)

		if ok12 then
		else
			warn("Failure to Start CoreScript module " .. SocialUpsell.Name .. ".\n" .. result12)
			result12 = nil
		end

		if result12 then
			result12.Overlay.initializeInExpOverlay()
		end
	end)()
end

coroutine.wrap(function() -- line: 631
	-- upvalues: CorePackages (copy), GuiService (copy)
	local Display = CorePackages.Workspace.Packages.Display
	local ok13, result13 = pcall(require, Display)

	if ok13 then
	else
		warn("Failure to Start CoreScript module " .. Display.Name .. ".\n" .. result13)
		result13 = nil
	end

	local v126 = result13

	GuiService:GetPropertyChangedSignal("TopbarInset"):Connect(function() -- line: 633
		-- upvalues: v126 (copy), GuiService (copy)
		v126.GetDisplayStore().setTopBarHeight(GuiService.TopbarInset.Height)
	end)
end)()

if v48 then
	local CoreScriptsProfilerTelemetry = require(CorePackages.Workspace.Packages.CoreScriptsProfiler).CoreScriptsProfilerTelemetry

	if CoreScriptsProfilerTelemetry then
		local v86 = nil

		if v49 then
			v86 = FStringReactSchedulingContext
		end

		CoreScriptsProfilerTelemetry(v86):start()
	end
end
