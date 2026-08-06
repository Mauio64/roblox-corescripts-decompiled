local ChromeShared = script:FindFirstAncestor("ChromeShared")
local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local React = require(CorePackages.Packages.React)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local FFlagEnableWhatsNew = SharedFlags.FFlagEnableWhatsNew
local v9 = if not FFlagEnableWhatsNew then nil else require(CorePackages.Workspace.Packages.WhatsNew).WhatsNewAnchor
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
local u42 = nil

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
	local v46 = UIManager.getInstance():getBottomBarVisibility()

	if v46 and isSpatial() then
		u42 = MappedSignal.new(v46, function() -- line: 76
			-- upvalues: v46 (copy)
			return v46:get()
		end)
	end
end

local v47 = if not FFlagEnableConsoleExpControls then nil else require(ChromeShared.Parent.Parent.TopBar.Components.MenuIconContext)
local v48 = game:DefineFastFlag("UseBindingForUnreadChat", false)
local t1 = {}

function areTooltipsDisplaying() -- line: 98
	-- upvalues: t1 (copy)
	local timestamp = tick()

	for _, v52 in t1 do
		if v52.displaying or timestamp - v52.time < 0.15 then
			return true
		end
	end

	return false
end
function logTooltipState(p1, b1: boolean) -- line: 110
	-- upvalues: t1 (copy)
	if not t1[p1] or b1 ~= t1[p1].displaying then
		t1[p1] = {
			displaying = b1,
			time = tick()
		}
	end
end
function NotificationBadge(t2: {[any]: any}) -- line: 129
	-- upvalues: v48 (copy), React (copy), useNotificationCount (copy), useMappedObservableValue (copy), Service (copy), FFlagTokenizeUnibarConstantsWithStyleProvider (copy), UnibarStyle (copy), Constants (copy), StatusIndicator (copy), Flags2 (copy), StatusIndicatorVariant (copy)
	if not t2.integration then
		return nil
	end

	local v56 = nil
	local u57 = nil
	local v58 = nil
	local v59 = nil
	local u60 = nil
	local u61 = false

	if v48 then
		local v62 = t2.integration.integration and t2.integration.integration.notification or nil
		local v63

		v56, v63 = React.useBinding(v62 and v62:get().value or 0)
		u57 = v63

		local v64

		v59, v64 = React.useState(false)
		u60 = v64
		React.useEffect(function() -- line: 143
			-- upvalues: v62 (copy), u60 (ref), u57 (ref)
			if not v62 then
				return
			end

			local v119 = v62:connect(function() -- line: 148
				-- upvalues: v62 (copy), u60 (ref), u57 (ref)
				local v144 = v62:get().value or 0

				u60(v144 > 0)
				u57(v144)
			end)

			return function() -- line: 153
				-- upvalues: v119 (copy)
				v119:disconnect()
			end
		end, { t2.integration.integration.id })
	else
		v58 = useNotificationCount(t2.integration.integration)

		if useMappedObservableValue(Service:currentSubMenu(), function(p2) -- line: 161
			-- upvalues: t2 (copy)
			return p2 == t2.integration.id
		end) then
			v58 = 0
		end

		if t2.integration and t2.integration.integration then
			u61 = t2.integration.integration.hideNotificationCountWhileOpen or false
		end
	end

	local ICON_BADGE_OFFSET_X, ICON_BADGE_OFFSET_Y

	if FFlagTokenizeUnibarConstantsWithStyleProvider then
		local v65 = UnibarStyle.use()

		ICON_BADGE_OFFSET_X = v65.ICON_BADGE_OFFSET_X
		ICON_BADGE_OFFSET_Y = v65.ICON_BADGE_OFFSET_Y
	else
		ICON_BADGE_OFFSET_X = Constants.ICON_BADGE_OFFSET_X
		ICON_BADGE_OFFSET_Y = Constants.ICON_BADGE_OFFSET_Y
	end

	local v68 = t2.minBadgeCount or 0
	local v69 = if not v48 then v58 > 0 or v68 > 0 else v59 or v68 > 0
	local v70 = if not v48 then math.min(math.max(v58, v68), 99) else v56:map(function(p3) -- line: 196
		-- upvalues: v68 (copy)
		return (math.min(math.max(p3, v68), 99))
	end)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		ZIndex = 2,
		Size = UDim2.fromScale(1, 1),
		Visible = not t2.toggleTransition or (t2.toggleTransition:map(function(p4) -- line: 204
			-- upvalues: u61 (ref)
			if u61 then
				return p4 < 0.5
			end

			return true
		end) or true)
	}, {
		Badge = if not v69 then nil else React.createElement(StatusIndicator, {
			value = v70,
			variant = if not Flags2.FoundationStatusIndicatorVariantExperiment then StatusIndicatorVariant.Emphasis else StatusIndicatorVariant.Contrast_Experiment,
			AnchorPoint = Vector2.new(0, 0),
			Position = UDim2.new(0, ICON_BADGE_OFFSET_X, 0, ICON_BADGE_OFFSET_Y)
		})
	})
