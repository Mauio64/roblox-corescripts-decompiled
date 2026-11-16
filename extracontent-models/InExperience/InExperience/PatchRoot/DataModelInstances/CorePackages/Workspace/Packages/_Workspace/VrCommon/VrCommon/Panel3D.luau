local VrCommon = script:FindFirstAncestor("VrCommon")
local parent = VrCommon.Parent

local VRService = game:GetService("VRService")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")
local VRUtil = require(VrCommon.VRUtil)
local AppCommonLib = require(parent.AppCommonLib)
local Create = AppCommonLib.Create

local HttpService = game:GetService("HttpService")
local v = "Panel3DRenderStep-" .. HttpService:GenerateGUID()

local vector2 = Vector2.new(0, 0)

local cframe = CFrame.new(0, -0.5, -5.5)
local cframe2 = CFrame.new(0, 0, -3)

local v2 = CFrame.new(0, 0, -0.1) * CFrame.Angles(0, 3.141592653589793, 0)

local v3 = nil
local v4 = nil
local v5 = 1e999
local v6 = nil
local v7 = vector2
local v8 = {}
local v9 = Create("ImageLabel")({
	Image = "rbxasset://textures/Cursors/Gamepad/Pointer.png",
	ImageColor3 = Color3.new(0, 1, 0),
	BackgroundTransparency = 1,
	ZIndex = 1000000000
})

local v10 = Create("Folder")({ Name = "VRCorePanelParts", Archivable = false })

local coreEffectFolder = Create("Folder")({ Name = "VRCoreEffectParts", Archivable = false })

pcall(function()
	GuiService.CoreGuiFolder = v10
	GuiService.CoreEffectFolder = coreEffectFolder
end)

local Panel3D = {
	Type = {
		None = 0,
		Standard = 1,
		Fixed = 2,
		HorizontalFollow = 3,
		FixedToHead = 4,
		NewStandard = 5,
		WristView = 6,
		PositionLocked = 7,
		UIManagerManaged = 8
	},
	["OnPanelClosed"] = Create("BindableEvent")({ Name = "OnPanelClosed" }),
	GetHeadLookXZ = function(p)
		local userCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
		local lookVector = userCFrame.lookVector
		local v11 = math.atan2(-lookVector.Z, lookVector.X) - 1.5707963267948966
		local cframe3 = CFrame.Angles(0, v11, 0)

		if p then
			cframe3 += userCFrame.p
		end

		return cframe3
	end,
	FindContainerOf = function(descendant)
		for _, v11 in pairs(v8) do
			if v11.gui and v11.gui:IsAncestorOf(descendant) then
				return v11
			end

			for _, subpanel in pairs(v11.subpanels) do
				if subpanel.gui and subpanel.gui:IsAncestorOf(descendant) then
					return v11
				end
			end
		end

		return nil
	end,
	SetModalPanel = function(object)
		if v3 == object then
			return
		end

		if v3 then
			v3:OnModalChanged(false)
		end

		if object then
			object:OnModalChanged(true)
		end

		v4 = v3
		v3 = object
	end,
	RaycastOntoPanel = function(object, p, p2, p3)
		local size = object.Size
		local z = size.Z
		local x = size.X
		local y = size.Y

		local renderCFrame = object:GetRenderCFrame()
		local lookVector = renderCFrame.lookVector
		local v11 = renderCFrame.p + lookVector * z * 0.5

		local rayPlaneIntersection = VRUtil.RayPlaneIntersection(p3, lookVector, v11)

		if not rayPlaneIntersection then
			return nil, nil, nil, false
		end

		local x2 = p.AbsoluteSize.X
		local y2 = p.AbsoluteSize.Y

		local v12 = renderCFrame:pointToObjectSpace(rayPlaneIntersection) * Vector3.new(-1, 1, 1) + Vector3.new(x / 2, -y / 2, 0)

		local vector2_2 = Vector2.new(v12.X / x * x2, v12.Y / y * -y2)

		local x3 = vector2_2.X
		local y3 = vector2_2.Y
		local x4 = p2.AbsolutePosition.X
		local y4 = p2.AbsolutePosition.Y
		local x5 = p2.AbsoluteSize.X
		local y5 = p2.AbsoluteSize.Y

		return
			rayPlaneIntersection,
			v12,
			vector2_2,
			p.Enabled and x4 <= x3 and x3 <= x4 + x5 and y4 <= y3 and y3 <= y4 + y5 and true or false
	end
}

