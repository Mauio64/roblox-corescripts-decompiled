local HttpService = game:GetService("HttpService")

return function() -- line: 4
	-- upvalues: HttpService (copy)
	return string.find(HttpService:GetUserAgent(), "OculusQuest3Store") ~= nil
end
