local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local React = require(parent.React)
local Dash = require(parent.Dash)

require(ProfilePlatform.Common.Types)
local InspectAvatarUtils = require(ProfilePlatform.Components.InspectAvatar.InspectAvatarUtils)
require(ProfilePlatform.Analytics.sendProfilePurchaseEvents)

local FFlagProfileUnifiedPurchaseLogging = require(ProfilePlatform.Flags.FFlagProfileUnifiedPurchaseLogging)

local isItemPurchasable = InspectAvatarUtils.isItemPurchasable
local getPriceStatus = InspectAvatarUtils.getPriceStatus
local PriceStatusEnum = InspectAvatarUtils.PriceStatusEnum

local function useRecentActivityPurchaseSelection(list)
	local state, setState = React.useState({})
	local ref = React.useRef({})

	React.useEffect(function()
		if #list == 0 then
			return
		end

		local idSet = {}
		local v = false

		for _, item in list do
			local id = item.id

			if not isItemPurchasable(item) or ref.current[id] then
				continue
			end

			ref.current[id] = true
			idSet[id] = true
			v = true
		end

		if not v then
			return
		end

		setState(function(p)
			return Dash.join(p, idSet)
		end)
	end, { list })

	return {
		selectedItems = state,
		onToggleItem = React.useCallback(function(p: string)
			setState(function(p2)
				return Dash.join(p2, {
					[p] = not p2[p]
				})
			end)
		end, {}),
		purchaseData = React.useMemo(function()
			local purchasedItems = FFlagProfileUnifiedPurchaseLogging and {} or nil
			local lineItems = {}
			local total = 0
			local count = 0

			for _, item in list do
				if not item.id then
					continue
				end

				local id = item.id

				if not (state[id] and isItemPurchasable(item)) then
					continue
				end

				local effectivePrice = InspectAvatarUtils.getEffectivePrice(item)
				local collectibleProductId

				if getPriceStatus(item) == PriceStatusEnum.PurchaseFromResale and item.collectibleItemDetails then
					collectibleProductId = item.collectibleItemDetails.collectibleLowestAvailableResaleProductId
						or item.collectibleProductId
				else
					collectibleProductId = item.collectibleProductId
				end

				table.insert(lineItems, {
					collectibleProductId = collectibleProductId,
					agreedPriceRobux = effectivePrice
				})

				if FFlagProfileUnifiedPurchaseLogging and purchasedItems then
					table.insert(purchasedItems, {
						itemId = id,
						itemType = item.itemType,
						itemSubType = tonumber(item.itemSubType),
						priceInRobux = effectivePrice
					})
				end

				total += effectivePrice
				count += 1
			end

			return {
				lineItems = lineItems,
				totalPrice = total,
				count = count,
				purchasedItems = purchasedItems
			}
		end, { list, state })
	}
end

return useRecentActivityPurchaseSelection
