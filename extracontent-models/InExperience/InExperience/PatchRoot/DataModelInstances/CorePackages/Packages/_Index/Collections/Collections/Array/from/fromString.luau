local parent = script.Parent.Parent.Parent.Parent
require(parent.ES7Types)

return function(value: string, callback, p)
	local count = #value
	local result = table.create(count)

	if callback then
		for i = 1, count do
			if p == nil then
				result[i] = callback(string.sub(value, i, i), i)
			else
				result[i] = callback(p, string.sub(value, i, i), i)
			end
		end
	else
		for i = 1, count do
			result[i] = string.sub(value, i, i)
		end
	end

	return result
end
