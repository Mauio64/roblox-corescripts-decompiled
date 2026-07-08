local symbols = require(script.Parent.symbols)

return function(...) -- line: 3
	-- upvalues: symbols (copy)
	local t1 = { ... }

	assert(#t1 > 1, "Mock Error: tuple only accepts more than 1 value.")

	return (setmetatable({
		[symbols.isTuple] = true,
		values = t1
	}, {
		__tostring = function(_) -- line: 11
			-- upvalues: t1 (copy)
			local t2 = {}

			for _, v in ipairs(t1) do
				table.insert(t2, (tostring(v)))
			end

			return "<Tuple values=[" .. table.concat(t2, ", ") .. "]>"
		end
	}))
end
