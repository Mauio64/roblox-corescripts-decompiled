local ChromeShared = script:FindFirstAncestor("ChromeShared")
local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local FFlagEnableMenuTrailingBadge = SharedFlags.FFlagEnableMenuTrailingBadge
local v8 = game:DefineFastFlag("AvatarSwitcherHamburgerExposure", false)
local v9 = game:DefineFastString("AvatarSwitcherIXPLayer", "UIEcosystem.User.Migration")
local FFlagUnibarMenuOpenSubmenu = require(script.Parent.Parent.Parent.Flags).FFlagUnibarMenuOpenSubmenu
local FFlagTokenizeUnibarConstantsWithStyleProvider = require(ChromeShared.Flags).FFlagTokenizeUnibarConstantsWithStyleProvider
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local v14 = if not FFlagEnableConsoleExpControls then nil else require(CorePackages.Workspace.Packages.InputUi).Gamepad.GamepadUtils
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local useStyle = UIBlox.Core.Style.useStyle
local Interactable = UIBlox.Core.Control.Interactable
local ControlState = UIBlox.Core.Control.Enum.ControlState
local VerticalScrollView = UIBlox.App.Container.VerticalScrollView
local ScrollBarType = UIBlox.App.Container.Enum.ScrollBarType
local ReactOtter = require(CorePackages.Packages.ReactOtter)
local IXPServiceWrapper = require(CorePackages.Workspace.Packages.IxpServiceWrapper).IXPServiceWrapper
local Foundation = require(CorePackages.Packages.Foundation)
local useCursor = Foundation.Hooks.useCursor
local Service = require(ChromeShared.Service)
local Chrome = require(CorePackages.Workspace.Packages.Chrome)
local ViewportUtil = require(ChromeShared.Service.ViewportUtil)
local Constants = require(ChromeShared.Unibar.Constants)
local v29 = if not FFlagEnableConsoleExpControls then nil else require(ChromeShared.Parent.Parent.TopBar.Components.MenuIconContext)
local SubMenuContext = require(ChromeShared.Unibar.SubMenuContext)
local v31 = if not FFlagEnableMenuTrailingBadge then nil else require(ChromeShared.Unibar.MenuTrailingBadge)
local UnibarStyle = Chrome.UnibarStyle
local UserInputService = game:GetService("UserInputService")
local useChromeMenuItems = require(ChromeShared.Hooks.useChromeMenuItems)
local useObservableValue = require(ChromeShared.Hooks.useObservableValue)
local useTopbarInsetHeight = require(ChromeShared.Hooks.useTopbarInsetHeight)
local useMappedObservableValue = require(ChromeShared.Hooks.useMappedObservableValue)
local v38 = game:DefineFastFlag("FixChromeIntegrationLayoutBug", false)
local isSpatial = require(CorePackages.Workspace.Packages.AppCommonLib).isSpatial
local isInExperienceUIVREnabled = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).isInExperienceUIVREnabled
local InExperienceUIVRIXP = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).InExperienceUIVRIXP
local UIManager = nil

if isInExperienceUIVREnabled then
	UIManager = require(CorePackages.Workspace.Packages.VrSpatialUi).UIManager
end

local IconHost = require(ChromeShared.Unibar.ComponentHosts.IconHost)
local RoundedSlot = Foundation.Enums.CursorType.RoundedSlot
local vector2 = Vector2.new(0, 0)
local _ = {
	Closed = 0,
	Open = 1
}
local t1 = {}
local u48 = nil

