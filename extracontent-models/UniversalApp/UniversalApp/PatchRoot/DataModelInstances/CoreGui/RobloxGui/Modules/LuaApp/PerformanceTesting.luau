local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local Create = require(CorePackages.Workspace.Packages.AppCommonLib).Create
local LuaApp = CoreGui.RobloxGui.Modules.LuaApp
local Config = require(LuaApp.Config)
local Constants = require(CorePackages.Workspace.Packages.AppChat.Constants)
local t1 = {
	Mode = {
		None = "None",
		Playing = "Playing",
		Recording = "Recording"
	},
	LuaState = function(_) -- line: 25
		-- upvalues: Stats (copy)
		local FrameRateManager = Stats:FindFirstChild("FrameRateManager")

		if not FrameRateManager then
			warn("FrameRateManager not present in Stats")

			return {
				AverageFPS = 0,
				FrameTimeVariance = 0
			}
		end

		return {
			AverageFPS = FrameRateManager:FindFirstChild("AverageFPS"):GetValue(),
			FrameTimeVariance = FrameRateManager:FindFirstChild("FrameTimeVariance"):GetValue()
		}
	end
}

function t1.ShowResults(_, p3) -- line: 40
	-- upvalues: t1 (copy), Create (copy), Constants (copy), Config (copy), CoreGui (copy)
	local v16 = t1:LuaState()

	Create("ScreenGui")({
		Name = "TestResults",
		DisplayOrder = 5,
		Create("Frame")({
			BackgroundTransparency = 0,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Constants.Color.WHITE,
			BorderSizePixel = 0,
			Create("UIListLayout")({
				SortOrder = "LayoutOrder"
			}),
			Create("TextLabel")({
				Name = "Title",
				BackgroundTransparency = 1,
				TextSize = Constants.Font.FONT_SIZE_14,
				Size = UDim2.new(1, 0, 0, 100),
				Text = "Test: " .. Config.General.PerformanceTestFilename
			}),
			Create("TextLabel")({
				Name = "AverageFPS",
				BackgroundTransparency = 1,
				Text = "AverageFPS:",
				TextXAlignment = Enum.TextXAlignment.Left,
				TextSize = Constants.Font.FONT_SIZE_14,
				Size = UDim2.new(1, 0, 0, 50)
			}),
			Create("TextLabel")({
				Name = "ExpectedAverageFPS",
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextSize = Constants.Font.FONT_SIZE_14,
				Size = UDim2.new(1, 0, 0, 30),
				Text = string.format("Expected: %g", p3.AverageFPS)
			}),
			Create("TextLabel")({
				Name = "ActualAverageFPS",
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextSize = Constants.Font.FONT_SIZE_14,
				Size = UDim2.new(1, 0, 0, 30),
				Text = string.format("Actual  : %g", v16.AverageFPS)
			}),
			Create("TextLabel")({
				Name = "ActualAverageFPS",
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextSize = Constants.Font.FONT_SIZE_14,
				Size = UDim2.new(1, 0, 0, 30),
				Text = string.format("Delta   : %g", v16.AverageFPS - p3.AverageFPS)
			}),
			Create("TextLabel")({
				Name = "FrameTimeVariance",
				BackgroundTransparency = 1,
				Text = "FrameTimeVariance:",
				TextXAlignment = Enum.TextXAlignment.Left,
				TextSize = Constants.Font.FONT_SIZE_14,
				Size = UDim2.new(1, 0, 0, 50)
			}),
			Create("TextLabel")({
				Name = "ExpectedAFrameTimeVariance",
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextSize = Constants.Font.FONT_SIZE_14,
				Size = UDim2.new(1, 0, 0, 30),
				Text = string.format("Expected: %g", p3.FrameTimeVariance)
			}),
			Create("TextLabel")({
				Name = "ActualFrameTimeVariance",
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextSize = Constants.Font.FONT_SIZE_14,
				Size = UDim2.new(1, 0, 0, 30),
				Text = string.format("Actual  : %g", v16.FrameTimeVariance)
			}),
			Create("TextLabel")({
				Name = "ActualFrameTimeVariance",
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextSize = Constants.Font.FONT_SIZE_14,
				Size = UDim2.new(1, 0, 0, 30),
				Text = string.format("Delta   : %g", v16.FrameTimeVariance - p3.FrameTimeVariance)
			})
		})
	}).Parent = CoreGui
end
function t1.Record(p4) -- line: 145
	-- upvalues: RunService (copy), VirtualInputManager (copy), HttpService (copy)
	RunService:setThrottleFramerateEnabled(false)
	VirtualInputManager.RecordingCompleted:Connect(function(_) -- line: 147
		-- upvalues: VirtualInputManager (copy), HttpService (copy), p4 (copy)
		print("*** Finished Recording Test ***")
		VirtualInputManager.AdditionalLuaState = HttpService:JSONEncode(p4:LuaState())
		print("~~~           DUMP          ~~~")
		VirtualInputManager:Dump()
	end)
	VirtualInputManager:StartRecording()
end
function t1.Play(p6, p7) -- line: 156
	-- upvalues: RunService (copy), VirtualInputManager (copy), HttpService (copy)
	print("PerformanceTesting:Play")
	RunService:setThrottleFramerateEnabled(false)
	VirtualInputManager.PlaybackCompleted:Connect(function() -- line: 159
		-- upvalues: HttpService (copy), VirtualInputManager (copy), p6 (copy)
		print("*** Finished Playing Test ***")

		local data = HttpService:JSONDecode(VirtualInputManager.AdditionalLuaState)

		p6:ShowResults(data)
	end)
	VirtualInputManager:StartPlaying(p7)
end
function t1.Stop(_) -- line: 167
	-- upvalues: Config (copy), VirtualInputManager (copy)
	if Config.General.PerformanceTestingMode == Enum.VirtualInputMode.Recording then
		VirtualInputManager:StopRecording()
	end
end
function t1.Initialize(p9, p10) -- line: 173
	-- upvalues: Config (copy)
	if Config.General.PerformanceTestingMode == Enum.VirtualInputMode.None then
		return
	end

	p9.appState = p10

	if Config.General.PerformanceTestingMode == Enum.VirtualInputMode.Recording then
		p9:Record()

		return
	end

	if Config.General.PerformanceTestingMode == Enum.VirtualInputMode.Playing then
		p9:Play(Config.General.PerformanceTestFilename)
	end
end

return t1
