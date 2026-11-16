local ScriptContext = game:GetService("ScriptContext")
local MemStorageService = game:GetService("MemStorageService")

local discoveryAppLaunchTracker = require("@luauforge/bundled/hEX").DiscoveryAppLaunchTracker

local defineFastFlag = game:DefineFastFlag("LeaveExperienceLatencyTrackingEnabled", false)
local engineFeature = game:GetEngineFeature("TriggerReportLuaRequireCountFromLua")

local module = require("@luauforge/bundled/hFU")
local default = require("@luauforge/bundled/hFV").default

local function logHomePageInteractive(p2, data)
	if p2 == nil then
		return
	end

	local appStartupSequence = data.appStartupSequence

	if
		appStartupSequence == nil
		or appStartupSequence.isInteractive
		or (p2.AbsoluteSize.X <= 1 or p2.AbsoluteSize.Y <= 1)
	then
		return
	end

	local loggingProtocol = data.loggingProtocol
	loggingProtocol:logEventOnce("home_page_interactive_legacy")

	task.defer(function()
		loggingProtocol:logEventOnce("home_page_interactive")

		if module then
			default.finish()
		end

		if
			defineFastFlag
			and MemStorageService:GetItem("pendingLeaveExperienceWithDestroyedLuaApp") == "true"
		then
			MemStorageService:SetItem("pendingLeaveExperienceWithDestroyedLuaApp", "")
			loggingProtocol:logEvent("leave_experience_end")
		end

		if discoveryAppLaunchTracker.isEnabled() and discoveryAppLaunchTracker.default then
			discoveryAppLaunchTracker.default:stopTracking()
		end

		if game:GetEngineFeature("LuaAppInteractiveSignalEnabled") and data.appLifecycleObserverService then
			data.appLifecycleObserverService:TriggerOnLuaAppInteractive()
		elseif engineFeature then
			ScriptContext:ReportLuaRequireCount()
		end

		task.defer(function()
			appStartupSequence:setInteractive()
		end)
	end)
end

return logHomePageInteractive
