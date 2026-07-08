local VrSpatialUi = script:FindFirstAncestor("VrSpatialUi")
local VrSpatialUiParent = VrSpatialUi.Parent
local Observable = require(VrSpatialUiParent.Observable)
local VRService = game:GetService("VRService")
local RunService = game:GetService("RunService")
local isInExperienceUIVREnabled = require(VrSpatialUiParent.SharedExperimentDefinition).isInExperienceUIVREnabled
local InExperienceUIVRIXP = require(VrSpatialUiParent.SharedExperimentDefinition).InExperienceUIVRIXP
local VRHub = nil

if not isInExperienceUIVREnabled then
	VRHub = require(VrSpatialUiParent.VrCommon).VRHub
end

local Constants = require(VrSpatialUi.Constants)
local Utils = require(VrSpatialUi.Utils)
local PanelType = Constants.PanelType
local SpatialUIType = Constants.SpatialUIType
local createCompatPanel = require(script.Parent.createCompatPanel)
local createUIGroupDragBar = require(script.Parent.createUIGroupDragBar)

require(VrSpatialUi.DragBar)

local UIGroupHelper = nil
local StableCameraCache = nil

if isInExperienceUIVREnabled then
	UIGroupHelper = require(VrSpatialUi.UIGroupHelper)
	StableCameraCache = require(VrSpatialUi.StableCameraCache)
end

local Players = game:GetService("Players")
local v18 = game:DefineFastInt("FIntUIResetDelayInSec", 3)
local v19 = game:DefineFastInt("SpatialUIPanelDistance", 64)
local v20 = game:DefineFastFlag("SpatialUIEnablePanelsRefocusing", false)
local v21 = game:DefineFastFlag("SpatialUIDisableBottomBarFading", false)
local v22 = game:DefineFastFlag("SpatialUIDisableBottomBarInteractionOnAnimating", false)
local v23 = if not isInExperienceUIVREnabled then CFrame.Angles(-0.3141592653589793, 0.17453292519943295, 0) else CFrame.Angles(0, 0, 0)
local cFrame

if isInExperienceUIVREnabled then
	local v24 = math.min(math.max(v19, 0), 500) / 100

	cFrame = CFrame.new(0, 0, v24 * -1 * 3.3333333333333335)
else
	cFrame = CFrame.new(-0.46666666666666673, -0.8, -2.1333333333333333)
end

local vector2 = Vector2.new(2.666666666666667, 1.866666666666667)
local v27 = cFrame * v23

local function getZAxisStablizedCFrame(cFrame2: CFrame) -- line: 62
	local v35, v36, _ = cFrame2:ToOrientation()

	return CFrame.new(cFrame2.Position) * CFrame.fromOrientation(v35, v36, 0)
end
local function getCameraOffsetFromHeadRotationWithZAxisStabl(p1, cFrame3: CFrame?) -- line: 67
	-- upvalues: VRService (copy)
	local v40 = cFrame3 or workspace.CurrentCamera.CFrame
	local v41 = (v40 * VRService:GetUserCFrame(Enum.UserCFrame.Head)):ToWorldSpace(p1)
	local v42, v43, _ = v41:ToOrientation()

	return v40:ToObjectSpace(CFrame.new(v41.Position) * CFrame.fromOrientation(v42, v43, 0))
end
local function getPanelPart(p2) -- line: 76
	-- upvalues: SpatialUIType (copy)
	if p2.uiType == SpatialUIType.SpatialUI or p2.uiType == SpatialUIType.SpatialUIRoact then
		return p2.panelObject.Adornee
	end

	if p2.uiType == SpatialUIType.SpatialUIPartOnly then
		return p2.panelObject
	end

	return nil
end
local function panelExistsInSpace(p3) -- line: 87
	-- upvalues: SpatialUIType (copy)
	return p3 ~= nil and (p3.panelObject ~= nil and p3.uiType ~= SpatialUIType.ScreenUI)
end

