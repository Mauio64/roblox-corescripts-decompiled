local Parent = script:FindFirstAncestor("NotApprovedPage").Parent
local ArgCheck = require(Parent.ArgCheck)
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder
local Promise = require(Parent.Promise)
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local function PostReactivateAccount(p1, n1: number) -- line: 11
	-- upvalues: ArgCheck (copy), Players (copy), Promise (copy), UrlBuilder (copy), HttpService (copy)
	ArgCheck.isType(n1, "number", "PostReactivate expects punishmentId to be a number")

	local LocalPlayer = Players.LocalPlayer

	ArgCheck.assert(LocalPlayer, "Players.LocalPlayer should be non-nil")

	if LocalPlayer == nil then
		return Promise.reject("Players.LocalPlayer is nil")
	end

	local UserId = LocalPlayer.UserId

	return p1(UrlBuilder.usermoderation.reactivate(), "POST", {
		postBody = HttpService:JSONEncode({
			PunishmentId = n1,
			PunishedUserId = UserId
		})
	})
end

return PostReactivateAccount
