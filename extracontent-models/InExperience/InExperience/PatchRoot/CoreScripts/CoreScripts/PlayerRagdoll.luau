local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")

game:GetService("StarterPlayer")

local Common = CoreGui:FindFirstChild("RobloxGui"):FindFirstChild("Modules"):FindFirstChild("Common")
local RagdollRigging = require(Common:FindFirstChild("RagdollRigging"))
local HumanoidReadyUtil = require(Common:FindFirstChild("HumanoidReadyUtil"))
local EngineFeature = game:GetEngineFeature("AvatarJointUpgradeFeature")
local LocalPlayer = Players.LocalPlayer

if not LocalPlayer then
	Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
	LocalPlayer = Players.LocalPlayer
end

local DeathType = RobloxReplicatedStorage:WaitForChild("DeathType", 1e999)

if not DeathType or not EngineFeature and DeathType.Value ~= "Ragdoll" then
	return
end

local OnRagdoll = nil

if not EngineFeature then
	OnRagdoll = RobloxReplicatedStorage:WaitForChild("OnRagdoll", 1e999)

	if not OnRagdoll or not OnRagdoll:IsA("RemoteEvent") then
		return
	end
end

local function onOwnedHumanoidDeath(p1, p2) -- line: 36
	-- upvalues: EngineFeature (copy), DeathType (copy), RagdollRigging (copy), OnRagdoll (ref)
	if EngineFeature then
		if DeathType.Value == "Ragdoll" then
			RagdollRigging.disableMotors(p1, p2.RigType)

			return
		end
	else
		local v14 = RagdollRigging.disableMotors(p1, p2.RigType)
		local Animator = p2:FindFirstChildWhichIsA("Animator")

		if Animator then
			Animator:ApplyJointVelocities(v14)
		end

		OnRagdoll:FireServer(p2)
		wait(0.1)
		RagdollRigging.easeJointFriction_OLD(p1, 0.85)
	end
end

HumanoidReadyUtil.registerHumanoidReady(function(p3, p4, p5) -- line: 91
	-- upvalues: DeathType (copy), RagdollRigging (copy), LocalPlayer (ref), onOwnedHumanoidDeath (copy)
	local connection = nil
	local connection2 = nil

	local function disconnect() -- line: 94
		-- upvalues: connection (ref), connection2 (ref)
		connection:Disconnect()
		connection2:Disconnect()
	end

	connection2 = p5.Died:Connect(function() -- line: 100
		-- upvalues: connection (ref), connection2 (ref), DeathType (copy), RagdollRigging (copy), p4 (copy), p3 (copy), LocalPlayer (ref), onOwnedHumanoidDeath (copy), p5 (copy)
		connection:Disconnect()
		connection2:Disconnect()

		if DeathType.Value == "Ragdoll" then
			delay(2, function() -- line: 105
				-- upvalues: RagdollRigging (copy), p4 (copy)
				RagdollRigging.disableParticleEmittersAndFadeOut(p4, 0.4)
			end)
		end

		if p3 == LocalPlayer then
			onOwnedHumanoidDeath(p4, p5)
		end
	end)
	connection = p3.CharacterRemoving:Connect(function(character) -- line: 117
		-- upvalues: p4 (copy), connection (ref), connection2 (ref)
		if character == p4 then
			connection:Disconnect()
			connection2:Disconnect()
		end
	end)
end)
