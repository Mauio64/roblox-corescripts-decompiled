local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local hydration_content = require(script.Parent.Parent.Parent.shared.v1beta1.hydration_content)
local template_entry = require(script.Parent.Parent.Parent.shared.v1beta1.template_entry)
local page_entry_content = require(script.Parent.Parent.Parent.shared.v1beta1.page_entry_content)
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 153
	-- upvalues: t2 (copy)
	return (setmetatable({
		event_id = if t3 ~= nil and t3.event_id ~= nil then t3.event_id else 0,
		user_id = if t3 ~= nil and t3.user_id ~= nil then t3.user_id else 0
	}, t2))
end
function t2.encode(p1) -- line: 162
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.event_id ~= nil and p1.event_id ~= 0 then
		local v15, v16 = proto.writeTag(buf, n1, 1, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v15, v16, p1.event_id)
	end

	if p1.user_id ~= nil and p1.user_id ~= 0 then
		local v17, v18 = proto.writeTag(buf, n1, 2, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v17, v18, p1.user_id)
	end

	local buf2 = buffer.create(n1)

	buffer.copy(buf2, 0, buf, 0, n1)

	return buf2
end
function t2.decode(p2: buffer) -- line: 181
	-- upvalues: t2 (copy), proto (copy)
	local v21 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v23, v24

		v23, v24, n2 = proto.readTag(p2, n2)

		if v24 == proto.wireTypes.varint then
			if v23 == 1 then
				local v25

				v25, n2 = proto.readVarIntI64(p2, n2)
				v21.event_id = v25
			elseif v23 == 2 then
				local v26

				v26, n2 = proto.readVarIntI64(p2, n2)
				v21.user_id = v26
			else
				local v27

				v27, n2 = proto.readVarInt(p2, n2)
			end
		elseif v24 == proto.wireTypes.lengthDelimited then
			local v28, v29 = proto.readVarInt(p2, n2)

			n2 = v29 + v28
		elseif v24 == proto.wireTypes.i32 then
			local v30

			v30, n2 = proto.readFixed32(p2, n2)
		elseif v24 == proto.wireTypes.i64 then
			local v31

			v31, n2 = proto.readFixed64(p2, n2)
		else
			error("Unsupported wire type: " .. v24)
		end
	end

	return v21
end
function t2.jsonEncode(p3) -- line: 229
	local t4 = {}

	if p3.event_id ~= nil and p3.event_id ~= 0 then
		t4.eventId = p3.event_id
	end

	if p3.user_id ~= nil and p3.user_id ~= 0 then
		t4.userId = p3.user_id
	end

	return t4
end
function t2.jsonDecode(t5: {[any]: any}) -- line: 243
	-- upvalues: t2 (copy)
	local v35 = t2.new()

	if t5.event_id ~= nil then
		v35.event_id = t5.event_id
	end

	if t5.eventId ~= nil then
		v35.event_id = t5.eventId
	end

	if t5.user_id ~= nil then
		v35.user_id = t5.user_id
	end

	if t5.userId ~= nil then
		v35.user_id = t5.userId
	end

	return v35
end

t2.descriptor = {
	name = "ExperienceEventDetailsPageRequest",
	fullName = "roblox.apppageplatform.experienceevents.v1beta1.ExperienceEventDetailsPageRequest"
}
t1.ExperienceEventDetailsPageRequest = t2
typeRegistry.default:register(t1.ExperienceEventDetailsPageRequest)

local t6 = {}

t6.__index = t6

function t6.new(t7: {[any]: any}?) -- line: 281
	-- upvalues: t6 (copy)
	return (setmetatable({
		page_entries = if t7 ~= nil and t7.page_entries ~= nil then t7.page_entries else {},
		hydration_data = if t7 ~= nil and t7.hydration_data ~= nil then t7.hydration_data else nil,
		templates = if t7 ~= nil and t7.templates ~= nil then t7.templates else {},
		localized_literals = if t7 ~= nil and t7.localized_literals ~= nil then t7.localized_literals else {}
	}, t6))
