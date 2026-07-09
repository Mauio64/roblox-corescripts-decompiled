local t1 = {
	"-inf",
	"-inf",
	"inf",
	"inf"
}
local t2 = {
	0,
	0
}
local t3 = {
	0,
	0,
	0,
	0
}

local function roundToDecimalPrecision(n1: number) -- line: 20
	if n1 >= 0 then
		return math.floor(n1 * 100000 + 0.5) / 100000
	end

	return math.ceil(n1 * 100000 - 0.5) / 100000
end
local function applyNumericPrecision(p1) -- line: 28
	-- upvalues: applyNumericPrecision (copy)
	if typeof(p1) == "number" then
		if p1 >= 0 then
			return math.floor(p1 * 100000 + 0.5) / 100000
		end

		return math.ceil(p1 * 100000 - 0.5) / 100000
	end

	if typeof(p1) == "table" then
		local t4 = {}

		for v14, v15 in p1 do
			t4[v14] = applyNumericPrecision(v15)
		end

		return t4
	end

	return p1
end
local function toVectorCode(t5: {[any]: any}) -- line: 42
	local v17 = #t5

	if v17 ~= 2 and v17 ~= 4 then
		return nil
	end

	if v17 == 4 and t5[1] == "-inf" and t5[2] == "-inf" and t5[3] == "inf" and t5[4] == "inf" then
		return 0
	end

	for _, v19 in t5 do
		if typeof(v19) ~= "number" or v19 ~= 0 then
			return nil
		end
	end

	if v17 == 2 then
		return 1
	end

	return 2
end
local function getSchemaName(s1: string, p2) -- line: 62
	local s2 = "s_"
	local v23 = typeof(p2)

	if v23 == "boolean" then
		s2 = "b_"
	end

	if v23 == "number" then
		s2 = p2 % 1 ~= 0 and "n_" or "i_"
	end

	if v23 == "table" then
		s2 = "v_"
	end

	return s2 .. s1
end
local function compressPackedProperties(t6: {[any]: any}) -- line: 83
	local n2 = 0

	for v26, v27 in t6 do
		if v27 ~= "" then
			n2 = v26
		end
	end

	if n2 == 0 then
		return ""
	end

	local t7 = {}
	local n3 = 1

	while n3 <= n2 do
		if t6[n3] ~= "" then
			table.insert(t7, t6[n3])
			n3 += 1
		else
			local v30 = n3

			while v30 <= n2 and t6[v30] == "" do
				v30 += 1
			end

			local v31 = v30 - n3

			if v31 > 2 then
				table.insert(t7, "-" .. tostring(v31))
			else
				for _ = 1, v31 do
					table.insert(t7, "")
				end
			end

			n3 = v30
		end
	end

	return table.concat(t7, ",")
end
local function collectSchema(t8: {[any]: any}) -- line: 120
	local t9 = {}

	local function collectProperties(t10: {[any]: any}) -- line: 123
		-- upvalues: t9 (copy), collectProperties (copy)
		for v59, v60 in t10.Properties do
			if v60 ~= nil then
				local v61 = t9
				local s3 = "s_"
				local v63 = typeof(v60)

				if v63 == "boolean" then
					s3 = "b_"
				end

				if v63 == "number" then
					s3 = v60 % 1 ~= 0 and "n_" or "i_"
				end

				if v63 == "table" then
					s3 = "v_"
				end

				v61[s3 .. v59] = true
			end
		end

		for _, v65 in t10.Children do
			collectProperties(v65)
		end
	end

	collectProperties(t8)

	local t11 = {}

	for v37, _ in t9 do
		table.insert(t11, v37)
	end

	table.sort(t11)

	local t12 = {}

	for v40, v41 in t11 do
		t12[v41] = v40
	end

	return t11, t12
