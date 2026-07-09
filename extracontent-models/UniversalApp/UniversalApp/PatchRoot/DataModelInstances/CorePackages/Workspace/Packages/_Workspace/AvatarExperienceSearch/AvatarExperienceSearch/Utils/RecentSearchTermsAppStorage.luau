local EngineFeature = game:GetEngineFeature("AXMarketplaceRecentSearchesStorageKey")
local AppStorageService = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local AvatarExperienceSearch = script:FindFirstAncestor("AvatarExperienceSearch")
local getLocalUserId = require(script.Parent.getLocalUserId)
local GetFIntAXMaxRecentSearchTerms = require(AvatarExperienceSearch.Flags.GetFIntAXMaxRecentSearchTerms)
local u8 = AppStorageService

local function getMockAppStorageService() -- line: 22
	return {
		storage = {},
		GetItem = function(p1, p2) -- line: 25
			return p1.storage[p2]
		end,
		SetItem = function(p3, p4, p5) -- line: 28
			p3.storage[p4] = p5
		end,
		Flush = function(_) -- line: 31
		end
	}
end

if not EngineFeature then
	u8 = getMockAppStorageService()
end

local function getUserId() -- line: 41
	-- upvalues: getLocalUserId (copy), Players (copy)
	return getLocalUserId(Players) or "defaultUserId"
end
local function getTerms() -- line: 48
	-- upvalues: getLocalUserId (copy), Players (copy), u8 (ref), HttpService (copy)
	local v14 = getLocalUserId(Players) or "defaultUserId"
	local v15 = u8:GetItem("AXMarketplaceRecentSearches") or "{}"
	local t1 = {}

	pcall(function() -- line: 60
		-- upvalues: HttpService (copy), v15 (copy), v14 (copy), t1 (ref)
		local data = HttpService:JSONDecode(v15)

		if data.userId == v14 then
			t1 = data.terms or {}
		end
	end)

	return t1
end
local function removeTerm(s1: string) -- line: 69
	-- upvalues: getTerms (copy)
	local v18 = getTerms()

	for v19, v20 in v18 do
		if string.lower(v20) == string.lower(s1) then
			table.remove(v18, v19)

			return v18
		end
	end

	return v18
end
local function saveTerms(t2: {[any]: any}) -- line: 80
	-- upvalues: getLocalUserId (copy), Players (copy), HttpService (copy), u8 (ref)
	local v22 = getLocalUserId(Players) or "defaultUserId"

	pcall(function() -- line: 83
		-- upvalues: HttpService (copy), v22 (copy), t2 (copy), u8 (ref)
		local json = HttpService:JSONEncode({
			userId = v22,
			terms = t2
		})

		u8:SetItem("AXMarketplaceRecentSearches", json)
		u8:Flush()
	end)
end

return {
	__mockAppStorageService = function(p7) -- line: 96
		-- upvalues: u8 (ref), getMockAppStorageService (copy)
		u8 = p7 or getMockAppStorageService()
	end,
	clearTerms = function() -- line: 100
		-- upvalues: u8 (ref)
		u8:SetItem("AXMarketplaceRecentSearches", "{}")
		u8:Flush()
	end,
	getTerms = function() -- line: 105
		-- upvalues: getTerms (copy)
		return (getTerms())
	end,
	removeTerm = function(s2: string) -- line: 109
		-- upvalues: getTerms (copy), removeTerm (copy), getLocalUserId (copy), Players (copy), HttpService (copy), u8 (ref)
		if s2 == nil or s2 == "" then
			return (getTerms())
		end

		local v25 = removeTerm(s2)
		local v26 = getLocalUserId(Players) or "defaultUserId"

		pcall(function() -- line: 83
			-- upvalues: HttpService (copy), v26 (copy), v25 (copy), u8 (ref)
			local json = HttpService:JSONEncode({
				userId = v26,
				terms = v25
			})

			u8:SetItem("AXMarketplaceRecentSearches", json)
			u8:Flush()
		end)

		return v25
	end,
	addTerm = function(s3: string) -- line: 119
		-- upvalues: getTerms (copy), removeTerm (copy), GetFIntAXMaxRecentSearchTerms (copy), getLocalUserId (copy), Players (copy), HttpService (copy), u8 (ref)
		if s3 == nil or s3 == "" then
			return (getTerms())
		end

		local v28 = removeTerm(s3)

		table.insert(v28, 1, s3)

		if #v28 > GetFIntAXMaxRecentSearchTerms() then
			table.remove(v28)
		end

		local v29 = getLocalUserId(Players) or "defaultUserId"

		pcall(function() -- line: 83
			-- upvalues: HttpService (copy), v29 (copy), v28 (copy), u8 (ref)
			local json = HttpService:JSONEncode({
				userId = v29,
				terms = v28
			})

			u8:SetItem("AXMarketplaceRecentSearches", json)
			u8:Flush()
		end)

		return v28
	end,
	findTermsForQuery = function(s4: string) -- line: 138
		-- upvalues: getTerms (copy)
		local v31 = getTerms()

		if s4 == nil or s4 == "" then
			return v31
		end

		local t3 = {}

		for _, v34 in v31 do
			if string.lower((string.sub(v34, 1, (string.len(s4))))) == string.lower(s4) then
				table.insert(t3, v34)
			end
		end

		return t3
	end
}
