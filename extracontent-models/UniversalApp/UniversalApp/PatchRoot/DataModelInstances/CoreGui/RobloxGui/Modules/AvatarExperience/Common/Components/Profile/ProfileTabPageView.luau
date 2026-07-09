local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local View = require(CorePackages.Packages.Foundation).View
local TopBar = require(Modules.LuaApp.Components.TopBar.TopBar)
local AvatarExperienceView = require(Modules.AvatarExperience.Common.Components.AvatarExperienceView)
local ProfilePlatformUniversalAppWrapper = require(Modules.LuaApp.Components.ProfilePlatform.ProfilePlatformUniversalAppWrapper)
local AXTransitionSegmentedMenu = require(Modules.AvatarExperience.Common.Components.AXTransitionSegmentedMenu)
local v10 = game:DefineFastFlag("RetainTopBarOnProfileTabPageView", false)

local function ProfileTabPageView(t1: {[any]: any}) -- line: 50
	-- upvalues: v10 (copy), React (copy), TopBar (copy), AXTransitionSegmentedMenu (copy), View (copy), AvatarExperienceView (copy), ProfilePlatformUniversalAppWrapper (copy)
	local v13 = if not v10 and not t1.isAtProfileRoot then nil else React.createElement(TopBar.Container, {
		useParentSizeForCenterItem = true,
		ZIndex = 2,
		leftItem = t1.leftItem,
		centerItem = AXTransitionSegmentedMenu,
		transparentBackground = t1.topBarTransparent
	})

	return React.createElement(View, {
		tag = {
			["data-testid=ProfileTabPageView"] = true,
			["size-full"] = true
		}
	}, {
		AvatarExperienceView = React.createElement(AvatarExperienceView, {
			isSceneFullView = false,
			showUndoRedo = true,
			showSaveButton = false,
			isUIFullView = t1.isPortrait,
			topBar = if not t1.isPortrait then v13 else nil
		}, {
			ProfileWrapper = React.createElement(ProfilePlatformUniversalAppWrapper, t1.wrapperProps)
		}),
		OverlayTopBar = if not t1.isOverlayTopBarVisible then nil else v13
	})
end

return ProfileTabPageView
