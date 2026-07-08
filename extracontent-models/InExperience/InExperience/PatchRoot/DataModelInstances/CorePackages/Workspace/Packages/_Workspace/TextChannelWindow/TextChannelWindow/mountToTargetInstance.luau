local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local ParentParent = script.Parent.Parent

require(ParentParent.React)

local ReactRoblox = require(ParentParent.ReactRoblox)
local t1 = {}
local t2 = {}

local function createOverlay(p1, p2) -- line: 15
	-- upvalues: CoreGui (copy)
	if p2 and p2:IsA("SurfaceGui") then
		local SurfaceGui = Instance.new("SurfaceGui")

		SurfaceGui.Name = "TextChannelWindowOverlay_" .. p1.Name
		SurfaceGui.ResetOnSpawn = false
		SurfaceGui.Adornee = p2.Adornee
		SurfaceGui.Face = p2.Face
		SurfaceGui.SizingMode = p2.SizingMode
		SurfaceGui.CanvasSize = p2.CanvasSize
		SurfaceGui.Parent = CoreGui

		return SurfaceGui
	end

	local ScreenGui = Instance.new("ScreenGui")

	ScreenGui.Name = "TextChannelWindowOverlay_" .. p1.Name
	ScreenGui.ResetOnSpawn = false

	if p2 and p2:IsA("ScreenGui") then
		ScreenGui.IgnoreGuiInset = p2.IgnoreGuiInset
		ScreenGui.DisplayOrder = -1
		ScreenGui.ZIndexBehavior = p2.ZIndexBehavior
	else
		ScreenGui.IgnoreGuiInset = true
		ScreenGui.DisplayOrder = -1
		ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	end

	ScreenGui.Parent = CoreGui

	return ScreenGui
end
local function connectGuiObjectSync(p3, p4, _, t3: {[any]: any}) -- line: 46
	local function syncTransform() -- line: 52
		-- upvalues: p4 (copy), p3 (copy)
		p4.Position = UDim2.fromOffset(p3.AbsolutePosition.X, p3.AbsolutePosition.Y)
		p4.Size = UDim2.fromOffset(p3.AbsoluteSize.X, p3.AbsoluteSize.Y)
		p4.Rotation = p3.Rotation
	end

	table.insert(t3, p3:GetPropertyChangedSignal("AbsolutePosition"):Connect(syncTransform))
	table.insert(t3, p3:GetPropertyChangedSignal("AbsoluteSize"):Connect(syncTransform))
	table.insert(t3, p3:GetPropertyChangedSignal("Rotation"):Connect(syncTransform))
end
local function connectSurfaceGuiSync(p6, p7, t4: {[any]: any}) -- line: 63
	table.insert(t4, p6:GetPropertyChangedSignal("Adornee"):Connect(function() -- line: 66
		-- upvalues: p7 (copy), p6 (copy)
		p7.Adornee = p6.Adornee
	end))
	table.insert(t4, p6:GetPropertyChangedSignal("Face"):Connect(function() -- line: 72
		-- upvalues: p7 (copy), p6 (copy)
		p7.Face = p6.Face
	end))
	table.insert(t4, p6:GetPropertyChangedSignal("SizingMode"):Connect(function() -- line: 78
		-- upvalues: p7 (copy), p6 (copy)
		p7.SizingMode = p6.SizingMode
	end))
	table.insert(t4, p6:GetPropertyChangedSignal("CanvasSize"):Connect(function() -- line: 84
		-- upvalues: p7 (copy), p6 (copy)
		p7.CanvasSize = p6.CanvasSize
	end))
end
local function connectScreenGuiSync(p8, p9, t5: {[any]: any}) -- line: 90
	table.insert(t5, p8:GetPropertyChangedSignal("IgnoreGuiInset"):Connect(function() -- line: 93
		-- upvalues: p9 (copy), p8 (copy)
		p9.IgnoreGuiInset = p8.IgnoreGuiInset
	end))
	table.insert(t5, p8:GetPropertyChangedSignal("ZIndexBehavior"):Connect(function() -- line: 99
		-- upvalues: p9 (copy), p8 (copy)
		p9.ZIndexBehavior = p8.ZIndexBehavior
	end))
