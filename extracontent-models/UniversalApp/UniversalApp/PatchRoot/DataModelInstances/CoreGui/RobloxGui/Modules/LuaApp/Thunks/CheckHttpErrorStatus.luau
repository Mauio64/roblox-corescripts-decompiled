local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local TelemetryService = game:GetService("TelemetryService")
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local Modules = CoreGui.RobloxGui.Modules
local Promise = require(Modules.LuaApp.Promise)
local StatusCodes = require(CorePackages.Workspace.Packages.Http).StatusCodes
local LogoutUserOnUnauthorized = require(Modules.LuaApp.Thunks.LogoutUserOnUnauthorized)
local UserModerationCheck = require(Modules.LuaApp.Thunks.Moderation.UserModerationCheck)
local Logger = require(CorePackages.Workspace.Packages.Loggers).Logger
local TelemetryConfigs = require(CorePackages.Workspace.Packages.AuthAnalytics).TelemetryConfigs
local AuthAnalytics = require(CorePackages.Workspace.Packages.AuthAnalytics)
local authClientError = AuthAnalytics.Events.authClientError
local authOperationTiming = AuthAnalytics.Events.authOperationTiming
local authPageload = AuthAnalytics.Events.authPageload
local EventStreamConstants = require(Modules.LuaApp.EventStreamConstants)
local WebViewStateTracker = require(CorePackages.Workspace.Packages.WebViewUtils).WebViewStateTracker
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagTriggerLogoutOnAuthErrorCode = SharedFlags.GetFFlagTriggerLogoutOnAuthErrorCode
local GetFStringAuthenticationErrorCode = SharedFlags.GetFStringAuthenticationErrorCode
local GetFStringAuthenticationErrorCodeAlternative = SharedFlags.GetFStringAuthenticationErrorCodeAlternative
local FFlagEnableWebViewStateTracker = SharedFlags.FFlagEnableWebViewStateTracker
local v24 = game:DefineFastFlag("RemoveHttpErrorLog2", false)
local v25 = game:DefineFastFlag("Enable401LogoutGracePeriod", false)
local v26 = game:DefineFastFlag("EnableWebViewOpenDurationCap", false)
local v27 = game:DefineFastInt("WebViewOpenDurationCapSeconds", 0)
local v28 = game:DefineFastInt("WebViewLastClosedDurationSeconds", 1)
local v29 = game:DefineFastFlag("Emit401WebViewDiagnostics", false)

