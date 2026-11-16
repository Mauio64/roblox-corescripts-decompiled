local Players = game:GetService("Players")

local parent = script:FindFirstAncestor("CoreGuiCommon").Parent
local Signals = require(parent.Signals)
local Cryo = require(parent.Cryo)
local createSignal = Signals.createSignal

return function()
	local signal, v = createSignal(nil)

	local signal2, v2 = createSignal({}, Cryo.Dictionary.equals)

	local localPlayer = Players.LocalPlayer
	local childAddedConnection = nil
	local healthChangedConnection = nil
	local diedConnection = nil

	while not localPlayer do
		Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
		localPlayer = Players.LocalPlayer
	end

	local function updateHealthValue()
		local v3 = signal(false)
		v2(v3 and {
			health = v3.Health,
			maxHealth = v3.MaxHealth,
			isDead = v3.Health <= 0
		} or {})
	end

	local function unobserveHumanoid() -- 2 equivalent calls inferred from this helper
		if childAddedConnection then
			childAddedConnection:Disconnect()
			childAddedConnection = nil
		end

		if healthChangedConnection then
			healthChangedConnection:Disconnect()
			healthChangedConnection = nil
		end

		if diedConnection then
			diedConnection:Disconnect()
			diedConnection = nil
		end

		v(nil)
	end

	local function observeHumanoid()
		unobserveHumanoid() -- inferred equivalent call
		local character = localPlayer.Character

		if character then
			local humanoid = character:FindFirstChildOfClass("Humanoid")

			if humanoid then
				v(humanoid)
				healthChangedConnection = humanoid.HealthChanged:Connect(updateHealthValue)
				diedConnection = humanoid.Died:Connect(updateHealthValue)
			else
				childAddedConnection = character.ChildAdded:Connect(function(humanoid2)
					if humanoid2:IsA("Humanoid") then
						observeHumanoid()
					end
				end)
			end
		end

		updateHealthValue()
	end

	local characterAddedConnection = localPlayer.CharacterAdded:Connect(observeHumanoid)
	local characterRemovingConnection = localPlayer.CharacterRemoving:Connect(observeHumanoid)
	observeHumanoid()

	local function cleanup()
		characterAddedConnection:Disconnect()
		characterRemovingConnection:Disconnect()
		unobserveHumanoid() -- inferred equivalent call
	end

	return { getLocalHumanoid = signal, getHealthValue = signal2, cleanup = cleanup }
end
