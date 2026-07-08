local function validateProps(p1: ((...any) -> ...any), p2) -- line: 1
	if _G.__DEV__ or _G.__DISABLE_ALL_WARNINGS_EXCEPT_PROP_VALIDATION__ then
		local v4, v5 = p1(p2)

		if not v4 then
			local v6 = `prop validation failed: { v5 }`

			error(v6)
		end
	end
end

return validateProps
