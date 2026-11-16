local function verifySummaryFormat(items, items2): boolean
	if items == nil or typeof(items) ~= "table" then
		return false
	end

	local set = {}

	for _, item in items2 do
		set[item] = true
	end

	for _, item in items2 do
		if items[item] == nil or typeof(items[item]) ~= "number" then
			return false
		end
	end

	for k, _ in items do
		if not set[k] then
			return false
		end
	end

	return true
end

return verifySummaryFormat