local class = {}
class.__index = class
function class.new(name)
	local v11 = {
		name = name,
		part = false,
		gui = false,
		width = 1,
		height = 1,
		isVisible = false,
		isEnabled = false,
		panelType = Panel3D.Type.None,
		pixelScale = 1,
		showCursor = true,
		canFade = true,
		shouldFindLookAtGuiElement = false,
		ignoreModal = false,
		needsPositionUpdate = false,
		alwaysUpdatePosition = false,
		linkedTo = false,
		subpanels = {},
		transparency = 0,
		forceShowUntilLookedAt = false,
		forceShowUntilTick = 0,
		isLookedAt = false,
		isWristHeldUp = false,
		isOffscreen = true,
		lookAtPixel = Vector2.new(-1, -1),
		cursorPos = Vector2.new(-1, -1),
		lookAtDistance = 1e999,
		lookAtGuiElement = false,
		isClosest = true,
		localCF = CFrame.new(),
		originCF = CFrame.new(),
		angleFromHorizon = false,
		angleFromForward = false,
		distance = 0,
		lerpTime = 0,
		lerpInitialCF = nil,
		lerpScaleSize = Vector2.new(0, 0),
		lerpInitialSize = Vector2.new(0, 0),
		FollowView = true,
		LastFollowCF = nil,
		LastCameraPos = Vector3.new(0, 0, 0),
		wristTargetPosition = Vector3.new()
	}

	if v8[name] then
		error("A panel by the name of " .. name .. " already exists.")
	end

	v8[name] = v11

	return (setmetatable(v11, class))
end

function class:GetPart()
	if not self.part then
		self.part = Create("Part")({
			Name = self.name,
			Parent = v10,
			Transparency = 1,
			CanCollide = false,
			CanTouch = false,
			Anchored = true,
			Size = Vector3.new(1, 1, 0.2)
		})
	end

	return self.part
end

function class:GetGUI()
	if not self.gui then
		local part = self:GetPart()
		self.gui = Create("SurfaceGui")({
			Parent = CoreGui,
			Name = self.name,
			Archivable = false,
			Adornee = part,
			Active = true,
			ToolPunchThroughDistance = 1000,
			CanvasSize = self.CanvasSize or Vector2.new(1000, 1000),
			Enabled = self.isEnabled,
			AlwaysOnTop = true
		})
	end

	return self.gui
end

function class.FindHoveredGuiElement(p, items)
	local x = p.lookAtPixel.X
	local y = p.lookAtPixel.Y

	for k, item in pairs(items) do
		local absolutePosition = item.AbsolutePosition
		local v11 = item.AbsolutePosition + item.AbsoluteSize

		if absolutePosition.X <= x and x <= v11.X and absolutePosition.Y <= y and y <= v11.Y then
			return item, k
		end
	end
end

function class:SetPartCFrame(p)
	local part = self:GetPart()
	part.CFrame = p * v2
end

function class:SetEnabled(isEnabled)
	if self.isEnabled == isEnabled then
		return
	end

	self.isEnabled = isEnabled

	if isEnabled then
		local part = self:GetPart()
		part.Parent = v10
		local gui = self:GetGUI()
		gui.Enabled = true
	else
		local part = self:GetPart()
		part.Parent = nil
		local gui = self:GetGUI()
		gui.Enabled = false
	end

	for _, subpanel in pairs(self.subpanels) do
		subpanel:SetEnabled(subpanel:GetEnabled())
	end

	self:OnEnabled(isEnabled)
end

function class:StartLerp(p)
	if self.panelType == Panel3D.Type.UIManagerManaged then
		return
	end

	self.lerpInitialCF = self:GetPart().CFrame * CFrame.new(0, -1.5, 0)
	self.lerpTime = 1
	self.lerpInitialSize = Vector2.new(self.width, self.height)
	self.lerpScaleSize = p and p or Vector2.new(0, 0)
end

