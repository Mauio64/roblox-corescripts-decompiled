local ChromeShared = script:FindFirstAncestor("ChromeShared")

local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local FFlagEnableMenuTrailingBadge = SharedFlags.FFlagEnableMenuTrailingBadge
local defineFastFlag = game:DefineFastFlag("AvatarSwitcherHamburgerExposure", false)
local defineFastString = game:DefineFastString("AvatarSwitcherIXPLayer", "UIEcosystem.User.Migration")

local Flags = require(script.Parent.Parent.Parent.Flags)
local FFlagUnibarMenuOpenSubmenu = Flags.FFlagUnibarMenuOpenSubmenu

local Flags2 = require(ChromeShared.Flags)
local FFlagTokenizeUnibarConstantsWithStyleProvider = Flags2.FFlagTokenizeUnibarConstantsWithStyleProvider

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local gamepadUtils

if FFlagEnableConsoleExpControls then
	local InputUi = require(CorePackages.Workspace.Packages.InputUi)
	gamepadUtils = InputUi.Gamepad.GamepadUtils
else
	gamepadUtils = nil
end

local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local useStyle = UIBlox.Core.Style.useStyle
local Interactable = UIBlox.Core.Control.Interactable
local ControlState = UIBlox.Core.Control.Enum.ControlState
local VerticalScrollView = UIBlox.App.Container.VerticalScrollView
local ScrollBarType = UIBlox.App.Container.Enum.ScrollBarType
local ReactOtter = require(CorePackages.Packages.ReactOtter)
local IxpServiceWrapper = require(CorePackages.Workspace.Packages.IxpServiceWrapper)
local IXPServiceWrapper = IxpServiceWrapper.IXPServiceWrapper

local Foundation = require(CorePackages.Packages.Foundation)
local useCursor = Foundation.Hooks.useCursor

local Service = require(ChromeShared.Service)
local Chrome = require(CorePackages.Workspace.Packages.Chrome)
local ViewportUtil = require(ChromeShared.Service.ViewportUtil)
local Constants = require(ChromeShared.Unibar.Constants)
local MenuIconContext

if FFlagEnableConsoleExpControls then
	MenuIconContext = require(ChromeShared.Parent.Parent.TopBar.Components.MenuIconContext)
else
	MenuIconContext = nil
end

local SubMenuContext = require(ChromeShared.Unibar.SubMenuContext)
local MenuTrailingBadge

if FFlagEnableMenuTrailingBadge then
	MenuTrailingBadge = require(ChromeShared.Unibar.MenuTrailingBadge)
else
	MenuTrailingBadge = nil
end

local UnibarStyle = Chrome.UnibarStyle

local UserInputService = game:GetService("UserInputService")

local useChromeMenuItems = require(ChromeShared.Hooks.useChromeMenuItems)
local useObservableValue = require(ChromeShared.Hooks.useObservableValue)
local useTopbarInsetHeight = require(ChromeShared.Hooks.useTopbarInsetHeight)
local useMappedObservableValue = require(ChromeShared.Hooks.useMappedObservableValue)

local defineFastFlag2 = game:DefineFastFlag("FixChromeIntegrationLayoutBug", false)

local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local isSpatial = AppCommonLib.isSpatial

local SharedExperimentDefinition = require(CorePackages.Workspace.Packages.SharedExperimentDefinition)
local isInExperienceUIVREnabled = SharedExperimentDefinition.isInExperienceUIVREnabled
local SharedExperimentDefinition2 = require(CorePackages.Workspace.Packages.SharedExperimentDefinition)
local InExperienceUIVRIXP = SharedExperimentDefinition2.InExperienceUIVRIXP
local uiManager

if isInExperienceUIVREnabled then
	local VrSpatialUi = require(CorePackages.Workspace.Packages.VrSpatialUi)
	uiManager = VrSpatialUi.UIManager
else
	uiManager = nil
end

local IconHost = require(ChromeShared.Unibar.ComponentHosts.IconHost)
local RoundedSlot = Foundation.Enums.CursorType.RoundedSlot

local vector2 = Vector2.new(0, 0)

local _ = { Closed = 0, Open = 1 }
local items = {}
local v = nil

