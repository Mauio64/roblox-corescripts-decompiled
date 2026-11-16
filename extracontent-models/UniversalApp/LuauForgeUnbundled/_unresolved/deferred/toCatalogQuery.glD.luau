require("@luauforge/deferred/glu")

local v5 = {
	["0"] = "Relevance",
	["1"] = "MostFavorited",
	["2"] = "Bestselling",
	["3"] = "RecentlyCreated",
	["4"] = "PriceLowToHigh",
	["5"] = "PriceHighToLow"
}

local v6 = { ["1"] = "PastDay", ["3"] = "PastWeek", ["5"] = "AllTime" }

local function urlDecode(value)
	local v7 = string.gsub(value, "%+", " ")
	return (string.gsub(v7, "%%(%x%x)", function(p2)
		return (string.char((tonumber(p2, 16))))
	end))
end

local function parseQueryString(value)
	local queryString = {}

	for k in string.gmatch(value, "[^&]+") do
		local v7, v8 = string.match(k, "^([^=]*)=?(.*)$")

		if not (v7 and v7 ~= "") then
			continue
		end

		local lower = string.lower
		local v9 = string.gsub(v7, "%+", " ")
		local function fn(p2)
			return (string.char((tonumber(p2, 16))))
		end

		local v10 = lower((string.gsub(v9, "%%(%x%x)", fn)))

		if queryString[v10] ~= nil then
			continue
		end

		local v11 = string.gsub(v8 or "", "%+", " ")
		queryString[v10] = string.gsub(v11, "%%(%x%x)", fn)
	end

	return queryString
end

local function nonEmpty(value)
	if value == nil then
		return nil
	end

	local v7 = string.match(value, "^%s*(.-)%s*$") or ""

	if v7 == "" then
		return nil
	end

	return v7
end

local function toCatalogQuery(p2)
	local v7 = parseQueryString(p2)

	local keyword = v7.keyword
	local v8

	if keyword ~= nil then
		v8 = string.match(keyword, "^%s*(.-)%s*$") or ""

		if v8 == "" then
			v8 = nil
		end
	end

	local creatorname = v7.creatorname
	local v9

	if creatorname ~= nil then
		v9 = string.match(creatorname, "^%s*(.-)%s*$") or ""

		if v9 == "" then
			v9 = nil
		end
	end

	local category = v7.category
	local v10

	if category ~= nil then
		v10 = string.match(category, "^%s*(.-)%s*$") or ""

		if v10 == "" then
			v10 = nil
		end
	end

	local subcategory = v7.subcategory
	local v11

	if subcategory ~= nil then
		v11 = string.match(subcategory, "^%s*(.-)%s*$") or ""

		if v11 == "" then
			v11 = nil
		end
	end

	local taxonomy = v7.taxonomy
	local v12

	if taxonomy ~= nil then
		v12 = string.match(taxonomy, "^%s*(.-)%s*$") or ""

		if v12 == "" then
			v12 = nil
		end
	end

	local catalogQuery = {
		keyword = v8,
		creatorName = v9,
		category = v10,
		subcategory = v11,
		taxonomy = v12,
		sortType = v5[v7.sorttype or ""],
		sortAggregation = v6[v7.sortaggregation or ""],
		salesTypeFilter = 0,
		minPrice = 0,
		maxPrice = 0,
		includeNotForSale = 0,
		topics = 0
	}
	local salestypefilter = v7.salestypefilter
	local v13

	if salestypefilter ~= nil then
		v13 = string.match(salestypefilter, "^%s*(.-)%s*$") or ""

		if v13 == "" then
			v13 = nil
		end
	end

	catalogQuery.salesTypeFilter = v13
	local minprice = v7.minprice
	local v14

	if minprice ~= nil then
		v14 = string.match(minprice, "^%s*(.-)%s*$") or ""

		if v14 == "" then
			v14 = nil
		end
	end

	catalogQuery.minPrice = v14
	local maxprice = v7.maxprice
	local v15

	if maxprice ~= nil then
		v15 = string.match(maxprice, "^%s*(.-)%s*$") or ""

		if v15 == "" then
			v15 = nil
		end
	end

	catalogQuery.maxPrice = v15
	catalogQuery.includeNotForSale = string.lower(v7.includenotforsale or "") == "true" and "true" or nil
	local topics = v7.topics
	local v16

	if topics ~= nil then
		v16 = string.match(topics, "^%s*(.-)%s*$") or ""

		if v16 == "" then
			v16 = nil
		end
	end

	catalogQuery.topics = v16
	return catalogQuery
end

return toCatalogQuery
