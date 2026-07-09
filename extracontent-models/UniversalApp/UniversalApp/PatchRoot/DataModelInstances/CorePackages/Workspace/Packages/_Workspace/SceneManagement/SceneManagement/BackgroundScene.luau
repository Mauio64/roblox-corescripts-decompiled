local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Parent = script:FindFirstAncestor("SceneManagement").Parent
local Object = require(Parent.LuauPolyfill).Object
local FFlagSkipBackgroundModelMoveInWorkspace = require(Parent.SharedFlags).FFlagSkipBackgroundModelMoveInWorkspace
local t1 = {
	FieldOfView = 50,
	Position = Vector3.new(0, 20, 0)
}
local t2 = {
	PositionOffset = Vector3.new(0, 0, 0),
	RotationOffset = Vector3.new(0, 0, 0),
	DistanceToCamera = 60
}

local function getOrCreateCamera() -- line: 37
	local CurrentCamera = workspace.CurrentCamera

	if CurrentCamera == nil then
		CurrentCamera = Instance.new("Camera")
		CurrentCamera.Parent = workspace
	end

	return CurrentCamera
end
local function configureCamera(p1, t3: {[any]: any}?) -- line: 46
	-- upvalues: Object (copy), t1 (copy)
	local v15 = Object.assign({}, t1, t3 or {})

	p1.FieldOfView = v15.FieldOfView
	p1.CFrame = CFrame.new(v15.Position)
	p1.CameraType = Enum.CameraType.Fixed
end
local function configureBackground(p2, p3, t4: {[any]: any}) -- line: 58
	-- upvalues: Object (copy), t2 (copy)
	local v20 = Object.assign({}, t2, t4)
	local PositionOffset = v20.PositionOffset
	local RotationOffset = v20.RotationOffset
	local DistanceToCamera = v20.DistanceToCamera
	local v24 = p3.CFrame.Position + DistanceToCamera * p3.CFrame.LookVector + PositionOffset

	p2:PivotTo(CFrame.new(v24) * CFrame.Angles(math.rad(RotationOffset.X), math.rad(RotationOffset.Y), (math.rad(RotationOffset.Z))))
end
local function initBackgroundScene(t5: {[any]: any}) -- line: 75
	-- upvalues: configureCamera (copy), FFlagSkipBackgroundModelMoveInWorkspace (copy), Workspace (copy), ReplicatedStorage (copy), configureBackground (copy)
	local CurrentCamera = workspace.CurrentCamera

	if CurrentCamera == nil then
		CurrentCamera = Instance.new("Camera")
		CurrentCamera.Parent = workspace
	end

	configureCamera(CurrentCamera, t5.CameraConfigs)

	local BackgroundConfigs = t5.BackgroundConfigs
	local BackgroundModelName = BackgroundConfigs.BackgroundModelName

	if FFlagSkipBackgroundModelMoveInWorkspace then
		local BackgroundModelName2 = Workspace:FindFirstChild(BackgroundModelName)

		if BackgroundModelName2 then
			return BackgroundModelName2, CurrentCamera
		end
	end

	assert(ReplicatedStorage:FindFirstChild(BackgroundModelName) ~= nil, string.format("Background Model %s is missing in ReplicatedStorage.", BackgroundModelName))

	local BackgroundModelName3 = ReplicatedStorage:WaitForChild(BackgroundModelName)

	if BackgroundModelName3 then
		BackgroundModelName3.Parent = workspace
	end

	configureBackground(BackgroundModelName3, CurrentCamera, BackgroundConfigs)

	return BackgroundModelName3, CurrentCamera
end

return {
	initialize = initBackgroundScene,
	getBackgroundInstance = function(s1: string) -- line: 53
		return (workspace:FindFirstChild(s1))
	end,
	updateXPosition = function(s2: string, n1: number) -- line: 100
		local s2_2 = workspace:FindFirstChild(s2)

		if s2_2 then
			local Pivot = s2_2:GetPivot()
			local PivotPosition = Pivot.Position
			local v36 = Pivot - PivotPosition
			local vector3 = Vector3.new(n1, PivotPosition.Y, PivotPosition.Z)

			s2_2:PivotTo(CFrame.new(vector3) * v36)
		end
	end,
	updateZPosition = function(s3: string, n2: number) -- line: 112
		local s3_2 = workspace:FindFirstChild(s3)

		if s3_2 then
			local Pivot = s3_2:GetPivot()
			local PivotPosition = Pivot.Position
			local v43 = Pivot - PivotPosition
			local vector3 = Vector3.new(PivotPosition.X, PivotPosition.Y, n2)

			s3_2:PivotTo(CFrame.new(vector3) * v43)
		end
	end
}
