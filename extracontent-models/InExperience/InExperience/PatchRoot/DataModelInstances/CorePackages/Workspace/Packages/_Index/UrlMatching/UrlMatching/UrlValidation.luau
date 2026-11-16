local parent = script.Parent.Parent

local Cryo = require(parent.Cryo)
local Regex = require(script.Parent.Regex)
local RegExp = require(parent.RegExp)

local StringUtilities = require(parent.StringUtilities)
local StringSplit = StringUtilities.StringSplit
local StringTrim = StringUtilities.StringTrim
local ParseQuery = StringUtilities.ParseQuery

local SharedFlags = require(parent.SharedFlags)
local FFlagAppChatEarlyTestingLinks = SharedFlags.FFlagAppChatEarlyTestingLinks

require(script.Parent.Types)

local function filterParams(p, flag: boolean) -- 3 equivalent calls inferred from this helper
	return Cryo.List.filter(p, function(p2): boolean
		return p2.optional == flag or not flag and p2.optional == nil
	end)
end

local function requiredParams(p)
	return filterParams(p, false)
end

local function optionalParams(p)
	return filterParams(p, true)
end

local function mapValidToArgName(p) -- 1 equivalent call inferred from this helper
	return function(p2)
		local matchWhole = Regex.matchWhole(Regex.oneOrMore(p2.pattern))
		local v = p[p2.name]

		if FFlagAppChatEarlyTestingLinks and type(v) ~= "string" or (v == nil or not RegExp(matchWhole):exec(v)) then
			return nil
		end

		return p2.name
	end
end

local function validateParams(mapped, p)
	local v = mapped or {}
	local v2 = filterParams(p, false) -- inferred equivalent call
	local v3 = mapValidToArgName(v) -- inferred equivalent call
	local filterMap = Cryo.List.filterMap(v2, v3)

	if #filterMap ~= #v2 then
		return false, {}
	end

	local v4 = filterParams(p, true) -- inferred equivalent call
	local filterMap2 = Cryo.List.filterMap(v4, v3)
	local joined = Cryo.List.join(filterMap, filterMap2)
	local set = Cryo.List.toSet(joined)
	return true, (Cryo.Dictionary.filter(v, function(_, p2): boolean
		return set[p2] ~= nil
	end))
end

local function validatePathParams(list, pathParams)
	if #list < #filterParams(pathParams, false) then -- inferred equivalent call
		return false, {}
	end

	return validateParams(Cryo.Dictionary.map(pathParams, function(p, p2)
		return list[p2], p.name
	end), pathParams)
end

local function validateUrlParams(url, item)
	local v = not url.path and "" or StringTrim(url.path, "/")
	local v2 = v == "" and {} or StringSplit(v, "/")

	local parseQuery = ParseQuery(url.query)
	local mapped = Cryo.Dictionary.map(parseQuery, function(list)
		return if #list == 1 then list[1] else list
	end)

	local v3, v4 = validatePathParams(v2, item.pathParams or {})

	if not v3 then
		return false, {}
	end

	local v5, v6 = validateParams(mapped, item.queryParams or {})

	if v5 then
		return true, Cryo.Dictionary.union(v4, v6)
	end

	return false, {}
end

return {
	validateUrlMatch = function(p, items)
		for k, item in items do
			if not RegExp(k, "i"):test(p.matchedPath) then
				continue
			end

			local v, v2 = validateUrlParams(p.url, item)

			if v then
				return v, item.paramCallback(v2)
			end
		end

		return false, nil
	end,
	validateUrlParams = validateUrlParams
}
