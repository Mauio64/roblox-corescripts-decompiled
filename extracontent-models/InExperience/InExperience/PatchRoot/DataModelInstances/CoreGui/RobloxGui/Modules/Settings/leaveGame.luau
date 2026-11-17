local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local Players = game:GetService("Players")

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableGameLeftMessage = SharedFlags.FFlagEnableGameLeftMessage
local FFlagSurvBloxEventTypeEnabled = SharedFlags.FFlagSurvBloxEventTypeEnabled
local engineFeature = game:GetEngineFeature("RbxAnalyticsServiceExposePlaySessionId")
local isExitModalRemoved = require(RobloxGui.Modules.Settings.Flags.isExitModalRemoved)

local VoiceChatCore = require(CorePackages.Workspace.Packages.VoiceChatCore)
local fFlagVoiceVolumeControlsEnableVoiceVolumeImpressionsTelemetry = VoiceChatCore.Flags.GetFFlagVoiceVolumeControlsEnableVoiceVolumeImpressionsTelemetry()

local PerfUtils = require(RobloxGui.Modules.Common.PerfUtils)
local Cryo = require(CorePackages.Packages.Cryo)
local MessageBus = require(CorePackages.Workspace.Packages.MessageBus)
local messageBus = MessageBus.MessageBus
local ExperienceService = require(CorePackages.Workspace.Packages.ExperienceService)
local experienceService = ExperienceService.ExperienceService
local SurveyEventPublisher = require(CorePackages.Workspace.Packages.OnPlatformSurveys.SurveyEventPublisher)
local WebViewEventType = require(CorePackages.Workspace.Packages.OnPlatformSurveys.WebViewEventType)
local CoreGuiFinalStateAnalytics = require(script:FindFirstAncestor("Settings").Analytics.CoreGuiFinalStateAnalytics)
local v = CoreGuiFinalStateAnalytics.new()

RobloxGui:WaitForChild("Modules"):WaitForChild("TenFootInterface")

local GetFFlagEnableInGameMenuDurationLogger = require(RobloxGui.Modules.Common.Flags.GetFFlagEnableInGameMenuDurationLogger)
local FFlagLeaveActionChromeShortcutTelemetry = require(RobloxGui.Modules.Chrome.Flags.FFlagLeaveActionChromeShortcutTelemetry)

local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local GetDefaultQualityLevel = AppCommonLib.GetDefaultQualityLevel

local Constants = require(RobloxGui.Modules:WaitForChild("InGameMenu"):WaitForChild("Resources"):WaitForChild("Constants"))
local ReactSchedulingTracker = require(RobloxGui.Modules.Common.ReactSchedulingTracker)
local default

if fFlagVoiceVolumeControlsEnableVoiceVolumeImpressionsTelemetry then
	local VoiceChatServiceManager = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager)
	default = VoiceChatServiceManager.default
else
	default = nil
end

return function(flag: boolean, data)
	if FFlagEnableGameLeftMessage and not (data and data.inhibitAppRating) then
		messageBus.publish(Constants.OnAppRatingPromptEventDescriptor, {
			gameTime = game:getGameTime()
		})
	end

	if GetFFlagEnableInGameMenuDurationLogger() then
		PerfUtils.leavingGame()
	end

	ReactSchedulingTracker:reportSession()
	local Memory = require(CorePackages.Workspace.Packages.Memory)
	local memoryTracker = Memory.MemoryTracker()

	if memoryTracker then
		memoryTracker:destroy()
	end

	GuiService.SelectedCoreObject = nil

	local playsessionid = not engineFeature and "" or RbxAnalyticsService:GetPlaySessionId()

	local joined = {
		confirmed = Constants.AnalyticsConfirmedName,
		universeid = tostring(game.GameId),
		source = Constants.AnalyticsLeaveGameSource,
		playsessionid = playsessionid
	}

	if FFlagLeaveActionChromeShortcutTelemetry and data and data.telemetryFields then
		joined = Cryo.Dictionary.join(joined, data.telemetryFields)
	end

	local analyticsTargetName = Constants.AnalyticsTargetName
	local v2

	if data and data.telemetryContext then
		v2 = data.telemetryContext
	else
		v2 = Constants.AnalyticsInGameMenuName
	end

	RbxAnalyticsService:SetRBXEventStream(analyticsTargetName, v2, Constants.AnalyticsLeaveGameName, joined)

	if flag then
		if FFlagSurvBloxEventTypeEnabled then
			SurveyEventPublisher.publishSurveyEvent(WebViewEventType.LeaveButtonClick)
		else
			local customProps = { chromeSeenCount = tostring(0) }

			local userId = tostring(Players.LocalPlayer.UserId)
			messageBus.publish(Constants.OnSurveyEventDescriptor, {
				eventType = Constants.SurveyEventType,
				userId = userId,
				customProps = customProps
			})
		end
	end

	v:sendCoreGuiFinalAnalytic()

	if fFlagVoiceVolumeControlsEnableVoiceVolumeImpressionsTelemetry then
		default:ReportVoiceVolumeImpressionsIfNeeded()
	end

	RunService.RenderStepped:wait()
	RunService.RenderStepped:wait()

	if data and data.leaveReason then
		experienceService:LeaveExperienceWithReason(data.leaveReason)
		local settings = settings()
		settings.Rendering.QualityLevel = GetDefaultQualityLevel()
	else
		if not (isExitModalRemoved and data and data.shouldNativeExit) then
			game:Shutdown()
		end

		local settings = settings()
		settings.Rendering.QualityLevel = GetDefaultQualityLevel()

		if isExitModalRemoved and data and data.shouldNativeExit then
			GuiService:BroadcastNotification("", GuiService:GetNotificationTypeList().NATIVE_EXIT)
		end
	end
end
