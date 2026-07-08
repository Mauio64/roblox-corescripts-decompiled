local ancestor = script:FindFirstAncestor("ultimate-list")
local exhaustiveMatch = require(ancestor.Util.exhaustiveMatch)

local function adjustPositionToScrollAxis(uDim2: UDim2, n1: number, s1: string) -- line: 5
	-- upvalues: exhaustiveMatch (copy)
	if s1 == "x" then
		return UDim2.new(0, uDim2.X.Offset - n1, uDim2.Y.Scale, uDim2.Y.Offset)
	end

	if s1 == "y" then
		return UDim2.new(uDim2.X.Scale, uDim2.X.Offset, 0, uDim2.Y.Offset - n1)
	end

	return exhaustiveMatch(s1)
end

return adjustPositionToScrollAxis
