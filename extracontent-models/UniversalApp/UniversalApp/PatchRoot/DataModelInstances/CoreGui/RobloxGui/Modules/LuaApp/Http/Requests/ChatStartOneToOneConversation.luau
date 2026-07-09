local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local Url = require(CorePackages.Workspace.Packages.Http).Url

return function(p1, p2) -- line: 6
	-- upvalues: HttpService (copy), Url (copy)
	local json = HttpService:JSONEncode({
		participantuserId = p2
	})

	return p1(string.format("%s/start-one-to-one-conversation", Url.CHAT_URL), "POST", {
		postBody = json
	})
end
