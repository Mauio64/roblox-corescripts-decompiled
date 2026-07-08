local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local Players = game:GetService("Players")
local CorePackages = game:GetService("CorePackages")

if require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableReferredPlayerJoinRemoteEvent() then
	local RemoteEvent = Instance.new("RemoteEvent")

	RemoteEvent.Name = "ReferredPlayerJoin"
	RemoteEvent.Parent = RobloxReplicatedStorage
	Players.PlayerAdded:Connect(function(player) -- line: 16
		-- upvalues: Players (copy), RemoteEvent (copy)
		local JoinData = player:GetJoinData()
		local v7 = JoinData and tonumber(JoinData.ReferredByPlayerId)

		if v7 and v7 ~= 0 then
			local PlayerByUserId = Players:GetPlayerByUserId(v7)

			if PlayerByUserId then
				RemoteEvent:FireClient(PlayerByUserId, player)
			end
		end
	end)
end
