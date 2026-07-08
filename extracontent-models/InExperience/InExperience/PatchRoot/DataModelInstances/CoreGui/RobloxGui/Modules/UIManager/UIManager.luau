local VRService = game:GetService("VRService")
local RunService = game:GetService("RunService")
local CorePackages = game:GetService("CorePackages")
local VRHub = require(CorePackages.Workspace.Packages.VrCommon).VRHub
local scriptParent = script.Parent
local Constants = require(scriptParent.Constants)
local Utils = require(scriptParent.Utils)
local PanelType = Constants.PanelType
local SpatialUIType = Constants.SpatialUIType
local createCompatPanel = require(script.Parent.createCompatPanel)
local createUIGroupDragBar = require(script.Parent.createUIGroupDragBar)

require(scriptParent.DragBar)

local Players = game:GetService("Players")
local v13 = game:DefineFastInt("FIntUIResetDelayInSec", 3)
local cFrame = CFrame.Angles(-0.3141592653589793, 0.17453292519943295, 0)
local cFrame2 = CFrame.new(-0.46666666666666673, -0.8, -2.1333333333333333)
local vector2 = Vector2.new(2.666666666666667, 1.866666666666667)
local v17 = cFrame2 * cFrame

local function getZAxisStablizedCFrame(cFrame3: CFrame) -- line: 52
	local v25, v26, _ = cFrame3:ToOrientation()

	return CFrame.new(cFrame3.Position) * CFrame.fromOrientation(v25, v26, 0)
end
local function getCameraOffsetFromHeadRotationWithZAxisStabl(p1) -- line: 57
	-- upvalues: VRService (copy)
	local CurrentCameraCFrame = workspace.CurrentCamera.CFrame
	local v30 = (CurrentCameraCFrame * VRService:GetUserCFrame(Enum.UserCFrame.Head)):ToWorldSpace(p1)
	local v31, v32, _ = v30:ToOrientation()

	return CurrentCameraCFrame:ToObjectSpace(CFrame.new(v30.Position) * CFrame.fromOrientation(v31, v32, 0))
end
local function getPanelPart(p2) -- line: 66
	-- upvalues: SpatialUIType (copy)
	if p2.uiType == SpatialUIType.SpatialUI or p2.uiType == SpatialUIType.SpatialUIRoact then
		return p2.panelObject.Adornee
	end

	if p2.uiType == SpatialUIType.SpatialUIPartOnly then
		return p2.panelObject
	end

	return nil
end
local function panelExistsInSpace(p3) -- line: 77
	-- upvalues: SpatialUIType (copy)
	return p3 ~= nil and (p3.panelObject ~= nil and p3.uiType ~= SpatialUIType.ScreenUI)
end

local t1 = {}
local u23 = nil

t1.__index = t1

function t1.removeRoactPanel(p4, p5) -- line: 97
	p4.uiElements[p5] = nil
end
function t1.registerRoactPanel(p6, p7, p8) -- line: 101
	p6.uiElements[p7] = p8
	p6:rescaleUIForCurrentHeadScale()
	p6:updateUIGroupsForCurHeadCFrame()
end
function t1.createUI(p9, p10) -- line: 113
	-- upvalues: createCompatPanel (copy)
	local v43 = createCompatPanel(p10)

	if v43 == nil then
		return nil
	end

	p9.uiElements[p10.panelType] = v43
	p9:updatePanelForCurHeadCFrame(p10.panelType)

	return {
		type = v43.uiType,
		panelObject = v43.panelObject
	}
end
function t1.updateUIGroupForCurHeadCFrame(p11, p12, b1: boolean?) -- line: 126
	-- upvalues: VRService (copy)
	local v47 = p11.uiGroups[p12]
	local uiGroupHeadRotation = v47.positionProps.uiGroupHeadRotation
	local CurrentCameraCFrame = workspace.CurrentCamera.CFrame
	local v50 = (CurrentCameraCFrame * VRService:GetUserCFrame(Enum.UserCFrame.Head)):ToWorldSpace(uiGroupHeadRotation)
	local v51, v52, _ = v50:ToOrientation()
	local v54 = CurrentCameraCFrame:ToObjectSpace(CFrame.new(v50.Position) * CFrame.fromOrientation(v51, v52, 0))

	v47.positionProps.uiGroupCameraOffSet = v54

	local v55 = b1 or false

	if v47.draggable and (v47.dragBar and not v55) then
		v47.dragBar:setCFrame(workspace.CurrentCamera.CFrame * v54:ToWorldSpace(v47.dragBarOffset))
	end

	p11:updatePanelsInUIGroupForCurHeadCFrame(p12)
end
function t1.updateUIGroupsForCurHeadCFrame(p13) -- line: 147
	for k, _ in pairs(p13.uiGroups) do
		p13:updateUIGroupForCurHeadCFrame(k)
	end
