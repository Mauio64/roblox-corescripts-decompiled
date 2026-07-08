local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local hydration_content = require(script.Parent.Parent.Parent.shared.v1beta1.hydration_content)
local page_entry_content = require(script.Parent.Parent.Parent.shared.v1beta1.page_entry_content)
local template_entry = require(script.Parent.Parent.Parent.shared.v1beta1.template_entry)
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 240
	-- upvalues: t2 (copy)
	return (setmetatable({
		parameters = if t3 ~= nil and t3.parameters ~= nil then t3.parameters else {},
		translations = if t3 ~= nil and t3.translations ~= nil then t3.translations else {}
	}, t2))
end
function t2.encode(p1) -- line: 247
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.parameters ~= nil and next(p1.parameters) ~= nil then
		for v18, v19 in p1.parameters do
			local buf2 = buffer.create(0)
			local v21, v22 = proto.writeTag(buf2, 0, 1, proto.wireTypes.lengthDelimited)
			local v23, v24 = proto.writeString(v21, v22, v18)
			local v25, v26 = proto.writeTag(v23, v24, 2, proto.wireTypes.lengthDelimited)
			local v27, v28 = proto.writeString(v25, v26, v19)
			local v29, v30 = proto.writeTag(buf, n1, 1, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v29, v30, v27, v28)
		end
	end

	if p1.translations ~= nil and next(p1.translations) ~= nil then
		for v31, v32 in p1.translations do
			local buf3 = buffer.create(0)
			local v34, v35 = proto.writeTag(buf3, 0, 1, proto.wireTypes.lengthDelimited)
			local v36, v37 = proto.writeString(v34, v35, v31)
			local v38, v39 = proto.writeTag(v36, v37, 2, proto.wireTypes.lengthDelimited)
			local v40, v41 = proto.writeString(v38, v39, v32)
			local v42, v43 = proto.writeTag(buf, n1, 2, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v42, v43, v40, v41)
		end
	end

	local buf4 = buffer.create(n1)

	buffer.copy(buf4, 0, buf, 0, n1)

	return buf4
end
function t2.decode(p2: buffer) -- line: 282
	-- upvalues: t2 (copy), proto (copy), t1 (copy)
	local v46 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v48, v49

		v48, v49, n2 = proto.readTag(p2, n2)

		if v49 == proto.wireTypes.varint then
			local v50

			v50, n2 = proto.readVarInt(p2, n2)
		elseif v49 == proto.wireTypes.lengthDelimited then
			if v48 == 1 then
				local v51

				v51, n2 = proto.readBuffer(p2, n2)

				local v52 = t1.CustomPrompt_ParametersEntry.decode(v51)

				v46.parameters[v52.key or ""] = v52.value or ""
			elseif v48 == 2 then
				local v53

				v53, n2 = proto.readBuffer(p2, n2)

				local v54 = t1.CustomPrompt_TranslationsEntry.decode(v53)

				v46.translations[v54.key or ""] = v54.value or ""
			else
				local v55, v56 = proto.readVarInt(p2, n2)

				n2 = v56 + v55
			end
		elseif v49 == proto.wireTypes.i32 then
			local v57

			v57, n2 = proto.readFixed32(p2, n2)
		elseif v49 == proto.wireTypes.i64 then
			local v58

			v58, n2 = proto.readFixed64(p2, n2)
		else
			error("Unsupported wire type: " .. v49)
		end
	end

	return v46
end
function t2.jsonEncode(p3) -- line: 344
	local t4 = {}

	if p3.parameters ~= nil and next(p3.parameters) ~= nil then
		local t5 = {}

		for v62, v63 in p3.parameters do
			t5[v62] = v63
		end

		t4.parameters = t5
	end

	if p3.translations ~= nil and next(p3.translations) ~= nil then
		local t6 = {}

		for v65, v66 in p3.translations do
			t6[v65] = v66
		end

		t4.translations = t6
	end

	return t4
end
function t2.jsonDecode(t7: {[any]: any}) -- line: 366
	-- upvalues: t2 (copy)
	local v68 = t2.new()

	if t7.parameters ~= nil then
		local t8 = {}

		for v70, v71 in t7.parameters do
			t8[v70] = v71
		end

		v68.parameters = t8
	end

	if t7.translations ~= nil then
		local t9 = {}

		for v73, v74 in t7.translations do
			t9[v73] = v74
		end

		v68.translations = t9
	end

	return v68
