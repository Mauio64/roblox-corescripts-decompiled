require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/AppCommonLib")
local Observable = require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/Observable")

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/VrSpatialUi/Constants")
local createUIGroupDragBar = require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/VrSpatialUi/createUIGroupDragBar")
require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/VrSpatialUi/DragBar")
local UIGroupState = require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/VrSpatialUi/UIGroupState")
local PanelManagedAnimatable = require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/VrSpatialUi/PanelManagedAnimatable")

local FFlagEnableSpatialUIBottomBarFixPlaceFilter = require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/VrSpatialUi/Flags/FFlagEnableSpatialUIBottomBarFixPlaceFilter")
local FFlagSpatialUIHiddenPanelRaycastFix = require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/VrSpatialUi/Flags/FFlagSpatialUIHiddenPanelRaycastFix")

local inExperienceUIVRIXP = require("@game/CorePackages/Workspace/Packages/_Workspace/VrSpatialUi/SharedExperimentDefinition").InExperienceUIVRIXP

local defineFastInt = game:DefineFastInt("SpatialUIRepositionDeviationAngle", 10)
local defineFastFlag = game:DefineFastFlag("SpatialUIEnableCameraCacheFix", false)
local v5 = math.rad(defineFastInt)

function LUAUFORGE_MODULE_GLOBALS_dnL_getUIGroupTypeForPanel(p2, p3)
	local v6 = if p3 then p2[p3] else nil

	if v6 == nil then
		return nil
	end

	local panelPositionProps = v6.panelPositionProps

	if panelPositionProps then
		return panelPositionProps.uiGroup
	end

	return nil
end

function LUAUFORGE_MODULE_GLOBALS_dnL_getDragBarSafely(p2)
	if p2 and p2.dragBar and p2.draggable then
		return p2.dragBar
	end

	return nil
end

function LUAUFORGE_MODULE_GLOBALS_dnL_isTempPanel(p2): boolean
	return p2 == Constants.PanelType.ToolTipsContainer
end

function LUAUFORGE_MODULE_GLOBALS_dnL_visitAllPanels(items, callback)
	for k, item in pairs(items) do
		callback(k, item)
	end
end

function LUAUFORGE_MODULE_GLOBALS_dnL_visitDraggablePanels(p2, p3, callback)
	LUAUFORGE_MODULE_GLOBALS_dnL_visitAllPanels(p2, function(p4, p5)
		local panelPositionProps = p5.panelPositionProps

		if
			panelPositionProps
			and not LUAUFORGE_MODULE_GLOBALS_dnL_isTempPanel(p4)
			and panelPositionProps.cameraFixedPanelProp
			and panelPositionProps.uiGroup == p3
		then
			callback(p4, panelPositionProps.cameraFixedPanelProp)
		end
	end)
end

function LUAUFORGE_MODULE_GLOBALS_dnL_connect(object, p2)
	return { value = object, connection = object:connect(p2) }
end

function LUAUFORGE_MODULE_GLOBALS_dnL_disconnect(p2)
	if p2.connection then
		p2.connection:disconnect()
		p2.connection = nil
	end
end

function LUAUFORGE_MODULE_GLOBALS_dnL_setPanelParent(p2, parent)
	local v6 = parent ~= nil

	if
		p2.uiType == Constants.SpatialUIType.SpatialUI
		or p2.uiType == Constants.SpatialUIType.SpatialUIRoact
	then
		local panelObject = p2.panelObject
		panelObject.Enabled = v6

		local adornee = panelObject.Adornee
		adornee.CanCollide = false
		adornee.CanTouch = false
		adornee.Anchored = true
		adornee.Parent = parent
	elseif p2.uiType == Constants.SpatialUIType.SpatialUIPartOnly then
		p2.panelObject.Parent = parent
	end
end

