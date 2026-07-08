local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local EventConnection = require(FoundationParent.ReactUtils).EventConnection
local useTokens = require(Foundation.Providers.Style.useTokens)
local withDefaults = require(Foundation.Utility.withDefaults)
local RunService = require(Foundation.Utility.Wrappers).Services.RunService
local Flags = require(Foundation.Utility.Flags)

local function getCameraDistance(n1: number, vector3: Vector3) -- line: 23
	local vector3X = vector3.X
	local vector3Y = vector3.Y
	local vector3Z = vector3.Z

	return math.max(vector3X, vector3Y, vector3Z) * (1 / math.tan(math.rad(n1) / 2)) + vector3Z / 2
end
local function rotateVectorAround(vector3: Vector3, n2: number, vector3_2: Vector3) -- line: 33
	return CFrame.fromAxisAngle(vector3_2, n2):VectorToWorldSpace(vector3)
end

local t1 = {
	rotationSpeed = 0.01,
	fieldOfView = 70
}

local function ObjectViewport(t2: {[any]: any}) -- line: 48
	-- upvalues: withDefaults (copy), t1 (copy), useTokens (copy), React (copy), Flags (copy), EventConnection (copy), RunService (copy)
	local v22 = withDefaults(t2, t1)
	local v23 = useTokens()
	local v24, v25 = React.useState(v22.model)
	local v26 = React.useRef(nil)
	local v27 = React.useRef(nil)
	local v28, v29 = React.useBinding(CFrame.new())
	local v30, v31 = React.useBinding(0)
	local v32, v33 = React.useState(CFrame.new())
	local v34, v35 = React.useState((Vector3.new()))
	local v36, v37 = React.useState(0)

	React.useEffect(function() -- line: 63
		-- upvalues: v27 (copy), v24 (copy)
		if v27.current and v24 ~= nil then
			v24.Parent = v27.current
		end

		return function() -- line: 68
			-- upvalues: v24 (copy)
			if v24 ~= nil then
				v24.Parent = nil
			end
		end
	end, {})
	React.useEffect(function() -- line: 75
		-- upvalues: v24 (copy), Flags (copy), v33 (copy), v35 (copy), v37 (copy), v22 (copy)
		if v24 ~= nil then
			local v38 = if not Flags.FoundationMigrateDeprecatedApis then v24:GetModelCFrame() else v24:GetPivot()

			v33(v38)
			v35(v38.LookVector)

			local ExtentsSize = v24:GetExtentsSize()
			local v40 = v37
			local fieldOfView = v22.fieldOfView
			local ExtentsSizeX = ExtentsSize.X
			local ExtentsSizeY = ExtentsSize.Y
			local ExtentsSizeZ = ExtentsSize.Z

			v40(math.max(ExtentsSizeX, ExtentsSizeY, ExtentsSizeZ) * (1 / math.tan(math.rad(fieldOfView) / 2)) + ExtentsSizeZ / 2)
		end
	end, { v24 })
	React.useEffect(function() -- line: 88
		-- upvalues: v24 (copy), v22 (copy), v27 (copy), v25 (copy)
		if v24 ~= nil then
			v24.Parent = nil
		end

		if v22.model ~= nil then
			v22.model.Parent = v27.current
			v25(v22.model)
		end
	end, { v22.model })

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.fromScale(0, 0),
		AnchorPoint = Vector2.new(0, 0),
		Size = UDim2.fromScale(1, 1)
	}, {
		AspectRatioConstraint = React.createElement("UIAspectRatioConstraint", {
			AspectRatio = 1,
			AspectType = Enum.AspectType.FitWithinMaxSize,
			DominantAxis = Enum.DominantAxis.Width
		}),
		ViewportFrame = React.createElement("ViewportFrame", {
			BackgroundTransparency = 1,
			LightDirection = Vector3.new(1, 1, 1),
			Size = UDim2.new(1, 25, 1, 25),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			LightColor = v23.Color.Extended.Gray.Gray_200.Color3,
			Ambient = v23.Color.Extended.Gray.Gray_200.Color3,
			CurrentCamera = v26
		}, {
			Camera = React.createElement("Camera", {
				CameraType = Enum.CameraType.Scriptable,
				FieldOfView = v22.fieldOfView,
				CFrame = v28,
				ref = v26
			}),
			WorldModel = React.createElement("WorldModel", {
				ref = v27
			}),
			RenderSteppedConnection = React.createElement(EventConnection, {
				event = RunService.RenderStepped,
				callback = function() -- line: 138
					-- upvalues: v31 (copy), v30 (copy), v22 (copy), v34 (copy), Flags (copy), v32 (copy), v36 (copy), v29 (copy)
					v31(v30:getValue() + v22.rotationSpeed or 0)

					local v45 = v34
					local v46 = v30:getValue()
					local v47 = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), v46):VectorToWorldSpace(v45)
					local v48 = if not Flags.FoundationMigrateDeprecatedApis then CFrame.new(v32.p + v47 * v36, v32.p) else CFrame.new(v32.Position + v47 * v36, v32.Position)

					v29(v48)
				end
			})
		})
	})
end

return ObjectViewport
