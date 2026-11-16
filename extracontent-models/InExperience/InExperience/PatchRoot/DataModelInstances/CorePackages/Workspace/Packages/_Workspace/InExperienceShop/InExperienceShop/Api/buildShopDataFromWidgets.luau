local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local Promise = require(parent.Promise)
local SharedFlags = require(parent.SharedFlags)
local Constants = require(InExperienceShop.Constants)
require(InExperienceShop.Types)
local FFlagEnableRobuxInExperienceShop = SharedFlags.FFlagEnableRobuxInExperienceShop
local FFlagEnableBonusJwtInShop = SharedFlags.FFlagEnableBonusJwtInShop
require(script.Parent.multiGetProductInfo)
local parseGamePassTrialAvailabilities = require(script.Parent.parseGamePassTrialAvailabilities)
local shopItemMapping = require(script.Parent.shopItemMapping)
local robuxWidgetMapping = require(script.Parent.robuxWidgetMapping)
local hydrateRobuxBonusItems = require(script.Parent.hydrateRobuxBonusItems)
local toRobuxPackageItem = robuxWidgetMapping.toRobuxPackageItem
local appendBonusItemRequests = hydrateRobuxBonusItems.appendBonusItemRequests
local mergeBonusItemDetailsIntoSections = hydrateRobuxBonusItems.mergeBonusItemDetailsIntoSections
local makeRequestKey = shopItemMapping.makeRequestKey
local toShopItem = shopItemMapping.toShopItem
local logCounter = require(InExperienceShop.Internal.logCounter)
local ProductInfoFailedItemsCounter = require(InExperienceShop.Events.ProductInfoFailedItemsCounter)

local FFlagEnableExperienceShopGlobalIcon = require(InExperienceShop.Flags.FFlagEnableExperienceShopGlobalIcon)
local FFlagIdentifyTopPicksByCategoryType = require(InExperienceShop.Flags.FFlagIdentifyTopPicksByCategoryType)
local FFlagParseStableCategoryId = require(InExperienceShop.Flags.FFlagParseStableCategoryId)
local FFlagLuaAppEnableGamePassFreeTrials = require(InExperienceShop.Flags.FFlagLuaAppEnableGamePassFreeTrials)

local defineFastString = game:DefineFastString("FreeTrialTopBarChipSettingName", "FreeTrialTopBarChip")

local function isNotificationSettingEnabled(isEnabled) -- 1 equivalent call inferred from this helper
	if typeof(isEnabled) == "boolean" then
		return isEnabled
	end

	return typeof(isEnabled) == "string" and isEnabled == "true"
end

local function readFreeTrialTopBarChipFromNotificationSettings(data)
	local notificationSettings = data.notificationSettings

	if notificationSettings == nil then
		return false
	end

	for _, notificationSetting in ipairs(notificationSettings) do
		if notificationSetting.name == defineFastString then
			return isNotificationSettingEnabled(notificationSetting.isEnabled) -- inferred equivalent call
		end
	end

	return false
end

local v = { id = Constants.HOME_CATEGORY_ID, name = "CommonUI.Features.Label.Home" }

