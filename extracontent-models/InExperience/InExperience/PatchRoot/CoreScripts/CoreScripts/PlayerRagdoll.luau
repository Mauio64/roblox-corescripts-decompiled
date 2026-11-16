local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
game:GetService("StarterPlayer")

local common = CoreGui:FindFirstChild("RobloxGui"):FindFirstChild("Modules"):FindFirstChild("Common")

local RagdollRigging = require(common:FindFirstChild("RagdollRigging"))
local HumanoidReadyUtil = require(common:FindFirstChild("HumanoidReadyUtil"))

local engineFeature = game:GetEngineFeature("AvatarJointUpgradeFeature")

local LocalPlayer = Players.LocalPlayer

if not LocalPlayer then
	Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
	LocalPlayer = Players.LocalPlayer
end

local DeathType = RobloxReplicatedStorage:WaitForChild("DeathType", 1e999)

if not DeathType or not engineFeature and DeathType.Value ~= "Ragdoll" then
	return
end

local onRagdoll

if engineFeature then
	onRagdoll = nil
else
	onRagdoll = RobloxReplicatedStorage:WaitForChild("OnRagdoll", 1e999)

	if not (onRagdoll and onRagdoll:IsA("RemoteEvent")) then
		return
	end
end

local function onOwnedHumanoidDeath(p, instance)
	if engineFeature then
		if DeathType.Value == "Ragdoll" then
			RagdollRigging.disableMotors(p, instance.RigType)
		end
	else
		local v = RagdollRigging.disableMotors(p, instance.RigType)

		local animator = instance:FindFirstChildWhichIsA("Animator")

		if animator then
			animator:ApplyJointVelocities(v)
		end

		onRagdoll:FireServer(instance)

		wait(0.1)

		RagdollRigging.easeJointFriction_OLD(p, 0.85)
	end
end

HumanoidReadyUtil.registerHumanoidReady(function(p, p2, p3)
	local characterRemovingConnection = nil
	local diedConnection = nil
	local function disconnect() -- 2 equivalent calls inferred from this helper
		characterRemovingConnection:Disconnect()
		diedConnection:Disconnect()
	end

	diedConnection = p3.Died:Connect(function()
		disconnect() -- inferred equivalent call

		if DeathType.Value == "Ragdoll" then
			delay(2, function()
				RagdollRigging.disableParticleEmittersAndFadeOut(p2, 0.4)
			end)
		end

		if p == LocalPlayer then
			onOwnedHumanoidDeath(p2, p3)
		end
	end)

	characterRemovingConnection = p.CharacterRemoving:Connect(function(character)
		if character == p2 then
			disconnect() -- inferred equivalent call
		end
	end)
end)
