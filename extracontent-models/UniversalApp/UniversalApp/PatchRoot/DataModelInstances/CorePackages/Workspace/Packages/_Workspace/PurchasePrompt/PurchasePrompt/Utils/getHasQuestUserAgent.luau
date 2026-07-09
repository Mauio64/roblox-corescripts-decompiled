local HttpService = game:GetService("HttpService")

return function() -- line: 3
	-- upvalues: HttpService (copy)
	return string.find(HttpService:GetUserAgent(), "OculusQuest3Store") ~= nil
end
