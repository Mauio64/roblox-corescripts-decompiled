local __DEV__ = _G.__DEV__
local parent = script.Parent.Parent.Parent
require(parent.ES7Types)

return function(list, callback, p)
	if __DEV__ then
		if typeof(list) ~= "table" then
			error(string.format("Array.reduce called on %s", (typeof(list))))
		end

		if typeof(callback) ~= "function" then
			error("callback is not a function")
		end
	end

	local count = #list
	local v

	if p == nil then
		v = 2

		if count == 0 then
			error("reduce of empty array with no initial value")
		end

		p = list[1]
	else
		v = 1
	end

	for i = v, count do
		p = callback(p, list[i], i, list)
	end

	return p
end
