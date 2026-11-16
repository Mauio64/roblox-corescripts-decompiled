local function subtract(items, ...)
	local result = {}

	for k, _ in pairs(items) do
		result[k] = true
	end

	for i = 1, select("#", ...) do
		result[select(i, ...)] = nil
	end

	return result
end

return subtract
