local Symbol = require(script.Parent.Symbol)
local t1 = {}

return {
	getOrInit = function(s1: string) -- line: 6
		-- upvalues: t1 (ref), Symbol (copy)
		if t1[s1] == nil then
			t1[s1] = Symbol.new(s1)
		end

		return t1[s1]
	end,
	__clear = function() -- line: 14
		-- upvalues: t1 (ref)
		t1 = {}
	end
}
