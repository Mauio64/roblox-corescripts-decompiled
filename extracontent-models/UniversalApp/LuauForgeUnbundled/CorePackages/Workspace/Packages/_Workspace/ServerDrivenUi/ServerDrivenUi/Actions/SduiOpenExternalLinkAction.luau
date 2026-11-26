local CentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/CentralOverlay")
local setCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local closeCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
local centralOverlayType = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RobloxAppEnums").CentralOverlayType
local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiActionType = SduiCoreSystem.SduiActionType
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local fFlagSafetyResourceBannerTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSafetyResourceBannerTelemetry
local sduiActionParams = SduiCoreSystem.SduiActionParams

local fFlagLuaAppSduiOpenExternalLinkSkipLeaveConfirmation = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppSduiOpenExternalLinkSkipLeaveConfirmation

return function(p2, p3, p4, p5)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{ name = sduiActionType.OpenExternalLink, message = "Missing actionParams" },
			p4.appPage
		)
		return
	end

	assert(actionParams, "actionParams must exist")
	local url = actionParams.url

	if typeof(url) ~= "string" or url == "" then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenExternalLink,
				message = `Invalid or missing url: {url}`,
				propName = "url"
			},
			p4.appPage
		)
		return
	end

	local dispatch = p4.dependencies.dispatch
	local linkingProtocol = p4.dependencies.linkingProtocol

	local onContinue = if fFlagSafetyResourceBannerTelemetry then actionParams.onContinue else nil

	local function openInBrowser()
		linkingProtocol:openURL(url):catch(function(value)
			p4.dependencies.logger.reportError(sduiErrorType.FailedToOpenLink, {
				name = sduiActionType.OpenExternalLink,
				message = typeof(value) ~= "string" and "Unknown reason" or value
			}, p4.appPage)
		end)
	end

	if
		fFlagLuaAppSduiOpenExternalLinkSkipLeaveConfirmation
		and sduiActionParams.getBooleanParam(actionParams, "skipLeaveConfirmation", false)
	then
		linkingProtocol:openURL(url):catch(function(value)
			p4.dependencies.logger.reportError(sduiErrorType.FailedToOpenLink, {
				name = sduiActionType.OpenExternalLink,
				message = typeof(value) ~= "string" and "Unknown reason" or value
			}, p4.appPage)
		end)

		return
	end

	local function fn()
		linkingProtocol:openURL(url):catch(function(value)
			p4.dependencies.logger.reportError(sduiErrorType.FailedToOpenLink, {
				name = sduiActionType.OpenExternalLink,
				message = typeof(value) ~= "string" and "Unknown reason" or value
			}, p4.appPage)
		end)

		dispatch(closeCentralOverlay())

		if fFlagSafetyResourceBannerTelemetry and typeof(onContinue) == "function" then
			local success, result = pcall(onContinue)

			if not success then
				p4.dependencies.logger.reportError(
					sduiErrorType.FailedToExecuteAction,
					{
						name = sduiActionType.OpenExternalLink,
						message = `onContinue failed: {tostring(result)}`
					},
					p4.appPage
				)
			end
		end
	end

	dispatch(setCentralOverlay(centralOverlayType.LeaveRobloxAlert, {
		continueFunc = fn
	}))
end
