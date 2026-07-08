local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local hydration_content = require(script.Parent.Parent.Parent.shared.v1beta1.hydration_content)
local template_entry = require(script.Parent.Parent.Parent.shared.v1beta1.template_entry)
local page_entry_content = require(script.Parent.Parent.Parent.shared.v1beta1.page_entry_content)
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 165
	-- upvalues: t1 (copy), t2 (copy)
	return (setmetatable({
		search_query = if t3 ~= nil and t3.search_query ~= nil then t3.search_query else "",
		session_id = if t3 ~= nil and t3.session_id ~= nil then t3.session_id else "",
		vertical_type = if t3 ~= nil and t3.vertical_type ~= nil then t3.vertical_type else assert(t1.SearchResultsPageVerticalType.fromNumber(0), "Enum has no 0 default"),
		global_session_id = if t3 ~= nil and t3.global_session_id ~= nil then t3.global_session_id else ""
	}, t2))
end
function t2.encode(p1) -- line: 178
	-- upvalues: proto (copy), t1 (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.search_query ~= nil and p1.search_query ~= "" then
		local v15, v16 = proto.writeTag(buf, n1, 1, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v15, v16, p1.search_query)
	end

	if p1.session_id ~= nil and p1.session_id ~= "" then
		local v17, v18 = proto.writeTag(buf, n1, 2, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v17, v18, p1.session_id)
	end

	if p1.vertical_type ~= nil and (p1.vertical_type ~= nil and p1.vertical_type ~= 0 or p1.vertical_type ~= t1.SearchResultsPageVerticalType.fromNumber(0)) then
		local v19, v20 = proto.writeTag(buf, n1, 3, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v19, v20, t1.SearchResultsPageVerticalType.toNumber(p1.vertical_type))
	end

	if p1.global_session_id ~= nil and p1.global_session_id ~= "" then
		local v21, v22 = proto.writeTag(buf, n1, 4, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v21, v22, p1.global_session_id)
	end

	local buf2 = buffer.create(n1)

	buffer.copy(buf2, 0, buf, 0, n1)

	return buf2
end
function t2.decode(p2: buffer) -- line: 217
	-- upvalues: t2 (copy), proto (copy), t1 (copy)
	local v25 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v27, v28

		v27, v28, n2 = proto.readTag(p2, n2)

		if v28 == proto.wireTypes.varint then
			if v27 == 3 then
				local v29

				v29, n2 = proto.readVarIntI32(p2, n2)
				v25.vertical_type = t1.SearchResultsPageVerticalType.fromNumber(v29) or v29
			else
				local v30

				v30, n2 = proto.readVarInt(p2, n2)
			end
		elseif v28 == proto.wireTypes.lengthDelimited then
			if v27 == 1 then
				local v31

				v31, n2 = proto.readBuffer(p2, n2)
				v25.search_query = buffer.tostring(v31)
			elseif v27 == 2 then
				local v32

				v32, n2 = proto.readBuffer(p2, n2)
				v25.session_id = buffer.tostring(v32)
			elseif v27 == 4 then
				local v33

				v33, n2 = proto.readBuffer(p2, n2)
				v25.global_session_id = buffer.tostring(v33)
			else
				local v34, v35 = proto.readVarInt(p2, n2)

				n2 = v35 + v34
			end
		elseif v28 == proto.wireTypes.i32 then
			local v36

			v36, n2 = proto.readFixed32(p2, n2)
		elseif v28 == proto.wireTypes.i64 then
			local v37

			v37, n2 = proto.readFixed64(p2, n2)
		else
			error("Unsupported wire type: " .. v28)
		end
	end

	return v25
end
function t2.jsonEncode(p3) -- line: 275
	-- upvalues: t1 (copy)
	local t4 = {}

	if p3.search_query ~= nil and p3.search_query ~= "" then
		t4.searchQuery = p3.search_query
	end

	if p3.session_id ~= nil and p3.session_id ~= "" then
		t4.sessionId = p3.session_id
	end

	if p3.vertical_type ~= nil and (p3.vertical_type ~= nil and p3.vertical_type ~= 0 or p3.vertical_type ~= t1.SearchResultsPageVerticalType.fromNumber(0)) then
		t4.verticalType = if typeof(p3.vertical_type) ~= "number" then t1.SearchResultsPageVerticalType.toNumber(p3.vertical_type) else p3.vertical_type
	end

	if p3.global_session_id ~= nil and p3.global_session_id ~= "" then
		t4.globalSessionId = p3.global_session_id
	end

	return t4
end
function t2.jsonDecode(t5: {[any]: any}) -- line: 305
	-- upvalues: t2 (copy), t1 (copy)
	local v41 = t2.new()

	if t5.search_query ~= nil then
		v41.search_query = t5.search_query
	end

	if t5.searchQuery ~= nil then
		v41.search_query = t5.searchQuery
	end

	if t5.session_id ~= nil then
		v41.session_id = t5.session_id
	end

	if t5.sessionId ~= nil then
		v41.session_id = t5.sessionId
	end

	if t5.vertical_type ~= nil then
		v41.vertical_type = if typeof(t5.vertical_type) ~= "number" then t1.SearchResultsPageVerticalType.fromName(t5.vertical_type) or t5.vertical_type else t1.SearchResultsPageVerticalType.fromNumber(t5.vertical_type) or t5.vertical_type
	end

	if t5.verticalType ~= nil then
		v41.vertical_type = if typeof(t5.verticalType) ~= "number" then t1.SearchResultsPageVerticalType.fromName(t5.verticalType) or t5.verticalType else t1.SearchResultsPageVerticalType.fromNumber(t5.verticalType) or t5.verticalType
	end

	if t5.global_session_id ~= nil then
		v41.global_session_id = t5.global_session_id
	end

	if t5.globalSessionId ~= nil then
		v41.global_session_id = t5.globalSessionId
	end

	return v41
end

t2.descriptor = {
	name = "GetSearchResultsPageRequest",
	fullName = "roblox.apppageplatform.search.v1beta1.GetSearchResultsPageRequest"
}
t1.GetSearchResultsPageRequest = t2
typeRegistry.default:register(t1.GetSearchResultsPageRequest)

local t6 = {}

t6.__index = t6

function t6.new(t7: {[any]: any}?) -- line: 361
	-- upvalues: t6 (copy)
	return (setmetatable({
		page_entries = if t7 ~= nil and t7.page_entries ~= nil then t7.page_entries else {},
		hydration_data = if t7 ~= nil and t7.hydration_data ~= nil then t7.hydration_data else nil,
		templates = if t7 ~= nil and t7.templates ~= nil then t7.templates else {},
		localized_literals = if t7 ~= nil and t7.localized_literals ~= nil then t7.localized_literals else {}
	}, t6))
end
function t6.encode(p4) -- line: 372
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n3 = 0

	if p4.page_entries ~= nil and #p4.page_entries > 0 then
		for _, v47 in p4.page_entries do
			local v48 = v47:encode()
			local v49, v50 = proto.writeTag(buf, n3, 1, proto.wireTypes.lengthDelimited)

			buf, n3 = proto.writeBuffer(v49, v50, v48, buffer.len(v48))
		end
	end

	if p4.hydration_data ~= nil then
		local v51 = p4.hydration_data:encode()
		local v52, v53 = proto.writeTag(buf, n3, 2, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeBuffer(v52, v53, v51, buffer.len(v51))
	end

	if p4.templates ~= nil and next(p4.templates) ~= nil then
		for v54, v55 in p4.templates do
			local buf3 = buffer.create(0)
			local v57, v58 = proto.writeTag(buf3, 0, 1, proto.wireTypes.lengthDelimited)
			local v59, v60 = proto.writeString(v57, v58, v54)
			local v61 = v55:encode()
			local v62, v63 = proto.writeTag(v59, v60, 2, proto.wireTypes.lengthDelimited)
			local v64, v65 = proto.writeBuffer(v62, v63, v61, buffer.len(v61))
			local v66, v67 = proto.writeTag(buf, n3, 3, proto.wireTypes.lengthDelimited)

			buf, n3 = proto.writeBuffer(v66, v67, v64, v65)
		end
	end

	if p4.localized_literals ~= nil and next(p4.localized_literals) ~= nil then
		for v68, v69 in p4.localized_literals do
			local buf4 = buffer.create(0)
			local v71, v72 = proto.writeTag(buf4, 0, 1, proto.wireTypes.lengthDelimited)
			local v73, v74 = proto.writeString(v71, v72, v68)
			local v75, v76 = proto.writeTag(v73, v74, 2, proto.wireTypes.lengthDelimited)
			local v77, v78 = proto.writeString(v75, v76, v69)
			local v79, v80 = proto.writeTag(buf, n3, 4, proto.wireTypes.lengthDelimited)

			buf, n3 = proto.writeBuffer(v79, v80, v77, v78)
		end
	end

	local buf5 = buffer.create(n3)

	buffer.copy(buf5, 0, buf, 0, n3)

	return buf5
end
function t6.decode(p5: buffer) -- line: 422
	-- upvalues: t6 (copy), proto (copy), page_entry_content (copy), hydration_content (copy), t1 (copy), template_entry (copy)
	local v83 = t6.new()
	local n4 = 0

	while n4 < buffer.len(p5) do
		local v85, v86

		v85, v86, n4 = proto.readTag(p5, n4)

		if v86 == proto.wireTypes.varint then
			local v87

			v87, n4 = proto.readVarInt(p5, n4)
		elseif v86 == proto.wireTypes.lengthDelimited then
			if v85 == 1 then
				local v88

				v88, n4 = proto.readBuffer(p5, n4)
				table.insert(v83.page_entries, page_entry_content.UniversalPageEntry.decode(v88))
			elseif v85 == 2 then
				local v89

				v89, n4 = proto.readBuffer(p5, n4)
				v83.hydration_data = hydration_content.HydrationContent.decode(v89)
			elseif v85 == 3 then
				local v90

				v90, n4 = proto.readBuffer(p5, n4)

				local v91 = t1.GetSearchResultsPageResponse_TemplatesEntry.decode(v90)
				local v92 = template_entry.TemplateEntry.new()

				v83.templates[v91.key or ""] = v91.value or v92
			elseif v85 == 4 then
				local v93

				v93, n4 = proto.readBuffer(p5, n4)

				local v94 = t1.GetSearchResultsPageResponse_LocalizedLiteralsEntry.decode(v93)

				v83.localized_literals[v94.key or ""] = v94.value or ""
			else
				local v95, v96 = proto.readVarInt(p5, n4)

				n4 = v96 + v95
			end
		elseif v86 == proto.wireTypes.i32 then
			local v97

			v97, n4 = proto.readFixed32(p5, n4)
		elseif v86 == proto.wireTypes.i64 then
			local v98

			v98, n4 = proto.readFixed64(p5, n4)
		else
			error("Unsupported wire type: " .. v86)
		end
	end

	return v83
end
function t6.jsonEncode(p6) -- line: 498
	local t8 = {}

	if p6.page_entries ~= nil and #p6.page_entries > 0 then
		local t9 = {}

		for _, v103 in p6.page_entries do
			table.insert(t9, v103:jsonEncode())
		end

		t8.pageEntries = t9
	end

	if p6.hydration_data ~= nil then
		t8.hydrationData = p6.hydration_data:jsonEncode()
	end

	if p6.templates ~= nil and next(p6.templates) ~= nil then
		local t10 = {}

		for v105, v106 in p6.templates do
			t10[v105] = v106:jsonEncode()
		end

		t8.templates = t10
	end

	if p6.localized_literals ~= nil and next(p6.localized_literals) ~= nil then
		local t11 = {}

		for v108, v109 in p6.localized_literals do
			t11[v108] = v109
		end

		t8.localizedLiterals = t11
	end

	return t8
end
function t6.jsonDecode(t12: {[any]: any}) -- line: 532
	-- upvalues: t6 (copy), page_entry_content (copy), hydration_content (copy), template_entry (copy)
	local v111 = t6.new()

	if t12.page_entries ~= nil then
		local t13 = {}

		for _, v114 in t12.page_entries do
			table.insert(t13, page_entry_content.UniversalPageEntry.jsonDecode(v114))
		end

		v111.page_entries = t13
	end

	if t12.pageEntries ~= nil then
		local t14 = {}

		for _, v117 in t12.pageEntries do
			table.insert(t14, page_entry_content.UniversalPageEntry.jsonDecode(v117))
		end

		v111.page_entries = t14
	end

	if t12.hydration_data ~= nil then
		v111.hydration_data = hydration_content.HydrationContent.jsonDecode(t12.hydration_data)
	end

	if t12.hydrationData ~= nil then
		v111.hydration_data = hydration_content.HydrationContent.jsonDecode(t12.hydrationData)
	end

	if t12.templates ~= nil then
		local t15 = {}

		for v119, v120 in t12.templates do
			t15[v119] = template_entry.TemplateEntry.jsonDecode(v120)
		end

		v111.templates = t15
	end

	if t12.localized_literals ~= nil then
		local t16 = {}

		for v122, v123 in t12.localized_literals do
			t16[v122] = v123
		end

		v111.localized_literals = t16
	end

	if t12.localizedLiterals ~= nil then
		local t17 = {}

		for v125, v126 in t12.localizedLiterals do
			t17[v125] = v126
		end

		v111.localized_literals = t17
	end

	return v111
end

t6.descriptor = {
	name = "GetSearchResultsPageResponse",
	fullName = "roblox.apppageplatform.search.v1beta1.GetSearchResultsPageResponse"
}
t1.GetSearchResultsPageResponse = t6
typeRegistry.default:register(t1.GetSearchResultsPageResponse)

local t18 = {}

t18.__index = t18

function t18.new(t19: {[any]: any}?) -- line: 615
	-- upvalues: t18 (copy)
	return (setmetatable({
		key = if t19 ~= nil and t19.key ~= nil then t19.key else "",
		value = if t19 ~= nil and t19.value ~= nil then t19.value else nil
	}, t18))
end
function t18.encode(p7) -- line: 624
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n5 = 0

	if p7.key ~= nil and p7.key ~= "" then
		local v131, v132 = proto.writeTag(buf, n5, 1, proto.wireTypes.lengthDelimited)

		buf, n5 = proto.writeString(v131, v132, p7.key)
	end

	if p7.value ~= nil then
		local v133 = p7.value:encode()
		local v134, v135 = proto.writeTag(buf, n5, 2, proto.wireTypes.lengthDelimited)

		buf, n5 = proto.writeBuffer(v134, v135, v133, buffer.len(v133))
	end

	local buf6 = buffer.create(n5)

	buffer.copy(buf6, 0, buf, 0, n5)

	return buf6
end
function t18.decode(p8: buffer) -- line: 646
	-- upvalues: t18 (copy), proto (copy), template_entry (copy)
	local v138 = t18.new()
	local n6 = 0

	while n6 < buffer.len(p8) do
		local v140, v141

		v140, v141, n6 = proto.readTag(p8, n6)

		if v141 == proto.wireTypes.varint then
			local v142

			v142, n6 = proto.readVarInt(p8, n6)
		elseif v141 == proto.wireTypes.lengthDelimited then
			if v140 == 1 then
				local v143

				v143, n6 = proto.readBuffer(p8, n6)
				v138.key = buffer.tostring(v143)
			elseif v140 == 2 then
				local v144

				v144, n6 = proto.readBuffer(p8, n6)
				v138.value = template_entry.TemplateEntry.decode(v144)
			else
				local v145, v146 = proto.readVarInt(p8, n6)

				n6 = v146 + v145
			end
		elseif v141 == proto.wireTypes.i32 then
			local v147

			v147, n6 = proto.readFixed32(p8, n6)
		elseif v141 == proto.wireTypes.i64 then
			local v148

			v148, n6 = proto.readFixed64(p8, n6)
		else
			error("Unsupported wire type: " .. v141)
		end
	end

	return v138
end
function t18.jsonEncode(p9) -- line: 696
	local t20 = {}

	if p9.key ~= nil and p9.key ~= "" then
		t20.key = p9.key
	end

	if p9.value ~= nil then
		t20.value = p9.value:jsonEncode()
	end

	return t20
end
function t18.jsonDecode(t21: {[any]: any}) -- line: 712
	-- upvalues: t18 (copy), template_entry (copy)
	local v152 = t18.new()

	if t21.key ~= nil then
		v152.key = t21.key
	end

	if t21.value ~= nil then
		v152.value = template_entry.TemplateEntry.jsonDecode(t21.value)
	end

	return v152
end

t18.descriptor = {
	name = "GetSearchResultsPageResponse_TemplatesEntry",
	fullName = "roblox.apppageplatform.search.v1beta1.TemplatesEntry"
}
t1.GetSearchResultsPageResponse_TemplatesEntry = t18
typeRegistry.default:register(t1.GetSearchResultsPageResponse_TemplatesEntry)

local t22 = {}

t22.__index = t22

function t22.new(t23: {[any]: any}?) -- line: 743
	-- upvalues: t22 (copy)
	return (setmetatable({
		key = if t23 ~= nil and t23.key ~= nil then t23.key else "",
		value = if t23 ~= nil and t23.value ~= nil then t23.value else ""
	}, t22))
end
function t22.encode(p10) -- line: 755
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n7 = 0

	if p10.key ~= nil and p10.key ~= "" then
		local v157, v158 = proto.writeTag(buf, n7, 1, proto.wireTypes.lengthDelimited)

		buf, n7 = proto.writeString(v157, v158, p10.key)
	end

	if p10.value ~= nil and p10.value ~= "" then
		local v159, v160 = proto.writeTag(buf, n7, 2, proto.wireTypes.lengthDelimited)

		buf, n7 = proto.writeString(v159, v160, p10.value)
	end

	local buf7 = buffer.create(n7)

	buffer.copy(buf7, 0, buf, 0, n7)

	return buf7
end
function t22.decode(p11: buffer) -- line: 776
	-- upvalues: t22 (copy), proto (copy)
	local v163 = t22.new()
	local n8 = 0

	while n8 < buffer.len(p11) do
		local v165, v166

		v165, v166, n8 = proto.readTag(p11, n8)

		if v166 == proto.wireTypes.varint then
			local v167

			v167, n8 = proto.readVarInt(p11, n8)
		elseif v166 == proto.wireTypes.lengthDelimited then
			if v165 == 1 then
				local v168

				v168, n8 = proto.readBuffer(p11, n8)
				v163.key = buffer.tostring(v168)
			elseif v165 == 2 then
				local v169

				v169, n8 = proto.readBuffer(p11, n8)
				v163.value = buffer.tostring(v169)
			else
				local v170, v171 = proto.readVarInt(p11, n8)

				n8 = v171 + v170
			end
		elseif v166 == proto.wireTypes.i32 then
			local v172

			v172, n8 = proto.readFixed32(p11, n8)
		elseif v166 == proto.wireTypes.i64 then
			local v173

			v173, n8 = proto.readFixed64(p11, n8)
		else
			error("Unsupported wire type: " .. v166)
		end
	end

	return v163
end
function t22.jsonEncode(p12) -- line: 826
	local t24 = {}

	if p12.key ~= nil and p12.key ~= "" then
		t24.key = p12.key
	end

	if p12.value ~= nil and p12.value ~= "" then
		t24.value = p12.value
	end

	return t24
end
function t22.jsonDecode(t25: {[any]: any}) -- line: 842
	-- upvalues: t22 (copy)
	local v177 = t22.new()

	if t25.key ~= nil then
		v177.key = t25.key
	end

	if t25.value ~= nil then
		v177.value = t25.value
	end

	return v177
end

t22.descriptor = {
	name = "GetSearchResultsPageResponse_LocalizedLiteralsEntry",
	fullName = "roblox.apppageplatform.search.v1beta1.LocalizedLiteralsEntry"
}
t1.GetSearchResultsPageResponse_LocalizedLiteralsEntry = t22
typeRegistry.default:register(t1.GetSearchResultsPageResponse_LocalizedLiteralsEntry)
t1.SearchResultsPageVerticalType = {
	fromNumber = function(n9: number) -- line: 870
		if n9 == 0 then
			return "SEARCH_RESULTS_PAGE_VERTICAL_TYPE_INVALID"
		end

		if n9 == 1 then
			return "SEARCH_RESULTS_PAGE_VERTICAL_TYPE_BLENDED"
		end

		if n9 == 2 then
			return "SEARCH_RESULTS_PAGE_VERTICAL_TYPE_GAME"
		end

		if n9 == 3 then
			return "SEARCH_RESULTS_PAGE_VERTICAL_TYPE_USER"
		end

		return nil
	end,
	toNumber = function(p13) -- line: 884
		if p13 == "SEARCH_RESULTS_PAGE_VERTICAL_TYPE_INVALID" then
			return 0
		end

		if p13 == "SEARCH_RESULTS_PAGE_VERTICAL_TYPE_BLENDED" then
			return 1
		end

		if p13 == "SEARCH_RESULTS_PAGE_VERTICAL_TYPE_GAME" then
			return 2
		end

		if p13 == "SEARCH_RESULTS_PAGE_VERTICAL_TYPE_USER" then
			return 3
		end

		return p13
	end,
	fromName = function(s1: string) -- line: 898
		if s1 == "SEARCH_RESULTS_PAGE_VERTICAL_TYPE_INVALID" then
			return "SEARCH_RESULTS_PAGE_VERTICAL_TYPE_INVALID"
		end

		if s1 == "SEARCH_RESULTS_PAGE_VERTICAL_TYPE_BLENDED" then
			return "SEARCH_RESULTS_PAGE_VERTICAL_TYPE_BLENDED"
		end

		if s1 == "SEARCH_RESULTS_PAGE_VERTICAL_TYPE_GAME" then
			return "SEARCH_RESULTS_PAGE_VERTICAL_TYPE_GAME"
		end

		if s1 == "SEARCH_RESULTS_PAGE_VERTICAL_TYPE_USER" then
			return "SEARCH_RESULTS_PAGE_VERTICAL_TYPE_USER"
		end

		return nil
	end
}

return {
	GetSearchResultsPageRequest = t1.GetSearchResultsPageRequest,
	GetSearchResultsPageResponse = t1.GetSearchResultsPageResponse,
	SearchResultsPageVerticalType = t1.SearchResultsPageVerticalType
}
