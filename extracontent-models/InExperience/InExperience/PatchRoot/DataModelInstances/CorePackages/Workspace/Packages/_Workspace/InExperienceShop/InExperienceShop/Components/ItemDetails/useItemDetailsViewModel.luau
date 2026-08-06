local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local InExperienceShopParent = InExperienceShop.Parent
local React = require(InExperienceShopParent.React)
local SignalsReact = require(InExperienceShopParent.SignalsReact)
local useLocalization = require(InExperienceShopParent.Localization).Hooks.useLocalization
local SharedFlags = require(InExperienceShopParent.SharedFlags)
local AbuseVector = require(InExperienceShopParent.GenericAbuseReporting.AbuseVector)
local initiateShopItemPurchase = require(InExperienceShop.initiateShopItemPurchase)
local formatUpdatedDate = require(InExperienceShop.Utils.formatUpdatedDate)
local getInExperienceShopStore = require(InExperienceShop.Stores.getInExperienceShopStore)
local v11 = if not SharedFlags.FFlagPassShopPurchaseSurfaceToBuyModal then nil else require(InExperienceShop.Analytics.Constants).ShopPageType
local useShopReportOverflow = require(InExperienceShop.Hooks.useShopReportOverflow)

require(InExperienceShop.Types)
require(script.Parent.ItemDetailsView)

local t1 = {
	product = "Feature.DeveloperProducts.Label.Product"
}

local function categoryLabelForType(p1, s1: string) -- line: 47
	if p1 == "GamePass" then
		return "Game pass"
	end

	return s1
end
local function useItemDetailsViewModel(t2: {[any]: any}) -- line: 54
	-- upvalues: useLocalization (copy), t1 (copy), SignalsReact (copy), getInExperienceShopStore (copy), React (copy), initiateShopItemPurchase (copy), v11 (copy), SharedFlags (copy), AbuseVector (copy), useShopReportOverflow (copy), formatUpdatedDate (copy)
	local item = t2.item
	local v20 = useLocalization(t1)
	local v21 = SignalsReact.useSignalState(getInExperienceShopStore)
	local v22 = SignalsReact.useSignalState(function(p2) -- line: 64
		-- upvalues: v21 (copy), item (copy)
		return v21.getOwnership(p2)[item.id]
	end)

	React.useEffect(function() -- line: 72
		-- upvalues: item (copy), v21 (copy)
		if item.itemType == "GamePass" then
			v21.fetchGamePassOwnership(item.id)
		end
	end, {
		item.id,
		item.itemType,
		v21.fetchGamePassOwnership
	})

	local v23 = if v22 == nil then item.isOwned else v22
	local v24 = React.useCallback(function() -- line: 83
		-- upvalues: initiateShopItemPurchase (copy), item (copy), v11 (copy)
		initiateShopItemPurchase(item.id, item.itemType, if not v11 then nil else v11.Category)
	end, {
		item.id,
		item.itemType
	})
	local FFlagEnableReportingFlowForExperienceShop = SharedFlags.FFlagEnableReportingFlowForExperienceShop
	local v26 = React.useCallback(function() -- line: 89
		-- upvalues: item (copy), AbuseVector (copy)
		if item.itemType == "GamePass" then
			return {
				abuseVector = AbuseVector.GamePass,
				targetId = item.id
			}
		end

		return {
			abuseVector = AbuseVector.DeveloperProduct,
			targetId = item.id
		}
	end, {
		item.id,
		item.itemType
	})
	local v27 = useShopReportOverflow.useShopReportOverflow({
		isReportingEnabled = FFlagEnableReportingFlowForExperienceShop,
		buildReportSession = v26
	})
	local v28 = React.useMemo(function() -- line: 107
		-- upvalues: formatUpdatedDate (copy), item (copy)
		return formatUpdatedDate(item.updated)
	end, { item.updated })
	local itemType = item.itemType
	local product = v20.product
	local v31 = if itemType ~= "GamePass" then product else "Game pass"
	local v32, v33 = React.useState(false)
	local v34 = React.useCallback(function(p3) -- line: 115
		-- upvalues: v33 (copy)
		local AbsoluteSizeX = p3.AbsoluteSize.X

		if AbsoluteSizeX <= 0 then
			return
		end

		local v38 = AbsoluteSizeX < 480

		v33(function(p4) -- line: 121
			-- upvalues: v38 (copy)
			if p4 == v38 then
				return p4
			end

			return v38
		end)
	end, {})

	return {
		itemId = item.id,
		name = item.name,
		thumbnail = item.thumbnail,
		price = item.price,
		isOwned = v23,
		isBuyDisabled = t2.disableBuy == true,
		description = item.description,
		creator = item.creator,
		categoryLabel = v31,
		updated = v28,
		isCompact = v32,
		isOverflowMenuOpen = v27.isOverflowMenuOpen,
		isReportingEnabled = v27.isReportingEnabled,
		reportSession = v27.reportSession,
		onClose = t2.onClose,
		onBuyActivated = v24,
		onOverflowActivated = v27.onOverflowActivated,
		onOverflowMenuClosed = v27.onOverflowMenuClosed,
		onMenuItemActivated = v27.onMenuItemActivated,
		onReportClose = v27.onReportClose,
		onAbsoluteSizeChanged = v34
	}
end

return useItemDetailsViewModel
