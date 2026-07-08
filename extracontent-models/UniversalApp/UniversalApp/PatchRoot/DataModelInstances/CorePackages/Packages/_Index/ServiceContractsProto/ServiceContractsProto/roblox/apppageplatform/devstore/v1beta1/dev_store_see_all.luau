local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local hydration_content = require(script.Parent.Parent.Parent.shared.v1beta1.hydration_content)
local template_entry = require(script.Parent.Parent.Parent.shared.v1beta1.template_entry)
local page_entry_content = require(script.Parent.Parent.Parent.shared.v1beta1.page_entry_content)
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 142
	-- upvalues: t2 (copy)
	return (setmetatable({
		universe_id = if t3 ~= nil and t3.universe_id ~= nil then t3.universe_id else 0
	}, t2))
end
function t2.encode(p1) -- line: 148
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.universe_id ~= nil and p1.universe_id ~= 0 then
		local v15, v16 = proto.writeTag(buf, n1, 1, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v15, v16, p1.universe_id)
	end

	local buf2 = buffer.create(n1)

	buffer.copy(buf2, 0, buf, 0, n1)

	return buf2
end
function t2.decode(p2: buffer) -- line: 162
	-- upvalues: t2 (copy), proto (copy)
	local v19 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v21, v22

		v21, v22, n2 = proto.readTag(p2, n2)

		if v22 == proto.wireTypes.varint then
			if v21 == 1 then
				local v23

				v23, n2 = proto.readVarIntI64(p2, n2)
				v19.universe_id = v23
			else
				local v24

				v24, n2 = proto.readVarInt(p2, n2)
			end
		elseif v22 == proto.wireTypes.lengthDelimited then
			local v25, v26 = proto.readVarInt(p2, n2)

			n2 = v26 + v25
		elseif v22 == proto.wireTypes.i32 then
			local v27

			v27, n2 = proto.readFixed32(p2, n2)
		elseif v22 == proto.wireTypes.i64 then
			local v28

			v28, n2 = proto.readFixed64(p2, n2)
		else
			error("Unsupported wire type: " .. v22)
		end
	end

	return v19
end
function t2.jsonEncode(p3) -- line: 205
	local t4 = {}

	if p3.universe_id ~= nil and p3.universe_id ~= 0 then
		t4.universeId = p3.universe_id
	end

	return t4
end
function t2.jsonDecode(t5: {[any]: any}) -- line: 215
	-- upvalues: t2 (copy)
	local v32 = t2.new()

	if t5.universe_id ~= nil then
		v32.universe_id = t5.universe_id
	end

	if t5.universeId ~= nil then
		v32.universe_id = t5.universeId
	end

	return v32
end

t2.descriptor = {
	name = "DevStoreSeeAllRequest",
	fullName = "roblox.apppageplatform.devstore.v1beta1.DevStoreSeeAllRequest"
}
t1.DevStoreSeeAllRequest = t2
typeRegistry.default:register(t1.DevStoreSeeAllRequest)

local t6 = {}

t6.__index = t6

function t6.new(t7: {[any]: any}?) -- line: 243
	-- upvalues: t6 (copy)
	return (setmetatable({
		page_entries = if t7 ~= nil and t7.page_entries ~= nil then t7.page_entries else {},
		hydration_data = if t7 ~= nil and t7.hydration_data ~= nil then t7.hydration_data else nil,
		templates = if t7 ~= nil and t7.templates ~= nil then t7.templates else {},
		localized_literals = if t7 ~= nil and t7.localized_literals ~= nil then t7.localized_literals else {}
	}, t6))
