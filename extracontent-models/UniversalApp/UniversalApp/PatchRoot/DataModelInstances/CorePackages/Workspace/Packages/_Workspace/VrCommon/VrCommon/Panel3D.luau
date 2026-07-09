local VrCommon = script:FindFirstAncestor("VrCommon")
local VrCommonParent = VrCommon.Parent
local VRService = game:GetService("VRService")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")
local VRUtil = require(VrCommon.VRUtil)
local Create = require(VrCommonParent.AppCommonLib).Create
local v9 = "Panel3DRenderStep-" .. game:GetService("HttpService"):GenerateGUID()
local vector2 = Vector2.new(0, 0)
local cFrame = CFrame.new(0, -0.5, -5.5)
local cFrame2 = CFrame.new(0, 0, -3)
local v13 = CFrame.new(0, 0, -0.1) * CFrame.Angles(0, 3.141592653589793, 0)
local u14 = nil
local u15 = nil
local n1 = 1e999
local u17 = nil
local u18 = vector2
local t1 = {}
local v20 = Create("ImageLabel")({
	Image = "rbxasset://textures/Cursors/Gamepad/Pointer.png",
	BackgroundTransparency = 1,
	ZIndex = 1000000000,
	ImageColor3 = Color3.new(0, 1, 0)
})
local v21 = Create("Folder")({
	Name = "VRCorePanelParts",
	Archivable = false
})
local v22 = Create("Folder")({
	Name = "VRCoreEffectParts",
	Archivable = false
})

pcall(function() -- line: 57
	-- upvalues: GuiService (copy), v21 (copy), v22 (copy)
	GuiService.CoreGuiFolder = v21
	GuiService.CoreEffectFolder = v22
end)

local t2 = {
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
	OnPanelClosed = Create("BindableEvent")({
		Name = "OnPanelClosed"
	}),
	GetHeadLookXZ = function(p1) -- line: 81
		-- upvalues: VRService (copy)
		local UserCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
		local lookVector = UserCFrame.lookVector
		local v41 = math.atan2(-lookVector.Z, lookVector.X) - 1.5707963267948966
		local cFrame3 = CFrame.Angles(0, v41, 0)

		if p1 then
			cFrame3 += UserCFrame.p
		end

		return cFrame3
	end,
	FindContainerOf = function(p2) -- line: 93
		-- upvalues: t1 (copy)
		for _, v in pairs(t1) do
			if v.gui and v.gui:IsAncestorOf(p2) then
				return v
			end

			for _, v2 in pairs(v.subpanels) do
				if v2.gui and v2.gui:IsAncestorOf(p2) then
					return v
				end
			end
		end

		return nil
	end,
	SetModalPanel = function(p3) -- line: 107
		-- upvalues: u14 (ref), u15 (ref)
		if p3 == u14 then
			return
		end

		if u14 then
			u14:OnModalChanged(false)
		end

		if p3 then
			p3:OnModalChanged(true)
		end

		u15 = u14
		u14 = p3
	end,
	RaycastOntoPanel = function(p4, p5, p6, p7) -- line: 121
		-- upvalues: VRUtil (copy)
		local p4Size = p4.Size
		local p4SizeZ = p4Size.Z
		local p4SizeX = p4Size.X
		local p4SizeY = p4Size.Y
		local RenderCFrame = p4:GetRenderCFrame()
		local lookVector = RenderCFrame.lookVector
		local v59 = RenderCFrame.p + lookVector * p4SizeZ * 0.5
		local v60 = VRUtil.RayPlaneIntersection(p7, lookVector, v59)

		if v60 then
			local AbsoluteSizeX = p5.AbsoluteSize.X
			local AbsoluteSizeY = p5.AbsoluteSize.Y
			local v63 = RenderCFrame:pointToObjectSpace(v60) * Vector3.new(-1, 1, 1) + Vector3.new(p4SizeX / 2, -p4SizeY / 2, 0)
			local vector2_2 = Vector2.new(v63.X / p4SizeX * AbsoluteSizeX, v63.Y / p4SizeY * -AbsoluteSizeY)
			local vector2_2X = vector2_2.X
			local vector2_2Y = vector2_2.Y
			local AbsolutePositionX = p6.AbsolutePosition.X
			local AbsolutePositionY = p6.AbsolutePosition.Y
			local AbsoluteSizeX2 = p6.AbsoluteSize.X
			local AbsoluteSizeY2 = p6.AbsoluteSize.Y
			local v71 = false

			if p5.Enabled and AbsolutePositionX <= vector2_2X and vector2_2X <= AbsolutePositionX + AbsoluteSizeX2 and AbsolutePositionY <= vector2_2Y and vector2_2Y <= AbsolutePositionY + AbsoluteSizeY2 then
				v71 = true
			end

			return v60, v63, vector2_2, v71
		end

		return nil, nil, nil, false
	end
}
local t3 = {}

t3.__index = t3

