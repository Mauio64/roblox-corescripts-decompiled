local module = require("@luauforge/deferred/gzV")
local urlBuilder = require("@luauforge/deferred/gAw").UrlBuilder
local module2 = require("@luauforge/deferred/gBe")

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local function PostReactivateAccount(callback, p2)
	module.isType(p2, "number", "PostReactivate expects punishmentId to be a number")

	local localPlayer = Players.LocalPlayer

	module.assert(localPlayer, "Players.LocalPlayer should be non-nil")

	if localPlayer == nil then
		return module2.reject("Players.LocalPlayer is nil")
	end

	local userId = localPlayer.UserId
	return callback(urlBuilder.usermoderation.reactivate(), "POST", {
		postBody = HttpService:JSONEncode({ PunishmentId = p2, PunishedUserId = userId })
	})
end

return PostReactivateAccount
