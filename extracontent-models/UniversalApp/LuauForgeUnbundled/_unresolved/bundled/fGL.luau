local HttpService = game:GetService("HttpService")

return function(json)
	if not json then
		return nil
	end

	local success, result = pcall(function()
		return HttpService:JSONDecode(json)
	end)

	if success and type(result) == "table" and result.errors and type(result.errors) == "table" then
		local err = result.errors[1]

		if err and err.code and err.code > 0 then
			return err.code
		end
	end

	return nil
end
