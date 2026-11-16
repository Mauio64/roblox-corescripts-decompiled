local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")

local ScriptContext = game:GetService("ScriptContext")
local NotificationService = game:GetService("NotificationService")

if require("@luauforge/bundled/a") then
	_G.__DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__ = true
end

if math.random(1, 9999) <= game:DefineFastInt("LuaAppEnableReactProfilerHundredthsPercent", 0) then
	_G.__PROFILE__ = true
end

if require("@luauforge/bundled/b") then
	local module = require("@luauforge/bundled/c")
	game:BindToClose(module())
else
	local v5 = if require("@luauforge/bundled/ijk") then require("@luauforge/bundled/ijl").start(coroutine.running()) else nil

	if require("@luauforge/bundled/ijn") then
		NotificationService.SelectedTheme = "dark"
	end

	local module = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol")

	module.default:logEventOnce("lua_app_starter_script_requires_begin")
	local discoveryAppLaunchTracker = require("@luauforge/bundled/hEX").DiscoveryAppLaunchTracker

	if discoveryAppLaunchTracker.isEnabled() then
		discoveryAppLaunchTracker.createDefault(module.default)
		module.default:setDurationLoggerListener(function(p2)
			discoveryAppLaunchTracker.default:onMilestoneChanged(p2)
		end)
		discoveryAppLaunchTracker.default:onMilestoneChanged("lua_app_starter_script_requires_begin")
	end

	local module2 = require("@luauforge/bundled/hWD")
	local defineFastInt = game:DefineFastInt("EnableSentryUARolloutPercentage", 0)

	if module2 and not UserSettings().GameSettings:InStudioMode() then
		local module3 = require("@luauforge/bundled/hVy")
		local module4 = require("@luauforge/bundled/hWq")
		local module5 = require("@luauforge/bundled/hWr")
		local module6 = require("@luauforge/bundled/hWE")
		local module7 = require("@luauforge/bundled/hWF")

		local fFlagDisableGoogleAnalyticsErrorReporting = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagDisableGoogleAnalyticsErrorReporting

		local v6 = nil
		local errorDetailed

		if module7() then
			errorDetailed = ScriptContext.ErrorDetailed
		else
			module6 = nil
		end

		if math.random(1, 100) <= math.clamp(defineFastInt, 0, 100) then
			errorDetailed = ScriptContext.ErrorDetailed
			v6 = module5
		end

		if module5 then
			module5:updateSharedAttributes({ before_legacy_reporter_init = true })
		end

		local v7 = module3.new(errorDetailed, nil, module6, module4.ERROR, v6)
		v7:setCurrentApp("LuaApp")

		if not fFlagDisableGoogleAnalyticsErrorReporting then
			v7:startQueueTimers()
		end
	end

	require("@luauforge/bundled/fBT").ExperimentCacheManager.default:initialize()

	local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
	local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild
	local soundManager = require("@luauforge/bundled/fyK").SoundManager
	RoactGamepad.Config.Enabled = not isVRAppBuild()

	local config = RoactGamepad.Config
	config.DebugKeyboardBindings = {
		[Enum.KeyCode.ButtonA] = { Enum.KeyCode.Space, Enum.KeyCode.Return },
		[Enum.KeyCode.ButtonB] = { Enum.KeyCode.Backspace, Enum.KeyCode.Escape }
	}

	local UIBlox = require(CorePackages.Packages.UIBlox)
	UIBlox.init(require("@luauforge/bundled/d"))

	if require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableCrossExpVoice() then
		require("@luauforge/bundled/fzn").IXPManager.default:initialize()
	end

	local module3 = require("@luauforge/bundled/ecR")
	local module4 = require("@luauforge/bundled/ijo")
	local module5 = require("@luauforge/bundled/hVy")
	local module6 = require("@luauforge/bundled/hWq")
	local module7 = require("@luauforge/bundled/hWr")
	local module8 = require("@luauforge/bundled/hWE")
	local module9 = require("@luauforge/bundled/n")
	local module10 = require("@luauforge/bundled/ijj")
	local module11 = require("@luauforge/bundled/ijv")
	local module12 = require("@luauforge/bundled/ijB")
	local module13 = require("@luauforge/bundled/ijC")
	local module14 = require("@luauforge/bundled/hWF")

	local fFlagDisableGoogleAnalyticsErrorReporting = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagDisableGoogleAnalyticsErrorReporting

	local IXPService = game:GetService("IXPService")
	local appUserLayers = require("@luauforge/bundled/dMA").AppUserLayers

	local getDefaultQualityLevel = require("@game/CorePackages/Workspace/Packages/AppCommonLib").GetDefaultQualityLevel

	local v7 = not module2 and math.random(1, 100) <= math.clamp(defineFastInt, 0, 100)

	local defineFastFlag = game:DefineFastFlag("DebugLuaAppThrowErrorInStarterScript", false)

	if not game:DefineFastFlag("GranularExportsBucket", false) then
		if not require("@luauforge/bundled/ijD") then
			require("@luauforge/bundled/hvI")
		end

		if not game:DefineFastFlag("LoginV2GranularExports", false) then
			require("@luauforge/bundled/ijE")
		end

		if not require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagGenericAbuseReportingGranularExports then
			require("@luauforge/bundled/hvX")
		end

		if not game:DefineFastFlag("SquadsGranularExports", false) then
			require("@luauforge/bundled/ijF")
			require("@luauforge/bundled/ijG")
		end

		if not game:DefineFastFlag("AppChatGranularExports", false) then
			require("@luauforge/bundled/ijL")
		end

		if not game:DefineFastFlag("FriendsLandingExports", false) then
			require("@luauforge/bundled/ile")
		end

		if not game:DefineFastFlag("EditProfileGranularExports", false) then
			require("@luauforge/bundled/gVI")
		end
	end

	module.default:logEventOnce("lua_app_starter_script_requires_end")

	if module2 and not UserSettings().GameSettings:InStudioMode() and module7 then
		module7:updateSharedAttributes({ before_legacy_reporter_init = false })
	end

	if not (module2 or UserSettings().GameSettings:InStudioMode()) then
		local v8 = nil
		local errorDetailed

		if module14() then
			errorDetailed = ScriptContext.ErrorDetailed
		else
			module8 = nil
		end

		if v7 then
			errorDetailed = ScriptContext.ErrorDetailed
			v8 = module7
		end

		local v9 = module5.new(errorDetailed, nil, module8, module6.ERROR, v8)

		v9:setCurrentApp("LuaApp")

		if not fFlagDisableGoogleAnalyticsErrorReporting then
			v9:startQueueTimers()
		end
	end

	require("@luauforge/bundled/ilg").initDataModelStreamWsClient()

	if defineFastFlag then
		error("This is a test error raised by FFlagDebugLuaAppThrowErrorInStarterScript")
	end

	module.default:logEventOnce("lua_app_starter_script_wait_for_player_begin")

	if game.Players.LocalPlayer == nil then
		game.Players.PlayerAdded:Wait()
	end

	module.default:logEventOnce("lua_app_starter_script_wait_for_player_end")

	local renderSteppedConnection = nil
	local RunService = game:GetService("RunService")
	renderSteppedConnection = RunService.RenderStepped:Connect(function()
		if renderSteppedConnection then
			renderSteppedConnection:Disconnect()
		end

		local settings_2 = settings()
		settings_2.Rendering.QualityLevel = getDefaultQualityLevel()
	end)

	module4.startup()

	if require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagInitializeSduiForApp then
		require("@luauforge/bundled/ilq")()
	end

	local v8 = module3.createElement(module9, { appName = "LuaApp" })

	if module10 then
		v8 = module3.createElement(module11, {}, { v8 })
	end

	module3.mount(v8, CoreGui, "App")

	if v5 then
		v5.markRootMounted()
	end

	if UserSettings().GameSettings:InStudioMode() then
		local registeredUserLayersToStatus = IXPService:GetRegisteredUserLayersToStatus()

		for k in appUserLayers do
			if not registeredUserLayersToStatus[appUserLayers[k]] then
				warn("IXP layer has not been registered: " .. appUserLayers[k])
			end
		end
	end

	if isVRAppBuild() then
		module12()
		module13()
	end

	soundManager.init()

	if
		require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagDebugForceConsoleSafeInsets
		and UserSettings().GameSettings:InStudioMode()
	then
		require("@luauforge/bundled/dUd").GetDisplayStore().forceConsoleSafeInsets()
	end

	if require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAvatarJointUpgradeInUA then
		local Thumbnailing = require(CorePackages.Packages.Thumbnailing)

		if Thumbnailing.EmoteUtility.EmoteUtilitySupportAJU then
			local StarterPlayer = game:GetService("StarterPlayer")
			StarterPlayer.AvatarJointUpgrade = Enum.RolloutState.Enabled
		end
	end

	local defineFastFlag2 = game:DefineFastFlag("EnableCorescriptTrackerForLuaApp", false)
	local module15 = require("@luauforge/bundled/ilS")

	if defineFastFlag2 then
		module15.start(true, nil, module15.MemoryScope.UniversalApp)
	else
		module15.start(false)
	end

	module.default:logEventOnce("lua_app_starter_script_end")
end
