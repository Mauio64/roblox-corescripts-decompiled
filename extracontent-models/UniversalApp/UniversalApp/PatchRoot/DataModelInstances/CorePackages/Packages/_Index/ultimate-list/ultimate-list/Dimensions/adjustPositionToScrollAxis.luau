local ultimatelist = script:FindFirstAncestor("ultimate-list")

local exhaustiveMatch = require(ultimatelist.Util.exhaustiveMatch)

local function adjustPositionToScrollAxis(udim: UDim2, p: number, p2: string)
	if p2 == "x" then
		return UDim2.new(0, udim.X.Offset - p, udim.Y.Scale, udim.Y.Offset)
	elseif p2 == "y" then
		return UDim2.new(udim.X.Scale, udim.X.Offset, 0, udim.Y.Offset - p)
	end

	return exhaustiveMatch(p2)
end

return adjustPositionToScrollAxis
