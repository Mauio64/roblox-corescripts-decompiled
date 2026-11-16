local equalObjects = require(script.Parent.Parent.equalObjects)

local function compare(items, items2): boolean
	if type(items) ~= "table" or type(items2) ~= "table" then
		return items == items2
	end

	for k, item in items do
		if items2[k] ~= item then
			return false
		end
	end

	for k, item in items2 do
		if items[k] ~= item then
			return false
		end
	end

	return true
end

local function equals(...): boolean
	if equalObjects(...) then
		return true
	end

	local v = select("#", ...)
	local v2 = select(1, ...)

	for i = 2, v do
		if not compare(v2, select(i, ...)) then
			return false
		end
	end

	return true
end

return equals
