local function bindingValidator(callback)
	return function(object): boolean
		local v = string.match(tostring(object), "RoactBinding")

		if typeof(object) ~= "table" or not v then
			warn(string.format("RoactBinding expected, got %s", (typeof(object))))
			return false
		end

		local success, result = pcall(function()
			return object:getValue()
		end)

		if not success then
			warn("getValue() not defined")
			return false
		end

		local v2, v3 = callback(result)

		if v2 then
			return true
		end

		warn(string.format("RoactBinding value: %s", v3))
		return false
	end
end

return bindingValidator
