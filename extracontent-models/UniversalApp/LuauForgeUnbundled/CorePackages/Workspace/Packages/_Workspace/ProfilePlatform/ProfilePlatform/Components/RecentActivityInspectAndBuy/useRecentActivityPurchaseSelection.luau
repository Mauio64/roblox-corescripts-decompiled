local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Dash")

require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Types")
local InspectAvatarUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/InspectAvatar/InspectAvatarUtils")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/sendProfilePurchaseEvents")

local FFlagProfileUnifiedPurchaseLogging = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfileUnifiedPurchaseLogging")

local isItemPurchasable = InspectAvatarUtils.isItemPurchasable
local getPriceStatus = InspectAvatarUtils.getPriceStatus
local priceStatusEnum = InspectAvatarUtils.PriceStatusEnum

local function useRecentActivityPurchaseSelection(list)
	local state, setState = React.useState({})
	local ref = React.useRef({})

	React.useEffect(function()
		if #list == 0 then
			return
		end

		local idSet = {}
		local v5 = false

		for k, item in list do
			local id = item.id

			if not isItemPurchasable(item) or ref.current[id] then
				continue
			end

			ref.current[id] = true
			idSet[id] = true
			v5 = true
		end

		if not v5 then
			return
		end

		setState(function(p2)
			return Dash.join(p2, idSet)
		end)
	end, { list })

	return {
		selectedItems = state,
		onToggleItem = React.useCallback(function(p2)
			setState(function(p3)
				return Dash.join(p3, {
					[p2] = not p3[p2]
				})
			end)
		end, {}),
		purchaseData = React.useMemo(function()
			local v5 = FFlagProfileUnifiedPurchaseLogging and {} or nil
			local v6 = {}
			local total = 0
			local count = 0

			for k, item in list do
				if not item.id then
					continue
				end

				local id = item.id

				if not (state[id] and isItemPurchasable(item)) then
					continue
				end

				local effectivePrice = InspectAvatarUtils.getEffectivePrice(item)
				local v7 = if getPriceStatus(item) == priceStatusEnum.PurchaseFromResale and item.collectibleItemDetails then item.collectibleItemDetails.collectibleLowestAvailableResaleProductId or item.collectibleProductId else item.collectibleProductId
				table.insert(v6, {
					collectibleProductId = v7,
					agreedPriceRobux = effectivePrice
				})

				if FFlagProfileUnifiedPurchaseLogging and v5 then
					table.insert(v5, {
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
				lineItems = v6,
				totalPrice = total,
				count = count,
				purchasedItems = v5
			}
		end, { list, state })
	}
end

return useRecentActivityPurchaseSelection
