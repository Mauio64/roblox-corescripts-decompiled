local CoreGui = game:GetService("CoreGui")
local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local VRService = game:GetService("VRService")
local create = require("@game/CorePackages/Workspace/Packages/_Workspace/VrCommon/AppCommonLib").Create
local VRUtil = require("@game/CorePackages/Workspace/Packages/_Workspace/VrCommon/VrCommon/VRUtil")

require("@game/CorePackages/Workspace/Packages/_Workspace/VrCommon/VrCommon/Panel3D")

local defineFastFlag = game:DefineFastFlag("EnableUserInputCFrameLogging", false)
local engineFeature = game:GetEngineFeature("RenderCaptureAlwaysOnTopGui")

local localPlayer = Players.LocalPlayer

while not localPlayer do
	Players.Changed:wait()
	localPlayer = Players.LocalPlayer
end

local function fromLinearRGB(data)
	return Color3.new(data.r ^ 2.2, data.g ^ 2.2, data.b ^ 2.2)
end

local function addPartsToGame(...)
	local v5 = { ... }
	local coreEffectFolder = GuiService.CoreEffectFolder

	if not coreEffectFolder then
		coroutine.wrap(function()
			while GuiService.Changed:wait() ~= "CoreEffectFolder" and GuiService.CoreEffectFolder == nil do

			end

			for k, v6 in pairs(v5) do
				v6.Parent = coreEffectFolder
				v6.CanTouch = false
				v6.CanCollide = false
				v6.CanQuery = false
			end
		end)()
		return
	end

	for k, v6 in pairs(v5) do
		v6.Parent = coreEffectFolder
		v6.CanTouch = false
		v6.CanCollide = false
		v6.CanQuery = false
	end
end
local function removePartsFromGame(...)
	for k, v5 in pairs({ ... }) do
		v5.Parent = nil
	end
end

local function getLocalHumanoid()
	local character = localPlayer.Character

	if not character then
		return
	end

	for i, humanoid in pairs(character:GetChildren()) do
		if humanoid:IsA("Humanoid") then
			return humanoid
		end
	end
end

local function applyExpCurve(p2, p3)
	local v5 = p2 ^ p3

	if v5 ~= v5 then
		v5 = math.abs(p2) ^ p3
	end

	return v5
end

local v5 = {
	Disabled = 0,
	Pointer = 1,
	Navigation = 2,
	Hidden = 3,
	DualPointer = 4
}

local v6 = { Right = 0, Left = 1 }

