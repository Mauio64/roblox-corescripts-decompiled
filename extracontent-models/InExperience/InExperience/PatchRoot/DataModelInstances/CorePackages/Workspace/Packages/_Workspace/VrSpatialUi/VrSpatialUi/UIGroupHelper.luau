local VrSpatialUi = script:FindFirstAncestor("VrSpatialUi")
local VrSpatialUiParent = VrSpatialUi.Parent

require(VrSpatialUiParent.AppCommonLib)

local Observable = require(VrSpatialUiParent.Observable)
local Constants = require(VrSpatialUi.Constants)
local createUIGroupDragBar = require(VrSpatialUi.createUIGroupDragBar)

require(VrSpatialUi.DragBar)

local UIGroupState = require(VrSpatialUi.UIGroupState)
local PanelManagedAnimatable = require(VrSpatialUi.PanelManagedAnimatable)
local FFlagEnableSpatialUIBottomBarFixPlaceFilter = require(VrSpatialUi.Flags.FFlagEnableSpatialUIBottomBarFixPlaceFilter)
local InExperienceUIVRIXP = require(VrSpatialUiParent.SharedExperimentDefinition).InExperienceUIVRIXP
local v10 = game:DefineFastInt("SpatialUIRepositionDeviationAngle", 10)
local v11 = game:DefineFastFlag("SpatialUIEnableCameraCacheFix", false)
local v12 = math.rad(v10)

function getUIGroupTypeForPanel(t1: {[any]: any}, p1) -- line: 46
	local v16 = if not p1 then nil else t1[p1]

	if v16 == nil then
		return nil
	end

	local panelPositionProps = v16.panelPositionProps

	if panelPositionProps then
		return panelPositionProps.uiGroup
	end

	return nil
end
function getDragBarSafely(p2) -- line: 62
	if p2 and (p2.dragBar and p2.draggable) then
		return p2.dragBar
	end

	return nil
end
function isTempPanel(p3) -- line: 70
	-- upvalues: Constants (copy)
	return p3 == Constants.PanelType.ToolTipsContainer
end
function visitAllPanels(t2: {[any]: any}, p4: ((...any) -> ...any)) -- line: 74
	for k, v in pairs(t2) do
		p4(k, v)
	end
end
function visitDraggablePanels(t3: {[any]: any}, p5, p6: ((...any) -> ...any)) -- line: 83
	visitAllPanels(t3, function(p7, p8) -- line: 91
		-- upvalues: p5 (copy), p6 (copy)
		local panelPositionProps = p8.panelPositionProps

		if panelPositionProps and (not isTempPanel(p7) and panelPositionProps.cameraFixedPanelProp and panelPositionProps.uiGroup == p5) then
			p6(p7, panelPositionProps.cameraFixedPanelProp)
		end
	end)
end
function connect(p9, p10) -- line: 104
	local v29 = p9:connect(p10)

	return {
		value = p9,
		connection = v29
	}
end
function disconnect(t4: {[any]: any}) -- line: 112
	if t4.connection then
		t4.connection:disconnect()
		t4.connection = nil
	end
end
function setPanelParent(p11, p12) -- line: 119
	-- upvalues: Constants (copy)
	local v33 = p12 ~= nil

	if p11.uiType == Constants.SpatialUIType.SpatialUI or p11.uiType == Constants.SpatialUIType.SpatialUIRoact then
		local panelObject = p11.panelObject

		panelObject.Enabled = v33

		local panelObjectAdornee = panelObject.Adornee

		panelObjectAdornee.CanCollide = false
		panelObjectAdornee.CanTouch = false
		panelObjectAdornee.Anchored = true
		panelObjectAdornee.Parent = p12

		return
	end

	if p11.uiType == Constants.SpatialUIType.SpatialUIPartOnly then
		p11.panelObject.Parent = p12
	end
end
function setPanelEnabledWithoutReparent(p13, b1: boolean) -- line: 143
	-- upvalues: Constants (copy)
	if p13.uiType == Constants.SpatialUIType.SpatialUI or p13.uiType == Constants.SpatialUIType.SpatialUIRoact then
		local panelObject = p13.panelObject

		panelObject.Enabled = b1

		local panelObjectAdornee = panelObject.Adornee

		panelObjectAdornee.CanCollide = false
		panelObjectAdornee.CanTouch = false
		panelObjectAdornee.Anchored = true
	end
end

local t5 = {}

t5.__index = t5

function t5.setTopBarVisible(p14, p15, p16) -- line: 174
	p14.topBarVisibleValue = connect(p15, p16)
