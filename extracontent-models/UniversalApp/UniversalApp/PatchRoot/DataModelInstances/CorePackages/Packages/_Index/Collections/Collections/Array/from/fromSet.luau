local parent = script.Parent.Parent.Parent.Parent
require(parent.ES7Types)

return function(p, callback, p2)
	if not callback then
		return (table.clone(p._array))
	end

	local result = {}

	for k, v in p do
		if p2 == nil then
			result[k] = callback(v, k)
		else
			result[k] = callback(p2, v, k)
		end
	end

	return result
end
