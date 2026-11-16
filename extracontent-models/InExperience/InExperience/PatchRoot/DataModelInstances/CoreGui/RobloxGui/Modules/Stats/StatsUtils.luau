local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local CorePackages = game:GetService("CorePackages")
local gameSettings = UserSettings().GameSettings

local StyleWidgets = require(CoreGui.RobloxGui.Modules.StyleWidgets)

local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local v = require(CorePackages.Workspace.Packages.Loggers)
v = v.mutedError

function LocalizeWithFallback(p, p2)
	local success, result = pcall(function()
		return RobloxTranslator:FormatByKey(p)
	end)
	return if success and result then result else p2
end

local StatsUtils = {}

StatsUtils.SelectedBackgroundColor = Color3.new(0.4, 0.4, 0.4)
StatsUtils.FontColor = Color3.new(1, 1, 1)
StatsUtils.GraphBarGreenColor = Color3.new(126 / 255, 211 / 255, 33 / 255)
StatsUtils.GraphBarYellowColor = Color3.new(209 / 255, 211 / 255, 33 / 255)
StatsUtils.GraphBarRedColor = Color3.new(211 / 255, 88 / 255, 33 / 255)
StatsUtils.GraphAverageLineColor = Color3.new(208 / 255, 1 / 255, 27 / 255)
StatsUtils.GraphAverageLineBorderColor = Color3.new(1, 1, 1)
StatsUtils.NormalColor = Color3.fromRGB(31, 31, 31)
StatsUtils.Transparency = 0.5
StatsUtils.MiniPanelTitleFontSize = Enum.FontSize.Size12
StatsUtils.MiniPanelValueFontSize = Enum.FontSize.Size10
StatsUtils.PanelTitleFontSize = Enum.FontSize.Size24
StatsUtils.PanelValueFontSize = Enum.FontSize.Size14
StatsUtils.PanelGraphFontSize = Enum.FontSize.Size10

StatsUtils.ButtonHeight = 36 + StyleWidgets.TabSelectionHeight
StatsUtils.ViewerTopMargin = 10
StatsUtils.ViewerHeight = 144
StatsUtils.ViewerWidth = 306
StatsUtils.TextZIndex = 5
StatsUtils.GraphZIndex = 2
StatsUtils.GraphTargetLineInnerThickness = 2
StatsUtils.GraphAverageLineInnerThickness = 2
StatsUtils.GraphAverageLineBorderThickness = 1
StatsUtils.GraphAverageLineTotalThickness = StatsUtils.GraphAverageLineInnerThickness + 2 * StatsUtils.GraphAverageLineBorderThickness

StatsUtils.TextPanelTitleHeightY = 52
StatsUtils.TextPanelLegendItemHeightY = 20

StatsUtils.TextPanelLeftMarginPix = 10
StatsUtils.TextPanelTopMarginPix = 10

StatsUtils.DecorationSize = 12
StatsUtils.OvalKeySize = 8
StatsUtils.TargetKeyWidth = 11
StatsUtils.TargetKeyHeight = 2
StatsUtils.DecorationMargin = 6

StatsUtils.StatType_Memory = "st_Memory"
StatsUtils.StatType_CPU = "st_CPU"
StatsUtils.StatType_GPU = "st_GPU"
StatsUtils.StatType_NetworkSent = "st_NetworkSent"
StatsUtils.StatType_NetworkReceived = "st_NetworkReceived"
StatsUtils.StatType_Ping = "st_Ping"

StatsUtils.AllStatTypes = {
	StatsUtils.StatType_Memory,
	StatsUtils.StatType_CPU,
	StatsUtils.StatType_GPU,
	StatsUtils.StatType_NetworkSent,
	StatsUtils.StatType_NetworkReceived,
	StatsUtils.StatType_Ping
}

StatsUtils.StatNames = {
	[StatsUtils.StatType_Memory] = "Memory",
	[StatsUtils.StatType_CPU] = "CPU",
	[StatsUtils.StatType_GPU] = "GPU",
	[StatsUtils.StatType_NetworkSent] = "NetworkSent",
	[StatsUtils.StatType_NetworkReceived] = "NetworkReceived",
	[StatsUtils.StatType_Ping] = "Ping"
}

