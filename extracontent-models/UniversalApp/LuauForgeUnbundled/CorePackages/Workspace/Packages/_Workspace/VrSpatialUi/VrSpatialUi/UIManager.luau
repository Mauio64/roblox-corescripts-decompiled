local Observable = require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/Observable")
local VRService = game:GetService("VRService")
local RunService = game:GetService("RunService")
local isInExperienceUIVREnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/SharedExperimentDefinition").isInExperienceUIVREnabled
local inExperienceUIVRIXP = require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/SharedExperimentDefinition").InExperienceUIVRIXP

local vrHub = if not isInExperienceUIVREnabled then require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/VrCommon").VRHub else nil

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/VrSpatialUi/Constants")
local Utils = require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/VrSpatialUi/Utils")
local panelType = Constants.PanelType
local spatialUIType = Constants.SpatialUIType
local createCompatPanel = require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/VrSpatialUi/createCompatPanel")
local createUIGroupDragBar = require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/VrSpatialUi/createUIGroupDragBar")
require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/VrSpatialUi/DragBar")
local v5, v6

if isInExperienceUIVREnabled then
	v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/VrSpatialUi/UIGroupHelper")
	v6 = require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/VrSpatialUi/StableCameraCache")
else
	v5 = nil
	v6 = nil
end

local Players = game:GetService("Players")
local defineFastInt = game:DefineFastInt("FIntUIResetDelayInSec", 3)
local defineFastInt2 = game:DefineFastInt("SpatialUIPanelDistance", 64)
local defineFastFlag = game:DefineFastFlag("SpatialUIEnablePanelsRefocusing", false)
local defineFastFlag2 = game:DefineFastFlag("SpatialUIDisableBottomBarFading", false)

local defineFastFlag3 = game:DefineFastFlag("SpatialUIDisableBottomBarInteractionOnAnimating", false)
local defineFastFlag4 = game:DefineFastFlag("VRSpatialUIGuardNilHeadScale", false)
local cframe

if isInExperienceUIVREnabled then
	cframe = CFrame.Angles(0, 0, 0)
else
	cframe = CFrame.Angles(-0.3141592653589793, 0.17453292519943295, 0)
end

local cframe2

if isInExperienceUIVREnabled then
	local v7 = math.min(math.max(defineFastInt2, 0), 500) / 100
	cframe2 = CFrame.new(0, 0, v7 * -1 * (10 / 3))
else
	cframe2 = CFrame.new(-0.46666666666666673, -0.8, -32 / 15)
end

local vector2 = Vector2.new(2.666666666666667, 1.866666666666667)

local v7 = cframe2 * cframe

local function getZAxisStablizedCFrame(cframe3)
	local orientation, v8, v9 = cframe3:ToOrientation()
	return CFrame.new(cframe3.Position) * CFrame.fromOrientation(orientation, v8, 0)
end

local function getCameraOffsetFromHeadRotationWithZAxisStabl(p2, p3)
	local cframe3 = p3 or workspace.CurrentCamera.CFrame
	local cframe4 = (cframe3 * VRService:GetUserCFrame(Enum.UserCFrame.Head)):ToWorldSpace(p2)
	local orientation, v8, v9 = cframe4:ToOrientation()
	return cframe3:ToObjectSpace(CFrame.new(cframe4.Position) * CFrame.fromOrientation(orientation, v8, 0))
end

local function getPanelPart(p2)
	if p2.uiType == spatialUIType.SpatialUI or p2.uiType == spatialUIType.SpatialUIRoact then
		return p2.panelObject.Adornee
	end

	if p2.uiType == spatialUIType.SpatialUIPartOnly then
		return p2.panelObject
	end

	return nil
end

local function panelExistsInSpace(p2): boolean
	return p2 ~= nil and p2.panelObject ~= nil and p2.uiType ~= spatialUIType.ScreenUI
end

