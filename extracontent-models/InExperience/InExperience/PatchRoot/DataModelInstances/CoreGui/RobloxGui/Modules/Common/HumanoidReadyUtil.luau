local Players = game:GetService("Players")

local function waitForFirst(...) -- line: 5
	local BindableEvent = Instance.new("BindableEvent")
	local t1 = { ... }

	local function fire(...) -- line: 9
		-- upvalues: t1 (copy), BindableEvent (copy)
		for i = 1, #t1 do
			t1[i]:Disconnect()
		end

		return BindableEvent:Fire(...)
	end

	for i = 1, #t1 do
		t1[i] = t1[i]:Connect(fire)
	end

	return BindableEvent.Event:Wait()
end

return {
	registerHumanoidReady = function(p1) -- line: 37
		-- upvalues: waitForFirst (copy), Players (copy)
		local function characterAdded(p2, p3) -- line: 39
			-- upvalues: waitForFirst (copy), p1 (copy)
			if not p3.Parent then
				waitForFirst(p3.AncestryChanged, p2.CharacterAdded)
			end

			if p3 ~= p2.Character or not p3.Parent then
				return
			end

			local Humanoid = p3:FindFirstChildOfClass("Humanoid")

			while p3:IsDescendantOf(game) and not Humanoid do
				waitForFirst(p3.ChildAdded, p3.AncestryChanged, p2.CharacterAdded)
				Humanoid = p3:FindFirstChildOfClass("Humanoid")
			end

			if p3 ~= p2.Character or not p3:IsDescendantOf(game) then
				return
			end

			local HumanoidRootPart = p3:FindFirstChild("HumanoidRootPart")

			while p3:IsDescendantOf(game) and not HumanoidRootPart do
				waitForFirst(p3.ChildAdded, p3.AncestryChanged, Humanoid.AncestryChanged, p2.CharacterAdded)
				HumanoidRootPart = p3:FindFirstChild("HumanoidRootPart")
			end

			if HumanoidRootPart and Humanoid:IsDescendantOf(game) and p3:IsDescendantOf(game) and p3 == p2.Character then
				p1(p2, p3, Humanoid)
			end
		end
		local function playerAdded(p4) -- line: 79
			-- upvalues: characterAdded (copy)
			local connection = p4.CharacterAdded:Connect(function(character) -- line: 80
				-- upvalues: characterAdded (copy), p4 (copy)
				characterAdded(p4, character)
			end)
			local connection2 = nil

			connection2 = p4.AncestryChanged:Connect(function(_, parent) -- line: 86
				-- upvalues: connection2 (ref), connection (copy)
				if not game:IsAncestorOf(parent) then
					connection2:Disconnect()
					connection:Disconnect()
				end
			end)

			local Character = p4.Character

			if Character then
				characterAdded(p4, Character)
			end
		end

		Players.PlayerAdded:Connect(playerAdded)

		for _, player in pairs(Players:GetPlayers()) do
			playerAdded(player)
		end
	end
}