return function(p1, p2, p3, p4) -- line: 34
	-- upvalues: Promise (copy), v24 (copy), Logger (copy), Logging (copy), StatusCodes (copy), UserModerationCheck (copy), HttpService (copy), TelemetryService (copy), TelemetryConfigs (copy), authClientError (copy), EventStreamConstants (copy), FFlagEnableWebViewStateTracker (copy), WebViewStateTracker (copy), v26 (copy), v27 (copy), v28 (copy), v29 (copy), authOperationTiming (copy), v25 (copy), authPageload (copy), GetFFlagTriggerLogoutOnAuthErrorCode (copy), GetFStringAuthenticationErrorCode (copy), GetFStringAuthenticationErrorCodeAlternative (copy), LogoutUserOnUnauthorized (copy)
	return function(p5) -- line: 35
		-- upvalues: p3 (copy), Promise (copy), v24 (copy), Logger (copy), p2 (copy), Logging (copy), StatusCodes (copy), UserModerationCheck (copy), p1 (copy), HttpService (copy), TelemetryService (copy), TelemetryConfigs (copy), authClientError (copy), EventStreamConstants (copy), FFlagEnableWebViewStateTracker (copy), WebViewStateTracker (copy), v26 (copy), v27 (copy), v28 (copy), v29 (copy), authOperationTiming (copy), v25 (copy), authPageload (copy), GetFFlagTriggerLogoutOnAuthErrorCode (copy), GetFStringAuthenticationErrorCode (copy), GetFStringAuthenticationErrorCodeAlternative (copy), LogoutUserOnUnauthorized (copy), p4 (copy)
		if p3 == nil then
			return Promise.resolve()
		end

		if v24 then
			Logger:debug("HTTP error url:`" .. tostring(p2) .. "`")
			Logger:debug("HTTP error code:`" .. tostring(p3.StatusCode) .. "`")
			Logger:debug("HTTP error body:`" .. tostring(p3.Body) .. "`")
		else
			Logging.warn("HTTP error url:`" .. tostring(p2) .. "`")
			Logging.warn("HTTP error code:`" .. tostring(p3.StatusCode) .. "`")
			Logging.warn("HTTP error body:`" .. tostring(p3.Body) .. "`")
		end

		if p3.StatusCode == StatusCodes.FORBIDDEN then
			p5:dispatch(UserModerationCheck(p1, p3))
		elseif p3.StatusCode == StatusCodes.UNAUTHORIZED then
			local s1 = "empty"
			local s2 = "empty"
			local ok, result = pcall(function() -- line: 57
				-- upvalues: HttpService (copy), p3 (copy)
				return HttpService:JSONDecode(p3.Body)
			end)

			if ok and result.errors and result.errors[1] then
				local v39 = result.errors[1]

				if v39.code ~= nil then
					s1 = tostring(v39.code)
				end

				if v39.subcode ~= nil then
					s2 = tostring(v39.subcode)
				end
			end

			TelemetryService:LogCounter(TelemetryConfigs.UnauthorizedErrorTelemetryConfig, {
				customFields = {
					code = s1,
					subcode = s2
				}
			}, 1)
			authClientError(EventStreamConstants.Context.UnauthorizedError, s2, p2, s1)

			if FFlagEnableWebViewStateTracker then
				local v40 = WebViewStateTracker.isOpenNoLongerThan(v26, v27)
				local v41 = WebViewStateTracker.wasClosedWithin(v28)

				if v29 then
					local Diagnostic401WebviewOpen, v43

					if v40 then
						Diagnostic401WebviewOpen = EventStreamConstants.State.Diagnostic401WebviewOpen
						v43 = WebViewStateTracker.getOpenDuration()
					elseif v41 then
						Diagnostic401WebviewOpen = EventStreamConstants.State.Diagnostic401WebviewRecentlyClosed
						v43 = WebViewStateTracker.wasLastClosed()
					elseif WebViewStateTracker.wasLastClosed() >= 0 then
						Diagnostic401WebviewOpen = EventStreamConstants.State.Diagnostic401WebviewClosedExpired
						v43 = WebViewStateTracker.wasLastClosed()
					else
						Diagnostic401WebviewOpen = EventStreamConstants.State.Diagnostic401WebviewNeverOpened
						v43 = -1
					end

					authOperationTiming(EventStreamConstants.Context.InvoluntaryLogoutGracePeriod, v43, Diagnostic401WebviewOpen)
				end

				if v25 and (v40 or v41) then
					authPageload(EventStreamConstants.Context.InvoluntaryLogoutGracePeriod, EventStreamConstants.State.GracePeriodApplied)

					return Promise.reject(p3)
				end

				if v40 and v26 and WebViewStateTracker.getOpenDuration() > v27 then
					authOperationTiming(EventStreamConstants.Context.InvoluntaryLogoutGracePeriod, WebViewStateTracker.getOpenDuration(), EventStreamConstants.State.GracePeriodExceeded)
				elseif not v41 then
					authOperationTiming(EventStreamConstants.Context.InvoluntaryLogoutGracePeriod, WebViewStateTracker.wasLastClosed(), EventStreamConstants.State.WebViewLastClosed)
				end
			end

			if GetFFlagTriggerLogoutOnAuthErrorCode() and (s1 == GetFStringAuthenticationErrorCode() or s1 == GetFStringAuthenticationErrorCodeAlternative()) then
				p5:dispatch(LogoutUserOnUnauthorized(p1, p4, p2))
			elseif not GetFFlagTriggerLogoutOnAuthErrorCode() then
				p5:dispatch(LogoutUserOnUnauthorized(p1, p4, p2))
			end
		end

		return Promise.reject(p3)
	end
end