StatsUtils.StatMaxNames = {
	[StatsUtils.StatType_Memory] = "MaxMemory",
	[StatsUtils.StatType_CPU] = "MaxCPU",
	[StatsUtils.StatType_GPU] = "MaxGPU",
	[StatsUtils.StatType_NetworkSent] = "MaxNetworkSent",
	[StatsUtils.StatType_NetworkReceived] = "MaxNetworkReceived",
	[StatsUtils.StatType_Ping] = "MaxPing"
}

StatsUtils.NumButtonTypes = #StatsUtils.AllStatTypes

local v2 = LocalizeWithFallback("InGame.UnknownNamespace.Network", "Network")
local v3 = LocalizeWithFallback("InGame.UnknownNamespace.Sent", "Sent") .. "\n" .. v2
local v4 = LocalizeWithFallback("InGame.UnknownNamespace.Received", "Received") .. "\n" .. v2

StatsUtils.TypeToName = {
	[StatsUtils.StatType_Memory] = "Memory",
	[StatsUtils.StatType_CPU] = "CPU",
	[StatsUtils.StatType_GPU] = "GPU",
	[StatsUtils.StatType_NetworkSent] = v3,
	[StatsUtils.StatType_NetworkReceived] = v4,
	[StatsUtils.StatType_Ping] = "NetworkPing"
}

StatsUtils.TypeToShortName = {
	[StatsUtils.StatType_Memory] = "Mem",
	[StatsUtils.StatType_CPU] = "CPU",
	[StatsUtils.StatType_GPU] = "GPU",
	[StatsUtils.StatType_NetworkSent] = "Sent",
	[StatsUtils.StatType_NetworkReceived] = "Recv",
	[StatsUtils.StatType_Ping] = "NetworkPing"
}

StatsUtils.MemoryAnalyzerTypeToName = {
	HumanoidTexture = "Humanoid Textures",
	HumanoidTextureOrphan = "Humanoid Textures (Unused)",
	OtherTexture = "Other Textures",
	OtherTextureOrphan = "Other Textures (Unused)",
	CoreScript = "Core Scripts",
	UserScript = "User Scripts",
	Sounds = "Sounds",
	CSG = "Solid Models",
	Meshes = "Meshes"
}

function StatsUtils.GetMemoryAnalyzerStatName(p)
	if StatsUtils.MemoryAnalyzerTypeToName[p] == nil then
		return p
	end

	return StatsUtils.MemoryAnalyzerTypeToName[p]
end

function StatsUtils:StyleFrame()
	self.BackgroundColor3 = StatsUtils.NormalColor
	self.BackgroundTransparency = StatsUtils.Transparency
end

function StatsUtils:StyleButton()
	self.BackgroundColor3 = StatsUtils.NormalColor
	self.BackgroundTransparency = StatsUtils.Transparency
end

function StatsUtils:StyleTextWidget()
	self.BackgroundTransparency = 1
	self.TextColor3 = StatsUtils.FontColor
	self.Font = Enum.Font.SourceSansBold
end

function StatsUtils:StyleButtonSelected(p)
	StatsUtils.StyleButton(self)

	if p then
		self.BackgroundColor3 = StatsUtils.SelectedBackgroundColor
	end
end

function StatsUtils.FormatTypedValue(p, p2)
	if p2 == StatsUtils.StatType_Memory then
		return string.format("%.2f MB", p)
	end

	if not (p2 ~= StatsUtils.StatType_CPU and p2 ~= StatsUtils.StatType_GPU) then
		return string.format("%.2f ms", p)
	end

	if not (p2 ~= StatsUtils.StatType_NetworkSent and p2 ~= StatsUtils.StatType_NetworkReceived) then
		return string.format("%.2f KB/s", p)
	end

	if p2 == StatsUtils.StatType_Ping then
		return string.format("%.0f ms", p)
	end
end

function StatsUtils:StyleAverageLine()
	self.BackgroundColor3 = StatsUtils.GraphAverageLineColor
	self.BorderSizePixel = StatsUtils.GraphAverageLineBorderThickness
	self.BorderColor3 = StatsUtils.GraphAverageLineBorderColor
end

function StatsUtils.GetColorForValue(p, p2)
	if p < 0.666 * p2 then
		return StatsUtils.GraphBarGreenColor
	end

	if p < 1.333 * p2 then
		return StatsUtils.GraphBarYellowColor
	end

	return StatsUtils.GraphBarRedColor
end

function StatsUtils.PerformanceStatsShouldBeVisible()
	local localPlayer = Players.LocalPlayer
	return gameSettings.PerformanceStatsVisible and localPlayer ~= nil
end

return StatsUtils
