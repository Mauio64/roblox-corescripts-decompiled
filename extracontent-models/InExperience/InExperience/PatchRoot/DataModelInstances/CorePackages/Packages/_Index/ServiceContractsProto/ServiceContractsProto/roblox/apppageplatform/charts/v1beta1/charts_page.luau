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

function t2.new(t3: {[any]: any}?) -- line: 442
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
function t2.encode(p1) -- line: 478
	-- upvalues: proto (copy), hydration_stream_mode (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.feed_page_token ~= nil and p1.feed_page_token ~= "" then
		local v25, v26 = proto.writeTag(buf, n1, 1, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v25, v26, p1.feed_page_token)
	end

	if p1.device ~= nil and p1.device ~= "" then
		local v27, v28 = proto.writeTag(buf, n1, 2, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v27, v28, p1.device)
	end

	if p1.country ~= nil and p1.country ~= "" then
		local v29, v30 = proto.writeTag(buf, n1, 3, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v29, v30, p1.country)
	end

	if p1.age_group ~= nil and p1.age_group ~= "" then
		local v31, v32 = proto.writeTag(buf, n1, 4, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v31, v32, p1.age_group)
	end

	if p1.session_id ~= nil and p1.session_id ~= "" then
		local v33, v34 = proto.writeTag(buf, n1, 5, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v33, v34, p1.session_id)
	end

	if p1.entry_pagination_key ~= nil and p1.entry_pagination_key ~= "" then
		local v35, v36 = proto.writeTag(buf, n1, 6, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v35, v36, p1.entry_pagination_key)
	end

	if p1.entry_page_token ~= nil and p1.entry_page_token ~= "" then
		local v37, v38 = proto.writeTag(buf, n1, 7, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v37, v38, p1.entry_page_token)
	end

	if p1.max_memory ~= nil and p1.max_memory ~= "" then
		local v39, v40 = proto.writeTag(buf, n1, 8, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v39, v40, p1.max_memory)
	end

	if p1.page_type ~= nil and p1.page_type ~= "" then
		local v41, v42 = proto.writeTag(buf, n1, 9, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v41, v42, p1.page_type)
	end

	if p1.include_placeholders ~= nil then
		local v43, v44 = proto.writeTag(buf, n1, 10, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v43, v44, not p1.include_placeholders and 0 or 1)
	end

	if p1.hydration_stream_enabled ~= nil then
		local v45, v46 = proto.writeTag(buf, n1, 11, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v45, v46, not p1.hydration_stream_enabled and 0 or 1)
	end

	if p1.hydration_stream_mode ~= nil and (p1.hydration_stream_mode ~= nil and p1.hydration_stream_mode ~= 0 or p1.hydration_stream_mode ~= hydration_stream_mode.HydrationStreamMode.fromNumber(0)) then
		local v47, v48 = proto.writeTag(buf, n1, 12, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v47, v48, hydration_stream_mode.HydrationStreamMode.toNumber(p1.hydration_stream_mode))
	end

	if p1.collection_layout ~= nil then
		local v49 = p1.collection_layout:encode()
		local v50, v51 = proto.writeTag(buf, n1, 13, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeBuffer(v50, v51, v49, buffer.len(v49))
	end

	if p1.cached_roblox_component_to_template_id ~= nil and next(p1.cached_roblox_component_to_template_id) ~= nil then
		for v52, v53 in p1.cached_roblox_component_to_template_id do
			local buf2 = buffer.create(0)
			local v55, v56 = proto.writeTag(buf2, 0, 1, proto.wireTypes.lengthDelimited)
			local v57, v58 = proto.writeString(v55, v56, v52)
			local v59, v60 = proto.writeTag(v57, v58, 2, proto.wireTypes.lengthDelimited)
			local v61, v62 = proto.writeString(v59, v60, v53)
			local v63, v64 = proto.writeTag(buf, n1, 14, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v63, v64, v61, v62)
		end
	end

	if p1.client_capabilities ~= nil then
		local v65 = p1.client_capabilities:encode()
		local v66, v67 = proto.writeTag(buf, n1, 15, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeBuffer(v66, v67, v65, buffer.len(v65))
	end

	local buf3 = buffer.create(n1)

	buffer.copy(buf3, 0, buf, 0, n1)

	return buf3
end
function t2.decode(p2: buffer) -- line: 588
	-- upvalues: t2 (copy), proto (copy), hydration_stream_mode (copy), t1 (copy), client_capabilities (copy)
	local v70 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v72, v73

		v72, v73, n2 = proto.readTag(p2, n2)

		if v73 == proto.wireTypes.varint then
			if v72 == 10 then
				local v74

				v74, n2 = proto.readVarInt(p2, n2)
				v70.include_placeholders = v74 ~= 0
			elseif v72 == 11 then
				local v75

				v75, n2 = proto.readVarInt(p2, n2)
				v70.hydration_stream_enabled = v75 ~= 0
			elseif v72 == 12 then
				local v76

				v76, n2 = proto.readVarIntI32(p2, n2)
				v70.hydration_stream_mode = hydration_stream_mode.HydrationStreamMode.fromNumber(v76) or v76
			else
				local v77

				v77, n2 = proto.readVarInt(p2, n2)
			end
		elseif v73 == proto.wireTypes.lengthDelimited then
			if v72 == 1 then
				local v78

				v78, n2 = proto.readBuffer(p2, n2)
				v70.feed_page_token = buffer.tostring(v78)
			elseif v72 == 2 then
				local v79

				v79, n2 = proto.readBuffer(p2, n2)
				v70.device = buffer.tostring(v79)
			elseif v72 == 3 then
				local v80

				v80, n2 = proto.readBuffer(p2, n2)
				v70.country = buffer.tostring(v80)
			elseif v72 == 4 then
				local v81

				v81, n2 = proto.readBuffer(p2, n2)
				v70.age_group = buffer.tostring(v81)
			elseif v72 == 5 then
				local v82

				v82, n2 = proto.readBuffer(p2, n2)
				v70.session_id = buffer.tostring(v82)
			elseif v72 == 6 then
				local v83

				v83, n2 = proto.readBuffer(p2, n2)
				v70.entry_pagination_key = buffer.tostring(v83)
			elseif v72 == 7 then
				local v84

				v84, n2 = proto.readBuffer(p2, n2)
				v70.entry_page_token = buffer.tostring(v84)
			elseif v72 == 8 then
				local v85

				v85, n2 = proto.readBuffer(p2, n2)
				v70.max_memory = buffer.tostring(v85)
			elseif v72 == 9 then
				local v86

				v86, n2 = proto.readBuffer(p2, n2)
				v70.page_type = buffer.tostring(v86)
			elseif v72 == 13 then
				local v87

				v87, n2 = proto.readBuffer(p2, n2)
				v70.collection_layout = t1.CollectionLayoutInfo.decode(v87)
			elseif v72 == 14 then
				local v88

				v88, n2 = proto.readBuffer(p2, n2)

				local v89 = t1.GetChartsPageRequest_CachedRobloxComponentToTemplateIdEntry.decode(v88)

				v70.cached_roblox_component_to_template_id[v89.key or ""] = v89.value or ""
			elseif v72 == 15 then
				local v90

				v90, n2 = proto.readBuffer(p2, n2)
				v70.client_capabilities = client_capabilities.ClientCapabilities.decode(v90)
			else
				local v91, v92 = proto.readVarInt(p2, n2)

				n2 = v92 + v91
			end
		elseif v73 == proto.wireTypes.i32 then
			local v93

			v93, n2 = proto.readFixed32(p2, n2)
		elseif v73 == proto.wireTypes.i64 then
			local v94

			v94, n2 = proto.readFixed64(p2, n2)
		else
			error("Unsupported wire type: " .. v73)
		end
	end

	return v70
end
function t2.jsonEncode(p3) -- line: 714
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

		for v98, v99 in p3.cached_roblox_component_to_template_id do
			t5[v98] = v99
		end

		t4.cachedRobloxComponentToTemplateId = t5
	end

	if p3.client_capabilities ~= nil then
		t4.clientCapabilities = p3.client_capabilities:jsonEncode()
	end

	return t4
end
function t2.jsonDecode(t6: {[any]: any}) -- line: 798
	-- upvalues: t2 (copy), hydration_stream_mode (copy), t1 (copy), client_capabilities (copy)
	local v101 = t2.new()

	if t6.feed_page_token ~= nil then
		v101.feed_page_token = t6.feed_page_token
	end

	if t6.feedPageToken ~= nil then
		v101.feed_page_token = t6.feedPageToken
	end

	if t6.device ~= nil then
		v101.device = t6.device
	end

	if t6.country ~= nil then
		v101.country = t6.country
	end

	if t6.age_group ~= nil then
		v101.age_group = t6.age_group
	end

	if t6.ageGroup ~= nil then
		v101.age_group = t6.ageGroup
	end

	if t6.session_id ~= nil then
		v101.session_id = t6.session_id
	end

	if t6.sessionId ~= nil then
		v101.session_id = t6.sessionId
	end

	if t6.entry_pagination_key ~= nil then
		v101.entry_pagination_key = t6.entry_pagination_key
	end

	if t6.entryPaginationKey ~= nil then
		v101.entry_pagination_key = t6.entryPaginationKey
	end

	if t6.entry_page_token ~= nil then
		v101.entry_page_token = t6.entry_page_token
	end

	if t6.entryPageToken ~= nil then
		v101.entry_page_token = t6.entryPageToken
	end

	if t6.max_memory ~= nil then
		v101.max_memory = t6.max_memory
	end

	if t6.maxMemory ~= nil then
		v101.max_memory = t6.maxMemory
	end

	if t6.page_type ~= nil then
		v101.page_type = t6.page_type
	end

	if t6.pageType ~= nil then
		v101.page_type = t6.pageType
	end

	if t6.include_placeholders ~= nil then
		v101.include_placeholders = t6.include_placeholders
	end

	if t6.includePlaceholders ~= nil then
		v101.include_placeholders = t6.includePlaceholders
	end

	if t6.hydration_stream_enabled ~= nil then
		v101.hydration_stream_enabled = t6.hydration_stream_enabled
	end

	if t6.hydrationStreamEnabled ~= nil then
		v101.hydration_stream_enabled = t6.hydrationStreamEnabled
	end

	if t6.hydration_stream_mode ~= nil then
		v101.hydration_stream_mode = if typeof(t6.hydration_stream_mode) ~= "number" then hydration_stream_mode.HydrationStreamMode.fromName(t6.hydration_stream_mode) or t6.hydration_stream_mode else hydration_stream_mode.HydrationStreamMode.fromNumber(t6.hydration_stream_mode) or t6.hydration_stream_mode
	end

	if t6.hydrationStreamMode ~= nil then
		v101.hydration_stream_mode = if typeof(t6.hydrationStreamMode) ~= "number" then hydration_stream_mode.HydrationStreamMode.fromName(t6.hydrationStreamMode) or t6.hydrationStreamMode else hydration_stream_mode.HydrationStreamMode.fromNumber(t6.hydrationStreamMode) or t6.hydrationStreamMode
	end

	if t6.collection_layout ~= nil then
		v101.collection_layout = t1.CollectionLayoutInfo.jsonDecode(t6.collection_layout)
	end

	if t6.collectionLayout ~= nil then
		v101.collection_layout = t1.CollectionLayoutInfo.jsonDecode(t6.collectionLayout)
	end

	if t6.cached_roblox_component_to_template_id ~= nil then
		local t7 = {}

		for v103, v104 in t6.cached_roblox_component_to_template_id do
			t7[v103] = v104
		end

		v101.cached_roblox_component_to_template_id = t7
	end

	if t6.cachedRobloxComponentToTemplateId ~= nil then
		local t8 = {}

		for v106, v107 in t6.cachedRobloxComponentToTemplateId do
			t8[v106] = v107
		end

		v101.cached_roblox_component_to_template_id = t8
	end

	if t6.client_capabilities ~= nil then
		v101.client_capabilities = client_capabilities.ClientCapabilities.jsonDecode(t6.client_capabilities)
	end

	if t6.clientCapabilities ~= nil then
		v101.client_capabilities = client_capabilities.ClientCapabilities.jsonDecode(t6.clientCapabilities)
	end

	return v101
end

t2.descriptor = {
	name = "GetChartsPageRequest",
	fullName = "roblox.apppageplatform.charts.v1beta1.GetChartsPageRequest"
}
t1.GetChartsPageRequest = t2
typeRegistry.default:register(t1.GetChartsPageRequest)

local t9 = {}

t9.__index = t9

function t9.new(t10: {[any]: any}?) -- line: 959
	-- upvalues: t9 (copy)
	return (setmetatable({
		key = if t10 ~= nil and t10.key ~= nil then t10.key else "",
		value = if t10 ~= nil and t10.value ~= nil then t10.value else ""
	}, t9))
end
function t9.encode(p4) -- line: 971
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n3 = 0

	if p4.key ~= nil and p4.key ~= "" then
		local v112, v113 = proto.writeTag(buf, n3, 1, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeString(v112, v113, p4.key)
	end

	if p4.value ~= nil and p4.value ~= "" then
		local v114, v115 = proto.writeTag(buf, n3, 2, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeString(v114, v115, p4.value)
	end

	local buf4 = buffer.create(n3)

	buffer.copy(buf4, 0, buf, 0, n3)

	return buf4
end
function t9.decode(p5: buffer) -- line: 992
	-- upvalues: t9 (copy), proto (copy)
	local v118 = t9.new()
	local n4 = 0

	while n4 < buffer.len(p5) do
		local v120, v121

		v120, v121, n4 = proto.readTag(p5, n4)

		if v121 == proto.wireTypes.varint then
			local v122

			v122, n4 = proto.readVarInt(p5, n4)
		elseif v121 == proto.wireTypes.lengthDelimited then
			if v120 == 1 then
				local v123

				v123, n4 = proto.readBuffer(p5, n4)
				v118.key = buffer.tostring(v123)
			elseif v120 == 2 then
				local v124

				v124, n4 = proto.readBuffer(p5, n4)
				v118.value = buffer.tostring(v124)
			else
				local v125, v126 = proto.readVarInt(p5, n4)

				n4 = v126 + v125
			end
		elseif v121 == proto.wireTypes.i32 then
			local v127

			v127, n4 = proto.readFixed32(p5, n4)
		elseif v121 == proto.wireTypes.i64 then
			local v128

			v128, n4 = proto.readFixed64(p5, n4)
		else
			error("Unsupported wire type: " .. v121)
		end
	end

	return v118
end
function t9.jsonEncode(p6) -- line: 1042
	local t11 = {}

	if p6.key ~= nil and p6.key ~= "" then
		t11.key = p6.key
	end

	if p6.value ~= nil and p6.value ~= "" then
		t11.value = p6.value
	end

	return t11
end
function t9.jsonDecode(t12: {[any]: any}) -- line: 1058
	-- upvalues: t9 (copy)
	local v132 = t9.new()

	if t12.key ~= nil then
		v132.key = t12.key
	end

	if t12.value ~= nil then
		v132.value = t12.value
	end

	return v132
end

t9.descriptor = {
	name = "GetChartsPageRequest_CachedRobloxComponentToTemplateIdEntry",
	fullName = "roblox.apppageplatform.charts.v1beta1.CachedRobloxComponentToTemplateIdEntry"
}
t1.GetChartsPageRequest_CachedRobloxComponentToTemplateIdEntry = t9
typeRegistry.default:register(t1.GetChartsPageRequest_CachedRobloxComponentToTemplateIdEntry)

local t13 = {}

t13.__index = t13

function t13.new(t14: {[any]: any}?) -- line: 1089
	-- upvalues: t13 (copy)
	return (setmetatable({
		items_per_row = if t14 ~= nil and t14.items_per_row ~= nil then t14.items_per_row else {},
		rows_above_fold = if t14 ~= nil and t14.rows_above_fold ~= nil then t14.rows_above_fold else 0
	}, t13))
end
function t13.encode(p7) -- line: 1096
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n5 = 0

	if p7.items_per_row ~= nil and next(p7.items_per_row) ~= nil then
		for v137, v138 in p7.items_per_row do
			local buf5 = buffer.create(0)
			local v140, v141 = proto.writeTag(buf5, 0, 1, proto.wireTypes.lengthDelimited)
			local v142, v143 = proto.writeString(v140, v141, v137)
			local v144, v145 = proto.writeTag(v142, v143, 2, proto.wireTypes.varint)
			local v146, v147 = proto.writeVarInt(v144, v145, v138)
			local v148, v149 = proto.writeTag(buf, n5, 1, proto.wireTypes.lengthDelimited)

			buf, n5 = proto.writeBuffer(v148, v149, v146, v147)
		end
	end

	if p7.rows_above_fold ~= nil and p7.rows_above_fold ~= 0 then
		local v150, v151 = proto.writeTag(buf, n5, 2, proto.wireTypes.varint)

		buf, n5 = proto.writeVarInt(v150, v151, p7.rows_above_fold)
	end

	local buf6 = buffer.create(n5)

	buffer.copy(buf6, 0, buf, 0, n5)

	return buf6
end
function t13.decode(p8: buffer) -- line: 1123
	-- upvalues: t13 (copy), proto (copy), t1 (copy)
	local v154 = t13.new()
	local n6 = 0

	while n6 < buffer.len(p8) do
		local v156, v157

		v156, v157, n6 = proto.readTag(p8, n6)

		if v157 == proto.wireTypes.varint then
			if v156 == 2 then
				local v158

				v158, n6 = proto.readVarIntI32(p8, n6)
				v154.rows_above_fold = v158
			else
				local v159

				v159, n6 = proto.readVarInt(p8, n6)
			end
		elseif v157 == proto.wireTypes.lengthDelimited then
			if v156 == 1 then
				local v160

				v160, n6 = proto.readBuffer(p8, n6)

				local v161 = t1.CollectionLayoutInfo_ItemsPerRowEntry.decode(v160)

				v154.items_per_row[v161.key or ""] = v161.value or 0
			else
				local v162, v163 = proto.readVarInt(p8, n6)

				n6 = v163 + v162
			end
		elseif v157 == proto.wireTypes.i32 then
			local v164

			v164, n6 = proto.readFixed32(p8, n6)
		elseif v157 == proto.wireTypes.i64 then
			local v165

			v165, n6 = proto.readFixed64(p8, n6)
		else
			error("Unsupported wire type: " .. v157)
		end
	end

	return v154
end
function t13.jsonEncode(p9) -- line: 1178
	local t15 = {}

	if p9.items_per_row ~= nil and next(p9.items_per_row) ~= nil then
		local t16 = {}

		for v169, v170 in p9.items_per_row do
			t16[v169] = v170
		end

		t15.itemsPerRow = t16
	end

	if p9.rows_above_fold ~= nil and p9.rows_above_fold ~= 0 then
		t15.rowsAboveFold = p9.rows_above_fold
	end

	return t15
end
function t13.jsonDecode(t17: {[any]: any}) -- line: 1196
	-- upvalues: t13 (copy)
	local v172 = t13.new()

	if t17.items_per_row ~= nil then
		local t18 = {}

		for v174, v175 in t17.items_per_row do
			t18[v174] = v175
		end

		v172.items_per_row = t18
	end

	if t17.itemsPerRow ~= nil then
		local t19 = {}

		for v177, v178 in t17.itemsPerRow do
			t19[v177] = v178
		end

		v172.items_per_row = t19
	end

	if t17.rows_above_fold ~= nil then
		v172.rows_above_fold = t17.rows_above_fold
	end

	if t17.rowsAboveFold ~= nil then
		v172.rows_above_fold = t17.rowsAboveFold
	end

	return v172
end

t13.descriptor = {
	name = "CollectionLayoutInfo",
	fullName = "roblox.apppageplatform.charts.v1beta1.CollectionLayoutInfo"
}
t1.CollectionLayoutInfo = t13
typeRegistry.default:register(t1.CollectionLayoutInfo)

local t20 = {}

t20.__index = t20

function t20.new(t21: {[any]: any}?) -- line: 1242
	-- upvalues: t20 (copy)
	return (setmetatable({
		key = if t21 ~= nil and t21.key ~= nil then t21.key else "",
		value = if t21 ~= nil and t21.value ~= nil then t21.value else 0
	}, t20))
end
function t20.encode(p10) -- line: 1251
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n7 = 0

	if p10.key ~= nil and p10.key ~= "" then
		local v183, v184 = proto.writeTag(buf, n7, 1, proto.wireTypes.lengthDelimited)

		buf, n7 = proto.writeString(v183, v184, p10.key)
	end

	if p10.value ~= nil and p10.value ~= 0 then
		local v185, v186 = proto.writeTag(buf, n7, 2, proto.wireTypes.varint)

		buf, n7 = proto.writeVarInt(v185, v186, p10.value)
	end

	local buf7 = buffer.create(n7)

	buffer.copy(buf7, 0, buf, 0, n7)

	return buf7
end
function t20.decode(p11: buffer) -- line: 1270
	-- upvalues: t20 (copy), proto (copy)
	local v189 = t20.new()
	local n8 = 0

	while n8 < buffer.len(p11) do
		local v191, v192

		v191, v192, n8 = proto.readTag(p11, n8)

		if v192 == proto.wireTypes.varint then
			if v191 == 2 then
				local v193

				v193, n8 = proto.readVarIntI32(p11, n8)
				v189.value = v193
			else
				local v194

				v194, n8 = proto.readVarInt(p11, n8)
			end
		elseif v192 == proto.wireTypes.lengthDelimited then
			if v191 == 1 then
				local v195

				v195, n8 = proto.readBuffer(p11, n8)
				v189.key = buffer.tostring(v195)
			else
				local v196, v197 = proto.readVarInt(p11, n8)

				n8 = v197 + v196
			end
		elseif v192 == proto.wireTypes.i32 then
			local v198

			v198, n8 = proto.readFixed32(p11, n8)
		elseif v192 == proto.wireTypes.i64 then
			local v199

			v199, n8 = proto.readFixed64(p11, n8)
		else
			error("Unsupported wire type: " .. v192)
		end
	end

	return v189
end
function t20.jsonEncode(p12) -- line: 1318
	local t22 = {}

	if p12.key ~= nil and p12.key ~= "" then
		t22.key = p12.key
	end

	if p12.value ~= nil and p12.value ~= 0 then
		t22.value = p12.value
	end

	return t22
end
function t20.jsonDecode(t23: {[any]: any}) -- line: 1332
	-- upvalues: t20 (copy)
	local v203 = t20.new()

	if t23.key ~= nil then
		v203.key = t23.key
	end

	if t23.value ~= nil then
		v203.value = t23.value
	end

	return v203
end

t20.descriptor = {
	name = "CollectionLayoutInfo_ItemsPerRowEntry",
	fullName = "roblox.apppageplatform.charts.v1beta1.ItemsPerRowEntry"
}
t1.CollectionLayoutInfo_ItemsPerRowEntry = t20
typeRegistry.default:register(t1.CollectionLayoutInfo_ItemsPerRowEntry)

local t24 = {}

t24.__index = t24

function t24.new(t25: {[any]: any}?) -- line: 1362
	-- upvalues: t24 (copy)
	return (setmetatable({
		page_entries = if t25 ~= nil and t25.page_entries ~= nil then t25.page_entries else {},
		hydration_data = if t25 ~= nil and t25.hydration_data ~= nil then t25.hydration_data else nil,
		templates = if t25 ~= nil and t25.templates ~= nil then t25.templates else {},
		localized_literals = if t25 ~= nil and t25.localized_literals ~= nil then t25.localized_literals else {}
	}, t24))
end
function t24.encode(p13) -- line: 1371
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n9 = 0

	if p13.page_entries ~= nil and #p13.page_entries > 0 then
		for _, v209 in p13.page_entries do
			local v210 = v209:encode()
			local v211, v212 = proto.writeTag(buf, n9, 1, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v211, v212, v210, buffer.len(v210))
		end
	end

	if p13.hydration_data ~= nil then
		local v213 = p13.hydration_data:encode()
		local v214, v215 = proto.writeTag(buf, n9, 2, proto.wireTypes.lengthDelimited)

		buf, n9 = proto.writeBuffer(v214, v215, v213, buffer.len(v213))
	end

	if p13.templates ~= nil and next(p13.templates) ~= nil then
		for v216, v217 in p13.templates do
			local buf8 = buffer.create(0)
			local v219, v220 = proto.writeTag(buf8, 0, 1, proto.wireTypes.lengthDelimited)
			local v221, v222 = proto.writeString(v219, v220, v216)
			local v223 = v217:encode()
			local v224, v225 = proto.writeTag(v221, v222, 2, proto.wireTypes.lengthDelimited)
			local v226, v227 = proto.writeBuffer(v224, v225, v223, buffer.len(v223))
			local v228, v229 = proto.writeTag(buf, n9, 3, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v228, v229, v226, v227)
		end
	end

	if p13.localized_literals ~= nil and next(p13.localized_literals) ~= nil then
		for v230, v231 in p13.localized_literals do
			local buf9 = buffer.create(0)
			local v233, v234 = proto.writeTag(buf9, 0, 1, proto.wireTypes.lengthDelimited)
			local v235, v236 = proto.writeString(v233, v234, v230)
			local v237, v238 = proto.writeTag(v235, v236, 2, proto.wireTypes.lengthDelimited)
			local v239, v240 = proto.writeString(v237, v238, v231)
			local v241, v242 = proto.writeTag(buf, n9, 4, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v241, v242, v239, v240)
		end
	end

	local buf10 = buffer.create(n9)

	buffer.copy(buf10, 0, buf, 0, n9)

	return buf10
end
function t24.decode(p14: buffer) -- line: 1421
	-- upvalues: t24 (copy), proto (copy), page_entry_content (copy), hydration_content (copy), t1 (copy), template_entry (copy)
	local v245 = t24.new()
	local n10 = 0

	while n10 < buffer.len(p14) do
		local v247, v248

		v247, v248, n10 = proto.readTag(p14, n10)

		if v248 == proto.wireTypes.varint then
			local v249

			v249, n10 = proto.readVarInt(p14, n10)
		elseif v248 == proto.wireTypes.lengthDelimited then
			if v247 == 1 then
				local v250

				v250, n10 = proto.readBuffer(p14, n10)
				table.insert(v245.page_entries, page_entry_content.UniversalPageEntry.decode(v250))
			elseif v247 == 2 then
				local v251

				v251, n10 = proto.readBuffer(p14, n10)
				v245.hydration_data = hydration_content.HydrationContent.decode(v251)
			elseif v247 == 3 then
				local v252

				v252, n10 = proto.readBuffer(p14, n10)

				local v253 = t1.GetChartsPageResponse_TemplatesEntry.decode(v252)
				local v254 = template_entry.TemplateEntry.new()

				v245.templates[v253.key or ""] = v253.value or v254
			elseif v247 == 4 then
				local v255

				v255, n10 = proto.readBuffer(p14, n10)

				local v256 = t1.GetChartsPageResponse_LocalizedLiteralsEntry.decode(v255)

				v245.localized_literals[v256.key or ""] = v256.value or ""
			else
				local v257, v258 = proto.readVarInt(p14, n10)

				n10 = v258 + v257
			end
		elseif v248 == proto.wireTypes.i32 then
			local v259

			v259, n10 = proto.readFixed32(p14, n10)
		elseif v248 == proto.wireTypes.i64 then
			local v260

			v260, n10 = proto.readFixed64(p14, n10)
		else
			error("Unsupported wire type: " .. v248)
		end
	end

	return v245
end
function t24.jsonEncode(p15) -- line: 1497
	local t26 = {}

	if p15.page_entries ~= nil and #p15.page_entries > 0 then
		local t27 = {}

		for _, v265 in p15.page_entries do
			table.insert(t27, v265:jsonEncode())
		end

		t26.pageEntries = t27
	end

	if p15.hydration_data ~= nil then
		t26.hydrationData = p15.hydration_data:jsonEncode()
	end

	if p15.templates ~= nil and next(p15.templates) ~= nil then
		local t28 = {}

		for v267, v268 in p15.templates do
			t28[v267] = v268:jsonEncode()
		end

		t26.templates = t28
	end

	if p15.localized_literals ~= nil and next(p15.localized_literals) ~= nil then
		local t29 = {}

		for v270, v271 in p15.localized_literals do
			t29[v270] = v271
		end

		t26.localizedLiterals = t29
	end

	return t26
end
function t24.jsonDecode(t30: {[any]: any}) -- line: 1531
	-- upvalues: t24 (copy), page_entry_content (copy), hydration_content (copy), template_entry (copy)
	local v273 = t24.new()

	if t30.page_entries ~= nil then
		local t31 = {}

		for _, v276 in t30.page_entries do
			table.insert(t31, page_entry_content.UniversalPageEntry.jsonDecode(v276))
		end

		v273.page_entries = t31
	end

	if t30.pageEntries ~= nil then
		local t32 = {}

		for _, v279 in t30.pageEntries do
			table.insert(t32, page_entry_content.UniversalPageEntry.jsonDecode(v279))
		end

		v273.page_entries = t32
	end

	if t30.hydration_data ~= nil then
		v273.hydration_data = hydration_content.HydrationContent.jsonDecode(t30.hydration_data)
	end

	if t30.hydrationData ~= nil then
		v273.hydration_data = hydration_content.HydrationContent.jsonDecode(t30.hydrationData)
	end

	if t30.templates ~= nil then
		local t33 = {}

		for v281, v282 in t30.templates do
			t33[v281] = template_entry.TemplateEntry.jsonDecode(v282)
		end

		v273.templates = t33
	end

	if t30.localized_literals ~= nil then
		local t34 = {}

		for v284, v285 in t30.localized_literals do
			t34[v284] = v285
		end

		v273.localized_literals = t34
	end

	if t30.localizedLiterals ~= nil then
		local t35 = {}

		for v287, v288 in t30.localizedLiterals do
			t35[v287] = v288
		end

		v273.localized_literals = t35
	end

	return v273
end

t24.descriptor = {
	name = "GetChartsPageResponse",
	fullName = "roblox.apppageplatform.charts.v1beta1.GetChartsPageResponse"
}
t1.GetChartsPageResponse = t24
typeRegistry.default:register(t1.GetChartsPageResponse)

local t36 = {}

t36.__index = t36

function t36.new(t37: {[any]: any}?) -- line: 1614
	-- upvalues: t36 (copy)
	return (setmetatable({
		key = if t37 ~= nil and t37.key ~= nil then t37.key else "",
		value = if t37 ~= nil and t37.value ~= nil then t37.value else nil
	}, t36))
end
function t36.encode(p16) -- line: 1623
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n11 = 0

	if p16.key ~= nil and p16.key ~= "" then
		local v293, v294 = proto.writeTag(buf, n11, 1, proto.wireTypes.lengthDelimited)

		buf, n11 = proto.writeString(v293, v294, p16.key)
	end

	if p16.value ~= nil then
		local v295 = p16.value:encode()
		local v296, v297 = proto.writeTag(buf, n11, 2, proto.wireTypes.lengthDelimited)

		buf, n11 = proto.writeBuffer(v296, v297, v295, buffer.len(v295))
	end

	local buf11 = buffer.create(n11)

	buffer.copy(buf11, 0, buf, 0, n11)

	return buf11
end
function t36.decode(p17: buffer) -- line: 1643
	-- upvalues: t36 (copy), proto (copy), template_entry (copy)
	local v300 = t36.new()
	local n12 = 0

	while n12 < buffer.len(p17) do
		local v302, v303

		v302, v303, n12 = proto.readTag(p17, n12)

		if v303 == proto.wireTypes.varint then
			local v304

			v304, n12 = proto.readVarInt(p17, n12)
		elseif v303 == proto.wireTypes.lengthDelimited then
			if v302 == 1 then
				local v305

				v305, n12 = proto.readBuffer(p17, n12)
				v300.key = buffer.tostring(v305)
			elseif v302 == 2 then
				local v306

				v306, n12 = proto.readBuffer(p17, n12)
				v300.value = template_entry.TemplateEntry.decode(v306)
			else
				local v307, v308 = proto.readVarInt(p17, n12)

				n12 = v308 + v307
			end
		elseif v303 == proto.wireTypes.i32 then
			local v309

			v309, n12 = proto.readFixed32(p17, n12)
		elseif v303 == proto.wireTypes.i64 then
			local v310

			v310, n12 = proto.readFixed64(p17, n12)
		else
			error("Unsupported wire type: " .. v303)
		end
	end

	return v300
end
function t36.jsonEncode(p18) -- line: 1691
	local t38 = {}

	if p18.key ~= nil and p18.key ~= "" then
		t38.key = p18.key
	end

	if p18.value ~= nil then
		t38.value = p18.value:jsonEncode()
	end

	return t38
end
function t36.jsonDecode(t39: {[any]: any}) -- line: 1705
	-- upvalues: t36 (copy), template_entry (copy)
	local v314 = t36.new()

	if t39.key ~= nil then
		v314.key = t39.key
	end

	if t39.value ~= nil then
		v314.value = template_entry.TemplateEntry.jsonDecode(t39.value)
	end

	return v314
end

t36.descriptor = {
	name = "GetChartsPageResponse_TemplatesEntry",
	fullName = "roblox.apppageplatform.charts.v1beta1.TemplatesEntry"
}
t1.GetChartsPageResponse_TemplatesEntry = t36
typeRegistry.default:register(t1.GetChartsPageResponse_TemplatesEntry)

local t40 = {}

t40.__index = t40

function t40.new(t41: {[any]: any}?) -- line: 1735
	-- upvalues: t40 (copy)
	return (setmetatable({
		key = if t41 ~= nil and t41.key ~= nil then t41.key else "",
		value = if t41 ~= nil and t41.value ~= nil then t41.value else ""
	}, t40))
end
function t40.encode(p19) -- line: 1744
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n13 = 0

	if p19.key ~= nil and p19.key ~= "" then
		local v319, v320 = proto.writeTag(buf, n13, 1, proto.wireTypes.lengthDelimited)

		buf, n13 = proto.writeString(v319, v320, p19.key)
	end

	if p19.value ~= nil and p19.value ~= "" then
		local v321, v322 = proto.writeTag(buf, n13, 2, proto.wireTypes.lengthDelimited)

		buf, n13 = proto.writeString(v321, v322, p19.value)
	end

	local buf12 = buffer.create(n13)

	buffer.copy(buf12, 0, buf, 0, n13)

	return buf12
end
function t40.decode(p20: buffer) -- line: 1765
	-- upvalues: t40 (copy), proto (copy)
	local v325 = t40.new()
	local n14 = 0

	while n14 < buffer.len(p20) do
		local v327, v328

		v327, v328, n14 = proto.readTag(p20, n14)

		if v328 == proto.wireTypes.varint then
			local v329

			v329, n14 = proto.readVarInt(p20, n14)
		elseif v328 == proto.wireTypes.lengthDelimited then
			if v327 == 1 then
				local v330

				v330, n14 = proto.readBuffer(p20, n14)
				v325.key = buffer.tostring(v330)
			elseif v327 == 2 then
				local v331

				v331, n14 = proto.readBuffer(p20, n14)
				v325.value = buffer.tostring(v331)
			else
				local v332, v333 = proto.readVarInt(p20, n14)

				n14 = v333 + v332
			end
		elseif v328 == proto.wireTypes.i32 then
			local v334

			v334, n14 = proto.readFixed32(p20, n14)
		elseif v328 == proto.wireTypes.i64 then
			local v335

			v335, n14 = proto.readFixed64(p20, n14)
		else
			error("Unsupported wire type: " .. v328)
		end
	end

	return v325
end
function t40.jsonEncode(p21) -- line: 1815
	local t42 = {}

	if p21.key ~= nil and p21.key ~= "" then
		t42.key = p21.key
	end

	if p21.value ~= nil and p21.value ~= "" then
		t42.value = p21.value
	end

	return t42
end
function t40.jsonDecode(t43: {[any]: any}) -- line: 1831
	-- upvalues: t40 (copy)
	local v339 = t40.new()

	if t43.key ~= nil then
		v339.key = t43.key
	end

	if t43.value ~= nil then
		v339.value = t43.value
	end

	return v339
end

t40.descriptor = {
	name = "GetChartsPageResponse_LocalizedLiteralsEntry",
	fullName = "roblox.apppageplatform.charts.v1beta1.LocalizedLiteralsEntry"
}
t1.GetChartsPageResponse_LocalizedLiteralsEntry = t40
typeRegistry.default:register(t1.GetChartsPageResponse_LocalizedLiteralsEntry)

local t44 = {}

t44.__index = t44

function t44.new(t45: {[any]: any}?) -- line: 1861
	-- upvalues: t44 (copy)
	return (setmetatable({
		sort_id = if t45 ~= nil and t45.sort_id ~= nil then t45.sort_id else "",
		content_page_token = if t45 ~= nil and t45.content_page_token ~= nil then t45.content_page_token else "",
		device = if t45 ~= nil and t45.device ~= nil then t45.device else "",
		country = if t45 ~= nil and t45.country ~= nil then t45.country else "",
		session_id = if t45 ~= nil and t45.session_id ~= nil then t45.session_id else "",
		age_group = if t45 ~= nil and t45.age_group ~= nil then t45.age_group else "",
		max_memory = if t45 ~= nil and t45.max_memory ~= nil then t45.max_memory else "",
		selected_genre = if t45 ~= nil and t45.selected_genre ~= nil then t45.selected_genre else "",
		cached_roblox_component_to_template_id = if t45 ~= nil and t45.cached_roblox_component_to_template_id ~= nil then t45.cached_roblox_component_to_template_id else {},
		client_capabilities = if t45 ~= nil and t45.client_capabilities ~= nil then t45.client_capabilities else nil
	}, t44))
end
function t44.encode(p22) -- line: 1883
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n15 = 0

	if p22.sort_id ~= nil and p22.sort_id ~= "" then
		local v344, v345 = proto.writeTag(buf, n15, 1, proto.wireTypes.lengthDelimited)

		buf, n15 = proto.writeString(v344, v345, p22.sort_id)
	end

	if p22.content_page_token ~= nil and p22.content_page_token ~= "" then
		local v346, v347 = proto.writeTag(buf, n15, 2, proto.wireTypes.lengthDelimited)

		buf, n15 = proto.writeString(v346, v347, p22.content_page_token)
	end

	if p22.device ~= nil and p22.device ~= "" then
		local v348, v349 = proto.writeTag(buf, n15, 3, proto.wireTypes.lengthDelimited)

		buf, n15 = proto.writeString(v348, v349, p22.device)
	end

	if p22.country ~= nil and p22.country ~= "" then
		local v350, v351 = proto.writeTag(buf, n15, 4, proto.wireTypes.lengthDelimited)

		buf, n15 = proto.writeString(v350, v351, p22.country)
	end

	if p22.session_id ~= nil and p22.session_id ~= "" then
		local v352, v353 = proto.writeTag(buf, n15, 5, proto.wireTypes.lengthDelimited)

		buf, n15 = proto.writeString(v352, v353, p22.session_id)
	end

	if p22.age_group ~= nil and p22.age_group ~= "" then
		local v354, v355 = proto.writeTag(buf, n15, 6, proto.wireTypes.lengthDelimited)

		buf, n15 = proto.writeString(v354, v355, p22.age_group)
	end

	if p22.max_memory ~= nil and p22.max_memory ~= "" then
		local v356, v357 = proto.writeTag(buf, n15, 7, proto.wireTypes.lengthDelimited)

		buf, n15 = proto.writeString(v356, v357, p22.max_memory)
	end

	if p22.selected_genre ~= nil and p22.selected_genre ~= "" then
		local v358, v359 = proto.writeTag(buf, n15, 8, proto.wireTypes.lengthDelimited)

		buf, n15 = proto.writeString(v358, v359, p22.selected_genre)
	end

	if p22.cached_roblox_component_to_template_id ~= nil and next(p22.cached_roblox_component_to_template_id) ~= nil then
		for v360, v361 in p22.cached_roblox_component_to_template_id do
			local buf13 = buffer.create(0)
			local v363, v364 = proto.writeTag(buf13, 0, 1, proto.wireTypes.lengthDelimited)
			local v365, v366 = proto.writeString(v363, v364, v360)
			local v367, v368 = proto.writeTag(v365, v366, 2, proto.wireTypes.lengthDelimited)
			local v369, v370 = proto.writeString(v367, v368, v361)
			local v371, v372 = proto.writeTag(buf, n15, 9, proto.wireTypes.lengthDelimited)

			buf, n15 = proto.writeBuffer(v371, v372, v369, v370)
		end
	end

	if p22.client_capabilities ~= nil then
		local v373 = p22.client_capabilities:encode()
		local v374, v375 = proto.writeTag(buf, n15, 10, proto.wireTypes.lengthDelimited)

		buf, n15 = proto.writeBuffer(v374, v375, v373, buffer.len(v373))
	end

	local buf14 = buffer.create(n15)

	buffer.copy(buf14, 0, buf, 0, n15)

	return buf14
end
function t44.decode(p23: buffer) -- line: 1954
	-- upvalues: t44 (copy), proto (copy), t1 (copy), client_capabilities (copy)
	local v378 = t44.new()
	local n16 = 0

	while n16 < buffer.len(p23) do
		local v380, v381

		v380, v381, n16 = proto.readTag(p23, n16)

		if v381 == proto.wireTypes.varint then
			local v382

			v382, n16 = proto.readVarInt(p23, n16)
		elseif v381 == proto.wireTypes.lengthDelimited then
			if v380 == 1 then
				local v383

				v383, n16 = proto.readBuffer(p23, n16)
				v378.sort_id = buffer.tostring(v383)
			elseif v380 == 2 then
				local v384

				v384, n16 = proto.readBuffer(p23, n16)
				v378.content_page_token = buffer.tostring(v384)
			elseif v380 == 3 then
				local v385

				v385, n16 = proto.readBuffer(p23, n16)
				v378.device = buffer.tostring(v385)
			elseif v380 == 4 then
				local v386

				v386, n16 = proto.readBuffer(p23, n16)
				v378.country = buffer.tostring(v386)
			elseif v380 == 5 then
				local v387

				v387, n16 = proto.readBuffer(p23, n16)
				v378.session_id = buffer.tostring(v387)
			elseif v380 == 6 then
				local v388

				v388, n16 = proto.readBuffer(p23, n16)
				v378.age_group = buffer.tostring(v388)
			elseif v380 == 7 then
				local v389

				v389, n16 = proto.readBuffer(p23, n16)
				v378.max_memory = buffer.tostring(v389)
			elseif v380 == 8 then
				local v390

				v390, n16 = proto.readBuffer(p23, n16)
				v378.selected_genre = buffer.tostring(v390)
			elseif v380 == 9 then
				local v391

				v391, n16 = proto.readBuffer(p23, n16)

				local v392 = t1.GetChartsSortDetailRequest_CachedRobloxComponentToTemplateIdEntry.decode(v391)

				v378.cached_roblox_component_to_template_id[v392.key or ""] = v392.value or ""
			elseif v380 == 10 then
				local v393

				v393, n16 = proto.readBuffer(p23, n16)
				v378.client_capabilities = client_capabilities.ClientCapabilities.decode(v393)
			else
				local v394, v395 = proto.readVarInt(p23, n16)

				n16 = v395 + v394
			end
		elseif v381 == proto.wireTypes.i32 then
			local v396

			v396, n16 = proto.readFixed32(p23, n16)
		elseif v381 == proto.wireTypes.i64 then
			local v397

			v397, n16 = proto.readFixed64(p23, n16)
		else
			error("Unsupported wire type: " .. v381)
		end
	end

	return v378
end
function t44.jsonEncode(p24) -- line: 2052
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

	if p24.selected_genre ~= nil and p24.selected_genre ~= "" then
		t46.selectedGenre = p24.selected_genre
	end

	if p24.cached_roblox_component_to_template_id ~= nil and next(p24.cached_roblox_component_to_template_id) ~= nil then
		local t47 = {}

		for v401, v402 in p24.cached_roblox_component_to_template_id do
			t47[v401] = v402
		end

		t46.cachedRobloxComponentToTemplateId = t47
	end

	if p24.client_capabilities ~= nil then
		t46.clientCapabilities = p24.client_capabilities:jsonEncode()
	end

	return t46
end
function t44.jsonDecode(t48: {[any]: any}) -- line: 2105
	-- upvalues: t44 (copy), client_capabilities (copy)
	local v404 = t44.new()

	if t48.sort_id ~= nil then
		v404.sort_id = t48.sort_id
	end

	if t48.sortId ~= nil then
		v404.sort_id = t48.sortId
	end

	if t48.content_page_token ~= nil then
		v404.content_page_token = t48.content_page_token
	end

	if t48.contentPageToken ~= nil then
		v404.content_page_token = t48.contentPageToken
	end

	if t48.device ~= nil then
		v404.device = t48.device
	end

	if t48.country ~= nil then
		v404.country = t48.country
	end

	if t48.session_id ~= nil then
		v404.session_id = t48.session_id
	end

	if t48.sessionId ~= nil then
		v404.session_id = t48.sessionId
	end

	if t48.age_group ~= nil then
		v404.age_group = t48.age_group
	end

	if t48.ageGroup ~= nil then
		v404.age_group = t48.ageGroup
	end

	if t48.max_memory ~= nil then
		v404.max_memory = t48.max_memory
	end

	if t48.maxMemory ~= nil then
		v404.max_memory = t48.maxMemory
	end

	if t48.selected_genre ~= nil then
		v404.selected_genre = t48.selected_genre
	end

	if t48.selectedGenre ~= nil then
		v404.selected_genre = t48.selectedGenre
	end

	if t48.cached_roblox_component_to_template_id ~= nil then
		local t49 = {}

		for v406, v407 in t48.cached_roblox_component_to_template_id do
			t49[v406] = v407
		end

		v404.cached_roblox_component_to_template_id = t49
	end

	if t48.cachedRobloxComponentToTemplateId ~= nil then
		local t50 = {}

		for v409, v410 in t48.cachedRobloxComponentToTemplateId do
			t50[v409] = v410
		end

		v404.cached_roblox_component_to_template_id = t50
	end

	if t48.client_capabilities ~= nil then
		v404.client_capabilities = client_capabilities.ClientCapabilities.jsonDecode(t48.client_capabilities)
	end

	if t48.clientCapabilities ~= nil then
		v404.client_capabilities = client_capabilities.ClientCapabilities.jsonDecode(t48.clientCapabilities)
	end

	return v404
end

t44.descriptor = {
	name = "GetChartsSortDetailRequest",
	fullName = "roblox.apppageplatform.charts.v1beta1.GetChartsSortDetailRequest"
}
t1.GetChartsSortDetailRequest = t44
typeRegistry.default:register(t1.GetChartsSortDetailRequest)

local t51 = {}

t51.__index = t51

function t51.new(t52: {[any]: any}?) -- line: 2214
	-- upvalues: t51 (copy)
	return (setmetatable({
		key = if t52 ~= nil and t52.key ~= nil then t52.key else "",
		value = if t52 ~= nil and t52.value ~= nil then t52.value else ""
	}, t51))
end
function t51.encode(p25) -- line: 2226
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n17 = 0

	if p25.key ~= nil and p25.key ~= "" then
		local v415, v416 = proto.writeTag(buf, n17, 1, proto.wireTypes.lengthDelimited)

		buf, n17 = proto.writeString(v415, v416, p25.key)
	end

	if p25.value ~= nil and p25.value ~= "" then
		local v417, v418 = proto.writeTag(buf, n17, 2, proto.wireTypes.lengthDelimited)

		buf, n17 = proto.writeString(v417, v418, p25.value)
	end

	local buf15 = buffer.create(n17)

	buffer.copy(buf15, 0, buf, 0, n17)

	return buf15
end
function t51.decode(p26: buffer) -- line: 2247
	-- upvalues: t51 (copy), proto (copy)
	local v421 = t51.new()
	local n18 = 0

	while n18 < buffer.len(p26) do
		local v423, v424

		v423, v424, n18 = proto.readTag(p26, n18)

		if v424 == proto.wireTypes.varint then
			local v425

			v425, n18 = proto.readVarInt(p26, n18)
		elseif v424 == proto.wireTypes.lengthDelimited then
			if v423 == 1 then
				local v426

				v426, n18 = proto.readBuffer(p26, n18)
				v421.key = buffer.tostring(v426)
			elseif v423 == 2 then
				local v427

				v427, n18 = proto.readBuffer(p26, n18)
				v421.value = buffer.tostring(v427)
			else
				local v428, v429 = proto.readVarInt(p26, n18)

				n18 = v429 + v428
			end
		elseif v424 == proto.wireTypes.i32 then
			local v430

			v430, n18 = proto.readFixed32(p26, n18)
		elseif v424 == proto.wireTypes.i64 then
			local v431

			v431, n18 = proto.readFixed64(p26, n18)
		else
			error("Unsupported wire type: " .. v424)
		end
	end

	return v421
end
function t51.jsonEncode(p27) -- line: 2297
	local t53 = {}

	if p27.key ~= nil and p27.key ~= "" then
		t53.key = p27.key
	end

	if p27.value ~= nil and p27.value ~= "" then
		t53.value = p27.value
	end

	return t53
end
function t51.jsonDecode(t54: {[any]: any}) -- line: 2313
	-- upvalues: t51 (copy)
	local v435 = t51.new()

	if t54.key ~= nil then
		v435.key = t54.key
	end

	if t54.value ~= nil then
		v435.value = t54.value
	end

	return v435
end

t51.descriptor = {
	name = "GetChartsSortDetailRequest_CachedRobloxComponentToTemplateIdEntry",
	fullName = "roblox.apppageplatform.charts.v1beta1.CachedRobloxComponentToTemplateIdEntry"
}
t1.GetChartsSortDetailRequest_CachedRobloxComponentToTemplateIdEntry = t51
typeRegistry.default:register(t1.GetChartsSortDetailRequest_CachedRobloxComponentToTemplateIdEntry)

local t55 = {}

t55.__index = t55

function t55.new(t56: {[any]: any}?) -- line: 2344
	-- upvalues: t55 (copy)
	return (setmetatable({
		page_entries = if t56 ~= nil and t56.page_entries ~= nil then t56.page_entries else {},
		hydration_data = if t56 ~= nil and t56.hydration_data ~= nil then t56.hydration_data else nil,
		templates = if t56 ~= nil and t56.templates ~= nil then t56.templates else {},
		next_content_page_token = if t56 ~= nil and t56.next_content_page_token ~= nil then t56.next_content_page_token else "",
		localized_literals = if t56 ~= nil and t56.localized_literals ~= nil then t56.localized_literals else {}
	}, t55))
end
function t55.encode(p28) -- line: 2358
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n19 = 0

	if p28.page_entries ~= nil and #p28.page_entries > 0 then
		for _, v441 in p28.page_entries do
			local v442 = v441:encode()
			local v443, v444 = proto.writeTag(buf, n19, 1, proto.wireTypes.lengthDelimited)

			buf, n19 = proto.writeBuffer(v443, v444, v442, buffer.len(v442))
		end
	end

	if p28.hydration_data ~= nil then
		local v445 = p28.hydration_data:encode()
		local v446, v447 = proto.writeTag(buf, n19, 2, proto.wireTypes.lengthDelimited)

		buf, n19 = proto.writeBuffer(v446, v447, v445, buffer.len(v445))
	end

	if p28.templates ~= nil and next(p28.templates) ~= nil then
		for v448, v449 in p28.templates do
			local buf16 = buffer.create(0)
			local v451, v452 = proto.writeTag(buf16, 0, 1, proto.wireTypes.lengthDelimited)
			local v453, v454 = proto.writeString(v451, v452, v448)
			local v455 = v449:encode()
			local v456, v457 = proto.writeTag(v453, v454, 2, proto.wireTypes.lengthDelimited)
			local v458, v459 = proto.writeBuffer(v456, v457, v455, buffer.len(v455))
			local v460, v461 = proto.writeTag(buf, n19, 3, proto.wireTypes.lengthDelimited)

			buf, n19 = proto.writeBuffer(v460, v461, v458, v459)
		end
	end

	if p28.next_content_page_token ~= nil and p28.next_content_page_token ~= "" then
		local v462, v463 = proto.writeTag(buf, n19, 4, proto.wireTypes.lengthDelimited)

		buf, n19 = proto.writeString(v462, v463, p28.next_content_page_token)
	end

	if p28.localized_literals ~= nil and next(p28.localized_literals) ~= nil then
		for v464, v465 in p28.localized_literals do
			local buf17 = buffer.create(0)
			local v467, v468 = proto.writeTag(buf17, 0, 1, proto.wireTypes.lengthDelimited)
			local v469, v470 = proto.writeString(v467, v468, v464)
			local v471, v472 = proto.writeTag(v469, v470, 2, proto.wireTypes.lengthDelimited)
			local v473, v474 = proto.writeString(v471, v472, v465)
			local v475, v476 = proto.writeTag(buf, n19, 5, proto.wireTypes.lengthDelimited)

			buf, n19 = proto.writeBuffer(v475, v476, v473, v474)
		end
	end

	local buf18 = buffer.create(n19)

	buffer.copy(buf18, 0, buf, 0, n19)

	return buf18
end
function t55.decode(p29: buffer) -- line: 2413
	-- upvalues: t55 (copy), proto (copy), page_entry_content (copy), hydration_content (copy), t1 (copy), template_entry (copy)
	local v479 = t55.new()
	local n20 = 0

	while n20 < buffer.len(p29) do
		local v481, v482

		v481, v482, n20 = proto.readTag(p29, n20)

		if v482 == proto.wireTypes.varint then
			local v483

			v483, n20 = proto.readVarInt(p29, n20)
		elseif v482 == proto.wireTypes.lengthDelimited then
			if v481 == 1 then
				local v484

				v484, n20 = proto.readBuffer(p29, n20)
				table.insert(v479.page_entries, page_entry_content.UniversalPageEntry.decode(v484))
			elseif v481 == 2 then
				local v485

				v485, n20 = proto.readBuffer(p29, n20)
				v479.hydration_data = hydration_content.HydrationContent.decode(v485)
			elseif v481 == 3 then
				local v486

				v486, n20 = proto.readBuffer(p29, n20)

				local v487 = t1.GetChartsSortDetailResponse_TemplatesEntry.decode(v486)
				local v488 = template_entry.TemplateEntry.new()

				v479.templates[v487.key or ""] = v487.value or v488
			elseif v481 == 4 then
				local v489

				v489, n20 = proto.readBuffer(p29, n20)
				v479.next_content_page_token = buffer.tostring(v489)
			elseif v481 == 5 then
				local v490

				v490, n20 = proto.readBuffer(p29, n20)

				local v491 = t1.GetChartsSortDetailResponse_LocalizedLiteralsEntry.decode(v490)

				v479.localized_literals[v491.key or ""] = v491.value or ""
			else
				local v492, v493 = proto.readVarInt(p29, n20)

				n20 = v493 + v492
			end
		elseif v482 == proto.wireTypes.i32 then
			local v494

			v494, n20 = proto.readFixed32(p29, n20)
		elseif v482 == proto.wireTypes.i64 then
			local v495

			v495, n20 = proto.readFixed64(p29, n20)
		else
			error("Unsupported wire type: " .. v482)
		end
	end

	return v479
end
function t55.jsonEncode(p30) -- line: 2494
	local t57 = {}

	if p30.page_entries ~= nil and #p30.page_entries > 0 then
		local t58 = {}

		for _, v500 in p30.page_entries do
			table.insert(t58, v500:jsonEncode())
		end

		t57.pageEntries = t58
	end

	if p30.hydration_data ~= nil then
		t57.hydrationData = p30.hydration_data:jsonEncode()
	end

	if p30.templates ~= nil and next(p30.templates) ~= nil then
		local t59 = {}

		for v502, v503 in p30.templates do
			t59[v502] = v503:jsonEncode()
		end

		t57.templates = t59
	end

	if p30.next_content_page_token ~= nil and p30.next_content_page_token ~= "" then
		t57.nextContentPageToken = p30.next_content_page_token
	end

	if p30.localized_literals ~= nil and next(p30.localized_literals) ~= nil then
		local t60 = {}

		for v505, v506 in p30.localized_literals do
			t60[v505] = v506
		end

		t57.localizedLiterals = t60
	end

	return t57
end
function t55.jsonDecode(t61: {[any]: any}) -- line: 2532
	-- upvalues: t55 (copy), page_entry_content (copy), hydration_content (copy), template_entry (copy)
	local v508 = t55.new()

	if t61.page_entries ~= nil then
		local t62 = {}

		for _, v511 in t61.page_entries do
			table.insert(t62, page_entry_content.UniversalPageEntry.jsonDecode(v511))
		end

		v508.page_entries = t62
	end

	if t61.pageEntries ~= nil then
		local t63 = {}

		for _, v514 in t61.pageEntries do
			table.insert(t63, page_entry_content.UniversalPageEntry.jsonDecode(v514))
		end

		v508.page_entries = t63
	end

	if t61.hydration_data ~= nil then
		v508.hydration_data = hydration_content.HydrationContent.jsonDecode(t61.hydration_data)
	end

	if t61.hydrationData ~= nil then
		v508.hydration_data = hydration_content.HydrationContent.jsonDecode(t61.hydrationData)
	end

	if t61.templates ~= nil then
		local t64 = {}

		for v516, v517 in t61.templates do
			t64[v516] = template_entry.TemplateEntry.jsonDecode(v517)
		end

		v508.templates = t64
	end

	if t61.next_content_page_token ~= nil then
		v508.next_content_page_token = t61.next_content_page_token
	end

	if t61.nextContentPageToken ~= nil then
		v508.next_content_page_token = t61.nextContentPageToken
	end

	if t61.localized_literals ~= nil then
		local t65 = {}

		for v519, v520 in t61.localized_literals do
			t65[v519] = v520
		end

		v508.localized_literals = t65
	end

	if t61.localizedLiterals ~= nil then
		local t66 = {}

		for v522, v523 in t61.localizedLiterals do
			t66[v522] = v523
		end

		v508.localized_literals = t66
	end

	return v508
end

t55.descriptor = {
	name = "GetChartsSortDetailResponse",
	fullName = "roblox.apppageplatform.charts.v1beta1.GetChartsSortDetailResponse"
}
t1.GetChartsSortDetailResponse = t55
typeRegistry.default:register(t1.GetChartsSortDetailResponse)

local t67 = {}

t67.__index = t67

function t67.new(t68: {[any]: any}?) -- line: 2623
	-- upvalues: t67 (copy)
	return (setmetatable({
		key = if t68 ~= nil and t68.key ~= nil then t68.key else "",
		value = if t68 ~= nil and t68.value ~= nil then t68.value else nil
	}, t67))
end
function t67.encode(p31) -- line: 2632
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n21 = 0

	if p31.key ~= nil and p31.key ~= "" then
		local v528, v529 = proto.writeTag(buf, n21, 1, proto.wireTypes.lengthDelimited)

		buf, n21 = proto.writeString(v528, v529, p31.key)
	end

	if p31.value ~= nil then
		local v530 = p31.value:encode()
		local v531, v532 = proto.writeTag(buf, n21, 2, proto.wireTypes.lengthDelimited)

		buf, n21 = proto.writeBuffer(v531, v532, v530, buffer.len(v530))
	end

	local buf19 = buffer.create(n21)

	buffer.copy(buf19, 0, buf, 0, n21)

	return buf19
end
function t67.decode(p32: buffer) -- line: 2654
	-- upvalues: t67 (copy), proto (copy), template_entry (copy)
	local v535 = t67.new()
	local n22 = 0

	while n22 < buffer.len(p32) do
		local v537, v538

		v537, v538, n22 = proto.readTag(p32, n22)

		if v538 == proto.wireTypes.varint then
			local v539

			v539, n22 = proto.readVarInt(p32, n22)
		elseif v538 == proto.wireTypes.lengthDelimited then
			if v537 == 1 then
				local v540

				v540, n22 = proto.readBuffer(p32, n22)
				v535.key = buffer.tostring(v540)
			elseif v537 == 2 then
				local v541

				v541, n22 = proto.readBuffer(p32, n22)
				v535.value = template_entry.TemplateEntry.decode(v541)
			else
				local v542, v543 = proto.readVarInt(p32, n22)

				n22 = v543 + v542
			end
		elseif v538 == proto.wireTypes.i32 then
			local v544

			v544, n22 = proto.readFixed32(p32, n22)
		elseif v538 == proto.wireTypes.i64 then
			local v545

			v545, n22 = proto.readFixed64(p32, n22)
		else
			error("Unsupported wire type: " .. v538)
		end
	end

	return v535
end
function t67.jsonEncode(p33) -- line: 2704
	local t69 = {}

	if p33.key ~= nil and p33.key ~= "" then
		t69.key = p33.key
	end

	if p33.value ~= nil then
		t69.value = p33.value:jsonEncode()
	end

	return t69
end
function t67.jsonDecode(t70: {[any]: any}) -- line: 2720
	-- upvalues: t67 (copy), template_entry (copy)
	local v549 = t67.new()

	if t70.key ~= nil then
		v549.key = t70.key
	end

	if t70.value ~= nil then
		v549.value = template_entry.TemplateEntry.jsonDecode(t70.value)
	end

	return v549
end

t67.descriptor = {
	name = "GetChartsSortDetailResponse_TemplatesEntry",
	fullName = "roblox.apppageplatform.charts.v1beta1.TemplatesEntry"
}
t1.GetChartsSortDetailResponse_TemplatesEntry = t67
typeRegistry.default:register(t1.GetChartsSortDetailResponse_TemplatesEntry)

local t71 = {}

t71.__index = t71

function t71.new(t72: {[any]: any}?) -- line: 2751
	-- upvalues: t71 (copy)
	return (setmetatable({
		key = if t72 ~= nil and t72.key ~= nil then t72.key else "",
		value = if t72 ~= nil and t72.value ~= nil then t72.value else ""
	}, t71))
end
function t71.encode(p34) -- line: 2763
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n23 = 0

	if p34.key ~= nil and p34.key ~= "" then
		local v554, v555 = proto.writeTag(buf, n23, 1, proto.wireTypes.lengthDelimited)

		buf, n23 = proto.writeString(v554, v555, p34.key)
	end

	if p34.value ~= nil and p34.value ~= "" then
		local v556, v557 = proto.writeTag(buf, n23, 2, proto.wireTypes.lengthDelimited)

		buf, n23 = proto.writeString(v556, v557, p34.value)
	end

	local buf20 = buffer.create(n23)

	buffer.copy(buf20, 0, buf, 0, n23)

	return buf20
end
function t71.decode(p35: buffer) -- line: 2784
	-- upvalues: t71 (copy), proto (copy)
	local v560 = t71.new()
	local n24 = 0

	while n24 < buffer.len(p35) do
		local v562, v563

		v562, v563, n24 = proto.readTag(p35, n24)

		if v563 == proto.wireTypes.varint then
			local v564

			v564, n24 = proto.readVarInt(p35, n24)
		elseif v563 == proto.wireTypes.lengthDelimited then
			if v562 == 1 then
				local v565

				v565, n24 = proto.readBuffer(p35, n24)
				v560.key = buffer.tostring(v565)
			elseif v562 == 2 then
				local v566

				v566, n24 = proto.readBuffer(p35, n24)
				v560.value = buffer.tostring(v566)
			else
				local v567, v568 = proto.readVarInt(p35, n24)

				n24 = v568 + v567
			end
		elseif v563 == proto.wireTypes.i32 then
			local v569

			v569, n24 = proto.readFixed32(p35, n24)
		elseif v563 == proto.wireTypes.i64 then
			local v570

			v570, n24 = proto.readFixed64(p35, n24)
		else
			error("Unsupported wire type: " .. v563)
		end
	end

	return v560
end
function t71.jsonEncode(p36) -- line: 2834
	local t73 = {}

	if p36.key ~= nil and p36.key ~= "" then
		t73.key = p36.key
	end

	if p36.value ~= nil and p36.value ~= "" then
		t73.value = p36.value
	end

	return t73
end
function t71.jsonDecode(t74: {[any]: any}) -- line: 2850
	-- upvalues: t71 (copy)
	local v574 = t71.new()

	if t74.key ~= nil then
		v574.key = t74.key
	end

	if t74.value ~= nil then
		v574.value = t74.value
	end

	return v574
end

t71.descriptor = {
	name = "GetChartsSortDetailResponse_LocalizedLiteralsEntry",
	fullName = "roblox.apppageplatform.charts.v1beta1.LocalizedLiteralsEntry"
}
t1.GetChartsSortDetailResponse_LocalizedLiteralsEntry = t71
typeRegistry.default:register(t1.GetChartsSortDetailResponse_LocalizedLiteralsEntry)

return {
	GetChartsPageRequest = t1.GetChartsPageRequest,
	CollectionLayoutInfo = t1.CollectionLayoutInfo,
	GetChartsPageResponse = t1.GetChartsPageResponse,
	GetChartsSortDetailRequest = t1.GetChartsSortDetailRequest,
	GetChartsSortDetailResponse = t1.GetChartsSortDetailResponse
}
