local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local Enabled = require(CorePackages.Workspace.Packages.Chrome).Enabled
local CapturesInExperience = require(CorePackages.Workspace.Packages.CapturesInExperience)
local v6 = CapturesInExperience.App.createApp()
local ScreenGui = Instance.new("ScreenGui")

ScreenGui.DisplayOrder = CapturesInExperience.Constants.CarouselDisplayOrder
ScreenGui.Name = "ScreenshotsCarousel"
ScreenGui.ResetOnSpawn = false
ScreenGui.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

local ScreenGui2 = Instance.new("ScreenGui")

ScreenGui2.DisplayOrder = CapturesInExperience.Constants.CarouselDisplayOrder
ScreenGui2.Name = "CaptureManager"
ScreenGui2.ResetOnSpawn = false
ScreenGui2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui2.Parent = CoreGui

local ScreenGui3 = Instance.new("ScreenGui")

ScreenGui3.DisplayOrder = CapturesInExperience.Constants.OverlayDisplayOrder
ScreenGui3.Name = CapturesInExperience.Constants.OverlayName
ScreenGui3.ResetOnSpawn = false
ScreenGui3.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui3.Parent = CoreGui

local ScreenGui4 = Instance.new("ScreenGui")

ScreenGui4.DisplayOrder = CapturesInExperience.Constants.CreationFlowDisplayOrder
ScreenGui4.Name = "MomentsCreationFlow"
ScreenGui4.ResetOnSpawn = false
ScreenGui4.ScreenInsets = Enum.ScreenInsets.None
ScreenGui4.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui4.Parent = CoreGui
v6.mountCaptureManager(ScreenGui2)
v6.mountCarousel(ScreenGui)
v6.mountCoreUI(RobloxGui, Enabled())
v6.mountCaptureOverlay(ScreenGui3)
v6.mountMomentsCreationFlow(ScreenGui4)

return v6
