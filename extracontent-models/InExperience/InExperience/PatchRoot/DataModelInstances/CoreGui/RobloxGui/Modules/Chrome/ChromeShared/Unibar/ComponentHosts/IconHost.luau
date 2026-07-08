local ChromeShared = script:FindFirstAncestor("ChromeShared")
local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local React = require(CorePackages.Packages.React)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local FFlagExpChatShowGlobalChatTooltip = SharedFlags.FFlagExpChatShowGlobalChatTooltip
local ExpChatShared = require(CorePackages.Workspace.Packages.ExpChatShared)
local FFlagExpChatPresetChatEnabled = ExpChatShared.Flags.FFlagExpChatPresetChatEnabled
local FFlagExpChatUseUnifiedTooltipStore = ExpChatShared.Flags.FFlagExpChatUseUnifiedTooltipStore
local v12 = FFlagExpChatShowGlobalChatTooltip or FFlagExpChatPresetChatEnabled and FFlagExpChatUseUnifiedTooltipStore
local Flags = require(script.Parent.Parent.Parent.Parent.Flags)
local FFlagUnibarMenuOpenHamburger = Flags.FFlagUnibarMenuOpenHamburger
local FFlagUnibarMenuOpenSubmenu = Flags.FFlagUnibarMenuOpenSubmenu
local FFlagTokenizeUnibarConstantsWithStyleProvider = require(ChromeShared.Flags).FFlagTokenizeUnibarConstantsWithStyleProvider
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local useCursor = Foundation.Hooks.useCursor
local Flags2 = Foundation.Utility.Flags
local StatusIndicator = Foundation.StatusIndicator
local StatusIndicatorVariant = Foundation.Enums.StatusIndicatorVariant
local Interactable = UIBlox.Core.Control.Interactable
local ControlState = UIBlox.Core.Control.Enum.ControlState
local useStyle = UIBlox.Core.Style.useStyle
local withTooltip = UIBlox.App.Dialog.TooltipV2.withTooltip
local Constants = require(ChromeShared.Unibar.Constants)
local Service = require(ChromeShared.Service)
local ChromeAnalytics = require(ChromeShared.Analytics.ChromeAnalytics)
local UnibarStyle = require(CorePackages.Workspace.Packages.Chrome).UnibarStyle
local useObservableValue = require(ChromeShared.Hooks.useObservableValue)
local useNotificationCount = require(ChromeShared.Hooks.useNotificationCount)
local useMappedObservableValue = require(ChromeShared.Hooks.useMappedObservableValue)
local useMappedObservableValueBinding = require(ChromeShared.Hooks.useMappedObservableValueBinding)
local useTimeHysteresis = require(ChromeShared.Hooks.useTimeHysteresis)
local shouldRejectMultiTouch = require(ChromeShared.Utility.shouldRejectMultiTouch)
local ChatNotificationBadge = require(script.Parent.ChatNotificationBadge)
local isInExperienceUIVREnabled = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).isInExperienceUIVREnabled
local isSpatial = nil
local Panel3DInSpatialUI = nil
local PanelType = nil
local TooltipOrientation = nil
local TooltipCallout = nil
local SPATIAL_TOOLTIP_SPACING = nil
local u45 = nil

if isInExperienceUIVREnabled then
	isSpatial = require(CorePackages.Workspace.Packages.AppCommonLib).isSpatial

	local VrSpatialUi = require(CorePackages.Workspace.Packages.VrSpatialUi)

	Panel3DInSpatialUI = VrSpatialUi.Panel3DInSpatialUI
	PanelType = VrSpatialUi.Constants.PanelType
	TooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
	TooltipCallout = UIBlox.App.Dialog.TooltipCallout
	SPATIAL_TOOLTIP_SPACING = VrSpatialUi.Constants.SPATIAL_TOOLTIP_SPACING

	local UIManager = VrSpatialUi.UIManager
	local MappedSignal = require(ChromeShared.Service.ChromeUtils).MappedSignal
	local v49 = UIManager.getInstance():getBottomBarVisibility()

	if v49 and isSpatial() then
		u45 = MappedSignal.new(v49, function() -- line: 79
			-- upvalues: v49 (copy)
			return v49:get()
		end)
	end
end

