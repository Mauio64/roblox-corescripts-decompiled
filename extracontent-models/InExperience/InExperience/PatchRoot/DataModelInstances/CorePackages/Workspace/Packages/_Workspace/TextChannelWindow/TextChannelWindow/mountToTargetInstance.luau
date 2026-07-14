local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local ParentParent = script.Parent.Parent

require(ParentParent.React)

local ReactRoblox = require(ParentParent.ReactRoblox)
local v5 = game:DefineFastInt("ExpChatTextChannelWindowMinWidth", 200)
local v6 = game:DefineFastInt("ExpChatTextChannelWindowMinHeight", 200)
local t1 = {}

local function getEffectiveAdornee(p1) -- line: 17
	if p1.Adornee ~= nil then
		return p1.Adornee
	end

	local p1Parent = p1.Parent

	if p1Parent and p1Parent:IsA("BasePart") then
		return p1Parent
	end

	return nil
end
local function createOverlay(p2, p3) -- line: 28
	-- upvalues: CoreGui (copy)
	if p3 and p3:IsA("SurfaceGui") then
		local SurfaceGui = Instance.new("SurfaceGui")

		SurfaceGui.Name = "TextChannelWindowOverlay_" .. p2.Name
		SurfaceGui.ResetOnSpawn = false

		local p3Adornee

		if p3.Adornee ~= nil then
			p3Adornee = p3.Adornee
		else
			local p3Parent = p3.Parent

			p3Adornee = if not p3Parent or not p3Parent:IsA("BasePart") then nil else p3Parent
		end

		SurfaceGui.Adornee = p3Adornee
		SurfaceGui.Face = p3.Face
		SurfaceGui.SizingMode = p3.SizingMode
		SurfaceGui.CanvasSize = p3.CanvasSize
		SurfaceGui.Parent = CoreGui

		return SurfaceGui
	end

	local ScreenGui = Instance.new("ScreenGui")

	ScreenGui.Name = "TextChannelWindowOverlay_" .. p2.Name
	ScreenGui.ResetOnSpawn = false

	if p3 and p3:IsA("ScreenGui") then
		ScreenGui.IgnoreGuiInset = p3.IgnoreGuiInset
		ScreenGui.DisplayOrder = -1
		ScreenGui.ZIndexBehavior = p3.ZIndexBehavior
	else
		ScreenGui.IgnoreGuiInset = true
		ScreenGui.DisplayOrder = -1
		ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	end

	ScreenGui.Parent = CoreGui

	return ScreenGui
end
local function connectGuiObjectSync(p4, p5, _, t2: {[any]: any}) -- line: 59
	local function syncTransform() -- line: 65
		-- upvalues: p5 (copy), p4 (copy)
		p5.Position = UDim2.fromOffset(p4.AbsolutePosition.X, p4.AbsolutePosition.Y)
		p5.Size = UDim2.fromOffset(p4.AbsoluteSize.X, p4.AbsoluteSize.Y)
		p5.Rotation = p4.Rotation
	end

	table.insert(t2, p4:GetPropertyChangedSignal("AbsolutePosition"):Connect(syncTransform))
	table.insert(t2, p4:GetPropertyChangedSignal("AbsoluteSize"):Connect(syncTransform))
	table.insert(t2, p4:GetPropertyChangedSignal("Rotation"):Connect(syncTransform))
end
local function connectSurfaceGuiSync(p7, p8, t3: {[any]: any}) -- line: 76
	local function syncAdornee() -- line: 77
		-- upvalues: p8 (copy), p7 (copy)
		local v50 = p8
		local v51 = p7
		local Adornee

		if v51.Adornee ~= nil then
			Adornee = v51.Adornee
		else
			local Parent = v51.Parent

			Adornee = if not Parent or not Parent:IsA("BasePart") then nil else Parent
		end

		v50.Adornee = Adornee
	end

	table.insert(t3, p7:GetPropertyChangedSignal("Adornee"):Connect(syncAdornee))
	table.insert(t3, p7:GetPropertyChangedSignal("Parent"):Connect(syncAdornee))
	table.insert(t3, p7:GetPropertyChangedSignal("Face"):Connect(function() -- line: 85
		-- upvalues: p8 (copy), p7 (copy)
		p8.Face = p7.Face
	end))
	table.insert(t3, p7:GetPropertyChangedSignal("SizingMode"):Connect(function() -- line: 91
		-- upvalues: p8 (copy), p7 (copy)
		p8.SizingMode = p7.SizingMode
	end))
	table.insert(t3, p7:GetPropertyChangedSignal("CanvasSize"):Connect(function() -- line: 97
		-- upvalues: p8 (copy), p7 (copy)
		p8.CanvasSize = p7.CanvasSize
	end))
