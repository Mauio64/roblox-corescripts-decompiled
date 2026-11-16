local objectIs = require(script.Parent.objectIs)

local function shallowEqual(items, items2): boolean
	if objectIs(items, items2) then
		return true
	end

	if typeof(items) ~= "table" or items == nil or typeof(items2) ~= "table" or items2 == nil then
		return false
	end

	for k, item in items do
		if not objectIs(items2[k], item) then
			return false
		end
	end

	for k, item in items2 do
		if not objectIs(items[k], item) then
			return false
		end
	end

	return true
end

return shallowEqual
