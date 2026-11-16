local RunService = game:GetService("RunService")

local UserInputService = game:GetService("UserInputService")
local SessionService = game:GetService("SessionService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/React")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/ReactFocusNavigation")
local messageBus = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/MessageBus").MessageBus
local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/Navigation")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/Responsive")
local sessionType = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/RobloxAppSessionization").SessionType
local useLastInputMethod = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/FocusNavigationUtils/useLastInputMethod")
local useLastInputMode = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/FocusNavigationUtils/useLastInputMode")
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local useFocusedGuiObject = ReactFocusNavigation.useFocusedGuiObject
local useRegistryEntry = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/FocusNavigationUtils/FocusNavigableSurfaceRegistry").useRegistryEntry
local useRegistryEntries = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/FocusNavigationUtils/FocusNavigableSurfaceRegistry").useRegistryEntries
local FocusNavigableSurfaceIdentifierEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/FocusNavigationUtils/FocusNavigableSurfaceIdentifierEnum")
local useAutoFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/FocusNavigationUtils/useAutoFocus")
local useDescendantHasFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/FocusNavigationUtils/useDescendantHasFocus")
local useAnyDescendantHasFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/FocusNavigationUtils/useAnyDescendantHasFocus")
local GlobalFocusTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/FocusNavigationUtils/GlobalFocusTelemetry")
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/RoactUtils").Hooks.RoactRodux.useSelector
local centralOverlayType = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/RobloxAppEnums").CentralOverlayType

local defineFastInt = game:DefineFastInt("AutoFocusFailsafeThreshold", 5)
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/SharedFlags")
local fFlagAppIaHomeSubTab = SharedFlags.FFlagAppIaHomeSubTab
local fFlagLuaAppResponsiveEnginePreferredInput = SharedFlags.FFlagLuaAppResponsiveEnginePreferredInput
local fFlagEnableDrawerFocusNav = SharedFlags.FFlagEnableDrawerFocusNav
local fFlagSearchAllRegistryEntriesForAutoFocus = SharedFlags.FFlagSearchAllRegistryEntriesForAutoFocus
local FFlagFixGlobalFocusPriority = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/FocusNavigationUtils/FFlagFixGlobalFocusPriority")

local FFlagGamepadDisconnectAutoFocusSuppression = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/FocusNavigationUtils/Flags/FFlagGamepadDisconnectAutoFocusSuppression")

local set = {
	[Enum.UserInputType.MouseButton1] = true,
	[Enum.UserInputType.MouseButton2] = true,
	[Enum.UserInputType.MouseButton3] = true,
	[Enum.UserInputType.Touch] = true
}

local subscriber = messageBus.Subscriber.new()

local function gameLeaveMessageValidator(p2): boolean
	return typeof(p2) == "table"
end

local function createGlobalFocusFailureDetection(callback)
	local v5 = false
	local total = 0
	return (RunService.Heartbeat:Connect(function(dt)
		total += dt

		if defineFastInt < total and not v5 then
			callback()
			v5 = true
			total = 0
		end
	end))
end

