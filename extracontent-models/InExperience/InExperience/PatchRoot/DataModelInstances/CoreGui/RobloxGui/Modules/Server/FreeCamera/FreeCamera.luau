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
local GameSettings = UserSettings().GameSettings
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

if not LocalPlayer then
	Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
	LocalPlayer = Players.LocalPlayer
end

local PlayerGui = nil
local Freecam = nil
local CurrentCamera = Workspace.CurrentCamera

Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- line: 67
	-- upvalues: Workspace (copy), CurrentCamera (ref)
	local CurrentCamera2 = Workspace.CurrentCamera

	if CurrentCamera2 then
		CurrentCamera = CurrentCamera2
	end
end)

local DepthOfFieldEffect = nil
local TextLabel = nil
local t19 = nil
local ok, result = pcall(function() -- line: 80
	return UserSettings():IsUserFeatureEnabled("UserExitFreecamBreaksWithShiftlock")
end)
local u25 = ok and result
local ok2, result2 = pcall(function() -- line: 88
	return UserSettings():IsUserFeatureEnabled("UserShowGuiHideToggles")
end)
local u28 = ok2 and result2
local ok3, result3 = pcall(function() -- line: 96
	return UserSettings():IsUserFeatureEnabled("UserFixFreecamDeltaTimeCalculation")
end)
local u31 = ok3 and result3
local ok4, result4 = pcall(function() -- line: 104
	return UserSettings():IsUserFeatureEnabled("UserFixFreecamGuiChangeVisibility2")
end)
local u34 = ok4 and result4
local ok5, result5 = pcall(function() -- line: 112
	return UserSettings():IsUserFeatureEnabled("UserFreecamControlSpeed")
end)
local u37 = ok5 and result5
local ok6, result6 = pcall(function() -- line: 120
	return UserSettings():IsUserFeatureEnabled("UserFreecamTiltControl")
end)
local u40 = ok6 and result6
local ok7, result7 = pcall(function() -- line: 128
	return UserSettings():IsUserFeatureEnabled("UserFreecamSmoothnessControl")
end)
local u43 = ok7 and result7
local ok8, result8 = pcall(function() -- line: 136
	return UserSettings():IsUserFeatureEnabled("UserFreecamGuiDestabilization")
end)
local u46 = ok8 and result8
local ok9, result9 = pcall(function() -- line: 144
	return UserSettings():IsUserFeatureEnabled("UserFreecamDepthOfFieldEffect3")
end)
local u49 = ok9 and result9
local ok10, result10 = pcall(function() -- line: 152
	return UserSettings():IsUserFeatureEnabled("UserFreecamPlayerLock2")
end)
local u52 = ok10 and result10
local ok11, result11 = pcall(function() -- line: 160
	return UserSettings():IsUserFeatureEnabled("UserFreecamPlayerLockResetHeight")
end)
local u55 = ok11 and result11
local ok12, result12 = pcall(function() -- line: 168
	return UserSettings():IsUserFeatureEnabled("UserFreecamCustomGui")
end)
local u58 = ok12 and result12
local LowValue = Enum.ContextActionPriority.Low.Value
local HighValue = Enum.ContextActionPriority.High.Value
local t1 = {
	Enum.KeyCode.LeftShift,
	Enum.KeyCode.P
}
local t2 = {
	[Enum.KeyCode.Z] = true,
	[Enum.KeyCode.C] = true
}
local t3 = {
	[Enum.KeyCode.ButtonL1] = true,
	[Enum.KeyCode.ButtonR1] = true
}
local t4 = {
	[Enum.KeyCode.BackSlash] = true
}
local t5 = {
	[Enum.KeyCode.Slash] = true
}
local t6 = {
	[Enum.KeyCode.R] = true,
	[Enum.KeyCode.T] = true
}
local t7 = {
	[Enum.KeyCode.G] = true
}
local t8 = {
	[Enum.KeyCode.X] = true
}
local t9 = {
	[Enum.KeyCode.L] = true
}
local v70 = Vector2.new(0.75, 1) * 8
local n1 = 1.5
local n2 = 1
local n3 = 4
local n4 = 1
local t10 = {}
local n5 = 0
local t11 = {}
local connection = nil
local connection2 = nil
local connection3 = nil
local connection4 = nil
local connection5 = nil
local u83 = false
local n6 = 20
local n7 = 0
local t12 = {}
local n8 = 1
local u88 = nil
local u89 = false
local u90 = false
local t13 = {}

t13.__index = t13

function t13.new(p1, p2) -- line: 267
	-- upvalues: t13 (copy)
	local self = setmetatable({}, t13)

	self.f = p1
	self.p = p2
	self.v = p2 * 0

	return self
end
function t13.Update(p3, p4, p5) -- line: 275
	-- upvalues: exp (copy)
	local v149 = p3.f * 2 * 3.141592653589793
	local p = p3.p
	local v = p3.v
	local v152 = p5 - p
	local v153 = exp(-v149 * p4)
	local v154 = p5 + (v * p4 - v152 * (v149 * p4 + 1)) * v153
	local v155 = (v149 * p4 * (v152 * v149 - v) + v) * v153

	p3.p = v154
	p3.v = v155

	return v154
end
function t13.SetFreq(p6, p7) -- line: 292
	p6.f = p7
end
function t13.Reset(p8, p9) -- line: 296
	p8.p = p9
	p8.v = p9 * 0
end

local vector3 = Vector3.new()
local u93 = if not u40 then Vector2.new() else Vector3.new()
local n9 = 0
local v95 = t13.new(n1, (Vector3.new()))
local v96 = t13.new(n2, Vector2.new())
local v97 = t13.new(n3, 0)
local v98 = t13.new(n4, 0)
local t14 = {}