local function buildShopDataFromWidgets(data, callback)
	local v2 = { v }
	local v3 = {}
	local v4 = {}

	local v5 = {}

	local set = {}
	local gamePassTrialAvailabilities

	if FFlagLuaAppEnableGamePassFreeTrials and typeof(data.gamePassTrialAvailabilities) == "table" then
		gamePassTrialAvailabilities = parseGamePassTrialAvailabilities(data.gamePassTrialAvailabilities)
	else
		gamePassTrialAvailabilities = nil
	end

	for _, category in ipairs(data.categories) do
		if Constants.BLACKLISTED_CATEGORY_NAMES[string.lower(category.name)] then
			continue
		end

		local id = tostring(category.id)
		table.insert(v2, { id = id, name = category.name })

		local categoryIndex = #v3 + 1
		local v6 = { id = id, name = category.name, items = {} }

		local metadata = category.metadata

		if FFlagIdentifyTopPicksByCategoryType and metadata ~= nil and metadata.categoryType ~= nil then
			v6.categoryType = metadata.categoryType
		end

		if FFlagParseStableCategoryId and metadata ~= nil and metadata.categoryId ~= nil then
			v6.stableCategoryId = metadata.categoryId
		end

		if FFlagParseStableCategoryId and metadata ~= nil and metadata.categoryGroup ~= nil then
			v6.categoryGroup = metadata.categoryGroup
		end

		if FFlagEnableRobuxInExperienceShop and metadata ~= nil and metadata.paymentSessionId ~= nil then
			v6.paymentSessionId = metadata.paymentSessionId
		end

		if FFlagEnableBonusJwtInShop and metadata ~= nil and metadata.bonusJwt ~= nil then
			v6.bonusJwt = metadata.bonusJwt
		end

		v3[categoryIndex] = v6
		local count = 0

		for _, item in ipairs(category.items) do
			local kind = item.type
			local infoType

			if kind == "Product" then
				infoType = Enum.InfoType.Product
			elseif kind == "GamePass" then
				infoType = Enum.InfoType.GamePass
			else
				if kind ~= "Robux" or not FFlagEnableRobuxInExperienceShop then
					continue
				end

				local v7 = toRobuxPackageItem(item)

				if v7 == nil then
					continue
				end

				if v6.robuxPackages == nil then
					v6.robuxPackages = {}
				end

				local robuxPackages = v6.robuxPackages

				if #robuxPackages == 0 then
					v7.isPrimaryRobuxPackage = true
				end

				table.insert(robuxPackages, v7)
				continue
			end

			count += 1
			set[categoryIndex] = true
			table.insert(v4, { id = item.id, infoType = infoType })

			table.insert(v5, {
				categoryIndex = categoryIndex,
				sectionId = id,
				itemType = kind,
				sectionItemIndex = count
			})
		end
	end

	local function filterOutput(list)
		local result = {}
		local idSet = {}

		for i, item in ipairs(list) do
			if not (set[i] or item.robuxPackages ~= nil and #item.robuxPackages > 0) then
				continue
			end

			table.insert(result, item)
			idSet[item.id] = true
		end

		local result2 = {}

		for _, v6 in ipairs(v2) do
			if v6.id == Constants.HOME_CATEGORY_ID or idSet[v6.id] then
				table.insert(result2, v6)
			end
		end

		return result2, result
	end

	if callback == nil then
		local failedItems = table.create(#v4)

		for i, v6 in ipairs(v4) do
			local v7 = v5[i]
			failedItems[i] = {
				id = v6.id,
				infoType = v6.infoType,
				itemType = v7.itemType,
				sectionId = v7.sectionId,
				originalIndex = v7.sectionItemIndex
			}
		end

		local categories, sections = filterOutput(v3)
		local resolve = Promise.resolve
		local metadata

		if FFlagEnableExperienceShopGlobalIcon then
			metadata = data.metadata
		end

		return resolve({
			categories = categories,
			sections = sections,
			failedItems = failedItems,
			metadata = metadata,
			notificationFreeTrialTopBarChip = readFreeTrialTopBarChipFromNotificationSettings(data),
			gamePassTrialAvailabilities = gamePassTrialAvailabilities
		})
	else
		local count = #v4

		if FFlagEnableRobuxInExperienceShop then
			appendBonusItemRequests(v4, v3)
		end

		return callback(v4):andThen(function(list)
			local v6 = {}

			for _, item in ipairs(list) do
				v6[makeRequestKey(item.request.id, item.request.infoType)] = item
			end

			local failedItems = {}

			for i = 1, count do
				local v7 = v4[i]

				local v8 = v5[i]
				local v9 = v6[makeRequestKey(v7.id, v7.infoType)]

				if v9 == nil or not v9.ok then
					table.insert(failedItems, {
						id = v7.id,
						infoType = v7.infoType,
						itemType = v8.itemType,
						sectionId = v8.sectionId,
						originalIndex = v8.sectionItemIndex
					})
				else
					local v10 = v3[v8.categoryIndex]

					local v11 = toShopItem(v9.value, v8.itemType, v7.id)
					v11.originalIndex = v8.sectionItemIndex
					table.insert(v10.items, v11)
				end
			end

			if #failedItems > 0 then
				logCounter(ProductInfoFailedItemsCounter, #failedItems)
			end

			local v7 = v3

			if FFlagEnableRobuxInExperienceShop then
				v7 = mergeBonusItemDetailsIntoSections(v3, list)
			end

			local categories, sections = filterOutput(v7)
			local metadata

			if FFlagEnableExperienceShopGlobalIcon then
				metadata = data.metadata
			end

			return {
				categories = categories,
				sections = sections,
				failedItems = failedItems,
				metadata = metadata,
				notificationFreeTrialTopBarChip = readFreeTrialTopBarChipFromNotificationSettings(data),
				gamePassTrialAvailabilities = gamePassTrialAvailabilities
			}
		end)
	end
end

return buildShopDataFromWidgets
