local parent = script.Parent.Parent
require(parent.types)

return function(list, callback, p)
	if _G.__DEV__ then
		if typeof(list) ~= "table" then
			error(string.format("Array.map called on %s", (typeof(list))))
		end

		if typeof(callback) ~= "function" then
			error("callback is not a function")
		end
	end

	local v = #list
	local v2 = 1
	local result = {}

	while v2 <= v do
		local item = list[v2]

		if item ~= nil then
			local v3

			if p == nil then
				v3 = callback(item, v2, list)
			else
				v3 = callback(p, item, v2, list)
			end

			result[v2] = v3
		end

		v2 += 1
	end

	return result
end
