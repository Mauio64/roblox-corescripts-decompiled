local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Modules = CoreGui.RobloxGui.Modules
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local Promise = require(CorePackages.Packages.Promise)
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local withNavigationFocus = RoactNavigation.withNavigationFocus
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local Focusable = RoactGamepad.Focusable
local t = require(CorePackages.Packages.t)
local ExternalEventConnection = require(CorePackages.Workspace.Packages.RoactUtils).ExternalEventConnection
local NavigationEventsLogger = require(Modules.AvatarExperience.Common.Components.RoactNavigation.Debug.NavigationEventsLogger)
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local useFocusNavigableSurfaceRegistryConnection = FocusNavigationUtils.useFocusNavigableSurfaceRegistryConnection
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local useTableWrappedCallbackRef = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.RoactGamepadMigration.useTableWrappedCallbackRef
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local v28 = require(CorePackages.Workspace.Packages.AppDebug).LogTree.logger("ax.gamepad")
local isGamepadInput = require(CorePackages.Workspace.Packages.RoactUtils).isGamepadInput
local BoundInputsUpdater = require(Modules.AvatarExperience.Common.Components.BoundInputsUpdater)
local GamepadFocusRecovery = require(Modules.AvatarExperience.Common.Components.GamepadFocusRecovery)
local AvatarVRPanelWrapper = require(Modules.AvatarExperience.Common.Components.AvatarVRPanelWrapper)
local AvatarScreenProperties = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).AvatarRoute.AvatarScreenProperties
local IsVRAppBuild = require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild
local GetFFlagLuafiedReportEntryPoints = SharedFlags.GetFFlagLuafiedReportEntryPoints
local FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local v38 = game:DefineFastFlag("AXOverlayShouldNotAutofocusForNonDirectionalInput", false)
local t1 = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local function useFocusNavigationBindings(p1, p2: ((...any) -> ...any)) -- line: 60
	-- upvalues: ReactFocusNavigation (copy), t1 (copy), React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy)
	local v45 = ReactFocusNavigation.useEventMap(t1, p1)
	local v46 = React.useMemo(function() -- line: 62
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), p2 (copy)
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p3) -- line: 65
					-- upvalues: p2 (copy)
					p3.cancelled = true
					p2()
				end)
			}
		}
	end, { p2 })

	return ReactFocusNavigation.useEventHandlerMap(v46, v45)
end

local v41 = Roact.PureComponent:extend("OverlayFocusHandler")

v41.validateProps = t.strictInterface({
	overlayComponent = t.union(t.table, t.callback),
	arguments = t.table,
	focusNavigationRef = if not FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation then nil else t.table,
	navigation = t.table,
	isFocused = t.boolean,
	forwardRef = if not FFlagAXMigrateAXToGlobalAutofocus then nil else t.optional(t.any)
})

function v41.init(p4) -- line: 92
	-- upvalues: FFlagAXMigrateAXToGlobalAutofocus (copy), UserInputService (copy), isGamepadInput (copy), RoactGamepad (copy), Roact (copy), NavigationUtils (copy)
	if not FFlagAXMigrateAXToGlobalAutofocus then
		local LastInputType = UserInputService:GetLastInputType()

		p4:setState({
			gamepadFocused = false,
			lastInputIsGamepad = isGamepadInput(LastInputType)
		})
	end

	p4.mounted = false
	p4.focusController = if not FFlagAXMigrateAXToGlobalAutofocus then RoactGamepad.createFocusController() else nil
	p4.defaultChildRef = Roact.createRef()

	if not FFlagAXMigrateAXToGlobalAutofocus then
		function p4.onFocusChanged(p5) -- line: 107
			-- upvalues: p4 (copy)
			if p4.mounted then
				p4:setState({
					gamepadFocused = p5
				})
			end
		end
	end

	function p4.closePrompt() -- line: 116
		-- upvalues: NavigationUtils (copy), p4 (copy)
		NavigationUtils.closeOverlay(p4.props.navigation)
	end
