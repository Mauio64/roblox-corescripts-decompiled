local parent = script:FindFirstAncestor("GameCollections").Parent

require(parent.DiscoveryTypes)
local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local reportWarning = DiscoveryAnalytics.Points.reportWarning

local LoggingProtocol = require(parent.LoggingProtocol)

local function removeFromAvailableCells(list, p: number, p2: number)
	for i = 1, #list do
		local item = list[i]

		if item.X == p and item.Y == p2 then
			table.remove(list, i)
			break
		end
	end
end

local function markOccupiedCell(p, p2: number, p3: number, p4: number, p5: number, p6: number, p7) -- 1 equivalent call inferred from this helper
	p[p3] = p[p3] or {}
	p[p3][p2] = p4

	local v = math.max(p5, p3)
	local v2 = math.max(p6, p2)

	if p7 then
		removeFromAvailableCells(p7, p2, p3)
	end

	return v, v2
end

local function isCellOccupied(p, p2: number, p3: number): boolean -- 1 equivalent call inferred from this helper
	if p[p3] then
		return p[p3][p2] ~= nil
	end

	return false
end

local function canInsertItem(p, p2: number, p3: number, p4: number, p5: number, p6: number): boolean
	if p6 < p2 + p4 - 1 then
		return false
	end

	for i = 0, p5 - 1 do
		for j = 0, p4 - 1 do
			if isCellOccupied(p, p2 + j, p3 + i) then -- inferred equivalent call
				return false
			end
		end
	end

	return true
end

local function markItemCells(p, p2: number, p3: number, p4: number, p5: number, p6: number, p7: number, p8: number, availableCells)
	local v, maxValue = markOccupiedCell(p, p2, p3, p4, p7, p8, availableCells) -- inferred equivalent call

	for i = 0, p6 - 1 do
		for j = 0, p5 - 1 do
			if not (j ~= 0 or i ~= 0) then
				continue
			end

			local v2 = p2 + j
			local v3 = p3 + i
			p[v3] = p[v3] or {}
			p[v3][v2] = -1

			v = math.max(v, v3)
			maxValue = math.max(maxValue, v2)

			if availableCells then
				removeFromAvailableCells(availableCells, v2, v3)
			end
		end
	end

	return v, maxValue
end

local function findPinnedInsertionPointAndMarkOccupiedItem(p, i: number, colSpan: number, rowSpan: number, p2: number, p3: number, p4: number, state, p5: number, value: number, p6: number)
	local lastRow2 = value or 1

	if p2 < colSpan then
		reportWarning(
			LoggingProtocol.default,
			"InvalidGrid",
			`Item {i} has colSpan {colSpan} greater than itemsPerRow {p2}`
		)

		return p3, p4, nil
	end

	if p5 < 1 or p2 < p5 + colSpan - 1 then
		reportWarning(
			LoggingProtocol.default,
			"InvalidGrid",
			`Item {i} cannot be pinned at column {p5} with colSpan {colSpan} in grid with {p2} columns`
		)

		return p3, p4, nil
	end

	while lastRow2 <= p6 do
		if state.lastRow < lastRow2 then
			local lastRow = state.lastRow
			state.lastRow = lastRow2

			for j = lastRow * p2 + 1, lastRow2 * p2 do
				table.insert(state.availableCells, Vector2.new((j - 1) % p2 + 1, math.floor((j - 1) / p2) + 1))
			end
		end

		if canInsertItem(p, p5, lastRow2, colSpan, rowSpan, p2) then
			local v, v2 = markItemCells(p, p5, lastRow2, i, colSpan, rowSpan, p3, p4, state.availableCells)

			return v, v2, lastRow2
		end

		lastRow2 += 1
	end

	reportWarning(
		LoggingProtocol.default,
		"InvalidGrid",
		`Item {i} at column {p5} with colSpan {colSpan} could not be placed within allowed rows`
	)

	return p3, p4, nil
