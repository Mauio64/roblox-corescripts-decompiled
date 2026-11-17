local function getCollectionSlotsLayout(p: number, data)
	local v = math.max(p, 1)
	local sideMargin = data.sideMargin
	local columnGap = data.columnGap
	local function getColumnStep(p2: number) -- 2 equivalent calls inferred from this helper
		return (v - sideMargin * 2 - data.carouselPeek + (data.fractionalItemAmount + 1) * columnGap) / (p2 + data.fractionalItemAmount)
	end

	local function getSlotLayout(p2: number, p3: number, p4: number, p5: number, p6: number)
		local v2 = math.max(p3 - p2, 1)
		return {
			clipPosition = UDim2.fromScale(p2 / v, 0),
			clipSize = UDim2.fromScale(v2 / v, p6),
			position = UDim2.fromScale((p4 - p2) / v2, 0),
			size = UDim2.fromScale(math.max(p5, 0) / v2, p6)
		}
	end

	local v2 = data.leadingColumns * getColumnStep(data.leadingNumColumns) -- inferred equivalent call
	local v3 = data.trailingColumns * getColumnStep(data.trailingNumColumns) -- inferred equivalent call
	local v4 = sideMargin + v2
	local v5 = v - sideMargin - v3
	local leading

	if data.leadingColumns > 0 then
		leading = getSlotLayout(sideMargin - columnGap / 2, v4 - columnGap / 2, sideMargin, v2 - columnGap, 1)
	end

	local trailing

	if data.trailingColumns > 0 then
		trailing = getSlotLayout(v5 + columnGap / 2, v - sideMargin + columnGap / 2, v5 + columnGap, v3 - columnGap, 1)
	end

	local v6

	if leading then
		v6 = v4 - data.hoverOverflow
	else
		v6 = -data.bleed
	end

	local v7

	if trailing then
		v7 = v5 + data.hoverOverflow
	else
		v7 = v + data.bleed
	end

	return {
		leading = leading,
		content = getSlotLayout(v6, v7, v4, v5 - v4, 0),
		trailing = trailing
	}
end

return getCollectionSlotsLayout
