local RunService = game:GetService("RunService")
local FocusNavigationUtils = script:FindFirstAncestor("FocusNavigationUtils")
local UserInputService = game:GetService("UserInputService")
local SessionService = game:GetService("SessionService")
local parent = FocusNavigationUtils.Parent
local React = require(parent.React)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local MessageBus = require(parent.MessageBus)
local messageBus = MessageBus.MessageBus
local Navigation = require(parent.Navigation)
local Responsive = require(parent.Responsive)
local Sessionization = require(parent.Sessionization)
local SessionType = Sessionization.SessionType
local useLastInputMethod = require(FocusNavigationUtils.useLastInputMethod)
local useLastInputMode = require(FocusNavigationUtils.useLastInputMode)
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local useFocusedGuiObject = ReactFocusNavigation.useFocusedGuiObject
local FocusNavigableSurfaceRegistry = require(FocusNavigationUtils.FocusNavigableSurfaceRegistry)
local useRegistryEntry = FocusNavigableSurfaceRegistry.useRegistryEntry
local FocusNavigableSurfaceRegistry2 = require(FocusNavigationUtils.FocusNavigableSurfaceRegistry)
local useRegistryEntries = FocusNavigableSurfaceRegistry2.useRegistryEntries
local FocusNavigableSurfaceIdentifierEnum = require(FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum)
local useAutoFocus = require(FocusNavigationUtils.useAutoFocus)
local useDescendantHasFocus = require(FocusNavigationUtils.useDescendantHasFocus)
local useAnyDescendantHasFocus = require(FocusNavigationUtils.useAnyDescendantHasFocus)
local GlobalFocusTelemetry = require(FocusNavigationUtils.GlobalFocusTelemetry)
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local RobloxAppEnums = require(parent.RobloxAppEnums)
local CentralOverlayType = RobloxAppEnums.CentralOverlayType

local defineFastInt = game:DefineFastInt("AutoFocusFailsafeThreshold", 5)
local SharedFlags = require(parent.SharedFlags)
local FFlagAppIaHomeSubTab = SharedFlags.FFlagAppIaHomeSubTab
local FFlagLuaAppResponsiveEnginePreferredInput = SharedFlags.FFlagLuaAppResponsiveEnginePreferredInput
local FFlagEnableDrawerFocusNav = SharedFlags.FFlagEnableDrawerFocusNav
local FFlagSearchAllRegistryEntriesForAutoFocus = SharedFlags.FFlagSearchAllRegistryEntriesForAutoFocus
local FFlagFixGlobalFocusPriority = require(script.Parent.FFlagFixGlobalFocusPriority)

local FFlagGamepadDisconnectAutoFocusSuppression = require(script.Parent.Flags.FFlagGamepadDisconnectAutoFocusSuppression)

local set = {
	[Enum.UserInputType.MouseButton1] = true,
	[Enum.UserInputType.MouseButton2] = true,
	[Enum.UserInputType.MouseButton3] = true,
	[Enum.UserInputType.Touch] = true
}

local subscriber = messageBus.Subscriber.new()

local function gameLeaveMessageValidator(p): boolean
	return typeof(p) == "table"
end

local function createGlobalFocusFailureDetection(fn) -- 1 equivalent call inferred from this helper
	local v = false
	local total = 0
	return (RunService.Heartbeat:Connect(function(dt)
		total += dt

		if defineFastInt < total and not v then
			fn()
			v = true
			total = 0
		end
	end))
end

local function createGameLeaveSubscription(setAutoFocusing)
	local messageId = messageBus.getMessageId("Game", "onGameLeave")
	local thread = nil

	subscriber:subscribe({ mid = messageId, validateParams = gameLeaveMessageValidator }, function(_)
		thread = task.delay(defineFastInt, function()
			setAutoFocusing()
		end)
	end)

	return {
		unsubscribe = function()
			subscriber:unsubscribeWithMsgId(messageId)

			if thread then
				task.cancel(thread)
			end
		end
	}
end

