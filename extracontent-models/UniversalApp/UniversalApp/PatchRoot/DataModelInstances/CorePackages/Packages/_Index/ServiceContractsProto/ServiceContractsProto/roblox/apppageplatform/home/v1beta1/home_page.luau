local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local hydration_content = require(script.Parent.Parent.Parent.shared.v1beta1.hydration_content)
local template_entry = require(script.Parent.Parent.Parent.shared.v1beta1.template_entry)
local page_entry_content = require(script.Parent.Parent.Parent.shared.v1beta1.page_entry_content)
local client_capabilities = require(script.Parent.Parent.Parent.shared.v1beta1.client_capabilities)
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 206
	-- upvalues: t2 (copy)
	return (setmetatable({
		session_id = if t3 ~= nil and t3.session_id ~= nil then t3.session_id else "",
		topic_ids = if t3 ~= nil and t3.topic_ids ~= nil then t3.topic_ids else {},
		contextual_features = if t3 ~= nil and t3.contextual_features ~= nil then t3.contextual_features else {},
		cached_roblox_component_to_template_id = if t3 ~= nil and t3.cached_roblox_component_to_template_id ~= nil then t3.cached_roblox_component_to_template_id else {},
		client_capabilities = if t3 ~= nil and t3.client_capabilities ~= nil then t3.client_capabilities else nil
	}, t2))
