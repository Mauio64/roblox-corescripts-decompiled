local VrSpatialUi = script:FindFirstAncestor("VrSpatialUi")
local parent = VrSpatialUi.Parent
require(parent.AppCommonLib)
local Observable = require(parent.Observable)

local Constants = require(VrSpatialUi.Constants)
local createUIGroupDragBar = require(VrSpatialUi.createUIGroupDragBar)
require(VrSpatialUi.DragBar)
local UIGroupState = require(VrSpatialUi.UIGroupState)
local PanelManagedAnimatable = require(VrSpatialUi.PanelManagedAnimatable)

local FFlagEnableSpatialUIBottomBarFixPlaceFilter = require(VrSpatialUi.Flags.FFlagEnableSpatialUIBottomBarFixPlaceFilter)
local FFlagSpatialUIHiddenPanelRaycastFix = require(VrSpatialUi.Flags.FFlagSpatialUIHiddenPanelRaycastFix)

local SharedExperimentDefinition = require(parent.SharedExperimentDefinition)
local InExperienceUIVRIXP = SharedExperimentDefinition.InExperienceUIVRIXP

local defineFastInt = game:DefineFastInt("SpatialUIRepositionDeviationAngle", 10)
local defineFastFlag = game:DefineFastFlag("SpatialUIEnableCameraCacheFix", false)
local v = math.rad(defineFastInt)

function getUIGroupTypeForPanel(p, p2)
	local v2

	if p2 then
		v2 = p[p2]
	end

	if v2 == nil then
		return nil
	end

	local panelPositionProps = v2.panelPositionProps

	if panelPositionProps then
		return panelPositionProps.uiGroup
	end

	return nil
end

function getDragBarSafely(p)
	return if p and p.dragBar and p.draggable then p.dragBar else nil
end

function isTempPanel(p): boolean
	return p == Constants.PanelType.ToolTipsContainer
end

function visitAllPanels(items, callback)
	for k, item in pairs(items) do
		callback(k, item)
	end
end

function visitDraggablePanels(p, p2, callback)
	visitAllPanels(p, function(p3, p4)
		local panelPositionProps = p4.panelPositionProps

		if
			panelPositionProps
			and not isTempPanel(p3)
			and panelPositionProps.cameraFixedPanelProp
			and panelPositionProps.uiGroup == p2
		then
			callback(p3, panelPositionProps.cameraFixedPanelProp)
		end
	end)
end

function connect(object, p)
	return { value = object, connection = object:connect(p) }
end

function disconnect(p)
	if p.connection then
		p.connection:disconnect()
		p.connection = nil
	end
end

function setPanelParent(p, parent2)
	local enabled = parent2 ~= nil

	if p.uiType == Constants.SpatialUIType.SpatialUI or p.uiType == Constants.SpatialUIType.SpatialUIRoact then
		local panelObject = p.panelObject
		panelObject.Enabled = enabled

		local adornee = panelObject.Adornee
		adornee.CanCollide = false
		adornee.CanTouch = false
		adornee.Anchored = true
		adornee.Parent = parent2
	elseif p.uiType == Constants.SpatialUIType.SpatialUIPartOnly then
		p.panelObject.Parent = parent2
	end
end

function setPanelEnabledWithoutReparent(p, enabled: boolean)
	if p.uiType == Constants.SpatialUIType.SpatialUI or p.uiType == Constants.SpatialUIType.SpatialUIRoact then
		local panelObject = p.panelObject
		panelObject.Enabled = enabled

		local adornee = panelObject.Adornee
		adornee.CanCollide = false
		adornee.CanTouch = false
		adornee.Anchored = true
	end
end

function setPanelVisibleState(p, p2, flag: boolean)
	if FFlagEnableSpatialUIBottomBarFixPlaceFilter and p2 == Constants.PanelType.BottomBar then
		setPanelEnabledWithoutReparent(p, flag)
		return
	end

	local setPanelParent = setPanelParent
	local v2

	if flag then
		v2 = workspace
	end

	setPanelParent(p, v2)
end

local UIGroupHelper = {}

UIGroupHelper.__index = UIGroupHelper

function UIGroupHelper:setTopBarVisible(p, p2)
	self.topBarVisibleValue = connect(p, p2)
end

function UIGroupHelper:isTopBarVisible()
	return self.topBarVisibleValue.value:get()
end

function UIGroupHelper:prepareGuiToggleAnimationState(_)
	self:setUIGroupState(UIGroupState.GuiToggleAnimation)
end

function UIGroupHelper:setUIGroupState(uiGroupState)
	self.uiGroupState = uiGroupState
end

