local TweenService = game:GetService("TweenService")

local VRService = game:GetService("VRService")
local CoreGui = game:GetService("CoreGui")
local Properties = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualCursorModular/VirtualCursorModular/Properties")

local class = {}
class.__index = class

local v5 = {
	Default = "rbxasset://textures/ui/VirtualCursor/cursorDefault.png",
	Hover = "rbxasset://textures/ui/VirtualCursor/cursorHover.png",
	Pressed = "rbxasset://textures/ui/VirtualCursor/cursorPressed.png",
	Arrow = "rbxasset://textures/ui/VirtualCursor/cursorArrow.png"
}

local v6 = { Default = 2, Hover = 2, Pressed = 1.7, Arrow = 2 }

function class.new()
	local cursorContainer = Instance.new("ScreenGui")
	cursorContainer.Enabled = false
	cursorContainer.IgnoreGuiInset = true
	cursorContainer.DisplayOrder = 1e999
	cursorContainer.OnTopOfCoreBlur = true
	cursorContainer.Name = "CursorContainer"

	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Active = false
	imageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	imageLabel.Size = UDim2.fromOffset(2 * Properties.CursorRadius, 2 * Properties.CursorRadius)

	imageLabel.Image = "rbxasset://textures/ui/VirtualCursor/cursorDefault.png"
	imageLabel.Visible = false
	imageLabel.BackgroundTransparency = 1

	imageLabel.Parent = cursorContainer
	cursorContainer.Parent = CoreGui

	local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0)
	return (setmetatable({
		_cursor = imageLabel,
		_cursorContainer = cursorContainer,
		_activeSelectionTweenIn = TweenService:Create(imageLabel, tweenInfo, {
			Size = UDim2.fromOffset(1.7 * Properties.CursorRadius, 1.7 * Properties.CursorRadius)
		}),
		_activeSelectionTweenOut = TweenService:Create(imageLabel, tweenInfo, {
			Size = UDim2.fromOffset(2 * Properties.CursorRadius, 2 * Properties.CursorRadius)
		}),
		_activePreviewPositionTween = nil,
		_activeOpacityTweenCompletedConnection = nil,
		_enabled = false
	}, class))
end

function class:Destroy()
	self._cursorContainer:Destroy()

	self._activeSelectionTweenIn:Destroy()
	self._activeSelectionTweenOut:Destroy()

	if self._activePreviewPositionTween then
		self._activePreviewPositionTween:Destroy()
	end

	local activeOpacityTweenCompletedConnection = self._activeOpacityTweenCompletedConnection

	if activeOpacityTweenCompletedConnection then
		activeOpacityTweenCompletedConnection:Disconnect()
		self._activeOpacityTweenCompletedConnection = nil
	end
end

function class:SetCursorSize(p3)
	local v7 = v6[p3] * Properties.CursorRadius
	self._cursor.Size = UDim2.fromOffset(v7, v7)
end

function class:PlayTweenActivate()
	self._activeSelectionTweenIn:Play()
end

function class:PlayTweenDefault()
	self._activeSelectionTweenOut:Play()
end

function class:SetHighlight(p3)
	if p3 then
		self._cursor.Image = "rbxasset://textures/ui/VirtualCursor/cursorHover.png"
	else
		self._cursor.Image = "rbxasset://textures/ui/VirtualCursor/cursorDefault.png"
	end
end

function class:SetPosition(p3)
	self._cursor.Position = UDim2.fromOffset(p3.X, p3.Y)
end

function class:GetCursorScreenGuiOffset()
	return self._cursorContainer.AbsolutePosition
end

function class:TweenPosition(p2)
	local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0)
	self._activePreviewPositionTween = TweenService:Create(self._cursor, tweenInfo, {
		Position = UDim2.fromOffset(p2.X, p2.Y)
	})
	self._activePreviewPositionTween:Play()
end

function class:TweenOpacity(p2)
	local activeOpacityTweenCompletedConnection = self._activeOpacityTweenCompletedConnection

	if activeOpacityTweenCompletedConnection then
		activeOpacityTweenCompletedConnection:Disconnect()
		self._activeOpacityTweenCompletedConnection = nil
	end

	local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0)
	local tween = TweenService:Create(self._cursor, tweenInfo, {
		ImageTransparency = p2 and 0 or 1
	})

	self._activeOpacityTweenCompletedConnection = tween.Completed:Connect(function()
		self._cursor.Visible = p2
		self._cursorContainer.Enabled = p2
	end)

	tween:Play()
end

function class:SetArrow(p3, p4)
	if p3 == -1 and p4 == 0 then
		self._cursor.Rotation = 90
	elseif p4 == 0 then
		self._cursor.Rotation = 270
	end

	if p3 == 0 and p4 == 1 then
		self._cursor.Rotation = 0
	elseif p3 == 0 then
		self._cursor.Rotation = 180
	end

	self._cursor.Image = "rbxasset://textures/ui/VirtualCursor/cursorArrow.png"
end

function class:GetEnabled()
	return self._enabled
end

function class:Enable(p2)
	if VRService.VREnabled then
		return
	end

	local v7 = not VRService.VREnabled
	self._cursorContainer.Enabled = v7
	self:SetCursorSize("Default")
	self:SetPosition(p2)
	self._cursor.Visible = v7

	self:TweenOpacity(true)

	self._enabled = true
end

function class:Disable()
	self:SetHighlight(false)

	self:TweenOpacity(false)

	self._enabled = false
end

return class
