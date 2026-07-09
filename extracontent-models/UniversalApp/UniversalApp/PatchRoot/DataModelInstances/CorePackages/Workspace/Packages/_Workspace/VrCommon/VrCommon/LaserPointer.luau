local VrCommon = script:FindFirstAncestor("VrCommon")
local VrCommonParent = VrCommon.Parent
local CoreGui = game:GetService("CoreGui")
local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local VRService = game:GetService("VRService")
local Create = require(VrCommonParent.AppCommonLib).Create
local VRUtil = require(VrCommon.VRUtil)

require(VrCommon.Panel3D)

local v10 = game:DefineFastFlag("EnableUserInputCFrameLogging", false)
local v11 = game:DefineFastFlag("VRLaserPointerRaycastChange", false)
local LocalPlayer = Players.LocalPlayer

while not LocalPlayer do
	Players.Changed:wait()
	LocalPlayer = Players.LocalPlayer
end

local function fromLinearRGB(p1) -- line: 32
	return Color3.new(p1.r ^ 2.2, p1.g ^ 2.2, p1.b ^ 2.2)
end
local function addPartsToGame(...) -- line: 36
	-- upvalues: GuiService (copy)
	local t1 = { ... }
	local CoreEffectFolder = GuiService.CoreEffectFolder

	if not CoreEffectFolder then
		coroutine.wrap(function() -- line: 42
			-- upvalues: GuiService (copy), t1 (copy), CoreEffectFolder (copy)
			while GuiService.Changed:wait() ~= "CoreEffectFolder" and GuiService.CoreEffectFolder == nil do
			end

			for _, v in pairs(t1) do
				v.Parent = CoreEffectFolder
				v.CanTouch = false
				v.CanCollide = false
				v.CanQuery = false
			end
		end)()

		return
	end

	for _, v in pairs(t1) do
		v.Parent = CoreEffectFolder
		v.CanTouch = false
		v.CanCollide = false
		v.CanQuery = false
	end
end
local function removePartsFromGame(...) -- line: 64
	for _, v in pairs({ ... }) do
		v.Parent = nil
	end
end
local function getLocalHumanoid() -- line: 71
	-- upvalues: LocalPlayer (ref)
	local Character = LocalPlayer.Character

	if not Character then
		return
	end

	for _, child in pairs(Character:GetChildren()) do
		if child:IsA("Humanoid") then
			return child
		end
	end
end
local function applyExpCurve(p2, p3) -- line: 85
	local v40 = p2 ^ p3

	if v40 ~= v40 then
		v40 = math.abs(p2) ^ p3
	end

	return v40
end

local t2 = {
	Disabled = 0,
	Pointer = 1,
	Navigation = 2,
	Hidden = 3,
	DualPointer = 4
}
local _ = {
	Right = 0,
	Left = 1
}
local t3 = {
	MODE_ENABLED = true,
	ARC_THICKNESS = 0.0125,
	PLOP_GOOD = "rbxasset://textures/ui/VR/VRPointerDiscBlue.png",
	PLOP_BAD = "rbxasset://textures/ui/VR/VRPointerDiscRed.png",
	PLOP_BALL_SIZE = 0.5,
	PLOP_SIZE = 2,
	PLOP_PULSE_MIN_SIZE = 0,
	PLOP_PULSE_MAX_SIZE = 2,
	MAX_VALID_DISTANCE = 100,
	BUTTON_DOWN_THRESHOLD = 0.95,
	BUTTON_UP_THRESHOLD = 0.5,
	MIN_VELOCITY = 10,
	RANGE_T_EXP = 2,
	G = 10,
	PULSE_DURATION = 0.8,
	PULSE_PERIOD = 1,
	PULSE_EXP = 2,
	PULSE_SIZE_0 = 0.25,
	PULSE_SIZE_1 = 2,
	BALL_WAVE_PERIOD = 2,
	BALL_WAVE_AMPLITUDE = 0.5,
	BALL_WAVE_START = 0.25,
	BALL_WAVE_EXP = 0.8,
	FLOOR_OFFSET = 4.5,
	FADE_OUT_DURATION = 0.125,
	FADE_IN_DURATION = 0.125,
	TRANSITION_DURATION = 0.25
}
local color3 = Color3.fromRGB(0, 162, 255)

