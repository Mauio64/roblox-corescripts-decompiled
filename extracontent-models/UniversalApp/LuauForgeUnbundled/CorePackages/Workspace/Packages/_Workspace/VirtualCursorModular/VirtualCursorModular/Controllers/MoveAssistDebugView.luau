local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualCursorModular/VirtualCursorModular/Controllers/MoveAssistController")

local m = Enum.KeyCode.M

local color = Color3.fromRGB(0, 200, 255)
local color2 = Color3.fromRGB(40, 230, 100)
local color3 = Color3.fromRGB(255, 255, 255)
local color4 = Color3.fromRGB(0, 200, 255)
local color5 = Color3.fromRGB(40, 230, 100)
local color6 = Color3.fromRGB(110, 110, 110)
local color7 = Color3.fromRGB(120, 90, 0)
local color8 = Color3.fromRGB(255, 220, 0)

local class = {}
class.__index = class

local function makeOutline(name, color9, parent)
	local frame = Instance.new("Frame")
	frame.Name = name
	frame.BackgroundTransparency = 1
	frame.BorderSizePixel = 0
	frame.Visible = false
	local uiStroke = Instance.new("UIStroke")
	uiStroke.Color = color9
	uiStroke.Thickness = 2
	uiStroke.Parent = frame
	frame.Parent = parent
	return { rect = frame, stroke = uiStroke }
end

local function makeRay(name, backgroundColor, parent)
	local frame = Instance.new("Frame")
	frame.Name = name

	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.Size = UDim2.fromOffset(80, 2)
	frame.BackgroundColor3 = backgroundColor
	frame.BorderSizePixel = 0
	frame.Visible = false
	frame.Parent = parent
	return frame
end

local function makeCandidateVisual(container)
	local outline = makeOutline("CandidateRect", color6, container)

	local aimDot = Instance.new("Frame")
	aimDot.Name = "AimDot"
	aimDot.AnchorPoint = Vector2.new(0.5, 0.5)
	aimDot.Size = UDim2.fromOffset(8, 8)
	aimDot.BorderSizePixel = 0
	aimDot.Visible = false
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(1, 0)
	uiCorner.Parent = aimDot
	aimDot.Parent = container

	return { rect = outline.rect, stroke = outline.stroke, aimDot = aimDot }
end

function class.new()
	local moveAssistDebug = Instance.new("ScreenGui")
	moveAssistDebug.Name = "MoveAssistDebug"
	moveAssistDebug.IgnoreGuiInset = true
	moveAssistDebug.DisplayOrder = 100000
	moveAssistDebug.ResetOnSpawn = false
	moveAssistDebug.Enabled = false

	local rect = makeOutline("AssistRadius", color, moveAssistDebug).rect
	rect.AnchorPoint = Vector2.new(0.5, 0.5)
	rect.Visible = true
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(1, 0)
	uiCorner.Parent = rect
	local inputRay = Instance.new("Frame")
	inputRay.Name = "InputRay"

	inputRay.AnchorPoint = Vector2.new(0.5, 0.5)
	inputRay.Size = UDim2.fromOffset(80, 2)
	inputRay.BackgroundColor3 = color3
	inputRay.BorderSizePixel = 0
	inputRay.Visible = false
	inputRay.Parent = moveAssistDebug
	local finalRay = Instance.new("Frame")
	finalRay.Name = "FinalRay"

	finalRay.AnchorPoint = Vector2.new(0.5, 0.5)
	finalRay.Size = UDim2.fromOffset(80, 2)
	finalRay.BackgroundColor3 = color4
	finalRay.BorderSizePixel = 0
	finalRay.Visible = false
	finalRay.Parent = moveAssistDebug

	local statsPanel = Instance.new("TextLabel")
	statsPanel.Name = "StatsPanel"
	statsPanel.Position = UDim2.fromOffset(12, 12)
	statsPanel.Size = UDim2.fromOffset(260, 228)
	statsPanel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	statsPanel.BackgroundTransparency = 0.4
	statsPanel.TextColor3 = Color3.fromRGB(255, 255, 255)
	statsPanel.TextXAlignment = Enum.TextXAlignment.Left
	statsPanel.TextYAlignment = Enum.TextYAlignment.Top
	statsPanel.Font = Enum.Font.Code
	statsPanel.TextSize = 14
	statsPanel.Text = ""
	statsPanel.Parent = moveAssistDebug

	moveAssistDebug.Parent = CoreGui

	local object = setmetatable({
		_container = moveAssistDebug,
		_radius = rect,
		_inputRay = inputRay,
		_finalRay = finalRay,
		_label = statsPanel,
		_candidateVisuals = {},
		_mode = 0,
		_toggleConnection = nil
	}, class)

	object._toggleConnection = UserInputService.InputBegan:Connect(function(input)
		if input.KeyCode == m then
			object:cycleMode()
		end
	end)

	return object
end

function class:cycleMode()
	self._mode = (self._mode + 1) % 3
end

function class:_getCandidateVisual(p3)
	local candidateVisual = self._candidateVisuals[p3]

	if candidateVisual then
		return candidateVisual
	end

	local candidateVisual2 = makeCandidateVisual(self._container)
	self._candidateVisuals[p3] = candidateVisual2
	return candidateVisual2
end

local function positionRay(p2, p3, p4)
	if p4.Magnitude < 0.001 then
		p2.Visible = false
		return
	end

	local unit = p4.Unit

	local v5 = p3 + unit * 40
	p2.Position = UDim2.fromOffset(v5.X, v5.Y)
	p2.Rotation = math.deg((math.atan2(unit.Y, unit.X)))
	p2.Visible = true
end

