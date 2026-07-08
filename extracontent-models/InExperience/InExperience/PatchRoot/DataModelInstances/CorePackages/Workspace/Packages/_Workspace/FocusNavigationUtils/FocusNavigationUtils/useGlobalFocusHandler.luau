local RunService = game:GetService("RunService")
local FocusNavigationUtils = script:FindFirstAncestor("FocusNavigationUtils")
local UserInputService = game:GetService("UserInputService")
local SessionService = game:GetService("SessionService")
local FocusNavigationUtilsParent = FocusNavigationUtils.Parent
local React = require(FocusNavigationUtilsParent.React)
local ReactFocusNavigation = require(FocusNavigationUtilsParent.ReactFocusNavigation)
local MessageBus = require(FocusNavigationUtilsParent.MessageBus).MessageBus
local LoggingProtocol = require(FocusNavigationUtilsParent.LoggingProtocol)
local Navigation = require(FocusNavigationUtilsParent.Navigation)
local mutedError = require(FocusNavigationUtilsParent.Loggers).mutedError
local Responsive = require(FocusNavigationUtilsParent.Responsive)
local SessionType = require(FocusNavigationUtilsParent.Sessionization).SessionType
local useLastInputMethod = require(FocusNavigationUtils.useLastInputMethod)
local useLastInputMode = require(FocusNavigationUtils.useLastInputMode)
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local useFocusedGuiObject = ReactFocusNavigation.useFocusedGuiObject
local useRegistryEntry = require(FocusNavigationUtils.FocusNavigableSurfaceRegistry).useRegistryEntry
local FocusNavigableSurfaceIdentifierEnum = require(FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum)
local useAutoFocus = require(FocusNavigationUtils.useAutoFocus)
local useDescendantHasFocus = require(FocusNavigationUtils.useDescendantHasFocus)
local GlobalFocusTelemetry = require(FocusNavigationUtils.GlobalFocusTelemetry)
local useSelector = require(FocusNavigationUtilsParent.RoactUtils).Hooks.RoactRodux.useSelector
local v24 = game:DefineFastFlag("TenFootUiCorrectAutoFocusLoggingBehavior", false)
local v25 = game:DefineFastInt("AutoFocusFailsafeThreshold", 5)
local FFlagEnablePeekViewFocusNav = require(FocusNavigationUtilsParent.SharedFlags).FFlagEnablePeekViewFocusNav
local FFlagAXMigrateAXToGlobalAutofocus = require(FocusNavigationUtilsParent.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local SharedFlags = require(FocusNavigationUtilsParent.SharedFlags)
local FFlagAppIaHomeSubTab = SharedFlags.FFlagAppIaHomeSubTab
local FFlagLuaAppResponsiveEnginePreferredInput = SharedFlags.FFlagLuaAppResponsiveEnginePreferredInput
local FFlagLuaAppsDefaultSelection = SharedFlags.FFlagLuaAppsDefaultSelection
local FFlagEnableDrawerFocusNav = SharedFlags.FFlagEnableDrawerFocusNav
local v33 = game:DefineFastFlag("GlobalFocusFailureTelemetry", false)
local t1 = {
	[Enum.UserInputType.MouseButton1] = true,
	[Enum.UserInputType.MouseButton2] = true,
	[Enum.UserInputType.MouseButton3] = true,
	[Enum.UserInputType.Touch] = true
}
local v35 = MessageBus.Subscriber.new()
local default = LoggingProtocol.default

local function gameLeaveMessageValidator(p1) -- line: 53
	if typeof(p1) == "table" then
		return true
	end

	return false
end
local function createGlobalFocusFailureDetection(p2: ((...any) -> ...any)) -- line: 61
	-- upvalues: v33 (copy), RunService (copy), v25 (copy)
	local u43 = not v33 and nil
	local n1 = 0

	return (RunService.Heartbeat:Connect(function(dt) -- line: 64
		-- upvalues: n1 (ref), v25 (copy), v33 (copy), u43 (ref), p2 (copy)
		n1 += dt

		if n1 > v25 and (not v33 or not u43) then
			p2()

			if v33 then
				u43 = true
			end

			n1 = 0
		end
	end))
end
local function createGameLeaveSubscription(p3: ((...any) -> ...any)) -- line: 84
	-- upvalues: MessageBus (copy), v35 (copy), gameLeaveMessageValidator (copy), v25 (copy)
	local v46 = MessageBus.getMessageId("Game", "onGameLeave")
	local thread = nil

	v35:subscribe({
		mid = v46,
		validateParams = gameLeaveMessageValidator
	}, function(_) -- line: 91
		-- upvalues: thread (ref), v25 (copy), p3 (copy)
		thread = task.delay(v25, function() -- line: 92
			-- upvalues: p3 (copy)
			p3()
		end)
	end)

	return {
		unsubscribe = function() -- line: 97
			-- upvalues: v35 (copy), v46 (copy), thread (ref)
			v35:unsubscribeWithMsgId(v46)

			if thread then
				task.cancel(thread)
			end
		end
	}
end
local function useGlobalFocusHandler(b1: boolean?) -- line: 110
	-- upvalues: useLastInputMethod (copy), useFocusGuiObject (copy), useFocusedGuiObject (copy), React (copy), v33 (copy), useLastInputMode (copy), FFlagLuaAppResponsiveEnginePreferredInput (copy), Responsive (copy), SessionService (copy), SessionType (copy), GlobalFocusTelemetry (copy), UserInputService (copy), t1 (copy), Navigation (copy), useRegistryEntry (copy), FocusNavigableSurfaceIdentifierEnum (copy), FFlagEnablePeekViewFocusNav (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), FFlagAppIaHomeSubTab (copy), FFlagEnableDrawerFocusNav (copy), useAutoFocus (copy), useDescendantHasFocus (copy), FFlagLuaAppsDefaultSelection (copy), useSelector (copy), v24 (copy), mutedError (copy), default (copy), RunService (copy), v25 (copy), createGameLeaveSubscription (copy)
	local v49 = useLastInputMethod()
	local v50 = useFocusGuiObject()
	local v51 = useFocusedGuiObject()
	local v52 = React.useRef(v51)
	local v53 = if not v33 then nil else React.useRef(false)
	local v54 = useLastInputMode() == "Focus"
	local v55 = if not FFlagLuaAppResponsiveEnginePreferredInput then nil else Responsive.usePreferredInput()

	React.useEffect(function() -- line: 121
		-- upvalues: v51 (copy), v52 (copy), SessionService (copy), SessionType (copy), v49 (copy), v33 (copy), v53 (copy), GlobalFocusTelemetry (copy)
		if v51 ~= nil and v52.current == nil then
			SessionService:SetSession(SessionType.StructuralIdentifier.Level1, SessionType.StructuralIdentifier.FocusNavigation, v49)
			v52.current = v51
		end

		if v33 and v51 ~= nil and v53.current then
			GlobalFocusTelemetry.sendAutoFocusRecoveryCounter()
			v53.current = false
		end
	end, { v51 })
	React.useEffect(function() -- line: 137
		-- upvalues: UserInputService (copy), FFlagLuaAppResponsiveEnginePreferredInput (copy), v55 (copy), Responsive (copy), t1 (copy), v52 (copy), SessionService (copy), SessionType (copy), v50 (copy)
		local connection = UserInputService.LastInputTypeChanged:Connect(function(p5) -- line: 138
			-- upvalues: FFlagLuaAppResponsiveEnginePreferredInput (copy), v55 (copy), Responsive (copy), t1 (copy), v52 (copy), SessionService (copy), SessionType (copy), v50 (copy)
			if if not FFlagLuaAppResponsiveEnginePreferredInput then t1[p5] else v55 ~= Responsive.Input.Directional and t1[p5] then
				if v52.current ~= nil then
					SessionService:RemoveSession(SessionType.StructuralIdentifier.FocusNavigation)
					v52.current = nil
					v50(nil)

					return
				end

				v50(nil)
			end
		end)

		return function() -- line: 153
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, if not FFlagLuaAppResponsiveEnginePreferredInput then { v50 } else {
		v50,
		v55
	})

	local v56 = Navigation.useNavigation()
	local v57 = if not v56 then nil else v56.state
	local v58 = if not v57 then nil else v57.index
	local v59 = React.useRef(v58)

	React.useEffect(function() -- line: 166
		-- upvalues: v54 (copy), v59 (copy), v58 (copy), v50 (copy)
		if v54 and (v59.current ~= nil and v58 ~= nil and v59.current < v58) then
			v59.current = v58
			v50(nil)
		end
	end, {
		v58,
		v54
	})

	local u60 = nil
	local u61 = nil

	if v33 then
		u60 = React.useRef(nil)
		u61 = React.useRef(nil)

		local v62 = Navigation.getCurrentRouteState(v56)
		local v63 = if not v62 then nil else v62.routeName

		React.useEffect(function() -- line: 187
			-- upvalues: v63 (copy), u60 (ref), u61 (ref)
			if v63 ~= u60.current then
				u61.current = u60.current
				u60.current = v63
			end
		end, { v63 })
	end

	local v64 = useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.NavBar)
	local v65 = useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.RouterView)
	local v66 = useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.CentralOverlay)
	local v67 = useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.ModerationOverlay)
	local v68 = useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.PopUp)
	local v69 = useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.ContextualMenu)
	local v70 = useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.SearchBar)
	local v71 = if not FFlagEnablePeekViewFocusNav then nil else useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.PeekView)
	local v72 = if not FFlagAXMigrateAXToGlobalAutofocus then nil else useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.SubRouterView)
	local v73 = if not FFlagAXMigrateAXToGlobalAutofocus then nil else useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.Auxiliary)
	local v74 = if not FFlagAppIaHomeSubTab then nil else useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.HeaderView)
	local v75 = if not FFlagEnableDrawerFocusNav then nil else useRegistryEntry(FocusNavigableSurfaceIdentifierEnum.Drawer)
	local v76 = React.useMemo(function() -- line: 242
		-- upvalues: v67 (copy), v66 (copy), v69 (copy), v68 (copy), v71 (copy), FFlagEnableDrawerFocusNav (copy), v75 (copy), v65 (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), v72 (copy), v64 (copy), v70 (copy), v73 (copy), FFlagAppIaHomeSubTab (copy), v74 (copy)
		local t2 = {}

		if v67 then
			table.insert(t2, v67)

			return t2
		end

		if v66 then
			table.insert(t2, v66)

			return t2
		end

		if v69 then
			table.insert(t2, v69)

			return t2
		end

		if v68 then
			table.insert(t2, v68)

			return t2
		end

		if v71 then
			table.insert(t2, v71)

			return t2
		end

		if FFlagEnableDrawerFocusNav and v75 then
			table.insert(t2, v75)

			return t2
		end

		if v65 then
			table.insert(t2, v65)
		end

		if FFlagAXMigrateAXToGlobalAutofocus and v72 then
			table.insert(t2, v72)
		end

		if v64 then
			table.insert(t2, v64)
		end

		if v70 then
			table.insert(t2, v70)
		end

		if FFlagAXMigrateAXToGlobalAutofocus and v73 then
			table.insert(t2, v73)
		end

		if FFlagAppIaHomeSubTab and v74 then
			table.insert(t2, v74)
		end

		return t2
	end, {
		v67,
		v65,
		v64,
		v66,
		v69,
		v68,
		v71,
		if not FFlagAXMigrateAXToGlobalAutofocus then nil else v72,
		if not FFlagAXMigrateAXToGlobalAutofocus then nil else v73,
		if not FFlagAppIaHomeSubTab then nil else v74,
		if not FFlagEnableDrawerFocusNav then nil else v70,
		if not FFlagEnableDrawerFocusNav then nil else v75
	})
	local v77 = useAutoFocus(v76, 0.1)
	local v78 = useDescendantHasFocus(v64)
	local v79 = useDescendantHasFocus(v65)
	local v80 = useDescendantHasFocus(v66)
	local v81 = useDescendantHasFocus(v67)
	local v82 = useDescendantHasFocus(v69)
	local v83 = useDescendantHasFocus(v68)
	local v84 = useDescendantHasFocus(v70)
	local v85 = if not FFlagAXMigrateAXToGlobalAutofocus then nil else useDescendantHasFocus(v72)
	local v86 = if not FFlagAXMigrateAXToGlobalAutofocus then nil else useDescendantHasFocus(v73)
	local v87 = not not FFlagEnablePeekViewFocusNav and useDescendantHasFocus(v71)
	local v88 = not not FFlagAppIaHomeSubTab and useDescendantHasFocus(v74)
	local v89 = not not FFlagEnableDrawerFocusNav and useDescendantHasFocus(v75)
	local v90 = if not v67 then if not v66 then if not v69 then if not v68 then if not v71 then if not FFlagEnableDrawerFocusNav or not v75 then if not FFlagAXMigrateAXToGlobalAutofocus then v78 or (v79 or (v84 or FFlagAppIaHomeSubTab and v88)) else v78 or (v79 or (v84 or (v85 or (v86 or FFlagAppIaHomeSubTab and v88)))) else v89 else v87 else v83 else v82 else v80 else v81
	local u91 = nil

	if FFlagLuaAppsDefaultSelection then
		u91 = React.useRef(v76)

		local v92 = v67 and not v81 or (v66 and not v80 or (v69 and not v82 or (v68 and not v83 or (v71 and not v87 or (FFlagEnableDrawerFocusNav and (not not v75 and not v89) or (v65 and not v79 or (FFlagAXMigrateAXToGlobalAutofocus and (not not v72 and not v85) or (v64 and not v78 or (v70 and not v84 or (FFlagAXMigrateAXToGlobalAutofocus and (not not v73 and not v86) or not not FFlagAppIaHomeSubTab and (not not v74 and (not v88 or false))))))))))))

		React.useEffect(function() -- line: 375
			-- upvalues: v55 (copy), Responsive (copy), u91 (ref), v76 (copy), b1 (copy), v92 (copy), v50 (copy)
			if v55 == Responsive.Input.Directional and (u91.current ~= v76 and not b1 and v92) then
				v50(nil)
			end

			u91.current = v76
		end, {
			v76,
			v55,
			b1,
			v92,
			v50
		})
	end

	local v93 = if not v33 then nil else useSelector(function(p6) -- line: 397
		return p6.CentralOverlay.OverlayType
	end)
	local v94 = ((if not FFlagLuaAppResponsiveEnginePreferredInput then v54 else v55 == Responsive.Input.Directional or v54)) and (not v90 and not b1)

	React.useEffect(function() -- line: 409
		-- upvalues: v77 (copy), v94 (copy), v33 (copy), GlobalFocusTelemetry (copy), v76 (copy), v51 (copy), u91 (ref), v67 (copy), v66 (copy), v69 (copy), v68 (copy), v71 (copy), v65 (copy), v72 (copy), v64 (copy), v70 (copy), v73 (copy), v74 (copy), u61 (ref), u60 (ref), v93 (copy), v53 (copy), v24 (copy), mutedError (copy), default (copy), RunService (copy), v25 (copy), createGameLeaveSubscription (copy)
		local u100 = nil
		local connection = nil

		local function setAutoFocusing() -- line: 413
			-- upvalues: u100 (ref), v77 (copy)
			if u100 then
				u100.cancel()
			end

			u100 = v77()
		end

		if v94 then
			if u100 then
				u100.cancel()
			end

			u100 = v77()

			local function v103() -- line: 422
				-- upvalues: v33 (copy), GlobalFocusTelemetry (copy), v76 (copy), v51 (copy), u91 (ref), v67 (copy), v66 (copy), v69 (copy), v68 (copy), v71 (copy), v65 (copy), v72 (copy), v64 (copy), v70 (copy), v73 (copy), v74 (copy), u61 (ref), u60 (ref), v93 (copy), v53 (copy), v24 (copy), mutedError (copy), default (copy), u100 (ref), v77 (copy)
				if v33 then
					GlobalFocusTelemetry.sendAutoFocusFailureCounter(v76)
					GlobalFocusTelemetry.sendAutoFocusFailureEvent(v51, if not u91 then {} else u91.current, v76, {
						moderationOverlay = v67,
						centralOverlay = v66,
						contextualMenu = v69,
						popUp = v68,
						peekView = v71,
						routerView = v65,
						subRouterView = v72,
						globalNavBar = v64,
						searchBar = v70,
						auxiliaryView = v73,
						headerView = v74
					}, if not u61 then nil else u61.current, if not u60 then nil else u60.current, v93)
					v53.current = true
				elseif v24 then
					mutedError("[useGlobalFocusHandler] globalFocusHandler failed to autofocus with " .. #v76 .. " targets, retrying")
				else
					default:logEvent("GamePadFocusFailsafeActivated", {
						targetCount = #v76
					})
				end

				if u100 then
					u100.cancel()
				end

				u100 = v77()
			end

			local u104 = not v33 and nil
			local n2 = 0

			connection = RunService.Heartbeat:Connect(function(dt) -- line: 64
				-- upvalues: n2 (ref), v25 (copy), v33 (copy), u104 (ref), v103 (copy)
				n2 += dt

				if n2 > v25 and (not v33 or not u104) then
					v103()

					if v33 then
						u104 = true
					end

					n2 = 0
				end
			end)
		end

		local u106 = nil

		if v94 then
			u106 = createGameLeaveSubscription(setAutoFocusing)
		end

		return function() -- line: 469
			-- upvalues: u100 (ref), u106 (ref), connection (ref)
			if u100 then
				u100.cancel()
			end

			if u106 then
				u106.unsubscribe()
			end

			if connection then
				connection:Disconnect()
			end
		end
	end, {
		v94,
		v77,
		v76,
		if not FFlagLuaAppsDefaultSelection then nil else v51
	})
end

return useGlobalFocusHandler