function UIGroupHelper.animateBottomBarOnHeadMoveIfNeeded(p, _, vector2: Vector2, vector2_2: Vector2)
	if p.uiGroupState ~= UIGroupState.GuiToggleAnimation or p.currentBottomBarAnimatable == nil then
		return
	end

	local x = vector2.X
	local y = vector2.Y
	local x2 = vector2_2.X
	local y2 = vector2_2.Y
	local v2 = math.abs(x - x2)
	local v3 = math.abs(y - y2)

	if v < v2 or v < v3 then
		p.currentBottomBarAnimatable:animateHideIfNeeded(false)
	else
		p.currentBottomBarAnimatable:animateShowIfNeeded()
	end
end

function UIGroupHelper:isGroupVisibleForPanel(p, p2)
	local uiGroupTypeForPanel = getUIGroupTypeForPanel(p2, p)
	local v2

	if uiGroupTypeForPanel then
		v2 = self.uiGroupVisibilityMap[uiGroupTypeForPanel]
	end

	if v2 then
		return v2.value:get()
	end

	return true
end

function UIGroupHelper:applyGroupPanelsEnabled(p, p2, flag: boolean?)
	local uiGroupVisibility = self.uiGroupVisibilityMap[p]
	local v2 = not uiGroupVisibility or uiGroupVisibility.value:get()
	local v3 = self:isTopBarVisible() and v2

	if flag and v3 then
		return
	end

	visitAllPanels(p2, function(p3, p4)
		if not isTempPanel(p3) and getUIGroupTypeForPanel(p2, p3) == p then
			setPanelVisibleState(p4, p3, v3)
		end
	end)
end

function UIGroupHelper:updateAllElements(p, p2)
	local topBarVisible = self:isTopBarVisible()

	if topBarVisible then
		self:setUIGroupState(UIGroupState.Default)

		if self.currentBottomBarAnimatable then
			self.currentBottomBarAnimatable:reset()
			self.currentBottomBarAnimatable = nil
		end
	end

	self:updateAllDragBar(p, p2)
	visitAllPanels(p, function(p3, p4)
		local v2 = p3 == Constants.PanelType.BottomBar

		if topBarVisible then
			if FFlagSpatialUIHiddenPanelRaycastFix and not self:isGroupVisibleForPanel(p3, p) then
				setPanelVisibleState(p4, p3, false)
			elseif FFlagEnableSpatialUIBottomBarFixPlaceFilter and v2 then
				setPanelEnabledWithoutReparent(p4, true)
			else
				setPanelParent(p4, workspace)
			end
		elseif v2 and (self.uiGroupState == UIGroupState.GuiToggleAnimation or p4.keepVisibleWhenTopBarHidden) then
			if not self.currentBottomBarAnimatable then
				local v3 = p4.keepVisibleWhenTopBarHidden and self.uiGroupState ~= UIGroupState.GuiToggleAnimation
				self.currentBottomBarAnimatable = PanelManagedAnimatable.create(
					p4.panelObject,
					self.bottomBarVisibility,
					v3
				)

				if self.currentBottomBarAnimatable then
					self.currentBottomBarAnimatable:hideAndBlockAnimationUntilLookBackAgain()
				end
			end

			if p4.keepVisibleWhenTopBarHidden then
				if FFlagEnableSpatialUIBottomBarFixPlaceFilter then
					setPanelEnabledWithoutReparent(p4, true)
				else
					setPanelParent(p4, workspace)
				end
			end
		elseif FFlagEnableSpatialUIBottomBarFixPlaceFilter and v2 then
			setPanelEnabledWithoutReparent(p4, false)
		else
			setPanelParent(p4, nil)
		end
	end)
end

function UIGroupHelper:connectPanelVisibility(p, p2, p3, p4)
	if isTempPanel(p) then
		return
	end

	self:disconnectPanelVisibility(p, p3, p4)
	local uiGroupTypeForPanel = getUIGroupTypeForPanel(p3, p)

	if not uiGroupTypeForPanel then
		return
	end

	self.uiGroupVisibilityMap[uiGroupTypeForPanel] = connect(p2, function()
		self:updateDragBar(p, p3, p4)

		if FFlagSpatialUIHiddenPanelRaycastFix then
			self:applyGroupPanelsEnabled(uiGroupTypeForPanel, p3)
		end
	end)
	self:updateDragBar(p, p3, p4)

	if FFlagSpatialUIHiddenPanelRaycastFix then
		self:applyGroupPanelsEnabled(uiGroupTypeForPanel, p3, true)
	end
end