local v50 = if not FFlagEnableConsoleExpControls then nil else require(ChromeShared.Parent.Parent.TopBar.Components.MenuIconContext)
local v51 = game:DefineFastFlag("UseBindingForUnreadChat", false)
local t1 = {}

function areTooltipsDisplaying() -- line: 101
	-- upvalues: t1 (copy)
	local timestamp = tick()

	for _, v55 in t1 do
		if v55.displaying or timestamp - v55.time < 0.15 then
			return true
		end
	end

	return false
end
function logTooltipState(p1, b1: boolean) -- line: 113
	-- upvalues: t1 (copy)
	if not t1[p1] or b1 ~= t1[p1].displaying then
		t1[p1] = {
			displaying = b1,
			time = tick()
		}
	end
end
function NotificationBadge(t2: {[any]: any}) -- line: 132
	-- upvalues: v51 (copy), React (copy), useNotificationCount (copy), useMappedObservableValue (copy), Service (copy), FFlagTokenizeUnibarConstantsWithStyleProvider (copy), UnibarStyle (copy), Constants (copy), v12 (copy), StatusIndicator (copy), Flags2 (copy), StatusIndicatorVariant (copy)
	if not t2.integration then
		return nil
	end

	local v59 = nil
	local u60 = nil
	local v61 = nil
	local v62 = nil
	local u63 = nil
	local u64 = false

	if v51 then
		local v65 = t2.integration.integration and t2.integration.integration.notification or nil
		local v66

		v59, v66 = React.useBinding(v65 and v65:get().value or 0)
		u60 = v66

		local v67

		v62, v67 = React.useState(false)
		u63 = v67
		React.useEffect(function() -- line: 146
			-- upvalues: v65 (copy), u63 (ref), u60 (ref)
			if not v65 then
				return
			end

			local v120 = v65:connect(function() -- line: 151
				-- upvalues: v65 (copy), u63 (ref), u60 (ref)
				local v146 = v65:get().value or 0

				u63(v146 > 0)
				u60(v146)
			end)

			return function() -- line: 156
				-- upvalues: v120 (copy)
				v120:disconnect()
			end
		end, { t2.integration.integration.id })
	else
		v61 = useNotificationCount(t2.integration.integration)

		if useMappedObservableValue(Service:currentSubMenu(), function(p2) -- line: 164
			-- upvalues: t2 (copy)
			return p2 == t2.integration.id
		end) then
			v61 = 0
		end

		if t2.integration and t2.integration.integration then
			u64 = t2.integration.integration.hideNotificationCountWhileOpen or false
		end
	end

	local ICON_BADGE_OFFSET_X, ICON_BADGE_OFFSET_Y

	if FFlagTokenizeUnibarConstantsWithStyleProvider then
		local v68 = UnibarStyle.use()

		ICON_BADGE_OFFSET_X = v68.ICON_BADGE_OFFSET_X
		ICON_BADGE_OFFSET_Y = v68.ICON_BADGE_OFFSET_Y
	else
		ICON_BADGE_OFFSET_X = Constants.ICON_BADGE_OFFSET_X
		ICON_BADGE_OFFSET_Y = Constants.ICON_BADGE_OFFSET_Y
	end

	local v71 = t2.minBadgeCount or 0
	local v72 = if not v12 then if not v51 then v61 > 0 else v62 else if not v51 then v61 > 0 or v71 > 0 else v62 or v71 > 0
	local v73 = if not v12 then if not v51 then math.min(v61, 99) else v59:map(function(p3) -- line: 211
		return (math.min(p3, 99))
	end) else if not v51 then math.min(math.max(v61, v71), 99) else v59:map(function(p4) -- line: 205
		-- upvalues: v71 (copy)
		return (math.min(math.max(p4, v71), 99))
	end)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		ZIndex = 2,
		Size = UDim2.fromScale(1, 1),
		Visible = not t2.toggleTransition or (t2.toggleTransition:map(function(p5) -- line: 220
			-- upvalues: u64 (ref)
			if u64 then
				return p5 < 0.5
			end

			return true
		end) or true)
	}, {
		Badge = if not v72 then nil else React.createElement(StatusIndicator, {
			value = v73,
			variant = if not Flags2.FoundationStatusIndicatorVariantExperiment then StatusIndicatorVariant.Emphasis else StatusIndicatorVariant.Contrast_Experiment,
			AnchorPoint = Vector2.new(0, 0),
			Position = UDim2.new(0, ICON_BADGE_OFFSET_X, 0, ICON_BADGE_OFFSET_Y)
		})
	})
