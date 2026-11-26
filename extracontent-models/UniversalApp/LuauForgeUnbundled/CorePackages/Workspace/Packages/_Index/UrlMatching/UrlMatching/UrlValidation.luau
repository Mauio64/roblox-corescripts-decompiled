local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/UrlMatching/Cryo")
local Regex = require("@game/CorePackages/Workspace/Packages/_Index/UrlMatching/UrlMatching/Regex")
local RegExp = require("@game/CorePackages/Workspace/Packages/_Workspace/UrlMatching/RegExp")

local StringUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/UrlMatching/StringUtilities")
local stringSplit = StringUtilities.StringSplit
local stringTrim = StringUtilities.StringTrim
local parseQuery = StringUtilities.ParseQuery

local fFlagAppChatEarlyTestingLinks = require("@game/CorePackages/Workspace/Packages/_Workspace/UrlMatching/SharedFlags").FFlagAppChatEarlyTestingLinks

require("@game/CorePackages/Workspace/Packages/_Index/UrlMatching/UrlMatching/Types")

local function filterParams(p2, p3)
	return Cryo.List.filter(p2, function(p4): boolean
		return p4.optional == p3 or not p3 and p4.optional == nil
	end)
end

local function requiredParams(p2)
	return filterParams(p2, false)
end

local function optionalParams(p2)
	return filterParams(p2, true)
end

local function mapValidToArgName(p2)
	return function(p3)
		local matchWhole = Regex.matchWhole(Regex.oneOrMore(p3.pattern))
		local v5 = p2[p3.name]

		if
			fFlagAppChatEarlyTestingLinks and type(v5) ~= "string"
			or (v5 == nil or not RegExp(matchWhole):exec(v5))
		then
			return nil
		end

		return p3.name
	end
end

local function validateParams(mapped, p2)
	local v5 = mapped or {}
	local v6
	v6 = false
	local filtered = Cryo.List.filter(p2, function(p3): boolean
		return p3.optional == v6 or not v6 and p3.optional == nil
	end)

	local function fn(p3)
		local matchWhole = Regex.matchWhole(Regex.oneOrMore(p3.pattern))
		local v7 = v5[p3.name]

		if
			fFlagAppChatEarlyTestingLinks and type(v7) ~= "string"
			or (v7 == nil or not RegExp(matchWhole):exec(v7))
		then
			return nil
		end

		return p3.name
	end

	local filterMap = Cryo.List.filterMap(filtered, fn)

	if #filterMap ~= #filtered then
		return false, {}
	end

	local v7
	v7 = true
	local filtered2 = Cryo.List.filter(p2, function(p3): boolean
		return p3.optional == v7 or not v7 and p3.optional == nil
	end)

	local filterMap2 = Cryo.List.filterMap(filtered2, fn)
	local joined = Cryo.List.join(filterMap, filterMap2)
	local set = Cryo.List.toSet(joined)
	return true, (Cryo.Dictionary.filter(v5, function(p3, p4): boolean
		return set[p4] ~= nil
	end))
end

local function validatePathParams(list, pathParams)
	local v5
	v5 = false

	if #list < #Cryo.List.filter(pathParams, function(p2): boolean
		return p2.optional == v5 or not v5 and p2.optional == nil
	end) then
		return false, {}
	end

	return validateParams(Cryo.Dictionary.map(pathParams, function(p2, p3)
		return list[p3], p2.name
	end), pathParams)
end

local function validateUrlParams(url, item)
	local v5 = not url.path and "" or stringTrim(url.path, "/")
	local v6 = v5 == "" and {} or stringSplit(v5, "/")

	local v7 = parseQuery(url.query)
	local mapped = Cryo.Dictionary.map(v7, function(list)
		if #list == 1 then
			return list[1]
		end

		return list
	end)

	local v8, v9 = validatePathParams(v6, item.pathParams or {})

	if not v8 then
		return false, {}
	end

	local v10, v11 = validateParams(mapped, item.queryParams or {})

	if v10 then
		return true, Cryo.Dictionary.union(v9, v11)
	end

	return false, {}
end

return {
	validateUrlMatch = function(p2, items)
		for k, item in items do
			if not RegExp(k, "i"):test(p2.matchedPath) then
				continue
			end

			local v5, v6 = validateUrlParams(p2.url, item)

			if v5 then
				return v5, item.paramCallback(v6)
			end
		end

		return false, nil
	end,
	validateUrlParams = validateUrlParams
}
