local function serializeFilterSelections(items)
	if items == nil then
		return nil
	end

	local v5 = {}

	for k in items do
		table.insert(v5, k)
	end

	if #v5 == 0 then
		return nil
	end

	table.sort(v5)
	local v6 = {}

	for k, v7 in v5 do
		table.insert(v6, `{v7}={items[v7]}`)
	end

	return table.concat(v6, "&")
end

local function getChartsSortDetailPageKey(p2, p3, p4)
	local v5

	if p2 == nil or p2 == "" then
		v5 = "ChartsSortDetail-Unknown"
	else
		v5 = if p3 and p3 ~= "" then `ChartsSortDetail-{p2}-{p3}` else `ChartsSortDetail-{p2}`
	end

	local v6 = serializeFilterSelections(p4)

	if v6 then
		return `{v5}?{v6}`
	end

	return v5
end

return getChartsSortDetailPageKey
