local function validateProps(callback, p)
	if _G.__DEV__ or _G.__DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__ then
		local v, v2 = callback(p)

		if not v then
			local formatted = `prop validation failed: {v2}`
			error(formatted)
		end
	end
end

return validateProps
