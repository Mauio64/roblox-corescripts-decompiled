local v = { "-inf", "-inf", "inf", "inf" }

local v2 = { 0, 0 }

local v3 = { 0, 0, 0, 0 }

local function roundToDecimalPrecision(value: number) -- 1 equivalent call inferred from this helper
	if value >= 0 then
		return math.floor(value * 100000 + 0.5) / 100000
	end

	return math.ceil(value * 100000 - 0.5) / 100000
end

local function applyNumericPrecision(item)
	if typeof(item) == "number" then
		return roundToDecimalPrecision(item) -- inferred equivalent call
	else
		if typeof(item) ~= "table" then
			return item
		end

		local result = {}

		for k, item2 in item do
			result[k] = applyNumericPrecision(item2)
		end

		return result
	end
end

local function toVectorCode(list): nil | number
	local count = #list

	if count ~= 2 and count ~= 4 then
		return nil
	end

	if count == 4 and list[1] == "-inf" and list[2] == "-inf" and list[3] == "inf" and list[4] == "inf" then
		return 0
	end

	for _, item in list do
		if typeof(item) ~= "number" or item ~= 0 then
			return nil
		end
	end

	return if count == 2 then 1 else 2
end

local function getSchemaName(k: string, p) -- 2 equivalent calls inferred from this helper
	local typeName = typeof(p)
	local v4 = typeName == "boolean" and "b_" or "s_"

	local v5 = typeName == "number" and (p % 1 == 0 and "i_" or "n_") or v4

	return (typeName == "table" and "v_" or v5) .. k
end

local function compressPackedProperties(items)
	local v4 = 0

	for k, item in items do
		if item ~= "" then
			v4 = k
		end
	end

	if v4 == 0 then
		return ""
	end

	local v5 = 1
	local v6 = {}

	while v5 <= v4 do
		if items[v5] == "" then
			local v7 = v5

			while v7 <= v4 and items[v7] == "" do
				v7 += 1
			end

			local v8 = v7 - v5

			if v8 > 2 then
				table.insert(v6, "-" .. tostring(v8))
			else
				for _ = 1, v8 do
					table.insert(v6, "")
				end
			end

			v5 = v7
		else
			table.insert(v6, items[v5])
			v5 += 1
		end
	end

	return table.concat(v6, ",")
end

local function collectSchema(p)
	local set = {}
	local function collectProperties(p2)
		for k, property in p2.Properties do
			if property ~= nil then
				set[getSchemaName(k, property)] = true -- inferred equivalent call
			end
		end

		for _, child in p2.Children do
			collectProperties(child)
		end
	end

	collectProperties(p)

	local result = {}

	for k, _ in set do
		table.insert(result, k)
	end

	table.sort(result)

	local result2 = {}

	for k, v4 in result do
		result2[v4] = k
	end

	return result, result2
end

local function compactDataModelPayload(p)
	local schema, v4 = collectSchema(p)

	local v5 = {}
	local mappings = { [0] = v, [1] = v2, [2] = v3 }

	local v6 = 3
	local function serializeMappingValue(list)
		local typeName = typeof(list)

		if typeName == "nil" then
			return "nil"
		end

		if typeName == "boolean" then
			return if list then "b:1" else "b:0"
		else
			if typeName == "number" then
				return "n:" .. tostring(list)
			elseif typeName == "string" then
				return "s:" .. list
			end

			if typeName ~= "table" then
				return typeName .. ":" .. tostring(list)
			end

			local count = #list
			local v7 = table.create(count)

			for i = 1, count do
				v7[i] = serializeMappingValue(list[i])
			end

			local v8 = {}

			for k, item in list do
				if not (typeof(k) ~= "number" or k < 1 or count < k or k % 1 ~= 0) then
					continue
				end

				table.insert(v8, serializeMappingValue(k) .. "=" .. serializeMappingValue(item))
			end

			table.sort(v8)
			return "t:[" .. table.concat(v7, ",") .. "]{" .. table.concat(v8, ",") .. "}"
		end
	end

	local function mapValue(p2)
		if typeof(p2) == "table" then
			local v7 = toVectorCode(p2)

			if v7 ~= nil then
				return v7
			end
		end

		local v7 = serializeMappingValue(p2)
		local v8 = v5[v7]

		if v8 ~= nil then
			return v8
		end

		while mappings[v6] ~= nil do
			v6 += 1
		end

		local v9 = v6
		v6 += 1
		v5[v7] = v9
		mappings[v9] = p2
		return v9
	end

	local function encodeProperties(properties)
		local v7 = {}

		for i = 1, #schema do
			v7[i] = ""
		end

		for k, item in properties do
			if item == nil then
				continue
			end

			local v8 = v4[getSchemaName(k, item)] -- inferred equivalent call

			if v8 ~= nil then
				v7[v8] = tostring(mapValue(applyNumericPrecision(item)))
			end
		end

		return compressPackedProperties(v7)
	end

	local v7 = {}
	local v8 = 1
	local function appendNode(child, parentId: number)
		local id = v8
		v8 += 1

		local v9 = {
			id = id,
			parentId = parentId,
			p = encodeProperties(child.Properties)
		}

		local v10 = `{v9.id},{v9.parentId}`

		if v9.p ~= "" then
			v10 ..= `,{v9.p}`
		end

		table.insert(v7, v10)

		for _, child2 in child.Children do
			appendNode(child2, id)
		end
	end

	local v9 = encodeProperties(p.Properties)
	local v10 = "0,-1"

	if v9 ~= "" then
		v10 ..= `,{v9}`
	end

	table.insert(v7, v10)

	for _, child in p.Children do
		appendNode(child, 0)
	end

	return { mappings = mappings, root = table.concat(v7, "\n"), schema = schema }
end

return compactDataModelPayload
