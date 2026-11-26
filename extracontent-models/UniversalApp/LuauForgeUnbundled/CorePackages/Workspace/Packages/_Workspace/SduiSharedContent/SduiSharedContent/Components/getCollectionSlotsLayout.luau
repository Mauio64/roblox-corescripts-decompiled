local function getCollectionSlotsLayout(p2, data)
	local v5 = math.max(p2, 1)
	local sideMargin = data.sideMargin
	local columnGap = data.columnGap
	local function getColumnStep(p3)
		return (v5 - 2 * sideMargin - data.carouselPeek + (1 + data.fractionalItemAmount) * columnGap) / (p3 + data.fractionalItemAmount)
	end

	local function getSlotLayout(p3, p4, p5, p6, p7)
		local v6 = math.max(p4 - p3, 1)
		return {
			clipPosition = UDim2.fromScale(p3 / v5, 0),
			clipSize = UDim2.fromScale(v6 / v5, p7),
			position = UDim2.fromScale((p5 - p3) / v6, 0),
			size = UDim2.fromScale(math.max(p6, 0) / v6, p7)
		}
	end

	local leadingColumns = data.leadingColumns
	local leadingNumColumns = data.leadingNumColumns
	local v6 = leadingColumns * ((v5 - 2 * sideMargin - data.carouselPeek + (1 + data.fractionalItemAmount) * columnGap) / (leadingNumColumns + data.fractionalItemAmount))

	local trailingColumns = data.trailingColumns
	local trailingNumColumns = data.trailingNumColumns
	local v7 = trailingColumns * ((v5 - 2 * sideMargin - data.carouselPeek + (1 + data.fractionalItemAmount) * columnGap) / (trailingNumColumns + data.fractionalItemAmount))

	local v8 = sideMargin + v6
	local v9 = v5 - sideMargin - v7
	local v10

	if data.leadingColumns > 0 then
		v10 = getSlotLayout(sideMargin - columnGap / 2, v8 - columnGap / 2, sideMargin, v6 - columnGap, 1)
	end

	local v11

	if data.trailingColumns > 0 then
		v11 = getSlotLayout(
			v9 + columnGap / 2,
			v5 - sideMargin + columnGap / 2,
			v9 + columnGap,
			v7 - columnGap,
			1
		)
	end

	local v12 = if v10 then v8 - data.hoverOverflow else -data.bleed
	local v13 = if v11 then v9 + data.hoverOverflow else v5 + data.bleed
	return {
		leading = v10,
		content = getSlotLayout(v12, v13, v8, v9 - v8, 0),
		trailing = v11
	}
end

return getCollectionSlotsLayout