end

local function findInsertionPointAndMarkOccupiedItem(p, i: number, colSpan: number, rowSpan: number, p2: number, p3: number, p4: number, state)
	if p2 < colSpan then
		reportWarning(
			LoggingProtocol.default,
			"InvalidGrid",
			`Item {i} has colSpan {colSpan} greater than itemsPerRow {p2}`
		)

		return p3, p4
	end

	if p3 + 1 > state.lastRow then
		local lastRow = state.lastRow
		local lastRow2 = p3 + 1
		state.lastRow = lastRow2

		for j = lastRow * p2 + 1, lastRow2 * p2 do
			table.insert(state.availableCells, Vector2.new((j - 1) % p2 + 1, math.floor((j - 1) / p2) + 1))
		end
	end

	local v = 1

	while v <= #state.availableCells do
		local availableCell = state.availableCells[v]
		local x = availableCell.X
		local y = availableCell.Y

		if canInsertItem(p, x, y, colSpan, rowSpan, p2) then
			local v2, v3 = markItemCells(p, x, y, i, colSpan, rowSpan, p3, p4, state.availableCells)

			return v2, v3
		end

		v += 1
	end

	return p3, p4
end

local function calculateGridLayout(p: number, p2: number, list)
	if not p2 or p2 <= 0 then
		return { layout = {}, totalRows = 0, totalCols = 0 }
	end

	local total = 0
	local layout = {}
	local totalRows = 0
	local totalCols = 0
	local v = { lastRow = 0, availableCells = {} }
	local v2 = 1
	local v3 = false

	for i = 1, p do
		local v4 = list and list[i]
		total += (v4 and v4.colSpan or 1) * (v4 and v4.rowSpan or 1)
	end

	local v4 = math.ceil(total / p2)
	local v5

	if total % p2 == 0 then
		v5 = v4
	else
		v5 = math.max(1, v4 - 1)
	end

	for i = 1, p do
		local colSpan = list and list[i] and list[i].colSpan or 1
		local rowSpan = list and list[i] and list[i].rowSpan or 1
		local alignmentType

		if list and list[i] then
			alignmentType = list[i].alignmentType or nil
		end

		local minRowPadding = list and list[i] and list[i].minRowPadding or 0
		v3 = (colSpan ~= 1 or rowSpan ~= 1 or alignmentType) and true or v3

		if v3 then
			if alignmentType == "RightPin" then
				local v6
				totalRows, totalCols, v6 = findPinnedInsertionPointAndMarkOccupiedItem(
					layout,
					i,
					colSpan,
					rowSpan,
					p2,
					totalRows,
					totalCols,
					v,
					p2 - colSpan + 1,
					v2,
					v5
				)

				if v6 and minRowPadding and minRowPadding > 0 then
					v2 = v6 + minRowPadding
				end
			elseif alignmentType == "LeftPin" then
				local v6
				totalRows, totalCols, v6 = findPinnedInsertionPointAndMarkOccupiedItem(
					layout,
					i,
					colSpan,
					rowSpan,
					p2,
					totalRows,
					totalCols,
					v,
					1,
					v2,
					v4
				)

				if v6 and minRowPadding and minRowPadding > 0 then
					v2 = v6 + minRowPadding
				end
			else
				totalRows, totalCols = findInsertionPointAndMarkOccupiedItem(
					layout,
					i,
					colSpan,
					rowSpan,
					p2,
					totalRows,
					totalCols,
					v
				)
			end
		else
			local v6 = (i - 1) % p2 + 1
			local v7 = math.floor((i - 1) / p2) + 1
			layout[v7] = layout[v7] or {}
			layout[v7][v6] = i

			totalRows = math.max(totalRows, v7)
			totalCols = math.max(totalCols, v6)
		end
	end

	return { layout = layout, totalRows = totalRows, totalCols = totalCols }
end

return calculateGridLayout
