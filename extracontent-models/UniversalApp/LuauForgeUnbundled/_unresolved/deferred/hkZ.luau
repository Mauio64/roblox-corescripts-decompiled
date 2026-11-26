local CoreGui = game:GetService("CoreGui")

local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

local create = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Create

local module = require("@luauforge/deferred/hkY")
local module2 = require("@luauforge/deferred/gHJ")

local v5 = {}

v5.Mode = { None = "None", Playing = "Playing", Recording = "Recording" }

function v5:LuaState()
	local frameRateManager = Stats:FindFirstChild("FrameRateManager")

	if frameRateManager then
		return {
			AverageFPS = frameRateManager:FindFirstChild("AverageFPS"):GetValue(),
			FrameTimeVariance = frameRateManager:FindFirstChild("FrameTimeVariance"):GetValue()
		}
	end

	warn("FrameRateManager not present in Stats")
	return { AverageFPS = 0, FrameTimeVariance = 0 }
end

function v5:ShowResults(p3)
	local luaState = v5:LuaState()

	local instance = create("ScreenGui")({
		Name = "TestResults",
		DisplayOrder = 5,
		create("Frame")({
			BackgroundTransparency = 0,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = module2.Color.WHITE,
			BorderSizePixel = 0,
			create("UIListLayout")({ SortOrder = "LayoutOrder" }),
			create("TextLabel")({
				Name = "Title",
				BackgroundTransparency = 1,
				TextSize = module2.Font.FONT_SIZE_14,
				Size = UDim2.new(1, 0, 0, 100),
				Text = "Test: " .. module.General.PerformanceTestFilename
			}),
			create("TextLabel")({
				Name = "AverageFPS",
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1,
				TextSize = module2.Font.FONT_SIZE_14,
				Size = UDim2.new(1, 0, 0, 50),
				Text = "AverageFPS:"
			}),
			create("TextLabel")({
				Name = "ExpectedAverageFPS",
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1,
				TextSize = module2.Font.FONT_SIZE_14,
				Size = UDim2.new(1, 0, 0, 30),
				Text = string.format("Expected: %g", p3.AverageFPS)
			}),
			create("TextLabel")({
				Name = "ActualAverageFPS",
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1,
				TextSize = module2.Font.FONT_SIZE_14,
				Size = UDim2.new(1, 0, 0, 30),
				Text = string.format("Actual  : %g", luaState.AverageFPS)
			}),
			create("TextLabel")({
				Name = "ActualAverageFPS",
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1,
				TextSize = module2.Font.FONT_SIZE_14,
				Size = UDim2.new(1, 0, 0, 30),
				Text = string.format("Delta   : %g", luaState.AverageFPS - p3.AverageFPS)
			}),
			create("TextLabel")({
				Name = "FrameTimeVariance",
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1,
				TextSize = module2.Font.FONT_SIZE_14,
				Size = UDim2.new(1, 0, 0, 50),
				Text = "FrameTimeVariance:"
			}),
			create("TextLabel")({
				Name = "ExpectedAFrameTimeVariance",
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1,
				TextSize = module2.Font.FONT_SIZE_14,
				Size = UDim2.new(1, 0, 0, 30),
				Text = string.format("Expected: %g", p3.FrameTimeVariance)
			}),
			create("TextLabel")({
				Name = "ActualFrameTimeVariance",
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1,
				TextSize = module2.Font.FONT_SIZE_14,
				Size = UDim2.new(1, 0, 0, 30),
				Text = string.format("Actual  : %g", luaState.FrameTimeVariance)
			}),
			create("TextLabel")({
				Name = "ActualFrameTimeVariance",
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1,
				TextSize = module2.Font.FONT_SIZE_14,
				Size = UDim2.new(1, 0, 0, 30),
				Text = string.format("Delta   : %g", luaState.FrameTimeVariance - p3.FrameTimeVariance)
			})
		})
	})

	instance.Parent = CoreGui
end

function v5:Record()
	RunService:setThrottleFramerateEnabled(false)
	VirtualInputManager.RecordingCompleted:Connect(function(p2)
		print("*** Finished Recording Test ***")
		VirtualInputManager.AdditionalLuaState = HttpService:JSONEncode(self:LuaState())
		print("~~~           DUMP          ~~~")
		VirtualInputManager:Dump()
	end)
	VirtualInputManager:StartRecording()
end

function v5:Play(p2)
	print("PerformanceTesting:Play")
	RunService:setThrottleFramerateEnabled(false)
	VirtualInputManager.PlaybackCompleted:Connect(function()
		print("*** Finished Playing Test ***")
		self:ShowResults((HttpService:JSONDecode(VirtualInputManager.AdditionalLuaState)))
	end)
	VirtualInputManager:StartPlaying(p2)
end

function v5:Stop()
	if module.General.PerformanceTestingMode == Enum.VirtualInputMode.Recording then
		VirtualInputManager:StopRecording()
	end
end

function v5:Initialize(appState)
	if module.General.PerformanceTestingMode == Enum.VirtualInputMode.None then
		return
	end

	self.appState = appState

	if module.General.PerformanceTestingMode == Enum.VirtualInputMode.Recording then
		self:Record()
	elseif module.General.PerformanceTestingMode == Enum.VirtualInputMode.Playing then
		self:Play(module.General.PerformanceTestFilename)
	end
end

return v5
