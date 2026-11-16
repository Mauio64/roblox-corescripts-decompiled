local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local Players = game:GetService("Players")
local CorePackages = game:GetService("CorePackages")

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)

if SharedFlags.GetFFlagEnableReferredPlayerJoinRemoteEvent() then
	local referredPlayerJoin = Instance.new("RemoteEvent")
	referredPlayerJoin.Name = "ReferredPlayerJoin"
	referredPlayerJoin.Parent = RobloxReplicatedStorage

	Players.PlayerAdded:Connect(function(player)
		local joinData = player:GetJoinData()
		local referredByPlayerId = joinData and tonumber(joinData.ReferredByPlayerId)

		local playerByUserId = referredByPlayerId
			and referredByPlayerId ~= 0
			and Players:GetPlayerByUserId(referredByPlayerId)

		if playerByUserId then
			referredPlayerJoin:FireClient(playerByUserId, player)
		end
	end)
end