function LUAUFORGE_MODULE_GLOBALS_dnL_setPanelEnabledWithoutReparent(p2, enabled)
	if
		p2.uiType == Constants.SpatialUIType.SpatialUI
		or p2.uiType == Constants.SpatialUIType.SpatialUIRoact
	then
		local panelObject = p2.panelObject
		panelObject.Enabled = enabled

		local adornee = panelObject.Adornee
		adornee.CanCollide = false
		adornee.CanTouch = false
		adornee.Anchored = true
	end
end

function LUAUFORGE_MODULE_GLOBALS_dnL_setPanelVisibleState(p2, p3, p4)
	if FFlagEnableSpatialUIBottomBarFixPlaceFilter and p3 == Constants.PanelType.BottomBar then
		LUAUFORGE_MODULE_GLOBALS_dnL_setPanelEnabledWithoutReparent(p2, p4)
		return
	end

	local LUAUFORGE_MODULE_GLOBALS_dnL_setPanelParent2 = LUAUFORGE_MODULE_GLOBALS_dnL_setPanelParent
	local v6 = if p4 then workspace else nil
	LUAUFORGE_MODULE_GLOBALS_dnL_setPanelParent2(p2, v6)
end

local class = {}

class.__index = class

function class:setTopBarVisible(p3, p4)
	self.topBarVisibleValue = LUAUFORGE_MODULE_GLOBALS_dnL_connect(p3, p4)
end

function class:isTopBarVisible()
	return self.topBarVisibleValue.value:get()
end

function class:prepareGuiToggleAnimationState(p2)
	self:setUIGroupState(UIGroupState.GuiToggleAnimation)
end

function class:setUIGroupState(uiGroupState)
	self.uiGroupState = uiGroupState
end

function class:animateBottomBarOnHeadMoveIfNeeded(p3, p4, p5)
	if self.uiGroupState ~= UIGroupState.GuiToggleAnimation or self.currentBottomBarAnimatable == nil then
		return
	end

	local x = p4.X
	local y = p4.Y
	local x2 = p5.X
	local y2 = p5.Y
	local v6 = math.abs(x - x2)
	local v7 = math.abs(y - y2)

	if v5 < v6 or v5 < v7 then
		self.currentBottomBarAnimatable:animateHideIfNeeded(false)
	else
		self.currentBottomBarAnimatable:animateShowIfNeeded()
	end
end

function class:isGroupVisibleForPanel(p3, p4)
	local v6 = LUAUFORGE_MODULE_GLOBALS_dnL_getUIGroupTypeForPanel(p4, p3)

	local v7 = if v6 then self.uiGroupVisibilityMap[v6] else nil

	if v7 then
		return v7.value:get()
	end

	return true
end

function class:applyGroupPanelsEnabled(p2, p3, p4)
	local uiGroupVisibility = self.uiGroupVisibilityMap[p2]
	local v6 = not uiGroupVisibility or uiGroupVisibility.value:get()
	local v7 = self:isTopBarVisible() and v6

	if p4 and v7 then
		return
	end

	LUAUFORGE_MODULE_GLOBALS_dnL_visitAllPanels(p3, function(p5, p6)
		if
			not LUAUFORGE_MODULE_GLOBALS_dnL_isTempPanel(p5)
			and LUAUFORGE_MODULE_GLOBALS_dnL_getUIGroupTypeForPanel(p3, p5) == p2
		then
			LUAUFORGE_MODULE_GLOBALS_dnL_setPanelVisibleState(p6, p5, v7)
		end
	end)
end

