local Parent = script:FindFirstAncestor("BugReporting").Parent
local Dash = require(Parent.Dash)
local React = require(Parent.React)
local useDispatch = require(Parent.RoactUtils).Hooks.RoactRodux.useDispatch
local useUserExperiment = require(Parent.RoactAppExperiment).useUserExperiment
local AppUserLayers = require(Parent.ExperimentLayers).AppUserLayers
local CentralOverlayType = require(Parent.RobloxAppEnums).CentralOverlayType
local SetCentralOverlay = require(Parent.CentralOverlay).Actions.SetCentralOverlay
local ScreenshotManager = require(Parent.TnSScreenshot).ScreenshotManager
local Signal = require(Parent.AppCommonLib).Signal

require(Parent.SystemInfoProtocol)

local SetCurrentToastMessage = require(Parent.ToastRodux).Actions.SetCurrentToastMessage
local reportDeviceLogs = require(Parent.LogReporting).reportDeviceLogs
local mutedError = require(Parent.Loggers).mutedError
local BugReporterCounterName = require(script.Parent.BugReporterTypes).BugReporterCounterName
local postBugReportApi = require(script.Parent.api.postBugReportApi)
local SharedConstants = require(script.Parent.SharedConstants)
local dependencies = require(script.Parent.dependencies)
local bugReporterService = dependencies.bugReporterService
local guiService = dependencies.guiService
local loggingProtocol = dependencies.loggingProtocol
local logReporterService = dependencies.logReporterService
local runService = dependencies.runService
local userInputService = dependencies.userInputService
local voiceChatService = dependencies.voiceChatService
local systemInfoProtocol = dependencies.systemInfoProtocol
local localPlayer = dependencies.localPlayer
local getPlaceId = dependencies.getPlaceId
local makeLogger = dependencies.makeLogger
local networking = dependencies.networking
local v30 = game:DefineFastFlag("InAppBugReporterIxpEnabled", false)
local v31 = game:DefineFastFlag("InAppBugReporterIxpBypass", false)

local function isVoiceEnabled(p1, n1: number) -- line: 46
	local ok, result = pcall(function() -- line: 47
		-- upvalues: n1 (copy), p1 (copy)
		if n1 then
			return p1:IsVoiceEnabledForUserIdAsync(n1)
		end

		return false
	end)

	return ok and result
end
local function safeReportDeviceLogs(p2, n2: number, n3: number, b1: boolean) -- line: 58
	-- upvalues: reportDeviceLogs (copy), mutedError (copy)
	local ok, result = pcall(function() -- line: 64
		-- upvalues: reportDeviceLogs (copy), p2 (copy), n2 (copy), n3 (copy), b1 (copy)
		return reportDeviceLogs(p2, n2, n3, b1).url
	end)

	if not ok then
		mutedError(`Failed to report device logs: { result }`)
	end

	return ok and result or ""
