local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local CentralOverlay = require(parent.CentralOverlay)
local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local CloseCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
local RobloxAppEnums = require(parent.RobloxAppEnums)
local CentralOverlayType = RobloxAppEnums.CentralOverlayType
local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SharedFlags = require(parent.SharedFlags)
local FFlagSafetyResourceBannerTelemetry = SharedFlags.FFlagSafetyResourceBannerTelemetry
local SduiActionParams = SduiCoreSystem.SduiActionParams

local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppSduiOpenExternalLinkSkipLeaveConfirmation = SharedFlags2.FFlagLuaAppSduiOpenExternalLinkSkipLeaveConfirmation

return function(p, _, p2, _)
	local actionParams = p and p.actionParams or nil

	if actionParams == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = SduiActionType.OpenExternalLink, message = "Missing actionParams" },
			p2.appPage
		)
		return
	end

	assert(actionParams, "actionParams must exist")
	local url = actionParams.url

	if typeof(url) ~= "string" or url == "" then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = SduiActionType.OpenExternalLink,
				message = `Invalid or missing url: {url}`,
				propName = "url"
			},
			p2.appPage
		)
		return
	end

	local dispatch = p2.dependencies.dispatch
	local linkingProtocol = p2.dependencies.linkingProtocol
	local onContinue

	if FFlagSafetyResourceBannerTelemetry then
		onContinue = actionParams.onContinue
	else
		onContinue = nil
	end

	local function openInBrowser() -- 2 equivalent calls inferred from this helper
		linkingProtocol:openURL(url):catch(function(value)
			p2.dependencies.logger.reportError(SduiErrorType.FailedToOpenLink, {
				name = SduiActionType.OpenExternalLink,
				message = typeof(value) ~= "string" and "Unknown reason" or value
			}, p2.appPage)
		end)
	end

	if
		FFlagLuaAppSduiOpenExternalLinkSkipLeaveConfirmation
		and SduiActionParams.getBooleanParam(actionParams, "skipLeaveConfirmation", false)
	then
		openInBrowser() -- inferred equivalent call
		return
	end

	local function fn()
		openInBrowser() -- inferred equivalent call
		dispatch(CloseCentralOverlay())

		if FFlagSafetyResourceBannerTelemetry and typeof(onContinue) == "function" then
			local success, result = pcall(onContinue)

			if not success then
				p2.dependencies.logger.reportError(
					SduiErrorType.FailedToExecuteAction,
					{
						name = SduiActionType.OpenExternalLink,
						message = `onContinue failed: {tostring(result)}`
					},
					p2.appPage
				)
			end
		end
	end

	dispatch(SetCentralOverlay(CentralOverlayType.LeaveRobloxAlert, { continueFunc = fn }))
end
