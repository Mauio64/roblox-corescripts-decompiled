local function isTapRelease(p2, p3): boolean
	if p2 == nil or p3 == nil then
		return true
	end

	local v5 = p3.Position - p2
	return Vector2.new(v5.X, v5.Y).Magnitude <= 10
end

return isTapRelease
