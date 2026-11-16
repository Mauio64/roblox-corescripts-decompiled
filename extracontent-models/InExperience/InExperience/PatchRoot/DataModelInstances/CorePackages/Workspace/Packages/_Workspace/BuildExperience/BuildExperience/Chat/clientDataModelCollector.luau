local function defaultDependencies()
	local Players = game:GetService("Players")
	return {
		gameId = game.GameId,
		root = game,
		players = Players,
		localPlayer = Players.LocalPlayer,
		getService = function(childName: string)
			local success, service = pcall(game.GetService, game, childName)

			if success then
				return service
			end

			return game:FindFirstChild(childName)
		end,
		getReflectionProperties = function(p: string)
			local ReflectionService = game:GetService("ReflectionService")
			return ReflectionService:GetPropertiesOfClass(p, {})
		end
	}
end

local function safeGetChildren(p) -- 3 equivalent calls inferred from this helper
	local success, children = pcall(p.GetChildren, p)

	if success and typeof(children) == "table" then
		return children
	end

	return {}
end

local function escapePathSegment(name: string) -- 1 equivalent call inferred from this helper
	if name == "" then
		return "%00"
	end

	return name:gsub("%%", "%%25"):gsub("%.", "%%2E"):gsub("%[", "%%5B"):gsub("%]", "%%5D")
end

local function unescapePathSegment(value: string) -- 1 equivalent call inferred from this helper
	if value == "%00" then
		return ""
	end

	return value:gsub("%%2E", "."):gsub("%%5B", "["):gsub("%%5D", "]"):gsub("%%25", "%%")
end

local function getChildPathEntries(p)
	local v = safeGetChildren(p) -- inferred equivalent call
	local v2 = {}

	for _, v3 in v do
		v2[v3.Name] = (v2[v3.Name] or 0) + 1
	end

	local v3 = {}
	local childPathEntries = {}

	for _, instance in v do
		local name = instance.Name
		local v4 = (v3[name] or 0) + 1
		v3[name] = v4
		local v5 = not (v2[name] > 1) and "" or `[{v4}]`
		table.insert(childPathEntries, {
			instance = instance,
			segment = escapePathSegment(name) .. v5 -- inferred equivalent call
		})
	end

	return childPathEntries
end

local function formatChildSegment(instance)
	if instance.Parent ~= nil then
		for _, v in getChildPathEntries(instance.Parent) do
			if v.instance == instance then
				return v.segment
			end
		end
	end

	return escapePathSegment(instance.Name)
end

local function appendPathSegment(p: string, p2: string) -- 3 equivalent calls inferred from this helper
	if p == "" then
		return p2
	end

	return `{p}.{p2}`
end

local function splitPath(value: string)
	local v = value:gsub("^game%.", ""):gsub("^game$", "")
	local result = {}

	for k in string.gmatch(v, "[^%.]+") do
		if k ~= "" then
			table.insert(result, k)
		end
	end

	return result
end

local function parsePathSegment(value: string) -- 2 equivalent calls inferred from this helper
	local v, v2 = string.match(value, "^(.*)%[(%d+)%]$")
	return unescapePathSegment(v or value), tonumber(v2) or 1 -- inferred equivalent call
end

local function findChild(p, p2: string, p3: number)
	local success, children = pcall(p.GetChildren, p)
	local count = 0

	for _, v in (not success or typeof(children) ~= "table") and {} or children do
		if v.Name ~= p2 then
			continue
		end

		count += 1

		if count == p3 then
			return v
		end
	end

	return nil
end