end
local function BugReporterEventReceiver() -- line: 76
	-- upvalues: useDispatch (copy), getPlaceId (copy), v31 (copy), v30 (copy), useUserExperiment (copy), AppUserLayers (copy), bugReporterService (copy), React (copy), localPlayer (copy), voiceChatService (copy), logReporterService (copy), reportDeviceLogs (copy), mutedError (copy), BugReporterCounterName (copy), postBugReportApi (copy), networking (copy), Dash (copy), SetCurrentToastMessage (copy), makeLogger (copy), loggingProtocol (copy), Signal (copy), ScreenshotManager (copy), SetCentralOverlay (copy), CentralOverlayType (copy), guiService (copy), runService (copy), userInputService (copy), systemInfoProtocol (copy), SharedConstants (copy)
	local v45 = useDispatch()
	local v46 = getPlaceId()
	local v47 = nil

	if v31 then
		v47 = true
	elseif v30 then
		v47 = useUserExperiment({ AppUserLayers.ConsumerPlatformsBugReporting }, function(p3) -- line: 86
			-- upvalues: AppUserLayers (copy)
			return (p3[AppUserLayers.ConsumerPlatformsBugReporting] or {}).inAppBugReportingEnabled or nil
		end)
	end

	local v48 = v47 and (bugReporterService and bugReporterService:IsAvailable())
	local v49 = React.useCallback(function(p4, p5) -- line: 96
		-- upvalues: localPlayer (copy), voiceChatService (copy), logReporterService (copy), v46 (copy), reportDeviceLogs (copy), mutedError (copy), BugReporterCounterName (copy), postBugReportApi (copy), networking (copy), Dash (copy), v45 (copy), SetCurrentToastMessage (copy)
		local v53 = localPlayer and localPlayer.UserId or 0
		local v54 = localPlayer and localPlayer.DisplayName or ""
		local v55 = voiceChatService
		local ok, result = pcall(function() -- line: 47
			-- upvalues: v53 (copy), v55 (copy)
			if v53 then
				return v55:IsVoiceEnabledForUserIdAsync(v53)
			end

			return false
		end)
		local v58 = ok and result
		local v59 = logReporterService
		local v60 = v46
		local ok2, result2 = pcall(function() -- line: 64
			-- upvalues: reportDeviceLogs (copy), v59 (copy), v53 (copy), v60 (copy), v58 (copy)
			return reportDeviceLogs(v59, v53, v60, v58).url
		end)

		if not ok2 then
			mutedError(`Failed to report device logs: { result2 }`)
		end

		local v63 = ok2 and result2 or ""

		p4.reportCounter(BugReporterCounterName.ReportSubmitted)
		p4.reportMilestone(BugReporterCounterName.ReportSubmitted, {
			screen = p5.additionalInfo.screen
		})
		postBugReportApi(networking, Dash.join(p5, {
			userId = v53,
			userDisplayName = v54,
			logUrl = v63
		})):andThen(function(p6) -- line: 115
			-- upvalues: p4 (copy), BugReporterCounterName (copy), v45 (copy), SetCurrentToastMessage (copy)
			p4.reportCounter(BugReporterCounterName.ReportSucceeded)
			p4.reportMilestone(BugReporterCounterName.ReportSucceeded, {
				issueId = p6.issue.id
			})
			v45(SetCurrentToastMessage({
				toastMessage = "Feature.InAppBugReporting.Message.ToastSuccess"
			}))
		end):catch(function(p7) -- line: 123
			-- upvalues: p4 (copy), p5 (copy), v45 (copy), SetCurrentToastMessage (copy)
			p4.reportError(p7.type, {
				screen = p5.additionalInfo.screen,
				message = p7.message
			})
			v45(SetCurrentToastMessage({
				toastMessage = "Feature.InAppBugReporting.Message.ToastFailure"
			}))
		end)
	end, {
		v45,
		v46
	})

	React.useEffect(function() -- line: 137
		-- upvalues: v48 (copy), bugReporterService (copy), makeLogger (copy), loggingProtocol (copy), Signal (copy), BugReporterCounterName (copy), ScreenshotManager (copy), v45 (copy), SetCentralOverlay (copy), CentralOverlayType (copy), guiService (copy), runService (copy), userInputService (copy), systemInfoProtocol (copy), v49 (copy), SharedConstants (copy)
		local connection = nil

		if v48 and bugReporterService then
			connection = bugReporterService.BugReportRequested:Connect(function(s1: string) -- line: 141
				-- upvalues: makeLogger (copy), loggingProtocol (copy), Signal (copy), BugReporterCounterName (copy), ScreenshotManager (copy), v45 (copy), SetCentralOverlay (copy), CentralOverlayType (copy), guiService (copy), runService (copy), userInputService (copy), systemInfoProtocol (copy), v49 (copy), SharedConstants (copy)
				local v68 = makeLogger(loggingProtocol, s1)
				local v69 = Signal.new()

				v68.reportCounter(BugReporterCounterName.ReportInitiated)
				ScreenshotManager:TakeScreenshotWithCallback(function(s2: string) -- line: 147
					-- upvalues: v68 (copy), BugReporterCounterName (copy), v69 (copy)
					v68.reportCounter(BugReporterCounterName.ScreenshotUploaded, {
						screenshotRemoteId = s2
					})
					v69:fire(s2)
				end, function(s3: string) -- line: 150
					-- upvalues: v68 (copy), BugReporterCounterName (copy), v45 (copy), SetCentralOverlay (copy), CentralOverlayType (copy), guiService (copy), runService (copy), userInputService (copy), systemInfoProtocol (copy), v69 (copy), v49 (copy)
					v68.reportCounter(BugReporterCounterName.ScreenshotCaptured, {
						screenshotLocalId = s3
					})
					v45(SetCentralOverlay(CentralOverlayType.BugReporter, {
						guiService = guiService,
						runService = runService,
						userInputService = userInputService,
						systemInfoProtocol = systemInfoProtocol,
						screenshotLocalId = s3,
						onScreenshotUploaded = v69,
						onSubmitBugReport = v49,
						logger = v68
					}))
				end, SharedConstants.SCREENSHOT_BUCKET)
			end)
		end

		return function() -- line: 166
			-- upvalues: connection (ref)
			if connection then
				connection:Disconnect()
			end
		end
	end, {
		v45,
		v48,
		v49
	})
end

return React.memo(BugReporterEventReceiver)
