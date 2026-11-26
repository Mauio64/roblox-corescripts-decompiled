local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local fFlagSignalsNavP3hMisc = SharedFlags.FFlagSignalsNavP3hMisc

local module2 = require("@luauforge/deferred/hGi")
local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Selectors

local formFactor = require("@luauforge/bundled/dGN").Enums.FormFactor

return function(data, p2)
	local v5, name

	if not fFlagSignalsNavP3hMisc then
		local v6

		if fFlagUseNavigationSelectors then
			v6 = selectors.selectLegacyHistory(data)
		else
			v6 = data.Navigation.history
		end

		local v7 = v6[#v6]
		name = v7[#v7] and v7[#v7].name
		v5 = #v7 > 1
	end

	local v7 = if not module2 then data.ChatAppReducer.AppLoaded else nil
	return {
		chatLoaded = v7,
		canGoBack = v5,
		wideMode = data.FormFactor == formFactor.WIDE,
		notificationCount = data.NotificationBadgeCounts.TopBarNotificationIcon,
		localUserId = data.LocalUserId,
		currentAppPage = name,
		bottomBarVisible = data.TabBarVisible
	}
end
