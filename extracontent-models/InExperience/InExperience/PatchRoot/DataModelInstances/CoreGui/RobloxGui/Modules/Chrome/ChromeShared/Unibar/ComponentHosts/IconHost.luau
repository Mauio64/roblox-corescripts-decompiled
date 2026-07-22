local ChromeShared = script:FindFirstAncestor("ChromeShared")
local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local React = require(CorePackages.Packages.React)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local FFlagExpChatShowGlobalChatTooltip = SharedFlags.FFlagExpChatShowGlobalChatTooltip
local FFlagEnableWhatsNew = SharedFlags.FFlagEnableWhatsNew
local v10 = if not FFlagEnableWhatsNew then nil else require(CorePackages.Workspace.Packages.WhatsNew).WhatsNewAnchor
local ExpChatShared = require(CorePackages.Workspace.Packages.ExpChatShared)
local FFlagExpChatPresetChatEnabled = ExpChatShared.Flags.FFlagExpChatPresetChatEnabled
local FFlagExpChatUseUnifiedTooltipStore = ExpChatShared.Flags.FFlagExpChatUseUnifiedTooltipStore
local v14 = FFlagExpChatShowGlobalChatTooltip or FFlagExpChatPresetChatEnabled and FFlagExpChatUseUnifiedTooltipStore
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
local u47 = nil

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
	local v51 = UIManager.getInstance():getBottomBarVisibility()

	if v51 and isSpatial() then
		u47 = MappedSignal.new(v51, function() -- line: 84
			-- upvalues: v51 (copy)
			return v51:get()
		end)
	end
end

local v52 = if not FFlagEnableConsoleExpControls then nil else require(ChromeShared.Parent.Parent.TopBar.Components.MenuIconContext)
local v53 = game:DefineFastFlag("UseBindingForUnreadChat", false)
local t1 = {}

function areTooltipsDisplaying() -- line: 106
	-- upvalues: t1 (copy)
	local timestamp = tick()

	for _, v57 in t1 do
		if v57.displaying or timestamp - v57.time < 0.15 then
			return true
		end
	end

	return false
end
function logTooltipState(p1, b1: boolean) -- line: 118
	-- upvalues: t1 (copy)
	if not t1[p1] or b1 ~= t1[p1].displaying then
		t1[p1] = {
			displaying = b1,
			time = tick()
		}
	end
end
function NotificationBadge(t2: {[any]: any}) -- line: 137
	-- upvalues: v53 (copy), React (copy), useNotificationCount (copy), useMappedObservableValue (copy), Service (copy), FFlagTokenizeUnibarConstantsWithStyleProvider (copy), UnibarStyle (copy), Constants (copy), v14 (copy), StatusIndicator (copy), Flags2 (copy), StatusIndicatorVariant (copy)
	if not t2.integration then
		return nil
	end

	local v61 = nil
	local u62 = nil
	local v63 = nil
	local v64 = nil
	local u65 = nil
	local u66 = false

	if v53 then
		local v67 = t2.integration.integration and t2.integration.integration.notification or nil
		local v68

		v61, v68 = React.useBinding(v67 and v67:get().value or 0)
		u62 = v68

		local v69

		v64, v69 = React.useState(false)
		u65 = v69
		React.useEffect(function() -- line: 151
			-- upvalues: v67 (copy), u65 (ref), u62 (ref)
			if not v67 then
				return
			end

			local v124 = v67:connect(function() -- line: 156
				-- upvalues: v67 (copy), u65 (ref), u62 (ref)
				local v150 = v67:get().value or 0

				u65(v150 > 0)
				u62(v150)
			end)

			return function() -- line: 161
				-- upvalues: v124 (copy)
				v124:disconnect()
			end
		end, { t2.integration.integration.id })
	else
		v63 = useNotificationCount(t2.integration.integration)

		if useMappedObservableValue(Service:currentSubMenu(), function(p2) -- line: 169
			-- upvalues: t2 (copy)
			return p2 == t2.integration.id
		end) then
			v63 = 0
		end

		if t2.integration and t2.integration.integration then
			u66 = t2.integration.integration.hideNotificationCountWhileOpen or false
		end
	end

	local ICON_BADGE_OFFSET_X, ICON_BADGE_OFFSET_Y

	if FFlagTokenizeUnibarConstantsWithStyleProvider then
		local v70 = UnibarStyle.use()

		ICON_BADGE_OFFSET_X = v70.ICON_BADGE_OFFSET_X
		ICON_BADGE_OFFSET_Y = v70.ICON_BADGE_OFFSET_Y
	else
		ICON_BADGE_OFFSET_X = Constants.ICON_BADGE_OFFSET_X
		ICON_BADGE_OFFSET_Y = Constants.ICON_BADGE_OFFSET_Y
	end

	local v73 = t2.minBadgeCount or 0
	local v74 = if not v14 then if not v53 then v63 > 0 else v64 else if not v53 then v63 > 0 or v73 > 0 else v64 or v73 > 0
	local v75 = if not v14 then if not v53 then math.min(v63, 99) else v61:map(function(p3) -- line: 216
		return (math.min(p3, 99))
	end) else if not v53 then math.min(math.max(v63, v73), 99) else v61:map(function(p4) -- line: 210
		-- upvalues: v73 (copy)
		return (math.min(math.max(p4, v73), 99))
	end)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		ZIndex = 2,
		Size = UDim2.fromScale(1, 1),
		Visible = not t2.toggleTransition or (t2.toggleTransition:map(function(p5) -- line: 225
			-- upvalues: u66 (ref)
			if u66 then
				return p5 < 0.5
			end

			return true
		end) or true)
	}, {
		Badge = if not v74 then nil else React.createElement(StatusIndicator, {
			value = v75,
			variant = if not Flags2.FoundationStatusIndicatorVariantExperiment then StatusIndicatorVariant.Emphasis else StatusIndicatorVariant.Contrast_Experiment,
			AnchorPoint = Vector2.new(0, 0),
			Position = UDim2.new(0, ICON_BADGE_OFFSET_X, 0, ICON_BADGE_OFFSET_Y)
		})
	})