function t3.new(p8) -- line: 169
	-- upvalues: t2 (copy), t1 (copy), t3 (copy)
	local t4 = {
		name = p8,
		part = false,
		gui = false,
		width = 1,
		height = 1,
		isVisible = false,
		isEnabled = false,
		panelType = t2.Type.None,
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

	if t1[p8] then
		error("A panel by the name of " .. p8 .. " already exists.")
	end

	t1[p8] = t4

	return (setmetatable(t4, t3))
end
function t3.GetPart(p9) -- line: 232
	-- upvalues: Create (copy), v21 (copy)
	if not p9.part then
		p9.part = Create("Part")({
			Transparency = 1,
			CanCollide = false,
			CanTouch = false,
			Anchored = true,
			Size = Vector3.new(1, 1, 0.20000000298023224),
			Name = p9.name,
			Parent = v21
		})
	end

	return p9.part
end
function t3.GetGUI(p10) -- line: 250
	-- upvalues: Create (copy), CoreGui (copy)
	if not p10.gui then
		local Part = p10:GetPart()

		p10.gui = Create("SurfaceGui")({
			Archivable = false,
			Active = true,
			ToolPunchThroughDistance = 1000,
			AlwaysOnTop = true,
			Parent = CoreGui,
			Name = p10.name,
			Adornee = Part,
			CanvasSize = p10.CanvasSize or Vector2.new(1000, 1000),
			Enabled = p10.isEnabled
		})
	end

	return p10.gui
end
function t3.FindHoveredGuiElement(p11, p12) -- line: 268
	local lookAtPixelX = p11.lookAtPixel.X
	local lookAtPixelY = p11.lookAtPixel.Y

	for k, v in pairs(p12) do
		local AbsolutePosition = v.AbsolutePosition
		local v84 = v.AbsolutePosition + v.AbsoluteSize

		if lookAtPixelX >= AbsolutePosition.X and lookAtPixelX <= v84.X and lookAtPixelY >= AbsolutePosition.Y and lookAtPixelY <= v84.Y then
			return v, k
		end
	end
end
function t3.SetPartCFrame(p13, p14) -- line: 282
	-- upvalues: v13 (copy)
	p13:GetPart().CFrame = p14 * v13
end
function t3.SetEnabled(p15, p16) -- line: 286
	-- upvalues: v21 (copy)
	if p16 == p15.isEnabled then
		return
	end

	p15.isEnabled = p16

	if p16 then
		p15:GetPart().Parent = v21
		p15:GetGUI().Enabled = true

		for _, v in pairs(p15.subpanels) do
			v:SetEnabled(v:GetEnabled())
		end
	else
		p15:GetPart().Parent = nil
		p15:GetGUI().Enabled = false

		for _, v in pairs(p15.subpanels) do
			v:SetEnabled(v:GetEnabled())
		end
	end

	p15:OnEnabled(p16)
end
function t3.StartLerp(p17, p18) -- line: 309
	-- upvalues: t2 (copy)
	if p17.panelType == t2.Type.UIManagerManaged then
		return
	end

	p17.lerpInitialCF = p17:GetPart().CFrame * CFrame.new(0, -1.5, 0)
	p17.lerpTime = 1
	p17.lerpInitialSize = Vector2.new(p17.width, p17.height)
	p17.lerpScaleSize = p18 and p18 or Vector2.new(0, 0)
end
function t3.EvaluatePositioning(p19, p20, p21, p22, p23) -- line: 320
	-- upvalues: t2 (copy), cFrame (copy), VRService (copy), cFrame2 (copy), VRUtil (copy)
	if p19.panelType == t2.Type.UIManagerManaged then
		return
	end

	if p19.panelType == t2.Type.Fixed then
		p19:SetPartCFrame(p20 * (p19.localCF - p19.localCF.p + p19.localCF.p * workspace.CurrentCamera.HeadScale))
	elseif p19.panelType == t2.Type.HorizontalFollow then
		local lookVector = p22.lookVector

		p19:SetPartCFrame(p20 * (CFrame.new(p22.p, p22.p + lookVector * Vector3.new(1, 0, 1)) * p19.angleFromForward * p19.angleFromHorizon * CFrame.new(0, 0, workspace.CurrentCamera.HeadScale * -p19.distance)))
	elseif p19.panelType == t2.Type.FixedToHead then
		p19:SetPartCFrame(p21 * (p19.localCF - p19.localCF.p + p19.localCF.p * workspace.CurrentCamera.HeadScale))
	elseif p19.panelType == t2.Type.Standard then
		if p19.needsPositionUpdate or p19.alwaysUpdatePosition then
			p19.needsPositionUpdate = false

			local v101 = t2.GetHeadLookXZ(true)
			local v102 = cFrame.Position * workspace.CurrentCamera.HeadScale

			p19.originCF = v101 * CFrame.new(v102)
		end

		p19:SetPartCFrame(p20 * p19.originCF * p19.localCF)
	elseif p19.panelType == t2.Type.NewStandard then
		if p19.needsPositionUpdate or p19.alwaysUpdatePosition then
			p19.needsPositionUpdate = false

			local UserCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
			local v104 = cFrame2.Position * workspace.CurrentCamera.HeadScale

			p19.originCF = UserCFrame * CFrame.new(v104)
		end

		p19:SetPartCFrame(p20 * p19.originCF * p19.localCF)
	elseif p19.panelType == t2.Type.WristView then
		if VRService:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand) then
			if p19.needsPositionUpdate or p19.alwaysUpdatePosition then
				p19.needsPositionUpdate = false

				local v105 = VRService:GetUserCFrame(Enum.UserCFrame.LeftHand).Position * workspace.CurrentCamera.HeadScale

				p19.originCF = CFrame.new(v105)
			end

			local v106 = p20 * VRService:GetUserCFrame(Enum.UserCFrame.Head)
			local Position = (p20 * p19.originCF).Position

			if p19.distance > 0 then
				local vector3 = Vector3.new(Position.x, v106.Position.y - 0.33, Position.z)
				local v109 = math.clamp((vector3 - v106.Position).Magnitude, p19.distance - 0.5, p19.distance + 0.5)
				local v110 = (vector3 - v106.Position).Unit * v109

				Position = v106.Position + v110
			end

			local vector3 = Vector3.new(v106.Position.x, Position.y, v106.Position.z)
			local cFrame4 = CFrame.new(Position, vector3)

			p19:GetPart().CFrame = cFrame4
		else
			p19:SetPartCFrame(p20 * (p19.localCF - p19.localCF.p + p19.localCF.p * workspace.CurrentCamera.HeadScale))
		end
	elseif p19.panelType == t2.Type.PositionLocked then
		local v113 = VRUtil.GetUserCFrameWorldSpace(Enum.UserCFrame.Head)

		if not p19.LastFollowCF then
			p19.LastFollowCF = v113
		end

		if (p19.LastCameraPos - p20.Position).Magnitude > 0.1 then
			p19.LastFollowCF = v113
		end

		p19.LastCameraPos = p20.Position

		if p19.LastFollowCF.LookVector:Dot(v113.LookVector) < 0.85 then
			p19.FollowView = true
		elseif p19.LastFollowCF.LookVector:Dot(v113.LookVector) > 0.99 then
			p19.FollowView = false
		end

		if p19.FollowView then
			p19.LastFollowCF = p19.LastFollowCF:Lerp(v113, 0.1)
		end

		local v114 = v113.Position + p19.LastFollowCF.LookVector * (p19.distance * workspace.CurrentCamera.HeadScale + 0.1)
		local vector3 = Vector3.new(v114.X, v113.Position.Y - 0.5 * workspace.CurrentCamera.HeadScale, v114.Z)
		local vector3_2 = Vector3.new(v113.Position.x, vector3.y, v113.Position.z)
		local cFrame5 = CFrame.new(vector3, vector3_2)

		p19:GetPart().CFrame = cFrame5
	end

	if p19.lerpInitialCF and p19.lerpTime > 0 then
		local CFrame2 = p19:GetPart().CFrame

		p19.lerpTime = p19.lerpTime - p23 * 4

		local v119 = math.clamp(1 - p19.lerpTime, 0, 1)
		local v120 = p19.lerpInitialCF:Lerp(CFrame2, v119)

		p19:GetPart().CFrame = v120

		if p19.lerpScaleSize.x > 0 or p19.lerpScaleSize.y > 0 then
			local v121 = p19.lerpInitialSize:Lerp(p19.lerpScaleSize, v119)

			p19:ResizeStuds(v121.x, v121.y, p19.pixelsPerStud)
		end
	end
