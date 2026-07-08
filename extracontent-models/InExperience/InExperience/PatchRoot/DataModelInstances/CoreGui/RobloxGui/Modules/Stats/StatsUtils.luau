local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local CorePackages = game:GetService("CorePackages")
local GameSettings = UserSettings().GameSettings
local StyleWidgets = require(CoreGui.RobloxGui.Modules.StyleWidgets)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local _ = require(CorePackages.Workspace.Packages.Loggers).mutedError

function LocalizeWithFallback(p1, p2) -- line: 20
	-- upvalues: RobloxTranslator (copy)
	local ok, result = pcall(function() -- line: 21
		-- upvalues: RobloxTranslator (copy), p1 (copy)
		return RobloxTranslator:FormatByKey(p1)
	end)

	if ok and result then
		return result
	end

	return p2
end

local t1 = {
	SelectedBackgroundColor = Color3.new(0.4, 0.4, 0.4),
	FontColor = Color3.new(1, 1, 1),
	GraphBarGreenColor = Color3.new(0.49411764705882355, 0.8274509803921568, 0.12941176470588237),
	GraphBarYellowColor = Color3.new(0.8196078431372549, 0.8274509803921568, 0.12941176470588237),
	GraphBarRedColor = Color3.new(0.8274509803921568, 0.34509803921568627, 0.12941176470588237),
	GraphAverageLineColor = Color3.new(0.8156862745098039, 0.00392156862745098, 0.10588235294117647),
	GraphAverageLineBorderColor = Color3.new(1, 1, 1),
	NormalColor = Color3.fromRGB(31, 31, 31),
	Transparency = 0.5,
	MiniPanelTitleFontSize = Enum.FontSize.Size12,
	MiniPanelValueFontSize = Enum.FontSize.Size10,
	PanelTitleFontSize = Enum.FontSize.Size24,
	PanelValueFontSize = Enum.FontSize.Size14,
	PanelGraphFontSize = Enum.FontSize.Size10,
	ButtonHeight = 36 + StyleWidgets.TabSelectionHeight,
	ViewerTopMargin = 10,
	ViewerHeight = 144,
	ViewerWidth = 306,
	TextZIndex = 5,
	GraphZIndex = 2,
	GraphTargetLineInnerThickness = 2,
	GraphAverageLineInnerThickness = 2,
	GraphAverageLineBorderThickness = 1
}

t1.GraphAverageLineTotalThickness = t1.GraphAverageLineInnerThickness + 2 * t1.GraphAverageLineBorderThickness
t1.TextPanelTitleHeightY = 52
t1.TextPanelLegendItemHeightY = 20
t1.TextPanelLeftMarginPix = 10
t1.TextPanelTopMarginPix = 10
t1.DecorationSize = 12
t1.OvalKeySize = 8
t1.TargetKeyWidth = 11
t1.TargetKeyHeight = 2
t1.DecorationMargin = 6
t1.StatType_Memory = "st_Memory"
t1.StatType_CPU = "st_CPU"
t1.StatType_GPU = "st_GPU"
t1.StatType_NetworkSent = "st_NetworkSent"
t1.StatType_NetworkReceived = "st_NetworkReceived"
t1.StatType_Ping = "st_Ping"
t1.AllStatTypes = {
	t1.StatType_Memory,
	t1.StatType_CPU,
	t1.StatType_GPU,
	t1.StatType_NetworkSent,
	t1.StatType_NetworkReceived,
	t1.StatType_Ping
}
t1.StatNames = {
	[t1.StatType_Memory] = "Memory",
	[t1.StatType_CPU] = "CPU",
	[t1.StatType_GPU] = "GPU",
	[t1.StatType_NetworkSent] = "NetworkSent",
	[t1.StatType_NetworkReceived] = "NetworkReceived",
	[t1.StatType_Ping] = "Ping"
}
t1.StatMaxNames = {
	[t1.StatType_Memory] = "MaxMemory",
	[t1.StatType_CPU] = "MaxCPU",
	[t1.StatType_GPU] = "MaxGPU",
	[t1.StatType_NetworkSent] = "MaxNetworkSent",
	[t1.StatType_NetworkReceived] = "MaxNetworkReceived",
	[t1.StatType_Ping] = "MaxPing"
}
t1.NumButtonTypes = #t1.AllStatTypes