function MenuRow(props)
	local theme = useStyle().Theme
	local v2 = { Color = Color3.new(0, 0, 0), Transparency = 1 }
	local ICON_SIZE, SUB_MENU_ROW_HEIGHT, SUBMENU_PADDING_LEFT, SUBMENU_PADDING_RIGHT, SUBMENU_ROW_LABEL_FONT, SUBMENU_ROW_PADDING, SUBMENU_ROW_CORNER_RADIUS

	if FFlagTokenizeUnibarConstantsWithStyleProvider then
		local v3 = UnibarStyle.use()
		ICON_SIZE = v3.ICON_SIZE
		SUB_MENU_ROW_HEIGHT = v3.SUB_MENU_ROW_HEIGHT
		SUBMENU_PADDING_LEFT = v3.SUBMENU_PADDING_LEFT
		SUBMENU_PADDING_RIGHT = v3.SUBMENU_PADDING_RIGHT
		SUBMENU_ROW_LABEL_FONT = v3.SUBMENU_ROW_LABEL_FONT
		SUBMENU_ROW_PADDING = v3.SUBMENU_ROW_PADDING
		SUBMENU_ROW_CORNER_RADIUS = v3.SUBMENU_ROW_CORNER_RADIUS
	else
		ICON_SIZE = Constants.ICON_SIZE
		SUB_MENU_ROW_HEIGHT = Constants.SUB_MENU_ROW_HEIGHT
		SUBMENU_PADDING_LEFT = Constants.SUBMENU_PADDING_LEFT
		SUBMENU_PADDING_RIGHT = Constants.SUBMENU_PADDING_RIGHT
		SUBMENU_ROW_LABEL_FONT = Constants.SUBMENU_ROW_LABEL_FONT
		SUBMENU_ROW_PADDING = Constants.SUBMENU_ROW_PADDING
		SUBMENU_ROW_CORNER_RADIUS = Constants.SUBMENU_ROW_CORNER_RADIUS
	end

	local v3 = React.useContext(SubMenuContext)
	local v4

	if FFlagEnableConsoleExpControls then
		v4 = React.useContext(MenuIconContext)
	end

	local v5, v6 = React.useBinding(v2)

	local onStateChanged = React.useCallback(function(_, p)
		if p == ControlState.Pressed then
			v6(theme.BackgroundOnPress)
		elseif p == ControlState.Hover then
			v6(theme.BackgroundOnHover)
		else
			v6(v2)
		end
	end)
	local menuTrailingBadgeConfig

	if FFlagEnableMenuTrailingBadge then
		menuTrailingBadgeConfig = props.integration.menuTrailingBadgeConfig
	end

	local v7 = React.useCallback(function()
		if not FFlagEnableConsoleExpControls then
			props.activated()

			return
		end

		Service:disableFocusNav()
		GuiService.SelectedCoreObject = nil
		Service:setShortcutBar(nil)
		Service:selectedItem():set(nil)
		props.activated()
	end, { props.id })

	local createElement = React.createElement
	local size

	if FFlagEnableMenuTrailingBadge then
		size = UDim2.fromScale(1, 1)
	else
		size = UDim2.new(1, -ICON_SIZE - SUBMENU_PADDING_LEFT - SUBMENU_PADDING_RIGHT, 1, 0)
	end

	local colorStyle

	if v3 then
		colorStyle = {
			Color = theme.TextEmphasis.Color,
			Transparency = v3:map(function(p)
				return 1 - p
			end)
		}
	else
		colorStyle = theme.TextEmphasis
	end

	local v8 = createElement(StyledTextLabel, {
		size = size,
		lineHeight = 1,
		fontStyle = SUBMENU_ROW_LABEL_FONT,
		colorStyle = colorStyle,
		text = props.integration.label,
		textTruncate = Enum.TextTruncate.AtEnd,
		textXAlignment = Enum.TextXAlignment.Left,
		fluidSizing = true,
		richText = true
	})

	if FFlagEnableMenuTrailingBadge then
		v8 = React.createElement(
			"Frame",
			{ Size = UDim2.fromScale(0, 1), BackgroundTransparency = 1, BorderSizePixel = 0 },
			{
				UIFlexItem = React.createElement("UIFlexItem", { FlexMode = Enum.UIFlexMode.Fill }),
				StyledTextLabel = v8
			}
		)
	end

	local createElement2 = React.createElement
	local fragment = React.Fragment
	local v9 = {
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, SUBMENU_PADDING_LEFT),
			PaddingRight = UDim.new(0, SUBMENU_PADDING_RIGHT)
		}),
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, SUBMENU_ROW_PADDING)
		}),
		IconHost = React.createElement(IconHost, {
			integration = props,
			disableButtonBehaviors = true
		}),
		Label = v8,
		TrailingBadge = 0
	}
	local trailingBadge

	if FFlagEnableMenuTrailingBadge and menuTrailingBadgeConfig then
		trailingBadge = React.createElement(MenuTrailingBadge, {
			integrationId = props.integration.id,
			config = menuTrailingBadgeConfig
		})
	end

	v9.TrailingBadge = trailingBadge
	local rowLabel = createElement2(fragment, nil, v9)

	local v10 = (not isInExperienceUIVREnabled or InExperienceUIVRIXP:isSpatialUIScalingFixEnabled()) and 1
		or uiManager.getInstance():getAdditionalCameraScaleIfNeeded()

	local createElement3 = React.createElement
	local v11 = {
		["Size"] = nil,
		Size = UDim2.new(1, 0, 0, SUB_MENU_ROW_HEIGHT * v10),
		BorderSizePixel = 0,
		BackgroundTransparency = v5:map(function(p)
			return p.Transparency
		end),
		BackgroundColor3 = v5:map(function(p)
			return p.Color
		end),
		SelectionImageObject = useCursor(RoundedSlot),
		[React.Event.Activated] = v7,
		LayoutOrder = props.order,
		onStateChanged = onStateChanged
	}
	local nextSelectionLeft

	if FFlagEnableConsoleExpControls then
		nextSelectionLeft = v4.menuIconRef
	end

	v11.NextSelectionLeft = nextSelectionLeft
	local v12 = {
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, SUBMENU_ROW_CORNER_RADIUS)
		}),
		RowLabel = 0
	}

	if defineFastFlag2 then
		rowLabel = React.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 1, 0),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				LayoutOrder = props.order
			},
			{ rowLabel }
		)
	end

	v12.RowLabel = rowLabel
	return createElement3(Interactable, v11, v12)
