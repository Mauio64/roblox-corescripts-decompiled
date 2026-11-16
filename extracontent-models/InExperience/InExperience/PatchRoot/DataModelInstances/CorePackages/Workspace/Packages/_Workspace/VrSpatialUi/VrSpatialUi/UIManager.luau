local VrSpatialUi = script:FindFirstAncestor("VrSpatialUi")
local parent = VrSpatialUi.Parent
local Observable = require(parent.Observable)
local VRService = game:GetService("VRService")
local RunService = game:GetService("RunService")
local SharedExperimentDefinition = require(parent.SharedExperimentDefinition)
local isInExperienceUIVREnabled = SharedExperimentDefinition.isInExperienceUIVREnabled
local SharedExperimentDefinition2 = require(parent.SharedExperimentDefinition)
local InExperienceUIVRIXP = SharedExperimentDefinition2.InExperienceUIVRIXP
local vrHub

if isInExperienceUIVREnabled then
	vrHub = nil
else
	local VrCommon = require(parent.VrCommon)
	vrHub = VrCommon.VRHub
end

local Constants = require(VrSpatialUi.Constants)
local Utils = require(VrSpatialUi.Utils)
local PanelType = Constants.PanelType
local SpatialUIType = Constants.SpatialUIType
local createCompatPanel = require(script.Parent.createCompatPanel)
local createUIGroupDragBar = require(script.Parent.createUIGroupDragBar)
require(VrSpatialUi.DragBar)
local UIGroupHelper, StableCameraCache

if isInExperienceUIVREnabled then
	UIGroupHelper = require(VrSpatialUi.UIGroupHelper)
	StableCameraCache = require(VrSpatialUi.StableCameraCache)
else
	UIGroupHelper = nil
	StableCameraCache = nil
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
	local v = math.min(math.max(defineFastInt2, 0), 500) / 100
	cframe2 = CFrame.new(0, 0, v * -1 * (10 / 3))
else
	cframe2 = CFrame.new(-0.46666666666666673, -0.8, -32 / 15)
end

local vector2 = Vector2.new(2.666666666666667, 1.866666666666667)

local v = cframe2 * cframe

local function getZAxisStablizedCFrame(cframe3: CFrame) -- 2 equivalent calls inferred from this helper
	local orientation, v2, _ = cframe3:ToOrientation()
	return CFrame.new(cframe3.Position) * CFrame.fromOrientation(orientation, v2, 0)
end

local function getCameraOffsetFromHeadRotationWithZAxisStabl(p, cframe3: CFrame?) -- 4 equivalent calls inferred from this helper
	local cframe4 = cframe3 or workspace.CurrentCamera.CFrame
	return cframe4:ToObjectSpace(getZAxisStablizedCFrame((cframe4 * VRService:GetUserCFrame(Enum.UserCFrame.Head)):ToWorldSpace(p))) -- inferred equivalent call
end

local function getPanelPart(uiElement) -- 3 equivalent calls inferred from this helper
	if uiElement.uiType == SpatialUIType.SpatialUI or uiElement.uiType == SpatialUIType.SpatialUIRoact then
		return uiElement.panelObject.Adornee
	end

	if uiElement.uiType == SpatialUIType.SpatialUIPartOnly then
		return uiElement.panelObject
	end

	return nil
end

local function panelExistsInSpace(uiElement): boolean -- 3 equivalent calls inferred from this helper
	return uiElement ~= nil and uiElement.panelObject ~= nil and uiElement.uiType ~= SpatialUIType.ScreenUI
end

function createUIGroup(data, p, flag: boolean?)
	local uiGroup = data.uiGroupHelper:createUIGroup(
		data,
		p,
		vector2,
		{
			uiGroupHeadRotation = v,
			uiGroupCameraOffSet = getCameraOffsetFromHeadRotationWithZAxisStabl(v), -- inferred equivalent call
			defaultGroupHeadRotation = v
		},
		data.uiElements,
		flag
	)
	data.uiGroups[p] = uiGroup
end

