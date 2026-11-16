local CorePackages = game:GetService("CorePackages")
local HttpRbxApiService = game:GetService("HttpRbxApiService")

local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local httpRequest = require(RobloxGui.Modules.Common.httpRequest)

local Http = require(CorePackages.Workspace.Packages.Http)
local Url = Http.Url

local v = httpRequest(HttpRbxApiService)

return function(p)
	return v(string.format("%s/v3/outfits/%s/details", Url.AVATAR_URL, (tostring(p))), "GET"):andThen(function(p2)
		return p2.responseBody.name
	end)
end
