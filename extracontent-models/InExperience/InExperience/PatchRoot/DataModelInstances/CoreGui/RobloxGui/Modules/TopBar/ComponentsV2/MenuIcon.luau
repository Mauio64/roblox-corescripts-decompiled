game:GetService("ContextActionService")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local GamepadService = game:GetService("GamepadService")
local GuiService = game:GetService("GuiService")
game:GetService("VRService")

local parent = script.Parent.Parent
local parent2 = parent.Parent
local chrome = parent2.Chrome

local Service = require(chrome.Service)
local Constants = require(parent.Constants)
local InGameMenuConstants = require(parent2.InGameMenuConstants)
local Constants2 = require(chrome.ChromeShared.Unibar.Constants)

local Chrome = require(CorePackages.Workspace.Packages.Chrome)
local FocusUtils = Chrome.FocusUtils
local Display = require(CorePackages.Workspace.Packages.Display)
local Foundation = require(CorePackages.Packages.Foundation)
local Motion = require(CorePackages.Packages.Motion)
local React = require(CorePackages.Packages.React)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local CoreScriptsCommon = require(CorePackages.Workspace.Packages.CoreScriptsCommon)
local SettingsShowSignal = CoreScriptsCommon.SettingsShowSignal
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local Signals = require(CorePackages.Packages.Signals)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local UIBlox = require(CorePackages.Packages.UIBlox)

local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local isSpatial = AppCommonLib.isSpatial
local FFlagShowUnibarOnVirtualCursor = SharedFlags.FFlagShowUnibarOnVirtualCursor
local isSideSheetEnabled = require(CorePackages.Workspace.Packages.InExperienceSideSheetUtils.isSideSheetEnabled)
local FFlagSideSheetFocusNav = SharedFlags.FFlagSideSheetFocusNav
local FFlagEnablePlaytestModeUnibar = SharedFlags.FFlagEnablePlaytestModeUnibar

local View = Foundation.View
local Icon = Foundation.Icon
local ControlState = Foundation.Enums.ControlState
local useTokens = Foundation.Hooks.useTokens
local useCursor = Foundation.Hooks.useCursor

local useIsPlaytestMode = require(chrome.ChromeShared.Hooks.useIsPlaytestMode)

local InExperienceSideSheet = require(CorePackages.Workspace.Packages.InExperienceSideSheet)
local getSideSheetVisibility = InExperienceSideSheet.getSideSheetVisibility

local menuIconHoveredSignal = require(parent.Components.Presentation.menuIconHoveredSignal)
local BadgeOver12 = require(parent.Components.Presentation.BadgeOver12)
local withTooltip = UIBlox.App.Dialog.TooltipV2.withTooltip
local TooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation

local TooltipCallout = UIBlox.App.Dialog.TooltipCallout
local VrSpatialUi = require(CorePackages.Workspace.Packages.VrSpatialUi)
local UIManager = VrSpatialUi.UIManager
local Panel3DInSpatialUI = VrSpatialUi.Panel3DInSpatialUI
local PanelType = VrSpatialUi.Constants.PanelType
local SPATIAL_TOOLTIP_SPACING = VrSpatialUi.Constants.SPATIAL_TOOLTIP_SPACING
local v

if FFlagEnablePlaytestModeUnibar then
	v = Foundation.Utility.getTokens(Foundation.Enums.ColorMode.Light)
else
	v = nil
end

local hotkeyCodes = { Enum.KeyCode.Escape }

local function fn(): boolean -- 3 equivalent calls inferred from this helper
	if not isSpatial() then
		return false
	end

	local v2 = Service:showTopBar()
	local bottomBarInteractionOnAnimationSupported = UIManager.getInstance():isBottomBarInteractionOnAnimationSupported()
	return not (v2 or bottomBarInteractionOnAnimationSupported)
end