end
local function connectLayerCollectorSync(p10, p11, t6: {[any]: any}) -- line: 105
	-- upvalues: connectSurfaceGuiSync (copy), connectScreenGuiSync (copy)
	if p10 == nil then
		return
	end

	if p10:IsA("SurfaceGui") then
		connectSurfaceGuiSync(p10, p11, t6)

		return
	end

	if p10:IsA("ScreenGui") then
		connectScreenGuiSync(p10, p11, t6)
	end
end
local function doMount(p12, p13) -- line: 120
	-- upvalues: t1 (copy), createOverlay (copy), ReactRoblox (copy), connectGuiObjectSync (copy), connectSurfaceGuiSync (copy), connectScreenGuiSync (copy)
	if not p12:IsA("TextChannelWindow") then
		return nil
	end

	if t1[p12] then
		return nil
	end

	local LayerCollector = p12:FindFirstAncestorWhichIsA("LayerCollector")

	if LayerCollector and not LayerCollector:IsA("ScreenGui") and not LayerCollector:IsA("SurfaceGui") then
		return nil
	end

	local v35 = createOverlay(p12, LayerCollector)
	local Frame = Instance.new("Frame")

	Frame.BackgroundTransparency = 1
	Frame.Position = UDim2.fromOffset(p12.AbsolutePosition.X, p12.AbsolutePosition.Y)
	Frame.Size = UDim2.fromOffset(p12.AbsoluteSize.X, p12.AbsoluteSize.Y)
	Frame.Rotation = p12.Rotation
	Frame.Parent = v35

	local v37 = ReactRoblox.createRoot(Frame)

	v37:render(p13)

	local t7 = {}

	connectGuiObjectSync(p12, Frame, v35, t7)

	if LayerCollector ~= nil then
		if LayerCollector:IsA("SurfaceGui") then
			connectSurfaceGuiSync(LayerCollector, v35, t7)
		elseif LayerCollector:IsA("ScreenGui") then
			connectScreenGuiSync(LayerCollector, v35, t7)
		end
	end

	v35.Enabled = p12.IsRendering
	table.insert(t7, p12:GetPropertyChangedSignal("IsRendering"):Connect(function() -- line: 155
		-- upvalues: v35 (copy), p12 (copy)
		v35.Enabled = p12.IsRendering
	end))

	local function unmount() -- line: 160
		-- upvalues: t7 (copy), v37 (copy), v35 (copy), t1 (copy), p12 (copy)
		for _, v46 in t7 do
			v46:Disconnect()
		end

		v37:unmount()
		v35:Destroy()
		t1[p12] = nil
	end

	table.insert(t7, p12.Destroying:Connect(unmount))
	t1[p12] = true

	return unmount
end
local function mountToTargetInstance(p14, p15) -- line: 175
	-- upvalues: StarterGui (copy), t2 (copy), doMount (copy)
	if p14:IsDescendantOf(StarterGui) then
		return nil
	end

	if p14.AbsoluteSize.X == 0 and p14.AbsoluteSize.Y == 0 then
		t2[p14] = true

		local connection = nil
		local connection2 = nil

		local function cleanup() -- line: 188
			-- upvalues: connection (ref), connection2 (ref), t2 (copy), p14 (copy)
			connection:Disconnect()
			connection2:Disconnect()
			t2[p14] = nil
		end

		connection = p14:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 194
			-- upvalues: p14 (copy), connection (ref), connection2 (ref), t2 (copy), p14 (copy), doMount (copy), p15 (copy)
			if p14.AbsoluteSize.X ~= 0 or p14.AbsoluteSize.Y ~= 0 then
				connection:Disconnect()
				connection2:Disconnect()
				t2[p14] = nil
				doMount(p14, p15)
			end
		end)
		connection2 = p14.Destroying:Connect(cleanup)

		return nil
	end

	return (doMount(p14, p15))
end

return mountToTargetInstance
