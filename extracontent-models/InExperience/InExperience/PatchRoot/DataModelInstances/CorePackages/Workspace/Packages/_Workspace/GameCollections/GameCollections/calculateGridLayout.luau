local Parent = script:FindFirstAncestor("GameCollections").Parent

require(Parent.DiscoveryTypes)

local reportWarning = require(Parent.DiscoveryAnalytics).Points.reportWarning
local LoggingProtocol = require(Parent.LoggingProtocol)

local function removeFromAvailableCells(t1: {[any]: any}, n1: number, n2: number) -- line: 18
	for i = 1, #t1 do
		local v16 = t1[i]

		if n1 == v16.X and n2 == v16.Y then
			table.remove(t1, i)

			return
		end
	end
end
local function markOccupiedCell(t2: {[any]: any}, n3: number, n4: number, n5: number, n6: number, n7: number, t3: {[any]: any}?) -- line: 28
	-- upvalues: removeFromAvailableCells (copy)
	t2[n4] = t2[n4] or {}
	t2[n4][n3] = n5

	local v24 = math.max(n6, n4)
	local v25 = math.max(n7, n3)

	if t3 then
		removeFromAvailableCells(t3, n3, n4)
	end

	return v24, v25
end
local function isCellOccupied(t4: {[any]: any}, n8: number, n9: number) -- line: 53
	if t4[n9] then
		return t4[n9][n8] ~= nil
	end

	return false
end
local function canInsertItem(t5: {[any]: any}, n10: number, n11: number, n12: number, n13: number, n14: number) -- line: 60
	if n14 < n10 + n12 - 1 then
		return false
	end

	for i = 0, n13 - 1 do
		for j = 0, n12 - 1 do
			local v37 = n10 + j
			local v38 = n11 + i

			if not not t5[v38] and t5[v38][v37] ~= nil then
				return false
			end
		end
	end

	return true
end
local function markItemCells(t6: {[any]: any}, n15: number, n16: number, n17: number, n18: number, n19: number, n20: number, n21: number, t7: {[any]: any}?) -- line: 85
	-- upvalues: removeFromAvailableCells (copy)
	t6[n16] = t6[n16] or {}
	t6[n16][n15] = n17

	local v48 = math.max(n20, n16)
	local v49 = math.max(n21, n15)

	if t7 then
		removeFromAvailableCells(t7, n15, n16)
	end

	for i = 0, n19 - 1 do
		for j = 0, n18 - 1 do
			if j ~= 0 or i ~= 0 then
				local v52 = n15 + j
				local v53 = n16 + i

				t6[v53] = t6[v53] or {}
				t6[v53][v52] = -1
				v48 = math.max(v48, v53)
				v49 = math.max(v49, v52)

				if t7 then
					removeFromAvailableCells(t7, v52, v53)
				end
			end
		end
	end

	return v48, v49
end
local function findPinnedInsertionPointAndMarkOccupiedItem(t8: {[any]: any}, n22: number, n23: number, n24: number, n25: number, n26: number, n27: number, t9: {[any]: any}, n28: number, n29: number, n30: number) -- line: 114
	-- upvalues: reportWarning (copy), LoggingProtocol (copy), canInsertItem (copy), markItemCells (copy)
	local v65 = n29 or 1

	if n25 < n23 then
		reportWarning(LoggingProtocol.default, "InvalidGrid", `Item { n22 } has colSpan { n23 } greater than itemsPerRow { n25 }`)

		return n26, n27, nil
	end

	if n28 < 1 or n25 < n28 + n23 - 1 then
		reportWarning(LoggingProtocol.default, "InvalidGrid", `Item { n22 } cannot be pinned at column { n28 } with colSpan { n23 } in grid with { n25 } columns`)

		return n26, n27, nil
	end

	while v65 <= n30 do
		if v65 > t9.lastRow then
			local lastRow = t9.lastRow

			t9.lastRow = v65

			for i = lastRow * n25 + 1, v65 * n25 do
				table.insert(t9.availableCells, Vector2.new((i - 1) % n25 + 1, math.floor((i - 1) / n25) + 1))
			end
		end

		if canInsertItem(t8, n28, v65, n23, n24, n25) then
			local v68, v69 = markItemCells(t8, n28, v65, n22, n23, n24, n26, n27, t9.availableCells)

			return v68, v69, v65
		end

		v65 += 1
	end

	reportWarning(LoggingProtocol.default, "InvalidGrid", `Item { n22 } at column { n28 } with colSpan { n23 } could not be placed within allowed rows`)

	return n26, n27, nil
