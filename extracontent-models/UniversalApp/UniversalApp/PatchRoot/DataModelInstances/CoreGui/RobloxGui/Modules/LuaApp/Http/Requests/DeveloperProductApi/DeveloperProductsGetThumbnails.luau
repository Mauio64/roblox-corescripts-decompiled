local CorePackages = game:GetService("CorePackages")
local Url = require(CorePackages.Workspace.Packages.Http).Url

return function(p1: ((...any) -> ...any), t1: {[any]: any}, s1: string) -- line: 4
	-- upvalues: Url (copy)
	local v6 = Url:makeQueryString({
		format = "png",
		assetIds = table.concat(t1, ","),
		size = s1
	})

	return p1(string.format("%sv1/assets?%s", Url.THUMBNAILS_URL, v6), "GET")
end
