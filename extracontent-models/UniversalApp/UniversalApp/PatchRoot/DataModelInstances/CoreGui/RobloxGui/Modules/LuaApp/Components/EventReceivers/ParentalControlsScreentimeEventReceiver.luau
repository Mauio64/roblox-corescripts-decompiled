local CoreGui = game:GetService("CoreGui")
local Modules = CoreGui.RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local ReactRoblox = require(CorePackages.Packages.ReactRoblox)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
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
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local ScreentimeRestrictionModal = require(Modules.LuaApp.Components.Screentime.ScreentimeRestrictionModal)
local RestrictionSource = require(Modules.LuaApp.Models.UserModerationApi.RestrictionSource)
local v22 = Roact.PureComponent:extend("ParentalControlsScreentimeEventReceiver")

function v22.render(p1) -- line: 29
	-- upvalues: Cryo (copy), RestrictionSource (copy), ReactRoblox (copy), React (copy), ScreentimeRestrictionModal (copy), CoreGui (copy)
	local v28 = Cryo.Dictionary.union(p1.props.globalGuiInset, {
		top = p1.props.statusBarHeight
	})

	if not p1.props.restrictionDetail or p1.props.restrictionDetail.source ~= RestrictionSource.Screentime then
		return nil
	end

	return ReactRoblox.createPortal({
		ModerationOverlayWrapper = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Selectable = false,
			Size = UDim2.fromScale(1, 1),
			ref = p1.props.forwardRef
		}, {
			ModerationOverlay = React.createElement(ScreentimeRestrictionModal, {
				screenSize = p1.props.screenSize,
				globalGuiInset = v28
			})
		})
	}, CoreGui)
end

local v23 = RoactRodux.connect(function(p2, _) -- line: 51
	return {
		screenSize = p2.ScreenSize,
		restrictionDetail = p2.UserAccess and p2.UserAccess.restrictionDetail or nil,
		globalGuiInset = p2.GlobalGuiInset,
		statusBarHeight = p2.TopBar.statusBarHeight
	}
end)(v22)
local u24 = RoactServices.connect({
	networking = RoactNetworking,
	guiService = AppGuiService
})(v23)
local t1 = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local function selectIsFocusable(p4) -- line: 70
	-- upvalues: RestrictionSource (copy)
	return p4.UserAccess and (p4.UserAccess.restrictionDetail and p4.UserAccess.restrictionDetail.source == RestrictionSource.Screentime)
end

return function(p5) -- line: 76
	-- upvalues: useSelector (copy), selectIsFocusable (copy), React (copy), useRegisterFocusNavigableSurface (copy), useDeRegisterFocusNavigableSurface (copy), FocusNavigableSurfaceIdentifierEnum (copy), ReactFocusNavigation (copy), t1 (copy), FocusNavigationEventNameEnum (copy), u24 (ref), Cryo (copy)
	local v33 = useSelector(selectIsFocusable)
	local v34, v35 = React.useState(nil)
	local v36 = useRegisterFocusNavigableSurface()
	local v37 = useDeRegisterFocusNavigableSurface()
	local v38 = v34 and v33

	React.useEffect(function() -- line: 83
		-- upvalues: v38 (copy), v36 (copy), FocusNavigableSurfaceIdentifierEnum (copy), v34 (copy), v37 (copy)
		if v38 then
			v36(FocusNavigableSurfaceIdentifierEnum.ModerationOverlay, v34)
		end

		return function() -- line: 88
			-- upvalues: v37 (copy), FocusNavigableSurfaceIdentifierEnum (copy), v34 (copy)
			v37(FocusNavigableSurfaceIdentifierEnum.ModerationOverlay, v34)
		end
	end, {
		v38,
		v34,
		v36,
		v37
	})

	local v39 = React.useCallback(function(p6) -- line: 93
		p6:cancel()
	end, {})
	local v40 = ReactFocusNavigation.useEventMap(t1, v35)
	local v41 = ReactFocusNavigation.useEventHandler(FocusNavigationEventNameEnum.NavigateBack, v39, nil, v40)

	return React.createElement(u24, Cryo.Dictionary.join(p5, {
		forwardRef = v41
	}))
end
