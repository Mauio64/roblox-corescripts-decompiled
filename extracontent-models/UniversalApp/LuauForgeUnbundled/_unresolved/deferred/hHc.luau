local HttpService = game:GetService("HttpService")
local SessionService = game:GetService("SessionService")

local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
require("@luauforge/deferred/hGN")
local sessionType = require("@luauforge/bundled/fwa").SessionType
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")

local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local unifiedLoggingSurface = AvatarExperienceNavigation.Enums.UnifiedLoggingSurface
local navigateDownToAvatarScreen = AvatarExperienceNavigation.Thunks.NavigateDownToAvatarScreen
local sendUnifiedEventLog = AvatarExperienceAnalytics.sendUnifiedEventLog
local marketplaceUnifiedAction = AvatarExperienceAnalytics.UnifiedEventLogEnums.MarketplaceUnifiedAction
local marketplaceUnifiedItemType = AvatarExperienceAnalytics.UnifiedEventLogEnums.MarketplaceUnifiedItemType
local unifiedLoggingElementNameEnums = AvatarExperienceAnalytics.Enums.UnifiedLoggingElementNameEnums
local fFlagAXEnableUnifiedLoggingAvatarMoment = SharedFlags.FFlagAXEnableUnifiedLoggingAvatarMoment

local level2a = sessionType.StructuralIdentifier.Level2a

local moments = sessionType.Tag.Level2a.Moments

local function buildShopMetadata(options)
	local v5 = options or {}
	local shopMetadata = {
		feedItemId = v5.feedItemId,
		feedSessionId = v5.feedSessionId,
		outfitId = 0,
		watchId = 0
	}
	local v6 = if v5.outfitId ~= nil then tostring(v5.outfitId) else nil
	shopMetadata.outfitId = v6
	local v7 = if SessionService:GetSessionTag(level2a) == moments then SessionService:GetSessionID(level2a) else nil
	shopMetadata.watchId = v7
	return shopMetadata
end

return function(p2, p3)
	local v5 = {
		itemId = p2,
		itemType = "Look",
		fromMoments = true,
		mountAsFullView = false,
		mountAnimation = true,
		showRobuxBalance = true,
		showDropDownTopBar = true,
		hideTab = true,
		shouldNavigateDown = true
	}

	if not fFlagAXEnableUnifiedLoggingAvatarMoment then
		return navigateDownToAvatarScreen(avatarScreen.TryOnItem, "Look" .. p2, v5)
	end

	local shopMetadata = buildShopMetadata(p3)
	v5.fromSurface = unifiedLoggingSurface.SHOP_AVATAR_MOMENT
	v5.shopMetadata = shopMetadata

	return function(object)
		sendUnifiedEventLog({
			action = marketplaceUnifiedAction.UI_ELEMENT_CLICK,
			surface = unifiedLoggingSurface.SHOP_AVATAR_MOMENT,
			itemId = p2,
			itemType = marketplaceUnifiedItemType.LOOK,
			elementName = unifiedLoggingElementNameEnums.AVATAR_MOMENTS.MOMENT_SHOP,
			elementMetadata = HttpService:JSONEncode(shopMetadata)
		})

		return object:dispatch(navigateDownToAvatarScreen(avatarScreen.TryOnItem, "Look" .. p2, v5))
	end
end
