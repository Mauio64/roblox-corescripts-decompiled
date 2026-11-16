local VirtualCursorModular = script:FindFirstAncestor("VirtualCursorModular")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

require(VirtualCursorModular.Controllers.MoveAssistController)

local m = Enum.KeyCode.M

local color = Color3.fromRGB(0, 200, 255)
local color2 = Color3.fromRGB(40, 230, 100)
local color3 = Color3.fromRGB(255, 255, 255)
local color4 = Color3.fromRGB(0, 200, 255)
local color5 = Color3.fromRGB(40, 230, 100)
local color6 = Color3.fromRGB(110, 110, 110)
local color7 = Color3.fromRGB(120, 90, 0)
local color8 = Color3.fromRGB(255, 220, 0)

local MoveAssistDebugView = {}
MoveAssistDebugView.__index = MoveAssistDebugView

local function makeOutline(name: string, color9: Color3, parent)
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

local function makeRay(name: string, color9: Color3, moveAssistDebug) -- 2 equivalent calls inferred from this helper
	local frame = Instance.new("Frame")
	frame.Name = name

	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.Size = UDim2.fromOffset(80, 2)
	frame.BackgroundColor3 = color9
	frame.BorderSizePixel = 0
	frame.Visible = false
	frame.Parent = moveAssistDebug
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

function MoveAssistDebugView.new()
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
	local ray = makeRay("InputRay", color3, moveAssistDebug) -- inferred equivalent call
	local ray2 = makeRay("FinalRay", color4, moveAssistDebug) -- inferred equivalent call
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
		_inputRay = ray,
		_finalRay = ray2,
		_label = statsPanel,
		_candidateVisuals = {},
		_mode = 0,
		_toggleConnection = nil
	}, MoveAssistDebugView)

	object._toggleConnection = UserInputService.InputBegan:Connect(function(input)
		if input.KeyCode == m then
			object:cycleMode()
		end
	end)

	return object
end

function MoveAssistDebugView:cycleMode()
	self._mode = (self._mode + 1) % 3
end

function MoveAssistDebugView:_getCandidateVisual(p: number)
	local candidateVisual = self._candidateVisuals[p]

	if candidateVisual then
		return candidateVisual
	end

	local candidateVisual2 = makeCandidateVisual(self._container)
	self._candidateVisuals[p] = candidateVisual2
	return candidateVisual2
end

local function positionRay(p, vector2: Vector2, vector2_2: Vector2) -- 2 equivalent calls inferred from this helper
	if vector2_2.Magnitude < 0.001 then
		p.Visible = false
		return
	end

	local unit = vector2_2.Unit

	local v = vector2 + unit * 40
	p.Position = UDim2.fromOffset(v.X, v.Y)
	p.Rotation = math.deg((math.atan2(unit.Y, unit.X)))
	p.Visible = true
end

local function candidateColor(candidate, p: number) -- 1 equivalent call inferred from this helper
	if candidate.state == "committed" then
		return color2
	end

	if candidate.state == "scored" then
		return color7:Lerp(color8, not (p > 0) and 0 or math.clamp(candidate.influence / p, 0, 1))
	end

	return color6
end

local function fmt(p: number) -- 14 equivalent calls inferred from this helper
	return string.format("%.2f", p)
end

function MoveAssistDebugView:update(data, vector2: Vector2)
	if self._mode == 0 or not data then
		self._container.Enabled = false
		return
	end

	self._container.Enabled = true
	self._label.Visible = self._mode == 1

	local v = data.cursorPosition - vector2

	local v2 = data.radius * 2
	self._radius.Size = UDim2.fromOffset(v2, v2)
	self._radius.Position = UDim2.fromOffset(v.X, v.Y)
	local v3 = 0

	for _, candidate in data.candidates do
		if v3 < candidate.influence then
			v3 = candidate.influence
		end
	end

	local count = 0

	for _, candidate in data.candidates do
		count += 1
		local candidateVisual = self:_getCandidateVisual(count)
		local v4 = candidateColor(candidate, v3) -- inferred equivalent call
		local v5 = candidate.position - vector2
		candidateVisual.rect.Position = UDim2.fromOffset(v5.X, v5.Y)
		candidateVisual.rect.Size = UDim2.fromOffset(candidate.size.X, candidate.size.Y)
		candidateVisual.rect.Visible = true
		candidateVisual.stroke.Color = v4

		local aimPoint = candidate.aimPoint

		if aimPoint and candidate.state ~= "skipped" then
			local v6 = aimPoint - vector2
			candidateVisual.aimDot.Position = UDim2.fromOffset(v6.X, v6.Y)
			candidateVisual.aimDot.BackgroundColor3 = v4
			candidateVisual.aimDot.Visible = true
		else
			candidateVisual.aimDot.Visible = false
		end
	end

	for i = count + 1, #self._candidateVisuals do
		self._candidateVisuals[i].rect.Visible = false
		self._candidateVisuals[i].aimDot.Visible = false
	end

	positionRay(self._inputRay, v, data.inputDir) -- inferred equivalent call
	positionRay(self._finalRay, v, data.finalDir) -- inferred equivalent call

	local finalRay = self._finalRay
	local backgroundColor = if data.active then color5 else color4
	finalRay.BackgroundColor3 = backgroundColor

	local committed = data.committed

	local v4 = (data.finalDir - data.inputDir) * data.inputMagnitude
	local v5 = math.deg((math.acos((math.clamp(data.inputDir:Dot(data.finalDir), -1, 1)))))
	local label = self._label

	local v6 = data.active and "ACTIVE" or "idle"
	local v7 = fmt(data.finalDir.X) -- inferred equivalent call
	local v8 = fmt(data.finalDir.Y) -- inferred equivalent call
	local v9 = fmt(data.inputMagnitude) -- inferred equivalent call
	local v10 = fmt(v4.X) -- inferred equivalent call
	local v11 = fmt(v4.Y) -- inferred equivalent call
	local v12 = fmt(v5) -- inferred equivalent call
	label.Text = string.format(
		"MoveAssist: %s\nmoveDir: (%s, %s)  mag %s\nbend: (%s, %s)  %s deg\ncommitted: %s\ninfluence: %s\nconfidence: %s (str %s)\ninputFollow: %s\narrival: %s\nintent: %s\nmasterGain: %s\nassistStrength: %s\ncandidates: %d",
		v6,
		v7,
		v8,
		v9,
		v10,
		v11,
		v12,
		not committed and "-" or committed.Name,
		fmt(data.bestInfluence), -- inferred equivalent call
		fmt(data.confidence), -- inferred equivalent call
		fmt(data.confidenceStrength), -- inferred equivalent call
		fmt(data.inputFollowStrength), -- inferred equivalent call
		fmt(data.arrivalFactor), -- inferred equivalent call
		fmt(data.intentFactor), -- inferred equivalent call
		fmt(data.masterGain), -- inferred equivalent call
		fmt(data.assistStrength), -- inferred equivalent call
		count
	)
end

function MoveAssistDebugView:Destroy()
	local toggleConnection = self._toggleConnection

	if toggleConnection then
		toggleConnection:Disconnect()
		self._toggleConnection = nil
	end

	self._container:Destroy()
end

return MoveAssistDebugView
