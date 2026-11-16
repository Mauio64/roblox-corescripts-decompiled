local module = require("@luauforge/bundled/hOn")
local module2 = require("@luauforge/bundled/hOo")
local useDispatch = require("@luauforge/bundled/hOp").Hooks.RoactRodux.useDispatch
local useUserExperiment = require("@luauforge/bundled/hOq").useUserExperiment
local appUserLayers = require("@luauforge/bundled/hOr").AppUserLayers
local centralOverlayType = require("@luauforge/bundled/hOs").CentralOverlayType
local setCentralOverlay = require("@luauforge/bundled/hOt").Actions.SetCentralOverlay
local screenshotManager = require("@luauforge/bundled/hOu").ScreenshotManager
local signal = require("@luauforge/bundled/hOy").Signal
require("@luauforge/bundled/hOz")
local setCurrentToastMessage = require("@luauforge/bundled/hOA").Actions.SetCurrentToastMessage
local reportDeviceLogs = require("@luauforge/bundled/hOB").reportDeviceLogs
local mutedError = require("@luauforge/bundled/hOC").mutedError
local bugReporterCounterName = require("@luauforge/bundled/hOD").BugReporterCounterName
local module3 = require("@luauforge/bundled/hOE")
local module4 = require("@luauforge/bundled/hOL")

local module5 = require("@luauforge/bundled/hOM")
local bugReporterService = module5.bugReporterService
local guiService = module5.guiService
local loggingProtocol = module5.loggingProtocol
local logReporterService = module5.logReporterService
local runService = module5.runService
local userInputService = module5.userInputService
local voiceChatService = module5.voiceChatService
local systemInfoProtocol = module5.systemInfoProtocol
local localPlayer = module5.localPlayer
local getPlaceId = module5.getPlaceId
local makeLogger = module5.makeLogger
local networking = module5.networking

local defineFastFlag = game:DefineFastFlag("InAppBugReporterIxpEnabled", false)
local defineFastFlag2 = game:DefineFastFlag("InAppBugReporterIxpBypass", false)

local function isVoiceEnabled(object, p2)
	local success, result = pcall(function()
		if p2 then
			return object:IsVoiceEnabledForUserIdAsync(p2)
		end

		return false
	end)

	return success and result
end

local function safeReportDeviceLogs(p2, p3, p4, p5)
	local success, result = pcall(function()
		return reportDeviceLogs(p2, p3, p4, p5).url
	end)

	if not success then
		mutedError(`Failed to report device logs: {result}`)
	end

	return success and result or ""
end

local function BugReporterEventReceiver()
	local v5 = useDispatch()
	local placeId = getPlaceId()
	local v6 = nil

	if defineFastFlag2 then
		v6 = true
	elseif defineFastFlag then
		v6 = useUserExperiment({ appUserLayers.ConsumerPlatformsBugReporting }, function(p2)
			return (p2[appUserLayers.ConsumerPlatformsBugReporting] or {}).inAppBugReportingEnabled or nil
		end)
	end

	local v7 = v6 and bugReporterService and bugReporterService:IsAvailable()

	local v8 = module2.useCallback(function(data, p2)
		local userId = localPlayer and localPlayer.UserId or 0
		local displayName = localPlayer and localPlayer.DisplayName or ""
		local v9 = voiceChatService
		local success, result = pcall(function()
			if userId then
				return v9:IsVoiceEnabledForUserIdAsync(userId)
			end

			return false
		end)

		local v10 = success and result

		local v11 = logReporterService
		local v12 = placeId
		local success2, result2 = pcall(function()
			return reportDeviceLogs(v11, userId, v12, v10).url
		end)

		if not success2 then
			mutedError(`Failed to report device logs: {result2}`)
		end

		data.reportCounter(bugReporterCounterName.ReportSubmitted)
		data.reportMilestone(bugReporterCounterName.ReportSubmitted, {
			screen = p2.additionalInfo.screen
		})

		module3(networking, module.join(p2, {
			userId = userId,
			userDisplayName = displayName,
			logUrl = success2 and result2 or ""
		})):andThen(function(p3)
			data.reportCounter(bugReporterCounterName.ReportSucceeded)
			data.reportMilestone(bugReporterCounterName.ReportSucceeded, {
				issueId = p3.issue.id
			})

			v5(setCurrentToastMessage({
				toastMessage = "Feature.InAppBugReporting.Message.ToastSuccess"
			}))
		end):catch(function(p3)
			data.reportError(p3.type, {
				screen = p2.additionalInfo.screen,
				message = p3.message
			})

			v5(setCurrentToastMessage({
				toastMessage = "Feature.InAppBugReporting.Message.ToastFailure"
			}))
		end)
	end, { v5, placeId })

	module2.useEffect(function()
		local bugReportRequestedConnection

		if v7 and bugReporterService then
			bugReportRequestedConnection = bugReporterService.BugReportRequested:Connect(function(p2)
				local logger = makeLogger(loggingProtocol, p2)
				local v9 = signal.new()

				logger.reportCounter(bugReporterCounterName.ReportInitiated)

				screenshotManager:TakeScreenshotWithCallback(function(p3)
					logger.reportCounter(bugReporterCounterName.ScreenshotUploaded, {
						screenshotRemoteId = p3
					})
					v9:fire(p3)
				end, function(p3)
					logger.reportCounter(bugReporterCounterName.ScreenshotCaptured, {
						screenshotLocalId = p3
					})
					v5(setCentralOverlay(centralOverlayType.BugReporter, {
						guiService = guiService,
						runService = runService,
						userInputService = userInputService,
						systemInfoProtocol = systemInfoProtocol,
						screenshotLocalId = p3,
						onScreenshotUploaded = v9,
						onSubmitBugReport = v8,
						logger = logger
					}))
				end, module4.SCREENSHOT_BUCKET)
			end)
		else
			bugReportRequestedConnection = nil
		end

		return function()
			if bugReportRequestedConnection then
				bugReportRequestedConnection:Disconnect()
			end
		end
	end, { v5, v7, v8 })
end

return module2.memo(BugReporterEventReceiver)
