local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local parent = SduiCoreSystem.Parent

require(parent.CollectionViews)
local tutils = require(parent.tutils)

require(SduiCoreSystem.ClientBinding.SduiPoolStoreTypes)

local frozen = table.freeze({})

local function getSpanConfigAt(p, p2: number)
	local v = p[p2]

	if v == nil then
		return nil
	end

	local colSpan = v.colSpan or 1
	local rowSpan = v.rowSpan or 1
	local alignmentType = v.alignmentType
	local minRowPadding = v.minRowPadding or 0

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

local SduiPoolStoreLayout = {}
SduiPoolStoreLayout.EMPTY_CELLS = frozen
SduiPoolStoreLayout.getSpanConfigAt = getSpanConfigAt

function SduiPoolStoreLayout.makePoolGetSpanConfig(p)
	return function(_, p2: number)
		return getSpanConfigAt(p, p2)
	end
end

function SduiPoolStoreLayout.layoutToCells(list, p: number, p2, p3)
	if list == nil then
		return frozen, 0
	end

	local v = 0

	for k in list do
		if v < k then
			v = k
		end
	end

	if v == 0 then
		return frozen, 0
	end

	local result = {}

	for i = 1, v do
		local v2 = list[i] or {}

		for j = 1, p do
			local realIndex = v2[j]

			if realIndex == nil or not (realIndex > 0) then
				table.insert(result, {})
			else
				local v3 = { item = p2[realIndex], realIndex = realIndex, spanOverride = 0 }
				local spanOverride

				if p3 ~= nil then
					spanOverride = getSpanConfigAt(p3, realIndex)
				end

				v3.spanOverride = spanOverride
				table.insert(result, v3)
			end
		end
	end

	return result, v
end

function SduiPoolStoreLayout.cellsEqual(list, list2): boolean
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

return SduiPoolStoreLayout
