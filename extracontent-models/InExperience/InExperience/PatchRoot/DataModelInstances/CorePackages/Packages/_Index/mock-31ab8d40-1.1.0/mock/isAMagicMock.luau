local symbols = require(script.Parent.symbols)

return function(p1) -- line: 3
	-- upvalues: symbols (copy)
	local mt = getmetatable(p1)

	if mt then
		return mt[symbols.isMagicMock] ~= nil
	end

	return false
end