t3.ARC_COLOR_GOOD = Color3.new(color3.r ^ 2.2, color3.g ^ 2.2, color3.b ^ 2.2)

local color3_2 = Color3.fromRGB(253, 68, 72)

t3.ARC_COLOR_BAD = Color3.new(color3_2.r ^ 2.2, color3_2.g ^ 2.2, color3_2.b ^ 2.2)
t3.PLOP_BALL_COLOR_GOOD = BrickColor.new("Bright green")
t3.PLOP_BALL_COLOR_BAD = BrickColor.new("Bright red")

local t4 = {
	MODE_ENABLED = true,
	ARC_THICKNESS = 0.01,
	MAX_DISTANCE = 50,
	G = 0,
	SWITCH_AIM_THRESHOLD = 0.2617993877991494,
	TRANSITION_DURATION = 0.075,
	ARC_COLOR_GOOD = t3.ARC_COLOR_GOOD,
	ARC_COLOR_BAD = t3.ARC_COLOR_BAD
}
local color3_3 = Color3.fromRGB(0, 255, 162)

t4.ARC_COLOR_HIT = Color3.new(color3_3.r ^ 2.2, color3_3.g ^ 2.2, color3_3.b ^ 2.2)

local vector2 = Vector2.new(0, 0)
local vector2_2 = Vector2.new(1, 1)
local t5 = {}

t5.__index = t5
t5.Mode = t2

