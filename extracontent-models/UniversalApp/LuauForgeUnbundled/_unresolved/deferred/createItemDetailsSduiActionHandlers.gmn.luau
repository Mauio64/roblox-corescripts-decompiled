local CorePackages = game:GetService("CorePackages")

local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local UIBlox = require(CorePackages.Packages.UIBlox)
local menuDirection = UIBlox.App.Menu.MenuDirection
local module = require("@luauforge/bundled/dPI")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local navigateDownToAvatarScreen = AvatarExperienceNavigation.Thunks.NavigateDownToAvatarScreen
local logOnOverlayClosed = AvatarExperienceNavigation.Debug.logOnOverlayClosed
local wasLastInputGamepad = require("@game/CorePackages/Workspace/Packages/RoactUtils").wasLastInputGamepad
require("@luauforge/deferred/gkq")
local module3 = require("@luauforge/bundled/dMx")
local module4 = require("@luauforge/bundled/dCp")

local module5 = require("@luauforge/deferred/gmo")

local fFlagAXFixPurchaseSurfaceLogging = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXFixPurchaseSurfaceLogging

local fFlagAXItemDetailsDescriptionLinks = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXItemDetailsDescriptionLinks

local function createItemDetailsSduiActionHandlers(data)
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

		local v7 = if fFlagAXFixPurchaseSurfaceLogging then navigation.getParam(module3.NavigationParams.fromSurface) else nil
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

		if data2.itemPosition ~= nil then
			data.sendRecommendedItemClickAnalytics(itemId, itemType, data2.itemPosition, param)
		end
	end

	local function openCatalogItemDetails(data2, p2)
		if data.maybePromptForR15Upgrade(data.getNavigation(), data2.itemId, data2.itemType, function()
			logOnOverlayClosed("ItemDetailsSdui", wasLastInputGamepad())
		end, function()
			navigateToItem(data2, p2)
		end, data2.itemSubType) then
			return
		end

		navigateToItem(data2, p2)
	end

	local function openItemInfoRowPrompt(data2)
		data.getNavigation().navigate(avatarScreen.ItemInfoRowPrompt, {
			screenSize = data.getScreenSize(),
			title = data2.title or RoactNavigation.None,
			message = data2.message or RoactNavigation.None,
			sections = data2.sections or RoactNavigation.None,
			confirmButtonText = "CommonUI.Controls.Action.OK"
		})
	end

	local function createTryOnHandlers(tryOn)
		return {
			toggleTryOn = function(data2)
				tryOn.toggleTryOn(data2.itemId, data2.itemType, data2.itemSubType)
			end,
			closeMatchingScreens = function(p2)
				tryOn.closeMatchingScreens(data.getNavigation(), p2)
			end,
			getShownItemSubType = tryOn.getShownItemSubType and function(p2, p3)
				local screenItem = data.getScreenItem()

				if screenItem.itemId == p2 and screenItem.itemType == p3 then
					return tryOn.getShownItemSubType()
				end

				return nil
			end or nil
		}
	end

	local function openCatalogItemCreatorProfile(p2, p3): boolean
		local detail = p2.detail

		if typeof(detail) ~= "string" or detail == "" then
			return false
		end

		data.getNavigation().navigate(module4.GenericWebPage, {
			detail = detail,
			extraProps = { titleKey = "CommonUI.Features.Label.Profile" }
		})

		return true
	end

	local function resolveCollectibleItemId(p2, p3, p4)
		if p4 ~= nil then
			return p4
		end

		local screenItem = data.getScreenItem()

		if screenItem.itemId == p2 and screenItem.itemType == p3 then
			return screenItem.collectibleItemId
		end

		return nil
	end

	local function openCatalogItemOwnership(data2)
		local navigate = data.getNavigation().navigate
		local itemOwnershipPage = avatarScreen.ItemOwnershipPage
		local v5 = { itemId = data2.itemId, collectibleItemId = 0, itemType = 0 }
		local itemId = data2.itemId
		local itemType = data2.itemType
		local collectibleItemId = data2.collectibleItemId

		if collectibleItemId == nil then
			local screenItem = data.getScreenItem()

			if screenItem.itemId == itemId and screenItem.itemType == itemType then
				collectibleItemId = screenItem.collectibleItemId
			else
				collectibleItemId = nil
			end
		end

		v5.collectibleItemId = collectibleItemId
		v5.itemType = data2.itemType
		navigate(itemOwnershipPage, v5)
	end

	local function openCatalogItemExperiences(p2): boolean
		local data2 = module.CollectibleItem.getCollectibleItemStore(false).getNormalizedCollectibleItemInfo(p2.collectibleItemId).data(false)
		local experiences = if data2 then data2.experiences else nil

		if data2 == nil or experiences == nil or #experiences == 0 then
			return false
		end

		data.getNavigation().navigate(avatarScreen.ItemExperiencesMenu, {
			collectibleData = {
				collectibleItemId = p2.collectibleItemId,
				experiences = experiences,
				unitsAvailableForConsumption = data2.unitsAvailableForConsumption,
				quantityLimitPerUser = data2.quantityLimitPerUser or 0
			},
			isLimited = p2.isLimited,
			openPositionY = UDim.new(0, 100),
			menuDirection = menuDirection.Down
		})

		return true
	end

	local function openCatalogItemResellers(data2)
		local navigation = data.getNavigation()
		local navigate = navigation.navigate
		local resellersPage = avatarScreen.ResellersPage
		local v5 = {
			itemId = data2.itemId,
			collectibleItemId = 0,
			itemType = 0,
			fromContentFeed = 0,
			fromProfile = 0
		}
		local itemId = data2.itemId
		local itemType = data2.itemType
		local collectibleItemId = data2.collectibleItemId

		if collectibleItemId == nil then
			local screenItem = data.getScreenItem()

			if screenItem.itemId == itemId and screenItem.itemType == itemType then
				collectibleItemId = screenItem.collectibleItemId
			else
				collectibleItemId = nil
			end
		end

		v5.collectibleItemId = collectibleItemId
		v5.itemType = data2.itemType
		v5.fromContentFeed = navigation.getParam("fromContentFeed")
		v5.fromProfile = navigation.getParam("fromProfile")
		navigate(resellersPage, v5)
	end

	if fFlagAXItemDetailsDescriptionLinks then
		openCatalogItemDetails = module5({
			getNavigation = data.getNavigation,
			getResultsListRef = data.getResultsListRef,
			sendRecommendedItemClickAnalytics = data.sendRecommendedItemClickAnalytics
		})
	end

	local itemDetailsSduiActionHandlers = {
		openCatalogItemDetails = openCatalogItemDetails,
		openItemInfoRowPrompt = openItemInfoRowPrompt,
		openCatalogItemCreatorProfile = openCatalogItemCreatorProfile,
		openCatalogItemOwnership = openCatalogItemOwnership,
		openCatalogItemExperiences = openCatalogItemExperiences,
		getCatalogItemAttributionPlay = data.getAttributionPlay,
		openCatalogItemResellers = openCatalogItemResellers,
		tryOnHandlers = 0,
		getScreenNavigation = 0,
		isInAvatarExperience = 0,
		isFocused = 0
	}

	local v5 = if data.tryOn then createTryOnHandlers(data.tryOn) else nil
	itemDetailsSduiActionHandlers.tryOnHandlers = v5
	itemDetailsSduiActionHandlers.getScreenNavigation = data.getNavigation
	itemDetailsSduiActionHandlers.isInAvatarExperience = data.isInAvatarExperience

	function itemDetailsSduiActionHandlers.isFocused()
		return data.getNavigation().isFocused()
	end
	return itemDetailsSduiActionHandlers
end

return createItemDetailsSduiActionHandlers
