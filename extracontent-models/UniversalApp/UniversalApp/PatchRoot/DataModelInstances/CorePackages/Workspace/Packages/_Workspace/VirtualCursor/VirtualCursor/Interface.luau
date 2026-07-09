local VirtualCursor = script:FindFirstAncestor("VirtualCursor")
local VirtualCursorParent = VirtualCursor.Parent
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local VRService = game:GetService("VRService")
local _ = CoreGui.RobloxGui
local Properties = require(VirtualCursor.Properties)
local getFFlagVirtualCursorDisplayOrder = require(VirtualCursorParent.SharedFlags).getFFlagVirtualCursorDisplayOrder
local t1 = {}
local t2 = {
	Default = "rbxasset://textures/ui/VirtualCursor/cursorDefault.png",
	Hover = "rbxasset://textures/ui/VirtualCursor/cursorHover.png",
	Pressed = "rbxasset://textures/ui/VirtualCursor/cursorPressed.png",
	Arrow = "rbxasset://textures/ui/VirtualCursor/cursorArrow.png"
}
local ScreenGui = nil
local ImageLabel = nil
local u13 = nil
local u14 = nil
local tween = nil
local tween2 = nil
local u17 = nil
local t3 = {
	Default = 2,
	Activated = 1.7
}

local function getCursorSize(p1) -- line: 45
	-- upvalues: t3 (copy), Properties (copy)
	local v26 = t3[p1] * Properties.CursorRadius

	return UDim2.fromOffset(v26, v26)
end
local function setCursorHighlight(p2) -- line: 50
	-- upvalues: ImageLabel (ref)
	if p2 then
		ImageLabel.Image = "rbxasset://textures/ui/VirtualCursor/cursorHover.png"

		return
	end

	ImageLabel.Image = "rbxasset://textures/ui/VirtualCursor/cursorDefault.png"
end
local function setCursorPosition(p3) -- line: 58
	-- upvalues: ImageLabel (ref)
	ImageLabel.Position = UDim2.fromOffset(p3.x, p3.y)
end
local function getOrCreateVirtualCursorContainer() -- line: 62
	-- upvalues: ScreenGui (ref), getFFlagVirtualCursorDisplayOrder (copy), ImageLabel (ref), t3 (copy), Properties (copy), CoreGui (copy), u13 (ref), TweenService (copy), u14 (ref)
	if ScreenGui == nil then
		ScreenGui = Instance.new("ScreenGui")
		ScreenGui.Enabled = false
		ScreenGui.IgnoreGuiInset = true
		ScreenGui.DisplayOrder = not getFFlagVirtualCursorDisplayOrder() and 100 or 1e999

		if getFFlagVirtualCursorDisplayOrder() then
			ScreenGui.OnTopOfCoreBlur = true
		end

		ScreenGui.Name = "VirtualCursorGui"
		ImageLabel = Instance.new("ImageLabel")
		ImageLabel.Active = false
		ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)

		local v29 = ImageLabel
		local v30 = t3.Default * Properties.CursorRadius

		v29.Size = UDim2.fromOffset(v30, v30)
		ImageLabel.Image = "rbxasset://textures/ui/VirtualCursor/cursorDefault.png"
		ImageLabel.Visible = false
		ImageLabel.BackgroundTransparency = 1
		ImageLabel.Transparency = 1
		ImageLabel.Parent = ScreenGui
		ScreenGui.Parent = CoreGui

		local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0)
		local v32 = TweenService
		local v33 = ImageLabel
		local t4 = {}
		local v35 = t3.Activated * Properties.CursorRadius

		t4.Size = UDim2.fromOffset(v35, v35)
		u13 = v32:Create(v33, tweenInfo, t4)

		local v36 = TweenService
		local v37 = ImageLabel
		local t5 = {}
		local v39 = t3.Default * Properties.CursorRadius

		t5.Size = UDim2.fromOffset(v39, v39)
		u14 = v36:Create(v37, tweenInfo, t5)
	end

	return ScreenGui
end
local function tweenCursorOpacity(p4) -- line: 95
	-- upvalues: u17 (ref), tween2 (ref), TweenService (copy), ImageLabel (ref), getOrCreateVirtualCursorContainer (copy)
	if u17 then
		u17:Disconnect()
		u17 = nil
	end

	local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0)

	tween2 = TweenService:Create(ImageLabel, tweenInfo, {
		ImageTransparency = not p4 and 1 or 0
	})
	u17 = tween2.Completed:Connect(function() -- line: 104
		-- upvalues: ImageLabel (ref), p4 (copy), getOrCreateVirtualCursorContainer (copy)
		ImageLabel.Visible = p4
		getOrCreateVirtualCursorContainer().Enabled = p4
	end)
	tween2:Play()
end
local function tweenCursorPosition(p5) -- line: 112
	-- upvalues: tween (ref), TweenService (copy), ImageLabel (ref)
	local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0)

	tween = TweenService:Create(ImageLabel, tweenInfo, {
		Position = UDim2.fromOffset(p5.x, p5.y)
	})
	tween:Play()
end

function t1.GetCursorSize(_, p7) -- line: 119
	-- upvalues: getCursorSize (copy)
	return getCursorSize(p7)
end
function t1.PlayCursorTweenActivate(_) -- line: 123
	-- upvalues: u13 (ref)
	u13:Play()
end
function t1.PlayCursorTweenDefault(_) -- line: 127
	-- upvalues: u14 (ref)
	u14:Play()
end
function t1.SetCursorHighlight(_, p11) -- line: 131
	-- upvalues: ImageLabel (ref), t2 (copy)
	if p11 then
		ImageLabel.Image = t2.Hover

		return
	end

	ImageLabel.Image = t2.Default
end
function t1.SetCursorPosition(_, p13) -- line: 135
	-- upvalues: ImageLabel (ref)
	ImageLabel.Position = UDim2.fromOffset(p13.x, p13.y)
end
function t1.TweenCursorPosition(_, p15) -- line: 139
	-- upvalues: tweenCursorPosition (copy)
	tweenCursorPosition(p15)
end
function t1.TweenCursorOpacity(_, p17) -- line: 143
	-- upvalues: tweenCursorOpacity (copy)
	tweenCursorOpacity(p17)
end
function t1.SetArrow(_, p19, p20) -- line: 147
	-- upvalues: ImageLabel (ref)
	if p19 == -1 and p20 == 0 then
		ImageLabel.Rotation = 90
	elseif p20 == 0 then
		ImageLabel.Rotation = 270
	end

	if p19 == 0 and p20 == 1 then
		ImageLabel.Rotation = 0
	elseif p19 == 0 then
		ImageLabel.Rotation = 180
	end

	ImageLabel.Image = "rbxasset://textures/ui/VirtualCursor/cursorArrow.png"
end
function t1.EnableUI(_, p22) -- line: 163
	-- upvalues: VRService (copy), getOrCreateVirtualCursorContainer (copy), ImageLabel (ref), t3 (copy), Properties (copy), t1 (copy)
	local v61 = not VRService.VREnabled

	getOrCreateVirtualCursorContainer().Enabled = v61

	local v62 = ImageLabel
	local v63 = t3.Default * Properties.CursorRadius

	v62.Size = UDim2.fromOffset(v63, v63)
	ImageLabel.Position = UDim2.fromOffset(p22.x, p22.y)
	ImageLabel.Visible = v61
	t1:TweenCursorOpacity(true)
end
function t1.DisableUI(_) -- line: 174
	-- upvalues: ImageLabel (ref), t2 (copy), t1 (copy)
	ImageLabel.Image = t2.Default
	t1:TweenCursorOpacity(false)
end

return t1
