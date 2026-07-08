local function bindingValidator(p1) -- line: 4
	return function(p2) -- line: 5
		-- upvalues: p1 (copy)
		local match = string.match(tostring(p2), "RoactBinding")

		if typeof(p2) ~= "table" or not match then
			warn(string.format("RoactBinding expected, got %s", (typeof(p2))))

			return false
		end

		local ok, result = pcall(function() -- line: 13
			-- upvalues: p2 (copy)
			return p2:getValue()
		end)

		if not ok then
			warn("getValue() not defined")

			return false
		end

		local v7, v8 = p1(result)

		if not v7 then
			warn(string.format("RoactBinding value: %s", v8))

			return false
		end

		return true
	end
end

return bindingValidator
