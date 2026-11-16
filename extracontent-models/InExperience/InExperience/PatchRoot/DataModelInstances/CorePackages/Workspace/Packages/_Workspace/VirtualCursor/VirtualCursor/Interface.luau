local VirtualCursor = script:FindFirstAncestor("VirtualCursor")
local parent = VirtualCursor.Parent

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local VRService = game:GetService("VRService")
local RobloxGui = CoreGui.RobloxGui
local Properties = require(VirtualCursor.Properties)

local Interface = {}

local v = {
	Default = "rbxasset://textures/ui/VirtualCursor/cursorDefault.png",
	Hover = "rbxasset://textures/ui/VirtualCursor/cursorHover.png",
	Pressed = "rbxasset://textures/ui/VirtualCursor/cursorPressed.png",
	Arrow = "rbxasset://textures/ui/VirtualCursor/cursorArrow.png"
}

local virtualCursorGui = nil
local imageLabel = nil

local v2 = nil
local v3 = nil

local v4 = nil

local v5 = nil
local completedConnection = nil

local v6 = { Default = 2, Activated = 1.7 }

local function getCursorSize(p) -- 4 equivalent calls inferred from this helper
	local v7 = v6[p] * Properties.CursorRadius
	return UDim2.fromOffset(v7, v7)
end

local function setCursorHighlight(p)
	if p then
		imageLabel.Image = "rbxasset://textures/ui/VirtualCursor/cursorHover.png"
	else
		imageLabel.Image = "rbxasset://textures/ui/VirtualCursor/cursorDefault.png"
	end
end

local function setCursorPosition(p) -- 2 equivalent calls inferred from this helper
	imageLabel.Position = UDim2.fromOffset(p.x, p.y)
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
	imageLabel.Size = getCursorSize("Default") -- inferred equivalent call
	imageLabel.Image = "rbxasset://textures/ui/VirtualCursor/cursorDefault.png"
	imageLabel.Visible = false
	imageLabel.BackgroundTransparency = 1
	imageLabel.Transparency = 1

	imageLabel.Parent = virtualCursorGui
	virtualCursorGui.Parent = CoreGui

	local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0)
	v2 = TweenService:Create(imageLabel, tweenInfo, { Size = getCursorSize("Activated") }) -- inferred equivalent call
	v3 = TweenService:Create(imageLabel, tweenInfo, { Size = getCursorSize("Default") }) -- inferred equivalent call

	return virtualCursorGui
end

local function tweenCursorOpacity(p)
	if completedConnection then
		completedConnection:Disconnect()
		completedConnection = nil
	end

	local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0)
	v5 = TweenService:Create(imageLabel, tweenInfo, {
		ImageTransparency = p and 0 or 1
	})
	completedConnection = v5.Completed:Connect(function()
		imageLabel.Visible = p
		local virtualCursorContainer = getOrCreateVirtualCursorContainer()
		virtualCursorContainer.Enabled = p
	end)

	v5:Play()
end

local function tweenCursorPosition(p)
	local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0)
	v4 = TweenService:Create(imageLabel, tweenInfo, { Position = UDim2.fromOffset(p.x, p.y) })
	v4:Play()
end

function Interface.GetCursorSize(_, p)
	return getCursorSize(p)
end

function Interface.PlayCursorTweenActivate(_)
	v2:Play()
end

function Interface.PlayCursorTweenDefault(_)
	v3:Play()
end

function Interface.SetCursorHighlight(_, p)
	if p then
		imageLabel.Image = v.Hover
	else
		imageLabel.Image = v.Default
	end
end

function Interface.SetCursorPosition(_, p)
	setCursorPosition(p) -- inferred equivalent call
end

function Interface.TweenCursorPosition(_, p)
	tweenCursorPosition(p)
end

function Interface:TweenCursorOpacity(p)
	tweenCursorOpacity(p)
end

function Interface.SetArrow(_, p, p2)
	if p == -1 and p2 == 0 then
		imageLabel.Rotation = 90
	elseif p2 == 0 then
		imageLabel.Rotation = 270
	end

	if p == 0 and p2 == 1 then
		imageLabel.Rotation = 0
	elseif p == 0 then
		imageLabel.Rotation = 180
	end

	imageLabel.Image = "rbxasset://textures/ui/VirtualCursor/cursorArrow.png"
end

function Interface.EnableUI(_, p)
	local v7 = not VRService.VREnabled

	local virtualCursorContainer = getOrCreateVirtualCursorContainer()
	virtualCursorContainer.Enabled = v7
	imageLabel.Size = getCursorSize("Default") -- inferred equivalent call
	setCursorPosition(p) -- inferred equivalent call
	imageLabel.Visible = v7

	Interface:TweenCursorOpacity(true)
end

function Interface.DisableUI(_)
	imageLabel.Image = v.Default

	Interface:TweenCursorOpacity(false)
end

return Interface
