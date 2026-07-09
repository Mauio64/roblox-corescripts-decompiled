local CorePackages = game:GetService("CorePackages")
local Url = require(CorePackages.Workspace.Packages.Http).Url

return function(p1: ((...any) -> ...any), s1: string, s2: string) -- line: 4
	-- upvalues: Url (copy)
	local v6 = Url:makeQueryString({
		status = "pending",
		locationType = "ExperienceDetailPage",
		playerId = s1,
		placeId = s2
	})

	return p1(string.format("%sdeveloper-products/v1/game-transactions?%s", Url.APIS_URL, v6), "GET")
end