function LUAUFORGE_MODULE_GLOBALS_dnj_createUIGroup(data, p2, p3)
	local uiGroupHelper = data.uiGroupHelper
	local v9 = {
		uiGroupHeadRotation = v7,
		uiGroupCameraOffSet = 0,
		defaultGroupHeadRotation = 0
	}
	local cframe3 = workspace.CurrentCamera.CFrame
	local cframe4 = (cframe3 * VRService:GetUserCFrame(Enum.UserCFrame.Head)):ToWorldSpace(v7)
	local orientation, v11, v12 = cframe4:ToOrientation()
	v9.uiGroupCameraOffSet = cframe3:ToObjectSpace(CFrame.new(cframe4.Position) * CFrame.fromOrientation(orientation, v11, 0))
	v9.defaultGroupHeadRotation = v7
	local uiGroup = uiGroupHelper:createUIGroup(data, p2, vector2, v9, data.uiElements, p3)
	data.uiGroups[p2] = uiGroup
end

local class = {}

local instance = nil

class.__index = class

function class:removeRoactPanel(p2)
	if isInExperienceUIVREnabled then
		self:disconnectPanelVisibility(p2)
	end

	self.uiElements[p2] = nil
end

function class:registerRoactPanel(p2, p3, p4)
	self.uiElements[p2] = p3

	if isInExperienceUIVREnabled then
		local v8 = self.uiGroupHelper:checkAndGetUIGroupTypeForTempPanel(p2, self.uiElements)

		if v8 == nil then
			self:rescaleUIForCurrentHeadScale()
			self:updateUIGroupsForCurHeadCFrame()
		else
			self:rescaleUIForCurrentHeadScale(v8, p2)

			if inExperienceUIVRIXP:isSpatialUICameraTypeFixEnabled() then
				self:updateUIGroupsForCurCamera(p2, self.stableCameraCache:getCurrentStableCameraCFrame())
			else
				self:updateUIGroupsForCurCamera(p2)
			end
		end
	else
		self:rescaleUIForCurrentHeadScale()
		self:updateUIGroupsForCurHeadCFrame()
	end

	if isInExperienceUIVREnabled then
		self:connectPanelVisibility(p2, p4 or Observable.ObservableValue.new(true))

		if p3.keepVisibleWhenTopBarHidden ~= nil then
			self.uiGroupHelper:updateAllElements(self.uiElements, self.uiGroups)
		end
	end
end

function class:createUI(p2)
	local v8 = createCompatPanel(p2)

	if v8 == nil then
		return nil
	end

	self.uiElements[p2.panelType] = v8
	self:updatePanelForCurHeadCFrame(p2.panelType)
	return { type = v8.uiType, panelObject = v8.panelObject }
end

function class:getPanelObject(p3)
	local uiElement = self.uiElements[p3]

	if uiElement then
		return uiElement.panelObject
	end

	return nil
end

function class:getPanelSizeInPixel(p2)
	return self:getScaledPartSizeInPixel(p2) * Constants.VR_PANEL_RESOLUTION_MULTIPLIER
end

function class:getScaledPartSizeInPixel(p3)
	if p3 == panelType.BottomBar then
		return Constants.BOTTOM_BAR_SIZE
	end

	local spatialPanelProps = Constants.COMPAT_PANEL_PROPS_MAP[p3].spatialPanelProps

	if not spatialPanelProps then
		return Vector2.new(0, 0)
	end

	local partSize = spatialPanelProps.partSize
	return Vector2.new(partSize.X, partSize.Y)
end

function class.connectTopBarVisibility(data, p2)
	data.uiGroupHelper:setTopBarVisible(p2, function()
		data.uiGroupHelper:updateAllElements(data.uiElements, data.uiGroups)
	end)
end

function class:connectPanelVisibility(p2, p3)
	self.uiGroupHelper:connectPanelVisibility(p2, p3, self.uiElements, self.uiGroups)
end

function class:disconnectPanelVisibility(p2)
	self.uiGroupHelper:disconnectPanelVisibility(p2, self.uiElements, self.uiGroups)
