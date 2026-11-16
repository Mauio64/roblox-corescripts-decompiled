local CoreGui = game:GetService("CoreGui")

local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local ReactRoblox = require(CorePackages.Packages.ReactRoblox)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Cryo = require(CorePackages.Packages.Cryo)

local Roact = require(CorePackages.Packages.Roact)
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module = require("@luauforge/bundled/eda")
local appGuiService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppGuiService

local module2 = require("@luauforge/bundled/eeo")
local focusNavigableSurfaceRegistry = module2.FocusNavigableSurfaceRegistry
local useRegisterFocusNavigableSurface = focusNavigableSurfaceRegistry.useRegisterFocusNavigableSurface
local useDeRegisterFocusNavigableSurface = focusNavigableSurfaceRegistry.useDeRegisterFocusNavigableSurface
local focusNavigableSurfaceIdentifierEnum = module2.FocusNavigableSurfaceIdentifierEnum
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local focusNavigationEventNameEnum = module2.FocusNavigationEventNameEnum
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector

local fFlagUseSignalsForUserAccess = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForUserAccess
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local getUserAccessStore = if fFlagUseSignalsForUserAccess then require("@luauforge/bundled/fDT").GetUserAccessStore else nil

local useIsRestrictedBySource = if fFlagUseSignalsForUserAccess then require("@luauforge/bundled/fDS").useIsRestrictedBySource else nil

local module3 = require("@luauforge/bundled/icb")
local module4 = require("@luauforge/bundled/fDK")

local extended = Roact.PureComponent:extend("ParentalControlsScreentimeEventReceiver")

function extended.render(p2)
	local union = Cryo.Dictionary.union(p2.props.globalGuiInset, {
		top = p2.props.statusBarHeight
	})

	if p2.props.restrictionDetail and p2.props.restrictionDetail.source == module4.Screentime then
		return ReactRoblox.createPortal({
			ModerationOverlayWrapper = React.createElement(
				"Frame",
				{
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 1,
					ref = p2.props.forwardRef,
					Selectable = false
				},
				{
					ModerationOverlay = React.createElement(module3, {
						screenSize = p2.props.screenSize,
						globalGuiInset = union
					})
				}
			)
		}, CoreGui)
	end

	return nil
end

local v5 = RoactRodux.connect(function(data, p2)
	local v6 = {
		screenSize = data.ScreenSize,
		restrictionDetail = 0,
		globalGuiInset = 0,
		statusBarHeight = 0
	}

	local v7 = if not (fFlagUseSignalsForUserAccess or not data.UserAccess) then data.UserAccess.restrictionDetail or nil else nil
	v6.restrictionDetail = v7

	v6.globalGuiInset = data.GlobalGuiInset
	v6.statusBarHeight = data.TopBar.statusBarHeight
	return v6
end)(extended)

if fFlagUseSignalsForUserAccess then
	local v6 = v5
	local function ParentalControlsScreentimeEventReceiverWithSignals(p2)
		local v7 = useSignalState(getUserAccessStore(false).getUserAccessRestrictionDetail)
		return React.createElement(v6, Cryo.Dictionary.union(p2, {
			restrictionDetail = v7
		}))
	end

	v5 = React.memo(ParentalControlsScreentimeEventReceiverWithSignals)
end

local v6 = roactServices.connect({ networking = module, guiService = appGuiService })(v5)

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack
}

local function selectIsFocusable(p2)
	return p2.UserAccess
		and p2.UserAccess.restrictionDetail
		and p2.UserAccess.restrictionDetail.source == module4.Screentime
end

return function(p2)
	local v7

	if fFlagUseSignalsForUserAccess then
		v7 = useIsRestrictedBySource(module4.Screentime)
	else
		v7 = useSelector(selectIsFocusable)
	end

	local state, setState = React.useState(nil)
	local v8 = useRegisterFocusNavigableSurface()
	local v9 = useDeRegisterFocusNavigableSurface()
	local v10 = state and v7

	React.useEffect(function()
		if v10 then
			v8(focusNavigableSurfaceIdentifierEnum.ModerationOverlay, state)
		end

		return function()
			v9(focusNavigableSurfaceIdentifierEnum.ModerationOverlay, state)
		end
	end, { v10, state, v8, v9 })

	local v11 = React.useCallback(function(object)
		object:cancel()
	end, {})

	local v12 = ReactFocusNavigation.useEventMap(navigateBacks, setState)
	local v13 = ReactFocusNavigation.useEventHandler(
		focusNavigationEventNameEnum.NavigateBack,
		v11,
		nil,
		v12
	)

	return React.createElement(v6, Cryo.Dictionary.join(p2, { forwardRef = v13 }))
end
