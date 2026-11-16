local ChromeShared = script:FindFirstAncestor("ChromeShared")

local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local ContextActionService = game:GetService("ContextActionService")
local React = require(CorePackages.Packages.React)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagDebugEnableUnibarDummyIntegrations = SharedFlags.GetFFlagDebugEnableUnibarDummyIntegrations
local GetFIntIconSelectionTimeout = SharedFlags.GetFIntIconSelectionTimeout
local GetFFlagChromeCentralizedConfiguration = SharedFlags.GetFFlagChromeCentralizedConfiguration
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local FFlagAddUILessMode = SharedFlags.FFlagAddUILessMode
local FIntAddUILessModeVariant = SharedFlags.FIntAddUILessModeVariant
local FFlagAppNavMyStatsTab = SharedFlags.FFlagAppNavMyStatsTab

local Flags = require(script.Parent.Parent.Parent.Flags)
local FFlagUnibarMenuOpenSubmenu = Flags.FFlagUnibarMenuOpenSubmenu

local Flags2 = require(ChromeShared.Flags)
local FFlagTokenizeUnibarConstantsWithStyleProvider = Flags2.FFlagTokenizeUnibarConstantsWithStyleProvider
local FFlagEnablePlaytestModeUnibar = SharedFlags.FFlagEnablePlaytestModeUnibar
local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local PlaytestModeThemeProvider = require(ChromeShared.Unibar.PlaytestModeThemeProvider)
local Service = require(ChromeShared.Service)
local Chrome = require(CorePackages.Workspace.Packages.Chrome)
local UnibarStyle = Chrome.UnibarStyle

if not GetFFlagChromeCentralizedConfiguration() then
	require(ChromeShared.Parent.Integrations)
end

local SubMenu = require(ChromeShared.Unibar.SubMenu)
local WindowManager = require(ChromeShared.Unibar.WindowManager)
local ShortcutBar = require(ChromeShared.Shortcuts.ShortcutBar)
local Constants = require(ChromeShared.Unibar.Constants)
local buildMenuOrder = require(ChromeShared.Unibar.buildMenuOrder)

local useChromeMenuItems = require(ChromeShared.Hooks.useChromeMenuItems)
local useObservableValue = require(ChromeShared.Hooks.useObservableValue)
local useMappedObservableValue = require(ChromeShared.Hooks.useMappedObservableValue)

local IconHost = require(ChromeShared.Unibar.ComponentHosts.IconHost)

local ReactOtter = require(CorePackages.Packages.ReactOtter)
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local isSpatial = AppCommonLib.isSpatial
local FFlagReduceTopBarInsetsWhileHidden = SharedFlags.FFlagReduceTopBarInsetsWhileHidden

local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local Stores = CoreGuiCommon.Stores
local Signals = require(CorePackages.Packages.Signals)
local createEffect = Signals.createEffect

local Constants2 = require(ChromeShared.Parent.Integrations.Party.Constants)
local isConnectUnibarEnabled = require(ChromeShared.Parent.Integrations.Connect.isConnectUnibarEnabled)
local GamepadConnector

if FFlagEnableConsoleExpControls then
	GamepadConnector = require(ChromeShared.Parent.Parent.TopBar.Components.GamepadConnector)
else
	GamepadConnector = nil
end

local SharedExperimentDefinition = require(CorePackages.Workspace.Packages.SharedExperimentDefinition)
local isInExperienceUIVREnabled = SharedExperimentDefinition.isInExperienceUIVREnabled
local panel3DInSpatialUI, panelType, observableValue

if isInExperienceUIVREnabled then
	local VrSpatialUi = require(CorePackages.Workspace.Packages.VrSpatialUi)
	panel3DInSpatialUI = VrSpatialUi.Panel3DInSpatialUI
	panelType = VrSpatialUi.Constants.PanelType
	local Observable = require(CorePackages.Workspace.Packages.Observable)
	observableValue = Observable.ObservableValue.new(true)
