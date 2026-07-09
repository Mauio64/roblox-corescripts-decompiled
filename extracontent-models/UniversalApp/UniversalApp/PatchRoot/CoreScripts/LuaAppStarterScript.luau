local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local ScriptContext = game:GetService("ScriptContext")
local NotificationService = game:GetService("NotificationService")

if require(Modules.LuaApp.Flags.FFlagDebugLuaAppValidateProps) then
	_G.__DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__ = true
end

if math.random(1, 9999) <= game:DefineFastInt("LuaAppEnableReactProfilerHundredthsPercent", 0) then
	_G.__PROFILE__ = true
end

if require(Modules.LuaApp.Navigation.FFlagClosedStartupSequence) then
	local createUniversalApp = require(Modules.LuaApp.Navigation.createUniversalApp)

	game:BindToClose(createUniversalApp())

	return
end

if require(CorePackages.Workspace.Packages.SharedFlags).FFlagReactTelemetryEnabled then
	require(CorePackages.Packages.ReactTelemetry).customFields.context = "universal_app"
end

if require(Modules.LuaApp.Flags.FFlagDebugLuaAppsUseDarkTheme) then
	NotificationService.SelectedTheme = "dark"
end

local LoggingProtocol = require(CorePackages.Workspace.Packages.LoggingProtocol)

LoggingProtocol.default:logEventOnce("lua_app_starter_script_requires_begin")

local DiscoveryAppLaunchTracker = require(CorePackages.Workspace.Packages.AppLaunchTracker).DiscoveryAppLaunchTracker

if DiscoveryAppLaunchTracker.isEnabled() then
	DiscoveryAppLaunchTracker.createDefault(LoggingProtocol.default)
	LoggingProtocol.default:setDurationLoggerListener(function(s1: string) -- line: 47
		-- upvalues: DiscoveryAppLaunchTracker (copy)
		DiscoveryAppLaunchTracker.default:onMilestoneChanged(s1)
	end)
	DiscoveryAppLaunchTracker.default:onMilestoneChanged("lua_app_starter_script_requires_begin")
end

require(CorePackages.Workspace.Packages.ExperimentCacheManager).ExperimentCacheManager.default:initialize()

local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local IsVRAppBuild = require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild
local SoundManager = require(CorePackages.Workspace.Packages.SoundManager).SoundManager

RoactGamepad.Config.Enabled = not IsVRAppBuild()
RoactGamepad.Config.DebugKeyboardBindings = {
	[Enum.KeyCode.ButtonA] = {
		Enum.KeyCode.Space,
		Enum.KeyCode.Return
	},
	[Enum.KeyCode.ButtonB] = {
		Enum.KeyCode.Backspace,
		Enum.KeyCode.Escape
	}
}
require(CorePackages.Packages.UIBlox).init(require(CorePackages.Workspace.Packages.RobloxAppUIBloxConfig))

if require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableCrossExpVoice() then
	require(CorePackages.Workspace.Packages.CrossExperienceVoice).IXPManager.default:initialize()
end

local Roact = require(Modules.Common.Roact)
local ReactSchedulerManager = require(CorePackages.Workspace.Packages.ReactSchedulerManager)
local LuaErrorReporter = require(Modules.Common.LuaErrorReporter)
local LuaErrorSeverity = require(Modules.Common.LuaErrorSeverity)
local LuaAppSentryReporter = require(Modules.LuaApp.LuaAppSentryReporter)
local LuaAppBacktraceReporter = require(Modules.LuaApp.LuaAppBacktraceReporter)
local UniversalApp = require(Modules.LuaApp.Components.UniversalApp)
local targetFramerateSetup = require(Modules.LuaApp.Util.targetFramerateSetup)
local setUpVRRecenterOnResume = require(Modules.LuaApp.Util.setUpVRRecenterOnResume)
local GetIsClientEnrolledInBacktraceRollout = require(Modules.LuaApp.Flags.GetIsClientEnrolledInBacktraceRollout)
local FFlagDisableGoogleAnalyticsErrorReporting = require(CorePackages.Workspace.Packages.SharedFlags).FFlagDisableGoogleAnalyticsErrorReporting
local IXPService = game:GetService("IXPService")
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local GetDefaultQualityLevel = require(CorePackages.Workspace.Packages.AppCommonLib).GetDefaultQualityLevel
local v26 = game:DefineFastInt("EnableSentryUARolloutPercentage", 0)
local v27 = math.random(1, 100) <= math.clamp(v26, 0, 100)
local v28 = game:DefineFastFlag("DebugLuaAppThrowErrorInStarterScript", false)

