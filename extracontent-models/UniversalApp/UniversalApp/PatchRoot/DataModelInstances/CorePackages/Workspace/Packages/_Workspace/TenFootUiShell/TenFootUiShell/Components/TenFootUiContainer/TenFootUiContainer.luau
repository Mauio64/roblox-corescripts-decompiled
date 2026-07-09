local TenFootUiShell = script:FindFirstAncestor("TenFootUiShell")
local TenFootUiShellParent = TenFootUiShell.Parent
local Responsive = require(TenFootUiShellParent.Responsive)
local React = require(TenFootUiShellParent.React)
local getOrCreateSurfaceGuiContainer = require(TenFootUiShell.getOrCreateSurfaceGuiContainer)
local getOrCreateWorkSpaceContainer = require(TenFootUiShell.getOrCreateWorkSpaceContainer)
local TenFootUiGlobalEffects = require(TenFootUiShell.Components.TenFootUiGlobalEffects)
local GlobalNavContainer = require(TenFootUiShellParent.TenFootUiGlobalNav).GlobalNavContainer
local TenFootUiContext = require(TenFootUiShellParent.TenFootUiCommon).TenFootUiContext
local AppShortcutBar = require(TenFootUiShellParent.AppShortcutBar)
local AppShortcutBarContainer = AppShortcutBar.AppShortcutBarContainer
local AppShortcutBarContext = AppShortcutBar.AppShortcutBarContext
local TenFootUiLayout = require(script.Parent.TenFootUiLayout)
local ProviderContainer = require(TenFootUiShellParent.RoactUtils).Components.ProviderContainer
local useOverlay = require(TenFootUiShellParent.Foundation).Hooks.useOverlay
local SduiDiscoveryDependencyUpdater = require(TenFootUiShellParent.ServerDrivenUi).SduiDiscoveryDependencyUpdater
local SduiAvatarExperienceRegister = require(TenFootUiShellParent.AvatarExperienceServerDrivenUi).SduiAvatarExperienceRegister
local SduiSharedRegister = require(TenFootUiShellParent.SduiSharedContent).SduiSharedRegister
local useNavigation = require(TenFootUiShellParent.Navigation).useNavigation
local SharedFlags = require(TenFootUiShellParent.SharedFlags)
local FFlagEnableAvatarExperienceSdui = SharedFlags.FFlagEnableAvatarExperienceSdui
local CollectionViews = require(TenFootUiShellParent.CollectionViews)
local v23 = game:DefineFastFlag("EnableProgressLoadingAssetsTenFoot", false)
local ProgressLoadingAssetsScreenGui = nil

if v23 then
	ProgressLoadingAssetsScreenGui = require(TenFootUiShellParent.ProgressLoading).ProgressLoadingAssetsScreenGui
end

local v25 = game:DefineFastFlag("EnableSduiRegistriesforTenFootUiContainer", false)
local FFlagLuaAppUseOverlayInAppContainer = SharedFlags.FFlagLuaAppUseOverlayInAppContainer

local function RootViewContainer(t1: {[any]: any}) -- line: 52
	-- upvalues: React (copy), Responsive (copy), CollectionViews (copy), getOrCreateSurfaceGuiContainer (copy), getOrCreateWorkSpaceContainer (copy), useNavigation (copy)
	local v30 = React.useContext(Responsive.ContainerRef)

	React.useEffect(function() -- line: 54
		-- upvalues: v30 (copy), CollectionViews (copy)
		local v40 = if not v30 then nil else v30.current

		if not v40 then
			return
		end

		local v41 = CollectionViews.getMainCollectionLayoutStore(false)

		if v41.setDefaultContentRegionWidth then
			v41.setDefaultContentRegionWidth(v40.AbsoluteSize.X)
		end

		local connection = v40:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 63
			-- upvalues: v41 (copy), v40 (copy)
			if v41.setDefaultContentRegionWidth then
				v41.setDefaultContentRegionWidth(v40.AbsoluteSize.X)
			end
		end)

		return function() -- line: 68
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, { v30 })

	local v31 = getOrCreateSurfaceGuiContainer()
	local v32 = getOrCreateWorkSpaceContainer()
	local v33 = useNavigation()
	local v34 = React.createElement(t1.dependencies.RootNavigator, {
		navigation = v33,
		screenProps = {
			surfaceGuiContainer = v31,
			worldContainer = v32
		}
	})

	return (React.createElement(React.Fragment, nil, {
		ResponsiveContainerFrame = React.createElement(Responsive.ResponsiveContainerFrame),
		NavigatorView = v34
	}))
end
local function TenFootUiContainer(t2: {[any]: any}) -- line: 91
	-- upvalues: FFlagLuaAppUseOverlayInAppContainer (copy), useOverlay (copy), getOrCreateSurfaceGuiContainer (copy), getOrCreateWorkSpaceContainer (copy), React (copy), TenFootUiLayout (copy), RootViewContainer (copy), GlobalNavContainer (copy), AppShortcutBarContainer (copy), v23 (copy), ProgressLoadingAssetsScreenGui (ref), TenFootUiGlobalEffects (copy), SduiSharedRegister (copy), v25 (copy), SduiDiscoveryDependencyUpdater (copy), FFlagEnableAvatarExperienceSdui (copy), SduiAvatarExperienceRegister (copy), TenFootUiContext (copy), AppShortcutBarContext (copy), ProviderContainer (copy)
	if FFlagLuaAppUseOverlayInAppContainer then
		useOverlay()
	end

	local v36 = getOrCreateSurfaceGuiContainer()
	local v37 = getOrCreateWorkSpaceContainer()
	local v38 = React.createElement(React.Fragment, nil, {
		Toast = t2.toast,
		CentralOverlay = t2.centralOverlay,
		TenFootUiLayout = React.createElement(TenFootUiLayout, {
			adorneeParent = v37,
			surfaceGuiParent = v36,
			rootViewSlot = React.createElement(RootViewContainer, t2),
			globalNavSlot = React.createElement(GlobalNavContainer),
			controllerBarSlot = React.createElement(AppShortcutBarContainer)
		}),
		ProgressLoadingAssetsScreenGui = if not v23 then nil else React.createElement(ProgressLoadingAssetsScreenGui),
		GlobalEffects = React.createElement(TenFootUiGlobalEffects),
		SduiSharedRegister = React.createElement(SduiSharedRegister),
		SduiDiscoveryDependencyUpdater = if not v25 then nil else React.createElement(SduiDiscoveryDependencyUpdater),
		SduiAvatarExperienceRegister = if not v25 or not FFlagEnableAvatarExperienceSdui then nil else React.createElement(SduiAvatarExperienceRegister)
	})
	local t3 = {}

	table.insert(t3, {
		class = TenFootUiContext.Provider,
		props = {
			value = t2.dependencies
		}
	})
	table.insert(t3, {
		class = AppShortcutBarContext.Provider
	})

	return React.createElement(ProviderContainer, {
		providers = t3
	}, v38)
end

return TenFootUiContainer