end

function isLeft(p): boolean
	return p == Enum.HorizontalAlignment.Left
end

function SubMenu(props)
	local v2 = useStyle()

	local theme = v2.Theme
	local ref = React.useRef(nil)
	local v3 = useObservableValue(ViewportUtil.screenSize)
	local v4 = useTopbarInsetHeight()
	local UNIBAR_LEFT_MARGIN, ICON_CELL_WIDTH, UNIBAR_END_PADDING, SUB_MENU_ROW_HEIGHT, SUBMENU_CORNER_RADIUS, SUBMENU_BOTTOM_PADDING

	if FFlagTokenizeUnibarConstantsWithStyleProvider then
		local v5 = UnibarStyle.use()
		UNIBAR_LEFT_MARGIN = v5.UNIBAR_LEFT_MARGIN
		ICON_CELL_WIDTH = v5.ICON_CELL_WIDTH
		UNIBAR_END_PADDING = v5.UNIBAR_END_PADDING
		SUB_MENU_ROW_HEIGHT = v5.SUB_MENU_ROW_HEIGHT
		SUBMENU_CORNER_RADIUS = v5.SUBMENU_CORNER_RADIUS
		SUBMENU_BOTTOM_PADDING = v5.SUBMENU_BOTTOM_PADDING
	else
		UNIBAR_LEFT_MARGIN = Constants.UNIBAR_LEFT_MARGIN
		ICON_CELL_WIDTH = Constants.ICON_CELL_WIDTH
		UNIBAR_END_PADDING = Constants.UNIBAR_END_PADDING
		SUB_MENU_ROW_HEIGHT = Constants.SUB_MENU_ROW_HEIGHT
		SUBMENU_CORNER_RADIUS = Constants.SUBMENU_CORNER_RADIUS
		SUBMENU_BOTTOM_PADDING = Constants.SUBMENU_BOTTOM_PADDING
	end

	local v5 = SUB_MENU_ROW_HEIGHT * 0.5
	React.useEffect(function()
		local function moveLeft() -- 2 equivalent calls inferred from this helper
			if ref.current and ref.current:IsAncestorOf(GuiService.SelectedCoreObject) then
				Service:setSelectedByOffset(-1)
			end
		end

		local function moveRight() -- 2 equivalent calls inferred from this helper
			if ref.current and ref.current:IsAncestorOf(GuiService.SelectedCoreObject) then
				Service:setSelectedByOffset(1)
			end
		end

		local inputChangedConnection

		if FFlagEnableConsoleExpControls then
			inputChangedConnection = UserInputService.InputChanged:Connect(function(_)
				local gamepadState = UserInputService:GetGamepadState(Enum.UserInputType.Gamepad1)

				for _, v6 in gamepadState do
					if v6.KeyCode ~= Enum.KeyCode.Thumbstick1 then
						continue
					end

					local x = gamepadUtils.normalizeStickByDeadzone(Vector2.new(v6.Position.X, v6.Position.Y)).X

					if x < -0.5 then
						moveLeft() -- inferred equivalent call
					elseif x > 0.5 then
						moveRight() -- inferred equivalent call
					end
				end
			end)
		else
			inputChangedConnection = nil
		end

		local inputBeganConnection = UserInputService.InputBegan:Connect(function(input)
			local keyCode = input.KeyCode

			if keyCode == Enum.KeyCode.Left or keyCode == Enum.KeyCode.DPadLeft then
				moveLeft() -- inferred equivalent call
			elseif keyCode == Enum.KeyCode.Right or keyCode == Enum.KeyCode.DPadRight then
				moveRight() -- inferred equivalent call
			end
		end)

		return function()
			if FFlagEnableConsoleExpControls then
				inputChangedConnection:Disconnect()
			end

			inputBeganConnection:Disconnect()
		end
	end, {})

	if defineFastFlag then
		React.useEffect(function()
			IXPServiceWrapper:LogFlagLinkedUserLayerExposure(defineFastString)
		end, {})
	end

	local v6 = v4 + ICON_CELL_WIDTH
	local v7 = not (props and props.items) and 0 or SUB_MENU_ROW_HEIGHT * #props.items
	local v8 = v7 * ((not isInExperienceUIVREnabled or InExperienceUIVRIXP:isSpatialUIScalingFixEnabled()) and 1 or uiManager.getInstance():getAdditionalCameraScaleIfNeeded())
	local v9 = if props.panelSize then props.panelSize.Y else v8
	local v10 = isInExperienceUIVREnabled and isSpatial()
	local v11

	if v10 then
		v11 = math.min(v8, v9)
	else
		v11 = math.min(v3.Y - v6, v7)
	end

	if not v10 and v3.Y - v6 < v7 then
		local v12 = math.floor((v3.Y - v6) / SUB_MENU_ROW_HEIGHT)

		if SUB_MENU_ROW_HEIGHT * v12 + v5 <= v3.Y - v6 then
			v11 = SUB_MENU_ROW_HEIGHT * v12 + v5
		else
			v11 = SUB_MENU_ROW_HEIGHT * v12 - v5
		end
	end

	local children = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		UISizeConstraint = 0,
		BottomPadding = 0
	}

	local createElement = React.createElement
	local minSize

	if UserGameSettings.ReducedMotion or not props.menuTransition then
		minSize = Vector2.new(0, v11)
	else
		minSize = props.menuTransition:map(function(p)
			return Vector2.new(0, v11 * p)
		end)
	end

	children.UISizeConstraint = createElement("UISizeConstraint", { MinSize = minSize })

	children.BottomPadding = React.createElement("Frame", {
		Size = UDim2.new(0, 0, 0, SUBMENU_BOTTOM_PADDING),
		BackgroundTransparency = 1,
		LayoutOrder = 10000
	})

	for _, item in props.items do
		children[item.id] = React.createElement(MenuRow, item)
	end

	local v12 = useMappedObservableValue(Service:orderAlignment(), isLeft)

	local v13 = v2.Theme.BackgroundUIContrast.Transparency * v2.Settings.PreferredTransparency
	local anchorPoint

	if v10 then
		anchorPoint = Vector2.new(0, 1)
	elseif v12 then
		anchorPoint = Vector2.zero
	else
		anchorPoint = Vector2.new(1, 0)
	end

	local createElement2 = React.createElement
	local udim

	if v10 then
		local v14

		if v10 then
			v14 = math.min(v8, v9)
		else
			v14 = v8
		end

		udim = UDim2.new(1, 0, 0, v14)
	else
		udim = UDim2.new(0, ICON_CELL_WIDTH * 4 + UNIBAR_LEFT_MARGIN + UNIBAR_END_PADDING * 2, 0, 0)
	end

	local position

	if v10 then
		position = UDim2.new(0, 0, 1, 0)
	else
		position = UDim2.new(0, -v4 - 2 + UNIBAR_LEFT_MARGIN, 0, 0)
	end

	local v14 = {
		Size = udim,
		AnchorPoint = anchorPoint,
		Position = position,
		BackgroundColor3 = theme.BackgroundUIContrast.Color,
		BackgroundTransparency = 0,
		AutomaticSize = 0,
		ref = 0,
		SelectionGroup = 0,
		SelectionBehaviorDown = 0
	}
	local backgroundTransparency

	if props.menuTransition then
		backgroundTransparency = props.menuTransition:map(function(p)
			return v13 + (1 - v13) * (1 - p)
		end)
	else
		backgroundTransparency = v13
	end

	v14.BackgroundTransparency = backgroundTransparency
	local automaticSize

	if not v10 then
		automaticSize = Enum.AutomaticSize.Y
	end

	v14.AutomaticSize = automaticSize
	v14.ref = ref
	v14.SelectionGroup = FFlagEnableConsoleExpControls and true or nil
	local selectionBehaviorDown

	if FFlagEnableConsoleExpControls then
		selectionBehaviorDown = Enum.SelectionBehavior.Stop
	end

	v14.SelectionBehaviorDown = selectionBehaviorDown
	local v15 = {
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, SUBMENU_CORNER_RADIUS)
		}),
		ScrollingFrame = 0
	}

	local createElement3 = React.createElement
	local v16 = {
		size = UDim2.new(1, 0, 1, 0),
		canvasSizeY = 0,
		selectable = false,
		scrollBarType = 0
	}

	if v10 then
		v7 = v8
	end

	v16.canvasSizeY = UDim.new(0, v7)

	v16.scrollBarType = ScrollBarType.Compact
	v15.ScrollingFrame = createElement3(VerticalScrollView, v16, children)
	return createElement2("Frame", v14, v15)
