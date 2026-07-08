local clamp = math.clamp
local exp = math.exp
local rad = math.rad
local sqrt = math.sqrt
local tan = math.tan
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local t1 = {
	AttributeName = "FreecamEnabled",
	Thumbstick = {
		Curvature = 2
	},
	DoubleTap = {
		Threshold = 0.25,
		Debounce = 0.1
	},
	PlayerLock = {
		DefaultZoom = 20,
		MinZoom = 5,
		MaxZoom = 50,
		DefaultHeight = 0,
		HeightRange = 10
	},
	Movement = {
		Gain = Vector3.new(64, 64, 64),
		AdjSpeed = 0.75,
		MinSpeed = 0.01,
		MaxSpeed = 4,
		ShiftMul = 0.25,
		Stiffness = 1.5,
		AdjStiffness = 0.75,
		MinStiffness = 0.01,
		MaxStiffness = 10
	},
	Pan = {
		AdjSpeed = 0.75,
		MinSpeed = 0.01,
		MaxSpeed = 4,
		Stiffness = 1,
		AdjStiffness = 0.75,
		MinStiffness = 0.01,
		MaxStiffness = 10,
		Gain = Vector2.new(0.75, 1) * 8,
		MouseScale = Vector2.new(0.0008181230868723419, -0.0008181230868723419),
		TrackpadScale = Vector2.new(0.011453723216212788, -0.011453723216212788),
		GamepadScale = Vector2.new(0.39269908169872414, 0.39269908169872414)
	},
	Fov = {
		Gain = 300,
		WheelScale = -0.01667,
		PinchScale = -0.008,
		GamepadScale = 0.25,
		AdjSpeed = 0.75,
		MinSpeed = 0.01,
		MaxSpeed = 4,
		Stiffness = 4,
		AdjStiffness = 0.75,
		MinStiffness = 0.01,
		MaxStiffness = 10
	},
	Roll = {
		Gain = -1.5707963267948966,
		AdjSpeed = 0.75,
		MinSpeed = 0.01,
		MaxSpeed = 4,
		Stiffness = 1,
		AdjStiffness = 0.75,
		MinStiffness = 0.01,
		MaxStiffness = 10
	},
	DoF = {
		FarIntensity = {
			Adj = 0.1,
			Min = 0,
			Max = 1
		},
		NearIntensity = {
			Adj = 0.1,
			Min = 0,
			Max = 1
		},
		FocusDistance = {
			Adj = 20,
			Min = 0,
			Max = 200
		},
		FocusRadius = {
			Adj = 5,
			Min = 0,
			Max = 50
		}
	},
	Bloom = {
		Intensity = {
			Adj = 0.05,
			Min = 0,
			Max = 1
		},
		Size = {
			Adj = 2,
			Min = 0,
			Max = 56
		},
		Threshold = {
			Adj = 0.05,
			Min = 0,
			Max = 1
		}
	},
	Blur = {
		Size = {
			Adj = 2,
			Min = 0,
			Max = 56
		}
	},
	ColorCorrection = {
		Brightness = {
			Adj = 0.05,
			Min = -1,
			Max = 1
		},
		Contrast = {
			Adj = 0.05,
			Min = -1,
			Max = 1
		},
		Saturation = {
			Adj = 0.05,
			Min = -1,
			Max = 1
		}
	},
	SunRays = {
		Intensity = {
			Adj = 0.05,
			Min = 0,
			Max = 1
		},
		Spread = {
			Adj = 0.05,
			Min = 0,
			Max = 1
		}
	},
	Keys = {
		Toggle = {
			Keyboard = Enum.KeyCode.P,
			Modifier = Enum.KeyCode.LeftShift
		},
		Pan = {
			Mouse = Enum.KeyCode.MouseDelta,
			Trackpad = Enum.KeyCode.TrackpadPan,
			Gamepad = Enum.KeyCode.Thumbstick2
		},
		MovementMove = {
			Keyboard = {
				Up = Enum.KeyCode.W,
				Down = Enum.KeyCode.S,
				Left = Enum.KeyCode.A,
				Right = Enum.KeyCode.D
			},
			Gamepad = Enum.KeyCode.Thumbstick1
		},
		MovementElevate = {
			Keyboard = {
				Up = Enum.KeyCode.E,
				Down = Enum.KeyCode.Q
			},
			Gamepad = {
				Up = Enum.KeyCode.ButtonR2,
				Down = Enum.KeyCode.ButtonL2
			}
		},
		ModeSelect = {
			Toggle = {
				Keyboard = Enum.KeyCode.Up,
				Gamepad = Enum.KeyCode.DPadUp
			},
			Next = {
				Keyboard = Enum.KeyCode.Down,
				Gamepad = Enum.KeyCode.DPadDown
			},
			Axis = {
				Up = {
					Keyboard = Enum.KeyCode.Right,
					Gamepad = Enum.KeyCode.DPadRight
				},
				Down = {
					Keyboard = Enum.KeyCode.Left,
					Gamepad = Enum.KeyCode.DPadLeft
				}
			}
		},
		Fov = {
			Mouse = Enum.KeyCode.MouseWheel,
			TrackpadPinch = Enum.KeyCode.TrackpadPinch,
			Gamepad = {
				Up = Enum.KeyCode.ButtonX,
				Down = Enum.KeyCode.ButtonY
			}
		},
		Tilt = {
			Keyboard = {
				Up = Enum.KeyCode.C,
				Down = Enum.KeyCode.Z
			},
			Gamepad = {
				Up = Enum.KeyCode.ButtonR1,
				Down = Enum.KeyCode.ButtonL1
			}
		},
		Shift = {
			KeyboardPrimary = Enum.KeyCode.LeftShift,
			KeyboardSecondary = Enum.KeyCode.RightShift
		}
	}
}

t1.Actions = {
	Toggle = {
		name = "FreecamToggleAction",
		type = Enum.InputActionType.Bool,
		bindings = {{
			keyCode = t1.Keys.Toggle.Keyboard,
			primaryModifier = t1.Keys.Toggle.Modifier
		}}
	},
	Pan = {
		name = "PanAction",
		type = Enum.InputActionType.Direction2D,
		bindings = {
			{
				keyCode = t1.Keys.Pan.Mouse,
				vector2Scale = t1.Pan.MouseScale
			},
			{
				keyCode = t1.Keys.Pan.Trackpad,
				vector2Scale = t1.Pan.TrackpadScale
			},
			{
				keyCode = t1.Keys.Pan.Gamepad,
				responseCurve = t1.Thumbstick.Curvature,
				vector2Scale = t1.Pan.GamepadScale
			}
		}
	},
	MovementMove = {
		name = "MovementMoveAction",
		type = Enum.InputActionType.Direction2D,
		bindings = {
			{
				up = t1.Keys.MovementMove.Keyboard.Up,
				down = t1.Keys.MovementMove.Keyboard.Down,
				left = t1.Keys.MovementMove.Keyboard.Left,
				right = t1.Keys.MovementMove.Keyboard.Right
			},
			{
				keyCode = t1.Keys.MovementMove.Gamepad,
				responseCurve = t1.Thumbstick.Curvature
			}
		}
	},
	MovementElevate = {
		name = "MovementElevateAction",
		type = Enum.InputActionType.Direction1D,
		bindings = {
			{
				up = t1.Keys.MovementElevate.Keyboard.Up,
				down = t1.Keys.MovementElevate.Keyboard.Down
			},
			{
				up = t1.Keys.MovementElevate.Gamepad.Up,
				down = t1.Keys.MovementElevate.Gamepad.Down
			}
		}
	},
	Fov = {
		name = "FovAction",
		type = Enum.InputActionType.Direction1D,
		bindings = {
			{
				keyCode = t1.Keys.Fov.Mouse,
				scale = t1.Fov.WheelScale
			},
			{
				keyCode = t1.Keys.Fov.TrackpadPinch,
				scale = t1.Fov.PinchScale
			},
			{
				up = t1.Keys.Fov.Gamepad.Up,
				down = t1.Keys.Fov.Gamepad.Down,
				scale = t1.Fov.GamepadScale
			}
		}
	},
	Tilt = {
		name = "TiltAction",
		type = Enum.InputActionType.Direction1D,
		bindings = {
			{
				up = t1.Keys.Tilt.Keyboard.Up,
				down = t1.Keys.Tilt.Keyboard.Down
			},
			{
				up = t1.Keys.Tilt.Gamepad.Up,
				down = t1.Keys.Tilt.Gamepad.Down
			}
		}
	},
	Shift = {
		name = "ShiftAction",
		type = Enum.InputActionType.Bool,
		bindings = {
			{
				keyCode = t1.Keys.Shift.KeyboardPrimary
			},
			{
				keyCode = t1.Keys.Shift.KeyboardSecondary
			}
		}
	},
	ModeToggle = {
		name = "ModeToggleAction",
		type = Enum.InputActionType.Bool,
		bindings = {
			{
				keyCode = t1.Keys.ModeSelect.Toggle.Keyboard
			},
			{
				keyCode = t1.Keys.ModeSelect.Toggle.Gamepad
			}
		}
	},
	ModeNext = {
		name = "ModeNextAction",
		type = Enum.InputActionType.Bool,
		bindings = {
			{
				keyCode = t1.Keys.ModeSelect.Next.Keyboard
			},
			{
				keyCode = t1.Keys.ModeSelect.Next.Gamepad
			}
		}
	},
	ModeAxis = {
		name = "ModeAxisAction",
		type = Enum.InputActionType.Direction1D,
		bindings = {
			{
				up = t1.Keys.ModeSelect.Axis.Up.Keyboard,
				down = t1.Keys.ModeSelect.Axis.Down.Keyboard
			},
			{
				up = t1.Keys.ModeSelect.Axis.Up.Gamepad,
				down = t1.Keys.ModeSelect.Axis.Down.Gamepad
			}
		}
	}
}

