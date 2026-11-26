local engineFeature = game:GetEngineFeature("AXMarketplaceRecentSearchesStorageKey")
local v5 = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local module = require("@luauforge/bundled/fxY")
local module2 = require("@luauforge/bundled/fys")

local module3 = require("@luauforge/bundled/fyu")

local function getMockAppStorageService()
	return {
		storage = {},
		GetItem = function(self, p3)
			return self.storage[p3]
		end,
		SetItem = function(self, p3, p4)
			self.storage[p3] = p4
		end,
		Flush = function(self) end
	}
end

if not engineFeature then
	v5 = getMockAppStorageService()
end

local function getUserId()
	return module(Players) or "defaultUserId"
end

local function getTerms()
	local v6 = module(Players) or "defaultUserId"

	local item = v5:GetItem("AXMarketplaceRecentSearches") or "{}"

	local terms = {}
	pcall(function()
		local jsonDecode = HttpService:JSONDecode(item)

		if jsonDecode.userId == v6 then
			terms = jsonDecode.terms or {}
		end
	end)
	return terms
end

local function removeTerm(value)
	local terms = getTerms()

	for k, term in terms do
		if string.lower(term) == string.lower(value) then
			table.remove(terms, k)
			return terms
		end
	end

	return terms
end

local function saveTerms(p2)
	local v6 = module(Players) or "defaultUserId"

	pcall(function()
		local jsonEncode = HttpService:JSONEncode({ userId = v6, terms = p2 })
		v5:SetItem("AXMarketplaceRecentSearches", jsonEncode)
		v5:Flush()
	end)
end

return {
	__mockAppStorageService = function(p2)
		v5 = p2 or getMockAppStorageService()
	end,
	clearTerms = function()
		v5:SetItem("AXMarketplaceRecentSearches", "{}")
		v5:Flush()
	end,
	getTerms = function()
		return getTerms()
	end,
	removeTerm = function(p2)
		if p2 == nil or p2 == "" then
			return getTerms()
		end

		local v6 = removeTerm(p2)
		local v7 = module(Players) or "defaultUserId"

		pcall(function()
			local jsonEncode = HttpService:JSONEncode({ userId = v7, terms = v6 })
			v5:SetItem("AXMarketplaceRecentSearches", jsonEncode)
			v5:Flush()
		end)

		return v6
	end,
	addTerm = function(p2)
		if p2 == nil or p2 == "" then
			return getTerms()
		end

		local v6 = removeTerm(p2)
		table.insert(v6, 1, p2)

		if #v6 > module3() then
			table.remove(v6)
		end

		local v7 = module(Players) or "defaultUserId"

		pcall(function()
			local jsonEncode = HttpService:JSONEncode({ userId = v7, terms = v6 })
			v5:SetItem("AXMarketplaceRecentSearches", jsonEncode)
			v5:Flush()
		end)

		return v6
	end,
	findTermsForQuery = function(value)
		local terms = getTerms()

		if value == nil or value == "" then
			return terms
		end

		local terms2 = {}

		for k, term in terms do
			if string.lower((string.sub(term, 1, (string.len(value))))) ~= string.lower(value) then
				continue
			end

			table.insert(terms2, term)
		end

		return terms2
	end,
	findTermsForAutocompleteKey = function(list)
		local terms = getTerms()

		if list == nil or list == "" then
			return terms
		end

		local terms2 = {}

		for k, term in terms do
			local v6 = module2(term)

			if v6 and string.sub(v6, 1, #list) == list then
				table.insert(terms2, term)
			end
		end

		return terms2
	end
}