local function resolvePath(value: string?, data)
	if value == nil or value == "" or string.lower(value) == "game" then
		return data.root, ""
	end

	local v = splitPath(value)

	if #v == 0 then
		return data.root, ""
	end

	local pathSegment = parsePathSegment(v[1]) -- inferred equivalent call
	local v2 = data.getService(pathSegment)

	if v2 == nil then
		return nil, nil
	end

	local v3, name, v4

	if v2.Parent == nil then
		v3 = v2
		name = v3.Name

		if name == "" then
			v4 = "%00"
		else
			v4 = name:gsub("%%", "%%25"):gsub("%.", "%%2E"):gsub("%[", "%%5B"):gsub("%]", "%%5D")
		end
	else
		v3 = v2
		local flag = true

		for _, v5 in getChildPathEntries(v2.Parent) do
			if v5.instance == v3 then
				v4 = v5.segment
				flag = false
				break
			end
		end

		if flag then
			name = v3.Name

			if name == "" then
				v4 = "%00"
			else
				v4 = name:gsub("%%", "%%25"):gsub("%.", "%%2E"):gsub("%[", "%%5B"):gsub("%]", "%%5D")
			end
		end
	end

	local v5

	for i = 2, #v do
		local pathSegment2, v6 = parsePathSegment(v[i]) -- inferred equivalent call

		if v2 == data.players and pathSegment2 == "LocalPlayer" then
			v2 = data.localPlayer
			v5 = v2
		else
			local success, children = pcall(v2.GetChildren, v2)
			local count = 0
			v5 = nil

			for _, v7 in (not success or typeof(children) ~= "table") and {} or children do
				if v7.Name ~= pathSegment2 then
					continue
				end

				count += 1

				if count == v6 then
					v5 = v7
					break
				end
			end
		end

		if v5 == nil then
			return nil, nil
		end

		if v5 == data.localPlayer then
			v4 = `{v4}.LocalPlayer`
		else
			local v7, name2, v8

			if v5.Parent == nil then
				v7 = v5
				name2 = v7.Name

				if name2 == "" then
					v8 = "%00"
				else
					v8 = name2:gsub("%%", "%%25"):gsub("%.", "%%2E"):gsub("%[", "%%5B"):gsub("%]", "%%5D")
				end
			else
				v7 = v5
				local flag = true

				for _, v9 in getChildPathEntries(v5.Parent) do
					if v9.instance == v7 then
						v8 = v9.segment
						flag = false
						break
					end
				end

				if flag then
					name2 = v7.Name

					if name2 == "" then
						v8 = "%00"
					else
						v8 = name2:gsub("%%", "%%25"):gsub("%.", "%%2E"):gsub("%[", "%%5B"):gsub("%]", "%%5D")
					end
				end
			end

			v4 = appendPathSegment(v4, v8) -- inferred equivalent call
		end
	end

	return v5, v4
end

local function getDisplayPath(p, p2)
	local v = p
	local v2 = {}

	while v ~= nil and v ~= p2.root do
		if v == p2.localPlayer then
			table.insert(v2, 1, "LocalPlayer")
			table.insert(v2, 1, "Players")
			return table.concat(v2, ".")
		end

		table.insert(v2, 1, formatChildSegment(v))
		v = v.Parent
	end

	if v == p2.root then
		return (table.concat(v2, "."))
	end

	return (tostring(p))
end

local function truncateString(value: string)
	if #value <= 4096 then
		return value
	end

	local v = 4082

	while v > 0 do
		local v2 = string.byte(value, v)

		if v2 == nil or v2 < 128 or v2 >= 192 then
			break
		end

		v -= 1
	end

	local v2 = 4082
	local v3

	if v > 0 then
		v3 = string.byte(value, v)
	end

	if v3 ~= nil and v + (v3 < 128 and 1 or v3 < 224 and 2 or v3 < 240 and 3 or v3 < 248 and 4 or 1) - 1 > 4082 then
		v2 = v - 1
	end

	return string.sub(value, 1, (math.max(v2, 0))) .. "...<truncated>"
end

local function serializeValue(items, p, value: number?)
	local typeName = typeof(items)

	if typeName == "nil" or typeName == "boolean" then
		return items
	end

	if typeName == "string" then
		return truncateString(items)
	end

	if typeName == "number" then
		if items == items and items ~= 1e999 and items ~= -1e999 then
			return items
		end

		return (tostring(items))
	end

	if typeName == "Instance" then
		return getDisplayPath(items, p)
	end

	if typeName == "table" then
		local v = value or 0

		if v >= 2 then
			return "<table>"
		end

		local count = 0
		local result = {}

		for k, item in items do
			count += 1

			if count > 50 then
				result.__truncated = true
				return result
			end

			result[truncateString(tostring(k))] = serializeValue(item, p, v + 1)
		end

		return result
	else
		local success, result = pcall(tostring, items)

		if success then
			return truncateString(result)
		end

		return `<unserializable {typeName}>`
	end
end

local function countDescendants(p)
	local success, children = pcall(p.GetChildren, p)

	local v = {}
	local v2 = 10000
	local v3 = false

	for _, v4 in (not success or typeof(children) ~= "table") and {} or children do
		if v2 <= #v then
			v3 = true
			break
		end

		table.insert(v, v4)
	end

	local count = 0

	while #v > 0 and v2 > 0 do
		local v4 = table.remove(v)
		count += 1
		v2 -= 1
		local success2, children2 = pcall(v4.GetChildren, v4)

		for _, v5 in (not success2 or typeof(children2) ~= "table") and {} or children2 do
			if v2 <= #v then
				v3 = true
				break
			end

			table.insert(v, v5)
		end
	end

	return count, v3 or #v > 0
