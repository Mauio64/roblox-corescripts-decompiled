local Players = game:GetService("Players")

local module = require("@luauforge/bundled/hSL")
local module2 = require("@luauforge/bundled/hSM")
local module3 = require("@luauforge/bundled/hSN")

local config = module.config({
	keyPath = "CrossPlaySettings.NetworkStatus",
	networkImpl = module2.config({
		requestFunction = function(p2, p3, p4)
			p4.headers = {
				["robloxctx-authenticated-userid"] = not (Players and Players.LocalPlayer) and "" or tostring(Players.LocalPlayer.UserId)
			}

			return module2.requestFunctions.RequestInternal(p2, p3, p4)
		end,
		maxRetryCount = 0
	})
})

return {
	roduxNetworking = config,
	thunks = module3({ roduxNetworking = config })
}
