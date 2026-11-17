local AdService = game:GetService("AdService")
local Players = game:GetService("Players")

local RewardedVideoAdShowController = require(script.RewardedVideoAdShowController)

return {
	serverStarterScript = function()
		local v = RewardedVideoAdShowController.new()

		function AdService.OnShowRewardedVideoAd(p, p2)
			return v:onShowRewardedVideoAd(p, p2.productId, p2.placementId)
		end

		function AdService.OnRewardedVideoAdResult(p, p2, p3: string, p4: string)
			v:onRewardedVideoAdResult(p, p2, p3, p4)
		end

		Players.PlayerRemoving:Connect(function(player)
			v:onPlayerRemoving(player)
		end)
	end,
	["jest.config"] = script["jest.config"]
}
