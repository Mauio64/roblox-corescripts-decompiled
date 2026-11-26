local CorePackages = game:GetService("CorePackages")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local withNavigationFocus = RoactNavigation.withNavigationFocus
local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")

local t = require(CorePackages.Packages.t)

local module3 = require("@luauforge/deferred/gJK")

local module4 = require("@luauforge/bundled/ehL")
local useFocusNavigableSurfaceRegistryConnection = module4.useFocusNavigableSurfaceRegistryConnection
local focusNavigableSurfaceIdentifierEnum = module4.FocusNavigableSurfaceIdentifierEnum
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local focusNavigationEventNameEnum = module4.FocusNavigationEventNameEnum
local module5 = require("@luauforge/bundled/dXh")
local useTableWrappedCallbackRef = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useTableWrappedCallbackRef
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject

local module6 = require("@luauforge/deferred/gJL")

local avatarScreenProperties = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").AvatarRoute.AvatarScreenProperties
local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild
local getFFlagLuafiedReportEntryPoints = SharedFlags.GetFFlagLuafiedReportEntryPoints

local fFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation

local defineFastFlag = game:DefineFastFlag("AXOverlayShouldNotAutofocusForNonDirectionalInput", false)

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack
}

local function useFocusNavigationBindings(ref, callback)
	local v5 = ReactFocusNavigation.useEventMap(navigateBacks, ref)
	local v6 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p2)
					p2.cancelled = true
					callback()
				end)
			}
		}
	end, { callback })
	return ReactFocusNavigation.useEventHandlerMap(v6, v5)
end

local extended = Roact.PureComponent:extend("OverlayFocusHandler")

local strictInterface = t.strictInterface
local v5 = {
	overlayComponent = t.union(t.table, t.callback),
	arguments = t.table,
	focusNavigationRef = 0,
	navigation = 0,
	isFocused = 0,
	forwardRef = 0
}
local v6 = if fFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation then t.table else nil
v5.focusNavigationRef = v6

v5.navigation = t.table
v5.isFocused = t.boolean
v5.forwardRef = t.optional(t.any)
extended.validateProps = strictInterface(v5)

function extended:init()
	self.mounted = false

	self.defaultChildRef = Roact.createRef()

	function self.closePrompt()
		module5.closeOverlay(self.props.navigation)
	end
end

function extended:didMount()
	self.mounted = true
end

function extended:willUnmount()
	self.mounted = false
end

function extended:getChildren()
	local overlayComponent = self.props.overlayComponent
	local arguments = self.props.arguments

	local element = Roact.createElement(overlayComponent, arguments)

	return {
		NavigationEventsLogger = Roact.createElement(module3, { pageName = "[Overlay]" }),
		OverlayScreen = element
	}
end

function extended:render()
	if isVRAppBuild() then
		local routeName = self.props.navigation.state.routeName

		local createElement = Roact.createElement
		local v8 = {
			panelPlacement = avatarScreenProperties[routeName].VRPanelPlacement,
			roundedCornersFrame = 0
		}
		local v9 = if getFFlagLuafiedReportEntryPoints() then avatarScreenProperties[routeName].VRPanelRoundedCorners else false
		v8.roundedCornersFrame = v9
		return createElement(module6, v8, self:getChildren())
	end

	return Roact.createElement("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		SelectionGroup = true,
		SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
		SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
		SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
		SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
		[Roact.Ref] = self.props.focusNavigationRef
	}, self:getChildren())
end

if not fFlagAXMigrateManageOutfitPageInputBindingsToFocusNavigation then
	return withNavigationFocus(extended)
end

local v7 = withNavigationFocus(extended)

return function(p2)
	local v8 = useNavigation()
	local v9 = React.useCallback(function()
		module5.closeOverlay(v8)
	end, { v8 })

	local ref = React.useRef(nil)
	useFocusNavigableSurfaceRegistryConnection(
		ref.current,
		focusNavigableSurfaceIdentifierEnum.CentralOverlay
	)

	local v11 = useTableWrappedCallbackRef((useFocusNavigationBindings(ref, v9)))
	local v12 = useFocusGuiObject()

	local v13 = if defineFastFlag then Responsive.usePreferredInput() == Responsive.Input.Directional else nil

	local function fn()
		local v14 = if defineFastFlag then ref.current and v13 else ref.current

		if v14 then
			task.delay(0.1, function()
				v12(ref.current)
			end)
		end
	end

	React.useEffect(fn, { v12, if defineFastFlag then v13 else nil })

	return React.createElement(v7, Cryo.Dictionary.join(p2, { focusNavigationRef = v11 }))
end