local function createGameLeaveSubscription(setAutoFocusing)
	local messageId = messageBus.getMessageId("Game", "onGameLeave")
	local thread = nil

	subscriber:subscribe({ mid = messageId, validateParams = gameLeaveMessageValidator }, function(p2)
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

local function useGlobalFocusHandler(p2)
	local v5 = useLastInputMethod()
	local v6 = useFocusGuiObject()
	local v7 = useFocusedGuiObject()
	local ref = React.useRef(v7)
	local ref2 = React.useRef(false)
	local v8 = useLastInputMode() == "Focus"

	local v9 = if fFlagLuaAppResponsiveEnginePreferredInput then Responsive.usePreferredInput() else nil

	React.useEffect(function()
		if v7 ~= nil and ref.current == nil then
			SessionService:SetSession(
				sessionType.StructuralIdentifier.Level1,
				sessionType.StructuralIdentifier.FocusNavigation,
				v5
			)

			ref.current = v7
		end

		if v7 ~= nil and ref2.current then
			GlobalFocusTelemetry.sendAutoFocusRecoveryCounter()
			ref2.current = false
		end
	end, { v7 })

	React.useEffect(function()
		local lastInputTypeChangedConnection = UserInputService.LastInputTypeChanged:Connect(function(p3)
			local v10

			if fFlagLuaAppResponsiveEnginePreferredInput then
				v10 = not (v9 == Responsive.Input.Directional) and set[p3]
			else
				v10 = set[p3]
			end

			if v10 then
				if ref.current == nil then
					v6(nil)
				else
					SessionService:RemoveSession(sessionType.StructuralIdentifier.FocusNavigation)
					ref.current = nil
					v6(nil)
				end
			end
		end)

		return function()
			lastInputTypeChangedConnection:Disconnect()
		end
	end, fFlagLuaAppResponsiveEnginePreferredInput and { v6, v9 } or { v6 })

	local v10 = Navigation.useNavigation()
	local state = if v10 then v10.state else nil
	local index = if state then state.index else nil
	local ref3 = React.useRef(index)
	React.useEffect(function()
		if v8 and ref3.current ~= nil and index ~= nil and ref3.current < index then
			ref3.current = index
			v6(nil)
		end
	end, { index, v8 })

	local ref4 = React.useRef(nil)
	local ref5 = React.useRef(nil)

	local currentRouteState = Navigation.getCurrentRouteState(v10)
	local routeName = if currentRouteState then currentRouteState.routeName else nil

	React.useEffect(function()
		if routeName ~= ref4.current then
			ref5.current = ref4.current
			ref4.current = routeName
		end
	end, { routeName })

	local v11 = useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.NavBar)
	local v12 = useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.RouterView)
	local v13 = useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.CentralOverlay)
	local v14 = useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.ModerationOverlay)
	local v15 = useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.PopUp)
	local v16 = useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.ContextualMenu)
	local v17 = useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.SearchBar)
	local v18 = useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.PeekView)
	local v19 = useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.SubRouterView)
	local v20 = useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.Auxiliary)

	local v21 = if fFlagAppIaHomeSubTab then useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.HeaderView) else nil

	local v22 = if fFlagEnableDrawerFocusNav then useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.Drawer) else nil

	local v23 = useSelector(function(p3)
		return p3.CentralOverlay.OverlayType
	end)

	local v24 = if FFlagGamepadDisconnectAutoFocusSuppression then v23 == centralOverlayType.GamepadDisconnected and v14 == nil else false

	local useMemo = React.useMemo
	local function fn()
		local v25 = {}

		if v14 then
			table.insert(v25, v14)
			return v25
		end

		if v13 then
			table.insert(v25, v13)
			return v25
		end

		if v16 then
			table.insert(v25, v16)
			return v25
		end

		if v15 then
			table.insert(v25, v15)
			return v25
		end

		if v18 then
			table.insert(v25, v18)
			return v25
		end

		if fFlagEnableDrawerFocusNav and v22 then
			table.insert(v25, v22)
			return v25
		end

		if v12 then
			table.insert(v25, v12)
		end

		if v19 then
			table.insert(v25, v19)
		end

		if v11 then
			table.insert(v25, v11)
		end

		if v17 then
			table.insert(v25, v17)
		end

		if v20 then
			table.insert(v25, v20)
		end

		if fFlagAppIaHomeSubTab and v21 then
			table.insert(v25, v21)
		end

		return v25
	end

	local v26 = if fFlagAppIaHomeSubTab then v21 else nil
	local v27 = if fFlagEnableDrawerFocusNav then v17 else nil
	local v29 = useMemo(fn, {
		v14,
		v12,
		v11,
		v13,
		v16,
		v15,
		v18,
		v19,
		v20,
		v26,
		v27,
		if fFlagEnableDrawerFocusNav then v22 else nil
	})

	local v30 = useAutoFocus(v29, 0.1)

	local v31 = useDescendantHasFocus(v11)
	local v32 = useDescendantHasFocus(v12)
	local v33

	if fFlagSearchAllRegistryEntriesForAutoFocus then
		v33 = useAnyDescendantHasFocus((useRegistryEntries(FocusNavigableSurfaceIdentifierEnum.RouterView)))
	end

	local v34 = useDescendantHasFocus(v13)
	local v35 = useDescendantHasFocus(v14)
	local v36 = useDescendantHasFocus(v16)
	local v37 = useDescendantHasFocus(v15)
	local v38 = useDescendantHasFocus(v17)
	local v39 = useDescendantHasFocus(v19)
	local v40 = useDescendantHasFocus(v20)
	local v41 = useDescendantHasFocus(v18)
	local v42 = if fFlagAppIaHomeSubTab then useDescendantHasFocus(v21) else false
	local v43 = if fFlagEnableDrawerFocusNav then useDescendantHasFocus(v22) else false
	local v44

	if v14 then
		v44 = v35
	elseif v13 then
		v44 = v34
	elseif v16 then
		v44 = v36
	elseif v15 then
		v44 = v37
	elseif v18 then
		v44 = v41
	elseif fFlagEnableDrawerFocusNav and v22 then
		v44 = v43
	elseif v31 then
		v44 = v31
	else
		if not fFlagSearchAllRegistryEntriesForAutoFocus then
			v33 = v32
		end

		v44 = v33 or v38 or v39 or v40 or fFlagAppIaHomeSubTab and v42
	end

	local ref6 = React.useRef(v29)
	local v45 = (v14 and not v35 or v13 and not v34 or v16 and not v36 or v15 and not v37 or v18 and not v41 or fFlagEnableDrawerFocusNav and v22 and not v43 or v12 and not v32 or v19 and not v39 or v11 and not v31 or v17 and not v38 or v20 and not v40)
		and true
		or fFlagAppIaHomeSubTab and v21 and not v42 and true
		or false

	if FFlagFixGlobalFocusPriority then
		if v14 then
			v45 = not v35
		elseif v13 then
			v45 = not v34
		elseif v16 then
			v45 = not v36
		elseif v15 then
			v45 = not v37
		elseif v18 then
			v45 = not v41
		elseif fFlagEnableDrawerFocusNav and v22 then
			v45 = not v43
		elseif v12 then
			v45 = not v32
		elseif v19 then
			v45 = not v39
		elseif v11 then
			v45 = not v31
		elseif v17 then
			v45 = not v38
		else
			v45 = if v20 then not v40 elseif fFlagAppIaHomeSubTab and v21 then not v42 else false
		end
	end

	React.useEffect(function()
		if v9 == Responsive.Input.Directional and ref6.current ~= v29 and not p2 and v45 then
			v6(nil)
		end

		ref6.current = v29
	end, { v29, v9, p2, v45, v6 })

	local v47 = (if fFlagLuaAppResponsiveEnginePreferredInput then v9 == Responsive.Input.Directional or v8 else v8)
		and not (v44 or p2 or v24)

	React.useEffect(function()
		local v48 = nil

		local function setAutoFocusing()
			if v48 then
				v48.cancel()
			end

			v48 = v30()
		end

		local heartbeatConnection

		if v47 then
			if v48 then
				v48.cancel()
			end

			v48 = v30()

			local function fn2()
				GlobalFocusTelemetry.sendAutoFocusFailureCounter(v29)
				GlobalFocusTelemetry.sendAutoFocusFailureEvent(v7, ref6.current, v29, {
					moderationOverlay = v14,
					centralOverlay = v13,
					contextualMenu = v16,
					popUp = v15,
					peekView = v18,
					routerView = v12,
					subRouterView = v19,
					globalNavBar = v11,
					searchBar = v17,
					auxiliaryView = v20,
					headerView = v21
				}, ref5.current, ref4.current, v23)

				ref2.current = true

				if v48 then
					v48.cancel()
				end

				v48 = v30()
			end

			local v49 = false
			local total = 0
			heartbeatConnection = RunService.Heartbeat:Connect(function(dt)
				total += dt

				if defineFastInt < total and not v49 then
					fn2()
					v49 = true
					total = 0
				end
			end)
		else
			heartbeatConnection = nil
		end

		local v49 = if v47 then createGameLeaveSubscription(setAutoFocusing) else nil

		return function()
			if v48 then
				v48.cancel()
			end

			if v49 then
				v49.unsubscribe()
			end

			if heartbeatConnection then
				heartbeatConnection:Disconnect()
			end
		end
	end, { v47, v30, v29, v7 })
end

return useGlobalFocusHandler
