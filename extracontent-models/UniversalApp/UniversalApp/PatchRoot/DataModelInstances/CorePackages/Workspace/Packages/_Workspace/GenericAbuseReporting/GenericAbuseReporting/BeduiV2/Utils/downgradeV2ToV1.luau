local t1 = {
	list = true,
	devList = true,
	inExpChatSelection = true
}

local function deepCopy(p1) -- line: 19
	-- upvalues: deepCopy (copy)
	if type(p1) ~= "table" then
		return p1
	end

	local t2 = {}

	for v9, v10 in p1 do
		t2[v9] = deepCopy(v10)
	end

	return t2
end
local function buildStoreAsMap(t3: {[any]: any}) -- line: 30
	local t4 = {}

	for _, v14 in t3 do
		local storeAs = v14.storeAs

		if type(storeAs) == "string" and storeAs ~= "" then
			t4[storeAs] = v14.type or ""
		end
	end

	return t4
end
local function rewriteNodes(t5: {[any]: any}) -- line: 41
	-- upvalues: t1 (copy)
	for _, v18 in t5 do
		local storeAs = v18.storeAs

		if type(storeAs) == "string" and storeAs ~= "" then
			local type2 = v18.type

			v18.storeAs = nil

			if t1[type2] then
				v18.storeSelectionAsContext = storeAs
				v18.formKey = "auto-gen-legacy-" .. storeAs
			else
				v18.formKey = storeAs
			end
		end
	end
end
local function rewriteStoreRefs(p2, t6: {[any]: any}) -- line: 59
	-- upvalues: t1 (copy), rewriteStoreRefs (copy)
	if type(p2) ~= "table" then
		return
	end

	if p2["$store"] ~= nil then
		local v23 = p2["$store"]

		if type(v23) == "string" then
			local v24 = string.find(v23, ".", 1, true)
			local v25 = t6[if not v24 then v23 else string.sub(v23, 1, v24 - 1)]

			p2["$store"] = nil

			if t1[v25] then
				p2["$context"] = v23

				return
			end

			p2["$formData"] = v23
		end

		return
	end

	for _, v27 in p2 do
		rewriteStoreRefs(v27, t6)
	end
end
local function downgradeV2ToV1(p3) -- line: 85
	-- upvalues: deepCopy (copy), buildStoreAsMap (copy), rewriteNodes (copy), rewriteStoreRefs (copy)
	local v29 = deepCopy(p3)
	local v30 = buildStoreAsMap(v29.nodes or {})

	rewriteNodes(v29.nodes or {})

	if v29.resources then
		for _, v32 in v29.resources do
			rewriteStoreRefs(v32.value, v30)
		end
	end

	rewriteStoreRefs(v29.display, v30)

	if v29.nodes then
		for _, v34 in v29.nodes do
			rewriteStoreRefs(v34, v30)
		end
	end

	rewriteStoreRefs(v29.submission, v30)
	v29.version = 1

	return v29
end

return downgradeV2ToV1
