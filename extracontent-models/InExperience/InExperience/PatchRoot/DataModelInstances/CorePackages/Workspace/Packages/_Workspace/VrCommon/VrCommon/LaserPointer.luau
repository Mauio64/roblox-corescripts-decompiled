local VrCommon = script:FindFirstAncestor("VrCommon")
local parent = VrCommon.Parent

local CoreGui = game:GetService("CoreGui")
local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local VRService = game:GetService("VRService")
local AppCommonLib = require(parent.AppCommonLib)
local Create = AppCommonLib.Create
local VRUtil = require(VrCommon.VRUtil)

require(VrCommon.Panel3D)

local defineFastFlag = game:DefineFastFlag("EnableUserInputCFrameLogging", false)
local engineFeature = game:GetEngineFeature("RenderCaptureAlwaysOnTopGui")

local LocalPlayer = Players.LocalPlayer

while not LocalPlayer do
	Players.Changed:wait()
	LocalPlayer = Players.LocalPlayer
end

local function fromLinearRGB(data) -- 3 equivalent calls inferred from this helper
	return Color3.new(data.r ^ 2.2, data.g ^ 2.2, data.b ^ 2.2)
end

local function addPartsToGame(...)
	local v = { ... }
	local coreEffectFolder = GuiService.CoreEffectFolder

	if not coreEffectFolder then
		coroutine.wrap(function()
			while GuiService.Changed:wait() ~= "CoreEffectFolder" and GuiService.CoreEffectFolder == nil do

			end

			for _, v2 in pairs(v) do
				v2.Parent = coreEffectFolder
				v2.CanTouch = false
				v2.CanCollide = false
				v2.CanQuery = false
			end
		end)()
		return
	end

	for _, v2 in pairs(v) do
		v2.Parent = coreEffectFolder
		v2.CanTouch = false
		v2.CanCollide = false
		v2.CanQuery = false
	end
end
local function removePartsFromGame(...)
	for _, v in pairs({ ... }) do
		v.Parent = nil
	end
end

local function getLocalHumanoid()
	local character = LocalPlayer.Character

	if not character then
		return
	end

	for _, humanoid in pairs(character:GetChildren()) do
		if humanoid:IsA("Humanoid") then
			return humanoid
		end
	end
end

local function applyExpCurve(p, p2) -- 2 equivalent calls inferred from this helper
	local v = p ^ p2

	if v ~= v then
		return math.abs(p) ^ p2
	end

	return v
end

local mode = {
	Disabled = 0,
	Pointer = 1,
	Navigation = 2,
	Hidden = 3,
	DualPointer = 4
}

local _ = { Right = 0, Left = 1 }

