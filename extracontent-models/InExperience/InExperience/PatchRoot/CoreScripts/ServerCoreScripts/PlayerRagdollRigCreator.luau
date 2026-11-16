local CoreGui = game:GetService("CoreGui")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
game:GetService("StarterPlayer")

local common = CoreGui:FindFirstChild("RobloxGui"):FindFirstChild("Modules"):FindFirstChild("Common")

local engineFeature = game:GetEngineFeature("AvatarJointUpgradeFeature")
local engineFeature2 = game:GetEngineFeature("AvatarJointUpgradeDefaultOnFeature")
local function jointUpgradeActive() -- 4 equivalent calls inferred from this helper
	return engineFeature and engineFeature2
end

local RagdollRigging = require(common:FindFirstChild("RagdollRigging"))
local HumanoidReadyUtil = require(common:FindFirstChild("HumanoidReadyUtil"))

local function getDefaultDeathType()
	if not game:GetEngineFeature("PolicyInfoForServerRobloxOnlyAsyncEnabled") then
		return game:DefineFastString("DeathTypeValue", "Classic")
	end

	local PolicyService = game:GetService("PolicyService")
	local defaultAvatarDeathType = PolicyService:GetPolicyInfoForServerRobloxOnlyAsync().DefaultAvatarDeathType

	if defaultAvatarDeathType == nil then
		error("PolicyService did not have death type policy")
	end

	return defaultAvatarDeathType
end

local defaultDeathType = getDefaultDeathType()

local deathType = Instance.new("StringValue")
deathType.Name = "DeathType"
deathType.Value = defaultDeathType
deathType.Parent = RobloxReplicatedStorage

if not engineFeature and defaultDeathType ~= "Ragdoll" then
	return
end

local v = {}

if not engineFeature then
	local onRagdoll = Instance.new("RemoteEvent")
	onRagdoll.Name = "OnRagdoll"
	onRagdoll.OnServerEvent:Connect(function(p, p2)
		if p2 and v[p] == p2 then
			local parent = p2 and p2.Parent

			if parent and parent:IsA("Model") then
				RagdollRigging.disableMotors(parent, p2.RigType)
			end

			v[p] = nil
		end
	end)
	onRagdoll.Parent = RobloxReplicatedStorage
end

HumanoidReadyUtil.registerHumanoidReady(function(p, p2, state)
	if engineFeature then
		if state.RigType == Enum.HumanoidRigType.R15 and jointUpgradeActive() then -- inferred equivalent call
			RagdollRigging.createRagdollJoints(p2, state.RigType, jointUpgradeActive()) -- inferred equivalent call
		elseif defaultDeathType == "Ragdoll" then
			RagdollRigging.createRagdollJoints(p2, state.RigType, false)
		end
	end

	if defaultDeathType ~= "Ragdoll" then
		return
	end

	local characterRemovingConnection = nil
	local function disconnect() -- 1 equivalent call inferred from this helper
		characterRemovingConnection:Disconnect()

		if v[p] == state then
			v[p] = nil
		end
	end

	characterRemovingConnection = p.CharacterRemoving:Connect(function(character)
		if character == p2 then
			disconnect() -- inferred equivalent call
		end
	end)

	state.BreakJointsOnDeath = false

	if not engineFeature then
		RagdollRigging.createRagdollJoints(p2, state.RigType, jointUpgradeActive()) -- inferred equivalent call
	end

	v[p] = state

	if engineFeature then
		state.Died:Connect(function()
			v[p] = nil

			local parent = state.Parent

			if parent and parent:IsA("Model") then
				RagdollRigging.disableMotors(parent, state.RigType)

				if jointUpgradeActive() then -- inferred equivalent call
					RagdollRigging.easeNongraphicJointFriction(parent, 0.85)
				end
			end
		end)
	end
end)
