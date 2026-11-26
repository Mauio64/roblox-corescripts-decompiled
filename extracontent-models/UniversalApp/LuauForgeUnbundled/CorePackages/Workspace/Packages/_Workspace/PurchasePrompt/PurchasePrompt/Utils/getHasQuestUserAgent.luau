local HttpService = game:GetService("HttpService")

return function(): boolean
	return string.find(HttpService:GetUserAgent(), "OculusQuest3Store") ~= nil
end
