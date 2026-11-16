local function defaultDependencies()
	local Players = game:GetService("Players")
	return {
		gameId = game.GameId,
		root = game,
		players = Players,
		localPlayer = Players.LocalPlayer,
		getService = function(childName)
			local success, service = pcall(game.GetService, game, childName)

			if success then
				return service
			end

			return game:FindFirstChild(childName)
		end,
		getReflectionProperties = function(p2)
			local ReflectionService = game:GetService("ReflectionService")
			return ReflectionService:GetPropertiesOfClass(p2, {})
		end
	}
end

local function safeGetChildren(p2)
	local success, children = pcall(p2.GetChildren, p2)

	if success and typeof(children) == "table" then
		return children
	end

	return {}
end

local function escapePathSegment(name)
	if name == "" then
		return "%00"
	end

	return name:gsub("%%", "%%25"):gsub("%.", "%%2E"):gsub("%[", "%%5B"):gsub("%]", "%%5D")
end

local function unescapePathSegment(value)
	if value == "%00" then
		return ""
	end

	return value:gsub("%%2E", "."):gsub("%%5B", "["):gsub("%%5D", "]"):gsub("%%25", "%%")
end

local function getChildPathEntries(p2)
	local success, children = pcall(p2.GetChildren, p2)
	local v5 = (not success or typeof(children) ~= "table") and {} or children

	local v6 = {}

	for k, v7 in v5 do
		v6[v7.Name] = (v6[v7.Name] or 0) + 1
	end

	local v7 = {}
	local childPathEntries = {}

	for k, v8 in v5 do
		local name = v8.Name
		local v9 = (v7[name] or 0) + 1
		v7[name] = v9
		local v10 = not (v6[name] > 1) and "" or `[{v9}]`
		table.insert(childPathEntries, {
			instance = v8,
			segment = (name == "" and "%00" or name:gsub("%%", "%%25"):gsub("%.", "%%2E"):gsub("%[", "%%5B"):gsub(
				"%]",
				"%%5D"
			)) .. v10
		})
	end

	return childPathEntries
end

local function formatChildSegment(instance)
	if instance.Parent ~= nil then
		for k, v5 in getChildPathEntries(instance.Parent) do
			if v5.instance == instance then
				return v5.segment
			end
		end
	end

	return escapePathSegment(instance.Name)
end

local function appendPathSegment(p2, p3)
	if p2 == "" then
		return p3
	end

	return `{p2}.{p3}`
end

local function splitPath(value)
	local v5 = value:gsub("^game%.", ""):gsub("^game$", "")
	local result = {}

	for k in string.gmatch(v5, "[^%.]+") do
		if k ~= "" then
			table.insert(result, k)
		end
	end

	return result
end

local function parsePathSegment(value)
	local v5, v6 = string.match(value, "^(.*)%[(%d+)%]$")
	local v7 = v5 or value
	return
		v7 == "%00" and "" or v7:gsub("%%2E", "."):gsub("%%5B", "["):gsub("%%5D", "]"):gsub("%%25", "%%"),
		tonumber(v6) or 1
end

local function findChild(p2, p3, p4)
	local success, children = pcall(p2.GetChildren, p2)
	local count = 0

	for k, v5 in (not success or typeof(children) ~= "table") and {} or children do
		if v5.Name ~= p3 then
			continue
		end

		count += 1

		if count == p4 then
			return v5
		end
	end

	return nil
end

