local abs = math.abs
local clamp = math.clamp
local exp = math.exp
local rad = math.rad
local sign = math.sign
local sqrt = math.sqrt
local tan = math.tan

local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local gameSettings = UserSettings().GameSettings
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer

if not LocalPlayer then
	Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
	LocalPlayer = Players.LocalPlayer
end

local playerGui = nil
local freecam = nil

local parent = Workspace.CurrentCamera
Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
	local currentCamera = Workspace.CurrentCamera

	if currentCamera then
		parent = currentCamera
	end
end)

local freecamDepthOfField = nil
local freecamCustomGui = nil
local v = nil

local success, result = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserExitFreecamBreaksWithShiftlock")
end)

local v2 = success and result

local success2, result2 = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserShowGuiHideToggles")
end)

local v3 = success2 and result2

local success3, result3 = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserFixFreecamDeltaTimeCalculation")
end)

local v4 = success3 and result3

local success4, result4 = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserFixFreecamGuiChangeVisibility2")
end)

local v5 = success4 and result4

local success5, result5 = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserFreecamControlSpeed")
end)

local v6 = success5 and result5

local success6, result6 = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserFreecamTiltControl")
end)

local v7 = success6 and result6

local success7, result7 = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserFreecamSmoothnessControl")
end)

local v8 = success7 and result7

local success8, result8 = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserFreecamGuiDestabilization")
end)

local v9 = success8 and result8

local success9, result9 = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserFreecamDepthOfFieldEffect3")
end)

local v10 = success9 and result9

local success10, result10 = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserFreecamPlayerLock2")
end)

local v11 = success10 and result10

local success11, result11 = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserFreecamPlayerLockResetHeight")
end)

local v12 = success11 and result11

local success12, result12 = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserFreecamCustomGui")
end)

local v13 = success12 and result12

local value = Enum.ContextActionPriority.Low.Value
local value2 = Enum.ContextActionPriority.High.Value
local v14 = { Enum.KeyCode.LeftShift, Enum.KeyCode.P }
local set = { [Enum.KeyCode.Z] = true, [Enum.KeyCode.C] = true }

local set2 = { [Enum.KeyCode.ButtonL1] = true, [Enum.KeyCode.ButtonR1] = true }

local backSlashSet = { [Enum.KeyCode.BackSlash] = true }

local slashSet = { [Enum.KeyCode.Slash] = true }
local set3 = { [Enum.KeyCode.R] = true, [Enum.KeyCode.T] = true }

local gSet = { [Enum.KeyCode.G] = true }

local set4 = { [Enum.KeyCode.X] = true }

local lSet = { [Enum.KeyCode.L] = true }

local v15 = Vector2.new(0.75, 1) * 8

local v16 = 1.5
local v17 = 1
local v18 = 4
local v19 = 1

local nows = {}
local v20 = 0

local depthOfFieldEffects = {}

local childAddedConnection = nil
local childAddedConnection2 = nil
local childAddedConnection3 = nil
local playerAddedConnection = nil
local playerRemovingConnection = nil

local v21 = false
local v22 = 20
local v23 = 0
local players = {}
local v24 = 1
local v25 = nil

local enabled = false
local v26 = false

local class = {}
class.__index = class

function class.new(p, p2)
	local self = setmetatable({}, class)
	self.f = p
	self.p = p2
	self.v = p2 * 0
	return self
end

function class:Update(p, p2)
	local v27 = self.f * 2 * 3.141592653589793
	local p3 = self.p
	local v28 = self.v

	local v29 = p2 - p3
	local v30 = exp(-v27 * p)

	local v31 = p2 + (v28 * p - v29 * (v27 * p + 1)) * v30
	local v32 = (v27 * p * (v29 * v27 - v28) + v28) * v30

	self.p = v31
	self.v = v32

	return v31
end

function class:SetFreq(p)
	self.f = p
end

function class:Reset(p)
	self.p = p
	self.v = p * 0
end

local v27 = Vector3.new()
local v28

if v7 then
	v28 = Vector3.new()
else
	v28 = Vector2.new()
end

local fieldOfView2 = 0

local new = class.new
local v29 = v16
local v30 = new(v29, (Vector3.new()))
local new2 = class.new
local v31 = v17
local v32 = new2(v31, Vector2.new())
local v36 = class.new(v18, 0)
local v37 = class.new(v19, 0)

local v38 = {}

local function fCurve(p) -- 1 equivalent call inferred from this helper
	return (exp(2 * p) - 1) / 6.38905609893065
end

local function fDeadzone(p) -- 1 equivalent call inferred from this helper
	return fCurve((p - 0.15) / 0.85) -- inferred equivalent call
end

local function thumbstickCurve(p)
	return sign(p) * clamp(fDeadzone(abs(p)), 0, 1) -- inferred equivalent call
end

