local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local Cryo = require(CorePackages.Packages.Cryo)
local t = require(CorePackages.Packages.t)
local v5 = t.strictInterface({
	regularProps = t.optional(t.table),
	modelRef = t.optional(t.strictInterface({
		value = t.instanceIsA("Model")
	})),
	cameraFocusPoint = t.optional(t.Vector3),
	cameraLookVector = t.optional(t.Vector3),
	cameraDistance = t.optional(t.number),
	cameraUpVector = t.optional(t.Vector3)
})
local v6 = Roact.PureComponent:extend("ViewportFrame")

v6.defaultProps = {
	cameraDistance = 6,
	cameraUpVector = Vector3.FromAxis(Enum.Axis.Y)
}

function v6.init(p1) -- line: 38
	-- upvalues: Roact (copy)
	p1.viewportRef = Roact.createRef()
	p1.model = nil
	p1.camera = nil
end
function v6.updateModel(p2) -- line: 45
	if p2.model ~= nil then
		p2.model.Parent = nil
		p2.model = nil
	end

	local modelRef = p2.props.modelRef

	if p2.viewportRef.current == nil or modelRef == nil then
		return
	end

	p2.model = modelRef.value
	p2.model.Parent = p2.viewportRef.current
end
function v6.updateCamera(p3) -- line: 65
	if p3.viewportRef.current == nil or p3.model == nil then
		return
	end

	if p3.camera == nil then
		p3.camera = Instance.new("Camera")
		p3.camera.Name = "Camera"
		p3.camera.CameraType = Enum.CameraType.Scriptable
		p3.camera.Parent = p3.viewportRef.current
		p3.viewportRef.current.CurrentCamera = p3.camera
	end

	local v11 = p3.props.cameraFocusPoint or (p3.model.PrimaryPart ~= nil and p3.model.PrimaryPart.Position or Vector3.new(0, 0, 0))
	local v12 = (p3.props.cameraLookVector or (p3.model.PrimaryPart ~= nil and -p3.model.PrimaryPart.CFrame.lookVector or Vector3.new(0, 0, 1))) * p3.props.cameraDistance
	local v13 = v11 - v12

	p3.camera.CFrame = CFrame.fromMatrix(v13, v12:Cross(p3.props.cameraUpVector).Unit, v12:Cross(p3.props.cameraUpVector):Cross(v12).Unit)
end
function v6.updateViewport(p4) -- line: 101
	p4:updateModel()
	p4:updateCamera()
end
function v6.didMount(p5) -- line: 106
	p5:updateViewport()
end
function v6.willUnmount(p6) -- line: 110
	if p6.model ~= nil then
		p6.model.Parent = nil
		p6.model = nil
	end

	if p6.camera ~= nil then
		p6.camera.Parent = nil
		p6.camera = nil
	end
end
function v6.didUpdate(p7, p8) -- line: 122
	if p8.modelRef ~= p7.props.modelRef then
		p7:updateViewport()

		return
	end

	if p8.cameraFocusPoint ~= p7.props.cameraFocusPoint or p8.cameraLookVector ~= p7.props.cameraLookVector or p8.cameraDistance ~= p7.props.cameraDistance then
		p7:updateCamera()
	end
end
function v6.render(p9) -- line: 134
	-- upvalues: v5 (copy), Cryo (copy), Roact (copy)
	assert(v5(p9.props))

	local v20 = p9.props.regularProps or {}
	local v21 = Cryo.Dictionary.join(v20, {
		[Roact.Ref] = p9.viewportRef
	})

	return Roact.createElement("ViewportFrame", v21)
end

return v6