local function candidateColor(p2, p3)
	if p2.state == "committed" then
		return color2
	end

	if p2.state ~= "scored" then
		return color6
	end

	return color7:Lerp(color8, not (p3 > 0) and 0 or math.clamp(p2.influence / p3, 0, 1))
end

local function fmt(p2)
	return string.format("%.2f", p2)
end

function class:update(data, p2)
	if self._mode == 0 or not data then
		self._container.Enabled = false
		return
	end

	self._container.Enabled = true
	self._label.Visible = self._mode == 1

	local v5 = data.cursorPosition - p2

	local v6 = data.radius * 2
	self._radius.Size = UDim2.fromOffset(v6, v6)
	self._radius.Position = UDim2.fromOffset(v5.X, v5.Y)
	local v7 = 0

	for k, candidate in data.candidates do
		if v7 < candidate.influence then
			v7 = candidate.influence
		end
	end

	local count = 0

	for k, candidate in data.candidates do
		count += 1
		local candidateVisual = self:_getCandidateVisual(count)
		local v8

		if candidate.state == "committed" then
			v8 = color2
		elseif candidate.state == "scored" then
			v8 = color7:Lerp(color8, not (v7 > 0) and 0 or math.clamp(candidate.influence / v7, 0, 1))
		else
			v8 = color6
		end

		local v9 = candidate.position - p2
		candidateVisual.rect.Position = UDim2.fromOffset(v9.X, v9.Y)
		candidateVisual.rect.Size = UDim2.fromOffset(candidate.size.X, candidate.size.Y)
		candidateVisual.rect.Visible = true
		candidateVisual.stroke.Color = v8

		local aimPoint = candidate.aimPoint

		if aimPoint and candidate.state ~= "skipped" then
			local v10 = aimPoint - p2
			candidateVisual.aimDot.Position = UDim2.fromOffset(v10.X, v10.Y)
			candidateVisual.aimDot.BackgroundColor3 = v8
			candidateVisual.aimDot.Visible = true
		else
			candidateVisual.aimDot.Visible = false
		end
	end

	for i = count + 1, #self._candidateVisuals do
		self._candidateVisuals[i].rect.Visible = false
		self._candidateVisuals[i].aimDot.Visible = false
	end

	local inputRay = self._inputRay
	local inputDir = data.inputDir

	if inputDir.Magnitude < 0.001 then
		inputRay.Visible = false
	else
		local unit = inputDir.Unit

		local v8 = v5 + unit * 40
		inputRay.Position = UDim2.fromOffset(v8.X, v8.Y)
		inputRay.Rotation = math.deg((math.atan2(unit.Y, unit.X)))
		inputRay.Visible = true
	end

	local finalRay = self._finalRay
	local finalDir = data.finalDir

	if finalDir.Magnitude < 0.001 then
		finalRay.Visible = false
	else
		local unit = finalDir.Unit

		local v8 = v5 + unit * 40
		finalRay.Position = UDim2.fromOffset(v8.X, v8.Y)
		finalRay.Rotation = math.deg((math.atan2(unit.Y, unit.X)))
		finalRay.Visible = true
	end

	local finalRay2 = self._finalRay
	local v8 = if data.active then color5 else color4
	finalRay2.BackgroundColor3 = v8

	local committed = data.committed

	local v9 = (data.finalDir - data.inputDir) * data.inputMagnitude
	local v10 = math.deg((math.acos((math.clamp(data.inputDir:Dot(data.finalDir), -1, 1)))))
	local label = self._label
	local format = string.format

	local v11 = data.active and "ACTIVE" or "idle"
	local x = data.finalDir.X
	local v12 = string.format("%.2f", x)

	local y = data.finalDir.Y
	local v13 = string.format("%.2f", y)

	local inputMagnitude = data.inputMagnitude
	local v14 = string.format("%.2f", inputMagnitude)

	local x2 = v9.X
	local v15 = string.format("%.2f", x2)

	local y2 = v9.Y
	local v16 = string.format("%.2f", y2)
	local v17 = string.format("%.2f", v10)

	local v18 = not committed and "-" or committed.Name
	local bestInfluence = data.bestInfluence
	local v19 = string.format("%.2f", bestInfluence)

	local confidence = data.confidence
	local v20 = string.format("%.2f", confidence)

	local confidenceStrength = data.confidenceStrength
	local v21 = string.format("%.2f", confidenceStrength)

	local inputFollowStrength = data.inputFollowStrength
	local v22 = string.format("%.2f", inputFollowStrength)

	local arrivalFactor = data.arrivalFactor
	local v23 = string.format("%.2f", arrivalFactor)

	local intentFactor = data.intentFactor
	local v24 = string.format("%.2f", intentFactor)

	local masterGain = data.masterGain
	local v25 = string.format("%.2f", masterGain)

	local assistStrength = data.assistStrength
	label.Text = format(
		"MoveAssist: %s\nmoveDir: (%s, %s)  mag %s\nbend: (%s, %s)  %s deg\ncommitted: %s\ninfluence: %s\nconfidence: %s (str %s)\ninputFollow: %s\narrival: %s\nintent: %s\nmasterGain: %s\nassistStrength: %s\ncandidates: %d",
		v11,
		v12,
		v13,
		v14,
		v15,
		v16,
		v17,
		v18,
		v19,
		v20,
		v21,
		v22,
		v23,
		v24,
		v25,
		string.format("%.2f", assistStrength),
		count
	)
end

function class:Destroy()
	local toggleConnection = self._toggleConnection

	if toggleConnection then
		toggleConnection:Disconnect()
		self._toggleConnection = nil
	end

	self._container:Destroy()
end

return class