local UIManager = {}

local instance = nil

UIManager.__index = UIManager

function UIManager:removeRoactPanel(p)
	if isInExperienceUIVREnabled then
		self:disconnectPanelVisibility(p)
	end

	self.uiElements[p] = nil
end

function UIManager:registerRoactPanel(p, p2, p3)
	self.uiElements[p] = p2

	if isInExperienceUIVREnabled then
		local v2 = self.uiGroupHelper:checkAndGetUIGroupTypeForTempPanel(p, self.uiElements)

		if v2 == nil then
			self:rescaleUIForCurrentHeadScale()
			self:updateUIGroupsForCurHeadCFrame()
		else
			self:rescaleUIForCurrentHeadScale(v2, p)

			if InExperienceUIVRIXP:isSpatialUICameraTypeFixEnabled() then
				self:updateUIGroupsForCurCamera(p, (self.stableCameraCache:getCurrentStableCameraCFrame()))
			else
				self:updateUIGroupsForCurCamera(p)
			end
		end
	else
		self:rescaleUIForCurrentHeadScale()
		self:updateUIGroupsForCurHeadCFrame()
	end

	if isInExperienceUIVREnabled then
		self:connectPanelVisibility(p, p3 or Observable.ObservableValue.new(true))

		if p2.keepVisibleWhenTopBarHidden ~= nil then
			self.uiGroupHelper:updateAllElements(self.uiElements, self.uiGroups)
		end
	end
end

function UIManager:createUI(p)
	local compatPanel = createCompatPanel(p)

	if compatPanel == nil then
		return nil
	end

	self.uiElements[p.panelType] = compatPanel
	self:updatePanelForCurHeadCFrame(p.panelType)
	return { type = compatPanel.uiType, panelObject = compatPanel.panelObject }
end

function UIManager.getPanelObject(p, p2)
	local uiElement = p.uiElements[p2]

	return if uiElement then uiElement.panelObject else nil
end

function UIManager:getPanelSizeInPixel(p)
	return self:getScaledPartSizeInPixel(p) * Constants.VR_PANEL_RESOLUTION_MULTIPLIER
end

function UIManager:getScaledPartSizeInPixel(p)
	if p == PanelType.BottomBar then
		return Constants.BOTTOM_BAR_SIZE
	end

	local spatialPanelProps = Constants.COMPAT_PANEL_PROPS_MAP[p].spatialPanelProps

	if not spatialPanelProps then
		return Vector2.new(0, 0)
	end

	local partSize = spatialPanelProps.partSize
	return Vector2.new(partSize.X, partSize.Y)
end

function UIManager.connectTopBarVisibility(data, p)
	data.uiGroupHelper:setTopBarVisible(p, function()
		data.uiGroupHelper:updateAllElements(data.uiElements, data.uiGroups)
	end)
end

function UIManager:connectPanelVisibility(p, p2)
	self.uiGroupHelper:connectPanelVisibility(p, p2, self.uiElements, self.uiGroups)
end

function UIManager:disconnectPanelVisibility(p)
	self.uiGroupHelper:disconnectPanelVisibility(p, self.uiElements, self.uiGroups)
end

function UIManager:updateUIGroupForCurHeadCFrame(p, flag: boolean?)
	local uiGroup = self.uiGroups[p]

	local cameraOffsetFromHeadRotationWithZAxisStabl = getCameraOffsetFromHeadRotationWithZAxisStabl(uiGroup.positionProps.uiGroupHeadRotation) -- inferred equivalent call
	uiGroup.positionProps.uiGroupCameraOffSet = cameraOffsetFromHeadRotationWithZAxisStabl

	if uiGroup.draggable and uiGroup.dragBar and not flag then
		uiGroup.dragBar:setCFrame(workspace.CurrentCamera.CFrame * cameraOffsetFromHeadRotationWithZAxisStabl:ToWorldSpace(uiGroup.dragBarOffset))
	end

	self:updatePanelsInUIGroupForCurHeadCFrame(p)
end

