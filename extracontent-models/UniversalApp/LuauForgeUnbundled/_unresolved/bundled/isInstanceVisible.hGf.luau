local function isInstanceVisible(p2, p3, p4)
	local absoluteSize = p2.AbsoluteSize

	if absoluteSize.X <= 0 or absoluteSize.Y <= 0 then
		return false
	end

	local absolutePosition = p2.AbsolutePosition
	local v5 = absolutePosition + absoluteSize

	local v6 = v5.X > p3.X and absolutePosition.X < p4.X
	local v7 = v5.Y > p3.Y and absolutePosition.Y < p4.Y

	return v6 and v7
end

return isInstanceVisible
