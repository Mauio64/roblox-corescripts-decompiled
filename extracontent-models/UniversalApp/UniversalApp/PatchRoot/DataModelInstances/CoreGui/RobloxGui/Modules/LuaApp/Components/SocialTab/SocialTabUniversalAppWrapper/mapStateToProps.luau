local Modules = script:FindFirstAncestor("Modules")
local CorePackages = game:GetService("CorePackages")
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local FFlagSignalsNavP3hMisc = SharedFlags.FFlagSignalsNavP3hMisc
local Selectors = require(CorePackages.Workspace.Packages.NavigationRodux).Selectors
local SocialTab = require(Modules.LuaApp.Components.SocialTab.SocialTab)
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor

return function(p1, _) -- line: 11
	-- upvalues: FFlagSignalsNavP3hMisc (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), SocialTab (copy), FormFactor (copy)
	local v11 = nil
	local v12 = nil

	if not FFlagSignalsNavP3hMisc then
		local v13 = if not FFlagUseNavigationSelectors then p1.Navigation.history else Selectors.selectLegacyHistory(p1)
		local v14 = v13[#v13]

		v11 = v14[#v14] and v14[#v14].name
		v12 = #v14 > 1
	end

	return {
		chatLoaded = p1.ChatAppReducer.AppLoaded,
		canGoBack = v12,
		retrievalStatus = SocialTab.Requests.FetchChatSettings.getStatus(p1),
		wideMode = p1.FormFactor == FormFactor.WIDE,
		notificationCount = p1.NotificationBadgeCounts.TopBarNotificationIcon,
		localUserId = p1.LocalUserId,
		currentAppPage = v11,
		bottomBarVisible = p1.TabBarVisible
	}
end
