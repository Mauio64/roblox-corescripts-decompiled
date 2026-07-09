local Players = game:GetService("Players")
local CrossPlay = script:FindFirstAncestor("CrossPlay")
local CrossPlayParent = CrossPlay.Parent
local RoduxNetworking = require(CrossPlayParent.RoduxNetworking)
local HttpRequest = require(CrossPlayParent.HttpRequest)
local createRequestThunks = require(CrossPlay.Networking.createRequestThunks)
local v7 = RoduxNetworking.config({
	keyPath = "CrossPlaySettings.NetworkStatus",
	networkImpl = HttpRequest.config({
		maxRetryCount = 0,
		requestFunction = function(p1, p2, p3) -- line: 11
			-- upvalues: Players (copy), HttpRequest (copy)
			p3.headers = {
				["robloxctx-authenticated-userid"] = (not Players or not Players.LocalPlayer) and "" or tostring(Players.LocalPlayer.UserId)
			}

			return HttpRequest.requestFunctions.RequestInternal(p1, p2, p3)
		end
	})
})

return {
	roduxNetworking = v7,
	thunks = createRequestThunks({
		roduxNetworking = v7
	})
}
