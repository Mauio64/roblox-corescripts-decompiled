local symbols = require(script.Parent.symbols)
local function resetMock(p, p2)
	local metatable = getmetatable(p)
	metatable[symbols.Calls] = {}

	for _, v in pairs(metatable[symbols.Children]) do
		if p2[v] then
			continue
		end

		p2[v] = true
		resetMock(v, p2)
	end
end

return function(p)
	resetMock(p, {})
end
