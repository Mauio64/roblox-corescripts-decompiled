local symbols = require(script.Parent.symbols)

return function(p): boolean
	local metatable = getmetatable(p)

	if metatable then
		return metatable[symbols.isMagicMock] ~= nil
	end

	return false
end
