local symbols = require(script.Parent.symbols)

return function(p1, p2) -- line: 3
	-- upvalues: symbols (copy)
	local mt = getmetatable(p1)
	local t1 = nil

	if p2 then
		t1 = {
			calls = 0,
			value = p2
		}
	end

	mt[symbols.SideEffect] = t1
end
