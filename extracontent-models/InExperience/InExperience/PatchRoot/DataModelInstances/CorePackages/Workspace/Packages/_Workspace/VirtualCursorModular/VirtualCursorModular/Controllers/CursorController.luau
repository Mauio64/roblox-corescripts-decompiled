local VirtualCursorModular = script:FindFirstAncestor("VirtualCursorModular")
local parent = VirtualCursorModular.Parent

local TweenService = game:GetService("TweenService")

local VRService = game:GetService("VRService")
local CoreGui = game:GetService("CoreGui")
local Properties = require(VirtualCursorModular.Properties)

local CursorController = {}
CursorController.__index = CursorController

local _ = {
	Default = "rbxasset://textures/ui/VirtualCursor/cursorDefault.png",
	Hover = "rbxasset://textures/ui/VirtualCursor/cursorHover.png",
	Pressed = "rbxasset://textures/ui/VirtualCursor/cursorPressed.png",
	Arrow = "rbxasset://textures/ui/VirtualCursor/cursorArrow.png"
}

local v = { Default = 2, Hover = 2, Pressed = 1.7, Arrow = 2 }

function CursorController.new()
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
	}, CursorController))
end

function CursorController:Destroy()
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

function CursorController:SetCursorSize(p: string)
	local v2 = v[p] * Properties.CursorRadius
	self._cursor.Size = UDim2.fromOffset(v2, v2)
end

function CursorController:PlayTweenActivate()
	self._activeSelectionTweenIn:Play()
end

function CursorController:PlayTweenDefault()
	self._activeSelectionTweenOut:Play()
end

function CursorController:SetHighlight(flag: boolean)
	if flag then
		self._cursor.Image = "rbxasset://textures/ui/VirtualCursor/cursorHover.png"
	else
		self._cursor.Image = "rbxasset://textures/ui/VirtualCursor/cursorDefault.png"
	end
end

function CursorController:SetPosition(vector2: Vector2)
	self._cursor.Position = UDim2.fromOffset(vector2.X, vector2.Y)
end

function CursorController:GetCursorScreenGuiOffset()
	return self._cursorContainer.AbsolutePosition
end

function CursorController:TweenPosition(vector2: Vector2)
	local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0)
	self._activePreviewPositionTween = TweenService:Create(self._cursor, tweenInfo, {
		Position = UDim2.fromOffset(vector2.X, vector2.Y)
	})
	self._activePreviewPositionTween:Play()
end

function CursorController:TweenOpacity(flag: boolean)
	local activeOpacityTweenCompletedConnection = self._activeOpacityTweenCompletedConnection

	if activeOpacityTweenCompletedConnection then
		activeOpacityTweenCompletedConnection:Disconnect()
		self._activeOpacityTweenCompletedConnection = nil
	end

	local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0)
	local tween = TweenService:Create(self._cursor, tweenInfo, {
		ImageTransparency = flag and 0 or 1
	})

	self._activeOpacityTweenCompletedConnection = tween.Completed:Connect(function()
		self._cursor.Visible = flag
		self._cursorContainer.Enabled = flag
	end)

	tween:Play()
end

function CursorController:SetArrow(p: number, p2: number)
	if p == -1 and p2 == 0 then
		self._cursor.Rotation = 90
	elseif p2 == 0 then
		self._cursor.Rotation = 270
	end

	if p == 0 and p2 == 1 then
		self._cursor.Rotation = 0
	elseif p == 0 then
		self._cursor.Rotation = 180
	end

	self._cursor.Image = "rbxasset://textures/ui/VirtualCursor/cursorArrow.png"
end

function CursorController:GetEnabled()
	return self._enabled
end

function CursorController:Enable(vector2: Vector2)
	if VRService.VREnabled then
		return
	end

	local v2 = not VRService.VREnabled
	self._cursorContainer.Enabled = v2
	self:SetCursorSize("Default")
	self:SetPosition(vector2)
	self._cursor.Visible = v2

	self:TweenOpacity(true)

	self._enabled = true
end

function CursorController:Disable()
	self:SetHighlight(false)

	self:TweenOpacity(false)

	self._enabled = false
end

return CursorController