if not game:DefineFastFlag("GranularExportsBucket", false) then
	if not require(Modules.LuaApp.Flags.FFlagProfilePlatformGranularExports) then
		require(CorePackages.Workspace.Packages.ProfilePlatform)
	end

	if not game:DefineFastFlag("LoginV2GranularExports", false) then
		require(CorePackages.Workspace.Packages.LoginV2)
	end

	if not require(CorePackages.Workspace.Packages.SharedFlags).FFlagGenericAbuseReportingGranularExports then
		require(CorePackages.Workspace.Packages.GenericAbuseReporting)
	end

	if not game:DefineFastFlag("SquadsGranularExports", false) then
		require(CorePackages.Workspace.Packages.Squads)
		require(CorePackages.Workspace.Packages.SquadsCore)
	end

	if not game:DefineFastFlag("AppChatGranularExports", false) then
		require(CorePackages.Workspace.Packages.AppChat)
	end

	if not game:DefineFastFlag("FriendsLandingExports", false) then
		require(CorePackages.Workspace.Packages.FriendsLanding)
	end

	if not game:DefineFastFlag("EditProfileGranularExports", false) then
		require(CorePackages.Workspace.Packages.EditProfile)
	end
end

LoggingProtocol.default:logEventOnce("lua_app_starter_script_requires_end")

if not UserSettings().GameSettings:InStudioMode() then
	local v29 = nil
	local ErrorDetailed = nil
	local v31 = nil

	if GetIsClientEnrolledInBacktraceRollout() then
		v29 = LuaAppBacktraceReporter
		ErrorDetailed = ScriptContext.ErrorDetailed
	end

	if v27 then
		v31 = LuaAppSentryReporter
		ErrorDetailed = ScriptContext.ErrorDetailed
	end

	local v32 = LuaErrorReporter.new(ErrorDetailed, nil, v29, LuaErrorSeverity.ERROR, v31)

	v32:setCurrentApp("LuaApp")

	if not FFlagDisableGoogleAnalyticsErrorReporting then
		v32:startQueueTimers()
	end
end

require(CorePackages.Workspace.Packages.DataModelStreaming).initDataModelStreamWsClient()

if v28 then
	error("This is a test error raised by FFlagDebugLuaAppThrowErrorInStarterScript")
end

LoggingProtocol.default:logEventOnce("lua_app_starter_script_wait_for_player_begin")

if game.Players.LocalPlayer == nil then
	game.Players.PlayerAdded:Wait()
end

LoggingProtocol.default:logEventOnce("lua_app_starter_script_wait_for_player_end")

local connection = nil

connection = game:GetService("RunService").RenderStepped:Connect(function() -- line: 186
	-- upvalues: connection (ref), GetDefaultQualityLevel (copy)
	if connection then
		connection:Disconnect()
	end

	settings().Rendering.QualityLevel = GetDefaultQualityLevel()
end)
ReactSchedulerManager.startup()

local v34 = Roact.createElement(UniversalApp, {
	appName = "LuaApp"
})

Roact.mount(v34, CoreGui, "App")

if UserSettings().GameSettings:InStudioMode() then
	local RegisteredUserLayersToStatus = IXPService:GetRegisteredUserLayersToStatus()

	for v36 in AppUserLayers do
		if not RegisteredUserLayersToStatus[AppUserLayers[v36]] then
			warn("IXP layer has not been registered: " .. AppUserLayers[v36])
		end
	end
end

if IsVRAppBuild() then
	targetFramerateSetup()
	setUpVRRecenterOnResume()
end

SoundManager.init()

if require(CorePackages.Workspace.Packages.SharedFlags).FFlagDebugForceConsoleSafeInsets and UserSettings().GameSettings:InStudioMode() then
	require(CorePackages.Workspace.Packages.Display).GetDisplayStore().forceConsoleSafeInsets()
end

if require(CorePackages.Workspace.Packages.SharedFlags).FFlagAvatarJointUpgradeInUA and require(CorePackages.Packages.Thumbnailing).EmoteUtility.EmoteUtilitySupportAJU then
	game:GetService("StarterPlayer").AvatarJointUpgrade = Enum.RolloutState.Enabled
end

local v37 = game:DefineFastFlag("EnableCorescriptTrackerForLuaApp", false)
local Memory = require(CorePackages.Workspace.Packages.Memory)

if v37 then
	Memory.start(true, nil, Memory.MemoryScope.UniversalApp)
else
	Memory.start(false)
end

LoggingProtocol.default:logEventOnce("lua_app_starter_script_end")
