local CorePackages = game:GetService("CorePackages")
local GetCanSendAndCanCustomizeInvites = require(CorePackages.Workspace.Packages.GameInvite).GetCanSendAndCanCustomizeInvites
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local httpRequest = require(RobloxGui.Modules.Common.httpRequest)

return function(s1: string, n1: number?) -- line: 12
	-- upvalues: httpRequest (copy), HttpRbxApiService (copy), GetCanSendAndCanCustomizeInvites (copy)
	local v8 = httpRequest(HttpRbxApiService)
	local v9, v10 = GetCanSendAndCanCustomizeInvites(v8, s1, n1):await()

	if v9 and (v10 and v10.responseBody) then
		return v10.responseBody.canPrompt, v10.responseBody.canCustomize
	end

	return false, false
end
