local parent = script.Parent.Parent
require(parent.types)

return function(list, callback, p)
	if _G.__DEV__ then
		if typeof(list) ~= "table" then
			error(string.format("Array.filter called on %s", (typeof(list))))
		end

		if typeof(callback) ~= "function" then
			error("callback is not a function")
		end
	end

	local count = #list
	local result = {}
	local v = 1

	if p == nil then
		for i = 1, count do
			local item = list[i]

			if not (item ~= nil and callback(item, i, list)) then
				continue
			end

			result[v] = item
			v += 1
		end
	else
		for i = 1, count do
			local item = list[i]

			if not (item ~= nil and callback(p, item, i, list)) then
				continue
			end

			result[v] = item
			v += 1
		end
	end

	return result
end