end
function v41.didMount(p6) -- line: 121
	-- upvalues: FFlagAXMigrateAXToGlobalAutofocus (copy), Cryo (copy)
	p6.mounted = true

	if not FFlagAXMigrateAXToGlobalAutofocus then
		p6:handleUpdate(Cryo.Dictionary.join(p6.props, {
			isFocused = false
		}), p6.state)
	end
end
function v41.willUnmount(p7) -- line: 134
	p7.mounted = false
end

if not FFlagAXMigrateAXToGlobalAutofocus then
	function v41.didUpdate(p8, p9, p10) -- line: 138
		p8:handleUpdate(p9, p10)
	end
	function v41.cancelCaptureFocus(p11) -- line: 142
		if p11.captureFocusPromise then
			p11.captureFocusPromise:cancel()
			p11.captureFocusPromise = nil
		end
	end
	function v41.captureFocusAfterDelay(t2: {[any]: any}, n1: number) -- line: 149
		-- upvalues: Promise (copy)
		t2:cancelCaptureFocus()
		t2.captureFocusPromise = Promise.delay(n1):andThen(t2.focusController.captureFocus)
	end
	function v41.handleUpdate(p12, p13, p14) -- line: 154
		-- upvalues: v28 (copy)
		local lastInputIsGamepad = p12.state.lastInputIsGamepad
		local lastInputIsGamepad2 = p14.lastInputIsGamepad
		local v62 = lastInputIsGamepad and p12.props.isFocused
		local v63 = not lastInputIsGamepad2 and lastInputIsGamepad
		local v64 = lastInputIsGamepad2 and not lastInputIsGamepad
		local v65 = not p13.isFocused and p12.props.isFocused

		if v62 and (v65 or v63) then
			v28:trace("captureFocus [Overlay], navigatedToPage: {}, acquiredGamepadInput: {}", v65, v63)
			p12.focusController.captureFocus()

			return
		end

		if v64 then
			v28:trace("releaseFocus [Overlay]")
			p12.focusController.releaseFocus()
		end
	end
end

function v41.getChildren(p15) -- line: 176
	-- upvalues: FFlagAXMigrateAXToGlobalAutofocus (copy), Cryo (copy), Roact (copy), NavigationEventsLogger (copy), ExternalEventConnection (copy), UserInputService (copy), isGamepadInput (copy), IsVRAppBuild (copy), BoundInputsUpdater (copy), GamepadFocusRecovery (copy)
	local overlayComponent = p15.props.overlayComponent
	local arguments = p15.props.arguments

	if not FFlagAXMigrateAXToGlobalAutofocus then
		arguments = if not arguments.focusController then Cryo.Dictionary.join(arguments, {
			defaultChildRef = p15.defaultChildRef,
			focusController = p15.focusController
		}) else Cryo.Dictionary.join(arguments, {
			defaultChildRef = p15.defaultChildRef
		})
	end

	local v69 = Roact.createElement(overlayComponent, arguments)

	return {
		NavigationEventsLogger = Roact.createElement(NavigationEventsLogger, {
			pageName = "[Overlay]"
		}),
		LastInputTypeChangedConnection = if not FFlagAXMigrateAXToGlobalAutofocus then Roact.createElement(ExternalEventConnection, {
			event = UserInputService.LastInputTypeChanged,
			callback = function(p16) -- line: 202
				-- upvalues: isGamepadInput (copy), p15 (copy)
				local v82 = isGamepadInput(p16)

				if v82 ~= p15.state.lastInputIsGamepad then
					p15:setState({
						lastInputIsGamepad = v82
					})
				end
			end
		}) else nil,
		BoundInputsUpdater = if not FFlagAXMigrateAXToGlobalAutofocus then if not IsVRAppBuild() then Roact.createElement(BoundInputsUpdater) else nil else nil,
		GamepadFocusRecovery = if not FFlagAXMigrateAXToGlobalAutofocus then Roact.createElement(GamepadFocusRecovery, {
			debugName = "[Overlay]",
			focusController = p15.focusController,
			isGamepadInput = p15.state.lastInputIsGamepad
		}) else nil,
		OverlayScreen = v69
	}
