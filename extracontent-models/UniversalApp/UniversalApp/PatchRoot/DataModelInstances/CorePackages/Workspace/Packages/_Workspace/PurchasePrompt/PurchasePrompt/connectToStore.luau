local Parent = script:FindFirstAncestor("PurchasePrompt").Parent
local RoactRodux = require(Parent.PurchasePromptDeps).RoactRodux

local function connectToStore(p1, p2) -- line: 12
	-- upvalues: RoactRodux (copy)
	return function(p3) -- line: 13
		-- upvalues: RoactRodux (copy), p1 (copy), p2 (copy)
		local v7 = RoactRodux.UNSTABLE_connect2(p1, p2)(p3)

		function v7.getUnconnected() -- line: 16
			-- upvalues: p3 (copy)
			return p3
		end

		return v7
	end
end

return connectToStore