else
	panel3DInSpatialUI = nil
	observableValue = nil
	panelType = nil
end

if not GetFFlagChromeCentralizedConfiguration() then
	function configureUnibar()
		local menuOrder = buildMenuOrder()

		local v = { "nine_dot", "chat", "toggle_mic_mute" }
		table.insert(v, 3, "join_voice")

		if GetFFlagDebugEnableUnibarDummyIntegrations() then
			table.insert(v, "dummy_window")
			table.insert(v, "dummy_window_2")
		end

		if isConnectUnibarEnabled() then
			table.insert(v, "party_entrypoint")
		end

		local index = table.find(v, "toggle_mic_mute")

		if index then
			table.insert(v, index, Constants2.TOGGLE_MIC_INTEGRATION_ID)
		end

		if FFlagAppNavMyStatsTab then
			table.insert(v, "assistant_build")
		end

		if isInExperienceUIVREnabled and isSpatial() then
			Service:configureMenu({
				{ "vr_toggle_button", "vr_safety_bubble" },
				v
			})
		else
			Service:configureMenu({ v })
		end

		Service:configureSubMenu("nine_dot", menuOrder)
	end

	configureUnibar()

	if FFlagEnableConsoleExpControls then
		local ConfigureShortcuts = require(script.Parent.Parent.Shortcuts.ConfigureShortcuts)
		ConfigureShortcuts()
	end
end

function IconDivider(props)
	local v = useStyle()
	local ICON_DIVIDER_POSITION

	if FFlagTokenizeUnibarConstantsWithStyleProvider then
		ICON_DIVIDER_POSITION = UnibarStyle.use().ICON_DIVIDER_POSITION
	else
		ICON_DIVIDER_POSITION = Constants.ICON_DIVIDER_POSITION
	end

	local createElement = React.createElement
	local v2 = {
		Position = props.position,
		Size = UDim2.new(0, Constants.DIVIDER_CELL_WIDTH, 1, 0),
		BorderSizePixel = 0,
		BackgroundTransparency = 1
	}

	local createElement2 = React.createElement
	local v3 = {
		Position = ICON_DIVIDER_POSITION,
		AnchorPoint = Vector2.new(0, 0.5),
		Size = Constants.ICON_DIVIDER_SIZE,
		BorderSizePixel = 0,
		BackgroundColor3 = v.Theme.Divider.Color,
		BackgroundTransparency = 0,
		Visible = 0
	}
	local backgroundTransparency

	if props.toggleTransition then
		backgroundTransparency = props.toggleTransition:map(function(p)
			return v.Theme.Divider.Transparency + (1 - p) * (1 - v.Theme.Divider.Transparency)
		end)
	else
		backgroundTransparency = v.Theme.Divider.Transparency
	end

	v3.BackgroundTransparency = backgroundTransparency

	v3.Visible = props.visible or true
	return createElement("Frame", v2, { DividerBar = createElement2("Frame", v3) })
end

local function getSelectedChild(menuFrameRef, p: string?) -- 2 equivalent calls inferred from this helper
	return menuFrameRef.current:FindFirstChild(Constants.ICON_NAME_PREFIX .. tostring(p), true)
end