end
function t3.SetLookedAt(p24, p25) -- line: 462
	if not p24.isLookedAt and p25 then
		p24.isLookedAt = true
		p24:OnMouseEnter(p24.lookAtPixel.X, p24.lookAtPixel.Y)

		if p24.forceShowUntilLookedAt then
			p24.forceShowUntilLookedAt = false

			return
		end
	elseif p24.isLookedAt and not p25 then
		p24.isLookedAt = false
		p24:OnMouseLeave(p24.lookAtPixel.X, p24.lookAtPixel.Y)
	end
end
function t3.EvaluateGaze(p26, p27, p28, _, _, p31) -- line: 475
	-- upvalues: vector2 (copy), t2 (copy), u18 (ref), u17 (ref), VRService (copy), n1 (ref)
	p26.isClosest = false
	p26.lookAtPixel = vector2
	p26.lookAtDistance = 1e999

	local v130 = nil
	local n2 = 0

	for _, v in pairs(p26.subpanels) do
		if v.part and v.guiElement then
			local v134, _, v136, v137 = t2.RaycastOntoPanel(v.part, v.gui, v.guiElement, p31)

			if v134 then
				v.lookAtPixel = v136
				v.cursorPos = v136

				if v137 and n2 < v.depthOffset then
					v130 = v
					n2 = v.depthOffset
				end
			end
		end
	end

	if v130 and v130.depthOffset > 0 then
		u18 = v130.cursorPos
		u17 = v130

		for _, v in pairs(p26.subpanels) do
			if v ~= v130 then
				v:SetLookedAt(false)
			end
		end

		v130:SetLookedAt(true)
	end

	if p26.panelType == t2.Type.WristView then
		p26.isWristHeldUp = false

		local UserCFrame = VRService:GetUserCFrame(Enum.UserCFrame.LeftHand)
		local v141 = UserCFrame.Position * workspace.CurrentCamera.HeadScale
		local v142 = p27 * CFrame.new(v141)

		if p26.distance == 0 then
			local v143 = p27 * VRService:GetUserCFrame(Enum.UserCFrame.Head)
			local Position = v142.Position
			local vector3 = Vector3.new(Position.x, v143.Position.y - 0.33, Position.z)
			local v146 = math.clamp((vector3 - v143.Position).Magnitude, 0.5, 1)
			local v147 = (vector3 - v143.Position).Unit * v146

			p26.isWristHeldUp = (v143.Position + v147 - v142.Position).Magnitude < 0.25
		else
			local UserCFrame2 = VRService:GetUserCFrame(Enum.UserCFrame.RightHand)
			local v149 = UserCFrame.Position - UserCFrame2.Position
			local v150 = UserCFrame2.LookVector:Dot(v149)
			local v151 = UserCFrame2.Position + UserCFrame2.LookVector * v150

			if (UserCFrame.Position - v151).Magnitude < 0.5 then
				p26.isWristHeldUp = true
			end
		end
	end

	local GUI = p26:GetGUI()
	local v153, _, v155, v156 = t2.RaycastOntoPanel(p26:GetPart(), GUI, GUI, p31)

	if v153 then
		p26.isOffscreen = false
		p26.lookAtPixel = v155
		p26.cursorPos = v155
		p26:SetLookedAt(v156)
		p26.lookAtDistance = (v153 - p28.p).magnitude

		if p26.isLookedAt and p26.lookAtDistance < n1 and p26.showCursor then
			n1 = p26.lookAtDistance
			u17 = p26

			if not v130 then
				u18 = p26.cursorPos

				return
			end
		end
	else
		p26.isOffscreen = true

		if p26.lookedAt then
			p26.lookedAt = false
			p26:OnMouseLeave(p26.lookAtPixel.X, p26.lookAtPixel.Y)
		end
	end