end
function t1.updatePanelForCurHeadCFrame(p14, p15) -- line: 153
	-- upvalues: SpatialUIType (copy), VRService (copy)
	local v61 = p14.uiElements[p15]

	if v61 ~= nil and (v61.panelObject ~= nil and v61.uiType ~= SpatialUIType.ScreenUI) and (v61.panelPositionProps and v61.panelPositionProps.cameraFixedPanelProp) then
		local panelPositionProps = v61.panelPositionProps
		local cameraFixedPanelProp = panelPositionProps.cameraFixedPanelProp
		local uiGroupHeadRotation = p14.uiGroups[panelPositionProps.uiGroup].positionProps.uiGroupHeadRotation
		local CurrentCameraCFrame = workspace.CurrentCamera.CFrame
		local v66 = (CurrentCameraCFrame * VRService:GetUserCFrame(Enum.UserCFrame.Head)):ToWorldSpace(uiGroupHeadRotation)
		local v67, v68, _ = v66:ToOrientation()
		local v70 = CurrentCameraCFrame:ToObjectSpace(CFrame.new(v66.Position) * CFrame.fromOrientation(v67, v68, 0))
		local v71 = if v61.uiType ~= SpatialUIType.SpatialUI and v61.uiType ~= SpatialUIType.SpatialUIRoact then if v61.uiType ~= SpatialUIType.SpatialUIPartOnly then nil else v61.panelObject else v61.panelObject.Adornee

		if v71 == nil then
			return
		end

		v71.CFrame = workspace.CurrentCamera.CFrame * v70
		v71.CFrame = v71.CFrame:ToWorldSpace(cameraFixedPanelProp.uiGroupElementOffset)
	end
end
function t1.updatePanelsInUIGroupForCurHeadCFrame(p16, p17) -- line: 175
	for k, v in pairs(p16.uiElements) do
		if v.panelPositionProps and p17 == v.panelPositionProps.uiGroup then
			p16:updatePanelForCurHeadCFrame(k)
		end
	end
end
function t1.updatePanelsForCurHeadCFrame(p18) -- line: 189
	for k, _ in pairs(p18.uiElements) do
		p18:updatePanelForCurHeadCFrame(k)
	end
end
function t1.dragUiGroupStart(p19, p20) -- line: 195
	if p19.uiGroups[p20].draggable == false then
		return
	end

	local dragBar = p19.uiGroups[p20].dragBar
	local v82 = workspace.CurrentCamera.CFrame:ToWorldSpace(p19.uiGroups[p20].positionProps.uiGroupCameraOffSet)

	dragBar:startDrag((dragBar:getCFrame():ToObjectSpace(v82)))
end
function t1.dragUiGroupEnd(p21, p22) -- line: 207
	if p21.uiGroups[p22].draggable == false then
		return
	end

	p21.uiGroups[p22].dragBar:dragEnd()
end
function t1.dragUiGroupStep(p23, p24) -- line: 215
	-- upvalues: VRService (copy)
	if p23.uiGroups[p24].draggable == false then
		return
	end

	local dragBar = p23.uiGroups[p24].dragBar
	local v88 = workspace.CurrentCamera.CFrame * VRService:GetUserCFrame(Enum.UserCFrame.Head)
	local v89 = dragBar:getCFrame()
	local vector3 = Vector3.new(v88.Position.X, v88.Position.Y - 0.6666666666666667, v88.Position.Z)
	local v91, v92, _ = (CFrame.lookAt(v89.Position, vector3) * CFrame.Angles(0, 3.141592653589793, 0)):ToEulerAnglesXYZ()
	local _, _, v96 = v89:ToEulerAnglesXYZ()
	local v97 = CFrame.new(v89.Position) * CFrame.Angles(v91, v92, v96)
	local v98, v99, _ = v97:ToOrientation()

	dragBar:setCFrame(CFrame.new(v97.Position) * CFrame.fromOrientation(v98, v99, 0))

	local v101 = dragBar:getCFrame():ToWorldSpace(dragBar.uiGroupOffSet)

	p23.uiGroups[p24].positionProps.uiGroupHeadRotation = v88:ToObjectSpace(v101)
	p23:updateUIGroupForCurHeadCFrame(p24, true)
