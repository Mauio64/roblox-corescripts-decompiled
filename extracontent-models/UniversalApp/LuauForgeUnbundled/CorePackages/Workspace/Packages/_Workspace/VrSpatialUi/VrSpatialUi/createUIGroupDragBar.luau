local DragBar = require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/VrSpatialUi/DragBar")
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/VrSpatialUi/Constants")
local CoreGui = game:GetService("CoreGui")

return function(data)
	local part = Instance.new("Part")
	part.Size = not data.dragBarPartSize and Vector3.new(0.6, 0.12, 0.00001)
		or Vector3.new(data.dragBarPartSize.X, data.dragBarPartSize.Y, 0.00001)

	part.Name = data.name .. "_DragBar"
	part.Color = Color3.new(1, 1, 1)
	part.Parent = workspace.CurrentCamera
	part.Anchored = true
	part.CanTouch = true
	part.CanCollide = false
	part.CastShadow = false
	part.Material = Enum.Material.Glass
	part.Transparency = 1

	local dragDetector = Instance.new("DragDetector")
	dragDetector.Enabled = true
	dragDetector.Parent = part
	dragDetector.DragStyle = Enum.DragDetectorDragStyle.BestForDevice

	local dragBar_SurfaceGui = Instance.new("SurfaceGui")
	dragBar_SurfaceGui.Parent = CoreGui
	dragBar_SurfaceGui.Name = "dragBar_SurfaceGui"
	dragBar_SurfaceGui.Enabled = true
	dragBar_SurfaceGui.CanvasSize = Vector2.new(part.Size.X, part.Size.Y) * Constants.VR_PANEL_RESOLUTION_MULTIPLIER
	dragBar_SurfaceGui.AlwaysOnTop = true
	dragBar_SurfaceGui.Shape = Enum.SurfaceGuiShape.Flat
	dragBar_SurfaceGui.HorizontalCurvature = 0
	dragBar_SurfaceGui.Active = true
	dragBar_SurfaceGui.Adornee = part
	dragBar_SurfaceGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	dragBar_SurfaceGui.LightInfluence = 0
	dragBar_SurfaceGui.ZOffset = 0
	dragBar_SurfaceGui.Face = Enum.NormalId.Back

	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Image = "rbxasset://textures/ui/InGameMenu/DragBar_Bright.png"
	imageLabel.Parent = dragBar_SurfaceGui
	imageLabel.BackgroundTransparency = 1
	imageLabel.BackgroundColor3 = Color3.new(1, 1, 1)
	imageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	imageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
	imageLabel.Size = UDim2.new(0.5, 0, 0.25, 0)
	imageLabel.ImageColor3 = Color3.new(1, 1, 1)

	dragDetector.RunLocally = true

	if data.dragFunction then
		dragDetector.DragContinue:Connect(data.dragFunction)
	end

	if data.dragStartFunction then
		dragDetector.DragStart:Connect(data.dragStartFunction)
	end

	if data.dragEndFunction then
		dragDetector.DragEnd:Connect(data.dragEndFunction)
	end

	return (DragBar.new(part, imageLabel))
end
