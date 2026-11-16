local CoreGui = game:GetService("CoreGui")

local function getEffectiveAdornee(instance) -- 2 equivalent calls inferred from this helper
	if instance.Adornee ~= nil then
		return instance.Adornee
	end

	local parent = instance.Parent
	return if parent and parent:IsA("BasePart") then parent else nil
end

local function connectSurfaceGuiSync(instance, p, connections)
	local function syncAdornee()
		p.Adornee = getEffectiveAdornee(instance) -- inferred equivalent call
	end
	table.insert(connections, instance:GetPropertyChangedSignal("Adornee"):Connect(syncAdornee))

	table.insert(connections, instance:GetPropertyChangedSignal("Parent"):Connect(syncAdornee))
	table.insert(connections, instance:GetPropertyChangedSignal("Face"):Connect(function()
		p.Face = instance.Face
	end))

	table.insert(connections, instance:GetPropertyChangedSignal("SizingMode"):Connect(function()
		p.SizingMode = instance.SizingMode

		p.CanvasSize = instance.CanvasSize
		p.PixelsPerStud = instance.PixelsPerStud
	end))

	table.insert(connections, instance:GetPropertyChangedSignal("CanvasSize"):Connect(function()
		p.CanvasSize = instance.CanvasSize
	end))

	table.insert(connections, instance:GetPropertyChangedSignal("PixelsPerStud"):Connect(function()
		p.PixelsPerStud = instance.PixelsPerStud
	end))
end

local function connectScreenGuiSync(instance, p, connections) -- 1 equivalent call inferred from this helper
	table.insert(connections, instance:GetPropertyChangedSignal("ZIndexBehavior"):Connect(function()
		p.ZIndexBehavior = instance.ZIndexBehavior
	end))
end

local CreateLayerCollectorOverlay = {}

function CreateLayerCollectorOverlay.create(p, instance)
	if instance and instance:IsA("SurfaceGui") then
		local surfaceGui = Instance.new("SurfaceGui")
		surfaceGui.Name = "TextChannelWindowOverlay_" .. p.Name
		surfaceGui.ResetOnSpawn = false
		surfaceGui.Adornee = getEffectiveAdornee(instance) -- inferred equivalent call
		surfaceGui.Face = instance.Face
		surfaceGui.SizingMode = instance.SizingMode
		surfaceGui.CanvasSize = instance.CanvasSize

		surfaceGui.PixelsPerStud = instance.PixelsPerStud
		surfaceGui.Parent = CoreGui
		return surfaceGui
	else
		local screenGui = Instance.new("ScreenGui")
		screenGui.Name = "TextChannelWindowOverlay_" .. p.Name
		screenGui.ResetOnSpawn = false

		if instance and instance:IsA("ScreenGui") then
			screenGui.IgnoreGuiInset = false
			screenGui.ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets
			screenGui.DisplayOrder = -1
			screenGui.ZIndexBehavior = instance.ZIndexBehavior
		else
			screenGui.IgnoreGuiInset = true
			screenGui.DisplayOrder = -1
			screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		end

		screenGui.Parent = CoreGui
		return screenGui
	end
end

function CreateLayerCollectorOverlay.connect(instance, p, connections)
	if instance == nil then
		return
	end

	if instance:IsA("SurfaceGui") then
		connectSurfaceGuiSync(instance, p, connections)
	elseif instance:IsA("ScreenGui") then
		connectScreenGuiSync(instance, p, connections) -- inferred equivalent call
	end
end

return CreateLayerCollectorOverlay
