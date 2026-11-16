local parent = script:FindFirstAncestor("ProgressLoading").Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagTiltLoadingScreenEnterExitHold = SharedFlags.FFlagTiltLoadingScreenEnterExitHold

local function shouldHoldForExit(flag: boolean)
	return FFlagTiltLoadingScreenEnterExitHold and not flag
end

return shouldHoldForExit
