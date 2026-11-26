local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local module = require("@luauforge/bundled/fxu")
local module2 = require("@luauforge/bundled/fxw")
local mutedError = require("@luauforge/bundled/fxX").mutedError

local safeAppStorageService = module.Lib.SafeAppStorageService
local module3 = require("@luauforge/bundled/fxY")

local module4 = require("@luauforge/bundled/fxZ")

local function getUserId()
	return module3(Players) or "defaultUserId"
end

local function getItems()
	local v5 = module3(Players) or "defaultUserId"

	local item = safeAppStorageService.getItem("AXMarketplaceRecentlyViewedItems")
	local v6 = (not item or item == "") and "{}" or item
	local items = {}
	local success, result = pcall(function()
		local jsonDecode = HttpService:JSONDecode(v6)

		if jsonDecode.userId == v5 then
			items = jsonDecode.items
		end
	end)

	if success == false then
		mutedError(`RecentlyViewedSearchItemsAppStorage getItems JSONDecode error: {result}`)
	end

	return items
end

local function removeItem(p2, p3)
	local items = getItems()
	return module2.filter(items, function(p4): boolean
		return p4.id ~= p2 or p4.itemType ~= p3
	end)
end

local function saveItems(p2)
	local v5 = module3(Players) or "defaultUserId"

	local success, result = pcall(function()
		local jsonEncode = HttpService:JSONEncode({ userId = v5, items = p2 })
		safeAppStorageService.setItem("AXMarketplaceRecentlyViewedItems", jsonEncode)
		safeAppStorageService.flush()
	end)

	if success == false then
		mutedError(`RecentlyViewedSearchItemsAppStorage saveItems JSONEncode error: {result}`)
	end
end

return {
	clearItems = function()
		safeAppStorageService.setItem("AXMarketplaceRecentlyViewedItems", "{}")
		safeAppStorageService.flush()
	end,
	getItems = function()
		return getItems()
	end,
	removeItem = function(p2, p3)
		local items = getItems()
		local filtered = module2.filter(items, function(p4): boolean
			return p4.id ~= p2 or p4.itemType ~= p3
		end)
		local v5 = module3(Players) or "defaultUserId"

		local success, result = pcall(function()
			local jsonEncode = HttpService:JSONEncode({ userId = v5, items = filtered })
			safeAppStorageService.setItem("AXMarketplaceRecentlyViewedItems", jsonEncode)
			safeAppStorageService.flush()
		end)

		if success == false then
			mutedError(`RecentlyViewedSearchItemsAppStorage saveItems JSONEncode error: {result}`)
		end

		return filtered
	end,
	addItem = function(p2, p3)
		local items = getItems()
		local filtered = module2.filter(items, function(p4): boolean
			return p4.id ~= p2 or p4.itemType ~= p3
		end)

		table.insert(filtered, 1, { id = p2, itemType = p3 })

		if #filtered > module4() then
			table.remove(filtered)
		end

		local v5 = module3(Players) or "defaultUserId"

		local success, result = pcall(function()
			local jsonEncode = HttpService:JSONEncode({ userId = v5, items = filtered })
			safeAppStorageService.setItem("AXMarketplaceRecentlyViewedItems", jsonEncode)
			safeAppStorageService.flush()
		end)

		if success == false then
			mutedError(`RecentlyViewedSearchItemsAppStorage saveItems JSONEncode error: {result}`)
		end

		return filtered
	end
}
