local Parent = script:FindFirstAncestor("ExpChat").Parent
local React = require(Parent.React)

local function calculateScaled(n1: number, n2: number) -- line: 6
	return n1 + n2 * (1 - n1)
end
local function mergeBindableScalar(p1, p2) -- line: 10
	-- upvalues: React (copy)
	return React.joinBindings((if typeof(p1) ~= "number" then {
		p2,
		p1
	} else { p2 })):map(function(p3) -- line: 15
		-- upvalues: p1 (copy)
		local v10 = p3[1]
		local v11 = p3[2] or p1

		if v11 == nil then
			return 1
		end

		return v11 + v10 * (1 - v11)
	end)
end

return mergeBindableScalar
