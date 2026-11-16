local Players = game:GetService("Players")

local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/Signals")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/Cryo")
local createSignal = Signals.createSignal

return function()
	local signal, v5 = createSignal(nil)

	local signal2, v6 = createSignal({}, Cryo.Dictionary.equals)

	local localPlayer = Players.LocalPlayer
	local childAddedConnection = nil
	local healthChangedConnection = nil
	local diedConnection = nil

	while not localPlayer do
		Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
		localPlayer = Players.LocalPlayer
	end

	local function updateHealthValue()
		local v7 = signal(false)
		v6(v7 and {
			health = v7.Health,
			maxHealth = v7.MaxHealth,
			isDead = v7.Health <= 0
		} or {})
	end

	local function unobserveHumanoid()
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

		v5(nil)
	end

	local function observeHumanoid()
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

		v5(nil)

		local character = localPlayer.Character

		if character then
			local humanoid = character:FindFirstChildOfClass("Humanoid")

			if humanoid then
				v5(humanoid)
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

		v5(nil)
	end

	return { getLocalHumanoid = signal, getHealthValue = signal2, cleanup = cleanup }
end