function UIManager:updateUIGroupsForCurHeadCFrame()
	for k, _ in pairs(self.uiGroups) do
		self:updateUIGroupForCurHeadCFrame(k)
	end
end

function UIManager:updatePanelForCurHeadCFrame(p)
	local uiElement = self.uiElements[p]

	if
		panelExistsInSpace(uiElement) -- inferred equivalent call
		and uiElement.panelPositionProps
		and uiElement.panelPositionProps.cameraFixedPanelProp
	then
		local panelPositionProps = uiElement.panelPositionProps
		local cameraFixedPanelProp = panelPositionProps.cameraFixedPanelProp

		local cameraOffsetFromHeadRotationWithZAxisStabl = getCameraOffsetFromHeadRotationWithZAxisStabl(self.uiGroups[panelPositionProps.uiGroup].positionProps.uiGroupHeadRotation) -- inferred equivalent call
		local panelPart = getPanelPart(uiElement) -- inferred equivalent call

		if panelPart == nil then
			return
		end

		panelPart.CFrame = workspace.CurrentCamera.CFrame * cameraOffsetFromHeadRotationWithZAxisStabl
		panelPart.CFrame = panelPart.CFrame:ToWorldSpace(cameraFixedPanelProp.uiGroupElementOffset)
	end
end

function UIManager:updatePanelsInUIGroupForCurHeadCFrame(p)
	for k, uiElement in pairs(self.uiElements) do
		if uiElement.panelPositionProps and uiElement.panelPositionProps.uiGroup == p then
			self:updatePanelForCurHeadCFrame(k)
		end
	end
end

function UIManager:updatePanelsForCurHeadCFrame()
	for k, _ in pairs(self.uiElements) do
		self:updatePanelForCurHeadCFrame(k)
	end
end

function UIManager:dragUiGroupStart(p)
	if self.uiGroups[p].draggable == false then
		return
	end

	local dragBar = self.uiGroups[p].dragBar
	local worldSpace = workspace.CurrentCamera.CFrame:ToWorldSpace(self.uiGroups[p].positionProps.uiGroupCameraOffSet)

	dragBar:startDrag((dragBar:getCFrame():ToObjectSpace(worldSpace)))
end

function UIManager:dragUiGroupEnd(p)
	if self.uiGroups[p].draggable == false then
		return
	end

	self.uiGroups[p].dragBar:dragEnd()
end

function UIManager:dragUiGroupStep(p)
	if self.uiGroups[p].draggable == false then
		return
	end

	local dragBar = self.uiGroups[p].dragBar

	local cframe3 = workspace.CurrentCamera.CFrame * VRService:GetUserCFrame(Enum.UserCFrame.Head)

	local cframe4 = dragBar:getCFrame()

	local vector3 = Vector3.new(cframe3.Position.X, cframe3.Position.Y - 0.6666666666666667, cframe3.Position.Z)
	local eulerAnglesXYZ, v2, _ = (CFrame.lookAt(cframe4.Position, vector3) * CFrame.Angles(0, 3.141592653589793, 0)):ToEulerAnglesXYZ()
	local _, _, v3 = cframe4:ToEulerAnglesXYZ()
	dragBar:setCFrame(getZAxisStablizedCFrame(CFrame.new(cframe4.Position) * CFrame.Angles(eulerAnglesXYZ, v2, v3))) -- inferred equivalent call

	local worldSpace = dragBar:getCFrame():ToWorldSpace(dragBar.uiGroupOffSet)
	self.uiGroups[p].positionProps.uiGroupHeadRotation = cframe3:ToObjectSpace(worldSpace)
	self:updateUIGroupForCurHeadCFrame(p, true)
end