end

t2.descriptor = {
	name = "CustomPrompt",
	fullName = "roblox.apppageplatform.prompts.v1beta1.CustomPrompt"
}
t1.CustomPrompt = t2
typeRegistry.default:register(t1.CustomPrompt)

local t10 = {}

t10.__index = t10

function t10.new(t11: {[any]: any}?) -- line: 404
	-- upvalues: t10 (copy)
	return (setmetatable({
		key = if t11 ~= nil and t11.key ~= nil then t11.key else "",
		value = if t11 ~= nil and t11.value ~= nil then t11.value else ""
	}, t10))
end
function t10.encode(p4) -- line: 413
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n3 = 0

	if p4.key ~= nil and p4.key ~= "" then
		local v79, v80 = proto.writeTag(buf, n3, 1, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeString(v79, v80, p4.key)
	end

	if p4.value ~= nil and p4.value ~= "" then
		local v81, v82 = proto.writeTag(buf, n3, 2, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeString(v81, v82, p4.value)
	end

	local buf5 = buffer.create(n3)

	buffer.copy(buf5, 0, buf, 0, n3)

	return buf5
end
function t10.decode(p5: buffer) -- line: 432
	-- upvalues: t10 (copy), proto (copy)
	local v85 = t10.new()
	local n4 = 0

	while n4 < buffer.len(p5) do
		local v87, v88

		v87, v88, n4 = proto.readTag(p5, n4)

		if v88 == proto.wireTypes.varint then
			local v89

			v89, n4 = proto.readVarInt(p5, n4)
		elseif v88 == proto.wireTypes.lengthDelimited then
			if v87 == 1 then
				local v90

				v90, n4 = proto.readBuffer(p5, n4)
				v85.key = buffer.tostring(v90)
			elseif v87 == 2 then
				local v91

				v91, n4 = proto.readBuffer(p5, n4)
				v85.value = buffer.tostring(v91)
			else
				local v92, v93 = proto.readVarInt(p5, n4)

				n4 = v93 + v92
			end
		elseif v88 == proto.wireTypes.i32 then
			local v94

			v94, n4 = proto.readFixed32(p5, n4)
		elseif v88 == proto.wireTypes.i64 then
			local v95

			v95, n4 = proto.readFixed64(p5, n4)
		else
			error("Unsupported wire type: " .. v88)
		end
	end

	return v85
end
function t10.jsonEncode(p6) -- line: 480
	local t12 = {}

	if p6.key ~= nil and p6.key ~= "" then
		t12.key = p6.key
	end

	if p6.value ~= nil and p6.value ~= "" then
		t12.value = p6.value
	end

	return t12
end
function t10.jsonDecode(t13: {[any]: any}) -- line: 494
	-- upvalues: t10 (copy)
	local v99 = t10.new()

	if t13.key ~= nil then
		v99.key = t13.key
	end

	if t13.value ~= nil then
		v99.value = t13.value
	end

	return v99
end

t10.descriptor = {
	name = "CustomPrompt_ParametersEntry",
	fullName = "roblox.apppageplatform.prompts.v1beta1.ParametersEntry"
}
t1.CustomPrompt_ParametersEntry = t10
typeRegistry.default:register(t1.CustomPrompt_ParametersEntry)

local t14 = {}

t14.__index = t14

function t14.new(t15: {[any]: any}?) -- line: 522
	-- upvalues: t14 (copy)
	return (setmetatable({
		key = if t15 ~= nil and t15.key ~= nil then t15.key else "",
		value = if t15 ~= nil and t15.value ~= nil then t15.value else ""
	}, t14))
end
function t14.encode(p7) -- line: 531
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n5 = 0

	if p7.key ~= nil and p7.key ~= "" then
		local v104, v105 = proto.writeTag(buf, n5, 1, proto.wireTypes.lengthDelimited)

		buf, n5 = proto.writeString(v104, v105, p7.key)
	end

	if p7.value ~= nil and p7.value ~= "" then
		local v106, v107 = proto.writeTag(buf, n5, 2, proto.wireTypes.lengthDelimited)

		buf, n5 = proto.writeString(v106, v107, p7.value)
	end

	local buf6 = buffer.create(n5)

	buffer.copy(buf6, 0, buf, 0, n5)

	return buf6
end
function t14.decode(p8: buffer) -- line: 550
	-- upvalues: t14 (copy), proto (copy)
	local v110 = t14.new()
	local n6 = 0

	while n6 < buffer.len(p8) do
		local v112, v113

		v112, v113, n6 = proto.readTag(p8, n6)

		if v113 == proto.wireTypes.varint then
			local v114

			v114, n6 = proto.readVarInt(p8, n6)
		elseif v113 == proto.wireTypes.lengthDelimited then
			if v112 == 1 then
				local v115

				v115, n6 = proto.readBuffer(p8, n6)
				v110.key = buffer.tostring(v115)
			elseif v112 == 2 then
				local v116

				v116, n6 = proto.readBuffer(p8, n6)
				v110.value = buffer.tostring(v116)
			else
				local v117, v118 = proto.readVarInt(p8, n6)

				n6 = v118 + v117
			end
		elseif v113 == proto.wireTypes.i32 then
			local v119

			v119, n6 = proto.readFixed32(p8, n6)
		elseif v113 == proto.wireTypes.i64 then
			local v120

			v120, n6 = proto.readFixed64(p8, n6)
		else
			error("Unsupported wire type: " .. v113)
		end
	end

	return v110
end
function t14.jsonEncode(p9) -- line: 598
	local t16 = {}

	if p9.key ~= nil and p9.key ~= "" then
		t16.key = p9.key
	end

	if p9.value ~= nil and p9.value ~= "" then
		t16.value = p9.value
	end

	return t16
end
function t14.jsonDecode(t17: {[any]: any}) -- line: 612
	-- upvalues: t14 (copy)
	local v124 = t14.new()

	if t17.key ~= nil then
		v124.key = t17.key
	end

	if t17.value ~= nil then
		v124.value = t17.value
	end

	return v124
end

t14.descriptor = {
	name = "CustomPrompt_TranslationsEntry",
	fullName = "roblox.apppageplatform.prompts.v1beta1.TranslationsEntry"
}
t1.CustomPrompt_TranslationsEntry = t14
typeRegistry.default:register(t1.CustomPrompt_TranslationsEntry)

local t18 = {}

t18.__index = t18

function t18.new(t19: {[any]: any}?) -- line: 640
	-- upvalues: t18 (copy)
	return (setmetatable({
		page_entries = if t19 ~= nil and t19.page_entries ~= nil then t19.page_entries else {},
		hydration_data = if t19 ~= nil and t19.hydration_data ~= nil then t19.hydration_data else nil,
		templates = if t19 ~= nil and t19.templates ~= nil then t19.templates else {},
		custom_prompts = if t19 ~= nil and t19.custom_prompts ~= nil then t19.custom_prompts else {},
		localized_literals = if t19 ~= nil and t19.localized_literals ~= nil then t19.localized_literals else {}
	}, t18))
end
function t18.encode(p10) -- line: 652
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n7 = 0

	if p10.page_entries ~= nil and #p10.page_entries > 0 then
		for _, v130 in p10.page_entries do
			local v131 = v130:encode()
			local v132, v133 = proto.writeTag(buf, n7, 1, proto.wireTypes.lengthDelimited)

			buf, n7 = proto.writeBuffer(v132, v133, v131, buffer.len(v131))
		end
	end

	if p10.hydration_data ~= nil then
		local v134 = p10.hydration_data:encode()
		local v135, v136 = proto.writeTag(buf, n7, 2, proto.wireTypes.lengthDelimited)

		buf, n7 = proto.writeBuffer(v135, v136, v134, buffer.len(v134))
	end

	if p10.templates ~= nil and next(p10.templates) ~= nil then
		for v137, v138 in p10.templates do
			local buf7 = buffer.create(0)
			local v140, v141 = proto.writeTag(buf7, 0, 1, proto.wireTypes.lengthDelimited)
			local v142, v143 = proto.writeString(v140, v141, v137)
			local v144 = v138:encode()
			local v145, v146 = proto.writeTag(v142, v143, 2, proto.wireTypes.lengthDelimited)
			local v147, v148 = proto.writeBuffer(v145, v146, v144, buffer.len(v144))
			local v149, v150 = proto.writeTag(buf, n7, 3, proto.wireTypes.lengthDelimited)

			buf, n7 = proto.writeBuffer(v149, v150, v147, v148)
		end
	end

	if p10.custom_prompts ~= nil and next(p10.custom_prompts) ~= nil then
		for v151, v152 in p10.custom_prompts do
			local buf8 = buffer.create(0)
			local v154, v155 = proto.writeTag(buf8, 0, 1, proto.wireTypes.lengthDelimited)
			local v156, v157 = proto.writeString(v154, v155, v151)
			local v158 = v152:encode()
			local v159, v160 = proto.writeTag(v156, v157, 2, proto.wireTypes.lengthDelimited)
			local v161, v162 = proto.writeBuffer(v159, v160, v158, buffer.len(v158))
			local v163, v164 = proto.writeTag(buf, n7, 4, proto.wireTypes.lengthDelimited)

			buf, n7 = proto.writeBuffer(v163, v164, v161, v162)
		end
	end

	if p10.localized_literals ~= nil and next(p10.localized_literals) ~= nil then
		for v165, v166 in p10.localized_literals do
			local buf9 = buffer.create(0)
			local v168, v169 = proto.writeTag(buf9, 0, 1, proto.wireTypes.lengthDelimited)
			local v170, v171 = proto.writeString(v168, v169, v165)
			local v172, v173 = proto.writeTag(v170, v171, 2, proto.wireTypes.lengthDelimited)
			local v174, v175 = proto.writeString(v172, v173, v166)
			local v176, v177 = proto.writeTag(buf, n7, 5, proto.wireTypes.lengthDelimited)

			buf, n7 = proto.writeBuffer(v176, v177, v174, v175)
		end
	end

	local buf10 = buffer.create(n7)

	buffer.copy(buf10, 0, buf, 0, n7)

	return buf10
end
function t18.decode(p11: buffer) -- line: 716
	-- upvalues: t18 (copy), proto (copy), page_entry_content (copy), hydration_content (copy), t1 (copy), template_entry (copy)
	local v180 = t18.new()
	local n8 = 0

	while n8 < buffer.len(p11) do
		local v182, v183

		v182, v183, n8 = proto.readTag(p11, n8)

		if v183 == proto.wireTypes.varint then
			local v184

			v184, n8 = proto.readVarInt(p11, n8)
		elseif v183 == proto.wireTypes.lengthDelimited then
			if v182 == 1 then
				local v185

				v185, n8 = proto.readBuffer(p11, n8)
				table.insert(v180.page_entries, page_entry_content.UniversalPageEntry.decode(v185))
			elseif v182 == 2 then
				local v186

				v186, n8 = proto.readBuffer(p11, n8)
				v180.hydration_data = hydration_content.HydrationContent.decode(v186)
			elseif v182 == 3 then
				local v187

				v187, n8 = proto.readBuffer(p11, n8)

				local v188 = t1.GetEligiblePromptsResponse_TemplatesEntry.decode(v187)
				local v189 = template_entry.TemplateEntry.new()

				v180.templates[v188.key or ""] = v188.value or v189
			elseif v182 == 4 then
				local v190

				v190, n8 = proto.readBuffer(p11, n8)

				local v191 = t1.GetEligiblePromptsResponse_CustomPromptsEntry.decode(v190)
				local v192 = t1.CustomPrompt.new()

				v180.custom_prompts[v191.key or ""] = v191.value or v192
			elseif v182 == 5 then
				local v193

				v193, n8 = proto.readBuffer(p11, n8)

				local v194 = t1.GetEligiblePromptsResponse_LocalizedLiteralsEntry.decode(v193)

				v180.localized_literals[v194.key or ""] = v194.value or ""
			else
				local v195, v196 = proto.readVarInt(p11, n8)

				n8 = v196 + v195
			end
		elseif v183 == proto.wireTypes.i32 then
			local v197

			v197, n8 = proto.readFixed32(p11, n8)
		elseif v183 == proto.wireTypes.i64 then
			local v198

			v198, n8 = proto.readFixed64(p11, n8)
		else
			error("Unsupported wire type: " .. v183)
		end
	end

	return v180
end
function t18.jsonEncode(p12) -- line: 804
	local t20 = {}

	if p12.page_entries ~= nil and #p12.page_entries > 0 then
		local t21 = {}

		for _, v203 in p12.page_entries do
			table.insert(t21, v203:jsonEncode())
		end

		t20.pageEntries = t21
	end

	if p12.hydration_data ~= nil then
		t20.hydrationData = p12.hydration_data:jsonEncode()
	end

	if p12.templates ~= nil and next(p12.templates) ~= nil then
		local t22 = {}

		for v205, v206 in p12.templates do
			t22[v205] = v206:jsonEncode()
		end

		t20.templates = t22
	end

	if p12.custom_prompts ~= nil and next(p12.custom_prompts) ~= nil then
		local t23 = {}

		for v208, v209 in p12.custom_prompts do
			t23[v208] = v209:jsonEncode()
		end

		t20.customPrompts = t23
	end

	if p12.localized_literals ~= nil and next(p12.localized_literals) ~= nil then
		local t24 = {}

		for v211, v212 in p12.localized_literals do
			t24[v211] = v212
		end

		t20.localizedLiterals = t24
	end

	return t20
end
function t18.jsonDecode(t25: {[any]: any}) -- line: 846
	-- upvalues: t18 (copy), page_entry_content (copy), hydration_content (copy), template_entry (copy), t1 (copy)
	local v214 = t18.new()

	if t25.page_entries ~= nil then
		local t26 = {}

		for _, v217 in t25.page_entries do
			table.insert(t26, page_entry_content.UniversalPageEntry.jsonDecode(v217))
		end

		v214.page_entries = t26
	end

	if t25.pageEntries ~= nil then
		local t27 = {}

		for _, v220 in t25.pageEntries do
			table.insert(t27, page_entry_content.UniversalPageEntry.jsonDecode(v220))
		end

		v214.page_entries = t27
	end

	if t25.hydration_data ~= nil then
		v214.hydration_data = hydration_content.HydrationContent.jsonDecode(t25.hydration_data)
	end

	if t25.hydrationData ~= nil then
		v214.hydration_data = hydration_content.HydrationContent.jsonDecode(t25.hydrationData)
	end

	if t25.templates ~= nil then
		local t28 = {}

		for v222, v223 in t25.templates do
			t28[v222] = template_entry.TemplateEntry.jsonDecode(v223)
		end

		v214.templates = t28
	end

	if t25.custom_prompts ~= nil then
		local t29 = {}

		for v225, v226 in t25.custom_prompts do
			t29[v225] = t1.CustomPrompt.jsonDecode(v226)
		end

		v214.custom_prompts = t29
	end

	if t25.customPrompts ~= nil then
		local t30 = {}

		for v228, v229 in t25.customPrompts do
			t30[v228] = t1.CustomPrompt.jsonDecode(v229)
		end

		v214.custom_prompts = t30
	end

	if t25.localized_literals ~= nil then
		local t31 = {}

		for v231, v232 in t25.localized_literals do
			t31[v231] = v232
		end

		v214.localized_literals = t31
	end

	if t25.localizedLiterals ~= nil then
		local t32 = {}

		for v234, v235 in t25.localizedLiterals do
			t32[v234] = v235
		end

		v214.localized_literals = t32
	end

	return v214
end

t18.descriptor = {
	name = "GetEligiblePromptsResponse",
	fullName = "roblox.apppageplatform.prompts.v1beta1.GetEligiblePromptsResponse"
}
t1.GetEligiblePromptsResponse = t18
typeRegistry.default:register(t1.GetEligiblePromptsResponse)

local t33 = {}

t33.__index = t33

function t33.new(t34: {[any]: any}?) -- line: 947
	-- upvalues: t33 (copy)
	return (setmetatable({
		key = if t34 ~= nil and t34.key ~= nil then t34.key else "",
		value = if t34 ~= nil and t34.value ~= nil then t34.value else nil
	}, t33))
end
function t33.encode(p13) -- line: 956
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n9 = 0

	if p13.key ~= nil and p13.key ~= "" then
		local v240, v241 = proto.writeTag(buf, n9, 1, proto.wireTypes.lengthDelimited)

		buf, n9 = proto.writeString(v240, v241, p13.key)
	end

	if p13.value ~= nil then
		local v242 = p13.value:encode()
		local v243, v244 = proto.writeTag(buf, n9, 2, proto.wireTypes.lengthDelimited)

		buf, n9 = proto.writeBuffer(v243, v244, v242, buffer.len(v242))
	end

	local buf11 = buffer.create(n9)

	buffer.copy(buf11, 0, buf, 0, n9)

	return buf11
end
function t33.decode(p14: buffer) -- line: 978
	-- upvalues: t33 (copy), proto (copy), template_entry (copy)
	local v247 = t33.new()
	local n10 = 0

	while n10 < buffer.len(p14) do
		local v249, v250

		v249, v250, n10 = proto.readTag(p14, n10)

		if v250 == proto.wireTypes.varint then
			local v251

			v251, n10 = proto.readVarInt(p14, n10)
		elseif v250 == proto.wireTypes.lengthDelimited then
			if v249 == 1 then
				local v252

				v252, n10 = proto.readBuffer(p14, n10)
				v247.key = buffer.tostring(v252)
			elseif v249 == 2 then
				local v253

				v253, n10 = proto.readBuffer(p14, n10)
				v247.value = template_entry.TemplateEntry.decode(v253)
			else
				local v254, v255 = proto.readVarInt(p14, n10)

				n10 = v255 + v254
			end
		elseif v250 == proto.wireTypes.i32 then
			local v256

			v256, n10 = proto.readFixed32(p14, n10)
		elseif v250 == proto.wireTypes.i64 then
			local v257

			v257, n10 = proto.readFixed64(p14, n10)
		else
			error("Unsupported wire type: " .. v250)
		end
	end

	return v247
end
function t33.jsonEncode(p15) -- line: 1028
	local t35 = {}

	if p15.key ~= nil and p15.key ~= "" then
		t35.key = p15.key
	end

	if p15.value ~= nil then
		t35.value = p15.value:jsonEncode()
	end

	return t35
end
function t33.jsonDecode(t36: {[any]: any}) -- line: 1044
	-- upvalues: t33 (copy), template_entry (copy)
	local v261 = t33.new()

	if t36.key ~= nil then
		v261.key = t36.key
	end

	if t36.value ~= nil then
		v261.value = template_entry.TemplateEntry.jsonDecode(t36.value)
	end

	return v261
end

t33.descriptor = {
	name = "GetEligiblePromptsResponse_TemplatesEntry",
	fullName = "roblox.apppageplatform.prompts.v1beta1.TemplatesEntry"
}
t1.GetEligiblePromptsResponse_TemplatesEntry = t33
typeRegistry.default:register(t1.GetEligiblePromptsResponse_TemplatesEntry)

local t37 = {}

t37.__index = t37

function t37.new(t38: {[any]: any}?) -- line: 1074
	-- upvalues: t37 (copy)
	return (setmetatable({
		key = if t38 ~= nil and t38.key ~= nil then t38.key else "",
		value = if t38 ~= nil and t38.value ~= nil then t38.value else nil
	}, t37))
end
function t37.encode(p16) -- line: 1083
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n11 = 0

	if p16.key ~= nil and p16.key ~= "" then
		local v266, v267 = proto.writeTag(buf, n11, 1, proto.wireTypes.lengthDelimited)

		buf, n11 = proto.writeString(v266, v267, p16.key)
	end

	if p16.value ~= nil then
		local v268 = p16.value:encode()
		local v269, v270 = proto.writeTag(buf, n11, 2, proto.wireTypes.lengthDelimited)

		buf, n11 = proto.writeBuffer(v269, v270, v268, buffer.len(v268))
	end

	local buf12 = buffer.create(n11)

	buffer.copy(buf12, 0, buf, 0, n11)

	return buf12
end
function t37.decode(p17: buffer) -- line: 1105
	-- upvalues: t37 (copy), proto (copy), t1 (copy)
	local v273 = t37.new()
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
				v273.value = t1.CustomPrompt.decode(v279)
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
function t37.jsonEncode(p18) -- line: 1155
	local t39 = {}

	if p18.key ~= nil and p18.key ~= "" then
		t39.key = p18.key
	end

	if p18.value ~= nil then
		t39.value = p18.value:jsonEncode()
	end

	return t39
end
function t37.jsonDecode(t40: {[any]: any}) -- line: 1171
	-- upvalues: t37 (copy), t1 (copy)
	local v287 = t37.new()

	if t40.key ~= nil then
		v287.key = t40.key
	end

	if t40.value ~= nil then
		v287.value = t1.CustomPrompt.jsonDecode(t40.value)
	end

	return v287
end

t37.descriptor = {
	name = "GetEligiblePromptsResponse_CustomPromptsEntry",
	fullName = "roblox.apppageplatform.prompts.v1beta1.CustomPromptsEntry"
}
t1.GetEligiblePromptsResponse_CustomPromptsEntry = t37
typeRegistry.default:register(t1.GetEligiblePromptsResponse_CustomPromptsEntry)

local t41 = {}

t41.__index = t41

function t41.new(t42: {[any]: any}?) -- line: 1202
	-- upvalues: t41 (copy)
	return (setmetatable({
		key = if t42 ~= nil and t42.key ~= nil then t42.key else "",
		value = if t42 ~= nil and t42.value ~= nil then t42.value else ""
	}, t41))
end
function t41.encode(p19) -- line: 1214
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n13 = 0

	if p19.key ~= nil and p19.key ~= "" then
		local v292, v293 = proto.writeTag(buf, n13, 1, proto.wireTypes.lengthDelimited)

		buf, n13 = proto.writeString(v292, v293, p19.key)
	end

	if p19.value ~= nil and p19.value ~= "" then
		local v294, v295 = proto.writeTag(buf, n13, 2, proto.wireTypes.lengthDelimited)

		buf, n13 = proto.writeString(v294, v295, p19.value)
	end

	local buf13 = buffer.create(n13)

	buffer.copy(buf13, 0, buf, 0, n13)

	return buf13
end
function t41.decode(p20: buffer) -- line: 1235
	-- upvalues: t41 (copy), proto (copy)
	local v298 = t41.new()
	local n14 = 0

	while n14 < buffer.len(p20) do
		local v300, v301

		v300, v301, n14 = proto.readTag(p20, n14)

		if v301 == proto.wireTypes.varint then
			local v302

			v302, n14 = proto.readVarInt(p20, n14)
		elseif v301 == proto.wireTypes.lengthDelimited then
			if v300 == 1 then
				local v303

				v303, n14 = proto.readBuffer(p20, n14)
				v298.key = buffer.tostring(v303)
			elseif v300 == 2 then
				local v304

				v304, n14 = proto.readBuffer(p20, n14)
				v298.value = buffer.tostring(v304)
			else
				local v305, v306 = proto.readVarInt(p20, n14)

				n14 = v306 + v305
			end
		elseif v301 == proto.wireTypes.i32 then
			local v307

			v307, n14 = proto.readFixed32(p20, n14)
		elseif v301 == proto.wireTypes.i64 then
			local v308

			v308, n14 = proto.readFixed64(p20, n14)
		else
			error("Unsupported wire type: " .. v301)
		end
	end

	return v298
end
function t41.jsonEncode(p21) -- line: 1285
	local t43 = {}

	if p21.key ~= nil and p21.key ~= "" then
		t43.key = p21.key
	end

	if p21.value ~= nil and p21.value ~= "" then
		t43.value = p21.value
	end

	return t43
end
function t41.jsonDecode(t44: {[any]: any}) -- line: 1301
	-- upvalues: t41 (copy)
	local v312 = t41.new()

	if t44.key ~= nil then
		v312.key = t44.key
	end

	if t44.value ~= nil then
		v312.value = t44.value
	end

	return v312
end

t41.descriptor = {
	name = "GetEligiblePromptsResponse_LocalizedLiteralsEntry",
	fullName = "roblox.apppageplatform.prompts.v1beta1.LocalizedLiteralsEntry"
}
t1.GetEligiblePromptsResponse_LocalizedLiteralsEntry = t41
typeRegistry.default:register(t1.GetEligiblePromptsResponse_LocalizedLiteralsEntry)

return {
	CustomPrompt = t1.CustomPrompt,
	GetEligiblePromptsResponse = t1.GetEligiblePromptsResponse
}
