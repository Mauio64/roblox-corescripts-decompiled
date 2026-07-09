local CoreGui = game:GetService("CoreGui")
local Modules = CoreGui.RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local ReactRoblox = require(CorePackages.Packages.ReactRoblox)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Cryo = require(CorePackages.Packages.Cryo)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local AppGuiService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppGuiService
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local FocusNavigableSurfaceRegistry = FocusNavigationUtils.FocusNavigableSurfaceRegistry
local useRegisterFocusNavigableSurface = FocusNavigableSurfaceRegistry.useRegisterFocusNavigableSurface
local useDeRegisterFocusNavigableSurface = FocusNavigableSurfaceRegistry.useDeRegisterFocusNavigableSurface
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useUiModeInfo = require(CorePackages.Workspace.Packages.RobloxAppHooks).useUiModeInfo
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local AppEventIngestService = require(Modules.LuaApp.Services.AppEventIngestService)
local LocaleRestrictionModal = require(Modules.LuaApp.Components.LocaleRestriction.LocaleRestrictionModal)
local RestrictionSource = require(Modules.LuaApp.Models.UserModerationApi.RestrictionSource)
local v24 = Roact.PureComponent:extend("LocaleRestrictionEventReceiver")

function v24.render(p1) -- line: 35
	-- upvalues: Cryo (copy), RestrictionSource (copy), ReactRoblox (copy), React (copy), Roact (copy), LocaleRestrictionModal (copy), CoreGui (copy)
	local v30 = Cryo.Dictionary.union(p1.props.globalGuiInset, {
		top = p1.props.statusBarHeight
	})

	if not p1.props.restrictionDetail or p1.props.restrictionDetail.source ~= RestrictionSource.LocaleUnavailable then
		return nil
	end

	return ReactRoblox.createPortal({
		ModerationOverlayWrapper = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Selectable = false,
			Size = UDim2.fromScale(1, 1),
			ref = p1.props.forwardRef
		}, {
			ModerationOverlay = Roact.createElement(LocaleRestrictionModal, {
				screenSize = p1.props.screenSize,
				globalGuiInset = v30
			})
		})
	}, CoreGui)
end

local v25 = RoactRodux.connect(function(p2, _) -- line: 60
	return {
		screenSize = p2.ScreenSize,
		restrictionDetail = p2.UserAccess and p2.UserAccess.restrictionDetail or nil,
		globalGuiInset = p2.GlobalGuiInset,
		statusBarHeight = p2.TopBar.statusBarHeight
	}
end)(v24)
local u26 = RoactServices.connect({
	networking = RoactNetworking,
	guiService = AppGuiService,
	eventIngestService = AppEventIngestService
})(v25)
local t1 = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local function selectIsFocusable(p4) -- line: 80
	-- upvalues: RestrictionSource (copy)
	return p4.UserAccess and (p4.UserAccess.restrictionDetail and p4.UserAccess.restrictionDetail.source == RestrictionSource.LocaleUnavailable)
end

return function(p5) -- line: 86
	-- upvalues: useSelector (copy), selectIsFocusable (copy), React (copy), useRegisterFocusNavigableSurface (copy), useDeRegisterFocusNavigableSurface (copy), FocusNavigableSurfaceIdentifierEnum (copy), ReactFocusNavigation (copy), t1 (copy), FocusNavigationEventNameEnum (copy), useUiModeInfo (copy), u26 (ref), Cryo (copy)
	local v35 = useSelector(selectIsFocusable)
	local v36, v37 = React.useState(nil)
	local v38 = useRegisterFocusNavigableSurface()
	local v39 = useDeRegisterFocusNavigableSurface()
	local v40 = v36 and v35

	React.useEffect(function() -- line: 93
		-- upvalues: v40 (copy), v38 (copy), FocusNavigableSurfaceIdentifierEnum (copy), v36 (copy), v39 (copy)
		if v40 then
			v38(FocusNavigableSurfaceIdentifierEnum.ModerationOverlay, v36)
		end

		return function() -- line: 98
			-- upvalues: v39 (copy), FocusNavigableSurfaceIdentifierEnum (copy), v36 (copy)
			v39(FocusNavigableSurfaceIdentifierEnum.ModerationOverlay, v36)
		end
	end, {
		v40,
		v36,
		v38,
		v39
	})

	local v41 = React.useCallback(function(p6) -- line: 103
		p6:cancel()
	end, {})
	local v42 = ReactFocusNavigation.useEventMap(t1, v37)
	local v43 = ReactFocusNavigation.useEventHandler(FocusNavigationEventNameEnum.NavigateBack, v41, nil, v42)
	local v44 = useUiModeInfo()

	return React.createElement(u26, Cryo.Dictionary.join(p5, {
		forwardRef = v43,
		uiMode = v44.uiMode
	}))
end