function t5.new(_) -- line: 184
	-- upvalues: t5 (copy), VRService (copy), Create (copy), CoreGui (copy), t3 (copy), vector2_2 (copy), vector2 (copy), GuiService (copy)
	local self = setmetatable({}, t5)

	self.laserMaxDistance = VRService.LaserDistance
	self.laserHand = 0
	self.inputUserCFrame = Enum.UserCFrame.RightHand
	self.equippedTool = false
	self.lastLaserModeHit = tick()
	self.guiMenuIsOpen = false
	self.externalForcePointer = false
	self.forceDotActive = true
	self.navHitPoint = Vector3.new(0, 0, 0)
	self.navHitNormal = Vector3.new(0, 1, 0)
	self.navHitPart = nil
	self.navigationIsValid = false
	self.lastNavigationValidityChangeTime = tick()
	self.plopBallBounceStart = tick()
	self.buttonPressStart = 0
	self.showPlopBallOnPointer = false
	self.parabola = Create("ParabolaAdornment")({
		Name = "LaserPointerParabola",
		A = -1,
		B = 2,
		C = 0,
		Color3 = nil,
		Visible = false,
		Parent = CoreGui,
		Thickness = t3.ARC_THICKNESS
	})
	self.originPart = Create("Part")({
		Name = "LaserPointerOrigin",
		Anchored = true,
		CanCollide = false,
		Size = Vector3.new(0.20000000298023224, 0.20000000298023224, 0.20000000298023224),
		Transparency = 1,
		TopSurface = Enum.SurfaceType.SmoothNoOutlines,
		BottomSurface = Enum.SurfaceType.SmoothNoOutlines,
		Material = Enum.Material.SmoothPlastic
	})
	self.parabola.Adornee = self.originPart
	self.parabolaOffhand = Create("ParabolaAdornment")({
		Name = "LaserPointerparabolaOffhand",
		A = 0,
		B = 1E-06,
		C = 0,
		Transparency = 0.5,
		Visible = false,
		Parent = CoreGui,
		Color3 = Color3.new(1, 1, 1),
		Thickness = t3.ARC_THICKNESS
	})
	self.originPartOffhand = Create("Part")({
		Name = "LaserPointerOriginOffhand",
		Anchored = true,
		CanCollide = false,
		Size = Vector3.new(0.20000000298023224, 0.20000000298023224, 0.20000000298023224),
		Transparency = 1,
		TopSurface = Enum.SurfaceType.SmoothNoOutlines,
		BottomSurface = Enum.SurfaceType.SmoothNoOutlines,
		Material = Enum.Material.SmoothPlastic
	})
	self.parabolaOffhand.Adornee = self.originPartOffhand
	self.plopPart = Create("Part")({
		Name = "LaserPointerTeleportPlop",
		Anchored = true,
		CanCollide = false,
		Size = Vector3.new(0.20000000298023224, 0.20000000298023224, 0.20000000298023224),
		Transparency = 1
	})
	self.plopBall = Create("Part")({
		Name = "LaserPointerTeleportPlopBall",
		Anchored = true,
		CanCollide = false,
		TopSurface = Enum.SurfaceType.SmoothNoOutlines,
		BottomSurface = Enum.SurfaceType.SmoothNoOutlines,
		Material = Enum.Material.Neon,
		BrickColor = t3.PLOP_BALL_COLOR_GOOD,
		Shape = Enum.PartType.Ball,
		Size = Vector3.new(1, 1, 1) * t3.PLOP_BALL_SIZE
	})
	self.plopAdorn = Create("ImageHandleAdornment")({
		Name = "LaserPointerTeleportPlopAdorn",
		Parent = self.plopPart,
		Adornee = self.plopPart,
		Size = vector2_2 * t3.PLOP_SIZE,
		Image = t3.PLOP_GOOD
	})
	self.plopAdornPulse = Create("ImageHandleAdornment")({
		Name = "LaserPointerTeleportPlopAdornPulse",
		Transparency = 0.5,
		Parent = self.plopPart,
		Adornee = self.plopPart,
		Size = vector2,
		Image = t3.PLOP_GOOD
	})
	self.cursorPart = Create("Part")({
		Name = "Cursor",
		CanCollide = false,
		CanQuery = false,
		CanTouch = false,
		Anchored = true,
		Transparency = 1
	})
	self.cursorSurfaceGui = Create("SurfaceGui")({
		Name = "CursorSurfaceGui",
		Active = false,
		AlwaysOnTop = true,
		Enabled = false,
		ZOffset = 10,
		Parent = self.cursorPart
	})
	self.cursorImage = Create("ImageLabel")({
		Image = "rbxasset://textures/Cursors/Gamepad/Pointer.png",
		BackgroundTransparency = 1,
		ImageColor3 = Color3.new(0, 1, 0),
		Parent = self.cursorSurfaceGui,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(1, 0, 1, 0)
	})
	self.connections = {}
	table.insert(self.connections, VRService:GetPropertyChangedSignal("LaserPointer"):Connect(function() -- line: 322
		-- upvalues: self (copy)
		self:onModeChanged()
	end))
	self:onModeChanged()
	GuiService.MenuOpened:connect(function() -- line: 329
		-- upvalues: self (copy)
		self.guiMenuIsOpen = true
	end)
	GuiService.MenuClosed:connect(function() -- line: 332
		-- upvalues: self (copy)
		self.guiMenuIsOpen = false
	end)
	self.inputUserCFrame = VRService.GuiInputUserCFrame
	VRService.Changed:connect(function(p5) -- line: 337
		-- upvalues: self (copy), VRService (copy)
		if p5 == "GuiInputUserCFrame" then
			self.inputUserCFrame = VRService.GuiInputUserCFrame

			return
		end

		if p5 == "PointerHitCFrame" or p5 == "DidPointerHit" then
			self:cursorInputsChanged()

			return
		end

		if p5 == "VRSessionState" and VRService.VRSessionState == Enum.VRSessionState.Focused then
			self:updateInputUserCFrame()
		end
	end)
	VRService.LaserPointerTriggered:connect(function(p6) -- line: 347
		-- upvalues: self (copy)
		if game:GetEngineFeature("ImprovedTriggerFire") and p6.UserInputState ~= Enum.UserInputState.End then
			return
		end

		if (p6.KeyCode == Enum.KeyCode.ButtonR1 or p6.KeyCode == Enum.KeyCode.ButtonR2 or p6.KeyCode == Enum.KeyCode.ButtonR3 or p6.KeyCode == Enum.KeyCode.ButtonA or p6.KeyCode == Enum.KeyCode.ButtonB) and self.laserHand ~= 0 then
			self.laserHand = 0
			self:updateInputUserCFrame()

			return
		end

		if (p6.KeyCode == Enum.KeyCode.ButtonL1 or p6.KeyCode == Enum.KeyCode.ButtonL2 or p6.KeyCode == Enum.KeyCode.ButtonL3 or p6.KeyCode == Enum.KeyCode.ButtonX or p6.KeyCode == Enum.KeyCode.ButtonY) and self.laserHand ~= 1 then
			self.laserHand = 1
			self:updateInputUserCFrame()
		end
	end)
	VRService.UserCFrameEnabled:Connect(function(_, _) -- line: 376
		-- upvalues: self (copy)
		self:updateInputUserCFrame()
	end)
	self:updateInputUserCFrame()

	return self
