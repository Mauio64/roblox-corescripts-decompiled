local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local hydration_content = require(script.Parent.Parent.Parent.shared.v1beta1.hydration_content)
local hydration_stream_mode = require(script.Parent.Parent.Parent.shared.v1beta1.hydration_stream_mode)
local template_entry = require(script.Parent.Parent.Parent.shared.v1beta1.template_entry)
local page_entry_content = require(script.Parent.Parent.Parent.shared.v1beta1.page_entry_content)
local client_capabilities = require(script.Parent.Parent.Parent.shared.v1beta1.client_capabilities)
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 404
	-- upvalues: hydration_stream_mode (copy), t2 (copy)
	return (setmetatable({
		feed_page_token = if t3 ~= nil and t3.feed_page_token ~= nil then t3.feed_page_token else "",
		device = if t3 ~= nil and t3.device ~= nil then t3.device else "",
		country = if t3 ~= nil and t3.country ~= nil then t3.country else "",
		age_group = if t3 ~= nil and t3.age_group ~= nil then t3.age_group else "",
		session_id = if t3 ~= nil and t3.session_id ~= nil then t3.session_id else "",
		entry_pagination_key = if t3 ~= nil and t3.entry_pagination_key ~= nil then t3.entry_pagination_key else "",
		entry_page_token = if t3 ~= nil and t3.entry_page_token ~= nil then t3.entry_page_token else "",
		max_memory = if t3 ~= nil and t3.max_memory ~= nil then t3.max_memory else "",
		page_type = if t3 ~= nil and t3.page_type ~= nil then t3.page_type else "",
		include_placeholders = if t3 ~= nil and t3.include_placeholders ~= nil then t3.include_placeholders else nil,
		hydration_stream_enabled = if t3 ~= nil and t3.hydration_stream_enabled ~= nil then t3.hydration_stream_enabled else nil,
		hydration_stream_mode = if t3 ~= nil and t3.hydration_stream_mode ~= nil then t3.hydration_stream_mode else assert(hydration_stream_mode.HydrationStreamMode.fromNumber(0), "Enum has no 0 default"),
		collection_layout = if t3 ~= nil and t3.collection_layout ~= nil then t3.collection_layout else nil,
		cached_roblox_component_to_template_id = if t3 ~= nil and t3.cached_roblox_component_to_template_id ~= nil then t3.cached_roblox_component_to_template_id else {},
		client_capabilities = if t3 ~= nil and t3.client_capabilities ~= nil then t3.client_capabilities else nil
	}, t2))