function UIManager:setUpUiGroups(flag: boolean?)
	if isInExperienceUIVREnabled then
		createUIGroup(self, Constants.SpatialUIGroupType.MainUIGroup, flag)
		createUIGroup(self, Constants.SpatialUIGroupType.MenuUIGroup, flag)
		createUIGroup(self, Constants.SpatialUIGroupType.ChatUIGroup, flag)
		createUIGroup(self, Constants.SpatialUIGroupType.ChromeSubMenuUIGroup, flag)
		self.uiGroupHelper:updateAllDragBar(self.uiElements, self.uiGroups)
	else
		local uiGroupDragBar = createUIGroupDragBar({
			name = "MainUIGroup",
			dragFunction = function(_, _, _, _, _)
				self:dragUiGroupStep(Constants.SpatialUIGroupType.MainUIGroup)
			end,
			dragStartFunction = function(_, _, _, _, _, _, _)
				self:dragUiGroupStart(Constants.SpatialUIGroupType.MainUIGroup)
			end,
			dragEndFunction = function(_)
				self:dragUiGroupEnd(Constants.SpatialUIGroupType.MainUIGroup)
			end
		})

		local v2 = {
			positionProps = {
				uiGroupHeadRotation = v,
				uiGroupCameraOffSet = getCameraOffsetFromHeadRotationWithZAxisStabl(v), -- inferred equivalent call
				defaultGroupHeadRotation = v
			},
			uiContainerSize = vector2,
			draggable = true,
			dragBar = uiGroupDragBar,
			dragBarOffset = CFrame.new(
				0,
				Constants.ROACT_PANEL_UIGROUP_ELEMENT_OFFSET_MAP[PanelType.BottomBar].Y - 0.075 - 1 / 15,
				0
			),
			headScale = 1
		}

		self.uiGroups[Constants.SpatialUIGroupType.MainUIGroup] = v2
	end
end

function UIManager:step()
	if not VRService.VREnabled then
		return
	end

	for k, uiElement in pairs(self.uiElements) do
		if not (panelExistsInSpace(uiElement) and k == PanelType.RobloxGui) then -- inferred equivalent call
			continue
		end

		local v2

		if uiElement.uiType == SpatialUIType.SpatialUI then
			v2 = uiElement.panelObject.Adornee
		else
			v2 = uiElement.panelObject
		end

		local orientation, v3, _ = v2.CFrame:ToOrientation()
		local orientation2, v4, _ = (workspace.CurrentCamera.CFrame * VRService:GetUserCFrame(Enum.UserCFrame.Head)):ToOrientation()

		if isInExperienceUIVREnabled and not defineFastFlag2 and self.uiGroupHelper then
			self.uiGroupHelper:animateBottomBarOnHeadMoveIfNeeded(
				self.uiElements,
				Vector2.new(orientation, v3),
				Vector2.new(orientation2, v4)
			)
		end

		if
			isInExperienceUIVREnabled
			and defineFastFlag
			and (math.abs(v3 - v4) > 1.7453292519943295 or math.abs(orientation - orientation2) > 1.7453292519943295)
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

function UIManager:prepareGuiToggleAnimationState()
	if self.uiGroupHelper:isTopBarVisible() then
		self.uiGroupHelper:prepareGuiToggleAnimationState(self.uiElements)
	end
end

function UIManager:onShowTopBarChanged()
	if isInExperienceUIVREnabled or not VRService.VREnabled then
		return
	end

	if vrHub and vrHub.ShowTopBar then
		for _, uiGroup in pairs(self.uiGroups) do
			if uiGroup.draggable and uiGroup.dragBar then
				uiGroup.dragBar:show()
			end
		end

		for _, uiElement in pairs(self.uiElements) do
			if uiElement.uiType == SpatialUIType.SpatialUI or uiElement.uiType == SpatialUIType.SpatialUIRoact then
				local panelObject = uiElement.panelObject
				panelObject.Enabled = true
				panelObject.Adornee.Parent = workspace
			elseif uiElement.uiType == SpatialUIType.SpatialUIPartOnly then
				uiElement.panelObject.Parent = workspace
			end
		end
	else
		for _, uiGroup in pairs(self.uiGroups) do
			if uiGroup.draggable and uiGroup.dragBar then
				uiGroup.dragBar:hide()
			end
		end

		for _, uiElement in pairs(self.uiElements) do
			if uiElement.uiType == SpatialUIType.SpatialUI or uiElement.uiType == SpatialUIType.SpatialUIRoact then
				local panelObject = uiElement.panelObject
				panelObject.Enabled = false
				panelObject.Adornee.Parent = nil
			elseif uiElement.uiType == SpatialUIType.SpatialUIPartOnly then
				uiElement.panelObject.Parent = nil
			end
		end
	end