function createUIGroup(p4, p5, b1: boolean?) -- line: 91
	-- upvalues: vector2 (copy), v27 (copy), VRService (copy)
	local uiGroupHelper = p4.uiGroupHelper
	local v51 = vector2
	local t1 = {
		uiGroupHeadRotation = v27
	}
	local v53 = v27
	local CurrentCameraCFrame = workspace.CurrentCamera.CFrame
	local v55 = (CurrentCameraCFrame * VRService:GetUserCFrame(Enum.UserCFrame.Head)):ToWorldSpace(v53)
	local v56, v57, _ = v55:ToOrientation()

	t1.uiGroupCameraOffSet = CurrentCameraCFrame:ToObjectSpace(CFrame.new(v55.Position) * CFrame.fromOrientation(v56, v57, 0))
	t1.defaultGroupHeadRotation = v27

	local v59 = uiGroupHelper:createUIGroup(p4, p5, v51, t1, p4.uiElements, b1)

	p4.uiGroups[p5] = v59
end

local t2 = {}
local u33 = nil

t2.__index = t2

function t2.removeRoactPanel(p6, p7) -- line: 125
	-- upvalues: isInExperienceUIVREnabled (copy)
	if isInExperienceUIVREnabled then
		p6:disconnectPanelVisibility(p7)
	end

	p6.uiElements[p7] = nil
end
function t2.registerRoactPanel(p8, p9, p10, p11) -- line: 132
	-- upvalues: isInExperienceUIVREnabled (copy), InExperienceUIVRIXP (copy), Observable (copy)
	p8.uiElements[p9] = p10

	if isInExperienceUIVREnabled then
		local v66 = p8.uiGroupHelper:checkAndGetUIGroupTypeForTempPanel(p9, p8.uiElements)

		if v66 ~= nil then
			p8:rescaleUIForCurrentHeadScale(v66, p9)

			if InExperienceUIVRIXP:isSpatialUICameraTypeFixEnabled() then
				p8:updateUIGroupsForCurCamera(p9, (p8.stableCameraCache:getCurrentStableCameraCFrame()))
			else
				p8:updateUIGroupsForCurCamera(p9)
			end
		else
			p8:rescaleUIForCurrentHeadScale()
			p8:updateUIGroupsForCurHeadCFrame()
		end
	else
		p8:rescaleUIForCurrentHeadScale()
		p8:updateUIGroupsForCurHeadCFrame()
	end

	if isInExperienceUIVREnabled then
		p8:connectPanelVisibility(p9, p11 or Observable.ObservableValue.new(true))
	end
end
function t2.createUI(p12, p13) -- line: 169
	-- upvalues: createCompatPanel (copy)
	local v69 = createCompatPanel(p13)

	if v69 == nil then
		return nil
	end

	p12.uiElements[p13.panelType] = v69
	p12:updatePanelForCurHeadCFrame(p13.panelType)

	return {
		type = v69.uiType,
		panelObject = v69.panelObject
	}
end
function t2.getPanelObject(p14, p15) -- line: 182
	local v72 = p14.uiElements[p15]

	if v72 then
		return v72.panelObject
	end

	return nil
end
function t2.getPanelSizeInPixel(p16, p17) -- line: 191
	-- upvalues: Constants (copy)
	return p16:getScaledPartSizeInPixel(p17) * Constants.VR_PANEL_RESOLUTION_MULTIPLIER
end
function t2.getScaledPartSizeInPixel(_, p19) -- line: 196
	-- upvalues: PanelType (copy), Constants (copy)
	if p19 == PanelType.BottomBar then
		return Constants.BOTTOM_BAR_SIZE
	end

	local spatialPanelProps = Constants.COMPAT_PANEL_PROPS_MAP[p19].spatialPanelProps

	if not spatialPanelProps then
		return Vector2.new(0, 0)
	end

	local partSize = spatialPanelProps.partSize

	return Vector2.new(partSize.X, partSize.Y)
end
function t2.connectTopBarVisibility(p20, p21) -- line: 208
	p20.uiGroupHelper:setTopBarVisible(p21, function() -- line: 209
		-- upvalues: p20 (copy)
		p20.uiGroupHelper:updateAllElements(p20.uiElements, p20.uiGroups)
	end)
