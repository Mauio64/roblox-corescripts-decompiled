local parent = script.Parent.Parent
require(parent.types)

return function(items, callback, p): boolean
	if typeof(items) ~= "table" then
		error(string.format("Array.some called on %s", (typeof(items))))
	end

	if typeof(callback) ~= "function" then
		error("callback is not a function")
	end

	for k, item in items do
		if p == nil then
			if item ~= nil and callback(item, k, items) then
				return true
			end
		elseif item ~= nil and callback(p, item, k, items) then
			return true
		end
	end

	return false
end
