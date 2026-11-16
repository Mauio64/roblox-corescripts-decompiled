local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local VRService = game:GetService("VRService")

local Properties = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualCursor/VirtualCursor/Properties")

local class = {}

local v5 = {
	Default = "rbxasset://textures/ui/VirtualCursor/cursorDefault.png",
	Hover = "rbxasset://textures/ui/VirtualCursor/cursorHover.png",
	Pressed = "rbxasset://textures/ui/VirtualCursor/cursorPressed.png",
	Arrow = "rbxasset://textures/ui/VirtualCursor/cursorArrow.png"
}

local virtualCursorGui = nil
local imageLabel = nil

local v6 = nil
local v7 = nil

local v8 = nil

local v9 = nil
local completedConnection = nil

local v10 = { Default = 2, Activated = 1.7 }

local function getCursorSize(p2)
	local v11 = v10[p2] * Properties.CursorRadius
	return UDim2.fromOffset(v11, v11)
end

local function setCursorHighlight(p2)
	if p2 then
		imageLabel.Image = "rbxasset://textures/ui/VirtualCursor/cursorHover.png"
	else
		imageLabel.Image = "rbxasset://textures/ui/VirtualCursor/cursorDefault.png"
	end
end

local function setCursorPosition(p2)
	imageLabel.Position = UDim2.fromOffset(p2.x, p2.y)
end

local function getOrCreateVirtualCursorContainer()
	if virtualCursorGui ~= nil then
		return virtualCursorGui
	end

	virtualCursorGui = Instance.new("ScreenGui")
	virtualCursorGui.Enabled = false
	virtualCursorGui.IgnoreGuiInset = true
	virtualCursorGui.DisplayOrder = 1e999
	virtualCursorGui.OnTopOfCoreBlur = true
	virtualCursorGui.Name = "VirtualCursorGui"

	imageLabel = Instance.new("ImageLabel")
	imageLabel.Active = false
	imageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	local v11 = imageLabel
	local v12 = v10.Default * Properties.CursorRadius
	v11.Size = UDim2.fromOffset(v12, v12)
	imageLabel.Image = "rbxasset://textures/ui/VirtualCursor/cursorDefault.png"
	imageLabel.Visible = false
	imageLabel.BackgroundTransparency = 1
	imageLabel.Transparency = 1

	imageLabel.Parent = virtualCursorGui
	virtualCursorGui.Parent = CoreGui

	local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0)

	local v14 = imageLabel
	local v16 = v10.Activated * Properties.CursorRadius
	v6 = TweenService:Create(v14, tweenInfo, { Size = UDim2.fromOffset(v16, v16) })

	local v18 = imageLabel
	local v20 = v10.Default * Properties.CursorRadius
	v7 = TweenService:Create(v18, tweenInfo, { Size = UDim2.fromOffset(v20, v20) })

	return virtualCursorGui
end

local function tweenCursorOpacity(p2)
	if completedConnection then
		completedConnection:Disconnect()
		completedConnection = nil
	end

	local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0)
	v9 = TweenService:Create(imageLabel, tweenInfo, {
		ImageTransparency = p2 and 0 or 1
	})
	completedConnection = v9.Completed:Connect(function()
		imageLabel.Visible = p2
		local virtualCursorContainer = getOrCreateVirtualCursorContainer()
		virtualCursorContainer.Enabled = p2
	end)

	v9:Play()
end

local function tweenCursorPosition(p2)
	local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0)
	v8 = TweenService:Create(imageLabel, tweenInfo, {
		Position = UDim2.fromOffset(p2.x, p2.y)
	})
	v8:Play()
end

function class.GetCursorSize(p2, p3)
	return getCursorSize(p3)
end

function class:PlayCursorTweenActivate()
	v6:Play()
end

function class:PlayCursorTweenDefault()
	v7:Play()
end

function class:SetCursorHighlight(p3)
	if p3 then
		imageLabel.Image = v5.Hover
	else
		imageLabel.Image = v5.Default
	end
end

function class:SetCursorPosition(p3)
	imageLabel.Position = UDim2.fromOffset(p3.x, p3.y)
end

function class:TweenCursorPosition(p3)
	tweenCursorPosition(p3)
end

function class:TweenCursorOpacity(p3)
	tweenCursorOpacity(p3)
end

function class:SetArrow(p3, p4)
	if p3 == -1 and p4 == 0 then
		imageLabel.Rotation = 90
	elseif p4 == 0 then
		imageLabel.Rotation = 270
	end

	if p3 == 0 and p4 == 1 then
		imageLabel.Rotation = 0
	elseif p3 == 0 then
		imageLabel.Rotation = 180
	end

	imageLabel.Image = "rbxasset://textures/ui/VirtualCursor/cursorArrow.png"
end

function class:EnableUI(p3)
	local v11 = not VRService.VREnabled

	local virtualCursorContainer = getOrCreateVirtualCursorContainer()
	virtualCursorContainer.Enabled = v11
	local v12 = imageLabel
	local v13 = v10.Default * Properties.CursorRadius
	v12.Size = UDim2.fromOffset(v13, v13)
	imageLabel.Position = UDim2.fromOffset(p3.x, p3.y)

	imageLabel.Visible = v11

	class:TweenCursorOpacity(true)
end

function class:DisableUI()
	imageLabel.Image = v5.Default

	class:TweenCursorOpacity(false)
end

return class
