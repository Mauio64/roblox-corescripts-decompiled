local ChromeShared = script:FindFirstAncestor("ChromeShared")

local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local React = require(CorePackages.Packages.React)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local FFlagEnableWhatsNew = SharedFlags.FFlagEnableWhatsNew
local whatsNewAnchor

if FFlagEnableWhatsNew then
	local WhatsNew = require(CorePackages.Workspace.Packages.WhatsNew)
	whatsNewAnchor = WhatsNew.WhatsNewAnchor
else
	whatsNewAnchor = nil
end

local Flags = require(script.Parent.Parent.Parent.Parent.Flags)
local FFlagUnibarMenuOpenHamburger = Flags.FFlagUnibarMenuOpenHamburger
local FFlagUnibarMenuOpenSubmenu = Flags.FFlagUnibarMenuOpenSubmenu

local Flags2 = require(ChromeShared.Flags)
local FFlagChromeNineDotActivityIndicator = Flags2.FFlagChromeNineDotActivityIndicator
local FFlagTokenizeUnibarConstantsWithStyleProvider = Flags2.FFlagTokenizeUnibarConstantsWithStyleProvider

local UIBlox = require(CorePackages.Packages.UIBlox)

local Foundation = require(CorePackages.Packages.Foundation)
local useCursor = Foundation.Hooks.useCursor
local StatusIndicator = Foundation.StatusIndicator
local StatusIndicatorVariant = Foundation.Enums.StatusIndicatorVariant

local Interactable = UIBlox.Core.Control.Interactable
local ControlState = UIBlox.Core.Control.Enum.ControlState
local useStyle = UIBlox.Core.Style.useStyle
local withTooltip = UIBlox.App.Dialog.TooltipV2.withTooltip

local Constants = require(ChromeShared.Unibar.Constants)

local Service = require(ChromeShared.Service)
local ChromeAnalytics = require(ChromeShared.Analytics.ChromeAnalytics)
local Chrome = require(CorePackages.Workspace.Packages.Chrome)
local UnibarStyle = Chrome.UnibarStyle

local useObservableValue = require(ChromeShared.Hooks.useObservableValue)
local useMappedObservableValueBinding = require(ChromeShared.Hooks.useMappedObservableValueBinding)
local useTimeHysteresis = require(ChromeShared.Hooks.useTimeHysteresis)
local shouldRejectMultiTouch = require(ChromeShared.Utility.shouldRejectMultiTouch)

local ChatNotificationBadge = require(script.Parent.ChatNotificationBadge)
local NineDotActivityIndicator = require(script.Parent.NineDotActivityIndicator)
local NineDotNotificationBadge = require(script.Parent.NineDotNotificationBadge)

local SharedExperimentDefinition = require(CorePackages.Workspace.Packages.SharedExperimentDefinition)
local isInExperienceUIVREnabled = SharedExperimentDefinition.isInExperienceUIVREnabled

local v = nil
local isSpatial, panel3DInSpatialUI, panelType, tooltipOrientation, tooltipCallout, SPATIAL_TOOLTIP_SPACING

if isInExperienceUIVREnabled then
	local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
	isSpatial = AppCommonLib.isSpatial
	local VrSpatialUi = require(CorePackages.Workspace.Packages.VrSpatialUi)
	panel3DInSpatialUI = VrSpatialUi.Panel3DInSpatialUI
	panelType = VrSpatialUi.Constants.PanelType
	tooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
	tooltipCallout = UIBlox.App.Dialog.TooltipCallout
	SPATIAL_TOOLTIP_SPACING = VrSpatialUi.Constants.SPATIAL_TOOLTIP_SPACING
	local uiManager = VrSpatialUi.UIManager
	local ChromeUtils = require(ChromeShared.Service.ChromeUtils)
	local mappedSignal = ChromeUtils.MappedSignal
	local bottomBarVisibility = uiManager.getInstance():getBottomBarVisibility()

	if bottomBarVisibility and isSpatial() then
		v = mappedSignal.new(bottomBarVisibility, function()
			return bottomBarVisibility:get()
		end)
	end
else
	isSpatial = nil
	panel3DInSpatialUI = nil
	panelType = nil
	SPATIAL_TOOLTIP_SPACING = nil
	tooltipCallout = nil
	tooltipOrientation = nil
end

local MenuIconContext

if FFlagEnableConsoleExpControls then
	MenuIconContext = require(ChromeShared.Parent.Parent.TopBar.Components.MenuIconContext)
else
	MenuIconContext = nil
end

local v2 = {}

