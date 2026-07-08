local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local ExternalEventConnection = require(CorePackages.Workspace.Packages.RoactUtils).ExternalEventConnection
local RunService = game:GetService("RunService")
local v6 = Roact.PureComponent:extend("ObjectViewport")

v6.validateProps = t.strictInterface({
	model = t.instanceOf("Model")
})

local function getCameraDistance(p1, p2) -- line: 23
	local p2X = p2.X
	local p2Y = p2.Y
	local p2Z = p2.Z
	local v14 = math.max(p2X, p2Y, p2Z)
	local v15 = 1 / math.tan(math.rad(p1) / 2)

	return v14 / 2 * v15 + p2Z / 2
end
local function rotateVectorAround(p3, p4, p5) -- line: 33
	return CFrame.fromAxisAngle(p5, p4):VectorToWorldSpace(p3)
end

function v6.init(p6) -- line: 37
	-- upvalues: Roact (copy)
	p6.cameraRef = Roact.createRef()
	p6.worldModelRef = Roact.createRef()

	local v20, v21 = Roact.createBinding(CFrame.new())

	p6.cameraCFrameBinding = v20
	p6.updateCameraCFrameBinding = v21

	local v22, v23 = Roact.createBinding(0)

	p6.cameraRotationBinding = v22
	p6.updateCameraRotationBinding = v23

	local v24, v25 = Roact.createBinding(CFrame.new())

	p6.cameraFocusBinding = v24
	p6.updateCameraFocusBinding = v25
	p6:OnModelChanged()
end
function v6.OnModelChanged(p7) -- line: 49
	if p7.props.model ~= nil then
		p7.modelCFrame = p7.props.model:GetModelCFrame()
		p7.initialLookVector = p7.modelCFrame.lookVector
		p7.modelExtentsSize = p7.props.model:GetExtentsSize()

		local modelExtentsSize = p7.modelExtentsSize
		local modelExtentsSizeX = modelExtentsSize.X
		local modelExtentsSizeY = modelExtentsSize.Y
		local modelExtentsSizeZ = modelExtentsSize.Z

		p7.cameraDistance = math.max(modelExtentsSizeX, modelExtentsSizeY, modelExtentsSizeZ) / 2 * 1.4281480067421146 + modelExtentsSizeZ / 2
	end
end
function v6.render(p8) -- line: 58
	-- upvalues: Roact (copy), ExternalEventConnection (copy), RunService (copy)
	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.fromScale(0, 0),
		AnchorPoint = Vector2.new(0, 0),
		Size = UDim2.fromScale(1, 1)
	}, {
		AspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
			AspectRatio = 1,
			AspectType = Enum.AspectType.FitWithinMaxSize,
			DominantAxis = Enum.DominantAxis.Width
		}),
		ViewportFrame = Roact.createElement("ViewportFrame", {
			BackgroundTransparency = 0,
			LightDirection = Vector3.new(1, 1, 1),
			BackgroundColor3 = Color3.new(0, 0, 0),
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			LightColor = Color3.fromRGB(240, 240, 240),
			Ambient = Color3.fromRGB(240, 240, 240),
			CurrentCamera = p8.cameraRef
		}, {
			Camera = Roact.createElement("Camera", {
				CameraType = Enum.CameraType.Scriptable,
				FieldOfView = 70,
				CFrame = p8.cameraCFrameBinding,
				Focus = p8.cameraFocusBinding,
				[Roact.Ref] = p8.cameraRef
			}),
			WorldModel = Roact.createElement("WorldModel", {
				[Roact.Ref] = p8.worldModelRef
			}),
			RenderSteppedConnection = Roact.createElement(ExternalEventConnection, {
				event = RunService.RenderStepped,
				callback = function() -- line: 99
					-- upvalues: p8 (copy)
					p8.updateCameraRotationBinding(p8.cameraRotationBinding:getValue() + 0.01)

					local initialLookVector = p8.initialLookVector
					local v37 = p8.cameraRotationBinding:getValue()
					local v38 = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), v37):VectorToWorldSpace(initialLookVector)
					local cFrame = CFrame.new(p8.modelCFrame.p + v38 * p8.cameraDistance, p8.modelCFrame.p)

					p8.updateCameraCFrameBinding(cFrame)
				end
			})
		})
	})
end
function v6.didMount(p9) -- line: 112
	if p9.worldModelRef:getValue() and p9.props.model ~= nil then
		p9.props.model.Parent = p9.worldModelRef:getValue()
	end
end
function v6.willUnmount(p10) -- line: 118
	if p10.props.model then
		p10.props.model.Parent = nil
	end
end
function v6.didUpdate(p11, p12) -- line: 124
	if p11.props.model ~= p12.model then
		if p12.model ~= nil then
			p12.model.Parent = nil
		end

		if p11.props.model ~= nil then
			p11.props.model.Parent = p11.worldModelRef:getValue()
		end

		p11:OnModelChanged()
	end
end

return v6