function AnimationStateHelper(data): nil
	local v = useObservableValue(Service:currentSubMenu())

	local v2 = useObservableValue(Service:selectedItem())
	local v3 = useObservableValue(Service:inFocusNav())

	React.useEffect(function()
		if v3 then
			if not FFlagEnableConsoleExpControls then
				ContextActionService:BindCoreAction("RBXEscapeUnibar", function(_, p, _)
					if FFlagEnableConsoleExpControls then
						if p == Enum.UserInputState.End then
							Service:disableFocusNav()
							GuiService.SelectedCoreObject = nil
						end
					else
						Service:disableFocusNav()
					end
				end, false, Enum.KeyCode.ButtonB)
			end

			if FFlagEnableConsoleExpControls then
				if data.menuFrameRef.current then
					local selectedChild = getSelectedChild(data.menuFrameRef, v2) -- inferred equivalent call

					if selectedChild then
						GuiService.SelectedCoreObject = selectedChild
						return
					end

					if not FFlagUnibarMenuOpenSubmenu then
						GuiService:Select(data.menuFrameRef.current)
						return
					end

					if FFlagEnableConsoleExpControls then
						Service:selectedItem():set("nine_dot")
					end

					Service:toggleSubMenu("nine_dot")
				end
			elseif data.menuFrameRef.current then
				GuiService:Select(data.menuFrameRef.current)
			end
		else
			ContextActionService:UnbindCoreAction("RBXEscapeUnibar")

			if
				GuiService.SelectedCoreObject
				and data.menuFrameRef.current:IsAncestorOf(GuiService.SelectedCoreObject)
			then
				GuiService.SelectedCoreObject = nil
			end
		end
	end, { v3 })

	React.useEffect(function()
		if v ~= "nine_dot" then
			data.setToggleSubmenuTransition((ReactOtter.spring(0, Constants.MENU_ANIMATION_SPRING)))

			return
		end

		if FFlagUnibarMenuOpenSubmenu and v3 then
			GuiService:Select(data.subMenuHostRef.current)
		end

		data.setToggleSubmenuTransition((ReactOtter.spring(1, Constants.MENU_ANIMATION_SPRING)))
	end, { v })

	local useEffect = React.useEffect
	local function fn()
		if FFlagEnableConsoleExpControls and v == v2 then
			return
		end

		local thread = coroutine.create(function()
			local count = 0

			while count < GetFIntIconSelectionTimeout() do
				count += 1
				task.wait()

				if not (data.menuFrameRef.current and v2) then
					continue
				end

				local selectedCoreObject

				if FFlagEnableConsoleExpControls then
					selectedCoreObject = getSelectedChild(data.menuFrameRef, v2) -- inferred equivalent call
				else
					selectedCoreObject = data.menuFrameRef.current:FindFirstChild("IconHitArea_" .. v2, true)
				end

				if selectedCoreObject then
					GuiService.SelectedCoreObject = selectedCoreObject
					break
				end
			end
		end)
		coroutine.resume(thread)
	end

	local v4

	if FFlagEnableConsoleExpControls then
		v4 = v
	end

	useEffect(fn, { v2, v4 })

	return nil
end

function linearInterpolation(p: number, p2: number, p3: number)
	return p * (1 - p3) + p2 * p3
end

function IconPositionBinding(p, p2: number, p3: number, p4: number, p5, p6, flag: boolean, flag2: boolean?, p7)
	local UNIBAR_END_PADDING

	if FFlagTokenizeUnibarConstantsWithStyleProvider then
		UNIBAR_END_PADDING = UnibarStyle.use().UNIBAR_END_PADDING
	else
		UNIBAR_END_PADDING = Constants.UNIBAR_END_PADDING
	end

	return (React.joinBindings({ p, p5, p6 }):map(function(list)
		local v

		if p7.current then
			v = linearInterpolation(p3, p2, list[2])
		else
			v = linearInterpolation(p2, p3, list[2])
		end

		local v2 = p4

		if flag2 and not flag then
			v2 = p4 - list[3]
		end

		local v3 = v - v2

		return UDim2.new(0, UNIBAR_END_PADDING + v2 + v3 * list[1], 0, 0)
	end))
end

local function onUnibarSelectionChanged(instance, _: boolean, _, descendant)
	if not instance:IsAncestorOf(descendant) then
		Service:disableFocusNav()
	end
end

function isLeft(p): boolean
	return p == Enum.HorizontalAlignment.Left
end

