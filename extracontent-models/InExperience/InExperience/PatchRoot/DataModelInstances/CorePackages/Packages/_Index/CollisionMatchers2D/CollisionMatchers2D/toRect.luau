local function toRect(p)
	local typeName = typeof(p)

	if typeName == "Rect" then
		return p
	elseif typeName == "Instance" then
		return Rect.new(p.AbsolutePosition, p.AbsolutePosition + p.AbsoluteSize)
	end
end

return toRect