end
function t2.connectPanelVisibility(p22, p23, p24) -- line: 214
	p22.uiGroupHelper:connectPanelVisibility(p23, p24, p22.uiElements, p22.uiGroups)
end
function t2.disconnectPanelVisibility(p25, p26) -- line: 222
	p25.uiGroupHelper:disconnectPanelVisibility(p26, p25.uiElements, p25.uiGroups)
end
function t2.updateUIGroupForCurHeadCFrame(p27, p28, b2: boolean?) -- line: 226
	-- upvalues: VRService (copy)
	local v89 = p27.uiGroups[p28]
	local uiGroupHeadRotation = v89.positionProps.uiGroupHeadRotation
	local CurrentCameraCFrame = workspace.CurrentCamera.CFrame
	local v92 = (CurrentCameraCFrame * VRService:GetUserCFrame(Enum.UserCFrame.Head)):ToWorldSpace(uiGroupHeadRotation)
	local v93, v94, _ = v92:ToOrientation()
	local v96 = CurrentCameraCFrame:ToObjectSpace(CFrame.new(v92.Position) * CFrame.fromOrientation(v93, v94, 0))

	v89.positionProps.uiGroupCameraOffSet = v96

	local v97 = b2 or false

	if v89.draggable and (v89.dragBar and not v97) then
		v89.dragBar:setCFrame(workspace.CurrentCamera.CFrame * v96:ToWorldSpace(v89.dragBarOffset))
	end

	p27:updatePanelsInUIGroupForCurHeadCFrame(p28)
end
function t2.updateUIGroupsForCurHeadCFrame(p29) -- line: 247
	for k, _ in pairs(p29.uiGroups) do
		p29:updateUIGroupForCurHeadCFrame(k)
	end
end
function t2.updatePanelForCurHeadCFrame(p30, p31) -- line: 253
	-- upvalues: SpatialUIType (copy), VRService (copy)
	local v103 = p30.uiElements[p31]

	if v103 ~= nil and (v103.panelObject ~= nil and v103.uiType ~= SpatialUIType.ScreenUI) and (v103.panelPositionProps and v103.panelPositionProps.cameraFixedPanelProp) then
		local panelPositionProps = v103.panelPositionProps
		local cameraFixedPanelProp = panelPositionProps.cameraFixedPanelProp
		local uiGroupHeadRotation = p30.uiGroups[panelPositionProps.uiGroup].positionProps.uiGroupHeadRotation
		local CurrentCameraCFrame = workspace.CurrentCamera.CFrame
		local v108 = (CurrentCameraCFrame * VRService:GetUserCFrame(Enum.UserCFrame.Head)):ToWorldSpace(uiGroupHeadRotation)
		local v109, v110, _ = v108:ToOrientation()
		local v112 = CurrentCameraCFrame:ToObjectSpace(CFrame.new(v108.Position) * CFrame.fromOrientation(v109, v110, 0))
		local v113 = if v103.uiType ~= SpatialUIType.SpatialUI and v103.uiType ~= SpatialUIType.SpatialUIRoact then if v103.uiType ~= SpatialUIType.SpatialUIPartOnly then nil else v103.panelObject else v103.panelObject.Adornee

		if v113 == nil then
			return
		end

		v113.CFrame = workspace.CurrentCamera.CFrame * v112
		v113.CFrame = v113.CFrame:ToWorldSpace(cameraFixedPanelProp.uiGroupElementOffset)
	end
end
function t2.updatePanelsInUIGroupForCurHeadCFrame(p32, p33) -- line: 275
	for k, v in pairs(p32.uiElements) do
		if v.panelPositionProps and p33 == v.panelPositionProps.uiGroup then
			p32:updatePanelForCurHeadCFrame(k)
		end
	end
end
function t2.updatePanelsForCurHeadCFrame(p34) -- line: 289
	for k, _ in pairs(p34.uiElements) do
		p34:updatePanelForCurHeadCFrame(k)
	end
end
function t2.dragUiGroupStart(p35, p36) -- line: 295
	if p35.uiGroups[p36].draggable == false then
		return
	end

	local dragBar = p35.uiGroups[p36].dragBar
	local v124 = workspace.CurrentCamera.CFrame:ToWorldSpace(p35.uiGroups[p36].positionProps.uiGroupCameraOffSet)

	dragBar:startDrag((dragBar:getCFrame():ToObjectSpace(v124)))