local LocalPlayer = Players.LocalPlayer

if not LocalPlayer then
	Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
	LocalPlayer = Players.LocalPlayer
end

local Freecam = nil
local CurrentCamera = Workspace.CurrentCamera

Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- line: 267
	-- upvalues: Workspace (copy), CurrentCamera (ref)
	local CurrentCamera2 = Workspace.CurrentCamera

	if CurrentCamera2 then
		CurrentCamera = CurrentCamera2
	end
end)

local u16 = nil
local u17 = nil
local u18 = nil
local u19 = nil
local u20 = nil
local u21 = nil
local t2 = {
	DepthOfField = {
		Enabled = false,
		FarIntensity = 0.75,
		NearIntensity = 0.75,
		FocusDistance = 0.05,
		InFocusRadius = 10
	},
	Bloom = {
		Enabled = false,
		Intensity = 0.4,
		Size = 24,
		Threshold = 0.95
	},
	Blur = {
		Enabled = false,
		Size = 24
	},
	ColorCorrection = {
		Enabled = false,
		Brightness = 0,
		Contrast = 0,
		Saturation = 0,
		TintColor = Color3.new(1, 1, 1)
	},
	SunRays = {
		Enabled = false,
		Intensity = 0.25,
		Spread = 1
	},
	ColorGrading = {
		Enabled = false,
		TonemapperPreset = Enum.TonemapperPreset.Default
	}
}
local u23 = nil
local t22 = nil
local t18 = nil
local ok, result = pcall(function() -- line: 296
	return UserSettings():IsUserFeatureEnabled("UserShowGuiHideToggles")
end)
local u28 = ok and result

