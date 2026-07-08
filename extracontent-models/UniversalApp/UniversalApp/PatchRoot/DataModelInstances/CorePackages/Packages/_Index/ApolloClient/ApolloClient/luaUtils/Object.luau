local ParentParent = script.Parent.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)

return (LuauPolyfill.Object.assign({}, LuauPolyfill.Object, {
	getPrototypeOf = function(p1) -- line: 12
		local mt = getmetatable(p1)

		return mt ~= false and mt or nil
	end,
	create = function(p2, p3) -- line: 16
		if p3 == nil then
			p3 = {}
		end

		return (setmetatable(p3, p2))
	end
}))
