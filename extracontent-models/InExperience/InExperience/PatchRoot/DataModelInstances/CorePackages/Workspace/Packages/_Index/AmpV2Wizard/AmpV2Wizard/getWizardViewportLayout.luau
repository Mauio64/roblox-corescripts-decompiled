local function getWizardViewportLayout(rect: Rect, rect2: Rect, data)
	local v = rect2.Min + Vector2.new(data.left, data.top)
	local v2 = rect2.Max - Vector2.new(data.right, data.bottom)
	local v3 = rect.Max - rect.Min
	local v4 = math.clamp(v.X - rect.Min.X, 0, v3.X)
	local v5 = math.clamp(v.Y - rect.Min.Y, 0, v3.Y)
	local v6 = math.clamp(rect.Max.X - v2.X, 0, v3.X - v4)
	local v7 = math.clamp(rect.Max.Y - v2.Y, 0, v3.Y - v5)
	local v8 = not (rect.Min.X <= v.X) and 0 or math.max(0, rect.Min.X - rect2.Min.X)
	local v9 = not (rect.Min.Y <= v.Y) and 0 or math.max(0, rect.Min.Y - rect2.Min.Y)
	local v10 = not (rect.Max.X >= v2.X) and 0 or math.max(0, rect2.Max.X - rect.Max.X)
	local v11 = not (rect.Max.Y >= v2.Y) and 0 or math.max(0, rect2.Max.Y - rect.Max.Y)

	return {
		contentPosition = UDim2.fromOffset(v4, v5),
		contentSize = UDim2.new(1, -v4 - v6, 1, -v5 - v7),
		backgroundPosition = UDim2.fromOffset(-v8, -v9),
		backgroundSize = UDim2.new(1, v8 + v10, 1, v9 + v11)
	}
end

return getWizardViewportLayout
