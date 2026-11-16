require(script.Parent.Parent.EventType)

local MoveToGoalEvent = { Name = "MoveToGoalEvent" }

local touchedConnection = nil

local function spawnGoalArea(vector3: Vector3, vector3_2: Vector3)
	local part = Instance.new("Part")
	part.Anchored = true
	part.CanCollide = false
	part.Transparency = 1
	part.Size = Vector3.new(math.abs(vector3_2.X - vector3.X), 1, (math.abs(vector3_2.Z - vector3.Z)))
	part.Position = Vector3.new((vector3_2.X + vector3.X) / 2, 6.3, (vector3_2.Z + vector3.Z) / 2)
	part.Parent = workspace

	return part
end

function MoveToGoalEvent.StartEvent(callback)
	local part = Instance.new("Part")
	part.Anchored = true
	part.CanCollide = false
	part.Transparency = 1
	part.Size = Vector3.new(17, 1, 18)
	part.Position = Vector3.new(0.5, 6.3, -40)
	part.Parent = workspace

	task.wait(1)

	touchedConnection = part.Touched:Connect(function(otherPart)
		if game.Players:GetPlayerFromCharacter(otherPart.Parent) then
			part:Destroy()

			task.wait(0.2)
			callback()

			if touchedConnection then
				touchedConnection:Disconnect()
				touchedConnection = nil
			end
		end
	end)
end

function MoveToGoalEvent.StopEvent()
	if touchedConnection then
		touchedConnection:Disconnect()
		touchedConnection = nil
	end
end

return MoveToGoalEvent