end
function NotificationIndicator(t3: {[any]: any}) -- line: 233
	-- upvalues: useObservableValue (copy), Service (copy), React (copy)
	local v72 = useObservableValue(Service:notificationIndicator())

	t3.setIconVisible(not v72)

	return (React.createElement("Frame", {
		Name = "NotificationIndicatorFrame",
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		IntegrationIcon = v72 and v72.component(t3) or nil,
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		})
	}))
end
function HighlightCircle(p5) -- line: 252
	-- upvalues: FFlagTokenizeUnibarConstantsWithStyleProvider (copy), UnibarStyle (copy), Constants (copy), React (copy)
	local v74 = if not FFlagTokenizeUnibarConstantsWithStyleProvider then Constants.ICON_HIGHLIGHT_SIZE else UnibarStyle.use().ICON_HIGHLIGHT_SIZE

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		Name = p5.name or "Highlighter",
		Size = v74,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		BackgroundColor3 = p5.color.Color,
		BackgroundTransparency = p5.color.Transparency,
		Visible = p5.visible
	}, {
		corner = React.createElement("UICorner", {
			CornerRadius = UDim.new(1, 0)
		})
	})
end
function TooltipButton(t4: {[any]: any}) -- line: 282
	-- upvalues: FFlagTokenizeUnibarConstantsWithStyleProvider (copy), UnibarStyle (copy), Constants (copy), React (copy), useTimeHysteresis (copy), isInExperienceUIVREnabled (copy), isSpatial (ref), useObservableValue (copy), Service (copy), u42 (ref), ControlState (copy), ChromeAnalytics (copy), UserInputService (copy), shouldRejectMultiTouch (copy), FFlagEnableConsoleExpControls (copy), v47 (copy), Interactable (copy), FFlagUnibarMenuOpenHamburger (copy), FFlagUnibarMenuOpenSubmenu (copy), useCursor (copy), Foundation (copy), Panel3DInSpatialUI (ref), PanelType (ref), SPATIAL_TOOLTIP_SPACING (ref), TooltipCallout (ref), TooltipOrientation (ref), withTooltip (copy), CoreGui (copy)
	local u76 = if not FFlagTokenizeUnibarConstantsWithStyleProvider then Constants.ICON_HIGHLIGHT_SIZE else UnibarStyle.use().ICON_HIGHLIGHT_SIZE
	local v77 = React.useRef(nil)
	local secondaryAction = t4.integration.integration.secondaryAction
	local u79 = t4.integration.integration.draggable or false
	local v80 = React.useRef(nil)

	React.useEffect(function() -- line: 298
		-- upvalues: v80 (copy)
		return function() -- line: 299
			-- upvalues: v80 (copy)
			if v80.current then
				v80.current:Disconnect()
				v80.current = nil
			end
		end
	end, {})

	local v81, u83

	if secondaryAction then
		local v82

		v81, v82 = useTimeHysteresis(0.05, 0.15, 0.35)
		u83 = v82
	else
		local v84

		v81, v84 = useTimeHysteresis(0.6, 0.65, 0.7)
		u83 = v84
	end

	local v85, v86 = useTimeHysteresis(0, 0, 0.65)
	local v87, v88 = React.useState(false)
	local v89, v90 = useTimeHysteresis(0, 1)
	local v91 = if not isInExperienceUIVREnabled then nil else isSpatial()
	local v92 = if not isInExperienceUIVREnabled then nil else useObservableValue(Service:getTopBarVisibiity())
	local v93 = if not isInExperienceUIVREnabled or not u42 then nil else useObservableValue(u42)
	local u94 = false

	if isInExperienceUIVREnabled and v91 and not v92 and not v93 then
		u94 = true
		u79 = u79 and not u94
	end

	local v95 = React.useCallback(function(p6, p7) -- line: 337
		-- upvalues: isInExperienceUIVREnabled (copy), u94 (ref), ControlState (copy), Service (copy), t4 (copy), u83 (ref), v85 (copy), v90 (copy)
		if isInExperienceUIVREnabled and u94 then
			return
		end

		if p7 == ControlState.Selected and (p6 == ControlState.Default or p6 == ControlState.Hover) then
			Service:setSelected(t4.integration.id)
		elseif p7 == ControlState.Selected and p6 == ControlState.Default then
			Service:setSelected(t4.integration.id)
		end

		local v125 = p7 ~= ControlState.Default

		t4.setHovered(v125)

		local v126 = p7 == ControlState.Hover

		u83(v126, v126 and v85 or areTooltipsDisplaying())

		if v126 then
			Service:onIntegrationHovered():fire(t4.integration.id)
		end

		if not v125 then
			v90(false)
		end
	end, if not isInExperienceUIVREnabled then {
		t4.setHovered,
		u83,
		v90,
		v85
	} else {
		t4.setHovered,
		u83,
		v90,
		v85,
		v91,
		u94
	})
	local v96 = React.useCallback(function(_, p9) -- line: 373
		-- upvalues: u79 (ref), v90 (copy), ChromeAnalytics (copy), t4 (copy), v80 (copy), UserInputService (copy), shouldRejectMultiTouch (copy), Service (copy), Constants (copy)
		if not u79 then
			return
		end

		if p9.UserInputType == Enum.UserInputType.MouseButton1 or p9.UserInputType == Enum.UserInputType.Touch then
			local p9Position = p9.Position

			v90(true, true)
			ChromeAnalytics.default:onIconTouchBegan(t4.integration.id)

			if not v80.current then
				v80.current = UserInputService.InputChanged:Connect(function(input, _) -- line: 386
					-- upvalues: shouldRejectMultiTouch (copy), p9 (copy), Service (copy), t4 (copy), v80 (copy), p9Position (copy), Constants (copy), ChromeAnalytics (copy)
					if shouldRejectMultiTouch(p9, input) then
						return
					end

					if Service:isWindowOpen(t4.integration.id) or not v80.current then
						return
					end

					local inputPosition = input.Position

					if math.abs((p9Position - inputPosition).Magnitude) > Constants.DRAG_MAGNITUDE_THRESHOLD then
						ChromeAnalytics.default:onIconDrag(t4.integration.id)
						Service:storeChromeInteracted()
						Service:toggleWindow(t4.integration.id)
						Service:gesture(t4.integration.id, v80, p9)
					end
				end)
			end
		end
	end, { u79 })
	local v97 = React.useCallback(function(_, p12) -- line: 412
		-- upvalues: u79 (ref), v90 (copy), v80 (copy), Service (copy), t4 (copy)
		if not u79 then
			return
		end

		if p12.UserInputType == Enum.UserInputType.MouseButton1 or p12.UserInputType == Enum.UserInputType.Touch then
			v90(false)

			if v80.current then
				v80.current:Disconnect()
				v80.current = nil
				Service:gesture(t4.integration.id, nil)
			end
		end
	end, { u79 })
	local u98 = (v81 or (v85 or v87)) and not v89

	if isInExperienceUIVREnabled and u98 and u94 then
		u98 = false
	end

	logTooltipState(t4.integration.id, u98)

	local v99 = if not FFlagEnableConsoleExpControls then nil else React.useContext(v47)
	local v100 = React.useCallback(function(p13) -- line: 440
		-- upvalues: FFlagEnableConsoleExpControls (copy), Service (copy), React (copy), Interactable (copy), Constants (copy), t4 (copy), u76 (ref), v95 (copy), v77 (copy), FFlagUnibarMenuOpenHamburger (copy), FFlagUnibarMenuOpenSubmenu (copy), useCursor (copy), Foundation (copy), u98 (ref), secondaryAction (copy), v99 (copy), v96 (copy), v97 (copy), isInExperienceUIVREnabled (copy), v91 (copy), u94 (ref), v90 (copy), v80 (copy)
		local id = nil

		if FFlagEnableConsoleExpControls then
			id = Service:menuList():get()[1].id
		end

		return React.createElement(Interactable, {
			Name = (not FFlagEnableConsoleExpControls and "IconHitArea_" or Constants.ICON_NAME_PREFIX) .. t4.integration.id,
			Size = u76,
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			onStateChanged = v95,
			ref = v77,
			SelectionOrder = if not FFlagUnibarMenuOpenHamburger and not FFlagUnibarMenuOpenSubmenu then 100 - t4.integration.order else t4.integration.order,
			Position = t4.isCurrentlyOpenSubMenu:map(function(b2: boolean?) -- line: 458
				-- upvalues: FFlagEnableConsoleExpControls (copy)
				return UDim2.new(0.5, 0, 0.5, (FFlagEnableConsoleExpControls or not b2) and 0 or 1)
			end),
			SelectionImageObject = useCursor(Foundation.Enums.CursorType.SkinToneCircle),
			SelectionGroup = true,
			SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
			SelectionBehaviorDown = t4.isCurrentlyOpenSubMenu:map(function(b3: boolean?) -- line: 464
				-- upvalues: u98 (ref), secondaryAction (copy)
				if u98 and secondaryAction or b3 then
					return Enum.SelectionBehavior.Escape
				end

				return Enum.SelectionBehavior.Stop
			end),
			NextSelectionLeft = if not FFlagEnableConsoleExpControls or id ~= t4.integration.id then nil else v99.menuIconRef,
			[React.Change.AbsolutePosition] = p13,
			[React.Change.AbsoluteSize] = p13,
			[React.Event.InputBegan] = v96,
			[React.Event.InputEnded] = v97,
			[React.Event.Activated] = function() -- line: 478
				-- upvalues: isInExperienceUIVREnabled (copy), v91 (copy), u94 (ref), Service (copy), v90 (copy), t4 (copy), v80 (copy)
				if isInExperienceUIVREnabled and v91 then
					if u94 then
						return
					end

					Service:onTriggerVRToggleButton():fire(true)
				end

				v90(true, true)
				t4.integration.activated()

				if v80.current then
					v80.current:Disconnect()
					v80.current = nil
					Service:gesture(t4.integration.id, nil)
				end
			end
		}, {
			corner = React.createElement("UICorner", {
				CornerRadius = UDim.new(1, 0)
			})
		})
	end, {
		v95,
		u83,
		v90,
		v96,
		v97,
		t4.isCurrentlyOpenSubMenu,
		u98,
		secondaryAction,
		if not isInExperienceUIVREnabled then nil else u94,
		if not FFlagEnableConsoleExpControls then nil else v99.menuIconRef
	})
	local v101 = React.useRef(nil)
	local v102 = React.useCallback(function(p14) -- line: 515
		-- upvalues: v101 (copy), v86 (copy)
		local u135 = nil
		local u136 = nil
		local u137 = nil

		if p14 ~= v101.current then
			pcall(function() -- line: 522
				-- upvalues: u135 (ref), u136 (ref), u137 (ref)
				if u135 then
					u135:disconnect()
					u135 = nil
				end

				if u136 then
					u136:disconnect()
					u136 = nil
				end

				if u137 then
					u137:disconnect()
					u137 = nil
				end
			end)

			if p14 then
				u135 = p14.MouseEnter:Connect(function() -- line: 540
					-- upvalues: v86 (copy)
					v86(true, true)
				end)
				u136 = p14.MouseLeave:Connect(function() -- line: 543
					-- upvalues: v86 (copy)
					v86(false)
				end)
				u137 = p14.Destroying:Connect(function() -- line: 546
					-- upvalues: v86 (copy)
					v86(false)
				end)
			end

			v101.current = p14
		end
	end, { v86 })
	local v103 = if not secondaryAction then nil else {
		text = secondaryAction.label,
		onStateChanged = function(_, p16) -- line: 557
			-- upvalues: ControlState (copy), v88 (copy)
			if p16 == ControlState.Selected then
				v88(true)

				return
			end

			v88(false)
		end,
		onActivated = function() -- line: 564
			-- upvalues: secondaryAction (copy), t4 (copy)
			secondaryAction.activated(t4.integration)
		end,
		NextSelectionUp = v77,
		NextSelectionLeft = v77,
		NextSelectionRight = v77,
		NextSelectionDown = v77
	}

	if isInExperienceUIVREnabled and v91 then
		local v104, v105 = React.useBinding(Vector2.zero)
		local v106, v107 = React.useBinding(Vector2.zero)
		local v108 = React.useCallback(function(p17) -- line: 578
			-- upvalues: v105 (copy), v107 (copy)
			v105(p17.AbsolutePosition)
			v107(p17.AbsoluteSize)
		end, {
			v105,
			v107
		})

		return React.createElement(React.Fragment, nil, {
			VRSpatialTooltip = if not u98 or not Panel3DInSpatialUI then nil else React.createElement(Panel3DInSpatialUI, {
				panelType = PanelType.ToolTipsContainer,
				renderFunction = function(vector2: Vector2) -- line: 590
					-- upvalues: v104 (copy), v106 (copy), SPATIAL_TOOLTIP_SPACING (ref), React (copy), TooltipCallout (ref), t4 (copy), TooltipOrientation (ref), v103 (copy), secondaryAction (copy), v102 (copy)
					local vector2_2 = Vector2.new(v104:getValue().X + v106:getValue().X / 2, vector2.Y - SPATIAL_TOOLTIP_SPACING)

					return React.createElement(TooltipCallout, {
						distanceOffset = 0,
						textAlignment = Enum.TextXAlignment.Center,
						headerText = t4.integration.integration.label,
						orientation = TooltipOrientation.Top,
						triggerPointCenter = vector2_2,
						contentOffsetVector = Vector2.zero,
						triggerPointRadius = Vector2.zero,
						buttonProps = v103,
						ref = if not secondaryAction then nil else v102
					})
				end
			}),
			v100(v108)
		})
	end

	return withTooltip({
		headerText = t4.integration.integration.label,
		hotkeyCodes = t4.integration.integration.hotkeyCodes,
		textAlignment = Enum.TextXAlignment.Left,
		buttonProps = v103,
		ref = if not secondaryAction then nil else v102
	}, {
		DisplayOrder = 10,
		active = u98,
		guiTarget = CoreGui
	}, v100)
