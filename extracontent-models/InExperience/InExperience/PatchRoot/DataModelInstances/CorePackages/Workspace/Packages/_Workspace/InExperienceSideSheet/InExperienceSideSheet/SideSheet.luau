local ContextActionService = game:GetService("ContextActionService")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")

local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")
local parent = InExperienceSideSheet.Parent

local Chrome = require(parent.Chrome)
local CoreScriptsCommon = require(parent.CoreScriptsCommon)
local Display = require(parent.Display)
local Drawer = require(parent.Drawer)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local Foundation = require(parent.Foundation)
local PioneerUtils = require(parent.PioneerUtils)
local isPioneerLaunch = PioneerUtils.isPioneerLaunch
local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)
local Responsive = require(parent.Responsive)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local SwitchServer = require(parent.SwitchServer)

local Divider = Foundation.Divider
local DrawerContainer = Drawer.DrawerContainer
local ExperienceDetailsRow = require(InExperienceSideSheet.Components.ExperienceDetailsRow)
local Footer = require(InExperienceSideSheet.Components.Footer)
local UserProfileRow = require(InExperienceSideSheet.Components.UserProfileRow)
local ScrollView = Foundation.ScrollView
local SideSheetWidgetList = require(InExperienceSideSheet.Components.SideSheetWidgetList)
local VerticalList = require(InExperienceSideSheet.Components.VerticalList)
local View = Foundation.View
local FocusRoot = FocusNavigationUtils.FocusRoot
local useLastInputMode = FocusNavigationUtils.useLastInputMode

local SidesheetAnalytics = require(InExperienceSideSheet.Analytics.SidesheetAnalytics)

local useDrawerShouldMount = Drawer.Hooks.useDrawerShouldMount
local useScaledValue = Foundation.Hooks.useScaledValue
local useStyleSheet = Foundation.Hooks.useStyleSheet
local useBackgroundStyle = require(InExperienceSideSheet.Hooks.useBackgroundStyle)
local useSideSheetFocusNavScrollViewAnimation = require(InExperienceSideSheet.Hooks.useSideSheetFocusNavScrollViewAnimation)

local GetIntegrationsStore = require(InExperienceSideSheet.Stores.GetIntegrationsStore)
local GetSideSheetConfigStore = require(InExperienceSideSheet.Stores.GetSideSheetConfigStore)
local GetSwitchServerStore = SwitchServer.GetSwitchServerStore

local wrapWithProviders = require(InExperienceSideSheet.Utils.wrapWithProviders)
local closePeoplePageOpenedWithSideSheet = require(InExperienceSideSheet.Utils.closePeoplePageOpenedWithSideSheet)
local getDidSideSheetOpenWithPeoplePage = require(InExperienceSideSheet.Utils.getDidSideSheetOpenWithPeoplePage)
local getIsPeoplePageOpen = require(InExperienceSideSheet.Utils.getIsPeoplePageOpen)
local getSideSheetVisibility = require(InExperienceSideSheet.Utils.getSideSheetVisibility)
local toggleSideSheet = require(InExperienceSideSheet.Utils.toggleSideSheet)

local Flags = require(InExperienceSideSheet.Flags)
local SharedFlags = require(parent.SharedFlags)
local FFlagMountUnmountSideSheet = Flags.FFlagMountUnmountSideSheet
local FFlagSideSheetOpenPeoplePage = Flags.FFlagSideSheetOpenPeoplePage
local FFlagSideSheetOpenPeoplePageRestoreChat = Flags.FFlagSideSheetOpenPeoplePageRestoreChat
local FFlagEnableSideSheetWidgets = SharedFlags.FFlagEnableSideSheetWidgets
local FFlagSideSheetFocusNav = SharedFlags.FFlagSideSheetFocusNav
local FFlagEnableWhatsNew = SharedFlags.FFlagEnableWhatsNew
local FFlagUseAnimateScrollViewToSelectionHelper = SharedFlags.FFlagUseAnimateScrollViewToSelectionHelper
local FFlagShowSwitchServerButton = SharedFlags.FFlagShowSwitchServerButton
local v = FFlagEnableSideSheetWidgets or isPioneerLaunch()
local whatsNewAnchor