end
function NotificationIndicator(t3: {[any]: any}) -- line: 254
	-- upvalues: useObservableValue (copy), Service (copy), React (copy)
	local v77 = useObservableValue(Service:notificationIndicator())

	t3.setIconVisible(not v77)

	return (React.createElement("Frame", {
		Name = "NotificationIndicatorFrame",
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		IntegrationIcon = v77 and v77.component(t3) or nil,
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		})
	}))
end
function HighlightCircle(p6) -- line: 273
	-- upvalues: FFlagTokenizeUnibarConstantsWithStyleProvider (copy), UnibarStyle (copy), Constants (copy), React (copy)
	local v79 = if not FFlagTokenizeUnibarConstantsWithStyleProvider then Constants.ICON_HIGHLIGHT_SIZE else UnibarStyle.use().ICON_HIGHLIGHT_SIZE

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		Name = p6.name or "Highlighter",
		Size = v79,
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
function TooltipButton(t4: {[any]: any}) -- line: 303
	-- upvalues: FFlagTokenizeUnibarConstantsWithStyleProvider (copy), UnibarStyle (copy), Constants (copy), React (copy), useTimeHysteresis (copy), isInExperienceUIVREnabled (copy), isSpatial (ref), useObservableValue (copy), Service (copy), u47 (ref), ControlState (copy), ChromeAnalytics (copy), UserInputService (copy), shouldRejectMultiTouch (copy), FFlagEnableConsoleExpControls (copy), v52 (copy), Interactable (copy), FFlagUnibarMenuOpenHamburger (copy), FFlagUnibarMenuOpenSubmenu (copy), useCursor (copy), Foundation (copy), Panel3DInSpatialUI (ref), PanelType (ref), SPATIAL_TOOLTIP_SPACING (ref), TooltipCallout (ref), TooltipOrientation (ref), withTooltip (copy), CoreGui (copy)
	local u81 = if not FFlagTokenizeUnibarConstantsWithStyleProvider then Constants.ICON_HIGHLIGHT_SIZE else UnibarStyle.use().ICON_HIGHLIGHT_SIZE
	local v82 = React.useRef(nil)
	local secondaryAction = t4.integration.integration.secondaryAction
	local u84 = t4.integration.integration.draggable or false
	local v85 = React.useRef(nil)

	React.useEffect(function() -- line: 319
		-- upvalues: v85 (copy)
		return function() -- line: 320
			-- upvalues: v85 (copy)
			if v85.current then
				v85.current:Disconnect()
				v85.current = nil
			end
		end
	end, {})

	local v86, u88

	if secondaryAction then
		local v87

		v86, v87 = useTimeHysteresis(0.05, 0.15, 0.35)
		u88 = v87
	else
		local v89

		v86, v89 = useTimeHysteresis(0.6, 0.65, 0.7)
		u88 = v89
	end

	local v90, v91 = useTimeHysteresis(0, 0, 0.65)
	local v92, v93 = React.useState(false)
	local v94, v95 = useTimeHysteresis(0, 1)
	local v96 = if not isInExperienceUIVREnabled then nil else isSpatial()
	local v97 = if not isInExperienceUIVREnabled then nil else useObservableValue(Service:getTopBarVisibiity())
	local v98 = if not isInExperienceUIVREnabled or not u47 then nil else useObservableValue(u47)
	local u99 = false

	if isInExperienceUIVREnabled and v96 and not v97 and not v98 then
		u99 = true
		u84 = u84 and not u99
	end

	local v100 = React.useCallback(function(p7, p8) -- line: 358
		-- upvalues: isInExperienceUIVREnabled (copy), u99 (ref), ControlState (copy), Service (copy), t4 (copy), u88 (ref), v90 (copy), v95 (copy)
		if isInExperienceUIVREnabled and u99 then
			return
		end

		if p8 == ControlState.Selected and (p7 == ControlState.Default or p7 == ControlState.Hover) then
			Service:setSelected(t4.integration.id)
		elseif p8 == ControlState.Selected and p7 == ControlState.Default then
			Service:setSelected(t4.integration.id)
		end

		local v131 = p8 ~= ControlState.Default

		t4.setHovered(v131)

		local v132 = p8 == ControlState.Hover

		u88(v132, v132 and v90 or areTooltipsDisplaying())

		if v132 then
			Service:onIntegrationHovered():fire(t4.integration.id)
		end

		if not v131 then
			v95(false)
		end
	end, if not isInExperienceUIVREnabled then {
		t4.setHovered,
		u88,
		v95,
		v90
	} else {
		t4.setHovered,
		u88,
		v95,
		v90,
		v96,
		u99
	})
	local v101 = React.useCallback(function(_, p10) -- line: 394
		-- upvalues: u84 (ref), v95 (copy), ChromeAnalytics (copy), t4 (copy), v85 (copy), UserInputService (copy), shouldRejectMultiTouch (copy), Service (copy), Constants (copy)
		if not u84 then
			return
		end

		if p10.UserInputType == Enum.UserInputType.MouseButton1 or p10.UserInputType == Enum.UserInputType.Touch then
			local p10Position = p10.Position

			v95(true, true)
			ChromeAnalytics.default:onIconTouchBegan(t4.integration.id)

			if not v85.current then
				v85.current = UserInputService.InputChanged:Connect(function(input, _) -- line: 407
					-- upvalues: shouldRejectMultiTouch (copy), p10 (copy), Service (copy), t4 (copy), v85 (copy), p10Position (copy), Constants (copy), ChromeAnalytics (copy)
					if shouldRejectMultiTouch(p10, input) then
						return
					end

					if Service:isWindowOpen(t4.integration.id) or not v85.current then
						return
					end

					local inputPosition = input.Position

					if math.abs((p10Position - inputPosition).Magnitude) > Constants.DRAG_MAGNITUDE_THRESHOLD then
						ChromeAnalytics.default:onIconDrag(t4.integration.id)
						Service:storeChromeInteracted()
						Service:toggleWindow(t4.integration.id)
						Service:gesture(t4.integration.id, v85, p10)
					end
				end)
			end
		end
	end, { u84 })
	local v102 = React.useCallback(function(_, p13) -- line: 433
		-- upvalues: u84 (ref), v95 (copy), v85 (copy), Service (copy), t4 (copy)
		if not u84 then
			return
		end

		if p13.UserInputType == Enum.UserInputType.MouseButton1 or p13.UserInputType == Enum.UserInputType.Touch then
			v95(false)

			if v85.current then
				v85.current:Disconnect()
				v85.current = nil
				Service:gesture(t4.integration.id, nil)
			end
		end
	end, { u84 })
	local u103 = (v86 or (v90 or v92)) and not v94

	if isInExperienceUIVREnabled and u103 and u99 then
		u103 = false
	end

	logTooltipState(t4.integration.id, u103)

	local v104 = if not FFlagEnableConsoleExpControls then nil else React.useContext(v52)
	local v105 = React.useCallback(function(p14) -- line: 461
		-- upvalues: FFlagEnableConsoleExpControls (copy), Service (copy), React (copy), Interactable (copy), Constants (copy), t4 (copy), u81 (ref), v100 (copy), v82 (copy), FFlagUnibarMenuOpenHamburger (copy), FFlagUnibarMenuOpenSubmenu (copy), useCursor (copy), Foundation (copy), u103 (ref), secondaryAction (copy), v104 (copy), v101 (copy), v102 (copy), isInExperienceUIVREnabled (copy), v96 (copy), u99 (ref), v95 (copy), v85 (copy)
		local id = nil

		if FFlagEnableConsoleExpControls then
			id = Service:menuList():get()[1].id
		end

		return React.createElement(Interactable, {
			Name = (not FFlagEnableConsoleExpControls and "IconHitArea_" or Constants.ICON_NAME_PREFIX) .. t4.integration.id,
			Size = u81,
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			onStateChanged = v100,
			ref = v82,
			SelectionOrder = if not FFlagUnibarMenuOpenHamburger and not FFlagUnibarMenuOpenSubmenu then 100 - t4.integration.order else t4.integration.order,
			Position = t4.isCurrentlyOpenSubMenu:map(function(b2: boolean?) -- line: 479
				-- upvalues: FFlagEnableConsoleExpControls (copy)
				return UDim2.new(0.5, 0, 0.5, (FFlagEnableConsoleExpControls or not b2) and 0 or 1)
			end),
			SelectionImageObject = useCursor(Foundation.Enums.CursorType.SkinToneCircle),
			SelectionGroup = true,
			SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
			SelectionBehaviorDown = t4.isCurrentlyOpenSubMenu:map(function(b3: boolean?) -- line: 485
				-- upvalues: u103 (ref), secondaryAction (copy)
				if u103 and secondaryAction or b3 then
					return Enum.SelectionBehavior.Escape
				end

				return Enum.SelectionBehavior.Stop
			end),
			NextSelectionLeft = if not FFlagEnableConsoleExpControls or id ~= t4.integration.id then nil else v104.menuIconRef,
			[React.Change.AbsolutePosition] = p14,
			[React.Change.AbsoluteSize] = p14,
			[React.Event.InputBegan] = v101,
			[React.Event.InputEnded] = v102,
			[React.Event.Activated] = function() -- line: 499
				-- upvalues: isInExperienceUIVREnabled (copy), v96 (copy), u99 (ref), Service (copy), v95 (copy), t4 (copy), v85 (copy)
				if isInExperienceUIVREnabled and v96 then
					if u99 then
						return
					end

					Service:onTriggerVRToggleButton():fire(true)
				end

				v95(true, true)
				t4.integration.activated()

				if v85.current then
					v85.current:Disconnect()
					v85.current = nil
					Service:gesture(t4.integration.id, nil)
				end
			end
		}, {
			corner = React.createElement("UICorner", {
				CornerRadius = UDim.new(1, 0)
			})
		})
	end, {
		v100,
		u88,
		v95,
		v101,
		v102,
		t4.isCurrentlyOpenSubMenu,
		u103,
		secondaryAction,
		if not isInExperienceUIVREnabled then nil else u99,
		if not FFlagEnableConsoleExpControls then nil else v104.menuIconRef
	})
	local v106 = React.useRef(nil)
	local v107 = React.useCallback(function(p15) -- line: 536
		-- upvalues: v106 (copy), v91 (copy)
		local u141 = nil
		local u142 = nil
		local u143 = nil

		if p15 ~= v106.current then
			pcall(function() -- line: 543
				-- upvalues: u141 (ref), u142 (ref), u143 (ref)
				if u141 then
					u141:disconnect()
					u141 = nil
				end

				if u142 then
					u142:disconnect()
					u142 = nil
				end

				if u143 then
					u143:disconnect()
					u143 = nil
				end
			end)

			if p15 then
				u141 = p15.MouseEnter:Connect(function() -- line: 561
					-- upvalues: v91 (copy)
					v91(true, true)
				end)
				u142 = p15.MouseLeave:Connect(function() -- line: 564
					-- upvalues: v91 (copy)
					v91(false)
				end)
				u143 = p15.Destroying:Connect(function() -- line: 567
					-- upvalues: v91 (copy)
					v91(false)
				end)
			end

			v106.current = p15
		end
	end, { v91 })
	local v108 = if not secondaryAction then nil else {
		text = secondaryAction.label,
		onStateChanged = function(_, p17) -- line: 578
			-- upvalues: ControlState (copy), v93 (copy)
			if p17 == ControlState.Selected then
				v93(true)

				return
			end

			v93(false)
		end,
		onActivated = function() -- line: 585
			-- upvalues: secondaryAction (copy), t4 (copy)
			secondaryAction.activated(t4.integration)
		end,
		NextSelectionUp = v82,
		NextSelectionLeft = v82,
		NextSelectionRight = v82,
		NextSelectionDown = v82
	}

	if isInExperienceUIVREnabled and v96 then
		local v109, v110 = React.useBinding(Vector2.zero)
		local v111, v112 = React.useBinding(Vector2.zero)
		local v113 = React.useCallback(function(p18) -- line: 599
			-- upvalues: v110 (copy), v112 (copy)
			v110(p18.AbsolutePosition)
			v112(p18.AbsoluteSize)
		end, {
			v110,
			v112
		})

		return React.createElement(React.Fragment, nil, {
			VRSpatialTooltip = if not u103 or not Panel3DInSpatialUI then nil else React.createElement(Panel3DInSpatialUI, {
				panelType = PanelType.ToolTipsContainer,
				renderFunction = function(vector2: Vector2) -- line: 611
					-- upvalues: v109 (copy), v111 (copy), SPATIAL_TOOLTIP_SPACING (ref), React (copy), TooltipCallout (ref), t4 (copy), TooltipOrientation (ref), v108 (copy), secondaryAction (copy), v107 (copy)
					local vector2_2 = Vector2.new(v109:getValue().X + v111:getValue().X / 2, vector2.Y - SPATIAL_TOOLTIP_SPACING)

					return React.createElement(TooltipCallout, {
						distanceOffset = 0,
						textAlignment = Enum.TextXAlignment.Center,
						headerText = t4.integration.integration.label,
						orientation = TooltipOrientation.Top,
						triggerPointCenter = vector2_2,
						contentOffsetVector = Vector2.zero,
						triggerPointRadius = Vector2.zero,
						buttonProps = v108,
						ref = if not secondaryAction then nil else v107
					})
				end
			}),
			v105(v113)
		})
	end

	return withTooltip({
		headerText = t4.integration.integration.label,
		hotkeyCodes = t4.integration.integration.hotkeyCodes,
		textAlignment = Enum.TextXAlignment.Left,
		buttonProps = v108,
		ref = if not secondaryAction then nil else v107
	}, {
		DisplayOrder = 10,
		active = u103,
		guiTarget = CoreGui
	}, v105)