end
function t5.isTopBarVisible(p17) -- line: 178
	return p17.topBarVisibleValue.value:get()
end
function t5.prepareGuiToggleAnimationState(p18, _: {[any]: any}) -- line: 182
	-- upvalues: UIGroupState (copy)
	p18:setUIGroupState(UIGroupState.GuiToggleAnimation)
end
function t5.setUIGroupState(p19, p20) -- line: 189
	p19.uiGroupState = p20
end
function t5.animateBottomBarOnHeadMoveIfNeeded(p21, _: {[any]: any}, vector2: Vector2, vector2_2: Vector2) -- line: 193
	-- upvalues: UIGroupState (copy), v12 (copy)
	if p21.uiGroupState ~= UIGroupState.GuiToggleAnimation or p21.currentBottomBarAnimatable == nil then
		return
	end

	local vector2X = vector2.X
	local vector2Y = vector2.Y
	local vector2_2X = vector2_2.X
	local vector2_2Y = vector2_2.Y
	local v56 = math.abs(vector2X - vector2_2X)
	local v57 = math.abs(vector2Y - vector2_2Y)

	if v56 > v12 or v57 > v12 then
		p21.currentBottomBarAnimatable:animateHideIfNeeded(false)

		return
	end

	p21.currentBottomBarAnimatable:animateShowIfNeeded()
end
function t5.updateAllElements(p22, t8: {[any]: any}, t9: {[any]: any}) -- line: 214
	-- upvalues: UIGroupState (copy), Constants (copy), FFlagEnableSpatialUIBottomBarFixPlaceFilter (copy), PanelManagedAnimatable (copy)
	local v61 = p22:isTopBarVisible()

	if v61 then
		p22:setUIGroupState(UIGroupState.Default)

		if p22.currentBottomBarAnimatable then
			p22.currentBottomBarAnimatable:reset()
			p22.currentBottomBarAnimatable = nil
		end
	end

	p22:updateAllDragBar(t8, t9)
	visitAllPanels(t8, function(p23, p24) -- line: 228
		-- upvalues: Constants (copy), v61 (copy), FFlagEnableSpatialUIBottomBarFixPlaceFilter (copy), p22 (copy), UIGroupState (copy), PanelManagedAnimatable (copy)
		local v115 = p23 == Constants.PanelType.BottomBar

		if v61 then
			if FFlagEnableSpatialUIBottomBarFixPlaceFilter and v115 then
				setPanelEnabledWithoutReparent(p24, true)

				return
			end

			setPanelParent(p24, workspace)

			return
		end

		if p22.uiGroupState == UIGroupState.GuiToggleAnimation and v115 then
			if not p22.currentBottomBarAnimatable then
				p22.currentBottomBarAnimatable = PanelManagedAnimatable.create(p24.panelObject, p22.bottomBarVisibility)

				if p22.currentBottomBarAnimatable then
					p22.currentBottomBarAnimatable:hideAndBlockAnimationUntilLookBackAgain()

					return
				end
			end
		else
			if FFlagEnableSpatialUIBottomBarFixPlaceFilter and v115 then
				setPanelEnabledWithoutReparent(p24, false)

				return
			end

			setPanelParent(p24, nil)
		end
	end)
end
function t5.connectPanelVisibility(p25, p26, p27, t10: {[any]: any}, t11: {[any]: any}) -- line: 254
	if isTempPanel(p26) then
		return
	end

	p25:disconnectPanelVisibility(p26, t10, t11)

	local v67 = getUIGroupTypeForPanel(t10, p26)

	if not v67 then
		return
	end

	p25.uiGroupVisibilityMap[v67] = connect(p27, function() -- line: 269
		-- upvalues: p25 (copy), p26 (copy), t10 (copy), t11 (copy)
		p25:updateDragBar(p26, t10, t11)
	end)
	p25:updateDragBar(p26, t10, t11)
end
function t5.disconnectPanelVisibility(p28, p29, t12: {[any]: any}, t13: {[any]: any}) -- line: 275
	if isTempPanel(p29) then
		return
	end

	local v72 = getUIGroupTypeForPanel(t12, p29)
	local v73 = if not v72 then nil else p28.uiGroupVisibilityMap[v72]

	if v73 then
		disconnect(v73)
		p28.uiGroupVisibilityMap[v72] = nil
		p28:updateDragBar(p29, t12, t13)
	end