local v = {
	MODE_ENABLED = true,
	ARC_COLOR_GOOD = fromLinearRGB(Color3.fromRGB(0, 162, 255)), -- inferred equivalent call
	ARC_COLOR_BAD = fromLinearRGB(Color3.fromRGB(253, 68, 72)), -- inferred equivalent call
	ARC_THICKNESS = 0.0125,
	PLOP_GOOD = "rbxasset://textures/ui/VR/VRPointerDiscBlue.png",
	PLOP_BAD = "rbxasset://textures/ui/VR/VRPointerDiscRed.png",
	PLOP_BALL_COLOR_GOOD = BrickColor.new("Bright green"),
	PLOP_BALL_COLOR_BAD = BrickColor.new("Bright red"),
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

local v2 = {
	MODE_ENABLED = true,
	ARC_COLOR_GOOD = v.ARC_COLOR_GOOD,
	ARC_COLOR_BAD = v.ARC_COLOR_BAD,
	ARC_COLOR_HIT = fromLinearRGB(Color3.fromRGB(0, 255, 162)), -- inferred equivalent call
	ARC_THICKNESS = 0.01,
	MAX_DISTANCE = 50,
	G = 0,
	SWITCH_AIM_THRESHOLD = 0.2617993877991494,
	TRANSITION_DURATION = 0.075
}

local vector2 = Vector2.new(0, 0)
local vector2_2 = Vector2.new(1, 1)

local LaserPointer = {}
LaserPointer.__index = LaserPointer
LaserPointer.Mode = mode

function LaserPointer.new(_)
	local object = setmetatable({}, LaserPointer)

	object.laserMaxDistance = VRService.LaserDistance
	object.laserHand = 0

	object.inputUserCFrame = Enum.UserCFrame.RightHand
	object.equippedTool = false

	object.lastLaserModeHit = tick()

	object.guiMenuIsOpen = false
	object.externalForcePointer = false
	object.forceDotActive = true

	object.navHitPoint = Vector3.new(0, 0, 0)
	object.navHitNormal = Vector3.new(0, 1, 0)
	object.navHitPart = nil

	object.navigationIsValid = false
	object.lastNavigationValidityChangeTime = tick()
	object.plopBallBounceStart = tick()

	object.buttonPressStart = 0
	object.showPlopBallOnPointer = false

	object.parabola = Create("ParabolaAdornment")({
		Name = "LaserPointerParabola",
		Parent = CoreGui,
		A = -1,
		B = 2,
		C = 0,
		Color3 = nil,
		Thickness = v.ARC_THICKNESS,
		Visible = false
	})

	object.originPart = Create("Part")({
		Name = "LaserPointerOrigin",
		Anchored = true,
		CanCollide = false,
		TopSurface = Enum.SurfaceType.SmoothNoOutlines,
		BottomSurface = Enum.SurfaceType.SmoothNoOutlines,
		Material = Enum.Material.SmoothPlastic,
		Size = Vector3.new(0.2, 0.2, 0.2),
		Transparency = 1
	})

	object.parabola.Adornee = object.originPart

	object.parabolaOffhand = Create("ParabolaAdornment")({
		Name = "LaserPointerparabolaOffhand",
		Parent = CoreGui,
		A = 0,
		B = 1e-6,
		C = 0,
		Color3 = Color3.new(1, 1, 1),
		Transparency = 0.5,
		Thickness = v.ARC_THICKNESS,
		Visible = false
	})

	object.originPartOffhand = Create("Part")({
		Name = "LaserPointerOriginOffhand",
		Anchored = true,
		CanCollide = false,
		TopSurface = Enum.SurfaceType.SmoothNoOutlines,
		BottomSurface = Enum.SurfaceType.SmoothNoOutlines,
		Material = Enum.Material.SmoothPlastic,
		Size = Vector3.new(0.2, 0.2, 0.2),
		Transparency = 1
	})

	object.parabolaOffhand.Adornee = object.originPartOffhand

	object.plopPart = Create("Part")({
		Name = "LaserPointerTeleportPlop",
		Anchored = true,
		CanCollide = false,
		Size = Vector3.new(0.2, 0.2, 0.2),
		Transparency = 1
	})

	object.plopBall = Create("Part")({
		Name = "LaserPointerTeleportPlopBall",
		Anchored = true,
		CanCollide = false,
		TopSurface = Enum.SurfaceType.SmoothNoOutlines,
		BottomSurface = Enum.SurfaceType.SmoothNoOutlines,
		Material = Enum.Material.Neon,
		BrickColor = v.PLOP_BALL_COLOR_GOOD,
		Shape = Enum.PartType.Ball,
		Size = Vector3.new(1, 1, 1) * v.PLOP_BALL_SIZE
	})

	object.plopAdorn = Create("ImageHandleAdornment")({
		Name = "LaserPointerTeleportPlopAdorn",
		Parent = object.plopPart,
		Adornee = object.plopPart,
		Size = vector2_2 * v.PLOP_SIZE,
		Image = v.PLOP_GOOD
	})

	object.plopAdornPulse = Create("ImageHandleAdornment")({
		Name = "LaserPointerTeleportPlopAdornPulse",
		Parent = object.plopPart,
		Adornee = object.plopPart,
		Size = vector2,
		Image = v.PLOP_GOOD,
		Transparency = 0.5
	})

	object.cursorPart = Create("Part")({
		Name = "Cursor",
		CanCollide = false,
		CanQuery = false,
		CanTouch = false,
		Anchored = true,
		Transparency = 1
	})

	local create = Create("SurfaceGui")
	local adornee

	if engineFeature then
		adornee = object.cursorPart
	end

	local parent2 = if engineFeature then CoreGui else object.cursorPart
	object.cursorSurfaceGui = create({
		Name = "CursorSurfaceGui",
		Active = false,
		AlwaysOnTop = true,
		Enabled = false,
		ZOffset = 10,
		Adornee = adornee,
		Parent = parent2
	})

	object.cursorImage = Create("ImageLabel")({
		Image = "rbxasset://textures/Cursors/Gamepad/Pointer.png",
		ImageColor3 = Color3.new(0, 1, 0),
		BackgroundTransparency = 1,
		Parent = object.cursorSurfaceGui,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(1, 0, 1, 0)
	})

	object.connections = {}
	table.insert(object.connections, VRService:GetPropertyChangedSignal("LaserPointer"):Connect(function()
		object:onModeChanged()
	end))

	object:onModeChanged()

	GuiService.MenuOpened:connect(function()
		object.guiMenuIsOpen = true
	end)
	GuiService.MenuClosed:connect(function()
		object.guiMenuIsOpen = false
	end)

	object.inputUserCFrame = VRService.GuiInputUserCFrame
	VRService.Changed:connect(function(p)
		if p == "GuiInputUserCFrame" then
			object.inputUserCFrame = VRService.GuiInputUserCFrame
		elseif p == "PointerHitCFrame" or p == "DidPointerHit" then
			object:cursorInputsChanged()
		elseif p == "VRSessionState" and VRService.VRSessionState == Enum.VRSessionState.Focused then
			object:updateInputUserCFrame()
		end
	end)

	VRService.LaserPointerTriggered:connect(function(p)
		if game:GetEngineFeature("ImprovedTriggerFire") and p.UserInputState ~= Enum.UserInputState.End then
			return
		end

		if
			(p.KeyCode == Enum.KeyCode.ButtonR1 or p.KeyCode == Enum.KeyCode.ButtonR2 or p.KeyCode == Enum.KeyCode.ButtonR3 or p.KeyCode == Enum.KeyCode.ButtonA or p.KeyCode == Enum.KeyCode.ButtonB)
			and object.laserHand ~= 0
		then
			object.laserHand = 0
			object:updateInputUserCFrame()
		elseif
			(p.KeyCode == Enum.KeyCode.ButtonL1 or p.KeyCode == Enum.KeyCode.ButtonL2 or p.KeyCode == Enum.KeyCode.ButtonL3 or p.KeyCode == Enum.KeyCode.ButtonX or p.KeyCode == Enum.KeyCode.ButtonY)
			and object.laserHand ~= 1
		then
			object.laserHand = 1
			object:updateInputUserCFrame()
		end
	end)

	VRService.UserCFrameEnabled:Connect(function(_, _)
		object:updateInputUserCFrame()
	end)

	object:updateInputUserCFrame()

	return object
end

function LaserPointer.hasAnyHandController()
	return VRService:GetUserCFrameEnabled(Enum.UserCFrame.RightHand)
		or VRService:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand)