end
function t5.hasAnyHandController() -- line: 385
	-- upvalues: VRService (copy)
	return VRService:GetUserCFrameEnabled(Enum.UserCFrame.RightHand) or VRService:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand)
end
function t5.getModeName(p9) -- line: 390
	-- upvalues: t2 (copy)
	for k, v in pairs(t2) do
		if p9 == v then
			return k
		end
	end

	return "unknown"
end
function t5.updateInputUserCFrame(p10) -- line: 400
	-- upvalues: v10 (copy), VRService (copy)
	local GuiInputUserCFrame = nil

	if v10 then
		GuiInputUserCFrame = VRService.GuiInputUserCFrame
	end

	if VRService:GetUserCFrameEnabled(Enum.UserCFrame.RightHand) and p10.laserHand == 0 then
		VRService.GuiInputUserCFrame = Enum.UserCFrame.RightHand
	elseif VRService:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand) and p10.laserHand == 1 then
		VRService.GuiInputUserCFrame = Enum.UserCFrame.LeftHand
	elseif VRService:GetUserCFrameEnabled(Enum.UserCFrame.RightHand) then
		VRService.GuiInputUserCFrame = Enum.UserCFrame.RightHand
	elseif VRService:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand) then
		VRService.GuiInputUserCFrame = Enum.UserCFrame.LeftHand
	else
		VRService.GuiInputUserCFrame = Enum.UserCFrame.Head
	end

	if v10 and GuiInputUserCFrame ~= VRService.GuiInputUserCFrame then
		print("Updated GuiInputUserCFrame is: " .. tostring(VRService.GuiInputUserCFrame))
	end
end
function t5.onModeChanged(p11, _) -- line: 421
	-- upvalues: VRService (copy), addPartsToGame (copy), removePartsFromGame (copy)
	p11:updateInputUserCFrame()

	if VRService.LaserPointer == Enum.VRLaserPointerMode.Disabled then
		addPartsToGame(p11.originPart, p11.cursorPart)
		removePartsFromGame(p11.plopPart, p11.plopBall, p11.originPartOffhand)
		p11.forceDotActive = true
		p11.parabola.Visible = false
		p11.parabolaOffhand.Visible = false
		p11:setNavigationActionEnabled(false)

		return
	end

	if VRService.LaserPointer == Enum.VRLaserPointerMode.Pointer then
		addPartsToGame(p11.originPart, p11.cursorPart)
		removePartsFromGame(p11.plopPart, p11.plopBall, p11.originPartOffhand)
		p11.parabola.Visible = true
		p11.parabolaOffhand.Visible = false
		p11:setNavigationActionEnabled(false)
		p11.forceDotActive = false

		return
	end

	if VRService.LaserPointer == Enum.VRLaserPointerMode.DualPointer then
		addPartsToGame(p11.originPart, p11.originPartOffhand, p11.cursorPart)
		removePartsFromGame(p11.plopPart, p11.plopBall)
		p11.parabola.Visible = true
		p11.parabolaOffhand.Visible = true
		p11:setNavigationActionEnabled(false)
		p11.forceDotActive = false
	end