end
function t2.dragUiGroupEnd(p37, p38) -- line: 307
	if p37.uiGroups[p38].draggable == false then
		return
	end

	p37.uiGroups[p38].dragBar:dragEnd()
end
function t2.dragUiGroupStep(p39, p40) -- line: 315
	-- upvalues: VRService (copy)
	if p39.uiGroups[p40].draggable == false then
		return
	end

	local dragBar = p39.uiGroups[p40].dragBar
	local v130 = workspace.CurrentCamera.CFrame * VRService:GetUserCFrame(Enum.UserCFrame.Head)
	local v131 = dragBar:getCFrame()
	local vector3 = Vector3.new(v130.Position.X, v130.Position.Y - 0.6666666666666667, v130.Position.Z)
	local v133, v134, _ = (CFrame.lookAt(v131.Position, vector3) * CFrame.Angles(0, 3.141592653589793, 0)):ToEulerAnglesXYZ()
	local _, _, v138 = v131:ToEulerAnglesXYZ()
	local v139 = CFrame.new(v131.Position) * CFrame.Angles(v133, v134, v138)
	local v140, v141, _ = v139:ToOrientation()

	dragBar:setCFrame(CFrame.new(v139.Position) * CFrame.fromOrientation(v140, v141, 0))

	local v143 = dragBar:getCFrame():ToWorldSpace(dragBar.uiGroupOffSet)

	p39.uiGroups[p40].positionProps.uiGroupHeadRotation = v130:ToObjectSpace(v143)
	p39:updateUIGroupForCurHeadCFrame(p40, true)
end
function t2.setUpUiGroups(p41, b3: boolean?) -- line: 347
	-- upvalues: isInExperienceUIVREnabled (copy), Constants (copy), createUIGroupDragBar (copy), v27 (copy), VRService (copy), vector2 (copy), PanelType (copy)
	if isInExperienceUIVREnabled then
		createUIGroup(p41, Constants.SpatialUIGroupType.MainUIGroup, b3)
		createUIGroup(p41, Constants.SpatialUIGroupType.MenuUIGroup, b3)
		createUIGroup(p41, Constants.SpatialUIGroupType.ChatUIGroup, b3)
		createUIGroup(p41, Constants.SpatialUIGroupType.ChromeSubMenuUIGroup, b3)
		p41.uiGroupHelper:updateAllDragBar(p41.uiElements, p41.uiGroups)

		return
	end

	local v146 = createUIGroupDragBar({
		name = "MainUIGroup",
		dragFunction = function(_, _, _, _, _) -- line: 359
			-- upvalues: p41 (copy), Constants (copy)
			p41:dragUiGroupStep(Constants.SpatialUIGroupType.MainUIGroup)
		end,
		dragStartFunction = function(_, _, _, _, _, _, _) -- line: 362
			-- upvalues: p41 (copy), Constants (copy)
			p41:dragUiGroupStart(Constants.SpatialUIGroupType.MainUIGroup)
		end,
		dragEndFunction = function(_) -- line: 365
			-- upvalues: p41 (copy), Constants (copy)
			p41:dragUiGroupEnd(Constants.SpatialUIGroupType.MainUIGroup)
		end
	})
	local t3 = {
		draggable = true,
		headScale = 1
	}
	local t4 = {
		uiGroupHeadRotation = v27
	}
	local v149 = v27
	local CurrentCameraCFrame = workspace.CurrentCamera.CFrame
	local v151 = (CurrentCameraCFrame * VRService:GetUserCFrame(Enum.UserCFrame.Head)):ToWorldSpace(v149)
	local v152, v153, _ = v151:ToOrientation()

	t4.uiGroupCameraOffSet = CurrentCameraCFrame:ToObjectSpace(CFrame.new(v151.Position) * CFrame.fromOrientation(v152, v153, 0))
	t4.defaultGroupHeadRotation = v27
	t3.positionProps = t4
	t3.uiContainerSize = vector2
	t3.dragBar = v146
	t3.dragBarOffset = CFrame.new(0, Constants.ROACT_PANEL_UIGROUP_ELEMENT_OFFSET_MAP[PanelType.BottomBar].Y - 0.075 - 0.06666666666666667, 0)
	p41.uiGroups[Constants.SpatialUIGroupType.MainUIGroup] = t3