end

function LaserPointer.getModeName(p)
	for k, v3 in pairs(mode) do
		if p == v3 then
			return k
		end
	end

	return "unknown"
end

function LaserPointer:updateInputUserCFrame()
	local guiInputUserCFrame

	if defineFastFlag then
		guiInputUserCFrame = VRService.GuiInputUserCFrame
	end

	if VRService:GetUserCFrameEnabled(Enum.UserCFrame.RightHand) and self.laserHand == 0 then
		VRService.GuiInputUserCFrame = Enum.UserCFrame.RightHand
	elseif VRService:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand) and self.laserHand == 1 then
		VRService.GuiInputUserCFrame = Enum.UserCFrame.LeftHand
	elseif VRService:GetUserCFrameEnabled(Enum.UserCFrame.RightHand) then
		VRService.GuiInputUserCFrame = Enum.UserCFrame.RightHand
	elseif VRService:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand) then
		VRService.GuiInputUserCFrame = Enum.UserCFrame.LeftHand
	else
		VRService.GuiInputUserCFrame = Enum.UserCFrame.Head
	end

	if defineFastFlag and guiInputUserCFrame ~= VRService.GuiInputUserCFrame then
		print("Updated GuiInputUserCFrame is: " .. tostring(VRService.GuiInputUserCFrame))
	end
end

function LaserPointer:onModeChanged(_)
	self:updateInputUserCFrame()

	if VRService.LaserPointer == Enum.VRLaserPointerMode.Disabled then
		addPartsToGame(self.originPart, self.cursorPart)
		removePartsFromGame(self.plopPart, self.plopBall, self.originPartOffhand)
		self.forceDotActive = true
		self.parabola.Visible = false
		self.parabolaOffhand.Visible = false
		self:setNavigationActionEnabled(false)
	elseif VRService.LaserPointer == Enum.VRLaserPointerMode.Pointer then
		addPartsToGame(self.originPart, self.cursorPart)
		removePartsFromGame(self.plopPart, self.plopBall, self.originPartOffhand)
		self.parabola.Visible = true
		self.parabolaOffhand.Visible = false
		self:setNavigationActionEnabled(false)
		self.forceDotActive = false
	elseif VRService.LaserPointer == Enum.VRLaserPointerMode.DualPointer then
		addPartsToGame(self.originPart, self.originPartOffhand, self.cursorPart)
		removePartsFromGame(self.plopPart, self.plopBall)
		self.parabola.Visible = true
		self.parabolaOffhand.Visible = true
		self:setNavigationActionEnabled(false)
		self.forceDotActive = false
	end