local function fCurve(p10) -- line: 325
	-- upvalues: exp (copy)
	return (exp(2 * p10) - 1) / 6.38905609893065
end
local function fDeadzone(p11) -- line: 329
	-- upvalues: exp (copy)
	return (exp(2 * ((p11 - 0.15) / 0.85)) - 1) / 6.38905609893065
end
local function thumbstickCurve(p12) -- line: 333
	-- upvalues: sign (copy), abs (copy), exp (copy), clamp (copy)
	return sign(p12) * clamp((exp(2 * ((abs(p12) - 0.15) / 0.85)) - 1) / 6.38905609893065, 0, 1)
end

local t15 = {
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
local t16 = {
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
local t17 = {
	MouseWheel = 0,
	Delta = Vector2.new()
}
local v106 = Vector2.new(1, 1) * 0.04908738521234052
local v107 = v106 / 60
local v108 = Vector2.new(1, 1) * 0.39269908169872414
local t18 = {
	FarIntensity = {
		ADJ = 0.1,
		MIN = 0,
		MAX = 1
	},
	NearIntensity = {
		ADJ = 0.1,
		MIN = 0,
		MAX = 1
	},
	FocusDistance = {
		ADJ = 20,
		MIN = 0,
		MAX = 200
	},
	FocusRadius = {
		ADJ = 5,
		MIN = 0,
		MAX = 50
	}
}
local n10 = 1
local n11 = 1
local n12 = 1

function t14.Vel(p13) -- line: 448
	-- upvalues: u37 (ref), n10 (ref), t16 (copy), t15 (copy), clamp (copy), thumbstickCurve (ref), UserInputService (copy)
	if u37 then
		n10 = clamp(n10 + p13 * (t16.Up - t16.Down + t15.DPadUp - t15.DPadDown) * 0.75, 0.01, 4)
	else
		n10 = clamp(n10 + p13 * (t16.Up - t16.Down) * 0.75, 0.01, 4)
	end

	local v164 = Vector3.new(thumbstickCurve(t15.Thumbstick1.X), thumbstickCurve(t15.ButtonR2) - thumbstickCurve(t15.ButtonL2), thumbstickCurve(-t15.Thumbstick1.Y)) * Vector3.new(1, 1, 1)
	local v165 = Vector3.new(t16.D - t16.A + t16.K - t16.H, t16.E - t16.Q + t16.I - t16.Y, t16.S - t16.W + t16.J - t16.U) * Vector3.new(1, 1, 1)
	local v166 = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)

	return (v164 + v165) * (n10 * (not v166 and 1 or 0.25))
end
function t14.Pan(p14) -- line: 471
	-- upvalues: thumbstickCurve (ref), t15 (copy), v108 (copy), t17 (copy), v106 (copy), u31 (ref), v107 (copy)
	local v168 = Vector2.new(thumbstickCurve(t15.Thumbstick2.Y), thumbstickCurve(-t15.Thumbstick2.X)) * v108
	local v169 = t17.Delta * v106

	if u31 and p14 > 0 then
		v169 = t17.Delta / p14 * v107
	end

	t17.Delta = Vector2.new()

	return v168 + v169
end
function t14.Fov(p15) -- line: 486
	-- upvalues: u37 (ref), n12 (ref), t16 (copy), t15 (copy), clamp (copy), t17 (copy), u31 (ref)
	if u37 then
		n12 = clamp(n12 + p15 * (t16.Right - t16.Left + t15.DPadRight - t15.DPadLeft) * 0.75, 0.01, 4)
	end

	local v171 = (t15.ButtonX - t15.ButtonY) * 0.25
	local v172 = t17.MouseWheel * 1

	if u31 and p15 > 0 then
		v172 = t17.MouseWheel / p15 * 0.016666666666666666
	end

	t17.MouseWheel = 0

	if u37 then
		return (v171 + v172) * n12
	end

	return v171 + v172
end
function t14.Roll(p16) -- line: 505
	-- upvalues: n11 (ref), t16 (copy), clamp (copy), t15 (copy)
	n11 = clamp(n11 + p16 * (t16.Period - t16.Comma) * 0.75, 0.01, 4)

	return ((t15.ButtonR1 - t15.ButtonL1) * 1 + (t16.C - t16.Z) * 1) * n11
end
function t14.SpringControl(p17) -- line: 514
	-- upvalues: u49 (ref), UserInputService (copy), n1 (ref), t16 (copy), clamp (copy), v95 (copy), n2 (ref), v96 (copy), n3 (ref), v97 (copy), n4 (ref), v98 (copy)
	if u49 then
		local v175 = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
		local v176 = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)

		if v175 or v176 then
			return
		end
	end

	n1 = clamp(n1 + p17 * (t16.RightBracket - t16.LeftBracket) * 0.75, 0.01, 10)
	v95:SetFreq(n1)
	n2 = clamp(n2 + p17 * (t16.Quote - t16.Semicolon) * 0.75, 0.01, 10)
	v96:SetFreq(n2)
	n3 = clamp(n3 + p17 * (t16.B - t16.V) * 0.75, 0.01, 10)
	v97:SetFreq(n3)
	n4 = clamp(n4 + p17 * (t16.M - t16.N) * 0.75, 0.01, 10)
	v98:SetFreq(n4)