end

function UIManager:updateUIGroupsForCurCamera(p, cframe3: CFrame?)
	if not VRService.VREnabled then
		return
	end

	for _, uiGroup in pairs(self.uiGroups) do
		if p == nil and uiGroup.draggable then
			uiGroup.dragBar:setCFrame((cframe3 or workspace.CurrentCamera.CFrame) * uiGroup.positionProps.uiGroupCameraOffSet:ToWorldSpace(uiGroup.dragBarOffset))
		end
	end

	for k, uiElement in pairs(self.uiElements) do
		if not ((p == nil or p == k) and panelExistsInSpace(uiElement) and uiElement.panelPositionProps and uiElement.panelPositionProps.cameraFixedPanelProp) then -- inferred equivalent call
			continue
		end

		local panelPositionProps = uiElement.panelPositionProps
		local cameraFixedPanelProp = panelPositionProps.cameraFixedPanelProp
		local panelPart = getPanelPart(uiElement) -- inferred equivalent call

		if panelPart == nil then
			break
		end

		local v2 = cframe3 or workspace.CurrentCamera.CFrame

		if isInExperienceUIVREnabled and not InExperienceUIVRIXP:isSpatialUICameraTypeFixEnabled() then
			v2 = self.uiGroupHelper:getGroupCameraCFrameIfPossible(k, self.uiElements)
		end

		panelPart.CFrame = v2 * self.uiGroups[panelPositionProps.uiGroup].positionProps.uiGroupCameraOffSet:ToWorldSpace(cameraFixedPanelProp.uiGroupElementOffset)
	end
end

function UIManager:onMouseTargetChanged(p)
	for _, uiGroup in pairs(self.uiGroups) do
		if not uiGroup.draggable then
			continue
		end

		if uiGroup.dragBar and uiGroup.dragBar.part == p then
			uiGroup.dragBar:startHover()
		elseif uiGroup.dragBar and uiGroup.dragBar.part ~= p then
			uiGroup.dragBar:hoverEnd()
		end
	end
end

function UIManager:resetDragAndDrop()
	for _, uiGroup in pairs(self.uiGroups) do
		if uiGroup.draggable and uiGroup.dragBar then
			uiGroup.dragBar:hide()
		end
	end

	self:setUpUiGroups(true)
	self:rescaleUIForCurrentHeadScale()
	self:updateUIGroupsForCurCamera()
end

function UIManager:getAdditionalCameraScaleIfNeeded()
	if VRService.VREnabled then
		return workspace.CurrentCamera.HeadScale
	end

	return 1
end

