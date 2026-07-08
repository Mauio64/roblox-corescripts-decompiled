local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local Players = game:GetService("Players")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui", 1e999)

assert(RobloxGui ~= nil, "RobloxGui should exist")

local GetFFlagPlayerViewRemoteEnabled = require(RobloxGui.Modules.Common.Flags.GetFFlagPlayerViewRemoteEnabled)
local v5 = game:DefineFastFlag("EnablePlayerViewRemoteEventUserIdValidation2", false)
local RemoteEvent = Instance.new("RemoteEvent")

RemoteEvent.Name = "RequestDeviceCameraOrientationCapability"
RemoteEvent.Parent = RobloxReplicatedStorage

local t1 = {}

RemoteEvent.OnServerEvent:Connect(function(player, p1) -- line: 17
	-- upvalues: t1 (copy), RemoteEvent (copy)
	local elapsed = os.clock()
	local v14 = t1[player.UserId]

	if v14 and elapsed - v14 < 2 then
		return
	end

	if typeof(p1) ~= "Instance" or not p1:IsA("Player") then
		return
	end

	t1[player.UserId] = elapsed

	local OsPlatform = p1.OsPlatform

	RemoteEvent:FireClient(player, p1, OsPlatform == "iOS" or OsPlatform == "Android")
end)
Players.PlayerRemoving:Connect(function(player) -- line: 37
	-- upvalues: t1 (copy)
	t1[player.UserId] = nil
end)

if GetFFlagPlayerViewRemoteEnabled() then
	local RemoteEvent2 = Instance.new("RemoteEvent")

	RemoteEvent2.Name = "RequestDeviceCameraCFrame"
	RemoteEvent2.Parent = RobloxReplicatedStorage

	local UnreliableRemoteEvent = Instance.new("UnreliableRemoteEvent")

	UnreliableRemoteEvent.Name = "ReplicateDeviceCameraCFrame"
	UnreliableRemoteEvent.Parent = RobloxReplicatedStorage

	local t2 = {}

	Players.PlayerRemoving:Connect(function(player) -- line: 52
		-- upvalues: t2 (copy)
		t2[tostring(player.UserId)] = nil
	end)
	RemoteEvent2.OnServerEvent:Connect(function(player, p2) -- line: 57
		-- upvalues: v5 (copy), Players (copy), t2 (copy), RemoteEvent2 (copy)
		if v5 then
			if typeof(p2) ~= "number" or p2 <= 0 or p2 == player.UserId or p2 ~= math.floor(p2) then
				return
			end
		elseif typeof(p2) ~= "number" or p2 <= 0 or p2 == player.UserId then
			return
		end

		local PlayerByUserId = Players:GetPlayerByUserId(p2)

		if not PlayerByUserId then
			return
		end

		local str = tostring(PlayerByUserId.UserId)

		if not t2[str] then
			t2[str] = {}
		end

		t2[str][tostring(player.UserId)] = os.clock()
		RemoteEvent2:FireClient(PlayerByUserId)
	end)
	UnreliableRemoteEvent.OnServerEvent:Connect(function(player, p3, p4) -- line: 83
		-- upvalues: t2 (copy), Players (copy), UnreliableRemoteEvent (copy)
		if typeof(p3) ~= "CFrame" or (typeof(p4) ~= "number" or p4 <= 0) then
			return
		end

		local str = tostring(player.UserId)

		if t2[str] then
			local t3 = {}

			for v27, v28 in t2[str] do
				if os.clock() - v28 > 5 then
					table.insert(t3, v27)
				else
					local num = tonumber(v27)

					if num then
						local PlayerByUserId = Players:GetPlayerByUserId(num)

						if PlayerByUserId then
							UnreliableRemoteEvent:FireClient(PlayerByUserId, player, p3, p4)
						end
					end
				end
			end

			for _, v32 in t3 do
				t2[str][v32] = nil
			end
		end
	end)
end
