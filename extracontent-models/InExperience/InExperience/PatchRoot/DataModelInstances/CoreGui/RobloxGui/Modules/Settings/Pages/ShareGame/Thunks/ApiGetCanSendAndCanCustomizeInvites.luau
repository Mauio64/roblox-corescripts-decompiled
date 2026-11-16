local CorePackages = game:GetService("CorePackages")

local GameInvite = require(CorePackages.Workspace.Packages.GameInvite)
local GetCanSendAndCanCustomizeInvites = GameInvite.GetCanSendAndCanCustomizeInvites

local HttpRbxApiService = game:GetService("HttpRbxApiService")

local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local httpRequest = require(RobloxGui.Modules.Common.httpRequest)

return function(p: string, p2: number?)
	local v, v2 = GetCanSendAndCanCustomizeInvites(httpRequest(HttpRbxApiService), p, p2):await()

	if v and v2 and v2.responseBody then
		return v2.responseBody.canPrompt, v2.responseBody.canCustomize
	end

	return false, false
end