end
function v41.render(p17) -- line: 225
	-- upvalues: IsVRAppBuild (copy), Roact (copy), AvatarVRPanelWrapper (copy), AvatarScreenProperties (copy), GetFFlagLuafiedReportEntryPoints (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), Focusable (copy), FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation (copy), RoactGamepad (copy)
	if IsVRAppBuild() then
		local routeName = p17.props.navigation.state.routeName

		return Roact.createElement(AvatarVRPanelWrapper, {
			panelPlacement = AvatarScreenProperties[routeName].VRPanelPlacement,
			roundedCornersFrame = not not GetFFlagLuafiedReportEntryPoints() and AvatarScreenProperties[routeName].VRPanelRoundedCorners
		}, p17:getChildren())
	end

	return Roact.createElement(if not FFlagAXMigrateAXToGlobalAutofocus then Focusable.Frame else "Frame", {
		[Roact.Ref] = if not FFlagAXMigrateAXToGlobalAutofocus then nil else p17.props.forwardRef,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		SelectionGroup = not not FFlagAXMigrateAXToGlobalAutofocus or nil,
		SelectionBehaviorLeft = if not FFlagAXMigrateAXToGlobalAutofocus then nil else Enum.SelectionBehavior.Stop,
		SelectionBehaviorRight = if not FFlagAXMigrateAXToGlobalAutofocus then nil else Enum.SelectionBehavior.Stop,
		SelectionBehaviorUp = if not FFlagAXMigrateAXToGlobalAutofocus then nil else Enum.SelectionBehavior.Stop,
		SelectionBehaviorDown = if not FFlagAXMigrateAXToGlobalAutofocus then nil else Enum.SelectionBehavior.Stop,
		focusController = if not FFlagAXMigrateAXToGlobalAutofocus then p17.focusController else nil,
		onFocusChanged = if not FFlagAXMigrateAXToGlobalAutofocus then p17.onFocusChanged else nil,
		defaultChild = if not FFlagAXMigrateAXToGlobalAutofocus then p17.defaultChildRef else nil,
		[Roact.Ref] = p17.props.focusNavigationRef,
		inputBindings = if not FFlagAXMigrateAXToGlobalAutofocus and not FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation then {
			closePrompt = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonB, p17.closePrompt)
		} else nil
	}, p17:getChildren())
end

if FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation then
	local u42 = withNavigationFocus(v41)

	return function(p18) -- line: 263
		-- upvalues: useNavigation (copy), React (copy), NavigationUtils (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), useFocusNavigableSurfaceRegistryConnection (copy), FocusNavigableSurfaceIdentifierEnum (copy), useFocusNavigationBindings (copy), useTableWrappedCallbackRef (copy), useFocusGuiObject (copy), v38 (copy), Responsive (copy), u42 (ref), Cryo (copy)
		local v73 = useNavigation()
		local v74 = React.useCallback(function() -- line: 265
			-- upvalues: NavigationUtils (copy), v73 (copy)
			NavigationUtils.closeOverlay(v73)
		end, { v73 })
		local v75 = React.useRef(nil)

		if FFlagAXMigrateAXToGlobalAutofocus then
			useFocusNavigableSurfaceRegistryConnection(v75.current, FocusNavigableSurfaceIdentifierEnum.CentralOverlay)
		end

		local v76 = useFocusNavigationBindings(v75, v74)
		local v77 = useTableWrappedCallbackRef(v76)
		local v78 = useFocusGuiObject()
		local v79 = if not v38 then nil else Responsive.usePreferredInput() == Responsive.Input.Directional

		React.useEffect(function() -- line: 282
			-- upvalues: v38 (copy), v75 (copy), v79 (copy), v78 (copy)
			if if not v38 then v75.current else v75.current and v79 then
				task.delay(0.1, function() -- line: 287
					-- upvalues: v78 (copy), v75 (copy)
					v78(v75.current)
				end)
			end
		end, {
			v78,
			if not v38 then nil else v79
		})

		return React.createElement(u42, Cryo.Dictionary.join(p18, {
			focusNavigationRef = v77
		}))
	end
end

return withNavigationFocus(v41)
