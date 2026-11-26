local appPage = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/RobloxAppEnums").AppPage
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/NavigationRodux").Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RobloxAppNavigation").NavigationCommands else nil

local function openFiatPurchasePage(p2, onClose)
	return function(object)
		local v5 = {
			name = appPage.GenericWebPage,
			detail = p2,
			extraProps = {
				titleKey = "Feature.PaidAccessPurchases.Webview.Title.Checkout",
				onClose = onClose
			}
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v5))
		else
			object:dispatch(navigateDown(v5))
		end
	end
end

return openFiatPurchasePage