end
function t5.setMode(_, p14) -- line: 455
	-- upvalues: t2 (copy), VRService (copy)
	if p14 == t2.Disabled or p14 == t2.Hidden then
		VRService.LaserPointer = Enum.VRLaserPointerMode.Disabled

		return
	end

	if p14 == t2.Pointer or p14 == t2.Navigation then
		VRService.LaserPointer = Enum.VRLaserPointerMode.Pointer

		return
	end

	if p14 == t2.DualPointer then
		VRService.LaserPointer = Enum.VRLaserPointerMode.DualPointer
	end
end
function t5.setEnableAmbidexterousPointer(_, _) -- line: 465
end
function t5.calculateLaunchVelocity(_, p18, p19, p20) -- line: 469
	return -(math.sqrt(p18 / 0.7071067811865476) * p19) / math.sqrt(2 * p20 * 0.7071067811865476 + 2 * p19 * 0.7071067811865476)
end
function t5.isHeadMounted(_) -- line: 478
	-- upvalues: VRService (copy)
	return VRService.GuiInputUserCFrame == Enum.UserCFrame.Head
end
function t5.shouldForcePointer(p22) -- line: 482
	return p22.externalForcePointer or p22.guiMenuIsOpen
end
function t5.setForcePointer(p23, p24) -- line: 486
	p23.externalForcePointer = p24
end
function t5.getNavigationOrigin(_) -- line: 490
	-- upvalues: getLocalHumanoid (copy)
	local v63 = getLocalHumanoid()

	if not v63 then
		return
	end

	local Torso = v63.Torso

	if not Torso then
		return
	end

	local HipHeight = v63.HipHeight

	if v63.RigType == Enum.HumanoidRigType.R6 then
		HipHeight = 2
	end

	local v66 = Torso.Size.Y / 2

	return Torso.Position + Vector3.new(0, -v66 - HipHeight, 0)
end
function t5.horzDistanceFromCharacter(_, p27) -- line: 509
	-- upvalues: LocalPlayer (ref)
	local Character = LocalPlayer.Character

	if not Character then
		return 1e999
	end

	local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

	if not HumanoidRootPart then
		return 1e999
	end

	return ((HumanoidRootPart:GetRenderCFrame().p - p27) * Vector3.new(1, 0, 1)).magnitude
end
function t5.onNavigateAction(p28, _, p30, _) -- line: 522
	-- upvalues: VRService (copy)
	if p30 == Enum.UserInputState.Begin then
		VRService:RequestNavigation(CFrame.new(p28.navHitPoint, p28.navHitPoint + p28.navHitNormal) * CFrame.Angles(1.5707963267948966, 0, 0), p28.inputUserCFrame)
	end
end
function t5.setNavigationActionEnabled(p32, p33) -- line: 531
	-- upvalues: ContextActionService (copy)
	if p33 then
		ContextActionService:BindCoreAction("LaserPointerNavigate", function(...) -- line: 533
			-- upvalues: p32 (copy)
			p32:onNavigateAction(...)
		end, false, Enum.KeyCode.ButtonA)

		return
	end

	ContextActionService:UnbindCoreAction("LaserPointerNavigate")
