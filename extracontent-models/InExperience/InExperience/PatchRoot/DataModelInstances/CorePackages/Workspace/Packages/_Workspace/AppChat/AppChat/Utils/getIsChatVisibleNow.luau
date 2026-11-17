local parent = script:FindFirstAncestor("AppChat").Parent

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3hMisc = SharedFlags.FFlagSignalsNavP3hMisc
local getLegacyNavigationStore

if FFlagSignalsNavP3hMisc then
	local NavigationRodux = require(parent.NavigationRodux)
	getLegacyNavigationStore = NavigationRodux.GetLegacyNavigationStore
else
	getLegacyNavigationStore = nil
end

local isNavigationAvailable

if FFlagSignalsNavP3hMisc then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	isNavigationAvailable = RobloxAppNavigation.isNavigationAvailable
else
	isNavigationAvailable = nil
end

local function isChatVisible(p): boolean -- 1 equivalent call inferred from this helper
	return not isNavigationAvailable() or getLegacyNavigationStore(false).getCurrentPageName(p) == AppPage.Chat
end

return {
	getIsChatVisibleNow = function()
		return isChatVisible(false) -- inferred equivalent call
	end,
	isChatVisible = isChatVisible
}