function areTooltipsDisplaying(): boolean
	local now = tick()

	for _, v3 in v2 do
		if v3.displaying or now - v3.time < 0.15 then
			return true
		end
	end

	return false
end

function logTooltipState(p, displaying: boolean)
	if not v2[p] or v2[p].displaying ~= displaying then
		v2[p] = { displaying = displaying, time = tick() }
	end
end

function NotificationBadge(props)
	if not props.integration then
		return nil
	end

	local notification

	if props.integration.integration then
		notification = props.integration.integration.notification or nil
	else
		notification = nil
	end

	local v3, v4 = React.useBinding(notification and notification:get().value or 0)
	local state, setState = React.useState(false)

	React.useEffect(function()
		if not notification then
			return
		end

		local connection = notification:connect(function()
			local value = notification:get().value or 0
			setState(value > 0)
			v4(value)
		end)
		return function()
			connection:disconnect()
		end
	end, { props.integration.integration.id })
	local ICON_BADGE_OFFSET_X, ICON_BADGE_OFFSET_Y

	if FFlagTokenizeUnibarConstantsWithStyleProvider then
		local v5 = UnibarStyle.use()
		ICON_BADGE_OFFSET_X = v5.ICON_BADGE_OFFSET_X
		ICON_BADGE_OFFSET_Y = v5.ICON_BADGE_OFFSET_Y
	else
		ICON_BADGE_OFFSET_X = Constants.ICON_BADGE_OFFSET_X
		ICON_BADGE_OFFSET_Y = Constants.ICON_BADGE_OFFSET_Y
	end

	local minBadgeCount = props.minBadgeCount or 0
	local hasNotificationBadge = state or minBadgeCount > 0
	local mapped = v3:map(function(p)
		return (math.min(math.max(p, minBadgeCount), 99))
	end)

	local createElement = React.createElement
	local v5 = {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Visible = props.toggleTransition and props.toggleTransition:map(function(_): boolean
			return true
		end) or true,
		ZIndex = 2
	}
	local badge

	if hasNotificationBadge then
		badge = React.createElement(StatusIndicator, {
			value = mapped,
			variant = StatusIndicatorVariant.Emphasis,
			AnchorPoint = Vector2.new(0, 0),
			Position = UDim2.new(0, ICON_BADGE_OFFSET_X, 0, ICON_BADGE_OFFSET_Y)
		})
	end

	local activityIndicator

	if FFlagChromeNineDotActivityIndicator and props.integration.id == "nine_dot" then
		activityIndicator = React.createElement(NineDotActivityIndicator, {
			hasNotificationBadge = hasNotificationBadge,
			position = UDim2.new(0, ICON_BADGE_OFFSET_X, 0, ICON_BADGE_OFFSET_Y),
			visible = props.showNineDotActivityIndicator == true
		})
	end

	return createElement("Frame", v5, { Badge = badge, ActivityIndicator = activityIndicator })
end

function NotificationIndicator(p)
	local v3 = useObservableValue(Service:notificationIndicator())
	p.setIconVisible(not v3)

	return (React.createElement(
		"Frame",
		{
			Name = "NotificationIndicatorFrame",
			Size = UDim2.new(1, 0, 1, 0),
			BorderSizePixel = 0,
			BackgroundTransparency = 1
		},
		{
			IntegrationIcon = v3 and v3.component(p) or nil,
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			})
		}
	))
end

function HighlightCircle(props)
	local size

	if FFlagTokenizeUnibarConstantsWithStyleProvider then
		size = UnibarStyle.use().ICON_HIGHLIGHT_SIZE
	else
		size = Constants.ICON_HIGHLIGHT_SIZE
	end

	return React.createElement("Frame", {
		Name = props.name or "Highlighter",
		Size = size,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		BackgroundColor3 = props.color.Color,
		BackgroundTransparency = props.color.Transparency,
		BorderSizePixel = 0,
		Visible = props.visible
	}, {
		corner = React.createElement("UICorner", { CornerRadius = UDim.new(1, 0) })
	})
end