end
local function connectScreenGuiSync(p9, p10, t4: {[any]: any}) -- line: 103
	table.insert(t4, p9:GetPropertyChangedSignal("IgnoreGuiInset"):Connect(function() -- line: 106
		-- upvalues: p10 (copy), p9 (copy)
		p10.IgnoreGuiInset = p9.IgnoreGuiInset
	end))
	table.insert(t4, p9:GetPropertyChangedSignal("ZIndexBehavior"):Connect(function() -- line: 112
		-- upvalues: p10 (copy), p9 (copy)
		p10.ZIndexBehavior = p9.ZIndexBehavior
	end))
end
local function connectLayerCollectorSync(p11, p12, t5: {[any]: any}) -- line: 118
	-- upvalues: connectSurfaceGuiSync (copy), connectScreenGuiSync (copy)
	if p11 == nil then
		return
	end

	if p11:IsA("SurfaceGui") then
		connectSurfaceGuiSync(p11, p12, t5)

		return
	end

	if p11:IsA("ScreenGui") then
		connectScreenGuiSync(p11, p12, t5)
	end
end
local function doMount(p13, p14) -- line: 133
	-- upvalues: t1 (copy), createOverlay (copy), ReactRoblox (copy), connectGuiObjectSync (copy), connectSurfaceGuiSync (copy), connectScreenGuiSync (copy), v5 (copy), v6 (copy)
	if not p13:IsA("TextChannelWindow") then
		return nil
	end

	if t1[p13] then
		return nil
	end

	local LayerCollector = p13:FindFirstAncestorWhichIsA("LayerCollector")

	if LayerCollector and not LayerCollector:IsA("ScreenGui") and not LayerCollector:IsA("SurfaceGui") then
		return nil
	end

	local v42 = createOverlay(p13, LayerCollector)
	local Frame = Instance.new("Frame")

	Frame.BackgroundTransparency = 1
	Frame.Position = UDim2.fromOffset(p13.AbsolutePosition.X, p13.AbsolutePosition.Y)
	Frame.Size = UDim2.fromOffset(p13.AbsoluteSize.X, p13.AbsoluteSize.Y)
	Frame.Rotation = p13.Rotation
	Frame.Parent = v42

	local v44 = ReactRoblox.createRoot(Frame)

	v44:render(p14)

	local t6 = {}

	connectGuiObjectSync(p13, Frame, v42, t6)

	if LayerCollector ~= nil then
		if LayerCollector:IsA("SurfaceGui") then
			connectSurfaceGuiSync(LayerCollector, v42, t6)
		elseif LayerCollector:IsA("ScreenGui") then
			connectScreenGuiSync(LayerCollector, v42, t6)
		end
	end

	local function updateEnabled() -- line: 165
		-- upvalues: v42 (copy), p13 (copy), p13 (copy), v5 (copy), v6 (copy)
		v42.Enabled = p13.IsRendering and (p13.AbsoluteSize.X >= v5 and p13.AbsoluteSize.Y >= v6)
	end

	v42.Enabled = p13.IsRendering and (p13.AbsoluteSize.X >= v5 and p13.AbsoluteSize.Y >= v6)
	table.insert(t6, p13:GetPropertyChangedSignal("IsRendering"):Connect(updateEnabled))
	table.insert(t6, p13:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateEnabled))

	local function unmount() -- line: 174
		-- upvalues: t6 (copy), v44 (copy), v42 (copy), t1 (copy), p13 (copy)
		for _, v55 in t6 do
			v55:Disconnect()
		end

		v44:unmount()
		v42:Destroy()
		t1[p13] = nil
	end

	table.insert(t6, p13.Destroying:Connect(unmount))
	t1[p13] = true

	return unmount
end
local function mountToTargetInstance(p15, p16) -- line: 189
	-- upvalues: StarterGui (copy), doMount (copy)
	if p15:IsDescendantOf(StarterGui) then
		return nil
	end

	return (doMount(p15, p16))
end

return mountToTargetInstance
