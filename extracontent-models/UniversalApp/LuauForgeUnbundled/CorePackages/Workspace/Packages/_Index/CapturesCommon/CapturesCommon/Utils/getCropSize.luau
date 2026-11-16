local function getCropSize(p2, p3)
	if p2.X == 0 or p2.Y == 0 or p3.X == 0 or p3.Y == 0 then
		return UDim2.fromScale(1, 1)
	end

	local v5 = p2.X / p2.Y
	local v6 = p3.X / p3.Y

	if v6 < v5 then
		return UDim2.fromScale(1, v5 / v6)
	end

	return UDim2.fromScale(v6 / v5, 1)
end

return getCropSize