end

function class:updateUIGroupForCurHeadCFrame(p2, p3)
	local uiGroup = self.uiGroups[p2]

	local uiGroupHeadRotation = uiGroup.positionProps.uiGroupHeadRotation
	local cframe3 = workspace.CurrentCamera.CFrame
	local cframe4 = (cframe3 * VRService:GetUserCFrame(Enum.UserCFrame.Head)):ToWorldSpace(uiGroupHeadRotation)
	local orientation, v8, v9 = cframe4:ToOrientation()
	local cframe5 = cframe3:ToObjectSpace(CFrame.new(cframe4.Position) * CFrame.fromOrientation(orientation, v8, 0))

	uiGroup.positionProps.uiGroupCameraOffSet = cframe5

	if uiGroup.draggable and uiGroup.dragBar and not p3 then
		uiGroup.dragBar:setCFrame(workspace.CurrentCamera.CFrame * cframe5:ToWorldSpace(uiGroup.dragBarOffset))
	end

	self:updatePanelsInUIGroupForCurHeadCFrame(p2)
end

function class:updateUIGroupsForCurHeadCFrame()
	for k, uiGroup in pairs(self.uiGroups) do
		self:updateUIGroupForCurHeadCFrame(k)
	end
end

function class:updatePanelForCurHeadCFrame(p3)
	local uiElement = self.uiElements[p3]
	local v8

	if uiElement == nil or uiElement.panelObject == nil then
		v8 = false
	else
		v8 = uiElement.uiType ~= spatialUIType.ScreenUI
	end

	if v8 and uiElement.panelPositionProps and uiElement.panelPositionProps.cameraFixedPanelProp then
		local panelPositionProps = uiElement.panelPositionProps
		local cameraFixedPanelProp = panelPositionProps.cameraFixedPanelProp

		local uiGroupHeadRotation = self.uiGroups[panelPositionProps.uiGroup].positionProps.uiGroupHeadRotation
		local cframe3 = workspace.CurrentCamera.CFrame
		local cframe4 = (cframe3 * VRService:GetUserCFrame(Enum.UserCFrame.Head)):ToWorldSpace(uiGroupHeadRotation)
		local orientation, v9, v10 = cframe4:ToOrientation()
		local objectSpace = cframe3:ToObjectSpace(CFrame.new(cframe4.Position) * CFrame.fromOrientation(orientation, v9, 0))
		local v11

		if
			uiElement.uiType == spatialUIType.SpatialUI
			or uiElement.uiType == spatialUIType.SpatialUIRoact
		then
			v11 = uiElement.panelObject.Adornee
		elseif uiElement.uiType == spatialUIType.SpatialUIPartOnly then
			v11 = uiElement.panelObject
		end

		if v11 == nil then
			return
		end

		v11.CFrame = workspace.CurrentCamera.CFrame * objectSpace
		v11.CFrame = v11.CFrame:ToWorldSpace(cameraFixedPanelProp.uiGroupElementOffset)
	end
end

function class:updatePanelsInUIGroupForCurHeadCFrame(p2)
	for k, uiElement in pairs(self.uiElements) do
		if uiElement.panelPositionProps and uiElement.panelPositionProps.uiGroup == p2 then
			self:updatePanelForCurHeadCFrame(k)
		end
	end
end

function class:updatePanelsForCurHeadCFrame()
	for k, uiElement in pairs(self.uiElements) do
		self:updatePanelForCurHeadCFrame(k)
	end
end

function class:dragUiGroupStart(p3)
	if self.uiGroups[p3].draggable == false then
		return
	end

	local dragBar = self.uiGroups[p3].dragBar
	local worldSpace = workspace.CurrentCamera.CFrame:ToWorldSpace(self.uiGroups[p3].positionProps.uiGroupCameraOffSet)

	dragBar:startDrag((dragBar:getCFrame():ToObjectSpace(worldSpace)))
