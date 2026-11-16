local parent = script.Parent
require(parent.Types)

local function memoize(callback, callback2)
	local v = {}

	return function(...)
		local v2 = { ... }
		local v3

		if callback2 then
			v3 = callback2(...)
		else
			v3 = table.concat(v2, "|")
		end

		if v[v3] == nil then
			v[v3] = callback(...)
		end

		return v[v3]
	end
end

return memoize
