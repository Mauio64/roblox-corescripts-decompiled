local Parent = script:FindFirstAncestor("AccountSwitching").Parent
local HttpService = game:GetService("HttpService")
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder
local Paths = require(script.Parent.Paths)

return function(p1, p2, p3) -- line: 7
	-- upvalues: UrlBuilder (copy), Paths (copy), HttpService (copy)
	local v8 = UrlBuilder.fromString(Paths.GetAccountsListAsPreviousAccountEntries)
	local json = HttpService:JSONEncode({
		encrypted_users_data_blob = p2,
		remove_invalid_active_user = p3
	})

	return p1(v8(), "POST", {
		postBody = json
	})
end
