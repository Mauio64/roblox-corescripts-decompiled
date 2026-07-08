local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local hydration_content = require(script.Parent.Parent.Parent.shared.v1beta1.hydration_content)
local template_entry = require(script.Parent.Parent.Parent.shared.v1beta1.template_entry)
local page_entry_content = require(script.Parent.Parent.Parent.shared.v1beta1.page_entry_content)
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 214
	-- upvalues: t2 (copy)
	return (setmetatable({
		request_id = if t3 ~= nil and t3.request_id ~= nil then t3.request_id else "",
		context = if t3 ~= nil and t3.context ~= nil then t3.context else "",
		screen_size = if t3 ~= nil and t3.screen_size ~= nil then t3.screen_size else "",
		pagination = if t3 ~= nil and t3.pagination ~= nil then t3.pagination else nil
	}, t2))
end
function t2.encode(p1) -- line: 225
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.request_id ~= nil and p1.request_id ~= "" then
		local v17, v18 = proto.writeTag(buf, n1, 1, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v17, v18, p1.request_id)
	end

	if p1.context ~= nil and p1.context ~= "" then
		local v19, v20 = proto.writeTag(buf, n1, 2, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v19, v20, p1.context)
	end

	if p1.screen_size ~= nil and p1.screen_size ~= "" then
		local v21, v22 = proto.writeTag(buf, n1, 3, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v21, v22, p1.screen_size)
	end

	if p1.pagination ~= nil then
		local v23 = p1.pagination:encode()
		local v24, v25 = proto.writeTag(buf, n1, 4, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeBuffer(v24, v25, v23, buffer.len(v23))
	end

	local buf2 = buffer.create(n1)

	buffer.copy(buf2, 0, buf, 0, n1)

	return buf2
end
function t2.decode(p2: buffer) -- line: 255
	-- upvalues: t2 (copy), proto (copy), t1 (copy)
	local v28 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v30, v31

		v30, v31, n2 = proto.readTag(p2, n2)

		if v31 == proto.wireTypes.varint then
			local v32

			v32, n2 = proto.readVarInt(p2, n2)
		elseif v31 == proto.wireTypes.lengthDelimited then
			if v30 == 1 then
				local v33

				v33, n2 = proto.readBuffer(p2, n2)
				v28.request_id = buffer.tostring(v33)
			elseif v30 == 2 then
				local v34

				v34, n2 = proto.readBuffer(p2, n2)
				v28.context = buffer.tostring(v34)
			elseif v30 == 3 then
				local v35

				v35, n2 = proto.readBuffer(p2, n2)
				v28.screen_size = buffer.tostring(v35)
			elseif v30 == 4 then
				local v36

				v36, n2 = proto.readBuffer(p2, n2)
				v28.pagination = t1.RequestPagination.decode(v36)
			else
				local v37, v38 = proto.readVarInt(p2, n2)

				n2 = v38 + v37
			end
		elseif v31 == proto.wireTypes.i32 then
			local v39

			v39, n2 = proto.readFixed32(p2, n2)
		elseif v31 == proto.wireTypes.i64 then
			local v40

			v40, n2 = proto.readFixed64(p2, n2)
		else
			error("Unsupported wire type: " .. v31)
		end
	end

	return v28
end
function t2.jsonEncode(p3) -- line: 313
	local t4 = {}

	if p3.request_id ~= nil and p3.request_id ~= "" then
		t4.requestId = p3.request_id
	end

	if p3.context ~= nil and p3.context ~= "" then
		t4.context = p3.context
	end

	if p3.screen_size ~= nil and p3.screen_size ~= "" then
		t4.screenSize = p3.screen_size
	end

	if p3.pagination ~= nil then
		t4.pagination = p3.pagination:jsonEncode()
	end

	return t4
end
function t2.jsonDecode(t5: {[any]: any}) -- line: 335
	-- upvalues: t2 (copy), t1 (copy)
	local v44 = t2.new()

	if t5.request_id ~= nil then
		v44.request_id = t5.request_id
	end

	if t5.requestId ~= nil then
		v44.request_id = t5.requestId
	end

	if t5.context ~= nil then
		v44.context = t5.context
	end

	if t5.screen_size ~= nil then
		v44.screen_size = t5.screen_size
	end

	if t5.screenSize ~= nil then
		v44.screen_size = t5.screenSize
	end

	if t5.pagination ~= nil then
		v44.pagination = t1.RequestPagination.jsonDecode(t5.pagination)
	end

	return v44
end

t2.descriptor = {
	name = "MarketplaceCatalogPageRequest",
	fullName = "roblox.apppageplatform.marketplacecatalog.v1beta1.MarketplaceCatalogPageRequest"
}
t1.MarketplaceCatalogPageRequest = t2
typeRegistry.default:register(t1.MarketplaceCatalogPageRequest)

local t6 = {}

t6.__index = t6

function t6.new(t7: {[any]: any}?) -- line: 379
	-- upvalues: t6 (copy)
	return (setmetatable({
		cursor = if t7 ~= nil and t7.cursor ~= nil then t7.cursor else nil,
		page_size = if t7 ~= nil and t7.page_size ~= nil then t7.page_size else nil,
		direction = if t7 ~= nil and t7.direction ~= nil then t7.direction else nil
	}, t6))
end
function t6.encode(p4) -- line: 387
	-- upvalues: proto (copy), t1 (copy)
	local buf = buffer.create(0)
	local n3 = 0

	if p4.cursor ~= nil then
		local v49, v50 = proto.writeTag(buf, n3, 1, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeString(v49, v50, p4.cursor)
	end

	if p4.page_size ~= nil then
		local v51, v52 = proto.writeTag(buf, n3, 2, proto.wireTypes.varint)

		buf, n3 = proto.writeVarInt(v51, v52, p4.page_size)
	end

	if p4.direction ~= nil then
		local v53, v54 = proto.writeTag(buf, n3, 3, proto.wireTypes.varint)

		buf, n3 = proto.writeVarInt(v53, v54, t1.PaginationDirection.toNumber(p4.direction))
	end

	local buf3 = buffer.create(n3)

	buffer.copy(buf3, 0, buf, 0, n3)

	return buf3
end
function t6.decode(p5: buffer) -- line: 412
	-- upvalues: t6 (copy), proto (copy), t1 (copy)
	local v57 = t6.new()
	local n4 = 0

	while n4 < buffer.len(p5) do
		local v59, v60

		v59, v60, n4 = proto.readTag(p5, n4)

		if v60 == proto.wireTypes.varint then
			if v59 == 2 then
				local v61

				v61, n4 = proto.readVarIntI32(p5, n4)
				v57.page_size = v61
			elseif v59 == 3 then
				local v62

				v62, n4 = proto.readVarIntI32(p5, n4)
				v57.direction = t1.PaginationDirection.fromNumber(v62) or v62
			else
				local v63

				v63, n4 = proto.readVarInt(p5, n4)
			end
		elseif v60 == proto.wireTypes.lengthDelimited then
			if v59 == 1 then
				local v64

				v64, n4 = proto.readBuffer(p5, n4)
				v57.cursor = buffer.tostring(v64)
			else
				local v65, v66 = proto.readVarInt(p5, n4)

				n4 = v66 + v65
			end
		elseif v60 == proto.wireTypes.i32 then
			local v67

			v67, n4 = proto.readFixed32(p5, n4)
		elseif v60 == proto.wireTypes.i64 then
			local v68

			v68, n4 = proto.readFixed64(p5, n4)
		else
			error("Unsupported wire type: " .. v60)
		end
	end

	return v57
end
function t6.jsonEncode(p6) -- line: 465
	-- upvalues: t1 (copy)
	local t8 = {}

	if p6.cursor ~= nil then
		t8.cursor = p6.cursor
	end

	if p6.page_size ~= nil then
		t8.pageSize = p6.page_size
	end

	if p6.direction ~= nil then
		t8.direction = if typeof(p6.direction) ~= "number" then t1.PaginationDirection.toNumber(p6.direction) else p6.direction
	end

	return t8
end
function t6.jsonDecode(t9: {[any]: any}) -- line: 485
	-- upvalues: t6 (copy), t1 (copy)
	local v72 = t6.new()

	if t9.cursor ~= nil then
		v72.cursor = t9.cursor
	end

	if t9.page_size ~= nil then
		v72.page_size = t9.page_size
	end

	if t9.pageSize ~= nil then
		v72.page_size = t9.pageSize
	end

	if t9.direction ~= nil then
		v72.direction = if typeof(t9.direction) ~= "number" then t1.PaginationDirection.fromName(t9.direction) or t9.direction else t1.PaginationDirection.fromNumber(t9.direction) or t9.direction
	end

	return v72
end

t6.descriptor = {
	name = "RequestPagination",
	fullName = "roblox.apppageplatform.marketplacecatalog.v1beta1.RequestPagination"
}
t1.RequestPagination = t6
typeRegistry.default:register(t1.RequestPagination)

local t10 = {}

t10.__index = t10

function t10.new(t11: {[any]: any}?) -- line: 523
	-- upvalues: t10 (copy)
	return (setmetatable({
		page_entries = if t11 ~= nil and t11.page_entries ~= nil then t11.page_entries else {},
		hydration_data = if t11 ~= nil and t11.hydration_data ~= nil then t11.hydration_data else nil,
		templates = if t11 ~= nil and t11.templates ~= nil then t11.templates else {},
		localized_literals = if t11 ~= nil and t11.localized_literals ~= nil then t11.localized_literals else {},
		pagination = if t11 ~= nil and t11.pagination ~= nil then t11.pagination else nil
	}, t10))
end
function t10.encode(p7) -- line: 535
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n5 = 0

	if p7.page_entries ~= nil and #p7.page_entries > 0 then
		for _, v78 in p7.page_entries do
			local v79 = v78:encode()
			local v80, v81 = proto.writeTag(buf, n5, 1, proto.wireTypes.lengthDelimited)

			buf, n5 = proto.writeBuffer(v80, v81, v79, buffer.len(v79))
		end
	end

	if p7.hydration_data ~= nil then
		local v82 = p7.hydration_data:encode()
		local v83, v84 = proto.writeTag(buf, n5, 2, proto.wireTypes.lengthDelimited)

		buf, n5 = proto.writeBuffer(v83, v84, v82, buffer.len(v82))
	end

	if p7.templates ~= nil and next(p7.templates) ~= nil then
		for v85, v86 in p7.templates do
			local buf4 = buffer.create(0)
			local v88, v89 = proto.writeTag(buf4, 0, 1, proto.wireTypes.lengthDelimited)
			local v90, v91 = proto.writeString(v88, v89, v85)
			local v92 = v86:encode()
			local v93, v94 = proto.writeTag(v90, v91, 2, proto.wireTypes.lengthDelimited)
			local v95, v96 = proto.writeBuffer(v93, v94, v92, buffer.len(v92))
			local v97, v98 = proto.writeTag(buf, n5, 3, proto.wireTypes.lengthDelimited)

			buf, n5 = proto.writeBuffer(v97, v98, v95, v96)
		end
	end

	if p7.localized_literals ~= nil and next(p7.localized_literals) ~= nil then
		for v99, v100 in p7.localized_literals do
			local buf5 = buffer.create(0)
			local v102, v103 = proto.writeTag(buf5, 0, 1, proto.wireTypes.lengthDelimited)
			local v104, v105 = proto.writeString(v102, v103, v99)
			local v106, v107 = proto.writeTag(v104, v105, 2, proto.wireTypes.lengthDelimited)
			local v108, v109 = proto.writeString(v106, v107, v100)
			local v110, v111 = proto.writeTag(buf, n5, 4, proto.wireTypes.lengthDelimited)

			buf, n5 = proto.writeBuffer(v110, v111, v108, v109)
		end
	end

	if p7.pagination ~= nil then
		local v112 = p7.pagination:encode()
		local v113, v114 = proto.writeTag(buf, n5, 5, proto.wireTypes.lengthDelimited)

		buf, n5 = proto.writeBuffer(v113, v114, v112, buffer.len(v112))
	end

	local buf6 = buffer.create(n5)

	buffer.copy(buf6, 0, buf, 0, n5)

	return buf6
end
function t10.decode(p8: buffer) -- line: 591
	-- upvalues: t10 (copy), proto (copy), page_entry_content (copy), hydration_content (copy), t1 (copy), template_entry (copy)
	local v117 = t10.new()
	local n6 = 0

	while n6 < buffer.len(p8) do
		local v119, v120

		v119, v120, n6 = proto.readTag(p8, n6)

		if v120 == proto.wireTypes.varint then
			local v121

			v121, n6 = proto.readVarInt(p8, n6)
		elseif v120 == proto.wireTypes.lengthDelimited then
			if v119 == 1 then
				local v122

				v122, n6 = proto.readBuffer(p8, n6)
				table.insert(v117.page_entries, page_entry_content.UniversalPageEntry.decode(v122))
			elseif v119 == 2 then
				local v123

				v123, n6 = proto.readBuffer(p8, n6)
				v117.hydration_data = hydration_content.HydrationContent.decode(v123)
			elseif v119 == 3 then
				local v124

				v124, n6 = proto.readBuffer(p8, n6)

				local v125 = t1.MarketplaceCatalogPageResponse_TemplatesEntry.decode(v124)
				local v126 = template_entry.TemplateEntry.new()

				v117.templates[v125.key or ""] = v125.value or v126
			elseif v119 == 4 then
				local v127

				v127, n6 = proto.readBuffer(p8, n6)

				local v128 = t1.MarketplaceCatalogPageResponse_LocalizedLiteralsEntry.decode(v127)

				v117.localized_literals[v128.key or ""] = v128.value or ""
			elseif v119 == 5 then
				local v129

				v129, n6 = proto.readBuffer(p8, n6)
				v117.pagination = t1.Pagination.decode(v129)
			else
				local v130, v131 = proto.readVarInt(p8, n6)

				n6 = v131 + v130
			end
		elseif v120 == proto.wireTypes.i32 then
			local v132

			v132, n6 = proto.readFixed32(p8, n6)
		elseif v120 == proto.wireTypes.i64 then
			local v133

			v133, n6 = proto.readFixed64(p8, n6)
		else
			error("Unsupported wire type: " .. v120)
		end
	end

	return v117
end
function t10.jsonEncode(p9) -- line: 672
	local t12 = {}

	if p9.page_entries ~= nil and #p9.page_entries > 0 then
		local t13 = {}

		for _, v138 in p9.page_entries do
			table.insert(t13, v138:jsonEncode())
		end

		t12.pageEntries = t13
	end

	if p9.hydration_data ~= nil then
		t12.hydrationData = p9.hydration_data:jsonEncode()
	end

	if p9.templates ~= nil and next(p9.templates) ~= nil then
		local t14 = {}

		for v140, v141 in p9.templates do
			t14[v140] = v141:jsonEncode()
		end

		t12.templates = t14
	end

	if p9.localized_literals ~= nil and next(p9.localized_literals) ~= nil then
		local t15 = {}

		for v143, v144 in p9.localized_literals do
			t15[v143] = v144
		end

		t12.localizedLiterals = t15
	end

	if p9.pagination ~= nil then
		t12.pagination = p9.pagination:jsonEncode()
	end

	return t12
end
function t10.jsonDecode(t16: {[any]: any}) -- line: 710
	-- upvalues: t10 (copy), page_entry_content (copy), hydration_content (copy), template_entry (copy), t1 (copy)
	local v146 = t10.new()

	if t16.page_entries ~= nil then
		local t17 = {}

		for _, v149 in t16.page_entries do
			table.insert(t17, page_entry_content.UniversalPageEntry.jsonDecode(v149))
		end

		v146.page_entries = t17
	end

	if t16.pageEntries ~= nil then
		local t18 = {}

		for _, v152 in t16.pageEntries do
			table.insert(t18, page_entry_content.UniversalPageEntry.jsonDecode(v152))
		end

		v146.page_entries = t18
	end

	if t16.hydration_data ~= nil then
		v146.hydration_data = hydration_content.HydrationContent.jsonDecode(t16.hydration_data)
	end

	if t16.hydrationData ~= nil then
		v146.hydration_data = hydration_content.HydrationContent.jsonDecode(t16.hydrationData)
	end

	if t16.templates ~= nil then
		local t19 = {}

		for v154, v155 in t16.templates do
			t19[v154] = template_entry.TemplateEntry.jsonDecode(v155)
		end

		v146.templates = t19
	end

	if t16.localized_literals ~= nil then
		local t20 = {}

		for v157, v158 in t16.localized_literals do
			t20[v157] = v158
		end

		v146.localized_literals = t20
	end

	if t16.localizedLiterals ~= nil then
		local t21 = {}

		for v160, v161 in t16.localizedLiterals do
			t21[v160] = v161
		end

		v146.localized_literals = t21
	end

	if t16.pagination ~= nil then
		v146.pagination = t1.Pagination.jsonDecode(t16.pagination)
	end

	return v146
end

t10.descriptor = {
	name = "MarketplaceCatalogPageResponse",
	fullName = "roblox.apppageplatform.marketplacecatalog.v1beta1.MarketplaceCatalogPageResponse"
}
t1.MarketplaceCatalogPageResponse = t10
typeRegistry.default:register(t1.MarketplaceCatalogPageResponse)

local t22 = {}

t22.__index = t22

function t22.new(t23: {[any]: any}?) -- line: 797
	-- upvalues: t22 (copy)
	return (setmetatable({
		key = if t23 ~= nil and t23.key ~= nil then t23.key else "",
		value = if t23 ~= nil and t23.value ~= nil then t23.value else nil
	}, t22))
end
function t22.encode(p10) -- line: 806
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n7 = 0

	if p10.key ~= nil and p10.key ~= "" then
		local v166, v167 = proto.writeTag(buf, n7, 1, proto.wireTypes.lengthDelimited)

		buf, n7 = proto.writeString(v166, v167, p10.key)
	end

	if p10.value ~= nil then
		local v168 = p10.value:encode()
		local v169, v170 = proto.writeTag(buf, n7, 2, proto.wireTypes.lengthDelimited)

		buf, n7 = proto.writeBuffer(v169, v170, v168, buffer.len(v168))
	end

	local buf7 = buffer.create(n7)

	buffer.copy(buf7, 0, buf, 0, n7)

	return buf7
end
function t22.decode(p11: buffer) -- line: 828
	-- upvalues: t22 (copy), proto (copy), template_entry (copy)
	local v173 = t22.new()
	local n8 = 0

	while n8 < buffer.len(p11) do
		local v175, v176

		v175, v176, n8 = proto.readTag(p11, n8)

		if v176 == proto.wireTypes.varint then
			local v177

			v177, n8 = proto.readVarInt(p11, n8)
		elseif v176 == proto.wireTypes.lengthDelimited then
			if v175 == 1 then
				local v178

				v178, n8 = proto.readBuffer(p11, n8)
				v173.key = buffer.tostring(v178)
			elseif v175 == 2 then
				local v179

				v179, n8 = proto.readBuffer(p11, n8)
				v173.value = template_entry.TemplateEntry.decode(v179)
			else
				local v180, v181 = proto.readVarInt(p11, n8)

				n8 = v181 + v180
			end
		elseif v176 == proto.wireTypes.i32 then
			local v182

			v182, n8 = proto.readFixed32(p11, n8)
		elseif v176 == proto.wireTypes.i64 then
			local v183

			v183, n8 = proto.readFixed64(p11, n8)
		else
			error("Unsupported wire type: " .. v176)
		end
	end

	return v173
end
function t22.jsonEncode(p12) -- line: 878
	local t24 = {}

	if p12.key ~= nil and p12.key ~= "" then
		t24.key = p12.key
	end

	if p12.value ~= nil then
		t24.value = p12.value:jsonEncode()
	end

	return t24
end
function t22.jsonDecode(t25: {[any]: any}) -- line: 894
	-- upvalues: t22 (copy), template_entry (copy)
	local v187 = t22.new()

	if t25.key ~= nil then
		v187.key = t25.key
	end

	if t25.value ~= nil then
		v187.value = template_entry.TemplateEntry.jsonDecode(t25.value)
	end

	return v187
end

t22.descriptor = {
	name = "MarketplaceCatalogPageResponse_TemplatesEntry",
	fullName = "roblox.apppageplatform.marketplacecatalog.v1beta1.TemplatesEntry"
}
t1.MarketplaceCatalogPageResponse_TemplatesEntry = t22
typeRegistry.default:register(t1.MarketplaceCatalogPageResponse_TemplatesEntry)

local t26 = {}

t26.__index = t26

function t26.new(t27: {[any]: any}?) -- line: 925
	-- upvalues: t26 (copy)
	return (setmetatable({
		key = if t27 ~= nil and t27.key ~= nil then t27.key else "",
		value = if t27 ~= nil and t27.value ~= nil then t27.value else ""
	}, t26))
end
function t26.encode(p13) -- line: 937
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n9 = 0

	if p13.key ~= nil and p13.key ~= "" then
		local v192, v193 = proto.writeTag(buf, n9, 1, proto.wireTypes.lengthDelimited)

		buf, n9 = proto.writeString(v192, v193, p13.key)
	end

	if p13.value ~= nil and p13.value ~= "" then
		local v194, v195 = proto.writeTag(buf, n9, 2, proto.wireTypes.lengthDelimited)

		buf, n9 = proto.writeString(v194, v195, p13.value)
	end

	local buf8 = buffer.create(n9)

	buffer.copy(buf8, 0, buf, 0, n9)

	return buf8
end
function t26.decode(p14: buffer) -- line: 958
	-- upvalues: t26 (copy), proto (copy)
	local v198 = t26.new()
	local n10 = 0

	while n10 < buffer.len(p14) do
		local v200, v201

		v200, v201, n10 = proto.readTag(p14, n10)

		if v201 == proto.wireTypes.varint then
			local v202

			v202, n10 = proto.readVarInt(p14, n10)
		elseif v201 == proto.wireTypes.lengthDelimited then
			if v200 == 1 then
				local v203

				v203, n10 = proto.readBuffer(p14, n10)
				v198.key = buffer.tostring(v203)
			elseif v200 == 2 then
				local v204

				v204, n10 = proto.readBuffer(p14, n10)
				v198.value = buffer.tostring(v204)
			else
				local v205, v206 = proto.readVarInt(p14, n10)

				n10 = v206 + v205
			end
		elseif v201 == proto.wireTypes.i32 then
			local v207

			v207, n10 = proto.readFixed32(p14, n10)
		elseif v201 == proto.wireTypes.i64 then
			local v208

			v208, n10 = proto.readFixed64(p14, n10)
		else
			error("Unsupported wire type: " .. v201)
		end
	end

	return v198
end
function t26.jsonEncode(p15) -- line: 1008
	local t28 = {}

	if p15.key ~= nil and p15.key ~= "" then
		t28.key = p15.key
	end

	if p15.value ~= nil and p15.value ~= "" then
		t28.value = p15.value
	end

	return t28
end
function t26.jsonDecode(t29: {[any]: any}) -- line: 1024
	-- upvalues: t26 (copy)
	local v212 = t26.new()

	if t29.key ~= nil then
		v212.key = t29.key
	end

	if t29.value ~= nil then
		v212.value = t29.value
	end

	return v212
end

t26.descriptor = {
	name = "MarketplaceCatalogPageResponse_LocalizedLiteralsEntry",
	fullName = "roblox.apppageplatform.marketplacecatalog.v1beta1.LocalizedLiteralsEntry"
}
t1.MarketplaceCatalogPageResponse_LocalizedLiteralsEntry = t26
typeRegistry.default:register(t1.MarketplaceCatalogPageResponse_LocalizedLiteralsEntry)

local t30 = {}

t30.__index = t30

function t30.new(t31: {[any]: any}?) -- line: 1055
	-- upvalues: t30 (copy)
	return (setmetatable({
		next_cursor = if t31 ~= nil and t31.next_cursor ~= nil then t31.next_cursor else nil
	}, t30))
end
function t30.encode(p16) -- line: 1061
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n11 = 0

	if p16.next_cursor ~= nil then
		local v217, v218 = proto.writeTag(buf, n11, 1, proto.wireTypes.lengthDelimited)

		buf, n11 = proto.writeString(v217, v218, p16.next_cursor)
	end

	local buf9 = buffer.create(n11)

	buffer.copy(buf9, 0, buf, 0, n11)

	return buf9
end
function t30.decode(p17: buffer) -- line: 1075
	-- upvalues: t30 (copy), proto (copy)
	local v221 = t30.new()
	local n12 = 0

	while n12 < buffer.len(p17) do
		local v223, v224

		v223, v224, n12 = proto.readTag(p17, n12)

		if v224 == proto.wireTypes.varint then
			local v225

			v225, n12 = proto.readVarInt(p17, n12)
		elseif v224 == proto.wireTypes.lengthDelimited then
			if v223 == 1 then
				local v226

				v226, n12 = proto.readBuffer(p17, n12)
				v221.next_cursor = buffer.tostring(v226)
			else
				local v227, v228 = proto.readVarInt(p17, n12)

				n12 = v228 + v227
			end
		elseif v224 == proto.wireTypes.i32 then
			local v229

			v229, n12 = proto.readFixed32(p17, n12)
		elseif v224 == proto.wireTypes.i64 then
			local v230

			v230, n12 = proto.readFixed64(p17, n12)
		else
			error("Unsupported wire type: " .. v224)
		end
	end

	return v221
end
function t30.jsonEncode(p18) -- line: 1118
	local t32 = {}

	if p18.next_cursor ~= nil then
		t32.nextCursor = p18.next_cursor
	end

	return t32
end
function t30.jsonDecode(t33: {[any]: any}) -- line: 1128
	-- upvalues: t30 (copy)
	local v234 = t30.new()

	if t33.next_cursor ~= nil then
		v234.next_cursor = t33.next_cursor
	end

	if t33.nextCursor ~= nil then
		v234.next_cursor = t33.nextCursor
	end

	return v234
end

t30.descriptor = {
	name = "Pagination",
	fullName = "roblox.apppageplatform.marketplacecatalog.v1beta1.Pagination"
}
t1.Pagination = t30
typeRegistry.default:register(t1.Pagination)
t1.PaginationDirection = {
	fromNumber = function(n13: number) -- line: 1153
		if n13 == 0 then
			return "PAGINATION_DIRECTION_INVALID"
		end

		if n13 == 1 then
			return "PAGINATION_DIRECTION_FORWARD"
		end

		if n13 == 2 then
			return "PAGINATION_DIRECTION_BACKWARD"
		end

		return nil
	end,
	toNumber = function(p19) -- line: 1165
		if p19 == "PAGINATION_DIRECTION_INVALID" then
			return 0
		end

		if p19 == "PAGINATION_DIRECTION_FORWARD" then
			return 1
		end

		if p19 == "PAGINATION_DIRECTION_BACKWARD" then
			return 2
		end

		return p19
	end,
	fromName = function(s1: string) -- line: 1177
		if s1 == "PAGINATION_DIRECTION_INVALID" then
			return "PAGINATION_DIRECTION_INVALID"
		end

		if s1 == "PAGINATION_DIRECTION_FORWARD" then
			return "PAGINATION_DIRECTION_FORWARD"
		end

		if s1 == "PAGINATION_DIRECTION_BACKWARD" then
			return "PAGINATION_DIRECTION_BACKWARD"
		end

		return nil
	end
}

return {
	MarketplaceCatalogPageRequest = t1.MarketplaceCatalogPageRequest,
	RequestPagination = t1.RequestPagination,
	MarketplaceCatalogPageResponse = t1.MarketplaceCatalogPageResponse,
	Pagination = t1.Pagination,
	PaginationDirection = t1.PaginationDirection
}