end
function t3.EvaluateTransparency(p32) -- line: 581
	-- upvalues: t2 (copy)
	if p32.panelType == t2.Type.UIManagerManaged then
		p32.transparency = 1

		return
	end

	if p32.forceShowUntilLookedAt or not p32.canFade or p32.forceShowUntilTick > tick() then
		p32.transparency = 0

		return
	end

	if p32.isLookedAt then
		p32.transparency = 0

		return
	end

	if p32.isOffscreen then
		p32.transparency = 1

		return
	end

	p32.transparency = p32:CalculateTransparency()
end
function t3.Update(p33, p34, p35, p36, p37, p38, p39) -- line: 607
	-- upvalues: u14 (ref)
	if (p33.forceShowUntilLookedAt or p33.forceShowUntilTick > tick()) and not p33.part then
		p33:GetPart()
		p33:GetGUI()
	end

	if not p33.part then
		return
	end

	local v165 = p33 == u14 or (not p33.linkedTo or p33.linkedTo == u14)

	if u14 and not v165 then
		p33:SetEnabled(false)

		return
	end

	p33:PreUpdate(p34, p35, p36, p37, p39)

	if p33.isVisible then
		p33:EvaluatePositioning(p34, p35, p36, p39)

		for _, v in pairs(p33.subpanels) do
			v:Update()
		end

		p33:EvaluateGaze(p34, p35, p36, p37, p38)
		p33:EvaluateTransparency(p34, p35)

		return
	end

	if p33.alwaysUpdatePosition then
		p33:EvaluatePositioning(p34, p35, p36, p39)
	end
