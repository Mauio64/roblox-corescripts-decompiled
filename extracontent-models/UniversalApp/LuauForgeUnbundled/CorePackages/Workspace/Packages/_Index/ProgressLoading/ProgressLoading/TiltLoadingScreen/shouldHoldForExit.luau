local fFlagTiltLoadingScreenEnterExitHold = require("@game/CorePackages/Workspace/Packages/_Workspace/ProgressLoading/SharedFlags").FFlagTiltLoadingScreenEnterExitHold

local function shouldHoldForExit(p2)
	return fFlagTiltLoadingScreenEnterExitHold and not p2
end

return shouldHoldForExit