end
function t2.step(p55) -- line: 390
	-- upvalues: VRService (copy), SpatialUIType (copy), PanelType (copy), isInExperienceUIVREnabled (copy), v21 (copy), v20 (copy), v18 (copy)
	if not VRService.VREnabled then
		return
	end

	for k, v in pairs(p55.uiElements) do
		if v ~= nil and (v.panelObject ~= nil and v.uiType ~= SpatialUIType.ScreenUI) and k == PanelType.RobloxGui then
			local v158, v159, _ = ((if v.uiType ~= SpatialUIType.SpatialUI then v.panelObject else v.panelObject.Adornee)).CFrame:ToOrientation()
			local v161, v162, _ = (workspace.CurrentCamera.CFrame * VRService:GetUserCFrame(Enum.UserCFrame.Head)):ToOrientation()

			if isInExperienceUIVREnabled and not v21 and p55.uiGroupHelper then
				p55.uiGroupHelper:animateBottomBarOnHeadMoveIfNeeded(p55.uiElements, Vector2.new(v158, v159), Vector2.new(v161, v162))
			end

			if isInExperienceUIVREnabled and v20 and (math.abs(v159 - v162) > 1.7453292519943295 or math.abs(v158 - v161) > 1.7453292519943295) then
				if p55.uiGroupsOutOfViewTimeStamp then
					if os.clock() - p55.uiGroupsOutOfViewTimeStamp >= v18 then
						p55:updateUIGroupsForCurHeadCFrame()
						p55.uiGroupsOutOfViewTimeStamp = nil
					end
				else
					p55.uiGroupsOutOfViewTimeStamp = os.clock()
				end
			else
				p55.uiGroupsOutOfViewTimeStamp = nil
			end
		end
	end
end
function t2.prepareGuiToggleAnimationState(p56) -- line: 441
	if p56.uiGroupHelper:isTopBarVisible() then
		p56.uiGroupHelper:prepareGuiToggleAnimationState(p56.uiElements)
	end
end
function t2.onShowTopBarChanged(p57) -- line: 447
	-- upvalues: isInExperienceUIVREnabled (copy), VRService (copy), VRHub (ref), SpatialUIType (copy)
	if isInExperienceUIVREnabled then
		return
	end

	if not VRService.VREnabled then
		return
	end

	if VRHub and VRHub.ShowTopBar then
		for _, v in pairs(p57.uiGroups) do
			if v.draggable and v.dragBar then
				v.dragBar:show()
			end
		end

		for _, v in pairs(p57.uiElements) do
			if v.uiType == SpatialUIType.SpatialUI or v.uiType == SpatialUIType.SpatialUIRoact then
				local panelObject = v.panelObject

				panelObject.Enabled = true
				panelObject.Adornee.Parent = workspace
			elseif v.uiType == SpatialUIType.SpatialUIPartOnly then
				v.panelObject.Parent = workspace
			end
		end

		return
	end

	for _, v in pairs(p57.uiGroups) do
		if v.draggable and v.dragBar then
			v.dragBar:hide()
		end
	end

	for _, v in pairs(p57.uiElements) do
		if v.uiType == SpatialUIType.SpatialUI or v.uiType == SpatialUIType.SpatialUIRoact then
			local panelObject = v.panelObject

			panelObject.Enabled = false
			panelObject.Adornee.Parent = nil
		elseif v.uiType == SpatialUIType.SpatialUIPartOnly then
			v.panelObject.Parent = nil
		end
	end