end
function t14.DoF(p18) -- line: 537
	-- upvalues: UserInputService (copy), DepthOfFieldEffect (ref), t16 (copy), t18 (copy), clamp (copy)
	local v178 = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
	local v179 = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)

	if v178 then
		DepthOfFieldEffect.FarIntensity = clamp(DepthOfFieldEffect.FarIntensity + p18 * (t16.RightBracket - t16.LeftBracket) * t18.FarIntensity.ADJ, t18.FarIntensity.MIN, t18.FarIntensity.MAX)
		DepthOfFieldEffect.InFocusRadius = clamp(DepthOfFieldEffect.InFocusRadius + p18 * (t16.Equals - t16.Minus) * t18.FocusRadius.ADJ, t18.FocusRadius.MIN, t18.FocusRadius.MAX)

		return
	end

	if v179 then
		DepthOfFieldEffect.NearIntensity = clamp(DepthOfFieldEffect.NearIntensity + p18 * (t16.RightBracket - t16.LeftBracket) * t18.NearIntensity.ADJ, t18.NearIntensity.MIN, t18.NearIntensity.MAX)

		return
	end

	DepthOfFieldEffect.FocusDistance = clamp(DepthOfFieldEffect.FocusDistance + p18 * (t16.Equals - t16.Minus) * t18.FocusDistance.ADJ, t18.FocusDistance.MIN, t18.FocusDistance.MAX)
end

local function resetKeys(p19, p20) -- line: 568
	for k, _ in pairs(p19) do
		if p20[k.Name] then
			p20[k.Name] = 0
		end
	end
end
local function handleDoubleTapReset(p21) -- line: 576
	-- upvalues: t10 (copy), n5 (ref), u93 (ref), v98 (copy), u49 (ref), t3 (copy), t15 (copy), t2 (copy), t16 (copy)
	local elapsed = os.clock()
	local v186 = t10[p21]
	local v187 = v186 and elapsed - v186 or -1

	if v186 and (v187 <= 0.25 and elapsed - n5 >= 0.1) then
		u93 = Vector3.new(u93.x, u93.y, 0)
		v98:Reset(0)

		if u49 then
			local v188 = t3
			local v189 = t15

			for k, _ in pairs(v188) do
				if v189[k.Name] then
					v189[k.Name] = 0
				end
			end

			local v192 = t2
			local v193 = t16

			for k, _ in pairs(v192) do
				if v193[k.Name] then
					v193[k.Name] = 0
				end
			end
		else
			t15.ButtonL1 = 0
			t15.ButtonR1 = 0
			t16.C = 0
			t16.Z = 0
		end

		n5 = elapsed
	end

	t10[p21] = elapsed
end
local function findPlayerLockRootPart(p22) -- line: 601
	-- upvalues: t12 (ref), n8 (ref), u83 (ref)
	if not t12 or #t12 < 1 then
		return nil
	end

	for _ = 1, #t12 do
		n8 = (n8 - 1 + p22) % #t12 + 1

		local v198 = t12[n8]
		local v199 = v198 and v198.Character

		if v199 then
			local Humanoid = v199:FindFirstChildOfClass("Humanoid")

			if Humanoid and Humanoid.RootPart then
				return Humanoid.RootPart
			end
		end

		if p22 == 0 then
			p22 = 1
		end
	end

	u83 = false

	return nil