end
function t6.encode(p4) -- line: 292
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n3 = 0

	if p4.page_entries ~= nil and #p4.page_entries > 0 then
		for _, v41 in p4.page_entries do
			local v42 = v41:encode()
			local v43, v44 = proto.writeTag(buf, n3, 1, proto.wireTypes.lengthDelimited)

			buf, n3 = proto.writeBuffer(v43, v44, v42, buffer.len(v42))
		end
	end

	if p4.hydration_data ~= nil then
		local v45 = p4.hydration_data:encode()
		local v46, v47 = proto.writeTag(buf, n3, 2, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeBuffer(v46, v47, v45, buffer.len(v45))
	end

	if p4.templates ~= nil and next(p4.templates) ~= nil then
		for v48, v49 in p4.templates do
			local buf3 = buffer.create(0)
			local v51, v52 = proto.writeTag(buf3, 0, 1, proto.wireTypes.lengthDelimited)
			local v53, v54 = proto.writeString(v51, v52, v48)
			local v55 = v49:encode()
			local v56, v57 = proto.writeTag(v53, v54, 2, proto.wireTypes.lengthDelimited)
			local v58, v59 = proto.writeBuffer(v56, v57, v55, buffer.len(v55))
			local v60, v61 = proto.writeTag(buf, n3, 3, proto.wireTypes.lengthDelimited)

			buf, n3 = proto.writeBuffer(v60, v61, v58, v59)
		end
	end

	if p4.localized_literals ~= nil and next(p4.localized_literals) ~= nil then
		for v62, v63 in p4.localized_literals do
			local buf4 = buffer.create(0)
			local v65, v66 = proto.writeTag(buf4, 0, 1, proto.wireTypes.lengthDelimited)
			local v67, v68 = proto.writeString(v65, v66, v62)
			local v69, v70 = proto.writeTag(v67, v68, 2, proto.wireTypes.lengthDelimited)
			local v71, v72 = proto.writeString(v69, v70, v63)
			local v73, v74 = proto.writeTag(buf, n3, 4, proto.wireTypes.lengthDelimited)

			buf, n3 = proto.writeBuffer(v73, v74, v71, v72)
		end
	end

	local buf5 = buffer.create(n3)

	buffer.copy(buf5, 0, buf, 0, n3)

	return buf5
end
function t6.decode(p5: buffer) -- line: 342
	-- upvalues: t6 (copy), proto (copy), page_entry_content (copy), hydration_content (copy), t1 (copy), template_entry (copy)
	local v77 = t6.new()
	local n4 = 0

	while n4 < buffer.len(p5) do
		local v79, v80

		v79, v80, n4 = proto.readTag(p5, n4)

		if v80 == proto.wireTypes.varint then
			local v81

			v81, n4 = proto.readVarInt(p5, n4)
		elseif v80 == proto.wireTypes.lengthDelimited then
			if v79 == 1 then
				local v82

				v82, n4 = proto.readBuffer(p5, n4)
				table.insert(v77.page_entries, page_entry_content.UniversalPageEntry.decode(v82))
			elseif v79 == 2 then
				local v83

				v83, n4 = proto.readBuffer(p5, n4)
				v77.hydration_data = hydration_content.HydrationContent.decode(v83)
			elseif v79 == 3 then
				local v84

				v84, n4 = proto.readBuffer(p5, n4)

				local v85 = t1.ExperienceEventDetailsPageResponse_TemplatesEntry.decode(v84)
				local v86 = template_entry.TemplateEntry.new()

				v77.templates[v85.key or ""] = v85.value or v86
			elseif v79 == 4 then
				local v87

				v87, n4 = proto.readBuffer(p5, n4)

				local v88 = t1.ExperienceEventDetailsPageResponse_LocalizedLiteralsEntry.decode(v87)

				v77.localized_literals[v88.key or ""] = v88.value or ""
			else
				local v89, v90 = proto.readVarInt(p5, n4)

				n4 = v90 + v89
			end
		elseif v80 == proto.wireTypes.i32 then
			local v91

			v91, n4 = proto.readFixed32(p5, n4)
		elseif v80 == proto.wireTypes.i64 then
			local v92

			v92, n4 = proto.readFixed64(p5, n4)
		else
			error("Unsupported wire type: " .. v80)
		end
	end

	return v77
end
function t6.jsonEncode(p6) -- line: 418
	local t8 = {}

	if p6.page_entries ~= nil and #p6.page_entries > 0 then
		local t9 = {}

		for _, v97 in p6.page_entries do
			table.insert(t9, v97:jsonEncode())
		end

		t8.pageEntries = t9
	end

	if p6.hydration_data ~= nil then
		t8.hydrationData = p6.hydration_data:jsonEncode()
	end

	if p6.templates ~= nil and next(p6.templates) ~= nil then
		local t10 = {}

		for v99, v100 in p6.templates do
			t10[v99] = v100:jsonEncode()
		end

		t8.templates = t10
	end

	if p6.localized_literals ~= nil and next(p6.localized_literals) ~= nil then
		local t11 = {}

		for v102, v103 in p6.localized_literals do
			t11[v102] = v103
		end

		t8.localizedLiterals = t11
	end

	return t8
end
function t6.jsonDecode(t12: {[any]: any}) -- line: 452
	-- upvalues: t6 (copy), page_entry_content (copy), hydration_content (copy), template_entry (copy)
	local v105 = t6.new()

	if t12.page_entries ~= nil then
		local t13 = {}

		for _, v108 in t12.page_entries do
			table.insert(t13, page_entry_content.UniversalPageEntry.jsonDecode(v108))
		end

		v105.page_entries = t13
	end

	if t12.pageEntries ~= nil then
		local t14 = {}

		for _, v111 in t12.pageEntries do
			table.insert(t14, page_entry_content.UniversalPageEntry.jsonDecode(v111))
		end

		v105.page_entries = t14
	end

	if t12.hydration_data ~= nil then
		v105.hydration_data = hydration_content.HydrationContent.jsonDecode(t12.hydration_data)
	end

	if t12.hydrationData ~= nil then
		v105.hydration_data = hydration_content.HydrationContent.jsonDecode(t12.hydrationData)
	end

	if t12.templates ~= nil then
		local t15 = {}

		for v113, v114 in t12.templates do
			t15[v113] = template_entry.TemplateEntry.jsonDecode(v114)
		end

		v105.templates = t15
	end

	if t12.localized_literals ~= nil then
		local t16 = {}

		for v116, v117 in t12.localized_literals do
			t16[v116] = v117
		end

		v105.localized_literals = t16
	end

	if t12.localizedLiterals ~= nil then
		local t17 = {}

		for v119, v120 in t12.localizedLiterals do
			t17[v119] = v120
		end

		v105.localized_literals = t17
	end

	return v105
end

t6.descriptor = {
	name = "ExperienceEventDetailsPageResponse",
	fullName = "roblox.apppageplatform.experienceevents.v1beta1.ExperienceEventDetailsPageResponse"
}
t1.ExperienceEventDetailsPageResponse = t6
typeRegistry.default:register(t1.ExperienceEventDetailsPageResponse)

local t18 = {}

t18.__index = t18

function t18.new(t19: {[any]: any}?) -- line: 538
	-- upvalues: t18 (copy)
	return (setmetatable({
		key = if t19 ~= nil and t19.key ~= nil then t19.key else "",
		value = if t19 ~= nil and t19.value ~= nil then t19.value else nil
	}, t18))
end
function t18.encode(p7) -- line: 550
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n5 = 0

	if p7.key ~= nil and p7.key ~= "" then
		local v125, v126 = proto.writeTag(buf, n5, 1, proto.wireTypes.lengthDelimited)

		buf, n5 = proto.writeString(v125, v126, p7.key)
	end

	if p7.value ~= nil then
		local v127 = p7.value:encode()
		local v128, v129 = proto.writeTag(buf, n5, 2, proto.wireTypes.lengthDelimited)

		buf, n5 = proto.writeBuffer(v128, v129, v127, buffer.len(v127))
	end

	local buf6 = buffer.create(n5)

	buffer.copy(buf6, 0, buf, 0, n5)

	return buf6
end
function t18.decode(p8: buffer) -- line: 572
	-- upvalues: t18 (copy), proto (copy), template_entry (copy)
	local v132 = t18.new()
	local n6 = 0

	while n6 < buffer.len(p8) do
		local v134, v135

		v134, v135, n6 = proto.readTag(p8, n6)

		if v135 == proto.wireTypes.varint then
			local v136

			v136, n6 = proto.readVarInt(p8, n6)
		elseif v135 == proto.wireTypes.lengthDelimited then
			if v134 == 1 then
				local v137

				v137, n6 = proto.readBuffer(p8, n6)
				v132.key = buffer.tostring(v137)
			elseif v134 == 2 then
				local v138

				v138, n6 = proto.readBuffer(p8, n6)
				v132.value = template_entry.TemplateEntry.decode(v138)
			else
				local v139, v140 = proto.readVarInt(p8, n6)

				n6 = v140 + v139
			end
		elseif v135 == proto.wireTypes.i32 then
			local v141

			v141, n6 = proto.readFixed32(p8, n6)
		elseif v135 == proto.wireTypes.i64 then
			local v142

			v142, n6 = proto.readFixed64(p8, n6)
		else
			error("Unsupported wire type: " .. v135)
		end
	end

	return v132
end
function t18.jsonEncode(p9) -- line: 622
	local t20 = {}

	if p9.key ~= nil and p9.key ~= "" then
		t20.key = p9.key
	end

	if p9.value ~= nil then
		t20.value = p9.value:jsonEncode()
	end

	return t20
end
function t18.jsonDecode(t21: {[any]: any}) -- line: 638
	-- upvalues: t18 (copy), template_entry (copy)
	local v146 = t18.new()

	if t21.key ~= nil then
		v146.key = t21.key
	end

	if t21.value ~= nil then
		v146.value = template_entry.TemplateEntry.jsonDecode(t21.value)
	end

	return v146
end

t18.descriptor = {
	name = "ExperienceEventDetailsPageResponse_TemplatesEntry",
	fullName = "roblox.apppageplatform.experienceevents.v1beta1.TemplatesEntry"
}
t1.ExperienceEventDetailsPageResponse_TemplatesEntry = t18
typeRegistry.default:register(t1.ExperienceEventDetailsPageResponse_TemplatesEntry)

local t22 = {}

t22.__index = t22

function t22.new(t23: {[any]: any}?) -- line: 670
	-- upvalues: t22 (copy)
	return (setmetatable({
		key = if t23 ~= nil and t23.key ~= nil then t23.key else "",
		value = if t23 ~= nil and t23.value ~= nil then t23.value else ""
	}, t22))
end
function t22.encode(p10) -- line: 682
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n7 = 0

	if p10.key ~= nil and p10.key ~= "" then
		local v151, v152 = proto.writeTag(buf, n7, 1, proto.wireTypes.lengthDelimited)

		buf, n7 = proto.writeString(v151, v152, p10.key)
	end

	if p10.value ~= nil and p10.value ~= "" then
		local v153, v154 = proto.writeTag(buf, n7, 2, proto.wireTypes.lengthDelimited)

		buf, n7 = proto.writeString(v153, v154, p10.value)
	end

	local buf7 = buffer.create(n7)

	buffer.copy(buf7, 0, buf, 0, n7)

	return buf7
end
function t22.decode(p11: buffer) -- line: 703
	-- upvalues: t22 (copy), proto (copy)
	local v157 = t22.new()
	local n8 = 0

	while n8 < buffer.len(p11) do
		local v159, v160

		v159, v160, n8 = proto.readTag(p11, n8)

		if v160 == proto.wireTypes.varint then
			local v161

			v161, n8 = proto.readVarInt(p11, n8)
		elseif v160 == proto.wireTypes.lengthDelimited then
			if v159 == 1 then
				local v162

				v162, n8 = proto.readBuffer(p11, n8)
				v157.key = buffer.tostring(v162)
			elseif v159 == 2 then
				local v163

				v163, n8 = proto.readBuffer(p11, n8)
				v157.value = buffer.tostring(v163)
			else
				local v164, v165 = proto.readVarInt(p11, n8)

				n8 = v165 + v164
			end
		elseif v160 == proto.wireTypes.i32 then
			local v166

			v166, n8 = proto.readFixed32(p11, n8)
		elseif v160 == proto.wireTypes.i64 then
			local v167

			v167, n8 = proto.readFixed64(p11, n8)
		else
			error("Unsupported wire type: " .. v160)
		end
	end

	return v157
end
function t22.jsonEncode(p12) -- line: 753
	local t24 = {}

	if p12.key ~= nil and p12.key ~= "" then
		t24.key = p12.key
	end

	if p12.value ~= nil and p12.value ~= "" then
		t24.value = p12.value
	end

	return t24
end
function t22.jsonDecode(t25: {[any]: any}) -- line: 769
	-- upvalues: t22 (copy)
	local v171 = t22.new()

	if t25.key ~= nil then
		v171.key = t25.key
	end

	if t25.value ~= nil then
		v171.value = t25.value
	end

	return v171
end

t22.descriptor = {
	name = "ExperienceEventDetailsPageResponse_LocalizedLiteralsEntry",
	fullName = "roblox.apppageplatform.experienceevents.v1beta1.LocalizedLiteralsEntry"
}
t1.ExperienceEventDetailsPageResponse_LocalizedLiteralsEntry = t22
typeRegistry.default:register(t1.ExperienceEventDetailsPageResponse_LocalizedLiteralsEntry)

return {
	ExperienceEventDetailsPageRequest = t1.ExperienceEventDetailsPageRequest,
	ExperienceEventDetailsPageResponse = t1.ExperienceEventDetailsPageResponse
}
