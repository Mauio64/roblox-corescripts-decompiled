require(script.Parent.Parent.EventType)

local t1 = {
	Name = "MoveToGoalEvent"
}
local u2 = nil

local function spawnGoalArea(vector3: Vector3, vector3_2: Vector3) -- line: 11
	local Part = Instance.new("Part")

	Part.Anchored = true
	Part.CanCollide = false
	Part.Transparency = 1
	Part.Size = Vector3.new(math.abs(vector3_2.X - vector3.X), 1, (math.abs(vector3_2.Z - vector3.Z)))
	Part.Position = Vector3.new((vector3_2.X + vector3.X) / 2, 6.3, (vector3_2.Z + vector3.Z) / 2)
	Part.Parent = workspace

	return Part
end

function t1.StartEvent(p1) -- line: 24
	-- upvalues: u2 (ref)
	local Part = Instance.new("Part")

	Part.Anchored = true
	Part.CanCollide = false
	Part.Transparency = 1
	Part.Size = Vector3.new(17, 1, 18)
	Part.Position = Vector3.new(0.5, 6.300000190734863, -40)
	Part.Parent = workspace

	local v9 = Part

	task.wait(1)
	u2 = v9.Touched:Connect(function(part) -- line: 32
		-- upvalues: v9 (copy), p1 (copy), u2 (ref)
		if game.Players:GetPlayerFromCharacter(part.Parent) then
			v9:Destroy()
			task.wait(0.2)
			p1()

			if u2 then
				u2:Disconnect()
				u2 = nil
			end
		end
	end)
end
function t1.StopEvent() -- line: 51
	-- upvalues: u2 (ref)
	if u2 then
		u2:Disconnect()
		u2 = nil
	end
end

return t1
