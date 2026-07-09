local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local InExperienceShopParent = InExperienceShop.Parent
local Promise = require(InExperienceShopParent.Promise)
local SharedFlags = require(InExperienceShopParent.SharedFlags)
local Constants = require(InExperienceShop.Constants)

require(InExperienceShop.Types)

local FFlagEnableRobuxInExperienceShop = SharedFlags.FFlagEnableRobuxInExperienceShop

require(script.Parent.multiGetProductInfo)

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
local t1 = {
	name = "CommonUI.Features.Label.Home",
	id = Constants.HOME_CATEGORY_ID
}

local function buildShopDataFromWidgets(p1, p2: ((...any) -> ...any)?) -- line: 89
	-- upvalues: t1 (copy), Constants (copy), FFlagEnableRobuxInExperienceShop (copy), toRobuxPackageItem (copy), Promise (copy), FFlagEnableExperienceShopGlobalIcon (copy), appendBonusItemRequests (copy), makeRequestKey (copy), toShopItem (copy), logCounter (copy), ProductInfoFailedItemsCounter (copy), mergeBonusItemDetailsIntoSections (copy)
	local t2 = { t1 }
	local t3 = {}
	local t4 = {}
	local t5 = {}
	local t6 = {}
	local g38 = nil
	local Product = nil

	for _, v in ipairs(p1.categories) do
		if not Constants.BLACKLISTED_CATEGORY_NAMES[string.lower(v.name)] then
			local str = tostring(v.id)

			table.insert(t2, {
				id = str,
				name = v.name
			})

			local v30 = #t3 + 1
			local t7 = {
				id = str,
				name = v.name,
				items = {}
			}
			local metadata = v.metadata

			if FFlagEnableRobuxInExperienceShop and metadata ~= nil and metadata.paymentSessionId ~= nil then
				t7.paymentSessionId = metadata.paymentSessionId
			end

			t3[v30] = t7

			local n1 = 0

			for _, v2 in ipairs(v.items) do
				local type = v2.type

				if type == "Product" then
					Product = Enum.InfoType.Product
					g38 = true
				end

				if g38 or type == "GamePass" then
					if not g38 then
						Product = Enum.InfoType.GamePass
					end

					g38 = false
					n1 += 1
					t6[v30] = true
					table.insert(t4, {
						id = v2.id,
						infoType = Product
					})
					table.insert(t5, {
						categoryIndex = v30,
						sectionId = str,
						itemType = type,
						sectionItemIndex = n1
					})

					continue
				end

				if type == "Robux" and FFlagEnableRobuxInExperienceShop then
					local v39 = toRobuxPackageItem(v2)

					if v39 ~= nil then
						if t7.robuxPackages == nil then
							t7.robuxPackages = {}
						end

						local robuxPackages = t7.robuxPackages

						if #robuxPackages == 0 then
							v39.isPrimaryRobuxPackage = true
						end

						table.insert(robuxPackages, v39)
					end
				end
			end
		end
	end

	local function filterOutput(t8: {[any]: any}) -- line: 200
		-- upvalues: t6 (copy), t2 (copy), Constants (copy)
		local t9 = {}
		local t10 = {}

		for i, v in ipairs(t8) do
			if t6[i] or v.robuxPackages ~= nil and #v.robuxPackages > 0 then
				table.insert(t9, v)
				t10[v.id] = true
			end
		end

		local t11 = {}

		for _, v in ipairs(t2) do
			if v.id == Constants.HOME_CATEGORY_ID or t10[v.id] then
				table.insert(t11, v)
			end
		end

		return t11, t9
	end

	if p2 == nil then
		local t12 = table.create(#t4)

		for i, v in ipairs(t4) do
			local v45 = t5[i]

			t12[i] = {
				id = v.id,
				infoType = v.infoType,
				itemType = v45.itemType,
				sectionId = v45.sectionId,
				originalIndex = v45.sectionItemIndex
			}
		end

		local v46, v47 = filterOutput(t3)

		return Promise.resolve({
			categories = v46,
			sections = v47,
			failedItems = t12,
			metadata = if not FFlagEnableExperienceShopGlobalIcon then nil else p1.metadata
		})
	end

	local v48 = #t4

	if FFlagEnableRobuxInExperienceShop then
		appendBonusItemRequests(t4, t3)
	end

	return p2(t4):andThen(function(t13: {[any]: any}) -- line: 245
		-- upvalues: makeRequestKey (copy), v48 (copy), t4 (copy), t5 (copy), t3 (copy), toShopItem (copy), logCounter (copy), ProductInfoFailedItemsCounter (copy), FFlagEnableRobuxInExperienceShop (copy), mergeBonusItemDetailsIntoSections (copy), filterOutput (copy), FFlagEnableExperienceShopGlobalIcon (copy), p1 (copy)
		local t14 = {}

		for _, v in ipairs(t13) do
			t14[makeRequestKey(v.request.id, v.request.infoType)] = v
		end

		local t15 = {}

		for i = 1, v48 do
			local v63 = t4[i]
			local v64 = t5[i]
			local v65 = t14[makeRequestKey(v63.id, v63.infoType)]

			if v65 == nil or not v65.ok then
				table.insert(t15, {
					id = v63.id,
					infoType = v63.infoType,
					itemType = v64.itemType,
					sectionId = v64.sectionId,
					originalIndex = v64.sectionItemIndex
				})
			else
				local v66 = t3[v64.categoryIndex]
				local v67 = toShopItem(v65.value, v64.itemType, v63.id)

				v67.originalIndex = v64.sectionItemIndex
				table.insert(v66.items, v67)
			end
		end

		if #t15 > 0 then
			logCounter(ProductInfoFailedItemsCounter, #t15)
		end

		local v68 = t3

		if FFlagEnableRobuxInExperienceShop then
			v68 = mergeBonusItemDetailsIntoSections(t3, t13)
		end

		local v69, v70 = filterOutput(v68)

		return {
			categories = v69,
			sections = v70,
			failedItems = t15,
			metadata = if not FFlagEnableExperienceShopGlobalIcon then nil else p1.metadata
		}
	end)
end

return buildShopDataFromWidgets
