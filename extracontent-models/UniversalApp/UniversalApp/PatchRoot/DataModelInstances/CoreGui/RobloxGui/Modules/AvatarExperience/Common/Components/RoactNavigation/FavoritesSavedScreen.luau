local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Foundation = require(CorePackages.Packages.Foundation)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local FullView = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Enums.FullView
local FavoritesSavedView = require(CorePackages.Workspace.Packages.AvatarExperienceFavoritesManager).Components.FavoritesSavedView
local Common = Modules.AvatarExperience.Common
local Utils = require(Modules.AvatarExperience.Common.Utils)
local NamedRefsContext = require(Common.Context.NamedRefsContext)
local useOverlayClosedCallback = require(Common.Hooks.useOverlayClosedCallback)
local useAvatarExperienceFocusNavigationBindings = require(Common.Hooks.useAvatarExperienceFocusNavigationBindings)
local useFullView = require(Common.Hooks.useFullView)
local NavigationEventsLogger = require(Common.Components.RoactNavigation.Debug.NavigationEventsLogger)
local AvatarExperienceView = require(Common.Components.AvatarExperienceView)
local FavoritesSavedTopBar = require(Common.Components.TopBar.FavoritesSavedTopBar)

local function FavoritesSavedScreen(_: {[any]: any}) -- line: 48
	-- upvalues: React (copy), useOverlayClosedCallback (copy), useFullView (copy), FullView (copy), NamedRefsContext (copy), RoactGamepad (copy), useAvatarExperienceFocusNavigationBindings (copy), AvatarScreen (copy), Utils (copy), Foundation (copy), NavigationEventsLogger (copy), AvatarExperienceView (copy), FavoritesSavedTopBar (copy), FavoritesSavedView (copy)
	local v21 = React.useRef(nil)
	local v22 = useOverlayClosedCallback()
	local v23, v24 = useFullView()
	local v25 = v23 == FullView.SceneFullView
	local v26 = v23 == FullView.UIFullView
	local v27 = React.useRef(nil)
	local v28 = React.useRef(nil)
	local v29 = React.useRef(nil)
	local v30 = React.useRef(nil)
	local v31 = React.useContext(NamedRefsContext)
	local v32 = RoactGamepad.useRefCache()
	local v33 = useAvatarExperienceFocusNavigationBindings({
		overlayClosedCallback = v22
	}, v31[AvatarScreen.FavoritesSaved])
	local v34 = React.useCallback(function() -- line: 68
		-- upvalues: Utils (copy), v23 (copy), v24 (copy)
		local v35 = Utils.getNewFullViewEnum(v23)

		v24(v35)
	end, {
		v23,
		v24
	})

	return React.createElement(Foundation.View, {
		tag = "size-full gui-object-defaults",
		ref = v33
	}, {
		NavigationEventsLogger = React.createElement(NavigationEventsLogger, {
			pageName = AvatarScreen.FavoritesSaved
		}),
		AvatarExperienceView = React.createElement(AvatarExperienceView, {
			allowAdaptiveScrolling = true,
			bottomBarEnabled = false,
			changeViewFunction = v34,
			isSceneFullView = v25,
			isUIFullView = v26,
			topBar = React.createElement(FavoritesSavedTopBar, {
				topBarRef = v27
			}),
			refinementButtonsRef = v29,
			quickButtonsRef = v30,
			ref = v28,
			multiTryOnBottomBarRef = v21,
			itemDetailsPeekViewRefs = v32
		}, {
			FavoritesSavedView = React.createElement(FavoritesSavedView)
		})
	})
end

return require(Common.Components.RoactNavigation.withStackVisibilityWrapper)(FavoritesSavedScreen)