function MenuRow(p1) -- line: 86
	-- upvalues: useStyle (copy), FFlagTokenizeUnibarConstantsWithStyleProvider (copy), UnibarStyle (copy), Constants (copy), React (copy), SubMenuContext (copy), FFlagEnableConsoleExpControls (copy), v29 (copy), ControlState (copy), FFlagEnableMenuTrailingBadge (copy), Service (copy), GuiService (copy), StyledTextLabel (copy), IconHost (copy), v31 (copy), isInExperienceUIVREnabled (copy), InExperienceUIVRIXP (copy), UIManager (ref), Interactable (copy), useCursor (copy), RoundedSlot (copy), v38 (copy)
	local Theme = useStyle().Theme
	local t2 = {
		Transparency = 1,
		Color = Color3.new(0, 0, 0)
	}
	local ICON_SIZE, SUB_MENU_ROW_HEIGHT, SUBMENU_PADDING_LEFT, SUBMENU_PADDING_RIGHT, SUBMENU_ROW_LABEL_FONT, SUBMENU_ROW_PADDING, SUBMENU_ROW_CORNER_RADIUS

	if FFlagTokenizeUnibarConstantsWithStyleProvider then
		local v52 = UnibarStyle.use()

		ICON_SIZE = v52.ICON_SIZE
		SUB_MENU_ROW_HEIGHT = v52.SUB_MENU_ROW_HEIGHT
		SUBMENU_PADDING_LEFT = v52.SUBMENU_PADDING_LEFT
		SUBMENU_PADDING_RIGHT = v52.SUBMENU_PADDING_RIGHT
		SUBMENU_ROW_LABEL_FONT = v52.SUBMENU_ROW_LABEL_FONT
		SUBMENU_ROW_PADDING = v52.SUBMENU_ROW_PADDING
		SUBMENU_ROW_CORNER_RADIUS = v52.SUBMENU_ROW_CORNER_RADIUS
	else
		ICON_SIZE = Constants.ICON_SIZE
		SUB_MENU_ROW_HEIGHT = Constants.SUB_MENU_ROW_HEIGHT
		SUBMENU_PADDING_LEFT = Constants.SUBMENU_PADDING_LEFT
		SUBMENU_PADDING_RIGHT = Constants.SUBMENU_PADDING_RIGHT
		SUBMENU_ROW_LABEL_FONT = Constants.SUBMENU_ROW_LABEL_FONT
		SUBMENU_ROW_PADDING = Constants.SUBMENU_ROW_PADDING
		SUBMENU_ROW_CORNER_RADIUS = Constants.SUBMENU_ROW_CORNER_RADIUS
	end

	local v60 = React.useContext(SubMenuContext)
	local v61 = if not FFlagEnableConsoleExpControls then nil else React.useContext(v29)
	local v62, v63 = React.useBinding(t2)
	local v64 = React.useCallback(function(_, p3) -- line: 125
		-- upvalues: ControlState (copy), v63 (copy), Theme (copy), t2 (copy)
		if p3 == ControlState.Pressed then
			v63(Theme.BackgroundOnPress)

			return
		end

		if p3 == ControlState.Hover then
			v63(Theme.BackgroundOnHover)

			return
		end

		v63(t2)
	end)
	local v65 = if not FFlagEnableMenuTrailingBadge then nil else p1.integration.menuTrailingBadgeConfig
	local v66 = React.useCallback(function() -- line: 137
		-- upvalues: FFlagEnableConsoleExpControls (copy), Service (copy), GuiService (copy), p1 (copy)
		if FFlagEnableConsoleExpControls then
			Service:disableFocusNav()
			GuiService.SelectedCoreObject = nil
			Service:setShortcutBar(nil)
			Service:selectedItem():set(nil)
			p1.activated()

			return
		end

		p1.activated()
	end, { p1.id })
	local v67 = React.createElement(StyledTextLabel, {
		lineHeight = 1,
		fluidSizing = true,
		richText = true,
		size = if not FFlagEnableMenuTrailingBadge then UDim2.new(1, -ICON_SIZE - SUBMENU_PADDING_LEFT - SUBMENU_PADDING_RIGHT, 1, 0) else UDim2.fromScale(1, 1),
		fontStyle = SUBMENU_ROW_LABEL_FONT,
		colorStyle = if not v60 then Theme.TextEmphasis else {
			Color = Theme.TextEmphasis.Color,
			Transparency = v60:map(function(p4) -- line: 161
				return 1 - p4
			end)
		},
		text = p1.integration.label,
		textTruncate = Enum.TextTruncate.AtEnd,
		textXAlignment = Enum.TextXAlignment.Left
	})
	local v68 = if not FFlagEnableMenuTrailingBadge then v67 else React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(0, 1)
	}, {
		UIFlexItem = React.createElement("UIFlexItem", {
			FlexMode = Enum.UIFlexMode.Fill
		}),
		StyledTextLabel = v67
	})
	local v69 = React.createElement(React.Fragment, nil, {
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
			disableButtonBehaviors = true,
			integration = p1
		}),
		Label = v68,
		TrailingBadge = if not FFlagEnableMenuTrailingBadge or not v65 then nil else React.createElement(v31, {
			integrationId = p1.integration.id,
			config = v65
		})
	})
	local v70 = (not isInExperienceUIVREnabled or InExperienceUIVRIXP:isSpatialUIScalingFixEnabled()) and 1 or UIManager.getInstance():getAdditionalCameraScaleIfNeeded()

	return React.createElement(Interactable, {
		Size = UDim2.new(1, 0, 0, SUB_MENU_ROW_HEIGHT * v70),
		BorderSizePixel = 0,
		BackgroundTransparency = v62:map(function(p5) -- line: 225
			return p5.Transparency
		end),
		BackgroundColor3 = v62:map(function(p6) -- line: 228
			return p6.Color
		end),
		SelectionImageObject = useCursor(RoundedSlot),
		[React.Event.Activated] = v66,
		LayoutOrder = p1.order,
		onStateChanged = v64,
		NextSelectionLeft = if not FFlagEnableConsoleExpControls then nil else v61.menuIconRef
	}, {
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, SUBMENU_ROW_CORNER_RADIUS)
		}),
		RowLabel = if not v38 then v69 else React.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			LayoutOrder = p1.order
		}, { v69 })
	})
