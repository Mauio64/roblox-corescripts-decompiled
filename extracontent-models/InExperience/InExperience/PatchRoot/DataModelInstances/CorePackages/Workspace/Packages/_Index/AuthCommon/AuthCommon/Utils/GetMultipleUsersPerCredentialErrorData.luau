local HttpService = game:GetService("HttpService")

return function(p)
	if p ~= nil and p.errors ~= nil and p.errors[1] and p.errors[1].fieldData then
		local fieldData = p.errors[1].fieldData
		local success, result = pcall(function()
			return HttpService:JSONDecode(fieldData)
		end)

		if success then
			return result.users or {}
		end
	end

	return {}
end
