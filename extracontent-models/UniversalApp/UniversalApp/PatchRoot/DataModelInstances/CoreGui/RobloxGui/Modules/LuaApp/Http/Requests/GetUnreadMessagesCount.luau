local CorePackages = game:GetService("CorePackages")
local Url = require(CorePackages.Workspace.Packages.Http).Url

return function(p1) -- line: 13
	-- upvalues: Url (copy)
	return p1(string.format("%s/messages/unread/count", Url.PRIVATEMESSAGES_URL), "GET")
end
