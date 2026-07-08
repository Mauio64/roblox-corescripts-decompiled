local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local background_layer = require(script.Parent.background_layer)
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 143
	-- upvalues: t2 (copy)
	return (setmetatable({
		id = if t3 ~= nil and t3.id ~= nil then t3.id else "",
		type = if t3 ~= nil and t3.type ~= nil then t3.type else ""
	}, t2))
end
function t2.encode(p1) -- line: 150
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.id ~= nil and p1.id ~= "" then
		local v13, v14 = proto.writeTag(buf, n1, 1, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v13, v14, p1.id)
	end

	if p1.type ~= nil and p1.type ~= "" then
		local v15, v16 = proto.writeTag(buf, n1, 2, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v15, v16, p1.type)
	end

	local buf2 = buffer.create(n1)

	buffer.copy(buf2, 0, buf, 0, n1)

	return buf2
end
function t2.decode(p2: buffer) -- line: 169
	-- upvalues: t2 (copy), proto (copy)
	local v19 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v21, v22

		v21, v22, n2 = proto.readTag(p2, n2)

		if v22 == proto.wireTypes.varint then
			local v23

			v23, n2 = proto.readVarInt(p2, n2)
		elseif v22 == proto.wireTypes.lengthDelimited then
			if v21 == 1 then
				local v24

				v24, n2 = proto.readBuffer(p2, n2)
				v19.id = buffer.tostring(v24)
			elseif v21 == 2 then
				local v25

				v25, n2 = proto.readBuffer(p2, n2)
				v19.type = buffer.tostring(v25)
			else
				local v26, v27 = proto.readVarInt(p2, n2)

				n2 = v27 + v26
			end
		elseif v22 == proto.wireTypes.i32 then
			local v28

			v28, n2 = proto.readFixed32(p2, n2)
		elseif v22 == proto.wireTypes.i64 then
			local v29

			v29, n2 = proto.readFixed64(p2, n2)
		else
			error("Unsupported wire type: " .. v22)
		end
	end

	return v19
end
function t2.jsonEncode(p3) -- line: 217
	local t4 = {}

	if p3.id ~= nil and p3.id ~= "" then
		t4.id = p3.id
	end

	if p3.type ~= nil and p3.type ~= "" then
		t4.type = p3.type
	end

	return t4
end
function t2.jsonDecode(t5: {[any]: any}) -- line: 231
	-- upvalues: t2 (copy)
	local v33 = t2.new()

	if t5.id ~= nil then
		v33.id = t5.id
	end

	if t5.type ~= nil then
		v33.type = t5.type
	end

	return v33
end

t2.descriptor = {
	name = "CatalogSortContentData",
	fullName = "roblox.apppageplatform.shared.v1beta1.CatalogSortContentData"
}
t1.CatalogSortContentData = t2
typeRegistry.default:register(t1.CatalogSortContentData)

local t6 = {}

t6.__index = t6

function t6.new(t7: {[any]: any}?) -- line: 259
	-- upvalues: t6 (copy)
	return (setmetatable({
		content_type = if t7 ~= nil and t7.content_type ~= nil then t7.content_type else ""
	}, t6))