end
function t5.setArcLaunchParams(p34, p35, p36, p37, p38) -- line: 541
	local v82 = math.cos(p35) * p36
	local v83 = math.sin(p35) * p36

	if v82 == 0 then
		v82 = 1E-06
	end

	p34.parabola.A = -(0.5 * p37) * (1 / v82 ^ 2)
	p34.parabola.B = v83 / v82
	p34.parabola.C = 0
	p34.parabola.Range = p38 * 1.5
end
function t5.renderAsParabola(p39, p40, p41) -- line: 556
	local v87 = p41 * Vector3.new(1, 0, 1)

	p39.originPart.CFrame = CFrame.new(p40, p40 + v87) * CFrame.Angles(0, 1.5707963267948966, 0)
end
function t5.renderAsLaser(p42, p43, p44) -- line: 561
	p42.originPart.CFrame = CFrame.new(p43, p44) * CFrame.Angles(0, 1.5707963267948966, 0)
	p42.parabola.A = 0
	p42.parabola.B = 1E-06
	p42.parabola.C = 0
	p42.parabola.Range = (p44 - p43).magnitude
end
function t5.renderOffhandLaser(p45, p46, p47) -- line: 569
	p45.originPartOffhand.CFrame = CFrame.new(p46, p47) * CFrame.Angles(0, 1.5707963267948966, 0)
	p45.parabolaOffhand.Range = (p47 - p46).magnitude
end

if not v11 then
	function t5.getLaserHit(p48, p49, p50, p51) -- line: 575
		local ray = Ray.new(p49, p50 * p48.laserMaxDistance)
		local part, position, normal, _ = workspace:FindPartOnRayWithIgnoreList(ray, p51)

		return part, position, normal, (position - p49).magnitude / math.max(p48.laserMaxDistance, 0.1)
	end
end

function t5.canNavigateTo(_, p53, _, p55) -- line: 584
	-- upvalues: LocalPlayer (ref)
	local Character = LocalPlayer.Character

	if not Character then
		return false
	end

	if not Character:FindFirstChild("HumanoidRootPart") then
		return false
	end

	if not p53 then
		return false
	end

	if p55.Y < -1E-06 then
		return false
	end

	return true
end
function t5.checkHeadMountedMode(p56, p57) -- line: 607
	-- upvalues: t2 (copy), GuiService (copy)
	if p56:shouldForcePointer() then
		p56:setMode(t2.Pointer)

		return
	end

	local CoreGuiFolder = GuiService.CoreGuiFolder

	if p57 and p57:IsDescendantOf(CoreGuiFolder) then
		p56:setMode(t2.Pointer)

		return
	end

	p56:setMode(t2.Navigation)
end
function t5.setNavigationValidState(p58, p59) -- line: 621
	-- upvalues: t3 (copy)
	if p59 == p58.navigationIsValid then
		return
	end

	p58.navigationIsValid = p59
	p58.lastNavigationValidityChangeTime = tick()

	if p59 then
		p58.plopBallBounceStart = tick()
		p58.parabola.Color3 = t3.ARC_COLOR_GOOD
		p58.plopAdorn.Visible = true
		p58.plopAdorn.Image = t3.PLOP_GOOD
		p58.plopAdornPulse.Visible = true
		p58.plopAdornPulse.Image = t3.PLOP_GOOD
		p58.plopBall.BrickColor = t3.PLOP_BALL_COLOR_GOOD

		return
	end

	p58.parabola.Color3 = t3.ARC_COLOR_BAD
	p58.plopAdorn.Visible = false
	p58.plopAdorn.Image = t3.PLOP_BAD
	p58.plopAdornPulse.Visible = false
	p58.plopAdornPulse.Image = t3.PLOP_BAD
	p58.plopBall.BrickColor = t3.PLOP_BALL_COLOR_BAD
