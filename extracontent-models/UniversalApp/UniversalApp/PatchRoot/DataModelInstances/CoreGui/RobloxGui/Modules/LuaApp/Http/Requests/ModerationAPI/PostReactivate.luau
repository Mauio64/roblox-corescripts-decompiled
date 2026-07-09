local Players = game:GetService("Players")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local HttpService = game:GetService("HttpService")
local ArgCheck = require(Modules.LuaApp.ArgCheck)
local UrlBuilder = require(Modules.LuaApp.Http.UrlBuilder)

return function(p1, p2) -- line: 16
	-- upvalues: ArgCheck (copy), Players (copy), UrlBuilder (copy), HttpService (copy)
	ArgCheck.isType(p2, "number", "PostReactivate expects punishmentId to be a number")

	local UserId = Players.LocalPlayer.UserId

	return p1(UrlBuilder.usermoderation.reactivate(), "POST", {
		postBody = HttpService:JSONEncode({
			PunishmentId = p2,
			PunishedUserId = UserId
		})
	})
end