end
local function findInsertionPointAndMarkOccupiedItem(t10: {[any]: any}, n31: number, n32: number, n33: number, n34: number, n35: number, n36: number, t11: {[any]: any}) -- line: 187
	-- upvalues: reportWarning (copy), LoggingProtocol (copy), canInsertItem (copy), markItemCells (copy)
	if n34 < n32 then
		reportWarning(LoggingProtocol.default, "InvalidGrid", `Item { n31 } has colSpan { n32 } greater than itemsPerRow { n34 }`)

		return n35, n36
	end

	if n35 + 1 > t11.lastRow then
		local lastRow = t11.lastRow
		local v79 = n35 + 1

		t11.lastRow = v79

		for i = lastRow * n34 + 1, v79 * n34 do
			table.insert(t11.availableCells, Vector2.new((i - 1) % n34 + 1, math.floor((i - 1) / n34) + 1))
		end
	end

	local n37 = 1

	while n37 <= #t11.availableCells do
		local v82 = t11.availableCells[n37]
		local X = v82.X
		local Y = v82.Y

		if canInsertItem(t10, X, Y, n32, n33, n34) then
			local v85, v86 = markItemCells(t10, X, Y, n31, n32, n33, n35, n36, t11.availableCells)

			return v85, v86
		end

		n37 += 1
	end

	return n35, n36
end
local function calculateGridLayout(n38: number, n39: number, t12: {[any]: any}?) -- line: 256
	-- upvalues: findPinnedInsertionPointAndMarkOccupiedItem (copy), findInsertionPointAndMarkOccupiedItem (copy)
	if not n39 or n39 <= 0 then
		return {
			totalRows = 0,
			totalCols = 0,
			layout = {}
		}
	end

	local t13 = {}
	local n40 = 0
	local n41 = 0
	local t14 = {
		lastRow = 0,
		availableCells = {}
	}
	local v94 = false
	local n42 = 1
	local n43 = 0

	for i = 1, n38 do
		local v98 = t12 and t12[i]

		n43 += (v98 and v98.colSpan or 1) * (v98 and v98.rowSpan or 1)
	end

	local v99 = math.ceil(n43 / n39)
	local v100 = if n43 % n39 ~= 0 then math.max(1, v99 - 1) else v99

	for i = 1, n38 do
		local v102 = t12 and (not not t12[i] and t12[i].colSpan) or 1
		local v103 = t12 and (not not t12[i] and t12[i].rowSpan) or 1
		local v104 = t12 and (not not t12[i] and t12[i].alignmentType) or nil
		local v105 = t12 and (not not t12[i] and t12[i].minRowPadding) or 0

		if v102 ~= 1 or v103 ~= 1 or v104 then
			v94 = true
		end

		if v94 then
			if v104 == "RightPin" then
				local v106 = n39 - v102 + 1
				local v107

				n40, n41, v107 = findPinnedInsertionPointAndMarkOccupiedItem(t13, i, v102, v103, n39, n40, n41, t14, v106, n42, v100)

				if v107 and v105 and v105 > 0 then
					n42 = v107 + v105
				end
			elseif v104 == "LeftPin" then
				local v108

				n40, n41, v108 = findPinnedInsertionPointAndMarkOccupiedItem(t13, i, v102, v103, n39, n40, n41, t14, 1, n42, v99)

				if v108 and v105 and v105 > 0 then
					n42 = v108 + v105
				end
			else
				n40, n41 = findInsertionPointAndMarkOccupiedItem(t13, i, v102, v103, n39, n40, n41, t14)
			end
		else
			local v109 = (i - 1) % n39 + 1
			local v110 = math.floor((i - 1) / n39) + 1

			t13[v110] = t13[v110] or {}
			t13[v110][v109] = i
			n40 = math.max(n40, v110)
			n41 = math.max(n41, v109)
		end
	end

	return {
		layout = t13,
		totalRows = n40,
		totalCols = n41
	}
end

return calculateGridLayout
