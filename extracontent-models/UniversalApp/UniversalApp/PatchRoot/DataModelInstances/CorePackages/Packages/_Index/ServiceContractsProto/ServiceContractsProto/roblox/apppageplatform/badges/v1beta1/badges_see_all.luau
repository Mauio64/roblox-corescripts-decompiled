local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local hydration_content = require(script.Parent.Parent.Parent.shared.v1beta1.hydration_content)
local template_entry = require(script.Parent.Parent.Parent.shared.v1beta1.template_entry)
local page_entry = require(script.Parent.Parent.Parent.shared.v1beta1.page_entry)
local page_entry_content = require(script.Parent.Parent.Parent.shared.v1beta1.page_entry_content)
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 290
	-- upvalues: page_entry_content (copy), t2 (copy)
	return (setmetatable({
		universe_id = if t3 ~= nil and t3.universe_id ~= nil then t3.universe_id else 0,
		user_id = if t3 ~= nil and t3.user_id ~= nil then t3.user_id else 0,
		page_size = if t3 ~= nil and t3.page_size ~= nil then t3.page_size else 0,
		cursor = if t3 ~= nil and t3.cursor ~= nil then t3.cursor else "",
		page_entry_format = if t3 ~= nil and t3.page_entry_format ~= nil then t3.page_entry_format else assert(page_entry_content.PageEntryFormat.fromNumber(0), "Enum has no 0 default")
	}, t2))