if FFlagEnableWhatsNew then
	local WhatsNew = require(parent.WhatsNew)
	whatsNewAnchor = WhatsNew.WhatsNewAnchor
else
	whatsNewAnchor = nil
end

local SwitchServerTelemetry = SwitchServer.SwitchServerTelemetry

local v2 = {
	Enum.KeyCode.Left,
	Enum.KeyCode.Right,
	Enum.KeyCode.Up,
	Enum.KeyCode.Down,
	Enum.KeyCode.W,
	Enum.KeyCode.A,
	Enum.KeyCode.S,
	Enum.KeyCode.D
}

local v3 = {
	ExperienceDetails = 0,
	HeaderDivider = 1,
	TopWidgets = 2,
	PrimaryList = v and 3 or 2,
	ListDivider = v and 4 or 3,
	SecondaryList = v and 5 or 4,
	BottomWidgets = v and 6 or 5
}

local SideSheet = {}

local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

local MouseIconOverrideService = CoreScriptsCommon.MouseIconOverrideService

local usePreferredInput = Responsive.usePreferredInput

local function getDeviceSafePadding(p)
	return Display.GetDisplayStore(p).getDeviceSafePadding(p)
end

local function getAboveFoldIntegrations(p)
	return GetIntegrationsStore(p).getAboveFoldIntegrations(p)
end

local function getBelowFoldIntegrations(p)
	return GetIntegrationsStore(p).getBelowFoldIntegrations(p)
end

local function getScrollableContentTopWidgetIntegrations(p)
	return GetIntegrationsStore(p).getScrollableContentTopWidgetIntegrations(p)
end

local function getScrollableContentBottomWidgetIntegrations(p)
	return GetIntegrationsStore(p).getScrollableContentBottomWidgetIntegrations(p)
end

local useFocusGuiObject

if FFlagSideSheetFocusNav then
	local ReactFocusNavigation = require(parent.ReactFocusNavigation)
	useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
else
	useFocusGuiObject = nil
end

