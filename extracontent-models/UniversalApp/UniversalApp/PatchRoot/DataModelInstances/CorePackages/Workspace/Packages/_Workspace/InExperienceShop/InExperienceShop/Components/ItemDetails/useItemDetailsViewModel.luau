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
local useShopReportOverflow = require(InExperienceShop.Hooks.useShopReportOverflow)

require(InExperienceShop.Types)
require(script.Parent.ItemDetailsView)

local t1 = {
	product = "Feature.DeveloperProducts.Label.Product"
}

local function categoryLabelForType(p1, s1: string) -- line: 44
	if p1 == "GamePass" then
		return "Game pass"
	end

	return s1
end
local function useItemDetailsViewModel(t2: {[any]: any}) -- line: 51
	-- upvalues: useLocalization (copy), t1 (copy), SignalsReact (copy), getInExperienceShopStore (copy), React (copy), initiateShopItemPurchase (copy), SharedFlags (copy), AbuseVector (copy), useShopReportOverflow (copy), formatUpdatedDate (copy)
	local item = t2.item
	local v19 = useLocalization(t1)
	local v20 = SignalsReact.useSignalState(getInExperienceShopStore)
	local v21 = SignalsReact.useSignalState(function(p2) -- line: 61
		-- upvalues: v20 (copy), item (copy)
		return v20.getOwnership(p2)[item.id]
	end)

	React.useEffect(function() -- line: 69
		-- upvalues: item (copy), v20 (copy)
		if item.itemType == "GamePass" then
			v20.fetchGamePassOwnership(item.id)
		end
	end, {
		item.id,
		item.itemType,
		v20.fetchGamePassOwnership
	})

	local v22 = if v21 == nil then item.isOwned else v21
	local v23 = React.useCallback(function() -- line: 80
		-- upvalues: initiateShopItemPurchase (copy), item (copy)
		initiateShopItemPurchase(item.id, item.itemType)
	end, {
		item.id,
		item.itemType
	})
	local FFlagEnableReportingFlowForExperienceShop = SharedFlags.FFlagEnableReportingFlowForExperienceShop
	local v25 = React.useCallback(function() -- line: 86
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
	local v26 = useShopReportOverflow.useShopReportOverflow({
		isReportingEnabled = FFlagEnableReportingFlowForExperienceShop,
		buildReportSession = v25
	})
	local v27 = React.useMemo(function() -- line: 104
		-- upvalues: formatUpdatedDate (copy), item (copy)
		return formatUpdatedDate(item.updated)
	end, { item.updated })
	local itemType = item.itemType
	local product = v19.product
	local v30 = if itemType ~= "GamePass" then product else "Game pass"
	local v31, v32 = React.useState(false)
	local v33 = React.useCallback(function(p3) -- line: 112
		-- upvalues: v32 (copy)
		local AbsoluteSizeX = p3.AbsoluteSize.X

		if AbsoluteSizeX <= 0 then
			return
		end

		local v37 = AbsoluteSizeX < 480

		v32(function(p4) -- line: 118
			-- upvalues: v37 (copy)
			if p4 == v37 then
				return p4
			end

			return v37
		end)
	end, {})

	return {
		itemId = item.id,
		name = item.name,
		thumbnail = item.thumbnail,
		price = item.price,
		isOwned = v22,
		isBuyDisabled = t2.disableBuy == true,
		description = item.description,
		creator = item.creator,
		categoryLabel = v30,
		updated = v27,
		isCompact = v31,
		isOverflowMenuOpen = v26.isOverflowMenuOpen,
		isReportingEnabled = v26.isReportingEnabled,
		reportSession = v26.reportSession,
		onClose = t2.onClose,
		onBuyActivated = v23,
		onOverflowActivated = v26.onOverflowActivated,
		onOverflowMenuClosed = v26.onOverflowMenuClosed,
		onMenuItemActivated = v26.onMenuItemActivated,
		onReportClose = v26.onReportClose,
		onAbsoluteSizeChanged = v33
	}
end

return useItemDetailsViewModel