end

function class:dragUiGroupEnd(p3)
	if self.uiGroups[p3].draggable == false then
		return
	end

	self.uiGroups[p3].dragBar:dragEnd()
end

function class:dragUiGroupStep(p2)
	if self.uiGroups[p2].draggable == false then
		return
	end

	local dragBar = self.uiGroups[p2].dragBar

	local cframe3 = workspace.CurrentCamera.CFrame * VRService:GetUserCFrame(Enum.UserCFrame.Head)

	local cframe4 = dragBar:getCFrame()

	local vector3 = Vector3.new(
		cframe3.Position.X,
		cframe3.Position.Y - 0.6666666666666667,
		cframe3.Position.Z
	)
	local eulerAnglesXYZ, v8, v9 = (CFrame.lookAt(cframe4.Position, vector3) * CFrame.Angles(0, 3.141592653589793, 0)):ToEulerAnglesXYZ()
	local eulerAnglesXYZ2, v10, v11 = cframe4:ToEulerAnglesXYZ()

	local cframe5 = CFrame.new(cframe4.Position) * CFrame.Angles(eulerAnglesXYZ, v8, v11)
	local orientation, v12, v13 = cframe5:ToOrientation()
	dragBar:setCFrame(CFrame.new(cframe5.Position) * CFrame.fromOrientation(orientation, v12, 0))

	local worldSpace = dragBar:getCFrame():ToWorldSpace(dragBar.uiGroupOffSet)
	self.uiGroups[p2].positionProps.uiGroupHeadRotation = cframe3:ToObjectSpace(worldSpace)
	self:updateUIGroupForCurHeadCFrame(p2, true)
end

function class:setUpUiGroups(p2)
	if isInExperienceUIVREnabled then
		LUAUFORGE_MODULE_GLOBALS_dnj_createUIGroup(self, Constants.SpatialUIGroupType.MainUIGroup, p2)
		LUAUFORGE_MODULE_GLOBALS_dnj_createUIGroup(self, Constants.SpatialUIGroupType.MenuUIGroup, p2)
		LUAUFORGE_MODULE_GLOBALS_dnj_createUIGroup(self, Constants.SpatialUIGroupType.ChatUIGroup, p2)
		LUAUFORGE_MODULE_GLOBALS_dnj_createUIGroup(
			self,
			Constants.SpatialUIGroupType.ChromeSubMenuUIGroup,
			p2
		)
		self.uiGroupHelper:updateAllDragBar(self.uiElements, self.uiGroups)
	else
		local v8 = createUIGroupDragBar({
			name = "MainUIGroup",
			dragFunction = function(p3, p4, p5, p6, p7)
				self:dragUiGroupStep(Constants.SpatialUIGroupType.MainUIGroup)
			end,
			dragStartFunction = function(p3, p4, p5, p6, p7, p8, p9)
				self:dragUiGroupStart(Constants.SpatialUIGroupType.MainUIGroup)
			end,
			dragEndFunction = function(p3)
				self:dragUiGroupEnd(Constants.SpatialUIGroupType.MainUIGroup)
			end
		})

		local v10 = {
			uiGroupHeadRotation = v7,
			uiGroupCameraOffSet = 0,
			defaultGroupHeadRotation = 0
		}
		local cframe3 = workspace.CurrentCamera.CFrame
		local cframe4 = (cframe3 * VRService:GetUserCFrame(Enum.UserCFrame.Head)):ToWorldSpace(v7)
		local orientation, v12, v13 = cframe4:ToOrientation()
		v10.uiGroupCameraOffSet = cframe3:ToObjectSpace(CFrame.new(cframe4.Position) * CFrame.fromOrientation(orientation, v12, 0))
		v10.defaultGroupHeadRotation = v7
		local v9 = {
			positionProps = v10,
			uiContainerSize = vector2,
			draggable = true,
			dragBar = v8,
			dragBarOffset = CFrame.new(
				0,
				Constants.ROACT_PANEL_UIGROUP_ELEMENT_OFFSET_MAP[panelType.BottomBar].Y - 0.075 - 1 / 15,
				0
			),
			headScale = 1
		}

		self.uiGroups[Constants.SpatialUIGroupType.MainUIGroup] = v9
	end
