local ParentParent = script.Parent.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object

return {
	compose = function(p1, p2) -- line: 22
		if p1 ~= nil and p2 ~= nil then
			return {
				p1,
				p2
			}
		end

		if p1 ~= nil then
			return p1
		end

		return p2
	end,
	create = function(p3) -- line: 31
		-- upvalues: Array (copy), Object (copy)
		if _G.__DEV__ then
			Array.forEach(Object.keys(p3), function(p4) -- line: 36
				-- upvalues: p3 (copy), Object (copy)
				if p3[p4] then
					Object.freeze(p3[p4])
				end
			end)
		end

		return p3
	end
}