end

function LaserPointer:setMode(p)
	if p == mode.Disabled or p == mode.Hidden then
		VRService.LaserPointer = Enum.VRLaserPointerMode.Disabled
	elseif p == mode.Pointer or p == mode.Navigation then
		VRService.LaserPointer = Enum.VRLaserPointerMode.Pointer
	elseif p == mode.DualPointer then
		VRService.LaserPointer = Enum.VRLaserPointerMode.DualPointer
	end
end

function LaserPointer.setEnableAmbidexterousPointer(_, _) end

function LaserPointer.calculateLaunchVelocity(_, p, p2, p3)
	return -(math.sqrt(p / 0.7071067811865476) * p2) / math.sqrt(2 * p3 * 0.7071067811865476 + 2 * p2 * 0.7071067811865476)
end

function LaserPointer:isHeadMounted(): boolean
	return VRService.GuiInputUserCFrame == Enum.UserCFrame.Head
end

function LaserPointer:shouldForcePointer()
	return self.externalForcePointer or self.guiMenuIsOpen
end

function LaserPointer:setForcePointer(externalForcePointer)
	self.externalForcePointer = externalForcePointer
end

function LaserPointer.getNavigationOrigin(_)
	local localHumanoid = getLocalHumanoid()

	if not localHumanoid then
		return
	end

	local torso = localHumanoid.Torso

	if not torso then
		return
	end

	local hipHeight = localHumanoid.HipHeight
	local v3 = localHumanoid.RigType == Enum.HumanoidRigType.R6 and 2 or hipHeight

	local v4 = torso.Size.Y / 2
	return torso.Position + Vector3.new(0, -v4 - v3, 0)
end

function LaserPointer.horzDistanceFromCharacter(_, p)
	local character = LocalPlayer.Character

	if not character then
		return 1e999
	end

	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

	if humanoidRootPart then
		return ((humanoidRootPart:GetRenderCFrame().p - p) * Vector3.new(1, 0, 1)).magnitude
	end

	return 1e999
end

function LaserPointer:onNavigateAction(_, p, _)
	if p == Enum.UserInputState.Begin then
		VRService:RequestNavigation(
			CFrame.new(self.navHitPoint, self.navHitPoint + self.navHitNormal) * CFrame.Angles(1.5707963267948966, 0, 0),
			self.inputUserCFrame
		)
	end
end

function LaserPointer:setNavigationActionEnabled(p)
	if p then
		ContextActionService:BindCoreAction("LaserPointerNavigate", function(...)
			self:onNavigateAction(...)
		end, false, Enum.KeyCode.ButtonA)
	else
		ContextActionService:UnbindCoreAction("LaserPointerNavigate")
	end
end

function LaserPointer.setArcLaunchParams(p, p2, p3, p4, p5)
	local v3 = math.cos(p2) * p3
	local v4 = math.sin(p2) * p3

	local v5 = v3 == 0 and 1e-6 or v3

	p.parabola.A = -(0.5 * p4) * (1 / v5 ^ 2)
	p.parabola.B = v4 / v5
	p.parabola.C = 0
	p.parabola.Range = p5 * 1.5
end

function LaserPointer.renderAsParabola(p, p2, p3)
	local v3 = p3 * Vector3.new(1, 0, 1)
	p.originPart.CFrame = CFrame.new(p2, p2 + v3) * CFrame.Angles(0, 1.5707963267948966, 0)
end

function LaserPointer:renderAsLaser(p, p2)
	self.originPart.CFrame = CFrame.new(p, p2) * CFrame.Angles(0, 1.5707963267948966, 0)
	self.parabola.A = 0
	self.parabola.B = 1e-6
	self.parabola.C = 0
	self.parabola.Range = (p2 - p).magnitude
end