end
function t3.PreUpdate(_, _, _, _, _, _) -- line: 644
end
function t3.OnUpdate(_, _) -- line: 647
end
function t3.OnMouseEnter(_, _, _) -- line: 650
end
function t3.OnMouseLeave(_, _, _) -- line: 653
end
function t3.OnEnabled(_, _) -- line: 656
end
function t3.OnModalChanged(_, _) -- line: 659
end
function t3.OnVisibilityChanged(_, _) -- line: 662
end
function t3.CalculateTransparency(p60) -- line: 665
	if not p60.canFade then
		return 0
	end

	local AbsoluteSizeX = p60.gui.AbsoluteSize.X
	local AbsoluteSizeY = p60.gui.AbsoluteSize.Y
	local lookAtPixelX = p60.lookAtPixel.X
	local lookAtPixelY = p60.lookAtPixel.Y
	local v193 = lookAtPixelX < 0 and -lookAtPixelX or lookAtPixelX - AbsoluteSizeX
	local v194 = lookAtPixelY < 0 and -lookAtPixelY or lookAtPixelY - AbsoluteSizeY

	if lookAtPixelX > 0 and lookAtPixelX < AbsoluteSizeX then
		v193 = 0
	end

	if lookAtPixelY > 0 and lookAtPixelY < AbsoluteSizeY then
		v194 = 0
	end

	return (math.max(0, (math.min(1, (math.sqrt(v193 ^ 2 + v194 ^ 2) - 10) / 20))))
end
function t3.ResizeStuds(p61, p62, p63, p64) -- line: 695
	-- upvalues: t2 (copy)
	if p61.panelType == t2.Type.UIManagerManaged then
		return
	end

	local v199 = p64 or 64

	p61.width = p62
	p61.height = p63
	p61.pixelScale = v199 / 64

	local Part = p61:GetPart()

	Part.Size = Vector3.new(p61.width * workspace.CurrentCamera.HeadScale, p61.height * workspace.CurrentCamera.HeadScale, 0.2)

	local GUI = p61:GetGUI()

	GUI.CanvasSize = Vector2.new(v199 * p61.width, v199 * p61.height)

	for _, v in pairs(p61.subpanels) do
		if v.part then
			v.part.Size = Part.Size
		end

		if v.gui then
			v.gui.CanvasSize = GUI.CanvasSize
		end
	end
end
function t3.ResizePixels(p65, p66, p67, p68) -- line: 726
	local v208 = p68 or 64

	p65:ResizeStuds(p66 / v208, p67 / v208, v208)
end
function t3.OnHeadScaleChanged(p69) -- line: 734
	local v210 = p69.pixelScale * 64

	p69:ResizeStuds(p69.width, p69.height, v210)
end
function t3.SetType(p70, p71, p72) -- line: 739
	-- upvalues: t2 (copy)
	p70.panelType = p71
	p70.localCF = CFrame.new()
	p70.angleFromHorizon = false
	p70.angleFromForward = false
	p70.distance = 0

	if not p72 then
		p72 = {}
	end

	if p71 == t2.Type.None then
		return
	end

	if p71 == t2.Type.Standard then
		p70.localCF = p72.CFrame or CFrame.new()

		return
	end

	if p71 == t2.Type.Fixed then
		p70.localCF = p72.CFrame or CFrame.new()

		return
	end

	if p71 == t2.Type.HorizontalFollow then
		p70.angleFromHorizon = CFrame.Angles(p72.angleFromHorizon or 0, 0, 0)
		p70.angleFromForward = CFrame.Angles(0, p72.angleFromForward or 0, 0)
		p70.distance = p72.distance or 5

		return
	end

	if p71 == t2.Type.FixedToHead then
		p70.localCF = p72.CFrame or CFrame.new()

		return
	end

	if p71 == t2.Type.NewStandard then
		p70.localCF = p72.CFrame or CFrame.new()

		return
	end

	if p71 == t2.Type.WristView then
		p70.localCF = p72.CFrame or CFrame.new()
		p70.distance = 0

		return
	end

	if p71 == t2.Type.PositionLocked then
		p70.localCF = p72.CFrame or CFrame.new()

		return
	end

	if p71 == t2.Type.UIManagerManaged then
		p70.part = p72.uiManagerPanelPart

		return
	end

	error("Invalid Panel type")
end
function t3.IsUIManagerManagedType(p73) -- line: 781
	-- upvalues: t2 (copy)
	return p73.panelType == t2.Type.UIManagerManaged
end
function t3.IsPositionLockedType(p74) -- line: 785
	-- upvalues: t2 (copy)
	return p74.panelType == t2.Type.PositionLocked
end
function t3.SetVisible(p75, p76, p77) -- line: 789
	-- upvalues: t2 (copy), VRService (copy), cFrame2 (copy), u14 (ref), u15 (ref)
	if p76 ~= p75.isVisible then
		p75:OnVisibilityChanged(p76)

		if not p76 then
			t2.OnPanelClosed:Fire(p75.name)
		else
			p75.needsPositionUpdate = true

			if p75.panelType == t2.Type.WristView then
				p75.originCF = VRService:GetUserCFrame(Enum.UserCFrame.Head) * cFrame2
			end
		end
	end

	p75.isVisible = p76
	p75:SetEnabled(p76)

	if p76 and p77 then
		t2.SetModalPanel(p75)
	end

	if not p76 and p75 == u14 then
		if p77 then
			t2.SetModalPanel(u15)
		else
			t2.SetModalPanel(nil)

			if p75 == u15 then
				u15 = nil
			end
		end
	end

	if not p76 and p75.forceShowUntilLookedAt then
		p75.forceShowUntilLookedAt = false
	end