function class:EvaluatePositioning(p, p2, p3, p4)
	if self.panelType == Panel3D.Type.UIManagerManaged then
		return
	end

	if self.panelType == Panel3D.Type.Fixed then
		self:SetPartCFrame(p * (self.localCF - self.localCF.p + self.localCF.p * workspace.CurrentCamera.HeadScale))
	elseif self.panelType == Panel3D.Type.HorizontalFollow then
		local lookVector = p3.lookVector
		self:SetPartCFrame(p * (CFrame.new(p3.p, p3.p + lookVector * Vector3.new(1, 0, 1)) * self.angleFromForward * self.angleFromHorizon * CFrame.new(
			0,
			0,
			workspace.CurrentCamera.HeadScale * -self.distance
		)))
	elseif self.panelType == Panel3D.Type.FixedToHead then
		self:SetPartCFrame(p2 * (self.localCF - self.localCF.p + self.localCF.p * workspace.CurrentCamera.HeadScale))
	elseif self.panelType == Panel3D.Type.Standard then
		if self.needsPositionUpdate or self.alwaysUpdatePosition then
			self.needsPositionUpdate = false
			local headLookXZ = Panel3D.GetHeadLookXZ(true)
			local v11 = cframe.Position * workspace.CurrentCamera.HeadScale
			self.originCF = headLookXZ * CFrame.new(v11)
		end

		self:SetPartCFrame(p * self.originCF * self.localCF)
	elseif self.panelType == Panel3D.Type.NewStandard then
		if self.needsPositionUpdate or self.alwaysUpdatePosition then
			self.needsPositionUpdate = false
			local userCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
			local v11 = cframe2.Position * workspace.CurrentCamera.HeadScale
			self.originCF = userCFrame * CFrame.new(v11)
		end

		self:SetPartCFrame(p * self.originCF * self.localCF)
	elseif self.panelType == Panel3D.Type.WristView then
		if VRService:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand) then
			if self.needsPositionUpdate or self.alwaysUpdatePosition then
				self.needsPositionUpdate = false
				local v11 = VRService:GetUserCFrame(Enum.UserCFrame.LeftHand).Position * workspace.CurrentCamera.HeadScale
				self.originCF = CFrame.new(v11)
			end

			local v11 = p * VRService:GetUserCFrame(Enum.UserCFrame.Head)

			local v12 = (p * self.originCF).Position

			if self.distance > 0 then
				local vector3 = Vector3.new(v12.x, v11.Position.y - 0.33, v12.z)

				local v13 = math.clamp((vector3 - v11.Position).Magnitude, self.distance - 0.5, self.distance + 0.5)

				local v14 = (vector3 - v11.Position).Unit * v13
				v12 = v11.Position + v14
			end

			local vector3 = Vector3.new(v11.Position.x, v12.y, v11.Position.z)

			local cframe3 = CFrame.new(v12, vector3)

			local part = self:GetPart()
			part.CFrame = cframe3
		else
			self:SetPartCFrame(p * (self.localCF - self.localCF.p + self.localCF.p * workspace.CurrentCamera.HeadScale))
		end
	elseif self.panelType == Panel3D.Type.PositionLocked then
		local userCFrameWorldSpace = VRUtil.GetUserCFrameWorldSpace(Enum.UserCFrame.Head)

		if not self.LastFollowCF then
			self.LastFollowCF = userCFrameWorldSpace
		end

		if (self.LastCameraPos - p.Position).Magnitude > 0.1 then
			self.LastFollowCF = userCFrameWorldSpace
		end

		self.LastCameraPos = p.Position

		if self.LastFollowCF.LookVector:Dot(userCFrameWorldSpace.LookVector) < 0.85 then
			self.FollowView = true
		elseif self.LastFollowCF.LookVector:Dot(userCFrameWorldSpace.LookVector) > 0.99 then
			self.FollowView = false
		end

		if self.FollowView then
			self.LastFollowCF = self.LastFollowCF:Lerp(userCFrameWorldSpace, 0.1)
		end

		local v11 = userCFrameWorldSpace.Position + self.LastFollowCF.LookVector * (self.distance * workspace.CurrentCamera.HeadScale + 0.1)
		local vector3 = Vector3.new(
			v11.X,
			userCFrameWorldSpace.Position.Y - 0.5 * workspace.CurrentCamera.HeadScale,
			v11.Z
		)

		local vector3_2 = Vector3.new(userCFrameWorldSpace.Position.x, vector3.y, userCFrameWorldSpace.Position.z)

		local cframe3 = CFrame.new(vector3, vector3_2)

		local part = self:GetPart()
		part.CFrame = cframe3
	end

	if self.lerpInitialCF and self.lerpTime > 0 then
		local cframe3 = self:GetPart().CFrame

		self.lerpTime -= p4 * 4
		local v11 = math.clamp(1 - self.lerpTime, 0, 1)
		local lerped = self.lerpInitialCF:Lerp(cframe3, v11)

		local part = self:GetPart()
		part.CFrame = lerped

		if self.lerpScaleSize.x > 0 or self.lerpScaleSize.y > 0 then
			local lerped2 = self.lerpInitialSize:Lerp(self.lerpScaleSize, v11)
			self:ResizeStuds(lerped2.x, lerped2.y, self.pixelsPerStud)
		end
	end
