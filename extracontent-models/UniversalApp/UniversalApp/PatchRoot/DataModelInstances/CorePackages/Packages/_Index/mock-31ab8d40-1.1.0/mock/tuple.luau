local symbols = require(script.Parent.symbols)

return function(...)
	local values = { ... }
	assert(#values > 1, "Mock Error: tuple only accepts more than 1 value.")

	local v = { [symbols.isTuple] = true, values = values }
	return (setmetatable(v, {
		__tostring = function(_)
			local v2 = {}

			for _, v3 in ipairs(values) do
				table.insert(v2, (tostring(v3)))
			end

			return "<Tuple values=[" .. table.concat(v2, ", ") .. "]>"
		end
	}))
end
