local HttpService = game:GetService("HttpService")

return function() -- line: 8
	-- upvalues: HttpService (copy)
	return HttpService:GenerateGUID(true)
end