end
function NotificationIndicator(t3: {[any]: any}) -- line: 249
	-- upvalues: useObservableValue (copy), Service (copy), React (copy)
	local v75 = useObservableValue(Service:notificationIndicator())

	t3.setIconVisible(not v75)

	return (React.createElement("Frame", {
		Name = "NotificationIndicatorFrame",
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		IntegrationIcon = v75 and v75.component(t3) or nil,
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		})
	}))
end
function HighlightCircle(p6) -- line: 268
	-- upvalues: FFlagTokenizeUnibarConstantsWithStyleProvider (copy), UnibarStyle (copy), Constants (copy), React (copy)
	local v77 = if not FFlagTokenizeUnibarConstantsWithStyleProvider then Constants.ICON_HIGHLIGHT_SIZE else UnibarStyle.use().ICON_HIGHLIGHT_SIZE

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		Name = p6.name or "Highlighter",
		Size = v77,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		BackgroundColor3 = p6.color.Color,
		BackgroundTransparency = p6.color.Transparency,
		Visible = p6.visible
	}, {
		corner = React.createElement("UICorner", {
			CornerRadius = UDim.new(1, 0)
		})
	})
end
function TooltipButton(t4: {[any]: any}) -- line: 298
	-- upvalues: FFlagTokenizeUnibarConstantsWithStyleProvider (copy), UnibarStyle (copy), Constants (copy), React (copy), useTimeHysteresis (copy), isInExperienceUIVREnabled (copy), isSpatial (ref), useObservableValue (copy), Service (copy), u45 (ref), ControlState (copy), ChromeAnalytics (copy), UserInputService (copy), shouldRejectMultiTouch (copy), FFlagEnableConsoleExpControls (copy), v50 (copy), Interactable (copy), FFlagUnibarMenuOpenHamburger (copy), FFlagUnibarMenuOpenSubmenu (copy), useCursor (copy), Foundation (copy), Panel3DInSpatialUI (ref), PanelType (ref), SPATIAL_TOOLTIP_SPACING (ref), TooltipCallout (ref), TooltipOrientation (ref), withTooltip (copy), CoreGui (copy)
	local u79 = if not FFlagTokenizeUnibarConstantsWithStyleProvider then Constants.ICON_HIGHLIGHT_SIZE else UnibarStyle.use().ICON_HIGHLIGHT_SIZE
	local v80 = React.useRef(nil)
	local secondaryAction = t4.integration.integration.secondaryAction
	local u82 = t4.integration.integration.draggable or false
	local v83 = React.useRef(nil)

	React.useEffect(function() -- line: 314
		-- upvalues: v83 (copy)
		return function() -- line: 315
			-- upvalues: v83 (copy)
			if v83.current then
				v83.current:Disconnect()
				v83.current = nil
			end
		end
	end, {})

	local v84, u86

	if secondaryAction then
		local v85

		v84, v85 = useTimeHysteresis(0.05, 0.15, 0.35)
		u86 = v85
	else
		local v87

		v84, v87 = useTimeHysteresis(0.6, 0.65, 0.7)
		u86 = v87
	end

	local v88, v89 = useTimeHysteresis(0, 0, 0.65)
	local v90, v91 = React.useState(false)
	local v92, v93 = useTimeHysteresis(0, 1)
	local v94 = if not isInExperienceUIVREnabled then nil else isSpatial()
	local v95 = if not isInExperienceUIVREnabled then nil else useObservableValue(Service:getTopBarVisibiity())
	local v96 = if not isInExperienceUIVREnabled or not u45 then nil else useObservableValue(u45)
	local u97 = false

	if isInExperienceUIVREnabled and v94 and not v95 and not v96 then
		u97 = true
		u82 = u82 and not u97
	end

	local v98 = React.useCallback(function(p7, p8) -- line: 353
		-- upvalues: isInExperienceUIVREnabled (copy), u97 (ref), ControlState (copy), Service (copy), t4 (copy), u86 (ref), v88 (copy), v93 (copy)
		if isInExperienceUIVREnabled and u97 then
			return
		end

		if p8 == ControlState.Selected and (p7 == ControlState.Default or p7 == ControlState.Hover) then
			Service:setSelected(t4.integration.id)
		elseif p8 == ControlState.Selected and p7 == ControlState.Default then
			Service:setSelected(t4.integration.id)
		end

		local v127 = p8 ~= ControlState.Default

		t4.setHovered(v127)

		local v128 = p8 == ControlState.Hover

		u86(v128, v128 and v88 or areTooltipsDisplaying())

		if v128 then
			Service:onIntegrationHovered():fire(t4.integration.id)
		end

		if not v127 then
			v93(false)
		end
	end, if not isInExperienceUIVREnabled then {
		t4.setHovered,
		u86,
		v93,
		v88
	} else {
		t4.setHovered,
		u86,
		v93,
		v88,
		v94,
		u97
	})
	local v99 = React.useCallback(function(_, p10) -- line: 389
		-- upvalues: u82 (ref), v93 (copy), ChromeAnalytics (copy), t4 (copy), v83 (copy), UserInputService (copy), shouldRejectMultiTouch (copy), Service (copy), Constants (copy)
		if not u82 then
			return
		end

		if p10.UserInputType == Enum.UserInputType.MouseButton1 or p10.UserInputType == Enum.UserInputType.Touch then
			local p10Position = p10.Position

			v93(true, true)
			ChromeAnalytics.default:onIconTouchBegan(t4.integration.id)

			if not v83.current then
				v83.current = UserInputService.InputChanged:Connect(function(input, _) -- line: 402
					-- upvalues: shouldRejectMultiTouch (copy), p10 (copy), Service (copy), t4 (copy), v83 (copy), p10Position (copy), Constants (copy), ChromeAnalytics (copy)
					if shouldRejectMultiTouch(p10, input) then
						return
					end

					if Service:isWindowOpen(t4.integration.id) or not v83.current then
						return
					end

					local inputPosition = input.Position

					if math.abs((p10Position - inputPosition).Magnitude) > Constants.DRAG_MAGNITUDE_THRESHOLD then
						ChromeAnalytics.default:onIconDrag(t4.integration.id)
						Service:storeChromeInteracted()
						Service:toggleWindow(t4.integration.id)
						Service:gesture(t4.integration.id, v83, p10)
					end
				end)
			end
		end
	end, { u82 })
	local v100 = React.useCallback(function(_, p13) -- line: 428
		-- upvalues: u82 (ref), v93 (copy), v83 (copy), Service (copy), t4 (copy)
		if not u82 then
			return
		end

		if p13.UserInputType == Enum.UserInputType.MouseButton1 or p13.UserInputType == Enum.UserInputType.Touch then
			v93(false)

			if v83.current then
				v83.current:Disconnect()
				v83.current = nil
				Service:gesture(t4.integration.id, nil)
			end
		end
	end, { u82 })
	local u101 = (v84 or (v88 or v90)) and not v92

	if isInExperienceUIVREnabled and u101 and u97 then
		u101 = false
	end

	logTooltipState(t4.integration.id, u101)

	local v102 = if not FFlagEnableConsoleExpControls then nil else React.useContext(v50)
	local v103 = React.useCallback(function(p14) -- line: 456
		-- upvalues: FFlagEnableConsoleExpControls (copy), Service (copy), React (copy), Interactable (copy), Constants (copy), t4 (copy), u79 (ref), v98 (copy), v80 (copy), FFlagUnibarMenuOpenHamburger (copy), FFlagUnibarMenuOpenSubmenu (copy), useCursor (copy), Foundation (copy), u101 (ref), secondaryAction (copy), v102 (copy), v99 (copy), v100 (copy), isInExperienceUIVREnabled (copy), v94 (copy), u97 (ref), v93 (copy), v83 (copy)
		local id = nil

		if FFlagEnableConsoleExpControls then
			id = Service:menuList():get()[1].id
		end

		return React.createElement(Interactable, {
			Name = (not FFlagEnableConsoleExpControls and "IconHitArea_" or Constants.ICON_NAME_PREFIX) .. t4.integration.id,
			Size = u79,
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			onStateChanged = v98,
			ref = v80,
			SelectionOrder = if not FFlagUnibarMenuOpenHamburger and not FFlagUnibarMenuOpenSubmenu then 100 - t4.integration.order else t4.integration.order,
			Position = t4.isCurrentlyOpenSubMenu:map(function(b2: boolean?) -- line: 474
				-- upvalues: FFlagEnableConsoleExpControls (copy)
				return UDim2.new(0.5, 0, 0.5, (FFlagEnableConsoleExpControls or not b2) and 0 or 1)
			end),
			SelectionImageObject = useCursor(Foundation.Enums.CursorType.SkinToneCircle),
			SelectionGroup = true,
			SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
			SelectionBehaviorDown = t4.isCurrentlyOpenSubMenu:map(function(b3: boolean?) -- line: 480
				-- upvalues: u101 (ref), secondaryAction (copy)
				if u101 and secondaryAction or b3 then
					return Enum.SelectionBehavior.Escape
				end

				return Enum.SelectionBehavior.Stop
			end),
			NextSelectionLeft = if not FFlagEnableConsoleExpControls or id ~= t4.integration.id then nil else v102.menuIconRef,
			[React.Change.AbsolutePosition] = p14,
			[React.Change.AbsoluteSize] = p14,
			[React.Event.InputBegan] = v99,
			[React.Event.InputEnded] = v100,
			[React.Event.Activated] = function() -- line: 494
				-- upvalues: isInExperienceUIVREnabled (copy), v94 (copy), u97 (ref), Service (copy), v93 (copy), t4 (copy), v83 (copy)
				if isInExperienceUIVREnabled and v94 then
					if u97 then
						return
					end

					Service:onTriggerVRToggleButton():fire(true)
				end

				v93(true, true)
				t4.integration.activated()

				if v83.current then
					v83.current:Disconnect()
					v83.current = nil
					Service:gesture(t4.integration.id, nil)
				end
			end
		}, {
			corner = React.createElement("UICorner", {
				CornerRadius = UDim.new(1, 0)
			})
		})
	end, {
		v98,
		u86,
		v93,
		v99,
		v100,
		t4.isCurrentlyOpenSubMenu,
		u101,
		secondaryAction,
		if not isInExperienceUIVREnabled then nil else u97,
		if not FFlagEnableConsoleExpControls then nil else v102.menuIconRef
	})
	local v104 = React.useRef(nil)
	local v105 = React.useCallback(function(p15) -- line: 531
		-- upvalues: v104 (copy), v89 (copy)
		local u137 = nil
		local u138 = nil
		local u139 = nil

		if p15 ~= v104.current then
			pcall(function() -- line: 538
				-- upvalues: u137 (ref), u138 (ref), u139 (ref)
				if u137 then
					u137:disconnect()
					u137 = nil
				end

				if u138 then
					u138:disconnect()
					u138 = nil
				end

				if u139 then
					u139:disconnect()
					u139 = nil
				end
			end)

			if p15 then
				u137 = p15.MouseEnter:Connect(function() -- line: 556
					-- upvalues: v89 (copy)
					v89(true, true)
				end)
				u138 = p15.MouseLeave:Connect(function() -- line: 559
					-- upvalues: v89 (copy)
					v89(false)
				end)
				u139 = p15.Destroying:Connect(function() -- line: 562
					-- upvalues: v89 (copy)
					v89(false)
				end)
			end

			v104.current = p15
		end
	end, { v89 })
	local v106 = if not secondaryAction then nil else {
		text = secondaryAction.label,
		onStateChanged = function(_, p17) -- line: 573
			-- upvalues: ControlState (copy), v91 (copy)
			if p17 == ControlState.Selected then
				v91(true)

				return
			end

			v91(false)
		end,
		onActivated = function() -- line: 580
			-- upvalues: secondaryAction (copy), t4 (copy)
			secondaryAction.activated(t4.integration)
		end,
		NextSelectionUp = v80,
		NextSelectionLeft = v80,
		NextSelectionRight = v80,
		NextSelectionDown = v80
	}

	if isInExperienceUIVREnabled and v94 then
		local v107, v108 = React.useBinding(Vector2.zero)
		local v109, v110 = React.useBinding(Vector2.zero)
		local v111 = React.useCallback(function(p18) -- line: 594
			-- upvalues: v108 (copy), v110 (copy)
			v108(p18.AbsolutePosition)
			v110(p18.AbsoluteSize)
		end, {
			v108,
			v110
		})

		return React.createElement(React.Fragment, nil, {
			VRSpatialTooltip = if not u101 or not Panel3DInSpatialUI then nil else React.createElement(Panel3DInSpatialUI, {
				panelType = PanelType.ToolTipsContainer,
				renderFunction = function(vector2: Vector2) -- line: 606
					-- upvalues: v107 (copy), v109 (copy), SPATIAL_TOOLTIP_SPACING (ref), React (copy), TooltipCallout (ref), t4 (copy), TooltipOrientation (ref), v106 (copy), secondaryAction (copy), v105 (copy)
					local vector2_2 = Vector2.new(v107:getValue().X + v109:getValue().X / 2, vector2.Y - SPATIAL_TOOLTIP_SPACING)

					return React.createElement(TooltipCallout, {
						distanceOffset = 0,
						textAlignment = Enum.TextXAlignment.Center,
						headerText = t4.integration.integration.label,
						orientation = TooltipOrientation.Top,
						triggerPointCenter = vector2_2,
						contentOffsetVector = Vector2.zero,
						triggerPointRadius = Vector2.zero,
						buttonProps = v106,
						ref = if not secondaryAction then nil else v105
					})
				end
			}),
			v103(v111)
		})
	end

	return withTooltip({
		headerText = t4.integration.integration.label,
		hotkeyCodes = t4.integration.integration.hotkeyCodes,
		textAlignment = Enum.TextXAlignment.Left,
		buttonProps = v106,
		ref = if not secondaryAction then nil else v105
	}, {
		DisplayOrder = 10,
		active = u101,
		guiTarget = CoreGui
	}, v103)
