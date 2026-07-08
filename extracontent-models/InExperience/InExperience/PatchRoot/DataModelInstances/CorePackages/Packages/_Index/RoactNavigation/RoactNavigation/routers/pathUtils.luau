local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local scriptParentParentParent = scriptParentParent.Parent
local LuauPolyfill = require(scriptParentParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
local String = LuauPolyfill.String
local RegExp = require(scriptParentParentParent.RegExp)
local invariant = require(scriptParentParent.utils.invariant)
local NavigationActions = require(scriptParentParent.NavigationActions)
local pathToRegexp = require(scriptParent.pathToRegexp)
local compile = pathToRegexp.compile
local pathToRegexp2 = pathToRegexp.pathToRegexp
local queryString = require(scriptParent.queryString)
local lib = require(scriptParent:FindFirstChild("ChildIsScreenRouterSymbol.roblox"))
local lib2 = require(scriptParent:FindFirstChild("NullPathSymbol.roblox"))
local decodeURIComponent = require(scriptParent.decodeURIComponent)
local t1 = {
	getParamsFromPath = function(p1, p2, p3) -- line: 27
		-- upvalues: Array (copy), decodeURIComponent (copy)
		return (Array.reduce(Array.slice(p2, 2), function(p4, p5, p6) -- line: 31
			-- upvalues: p3 (copy), decodeURIComponent (copy)
			local v56 = p3[p6]

			if not v56 or v56.pattern == ".*" then
				return p4
			end

			local name = v56.name
			local v58 = nil

			if p5 then
				local ok, result = pcall(decodeURIComponent, p5)

				if ok then
					v58 = result
				end
			end

			p4[name] = v58 or p5

			return p4
		end, table.clone(p1)))
	end
}

local function getRestOfPath(p7, p8) -- line: 59
	-- upvalues: Array (copy)
	return p7[Array.findIndex(p8, function(p9) -- line: 62
		return p9.pattern == ".*"
	end) + 1]
end
local function determineDelimiter(p10, p11) -- line: 69
	-- upvalues: Array (copy), String (copy)
	if Array.isArray(p11) then
		if #p11 == 1 then
			return p11[1]
		end

		for _, v29 in p11 do
			if String.startsWith(p10, v29) then
				return v29
			end
		end

		return nil
	end

	return p11
end

function t1.urlToPathAndParams(p12, p13) -- line: 85
	-- upvalues: RegExp (copy), queryString (copy), determineDelimiter (copy)
	local v32 = RegExp("^(.*)\\?(.*)$"):exec(p12)
	local v33 = if not v32 then p12 else v32[2]
	local v34 = if not v32 then {} else v32[3]
	local v35 = queryString.parse(v34)
	local v36 = determineDelimiter(v33, p13)

	if v36 == nil or v36 == "" then
		v36 = "://"
	end

	local v37 = string.split(v33, v36)[2]

	if v37 == nil then
		v37 = v33
	end

	if v37 == "/" then
		v37 = ""
	end

	if string.sub(v37, -1, -1) == "/" then
		v37 = string.sub(v37, 1, -2)
	end

	return {
		path = v37,
		params = v35
	}
end
function t1.createPathParser(p14, p15, p16) -- line: 112
	-- upvalues: lib2 (copy), invariant (copy), pathToRegexp2 (copy), compile (copy), Object (copy), Array (copy), NavigationActions (copy), t1 (copy), lib (copy)
	local v41 = p16.paths or {}
	local disableRouteNamePaths = p16.disableRouteNamePaths
	local t2 = {}

	for v44 in p14 do
		local v45 = nil

		if v41[v44] ~= nil then
			v45 = v41[v44]
		elseif type(p15[v44]) == "table" then
			v45 = p15[v44].path
		end

		if v45 == nil then
			v45 = if not disableRouteNamePaths then v44 else lib2
		end

		invariant(v45 == lib2 or type(v45) == "string", "Route path for %s must be specified as a string, or RoactNavigation.NoPath.", v44)

		local v46 = v45 ~= lib2
		local t3 = {}
		local v48 = nil

		if v46 then
			v48 = pathToRegexp2(v45, t3)
		end

		local t4 = {}
		local v50 = v45 == "" or not v46
		local v51 = pathToRegexp2(if not v50 then ("%s/(.*)"):format(v45) else "(.*)", t4)

		t2[v44] = {
			exactRe = v48,
			exactReKeys = t3,
			extendedPathRe = v51,
			extendedPathReKeys = t4,
			isWildcard = v50,
			toPath = v45 == lib2 and function() -- line: 172
				return ""
			end or compile(v45)
		}
	end

	local u52 = Object.entries(t2)

	return {
		getActionForPathAndParams = function(p17, p18) -- line: 180
			-- upvalues: u52 (ref), p14 (copy), Array (copy), NavigationActions (copy), t1 (copy)
			if p17 == nil then
				p17 = ""
			end

			if p18 == nil then
				p18 = {}
			end

			for _, v65 in u52 do
				local v66 = v65[1]
				local v67 = v65[2]
				local exactRe = v67.exactRe
				local exactReKeys = v67.exactReKeys
				local extendedPathRe = v67.extendedPathRe
				local extendedPathReKeys = v67.extendedPathReKeys
				local v72 = p14[v66]
				local v73 = exactRe and exactRe:exec(p17)

				if v73 and v73.n ~= 0 then
					local v74 = extendedPathRe and extendedPathRe:exec(p17)
					local v75 = nil

					if v74 and v72 then
						local v76 = v74[Array.findIndex(extendedPathReKeys, function(p19) -- line: 62
							return p19.pattern == ".*"
						end) + 1]

						v75 = v72.getActionForPathAndParams(v76, p18)
					end

					return NavigationActions.navigate({
						routeName = v66,
						params = t1.getParamsFromPath(p18, v73, exactReKeys),
						action = v75
					})
				end
			end

			for _, v78 in u52 do
				local v79 = v78[1]
				local v80 = v78[2]
				local extendedPathRe = v80.extendedPathRe
				local extendedPathReKeys = v80.extendedPathReKeys
				local v83 = p14[v79]
				local v84 = extendedPathRe and extendedPathRe:exec(p17)

				if not v84 or v84.n == 0 then
					continue
				end

				local v85 = v84[Array.findIndex(extendedPathReKeys, function(p20) -- line: 62
					return p20.pattern == ".*"
				end) + 1]
				local v86 = nil

				if v83 then
					v86 = v83.getActionForPathAndParams(v85, p18)
				end

				if v86 then
					return NavigationActions.navigate({
						routeName = v79,
						params = t1.getParamsFromPath(p18, v84, extendedPathReKeys),
						action = v86
					})
				end
			end

			return nil
		end,
		getPathAndParamsForRoute = function(p21) -- line: 247
			-- upvalues: p14 (copy), t2 (copy), Array (copy), Object (copy), lib (copy)
			local routeName = p21.routeName
			local params = p21.params
			local v90 = p14[routeName]
			local v91 = t2[routeName]
			local toPath = v91.toPath
			local exactReKeys = v91.exactReKeys
			local v94 = toPath(params)
			local t5 = {}

			if params then
				for _, v97 in (Array.filter(Object.keys(params), function(p22) -- line: 257
					-- upvalues: Array (copy), exactReKeys (copy)
					return not Array.find(exactReKeys, function(p23) -- line: 258
						-- upvalues: p22 (copy)
						return p23.name == p22
					end)
				end)) do
					t5[v97] = params[v97]
				end
			end

			if v90 and v90 ~= lib then
				local v98 = v90.getPathAndParamsForState(p21)

				return {
					path = if not v94 or v94 == "" then v98.path else ("%s/%s"):format(v94, v98.path),
					params = if not v98.params then t5 else Object.assign(t5, v98.params)
				}
			end

			return {
				path = v94,
				params = t5
			}
		end
	}
end

return t1