end
function t1.setUpUiGroups(p25) -- line: 247
	-- upvalues: createUIGroupDragBar (copy), Constants (copy), v17 (copy), VRService (copy), vector2 (copy), PanelType (copy)
	local v103 = createUIGroupDragBar({
		name = "MainUIGroup",
		dragFunction = function(_, _, _, _, _) -- line: 251
			-- upvalues: p25 (copy), Constants (copy)
			p25:dragUiGroupStep(Constants.SpatialUIGroupType.MainUIGroup)
		end,
		dragStartFunction = function(_, _, _, _, _, _, _) -- line: 254
			-- upvalues: p25 (copy), Constants (copy)
			p25:dragUiGroupStart(Constants.SpatialUIGroupType.MainUIGroup)
		end,
		dragEndFunction = function(_) -- line: 257
			-- upvalues: p25 (copy), Constants (copy)
			p25:dragUiGroupEnd(Constants.SpatialUIGroupType.MainUIGroup)
		end
	})
	local t2 = {
		draggable = true,
		headScale = 1
	}
	local t3 = {
		uiGroupHeadRotation = v17
	}
	local v106 = v17
	local CurrentCameraCFrame = workspace.CurrentCamera.CFrame
	local v108 = (CurrentCameraCFrame * VRService:GetUserCFrame(Enum.UserCFrame.Head)):ToWorldSpace(v106)
	local v109, v110, _ = v108:ToOrientation()

	t3.uiGroupCameraOffSet = CurrentCameraCFrame:ToObjectSpace(CFrame.new(v108.Position) * CFrame.fromOrientation(v109, v110, 0))
	t3.defaultGroupHeadRotation = v17
	t2.positionProps = t3
	t2.uiContainerSize = vector2
	t2.dragBar = v103
	t2.dragBarOffset = CFrame.new(0, Constants.ROACT_PANEL_UIGROUP_ELEMENT_OFFSET_MAP[PanelType.BottomBar].Y - 0.075 - 0.06666666666666667, 0)
	p25.uiGroups[Constants.SpatialUIGroupType.MainUIGroup] = t2
end
function t1.step(p39) -- line: 282
	-- upvalues: VRService (copy), SpatialUIType (copy), PanelType (copy), v13 (copy)
	if not VRService.VREnabled then
		return
	end

	for k, v in pairs(p39.uiElements) do
		if v ~= nil and (v.panelObject ~= nil and v.uiType ~= SpatialUIType.ScreenUI) and k == PanelType.RobloxGui then
			local v115, v116, _ = ((if v.uiType ~= SpatialUIType.SpatialUI then v.panelObject else v.panelObject.Adornee)).CFrame:ToOrientation()
			local v118, v119, _ = (workspace.CurrentCamera.CFrame * VRService:GetUserCFrame(Enum.UserCFrame.Head)):ToOrientation()

			if math.abs(v116 - v119) > 1.7453292519943295 or math.abs(v115 - v118) > 1.7453292519943295 then
				if p39.uiGroupsOutOfViewTimeStamp then
					if os.clock() - p39.uiGroupsOutOfViewTimeStamp >= v13 then
						p39:updateUIGroupsForCurHeadCFrame()
						p39.uiGroupsOutOfViewTimeStamp = nil
					end
				else
					p39.uiGroupsOutOfViewTimeStamp = os.clock()
				end
			else
				p39.uiGroupsOutOfViewTimeStamp = nil
			end
		end
	end
end
function t1.onShowTopBarChanged(p40) -- line: 321
	-- upvalues: VRService (copy), VRHub (copy), SpatialUIType (copy)
	if not VRService.VREnabled then
		return
	end

	if VRHub.ShowTopBar then
		for _, v in pairs(p40.uiGroups) do
			if v.draggable and v.dragBar then
				v.dragBar:show()
			end
		end

		for _, v in pairs(p40.uiElements) do
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

	for _, v in pairs(p40.uiGroups) do
		if v.draggable and v.dragBar then
			v.dragBar:hide()
		end
	end

	for _, v in pairs(p40.uiElements) do
		if v.uiType == SpatialUIType.SpatialUI or v.uiType == SpatialUIType.SpatialUIRoact then
			local panelObject = v.panelObject

			panelObject.Enabled = false
			panelObject.Adornee.Parent = nil
		elseif v.uiType == SpatialUIType.SpatialUIPartOnly then
			v.panelObject.Parent = nil
		end
	end
end
function t1.updateUIGroupsForCurCamera(p41) -- line: 362
	-- upvalues: VRService (copy), SpatialUIType (copy)
	if not VRService.VREnabled then
		return
	end

	for _, v in pairs(p41.uiGroups) do
		if v.draggable then
			v.dragBar:setCFrame(workspace.CurrentCamera.CFrame * v.positionProps.uiGroupCameraOffSet:ToWorldSpace(v.dragBarOffset))
		end
	end

	for _, v in pairs(p41.uiElements) do
		if not (v ~= nil and (v.panelObject ~= nil and v.uiType ~= SpatialUIType.ScreenUI)) or not v.panelPositionProps or not v.panelPositionProps.cameraFixedPanelProp then
			continue
		end

		local panelPositionProps = v.panelPositionProps
		local cameraFixedPanelProp = panelPositionProps.cameraFixedPanelProp
		local v139 = if v.uiType ~= SpatialUIType.SpatialUI and v.uiType ~= SpatialUIType.SpatialUIRoact then if v.uiType ~= SpatialUIType.SpatialUIPartOnly then nil else v.panelObject else v.panelObject.Adornee

		if v139 == nil then
			return
		end

		v139.CFrame = workspace.CurrentCamera.CFrame * p41.uiGroups[panelPositionProps.uiGroup].positionProps.uiGroupCameraOffSet:ToWorldSpace(cameraFixedPanelProp.uiGroupElementOffset)
	end