end
function IconHost(t5: {[any]: any}) -- line: 645
	-- upvalues: React (copy), useStyle (copy), FFlagTokenizeUnibarConstantsWithStyleProvider (copy), UnibarStyle (copy), Constants (copy), useMappedObservableValueBinding (copy), Service (copy), FFlagEnableConsoleExpControls (copy), v12 (copy), ChatNotificationBadge (copy)
	if not t5.integration or not t5.integration.component then
		warn("IconHost has no component to render")
	end

	local v113, v114 = React.useBinding(false)
	local v115, v116 = React.useBinding(true)
	local BackgroundOnHover = useStyle().Theme.BackgroundOnHover
	local v118 = if not FFlagTokenizeUnibarConstantsWithStyleProvider then Constants.ICON_CELL_WIDTH else UnibarStyle.use().ICON_CELL_WIDTH
	local v119 = useMappedObservableValueBinding(Service:currentSubMenu(), function(p19) -- line: 668
		-- upvalues: t5 (copy)
		return p19 == t5.integration.id
	end)

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Size = UDim2.new(0, v118, 0, v118),
		LayoutOrder = t5.integration.order,
		Position = t5.position,
		Visible = t5.visible,
		ZIndex = if not FFlagEnableConsoleExpControls then t5.integration.order else nil
	}, {
		React.createElement("Frame", {
			Name = "IntegrationIconFrame",
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Visible = v115
		}, {
			IntegrationIcon = t5.integration and (not not t5.integration.component and t5.integration.component(t5)) or nil,
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			})
		}),
		if not t5.integration.integration.flashNotificationSource then nil else React.createElement(NotificationIndicator, {
			integration = t5.integration,
			setIconVisible = v116
		}),
		React.createElement(HighlightCircle, {
			name = "SelectedHighlighter",
			color = BackgroundOnHover,
			visible = v119
		}),
		React.createElement(HighlightCircle, {
			name = "Highlighter",
			color = BackgroundOnHover,
			visible = v113
		}),
		if not v12 or t5.integration.id ~= "chat" then React.createElement(NotificationBadge, t5) else React.createElement(ChatNotificationBadge, {
			iconHostProps = t5,
			NotificationBadge = NotificationBadge
		}),
		if not t5.disableButtonBehaviors then React.createElement(TooltipButton, {
			integration = t5.integration,
			setHovered = v114,
			isCurrentlyOpenSubMenu = v119
		}) else nil
	})
end

return IconHost
