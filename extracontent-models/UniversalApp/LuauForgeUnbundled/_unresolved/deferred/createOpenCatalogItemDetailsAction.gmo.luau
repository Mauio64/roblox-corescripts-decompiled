local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local navigateDownToAvatarScreen = AvatarExperienceNavigation.Thunks.NavigateDownToAvatarScreen
local logOnOverlayClosed = AvatarExperienceNavigation.Debug.logOnOverlayClosed
local wasLastInputGamepad = require("@game/CorePackages/Workspace/Packages/RoactUtils").wasLastInputGamepad
require("@luauforge/deferred/gkq")
local module2 = require("@luauforge/bundled/dMx")
local module3 = require("@luauforge/deferred/gkR")

local fFlagAXFixPurchaseSurfaceLogging = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXFixPurchaseSurfaceLogging

local function createOpenCatalogItemDetailsAction(data)
	local function navigateToItem(data2, callback)
		local navigation = data.getNavigation()
		local itemId = data2.itemId
		local itemType = data2.itemType
		local v5 = itemType .. itemId

		local param = navigation.getParam("fromProfile")

		if typeof(param) ~= "boolean" then
			param = nil
		end

		local v6 = {
			itemId = itemId,
			itemType = itemType,
			itemSubType = data2.itemSubType,
			mountAsFullView = true,
			mountAnimation = false,
			resultsListRef = data.getResultsListRef(),
			isFirstItemDetails = false,
			fromProfile = param,
			showFullWithNoPeekView = navigation.getParam("showFullWithNoPeekView"),
			fromSurface = 0
		}

		local v7 = if fFlagAXFixPurchaseSurfaceLogging then navigation.getParam(module2.NavigationParams.fromSurface) else nil
		v6.fromSurface = v7

		if param then
			callback(navigateDownToAvatarScreen(avatarScreen.ItemDetails, v5, v6))
		elseif navigation.getParam("shouldNavigateDown") then
			v6.mountAnimation = navigation.getParam("mountAnimation")
			v6.showRobuxBalance = navigation.getParam("showRobuxBalance")
			v6.showDropDownTopBar = navigation.getParam("showDropDownTopBar")
			v6.shouldNavigateDown = navigation.getParam("shouldNavigateDown")
			v6.hideTab = navigation.getParam("hideTab")
			v6.simpleView = navigation.getParam("simpleView")
			callback(navigateDownToAvatarScreen(navigation.state.routeName, v5, v6))
		else
			navigation.push(avatarScreen.ItemDetails, v6)
		end

		local sendRecommendedItemClickAnalytics = data.sendRecommendedItemClickAnalytics

		if sendRecommendedItemClickAnalytics and data2.itemPosition ~= nil then
			sendRecommendedItemClickAnalytics(itemId, itemType, data2.itemPosition, param)
		end
	end

	return function(data2, callback)
		if callback((module3(data.getNavigation(), data2.itemId, data2.itemType, function()
			logOnOverlayClosed("ItemDetailsOpenItem", wasLastInputGamepad())
		end, function()
			navigateToItem(data2, callback)
		end, false, data2.itemSubType))) then
			return
		end

		navigateToItem(data2, callback)
	end
end

return createOpenCatalogItemDetailsAction
