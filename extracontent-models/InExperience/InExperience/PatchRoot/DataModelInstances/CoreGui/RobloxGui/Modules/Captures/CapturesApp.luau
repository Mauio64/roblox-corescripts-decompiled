local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")

local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local Chrome = require(CorePackages.Workspace.Packages.Chrome)
local Enabled = Chrome.Enabled

local CapturesInExperience = require(CorePackages.Workspace.Packages.CapturesInExperience)

local app = CapturesInExperience.App.createApp()

local screenshotsCarousel = Instance.new("ScreenGui")
screenshotsCarousel.DisplayOrder = CapturesInExperience.Constants.CarouselDisplayOrder
screenshotsCarousel.Name = "ScreenshotsCarousel"
screenshotsCarousel.ResetOnSpawn = false
screenshotsCarousel.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
screenshotsCarousel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenshotsCarousel.Parent = CoreGui

local captureManager = Instance.new("ScreenGui")
captureManager.DisplayOrder = CapturesInExperience.Constants.CarouselDisplayOrder
captureManager.Name = "CaptureManager"
captureManager.ResetOnSpawn = false
captureManager.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
captureManager.Parent = CoreGui

local screenGui = Instance.new("ScreenGui")
screenGui.DisplayOrder = CapturesInExperience.Constants.OverlayDisplayOrder
screenGui.Name = CapturesInExperience.Constants.OverlayName
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = CoreGui

local momentsCreationFlow = Instance.new("ScreenGui")
momentsCreationFlow.DisplayOrder = CapturesInExperience.Constants.CreationFlowDisplayOrder
momentsCreationFlow.Name = "MomentsCreationFlow"
momentsCreationFlow.ResetOnSpawn = false
momentsCreationFlow.ScreenInsets = Enum.ScreenInsets.None
momentsCreationFlow.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
momentsCreationFlow.Parent = CoreGui

app.mountCaptureManager(captureManager)
app.mountCarousel(screenshotsCarousel)
app.mountCoreUI(RobloxGui, Enabled())
app.mountCaptureOverlay(screenGui)
app.mountMomentsCreationFlow(momentsCreationFlow)

return app