local v7 = {
	MODE_ENABLED = true,
	ARC_COLOR_GOOD = 0,
	ARC_COLOR_BAD = 0,
	ARC_THICKNESS = 0.0125,
	PLOP_GOOD = "rbxasset://textures/ui/VR/VRPointerDiscBlue.png",
	PLOP_BAD = "rbxasset://textures/ui/VR/VRPointerDiscRed.png",
	PLOP_BALL_COLOR_GOOD = 0,
	PLOP_BALL_COLOR_BAD = 0,
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

local color = Color3.fromRGB(0, 162, 255)
v7.ARC_COLOR_GOOD = Color3.new(color.r ^ 2.2, color.g ^ 2.2, color.b ^ 2.2)
local color2 = Color3.fromRGB(253, 68, 72)
v7.ARC_COLOR_BAD = Color3.new(color2.r ^ 2.2, color2.g ^ 2.2, color2.b ^ 2.2)

v7.PLOP_BALL_COLOR_GOOD = BrickColor.new("Bright green")
v7.PLOP_BALL_COLOR_BAD = BrickColor.new("Bright red")

local v8 = {
	MODE_ENABLED = true,
	ARC_COLOR_GOOD = v7.ARC_COLOR_GOOD,
	ARC_COLOR_BAD = v7.ARC_COLOR_BAD,
	ARC_COLOR_HIT = 0,
	ARC_THICKNESS = 0.01,
	MAX_DISTANCE = 50,
	G = 0,
	SWITCH_AIM_THRESHOLD = 0.2617993877991494,
	TRANSITION_DURATION = 0.075
}
local color3 = Color3.fromRGB(0, 255, 162)
v8.ARC_COLOR_HIT = Color3.new(color3.r ^ 2.2, color3.g ^ 2.2, color3.b ^ 2.2)

local vector2 = Vector2.new(0, 0)
local vector2_2 = Vector2.new(1, 1)

local class = {}
class.__index = class
class.Mode = v5

function class.new(p2)
	local object = setmetatable({}, class)

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

	object.parabola = create("ParabolaAdornment")({
		Name = "LaserPointerParabola",
		Parent = CoreGui,
		A = -1,
		B = 2,
		C = 0,
		Color3 = nil,
		Thickness = v7.ARC_THICKNESS,
		Visible = false
	})

	object.originPart = create("Part")({
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

	object.parabolaOffhand = create("ParabolaAdornment")({
		Name = "LaserPointerparabolaOffhand",
		Parent = CoreGui,
		A = 0,
		B = 1e-6,
		C = 0,
		Color3 = Color3.new(1, 1, 1),
		Transparency = 0.5,
		Thickness = v7.ARC_THICKNESS,
		Visible = false
	})

	object.originPartOffhand = create("Part")({
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

	object.plopPart = create("Part")({
		Name = "LaserPointerTeleportPlop",
		Anchored = true,
		CanCollide = false,
		Size = Vector3.new(0.2, 0.2, 0.2),
		Transparency = 1
	})

	object.plopBall = create("Part")({
		Name = "LaserPointerTeleportPlopBall",
		Anchored = true,
		CanCollide = false,
		TopSurface = Enum.SurfaceType.SmoothNoOutlines,
		BottomSurface = Enum.SurfaceType.SmoothNoOutlines,
		Material = Enum.Material.Neon,
		BrickColor = v7.PLOP_BALL_COLOR_GOOD,
		Shape = Enum.PartType.Ball,
		Size = Vector3.new(1, 1, 1) * v7.PLOP_BALL_SIZE
	})

	object.plopAdorn = create("ImageHandleAdornment")({
		Name = "LaserPointerTeleportPlopAdorn",
		Parent = object.plopPart,
		Adornee = object.plopPart,
		Size = vector2_2 * v7.PLOP_SIZE,
		Image = v7.PLOP_GOOD
	})

	object.plopAdornPulse = create("ImageHandleAdornment")({
		Name = "LaserPointerTeleportPlopAdornPulse",
		Parent = object.plopPart,
		Adornee = object.plopPart,
		Size = vector2,
		Image = v7.PLOP_GOOD,
		Transparency = 0.5
	})

	object.cursorPart = create("Part")({
		Name = "Cursor",
		CanCollide = false,
		CanQuery = false,
		CanTouch = false,
		Anchored = true,
		Transparency = 1
	})

	local v9 = create("SurfaceGui")

	local v10 = if engineFeature then object.cursorPart else nil
	local v11 = if engineFeature then CoreGui else object.cursorPart
	object.cursorSurfaceGui = v9({
		Name = "CursorSurfaceGui",
		Active = false,
		AlwaysOnTop = true,
		Enabled = false,
		ZOffset = 10,
		Adornee = v10,
		Parent = v11
	})

	object.cursorImage = create("ImageLabel")({
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
	VRService.Changed:connect(function(p3)
		if p3 == "GuiInputUserCFrame" then
			object.inputUserCFrame = VRService.GuiInputUserCFrame
		elseif p3 == "PointerHitCFrame" or p3 == "DidPointerHit" then
			object:cursorInputsChanged()
		elseif p3 == "VRSessionState" and VRService.VRSessionState == Enum.VRSessionState.Focused then
			object:updateInputUserCFrame()
		end
	end)

	VRService.LaserPointerTriggered:connect(function(p3)
		if
			game:GetEngineFeature("ImprovedTriggerFire")
			and p3.UserInputState ~= Enum.UserInputState.End
		then
			return
		end

		if
			(p3.KeyCode == Enum.KeyCode.ButtonR1 or p3.KeyCode == Enum.KeyCode.ButtonR2 or p3.KeyCode == Enum.KeyCode.ButtonR3 or p3.KeyCode == Enum.KeyCode.ButtonA or p3.KeyCode == Enum.KeyCode.ButtonB)
			and object.laserHand ~= 0
		then
			object.laserHand = 0
			object:updateInputUserCFrame()
		elseif
			(p3.KeyCode == Enum.KeyCode.ButtonL1 or p3.KeyCode == Enum.KeyCode.ButtonL2 or p3.KeyCode == Enum.KeyCode.ButtonL3 or p3.KeyCode == Enum.KeyCode.ButtonX or p3.KeyCode == Enum.KeyCode.ButtonY)
			and object.laserHand ~= 1
		then
			object.laserHand = 1
			object:updateInputUserCFrame()
		end
	end)

	VRService.UserCFrameEnabled:Connect(function(p3, p4)
		object:updateInputUserCFrame()
	end)

	object:updateInputUserCFrame()

	return object
end

function class.hasAnyHandController()
	return VRService:GetUserCFrameEnabled(Enum.UserCFrame.RightHand)
		or VRService:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand)
end

function class.getModeName(p2)
	for k, v9 in pairs(v5) do
		if p2 == v9 then
			return k
		end
	end

	return "unknown"
end

function class:updateInputUserCFrame()
	local guiInputUserCFrame = if defineFastFlag then VRService.GuiInputUserCFrame else nil

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

function class:onModeChanged(p2)
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

function class:setMode(p3)
	if p3 == v5.Disabled or p3 == v5.Hidden then
		VRService.LaserPointer = Enum.VRLaserPointerMode.Disabled
	elseif p3 == v5.Pointer or p3 == v5.Navigation then
		VRService.LaserPointer = Enum.VRLaserPointerMode.Pointer
	elseif p3 == v5.DualPointer then
		VRService.LaserPointer = Enum.VRLaserPointerMode.DualPointer
	end
end

function class.setEnableAmbidexterousPointer(p2, p3) end

function class.calculateLaunchVelocity(p2, p3, p4, p5)
	return -(math.sqrt(p3 / 0.7071067811865476) * p4) / math.sqrt(2 * p5 * 0.7071067811865476 + 2 * p4 * 0.7071067811865476)
end

function class:isHeadMounted(): boolean
	return VRService.GuiInputUserCFrame == Enum.UserCFrame.Head
end

function class:shouldForcePointer()
	return self.externalForcePointer or self.guiMenuIsOpen
end

function class:setForcePointer(externalForcePointer)
	self.externalForcePointer = externalForcePointer
end

function class.getNavigationOrigin(p2)
	local localHumanoid = getLocalHumanoid()

	if not localHumanoid then
		return
	end

	local torso = localHumanoid.Torso

	if not torso then
		return
	end

	local hipHeight = localHumanoid.HipHeight
	local v9 = localHumanoid.RigType == Enum.HumanoidRigType.R6 and 2 or hipHeight

	local v10 = torso.Size.Y / 2
	return torso.Position + Vector3.new(0, -v10 - v9, 0)
end

function class.horzDistanceFromCharacter(p2, p3)
	local character = localPlayer.Character

	if not character then
		return 1e999
	end

	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

	if humanoidRootPart then
		return ((humanoidRootPart:GetRenderCFrame().p - p3) * Vector3.new(1, 0, 1)).magnitude
	end

	return 1e999
end

function class:onNavigateAction(p2, p3, p4)
	if p3 == Enum.UserInputState.Begin then
		VRService:RequestNavigation(
			CFrame.new(self.navHitPoint, self.navHitPoint + self.navHitNormal) * CFrame.Angles(1.5707963267948966, 0, 0),
			self.inputUserCFrame
		)
	end
end

function class:setNavigationActionEnabled(p2)
	if p2 then
		ContextActionService:BindCoreAction("LaserPointerNavigate", function(...)
			self:onNavigateAction(...)
		end, false, Enum.KeyCode.ButtonA)
	else
		ContextActionService:UnbindCoreAction("LaserPointerNavigate")
	end
end

function class.setArcLaunchParams(p2, p3, p4, p5, p6)
	local v9 = math.cos(p3) * p4
	local v10 = math.sin(p3) * p4

	local v11 = v9 == 0 and 1e-6 or v9

	p2.parabola.A = -(0.5 * p5) * (1 / v11 ^ 2)
	p2.parabola.B = v10 / v11
	p2.parabola.C = 0
	p2.parabola.Range = p6 * 1.5
end

function class.renderAsParabola(p2, p3, p4)
	local v9 = p4 * Vector3.new(1, 0, 1)
	p2.originPart.CFrame = CFrame.new(p3, p3 + v9) * CFrame.Angles(0, 1.5707963267948966, 0)
end

function class:renderAsLaser(p3, p4)
	self.originPart.CFrame = CFrame.new(p3, p4) * CFrame.Angles(0, 1.5707963267948966, 0)
	self.parabola.A = 0
	self.parabola.B = 1e-6
	self.parabola.C = 0
	self.parabola.Range = (p4 - p3).magnitude
end

function class:renderOffhandLaser(p3, p4)
	self.originPartOffhand.CFrame = CFrame.new(p3, p4) * CFrame.Angles(0, 1.5707963267948966, 0)
	self.parabolaOffhand.Range = (p4 - p3).magnitude
end

function class:canNavigateTo(p3, p4, p5): boolean
	local character = localPlayer.Character

	if not (character and character:FindFirstChild("HumanoidRootPart")) then
		return false
	end

	if p3 then
		return not (p5.Y < -1e-6)
	end

	return false
end

function class:checkHeadMountedMode(instance)
	if self:shouldForcePointer() then
		self:setMode(v5.Pointer)
		return
	end

	local coreGuiFolder = GuiService.CoreGuiFolder

	if instance and instance:IsDescendantOf(coreGuiFolder) then
		self:setMode(v5.Pointer)
	else
		self:setMode(v5.Navigation)
	end
end

function class:setNavigationValidState(navigationIsValid)
	if navigationIsValid == self.navigationIsValid then
		return
	end

	self.navigationIsValid = navigationIsValid
	self.lastNavigationValidityChangeTime = tick()

	if navigationIsValid then
		self.plopBallBounceStart = tick()
		self.parabola.Color3 = v7.ARC_COLOR_GOOD
		self.plopAdorn.Visible = true
		self.plopAdorn.Image = v7.PLOP_GOOD
		self.plopAdornPulse.Visible = true
		self.plopAdornPulse.Image = v7.PLOP_GOOD
		self.plopBall.BrickColor = v7.PLOP_BALL_COLOR_GOOD
	else
		self.parabola.Color3 = v7.ARC_COLOR_BAD
		self.plopAdorn.Visible = false
		self.plopAdorn.Image = v7.PLOP_BAD
		self.plopAdornPulse.Visible = false
		self.plopAdornPulse.Image = v7.PLOP_BAD
		self.plopBall.BrickColor = v7.PLOP_BALL_COLOR_BAD
	end
end

function class:updateNavPlop(p2, p3)
	local v9 = tick() - self.plopBallBounceStart

	local cframe = CFrame.new(p2, p2 + p3)
	local v10

	if self.navigationIsValid then
		local v11 = math.sin(v9 * 2 * 3.141592653589793 / v7.BALL_WAVE_PERIOD)
		local BALL_WAVE_EXP = v7.BALL_WAVE_EXP
		local v12 = v11 ^ BALL_WAVE_EXP

		if v12 ~= v12 then
			v12 = math.abs(v11) ^ BALL_WAVE_EXP
		end

		v10 = v7.BALL_WAVE_START + v12 * v7.BALL_WAVE_AMPLITUDE
	else
		v10 = 0
	end

	self.plopPart.CFrame = cframe
	self.plopBall.CFrame = cframe * CFrame.new(0, 0, -v10)

	local v11 = v9 % v7.PULSE_PERIOD

	if v11 > 0 then
		local v12 = v11 / v7.PULSE_DURATION

		if v12 < 1 then
			self.plopAdornPulse.Visible = true
			local plopAdornPulse = self.plopAdornPulse

			local PULSE_SIZE_0 = v7.PULSE_SIZE_0
			local PULSE_EXP = v7.PULSE_EXP
			local v14 = v12 ^ PULSE_EXP

			if v14 ~= v14 then
				v14 = math.abs(v12) ^ PULSE_EXP
			end

			plopAdornPulse.Size = vector2_2 * (PULSE_SIZE_0 + v14 * (v7.PULSE_SIZE_1 - v7.PULSE_SIZE_0))

			self.plopAdornPulse.Transparency = 0.5 + v12 * 0.5
		else
			self.plopAdornPulse.Visible = false
			self.plopAdornPulse.Size = vector2
			self.pulseStartTime = tick() + v7.PULSE_PERIOD
		end
	end
end

function class:updateNavigationMode(navHitPoint, navHitNormal, navHitPart)
	self.navHitPoint = navHitPoint
	self.navHitNormal = navHitNormal
	self.navHitPart = navHitPart

	self:updateNavPlop(navHitPoint, navHitNormal)
	self:setNavigationValidState(self:canNavigateTo(self.navHitPart, self.navHitPoint, self.navHitNormal))
end

function class:showHitBallOnLaserPointer(p2)
	if p2 then
		if not self.showPlopBallOnPointer then
			self.showPlopBallOnPointer = true
			addPartsToGame(self.plopBall)
		end
	elseif self.showPlopBallOnPointer then
		removePartsFromGame(self.plopBall)
		self.showPlopBallOnPointer = false
	end
end

function class:cursorInputsChanged()
	local didPointerHit = VRService.DidPointerHit
	self.cursorSurfaceGui.Enabled = didPointerHit

	if didPointerHit then
		local pointerHitCFrame = VRService.PointerHitCFrame

		local v9 = (VRUtil.GetUserCFrameWorldSpace(Enum.UserCFrame.Head).Position - pointerHitCFrame.Position).magnitude * 0.01
		local v10

		if v9 < 0.05 then
			v10 = v9 / 0.05
			v9 = 0.05
		else
			v10 = 1
		end

		self.cursorPart.Size = Vector3.new(v9, v9, v9)
		local cframe = CFrame.new(0, 0, v9 * 0.5)
		self.cursorPart.CFrame = pointerHitCFrame * cframe
		self.cursorImage.Size = UDim2.new(v10, 0, v10, 0)
	end
end

function class:updateCursor_DEPRECATED()
	if VRService.DidPointerHit then
		local v9 = VRService.PointerHitCFrame
		local v10 = VRUtil.GetUserCFrameWorldSpace(self.inputUserCFrame)

		if self:isHeadMounted() then
			v10 = VRUtil.GetUserCFrameWorldSpace(Enum.UserCFrame.Head)
		end

		local p2 = v10.p
		local lookVector = v10.lookVector

		local position = v9.Position
		local lookVector2 = v9.lookVector
		local dot = lookVector2:Dot(lookVector)

		if math.abs(dot) > 0.001 then
			local v11 = p2 + (position - p2):Dot(lookVector2) / dot * lookVector
			v9 = v9.Rotation + v11
		end

		local v11 = (workspace.CurrentCamera.CFrame.Position - v9.Position).magnitude * 0.01
		local v12

		if v11 < 0.05 then
			v12 = v11 / 0.05
			v11 = 0.05
		else
			v12 = 1
		end

		self.cursorPart.Size = Vector3.new(v11, v11, v11)
		local cframe = CFrame.new(0, 0, v11 * 0.5)
		self.cursorPart.CFrame = v9 * cframe
		self.cursorImage.Size = UDim2.new(v12, 0, v12, 0)
	end

	self.cursorSurfaceGui.Enabled = VRService.DidPointerHit
end

function class:disableComponent()
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

	for k, connection in pairs(self.connections) do
		connection:Disconnect()
	end

	self.connections = {}
end

function class:update(p2)
	if VRService.LaserPointer == Enum.VRLaserPointerMode.Disabled then
		return
	end

	self.parabola.Thickness = v8.ARC_THICKNESS * workspace.CurrentCamera.HeadScale
	self.parabolaOffhand.Thickness = v8.ARC_THICKNESS * workspace.CurrentCamera.HeadScale

	if localPlayer and localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Tool") then
		self.parabola.Color3 = v8.ARC_COLOR_BAD
	else
		self.parabola.Color3 = VRService.DidPointerHit and v8.ARC_COLOR_HIT or v8.ARC_COLOR_GOOD
	end

	local userCFrameWorldSpace = VRUtil.GetUserCFrameWorldSpace(self.inputUserCFrame)
	local p3 = userCFrameWorldSpace.p
	local lookVector = userCFrameWorldSpace.lookVector
	local v9

	if VRService.DidPointerHit then
		v9 = p3 + lookVector * (VRService.PointerHitCFrame.Position - p3).magnitude
	else
		v9 = p3 + lookVector * self.laserMaxDistance
	end

	if self:isHeadMounted() then
		self.parabola.Visible = false
	else
		self.parabola.Visible = true
		self:renderAsLaser(p3, v9)
	end

	if VRService.LaserPointer == Enum.VRLaserPointerMode.DualPointer then
		if self:isHeadMounted() then
			self.parabolaOffhand.Visible = false
			return
		end

		self.parabolaOffhand.Visible = true
		local v10

		if self.inputUserCFrame == Enum.UserCFrame.RightHand then
			v10 = Enum.UserCFrame.LeftHand
		else
			v10 = Enum.UserCFrame.RightHand
		end

		local userCFrameWorldSpace2 = VRUtil.GetUserCFrameWorldSpace(v10)
		local p4 = userCFrameWorldSpace2.p
		self:renderOffhandLaser(p4, p4 + userCFrameWorldSpace2.lookVector * 3)
	end
end

return class
