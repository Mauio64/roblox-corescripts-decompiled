local function getScale(p2, p3, p4)
	if p2.X == 0 or p2.Y == 0 or p3.X == 0 or p3.Y == 0 then
		return 1
	end

	local v5 = p2.X / p2.Y
	local v6 = p3.X / p3.Y

	return (if (p4 == Enum.ScaleType.Fit) == (v5 < v6) then p2.X else p2.Y * v6) / 1280
end

return getScale