end
function t2.encode(p1) -- line: 223
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.session_id ~= nil and p1.session_id ~= "" then
		local v18, v19 = proto.writeTag(buf, n1, 1, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v18, v19, p1.session_id)
	end

	if p1.topic_ids ~= nil and #p1.topic_ids > 0 then
		for _, v21 in p1.topic_ids do
			local v22, v23 = proto.writeTag(buf, n1, 2, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeString(v22, v23, v21)
		end
	end

	if p1.contextual_features ~= nil and next(p1.contextual_features) ~= nil then
		for v24, v25 in p1.contextual_features do
			local buf2 = buffer.create(0)
			local v27, v28 = proto.writeTag(buf2, 0, 1, proto.wireTypes.lengthDelimited)
			local v29, v30 = proto.writeString(v27, v28, v24)
			local v31, v32 = proto.writeTag(v29, v30, 2, proto.wireTypes.lengthDelimited)
			local v33, v34 = proto.writeString(v31, v32, v25)
			local v35, v36 = proto.writeTag(buf, n1, 3, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v35, v36, v33, v34)
		end
	end

	if p1.cached_roblox_component_to_template_id ~= nil and next(p1.cached_roblox_component_to_template_id) ~= nil then
		for v37, v38 in p1.cached_roblox_component_to_template_id do
			local buf3 = buffer.create(0)
			local v40, v41 = proto.writeTag(buf3, 0, 1, proto.wireTypes.lengthDelimited)
			local v42, v43 = proto.writeString(v40, v41, v37)
			local v44, v45 = proto.writeTag(v42, v43, 2, proto.wireTypes.lengthDelimited)
			local v46, v47 = proto.writeString(v44, v45, v38)
			local v48, v49 = proto.writeTag(buf, n1, 4, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v48, v49, v46, v47)
		end
	end

	if p1.client_capabilities ~= nil then
		local v50 = p1.client_capabilities:encode()
		local v51, v52 = proto.writeTag(buf, n1, 5, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeBuffer(v51, v52, v50, buffer.len(v50))
	end

	local buf4 = buffer.create(n1)

	buffer.copy(buf4, 0, buf, 0, n1)

	return buf4
end
function t2.decode(p2: buffer) -- line: 279
	-- upvalues: t2 (copy), proto (copy), t1 (copy), client_capabilities (copy)
	local v55 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v57, v58

		v57, v58, n2 = proto.readTag(p2, n2)

		if v58 == proto.wireTypes.varint then
			local v59

			v59, n2 = proto.readVarInt(p2, n2)
		elseif v58 == proto.wireTypes.lengthDelimited then
			if v57 == 1 then
				local v60

				v60, n2 = proto.readBuffer(p2, n2)
				v55.session_id = buffer.tostring(v60)
			elseif v57 == 2 then
				local v61

				v61, n2 = proto.readBuffer(p2, n2)
				table.insert(v55.topic_ids, buffer.tostring(v61))
			elseif v57 == 3 then
				local v62

				v62, n2 = proto.readBuffer(p2, n2)

				local v63 = t1.HomePageRequest_ContextualFeaturesEntry.decode(v62)

				v55.contextual_features[v63.key or ""] = v63.value or ""
			elseif v57 == 4 then
				local v64

				v64, n2 = proto.readBuffer(p2, n2)

				local v65 = t1.HomePageRequest_CachedRobloxComponentToTemplateIdEntry.decode(v64)

				v55.cached_roblox_component_to_template_id[v65.key or ""] = v65.value or ""
			elseif v57 == 5 then
				local v66

				v66, n2 = proto.readBuffer(p2, n2)
				v55.client_capabilities = client_capabilities.ClientCapabilities.decode(v66)
			else
				local v67, v68 = proto.readVarInt(p2, n2)

				n2 = v68 + v67
			end
		elseif v58 == proto.wireTypes.i32 then
			local v69

			v69, n2 = proto.readFixed32(p2, n2)
		elseif v58 == proto.wireTypes.i64 then
			local v70

			v70, n2 = proto.readFixed64(p2, n2)
		else
			error("Unsupported wire type: " .. v58)
		end
	end

	return v55
end
function t2.jsonEncode(p3) -- line: 358
	local t4 = {}

	if p3.session_id ~= nil and p3.session_id ~= "" then
		t4.sessionId = p3.session_id
	end

	if p3.topic_ids ~= nil and #p3.topic_ids > 0 then
		local t5 = {}

		for _, v75 in p3.topic_ids do
			table.insert(t5, v75)
		end

		t4.topicIds = t5
	end

	if p3.contextual_features ~= nil and next(p3.contextual_features) ~= nil then
		local t6 = {}

		for v77, v78 in p3.contextual_features do
			t6[v77] = v78
		end

		t4.contextualFeatures = t6
	end

	if p3.cached_roblox_component_to_template_id ~= nil and next(p3.cached_roblox_component_to_template_id) ~= nil then
		local t7 = {}

		for v80, v81 in p3.cached_roblox_component_to_template_id do
			t7[v80] = v81
		end

		t4.cachedRobloxComponentToTemplateId = t7
	end

	if p3.client_capabilities ~= nil then
		t4.clientCapabilities = p3.client_capabilities:jsonEncode()
	end

	return t4
end
function t2.jsonDecode(t8: {[any]: any}) -- line: 399
	-- upvalues: t2 (copy), client_capabilities (copy)
	local v83 = t2.new()

	if t8.session_id ~= nil then
		v83.session_id = t8.session_id
	end

	if t8.sessionId ~= nil then
		v83.session_id = t8.sessionId
	end

	if t8.topic_ids ~= nil then
		local t9 = {}

		for _, v86 in t8.topic_ids do
			table.insert(t9, v86)
		end

		v83.topic_ids = t9
	end

	if t8.topicIds ~= nil then
		local t10 = {}

		for _, v89 in t8.topicIds do
			table.insert(t10, v89)
		end

		v83.topic_ids = t10
	end

	if t8.contextual_features ~= nil then
		local t11 = {}

		for v91, v92 in t8.contextual_features do
			t11[v91] = v92
		end

		v83.contextual_features = t11
	end

	if t8.contextualFeatures ~= nil then
		local t12 = {}

		for v94, v95 in t8.contextualFeatures do
			t12[v94] = v95
		end

		v83.contextual_features = t12
	end

	if t8.cached_roblox_component_to_template_id ~= nil then
		local t13 = {}

		for v97, v98 in t8.cached_roblox_component_to_template_id do
			t13[v97] = v98
		end

		v83.cached_roblox_component_to_template_id = t13
	end

	if t8.cachedRobloxComponentToTemplateId ~= nil then
		local t14 = {}

		for v100, v101 in t8.cachedRobloxComponentToTemplateId do
			t14[v100] = v101
		end

		v83.cached_roblox_component_to_template_id = t14
	end

	if t8.client_capabilities ~= nil then
		v83.client_capabilities = client_capabilities.ClientCapabilities.jsonDecode(t8.client_capabilities)
	end

	if t8.clientCapabilities ~= nil then
		v83.client_capabilities = client_capabilities.ClientCapabilities.jsonDecode(t8.clientCapabilities)
	end

	return v83
end

t2.descriptor = {
	name = "HomePageRequest",
	fullName = "roblox.apppageplatform.home.v1beta1.HomePageRequest"
}
t1.HomePageRequest = t2
typeRegistry.default:register(t1.HomePageRequest)

local t15 = {}

t15.__index = t15

function t15.new(t16: {[any]: any}?) -- line: 495
	-- upvalues: t15 (copy)
	return (setmetatable({
		key = if t16 ~= nil and t16.key ~= nil then t16.key else "",
		value = if t16 ~= nil and t16.value ~= nil then t16.value else ""
	}, t15))
end
function t15.encode(p4) -- line: 504
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n3 = 0

	if p4.key ~= nil and p4.key ~= "" then
		local v106, v107 = proto.writeTag(buf, n3, 1, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeString(v106, v107, p4.key)
	end

	if p4.value ~= nil and p4.value ~= "" then
		local v108, v109 = proto.writeTag(buf, n3, 2, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeString(v108, v109, p4.value)
	end

	local buf5 = buffer.create(n3)

	buffer.copy(buf5, 0, buf, 0, n3)

	return buf5
end
function t15.decode(p5: buffer) -- line: 523
	-- upvalues: t15 (copy), proto (copy)
	local v112 = t15.new()
	local n4 = 0

	while n4 < buffer.len(p5) do
		local v114, v115

		v114, v115, n4 = proto.readTag(p5, n4)

		if v115 == proto.wireTypes.varint then
			local v116

			v116, n4 = proto.readVarInt(p5, n4)
		elseif v115 == proto.wireTypes.lengthDelimited then
			if v114 == 1 then
				local v117

				v117, n4 = proto.readBuffer(p5, n4)
				v112.key = buffer.tostring(v117)
			elseif v114 == 2 then
				local v118

				v118, n4 = proto.readBuffer(p5, n4)
				v112.value = buffer.tostring(v118)
			else
				local v119, v120 = proto.readVarInt(p5, n4)

				n4 = v120 + v119
			end
		elseif v115 == proto.wireTypes.i32 then
			local v121

			v121, n4 = proto.readFixed32(p5, n4)
		elseif v115 == proto.wireTypes.i64 then
			local v122

			v122, n4 = proto.readFixed64(p5, n4)
		else
			error("Unsupported wire type: " .. v115)
		end
	end

	return v112
end
function t15.jsonEncode(p6) -- line: 571
	local t17 = {}

	if p6.key ~= nil and p6.key ~= "" then
		t17.key = p6.key
	end

	if p6.value ~= nil and p6.value ~= "" then
		t17.value = p6.value
	end

	return t17
end
function t15.jsonDecode(t18: {[any]: any}) -- line: 585
	-- upvalues: t15 (copy)
	local v126 = t15.new()

	if t18.key ~= nil then
		v126.key = t18.key
	end

	if t18.value ~= nil then
		v126.value = t18.value
	end

	return v126
end

t15.descriptor = {
	name = "HomePageRequest_ContextualFeaturesEntry",
	fullName = "roblox.apppageplatform.home.v1beta1.ContextualFeaturesEntry"
}
t1.HomePageRequest_ContextualFeaturesEntry = t15
typeRegistry.default:register(t1.HomePageRequest_ContextualFeaturesEntry)

local t19 = {}

t19.__index = t19

function t19.new(t20: {[any]: any}?) -- line: 616
	-- upvalues: t19 (copy)
	return (setmetatable({
		key = if t20 ~= nil and t20.key ~= nil then t20.key else "",
		value = if t20 ~= nil and t20.value ~= nil then t20.value else ""
	}, t19))
end
function t19.encode(p7) -- line: 628
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n5 = 0

	if p7.key ~= nil and p7.key ~= "" then
		local v131, v132 = proto.writeTag(buf, n5, 1, proto.wireTypes.lengthDelimited)

		buf, n5 = proto.writeString(v131, v132, p7.key)
	end

	if p7.value ~= nil and p7.value ~= "" then
		local v133, v134 = proto.writeTag(buf, n5, 2, proto.wireTypes.lengthDelimited)

		buf, n5 = proto.writeString(v133, v134, p7.value)
	end

	local buf6 = buffer.create(n5)

	buffer.copy(buf6, 0, buf, 0, n5)

	return buf6
end
function t19.decode(p8: buffer) -- line: 649
	-- upvalues: t19 (copy), proto (copy)
	local v137 = t19.new()
	local n6 = 0

	while n6 < buffer.len(p8) do
		local v139, v140

		v139, v140, n6 = proto.readTag(p8, n6)

		if v140 == proto.wireTypes.varint then
			local v141

			v141, n6 = proto.readVarInt(p8, n6)
		elseif v140 == proto.wireTypes.lengthDelimited then
			if v139 == 1 then
				local v142

				v142, n6 = proto.readBuffer(p8, n6)
				v137.key = buffer.tostring(v142)
			elseif v139 == 2 then
				local v143

				v143, n6 = proto.readBuffer(p8, n6)
				v137.value = buffer.tostring(v143)
			else
				local v144, v145 = proto.readVarInt(p8, n6)

				n6 = v145 + v144
			end
		elseif v140 == proto.wireTypes.i32 then
			local v146

			v146, n6 = proto.readFixed32(p8, n6)
		elseif v140 == proto.wireTypes.i64 then
			local v147

			v147, n6 = proto.readFixed64(p8, n6)
		else
			error("Unsupported wire type: " .. v140)
		end
	end

	return v137
end
function t19.jsonEncode(p9) -- line: 699
	local t21 = {}

	if p9.key ~= nil and p9.key ~= "" then
		t21.key = p9.key
	end

	if p9.value ~= nil and p9.value ~= "" then
		t21.value = p9.value
	end

	return t21
end
function t19.jsonDecode(t22: {[any]: any}) -- line: 715
	-- upvalues: t19 (copy)
	local v151 = t19.new()

	if t22.key ~= nil then
		v151.key = t22.key
	end

	if t22.value ~= nil then
		v151.value = t22.value
	end

	return v151
end

t19.descriptor = {
	name = "HomePageRequest_CachedRobloxComponentToTemplateIdEntry",
	fullName = "roblox.apppageplatform.home.v1beta1.CachedRobloxComponentToTemplateIdEntry"
}
t1.HomePageRequest_CachedRobloxComponentToTemplateIdEntry = t19
typeRegistry.default:register(t1.HomePageRequest_CachedRobloxComponentToTemplateIdEntry)

local t23 = {}

t23.__index = t23

function t23.new(t24: {[any]: any}?) -- line: 746
	-- upvalues: t23 (copy)
	return (setmetatable({
		page_entries = if t24 ~= nil and t24.page_entries ~= nil then t24.page_entries else {},
		hydration_data = if t24 ~= nil and t24.hydration_data ~= nil then t24.hydration_data else nil,
		templates = if t24 ~= nil and t24.templates ~= nil then t24.templates else {},
		localized_literals = if t24 ~= nil and t24.localized_literals ~= nil then t24.localized_literals else {}
	}, t23))
end
function t23.encode(p10) -- line: 755
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n7 = 0

	if p10.page_entries ~= nil and #p10.page_entries > 0 then
		for _, v157 in p10.page_entries do
			local v158 = v157:encode()
			local v159, v160 = proto.writeTag(buf, n7, 1, proto.wireTypes.lengthDelimited)

			buf, n7 = proto.writeBuffer(v159, v160, v158, buffer.len(v158))
		end
	end

	if p10.hydration_data ~= nil then
		local v161 = p10.hydration_data:encode()
		local v162, v163 = proto.writeTag(buf, n7, 2, proto.wireTypes.lengthDelimited)

		buf, n7 = proto.writeBuffer(v162, v163, v161, buffer.len(v161))
	end

	if p10.templates ~= nil and next(p10.templates) ~= nil then
		for v164, v165 in p10.templates do
			local buf7 = buffer.create(0)
			local v167, v168 = proto.writeTag(buf7, 0, 1, proto.wireTypes.lengthDelimited)
			local v169, v170 = proto.writeString(v167, v168, v164)
			local v171 = v165:encode()
			local v172, v173 = proto.writeTag(v169, v170, 2, proto.wireTypes.lengthDelimited)
			local v174, v175 = proto.writeBuffer(v172, v173, v171, buffer.len(v171))
			local v176, v177 = proto.writeTag(buf, n7, 3, proto.wireTypes.lengthDelimited)

			buf, n7 = proto.writeBuffer(v176, v177, v174, v175)
		end
	end

	if p10.localized_literals ~= nil and next(p10.localized_literals) ~= nil then
		for v178, v179 in p10.localized_literals do
			local buf8 = buffer.create(0)
			local v181, v182 = proto.writeTag(buf8, 0, 1, proto.wireTypes.lengthDelimited)
			local v183, v184 = proto.writeString(v181, v182, v178)
			local v185, v186 = proto.writeTag(v183, v184, 2, proto.wireTypes.lengthDelimited)
			local v187, v188 = proto.writeString(v185, v186, v179)
			local v189, v190 = proto.writeTag(buf, n7, 4, proto.wireTypes.lengthDelimited)

			buf, n7 = proto.writeBuffer(v189, v190, v187, v188)
		end
	end

	local buf9 = buffer.create(n7)

	buffer.copy(buf9, 0, buf, 0, n7)

	return buf9
end
function t23.decode(p11: buffer) -- line: 805
	-- upvalues: t23 (copy), proto (copy), page_entry_content (copy), hydration_content (copy), t1 (copy), template_entry (copy)
	local v193 = t23.new()
	local n8 = 0

	while n8 < buffer.len(p11) do
		local v195, v196

		v195, v196, n8 = proto.readTag(p11, n8)

		if v196 == proto.wireTypes.varint then
			local v197

			v197, n8 = proto.readVarInt(p11, n8)
		elseif v196 == proto.wireTypes.lengthDelimited then
			if v195 == 1 then
				local v198

				v198, n8 = proto.readBuffer(p11, n8)
				table.insert(v193.page_entries, page_entry_content.UniversalPageEntry.decode(v198))
			elseif v195 == 2 then
				local v199

				v199, n8 = proto.readBuffer(p11, n8)
				v193.hydration_data = hydration_content.HydrationContent.decode(v199)
			elseif v195 == 3 then
				local v200

				v200, n8 = proto.readBuffer(p11, n8)

				local v201 = t1.HomePageResponse_TemplatesEntry.decode(v200)
				local v202 = template_entry.TemplateEntry.new()

				v193.templates[v201.key or ""] = v201.value or v202
			elseif v195 == 4 then
				local v203

				v203, n8 = proto.readBuffer(p11, n8)

				local v204 = t1.HomePageResponse_LocalizedLiteralsEntry.decode(v203)

				v193.localized_literals[v204.key or ""] = v204.value or ""
			else
				local v205, v206 = proto.readVarInt(p11, n8)

				n8 = v206 + v205
			end
		elseif v196 == proto.wireTypes.i32 then
			local v207

			v207, n8 = proto.readFixed32(p11, n8)
		elseif v196 == proto.wireTypes.i64 then
			local v208

			v208, n8 = proto.readFixed64(p11, n8)
		else
			error("Unsupported wire type: " .. v196)
		end
	end

	return v193
end
function t23.jsonEncode(p12) -- line: 881
	local t25 = {}

	if p12.page_entries ~= nil and #p12.page_entries > 0 then
		local t26 = {}

		for _, v213 in p12.page_entries do
			table.insert(t26, v213:jsonEncode())
		end

		t25.pageEntries = t26
	end

	if p12.hydration_data ~= nil then
		t25.hydrationData = p12.hydration_data:jsonEncode()
	end

	if p12.templates ~= nil and next(p12.templates) ~= nil then
		local t27 = {}

		for v215, v216 in p12.templates do
			t27[v215] = v216:jsonEncode()
		end

		t25.templates = t27
	end

	if p12.localized_literals ~= nil and next(p12.localized_literals) ~= nil then
		local t28 = {}

		for v218, v219 in p12.localized_literals do
			t28[v218] = v219
		end

		t25.localizedLiterals = t28
	end

	return t25
end
function t23.jsonDecode(t29: {[any]: any}) -- line: 915
	-- upvalues: t23 (copy), page_entry_content (copy), hydration_content (copy), template_entry (copy)
	local v221 = t23.new()

	if t29.page_entries ~= nil then
		local t30 = {}

		for _, v224 in t29.page_entries do
			table.insert(t30, page_entry_content.UniversalPageEntry.jsonDecode(v224))
		end

		v221.page_entries = t30
	end

	if t29.pageEntries ~= nil then
		local t31 = {}

		for _, v227 in t29.pageEntries do
			table.insert(t31, page_entry_content.UniversalPageEntry.jsonDecode(v227))
		end

		v221.page_entries = t31
	end

	if t29.hydration_data ~= nil then
		v221.hydration_data = hydration_content.HydrationContent.jsonDecode(t29.hydration_data)
	end

	if t29.hydrationData ~= nil then
		v221.hydration_data = hydration_content.HydrationContent.jsonDecode(t29.hydrationData)
	end

	if t29.templates ~= nil then
		local t32 = {}

		for v229, v230 in t29.templates do
			t32[v229] = template_entry.TemplateEntry.jsonDecode(v230)
		end

		v221.templates = t32
	end

	if t29.localized_literals ~= nil then
		local t33 = {}

		for v232, v233 in t29.localized_literals do
			t33[v232] = v233
		end

		v221.localized_literals = t33
	end

	if t29.localizedLiterals ~= nil then
		local t34 = {}

		for v235, v236 in t29.localizedLiterals do
			t34[v235] = v236
		end

		v221.localized_literals = t34
	end

	return v221
end

t23.descriptor = {
	name = "HomePageResponse",
	fullName = "roblox.apppageplatform.home.v1beta1.HomePageResponse"
}
t1.HomePageResponse = t23
typeRegistry.default:register(t1.HomePageResponse)

local t35 = {}

t35.__index = t35

function t35.new(t36: {[any]: any}?) -- line: 998
	-- upvalues: t35 (copy)
	return (setmetatable({
		key = if t36 ~= nil and t36.key ~= nil then t36.key else "",
		value = if t36 ~= nil and t36.value ~= nil then t36.value else nil
	}, t35))
end
function t35.encode(p13) -- line: 1007
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n9 = 0

	if p13.key ~= nil and p13.key ~= "" then
		local v241, v242 = proto.writeTag(buf, n9, 1, proto.wireTypes.lengthDelimited)

		buf, n9 = proto.writeString(v241, v242, p13.key)
	end

	if p13.value ~= nil then
		local v243 = p13.value:encode()
		local v244, v245 = proto.writeTag(buf, n9, 2, proto.wireTypes.lengthDelimited)

		buf, n9 = proto.writeBuffer(v244, v245, v243, buffer.len(v243))
	end

	local buf10 = buffer.create(n9)

	buffer.copy(buf10, 0, buf, 0, n9)

	return buf10
end
function t35.decode(p14: buffer) -- line: 1027
	-- upvalues: t35 (copy), proto (copy), template_entry (copy)
	local v248 = t35.new()
	local n10 = 0

	while n10 < buffer.len(p14) do
		local v250, v251

		v250, v251, n10 = proto.readTag(p14, n10)

		if v251 == proto.wireTypes.varint then
			local v252

			v252, n10 = proto.readVarInt(p14, n10)
		elseif v251 == proto.wireTypes.lengthDelimited then
			if v250 == 1 then
				local v253

				v253, n10 = proto.readBuffer(p14, n10)
				v248.key = buffer.tostring(v253)
			elseif v250 == 2 then
				local v254

				v254, n10 = proto.readBuffer(p14, n10)
				v248.value = template_entry.TemplateEntry.decode(v254)
			else
				local v255, v256 = proto.readVarInt(p14, n10)

				n10 = v256 + v255
			end
		elseif v251 == proto.wireTypes.i32 then
			local v257

			v257, n10 = proto.readFixed32(p14, n10)
		elseif v251 == proto.wireTypes.i64 then
			local v258

			v258, n10 = proto.readFixed64(p14, n10)
		else
			error("Unsupported wire type: " .. v251)
		end
	end

	return v248
end
function t35.jsonEncode(p15) -- line: 1075
	local t37 = {}

	if p15.key ~= nil and p15.key ~= "" then
		t37.key = p15.key
	end

	if p15.value ~= nil then
		t37.value = p15.value:jsonEncode()
	end

	return t37
end
function t35.jsonDecode(t38: {[any]: any}) -- line: 1089
	-- upvalues: t35 (copy), template_entry (copy)
	local v262 = t35.new()

	if t38.key ~= nil then
		v262.key = t38.key
	end

	if t38.value ~= nil then
		v262.value = template_entry.TemplateEntry.jsonDecode(t38.value)
	end

	return v262
end

t35.descriptor = {
	name = "HomePageResponse_TemplatesEntry",
	fullName = "roblox.apppageplatform.home.v1beta1.TemplatesEntry"
}
t1.HomePageResponse_TemplatesEntry = t35
typeRegistry.default:register(t1.HomePageResponse_TemplatesEntry)

local t39 = {}

t39.__index = t39

function t39.new(t40: {[any]: any}?) -- line: 1117
	-- upvalues: t39 (copy)
	return (setmetatable({
		key = if t40 ~= nil and t40.key ~= nil then t40.key else "",
		value = if t40 ~= nil and t40.value ~= nil then t40.value else ""
	}, t39))
end
function t39.encode(p16) -- line: 1126
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n11 = 0

	if p16.key ~= nil and p16.key ~= "" then
		local v267, v268 = proto.writeTag(buf, n11, 1, proto.wireTypes.lengthDelimited)

		buf, n11 = proto.writeString(v267, v268, p16.key)
	end

	if p16.value ~= nil and p16.value ~= "" then
		local v269, v270 = proto.writeTag(buf, n11, 2, proto.wireTypes.lengthDelimited)

		buf, n11 = proto.writeString(v269, v270, p16.value)
	end

	local buf11 = buffer.create(n11)

	buffer.copy(buf11, 0, buf, 0, n11)

	return buf11
end
function t39.decode(p17: buffer) -- line: 1145
	-- upvalues: t39 (copy), proto (copy)
	local v273 = t39.new()
	local n12 = 0

	while n12 < buffer.len(p17) do
		local v275, v276

		v275, v276, n12 = proto.readTag(p17, n12)

		if v276 == proto.wireTypes.varint then
			local v277

			v277, n12 = proto.readVarInt(p17, n12)
		elseif v276 == proto.wireTypes.lengthDelimited then
			if v275 == 1 then
				local v278

				v278, n12 = proto.readBuffer(p17, n12)
				v273.key = buffer.tostring(v278)
			elseif v275 == 2 then
				local v279

				v279, n12 = proto.readBuffer(p17, n12)
				v273.value = buffer.tostring(v279)
			else
				local v280, v281 = proto.readVarInt(p17, n12)

				n12 = v281 + v280
			end
		elseif v276 == proto.wireTypes.i32 then
			local v282

			v282, n12 = proto.readFixed32(p17, n12)
		elseif v276 == proto.wireTypes.i64 then
			local v283

			v283, n12 = proto.readFixed64(p17, n12)
		else
			error("Unsupported wire type: " .. v276)
		end
	end

	return v273
end
function t39.jsonEncode(p18) -- line: 1193
	local t41 = {}

	if p18.key ~= nil and p18.key ~= "" then
		t41.key = p18.key
	end

	if p18.value ~= nil and p18.value ~= "" then
		t41.value = p18.value
	end

	return t41
end
function t39.jsonDecode(t42: {[any]: any}) -- line: 1207
	-- upvalues: t39 (copy)
	local v287 = t39.new()

	if t42.key ~= nil then
		v287.key = t42.key
	end

	if t42.value ~= nil then
		v287.value = t42.value
	end

	return v287
end

t39.descriptor = {
	name = "HomePageResponse_LocalizedLiteralsEntry",
	fullName = "roblox.apppageplatform.home.v1beta1.LocalizedLiteralsEntry"
}
t1.HomePageResponse_LocalizedLiteralsEntry = t39
typeRegistry.default:register(t1.HomePageResponse_LocalizedLiteralsEntry)

return {
	HomePageRequest = t1.HomePageRequest,
	HomePageResponse = t1.HomePageResponse
}
