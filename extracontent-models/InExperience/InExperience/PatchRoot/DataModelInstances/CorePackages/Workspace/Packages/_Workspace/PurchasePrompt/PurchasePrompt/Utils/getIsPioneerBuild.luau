local parent = script:FindFirstAncestor("PurchasePrompt").Parent

local PioneerUtils = require(parent.PioneerUtils)
local PioneerInfo = PioneerUtils.PioneerInfo

return function()
	return PioneerInfo.isDaveyBazooka()
end
