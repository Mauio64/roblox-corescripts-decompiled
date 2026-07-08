local symbols = require(script.Parent.symbols)
local Spy = require(script.Parent.Spy)

return function(p1) -- line: 4
	-- upvalues: Spy (copy), symbols (copy)
	if type(p1) == "function" then
		local v4 = Spy.lookup(p1)

		if v4 then
			return v4[symbols.Calls]
		end

		error("Calling getCalls on a non-spy function")
	end

	local v5 = rawget(p1, symbols.Calls)

	if v5 == nil then
		v5 = getmetatable(p1)[symbols.Calls]
	end

	if v5 == nil then
		error("Calling getCalls on a non-mock")
	end

	return v5
end
