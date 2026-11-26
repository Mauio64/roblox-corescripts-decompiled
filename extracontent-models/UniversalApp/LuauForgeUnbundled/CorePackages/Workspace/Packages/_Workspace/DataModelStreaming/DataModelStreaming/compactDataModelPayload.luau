local v5 = { "-inf", "-inf", "inf", "inf" }

local v6 = { 0, 0 }

local v7 = { 0, 0, 0, 0 }

local function roundToDecimalPrecision(p2)
	if p2 >= 0 then
		return math.floor(p2 * 100000 + 0.5) / 100000
	end

	return math.ceil(p2 * 100000 - 0.5) / 100000
end

local function applyNumericPrecision(item)
	if typeof(item) == "number" then
		if item >= 0 then
			return math.floor(item * 100000 + 0.5) / 100000
		end

		return math.ceil(item * 100000 - 0.5) / 100000
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

	for k, item in list do
		if typeof(item) ~= "number" or item ~= 0 then
			return nil
		end
	end

	if count == 2 then
		return 1
	end

	return 2
end

local function getSchemaName(p2, p3)
	local typeName = typeof(p3)
	local v8 = typeName == "boolean" and "b_" or "s_"

	local v9 = typeName == "number" and (p3 % 1 == 0 and "i_" or "n_") or v8

	return (typeName == "table" and "v_" or v9) .. p2
end

local function compressPackedProperties(items)
	local v8 = 0

	for k, item in items do
		if item ~= "" then
			v8 = k
		end
	end

	if v8 == 0 then
		return ""
	end

	local v9 = 1
	local v10 = {}

	while v9 <= v8 do
		if items[v9] == "" then
			local v11 = v9

			while v11 <= v8 and items[v11] == "" do
				v11 += 1
			end

			local v12 = v11 - v9

			if v12 > 2 then
				table.insert(v10, "-" .. tostring(v12))
			else
				for i = 1, v12 do
					table.insert(v10, "")
				end
			end

			v9 = v11
		else
			table.insert(v10, items[v9])
			v9 += 1
		end
	end

	return table.concat(v10, ",")
end

local function collectSchema(p2)
	local v8 = {}
	local function collectProperties(p3)
		for k, property in p3.Properties do
			if property == nil then
				continue
			end

			local v9 = v8
			local typeName = typeof(property)
			local v10 = typeName == "boolean" and "b_" or "s_"

			local v11 = typeName == "number" and (property % 1 == 0 and "i_" or "n_") or v10

			v9[(typeName == "table" and "v_" or v11) .. k] = true
		end

		for k, child in p3.Children do
			collectProperties(child)
		end
	end

	collectProperties(p2)

	local result = {}

	for k, v9 in v8 do
		table.insert(result, k)
	end

	table.sort(result)

	local result2 = {}

	for k, v9 in result do
		result2[v9] = k
	end

	return result, result2
end

local function compactDataModelPayload(p2)
	local v8, v9 = collectSchema(p2)

	local v10 = {}
	local v11 = { [0] = v5, [1] = v6, [2] = v7 }

	local v12 = 3
	local function serializeMappingValue(list)
		local typeName = typeof(list)

		if typeName == "nil" then
			return "nil"
		end

		if typeName == "boolean" then
			if list then
				return "b:1"
			end

			return "b:0"
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
			local v13 = table.create(count)

			for i = 1, count do
				v13[i] = serializeMappingValue(list[i])
			end

			local v14 = {}

			for k, item in list do
				if not (typeof(k) ~= "number" or k < 1 or count < k or k % 1 ~= 0) then
					continue
				end

				table.insert(v14, serializeMappingValue(k) .. "=" .. serializeMappingValue(item))
			end

			table.sort(v14)
			return "t:[" .. table.concat(v13, ",") .. "]{" .. table.concat(v14, ",") .. "}"
		end
	end

	local function mapValue(p3)
		if typeof(p3) == "table" then
			local v13 = toVectorCode(p3)

			if v13 ~= nil then
				return v13
			end
		end

		local v13 = serializeMappingValue(p3)
		local v14 = v10[v13]

		if v14 ~= nil then
			return v14
		end

		while v11[v12] ~= nil do
			v12 += 1
		end

		local v15 = v12
		v12 += 1
		v10[v13] = v15
		v11[v15] = p3
		return v15
	end

	local function encodeProperties(properties)
		local v13 = {}

		for i = 1, #v8 do
			v13[i] = ""
		end

		for k, item in properties do
			if item == nil then
				continue
			end

			local typeName = typeof(item)
			local v14 = typeName == "boolean" and "b_" or "s_"

			local v15 = typeName == "number" and (item % 1 == 0 and "i_" or "n_") or v14

			local v17 = v9[(typeName == "table" and "v_" or v15) .. k]

			if v17 ~= nil then
				v13[v17] = tostring(mapValue(applyNumericPrecision(item)))
			end
		end

		return compressPackedProperties(v13)
	end

	local v13 = {}
	local v14 = 1
	local function appendNode(child, p3)
		local v15 = v14
		v14 += 1

		local v16 = {
			id = v15,
			parentId = p3,
			p = encodeProperties(child.Properties)
		}

		local v17 = `{v16.id},{v16.parentId}`

		if v16.p ~= "" then
			v17 ..= `,{v16.p}`
		end

		table.insert(v13, v17)

		for k, child2 in child.Children do
			appendNode(child2, v15)
		end
	end

	local v15 = encodeProperties(p2.Properties)
	local v16 = "0,-1"

	if v15 ~= "" then
		v16 ..= `,{v15}`
	end

	table.insert(v13, v16)

	for k, child in p2.Children do
		appendNode(child, 0)
	end

	return { mappings = v11, root = table.concat(v13, "\n"), schema = v8 }
end

return compactDataModelPayload