function Unibar(props)
	local ICON_CELL_WIDTH, UNIBAR_END_PADDING

	if FFlagTokenizeUnibarConstantsWithStyleProvider then
		local v = UnibarStyle.use()
		ICON_CELL_WIDTH = v.ICON_CELL_WIDTH
		UNIBAR_END_PADDING = v.UNIBAR_END_PADDING
	else
		ICON_CELL_WIDTH = Constants.ICON_CELL_WIDTH
		UNIBAR_END_PADDING = Constants.UNIBAR_END_PADDING
	end

	local current3 = {}
	local ref = React.useRef({})
	local ref2 = React.useRef(Vector2.zero)

	local ref3 = React.useRef(Vector2.zero)
	local ref4

	if FFlagAddUILessMode and FIntAddUILessModeVariant ~= 0 and Stores.GetUILessStore then
		ref4 = React.useRef(Stores.GetUILessStore(false))
	else
		ref4 = nil
	end

	local v = false
	local current = ref.current or {}

	local v2 = useChromeMenuItems()

	local v3, setToggleIconTransition = ReactOtter.useAnimatedBinding(1)
	local toggleTransition, setToggleWidthTransition = ReactOtter.useAnimatedBinding(1)
	local v4, v5 = ReactOtter.useAnimatedBinding(0)
	local ref5 = React.useRef(0)
	local v6, v7 = ReactOtter.useAnimatedBinding(1)
	local ref6 = React.useRef(false)
	local ref7 = React.useRef(0)

	local v8 = Service:currentSubMenu():get() == "nine_dot"

	local toggleTransition2, setToggleSubmenuTransition = ReactOtter.useAnimatedBinding(v8 and 1 or 0)

	local children = {}
	local count = 0
	local total = 0
	local total2 = 0
	local v9 = 0

	local v10 = React.useCallback(function(p)
		local current2 = Vector2.zero
		local current4 = Vector2.zero

		if p then
			current2 = p.AbsolutePosition
			current4 = p.AbsoluteSize

			if current2 ~= ref2.current then
				ref2.current = current2
				Service:setMenuAbsolutePosition(current2)
			end

			if FFlagReduceTopBarInsetsWhileHidden and current4 ~= ref3.current then
				ref3.current = current4
			end

			if FFlagAddUILessMode and FIntAddUILessModeVariant ~= 0 and ref4.current.getUILessModeEnabled(false) then
				if current2 ~= ref2.current then
					ref2.current = current2
					Service:setMenuAbsolutePosition(current2)
				end

				if current4 ~= ref3.current then
					ref3.current = current4
				end
			end
		end

		if FFlagReduceTopBarInsetsWhileHidden and GamepadConnector then
			if p and props.onAreaChanged and GamepadConnector:getShowTopBar():get() then
				props.onAreaChanged(Constants.UNIBAR_KEEP_OUT_AREA_ID, current2, current4)
			end
		elseif FFlagAddUILessMode and FIntAddUILessModeVariant ~= 0 and ref4.current.getUILessModeEnabled(false) then
			if p and props.onAreaChanged and ref4.current.getUIVisible(false) then
				props.onAreaChanged(Constants.UNIBAR_KEEP_OUT_AREA_ID, current2, current4)
			end
		elseif p and props.onAreaChanged then
			props.onAreaChanged(Constants.UNIBAR_KEEP_OUT_AREA_ID, current2, p.AbsoluteSize)
		end
	end, {})

	local mapped = React.joinBindings({ toggleTransition, v4 }):map(function(list)
		return UDim2.new(0, linearInterpolation(v9, list[2], list[1]), 0, ICON_CELL_WIDTH)
	end)

	local v11 = useMappedObservableValue(Service:orderAlignment(), isLeft)

	for _, v12 in v2 do
		if v12.integration.availability:get() == Service.AvailabilitySignal.Pinned then
			count += 1
		end
	end

	local v12 = v11 and 1 or math.max(count - 1, 0)

	for k, integration in v2 do
		if integration.isDivider then
			local v13 = total + ICON_CELL_WIDTH * v12

			local v14 = current[integration.id] or total
			current3[integration.id] = total
			v = v or v14 ~= total
			local position = IconPositionBinding(v3, v14, total, v13, v6, v4, false, v11, ref6)
			local visible

			if v11 then
				visible = React.joinBindings({ position, mapped }):map(function(list): boolean
					local offset = list[1].X.Offset
					return ICON_CELL_WIDTH * 0.5 <= offset
				end)
			else
				visible = React.joinBindings({ position, mapped }):map(function(list): boolean
					local item = list[1]
					local item2 = list[2]
					return item.X.Offset <= item2.X.Offset - ICON_CELL_WIDTH
				end)
			end

			children[integration.id or "icon" .. k] = React.createElement(IconDivider, {
				position = position,
				visible = visible,
				toggleTransition = toggleTransition
			})

			total += Constants.DIVIDER_CELL_WIDTH
		elseif integration.integration then
			local v13 = total + ICON_CELL_WIDTH * v12
			local flag

			if integration.integration.availability:get() == Service.AvailabilitySignal.Pinned then
				v13 = total2
				flag = true
			else
				flag = false
			end

			local v14

			if current[integration.id] == nil then
				v14 = total
			else
				v14 = current[integration.id]
			end

			current3[integration.id] = total
			v = v or v14 ~= total
			local position = IconPositionBinding(v3, v14, total, v13, v6, v4, flag, v11, ref6)
			local v15

			if v11 then
				v15 = React.joinBindings({ position, mapped }):map(function(list): boolean
					local offset = list[1].X.Offset
					return ICON_CELL_WIDTH * 0.5 <= offset
				end)
			else
				v15 = React.joinBindings({ position, mapped }):map(function(list): boolean
					local item = list[1]
					local item2 = list[2]
					return item.X.Offset <= item2.X.Offset - ICON_CELL_WIDTH * 1.5
				end)
			end

			children[integration.id or "icon" .. k] = React.createElement(IconHost, {
				position = position,
				visible = flag or v15,
				toggleTransition = toggleTransition2,
				integration = integration
			})

			total += ICON_CELL_WIDTH

			if flag then
				total2 += ICON_CELL_WIDTH
			end
		end
	end

	v9 = total

	if props.onMinWidthChanged then
		props.onMinWidthChanged(v9)
	end

	local current4 = UNIBAR_END_PADDING * 2 + total

	React.useEffect(function()
		local current2 = ref5.current

		if v4:getValue() == 0 then
			v5((ReactOtter.instant(current4)))
			ref5.current = current4
		elseif current2 ~= current4 then
			v5(ReactOtter.spring(current4, Constants.MENU_ANIMATION_SPRING))
			ref5.current = current4
		end

		Service:setMenuAbsoluteSize(Vector2.new(current4, ICON_CELL_WIDTH))
	end, { current4 })

	if v then
		ref7.current = (ref7.current or 0) + 1
	end

	ref.current = current3

	React.useEffect(function()
		if ref6.current then
			v7(ReactOtter.spring(1, Constants.MENU_ANIMATION_SPRING))
			ref6.current = false
		else
			v7(ReactOtter.spring(0, Constants.MENU_ANIMATION_SPRING))
			ref6.current = true
		end
	end, { ref7.current, ref6 })

	React.useEffect(function()
		if FFlagReduceTopBarInsetsWhileHidden and GamepadConnector then
			local showTopBar = GamepadConnector:getShowTopBar()
			showTopBar:connect(function()
				if showTopBar:get() then
					props.onAreaChanged(Constants.UNIBAR_KEEP_OUT_AREA_ID, ref2.current, ref3.current)
				else
					props.onAreaChanged(Constants.UNIBAR_KEEP_OUT_AREA_ID, Vector2.zero, Vector2.zero)
				end
			end)
			props.onAreaChanged(Constants.UNIBAR_KEEP_OUT_AREA_ID, Vector2.zero, Vector2.zero)
		end
	end, {})

	React.useEffect(function()
		local v13

		if FFlagAddUILessMode and FIntAddUILessModeVariant ~= 0 and ref4.current.getUILessModeEnabled(false) then
			v13 = createEffect(function(p)
				if ref4.current.getUIVisible(p) then
					props.onAreaChanged(Constants.UNIBAR_KEEP_OUT_AREA_ID, ref2.current, ref3.current)
				else
					props.onAreaChanged(Constants.UNIBAR_KEEP_OUT_AREA_ID, Vector2.zero, Vector2.zero)
				end
			end)
			props.onAreaChanged(Constants.UNIBAR_KEEP_OUT_AREA_ID, Vector2.zero, Vector2.zero)
		else
			v13 = nil
		end

		return function()
			if v13 then
				v13()
			end
		end
	end, {})

	local v13 = useStyle()

	local createElement = React.createElement

	local v14 = {
		Size = mapped,
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		SelectionGroup = true,
		ref = props.menuFrameRef,
		[React.Change.AbsoluteSize] = v10,
		[React.Change.AbsolutePosition] = v10
	}

	local createElement2 = React.createElement
	local animationStateHelper = AnimationStateHelper
	local v15 = {
		setToggleIconTransition = setToggleIconTransition,
		setToggleWidthTransition = setToggleWidthTransition,
		setToggleSubmenuTransition = setToggleSubmenuTransition,
		menuFrameRef = props.menuFrameRef,
		subMenuHostRef = 0
	}
	local subMenuHostRef

	if FFlagUnibarMenuOpenSubmenu then
		subMenuHostRef = props.subMenuHostRef
	end

	v15.subMenuHostRef = subMenuHostRef
	return createElement("Frame", v14, {
		createElement2(animationStateHelper, v15),
		React.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = v13.Theme.BackgroundUIContrast.Color,
			BackgroundTransparency = v13.Theme.BackgroundUIContrast.Transparency * v13.Settings.PreferredTransparency
		}, {
			UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(1, 0) })
		}),
		React.createElement(
			"Frame",
			{ Size = UDim2.new(1, 0, 1, 0), BorderSizePixel = 0, BackgroundTransparency = 1 },
			children
		)
	})
