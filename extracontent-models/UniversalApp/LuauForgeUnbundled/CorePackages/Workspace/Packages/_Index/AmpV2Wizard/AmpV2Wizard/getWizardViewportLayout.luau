local function getWizardViewportLayout(p2, p3, data)
	local v5 = p3.Min + Vector2.new(data.left, data.top)
	local v6 = p3.Max - Vector2.new(data.right, data.bottom)
	local v7 = p2.Max - p2.Min
	local v8 = math.clamp(v5.X - p2.Min.X, 0, v7.X)
	local v9 = math.clamp(v5.Y - p2.Min.Y, 0, v7.Y)
	local v10 = math.clamp(p2.Max.X - v6.X, 0, v7.X - v8)
	local v11 = math.clamp(p2.Max.Y - v6.Y, 0, v7.Y - v9)
	local v12 = not (p2.Min.X <= v5.X) and 0 or math.max(0, p2.Min.X - p3.Min.X)
	local v13 = not (p2.Min.Y <= v5.Y) and 0 or math.max(0, p2.Min.Y - p3.Min.Y)
	local v14 = not (p2.Max.X >= v6.X) and 0 or math.max(0, p3.Max.X - p2.Max.X)
	local v15 = not (p2.Max.Y >= v6.Y) and 0 or math.max(0, p3.Max.Y - p2.Max.Y)

	return {
		contentPosition = UDim2.fromOffset(v8, v9),
		contentSize = UDim2.new(1, -v8 - v10, 1, -v9 - v11),
		backgroundPosition = UDim2.fromOffset(-v12, -v13),
		backgroundSize = UDim2.new(1, v12 + v14, 1, v13 + v15)
	}
end

return getWizardViewportLayout
