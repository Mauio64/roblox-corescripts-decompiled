local InExperienceShop = script:FindFirstAncestor("InExperienceShop")

require(InExperienceShop.Types)
require(script.Parent.multiGetProductInfo)
local shopItemMapping = require(script.Parent.shopItemMapping)

local makeRequestKey = shopItemMapping.makeRequestKey
local toShopItem = shopItemMapping.toShopItem

local GamePass = Enum.InfoType.GamePass
local HydrateRobuxBonusItems = {}

function HydrateRobuxBonusItems.appendBonusItemRequests(list, list2)
	local set = {}

	for _, item in ipairs(list) do
		set[makeRequestKey(item.id, item.infoType)] = true
	end

	for _, item in ipairs(list2) do
		local robuxPackages = item.robuxPackages

		if robuxPackages == nil then
			continue
		end

		for _, robuxPackage in robuxPackages do
			local bonusItem = robuxPackage.bonusItem

			if not (bonusItem ~= nil and bonusItem.type == "GamePass") then
				continue
			end

			local requestKey = makeRequestKey(bonusItem.id, GamePass)

			if set[requestKey] then
				continue
			end

			set[requestKey] = true
			table.insert(list, { id = bonusItem.id, infoType = GamePass })
		end
	end

	return list
end

function HydrateRobuxBonusItems.mergeBonusItemDetailsIntoSections(list, list2)
	local v = {}

	for _, item in ipairs(list2) do
		v[makeRequestKey(item.request.id, item.request.infoType)] = item
	end

	local result = table.create(#list)

	for i, item in ipairs(list) do
		local robuxPackages = item.robuxPackages

		if robuxPackages == nil or #robuxPackages == 0 then
			result[i] = item
		else
			local robuxPackages2 = nil

			for j, robuxPackage in ipairs(robuxPackages) do
				local bonusItem = robuxPackage.bonusItem

				if bonusItem == nil then
					if robuxPackages2 ~= nil then
						robuxPackages2[j] = robuxPackage
					end
				else
					local v2 = v[makeRequestKey(bonusItem.id, GamePass)]

					if v2 == nil or not v2.ok then
						if robuxPackages2 ~= nil then
							robuxPackages2[j] = robuxPackage
						end
					else
						if robuxPackages2 == nil then
							robuxPackages2 = table.create(#robuxPackages)

							for k = 1, j - 1 do
								robuxPackages2[k] = robuxPackages[k]
							end
						end

						robuxPackages2[j] = {
							id = robuxPackage.id,
							robuxAmount = robuxPackage.robuxAmount,
							currencyAmountStr = robuxPackage.currencyAmountStr,
							robuxImage = robuxPackage.robuxImage,
							productId = robuxPackage.productId,
							mobileProductId = robuxPackage.mobileProductId,
							bonusItem = robuxPackage.bonusItem,
							bonusItemDetails = toShopItem(v2.value, "GamePass", bonusItem.id),
							isPrimaryRobuxPackage = robuxPackage.isPrimaryRobuxPackage
						}
					end
				end
			end

			if robuxPackages2 == nil then
				result[i] = item
			else
				for j = #robuxPackages2 + 1, #robuxPackages do
					robuxPackages2[j] = robuxPackages[j]
				end

				result[i] = {
					id = item.id,
					name = item.name,
					items = item.items,
					categoryType = item.categoryType,
					stableCategoryId = item.stableCategoryId,
					categoryGroup = item.categoryGroup,
					paymentSessionId = item.paymentSessionId,
					bonusJwt = item.bonusJwt,
					robuxPackages = robuxPackages2
				}
			end
		end
	end

	return result
end

return HydrateRobuxBonusItems