end

local function UnibarPills(p)
	local v = useStyle()
	local UNIBAR_END_PADDING, MENU_SUBMENU_PADDING

	if FFlagTokenizeUnibarConstantsWithStyleProvider then
		local v2 = UnibarStyle.use()
		UNIBAR_END_PADDING = v2.UNIBAR_END_PADDING
		MENU_SUBMENU_PADDING = v2.MENU_SUBMENU_PADDING
	else
		UNIBAR_END_PADDING = Constants.UNIBAR_END_PADDING
		MENU_SUBMENU_PADDING = Constants.MENU_SUBMENU_PADDING
	end

	local v2 = useChromeMenuItems()

	local v3 = Service:currentSubMenu():get() == "nine_dot"

	local toggleTransition, setToggleSubmenuTransition = ReactOtter.useAnimatedBinding(v3 and 1 or 0)

	assert(v2 ~= nil, "Menu items should not be nil")

	local children = {}
	local elements = {}

	for k, integration in v2 do
		if integration.integration and integration.isDivider == false then
			children["icon_host" .. k] = React.createElement(IconHost, {
				toggleTransition = toggleTransition,
				integration = integration
			})
		end

		if not (integration.isDivider or k == #v2) then
			continue
		end

		local element = React.createElement("Frame", {
			Size = UDim2.new(0, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.XY,
			BorderSizePixel = 0,
			BackgroundColor3 = v.Theme.BackgroundUIContrast.Color,
			BackgroundTransparency = v.Theme.BackgroundUIContrast.Transparency * v.Settings.PreferredTransparency
		}, {
			UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(1, 0) }),
			Padding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, UNIBAR_END_PADDING),
				PaddingRight = UDim.new(0, UNIBAR_END_PADDING)
			}),
			PillsHorizontalList = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center
			})
		}, children)

		elements["pill_" .. k] = element
		children = {}
	end

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		SelectionGroup = true,
		ref = p.menuFrameRef,
		AutomaticSize = Enum.AutomaticSize.XY
	}, {
		React.createElement(AnimationStateHelper, {
			setToggleSubmenuTransition = setToggleSubmenuTransition,
			menuFrameRef = p.menuFrameRef,
			subMenuHostRef = p.subMenuHostRef
		}),
		React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, MENU_SUBMENU_PADDING)
		})
	}, elements)