local function MenuIcon(data)
	local v2 = useTokens()
	local v3

	if FFlagEnablePlaytestModeUnibar then
		v3 = useIsPlaytestMode()
	end

	local style

	if FFlagEnablePlaytestModeUnibar and v3 then
		style = v.Color.Content.Emphasis
	elseif isSideSheetEnabled then
		style = v2.Color.ActionEmphasis.Foreground
	else
		style = nil
	end

	local overMedia_0

	if FFlagEnablePlaytestModeUnibar and v3 then
		overMedia_0 = v.Color.OverMedia.OverMedia_0
	else
		overMedia_0 = v2.Color.OverMedia.OverMedia_0
	end

	local v4 = SignalsReact.useSignalState(function(p)
		return Display.GetDisplayStore(p).getUIScale(p)
	end)

	local v5 = Constants.TopBarButtonPadding * v4

	local size = Constants.MENU_ICON_SIZE * v4
	local v6 = React.useMemo(function()
		return {
			menuOpen = Motion.createState({
				size = size * Constants.MenuIconOpenScale
			}),
			menuClosed = Motion.createState({ size = size })
		}
	end, { v4 })
	local v7, v8 = Motion.useMotion(v6.menuClosed)

	local v9, v10 = React.useBinding(GuiService.PreferredTransparency)

	local ref = React.useRef(false)
	local ref2 = React.useRef(false)
	local child

	if data.unibarMenuRef and data.unibarMenuRef.current then
		local v11 = Service:menuList():get()[1]
		local v12

		if v11 then
			v12 = Constants2.ICON_NAME_PREFIX .. v11.id
		end

		if data.unibarMenuRef.current and v12 then
			child = data.unibarMenuRef.current:FindFirstChild(v12, true)
		else
			child = nil
		end
	else
		child = nil
	end

	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(Vector2.zero)
	local state3, setState3 = React.useState(Vector2.zero)

	local selectionImageObject = useCursor(Foundation.Enums.CursorType.SkinToneCircle)

	local ref3 = React.useRef("Roblox Menu")
	local v11 = {
		textAlignment = Enum.TextXAlignment.Center,
		headerText = ref3.current,
		hotkeyCodes = hotkeyCodes
	}

	local v12 = {
		active = state,
		guiTarget = CoreGui,
		preferredOrientation = TooltipOrientation.Bottom,
		DisplayOrder = 10
	}

	React.useEffect(function()
		pcall(function()
			ref3.current = RobloxTranslator:FormatByKey("CoreScripts.TopBar.RobloxMenu")
		end)

		local preferredTransparencyChangedConnection = GuiService:GetPropertyChangedSignal("PreferredTransparency"):Connect(function()
			v10(GuiService.PreferredTransparency)
		end)
		local connection = SettingsShowSignal:connect(function(p)
			local v13 = if p then v6.menuOpen else v6.menuClosed
			v8(v13)
		end)
		local v13

		if isSideSheetEnabled then
			v13 = Signals.createEffect(function(p)
				local v14

				if getSideSheetVisibility(p) then
					v14 = v6.menuOpen
				else
					v14 = v6.menuClosed
				end

				v8(v14)
			end)
		else
			v13 = nil
		end

		local connection2

		if data.menuIconRef then
			connection2 = Service:onTriggerMenuIcon():connect(function()
				GuiService.SelectedCoreObject = data.menuIconRef.current
				FocusUtils.MenuIconSelectedSignal:set(true)
			end)
		else
			connection2 = nil
		end

		return function()
			if isSideSheetEnabled and v13 then
				v13()
			end

			preferredTransparencyChangedConnection:Disconnect()
			connection:Disconnect()

			if connection2 then
				connection2:disconnect()
			end
		end
	end, {})

	local ref4 = React.useRef(ControlState.Default)
	local v13 = React.useCallback(function(current)
		if current == ControlState.Hover then
			if fn() then -- inferred equivalent call
				return
			end

			ref2.current = true
			menuIconHoveredSignal:fire(true)

			task.delay(0.65, function()
				if ref2.current and not ref.current then
					if fn() then -- inferred equivalent call
						return
					end

					setState(true)
				end
			end)
		elseif current == ControlState.Selected then
			FocusUtils.MenuIconSelectedSignal:set(true)
		elseif current == ControlState.Default then
			if ref4.current == ControlState.Hover then
				setState(false)
				ref2.current = false
				ref.current = false
			elseif ref4.current == ControlState.Selected then
				if
					not (FFlagShowUnibarOnVirtualCursor and GamepadService.GamepadCursorEnabled)
					and GuiService.SelectedCoreObject
					and string.find(GuiService.SelectedCoreObject.Name, Constants2.ICON_NAME_PREFIX)
				then
					Service:enableFocusNav()
				end

				FocusUtils.MenuIconSelectedSignal:set(false)
			end
		end

		ref4.current = current
	end, {})

	local v14 = React.useCallback(function()
		setState(false)
		ref.current = true

		if fn() then -- inferred equivalent call
			return
		end

		local SettingsHub = require(parent2.Settings.SettingsHub)
		SettingsHub:ToggleVisibility(InGameMenuConstants.AnalyticsMenuOpenTypes.TopbarButton)
	end, {})

	local function renderWithTooltipCompat(p, p2, callback)
		if not isSpatial() then
			return withTooltip(p, p2, callback)
		end

		local function fn2(p3)
			setState2(p3.AbsoluteSize)
			setState3(p3.AbsolutePosition)
		end
		local renderFunction = React.useCallback(function(vector2: Vector2)
			return React.createElement(TooltipCallout, {
				textAlignment = Enum.TextXAlignment.Center,
				headerText = p.headerText,
				orientation = TooltipOrientation.Top,
				distanceOffset = 0,
				triggerPointCenter = Vector2.new(state3.X + state2.X / 2, vector2.Y - SPATIAL_TOOLTIP_SPACING),
				contentOffsetVector = Vector2.zero,
				triggerPointRadius = Vector2.zero
			})
		end, { p, state3, state2 })
		local createElement = React.createElement
		local fragment = React.Fragment
		local vrSpatialTooltip

		if p2.active and state2 and Panel3DInSpatialUI then
			vrSpatialTooltip = React.createElement(Panel3DInSpatialUI, {
				panelType = PanelType.ToolTipsContainer,
				renderFunction = renderFunction
			})
		end

		return createElement(fragment, nil, {
			["VRSpatialTooltip"] = vrSpatialTooltip,
			MenuIconTriggerPoint = callback(fn2)
		})
	end

	return renderWithTooltipCompat(v11, v12, React.useCallback(function(p)
		local createElement = React.createElement
		local backgroundStyle

		if not isSideSheetEnabled then
			backgroundStyle = v9:map(function(p2)
				local v15 = overMedia_0
				v15.Transparency *= p2
				return v15
			end)
		end

		local size2

		if data.buttonSize then
			size2 = UDim2.fromOffset(data.buttonSize, data.buttonSize)
		else
			size2 = UDim2.fromScale(1, 1)
		end

		local v15 = {
			tag = "radius-circle aspect-1-1",
			backgroundStyle = backgroundStyle,
			Size = size2,
			NextSelectionRight = child,
			selection = isSideSheetEnabled and FFlagSideSheetFocusNav and { Selectable = false } or {
				Selectable = true,
				SelectionImageObject = selectionImageObject
			},
			selectionGroup = {
				SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
				SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
				SelectionBehaviorDown = Enum.SelectionBehavior.Stop
			},
			ref = data.menuIconRef,
			onAbsoluteSizeChanged = p,
			onAbsolutePositionChanged = p,
			onActivated = 0,
			onStateChanged = 0
		}
		local onActivated

		if not isSideSheetEnabled then
			onActivated = v14
		end

		v15.onActivated = onActivated
		local onStateChanged

		if not isSideSheetEnabled then
			onStateChanged = v13
		end

		v15.onStateChanged = onStateChanged
		local badgeOver

		if data.showBadgeOver12 then
			badgeOver = React.createElement(BadgeOver12, {
				position = UDim2.new(0, 1, 1, -(v5 + 1))
			})
		end

		return createElement(View, v15, {
			BadgeOver12 = badgeOver,
			Icon = React.createElement(Icon, {
				name = Foundation.Enums.IconName.Tilt,
				size = v7.size,
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				style = style
			})
		})
	end, {
		v9,
		child,
		selectionImageObject,
		v14,
		v13,
		data.showBadgeOver12,
		style,
		overMedia_0,
		data.buttonSize
	}))
end

return MenuIcon