end

local function countDescendantsByInstance(path)
	local v = {
		{ instance = path, expanded = false }
	}
	local result = {}
	local v2 = false
	local v3 = {}
	local v4 = 1

	while #v > 0 do
		local v5 = table.remove(v)

		if v5 == nil then
			break
		end

		if v5.expanded then
			local total = 0

			for _, v6 in v3[v5.instance] or {} do
				total += 1 + (result[v6] or 0)
			end

			result[v5.instance] = total
		else
			local v6 = safeGetChildren(v5.instance) -- inferred equivalent call
			v3[v5.instance] = v6
			table.insert(v, { instance = v5.instance, expanded = true })

			for i = #v6, 1, -1 do
				if v4 >= 10000 then
					v2 = true
					break
				end

				v4 += 1
				table.insert(v, { instance = v6[i], expanded = false })
			end
		end
	end

	return result, v2
end

local function summarizeChildren(path, p: string)
	local childPathEntries = getChildPathEntries(path)
	local immediateChildren = {}

	for k, childPathEntry in childPathEntries do
		if k > 100 then
			break
		end

		local v = {
			className = childPathEntry.instance.ClassName,
			path = appendPathSegment(p, childPathEntry.segment) -- inferred equivalent call
		}
		table.insert(immediateChildren, v)
	end

	local totalDescendants, v = countDescendants(path)
	local truncated = #childPathEntries > #immediateChildren or v
	return {
		immediateChildren = immediateChildren,
		childrenCount = #childPathEntries,
		totalDescendants = totalDescendants,
		truncated = truncated
	}, truncated
end

local function getPropertyNames(instance, p)
	local propertyNames = {}
	local set = {}

	local function addName(name) -- 1 equivalent call inferred from this helper
		if typeof(name) == "string" and name ~= "" and not set[name] and #propertyNames < 256 then
			set[name] = true
			table.insert(propertyNames, name)
		end
	end

	for _, v in p.getReflectionProperties(instance.ClassName) do
		if typeof(v) == "table" then
			addName(v.Name) -- inferred equivalent call
		end
	end

	table.sort(propertyNames)
	return propertyNames
end

local function collectProperties(path, p)
	local properties = {}

	for _, v in getPropertyNames(path, p) do
		local success, result = pcall(function()
			return path[v]
		end)

		if success and result ~= nil then
			properties[v] = serializeValue(result, p)
		end
	end

	return properties
end

local function collectAttributes(path, p)
	local success, attributes = pcall(path.GetAttributes, path)

	if not success or typeof(attributes) ~= "table" then
		return {}
	end

	local v = {}
	local result = {}

	for k in attributes do
		table.insert(v, k)
	end

	table.sort(v)

	for k, v2 in v do
		if k > 100 then
			break
		end

		result[v2] = serializeValue(attributes[v2], p)
	end

	return result
end

local function invalidInput(message: string) -- 1 equivalent call inferred from this helper
	return { status = "invalid_input", message = message }
end

local function notInGame() -- 2 equivalent calls inferred from this helper
	return { status = "not_in_game", message = "The user is not in the game." }
end

local function notFound(path: string) -- 2 equivalent calls inferred from this helper
	return {
		status = "not_found",
		path = path,
		message = "No instance exists at the requested path."
	}
end

local function getOptionalString(p, p2: string) -- 4 equivalent calls inferred from this helper
	if typeof(p) ~= "table" then
		return nil
	end

	local v = p[p2]
	return if typeof(v) == "string" and v ~= "" then v else nil
end

local function getBoundedInteger(p, p2: string, p3: number, min: number, max: number) -- 2 equivalent calls inferred from this helper
	if typeof(p) == "table" and typeof(p[p2]) == "number" then
		return (math.clamp(math.floor(p[p2]), min, max))
	end

	return p3
end

local function getKeywords(p)
	local optionalString = getOptionalString(p, "keywords") -- inferred equivalent call

	if optionalString == nil then
		return {}
	end

	local result = {}

	for k in string.gmatch(string.lower(optionalString), "[^,%s]+") do
		table.insert(result, k)
	end

	return result
end