end

function class:SetLookedAt(p)
	if self.isLookedAt or not p then
		if self.isLookedAt and not p then
			self.isLookedAt = false
			self:OnMouseLeave(self.lookAtPixel.X, self.lookAtPixel.Y)
		end
	else
		self.isLookedAt = true
		self:OnMouseEnter(self.lookAtPixel.X, self.lookAtPixel.Y)

		if self.forceShowUntilLookedAt then
			self.forceShowUntilLookedAt = false
		end
	end
end

function class:EvaluateGaze(p, p2, _, _, p3)
	self.isClosest = false
	self.lookAtPixel = vector2
	self.lookAtDistance = 1e999
	local v11 = 0
	local v12 = nil

	for _, subpanel in pairs(self.subpanels) do
		if not (subpanel.part and subpanel.guiElement) then
			continue
		end

		local raycastOntoPanel, _, v13, v14 = Panel3D.RaycastOntoPanel(
			subpanel.part,
			subpanel.gui,
			subpanel.guiElement,
			p3
		)

		if not raycastOntoPanel then
			continue
		end

		subpanel.lookAtPixel = v13
		subpanel.cursorPos = v13

		if not (v14 and v11 < subpanel.depthOffset) then
			continue
		end

		v11 = subpanel.depthOffset
		v12 = subpanel
	end

	if v12 and v12.depthOffset > 0 then
		v7 = v12.cursorPos
		v6 = v12

		for _, subpanel in pairs(self.subpanels) do
			if subpanel ~= v12 then
				subpanel:SetLookedAt(false)
			end
		end

		v12:SetLookedAt(true)
	end

	if self.panelType == Panel3D.Type.WristView then
		self.isWristHeldUp = false
		local userCFrame = VRService:GetUserCFrame(Enum.UserCFrame.LeftHand)
		local v13 = userCFrame.Position * workspace.CurrentCamera.HeadScale
		local v14 = p * CFrame.new(v13)

		if self.distance == 0 then
			local v15 = p * VRService:GetUserCFrame(Enum.UserCFrame.Head)
			local position = v14.Position
			local vector3 = Vector3.new(position.x, v15.Position.y - 0.33, position.z)

			local v16 = math.clamp((vector3 - v15.Position).Magnitude, 0.5, 1)
			local v17 = (vector3 - v15.Position).Unit * v16
			self.isWristHeldUp = (v15.Position + v17 - v14.Position).Magnitude < 0.25
		else
			local userCFrame2 = VRService:GetUserCFrame(Enum.UserCFrame.RightHand)
			local v15 = userCFrame.Position - userCFrame2.Position
			local dot = userCFrame2.LookVector:Dot(v15)
			local v16 = userCFrame2.Position + userCFrame2.LookVector * dot

			if (userCFrame.Position - v16).Magnitude < 0.5 then
				self.isWristHeldUp = true
			end
		end
	end

	local gui = self:GetGUI()

	local raycastOntoPanel, _, v13, v14 = Panel3D.RaycastOntoPanel(self:GetPart(), gui, gui, p3)

	if raycastOntoPanel then
		self.isOffscreen = false

		self.lookAtPixel = v13
		self.cursorPos = v13

		self:SetLookedAt(v14)

		self.lookAtDistance = (raycastOntoPanel - p2.p).magnitude

		if self.isLookedAt and self.lookAtDistance < v5 and self.showCursor then
			v5 = self.lookAtDistance
			v6 = self

			if not v12 then
				v7 = self.cursorPos
			end
		end
	else
		self.isOffscreen = true

		if self.lookedAt then
			self.lookedAt = false
			self:OnMouseLeave(self.lookAtPixel.X, self.lookAtPixel.Y)
		end
	end
end

function class:EvaluateTransparency()
	if self.panelType == Panel3D.Type.UIManagerManaged then
		self.transparency = 1
	elseif self.forceShowUntilLookedAt or not self.canFade or self.forceShowUntilTick > tick() then
		self.transparency = 0
	elseif self.isLookedAt then
		self.transparency = 0
	elseif self.isOffscreen then
		self.transparency = 1
	else
		self.transparency = self:CalculateTransparency()
	end
end

