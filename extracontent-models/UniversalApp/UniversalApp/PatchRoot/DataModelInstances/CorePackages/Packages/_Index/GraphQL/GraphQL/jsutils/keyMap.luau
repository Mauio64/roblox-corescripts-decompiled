local ParentParent = script.Parent.Parent.Parent

require(ParentParent.LuauPolyfill)
require(script.Parent.ObjMap)

return {
	keyMap = function(p1, p2: ((...any) -> ...any)) -- line: 38
		local t1 = {}

		for _, v in ipairs(p1) do
			t1[p2(v)] = v
		end

		return t1
	end
}