function UIGroupHelper:disconnectPanelVisibility(p, p2, p3)
	if isTempPanel(p) then
		return
	end

	local uiGroupTypeForPanel = getUIGroupTypeForPanel(p2, p)
	local v2

	if uiGroupTypeForPanel then
		v2 = self.uiGroupVisibilityMap[uiGroupTypeForPanel]
	end

	if v2 then
		disconnect(v2)
		self.uiGroupVisibilityMap[uiGroupTypeForPanel] = nil
		self:updateDragBar(p, p2, p3)
	end
end

function UIGroupHelper:updateDragBar(p, p2, p3)
	local uiGroupTypeForPanel = getUIGroupTypeForPanel(p2, p)
	local v2

	if uiGroupTypeForPanel then
		v2 = p3[uiGroupTypeForPanel]
	end

	if not v2 or not v2.dragBar or not v2.draggable or isTempPanel(p) then
		return
	end

	local topBarVisible = self:isTopBarVisible()
	local uiGroupVisibility = self.uiGroupVisibilityMap[uiGroupTypeForPanel]
	local v3

	if uiGroupVisibility then
		v3 = topBarVisible and uiGroupVisibility.value:get()
	else
		v3 = false
	end

	if v3 then
		v2.dragBar:show()
	else
		v2.dragBar:hide()
	end
end

function UIGroupHelper:updateAllDragBar(items, p)
	for k, _ in pairs(items) do
		self:updateDragBar(k, items, p)
	end
end

function UIGroupHelper.createUIGroup(p, object, name, uiContainerSize: Vector2, positionProps, p2, flag: boolean?)
	local cframe = Constants.UIGROUP_INITITIAL_ROTATION_MAP[name]
	local uiGroup = p.uiGroups[name]
	local dragBarSafely = getDragBarSafely(uiGroup)

	if flag and cframe and dragBarSafely and dragBarSafely:isEverDragged() then
		visitDraggablePanels(p2, name, function(_, p3)
			uiGroup.dragBarOffset *= cframe
			p3.uiGroupElementOffset *= cframe
		end)
	end

	local uiGroup2 = nil
	local dragBar = nil
	dragBar = createUIGroupDragBar({
		name = name,
		dragFunction = function(_, _, _, _, _)
			object:dragUiGroupStep(name)
		end,
		dragStartFunction = function(_, _, _, _, _, _, _)
			if cframe and uiGroup2 and dragBar and not dragBar:isEverDragged() then
				dragBar:setCFrame(dragBar:getCFrame() * cframe:Inverse())
				uiGroup2.dragBarOffset *= cframe:Inverse()
				visitDraggablePanels(p2, name, function(_, p3)
					p3.uiGroupElementOffset *= cframe:Inverse()
				end)
			end

			object:dragUiGroupStart(name)
		end,
		dragEndFunction = function(_)
			object:dragUiGroupEnd(name)
		end,
		dragBarPartSize = Constants.DRAG_BAR_SIZE
	})

	dragBar:hide()
	uiGroup2 = {
		positionProps = positionProps,
		uiContainerSize = uiContainerSize,
		draggable = InExperienceUIVRIXP:isDraggingAllowed(),
		dragBar = dragBar,
		dragBarOffset = Constants.UIGROUP_DRAGBAR_OFFSET_MAP[name],
		headScale = 1
	}

	p.uiGroups[name] = uiGroup2
	return uiGroup2
end

function UIGroupHelper.checkAndGetUIGroupTypeForTempPanel(_, p, p2)
	if isTempPanel(p) then
		return (getUIGroupTypeForPanel(p2, p))
	end

	return nil
end

function UIGroupHelper.getGroupCameraCFrameIfPossible(p, p2, p3)
	local groupCameraCFrameIfPossible = workspace.CurrentCamera.CFrame

	if defineFastFlag and isTempPanel(p2) then
		local uiGroupTypeForPanel = getUIGroupTypeForPanel(p3, p2)

		if uiGroupTypeForPanel ~= nil and p.uiGroups[uiGroupTypeForPanel].lastCameraCFrame then
			groupCameraCFrameIfPossible = p.uiGroups[uiGroupTypeForPanel].lastCameraCFrame
		end
	end

	return groupCameraCFrameIfPossible
end

function UIGroupHelper.getBottomBarVisibility(p)
	return p.bottomBarVisibility
end

function UIGroupHelper.new(flag: boolean)
	local v2 = {
		uiGroupVisibilityMap = {},
		topBarVisibleValue = {
			value = Observable.ObservableValue.new(flag)
		},
		uiGroups = {},
		uiGroupState = UIGroupState.Default,
		bottomBarVisibility = Observable.ObservableValue.new(true),
		currentBottomBarAnimatable = nil
	}

	setmetatable(v2, UIGroupHelper)
	return v2
end

return UIGroupHelper
