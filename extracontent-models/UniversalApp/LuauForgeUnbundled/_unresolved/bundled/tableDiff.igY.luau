local v5 = newproxy(true)
getmetatable(v5).__tostring = function(): string
	return "<removed>"
end

local function tableDiff(items, items2, value)
	local v6 = value or 0

	if v6 == 10 then
		return nil
	end

	if items2 == nil then
		return v5
	end

	if typeof(items2) ~= "table" then
		return items2
	end

	local result = {}

	if (typeof)(items) == "table" then
		for k, item in pairs(items) do
			if items2[k] ~= item then
				result[k] = tableDiff(item, items2[k], v6 + 1)
			end
		end
	end

	for k, item in pairs(items2) do
		if (typeof)(items) ~= "table" or items[k] == nil then
			result[k] = tableDiff(nil, item, v6 + 1)
		end
	end

	if next(result) then
		return result
	end

	return nil
end

return tableDiff
