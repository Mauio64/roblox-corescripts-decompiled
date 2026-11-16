local parent = script.Parent
require(parent.Types)

local function iterator(value)
	if typeof(value) == "function" then
		return value
	end

	if typeof(value) ~= "table" then
		return nil
	end

	if #value > 0 then
		return ipairs(value)
	end

	return pairs(value)
end

return iterator