end
function t2.encode(p1) -- line: 305
	-- upvalues: proto (copy), page_entry_content (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.universe_id ~= nil and p1.universe_id ~= 0 then
		local v21, v22 = proto.writeTag(buf, n1, 1, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v21, v22, p1.universe_id)
	end

	if p1.user_id ~= nil and p1.user_id ~= 0 then
		local v23, v24 = proto.writeTag(buf, n1, 2, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v23, v24, p1.user_id)
	end

	if p1.page_size ~= nil and p1.page_size ~= 0 then
		local v25, v26 = proto.writeTag(buf, n1, 3, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v25, v26, p1.page_size)
	end

	if p1.cursor ~= nil and p1.cursor ~= "" then
		local v27, v28 = proto.writeTag(buf, n1, 4, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v27, v28, p1.cursor)
	end

	if p1.page_entry_format ~= nil and (p1.page_entry_format ~= nil and p1.page_entry_format ~= 0 or p1.page_entry_format ~= page_entry_content.PageEntryFormat.fromNumber(0)) then
		local v29, v30 = proto.writeTag(buf, n1, 5, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v29, v30, page_entry_content.PageEntryFormat.toNumber(p1.page_entry_format))
	end

	local buf2 = buffer.create(n1)

	buffer.copy(buf2, 0, buf, 0, n1)

	return buf2
end
function t2.decode(p2: buffer) -- line: 352
	-- upvalues: t2 (copy), proto (copy), page_entry_content (copy)
	local v33 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v35, v36

		v35, v36, n2 = proto.readTag(p2, n2)

		if v36 == proto.wireTypes.varint then
			if v35 == 1 then
				local v37

				v37, n2 = proto.readVarIntI64(p2, n2)
				v33.universe_id = v37
			elseif v35 == 2 then
				local v38

				v38, n2 = proto.readVarIntI64(p2, n2)
				v33.user_id = v38
			elseif v35 == 3 then
				local v39

				v39, n2 = proto.readVarIntI32(p2, n2)
				v33.page_size = v39
			elseif v35 == 5 then
				local v40

				v40, n2 = proto.readVarIntI32(p2, n2)
				v33.page_entry_format = page_entry_content.PageEntryFormat.fromNumber(v40) or v40
			else
				local v41

				v41, n2 = proto.readVarInt(p2, n2)
			end
		elseif v36 == proto.wireTypes.lengthDelimited then
			if v35 == 4 then
				local v42

				v42, n2 = proto.readBuffer(p2, n2)
				v33.cursor = buffer.tostring(v42)
			else
				local v43, v44 = proto.readVarInt(p2, n2)

				n2 = v44 + v43
			end
		elseif v36 == proto.wireTypes.i32 then
			local v45

			v45, n2 = proto.readFixed32(p2, n2)
		elseif v36 == proto.wireTypes.i64 then
			local v46

			v46, n2 = proto.readFixed64(p2, n2)
		else
			error("Unsupported wire type: " .. v36)
		end
	end

	return v33
end
function t2.jsonEncode(p3) -- line: 418
	-- upvalues: page_entry_content (copy)
	local t4 = {}

	if p3.universe_id ~= nil and p3.universe_id ~= 0 then
		t4.universeId = p3.universe_id
	end

	if p3.user_id ~= nil and p3.user_id ~= 0 then
		t4.userId = p3.user_id
	end

	if p3.page_size ~= nil and p3.page_size ~= 0 then
		t4.pageSize = p3.page_size
	end

	if p3.cursor ~= nil and p3.cursor ~= "" then
		t4.cursor = p3.cursor
	end

	if p3.page_entry_format ~= nil and (p3.page_entry_format ~= nil and p3.page_entry_format ~= 0 or p3.page_entry_format ~= page_entry_content.PageEntryFormat.fromNumber(0)) then
		t4.pageEntryFormat = if typeof(p3.page_entry_format) ~= "number" then page_entry_content.PageEntryFormat.toNumber(p3.page_entry_format) else p3.page_entry_format
	end

	return t4
end
function t2.jsonDecode(t5: {[any]: any}) -- line: 455
	-- upvalues: t2 (copy), page_entry_content (copy)
	local v50 = t2.new()

	if t5.universe_id ~= nil then
		v50.universe_id = t5.universe_id
	end

	if t5.universeId ~= nil then
		v50.universe_id = t5.universeId
	end

	if t5.user_id ~= nil then
		v50.user_id = t5.user_id
	end

	if t5.userId ~= nil then
		v50.user_id = t5.userId
	end

	if t5.page_size ~= nil then
		v50.page_size = t5.page_size
	end

	if t5.pageSize ~= nil then
		v50.page_size = t5.pageSize
	end

	if t5.cursor ~= nil then
		v50.cursor = t5.cursor
	end

	if t5.page_entry_format ~= nil then
		v50.page_entry_format = if typeof(t5.page_entry_format) ~= "number" then page_entry_content.PageEntryFormat.fromName(t5.page_entry_format) or t5.page_entry_format else page_entry_content.PageEntryFormat.fromNumber(t5.page_entry_format) or t5.page_entry_format
	end

	if t5.pageEntryFormat ~= nil then
		v50.page_entry_format = if typeof(t5.pageEntryFormat) ~= "number" then page_entry_content.PageEntryFormat.fromName(t5.pageEntryFormat) or t5.pageEntryFormat else page_entry_content.PageEntryFormat.fromNumber(t5.pageEntryFormat) or t5.pageEntryFormat
	end

	return v50
end

t2.descriptor = {
	name = "BadgesSeeAllRequest",
	fullName = "roblox.apppageplatform.badges.v1beta1.BadgesSeeAllRequest"
}
t1.BadgesSeeAllRequest = t2
typeRegistry.default:register(t1.BadgesSeeAllRequest)

local t6 = {}

t6.__index = t6

function t6.new(t7: {[any]: any}?) -- line: 523
	-- upvalues: t6 (copy)
	return (setmetatable({
		page_size = if t7 ~= nil and t7.page_size ~= nil then t7.page_size else 0,
		next_cursor = if t7 ~= nil and t7.next_cursor ~= nil then t7.next_cursor else "",
		prev_cursor = if t7 ~= nil and t7.prev_cursor ~= nil then t7.prev_cursor else "",
		total = if t7 ~= nil and t7.total ~= nil then t7.total else 0
	}, t6))
end
function t6.encode(p4) -- line: 532
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n3 = 0

	if p4.page_size ~= nil and p4.page_size ~= 0 then
		local v55, v56 = proto.writeTag(buf, n3, 1, proto.wireTypes.varint)

		buf, n3 = proto.writeVarInt(v55, v56, p4.page_size)
	end

	if p4.next_cursor ~= nil and p4.next_cursor ~= "" then
		local v57, v58 = proto.writeTag(buf, n3, 2, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeString(v57, v58, p4.next_cursor)
	end

	if p4.prev_cursor ~= nil and p4.prev_cursor ~= "" then
		local v59, v60 = proto.writeTag(buf, n3, 3, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeString(v59, v60, p4.prev_cursor)
	end

	if p4.total ~= nil and p4.total ~= 0 then
		local v61, v62 = proto.writeTag(buf, n3, 4, proto.wireTypes.varint)

		buf, n3 = proto.writeVarInt(v61, v62, p4.total)
	end

	local buf3 = buffer.create(n3)

	buffer.copy(buf3, 0, buf, 0, n3)

	return buf3
end
function t6.decode(p5: buffer) -- line: 561
	-- upvalues: t6 (copy), proto (copy)
	local v65 = t6.new()
	local n4 = 0

	while n4 < buffer.len(p5) do
		local v67, v68

		v67, v68, n4 = proto.readTag(p5, n4)

		if v68 == proto.wireTypes.varint then
			if v67 == 1 then
				local v69

				v69, n4 = proto.readVarIntI32(p5, n4)
				v65.page_size = v69
			elseif v67 == 4 then
				local v70

				v70, n4 = proto.readVarIntI64(p5, n4)
				v65.total = v70
			else
				local v71

				v71, n4 = proto.readVarInt(p5, n4)
			end
		elseif v68 == proto.wireTypes.lengthDelimited then
			if v67 == 2 then
				local v72

				v72, n4 = proto.readBuffer(p5, n4)
				v65.next_cursor = buffer.tostring(v72)
			elseif v67 == 3 then
				local v73

				v73, n4 = proto.readBuffer(p5, n4)
				v65.prev_cursor = buffer.tostring(v73)
			else
				local v74, v75 = proto.readVarInt(p5, n4)

				n4 = v75 + v74
			end
		elseif v68 == proto.wireTypes.i32 then
			local v76

			v76, n4 = proto.readFixed32(p5, n4)
		elseif v68 == proto.wireTypes.i64 then
			local v77

			v77, n4 = proto.readFixed64(p5, n4)
		else
			error("Unsupported wire type: " .. v68)
		end
	end

	return v65
end
function t6.jsonEncode(p6) -- line: 619
	local t8 = {}

	if p6.page_size ~= nil and p6.page_size ~= 0 then
		t8.pageSize = p6.page_size
	end

	if p6.next_cursor ~= nil and p6.next_cursor ~= "" then
		t8.nextCursor = p6.next_cursor
	end

	if p6.prev_cursor ~= nil and p6.prev_cursor ~= "" then
		t8.prevCursor = p6.prev_cursor
	end

	if p6.total ~= nil and p6.total ~= 0 then
		t8.total = p6.total
	end

	return t8
end
function t6.jsonDecode(t9: {[any]: any}) -- line: 641
	-- upvalues: t6 (copy)
	local v81 = t6.new()

	if t9.page_size ~= nil then
		v81.page_size = t9.page_size
	end

	if t9.pageSize ~= nil then
		v81.page_size = t9.pageSize
	end

	if t9.next_cursor ~= nil then
		v81.next_cursor = t9.next_cursor
	end

	if t9.nextCursor ~= nil then
		v81.next_cursor = t9.nextCursor
	end

	if t9.prev_cursor ~= nil then
		v81.prev_cursor = t9.prev_cursor
	end

	if t9.prevCursor ~= nil then
		v81.prev_cursor = t9.prevCursor
	end

	if t9.total ~= nil then
		v81.total = t9.total
	end

	return v81
end

t6.descriptor = {
	name = "Pagination",
	fullName = "roblox.apppageplatform.badges.v1beta1.Pagination"
}
t1.Pagination = t6
typeRegistry.default:register(t1.Pagination)

local t10 = {}

t10.__index = t10

function t10.new(t11: {[any]: any}?) -- line: 689
	-- upvalues: t10 (copy)
	return (setmetatable({
		section_title = if t11 ~= nil and t11.section_title ~= nil then t11.section_title else "",
		badges = if t11 ~= nil and t11.badges ~= nil then t11.badges else {},
		collection_id = if t11 ~= nil and t11.collection_id ~= nil then t11.collection_id else "",
		collection_position = if t11 ~= nil and t11.collection_position ~= nil then t11.collection_position else "",
		universe_id = if t11 ~= nil and t11.universe_id ~= nil then t11.universe_id else ""
	}, t10))
end
function t10.encode(p7) -- line: 701
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n5 = 0

	if p7.section_title ~= nil and p7.section_title ~= "" then
		local v86, v87 = proto.writeTag(buf, n5, 1, proto.wireTypes.lengthDelimited)

		buf, n5 = proto.writeString(v86, v87, p7.section_title)
	end

	if p7.badges ~= nil and #p7.badges > 0 then
		for _, v89 in p7.badges do
			local v90 = v89:encode()
			local v91, v92 = proto.writeTag(buf, n5, 2, proto.wireTypes.lengthDelimited)

			buf, n5 = proto.writeBuffer(v91, v92, v90, buffer.len(v90))
		end
	end

	if p7.collection_id ~= nil and p7.collection_id ~= "" then
		local v93, v94 = proto.writeTag(buf, n5, 3, proto.wireTypes.lengthDelimited)

		buf, n5 = proto.writeString(v93, v94, p7.collection_id)
	end

	if p7.collection_position ~= nil and p7.collection_position ~= "" then
		local v95, v96 = proto.writeTag(buf, n5, 4, proto.wireTypes.lengthDelimited)

		buf, n5 = proto.writeString(v95, v96, p7.collection_position)
	end

	if p7.universe_id ~= nil and p7.universe_id ~= "" then
		local v97, v98 = proto.writeTag(buf, n5, 5, proto.wireTypes.lengthDelimited)

		buf, n5 = proto.writeString(v97, v98, p7.universe_id)
	end

	local buf4 = buffer.create(n5)

	buffer.copy(buf4, 0, buf, 0, n5)

	return buf4
end
function t10.decode(p8: buffer) -- line: 738
	-- upvalues: t10 (copy), proto (copy), t1 (copy)
	local v101 = t10.new()
	local n6 = 0

	while n6 < buffer.len(p8) do
		local v103, v104

		v103, v104, n6 = proto.readTag(p8, n6)

		if v104 == proto.wireTypes.varint then
			local v105

			v105, n6 = proto.readVarInt(p8, n6)
		elseif v104 == proto.wireTypes.lengthDelimited then
			if v103 == 1 then
				local v106

				v106, n6 = proto.readBuffer(p8, n6)
				v101.section_title = buffer.tostring(v106)
			elseif v103 == 2 then
				local v107

				v107, n6 = proto.readBuffer(p8, n6)
				table.insert(v101.badges, t1.BadgesGridPageEntry_BadgeInputData.decode(v107))
			elseif v103 == 3 then
				local v108

				v108, n6 = proto.readBuffer(p8, n6)
				v101.collection_id = buffer.tostring(v108)
			elseif v103 == 4 then
				local v109

				v109, n6 = proto.readBuffer(p8, n6)
				v101.collection_position = buffer.tostring(v109)
			elseif v103 == 5 then
				local v110

				v110, n6 = proto.readBuffer(p8, n6)
				v101.universe_id = buffer.tostring(v110)
			else
				local v111, v112 = proto.readVarInt(p8, n6)

				n6 = v112 + v111
			end
		elseif v104 == proto.wireTypes.i32 then
			local v113

			v113, n6 = proto.readFixed32(p8, n6)
		elseif v104 == proto.wireTypes.i64 then
			local v114

			v114, n6 = proto.readFixed64(p8, n6)
		else
			error("Unsupported wire type: " .. v104)
		end
	end

	return v101
end
function t10.jsonEncode(p9) -- line: 801
	local t12 = {}

	if p9.section_title ~= nil and p9.section_title ~= "" then
		t12.sectionTitle = p9.section_title
	end

	if p9.badges ~= nil and #p9.badges > 0 then
		local t13 = {}

		for _, v119 in p9.badges do
			table.insert(t13, v119:jsonEncode())
		end

		t12.badges = t13
	end

	if p9.collection_id ~= nil and p9.collection_id ~= "" then
		t12.collectionId = p9.collection_id
	end

	if p9.collection_position ~= nil and p9.collection_position ~= "" then
		t12.collectionPosition = p9.collection_position
	end

	if p9.universe_id ~= nil and p9.universe_id ~= "" then
		t12.universeId = p9.universe_id
	end

	return t12
end
function t10.jsonDecode(t14: {[any]: any}) -- line: 831
	-- upvalues: t10 (copy), t1 (copy)
	local v121 = t10.new()

	if t14.section_title ~= nil then
		v121.section_title = t14.section_title
	end

	if t14.sectionTitle ~= nil then
		v121.section_title = t14.sectionTitle
	end

	if t14.badges ~= nil then
		local t15 = {}

		for _, v124 in t14.badges do
			table.insert(t15, t1.BadgesGridPageEntry_BadgeInputData.jsonDecode(v124))
		end

		v121.badges = t15
	end

	if t14.collection_id ~= nil then
		v121.collection_id = t14.collection_id
	end

	if t14.collectionId ~= nil then
		v121.collection_id = t14.collectionId
	end

	if t14.collection_position ~= nil then
		v121.collection_position = t14.collection_position
	end

	if t14.collectionPosition ~= nil then
		v121.collection_position = t14.collectionPosition
	end

	if t14.universe_id ~= nil then
		v121.universe_id = t14.universe_id
	end

	if t14.universeId ~= nil then
		v121.universe_id = t14.universeId
	end

	return v121
end

t10.descriptor = {
	name = "BadgesGridPageEntry",
	fullName = "roblox.apppageplatform.badges.v1beta1.BadgesGridPageEntry"
}
t1.BadgesGridPageEntry = t10
typeRegistry.default:register(t1.BadgesGridPageEntry)

local t16 = {}

t16.__index = t16

function t16.new(t17: {[any]: any}?) -- line: 892
	-- upvalues: t16 (copy)
	return (setmetatable({
		badge_id = if t17 ~= nil and t17.badge_id ~= nil then t17.badge_id else ""
	}, t16))
end
function t16.encode(p10) -- line: 900
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n7 = 0

	if p10.badge_id ~= nil and p10.badge_id ~= "" then
		local v129, v130 = proto.writeTag(buf, n7, 1, proto.wireTypes.lengthDelimited)

		buf, n7 = proto.writeString(v129, v130, p10.badge_id)
	end

	local buf5 = buffer.create(n7)

	buffer.copy(buf5, 0, buf, 0, n7)

	return buf5
end
function t16.decode(p11: buffer) -- line: 914
	-- upvalues: t16 (copy), proto (copy)
	local v133 = t16.new()
	local n8 = 0

	while n8 < buffer.len(p11) do
		local v135, v136

		v135, v136, n8 = proto.readTag(p11, n8)

		if v136 == proto.wireTypes.varint then
			local v137

			v137, n8 = proto.readVarInt(p11, n8)
		elseif v136 == proto.wireTypes.lengthDelimited then
			if v135 == 1 then
				local v138

				v138, n8 = proto.readBuffer(p11, n8)
				v133.badge_id = buffer.tostring(v138)
			else
				local v139, v140 = proto.readVarInt(p11, n8)

				n8 = v140 + v139
			end
		elseif v136 == proto.wireTypes.i32 then
			local v141

			v141, n8 = proto.readFixed32(p11, n8)
		elseif v136 == proto.wireTypes.i64 then
			local v142

			v142, n8 = proto.readFixed64(p11, n8)
		else
			error("Unsupported wire type: " .. v136)
		end
	end

	return v133
end
function t16.jsonEncode(p12) -- line: 957
	local t18 = {}

	if p12.badge_id ~= nil and p12.badge_id ~= "" then
		t18.badgeId = p12.badge_id
	end

	return t18
end
function t16.jsonDecode(t19: {[any]: any}) -- line: 967
	-- upvalues: t16 (copy)
	local v146 = t16.new()

	if t19.badge_id ~= nil then
		v146.badge_id = t19.badge_id
	end

	if t19.badgeId ~= nil then
		v146.badge_id = t19.badgeId
	end

	return v146
end

t16.descriptor = {
	name = "BadgesGridPageEntry_BadgeInputData",
	fullName = "roblox.apppageplatform.badges.v1beta1.BadgeInputData"
}
t1.BadgesGridPageEntry_BadgeInputData = t16
typeRegistry.default:register(t1.BadgesGridPageEntry_BadgeInputData)

local t20 = {}

t20.__index = t20

function t20.new(t21: {[any]: any}?) -- line: 997
	-- upvalues: t20 (copy)
	return (setmetatable({
		page_entry = if t21 ~= nil and t21.page_entry ~= nil then t21.page_entry else nil,
		kind = if t21 ~= nil and t21.kind ~= nil then t21.kind else nil
	}, t20))
end
function t20.encode(p13) -- line: 1004
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n9 = 0

	if p13.page_entry ~= nil then
		local v151 = p13.page_entry:encode()
		local v152, v153 = proto.writeTag(buf, n9, 1, proto.wireTypes.lengthDelimited)

		buf, n9 = proto.writeBuffer(v152, v153, v151, buffer.len(v151))
	end

	if p13.kind ~= nil and p13.kind.type == "badges_grid" then
		local v154 = p13.kind.value:encode()
		local v155, v156 = proto.writeTag(buf, n9, 2, proto.wireTypes.lengthDelimited)

		buf, n9 = proto.writeBuffer(v155, v156, v154, buffer.len(v154))
	end

	local buf6 = buffer.create(n9)

	buffer.copy(buf6, 0, buf, 0, n9)

	return buf6
end
function t20.decode(p14: buffer) -- line: 1027
	-- upvalues: t20 (copy), proto (copy), page_entry (copy), t1 (copy)
	local v159 = t20.new()
	local n10 = 0

	while n10 < buffer.len(p14) do
		local v161, v162

		v161, v162, n10 = proto.readTag(p14, n10)

		if v162 == proto.wireTypes.varint then
			local v163

			v163, n10 = proto.readVarInt(p14, n10)
		elseif v162 == proto.wireTypes.lengthDelimited then
			if v161 == 1 then
				local v164

				v164, n10 = proto.readBuffer(p14, n10)
				v159.page_entry = page_entry.PageEntry.decode(v164)
			elseif v161 == 2 then
				local v165

				v165, n10 = proto.readBuffer(p14, n10)
				v159.kind = {
					type = "badges_grid",
					value = t1.BadgesGridPageEntry.decode(v165)
				}
			else
				local v166, v167 = proto.readVarInt(p14, n10)

				n10 = v167 + v166
			end
		elseif v162 == proto.wireTypes.i32 then
			local v168

			v168, n10 = proto.readFixed32(p14, n10)
		elseif v162 == proto.wireTypes.i64 then
			local v169

			v169, n10 = proto.readFixed64(p14, n10)
		else
			error("Unsupported wire type: " .. v162)
		end
	end

	return v159
end
function t20.jsonEncode(p15) -- line: 1075
	local t22 = {}

	if p15.page_entry ~= nil then
		t22.pageEntry = p15.page_entry:jsonEncode()
	end

	if p15.kind ~= nil and p15.kind.type == "badges_grid" then
		t22.badgesGrid = p15.kind.value:jsonEncode()
	end

	return t22
end
function t20.jsonDecode(t23: {[any]: any}) -- line: 1091
	-- upvalues: t20 (copy), page_entry (copy), t1 (copy)
	local v173 = t20.new()

	if t23.page_entry ~= nil then
		v173.page_entry = page_entry.PageEntry.jsonDecode(t23.page_entry)
	end

	if t23.pageEntry ~= nil then
		v173.page_entry = page_entry.PageEntry.jsonDecode(t23.pageEntry)
	end

	if t23.badges_grid ~= nil then
		v173.kind = {
			type = "badges_grid",
			value = t1.BadgesGridPageEntry.jsonDecode(t23.badges_grid)
		}
	end

	if t23.badgesGrid ~= nil then
		v173.kind = {
			type = "badges_grid",
			value = t1.BadgesGridPageEntry.jsonDecode(t23.badgesGrid)
		}
	end

	return v173
end

t20.descriptor = {
	name = "BadgesSeeAllPageEntry",
	fullName = "roblox.apppageplatform.badges.v1beta1.BadgesSeeAllPageEntry"
}
t1.BadgesSeeAllPageEntry = t20
typeRegistry.default:register(t1.BadgesSeeAllPageEntry)

local t24 = {}

t24.__index = t24

function t24.new(t25: {[any]: any}?) -- line: 1127
	-- upvalues: t24 (copy)
	return (setmetatable({
		page_entries = if t25 ~= nil and t25.page_entries ~= nil then t25.page_entries else {},
		hydration_data = if t25 ~= nil and t25.hydration_data ~= nil then t25.hydration_data else nil,
		templates = if t25 ~= nil and t25.templates ~= nil then t25.templates else {},
		pagination = if t25 ~= nil and t25.pagination ~= nil then t25.pagination else nil
	}, t24))
end
function t24.encode(p16) -- line: 1136
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n11 = 0

	if p16.page_entries ~= nil and #p16.page_entries > 0 then
		for _, v179 in p16.page_entries do
			local v180 = v179:encode()
			local v181, v182 = proto.writeTag(buf, n11, 1, proto.wireTypes.lengthDelimited)

			buf, n11 = proto.writeBuffer(v181, v182, v180, buffer.len(v180))
		end
	end

	if p16.hydration_data ~= nil then
		local v183 = p16.hydration_data:encode()
		local v184, v185 = proto.writeTag(buf, n11, 2, proto.wireTypes.lengthDelimited)

		buf, n11 = proto.writeBuffer(v184, v185, v183, buffer.len(v183))
	end

	if p16.templates ~= nil and next(p16.templates) ~= nil then
		for v186, v187 in p16.templates do
			local buf7 = buffer.create(0)
			local v189, v190 = proto.writeTag(buf7, 0, 1, proto.wireTypes.lengthDelimited)
			local v191, v192 = proto.writeString(v189, v190, v186)
			local v193 = v187:encode()
			local v194, v195 = proto.writeTag(v191, v192, 2, proto.wireTypes.lengthDelimited)
			local v196, v197 = proto.writeBuffer(v194, v195, v193, buffer.len(v193))
			local v198, v199 = proto.writeTag(buf, n11, 3, proto.wireTypes.lengthDelimited)

			buf, n11 = proto.writeBuffer(v198, v199, v196, v197)
		end
	end

	if p16.pagination ~= nil then
		local v200 = p16.pagination:encode()
		local v201, v202 = proto.writeTag(buf, n11, 4, proto.wireTypes.lengthDelimited)

		buf, n11 = proto.writeBuffer(v201, v202, v200, buffer.len(v200))
	end

	local buf8 = buffer.create(n11)

	buffer.copy(buf8, 0, buf, 0, n11)

	return buf8
end
function t24.decode(p17: buffer) -- line: 1179
	-- upvalues: t24 (copy), proto (copy), t1 (copy), hydration_content (copy), template_entry (copy)
	local v205 = t24.new()
	local n12 = 0

	while n12 < buffer.len(p17) do
		local v207, v208

		v207, v208, n12 = proto.readTag(p17, n12)

		if v208 == proto.wireTypes.varint then
			local v209

			v209, n12 = proto.readVarInt(p17, n12)
		elseif v208 == proto.wireTypes.lengthDelimited then
			if v207 == 1 then
				local v210

				v210, n12 = proto.readBuffer(p17, n12)
				table.insert(v205.page_entries, t1.BadgesSeeAllPageEntry.decode(v210))
			elseif v207 == 2 then
				local v211

				v211, n12 = proto.readBuffer(p17, n12)
				v205.hydration_data = hydration_content.HydrationContent.decode(v211)
			elseif v207 == 3 then
				local v212

				v212, n12 = proto.readBuffer(p17, n12)

				local v213 = t1.BadgesSeeAllResponse_TemplatesEntry.decode(v212)
				local v214 = template_entry.TemplateEntry.new()

				v205.templates[v213.key or ""] = v213.value or v214
			elseif v207 == 4 then
				local v215

				v215, n12 = proto.readBuffer(p17, n12)
				v205.pagination = t1.Pagination.decode(v215)
			else
				local v216, v217 = proto.readVarInt(p17, n12)

				n12 = v217 + v216
			end
		elseif v208 == proto.wireTypes.i32 then
			local v218

			v218, n12 = proto.readFixed32(p17, n12)
		elseif v208 == proto.wireTypes.i64 then
			local v219

			v219, n12 = proto.readFixed64(p17, n12)
		else
			error("Unsupported wire type: " .. v208)
		end
	end

	return v205
end
function t24.jsonEncode(p18) -- line: 1245
	local t26 = {}

	if p18.page_entries ~= nil and #p18.page_entries > 0 then
		local t27 = {}

		for _, v224 in p18.page_entries do
			table.insert(t27, v224:jsonEncode())
		end

		t26.pageEntries = t27
	end

	if p18.hydration_data ~= nil then
		t26.hydrationData = p18.hydration_data:jsonEncode()
	end

	if p18.templates ~= nil and next(p18.templates) ~= nil then
		local t28 = {}

		for v226, v227 in p18.templates do
			t28[v226] = v227:jsonEncode()
		end

		t26.templates = t28
	end

	if p18.pagination ~= nil then
		t26.pagination = p18.pagination:jsonEncode()
	end

	return t26
end
function t24.jsonDecode(t29: {[any]: any}) -- line: 1275
	-- upvalues: t24 (copy), t1 (copy), hydration_content (copy), template_entry (copy)
	local v229 = t24.new()

	if t29.page_entries ~= nil then
		local t30 = {}

		for _, v232 in t29.page_entries do
			table.insert(t30, t1.BadgesSeeAllPageEntry.jsonDecode(v232))
		end

		v229.page_entries = t30
	end

	if t29.pageEntries ~= nil then
		local t31 = {}

		for _, v235 in t29.pageEntries do
			table.insert(t31, t1.BadgesSeeAllPageEntry.jsonDecode(v235))
		end

		v229.page_entries = t31
	end

	if t29.hydration_data ~= nil then
		v229.hydration_data = hydration_content.HydrationContent.jsonDecode(t29.hydration_data)
	end

	if t29.hydrationData ~= nil then
		v229.hydration_data = hydration_content.HydrationContent.jsonDecode(t29.hydrationData)
	end

	if t29.templates ~= nil then
		local t32 = {}

		for v237, v238 in t29.templates do
			t32[v237] = template_entry.TemplateEntry.jsonDecode(v238)
		end

		v229.templates = t32
	end

	if t29.pagination ~= nil then
		v229.pagination = t1.Pagination.jsonDecode(t29.pagination)
	end

	return v229
end

t24.descriptor = {
	name = "BadgesSeeAllResponse",
	fullName = "roblox.apppageplatform.badges.v1beta1.BadgesSeeAllResponse"
}
t1.BadgesSeeAllResponse = t24
typeRegistry.default:register(t1.BadgesSeeAllResponse)

local t33 = {}

t33.__index = t33

function t33.new(t34: {[any]: any}?) -- line: 1338
	-- upvalues: t33 (copy)
	return (setmetatable({
		key = if t34 ~= nil and t34.key ~= nil then t34.key else "",
		value = if t34 ~= nil and t34.value ~= nil then t34.value else nil
	}, t33))
end
function t33.encode(p19) -- line: 1347
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n13 = 0

	if p19.key ~= nil and p19.key ~= "" then
		local v243, v244 = proto.writeTag(buf, n13, 1, proto.wireTypes.lengthDelimited)

		buf, n13 = proto.writeString(v243, v244, p19.key)
	end

	if p19.value ~= nil then
		local v245 = p19.value:encode()
		local v246, v247 = proto.writeTag(buf, n13, 2, proto.wireTypes.lengthDelimited)

		buf, n13 = proto.writeBuffer(v246, v247, v245, buffer.len(v245))
	end

	local buf9 = buffer.create(n13)

	buffer.copy(buf9, 0, buf, 0, n13)

	return buf9
end
function t33.decode(p20: buffer) -- line: 1367
	-- upvalues: t33 (copy), proto (copy), template_entry (copy)
	local v250 = t33.new()
	local n14 = 0

	while n14 < buffer.len(p20) do
		local v252, v253

		v252, v253, n14 = proto.readTag(p20, n14)

		if v253 == proto.wireTypes.varint then
			local v254

			v254, n14 = proto.readVarInt(p20, n14)
		elseif v253 == proto.wireTypes.lengthDelimited then
			if v252 == 1 then
				local v255

				v255, n14 = proto.readBuffer(p20, n14)
				v250.key = buffer.tostring(v255)
			elseif v252 == 2 then
				local v256

				v256, n14 = proto.readBuffer(p20, n14)
				v250.value = template_entry.TemplateEntry.decode(v256)
			else
				local v257, v258 = proto.readVarInt(p20, n14)

				n14 = v258 + v257
			end
		elseif v253 == proto.wireTypes.i32 then
			local v259

			v259, n14 = proto.readFixed32(p20, n14)
		elseif v253 == proto.wireTypes.i64 then
			local v260

			v260, n14 = proto.readFixed64(p20, n14)
		else
			error("Unsupported wire type: " .. v253)
		end
	end

	return v250
end
function t33.jsonEncode(p21) -- line: 1415
	local t35 = {}

	if p21.key ~= nil and p21.key ~= "" then
		t35.key = p21.key
	end

	if p21.value ~= nil then
		t35.value = p21.value:jsonEncode()
	end

	return t35
end
function t33.jsonDecode(t36: {[any]: any}) -- line: 1429
	-- upvalues: t33 (copy), template_entry (copy)
	local v264 = t33.new()

	if t36.key ~= nil then
		v264.key = t36.key
	end

	if t36.value ~= nil then
		v264.value = template_entry.TemplateEntry.jsonDecode(t36.value)
	end

	return v264
end

t33.descriptor = {
	name = "BadgesSeeAllResponse_TemplatesEntry",
	fullName = "roblox.apppageplatform.badges.v1beta1.TemplatesEntry"
}
t1.BadgesSeeAllResponse_TemplatesEntry = t33
typeRegistry.default:register(t1.BadgesSeeAllResponse_TemplatesEntry)

local t37 = {}

t37.__index = t37

function t37.new(t38: {[any]: any}?) -- line: 1459
	-- upvalues: t37 (copy)
	return (setmetatable({
		page_entries = if t38 ~= nil and t38.page_entries ~= nil then t38.page_entries else {},
		hydration_data = if t38 ~= nil and t38.hydration_data ~= nil then t38.hydration_data else nil,
		templates = if t38 ~= nil and t38.templates ~= nil then t38.templates else {},
		pagination = if t38 ~= nil and t38.pagination ~= nil then t38.pagination else nil
	}, t37))
end
function t37.encode(p22) -- line: 1468
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n15 = 0

	if p22.page_entries ~= nil and #p22.page_entries > 0 then
		for _, v270 in p22.page_entries do
			local v271 = v270:encode()
			local v272, v273 = proto.writeTag(buf, n15, 1, proto.wireTypes.lengthDelimited)

			buf, n15 = proto.writeBuffer(v272, v273, v271, buffer.len(v271))
		end
	end

	if p22.hydration_data ~= nil then
		local v274 = p22.hydration_data:encode()
		local v275, v276 = proto.writeTag(buf, n15, 2, proto.wireTypes.lengthDelimited)

		buf, n15 = proto.writeBuffer(v275, v276, v274, buffer.len(v274))
	end

	if p22.templates ~= nil and next(p22.templates) ~= nil then
		for v277, v278 in p22.templates do
			local buf10 = buffer.create(0)
			local v280, v281 = proto.writeTag(buf10, 0, 1, proto.wireTypes.lengthDelimited)
			local v282, v283 = proto.writeString(v280, v281, v277)
			local v284 = v278:encode()
			local v285, v286 = proto.writeTag(v282, v283, 2, proto.wireTypes.lengthDelimited)
			local v287, v288 = proto.writeBuffer(v285, v286, v284, buffer.len(v284))
			local v289, v290 = proto.writeTag(buf, n15, 3, proto.wireTypes.lengthDelimited)

			buf, n15 = proto.writeBuffer(v289, v290, v287, v288)
		end
	end

	if p22.pagination ~= nil then
		local v291 = p22.pagination:encode()
		local v292, v293 = proto.writeTag(buf, n15, 4, proto.wireTypes.lengthDelimited)

		buf, n15 = proto.writeBuffer(v292, v293, v291, buffer.len(v291))
	end

	local buf11 = buffer.create(n15)

	buffer.copy(buf11, 0, buf, 0, n15)

	return buf11
end
function t37.decode(p23: buffer) -- line: 1511
	-- upvalues: t37 (copy), proto (copy), page_entry_content (copy), hydration_content (copy), t1 (copy), template_entry (copy)
	local v296 = t37.new()
	local n16 = 0

	while n16 < buffer.len(p23) do
		local v298, v299

		v298, v299, n16 = proto.readTag(p23, n16)

		if v299 == proto.wireTypes.varint then
			local v300

			v300, n16 = proto.readVarInt(p23, n16)
		elseif v299 == proto.wireTypes.lengthDelimited then
			if v298 == 1 then
				local v301

				v301, n16 = proto.readBuffer(p23, n16)
				table.insert(v296.page_entries, page_entry_content.UniversalPageEntry.decode(v301))
			elseif v298 == 2 then
				local v302

				v302, n16 = proto.readBuffer(p23, n16)
				v296.hydration_data = hydration_content.HydrationContent.decode(v302)
			elseif v298 == 3 then
				local v303

				v303, n16 = proto.readBuffer(p23, n16)

				local v304 = t1.BadgesSeeAllV2Response_TemplatesEntry.decode(v303)
				local v305 = template_entry.TemplateEntry.new()

				v296.templates[v304.key or ""] = v304.value or v305
			elseif v298 == 4 then
				local v306

				v306, n16 = proto.readBuffer(p23, n16)
				v296.pagination = t1.Pagination.decode(v306)
			else
				local v307, v308 = proto.readVarInt(p23, n16)

				n16 = v308 + v307
			end
		elseif v299 == proto.wireTypes.i32 then
			local v309

			v309, n16 = proto.readFixed32(p23, n16)
		elseif v299 == proto.wireTypes.i64 then
			local v310

			v310, n16 = proto.readFixed64(p23, n16)
		else
			error("Unsupported wire type: " .. v299)
		end
	end

	return v296
end
function t37.jsonEncode(p24) -- line: 1580
	local t39 = {}

	if p24.page_entries ~= nil and #p24.page_entries > 0 then
		local t40 = {}

		for _, v315 in p24.page_entries do
			table.insert(t40, v315:jsonEncode())
		end

		t39.pageEntries = t40
	end

	if p24.hydration_data ~= nil then
		t39.hydrationData = p24.hydration_data:jsonEncode()
	end

	if p24.templates ~= nil and next(p24.templates) ~= nil then
		local t41 = {}

		for v317, v318 in p24.templates do
			t41[v317] = v318:jsonEncode()
		end

		t39.templates = t41
	end

	if p24.pagination ~= nil then
		t39.pagination = p24.pagination:jsonEncode()
	end

	return t39
end
function t37.jsonDecode(t42: {[any]: any}) -- line: 1610
	-- upvalues: t37 (copy), page_entry_content (copy), hydration_content (copy), template_entry (copy), t1 (copy)
	local v320 = t37.new()

	if t42.page_entries ~= nil then
		local t43 = {}

		for _, v323 in t42.page_entries do
			table.insert(t43, page_entry_content.UniversalPageEntry.jsonDecode(v323))
		end

		v320.page_entries = t43
	end

	if t42.pageEntries ~= nil then
		local t44 = {}

		for _, v326 in t42.pageEntries do
			table.insert(t44, page_entry_content.UniversalPageEntry.jsonDecode(v326))
		end

		v320.page_entries = t44
	end

	if t42.hydration_data ~= nil then
		v320.hydration_data = hydration_content.HydrationContent.jsonDecode(t42.hydration_data)
	end

	if t42.hydrationData ~= nil then
		v320.hydration_data = hydration_content.HydrationContent.jsonDecode(t42.hydrationData)
	end

	if t42.templates ~= nil then
		local t45 = {}

		for v328, v329 in t42.templates do
			t45[v328] = template_entry.TemplateEntry.jsonDecode(v329)
		end

		v320.templates = t45
	end

	if t42.pagination ~= nil then
		v320.pagination = t1.Pagination.jsonDecode(t42.pagination)
	end

	return v320
end

t37.descriptor = {
	name = "BadgesSeeAllV2Response",
	fullName = "roblox.apppageplatform.badges.v1beta1.BadgesSeeAllV2Response"
}
t1.BadgesSeeAllV2Response = t37
typeRegistry.default:register(t1.BadgesSeeAllV2Response)

local t46 = {}

t46.__index = t46

function t46.new(t47: {[any]: any}?) -- line: 1679
	-- upvalues: t46 (copy)
	return (setmetatable({
		key = if t47 ~= nil and t47.key ~= nil then t47.key else "",
		value = if t47 ~= nil and t47.value ~= nil then t47.value else nil
	}, t46))
end
function t46.encode(p25) -- line: 1688
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n17 = 0

	if p25.key ~= nil and p25.key ~= "" then
		local v334, v335 = proto.writeTag(buf, n17, 1, proto.wireTypes.lengthDelimited)

		buf, n17 = proto.writeString(v334, v335, p25.key)
	end

	if p25.value ~= nil then
		local v336 = p25.value:encode()
		local v337, v338 = proto.writeTag(buf, n17, 2, proto.wireTypes.lengthDelimited)

		buf, n17 = proto.writeBuffer(v337, v338, v336, buffer.len(v336))
	end

	local buf12 = buffer.create(n17)

	buffer.copy(buf12, 0, buf, 0, n17)

	return buf12
end
function t46.decode(p26: buffer) -- line: 1708
	-- upvalues: t46 (copy), proto (copy), template_entry (copy)
	local v341 = t46.new()
	local n18 = 0

	while n18 < buffer.len(p26) do
		local v343, v344

		v343, v344, n18 = proto.readTag(p26, n18)

		if v344 == proto.wireTypes.varint then
			local v345

			v345, n18 = proto.readVarInt(p26, n18)
		elseif v344 == proto.wireTypes.lengthDelimited then
			if v343 == 1 then
				local v346

				v346, n18 = proto.readBuffer(p26, n18)
				v341.key = buffer.tostring(v346)
			elseif v343 == 2 then
				local v347

				v347, n18 = proto.readBuffer(p26, n18)
				v341.value = template_entry.TemplateEntry.decode(v347)
			else
				local v348, v349 = proto.readVarInt(p26, n18)

				n18 = v349 + v348
			end
		elseif v344 == proto.wireTypes.i32 then
			local v350

			v350, n18 = proto.readFixed32(p26, n18)
		elseif v344 == proto.wireTypes.i64 then
			local v351

			v351, n18 = proto.readFixed64(p26, n18)
		else
			error("Unsupported wire type: " .. v344)
		end
	end

	return v341
end
function t46.jsonEncode(p27) -- line: 1756
	local t48 = {}

	if p27.key ~= nil and p27.key ~= "" then
		t48.key = p27.key
	end

	if p27.value ~= nil then
		t48.value = p27.value:jsonEncode()
	end

	return t48
end
function t46.jsonDecode(t49: {[any]: any}) -- line: 1770
	-- upvalues: t46 (copy), template_entry (copy)
	local v355 = t46.new()

	if t49.key ~= nil then
		v355.key = t49.key
	end

	if t49.value ~= nil then
		v355.value = template_entry.TemplateEntry.jsonDecode(t49.value)
	end

	return v355
end

t46.descriptor = {
	name = "BadgesSeeAllV2Response_TemplatesEntry",
	fullName = "roblox.apppageplatform.badges.v1beta1.TemplatesEntry"
}
t1.BadgesSeeAllV2Response_TemplatesEntry = t46
typeRegistry.default:register(t1.BadgesSeeAllV2Response_TemplatesEntry)

return {
	BadgesSeeAllRequest = t1.BadgesSeeAllRequest,
	Pagination = t1.Pagination,
	BadgesGridPageEntry = t1.BadgesGridPageEntry,
	BadgesGridPageEntry_BadgeInputData = t1.BadgesGridPageEntry_BadgeInputData,
	BadgesSeeAllPageEntry = t1.BadgesSeeAllPageEntry,
	BadgesSeeAllResponse = t1.BadgesSeeAllResponse,
	BadgesSeeAllV2Response = t1.BadgesSeeAllV2Response
}
