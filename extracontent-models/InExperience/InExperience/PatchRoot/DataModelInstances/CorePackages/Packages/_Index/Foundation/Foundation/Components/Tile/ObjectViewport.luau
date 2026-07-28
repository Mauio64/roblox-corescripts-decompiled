local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local EventConnection = require(FoundationParent.ReactUtils).EventConnection
local useTokens = require(Foundation.Providers.Style.useTokens)
local withDefaults = require(Foundation.Utility.withDefaults)
local RunService = require(Foundation.Utility.Wrappers).Services.RunService

local function getCameraDistance(n1: number, vector3: Vector3) -- line: 19
	local vector3X = vector3.X
	local vector3Y = vector3.Y
	local vector3Z = vector3.Z

	return math.max(vector3X, vector3Y, vector3Z) * (1 / math.tan(math.rad(n1) / 2)) + vector3Z / 2
end
local function rotateVectorAround(vector3: Vector3, n2: number, vector3_2: Vector3) -- line: 29
	return CFrame.fromAxisAngle(vector3_2, n2):VectorToWorldSpace(vector3)
end

local t1 = {
	rotationSpeed = 0.01,
	fieldOfView = 70
}

local function ObjectViewport(t2: {[any]: any}) -- line: 44
	-- upvalues: withDefaults (copy), t1 (copy), useTokens (copy), React (copy), EventConnection (copy), RunService (copy)
	local v21 = withDefaults(t2, t1)
	local v22 = useTokens()
	local v23, v24 = React.useState(v21.model)
	local v25 = React.useRef(nil)
	local v26 = React.useRef(nil)
	local v27, v28 = React.useBinding(CFrame.new())
	local v29, v30 = React.useBinding(0)
	local v31, v32 = React.useState(CFrame.new())
	local v33, v34 = React.useState((Vector3.new()))
	local v35, v36 = React.useState(0)

	React.useEffect(function() -- line: 59
		-- upvalues: v26 (copy), v23 (copy)
		if v26.current and v23 ~= nil then
			v23.Parent = v26.current
		end

		return function() -- line: 64
			-- upvalues: v23 (copy)
			if v23 ~= nil then
				v23.Parent = nil
			end
		end
	end, {})
	React.useEffect(function() -- line: 71
		-- upvalues: v23 (copy), v32 (copy), v34 (copy), v36 (copy), v21 (copy)
		if v23 ~= nil then
			local Pivot = v23:GetPivot()

			v32(Pivot)
			v34(Pivot.LookVector)

			local ExtentsSize = v23:GetExtentsSize()
			local v39 = v36
			local fieldOfView = v21.fieldOfView
			local ExtentsSizeX = ExtentsSize.X
			local ExtentsSizeY = ExtentsSize.Y
			local ExtentsSizeZ = ExtentsSize.Z

			v39(math.max(ExtentsSizeX, ExtentsSizeY, ExtentsSizeZ) * (1 / math.tan(math.rad(fieldOfView) / 2)) + ExtentsSizeZ / 2)
		end
	end, { v23 })
	React.useEffect(function() -- line: 82
		-- upvalues: v23 (copy), v21 (copy), v26 (copy), v24 (copy)
		if v23 ~= nil then
			v23.Parent = nil
		end

		if v21.model ~= nil then
			v21.model.Parent = v26.current
			v24(v21.model)
		end
	end, { v21.model })

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
			LightColor = v22.Color.Extended.Gray.Gray_200.Color3,
			Ambient = v22.Color.Extended.Gray.Gray_200.Color3,
			CurrentCamera = v25
		}, {
			Camera = React.createElement("Camera", {
				CameraType = Enum.CameraType.Scriptable,
				FieldOfView = v21.fieldOfView,
				CFrame = v27,
				ref = v25
			}),
			WorldModel = React.createElement("WorldModel", {
				ref = v26
			}),
			RenderSteppedConnection = React.createElement(EventConnection, {
				event = RunService.RenderStepped,
				callback = function() -- line: 132
					-- upvalues: v30 (copy), v29 (copy), v21 (copy), v33 (copy), v31 (copy), v35 (copy), v28 (copy)
					v30(v29:getValue() + v21.rotationSpeed or 0)

					local v44 = v33
					local v45 = v29:getValue()
					local v46 = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), v45):VectorToWorldSpace(v44)
					local cFrame = CFrame.new(v31.Position + v46 * v35, v31.Position)

					v28(cFrame)
				end
			})
		})
	})
end

return ObjectViewport