function class:Update(p, p2, p3, p4, p5, p6)
	if (self.forceShowUntilLookedAt or self.forceShowUntilTick > tick()) and not self.part then
		self:GetPart()
		self:GetGUI()
	end

	if not self.part then
		return
	end

	local v11 = v3 == self
	local v12 = not v11 and self.linkedTo and self.linkedTo == v3 and true or v11

	if v3 and not v12 then
		self:SetEnabled(false)
		return
	end

	self:PreUpdate(p, p2, p3, p4, p6)

	if self.isVisible then
		self:EvaluatePositioning(p, p2, p3, p6)

		for _, subpanel in pairs(self.subpanels) do
			subpanel:Update()
		end

		self:EvaluateGaze(p, p2, p3, p4, p5)

		self:EvaluateTransparency(p, p2)
	elseif self.alwaysUpdatePosition then
		self:EvaluatePositioning(p, p2, p3, p6)
	end
end

function class:PreUpdate(_, _, _, _, _) end

function class:OnUpdate(_) end

function class:OnMouseEnter(_, _) end

function class:OnMouseLeave(_, _) end

function class:OnEnabled(_) end

function class:OnModalChanged(_) end

function class:OnVisibilityChanged(_) end

function class:CalculateTransparency()
	if not self.canFade then
		return 0
	end

	local x = self.gui.AbsoluteSize.X
	local y = self.gui.AbsoluteSize.Y
	local x2 = self.lookAtPixel.X
	local y2 = self.lookAtPixel.Y

	local v11 = x2 < 0 and -x2 or x2 - x
	local v12 = y2 < 0 and -y2 or y2 - y
	local v13 = x2 > 0 and x2 < x and 0 or v11

	local v14 = y2 > 0 and y2 < y and 0 or v12

	return (math.max(0, (math.min(1, (math.sqrt(v13 ^ 2 + v14 ^ 2) - 10) / 20))))
end

function class:ResizeStuds(width, height, value)
	if self.panelType == Panel3D.Type.UIManagerManaged then
		return
	end

	value = value or 64

	self.width = width
	self.height = height

	self.pixelScale = value / 64

	local part = self:GetPart()
	part.Size = Vector3.new(
		self.width * workspace.CurrentCamera.HeadScale,
		self.height * workspace.CurrentCamera.HeadScale,
		0.2
	)

	local gui = self:GetGUI()
	gui.CanvasSize = Vector2.new(value * self.width, value * self.height)

	for _, subpanel in pairs(self.subpanels) do
		if subpanel.part then
			subpanel.part.Size = part.Size
		end

		if subpanel.gui then
			subpanel.gui.CanvasSize = gui.CanvasSize
		end
	end
end

function class:ResizePixels(p, p2, value)
	value = value or 64

	self:ResizeStuds(p / value, p2 / value, value)
end

function class:OnHeadScaleChanged()
	local v11 = self.pixelScale * 64
	self:ResizeStuds(self.width, self.height, v11)
end

function class:SetType(panelType, options)
	self.panelType = panelType

	self.localCF = CFrame.new()

	self.angleFromHorizon = false
	self.angleFromForward = false
	self.distance = 0

	options = options or {}

	if panelType == Panel3D.Type.None then
		return
	end

	if panelType == Panel3D.Type.Standard then
		self.localCF = options.CFrame or CFrame.new()
	elseif panelType == Panel3D.Type.Fixed then
		self.localCF = options.CFrame or CFrame.new()
	elseif panelType == Panel3D.Type.HorizontalFollow then
		self.angleFromHorizon = CFrame.Angles(options.angleFromHorizon or 0, 0, 0)
		self.angleFromForward = CFrame.Angles(0, options.angleFromForward or 0, 0)
		self.distance = options.distance or 5
	elseif panelType == Panel3D.Type.FixedToHead then
		self.localCF = options.CFrame or CFrame.new()
	elseif panelType == Panel3D.Type.NewStandard then
		self.localCF = options.CFrame or CFrame.new()
	elseif panelType == Panel3D.Type.WristView then
		self.localCF = options.CFrame or CFrame.new()
		self.distance = 0
	elseif panelType == Panel3D.Type.PositionLocked then
		self.localCF = options.CFrame or CFrame.new()
	elseif panelType == Panel3D.Type.UIManagerManaged then
		self.part = options.uiManagerPanelPart
	else
		error("Invalid Panel type")
	end
end

function class.IsUIManagerManagedType(p): boolean
	return p.panelType == Panel3D.Type.UIManagerManaged
end

function class.IsPositionLockedType(p): boolean
	return p.panelType == Panel3D.Type.PositionLocked
end