local function resolvePath(value, data)
	if value == nil or value == "" or string.lower(value) == "game" then
		return data.root, ""
	end

	local v5 = splitPath(value)

	if #v5 == 0 then
		return data.root, ""
	end

	local v6 = v5[1]
	local v7, v8 = string.match(v6, "^(.*)%[(%d+)%]$")
	local v9 = v7 or v6
	local v10 = v9 == "%00" and ""
		or v9:gsub("%%2E", "."):gsub("%%5B", "["):gsub("%%5D", "]"):gsub("%%25", "%%")

	local v11 = tonumber(v8) or 1

	local v12 = data.getService(v10)

	if v12 == nil then
		return nil, nil
	end

	local v13, name, v14

	if v12.Parent == nil then
		v13 = v12
		name = v13.Name

		if name == "" then
			v14 = "%00"
		else
			v14 = name:gsub("%%", "%%25"):gsub("%.", "%%2E"):gsub("%[", "%%5B"):gsub("%]", "%%5D")
		end
	else
		v13 = v12
		local flag = true

		for k, v15 in getChildPathEntries(v12.Parent) do
			if v15.instance == v13 then
				v14 = v15.segment
				flag = false
				break
			end
		end

		if flag then
			name = v13.Name

			if name == "" then
				v14 = "%00"
			else
				v14 = name:gsub("%%", "%%25"):gsub("%.", "%%2E"):gsub("%[", "%%5B"):gsub("%]", "%%5D")
			end
		end
	end

	local v15

	for i = 2, #v5 do
		local v16 = v5[i]
		local v17, v18 = string.match(v16, "^(.*)%[(%d+)%]$")
		local v19 = v17 or v16
		local v20 = v19 == "%00" and ""
			or v19:gsub("%%2E", "."):gsub("%%5B", "["):gsub("%%5D", "]"):gsub("%%25", "%%")

		local v21 = tonumber(v18) or 1

		if v12 == data.players and v20 == "LocalPlayer" then
			v12 = data.localPlayer
			v15 = v12
		else
			local success, children = pcall(v12.GetChildren, v12)
			local count = 0
			v15 = nil

			for k, v23 in (not success or typeof(children) ~= "table") and {} or children do
				if v23.Name ~= v20 then
					continue
				end

				count += 1

				if count == v21 then
					v15 = v23
					break
				end
			end
		end

		if v15 == nil then
			return nil, nil
		end

		if v15 == data.localPlayer then
			v14 = `{v14}.LocalPlayer`
		else
			local v22, name2, v23

			if v15.Parent == nil then
				v22 = v15
				name2 = v22.Name

				if name2 == "" then
					v23 = "%00"
				else
					v23 = name2:gsub("%%", "%%25"):gsub("%.", "%%2E"):gsub("%[", "%%5B"):gsub("%]", "%%5D")
				end
			else
				v22 = v15
				local flag = true

				for k, v24 in getChildPathEntries(v15.Parent) do
					if v24.instance == v22 then
						v23 = v24.segment
						flag = false
						break
					end
				end

				if flag then
					name2 = v22.Name

					if name2 == "" then
						v23 = "%00"
					else
						v23 = name2:gsub("%%", "%%25"):gsub("%.", "%%2E"):gsub("%[", "%%5B"):gsub(
							"%]",
							"%%5D"
						)
					end
				end
			end

			v14 = if v14 == "" then v23 else `{v14}.{v23}`
		end
	end

	return v15, v14
end

local function getDisplayPath(p2, p3)
	local v5 = p2
	local v6 = {}

	while v5 ~= nil and v5 ~= p3.root do
		if v5 == p3.localPlayer then
			table.insert(v6, 1, "LocalPlayer")
			table.insert(v6, 1, "Players")
			return table.concat(v6, ".")
		end

		table.insert(v6, 1, formatChildSegment(v5))
		v5 = v5.Parent
	end

	if v5 == p3.root then
		return (table.concat(v6, "."))
	end

	return (tostring(p2))
end

local function truncateString(value)
	if #value <= 4096 then
		return value
	end

	local v5 = 4082

	while v5 > 0 do
		local v6 = string.byte(value, v5)

		if v6 == nil or v6 < 128 or v6 >= 192 then
			break
		end

		v5 -= 1
	end

	local v6 = 4082
	local v7 = if v5 > 0 then string.byte(value, v5) else nil

	if
		v7 ~= nil
		and v5 + (v7 < 128 and 1 or v7 < 224 and 2 or v7 < 240 and 3 or v7 < 248 and 4 or 1) - 1 > 4082
	then
		v6 = v5 - 1
	end

	return string.sub(value, 1, ((math.max)(v6, 0))) .. "...<truncated>"
end

local function serializeValue(items, p2, value)
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
		return getDisplayPath(items, p2)
	end

	if typeName == "table" then
		local v5 = value or 0

		if v5 >= 2 then
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

			result[truncateString(tostring(k))] = serializeValue(item, p2, v5 + 1)
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

local function countDescendants(p2)
	local success, children = pcall(p2.GetChildren, p2)

	local v5 = {}
	local v6 = 10000
	local v7 = false

	for k, v9 in (not success or typeof(children) ~= "table") and {} or children do
		if v6 <= #v5 then
			v7 = true
			break
		end

		table.insert(v5, v9)
	end

	local count = 0

	while #v5 > 0 and v6 > 0 do
		local v9 = table.remove(v5)
		count += 1
		v6 -= 1
		local success2, children2 = pcall(v9.GetChildren, v9)

		for k, v11 in (not success2 or typeof(children2) ~= "table") and {} or children2 do
			if v6 <= #v5 then
				v7 = true
				break
			end

			table.insert(v5, v11)
		end
	end

	return count, v7 or #v5 > 0
end

