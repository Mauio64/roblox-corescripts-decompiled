local VRService = game:GetService("VRService")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")
local VRUtil = require("@game/CorePackages/Workspace/Packages/_Workspace/VrCommon/VrCommon/VRUtil")
local create = require("@game/CorePackages/Workspace/Packages/_Workspace/VrCommon/AppCommonLib").Create

local HttpService = game:GetService("HttpService")
local v5 = "Panel3DRenderStep-" .. HttpService:GenerateGUID()

local vector2 = Vector2.new(0, 0)

local cframe = CFrame.new(0, -0.5, -5.5)
local cframe2 = CFrame.new(0, 0, -3)

local v6 = CFrame.new(0, 0, -0.1) * CFrame.Angles(0, 3.141592653589793, 0)

local v7 = nil
local v8 = nil
local v9 = 1e999
local v10 = nil
local v11 = vector2
local v12 = {}
local v13 = create("ImageLabel")({
	Image = "rbxasset://textures/Cursors/Gamepad/Pointer.png",
	ImageColor3 = Color3.new(0, 1, 0),
	BackgroundTransparency = 1,
	ZIndex = 1000000000
})

local v14 = create("Folder")({ Name = "VRCorePanelParts", Archivable = false })

local v15 = create("Folder")({ Name = "VRCoreEffectParts", Archivable = false })

pcall(function()
	GuiService.CoreGuiFolder = v14
	GuiService.CoreEffectFolder = v15
end)

local v16 = {
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
	["OnPanelClosed"] = create("BindableEvent")({ Name = "OnPanelClosed" }),
	GetHeadLookXZ = function(p2)
		local userCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
		local lookVector = userCFrame.lookVector
		local v17 = math.atan2(-lookVector.Z, lookVector.X) - 1.5707963267948966
		local cframe3 = CFrame.Angles(0, v17, 0)

		if p2 then
			cframe3 += userCFrame.p
		end

		return cframe3
	end,
	FindContainerOf = function(descendant)
		for k, v17 in pairs(v12) do
			if v17.gui and v17.gui:IsAncestorOf(descendant) then
				return v17
			end

			for k2, subpanel in pairs(v17.subpanels) do
				if subpanel.gui and subpanel.gui:IsAncestorOf(descendant) then
					return v17
				end
			end
		end

		return nil
	end,
	SetModalPanel = function(object)
		if v7 == object then
			return
		end

		if v7 then
			v7:OnModalChanged(false)
		end

		if object then
			object:OnModalChanged(true)
		end

		v8 = v7
		v7 = object
	end,
	RaycastOntoPanel = function(object, p2, p3, p4)
		local size = object.Size
		local z = size.Z
		local x = size.X
		local y = size.Y

		local renderCFrame = object:GetRenderCFrame()
		local lookVector = renderCFrame.lookVector
		local v17 = renderCFrame.p + lookVector * z * 0.5

		local rayPlaneIntersection = VRUtil.RayPlaneIntersection(p4, lookVector, v17)

		if not rayPlaneIntersection then
			return nil, nil, nil, false
		end

		local x2 = p2.AbsoluteSize.X
		local y2 = p2.AbsoluteSize.Y

		local v18 = renderCFrame:pointToObjectSpace(rayPlaneIntersection) * Vector3.new(-1, 1, 1) + Vector3.new(x / 2, -y / 2, 0)

		local vector2_2 = Vector2.new(v18.X / x * x2, v18.Y / y * -y2)

		local x3 = vector2_2.X
		local y3 = vector2_2.Y
		local x4 = p3.AbsolutePosition.X
		local y4 = p3.AbsolutePosition.Y
		local x5 = p3.AbsoluteSize.X
		local y5 = p3.AbsoluteSize.Y

		return
			rayPlaneIntersection,
			v18,
			vector2_2,
			p2.Enabled and x4 <= x3 and x3 <= x4 + x5 and y4 <= y3 and y3 <= y4 + y5 and true or false
	end
}