end
function t3.IsVisible(p78) -- line: 829
	return p78.isVisible
end
function t3.LinkTo(p79, p80) -- line: 833
	-- upvalues: t2 (copy)
	if type(p80) == "string" then
		p79.linkedTo = t2.Get(p80)

		return
	end

	p79.linkedTo = p80
end
function t3.ForceShowUntilLookedAt(p81, p82) -- line: 841
	p81:GetPart()
	p81:GetGUI()
	p81:SetVisible(true, p82)
	p81:RequestPositionUpdate()
	p81.forceShowUntilLookedAt = true
end
function t3.ForceShowForSeconds(p83, p84) -- line: 851
	p83:GetPart()
	p83:GetGUI()
	p83:SetVisible(true)

	if p83.forceShowUntilTick < tick() then
		p83:RequestPositionUpdate()
	end

	p83.forceShowUntilTick = tick() + p84
end
function t3.SetCanFade(p85, p86) -- line: 862
	p85.canFade = p86
end
function t3.RequestPositionUpdate(p87) -- line: 866
	p87.needsPositionUpdate = true
end
function t3.ForcePositionUpdate(p88, p89) -- line: 870
	p88.alwaysUpdatePosition = p89
end
function t3.GetGuiPositionInPanelSpace(p90, p91) -- line: 874
	local vector2_3 = Vector2.new(p90.part.Size.X, p90.part.Size.Y)
	local AbsoluteSize = p90.gui.AbsoluteSize
	local v235 = (p91 - AbsoluteSize / 2) / AbsoluteSize * vector2_3

	return (Vector3.new(v235.X, v235.Y, 0.1))
end
function t3.GetCFrameInCameraSpace(p92) -- line: 885
	-- upvalues: t2 (copy)
	if p92.panelType == t2.Type.Standard or p92.panelType == t2.Type.NewStandard then
		return p92.originCF * p92.localCF
	end

	return p92.localCF or CFrame.new()
end

local t5 = {}

t5.__index = t5

function t5.new(p93, p94) -- line: 896
	-- upvalues: t5 (copy)
	local t6 = {
		parentPanel = p93,
		guiElement = p94,
		lastParent = p94.Parent,
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

	setmetatable(t6, t5)
	t6:GetGUI()
	t6:UpdateSurrogate()
	t6:WatchParent(t6.lastParent)
	p94.Parent = t6.guiSurrogate

	local function ancestryCallback(_, p96) -- line: 924
		-- upvalues: t6 (copy), p94 (copy), ancestryCallback (copy)
		t6:GetGUI().Enabled = t6.parentPanel:GetGUI():IsAncestorOf(t6.lastParent)

		if not t6:GetGUI().Enabled then
			t6:GetPart().Parent = nil
		else
			t6:GetPart().Parent = workspace.CurrentCamera
		end

		if p96 == p94 then
			t6.ancestryConn:disconnect()
			t6.lastParent = p94.Parent
			p94.Parent = t6.guiSurrogate
			t6:WatchParent(t6.lastParent)
			t6.ancestryConn = p94.AncestryChanged:connect(ancestryCallback)
		end
	end

	t6.ancestryConn = p94.AncestryChanged:connect(ancestryCallback)

	return t6
end
function t5.Cleanup(p97) -- line: 948
	p97.guiElement.Parent = p97.lastParent

	if p97.part then
		p97.part:Destroy()
		p97.part = nil
	end

	spawn(function() -- line: 954
		-- upvalues: p97 (copy)
		wait()

		if p97.gui then
			p97.gui:Destroy()
			p97.gui = nil
		end
	end)

	if p97.ancestryConn then
		p97.ancestryConn:disconnect()
		p97.ancestryConn = nil
	end

	if p97.changedConn then
		p97.changedConn:disconnect()
		p97.changedConn = nil
	end

	p97.lastParent = nil
	p97.parentPanel = nil
	p97.guiElement = nil
	p97.guiSurrogate = nil
end
function t5.OnMouseEnter(_, _, _) -- line: 975
end
function t5.OnMouseLeave(_, _, _) -- line: 976
end
function t5.SetLookedAt(p104, p105) -- line: 978
	if p105 and not p104.lookedAt then
		p104:OnMouseEnter(p104.lookAtPixel.X, p104.lookAtPixel.Y)
	elseif not p105 and p104.lookedAt then
		p104:OnMouseLeave(p104.lookAtPixel.X, p104.lookAtPixel.Y)
	end

	p104.lookedAt = p105
end
function t5.WatchParent(p106, p107) -- line: 987
	if p106.changedConn then
		p106.changedConn:disconnect()
	end

	p106.changedConn = p107.Changed:connect(function(p108) -- line: 991
		-- upvalues: p106 (copy)
		if p108 == "AbsolutePosition" or (p108 == "AbsoluteSize" or p108 == "Parent") then
			p106:UpdateSurrogate()
		end
	end)
end
function t5.UpdateSurrogate(p109) -- line: 998
	local lastParent = p109.lastParent

	p109.guiSurrogate.Position = UDim2.new(0, lastParent.AbsolutePosition.X, 0, lastParent.AbsolutePosition.Y)
	p109.guiSurrogate.Size = UDim2.new(0, lastParent.AbsoluteSize.X, 0, lastParent.AbsoluteSize.Y)
end
function t5.GetPart(p110) -- line: 1004
	-- upvalues: v21 (copy)
	if p110.part then
		return p110.part
	end

	p110.part = p110.parentPanel:GetPart():Clone()
	p110.part.Parent = v21

	return p110.part
end
function t5.GetGUI(p111) -- line: 1014
	-- upvalues: Create (copy), CoreGui (copy)
	if p111.gui then
		return p111.gui
	end

	p111.gui = Create("SurfaceGui")({
		Active = true,
		ToolPunchThroughDistance = 1000,
		AlwaysOnTop = true,
		Parent = CoreGui,
		Adornee = p111:GetPart(),
		CanvasSize = p111.parentPanel:GetGUI().CanvasSize,
		Enabled = p111.parentPanel.isEnabled
	})
	p111.guiSurrogate = Create("Frame")({
		Active = false,
		BackgroundTransparency = 1,
		Parent = p111.gui,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0)
	})

	return p111.gui