end
function isLeft(p7) -- line: 253
	return p7 == Enum.HorizontalAlignment.Left
end
function SubMenu(t3: {[any]: any}) -- line: 257
	-- upvalues: useStyle (copy), React (copy), useObservableValue (copy), ViewportUtil (copy), useTopbarInsetHeight (copy), FFlagTokenizeUnibarConstantsWithStyleProvider (copy), UnibarStyle (copy), Constants (copy), GuiService (copy), Service (copy), FFlagEnableConsoleExpControls (copy), UserInputService (copy), v14 (copy), v8 (copy), IXPServiceWrapper (copy), v9 (copy), isInExperienceUIVREnabled (copy), InExperienceUIVRIXP (copy), UIManager (ref), isSpatial (copy), UserGameSettings (copy), useMappedObservableValue (copy), VerticalScrollView (copy), ScrollBarType (copy)
	local v73 = useStyle()
	local Theme = v73.Theme
	local v75 = React.useRef(nil)
	local v76 = useObservableValue(ViewportUtil.screenSize)
	local v77 = useTopbarInsetHeight()
	local UNIBAR_LEFT_MARGIN, ICON_CELL_WIDTH, UNIBAR_END_PADDING, SUB_MENU_ROW_HEIGHT, SUBMENU_CORNER_RADIUS, SUBMENU_BOTTOM_PADDING

	if FFlagTokenizeUnibarConstantsWithStyleProvider then
		local v78 = UnibarStyle.use()

		UNIBAR_LEFT_MARGIN = v78.UNIBAR_LEFT_MARGIN
		ICON_CELL_WIDTH = v78.ICON_CELL_WIDTH
		UNIBAR_END_PADDING = v78.UNIBAR_END_PADDING
		SUB_MENU_ROW_HEIGHT = v78.SUB_MENU_ROW_HEIGHT
		SUBMENU_CORNER_RADIUS = v78.SUBMENU_CORNER_RADIUS
		SUBMENU_BOTTOM_PADDING = v78.SUBMENU_BOTTOM_PADDING
	else
		UNIBAR_LEFT_MARGIN = Constants.UNIBAR_LEFT_MARGIN
		ICON_CELL_WIDTH = Constants.ICON_CELL_WIDTH
		UNIBAR_END_PADDING = Constants.UNIBAR_END_PADDING
		SUB_MENU_ROW_HEIGHT = Constants.SUB_MENU_ROW_HEIGHT
		SUBMENU_CORNER_RADIUS = Constants.SUBMENU_CORNER_RADIUS
		SUBMENU_BOTTOM_PADDING = Constants.SUBMENU_BOTTOM_PADDING
	end

	local v85 = SUB_MENU_ROW_HEIGHT * 0.5

	React.useEffect(function() -- line: 287
		-- upvalues: v75 (copy), GuiService (copy), Service (copy), FFlagEnableConsoleExpControls (copy), UserInputService (copy), v14 (copy)
		local function moveLeft() -- line: 288
			-- upvalues: v75 (copy), GuiService (copy), Service (copy)
			if v75.current and v75.current:IsAncestorOf(GuiService.SelectedCoreObject) then
				Service:setSelectedByOffset(-1)
			end
		end
		local function moveRight() -- line: 295
			-- upvalues: v75 (copy), GuiService (copy), Service (copy)
			if v75.current and v75.current:IsAncestorOf(GuiService.SelectedCoreObject) then
				Service:setSelectedByOffset(1)
			end
		end

		local connection = nil

		if FFlagEnableConsoleExpControls then
			connection = UserInputService.InputChanged:Connect(function(_) -- line: 306
				-- upvalues: UserInputService (copy), v14 (copy), v75 (copy), GuiService (copy), Service (copy)
				for _, v127 in (UserInputService:GetGamepadState(Enum.UserInputType.Gamepad1)) do
					if v127.KeyCode == Enum.KeyCode.Thumbstick1 then
						local X = v14.normalizeStickByDeadzone(Vector2.new(v127.Position.X, v127.Position.Y)).X

						if X < -0.5 then
							if v75.current and v75.current:IsAncestorOf(GuiService.SelectedCoreObject) then
								Service:setSelectedByOffset(-1)
							end
						elseif X > 0.5 and (v75.current and v75.current:IsAncestorOf(GuiService.SelectedCoreObject)) then
							Service:setSelectedByOffset(1)
						end
					end
				end
			end)
		end

		local connection2 = UserInputService.InputBegan:Connect(function(input) -- line: 328
			-- upvalues: v75 (copy), GuiService (copy), Service (copy)
			local KeyCode = input.KeyCode

			if KeyCode == Enum.KeyCode.Left or KeyCode == Enum.KeyCode.DPadLeft then
				if v75.current and v75.current:IsAncestorOf(GuiService.SelectedCoreObject) then
					Service:setSelectedByOffset(-1)

					return
				end
			elseif (KeyCode == Enum.KeyCode.Right or KeyCode == Enum.KeyCode.DPadRight) and (v75.current and v75.current:IsAncestorOf(GuiService.SelectedCoreObject)) then
				Service:setSelectedByOffset(1)
			end
		end)

		return function() -- line: 337
			-- upvalues: FFlagEnableConsoleExpControls (copy), connection (ref), connection2 (copy)
			if FFlagEnableConsoleExpControls then
				connection:Disconnect()
			end

			connection2:Disconnect()
		end
	end, {})

	if v8 then
		React.useEffect(function() -- line: 347
			-- upvalues: IXPServiceWrapper (copy), v9 (copy)
			IXPServiceWrapper:LogFlagLinkedUserLayerExposure(v9)
		end, {})
	end

	local v86 = v77 + ICON_CELL_WIDTH
	local v87 = (not t3 or not t3.items) and 0 or SUB_MENU_ROW_HEIGHT * #t3.items
	local v88 = v87 * ((not isInExperienceUIVREnabled or InExperienceUIVRIXP:isSpatialUIScalingFixEnabled()) and 1 or UIManager.getInstance():getAdditionalCameraScaleIfNeeded())
	local v89 = if not t3.panelSize then v88 else t3.panelSize.Y
	local v90 = isInExperienceUIVREnabled and isSpatial()
	local u91 = if not v90 then math.min(v76.Y - v86, v87) else math.min(v88, v89)

	if not v90 and v87 > v76.Y - v86 then
		local v92 = math.floor((v76.Y - v86) / SUB_MENU_ROW_HEIGHT)

		u91 = if not (SUB_MENU_ROW_HEIGHT * v92 + v85 <= v76.Y - v86) then SUB_MENU_ROW_HEIGHT * v92 - v85 else SUB_MENU_ROW_HEIGHT * v92 + v85
	end

	local t4 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		UISizeConstraint = React.createElement("UISizeConstraint", {
			MinSize = if UserGameSettings.ReducedMotion or not t3.menuTransition then Vector2.new(0, u91) else t3.menuTransition:map(function(p9) -- line: 384
				-- upvalues: u91 (ref)
				return Vector2.new(0, u91 * p9)
			end)
		}),
		BottomPadding = React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 10000,
			Size = UDim2.new(0, 0, 0, SUBMENU_BOTTOM_PADDING)
		})
	}

	for _, v95 in t3.items do
		t4[v95.id] = React.createElement(MenuRow, v95)
	end

	local v96 = useMappedObservableValue(Service:orderAlignment(), isLeft)
	local v97 = v73.Theme.BackgroundUIContrast.Transparency * v73.Settings.PreferredTransparency
	local v98 = if not v90 then if not v96 then Vector2.new(1, 0) else Vector2.zero else Vector2.new(0, 1)

	return React.createElement("Frame", {
		Size = if not v90 then UDim2.new(0, ICON_CELL_WIDTH * 4 + UNIBAR_LEFT_MARGIN + UNIBAR_END_PADDING * 2, 0, 0) else UDim2.new(1, 0, 0, if not v90 then v88 else math.min(v88, v89)),
		AnchorPoint = v98,
		Position = if not v90 then UDim2.new(0, -v77 - 2 + UNIBAR_LEFT_MARGIN, 0, 0) else UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = Theme.BackgroundUIContrast.Color,
		BackgroundTransparency = if not t3.menuTransition then v97 else t3.menuTransition:map(function(p10) -- line: 424
			-- upvalues: v97 (copy)
			return v97 + (1 - v97) * (1 - p10)
		end),
		AutomaticSize = if not v90 then Enum.AutomaticSize.Y else nil,
		ref = v75,
		SelectionGroup = not not FFlagEnableConsoleExpControls or nil,
		SelectionBehaviorDown = if not FFlagEnableConsoleExpControls then nil else Enum.SelectionBehavior.Stop
	}, {
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, SUBMENU_CORNER_RADIUS)
		}),
		ScrollingFrame = React.createElement(VerticalScrollView, {
			selectable = false,
			size = UDim2.new(1, 0, 1, 0),
			canvasSizeY = UDim.new(0, if not v90 then v87 else v88),
			scrollBarType = ScrollBarType.Compact
		}, t4)
	})
