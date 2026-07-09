local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local NavigateDownToAvatarScreen = require(Modules.AvatarExperience.Common.Components.RoactNavigation.AppRouterWrapper.NavigateDownToAvatarScreen)
local api = require(Modules.LuaApp.Components.ProfileQRCodePage.api)
local ProfileQRCodeUniversalAppWrapper = require(Modules.LuaApp.Components.ProfileQRCodePage.ProfileQRCodeUniversalAppWrapper)
local TitleKey = api.TitleKey
local Cryo = require(CorePackages.Packages.Cryo)
local FullscreenPageWithSafeArea = require(Modules.LuaApp.Components.FullscreenPageWithSafeArea)

return function(t1: {[any]: any}) -- line: 16
	-- upvalues: React (copy), FullscreenPageWithSafeArea (copy), ProfileQRCodeUniversalAppWrapper (copy), Cryo (copy), TitleKey (copy), NavigateDownToAvatarScreen (copy), AvatarScreen (copy)
	local t2 = {
		playEmote = true,
		isTopBarVisible = false,
		renderContent = function(p1) -- line: 22
			-- upvalues: React (copy), FullscreenPageWithSafeArea (copy), ProfileQRCodeUniversalAppWrapper (copy), Cryo (copy), t1 (copy)
			return React.createElement(FullscreenPageWithSafeArea, {
				includeStatusBar = true,
				BackgroundTransparency = 1
			}, {
				QRCode = React.createElement(ProfileQRCodeUniversalAppWrapper, Cryo.Dictionary.join(t1, p1))
			})
		end,
		title = TitleKey
	}

	return NavigateDownToAvatarScreen(AvatarScreen.AvatarBackground, "QRCode", t2)
end