local v9 = LocalizeWithFallback("InGame.UnknownNamespace.Network", "Network")
local v10 = LocalizeWithFallback("InGame.UnknownNamespace.Sent", "Sent") .. "\n" .. v9
local v11 = LocalizeWithFallback("InGame.UnknownNamespace.Received", "Received") .. "\n" .. v9

t1.TypeToName = {
	[t1.StatType_Memory] = "Memory",
	[t1.StatType_CPU] = "CPU",
	[t1.StatType_GPU] = "GPU",
	[t1.StatType_NetworkSent] = v10,
	[t1.StatType_NetworkReceived] = v11,
	[t1.StatType_Ping] = "NetworkPing"
}
t1.TypeToShortName = {
	[t1.StatType_Memory] = "Mem",
	[t1.StatType_CPU] = "CPU",
	[t1.StatType_GPU] = "GPU",
	[t1.StatType_NetworkSent] = "Sent",
	[t1.StatType_NetworkReceived] = "Recv",
	[t1.StatType_Ping] = "NetworkPing"
}
t1.MemoryAnalyzerTypeToName = {
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

function t1.GetMemoryAnalyzerStatName(p3) -- line: 158
	-- upvalues: t1 (copy)
	if t1.MemoryAnalyzerTypeToName[p3] == nil then
		return p3
	end

	return t1.MemoryAnalyzerTypeToName[p3]
end
function t1.StyleFrame(p4) -- line: 166
	-- upvalues: t1 (copy)
	p4.BackgroundColor3 = t1.NormalColor
	p4.BackgroundTransparency = t1.Transparency
end
function t1.StyleButton(p5) -- line: 171
	-- upvalues: t1 (copy)
	p5.BackgroundColor3 = t1.NormalColor
	p5.BackgroundTransparency = t1.Transparency
end
function t1.StyleTextWidget(p6) -- line: 176
	-- upvalues: t1 (copy)
	p6.BackgroundTransparency = 1
	p6.TextColor3 = t1.FontColor
	p6.Font = Enum.Font.SourceSansBold
end
function t1.StyleButtonSelected(p7, p8) -- line: 182
	-- upvalues: t1 (copy)
	t1.StyleButton(p7)

	if p8 then
		p7.BackgroundColor3 = t1.SelectedBackgroundColor
	end
end
function t1.FormatTypedValue(p9, p10) -- line: 189
	-- upvalues: t1 (copy)
	if p10 == t1.StatType_Memory then
		return string.format("%.2f MB", p9)
	end

	if p10 == t1.StatType_CPU then
		return string.format("%.2f ms", p9)
	end

	if p10 == t1.StatType_GPU then
		return string.format("%.2f ms", p9)
	end

	if p10 == t1.StatType_NetworkSent then
		return string.format("%.2f KB/s", p9)
	end

	if p10 == t1.StatType_NetworkReceived then
		return string.format("%.2f KB/s", p9)
	end

	if p10 == t1.StatType_Ping then
		return string.format("%.0f ms", p9)
	end
end
function t1.StyleAverageLine(p11) -- line: 205
	-- upvalues: t1 (copy)
	p11.BackgroundColor3 = t1.GraphAverageLineColor
	p11.BorderSizePixel = t1.GraphAverageLineBorderThickness
	p11.BorderColor3 = t1.GraphAverageLineBorderColor
end
function t1.GetColorForValue(p12, p13) -- line: 211
	-- upvalues: t1 (copy)
	if p12 < 0.666 * p13 then
		return t1.GraphBarGreenColor
	end

	if p12 < 1.333 * p13 then
		return t1.GraphBarYellowColor
	end

	return t1.GraphBarRedColor
end
function t1.PerformanceStatsShouldBeVisible() -- line: 221
	-- upvalues: Players (copy), GameSettings (copy)
	local LocalPlayer = Players.LocalPlayer

	return GameSettings.PerformanceStatsVisible and LocalPlayer ~= nil
end

return t1