end
function t5.updateNavPlop(p60, p61, p62) -- line: 646
	-- upvalues: t3 (copy), vector2_2 (copy), vector2 (copy)
	local v116 = tick() - p60.plopBallBounceStart
	local cFrame = CFrame.new(p61, p61 + p62)
	local n1 = 0

	if p60.navigationIsValid then
		local v119 = math.sin(v116 * 2 * 3.141592653589793 / t3.BALL_WAVE_PERIOD)
		local BALL_WAVE_EXP = t3.BALL_WAVE_EXP
		local v121 = v119 ^ BALL_WAVE_EXP

		if v121 ~= v121 then
			v121 = math.abs(v119) ^ BALL_WAVE_EXP
		end

		n1 = t3.BALL_WAVE_START + v121 * t3.BALL_WAVE_AMPLITUDE
	end

	p60.plopPart.CFrame = cFrame
	p60.plopBall.CFrame = cFrame * CFrame.new(0, 0, -n1)

	local v122 = v116 % t3.PULSE_PERIOD

	if v122 > 0 then
		local v123 = v122 / t3.PULSE_DURATION

		if v123 < 1 then
			p60.plopAdornPulse.Visible = true

			local plopAdornPulse = p60.plopAdornPulse
			local v125 = vector2_2
			local PULSE_SIZE_0 = t3.PULSE_SIZE_0
			local PULSE_EXP = t3.PULSE_EXP
			local v128 = v123 ^ PULSE_EXP

			if v128 ~= v128 then
				v128 = math.abs(v123) ^ PULSE_EXP
			end

			plopAdornPulse.Size = v125 * (PULSE_SIZE_0 + v128 * (t3.PULSE_SIZE_1 - t3.PULSE_SIZE_0))
			p60.plopAdornPulse.Transparency = 0.5 + v123 * 0.5

			return
		end

		p60.plopAdornPulse.Visible = false
		p60.plopAdornPulse.Size = vector2
		p60.pulseStartTime = tick() + t3.PULSE_PERIOD
	end
end
function t5.updateNavigationMode(p63, p64, p65, p66) -- line: 684
	p63.navHitPoint = p64
	p63.navHitNormal = p65
	p63.navHitPart = p66
	p63:updateNavPlop(p64, p65)
	p63:setNavigationValidState(p63:canNavigateTo(p63.navHitPart, p63.navHitPoint, p63.navHitNormal))
end
function t5.showHitBallOnLaserPointer(p67, p68) -- line: 693
	-- upvalues: addPartsToGame (copy), removePartsFromGame (copy)
	if p68 then
		if not p67.showPlopBallOnPointer then
			p67.showPlopBallOnPointer = true
			addPartsToGame(p67.plopBall)

			return
		end
	elseif p67.showPlopBallOnPointer then
		removePartsFromGame(p67.plopBall)
		p67.showPlopBallOnPointer = false
	end
end
function t5.cursorInputsChanged(p69) -- line: 707
	-- upvalues: VRService (copy), VRUtil (copy)
	local DidPointerHit = VRService.DidPointerHit

	p69.cursorSurfaceGui.Enabled = DidPointerHit

	if DidPointerHit then
		local PointerHitCFrame = VRService.PointerHitCFrame
		local n2 = 1
		local v139 = (VRUtil.GetUserCFrameWorldSpace(Enum.UserCFrame.Head).Position - PointerHitCFrame.Position).magnitude * 0.01

		if v139 < 0.05 then
			n2 = v139 / 0.05
			v139 = 0.05
		end

		p69.cursorPart.Size = Vector3.new(v139, v139, v139)

		local cFrame = CFrame.new(0, 0, v139 * 0.5)

		p69.cursorPart.CFrame = PointerHitCFrame * cFrame
		p69.cursorImage.Size = UDim2.new(n2, 0, n2, 0)
	end
