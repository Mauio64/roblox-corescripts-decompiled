local HttpService = game:GetService("HttpService")

return function(p1) -- line: 18
	-- upvalues: HttpService (copy)
	if p1 ~= nil and (p1.errors ~= nil and p1.errors[1] and p1.errors[1].fieldData) then
		local fieldData = p1.errors[1].fieldData
		local ok, result = pcall(function() -- line: 26
			-- upvalues: HttpService (copy), fieldData (copy)
			return HttpService:JSONDecode(fieldData)
		end)

		if ok then
			return result.users or {}
		end
	end

	return {}
end
