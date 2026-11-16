local function validateProps(callback, p2)
	if _G.__DEV__ or _G.__DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__ then
		local v5, v6 = callback(p2)

		if not v5 then
			local formatted = `prop validation failed: {v6}`
			error(formatted)
		end
	end
end

return validateProps
