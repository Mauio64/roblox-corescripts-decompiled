local HttpService = game:GetService("HttpService")
local TelemetryService = game:GetService("TelemetryService")
local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging

local module = require("@luauforge/bundled/egs")
local statusCodes = require("@game/CorePackages/Workspace/Packages/Http").StatusCodes
local module2 = require("@luauforge/bundled/ilT")
local module3 = require("@luauforge/bundled/ilU")
local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").Logger
local telemetryConfigs = require("@luauforge/bundled/fzT").TelemetryConfigs
local module4 = require("@luauforge/bundled/fzT")
local authClientError = module4.Events.authClientError
local authOperationTiming = module4.Events.authOperationTiming
local authPageload = module4.Events.authPageload
local module5 = require("@luauforge/bundled/fzS")
local webViewStateTracker = require("@luauforge/bundled/fBH").WebViewStateTracker
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local getFFlagTriggerLogoutOnAuthErrorCode = SharedFlags.GetFFlagTriggerLogoutOnAuthErrorCode
local getFStringAuthenticationErrorCode = SharedFlags.GetFStringAuthenticationErrorCode
local getFStringAuthenticationErrorCodeAlternative = SharedFlags.GetFStringAuthenticationErrorCodeAlternative
local fFlagEnableWebViewStateTracker = SharedFlags.FFlagEnableWebViewStateTracker

local defineFastFlag = game:DefineFastFlag("RemoveHttpErrorLog2", false)
local defineFastFlag2 = game:DefineFastFlag("EnableWebViewOpenDurationCap", false)
local defineFastInt = game:DefineFastInt("WebViewOpenDurationCapSeconds", 0)
local defineFastInt2 = game:DefineFastInt("WebViewLastClosedDurationSeconds", 1)

return function(p2, p3, p4, p5)
	return function(object)
		if p4 == nil then
			return module.resolve()
		end

		if defineFastFlag then
			logger:debug("HTTP error url:`" .. tostring(p3) .. "`")
			logger:debug("HTTP error code:`" .. tostring(p4.StatusCode) .. "`")
			logger:debug("HTTP error body:`" .. tostring(p4.Body) .. "`")
		else
			logging.warn("HTTP error url:`" .. tostring(p3) .. "`")
			logging.warn("HTTP error code:`" .. tostring(p4.StatusCode) .. "`")
			logging.warn("HTTP error body:`" .. tostring(p4.Body) .. "`")
		end

		if p4.StatusCode == statusCodes.FORBIDDEN then
			object:dispatch(module3(p2, p4))
		elseif p4.StatusCode == statusCodes.UNAUTHORIZED then
			local v5 = "empty"
			local v6 = "empty"

			local success, result = pcall(function()
				return HttpService:JSONDecode(p4.Body)
			end)

			if success and result.errors and result.errors[1] then
				local err = result.errors[1]

				if err.code ~= nil then
					v5 = tostring(err.code)
				end

				if err.subcode ~= nil then
					v6 = tostring(err.subcode)
				end
			end

			TelemetryService:LogCounter(telemetryConfigs.UnauthorizedErrorTelemetryConfig, {
				customFields = { code = v5, subcode = v6 }
			}, 1)

			authClientError(module5.Context.UnauthorizedError, v6, p3, v5)

			if fFlagEnableWebViewStateTracker then
				local openNoLongerThan = webViewStateTracker.isOpenNoLongerThan(
					defineFastFlag2,
					defineFastInt
				)

				local wasClosedWithin = webViewStateTracker.wasClosedWithin(defineFastInt2)
				local v7, v8

				if openNoLongerThan then
					v7 = module5.State.Diagnostic401WebviewOpen
					v8 = webViewStateTracker.getOpenDuration()
				elseif wasClosedWithin then
					v7 = module5.State.Diagnostic401WebviewRecentlyClosed
					v8 = webViewStateTracker.wasLastClosed()
				elseif webViewStateTracker.wasLastClosed() >= 0 then
					v7 = module5.State.Diagnostic401WebviewClosedExpired
					v8 = webViewStateTracker.wasLastClosed()
				else
					v7 = module5.State.Diagnostic401WebviewNeverOpened
					v8 = -1
				end

				authOperationTiming(module5.Context.InvoluntaryLogoutGracePeriod, v8, v7)

				if openNoLongerThan or wasClosedWithin then
					authPageload(
						module5.Context.InvoluntaryLogoutGracePeriod,
						module5.State.GracePeriodApplied
					)

					return module.reject(p4)
				end

				if openNoLongerThan and defineFastFlag2 then
					if defineFastInt < webViewStateTracker.getOpenDuration() then
						authOperationTiming(
							module5.Context.InvoluntaryLogoutGracePeriod,
							webViewStateTracker.getOpenDuration(),
							module5.State.GracePeriodExceeded
						)
					elseif not wasClosedWithin then
						authOperationTiming(
							module5.Context.InvoluntaryLogoutGracePeriod,
							webViewStateTracker.wasLastClosed(),
							module5.State.WebViewLastClosed
						)
					end
				elseif not wasClosedWithin then
					authOperationTiming(
						module5.Context.InvoluntaryLogoutGracePeriod,
						webViewStateTracker.wasLastClosed(),
						module5.State.WebViewLastClosed
					)
				end
			end

			if
				getFFlagTriggerLogoutOnAuthErrorCode()
				and (v5 == getFStringAuthenticationErrorCode() or v5 == getFStringAuthenticationErrorCodeAlternative())
			then
				object:dispatch(module2(p2, p5, p3))
			elseif not getFFlagTriggerLogoutOnAuthErrorCode() then
				object:dispatch(module2(p2, p5, p3))
			end
		end

		return module.reject(p4)
	end
end