end

function class:step()
	if not VRService.VREnabled then
		return
	end

	for k, uiElement in pairs(self.uiElements) do
		local v8

		if uiElement == nil or uiElement.panelObject == nil then
			v8 = false
		else
			v8 = uiElement.uiType ~= spatialUIType.ScreenUI
		end

		if not (v8 and k == panelType.RobloxGui) then
			continue
		end

		local v9

		if uiElement.uiType == spatialUIType.SpatialUI then
			v9 = uiElement.panelObject.Adornee
		else
			v9 = uiElement.panelObject
		end

		local orientation, v10, v11 = v9.CFrame:ToOrientation()
		local orientation2, v12, v13 = (workspace.CurrentCamera.CFrame * VRService:GetUserCFrame(Enum.UserCFrame.Head)):ToOrientation()

		if isInExperienceUIVREnabled and not defineFastFlag2 and self.uiGroupHelper then
			self.uiGroupHelper:animateBottomBarOnHeadMoveIfNeeded(
				self.uiElements,
				Vector2.new(orientation, v10),
				Vector2.new(orientation2, v12)
			)
		end

		if
			isInExperienceUIVREnabled
			and defineFastFlag
			and (math.abs(v10 - v12) > 1.7453292519943295 or math.abs(orientation - orientation2) > 1.7453292519943295)
		then
			if self.uiGroupsOutOfViewTimeStamp then
				if defineFastInt <= os.clock() - self.uiGroupsOutOfViewTimeStamp then
					self:updateUIGroupsForCurHeadCFrame()
					self.uiGroupsOutOfViewTimeStamp = nil
				end
			else
				self.uiGroupsOutOfViewTimeStamp = os.clock()
			end
		else
			self.uiGroupsOutOfViewTimeStamp = nil
		end
	end
end

function class:prepareGuiToggleAnimationState()
	if self.uiGroupHelper:isTopBarVisible() then
		self.uiGroupHelper:prepareGuiToggleAnimationState(self.uiElements)
	end
end

function class:onShowTopBarChanged()
	if isInExperienceUIVREnabled or not VRService.VREnabled then
		return
	end

	if vrHub and vrHub.ShowTopBar then
		for k, uiGroup in pairs(self.uiGroups) do
			if uiGroup.draggable and uiGroup.dragBar then
				uiGroup.dragBar:show()
			end
		end

		for k, uiElement in pairs(self.uiElements) do
			if
				uiElement.uiType == spatialUIType.SpatialUI
				or uiElement.uiType == spatialUIType.SpatialUIRoact
			then
				local panelObject = uiElement.panelObject
				panelObject.Enabled = true
				panelObject.Adornee.Parent = workspace
			elseif uiElement.uiType == spatialUIType.SpatialUIPartOnly then
				uiElement.panelObject.Parent = workspace
			end
		end
	else
		for k, uiGroup in pairs(self.uiGroups) do
			if uiGroup.draggable and uiGroup.dragBar then
				uiGroup.dragBar:hide()
			end
		end

		for k, uiElement in pairs(self.uiElements) do
			if
				uiElement.uiType == spatialUIType.SpatialUI
				or uiElement.uiType == spatialUIType.SpatialUIRoact
			then
				local panelObject = uiElement.panelObject
				panelObject.Enabled = false
				panelObject.Adornee.Parent = nil
			elseif uiElement.uiType == spatialUIType.SpatialUIPartOnly then
				uiElement.panelObject.Parent = nil
			end
		end
	end
end

