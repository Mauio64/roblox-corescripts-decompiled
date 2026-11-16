local parent = script.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent

local LuauPolyfill = require(parent3.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
local String = LuauPolyfill.String
local RegExp = require(parent3.RegExp)
local invariant = require(parent2.utils.invariant)
local NavigationActions = require(parent2.NavigationActions)
local pathToRegexp = require(parent.pathToRegexp)
local compile = pathToRegexp.compile
local pathToRegexp2 = pathToRegexp.pathToRegexp
local queryString = require(parent.queryString)
local ChildIsScreenRouterSymbolroblox = require(parent:FindFirstChild("ChildIsScreenRouterSymbol.roblox"))
local NullPathSymbolroblox = require(parent:FindFirstChild("NullPathSymbol.roblox"))

local decodeURIComponent = require(parent.decodeURIComponent)

local PathUtils = {}

function PathUtils.getParamsFromPath(p, p2, p3)
	return (Array.reduce(Array.slice(p2, 2), function(p4, p5, p6)
		local v = p3[p6]

		if not v or v.pattern == ".*" then
			return p4
		end

		local name = v.name

		local v2 = nil

		if p5 then
			local success, result = pcall(decodeURIComponent, p5)

			if success then
				v2 = result
			end
		end

		p4[name] = v2 or p5
		return p4
	end, table.clone(p)))
end

local function getRestOfPath(p, p2)
	return p[Array.findIndex(p2, function(p3): boolean
		return p3.pattern == ".*"
	end) + 1]
end

local function determineDelimiter(value, list)
	if not Array.isArray(list) then
		return list
	end

	if #list == 1 then
		return list[1]
	end

	for _, item in list do
		if String.startsWith(value, item) then
			return item
		end
	end

	return nil
end

function PathUtils.urlToPathAndParams(value, p)
	local v = RegExp("^(.*)\\?(.*)$"):exec(value)

	if v then
		value = v[2]
	end

	local v2 = not v and {} or v[3]
	local parsed = queryString.parse(v2)
	local v3 = determineDelimiter(value, p)
	local v4 = (v3 == nil or v3 == "") and "://" or v3

	local v5 = string.split(value, v4)[2]

	if v5 == nil then
		v5 = value
	end

	local path = v5 == "/" and "" or v5

	if string.sub(path, -1, -1) == "/" then
		path = string.sub(path, 1, -2)
	end

	return { path = path, params = parsed }
end

function PathUtils.createPathParser(items, p, p2)
	local paths = p2.paths or {}
	local disableRouteNamePaths = p2.disableRouteNamePaths
	local v = {}

	for k in items do
		local v2 = nil

		if paths[k] == nil then
			if type(p[k]) == "table" then
				v2 = p[k].path
			end
		else
			v2 = paths[k]
		end

		if v2 == nil then
			if disableRouteNamePaths then
				v2 = NullPathSymbolroblox
			else
				v2 = k
			end
		end

		invariant(
			v2 == NullPathSymbolroblox or type(v2) == "string",
			"Route path for %s must be specified as a string, or RoactNavigation.NoPath.",
			k
		)
		local v3 = v2 ~= NullPathSymbolroblox
		local exactReKeys = {}
		local exactRe

		if v3 then
			exactRe = pathToRegexp2(v2, exactReKeys)
		end

		local extendedPathReKeys = {}
		local isWildcard = v2 == "" or not v3

		v[k] = {
			exactRe = exactRe,
			exactReKeys = exactReKeys,
			extendedPathRe = pathToRegexp2(isWildcard and "(.*)" or ("%s/(.*)"):format(v2), extendedPathReKeys),
			extendedPathReKeys = extendedPathReKeys,
			isWildcard = isWildcard,
			toPath = v2 == NullPathSymbolroblox and function(): string
				return ""
			end or compile(v2)
		}
	end

	local entries = Object.entries(v)

	return {
		getActionForPathAndParams = function(p3, p4)
			local v2 = p3 == nil and "" or p3

			local v3 = p4 == nil and {} or p4

			local function fn(p5): boolean
				return p5.pattern == ".*"
			end

			for _, entry in entries do
				local routeName = entry[1]
				local v4 = entry[2]
				local exactRe = v4.exactRe
				local exactReKeys = v4.exactReKeys
				local extendedPathRe = v4.extendedPathRe
				local extendedPathReKeys = v4.extendedPathReKeys
				local item = items[routeName]

				local v5 = exactRe and exactRe:exec(v2)

				if v5 and v5.n ~= 0 then
					local v6 = extendedPathRe and extendedPathRe:exec(v2)
					local action

					if v6 and item then
						local v7 = v6[Array.findIndex(extendedPathReKeys, fn) + 1]

						action = item.getActionForPathAndParams(v7, v3)
					end

					return NavigationActions.navigate({
						routeName = routeName,
						params = PathUtils.getParamsFromPath(v3, v5, exactReKeys),
						action = action
					})
				end
			end

			for _, entry in entries do
				local routeName = entry[1]
				local v4 = entry[2]
				local extendedPathRe = v4.extendedPathRe
				local extendedPathReKeys = v4.extendedPathReKeys
				local item = items[routeName]
				local v5 = extendedPathRe and extendedPathRe:exec(v2)

				if not (v5 and v5.n ~= 0) then
					continue
				end

				local v6 = v5[Array.findIndex(extendedPathReKeys, fn) + 1]
				local action

				if item then
					action = item.getActionForPathAndParams(v6, v3)
				end

				if action then
					return NavigationActions.navigate({
						routeName = routeName,
						params = PathUtils.getParamsFromPath(v3, v5, extendedPathReKeys),
						action = action
					})
				end
			end

			return nil
		end,
		getPathAndParamsForRoute = function(p3)
			local routeName = p3.routeName
			local params = p3.params
			local item = items[routeName]
			local v2 = v[routeName]
			local toPath = v2.toPath
			local exactReKeys = v2.exactReKeys
			local path = toPath(params)
			local params2 = {}

			if params then
				local filtered = Array.filter(Object.keys(params), function(p4): boolean
					return not Array.find(exactReKeys, function(p5): boolean
						return p5.name == p4
					end)
				end)

				for _, v3 in filtered do
					params2[v3] = params[v3]
				end
			end

			if not item or item == ChildIsScreenRouterSymbolroblox then
				return { path = path, params = params2 }
			end

			local pathAndParamsForState = item.getPathAndParamsForState(p3)
			local path2

			if path and path ~= "" then
				path2 = ("%s/%s"):format(path, pathAndParamsForState.path)
			else
				path2 = pathAndParamsForState.path
			end

			if pathAndParamsForState.params then
				params2 = Object.assign(params2, pathAndParamsForState.params)
			end

			return { path = path2, params = params2 }
		end
	}
end

return PathUtils
