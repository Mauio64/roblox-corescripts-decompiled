local scriptParent = script.Parent
local DragBar = require(scriptParent.DragBar)
local Constants = require(scriptParent.Constants)
local CoreGui = game:GetService("CoreGui")

return function(p1) -- line: 8
	-- upvalues: CoreGui (copy), Constants (copy), DragBar (copy)
	local Part = Instance.new("Part")

	Part.Size = Vector3.new(0.6000000238418579, 0.11999999731779099, 9.999999747378752E-06)
	Part.Name = p1.name .. "_DragBar"
	Part.Color = Color3.new(1, 1, 1)
	Part.Parent = workspace.CurrentCamera
	Part.Anchored = true
	Part.CanTouch = true
	Part.CanCollide = false
	Part.CastShadow = false
	Part.Material = Enum.Material.Glass
	Part.Transparency = 1

	local DragDetector = Instance.new("DragDetector")

	DragDetector.Enabled = true
	DragDetector.Parent = Part
	DragDetector.DragStyle = Enum.DragDetectorDragStyle.BestForDevice

	local SurfaceGui = Instance.new("SurfaceGui", CoreGui)

	SurfaceGui.Name = "dragBar_SurfaceGui"
	SurfaceGui.Enabled = true
	SurfaceGui.CanvasSize = Vector2.new(Part.Size.X, Part.Size.Y) * Constants.VR_PANEL_RESOLUTION_MULTIPLIER
	SurfaceGui.AlwaysOnTop = true
	SurfaceGui.Shape = Enum.SurfaceGuiShape.Flat
	SurfaceGui.HorizontalCurvature = 0
	SurfaceGui.Active = true
	SurfaceGui.Adornee = Part
	SurfaceGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	SurfaceGui.LightInfluence = 0
	SurfaceGui.ZOffset = 0
	SurfaceGui.Face = Enum.NormalId.Back

	local ImageLabel = Instance.new("ImageLabel")

	ImageLabel.Image = "rbxasset://textures/ui/InGameMenu/DragBar_Bright.png"
	ImageLabel.Parent = SurfaceGui
	ImageLabel.BackgroundTransparency = 1
	ImageLabel.BackgroundColor3 = Color3.new(1, 1, 1)
	ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	ImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
	ImageLabel.Size = UDim2.new(0.5, 0, 0.25, 0)
	ImageLabel.ImageColor3 = Color3.new(1, 1, 1)
	DragDetector.RunLocally = true

	if p1.dragFunction then
		DragDetector.DragContinue:Connect(p1.dragFunction)
	end

	if p1.dragStartFunction then
		DragDetector.DragStart:Connect(p1.dragStartFunction)
	end

	if p1.dragEndFunction then
		DragDetector.DragEnd:Connect(p1.dragEndFunction)
	end

	return (DragBar.new(Part, ImageLabel))
end
