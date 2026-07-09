local CorePackages = game:GetService("CorePackages")
local Url = require(CorePackages.Workspace.Packages.Http).Url

return function(p1, p2, p3) -- line: 18
	-- upvalues: Url (copy)
	local v6 = Url:makeQueryString({
		format = "png",
		isCircular = true,
		gamePassIds = table.concat(p2, ","),
		size = p3
	})

	return p1(string.format("%sv1/game-passes?%s", Url.THUMBNAILS_URL, v6), "GET")
end
