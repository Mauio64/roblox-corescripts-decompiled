local Players = game:GetService("Players")
local Parent = script:FindFirstAncestor("CoreGuiCommon").Parent
local Signals = require(Parent.Signals)
local Cryo = require(Parent.Cryo)
local createSignal = Signals.createSignal

return function() -- line: 24
	-- upvalues: createSignal (copy), Cryo (copy), Players (copy)
	local v6, v7 = createSignal(nil)
	local v8, v9 = createSignal({}, Cryo.Dictionary.equals)
	local u10 = nil
	local u11 = nil
	local u12 = nil
	local LocalPlayer = Players.LocalPlayer

	while not LocalPlayer do
		Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
		LocalPlayer = Players.LocalPlayer
	end

	local v14 = LocalPlayer

	local function updateHealthValue() -- line: 41
		-- upvalues: v6 (copy), v9 (copy)
		local v20 = v6(false)

		v9(if not v20 then {} else {
			health = v20.Health,
			maxHealth = v20.MaxHealth,
			isDead = v20.Health <= 0
		})
	end
	local function unobserveHumanoid() -- line: 52
		-- upvalues: u12 (ref), u10 (ref), u11 (ref), v7 (copy)
		if u12 then
			u12:Disconnect()
			u12 = nil
		end

		if u10 then
			u10:Disconnect()
			u10 = nil
		end

		if u11 then
			u11:Disconnect()
			u11 = nil
		end

		v7(nil)
	end
	local function observeHumanoid() -- line: 69
		-- upvalues: u12 (ref), u10 (ref), u11 (ref), v7 (copy), v14 (copy), updateHealthValue (copy), observeHumanoid (copy)
		if u12 then
			u12:Disconnect()
			u12 = nil
		end

		if u10 then
			u10:Disconnect()
			u10 = nil
		end

		if u11 then
			u11:Disconnect()
			u11 = nil
		end

		v7(nil)

		local Character = v14.Character

		if Character then
			local Humanoid = Character:FindFirstChildOfClass("Humanoid")

			if Humanoid then
				v7(Humanoid)
				u10 = Humanoid.HealthChanged:Connect(updateHealthValue)
				u11 = Humanoid.Died:Connect(updateHealthValue)
			else
				u12 = Character.ChildAdded:Connect(function(child) -- line: 79
					-- upvalues: observeHumanoid (copy)
					if child:IsA("Humanoid") then
						observeHumanoid()
					end
				end)
			end
		end

		updateHealthValue()
	end

	local connection = v14.CharacterAdded:Connect(observeHumanoid)
	local connection2 = v14.CharacterRemoving:Connect(observeHumanoid)

	observeHumanoid()

	return {
		getLocalHumanoid = v6,
		getHealthValue = v8,
		cleanup = function() -- line: 93
			-- upvalues: connection (copy), connection2 (copy), u12 (ref), u10 (ref), u11 (ref), v7 (copy)
			connection:Disconnect()
			connection2:Disconnect()

			if u12 then
				u12:Disconnect()
				u12 = nil
			end

			if u10 then
				u10:Disconnect()
				u10 = nil
			end

			if u11 then
				u11:Disconnect()
				u11 = nil
			end

			v7(nil)
		end
	}
end