end

return function(p)
	local children = {}

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local v2 = useObservableValue(Service:currentSubMenu())

	local _, setState = React.useState(0)

	local v3 = useChromeMenuItems()
	local items2 = {}

	local menuTransition, v4 = ReactOtter.useAnimatedBinding(0, function(p2)
		setState(p2)
	end)

	React.useEffect(function()
		items = items2
		v = v2

		if v2 then
			setState(0)
			v4(ReactOtter.spring(1, Constants.MENU_ANIMATION_SPRING))

			ref3.current = UserInputService.TouchStarted:Connect(function(p2)
				vector2 = Vector2.new(p2.Position.X, p2.Position.Y)
			end)

			ref2.current = UserInputService.TouchTap:Connect(function(list)
				if list[1] - vector2 ~= Vector2.zero then
					return
				end

				local v5 = Service:currentSubMenu():get()

				if v5 then
					Service:toggleSubMenu(v5)
				end
			end)

			ref.current = UserInputService.InputEnded:Connect(function(input, _)
				if isInExperienceUIVREnabled and isSpatial() and not InExperienceUIVRIXP:isMovePanelToCenter() then
					return
				end

				local v5 = input.UserInputType == Enum.UserInputType.MouseButton1

				local v6 = Service:currentSubMenu():get()

				if v6 and v5 then
					Service:toggleSubMenu(v6)
				end
			end)
		else
			setState(1)
			v4(ReactOtter.spring(0, Constants.MENU_ANIMATION_SPRING))
		end

		return function()
			if ref.current then
				ref.current:Disconnect()
				ref.current = nil
			end

			if ref2.current then
				ref2.current:Disconnect()
				ref2.current = nil
			end

			if ref3.current then
				ref3.current:Disconnect()
				ref3.current = nil
			end
		end
	end, { v2 })

	if v2 and v3 then
		for _, v5 in v3 do
			if v2 == v5.id then
				items2 = v5.children
				break
			end
		end
	end

	if #items2 > 0 then
		children[v2] = React.createElement(SubMenu, {
			items = items2,
			menuTransition = menuTransition,
			panelSize = p.panelSize
		})
	elseif #items > 0 then
		children[v] = React.createElement(SubMenu, {
			items = items,
			menuTransition = menuTransition,
			panelSize = p.panelSize
		})
	end

	local createElement = React.createElement
	local size

	if isInExperienceUIVREnabled and isSpatial() then
		size = UDim2.new(1, 0, 1, 0)
	else
		size = UDim2.new(0, 0, 1, 0)
	end

	local ref4

	if FFlagUnibarMenuOpenSubmenu then
		ref4 = p.subMenuHostRef
	end

	return createElement("Frame", {
		Name = "SubMenuHost",
		Size = size,
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		ref = ref4
	}, React.createElement(SubMenuContext.Provider, { value = menuTransition }, children))
end