end
function t5.updateDragBar(p30, p31, t14: {[any]: any}, t15: {[any]: any}) -- line: 295
	local v78 = getUIGroupTypeForPanel(t14, p31)
	local v79 = if not v78 then nil else t15[v78]

	if not v79 or (not v79.dragBar or not v79.draggable or isTempPanel(p31)) then
		return
	end

	local v80 = p30:isTopBarVisible()
	local v81 = p30.uiGroupVisibilityMap[v78]

	if v81 and (v80 and v81.value:get()) then
		v79.dragBar:show()

		return
	end

	v79.dragBar:hide()
end
function t5.updateAllDragBar(p32, t16: {[any]: any}, t17: {[any]: any}) -- line: 320
	for k, _ in pairs(t16) do
		p32:updateDragBar(k, t16, t17)
	end
end
function t5.createUIGroup(p33, p34, p35, vector2: Vector2, p36, t18: {[any]: any}, b2: boolean?) -- line: 330
	-- upvalues: Constants (copy), createUIGroupDragBar (copy), InExperienceUIVRIXP (copy)
	local v94 = Constants.UIGROUP_INITITIAL_ROTATION_MAP[p35]
	local v95 = p33.uiGroups[p35]
	local v96 = getDragBarSafely(v95)

	if b2 and (v94 and v96 and v96:isEverDragged()) then
		visitDraggablePanels(t18, p35, function(_, p38) -- line: 346
			-- upvalues: v95 (copy), v94 (copy)
			v95.dragBarOffset = v95.dragBarOffset * v94
			p38.uiGroupElementOffset = p38.uiGroupElementOffset * v94
		end)
	end

	local t19 = nil
	local u98 = nil

	u98 = createUIGroupDragBar({
		name = p35,
		dragFunction = function(_, _, _, _, _) -- line: 355
			-- upvalues: p34 (copy), p35 (copy)
			p34:dragUiGroupStep(p35)
		end,
		dragStartFunction = function(_, _, _, _, _, _, _) -- line: 358
			-- upvalues: v94 (copy), t19 (ref), u98 (ref), t18 (copy), p35 (copy), p34 (copy)
			if v94 and (t19 and u98 and not u98:isEverDragged()) then
				u98:setCFrame(u98:getCFrame() * v94:Inverse())
				t19.dragBarOffset = t19.dragBarOffset * v94:Inverse()
				visitDraggablePanels(t18, p35, function(_, p52) -- line: 367
					-- upvalues: v94 (copy)
					p52.uiGroupElementOffset = p52.uiGroupElementOffset * v94:Inverse()
				end)
			end

			p34:dragUiGroupStart(p35)
		end,
		dragEndFunction = function(_) -- line: 375
			-- upvalues: p34 (copy), p35 (copy)
			p34:dragUiGroupEnd(p35)
		end,
		dragBarPartSize = Constants.DRAG_BAR_SIZE
	})
	u98:hide()
	t19 = {
		headScale = 1,
		positionProps = p36,
		uiContainerSize = vector2,
		draggable = InExperienceUIVRIXP:isDraggingAllowed(),
		dragBar = u98,
		dragBarOffset = Constants.UIGROUP_DRAGBAR_OFFSET_MAP[p35]
	}
	p33.uiGroups[p35] = t19

	return t19
end
function t5.checkAndGetUIGroupTypeForTempPanel(_, p55, t20: {[any]: any}) -- line: 393
	if isTempPanel(p55) then
		return (getUIGroupTypeForPanel(t20, p55))
	end

	return nil
end
function t5.getGroupCameraCFrameIfPossible(p56, p57, t21: {[any]: any}) -- line: 404
	-- upvalues: v11 (copy)
	local CurrentCameraCFrame = workspace.CurrentCamera.CFrame

	if v11 and isTempPanel(p57) then
		local v106 = getUIGroupTypeForPanel(t21, p57)

		if v106 ~= nil and p56.uiGroups[v106].lastCameraCFrame then
			CurrentCameraCFrame = p56.uiGroups[v106].lastCameraCFrame
		end
	end

	return CurrentCameraCFrame
end
function t5.getBottomBarVisibility(p58) -- line: 420
	return p58.bottomBarVisibility
end
function t5.new(b3: boolean) -- line: 424
	-- upvalues: Observable (copy), UIGroupState (copy), t5 (copy)
	local t22 = {
		currentBottomBarAnimatable = nil,
		uiGroupVisibilityMap = {},
		topBarVisibleValue = {
			value = Observable.ObservableValue.new(b3)
		},
		uiGroups = {},
		uiGroupState = UIGroupState.Default,
		bottomBarVisibility = Observable.ObservableValue.new(true)
	}

	setmetatable(t22, t5)

	return t22
end

return t5