end
function t2.encode(p1) -- line: 440
	-- upvalues: proto (copy), hydration_stream_mode (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.feed_page_token ~= nil and p1.feed_page_token ~= "" then
		local v24, v25 = proto.writeTag(buf, n1, 1, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v24, v25, p1.feed_page_token)
	end

	if p1.device ~= nil and p1.device ~= "" then
		local v26, v27 = proto.writeTag(buf, n1, 2, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v26, v27, p1.device)
	end

	if p1.country ~= nil and p1.country ~= "" then
		local v28, v29 = proto.writeTag(buf, n1, 3, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v28, v29, p1.country)
	end

	if p1.age_group ~= nil and p1.age_group ~= "" then
		local v30, v31 = proto.writeTag(buf, n1, 4, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v30, v31, p1.age_group)
	end

	if p1.session_id ~= nil and p1.session_id ~= "" then
		local v32, v33 = proto.writeTag(buf, n1, 5, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v32, v33, p1.session_id)
	end

	if p1.entry_pagination_key ~= nil and p1.entry_pagination_key ~= "" then
		local v34, v35 = proto.writeTag(buf, n1, 6, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v34, v35, p1.entry_pagination_key)
	end

	if p1.entry_page_token ~= nil and p1.entry_page_token ~= "" then
		local v36, v37 = proto.writeTag(buf, n1, 7, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v36, v37, p1.entry_page_token)
	end

	if p1.max_memory ~= nil and p1.max_memory ~= "" then
		local v38, v39 = proto.writeTag(buf, n1, 8, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v38, v39, p1.max_memory)
	end

	if p1.page_type ~= nil and p1.page_type ~= "" then
		local v40, v41 = proto.writeTag(buf, n1, 9, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v40, v41, p1.page_type)
	end

	if p1.include_placeholders ~= nil then
		local v42, v43 = proto.writeTag(buf, n1, 10, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v42, v43, not p1.include_placeholders and 0 or 1)
	end

	if p1.hydration_stream_enabled ~= nil then
		local v44, v45 = proto.writeTag(buf, n1, 11, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v44, v45, not p1.hydration_stream_enabled and 0 or 1)
	end

	if p1.hydration_stream_mode ~= nil and (p1.hydration_stream_mode ~= nil and p1.hydration_stream_mode ~= 0 or p1.hydration_stream_mode ~= hydration_stream_mode.HydrationStreamMode.fromNumber(0)) then
		local v46, v47 = proto.writeTag(buf, n1, 12, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v46, v47, hydration_stream_mode.HydrationStreamMode.toNumber(p1.hydration_stream_mode))
	end

	if p1.collection_layout ~= nil then
		local v48 = p1.collection_layout:encode()
		local v49, v50 = proto.writeTag(buf, n1, 13, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeBuffer(v49, v50, v48, buffer.len(v48))
	end

	if p1.cached_roblox_component_to_template_id ~= nil and next(p1.cached_roblox_component_to_template_id) ~= nil then
		for v51, v52 in p1.cached_roblox_component_to_template_id do
			local buf2 = buffer.create(0)
			local v54, v55 = proto.writeTag(buf2, 0, 1, proto.wireTypes.lengthDelimited)
			local v56, v57 = proto.writeString(v54, v55, v51)
			local v58, v59 = proto.writeTag(v56, v57, 2, proto.wireTypes.lengthDelimited)
			local v60, v61 = proto.writeString(v58, v59, v52)
			local v62, v63 = proto.writeTag(buf, n1, 14, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v62, v63, v60, v61)
		end
	end

	if p1.client_capabilities ~= nil then
		local v64 = p1.client_capabilities:encode()
		local v65, v66 = proto.writeTag(buf, n1, 15, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeBuffer(v65, v66, v64, buffer.len(v64))
	end

	local buf3 = buffer.create(n1)

	buffer.copy(buf3, 0, buf, 0, n1)

	return buf3
end
function t2.decode(p2: buffer) -- line: 550
	-- upvalues: t2 (copy), proto (copy), hydration_stream_mode (copy), t1 (copy), client_capabilities (copy)
	local v69 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v71, v72

		v71, v72, n2 = proto.readTag(p2, n2)

		if v72 == proto.wireTypes.varint then
			if v71 == 10 then
				local v73

				v73, n2 = proto.readVarInt(p2, n2)
				v69.include_placeholders = v73 ~= 0
			elseif v71 == 11 then
				local v74

				v74, n2 = proto.readVarInt(p2, n2)
				v69.hydration_stream_enabled = v74 ~= 0
			elseif v71 == 12 then
				local v75

				v75, n2 = proto.readVarIntI32(p2, n2)
				v69.hydration_stream_mode = hydration_stream_mode.HydrationStreamMode.fromNumber(v75) or v75
			else
				local v76

				v76, n2 = proto.readVarInt(p2, n2)
			end
		elseif v72 == proto.wireTypes.lengthDelimited then
			if v71 == 1 then
				local v77

				v77, n2 = proto.readBuffer(p2, n2)
				v69.feed_page_token = buffer.tostring(v77)
			elseif v71 == 2 then
				local v78

				v78, n2 = proto.readBuffer(p2, n2)
				v69.device = buffer.tostring(v78)
			elseif v71 == 3 then
				local v79

				v79, n2 = proto.readBuffer(p2, n2)
				v69.country = buffer.tostring(v79)
			elseif v71 == 4 then
				local v80

				v80, n2 = proto.readBuffer(p2, n2)
				v69.age_group = buffer.tostring(v80)
			elseif v71 == 5 then
				local v81

				v81, n2 = proto.readBuffer(p2, n2)
				v69.session_id = buffer.tostring(v81)
			elseif v71 == 6 then
				local v82

				v82, n2 = proto.readBuffer(p2, n2)
				v69.entry_pagination_key = buffer.tostring(v82)
			elseif v71 == 7 then
				local v83

				v83, n2 = proto.readBuffer(p2, n2)
				v69.entry_page_token = buffer.tostring(v83)
			elseif v71 == 8 then
				local v84

				v84, n2 = proto.readBuffer(p2, n2)
				v69.max_memory = buffer.tostring(v84)
			elseif v71 == 9 then
				local v85

				v85, n2 = proto.readBuffer(p2, n2)
				v69.page_type = buffer.tostring(v85)
			elseif v71 == 13 then
				local v86

				v86, n2 = proto.readBuffer(p2, n2)
				v69.collection_layout = t1.CollectionLayoutInfo.decode(v86)
			elseif v71 == 14 then
				local v87

				v87, n2 = proto.readBuffer(p2, n2)

				local v88 = t1.GetChartsPageRequest_CachedRobloxComponentToTemplateIdEntry.decode(v87)

				v69.cached_roblox_component_to_template_id[v88.key or ""] = v88.value or ""
			elseif v71 == 15 then
				local v89

				v89, n2 = proto.readBuffer(p2, n2)
				v69.client_capabilities = client_capabilities.ClientCapabilities.decode(v89)
			else
				local v90, v91 = proto.readVarInt(p2, n2)

				n2 = v91 + v90
			end
		elseif v72 == proto.wireTypes.i32 then
			local v92

			v92, n2 = proto.readFixed32(p2, n2)
		elseif v72 == proto.wireTypes.i64 then
			local v93

			v93, n2 = proto.readFixed64(p2, n2)
		else
			error("Unsupported wire type: " .. v72)
		end
	end

	return v69
end
function t2.jsonEncode(p3) -- line: 676
	-- upvalues: hydration_stream_mode (copy)
	local t4 = {}

	if p3.feed_page_token ~= nil and p3.feed_page_token ~= "" then
		t4.feedPageToken = p3.feed_page_token
	end

	if p3.device ~= nil and p3.device ~= "" then
		t4.device = p3.device
	end

	if p3.country ~= nil and p3.country ~= "" then
		t4.country = p3.country
	end

	if p3.age_group ~= nil and p3.age_group ~= "" then
		t4.ageGroup = p3.age_group
	end

	if p3.session_id ~= nil and p3.session_id ~= "" then
		t4.sessionId = p3.session_id
	end

	if p3.entry_pagination_key ~= nil and p3.entry_pagination_key ~= "" then
		t4.entryPaginationKey = p3.entry_pagination_key
	end

	if p3.entry_page_token ~= nil and p3.entry_page_token ~= "" then
		t4.entryPageToken = p3.entry_page_token
	end

	if p3.max_memory ~= nil and p3.max_memory ~= "" then
		t4.maxMemory = p3.max_memory
	end

	if p3.page_type ~= nil and p3.page_type ~= "" then
		t4.pageType = p3.page_type
	end

	if p3.include_placeholders ~= nil then
		t4.includePlaceholders = p3.include_placeholders
	end

	if p3.hydration_stream_enabled ~= nil then
		t4.hydrationStreamEnabled = p3.hydration_stream_enabled
	end

	if p3.hydration_stream_mode ~= nil and (p3.hydration_stream_mode ~= nil and p3.hydration_stream_mode ~= 0 or p3.hydration_stream_mode ~= hydration_stream_mode.HydrationStreamMode.fromNumber(0)) then
		t4.hydrationStreamMode = if typeof(p3.hydration_stream_mode) ~= "number" then hydration_stream_mode.HydrationStreamMode.toNumber(p3.hydration_stream_mode) else p3.hydration_stream_mode
	end

	if p3.collection_layout ~= nil then
		t4.collectionLayout = p3.collection_layout:jsonEncode()
	end

	if p3.cached_roblox_component_to_template_id ~= nil and next(p3.cached_roblox_component_to_template_id) ~= nil then
		local t5 = {}

		for v97, v98 in p3.cached_roblox_component_to_template_id do
			t5[v97] = v98
		end

		t4.cachedRobloxComponentToTemplateId = t5
	end

	if p3.client_capabilities ~= nil then
		t4.clientCapabilities = p3.client_capabilities:jsonEncode()
	end

	return t4
end
function t2.jsonDecode(t6: {[any]: any}) -- line: 760
	-- upvalues: t2 (copy), hydration_stream_mode (copy), t1 (copy), client_capabilities (copy)
	local v100 = t2.new()

	if t6.feed_page_token ~= nil then
		v100.feed_page_token = t6.feed_page_token
	end

	if t6.feedPageToken ~= nil then
		v100.feed_page_token = t6.feedPageToken
	end

	if t6.device ~= nil then
		v100.device = t6.device
	end

	if t6.country ~= nil then
		v100.country = t6.country
	end

	if t6.age_group ~= nil then
		v100.age_group = t6.age_group
	end

	if t6.ageGroup ~= nil then
		v100.age_group = t6.ageGroup
	end

	if t6.session_id ~= nil then
		v100.session_id = t6.session_id
	end

	if t6.sessionId ~= nil then
		v100.session_id = t6.sessionId
	end

	if t6.entry_pagination_key ~= nil then
		v100.entry_pagination_key = t6.entry_pagination_key
	end

	if t6.entryPaginationKey ~= nil then
		v100.entry_pagination_key = t6.entryPaginationKey
	end

	if t6.entry_page_token ~= nil then
		v100.entry_page_token = t6.entry_page_token
	end

	if t6.entryPageToken ~= nil then
		v100.entry_page_token = t6.entryPageToken
	end

	if t6.max_memory ~= nil then
		v100.max_memory = t6.max_memory
	end

	if t6.maxMemory ~= nil then
		v100.max_memory = t6.maxMemory
	end

	if t6.page_type ~= nil then
		v100.page_type = t6.page_type
	end

	if t6.pageType ~= nil then
		v100.page_type = t6.pageType
	end

	if t6.include_placeholders ~= nil then
		v100.include_placeholders = t6.include_placeholders
	end

	if t6.includePlaceholders ~= nil then
		v100.include_placeholders = t6.includePlaceholders
	end

	if t6.hydration_stream_enabled ~= nil then
		v100.hydration_stream_enabled = t6.hydration_stream_enabled
	end

	if t6.hydrationStreamEnabled ~= nil then
		v100.hydration_stream_enabled = t6.hydrationStreamEnabled
	end

	if t6.hydration_stream_mode ~= nil then
		v100.hydration_stream_mode = if typeof(t6.hydration_stream_mode) ~= "number" then hydration_stream_mode.HydrationStreamMode.fromName(t6.hydration_stream_mode) or t6.hydration_stream_mode else hydration_stream_mode.HydrationStreamMode.fromNumber(t6.hydration_stream_mode) or t6.hydration_stream_mode
	end

	if t6.hydrationStreamMode ~= nil then
		v100.hydration_stream_mode = if typeof(t6.hydrationStreamMode) ~= "number" then hydration_stream_mode.HydrationStreamMode.fromName(t6.hydrationStreamMode) or t6.hydrationStreamMode else hydration_stream_mode.HydrationStreamMode.fromNumber(t6.hydrationStreamMode) or t6.hydrationStreamMode
	end

	if t6.collection_layout ~= nil then
		v100.collection_layout = t1.CollectionLayoutInfo.jsonDecode(t6.collection_layout)
	end

	if t6.collectionLayout ~= nil then
		v100.collection_layout = t1.CollectionLayoutInfo.jsonDecode(t6.collectionLayout)
	end

	if t6.cached_roblox_component_to_template_id ~= nil then
		local t7 = {}

		for v102, v103 in t6.cached_roblox_component_to_template_id do
			t7[v102] = v103
		end

		v100.cached_roblox_component_to_template_id = t7
	end

	if t6.cachedRobloxComponentToTemplateId ~= nil then
		local t8 = {}

		for v105, v106 in t6.cachedRobloxComponentToTemplateId do
			t8[v105] = v106
		end

		v100.cached_roblox_component_to_template_id = t8
	end

	if t6.client_capabilities ~= nil then
		v100.client_capabilities = client_capabilities.ClientCapabilities.jsonDecode(t6.client_capabilities)
	end

	if t6.clientCapabilities ~= nil then
		v100.client_capabilities = client_capabilities.ClientCapabilities.jsonDecode(t6.clientCapabilities)
	end

	return v100
end

t2.descriptor = {
	name = "GetChartsPageRequest",
	fullName = "roblox.apppageplatform.charts.v1beta1.GetChartsPageRequest"
}
t1.GetChartsPageRequest = t2
typeRegistry.default:register(t1.GetChartsPageRequest)

local t9 = {}

t9.__index = t9

function t9.new(t10: {[any]: any}?) -- line: 921
	-- upvalues: t9 (copy)
	return (setmetatable({
		key = if t10 ~= nil and t10.key ~= nil then t10.key else "",
		value = if t10 ~= nil and t10.value ~= nil then t10.value else ""
	}, t9))
end
function t9.encode(p4) -- line: 933
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n3 = 0

	if p4.key ~= nil and p4.key ~= "" then
		local v111, v112 = proto.writeTag(buf, n3, 1, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeString(v111, v112, p4.key)
	end

	if p4.value ~= nil and p4.value ~= "" then
		local v113, v114 = proto.writeTag(buf, n3, 2, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeString(v113, v114, p4.value)
	end

	local buf4 = buffer.create(n3)

	buffer.copy(buf4, 0, buf, 0, n3)

	return buf4
end
function t9.decode(p5: buffer) -- line: 954
	-- upvalues: t9 (copy), proto (copy)
	local v117 = t9.new()
	local n4 = 0

	while n4 < buffer.len(p5) do
		local v119, v120

		v119, v120, n4 = proto.readTag(p5, n4)

		if v120 == proto.wireTypes.varint then
			local v121

			v121, n4 = proto.readVarInt(p5, n4)
		elseif v120 == proto.wireTypes.lengthDelimited then
			if v119 == 1 then
				local v122

				v122, n4 = proto.readBuffer(p5, n4)
				v117.key = buffer.tostring(v122)
			elseif v119 == 2 then
				local v123

				v123, n4 = proto.readBuffer(p5, n4)
				v117.value = buffer.tostring(v123)
			else
				local v124, v125 = proto.readVarInt(p5, n4)

				n4 = v125 + v124
			end
		elseif v120 == proto.wireTypes.i32 then
			local v126

			v126, n4 = proto.readFixed32(p5, n4)
		elseif v120 == proto.wireTypes.i64 then
			local v127

			v127, n4 = proto.readFixed64(p5, n4)
		else
			error("Unsupported wire type: " .. v120)
		end
	end

	return v117
end
function t9.jsonEncode(p6) -- line: 1004
	local t11 = {}

	if p6.key ~= nil and p6.key ~= "" then
		t11.key = p6.key
	end

	if p6.value ~= nil and p6.value ~= "" then
		t11.value = p6.value
	end

	return t11
end
function t9.jsonDecode(t12: {[any]: any}) -- line: 1020
	-- upvalues: t9 (copy)
	local v131 = t9.new()

	if t12.key ~= nil then
		v131.key = t12.key
	end

	if t12.value ~= nil then
		v131.value = t12.value
	end

	return v131
end

t9.descriptor = {
	name = "GetChartsPageRequest_CachedRobloxComponentToTemplateIdEntry",
	fullName = "roblox.apppageplatform.charts.v1beta1.CachedRobloxComponentToTemplateIdEntry"
}
t1.GetChartsPageRequest_CachedRobloxComponentToTemplateIdEntry = t9
typeRegistry.default:register(t1.GetChartsPageRequest_CachedRobloxComponentToTemplateIdEntry)

local t13 = {}

t13.__index = t13

function t13.new(t14: {[any]: any}?) -- line: 1051
	-- upvalues: t13 (copy)
	return (setmetatable({
		items_per_row = if t14 ~= nil and t14.items_per_row ~= nil then t14.items_per_row else {},
		rows_above_fold = if t14 ~= nil and t14.rows_above_fold ~= nil then t14.rows_above_fold else 0
	}, t13))
end
function t13.encode(p7) -- line: 1058
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n5 = 0

	if p7.items_per_row ~= nil and next(p7.items_per_row) ~= nil then
		for v136, v137 in p7.items_per_row do
			local buf5 = buffer.create(0)
			local v139, v140 = proto.writeTag(buf5, 0, 1, proto.wireTypes.lengthDelimited)
			local v141, v142 = proto.writeString(v139, v140, v136)
			local v143, v144 = proto.writeTag(v141, v142, 2, proto.wireTypes.varint)
			local v145, v146 = proto.writeVarInt(v143, v144, v137)
			local v147, v148 = proto.writeTag(buf, n5, 1, proto.wireTypes.lengthDelimited)

			buf, n5 = proto.writeBuffer(v147, v148, v145, v146)
		end
	end

	if p7.rows_above_fold ~= nil and p7.rows_above_fold ~= 0 then
		local v149, v150 = proto.writeTag(buf, n5, 2, proto.wireTypes.varint)

		buf, n5 = proto.writeVarInt(v149, v150, p7.rows_above_fold)
	end

	local buf6 = buffer.create(n5)

	buffer.copy(buf6, 0, buf, 0, n5)

	return buf6
end
function t13.decode(p8: buffer) -- line: 1085
	-- upvalues: t13 (copy), proto (copy), t1 (copy)
	local v153 = t13.new()
	local n6 = 0

	while n6 < buffer.len(p8) do
		local v155, v156

		v155, v156, n6 = proto.readTag(p8, n6)

		if v156 == proto.wireTypes.varint then
			if v155 == 2 then
				local v157

				v157, n6 = proto.readVarIntI32(p8, n6)
				v153.rows_above_fold = v157
			else
				local v158

				v158, n6 = proto.readVarInt(p8, n6)
			end
		elseif v156 == proto.wireTypes.lengthDelimited then
			if v155 == 1 then
				local v159

				v159, n6 = proto.readBuffer(p8, n6)

				local v160 = t1.CollectionLayoutInfo_ItemsPerRowEntry.decode(v159)

				v153.items_per_row[v160.key or ""] = v160.value or 0
			else
				local v161, v162 = proto.readVarInt(p8, n6)

				n6 = v162 + v161
			end
		elseif v156 == proto.wireTypes.i32 then
			local v163

			v163, n6 = proto.readFixed32(p8, n6)
		elseif v156 == proto.wireTypes.i64 then
			local v164

			v164, n6 = proto.readFixed64(p8, n6)
		else
			error("Unsupported wire type: " .. v156)
		end
	end

	return v153
end
function t13.jsonEncode(p9) -- line: 1140
	local t15 = {}

	if p9.items_per_row ~= nil and next(p9.items_per_row) ~= nil then
		local t16 = {}

		for v168, v169 in p9.items_per_row do
			t16[v168] = v169
		end

		t15.itemsPerRow = t16
	end

	if p9.rows_above_fold ~= nil and p9.rows_above_fold ~= 0 then
		t15.rowsAboveFold = p9.rows_above_fold
	end

	return t15
end
function t13.jsonDecode(t17: {[any]: any}) -- line: 1158
	-- upvalues: t13 (copy)
	local v171 = t13.new()

	if t17.items_per_row ~= nil then
		local t18 = {}

		for v173, v174 in t17.items_per_row do
			t18[v173] = v174
		end

		v171.items_per_row = t18
	end

	if t17.itemsPerRow ~= nil then
		local t19 = {}

		for v176, v177 in t17.itemsPerRow do
			t19[v176] = v177
		end

		v171.items_per_row = t19
	end

	if t17.rows_above_fold ~= nil then
		v171.rows_above_fold = t17.rows_above_fold
	end

	if t17.rowsAboveFold ~= nil then
		v171.rows_above_fold = t17.rowsAboveFold
	end

	return v171
end

t13.descriptor = {
	name = "CollectionLayoutInfo",
	fullName = "roblox.apppageplatform.charts.v1beta1.CollectionLayoutInfo"
}
t1.CollectionLayoutInfo = t13
typeRegistry.default:register(t1.CollectionLayoutInfo)

local t20 = {}

t20.__index = t20

function t20.new(t21: {[any]: any}?) -- line: 1204
	-- upvalues: t20 (copy)
	return (setmetatable({
		key = if t21 ~= nil and t21.key ~= nil then t21.key else "",
		value = if t21 ~= nil and t21.value ~= nil then t21.value else 0
	}, t20))
end
function t20.encode(p10) -- line: 1213
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n7 = 0

	if p10.key ~= nil and p10.key ~= "" then
		local v182, v183 = proto.writeTag(buf, n7, 1, proto.wireTypes.lengthDelimited)

		buf, n7 = proto.writeString(v182, v183, p10.key)
	end

	if p10.value ~= nil and p10.value ~= 0 then
		local v184, v185 = proto.writeTag(buf, n7, 2, proto.wireTypes.varint)

		buf, n7 = proto.writeVarInt(v184, v185, p10.value)
	end

	local buf7 = buffer.create(n7)

	buffer.copy(buf7, 0, buf, 0, n7)

	return buf7
end
function t20.decode(p11: buffer) -- line: 1232
	-- upvalues: t20 (copy), proto (copy)
	local v188 = t20.new()
	local n8 = 0

	while n8 < buffer.len(p11) do
		local v190, v191

		v190, v191, n8 = proto.readTag(p11, n8)

		if v191 == proto.wireTypes.varint then
			if v190 == 2 then
				local v192

				v192, n8 = proto.readVarIntI32(p11, n8)
				v188.value = v192
			else
				local v193

				v193, n8 = proto.readVarInt(p11, n8)
			end
		elseif v191 == proto.wireTypes.lengthDelimited then
			if v190 == 1 then
				local v194

				v194, n8 = proto.readBuffer(p11, n8)
				v188.key = buffer.tostring(v194)
			else
				local v195, v196 = proto.readVarInt(p11, n8)

				n8 = v196 + v195
			end
		elseif v191 == proto.wireTypes.i32 then
			local v197

			v197, n8 = proto.readFixed32(p11, n8)
		elseif v191 == proto.wireTypes.i64 then
			local v198

			v198, n8 = proto.readFixed64(p11, n8)
		else
			error("Unsupported wire type: " .. v191)
		end
	end

	return v188
end
function t20.jsonEncode(p12) -- line: 1280
	local t22 = {}

	if p12.key ~= nil and p12.key ~= "" then
		t22.key = p12.key
	end

	if p12.value ~= nil and p12.value ~= 0 then
		t22.value = p12.value
	end

	return t22
end
function t20.jsonDecode(t23: {[any]: any}) -- line: 1294
	-- upvalues: t20 (copy)
	local v202 = t20.new()

	if t23.key ~= nil then
		v202.key = t23.key
	end

	if t23.value ~= nil then
		v202.value = t23.value
	end

	return v202
end

t20.descriptor = {
	name = "CollectionLayoutInfo_ItemsPerRowEntry",
	fullName = "roblox.apppageplatform.charts.v1beta1.ItemsPerRowEntry"
}
t1.CollectionLayoutInfo_ItemsPerRowEntry = t20
typeRegistry.default:register(t1.CollectionLayoutInfo_ItemsPerRowEntry)

local t24 = {}

t24.__index = t24

function t24.new(t25: {[any]: any}?) -- line: 1324
	-- upvalues: t24 (copy)
	return (setmetatable({
		page_entries = if t25 ~= nil and t25.page_entries ~= nil then t25.page_entries else {},
		hydration_data = if t25 ~= nil and t25.hydration_data ~= nil then t25.hydration_data else nil,
		templates = if t25 ~= nil and t25.templates ~= nil then t25.templates else {},
		localized_literals = if t25 ~= nil and t25.localized_literals ~= nil then t25.localized_literals else {}
	}, t24))
end
function t24.encode(p13) -- line: 1333
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n9 = 0

	if p13.page_entries ~= nil and #p13.page_entries > 0 then
		for _, v208 in p13.page_entries do
			local v209 = v208:encode()
			local v210, v211 = proto.writeTag(buf, n9, 1, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v210, v211, v209, buffer.len(v209))
		end
	end

	if p13.hydration_data ~= nil then
		local v212 = p13.hydration_data:encode()
		local v213, v214 = proto.writeTag(buf, n9, 2, proto.wireTypes.lengthDelimited)

		buf, n9 = proto.writeBuffer(v213, v214, v212, buffer.len(v212))
	end

	if p13.templates ~= nil and next(p13.templates) ~= nil then
		for v215, v216 in p13.templates do
			local buf8 = buffer.create(0)
			local v218, v219 = proto.writeTag(buf8, 0, 1, proto.wireTypes.lengthDelimited)
			local v220, v221 = proto.writeString(v218, v219, v215)
			local v222 = v216:encode()
			local v223, v224 = proto.writeTag(v220, v221, 2, proto.wireTypes.lengthDelimited)
			local v225, v226 = proto.writeBuffer(v223, v224, v222, buffer.len(v222))
			local v227, v228 = proto.writeTag(buf, n9, 3, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v227, v228, v225, v226)
		end
	end

	if p13.localized_literals ~= nil and next(p13.localized_literals) ~= nil then
		for v229, v230 in p13.localized_literals do
			local buf9 = buffer.create(0)
			local v232, v233 = proto.writeTag(buf9, 0, 1, proto.wireTypes.lengthDelimited)
			local v234, v235 = proto.writeString(v232, v233, v229)
			local v236, v237 = proto.writeTag(v234, v235, 2, proto.wireTypes.lengthDelimited)
			local v238, v239 = proto.writeString(v236, v237, v230)
			local v240, v241 = proto.writeTag(buf, n9, 4, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v240, v241, v238, v239)
		end
	end

	local buf10 = buffer.create(n9)

	buffer.copy(buf10, 0, buf, 0, n9)

	return buf10
end
function t24.decode(p14: buffer) -- line: 1383
	-- upvalues: t24 (copy), proto (copy), page_entry_content (copy), hydration_content (copy), t1 (copy), template_entry (copy)
	local v244 = t24.new()
	local n10 = 0

	while n10 < buffer.len(p14) do
		local v246, v247

		v246, v247, n10 = proto.readTag(p14, n10)

		if v247 == proto.wireTypes.varint then
			local v248

			v248, n10 = proto.readVarInt(p14, n10)
		elseif v247 == proto.wireTypes.lengthDelimited then
			if v246 == 1 then
				local v249

				v249, n10 = proto.readBuffer(p14, n10)
				table.insert(v244.page_entries, page_entry_content.UniversalPageEntry.decode(v249))
			elseif v246 == 2 then
				local v250

				v250, n10 = proto.readBuffer(p14, n10)
				v244.hydration_data = hydration_content.HydrationContent.decode(v250)
			elseif v246 == 3 then
				local v251

				v251, n10 = proto.readBuffer(p14, n10)

				local v252 = t1.GetChartsPageResponse_TemplatesEntry.decode(v251)
				local v253 = template_entry.TemplateEntry.new()

				v244.templates[v252.key or ""] = v252.value or v253
			elseif v246 == 4 then
				local v254

				v254, n10 = proto.readBuffer(p14, n10)

				local v255 = t1.GetChartsPageResponse_LocalizedLiteralsEntry.decode(v254)

				v244.localized_literals[v255.key or ""] = v255.value or ""
			else
				local v256, v257 = proto.readVarInt(p14, n10)

				n10 = v257 + v256
			end
		elseif v247 == proto.wireTypes.i32 then
			local v258

			v258, n10 = proto.readFixed32(p14, n10)
		elseif v247 == proto.wireTypes.i64 then
			local v259

			v259, n10 = proto.readFixed64(p14, n10)
		else
			error("Unsupported wire type: " .. v247)
		end
	end

	return v244
end
function t24.jsonEncode(p15) -- line: 1459
	local t26 = {}

	if p15.page_entries ~= nil and #p15.page_entries > 0 then
		local t27 = {}

		for _, v264 in p15.page_entries do
			table.insert(t27, v264:jsonEncode())
		end

		t26.pageEntries = t27
	end

	if p15.hydration_data ~= nil then
		t26.hydrationData = p15.hydration_data:jsonEncode()
	end

	if p15.templates ~= nil and next(p15.templates) ~= nil then
		local t28 = {}

		for v266, v267 in p15.templates do
			t28[v266] = v267:jsonEncode()
		end

		t26.templates = t28
	end

	if p15.localized_literals ~= nil and next(p15.localized_literals) ~= nil then
		local t29 = {}

		for v269, v270 in p15.localized_literals do
			t29[v269] = v270
		end

		t26.localizedLiterals = t29
	end

	return t26
end
function t24.jsonDecode(t30: {[any]: any}) -- line: 1493
	-- upvalues: t24 (copy), page_entry_content (copy), hydration_content (copy), template_entry (copy)
	local v272 = t24.new()

	if t30.page_entries ~= nil then
		local t31 = {}

		for _, v275 in t30.page_entries do
			table.insert(t31, page_entry_content.UniversalPageEntry.jsonDecode(v275))
		end

		v272.page_entries = t31
	end

	if t30.pageEntries ~= nil then
		local t32 = {}

		for _, v278 in t30.pageEntries do
			table.insert(t32, page_entry_content.UniversalPageEntry.jsonDecode(v278))
		end

		v272.page_entries = t32
	end

	if t30.hydration_data ~= nil then
		v272.hydration_data = hydration_content.HydrationContent.jsonDecode(t30.hydration_data)
	end

	if t30.hydrationData ~= nil then
		v272.hydration_data = hydration_content.HydrationContent.jsonDecode(t30.hydrationData)
	end

	if t30.templates ~= nil then
		local t33 = {}

		for v280, v281 in t30.templates do
			t33[v280] = template_entry.TemplateEntry.jsonDecode(v281)
		end

		v272.templates = t33
	end

	if t30.localized_literals ~= nil then
		local t34 = {}

		for v283, v284 in t30.localized_literals do
			t34[v283] = v284
		end

		v272.localized_literals = t34
	end

	if t30.localizedLiterals ~= nil then
		local t35 = {}

		for v286, v287 in t30.localizedLiterals do
			t35[v286] = v287
		end

		v272.localized_literals = t35
	end

	return v272
end

t24.descriptor = {
	name = "GetChartsPageResponse",
	fullName = "roblox.apppageplatform.charts.v1beta1.GetChartsPageResponse"
}
t1.GetChartsPageResponse = t24
typeRegistry.default:register(t1.GetChartsPageResponse)

local t36 = {}

t36.__index = t36

function t36.new(t37: {[any]: any}?) -- line: 1576
	-- upvalues: t36 (copy)
	return (setmetatable({
		key = if t37 ~= nil and t37.key ~= nil then t37.key else "",
		value = if t37 ~= nil and t37.value ~= nil then t37.value else nil
	}, t36))
end
function t36.encode(p16) -- line: 1585
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n11 = 0

	if p16.key ~= nil and p16.key ~= "" then
		local v292, v293 = proto.writeTag(buf, n11, 1, proto.wireTypes.lengthDelimited)

		buf, n11 = proto.writeString(v292, v293, p16.key)
	end

	if p16.value ~= nil then
		local v294 = p16.value:encode()
		local v295, v296 = proto.writeTag(buf, n11, 2, proto.wireTypes.lengthDelimited)

		buf, n11 = proto.writeBuffer(v295, v296, v294, buffer.len(v294))
	end

	local buf11 = buffer.create(n11)

	buffer.copy(buf11, 0, buf, 0, n11)

	return buf11
end
function t36.decode(p17: buffer) -- line: 1605
	-- upvalues: t36 (copy), proto (copy), template_entry (copy)
	local v299 = t36.new()
	local n12 = 0

	while n12 < buffer.len(p17) do
		local v301, v302

		v301, v302, n12 = proto.readTag(p17, n12)

		if v302 == proto.wireTypes.varint then
			local v303

			v303, n12 = proto.readVarInt(p17, n12)
		elseif v302 == proto.wireTypes.lengthDelimited then
			if v301 == 1 then
				local v304

				v304, n12 = proto.readBuffer(p17, n12)
				v299.key = buffer.tostring(v304)
			elseif v301 == 2 then
				local v305

				v305, n12 = proto.readBuffer(p17, n12)
				v299.value = template_entry.TemplateEntry.decode(v305)
			else
				local v306, v307 = proto.readVarInt(p17, n12)

				n12 = v307 + v306
			end
		elseif v302 == proto.wireTypes.i32 then
			local v308

			v308, n12 = proto.readFixed32(p17, n12)
		elseif v302 == proto.wireTypes.i64 then
			local v309

			v309, n12 = proto.readFixed64(p17, n12)
		else
			error("Unsupported wire type: " .. v302)
		end
	end

	return v299
end
function t36.jsonEncode(p18) -- line: 1653
	local t38 = {}

	if p18.key ~= nil and p18.key ~= "" then
		t38.key = p18.key
	end

	if p18.value ~= nil then
		t38.value = p18.value:jsonEncode()
	end

	return t38
end
function t36.jsonDecode(t39: {[any]: any}) -- line: 1667
	-- upvalues: t36 (copy), template_entry (copy)
	local v313 = t36.new()

	if t39.key ~= nil then
		v313.key = t39.key
	end

	if t39.value ~= nil then
		v313.value = template_entry.TemplateEntry.jsonDecode(t39.value)
	end

	return v313
end

t36.descriptor = {
	name = "GetChartsPageResponse_TemplatesEntry",
	fullName = "roblox.apppageplatform.charts.v1beta1.TemplatesEntry"
}
t1.GetChartsPageResponse_TemplatesEntry = t36
typeRegistry.default:register(t1.GetChartsPageResponse_TemplatesEntry)

local t40 = {}

t40.__index = t40

function t40.new(t41: {[any]: any}?) -- line: 1697
	-- upvalues: t40 (copy)
	return (setmetatable({
		key = if t41 ~= nil and t41.key ~= nil then t41.key else "",
		value = if t41 ~= nil and t41.value ~= nil then t41.value else ""
	}, t40))
end
function t40.encode(p19) -- line: 1706
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n13 = 0

	if p19.key ~= nil and p19.key ~= "" then
		local v318, v319 = proto.writeTag(buf, n13, 1, proto.wireTypes.lengthDelimited)

		buf, n13 = proto.writeString(v318, v319, p19.key)
	end

	if p19.value ~= nil and p19.value ~= "" then
		local v320, v321 = proto.writeTag(buf, n13, 2, proto.wireTypes.lengthDelimited)

		buf, n13 = proto.writeString(v320, v321, p19.value)
	end

	local buf12 = buffer.create(n13)

	buffer.copy(buf12, 0, buf, 0, n13)

	return buf12
end
function t40.decode(p20: buffer) -- line: 1727
	-- upvalues: t40 (copy), proto (copy)
	local v324 = t40.new()
	local n14 = 0

	while n14 < buffer.len(p20) do
		local v326, v327

		v326, v327, n14 = proto.readTag(p20, n14)

		if v327 == proto.wireTypes.varint then
			local v328

			v328, n14 = proto.readVarInt(p20, n14)
		elseif v327 == proto.wireTypes.lengthDelimited then
			if v326 == 1 then
				local v329

				v329, n14 = proto.readBuffer(p20, n14)
				v324.key = buffer.tostring(v329)
			elseif v326 == 2 then
				local v330

				v330, n14 = proto.readBuffer(p20, n14)
				v324.value = buffer.tostring(v330)
			else
				local v331, v332 = proto.readVarInt(p20, n14)

				n14 = v332 + v331
			end
		elseif v327 == proto.wireTypes.i32 then
			local v333

			v333, n14 = proto.readFixed32(p20, n14)
		elseif v327 == proto.wireTypes.i64 then
			local v334

			v334, n14 = proto.readFixed64(p20, n14)
		else
			error("Unsupported wire type: " .. v327)
		end
	end

	return v324
end
function t40.jsonEncode(p21) -- line: 1777
	local t42 = {}

	if p21.key ~= nil and p21.key ~= "" then
		t42.key = p21.key
	end

	if p21.value ~= nil and p21.value ~= "" then
		t42.value = p21.value
	end

	return t42
end
function t40.jsonDecode(t43: {[any]: any}) -- line: 1793
	-- upvalues: t40 (copy)
	local v338 = t40.new()

	if t43.key ~= nil then
		v338.key = t43.key
	end

	if t43.value ~= nil then
		v338.value = t43.value
	end

	return v338
end

t40.descriptor = {
	name = "GetChartsPageResponse_LocalizedLiteralsEntry",
	fullName = "roblox.apppageplatform.charts.v1beta1.LocalizedLiteralsEntry"
}
t1.GetChartsPageResponse_LocalizedLiteralsEntry = t40
typeRegistry.default:register(t1.GetChartsPageResponse_LocalizedLiteralsEntry)

local t44 = {}

t44.__index = t44

function t44.new(t45: {[any]: any}?) -- line: 1823
	-- upvalues: t44 (copy)
	return (setmetatable({
		sort_id = if t45 ~= nil and t45.sort_id ~= nil then t45.sort_id else "",
		content_page_token = if t45 ~= nil and t45.content_page_token ~= nil then t45.content_page_token else "",
		device = if t45 ~= nil and t45.device ~= nil then t45.device else "",
		country = if t45 ~= nil and t45.country ~= nil then t45.country else "",
		session_id = if t45 ~= nil and t45.session_id ~= nil then t45.session_id else "",
		age_group = if t45 ~= nil and t45.age_group ~= nil then t45.age_group else "",
		max_memory = if t45 ~= nil and t45.max_memory ~= nil then t45.max_memory else ""
	}, t44))
end
function t44.encode(p22) -- line: 1837
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n15 = 0

	if p22.sort_id ~= nil and p22.sort_id ~= "" then
		local v343, v344 = proto.writeTag(buf, n15, 1, proto.wireTypes.lengthDelimited)

		buf, n15 = proto.writeString(v343, v344, p22.sort_id)
	end

	if p22.content_page_token ~= nil and p22.content_page_token ~= "" then
		local v345, v346 = proto.writeTag(buf, n15, 2, proto.wireTypes.lengthDelimited)

		buf, n15 = proto.writeString(v345, v346, p22.content_page_token)
	end

	if p22.device ~= nil and p22.device ~= "" then
		local v347, v348 = proto.writeTag(buf, n15, 3, proto.wireTypes.lengthDelimited)

		buf, n15 = proto.writeString(v347, v348, p22.device)
	end

	if p22.country ~= nil and p22.country ~= "" then
		local v349, v350 = proto.writeTag(buf, n15, 4, proto.wireTypes.lengthDelimited)

		buf, n15 = proto.writeString(v349, v350, p22.country)
	end

	if p22.session_id ~= nil and p22.session_id ~= "" then
		local v351, v352 = proto.writeTag(buf, n15, 5, proto.wireTypes.lengthDelimited)

		buf, n15 = proto.writeString(v351, v352, p22.session_id)
	end

	if p22.age_group ~= nil and p22.age_group ~= "" then
		local v353, v354 = proto.writeTag(buf, n15, 6, proto.wireTypes.lengthDelimited)

		buf, n15 = proto.writeString(v353, v354, p22.age_group)
	end

	if p22.max_memory ~= nil and p22.max_memory ~= "" then
		local v355, v356 = proto.writeTag(buf, n15, 7, proto.wireTypes.lengthDelimited)

		buf, n15 = proto.writeString(v355, v356, p22.max_memory)
	end

	local buf13 = buffer.create(n15)

	buffer.copy(buf13, 0, buf, 0, n15)

	return buf13
end
function t44.decode(p23: buffer) -- line: 1881
	-- upvalues: t44 (copy), proto (copy)
	local v359 = t44.new()
	local n16 = 0

	while n16 < buffer.len(p23) do
		local v361, v362

		v361, v362, n16 = proto.readTag(p23, n16)

		if v362 == proto.wireTypes.varint then
			local v363

			v363, n16 = proto.readVarInt(p23, n16)
		elseif v362 == proto.wireTypes.lengthDelimited then
			if v361 == 1 then
				local v364

				v364, n16 = proto.readBuffer(p23, n16)
				v359.sort_id = buffer.tostring(v364)
			elseif v361 == 2 then
				local v365

				v365, n16 = proto.readBuffer(p23, n16)
				v359.content_page_token = buffer.tostring(v365)
			elseif v361 == 3 then
				local v366

				v366, n16 = proto.readBuffer(p23, n16)
				v359.device = buffer.tostring(v366)
			elseif v361 == 4 then
				local v367

				v367, n16 = proto.readBuffer(p23, n16)
				v359.country = buffer.tostring(v367)
			elseif v361 == 5 then
				local v368

				v368, n16 = proto.readBuffer(p23, n16)
				v359.session_id = buffer.tostring(v368)
			elseif v361 == 6 then
				local v369

				v369, n16 = proto.readBuffer(p23, n16)
				v359.age_group = buffer.tostring(v369)
			elseif v361 == 7 then
				local v370

				v370, n16 = proto.readBuffer(p23, n16)
				v359.max_memory = buffer.tostring(v370)
			else
				local v371, v372 = proto.readVarInt(p23, n16)

				n16 = v372 + v371
			end
		elseif v362 == proto.wireTypes.i32 then
			local v373

			v373, n16 = proto.readFixed32(p23, n16)
		elseif v362 == proto.wireTypes.i64 then
			local v374

			v374, n16 = proto.readFixed64(p23, n16)
		else
			error("Unsupported wire type: " .. v362)
		end
	end

	return v359
end
function t44.jsonEncode(p24) -- line: 1954
	local t46 = {}

	if p24.sort_id ~= nil and p24.sort_id ~= "" then
		t46.sortId = p24.sort_id
	end

	if p24.content_page_token ~= nil and p24.content_page_token ~= "" then
		t46.contentPageToken = p24.content_page_token
	end

	if p24.device ~= nil and p24.device ~= "" then
		t46.device = p24.device
	end

	if p24.country ~= nil and p24.country ~= "" then
		t46.country = p24.country
	end

	if p24.session_id ~= nil and p24.session_id ~= "" then
		t46.sessionId = p24.session_id
	end

	if p24.age_group ~= nil and p24.age_group ~= "" then
		t46.ageGroup = p24.age_group
	end

	if p24.max_memory ~= nil and p24.max_memory ~= "" then
		t46.maxMemory = p24.max_memory
	end

	return t46
end
function t44.jsonDecode(t47: {[any]: any}) -- line: 1988
	-- upvalues: t44 (copy)
	local v378 = t44.new()

	if t47.sort_id ~= nil then
		v378.sort_id = t47.sort_id
	end

	if t47.sortId ~= nil then
		v378.sort_id = t47.sortId
	end

	if t47.content_page_token ~= nil then
		v378.content_page_token = t47.content_page_token
	end

	if t47.contentPageToken ~= nil then
		v378.content_page_token = t47.contentPageToken
	end

	if t47.device ~= nil then
		v378.device = t47.device
	end

	if t47.country ~= nil then
		v378.country = t47.country
	end

	if t47.session_id ~= nil then
		v378.session_id = t47.session_id
	end

	if t47.sessionId ~= nil then
		v378.session_id = t47.sessionId
	end

	if t47.age_group ~= nil then
		v378.age_group = t47.age_group
	end

	if t47.ageGroup ~= nil then
		v378.age_group = t47.ageGroup
	end

	if t47.max_memory ~= nil then
		v378.max_memory = t47.max_memory
	end

	if t47.maxMemory ~= nil then
		v378.max_memory = t47.maxMemory
	end

	return v378
end

t44.descriptor = {
	name = "GetChartsSortDetailRequest",
	fullName = "roblox.apppageplatform.charts.v1beta1.GetChartsSortDetailRequest"
}
t1.GetChartsSortDetailRequest = t44
typeRegistry.default:register(t1.GetChartsSortDetailRequest)

local t48 = {}

t48.__index = t48

function t48.new(t49: {[any]: any}?) -- line: 2056
	-- upvalues: t48 (copy)
	return (setmetatable({
		page_entries = if t49 ~= nil and t49.page_entries ~= nil then t49.page_entries else {},
		hydration_data = if t49 ~= nil and t49.hydration_data ~= nil then t49.hydration_data else nil,
		templates = if t49 ~= nil and t49.templates ~= nil then t49.templates else {},
		next_content_page_token = if t49 ~= nil and t49.next_content_page_token ~= nil then t49.next_content_page_token else "",
		localized_literals = if t49 ~= nil and t49.localized_literals ~= nil then t49.localized_literals else {}
	}, t48))
end
function t48.encode(p25) -- line: 2070
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n17 = 0

	if p25.page_entries ~= nil and #p25.page_entries > 0 then
		for _, v384 in p25.page_entries do
			local v385 = v384:encode()
			local v386, v387 = proto.writeTag(buf, n17, 1, proto.wireTypes.lengthDelimited)

			buf, n17 = proto.writeBuffer(v386, v387, v385, buffer.len(v385))
		end
	end

	if p25.hydration_data ~= nil then
		local v388 = p25.hydration_data:encode()
		local v389, v390 = proto.writeTag(buf, n17, 2, proto.wireTypes.lengthDelimited)

		buf, n17 = proto.writeBuffer(v389, v390, v388, buffer.len(v388))
	end

	if p25.templates ~= nil and next(p25.templates) ~= nil then
		for v391, v392 in p25.templates do
			local buf14 = buffer.create(0)
			local v394, v395 = proto.writeTag(buf14, 0, 1, proto.wireTypes.lengthDelimited)
			local v396, v397 = proto.writeString(v394, v395, v391)
			local v398 = v392:encode()
			local v399, v400 = proto.writeTag(v396, v397, 2, proto.wireTypes.lengthDelimited)
			local v401, v402 = proto.writeBuffer(v399, v400, v398, buffer.len(v398))
			local v403, v404 = proto.writeTag(buf, n17, 3, proto.wireTypes.lengthDelimited)

			buf, n17 = proto.writeBuffer(v403, v404, v401, v402)
		end
	end

	if p25.next_content_page_token ~= nil and p25.next_content_page_token ~= "" then
		local v405, v406 = proto.writeTag(buf, n17, 4, proto.wireTypes.lengthDelimited)

		buf, n17 = proto.writeString(v405, v406, p25.next_content_page_token)
	end

	if p25.localized_literals ~= nil and next(p25.localized_literals) ~= nil then
		for v407, v408 in p25.localized_literals do
			local buf15 = buffer.create(0)
			local v410, v411 = proto.writeTag(buf15, 0, 1, proto.wireTypes.lengthDelimited)
			local v412, v413 = proto.writeString(v410, v411, v407)
			local v414, v415 = proto.writeTag(v412, v413, 2, proto.wireTypes.lengthDelimited)
			local v416, v417 = proto.writeString(v414, v415, v408)
			local v418, v419 = proto.writeTag(buf, n17, 5, proto.wireTypes.lengthDelimited)

			buf, n17 = proto.writeBuffer(v418, v419, v416, v417)
		end
	end

	local buf16 = buffer.create(n17)

	buffer.copy(buf16, 0, buf, 0, n17)

	return buf16
end
function t48.decode(p26: buffer) -- line: 2125
	-- upvalues: t48 (copy), proto (copy), page_entry_content (copy), hydration_content (copy), t1 (copy), template_entry (copy)
	local v422 = t48.new()
	local n18 = 0

	while n18 < buffer.len(p26) do
		local v424, v425

		v424, v425, n18 = proto.readTag(p26, n18)

		if v425 == proto.wireTypes.varint then
			local v426

			v426, n18 = proto.readVarInt(p26, n18)
		elseif v425 == proto.wireTypes.lengthDelimited then
			if v424 == 1 then
				local v427

				v427, n18 = proto.readBuffer(p26, n18)
				table.insert(v422.page_entries, page_entry_content.UniversalPageEntry.decode(v427))
			elseif v424 == 2 then
				local v428

				v428, n18 = proto.readBuffer(p26, n18)
				v422.hydration_data = hydration_content.HydrationContent.decode(v428)
			elseif v424 == 3 then
				local v429

				v429, n18 = proto.readBuffer(p26, n18)

				local v430 = t1.GetChartsSortDetailResponse_TemplatesEntry.decode(v429)
				local v431 = template_entry.TemplateEntry.new()

				v422.templates[v430.key or ""] = v430.value or v431
			elseif v424 == 4 then
				local v432

				v432, n18 = proto.readBuffer(p26, n18)
				v422.next_content_page_token = buffer.tostring(v432)
			elseif v424 == 5 then
				local v433

				v433, n18 = proto.readBuffer(p26, n18)

				local v434 = t1.GetChartsSortDetailResponse_LocalizedLiteralsEntry.decode(v433)

				v422.localized_literals[v434.key or ""] = v434.value or ""
			else
				local v435, v436 = proto.readVarInt(p26, n18)

				n18 = v436 + v435
			end
		elseif v425 == proto.wireTypes.i32 then
			local v437

			v437, n18 = proto.readFixed32(p26, n18)
		elseif v425 == proto.wireTypes.i64 then
			local v438

			v438, n18 = proto.readFixed64(p26, n18)
		else
			error("Unsupported wire type: " .. v425)
		end
	end

	return v422
end
function t48.jsonEncode(p27) -- line: 2206
	local t50 = {}

	if p27.page_entries ~= nil and #p27.page_entries > 0 then
		local t51 = {}

		for _, v443 in p27.page_entries do
			table.insert(t51, v443:jsonEncode())
		end

		t50.pageEntries = t51
	end

	if p27.hydration_data ~= nil then
		t50.hydrationData = p27.hydration_data:jsonEncode()
	end

	if p27.templates ~= nil and next(p27.templates) ~= nil then
		local t52 = {}

		for v445, v446 in p27.templates do
			t52[v445] = v446:jsonEncode()
		end

		t50.templates = t52
	end

	if p27.next_content_page_token ~= nil and p27.next_content_page_token ~= "" then
		t50.nextContentPageToken = p27.next_content_page_token
	end

	if p27.localized_literals ~= nil and next(p27.localized_literals) ~= nil then
		local t53 = {}

		for v448, v449 in p27.localized_literals do
			t53[v448] = v449
		end

		t50.localizedLiterals = t53
	end

	return t50
end
function t48.jsonDecode(t54: {[any]: any}) -- line: 2244
	-- upvalues: t48 (copy), page_entry_content (copy), hydration_content (copy), template_entry (copy)
	local v451 = t48.new()

	if t54.page_entries ~= nil then
		local t55 = {}

		for _, v454 in t54.page_entries do
			table.insert(t55, page_entry_content.UniversalPageEntry.jsonDecode(v454))
		end

		v451.page_entries = t55
	end

	if t54.pageEntries ~= nil then
		local t56 = {}

		for _, v457 in t54.pageEntries do
			table.insert(t56, page_entry_content.UniversalPageEntry.jsonDecode(v457))
		end

		v451.page_entries = t56
	end

	if t54.hydration_data ~= nil then
		v451.hydration_data = hydration_content.HydrationContent.jsonDecode(t54.hydration_data)
	end

	if t54.hydrationData ~= nil then
		v451.hydration_data = hydration_content.HydrationContent.jsonDecode(t54.hydrationData)
	end

	if t54.templates ~= nil then
		local t57 = {}

		for v459, v460 in t54.templates do
			t57[v459] = template_entry.TemplateEntry.jsonDecode(v460)
		end

		v451.templates = t57
	end

	if t54.next_content_page_token ~= nil then
		v451.next_content_page_token = t54.next_content_page_token
	end

	if t54.nextContentPageToken ~= nil then
		v451.next_content_page_token = t54.nextContentPageToken
	end

	if t54.localized_literals ~= nil then
		local t58 = {}

		for v462, v463 in t54.localized_literals do
			t58[v462] = v463
		end

		v451.localized_literals = t58
	end

	if t54.localizedLiterals ~= nil then
		local t59 = {}

		for v465, v466 in t54.localizedLiterals do
			t59[v465] = v466
		end

		v451.localized_literals = t59
	end

	return v451
end

t48.descriptor = {
	name = "GetChartsSortDetailResponse",
	fullName = "roblox.apppageplatform.charts.v1beta1.GetChartsSortDetailResponse"
}
t1.GetChartsSortDetailResponse = t48
typeRegistry.default:register(t1.GetChartsSortDetailResponse)

local t60 = {}

t60.__index = t60

function t60.new(t61: {[any]: any}?) -- line: 2335
	-- upvalues: t60 (copy)
	return (setmetatable({
		key = if t61 ~= nil and t61.key ~= nil then t61.key else "",
		value = if t61 ~= nil and t61.value ~= nil then t61.value else nil
	}, t60))
end
function t60.encode(p28) -- line: 2344
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n19 = 0

	if p28.key ~= nil and p28.key ~= "" then
		local v471, v472 = proto.writeTag(buf, n19, 1, proto.wireTypes.lengthDelimited)

		buf, n19 = proto.writeString(v471, v472, p28.key)
	end

	if p28.value ~= nil then
		local v473 = p28.value:encode()
		local v474, v475 = proto.writeTag(buf, n19, 2, proto.wireTypes.lengthDelimited)

		buf, n19 = proto.writeBuffer(v474, v475, v473, buffer.len(v473))
	end

	local buf17 = buffer.create(n19)

	buffer.copy(buf17, 0, buf, 0, n19)

	return buf17
end
function t60.decode(p29: buffer) -- line: 2366
	-- upvalues: t60 (copy), proto (copy), template_entry (copy)
	local v478 = t60.new()
	local n20 = 0

	while n20 < buffer.len(p29) do
		local v480, v481

		v480, v481, n20 = proto.readTag(p29, n20)

		if v481 == proto.wireTypes.varint then
			local v482

			v482, n20 = proto.readVarInt(p29, n20)
		elseif v481 == proto.wireTypes.lengthDelimited then
			if v480 == 1 then
				local v483

				v483, n20 = proto.readBuffer(p29, n20)
				v478.key = buffer.tostring(v483)
			elseif v480 == 2 then
				local v484

				v484, n20 = proto.readBuffer(p29, n20)
				v478.value = template_entry.TemplateEntry.decode(v484)
			else
				local v485, v486 = proto.readVarInt(p29, n20)

				n20 = v486 + v485
			end
		elseif v481 == proto.wireTypes.i32 then
			local v487

			v487, n20 = proto.readFixed32(p29, n20)
		elseif v481 == proto.wireTypes.i64 then
			local v488

			v488, n20 = proto.readFixed64(p29, n20)
		else
			error("Unsupported wire type: " .. v481)
		end
	end

	return v478
end
function t60.jsonEncode(p30) -- line: 2416
	local t62 = {}

	if p30.key ~= nil and p30.key ~= "" then
		t62.key = p30.key
	end

	if p30.value ~= nil then
		t62.value = p30.value:jsonEncode()
	end

	return t62
end
function t60.jsonDecode(t63: {[any]: any}) -- line: 2432
	-- upvalues: t60 (copy), template_entry (copy)
	local v492 = t60.new()

	if t63.key ~= nil then
		v492.key = t63.key
	end

	if t63.value ~= nil then
		v492.value = template_entry.TemplateEntry.jsonDecode(t63.value)
	end

	return v492
end

t60.descriptor = {
	name = "GetChartsSortDetailResponse_TemplatesEntry",
	fullName = "roblox.apppageplatform.charts.v1beta1.TemplatesEntry"
}
t1.GetChartsSortDetailResponse_TemplatesEntry = t60
typeRegistry.default:register(t1.GetChartsSortDetailResponse_TemplatesEntry)

local t64 = {}

t64.__index = t64

function t64.new(t65: {[any]: any}?) -- line: 2463
	-- upvalues: t64 (copy)
	return (setmetatable({
		key = if t65 ~= nil and t65.key ~= nil then t65.key else "",
		value = if t65 ~= nil and t65.value ~= nil then t65.value else ""
	}, t64))
end
function t64.encode(p31) -- line: 2475
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n21 = 0

	if p31.key ~= nil and p31.key ~= "" then
		local v497, v498 = proto.writeTag(buf, n21, 1, proto.wireTypes.lengthDelimited)

		buf, n21 = proto.writeString(v497, v498, p31.key)
	end

	if p31.value ~= nil and p31.value ~= "" then
		local v499, v500 = proto.writeTag(buf, n21, 2, proto.wireTypes.lengthDelimited)

		buf, n21 = proto.writeString(v499, v500, p31.value)
	end

	local buf18 = buffer.create(n21)

	buffer.copy(buf18, 0, buf, 0, n21)

	return buf18
end
function t64.decode(p32: buffer) -- line: 2496
	-- upvalues: t64 (copy), proto (copy)
	local v503 = t64.new()
	local n22 = 0

	while n22 < buffer.len(p32) do
		local v505, v506

		v505, v506, n22 = proto.readTag(p32, n22)

		if v506 == proto.wireTypes.varint then
			local v507

			v507, n22 = proto.readVarInt(p32, n22)
		elseif v506 == proto.wireTypes.lengthDelimited then
			if v505 == 1 then
				local v508

				v508, n22 = proto.readBuffer(p32, n22)
				v503.key = buffer.tostring(v508)
			elseif v505 == 2 then
				local v509

				v509, n22 = proto.readBuffer(p32, n22)
				v503.value = buffer.tostring(v509)
			else
				local v510, v511 = proto.readVarInt(p32, n22)

				n22 = v511 + v510
			end
		elseif v506 == proto.wireTypes.i32 then
			local v512

			v512, n22 = proto.readFixed32(p32, n22)
		elseif v506 == proto.wireTypes.i64 then
			local v513

			v513, n22 = proto.readFixed64(p32, n22)
		else
			error("Unsupported wire type: " .. v506)
		end
	end

	return v503
end
function t64.jsonEncode(p33) -- line: 2546
	local t66 = {}

	if p33.key ~= nil and p33.key ~= "" then
		t66.key = p33.key
	end

	if p33.value ~= nil and p33.value ~= "" then
		t66.value = p33.value
	end

	return t66
end
function t64.jsonDecode(t67: {[any]: any}) -- line: 2562
	-- upvalues: t64 (copy)
	local v517 = t64.new()

	if t67.key ~= nil then
		v517.key = t67.key
	end

	if t67.value ~= nil then
		v517.value = t67.value
	end

	return v517
end

t64.descriptor = {
	name = "GetChartsSortDetailResponse_LocalizedLiteralsEntry",
	fullName = "roblox.apppageplatform.charts.v1beta1.LocalizedLiteralsEntry"
}
t1.GetChartsSortDetailResponse_LocalizedLiteralsEntry = t64
typeRegistry.default:register(t1.GetChartsSortDetailResponse_LocalizedLiteralsEntry)

return {
	GetChartsPageRequest = t1.GetChartsPageRequest,
	CollectionLayoutInfo = t1.CollectionLayoutInfo,
	GetChartsPageResponse = t1.GetChartsPageResponse,
	GetChartsSortDetailRequest = t1.GetChartsSortDetailRequest,
	GetChartsSortDetailResponse = t1.GetChartsSortDetailResponse
}
