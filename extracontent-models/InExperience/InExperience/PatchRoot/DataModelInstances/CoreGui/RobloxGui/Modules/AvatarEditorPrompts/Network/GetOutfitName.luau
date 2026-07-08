local CorePackages = game:GetService("CorePackages")
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local httpRequest = require(RobloxGui.Modules.Common.httpRequest)
local Url = require(CorePackages.Workspace.Packages.Http).Url
local v6 = httpRequest(HttpRbxApiService)

return function(p1) -- line: 13
	-- upvalues: Url (copy), v6 (copy)
	local v8 = string.format("%s/v3/outfits/%s/details", Url.AVATAR_URL, (tostring(p1)))

	return v6(v8, "GET"):andThen(function(p2) -- line: 16
		return p2.responseBody.name
	end)
end
