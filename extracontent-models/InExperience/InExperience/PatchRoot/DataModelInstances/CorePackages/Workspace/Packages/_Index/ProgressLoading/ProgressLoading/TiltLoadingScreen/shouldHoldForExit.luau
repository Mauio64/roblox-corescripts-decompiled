local Parent = script:FindFirstAncestor("ProgressLoading").Parent
local FFlagTiltLoadingScreenEnterExitHold = require(Parent.SharedFlags).FFlagTiltLoadingScreenEnterExitHold

local function shouldHoldForExit(b1: boolean, b2: boolean) -- line: 6
	-- upvalues: FFlagTiltLoadingScreenEnterExitHold (copy)
	return FFlagTiltLoadingScreenEnterExitHold and (not b1 and not b2)
end

return shouldHoldForExit