function TooltipButton(props)
	local ICON_HIGHLIGHT_SIZE

	if FFlagTokenizeUnibarConstantsWithStyleProvider then
		ICON_HIGHLIGHT_SIZE = UnibarStyle.use().ICON_HIGHLIGHT_SIZE
	else
		ICON_HIGHLIGHT_SIZE = Constants.ICON_HIGHLIGHT_SIZE
	end

	local ref = React.useRef(nil)
	local secondaryAction = props.integration.integration.secondaryAction
	local v3 = props.integration.integration.draggable or false
	local ref2 = React.useRef(nil)

	React.useEffect(function()
		return function()
			if ref2.current then
				ref2.current:Disconnect()
				ref2.current = nil
			end
		end
	end, {})
	local v4, v5

	if secondaryAction then
		v4, v5 = useTimeHysteresis(0.05, 0.15, 0.35)
	else
		v4, v5 = useTimeHysteresis(0.6, 0.65, 0.7)
	end

	local v6, v7 = useTimeHysteresis(0, 0, 0.65)
	local state, setState = React.useState(false)

	local v8, v9 = useTimeHysteresis(0, 1)
	local v10

	if isInExperienceUIVREnabled then
		v10 = isSpatial()
	else
		v10 = nil
	end

	local v11

	if isInExperienceUIVREnabled then
		v11 = useObservableValue(Service:getTopBarVisibiity())
	end

	local v12

	if isInExperienceUIVREnabled and v then
		v12 = useObservableValue(v)
	end

	local flag

	if isInExperienceUIVREnabled and v10 and not (v11 or v12) then
		flag = true
		v3 = v3 and not flag
	else
		flag = false
	end

	local useCallback = React.useCallback
	local function fn(p, p2)
		if isInExperienceUIVREnabled and flag then
			return
		end

		if p2 == ControlState.Selected and (p == ControlState.Default or p == ControlState.Hover) then
			Service:setSelected(props.integration.id)
		elseif p2 == ControlState.Selected and p == ControlState.Default then
			Service:setSelected(props.integration.id)
		end

		local v13 = p2 ~= ControlState.Default
		props.setHovered(v13)
		local v14 = p2 == ControlState.Hover
		v5(v14, v14 and v6 or areTooltipsDisplaying())

		if v14 then
			Service:onIntegrationHovered():fire(props.integration.id)
		end

		if not v13 then
			v9(false)
		end
	end

	local v13

	if isInExperienceUIVREnabled then
		v13 = { props.setHovered, v5, v9, v6, v10, flag }
	else
		v13 = { props.setHovered, v5, v9, v6 }
	end

	local onStateChanged = useCallback(fn, v13)

	local v14 = React.useCallback(function(_, p)
		if not v3 then
			return
		end

		if p.UserInputType == Enum.UserInputType.MouseButton1 or p.UserInputType == Enum.UserInputType.Touch then
			local position = p.Position
			v9(true, true)
			ChromeAnalytics.default:onIconTouchBegan(props.integration.id)

			if not ref2.current then
				ref2.current = UserInputService.InputChanged:Connect(function(input, _)
					if
						shouldRejectMultiTouch(p, input)
						or (Service:isWindowOpen(props.integration.id) or not ref2.current)
					then
						return
					end

					local position2 = input.Position

					if math.abs((position - position2).Magnitude) > Constants.DRAG_MAGNITUDE_THRESHOLD then
						ChromeAnalytics.default:onIconDrag(props.integration.id)
						Service:storeChromeInteracted()
						Service:toggleWindow(props.integration.id)
						Service:gesture(props.integration.id, ref2, p)
					end
				end)
			end
		end
	end, { v3 })
	local v15 = React.useCallback(function(_, p)
		if not v3 then
			return
		end

		if p.UserInputType == Enum.UserInputType.MouseButton1 or p.UserInputType == Enum.UserInputType.Touch then
			v9(false)

			if ref2.current then
				ref2.current:Disconnect()
				ref2.current = nil
				Service:gesture(props.integration.id, nil)
			end
		end
	end, { v3 })
	local active

	if v4 or v6 then
		active = not v8
	else
		active = state and not v8
	end

	if isInExperienceUIVREnabled and active and flag then
		active = false
	end

	logTooltipState(props.integration.id, active)
	local v16

	if FFlagEnableConsoleExpControls then
		v16 = React.useContext(MenuIconContext)
	else
		v16 = nil
	end

	local useCallback2 = React.useCallback
	local function fn2(p)
		local id

		if FFlagEnableConsoleExpControls then
			id = Service:menuList():get()[1].id
		end

		local createElement = React.createElement
		local v17 = {
			["Name"] = nil,
			["Name"] = nil,
			["Name"] = nil,
			["Name"] = nil,
			["Name"] = nil,
			["Name"] = nil,
			["Name"] = nil,
			["Name"] = nil,
			["Name"] = nil,
			["Name"] = nil,
			Name = (not FFlagEnableConsoleExpControls and "IconHitArea_" or Constants.ICON_NAME_PREFIX) .. props.integration.id,
			Size = ICON_HIGHLIGHT_SIZE,
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			onStateChanged = onStateChanged,
			ref = ref
		}
		local selectionOrder

		if FFlagUnibarMenuOpenHamburger or FFlagUnibarMenuOpenSubmenu then
			selectionOrder = props.integration.order
		else
			selectionOrder = 100 - props.integration.order
		end

		v17.SelectionOrder = selectionOrder

		v17.Position = props.isCurrentlyOpenSubMenu:map(function(flag2: boolean?)
			return UDim2.new(0.5, 0, 0.5, (FFlagEnableConsoleExpControls or not flag2) and 0 or 1)
		end)

		v17.SelectionImageObject = useCursor(Foundation.Enums.CursorType.SkinToneCircle)
		v17.SelectionGroup = true
		v17.SelectionBehaviorUp = Enum.SelectionBehavior.Stop
		v17.SelectionBehaviorDown = props.isCurrentlyOpenSubMenu:map(function(flag2: boolean?)
			if active and secondaryAction or flag2 then
				return Enum.SelectionBehavior.Escape
			end

			return Enum.SelectionBehavior.Stop
		end)
		local nextSelectionLeft

		if FFlagEnableConsoleExpControls and props.integration.id == id then
			nextSelectionLeft = v16.menuIconRef
		end

		v17.NextSelectionLeft = nextSelectionLeft

		v17[React.Change.AbsolutePosition] = p
		v17[React.Change.AbsoluteSize] = p
		v17[React.Event.InputBegan] = v14
		v17[React.Event.InputEnded] = v15
		v17[React.Event.Activated] = function()
			if isInExperienceUIVREnabled and v10 then
				if flag then
					return
				end

				Service:onTriggerVRToggleButton():fire(true)
			end

			v9(true, true)
			props.integration.activated()

			if ref2.current then
				ref2.current:Disconnect()
				ref2.current = nil
				Service:gesture(props.integration.id, nil)
			end
		end

		return createElement(Interactable, v17, {
			corner = React.createElement("UICorner", { CornerRadius = UDim.new(1, 0) })
		})
	end

	local isCurrentlyOpenSubMenu = props.isCurrentlyOpenSubMenu
	local v17

	if isInExperienceUIVREnabled then
		v17 = flag
	end

	local v18

	if FFlagEnableConsoleExpControls then
		v18 = v16.menuIconRef
	end

	local v19 = useCallback2(fn2, {
		onStateChanged,
		v5,
		v9,
		v14,
		v15,
		isCurrentlyOpenSubMenu,
		active,
		secondaryAction,
		v17,
		v18
	})

	local ref3 = React.useRef(nil)
	local ref4 = React.useCallback(function(current)
		local mouseEnterConnection = nil
		local mouseLeaveConnection = nil
		local destroyingConnection = nil
		local function fn3()
			if mouseEnterConnection then
				mouseEnterConnection:disconnect()
				mouseEnterConnection = nil
			end

			if mouseLeaveConnection then
				mouseLeaveConnection:disconnect()
				mouseLeaveConnection = nil
			end

			if destroyingConnection then
				destroyingConnection:disconnect()
				destroyingConnection = nil
			end
		end

		if current ~= ref3.current then
			pcall(fn3)

			if current then
				mouseEnterConnection = current.MouseEnter:Connect(function()
					v7(true, true)
				end)
				mouseLeaveConnection = current.MouseLeave:Connect(function()
					v7(false)
				end)
				destroyingConnection = current.Destroying:Connect(function()
					v7(false)
				end)
			end

			ref3.current = current
		end
	end, { v7 })

	local buttonProps = secondaryAction and {
		text = secondaryAction.label,
		onStateChanged = function(_, p)
			if p == ControlState.Selected then
				setState(true)
			else
				setState(false)
			end
		end,
		onActivated = function()
			secondaryAction.activated(props.integration)
		end,
		NextSelectionUp = ref,
		NextSelectionLeft = ref,
		NextSelectionRight = ref,
		NextSelectionDown = ref
	} or nil

	if isInExperienceUIVREnabled and v10 then
		local v20, v21 = React.useBinding(Vector2.zero)
		local v22, v23 = React.useBinding(Vector2.zero)

		local v24 = React.useCallback(function(p)
			v21(p.AbsolutePosition)
			v23(p.AbsoluteSize)
		end, { v21, v23 })

		local createElement = React.createElement
		local fragment = React.Fragment
		local vrSpatialTooltip

		if active and panel3DInSpatialUI then
			vrSpatialTooltip = React.createElement(panel3DInSpatialUI, {
				panelType = panelType.ToolTipsContainer,
				renderFunction = function(vector2: Vector2)
					local vector2_2 = Vector2.new(
						v20:getValue().X + v22:getValue().X / 2,
						vector2.Y - SPATIAL_TOOLTIP_SPACING
					)

					local createElement2 = React.createElement
					local v25 = {
						textAlignment = Enum.TextXAlignment.Center,
						headerText = props.integration.integration.label,
						orientation = tooltipOrientation.Top,
						distanceOffset = 0,
						triggerPointCenter = vector2_2,
						contentOffsetVector = Vector2.zero,
						triggerPointRadius = Vector2.zero,
						buttonProps = buttonProps,
						ref = 0
					}
					local ref5

					if secondaryAction then
						ref5 = ref4
					end

					v25.ref = ref5
					return createElement2(tooltipCallout, v25)
				end
			})
		end

		return createElement(fragment, nil, {
			VRSpatialTooltip = vrSpatialTooltip,
			v19(v24)
		})
	else
		local v20 = {
			headerText = props.integration.integration.label,
			hotkeyCodes = props.integration.integration.hotkeyCodes,
			textAlignment = Enum.TextXAlignment.Left,
			buttonProps = buttonProps,
			ref = 0
		}

		if not secondaryAction then
			ref4 = nil
		end

		v20.ref = ref4
		return withTooltip(v20, { active = active, guiTarget = CoreGui, DisplayOrder = 10 }, v19)
	end
