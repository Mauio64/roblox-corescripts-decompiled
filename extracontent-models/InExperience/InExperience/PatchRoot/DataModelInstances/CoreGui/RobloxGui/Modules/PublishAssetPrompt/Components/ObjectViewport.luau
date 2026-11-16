local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local ExternalEventConnection = RoactUtils.ExternalEventConnection
local RunService = game:GetService("RunService")

local extended = Roact.PureComponent:extend("ObjectViewport")

extended.validateProps = t.strictInterface({ model = t.instanceOf("Model") })

local function getCameraDistance(p, data)
	local x = data.X
	local y = data.Y
	local z = data.Z

	local v = math.max(x, y, z)

	local v2 = 1 / math.tan(math.rad(p) / 2)
	return v / 2 * v2 + z / 2
end

local function rotateVectorAround(initialLookVector, p, p2) -- 1 equivalent call inferred from this helper
	return CFrame.fromAxisAngle(p2, p):VectorToWorldSpace(initialLookVector)
end

function extended:init()
	self.cameraRef = Roact.createRef()
	self.worldModelRef = Roact.createRef()

	local binding, updateCameraCFrameBinding = Roact.createBinding(CFrame.new())
	self.cameraCFrameBinding = binding
	self.updateCameraCFrameBinding = updateCameraCFrameBinding
	local binding2, updateCameraRotationBinding = Roact.createBinding(0)
	self.cameraRotationBinding = binding2
	self.updateCameraRotationBinding = updateCameraRotationBinding
	local binding3, updateCameraFocusBinding = Roact.createBinding(CFrame.new())
	self.cameraFocusBinding = binding3
	self.updateCameraFocusBinding = updateCameraFocusBinding

	self:OnModelChanged()
end

function extended:OnModelChanged()
	if self.props.model ~= nil then
		self.modelCFrame = self.props.model:GetModelCFrame()
		self.initialLookVector = self.modelCFrame.lookVector
		self.modelExtentsSize = self.props.model:GetExtentsSize()
		local modelExtentsSize = self.modelExtentsSize
		local x = modelExtentsSize.X
		local y = modelExtentsSize.Y
		local z = modelExtentsSize.Z

		self.cameraDistance = math.max(x, y, z) / 2 * 1.4281480067421146 + z / 2
	end
end

function extended.render(props)
	return Roact.createElement(
		"Frame",
		{
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(0, 0),
			AnchorPoint = Vector2.new(0, 0),
			Size = UDim2.fromScale(1, 1)
		},
		{
			AspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
				AspectRatio = 1,
				AspectType = Enum.AspectType.FitWithinMaxSize,
				DominantAxis = Enum.DominantAxis.Width
			}),
			ViewportFrame = Roact.createElement("ViewportFrame", {
				BackgroundTransparency = 0,
				BackgroundColor3 = Color3.new(0, 0, 0),
				Size = UDim2.fromScale(1, 1),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				LightColor = Color3.fromRGB(240, 240, 240),
				LightDirection = Vector3.new(1, 1, 1),
				Ambient = Color3.fromRGB(240, 240, 240),
				CurrentCamera = props.cameraRef
			}, {
				Camera = Roact.createElement("Camera", {
					CameraType = Enum.CameraType.Scriptable,
					FieldOfView = 70,
					CFrame = props.cameraCFrameBinding,
					Focus = props.cameraFocusBinding,
					[Roact.Ref] = props.cameraRef
				}),
				WorldModel = Roact.createElement("WorldModel", { [Roact.Ref] = props.worldModelRef }),
				RenderSteppedConnection = Roact.createElement(ExternalEventConnection, {
					event = RunService.RenderStepped,
					callback = function()
						props.updateCameraRotationBinding(props.cameraRotationBinding:getValue() + 0.01)

						local v = rotateVectorAround( -- inferred equivalent call
							props.initialLookVector,
							props.cameraRotationBinding:getValue(),
							Vector3.new(0, 1, 0)
						)

						local cframe = CFrame.new(props.modelCFrame.p + v * props.cameraDistance, props.modelCFrame.p)
						props.updateCameraCFrameBinding(cframe)
					end
				})
			})
		}
	)
end

function extended.didMount(p)
	if p.worldModelRef:getValue() and p.props.model ~= nil then
		p.props.model.Parent = p.worldModelRef:getValue()
	end
end

function extended.willUnmount(p)
	if p.props.model then
		p.props.model.Parent = nil
	end
end

function extended:didUpdate(p)
	if self.props.model ~= p.model then
		if p.model ~= nil then
			p.model.Parent = nil
		end

		if self.props.model ~= nil then
			self.props.model.Parent = self.worldModelRef:getValue()
		end

		self:OnModelChanged()
	end
end

return extended