end
local function Keypress(_, p24, p25) -- line: 628
	-- upvalues: t16 (copy), u40 (ref), t2 (copy), handleDoubleTapReset (copy), u49 (ref), t4 (copy), DepthOfFieldEffect (ref), t11 (ref), CurrentCamera (ref), Lighting (copy), connection2 (ref), connection3 (ref), u52 (ref), t5 (copy), u83 (ref), n6 (ref), u55 (ref), n7 (ref), u88 (ref), findPlayerLockRootPart (copy), t6 (copy), t12 (ref), u58 (ref), t7 (copy), Freecam (ref), t8 (copy), u89 (ref), t19 (ref), t9 (copy), u90 (ref), StarterGui (copy)
	t16[p25.KeyCode.Name] = p24 ~= Enum.UserInputState.Begin and 0 or 1

	if u40 and (t2[p25.KeyCode] and p25.UserInputState == Enum.UserInputState.Begin) then
		handleDoubleTapReset(p25.KeyCode)
	end

	if u49 and t4[p25.KeyCode] and p25.UserInputState == Enum.UserInputState.Begin then
		if not DepthOfFieldEffect.Enabled then
			t11 = {}

			for _, child in ipairs(CurrentCamera:GetChildren()) do
				if child:IsA("DepthOfFieldEffect") and child.Enabled then
					t11[#t11 + 1] = child
					child.Enabled = false
				end
			end

			for _, child in ipairs(Lighting:GetChildren()) do
				if child:IsA("DepthOfFieldEffect") and child.Enabled then
					t11[#t11 + 1] = child
					child.Enabled = false
				end
			end

			connection2 = CurrentCamera.ChildAdded:Connect(function(child) -- line: 654
				-- upvalues: t11 (ref)
				if child:IsA("DepthOfFieldEffect") and child.Enabled then
					t11[#t11 + 1] = child
					child.Enabled = false
				end
			end)
			connection3 = Lighting.ChildAdded:Connect(function(child) -- line: 660
				-- upvalues: t11 (ref)
				if child:IsA("DepthOfFieldEffect") and child.Enabled then
					t11[#t11 + 1] = child
					child.Enabled = false
				end
			end)
		else
			for _, v in ipairs(t11) do
				if v.Parent then
					v.Enabled = true
				end
			end

			if connection2 then
				connection2:Disconnect()
				connection2 = nil
			end

			if connection3 then
				connection3:Disconnect()
				connection3 = nil
			end

			t11 = {}
		end

		DepthOfFieldEffect.Enabled = not DepthOfFieldEffect.Enabled

		local v210 = t4
		local v211 = t16

		for k, _ in pairs(v210) do
			if v211[k.Name] then
				v211[k.Name] = 0
			end
		end
	end

	if u52 then
		if t5[p25.KeyCode] and p25.UserInputState == Enum.UserInputState.Begin then
			u83 = not u83

			if u83 then
				n6 = 20

				if u55 then
					n7 = 0
				end

				u88 = findPlayerLockRootPart(0)
			end

			local v214 = t5
			local v215 = t16

			for k, _ in pairs(v214) do
				if v215[k.Name] then
					v215[k.Name] = 0
				end
			end
		end

		if t6[p25.KeyCode] and p25.UserInputState == Enum.UserInputState.Begin then
			if u83 and #t12 > 0 then
				local v218 = t16.T - t16.R

				u88 = findPlayerLockRootPart(v218)
			end

			local v219 = t6
			local v220 = t16

			for k, _ in pairs(v219) do
				if v220[k.Name] then
					v220[k.Name] = 0
				end
			end
		end
	end

	if u58 then
		if t7[p25.keyCode] and p25.UserInputState == Enum.UserInputState.Begin then
			if Freecam and Freecam.Parent then
				Freecam.Enabled = not Freecam.Enabled
			end

			local v223 = t7
			local v224 = t16

			for k, _ in pairs(v223) do
				if v224[k.Name] then
					v224[k.Name] = 0
				end
			end
		end

		if t8[p25.keyCode] and p25.UserInputState == Enum.UserInputState.Begin then
			u89 = not u89

			if t19 then
				local v227 = t19.getScreenGuis()

				for _, v in pairs(v227) do
					if v.Parent and v ~= Freecam then
						v.Enabled = u89
					end
				end
			end

			local v230 = t8
			local v231 = t16

			for k, _ in pairs(v230) do
				if v231[k.Name] then
					v231[k.Name] = 0
				end
			end
		end

		if t9[p25.keyCode] and p25.UserInputState == Enum.UserInputState.Begin then
			u90 = not u90
			StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, u90)

			local v234 = t9
			local v235 = t16

			for k, _ in pairs(v234) do
				if v235[k.Name] then
					v235[k.Name] = 0
				end
			end
		end
	end

	return Enum.ContextActionResult.Sink
end
local function GpButton(_, p27, p28) -- line: 741
	-- upvalues: t15 (copy), u40 (ref), t3 (copy), handleDoubleTapReset (copy)
	t15[p28.KeyCode.Name] = p27 ~= Enum.UserInputState.Begin and 0 or 1

	if u40 and (t3[p28.KeyCode] and p28.UserInputState == Enum.UserInputState.Begin) then
		handleDoubleTapReset(p28.KeyCode)
	end

	return Enum.ContextActionResult.Sink
end
local function MousePan(_, _, p31) -- line: 753
	-- upvalues: t17 (copy)
	local Delta = p31.Delta

	t17.Delta = Vector2.new(-Delta.y, -Delta.x)

	return Enum.ContextActionResult.Sink
end
local function Thumb(_, _, p34) -- line: 759
	-- upvalues: t15 (copy)
	t15[p34.KeyCode.Name] = p34.Position

	return Enum.ContextActionResult.Sink
end
local function Trigger(_, _, p37) -- line: 764
	-- upvalues: t15 (copy)
	t15[p37.KeyCode.Name] = p37.Position.z

	return Enum.ContextActionResult.Sink
end
local function MouseWheel(_, _, p40) -- line: 769
	-- upvalues: t17 (copy)
	t17[p40.UserInputType.Name] = -p40.Position.z

	return Enum.ContextActionResult.Sink
end
local function Zero(p41) -- line: 774
	for k, v in pairs(p41) do
		p41[k] = v * 0
	end
end

function t14.StartCapture() -- line: 780
	-- upvalues: u37 (ref), ContextActionService (copy), Keypress (copy), HighValue (copy), GpButton (copy), u40 (ref), u43 (ref), u49 (ref), u52 (ref), u58 (ref), MousePan (copy), MouseWheel (copy), Trigger (copy), Thumb (copy)
	if u37 then
		ContextActionService:BindActionAtPriority("FreecamKeyboard", Keypress, false, HighValue, Enum.KeyCode.W, Enum.KeyCode.U, Enum.KeyCode.A, Enum.KeyCode.H, Enum.KeyCode.S, Enum.KeyCode.J, Enum.KeyCode.D, Enum.KeyCode.K, Enum.KeyCode.E, Enum.KeyCode.I, Enum.KeyCode.Q, Enum.KeyCode.Y)
		ContextActionService:BindActionAtPriority("FreecamKeyboardControlSpeed", Keypress, false, HighValue, Enum.KeyCode.Up, Enum.KeyCode.Down, Enum.KeyCode.Left, Enum.KeyCode.Right)
		ContextActionService:BindActionAtPriority("FreecamGamepadControlSpeed", GpButton, false, HighValue, Enum.KeyCode.DPadUp, Enum.KeyCode.DPadDown, Enum.KeyCode.DPadLeft, Enum.KeyCode.DPadRight)
	else
		ContextActionService:BindActionAtPriority("FreecamKeyboard", Keypress, false, HighValue, Enum.KeyCode.W, Enum.KeyCode.U, Enum.KeyCode.A, Enum.KeyCode.H, Enum.KeyCode.S, Enum.KeyCode.J, Enum.KeyCode.D, Enum.KeyCode.K, Enum.KeyCode.E, Enum.KeyCode.I, Enum.KeyCode.Q, Enum.KeyCode.Y, Enum.KeyCode.Up, Enum.KeyCode.Down)
	end

	if u40 then
		ContextActionService:BindActionAtPriority("FreecamKeyboardTiltControl", Keypress, false, HighValue, Enum.KeyCode.Z, Enum.KeyCode.C)
		ContextActionService:BindActionAtPriority("FreecamGamepadTiltControl", GpButton, false, HighValue, Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1)
		ContextActionService:BindActionAtPriority("FreecamKeyboardTiltControlSpeed", Keypress, false, HighValue, Enum.KeyCode.Comma, Enum.KeyCode.Period)

		if u43 then
			ContextActionService:BindActionAtPriority("FreecamKeyboardSmoothnessControl", Keypress, false, HighValue, Enum.KeyCode.LeftBracket, Enum.KeyCode.RightBracket, Enum.KeyCode.Semicolon, Enum.KeyCode.Quote, Enum.KeyCode.V, Enum.KeyCode.B, Enum.KeyCode.N, Enum.KeyCode.M)
		end
	end

	if u49 then
		ContextActionService:BindActionAtPriority("FreecamKeyboardDoFToggle", Keypress, false, HighValue, Enum.KeyCode.BackSlash)
		ContextActionService:BindActionAtPriority("FreecamKeyboardDoFControls", Keypress, false, HighValue, Enum.KeyCode.Minus, Enum.KeyCode.Equals)
	end

	if u52 then
		ContextActionService:BindActionAtPriority("FreecamKeyboardPlayerLockToggle", Keypress, false, HighValue, Enum.KeyCode.Slash)
		ContextActionService:BindActionAtPriority("FreecamKeyboardPlayerLockSwitch", Keypress, false, HighValue, Enum.KeyCode.R, Enum.KeyCode.T)
	end

	if u58 then
		ContextActionService:BindActionAtPriority("FreecamKeyboardCustomGuiToggle", Keypress, false, HighValue, Enum.KeyCode.G)
		ContextActionService:BindActionAtPriority("FreecamKeyboardPlayerGuiToggle", Keypress, false, HighValue, Enum.KeyCode.X)
		ContextActionService:BindActionAtPriority("FreecamKeyboardLeaderboardToggle", Keypress, false, HighValue, Enum.KeyCode.L)
	end

	ContextActionService:BindActionAtPriority("FreecamMousePan", MousePan, false, HighValue, Enum.UserInputType.MouseMovement)
	ContextActionService:BindActionAtPriority("FreecamMouseWheel", MouseWheel, false, HighValue, Enum.UserInputType.MouseWheel)
	ContextActionService:BindActionAtPriority("FreecamGamepadButton", GpButton, false, HighValue, Enum.KeyCode.ButtonX, Enum.KeyCode.ButtonY)
	ContextActionService:BindActionAtPriority("FreecamGamepadTrigger", Trigger, false, HighValue, Enum.KeyCode.ButtonR2, Enum.KeyCode.ButtonL2)
	ContextActionService:BindActionAtPriority("FreecamGamepadThumbstick", Thumb, false, HighValue, Enum.KeyCode.Thumbstick1, Enum.KeyCode.Thumbstick2)
end
function t14.StopCapture() -- line: 860
	-- upvalues: u58 (ref), n10 (ref), u37 (ref), n12 (ref), u40 (ref), n11 (ref), t15 (copy), t16 (copy), t17 (copy), ContextActionService (copy), u43 (ref), u49 (ref), u52 (ref)
	if not u58 then
		n10 = 1

		if u37 then
			n12 = 1
		end

		if u40 then
			n11 = 1
		end
	end

	local v257 = t15

	for k, v in pairs(v257) do
		v257[k] = v * 0
	end

	local v260 = t16

	for k, v in pairs(v260) do
		v260[k] = v * 0
	end

	local v263 = t17

	for k, v in pairs(v263) do
		v263[k] = v * 0
	end

	ContextActionService:UnbindAction("FreecamKeyboard")

	if u37 then
		ContextActionService:UnbindAction("FreecamKeyboardControlSpeed")
		ContextActionService:UnbindAction("FreecamGamepadControlSpeed")
	end

	if u40 then
		ContextActionService:UnbindAction("FreecamKeyboardTiltControl")
		ContextActionService:UnbindAction("FreecamGamepadTiltControl")
		ContextActionService:UnbindAction("FreecamKeyboardTiltControlSpeed")

		if u43 then
			ContextActionService:UnbindAction("FreecamKeyboardSmoothnessControl")
		end
	end

	if u49 then
		ContextActionService:UnbindAction("FreecamKeyboardDoFToggle")
		ContextActionService:UnbindAction("FreecamKeyboardDoFControls")
	end

	if u52 then
		ContextActionService:UnbindAction("FreecamKeyboardPlayerLockToggle")
		ContextActionService:UnbindAction("FreecamKeyboardPlayerLockSwitch")
	end

	if u58 then
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
function t14.getNavSpeed() -- line: 906
	-- upvalues: n10 (ref)
	return n10
end
function t14.getFovSpeed() -- line: 910
	-- upvalues: n12 (ref)
	return n12
end
function t14.getRollSpeed() -- line: 914
	-- upvalues: n11 (ref)
	return n11
end

local function StepFreecam(p42) -- line: 922
	-- upvalues: u43 (ref), t14 (copy), u49 (ref), DepthOfFieldEffect (ref), v95 (copy), v96 (copy), v97 (copy), u40 (ref), v98 (copy), n9 (ref), rad (copy), tan (copy), sqrt (copy), clamp (copy), v70 (copy), u93 (ref), vector3 (ref), u52 (ref), u83 (ref), u88 (ref), n6 (ref), n7 (ref), u58 (ref), TextLabel (ref), Freecam (ref), n1 (ref), n2 (ref), n3 (ref), n4 (ref), u37 (ref), t12 (ref), n8 (ref), CurrentCamera (ref)
	if u43 then
		t14.SpringControl(p42)
	end

	if u49 and DepthOfFieldEffect and DepthOfFieldEffect.Parent then
		t14.DoF(p42)
	end

	local v267 = v95:Update(p42, t14.Vel(p42))
	local v268 = v96:Update(p42, t14.Pan(p42))
	local v269 = v97:Update(p42, t14.Fov(p42))
	local v270 = nil

	if u40 then
		v270 = v98:Update(p42, t14.Roll(p42))
	end

	local v271 = sqrt(0.7002075382097097 / tan((rad(n9 / 2))))

	n9 = clamp(n9 + v269 * 300 * (p42 / v271), 1, 120)

	local v273

	if u40 then
		local v272 = v268 * v70 * (p42 / v271)

		u93 += Vector3.new(v272.X, v272.Y, v270 * -1.5707963267948966 * (p42 / v271))

		if u43 then
			u93 = Vector3.new(u93.x % 6.283185307179586, u93.y % 6.283185307179586, u93.z % 6.283185307179586)
		else
			u93 = Vector3.new(clamp(u93.x, -1.5707963267948966, 1.5707963267948966), u93.y % 6.283185307179586, u93.z)
		end

		v273 = CFrame.new(vector3) * CFrame.fromOrientation(u93.x, u93.y, u93.z) * CFrame.new(v267 * Vector3.new(64, 64, 64) * p42)
	else
		u93 += v268 * v70 * (p42 / v271)
		u93 = Vector2.new(clamp(u93.x, -1.5707963267948966, 1.5707963267948966), u93.y % 6.283185307179586)
		v273 = CFrame.new(vector3) * CFrame.fromOrientation(u93.x, u93.y, 0) * CFrame.new(v267 * Vector3.new(64, 64, 64) * p42)
	end

	if u52 and u83 and u88 then
		local v274 = v267.Z * 64 * p42
		local v275 = v267.Y * 64 * p42

		n6 = clamp(n6 + v274, 5, 50)
		n7 = clamp(n7 + v275, -10, 10)
		v273 = CFrame.new(u88.Position + Vector3.new(0, n7, 0)) * (if not u40 then CFrame.fromOrientation(u93.x, u93.y, 0) else CFrame.fromOrientation(u93.x, u93.y, u93.z)) * CFrame.new(0, 0, n6)
	end

	if u58 and TextLabel and TextLabel.Parent and Freecam and Freecam.Parent and Freecam.Enabled then
		local s1 = ""

		if p42 > 0 then
			local v277 = (v273.p - vector3) / p42

			s1 ..= string.format("Velocity: (%.1f, %.1f, %.1f)\n", v277.X, v277.Y, v277.Z)
		end

		local v278 = s1 .. string.format("FOV: %.1f\n", n9)

		if u40 then
			v278 ..= string.format("Tilt: %.1f°\n", (math.deg(u93.z)))
		end

		if u43 then
			v278 = (((v278 .. string.format("Stiffness (Vel): %.1f\n", n1)) .. string.format("Stiffness (Pan): %.1f\n", n2)) .. string.format("Stiffness (FOV): %.1f\n", n3)) .. string.format("Stiffness (Roll): %.1f\n", n4)
		end

		if u37 then
			v278 = ((v278 .. string.format("Movement Speed: %.1f\n", t14.getNavSpeed())) .. string.format("Zoom Speed: %.1f\n", t14.getFovSpeed())) .. string.format("Tilt Speed: %.1f\n", t14.getRollSpeed())
		end

		if u49 then
			v278 = if not DepthOfFieldEffect or (not DepthOfFieldEffect.Parent or not DepthOfFieldEffect.Enabled) then v278 .. string.format("Custom Depth Of Field: Off\n") else ((((v278 .. string.format("Custom Depth Of Field: On\n")) .. string.format("Custom Depth Of Field Near Intensity: %.1f\n", DepthOfFieldEffect.NearIntensity)) .. string.format("Custom Depth Of Field Far Intensity: %.1f\n", DepthOfFieldEffect.FarIntensity)) .. string.format("Custom Depth Of Field Focus Distance: %.1f\n", DepthOfFieldEffect.FocusDistance)) .. string.format("Custom Depth Of Field Focus Radius: %.1f\n", DepthOfFieldEffect.InFocusRadius)
		end

		if u52 then
			v278 = if not u83 or not (#t12 > 0) then v278 .. string.format("Player Lock: Off\n") else v278 .. string.format("Player Lock: %s\n", t12[n8].Name)
		end

		TextLabel.Text = v278
	end

	vector3 = v273.p
	CurrentCamera.CFrame = v273
	CurrentCamera.Focus = v273
	CurrentCamera.FieldOfView = n9
end
local function CheckMouseLockAvailability() -- line: 1038
	-- upvalues: Players (copy), GameSettings (copy)
	local DevEnableMouseLock = Players.LocalPlayer.DevEnableMouseLock
	local v280 = Players.LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.Scriptable
	local v281 = GameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch
	local v282 = GameSettings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove

	return DevEnableMouseLock and (v281 and (not v282 and not v280))
end

t19 = {}

local Default = nil
local MouseIconEnabled = nil
local CameraType = nil
local Focus = nil
local CurrentCameraCFrame = nil
local FieldOfView = nil
local t20 = {}
local t21 = {
	Backpack = true,
	Chat = true,
	Health = true,
	PlayerList = true
}
local t22 = {
	BadgesNotificationsActive = true,
	PointsNotificationsActive = true
}

function t19.Push() -- line: 1071
	-- upvalues: t21 (copy), StarterGui (copy), t22 (copy), LocalPlayer (ref), t20 (ref), u34 (ref), connection (ref), u58 (ref), u89 (ref), FieldOfView (ref), CurrentCamera (ref), CameraType (ref), CurrentCameraCFrame (ref), Focus (ref), MouseIconEnabled (ref), UserInputService (copy), u25 (ref), Players (copy), GameSettings (copy), Default (ref)
	local g288 = nil
	local DevEnableMouseLock = nil
	local v291 = nil
	local v292 = nil
	local v290 = nil

	for k in pairs(t21) do
		t21[k] = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType[k])
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType[k], false)
	end

	for k in pairs(t22) do
		t22[k] = StarterGui:GetCore(k)
		StarterGui:SetCore(k, false)
	end

	local PlayerGui2 = LocalPlayer:FindFirstChildOfClass("PlayerGui")

	if PlayerGui2 then
		for _, child in pairs(PlayerGui2:GetChildren()) do
			if child:IsA("ScreenGui") and child.Enabled then
				t20[#t20 + 1] = child
				child.Enabled = false
			end
		end

		if u34 then
			connection = PlayerGui2.ChildAdded:Connect(function(child) -- line: 1089
				-- upvalues: t20 (ref), u58 (ref), u89 (ref)
				if child:IsA("ScreenGui") and child.Enabled then
					t20[#t20 + 1] = child

					if u58 then
						child.Enabled = u89

						return
					end

					child.Enabled = false
				end
			end)
		end
	end

	FieldOfView = CurrentCamera.FieldOfView
	CurrentCamera.FieldOfView = 70
	CameraType = CurrentCamera.CameraType
	CurrentCamera.CameraType = Enum.CameraType.Custom
	CurrentCameraCFrame = CurrentCamera.CFrame
	Focus = CurrentCamera.Focus
	MouseIconEnabled = UserInputService.MouseIconEnabled
	UserInputService.MouseIconEnabled = false

	repeat
		if g288 or u25 then
			if not g288 then
				DevEnableMouseLock = Players.LocalPlayer.DevEnableMouseLock
				v290 = Players.LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.Scriptable
				v291 = GameSettings.ControlMode == Enum.ControlMode.MouseLockSwitch
				v292 = GameSettings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove
			end

			if g288 or DevEnableMouseLock and (v291 and (not v292 and not v290)) then
				if not g288 then
					Default = Enum.MouseBehavior.Default
				end

				g288 = false
				UserInputService.MouseBehavior = Enum.MouseBehavior.Default

				return
			end
		end

		Default = UserInputService.MouseBehavior
		g288 = true
	until not g288
end
function t19.Pop() -- line: 1123
	-- upvalues: t21 (copy), StarterGui (copy), t22 (copy), t20 (ref), u58 (ref), Freecam (ref), u34 (ref), connection (ref), CurrentCamera (ref), FieldOfView (ref), CameraType (ref), CurrentCameraCFrame (ref), Focus (ref), UserInputService (copy), MouseIconEnabled (ref), Default (ref)
	for k, v in pairs(t21) do
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType[k], v)
	end

	for k, v in pairs(t22) do
		StarterGui:SetCore(k, v)
	end

	for _, v in pairs(t20) do
		if u58 then
			if v.Parent and v ~= Freecam then
				v.Enabled = true
			end
		elseif v.Parent then
			v.Enabled = true
		end
	end

	if u34 then
		if connection then
			connection:Disconnect()
			connection = nil
		end

		t20 = {}
	end

	CurrentCamera.FieldOfView = FieldOfView
	FieldOfView = nil
	CurrentCamera.CameraType = CameraType
	CameraType = nil
	CurrentCamera.CFrame = CurrentCameraCFrame
	CurrentCameraCFrame = nil
	CurrentCamera.Focus = Focus
	Focus = nil
	UserInputService.MouseIconEnabled = MouseIconEnabled
	MouseIconEnabled = nil
	UserInputService.MouseBehavior = Default
	Default = nil
end
function t19.getScreenGuis() -- line: 1169
	-- upvalues: t20 (ref)
	return t20
end

local function removePlayerFromList(p43) -- line: 1174
	-- upvalues: t12 (ref), n8 (ref), u83 (ref)
	for i, v in ipairs(t12) do
		if v == p43 then
			table.remove(t12, i)

			if i == n8 and u83 then
				u83 = false
				n8 = 1
			end

			if i < n8 then
				n8 -= 1
			end

			if not (n8 > #t12) and not (n8 < 1) then
				return
			end

			n8 = 1

			return
		end
	end
end
local function initializePlayerList() -- line: 1198
	-- upvalues: t12 (ref), Players (copy), LocalPlayer (ref), n8 (ref), connection4 (ref), connection5 (ref), removePlayerFromList (copy)
	t12 = Players:GetPlayers()

	for i, v in ipairs(t12) do
		if v == LocalPlayer then
			n8 = i

			break
		end
	end

	connection4 = Players.PlayerAdded:Connect(function(player) -- line: 1208
		-- upvalues: t12 (ref)
		table.insert(t12, player)
	end)
	connection5 = Players.PlayerRemoving:Connect(removePlayerFromList)
end
local function StartFreecam() -- line: 1215
	-- upvalues: u52 (ref), initializePlayerList (copy), u46 (ref), u28 (ref), CurrentCamera (ref), u40 (ref), u93 (ref), vector3 (ref), n9 (ref), v95 (copy), v96 (copy), v97 (copy), v98 (copy), u58 (ref), u43 (ref), n1 (ref), n2 (ref), n3 (ref), n4 (ref), PlayerGui (ref), LocalPlayer (ref), Freecam (ref), TextLabel (ref), t19 (ref), u49 (ref), DepthOfFieldEffect (ref), RunService (copy), StepFreecam (copy), t14 (copy)
	if u52 then
		initializePlayerList()
	end

	if not u46 and u28 then
		script:SetAttribute("FreecamEnabled", true)
	end

	local CurrentCameraCFrame2 = CurrentCamera.CFrame

	if u40 then
		u93 = Vector3.new(CurrentCameraCFrame2:toEulerAnglesYXZ())
	else
		u93 = Vector2.new(CurrentCameraCFrame2:toEulerAnglesYXZ())
	end

	vector3 = CurrentCameraCFrame2.p
	n9 = CurrentCamera.FieldOfView
	v95:Reset((Vector3.new()))
	v96:Reset(Vector2.new())
	v97:Reset(0)

	if u40 then
		v98:Reset(0)
	end

	if not u58 and u43 then
		n1 = 1.5
		n2 = 1
		n3 = 4
		n4 = 1
	end

	if u58 then
		PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
		Freecam = PlayerGui:WaitForChild("Freecam")

		if not TextLabel or not TextLabel.Parent then
			TextLabel = Instance.new("TextLabel")
			TextLabel.Name = "FreecamCustomGui"
			TextLabel.TextColor3 = Color3.new(1, 1, 1)
			TextLabel.Font = Enum.Font.SourceSansBold
			TextLabel.TextSize = 20
			TextLabel.TextStrokeTransparency = 0
			TextLabel.BackgroundTransparency = 1
			TextLabel.TextWrapped = true
			TextLabel.TextXAlignment = Enum.TextXAlignment.Right
			TextLabel.AutomaticSize = Enum.AutomaticSize.Y
			TextLabel.AnchorPoint = Vector2.new(1, 1)
			TextLabel.Position = UDim2.new(1, -10, 1, -10)
			TextLabel.Size = UDim2.new(0, 400, 0, 0)
			TextLabel.Parent = Freecam
		end
	end

	t19.Push()

	if u49 and (not DepthOfFieldEffect or not DepthOfFieldEffect.Parent) then
		DepthOfFieldEffect = Instance.new("DepthOfFieldEffect")
		DepthOfFieldEffect.Enabled = false
		DepthOfFieldEffect.Name = "FreecamDepthOfField"
		DepthOfFieldEffect.Parent = CurrentCamera
	end

	RunService:BindToRenderStep("Freecam", Enum.RenderPriority.Camera.Value, StepFreecam)
	t14.StartCapture()
end
local function StopFreecam() -- line: 1287
	-- upvalues: u46 (ref), u28 (ref), u52 (ref), connection4 (ref), connection5 (ref), u83 (ref), n8 (ref), t12 (ref), u49 (ref), DepthOfFieldEffect (ref), t11 (ref), connection2 (ref), connection3 (ref), u58 (ref), Freecam (ref), u89 (ref), u90 (ref), t14 (copy), RunService (copy), t19 (ref)
	if not u46 and u28 then
		script:SetAttribute("FreecamEnabled", false)
	end

	if u52 then
		if connection4 then
			connection4:Disconnect()
			connection4 = nil
		end

		if connection5 then
			connection5:Disconnect()
			connection5 = nil
		end

		u83 = false
		n8 = 1
		t12 = {}
	end

	if u49 and DepthOfFieldEffect and DepthOfFieldEffect.Parent then
		if DepthOfFieldEffect.Enabled then
			for _, v in ipairs(t11) do
				if v.Parent then
					v.Enabled = true
				end
			end

			if connection2 then
				connection2:Disconnect()
				connection2 = nil
			end

			if connection3 then
				connection3:Disconnect()
				connection3 = nil
			end

			t11 = {}
		end

		DepthOfFieldEffect.Enabled = false
	end

	if u58 then
		if Freecam and Freecam.Parent then
			Freecam.Enabled = false
		end

		u89 = false
		u90 = false
	end

	t14.StopCapture()
	RunService:UnbindFromRenderStep("Freecam")
	t19.Pop()
end

local u138 = false

local function ToggleFreecam() -- line: 1348
	-- upvalues: u138 (ref), StopFreecam (copy), StartFreecam (copy), u46 (ref)
	if u138 then
		StopFreecam()
	else
		StartFreecam()
	end

	u138 = not u138

	if u46 then
		script:SetAttribute("FreecamEnabled", u138)
	end
end
local function CheckMacro(p44) -- line: 1360
	-- upvalues: UserInputService (copy), u138 (ref), StopFreecam (copy), StartFreecam (copy), u46 (ref)
	for i = 1, #p44 - 1 do
		if not UserInputService:IsKeyDown(p44[i]) then
			return
		end
	end

	if u138 then
		StopFreecam()
	else
		StartFreecam()
	end

	u138 = not u138

	if u46 then
		script:SetAttribute("FreecamEnabled", u138)
	end
end
local function HandleActivationInput(_, p46, p47) -- line: 1369
	-- upvalues: t1 (copy), CheckMacro (copy)
	if p46 == Enum.UserInputState.Begin and p47.KeyCode == t1[#t1] then
		CheckMacro(t1)
	end

	return Enum.ContextActionResult.Pass
end

ContextActionService:BindActionAtPriority("FreecamToggle", HandleActivationInput, false, LowValue, t1[#t1])

if u46 or u28 then
	script:SetAttribute("FreecamEnabled", u138)
	script:GetAttributeChangedSignal("FreecamEnabled"):Connect(function() -- line: 1382
		-- upvalues: u138 (ref), StartFreecam (copy), StopFreecam (copy)
		local FreecamEnabled = script:GetAttribute("FreecamEnabled")

		if typeof(FreecamEnabled) ~= "boolean" then
			script:SetAttribute("FreecamEnabled", u138)

			return
		end

		if FreecamEnabled ~= u138 then
			if FreecamEnabled then
				StartFreecam()
				u138 = true

				return
			end

			StopFreecam()
			u138 = false
		end
	end)
end

return {}