local class = {}
class.__index = class
function class.new(p2)
	local v17 = {
		name = p2,
		part = false,
		gui = false,
		width = 1,
		height = 1,
		isVisible = false,
		isEnabled = false,
		panelType = v16.Type.None,
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

	if v12[p2] then
		error("A panel by the name of " .. p2 .. " already exists.")
	end

	v12[p2] = v17

	return (setmetatable(v17, class))
end

function class:GetPart()
	if not self.part then
		self.part = create("Part")({
			Name = self.name,
			Parent = v14,
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
		self.gui = create("SurfaceGui")({
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

function class.FindHoveredGuiElement(p2, items)
	local x = p2.lookAtPixel.X
	local y = p2.lookAtPixel.Y

	for k, item in pairs(items) do
		local absolutePosition = item.AbsolutePosition
		local v17 = item.AbsolutePosition + item.AbsoluteSize

		if absolutePosition.X <= x and x <= v17.X and absolutePosition.Y <= y and y <= v17.Y then
			return item, k
		end
	end
end

function class:SetPartCFrame(p2)
	local part = self:GetPart()
	part.CFrame = p2 * v6
end

function class:SetEnabled(isEnabled)
	if self.isEnabled == isEnabled then
		return
	end

	self.isEnabled = isEnabled

	if isEnabled then
		local part = self:GetPart()
		part.Parent = v14
		local gui = self:GetGUI()
		gui.Enabled = true
	else
		local part_2 = self:GetPart()
		part_2.Parent = nil
		local gui_2 = self:GetGUI()
		gui_2.Enabled = false
	end

	for k, subpanel in pairs(self.subpanels) do
		subpanel:SetEnabled(subpanel:GetEnabled())
	end

	self:OnEnabled(isEnabled)
end

function class:StartLerp(p2)
	if self.panelType == v16.Type.UIManagerManaged then
		return
	end

	self.lerpInitialCF = self:GetPart().CFrame * CFrame.new(0, -1.5, 0)
	self.lerpTime = 1
	self.lerpInitialSize = Vector2.new(self.width, self.height)
	self.lerpScaleSize = p2 and p2 or Vector2.new(0, 0)
end

function class:EvaluatePositioning(p2, p3, p4, p5)
	if self.panelType == v16.Type.UIManagerManaged then
		return
	end

	if self.panelType == v16.Type.Fixed then
		self:SetPartCFrame(p2 * (self.localCF - self.localCF.p + self.localCF.p * workspace.CurrentCamera.HeadScale))
	elseif self.panelType == v16.Type.HorizontalFollow then
		local lookVector = p4.lookVector
		self:SetPartCFrame(p2 * (CFrame.new(p4.p, p4.p + lookVector * Vector3.new(1, 0, 1)) * self.angleFromForward * self.angleFromHorizon * CFrame.new(
			0,
			0,
			workspace.CurrentCamera.HeadScale * -self.distance
		)))
	elseif self.panelType == v16.Type.FixedToHead then
		self:SetPartCFrame(p3 * (self.localCF - self.localCF.p + self.localCF.p * workspace.CurrentCamera.HeadScale))
	elseif self.panelType == v16.Type.Standard then
		if self.needsPositionUpdate or self.alwaysUpdatePosition then
			self.needsPositionUpdate = false
			local headLookXZ = v16.GetHeadLookXZ(true)
			local v17 = cframe.Position * workspace.CurrentCamera.HeadScale
			self.originCF = headLookXZ * CFrame.new(v17)
		end

		self:SetPartCFrame(p2 * self.originCF * self.localCF)
	elseif self.panelType == v16.Type.NewStandard then
		if self.needsPositionUpdate or self.alwaysUpdatePosition then
			self.needsPositionUpdate = false
			local userCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
			local v17 = cframe2.Position * workspace.CurrentCamera.HeadScale
			self.originCF = userCFrame * CFrame.new(v17)
		end

		self:SetPartCFrame(p2 * self.originCF * self.localCF)
	elseif self.panelType == v16.Type.WristView then
		if VRService:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand) then
			if self.needsPositionUpdate or self.alwaysUpdatePosition then
				self.needsPositionUpdate = false
				local v17 = VRService:GetUserCFrame(Enum.UserCFrame.LeftHand).Position * workspace.CurrentCamera.HeadScale
				self.originCF = CFrame.new(v17)
			end

			local v17 = p2 * VRService:GetUserCFrame(Enum.UserCFrame.Head)

			local v18 = (p2 * self.originCF).Position

			if self.distance > 0 then
				local vector3 = Vector3.new(v18.x, v17.Position.y - 0.33, v18.z)

				local v19 = math.clamp(
					(vector3 - v17.Position).Magnitude,
					self.distance - 0.5,
					self.distance + 0.5
				)

				local v20 = (vector3 - v17.Position).Unit * v19
				v18 = v17.Position + v20
			end

			local vector3 = Vector3.new(v17.Position.x, v18.y, v17.Position.z)

			local cframe3 = CFrame.new(v18, vector3)

			local part = self:GetPart()
			part.CFrame = cframe3
		else
			self:SetPartCFrame(p2 * (self.localCF - self.localCF.p + self.localCF.p * workspace.CurrentCamera.HeadScale))
		end
	elseif self.panelType == v16.Type.PositionLocked then
		local userCFrameWorldSpace = VRUtil.GetUserCFrameWorldSpace(Enum.UserCFrame.Head)

		if not self.LastFollowCF then
			self.LastFollowCF = userCFrameWorldSpace
		end

		if (self.LastCameraPos - p2.Position).Magnitude > 0.1 then
			self.LastFollowCF = userCFrameWorldSpace
		end

		self.LastCameraPos = p2.Position

		if self.LastFollowCF.LookVector:Dot(userCFrameWorldSpace.LookVector) < 0.85 then
			self.FollowView = true
		elseif self.LastFollowCF.LookVector:Dot(userCFrameWorldSpace.LookVector) > 0.99 then
			self.FollowView = false
		end

		if self.FollowView then
			self.LastFollowCF = self.LastFollowCF:Lerp(userCFrameWorldSpace, 0.1)
		end

		local v17 = userCFrameWorldSpace.Position + self.LastFollowCF.LookVector * (self.distance * workspace.CurrentCamera.HeadScale + 0.1)
		local vector3 = Vector3.new(
			v17.X,
			userCFrameWorldSpace.Position.Y - 0.5 * workspace.CurrentCamera.HeadScale,
			v17.Z
		)

		local vector3_2 = Vector3.new(
			userCFrameWorldSpace.Position.x,
			vector3.y,
			userCFrameWorldSpace.Position.z
		)

		local cframe3 = CFrame.new(vector3, vector3_2)

		local part_2 = self:GetPart()
		part_2.CFrame = cframe3
	end

	if self.lerpInitialCF and self.lerpTime > 0 then
		local cframe3 = self:GetPart().CFrame

		self.lerpTime -= p5 * 4
		local v17 = math.clamp(1 - self.lerpTime, 0, 1)
		local lerped = self.lerpInitialCF:Lerp(cframe3, v17)

		local part_3 = self:GetPart()
		part_3.CFrame = lerped

		if self.lerpScaleSize.x > 0 or self.lerpScaleSize.y > 0 then
			local lerped2 = self.lerpInitialSize:Lerp(self.lerpScaleSize, v17)
			self:ResizeStuds(lerped2.x, lerped2.y, self.pixelsPerStud)
		end
	end
end

function class:SetLookedAt(p2)
	if self.isLookedAt or not p2 then
		if self.isLookedAt and not p2 then
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

function class:EvaluateGaze(p2, p3, p4, p5, p6)
	self.isClosest = false
	self.lookAtPixel = vector2
	self.lookAtDistance = 1e999
	local v17 = 0
	local v18 = nil

	for k, subpanel in pairs(self.subpanels) do
		if not (subpanel.part and subpanel.guiElement) then
			continue
		end

		local raycastOntoPanel, v19, v20, v21 = v16.RaycastOntoPanel(
			subpanel.part,
			subpanel.gui,
			subpanel.guiElement,
			p6
		)

		if not raycastOntoPanel then
			continue
		end

		subpanel.lookAtPixel = v20
		subpanel.cursorPos = v20

		if not (v21 and v17 < subpanel.depthOffset) then
			continue
		end

		v17 = subpanel.depthOffset
		v18 = subpanel
	end

	if v18 and v18.depthOffset > 0 then
		v11 = v18.cursorPos
		v10 = v18

		for k, subpanel in pairs(self.subpanels) do
			if subpanel ~= v18 then
				subpanel:SetLookedAt(false)
			end
		end

		v18:SetLookedAt(true)
	end

	if self.panelType == v16.Type.WristView then
		self.isWristHeldUp = false
		local userCFrame = VRService:GetUserCFrame(Enum.UserCFrame.LeftHand)
		local v19 = userCFrame.Position * workspace.CurrentCamera.HeadScale
		local v20 = p2 * CFrame.new(v19)

		if self.distance == 0 then
			local v21 = p2 * VRService:GetUserCFrame(Enum.UserCFrame.Head)
			local position = v20.Position
			local vector3 = Vector3.new(position.x, v21.Position.y - 0.33, position.z)

			local v22 = math.clamp((vector3 - v21.Position).Magnitude, 0.5, 1)
			local v23 = (vector3 - v21.Position).Unit * v22
			self.isWristHeldUp = (v21.Position + v23 - v20.Position).Magnitude < 0.25
		else
			local userCFrame2 = VRService:GetUserCFrame(Enum.UserCFrame.RightHand)
			local v21 = userCFrame.Position - userCFrame2.Position
			local dot = userCFrame2.LookVector:Dot(v21)
			local v22 = userCFrame2.Position + userCFrame2.LookVector * dot

			if (userCFrame.Position - v22).Magnitude < 0.5 then
				self.isWristHeldUp = true
			end
		end
	end

	local gui = self:GetGUI()

	local raycastOntoPanel, v19, v20, v21 = v16.RaycastOntoPanel(self:GetPart(), gui, gui, p6)

	if raycastOntoPanel then
		self.isOffscreen = false

		self.lookAtPixel = v20
		self.cursorPos = v20

		self:SetLookedAt(v21)

		self.lookAtDistance = (raycastOntoPanel - p3.p).magnitude

		if self.isLookedAt and self.lookAtDistance < v9 and self.showCursor then
			v9 = self.lookAtDistance
			v10 = self

			if not v18 then
				v11 = self.cursorPos
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
	if self.panelType == v16.Type.UIManagerManaged then
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

function class:Update(p2, p3, p4, p5, p6, p7)
	if (self.forceShowUntilLookedAt or self.forceShowUntilTick > tick()) and not self.part then
		self:GetPart()
		self:GetGUI()
	end

	if not self.part then
		return
	end

	local v17 = v7 == self
	local v18 = not v17 and self.linkedTo and self.linkedTo == v7 and true or v17

	if v7 and not v18 then
		self:SetEnabled(false)
		return
	end

	self:PreUpdate(p2, p3, p4, p5, p7)

	if self.isVisible then
		self:EvaluatePositioning(p2, p3, p4, p7)

		for k, subpanel in pairs(self.subpanels) do
			subpanel:Update()
		end

		self:EvaluateGaze(p2, p3, p4, p5, p6)

		self:EvaluateTransparency(p2, p3)
	elseif self.alwaysUpdatePosition then
		self:EvaluatePositioning(p2, p3, p4, p7)
	end
end

function class:PreUpdate(p3, p4, p5, p6, p7) end

function class:OnUpdate(p3) end

function class:OnMouseEnter(p3, p4) end

function class:OnMouseLeave(p3, p4) end

function class:OnEnabled(p3) end

function class:OnModalChanged(p3) end

function class:OnVisibilityChanged(p3) end

function class:CalculateTransparency()
	if not self.canFade then
		return 0
	end

	local x = self.gui.AbsoluteSize.X
	local y = self.gui.AbsoluteSize.Y
	local x2 = self.lookAtPixel.X
	local y2 = self.lookAtPixel.Y

	local v17 = x2 < 0 and -x2 or x2 - x
	local v18 = y2 < 0 and -y2 or y2 - y
	local v19 = x2 > 0 and x2 < x and 0 or v17

	local v20 = y2 > 0 and y2 < y and 0 or v18

	return (math.max(0, (math.min(1, (math.sqrt(v19 ^ 2 + v20 ^ 2) - 10) / 20))))
end

function class:ResizeStuds(width, height, value)
	if self.panelType == v16.Type.UIManagerManaged then
		return
	end

	local v17 = value or 64

	self.width = width
	self.height = height

	self.pixelScale = v17 / 64

	local part = self:GetPart()
	part.Size = Vector3.new(
		self.width * workspace.CurrentCamera.HeadScale,
		self.height * workspace.CurrentCamera.HeadScale,
		0.2
	)

	local gui = self:GetGUI()
	gui.CanvasSize = Vector2.new(v17 * self.width, v17 * self.height)

	for k, subpanel in pairs(self.subpanels) do
		if subpanel.part then
			subpanel.part.Size = part.Size
		end

		if subpanel.gui then
			subpanel.gui.CanvasSize = gui.CanvasSize
		end
	end
end

function class:ResizePixels(p2, p3, value)
	local v17 = value or 64

	self:ResizeStuds(p2 / v17, p3 / v17, v17)
end

function class:OnHeadScaleChanged()
	local v17 = self.pixelScale * 64
	self:ResizeStuds(self.width, self.height, v17)
end

function class:SetType(panelType, options)
	self.panelType = panelType

	self.localCF = CFrame.new()

	self.angleFromHorizon = false
	self.angleFromForward = false
	self.distance = 0

	local v17 = options or {}

	if panelType == v16.Type.None then
		return
	end

	if panelType == v16.Type.Standard then
		self.localCF = v17.CFrame or CFrame.new()
	elseif panelType == v16.Type.Fixed then
		self.localCF = v17.CFrame or CFrame.new()
	elseif panelType == v16.Type.HorizontalFollow then
		self.angleFromHorizon = CFrame.Angles(v17.angleFromHorizon or 0, 0, 0)
		self.angleFromForward = CFrame.Angles(0, v17.angleFromForward or 0, 0)
		self.distance = v17.distance or 5
	elseif panelType == v16.Type.FixedToHead then
		self.localCF = v17.CFrame or CFrame.new()
	elseif panelType == v16.Type.NewStandard then
		self.localCF = v17.CFrame or CFrame.new()
	elseif panelType == v16.Type.WristView then
		self.localCF = v17.CFrame or CFrame.new()
		self.distance = 0
	elseif panelType == v16.Type.PositionLocked then
		self.localCF = v17.CFrame or CFrame.new()
	elseif panelType == v16.Type.UIManagerManaged then
		self.part = v17.uiManagerPanelPart
	else
		error("Invalid Panel type")
	end
end

function class.IsUIManagerManagedType(p2): boolean
	return p2.panelType == v16.Type.UIManagerManaged
end

function class.IsPositionLockedType(p2): boolean
	return p2.panelType == v16.Type.PositionLocked
end

function class:SetVisible(isVisible, p2)
	if isVisible ~= self.isVisible then
		self:OnVisibilityChanged(isVisible)

		if isVisible then
			self.needsPositionUpdate = true

			if self.panelType == v16.Type.WristView then
				self.originCF = VRService:GetUserCFrame(Enum.UserCFrame.Head) * cframe2
			end
		else
			v16.OnPanelClosed:Fire(self.name)
		end
	end

	self.isVisible = isVisible
	self:SetEnabled(isVisible)

	if isVisible and p2 then
		v16.SetModalPanel(self)
	end

	if not isVisible and v7 == self then
		if p2 then
			v16.SetModalPanel(v8)
		else
			v16.SetModalPanel(nil)

			if v8 == self then
				v8 = nil
			end
		end
	end

	if not isVisible and self.forceShowUntilLookedAt then
		self.forceShowUntilLookedAt = false
	end
end

function class.IsVisible(p2)
	return p2.isVisible
end

function class:LinkTo(linkedTo)
	if type(linkedTo) == "string" then
		self.linkedTo = v16.Get(linkedTo)
	else
		self.linkedTo = linkedTo
	end
end

function class:ForceShowUntilLookedAt(p2)
	self:GetPart()
	self:GetGUI()

	self:SetVisible(true, p2)
	self:RequestPositionUpdate()
	self.forceShowUntilLookedAt = true
end

function class:ForceShowForSeconds(p2)
	self:GetPart()
	self:GetGUI()

	self:SetVisible(true)

	if self.forceShowUntilTick < tick() then
		self:RequestPositionUpdate()
	end

	self.forceShowUntilTick = tick() + p2
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

function class.GetGuiPositionInPanelSpace(p2, p3)
	local vector2_2 = Vector2.new(p2.part.Size.X, p2.part.Size.Y)
	local absoluteSize = p2.gui.AbsoluteSize
	local v17 = (p3 - absoluteSize / 2) / absoluteSize * vector2_2

	return (Vector3.new(v17.X, v17.Y, 0.1))
end

function class.GetCFrameInCameraSpace(data)
	if data.panelType == v16.Type.Standard or data.panelType == v16.Type.NewStandard then
		return data.originCF * data.localCF
	end

	return data.localCF or CFrame.new()
end

local class2 = {}
class2.__index = class2
function class2.new(p2, instance)
	local v17 = {
		["parentPanel"] = p2,
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

	setmetatable(v17, class2)

	v17:GetGUI()
	v17:UpdateSurrogate()
	v17:WatchParent(v17.lastParent)

	instance.Parent = v17.guiSurrogate
	local function ancestryCallback(p3, p4)
		local gui = v17:GetGUI()
		gui.Enabled = v17.parentPanel:GetGUI():IsAncestorOf(v17.lastParent)

		if v17:GetGUI().Enabled then
			local part = v17:GetPart()
			part.Parent = workspace.CurrentCamera
		else
			local part_2 = v17:GetPart()
			part_2.Parent = nil
		end

		if p4 == instance then
			v17.ancestryConn:disconnect()

			v17.lastParent = instance.Parent
			instance.Parent = v17.guiSurrogate
			v17:WatchParent(v17.lastParent)

			v17.ancestryConn = instance.AncestryChanged:connect(ancestryCallback)
		end
	end
	v17.ancestryConn = instance.AncestryChanged:connect(ancestryCallback)

	return v17
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

function class2:OnMouseEnter(p3, p4) end
function class2:OnMouseLeave(p3, p4) end

function class2:SetLookedAt(lookedAt)
	if lookedAt and not self.lookedAt then
		self:OnMouseEnter(self.lookAtPixel.X, self.lookAtPixel.Y)
	elseif not lookedAt and self.lookedAt then
		self:OnMouseLeave(self.lookAtPixel.X, self.lookAtPixel.Y)
	end

	self.lookedAt = lookedAt
end

function class2:WatchParent(p2)
	if self.changedConn then
		self.changedConn:disconnect()
	end

	self.changedConn = p2.Changed:connect(function(p3)
		if p3 == "AbsolutePosition" or p3 == "AbsoluteSize" or p3 == "Parent" then
			self:UpdateSurrogate()
		end
	end)
end

function class2:UpdateSurrogate()
	local lastParent = self.lastParent
	self.guiSurrogate.Position = UDim2.new(
		0,
		lastParent.AbsolutePosition.X,
		0,
		lastParent.AbsolutePosition.Y
	)
	self.guiSurrogate.Size = UDim2.new(0, lastParent.AbsoluteSize.X, 0, lastParent.AbsoluteSize.Y)
end

function class2:GetPart()
	if self.part then
		return self.part
	end

	self.part = self.parentPanel:GetPart():Clone()
	self.part.Parent = v14
	return self.part
end

function class2:GetGUI()
	if self.gui then
		return self.gui
	end

	self.gui = create("SurfaceGui")({
		Parent = CoreGui,
		Adornee = self:GetPart(),
		Active = true,
		ToolPunchThroughDistance = 1000,
		CanvasSize = self.parentPanel:GetGUI().CanvasSize,
		Enabled = self.parentPanel.isEnabled,
		AlwaysOnTop = true
	})

	self.guiSurrogate = create("Frame")({
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
		part.Parent = v14
		local gui = self:GetGUI()
		gui.Enabled = true
	else
		local part_2 = self:GetPart()
		part_2.Parent = nil
		local gui_2 = self:GetGUI()
		gui_2.Enabled = false
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

function class:AddSubpanel(p3)
	local v17 = class2.new(self, p3)
	self.subpanels[p3] = v17
	return v17
end

function class:RemoveSubpanel(p3)
	local subpanel = self.subpanels[p3]

	if subpanel then
		subpanel:Cleanup()
	end

	self.subpanels[p3] = nil
end

function class:SetSubpanelDepth(p2, p3)
	local subpanel = self.subpanels[p2]

	if p3 == 0 then
		if subpanel then
			self:RemoveSubpanel(p2)
		end

		return nil
	else
		local v17 = subpanel or self:AddSubpanel(p2)

		v17:SetDepthOffset(p3)

		return v17
	end
end

function v16.Get(p2)
	local v17 = v12[p2]

	if not v12[p2] then
		v12[p2] = class.new(p2)
		v17 = v12[p2]
	end

	return v17
end

local v17 = tick()
local function onRenderStep()
	if not VRService.VREnabled then
		return
	end

	local now = tick()
	local v18 = now - v17
	v17 = now

	v10 = nil
	v9 = 1e999

	local currentCamera = workspace.CurrentCamera
	local cframe3 = currentCamera.CFrame
	local renderCFrame = currentCamera:GetRenderCFrame()
	local userCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
	local ray = Ray.new(renderCFrame.p, renderCFrame.lookVector)

	local v19 = cframe3 * VRService:GetUserCFrame(VRService.GuiInputUserCFrame)
	local ray2 = Ray.new(v19.p, v19.lookVector)

	for k, v20 in pairs(v12) do
		v20:Update(cframe3, renderCFrame, userCFrame, ray, ray2, v18)
	end

	local set = {}

	for k, v20 in pairs(v12) do
		if set[v20] or not v20.linkedTo or not v20.isVisible or not v20.linkedTo.isVisible then
			continue
		end

		set[v20] = true
		set[v20.linkedTo] = true

		local v21 = math.min(v20.transparency, v20.linkedTo.transparency)
		v20.transparency = v21
		v20.linkedTo.transparency = v21
	end

	for k, v20 in pairs(v12) do
		if v20.part and v20.gui then
			local v21 = v7 == v20
			local v22 = not v21 and v20.linkedTo and v20.linkedTo == v7 and true or v21

			local v23 = v20.isVisible

			if not v22 and v7 then
				v23 = false
			end

			if v20.transparency >= 1 then
				v23 = false
			end

			local v24 = v20.forceShowUntilLookedAt and true or v23

			v20:SetEnabled(not v20.canFade and v20.isVisible and true or v24)
		end

		v20:OnUpdate(v18)
	end

	if not v10 then
		v13.Parent = nil

		return
	end

	local x = v11.X
	local y = v11.Y
	local pixelScale = v10:GetPixelScale()
	v13.Size = UDim2.new(0, 3 * pixelScale, 0, 3 * pixelScale)
	v13.Position = UDim2.new(0, x - v13.AbsoluteSize.x * 0.5, 0, y - v13.AbsoluteSize.y * 0.5)
end

local v18 = true
local function putFoldersIn(parent)
	v14.Parent = parent
	v15.Parent = parent
end

local headScaleChangedConnection = nil
local function onHeadScaleChanged()
	for k, v19 in pairs(v12) do
		v19:OnHeadScaleChanged()
	end
end

local cFrameChangedConnection = nil
local function onCameraCFrameChanged()
	local currentCamera = workspace.CurrentCamera
	local cframe3 = currentCamera.CFrame
	local renderCFrame = currentCamera:GetRenderCFrame()
	local userCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
	local ray = Ray.new(renderCFrame.p, renderCFrame.lookVector)

	local v19 = cframe3 * VRService:GetUserCFrame(VRService.GuiInputUserCFrame)
	local ray2 = Ray.new(v19.p, v19.lookVector)

	for k, v20 in pairs(v12) do
		v20:Update(cframe3, renderCFrame, userCFrame, ray, ray2, 0)
	end
end

local function onCurrentCameraChanged()
	for k, v19 in pairs(v12) do
		v19:OnHeadScaleChanged()
	end

	if headScaleChangedConnection then
		headScaleChangedConnection:disconnect()
	end

	headScaleChangedConnection = workspace.CurrentCamera:GetPropertyChangedSignal("HeadScale"):Connect(onHeadScaleChanged)

	if cFrameChangedConnection then
		cFrameChangedConnection:disconnect()
	end

	cFrameChangedConnection = workspace.CurrentCamera:GetPropertyChangedSignal("CFrame"):Connect(onCameraCFrameChanged)

	if VRService.VREnabled and v18 then
		local currentCamera = workspace.CurrentCamera
		v14.Parent = currentCamera
		v15.Parent = currentCamera
	end
end

local currentCameraChangedConnection = nil
local flag = false
local function onVREnabledChanged()
	if VRService.VREnabled then
		while not v18 do
			wait()
		end

		if workspace.CurrentCamera then
			onCurrentCameraChanged()
		end

		currentCameraChangedConnection = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(onCurrentCameraChanged)

		local currentCamera = workspace.CurrentCamera
		v14.Parent = currentCamera
		v15.Parent = currentCamera

		if not flag then
			RunService:BindToRenderStep(v5, Enum.RenderPriority.Last.Value, onRenderStep)
			flag = true
		end
	else
		if currentCameraChangedConnection then
			currentCameraChangedConnection:disconnect()
			currentCameraChangedConnection = nil
		end

		v14.Parent = nil
		v15.Parent = nil

		if flag then
			RunService:UnbindFromRenderStep(v5)
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

	v18 = true
end)()

return v16