function class:updateAllElements(p2, p3)
	local topBarVisible = self:isTopBarVisible()

	if topBarVisible then
		self:setUIGroupState(UIGroupState.Default)

		if self.currentBottomBarAnimatable then
			self.currentBottomBarAnimatable:reset()
			self.currentBottomBarAnimatable = nil
		end
	end

	self:updateAllDragBar(p2, p3)
	LUAUFORGE_MODULE_GLOBALS_dnL_visitAllPanels(p2, function(p4, p5)
		local v6 = p4 == Constants.PanelType.BottomBar

		if topBarVisible then
			if FFlagSpatialUIHiddenPanelRaycastFix and not self:isGroupVisibleForPanel(p4, p2) then
				LUAUFORGE_MODULE_GLOBALS_dnL_setPanelVisibleState(p5, p4, false)
			elseif FFlagEnableSpatialUIBottomBarFixPlaceFilter and v6 then
				LUAUFORGE_MODULE_GLOBALS_dnL_setPanelEnabledWithoutReparent(p5, true)
			else
				LUAUFORGE_MODULE_GLOBALS_dnL_setPanelParent(p5, workspace)
			end
		elseif
			v6
			and (self.uiGroupState == UIGroupState.GuiToggleAnimation or p5.keepVisibleWhenTopBarHidden)
		then
			if not self.currentBottomBarAnimatable then
				local v7 = p5.keepVisibleWhenTopBarHidden
					and self.uiGroupState ~= UIGroupState.GuiToggleAnimation
				self.currentBottomBarAnimatable = PanelManagedAnimatable.create(p5.panelObject, self.bottomBarVisibility, v7)

				if self.currentBottomBarAnimatable then
					self.currentBottomBarAnimatable:hideAndBlockAnimationUntilLookBackAgain()
				end
			end

			if p5.keepVisibleWhenTopBarHidden then
				if FFlagEnableSpatialUIBottomBarFixPlaceFilter then
					LUAUFORGE_MODULE_GLOBALS_dnL_setPanelEnabledWithoutReparent(p5, true)
				else
					LUAUFORGE_MODULE_GLOBALS_dnL_setPanelParent(p5, workspace)
				end
			end
		elseif FFlagEnableSpatialUIBottomBarFixPlaceFilter and v6 then
			LUAUFORGE_MODULE_GLOBALS_dnL_setPanelEnabledWithoutReparent(p5, false)
		else
			LUAUFORGE_MODULE_GLOBALS_dnL_setPanelParent(p5, nil)
		end
	end)
end

function class:connectPanelVisibility(p2, p3, p4, p5)
	if LUAUFORGE_MODULE_GLOBALS_dnL_isTempPanel(p2) then
		return
	end

	self:disconnectPanelVisibility(p2, p4, p5)
	local v6 = LUAUFORGE_MODULE_GLOBALS_dnL_getUIGroupTypeForPanel(p4, p2)

	if not v6 then
		return
	end

	self.uiGroupVisibilityMap[v6] = LUAUFORGE_MODULE_GLOBALS_dnL_connect(p3, function()
		self:updateDragBar(p2, p4, p5)

		if FFlagSpatialUIHiddenPanelRaycastFix then
			self:applyGroupPanelsEnabled(v6, p4)
		end
	end)
	self:updateDragBar(p2, p4, p5)

	if FFlagSpatialUIHiddenPanelRaycastFix then
		self:applyGroupPanelsEnabled(v6, p4, true)
	end
end

function class:disconnectPanelVisibility(p2, p3, p4)
	if LUAUFORGE_MODULE_GLOBALS_dnL_isTempPanel(p2) then
		return
	end

	local v6 = LUAUFORGE_MODULE_GLOBALS_dnL_getUIGroupTypeForPanel(p3, p2)

	local v7 = if v6 then self.uiGroupVisibilityMap[v6] else nil

	if v7 then
		LUAUFORGE_MODULE_GLOBALS_dnL_disconnect(v7)
		self.uiGroupVisibilityMap[v6] = nil
		self:updateDragBar(p2, p3, p4)
	end
end

function class:updateDragBar(p2, p3, p4)
	local v6 = LUAUFORGE_MODULE_GLOBALS_dnL_getUIGroupTypeForPanel(p3, p2)
	local v7 = if v6 then p4[v6] else nil

	if not v7 or not v7.dragBar or not v7.draggable or LUAUFORGE_MODULE_GLOBALS_dnL_isTempPanel(p2) then
		return
	end

	local topBarVisible = self:isTopBarVisible()
	local uiGroupVisibility = self.uiGroupVisibilityMap[v6]

	local v8 = if uiGroupVisibility then topBarVisible and uiGroupVisibility.value:get() else false

	if v8 then
		v7.dragBar:show()
	else
		v7.dragBar:hide()
	end
