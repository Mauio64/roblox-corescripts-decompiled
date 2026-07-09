local HttpService = game:GetService("HttpService")

return function(s1: string?) -- line: 3
	-- upvalues: HttpService (copy)
	if not s1 then
		return nil
	end

	local ok, result = pcall(function() -- line: 8
		-- upvalues: HttpService (copy), s1 (copy)
		return HttpService:JSONDecode(s1)
	end)

	if ok and type(result) == "table" and result.errors and type(result.errors) == "table" then
		local v5 = result.errors[1]

		if v5 and v5.code and v5.code > 0 then
			return v5.code
		end
	end

	return nil
end
