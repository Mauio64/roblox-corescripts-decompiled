local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local hydration_content = require(script.Parent.Parent.Parent.shared.v1beta1.hydration_content)
local template_entry = require(script.Parent.Parent.Parent.shared.v1beta1.template_entry)
local page_entry_content = require(script.Parent.Parent.Parent.shared.v1beta1.page_entry_content)
local client_capabilities = require(script.Parent.Parent.Parent.shared.v1beta1.client_capabilities)
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 187
	-- upvalues: t2 (copy)
	return (setmetatable({
		cached_roblox_component_to_template_id = if t3 ~= nil and t3.cached_roblox_component_to_template_id ~= nil then t3.cached_roblox_component_to_template_id else {},
		client_capabilities = if t3 ~= nil and t3.client_capabilities ~= nil then t3.client_capabilities else nil
	}, t2))
end
function t2.encode(p1) -- line: 201
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.cached_roblox_component_to_template_id ~= nil and next(p1.cached_roblox_component_to_template_id) ~= nil then
		for v17, v18 in p1.cached_roblox_component_to_template_id do
			local buf2 = buffer.create(0)
			local v20, v21 = proto.writeTag(buf2, 0, 1, proto.wireTypes.lengthDelimited)
			local v22, v23 = proto.writeString(v20, v21, v17)
			local v24, v25 = proto.writeTag(v22, v23, 2, proto.wireTypes.lengthDelimited)
			local v26, v27 = proto.writeString(v24, v25, v18)
			local v28, v29 = proto.writeTag(buf, n1, 1, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v28, v29, v26, v27)
		end
	end

	if p1.client_capabilities ~= nil then
		local v30 = p1.client_capabilities:encode()
		local v31, v32 = proto.writeTag(buf, n1, 2, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeBuffer(v31, v32, v30, buffer.len(v30))
	end

	local buf3 = buffer.create(n1)

	buffer.copy(buf3, 0, buf, 0, n1)

	return buf3
end
function t2.decode(p2: buffer) -- line: 232
	-- upvalues: t2 (copy), proto (copy), t1 (copy), client_capabilities (copy)
	local v35 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v37, v38

		v37, v38, n2 = proto.readTag(p2, n2)

		if v38 == proto.wireTypes.varint then
			local v39

			v39, n2 = proto.readVarInt(p2, n2)
		elseif v38 == proto.wireTypes.lengthDelimited then
			if v37 == 1 then
				local v40

				v40, n2 = proto.readBuffer(p2, n2)

				local v41 = t1.ExperienceDetailsPageRequest_CachedRobloxComponentToTemplateIdEntry.decode(v40)

				v35.cached_roblox_component_to_template_id[v41.key or ""] = v41.value or ""
			elseif v37 == 2 then
				local v42

				v42, n2 = proto.readBuffer(p2, n2)
				v35.client_capabilities = client_capabilities.ClientCapabilities.decode(v42)
			else
				local v43, v44 = proto.readVarInt(p2, n2)

				n2 = v44 + v43
			end
		elseif v38 == proto.wireTypes.i32 then
			local v45

			v45, n2 = proto.readFixed32(p2, n2)
		elseif v38 == proto.wireTypes.i64 then
			local v46

			v46, n2 = proto.readFixed64(p2, n2)
		else
			error("Unsupported wire type: " .. v38)
		end
	end

	return v35
end
function t2.jsonEncode(p3) -- line: 290
	local t4 = {}

	if p3.cached_roblox_component_to_template_id ~= nil and next(p3.cached_roblox_component_to_template_id) ~= nil then
		local t5 = {}

		for v50, v51 in p3.cached_roblox_component_to_template_id do
			t5[v50] = v51
		end

		t4.cachedRobloxComponentToTemplateId = t5
	end

	if p3.client_capabilities ~= nil then
		t4.clientCapabilities = p3.client_capabilities:jsonEncode()
	end

	return t4
end
function t2.jsonDecode(t6: {[any]: any}) -- line: 311
	-- upvalues: t2 (copy), client_capabilities (copy)
	local v53 = t2.new()

	if t6.cached_roblox_component_to_template_id ~= nil then
		local t7 = {}

		for v55, v56 in t6.cached_roblox_component_to_template_id do
			t7[v55] = v56
		end

		v53.cached_roblox_component_to_template_id = t7
	end

	if t6.cachedRobloxComponentToTemplateId ~= nil then
		local t8 = {}

		for v58, v59 in t6.cachedRobloxComponentToTemplateId do
			t8[v58] = v59
		end

		v53.cached_roblox_component_to_template_id = t8
	end

	if t6.client_capabilities ~= nil then
		v53.client_capabilities = client_capabilities.ClientCapabilities.jsonDecode(t6.client_capabilities)
	end

	if t6.clientCapabilities ~= nil then
		v53.client_capabilities = client_capabilities.ClientCapabilities.jsonDecode(t6.clientCapabilities)
	end

	return v53
end

t2.descriptor = {
	name = "ExperienceDetailsPageRequest",
	fullName = "roblox.apppageplatform.experiencedetails.v1beta1.ExperienceDetailsPageRequest"
}
t1.ExperienceDetailsPageRequest = t2
typeRegistry.default:register(t1.ExperienceDetailsPageRequest)

local t9 = {}

t9.__index = t9

function t9.new(t10: {[any]: any}?) -- line: 364
	-- upvalues: t9 (copy)
	return (setmetatable({
		key = if t10 ~= nil and t10.key ~= nil then t10.key else "",
		value = if t10 ~= nil and t10.value ~= nil then t10.value else ""
	}, t9))
end
function t9.encode(p4) -- line: 376
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n3 = 0

	if p4.key ~= nil and p4.key ~= "" then
		local v64, v65 = proto.writeTag(buf, n3, 1, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeString(v64, v65, p4.key)
	end

	if p4.value ~= nil and p4.value ~= "" then
		local v66, v67 = proto.writeTag(buf, n3, 2, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeString(v66, v67, p4.value)
	end

	local buf4 = buffer.create(n3)

	buffer.copy(buf4, 0, buf, 0, n3)

	return buf4
end
function t9.decode(p5: buffer) -- line: 397
	-- upvalues: t9 (copy), proto (copy)
	local v70 = t9.new()
	local n4 = 0

	while n4 < buffer.len(p5) do
		local v72, v73

		v72, v73, n4 = proto.readTag(p5, n4)

		if v73 == proto.wireTypes.varint then
			local v74

			v74, n4 = proto.readVarInt(p5, n4)
		elseif v73 == proto.wireTypes.lengthDelimited then
			if v72 == 1 then
				local v75

				v75, n4 = proto.readBuffer(p5, n4)
				v70.key = buffer.tostring(v75)
			elseif v72 == 2 then
				local v76

				v76, n4 = proto.readBuffer(p5, n4)
				v70.value = buffer.tostring(v76)
			else
				local v77, v78 = proto.readVarInt(p5, n4)

				n4 = v78 + v77
			end
		elseif v73 == proto.wireTypes.i32 then
			local v79

			v79, n4 = proto.readFixed32(p5, n4)
		elseif v73 == proto.wireTypes.i64 then
			local v80

			v80, n4 = proto.readFixed64(p5, n4)
		else
			error("Unsupported wire type: " .. v73)
		end
	end

	return v70
end
function t9.jsonEncode(p6) -- line: 447
	local t11 = {}

	if p6.key ~= nil and p6.key ~= "" then
		t11.key = p6.key
	end

	if p6.value ~= nil and p6.value ~= "" then
		t11.value = p6.value
	end

	return t11
end
function t9.jsonDecode(t12: {[any]: any}) -- line: 463
	-- upvalues: t9 (copy)
	local v84 = t9.new()

	if t12.key ~= nil then
		v84.key = t12.key
	end

	if t12.value ~= nil then
		v84.value = t12.value
	end

	return v84
end

t9.descriptor = {
	name = "ExperienceDetailsPageRequest_CachedRobloxComponentToTemplateIdEntry",
	fullName = "roblox.apppageplatform.experiencedetails.v1beta1.CachedRobloxComponentToTemplateIdEntry"
}
t1.ExperienceDetailsPageRequest_CachedRobloxComponentToTemplateIdEntry = t9
typeRegistry.default:register(t1.ExperienceDetailsPageRequest_CachedRobloxComponentToTemplateIdEntry)

local t13 = {}

t13.__index = t13

function t13.new(t14: {[any]: any}?) -- line: 494
	-- upvalues: t13 (copy)
	return (setmetatable({
		page_entries = if t14 ~= nil and t14.page_entries ~= nil then t14.page_entries else {},
		hydration_data = if t14 ~= nil and t14.hydration_data ~= nil then t14.hydration_data else nil,
		templates = if t14 ~= nil and t14.templates ~= nil then t14.templates else {},
		localized_literals = if t14 ~= nil and t14.localized_literals ~= nil then t14.localized_literals else {}
	}, t13))
end
function t13.encode(p7) -- line: 505
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n5 = 0

	if p7.page_entries ~= nil and #p7.page_entries > 0 then
		for _, v90 in p7.page_entries do
			local v91 = v90:encode()
			local v92, v93 = proto.writeTag(buf, n5, 1, proto.wireTypes.lengthDelimited)

			buf, n5 = proto.writeBuffer(v92, v93, v91, buffer.len(v91))
		end
	end

	if p7.hydration_data ~= nil then
		local v94 = p7.hydration_data:encode()
		local v95, v96 = proto.writeTag(buf, n5, 2, proto.wireTypes.lengthDelimited)

		buf, n5 = proto.writeBuffer(v95, v96, v94, buffer.len(v94))
	end

	if p7.templates ~= nil and next(p7.templates) ~= nil then
		for v97, v98 in p7.templates do
			local buf5 = buffer.create(0)
			local v100, v101 = proto.writeTag(buf5, 0, 1, proto.wireTypes.lengthDelimited)
			local v102, v103 = proto.writeString(v100, v101, v97)
			local v104 = v98:encode()
			local v105, v106 = proto.writeTag(v102, v103, 2, proto.wireTypes.lengthDelimited)
			local v107, v108 = proto.writeBuffer(v105, v106, v104, buffer.len(v104))
			local v109, v110 = proto.writeTag(buf, n5, 3, proto.wireTypes.lengthDelimited)

			buf, n5 = proto.writeBuffer(v109, v110, v107, v108)
		end
	end

	if p7.localized_literals ~= nil and next(p7.localized_literals) ~= nil then
		for v111, v112 in p7.localized_literals do
			local buf6 = buffer.create(0)
			local v114, v115 = proto.writeTag(buf6, 0, 1, proto.wireTypes.lengthDelimited)
			local v116, v117 = proto.writeString(v114, v115, v111)
			local v118, v119 = proto.writeTag(v116, v117, 2, proto.wireTypes.lengthDelimited)
			local v120, v121 = proto.writeString(v118, v119, v112)
			local v122, v123 = proto.writeTag(buf, n5, 4, proto.wireTypes.lengthDelimited)

			buf, n5 = proto.writeBuffer(v122, v123, v120, v121)
		end
	end

	local buf7 = buffer.create(n5)

	buffer.copy(buf7, 0, buf, 0, n5)

	return buf7
end
function t13.decode(p8: buffer) -- line: 555
	-- upvalues: t13 (copy), proto (copy), page_entry_content (copy), hydration_content (copy), t1 (copy), template_entry (copy)
	local v126 = t13.new()
	local n6 = 0

	while n6 < buffer.len(p8) do
		local v128, v129

		v128, v129, n6 = proto.readTag(p8, n6)

		if v129 == proto.wireTypes.varint then
			local v130

			v130, n6 = proto.readVarInt(p8, n6)
		elseif v129 == proto.wireTypes.lengthDelimited then
			if v128 == 1 then
				local v131

				v131, n6 = proto.readBuffer(p8, n6)
				table.insert(v126.page_entries, page_entry_content.UniversalPageEntry.decode(v131))
			elseif v128 == 2 then
				local v132

				v132, n6 = proto.readBuffer(p8, n6)
				v126.hydration_data = hydration_content.HydrationContent.decode(v132)
			elseif v128 == 3 then
				local v133

				v133, n6 = proto.readBuffer(p8, n6)

				local v134 = t1.ExperienceDetailsPageResponse_TemplatesEntry.decode(v133)
				local v135 = template_entry.TemplateEntry.new()

				v126.templates[v134.key or ""] = v134.value or v135
			elseif v128 == 4 then
				local v136

				v136, n6 = proto.readBuffer(p8, n6)

				local v137 = t1.ExperienceDetailsPageResponse_LocalizedLiteralsEntry.decode(v136)

				v126.localized_literals[v137.key or ""] = v137.value or ""
			else
				local v138, v139 = proto.readVarInt(p8, n6)

				n6 = v139 + v138
			end
		elseif v129 == proto.wireTypes.i32 then
			local v140

			v140, n6 = proto.readFixed32(p8, n6)
		elseif v129 == proto.wireTypes.i64 then
			local v141

			v141, n6 = proto.readFixed64(p8, n6)
		else
			error("Unsupported wire type: " .. v129)
		end
	end

	return v126
end
function t13.jsonEncode(p9) -- line: 631
	local t15 = {}

	if p9.page_entries ~= nil and #p9.page_entries > 0 then
		local t16 = {}

		for _, v146 in p9.page_entries do
			table.insert(t16, v146:jsonEncode())
		end

		t15.pageEntries = t16
	end

	if p9.hydration_data ~= nil then
		t15.hydrationData = p9.hydration_data:jsonEncode()
	end

	if p9.templates ~= nil and next(p9.templates) ~= nil then
		local t17 = {}

		for v148, v149 in p9.templates do
			t17[v148] = v149:jsonEncode()
		end

		t15.templates = t17
	end

	if p9.localized_literals ~= nil and next(p9.localized_literals) ~= nil then
		local t18 = {}

		for v151, v152 in p9.localized_literals do
			t18[v151] = v152
		end

		t15.localizedLiterals = t18
	end

	return t15
end
function t13.jsonDecode(t19: {[any]: any}) -- line: 665
	-- upvalues: t13 (copy), page_entry_content (copy), hydration_content (copy), template_entry (copy)
	local v154 = t13.new()

	if t19.page_entries ~= nil then
		local t20 = {}

		for _, v157 in t19.page_entries do
			table.insert(t20, page_entry_content.UniversalPageEntry.jsonDecode(v157))
		end

		v154.page_entries = t20
	end

	if t19.pageEntries ~= nil then
		local t21 = {}

		for _, v160 in t19.pageEntries do
			table.insert(t21, page_entry_content.UniversalPageEntry.jsonDecode(v160))
		end

		v154.page_entries = t21
	end

	if t19.hydration_data ~= nil then
		v154.hydration_data = hydration_content.HydrationContent.jsonDecode(t19.hydration_data)
	end

	if t19.hydrationData ~= nil then
		v154.hydration_data = hydration_content.HydrationContent.jsonDecode(t19.hydrationData)
	end

	if t19.templates ~= nil then
		local t22 = {}

		for v162, v163 in t19.templates do
			t22[v162] = template_entry.TemplateEntry.jsonDecode(v163)
		end

		v154.templates = t22
	end

	if t19.localized_literals ~= nil then
		local t23 = {}

		for v165, v166 in t19.localized_literals do
			t23[v165] = v166
		end

		v154.localized_literals = t23
	end

	if t19.localizedLiterals ~= nil then
		local t24 = {}

		for v168, v169 in t19.localizedLiterals do
			t24[v168] = v169
		end

		v154.localized_literals = t24
	end

	return v154
end

t13.descriptor = {
	name = "ExperienceDetailsPageResponse",
	fullName = "roblox.apppageplatform.experiencedetails.v1beta1.ExperienceDetailsPageResponse"
}
t1.ExperienceDetailsPageResponse = t13
typeRegistry.default:register(t1.ExperienceDetailsPageResponse)

local t25 = {}

t25.__index = t25

function t25.new(t26: {[any]: any}?) -- line: 748
	-- upvalues: t25 (copy)
	return (setmetatable({
		key = if t26 ~= nil and t26.key ~= nil then t26.key else "",
		value = if t26 ~= nil and t26.value ~= nil then t26.value else nil
	}, t25))
end
function t25.encode(p10) -- line: 757
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n7 = 0

	if p10.key ~= nil and p10.key ~= "" then
		local v174, v175 = proto.writeTag(buf, n7, 1, proto.wireTypes.lengthDelimited)

		buf, n7 = proto.writeString(v174, v175, p10.key)
	end

	if p10.value ~= nil then
		local v176 = p10.value:encode()
		local v177, v178 = proto.writeTag(buf, n7, 2, proto.wireTypes.lengthDelimited)

		buf, n7 = proto.writeBuffer(v177, v178, v176, buffer.len(v176))
	end

	local buf8 = buffer.create(n7)

	buffer.copy(buf8, 0, buf, 0, n7)

	return buf8
end
function t25.decode(p11: buffer) -- line: 779
	-- upvalues: t25 (copy), proto (copy), template_entry (copy)
	local v181 = t25.new()
	local n8 = 0

	while n8 < buffer.len(p11) do
		local v183, v184

		v183, v184, n8 = proto.readTag(p11, n8)

		if v184 == proto.wireTypes.varint then
			local v185

			v185, n8 = proto.readVarInt(p11, n8)
		elseif v184 == proto.wireTypes.lengthDelimited then
			if v183 == 1 then
				local v186

				v186, n8 = proto.readBuffer(p11, n8)
				v181.key = buffer.tostring(v186)
			elseif v183 == 2 then
				local v187

				v187, n8 = proto.readBuffer(p11, n8)
				v181.value = template_entry.TemplateEntry.decode(v187)
			else
				local v188, v189 = proto.readVarInt(p11, n8)

				n8 = v189 + v188
			end
		elseif v184 == proto.wireTypes.i32 then
			local v190

			v190, n8 = proto.readFixed32(p11, n8)
		elseif v184 == proto.wireTypes.i64 then
			local v191

			v191, n8 = proto.readFixed64(p11, n8)
		else
			error("Unsupported wire type: " .. v184)
		end
	end

	return v181
end
function t25.jsonEncode(p12) -- line: 829
	local t27 = {}

	if p12.key ~= nil and p12.key ~= "" then
		t27.key = p12.key
	end

	if p12.value ~= nil then
		t27.value = p12.value:jsonEncode()
	end

	return t27
end
function t25.jsonDecode(t28: {[any]: any}) -- line: 845
	-- upvalues: t25 (copy), template_entry (copy)
	local v195 = t25.new()

	if t28.key ~= nil then
		v195.key = t28.key
	end

	if t28.value ~= nil then
		v195.value = template_entry.TemplateEntry.jsonDecode(t28.value)
	end

	return v195
end

t25.descriptor = {
	name = "ExperienceDetailsPageResponse_TemplatesEntry",
	fullName = "roblox.apppageplatform.experiencedetails.v1beta1.TemplatesEntry"
}
t1.ExperienceDetailsPageResponse_TemplatesEntry = t25
typeRegistry.default:register(t1.ExperienceDetailsPageResponse_TemplatesEntry)

local t29 = {}

t29.__index = t29

function t29.new(t30: {[any]: any}?) -- line: 876
	-- upvalues: t29 (copy)
	return (setmetatable({
		key = if t30 ~= nil and t30.key ~= nil then t30.key else "",
		value = if t30 ~= nil and t30.value ~= nil then t30.value else ""
	}, t29))
end
function t29.encode(p13) -- line: 888
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n9 = 0

	if p13.key ~= nil and p13.key ~= "" then
		local v200, v201 = proto.writeTag(buf, n9, 1, proto.wireTypes.lengthDelimited)

		buf, n9 = proto.writeString(v200, v201, p13.key)
	end

	if p13.value ~= nil and p13.value ~= "" then
		local v202, v203 = proto.writeTag(buf, n9, 2, proto.wireTypes.lengthDelimited)

		buf, n9 = proto.writeString(v202, v203, p13.value)
	end

	local buf9 = buffer.create(n9)

	buffer.copy(buf9, 0, buf, 0, n9)

	return buf9
end
function t29.decode(p14: buffer) -- line: 909
	-- upvalues: t29 (copy), proto (copy)
	local v206 = t29.new()
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
				v206.value = buffer.tostring(v212)
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
function t29.jsonEncode(p15) -- line: 959
	local t31 = {}

	if p15.key ~= nil and p15.key ~= "" then
		t31.key = p15.key
	end

	if p15.value ~= nil and p15.value ~= "" then
		t31.value = p15.value
	end

	return t31
end
function t29.jsonDecode(t32: {[any]: any}) -- line: 975
	-- upvalues: t29 (copy)
	local v220 = t29.new()

	if t32.key ~= nil then
		v220.key = t32.key
	end

	if t32.value ~= nil then
		v220.value = t32.value
	end

	return v220
end

t29.descriptor = {
	name = "ExperienceDetailsPageResponse_LocalizedLiteralsEntry",
	fullName = "roblox.apppageplatform.experiencedetails.v1beta1.LocalizedLiteralsEntry"
}
t1.ExperienceDetailsPageResponse_LocalizedLiteralsEntry = t29
typeRegistry.default:register(t1.ExperienceDetailsPageResponse_LocalizedLiteralsEntry)

return {
	ExperienceDetailsPageRequest = t1.ExperienceDetailsPageRequest,
	ExperienceDetailsPageResponse = t1.ExperienceDetailsPageResponse
}