local function makeEffectOverride(p1, p2) -- line: 304
	-- upvalues: CurrentCamera (ref), Lighting (copy)
	local t3 = {}
	local u111 = nil
	local u112 = nil

	local function disable() -- line: 308
		-- upvalues: t3 (ref), u111 (ref), u112 (ref)
		for _, v in ipairs(t3) do
			if v.Parent then
				v.Enabled = true
			end
		end

		if u111 then
			u111:Disconnect()
			u111 = nil
		end

		if u112 then
			u112:Disconnect()
			u112 = nil
		end

		t3 = {}
	end
	local function trySuppress(p3) -- line: 317
		-- upvalues: p1 (copy), p2 (copy), t3 (ref)
		if p3:IsA(p1) and p3.Enabled and (not p2 or not p2(p3)) then
			t3[#t3 + 1] = p3
			p3.Enabled = false
		end
	end
	local function enable() -- line: 324
		-- upvalues: t3 (ref), CurrentCamera (ref), p1 (copy), p2 (copy), Lighting (copy), u111 (ref), u112 (ref)
		t3 = {}

		for _, child in ipairs(CurrentCamera:GetChildren()) do
			if child:IsA(p1) and child.Enabled and (not p2 or not p2(child)) then
				t3[#t3 + 1] = child
				child.Enabled = false
			end
		end

		for _, child in ipairs(Lighting:GetChildren()) do
			if child:IsA(p1) and child.Enabled and (not p2 or not p2(child)) then
				t3[#t3 + 1] = child
				child.Enabled = false
			end
		end

		u111 = CurrentCamera.ChildAdded:Connect(function(child) -- line: 328
			-- upvalues: p1 (copy), p2 (copy), t3 (ref)
			if child:IsA(p1) and child.Enabled and (not p2 or not p2(child)) then
				t3[#t3 + 1] = child
				child.Enabled = false
			end
		end)
		u112 = Lighting.ChildAdded:Connect(function(child) -- line: 329
			-- upvalues: p1 (copy), p2 (copy), t3 (ref)
			if child:IsA(p1) and child.Enabled and (not p2 or not p2(child)) then
				t3[#t3 + 1] = child
				child.Enabled = false
			end
		end)
	end

	return enable, disable
end

local u30 = false
local v31, v32 = makeEffectOverride("PostEffect", function(p4) -- line: 337
	return p4.Name:sub(1, 7) == "Freecam"
end)
local t4 = nil

local function doToggleMasterEffects() -- line: 343
	-- upvalues: u30 (ref), v31 (copy), v32 (copy), t4 (ref)
	u30 = not u30

	if u30 then
		v31()

		return
	end

	v32()

	for _, v in ipairs(t4) do
		local v119 = v.get()

		if v119 then
			v119.Enabled = false
		end
	end
end
local function doToggleDoF() -- line: 356
	-- upvalues: u16 (ref)
	local v120 = u16

	if v120 then
		v120.Enabled = not v120.Enabled
	end
end
local function doToggleBloom() -- line: 357
	-- upvalues: u17 (ref)
	local v121 = u17

	if v121 then
		v121.Enabled = not v121.Enabled
	end
end
local function doToggleBlur() -- line: 358
	-- upvalues: u18 (ref)
	local v122 = u18

	if v122 then
		v122.Enabled = not v122.Enabled
	end
end
local function doToggleColorCorrection() -- line: 359
	-- upvalues: u19 (ref)
	local v123 = u19

	if v123 then
		v123.Enabled = not v123.Enabled
	end
end
local function doToggleSunRays() -- line: 360
	-- upvalues: u20 (ref)
	local v124 = u20

	if v124 then
		v124.Enabled = not v124.Enabled
	end
end
local function doToggleColorGrading() -- line: 361
	-- upvalues: u21 (ref)
	local v125 = u21

	if v125 then
		v125.Enabled = not v125.Enabled
	end
end

t4 = {
	{
		key = "DepthOfField",
		class = "DepthOfFieldEffect",
		get = function() -- line: 365
			-- upvalues: u16 (ref)
			return u16
		end,
		set = function(p5) -- line: 366
			-- upvalues: u16 (ref)
			u16 = p5
		end,
		props = {
			"FarIntensity",
			"NearIntensity",
			"FocusDistance",
			"InFocusRadius"
		}
	},
	{
		key = "Bloom",
		class = "BloomEffect",
		get = function() -- line: 369
			-- upvalues: u17 (ref)
			return u17
		end,
		set = function(p6) -- line: 370
			-- upvalues: u17 (ref)
			u17 = p6
		end,
		props = {
			"Intensity",
			"Size",
			"Threshold"
		}
	},
	{
		key = "Blur",
		class = "BlurEffect",
		get = function() -- line: 373
			-- upvalues: u18 (ref)
			return u18
		end,
		set = function(p7) -- line: 374
			-- upvalues: u18 (ref)
			u18 = p7
		end,
		props = { "Size" }
	},
	{
		key = "ColorCorrection",
		class = "ColorCorrectionEffect",
		get = function() -- line: 377
			-- upvalues: u19 (ref)
			return u19
		end,
		set = function(p8) -- line: 378
			-- upvalues: u19 (ref)
			u19 = p8
		end,
		props = {
			"Brightness",
			"Contrast",
			"Saturation",
			"TintColor"
		}
	},
	{
		key = "SunRays",
		class = "SunRaysEffect",
		get = function() -- line: 381
			-- upvalues: u20 (ref)
			return u20
		end,
		set = function(p9) -- line: 382
			-- upvalues: u20 (ref)
			u20 = p9
		end,
		props = {
			"Intensity",
			"Spread"
		}
	},
	{
		key = "ColorGrading",
		class = "ColorGradingEffect",
		get = function() -- line: 385
			-- upvalues: u21 (ref)
			return u21
		end,
		set = function(p10) -- line: 386
			-- upvalues: u21 (ref)
			u21 = p10
		end,
		props = { "TonemapperPreset" }
	}
}

local connection = nil
local connection2 = nil
local connection3 = nil
local u44 = false
local DefaultZoom = t1.PlayerLock.DefaultZoom
local DefaultHeight = t1.PlayerLock.DefaultHeight
local t5 = {}
local n1 = 1
local u49 = nil
local u50 = false
local u51 = false
local n2 = -1e999
local n3 = -1e999
local t6 = {
	movement = t1.Movement.Stiffness,
	pan = t1.Pan.Stiffness,
	fov = t1.Fov.Stiffness,
	roll = t1.Roll.Stiffness
}
local u55 = nil
local t7 = {}

t7.__index = t7

function t7.new(p11, p12) -- line: 422
	-- upvalues: t7 (copy)
	local self = setmetatable({}, t7)

	self.f = p11
	self.p = p12
	self.v = p12 * 0

	return self
end
function t7.Update(p13, p14, p15) -- line: 430
	-- upvalues: exp (copy)
	local v138 = p13.f * 2 * 3.141592653589793
	local p = p13.p
	local v = p13.v
	local v141 = p15 - p
	local v142 = exp(-v138 * p14)
	local v143 = p15 + (v * p14 - v141 * (v138 * p14 + 1)) * v142
	local v144 = (v138 * p14 * (v141 * v138 - v) + v) * v142

	p13.p = v143
	p13.v = v144

	return v143
end
function t7.SetFreq(p16, p17) -- line: 443
	p16.f = p17
end
function t7.Reset(p18, p19) -- line: 445
	p18.p = p19
	p18.v = p19 * 0
end

local vector3 = Vector3.new()
local vector3_2 = Vector3.new()
local n4 = 0
local v60 = t7.new(t6.movement, (Vector3.new()))
local v61 = t7.new(t6.pan, Vector2.new())
local v62 = t7.new(t6.fov, 0)
local v63 = t7.new(t6.roll, 0)
local t8 = {}
local t9 = {}
local t10 = {
	movement = 1,
	pan = 1,
	fov = 1,
	roll = 1
}
local u67 = false
local u68 = nil
local u69 = false
local n5 = 1
local t11 = {}
local u72 = false

local function findPlayerLockRootPart(p20) -- line: 483
	-- upvalues: t5 (ref), n1 (ref), u44 (ref)
	if not t5 or #t5 < 1 then
		return nil
	end

	for _ = 1, #t5 do
		n1 = (n1 - 1 + p20) % #t5 + 1

		local v151 = t5[n1]
		local v152 = v151 and v151.Character

		if v152 then
			local Humanoid = v152:FindFirstChildOfClass("Humanoid")

			if Humanoid and Humanoid.RootPart then
				return Humanoid.RootPart
			end
		end

		if p20 == 0 then
			p20 = 1
		end
	end

	u44 = false

	return nil
end

local t12 = {
	{
		name = "Custom",
		color = nil
	},
	{
		name = "White",
		color = Color3.new(1, 1, 1)
	},
	{
		name = "Warm",
		color = Color3.fromRGB(255, 230, 200)
	},
	{
		name = "Cool",
		color = Color3.fromRGB(200, 220, 255)
	},
	{
		name = "Red",
		color = Color3.new(1, 0, 0)
	},
	{
		name = "Green",
		color = Color3.new(0, 1, 0)
	},
	{
		name = "Blue",
		color = Color3.new(0, 0, 1)
	},
	{
		name = "Yellow",
		color = Color3.new(1, 1, 0)
	},
	{
		name = "Cyan",
		color = Color3.new(0, 1, 1)
	},
	{
		name = "Magenta",
		color = Color3.new(1, 0, 1)
	},
	{
		name = "Orange",
		color = Color3.fromRGB(255, 140, 0)
	},
	{
		name = "Purple",
		color = Color3.fromRGB(128, 0, 255)
	}
}
local n6 = 1
local color3 = Color3.new(1, 1, 1)

local function doTogglePlayerLock() -- line: 517
	-- upvalues: u44 (ref), DefaultZoom (ref), t1 (copy), DefaultHeight (ref), u49 (ref), findPlayerLockRootPart (copy)
	u44 = not u44

	if u44 then
		DefaultZoom = t1.PlayerLock.DefaultZoom
		DefaultHeight = t1.PlayerLock.DefaultHeight
		u49 = findPlayerLockRootPart(0)
	end
end
local function doToggleScreenGuis() -- line: 526
	-- upvalues: u50 (ref), t18 (ref), Freecam (ref)
	u50 = not u50

	if t18 then
		for _, v in pairs(t18.getScreenGuis()) do
			if v.Parent and v ~= Freecam then
				v.Enabled = u50
			end
		end
	end
end
local function doToggleLeaderboard() -- line: 537
	-- upvalues: u51 (ref), StarterGui (copy)
	u51 = not u51
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, u51)
end
local function makeEffectGroup(p21, p22, p23, p24, p25) -- line: 549
	local t13 = {{
		type = "toggle",
		name = "Enable",
		toggle = p22,
		isEnabled = function() -- line: 553
			-- upvalues: p23 (copy)
			local v348 = p23()

			return v348 and v348.Enabled
		end
	}}

	for _, v in ipairs(p24 or {}) do
		t13[#t13 + 1] = {
			type = "axis",
			name = v.name,
			adj = v.adjCfg.Adj,
			min = v.adjCfg.Min,
			max = v.adjCfg.Max,
			get = function() -- line: 559
				-- upvalues: p23 (copy), v (copy)
				local v349 = p23()

				return v349 and v349[v.prop] or 0
			end,
			set = function(p26) -- line: 560
				-- upvalues: p23 (copy), v (copy)
				local v351 = p23()

				if v351 then
					v351[v.prop] = p26
				end
			end
		}
	end

	for _, v in ipairs(p25 or {}) do
		t13[#t13 + 1] = v
	end

	return {
		type = "group",
		name = p21,
		modes = t13
	}
end
local function buildCustomEffectsGroup() -- line: 569
	-- upvalues: doToggleMasterEffects (copy), u30 (ref), makeEffectGroup (copy), doToggleDoF (copy), u16 (ref), t1 (copy), doToggleBloom (copy), u17 (ref), doToggleBlur (copy), u18 (ref), doToggleColorCorrection (copy), u19 (ref), t12 (copy), n6 (ref), color3 (ref), doToggleSunRays (copy), u20 (ref), doToggleColorGrading (copy), u21 (ref)
	return {
		type = "group",
		name = "Custom Post Processing",
		modes = {
			{
				type = "toggle",
				name = "Enable",
				toggle = doToggleMasterEffects,
				isEnabled = function() -- line: 575
					-- upvalues: u30 (ref)
					return u30
				end
			},
			makeEffectGroup("Depth of Field", doToggleDoF, function() -- line: 576
				-- upvalues: u16 (ref)
				return u16
			end, {
				{
					name = "Far",
					prop = "FarIntensity",
					adjCfg = t1.DoF.FarIntensity
				},
				{
					name = "Near",
					prop = "NearIntensity",
					adjCfg = t1.DoF.NearIntensity
				},
				{
					name = "Focus Distance",
					prop = "FocusDistance",
					adjCfg = t1.DoF.FocusDistance
				},
				{
					name = "Focus Radius",
					prop = "InFocusRadius",
					adjCfg = t1.DoF.FocusRadius
				}
			}),
			makeEffectGroup("Bloom", doToggleBloom, function() -- line: 582
				-- upvalues: u17 (ref)
				return u17
			end, {
				{
					name = "Intensity",
					prop = "Intensity",
					adjCfg = t1.Bloom.Intensity
				},
				{
					name = "Size",
					prop = "Size",
					adjCfg = t1.Bloom.Size
				},
				{
					name = "Threshold",
					prop = "Threshold",
					adjCfg = t1.Bloom.Threshold
				}
			}),
			makeEffectGroup("Blur", doToggleBlur, function() -- line: 587
				-- upvalues: u18 (ref)
				return u18
			end, {{
				name = "Size",
				prop = "Size",
				adjCfg = t1.Blur.Size
			}}),
			makeEffectGroup("Color Correction", doToggleColorCorrection, function() -- line: 590
				-- upvalues: u19 (ref)
				return u19
			end, {
				{
					name = "Brightness",
					prop = "Brightness",
					adjCfg = t1.ColorCorrection.Brightness
				},
				{
					name = "Contrast",
					prop = "Contrast",
					adjCfg = t1.ColorCorrection.Contrast
				},
				{
					name = "Saturation",
					prop = "Saturation",
					adjCfg = t1.ColorCorrection.Saturation
				}
			}, {
				{
					type = "cycle",
					name = "Tint",
					items = function() -- line: 598
						-- upvalues: t12 (copy)
						return t12
					end,
					getIndex = function() -- line: 599
						-- upvalues: n6 (ref)
						return n6
					end,
					setIndex = function(p27) -- line: 600
						-- upvalues: n6 (ref), u19 (ref), color3 (ref), t12 (copy)
						n6 = p27

						if u19 then
							if p27 == 1 then
								u19.TintColor = color3

								return
							end

							local color = t12[p27].color

							u19.TintColor = color
							color3 = color
						end
					end,
					displayItem = function(p28) -- line: 612
						return p28.name
					end
				},
				{
					type = "axis",
					name = "Tint R",
					adj = 0.02,
					min = 0,
					max = 1,
					get = function() -- line: 614
						-- upvalues: color3 (ref)
						return color3.R
					end,
					set = function(p29) -- line: 615
						-- upvalues: color3 (ref), n6 (ref), u19 (ref)
						color3 = Color3.new(p29, color3.G, color3.B)
						n6 = 1

						if u19 then
							u19.TintColor = color3
						end
					end
				},
				{
					type = "axis",
					name = "Tint G",
					adj = 0.02,
					min = 0,
					max = 1,
					get = function() -- line: 621
						-- upvalues: color3 (ref)
						return color3.G
					end,
					set = function(p30) -- line: 622
						-- upvalues: color3 (ref), n6 (ref), u19 (ref)
						color3 = Color3.new(color3.R, p30, color3.B)
						n6 = 1

						if u19 then
							u19.TintColor = color3
						end
					end
				},
				{
					type = "axis",
					name = "Tint B",
					adj = 0.02,
					min = 0,
					max = 1,
					get = function() -- line: 628
						-- upvalues: color3 (ref)
						return color3.B
					end,
					set = function(p31) -- line: 629
						-- upvalues: color3 (ref), n6 (ref), u19 (ref)
						color3 = Color3.new(color3.R, color3.G, p31)
						n6 = 1

						if u19 then
							u19.TintColor = color3
						end
					end
				}
			}),
			makeEffectGroup("Sun Rays", doToggleSunRays, function() -- line: 636
				-- upvalues: u20 (ref)
				return u20
			end, {
				{
					name = "Intensity",
					prop = "Intensity",
					adjCfg = t1.SunRays.Intensity
				},
				{
					name = "Spread",
					prop = "Spread",
					adjCfg = t1.SunRays.Spread
				}
			}),
			(makeEffectGroup("Color Grading", doToggleColorGrading, function() -- line: 640
				-- upvalues: u21 (ref)
				return u21
			end, nil, {{
				type = "cycle",
				name = "Tonemap",
				items = function() -- line: 644
					return {
						Enum.TonemapperPreset.Default,
						Enum.TonemapperPreset.Retro
					}
				end,
				getIndex = function() -- line: 645
					-- upvalues: u21 (ref)
					if u21 and u21.TonemapperPreset == Enum.TonemapperPreset.Retro then
						return 2
					end

					return 1
				end,
				setIndex = function(p32) -- line: 651
					-- upvalues: u21 (ref)
					if u21 then
						u21.TonemapperPreset = ({
							Enum.TonemapperPreset.Default,
							Enum.TonemapperPreset.Retro
						})[p32]
					end
				end,
				displayItem = function(p33) -- line: 657
					return p33.Name
				end
			}}))
		}
	}
end
local function makeSpeedStiffnessGroup(p34, p35, p36, p37, p38) -- line: 664
	-- upvalues: t10 (copy), t6 (copy)
	return {
		type = "group",
		name = p34,
		modes = {
			{
				type = "axis",
				name = "Speed",
				adj = p35.AdjSpeed,
				min = p35.MinSpeed,
				max = p35.MaxSpeed,
				get = function() -- line: 668
					-- upvalues: t10 (copy), p36 (copy)
					return t10[p36]
				end,
				set = function(p39) -- line: 669
					-- upvalues: t10 (copy), p36 (copy)
					t10[p36] = p39
				end
			},
			{
				type = "axis",
				name = "Stiffness",
				adj = p35.AdjStiffness,
				min = p35.MinStiffness,
				max = p35.MaxStiffness,
				get = function() -- line: 672
					-- upvalues: t6 (copy), p37 (copy)
					return t6[p37]
				end,
				set = function(p40) -- line: 673
					-- upvalues: t6 (copy), p37 (copy), p38 (copy)
					t6[p37] = p40
					p38:SetFreq(p40)
				end
			}
		}
	}
end

local t14 = {
	buildCustomEffectsGroup(),
	{
		type = "group",
		name = "Player Lock",
		modes = {
			{
				type = "toggle",
				name = "Enable",
				toggle = doTogglePlayerLock,
				isEnabled = function() -- line: 684
					-- upvalues: u44 (ref)
					return u44
				end
			},
			{
				type = "cycle",
				name = "Target",
				items = function() -- line: 686
					-- upvalues: t5 (ref)
					return t5
				end,
				getIndex = function() -- line: 687
					-- upvalues: n1 (ref)
					return n1
				end,
				setIndex = function(p41) -- line: 688
					-- upvalues: n1 (ref), t5 (ref), u49 (ref)
					n1 = p41

					local v172 = t5[p41]
					local v173 = v172 and v172.Character

					if v173 then
						local Humanoid = v173:FindFirstChildOfClass("Humanoid")

						u49 = Humanoid and Humanoid.RootPart or nil

						return
					end

					u49 = nil
				end,
				displayItem = function(p42) -- line: 699
					return p42.Name
				end
			}
		}
	},
	{
		type = "group",
		name = "UI",
		modes = {
			{
				type = "toggle",
				name = "Screen GUIs",
				toggle = doToggleScreenGuis,
				isEnabled = function() -- line: 705
					-- upvalues: u50 (ref)
					return u50
				end
			},
			{
				type = "toggle",
				name = "Leaderboard",
				toggle = doToggleLeaderboard,
				isEnabled = function() -- line: 708
					-- upvalues: u51 (ref)
					return u51
				end
			}
		}
	},
	makeSpeedStiffnessGroup("Movement", t1.Movement, "movement", "movement", v60),
	makeSpeedStiffnessGroup("Field of View", t1.Fov, "fov", "fov", v62),
	makeSpeedStiffnessGroup("Tilt", t1.Roll, "roll", "roll", v63),
	(makeSpeedStiffnessGroup("Pan", t1.Pan, "pan", "pan", v61))
}

local function currentMode() -- line: 716
	-- upvalues: t11 (ref), t14 (copy), n5 (ref)
	if #t11 > 0 then
		local v176 = t11[#t11]

		return v176.modes[v176.index]
	end

	return t14[n5]
end
local function createBinding(p43, p44) -- line: 727
	local InputBinding = Instance.new("InputBinding")

	if p44.keyCode then
		InputBinding.KeyCode = p44.keyCode
	end

	if p44.up then
		InputBinding.Up = p44.up
	end

	if p44.down then
		InputBinding.Down = p44.down
	end

	if p44.left then
		InputBinding.Left = p44.left
	end

	if p44.right then
		InputBinding.Right = p44.right
	end

	if p44.scale then
		InputBinding.Scale = p44.scale
	end

	if p44.vector2Scale then
		InputBinding.Vector2Scale = p44.vector2Scale
	end

	if p44.responseCurve then
		InputBinding.ResponseCurve = p44.responseCurve
	end

	if p44.primaryModifier then
		InputBinding.PrimaryModifier = p44.primaryModifier
	end

	InputBinding.Parent = p43

	return InputBinding
end
local function createAction(p45, p46) -- line: 742
	-- upvalues: createBinding (copy)
	local InputAction = Instance.new("InputAction")

	InputAction.Name = p46.name
	InputAction.Type = p46.type
	InputAction.Parent = p45

	for _, v in ipairs(p46.bindings) do
		createBinding(InputAction, v)
	end

	return InputAction
end
local function makeDoubleTapHandler(p47, p48, p49) -- line: 754
	local u188 = nil
	local n7 = 0

	local function detect(p50) -- line: 756
		-- upvalues: u188 (ref), p47 (copy), n7 (ref), p48 (copy), p49 (copy)
		if math.abs(p50) > 0.01 then
			local elapsed = os.clock()

			if u188 ~= nil and elapsed - u188 <= p47 then
				if elapsed - n7 >= p48 then
					p49()
					n7 = elapsed
				end

				u188 = nil

				return
			end

			u188 = elapsed
		end
	end
	local function reset() -- line: 770
		-- upvalues: u188 (ref)
		u188 = nil
	end

	return detect, reset
end
local function createIASContexts() -- line: 774
	-- upvalues: t1 (copy), u55 (ref), createAction (copy), t8 (copy), t9 (copy), u68 (ref), vector3_2 (ref), v63 (copy), u67 (ref), u69 (ref), u72 (ref), t11 (ref), t14 (copy), n5 (ref)
	local Actions = t1.Actions
	local InputContext = Instance.new("InputContext")

	InputContext.Name = "FreecamToggleContext"
	InputContext.Priority = 3000
	InputContext.Sink = false
	InputContext.Enabled = true
	InputContext.Parent = script
	u55 = createAction(InputContext, Actions.Toggle)

	local InputContext2 = Instance.new("InputContext")

	InputContext2.Name = "FreecamInputContext"
	InputContext2.Priority = 2000
	InputContext2.Sink = true
	InputContext2.Enabled = false
	InputContext2.Parent = script
	t8._sinkContext = InputContext2
	t9.Pan = createAction(InputContext2, Actions.Pan)
	t9.MovementMove = createAction(InputContext2, Actions.MovementMove)
	t9.MovementElevate = createAction(InputContext2, Actions.MovementElevate)
	t9.Fov = createAction(InputContext2, Actions.Fov)
	t9.Shift = createAction(InputContext2, Actions.Shift)

	local v195 = createAction(InputContext2, Actions.Tilt)

	t9.Tilt = v195

	local Threshold = t1.DoubleTap.Threshold
	local Debounce = t1.DoubleTap.Debounce

	local function v198() -- line: 807
		-- upvalues: vector3_2 (ref), v63 (copy), u67 (ref)
		vector3_2 = Vector3.new(vector3_2.x, vector3_2.y, 0)
		v63:Reset(0)
		u67 = true
	end

	local u199 = nil
	local n8 = 0

	local function detect(p51) -- line: 756
		-- upvalues: u199 (ref), Threshold (copy), n8 (ref), Debounce (copy), v198 (copy)
		if math.abs(p51) > 0.01 then
			local elapsed = os.clock()

			if u199 ~= nil and elapsed - u199 <= Threshold then
				if elapsed - n8 >= Debounce then
					v198()
					n8 = elapsed
				end

				u199 = nil

				return
			end

			u199 = elapsed
		end
	end
	local function reset() -- line: 770
		-- upvalues: u199 (ref)
		u199 = nil
	end

	u68 = reset

	local u203 = detect

	v195.StateChanged:Connect(function(oldState: number) -- line: 813
		-- upvalues: u67 (ref), u203 (ref)
		if u67 then
			if math.abs(oldState) < 0.01 then
				u67 = false
			end

			return
		end

		u203(oldState)
	end)
	createAction(InputContext2, Actions.ModeToggle).StateChanged:Connect(function(oldState: boolean) -- line: 822
		-- upvalues: u69 (ref), u72 (ref), t11 (ref)
		if not oldState then
			return
		end

		if u69 then
			if u72 then
				u72 = false

				return
			end

			if #t11 > 0 then
				t11[#t11] = nil

				return
			end

			u69 = false

			return
		end

		u69 = true
	end)
	createAction(InputContext2, Actions.ModeNext).StateChanged:Connect(function(oldState: boolean) -- line: 838
		-- upvalues: u69 (ref), u72 (ref), t11 (ref), t14 (copy), n5 (ref)
		if not oldState or not u69 then
			return
		end

		if u72 then
			return
		end

		if #t11 > 0 then
			local v369 = t11[#t11]

			v369.index = v369.index % #v369.modes + 1

			return
		end

		local v370 = t14[n5]

		if v370.type == "group" then
			table.insert(t11, {
				index = 1,
				modes = v370.modes,
				groupName = v370.name
			})

			return
		end

		if v370.type == "toggle" then
			v370.toggle()

			return
		end

		if v370.type == "cycle" then
			local v371 = v370.items()

			if #v371 > 0 then
				v370.setIndex(v370.getIndex() % #v371 + 1)

				return
			end
		else
			if v370.type == "action" then
				v370.action()

				return
			end

			if v370.type == "axis" then
				u72 = true
			end
		end
	end)

	local v204 = createAction(InputContext2, Actions.ModeAxis)

	v204.StateChanged:Connect(function(oldState: number) -- line: 863
		-- upvalues: u69 (ref), u72 (ref), t11 (ref), t14 (copy), n5 (ref)
		if not u69 or oldState == 0 then
			return
		end

		if u72 then
			return
		end

		if #t11 > 0 then
			local v374

			if #t11 > 0 then
				local v373 = t11[#t11]

				v374 = v373.modes[v373.index]
			else
				v374 = t14[n5]
			end

			if v374.type == "group" then
				table.insert(t11, {
					index = 1,
					modes = v374.modes,
					groupName = v374.name
				})

				return
			end

			if v374.type == "toggle" then
				v374.toggle()

				return
			end

			if v374.type == "cycle" then
				local v375 = v374.items()

				if #v375 == 0 then
					return
				end

				if oldState > 0 then
					v374.setIndex(v374.getIndex() % #v375 + 1)

					return
				end

				if oldState < 0 then
					v374.setIndex((v374.getIndex() - 2) % #v375 + 1)

					return
				end
			elseif v374.type == "action" then
				v374.action()

				return
			end
		else
			if oldState > 0 then
				n5 = n5 % #t14 + 1

				return
			end

			if oldState < 0 then
				n5 = (n5 - 2) % #t14 + 1
			end
		end
	end)
	t9.ModeAxis = v204
end

createIASContexts()

function t8.Movement() -- line: 899
	-- upvalues: t9 (copy), t10 (copy), t1 (copy)
	local State = t9.MovementMove:GetState()

	return Vector3.new(State.X, t9.MovementElevate:GetState(), State.Y) * (t10.movement * (t9.Shift:GetState() and t1.Movement.ShiftMul or 1))
end
function t8.Pan() -- line: 905
	-- upvalues: t9 (copy), t10 (copy)
	local State = t9.Pan:GetState()

	return Vector2.new(State.Y, -State.X) * t10.pan
end
function t8.Fov() -- line: 910
	-- upvalues: t9 (copy), t10 (copy)
	return t9.Fov:GetState() * t10.fov
end
function t8.Roll() -- line: 914
	-- upvalues: u67 (ref), t9 (copy), t10 (copy)
	return ((if not u67 then t9.Tilt:GetState() else 0)) * t10.roll
end
function t8.ModeControl(p52) -- line: 918
	-- upvalues: u69 (ref), t11 (ref), u72 (ref), t14 (copy), n5 (ref), t9 (copy), clamp (copy)
	if not u69 then
		return
	end

	if #t11 == 0 and not u72 then
		return
	end

	local v209

	if #t11 > 0 then
		local v208 = t11[#t11]

		v209 = v208.modes[v208.index]
	else
		v209 = t14[n5]
	end

	if v209.type ~= "axis" then
		return
	end

	local v210 = t9.ModeAxis:GetState() * v209.adj * p52

	if v210 ~= 0 then
		v209.set((clamp(v209.get() + v210, v209.min, v209.max)))
	end
end
function t8.StartCapture() -- line: 929
	-- upvalues: t8 (copy)
	t8._sinkContext.Enabled = true
end
function t8.StopCapture() -- line: 933
	-- upvalues: t8 (copy), u67 (ref), u68 (ref), u69 (ref), t11 (ref), u72 (ref)
	t8._sinkContext.Enabled = false
	u67 = false

	if u68 then
		u68()
	end

	u69 = false
	t11 = {}
	u72 = false
end
function t8.getModeActive() -- line: 942
	-- upvalues: u69 (ref)
	return u69
end
function t8.getModeName() -- line: 944
	-- upvalues: t11 (ref), t14 (copy), n5 (ref)
	local v212

	if #t11 > 0 then
		local v211 = t11[#t11]

		v212 = v211.modes[v211.index]
	else
		v212 = t14[n5]
	end

	return v212.name
end
function t8.getModeBreadcrumb() -- line: 948
	-- upvalues: t11 (ref)
	if #t11 == 0 then
		return ""
	end

	local t15 = {}

	for _, v in ipairs(t11) do
		table.insert(t15, v.groupName)
	end

	return table.concat(t15, " › ")
end
function t8.getModeDisplay() -- line: 956
	-- upvalues: t11 (ref), t14 (copy), n5 (ref)
	local v217

	if #t11 > 0 then
		local v216 = t11[#t11]

		v217 = v216.modes[v216.index]
	else
		v217 = t14[n5]
	end

	if v217.type == "group" then
		return ""
	end

	if v217.type == "axis" then
		return string.format("%.2f", v217.get())
	end

	if v217.type == "toggle" then
		if v217.isEnabled() then
			return "ON"
		end

		return "OFF"
	end

	if v217.type == "cycle" then
		local v218 = v217.items()

		if #v218 == 0 then
			return "None"
		end

		local v219 = v218[v217.getIndex()]

		return v219 and v217.displayItem(v219) or "None"
	end

	if v217.type == "action" then
		return "(fire)"
	end

	return ""
end
function t8.getModeHint() -- line: 975
	-- upvalues: t14 (copy), n5 (ref), t11 (ref), u72 (ref)
	local v220 = t14[n5]

	local function lrVerb(p53) -- line: 978
		if p53 == "axis" then
			return "Hold to adjust"
		end

		if p53 == "toggle" then
			return "Tap to flip"
		end

		if p53 == "cycle" then
			return "Tap to cycle"
		end

		if p53 == "action" then
			return "Tap to fire"
		end

		if p53 == "group" then
			return "Enter"
		end

		return nil
	end

	if #t11 > 0 then
		local v222 = t11[#t11]
		local v223 = v222.index % #v222.modes + 1
		local v224 = "[↑] Back  [↓] " .. v222.modes[v223].name
		local v226

		if #t11 > 0 then
			local v225 = t11[#t11]

			v226 = v225.modes[v225.index]
		else
			v226 = t14[n5]
		end

		local type = v226.type
		local v228 = if type ~= "axis" then if type ~= "toggle" then if type ~= "cycle" then if type ~= "action" then if type ~= "group" then nil else "Enter" else "Tap to fire" else "Tap to cycle" else "Tap to flip" else "Hold to adjust"

		return {
			nav = v224,
			action = v228 and "[←][→] " .. v228 or ""
		}
	end

	if u72 then
		local type = v220.type
		local v230 = if type ~= "axis" then if type ~= "toggle" then if type ~= "cycle" then if type ~= "action" then if type ~= "group" then nil else "Enter" else "Tap to fire" else "Tap to cycle" else "Tap to flip" else "Hold to adjust"

		return {
			nav = "[↑] Back",
			action = v230 and "[←][→] " .. v230 or ""
		}
	end

	local type = v220.type
	local v232 = if type ~= "group" then if type ~= "toggle" then if type ~= "cycle" then if type ~= "action" then type ~= "axis" and "Select" or "Adjust" else "Fire" else "Cycle" else "Flip" else "Enter"
	local name = t14[(n5 - 2) % #t14 + 1].name
	local name2 = t14[n5 % #t14 + 1].name

	return {
		nav = "[↑] Close  [↓] " .. v232,
		action = "[←] " .. name .. "  [→] " .. name2
	}
end
function t8.getTintColorName() -- line: 1017
	-- upvalues: n6 (ref), t12 (copy)
	if n6 >= 1 and n6 <= #t12 then
		return t12[n6].name
	end

	return "Custom"
end
function t8.getActiveGroupName() -- line: 1023
	-- upvalues: u69 (ref), t11 (ref)
	if not u69 or #t11 == 0 then
		return nil
	end

	return t11[1].groupName
end

local t16 = {
	{
		key = "bloom",
		group = "Custom Post Processing",
		get = function() -- line: 1032
			-- upvalues: u17 (ref)
			return u17
		end,
		fmt = function(p54) -- line: 1033
			return string.format("Intensity: %.2f  Size: %.1f\nThreshold: %.2f", p54.Intensity, p54.Size, p54.Threshold)
		end
	},
	{
		key = "blur",
		group = "Custom Post Processing",
		get = function() -- line: 1035
			-- upvalues: u18 (ref)
			return u18
		end,
		fmt = function(p55) -- line: 1036
			return string.format("Size: %.1f", p55.Size)
		end
	},
	{
		key = "cc",
		group = "Custom Post Processing",
		get = function() -- line: 1037
			-- upvalues: u19 (ref)
			return u19
		end,
		fmt = function(p56) -- line: 1038
			-- upvalues: t8 (copy)
			return string.format("Brightness: %.2f  Contrast: %.2f\nSaturation: %.2f  Tint: %s", p56.Brightness, p56.Contrast, p56.Saturation, t8.getTintColorName())
		end
	},
	{
		key = "sunrays",
		group = "Custom Post Processing",
		get = function() -- line: 1040
			-- upvalues: u20 (ref)
			return u20
		end,
		fmt = function(p57) -- line: 1041
			return string.format("Intensity: %.2f  Spread: %.2f", p57.Intensity, p57.Spread)
		end
	},
	{
		key = "colorgrading",
		group = "Custom Post Processing",
		get = function() -- line: 1043
			-- upvalues: u21 (ref)
			return u21
		end,
		fmt = function(p58) -- line: 1044
			return string.format("Color Grading: %s", p58.TonemapperPreset.Name)
		end
	},
	{
		key = "dof",
		group = "Custom Post Processing",
		get = function() -- line: 1045
			-- upvalues: u16 (ref)
			return u16
		end,
		fmt = function(p59) -- line: 1046
			return string.format("Far: %.2f  Near: %.2f\nDistance: %.1f  Radius: %.1f", p59.FarIntensity, p59.NearIntensity, p59.FocusDistance, p59.InFocusRadius)
		end
	}
}

local function setBubble(p60, p61) -- line: 1050
	p60.bubble.Visible = p61 ~= ""

	if p61 ~= "" then
		p60.label.Text = p61
	end
end
local function StepFreecam(p62) -- line: 1055
	-- upvalues: t8 (copy), v60 (copy), v61 (copy), v62 (copy), v63 (copy), n4 (ref), rad (copy), tan (copy), sqrt (copy), t1 (copy), clamp (copy), n2 (ref), n3 (ref), vector3_2 (ref), vector3 (ref), u44 (ref), u49 (ref), DefaultZoom (ref), DefaultHeight (ref), u23 (ref), t22 (ref), Freecam (ref), t5 (ref), n1 (ref), t16 (copy), CurrentCamera (ref)
	t8.ModeControl(p62)

	local v244 = v60:Update(p62, t8.Movement())
	local v245 = v61:Update(p62, t8.Pan())
	local v246 = v62:Update(p62, t8.Fov())
	local v247 = v63:Update(p62, t8.Roll())
	local v248 = sqrt(0.7002075382097097 / tan((rad(n4 / 2))))
	local v249 = n4

	n4 = clamp(n4 + v246 * t1.Fov.Gain * (p62 / v248), 1, 120)

	if math.abs(n4 - v249) > 0.01 then
		n2 = os.clock()
	end

	if v244.Magnitude > 0.05 or v245.Magnitude > 0.0005 or math.abs(v247) > 0.0005 or math.abs(v246) > 0.0005 then
		n3 = os.clock()
	end

	local v250 = v245 * t1.Pan.Gain * (p62 / v248)

	vector3_2 += Vector3.new(v250.X, v250.Y, v247 * t1.Roll.Gain * (p62 / v248))

	local function wrapAngle(p63) -- line: 1077
		local v378 = p63 % 6.283185307179586

		return v378 > 3.141592653589793 and v378 - 6.283185307179586 or v378
	end

	local v252 = vector3_2.x % 6.283185307179586
	local v253 = v252 > 3.141592653589793 and v252 - 6.283185307179586 or v252
	local v254 = vector3_2.y % 6.283185307179586
	local v255 = v254 > 3.141592653589793 and v254 - 6.283185307179586 or v254
	local v256 = vector3_2.z % 6.283185307179586

	vector3_2 = Vector3.new(v253, v255, v256 > 3.141592653589793 and v256 - 6.283185307179586 or v256)

	local vector3_3 = Vector3.new(v244.X, v244.Y, -v244.Z)
	local v258 = CFrame.new(vector3) * CFrame.fromOrientation(vector3_2.x, vector3_2.y, vector3_2.z) * CFrame.new(vector3_3 * t1.Movement.Gain * p62)

	if u44 and u49 and u49.Parent then
		local PlayerLock = t1.PlayerLock
		local v260 = -v244.Z * t1.Movement.Gain.Z * p62
		local v261 = v244.Y * t1.Movement.Gain.Y * p62

		DefaultZoom = clamp(DefaultZoom + v260, PlayerLock.MinZoom, PlayerLock.MaxZoom)
		DefaultHeight = clamp(DefaultHeight + v261, -PlayerLock.HeightRange, PlayerLock.HeightRange)
		v258 = CFrame.new(u49.Position + Vector3.new(0, DefaultHeight, 0)) * CFrame.fromOrientation(vector3_2.x, vector3_2.y, vector3_2.z) * CFrame.new(0, 0, DefaultZoom)
	end

	if u23 and u23.Parent and t22 and Freecam and Freecam.Parent then
		local mode = t22.mode

		if t8.getModeActive() then
			if os.clock() - n3 < 2 then
				local t17 = {}

				t17[#t17 + 1] = string.format("X: %.0f  Y: %.0f  Z: %.0f", vector3.X, vector3.Y, vector3.Z)
				t17[#t17 + 1] = string.format("Pitch: %.1f°  Yaw: %.1f°  Roll: %.1f°", math.deg(vector3_2.X), math.deg(vector3_2.Y), (math.deg(vector3_2.Z)))

				if os.clock() - n2 < 2 then
					t17[#t17 + 1] = string.format("Field of View: %.1f", n4)
				end

				if p62 > 0 then
					local v264 = (v258.p - vector3).Magnitude / p62

					if v264 > 0.5 then
						t17[#t17 + 1] = string.format("Speed: %.1f", v264)
					end
				end

				local status = t22.status
				local v266 = table.concat(t17, "\n")

				status.bubble.Visible = v266 ~= ""

				if v266 ~= "" then
					status.label.Text = v266
				end
			else
				t22.status.bubble.Visible = false
			end

			if u44 and #t5 > 0 and t8.getActiveGroupName() ~= "Player Lock" then
				local lock = t22.lock
				local v268 = string.format("Lock: %s", t5[n1].Name)

				lock.bubble.Visible = v268 ~= ""

				if v268 ~= "" then
					lock.label.Text = v268
				end
			else
				t22.lock.bubble.Visible = false
			end

			local v269 = t8.getActiveGroupName()

			for _, v in ipairs(t16) do
				local v272 = v.get()

				if v272 and v272.Enabled and v269 ~= v.group then
					local v273 = t22[v.key]
					local v274 = v.fmt(v272)

					v273.bubble.Visible = v274 ~= ""

					if v274 ~= "" then
						v273.label.Text = v274
					end
				else
					t22[v.key].bubble.Visible = false
				end
			end

			mode.bubble.Visible = true

			local v275 = t8.getModeBreadcrumb()

			mode.breadcrumb.Text = v275
			mode.breadcrumb.Visible = v275 ~= ""

			local v276 = t8.getModeName()
			local v277 = t8.getModeDisplay()

			mode.title.Text = v277 ~= "" and v276 .. ": " .. v277 or v276

			local v278 = t8.getModeHint()

			mode.nav.Text = v278.nav
			mode.nav.Visible = v278.nav ~= ""
			mode.action.Text = v278.action
			mode.action.Visible = v278.action ~= ""
			u23.Visible = true
		else
			u23.Visible = false
		end
	end

	vector3 = v258.p
	CurrentCamera.CFrame = v258
	CurrentCamera.Focus = v258
	CurrentCamera.FieldOfView = n4
end

t18 = {}

local Default = nil
local MouseIconEnabled = nil
local CameraType = nil
local Focus = nil
local CurrentCameraCFrame = nil
local FieldOfView = nil
local t19 = {}
local t20 = {
	Backpack = true,
	Chat = true,
	Health = true,
	PlayerList = true
}
local t21 = {
	BadgesNotificationsActive = true,
	PointsNotificationsActive = true
}

function t18.Push() -- line: 1186
	-- upvalues: t20 (copy), StarterGui (copy), t21 (copy), LocalPlayer (ref), t19 (ref), connection (ref), u50 (ref), FieldOfView (ref), CurrentCamera (ref), CameraType (ref), CurrentCameraCFrame (ref), Focus (ref), MouseIconEnabled (ref), UserInputService (copy), Default (ref)
	for k in pairs(t20) do
		t20[k] = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType[k])
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType[k], false)
	end

	for k in pairs(t21) do
		t21[k] = StarterGui:GetCore(k)
		StarterGui:SetCore(k, false)
	end

	local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")

	if PlayerGui then
		for _, child in pairs(PlayerGui:GetChildren()) do
			if child:IsA("ScreenGui") and child.Enabled then
				t19[#t19 + 1] = child
				child.Enabled = false
			end
		end

		connection = PlayerGui.ChildAdded:Connect(function(child) -- line: 1203
			-- upvalues: t19 (ref), u50 (ref)
			if child:IsA("ScreenGui") and child.Enabled then
				t19[#t19 + 1] = child
				child.Enabled = u50
			end
		end)
	end

	FieldOfView = CurrentCamera.FieldOfView
	CurrentCamera.FieldOfView = 70
	CameraType = CurrentCamera.CameraType
	CurrentCamera.CameraType = Enum.CameraType.Custom
	CurrentCameraCFrame = CurrentCamera.CFrame
	Focus = CurrentCamera.Focus
	MouseIconEnabled = UserInputService.MouseIconEnabled
	UserInputService.MouseIconEnabled = false
	Default = Enum.MouseBehavior.Default
	UserInputService.MouseBehavior = Enum.MouseBehavior.Default
end
function t18.Pop() -- line: 1227
	-- upvalues: t20 (copy), StarterGui (copy), t21 (copy), t19 (ref), Freecam (ref), connection (ref), CurrentCamera (ref), FieldOfView (ref), CameraType (ref), CurrentCameraCFrame (ref), Focus (ref), UserInputService (copy), MouseIconEnabled (ref), Default (ref)
	for k, v in pairs(t20) do
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType[k], v)
	end

	for k, v in pairs(t21) do
		StarterGui:SetCore(k, v)
	end

	for _, v in pairs(t19) do
		if v.Parent and v ~= Freecam then
			v.Enabled = true
		end
	end

	if connection then
		connection:Disconnect()
		connection = nil
	end

	t19 = {}
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
function t18.getScreenGuis() -- line: 1252
	-- upvalues: t19 (ref)
	return t19
end

local function removePlayerFromList(p64) -- line: 1255
	-- upvalues: t5 (ref), n1 (ref), u44 (ref)
	for i, v in ipairs(t5) do
		if v == p64 then
			table.remove(t5, i)

			if i == n1 and u44 then
				u44 = false
				n1 = 1
			end

			if i < n1 then
				n1 -= 1
			end

			if not (n1 > #t5) and not (n1 < 1) then
				return
			end

			n1 = 1

			return
		end
	end
end
local function initializePlayerList() -- line: 1270
	-- upvalues: t5 (ref), Players (copy), LocalPlayer (ref), n1 (ref), connection2 (ref), connection3 (ref), removePlayerFromList (copy)
	t5 = Players:GetPlayers()

	for i, v in ipairs(t5) do
		if v == LocalPlayer then
			n1 = i

			break
		end
	end

	connection2 = Players.PlayerAdded:Connect(function(player) -- line: 1275
		-- upvalues: t5 (ref)
		table.insert(t5, player)
	end)
	connection3 = Players.PlayerRemoving:Connect(removePlayerFromList)
end
local function StartFreecam() -- line: 1279
	-- upvalues: initializePlayerList (copy), CurrentCamera (ref), vector3_2 (ref), vector3 (ref), n4 (ref), v60 (copy), v61 (copy), v62 (copy), v63 (copy), Freecam (ref), LocalPlayer (ref), u23 (ref), t22 (ref), t18 (ref), t4 (ref), t2 (copy), RunService (copy), StepFreecam (copy), t8 (copy)
	initializePlayerList()

	local CurrentCameraCFrame2 = CurrentCamera.CFrame

	vector3_2 = Vector3.new(CurrentCameraCFrame2:toEulerAnglesYXZ())
	vector3 = CurrentCameraCFrame2.p
	n4 = CurrentCamera.FieldOfView
	v60:Reset((Vector3.new()))
	v61:Reset(Vector2.new())
	v62:Reset(0)
	v63:Reset(0)
	Freecam = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Freecam")

	if not u23 or not u23.Parent then
		local Frame = Instance.new("Frame")

		Frame.Name = "FreecamCustomGui"
		Frame.BackgroundTransparency = 1
		Frame.AutomaticSize = Enum.AutomaticSize.XY
		Frame.AnchorPoint = Vector2.new(1, 1)
		Frame.Position = UDim2.new(1, -16, 1, -16)
		Frame.Size = UDim2.new(0, 0, 0, 0)
		Frame.Visible = false

		local UIListLayout = Instance.new("UIListLayout")

		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.FillDirection = Enum.FillDirection.Vertical
		UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
		UIListLayout.Padding = UDim.new(0, 6)
		UIListLayout.Parent = Frame

		local function makeBubble(p65, p66) -- line: 1311
			-- upvalues: Frame (copy)
			local Frame2 = Instance.new("Frame")

			Frame2.Name = p65
			Frame2.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
			Frame2.BackgroundTransparency = 0.4
			Frame2.BorderSizePixel = 0
			Frame2.AutomaticSize = Enum.AutomaticSize.XY
			Frame2.Size = UDim2.new(0, 0, 0, 0)
			Frame2.LayoutOrder = p66
			Frame2.Visible = false

			local UICorner = Instance.new("UICorner")

			UICorner.CornerRadius = UDim.new(0, 8)
			UICorner.Parent = Frame2

			local UIPadding = Instance.new("UIPadding")

			UIPadding.PaddingTop = UDim.new(0, 8)
			UIPadding.PaddingBottom = UDim.new(0, 8)
			UIPadding.PaddingLeft = UDim.new(0, 12)
			UIPadding.PaddingRight = UDim.new(0, 12)
			UIPadding.Parent = Frame2

			local TextLabel = Instance.new("TextLabel")

			TextLabel.Name = "Label"
			TextLabel.BackgroundTransparency = 1
			TextLabel.TextColor3 = Color3.new(1, 1, 1)
			TextLabel.Font = Enum.Font.GothamMedium
			TextLabel.TextSize = 14
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel.AutomaticSize = Enum.AutomaticSize.XY
			TextLabel.Size = UDim2.new(0, 0, 0, 0)
			TextLabel.Parent = Frame2
			Frame2.Parent = Frame

			return Frame2, TextLabel
		end

		local v299, v300 = makeBubble("BloomBubble", 1)
		local v301, v302 = makeBubble("BlurBubble", 2)
		local v303, v304 = makeBubble("CCBubble", 3)
		local v305, v306 = makeBubble("SunRaysBubble", 4)
		local v307, v308 = makeBubble("ColorGradingBubble", 5)
		local v309, v310 = makeBubble("DofBubble", 6)
		local v311, v312 = makeBubble("LockBubble", 7)
		local v313, v314 = makeBubble("StatusBubble", 8)
		local Frame3 = Instance.new("Frame")

		Frame3.Name = "ModeBubble"
		Frame3.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
		Frame3.BackgroundTransparency = 0.4
		Frame3.BorderSizePixel = 0
		Frame3.AutomaticSize = Enum.AutomaticSize.XY
		Frame3.Size = UDim2.new(0, 0, 0, 0)
		Frame3.LayoutOrder = 9
		Frame3.Visible = false

		local UICorner = Instance.new("UICorner")

		UICorner.CornerRadius = UDim.new(0, 8)
		UICorner.Parent = Frame3

		local UIPadding = Instance.new("UIPadding")

		UIPadding.PaddingTop = UDim.new(0, 8)
		UIPadding.PaddingBottom = UDim.new(0, 8)
		UIPadding.PaddingLeft = UDim.new(0, 12)
		UIPadding.PaddingRight = UDim.new(0, 12)
		UIPadding.Parent = Frame3

		local UIListLayout2 = Instance.new("UIListLayout")

		UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout2.FillDirection = Enum.FillDirection.Vertical
		UIListLayout2.Padding = UDim.new(0, 2)
		UIListLayout2.Parent = Frame3

		local function makeModeLabel(p67, p68, p69, p70, p71) -- line: 1376
			-- upvalues: Frame3 (copy)
			local TextLabel = Instance.new("TextLabel")

			TextLabel.Name = p67
			TextLabel.BackgroundTransparency = 1
			TextLabel.TextColor3 = p71
			TextLabel.Font = p69
			TextLabel.TextSize = p70
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel.AutomaticSize = Enum.AutomaticSize.XY
			TextLabel.Size = UDim2.new(0, 0, 0, 0)
			TextLabel.LayoutOrder = p68
			TextLabel.Parent = Frame3

			return TextLabel
		end

		local v320 = makeModeLabel("Breadcrumb", 1, Enum.Font.Gotham, 11, Color3.fromRGB(100, 100, 100))
		local v321 = makeModeLabel("Title", 2, Enum.Font.GothamBold, 14, Color3.new(1, 1, 1))
		local v322 = makeModeLabel("NavHint", 3, Enum.Font.Gotham, 12, Color3.fromRGB(120, 120, 120))
		local v323 = makeModeLabel("ActionHint", 4, Enum.Font.GothamMedium, 12, Color3.fromRGB(200, 200, 200))

		Frame3.Parent = Frame
		u23 = Frame
		t22 = {
			bloom = {
				bubble = v299,
				label = v300
			},
			blur = {
				bubble = v301,
				label = v302
			},
			cc = {
				bubble = v303,
				label = v304
			},
			sunrays = {
				bubble = v305,
				label = v306
			},
			colorgrading = {
				bubble = v307,
				label = v308
			},
			dof = {
				bubble = v309,
				label = v310
			},
			lock = {
				bubble = v311,
				label = v312
			},
			status = {
				bubble = v313,
				label = v314
			},
			mode = {
				bubble = Frame3,
				breadcrumb = v320,
				title = v321,
				nav = v322,
				action = v323
			}
		}
		Frame.Parent = Freecam
	end

	t18.Push()
	Freecam.Enabled = true

	local function makeEffect(p72, p73) -- line: 1415
		-- upvalues: CurrentCamera (ref)
		local v395 = Instance.new(p72)

		v395.Name = p73
		v395.Parent = CurrentCamera

		return v395
	end

	for _, v in ipairs(t4) do
		local v327 = t2[v.key]
		local class = v.class
		local v329 = "Freecam" .. v.key
		local v330 = Instance.new(class)

		v330.Name = v329
		v330.Parent = CurrentCamera

		for _, v2 in ipairs(v.props) do
			v330[v2] = v327[v2]
		end

		v330.Enabled = v327.Enabled
		v.set(v330)
	end

	RunService:BindToRenderStep("Freecam", Enum.RenderPriority.Camera.Value, StepFreecam)
	t8.StartCapture()
end
local function StopFreecam() -- line: 1433
	-- upvalues: connection2 (ref), connection3 (ref), u44 (ref), n1 (ref), t5 (ref), v32 (copy), u30 (ref), t4 (ref), t2 (copy), Freecam (ref), u50 (ref), u51 (ref), t8 (copy), RunService (copy), t18 (ref)
	if connection2 then
		connection2:Disconnect()
		connection2 = nil
	end

	if connection3 then
		connection3:Disconnect()
		connection3 = nil
	end

	u44 = false
	n1 = 1
	t5 = {}
	v32()
	u30 = false

	for _, v in ipairs(t4) do
		local v335 = v.get()

		if v335 then
			local v336 = t2[v.key]

			v336.Enabled = v335.Enabled

			for _, v3 in ipairs(v.props) do
				v336[v3] = v335[v3]
			end

			v335:Destroy()
			v.set(nil)
		end
	end

	if Freecam and Freecam.Parent then
		Freecam.Enabled = false
	end

	u50 = false
	u51 = false
	t8.StopCapture()
	RunService:UnbindFromRenderStep("Freecam")
	t18.Pop()
end

local u105 = false

local function ToggleFreecam() -- line: 1467
	-- upvalues: u105 (ref), StopFreecam (copy), StartFreecam (copy), u28 (ref), t1 (copy)
	if u105 then
		StopFreecam()
	else
		StartFreecam()
	end

	u105 = not u105

	if u28 then
		script:SetAttribute(t1.AttributeName, u105)
	end
end

u55.StateChanged:Connect(function(oldState: boolean) -- line: 1475
	-- upvalues: u105 (ref), StopFreecam (copy), StartFreecam (copy), u28 (ref), t1 (copy)
	if oldState then
		if u105 then
			StopFreecam()
		else
			StartFreecam()
		end

		u105 = not u105

		if u28 then
			script:SetAttribute(t1.AttributeName, u105)
		end
	end
end)

if u28 then
	script:SetAttribute(t1.AttributeName, u105)
	script:GetAttributeChangedSignal(t1.AttributeName):Connect(function() -- line: 1481
		-- upvalues: t1 (copy), u105 (ref), StartFreecam (copy), StopFreecam (copy)
		local t1AttributeName = script:GetAttribute(t1.AttributeName)

		if typeof(t1AttributeName) ~= "boolean" then
			script:SetAttribute(t1.AttributeName, u105)

			return
		end

		if t1AttributeName ~= u105 then
			if t1AttributeName then
				StartFreecam()
				u105 = true

				return
			end

			StopFreecam()
			u105 = false
		end
	end)
end

return {}