local sideSheet = nil
local function SideSheetContent(p)
	local menuWidth = useScaledValue(320)
	local styleSheet = useStyleSheet()
	local backgroundStyle = useBackgroundStyle()
	local v4 = SignalsReact.useSignalState(getDeviceSafePadding)
	local v5 = not FFlagMountUnmountSideSheet or useDrawerShouldMount()
	local v6

	if FFlagSideSheetOpenPeoplePage then
		v6 = SignalsReact.useSignalState(getSideSheetVisibility)
	else
		v6 = false
	end

	local v7

	if FFlagSideSheetOpenPeoplePage then
		v7 = SignalsReact.useSignalState(getIsPeoplePageOpen)
	else
		v7 = false
	end

	local v8

	if FFlagSideSheetOpenPeoplePage then
		v8 = SignalsReact.useSignalState(getDidSideSheetOpenWithPeoplePage)
	else
		v8 = false
	end

	local allowRightFocusEscape = v8 and v6 and v7
	local v9 = SignalsReact.useSignalState(getScrollableContentTopWidgetIntegrations)
	local v10 = v and #v9 > 0

	local onDrawerClosedAnalytics = React.useCallback(function(p2)
		SidesheetAnalytics.logSidesheetClosed(p2.source)
	end, {})

	local ref = nil
	local v11 = nil
	local v12 = nil
	local firstIntegrationToFocusCallback

	if FFlagSideSheetFocusNav then
		ref = React.useRef(nil)
		v11 = useFocusGuiObject()
		v12 = useLastInputMode()
		firstIntegrationToFocusCallback = React.useCallback(function(p2)
			if v12 == "Focus" and ref and ref.current == false then
				ref.current = true
				v11(p2)
			end
		end, { v11, v12 })
	end

	local ref2 = React.useRef(false)
	local ref3

	if FFlagSideSheetOpenPeoplePageRestoreChat then
		ref3 = React.useRef(nil)
	else
		ref3 = nil
	end

	local ref4 = React.useRef(false)
	local v13 = usePreferredInput()

	local ref5 = React.useRef(false)

	local useEffect = React.useEffect
	local function fn()
		local effect = Signals.createEffect(function(p2)
			local sideSheetVisibility = getSideSheetVisibility(p2)

			if
				FFlagSideSheetOpenPeoplePageRestoreChat
				and ref3
				and p.ChatSelector
				and sideSheetVisibility
				and not ref3.current
			then
				local visibility = p.ChatSelector:GetVisibility()

				if GuiService.MenuIsOpen and not visibility then
					ref2.current = UserSettings().GameSettings.ChatVisible
				else
					ref2.current = visibility
				end
			end

			GuiService:SetMenuIsOpen(sideSheetVisibility, "InExperienceSideSheet")

			if FFlagSideSheetOpenPeoplePageRestoreChat and ref3 and p.ChatSelector then
				if sideSheetVisibility then
					if ref3.current then
						ref3.current:Disconnect()
						ref3.current = nil
					end

					p.ChatSelector:SetVisible(false)
				elseif ref2.current and not ref3.current then
					local function restoreChat()
						if ref3.current then
							ref3.current:Disconnect()
						end

						ref3.current = nil
						p.ChatSelector:SetVisible(true)
						ref2.current = false
					end

					if GuiService.MenuIsOpen then
						ref3.current = GuiService.MenuClosed:Once(restoreChat)
						return
					end

					if ref3.current then
						ref3.current:Disconnect()
					end

					ref3.current = nil
					p.ChatSelector:SetVisible(true)
					ref2.current = false
				end
			end
		end)

		return function()
			effect()

			if FFlagSideSheetOpenPeoplePageRestoreChat and ref3 and ref3.current then
				ref3.current:Disconnect()
				ref3.current = nil
			end

			if GuiService.MenuIsOpen then
				GuiService:SetMenuIsOpen(false, "InExperienceSideSheet")
			end
		end
	end

	local v14

	if FFlagSideSheetOpenPeoplePageRestoreChat then
		v14 = p.ChatSelector
	end

	useEffect(fn, { v14 })

	React.useEffect(function()
		local effect = Signals.createEffect(function(p2)
			local sideSheetVisibility = getSideSheetVisibility(p2)

			if not FFlagSideSheetOpenPeoplePageRestoreChat and p.ChatSelector then
				if sideSheetVisibility then
					ref2.current = p.ChatSelector:GetVisibility()
					p.ChatSelector:SetVisible(false)
				elseif ref2.current then
					p.ChatSelector:SetVisible(true)
					ref2.current = false
				end
			end

			if v13 == Responsive.Input.Pointer then
				if sideSheetVisibility and not ref4.current then
					MouseIconOverrideService.push("InExperienceSideSheet", Enum.OverrideMouseIconBehavior.ForceShow)
					ref4.current = true
				elseif not sideSheetVisibility and ref4.current then
					MouseIconOverrideService.pop("InExperienceSideSheet")
					ref4.current = false
				end
			end

			if FFlagSideSheetFocusNav then
				if sideSheetVisibility then
					ref.current = false
				else
					ref.current = nil
				end
			end

			if
				sideSheetVisibility
				and (FFlagShowSwitchServerButton or isPioneerLaunch())
				and GetSwitchServerStore(p2).shouldEnableSwitchServer(p2)
				and not ref5.current
			then
				ref5.current = true
				SwitchServerTelemetry.sendSwitchServerButtonActions({ event_type = "impression" })
			end
		end)
		local visibilityStateChangedConnection

		if p.ChatSelector then
			visibilityStateChangedConnection = p.ChatSelector.VisibilityStateChanged:connect(function(p2)
				if getSideSheetVisibility() and p2 then
					ref2.current = false
				end
			end)
		else
			visibilityStateChangedConnection = nil
		end

		return function()
			effect()

			if visibilityStateChangedConnection ~= nil then
				visibilityStateChangedConnection:disconnect()
			end
		end
	end, { p.ChatSelector, v13 })

	if FFlagSideSheetFocusNav then
		React.useEffect(function()
			ContextActionService:BindCoreAction("SideSheetBlockInputAction", function(_, p2, _)
				if not (p2 == Enum.UserInputState.Begin and ref.current ~= nil) then
					return Enum.ContextActionResult.Pass
				end

				return Enum.ContextActionResult.Sink
			end, false, unpack(v2))

			ContextActionService:BindCoreAction("SideSheetSinkR2Action", function(_, _, _)
				if getSideSheetVisibility() then
					return Enum.ContextActionResult.Sink
				end

				return Enum.ContextActionResult.Pass
			end, false, Enum.KeyCode.ButtonR2)

			ContextActionService:BindCoreAction("SideSheetCloseAction", function(_, p2, _)
				if FFlagSideSheetOpenPeoplePage and p2 ~= Enum.UserInputState.Begin or not getSideSheetVisibility() then
					return Enum.ContextActionResult.Pass
				end

				toggleSideSheet(false)
				return Enum.ContextActionResult.Sink
			end, false, Enum.KeyCode.ButtonB, Enum.KeyCode.ButtonStart)

			return function()
				ContextActionService:UnbindCoreAction("SideSheetBlockInputAction")
				ContextActionService:UnbindCoreAction("SideSheetSinkR2Action")
				ContextActionService:UnbindCoreAction("SideSheetCloseAction")
			end
		end, {})
	end

	local scrollingFrameRef

	if FFlagSideSheetFocusNav and FFlagUseAnimateScrollViewToSelectionHelper then
		scrollingFrameRef = useSideSheetFocusNavScrollViewAnimation()
	end

	local left = v4.left

	if FFlagSideSheetOpenPeoplePage then
		React.useEffect(function()
			GetSideSheetConfigStore(false).setSideSheetDrawerWidth(menuWidth)
		end, { menuWidth })

		React.useEffect(function()
			if v6 then
				return function()
					closePeoplePageOpenedWithSideSheet()
				end
			end

			return nil
		end, { v6 })
	end

	if not v5 then
		return nil
	end

	local headerRow

	if isPioneerLaunch() then
		headerRow = React.createElement(UserProfileRow, { layoutOrder = v3.ExperienceDetails })
	else
		headerRow = React.createElement(ExperienceDetailsRow, { layoutOrder = v3.ExperienceDetails })
	end

	local headerDivider

	if not v10 then
		headerDivider = React.createElement(View, {
			tag = "size-full-0 auto-y",
			LayoutOrder = v3.HeaderDivider
		}, {
			Divider = React.createElement(Divider)
		})
	end

	local topWidgets

	if v then
		local createElement = React.createElement
		local v15 = {
			integrationsGetter = getScrollableContentTopWidgetIntegrations,
			layoutOrder = v3.TopWidgets,
			placement = Chrome.Enums.SideSheetPlacement.ScrollableContentTop,
			firstIntegrationToFocusCallback = 0
		}
		local firstIntegrationToFocusCallback2

		if FFlagSideSheetFocusNav and v10 then
			firstIntegrationToFocusCallback2 = firstIntegrationToFocusCallback
		end

		v15.firstIntegrationToFocusCallback = firstIntegrationToFocusCallback2
		topWidgets = createElement(SideSheetWidgetList, v15)
	end

	local createElement = React.createElement
	local v15 = {
		layoutOrder = v3.PrimaryList,
		integrationsGetter = getAboveFoldIntegrations,
		firstIntegrationToFocusCallback = 0,
		allowRightFocusEscape = 0
	}

	if not FFlagSideSheetFocusNav or v10 then
		firstIntegrationToFocusCallback = nil
	end

	v15.firstIntegrationToFocusCallback = firstIntegrationToFocusCallback

	v15.allowRightFocusEscape = allowRightFocusEscape
	local children = {
		HeaderRow = headerRow,
		HeaderDivider = headerDivider,
		TopWidgets = topWidgets,
		AboveFoldList = createElement(VerticalList, v15),
		FoldDivider = React.createElement(
			View,
			{ tag = "size-full-0 auto-y padding-y-xxlarge", LayoutOrder = v3.ListDivider },
			{ Divider = React.createElement(Divider) }
		),
		BelowFoldList = React.createElement(VerticalList, {
			layoutOrder = v3.SecondaryList,
			integrationsGetter = getBelowFoldIntegrations,
			allowRightFocusEscape = allowRightFocusEscape
		}),
		BottomWidgets = 0
	}
	local bottomWidgets

	if v then
		bottomWidgets = React.createElement(SideSheetWidgetList, {
			integrationsGetter = getScrollableContentBottomWidgetIntegrations,
			layoutOrder = v3.BottomWidgets,
			placement = Chrome.Enums.SideSheetPlacement.ScrollableContentBottom
		})
	end

	children.BottomWidgets = bottomWidgets

	local createElement2 = React.createElement

	local createElement3 = React.createElement
	local v16 = {
		tag = "fill size-full-0 padding-x-xlarge",
		scroll = {
			ScrollingDirection = Enum.ScrollingDirection.Y,
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.fromScale(0, 0)
		},
		layout = {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		},
		LayoutOrder = 1,
		selection = FFlagSideSheetFocusNav and { Selectable = false } or nil,
		scrollingFrameRef = 0
	}

	if not (FFlagSideSheetFocusNav and FFlagUseAnimateScrollViewToSelectionHelper) then
		scrollingFrameRef = nil
	end

	v16.scrollingFrameRef = scrollingFrameRef
	local v17 = createElement2(View, { tag = "col size-full" }, {
		ScrollableContent = createElement3(ScrollView, v16, children),
		Footer = React.createElement(Footer, { layoutOrder = 2 })
	})

	if FFlagEnableWhatsNew then
		v17 = React.createElement(whatsNewAnchor, { anchorId = "sideSheet", tag = "size-full" }, {
			SideSheetPanel = v17
		})
	end

	local createElement4 = React.createElement
	local v18 = {
		displayOrder = 12,
		menuWidth = menuWidth,
		leftOffset = left,
		topOffset = v4.top,
		bottomOffset = v4.bottom,
		backgroundStyle = backgroundStyle,
		onDrawerClosedAnalytics = onDrawerClosedAnalytics,
		allowOutsideInteraction = 0,
		scrimIsModal = 0
	}
	local allowOutsideInteraction

	if FFlagSideSheetOpenPeoplePage then
		allowOutsideInteraction = allowRightFocusEscape
	end

	v18.allowOutsideInteraction = allowOutsideInteraction
	v18.scrimIsModal = not FFlagSideSheetOpenPeoplePage or not allowRightFocusEscape
	local v19 = {
		nil,
		FoundationStyleLink = React.createElement("StyleLink", { StyleSheet = styleSheet })
	}

	if FFlagSideSheetFocusNav then
		v17 = React.createElement(FocusRoot, {
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
			isIsolated = true,
			frameProps = allowRightFocusEscape and {
				SelectionBehaviorRight = Enum.SelectionBehavior.Escape
			} or nil
		}, { Content = v17 })
	end

	v19[1] = v17
	return createElement4(DrawerContainer, v18, v19)
end

function SideSheet.createSideSheet(p, p2, p3)
	if sideSheet then
		return sideSheet
	end

	local inExperienceSideSheet = Instance.new("Folder")
	inExperienceSideSheet.Name = "InExperienceSideSheet"
	inExperienceSideSheet.Parent = CoreGui

	local v4 = wrapWithProviders({
		SideSheetContent = React.createElement(SideSheetContent, p2)
	}, p, p3)

	sideSheet = ReactRoblox.createRoot(inExperienceSideSheet)
	sideSheet:render(v4)

	return sideSheet
end

return SideSheet
