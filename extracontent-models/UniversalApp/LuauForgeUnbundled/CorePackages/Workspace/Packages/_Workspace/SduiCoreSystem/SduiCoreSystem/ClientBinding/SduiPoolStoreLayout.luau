require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/CollectionViews")
local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/tutils")

require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiPoolStoreTypes")

local frozen = table.freeze({})

local function getSpanConfigAt(p2, p3)
	local v5 = p2[p3]

	if v5 == nil then
		return nil
	end

	local colSpan = v5.colSpan or 1
	local rowSpan = v5.rowSpan or 1
	local alignmentType = v5.alignmentType
	local minRowPadding = v5.minRowPadding or 0

	if colSpan == 1 and rowSpan == 1 and alignmentType == nil and minRowPadding == 0 then
		return nil
	end

	return {
		colSpan = colSpan,
		rowSpan = rowSpan,
		alignmentType = alignmentType,
		minRowPadding = minRowPadding
	}
end

return {
	EMPTY_CELLS = frozen,
	getSpanConfigAt = getSpanConfigAt,
	makePoolGetSpanConfig = function(p2)
		return function(p3, p4)
			return getSpanConfigAt(p2, p4)
		end
	end,
	layoutToCells = function(list, p2, p3, p4)
		if list == nil then
			return frozen, 0
		end

		local v5 = 0

		for k in list do
			if v5 < k then
				v5 = k
			end
		end

		if v5 == 0 then
			return frozen, 0
		end

		local result = {}

		for i = 1, v5 do
			local v6 = list[i] or {}

			for j = 1, p2 do
				local v7 = v6[j]

				if v7 == nil or not (v7 > 0) then
					table.insert(result, {})
				else
					local v8 = { item = p3[v7], realIndex = v7, spanOverride = 0 }

					local v9 = if p4 ~= nil then getSpanConfigAt(p4, v7) else nil
					v8.spanOverride = v9
					table.insert(result, v8)
				end
			end
		end

		return result, v5
	end,
	cellsEqual = function(list, list2): boolean
		if list == list2 then
			return true
		end

		if list == nil or list2 == nil or #list ~= #list2 then
			return false
		end

		for k, item in list do
			if not tutils.shallowEqual(item, list2[k]) then
				return false
			end
		end

		return true
	end
}
