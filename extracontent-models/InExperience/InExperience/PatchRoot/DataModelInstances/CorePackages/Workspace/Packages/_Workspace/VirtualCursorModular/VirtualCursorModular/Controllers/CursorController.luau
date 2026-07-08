local VirtualCursorModular = script:FindFirstAncestor("VirtualCursorModular")
local VirtualCursorModularParent = VirtualCursorModular.Parent
local TweenService = game:GetService("TweenService")
local VRService = game:GetService("VRService")
local CoreGui = game:GetService("CoreGui")
local Properties = require(VirtualCursorModular.Properties)
local getFFlagVirtualCursorDisplayOrder = require(VirtualCursorModularParent.SharedFlags).getFFlagVirtualCursorDisplayOrder
local EngineFeature = game:GetEngineFeature("DeprecateOldGuiObjectProperties")
local t1 = {}

t1.__index = t1

local _ = {
	Default = "rbxasset://textures/ui/VirtualCursor/cursorDefault.png",
	Hover = "rbxasset://textures/ui/VirtualCursor/cursorHover.png",
	Pressed = "rbxasset://textures/ui/VirtualCursor/cursorPressed.png",
	Arrow = "rbxasset://textures/ui/VirtualCursor/cursorArrow.png"
}
local t2 = {
	Default = 2,
	Hover = 2,
	Pressed = 1.7,
	Arrow = 2
}

function t1.new() -- line: 46
	-- upvalues: getFFlagVirtualCursorDisplayOrder (copy), Properties (copy), EngineFeature (copy), CoreGui (copy), TweenService (copy), t1 (copy)
	local ScreenGui = Instance.new("ScreenGui")

	ScreenGui.Enabled = false
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.DisplayOrder = not getFFlagVirtualCursorDisplayOrder() and 100 or 1e999

	if getFFlagVirtualCursorDisplayOrder() then
		ScreenGui.OnTopOfCoreBlur = true
	end

	ScreenGui.Name = "CursorContainer"

	local ImageLabel = Instance.new("ImageLabel")

	ImageLabel.Active = false
	ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	ImageLabel.Size = UDim2.fromOffset(2 * Properties.CursorRadius, 2 * Properties.CursorRadius)
	ImageLabel.Image = "rbxasset://textures/ui/VirtualCursor/cursorDefault.png"
	ImageLabel.Visible = false
	ImageLabel.BackgroundTransparency = 1

	if not EngineFeature then
		ImageLabel.Transparency = 1
	end

	ImageLabel.Parent = ScreenGui
	ScreenGui.Parent = CoreGui

	local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0)
	local tween = TweenService:Create(ImageLabel, tweenInfo, {
		Size = UDim2.fromOffset(1.7 * Properties.CursorRadius, 1.7 * Properties.CursorRadius)
	})
	local tween2 = TweenService:Create(ImageLabel, tweenInfo, {
		Size = UDim2.fromOffset(2 * Properties.CursorRadius, 2 * Properties.CursorRadius)
	})

	return (setmetatable({
		_activePreviewPositionTween = nil,
		_activeOpacityTweenCompletedConnection = nil,
		_enabled = false,
		_cursor = ImageLabel,
		_cursorContainer = ScreenGui,
		_activeSelectionTweenIn = tween,
		_activeSelectionTweenOut = tween2
	}, t1))
end
function t1.Destroy(p1) -- line: 100
	p1._cursorContainer:Destroy()
	p1._activeSelectionTweenIn:Destroy()
	p1._activeSelectionTweenOut:Destroy()

	if p1._activePreviewPositionTween then
		p1._activePreviewPositionTween:Destroy()
	end

	local _activeOpacityTweenCompletedConnection = p1._activeOpacityTweenCompletedConnection

	if _activeOpacityTweenCompletedConnection then
		_activeOpacityTweenCompletedConnection:Disconnect()
		p1._activeOpacityTweenCompletedConnection = nil
	end
end
function t1.SetCursorSize(t3: {[any]: any}, s1: string) -- line: 117
	-- upvalues: t2 (copy), Properties (copy)
	local v21 = t2[s1] * Properties.CursorRadius

	t3._cursor.Size = UDim2.fromOffset(v21, v21)
end
function t1.PlayTweenActivate(p2) -- line: 122
	p2._activeSelectionTweenIn:Play()
end
function t1.PlayTweenDefault(p3) -- line: 126
	p3._activeSelectionTweenOut:Play()
end
function t1.SetHighlight(t4: {[any]: any}, b1: boolean) -- line: 130
	if b1 then
		t4._cursor.Image = "rbxasset://textures/ui/VirtualCursor/cursorHover.png"

		return
	end

	t4._cursor.Image = "rbxasset://textures/ui/VirtualCursor/cursorDefault.png"
end
function t1.SetPosition(t5: {[any]: any}, vector2: Vector2) -- line: 138
	t5._cursor.Position = UDim2.fromOffset(vector2.X, vector2.Y)
end
function t1.GetCursorScreenGuiOffset(p4) -- line: 142
	return p4._cursorContainer.AbsolutePosition
end
function t1.TweenPosition(t6: {[any]: any}, vector2: Vector2) -- line: 146
	-- upvalues: TweenService (copy)
	local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0)

	t6._activePreviewPositionTween = TweenService:Create(t6._cursor, tweenInfo, {
		Position = UDim2.fromOffset(vector2.X, vector2.Y)
	})
	t6._activePreviewPositionTween:Play()
end
function t1.TweenOpacity(t7: {[any]: any}, b2: boolean) -- line: 153
	-- upvalues: TweenService (copy)
	local _activeOpacityTweenCompletedConnection = t7._activeOpacityTweenCompletedConnection

	if _activeOpacityTweenCompletedConnection then
		_activeOpacityTweenCompletedConnection:Disconnect()
		t7._activeOpacityTweenCompletedConnection = nil
	end

	local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0)
	local tween = TweenService:Create(t7._cursor, tweenInfo, {
		ImageTransparency = not b2 and 1 or 0
	})

	t7._activeOpacityTweenCompletedConnection = tween.Completed:Connect(function() -- line: 166
		-- upvalues: t7 (copy), b2 (copy)
		t7._cursor.Visible = b2
		t7._cursorContainer.Enabled = b2
	end)
	tween:Play()
end
function t1.SetArrow(t8: {[any]: any}, n1: number, n2: number) -- line: 174
	if n1 == -1 and n2 == 0 then
		t8._cursor.Rotation = 90
	elseif n2 == 0 then
		t8._cursor.Rotation = 270
	end

	if n1 == 0 and n2 == 1 then
		t8._cursor.Rotation = 0
	elseif n1 == 0 then
		t8._cursor.Rotation = 180
	end

	t8._cursor.Image = "rbxasset://textures/ui/VirtualCursor/cursorArrow.png"
end
function t1.GetEnabled(p5) -- line: 190
	return p5._enabled
end
function t1.Enable(t9: {[any]: any}, vector2: Vector2) -- line: 194
	-- upvalues: VRService (copy)
	if VRService.VREnabled then
		return
	end

	local v43 = not VRService.VREnabled

	t9._cursorContainer.Enabled = v43
	t9:SetCursorSize("Default")
	t9:SetPosition(vector2)
	t9._cursor.Visible = v43
	t9:TweenOpacity(true)
	t9._enabled = true
end
function t1.Disable(p6) -- line: 210
	p6:SetHighlight(false)
	p6:TweenOpacity(false)
	p6._enabled = false
end

return t1
