local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local LuaErrorReporter = require(Modules.Common.LuaErrorReporter)
local LuaErrorSeverity = require(Modules.Common.LuaErrorSeverity)
local LuaAppSentryReporter = require(Modules.LuaApp.LuaAppSentryReporter)
local LuaAppBacktraceReporter = require(Modules.LuaApp.LuaAppBacktraceReporter)
local LuaAppEvents = require(Modules.LuaApp.LuaAppEvents)
local GetIsClientEnrolledInBacktraceRollout = require(Modules.LuaApp.Flags.GetIsClientEnrolledInBacktraceRollout)
local v10 = game:DefineFastInt("EnableSentryUADebugRolloutPercentage", 0)
local v11 = math.random(1, 100) <= math.clamp(v10, 0, 100)
local v12 = Roact.Component:extend("MutedErrorReporter")
local FFlagDisableGoogleAnalyticsErrorReporting = require(CorePackages.Workspace.Packages.SharedFlags).FFlagDisableGoogleAnalyticsErrorReporting

function v12.init(p1) -- line: 21
	-- upvalues: GetIsClientEnrolledInBacktraceRollout (copy), LuaAppBacktraceReporter (copy), v11 (copy), LuaAppSentryReporter (copy), LuaErrorReporter (copy), LuaAppEvents (copy), LuaErrorSeverity (copy), FFlagDisableGoogleAnalyticsErrorReporting (copy)
	local appName = p1.props.appName
	local v16 = nil

	if GetIsClientEnrolledInBacktraceRollout() then
		v16 = LuaAppBacktraceReporter
	end

	local v17 = nil

	if v11 then
		v17 = LuaAppSentryReporter
	end

	p1.errorReporter = LuaErrorReporter.new(LuaAppEvents.ReportMutedError, nil, v16, LuaErrorSeverity.DEBUG, v17)
	p1.errorReporter:setCurrentApp(appName)

	if not FFlagDisableGoogleAnalyticsErrorReporting then
		p1.errorReporter:startQueueTimers()
	end
end
function v12.render(_) -- line: 48
	return nil
end
function v12.willUnmount(p3) -- line: 52
	-- upvalues: FFlagDisableGoogleAnalyticsErrorReporting (copy)
	if not FFlagDisableGoogleAnalyticsErrorReporting then
		p3.errorReporter:stopQueueTimers()
	end
end

return v12
