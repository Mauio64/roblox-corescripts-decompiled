local equalObjects = require(script.Parent.Parent.equalObjects)

local function compare(list, list2): boolean
	if type(list) ~= "table" or type(list2) ~= "table" then
		return list == list2
	end

	if #list ~= #list2 then
		return false
	end

	for i = 1, #list do
		if list[i] ~= list2[i] then
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
