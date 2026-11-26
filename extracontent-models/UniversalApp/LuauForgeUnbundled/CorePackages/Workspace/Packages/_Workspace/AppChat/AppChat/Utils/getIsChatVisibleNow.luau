local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxAppEnums").AppPage
local fFlagSignalsNavP3hMisc = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagSignalsNavP3hMisc
local getLegacyNavigationStore

if fFlagSignalsNavP3hMisc then
	getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/NavigationRodux").GetLegacyNavigationStore
else
	getLegacyNavigationStore = nil
end

local isNavigationAvailable

if fFlagSignalsNavP3hMisc then
	isNavigationAvailable = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxAppNavigation").isNavigationAvailable
else
	isNavigationAvailable = nil
end

return {
	getIsChatVisibleNow = function(): boolean
		if isNavigationAvailable() then
			return getLegacyNavigationStore(false).getCurrentPageName(false) == appPage.Chat
		end

		return true
	end,
	isChatVisible = function(p2): boolean
		if isNavigationAvailable() then
			return getLegacyNavigationStore(false).getCurrentPageName(p2) == appPage.Chat
		end

		return true
	end
}