end
function t5.updateCursor_DEPRECATED(p70) -- line: 732
	-- upvalues: VRService (copy), VRUtil (copy)
	if VRService.DidPointerHit then
		local PointerHitCFrame = VRService.PointerHitCFrame
		local v143 = VRUtil.GetUserCFrameWorldSpace(p70.inputUserCFrame)

		if p70:isHeadMounted() then
			v143 = VRUtil.GetUserCFrameWorldSpace(Enum.UserCFrame.Head)
		end

		local p = v143.p
		local lookVector = v143.lookVector
		local PointerHitCFramePosition = PointerHitCFrame.Position
		local lookVector2 = PointerHitCFrame.lookVector
		local v148 = lookVector2:Dot(lookVector)

		if math.abs(v148) > 0.001 then
			local v149 = p + (PointerHitCFramePosition - p):Dot(lookVector2) / v148 * lookVector

			PointerHitCFrame = PointerHitCFrame.Rotation + v149
		end

		local n3 = 1
		local v151 = (workspace.CurrentCamera.CFrame.Position - PointerHitCFrame.Position).magnitude * 0.01

		if v151 < 0.05 then
			n3 = v151 / 0.05
			v151 = 0.05
		end

		p70.cursorPart.Size = Vector3.new(v151, v151, v151)

		local cFrame = CFrame.new(0, 0, v151 * 0.5)

		p70.cursorPart.CFrame = PointerHitCFrame * cFrame
		p70.cursorImage.Size = UDim2.new(n3, 0, n3, 0)
	end

	p70.cursorSurfaceGui.Enabled = VRService.DidPointerHit
end
function t5.disableComponent(p71) -- line: 774
	-- upvalues: removePartsFromGame (copy)
	removePartsFromGame(p71.parabola, p71.parabolaOffhand, p71.originPart, p71.originPartOffhand, p71.plopPart, p71.plopBall, p71.cursorPart)
	p71:setNavigationActionEnabled(false)

	for _, v in pairs(p71.connections) do
		v:Disconnect()
	end

	p71.connections = {}
end
function t5.update(p72, _) -- line: 791
	-- upvalues: VRService (copy), t4 (copy), LocalPlayer (ref), VRUtil (copy)
	if VRService.LaserPointer == Enum.VRLaserPointerMode.Disabled then
		return
	end

	p72.parabola.Thickness = t4.ARC_THICKNESS * workspace.CurrentCamera.HeadScale
	p72.parabolaOffhand.Thickness = t4.ARC_THICKNESS * workspace.CurrentCamera.HeadScale

	if LocalPlayer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool") then
		p72.parabola.Color3 = t4.ARC_COLOR_BAD
	else
		p72.parabola.Color3 = VRService.DidPointerHit and t4.ARC_COLOR_HIT or t4.ARC_COLOR_GOOD
	end

	local v158 = VRUtil.GetUserCFrameWorldSpace(p72.inputUserCFrame)
	local p = v158.p
	local lookVector = v158.lookVector
	local v161 = if not VRService.DidPointerHit then p + lookVector * p72.laserMaxDistance else p + lookVector * (VRService.PointerHitCFrame.Position - p).magnitude

	if p72:isHeadMounted() then
		p72.parabola.Visible = false
	else
		p72.parabola.Visible = true
		p72:renderAsLaser(p, v161)
	end

	if VRService.LaserPointer == Enum.VRLaserPointerMode.DualPointer then
		if p72:isHeadMounted() then
			p72.parabolaOffhand.Visible = false

			return
		end

		p72.parabolaOffhand.Visible = true

		local v162 = if p72.inputUserCFrame ~= Enum.UserCFrame.RightHand then Enum.UserCFrame.RightHand else Enum.UserCFrame.LeftHand
		local v163 = VRUtil.GetUserCFrameWorldSpace(v162)
		local p2 = v163.p

		p72:renderOffhandLaser(p2, p2 + v163.lookVector * 3)
	end
end

return t5