function LaserPointer:renderOffhandLaser(p, p2)
	self.originPartOffhand.CFrame = CFrame.new(p, p2) * CFrame.Angles(0, 1.5707963267948966, 0)
	self.parabolaOffhand.Range = (p2 - p).magnitude
end

function LaserPointer:canNavigateTo(p, _, p2): boolean
	local character = LocalPlayer.Character

	if not (character and character:FindFirstChild("HumanoidRootPart")) then
		return false
	end

	if p then
		return not (p2.Y < -1e-6)
	end

	return false
end

function LaserPointer:checkHeadMountedMode(instance)
	if self:shouldForcePointer() then
		self:setMode(mode.Pointer)
		return
	end

	local coreGuiFolder = GuiService.CoreGuiFolder

	if instance and instance:IsDescendantOf(coreGuiFolder) then
		self:setMode(mode.Pointer)
	else
		self:setMode(mode.Navigation)
	end
end

function LaserPointer:setNavigationValidState(navigationIsValid)
	if navigationIsValid == self.navigationIsValid then
		return
	end

	self.navigationIsValid = navigationIsValid
	self.lastNavigationValidityChangeTime = tick()

	if navigationIsValid then
		self.plopBallBounceStart = tick()
		self.parabola.Color3 = v.ARC_COLOR_GOOD
		self.plopAdorn.Visible = true
		self.plopAdorn.Image = v.PLOP_GOOD
		self.plopAdornPulse.Visible = true
		self.plopAdornPulse.Image = v.PLOP_GOOD
		self.plopBall.BrickColor = v.PLOP_BALL_COLOR_GOOD
	else
		self.parabola.Color3 = v.ARC_COLOR_BAD
		self.plopAdorn.Visible = false
		self.plopAdorn.Image = v.PLOP_BAD
		self.plopAdornPulse.Visible = false
		self.plopAdornPulse.Image = v.PLOP_BAD
		self.plopBall.BrickColor = v.PLOP_BALL_COLOR_BAD
	end
end

function LaserPointer:updateNavPlop(p, p2)
	local v3 = tick() - self.plopBallBounceStart

	local cframe = CFrame.new(p, p + p2)
	local v4

	if self.navigationIsValid then
		local v5 = applyExpCurve(math.sin(v3 * 2 * 3.141592653589793 / v.BALL_WAVE_PERIOD), v.BALL_WAVE_EXP) -- inferred equivalent call
		v4 = v.BALL_WAVE_START + v5 * v.BALL_WAVE_AMPLITUDE
	else
		v4 = 0
	end

	self.plopPart.CFrame = cframe
	self.plopBall.CFrame = cframe * CFrame.new(0, 0, -v4)

	local v5 = v3 % v.PULSE_PERIOD

	if v5 > 0 then
		local v6 = v5 / v.PULSE_DURATION

		if v6 < 1 then
			self.plopAdornPulse.Visible = true
			local plopAdornPulse = self.plopAdornPulse
			plopAdornPulse.Size = vector2_2 * (v.PULSE_SIZE_0 + applyExpCurve(v6, v.PULSE_EXP) * (v.PULSE_SIZE_1 - v.PULSE_SIZE_0)) -- inferred equivalent call

			self.plopAdornPulse.Transparency = 0.5 + v6 * 0.5
		else
			self.plopAdornPulse.Visible = false
			self.plopAdornPulse.Size = vector2
			self.pulseStartTime = tick() + v.PULSE_PERIOD
		end
	end
end

function LaserPointer:updateNavigationMode(navHitPoint, navHitNormal, navHitPart)
	self.navHitPoint = navHitPoint
	self.navHitNormal = navHitNormal
	self.navHitPart = navHitPart

	self:updateNavPlop(navHitPoint, navHitNormal)
	self:setNavigationValidState(self:canNavigateTo(self.navHitPart, self.navHitPoint, self.navHitNormal))
end

function LaserPointer:showHitBallOnLaserPointer(p)
	if p then
		if not self.showPlopBallOnPointer then
			self.showPlopBallOnPointer = true
			addPartsToGame(self.plopBall)
		end
	elseif self.showPlopBallOnPointer then
		removePartsFromGame(self.plopBall)
		self.showPlopBallOnPointer = false
	end
end

