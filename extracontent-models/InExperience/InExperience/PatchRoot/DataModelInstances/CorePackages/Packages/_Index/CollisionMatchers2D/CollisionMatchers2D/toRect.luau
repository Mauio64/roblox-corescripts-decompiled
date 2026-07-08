local function toRect(p1) -- line: 11
	local v3 = typeof(p1)

	if v3 == "Rect" then
		return p1
	end

	if v3 == "Instance" then
		return Rect.new(p1.AbsolutePosition, p1.AbsolutePosition + p1.AbsoluteSize)
	end
end

return toRect
