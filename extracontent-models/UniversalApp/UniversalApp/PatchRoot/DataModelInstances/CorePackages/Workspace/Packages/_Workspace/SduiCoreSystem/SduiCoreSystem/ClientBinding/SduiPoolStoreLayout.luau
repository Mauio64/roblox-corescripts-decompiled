local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent

require(SduiCoreSystemParent.CollectionViews)

local tutils = require(SduiCoreSystemParent.tutils)

require(SduiCoreSystem.ClientBinding.SduiPoolStoreTypes)

local v4 = table.freeze({})

local function getSpanConfigAt(t1: {[any]: any}, n1: number) -- line: 19
	local v8 = t1[n1]

	if v8 == nil then
		return nil
	end

	local v9 = v8.colSpan or 1
	local v10 = v8.rowSpan or 1
	local alignmentType = v8.alignmentType
	local v12 = v8.minRowPadding or 0

	if v9 == 1 and v10 == 1 and alignmentType == nil and v12 == 0 then
		return nil
	end

	return {
		colSpan = v9,
		rowSpan = v10,
		alignmentType = alignmentType,
		minRowPadding = v12
	}
end

return {
	EMPTY_CELLS = v4,
	getSpanConfigAt = getSpanConfigAt,
	makePoolGetSpanConfig = function(t2: {[any]: any}) -- line: 40
		-- upvalues: getSpanConfigAt (copy)
		return function(_, n2: number) -- line: 41
			-- upvalues: getSpanConfigAt (copy), t2 (copy)
			return (getSpanConfigAt(t2, n2))
		end
	end,
	layoutToCells = function(t3: {[any]: any}?, n3: number, t4: {[any]: any}, t5: {[any]: any}?) -- line: 47
		-- upvalues: v4 (copy), getSpanConfigAt (copy)
		if t3 == nil then
			return v4, 0
		end

		local n4 = 0

		for v19 in t3 do
			if n4 < v19 then
				n4 = v19
			end
		end

		if n4 == 0 then
			return v4, 0
		end

		local t6 = {}

		for i = 1, n4 do
			local v22 = t3[i] or {}

			for j = 1, n3 do
				local v24 = v22[j]

				if v24 ~= nil and v24 > 0 then
					table.insert(t6, {
						item = t4[v24],
						realIndex = v24,
						spanOverride = if t5 == nil then nil else getSpanConfigAt(t5, v24)
					})
				else
					table.insert(t6, {})
				end
			end
		end

		return t6, n4
	end,
	cellsEqual = function(t7: {[any]: any}?, t8: {[any]: any}?) -- line: 87
		-- upvalues: tutils (copy)
		if t7 == t8 then
			return true
		end

		if t7 == nil or t8 == nil then
			return false
		end

		if #t7 ~= #t8 then
			return false
		end

		for v27, v28 in t7 do
			if not tutils.shallowEqual(v28, t8[v27]) then
				return false
			end
		end

		return true
	end
}
