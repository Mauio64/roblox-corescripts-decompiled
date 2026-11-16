local parent = script.Parent.Parent
require(parent.types)

return function(list, callback, p)
	if _G.__DEV__ then
		if typeof(list) ~= "table" then
			error(string.format("Array.forEach called on %s", (typeof(list))))
		end

		if typeof(callback) ~= "function" then
			error("callback is not a function")
		end
	end

	local v = #list
	local v2 = 1

	while v2 <= v do
		local item = list[v2]

		if p == nil then
			callback(item, v2, list)
		else
			callback(p, item, v2, list)
		end

		v = #list < v and #list or v

		v2 += 1
	end
end