end
function IconHost(t5: {[any]: any}) -- line: 650
	-- upvalues: React (copy), useStyle (copy), FFlagTokenizeUnibarConstantsWithStyleProvider (copy), UnibarStyle (copy), Constants (copy), useMappedObservableValueBinding (copy), Service (copy), v14 (copy), ChatNotificationBadge (copy), FFlagEnableConsoleExpControls (copy), FFlagEnableWhatsNew (copy), v10 (copy)
	if not t5.integration or not t5.integration.component then
		warn("IconHost has no component to render")
	end

	local v115, v116 = React.useBinding(false)
	local v117, v118 = React.useBinding(true)
	local BackgroundOnHover = useStyle().Theme.BackgroundOnHover
	local v120 = if not FFlagTokenizeUnibarConstantsWithStyleProvider then Constants.ICON_CELL_WIDTH else UnibarStyle.use().ICON_CELL_WIDTH
	local v121 = useMappedObservableValueBinding(Service:currentSubMenu(), function(p19) -- line: 673
		-- upvalues: t5 (copy)
		return p19 == t5.integration.id
	end)
	local t6 = {
		React.createElement("Frame", {
			Name = "IntegrationIconFrame",
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Visible = v117
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
			setIconVisible = v118
		}),
		React.createElement(HighlightCircle, {
			name = "SelectedHighlighter",
			color = BackgroundOnHover,
			visible = v121
		}),
		React.createElement(HighlightCircle, {
			name = "Highlighter",
			color = BackgroundOnHover,
			visible = v115
		}),
		if not v14 or t5.integration.id ~= "chat" then React.createElement(NotificationBadge, t5) else React.createElement(ChatNotificationBadge, {
			iconHostProps = t5,
			NotificationBadge = NotificationBadge
		}),
		if not t5.disableButtonBehaviors then React.createElement(TooltipButton, {
			integration = t5.integration,
			setHovered = v116,
			isCurrentlyOpenSubMenu = v121
		}) else nil
	}
	local t7 = {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Size = UDim2.new(0, v120, 0, v120),
		LayoutOrder = t5.integration.order,
		Position = t5.position,
		Visible = t5.visible,
		ZIndex = if not FFlagEnableConsoleExpControls then t5.integration.order else nil
	}

	if FFlagEnableWhatsNew then
		return React.createElement("Frame", t7, {
			WhatsNewAnchor = React.createElement(v10, {
				tag = "size-full",
				anchorId = t5.integration.id
			}, t6)
		})
	end

	return React.createElement("Frame", t7, t6)
end

return IconHost