end

function class:updateAllDragBar(items, p2)
	for k, item in pairs(items) do
		self:updateDragBar(k, items, p2)
	end
end

function class:createUIGroup(object, p3, p4, p5, p6, p7)
	local cframe = Constants.UIGROUP_INITITIAL_ROTATION_MAP[p3]
	local uiGroup = self.uiGroups[p3]
	local v6 = LUAUFORGE_MODULE_GLOBALS_dnL_getDragBarSafely(uiGroup)

	if p7 and cframe and v6 and v6:isEverDragged() then
		LUAUFORGE_MODULE_GLOBALS_dnL_visitDraggablePanels(p6, p3, function(p8, p9)
			uiGroup.dragBarOffset *= cframe
			p9.uiGroupElementOffset *= cframe
		end)
	end

	local uiGroup2 = nil
	local v7 = nil
	v7 = createUIGroupDragBar({
		name = p3,
		dragFunction = function(p8, p9, p10, p11, p12)
			object:dragUiGroupStep(p3)
		end,
		dragStartFunction = function(p8, p9, p10, p11, p12, p13, p14)
			if cframe and uiGroup2 and v7 and not v7:isEverDragged() then
				v7:setCFrame(v7:getCFrame() * cframe:Inverse())
				uiGroup2.dragBarOffset *= cframe:Inverse()
				LUAUFORGE_MODULE_GLOBALS_dnL_visitDraggablePanels(p6, p3, function(p15, p16)
					p16.uiGroupElementOffset *= cframe:Inverse()
				end)
			end

			object:dragUiGroupStart(p3)
		end,
		dragEndFunction = function(p8)
			object:dragUiGroupEnd(p3)
		end,
		dragBarPartSize = Constants.DRAG_BAR_SIZE
	})

	v7:hide()
	uiGroup2 = {
		positionProps = p5,
		uiContainerSize = p4,
		draggable = inExperienceUIVRIXP:isDraggingAllowed(),
		dragBar = v7,
		dragBarOffset = Constants.UIGROUP_DRAGBAR_OFFSET_MAP[p3],
		headScale = 1
	}

	self.uiGroups[p3] = uiGroup2
	return uiGroup2
end

function class:checkAndGetUIGroupTypeForTempPanel(p3, p4)
	if LUAUFORGE_MODULE_GLOBALS_dnL_isTempPanel(p3) then
		return (LUAUFORGE_MODULE_GLOBALS_dnL_getUIGroupTypeForPanel(p4, p3))
	end

	return nil
end

function class:getGroupCameraCFrameIfPossible(p3, p4)
	local groupCameraCFrameIfPossible = workspace.CurrentCamera.CFrame

	if defineFastFlag and LUAUFORGE_MODULE_GLOBALS_dnL_isTempPanel(p3) then
		local v6 = LUAUFORGE_MODULE_GLOBALS_dnL_getUIGroupTypeForPanel(p4, p3)

		if v6 ~= nil and self.uiGroups[v6].lastCameraCFrame then
			groupCameraCFrameIfPossible = self.uiGroups[v6].lastCameraCFrame
		end
	end

	return groupCameraCFrameIfPossible
end

function class:getBottomBarVisibility()
	return self.bottomBarVisibility
end

function class.new(p2)
	local v6 = {
		uiGroupVisibilityMap = {},
		topBarVisibleValue = { value = Observable.ObservableValue.new(p2) },
		uiGroups = {},
		uiGroupState = UIGroupState.Default,
		bottomBarVisibility = Observable.ObservableValue.new(true),
		currentBottomBarAnimatable = nil
	}

	setmetatable(v6, class)
	return v6
end

return class
