local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local t1 = {
	initStarted = false,
	TestModel = nil,
	hrp = nil,
	humanoid = nil,
	player = nil
}

function t1.Init() -- line: 15
	-- upvalues: t1 (copy), Players (copy), RunService (copy)
	if t1.initStarted then
		return
	end

	t1.initStarted = true

	local v5 = t1.WaitForExpression(function() -- line: 23
		-- upvalues: Players (copy)
		return Players.LocalPlayer
	end, 10, "Players.LocalPlayer not found")

	t1.player = v5

	if v5.Character == nil and RunService:IsServer() then
		if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
			v5:LoadCharacterAsync()
		else
			v5:LoadCharacter()
		end
	end

	t1.WaitForExpression(function() -- line: 37
		-- upvalues: v5 (copy)
		return v5.Character
	end, 10, "LocalPlayer.Character not found")
	t1.hrp = v5.Character:WaitForChild("HumanoidRootPart")
	t1.humanoid = v5.Character:WaitForChild("Humanoid")

	if t1.TestModel == nil then
		t1.TestModel = Instance.new("Model")
		t1.TestModel.Name = "_TestContainer"
		t1.TestModel.Parent = workspace
	end

	t1.PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
end
function t1.AddInstance(p1) -- line: 54
	-- upvalues: t1 (copy)
	local v7 = Instance.new(p1)

	v7.Parent = t1.TestModel

	return v7
end
function t1.CleanUpAfterTest() -- line: 61
	-- upvalues: t1 (copy)
	t1.TestModel:ClearAllChildren()
end
function t1.SetCameraFOV(p2) -- line: 65
	workspace.CurrentCamera.FieldOfView = p2
end
function t1.IsPartOnscreen(p3) -- line: 69
	local _, v11 = workspace.CurrentCamera:WorldToViewportPoint(p3.Position)

	return v11
end
function t1.GetPartViewportPixelPosition(p4) -- line: 75
	local v13, _ = workspace.CurrentCamera:WorldToViewportPoint(p4.Position)

	return Vector2.new(v13.x, v13.y)
end
function t1.MovePlayerToPosition(p5) -- line: 82
	-- upvalues: t1 (copy)
	if t1.hrp ~= nil then
		local v16 = CFrame.new() + p5 + Vector3.new(0, 1 + t1.humanoid.HipHeight, 0)

		t1.hrp.CFrame = v16
	end
end
function t1.SetPlayerCamera(p6, p7) -- line: 91
	-- upvalues: t1 (copy)
	local Head = t1.player.Character:WaitForChild("Head", 10)
	local v20 = CFrame.new(Vector3.new(), p6) + Head.Position - p7 * p6.Unit
	local CurrentCamera = workspace.CurrentCamera

	CurrentCamera.CameraType = Enum.CameraType.Scriptable
	CurrentCamera.CFrame = v20
end
function t1.WaitNFrames(p8) -- line: 102
	-- upvalues: RunService (copy)
	for _ = 1, p8 do
		RunService.RenderStepped:Wait()
	end
end
function t1.WaitWallTime(p9) -- line: 111
	-- upvalues: t1 (copy)
	local timestamp = tick()

	if p9 > 2 then
		warn("Requested wait time too long, waiting 2s")
		p9 = 2
	end

	while not (p9 < tick() - timestamp) do
		t1.WaitNFrames(1)
	end
end
function t1.WaitGameTime(p10) -- line: 129
	-- upvalues: RunService (copy)
	local time, _ = RunService.Stepped:Wait()
	local v29 = time

	while p10 > v29 - time do
		local dt

		v29, dt = RunService.Stepped:Wait()
	end
end
function t1.WaitForExpression(p11, p12, p13) -- line: 138
	-- upvalues: t1 (copy)
	local timestamp = tick()
	local v35 = p11()

	while not v35 and p12 > tick() - timestamp do
		t1.WaitNFrames(1)
		v35 = p11()
	end

	if not v35 then
		error(p13)
	end

	return v35
end
function t1.GetCornersOfBillboardGui(p14) -- line: 156
	-- upvalues: t1 (copy), GuiService (copy)
	local v37 = t1.GetPartViewportPixelPosition(p14.Adornee)
	local vector2 = Vector2.new(p14.SizeOffset.x * p14.AbsoluteSize.x, p14.SizeOffset.y * p14.AbsoluteSize.y)
	local v39 = v37 - GuiService:GetGuiInset() + vector2
	local AbsoluteSize = p14.AbsoluteSize
	local v41 = v39 - AbsoluteSize / 2 + Vector2.new(1, 1)
	local v42 = v39 + Vector2.new(AbsoluteSize.x / 2 - 1, -AbsoluteSize.y / 2 + 1)
	local v43 = v39 + Vector2.new(AbsoluteSize.x / 2 - 1, AbsoluteSize.y / 2 - 1)
	local v44 = v39 + Vector2.new(-AbsoluteSize.x / 2 + 1, AbsoluteSize.y / 2 - 1)

	return {
		center = v39,
		topLeft = v41,
		topRight = v42,
		bottomRight = v43,
		bottomLeft = v44
	}
end

return t1
