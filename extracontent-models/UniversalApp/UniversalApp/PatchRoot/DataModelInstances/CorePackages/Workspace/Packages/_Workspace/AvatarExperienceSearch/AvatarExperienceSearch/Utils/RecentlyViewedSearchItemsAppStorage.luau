local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local AvatarExperienceSearch = script:FindFirstAncestor("AvatarExperienceSearch")
local AvatarExperienceSearchParent = AvatarExperienceSearch.Parent
local AXCommon = require(AvatarExperienceSearchParent.AXCommon)
local Dash = require(AvatarExperienceSearchParent.Dash)
local mutedError = require(AvatarExperienceSearchParent.Loggers).mutedError
local SafeAppStorageService = AXCommon.Lib.SafeAppStorageService
local getLocalUserId = require(script.Parent.getLocalUserId)
local GetFIntAXMaxRecentlyViewedSearchItems = require(AvatarExperienceSearch.Flags.GetFIntAXMaxRecentlyViewedSearchItems)

local function getUserId() -- line: 29
	-- upvalues: getLocalUserId (copy), Players (copy)
	return getLocalUserId(Players) or "defaultUserId"
end
local function getItems() -- line: 36
	-- upvalues: getLocalUserId (copy), Players (copy), SafeAppStorageService (copy), HttpService (copy), mutedError (copy)
	local v15 = getLocalUserId(Players) or "defaultUserId"
	local u16 = SafeAppStorageService.getItem("AXMarketplaceRecentlyViewedItems")

	if not u16 or u16 == "" then
		u16 = "{}"
	end

	local t1 = {}
	local ok, result = pcall(function() -- line: 51
		-- upvalues: HttpService (copy), u16 (ref), v15 (copy), t1 (ref)
		local data = HttpService:JSONDecode(u16)

		if data.userId == v15 then
			t1 = data.items
		end
	end)

	if ok == false then
		mutedError(`RecentlyViewedSearchItemsAppStorage getItems JSONDecode error: { result }`)
	end

	return t1
end
local function removeItem(s1: string, s2: string) -- line: 65
	-- upvalues: getItems (copy), Dash (copy)
	local v22 = getItems()

	return Dash.filter(v22, function(p1) -- line: 67
		-- upvalues: s1 (copy), s2 (copy)
		return p1.id ~= s1 or p1.itemType ~= s2
	end)
end
local function saveItems(t2: {[any]: any}) -- line: 72
	-- upvalues: getLocalUserId (copy), Players (copy), HttpService (copy), SafeAppStorageService (copy), mutedError (copy)
	local v24 = getLocalUserId(Players) or "defaultUserId"
	local ok, result = pcall(function() -- line: 75
		-- upvalues: HttpService (copy), v24 (copy), t2 (copy), SafeAppStorageService (copy)
		local json = HttpService:JSONEncode({
			userId = v24,
			items = t2
		})

		SafeAppStorageService.setItem("AXMarketplaceRecentlyViewedItems", json)
		SafeAppStorageService.flush()
	end)

	if ok == false then
		mutedError(`RecentlyViewedSearchItemsAppStorage saveItems JSONEncode error: { result }`)
	end
end

return {
	clearItems = function() -- line: 91
		-- upvalues: SafeAppStorageService (copy)
		SafeAppStorageService.setItem("AXMarketplaceRecentlyViewedItems", "{}")
		SafeAppStorageService.flush()
	end,
	getItems = function() -- line: 96
		-- upvalues: getItems (copy)
		return (getItems())
	end,
	removeItem = function(s3: string, s4: string) -- line: 100
		-- upvalues: getItems (copy), Dash (copy), getLocalUserId (copy), Players (copy), HttpService (copy), SafeAppStorageService (copy), mutedError (copy)
		local v29 = getItems()
		local v30 = Dash.filter(v29, function(p2) -- line: 67
			-- upvalues: s3 (copy), s4 (copy)
			return p2.id ~= s3 or p2.itemType ~= s4
		end)
		local v31 = getLocalUserId(Players) or "defaultUserId"
		local ok, result = pcall(function() -- line: 75
			-- upvalues: HttpService (copy), v31 (copy), v30 (copy), SafeAppStorageService (copy)
			local json = HttpService:JSONEncode({
				userId = v31,
				items = v30
			})

			SafeAppStorageService.setItem("AXMarketplaceRecentlyViewedItems", json)
			SafeAppStorageService.flush()
		end)

		if ok == false then
			mutedError(`RecentlyViewedSearchItemsAppStorage saveItems JSONEncode error: { result }`)
		end

		return v30
	end,
	addItem = function(s5: string, s6: string) -- line: 106
		-- upvalues: getItems (copy), Dash (copy), GetFIntAXMaxRecentlyViewedSearchItems (copy), getLocalUserId (copy), Players (copy), HttpService (copy), SafeAppStorageService (copy), mutedError (copy)
		local v36 = getItems()
		local v37 = Dash.filter(v36, function(p3) -- line: 67
			-- upvalues: s5 (copy), s6 (copy)
			return p3.id ~= s5 or p3.itemType ~= s6
		end)

		table.insert(v37, 1, {
			id = s5,
			itemType = s6
		})

		if #v37 > GetFIntAXMaxRecentlyViewedSearchItems() then
			table.remove(v37)
		end

		local v38 = getLocalUserId(Players) or "defaultUserId"
		local ok, result = pcall(function() -- line: 75
			-- upvalues: HttpService (copy), v38 (copy), v37 (copy), SafeAppStorageService (copy)
			local json = HttpService:JSONEncode({
				userId = v38,
				items = v37
			})

			SafeAppStorageService.setItem("AXMarketplaceRecentlyViewedItems", json)
			SafeAppStorageService.flush()
		end)

		if ok == false then
			mutedError(`RecentlyViewedSearchItemsAppStorage saveItems JSONEncode error: { result }`)
		end

		return v37
	end
}