function UIManager:rescaleUIForCurrentHeadScale(p, p2)
	local headScale

	if isInExperienceUIVREnabled then
		headScale = self:getAdditionalCameraScaleIfNeeded()
	else
		headScale = workspace.CurrentCamera.HeadScale
	end

	for _, uiGroup in pairs(self.uiGroups) do
		if p ~= nil then
			continue
		end

		local v2

		if defineFastFlag4 then
			v2 = uiGroup.headScale or headScale
		else
			v2 = uiGroup.headScale
		end

		local v3 = headScale / v2

		uiGroup.positionProps.uiGroupHeadRotation = Utils.rescaleCFramePosition(
			uiGroup.positionProps.uiGroupHeadRotation,
			v3
		)
		uiGroup.positionProps.uiGroupCameraOffSet = Utils.rescaleCFramePosition(
			uiGroup.positionProps.uiGroupCameraOffSet,
			v3
		)
		uiGroup.positionProps.defaultGroupHeadRotation = Utils.rescaleCFramePosition(
			uiGroup.positionProps.defaultGroupHeadRotation,
			v3
		)

		if uiGroup.draggable then
			uiGroup.dragBarOffset = Utils.rescaleCFramePosition(uiGroup.dragBarOffset, v3)
			uiGroup.dragBar:rescale(v3)
		end

		uiGroup.headScale = headScale

		if isInExperienceUIVREnabled then
			uiGroup.lastCameraCFrame = workspace.CurrentCamera.CFrame
		end
	end

	for k, uiElement in pairs(self.uiElements) do
		if not (p2 == nil or p2 == k) then
			continue
		end

		local v2

		if defineFastFlag4 then
			v2 = uiElement.headScale or headScale
		else
			v2 = uiElement.headScale
		end

		local v3 = headScale / v2

		if uiElement.uiType ~= SpatialUIType.SpatialUIRoact then
			local panelPart = getPanelPart(uiElement) -- inferred equivalent call

			if panelPart ~= nil then
				panelPart.Size *= v3
			end
		end

		local panelPositionProps = uiElement.panelPositionProps

		if panelPositionProps and panelPositionProps.cameraFixedPanelProp then
			panelPositionProps.cameraFixedPanelProp.uiGroupElementOffset = Utils.rescaleCFramePosition(
				panelPositionProps.cameraFixedPanelProp.uiGroupElementOffset,
				v3
			)
		end

		uiElement.headScale = headScale
	end
end

function UIManager.new()
	local v2 = {
		currentMouseTarget = nil,
		uiGroupsOutOfViewTimeStamp = nil,
		uiElements = {},
		uiGroups = {},
		uiGroupHelper = {},
		stableCameraCache = {}
	}

	if isInExperienceUIVREnabled then
		v2.uiGroupHelper = UIGroupHelper.new(false)
		v2.stableCameraCache = StableCameraCache.new()
	end

	setmetatable(v2, UIManager)

	v2:setUpUiGroups()
	v2:rescaleUIForCurrentHeadScale()
	v2:updateUIGroupsForCurCamera()

	RunService:BindToRenderStep("UIManagerRenderStep", Enum.RenderPriority.Last.Value, function()
		v2:step()
	end)

	if not isInExperienceUIVREnabled and vrHub then
		vrHub.ShowTopBarChanged.Event:connect(function()
			v2:onShowTopBarChanged()
		end)
	end

	local currentCamera = workspace.CurrentCamera
	currentCamera:GetPropertyChangedSignal("CFrame"):Connect(function()
		if isInExperienceUIVREnabled and InExperienceUIVRIXP:isSpatialUICameraTypeFixEnabled() then
			if v2.stableCameraCache:updateAndCheckCameraMoved() then
				v2:updateUIGroupsForCurCamera(nil, (v2.stableCameraCache:getCurrentStableCameraCFrame()))
			end
		else
			v2:updateUIGroupsForCurCamera()
		end
	end)

	currentCamera:GetPropertyChangedSignal("HeadScale"):Connect(function()
		v2:rescaleUIForCurrentHeadScale()
		v2:updateUIGroupsForCurHeadCFrame()
	end)

	local mouse = Players.LocalPlayer:GetMouse()

	if mouse then
		mouse.Move:Connect(function()
			local mouse2 = Players.LocalPlayer:GetMouse()

			if mouse2.Target ~= v2.currentMouseTarget then
				v2:onMouseTargetChanged(mouse2.Target)
				v2.currentMouseTarget = mouse2.Target
			end
		end)
	end

	return v2
end

function UIManager:getBottomBarVisibility()
	if defineFastFlag3 then
		return nil
	end

	return self.uiGroupHelper:getBottomBarVisibility()
end

function UIManager.isBottomBarInteractionOnAnimationSupported(p)
	return not defineFastFlag3 and p.uiGroupHelper:getBottomBarVisibility():get()
end

function UIManager.getInstance()
	if instance == nil then
		instance = UIManager.new()
	end

	return instance
end

return UIManager