local function matchesFilters(instance, optionalString: string?, keywords): boolean
	if optionalString ~= nil then
		local success, result = pcall(instance.IsA, instance, optionalString)

		if not (success and result) then
			return false
		end
	end

	local name = string.lower(instance.Name)

	for _, item in keywords do
		if not string.find(name, item, 1, true) then
			return false
		end
	end

	return true
end

local function makeSearchMatch(instance, path: string)
	local parent = instance.Parent
	local searchMatch = {
		_instance = instance,
		name = instance.Name,
		className = instance.ClassName,
		path = path,
		parentName = 0,
		childrenCount = 0
	}
	local parentName

	if parent ~= nil then
		parentName = parent.Name
	end

	searchMatch.parentName = parentName
	searchMatch.childrenCount = #safeGetChildren(instance) -- inferred equivalent call
	return searchMatch
end

local ClientDataModelCollector = {}
ClientDataModelCollector.NOT_IN_GAME_MESSAGE = "The user is not in the game."
ClientDataModelCollector.NOT_FOUND_MESSAGE = "No instance exists at the requested path."

function ClientDataModelCollector.getInstancePath(p, p2)
	return getDisplayPath(p, p2 or defaultDependencies())
end

function ClientDataModelCollector.resolveInstancePath(p: string, p2: string, p3)
	local path, v = resolvePath(p, p3 or defaultDependencies())
	return if not (path == nil or path.ClassName ~= p2) then v else nil
end

function ClientDataModelCollector.searchClientDataModel(p, p2)
	local v = p2 or defaultDependencies()

	if v.gameId == 0 then
		return notInGame() -- inferred equivalent call
	end

	local optionalString = getOptionalString(p, "path") -- inferred equivalent call
	local path, path2 = resolvePath(optionalString, v)

	if path == nil or path2 == nil then
		return notFound(optionalString or "") -- inferred equivalent call
	end

	local boundedInteger = getBoundedInteger(p, "max_depth", 3, 0, 10) -- inferred equivalent call
	local boundedInteger2 = getBoundedInteger(p, "head_limit", 200, 1, 200) -- inferred equivalent call
	local optionalString2 = getOptionalString(p, "instance_type") -- inferred equivalent call
	local keywords = getKeywords(p)

	local v2 = {}

	if path2 == "" then
		for _, v3 in getChildPathEntries(path) do
			table.insert(v2, { instance = v3.instance, path = v3.segment, depth = 1 })
		end
	else
		table.insert(v2, { instance = path, path = path2, depth = 0 })
	end

	local v3 = 1
	local count = 0
	local matches = {}
	local truncated = false
	local count2 = 0

	while v3 <= #v2 do
		if count >= 10000 then
			truncated = true
			break
		end

		local v4 = v2[v3]
		v3 += 1
		count += 1

		if matchesFilters(v4.instance, optionalString2, keywords) then
			count2 += 1

			if #matches < boundedInteger2 then
				table.insert(matches, makeSearchMatch(v4.instance, v4.path))
			else
				truncated = true
			end
		end

		if not (v4.depth < boundedInteger) then
			continue
		end

		for _, v5 in getChildPathEntries(v4.instance) do
			if count + (#v2 - v3 + 1) >= 10000 then
				truncated = true
				break
			else
				local v6 = {
					instance = v5.instance,
					path = appendPathSegment(v4.path, v5.segment), -- inferred equivalent call
					depth = v4.depth + 1
				}
				table.insert(v2, v6)
			end
		end
	end

	if #matches > 0 then
		local v4, v5 = countDescendantsByInstance(path)

		for _, v6 in matches do
			v6.totalDescendants = v4[v6._instance] or 0
			v6._instance = nil
		end

		truncated = truncated or v5
	end

	return {
		status = "ok",
		matches = matches,
		count = #matches,
		totalFound = count2,
		truncated = truncated
	}
end

function ClientDataModelCollector.inspectClientInstance(p, p2)
	local v = p2 or defaultDependencies()

	if v.gameId == 0 then
		return notInGame() -- inferred equivalent call
	end

	local optionalString = getOptionalString(p, "path") -- inferred equivalent call

	if optionalString == nil then
		return invalidInput("path is required") -- inferred equivalent call
	end

	local path, path2 = resolvePath(optionalString, v)

	if path == nil or path2 == nil then
		return notFound(optionalString) -- inferred equivalent call
	end

	local children = summarizeChildren(path, path2)
	return {
		status = "ok",
		instance = {
			name = path.Name,
			className = path.ClassName,
			path = path2,
			properties = collectProperties(path, v),
			attributes = collectAttributes(path, v),
			children = children
		}
	}
end

return ClientDataModelCollector