end

function IconHost(props)
	if not (props.integration and props.integration.component) then
		warn("IconHost has no component to render")
	end

	local visible, setHovered = React.useBinding(false)
	local visible2, setIconVisible = React.useBinding(true)

	local backgroundOnHover = useStyle().Theme.BackgroundOnHover
	local ICON_CELL_WIDTH

	if FFlagTokenizeUnibarConstantsWithStyleProvider then
		ICON_CELL_WIDTH = UnibarStyle.use().ICON_CELL_WIDTH
	else
		ICON_CELL_WIDTH = Constants.ICON_CELL_WIDTH
	end

	local v3 = useMappedObservableValueBinding(Service:currentSubMenu(), function(p): boolean
		return p == props.integration.id
	end)

	local createElement = React.createElement
	local v4 = {
		Name = "IntegrationIconFrame",
		Size = UDim2.new(1, 0, 1, 0),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Visible = visible2
	}
	local integrationIcon

	if props.integration and props.integration.component then
		integrationIcon = props.integration.component(props) or nil
	end

	local element = createElement("Frame", v4, {
		IntegrationIcon = integrationIcon,
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		})
	})
	local v5

	if props.integration.integration.flashNotificationSource then
		v5 = React.createElement(NotificationIndicator, {
			integration = props.integration,
			setIconVisible = setIconVisible
		})
	end

	local element2 = React.createElement(HighlightCircle, {
		name = "SelectedHighlighter",
		color = backgroundOnHover,
		visible = v3
	})

	local element3 = React.createElement(HighlightCircle, {
		name = "Highlighter",
		color = backgroundOnHover,
		visible = visible
	})
	local v6

	if props.integration.id == "chat" then
		v6 = React.createElement(ChatNotificationBadge, {
			iconHostProps = props,
			NotificationBadge = NotificationBadge
		})
	elseif FFlagChromeNineDotActivityIndicator and props.integration.id == "nine_dot" then
		v6 = React.createElement(NineDotNotificationBadge, {
			iconHostProps = props,
			NotificationBadge = NotificationBadge
		})
	else
		v6 = React.createElement(NotificationBadge, props)
	end

	local v7

	if not props.disableButtonBehaviors then
		v7 = React.createElement(TooltipButton, {
			integration = props.integration,
			setHovered = setHovered,
			isCurrentlyOpenSubMenu = v3
		})
	end

	local v8 = { element, v5, element2, element3, v6, v7 }

	local v9 = {
		Size = UDim2.new(0, ICON_CELL_WIDTH, 0, ICON_CELL_WIDTH),
		LayoutOrder = props.integration.order,
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Position = props.position,
		Visible = props.visible,
		ZIndex = 0
	}
	local zIndex

	if not FFlagEnableConsoleExpControls then
		zIndex = props.integration.order
	end

	v9.ZIndex = zIndex

	if FFlagEnableWhatsNew then
		return React.createElement("Frame", v9, {
			WhatsNewAnchor = React.createElement(
				whatsNewAnchor,
				{ anchorId = props.integration.id, tag = "size-full" },
				v8
			)
		})
	end

	return React.createElement("Frame", v9, v8)
end

return IconHost
