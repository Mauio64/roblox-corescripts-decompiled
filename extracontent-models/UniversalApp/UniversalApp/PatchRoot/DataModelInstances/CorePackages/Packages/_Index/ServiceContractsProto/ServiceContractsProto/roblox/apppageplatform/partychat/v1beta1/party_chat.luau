local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local hydration_content = require(script.Parent.Parent.Parent.shared.v1beta1.hydration_content)
local template_entry = require(script.Parent.Parent.Parent.shared.v1beta1.template_entry)
local page_entry_content = require(script.Parent.Parent.Parent.shared.v1beta1.page_entry_content)
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 112
	-- upvalues: t2 (copy)
	return (setmetatable({
		page_entries = if t3 ~= nil and t3.page_entries ~= nil then t3.page_entries else {},
		hydration_data = if t3 ~= nil and t3.hydration_data ~= nil then t3.hydration_data else nil,
		templates = if t3 ~= nil and t3.templates ~= nil then t3.templates else {},
		localized_literals = if t3 ~= nil and t3.localized_literals ~= nil then t3.localized_literals else {}
	}, t2))
end
function t2.encode(p1) -- line: 121
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.page_entries ~= nil and #p1.page_entries > 0 then
		for _, v15 in p1.page_entries do
			local v16 = v15:encode()
			local v17, v18 = proto.writeTag(buf, n1, 1, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v17, v18, v16, buffer.len(v16))
		end
	end

	if p1.hydration_data ~= nil then
		local v19 = p1.hydration_data:encode()
		local v20, v21 = proto.writeTag(buf, n1, 2, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeBuffer(v20, v21, v19, buffer.len(v19))
	end

	if p1.templates ~= nil and next(p1.templates) ~= nil then
		for v22, v23 in p1.templates do
			local buf2 = buffer.create(0)
			local v25, v26 = proto.writeTag(buf2, 0, 1, proto.wireTypes.lengthDelimited)
			local v27, v28 = proto.writeString(v25, v26, v22)
			local v29 = v23:encode()
			local v30, v31 = proto.writeTag(v27, v28, 2, proto.wireTypes.lengthDelimited)
			local v32, v33 = proto.writeBuffer(v30, v31, v29, buffer.len(v29))
			local v34, v35 = proto.writeTag(buf, n1, 3, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v34, v35, v32, v33)
		end
	end

	if p1.localized_literals ~= nil and next(p1.localized_literals) ~= nil then
		for v36, v37 in p1.localized_literals do
			local buf3 = buffer.create(0)
			local v39, v40 = proto.writeTag(buf3, 0, 1, proto.wireTypes.lengthDelimited)
			local v41, v42 = proto.writeString(v39, v40, v36)
			local v43, v44 = proto.writeTag(v41, v42, 2, proto.wireTypes.lengthDelimited)
			local v45, v46 = proto.writeString(v43, v44, v37)
			local v47, v48 = proto.writeTag(buf, n1, 4, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v47, v48, v45, v46)
		end
	end

	local buf4 = buffer.create(n1)

	buffer.copy(buf4, 0, buf, 0, n1)

	return buf4
end
function t2.decode(p2: buffer) -- line: 171
	-- upvalues: t2 (copy), proto (copy), page_entry_content (copy), hydration_content (copy), t1 (copy), template_entry (copy)
	local v51 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v53, v54

		v53, v54, n2 = proto.readTag(p2, n2)

		if v54 == proto.wireTypes.varint then
			local v55

			v55, n2 = proto.readVarInt(p2, n2)
		elseif v54 == proto.wireTypes.lengthDelimited then
			if v53 == 1 then
				local v56

				v56, n2 = proto.readBuffer(p2, n2)
				table.insert(v51.page_entries, page_entry_content.UniversalPageEntry.decode(v56))
			elseif v53 == 2 then
				local v57

				v57, n2 = proto.readBuffer(p2, n2)
				v51.hydration_data = hydration_content.HydrationContent.decode(v57)
			elseif v53 == 3 then
				local v58

				v58, n2 = proto.readBuffer(p2, n2)

				local v59 = t1.PartyChatResponse_TemplatesEntry.decode(v58)
				local v60 = template_entry.TemplateEntry.new()

				v51.templates[v59.key or ""] = v59.value or v60
			elseif v53 == 4 then
				local v61

				v61, n2 = proto.readBuffer(p2, n2)

				local v62 = t1.PartyChatResponse_LocalizedLiteralsEntry.decode(v61)

				v51.localized_literals[v62.key or ""] = v62.value or ""
			else
				local v63, v64 = proto.readVarInt(p2, n2)

				n2 = v64 + v63
			end
		elseif v54 == proto.wireTypes.i32 then
			local v65

			v65, n2 = proto.readFixed32(p2, n2)
		elseif v54 == proto.wireTypes.i64 then
			local v66

			v66, n2 = proto.readFixed64(p2, n2)
		else
			error("Unsupported wire type: " .. v54)
		end
	end

	return v51
end
function t2.jsonEncode(p3) -- line: 247
	local t4 = {}

	if p3.page_entries ~= nil and #p3.page_entries > 0 then
		local t5 = {}

		for _, v71 in p3.page_entries do
			table.insert(t5, v71:jsonEncode())
		end

		t4.pageEntries = t5
	end

	if p3.hydration_data ~= nil then
		t4.hydrationData = p3.hydration_data:jsonEncode()
	end

	if p3.templates ~= nil and next(p3.templates) ~= nil then
		local t6 = {}

		for v73, v74 in p3.templates do
			t6[v73] = v74:jsonEncode()
		end

		t4.templates = t6
	end

	if p3.localized_literals ~= nil and next(p3.localized_literals) ~= nil then
		local t7 = {}

		for v76, v77 in p3.localized_literals do
			t7[v76] = v77
		end

		t4.localizedLiterals = t7
	end

	return t4
end
function t2.jsonDecode(t8: {[any]: any}) -- line: 281
	-- upvalues: t2 (copy), page_entry_content (copy), hydration_content (copy), template_entry (copy)
	local v79 = t2.new()

	if t8.page_entries ~= nil then
		local t9 = {}

		for _, v82 in t8.page_entries do
			table.insert(t9, page_entry_content.UniversalPageEntry.jsonDecode(v82))
		end

		v79.page_entries = t9
	end

	if t8.pageEntries ~= nil then
		local t10 = {}

		for _, v85 in t8.pageEntries do
			table.insert(t10, page_entry_content.UniversalPageEntry.jsonDecode(v85))
		end

		v79.page_entries = t10
	end

	if t8.hydration_data ~= nil then
		v79.hydration_data = hydration_content.HydrationContent.jsonDecode(t8.hydration_data)
	end

	if t8.hydrationData ~= nil then
		v79.hydration_data = hydration_content.HydrationContent.jsonDecode(t8.hydrationData)
	end

	if t8.templates ~= nil then
		local t11 = {}

		for v87, v88 in t8.templates do
			t11[v87] = template_entry.TemplateEntry.jsonDecode(v88)
		end

		v79.templates = t11
	end

	if t8.localized_literals ~= nil then
		local t12 = {}

		for v90, v91 in t8.localized_literals do
			t12[v90] = v91
		end

		v79.localized_literals = t12
	end

	if t8.localizedLiterals ~= nil then
		local t13 = {}

		for v93, v94 in t8.localizedLiterals do
			t13[v93] = v94
		end

		v79.localized_literals = t13
	end

	return v79
end

t2.descriptor = {
	name = "PartyChatResponse",
	fullName = "roblox.apppageplatform.partychat.v1beta1.PartyChatResponse"
}
t1.PartyChatResponse = t2
typeRegistry.default:register(t1.PartyChatResponse)

local t14 = {}

t14.__index = t14

function t14.new(t15: {[any]: any}?) -- line: 364
	-- upvalues: t14 (copy)
	return (setmetatable({
		key = if t15 ~= nil and t15.key ~= nil then t15.key else "",
		value = if t15 ~= nil and t15.value ~= nil then t15.value else nil
	}, t14))
end
function t14.encode(p4) -- line: 373
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n3 = 0

	if p4.key ~= nil and p4.key ~= "" then
		local v99, v100 = proto.writeTag(buf, n3, 1, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeString(v99, v100, p4.key)
	end

	if p4.value ~= nil then
		local v101 = p4.value:encode()
		local v102, v103 = proto.writeTag(buf, n3, 2, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeBuffer(v102, v103, v101, buffer.len(v101))
	end

	local buf5 = buffer.create(n3)

	buffer.copy(buf5, 0, buf, 0, n3)

	return buf5
end
function t14.decode(p5: buffer) -- line: 393
	-- upvalues: t14 (copy), proto (copy), template_entry (copy)
	local v106 = t14.new()
	local n4 = 0

	while n4 < buffer.len(p5) do
		local v108, v109

		v108, v109, n4 = proto.readTag(p5, n4)

		if v109 == proto.wireTypes.varint then
			local v110

			v110, n4 = proto.readVarInt(p5, n4)
		elseif v109 == proto.wireTypes.lengthDelimited then
			if v108 == 1 then
				local v111

				v111, n4 = proto.readBuffer(p5, n4)
				v106.key = buffer.tostring(v111)
			elseif v108 == 2 then
				local v112

				v112, n4 = proto.readBuffer(p5, n4)
				v106.value = template_entry.TemplateEntry.decode(v112)
			else
				local v113, v114 = proto.readVarInt(p5, n4)

				n4 = v114 + v113
			end
		elseif v109 == proto.wireTypes.i32 then
			local v115

			v115, n4 = proto.readFixed32(p5, n4)
		elseif v109 == proto.wireTypes.i64 then
			local v116

			v116, n4 = proto.readFixed64(p5, n4)
		else
			error("Unsupported wire type: " .. v109)
		end
	end

	return v106
end
function t14.jsonEncode(p6) -- line: 441
	local t16 = {}

	if p6.key ~= nil and p6.key ~= "" then
		t16.key = p6.key
	end

	if p6.value ~= nil then
		t16.value = p6.value:jsonEncode()
	end

	return t16
end
function t14.jsonDecode(t17: {[any]: any}) -- line: 455
	-- upvalues: t14 (copy), template_entry (copy)
	local v120 = t14.new()

	if t17.key ~= nil then
		v120.key = t17.key
	end

	if t17.value ~= nil then
		v120.value = template_entry.TemplateEntry.jsonDecode(t17.value)
	end

	return v120
end

t14.descriptor = {
	name = "PartyChatResponse_TemplatesEntry",
	fullName = "roblox.apppageplatform.partychat.v1beta1.TemplatesEntry"
}
t1.PartyChatResponse_TemplatesEntry = t14
typeRegistry.default:register(t1.PartyChatResponse_TemplatesEntry)

local t18 = {}

t18.__index = t18

function t18.new(t19: {[any]: any}?) -- line: 485
	-- upvalues: t18 (copy)
	return (setmetatable({
		key = if t19 ~= nil and t19.key ~= nil then t19.key else "",
		value = if t19 ~= nil and t19.value ~= nil then t19.value else ""
	}, t18))
end
function t18.encode(p7) -- line: 494
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n5 = 0

	if p7.key ~= nil and p7.key ~= "" then
		local v125, v126 = proto.writeTag(buf, n5, 1, proto.wireTypes.lengthDelimited)

		buf, n5 = proto.writeString(v125, v126, p7.key)
	end

	if p7.value ~= nil and p7.value ~= "" then
		local v127, v128 = proto.writeTag(buf, n5, 2, proto.wireTypes.lengthDelimited)

		buf, n5 = proto.writeString(v127, v128, p7.value)
	end

	local buf6 = buffer.create(n5)

	buffer.copy(buf6, 0, buf, 0, n5)

	return buf6
end
function t18.decode(p8: buffer) -- line: 515
	-- upvalues: t18 (copy), proto (copy)
	local v131 = t18.new()
	local n6 = 0

	while n6 < buffer.len(p8) do
		local v133, v134

		v133, v134, n6 = proto.readTag(p8, n6)

		if v134 == proto.wireTypes.varint then
			local v135

			v135, n6 = proto.readVarInt(p8, n6)
		elseif v134 == proto.wireTypes.lengthDelimited then
			if v133 == 1 then
				local v136

				v136, n6 = proto.readBuffer(p8, n6)
				v131.key = buffer.tostring(v136)
			elseif v133 == 2 then
				local v137

				v137, n6 = proto.readBuffer(p8, n6)
				v131.value = buffer.tostring(v137)
			else
				local v138, v139 = proto.readVarInt(p8, n6)

				n6 = v139 + v138
			end
		elseif v134 == proto.wireTypes.i32 then
			local v140

			v140, n6 = proto.readFixed32(p8, n6)
		elseif v134 == proto.wireTypes.i64 then
			local v141

			v141, n6 = proto.readFixed64(p8, n6)
		else
			error("Unsupported wire type: " .. v134)
		end
	end

	return v131
end
function t18.jsonEncode(p9) -- line: 565
	local t20 = {}

	if p9.key ~= nil and p9.key ~= "" then
		t20.key = p9.key
	end

	if p9.value ~= nil and p9.value ~= "" then
		t20.value = p9.value
	end

	return t20
end
function t18.jsonDecode(t21: {[any]: any}) -- line: 581
	-- upvalues: t18 (copy)
	local v145 = t18.new()

	if t21.key ~= nil then
		v145.key = t21.key
	end

	if t21.value ~= nil then
		v145.value = t21.value
	end

	return v145
end

t18.descriptor = {
	name = "PartyChatResponse_LocalizedLiteralsEntry",
	fullName = "roblox.apppageplatform.partychat.v1beta1.LocalizedLiteralsEntry"
}
t1.PartyChatResponse_LocalizedLiteralsEntry = t18
typeRegistry.default:register(t1.PartyChatResponse_LocalizedLiteralsEntry)

return {
	PartyChatResponse = t1.PartyChatResponse
}