end
function t2.updateUIGroupsForCurCamera(p58, p59, cFrame4: CFrame?) -- line: 491
	-- upvalues: VRService (copy), SpatialUIType (copy), isInExperienceUIVREnabled (copy), InExperienceUIVRIXP (copy)
	if not VRService.VREnabled then
		return
	end

	for _, v in pairs(p58.uiGroups) do
		if p59 == nil and v.draggable then
			v.dragBar:setCFrame((cFrame4 or workspace.CurrentCamera.CFrame) * v.positionProps.uiGroupCameraOffSet:ToWorldSpace(v.dragBarOffset))
		end
	end

	for k, v in pairs(p58.uiElements) do
		if p59 ~= nil and p59 ~= k or (v == nil or (v.panelObject == nil or v.uiType == SpatialUIType.ScreenUI)) or not v.panelPositionProps or not v.panelPositionProps.cameraFixedPanelProp then
			continue
		end

		local panelPositionProps = v.panelPositionProps
		local cameraFixedPanelProp = panelPositionProps.cameraFixedPanelProp
		local v185 = if v.uiType ~= SpatialUIType.SpatialUI and v.uiType ~= SpatialUIType.SpatialUIRoact then if v.uiType ~= SpatialUIType.SpatialUIPartOnly then nil else v.panelObject else v.panelObject.Adornee

		if v185 == nil then
			return
		end

		local v186 = cFrame4 or workspace.CurrentCamera.CFrame

		if isInExperienceUIVREnabled and not InExperienceUIVRIXP:isSpatialUICameraTypeFixEnabled() then
			v186 = p58.uiGroupHelper:getGroupCameraCFrameIfPossible(k, p58.uiElements)
		end

		v185.CFrame = v186 * p58.uiGroups[panelPositionProps.uiGroup].positionProps.uiGroupCameraOffSet:ToWorldSpace(cameraFixedPanelProp.uiGroupElementOffset)
	end
end
function t2.onMouseTargetChanged(p60, p61) -- line: 539
	for _, v in pairs(p60.uiGroups) do
		if v.draggable then
			if v.dragBar and p61 == v.dragBar.part then
				v.dragBar:startHover()
			elseif v.dragBar and p61 ~= v.dragBar.part then
				v.dragBar:hoverEnd()
			end
		end
	end
end
function t2.resetDragAndDrop(p62) -- line: 551
	for _, v in pairs(p62.uiGroups) do
		if v.draggable and v.dragBar then
			v.dragBar:hide()
		end
	end

	p62:setUpUiGroups(true)
	p62:rescaleUIForCurrentHeadScale()
	p62:updateUIGroupsForCurCamera()
end
function t2.getAdditionalCameraScaleIfNeeded(_) -- line: 564
	-- upvalues: VRService (copy)
	if VRService.VREnabled then
		return workspace.CurrentCamera.HeadScale
	end

	return 1
end
function t2.rescaleUIForCurrentHeadScale(p64, p65, p66) -- line: 568
	-- upvalues: isInExperienceUIVREnabled (copy), Utils (copy), SpatialUIType (copy)
	local v198 = if not isInExperienceUIVREnabled then workspace.CurrentCamera.HeadScale else p64:getAdditionalCameraScaleIfNeeded()

	for _, v in pairs(p64.uiGroups) do
		if p65 == nil then
			local v201 = v198 / v.headScale

			v.positionProps.uiGroupHeadRotation = Utils.rescaleCFramePosition(v.positionProps.uiGroupHeadRotation, v201)
			v.positionProps.uiGroupCameraOffSet = Utils.rescaleCFramePosition(v.positionProps.uiGroupCameraOffSet, v201)
			v.positionProps.defaultGroupHeadRotation = Utils.rescaleCFramePosition(v.positionProps.defaultGroupHeadRotation, v201)

			if v.draggable then
				v.dragBarOffset = Utils.rescaleCFramePosition(v.dragBarOffset, v201)
				v.dragBar:rescale(v201)
			end

			v.headScale = v198

			if isInExperienceUIVREnabled then
				v.lastCameraCFrame = workspace.CurrentCamera.CFrame
			end
		end
	end

	for k, v in pairs(p64.uiElements) do
		if p66 == nil or p66 == k then
			local v204 = v198 / v.headScale

			if v.uiType ~= SpatialUIType.SpatialUIRoact then
				local v205 = if v.uiType ~= SpatialUIType.SpatialUI and v.uiType ~= SpatialUIType.SpatialUIRoact then if v.uiType ~= SpatialUIType.SpatialUIPartOnly then nil else v.panelObject else v.panelObject.Adornee

				if v205 ~= nil then
					v205.Size = v205.Size * v204
				end
			end

			local panelPositionProps = v.panelPositionProps

			if panelPositionProps and panelPositionProps.cameraFixedPanelProp then
				panelPositionProps.cameraFixedPanelProp.uiGroupElementOffset = Utils.rescaleCFramePosition(panelPositionProps.cameraFixedPanelProp.uiGroupElementOffset, v204)
			end

			v.headScale = v198
		end
	end
