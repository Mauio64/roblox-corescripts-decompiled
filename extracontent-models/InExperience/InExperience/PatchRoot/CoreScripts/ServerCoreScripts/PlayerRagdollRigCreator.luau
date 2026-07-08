local CoreGui = game:GetService("CoreGui")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")

game:GetService("StarterPlayer")

local Common = CoreGui:FindFirstChild("RobloxGui"):FindFirstChild("Modules"):FindFirstChild("Common")
local EngineFeature = game:GetEngineFeature("AvatarJointUpgradeFeature")
local EngineFeature2 = game:GetEngineFeature("AvatarJointUpgradeDefaultOnFeature")

local function jointUpgradeActive() -- line: 11
	-- upvalues: EngineFeature (copy), EngineFeature2 (copy)
	return EngineFeature and EngineFeature2
end

local RagdollRigging = require(Common:FindFirstChild("RagdollRigging"))
local HumanoidReadyUtil = require(Common:FindFirstChild("HumanoidReadyUtil"))

local function getDefaultDeathType() -- line: 23
	if not game:GetEngineFeature("PolicyInfoForServerRobloxOnlyAsyncEnabled") then
		return game:DefineFastString("DeathTypeValue", "Classic")
	end

	local DefaultAvatarDeathType = game:GetService("PolicyService"):GetPolicyInfoForServerRobloxOnlyAsync().DefaultAvatarDeathType

	if DefaultAvatarDeathType == nil then
		error("PolicyService did not have death type policy")
	end

	return DefaultAvatarDeathType
end

local v10 = getDefaultDeathType()
local StringValue = Instance.new("StringValue")

StringValue.Name = "DeathType"
StringValue.Value = v10
StringValue.Parent = RobloxReplicatedStorage

if not EngineFeature and v10 ~= "Ragdoll" then
	return
end

local t1 = {}

if not EngineFeature then
	local RemoteEvent = Instance.new("RemoteEvent")

	RemoteEvent.Name = "OnRagdoll"
	RemoteEvent.OnServerEvent:Connect(function(player, p1) -- line: 62
		-- upvalues: t1 (copy), RagdollRigging (copy)
		if p1 and p1 == t1[player] then
			local v17 = p1 and p1.Parent

			if v17 and v17:IsA("Model") then
				RagdollRigging.disableMotors(v17, p1.RigType)
			end

			t1[player] = nil
		end
	end)
	RemoteEvent.Parent = RobloxReplicatedStorage
end

HumanoidReadyUtil.registerHumanoidReady(function(p2, p3, p4) -- line: 75
	-- upvalues: EngineFeature (copy), EngineFeature2 (copy), RagdollRigging (copy), v10 (copy), t1 (copy)
	if EngineFeature then
		if p4.RigType == Enum.HumanoidRigType.R15 and (EngineFeature and EngineFeature2) then
			RagdollRigging.createRagdollJoints(p3, p4.RigType, EngineFeature and EngineFeature2)
		elseif v10 == "Ragdoll" then
			RagdollRigging.createRagdollJoints(p3, p4.RigType, false)
		end
	end

	if v10 ~= "Ragdoll" then
		return
	end

	local connection = nil

	local function disconnect() -- line: 89
		-- upvalues: connection (ref), t1 (copy), p2 (copy), p4 (copy)
		connection:Disconnect()

		if t1[p2] == p4 then
			t1[p2] = nil
		end
	end

	connection = p2.CharacterRemoving:Connect(function(character) -- line: 97
		-- upvalues: p3 (copy), connection (ref), t1 (copy), p2 (copy), p4 (copy)
		if character == p3 then
			connection:Disconnect()

			if t1[p2] == p4 then
				t1[p2] = nil
			end
		end
	end)
	p4.BreakJointsOnDeath = false

	if not EngineFeature then
		RagdollRigging.createRagdollJoints(p3, p4.RigType, EngineFeature and EngineFeature2)
	end

	t1[p2] = p4

	if EngineFeature then
		p4.Died:Connect(function() -- line: 114
			-- upvalues: t1 (copy), p2 (copy), p4 (copy), RagdollRigging (copy), EngineFeature (copy), EngineFeature2 (copy)
			t1[p2] = nil

			local p4Parent = p4.Parent

			if p4Parent and p4Parent:IsA("Model") then
				RagdollRigging.disableMotors(p4Parent, p4.RigType)

				if EngineFeature and EngineFeature2 then
					RagdollRigging.easeNongraphicJointFriction(p4Parent, 0.85)
				end
			end
		end)
	end
end)