end
function t5.SetDepthOffset(p112, p113) -- line: 1041
	p112.depthOffset = p113
end
function t5.Update(p114) -- line: 1045
	local Part = p114:GetPart()
	local Part2 = p114.parentPanel:GetPart()

	if Part and Part2 then
		Part.CFrame = Part2.CFrame * CFrame.new(0, 0, -p114.depthOffset)
	end
end
function t5.SetEnabled(p115, p116) -- line: 1054
	-- upvalues: v21 (copy)
	p115.isEnabled = p116

	if p116 and p115.parentPanel.isEnabled then
		p115:GetPart().Parent = v21
		p115:GetGUI().Enabled = true

		return
	end

	p115:GetPart().Parent = nil
	p115:GetGUI().Enabled = false
end
function t5.GetEnabled(p117) -- line: 1067
	return p117.isEnabled
end
function t5.GetPixelScale(p118) -- line: 1071
	return p118.parentPanel:GetPixelScale()
end
function t3.GetPixelScale(p119) -- line: 1074
	return p119.pixelScale
end
function t3.AddSubpanel(p120, p121) -- line: 1078
	-- upvalues: t5 (copy)
	local v268 = t5.new(p120, p121)

	p120.subpanels[p121] = v268

	return v268
end
function t3.RemoveSubpanel(p122, p123) -- line: 1084
	local v271 = p122.subpanels[p123]

	if v271 then
		v271:Cleanup()
	end

	p122.subpanels[p123] = nil
end
function t3.SetSubpanelDepth(p124, p125, p126) -- line: 1092
	local v275 = p124.subpanels[p125]

	if p126 == 0 then
		if v275 then
			p124:RemoveSubpanel(p125)
		end

		return nil
	end

	if not v275 then
		v275 = p124:AddSubpanel(p125)
	end

	v275:SetDepthOffset(p126)

	return v275
end
function t2.Get(p127) -- line: 1114
	-- upvalues: t1 (copy), t3 (copy)
	local v277 = t1[p127]

	if not t1[p127] then
		t1[p127] = t3.new(p127)
		v277 = t1[p127]
	end

	return v277
end

local timestamp = tick()

local function onRenderStep() -- line: 1126
	-- upvalues: VRService (copy), timestamp (ref), u17 (ref), n1 (ref), t1 (copy), u14 (ref), u18 (ref), v20 (copy)
	if not VRService.VREnabled then
		return
	end

	local timestamp2 = tick()
	local v279 = timestamp2 - timestamp

	timestamp = timestamp2
	u17 = nil
	n1 = 1e999

	local CurrentCamera = workspace.CurrentCamera
	local CurrentCameraCFrame = CurrentCamera.CFrame
	local RenderCFrame = CurrentCamera:GetRenderCFrame()
	local UserCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
	local ray = Ray.new(RenderCFrame.p, RenderCFrame.lookVector)
	local GuiInputUserCFrame = VRService.GuiInputUserCFrame
	local v286 = CurrentCameraCFrame * VRService:GetUserCFrame(GuiInputUserCFrame)
	local ray2 = Ray.new(v286.p, v286.lookVector)

	for _, v in pairs(t1) do
		v:Update(CurrentCameraCFrame, RenderCFrame, UserCFrame, ray, ray2, v279)
	end

	local t7 = {}

	for _, v in pairs(t1) do
		if not t7[v] and v.linkedTo and v.isVisible and v.linkedTo.isVisible then
			t7[v] = true
			t7[v.linkedTo] = true

			local v293 = math.min(v.transparency, v.linkedTo.transparency)

			v.transparency = v293
			v.linkedTo.transparency = v293
		end
	end

	for _, v in pairs(t1) do
		if v.part and v.gui then
			local v296 = v == u14 or (not v.linkedTo or v.linkedTo == u14)
			local isVisible = v.isVisible

			if not v296 and u14 then
				isVisible = false
			end

			if v.transparency >= 1 then
				isVisible = false
			end

			if v.forceShowUntilLookedAt then
				isVisible = true
			end

			if not v.canFade and v.isVisible then
				isVisible = true
			end

			v:SetEnabled(isVisible)
		end

		v:OnUpdate(v279)
	end

	if u17 then
		local X = u18.X
		local Y = u18.Y
		local PixelScale = u17:GetPixelScale()

		v20.Size = UDim2.new(0, 3 * PixelScale, 0, 3 * PixelScale)
		v20.Position = UDim2.new(0, X - v20.AbsoluteSize.x * 0.5, 0, Y - v20.AbsoluteSize.y * 0.5)

		return
	end

	v20.Parent = nil
