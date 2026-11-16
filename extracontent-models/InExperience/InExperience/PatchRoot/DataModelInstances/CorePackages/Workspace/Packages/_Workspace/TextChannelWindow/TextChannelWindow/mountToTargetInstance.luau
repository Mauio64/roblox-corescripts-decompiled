local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local parent = script.Parent.Parent

require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)

local FFlagExpChatTextChannelWindowFixLayerCollectorGeometry = require(script.Parent.Flags.FFlagExpChatTextChannelWindowFixLayerCollectorGeometry)
local createLayerCollectorOverlay = require(script.Parent.createLayerCollectorOverlay)

local defineFastInt = game:DefineFastInt("ExpChatTextChannelWindowMinWidth", 200)
local defineFastInt2 = game:DefineFastInt("ExpChatTextChannelWindowMinHeight", 200)

local v = {}

local function getEffectiveAdornee(instance) -- 2 equivalent calls inferred from this helper
	if instance.Adornee ~= nil then
		return instance.Adornee
	end

	local parent2 = instance.Parent
	return if parent2 and parent2:IsA("BasePart") then parent2 else nil
end

local function createOverlay(textChannelWindow, layerCollector)
	if layerCollector and layerCollector:IsA("SurfaceGui") then
		local surfaceGui = Instance.new("SurfaceGui")
		surfaceGui.Name = "TextChannelWindowOverlay_" .. textChannelWindow.Name
		surfaceGui.ResetOnSpawn = false
		surfaceGui.Adornee = getEffectiveAdornee(layerCollector) -- inferred equivalent call
		surfaceGui.Face = layerCollector.Face
		surfaceGui.SizingMode = layerCollector.SizingMode
		surfaceGui.CanvasSize = layerCollector.CanvasSize
		surfaceGui.Parent = CoreGui
		return surfaceGui
	else
		local screenGui = Instance.new("ScreenGui")
		screenGui.Name = "TextChannelWindowOverlay_" .. textChannelWindow.Name
		screenGui.ResetOnSpawn = false

		if layerCollector and layerCollector:IsA("ScreenGui") then
			screenGui.IgnoreGuiInset = layerCollector.IgnoreGuiInset
			screenGui.DisplayOrder = -1
			screenGui.ZIndexBehavior = layerCollector.ZIndexBehavior
		else
			screenGui.IgnoreGuiInset = true
			screenGui.DisplayOrder = -1
			screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		end

		screenGui.Parent = CoreGui
		return screenGui
	end
end

local function connectGuiObjectSync(textChannelWindow, frame, _, connections)
	local function syncTransform()
		frame.Position = UDim2.fromOffset(textChannelWindow.AbsolutePosition.X, textChannelWindow.AbsolutePosition.Y)
		frame.Size = UDim2.fromOffset(textChannelWindow.AbsoluteSize.X, textChannelWindow.AbsoluteSize.Y)
		frame.Rotation = textChannelWindow.Rotation
	end

	table.insert(connections, textChannelWindow:GetPropertyChangedSignal("AbsolutePosition"):Connect(syncTransform))
	table.insert(connections, textChannelWindow:GetPropertyChangedSignal("AbsoluteSize"):Connect(syncTransform))
	table.insert(connections, textChannelWindow:GetPropertyChangedSignal("Rotation"):Connect(syncTransform))
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
	end))

	table.insert(connections, instance:GetPropertyChangedSignal("CanvasSize"):Connect(function()
		p.CanvasSize = instance.CanvasSize
	end))
end

local function connectScreenGuiSync(instance, p, connections)
	table.insert(connections, instance:GetPropertyChangedSignal("IgnoreGuiInset"):Connect(function()
		p.IgnoreGuiInset = instance.IgnoreGuiInset
	end))

	table.insert(connections, instance:GetPropertyChangedSignal("ZIndexBehavior"):Connect(function()
		p.ZIndexBehavior = instance.ZIndexBehavior
	end))
end

local function connectLayerCollectorSync(layerCollector, p, connections) -- 1 equivalent call inferred from this helper
	if layerCollector == nil then
		return
	end

	if layerCollector:IsA("SurfaceGui") then
		connectSurfaceGuiSync(layerCollector, p, connections)
	elseif layerCollector:IsA("ScreenGui") then
		connectScreenGuiSync(layerCollector, p, connections)
	end
end

local function doMount(textChannelWindow, p)
	if not textChannelWindow:IsA("TextChannelWindow") or v[textChannelWindow] then
		return nil
	end

	local layerCollector = textChannelWindow:FindFirstAncestorWhichIsA("LayerCollector")

	if layerCollector and not (layerCollector:IsA("ScreenGui") or layerCollector:IsA("SurfaceGui")) then
		return nil
	end

	local parent2

	if FFlagExpChatTextChannelWindowFixLayerCollectorGeometry then
		parent2 = createLayerCollectorOverlay.create(textChannelWindow, layerCollector)
	else
		parent2 = createOverlay(textChannelWindow, layerCollector)
	end

	local frame = Instance.new("Frame")
	frame.BackgroundTransparency = 1
	frame.Position = UDim2.fromOffset(textChannelWindow.AbsolutePosition.X, textChannelWindow.AbsolutePosition.Y)
	frame.Size = UDim2.fromOffset(textChannelWindow.AbsoluteSize.X, textChannelWindow.AbsoluteSize.Y)
	frame.Rotation = textChannelWindow.Rotation
	frame.Parent = parent2

	local root = ReactRoblox.createRoot(frame)
	root:render(p)

	local connections = {}

	connectGuiObjectSync(textChannelWindow, frame, parent2, connections)

	if FFlagExpChatTextChannelWindowFixLayerCollectorGeometry then
		createLayerCollectorOverlay.connect(layerCollector, parent2, connections)
	else
		connectLayerCollectorSync(layerCollector, parent2, connections) -- inferred equivalent call
	end

	local function updateEnabled()
		local v2 = parent2
		local enabled = textChannelWindow.IsRendering

		if enabled then
			if defineFastInt <= textChannelWindow.AbsoluteSize.X then
				enabled = defineFastInt2 <= textChannelWindow.AbsoluteSize.Y
			else
				enabled = false
			end
		end

		v2.Enabled = enabled
	end

	local enabled = textChannelWindow.IsRendering

	if enabled then
		if defineFastInt <= textChannelWindow.AbsoluteSize.X then
			enabled = defineFastInt2 <= textChannelWindow.AbsoluteSize.Y
		else
			enabled = false
		end
	end

	parent2.Enabled = enabled

	table.insert(connections, textChannelWindow:GetPropertyChangedSignal("IsRendering"):Connect(updateEnabled))
	table.insert(connections, textChannelWindow:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateEnabled))

	local function unmount()
		for _, connection in connections do
			connection:Disconnect()
		end

		root:unmount()
		parent2:Destroy()
		v[textChannelWindow] = nil
	end

	table.insert(connections, textChannelWindow.Destroying:Connect(unmount))

	v[textChannelWindow] = true
	return unmount
end

local function mountToTargetInstance(instance, p)
	if instance:IsDescendantOf(StarterGui) then
		return nil
	end

	return doMount(instance, p)
end

return mountToTargetInstance