local function countDescendantsByInstance(path)
	local v5 = {
		{ instance = path, expanded = false }
	}
	local result = {}
	local v6 = false
	local v7 = {}
	local v8 = 1

	while #v5 > 0 do
		local v9 = table.remove(v5)

		if v9 == nil then
			break
		end

		if v9.expanded then
			local total = 0

			for k, v10 in v7[v9.instance] or {} do
				total += 1 + (result[v10] or 0)
			end

			result[v9.instance] = total
		else
			local instance = v9.instance
			local success, children = pcall(instance.GetChildren, instance)
			local v10 = (not success or typeof(children) ~= "table") and {} or children

			v7[v9.instance] = v10
			table.insert(v5, { instance = v9.instance, expanded = true })

			for i = #v10, 1, -1 do
				if v8 >= 10000 then
					v6 = true
					break
				end

				v8 += 1
				table.insert(v5, { instance = v10[i], expanded = false })
			end
		end
	end

	return result, v6
end

local function summarizeChildren(path, p2)
	local childPathEntries = getChildPathEntries(path)
	local v5 = {}

	for k, childPathEntry in childPathEntries do
		if k > 100 then
			break
		end

		local v6 = { className = childPathEntry.instance.ClassName, path = 0 }
		local segment = childPathEntry.segment

		if p2 ~= "" then
			segment = `{p2}.{segment}`
		end

		v6.path = segment
		table.insert(v5, v6)
	end

	local v6, v7 = countDescendants(path)
	local v8 = #childPathEntries > #v5 or v7
	return {
		immediateChildren = v5,
		childrenCount = #childPathEntries,
		totalDescendants = v6,
		truncated = v8
	}, v8
end

