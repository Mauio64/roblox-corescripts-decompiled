local forwardErrorToScriptContext = require(script.Parent.forwardErrorToScriptContext)

local function reportMilestoneError(p)
	forwardErrorToScriptContext(debug.traceback(tostring(p), 2))
end

local function tryMilestoneOperation(callback)
	return (xpcall(callback, reportMilestoneError))
end

return tryMilestoneOperation