local function useGlobalFocusHandler(flag: boolean?)
	local v = useLastInputMethod()
	local v2 = useFocusGuiObject()
	local current = useFocusedGuiObject()
	local ref = React.useRef(current)
	local ref2 = React.useRef(false)
	local v3 = useLastInputMode() == "Focus"
	local v4

	if FFlagLuaAppResponsiveEnginePreferredInput then
		v4 = Responsive.usePreferredInput()
	else
		v4 = nil
	end

	React.useEffect(function()
		if current ~= nil and ref.current == nil then
			SessionService:SetSession(
				SessionType.StructuralIdentifier.Level1,
				SessionType.StructuralIdentifier.FocusNavigation,
				v
			)

			ref.current = current
		end

		if current ~= nil and ref2.current then
			GlobalFocusTelemetry.sendAutoFocusRecoveryCounter()
			ref2.current = false
		end
	end, { current })

	React.useEffect(function()
		local lastInputTypeChangedConnection = UserInputService.LastInputTypeChanged:Connect(function(p)
			local v5

			if FFlagLuaAppResponsiveEnginePreferredInput then
				if v4 == Responsive.Input.Directional then
					v5 = false
				else
					v5 = set[p]
				end
			else
				v5 = set[p]
			end

			if v5 then
				if ref.current == nil then
					v2(nil)
				else
					SessionService:RemoveSession(SessionType.StructuralIdentifier.FocusNavigation)
					ref.current = nil
					v2(nil)
				end
			end
		end)

		return function()
			lastInputTypeChangedConnection:Disconnect()
		end
	end, FFlagLuaAppResponsiveEnginePreferredInput and { v2, v4 } or { v2 })

	local v5 = Navigation.useNavigation()
	local state

	if v5 then
		state = v5.state
	end

	local index

	if state then
		index = state.index
	else
		index = nil
	end

	local ref3 = React.useRef(index)
	React.useEffect(function()
		if v3 and ref3.current ~= nil and index ~= nil and ref3.current < index then
			ref3.current = index
			v2(nil)
		end
	end, { index, v3 })

	local ref4 = React.useRef(nil)
	local ref5 = React.useRef(nil)

	local currentRouteState = Navigation.getCurrentRouteState(v5)
	local routeName

	if currentRouteState then
		routeName = currentRouteState.routeName
	else
		routeName = nil
	end

	React.useEffect(function()
		if routeName ~= ref4.current then
			ref5.current = ref4.current
			ref4.current = routeName
		end
	end, { routeName })

	local globalNavBar = useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.NavBar)
	local routerView = useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.RouterView)
	local centralOverlay = useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.CentralOverlay)
	local moderationOverlay = useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.ModerationOverlay)
	local popUp = useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.PopUp)
	local contextualMenu = useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.ContextualMenu)
	local searchBar = useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.SearchBar)
	local peekView = useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.PeekView)
	local subRouterView = useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.SubRouterView)
	local auxiliaryView = useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.Auxiliary)
	local headerView

	if FFlagAppIaHomeSubTab then
		headerView = useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.HeaderView)
	else
		headerView = nil
	end

	local v6

	if FFlagEnableDrawerFocusNav then
		v6 = useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.Drawer)
	else
		v6 = nil
	end

	local v7 = useSelector(function(p)
		return p.CentralOverlay.OverlayType
	end)
	local v8

	if FFlagGamepadDisconnectAutoFocusSuppression then
		if v7 == CentralOverlayType.GamepadDisconnected then
			v8 = moderationOverlay == nil
		else
			v8 = false
		end
	else
		v8 = false
	end

	local useMemo = React.useMemo
	local function fn()
		local v9 = {}

		if moderationOverlay then
			table.insert(v9, moderationOverlay)
			return v9
		end

		if centralOverlay then
			table.insert(v9, centralOverlay)
			return v9
		end

		if contextualMenu then
			table.insert(v9, contextualMenu)
			return v9
		end

		if popUp then
			table.insert(v9, popUp)
			return v9
		end

		if peekView then
			table.insert(v9, peekView)
			return v9
		end

		if FFlagEnableDrawerFocusNav and v6 then
			table.insert(v9, v6)
			return v9
		end

		if routerView then
			table.insert(v9, routerView)
		end

		if subRouterView then
			table.insert(v9, subRouterView)
		end

		if globalNavBar then
			table.insert(v9, globalNavBar)
		end

		if searchBar then
			table.insert(v9, searchBar)
		end

		if auxiliaryView then
			table.insert(v9, auxiliaryView)
		end

		if FFlagAppIaHomeSubTab and headerView then
			table.insert(v9, headerView)
		end

		return v9
	end

	local v9

	if FFlagAppIaHomeSubTab then
		v9 = headerView
	end

	local v10

	if FFlagEnableDrawerFocusNav then
		v10 = searchBar
	end

	local v11

	if FFlagEnableDrawerFocusNav then
		v11 = v6
	end

	local current2 = useMemo(fn, {
		moderationOverlay,
		routerView,
		globalNavBar,
		centralOverlay,
		contextualMenu,
		popUp,
		peekView,
		subRouterView,
		auxiliaryView,
		v9,
		v10,
		v11
	})

	local v12 = useAutoFocus(current2, 0.1)

	local v13 = useDescendantHasFocus(globalNavBar)
	local v14 = useDescendantHasFocus(routerView)
	local v15

	if FFlagSearchAllRegistryEntriesForAutoFocus then
		v15 = useAnyDescendantHasFocus((useRegistryEntries(FocusNavigableSurfaceIdentifierEnum.RouterView)))
	end

	local v16 = useDescendantHasFocus(centralOverlay)
	local v17 = useDescendantHasFocus(moderationOverlay)
	local v18 = useDescendantHasFocus(contextualMenu)
	local v19 = useDescendantHasFocus(popUp)
	local v20 = useDescendantHasFocus(searchBar)
	local v21 = useDescendantHasFocus(subRouterView)
	local v22 = useDescendantHasFocus(auxiliaryView)
	local v23 = useDescendantHasFocus(peekView)
	local v24

	if FFlagAppIaHomeSubTab then
		v24 = useDescendantHasFocus(headerView)
	else
		v24 = false
	end

	local v25

	if FFlagEnableDrawerFocusNav then
		v25 = useDescendantHasFocus(v6)
	else
		v25 = false
	end

	local v26

	if moderationOverlay then
		v26 = v17
	elseif centralOverlay then
		v26 = v16
	elseif contextualMenu then
		v26 = v18
	elseif popUp then
		v26 = v19
	elseif peekView then
		v26 = v23
	elseif FFlagEnableDrawerFocusNav and v6 then
		v26 = v25
	elseif v13 then
		v26 = v13
	else
		if not FFlagSearchAllRegistryEntriesForAutoFocus then
			v15 = v14
		end

		v26 = v15 or v20 or v21 or v22 or FFlagAppIaHomeSubTab and v24
	end

	local ref6 = React.useRef(current2)
	local v27 = (moderationOverlay and not v17 or centralOverlay and not v16 or contextualMenu and not v18 or popUp and not v19 or peekView and not v23 or FFlagEnableDrawerFocusNav and v6 and not v25 or routerView and not v14 or subRouterView and not v21 or globalNavBar and not v13 or searchBar and not v20 or auxiliaryView and not v22)
		and true
		or FFlagAppIaHomeSubTab and headerView and not v24 and true
		or false

	if FFlagFixGlobalFocusPriority then
		if moderationOverlay then
			v27 = not v17
		elseif centralOverlay then
			v27 = not v16
		elseif contextualMenu then
			v27 = not v18
		elseif popUp then
			v27 = not v19
		elseif peekView then
			v27 = not v23
		elseif FFlagEnableDrawerFocusNav and v6 then
			v27 = not v25
		elseif routerView then
			v27 = not v14
		elseif subRouterView then
			v27 = not v21
		elseif globalNavBar then
			v27 = not v13
		elseif searchBar then
			v27 = not v20
		elseif auxiliaryView then
			v27 = not v22
		elseif FFlagAppIaHomeSubTab and headerView then
			v27 = not v24
		else
			v27 = false
		end
	end

	React.useEffect(function()
		if v4 == Responsive.Input.Directional and ref6.current ~= current2 and not flag and v27 then
			v2(nil)
		end

		ref6.current = current2
	end, { current2, v4, flag, v27, v2 })
	local v28

	if FFlagLuaAppResponsiveEnginePreferredInput then
		v28 = v4 == Responsive.Input.Directional or v3
	else
		v28 = v3
	end

	local v29 = v28 and not (v26 or flag or v8)
	React.useEffect(function()
		local v30 = nil

		local function setAutoFocusing() -- 2 equivalent calls inferred from this helper
			if v30 then
				v30.cancel()
			end

			v30 = v12()
		end

		local connection

		if v29 then
			setAutoFocusing() -- inferred equivalent call

			local function fn2()
				GlobalFocusTelemetry.sendAutoFocusFailureCounter(current2)
				GlobalFocusTelemetry.sendAutoFocusFailureEvent(current, ref6.current, current2, {
					moderationOverlay = moderationOverlay,
					centralOverlay = centralOverlay,
					contextualMenu = contextualMenu,
					popUp = popUp,
					peekView = peekView,
					routerView = routerView,
					subRouterView = subRouterView,
					globalNavBar = globalNavBar,
					searchBar = searchBar,
					auxiliaryView = auxiliaryView,
					headerView = headerView
				}, ref5.current, ref4.current, v7)

				ref2.current = true
				setAutoFocusing() -- inferred equivalent call
			end

			connection = createGlobalFocusFailureDetection(fn2) -- inferred equivalent call
		else
			connection = nil
		end

		local v31

		if v29 then
			v31 = createGameLeaveSubscription(setAutoFocusing)
		else
			v31 = nil
		end

		return function()
			if v30 then
				v30.cancel()
			end

			if v31 then
				v31.unsubscribe()
			end

			if connection then
				connection:Disconnect()
			end
		end
	end, { v29, v12, current2, current })
end

return useGlobalFocusHandler
