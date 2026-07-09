local Parent = script:FindFirstAncestor("BulkPurchaseApp").Parent
local React = require(Parent.React)

local function makeHookTest(p1: ((...any) -> ...any), p2, s1: string?) -- line: 5
	-- upvalues: React (copy)
	return function() -- line: 6
		-- upvalues: p1 (copy), p2 (copy), React (copy), s1 (copy)
		local v7 = p1()

		p2(v7)

		return React.createElement("Frame", {
			Name = "HookFrame",
			Position = UDim2.fromOffset(100, 100),
			Size = UDim2.fromOffset(100, 100),
			ref = if not s1 then nil else v7[s1]
		})
	end
end

return makeHookTest
