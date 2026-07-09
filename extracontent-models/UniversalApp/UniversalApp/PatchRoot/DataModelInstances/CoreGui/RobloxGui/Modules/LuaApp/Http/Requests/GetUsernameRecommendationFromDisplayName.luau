local CorePackages = game:GetService("CorePackages")
local Url = require(CorePackages.Workspace.Packages.Http).Url
local v3 = require(CorePackages.Packages.UrlBuilder).UrlBuilder.new({
	path = "v1/validators/recommendedUsernameFromDisplayName",
	query = "DisplayName={displayName}&BirthDay={birthday}",
	base = Url.AUTH_URL
})

return function(p1, s1: string, s2: string) -- line: 16
	-- upvalues: v3 (copy)
	return p1(v3({
		displayName = s1,
		birthday = s2
	}), "GET", {
		maxRetryCount = 0
	})
end