function LaserPointer:cursorInputsChanged()
	local didPointerHit = VRService.DidPointerHit
	self.cursorSurfaceGui.Enabled = didPointerHit

	if didPointerHit then
		local pointerHitCFrame = VRService.PointerHitCFrame

		local v3 = (VRUtil.GetUserCFrameWorldSpace(Enum.UserCFrame.Head).Position - pointerHitCFrame.Position).magnitude * 0.01
		local v4

		if v3 < 0.05 then
			v4 = v3 / 0.05
			v3 = 0.05
		else
			v4 = 1
		end

		self.cursorPart.Size = Vector3.new(v3, v3, v3)
		local cframe = CFrame.new(0, 0, v3 * 0.5)
		self.cursorPart.CFrame = pointerHitCFrame * cframe
		self.cursorImage.Size = UDim2.new(v4, 0, v4, 0)
	end
end

function LaserPointer:updateCursor_DEPRECATED()
	if VRService.DidPointerHit then
		local v3 = VRService.PointerHitCFrame
		local v4 = VRUtil.GetUserCFrameWorldSpace(self.inputUserCFrame)

		if self:isHeadMounted() then
			v4 = VRUtil.GetUserCFrameWorldSpace(Enum.UserCFrame.Head)
		end

		local p = v4.p
		local lookVector = v4.lookVector

		local position = v3.Position
		local lookVector2 = v3.lookVector
		local dot = lookVector2:Dot(lookVector)

		if math.abs(dot) > 0.001 then
			local v5 = p + (position - p):Dot(lookVector2) / dot * lookVector
			v3 = v3.Rotation + v5
		end

		local v5 = (workspace.CurrentCamera.CFrame.Position - v3.Position).magnitude * 0.01
		local v6

		if v5 < 0.05 then
			v6 = v5 / 0.05
			v5 = 0.05
		else
			v6 = 1
		end

		self.cursorPart.Size = Vector3.new(v5, v5, v5)
		local cframe = CFrame.new(0, 0, v5 * 0.5)
		self.cursorPart.CFrame = v3 * cframe
		self.cursorImage.Size = UDim2.new(v6, 0, v6, 0)
	end

	self.cursorSurfaceGui.Enabled = VRService.DidPointerHit
end

function LaserPointer:disableComponent()
	removePartsFromGame(
		self.parabola,
		self.parabolaOffhand,
		self.originPart,
		self.originPartOffhand,
		self.plopPart,
		self.plopBall,
		self.cursorPart
	)

	if engineFeature then
		removePartsFromGame(self.cursorSurfaceGui)
	end

	self:setNavigationActionEnabled(false)

	for _, connection in pairs(self.connections) do
		connection:Disconnect()
	end

	self.connections = {}
end

function LaserPointer:update(_)
	if VRService.LaserPointer == Enum.VRLaserPointerMode.Disabled then
		return
	end

	self.parabola.Thickness = v2.ARC_THICKNESS * workspace.CurrentCamera.HeadScale
	self.parabolaOffhand.Thickness = v2.ARC_THICKNESS * workspace.CurrentCamera.HeadScale

	if LocalPlayer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool") then
		self.parabola.Color3 = v2.ARC_COLOR_BAD
	else
		self.parabola.Color3 = VRService.DidPointerHit and v2.ARC_COLOR_HIT or v2.ARC_COLOR_GOOD
	end

	local userCFrameWorldSpace = VRUtil.GetUserCFrameWorldSpace(self.inputUserCFrame)
	local p = userCFrameWorldSpace.p
	local lookVector = userCFrameWorldSpace.lookVector
	local v3

	if VRService.DidPointerHit then
		v3 = p + lookVector * (VRService.PointerHitCFrame.Position - p).magnitude
	else
		v3 = p + lookVector * self.laserMaxDistance
	end

	if self:isHeadMounted() then
		self.parabola.Visible = false
	else
		self.parabola.Visible = true
		self:renderAsLaser(p, v3)
	end

	if VRService.LaserPointer == Enum.VRLaserPointerMode.DualPointer then
		if self:isHeadMounted() then
			self.parabolaOffhand.Visible = false
			return
		end

		self.parabolaOffhand.Visible = true
		local v4

		if self.inputUserCFrame == Enum.UserCFrame.RightHand then
			v4 = Enum.UserCFrame.LeftHand
		else
			v4 = Enum.UserCFrame.RightHand
		end

		local userCFrameWorldSpace2 = VRUtil.GetUserCFrameWorldSpace(v4)
		local p2 = userCFrameWorldSpace2.p
		self:renderOffhandLaser(p2, p2 + userCFrameWorldSpace2.lookVector * 3)
	end
end

return LaserPointer