local function getPropertyNames(instance, p2)
	local propertyNames = {}
	local set = {}

	local function addName(value)
		if typeof(value) == "string" and value ~= "" and not set[value] and #propertyNames < 256 then
			set[value] = true
			table.insert(propertyNames, value)
		end
	end

	for k, v5 in p2.getReflectionProperties(instance.ClassName) do
		if typeof(v5) ~= "table" then
			continue
		end

		local name = v5.Name

		if typeof(name) ~= "string" or name == "" or set[name] or not (#propertyNames < 256) then
			continue
		end

		set[name] = true
		table.insert(propertyNames, name)
	end

	table.sort(propertyNames)
	return propertyNames
end

local function collectProperties(path, p2)
	local properties = {}

	for k, v5 in getPropertyNames(path, p2) do
		local success, result = pcall(function()
			return path[v5]
		end)

		if success and result ~= nil then
			properties[v5] = serializeValue(result, p2)
		end
	end

	return properties
end

local function collectAttributes(path, p2)
	local success, attributes = pcall(path.GetAttributes, path)

	if not success or typeof(attributes) ~= "table" then
		return {}
	end

	local v5 = {}
	local result = {}

	for k in attributes do
		table.insert(v5, k)
	end

	table.sort(v5)

	for k, v6 in v5 do
		if k > 100 then
			break
		end

		result[v6] = serializeValue(attributes[v6], p2)
	end

	return result
end

local function invalidInput(p2)
	return { status = "invalid_input", message = p2 }
end

local function notInGame()
	return { status = "not_in_game", message = "The user is not in the game." }
end

local function notFound(p2)
	return {
		status = "not_found",
		path = p2,
		message = "No instance exists at the requested path."
	}
end

local function getOptionalString(p2, p3)
	if typeof(p2) ~= "table" then
		return nil
	end

	local v5 = p2[p3]

	if typeof(v5) == "string" and v5 ~= "" then
		return v5
	end

	return nil
end

local function getBoundedInteger(p2, p3, p4, min, max)
	if typeof(p2) == "table" and typeof(p2[p3]) == "number" then
		return (math.clamp(math.floor(p2[p3]), min, max))
	end

	return p4
end

local function getKeywords(data)
	local keywords

	if typeof(data) == "table" then
		keywords = data.keywords

		if typeof(keywords) ~= "string" or keywords == "" then
			keywords = nil
		end
	end

	if keywords == nil then
		return {}
	end

	local result = {}

	for k in string.gmatch(string.lower(keywords), "[^,%s]+") do
		table.insert(result, k)
	end

	return result
end

local function matchesFilters(instance, instance_type, keywords): boolean
	if instance_type ~= nil then
		local success, result = pcall(instance.IsA, instance, instance_type)

		if not (success and result) then
			return false
		end
	end

	local name = string.lower(instance.Name)

	for k, item in keywords do
		if not string.find(name, item, 1, true) then
			return false
		end
	end

	return true
end

local function makeSearchMatch(instance, path)
	local parent = instance.Parent
	local searchMatch = {
		_instance = instance,
		name = instance.Name,
		className = instance.ClassName,
		path = path,
		parentName = 0,
		childrenCount = 0
	}

	local v5 = if parent ~= nil then parent.Name else nil
	searchMatch.parentName = v5
	local success, children = pcall(instance.GetChildren, instance)
	searchMatch.childrenCount = #((not success or typeof(children) ~= "table") and {} or children)
	return searchMatch
end

return {
	NOT_IN_GAME_MESSAGE = "The user is not in the game.",
	NOT_FOUND_MESSAGE = "No instance exists at the requested path.",
	getInstancePath = function(p2, p3)
		return getDisplayPath(p2, p3 or defaultDependencies())
	end,
	resolveInstancePath = function(p2, p3, p4)
		local path, v5 = resolvePath(p2, p4 or defaultDependencies())

		if path == nil or path.ClassName ~= p3 then
			return nil
		end

		return v5
	end,
	searchClientDataModel = function(data, p2)
		local v5 = p2 or defaultDependencies()

		if v5.gameId == 0 then
			return { status = "not_in_game", message = "The user is not in the game." }
		end

		local path

		if typeof(data) == "table" then
			path = data.path

			if typeof(path) ~= "string" or path == "" then
				path = nil
			end
		end

		local path2, v6 = resolvePath(path, v5)

		if path2 == nil or v6 == nil then
			return {
				status = "not_found",
				path = path or "",
				message = "No instance exists at the requested path."
			}
		end

		local v7 = (typeof(data) ~= "table" or typeof(data.max_depth) ~= "number") and 3
			or math.clamp(math.floor(data.max_depth), 0, 10)
		local v8 = (typeof(data) ~= "table" or typeof(data.head_limit) ~= "number") and 200
			or math.clamp(math.floor(data.head_limit), 1, 200)
		local instance_type

		if typeof(data) == "table" then
			instance_type = data.instance_type

			if typeof(instance_type) ~= "string" or instance_type == "" then
				instance_type = nil
			end
		end

		local keywords = getKeywords(data)

		local v9 = {}

		if v6 == "" then
			for k, v10 in getChildPathEntries(path2) do
				table.insert(v9, {
					instance = v10.instance,
					path = v10.segment,
					depth = 1
				})
			end
		else
			table.insert(v9, { instance = path2, path = v6, depth = 0 })
		end

		local v10 = 1
		local count = 0
		local v11 = {}
		local v12 = false
		local count2 = 0

		while v10 <= #v9 do
			if count >= 10000 then
				v12 = true
				break
			end

			local v13 = v9[v10]
			v10 += 1
			count += 1

			if matchesFilters(v13.instance, instance_type, keywords) then
				count2 += 1

				if #v11 < v8 then
					table.insert(v11, makeSearchMatch(v13.instance, v13.path))
				else
					v12 = true
				end
			end

			if not (v13.depth < v7) then
				continue
			end

			for k, v15 in getChildPathEntries(v13.instance) do
				if count + (#v9 - v10 + 1) >= 10000 then
					v12 = true
					break
				else
					local v16 = { instance = v15.instance, path = 0, depth = 0 }
					local path3 = v13.path
					local segment = v15.segment

					if path3 ~= "" then
						segment = `{path3}.{segment}`
					end

					v16.path = segment
					v16.depth = v13.depth + 1
					table.insert(v9, v16)
				end
			end
		end

		if #v11 > 0 then
			local v13, v14 = countDescendantsByInstance(path2)

			for k, v15 in v11 do
				v15.totalDescendants = v13[v15._instance] or 0
				v15._instance = nil
			end

			v12 = v12 or v14
		end

		return {
			status = "ok",
			matches = v11,
			count = #v11,
			totalFound = count2,
			truncated = v12
		}
	end,
	inspectClientInstance = function(p2, p3)
		local v5 = p3 or defaultDependencies()

		if v5.gameId == 0 then
			return { status = "not_in_game", message = "The user is not in the game." }
		end

		local path

		if typeof(p2) == "table" then
			path = p2.path

			if typeof(path) ~= "string" or path == "" then
				path = nil
			end
		end

		if path == nil then
			return { status = "invalid_input", message = "path is required" }
		end

		local path2, v6 = resolvePath(path, v5)

		if path2 == nil or v6 == nil then
			return {
				status = "not_found",
				path = path,
				message = "No instance exists at the requested path."
			}
		end

		local v7 = summarizeChildren(path2, v6)
		return {
			status = "ok",
			instance = {
				name = path2.Name,
				className = path2.ClassName,
				path = v6,
				properties = collectProperties(path2, v5),
				attributes = collectAttributes(path2, v5),
				children = v7
			}
		}
	end
}
