local NotificationsOrchestrator = script:FindFirstAncestor("NotificationsOrchestrator")
local parent = NotificationsOrchestrator.Parent

local Promise = require(parent.Promise)
local FFlagEnableOrchestratorDebugLogging = require(NotificationsOrchestrator.Flags.FFlagEnableOrchestratorDebugLogging)
local OrchestratorDebugLogger = {}

function OrchestratorDebugLogger.log(p: string)
	if FFlagEnableOrchestratorDebugLogging then
		print("[NotifOrchDebug]", p)
	end
end

function OrchestratorDebugLogger.logLazy(callback)
	if FFlagEnableOrchestratorDebugLogging then
		print("[NotifOrchDebug]", callback())
	end
end

function OrchestratorDebugLogger.startTimer()
	if FFlagEnableOrchestratorDebugLogging then
		return os.clock()
	end

	return nil
end

function OrchestratorDebugLogger.logElapsed(p: string, p2: number?)
	if FFlagEnableOrchestratorDebugLogging and p2 ~= nil then
		print("[NotifOrchDebug]", p, string.format("(%.3fs)", os.clock() - p2))
	end
end

function OrchestratorDebugLogger.logElapsedLazy(callback, p: number?)
	if FFlagEnableOrchestratorDebugLogging and p ~= nil then
		print("[NotifOrchDebug]", callback(), string.format("(%.3fs)", os.clock() - p))
	end
end

function OrchestratorDebugLogger.tracePromise(object, p)
	if not FFlagEnableOrchestratorDebugLogging then
		return object
	end

	if p.onSuccess then
		local onSuccess = p.onSuccess
		object = object:andThen(function(p2)
			onSuccess(p2)
			return p2
		end)
	end

	if p.onError then
		local onError = p.onError
		object = object:catch(function(p2)
			onError(p2)
			return Promise.reject(p2)
		end)
	end

	return object
end

return OrchestratorDebugLogger