end
function t6.encode(p4) -- line: 267
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n3 = 0

	if p4.content_type ~= nil and p4.content_type ~= "" then
		local v38, v39 = proto.writeTag(buf, n3, 1, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeString(v38, v39, p4.content_type)
	end

	local buf3 = buffer.create(n3)

	buffer.copy(buf3, 0, buf, 0, n3)

	return buf3
end
function t6.decode(p5: buffer) -- line: 281
	-- upvalues: t6 (copy), proto (copy)
	local v42 = t6.new()
	local n4 = 0

	while n4 < buffer.len(p5) do
		local v44, v45

		v44, v45, n4 = proto.readTag(p5, n4)

		if v45 == proto.wireTypes.varint then
			local v46

			v46, n4 = proto.readVarInt(p5, n4)
		elseif v45 == proto.wireTypes.lengthDelimited then
			if v44 == 1 then
				local v47

				v47, n4 = proto.readBuffer(p5, n4)
				v42.content_type = buffer.tostring(v47)
			else
				local v48, v49 = proto.readVarInt(p5, n4)

				n4 = v49 + v48
			end
		elseif v45 == proto.wireTypes.i32 then
			local v50

			v50, n4 = proto.readFixed32(p5, n4)
		elseif v45 == proto.wireTypes.i64 then
			local v51

			v51, n4 = proto.readFixed64(p5, n4)
		else
			error("Unsupported wire type: " .. v45)
		end
	end

	return v42
end
function t6.jsonEncode(p6) -- line: 324
	local t8 = {}

	if p6.content_type ~= nil and p6.content_type ~= "" then
		t8.contentType = p6.content_type
	end

	return t8
end
function t6.jsonDecode(t9: {[any]: any}) -- line: 334
	-- upvalues: t6 (copy)
	local v55 = t6.new()

	if t9.content_type ~= nil then
		v55.content_type = t9.content_type
	end

	if t9.contentType ~= nil then
		v55.content_type = t9.contentType
	end

	return v55
end

t6.descriptor = {
	name = "CatalogSortCardItemFooter",
	fullName = "roblox.apppageplatform.shared.v1beta1.CatalogSortCardItemFooter"
}
t1.CatalogSortCardItemFooter = t6
typeRegistry.default:register(t1.CatalogSortCardItemFooter)

local t10 = {}

t10.__index = t10

function t10.new(t11: {[any]: any}?) -- line: 362
	-- upvalues: t10 (copy)
	return (setmetatable({
		thumbnail_aspect_ratio = if t11 ~= nil and t11.thumbnail_aspect_ratio ~= nil then t11.thumbnail_aspect_ratio else "",
		background_layers = if t11 ~= nil and t11.background_layers ~= nil then t11.background_layers else {}
	}, t10))
end
function t10.encode(p7) -- line: 371
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n5 = 0

	if p7.thumbnail_aspect_ratio ~= nil and p7.thumbnail_aspect_ratio ~= "" then
		local v60, v61 = proto.writeTag(buf, n5, 1, proto.wireTypes.lengthDelimited)

		buf, n5 = proto.writeString(v60, v61, p7.thumbnail_aspect_ratio)
	end

	if p7.background_layers ~= nil and #p7.background_layers > 0 then
		for _, v63 in p7.background_layers do
			local v64 = v63:encode()
			local v65, v66 = proto.writeTag(buf, n5, 2, proto.wireTypes.lengthDelimited)

			buf, n5 = proto.writeBuffer(v65, v66, v64, buffer.len(v64))
		end
	end

	local buf4 = buffer.create(n5)

	buffer.copy(buf4, 0, buf, 0, n5)

	return buf4
end
function t10.decode(p8: buffer) -- line: 393
	-- upvalues: t10 (copy), proto (copy), background_layer (copy)
	local v69 = t10.new()
	local n6 = 0

	while n6 < buffer.len(p8) do
		local v71, v72

		v71, v72, n6 = proto.readTag(p8, n6)

		if v72 == proto.wireTypes.varint then
			local v73

			v73, n6 = proto.readVarInt(p8, n6)
		elseif v72 == proto.wireTypes.lengthDelimited then
			if v71 == 1 then
				local v74

				v74, n6 = proto.readBuffer(p8, n6)
				v69.thumbnail_aspect_ratio = buffer.tostring(v74)
			elseif v71 == 2 then
				local v75

				v75, n6 = proto.readBuffer(p8, n6)
				table.insert(v69.background_layers, background_layer.BackgroundLayer.decode(v75))
			else
				local v76, v77 = proto.readVarInt(p8, n6)

				n6 = v77 + v76
			end
		elseif v72 == proto.wireTypes.i32 then
			local v78

			v78, n6 = proto.readFixed32(p8, n6)
		elseif v72 == proto.wireTypes.i64 then
			local v79

			v79, n6 = proto.readFixed64(p8, n6)
		else
			error("Unsupported wire type: " .. v72)
		end
	end

	return v69
end
function t10.jsonEncode(p9) -- line: 444
	local t12 = {}

	if p9.thumbnail_aspect_ratio ~= nil and p9.thumbnail_aspect_ratio ~= "" then
		t12.thumbnailAspectRatio = p9.thumbnail_aspect_ratio
	end

	if p9.background_layers ~= nil and #p9.background_layers > 0 then
		local t13 = {}

		for _, v84 in p9.background_layers do
			table.insert(t13, v84:jsonEncode())
		end

		t12.backgroundLayers = t13
	end

	return t12
end
function t10.jsonDecode(t14: {[any]: any}) -- line: 462
	-- upvalues: t10 (copy), background_layer (copy)
	local v86 = t10.new()

	if t14.thumbnail_aspect_ratio ~= nil then
		v86.thumbnail_aspect_ratio = t14.thumbnail_aspect_ratio
	end

	if t14.thumbnailAspectRatio ~= nil then
		v86.thumbnail_aspect_ratio = t14.thumbnailAspectRatio
	end

	if t14.background_layers ~= nil then
		local t15 = {}

		for _, v89 in t14.background_layers do
			table.insert(t15, background_layer.BackgroundLayer.jsonDecode(v89))
		end

		v86.background_layers = t15
	end

	if t14.backgroundLayers ~= nil then
		local t16 = {}

		for _, v92 in t14.backgroundLayers do
			table.insert(t16, background_layer.BackgroundLayer.jsonDecode(v92))
		end

		v86.background_layers = t16
	end

	return v86
end

t10.descriptor = {
	name = "CatalogSortCardStyle",
	fullName = "roblox.apppageplatform.shared.v1beta1.CatalogSortCardStyle"
}
t1.CatalogSortCardStyle = t10
typeRegistry.default:register(t1.CatalogSortCardStyle)

local t17 = {}

t17.__index = t17

function t17.new(t18: {[any]: any}?) -- line: 514
	-- upvalues: t17 (copy)
	return (setmetatable({
		id = if t18 ~= nil and t18.id ~= nil then t18.id else "",
		type = if t18 ~= nil and t18.type ~= nil then t18.type else "",
		hydration_priority = if t18 ~= nil and t18.hydration_priority ~= nil then t18.hydration_priority else 0,
		hydration_count = if t18 ~= nil and t18.hydration_count ~= nil then t18.hydration_count else 0,
		content = if t18 ~= nil and t18.content ~= nil then t18.content else {},
		preview_columns = if t18 ~= nil and t18.preview_columns ~= nil then t18.preview_columns else 0,
		title = if t18 ~= nil and t18.title ~= nil then t18.title else "",
		description = if t18 ~= nil and t18.description ~= nil then t18.description else "",
		card_style = if t18 ~= nil and t18.card_style ~= nil then t18.card_style else nil,
		card_footers = if t18 ~= nil and t18.card_footers ~= nil then t18.card_footers else {},
		tag_id = if t18 ~= nil and t18.tag_id ~= nil then t18.tag_id else ""
	}, t17))
end
function t17.encode(p10) -- line: 530
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n7 = 0

	if p10.id ~= nil and p10.id ~= "" then
		local v97, v98 = proto.writeTag(buf, n7, 1, proto.wireTypes.lengthDelimited)

		buf, n7 = proto.writeString(v97, v98, p10.id)
	end

	if p10.type ~= nil and p10.type ~= "" then
		local v99, v100 = proto.writeTag(buf, n7, 2, proto.wireTypes.lengthDelimited)

		buf, n7 = proto.writeString(v99, v100, p10.type)
	end

	if p10.hydration_priority ~= nil and p10.hydration_priority ~= 0 then
		local v101, v102 = proto.writeTag(buf, n7, 3, proto.wireTypes.varint)

		buf, n7 = proto.writeVarInt(v101, v102, p10.hydration_priority)
	end

	if p10.hydration_count ~= nil and p10.hydration_count ~= 0 then
		local v103, v104 = proto.writeTag(buf, n7, 4, proto.wireTypes.varint)

		buf, n7 = proto.writeVarInt(v103, v104, p10.hydration_count)
	end

	if p10.content ~= nil and #p10.content > 0 then
		for _, v106 in p10.content do
			local v107 = v106:encode()
			local v108, v109 = proto.writeTag(buf, n7, 5, proto.wireTypes.lengthDelimited)

			buf, n7 = proto.writeBuffer(v108, v109, v107, buffer.len(v107))
		end
	end

	if p10.preview_columns ~= nil and p10.preview_columns ~= 0 then
		local v110, v111 = proto.writeTag(buf, n7, 6, proto.wireTypes.varint)

		buf, n7 = proto.writeVarInt(v110, v111, p10.preview_columns)
	end

	if p10.title ~= nil and p10.title ~= "" then
		local v112, v113 = proto.writeTag(buf, n7, 7, proto.wireTypes.lengthDelimited)

		buf, n7 = proto.writeString(v112, v113, p10.title)
	end

	if p10.description ~= nil and p10.description ~= "" then
		local v114, v115 = proto.writeTag(buf, n7, 8, proto.wireTypes.lengthDelimited)

		buf, n7 = proto.writeString(v114, v115, p10.description)
	end

	if p10.card_style ~= nil then
		local v116 = p10.card_style:encode()
		local v117, v118 = proto.writeTag(buf, n7, 9, proto.wireTypes.lengthDelimited)

		buf, n7 = proto.writeBuffer(v117, v118, v116, buffer.len(v116))
	end

	if p10.card_footers ~= nil and #p10.card_footers > 0 then
		for _, v120 in p10.card_footers do
			local v121 = v120:encode()
			local v122, v123 = proto.writeTag(buf, n7, 10, proto.wireTypes.lengthDelimited)

			buf, n7 = proto.writeBuffer(v122, v123, v121, buffer.len(v121))
		end
	end

	if p10.tag_id ~= nil and p10.tag_id ~= "" then
		local v124, v125 = proto.writeTag(buf, n7, 11, proto.wireTypes.lengthDelimited)

		buf, n7 = proto.writeString(v124, v125, p10.tag_id)
	end

	local buf5 = buffer.create(n7)

	buffer.copy(buf5, 0, buf, 0, n7)

	return buf5
end
function t17.decode(p11: buffer) -- line: 601
	-- upvalues: t17 (copy), proto (copy), t1 (copy)
	local v128 = t17.new()
	local n8 = 0

	while n8 < buffer.len(p11) do
		local v130, v131

		v130, v131, n8 = proto.readTag(p11, n8)

		if v131 == proto.wireTypes.varint then
			if v130 == 3 then
				local v132

				v132, n8 = proto.readVarIntI32(p11, n8)
				v128.hydration_priority = v132
			elseif v130 == 4 then
				local v133

				v133, n8 = proto.readVarIntI32(p11, n8)
				v128.hydration_count = v133
			elseif v130 == 6 then
				local v134

				v134, n8 = proto.readVarIntI64(p11, n8)
				v128.preview_columns = v134
			else
				local v135

				v135, n8 = proto.readVarInt(p11, n8)
			end
		elseif v131 == proto.wireTypes.lengthDelimited then
			if v130 == 1 then
				local v136

				v136, n8 = proto.readBuffer(p11, n8)
				v128.id = buffer.tostring(v136)
			elseif v130 == 2 then
				local v137

				v137, n8 = proto.readBuffer(p11, n8)
				v128.type = buffer.tostring(v137)
			elseif v130 == 5 then
				local v138

				v138, n8 = proto.readBuffer(p11, n8)
				table.insert(v128.content, t1.CatalogSortContentData.decode(v138))
			elseif v130 == 7 then
				local v139

				v139, n8 = proto.readBuffer(p11, n8)
				v128.title = buffer.tostring(v139)
			elseif v130 == 8 then
				local v140

				v140, n8 = proto.readBuffer(p11, n8)
				v128.description = buffer.tostring(v140)
			elseif v130 == 9 then
				local v141

				v141, n8 = proto.readBuffer(p11, n8)
				v128.card_style = t1.CatalogSortCardStyle.decode(v141)
			elseif v130 == 10 then
				local v142

				v142, n8 = proto.readBuffer(p11, n8)
				table.insert(v128.card_footers, t1.CatalogSortCardItemFooter.decode(v142))
			elseif v130 == 11 then
				local v143

				v143, n8 = proto.readBuffer(p11, n8)
				v128.tag_id = buffer.tostring(v143)
			else
				local v144, v145 = proto.readVarInt(p11, n8)

				n8 = v145 + v144
			end
		elseif v131 == proto.wireTypes.i32 then
			local v146

			v146, n8 = proto.readFixed32(p11, n8)
		elseif v131 == proto.wireTypes.i64 then
			local v147

			v147, n8 = proto.readFixed64(p11, n8)
		else
			error("Unsupported wire type: " .. v131)
		end
	end

	return v128
end
function t17.jsonEncode(p12) -- line: 694
	local t19 = {}

	if p12.id ~= nil and p12.id ~= "" then
		t19.id = p12.id
	end

	if p12.type ~= nil and p12.type ~= "" then
		t19.type = p12.type
	end

	if p12.hydration_priority ~= nil and p12.hydration_priority ~= 0 then
		t19.hydrationPriority = p12.hydration_priority
	end

	if p12.hydration_count ~= nil and p12.hydration_count ~= 0 then
		t19.hydrationCount = p12.hydration_count
	end

	if p12.content ~= nil and #p12.content > 0 then
		local t20 = {}

		for _, v152 in p12.content do
			table.insert(t20, v152:jsonEncode())
		end

		t19.content = t20
	end

	if p12.preview_columns ~= nil and p12.preview_columns ~= 0 then
		t19.previewColumns = p12.preview_columns
	end

	if p12.title ~= nil and p12.title ~= "" then
		t19.title = p12.title
	end

	if p12.description ~= nil and p12.description ~= "" then
		t19.description = p12.description
	end

	if p12.card_style ~= nil then
		t19.cardStyle = p12.card_style:jsonEncode()
	end

	if p12.card_footers ~= nil and #p12.card_footers > 0 then
		local t21 = {}

		for _, v155 in p12.card_footers do
			table.insert(t21, v155:jsonEncode())
		end

		t19.cardFooters = t21
	end

	if p12.tag_id ~= nil and p12.tag_id ~= "" then
		t19.tagId = p12.tag_id
	end

	return t19
end
function t17.jsonDecode(t22: {[any]: any}) -- line: 752
	-- upvalues: t17 (copy), t1 (copy)
	local v157 = t17.new()

	if t22.id ~= nil then
		v157.id = t22.id
	end

	if t22.type ~= nil then
		v157.type = t22.type
	end

	if t22.hydration_priority ~= nil then
		v157.hydration_priority = t22.hydration_priority
	end

	if t22.hydrationPriority ~= nil then
		v157.hydration_priority = t22.hydrationPriority
	end

	if t22.hydration_count ~= nil then
		v157.hydration_count = t22.hydration_count
	end

	if t22.hydrationCount ~= nil then
		v157.hydration_count = t22.hydrationCount
	end

	if t22.content ~= nil then
		local t23 = {}

		for _, v160 in t22.content do
			table.insert(t23, t1.CatalogSortContentData.jsonDecode(v160))
		end

		v157.content = t23
	end

	if t22.preview_columns ~= nil then
		v157.preview_columns = t22.preview_columns
	end

	if t22.previewColumns ~= nil then
		v157.preview_columns = t22.previewColumns
	end

	if t22.title ~= nil then
		v157.title = t22.title
	end

	if t22.description ~= nil then
		v157.description = t22.description
	end

	if t22.card_style ~= nil then
		v157.card_style = t1.CatalogSortCardStyle.jsonDecode(t22.card_style)
	end

	if t22.cardStyle ~= nil then
		v157.card_style = t1.CatalogSortCardStyle.jsonDecode(t22.cardStyle)
	end

	if t22.card_footers ~= nil then
		local t24 = {}

		for _, v163 in t22.card_footers do
			table.insert(t24, t1.CatalogSortCardItemFooter.jsonDecode(v163))
		end

		v157.card_footers = t24
	end

	if t22.cardFooters ~= nil then
		local t25 = {}

		for _, v166 in t22.cardFooters do
			table.insert(t25, t1.CatalogSortCardItemFooter.jsonDecode(v166))
		end

		v157.card_footers = t25
	end

	if t22.tag_id ~= nil then
		v157.tag_id = t22.tag_id
	end

	if t22.tagId ~= nil then
		v157.tag_id = t22.tagId
	end

	return v157
end

t17.descriptor = {
	name = "CatalogSortData",
	fullName = "roblox.apppageplatform.shared.v1beta1.CatalogSortData"
}
t1.CatalogSortData = t17
typeRegistry.default:register(t1.CatalogSortData)

return {
	CatalogSortContentData = t1.CatalogSortContentData,
	CatalogSortCardItemFooter = t1.CatalogSortCardItemFooter,
	CatalogSortCardStyle = t1.CatalogSortCardStyle,
	CatalogSortData = t1.CatalogSortData
}
