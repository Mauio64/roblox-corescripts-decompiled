local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui", 1e999)
assert(RobloxGui ~= nil, "RobloxGui should exist")

local GetFFlagPlayerViewRemoteEnabled = require(RobloxGui.Modules.Common.Flags.GetFFlagPlayerViewRemoteEnabled)

local defineFastFlag = game:DefineFastFlag("EnablePlayerViewRemoteEventUserIdValidation2", false)

local requestDeviceCameraOrientationCapability = Instance.new("RemoteEvent")
requestDeviceCameraOrientationCapability.Name = "RequestDeviceCameraOrientationCapability"
requestDeviceCameraOrientationCapability.Parent = RobloxReplicatedStorage

local v = {}

requestDeviceCameraOrientationCapability.OnServerEvent:Connect(function(player, player2)
	local now = os.clock()
	local v2 = v[player.UserId]

	if v2 and now - v2 < 2 or (typeof(player2) ~= "Instance" or not player2:IsA("Player")) then
		return
	end

	v[player.UserId] = now

	local osPlatform = player2.OsPlatform
	requestDeviceCameraOrientationCapability:FireClient(player, player2, osPlatform == "iOS" or osPlatform == "Android")
end)

Players.PlayerRemoving:Connect(function(player)
	v[player.UserId] = nil
end)

if GetFFlagPlayerViewRemoteEnabled() then
	local requestDeviceCameraCFrame = Instance.new("RemoteEvent")
	requestDeviceCameraCFrame.Name = "RequestDeviceCameraCFrame"
	requestDeviceCameraCFrame.Parent = RobloxReplicatedStorage

	local replicateDeviceCameraCFrame = Instance.new("UnreliableRemoteEvent")
	replicateDeviceCameraCFrame.Name = "ReplicateDeviceCameraCFrame"
	replicateDeviceCameraCFrame.Parent = RobloxReplicatedStorage

	local v2 = {}

	Players.PlayerRemoving:Connect(function(player)
		v2[tostring(player.UserId)] = nil
	end)

	requestDeviceCameraCFrame.OnServerEvent:Connect(function(p, value)
		if defineFastFlag then
			if typeof(value) ~= "number" or value <= 0 or p.UserId == value or math.floor(value) ~= value then
				return
			end
		elseif typeof(value) ~= "number" or value <= 0 or p.UserId == value then
			return
		end

		local playerByUserId = Players:GetPlayerByUserId(value)

		if not playerByUserId then
			return
		end

		local userId = tostring(playerByUserId.UserId)

		if not v2[userId] then
			v2[userId] = {}
		end

		v2[userId][tostring(p.UserId)] = os.clock()
		requestDeviceCameraCFrame:FireClient(playerByUserId)
	end)

	replicateDeviceCameraCFrame.OnServerEvent:Connect(function(p, p2, value)
		if typeof(p2) ~= "CFrame" or typeof(value) ~= "number" or value <= 0 then
			return
		end

		local userId = tostring(p.UserId)

		if v2[userId] then
			local v3 = {}

			for k, v4 in v2[userId] do
				if os.clock() - v4 > 5 then
					table.insert(v3, k)
				else
					local v5 = tonumber(k)

					if v5 then
						local playerByUserId = Players:GetPlayerByUserId(v5)

						if playerByUserId then
							replicateDeviceCameraCFrame:FireClient(playerByUserId, p, p2, value)
						end
					end
				end
			end

			for _, v4 in v3 do
				v2[userId][v4] = nil
			end
		end
	end)
end
