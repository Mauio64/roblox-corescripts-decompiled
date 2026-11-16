local clamp = math.clamp
local exp = math.exp
local rad = math.rad
local sqrt = math.sqrt
local tan = math.tan

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local StarterPlayer = game:GetService("StarterPlayer")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

local success, result = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserFreecamIASRefactor1")
end)

local v = success and result

local v2 = {
	AttributeName = "FreecamEnabled",
	Thumbstick = { Curvature = 2 },
	DoubleTap = { Threshold = 0.25, Debounce = 0.1 },
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
		Gain = Vector2.new(0.75, 1) * 8,
		MouseScale = Vector2.new(0.0008181230868723419, -0.0008181230868723419),
		TrackpadScale = Vector2.new(0.011453723216212788, -0.011453723216212788),
		GamepadScale = Vector2.new(0.39269908169872414, 0.39269908169872414),
		AdjSpeed = 0.75,
		MinSpeed = 0.01,
		MaxSpeed = 4,
		Stiffness = 1,
		AdjStiffness = 0.75,
		MinStiffness = 0.01,
		MaxStiffness = 10
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
		FarIntensity = { Adj = 0.1, Min = 0, Max = 1 },
		NearIntensity = { Adj = 0.1, Min = 0, Max = 1 },
		FocusDistance = { Adj = 20, Min = 0, Max = 200 },
		FocusRadius = { Adj = 5, Min = 0, Max = 50 }
	},
	Bloom = {
		Intensity = { Adj = 0.05, Min = 0, Max = 1 },
		Size = { Adj = 2, Min = 0, Max = 56 },
		Threshold = {
			Adj = 0.05,
			Min = v and 0.8 or 0,
			Max = v and 4 or 1
		}
	},
	Blur = {
		Size = { Adj = 2, Min = 0, Max = 56 }
	},
	ColorCorrection = {
		Brightness = { Adj = 0.05, Min = -1, Max = 1 },
		Contrast = { Adj = 0.05, Min = -1, Max = 1 },
		Saturation = { Adj = 0.05, Min = -1, Max = 1 }
	},
	SunRays = {
		Intensity = { Adj = 0.05, Min = 0, Max = 1 },
		Spread = { Adj = 0.05, Min = 0, Max = 1 }
	},
	Keys = {
		Toggle = { Keyboard = Enum.KeyCode.P, Modifier = Enum.KeyCode.LeftShift },
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
			Keyboard = { Up = Enum.KeyCode.E, Down = Enum.KeyCode.Q },
			Gamepad = { Up = Enum.KeyCode.ButtonR2, Down = Enum.KeyCode.ButtonL2 }
		},
		ModeSelect = {
			Toggle = { Keyboard = Enum.KeyCode.Up, Gamepad = Enum.KeyCode.DPadUp },
			Next = { Keyboard = Enum.KeyCode.Down, Gamepad = Enum.KeyCode.DPadDown },
			Axis = {
				Up = { Keyboard = Enum.KeyCode.Right, Gamepad = Enum.KeyCode.DPadRight },
				Down = { Keyboard = Enum.KeyCode.Left, Gamepad = Enum.KeyCode.DPadLeft }
			}
		},
		Fov = {
			Mouse = Enum.KeyCode.MouseWheel,
			TrackpadPinch = Enum.KeyCode.TrackpadPinch,
			Gamepad = { Up = Enum.KeyCode.ButtonX, Down = Enum.KeyCode.ButtonY }
		},
		Tilt = {
			Keyboard = { Up = Enum.KeyCode.C, Down = Enum.KeyCode.Z },
			Gamepad = { Up = Enum.KeyCode.ButtonR1, Down = Enum.KeyCode.ButtonL1 }
		},
		Shift = {
			KeyboardPrimary = Enum.KeyCode.LeftShift,
			KeyboardSecondary = Enum.KeyCode.RightShift
		}
	}
}

v2.Actions = {
	Toggle = {
		name = "FreecamToggleAction",
		type = Enum.InputActionType.Bool,
		bindings = {
			{ keyCode = v2.Keys.Toggle.Keyboard, primaryModifier = v2.Keys.Toggle.Modifier }
		}
	},
	Pan = {
		name = "PanAction",
		type = Enum.InputActionType.Direction2D,
		bindings = {
			{ keyCode = v2.Keys.Pan.Mouse, vector2Scale = v2.Pan.MouseScale },
			{ keyCode = v2.Keys.Pan.Trackpad, vector2Scale = v2.Pan.TrackpadScale },
			{
				keyCode = v2.Keys.Pan.Gamepad,
				responseCurve = v2.Thumbstick.Curvature,
				vector2Scale = v2.Pan.GamepadScale
			}
		}
	},
	MovementMove = {
		name = "MovementMoveAction",
		type = Enum.InputActionType.Direction2D,
		bindings = {
			{
				up = v2.Keys.MovementMove.Keyboard.Up,
				down = v2.Keys.MovementMove.Keyboard.Down,
				left = v2.Keys.MovementMove.Keyboard.Left,
				right = v2.Keys.MovementMove.Keyboard.Right
			},
			{ keyCode = v2.Keys.MovementMove.Gamepad, responseCurve = v2.Thumbstick.Curvature }
		}
	},
	MovementElevate = {
		name = "MovementElevateAction",
		type = Enum.InputActionType.Direction1D,
		bindings = {
			{
				up = v2.Keys.MovementElevate.Keyboard.Up,
				down = v2.Keys.MovementElevate.Keyboard.Down
			},
			{ up = v2.Keys.MovementElevate.Gamepad.Up, down = v2.Keys.MovementElevate.Gamepad.Down }
		}
	},
	Fov = {
		name = "FovAction",
		type = Enum.InputActionType.Direction1D,
		bindings = {
			{ keyCode = v2.Keys.Fov.Mouse, scale = v2.Fov.WheelScale },
			{ keyCode = v2.Keys.Fov.TrackpadPinch, scale = v2.Fov.PinchScale },
			{
				up = v2.Keys.Fov.Gamepad.Up,
				down = v2.Keys.Fov.Gamepad.Down,
				scale = v2.Fov.GamepadScale
			}
		}
	},
	Tilt = {
		name = "TiltAction",
		type = Enum.InputActionType.Direction1D,
		bindings = {
			{ up = v2.Keys.Tilt.Keyboard.Up, down = v2.Keys.Tilt.Keyboard.Down },
			{ up = v2.Keys.Tilt.Gamepad.Up, down = v2.Keys.Tilt.Gamepad.Down }
		}
	},
	Shift = {
		name = "ShiftAction",
		type = Enum.InputActionType.Bool,
		bindings = {
			{ keyCode = v2.Keys.Shift.KeyboardPrimary },
			{ keyCode = v2.Keys.Shift.KeyboardSecondary }
		}
	},
	ModeToggle = {
		name = "ModeToggleAction",
		type = Enum.InputActionType.Bool,
		bindings = {
			{ keyCode = v2.Keys.ModeSelect.Toggle.Keyboard },
			{ keyCode = v2.Keys.ModeSelect.Toggle.Gamepad }
		}
	},
	ModeNext = {
		name = "ModeNextAction",
		type = Enum.InputActionType.Bool,
		bindings = {
			{ keyCode = v2.Keys.ModeSelect.Next.Keyboard },
			{ keyCode = v2.Keys.ModeSelect.Next.Gamepad }
		}
	},
	ModeAxis = {
		name = "ModeAxisAction",
		type = Enum.InputActionType.Direction1D,
		bindings = {
			{
				up = v2.Keys.ModeSelect.Axis.Up.Keyboard,
				down = v2.Keys.ModeSelect.Axis.Down.Keyboard
			},
			{ up = v2.Keys.ModeSelect.Axis.Up.Gamepad, down = v2.Keys.ModeSelect.Axis.Down.Gamepad }
		}
	}
}

local LocalPlayer = Players.LocalPlayer

if not LocalPlayer then
	Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
	LocalPlayer = Players.LocalPlayer
end

local freecam = nil

local parent2 = Workspace.CurrentCamera
Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
	local currentCamera = Workspace.CurrentCamera

	if currentCamera then
		parent2 = currentCamera
	end
end)

local v3 = nil
local v4 = nil
local v5 = nil
local v6 = nil
local v7 = nil
local v8 = nil