function class:updateUIGroupsForCurCamera(p2, p3)
	if not VRService.VREnabled then
		return
	end

	for k, uiGroup in pairs(self.uiGroups) do
		if p2 == nil and uiGroup.draggable then
			uiGroup.dragBar:setCFrame((p3 or workspace.CurrentCamera.CFrame) * uiGroup.positionProps.uiGroupCameraOffSet:ToWorldSpace(uiGroup.dragBarOffset))
		end
	end

	for k, uiElement in pairs(self.uiElements) do
		if not (p2 == nil or p2 == k) then
			continue
		end

		local v8

		if uiElement == nil or uiElement.panelObject == nil then
			v8 = false
		else
			v8 = uiElement.uiType ~= spatialUIType.ScreenUI
		end

		if not (v8 and uiElement.panelPositionProps and uiElement.panelPositionProps.cameraFixedPanelProp) then
			continue
		end

		local panelPositionProps = uiElement.panelPositionProps
		local cameraFixedPanelProp = panelPositionProps.cameraFixedPanelProp
		local v9

		if
			uiElement.uiType == spatialUIType.SpatialUI
			or uiElement.uiType == spatialUIType.SpatialUIRoact
		then
			v9 = uiElement.panelObject.Adornee
		elseif uiElement.uiType == spatialUIType.SpatialUIPartOnly then
			v9 = uiElement.panelObject
		end

		if v9 == nil then
			break
		end

		local v10 = p3 or workspace.CurrentCamera.CFrame

		if isInExperienceUIVREnabled and not inExperienceUIVRIXP:isSpatialUICameraTypeFixEnabled() then
			v10 = self.uiGroupHelper:getGroupCameraCFrameIfPossible(k, self.uiElements)
		end

		v9.CFrame = v10 * self.uiGroups[panelPositionProps.uiGroup].positionProps.uiGroupCameraOffSet:ToWorldSpace(cameraFixedPanelProp.uiGroupElementOffset)
	end
end

function class:onMouseTargetChanged(p3)
	for k, uiGroup in pairs(self.uiGroups) do
		if not uiGroup.draggable then
			continue
		end

		if uiGroup.dragBar and uiGroup.dragBar.part == p3 then
			uiGroup.dragBar:startHover()
		elseif uiGroup.dragBar and uiGroup.dragBar.part ~= p3 then
			uiGroup.dragBar:hoverEnd()
		end
	end
end

function class:resetDragAndDrop()
	for k, uiGroup in pairs(self.uiGroups) do
		if uiGroup.draggable and uiGroup.dragBar then
			uiGroup.dragBar:hide()
		end
	end

	self:setUpUiGroups(true)
	self:rescaleUIForCurrentHeadScale()
	self:updateUIGroupsForCurCamera()
end

function class:getAdditionalCameraScaleIfNeeded()
	if VRService.VREnabled then
		return workspace.CurrentCamera.HeadScale
	end

	return 1
end

