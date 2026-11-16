local parent = script.Parent.Parent.Parent
require(parent.types)

return function(items, callback, p)
	if callback then
		local result = {}

		for k, item in items do
			if p == nil then
				result[k] = callback(item, k)
			else
				result[k] = callback(p, item, k)
			end
		end

		return result
	else
		local result = {}

		for k, item in items do
			result[k] = item
		end

		return result
	end
end
