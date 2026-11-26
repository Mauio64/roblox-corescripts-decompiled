local HttpService = game:GetService("HttpService")

return function(p2)
	if p2 ~= nil and p2.errors ~= nil and p2.errors[1] and p2.errors[1].fieldData then
		local fieldData = p2.errors[1].fieldData
		local success, result = pcall(function()
			return HttpService:JSONDecode(fieldData)
		end)

		if success then
			return result.users or {}
		end
	end

	return {}
end
