local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local hydration_content = require(script.Parent.Parent.Parent.shared.v1beta1.hydration_content)
local page_entry = require(script.Parent.Parent.Parent.shared.v1beta1.page_entry)
local template_entry = require(script.Parent.Parent.Parent.shared.v1beta1.template_entry)
local page_entry_content = require(script.Parent.Parent.Parent.shared.v1beta1.page_entry_content)
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 370
	-- upvalues: page_entry_content (copy), t2 (copy)
	return (setmetatable({
		badge_id = if t3 ~= nil and t3.badge_id ~= nil then t3.badge_id else 0,
		user_id = if t3 ~= nil and t3.user_id ~= nil then t3.user_id else 0,
		page_entry_format = if t3 ~= nil and t3.page_entry_format ~= nil then t3.page_entry_format else assert(page_entry_content.PageEntryFormat.fromNumber(0), "Enum has no 0 default")
	}, t2))
end
function t2.encode(p1) -- line: 383
	-- upvalues: proto (copy), page_entry_content (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.badge_id ~= nil and p1.badge_id ~= 0 then
		local v23, v24 = proto.writeTag(buf, n1, 1, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v23, v24, p1.badge_id)
	end

	if p1.user_id ~= nil and p1.user_id ~= 0 then
		local v25, v26 = proto.writeTag(buf, n1, 2, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v25, v26, p1.user_id)
	end

	if p1.page_entry_format ~= nil and (p1.page_entry_format ~= nil and p1.page_entry_format ~= 0 or p1.page_entry_format ~= page_entry_content.PageEntryFormat.fromNumber(0)) then
		local v27, v28 = proto.writeTag(buf, n1, 3, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v27, v28, page_entry_content.PageEntryFormat.toNumber(p1.page_entry_format))
	end

	local buf2 = buffer.create(n1)

	buffer.copy(buf2, 0, buf, 0, n1)

	return buf2
end
function t2.decode(p2: buffer) -- line: 420
	-- upvalues: t2 (copy), proto (copy), page_entry_content (copy)
	local v31 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v33, v34

		v33, v34, n2 = proto.readTag(p2, n2)

		if v34 == proto.wireTypes.varint then
			if v33 == 1 then
				local v35

				v35, n2 = proto.readVarIntI64(p2, n2)
				v31.badge_id = v35
			elseif v33 == 2 then
				local v36

				v36, n2 = proto.readVarIntI64(p2, n2)
				v31.user_id = v36
			elseif v33 == 3 then
				local v37

				v37, n2 = proto.readVarIntI32(p2, n2)
				v31.page_entry_format = page_entry_content.PageEntryFormat.fromNumber(v37) or v37
			else
				local v38

				v38, n2 = proto.readVarInt(p2, n2)
			end
		elseif v34 == proto.wireTypes.lengthDelimited then
			local v39, v40 = proto.readVarInt(p2, n2)

			n2 = v40 + v39
		elseif v34 == proto.wireTypes.i32 then
			local v41

			v41, n2 = proto.readFixed32(p2, n2)
		elseif v34 == proto.wireTypes.i64 then
			local v42

			v42, n2 = proto.readFixed64(p2, n2)
		else
			error("Unsupported wire type: " .. v34)
		end
	end

	return v31
end
function t2.jsonEncode(p3) -- line: 476
	-- upvalues: page_entry_content (copy)
	local t4 = {}

	if p3.badge_id ~= nil and p3.badge_id ~= 0 then
		t4.badgeId = p3.badge_id
	end

	if p3.user_id ~= nil and p3.user_id ~= 0 then
		t4.userId = p3.user_id
	end

	if p3.page_entry_format ~= nil and (p3.page_entry_format ~= nil and p3.page_entry_format ~= 0 or p3.page_entry_format ~= page_entry_content.PageEntryFormat.fromNumber(0)) then
		t4.pageEntryFormat = if typeof(p3.page_entry_format) ~= "number" then page_entry_content.PageEntryFormat.toNumber(p3.page_entry_format) else p3.page_entry_format
	end

	return t4
end
function t2.jsonDecode(t5: {[any]: any}) -- line: 505
	-- upvalues: t2 (copy), page_entry_content (copy)
	local v46 = t2.new()

	if t5.badge_id ~= nil then
		v46.badge_id = t5.badge_id
	end

	if t5.badgeId ~= nil then
		v46.badge_id = t5.badgeId
	end

	if t5.user_id ~= nil then
		v46.user_id = t5.user_id
	end

	if t5.userId ~= nil then
		v46.user_id = t5.userId
	end

	if t5.page_entry_format ~= nil then
		v46.page_entry_format = if typeof(t5.page_entry_format) ~= "number" then page_entry_content.PageEntryFormat.fromName(t5.page_entry_format) or t5.page_entry_format else page_entry_content.PageEntryFormat.fromNumber(t5.page_entry_format) or t5.page_entry_format
	end

	if t5.pageEntryFormat ~= nil then
		v46.page_entry_format = if typeof(t5.pageEntryFormat) ~= "number" then page_entry_content.PageEntryFormat.fromName(t5.pageEntryFormat) or t5.pageEntryFormat else page_entry_content.PageEntryFormat.fromNumber(t5.pageEntryFormat) or t5.pageEntryFormat
	end

	return v46
end

t2.descriptor = {
	name = "BadgeDetailsPageRequest",
	fullName = "roblox.apppageplatform.badges.v1beta1.BadgeDetailsPageRequest"
}
t1.BadgeDetailsPageRequest = t2
typeRegistry.default:register(t1.BadgeDetailsPageRequest)

local t6 = {}

t6.__index = t6

function t6.new(t7: {[any]: any}?) -- line: 561
	-- upvalues: t6 (copy)
	return (setmetatable({
		page_entries = if t7 ~= nil and t7.page_entries ~= nil then t7.page_entries else {},
		hydration_data = if t7 ~= nil and t7.hydration_data ~= nil then t7.hydration_data else nil,
		templates = if t7 ~= nil and t7.templates ~= nil then t7.templates else {}
	}, t6))
end
function t6.encode(p4) -- line: 569
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n3 = 0

	if p4.page_entries ~= nil and #p4.page_entries > 0 then
		for _, v52 in p4.page_entries do
			local v53 = v52:encode()
			local v54, v55 = proto.writeTag(buf, n3, 1, proto.wireTypes.lengthDelimited)

			buf, n3 = proto.writeBuffer(v54, v55, v53, buffer.len(v53))
		end
	end

	if p4.hydration_data ~= nil then
		local v56 = p4.hydration_data:encode()
		local v57, v58 = proto.writeTag(buf, n3, 2, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeBuffer(v57, v58, v56, buffer.len(v56))
	end

	if p4.templates ~= nil and next(p4.templates) ~= nil then
		for v59, v60 in p4.templates do
			local buf3 = buffer.create(0)
			local v62, v63 = proto.writeTag(buf3, 0, 1, proto.wireTypes.lengthDelimited)
			local v64, v65 = proto.writeString(v62, v63, v59)
			local v66 = v60:encode()
			local v67, v68 = proto.writeTag(v64, v65, 2, proto.wireTypes.lengthDelimited)
			local v69, v70 = proto.writeBuffer(v67, v68, v66, buffer.len(v66))
			local v71, v72 = proto.writeTag(buf, n3, 3, proto.wireTypes.lengthDelimited)

			buf, n3 = proto.writeBuffer(v71, v72, v69, v70)
		end
	end

	local buf4 = buffer.create(n3)

	buffer.copy(buf4, 0, buf, 0, n3)

	return buf4
end
function t6.decode(p5: buffer) -- line: 606
	-- upvalues: t6 (copy), proto (copy), t1 (copy), hydration_content (copy), template_entry (copy)
	local v75 = t6.new()
	local n4 = 0

	while n4 < buffer.len(p5) do
		local v77, v78

		v77, v78, n4 = proto.readTag(p5, n4)

		if v78 == proto.wireTypes.varint then
			local v79

			v79, n4 = proto.readVarInt(p5, n4)
		elseif v78 == proto.wireTypes.lengthDelimited then
			if v77 == 1 then
				local v80

				v80, n4 = proto.readBuffer(p5, n4)
				table.insert(v75.page_entries, t1.BadgeDetailsPageEntry.decode(v80))
			elseif v77 == 2 then
				local v81

				v81, n4 = proto.readBuffer(p5, n4)
				v75.hydration_data = hydration_content.HydrationContent.decode(v81)
			elseif v77 == 3 then
				local v82

				v82, n4 = proto.readBuffer(p5, n4)

				local v83 = t1.BadgeDetailsPageResponse_TemplatesEntry.decode(v82)
				local v84 = template_entry.TemplateEntry.new()

				v75.templates[v83.key or ""] = v83.value or v84
			else
				local v85, v86 = proto.readVarInt(p5, n4)

				n4 = v86 + v85
			end
		elseif v78 == proto.wireTypes.i32 then
			local v87

			v87, n4 = proto.readFixed32(p5, n4)
		elseif v78 == proto.wireTypes.i64 then
			local v88

			v88, n4 = proto.readFixed64(p5, n4)
		else
			error("Unsupported wire type: " .. v78)
		end
	end

	return v75
end
function t6.jsonEncode(p6) -- line: 667
	local t8 = {}

	if p6.page_entries ~= nil and #p6.page_entries > 0 then
		local t9 = {}

		for _, v93 in p6.page_entries do
			table.insert(t9, v93:jsonEncode())
		end

		t8.pageEntries = t9
	end

	if p6.hydration_data ~= nil then
		t8.hydrationData = p6.hydration_data:jsonEncode()
	end

	if p6.templates ~= nil and next(p6.templates) ~= nil then
		local t10 = {}

		for v95, v96 in p6.templates do
			t10[v95] = v96:jsonEncode()
		end

		t8.templates = t10
	end

	return t8
end
function t6.jsonDecode(t11: {[any]: any}) -- line: 693
	-- upvalues: t6 (copy), t1 (copy), hydration_content (copy), template_entry (copy)
	local v98 = t6.new()

	if t11.page_entries ~= nil then
		local t12 = {}

		for _, v101 in t11.page_entries do
			table.insert(t12, t1.BadgeDetailsPageEntry.jsonDecode(v101))
		end

		v98.page_entries = t12
	end

	if t11.pageEntries ~= nil then
		local t13 = {}

		for _, v104 in t11.pageEntries do
			table.insert(t13, t1.BadgeDetailsPageEntry.jsonDecode(v104))
		end

		v98.page_entries = t13
	end

	if t11.hydration_data ~= nil then
		v98.hydration_data = hydration_content.HydrationContent.jsonDecode(t11.hydration_data)
	end

	if t11.hydrationData ~= nil then
		v98.hydration_data = hydration_content.HydrationContent.jsonDecode(t11.hydrationData)
	end

	if t11.templates ~= nil then
		local t14 = {}

		for v106, v107 in t11.templates do
			t14[v106] = template_entry.TemplateEntry.jsonDecode(v107)
		end

		v98.templates = t14
	end

	return v98
end

t6.descriptor = {
	name = "BadgeDetailsPageResponse",
	fullName = "roblox.apppageplatform.badges.v1beta1.BadgeDetailsPageResponse"
}
t1.BadgeDetailsPageResponse = t6
typeRegistry.default:register(t1.BadgeDetailsPageResponse)

local t15 = {}

t15.__index = t15

function t15.new(t16: {[any]: any}?) -- line: 752
	-- upvalues: t15 (copy)
	return (setmetatable({
		key = if t16 ~= nil and t16.key ~= nil then t16.key else "",
		value = if t16 ~= nil and t16.value ~= nil then t16.value else nil
	}, t15))
end
function t15.encode(p7) -- line: 761
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n5 = 0

	if p7.key ~= nil and p7.key ~= "" then
		local v112, v113 = proto.writeTag(buf, n5, 1, proto.wireTypes.lengthDelimited)

		buf, n5 = proto.writeString(v112, v113, p7.key)
	end

	if p7.value ~= nil then
		local v114 = p7.value:encode()
		local v115, v116 = proto.writeTag(buf, n5, 2, proto.wireTypes.lengthDelimited)

		buf, n5 = proto.writeBuffer(v115, v116, v114, buffer.len(v114))
	end

	local buf5 = buffer.create(n5)

	buffer.copy(buf5, 0, buf, 0, n5)

	return buf5
end
function t15.decode(p8: buffer) -- line: 781
	-- upvalues: t15 (copy), proto (copy), template_entry (copy)
	local v119 = t15.new()
	local n6 = 0

	while n6 < buffer.len(p8) do
		local v121, v122

		v121, v122, n6 = proto.readTag(p8, n6)

		if v122 == proto.wireTypes.varint then
			local v123

			v123, n6 = proto.readVarInt(p8, n6)
		elseif v122 == proto.wireTypes.lengthDelimited then
			if v121 == 1 then
				local v124

				v124, n6 = proto.readBuffer(p8, n6)
				v119.key = buffer.tostring(v124)
			elseif v121 == 2 then
				local v125

				v125, n6 = proto.readBuffer(p8, n6)
				v119.value = template_entry.TemplateEntry.decode(v125)
			else
				local v126, v127 = proto.readVarInt(p8, n6)

				n6 = v127 + v126
			end
		elseif v122 == proto.wireTypes.i32 then
			local v128

			v128, n6 = proto.readFixed32(p8, n6)
		elseif v122 == proto.wireTypes.i64 then
			local v129

			v129, n6 = proto.readFixed64(p8, n6)
		else
			error("Unsupported wire type: " .. v122)
		end
	end

	return v119
end
function t15.jsonEncode(p9) -- line: 829
	local t17 = {}

	if p9.key ~= nil and p9.key ~= "" then
		t17.key = p9.key
	end

	if p9.value ~= nil then
		t17.value = p9.value:jsonEncode()
	end

	return t17
end
function t15.jsonDecode(t18: {[any]: any}) -- line: 843
	-- upvalues: t15 (copy), template_entry (copy)
	local v133 = t15.new()

	if t18.key ~= nil then
		v133.key = t18.key
	end

	if t18.value ~= nil then
		v133.value = template_entry.TemplateEntry.jsonDecode(t18.value)
	end

	return v133
end

t15.descriptor = {
	name = "BadgeDetailsPageResponse_TemplatesEntry",
	fullName = "roblox.apppageplatform.badges.v1beta1.TemplatesEntry"
}
t1.BadgeDetailsPageResponse_TemplatesEntry = t15
typeRegistry.default:register(t1.BadgeDetailsPageResponse_TemplatesEntry)

local t19 = {}

t19.__index = t19

function t19.new(t20: {[any]: any}?) -- line: 873
	-- upvalues: t19 (copy)
	return (setmetatable({
		page_entries = if t20 ~= nil and t20.page_entries ~= nil then t20.page_entries else {},
		hydration_data = if t20 ~= nil and t20.hydration_data ~= nil then t20.hydration_data else nil,
		templates = if t20 ~= nil and t20.templates ~= nil then t20.templates else {}
	}, t19))
end
function t19.encode(p10) -- line: 883
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n7 = 0

	if p10.page_entries ~= nil and #p10.page_entries > 0 then
		for _, v139 in p10.page_entries do
			local v140 = v139:encode()
			local v141, v142 = proto.writeTag(buf, n7, 1, proto.wireTypes.lengthDelimited)

			buf, n7 = proto.writeBuffer(v141, v142, v140, buffer.len(v140))
		end
	end

	if p10.hydration_data ~= nil then
		local v143 = p10.hydration_data:encode()
		local v144, v145 = proto.writeTag(buf, n7, 2, proto.wireTypes.lengthDelimited)

		buf, n7 = proto.writeBuffer(v144, v145, v143, buffer.len(v143))
	end

	if p10.templates ~= nil and next(p10.templates) ~= nil then
		for v146, v147 in p10.templates do
			local buf6 = buffer.create(0)
			local v149, v150 = proto.writeTag(buf6, 0, 1, proto.wireTypes.lengthDelimited)
			local v151, v152 = proto.writeString(v149, v150, v146)
			local v153 = v147:encode()
			local v154, v155 = proto.writeTag(v151, v152, 2, proto.wireTypes.lengthDelimited)
			local v156, v157 = proto.writeBuffer(v154, v155, v153, buffer.len(v153))
			local v158, v159 = proto.writeTag(buf, n7, 3, proto.wireTypes.lengthDelimited)

			buf, n7 = proto.writeBuffer(v158, v159, v156, v157)
		end
	end

	local buf7 = buffer.create(n7)

	buffer.copy(buf7, 0, buf, 0, n7)

	return buf7
end
function t19.decode(p11: buffer) -- line: 920
	-- upvalues: t19 (copy), proto (copy), page_entry_content (copy), hydration_content (copy), t1 (copy), template_entry (copy)
	local v162 = t19.new()
	local n8 = 0

	while n8 < buffer.len(p11) do
		local v164, v165

		v164, v165, n8 = proto.readTag(p11, n8)

		if v165 == proto.wireTypes.varint then
			local v166

			v166, n8 = proto.readVarInt(p11, n8)
		elseif v165 == proto.wireTypes.lengthDelimited then
			if v164 == 1 then
				local v167

				v167, n8 = proto.readBuffer(p11, n8)
				table.insert(v162.page_entries, page_entry_content.UniversalPageEntry.decode(v167))
			elseif v164 == 2 then
				local v168

				v168, n8 = proto.readBuffer(p11, n8)
				v162.hydration_data = hydration_content.HydrationContent.decode(v168)
			elseif v164 == 3 then
				local v169

				v169, n8 = proto.readBuffer(p11, n8)

				local v170 = t1.BadgeDetailsPageV2Response_TemplatesEntry.decode(v169)
				local v171 = template_entry.TemplateEntry.new()

				v162.templates[v170.key or ""] = v170.value or v171
			else
				local v172, v173 = proto.readVarInt(p11, n8)

				n8 = v173 + v172
			end
		elseif v165 == proto.wireTypes.i32 then
			local v174

			v174, n8 = proto.readFixed32(p11, n8)
		elseif v165 == proto.wireTypes.i64 then
			local v175

			v175, n8 = proto.readFixed64(p11, n8)
		else
			error("Unsupported wire type: " .. v165)
		end
	end

	return v162
end
function t19.jsonEncode(p12) -- line: 984
	local t21 = {}

	if p12.page_entries ~= nil and #p12.page_entries > 0 then
		local t22 = {}

		for _, v180 in p12.page_entries do
			table.insert(t22, v180:jsonEncode())
		end

		t21.pageEntries = t22
	end

	if p12.hydration_data ~= nil then
		t21.hydrationData = p12.hydration_data:jsonEncode()
	end

	if p12.templates ~= nil and next(p12.templates) ~= nil then
		local t23 = {}

		for v182, v183 in p12.templates do
			t23[v182] = v183:jsonEncode()
		end

		t21.templates = t23
	end

	return t21
end
function t19.jsonDecode(t24: {[any]: any}) -- line: 1010
	-- upvalues: t19 (copy), page_entry_content (copy), hydration_content (copy), template_entry (copy)
	local v185 = t19.new()

	if t24.page_entries ~= nil then
		local t25 = {}

		for _, v188 in t24.page_entries do
			table.insert(t25, page_entry_content.UniversalPageEntry.jsonDecode(v188))
		end

		v185.page_entries = t25
	end

	if t24.pageEntries ~= nil then
		local t26 = {}

		for _, v191 in t24.pageEntries do
			table.insert(t26, page_entry_content.UniversalPageEntry.jsonDecode(v191))
		end

		v185.page_entries = t26
	end

	if t24.hydration_data ~= nil then
		v185.hydration_data = hydration_content.HydrationContent.jsonDecode(t24.hydration_data)
	end

	if t24.hydrationData ~= nil then
		v185.hydration_data = hydration_content.HydrationContent.jsonDecode(t24.hydrationData)
	end

	if t24.templates ~= nil then
		local t27 = {}

		for v193, v194 in t24.templates do
			t27[v193] = template_entry.TemplateEntry.jsonDecode(v194)
		end

		v185.templates = t27
	end

	return v185
end

t19.descriptor = {
	name = "BadgeDetailsPageV2Response",
	fullName = "roblox.apppageplatform.badges.v1beta1.BadgeDetailsPageV2Response"
}
t1.BadgeDetailsPageV2Response = t19
typeRegistry.default:register(t1.BadgeDetailsPageV2Response)

local t28 = {}

t28.__index = t28

function t28.new(t29: {[any]: any}?) -- line: 1075
	-- upvalues: t28 (copy)
	return (setmetatable({
		key = if t29 ~= nil and t29.key ~= nil then t29.key else "",
		value = if t29 ~= nil and t29.value ~= nil then t29.value else nil
	}, t28))
end
function t28.encode(p13) -- line: 1084
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n9 = 0

	if p13.key ~= nil and p13.key ~= "" then
		local v199, v200 = proto.writeTag(buf, n9, 1, proto.wireTypes.lengthDelimited)

		buf, n9 = proto.writeString(v199, v200, p13.key)
	end

	if p13.value ~= nil then
		local v201 = p13.value:encode()
		local v202, v203 = proto.writeTag(buf, n9, 2, proto.wireTypes.lengthDelimited)

		buf, n9 = proto.writeBuffer(v202, v203, v201, buffer.len(v201))
	end

	local buf8 = buffer.create(n9)

	buffer.copy(buf8, 0, buf, 0, n9)

	return buf8
end
function t28.decode(p14: buffer) -- line: 1106
	-- upvalues: t28 (copy), proto (copy), template_entry (copy)
	local v206 = t28.new()
	local n10 = 0

	while n10 < buffer.len(p14) do
		local v208, v209

		v208, v209, n10 = proto.readTag(p14, n10)

		if v209 == proto.wireTypes.varint then
			local v210

			v210, n10 = proto.readVarInt(p14, n10)
		elseif v209 == proto.wireTypes.lengthDelimited then
			if v208 == 1 then
				local v211

				v211, n10 = proto.readBuffer(p14, n10)
				v206.key = buffer.tostring(v211)
			elseif v208 == 2 then
				local v212

				v212, n10 = proto.readBuffer(p14, n10)
				v206.value = template_entry.TemplateEntry.decode(v212)
			else
				local v213, v214 = proto.readVarInt(p14, n10)

				n10 = v214 + v213
			end
		elseif v209 == proto.wireTypes.i32 then
			local v215

			v215, n10 = proto.readFixed32(p14, n10)
		elseif v209 == proto.wireTypes.i64 then
			local v216

			v216, n10 = proto.readFixed64(p14, n10)
		else
			error("Unsupported wire type: " .. v209)
		end
	end

	return v206
end
function t28.jsonEncode(p15) -- line: 1156
	local t30 = {}

	if p15.key ~= nil and p15.key ~= "" then
		t30.key = p15.key
	end

	if p15.value ~= nil then
		t30.value = p15.value:jsonEncode()
	end

	return t30
end
function t28.jsonDecode(t31: {[any]: any}) -- line: 1172
	-- upvalues: t28 (copy), template_entry (copy)
	local v220 = t28.new()

	if t31.key ~= nil then
		v220.key = t31.key
	end

	if t31.value ~= nil then
		v220.value = template_entry.TemplateEntry.jsonDecode(t31.value)
	end

	return v220
end

t28.descriptor = {
	name = "BadgeDetailsPageV2Response_TemplatesEntry",
	fullName = "roblox.apppageplatform.badges.v1beta1.TemplatesEntry"
}
t1.BadgeDetailsPageV2Response_TemplatesEntry = t28
typeRegistry.default:register(t1.BadgeDetailsPageV2Response_TemplatesEntry)

local t32 = {}

t32.__index = t32

function t32.new(t33: {[any]: any}?) -- line: 1202
	-- upvalues: t32 (copy)
	return (setmetatable({
		page_entry = if t33 ~= nil and t33.page_entry ~= nil then t33.page_entry else nil,
		kind = if t33 ~= nil and t33.kind ~= nil then t33.kind else nil
	}, t32))
end
function t32.encode(p16) -- line: 1209
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n11 = 0

	if p16.page_entry ~= nil then
		local v225 = p16.page_entry:encode()
		local v226, v227 = proto.writeTag(buf, n11, 1, proto.wireTypes.lengthDelimited)

		buf, n11 = proto.writeBuffer(v226, v227, v225, buffer.len(v225))
	end

	if p16.kind ~= nil and p16.kind.type == "badge_details" then
		local v228 = p16.kind.value:encode()
		local v229, v230 = proto.writeTag(buf, n11, 2, proto.wireTypes.lengthDelimited)

		buf, n11 = proto.writeBuffer(v229, v230, v228, buffer.len(v228))
	end

	local buf9 = buffer.create(n11)

	buffer.copy(buf9, 0, buf, 0, n11)

	return buf9
end
function t32.decode(p17: buffer) -- line: 1232
	-- upvalues: t32 (copy), proto (copy), page_entry (copy), t1 (copy)
	local v233 = t32.new()
	local n12 = 0

	while n12 < buffer.len(p17) do
		local v235, v236

		v235, v236, n12 = proto.readTag(p17, n12)

		if v236 == proto.wireTypes.varint then
			local v237

			v237, n12 = proto.readVarInt(p17, n12)
		elseif v236 == proto.wireTypes.lengthDelimited then
			if v235 == 1 then
				local v238

				v238, n12 = proto.readBuffer(p17, n12)
				v233.page_entry = page_entry.PageEntry.decode(v238)
			elseif v235 == 2 then
				local v239

				v239, n12 = proto.readBuffer(p17, n12)
				v233.kind = {
					type = "badge_details",
					value = t1.BadgeDetailsContent.decode(v239)
				}
			else
				local v240, v241 = proto.readVarInt(p17, n12)

				n12 = v241 + v240
			end
		elseif v236 == proto.wireTypes.i32 then
			local v242

			v242, n12 = proto.readFixed32(p17, n12)
		elseif v236 == proto.wireTypes.i64 then
			local v243

			v243, n12 = proto.readFixed64(p17, n12)
		else
			error("Unsupported wire type: " .. v236)
		end
	end

	return v233
end
function t32.jsonEncode(p18) -- line: 1280
	local t34 = {}

	if p18.page_entry ~= nil then
		t34.pageEntry = p18.page_entry:jsonEncode()
	end

	if p18.kind ~= nil and p18.kind.type == "badge_details" then
		t34.badgeDetails = p18.kind.value:jsonEncode()
	end

	return t34
end
function t32.jsonDecode(t35: {[any]: any}) -- line: 1296
	-- upvalues: t32 (copy), page_entry (copy), t1 (copy)
	local v247 = t32.new()

	if t35.page_entry ~= nil then
		v247.page_entry = page_entry.PageEntry.jsonDecode(t35.page_entry)
	end

	if t35.pageEntry ~= nil then
		v247.page_entry = page_entry.PageEntry.jsonDecode(t35.pageEntry)
	end

	if t35.badge_details ~= nil then
		v247.kind = {
			type = "badge_details",
			value = t1.BadgeDetailsContent.jsonDecode(t35.badge_details)
		}
	end

	if t35.badgeDetails ~= nil then
		v247.kind = {
			type = "badge_details",
			value = t1.BadgeDetailsContent.jsonDecode(t35.badgeDetails)
		}
	end

	return v247
end

t32.descriptor = {
	name = "BadgeDetailsPageEntry",
	fullName = "roblox.apppageplatform.badges.v1beta1.BadgeDetailsPageEntry"
}
t1.BadgeDetailsPageEntry = t32
typeRegistry.default:register(t1.BadgeDetailsPageEntry)

local t36 = {}

t36.__index = t36

function t36.new(t37: {[any]: any}?) -- line: 1332
	-- upvalues: t36 (copy)
	return (setmetatable({
		badge_id = if t37 ~= nil and t37.badge_id ~= nil then t37.badge_id else "",
		universe_id = if t37 ~= nil and t37.universe_id ~= nil then t37.universe_id else "",
		localized_literals = if t37 ~= nil and t37.localized_literals ~= nil then t37.localized_literals else nil,
		creator_key = if t37 ~= nil and t37.creator_key ~= nil then t37.creator_key else ""
	}, t36))
end
function t36.encode(p19) -- line: 1341
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n13 = 0

	if p19.badge_id ~= nil and p19.badge_id ~= "" then
		local v252, v253 = proto.writeTag(buf, n13, 1, proto.wireTypes.lengthDelimited)

		buf, n13 = proto.writeString(v252, v253, p19.badge_id)
	end

	if p19.universe_id ~= nil and p19.universe_id ~= "" then
		local v254, v255 = proto.writeTag(buf, n13, 2, proto.wireTypes.lengthDelimited)

		buf, n13 = proto.writeString(v254, v255, p19.universe_id)
	end

	if p19.localized_literals ~= nil then
		local v256 = p19.localized_literals:encode()
		local v257, v258 = proto.writeTag(buf, n13, 3, proto.wireTypes.lengthDelimited)

		buf, n13 = proto.writeBuffer(v257, v258, v256, buffer.len(v256))
	end

	if p19.creator_key ~= nil and p19.creator_key ~= "" then
		local v259, v260 = proto.writeTag(buf, n13, 4, proto.wireTypes.lengthDelimited)

		buf, n13 = proto.writeString(v259, v260, p19.creator_key)
	end

	local buf10 = buffer.create(n13)

	buffer.copy(buf10, 0, buf, 0, n13)

	return buf10
end
function t36.decode(p20: buffer) -- line: 1371
	-- upvalues: t36 (copy), proto (copy), t1 (copy)
	local v263 = t36.new()
	local n14 = 0

	while n14 < buffer.len(p20) do
		local v265, v266

		v265, v266, n14 = proto.readTag(p20, n14)

		if v266 == proto.wireTypes.varint then
			local v267

			v267, n14 = proto.readVarInt(p20, n14)
		elseif v266 == proto.wireTypes.lengthDelimited then
			if v265 == 1 then
				local v268

				v268, n14 = proto.readBuffer(p20, n14)
				v263.badge_id = buffer.tostring(v268)
			elseif v265 == 2 then
				local v269

				v269, n14 = proto.readBuffer(p20, n14)
				v263.universe_id = buffer.tostring(v269)
			elseif v265 == 3 then
				local v270

				v270, n14 = proto.readBuffer(p20, n14)
				v263.localized_literals = t1.BadgeDetailsContent_LocalizedLiterals.decode(v270)
			elseif v265 == 4 then
				local v271

				v271, n14 = proto.readBuffer(p20, n14)
				v263.creator_key = buffer.tostring(v271)
			else
				local v272, v273 = proto.readVarInt(p20, n14)

				n14 = v273 + v272
			end
		elseif v266 == proto.wireTypes.i32 then
			local v274

			v274, n14 = proto.readFixed32(p20, n14)
		elseif v266 == proto.wireTypes.i64 then
			local v275

			v275, n14 = proto.readFixed64(p20, n14)
		else
			error("Unsupported wire type: " .. v266)
		end
	end

	return v263
end
function t36.jsonEncode(p21) -- line: 1429
	local t38 = {}

	if p21.badge_id ~= nil and p21.badge_id ~= "" then
		t38.badgeId = p21.badge_id
	end

	if p21.universe_id ~= nil and p21.universe_id ~= "" then
		t38.universeId = p21.universe_id
	end

	if p21.localized_literals ~= nil then
		t38.localizedLiterals = p21.localized_literals:jsonEncode()
	end

	if p21.creator_key ~= nil and p21.creator_key ~= "" then
		t38.creatorKey = p21.creator_key
	end

	return t38
end
function t36.jsonDecode(t39: {[any]: any}) -- line: 1451
	-- upvalues: t36 (copy), t1 (copy)
	local v279 = t36.new()

	if t39.badge_id ~= nil then
		v279.badge_id = t39.badge_id
	end

	if t39.badgeId ~= nil then
		v279.badge_id = t39.badgeId
	end

	if t39.universe_id ~= nil then
		v279.universe_id = t39.universe_id
	end

	if t39.universeId ~= nil then
		v279.universe_id = t39.universeId
	end

	if t39.localized_literals ~= nil then
		v279.localized_literals = t1.BadgeDetailsContent_LocalizedLiterals.jsonDecode(t39.localized_literals)
	end

	if t39.localizedLiterals ~= nil then
		v279.localized_literals = t1.BadgeDetailsContent_LocalizedLiterals.jsonDecode(t39.localizedLiterals)
	end

	if t39.creator_key ~= nil then
		v279.creator_key = t39.creator_key
	end

	if t39.creatorKey ~= nil then
		v279.creator_key = t39.creatorKey
	end

	return v279
end

t36.descriptor = {
	name = "BadgeDetailsContent",
	fullName = "roblox.apppageplatform.badges.v1beta1.BadgeDetailsContent"
}
t1.BadgeDetailsContent = t36
typeRegistry.default:register(t1.BadgeDetailsContent)

local t40 = {}

t40.__index = t40

function t40.new(t41: {[any]: any}?) -- line: 1504
	-- upvalues: t40 (copy)
	return (setmetatable({
		info_table = if t41 ~= nil and t41.info_table ~= nil then t41.info_table else nil,
		action_module = if t41 ~= nil and t41.action_module ~= nil then t41.action_module else nil,
		overflow_menu = if t41 ~= nil and t41.overflow_menu ~= nil then t41.overflow_menu else nil
	}, t40))
end
function t40.encode(p22) -- line: 1514
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n15 = 0

	if p22.info_table ~= nil then
		local v284 = p22.info_table:encode()
		local v285, v286 = proto.writeTag(buf, n15, 1, proto.wireTypes.lengthDelimited)

		buf, n15 = proto.writeBuffer(v285, v286, v284, buffer.len(v284))
	end

	if p22.action_module ~= nil then
		local v287 = p22.action_module:encode()
		local v288, v289 = proto.writeTag(buf, n15, 2, proto.wireTypes.lengthDelimited)

		buf, n15 = proto.writeBuffer(v288, v289, v287, buffer.len(v287))
	end

	if p22.overflow_menu ~= nil then
		local v290 = p22.overflow_menu:encode()
		local v291, v292 = proto.writeTag(buf, n15, 3, proto.wireTypes.lengthDelimited)

		buf, n15 = proto.writeBuffer(v291, v292, v290, buffer.len(v290))
	end

	local buf11 = buffer.create(n15)

	buffer.copy(buf11, 0, buf, 0, n15)

	return buf11
end
function t40.decode(p23: buffer) -- line: 1541
	-- upvalues: t40 (copy), proto (copy), t1 (copy)
	local v295 = t40.new()
	local n16 = 0

	while n16 < buffer.len(p23) do
		local v297, v298

		v297, v298, n16 = proto.readTag(p23, n16)

		if v298 == proto.wireTypes.varint then
			local v299

			v299, n16 = proto.readVarInt(p23, n16)
		elseif v298 == proto.wireTypes.lengthDelimited then
			if v297 == 1 then
				local v300

				v300, n16 = proto.readBuffer(p23, n16)
				v295.info_table = t1.BadgeDetailsContent_LocalizedLiterals_InfoTable.decode(v300)
			elseif v297 == 2 then
				local v301

				v301, n16 = proto.readBuffer(p23, n16)
				v295.action_module = t1.BadgeDetailsContent_LocalizedLiterals_ActionModule.decode(v301)
			elseif v297 == 3 then
				local v302

				v302, n16 = proto.readBuffer(p23, n16)
				v295.overflow_menu = t1.BadgeDetailsContent_LocalizedLiterals_OverflowMenu.decode(v302)
			else
				local v303, v304 = proto.readVarInt(p23, n16)

				n16 = v304 + v303
			end
		elseif v298 == proto.wireTypes.i32 then
			local v305

			v305, n16 = proto.readFixed32(p23, n16)
		elseif v298 == proto.wireTypes.i64 then
			local v306

			v306, n16 = proto.readFixed64(p23, n16)
		else
			error("Unsupported wire type: " .. v298)
		end
	end

	return v295
end
function t40.jsonEncode(p24) -- line: 1594
	local t42 = {}

	if p24.info_table ~= nil then
		t42.infoTable = p24.info_table:jsonEncode()
	end

	if p24.action_module ~= nil then
		t42.actionModule = p24.action_module:jsonEncode()
	end

	if p24.overflow_menu ~= nil then
		t42.overflowMenu = p24.overflow_menu:jsonEncode()
	end

	return t42
end
function t40.jsonDecode(t43: {[any]: any}) -- line: 1612
	-- upvalues: t40 (copy), t1 (copy)
	local v310 = t40.new()

	if t43.info_table ~= nil then
		v310.info_table = t1.BadgeDetailsContent_LocalizedLiterals_InfoTable.jsonDecode(t43.info_table)
	end

	if t43.infoTable ~= nil then
		v310.info_table = t1.BadgeDetailsContent_LocalizedLiterals_InfoTable.jsonDecode(t43.infoTable)
	end

	if t43.action_module ~= nil then
		v310.action_module = t1.BadgeDetailsContent_LocalizedLiterals_ActionModule.jsonDecode(t43.action_module)
	end

	if t43.actionModule ~= nil then
		v310.action_module = t1.BadgeDetailsContent_LocalizedLiterals_ActionModule.jsonDecode(t43.actionModule)
	end

	if t43.overflow_menu ~= nil then
		v310.overflow_menu = t1.BadgeDetailsContent_LocalizedLiterals_OverflowMenu.jsonDecode(t43.overflow_menu)
	end

	if t43.overflowMenu ~= nil then
		v310.overflow_menu = t1.BadgeDetailsContent_LocalizedLiterals_OverflowMenu.jsonDecode(t43.overflowMenu)
	end

	return v310
end

t40.descriptor = {
	name = "BadgeDetailsContent_LocalizedLiterals",
	fullName = "roblox.apppageplatform.badges.v1beta1.LocalizedLiterals"
}
t1.BadgeDetailsContent_LocalizedLiterals = t40
typeRegistry.default:register(t1.BadgeDetailsContent_LocalizedLiterals)

local t44 = {}

t44.__index = t44

function t44.new(t45: {[any]: any}?) -- line: 1662
	-- upvalues: t44 (copy)
	return (setmetatable({
		type_label = if t45 ~= nil and t45.type_label ~= nil then t45.type_label else "",
		earned_label = if t45 ~= nil and t45.earned_label ~= nil then t45.earned_label else "",
		updated_label = if t45 ~= nil and t45.updated_label ~= nil then t45.updated_label else "",
		experience_label = if t45 ~= nil and t45.experience_label ~= nil then t45.experience_label else "",
		rarity_label = if t45 ~= nil and t45.rarity_label ~= nil then t45.rarity_label else "",
		won_yesterday_label = if t45 ~= nil and t45.won_yesterday_label ~= nil then t45.won_yesterday_label else "",
		won_ever_label = if t45 ~= nil and t45.won_ever_label ~= nil then t45.won_ever_label else ""
	}, t44))
end
function t44.encode(p25) -- line: 1678
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n17 = 0

	if p25.type_label ~= nil and p25.type_label ~= "" then
		local v315, v316 = proto.writeTag(buf, n17, 1, proto.wireTypes.lengthDelimited)

		buf, n17 = proto.writeString(v315, v316, p25.type_label)
	end

	if p25.earned_label ~= nil and p25.earned_label ~= "" then
		local v317, v318 = proto.writeTag(buf, n17, 2, proto.wireTypes.lengthDelimited)

		buf, n17 = proto.writeString(v317, v318, p25.earned_label)
	end

	if p25.updated_label ~= nil and p25.updated_label ~= "" then
		local v319, v320 = proto.writeTag(buf, n17, 3, proto.wireTypes.lengthDelimited)

		buf, n17 = proto.writeString(v319, v320, p25.updated_label)
	end

	if p25.experience_label ~= nil and p25.experience_label ~= "" then
		local v321, v322 = proto.writeTag(buf, n17, 4, proto.wireTypes.lengthDelimited)

		buf, n17 = proto.writeString(v321, v322, p25.experience_label)
	end

	if p25.rarity_label ~= nil and p25.rarity_label ~= "" then
		local v323, v324 = proto.writeTag(buf, n17, 5, proto.wireTypes.lengthDelimited)

		buf, n17 = proto.writeString(v323, v324, p25.rarity_label)
	end

	if p25.won_yesterday_label ~= nil and p25.won_yesterday_label ~= "" then
		local v325, v326 = proto.writeTag(buf, n17, 6, proto.wireTypes.lengthDelimited)

		buf, n17 = proto.writeString(v325, v326, p25.won_yesterday_label)
	end

	if p25.won_ever_label ~= nil and p25.won_ever_label ~= "" then
		local v327, v328 = proto.writeTag(buf, n17, 7, proto.wireTypes.lengthDelimited)

		buf, n17 = proto.writeString(v327, v328, p25.won_ever_label)
	end

	local buf12 = buffer.create(n17)

	buffer.copy(buf12, 0, buf, 0, n17)

	return buf12
end
function t44.decode(p26: buffer) -- line: 1724
	-- upvalues: t44 (copy), proto (copy)
	local v331 = t44.new()
	local n18 = 0

	while n18 < buffer.len(p26) do
		local v333, v334

		v333, v334, n18 = proto.readTag(p26, n18)

		if v334 == proto.wireTypes.varint then
			local v335

			v335, n18 = proto.readVarInt(p26, n18)
		elseif v334 == proto.wireTypes.lengthDelimited then
			if v333 == 1 then
				local v336

				v336, n18 = proto.readBuffer(p26, n18)
				v331.type_label = buffer.tostring(v336)
			elseif v333 == 2 then
				local v337

				v337, n18 = proto.readBuffer(p26, n18)
				v331.earned_label = buffer.tostring(v337)
			elseif v333 == 3 then
				local v338

				v338, n18 = proto.readBuffer(p26, n18)
				v331.updated_label = buffer.tostring(v338)
			elseif v333 == 4 then
				local v339

				v339, n18 = proto.readBuffer(p26, n18)
				v331.experience_label = buffer.tostring(v339)
			elseif v333 == 5 then
				local v340

				v340, n18 = proto.readBuffer(p26, n18)
				v331.rarity_label = buffer.tostring(v340)
			elseif v333 == 6 then
				local v341

				v341, n18 = proto.readBuffer(p26, n18)
				v331.won_yesterday_label = buffer.tostring(v341)
			elseif v333 == 7 then
				local v342

				v342, n18 = proto.readBuffer(p26, n18)
				v331.won_ever_label = buffer.tostring(v342)
			else
				local v343, v344 = proto.readVarInt(p26, n18)

				n18 = v344 + v343
			end
		elseif v334 == proto.wireTypes.i32 then
			local v345

			v345, n18 = proto.readFixed32(p26, n18)
		elseif v334 == proto.wireTypes.i64 then
			local v346

			v346, n18 = proto.readFixed64(p26, n18)
		else
			error("Unsupported wire type: " .. v334)
		end
	end

	return v331
end
function t44.jsonEncode(p27) -- line: 1799
	local t46 = {}

	if p27.type_label ~= nil and p27.type_label ~= "" then
		t46.typeLabel = p27.type_label
	end

	if p27.earned_label ~= nil and p27.earned_label ~= "" then
		t46.earnedLabel = p27.earned_label
	end

	if p27.updated_label ~= nil and p27.updated_label ~= "" then
		t46.updatedLabel = p27.updated_label
	end

	if p27.experience_label ~= nil and p27.experience_label ~= "" then
		t46.experienceLabel = p27.experience_label
	end

	if p27.rarity_label ~= nil and p27.rarity_label ~= "" then
		t46.rarityLabel = p27.rarity_label
	end

	if p27.won_yesterday_label ~= nil and p27.won_yesterday_label ~= "" then
		t46.wonYesterdayLabel = p27.won_yesterday_label
	end

	if p27.won_ever_label ~= nil and p27.won_ever_label ~= "" then
		t46.wonEverLabel = p27.won_ever_label
	end

	return t46
end
function t44.jsonDecode(t47: {[any]: any}) -- line: 1835
	-- upvalues: t44 (copy)
	local v350 = t44.new()

	if t47.type_label ~= nil then
		v350.type_label = t47.type_label
	end

	if t47.typeLabel ~= nil then
		v350.type_label = t47.typeLabel
	end

	if t47.earned_label ~= nil then
		v350.earned_label = t47.earned_label
	end

	if t47.earnedLabel ~= nil then
		v350.earned_label = t47.earnedLabel
	end

	if t47.updated_label ~= nil then
		v350.updated_label = t47.updated_label
	end

	if t47.updatedLabel ~= nil then
		v350.updated_label = t47.updatedLabel
	end

	if t47.experience_label ~= nil then
		v350.experience_label = t47.experience_label
	end

	if t47.experienceLabel ~= nil then
		v350.experience_label = t47.experienceLabel
	end

	if t47.rarity_label ~= nil then
		v350.rarity_label = t47.rarity_label
	end

	if t47.rarityLabel ~= nil then
		v350.rarity_label = t47.rarityLabel
	end

	if t47.won_yesterday_label ~= nil then
		v350.won_yesterday_label = t47.won_yesterday_label
	end

	if t47.wonYesterdayLabel ~= nil then
		v350.won_yesterday_label = t47.wonYesterdayLabel
	end

	if t47.won_ever_label ~= nil then
		v350.won_ever_label = t47.won_ever_label
	end

	if t47.wonEverLabel ~= nil then
		v350.won_ever_label = t47.wonEverLabel
	end

	return v350
end

t44.descriptor = {
	name = "BadgeDetailsContent_LocalizedLiterals_InfoTable",
	fullName = "roblox.apppageplatform.badges.v1beta1.InfoTable"
}
t1.BadgeDetailsContent_LocalizedLiterals_InfoTable = t44
typeRegistry.default:register(t1.BadgeDetailsContent_LocalizedLiterals_InfoTable)

local t48 = {}

t48.__index = t48

function t48.new(t49: {[any]: any}?) -- line: 1915
	-- upvalues: t48 (copy)
	return (setmetatable({
		share = if t49 ~= nil and t49.share ~= nil then t49.share else "",
		report = if t49 ~= nil and t49.report ~= nil then t49.report else ""
	}, t48))
end
function t48.encode(p28) -- line: 1927
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n19 = 0

	if p28.share ~= nil and p28.share ~= "" then
		local v355, v356 = proto.writeTag(buf, n19, 1, proto.wireTypes.lengthDelimited)

		buf, n19 = proto.writeString(v355, v356, p28.share)
	end

	if p28.report ~= nil and p28.report ~= "" then
		local v357, v358 = proto.writeTag(buf, n19, 2, proto.wireTypes.lengthDelimited)

		buf, n19 = proto.writeString(v357, v358, p28.report)
	end

	local buf13 = buffer.create(n19)

	buffer.copy(buf13, 0, buf, 0, n19)

	return buf13
end
function t48.decode(p29: buffer) -- line: 1948
	-- upvalues: t48 (copy), proto (copy)
	local v361 = t48.new()
	local n20 = 0

	while n20 < buffer.len(p29) do
		local v363, v364

		v363, v364, n20 = proto.readTag(p29, n20)

		if v364 == proto.wireTypes.varint then
			local v365

			v365, n20 = proto.readVarInt(p29, n20)
		elseif v364 == proto.wireTypes.lengthDelimited then
			if v363 == 1 then
				local v366

				v366, n20 = proto.readBuffer(p29, n20)
				v361.share = buffer.tostring(v366)
			elseif v363 == 2 then
				local v367

				v367, n20 = proto.readBuffer(p29, n20)
				v361.report = buffer.tostring(v367)
			else
				local v368, v369 = proto.readVarInt(p29, n20)

				n20 = v369 + v368
			end
		elseif v364 == proto.wireTypes.i32 then
			local v370

			v370, n20 = proto.readFixed32(p29, n20)
		elseif v364 == proto.wireTypes.i64 then
			local v371

			v371, n20 = proto.readFixed64(p29, n20)
		else
			error("Unsupported wire type: " .. v364)
		end
	end

	return v361
end
function t48.jsonEncode(p30) -- line: 1998
	local t50 = {}

	if p30.share ~= nil and p30.share ~= "" then
		t50.share = p30.share
	end

	if p30.report ~= nil and p30.report ~= "" then
		t50.report = p30.report
	end

	return t50
end
function t48.jsonDecode(t51: {[any]: any}) -- line: 2014
	-- upvalues: t48 (copy)
	local v375 = t48.new()

	if t51.share ~= nil then
		v375.share = t51.share
	end

	if t51.report ~= nil then
		v375.report = t51.report
	end

	return v375
end

t48.descriptor = {
	name = "BadgeDetailsContent_LocalizedLiterals_ActionModule",
	fullName = "roblox.apppageplatform.badges.v1beta1.ActionModule"
}
t1.BadgeDetailsContent_LocalizedLiterals_ActionModule = t48
typeRegistry.default:register(t1.BadgeDetailsContent_LocalizedLiterals_ActionModule)

local t52 = {}

t52.__index = t52

function t52.new(t53: {[any]: any}?) -- line: 2046
	-- upvalues: t52 (copy)
	return (setmetatable({
		report = if t53 ~= nil and t53.report ~= nil then t53.report else "",
		remove = if t53 ~= nil and t53.remove ~= nil then t53.remove else ""
	}, t52))
end
function t52.encode(p31) -- line: 2058
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n21 = 0

	if p31.report ~= nil and p31.report ~= "" then
		local v380, v381 = proto.writeTag(buf, n21, 1, proto.wireTypes.lengthDelimited)

		buf, n21 = proto.writeString(v380, v381, p31.report)
	end

	if p31.remove ~= nil and p31.remove ~= "" then
		local v382, v383 = proto.writeTag(buf, n21, 2, proto.wireTypes.lengthDelimited)

		buf, n21 = proto.writeString(v382, v383, p31.remove)
	end

	local buf14 = buffer.create(n21)

	buffer.copy(buf14, 0, buf, 0, n21)

	return buf14
end
function t52.decode(p32: buffer) -- line: 2079
	-- upvalues: t52 (copy), proto (copy)
	local v386 = t52.new()
	local n22 = 0

	while n22 < buffer.len(p32) do
		local v388, v389

		v388, v389, n22 = proto.readTag(p32, n22)

		if v389 == proto.wireTypes.varint then
			local v390

			v390, n22 = proto.readVarInt(p32, n22)
		elseif v389 == proto.wireTypes.lengthDelimited then
			if v388 == 1 then
				local v391

				v391, n22 = proto.readBuffer(p32, n22)
				v386.report = buffer.tostring(v391)
			elseif v388 == 2 then
				local v392

				v392, n22 = proto.readBuffer(p32, n22)
				v386.remove = buffer.tostring(v392)
			else
				local v393, v394 = proto.readVarInt(p32, n22)

				n22 = v394 + v393
			end
		elseif v389 == proto.wireTypes.i32 then
			local v395

			v395, n22 = proto.readFixed32(p32, n22)
		elseif v389 == proto.wireTypes.i64 then
			local v396

			v396, n22 = proto.readFixed64(p32, n22)
		else
			error("Unsupported wire type: " .. v389)
		end
	end

	return v386
end
function t52.jsonEncode(p33) -- line: 2129
	local t54 = {}

	if p33.report ~= nil and p33.report ~= "" then
		t54.report = p33.report
	end

	if p33.remove ~= nil and p33.remove ~= "" then
		t54.remove = p33.remove
	end

	return t54
end
function t52.jsonDecode(t55: {[any]: any}) -- line: 2145
	-- upvalues: t52 (copy)
	local v400 = t52.new()

	if t55.report ~= nil then
		v400.report = t55.report
	end

	if t55.remove ~= nil then
		v400.remove = t55.remove
	end

	return v400
end

t52.descriptor = {
	name = "BadgeDetailsContent_LocalizedLiterals_OverflowMenu",
	fullName = "roblox.apppageplatform.badges.v1beta1.OverflowMenu"
}
t1.BadgeDetailsContent_LocalizedLiterals_OverflowMenu = t52
typeRegistry.default:register(t1.BadgeDetailsContent_LocalizedLiterals_OverflowMenu)

return {
	BadgeDetailsPageRequest = t1.BadgeDetailsPageRequest,
	BadgeDetailsPageResponse = t1.BadgeDetailsPageResponse,
	BadgeDetailsPageV2Response = t1.BadgeDetailsPageV2Response,
	BadgeDetailsPageEntry = t1.BadgeDetailsPageEntry,
	BadgeDetailsContent = t1.BadgeDetailsContent,
	BadgeDetailsContent_LocalizedLiterals = t1.BadgeDetailsContent_LocalizedLiterals,
	BadgeDetailsContent_LocalizedLiterals_InfoTable = t1.BadgeDetailsContent_LocalizedLiterals_InfoTable,
	BadgeDetailsContent_LocalizedLiterals_ActionModule = t1.BadgeDetailsContent_LocalizedLiterals_ActionModule,
	BadgeDetailsContent_LocalizedLiterals_OverflowMenu = t1.BadgeDetailsContent_LocalizedLiterals_OverflowMenu
}
