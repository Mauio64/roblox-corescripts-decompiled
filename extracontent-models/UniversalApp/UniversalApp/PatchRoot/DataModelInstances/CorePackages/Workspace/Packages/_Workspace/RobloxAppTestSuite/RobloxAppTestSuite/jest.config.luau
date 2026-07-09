local ParentParent = script.Parent.Parent

return {
	projects = {
		require(ParentParent.Achievements)["jest.config"],
		require(ParentParent.AppHeaderBar)["jest.config"],
		require(ParentParent.AppNavBar)["jest.config"],
		require(ParentParent.AppTabBarRodux)["jest.config"],
		require(ParentParent.AppTopBanner)["jest.config"],
		require(ParentParent.BugReporting)["jest.config"],
		require(ParentParent.BumperNavigation)["jest.config"],
		require(ParentParent.CrossPlay)["jest.config"],
		require(ParentParent.HoldToPlay)["jest.config"],
		require(ParentParent.InExperienceLocales)["jest.config"],
		require(ParentParent.LogReporting)["jest.config"],
		require(ParentParent.NavigationRodux)["jest.config"],
		require(ParentParent.RobloxAppLocales)["jest.config"],
		require(ParentParent.RobloxAppUpdate)["jest.config"],
		require(ParentParent.RobloxAppToastsRodux)["jest.config"],
		require(ParentParent.RobloxAppNavigation)["jest.config"],
		require(ParentParent.RobloxAppNavigationCore)["jest.config"],
		require(ParentParent.SocialGraphSync)["jest.config"],
		require(ParentParent.DeviceOrientationRodux)["jest.config"],
		require(ParentParent.AppRatingPrompt)["jest.config"],
		require(ParentParent.UiShellEvents)["jest.config"],
		game.CoreGui.RobloxGui.Modules.LuaApp.Navigation["jest.config"],
		game.CoreGui.RobloxGui.Modules.LuaApp.Util["jest.config"],
		game.CoreGui.RobloxGui.Modules.LuaApp.Components.Session["jest.config"],
		game.CoreGui.RobloxGui.Modules.AvatarExperience.AvatarRefinement.HeadRefinement["jest.config"]
	}
}