local v39 = {
	ButtonX = 0,
	ButtonY = 0,
	DPadDown = 0,
	DPadUp = 0,
	DPadLeft = 0,
	DPadRight = 0,
	ButtonL2 = 0,
	ButtonR2 = 0,
	ButtonL1 = 0,
	ButtonR1 = 0,
	Thumbstick1 = Vector2.new(),
	Thumbstick2 = Vector2.new()
}

local v40 = {
	W = 0,
	A = 0,
	S = 0,
	D = 0,
	E = 0,
	Q = 0,
	U = 0,
	H = 0,
	J = 0,
	K = 0,
	I = 0,
	Y = 0,
	Up = 0,
	Down = 0,
	Left = 0,
	Right = 0,
	LeftShift = 0,
	RightShift = 0,
	Z = 0,
	C = 0,
	Comma = 0,
	Period = 0,
	LeftBracket = 0,
	RightBracket = 0,
	Semicolon = 0,
	Quote = 0,
	V = 0,
	B = 0,
	N = 0,
	M = 0,
	BackSlash = 0,
	Minus = 0,
	Equals = 0,
	Slash = 0,
	R = 0,
	T = 0,
	G = 0,
	X = 0,
	L = 0
}

local v41 = { Delta = Vector2.new(), MouseWheel = 0 }

local v42 = Vector2.new(1, 1) * 0.04908738521234052
local v43 = v42 / 60
local v44 = Vector2.new(1, 1) * 0.39269908169872414

local v45 = {
	FarIntensity = { ADJ = 0.1, MIN = 0, MAX = 1 },
	NearIntensity = { ADJ = 0.1, MIN = 0, MAX = 1 },
	FocusDistance = { ADJ = 20, MIN = 0, MAX = 200 },
	FocusRadius = { ADJ = 5, MIN = 0, MAX = 50 }
}

local navSpeed = 1
local rollSpeed = 1
local fovSpeed = 1

function v38.Vel(p)
	if v6 then
		navSpeed = clamp(navSpeed + p * (v40.Up - v40.Down + v39.DPadUp - v39.DPadDown) * 0.75, 0.01, 4)
	else
		navSpeed = clamp(navSpeed + p * (v40.Up - v40.Down) * 0.75, 0.01, 4)
	end

	local v46 = Vector3.new(
		thumbstickCurve(v39.Thumbstick1.X),
		thumbstickCurve(v39.ButtonR2) - thumbstickCurve(v39.ButtonL2),
		thumbstickCurve(-v39.Thumbstick1.Y)
	) * Vector3.new(1, 1, 1)

	local v47 = Vector3.new(v40.D - v40.A + v40.K - v40.H, v40.E - v40.Q + v40.I - v40.Y, v40.S - v40.W + v40.J - v40.U) * Vector3.new(1, 1, 1)

	local v48 = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)
		or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)

	return (v46 + v47) * (navSpeed * (v48 and 0.25 or 1))
end

function v38.Pan(p)
	local v46 = Vector2.new(thumbstickCurve(v39.Thumbstick2.Y), thumbstickCurve(-v39.Thumbstick2.X)) * v44
	local v47 = v41.Delta * v42

	if v4 and p > 0 then
		v47 = v41.Delta / p * v43
	end

	v41.Delta = Vector2.new()
	return v46 + v47
end

function v38.Fov(p)
	if v6 then
		fovSpeed = clamp(fovSpeed + p * (v40.Right - v40.Left + v39.DPadRight - v39.DPadLeft) * 0.75, 0.01, 4)
	end

	local v46 = (v39.ButtonX - v39.ButtonY) * 0.25
	local v47 = v41.MouseWheel * 1

	if v4 and p > 0 then
		v47 = v41.MouseWheel / p * (1 / 60)
	end

	v41.MouseWheel = 0

	if v6 then
		return (v46 + v47) * fovSpeed
	end

	return v46 + v47
end

function v38.Roll(p)
	rollSpeed = clamp(rollSpeed + p * (v40.Period - v40.Comma) * 0.75, 0.01, 4)

	return ((v39.ButtonR1 - v39.ButtonL1) * 1 + (v40.C - v40.Z) * 1) * rollSpeed
end

function v38.SpringControl(p)
	if v10 then
		local v46 = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)
			or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
		local v47 = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl)
			or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)

		if v46 or v47 then
			return
		end
	end

	v16 = clamp(v16 + p * (v40.RightBracket - v40.LeftBracket) * 0.75, 0.01, 10)
	v30:SetFreq(v16)

	v17 = clamp(v17 + p * (v40.Quote - v40.Semicolon) * 0.75, 0.01, 10)
	v32:SetFreq(v17)

	v18 = clamp(v18 + p * (v40.B - v40.V) * 0.75, 0.01, 10)
	v36:SetFreq(v18)

	v19 = clamp(v19 + p * (v40.M - v40.N) * 0.75, 0.01, 10)
	v37:SetFreq(v19)
end

