local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")
local module2 = require("@luauforge/bundled/dMd")

local unifiedLoggingSurface = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.UnifiedLoggingSurface
local module3 = require("@luauforge/deferred/glr")
require("@luauforge/deferred/glL")
local module4 = require("@luauforge/deferred/glM")
local module5 = require("@luauforge/deferred/glN")
require("@luauforge/deferred/glI")
require("@luauforge/deferred/glO")

local module6 = require("@luauforge/bundled/fTi")

local itemTypeEnum = module2.Enums.ItemTypeEnum
local addUnifiedEventLogging = AvatarExperienceAnalytics.addUnifiedEventLogging
local marketplaceUnifiedAction = AvatarExperienceAnalytics.UnifiedEventLogEnums.MarketplaceUnifiedAction

local ITEM_DETAILS_DESCRIPTION_LINK = AvatarExperienceAnalytics.Enums.UnifiedLoggingElementNameEnums.ITEM_DETAILS_DESCRIPTION_LINK
local getMarketplaceUnifiedItemType = AvatarExperienceAnalytics.Utils.getMarketplaceUnifiedItemType

local v5 = {
	hasDeferredActions = false,
	sessionTagName = AvatarExperienceAnalytics.UnifiedEventLogConstants.L2_SESSION_TAG_NAME
}

local v6 = { kind = module5.Invalid, url = "" }

local function getLinkHandler(data, p2)
	if p2 == module4.OpenItem then
		return data.OpenItem
	end

	if p2 == module4.OpenCatalog then
		return data.OpenCatalog
	end

	if p2 == module4.OpenCommunity then
		return data.OpenCommunity
	end

	if p2 == module4.OpenCommunityStore then
		return data.OpenCommunityStore
	end

	return nil
end

local function getElementName(p2)
	if p2.kind == module5.Item then
		if p2.itemType == itemTypeEnum.Bundle then
			return ITEM_DETAILS_DESCRIPTION_LINK.Bundle
		end

		return ITEM_DETAILS_DESCRIPTION_LINK.Item
	end

	if p2.kind == module5.Community then
		return ITEM_DETAILS_DESCRIPTION_LINK.Community
	end

	if p2.kind == module5.CommunityStore then
		return ITEM_DETAILS_DESCRIPTION_LINK.CommunityStore
	end

	return ITEM_DETAILS_DESCRIPTION_LINK.CatalogSearch
end

local function useDescriptionLinkChipViewModel(data)
	local ref = React.useRef(nil)

	local v7 = React.useMemo(function()
		return module3.classifyDescriptionUrl(data.url)
	end, { data.url })
	local actions = data.actions
	local action = v7.action
	local v8

	if action == module4.OpenItem then
		v8 = actions.OpenItem
	elseif action == module4.OpenCatalog then
		v8 = actions.OpenCatalog
	elseif action == module4.OpenCommunity then
		v8 = actions.OpenCommunity
	else
		v8 = if action == module4.OpenCommunityStore then actions.OpenCommunityStore else nil
	end

	local describeDescriptionLink = module3.describeDescriptionLink
	local v9 = if v8 then v7 else v6
	local v10 = describeDescriptionLink(v9)
	local v11 = module6({ label = v10.labelKey })

	local v12 = React.useCallback(function()
		if v8 then
			v8(v7)
		end
	end, { v8, v7 })
	local v13

	if v8 then
		if v7.kind == module5.Item then
			if v7.itemType == itemTypeEnum.Bundle then
				v13 = ITEM_DETAILS_DESCRIPTION_LINK.Bundle
			else
				v13 = ITEM_DETAILS_DESCRIPTION_LINK.Item
			end
		elseif v7.kind == module5.Community then
			v13 = ITEM_DETAILS_DESCRIPTION_LINK.Community
		elseif v7.kind == module5.CommunityStore then
			v13 = ITEM_DETAILS_DESCRIPTION_LINK.CommunityStore
		else
			v13 = ITEM_DETAILS_DESCRIPTION_LINK.CatalogSearch
		end
	else
		v13 = nil
	end

	React.useEffect(function()
		if v13 and ref.current then
			addUnifiedEventLogging(ref, {
				action = marketplaceUnifiedAction.UI_ELEMENT_CLICK,
				elementName = v13,
				surface = unifiedLoggingSurface.ITEM_DETAILS,
				itemId = data.itemId,
				itemType = getMarketplaceUnifiedItemType(data.itemType)
			}, v5)
		end
	end, { v13, data.itemId, data.itemType })

	return {
		text = v11.label,
		icon = v10.icon,
		isInvalid = v8 == nil,
		onActivated = v12,
		LayoutOrder = data.LayoutOrder,
		ref = ref
	}
end

return useDescriptionLinkChipViewModel