end
function IconHost(t5: {[any]: any}) -- line: 629
	-- upvalues: React (copy), useStyle (copy), FFlagTokenizeUnibarConstantsWithStyleProvider (copy), UnibarStyle (copy), Constants (copy), useMappedObservableValueBinding (copy), Service (copy), ChatNotificationBadge (copy), FFlagEnableConsoleExpControls (copy), FFlagEnableWhatsNew (copy), v9 (copy)
	if not t5.integration or not t5.integration.component then
		warn("IconHost has no component to render")
	end

	local v110, v111 = React.useBinding(false)
	local v112, v113 = React.useBinding(true)
	local BackgroundOnHover = useStyle().Theme.BackgroundOnHover
	local v115 = if not FFlagTokenizeUnibarConstantsWithStyleProvider then Constants.ICON_CELL_WIDTH else UnibarStyle.use().ICON_CELL_WIDTH
	local v116 = useMappedObservableValueBinding(Service:currentSubMenu(), function(p18) -- line: 652
		-- upvalues: t5 (copy)
		return p18 == t5.integration.id
	end)
	local t6 = {
		React.createElement("Frame", {
			Name = "IntegrationIconFrame",
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Visible = v112
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
			setIconVisible = v113
		}),
		React.createElement(HighlightCircle, {
			name = "SelectedHighlighter",
			color = BackgroundOnHover,
			visible = v116
		}),
		React.createElement(HighlightCircle, {
			name = "Highlighter",
			color = BackgroundOnHover,
			visible = v110
		}),
		if t5.integration.id ~= "chat" then React.createElement(NotificationBadge, t5) else React.createElement(ChatNotificationBadge, {
			iconHostProps = t5,
			NotificationBadge = NotificationBadge
		}),
		if not t5.disableButtonBehaviors then React.createElement(TooltipButton, {
			integration = t5.integration,
			setHovered = v111,
			isCurrentlyOpenSubMenu = v116
		}) else nil
	}
	local t7 = {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Size = UDim2.new(0, v115, 0, v115),
		LayoutOrder = t5.integration.order,
		Position = t5.position,
		Visible = t5.visible,
		ZIndex = if not FFlagEnableConsoleExpControls then t5.integration.order else nil
	}

	if FFlagEnableWhatsNew then
		return React.createElement("Frame", t7, {
			WhatsNewAnchor = React.createElement(v9, {
				tag = "size-full",
				anchorId = t5.integration.id
			}, t6)
		})
	end

	return React.createElement("Frame", t7, t6)
end

return IconHost
