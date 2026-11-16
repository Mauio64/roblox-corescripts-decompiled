local parent = script:FindFirstAncestor("PurchasePrompt").Parent
local PurchasePromptDeps = require(parent.PurchasePromptDeps)
local RoactRodux = PurchasePromptDeps.RoactRodux

local function connectToStore(p, p2)
	return function(unconnected)
		local v = RoactRodux.UNSTABLE_connect2(p, p2)(unconnected)

		function v.getUnconnected()
			return unconnected
		end

		return v
	end
end

return connectToStore
