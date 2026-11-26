local forwardErrorToScriptContext = require("@game/CorePackages/Workspace/Packages/_Index/ProgressLoading/ProgressLoading/LoadingScreenMilestones/forwardErrorToScriptContext")

local function reportMilestoneError(p2)
	forwardErrorToScriptContext(debug.traceback(tostring(p2), 2))
end

local function tryMilestoneOperation(callback)
	return (xpcall(callback, reportMilestoneError))
end

return tryMilestoneOperation
