local parent = script.Parent.Parent.Parent
require(parent.types)

return function(list, callback, p)
	if not callback then
		return (table.clone(list))
	end

	local count = #list
	local result = table.create(count)

	for i = 1, count do
		if p == nil then
			result[i] = callback(list[i], i)
		else
			result[i] = callback(p, list[i], i)
		end
	end

	return result
end