end

return function(t5: {[any]: any}) -- line: 450
	-- upvalues: React (copy), useObservableValue (copy), Service (copy), useChromeMenuItems (copy), ReactOtter (copy), t1 (ref), u48 (ref), Constants (copy), UserInputService (copy), vector2 (ref), isInExperienceUIVREnabled (copy), isSpatial (copy), InExperienceUIVRIXP (copy), FFlagUnibarMenuOpenSubmenu (copy), SubMenuContext (copy)
	local t6 = {}
	local v101 = React.useRef(nil)
	local v102 = React.useRef(nil)
	local v103 = React.useRef(nil)
	local v104 = useObservableValue(Service:currentSubMenu())
	local _, v106 = React.useState(0)
	local v107 = useChromeMenuItems()
	local t7 = {}
	local v109, v110 = ReactOtter.useAnimatedBinding(0, function(p11) -- line: 463
		-- upvalues: v106 (copy)
		v106(p11)
	end)

	React.useEffect(function() -- line: 468
		-- upvalues: t1 (ref), t7 (ref), u48 (ref), v104 (copy), v106 (copy), v110 (copy), ReactOtter (copy), Constants (copy), v103 (copy), UserInputService (copy), vector2 (ref), v102 (copy), Service (copy), v101 (copy), isInExperienceUIVREnabled (copy), isSpatial (copy), InExperienceUIVRIXP (copy)
		t1 = t7
		u48 = v104

		if v104 then
			v106(0)
			v110(ReactOtter.spring(1, Constants.MENU_ANIMATION_SPRING))
			v103.current = UserInputService.TouchStarted:Connect(function(p12) -- line: 476
				-- upvalues: vector2 (ref)
				vector2 = Vector2.new(p12.Position.X, p12.Position.Y)
			end)
			v102.current = UserInputService.TouchTap:Connect(function(p13) -- line: 480
				-- upvalues: vector2 (ref), Service (copy)
				if p13[1] - vector2 ~= Vector2.zero then
					return
				end

				local v133 = Service:currentSubMenu():get()

				if v133 then
					Service:toggleSubMenu(v133)
				end
			end)
			v101.current = UserInputService.InputEnded:Connect(function(input, _) -- line: 491
				-- upvalues: isInExperienceUIVREnabled (copy), isSpatial (copy), InExperienceUIVRIXP (copy), Service (copy)
				if isInExperienceUIVREnabled and (isSpatial() and not InExperienceUIVRIXP:isMovePanelToCenter()) then
					return
				end

				local v136 = input.UserInputType == Enum.UserInputType.MouseButton1
				local v137 = Service:currentSubMenu():get()

				if v137 and v136 then
					Service:toggleSubMenu(v137)
				end
			end)
		else
			v106(1)
			v110(ReactOtter.spring(0, Constants.MENU_ANIMATION_SPRING))
		end

		return function() -- line: 512
			-- upvalues: v101 (copy), v102 (copy), v103 (copy)
			if v101.current then
				v101.current:Disconnect()
				v101.current = nil
			end

			if v102.current then
				v102.current:Disconnect()
				v102.current = nil
			end

			if v103.current then
				v103.current:Disconnect()
				v103.current = nil
			end
		end
	end, { v104 })

	if v104 and v107 then
		for _, v112 in v107 do
			if v104 == v112.id then
				t7 = v112.children

				break
			end
		end
	end

	if #t7 > 0 then
		t6[v104] = React.createElement(SubMenu, {
			items = t7,
			menuTransition = v109,
			panelSize = t5.panelSize
		})
	elseif #t1 > 0 then
		t6[u48] = React.createElement(SubMenu, {
			items = t1,
			menuTransition = v109,
			panelSize = t5.panelSize
		})
	end

	return React.createElement("Frame", {
		Name = "SubMenuHost",
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Size = if not isInExperienceUIVREnabled or not isSpatial() then UDim2.new(0, 0, 1, 0) else UDim2.new(1, 0, 1, 0),
		ref = if not FFlagUnibarMenuOpenSubmenu then nil else t5.subMenuHostRef
	}, React.createElement(SubMenuContext.Provider, {
		value = v109
	}, t6))
end
