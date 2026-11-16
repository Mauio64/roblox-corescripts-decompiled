local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")

local PlayerHelper = {}
PlayerHelper.initStarted = false
PlayerHelper.TestModel = nil
PlayerHelper.hrp = nil
PlayerHelper.humanoid = nil
PlayerHelper.player = nil

function PlayerHelper.Init()
	if PlayerHelper.initStarted then
		return
	end

	PlayerHelper.initStarted = true

	local player = PlayerHelper.WaitForExpression(function()
		return Players.LocalPlayer
	end, 10, "Players.LocalPlayer not found")

	PlayerHelper.player = player

	if player.Character == nil and RunService:IsServer() then
		player:LoadCharacterAsync()
	end

	PlayerHelper.WaitForExpression(function()
		return player.Character
	end, 10, "LocalPlayer.Character not found")

	PlayerHelper.hrp = player.Character:WaitForChild("HumanoidRootPart")
	PlayerHelper.humanoid = player.Character:WaitForChild("Humanoid")

	if PlayerHelper.TestModel == nil then
		PlayerHelper.TestModel = Instance.new("Model")
		PlayerHelper.TestModel.Name = "_TestContainer"
		PlayerHelper.TestModel.Parent = workspace
	end

	PlayerHelper.PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
end

function PlayerHelper.AddInstance(className)
	local instance = Instance.new(className)
	instance.Parent = PlayerHelper.TestModel
	return instance
end

function PlayerHelper.CleanUpAfterTest()
	PlayerHelper.TestModel:ClearAllChildren()
end

function PlayerHelper.SetCameraFOV(fieldOfView)
	workspace.CurrentCamera.FieldOfView = fieldOfView
end

function PlayerHelper.IsPartOnscreen(p)
	local _, v = workspace.CurrentCamera:WorldToViewportPoint(p.Position)
	return v
end

function PlayerHelper.GetPartViewportPixelPosition(p)
	local worldToViewportPoint, _ = workspace.CurrentCamera:WorldToViewportPoint(p.Position)
	return Vector2.new(worldToViewportPoint.x, worldToViewportPoint.y)
end

function PlayerHelper.MovePlayerToPosition(p)
	if PlayerHelper.hrp ~= nil then
		local cframe = CFrame.new() + p + Vector3.new(0, 1 + PlayerHelper.humanoid.HipHeight, 0)
		PlayerHelper.hrp.CFrame = cframe
	end
end

function PlayerHelper.SetPlayerCamera(p, p2)
	local head = PlayerHelper.player.Character:WaitForChild("Head", 10)
	local cframe = CFrame.new(Vector3.new(), p) + head.Position - p2 * p.Unit

	local currentCamera = workspace.CurrentCamera
	currentCamera.CameraType = Enum.CameraType.Scriptable
	currentCamera.CFrame = cframe
end

function PlayerHelper.WaitNFrames(p)
	for _ = 1, p do
		RunService.RenderStepped:Wait()
	end
end

function PlayerHelper.WaitWallTime(p)
	local lastTime = tick()

	if p > 2 then
		warn("Requested wait time too long, waiting 2s")
		p = 2
	end

	while not (p < tick() - lastTime) do
		PlayerHelper.WaitNFrames(1)
	end
end

function PlayerHelper.WaitGameTime(p)
	local v, _ = RunService.Stepped:Wait()
	local v2 = v

	while v2 - v < p do
		local v3
		v2, v3 = RunService.Stepped:Wait()
	end
end

function PlayerHelper.WaitForExpression(callback, p, message)
	local lastTime = tick()
	local v = callback()

	while not v and tick() - lastTime < p do
		PlayerHelper.WaitNFrames(1)
		v = callback()
	end

	if not v then
		error(message)
	end

	return v
end

function PlayerHelper.GetCornersOfBillboardGui(data)
	local partViewportPixelPosition = PlayerHelper.GetPartViewportPixelPosition(data.Adornee)
	local vector2 = Vector2.new(data.SizeOffset.x * data.AbsoluteSize.x, data.SizeOffset.y * data.AbsoluteSize.y)
	local center = partViewportPixelPosition - GuiService:GetGuiInset() + vector2
	local absoluteSize = data.AbsoluteSize

	return {
		center = center,
		topLeft = center - absoluteSize / 2 + Vector2.new(1, 1),
		topRight = center + Vector2.new(absoluteSize.x / 2 - 1, -absoluteSize.y / 2 + 1),
		bottomRight = center + Vector2.new(absoluteSize.x / 2 - 1, absoluteSize.y / 2 - 1),
		bottomLeft = center + Vector2.new(-absoluteSize.x / 2 + 1, absoluteSize.y / 2 - 1)
	}
end

return PlayerHelper