end

local u28 = true

local function putFoldersIn(p128) -- line: 1212
	-- upvalues: v21 (copy), v22 (copy)
	v21.Parent = p128
	v22.Parent = p128
end

local connection = nil

local function onHeadScaleChanged() -- line: 1218
	-- upvalues: t1 (copy)
	for _, v in pairs(t1) do
		v:OnHeadScaleChanged()
	end
end

local connection2 = nil

local function onCameraCFrameChanged() -- line: 1225
	-- upvalues: VRService (copy), t1 (copy)
	local CurrentCamera = workspace.CurrentCamera
	local CurrentCameraCFrame = CurrentCamera.CFrame
	local RenderCFrame = CurrentCamera:GetRenderCFrame()
	local UserCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
	local ray = Ray.new(RenderCFrame.p, RenderCFrame.lookVector)
	local GuiInputUserCFrame = VRService.GuiInputUserCFrame
	local v310 = CurrentCameraCFrame * VRService:GetUserCFrame(GuiInputUserCFrame)
	local ray3 = Ray.new(v310.p, v310.lookVector)

	for _, v in pairs(t1) do
		v:Update(CurrentCameraCFrame, RenderCFrame, UserCFrame, ray, ray3, 0)
	end
end
local function onCurrentCameraChanged() -- line: 1241
	-- upvalues: t1 (copy), connection (ref), onHeadScaleChanged (copy), connection2 (ref), onCameraCFrameChanged (copy), VRService (copy), u28 (ref), v21 (copy), v22 (copy)
	for _, v in pairs(t1) do
		v:OnHeadScaleChanged()
	end

	if connection then
		connection:disconnect()
	end

	connection = workspace.CurrentCamera:GetPropertyChangedSignal("HeadScale"):Connect(onHeadScaleChanged)

	if connection2 then
		connection2:disconnect()
	end

	connection2 = workspace.CurrentCamera:GetPropertyChangedSignal("CFrame"):Connect(onCameraCFrameChanged)

	if VRService.VREnabled and u28 then
		local CurrentCamera = workspace.CurrentCamera

		v21.Parent = CurrentCamera
		v22.Parent = CurrentCamera
	end
end

local connection3 = nil
local u36 = false

local function onVREnabledChanged() -- line: 1264
	-- upvalues: VRService (copy), u28 (ref), onCurrentCameraChanged (copy), connection3 (ref), v21 (copy), v22 (copy), u36 (ref), RunService (copy), v9 (copy), onRenderStep (copy)
	if VRService.VREnabled then
		while not u28 do
			wait()
		end

		if workspace.CurrentCamera then
			onCurrentCameraChanged()
		end

		connection3 = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(onCurrentCameraChanged)

		local CurrentCamera = workspace.CurrentCamera

		v21.Parent = CurrentCamera
		v22.Parent = CurrentCamera

		if not u36 then
			RunService:BindToRenderStep(v9, Enum.RenderPriority.Last.Value, onRenderStep)
			u36 = true

			return
		end
	else
		if connection3 then
			connection3:disconnect()
			connection3 = nil
		end

		v21.Parent = nil
		v22.Parent = nil

		if u36 then
			RunService:UnbindFromRenderStep(v9)
			u36 = false
		end
	end
end

VRService:GetPropertyChangedSignal("VREnabled"):connect(onVREnabledChanged)
spawn(onVREnabledChanged)
coroutine.wrap(function() -- line: 1297
	-- upvalues: u28 (ref)
	while true do
		while not workspace.CurrentCamera do
			wait()
		end

		if workspace.CurrentCamera.CameraSubject ~= nil or workspace.CurrentCamera.CameraType == Enum.CameraType.Scriptable then
			break
		end

		workspace.CurrentCamera.Changed:Wait()
	end

	u28 = true
end)()

return t2
