local CorePackages = game:GetService("CorePackages")
local t = require(CorePackages.Packages.t)
local v3 = t.strictInterface({
	model = t.instanceIsA("Model"),
	cameraFieldOfView = t.optional(t.numberConstrained(1, 120)),
	upVector = t.optional(t.Vector3),
	lookVector = t.optional(t.Vector3),
	bottomOffset = t.optional(t.numberMin(0)),
	topOffset = t.optional(t.numberMin(0))
})

local function getCameraSettingsToFitModel(p1) -- line: 28
	-- upvalues: v3 (copy)
	assert(v3(p1))

	local clone = p1.model:Clone()
	local v7 = p1.cameraFieldOfView or 70
	local v8 = p1.upVector.Unit or Vector3.fromAxis(Enum.Axis.Y)
	local v9 = p1.lookVector.Unit or Vector3.fromAxis(Enum.Axis.Z)
	local v10 = v8:Cross(v9)
	local v11 = p1.bottomOffset or 0
	local v12 = p1.topOffset or 0

	assert(math.abs((v8:Dot(v9))) < 1E-05, "upVector and lookVector must be perpendicular")

	local PrimaryPart = clone.PrimaryPart
	local v14 = PrimaryPart and PrimaryPart.CFrame.Position or Vector3.new()
	local cFrame = CFrame.fromMatrix(Vector3.new(), v10, v8)
	local Part = Instance.new("Part", clone)

	Part.Size = Vector3.new(0, 0, 0)
	clone.PrimaryPart = Part
	Part.CFrame = cFrame * CFrame.fromMatrix(Vector3.new(), Vector3.fromAxis(Enum.Axis.X), (Vector3.new(0, math.cos(v7 * 3.141592653589793 / 360), (math.sin(v7 * 3.141592653589793 / 360))))) + v14

	local v17, v18 = clone:GetBoundingBox()
	local v19 = v17 + cFrame * Vector3.new(0, -v11, 0)
	local v20 = v19:VectorToWorldSpace(Vector3.fromAxis(Enum.Axis.Y)):Dot(v14 - v19.Position) + v18.Y / 2
	local v21 = Part.Position - v20 * v19.UpVector
	local LookVector = v19.LookVector

	Part.CFrame = cFrame * CFrame.fromMatrix(Vector3.new(), Vector3.fromAxis(Enum.Axis.X), (Vector3.new(0, math.cos(v7 * 3.141592653589793 / 360), -math.sin(v7 * 3.141592653589793 / 360)))) + v14

	local v23, v24 = clone:GetBoundingBox()
	local v25 = v23 + cFrame * Vector3.new(0, v12, 0)
	local v26 = v25:VectorToWorldSpace(Vector3.fromAxis(Enum.Axis.Y)):Dot(v25.Position - v14) + v24.Y / 2
	local v27 = Part.Position + v26 * v25.UpVector
	local LookVector2 = v25.LookVector

	clone:Destroy()

	local v29 = v21 + LookVector * LookVector2:Cross(v27 - v21).Magnitude / LookVector2:Cross(LookVector).Magnitude
	local v30 = (v14 - v29):Dot(v9)
	local v31 = v29 + v30 * v9

	return {
		distance = v30,
		focusPoint = v31
	}
end

return getCameraSettingsToFitModel
