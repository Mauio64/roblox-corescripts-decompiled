local symbols = require(script.Parent.symbols)

local function resetMock(p1, p2) -- line: 3
	-- upvalues: symbols (copy), resetMock (copy)
	local mt = getmetatable(p1)

	mt[symbols.Calls] = {}

	for _, v in pairs(mt[symbols.Children]) do
		if not p2[v] then
			p2[v] = true
			resetMock(v, p2)
		end
	end
end

return function(p3) -- line: 15
	-- upvalues: resetMock (copy)
	resetMock(p3, {})
end