end
function t1.onMouseTargetChanged(p42, p43) -- line: 398
	for _, v in pairs(p42.uiGroups) do
		if v.draggable then
			if v.dragBar and p43 == v.dragBar.part then
				v.dragBar:startHover()
			elseif v.dragBar and p43 ~= v.dragBar.part then
				v.dragBar:hoverEnd()
			end
		end
	end
end
function t1.rescaleUIForCurrentHeadScale(p44) -- line: 410
	-- upvalues: Utils (copy), SpatialUIType (copy)
	local HeadScale = workspace.CurrentCamera.HeadScale

	for _, v in pairs(p44.uiGroups) do
		local v148 = HeadScale / v.headScale

		v.positionProps.uiGroupHeadRotation = Utils.rescaleCFramePosition(v.positionProps.uiGroupHeadRotation, v148)
		v.positionProps.uiGroupCameraOffSet = Utils.rescaleCFramePosition(v.positionProps.uiGroupCameraOffSet, v148)
		v.positionProps.defaultGroupHeadRotation = Utils.rescaleCFramePosition(v.positionProps.defaultGroupHeadRotation, v148)

		if v.draggable then
			v.dragBarOffset = Utils.rescaleCFramePosition(v.dragBarOffset, v148)
			v.dragBar:rescale(v148)
		end

		v.headScale = HeadScale
	end

	for _, v in pairs(p44.uiElements) do
		local v151 = HeadScale / v.headScale

		if v.uiType ~= SpatialUIType.SpatialUIRoact then
			local v152 = if v.uiType ~= SpatialUIType.SpatialUI and v.uiType ~= SpatialUIType.SpatialUIRoact then if v.uiType ~= SpatialUIType.SpatialUIPartOnly then nil else v.panelObject else v.panelObject.Adornee

			if v152 ~= nil then
				v152.Size = v152.Size * v151
			end
		end

		local panelPositionProps = v.panelPositionProps

		if panelPositionProps and panelPositionProps.cameraFixedPanelProp then
			panelPositionProps.cameraFixedPanelProp.uiGroupElementOffset = Utils.rescaleCFramePosition(panelPositionProps.cameraFixedPanelProp.uiGroupElementOffset, v151)
		end

		v.headScale = HeadScale
	end
end
function t1.new() -- line: 450
	-- upvalues: t1 (copy), RunService (copy), VRHub (copy), Players (copy)
	local t4 = {
		currentMouseTarget = nil,
		uiGroupsOutOfViewTimeStamp = nil,
		uiElements = {},
		uiGroups = {}
	}

	setmetatable(t4, t1)
	t4:setUpUiGroups()
	t4:rescaleUIForCurrentHeadScale()
	t4:updateUIGroupsForCurCamera()
	RunService:BindToRenderStep("UIManagerRenderStep", Enum.RenderPriority.Last.Value, function() -- line: 465
		-- upvalues: t4 (copy)
		t4:step()
	end)
	VRHub.ShowTopBarChanged.Event:connect(function() -- line: 469
		-- upvalues: t4 (copy)
		t4:onShowTopBarChanged()
	end)

	local CurrentCamera = workspace.CurrentCamera

	CurrentCamera:GetPropertyChangedSignal("CFrame"):Connect(function() -- line: 474
		-- upvalues: t4 (copy)
		t4:updateUIGroupsForCurCamera()
	end)
	CurrentCamera:GetPropertyChangedSignal("HeadScale"):Connect(function() -- line: 478
		-- upvalues: t4 (copy)
		t4:rescaleUIForCurrentHeadScale()
		t4:updateUIGroupsForCurHeadCFrame()
	end)

	local Mouse = Players.LocalPlayer:GetMouse()

	if Mouse then
		Mouse.Move:Connect(function() -- line: 486
			-- upvalues: Players (copy), t4 (copy)
			local Mouse2 = Players.LocalPlayer:GetMouse()

			if Mouse2.Target ~= t4.currentMouseTarget then
				t4:onMouseTargetChanged(Mouse2.Target)
				t4.currentMouseTarget = Mouse2.Target
			end
		end)
	end

	return t4
end
function t1.getInstance() -- line: 499
	-- upvalues: u23 (ref), t1 (copy)
	if u23 == nil then
		u23 = t1.new()
	end

	return u23
end

return t1
