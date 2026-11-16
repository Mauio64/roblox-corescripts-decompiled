local function serializeFilterSelections(items)
	if items == nil then
		return nil
	end

	local v = {}

	for k in items do
		table.insert(v, k)
	end

	if #v == 0 then
		return nil
	end

	table.sort(v)
	local v2 = {}

	for _, v3 in v do
		table.insert(v2, `{v3}={items[v3]}`)
	end

	return table.concat(v2, "&")
end

local function getChartsSortDetailPageKey(p: string?, p2: string?, p3)
	local v

	if p == nil or p == "" then
		v = "ChartsSortDetail-Unknown"
	elseif p2 and p2 ~= "" then
		v = `ChartsSortDetail-{p}-{p2}`
	else
		v = `ChartsSortDetail-{p}`
	end

	local v2 = serializeFilterSelections(p3)

	if v2 then
		return `{v}?{v2}`
	end

	return v
end

return getChartsSortDetailPageKey
