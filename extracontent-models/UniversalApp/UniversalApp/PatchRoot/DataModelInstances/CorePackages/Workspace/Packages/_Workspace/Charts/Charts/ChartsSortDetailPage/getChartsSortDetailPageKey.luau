local function serializeFilterSelections(t1: {[any]: any}?) -- line: 3
	if t1 == nil then
		return nil
	end

	local t2 = {}

	for v5 in t1 do
		table.insert(t2, v5)
	end

	if #t2 == 0 then
		return nil
	end

	table.sort(t2)

	local t3 = {}

	for _, v8 in t2 do
		table.insert(t3, `{ v8 }={ t1[v8] }`)
	end

	return table.concat(t3, "&")
end
local function getChartsSortDetailPageKey(s1: string?, s2: string?, t4: {[any]: any}?) -- line: 22
	-- upvalues: serializeFilterSelections (copy)
	local v12 = if s1 ~= nil and s1 ~= "" then if not s2 or s2 == "" then `ChartsSortDetail-{ s1 }` else `ChartsSortDetail-{ s1 }-{ s2 }` else "ChartsSortDetail-Unknown"
	local v13 = serializeFilterSelections(t4)

	if v13 then
		return `{ v12 }?{ v13 }`
	end

	return v12
end

return getChartsSortDetailPageKey