end

local function SubMenuWrapper(p)
	if isInExperienceUIVREnabled and isSpatial() and panel3DInSpatialUI then
		observableValue:set(useObservableValue(Service:currentSubMenu()) ~= nil)
	end

	local renderFunction = React.useCallback(function(panelSize: Vector2)
		return (React.createElement(SubMenu, {
			subMenuHostRef = p.subMenuHostRef,
			panelSize = panelSize
		}))
	end, { p.subMenuHostRef })

	if isInExperienceUIVREnabled and isSpatial() and panel3DInSpatialUI then
		return (React.createElement(panel3DInSpatialUI, {
			panelType = panelType.ChromeSubMenu,
			renderFunction = renderFunction,
			visibilityObservable = observableValue
		}))
	end

	return (React.createElement(SubMenu, { subMenuHostRef = p.subMenuHostRef }))
end

return React.memo(function(props)
	local MENU_SUBMENU_PADDING

	if FFlagTokenizeUnibarConstantsWithStyleProvider then
		MENU_SUBMENU_PADDING = UnibarStyle.use().MENU_SUBMENU_PADDING
	else
		MENU_SUBMENU_PADDING = Constants.MENU_SUBMENU_PADDING
	end

	local menuFrameRef = React.useRef(nil)

	if FFlagEnableConsoleExpControls and props.menuRef then
		menuFrameRef = props.menuRef
	end

	local ref = React.useRef(nil)
	local ref2

	if FFlagUnibarMenuOpenSubmenu then
		ref2 = React.useRef(nil)
	end

	local function updateSize() -- 1 equivalent call inferred from this helper
		if ref.current and menuFrameRef.current then
			ref.current.Size = menuFrameRef.current.Size
		end
	end

	local v = useMappedObservableValue(Service:orderAlignment(), isLeft)
	local visible, v2, v3

	if FFlagEnableConsoleExpControls and GamepadConnector then
		visible, v2 = React.useBinding(GamepadConnector:getShowTopBar():get())
		v3 = GamepadConnector:getShowTopBar()
	else
		v3 = nil
		v2 = nil
	end

	local ref3

	if FFlagAddUILessMode and FIntAddUILessModeVariant ~= 0 and Stores.GetUILessStore then
		ref3 = React.useRef(Stores.GetUILessStore(false))

		if ref3.current.getUILessModeEnabled(false) then
			visible, v2 = React.useBinding(true)
		end
	else
		ref3 = nil
	end

	React.useEffect(function()
		local sizeChangedConnection

		if menuFrameRef and menuFrameRef.current then
			sizeChangedConnection = menuFrameRef.current:GetPropertyChangedSignal("Size"):Connect(updateSize)
		else
			sizeChangedConnection = nil
		end

		updateSize() -- inferred equivalent call

		if FFlagEnableConsoleExpControls then
			v3:connect(function()
				v2(v3:get())
			end)
		end

		return function()
			if sizeChangedConnection then
				sizeChangedConnection:disconnect()
			end
		end
	end)

	React.useEffect(function()
		local v4

		if FFlagAddUILessMode and FIntAddUILessModeVariant ~= 0 and ref3.current.getUILessModeEnabled(false) then
			v4 = createEffect(function(p)
				v2(ref3.current.getUIVisible(p))
			end)
		else
			v4 = nil
		end

		return function()
			if v4 then
				v4()
			end
		end
	end, {})
	local unibar2

	if isInExperienceUIVREnabled and isSpatial() then
		unibar2 = React.createElement(UnibarPills, {
			menuFrameRef = menuFrameRef,
			subMenuHostRef = ref2
		})
	else
		local createElement = React.createElement
		local unibar = Unibar
		local v4 = {
			menuFrameRef = menuFrameRef,
			subMenuHostRef = nil,
			onAreaChanged = 0,
			onMinWidthChanged = 0
		}
		local subMenuHostRef

		if FFlagUnibarMenuOpenSubmenu then
			subMenuHostRef = ref2
		end

		v4.subMenuHostRef = subMenuHostRef
		v4.onAreaChanged = props.onAreaChanged
		v4.onMinWidthChanged = props.onMinWidthChanged
		unibar2 = createElement(unibar, v4)
	end

	if FFlagEnablePlaytestModeUnibar then
		unibar2 = React.createElement(
			"Frame",
			{
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundTransparency = 1,
				BorderSizePixel = 0
			},
			{
				PlaytestModeThemeProvider = React.createElement(PlaytestModeThemeProvider, nil, {
					Unibar = unibar2
				})
			}
		)
	end

	local createElement = React.createElement
	local v4 = {}
	v4.Name = "UnibarMenu"
	v4.AutomaticSize = Enum.AutomaticSize.Y
	v4.BorderSizePixel = 0
	v4.BackgroundTransparency = 1
	v4.LayoutOrder = props.layoutOrder
	v4.SelectionGroup = true
	v4.SelectionBehaviorUp = Enum.SelectionBehavior.Stop
	local selectionBehaviorLeft

	if not FFlagEnableConsoleExpControls then
		selectionBehaviorLeft = Enum.SelectionBehavior.Stop
	end

	v4.SelectionBehaviorLeft = selectionBehaviorLeft
	v4.SelectionBehaviorRight = Enum.SelectionBehavior.Stop
	v4.ref = ref
	local selectionChanged = React.Event.SelectionChanged
	local v5

	if FFlagEnableConsoleExpControls then
		v5 = onUnibarSelectionChanged
	end

	v4[selectionChanged] = v5

	if
		not FFlagEnableConsoleExpControls
		and (not FFlagAddUILessMode or FIntAddUILessModeVariant == 0 or not ref3.current.getUILessModeEnabled(false))
	then
		visible = nil
	end

	v4.Visible = visible

	local createElement2 = React.createElement
	local v6 = {
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = 0,
		VerticalAlignment = 0,
		Padding = 0
	}
	local horizontalAlignment

	if v then
		horizontalAlignment = Enum.HorizontalAlignment.Left
	else
		horizontalAlignment = Enum.HorizontalAlignment.Right
	end

	v6.HorizontalAlignment = horizontalAlignment

	v6.VerticalAlignment = Enum.VerticalAlignment.Top
	v6.Padding = UDim.new(0, MENU_SUBMENU_PADDING)
	local element = createElement2("UIListLayout", v6)
	local v7

	if isInExperienceUIVREnabled then
		v7 = React.createElement(SubMenuWrapper, { subMenuHostRef = ref2 })
	else
		v7 = React.createElement(SubMenu, { subMenuHostRef = ref2 })
	end

	local v8

	if FFlagEnableConsoleExpControls then
		v8 = React.createElement(ShortcutBar)
	end

	return { createElement("Frame", v4, {
			element,
			unibar2,
			v7,
			v8,
			(React.createElement(WindowManager))
		}) }
end, function(_, _): boolean
	return true
end)
