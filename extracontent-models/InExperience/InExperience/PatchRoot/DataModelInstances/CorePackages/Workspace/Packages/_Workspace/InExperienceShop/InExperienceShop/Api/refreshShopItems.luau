local InExperienceShop = script:FindFirstAncestor("InExperienceShop")

require(InExperienceShop.Types)
require(script.Parent.multiGetProductInfo)
local shopItemMapping = require(script.Parent.shopItemMapping)

local makeRequestKey = shopItemMapping.makeRequestKey
local toShopItem = shopItemMapping.toShopItem

local function infoTypeForShopItemType(itemType) -- 2 equivalent calls inferred from this helper
	if itemType == "Product" then
		return Enum.InfoType.Product
	elseif itemType == "GamePass" then
		return Enum.InfoType.GamePass
	end

	return nil
end

local function refreshShopItemFromProductInfo(item, value)
	local v = toShopItem(value, item.itemType, (tonumber(item.id)))
	return {
		id = item.id,
		itemType = item.itemType,
		isOwned = item.isOwned,
		creator = v.creator or item.creator,
		universeId = item.universeId,
		originalIndex = item.originalIndex,
		name = v.name,
		thumbnail = v.thumbnail,
		price = v.price,
		userBasePriceInRobux = v.userBasePriceInRobux,
		description = v.description,
		updated = v.updated
	}
end

local RefreshShopItems = {}
RefreshShopItems.infoTypeForShopItemType = infoTypeForShopItemType

function RefreshShopItems.buildRequestsFromSections(list)
	local requestKeySet = {}
	local requestsFromSections = {}

	for _, item in ipairs(list) do
		for _, item2 in ipairs(item.items) do
			local infoType = infoTypeForShopItemType(item2.itemType) -- inferred equivalent call

			if infoType == nil then
				continue
			end

			local id = tonumber(item2.id)

			if id == nil then
				continue
			end

			local requestKey = makeRequestKey(id, infoType)

			if requestKeySet[requestKey] then
				continue
			end

			requestKeySet[requestKey] = true
			table.insert(requestsFromSections, { id = id, infoType = infoType })
		end
	end

	return requestsFromSections
end

function RefreshShopItems.appendFailedItemRequests(list, list2)
	local set = {}

	for _, item in ipairs(list) do
		set[makeRequestKey(item.id, item.infoType)] = true
	end

	for _, item in ipairs(list2) do
		local requestKey = makeRequestKey(item.id, item.infoType)

		if set[requestKey] then
			continue
		end

		set[requestKey] = true
		table.insert(list, { id = item.id, infoType = item.infoType })
	end

	return list
end

RefreshShopItems.refreshShopItemFromProductInfo = refreshShopItemFromProductInfo

function RefreshShopItems.mergeProductInfoIntoSections(list, list2)
	local v = {}

	for _, item in ipairs(list2) do
		v[makeRequestKey(item.request.id, item.request.infoType)] = item
	end

	local result = table.create(#list)

	for i, item in ipairs(list) do
		local items = nil

		for j, item2 in ipairs(item.items) do
			local v2 = infoTypeForShopItemType(item2.itemType) -- inferred equivalent call
			local id = tonumber(item2.id)
			local v3

			if not (v2 == nil or id == nil) then
				v3 = v[makeRequestKey(id, v2)]
			end

			if v3 == nil or not v3.ok then
				if items ~= nil then
					items[j] = item2
				end
			else
				if items == nil then
					items = table.create(#item.items)

					for k = 1, j - 1 do
						items[k] = item.items[k]
					end
				end

				items[j] = refreshShopItemFromProductInfo(item2, v3.value)
			end
		end

		if items == nil then
			result[i] = item
		else
			result[i] = {
				id = item.id,
				name = item.name,
				items = items,
				categoryType = item.categoryType,
				stableCategoryId = item.stableCategoryId,
				categoryGroup = item.categoryGroup,
				paymentSessionId = item.paymentSessionId,
				bonusJwt = item.bonusJwt,
				robuxPackages = item.robuxPackages
			}
		end
	end

	return result
end

function RefreshShopItems.insertRecoveredItemsIntoSections(list, list2, list3)
	local v = {}

	for _, item in ipairs(list2) do
		v[makeRequestKey(item.request.id, item.request.infoType)] = item
	end

	local result = {}
	local v2 = {}

	for _, item in ipairs(list3) do
		local v3 = v[makeRequestKey(item.id, item.infoType)]

		if v3 == nil or not v3.ok then
			table.insert(result, item)
		else
			local v4 = v2[item.sectionId]

			if v4 == nil then
				v4 = {}
				v2[item.sectionId] = v4
			end

			local v5 = toShopItem(v3.value, item.itemType, item.id)
			v5.originalIndex = item.originalIndex
			table.insert(v4, v5)
		end
	end

	local result2 = table.create(#list)

	for i, item in ipairs(list) do
		local v3 = v2[item.id]

		if v3 == nil then
			result2[i] = item
		else
			table.sort(v3, function(a, b): boolean
				return (a.originalIndex or 0) < (b.originalIndex or 0)
			end)

			local items = table.create(#item.items + #v3)
			local v4 = 1
			local v5 = 1

			while v4 <= #item.items or v5 <= #v3 do
				local item2 = item.items[v4]
				local v6 = v3[v5]

				if v6 == nil then
					table.insert(items, item2)
					v4 += 1
				elseif item2 == nil then
					table.insert(items, v6)
					v5 += 1
				elseif (item2.originalIndex or 0) <= (v6.originalIndex or 0) then
					table.insert(items, item2)
					v4 += 1
				else
					table.insert(items, v6)
					v5 += 1
				end
			end

			result2[i] = {
				id = item.id,
				name = item.name,
				items = items,
				categoryType = item.categoryType,
				stableCategoryId = item.stableCategoryId,
				categoryGroup = item.categoryGroup,
				paymentSessionId = item.paymentSessionId,
				bonusJwt = item.bonusJwt,
				robuxPackages = item.robuxPackages
			}
		end
	end

	return result2, result
end

return RefreshShopItems
