local ParentParent = script.Parent.Parent.Parent
local Array = require(ParentParent.LuauPolyfill).Array

return {
	addPath = function(t1: {[any]: any}?, p1, s1: string?) -- line: 21
		return {
			prev = t1,
			key = p1,
			typename = s1
		}
	end,
	pathToArray = function(t2: {[any]: any}?) -- line: 29
		-- upvalues: Array (copy)
		local t3 = {}

		while t2 do
			table.insert(t3, t2.key)
			t2 = t2.prev
		end

		return Array.reverse(t3)
	end
}