end
function t6.encode(p4) -- line: 252
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n3 = 0

	if p4.page_entries ~= nil and #p4.page_entries > 0 then
		for _, v38 in p4.page_entries do
			local v39 = v38:encode()
			local v40, v41 = proto.writeTag(buf, n3, 1, proto.wireTypes.lengthDelimited)

			buf, n3 = proto.writeBuffer(v40, v41, v39, buffer.len(v39))
		end
	end

	if p4.hydration_data ~= nil then
		local v42 = p4.hydration_data:encode()
		local v43, v44 = proto.writeTag(buf, n3, 2, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeBuffer(v43, v44, v42, buffer.len(v42))
	end

	if p4.templates ~= nil and next(p4.templates) ~= nil then
		for v45, v46 in p4.templates do
			local buf3 = buffer.create(0)
			local v48, v49 = proto.writeTag(buf3, 0, 1, proto.wireTypes.lengthDelimited)
			local v50, v51 = proto.writeString(v48, v49, v45)
			local v52 = v46:encode()
			local v53, v54 = proto.writeTag(v50, v51, 2, proto.wireTypes.lengthDelimited)
			local v55, v56 = proto.writeBuffer(v53, v54, v52, buffer.len(v52))
			local v57, v58 = proto.writeTag(buf, n3, 3, proto.wireTypes.lengthDelimited)

			buf, n3 = proto.writeBuffer(v57, v58, v55, v56)
		end
	end

	if p4.localized_literals ~= nil and next(p4.localized_literals) ~= nil then
		for v59, v60 in p4.localized_literals do
			local buf4 = buffer.create(0)
			local v62, v63 = proto.writeTag(buf4, 0, 1, proto.wireTypes.lengthDelimited)
			local v64, v65 = proto.writeString(v62, v63, v59)
			local v66, v67 = proto.writeTag(v64, v65, 2, proto.wireTypes.lengthDelimited)
			local v68, v69 = proto.writeString(v66, v67, v60)
			local v70, v71 = proto.writeTag(buf, n3, 4, proto.wireTypes.lengthDelimited)

			buf, n3 = proto.writeBuffer(v70, v71, v68, v69)
		end
	end

	local buf5 = buffer.create(n3)

	buffer.copy(buf5, 0, buf, 0, n3)

	return buf5
end
function t6.decode(p5: buffer) -- line: 302
	-- upvalues: t6 (copy), proto (copy), page_entry_content (copy), hydration_content (copy), t1 (copy), template_entry (copy)
	local v74 = t6.new()
	local n4 = 0

	while n4 < buffer.len(p5) do
		local v76, v77

		v76, v77, n4 = proto.readTag(p5, n4)

		if v77 == proto.wireTypes.varint then
			local v78

			v78, n4 = proto.readVarInt(p5, n4)
		elseif v77 == proto.wireTypes.lengthDelimited then
			if v76 == 1 then
				local v79

				v79, n4 = proto.readBuffer(p5, n4)
				table.insert(v74.page_entries, page_entry_content.UniversalPageEntry.decode(v79))
			elseif v76 == 2 then
				local v80

				v80, n4 = proto.readBuffer(p5, n4)
				v74.hydration_data = hydration_content.HydrationContent.decode(v80)
			elseif v76 == 3 then
				local v81

				v81, n4 = proto.readBuffer(p5, n4)

				local v82 = t1.DevStoreSeeAllResponse_TemplatesEntry.decode(v81)
				local v83 = template_entry.TemplateEntry.new()

				v74.templates[v82.key or ""] = v82.value or v83
			elseif v76 == 4 then
				local v84

				v84, n4 = proto.readBuffer(p5, n4)

				local v85 = t1.DevStoreSeeAllResponse_LocalizedLiteralsEntry.decode(v84)

				v74.localized_literals[v85.key or ""] = v85.value or ""
			else
				local v86, v87 = proto.readVarInt(p5, n4)

				n4 = v87 + v86
			end
		elseif v77 == proto.wireTypes.i32 then
			local v88

			v88, n4 = proto.readFixed32(p5, n4)
		elseif v77 == proto.wireTypes.i64 then
			local v89

			v89, n4 = proto.readFixed64(p5, n4)
		else
			error("Unsupported wire type: " .. v77)
		end
	end

	return v74
end
function t6.jsonEncode(p6) -- line: 378
	local t8 = {}

	if p6.page_entries ~= nil and #p6.page_entries > 0 then
		local t9 = {}

		for _, v94 in p6.page_entries do
			table.insert(t9, v94:jsonEncode())
		end

		t8.pageEntries = t9
	end

	if p6.hydration_data ~= nil then
		t8.hydrationData = p6.hydration_data:jsonEncode()
	end

	if p6.templates ~= nil and next(p6.templates) ~= nil then
		local t10 = {}

		for v96, v97 in p6.templates do
			t10[v96] = v97:jsonEncode()
		end

		t8.templates = t10
	end

	if p6.localized_literals ~= nil and next(p6.localized_literals) ~= nil then
		local t11 = {}

		for v99, v100 in p6.localized_literals do
			t11[v99] = v100
		end

		t8.localizedLiterals = t11
	end

	return t8
end
function t6.jsonDecode(t12: {[any]: any}) -- line: 412
	-- upvalues: t6 (copy), page_entry_content (copy), hydration_content (copy), template_entry (copy)
	local v102 = t6.new()

	if t12.page_entries ~= nil then
		local t13 = {}

		for _, v105 in t12.page_entries do
			table.insert(t13, page_entry_content.UniversalPageEntry.jsonDecode(v105))
		end

		v102.page_entries = t13
	end

	if t12.pageEntries ~= nil then
		local t14 = {}

		for _, v108 in t12.pageEntries do
			table.insert(t14, page_entry_content.UniversalPageEntry.jsonDecode(v108))
		end

		v102.page_entries = t14
	end

	if t12.hydration_data ~= nil then
		v102.hydration_data = hydration_content.HydrationContent.jsonDecode(t12.hydration_data)
	end

	if t12.hydrationData ~= nil then
		v102.hydration_data = hydration_content.HydrationContent.jsonDecode(t12.hydrationData)
	end

	if t12.templates ~= nil then
		local t15 = {}

		for v110, v111 in t12.templates do
			t15[v110] = template_entry.TemplateEntry.jsonDecode(v111)
		end

		v102.templates = t15
	end

	if t12.localized_literals ~= nil then
		local t16 = {}

		for v113, v114 in t12.localized_literals do
			t16[v113] = v114
		end

		v102.localized_literals = t16
	end

	if t12.localizedLiterals ~= nil then
		local t17 = {}

		for v116, v117 in t12.localizedLiterals do
			t17[v116] = v117
		end

		v102.localized_literals = t17
	end

	return v102
end

t6.descriptor = {
	name = "DevStoreSeeAllResponse",
	fullName = "roblox.apppageplatform.devstore.v1beta1.DevStoreSeeAllResponse"
}
t1.DevStoreSeeAllResponse = t6
typeRegistry.default:register(t1.DevStoreSeeAllResponse)

local t18 = {}

t18.__index = t18

function t18.new(t19: {[any]: any}?) -- line: 495
	-- upvalues: t18 (copy)
	return (setmetatable({
		key = if t19 ~= nil and t19.key ~= nil then t19.key else "",
		value = if t19 ~= nil and t19.value ~= nil then t19.value else nil
	}, t18))
end
function t18.encode(p7) -- line: 504
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n5 = 0

	if p7.key ~= nil and p7.key ~= "" then
		local v122, v123 = proto.writeTag(buf, n5, 1, proto.wireTypes.lengthDelimited)

		buf, n5 = proto.writeString(v122, v123, p7.key)
	end

	if p7.value ~= nil then
		local v124 = p7.value:encode()
		local v125, v126 = proto.writeTag(buf, n5, 2, proto.wireTypes.lengthDelimited)

		buf, n5 = proto.writeBuffer(v125, v126, v124, buffer.len(v124))
	end

	local buf6 = buffer.create(n5)

	buffer.copy(buf6, 0, buf, 0, n5)

	return buf6
end
function t18.decode(p8: buffer) -- line: 524
	-- upvalues: t18 (copy), proto (copy), template_entry (copy)
	local v129 = t18.new()
	local n6 = 0

	while n6 < buffer.len(p8) do
		local v131, v132

		v131, v132, n6 = proto.readTag(p8, n6)

		if v132 == proto.wireTypes.varint then
			local v133

			v133, n6 = proto.readVarInt(p8, n6)
		elseif v132 == proto.wireTypes.lengthDelimited then
			if v131 == 1 then
				local v134

				v134, n6 = proto.readBuffer(p8, n6)
				v129.key = buffer.tostring(v134)
			elseif v131 == 2 then
				local v135

				v135, n6 = proto.readBuffer(p8, n6)
				v129.value = template_entry.TemplateEntry.decode(v135)
			else
				local v136, v137 = proto.readVarInt(p8, n6)

				n6 = v137 + v136
			end
		elseif v132 == proto.wireTypes.i32 then
			local v138

			v138, n6 = proto.readFixed32(p8, n6)
		elseif v132 == proto.wireTypes.i64 then
			local v139

			v139, n6 = proto.readFixed64(p8, n6)
		else
			error("Unsupported wire type: " .. v132)
		end
	end

	return v129
end
function t18.jsonEncode(p9) -- line: 572
	local t20 = {}

	if p9.key ~= nil and p9.key ~= "" then
		t20.key = p9.key
	end

	if p9.value ~= nil then
		t20.value = p9.value:jsonEncode()
	end

	return t20
end
function t18.jsonDecode(t21: {[any]: any}) -- line: 586
	-- upvalues: t18 (copy), template_entry (copy)
	local v143 = t18.new()

	if t21.key ~= nil then
		v143.key = t21.key
	end

	if t21.value ~= nil then
		v143.value = template_entry.TemplateEntry.jsonDecode(t21.value)
	end

	return v143
end

t18.descriptor = {
	name = "DevStoreSeeAllResponse_TemplatesEntry",
	fullName = "roblox.apppageplatform.devstore.v1beta1.TemplatesEntry"
}
t1.DevStoreSeeAllResponse_TemplatesEntry = t18
typeRegistry.default:register(t1.DevStoreSeeAllResponse_TemplatesEntry)

local t22 = {}

t22.__index = t22

function t22.new(t23: {[any]: any}?) -- line: 616
	-- upvalues: t22 (copy)
	return (setmetatable({
		key = if t23 ~= nil and t23.key ~= nil then t23.key else "",
		value = if t23 ~= nil and t23.value ~= nil then t23.value else ""
	}, t22))
end
function t22.encode(p10) -- line: 625
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n7 = 0

	if p10.key ~= nil and p10.key ~= "" then
		local v148, v149 = proto.writeTag(buf, n7, 1, proto.wireTypes.lengthDelimited)

		buf, n7 = proto.writeString(v148, v149, p10.key)
	end

	if p10.value ~= nil and p10.value ~= "" then
		local v150, v151 = proto.writeTag(buf, n7, 2, proto.wireTypes.lengthDelimited)

		buf, n7 = proto.writeString(v150, v151, p10.value)
	end

	local buf7 = buffer.create(n7)

	buffer.copy(buf7, 0, buf, 0, n7)

	return buf7
end
function t22.decode(p11: buffer) -- line: 646
	-- upvalues: t22 (copy), proto (copy)
	local v154 = t22.new()
	local n8 = 0

	while n8 < buffer.len(p11) do
		local v156, v157

		v156, v157, n8 = proto.readTag(p11, n8)

		if v157 == proto.wireTypes.varint then
			local v158

			v158, n8 = proto.readVarInt(p11, n8)
		elseif v157 == proto.wireTypes.lengthDelimited then
			if v156 == 1 then
				local v159

				v159, n8 = proto.readBuffer(p11, n8)
				v154.key = buffer.tostring(v159)
			elseif v156 == 2 then
				local v160

				v160, n8 = proto.readBuffer(p11, n8)
				v154.value = buffer.tostring(v160)
			else
				local v161, v162 = proto.readVarInt(p11, n8)

				n8 = v162 + v161
			end
		elseif v157 == proto.wireTypes.i32 then
			local v163

			v163, n8 = proto.readFixed32(p11, n8)
		elseif v157 == proto.wireTypes.i64 then
			local v164

			v164, n8 = proto.readFixed64(p11, n8)
		else
			error("Unsupported wire type: " .. v157)
		end
	end

	return v154
end
function t22.jsonEncode(p12) -- line: 696
	local t24 = {}

	if p12.key ~= nil and p12.key ~= "" then
		t24.key = p12.key
	end

	if p12.value ~= nil and p12.value ~= "" then
		t24.value = p12.value
	end

	return t24
end
function t22.jsonDecode(t25: {[any]: any}) -- line: 712
	-- upvalues: t22 (copy)
	local v168 = t22.new()

	if t25.key ~= nil then
		v168.key = t25.key
	end

	if t25.value ~= nil then
		v168.value = t25.value
	end

	return v168
end

t22.descriptor = {
	name = "DevStoreSeeAllResponse_LocalizedLiteralsEntry",
	fullName = "roblox.apppageplatform.devstore.v1beta1.LocalizedLiteralsEntry"
}
t1.DevStoreSeeAllResponse_LocalizedLiteralsEntry = t22
typeRegistry.default:register(t1.DevStoreSeeAllResponse_LocalizedLiteralsEntry)

return {
	DevStoreSeeAllRequest = t1.DevStoreSeeAllRequest,
	DevStoreSeeAllResponse = t1.DevStoreSeeAllResponse
}