local v9 = {
	DepthOfField = {
		Enabled = false,
		FarIntensity = 0.75,
		NearIntensity = 0.75,
		FocusDistance = 0.05,
		InFocusRadius = 10
	},
	Bloom = { Enabled = false, Intensity = 0.4, Size = 24, Threshold = 0.95 },
	Blur = { Enabled = false, Size = 24 },
	ColorCorrection = {
		Enabled = false,
		Brightness = 0,
		Contrast = 0,
		Saturation = 0,
		TintColor = Color3.new(1, 1, 1)
	},
	SunRays = { Enabled = false, Intensity = 0.25, Spread = 1 },
	ColorGrading = { Enabled = false, TonemapperPreset = Enum.TonemapperPreset.Default }
}

local v10 = nil
local v11 = nil
local v12 = nil

local success2, result2 = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserShowGuiHideToggles")
end)

local v13 = success2 and result2

local success3, result3 = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserPlayerScriptsRefactor4")
end)

local v14 = success3 and result3

local success4, result4 = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserPlayerScriptsRefactor5")
end)

local v15 = success4 and result4

local success5, result5 = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserFreecamIASRefactor2")
end)

local v16 = success5 and result5

local success6, result6 = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserFreecamIASRefactor3")
end)

local v17 = success6 and result6

local success7, result7 = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserFreecamIASRefactor4")
end)

local v18 = success7 and result7

local function makeEffectOverride(className, fn)
	local instances = {}
	local childAddedConnection = nil
	local childAddedConnection2 = nil

	local function disable()
		for _, v19 in ipairs(instances) do
			if v19.Parent then
				v19.Enabled = true
			end
		end

		if childAddedConnection then
			childAddedConnection:Disconnect()
			childAddedConnection = nil
		end

		if childAddedConnection2 then
			childAddedConnection2:Disconnect()
			childAddedConnection2 = nil
		end

		instances = {}
	end

	local function trySuppress(child) -- 4 equivalent calls inferred from this helper
		if child:IsA(className) and child.Enabled and not (fn and fn(child)) then
			instances[#instances + 1] = child
			child.Enabled = false
		end
	end

	local function enable()
		instances = {}

		for _, child in ipairs(parent2:GetChildren()) do
			trySuppress(child) -- inferred equivalent call
		end

		for _, child in ipairs(Lighting:GetChildren()) do
			trySuppress(child) -- inferred equivalent call
		end

		childAddedConnection = parent2.ChildAdded:Connect(function(child)
			trySuppress(child) -- inferred equivalent call
		end)
		childAddedConnection2 = Lighting.ChildAdded:Connect(function(child)
			trySuppress(child) -- inferred equivalent call
		end)
	end

	return enable, disable
end

local v19 = false
local effectOverride, disable = makeEffectOverride("PostEffect", function(p): boolean
	return p.Name:sub(1, 7) == "Freecam"
end)

local v20 = nil

local function doToggleMasterEffects()
	v19 = not v19

	if v19 then
		effectOverride()
		return
	end

	disable()

	for _, v21 in ipairs(v20) do
		local v22 = v21.get()

		if v22 then
			v22.Enabled = false
		end
	end
end

local function doToggleDoF()
	if v14 and not v19 then
		return
	end

	local v21 = v3

	if v21 then
		v21.Enabled = not v21.Enabled
	end
end
local function doToggleBloom()
	if v14 and not v19 then
		return
	end

	local v21 = v4

	if v21 then
		v21.Enabled = not v21.Enabled
	end
end
local function doToggleBlur()
	if v14 and not v19 then
		return
	end

	local v21 = v5

	if v21 then
		v21.Enabled = not v21.Enabled
	end
end
local function doToggleColorCorrection()
	if v14 and not v19 then
		return
	end

	local v21 = v6

	if v21 then
		v21.Enabled = not v21.Enabled
	end
end
local function doToggleSunRays()
	if v14 and not v19 then
		return
	end

	local v21 = v7

	if v21 then
		v21.Enabled = not v21.Enabled
	end
end
local function doToggleColorGrading()
	if v14 and not v19 then
		return
	end

	local v21 = v8

	if v21 then
		v21.Enabled = not v21.Enabled
	end
end

v20 = {
	{
		key = "DepthOfField",
		class = "DepthOfFieldEffect",
		get = function()
			return v3
		end,
		set = function(p)
			v3 = p
		end,
		props = { "FarIntensity", "NearIntensity", "FocusDistance", "InFocusRadius" }
	},
	{
		key = "Bloom",
		class = "BloomEffect",
		get = function()
			return v4
		end,
		set = function(p)
			v4 = p
		end,
		props = { "Intensity", "Size", "Threshold" }
	},
	{
		key = "Blur",
		class = "BlurEffect",
		get = function()
			return v5
		end,
		set = function(p)
			v5 = p
		end,
		props = { "Size" }
	},
	{
		key = "ColorCorrection",
		class = "ColorCorrectionEffect",
		get = function()
			return v6
		end,
		set = function(p)
			v6 = p
		end,
		props = { "Brightness", "Contrast", "Saturation", "TintColor" }
	},
	{
		key = "SunRays",
		class = "SunRaysEffect",
		get = function()
			return v7
		end,
		set = function(p)
			v7 = p
		end,
		props = { "Intensity", "Spread" }
	},
	{
		key = "ColorGrading",
		class = "ColorGradingEffect",
		parent = v15 and Lighting or nil,
		get = function()
			return v8
		end,
		set = function(p)
			v8 = p
		end,
		props = { "TonemapperPreset" }
	}
}

local childAddedConnection = nil
local playerAddedConnection = nil
local playerRemovingConnection = nil

local v21 = false
local v22 = v2.PlayerLock.DefaultZoom
local v23 = v2.PlayerLock.DefaultHeight
local players = {}
local index = 1
local v24 = nil

local enabled = false
local v25 = false

local lastTime = -1e999
local lastTime2 = -1e999

local v26 = {
	movement = v2.Movement.Stiffness,
	pan = v2.Pan.Stiffness,
	fov = v2.Fov.Stiffness,
	roll = v2.Roll.Stiffness
}

local v27 = nil

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
	local v28 = self.f * 2 * 3.141592653589793
	local p3 = self.p
	local v29 = self.v
	local v30 = p2 - p3
	local v31 = exp(-v28 * p)
	local v32 = p2 + (v29 * p - v30 * (v28 * p + 1)) * v31
	local v36 = (v28 * p * (v30 * v28 - v29) + v29) * v31
	self.p = v32
	self.v = v36
	return v32
end

function class:SetFreq(p)
	self.f = p
end

function class:Reset(p)
	self.p = p
	self.v = p * 0
end

local v28 = Vector3.new()
local vector3 = Vector3.new()
local fieldOfView2 = 0

local v29 = class.new(v26.movement, (Vector3.new()))
local v30 = class.new(v26.pan, Vector2.new())
local v31 = class.new(v26.fov, 0)
local v32 = class.new(v26.roll, 0)

local v37 = {}
local v38 = {}

local v39 = { movement = 1, pan = 1, fov = 1, roll = 1 }

local v40 = false
local v41 = nil

local modeActive = false
local modeIndex = 1
local navigationStack = {}
local flag = false
local flag2 = false

local function findPlayerLockRootPart(p)
	if not players or #players < 1 then
		return nil
	end

	for _ = 1, #players do
		index = (index - 1 + p) % #players + 1
		local v43 = players[index]
		local character = v43 and v43.Character

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

local v43 = {
	{ name = "Custom", color = nil },
	{ name = "White", color = Color3.new(1, 1, 1) },
	{ name = "Warm", color = Color3.fromRGB(255, 230, 200) },
	{ name = "Cool", color = Color3.fromRGB(200, 220, 255) },
	{ name = "Red", color = Color3.new(1, 0, 0) },
	{ name = "Green", color = Color3.new(0, 1, 0) },
	{ name = "Blue", color = Color3.new(0, 0, 1) },
	{ name = "Yellow", color = Color3.new(1, 1, 0) },
	{ name = "Cyan", color = Color3.new(0, 1, 1) },
	{ name = "Magenta", color = Color3.new(1, 0, 1) },
	{ name = "Orange", color = Color3.fromRGB(255, 140, 0) },
	{ name = "Purple", color = Color3.fromRGB(128, 0, 255) }
}

local index2 = 1
local tintColor2 = Color3.new(1, 1, 1)

local function doTogglePlayerLock()
	v21 = not v21

	if v21 then
		v22 = v2.PlayerLock.DefaultZoom
		v23 = v2.PlayerLock.DefaultHeight
		v24 = findPlayerLockRootPart(0)
	end
end

local function doToggleScreenGuis()
	enabled = not enabled

	if v12 then
		for _, v45 in pairs(v12.getScreenGuis()) do
			if v45.Parent and v45 ~= freecam then
				v45.Enabled = enabled
			end
		end
	end
end

local function doToggleLeaderboard()
	v25 = not v25
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, v25)
end

