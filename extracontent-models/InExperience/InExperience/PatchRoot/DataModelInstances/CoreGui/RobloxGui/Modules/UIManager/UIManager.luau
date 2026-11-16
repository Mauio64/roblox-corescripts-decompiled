local VRService = game:GetService("VRService")
local RunService = game:GetService("RunService")
local CorePackages = game:GetService("CorePackages")
local VrCommon = require(CorePackages.Workspace.Packages.VrCommon)
local VRHub = VrCommon.VRHub
local parent = script.Parent
local Constants = require(parent.Constants)
local Utils = require(parent.Utils)
local PanelType = Constants.PanelType
local SpatialUIType = Constants.SpatialUIType
local createCompatPanel = require(script.Parent.createCompatPanel)
local createUIGroupDragBar = require(script.Parent.createUIGroupDragBar)
require(parent.DragBar)
local Players = game:GetService("Players")
local defineFastInt = game:DefineFastInt("FIntUIResetDelayInSec", 3)

local cframe = CFrame.Angles(-0.3141592653589793, 0.17453292519943295, 0)

local cframe2 = CFrame.new(-0.46666666666666673, -0.8, -32 / 15)

local vector2 = Vector2.new(2.666666666666667, 1.866666666666667)

local v = cframe2 * cframe

local function getZAxisStablizedCFrame(cframe3: CFrame) -- 2 equivalent calls inferred from this helper
	local orientation, v2, _ = cframe3:ToOrientation()
	return CFrame.new(cframe3.Position) * CFrame.fromOrientation(orientation, v2, 0)
end

local function getCameraOffsetFromHeadRotationWithZAxisStabl(p) -- 3 equivalent calls inferred from this helper
	local cframe3 = workspace.CurrentCamera.CFrame
	return cframe3:ToObjectSpace(getZAxisStablizedCFrame((cframe3 * VRService:GetUserCFrame(Enum.UserCFrame.Head)):ToWorldSpace(p))) -- inferred equivalent call
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

local UIManager = {}

local instance = nil

UIManager.__index = UIManager

function UIManager.removeRoactPanel(p, p2)
	p.uiElements[p2] = nil
end

function UIManager:registerRoactPanel(p, p2)
	self.uiElements[p] = p2

	self:rescaleUIForCurrentHeadScale()
	self:updateUIGroupsForCurHeadCFrame()
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

function UIManager:setUpUiGroups()
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

		if math.abs(v3 - v4) > 1.7453292519943295 or math.abs(orientation - orientation2) > 1.7453292519943295 then
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

function UIManager:onShowTopBarChanged()
	if not VRService.VREnabled then
		return
	end

	if VRHub.ShowTopBar then
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

function UIManager:updateUIGroupsForCurCamera()
	if not VRService.VREnabled then
		return
	end

	for _, uiGroup in pairs(self.uiGroups) do
		if uiGroup.draggable then
			uiGroup.dragBar:setCFrame(workspace.CurrentCamera.CFrame * uiGroup.positionProps.uiGroupCameraOffSet:ToWorldSpace(uiGroup.dragBarOffset))
		end
	end

	for _, uiElement in pairs(self.uiElements) do
		if not (panelExistsInSpace(uiElement) and uiElement.panelPositionProps and uiElement.panelPositionProps.cameraFixedPanelProp) then -- inferred equivalent call
			continue
		end

		local panelPositionProps = uiElement.panelPositionProps
		local cameraFixedPanelProp = panelPositionProps.cameraFixedPanelProp
		local panelPart = getPanelPart(uiElement) -- inferred equivalent call

		if panelPart == nil then
			break
		end

		panelPart.CFrame = workspace.CurrentCamera.CFrame * self.uiGroups[panelPositionProps.uiGroup].positionProps.uiGroupCameraOffSet:ToWorldSpace(cameraFixedPanelProp.uiGroupElementOffset)
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

function UIManager:rescaleUIForCurrentHeadScale()
	local headScale = workspace.CurrentCamera.HeadScale

	for _, uiGroup in pairs(self.uiGroups) do
		local v2 = headScale / uiGroup.headScale
		uiGroup.positionProps.uiGroupHeadRotation = Utils.rescaleCFramePosition(
			uiGroup.positionProps.uiGroupHeadRotation,
			v2
		)
		uiGroup.positionProps.uiGroupCameraOffSet = Utils.rescaleCFramePosition(
			uiGroup.positionProps.uiGroupCameraOffSet,
			v2
		)
		uiGroup.positionProps.defaultGroupHeadRotation = Utils.rescaleCFramePosition(
			uiGroup.positionProps.defaultGroupHeadRotation,
			v2
		)

		if uiGroup.draggable then
			uiGroup.dragBarOffset = Utils.rescaleCFramePosition(uiGroup.dragBarOffset, v2)
			uiGroup.dragBar:rescale(v2)
		end

		uiGroup.headScale = headScale
	end

	for _, uiElement in pairs(self.uiElements) do
		local v2 = headScale / uiElement.headScale

		if uiElement.uiType ~= SpatialUIType.SpatialUIRoact then
			local panelPart = getPanelPart(uiElement) -- inferred equivalent call

			if panelPart ~= nil then
				panelPart.Size *= v2
			end
		end

		local panelPositionProps = uiElement.panelPositionProps

		if panelPositionProps and panelPositionProps.cameraFixedPanelProp then
			panelPositionProps.cameraFixedPanelProp.uiGroupElementOffset = Utils.rescaleCFramePosition(
				panelPositionProps.cameraFixedPanelProp.uiGroupElementOffset,
				v2
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
		uiGroups = {}
	}

	setmetatable(v2, UIManager)

	v2:setUpUiGroups()
	v2:rescaleUIForCurrentHeadScale()
	v2:updateUIGroupsForCurCamera()

	RunService:BindToRenderStep("UIManagerRenderStep", Enum.RenderPriority.Last.Value, function()
		v2:step()
	end)

	VRHub.ShowTopBarChanged.Event:connect(function()
		v2:onShowTopBarChanged()
	end)

	local currentCamera = workspace.CurrentCamera
	currentCamera:GetPropertyChangedSignal("CFrame"):Connect(function()
		v2:updateUIGroupsForCurCamera()
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

function UIManager.getInstance()
	if instance == nil then
		instance = UIManager.new()
	end

	return instance
end

return UIManager