function class:rescaleUIForCurrentHeadScale(p2, p3)
	local v8

	if isInExperienceUIVREnabled then
		v8 = self:getAdditionalCameraScaleIfNeeded()
	else
		v8 = workspace.CurrentCamera.HeadScale
	end

	for k, uiGroup in pairs(self.uiGroups) do
		if p2 ~= nil then
			continue
		end

		local v9 = if defineFastFlag4 then uiGroup.headScale or v8 else uiGroup.headScale
		local v10 = v8 / v9

		uiGroup.positionProps.uiGroupHeadRotation = Utils.rescaleCFramePosition(
			uiGroup.positionProps.uiGroupHeadRotation,
			v10
		)
		uiGroup.positionProps.uiGroupCameraOffSet = Utils.rescaleCFramePosition(
			uiGroup.positionProps.uiGroupCameraOffSet,
			v10
		)
		uiGroup.positionProps.defaultGroupHeadRotation = Utils.rescaleCFramePosition(
			uiGroup.positionProps.defaultGroupHeadRotation,
			v10
		)

		if uiGroup.draggable then
			uiGroup.dragBarOffset = Utils.rescaleCFramePosition(uiGroup.dragBarOffset, v10)
			uiGroup.dragBar:rescale(v10)
		end

		uiGroup.headScale = v8

		if isInExperienceUIVREnabled then
			uiGroup.lastCameraCFrame = workspace.CurrentCamera.CFrame
		end
	end

	for k, uiElement in pairs(self.uiElements) do
		if not (p3 == nil or p3 == k) then
			continue
		end

		local v9 = if defineFastFlag4 then uiElement.headScale or v8 else uiElement.headScale
		local v10 = v8 / v9

		if uiElement.uiType ~= spatialUIType.SpatialUIRoact then
			local v11

			if
				uiElement.uiType == spatialUIType.SpatialUI
				or uiElement.uiType == spatialUIType.SpatialUIRoact
			then
				v11 = uiElement.panelObject.Adornee
			elseif uiElement.uiType == spatialUIType.SpatialUIPartOnly then
				v11 = uiElement.panelObject
			end

			if v11 ~= nil then
				v11.Size *= v10
			end
		end

		local panelPositionProps = uiElement.panelPositionProps

		if panelPositionProps and panelPositionProps.cameraFixedPanelProp then
			panelPositionProps.cameraFixedPanelProp.uiGroupElementOffset = Utils.rescaleCFramePosition(
				panelPositionProps.cameraFixedPanelProp.uiGroupElementOffset,
				v10
			)
		end

		uiElement.headScale = v8
	end
end

function class.new()
	local v8 = {
		currentMouseTarget = nil,
		uiGroupsOutOfViewTimeStamp = nil,
		uiElements = {},
		uiGroups = {},
		uiGroupHelper = {},
		stableCameraCache = {}
	}

	if isInExperienceUIVREnabled then
		v8.uiGroupHelper = v5.new(false)
		v8.stableCameraCache = v6.new()
	end

	setmetatable(v8, class)

	v8:setUpUiGroups()
	v8:rescaleUIForCurrentHeadScale()
	v8:updateUIGroupsForCurCamera()

	RunService:BindToRenderStep("UIManagerRenderStep", Enum.RenderPriority.Last.Value, function()
		v8:step()
	end)

	if not isInExperienceUIVREnabled and vrHub then
		vrHub.ShowTopBarChanged.Event:connect(function()
			v8:onShowTopBarChanged()
		end)
	end

	local currentCamera = workspace.CurrentCamera
	currentCamera:GetPropertyChangedSignal("CFrame"):Connect(function()
		if isInExperienceUIVREnabled and inExperienceUIVRIXP:isSpatialUICameraTypeFixEnabled() then
			if v8.stableCameraCache:updateAndCheckCameraMoved() then
				v8:updateUIGroupsForCurCamera(nil, v8.stableCameraCache:getCurrentStableCameraCFrame())
			end
		else
			v8:updateUIGroupsForCurCamera()
		end
	end)

	currentCamera:GetPropertyChangedSignal("HeadScale"):Connect(function()
		v8:rescaleUIForCurrentHeadScale()
		v8:updateUIGroupsForCurHeadCFrame()
	end)

	local mouse = Players.LocalPlayer:GetMouse()

	if mouse then
		mouse.Move:Connect(function()
			local mouse2 = Players.LocalPlayer:GetMouse()

			if mouse2.Target ~= v8.currentMouseTarget then
				v8:onMouseTargetChanged(mouse2.Target)
				v8.currentMouseTarget = mouse2.Target
			end
		end)
	end

	return v8
end

function class:getBottomBarVisibility()
	if defineFastFlag3 then
		return nil
	end

	return self.uiGroupHelper:getBottomBarVisibility()
end

function class.isBottomBarInteractionOnAnimationSupported(p2)
	if defineFastFlag3 then
		return false
	end

	return p2.uiGroupHelper:getBottomBarVisibility():get()
end

function class.getInstance()
	if instance == nil then
		instance = class.new()
	end

	return instance
end

return class