function v38.DoF(p)
	local v46 = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)
		or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
	local v47 = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl)
		or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)

	if v46 then
		freecamDepthOfField.FarIntensity = clamp(
			freecamDepthOfField.FarIntensity + p * (v40.RightBracket - v40.LeftBracket) * v45.FarIntensity.ADJ,
			v45.FarIntensity.MIN,
			v45.FarIntensity.MAX
		)

		freecamDepthOfField.InFocusRadius = clamp(
			freecamDepthOfField.InFocusRadius + p * (v40.Equals - v40.Minus) * v45.FocusRadius.ADJ,
			v45.FocusRadius.MIN,
			v45.FocusRadius.MAX
		)
	elseif v47 then
		freecamDepthOfField.NearIntensity = clamp(
			freecamDepthOfField.NearIntensity + p * (v40.RightBracket - v40.LeftBracket) * v45.NearIntensity.ADJ,
			v45.NearIntensity.MIN,
			v45.NearIntensity.MAX
		)
	else
		freecamDepthOfField.FocusDistance = clamp(
			freecamDepthOfField.FocusDistance + p * (v40.Equals - v40.Minus) * v45.FocusDistance.ADJ,
			v45.FocusDistance.MIN,
			v45.FocusDistance.MAX
		)
	end
end

local function resetKeys(items, p) -- 8 equivalent calls inferred from this helper
	for k, _ in pairs(items) do
		if p[k.Name] then
			p[k.Name] = 0
		end
	end
end

local function handleDoubleTapReset(keyCode)
	local now = os.clock()

	local v46 = nows[keyCode]
	local v47 = v46 and now - v46 or -1

	if v46 and v47 <= 0.25 and now - v20 >= 0.1 then
		v28 = Vector3.new(v28.x, v28.y, 0)
		v37:Reset(0)

		if v10 then
			resetKeys(set2, v39) -- inferred equivalent call
			resetKeys(set, v40) -- inferred equivalent call
		else
			v39.ButtonL1 = 0
			v39.ButtonR1 = 0
			v40.C = 0
			v40.Z = 0
		end

		v20 = now
	end

	nows[keyCode] = now
end

local function findPlayerLockRootPart(p)
	if not players or #players < 1 then
		return nil
	end

	for _ = 1, #players do
		v24 = (v24 - 1 + p) % #players + 1

		local v46 = players[v24]
		local character = v46 and v46.Character

		if character then
			local humanoid = character:FindFirstChildOfClass("Humanoid")

			if humanoid and humanoid.RootPart then
				return humanoid.RootPart
			end
		end

		if p == 0 then
			p = 1
		end
	end

	v21 = false
	return nil
end