function class:SetVisible(isVisible, p)
	if isVisible ~= self.isVisible then
		self:OnVisibilityChanged(isVisible)

		if isVisible then
			self.needsPositionUpdate = true

			if self.panelType == Panel3D.Type.WristView then
				self.originCF = VRService:GetUserCFrame(Enum.UserCFrame.Head) * cframe2
			end
		else
			Panel3D.OnPanelClosed:Fire(self.name)
		end
	end

	self.isVisible = isVisible
	self:SetEnabled(isVisible)

	if isVisible and p then
		Panel3D.SetModalPanel(self)
	end

	if not isVisible and v3 == self then
		if p then
			Panel3D.SetModalPanel(v4)
		else
			Panel3D.SetModalPanel(nil)

			if v4 == self then
				v4 = nil
			end
		end
	end

	if not isVisible and self.forceShowUntilLookedAt then
		self.forceShowUntilLookedAt = false
	end
end

function class.IsVisible(p)
	return p.isVisible
end

function class:LinkTo(linkedTo)
	if type(linkedTo) == "string" then
		self.linkedTo = Panel3D.Get(linkedTo)
	else
		self.linkedTo = linkedTo
	end
end

function class:ForceShowUntilLookedAt(p)
	self:GetPart()
	self:GetGUI()

	self:SetVisible(true, p)
	self:RequestPositionUpdate()
	self.forceShowUntilLookedAt = true
end

function class:ForceShowForSeconds(p)
	self:GetPart()
	self:GetGUI()

	self:SetVisible(true)

	if self.forceShowUntilTick < tick() then
		self:RequestPositionUpdate()
	end

	self.forceShowUntilTick = tick() + p
end

function class:SetCanFade(canFade)
	self.canFade = canFade
end

function class:RequestPositionUpdate()
	self.needsPositionUpdate = true
end

function class:ForcePositionUpdate(alwaysUpdatePosition)
	self.alwaysUpdatePosition = alwaysUpdatePosition
end

function class.GetGuiPositionInPanelSpace(p, p2)
	local vector2_2 = Vector2.new(p.part.Size.X, p.part.Size.Y)
	local absoluteSize = p.gui.AbsoluteSize
	local v11 = (p2 - absoluteSize / 2) / absoluteSize * vector2_2

	return (Vector3.new(v11.X, v11.Y, 0.1))
end

function class.GetCFrameInCameraSpace(data)
	if data.panelType == Panel3D.Type.Standard or data.panelType == Panel3D.Type.NewStandard then
		return data.originCF * data.localCF
	end

	return data.localCF or CFrame.new()
end

local class2 = {}
class2.__index = class2
function class2.new(parentPanel, instance)
	local v11 = {
		["parentPanel"] = parentPanel,
		guiElement = instance,
		lastParent = instance.Parent,
		ancestryConn = nil,
		changedConn = nil,
		lookAtPixel = Vector2.new(-1, -1),
		cursorPos = Vector2.new(-1, -1),
		lookedAt = false,
		isEnabled = true,
		part = nil,
		gui = nil,
		guiSurrogate = nil,
		depthOffset = 0
	}

	setmetatable(v11, class2)

	v11:GetGUI()
	v11:UpdateSurrogate()
	v11:WatchParent(v11.lastParent)

	instance.Parent = v11.guiSurrogate
	local function ancestryCallback(_, p)
		local gui = v11:GetGUI()
		gui.Enabled = v11.parentPanel:GetGUI():IsAncestorOf(v11.lastParent)

		if v11:GetGUI().Enabled then
			local part = v11:GetPart()
			part.Parent = workspace.CurrentCamera
		else
			local part = v11:GetPart()
			part.Parent = nil
		end

		if p == instance then
			v11.ancestryConn:disconnect()

			v11.lastParent = instance.Parent
			instance.Parent = v11.guiSurrogate
			v11:WatchParent(v11.lastParent)

			v11.ancestryConn = instance.AncestryChanged:connect(ancestryCallback)
		end
	end
	v11.ancestryConn = instance.AncestryChanged:connect(ancestryCallback)

	return v11
end

function class2:Cleanup()
	self.guiElement.Parent = self.lastParent

	if self.part then
		self.part:Destroy()
		self.part = nil
	end

	spawn(function()
		wait()

		if self.gui then
			self.gui:Destroy()
			self.gui = nil
		end
	end)

	if self.ancestryConn then
		self.ancestryConn:disconnect()
		self.ancestryConn = nil
	end

	if self.changedConn then
		self.changedConn:disconnect()
		self.changedConn = nil
	end

	self.lastParent = nil
	self.parentPanel = nil
	self.guiElement = nil
	self.guiSurrogate = nil