local function makeEffectGroup(name, toggle, fn, options, options2)
	local modes = {
		{
			type = "toggle",
			name = "Enable",
			toggle = toggle,
			isEnabled = function()
				local v46 = fn()
				return v46 and v46.Enabled
			end
		}
	}

	for _, v46 in ipairs(options or {}) do
		modes[#modes + 1] = {
			type = "axis",
			name = v46.name,
			adj = v46.adjCfg.Adj,
			min = v46.adjCfg.Min,
			max = v46.adjCfg.Max,
			get = function()
				local v47 = fn()
				return v47 and v47[v46.prop] or 0
			end,
			set = function(p)
				local v47 = fn()

				if v47 then
					v47[v46.prop] = p
				end
			end
		}
	end

	for _, v46 in ipairs(options2 or {}) do
		modes[#modes + 1] = v46
	end

	return { type = "group", name = name, modes = modes }
end

local function makeTintChannel(p)
	if v16 then
		return {
			type = "axis",
			name = "Tint " .. p,
			adj = 64,
			min = 0,
			max = 255,
			format = "%.0f",
			get = function()
				return (v6 and v6.TintColor or tintColor2)[p] * 255
			end,
			set = function(p2)
				local tintColor = v6 and v6.TintColor or tintColor2
				local v45 = tintColor.R
				local v46 = tintColor.G
				local v47 = tintColor.B

				if p == "R" then
					v45 = p2 / 255
				elseif p == "G" then
					v46 = p2 / 255
				else
					v47 = p2 / 255
				end

				tintColor2 = Color3.new(v45, v46, v47)
				index2 = 1

				if v6 then
					v6.TintColor = tintColor2
				end
			end
		}
	end

	return {
		type = "axis",
		name = "Tint " .. p,
		adj = 0.02,
		min = 0,
		max = 1,
		get = function()
			return tintColor2[p]
		end,
		set = function(p2)
			local v45 = tintColor2.R
			local v46 = tintColor2.G
			local v47 = tintColor2.B

			if p == "R" then
				v45 = p2
			elseif p == "G" then
				v46 = p2
			else
				v47 = p2
			end

			tintColor2 = Color3.new(v45, v46, v47)
			index2 = 1

			if v6 then
				v6.TintColor = tintColor2
			end
		end
	}
end

local function buildCustomEffectsGroup()
	local customEffectsGroup = {
		type = "group",
		name = "Custom Post Processing",
		modes = {
			{
				type = "toggle",
				name = "Enable",
				toggle = doToggleMasterEffects,
				isEnabled = function()
					return v19
				end
			},
			makeEffectGroup("Depth of Field", doToggleDoF, function()
				return v3
			end, {
				{ name = "Far", adjCfg = v2.DoF.FarIntensity, prop = "FarIntensity" },
				{ name = "Near", adjCfg = v2.DoF.NearIntensity, prop = "NearIntensity" },
				{ name = "Focus Distance", adjCfg = v2.DoF.FocusDistance, prop = "FocusDistance" },
				{ name = "Focus Radius", adjCfg = v2.DoF.FocusRadius, prop = "InFocusRadius" }
			}),
			makeEffectGroup("Bloom", doToggleBloom, function()
				return v4
			end, {
				{ name = "Intensity", adjCfg = v2.Bloom.Intensity, prop = "Intensity" },
				{ name = "Size", adjCfg = v2.Bloom.Size, prop = "Size" },
				{ name = "Threshold", adjCfg = v2.Bloom.Threshold, prop = "Threshold" }
			}),
			makeEffectGroup("Blur", doToggleBlur, function()
				return v5
			end, {
				{ name = "Size", adjCfg = v2.Blur.Size, prop = "Size" }
			}),
			makeEffectGroup("Color Correction", doToggleColorCorrection, function()
				return v6
			end, {
				{ name = "Brightness", adjCfg = v2.ColorCorrection.Brightness, prop = "Brightness" },
				{ name = "Contrast", adjCfg = v2.ColorCorrection.Contrast, prop = "Contrast" },
				{ name = "Saturation", adjCfg = v2.ColorCorrection.Saturation, prop = "Saturation" }
			}, {
				{
					type = "cycle",
					name = "Tint",
					items = function()
						return v43
					end,
					getIndex = function()
						return index2
					end,
					setIndex = function(p)
						index2 = p

						if v6 then
							if p == 1 then
								v6.TintColor = tintColor2
								return
							end

							local color = v43[p].color
							v6.TintColor = color

							if not v16 then
								tintColor2 = color
							end
						end
					end,
					displayItem = function(p)
						return p.name
					end
				},
				makeTintChannel("R"),
				makeTintChannel("G"),
				makeTintChannel("B")
			}),
			makeEffectGroup("Sun Rays", doToggleSunRays, function()
				return v7
			end, {
				{ name = "Intensity", adjCfg = v2.SunRays.Intensity, prop = "Intensity" },
				{ name = "Spread", adjCfg = v2.SunRays.Spread, prop = "Spread" }
			}),
			makeEffectGroup("Color Grading", doToggleColorGrading, function()
				return v8
			end, nil, {
				{
					type = "cycle",
					name = "Tonemap",
					items = function()
						return { Enum.TonemapperPreset.Default, Enum.TonemapperPreset.Retro }
					end,
					getIndex = function(): number
						if v8 and v8.TonemapperPreset == Enum.TonemapperPreset.Retro then
							return 2
						end

						return 1
					end,
					setIndex = function(p)
						if v8 then
							local v45 = { Enum.TonemapperPreset.Default, Enum.TonemapperPreset.Retro }
							v8.TonemapperPreset = v45[p]
						end
					end,
					displayItem = function(p)
						return p.Name
					end
				}
			})
		}
	}

	if v14 then
		for i = 2, #customEffectsGroup.modes do
			customEffectsGroup.modes[i].disabled = function(): boolean
				return not v19
			end
		end
	end

	return customEffectsGroup
end

local function makeSpeedStiffnessGroup(name, data, p, p2, object)
	return {
		type = "group",
		name = name,
		modes = {
			{
				type = "axis",
				name = "Speed",
				adj = data.AdjSpeed,
				min = data.MinSpeed,
				max = data.MaxSpeed,
				get = function()
					return v39[p]
				end,
				set = function(p3)
					v39[p] = p3
				end
			},
			{
				type = "axis",
				name = "Stiffness",
				adj = data.AdjStiffness,
				min = data.MinStiffness,
				max = data.MaxStiffness,
				get = function()
					return v26[p2]
				end,
				set = function(p3)
					v26[p2] = p3
					object:SetFreq(p3)
				end
			}
		}
	}
end

local v45 = {
	buildCustomEffectsGroup(),
	{
		type = "group",
		name = "Player Lock",
		modes = {
			{
				type = "toggle",
				name = "Enable",
				toggle = doTogglePlayerLock,
				isEnabled = function()
					return v21
				end
			},
			{
				type = "cycle",
				name = "Target",
				items = function()
					return players
				end,
				getIndex = function()
					return index
				end,
				setIndex = function(p)
					index = p
					local v46 = players[p]
					local character = v46 and v46.Character

					if not character then
						v24 = nil

						return
					end

					local humanoid = character:FindFirstChildOfClass("Humanoid")
					v24 = humanoid and humanoid.RootPart or nil
				end,
				displayItem = function(p)
					return p.Name
				end
			}
		}
	},
	{
		type = "group",
		name = v17 and "UI Visibility" or "UI",
		modes = {
			{
				type = "toggle",
				name = "Screen GUIs",
				toggle = doToggleScreenGuis,
				isEnabled = function()
					return enabled
				end
			},
			{
				type = "toggle",
				name = "Leaderboard",
				toggle = doToggleLeaderboard,
				isEnabled = function()
					return v25
				end
			}
		}
	},
	makeSpeedStiffnessGroup("Movement", v2.Movement, "movement", "movement", v29),
	makeSpeedStiffnessGroup("Field of View", v2.Fov, "fov", "fov", v31),
	makeSpeedStiffnessGroup(v17 and "Roll" or "Tilt", v2.Roll, "roll", "roll", v32),
	makeSpeedStiffnessGroup(v17 and "Rotation" or "Pan", v2.Pan, "pan", "pan", v30)
}

local modes2 = v17 and { v45[4], v45[7], v45[6], v45[5], v45[1], v45[2], v45[3] } or v45
local isDisabled, nextEnabledIndex

if v14 then
	isDisabled = function(p)
		return p.disabled and p.disabled()
	end

	nextEnabledIndex = function(list, p, p2)
		local count = #list

		for _ = 1, count do
			p = (p - 1 + p2) % count + 1

			if not isDisabled(list[p]) then
				return p
			end
		end

		return p
	end
else
	nextEnabledIndex = nil
	isDisabled = nil
end

local function currentMode() -- 6 equivalent calls inferred from this helper
	if #navigationStack > 0 then
		local v47 = navigationStack[#navigationStack]
		return v47.modes[v47.index]
	end

	return modes2[modeIndex]
end

local function createBinding(inputAction, binding)
	local inputBinding = Instance.new("InputBinding")

	if binding.keyCode then
		inputBinding.KeyCode = binding.keyCode
	end

	if binding.up then
		inputBinding.Up = binding.up
	end

	if binding.down then
		inputBinding.Down = binding.down
	end

	if binding.left then
		inputBinding.Left = binding.left
	end

	if binding.right then
		inputBinding.Right = binding.right
	end

	if binding.scale then
		inputBinding.Scale = binding.scale
	end

	if binding.vector2Scale then
		inputBinding.Vector2Scale = binding.vector2Scale
	end

	if binding.responseCurve then
		inputBinding.ResponseCurve = binding.responseCurve
	end

	if binding.primaryModifier then
		inputBinding.PrimaryModifier = binding.primaryModifier
	end

	inputBinding.Parent = inputAction
	return inputBinding
end

local function createAction(parent, data)
	local inputAction = Instance.new("InputAction")
	inputAction.Name = data.name
	inputAction.Type = data.type
	inputAction.Parent = parent

	for _, binding in ipairs(data.bindings) do
		createBinding(inputAction, binding)
	end

	return inputAction
end

local function makeDoubleTapHandler(threshold, debounce, fn) -- 1 equivalent call inferred from this helper
	local v47 = nil
	local v48 = 0
	local function detect(p)
		if math.abs(p) > 0.01 then
			local now = os.clock()

			if v47 == nil or not (now - v47 <= threshold) then
				v47 = now
			else
				if debounce <= now - v48 then
					fn()
					v48 = now
				end

				v47 = nil
			end
		end
	end
	local function reset()
		v47 = nil
	end
	return detect, reset
end

local function createIASContexts()
	local actions = v2.Actions
	local freecamInput

	if v18 then
		freecamInput = Instance.new("Folder")
		freecamInput.Name = "FreecamInput"
		freecamInput.Parent = StarterPlayer
		script.Destroying:Connect(function()
			freecamInput:Destroy()
		end)
	else
		freecamInput = script
	end

	local freecamToggleContext = Instance.new("InputContext")
	freecamToggleContext.Name = "FreecamToggleContext"
	freecamToggleContext.Priority = 3000
	freecamToggleContext.Sink = false
	freecamToggleContext.Enabled = true
	freecamToggleContext.Parent = freecamInput
	v27 = createAction(freecamToggleContext, actions.Toggle)

	local freecamInputContext = Instance.new("InputContext")
	freecamInputContext.Name = "FreecamInputContext"
	freecamInputContext.Priority = 2000
	freecamInputContext.Sink = true
	freecamInputContext.Enabled = false
	freecamInputContext.Parent = freecamInput
	v37._sinkContext = freecamInputContext

	v38.Pan = createAction(freecamInputContext, actions.Pan)
	v38.MovementMove = createAction(freecamInputContext, actions.MovementMove)
	v38.MovementElevate = createAction(freecamInputContext, actions.MovementElevate)
	v38.Fov = createAction(freecamInputContext, actions.Fov)
	v38.Shift = createAction(freecamInputContext, actions.Shift)

	local action = createAction(freecamInputContext, actions.Tilt)
	v38.Tilt = action

	local threshold = v2.DoubleTap.Threshold
	local debounce = v2.DoubleTap.Debounce
	local function fn()
		vector3 = Vector3.new(vector3.x, vector3.y, 0)
		v32:Reset(0)
		v40 = true
	end

	local detect, reset = makeDoubleTapHandler(threshold, debounce, fn) -- inferred equivalent call
	v41 = reset

	action.StateChanged:Connect(function(p: number)
		if not v40 then
			detect(p)
		elseif math.abs(p) < 0.01 then
			v40 = false
		end
	end)

	createAction(freecamInputContext, actions.ModeToggle).StateChanged:Connect(function(flag3: boolean)
		if not flag3 then
			return
		end

		if v14 then
			if not modeActive then
				modeActive = true
			elseif flag2 then
				flag2 = false
			elseif #navigationStack > 0 then
				local v48 = navigationStack[#navigationStack]
				local v49 = nextEnabledIndex(v48.modes, v48.index, -1)

				if v49 < v48.index then
					v48.index = v49
				else
					navigationStack[#navigationStack] = nil
				end
			else
				local v48 = nextEnabledIndex(modes2, modeIndex, -1)

				if v48 < modeIndex then
					modeIndex = v48
				else
					modeActive = false
				end
			end
		elseif not modeActive then
			modeActive = true
		elseif flag then
			flag = false
		elseif #navigationStack > 0 then
			navigationStack[#navigationStack] = nil
		else
			modeActive = false
		end
	end)

	createAction(freecamInputContext, actions.ModeNext).StateChanged:Connect(function(flag3: boolean)
		if not flag3 then
			return
		end

		if v14 then
			if not modeActive then
				modeActive = true
			elseif flag2 then
				flag2 = false
			elseif #navigationStack > 0 then
				local v48 = navigationStack[#navigationStack]
				v48.index = nextEnabledIndex(v48.modes, v48.index, 1)
			else
				modeIndex = nextEnabledIndex(modes2, modeIndex, 1)
			end
		else
			if not modeActive or flag then
				return
			end

			if #navigationStack > 0 then
				local v48 = navigationStack[#navigationStack]
				v48.index = v48.index % #v48.modes + 1
			else
				local v48 = modes2[modeIndex]

				if v48.type == "group" then
					table.insert(navigationStack, {
						modes = v48.modes,
						index = 1,
						groupName = v48.name
					})
				elseif v48.type == "toggle" then
					v48.toggle()
				elseif v48.type == "cycle" then
					local items = v48.items()

					if #items > 0 then
						v48.setIndex(v48.getIndex() % #items + 1)
					end
				elseif v48.type == "action" then
					v48.action()
				elseif v48.type == "axis" then
					flag = true
				end
			end
		end
	end)

	local action2 = createAction(freecamInputContext, actions.ModeAxis)
	action2.StateChanged:Connect(function(p: number)
		if not modeActive or p == 0 then
			return
		end

		if v14 then
			local v48 = currentMode() -- inferred equivalent call

			if flag2 then
				if v48.type == "toggle" then
					v48.toggle()
				elseif v48.type == "cycle" then
					local items = v48.items()

					if #items > 0 then
						if p > 0 then
							v48.setIndex(v48.getIndex() % #items + 1)
						else
							v48.setIndex((v48.getIndex() - 2) % #items + 1)
						end
					end
				elseif v48.type == "action" then
					v48.action()
				elseif v48.type == "axis" then
					return
				end
			elseif p > 0 then
				if isDisabled(v48) then
					return
				end

				if v48.type == "group" then
					table.insert(navigationStack, {
						modes = v48.modes,
						index = 1,
						groupName = v48.name
					})
				elseif v48.type == "action" then
					v48.action()
				else
					flag2 = true
				end
			elseif p < 0 then
				flag2 = false

				if #navigationStack > 0 then
					navigationStack[#navigationStack] = nil
				else
					modeActive = false
				end
			end
		else
			if flag then
				return
			end

			if #navigationStack > 0 then
				local v48 = currentMode() -- inferred equivalent call

				if v48.type == "group" then
					table.insert(navigationStack, {
						modes = v48.modes,
						index = 1,
						groupName = v48.name
					})
				elseif v48.type == "toggle" then
					v48.toggle()
				elseif v48.type == "cycle" then
					local items = v48.items()

					if #items == 0 then
						return
					end

					if p > 0 then
						v48.setIndex(v48.getIndex() % #items + 1)
					elseif p < 0 then
						v48.setIndex((v48.getIndex() - 2) % #items + 1)
					end
				elseif v48.type == "action" then
					v48.action()
				end
			elseif p > 0 then
				modeIndex = modeIndex % #modes2 + 1
			elseif p < 0 then
				modeIndex = (modeIndex - 2) % #modes2 + 1
			end
		end
	end)
	v38.ModeAxis = action2
end

createIASContexts()

function v37.Movement()
	local state = v38.MovementMove:GetState()
	return Vector3.new(state.X, v38.MovementElevate:GetState(), state.Y) * (v39.movement * (v38.Shift:GetState() and v2.Movement.ShiftMul or 1))
end

function v37.Pan()
	local state = v38.Pan:GetState()
	return Vector2.new(state.Y, -state.X) * v39.pan
end

function v37.Fov()
	return v38.Fov:GetState() * v39.fov
end

function v37.Roll()
	return (v40 and 0 or v38.Tilt:GetState()) * v39.roll
end

function v37.ModeControl(p)
	if not modeActive then
		return
	end

	if v14 then
		if not flag2 then
			return
		end
	elseif #navigationStack == 0 and not flag then
		return
	end

	local v47 = currentMode() -- inferred equivalent call

	if v47.type ~= "axis" then
		return
	end

	local v48 = v38.ModeAxis:GetState() * v47.adj * p

	if v48 ~= 0 then
		v47.set((clamp(v47.get() + v48, v47.min, v47.max)))
	end
end

function v37.StartCapture()
	v37._sinkContext.Enabled = true
end

function v37.StopCapture()
	v37._sinkContext.Enabled = false
	v40 = false

	if v41 then
		v41()
	end

	modeActive = false

	if v14 then
		table.clear(navigationStack)
		flag2 = false
	else
		navigationStack = {}
	end

	flag = false
end

function v37.getModeActive()
	return modeActive
end

function v37.getModeName()
	return currentMode().name -- inferred equivalent call
end

function v37.getModeBreadcrumb()
	if #navigationStack == 0 then
		return ""
	end

	local groupNames = {}

	for _, v47 in ipairs(navigationStack) do
		table.insert(groupNames, v47.groupName)
	end

	return table.concat(groupNames, " › ")
end

function v37.getModeDisplay()
	local v47 = currentMode() -- inferred equivalent call

	if v47.type == "group" then
		return ""
	end

	if v47.type == "axis" then
		return string.format(v16 and v47.format or "%.2f", v47.get())
	end

	if v47.type == "toggle" then
		return if v47.isEnabled() then "ON" else "OFF"
	elseif v47.type == "cycle" then
		local items = v47.items()

		if #items == 0 then
			return "None"
		end

		local item = items[v47.getIndex()]
		return item and v47.displayItem(item) or "None"
	else
		return if v47.type == "action" then "(fire)" else ""
	end
end

function v37.getModeHint()
	local v47 = modes2[modeIndex]

	local function lrVerb(kind): nil | string -- 2 equivalent calls inferred from this helper
		if kind == "axis" then
			return "Hold to adjust"
		elseif kind == "toggle" then
			return "Tap to flip"
		elseif kind == "cycle" then
			return "Tap to cycle"
		elseif kind == "action" then
			return "Tap to fire"
		elseif kind == "group" then
			return "Enter"
		end

		return nil
	end

	if #navigationStack > 0 then
		local v48 = navigationStack[#navigationStack]
		local v49 = v48.index % #v48.modes + 1
		local nav = "[↑] Back  [↓] " .. v48.modes[v49].name
		local v51 = lrVerb(currentMode().type) -- inferred equivalent call
		return {
			nav = nav,
			action = v51 and "[←][→] " .. v51 or ""
		}
	elseif flag then
		local v48 = lrVerb(v47.type) -- inferred equivalent call
		return {
			nav = "[↑] Back",
			action = v48 and "[←][→] " .. v48 or ""
		}
	else
		local kind = v47.type
		local v48

		if kind == "group" then
			v48 = "Enter"
		elseif kind == "toggle" then
			v48 = "Flip"
		elseif kind == "cycle" then
			v48 = "Cycle"
		elseif kind == "action" then
			v48 = "Fire"
		elseif kind == "axis" then
			v48 = "Adjust"
		else
			v48 = "Select"
		end

		local name = modes2[(modeIndex - 2) % #modes2 + 1].name
		local name2 = modes2[modeIndex % #modes2 + 1].name
		return {
			nav = "[↑] Close  [↓] " .. v48,
			action = "[←] " .. name .. "  [→] " .. name2
		}
	end
end

function v37.getTintColorName()
	if index2 >= 1 and index2 <= #v43 then
		return v43[index2].name
	end

	return "Custom"
end

function v37.getActiveGroupName()
	if modeActive and #navigationStack ~= 0 then
		return navigationStack[1].groupName
	end

	return nil
end

if v14 then
	v37._navigationStack = navigationStack
	v37._modes = modes2
	function v37._getModeIndex()
		return modeIndex
	end
	function v37._isMonitorItemSelected()
		return flag2
	end
end

local v47 = {
	{
		get = function()
			return v4
		end,
		key = "bloom",
		group = "Custom Post Processing",
		fmt = function(data)
			return string.format(
				"Intensity: %.2f  Size: %.1f\nThreshold: %.2f",
				data.Intensity,
				data.Size,
				data.Threshold
			)
		end
	},
	{
		get = function()
			return v5
		end,
		key = "blur",
		group = "Custom Post Processing",
		fmt = function(p)
			return string.format("Size: %.1f", p.Size)
		end
	},
	{
		get = function()
			return v6
		end,
		key = "cc",
		group = "Custom Post Processing",
		fmt = function(data)
			return string.format(
				"Brightness: %.2f  Contrast: %.2f\nSaturation: %.2f  Tint: %s",
				data.Brightness,
				data.Contrast,
				data.Saturation,
				v37.getTintColorName()
			)
		end
	},
	{
		get = function()
			return v7
		end,
		key = "sunrays",
		group = "Custom Post Processing",
		fmt = function(p)
			return string.format("Intensity: %.2f  Spread: %.2f", p.Intensity, p.Spread)
		end
	},
	{
		get = function()
			return v8
		end,
		key = "colorgrading",
		group = "Custom Post Processing",
		fmt = function(p)
			return string.format("Color Grading: %s", p.TonemapperPreset.Name)
		end
	},
	{
		get = function()
			return v3
		end,
		key = "dof",
		group = "Custom Post Processing",
		fmt = function(data)
			return string.format(
				"Far: %.2f  Near: %.2f\nDistance: %.1f  Radius: %.1f",
				data.FarIntensity,
				data.NearIntensity,
				data.FocusDistance,
				data.InFocusRadius
			)
		end
	}
}

local function setBubble(p, text) -- 3 equivalent calls inferred from this helper
	p.bubble.Visible = text ~= ""

	if text ~= "" then
		p.label.Text = text
	end
end

local v48 = nil
local fn, fn2

if v14 then
	local v49 = {}
	local v50 = 12

	fn = function(parent)
		local freecamMonitorPanel = Instance.new("Frame")
		freecamMonitorPanel.Name = "FreecamMonitorPanel"
		freecamMonitorPanel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		freecamMonitorPanel.BackgroundTransparency = 0.2
		freecamMonitorPanel.BorderSizePixel = 0
		freecamMonitorPanel.Size = UDim2.new(0, 240, 0, 0)
		freecamMonitorPanel.AutomaticSize = Enum.AutomaticSize.Y
		freecamMonitorPanel.AnchorPoint = Vector2.new(1, 1)
		freecamMonitorPanel.Position = UDim2.new(1, -16, 1, -16)
		freecamMonitorPanel.Visible = false

		local uiCorner = Instance.new("UICorner")
		uiCorner.CornerRadius = UDim.new(0, 8)
		uiCorner.Parent = freecamMonitorPanel

		local uiPadding = Instance.new("UIPadding")
		uiPadding.PaddingTop = UDim.new(0, 8)
		uiPadding.PaddingBottom = UDim.new(0, 8)
		uiPadding.PaddingLeft = UDim.new(0, 12)
		uiPadding.PaddingRight = UDim.new(0, 12)
		uiPadding.Parent = freecamMonitorPanel

		local uiListLayout = Instance.new("UIListLayout")
		uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		uiListLayout.FillDirection = Enum.FillDirection.Vertical
		uiListLayout.Padding = UDim.new(0, 1)
		uiListLayout.Parent = freecamMonitorPanel

		local breadcrumb = Instance.new("TextLabel")
		breadcrumb.Name = "Breadcrumb"
		breadcrumb.BackgroundTransparency = 1
		breadcrumb.TextColor3 = Color3.fromRGB(150, 150, 150)
		breadcrumb.Font = Enum.Font.GothamMedium
		breadcrumb.TextSize = 11
		breadcrumb.TextXAlignment = Enum.TextXAlignment.Left
		breadcrumb.Size = UDim2.new(1, 0, 0, 16)
		breadcrumb.LayoutOrder = 0
		breadcrumb.Visible = false
		breadcrumb.Parent = freecamMonitorPanel

		v49 = {}

		for i = 1, v50 do
			local frame = Instance.new("Frame")
			frame.Name = "Row" .. i
			frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			frame.BackgroundTransparency = 1
			frame.BorderSizePixel = 0
			frame.Size = UDim2.new(1, 0, 0, 22)
			frame.LayoutOrder = i
			frame.Visible = false

			local uiCorner2 = Instance.new("UICorner")
			uiCorner2.CornerRadius = UDim.new(0, 4)
			uiCorner2.Parent = frame

			local uiPadding2 = Instance.new("UIPadding")
			uiPadding2.PaddingLeft = UDim.new(0, 6)
			uiPadding2.PaddingRight = UDim.new(0, 6)
			uiPadding2.Parent = frame

			local name = Instance.new("TextLabel")
			name.Name = "Name"
			name.BackgroundTransparency = 1
			name.TextColor3 = Color3.new(1, 1, 1)
			name.Font = Enum.Font.GothamMedium
			name.TextSize = 14
			name.TextXAlignment = Enum.TextXAlignment.Left
			name.Size = UDim2.new(0.55, 0, 1, 0)
			name.Position = UDim2.new(0, 0, 0, 0)
			name.Parent = frame

			local valueLabel = Instance.new("TextLabel")
			valueLabel.Name = "Value"
			valueLabel.BackgroundTransparency = 1
			valueLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
			valueLabel.Font = Enum.Font.GothamMedium
			valueLabel.TextSize = 14
			valueLabel.TextXAlignment = Enum.TextXAlignment.Right
			valueLabel.Size = UDim2.new(0.45, 0, 1, 0)
			valueLabel.Position = UDim2.new(0.55, 0, 0, 0)
			valueLabel.Parent = frame

			frame.Parent = freecamMonitorPanel
			v49[i] = { frame = frame, nameLabel = name, valueLabel = valueLabel }
		end

		local hint = Instance.new("TextLabel")
		hint.Name = "Hint"
		hint.BackgroundTransparency = 1
		hint.TextColor3 = Color3.fromRGB(120, 120, 120)
		hint.Font = Enum.Font.Gotham
		hint.TextSize = 12
		hint.TextXAlignment = Enum.TextXAlignment.Left
		hint.Size = UDim2.new(1, 0, 0, 20)
		hint.LayoutOrder = v50 + 1
		hint.Parent = freecamMonitorPanel

		freecamMonitorPanel.Parent = parent
		v48 = { panel = freecamMonitorPanel, breadcrumb = breadcrumb, hint = hint }
	end

	local function fn3(mode)
		if mode.type == "group" then
			return "›"
		end

		if mode.type == "toggle" then
			return if mode.isEnabled() then "On" else "Off"
		end

		if mode.type == "axis" then
			return string.format(v16 and mode.format or "%.2f", mode.get())
		end

		if mode.type == "cycle" then
			local items = mode.items()

			if #items == 0 then
				return "--"
			end

			local item = items[mode.getIndex()]
			return item and mode.displayItem(item) or "--"
		end

		if mode.type == "action" then
		end

		return ""
	end

	local function fn4(mode, p, monitorItemSelected)
		if mode.type == "toggle" then
			if mode.isEnabled() then
				return Color3.fromRGB(0, 176, 111)
			end

			return Color3.fromRGB(150, 150, 150)
		elseif p and monitorItemSelected then
			return Color3.new(1, 1, 1)
		else
			return Color3.fromRGB(180, 180, 180)
		end
	end

	fn2 = function()
		if not v48 then
			return
		end

		local panel = v48.panel

		if not v37.getModeActive() then
			panel.Visible = false
			return
		end

		panel.Visible = true
		local modes, v51

		if #v37._navigationStack > 0 then
			local v52 = v37._navigationStack[#v37._navigationStack]
			modes = v52.modes
			v51 = v52.index
		else
			modes = v37._modes
			v51 = v37._getModeIndex()
		end

		local modeBreadcrumb = v37.getModeBreadcrumb()
		v48.breadcrumb.Text = modeBreadcrumb
		v48.breadcrumb.Visible = modeBreadcrumb ~= ""

		local monitorItemSelected = v37._isMonitorItemSelected()
		local v52 = math.min(#modes, v50)

		for i = 1, v50 do
			local v53 = v49[i]

			if i <= v52 then
				local mode = modes[i]
				local v54 = i == v51
				local v55 = mode.disabled and mode.disabled()
				v53.frame.Visible = true

				if v54 and not v55 then
					v53.nameLabel.Text = "> " .. mode.name
					v53.nameLabel.TextColor3 = Color3.new(1, 1, 1)
					v53.nameLabel.Font = Enum.Font.GothamMedium
					v53.frame.BackgroundTransparency = monitorItemSelected and 0.88 or 1
				else
					if v55 then
						v53.nameLabel.Text = "  " .. mode.name
						v53.nameLabel.TextColor3 = Color3.fromRGB(80, 80, 80)
					else
						v53.nameLabel.Text = "  " .. mode.name
						v53.nameLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
					end

					v53.nameLabel.Font = Enum.Font.GothamMedium
					v53.frame.BackgroundTransparency = 1
				end

				v53.valueLabel.Text = fn3(mode)
				v53.valueLabel.TextColor3 = v55 and Color3.fromRGB(60, 60, 60) or fn4(mode, v54, monitorItemSelected)
			else
				v53.frame.Visible = false
			end
		end

		if not monitorItemSelected then
			v48.hint.Text = "↑↓ Navigate   → Select   ← Back"
		elseif v17 then
			v48.hint.Text = "↑↓ Exit selection   ←→ Adjust"
		else
			v48.hint.Text = "←→ Adjust   ↑↓ Exit selection"
		end
	end
else
	fn2 = nil
	fn = nil
end

local function StepFreecam(p)
	v37.ModeControl(p)

	local v49 = v29:Update(p, v37.Movement())
	local v50 = v30:Update(p, v37.Pan())
	local v51 = v31:Update(p, v37.Fov())
	local v52 = v32:Update(p, v37.Roll())

	local v53 = sqrt(0.7002075382097097 / tan((rad(fieldOfView2 / 2))))

	local v54 = fieldOfView2
	fieldOfView2 = clamp(fieldOfView2 + v51 * v2.Fov.Gain * (p / v53), 1, 120)

	if math.abs(fieldOfView2 - v54) > 0.01 then
		lastTime = os.clock()
	end

	if v49.Magnitude > 0.05 or v50.Magnitude > 0.0005 or math.abs(v52) > 0.0005 or math.abs(v51) > 0.0005 then
		lastTime2 = os.clock()
	end

	local v55 = v50 * v2.Pan.Gain * (p / v53)
	vector3 += Vector3.new(v55.X, v55.Y, v52 * v2.Roll.Gain * (p / v53))
	local function wrapAngle(p2) -- 3 equivalent calls inferred from this helper
		local v56 = p2 % 6.283185307179586
		return v56 > 3.141592653589793 and v56 - 6.283185307179586 or v56
	end

	vector3 = Vector3.new(wrapAngle(vector3.x), wrapAngle(vector3.y), wrapAngle(vector3.z)) -- inferred equivalent call
	local vector3_2 = Vector3.new(v49.X, v49.Y, -v49.Z)
	local v56 = CFrame.new(v28) * CFrame.fromOrientation(vector3.x, vector3.y, vector3.z) * CFrame.new(vector3_2 * v2.Movement.Gain * p)

	if v21 and v24 and v24.Parent then
		local playerLock = v2.PlayerLock
		local v57 = -v49.Z * v2.Movement.Gain.Z * p
		local v58 = v49.Y * v2.Movement.Gain.Y * p
		v22 = clamp(v22 + v57, playerLock.MinZoom, playerLock.MaxZoom)
		v23 = clamp(v23 + v58, -playerLock.HeightRange, playerLock.HeightRange)
		v56 = CFrame.new(v24.Position + Vector3.new(0, v23, 0)) * CFrame.fromOrientation(vector3.x, vector3.y, vector3.z) * CFrame.new(0, 0, v22)
	end

	if v14 then
		fn2()
	elseif v10 and v10.Parent and v11 and freecam and freecam.Parent then
		local mode = v11.mode

		if v37.getModeActive() then
			if os.clock() - lastTime2 < 2 then
				local v57 = {}
				v57[#v57 + 1] = string.format("X: %.0f  Y: %.0f  Z: %.0f", v28.X, v28.Y, v28.Z)
				v57[#v57 + 1] = string.format(
					"Pitch: %.1f°  Yaw: %.1f°  Roll: %.1f°",
					math.deg(vector3.X),
					math.deg(vector3.Y),
					(math.deg(vector3.Z))
				)

				if os.clock() - lastTime < 2 then
					v57[#v57 + 1] = string.format("Field of View: %.1f", fieldOfView2)
				end

				if p > 0 then
					local v58 = (v56.p - v28).Magnitude / p

					if v58 > 0.5 then
						v57[#v57 + 1] = string.format("Speed: %.1f", v58)
					end
				end

				setBubble(v11.status, table.concat(v57, "\n")) -- inferred equivalent call
			else
				v11.status.bubble.Visible = false
			end

			if v21 and #players > 0 and v37.getActiveGroupName() ~= "Player Lock" then
				setBubble(v11.lock, string.format("Lock: %s", players[index].Name)) -- inferred equivalent call
			else
				v11.lock.bubble.Visible = false
			end

			local activeGroupName = v37.getActiveGroupName()

			for _, v57 in ipairs(v47) do
				local v58 = v57.get()

				if v58 and v58.Enabled and activeGroupName ~= v57.group then
					setBubble(v11[v57.key], v57.fmt(v58)) -- inferred equivalent call
				else
					v11[v57.key].bubble.Visible = false
				end
			end

			mode.bubble.Visible = true
			local modeBreadcrumb = v37.getModeBreadcrumb()
			mode.breadcrumb.Text = modeBreadcrumb
			mode.breadcrumb.Visible = modeBreadcrumb ~= ""
			local text = v37.getModeName()
			local modeDisplay = v37.getModeDisplay()
			local title = mode.title
			text = modeDisplay ~= "" and text .. ": " .. modeDisplay or text
			title.Text = text
			local modeHint = v37.getModeHint()
			mode.nav.Text = modeHint.nav
			mode.nav.Visible = modeHint.nav ~= ""
			mode.action.Text = modeHint.action
			mode.action.Visible = modeHint.action ~= ""

			v10.Visible = true
		else
			v10.Visible = false
		end
	end

	v28 = v56.p
	parent2.CFrame = v56
	parent2.Focus = v56
	parent2.FieldOfView = fieldOfView2
end

v12 = {}

local default = nil
local mouseIconEnabled = nil
local cameraType = nil
local focus = nil
local cframe = nil
local fieldOfView = nil
local screenGuis = {}
local coreGuiEnableds = { Backpack = true, Chat = true, Health = true, PlayerList = true }

local cores = { BadgesNotificationsActive = true, PointsNotificationsActive = true }

function v12.Push()
	for k in pairs(coreGuiEnableds) do
		coreGuiEnableds[k] = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType[k])
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType[k], false)
	end

	for k in pairs(cores) do
		cores[k] = StarterGui:GetCore(k)
		StarterGui:SetCore(k, false)
	end

	local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")

	if playerGui then
		for _, screenGui in pairs(playerGui:GetChildren()) do
			if not (screenGui:IsA("ScreenGui") and screenGui.Enabled) then
				continue
			end

			screenGuis[#screenGuis + 1] = screenGui
			screenGui.Enabled = false
		end

		childAddedConnection = playerGui.ChildAdded:Connect(function(screenGui)
			if screenGui:IsA("ScreenGui") and screenGui.Enabled then
				screenGuis[#screenGuis + 1] = screenGui
				screenGui.Enabled = enabled
			end
		end)
	end

	fieldOfView = parent2.FieldOfView
	parent2.FieldOfView = 70

	cameraType = parent2.CameraType
	parent2.CameraType = Enum.CameraType.Custom

	cframe = parent2.CFrame
	focus = parent2.Focus

	mouseIconEnabled = UserInputService.MouseIconEnabled
	UserInputService.MouseIconEnabled = false

	default = Enum.MouseBehavior.Default
	UserInputService.MouseBehavior = Enum.MouseBehavior.Default
end

function v12.Pop()
	for k, v49 in pairs(coreGuiEnableds) do
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType[k], v49)
	end

	for k, v49 in pairs(cores) do
		StarterGui:SetCore(k, v49)
	end

	for _, v49 in pairs(screenGuis) do
		if v49.Parent and v49 ~= freecam then
			v49.Enabled = true
		end
	end

	if childAddedConnection then
		childAddedConnection:Disconnect()
		childAddedConnection = nil
	end

	screenGuis = {}

	parent2.FieldOfView = fieldOfView
	fieldOfView = nil
	parent2.CameraType = cameraType
	cameraType = nil
	parent2.CFrame = cframe
	cframe = nil
	parent2.Focus = focus
	focus = nil

	UserInputService.MouseIconEnabled = mouseIconEnabled
	mouseIconEnabled = nil
	UserInputService.MouseBehavior = default
	default = nil
end

function v12.getScreenGuis()
	return screenGuis
end

local function removePlayerFromList(p)
	for i, v49 in ipairs(players) do
		if v49 ~= p then
			continue
		end

		table.remove(players, i)

		if index == i and v21 then
			v21 = false
			index = 1
		end

		if i < index then
			index -= 1
		end

		if index > #players or index < 1 then
			index = 1
			break
		end

		break
	end
end

local function initializePlayerList()
	players = Players:GetPlayers()

	for i, v49 in ipairs(players) do
		if v49 == LocalPlayer then
			index = i
			break
		end
	end

	playerAddedConnection = Players.PlayerAdded:Connect(function(player)
		table.insert(players, player)
	end)
	playerRemovingConnection = Players.PlayerRemoving:Connect(removePlayerFromList)
end

local function StartFreecam()
	initializePlayerList()

	local cframe2 = parent2.CFrame
	vector3 = Vector3.new(cframe2:toEulerAnglesYXZ())
	v28 = cframe2.p
	fieldOfView2 = parent2.FieldOfView

	v29:Reset((Vector3.new()))
	v30:Reset(Vector2.new())
	v31:Reset(0)
	v32:Reset(0)

	freecam = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Freecam")

	if v14 then
		if not v48 then
			fn(freecam)
		end
	elseif not (v10 and v10.Parent) then
		local freecamCustomGui = Instance.new("Frame")
		freecamCustomGui.Name = "FreecamCustomGui"
		freecamCustomGui.BackgroundTransparency = 1
		freecamCustomGui.AutomaticSize = Enum.AutomaticSize.XY
		freecamCustomGui.AnchorPoint = Vector2.new(1, 1)
		freecamCustomGui.Position = UDim2.new(1, -16, 1, -16)
		freecamCustomGui.Size = UDim2.new(0, 0, 0, 0)
		freecamCustomGui.Visible = false

		local uiListLayout = Instance.new("UIListLayout")
		uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		uiListLayout.FillDirection = Enum.FillDirection.Vertical
		uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
		uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
		uiListLayout.Padding = UDim.new(0, 6)
		uiListLayout.Parent = freecamCustomGui

		local function makeBubble(name, layoutOrder)
			local frame = Instance.new("Frame")
			frame.Name = name
			frame.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
			frame.BackgroundTransparency = 0.4
			frame.BorderSizePixel = 0
			frame.AutomaticSize = Enum.AutomaticSize.XY
			frame.Size = UDim2.new(0, 0, 0, 0)
			frame.LayoutOrder = layoutOrder
			frame.Visible = false
			local uiCorner = Instance.new("UICorner")
			uiCorner.CornerRadius = UDim.new(0, 8)
			uiCorner.Parent = frame
			local uiPadding = Instance.new("UIPadding")
			uiPadding.PaddingTop = UDim.new(0, 8)
			uiPadding.PaddingBottom = UDim.new(0, 8)
			uiPadding.PaddingLeft = UDim.new(0, 12)
			uiPadding.PaddingRight = UDim.new(0, 12)
			uiPadding.Parent = frame
			local label = Instance.new("TextLabel")
			label.Name = "Label"
			label.BackgroundTransparency = 1
			label.TextColor3 = Color3.new(1, 1, 1)
			label.Font = Enum.Font.GothamMedium
			label.TextSize = 14
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.AutomaticSize = Enum.AutomaticSize.XY
			label.Size = UDim2.new(0, 0, 0, 0)
			label.Parent = frame
			frame.Parent = freecamCustomGui
			return frame, label
		end

		local bubble, label = makeBubble("BloomBubble", 1)
		local bubble2, label2 = makeBubble("BlurBubble", 2)
		local bubble3, label3 = makeBubble("CCBubble", 3)
		local bubble4, label4 = makeBubble("SunRaysBubble", 4)
		local bubble5, label5 = makeBubble("ColorGradingBubble", 5)
		local bubble6, label6 = makeBubble("DofBubble", 6)
		local bubble7, label7 = makeBubble("LockBubble", 7)
		local bubble8, label8 = makeBubble("StatusBubble", 8)

		local modeBubble = Instance.new("Frame")
		modeBubble.Name = "ModeBubble"
		modeBubble.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
		modeBubble.BackgroundTransparency = 0.4
		modeBubble.BorderSizePixel = 0
		modeBubble.AutomaticSize = Enum.AutomaticSize.XY
		modeBubble.Size = UDim2.new(0, 0, 0, 0)
		modeBubble.LayoutOrder = 9
		modeBubble.Visible = false
		local uiCorner = Instance.new("UICorner")
		uiCorner.CornerRadius = UDim.new(0, 8)
		uiCorner.Parent = modeBubble
		local uiPadding = Instance.new("UIPadding")
		uiPadding.PaddingTop = UDim.new(0, 8)
		uiPadding.PaddingBottom = UDim.new(0, 8)
		uiPadding.PaddingLeft = UDim.new(0, 12)
		uiPadding.PaddingRight = UDim.new(0, 12)
		uiPadding.Parent = modeBubble
		local uiListLayout2 = Instance.new("UIListLayout")
		uiListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
		uiListLayout2.FillDirection = Enum.FillDirection.Vertical
		uiListLayout2.Padding = UDim.new(0, 2)
		uiListLayout2.Parent = modeBubble
		local function makeModeLabel(name, layoutOrder, font, textSize, textColor)
			local textLabel = Instance.new("TextLabel")
			textLabel.Name = name
			textLabel.BackgroundTransparency = 1
			textLabel.TextColor3 = textColor
			textLabel.Font = font
			textLabel.TextSize = textSize
			textLabel.TextXAlignment = Enum.TextXAlignment.Left
			textLabel.AutomaticSize = Enum.AutomaticSize.XY
			textLabel.Size = UDim2.new(0, 0, 0, 0)
			textLabel.LayoutOrder = layoutOrder
			textLabel.Parent = modeBubble
			return textLabel
		end

		local modeLabel = makeModeLabel("Breadcrumb", 1, Enum.Font.Gotham, 11, Color3.fromRGB(100, 100, 100))
		local modeLabel2 = makeModeLabel("Title", 2, Enum.Font.GothamBold, 14, Color3.new(1, 1, 1))
		local modeLabel3 = makeModeLabel("NavHint", 3, Enum.Font.Gotham, 12, Color3.fromRGB(120, 120, 120))
		local modeLabel4 = makeModeLabel("ActionHint", 4, Enum.Font.GothamMedium, 12, Color3.fromRGB(200, 200, 200))
		modeBubble.Parent = freecamCustomGui

		v10 = freecamCustomGui
		v11 = {
			bloom = { bubble = bubble, label = label },
			blur = { bubble = bubble2, label = label2 },
			cc = { bubble = bubble3, label = label3 },
			sunrays = { bubble = bubble4, label = label4 },
			colorgrading = { bubble = bubble5, label = label5 },
			dof = { bubble = bubble6, label = label6 },
			lock = { bubble = bubble7, label = label7 },
			status = { bubble = bubble8, label = label8 },
			mode = {
				bubble = modeBubble,
				breadcrumb = modeLabel,
				title = modeLabel2,
				nav = modeLabel3,
				action = modeLabel4
			}
		}

		freecamCustomGui.Parent = freecam
	end

	v12.Push()
	freecam.Enabled = true

	local function makeEffect(class2, name) -- 1 equivalent call inferred from this helper
		local instance = Instance.new(class2)
		instance.Name = name
		instance.Parent = parent2
		return instance
	end

	for _, v49 in ipairs(v20) do
		local v50 = v9[v49.key]
		local effect = makeEffect(v49.class, "Freecam" .. v49.key) -- inferred equivalent call

		if v15 and v49.parent then
			effect.Parent = v49.parent
		end

		for _, v51 in ipairs(v49.props) do
			effect[v51] = v50[v51]
		end

		effect.Enabled = v50.Enabled
		v49.set(effect)
	end

	RunService:BindToRenderStep("Freecam", Enum.RenderPriority.Camera.Value, StepFreecam)
	v37.StartCapture()
end

local function StopFreecam()
	if playerAddedConnection then
		playerAddedConnection:Disconnect()
		playerAddedConnection = nil
	end

	if playerRemovingConnection then
		playerRemovingConnection:Disconnect()
		playerRemovingConnection = nil
	end

	v21 = false
	index = 1
	players = {}

	disable()
	v19 = false

	for _, v49 in ipairs(v20) do
		local v50 = v49.get()

		if not v50 then
			continue
		end

		local v51 = v9[v49.key]
		v51.Enabled = v50.Enabled

		for _, v52 in ipairs(v49.props) do
			v51[v52] = v50[v52]
		end

		v50:Destroy()
		v49.set(nil)
	end

	if v14 and v48 then
		v48.panel.Visible = false
	end

	if freecam and freecam.Parent then
		freecam.Enabled = false
	end

	enabled = false
	v25 = false

	v37.StopCapture()
	RunService:UnbindFromRenderStep("Freecam")
	v12.Pop()
end

local v49 = false

local function ToggleFreecam() -- 1 equivalent call inferred from this helper
	if v49 then
		StopFreecam()
	else
		StartFreecam()
	end

	v49 = not v49

	if v13 then
		script:SetAttribute(v2.AttributeName, v49)
	end
end

v27.StateChanged:Connect(function(flag3: boolean)
	if flag3 then
		ToggleFreecam() -- inferred equivalent call
	end
end)

if v13 then
	script:SetAttribute(v2.AttributeName, v49)
	script:GetAttributeChangedSignal(v2.AttributeName):Connect(function()
		local attribute = script:GetAttribute(v2.AttributeName)

		if typeof(attribute) ~= "boolean" then
			script:SetAttribute(v2.AttributeName, v49)
		elseif attribute ~= v49 then
			if attribute then
				StartFreecam()
				v49 = true
			else
				StopFreecam()
				v49 = false
			end
		end
	end)
end

return {}
