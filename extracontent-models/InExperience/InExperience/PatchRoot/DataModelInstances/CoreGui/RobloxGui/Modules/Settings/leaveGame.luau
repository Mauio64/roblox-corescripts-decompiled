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
local EngineFeature = game:GetEngineFeature("RbxAnalyticsServiceExposePlaySessionId")
local FFlagRemoveExitModal = require(RobloxGui.Modules.Settings.Flags.FFlagRemoveExitModal)
local v13 = require(CorePackages.Workspace.Packages.VoiceChatCore).Flags.GetFFlagVoiceVolumeControlsEnableVoiceVolumeImpressionsTelemetry()
local PerfUtils = require(RobloxGui.Modules.Common.PerfUtils)
local Cryo = require(CorePackages.Packages.Cryo)
local MessageBus = require(CorePackages.Workspace.Packages.MessageBus).MessageBus
local SurveyEventPublisher = require(CorePackages.Workspace.Packages.OnPlatformSurveys.SurveyEventPublisher)
local WebViewEventType = require(CorePackages.Workspace.Packages.OnPlatformSurveys.WebViewEventType)
local v19 = require(script:FindFirstAncestor("Settings").Analytics.CoreGuiFinalStateAnalytics).new()

RobloxGui:WaitForChild("Modules"):WaitForChild("TenFootInterface")

local GetFFlagEnableInGameMenuDurationLogger = require(RobloxGui.Modules.Common.Flags.GetFFlagEnableInGameMenuDurationLogger)
local FFlagLeaveActionChromeShortcutTelemetry = require(RobloxGui.Modules.Chrome.Flags.FFlagLeaveActionChromeShortcutTelemetry)
local GetDefaultQualityLevel = require(CorePackages.Workspace.Packages.AppCommonLib).GetDefaultQualityLevel
local Constants = require(RobloxGui.Modules:WaitForChild("InGameMenu"):WaitForChild("Resources"):WaitForChild("Constants"))
local ReactSchedulingTracker = require(RobloxGui.Modules.Common.ReactSchedulingTracker)
local v25 = if not v13 then nil else require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager).default

return function(b1: boolean, t1: {[any]: any}?) -- line: 50
	-- upvalues: FFlagEnableGameLeftMessage (copy), MessageBus (copy), Constants (copy), GetFFlagEnableInGameMenuDurationLogger (copy), PerfUtils (copy), ReactSchedulingTracker (copy), CorePackages (copy), GuiService (copy), EngineFeature (copy), RbxAnalyticsService (copy), FFlagLeaveActionChromeShortcutTelemetry (copy), Cryo (copy), FFlagSurvBloxEventTypeEnabled (copy), SurveyEventPublisher (copy), WebViewEventType (copy), Players (copy), v19 (copy), v13 (copy), v25 (copy), RunService (copy), FFlagRemoveExitModal (copy), GetDefaultQualityLevel (copy)
	if FFlagEnableGameLeftMessage then
		MessageBus.publish(Constants.OnAppRatingPromptEventDescriptor, {
			gameTime = game:getGameTime()
		})
	end

	if GetFFlagEnableInGameMenuDurationLogger() then
		PerfUtils.leavingGame()
	end

	ReactSchedulingTracker:reportSession()

	local v28 = require(CorePackages.Workspace.Packages.Memory).MemoryTracker()

	if v28 then
		v28:destroy()
	end

	GuiService.SelectedCoreObject = nil

	local s1 = ""

	if EngineFeature then
		s1 = RbxAnalyticsService:GetPlaySessionId()
	end

	local t2 = {
		confirmed = Constants.AnalyticsConfirmedName,
		universeid = tostring(game.GameId),
		source = Constants.AnalyticsLeaveGameSource,
		playsessionid = s1
	}

	if FFlagLeaveActionChromeShortcutTelemetry and t1 and t1.telemetryFields then
		t2 = Cryo.Dictionary.join(t2, t1.telemetryFields)
	end

	RbxAnalyticsService:SetRBXEventStream(Constants.AnalyticsTargetName, Constants.AnalyticsInGameMenuName, Constants.AnalyticsLeaveGameName, t2)

	if b1 then
		if FFlagSurvBloxEventTypeEnabled then
			SurveyEventPublisher.publishSurveyEvent(WebViewEventType.LeaveButtonClick)
		else
			local t3 = {
				chromeSeenCount = tostring(0)
			}
			local str = tostring(Players.LocalPlayer.UserId)

			MessageBus.publish(Constants.OnSurveyEventDescriptor, {
				eventType = Constants.SurveyEventType,
				userId = str,
				customProps = t3
			})
		end
	end

	v19:sendCoreGuiFinalAnalytic()

	if v13 then
		v25:ReportVoiceVolumeImpressionsIfNeeded()
	end

	RunService.RenderStepped:wait()
	RunService.RenderStepped:wait()

	if not FFlagRemoveExitModal or not t1 or not t1.shouldNativeExit then
		game:Shutdown()
	end

	settings().Rendering.QualityLevel = GetDefaultQualityLevel()

	if FFlagRemoveExitModal and t1 and t1.shouldNativeExit then
		local NotificationTypeList = GuiService:GetNotificationTypeList()

		GuiService:BroadcastNotification("", NotificationTypeList.NATIVE_EXIT)
	end
end
