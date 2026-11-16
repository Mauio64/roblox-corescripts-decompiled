local Players = game:GetService("Players")

local function waitForFirst(...)
	local bindableEvent = Instance.new("BindableEvent")
	local connections = { ... }

	local function fire(...)
		for i = 1, #connections do
			connections[i]:Disconnect()
		end

		return bindableEvent:Fire(...)
	end

	for i = 1, #connections do
		connections[i] = connections[i]:Connect(fire)
	end

	return bindableEvent.Event:Wait()
end

return {
	registerHumanoidReady = function(callback)
		local function characterAdded(player, character)
			if not character.Parent then
				waitForFirst(character.AncestryChanged, player.CharacterAdded)
			end

			if player.Character ~= character or not character.Parent then
				return
			end

			local humanoid = character:FindFirstChildOfClass("Humanoid")

			while character:IsDescendantOf(game) and not humanoid do
				waitForFirst(character.ChildAdded, character.AncestryChanged, player.CharacterAdded)
				humanoid = character:FindFirstChildOfClass("Humanoid")
			end

			if player.Character ~= character or not character:IsDescendantOf(game) then
				return
			end

			local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

			while character:IsDescendantOf(game) and not humanoidRootPart do
				waitForFirst(
					character.ChildAdded,
					character.AncestryChanged,
					humanoid.AncestryChanged,
					player.CharacterAdded
				)
				humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
			end

			if
				humanoidRootPart
				and humanoid:IsDescendantOf(game)
				and character:IsDescendantOf(game)
				and player.Character == character
			then
				callback(player, character, humanoid)
			end
		end

		local function playerAdded(player)
			local characterAddedConnection = player.CharacterAdded:Connect(function(character)
				characterAdded(player, character)
			end)

			local ancestryChangedConnection = nil
			ancestryChangedConnection = player.AncestryChanged:Connect(function(_, parent)
				if not game:IsAncestorOf(parent) then
					ancestryChangedConnection:Disconnect()
					characterAddedConnection:Disconnect()
				end
			end)

			local character = player.Character

			if character then
				characterAdded(player, character)
			end
		end

		Players.PlayerAdded:Connect(playerAdded)

		for _, v in pairs(Players:GetPlayers()) do
			playerAdded(v)
		end
	end
}