local function Keypress(_, p, data)
	v40[data.KeyCode.Name] = p == Enum.UserInputState.Begin and 1 or 0

	if v7 and set[data.KeyCode] and data.UserInputState == Enum.UserInputState.Begin then
		handleDoubleTapReset(data.KeyCode)
	end

	if v10 and backSlashSet[data.KeyCode] and data.UserInputState == Enum.UserInputState.Begin then
		if freecamDepthOfField.Enabled then
			for _, v46 in ipairs(depthOfFieldEffects) do
				if v46.Parent then
					v46.Enabled = true
				end
			end

			if childAddedConnection2 then
				childAddedConnection2:Disconnect()
				childAddedConnection2 = nil
			end

			if childAddedConnection3 then
				childAddedConnection3:Disconnect()
				childAddedConnection3 = nil
			end

			depthOfFieldEffects = {}
		else
			depthOfFieldEffects = {}

			for _, depthOfFieldEffect in ipairs(parent:GetChildren()) do
				if not (depthOfFieldEffect:IsA("DepthOfFieldEffect") and depthOfFieldEffect.Enabled) then
					continue
				end

				depthOfFieldEffects[#depthOfFieldEffects + 1] = depthOfFieldEffect
				depthOfFieldEffect.Enabled = false
			end

			for _, depthOfFieldEffect in ipairs(Lighting:GetChildren()) do
				if not (depthOfFieldEffect:IsA("DepthOfFieldEffect") and depthOfFieldEffect.Enabled) then
					continue
				end

				depthOfFieldEffects[#depthOfFieldEffects + 1] = depthOfFieldEffect
				depthOfFieldEffect.Enabled = false
			end

			childAddedConnection2 = parent.ChildAdded:Connect(function(depthOfFieldEffect)
				if depthOfFieldEffect:IsA("DepthOfFieldEffect") and depthOfFieldEffect.Enabled then
					depthOfFieldEffects[#depthOfFieldEffects + 1] = depthOfFieldEffect
					depthOfFieldEffect.Enabled = false
				end
			end)
			childAddedConnection3 = Lighting.ChildAdded:Connect(function(depthOfFieldEffect)
				if depthOfFieldEffect:IsA("DepthOfFieldEffect") and depthOfFieldEffect.Enabled then
					depthOfFieldEffects[#depthOfFieldEffects + 1] = depthOfFieldEffect
					depthOfFieldEffect.Enabled = false
				end
			end)
		end

		freecamDepthOfField.Enabled = not freecamDepthOfField.Enabled
		resetKeys(backSlashSet, v40) -- inferred equivalent call
	end

	if v11 then
		if slashSet[data.KeyCode] and data.UserInputState == Enum.UserInputState.Begin then
			v21 = not v21

			if v21 then
				v22 = 20

				if v12 then
					v23 = 0
				end

				v25 = findPlayerLockRootPart(0)
			end

			resetKeys(slashSet, v40) -- inferred equivalent call
		end

		if set3[data.KeyCode] and data.UserInputState == Enum.UserInputState.Begin then
			if v21 and #players > 0 then
				v25 = findPlayerLockRootPart(v40.T - v40.R)
			end

			resetKeys(set3, v40) -- inferred equivalent call
		end
	end

	if not v13 then
		return Enum.ContextActionResult.Sink
	end

	if gSet[data.keyCode] and data.UserInputState == Enum.UserInputState.Begin then
		if freecam and freecam.Parent then
			freecam.Enabled = not freecam.Enabled
		end

		resetKeys(gSet, v40) -- inferred equivalent call
	end

	if set4[data.keyCode] and data.UserInputState == Enum.UserInputState.Begin then
		enabled = not enabled

		if v then
			local screenGuis = v.getScreenGuis()

			for _, v46 in pairs(screenGuis) do
				if v46.Parent and v46 ~= freecam then
					v46.Enabled = enabled
				end
			end
		end

		resetKeys(set4, v40) -- inferred equivalent call
	end

	if lSet[data.keyCode] and data.UserInputState == Enum.UserInputState.Begin then
		v26 = not v26
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, v26)
		resetKeys(lSet, v40) -- inferred equivalent call
	end

	return Enum.ContextActionResult.Sink
end

local function GpButton(_, p, p2)
	v39[p2.KeyCode.Name] = p == Enum.UserInputState.Begin and 1 or 0

	if v7 and set2[p2.KeyCode] and p2.UserInputState == Enum.UserInputState.Begin then
		handleDoubleTapReset(p2.KeyCode)
	end

	return Enum.ContextActionResult.Sink
end

local function MousePan(_, _, p)
	local delta = p.Delta
	v41.Delta = Vector2.new(-delta.y, -delta.x)
	return Enum.ContextActionResult.Sink
end

local function Thumb(_, _, p)
	v39[p.KeyCode.Name] = p.Position
	return Enum.ContextActionResult.Sink
end

local function Trigger(_, _, p)
	v39[p.KeyCode.Name] = p.Position.z
	return Enum.ContextActionResult.Sink
end

local function MouseWheel(_, _, p)
	v41[p.UserInputType.Name] = -p.Position.z
	return Enum.ContextActionResult.Sink
end

local function Zero(items) -- 3 equivalent calls inferred from this helper
	for k, item in pairs(items) do
		items[k] = item * 0
	end
end

function v38.StartCapture()
	if v6 then
		ContextActionService:BindActionAtPriority(
			"FreecamKeyboard",
			Keypress,
			false,
			value2,
			Enum.KeyCode.W,
			Enum.KeyCode.U,
			Enum.KeyCode.A,
			Enum.KeyCode.H,
			Enum.KeyCode.S,
			Enum.KeyCode.J,
			Enum.KeyCode.D,
			Enum.KeyCode.K,
			Enum.KeyCode.E,
			Enum.KeyCode.I,
			Enum.KeyCode.Q,
			Enum.KeyCode.Y
		)

		ContextActionService:BindActionAtPriority(
			"FreecamKeyboardControlSpeed",
			Keypress,
			false,
			value2,
			Enum.KeyCode.Up,
			Enum.KeyCode.Down,
			Enum.KeyCode.Left,
			Enum.KeyCode.Right
		)

		ContextActionService:BindActionAtPriority(
			"FreecamGamepadControlSpeed",
			GpButton,
			false,
			value2,
			Enum.KeyCode.DPadUp,
			Enum.KeyCode.DPadDown,
			Enum.KeyCode.DPadLeft,
			Enum.KeyCode.DPadRight
		)
	else
		ContextActionService:BindActionAtPriority(
			"FreecamKeyboard",
			Keypress,
			false,
			value2,
			Enum.KeyCode.W,
			Enum.KeyCode.U,
			Enum.KeyCode.A,
			Enum.KeyCode.H,
			Enum.KeyCode.S,
			Enum.KeyCode.J,
			Enum.KeyCode.D,
			Enum.KeyCode.K,
			Enum.KeyCode.E,
			Enum.KeyCode.I,
			Enum.KeyCode.Q,
			Enum.KeyCode.Y,
			Enum.KeyCode.Up,
			Enum.KeyCode.Down
		)
	end

	if v7 then
		ContextActionService:BindActionAtPriority(
			"FreecamKeyboardTiltControl",
			Keypress,
			false,
			value2,
			Enum.KeyCode.Z,
			Enum.KeyCode.C
		)

		ContextActionService:BindActionAtPriority(
			"FreecamGamepadTiltControl",
			GpButton,
			false,
			value2,
			Enum.KeyCode.ButtonL1,
			Enum.KeyCode.ButtonR1
		)

		ContextActionService:BindActionAtPriority(
			"FreecamKeyboardTiltControlSpeed",
			Keypress,
			false,
			value2,
			Enum.KeyCode.Comma,
			Enum.KeyCode.Period
		)

		if v8 then
			ContextActionService:BindActionAtPriority(
				"FreecamKeyboardSmoothnessControl",
				Keypress,
				false,
				value2,
				Enum.KeyCode.LeftBracket,
				Enum.KeyCode.RightBracket,
				Enum.KeyCode.Semicolon,
				Enum.KeyCode.Quote,
				Enum.KeyCode.V,
				Enum.KeyCode.B,
				Enum.KeyCode.N,
				Enum.KeyCode.M
			)
		end
	end

	if v10 then
		ContextActionService:BindActionAtPriority(
			"FreecamKeyboardDoFToggle",
			Keypress,
			false,
			value2,
			Enum.KeyCode.BackSlash
		)
		ContextActionService:BindActionAtPriority(
			"FreecamKeyboardDoFControls",
			Keypress,
			false,
			value2,
			Enum.KeyCode.Minus,
			Enum.KeyCode.Equals
		)
	end

	if v11 then
		ContextActionService:BindActionAtPriority(
			"FreecamKeyboardPlayerLockToggle",
			Keypress,
			false,
			value2,
			Enum.KeyCode.Slash
		)

		ContextActionService:BindActionAtPriority(
			"FreecamKeyboardPlayerLockSwitch",
			Keypress,
			false,
			value2,
			Enum.KeyCode.R,
			Enum.KeyCode.T
		)
	end

	if v13 then
		ContextActionService:BindActionAtPriority(
			"FreecamKeyboardCustomGuiToggle",
			Keypress,
			false,
			value2,
			Enum.KeyCode.G
		)

		ContextActionService:BindActionAtPriority(
			"FreecamKeyboardPlayerGuiToggle",
			Keypress,
			false,
			value2,
			Enum.KeyCode.X
		)

		ContextActionService:BindActionAtPriority(
			"FreecamKeyboardLeaderboardToggle",
			Keypress,
			false,
			value2,
			Enum.KeyCode.L
		)
	end

	ContextActionService:BindActionAtPriority(
		"FreecamMousePan",
		MousePan,
		false,
		value2,
		Enum.UserInputType.MouseMovement
	)
	ContextActionService:BindActionAtPriority(
		"FreecamMouseWheel",
		MouseWheel,
		false,
		value2,
		Enum.UserInputType.MouseWheel
	)
	ContextActionService:BindActionAtPriority(
		"FreecamGamepadButton",
		GpButton,
		false,
		value2,
		Enum.KeyCode.ButtonX,
		Enum.KeyCode.ButtonY
	)
	ContextActionService:BindActionAtPriority(
		"FreecamGamepadTrigger",
		Trigger,
		false,
		value2,
		Enum.KeyCode.ButtonR2,
		Enum.KeyCode.ButtonL2
	)
	ContextActionService:BindActionAtPriority(
		"FreecamGamepadThumbstick",
		Thumb,
		false,
		value2,
		Enum.KeyCode.Thumbstick1,
		Enum.KeyCode.Thumbstick2
	)
end

function v38.StopCapture()
	if not v13 then
		navSpeed = 1

		if v6 then
			fovSpeed = 1
		end

		if v7 then
			rollSpeed = 1
		end
	end

	Zero(v39) -- inferred equivalent call
	Zero(v40) -- inferred equivalent call
	Zero(v41) -- inferred equivalent call
	ContextActionService:UnbindAction("FreecamKeyboard")

	if v6 then
		ContextActionService:UnbindAction("FreecamKeyboardControlSpeed")
		ContextActionService:UnbindAction("FreecamGamepadControlSpeed")
	end

	if v7 then
		ContextActionService:UnbindAction("FreecamKeyboardTiltControl")
		ContextActionService:UnbindAction("FreecamGamepadTiltControl")
		ContextActionService:UnbindAction("FreecamKeyboardTiltControlSpeed")

		if v8 then
			ContextActionService:UnbindAction("FreecamKeyboardSmoothnessControl")
		end
	end

	if v10 then
		ContextActionService:UnbindAction("FreecamKeyboardDoFToggle")
		ContextActionService:UnbindAction("FreecamKeyboardDoFControls")
	end

	if v11 then
		ContextActionService:UnbindAction("FreecamKeyboardPlayerLockToggle")
		ContextActionService:UnbindAction("FreecamKeyboardPlayerLockSwitch")
	end

	if v13 then
		ContextActionService:UnbindAction("FreecamKeyboardCustomGuiToggle")
		ContextActionService:UnbindAction("FreecamKeyboardPlayerGuiToggle")
		ContextActionService:UnbindAction("FreecamKeyboardLeaderboardToggle")
	end

	ContextActionService:UnbindAction("FreecamMousePan")
	ContextActionService:UnbindAction("FreecamMouseWheel")
	ContextActionService:UnbindAction("FreecamGamepadButton")
	ContextActionService:UnbindAction("FreecamGamepadTrigger")
	ContextActionService:UnbindAction("FreecamGamepadThumbstick")
end

function v38.getNavSpeed()
	return navSpeed
end

function v38.getFovSpeed()
	return fovSpeed
end

function v38.getRollSpeed()
	return rollSpeed
end

local function StepFreecam(p)
	if v8 then
		v38.SpringControl(p)
	end

	if v10 and freecamDepthOfField and freecamDepthOfField.Parent then
		v38.DoF(p)
	end

	local v46 = v30:Update(p, v38.Vel(p))
	local v47 = v32:Update(p, v38.Pan(p))
	local v48 = v36:Update(p, v38.Fov(p))
	local v49

	if v7 then
		v49 = v37:Update(p, v38.Roll(p))
	end

	local v50 = sqrt(0.7002075382097097 / tan((rad(fieldOfView2 / 2))))

	fieldOfView2 = clamp(fieldOfView2 + v48 * 300 * (p / v50), 1, 120)
	local v51

	if v7 then
		local v52 = v47 * v15 * (p / v50)
		v28 += Vector3.new(v52.X, v52.Y, v49 * -1.5707963267948966 * (p / v50))

		if v8 then
			v28 = Vector3.new(v28.x % 6.283185307179586, v28.y % 6.283185307179586, v28.z % 6.283185307179586)
		else
			v28 = Vector3.new(clamp(v28.x, -1.5707963267948966, 1.5707963267948966), v28.y % 6.283185307179586, v28.z)
		end

		v51 = CFrame.new(v27) * CFrame.fromOrientation(v28.x, v28.y, v28.z) * CFrame.new(v46 * Vector3.new(64, 64, 64) * p)
	else
		v28 += v47 * v15 * (p / v50)
		v28 = Vector2.new(clamp(v28.x, -1.5707963267948966, 1.5707963267948966), v28.y % 6.283185307179586)

		v51 = CFrame.new(v27) * CFrame.fromOrientation(v28.x, v28.y, 0) * CFrame.new(v46 * Vector3.new(64, 64, 64) * p)
	end

	if v11 and v21 and v25 then
		local v52 = v46.Z * 64 * p
		local v53 = v46.Y * 64 * p
		v22 = clamp(v22 + v52, 5, 50)
		v23 = clamp(v23 + v53, -10, 10)
		local cframe = CFrame.new(v25.Position + Vector3.new(0, v23, 0))
		local v54

		if v7 then
			v54 = CFrame.fromOrientation(v28.x, v28.y, v28.z)
		else
			v54 = CFrame.fromOrientation(v28.x, v28.y, 0)
		end

		v51 = cframe * v54 * CFrame.new(0, 0, v22)
	end

	if v13 and freecamCustomGui and freecamCustomGui.Parent and freecam and freecam.Parent and freecam.Enabled then
		local v52 = ""

		if p > 0 then
			local v53 = (v51.p - v27) / p
			v52 ..= string.format("Velocity: (%.1f, %.1f, %.1f)\n", v53.X, v53.Y, v53.Z)
		end

		local text = v52 .. string.format("FOV: %.1f\n", fieldOfView2)

		if v7 then
			text ..= string.format("Tilt: %.1f°\n", (math.deg(v28.z)))
		end

		if v8 then
			text = (((text .. string.format("Stiffness (Vel): %.1f\n", v16)) .. string.format("Stiffness (Pan): %.1f\n", v17)) .. string.format("Stiffness (FOV): %.1f\n", v18)) .. string.format("Stiffness (Roll): %.1f\n", v19)
		end

		if v6 then
			text = ((text .. string.format("Movement Speed: %.1f\n", v38.getNavSpeed())) .. string.format("Zoom Speed: %.1f\n", v38.getFovSpeed())) .. string.format("Tilt Speed: %.1f\n", v38.getRollSpeed())
		end

		if v10 then
			if freecamDepthOfField and freecamDepthOfField.Parent and freecamDepthOfField.Enabled then
				text = ((((text .. string.format("Custom Depth Of Field: On\n")) .. string.format(
					"Custom Depth Of Field Near Intensity: %.1f\n",
					freecamDepthOfField.NearIntensity
				)) .. string.format("Custom Depth Of Field Far Intensity: %.1f\n", freecamDepthOfField.FarIntensity)) .. string.format(
					"Custom Depth Of Field Focus Distance: %.1f\n",
					freecamDepthOfField.FocusDistance
				)) .. string.format("Custom Depth Of Field Focus Radius: %.1f\n", freecamDepthOfField.InFocusRadius)
			else
				text ..= string.format("Custom Depth Of Field: Off\n")
			end
		end

		if v11 then
			if v21 and #players > 0 then
				text ..= string.format("Player Lock: %s\n", players[v24].Name)
			else
				text ..= string.format("Player Lock: Off\n")
			end
		end

		freecamCustomGui.Text = text
	end

	v27 = v51.p

	parent.CFrame = v51
	parent.Focus = v51
	parent.FieldOfView = fieldOfView2
end

local function CheckMouseLockAvailability() -- 1 equivalent call inferred from this helper
	local devEnableMouseLock = Players.LocalPlayer.DevEnableMouseLock
	local v46 = Players.LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.Scriptable
	local v47 = gameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch
	local v48 = gameSettings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove

	return devEnableMouseLock and v47 and not v48 and not v46
end

v = {}

local mouseBehavior = nil
local mouseIconEnabled = nil
local cameraType = nil
local focus = nil
local cframe = nil
local fieldOfView = nil
local screenGuis = {}
local coreGuiEnableds = { Backpack = true, Chat = true, Health = true, PlayerList = true }

local cores = { BadgesNotificationsActive = true, PointsNotificationsActive = true }

function v.Push()
	for k in pairs(coreGuiEnableds) do
		coreGuiEnableds[k] = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType[k])
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType[k], false)
	end

	for k in pairs(cores) do
		cores[k] = StarterGui:GetCore(k)
		StarterGui:SetCore(k, false)
	end

	local playerGui2 = LocalPlayer:FindFirstChildOfClass("PlayerGui")

	if playerGui2 then
		for _, screenGui in pairs(playerGui2:GetChildren()) do
			if not (screenGui:IsA("ScreenGui") and screenGui.Enabled) then
				continue
			end

			screenGuis[#screenGuis + 1] = screenGui
			screenGui.Enabled = false
		end

		if v5 then
			childAddedConnection = playerGui2.ChildAdded:Connect(function(screenGui)
				if screenGui:IsA("ScreenGui") and screenGui.Enabled then
					screenGuis[#screenGuis + 1] = screenGui

					if v13 then
						screenGui.Enabled = enabled
					else
						screenGui.Enabled = false
					end
				end
			end)
		end
	end

	fieldOfView = parent.FieldOfView
	parent.FieldOfView = 70

	cameraType = parent.CameraType
	parent.CameraType = Enum.CameraType.Custom

	cframe = parent.CFrame
	focus = parent.Focus

	mouseIconEnabled = UserInputService.MouseIconEnabled
	UserInputService.MouseIconEnabled = false

	if v2 then
		if CheckMouseLockAvailability() then -- inferred equivalent call
			mouseBehavior = Enum.MouseBehavior.Default
		else
			mouseBehavior = UserInputService.MouseBehavior
		end
	else
		mouseBehavior = UserInputService.MouseBehavior
	end

	UserInputService.MouseBehavior = Enum.MouseBehavior.Default
end

function v.Pop()
	for k, v47 in pairs(coreGuiEnableds) do
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType[k], v47)
	end

	for k, v47 in pairs(cores) do
		StarterGui:SetCore(k, v47)
	end

	for _, v47 in pairs(screenGuis) do
		if v13 then
			if v47.Parent and v47 ~= freecam then
				v47.Enabled = true
			end
		elseif v47.Parent then
			v47.Enabled = true
		end
	end

	if v5 then
		if childAddedConnection then
			childAddedConnection:Disconnect()
			childAddedConnection = nil
		end

		screenGuis = {}
	end

	parent.FieldOfView = fieldOfView
	fieldOfView = nil

	parent.CameraType = cameraType
	cameraType = nil

	parent.CFrame = cframe
	cframe = nil

	parent.Focus = focus
	focus = nil

	UserInputService.MouseIconEnabled = mouseIconEnabled
	mouseIconEnabled = nil

	UserInputService.MouseBehavior = mouseBehavior
	mouseBehavior = nil
end

function v.getScreenGuis()
	return screenGuis
end

local function removePlayerFromList(p)
	for i, v47 in ipairs(players) do
		if v47 ~= p then
			continue
		end

		table.remove(players, i)

		if v24 == i and v21 then
			v21 = false
			v24 = 1
		end

		if i < v24 then
			v24 -= 1
		end

		if v24 > #players or v24 < 1 then
			v24 = 1
			break
		end

		break
	end
end

local function initializePlayerList()
	players = Players:GetPlayers()

	for i, v47 in ipairs(players) do
		if v47 == LocalPlayer then
			v24 = i
			break
		end
	end

	playerAddedConnection = Players.PlayerAdded:Connect(function(player)
		table.insert(players, player)
	end)

	playerRemovingConnection = Players.PlayerRemoving:Connect(removePlayerFromList)
end

local function StartFreecam()
	if v11 then
		initializePlayerList()
	end

	if not v9 and v3 then
		script:SetAttribute("FreecamEnabled", true)
	end

	local cframe2 = parent.CFrame

	if v7 then
		v28 = Vector3.new(cframe2:toEulerAnglesYXZ())
	else
		v28 = Vector2.new(cframe2:toEulerAnglesYXZ())
	end

	v27 = cframe2.p
	fieldOfView2 = parent.FieldOfView

	v30:Reset((Vector3.new()))
	v32:Reset(Vector2.new())
	v36:Reset(0)

	if v7 then
		v37:Reset(0)
	end

	if not v13 and v8 then
		v16 = 1.5
		v17 = 1
		v18 = 4
		v19 = 1
	end

	if v13 then
		playerGui = LocalPlayer:WaitForChild("PlayerGui")
		freecam = playerGui:WaitForChild("Freecam")

		if not (freecamCustomGui and freecamCustomGui.Parent) then
			freecamCustomGui = Instance.new("TextLabel")
			freecamCustomGui.Name = "FreecamCustomGui"
			freecamCustomGui.TextColor3 = Color3.new(1, 1, 1)
			freecamCustomGui.Font = Enum.Font.SourceSansBold
			freecamCustomGui.TextSize = 20
			freecamCustomGui.TextStrokeTransparency = 0
			freecamCustomGui.BackgroundTransparency = 1
			freecamCustomGui.TextWrapped = true
			freecamCustomGui.TextXAlignment = Enum.TextXAlignment.Right
			freecamCustomGui.AutomaticSize = Enum.AutomaticSize.Y
			freecamCustomGui.AnchorPoint = Vector2.new(1, 1)
			freecamCustomGui.Position = UDim2.new(1, -10, 1, -10)
			freecamCustomGui.Size = UDim2.new(0, 400, 0, 0)
			freecamCustomGui.Parent = freecam
		end
	end

	v.Push()

	if v10 and not (freecamDepthOfField and freecamDepthOfField.Parent) then
		freecamDepthOfField = Instance.new("DepthOfFieldEffect")
		freecamDepthOfField.Enabled = false
		freecamDepthOfField.Name = "FreecamDepthOfField"
		freecamDepthOfField.Parent = parent
	end

	RunService:BindToRenderStep("Freecam", Enum.RenderPriority.Camera.Value, StepFreecam)
	v38.StartCapture()
end

local function StopFreecam()
	if not v9 and v3 then
		script:SetAttribute("FreecamEnabled", false)
	end

	if v11 then
		if playerAddedConnection then
			playerAddedConnection:Disconnect()
			playerAddedConnection = nil
		end

		if playerRemovingConnection then
			playerRemovingConnection:Disconnect()
			playerRemovingConnection = nil
		end

		v21 = false
		v24 = 1
		players = {}
	end

	if v10 and freecamDepthOfField and freecamDepthOfField.Parent then
		if freecamDepthOfField.Enabled then
			for _, v47 in ipairs(depthOfFieldEffects) do
				if v47.Parent then
					v47.Enabled = true
				end
			end

			if childAddedConnection2 then
				childAddedConnection2:Disconnect()
				childAddedConnection2 = nil
			end

			if childAddedConnection3 then
				childAddedConnection3:Disconnect()
				childAddedConnection3 = nil
			end

			depthOfFieldEffects = {}
		end

		freecamDepthOfField.Enabled = false
	end

	if v13 then
		if freecam and freecam.Parent then
			freecam.Enabled = false
		end

		enabled = false
		v26 = false
	end

	v38.StopCapture()
	RunService:UnbindFromRenderStep("Freecam")
	v.Pop()
end

local v47 = false

local function ToggleFreecam() -- 1 equivalent call inferred from this helper
	if v47 then
		StopFreecam()
	else
		StartFreecam()
	end

	v47 = not v47

	if v9 then
		script:SetAttribute("FreecamEnabled", v47)
	end
end

local function CheckMacro(list)
	for i = 1, #list - 1 do
		if not UserInputService:IsKeyDown(list[i]) then
			return
		end
	end

	ToggleFreecam() -- inferred equivalent call
end

local function HandleActivationInput(_, p, p2)
	if p == Enum.UserInputState.Begin and p2.KeyCode == v14[#v14] then
		CheckMacro(v14)
	end

	return Enum.ContextActionResult.Pass
end

ContextActionService:BindActionAtPriority("FreecamToggle", HandleActivationInput, false, value, v14[#v14])

if v9 or v3 then
	script:SetAttribute("FreecamEnabled", v47)
	script:GetAttributeChangedSignal("FreecamEnabled"):Connect(function()
		local freecamEnabled = script:GetAttribute("FreecamEnabled")

		if typeof(freecamEnabled) ~= "boolean" then
			script:SetAttribute("FreecamEnabled", v47)
		elseif freecamEnabled ~= v47 then
			if freecamEnabled then
				StartFreecam()
				v47 = true
			else
				StopFreecam()
				v47 = false
			end
		end
	end)
end

return {}
