local symbols = require(script.Parent.symbols)
local Spy = require(script.Parent.Spy)

return function(callback)
	if type(callback) == "function" then
		local lookup = Spy.lookup(callback)

		if lookup then
			return lookup[symbols.Calls]
		end

		error("Calling getCalls on a non-spy function")
	end

	local v = rawget(callback, symbols.Calls)

	if v == nil then
		v = getmetatable(callback)[symbols.Calls]
	end

	if v == nil then
		error("Calling getCalls on a non-mock")
	end

	return v
end
