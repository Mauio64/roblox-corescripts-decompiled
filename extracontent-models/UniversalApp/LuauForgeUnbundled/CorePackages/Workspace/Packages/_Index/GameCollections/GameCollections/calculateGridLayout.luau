require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/DiscoveryTypes")
local reportWarning = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/DiscoveryAnalytics").Points.reportWarning

local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/LoggingProtocol")

local function removeFromAvailableCells(list, p2, p3)
	for i = 1, #list do
		local item = list[i]

		if item.X == p2 and item.Y == p3 then
			table.remove(list, i)
			break
		end
	end
end

local function markOccupiedCell(p2, p3, p4, p5, p6, p7, p8)
	p2[p4] = p2[p4] or {}
	p2[p4][p3] = p5

	local v5 = math.max(p6, p4)
	local v6 = math.max(p7, p3)

	if p8 then
		removeFromAvailableCells(p8, p3, p4)
	end

	return v5, v6
end

local function isCellOccupied(p2, p3, p4): boolean
	if p2[p4] then
		return p2[p4][p3] ~= nil
	end

	return false
end

local function canInsertItem(p2, p3, p4, p5, p6, p7): boolean
	if p7 < p3 + p5 - 1 then
		return false
	end

	for i = 0, p6 - 1 do
		for j = 0, p5 - 1 do
			local v5 = p3 + j
			local v6 = p4 + i
			local v7 = if p2[v6] then p2[v6][v5] ~= nil else false

			if v7 then
				return false
			end
		end
	end

	return true
end

local function markItemCells(p2, p3, p4, p5, p6, p7, p8, p9, availableCells)
	p2[p4] = p2[p4] or {}
	p2[p4][p3] = p5

	local v5 = math.max(p8, p4)
	local v6 = math.max(p9, p3)

	if availableCells then
		removeFromAvailableCells(availableCells, p3, p4)
	end

	for i = 0, p7 - 1 do
		for j = 0, p6 - 1 do
			if not (j ~= 0 or i ~= 0) then
				continue
			end

			local v7 = p3 + j
			local v8 = p4 + i
			p2[v8] = p2[v8] or {}
			p2[v8][v7] = -1

			v5 = math.max(v5, v8)
			v6 = math.max(v6, v7)

			if availableCells then
				removeFromAvailableCells(availableCells, v7, v8)
			end
		end
	end

	return v5, v6
end

local function findPinnedInsertionPointAndMarkOccupiedItem(p2, i, colSpan, rowSpan, p3, p4, p5, state, p6, value, p7)
	local v5 = value or 1

	if p3 < colSpan then
		reportWarning(
			LoggingProtocol.default,
			"InvalidGrid",
			`Item {i} has colSpan {colSpan} greater than itemsPerRow {p3}`
		)

		return p4, p5, nil
	end

	if p6 < 1 or p3 < p6 + colSpan - 1 then
		reportWarning(
			LoggingProtocol.default,
			"InvalidGrid",
			`Item {i} cannot be pinned at column {p6} with colSpan {colSpan} in grid with {p3} columns`
		)

		return p4, p5, nil
	end

	while v5 <= p7 do
		if state.lastRow < v5 then
			local lastRow = state.lastRow
			state.lastRow = v5

			for j = lastRow * p3 + 1, v5 * p3 do
				table.insert(
					state.availableCells,
					Vector2.new((j - 1) % p3 + 1, math.floor((j - 1) / p3) + 1)
				)
			end
		end

		if canInsertItem(p2, p6, v5, colSpan, rowSpan, p3) then
			local v6, v7 = markItemCells(p2, p6, v5, i, colSpan, rowSpan, p4, p5, state.availableCells)

			return v6, v7, v5
		end

		v5 += 1
	end

	reportWarning(
		LoggingProtocol.default,
		"InvalidGrid",
		`Item {i} at column {p6} with colSpan {colSpan} could not be placed within allowed rows`
	)

	return p4, p5, nil
end

local function findInsertionPointAndMarkOccupiedItem(p2, i, colSpan, rowSpan, p3, p4, p5, state)
	if p3 < colSpan then
		reportWarning(
			LoggingProtocol.default,
			"InvalidGrid",
			`Item {i} has colSpan {colSpan} greater than itemsPerRow {p3}`
		)

		return p4, p5
	end

	if p4 + 1 > state.lastRow then
		local lastRow = state.lastRow
		local v5 = p4 + 1
		state.lastRow = v5

		for j = lastRow * p3 + 1, v5 * p3 do
			table.insert(state.availableCells, Vector2.new((j - 1) % p3 + 1, math.floor((j - 1) / p3) + 1))
		end
	end

	local v5 = 1

	while v5 <= #state.availableCells do
		local availableCell = state.availableCells[v5]
		local x = availableCell.X
		local y = availableCell.Y

		if canInsertItem(p2, x, y, colSpan, rowSpan, p3) then
			local v6, v7 = markItemCells(p2, x, y, i, colSpan, rowSpan, p4, p5, state.availableCells)

			return v6, v7
		end

		v5 += 1
	end

	return p4, p5
end

local function calculateGridLayout(p2, p3, list)
	if not p3 or p3 <= 0 then
		return { layout = {}, totalRows = 0, totalCols = 0 }
	end

	local total = 0
	local v5 = {}
	local v6 = 0
	local v7 = 0
	local v8 = { lastRow = 0, availableCells = {} }
	local v9 = 1
	local v10 = false

	for i = 1, p2 do
		local v11 = list and list[i]
		total += (v11 and v11.colSpan or 1) * (v11 and v11.rowSpan or 1)
	end

	local v11 = math.ceil(total / p3)

	local v12 = if total % p3 == 0 then v11 else math.max(1, v11 - 1)

	for i = 1, p2 do
		local colSpan = list and list[i] and list[i].colSpan or 1
		local rowSpan = list and list[i] and list[i].rowSpan or 1
		local alignmentType = if list and list[i] then list[i].alignmentType or nil else nil
		local minRowPadding = list and list[i] and list[i].minRowPadding or 0
		v10 = (colSpan ~= 1 or rowSpan ~= 1 or alignmentType) and true or v10

		if v10 then
			if alignmentType == "RightPin" then
				local v14
				v6, v7, v14 = findPinnedInsertionPointAndMarkOccupiedItem(
					v5,
					i,
					colSpan,
					rowSpan,
					p3,
					v6,
					v7,
					v8,
					p3 - colSpan + 1,
					v9,
					v12
				)

				if v14 and minRowPadding and minRowPadding > 0 then
					v9 = v14 + minRowPadding
				end
			elseif alignmentType == "LeftPin" then
				local v13
				v6, v7, v13 = findPinnedInsertionPointAndMarkOccupiedItem(
					v5,
					i,
					colSpan,
					rowSpan,
					p3,
					v6,
					v7,
					v8,
					1,
					v9,
					v11
				)

				if v13 and minRowPadding and minRowPadding > 0 then
					v9 = v13 + minRowPadding
				end
			else
				v6, v7 = findInsertionPointAndMarkOccupiedItem(v5, i, colSpan, rowSpan, p3, v6, v7, v8)
			end
		else
			local v13 = (i - 1) % p3 + 1
			local v14 = math.floor((i - 1) / p3) + 1
			v5[v14] = v5[v14] or {}
			v5[v14][v13] = i

			v6 = math.max(v6, v14)
			v7 = math.max(v7, v13)
		end
	end

	return { layout = v5, totalRows = v6, totalCols = v7 }
end

return calculateGridLayout