end

function class2:OnMouseEnter(_, _) end
function class2:OnMouseLeave(_, _) end

function class2:SetLookedAt(lookedAt)
	if lookedAt and not self.lookedAt then
		self:OnMouseEnter(self.lookAtPixel.X, self.lookAtPixel.Y)
	elseif not lookedAt and self.lookedAt then
		self:OnMouseLeave(self.lookAtPixel.X, self.lookAtPixel.Y)
	end

	self.lookedAt = lookedAt
end

function class2:WatchParent(p)
	if self.changedConn then
		self.changedConn:disconnect()
	end

	self.changedConn = p.Changed:connect(function(p2)
		if p2 == "AbsolutePosition" or p2 == "AbsoluteSize" or p2 == "Parent" then
			self:UpdateSurrogate()
		end
	end)
end

function class2:UpdateSurrogate()
	local lastParent = self.lastParent
	self.guiSurrogate.Position = UDim2.new(0, lastParent.AbsolutePosition.X, 0, lastParent.AbsolutePosition.Y)
	self.guiSurrogate.Size = UDim2.new(0, lastParent.AbsoluteSize.X, 0, lastParent.AbsoluteSize.Y)
end

function class2:GetPart()
	if self.part then
		return self.part
	end

	self.part = self.parentPanel:GetPart():Clone()
	self.part.Parent = v10
	return self.part
end

function class2:GetGUI()
	if self.gui then
		return self.gui
	end

	self.gui = Create("SurfaceGui")({
		Parent = CoreGui,
		Adornee = self:GetPart(),
		Active = true,
		ToolPunchThroughDistance = 1000,
		CanvasSize = self.parentPanel:GetGUI().CanvasSize,
		Enabled = self.parentPanel.isEnabled,
		AlwaysOnTop = true
	})

	self.guiSurrogate = Create("Frame")({
		Parent = self.gui,
		Active = false,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1
	})

	return self.gui
end

function class2:SetDepthOffset(depthOffset)
	self.depthOffset = depthOffset
end

function class2:Update()
	local part = self:GetPart()
	local part2 = self.parentPanel:GetPart()

	if part and part2 then
		part.CFrame = part2.CFrame * CFrame.new(0, 0, -self.depthOffset)
	end
end

function class2:SetEnabled(isEnabled)
	self.isEnabled = isEnabled

	if isEnabled and self.parentPanel.isEnabled then
		local part = self:GetPart()
		part.Parent = v10
		local gui = self:GetGUI()
		gui.Enabled = true
	else
		local part = self:GetPart()
		part.Parent = nil
		local gui = self:GetGUI()
		gui.Enabled = false
	end
end

function class2:GetEnabled()
	return self.isEnabled
end

function class2:GetPixelScale()
	return self.parentPanel:GetPixelScale()
end

function class:GetPixelScale()
	return self.pixelScale
end

function class:AddSubpanel(p)
	local v11 = class2.new(self, p)
	self.subpanels[p] = v11
	return v11
end

function class:RemoveSubpanel(p)
	local subpanel = self.subpanels[p]

	if subpanel then
		subpanel:Cleanup()
	end

	self.subpanels[p] = nil
end

function class:SetSubpanelDepth(p, p2)
	local selected = self.subpanels[p]

	if p2 == 0 then
		if selected then
			self:RemoveSubpanel(p)
		end

		return nil
	end

	selected = selected or self:AddSubpanel(p)

	selected:SetDepthOffset(p2)

	return selected
end

function Panel3D.Get(p)
	local v11 = v8[p]

	if not v8[p] then
		v8[p] = class.new(p)
		return v8[p]
	end

	return v11
end