end
function t2.new() -- line: 621
	-- upvalues: isInExperienceUIVREnabled (copy), UIGroupHelper (ref), StableCameraCache (ref), t2 (copy), RunService (copy), VRHub (ref), InExperienceUIVRIXP (copy), Players (copy)
	local t5 = {
		currentMouseTarget = nil,
		uiGroupsOutOfViewTimeStamp = nil,
		uiElements = {},
		uiGroups = {},
		uiGroupHelper = {},
		stableCameraCache = {}
	}

	if isInExperienceUIVREnabled then
		t5.uiGroupHelper = UIGroupHelper.new(false)
		t5.stableCameraCache = StableCameraCache.new()
	end

	setmetatable(t5, t2)
	t5:setUpUiGroups()
	t5:rescaleUIForCurrentHeadScale()
	t5:updateUIGroupsForCurCamera()
	RunService:BindToRenderStep("UIManagerRenderStep", Enum.RenderPriority.Last.Value, function() -- line: 641
		-- upvalues: t5 (copy)
		t5:step()
	end)

	if not isInExperienceUIVREnabled and VRHub then
		VRHub.ShowTopBarChanged.Event:connect(function() -- line: 647
			-- upvalues: t5 (copy)
			t5:onShowTopBarChanged()
		end)
	end

	local CurrentCamera = workspace.CurrentCamera

	CurrentCamera:GetPropertyChangedSignal("CFrame"):Connect(function() -- line: 654
		-- upvalues: isInExperienceUIVREnabled (copy), InExperienceUIVRIXP (copy), t5 (copy)
		if isInExperienceUIVREnabled and InExperienceUIVRIXP:isSpatialUICameraTypeFixEnabled() then
			if t5.stableCameraCache:updateAndCheckCameraMoved() then
				t5:updateUIGroupsForCurCamera(nil, (t5.stableCameraCache:getCurrentStableCameraCFrame()))

				return
			end
		else
			t5:updateUIGroupsForCurCamera()
		end
	end)
	CurrentCamera:GetPropertyChangedSignal("HeadScale"):Connect(function() -- line: 665
		-- upvalues: t5 (copy)
		t5:rescaleUIForCurrentHeadScale()
		t5:updateUIGroupsForCurHeadCFrame()
	end)

	local Mouse = Players.LocalPlayer:GetMouse()

	if Mouse then
		Mouse.Move:Connect(function() -- line: 673
			-- upvalues: Players (copy), t5 (copy)
			local Mouse2 = Players.LocalPlayer:GetMouse()

			if Mouse2.Target ~= t5.currentMouseTarget then
				t5:onMouseTargetChanged(Mouse2.Target)
				t5.currentMouseTarget = Mouse2.Target
			end
		end)
	end

	return t5
end
function t2.getBottomBarVisibility(p67) -- line: 686
	-- upvalues: v22 (copy)
	if v22 then
		return nil
	end

	return p67.uiGroupHelper:getBottomBarVisibility()
end
function t2.isBottomBarInteractionOnAnimationSupported(p68) -- line: 693
	-- upvalues: v22 (copy)
	if v22 then
		return false
	end

	return (p68.uiGroupHelper:getBottomBarVisibility():get())
end
function t2.getInstance() -- line: 700
	-- upvalues: u33 (ref), t2 (copy)
	if u33 == nil then
		u33 = t2.new()
	end

	return u33
end

return t2