end
local function compactDataModelPayload(t13: {[any]: any}) -- line: 151
	-- upvalues: collectSchema (copy), t1 (copy), t2 (copy), t3 (copy), toVectorCode (copy), applyNumericPrecision (copy), compressPackedProperties (copy)
	local v43, v44 = collectSchema(t13)
	local t14 = {}
	local t15 = {
		[0] = t1,
		[1] = t2,
		[2] = t3
	}
	local n4 = 3

	local function serializeMappingValue(p3) -- line: 162
		-- upvalues: serializeMappingValue (copy)
		local v67 = typeof(p3)

		if v67 == "nil" then
			return "nil"
		end

		if v67 == "boolean" then
			if p3 then
				return "b:1"
			end

			return "b:0"
		end

		if v67 == "number" then
			return "n:" .. tostring(p3)
		end

		if v67 == "string" then
			return "s:" .. p3
		end

		if v67 == "table" then
			local v68 = #p3
			local t16 = table.create(v68)

			for i = 1, v68 do
				t16[i] = serializeMappingValue(p3[i])
			end

			local t17 = {}

			for v72, v73 in p3 do
				if typeof(v72) ~= "number" or v72 < 1 or v68 < v72 or v72 % 1 ~= 0 then
					table.insert(t17, serializeMappingValue(v72) .. "=" .. serializeMappingValue(v73))
				end
			end

			table.sort(t17)

			return "t:[" .. table.concat(t16, ",") .. "]{" .. table.concat(t17, ",") .. "}"
		end

		return v67 .. ":" .. tostring(p3)
	end
	local function mapValue(p4) -- line: 191
		-- upvalues: toVectorCode (copy), serializeMappingValue (copy), t14 (copy), t15 (copy), n4 (ref)
		if typeof(p4) == "table" then
			local v75 = toVectorCode(p4)

			if v75 ~= nil then
				return v75
			end
		end

		local v76 = serializeMappingValue(p4)
		local v77 = t14[v76]

		if v77 ~= nil then
			return v77
		end

		while t15[n4] ~= nil do
			n4 += 1
		end

		local v78 = n4

		n4 += 1
		t14[v76] = v78
		t15[v78] = p4

		return v78
	end
	local function encodeProperties(t18: {[any]: any}) -- line: 216
		-- upvalues: v43 (copy), v44 (copy), mapValue (copy), applyNumericPrecision (copy), compressPackedProperties (copy)
		local t19 = {}

		for i = 1, #v43 do
			t19[i] = ""
		end

		for v82, v83 in t18 do
			if v83 ~= nil then
				local s4 = "s_"
				local v85 = typeof(v83)

				if v85 == "boolean" then
					s4 = "b_"
				end

				if v85 == "number" then
					s4 = v83 % 1 ~= 0 and "n_" or "i_"
				end

				if v85 == "table" then
					s4 = "v_"
				end

				local v86 = v44[s4 .. v82]

				if v86 ~= nil then
					t19[v86] = tostring((mapValue((applyNumericPrecision(v83)))))
				end
			end
		end

		return compressPackedProperties(t19)
	end

	local t20 = {}
	local n5 = 1

	local function appendNode(t21: {[any]: any}, n6: number) -- line: 236
		-- upvalues: n5 (ref), encodeProperties (copy), t20 (copy), appendNode (copy)
		local v89 = n5

		n5 += 1

		local t22 = {
			id = v89,
			parentId = n6,
			p = encodeProperties(t21.Properties)
		}
		local v91 = `{ t22.id },{ t22.parentId }`

		if t22.p ~= "" then
			v91 ..= (",%*"):format(t22.p)
		end

		table.insert(t20, v91)

		for _, v93 in t21.Children do
			appendNode(v93, v89)
		end
	end

	local v54 = encodeProperties(t13.Properties)
	local s5 = "0,-1"

	if v54 ~= "" then
		s5 ..= (",%*"):format(v54)
	end

	table.insert(t20, s5)

	for _, v57 in t13.Children do
		appendNode(v57, 0)
	end

	return {
		mappings = t15,
		root = table.concat(t20, "\n"),
		schema = v43
	}
end

return compactDataModelPayload