local v11 = tick()
local function onRenderStep()
	if not VRService.VREnabled then
		return
	end

	local now = tick()
	local v12 = now - v11
	v11 = now

	v6 = nil
	v5 = 1e999

	local currentCamera = workspace.CurrentCamera
	local cframe3 = currentCamera.CFrame
	local renderCFrame = currentCamera:GetRenderCFrame()
	local userCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
	local ray = Ray.new(renderCFrame.p, renderCFrame.lookVector)

	local v13 = cframe3 * VRService:GetUserCFrame(VRService.GuiInputUserCFrame)
	local ray2 = Ray.new(v13.p, v13.lookVector)

	for _, v14 in pairs(v8) do
		v14:Update(cframe3, renderCFrame, userCFrame, ray, ray2, v12)
	end

	local set = {}

	for _, v14 in pairs(v8) do
		if set[v14] or not v14.linkedTo or not v14.isVisible or not v14.linkedTo.isVisible then
			continue
		end

		set[v14] = true
		set[v14.linkedTo] = true

		local transparency = math.min(v14.transparency, v14.linkedTo.transparency)
		v14.transparency = transparency
		v14.linkedTo.transparency = transparency
	end

	for _, v14 in pairs(v8) do
		if v14.part and v14.gui then
			local v15 = v3 == v14
			local v16 = not v15 and v14.linkedTo and v14.linkedTo == v3 and true or v15

			local v17 = v14.isVisible

			if not v16 and v3 then
				v17 = false
			end

			if v14.transparency >= 1 then
				v17 = false
			end

			local v18 = v14.forceShowUntilLookedAt and true or v17

			v14:SetEnabled(not v14.canFade and v14.isVisible and true or v18)
		end

		v14:OnUpdate(v12)
	end

	if not v6 then
		v9.Parent = nil

		return
	end

	local x = v7.X
	local y = v7.Y
	local pixelScale = v6:GetPixelScale()
	v9.Size = UDim2.new(0, 3 * pixelScale, 0, 3 * pixelScale)
	v9.Position = UDim2.new(0, x - v9.AbsoluteSize.x * 0.5, 0, y - v9.AbsoluteSize.y * 0.5)
end

local v12 = true
local function putFoldersIn(currentCamera) -- 3 equivalent calls inferred from this helper
	v10.Parent = currentCamera
	coreEffectFolder.Parent = currentCamera
end

local headScaleChangedConnection = nil
local function onHeadScaleChanged() -- 1 equivalent call inferred from this helper
	for _, v13 in pairs(v8) do
		v13:OnHeadScaleChanged()
	end
end

local cFrameChangedConnection = nil
local function onCameraCFrameChanged()
	local currentCamera = workspace.CurrentCamera
	local cframe3 = currentCamera.CFrame
	local renderCFrame = currentCamera:GetRenderCFrame()
	local userCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
	local ray = Ray.new(renderCFrame.p, renderCFrame.lookVector)

	local v13 = cframe3 * VRService:GetUserCFrame(VRService.GuiInputUserCFrame)
	local ray2 = Ray.new(v13.p, v13.lookVector)

	for _, v14 in pairs(v8) do
		v14:Update(cframe3, renderCFrame, userCFrame, ray, ray2, 0)
	end
end

local function onCurrentCameraChanged()
	onHeadScaleChanged() -- inferred equivalent call

	if headScaleChangedConnection then
		headScaleChangedConnection:disconnect()
	end

	headScaleChangedConnection = workspace.CurrentCamera:GetPropertyChangedSignal("HeadScale"):Connect(onHeadScaleChanged)

	if cFrameChangedConnection then
		cFrameChangedConnection:disconnect()
	end

	cFrameChangedConnection = workspace.CurrentCamera:GetPropertyChangedSignal("CFrame"):Connect(onCameraCFrameChanged)

	if VRService.VREnabled and v12 then
		putFoldersIn(workspace.CurrentCamera) -- inferred equivalent call
	end
end

local currentCameraChangedConnection = nil
local flag = false
local function onVREnabledChanged()
	if VRService.VREnabled then
		while not v12 do
			wait()
		end

		if workspace.CurrentCamera then
			onCurrentCameraChanged()
		end

		currentCameraChangedConnection = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(onCurrentCameraChanged)

		putFoldersIn(workspace.CurrentCamera) -- inferred equivalent call

		if not flag then
			RunService:BindToRenderStep(v, Enum.RenderPriority.Last.Value, onRenderStep)
			flag = true
		end
	else
		if currentCameraChangedConnection then
			currentCameraChangedConnection:disconnect()
			currentCameraChangedConnection = nil
		end

		putFoldersIn(nil) -- inferred equivalent call

		if flag then
			RunService:UnbindFromRenderStep(v)
			flag = false
		end
	end
end
VRService:GetPropertyChangedSignal("VREnabled"):connect(onVREnabledChanged)
spawn(onVREnabledChanged)

coroutine.wrap(function()
	while true do
		if workspace.CurrentCamera then
			if
				workspace.CurrentCamera.CameraSubject ~= nil
				or workspace.CurrentCamera.CameraType == Enum.CameraType.Scriptable
			then
				break
			end

			workspace.CurrentCamera.Changed:Wait()
		else
			wait()
		end
	end

	v12 = true
end)()

return Panel3D
