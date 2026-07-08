local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local struct = require(script.Parent.Parent.Parent.Parent.Parent.google.protobuf.struct)
local hydration_data_spec = require(script.Parent.hydration_data_spec)
local prop_condition = require(script.Parent.prop_condition)
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 2813
	-- upvalues: t2 (copy)
	return (setmetatable({
		namespace = if t3 ~= nil and t3.namespace ~= nil then t3.namespace else "",
		key = if t3 ~= nil and t3.key ~= nil then t3.key else "",
		map_key = if t3 ~= nil and t3.map_key ~= nil then t3.map_key else ""
	}, t2))
end
function t2.encode(p1) -- line: 2821
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.namespace ~= nil and p1.namespace ~= "" then
		local v103, v104 = proto.writeTag(buf, n1, 1, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v103, v104, p1.namespace)
	end

	if p1.key ~= nil and p1.key ~= "" then
		local v105, v106 = proto.writeTag(buf, n1, 2, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v105, v106, p1.key)
	end

	if p1.map_key ~= nil and p1.map_key ~= "" then
		local v107, v108 = proto.writeTag(buf, n1, 3, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v107, v108, p1.map_key)
	end

	local buf2 = buffer.create(n1)

	buffer.copy(buf2, 0, buf, 0, n1)

	return buf2
end
function t2.decode(p2: buffer) -- line: 2845
	-- upvalues: t2 (copy), proto (copy)
	local v111 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v113, v114

		v113, v114, n2 = proto.readTag(p2, n2)

		if v114 == proto.wireTypes.varint then
			local v115

			v115, n2 = proto.readVarInt(p2, n2)
		elseif v114 == proto.wireTypes.lengthDelimited then
			if v113 == 1 then
				local v116

				v116, n2 = proto.readBuffer(p2, n2)
				v111.namespace = buffer.tostring(v116)
			elseif v113 == 2 then
				local v117

				v117, n2 = proto.readBuffer(p2, n2)
				v111.key = buffer.tostring(v117)
			elseif v113 == 3 then
				local v118

				v118, n2 = proto.readBuffer(p2, n2)
				v111.map_key = buffer.tostring(v118)
			else
				local v119, v120 = proto.readVarInt(p2, n2)

				n2 = v120 + v119
			end
		elseif v114 == proto.wireTypes.i32 then
			local v121

			v121, n2 = proto.readFixed32(p2, n2)
		elseif v114 == proto.wireTypes.i64 then
			local v122

			v122, n2 = proto.readFixed64(p2, n2)
		else
			error("Unsupported wire type: " .. v114)
		end
	end

	return v111
end
function t2.jsonEncode(p3) -- line: 2898
	local t4 = {}

	if p3.namespace ~= nil and p3.namespace ~= "" then
		t4.namespace = p3.namespace
	end

	if p3.key ~= nil and p3.key ~= "" then
		t4.key = p3.key
	end

	if p3.map_key ~= nil and p3.map_key ~= "" then
		t4.mapKey = p3.map_key
	end

	return t4
end
function t2.jsonDecode(t5: {[any]: any}) -- line: 2916
	-- upvalues: t2 (copy)
	local v126 = t2.new()

	if t5.namespace ~= nil then
		v126.namespace = t5.namespace
	end

	if t5.key ~= nil then
		v126.key = t5.key
	end

	if t5.map_key ~= nil then
		v126.map_key = t5.map_key
	end

	if t5.mapKey ~= nil then
		v126.map_key = t5.mapKey
	end

	return v126
end

t2.descriptor = {
	name = "TranslationRef",
	fullName = "roblox.apppageplatform.shared.v1beta1.TranslationRef"
}
t1.TranslationRef = t2
typeRegistry.default:register(t1.TranslationRef)

local t6 = {}

t6.__index = t6

function t6.new(t7: {[any]: any}?) -- line: 2952
	-- upvalues: t6 (copy)
	return (setmetatable({
		str = if t7 ~= nil and t7.str ~= nil then t7.str else "",
		args = if t7 ~= nil and t7.args ~= nil then t7.args else {},
		translation = if t7 ~= nil and t7.translation ~= nil then t7.translation else nil
	}, t6))
end
function t6.encode(p4) -- line: 2960
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n3 = 0

	if p4.str ~= nil and p4.str ~= "" then
		local v131, v132 = proto.writeTag(buf, n3, 1, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeString(v131, v132, p4.str)
	end

	if p4.args ~= nil and next(p4.args) ~= nil then
		for v133, v134 in p4.args do
			local buf3 = buffer.create(0)
			local v136, v137 = proto.writeTag(buf3, 0, 1, proto.wireTypes.lengthDelimited)
			local v138, v139 = proto.writeString(v136, v137, v133)
			local v140 = v134:encode()
			local v141, v142 = proto.writeTag(v138, v139, 2, proto.wireTypes.lengthDelimited)
			local v143, v144 = proto.writeBuffer(v141, v142, v140, buffer.len(v140))
			local v145, v146 = proto.writeTag(buf, n3, 2, proto.wireTypes.lengthDelimited)

			buf, n3 = proto.writeBuffer(v145, v146, v143, v144)
		end
	end

	if p4.translation ~= nil then
		local v147 = p4.translation:encode()
		local v148, v149 = proto.writeTag(buf, n3, 3, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeBuffer(v148, v149, v147, buffer.len(v147))
	end

	local buf4 = buffer.create(n3)

	buffer.copy(buf4, 0, buf, 0, n3)

	return buf4
end
function t6.decode(p5: buffer) -- line: 2994
	-- upvalues: t6 (copy), proto (copy), t1 (copy)
	local v152 = t6.new()
	local n4 = 0

	while n4 < buffer.len(p5) do
		local v154, v155

		v154, v155, n4 = proto.readTag(p5, n4)

		if v155 == proto.wireTypes.varint then
			local v156

			v156, n4 = proto.readVarInt(p5, n4)
		elseif v155 == proto.wireTypes.lengthDelimited then
			if v154 == 1 then
				local v157

				v157, n4 = proto.readBuffer(p5, n4)
				v152.str = buffer.tostring(v157)
			elseif v154 == 2 then
				local v158

				v158, n4 = proto.readBuffer(p5, n4)

				local v159 = t1.StringFormat_ArgsEntry.decode(v158)
				local v160 = t1.StringFormat_FormatArg.new()

				v152.args[v159.key or ""] = v159.value or v160
			elseif v154 == 3 then
				local v161

				v161, n4 = proto.readBuffer(p5, n4)
				v152.translation = t1.TranslationRef.decode(v161)
			else
				local v162, v163 = proto.readVarInt(p5, n4)

				n4 = v163 + v162
			end
		elseif v155 == proto.wireTypes.i32 then
			local v164

			v164, n4 = proto.readFixed32(p5, n4)
		elseif v155 == proto.wireTypes.i64 then
			local v165

			v165, n4 = proto.readFixed64(p5, n4)
		else
			error("Unsupported wire type: " .. v155)
		end
	end

	return v152
end
function t6.jsonEncode(p6) -- line: 3054
	local t8 = {}

	if p6.str ~= nil and p6.str ~= "" then
		t8.str = p6.str
	end

	if p6.args ~= nil and next(p6.args) ~= nil then
		local t9 = {}

		for v169, v170 in p6.args do
			t9[v169] = v170:jsonEncode()
		end

		t8.args = t9
	end

	if p6.translation ~= nil then
		t8.translation = p6.translation:jsonEncode()
	end

	return t8
end
function t6.jsonDecode(t10: {[any]: any}) -- line: 3076
	-- upvalues: t6 (copy), t1 (copy)
	local v172 = t6.new()

	if t10.str ~= nil then
		v172.str = t10.str
	end

	if t10.args ~= nil then
		local t11 = {}

		for v174, v175 in t10.args do
			t11[v174] = t1.StringFormat_FormatArg.jsonDecode(v175)
		end

		v172.args = t11
	end

	if t10.translation ~= nil then
		v172.translation = t1.TranslationRef.jsonDecode(t10.translation)
	end

	return v172
end

t6.descriptor = {
	name = "StringFormat",
	fullName = "roblox.apppageplatform.shared.v1beta1.StringFormat"
}
t1.StringFormat = t6
typeRegistry.default:register(t1.StringFormat)

local t12 = {}

t12.__index = t12

function t12.new(t13: {[any]: any}?) -- line: 3113
	-- upvalues: t12 (copy)
	return (setmetatable({
		kind = if t13 ~= nil and t13.kind ~= nil then t13.kind else nil,
		formatter = if t13 ~= nil and t13.formatter ~= nil then t13.formatter else nil
	}, t12))
end
function t12.encode(p7) -- line: 3120
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n5 = 0

	if p7.kind ~= nil then
		if p7.kind.type == "literal" then
			local v180, v181 = proto.writeTag(buf, n5, 1, proto.wireTypes.lengthDelimited)

			buf, n5 = proto.writeString(v180, v181, p7.kind.value)
		elseif p7.kind.type == "binding_path" then
			local v182, v183 = proto.writeTag(buf, n5, 2, proto.wireTypes.lengthDelimited)

			buf, n5 = proto.writeString(v182, v183, p7.kind.value)
		end
	end

	if p7.formatter ~= nil then
		local v184 = p7.formatter:encode()
		local v185, v186 = proto.writeTag(buf, n5, 3, proto.wireTypes.lengthDelimited)

		buf, n5 = proto.writeBuffer(v185, v186, v184, buffer.len(v184))
	end

	local buf5 = buffer.create(n5)

	buffer.copy(buf5, 0, buf, 0, n5)

	return buf5
end
function t12.decode(p8: buffer) -- line: 3145
	-- upvalues: t12 (copy), proto (copy), t1 (copy)
	local v189 = t12.new()
	local n6 = 0

	while n6 < buffer.len(p8) do
		local v191, v192

		v191, v192, n6 = proto.readTag(p8, n6)

		if v192 == proto.wireTypes.varint then
			local v193

			v193, n6 = proto.readVarInt(p8, n6)
		elseif v192 == proto.wireTypes.lengthDelimited then
			if v191 == 1 then
				local v194

				v194, n6 = proto.readBuffer(p8, n6)
				v189.kind = {
					type = "literal",
					value = buffer.tostring(v194)
				}
			elseif v191 == 2 then
				local v195

				v195, n6 = proto.readBuffer(p8, n6)
				v189.kind = {
					type = "binding_path",
					value = buffer.tostring(v195)
				}
			elseif v191 == 3 then
				local v196

				v196, n6 = proto.readBuffer(p8, n6)
				v189.formatter = t1.StringFormat_FormatArg_Formatter.decode(v196)
			else
				local v197, v198 = proto.readVarInt(p8, n6)

				n6 = v198 + v197
			end
		elseif v192 == proto.wireTypes.i32 then
			local v199

			v199, n6 = proto.readFixed32(p8, n6)
		elseif v192 == proto.wireTypes.i64 then
			local v200

			v200, n6 = proto.readFixed64(p8, n6)
		else
			error("Unsupported wire type: " .. v192)
		end
	end

	return v189
end
function t12.jsonEncode(p9) -- line: 3198
	local t14 = {}

	if p9.kind ~= nil then
		if p9.kind.type == "literal" then
			t14.literal = p9.kind.value
		elseif p9.kind.type == "binding_path" then
			t14.bindingPath = p9.kind.value
		end
	end

	if p9.formatter ~= nil then
		t14.formatter = p9.formatter:jsonEncode()
	end

	return t14
end
function t12.jsonDecode(t15: {[any]: any}) -- line: 3216
	-- upvalues: t12 (copy), t1 (copy)
	local v204 = t12.new()

	if t15.literal ~= nil then
		v204.kind = {
			type = "literal",
			value = t15.literal
		}
	end

	if t15.binding_path ~= nil then
		v204.kind = {
			type = "binding_path",
			value = t15.binding_path
		}
	end

	if t15.bindingPath ~= nil then
		v204.kind = {
			type = "binding_path",
			value = t15.bindingPath
		}
	end

	if t15.formatter ~= nil then
		v204.formatter = t1.StringFormat_FormatArg_Formatter.jsonDecode(t15.formatter)
	end

	return v204
end

t12.descriptor = {
	name = "StringFormat_FormatArg",
	fullName = "roblox.apppageplatform.shared.v1beta1.FormatArg"
}
t1.StringFormat_FormatArg = t12
typeRegistry.default:register(t1.StringFormat_FormatArg)

local t16 = {}

t16.__index = t16

function t16.new(t17: {[any]: any}?) -- line: 3252
	-- upvalues: t1 (copy), t16 (copy)
	return (setmetatable({
		type = if t17 ~= nil and t17.type ~= nil then t17.type else assert(t1.StringFormat_FormatArg_Formatter_Type.fromNumber(0), "Enum has no 0 default"),
		config = if t17 ~= nil and t17.config ~= nil then t17.config else nil
	}, t16))
end
function t16.encode(p10) -- line: 3263
	-- upvalues: t1 (copy), proto (copy)
	local buf = buffer.create(0)
	local n7 = 0

	if p10.type ~= nil and (p10.type ~= nil and p10.type ~= 0 or p10.type ~= t1.StringFormat_FormatArg_Formatter_Type.fromNumber(0)) then
		local v209, v210 = proto.writeTag(buf, n7, 1, proto.wireTypes.varint)

		buf, n7 = proto.writeVarInt(v209, v210, t1.StringFormat_FormatArg_Formatter_Type.toNumber(p10.type))
	end

	if p10.config ~= nil and p10.config.type == "date_config" then
		local v211 = p10.config.value:encode()
		local v212, v213 = proto.writeTag(buf, n7, 2, proto.wireTypes.lengthDelimited)

		buf, n7 = proto.writeBuffer(v212, v213, v211, buffer.len(v211))
	end

	local buf6 = buffer.create(n7)

	buffer.copy(buf6, 0, buf, 0, n7)

	return buf6
end
function t16.decode(p11: buffer) -- line: 3295
	-- upvalues: t16 (copy), proto (copy), t1 (copy)
	local v216 = t16.new()
	local n8 = 0

	while n8 < buffer.len(p11) do
		local v218, v219

		v218, v219, n8 = proto.readTag(p11, n8)

		if v219 == proto.wireTypes.varint then
			if v218 == 1 then
				local v220

				v220, n8 = proto.readVarIntI32(p11, n8)
				v216.type = t1.StringFormat_FormatArg_Formatter_Type.fromNumber(v220) or v220
			else
				local v221

				v221, n8 = proto.readVarInt(p11, n8)
			end
		elseif v219 == proto.wireTypes.lengthDelimited then
			if v218 == 2 then
				local v222

				v222, n8 = proto.readBuffer(p11, n8)
				v216.config = {
					type = "date_config",
					value = t1.StringFormat_FormatArg_Formatter_DateConfig.decode(v222)
				}
			else
				local v223, v224 = proto.readVarInt(p11, n8)

				n8 = v224 + v223
			end
		elseif v219 == proto.wireTypes.i32 then
			local v225

			v225, n8 = proto.readFixed32(p11, n8)
		elseif v219 == proto.wireTypes.i64 then
			local v226

			v226, n8 = proto.readFixed64(p11, n8)
		else
			error("Unsupported wire type: " .. v219)
		end
	end

	return v216
end
function t16.jsonEncode(p12) -- line: 3346
	-- upvalues: t1 (copy)
	local t18 = {}

	if p12.type ~= nil and (p12.type ~= nil and p12.type ~= 0 or p12.type ~= t1.StringFormat_FormatArg_Formatter_Type.fromNumber(0)) then
		t18.type = if typeof(p12.type) ~= "number" then t1.StringFormat_FormatArg_Formatter_Type.toNumber(p12.type) else p12.type
	end

	if p12.config ~= nil and p12.config.type == "date_config" then
		t18.dateConfig = p12.config.value:jsonEncode()
	end

	return t18
end
function t16.jsonDecode(t19: {[any]: any}) -- line: 3370
	-- upvalues: t16 (copy), t1 (copy)
	local v230 = t16.new()

	if t19.type ~= nil then
		v230.type = if typeof(t19.type) ~= "number" then t1.StringFormat_FormatArg_Formatter_Type.fromName(t19.type) or t19.type else t1.StringFormat_FormatArg_Formatter_Type.fromNumber(t19.type) or t19.type
	end

	if t19.date_config ~= nil then
		v230.config = {
			type = "date_config",
			value = t1.StringFormat_FormatArg_Formatter_DateConfig.jsonDecode(t19.date_config)
		}
	end

	if t19.dateConfig ~= nil then
		v230.config = {
			type = "date_config",
			value = t1.StringFormat_FormatArg_Formatter_DateConfig.jsonDecode(t19.dateConfig)
		}
	end

	return v230
end

t16.descriptor = {
	name = "StringFormat_FormatArg_Formatter",
	fullName = "roblox.apppageplatform.shared.v1beta1.Formatter"
}
t1.StringFormat_FormatArg_Formatter = t16
typeRegistry.default:register(t1.StringFormat_FormatArg_Formatter)

local t20 = {}

t20.__index = t20

function t20.new(t21: {[any]: any}?) -- line: 3412
	-- upvalues: t20 (copy)
	return (setmetatable({
		pattern = if t21 ~= nil and t21.pattern ~= nil then t21.pattern else ""
	}, t20))
end
function t20.encode(p13) -- line: 3420
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n9 = 0

	if p13.pattern ~= nil and p13.pattern ~= "" then
		local v235, v236 = proto.writeTag(buf, n9, 1, proto.wireTypes.lengthDelimited)

		buf, n9 = proto.writeString(v235, v236, p13.pattern)
	end

	local buf7 = buffer.create(n9)

	buffer.copy(buf7, 0, buf, 0, n9)

	return buf7
end
function t20.decode(p14: buffer) -- line: 3436
	-- upvalues: t20 (copy), proto (copy)
	local v239 = t20.new()
	local n10 = 0

	while n10 < buffer.len(p14) do
		local v241, v242

		v241, v242, n10 = proto.readTag(p14, n10)

		if v242 == proto.wireTypes.varint then
			local v243

			v243, n10 = proto.readVarInt(p14, n10)
		elseif v242 == proto.wireTypes.lengthDelimited then
			if v241 == 1 then
				local v244

				v244, n10 = proto.readBuffer(p14, n10)
				v239.pattern = buffer.tostring(v244)
			else
				local v245, v246 = proto.readVarInt(p14, n10)

				n10 = v246 + v245
			end
		elseif v242 == proto.wireTypes.i32 then
			local v247

			v247, n10 = proto.readFixed32(p14, n10)
		elseif v242 == proto.wireTypes.i64 then
			local v248

			v248, n10 = proto.readFixed64(p14, n10)
		else
			error("Unsupported wire type: " .. v242)
		end
	end

	return v239
end
function t20.jsonEncode(p15) -- line: 3481
	local t22 = {}

	if p15.pattern ~= nil and p15.pattern ~= "" then
		t22.pattern = p15.pattern
	end

	return t22
end
function t20.jsonDecode(t23: {[any]: any}) -- line: 3493
	-- upvalues: t20 (copy)
	local v252 = t20.new()

	if t23.pattern ~= nil then
		v252.pattern = t23.pattern
	end

	return v252
end

t20.descriptor = {
	name = "StringFormat_FormatArg_Formatter_DateConfig",
	fullName = "roblox.apppageplatform.shared.v1beta1.DateConfig"
}
t1.StringFormat_FormatArg_Formatter_DateConfig = t20
typeRegistry.default:register(t1.StringFormat_FormatArg_Formatter_DateConfig)
t1.StringFormat_FormatArg_Formatter_Type = {
	fromNumber = function(n11: number) -- line: 3516
		if n11 == 0 then
			return "TYPE_INVALID"
		end

		if n11 == 1 then
			return "TYPE_NUMBER_ABBREVIATE"
		end

		if n11 == 2 then
			return "TYPE_NUMBER_LOCALIZE"
		end

		if n11 == 3 then
			return "TYPE_DATE_FORMAT"
		end

		return nil
	end,
	toNumber = function(p16) -- line: 3530
		if p16 == "TYPE_INVALID" then
			return 0
		end

		if p16 == "TYPE_NUMBER_ABBREVIATE" then
			return 1
		end

		if p16 == "TYPE_NUMBER_LOCALIZE" then
			return 2
		end

		if p16 == "TYPE_DATE_FORMAT" then
			return 3
		end

		return p16
	end,
	fromName = function(s1: string) -- line: 3544
		if s1 == "TYPE_INVALID" then
			return "TYPE_INVALID"
		end

		if s1 == "TYPE_NUMBER_ABBREVIATE" then
			return "TYPE_NUMBER_ABBREVIATE"
		end

		if s1 == "TYPE_NUMBER_LOCALIZE" then
			return "TYPE_NUMBER_LOCALIZE"
		end

		if s1 == "TYPE_DATE_FORMAT" then
			return "TYPE_DATE_FORMAT"
		end

		return nil
	end
}

local t24 = {}

t24.__index = t24

function t24.new(t25: {[any]: any}?) -- line: 3563
	-- upvalues: t24 (copy)
	return (setmetatable({
		key = if t25 ~= nil and t25.key ~= nil then t25.key else "",
		value = if t25 ~= nil and t25.value ~= nil then t25.value else nil
	}, t24))
end
function t24.encode(p17) -- line: 3570
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n12 = 0

	if p17.key ~= nil and p17.key ~= "" then
		local v260, v261 = proto.writeTag(buf, n12, 1, proto.wireTypes.lengthDelimited)

		buf, n12 = proto.writeString(v260, v261, p17.key)
	end

	if p17.value ~= nil then
		local v262 = p17.value:encode()
		local v263, v264 = proto.writeTag(buf, n12, 2, proto.wireTypes.lengthDelimited)

		buf, n12 = proto.writeBuffer(v263, v264, v262, buffer.len(v262))
	end

	local buf8 = buffer.create(n12)

	buffer.copy(buf8, 0, buf, 0, n12)

	return buf8
end
function t24.decode(p18: buffer) -- line: 3590
	-- upvalues: t24 (copy), proto (copy), t1 (copy)
	local v267 = t24.new()
	local n13 = 0

	while n13 < buffer.len(p18) do
		local v269, v270

		v269, v270, n13 = proto.readTag(p18, n13)

		if v270 == proto.wireTypes.varint then
			local v271

			v271, n13 = proto.readVarInt(p18, n13)
		elseif v270 == proto.wireTypes.lengthDelimited then
			if v269 == 1 then
				local v272

				v272, n13 = proto.readBuffer(p18, n13)
				v267.key = buffer.tostring(v272)
			elseif v269 == 2 then
				local v273

				v273, n13 = proto.readBuffer(p18, n13)
				v267.value = t1.StringFormat_FormatArg.decode(v273)
			else
				local v274, v275 = proto.readVarInt(p18, n13)

				n13 = v275 + v274
			end
		elseif v270 == proto.wireTypes.i32 then
			local v276

			v276, n13 = proto.readFixed32(p18, n13)
		elseif v270 == proto.wireTypes.i64 then
			local v277

			v277, n13 = proto.readFixed64(p18, n13)
		else
			error("Unsupported wire type: " .. v270)
		end
	end

	return v267
end
function t24.jsonEncode(p19) -- line: 3638
	local t26 = {}

	if p19.key ~= nil and p19.key ~= "" then
		t26.key = p19.key
	end

	if p19.value ~= nil then
		t26.value = p19.value:jsonEncode()
	end

	return t26
end
function t24.jsonDecode(t27: {[any]: any}) -- line: 3652
	-- upvalues: t24 (copy), t1 (copy)
	local v281 = t24.new()

	if t27.key ~= nil then
		v281.key = t27.key
	end

	if t27.value ~= nil then
		v281.value = t1.StringFormat_FormatArg.jsonDecode(t27.value)
	end

	return v281
end

t24.descriptor = {
	name = "StringFormat_ArgsEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.ArgsEntry"
}
t1.StringFormat_ArgsEntry = t24
typeRegistry.default:register(t1.StringFormat_ArgsEntry)

local t28 = {}

t28.__index = t28

function t28.new(t29: {[any]: any}?) -- line: 3680
	-- upvalues: t28 (copy)
	return (setmetatable({
		kind = if t29 ~= nil and t29.kind ~= nil then t29.kind else nil
	}, t28))
end
function t28.encode(p20) -- line: 3686
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n14 = 0

	if p20.kind ~= nil then
		if p20.kind.type == "literal" then
			local v286, v287 = proto.writeTag(buf, n14, 1, proto.wireTypes.lengthDelimited)

			buf, n14 = proto.writeString(v286, v287, p20.kind.value)
		elseif p20.kind.type == "binding_path" then
			local v288, v289 = proto.writeTag(buf, n14, 2, proto.wireTypes.lengthDelimited)

			buf, n14 = proto.writeString(v288, v289, p20.kind.value)
		elseif p20.kind.type == "token" then
			local v290, v291 = proto.writeTag(buf, n14, 3, proto.wireTypes.lengthDelimited)

			buf, n14 = proto.writeString(v290, v291, p20.kind.value)
		elseif p20.kind.type == "format" then
			local v292 = p20.kind.value:encode()
			local v293, v294 = proto.writeTag(buf, n14, 4, proto.wireTypes.lengthDelimited)

			buf, n14 = proto.writeBuffer(v293, v294, v292, buffer.len(v292))
		elseif p20.kind.type == "conditional" then
			local v295 = p20.kind.value:encode()
			local v296, v297 = proto.writeTag(buf, n14, 5, proto.wireTypes.lengthDelimited)

			buf, n14 = proto.writeBuffer(v296, v297, v295, buffer.len(v295))
		elseif p20.kind.type == "translation" then
			local v298 = p20.kind.value:encode()
			local v299, v300 = proto.writeTag(buf, n14, 6, proto.wireTypes.lengthDelimited)

			buf, n14 = proto.writeBuffer(v299, v300, v298, buffer.len(v298))
		end
	end

	local buf9 = buffer.create(n14)

	buffer.copy(buf9, 0, buf, 0, n14)

	return buf9
end
function t28.decode(p21: buffer) -- line: 3720
	-- upvalues: t28 (copy), proto (copy), t1 (copy)
	local v303 = t28.new()
	local n15 = 0

	while n15 < buffer.len(p21) do
		local v305, v306

		v305, v306, n15 = proto.readTag(p21, n15)

		if v306 == proto.wireTypes.varint then
			local v307

			v307, n15 = proto.readVarInt(p21, n15)
		elseif v306 == proto.wireTypes.lengthDelimited then
			if v305 == 1 then
				local v308

				v308, n15 = proto.readBuffer(p21, n15)
				v303.kind = {
					type = "literal",
					value = buffer.tostring(v308)
				}
			elseif v305 == 2 then
				local v309

				v309, n15 = proto.readBuffer(p21, n15)
				v303.kind = {
					type = "binding_path",
					value = buffer.tostring(v309)
				}
			elseif v305 == 3 then
				local v310

				v310, n15 = proto.readBuffer(p21, n15)
				v303.kind = {
					type = "token",
					value = buffer.tostring(v310)
				}
			elseif v305 == 4 then
				local v311

				v311, n15 = proto.readBuffer(p21, n15)
				v303.kind = {
					type = "format",
					value = t1.StringFormat.decode(v311)
				}
			elseif v305 == 5 then
				local v312

				v312, n15 = proto.readBuffer(p21, n15)
				v303.kind = {
					type = "conditional",
					value = t1.StringProp_ConditionalOptions.decode(v312)
				}
			elseif v305 == 6 then
				local v313

				v313, n15 = proto.readBuffer(p21, n15)
				v303.kind = {
					type = "translation",
					value = t1.TranslationRef.decode(v313)
				}
			else
				local v314, v315 = proto.readVarInt(p21, n15)

				n15 = v315 + v314
			end
		elseif v306 == proto.wireTypes.i32 then
			local v316

			v316, n15 = proto.readFixed32(p21, n15)
		elseif v306 == proto.wireTypes.i64 then
			local v317

			v317, n15 = proto.readFixed64(p21, n15)
		else
			error("Unsupported wire type: " .. v306)
		end
	end

	return v303
end
function t28.jsonEncode(p22) -- line: 3788
	local t30 = {}

	if p22.kind ~= nil then
		if p22.kind.type == "literal" then
			t30.literal = p22.kind.value

			return t30
		end

		if p22.kind.type == "binding_path" then
			t30.bindingPath = p22.kind.value

			return t30
		end

		if p22.kind.type == "token" then
			t30.token = p22.kind.value

			return t30
		end

		if p22.kind.type == "format" then
			t30.format = p22.kind.value:jsonEncode()

			return t30
		end

		if p22.kind.type == "conditional" then
			t30.conditional = p22.kind.value:jsonEncode()

			return t30
		end

		if p22.kind.type == "translation" then
			t30.translation = p22.kind.value:jsonEncode()
		end
	end

	return t30
end
function t28.jsonDecode(t31: {[any]: any}) -- line: 3810
	-- upvalues: t28 (copy), t1 (copy)
	local v321 = t28.new()

	if t31.literal ~= nil then
		v321.kind = {
			type = "literal",
			value = t31.literal
		}
	end

	if t31.binding_path ~= nil then
		v321.kind = {
			type = "binding_path",
			value = t31.binding_path
		}
	end

	if t31.bindingPath ~= nil then
		v321.kind = {
			type = "binding_path",
			value = t31.bindingPath
		}
	end

	if t31.token ~= nil then
		v321.kind = {
			type = "token",
			value = t31.token
		}
	end

	if t31.format ~= nil then
		v321.kind = {
			type = "format",
			value = t1.StringFormat.jsonDecode(t31.format)
		}
	end

	if t31.conditional ~= nil then
		v321.kind = {
			type = "conditional",
			value = t1.StringProp_ConditionalOptions.jsonDecode(t31.conditional)
		}
	end

	if t31.translation ~= nil then
		v321.kind = {
			type = "translation",
			value = t1.TranslationRef.jsonDecode(t31.translation)
		}
	end

	return v321
end

t28.descriptor = {
	name = "StringProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.StringProp"
}
t1.StringProp = t28
typeRegistry.default:register(t1.StringProp)

local t32 = {}

t32.__index = t32

function t32.new(t33: {[any]: any}?) -- line: 3859
	-- upvalues: t32 (copy)
	return (setmetatable({
		condition = if t33 ~= nil and t33.condition ~= nil then t33.condition else nil,
		kind = if t33 ~= nil and t33.kind ~= nil then t33.kind else nil
	}, t32))
end
function t32.encode(p23) -- line: 3868
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n16 = 0

	if p23.condition ~= nil then
		local v326 = p23.condition:encode()
		local v327, v328 = proto.writeTag(buf, n16, 1, proto.wireTypes.lengthDelimited)

		buf, n16 = proto.writeBuffer(v327, v328, v326, buffer.len(v326))
	end

	if p23.kind ~= nil then
		if p23.kind.type == "literal" then
			local v329, v330 = proto.writeTag(buf, n16, 2, proto.wireTypes.lengthDelimited)

			buf, n16 = proto.writeString(v329, v330, p23.kind.value)
		elseif p23.kind.type == "binding_path" then
			local v331, v332 = proto.writeTag(buf, n16, 3, proto.wireTypes.lengthDelimited)

			buf, n16 = proto.writeString(v331, v332, p23.kind.value)
		elseif p23.kind.type == "token" then
			local v333, v334 = proto.writeTag(buf, n16, 4, proto.wireTypes.lengthDelimited)

			buf, n16 = proto.writeString(v333, v334, p23.kind.value)
		elseif p23.kind.type == "format" then
			local v335 = p23.kind.value:encode()
			local v336, v337 = proto.writeTag(buf, n16, 5, proto.wireTypes.lengthDelimited)

			buf, n16 = proto.writeBuffer(v336, v337, v335, buffer.len(v335))
		elseif p23.kind.type == "translation" then
			local v338 = p23.kind.value:encode()
			local v339, v340 = proto.writeTag(buf, n16, 6, proto.wireTypes.lengthDelimited)

			buf, n16 = proto.writeBuffer(v339, v340, v338, buffer.len(v338))
		end
	end

	local buf10 = buffer.create(n16)

	buffer.copy(buf10, 0, buf, 0, n16)

	return buf10
end
function t32.decode(p24: buffer) -- line: 3904
	-- upvalues: t32 (copy), proto (copy), prop_condition (copy), t1 (copy)
	local v343 = t32.new()
	local n17 = 0

	while n17 < buffer.len(p24) do
		local v345, v346

		v345, v346, n17 = proto.readTag(p24, n17)

		if v346 == proto.wireTypes.varint then
			local v347

			v347, n17 = proto.readVarInt(p24, n17)
		elseif v346 == proto.wireTypes.lengthDelimited then
			if v345 == 1 then
				local v348

				v348, n17 = proto.readBuffer(p24, n17)
				v343.condition = prop_condition.PropCondition.decode(v348)
			elseif v345 == 2 then
				local v349

				v349, n17 = proto.readBuffer(p24, n17)
				v343.kind = {
					type = "literal",
					value = buffer.tostring(v349)
				}
			elseif v345 == 3 then
				local v350

				v350, n17 = proto.readBuffer(p24, n17)
				v343.kind = {
					type = "binding_path",
					value = buffer.tostring(v350)
				}
			elseif v345 == 4 then
				local v351

				v351, n17 = proto.readBuffer(p24, n17)
				v343.kind = {
					type = "token",
					value = buffer.tostring(v351)
				}
			elseif v345 == 5 then
				local v352

				v352, n17 = proto.readBuffer(p24, n17)
				v343.kind = {
					type = "format",
					value = t1.StringFormat.decode(v352)
				}
			elseif v345 == 6 then
				local v353

				v353, n17 = proto.readBuffer(p24, n17)
				v343.kind = {
					type = "translation",
					value = t1.TranslationRef.decode(v353)
				}
			else
				local v354, v355 = proto.readVarInt(p24, n17)

				n17 = v355 + v354
			end
		elseif v346 == proto.wireTypes.i32 then
			local v356

			v356, n17 = proto.readFixed32(p24, n17)
		elseif v346 == proto.wireTypes.i64 then
			local v357

			v357, n17 = proto.readFixed64(p24, n17)
		else
			error("Unsupported wire type: " .. v346)
		end
	end

	return v343
end
function t32.jsonEncode(p25) -- line: 3972
	local t34 = {}

	if p25.condition ~= nil then
		t34.condition = p25.condition:jsonEncode()
	end

	if p25.kind ~= nil then
		if p25.kind.type == "literal" then
			t34.literal = p25.kind.value

			return t34
		end

		if p25.kind.type == "binding_path" then
			t34.bindingPath = p25.kind.value

			return t34
		end

		if p25.kind.type == "token" then
			t34.token = p25.kind.value

			return t34
		end

		if p25.kind.type == "format" then
			t34.format = p25.kind.value:jsonEncode()

			return t34
		end

		if p25.kind.type == "translation" then
			t34.translation = p25.kind.value:jsonEncode()
		end
	end

	return t34
end
function t32.jsonDecode(t35: {[any]: any}) -- line: 3996
	-- upvalues: t32 (copy), prop_condition (copy), t1 (copy)
	local v361 = t32.new()

	if t35.condition ~= nil then
		v361.condition = prop_condition.PropCondition.jsonDecode(t35.condition)
	end

	if t35.literal ~= nil then
		v361.kind = {
			type = "literal",
			value = t35.literal
		}
	end

	if t35.binding_path ~= nil then
		v361.kind = {
			type = "binding_path",
			value = t35.binding_path
		}
	end

	if t35.bindingPath ~= nil then
		v361.kind = {
			type = "binding_path",
			value = t35.bindingPath
		}
	end

	if t35.token ~= nil then
		v361.kind = {
			type = "token",
			value = t35.token
		}
	end

	if t35.format ~= nil then
		v361.kind = {
			type = "format",
			value = t1.StringFormat.jsonDecode(t35.format)
		}
	end

	if t35.translation ~= nil then
		v361.kind = {
			type = "translation",
			value = t1.TranslationRef.jsonDecode(t35.translation)
		}
	end

	return v361
end

t32.descriptor = {
	name = "StringProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}
t1.StringProp_ConditionalOption = t32
typeRegistry.default:register(t1.StringProp_ConditionalOption)

local t36 = {}

t36.__index = t36

function t36.new(t37: {[any]: any}?) -- line: 4045
	-- upvalues: t36 (copy)
	return (setmetatable({
		options = if t37 ~= nil and t37.options ~= nil then t37.options else {}
	}, t36))
end
function t36.encode(p26) -- line: 4053
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n18 = 0

	if p26.options ~= nil and #p26.options > 0 then
		for _, v367 in p26.options do
			local v368 = v367:encode()
			local v369, v370 = proto.writeTag(buf, n18, 1, proto.wireTypes.lengthDelimited)

			buf, n18 = proto.writeBuffer(v369, v370, v368, buffer.len(v368))
		end
	end

	local buf11 = buffer.create(n18)

	buffer.copy(buf11, 0, buf, 0, n18)

	return buf11
end
function t36.decode(p27: buffer) -- line: 4070
	-- upvalues: t36 (copy), proto (copy), t1 (copy)
	local v373 = t36.new()
	local n19 = 0

	while n19 < buffer.len(p27) do
		local v375, v376

		v375, v376, n19 = proto.readTag(p27, n19)

		if v376 == proto.wireTypes.varint then
			local v377

			v377, n19 = proto.readVarInt(p27, n19)
		elseif v376 == proto.wireTypes.lengthDelimited then
			if v375 == 1 then
				local v378

				v378, n19 = proto.readBuffer(p27, n19)
				table.insert(v373.options, t1.StringProp_ConditionalOption.decode(v378))
			else
				local v379, v380 = proto.readVarInt(p27, n19)

				n19 = v380 + v379
			end
		elseif v376 == proto.wireTypes.i32 then
			local v381

			v381, n19 = proto.readFixed32(p27, n19)
		elseif v376 == proto.wireTypes.i64 then
			local v382

			v382, n19 = proto.readFixed64(p27, n19)
		else
			error("Unsupported wire type: " .. v376)
		end
	end

	return v373
end
function t36.jsonEncode(p28) -- line: 4113
	local t38 = {}

	if p28.options ~= nil and #p28.options > 0 then
		local t39 = {}

		for _, v387 in p28.options do
			table.insert(t39, v387:jsonEncode())
		end

		t38.options = t39
	end

	return t38
end
function t36.jsonDecode(t40: {[any]: any}) -- line: 4127
	-- upvalues: t36 (copy), t1 (copy)
	local v389 = t36.new()

	if t40.options ~= nil then
		local t41 = {}

		for _, v392 in t40.options do
			table.insert(t41, t1.StringProp_ConditionalOption.jsonDecode(v392))
		end

		v389.options = t41
	end

	return v389
end

t36.descriptor = {
	name = "StringProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}
t1.StringProp_ConditionalOptions = t36
typeRegistry.default:register(t1.StringProp_ConditionalOptions)

local t42 = {}

t42.__index = t42

function t42.new(t43: {[any]: any}?) -- line: 4156
	-- upvalues: t42 (copy)
	return (setmetatable({
		kind = if t43 ~= nil and t43.kind ~= nil then t43.kind else nil
	}, t42))
end
function t42.encode(p29) -- line: 4162
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n20 = 0

	if p29.kind ~= nil then
		if p29.kind.type == "literal" then
			local v397, v398 = proto.writeTag(buf, n20, 1, proto.wireTypes.i32)

			buf, n20 = proto.writeFloat(v397, v398, p29.kind.value)
		elseif p29.kind.type == "binding_path" then
			local v399, v400 = proto.writeTag(buf, n20, 2, proto.wireTypes.lengthDelimited)

			buf, n20 = proto.writeString(v399, v400, p29.kind.value)
		elseif p29.kind.type == "token" then
			local v401, v402 = proto.writeTag(buf, n20, 3, proto.wireTypes.lengthDelimited)

			buf, n20 = proto.writeString(v401, v402, p29.kind.value)
		elseif p29.kind.type == "conditional" then
			local v403 = p29.kind.value:encode()
			local v404, v405 = proto.writeTag(buf, n20, 4, proto.wireTypes.lengthDelimited)

			buf, n20 = proto.writeBuffer(v404, v405, v403, buffer.len(v403))
		end
	end

	local buf12 = buffer.create(n20)

	buffer.copy(buf12, 0, buf, 0, n20)

	return buf12
end
function t42.decode(p30: buffer) -- line: 4188
	-- upvalues: t42 (copy), proto (copy), t1 (copy)
	local v408 = t42.new()
	local n21 = 0

	while n21 < buffer.len(p30) do
		local v410, v411

		v410, v411, n21 = proto.readTag(p30, n21)

		if v411 == proto.wireTypes.varint then
			local v412

			v412, n21 = proto.readVarInt(p30, n21)
		elseif v411 == proto.wireTypes.lengthDelimited then
			if v410 == 2 then
				local v413

				v413, n21 = proto.readBuffer(p30, n21)
				v408.kind = {
					type = "binding_path",
					value = buffer.tostring(v413)
				}
			elseif v410 == 3 then
				local v414

				v414, n21 = proto.readBuffer(p30, n21)
				v408.kind = {
					type = "token",
					value = buffer.tostring(v414)
				}
			elseif v410 == 4 then
				local v415

				v415, n21 = proto.readBuffer(p30, n21)
				v408.kind = {
					type = "conditional",
					value = t1.FloatProp_ConditionalOptions.decode(v415)
				}
			else
				local v416, v417 = proto.readVarInt(p30, n21)

				n21 = v417 + v416
			end
		elseif v411 == proto.wireTypes.i32 then
			if v410 == 1 then
				local v418

				v418, n21 = proto.readFloat(p30, n21)
				v408.kind = {
					type = "literal",
					value = v418
				}
			else
				local v419

				v419, n21 = proto.readFixed32(p30, n21)
			end
		elseif v411 == proto.wireTypes.i64 then
			local v420

			v420, n21 = proto.readFixed64(p30, n21)
		else
			error("Unsupported wire type: " .. v411)
		end
	end

	return v408
end
function t42.jsonEncode(p31) -- line: 4246
	-- upvalues: proto (copy)
	local t44 = {}

	if p31.kind ~= nil then
		if p31.kind.type == "literal" then
			t44.literal = proto.json.serializeNumber(p31.kind.value)

			return t44
		end

		if p31.kind.type == "binding_path" then
			t44.bindingPath = p31.kind.value

			return t44
		end

		if p31.kind.type == "token" then
			t44.token = p31.kind.value

			return t44
		end

		if p31.kind.type == "conditional" then
			t44.conditional = p31.kind.value:jsonEncode()
		end
	end

	return t44
end
function t42.jsonDecode(t45: {[any]: any}) -- line: 4264
	-- upvalues: t42 (copy), proto (copy), t1 (copy)
	local v424 = t42.new()

	if t45.literal ~= nil then
		v424.kind = {
			type = "literal",
			value = proto.json.deserializeNumber(t45.literal)
		}
	end

	if t45.binding_path ~= nil then
		v424.kind = {
			type = "binding_path",
			value = t45.binding_path
		}
	end

	if t45.bindingPath ~= nil then
		v424.kind = {
			type = "binding_path",
			value = t45.bindingPath
		}
	end

	if t45.token ~= nil then
		v424.kind = {
			type = "token",
			value = t45.token
		}
	end

	if t45.conditional ~= nil then
		v424.kind = {
			type = "conditional",
			value = t1.FloatProp_ConditionalOptions.jsonDecode(t45.conditional)
		}
	end

	return v424
end

t42.descriptor = {
	name = "FloatProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.FloatProp"
}
t1.FloatProp = t42
typeRegistry.default:register(t1.FloatProp)

local t46 = {}

t46.__index = t46

function t46.new(t47: {[any]: any}?) -- line: 4305
	-- upvalues: t46 (copy)
	return (setmetatable({
		condition = if t47 ~= nil and t47.condition ~= nil then t47.condition else nil,
		kind = if t47 ~= nil and t47.kind ~= nil then t47.kind else nil
	}, t46))
end
function t46.encode(p32) -- line: 4314
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n22 = 0

	if p32.condition ~= nil then
		local v429 = p32.condition:encode()
		local v430, v431 = proto.writeTag(buf, n22, 1, proto.wireTypes.lengthDelimited)

		buf, n22 = proto.writeBuffer(v430, v431, v429, buffer.len(v429))
	end

	if p32.kind ~= nil then
		if p32.kind.type == "literal" then
			local v432, v433 = proto.writeTag(buf, n22, 2, proto.wireTypes.i32)

			buf, n22 = proto.writeFloat(v432, v433, p32.kind.value)
		elseif p32.kind.type == "binding_path" then
			local v434, v435 = proto.writeTag(buf, n22, 3, proto.wireTypes.lengthDelimited)

			buf, n22 = proto.writeString(v434, v435, p32.kind.value)
		elseif p32.kind.type == "token" then
			local v436, v437 = proto.writeTag(buf, n22, 4, proto.wireTypes.lengthDelimited)

			buf, n22 = proto.writeString(v436, v437, p32.kind.value)
		end
	end

	local buf13 = buffer.create(n22)

	buffer.copy(buf13, 0, buf, 0, n22)

	return buf13
end
function t46.decode(p33: buffer) -- line: 4342
	-- upvalues: t46 (copy), proto (copy), prop_condition (copy)
	local v440 = t46.new()
	local n23 = 0

	while n23 < buffer.len(p33) do
		local v442, v443

		v442, v443, n23 = proto.readTag(p33, n23)

		if v443 == proto.wireTypes.varint then
			local v444

			v444, n23 = proto.readVarInt(p33, n23)
		elseif v443 == proto.wireTypes.lengthDelimited then
			if v442 == 1 then
				local v445

				v445, n23 = proto.readBuffer(p33, n23)
				v440.condition = prop_condition.PropCondition.decode(v445)
			elseif v442 == 3 then
				local v446

				v446, n23 = proto.readBuffer(p33, n23)
				v440.kind = {
					type = "binding_path",
					value = buffer.tostring(v446)
				}
			elseif v442 == 4 then
				local v447

				v447, n23 = proto.readBuffer(p33, n23)
				v440.kind = {
					type = "token",
					value = buffer.tostring(v447)
				}
			else
				local v448, v449 = proto.readVarInt(p33, n23)

				n23 = v449 + v448
			end
		elseif v443 == proto.wireTypes.i32 then
			if v442 == 2 then
				local v450

				v450, n23 = proto.readFloat(p33, n23)
				v440.kind = {
					type = "literal",
					value = v450
				}
			else
				local v451

				v451, n23 = proto.readFixed32(p33, n23)
			end
		elseif v443 == proto.wireTypes.i64 then
			local v452

			v452, n23 = proto.readFixed64(p33, n23)
		else
			error("Unsupported wire type: " .. v443)
		end
	end

	return v440
end
function t46.jsonEncode(p34) -- line: 4400
	-- upvalues: proto (copy)
	local t48 = {}

	if p34.condition ~= nil then
		t48.condition = p34.condition:jsonEncode()
	end

	if p34.kind ~= nil then
		if p34.kind.type == "literal" then
			t48.literal = proto.json.serializeNumber(p34.kind.value)

			return t48
		end

		if p34.kind.type == "binding_path" then
			t48.bindingPath = p34.kind.value

			return t48
		end

		if p34.kind.type == "token" then
			t48.token = p34.kind.value
		end
	end

	return t48
end
function t46.jsonDecode(t49: {[any]: any}) -- line: 4420
	-- upvalues: t46 (copy), prop_condition (copy), proto (copy)
	local v456 = t46.new()

	if t49.condition ~= nil then
		v456.condition = prop_condition.PropCondition.jsonDecode(t49.condition)
	end

	if t49.literal ~= nil then
		v456.kind = {
			type = "literal",
			value = proto.json.deserializeNumber(t49.literal)
		}
	end

	if t49.binding_path ~= nil then
		v456.kind = {
			type = "binding_path",
			value = t49.binding_path
		}
	end

	if t49.bindingPath ~= nil then
		v456.kind = {
			type = "binding_path",
			value = t49.bindingPath
		}
	end

	if t49.token ~= nil then
		v456.kind = {
			type = "token",
			value = t49.token
		}
	end

	return v456
end

t46.descriptor = {
	name = "FloatProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}
t1.FloatProp_ConditionalOption = t46
typeRegistry.default:register(t1.FloatProp_ConditionalOption)

local t50 = {}

t50.__index = t50

function t50.new(t51: {[any]: any}?) -- line: 4461
	-- upvalues: t50 (copy)
	return (setmetatable({
		options = if t51 ~= nil and t51.options ~= nil then t51.options else {}
	}, t50))
end
function t50.encode(p35) -- line: 4469
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n24 = 0

	if p35.options ~= nil and #p35.options > 0 then
		for _, v462 in p35.options do
			local v463 = v462:encode()
			local v464, v465 = proto.writeTag(buf, n24, 1, proto.wireTypes.lengthDelimited)

			buf, n24 = proto.writeBuffer(v464, v465, v463, buffer.len(v463))
		end
	end

	local buf14 = buffer.create(n24)

	buffer.copy(buf14, 0, buf, 0, n24)

	return buf14
end
function t50.decode(p36: buffer) -- line: 4486
	-- upvalues: t50 (copy), proto (copy), t1 (copy)
	local v468 = t50.new()
	local n25 = 0

	while n25 < buffer.len(p36) do
		local v470, v471

		v470, v471, n25 = proto.readTag(p36, n25)

		if v471 == proto.wireTypes.varint then
			local v472

			v472, n25 = proto.readVarInt(p36, n25)
		elseif v471 == proto.wireTypes.lengthDelimited then
			if v470 == 1 then
				local v473

				v473, n25 = proto.readBuffer(p36, n25)
				table.insert(v468.options, t1.FloatProp_ConditionalOption.decode(v473))
			else
				local v474, v475 = proto.readVarInt(p36, n25)

				n25 = v475 + v474
			end
		elseif v471 == proto.wireTypes.i32 then
			local v476

			v476, n25 = proto.readFixed32(p36, n25)
		elseif v471 == proto.wireTypes.i64 then
			local v477

			v477, n25 = proto.readFixed64(p36, n25)
		else
			error("Unsupported wire type: " .. v471)
		end
	end

	return v468
end
function t50.jsonEncode(p37) -- line: 4529
	local t52 = {}

	if p37.options ~= nil and #p37.options > 0 then
		local t53 = {}

		for _, v482 in p37.options do
			table.insert(t53, v482:jsonEncode())
		end

		t52.options = t53
	end

	return t52
end
function t50.jsonDecode(t54: {[any]: any}) -- line: 4543
	-- upvalues: t50 (copy), t1 (copy)
	local v484 = t50.new()

	if t54.options ~= nil then
		local t55 = {}

		for _, v487 in t54.options do
			table.insert(t55, t1.FloatProp_ConditionalOption.jsonDecode(v487))
		end

		v484.options = t55
	end

	return v484
end

t50.descriptor = {
	name = "FloatProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}
t1.FloatProp_ConditionalOptions = t50
typeRegistry.default:register(t1.FloatProp_ConditionalOptions)

local t56 = {}

t56.__index = t56

function t56.new(t57: {[any]: any}?) -- line: 4572
	-- upvalues: t56 (copy)
	return (setmetatable({
		kind = if t57 ~= nil and t57.kind ~= nil then t57.kind else nil
	}, t56))
end
function t56.encode(p38) -- line: 4578
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n26 = 0

	if p38.kind ~= nil then
		if p38.kind.type == "literal" then
			local v492, v493 = proto.writeTag(buf, n26, 1, proto.wireTypes.i64)

			buf, n26 = proto.writeDouble(v492, v493, p38.kind.value)
		elseif p38.kind.type == "binding_path" then
			local v494, v495 = proto.writeTag(buf, n26, 2, proto.wireTypes.lengthDelimited)

			buf, n26 = proto.writeString(v494, v495, p38.kind.value)
		elseif p38.kind.type == "token" then
			local v496, v497 = proto.writeTag(buf, n26, 3, proto.wireTypes.lengthDelimited)

			buf, n26 = proto.writeString(v496, v497, p38.kind.value)
		elseif p38.kind.type == "conditional" then
			local v498 = p38.kind.value:encode()
			local v499, v500 = proto.writeTag(buf, n26, 4, proto.wireTypes.lengthDelimited)

			buf, n26 = proto.writeBuffer(v499, v500, v498, buffer.len(v498))
		end
	end

	local buf15 = buffer.create(n26)

	buffer.copy(buf15, 0, buf, 0, n26)

	return buf15
end
function t56.decode(p39: buffer) -- line: 4604
	-- upvalues: t56 (copy), proto (copy), t1 (copy)
	local v503 = t56.new()
	local n27 = 0

	while n27 < buffer.len(p39) do
		local v505, v506

		v505, v506, n27 = proto.readTag(p39, n27)

		if v506 == proto.wireTypes.varint then
			local v507

			v507, n27 = proto.readVarInt(p39, n27)
		elseif v506 == proto.wireTypes.lengthDelimited then
			if v505 == 2 then
				local v508

				v508, n27 = proto.readBuffer(p39, n27)
				v503.kind = {
					type = "binding_path",
					value = buffer.tostring(v508)
				}
			elseif v505 == 3 then
				local v509

				v509, n27 = proto.readBuffer(p39, n27)
				v503.kind = {
					type = "token",
					value = buffer.tostring(v509)
				}
			elseif v505 == 4 then
				local v510

				v510, n27 = proto.readBuffer(p39, n27)
				v503.kind = {
					type = "conditional",
					value = t1.DoubleProp_ConditionalOptions.decode(v510)
				}
			else
				local v511, v512 = proto.readVarInt(p39, n27)

				n27 = v512 + v511
			end
		elseif v506 == proto.wireTypes.i32 then
			local v513

			v513, n27 = proto.readFixed32(p39, n27)
		elseif v506 == proto.wireTypes.i64 then
			if v505 == 1 then
				local v514

				v514, n27 = proto.readDouble(p39, n27)
				v503.kind = {
					type = "literal",
					value = v514
				}
			else
				local v515

				v515, n27 = proto.readFixed64(p39, n27)
			end
		else
			error("Unsupported wire type: " .. v506)
		end
	end

	return v503
end
function t56.jsonEncode(p40) -- line: 4662
	-- upvalues: proto (copy)
	local t58 = {}

	if p40.kind ~= nil then
		if p40.kind.type == "literal" then
			t58.literal = proto.json.serializeNumber(p40.kind.value)

			return t58
		end

		if p40.kind.type == "binding_path" then
			t58.bindingPath = p40.kind.value

			return t58
		end

		if p40.kind.type == "token" then
			t58.token = p40.kind.value

			return t58
		end

		if p40.kind.type == "conditional" then
			t58.conditional = p40.kind.value:jsonEncode()
		end
	end

	return t58
end
function t56.jsonDecode(t59: {[any]: any}) -- line: 4680
	-- upvalues: t56 (copy), proto (copy), t1 (copy)
	local v519 = t56.new()

	if t59.literal ~= nil then
		v519.kind = {
			type = "literal",
			value = proto.json.deserializeNumber(t59.literal)
		}
	end

	if t59.binding_path ~= nil then
		v519.kind = {
			type = "binding_path",
			value = t59.binding_path
		}
	end

	if t59.bindingPath ~= nil then
		v519.kind = {
			type = "binding_path",
			value = t59.bindingPath
		}
	end

	if t59.token ~= nil then
		v519.kind = {
			type = "token",
			value = t59.token
		}
	end

	if t59.conditional ~= nil then
		v519.kind = {
			type = "conditional",
			value = t1.DoubleProp_ConditionalOptions.jsonDecode(t59.conditional)
		}
	end

	return v519
end

t56.descriptor = {
	name = "DoubleProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.DoubleProp"
}
t1.DoubleProp = t56
typeRegistry.default:register(t1.DoubleProp)

local t60 = {}

t60.__index = t60

function t60.new(t61: {[any]: any}?) -- line: 4721
	-- upvalues: t60 (copy)
	return (setmetatable({
		condition = if t61 ~= nil and t61.condition ~= nil then t61.condition else nil,
		kind = if t61 ~= nil and t61.kind ~= nil then t61.kind else nil
	}, t60))
end
function t60.encode(p41) -- line: 4730
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n28 = 0

	if p41.condition ~= nil then
		local v524 = p41.condition:encode()
		local v525, v526 = proto.writeTag(buf, n28, 1, proto.wireTypes.lengthDelimited)

		buf, n28 = proto.writeBuffer(v525, v526, v524, buffer.len(v524))
	end

	if p41.kind ~= nil then
		if p41.kind.type == "literal" then
			local v527, v528 = proto.writeTag(buf, n28, 2, proto.wireTypes.i64)

			buf, n28 = proto.writeDouble(v527, v528, p41.kind.value)
		elseif p41.kind.type == "binding_path" then
			local v529, v530 = proto.writeTag(buf, n28, 3, proto.wireTypes.lengthDelimited)

			buf, n28 = proto.writeString(v529, v530, p41.kind.value)
		elseif p41.kind.type == "token" then
			local v531, v532 = proto.writeTag(buf, n28, 4, proto.wireTypes.lengthDelimited)

			buf, n28 = proto.writeString(v531, v532, p41.kind.value)
		end
	end

	local buf16 = buffer.create(n28)

	buffer.copy(buf16, 0, buf, 0, n28)

	return buf16
end
function t60.decode(p42: buffer) -- line: 4758
	-- upvalues: t60 (copy), proto (copy), prop_condition (copy)
	local v535 = t60.new()
	local n29 = 0

	while n29 < buffer.len(p42) do
		local v537, v538

		v537, v538, n29 = proto.readTag(p42, n29)

		if v538 == proto.wireTypes.varint then
			local v539

			v539, n29 = proto.readVarInt(p42, n29)
		elseif v538 == proto.wireTypes.lengthDelimited then
			if v537 == 1 then
				local v540

				v540, n29 = proto.readBuffer(p42, n29)
				v535.condition = prop_condition.PropCondition.decode(v540)
			elseif v537 == 3 then
				local v541

				v541, n29 = proto.readBuffer(p42, n29)
				v535.kind = {
					type = "binding_path",
					value = buffer.tostring(v541)
				}
			elseif v537 == 4 then
				local v542

				v542, n29 = proto.readBuffer(p42, n29)
				v535.kind = {
					type = "token",
					value = buffer.tostring(v542)
				}
			else
				local v543, v544 = proto.readVarInt(p42, n29)

				n29 = v544 + v543
			end
		elseif v538 == proto.wireTypes.i32 then
			local v545

			v545, n29 = proto.readFixed32(p42, n29)
		elseif v538 == proto.wireTypes.i64 then
			if v537 == 2 then
				local v546

				v546, n29 = proto.readDouble(p42, n29)
				v535.kind = {
					type = "literal",
					value = v546
				}
			else
				local v547

				v547, n29 = proto.readFixed64(p42, n29)
			end
		else
			error("Unsupported wire type: " .. v538)
		end
	end

	return v535
end
function t60.jsonEncode(p43) -- line: 4816
	-- upvalues: proto (copy)
	local t62 = {}

	if p43.condition ~= nil then
		t62.condition = p43.condition:jsonEncode()
	end

	if p43.kind ~= nil then
		if p43.kind.type == "literal" then
			t62.literal = proto.json.serializeNumber(p43.kind.value)

			return t62
		end

		if p43.kind.type == "binding_path" then
			t62.bindingPath = p43.kind.value

			return t62
		end

		if p43.kind.type == "token" then
			t62.token = p43.kind.value
		end
	end

	return t62
end
function t60.jsonDecode(t63: {[any]: any}) -- line: 4836
	-- upvalues: t60 (copy), prop_condition (copy), proto (copy)
	local v551 = t60.new()

	if t63.condition ~= nil then
		v551.condition = prop_condition.PropCondition.jsonDecode(t63.condition)
	end

	if t63.literal ~= nil then
		v551.kind = {
			type = "literal",
			value = proto.json.deserializeNumber(t63.literal)
		}
	end

	if t63.binding_path ~= nil then
		v551.kind = {
			type = "binding_path",
			value = t63.binding_path
		}
	end

	if t63.bindingPath ~= nil then
		v551.kind = {
			type = "binding_path",
			value = t63.bindingPath
		}
	end

	if t63.token ~= nil then
		v551.kind = {
			type = "token",
			value = t63.token
		}
	end

	return v551
end

t60.descriptor = {
	name = "DoubleProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}
t1.DoubleProp_ConditionalOption = t60
typeRegistry.default:register(t1.DoubleProp_ConditionalOption)

local t64 = {}

t64.__index = t64

function t64.new(t65: {[any]: any}?) -- line: 4877
	-- upvalues: t64 (copy)
	return (setmetatable({
		options = if t65 ~= nil and t65.options ~= nil then t65.options else {}
	}, t64))
end
function t64.encode(p44) -- line: 4885
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n30 = 0

	if p44.options ~= nil and #p44.options > 0 then
		for _, v557 in p44.options do
			local v558 = v557:encode()
			local v559, v560 = proto.writeTag(buf, n30, 1, proto.wireTypes.lengthDelimited)

			buf, n30 = proto.writeBuffer(v559, v560, v558, buffer.len(v558))
		end
	end

	local buf17 = buffer.create(n30)

	buffer.copy(buf17, 0, buf, 0, n30)

	return buf17
end
function t64.decode(p45: buffer) -- line: 4902
	-- upvalues: t64 (copy), proto (copy), t1 (copy)
	local v563 = t64.new()
	local n31 = 0

	while n31 < buffer.len(p45) do
		local v565, v566

		v565, v566, n31 = proto.readTag(p45, n31)

		if v566 == proto.wireTypes.varint then
			local v567

			v567, n31 = proto.readVarInt(p45, n31)
		elseif v566 == proto.wireTypes.lengthDelimited then
			if v565 == 1 then
				local v568

				v568, n31 = proto.readBuffer(p45, n31)
				table.insert(v563.options, t1.DoubleProp_ConditionalOption.decode(v568))
			else
				local v569, v570 = proto.readVarInt(p45, n31)

				n31 = v570 + v569
			end
		elseif v566 == proto.wireTypes.i32 then
			local v571

			v571, n31 = proto.readFixed32(p45, n31)
		elseif v566 == proto.wireTypes.i64 then
			local v572

			v572, n31 = proto.readFixed64(p45, n31)
		else
			error("Unsupported wire type: " .. v566)
		end
	end

	return v563
end
function t64.jsonEncode(p46) -- line: 4945
	local t66 = {}

	if p46.options ~= nil and #p46.options > 0 then
		local t67 = {}

		for _, v577 in p46.options do
			table.insert(t67, v577:jsonEncode())
		end

		t66.options = t67
	end

	return t66
end
function t64.jsonDecode(t68: {[any]: any}) -- line: 4959
	-- upvalues: t64 (copy), t1 (copy)
	local v579 = t64.new()

	if t68.options ~= nil then
		local t69 = {}

		for _, v582 in t68.options do
			table.insert(t69, t1.DoubleProp_ConditionalOption.jsonDecode(v582))
		end

		v579.options = t69
	end

	return v579
end

t64.descriptor = {
	name = "DoubleProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}
t1.DoubleProp_ConditionalOptions = t64
typeRegistry.default:register(t1.DoubleProp_ConditionalOptions)

local t70 = {}

t70.__index = t70

function t70.new(t71: {[any]: any}?) -- line: 4988
	-- upvalues: t70 (copy)
	return (setmetatable({
		kind = if t71 ~= nil and t71.kind ~= nil then t71.kind else nil
	}, t70))
end
function t70.encode(p47) -- line: 4994
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n32 = 0

	if p47.kind ~= nil then
		if p47.kind.type == "literal" then
			local v587, v588 = proto.writeTag(buf, n32, 1, proto.wireTypes.varint)

			buf, n32 = proto.writeVarInt(v587, v588, p47.kind.value)
		elseif p47.kind.type == "binding_path" then
			local v589, v590 = proto.writeTag(buf, n32, 2, proto.wireTypes.lengthDelimited)

			buf, n32 = proto.writeString(v589, v590, p47.kind.value)
		elseif p47.kind.type == "token" then
			local v591, v592 = proto.writeTag(buf, n32, 3, proto.wireTypes.lengthDelimited)

			buf, n32 = proto.writeString(v591, v592, p47.kind.value)
		elseif p47.kind.type == "conditional" then
			local v593 = p47.kind.value:encode()
			local v594, v595 = proto.writeTag(buf, n32, 4, proto.wireTypes.lengthDelimited)

			buf, n32 = proto.writeBuffer(v594, v595, v593, buffer.len(v593))
		end
	end

	local buf18 = buffer.create(n32)

	buffer.copy(buf18, 0, buf, 0, n32)

	return buf18
end
function t70.decode(p48: buffer) -- line: 5020
	-- upvalues: t70 (copy), proto (copy), t1 (copy)
	local v598 = t70.new()
	local n33 = 0

	while n33 < buffer.len(p48) do
		local v600, v601

		v600, v601, n33 = proto.readTag(p48, n33)

		if v601 == proto.wireTypes.varint then
			if v600 == 1 then
				local v602

				v602, n33 = proto.readVarIntI32(p48, n33)
				v598.kind = {
					type = "literal",
					value = v602
				}
			else
				local v603

				v603, n33 = proto.readVarInt(p48, n33)
			end
		elseif v601 == proto.wireTypes.lengthDelimited then
			if v600 == 2 then
				local v604

				v604, n33 = proto.readBuffer(p48, n33)
				v598.kind = {
					type = "binding_path",
					value = buffer.tostring(v604)
				}
			elseif v600 == 3 then
				local v605

				v605, n33 = proto.readBuffer(p48, n33)
				v598.kind = {
					type = "token",
					value = buffer.tostring(v605)
				}
			elseif v600 == 4 then
				local v606

				v606, n33 = proto.readBuffer(p48, n33)
				v598.kind = {
					type = "conditional",
					value = t1.Int32Prop_ConditionalOptions.decode(v606)
				}
			else
				local v607, v608 = proto.readVarInt(p48, n33)

				n33 = v608 + v607
			end
		elseif v601 == proto.wireTypes.i32 then
			local v609

			v609, n33 = proto.readFixed32(p48, n33)
		elseif v601 == proto.wireTypes.i64 then
			local v610

			v610, n33 = proto.readFixed64(p48, n33)
		else
			error("Unsupported wire type: " .. v601)
		end
	end

	return v598
end
function t70.jsonEncode(p49) -- line: 5078
	local t72 = {}

	if p49.kind ~= nil then
		if p49.kind.type == "literal" then
			t72.literal = p49.kind.value

			return t72
		end

		if p49.kind.type == "binding_path" then
			t72.bindingPath = p49.kind.value

			return t72
		end

		if p49.kind.type == "token" then
			t72.token = p49.kind.value

			return t72
		end

		if p49.kind.type == "conditional" then
			t72.conditional = p49.kind.value:jsonEncode()
		end
	end

	return t72
end
function t70.jsonDecode(t73: {[any]: any}) -- line: 5096
	-- upvalues: t70 (copy), t1 (copy)
	local v614 = t70.new()

	if t73.literal ~= nil then
		v614.kind = {
			type = "literal",
			value = t73.literal
		}
	end

	if t73.binding_path ~= nil then
		v614.kind = {
			type = "binding_path",
			value = t73.binding_path
		}
	end

	if t73.bindingPath ~= nil then
		v614.kind = {
			type = "binding_path",
			value = t73.bindingPath
		}
	end

	if t73.token ~= nil then
		v614.kind = {
			type = "token",
			value = t73.token
		}
	end

	if t73.conditional ~= nil then
		v614.kind = {
			type = "conditional",
			value = t1.Int32Prop_ConditionalOptions.jsonDecode(t73.conditional)
		}
	end

	return v614
end

t70.descriptor = {
	name = "Int32Prop",
	fullName = "roblox.apppageplatform.shared.v1beta1.Int32Prop"
}
t1.Int32Prop = t70
typeRegistry.default:register(t1.Int32Prop)

local t74 = {}

t74.__index = t74

function t74.new(t75: {[any]: any}?) -- line: 5137
	-- upvalues: t74 (copy)
	return (setmetatable({
		condition = if t75 ~= nil and t75.condition ~= nil then t75.condition else nil,
		kind = if t75 ~= nil and t75.kind ~= nil then t75.kind else nil
	}, t74))
end
function t74.encode(p50) -- line: 5146
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n34 = 0

	if p50.condition ~= nil then
		local v619 = p50.condition:encode()
		local v620, v621 = proto.writeTag(buf, n34, 1, proto.wireTypes.lengthDelimited)

		buf, n34 = proto.writeBuffer(v620, v621, v619, buffer.len(v619))
	end

	if p50.kind ~= nil then
		if p50.kind.type == "literal" then
			local v622, v623 = proto.writeTag(buf, n34, 2, proto.wireTypes.varint)

			buf, n34 = proto.writeVarInt(v622, v623, p50.kind.value)
		elseif p50.kind.type == "binding_path" then
			local v624, v625 = proto.writeTag(buf, n34, 3, proto.wireTypes.lengthDelimited)

			buf, n34 = proto.writeString(v624, v625, p50.kind.value)
		elseif p50.kind.type == "token" then
			local v626, v627 = proto.writeTag(buf, n34, 4, proto.wireTypes.lengthDelimited)

			buf, n34 = proto.writeString(v626, v627, p50.kind.value)
		end
	end

	local buf19 = buffer.create(n34)

	buffer.copy(buf19, 0, buf, 0, n34)

	return buf19
end
function t74.decode(p51: buffer) -- line: 5174
	-- upvalues: t74 (copy), proto (copy), prop_condition (copy)
	local v630 = t74.new()
	local n35 = 0

	while n35 < buffer.len(p51) do
		local v632, v633

		v632, v633, n35 = proto.readTag(p51, n35)

		if v633 == proto.wireTypes.varint then
			if v632 == 2 then
				local v634

				v634, n35 = proto.readVarIntI32(p51, n35)
				v630.kind = {
					type = "literal",
					value = v634
				}
			else
				local v635

				v635, n35 = proto.readVarInt(p51, n35)
			end
		elseif v633 == proto.wireTypes.lengthDelimited then
			if v632 == 1 then
				local v636

				v636, n35 = proto.readBuffer(p51, n35)
				v630.condition = prop_condition.PropCondition.decode(v636)
			elseif v632 == 3 then
				local v637

				v637, n35 = proto.readBuffer(p51, n35)
				v630.kind = {
					type = "binding_path",
					value = buffer.tostring(v637)
				}
			elseif v632 == 4 then
				local v638

				v638, n35 = proto.readBuffer(p51, n35)
				v630.kind = {
					type = "token",
					value = buffer.tostring(v638)
				}
			else
				local v639, v640 = proto.readVarInt(p51, n35)

				n35 = v640 + v639
			end
		elseif v633 == proto.wireTypes.i32 then
			local v641

			v641, n35 = proto.readFixed32(p51, n35)
		elseif v633 == proto.wireTypes.i64 then
			local v642

			v642, n35 = proto.readFixed64(p51, n35)
		else
			error("Unsupported wire type: " .. v633)
		end
	end

	return v630
end
function t74.jsonEncode(p52) -- line: 5232
	local t76 = {}

	if p52.condition ~= nil then
		t76.condition = p52.condition:jsonEncode()
	end

	if p52.kind ~= nil then
		if p52.kind.type == "literal" then
			t76.literal = p52.kind.value

			return t76
		end

		if p52.kind.type == "binding_path" then
			t76.bindingPath = p52.kind.value

			return t76
		end

		if p52.kind.type == "token" then
			t76.token = p52.kind.value
		end
	end

	return t76
end
function t74.jsonDecode(t77: {[any]: any}) -- line: 5252
	-- upvalues: t74 (copy), prop_condition (copy)
	local v646 = t74.new()

	if t77.condition ~= nil then
		v646.condition = prop_condition.PropCondition.jsonDecode(t77.condition)
	end

	if t77.literal ~= nil then
		v646.kind = {
			type = "literal",
			value = t77.literal
		}
	end

	if t77.binding_path ~= nil then
		v646.kind = {
			type = "binding_path",
			value = t77.binding_path
		}
	end

	if t77.bindingPath ~= nil then
		v646.kind = {
			type = "binding_path",
			value = t77.bindingPath
		}
	end

	if t77.token ~= nil then
		v646.kind = {
			type = "token",
			value = t77.token
		}
	end

	return v646
end

t74.descriptor = {
	name = "Int32Prop_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}
t1.Int32Prop_ConditionalOption = t74
typeRegistry.default:register(t1.Int32Prop_ConditionalOption)

local t78 = {}

t78.__index = t78

function t78.new(t79: {[any]: any}?) -- line: 5293
	-- upvalues: t78 (copy)
	return (setmetatable({
		options = if t79 ~= nil and t79.options ~= nil then t79.options else {}
	}, t78))
end
function t78.encode(p53) -- line: 5301
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n36 = 0

	if p53.options ~= nil and #p53.options > 0 then
		for _, v652 in p53.options do
			local v653 = v652:encode()
			local v654, v655 = proto.writeTag(buf, n36, 1, proto.wireTypes.lengthDelimited)

			buf, n36 = proto.writeBuffer(v654, v655, v653, buffer.len(v653))
		end
	end

	local buf20 = buffer.create(n36)

	buffer.copy(buf20, 0, buf, 0, n36)

	return buf20
end
function t78.decode(p54: buffer) -- line: 5318
	-- upvalues: t78 (copy), proto (copy), t1 (copy)
	local v658 = t78.new()
	local n37 = 0

	while n37 < buffer.len(p54) do
		local v660, v661

		v660, v661, n37 = proto.readTag(p54, n37)

		if v661 == proto.wireTypes.varint then
			local v662

			v662, n37 = proto.readVarInt(p54, n37)
		elseif v661 == proto.wireTypes.lengthDelimited then
			if v660 == 1 then
				local v663

				v663, n37 = proto.readBuffer(p54, n37)
				table.insert(v658.options, t1.Int32Prop_ConditionalOption.decode(v663))
			else
				local v664, v665 = proto.readVarInt(p54, n37)

				n37 = v665 + v664
			end
		elseif v661 == proto.wireTypes.i32 then
			local v666

			v666, n37 = proto.readFixed32(p54, n37)
		elseif v661 == proto.wireTypes.i64 then
			local v667

			v667, n37 = proto.readFixed64(p54, n37)
		else
			error("Unsupported wire type: " .. v661)
		end
	end

	return v658
end
function t78.jsonEncode(p55) -- line: 5361
	local t80 = {}

	if p55.options ~= nil and #p55.options > 0 then
		local t81 = {}

		for _, v672 in p55.options do
			table.insert(t81, v672:jsonEncode())
		end

		t80.options = t81
	end

	return t80
end
function t78.jsonDecode(t82: {[any]: any}) -- line: 5375
	-- upvalues: t78 (copy), t1 (copy)
	local v674 = t78.new()

	if t82.options ~= nil then
		local t83 = {}

		for _, v677 in t82.options do
			table.insert(t83, t1.Int32Prop_ConditionalOption.jsonDecode(v677))
		end

		v674.options = t83
	end

	return v674
end

t78.descriptor = {
	name = "Int32Prop_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}
t1.Int32Prop_ConditionalOptions = t78
typeRegistry.default:register(t1.Int32Prop_ConditionalOptions)

local t84 = {}

t84.__index = t84

function t84.new(t85: {[any]: any}?) -- line: 5404
	-- upvalues: t84 (copy)
	return (setmetatable({
		kind = if t85 ~= nil and t85.kind ~= nil then t85.kind else nil
	}, t84))
end
function t84.encode(p56) -- line: 5410
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n38 = 0

	if p56.kind ~= nil then
		if p56.kind.type == "literal" then
			local v682, v683 = proto.writeTag(buf, n38, 1, proto.wireTypes.varint)

			buf, n38 = proto.writeVarInt(v682, v683, p56.kind.value)
		elseif p56.kind.type == "binding_path" then
			local v684, v685 = proto.writeTag(buf, n38, 2, proto.wireTypes.lengthDelimited)

			buf, n38 = proto.writeString(v684, v685, p56.kind.value)
		elseif p56.kind.type == "token" then
			local v686, v687 = proto.writeTag(buf, n38, 3, proto.wireTypes.lengthDelimited)

			buf, n38 = proto.writeString(v686, v687, p56.kind.value)
		elseif p56.kind.type == "conditional" then
			local v688 = p56.kind.value:encode()
			local v689, v690 = proto.writeTag(buf, n38, 4, proto.wireTypes.lengthDelimited)

			buf, n38 = proto.writeBuffer(v689, v690, v688, buffer.len(v688))
		end
	end

	local buf21 = buffer.create(n38)

	buffer.copy(buf21, 0, buf, 0, n38)

	return buf21
end
function t84.decode(p57: buffer) -- line: 5436
	-- upvalues: t84 (copy), proto (copy), t1 (copy)
	local v693 = t84.new()
	local n39 = 0

	while n39 < buffer.len(p57) do
		local v695, v696

		v695, v696, n39 = proto.readTag(p57, n39)

		if v696 == proto.wireTypes.varint then
			if v695 == 1 then
				local v697

				v697, n39 = proto.readVarIntI64(p57, n39)
				v693.kind = {
					type = "literal",
					value = v697
				}
			else
				local v698

				v698, n39 = proto.readVarInt(p57, n39)
			end
		elseif v696 == proto.wireTypes.lengthDelimited then
			if v695 == 2 then
				local v699

				v699, n39 = proto.readBuffer(p57, n39)
				v693.kind = {
					type = "binding_path",
					value = buffer.tostring(v699)
				}
			elseif v695 == 3 then
				local v700

				v700, n39 = proto.readBuffer(p57, n39)
				v693.kind = {
					type = "token",
					value = buffer.tostring(v700)
				}
			elseif v695 == 4 then
				local v701

				v701, n39 = proto.readBuffer(p57, n39)
				v693.kind = {
					type = "conditional",
					value = t1.Int64Prop_ConditionalOptions.decode(v701)
				}
			else
				local v702, v703 = proto.readVarInt(p57, n39)

				n39 = v703 + v702
			end
		elseif v696 == proto.wireTypes.i32 then
			local v704

			v704, n39 = proto.readFixed32(p57, n39)
		elseif v696 == proto.wireTypes.i64 then
			local v705

			v705, n39 = proto.readFixed64(p57, n39)
		else
			error("Unsupported wire type: " .. v696)
		end
	end

	return v693
end
function t84.jsonEncode(p58) -- line: 5494
	local t86 = {}

	if p58.kind ~= nil then
		if p58.kind.type == "literal" then
			t86.literal = p58.kind.value

			return t86
		end

		if p58.kind.type == "binding_path" then
			t86.bindingPath = p58.kind.value

			return t86
		end

		if p58.kind.type == "token" then
			t86.token = p58.kind.value

			return t86
		end

		if p58.kind.type == "conditional" then
			t86.conditional = p58.kind.value:jsonEncode()
		end
	end

	return t86
end
function t84.jsonDecode(t87: {[any]: any}) -- line: 5512
	-- upvalues: t84 (copy), t1 (copy)
	local v709 = t84.new()

	if t87.literal ~= nil then
		v709.kind = {
			type = "literal",
			value = t87.literal
		}
	end

	if t87.binding_path ~= nil then
		v709.kind = {
			type = "binding_path",
			value = t87.binding_path
		}
	end

	if t87.bindingPath ~= nil then
		v709.kind = {
			type = "binding_path",
			value = t87.bindingPath
		}
	end

	if t87.token ~= nil then
		v709.kind = {
			type = "token",
			value = t87.token
		}
	end

	if t87.conditional ~= nil then
		v709.kind = {
			type = "conditional",
			value = t1.Int64Prop_ConditionalOptions.jsonDecode(t87.conditional)
		}
	end

	return v709
end

t84.descriptor = {
	name = "Int64Prop",
	fullName = "roblox.apppageplatform.shared.v1beta1.Int64Prop"
}
t1.Int64Prop = t84
typeRegistry.default:register(t1.Int64Prop)

local t88 = {}

t88.__index = t88

function t88.new(t89: {[any]: any}?) -- line: 5553
	-- upvalues: t88 (copy)
	return (setmetatable({
		condition = if t89 ~= nil and t89.condition ~= nil then t89.condition else nil,
		kind = if t89 ~= nil and t89.kind ~= nil then t89.kind else nil
	}, t88))
end
function t88.encode(p59) -- line: 5562
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n40 = 0

	if p59.condition ~= nil then
		local v714 = p59.condition:encode()
		local v715, v716 = proto.writeTag(buf, n40, 1, proto.wireTypes.lengthDelimited)

		buf, n40 = proto.writeBuffer(v715, v716, v714, buffer.len(v714))
	end

	if p59.kind ~= nil then
		if p59.kind.type == "literal" then
			local v717, v718 = proto.writeTag(buf, n40, 2, proto.wireTypes.varint)

			buf, n40 = proto.writeVarInt(v717, v718, p59.kind.value)
		elseif p59.kind.type == "binding_path" then
			local v719, v720 = proto.writeTag(buf, n40, 3, proto.wireTypes.lengthDelimited)

			buf, n40 = proto.writeString(v719, v720, p59.kind.value)
		elseif p59.kind.type == "token" then
			local v721, v722 = proto.writeTag(buf, n40, 4, proto.wireTypes.lengthDelimited)

			buf, n40 = proto.writeString(v721, v722, p59.kind.value)
		end
	end

	local buf22 = buffer.create(n40)

	buffer.copy(buf22, 0, buf, 0, n40)

	return buf22
end
function t88.decode(p60: buffer) -- line: 5590
	-- upvalues: t88 (copy), proto (copy), prop_condition (copy)
	local v725 = t88.new()
	local n41 = 0

	while n41 < buffer.len(p60) do
		local v727, v728

		v727, v728, n41 = proto.readTag(p60, n41)

		if v728 == proto.wireTypes.varint then
			if v727 == 2 then
				local v729

				v729, n41 = proto.readVarIntI64(p60, n41)
				v725.kind = {
					type = "literal",
					value = v729
				}
			else
				local v730

				v730, n41 = proto.readVarInt(p60, n41)
			end
		elseif v728 == proto.wireTypes.lengthDelimited then
			if v727 == 1 then
				local v731

				v731, n41 = proto.readBuffer(p60, n41)
				v725.condition = prop_condition.PropCondition.decode(v731)
			elseif v727 == 3 then
				local v732

				v732, n41 = proto.readBuffer(p60, n41)
				v725.kind = {
					type = "binding_path",
					value = buffer.tostring(v732)
				}
			elseif v727 == 4 then
				local v733

				v733, n41 = proto.readBuffer(p60, n41)
				v725.kind = {
					type = "token",
					value = buffer.tostring(v733)
				}
			else
				local v734, v735 = proto.readVarInt(p60, n41)

				n41 = v735 + v734
			end
		elseif v728 == proto.wireTypes.i32 then
			local v736

			v736, n41 = proto.readFixed32(p60, n41)
		elseif v728 == proto.wireTypes.i64 then
			local v737

			v737, n41 = proto.readFixed64(p60, n41)
		else
			error("Unsupported wire type: " .. v728)
		end
	end

	return v725
end
function t88.jsonEncode(p61) -- line: 5648
	local t90 = {}

	if p61.condition ~= nil then
		t90.condition = p61.condition:jsonEncode()
	end

	if p61.kind ~= nil then
		if p61.kind.type == "literal" then
			t90.literal = p61.kind.value

			return t90
		end

		if p61.kind.type == "binding_path" then
			t90.bindingPath = p61.kind.value

			return t90
		end

		if p61.kind.type == "token" then
			t90.token = p61.kind.value
		end
	end

	return t90
end
function t88.jsonDecode(t91: {[any]: any}) -- line: 5668
	-- upvalues: t88 (copy), prop_condition (copy)
	local v741 = t88.new()

	if t91.condition ~= nil then
		v741.condition = prop_condition.PropCondition.jsonDecode(t91.condition)
	end

	if t91.literal ~= nil then
		v741.kind = {
			type = "literal",
			value = t91.literal
		}
	end

	if t91.binding_path ~= nil then
		v741.kind = {
			type = "binding_path",
			value = t91.binding_path
		}
	end

	if t91.bindingPath ~= nil then
		v741.kind = {
			type = "binding_path",
			value = t91.bindingPath
		}
	end

	if t91.token ~= nil then
		v741.kind = {
			type = "token",
			value = t91.token
		}
	end

	return v741
end

t88.descriptor = {
	name = "Int64Prop_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}
t1.Int64Prop_ConditionalOption = t88
typeRegistry.default:register(t1.Int64Prop_ConditionalOption)

local t92 = {}

t92.__index = t92

function t92.new(t93: {[any]: any}?) -- line: 5709
	-- upvalues: t92 (copy)
	return (setmetatable({
		options = if t93 ~= nil and t93.options ~= nil then t93.options else {}
	}, t92))
end
function t92.encode(p62) -- line: 5717
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n42 = 0

	if p62.options ~= nil and #p62.options > 0 then
		for _, v747 in p62.options do
			local v748 = v747:encode()
			local v749, v750 = proto.writeTag(buf, n42, 1, proto.wireTypes.lengthDelimited)

			buf, n42 = proto.writeBuffer(v749, v750, v748, buffer.len(v748))
		end
	end

	local buf23 = buffer.create(n42)

	buffer.copy(buf23, 0, buf, 0, n42)

	return buf23
end
function t92.decode(p63: buffer) -- line: 5734
	-- upvalues: t92 (copy), proto (copy), t1 (copy)
	local v753 = t92.new()
	local n43 = 0

	while n43 < buffer.len(p63) do
		local v755, v756

		v755, v756, n43 = proto.readTag(p63, n43)

		if v756 == proto.wireTypes.varint then
			local v757

			v757, n43 = proto.readVarInt(p63, n43)
		elseif v756 == proto.wireTypes.lengthDelimited then
			if v755 == 1 then
				local v758

				v758, n43 = proto.readBuffer(p63, n43)
				table.insert(v753.options, t1.Int64Prop_ConditionalOption.decode(v758))
			else
				local v759, v760 = proto.readVarInt(p63, n43)

				n43 = v760 + v759
			end
		elseif v756 == proto.wireTypes.i32 then
			local v761

			v761, n43 = proto.readFixed32(p63, n43)
		elseif v756 == proto.wireTypes.i64 then
			local v762

			v762, n43 = proto.readFixed64(p63, n43)
		else
			error("Unsupported wire type: " .. v756)
		end
	end

	return v753
end
function t92.jsonEncode(p64) -- line: 5777
	local t94 = {}

	if p64.options ~= nil and #p64.options > 0 then
		local t95 = {}

		for _, v767 in p64.options do
			table.insert(t95, v767:jsonEncode())
		end

		t94.options = t95
	end

	return t94
end
function t92.jsonDecode(t96: {[any]: any}) -- line: 5791
	-- upvalues: t92 (copy), t1 (copy)
	local v769 = t92.new()

	if t96.options ~= nil then
		local t97 = {}

		for _, v772 in t96.options do
			table.insert(t97, t1.Int64Prop_ConditionalOption.jsonDecode(v772))
		end

		v769.options = t97
	end

	return v769
end

t92.descriptor = {
	name = "Int64Prop_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}
t1.Int64Prop_ConditionalOptions = t92
typeRegistry.default:register(t1.Int64Prop_ConditionalOptions)

local t98 = {}

t98.__index = t98

function t98.new(t99: {[any]: any}?) -- line: 5820
	-- upvalues: t98 (copy)
	return (setmetatable({
		kind = if t99 ~= nil and t99.kind ~= nil then t99.kind else nil
	}, t98))
end
function t98.encode(p65) -- line: 5826
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n44 = 0

	if p65.kind ~= nil then
		if p65.kind.type == "literal" then
			local v777, v778 = proto.writeTag(buf, n44, 1, proto.wireTypes.varint)

			buf, n44 = proto.writeVarInt(v777, v778, not p65.kind.value and 0 or 1)
		elseif p65.kind.type == "binding_path" then
			local v779, v780 = proto.writeTag(buf, n44, 2, proto.wireTypes.lengthDelimited)

			buf, n44 = proto.writeString(v779, v780, p65.kind.value)
		elseif p65.kind.type == "conditional" then
			local v781 = p65.kind.value:encode()
			local v782, v783 = proto.writeTag(buf, n44, 3, proto.wireTypes.lengthDelimited)

			buf, n44 = proto.writeBuffer(v782, v783, v781, buffer.len(v781))
		end
	end

	local buf24 = buffer.create(n44)

	buffer.copy(buf24, 0, buf, 0, n44)

	return buf24
end
function t98.decode(p66: buffer) -- line: 5849
	-- upvalues: t98 (copy), proto (copy), t1 (copy)
	local v786 = t98.new()
	local n45 = 0

	while n45 < buffer.len(p66) do
		local v788, v789

		v788, v789, n45 = proto.readTag(p66, n45)

		if v789 == proto.wireTypes.varint then
			if v788 == 1 then
				local v790

				v790, n45 = proto.readVarInt(p66, n45)
				v786.kind = {
					type = "literal",
					value = v790 ~= 0
				}
			else
				local v791

				v791, n45 = proto.readVarInt(p66, n45)
			end
		elseif v789 == proto.wireTypes.lengthDelimited then
			if v788 == 2 then
				local v792

				v792, n45 = proto.readBuffer(p66, n45)
				v786.kind = {
					type = "binding_path",
					value = buffer.tostring(v792)
				}
			elseif v788 == 3 then
				local v793

				v793, n45 = proto.readBuffer(p66, n45)
				v786.kind = {
					type = "conditional",
					value = t1.BoolProp_ConditionalOptions.decode(v793)
				}
			else
				local v794, v795 = proto.readVarInt(p66, n45)

				n45 = v795 + v794
			end
		elseif v789 == proto.wireTypes.i32 then
			local v796

			v796, n45 = proto.readFixed32(p66, n45)
		elseif v789 == proto.wireTypes.i64 then
			local v797

			v797, n45 = proto.readFixed64(p66, n45)
		else
			error("Unsupported wire type: " .. v789)
		end
	end

	return v786
end
function t98.jsonEncode(p67) -- line: 5902
	local t100 = {}

	if p67.kind ~= nil then
		if p67.kind.type == "literal" then
			t100.literal = p67.kind.value

			return t100
		end

		if p67.kind.type == "binding_path" then
			t100.bindingPath = p67.kind.value

			return t100
		end

		if p67.kind.type == "conditional" then
			t100.conditional = p67.kind.value:jsonEncode()
		end
	end

	return t100
end
function t98.jsonDecode(t101: {[any]: any}) -- line: 5918
	-- upvalues: t98 (copy), t1 (copy)
	local v801 = t98.new()

	if t101.literal ~= nil then
		v801.kind = {
			type = "literal",
			value = t101.literal
		}
	end

	if t101.binding_path ~= nil then
		v801.kind = {
			type = "binding_path",
			value = t101.binding_path
		}
	end

	if t101.bindingPath ~= nil then
		v801.kind = {
			type = "binding_path",
			value = t101.bindingPath
		}
	end

	if t101.conditional ~= nil then
		v801.kind = {
			type = "conditional",
			value = t1.BoolProp_ConditionalOptions.jsonDecode(t101.conditional)
		}
	end

	return v801
end

t98.descriptor = {
	name = "BoolProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.BoolProp"
}
t1.BoolProp = t98
typeRegistry.default:register(t1.BoolProp)

local t102 = {}

t102.__index = t102

function t102.new(t103: {[any]: any}?) -- line: 5955
	-- upvalues: t102 (copy)
	return (setmetatable({
		condition = if t103 ~= nil and t103.condition ~= nil then t103.condition else nil,
		kind = if t103 ~= nil and t103.kind ~= nil then t103.kind else nil
	}, t102))
end
function t102.encode(p68) -- line: 5964
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n46 = 0

	if p68.condition ~= nil then
		local v806 = p68.condition:encode()
		local v807, v808 = proto.writeTag(buf, n46, 1, proto.wireTypes.lengthDelimited)

		buf, n46 = proto.writeBuffer(v807, v808, v806, buffer.len(v806))
	end

	if p68.kind ~= nil then
		if p68.kind.type == "literal" then
			local v809, v810 = proto.writeTag(buf, n46, 2, proto.wireTypes.varint)

			buf, n46 = proto.writeVarInt(v809, v810, not p68.kind.value and 0 or 1)
		elseif p68.kind.type == "binding_path" then
			local v811, v812 = proto.writeTag(buf, n46, 3, proto.wireTypes.lengthDelimited)

			buf, n46 = proto.writeString(v811, v812, p68.kind.value)
		end
	end

	local buf25 = buffer.create(n46)

	buffer.copy(buf25, 0, buf, 0, n46)

	return buf25
end
function t102.decode(p69: buffer) -- line: 5989
	-- upvalues: t102 (copy), proto (copy), prop_condition (copy)
	local v815 = t102.new()
	local n47 = 0

	while n47 < buffer.len(p69) do
		local v817, v818

		v817, v818, n47 = proto.readTag(p69, n47)

		if v818 == proto.wireTypes.varint then
			if v817 == 2 then
				local v819

				v819, n47 = proto.readVarInt(p69, n47)
				v815.kind = {
					type = "literal",
					value = v819 ~= 0
				}
			else
				local v820

				v820, n47 = proto.readVarInt(p69, n47)
			end
		elseif v818 == proto.wireTypes.lengthDelimited then
			if v817 == 1 then
				local v821

				v821, n47 = proto.readBuffer(p69, n47)
				v815.condition = prop_condition.PropCondition.decode(v821)
			elseif v817 == 3 then
				local v822

				v822, n47 = proto.readBuffer(p69, n47)
				v815.kind = {
					type = "binding_path",
					value = buffer.tostring(v822)
				}
			else
				local v823, v824 = proto.readVarInt(p69, n47)

				n47 = v824 + v823
			end
		elseif v818 == proto.wireTypes.i32 then
			local v825

			v825, n47 = proto.readFixed32(p69, n47)
		elseif v818 == proto.wireTypes.i64 then
			local v826

			v826, n47 = proto.readFixed64(p69, n47)
		else
			error("Unsupported wire type: " .. v818)
		end
	end

	return v815
end
function t102.jsonEncode(p70) -- line: 6042
	local t104 = {}

	if p70.condition ~= nil then
		t104.condition = p70.condition:jsonEncode()
	end

	if p70.kind ~= nil then
		if p70.kind.type == "literal" then
			t104.literal = p70.kind.value

			return t104
		end

		if p70.kind.type == "binding_path" then
			t104.bindingPath = p70.kind.value
		end
	end

	return t104
end
function t102.jsonDecode(t105: {[any]: any}) -- line: 6060
	-- upvalues: t102 (copy), prop_condition (copy)
	local v830 = t102.new()

	if t105.condition ~= nil then
		v830.condition = prop_condition.PropCondition.jsonDecode(t105.condition)
	end

	if t105.literal ~= nil then
		v830.kind = {
			type = "literal",
			value = t105.literal
		}
	end

	if t105.binding_path ~= nil then
		v830.kind = {
			type = "binding_path",
			value = t105.binding_path
		}
	end

	if t105.bindingPath ~= nil then
		v830.kind = {
			type = "binding_path",
			value = t105.bindingPath
		}
	end

	return v830
end

t102.descriptor = {
	name = "BoolProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}
t1.BoolProp_ConditionalOption = t102
typeRegistry.default:register(t1.BoolProp_ConditionalOption)

local t106 = {}

t106.__index = t106

function t106.new(t107: {[any]: any}?) -- line: 6097
	-- upvalues: t106 (copy)
	return (setmetatable({
		options = if t107 ~= nil and t107.options ~= nil then t107.options else {}
	}, t106))
end
function t106.encode(p71) -- line: 6105
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n48 = 0

	if p71.options ~= nil and #p71.options > 0 then
		for _, v836 in p71.options do
			local v837 = v836:encode()
			local v838, v839 = proto.writeTag(buf, n48, 1, proto.wireTypes.lengthDelimited)

			buf, n48 = proto.writeBuffer(v838, v839, v837, buffer.len(v837))
		end
	end

	local buf26 = buffer.create(n48)

	buffer.copy(buf26, 0, buf, 0, n48)

	return buf26
end
function t106.decode(p72: buffer) -- line: 6122
	-- upvalues: t106 (copy), proto (copy), t1 (copy)
	local v842 = t106.new()
	local n49 = 0

	while n49 < buffer.len(p72) do
		local v844, v845

		v844, v845, n49 = proto.readTag(p72, n49)

		if v845 == proto.wireTypes.varint then
			local v846

			v846, n49 = proto.readVarInt(p72, n49)
		elseif v845 == proto.wireTypes.lengthDelimited then
			if v844 == 1 then
				local v847

				v847, n49 = proto.readBuffer(p72, n49)
				table.insert(v842.options, t1.BoolProp_ConditionalOption.decode(v847))
			else
				local v848, v849 = proto.readVarInt(p72, n49)

				n49 = v849 + v848
			end
		elseif v845 == proto.wireTypes.i32 then
			local v850

			v850, n49 = proto.readFixed32(p72, n49)
		elseif v845 == proto.wireTypes.i64 then
			local v851

			v851, n49 = proto.readFixed64(p72, n49)
		else
			error("Unsupported wire type: " .. v845)
		end
	end

	return v842
end
function t106.jsonEncode(p73) -- line: 6165
	local t108 = {}

	if p73.options ~= nil and #p73.options > 0 then
		local t109 = {}

		for _, v856 in p73.options do
			table.insert(t109, v856:jsonEncode())
		end

		t108.options = t109
	end

	return t108
end
function t106.jsonDecode(t110: {[any]: any}) -- line: 6179
	-- upvalues: t106 (copy), t1 (copy)
	local v858 = t106.new()

	if t110.options ~= nil then
		local t111 = {}

		for _, v861 in t110.options do
			table.insert(t111, t1.BoolProp_ConditionalOption.jsonDecode(v861))
		end

		v858.options = t111
	end

	return v858
end

t106.descriptor = {
	name = "BoolProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}
t1.BoolProp_ConditionalOptions = t106
typeRegistry.default:register(t1.BoolProp_ConditionalOptions)

local t112 = {}

t112.__index = t112

function t112.new(t113: {[any]: any}?) -- line: 6208
	-- upvalues: t112 (copy)
	return (setmetatable({
		kind = if t113 ~= nil and t113.kind ~= nil then t113.kind else nil
	}, t112))
end
function t112.encode(p74) -- line: 6214
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n50 = 0

	if p74.kind ~= nil then
		if p74.kind.type == "literal" then
			local v866 = p74.kind.value:encode()
			local v867, v868 = proto.writeTag(buf, n50, 1, proto.wireTypes.lengthDelimited)

			buf, n50 = proto.writeBuffer(v867, v868, v866, buffer.len(v866))
		elseif p74.kind.type == "binding_path" then
			local v869, v870 = proto.writeTag(buf, n50, 2, proto.wireTypes.lengthDelimited)

			buf, n50 = proto.writeString(v869, v870, p74.kind.value)
		elseif p74.kind.type == "conditional" then
			local v871 = p74.kind.value:encode()
			local v872, v873 = proto.writeTag(buf, n50, 3, proto.wireTypes.lengthDelimited)

			buf, n50 = proto.writeBuffer(v872, v873, v871, buffer.len(v871))
		end
	end

	local buf27 = buffer.create(n50)

	buffer.copy(buf27, 0, buf, 0, n50)

	return buf27
end
function t112.decode(p75: buffer) -- line: 6238
	-- upvalues: t112 (copy), proto (copy), struct (copy), t1 (copy)
	local v876 = t112.new()
	local n51 = 0

	while n51 < buffer.len(p75) do
		local v878, v879

		v878, v879, n51 = proto.readTag(p75, n51)

		if v879 == proto.wireTypes.varint then
			local v880

			v880, n51 = proto.readVarInt(p75, n51)
		elseif v879 == proto.wireTypes.lengthDelimited then
			if v878 == 1 then
				local v881

				v881, n51 = proto.readBuffer(p75, n51)
				v876.kind = {
					type = "literal",
					value = struct.Struct.decode(v881)
				}
			elseif v878 == 2 then
				local v882

				v882, n51 = proto.readBuffer(p75, n51)
				v876.kind = {
					type = "binding_path",
					value = buffer.tostring(v882)
				}
			elseif v878 == 3 then
				local v883

				v883, n51 = proto.readBuffer(p75, n51)
				v876.kind = {
					type = "conditional",
					value = t1.StructProp_ConditionalOptions.decode(v883)
				}
			else
				local v884, v885 = proto.readVarInt(p75, n51)

				n51 = v885 + v884
			end
		elseif v879 == proto.wireTypes.i32 then
			local v886

			v886, n51 = proto.readFixed32(p75, n51)
		elseif v879 == proto.wireTypes.i64 then
			local v887

			v887, n51 = proto.readFixed64(p75, n51)
		else
			error("Unsupported wire type: " .. v879)
		end
	end

	return v876
end
function t112.jsonEncode(p76) -- line: 6291
	local t114 = {}

	if p76.kind ~= nil then
		if p76.kind.type == "literal" then
			t114.literal = p76.kind.value:jsonEncode()

			return t114
		end

		if p76.kind.type == "binding_path" then
			t114.bindingPath = p76.kind.value

			return t114
		end

		if p76.kind.type == "conditional" then
			t114.conditional = p76.kind.value:jsonEncode()
		end
	end

	return t114
end
function t112.jsonDecode(t115: {[any]: any}) -- line: 6307
	-- upvalues: t112 (copy), struct (copy), t1 (copy)
	local v891 = t112.new()

	if t115.literal ~= nil then
		v891.kind = {
			type = "literal",
			value = struct.Struct.jsonDecode(t115.literal)
		}
	end

	if t115.binding_path ~= nil then
		v891.kind = {
			type = "binding_path",
			value = t115.binding_path
		}
	end

	if t115.bindingPath ~= nil then
		v891.kind = {
			type = "binding_path",
			value = t115.bindingPath
		}
	end

	if t115.conditional ~= nil then
		v891.kind = {
			type = "conditional",
			value = t1.StructProp_ConditionalOptions.jsonDecode(t115.conditional)
		}
	end

	return v891
end

t112.descriptor = {
	name = "StructProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.StructProp"
}
t1.StructProp = t112
typeRegistry.default:register(t1.StructProp)

local t116 = {}

t116.__index = t116

function t116.new(t117: {[any]: any}?) -- line: 6344
	-- upvalues: t116 (copy)
	return (setmetatable({
		condition = if t117 ~= nil and t117.condition ~= nil then t117.condition else nil,
		kind = if t117 ~= nil and t117.kind ~= nil then t117.kind else nil
	}, t116))
end
function t116.encode(p77) -- line: 6353
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n52 = 0

	if p77.condition ~= nil then
		local v896 = p77.condition:encode()
		local v897, v898 = proto.writeTag(buf, n52, 1, proto.wireTypes.lengthDelimited)

		buf, n52 = proto.writeBuffer(v897, v898, v896, buffer.len(v896))
	end

	if p77.kind ~= nil then
		if p77.kind.type == "literal" then
			local v899 = p77.kind.value:encode()
			local v900, v901 = proto.writeTag(buf, n52, 2, proto.wireTypes.lengthDelimited)

			buf, n52 = proto.writeBuffer(v900, v901, v899, buffer.len(v899))
		elseif p77.kind.type == "binding_path" then
			local v902, v903 = proto.writeTag(buf, n52, 3, proto.wireTypes.lengthDelimited)

			buf, n52 = proto.writeString(v902, v903, p77.kind.value)
		end
	end

	local buf28 = buffer.create(n52)

	buffer.copy(buf28, 0, buf, 0, n52)

	return buf28
end
function t116.decode(p78: buffer) -- line: 6379
	-- upvalues: t116 (copy), proto (copy), prop_condition (copy), struct (copy)
	local v906 = t116.new()
	local n53 = 0

	while n53 < buffer.len(p78) do
		local v908, v909

		v908, v909, n53 = proto.readTag(p78, n53)

		if v909 == proto.wireTypes.varint then
			local v910

			v910, n53 = proto.readVarInt(p78, n53)
		elseif v909 == proto.wireTypes.lengthDelimited then
			if v908 == 1 then
				local v911

				v911, n53 = proto.readBuffer(p78, n53)
				v906.condition = prop_condition.PropCondition.decode(v911)
			elseif v908 == 2 then
				local v912

				v912, n53 = proto.readBuffer(p78, n53)
				v906.kind = {
					type = "literal",
					value = struct.Struct.decode(v912)
				}
			elseif v908 == 3 then
				local v913

				v913, n53 = proto.readBuffer(p78, n53)
				v906.kind = {
					type = "binding_path",
					value = buffer.tostring(v913)
				}
			else
				local v914, v915 = proto.readVarInt(p78, n53)

				n53 = v915 + v914
			end
		elseif v909 == proto.wireTypes.i32 then
			local v916

			v916, n53 = proto.readFixed32(p78, n53)
		elseif v909 == proto.wireTypes.i64 then
			local v917

			v917, n53 = proto.readFixed64(p78, n53)
		else
			error("Unsupported wire type: " .. v909)
		end
	end

	return v906
end
function t116.jsonEncode(p79) -- line: 6432
	local t118 = {}

	if p79.condition ~= nil then
		t118.condition = p79.condition:jsonEncode()
	end

	if p79.kind ~= nil then
		if p79.kind.type == "literal" then
			t118.literal = p79.kind.value:jsonEncode()

			return t118
		end

		if p79.kind.type == "binding_path" then
			t118.bindingPath = p79.kind.value
		end
	end

	return t118
end
function t116.jsonDecode(t119: {[any]: any}) -- line: 6450
	-- upvalues: t116 (copy), prop_condition (copy), struct (copy)
	local v921 = t116.new()

	if t119.condition ~= nil then
		v921.condition = prop_condition.PropCondition.jsonDecode(t119.condition)
	end

	if t119.literal ~= nil then
		v921.kind = {
			type = "literal",
			value = struct.Struct.jsonDecode(t119.literal)
		}
	end

	if t119.binding_path ~= nil then
		v921.kind = {
			type = "binding_path",
			value = t119.binding_path
		}
	end

	if t119.bindingPath ~= nil then
		v921.kind = {
			type = "binding_path",
			value = t119.bindingPath
		}
	end

	return v921
end

t116.descriptor = {
	name = "StructProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}
t1.StructProp_ConditionalOption = t116
typeRegistry.default:register(t1.StructProp_ConditionalOption)

local t120 = {}

t120.__index = t120

function t120.new(t121: {[any]: any}?) -- line: 6487
	-- upvalues: t120 (copy)
	return (setmetatable({
		options = if t121 ~= nil and t121.options ~= nil then t121.options else {}
	}, t120))
end
function t120.encode(p80) -- line: 6495
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n54 = 0

	if p80.options ~= nil and #p80.options > 0 then
		for _, v927 in p80.options do
			local v928 = v927:encode()
			local v929, v930 = proto.writeTag(buf, n54, 1, proto.wireTypes.lengthDelimited)

			buf, n54 = proto.writeBuffer(v929, v930, v928, buffer.len(v928))
		end
	end

	local buf29 = buffer.create(n54)

	buffer.copy(buf29, 0, buf, 0, n54)

	return buf29
end
function t120.decode(p81: buffer) -- line: 6512
	-- upvalues: t120 (copy), proto (copy), t1 (copy)
	local v933 = t120.new()
	local n55 = 0

	while n55 < buffer.len(p81) do
		local v935, v936

		v935, v936, n55 = proto.readTag(p81, n55)

		if v936 == proto.wireTypes.varint then
			local v937

			v937, n55 = proto.readVarInt(p81, n55)
		elseif v936 == proto.wireTypes.lengthDelimited then
			if v935 == 1 then
				local v938

				v938, n55 = proto.readBuffer(p81, n55)
				table.insert(v933.options, t1.StructProp_ConditionalOption.decode(v938))
			else
				local v939, v940 = proto.readVarInt(p81, n55)

				n55 = v940 + v939
			end
		elseif v936 == proto.wireTypes.i32 then
			local v941

			v941, n55 = proto.readFixed32(p81, n55)
		elseif v936 == proto.wireTypes.i64 then
			local v942

			v942, n55 = proto.readFixed64(p81, n55)
		else
			error("Unsupported wire type: " .. v936)
		end
	end

	return v933
end
function t120.jsonEncode(p82) -- line: 6555
	local t122 = {}

	if p82.options ~= nil and #p82.options > 0 then
		local t123 = {}

		for _, v947 in p82.options do
			table.insert(t123, v947:jsonEncode())
		end

		t122.options = t123
	end

	return t122
end
function t120.jsonDecode(t124: {[any]: any}) -- line: 6569
	-- upvalues: t120 (copy), t1 (copy)
	local v949 = t120.new()

	if t124.options ~= nil then
		local t125 = {}

		for _, v952 in t124.options do
			table.insert(t125, t1.StructProp_ConditionalOption.jsonDecode(v952))
		end

		v949.options = t125
	end

	return v949
end

t120.descriptor = {
	name = "StructProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}
t1.StructProp_ConditionalOptions = t120
typeRegistry.default:register(t1.StructProp_ConditionalOptions)

local t126 = {}

t126.__index = t126

function t126.new(t127: {[any]: any}?) -- line: 6598
	-- upvalues: t126 (copy)
	return (setmetatable({
		kind = if t127 ~= nil and t127.kind ~= nil then t127.kind else nil,
		alt = if t127 ~= nil and t127.alt ~= nil then t127.alt else nil
	}, t126))
end
function t126.encode(p83) -- line: 6605
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n56 = 0

	if p83.kind ~= nil then
		if p83.kind.type == "literal" then
			local v957, v958 = proto.writeTag(buf, n56, 1, proto.wireTypes.lengthDelimited)

			buf, n56 = proto.writeString(v957, v958, p83.kind.value)
		elseif p83.kind.type == "binding_path" then
			local v959, v960 = proto.writeTag(buf, n56, 2, proto.wireTypes.lengthDelimited)

			buf, n56 = proto.writeString(v959, v960, p83.kind.value)
		elseif p83.kind.type == "format" then
			local v961 = p83.kind.value:encode()
			local v962, v963 = proto.writeTag(buf, n56, 3, proto.wireTypes.lengthDelimited)

			buf, n56 = proto.writeBuffer(v962, v963, v961, buffer.len(v961))
		elseif p83.kind.type == "conditional" then
			local v964 = p83.kind.value:encode()
			local v965, v966 = proto.writeTag(buf, n56, 4, proto.wireTypes.lengthDelimited)

			buf, n56 = proto.writeBuffer(v965, v966, v964, buffer.len(v964))
		elseif p83.kind.type == "translation" then
			local v967 = p83.kind.value:encode()
			local v968, v969 = proto.writeTag(buf, n56, 5, proto.wireTypes.lengthDelimited)

			buf, n56 = proto.writeBuffer(v968, v969, v967, buffer.len(v967))
		end
	end

	if p83.alt ~= nil then
		local v970 = p83.alt:encode()
		local v971, v972 = proto.writeTag(buf, n56, 6, proto.wireTypes.lengthDelimited)

		buf, n56 = proto.writeBuffer(v971, v972, v970, buffer.len(v970))
	end

	local buf30 = buffer.create(n56)

	buffer.copy(buf30, 0, buf, 0, n56)

	return buf30
end
function t126.decode(p84: buffer) -- line: 6642
	-- upvalues: t126 (copy), proto (copy), t1 (copy)
	local v975 = t126.new()
	local n57 = 0

	while n57 < buffer.len(p84) do
		local v977, v978

		v977, v978, n57 = proto.readTag(p84, n57)

		if v978 == proto.wireTypes.varint then
			local v979

			v979, n57 = proto.readVarInt(p84, n57)
		elseif v978 == proto.wireTypes.lengthDelimited then
			if v977 == 1 then
				local v980

				v980, n57 = proto.readBuffer(p84, n57)
				v975.kind = {
					type = "literal",
					value = buffer.tostring(v980)
				}
			elseif v977 == 2 then
				local v981

				v981, n57 = proto.readBuffer(p84, n57)
				v975.kind = {
					type = "binding_path",
					value = buffer.tostring(v981)
				}
			elseif v977 == 3 then
				local v982

				v982, n57 = proto.readBuffer(p84, n57)
				v975.kind = {
					type = "format",
					value = t1.StringFormat.decode(v982)
				}
			elseif v977 == 4 then
				local v983

				v983, n57 = proto.readBuffer(p84, n57)
				v975.kind = {
					type = "conditional",
					value = t1.ImageStringProp_ConditionalOptions.decode(v983)
				}
			elseif v977 == 5 then
				local v984

				v984, n57 = proto.readBuffer(p84, n57)
				v975.kind = {
					type = "translation",
					value = t1.TranslationRef.decode(v984)
				}
			elseif v977 == 6 then
				local v985

				v985, n57 = proto.readBuffer(p84, n57)
				v975.alt = t1.StringFormat.decode(v985)
			else
				local v986, v987 = proto.readVarInt(p84, n57)

				n57 = v987 + v986
			end
		elseif v978 == proto.wireTypes.i32 then
			local v988

			v988, n57 = proto.readFixed32(p84, n57)
		elseif v978 == proto.wireTypes.i64 then
			local v989

			v989, n57 = proto.readFixed64(p84, n57)
		else
			error("Unsupported wire type: " .. v978)
		end
	end

	return v975
end
function t126.jsonEncode(p85) -- line: 6711
	local t128 = {}

	if p85.kind ~= nil then
		if p85.kind.type == "literal" then
			t128.literal = p85.kind.value
		elseif p85.kind.type == "binding_path" then
			t128.bindingPath = p85.kind.value
		elseif p85.kind.type == "format" then
			t128.format = p85.kind.value:jsonEncode()
		elseif p85.kind.type == "conditional" then
			t128.conditional = p85.kind.value:jsonEncode()
		elseif p85.kind.type == "translation" then
			t128.translation = p85.kind.value:jsonEncode()
		end
	end

	if p85.alt ~= nil then
		t128.alt = p85.alt:jsonEncode()
	end

	return t128
end
function t126.jsonDecode(t129: {[any]: any}) -- line: 6735
	-- upvalues: t126 (copy), t1 (copy)
	local v993 = t126.new()

	if t129.literal ~= nil then
		v993.kind = {
			type = "literal",
			value = t129.literal
		}
	end

	if t129.binding_path ~= nil then
		v993.kind = {
			type = "binding_path",
			value = t129.binding_path
		}
	end

	if t129.bindingPath ~= nil then
		v993.kind = {
			type = "binding_path",
			value = t129.bindingPath
		}
	end

	if t129.format ~= nil then
		v993.kind = {
			type = "format",
			value = t1.StringFormat.jsonDecode(t129.format)
		}
	end

	if t129.conditional ~= nil then
		v993.kind = {
			type = "conditional",
			value = t1.ImageStringProp_ConditionalOptions.jsonDecode(t129.conditional)
		}
	end

	if t129.translation ~= nil then
		v993.kind = {
			type = "translation",
			value = t1.TranslationRef.jsonDecode(t129.translation)
		}
	end

	if t129.alt ~= nil then
		v993.alt = t1.StringFormat.jsonDecode(t129.alt)
	end

	return v993
end

t126.descriptor = {
	name = "ImageStringProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.ImageStringProp"
}
t1.ImageStringProp = t126
typeRegistry.default:register(t1.ImageStringProp)

local t130 = {}

t130.__index = t130

function t130.new(t131: {[any]: any}?) -- line: 6786
	-- upvalues: t130 (copy)
	return (setmetatable({
		condition = if t131 ~= nil and t131.condition ~= nil then t131.condition else nil,
		kind = if t131 ~= nil and t131.kind ~= nil then t131.kind else nil
	}, t130))
end
function t130.encode(p86) -- line: 6795
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n58 = 0

	if p86.condition ~= nil then
		local v998 = p86.condition:encode()
		local v999, v1000 = proto.writeTag(buf, n58, 1, proto.wireTypes.lengthDelimited)

		buf, n58 = proto.writeBuffer(v999, v1000, v998, buffer.len(v998))
	end

	if p86.kind ~= nil then
		if p86.kind.type == "literal" then
			local v1001, v1002 = proto.writeTag(buf, n58, 2, proto.wireTypes.lengthDelimited)

			buf, n58 = proto.writeString(v1001, v1002, p86.kind.value)
		elseif p86.kind.type == "binding_path" then
			local v1003, v1004 = proto.writeTag(buf, n58, 3, proto.wireTypes.lengthDelimited)

			buf, n58 = proto.writeString(v1003, v1004, p86.kind.value)
		elseif p86.kind.type == "format" then
			local v1005 = p86.kind.value:encode()
			local v1006, v1007 = proto.writeTag(buf, n58, 4, proto.wireTypes.lengthDelimited)

			buf, n58 = proto.writeBuffer(v1006, v1007, v1005, buffer.len(v1005))
		elseif p86.kind.type == "translation" then
			local v1008 = p86.kind.value:encode()
			local v1009, v1010 = proto.writeTag(buf, n58, 5, proto.wireTypes.lengthDelimited)

			buf, n58 = proto.writeBuffer(v1009, v1010, v1008, buffer.len(v1008))
		end
	end

	local buf31 = buffer.create(n58)

	buffer.copy(buf31, 0, buf, 0, n58)

	return buf31
end
function t130.decode(p87: buffer) -- line: 6828
	-- upvalues: t130 (copy), proto (copy), prop_condition (copy), t1 (copy)
	local v1013 = t130.new()
	local n59 = 0

	while n59 < buffer.len(p87) do
		local v1015, v1016

		v1015, v1016, n59 = proto.readTag(p87, n59)

		if v1016 == proto.wireTypes.varint then
			local v1017

			v1017, n59 = proto.readVarInt(p87, n59)
		elseif v1016 == proto.wireTypes.lengthDelimited then
			if v1015 == 1 then
				local v1018

				v1018, n59 = proto.readBuffer(p87, n59)
				v1013.condition = prop_condition.PropCondition.decode(v1018)
			elseif v1015 == 2 then
				local v1019

				v1019, n59 = proto.readBuffer(p87, n59)
				v1013.kind = {
					type = "literal",
					value = buffer.tostring(v1019)
				}
			elseif v1015 == 3 then
				local v1020

				v1020, n59 = proto.readBuffer(p87, n59)
				v1013.kind = {
					type = "binding_path",
					value = buffer.tostring(v1020)
				}
			elseif v1015 == 4 then
				local v1021

				v1021, n59 = proto.readBuffer(p87, n59)
				v1013.kind = {
					type = "format",
					value = t1.StringFormat.decode(v1021)
				}
			elseif v1015 == 5 then
				local v1022

				v1022, n59 = proto.readBuffer(p87, n59)
				v1013.kind = {
					type = "translation",
					value = t1.TranslationRef.decode(v1022)
				}
			else
				local v1023, v1024 = proto.readVarInt(p87, n59)

				n59 = v1024 + v1023
			end
		elseif v1016 == proto.wireTypes.i32 then
			local v1025

			v1025, n59 = proto.readFixed32(p87, n59)
		elseif v1016 == proto.wireTypes.i64 then
			local v1026

			v1026, n59 = proto.readFixed64(p87, n59)
		else
			error("Unsupported wire type: " .. v1016)
		end
	end

	return v1013
end
function t130.jsonEncode(p88) -- line: 6891
	local t132 = {}

	if p88.condition ~= nil then
		t132.condition = p88.condition:jsonEncode()
	end

	if p88.kind ~= nil then
		if p88.kind.type == "literal" then
			t132.literal = p88.kind.value

			return t132
		end

		if p88.kind.type == "binding_path" then
			t132.bindingPath = p88.kind.value

			return t132
		end

		if p88.kind.type == "format" then
			t132.format = p88.kind.value:jsonEncode()

			return t132
		end

		if p88.kind.type == "translation" then
			t132.translation = p88.kind.value:jsonEncode()
		end
	end

	return t132
end
function t130.jsonDecode(t133: {[any]: any}) -- line: 6913
	-- upvalues: t130 (copy), prop_condition (copy), t1 (copy)
	local v1030 = t130.new()

	if t133.condition ~= nil then
		v1030.condition = prop_condition.PropCondition.jsonDecode(t133.condition)
	end

	if t133.literal ~= nil then
		v1030.kind = {
			type = "literal",
			value = t133.literal
		}
	end

	if t133.binding_path ~= nil then
		v1030.kind = {
			type = "binding_path",
			value = t133.binding_path
		}
	end

	if t133.bindingPath ~= nil then
		v1030.kind = {
			type = "binding_path",
			value = t133.bindingPath
		}
	end

	if t133.format ~= nil then
		v1030.kind = {
			type = "format",
			value = t1.StringFormat.jsonDecode(t133.format)
		}
	end

	if t133.translation ~= nil then
		v1030.kind = {
			type = "translation",
			value = t1.TranslationRef.jsonDecode(t133.translation)
		}
	end

	return v1030
end

t130.descriptor = {
	name = "ImageStringProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}
t1.ImageStringProp_ConditionalOption = t130
typeRegistry.default:register(t1.ImageStringProp_ConditionalOption)

local t134 = {}

t134.__index = t134

function t134.new(t135: {[any]: any}?) -- line: 6960
	-- upvalues: t134 (copy)
	return (setmetatable({
		options = if t135 ~= nil and t135.options ~= nil then t135.options else {}
	}, t134))
end
function t134.encode(p89) -- line: 6968
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n60 = 0

	if p89.options ~= nil and #p89.options > 0 then
		for _, v1036 in p89.options do
			local v1037 = v1036:encode()
			local v1038, v1039 = proto.writeTag(buf, n60, 1, proto.wireTypes.lengthDelimited)

			buf, n60 = proto.writeBuffer(v1038, v1039, v1037, buffer.len(v1037))
		end
	end

	local buf32 = buffer.create(n60)

	buffer.copy(buf32, 0, buf, 0, n60)

	return buf32
end
function t134.decode(p90: buffer) -- line: 6985
	-- upvalues: t134 (copy), proto (copy), t1 (copy)
	local v1042 = t134.new()
	local n61 = 0

	while n61 < buffer.len(p90) do
		local v1044, v1045

		v1044, v1045, n61 = proto.readTag(p90, n61)

		if v1045 == proto.wireTypes.varint then
			local v1046

			v1046, n61 = proto.readVarInt(p90, n61)
		elseif v1045 == proto.wireTypes.lengthDelimited then
			if v1044 == 1 then
				local v1047

				v1047, n61 = proto.readBuffer(p90, n61)
				table.insert(v1042.options, t1.ImageStringProp_ConditionalOption.decode(v1047))
			else
				local v1048, v1049 = proto.readVarInt(p90, n61)

				n61 = v1049 + v1048
			end
		elseif v1045 == proto.wireTypes.i32 then
			local v1050

			v1050, n61 = proto.readFixed32(p90, n61)
		elseif v1045 == proto.wireTypes.i64 then
			local v1051

			v1051, n61 = proto.readFixed64(p90, n61)
		else
			error("Unsupported wire type: " .. v1045)
		end
	end

	return v1042
end
function t134.jsonEncode(p91) -- line: 7028
	local t136 = {}

	if p91.options ~= nil and #p91.options > 0 then
		local t137 = {}

		for _, v1056 in p91.options do
			table.insert(t137, v1056:jsonEncode())
		end

		t136.options = t137
	end

	return t136
end
function t134.jsonDecode(t138: {[any]: any}) -- line: 7042
	-- upvalues: t134 (copy), t1 (copy)
	local v1058 = t134.new()

	if t138.options ~= nil then
		local t139 = {}

		for _, v1061 in t138.options do
			table.insert(t139, t1.ImageStringProp_ConditionalOption.jsonDecode(v1061))
		end

		v1058.options = t139
	end

	return v1058
end

t134.descriptor = {
	name = "ImageStringProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}
t1.ImageStringProp_ConditionalOptions = t134
typeRegistry.default:register(t1.ImageStringProp_ConditionalOptions)

local t140 = {}

t140.__index = t140

function t140.new(t141: {[any]: any}?) -- line: 7073
	-- upvalues: t140 (copy)
	return (setmetatable({
		kind = if t141 ~= nil and t141.kind ~= nil then t141.kind else nil
	}, t140))
end
function t140.encode(p92) -- line: 7079
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n62 = 0

	if p92.kind ~= nil then
		if p92.kind.type == "literal" then
			local v1066, v1067 = proto.writeTag(buf, n62, 1, proto.wireTypes.lengthDelimited)

			buf, n62 = proto.writeString(v1066, v1067, p92.kind.value)
		elseif p92.kind.type == "binding_path" then
			local v1068, v1069 = proto.writeTag(buf, n62, 2, proto.wireTypes.lengthDelimited)

			buf, n62 = proto.writeString(v1068, v1069, p92.kind.value)
		elseif p92.kind.type == "format" then
			local v1070 = p92.kind.value:encode()
			local v1071, v1072 = proto.writeTag(buf, n62, 3, proto.wireTypes.lengthDelimited)

			buf, n62 = proto.writeBuffer(v1071, v1072, v1070, buffer.len(v1070))
		elseif p92.kind.type == "conditional" then
			local v1073 = p92.kind.value:encode()
			local v1074, v1075 = proto.writeTag(buf, n62, 4, proto.wireTypes.lengthDelimited)

			buf, n62 = proto.writeBuffer(v1074, v1075, v1073, buffer.len(v1073))
		elseif p92.kind.type == "translation" then
			local v1076 = p92.kind.value:encode()
			local v1077, v1078 = proto.writeTag(buf, n62, 5, proto.wireTypes.lengthDelimited)

			buf, n62 = proto.writeBuffer(v1077, v1078, v1076, buffer.len(v1076))
		end
	end

	local buf33 = buffer.create(n62)

	buffer.copy(buf33, 0, buf, 0, n62)

	return buf33
end
function t140.decode(p93: buffer) -- line: 7110
	-- upvalues: t140 (copy), proto (copy), t1 (copy)
	local v1081 = t140.new()
	local n63 = 0

	while n63 < buffer.len(p93) do
		local v1083, v1084

		v1083, v1084, n63 = proto.readTag(p93, n63)

		if v1084 == proto.wireTypes.varint then
			local v1085

			v1085, n63 = proto.readVarInt(p93, n63)
		elseif v1084 == proto.wireTypes.lengthDelimited then
			if v1083 == 1 then
				local v1086

				v1086, n63 = proto.readBuffer(p93, n63)
				v1081.kind = {
					type = "literal",
					value = buffer.tostring(v1086)
				}
			elseif v1083 == 2 then
				local v1087

				v1087, n63 = proto.readBuffer(p93, n63)
				v1081.kind = {
					type = "binding_path",
					value = buffer.tostring(v1087)
				}
			elseif v1083 == 3 then
				local v1088

				v1088, n63 = proto.readBuffer(p93, n63)
				v1081.kind = {
					type = "format",
					value = t1.StringFormat.decode(v1088)
				}
			elseif v1083 == 4 then
				local v1089

				v1089, n63 = proto.readBuffer(p93, n63)
				v1081.kind = {
					type = "conditional",
					value = t1.ImageSetProp_ConditionalOptions.decode(v1089)
				}
			elseif v1083 == 5 then
				local v1090

				v1090, n63 = proto.readBuffer(p93, n63)
				v1081.kind = {
					type = "translation",
					value = t1.TranslationRef.decode(v1090)
				}
			else
				local v1091, v1092 = proto.readVarInt(p93, n63)

				n63 = v1092 + v1091
			end
		elseif v1084 == proto.wireTypes.i32 then
			local v1093

			v1093, n63 = proto.readFixed32(p93, n63)
		elseif v1084 == proto.wireTypes.i64 then
			local v1094

			v1094, n63 = proto.readFixed64(p93, n63)
		else
			error("Unsupported wire type: " .. v1084)
		end
	end

	return v1081
end
function t140.jsonEncode(p94) -- line: 7173
	local t142 = {}

	if p94.kind ~= nil then
		if p94.kind.type == "literal" then
			t142.literal = p94.kind.value

			return t142
		end

		if p94.kind.type == "binding_path" then
			t142.bindingPath = p94.kind.value

			return t142
		end

		if p94.kind.type == "format" then
			t142.format = p94.kind.value:jsonEncode()

			return t142
		end

		if p94.kind.type == "conditional" then
			t142.conditional = p94.kind.value:jsonEncode()

			return t142
		end

		if p94.kind.type == "translation" then
			t142.translation = p94.kind.value:jsonEncode()
		end
	end

	return t142
end
function t140.jsonDecode(t143: {[any]: any}) -- line: 7193
	-- upvalues: t140 (copy), t1 (copy)
	local v1098 = t140.new()

	if t143.literal ~= nil then
		v1098.kind = {
			type = "literal",
			value = t143.literal
		}
	end

	if t143.binding_path ~= nil then
		v1098.kind = {
			type = "binding_path",
			value = t143.binding_path
		}
	end

	if t143.bindingPath ~= nil then
		v1098.kind = {
			type = "binding_path",
			value = t143.bindingPath
		}
	end

	if t143.format ~= nil then
		v1098.kind = {
			type = "format",
			value = t1.StringFormat.jsonDecode(t143.format)
		}
	end

	if t143.conditional ~= nil then
		v1098.kind = {
			type = "conditional",
			value = t1.ImageSetProp_ConditionalOptions.jsonDecode(t143.conditional)
		}
	end

	if t143.translation ~= nil then
		v1098.kind = {
			type = "translation",
			value = t1.TranslationRef.jsonDecode(t143.translation)
		}
	end

	return v1098
end

t140.descriptor = {
	name = "ImageSetProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.ImageSetProp"
}
t1.ImageSetProp = t140
typeRegistry.default:register(t1.ImageSetProp)

local t144 = {}

t144.__index = t144

function t144.new(t145: {[any]: any}?) -- line: 7238
	-- upvalues: t144 (copy)
	return (setmetatable({
		condition = if t145 ~= nil and t145.condition ~= nil then t145.condition else nil,
		kind = if t145 ~= nil and t145.kind ~= nil then t145.kind else nil
	}, t144))
end
function t144.encode(p95) -- line: 7247
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n64 = 0

	if p95.condition ~= nil then
		local v1103 = p95.condition:encode()
		local v1104, v1105 = proto.writeTag(buf, n64, 1, proto.wireTypes.lengthDelimited)

		buf, n64 = proto.writeBuffer(v1104, v1105, v1103, buffer.len(v1103))
	end

	if p95.kind ~= nil then
		if p95.kind.type == "literal" then
			local v1106, v1107 = proto.writeTag(buf, n64, 2, proto.wireTypes.lengthDelimited)

			buf, n64 = proto.writeString(v1106, v1107, p95.kind.value)
		elseif p95.kind.type == "binding_path" then
			local v1108, v1109 = proto.writeTag(buf, n64, 3, proto.wireTypes.lengthDelimited)

			buf, n64 = proto.writeString(v1108, v1109, p95.kind.value)
		elseif p95.kind.type == "format" then
			local v1110 = p95.kind.value:encode()
			local v1111, v1112 = proto.writeTag(buf, n64, 4, proto.wireTypes.lengthDelimited)

			buf, n64 = proto.writeBuffer(v1111, v1112, v1110, buffer.len(v1110))
		elseif p95.kind.type == "translation" then
			local v1113 = p95.kind.value:encode()
			local v1114, v1115 = proto.writeTag(buf, n64, 5, proto.wireTypes.lengthDelimited)

			buf, n64 = proto.writeBuffer(v1114, v1115, v1113, buffer.len(v1113))
		end
	end

	local buf34 = buffer.create(n64)

	buffer.copy(buf34, 0, buf, 0, n64)

	return buf34
end
function t144.decode(p96: buffer) -- line: 7280
	-- upvalues: t144 (copy), proto (copy), prop_condition (copy), t1 (copy)
	local v1118 = t144.new()
	local n65 = 0

	while n65 < buffer.len(p96) do
		local v1120, v1121

		v1120, v1121, n65 = proto.readTag(p96, n65)

		if v1121 == proto.wireTypes.varint then
			local v1122

			v1122, n65 = proto.readVarInt(p96, n65)
		elseif v1121 == proto.wireTypes.lengthDelimited then
			if v1120 == 1 then
				local v1123

				v1123, n65 = proto.readBuffer(p96, n65)
				v1118.condition = prop_condition.PropCondition.decode(v1123)
			elseif v1120 == 2 then
				local v1124

				v1124, n65 = proto.readBuffer(p96, n65)
				v1118.kind = {
					type = "literal",
					value = buffer.tostring(v1124)
				}
			elseif v1120 == 3 then
				local v1125

				v1125, n65 = proto.readBuffer(p96, n65)
				v1118.kind = {
					type = "binding_path",
					value = buffer.tostring(v1125)
				}
			elseif v1120 == 4 then
				local v1126

				v1126, n65 = proto.readBuffer(p96, n65)
				v1118.kind = {
					type = "format",
					value = t1.StringFormat.decode(v1126)
				}
			elseif v1120 == 5 then
				local v1127

				v1127, n65 = proto.readBuffer(p96, n65)
				v1118.kind = {
					type = "translation",
					value = t1.TranslationRef.decode(v1127)
				}
			else
				local v1128, v1129 = proto.readVarInt(p96, n65)

				n65 = v1129 + v1128
			end
		elseif v1121 == proto.wireTypes.i32 then
			local v1130

			v1130, n65 = proto.readFixed32(p96, n65)
		elseif v1121 == proto.wireTypes.i64 then
			local v1131

			v1131, n65 = proto.readFixed64(p96, n65)
		else
			error("Unsupported wire type: " .. v1121)
		end
	end

	return v1118
end
function t144.jsonEncode(p97) -- line: 7343
	local t146 = {}

	if p97.condition ~= nil then
		t146.condition = p97.condition:jsonEncode()
	end

	if p97.kind ~= nil then
		if p97.kind.type == "literal" then
			t146.literal = p97.kind.value

			return t146
		end

		if p97.kind.type == "binding_path" then
			t146.bindingPath = p97.kind.value

			return t146
		end

		if p97.kind.type == "format" then
			t146.format = p97.kind.value:jsonEncode()

			return t146
		end

		if p97.kind.type == "translation" then
			t146.translation = p97.kind.value:jsonEncode()
		end
	end

	return t146
end
function t144.jsonDecode(t147: {[any]: any}) -- line: 7365
	-- upvalues: t144 (copy), prop_condition (copy), t1 (copy)
	local v1135 = t144.new()

	if t147.condition ~= nil then
		v1135.condition = prop_condition.PropCondition.jsonDecode(t147.condition)
	end

	if t147.literal ~= nil then
		v1135.kind = {
			type = "literal",
			value = t147.literal
		}
	end

	if t147.binding_path ~= nil then
		v1135.kind = {
			type = "binding_path",
			value = t147.binding_path
		}
	end

	if t147.bindingPath ~= nil then
		v1135.kind = {
			type = "binding_path",
			value = t147.bindingPath
		}
	end

	if t147.format ~= nil then
		v1135.kind = {
			type = "format",
			value = t1.StringFormat.jsonDecode(t147.format)
		}
	end

	if t147.translation ~= nil then
		v1135.kind = {
			type = "translation",
			value = t1.TranslationRef.jsonDecode(t147.translation)
		}
	end

	return v1135
end

t144.descriptor = {
	name = "ImageSetProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}
t1.ImageSetProp_ConditionalOption = t144
typeRegistry.default:register(t1.ImageSetProp_ConditionalOption)

local t148 = {}

t148.__index = t148

function t148.new(t149: {[any]: any}?) -- line: 7410
	-- upvalues: t148 (copy)
	return (setmetatable({
		options = if t149 ~= nil and t149.options ~= nil then t149.options else {}
	}, t148))
end
function t148.encode(p98) -- line: 7418
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n66 = 0

	if p98.options ~= nil and #p98.options > 0 then
		for _, v1141 in p98.options do
			local v1142 = v1141:encode()
			local v1143, v1144 = proto.writeTag(buf, n66, 1, proto.wireTypes.lengthDelimited)

			buf, n66 = proto.writeBuffer(v1143, v1144, v1142, buffer.len(v1142))
		end
	end

	local buf35 = buffer.create(n66)

	buffer.copy(buf35, 0, buf, 0, n66)

	return buf35
end
function t148.decode(p99: buffer) -- line: 7435
	-- upvalues: t148 (copy), proto (copy), t1 (copy)
	local v1147 = t148.new()
	local n67 = 0

	while n67 < buffer.len(p99) do
		local v1149, v1150

		v1149, v1150, n67 = proto.readTag(p99, n67)

		if v1150 == proto.wireTypes.varint then
			local v1151

			v1151, n67 = proto.readVarInt(p99, n67)
		elseif v1150 == proto.wireTypes.lengthDelimited then
			if v1149 == 1 then
				local v1152

				v1152, n67 = proto.readBuffer(p99, n67)
				table.insert(v1147.options, t1.ImageSetProp_ConditionalOption.decode(v1152))
			else
				local v1153, v1154 = proto.readVarInt(p99, n67)

				n67 = v1154 + v1153
			end
		elseif v1150 == proto.wireTypes.i32 then
			local v1155

			v1155, n67 = proto.readFixed32(p99, n67)
		elseif v1150 == proto.wireTypes.i64 then
			local v1156

			v1156, n67 = proto.readFixed64(p99, n67)
		else
			error("Unsupported wire type: " .. v1150)
		end
	end

	return v1147
end
function t148.jsonEncode(p100) -- line: 7478
	local t150 = {}

	if p100.options ~= nil and #p100.options > 0 then
		local t151 = {}

		for _, v1161 in p100.options do
			table.insert(t151, v1161:jsonEncode())
		end

		t150.options = t151
	end

	return t150
end
function t148.jsonDecode(t152: {[any]: any}) -- line: 7492
	-- upvalues: t148 (copy), t1 (copy)
	local v1163 = t148.new()

	if t152.options ~= nil then
		local t153 = {}

		for _, v1166 in t152.options do
			table.insert(t153, t1.ImageSetProp_ConditionalOption.jsonDecode(v1166))
		end

		v1163.options = t153
	end

	return v1163
end

t148.descriptor = {
	name = "ImageSetProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}
t1.ImageSetProp_ConditionalOptions = t148
typeRegistry.default:register(t1.ImageSetProp_ConditionalOptions)

local t154 = {}

t154.__index = t154

function t154.new(t155: {[any]: any}?) -- line: 7521
	-- upvalues: t154 (copy)
	return (setmetatable({
		kind = if t155 ~= nil and t155.kind ~= nil then t155.kind else nil
	}, t154))
end
function t154.encode(p101) -- line: 7527
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n68 = 0

	if p101.kind ~= nil then
		if p101.kind.type == "literal" then
			local v1171, v1172 = proto.writeTag(buf, n68, 1, proto.wireTypes.lengthDelimited)

			buf, n68 = proto.writeString(v1171, v1172, p101.kind.value)
		elseif p101.kind.type == "token" then
			local v1173, v1174 = proto.writeTag(buf, n68, 2, proto.wireTypes.lengthDelimited)

			buf, n68 = proto.writeString(v1173, v1174, p101.kind.value)
		elseif p101.kind.type == "conditional" then
			local v1175 = p101.kind.value:encode()
			local v1176, v1177 = proto.writeTag(buf, n68, 3, proto.wireTypes.lengthDelimited)

			buf, n68 = proto.writeBuffer(v1176, v1177, v1175, buffer.len(v1175))
		elseif p101.kind.type == "binding_path" then
			local v1178, v1179 = proto.writeTag(buf, n68, 4, proto.wireTypes.lengthDelimited)

			buf, n68 = proto.writeString(v1178, v1179, p101.kind.value)
		end
	end

	local buf36 = buffer.create(n68)

	buffer.copy(buf36, 0, buf, 0, n68)

	return buf36
end
function t154.decode(p102: buffer) -- line: 7553
	-- upvalues: t154 (copy), proto (copy), t1 (copy)
	local v1182 = t154.new()
	local n69 = 0

	while n69 < buffer.len(p102) do
		local v1184, v1185

		v1184, v1185, n69 = proto.readTag(p102, n69)

		if v1185 == proto.wireTypes.varint then
			local v1186

			v1186, n69 = proto.readVarInt(p102, n69)
		elseif v1185 == proto.wireTypes.lengthDelimited then
			if v1184 == 1 then
				local v1187

				v1187, n69 = proto.readBuffer(p102, n69)
				v1182.kind = {
					type = "literal",
					value = buffer.tostring(v1187)
				}
			elseif v1184 == 2 then
				local v1188

				v1188, n69 = proto.readBuffer(p102, n69)
				v1182.kind = {
					type = "token",
					value = buffer.tostring(v1188)
				}
			elseif v1184 == 3 then
				local v1189

				v1189, n69 = proto.readBuffer(p102, n69)
				v1182.kind = {
					type = "conditional",
					value = t1.ColorProp_ConditionalOptions.decode(v1189)
				}
			elseif v1184 == 4 then
				local v1190

				v1190, n69 = proto.readBuffer(p102, n69)
				v1182.kind = {
					type = "binding_path",
					value = buffer.tostring(v1190)
				}
			else
				local v1191, v1192 = proto.readVarInt(p102, n69)

				n69 = v1192 + v1191
			end
		elseif v1185 == proto.wireTypes.i32 then
			local v1193

			v1193, n69 = proto.readFixed32(p102, n69)
		elseif v1185 == proto.wireTypes.i64 then
			local v1194

			v1194, n69 = proto.readFixed64(p102, n69)
		else
			error("Unsupported wire type: " .. v1185)
		end
	end

	return v1182
end
function t154.jsonEncode(p103) -- line: 7611
	local t156 = {}

	if p103.kind ~= nil then
		if p103.kind.type == "literal" then
			t156.literal = p103.kind.value

			return t156
		end

		if p103.kind.type == "token" then
			t156.token = p103.kind.value

			return t156
		end

		if p103.kind.type == "conditional" then
			t156.conditional = p103.kind.value:jsonEncode()

			return t156
		end

		if p103.kind.type == "binding_path" then
			t156.bindingPath = p103.kind.value
		end
	end

	return t156
end
function t154.jsonDecode(t157: {[any]: any}) -- line: 7629
	-- upvalues: t154 (copy), t1 (copy)
	local v1198 = t154.new()

	if t157.literal ~= nil then
		v1198.kind = {
			type = "literal",
			value = t157.literal
		}
	end

	if t157.token ~= nil then
		v1198.kind = {
			type = "token",
			value = t157.token
		}
	end

	if t157.conditional ~= nil then
		v1198.kind = {
			type = "conditional",
			value = t1.ColorProp_ConditionalOptions.jsonDecode(t157.conditional)
		}
	end

	if t157.binding_path ~= nil then
		v1198.kind = {
			type = "binding_path",
			value = t157.binding_path
		}
	end

	if t157.bindingPath ~= nil then
		v1198.kind = {
			type = "binding_path",
			value = t157.bindingPath
		}
	end

	return v1198
end

t154.descriptor = {
	name = "ColorProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.ColorProp"
}
t1.ColorProp = t154
typeRegistry.default:register(t1.ColorProp)

local t158 = {}

t158.__index = t158

function t158.new(t159: {[any]: any}?) -- line: 7670
	-- upvalues: t158 (copy)
	return (setmetatable({
		condition = if t159 ~= nil and t159.condition ~= nil then t159.condition else nil,
		kind = if t159 ~= nil and t159.kind ~= nil then t159.kind else nil
	}, t158))
end
function t158.encode(p104) -- line: 7679
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n70 = 0

	if p104.condition ~= nil then
		local v1203 = p104.condition:encode()
		local v1204, v1205 = proto.writeTag(buf, n70, 1, proto.wireTypes.lengthDelimited)

		buf, n70 = proto.writeBuffer(v1204, v1205, v1203, buffer.len(v1203))
	end

	if p104.kind ~= nil then
		if p104.kind.type == "literal" then
			local v1206, v1207 = proto.writeTag(buf, n70, 2, proto.wireTypes.lengthDelimited)

			buf, n70 = proto.writeString(v1206, v1207, p104.kind.value)
		elseif p104.kind.type == "token" then
			local v1208, v1209 = proto.writeTag(buf, n70, 3, proto.wireTypes.lengthDelimited)

			buf, n70 = proto.writeString(v1208, v1209, p104.kind.value)
		elseif p104.kind.type == "binding_path" then
			local v1210, v1211 = proto.writeTag(buf, n70, 4, proto.wireTypes.lengthDelimited)

			buf, n70 = proto.writeString(v1210, v1211, p104.kind.value)
		end
	end

	local buf37 = buffer.create(n70)

	buffer.copy(buf37, 0, buf, 0, n70)

	return buf37
end
function t158.decode(p105: buffer) -- line: 7707
	-- upvalues: t158 (copy), proto (copy), prop_condition (copy)
	local v1214 = t158.new()
	local n71 = 0

	while n71 < buffer.len(p105) do
		local v1216, v1217

		v1216, v1217, n71 = proto.readTag(p105, n71)

		if v1217 == proto.wireTypes.varint then
			local v1218

			v1218, n71 = proto.readVarInt(p105, n71)
		elseif v1217 == proto.wireTypes.lengthDelimited then
			if v1216 == 1 then
				local v1219

				v1219, n71 = proto.readBuffer(p105, n71)
				v1214.condition = prop_condition.PropCondition.decode(v1219)
			elseif v1216 == 2 then
				local v1220

				v1220, n71 = proto.readBuffer(p105, n71)
				v1214.kind = {
					type = "literal",
					value = buffer.tostring(v1220)
				}
			elseif v1216 == 3 then
				local v1221

				v1221, n71 = proto.readBuffer(p105, n71)
				v1214.kind = {
					type = "token",
					value = buffer.tostring(v1221)
				}
			elseif v1216 == 4 then
				local v1222

				v1222, n71 = proto.readBuffer(p105, n71)
				v1214.kind = {
					type = "binding_path",
					value = buffer.tostring(v1222)
				}
			else
				local v1223, v1224 = proto.readVarInt(p105, n71)

				n71 = v1224 + v1223
			end
		elseif v1217 == proto.wireTypes.i32 then
			local v1225

			v1225, n71 = proto.readFixed32(p105, n71)
		elseif v1217 == proto.wireTypes.i64 then
			local v1226

			v1226, n71 = proto.readFixed64(p105, n71)
		else
			error("Unsupported wire type: " .. v1217)
		end
	end

	return v1214
end
function t158.jsonEncode(p106) -- line: 7765
	local t160 = {}

	if p106.condition ~= nil then
		t160.condition = p106.condition:jsonEncode()
	end

	if p106.kind ~= nil then
		if p106.kind.type == "literal" then
			t160.literal = p106.kind.value

			return t160
		end

		if p106.kind.type == "token" then
			t160.token = p106.kind.value

			return t160
		end

		if p106.kind.type == "binding_path" then
			t160.bindingPath = p106.kind.value
		end
	end

	return t160
end
function t158.jsonDecode(t161: {[any]: any}) -- line: 7785
	-- upvalues: t158 (copy), prop_condition (copy)
	local v1230 = t158.new()

	if t161.condition ~= nil then
		v1230.condition = prop_condition.PropCondition.jsonDecode(t161.condition)
	end

	if t161.literal ~= nil then
		v1230.kind = {
			type = "literal",
			value = t161.literal
		}
	end

	if t161.token ~= nil then
		v1230.kind = {
			type = "token",
			value = t161.token
		}
	end

	if t161.binding_path ~= nil then
		v1230.kind = {
			type = "binding_path",
			value = t161.binding_path
		}
	end

	if t161.bindingPath ~= nil then
		v1230.kind = {
			type = "binding_path",
			value = t161.bindingPath
		}
	end

	return v1230
end

t158.descriptor = {
	name = "ColorProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}
t1.ColorProp_ConditionalOption = t158
typeRegistry.default:register(t1.ColorProp_ConditionalOption)

local t162 = {}

t162.__index = t162

function t162.new(t163: {[any]: any}?) -- line: 7826
	-- upvalues: t162 (copy)
	return (setmetatable({
		options = if t163 ~= nil and t163.options ~= nil then t163.options else {}
	}, t162))
end
function t162.encode(p107) -- line: 7834
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n72 = 0

	if p107.options ~= nil and #p107.options > 0 then
		for _, v1236 in p107.options do
			local v1237 = v1236:encode()
			local v1238, v1239 = proto.writeTag(buf, n72, 1, proto.wireTypes.lengthDelimited)

			buf, n72 = proto.writeBuffer(v1238, v1239, v1237, buffer.len(v1237))
		end
	end

	local buf38 = buffer.create(n72)

	buffer.copy(buf38, 0, buf, 0, n72)

	return buf38
end
function t162.decode(p108: buffer) -- line: 7851
	-- upvalues: t162 (copy), proto (copy), t1 (copy)
	local v1242 = t162.new()
	local n73 = 0

	while n73 < buffer.len(p108) do
		local v1244, v1245

		v1244, v1245, n73 = proto.readTag(p108, n73)

		if v1245 == proto.wireTypes.varint then
			local v1246

			v1246, n73 = proto.readVarInt(p108, n73)
		elseif v1245 == proto.wireTypes.lengthDelimited then
			if v1244 == 1 then
				local v1247

				v1247, n73 = proto.readBuffer(p108, n73)
				table.insert(v1242.options, t1.ColorProp_ConditionalOption.decode(v1247))
			else
				local v1248, v1249 = proto.readVarInt(p108, n73)

				n73 = v1249 + v1248
			end
		elseif v1245 == proto.wireTypes.i32 then
			local v1250

			v1250, n73 = proto.readFixed32(p108, n73)
		elseif v1245 == proto.wireTypes.i64 then
			local v1251

			v1251, n73 = proto.readFixed64(p108, n73)
		else
			error("Unsupported wire type: " .. v1245)
		end
	end

	return v1242
end
function t162.jsonEncode(p109) -- line: 7894
	local t164 = {}

	if p109.options ~= nil and #p109.options > 0 then
		local t165 = {}

		for _, v1256 in p109.options do
			table.insert(t165, v1256:jsonEncode())
		end

		t164.options = t165
	end

	return t164
end
function t162.jsonDecode(t166: {[any]: any}) -- line: 7908
	-- upvalues: t162 (copy), t1 (copy)
	local v1258 = t162.new()

	if t166.options ~= nil then
		local t167 = {}

		for _, v1261 in t166.options do
			table.insert(t167, t1.ColorProp_ConditionalOption.jsonDecode(v1261))
		end

		v1258.options = t167
	end

	return v1258
end

t162.descriptor = {
	name = "ColorProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}
t1.ColorProp_ConditionalOptions = t162
typeRegistry.default:register(t1.ColorProp_ConditionalOptions)

local t168 = {}

t168.__index = t168

function t168.new(t169: {[any]: any}?) -- line: 7937
	-- upvalues: t168 (copy)
	return (setmetatable({
		kind = if t169 ~= nil and t169.kind ~= nil then t169.kind else nil
	}, t168))
end
function t168.encode(p110) -- line: 7943
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n74 = 0

	if p110.kind ~= nil then
		if p110.kind.type == "token" then
			local v1266, v1267 = proto.writeTag(buf, n74, 1, proto.wireTypes.lengthDelimited)

			buf, n74 = proto.writeString(v1266, v1267, p110.kind.value)
		elseif p110.kind.type == "conditional" then
			local v1268 = p110.kind.value:encode()
			local v1269, v1270 = proto.writeTag(buf, n74, 2, proto.wireTypes.lengthDelimited)

			buf, n74 = proto.writeBuffer(v1269, v1270, v1268, buffer.len(v1268))
		end
	end

	local buf39 = buffer.create(n74)

	buffer.copy(buf39, 0, buf, 0, n74)

	return buf39
end
function t168.decode(p111: buffer) -- line: 7963
	-- upvalues: t168 (copy), proto (copy), t1 (copy)
	local v1273 = t168.new()
	local n75 = 0

	while n75 < buffer.len(p111) do
		local v1275, v1276

		v1275, v1276, n75 = proto.readTag(p111, n75)

		if v1276 == proto.wireTypes.varint then
			local v1277

			v1277, n75 = proto.readVarInt(p111, n75)
		elseif v1276 == proto.wireTypes.lengthDelimited then
			if v1275 == 1 then
				local v1278

				v1278, n75 = proto.readBuffer(p111, n75)
				v1273.kind = {
					type = "token",
					value = buffer.tostring(v1278)
				}
			elseif v1275 == 2 then
				local v1279

				v1279, n75 = proto.readBuffer(p111, n75)
				v1273.kind = {
					type = "conditional",
					value = t1.TypographyProp_ConditionalOptions.decode(v1279)
				}
			else
				local v1280, v1281 = proto.readVarInt(p111, n75)

				n75 = v1281 + v1280
			end
		elseif v1276 == proto.wireTypes.i32 then
			local v1282

			v1282, n75 = proto.readFixed32(p111, n75)
		elseif v1276 == proto.wireTypes.i64 then
			local v1283

			v1283, n75 = proto.readFixed64(p111, n75)
		else
			error("Unsupported wire type: " .. v1276)
		end
	end

	return v1273
end
function t168.jsonEncode(p112) -- line: 8012
	local t170 = {}

	if p112.kind ~= nil then
		if p112.kind.type == "token" then
			t170.token = p112.kind.value

			return t170
		end

		if p112.kind.type == "conditional" then
			t170.conditional = p112.kind.value:jsonEncode()
		end
	end

	return t170
end
function t168.jsonDecode(t171: {[any]: any}) -- line: 8026
	-- upvalues: t168 (copy), t1 (copy)
	local v1287 = t168.new()

	if t171.token ~= nil then
		v1287.kind = {
			type = "token",
			value = t171.token
		}
	end

	if t171.conditional ~= nil then
		v1287.kind = {
			type = "conditional",
			value = t1.TypographyProp_ConditionalOptions.jsonDecode(t171.conditional)
		}
	end

	return v1287
end

t168.descriptor = {
	name = "TypographyProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.TypographyProp"
}
t1.TypographyProp = t168
typeRegistry.default:register(t1.TypographyProp)

local t172 = {}

t172.__index = t172

function t172.new(t173: {[any]: any}?) -- line: 8057
	-- upvalues: t172 (copy)
	return (setmetatable({
		condition = if t173 ~= nil and t173.condition ~= nil then t173.condition else nil,
		kind = if t173 ~= nil and t173.kind ~= nil then t173.kind else nil
	}, t172))
end
function t172.encode(p113) -- line: 8066
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n76 = 0

	if p113.condition ~= nil then
		local v1292 = p113.condition:encode()
		local v1293, v1294 = proto.writeTag(buf, n76, 1, proto.wireTypes.lengthDelimited)

		buf, n76 = proto.writeBuffer(v1293, v1294, v1292, buffer.len(v1292))
	end

	if p113.kind ~= nil and p113.kind.type == "token" then
		local v1295, v1296 = proto.writeTag(buf, n76, 2, proto.wireTypes.lengthDelimited)

		buf, n76 = proto.writeString(v1295, v1296, p113.kind.value)
	end

	local buf40 = buffer.create(n76)

	buffer.copy(buf40, 0, buf, 0, n76)

	return buf40
end
function t172.decode(p114: buffer) -- line: 8088
	-- upvalues: t172 (copy), proto (copy), prop_condition (copy)
	local v1299 = t172.new()
	local n77 = 0

	while n77 < buffer.len(p114) do
		local v1301, v1302

		v1301, v1302, n77 = proto.readTag(p114, n77)

		if v1302 == proto.wireTypes.varint then
			local v1303

			v1303, n77 = proto.readVarInt(p114, n77)
		elseif v1302 == proto.wireTypes.lengthDelimited then
			if v1301 == 1 then
				local v1304

				v1304, n77 = proto.readBuffer(p114, n77)
				v1299.condition = prop_condition.PropCondition.decode(v1304)
			elseif v1301 == 2 then
				local v1305

				v1305, n77 = proto.readBuffer(p114, n77)
				v1299.kind = {
					type = "token",
					value = buffer.tostring(v1305)
				}
			else
				local v1306, v1307 = proto.readVarInt(p114, n77)

				n77 = v1307 + v1306
			end
		elseif v1302 == proto.wireTypes.i32 then
			local v1308

			v1308, n77 = proto.readFixed32(p114, n77)
		elseif v1302 == proto.wireTypes.i64 then
			local v1309

			v1309, n77 = proto.readFixed64(p114, n77)
		else
			error("Unsupported wire type: " .. v1302)
		end
	end

	return v1299
end
function t172.jsonEncode(p115) -- line: 8136
	local t174 = {}

	if p115.condition ~= nil then
		t174.condition = p115.condition:jsonEncode()
	end

	if p115.kind ~= nil and p115.kind.type == "token" then
		t174.token = p115.kind.value
	end

	return t174
end
function t172.jsonDecode(t175: {[any]: any}) -- line: 8152
	-- upvalues: t172 (copy), prop_condition (copy)
	local v1313 = t172.new()

	if t175.condition ~= nil then
		v1313.condition = prop_condition.PropCondition.jsonDecode(t175.condition)
	end

	if t175.token ~= nil then
		v1313.kind = {
			type = "token",
			value = t175.token
		}
	end

	return v1313
end

t172.descriptor = {
	name = "TypographyProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}
t1.TypographyProp_ConditionalOption = t172
typeRegistry.default:register(t1.TypographyProp_ConditionalOption)

local t176 = {}

t176.__index = t176

function t176.new(t177: {[any]: any}?) -- line: 8183
	-- upvalues: t176 (copy)
	return (setmetatable({
		options = if t177 ~= nil and t177.options ~= nil then t177.options else {}
	}, t176))
end
function t176.encode(p116) -- line: 8191
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n78 = 0

	if p116.options ~= nil and #p116.options > 0 then
		for _, v1319 in p116.options do
			local v1320 = v1319:encode()
			local v1321, v1322 = proto.writeTag(buf, n78, 1, proto.wireTypes.lengthDelimited)

			buf, n78 = proto.writeBuffer(v1321, v1322, v1320, buffer.len(v1320))
		end
	end

	local buf41 = buffer.create(n78)

	buffer.copy(buf41, 0, buf, 0, n78)

	return buf41
end
function t176.decode(p117: buffer) -- line: 8208
	-- upvalues: t176 (copy), proto (copy), t1 (copy)
	local v1325 = t176.new()
	local n79 = 0

	while n79 < buffer.len(p117) do
		local v1327, v1328

		v1327, v1328, n79 = proto.readTag(p117, n79)

		if v1328 == proto.wireTypes.varint then
			local v1329

			v1329, n79 = proto.readVarInt(p117, n79)
		elseif v1328 == proto.wireTypes.lengthDelimited then
			if v1327 == 1 then
				local v1330

				v1330, n79 = proto.readBuffer(p117, n79)
				table.insert(v1325.options, t1.TypographyProp_ConditionalOption.decode(v1330))
			else
				local v1331, v1332 = proto.readVarInt(p117, n79)

				n79 = v1332 + v1331
			end
		elseif v1328 == proto.wireTypes.i32 then
			local v1333

			v1333, n79 = proto.readFixed32(p117, n79)
		elseif v1328 == proto.wireTypes.i64 then
			local v1334

			v1334, n79 = proto.readFixed64(p117, n79)
		else
			error("Unsupported wire type: " .. v1328)
		end
	end

	return v1325
end
function t176.jsonEncode(p118) -- line: 8251
	local t178 = {}

	if p118.options ~= nil and #p118.options > 0 then
		local t179 = {}

		for _, v1339 in p118.options do
			table.insert(t179, v1339:jsonEncode())
		end

		t178.options = t179
	end

	return t178
end
function t176.jsonDecode(t180: {[any]: any}) -- line: 8265
	-- upvalues: t176 (copy), t1 (copy)
	local v1341 = t176.new()

	if t180.options ~= nil then
		local t181 = {}

		for _, v1344 in t180.options do
			table.insert(t181, t1.TypographyProp_ConditionalOption.jsonDecode(v1344))
		end

		v1341.options = t181
	end

	return v1341
end

t176.descriptor = {
	name = "TypographyProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}
t1.TypographyProp_ConditionalOptions = t176
typeRegistry.default:register(t1.TypographyProp_ConditionalOptions)

local t182 = {}

t182.__index = t182

function t182.new(t183: {[any]: any}?) -- line: 8296
	-- upvalues: t182 (copy)
	return (setmetatable({
		kind = if t183 ~= nil and t183.kind ~= nil then t183.kind else nil
	}, t182))
end
function t182.encode(p119) -- line: 8302
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n80 = 0

	if p119.kind ~= nil then
		if p119.kind.type == "token" then
			local v1349, v1350 = proto.writeTag(buf, n80, 1, proto.wireTypes.lengthDelimited)

			buf, n80 = proto.writeString(v1349, v1350, p119.kind.value)
		elseif p119.kind.type == "conditional" then
			local v1351 = p119.kind.value:encode()
			local v1352, v1353 = proto.writeTag(buf, n80, 2, proto.wireTypes.lengthDelimited)

			buf, n80 = proto.writeBuffer(v1352, v1353, v1351, buffer.len(v1351))
		end
	end

	local buf42 = buffer.create(n80)

	buffer.copy(buf42, 0, buf, 0, n80)

	return buf42
end
function t182.decode(p120: buffer) -- line: 8322
	-- upvalues: t182 (copy), proto (copy), t1 (copy)
	local v1356 = t182.new()
	local n81 = 0

	while n81 < buffer.len(p120) do
		local v1358, v1359

		v1358, v1359, n81 = proto.readTag(p120, n81)

		if v1359 == proto.wireTypes.varint then
			local v1360

			v1360, n81 = proto.readVarInt(p120, n81)
		elseif v1359 == proto.wireTypes.lengthDelimited then
			if v1358 == 1 then
				local v1361

				v1361, n81 = proto.readBuffer(p120, n81)
				v1356.kind = {
					type = "token",
					value = buffer.tostring(v1361)
				}
			elseif v1358 == 2 then
				local v1362

				v1362, n81 = proto.readBuffer(p120, n81)
				v1356.kind = {
					type = "conditional",
					value = t1.TypographyFontProp_ConditionalOptions.decode(v1362)
				}
			else
				local v1363, v1364 = proto.readVarInt(p120, n81)

				n81 = v1364 + v1363
			end
		elseif v1359 == proto.wireTypes.i32 then
			local v1365

			v1365, n81 = proto.readFixed32(p120, n81)
		elseif v1359 == proto.wireTypes.i64 then
			local v1366

			v1366, n81 = proto.readFixed64(p120, n81)
		else
			error("Unsupported wire type: " .. v1359)
		end
	end

	return v1356
end
function t182.jsonEncode(p121) -- line: 8371
	local t184 = {}

	if p121.kind ~= nil then
		if p121.kind.type == "token" then
			t184.token = p121.kind.value

			return t184
		end

		if p121.kind.type == "conditional" then
			t184.conditional = p121.kind.value:jsonEncode()
		end
	end

	return t184
end
function t182.jsonDecode(t185: {[any]: any}) -- line: 8385
	-- upvalues: t182 (copy), t1 (copy)
	local v1370 = t182.new()

	if t185.token ~= nil then
		v1370.kind = {
			type = "token",
			value = t185.token
		}
	end

	if t185.conditional ~= nil then
		v1370.kind = {
			type = "conditional",
			value = t1.TypographyFontProp_ConditionalOptions.jsonDecode(t185.conditional)
		}
	end

	return v1370
end

t182.descriptor = {
	name = "TypographyFontProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.TypographyFontProp"
}
t1.TypographyFontProp = t182
typeRegistry.default:register(t1.TypographyFontProp)

local t186 = {}

t186.__index = t186

function t186.new(t187: {[any]: any}?) -- line: 8416
	-- upvalues: t186 (copy)
	return (setmetatable({
		condition = if t187 ~= nil and t187.condition ~= nil then t187.condition else nil,
		kind = if t187 ~= nil and t187.kind ~= nil then t187.kind else nil
	}, t186))
end
function t186.encode(p122) -- line: 8425
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n82 = 0

	if p122.condition ~= nil then
		local v1375 = p122.condition:encode()
		local v1376, v1377 = proto.writeTag(buf, n82, 1, proto.wireTypes.lengthDelimited)

		buf, n82 = proto.writeBuffer(v1376, v1377, v1375, buffer.len(v1375))
	end

	if p122.kind ~= nil and p122.kind.type == "token" then
		local v1378, v1379 = proto.writeTag(buf, n82, 2, proto.wireTypes.lengthDelimited)

		buf, n82 = proto.writeString(v1378, v1379, p122.kind.value)
	end

	local buf43 = buffer.create(n82)

	buffer.copy(buf43, 0, buf, 0, n82)

	return buf43
end
function t186.decode(p123: buffer) -- line: 8447
	-- upvalues: t186 (copy), proto (copy), prop_condition (copy)
	local v1382 = t186.new()
	local n83 = 0

	while n83 < buffer.len(p123) do
		local v1384, v1385

		v1384, v1385, n83 = proto.readTag(p123, n83)

		if v1385 == proto.wireTypes.varint then
			local v1386

			v1386, n83 = proto.readVarInt(p123, n83)
		elseif v1385 == proto.wireTypes.lengthDelimited then
			if v1384 == 1 then
				local v1387

				v1387, n83 = proto.readBuffer(p123, n83)
				v1382.condition = prop_condition.PropCondition.decode(v1387)
			elseif v1384 == 2 then
				local v1388

				v1388, n83 = proto.readBuffer(p123, n83)
				v1382.kind = {
					type = "token",
					value = buffer.tostring(v1388)
				}
			else
				local v1389, v1390 = proto.readVarInt(p123, n83)

				n83 = v1390 + v1389
			end
		elseif v1385 == proto.wireTypes.i32 then
			local v1391

			v1391, n83 = proto.readFixed32(p123, n83)
		elseif v1385 == proto.wireTypes.i64 then
			local v1392

			v1392, n83 = proto.readFixed64(p123, n83)
		else
			error("Unsupported wire type: " .. v1385)
		end
	end

	return v1382
end
function t186.jsonEncode(p124) -- line: 8495
	local t188 = {}

	if p124.condition ~= nil then
		t188.condition = p124.condition:jsonEncode()
	end

	if p124.kind ~= nil and p124.kind.type == "token" then
		t188.token = p124.kind.value
	end

	return t188
end
function t186.jsonDecode(t189: {[any]: any}) -- line: 8511
	-- upvalues: t186 (copy), prop_condition (copy)
	local v1396 = t186.new()

	if t189.condition ~= nil then
		v1396.condition = prop_condition.PropCondition.jsonDecode(t189.condition)
	end

	if t189.token ~= nil then
		v1396.kind = {
			type = "token",
			value = t189.token
		}
	end

	return v1396
end

t186.descriptor = {
	name = "TypographyFontProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}
t1.TypographyFontProp_ConditionalOption = t186
typeRegistry.default:register(t1.TypographyFontProp_ConditionalOption)

local t190 = {}

t190.__index = t190

function t190.new(t191: {[any]: any}?) -- line: 8542
	-- upvalues: t190 (copy)
	return (setmetatable({
		options = if t191 ~= nil and t191.options ~= nil then t191.options else {}
	}, t190))
end
function t190.encode(p125) -- line: 8550
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n84 = 0

	if p125.options ~= nil and #p125.options > 0 then
		for _, v1402 in p125.options do
			local v1403 = v1402:encode()
			local v1404, v1405 = proto.writeTag(buf, n84, 1, proto.wireTypes.lengthDelimited)

			buf, n84 = proto.writeBuffer(v1404, v1405, v1403, buffer.len(v1403))
		end
	end

	local buf44 = buffer.create(n84)

	buffer.copy(buf44, 0, buf, 0, n84)

	return buf44
end
function t190.decode(p126: buffer) -- line: 8567
	-- upvalues: t190 (copy), proto (copy), t1 (copy)
	local v1408 = t190.new()
	local n85 = 0

	while n85 < buffer.len(p126) do
		local v1410, v1411

		v1410, v1411, n85 = proto.readTag(p126, n85)

		if v1411 == proto.wireTypes.varint then
			local v1412

			v1412, n85 = proto.readVarInt(p126, n85)
		elseif v1411 == proto.wireTypes.lengthDelimited then
			if v1410 == 1 then
				local v1413

				v1413, n85 = proto.readBuffer(p126, n85)
				table.insert(v1408.options, t1.TypographyFontProp_ConditionalOption.decode(v1413))
			else
				local v1414, v1415 = proto.readVarInt(p126, n85)

				n85 = v1415 + v1414
			end
		elseif v1411 == proto.wireTypes.i32 then
			local v1416

			v1416, n85 = proto.readFixed32(p126, n85)
		elseif v1411 == proto.wireTypes.i64 then
			local v1417

			v1417, n85 = proto.readFixed64(p126, n85)
		else
			error("Unsupported wire type: " .. v1411)
		end
	end

	return v1408
end
function t190.jsonEncode(p127) -- line: 8610
	local t192 = {}

	if p127.options ~= nil and #p127.options > 0 then
		local t193 = {}

		for _, v1422 in p127.options do
			table.insert(t193, v1422:jsonEncode())
		end

		t192.options = t193
	end

	return t192
end
function t190.jsonDecode(t194: {[any]: any}) -- line: 8624
	-- upvalues: t190 (copy), t1 (copy)
	local v1424 = t190.new()

	if t194.options ~= nil then
		local t195 = {}

		for _, v1427 in t194.options do
			table.insert(t195, t1.TypographyFontProp_ConditionalOption.jsonDecode(v1427))
		end

		v1424.options = t195
	end

	return v1424
end

t190.descriptor = {
	name = "TypographyFontProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}
t1.TypographyFontProp_ConditionalOptions = t190
typeRegistry.default:register(t1.TypographyFontProp_ConditionalOptions)

local t196 = {}

t196.__index = t196

function t196.new(t197: {[any]: any}?) -- line: 8655
	-- upvalues: t196 (copy)
	return (setmetatable({
		kind = if t197 ~= nil and t197.kind ~= nil then t197.kind else nil
	}, t196))
end
function t196.encode(p128) -- line: 8661
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n86 = 0

	if p128.kind ~= nil then
		if p128.kind.type == "token" then
			local v1432, v1433 = proto.writeTag(buf, n86, 1, proto.wireTypes.lengthDelimited)

			buf, n86 = proto.writeString(v1432, v1433, p128.kind.value)
		elseif p128.kind.type == "conditional" then
			local v1434 = p128.kind.value:encode()
			local v1435, v1436 = proto.writeTag(buf, n86, 2, proto.wireTypes.lengthDelimited)

			buf, n86 = proto.writeBuffer(v1435, v1436, v1434, buffer.len(v1434))
		end
	end

	local buf45 = buffer.create(n86)

	buffer.copy(buf45, 0, buf, 0, n86)

	return buf45
end
function t196.decode(p129: buffer) -- line: 8681
	-- upvalues: t196 (copy), proto (copy), t1 (copy)
	local v1439 = t196.new()
	local n87 = 0

	while n87 < buffer.len(p129) do
		local v1441, v1442

		v1441, v1442, n87 = proto.readTag(p129, n87)

		if v1442 == proto.wireTypes.varint then
			local v1443

			v1443, n87 = proto.readVarInt(p129, n87)
		elseif v1442 == proto.wireTypes.lengthDelimited then
			if v1441 == 1 then
				local v1444

				v1444, n87 = proto.readBuffer(p129, n87)
				v1439.kind = {
					type = "token",
					value = buffer.tostring(v1444)
				}
			elseif v1441 == 2 then
				local v1445

				v1445, n87 = proto.readBuffer(p129, n87)
				v1439.kind = {
					type = "conditional",
					value = t1.ColorStyleProp_ConditionalOptions.decode(v1445)
				}
			else
				local v1446, v1447 = proto.readVarInt(p129, n87)

				n87 = v1447 + v1446
			end
		elseif v1442 == proto.wireTypes.i32 then
			local v1448

			v1448, n87 = proto.readFixed32(p129, n87)
		elseif v1442 == proto.wireTypes.i64 then
			local v1449

			v1449, n87 = proto.readFixed64(p129, n87)
		else
			error("Unsupported wire type: " .. v1442)
		end
	end

	return v1439
end
function t196.jsonEncode(p130) -- line: 8730
	local t198 = {}

	if p130.kind ~= nil then
		if p130.kind.type == "token" then
			t198.token = p130.kind.value

			return t198
		end

		if p130.kind.type == "conditional" then
			t198.conditional = p130.kind.value:jsonEncode()
		end
	end

	return t198
end
function t196.jsonDecode(t199: {[any]: any}) -- line: 8744
	-- upvalues: t196 (copy), t1 (copy)
	local v1453 = t196.new()

	if t199.token ~= nil then
		v1453.kind = {
			type = "token",
			value = t199.token
		}
	end

	if t199.conditional ~= nil then
		v1453.kind = {
			type = "conditional",
			value = t1.ColorStyleProp_ConditionalOptions.jsonDecode(t199.conditional)
		}
	end

	return v1453
end

t196.descriptor = {
	name = "ColorStyleProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.ColorStyleProp"
}
t1.ColorStyleProp = t196
typeRegistry.default:register(t1.ColorStyleProp)

local t200 = {}

t200.__index = t200

function t200.new(t201: {[any]: any}?) -- line: 8775
	-- upvalues: t200 (copy)
	return (setmetatable({
		condition = if t201 ~= nil and t201.condition ~= nil then t201.condition else nil,
		kind = if t201 ~= nil and t201.kind ~= nil then t201.kind else nil
	}, t200))
end
function t200.encode(p131) -- line: 8784
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n88 = 0

	if p131.condition ~= nil then
		local v1458 = p131.condition:encode()
		local v1459, v1460 = proto.writeTag(buf, n88, 1, proto.wireTypes.lengthDelimited)

		buf, n88 = proto.writeBuffer(v1459, v1460, v1458, buffer.len(v1458))
	end

	if p131.kind ~= nil and p131.kind.type == "token" then
		local v1461, v1462 = proto.writeTag(buf, n88, 2, proto.wireTypes.lengthDelimited)

		buf, n88 = proto.writeString(v1461, v1462, p131.kind.value)
	end

	local buf46 = buffer.create(n88)

	buffer.copy(buf46, 0, buf, 0, n88)

	return buf46
end
function t200.decode(p132: buffer) -- line: 8806
	-- upvalues: t200 (copy), proto (copy), prop_condition (copy)
	local v1465 = t200.new()
	local n89 = 0

	while n89 < buffer.len(p132) do
		local v1467, v1468

		v1467, v1468, n89 = proto.readTag(p132, n89)

		if v1468 == proto.wireTypes.varint then
			local v1469

			v1469, n89 = proto.readVarInt(p132, n89)
		elseif v1468 == proto.wireTypes.lengthDelimited then
			if v1467 == 1 then
				local v1470

				v1470, n89 = proto.readBuffer(p132, n89)
				v1465.condition = prop_condition.PropCondition.decode(v1470)
			elseif v1467 == 2 then
				local v1471

				v1471, n89 = proto.readBuffer(p132, n89)
				v1465.kind = {
					type = "token",
					value = buffer.tostring(v1471)
				}
			else
				local v1472, v1473 = proto.readVarInt(p132, n89)

				n89 = v1473 + v1472
			end
		elseif v1468 == proto.wireTypes.i32 then
			local v1474

			v1474, n89 = proto.readFixed32(p132, n89)
		elseif v1468 == proto.wireTypes.i64 then
			local v1475

			v1475, n89 = proto.readFixed64(p132, n89)
		else
			error("Unsupported wire type: " .. v1468)
		end
	end

	return v1465
end
function t200.jsonEncode(p133) -- line: 8854
	local t202 = {}

	if p133.condition ~= nil then
		t202.condition = p133.condition:jsonEncode()
	end

	if p133.kind ~= nil and p133.kind.type == "token" then
		t202.token = p133.kind.value
	end

	return t202
end
function t200.jsonDecode(t203: {[any]: any}) -- line: 8870
	-- upvalues: t200 (copy), prop_condition (copy)
	local v1479 = t200.new()

	if t203.condition ~= nil then
		v1479.condition = prop_condition.PropCondition.jsonDecode(t203.condition)
	end

	if t203.token ~= nil then
		v1479.kind = {
			type = "token",
			value = t203.token
		}
	end

	return v1479
end

t200.descriptor = {
	name = "ColorStyleProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}
t1.ColorStyleProp_ConditionalOption = t200
typeRegistry.default:register(t1.ColorStyleProp_ConditionalOption)

local t204 = {}

t204.__index = t204

function t204.new(t205: {[any]: any}?) -- line: 8901
	-- upvalues: t204 (copy)
	return (setmetatable({
		options = if t205 ~= nil and t205.options ~= nil then t205.options else {}
	}, t204))
end
function t204.encode(p134) -- line: 8909
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n90 = 0

	if p134.options ~= nil and #p134.options > 0 then
		for _, v1485 in p134.options do
			local v1486 = v1485:encode()
			local v1487, v1488 = proto.writeTag(buf, n90, 1, proto.wireTypes.lengthDelimited)

			buf, n90 = proto.writeBuffer(v1487, v1488, v1486, buffer.len(v1486))
		end
	end

	local buf47 = buffer.create(n90)

	buffer.copy(buf47, 0, buf, 0, n90)

	return buf47
end
function t204.decode(p135: buffer) -- line: 8926
	-- upvalues: t204 (copy), proto (copy), t1 (copy)
	local v1491 = t204.new()
	local n91 = 0

	while n91 < buffer.len(p135) do
		local v1493, v1494

		v1493, v1494, n91 = proto.readTag(p135, n91)

		if v1494 == proto.wireTypes.varint then
			local v1495

			v1495, n91 = proto.readVarInt(p135, n91)
		elseif v1494 == proto.wireTypes.lengthDelimited then
			if v1493 == 1 then
				local v1496

				v1496, n91 = proto.readBuffer(p135, n91)
				table.insert(v1491.options, t1.ColorStyleProp_ConditionalOption.decode(v1496))
			else
				local v1497, v1498 = proto.readVarInt(p135, n91)

				n91 = v1498 + v1497
			end
		elseif v1494 == proto.wireTypes.i32 then
			local v1499

			v1499, n91 = proto.readFixed32(p135, n91)
		elseif v1494 == proto.wireTypes.i64 then
			local v1500

			v1500, n91 = proto.readFixed64(p135, n91)
		else
			error("Unsupported wire type: " .. v1494)
		end
	end

	return v1491
end
function t204.jsonEncode(p136) -- line: 8969
	local t206 = {}

	if p136.options ~= nil and #p136.options > 0 then
		local t207 = {}

		for _, v1505 in p136.options do
			table.insert(t207, v1505:jsonEncode())
		end

		t206.options = t207
	end

	return t206
end
function t204.jsonDecode(t208: {[any]: any}) -- line: 8983
	-- upvalues: t204 (copy), t1 (copy)
	local v1507 = t204.new()

	if t208.options ~= nil then
		local t209 = {}

		for _, v1510 in t208.options do
			table.insert(t209, t1.ColorStyleProp_ConditionalOption.jsonDecode(v1510))
		end

		v1507.options = t209
	end

	return v1507
end

t204.descriptor = {
	name = "ColorStyleProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}
t1.ColorStyleProp_ConditionalOptions = t204
typeRegistry.default:register(t1.ColorStyleProp_ConditionalOptions)

local t210 = {}

t210.__index = t210

function t210.new(t211: {[any]: any}?) -- line: 9014
	-- upvalues: t210 (copy)
	return (setmetatable({
		kind = if t211 ~= nil and t211.kind ~= nil then t211.kind else nil
	}, t210))
end
function t210.encode(p137) -- line: 9020
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n92 = 0

	if p137.kind ~= nil then
		if p137.kind.type == "literal" then
			local v1515, v1516 = proto.writeTag(buf, n92, 1, proto.wireTypes.lengthDelimited)

			buf, n92 = proto.writeString(v1515, v1516, p137.kind.value)
		elseif p137.kind.type == "conditional" then
			local v1517 = p137.kind.value:encode()
			local v1518, v1519 = proto.writeTag(buf, n92, 2, proto.wireTypes.lengthDelimited)

			buf, n92 = proto.writeBuffer(v1518, v1519, v1517, buffer.len(v1517))
		elseif p137.kind.type == "binding_path" then
			local v1520, v1521 = proto.writeTag(buf, n92, 3, proto.wireTypes.lengthDelimited)

			buf, n92 = proto.writeString(v1520, v1521, p137.kind.value)
		end
	end

	local buf48 = buffer.create(n92)

	buffer.copy(buf48, 0, buf, 0, n92)

	return buf48
end
function t210.decode(p138: buffer) -- line: 9043
	-- upvalues: t210 (copy), proto (copy), t1 (copy)
	local v1524 = t210.new()
	local n93 = 0

	while n93 < buffer.len(p138) do
		local v1526, v1527

		v1526, v1527, n93 = proto.readTag(p138, n93)

		if v1527 == proto.wireTypes.varint then
			local v1528

			v1528, n93 = proto.readVarInt(p138, n93)
		elseif v1527 == proto.wireTypes.lengthDelimited then
			if v1526 == 1 then
				local v1529

				v1529, n93 = proto.readBuffer(p138, n93)
				v1524.kind = {
					type = "literal",
					value = buffer.tostring(v1529)
				}
			elseif v1526 == 2 then
				local v1530

				v1530, n93 = proto.readBuffer(p138, n93)
				v1524.kind = {
					type = "conditional",
					value = t1.FillBehaviorProp_ConditionalOptions.decode(v1530)
				}
			elseif v1526 == 3 then
				local v1531

				v1531, n93 = proto.readBuffer(p138, n93)
				v1524.kind = {
					type = "binding_path",
					value = buffer.tostring(v1531)
				}
			else
				local v1532, v1533 = proto.readVarInt(p138, n93)

				n93 = v1533 + v1532
			end
		elseif v1527 == proto.wireTypes.i32 then
			local v1534

			v1534, n93 = proto.readFixed32(p138, n93)
		elseif v1527 == proto.wireTypes.i64 then
			local v1535

			v1535, n93 = proto.readFixed64(p138, n93)
		else
			error("Unsupported wire type: " .. v1527)
		end
	end

	return v1524
end
function t210.jsonEncode(p139) -- line: 9097
	local t212 = {}

	if p139.kind ~= nil then
		if p139.kind.type == "literal" then
			t212.literal = p139.kind.value

			return t212
		end

		if p139.kind.type == "conditional" then
			t212.conditional = p139.kind.value:jsonEncode()

			return t212
		end

		if p139.kind.type == "binding_path" then
			t212.bindingPath = p139.kind.value
		end
	end

	return t212
end
function t210.jsonDecode(t213: {[any]: any}) -- line: 9113
	-- upvalues: t210 (copy), t1 (copy)
	local v1539 = t210.new()

	if t213.literal ~= nil then
		v1539.kind = {
			type = "literal",
			value = t213.literal
		}
	end

	if t213.conditional ~= nil then
		v1539.kind = {
			type = "conditional",
			value = t1.FillBehaviorProp_ConditionalOptions.jsonDecode(t213.conditional)
		}
	end

	if t213.binding_path ~= nil then
		v1539.kind = {
			type = "binding_path",
			value = t213.binding_path
		}
	end

	if t213.bindingPath ~= nil then
		v1539.kind = {
			type = "binding_path",
			value = t213.bindingPath
		}
	end

	return v1539
end

t210.descriptor = {
	name = "FillBehaviorProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.FillBehaviorProp"
}
t1.FillBehaviorProp = t210
typeRegistry.default:register(t1.FillBehaviorProp)

local t214 = {}

t214.__index = t214

function t214.new(t215: {[any]: any}?) -- line: 9152
	-- upvalues: t214 (copy)
	return (setmetatable({
		condition = if t215 ~= nil and t215.condition ~= nil then t215.condition else nil,
		kind = if t215 ~= nil and t215.kind ~= nil then t215.kind else nil
	}, t214))
end
function t214.encode(p140) -- line: 9161
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n94 = 0

	if p140.condition ~= nil then
		local v1544 = p140.condition:encode()
		local v1545, v1546 = proto.writeTag(buf, n94, 1, proto.wireTypes.lengthDelimited)

		buf, n94 = proto.writeBuffer(v1545, v1546, v1544, buffer.len(v1544))
	end

	if p140.kind ~= nil then
		if p140.kind.type == "literal" then
			local v1547, v1548 = proto.writeTag(buf, n94, 2, proto.wireTypes.lengthDelimited)

			buf, n94 = proto.writeString(v1547, v1548, p140.kind.value)
		elseif p140.kind.type == "binding_path" then
			local v1549, v1550 = proto.writeTag(buf, n94, 3, proto.wireTypes.lengthDelimited)

			buf, n94 = proto.writeString(v1549, v1550, p140.kind.value)
		end
	end

	local buf49 = buffer.create(n94)

	buffer.copy(buf49, 0, buf, 0, n94)

	return buf49
end
function t214.decode(p141: buffer) -- line: 9186
	-- upvalues: t214 (copy), proto (copy), prop_condition (copy)
	local v1553 = t214.new()
	local n95 = 0

	while n95 < buffer.len(p141) do
		local v1555, v1556

		v1555, v1556, n95 = proto.readTag(p141, n95)

		if v1556 == proto.wireTypes.varint then
			local v1557

			v1557, n95 = proto.readVarInt(p141, n95)
		elseif v1556 == proto.wireTypes.lengthDelimited then
			if v1555 == 1 then
				local v1558

				v1558, n95 = proto.readBuffer(p141, n95)
				v1553.condition = prop_condition.PropCondition.decode(v1558)
			elseif v1555 == 2 then
				local v1559

				v1559, n95 = proto.readBuffer(p141, n95)
				v1553.kind = {
					type = "literal",
					value = buffer.tostring(v1559)
				}
			elseif v1555 == 3 then
				local v1560

				v1560, n95 = proto.readBuffer(p141, n95)
				v1553.kind = {
					type = "binding_path",
					value = buffer.tostring(v1560)
				}
			else
				local v1561, v1562 = proto.readVarInt(p141, n95)

				n95 = v1562 + v1561
			end
		elseif v1556 == proto.wireTypes.i32 then
			local v1563

			v1563, n95 = proto.readFixed32(p141, n95)
		elseif v1556 == proto.wireTypes.i64 then
			local v1564

			v1564, n95 = proto.readFixed64(p141, n95)
		else
			error("Unsupported wire type: " .. v1556)
		end
	end

	return v1553
end
function t214.jsonEncode(p142) -- line: 9239
	local t216 = {}

	if p142.condition ~= nil then
		t216.condition = p142.condition:jsonEncode()
	end

	if p142.kind ~= nil then
		if p142.kind.type == "literal" then
			t216.literal = p142.kind.value

			return t216
		end

		if p142.kind.type == "binding_path" then
			t216.bindingPath = p142.kind.value
		end
	end

	return t216
end
function t214.jsonDecode(t217: {[any]: any}) -- line: 9257
	-- upvalues: t214 (copy), prop_condition (copy)
	local v1568 = t214.new()

	if t217.condition ~= nil then
		v1568.condition = prop_condition.PropCondition.jsonDecode(t217.condition)
	end

	if t217.literal ~= nil then
		v1568.kind = {
			type = "literal",
			value = t217.literal
		}
	end

	if t217.binding_path ~= nil then
		v1568.kind = {
			type = "binding_path",
			value = t217.binding_path
		}
	end

	if t217.bindingPath ~= nil then
		v1568.kind = {
			type = "binding_path",
			value = t217.bindingPath
		}
	end

	return v1568
end

t214.descriptor = {
	name = "FillBehaviorProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}
t1.FillBehaviorProp_ConditionalOption = t214
typeRegistry.default:register(t1.FillBehaviorProp_ConditionalOption)

local t218 = {}

t218.__index = t218

function t218.new(t219: {[any]: any}?) -- line: 9296
	-- upvalues: t218 (copy)
	return (setmetatable({
		options = if t219 ~= nil and t219.options ~= nil then t219.options else {}
	}, t218))
end
function t218.encode(p143) -- line: 9304
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n96 = 0

	if p143.options ~= nil and #p143.options > 0 then
		for _, v1574 in p143.options do
			local v1575 = v1574:encode()
			local v1576, v1577 = proto.writeTag(buf, n96, 1, proto.wireTypes.lengthDelimited)

			buf, n96 = proto.writeBuffer(v1576, v1577, v1575, buffer.len(v1575))
		end
	end

	local buf50 = buffer.create(n96)

	buffer.copy(buf50, 0, buf, 0, n96)

	return buf50
end
function t218.decode(p144: buffer) -- line: 9321
	-- upvalues: t218 (copy), proto (copy), t1 (copy)
	local v1580 = t218.new()
	local n97 = 0

	while n97 < buffer.len(p144) do
		local v1582, v1583

		v1582, v1583, n97 = proto.readTag(p144, n97)

		if v1583 == proto.wireTypes.varint then
			local v1584

			v1584, n97 = proto.readVarInt(p144, n97)
		elseif v1583 == proto.wireTypes.lengthDelimited then
			if v1582 == 1 then
				local v1585

				v1585, n97 = proto.readBuffer(p144, n97)
				table.insert(v1580.options, t1.FillBehaviorProp_ConditionalOption.decode(v1585))
			else
				local v1586, v1587 = proto.readVarInt(p144, n97)

				n97 = v1587 + v1586
			end
		elseif v1583 == proto.wireTypes.i32 then
			local v1588

			v1588, n97 = proto.readFixed32(p144, n97)
		elseif v1583 == proto.wireTypes.i64 then
			local v1589

			v1589, n97 = proto.readFixed64(p144, n97)
		else
			error("Unsupported wire type: " .. v1583)
		end
	end

	return v1580
end
function t218.jsonEncode(p145) -- line: 9364
	local t220 = {}

	if p145.options ~= nil and #p145.options > 0 then
		local t221 = {}

		for _, v1594 in p145.options do
			table.insert(t221, v1594:jsonEncode())
		end

		t220.options = t221
	end

	return t220
end
function t218.jsonDecode(t222: {[any]: any}) -- line: 9378
	-- upvalues: t218 (copy), t1 (copy)
	local v1596 = t218.new()

	if t222.options ~= nil then
		local t223 = {}

		for _, v1599 in t222.options do
			table.insert(t223, t1.FillBehaviorProp_ConditionalOption.jsonDecode(v1599))
		end

		v1596.options = t223
	end

	return v1596
end

t218.descriptor = {
	name = "FillBehaviorProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}
t1.FillBehaviorProp_ConditionalOptions = t218
typeRegistry.default:register(t1.FillBehaviorProp_ConditionalOptions)

local t224 = {}

t224.__index = t224

function t224.new(t225: {[any]: any}?) -- line: 9409
	-- upvalues: t224 (copy)
	return (setmetatable({
		kind = if t225 ~= nil and t225.kind ~= nil then t225.kind else nil
	}, t224))
end
function t224.encode(p146) -- line: 9415
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n98 = 0

	if p146.kind ~= nil then
		if p146.kind.type == "literal" then
			local v1604, v1605 = proto.writeTag(buf, n98, 1, proto.wireTypes.lengthDelimited)

			buf, n98 = proto.writeString(v1604, v1605, p146.kind.value)
		elseif p146.kind.type == "conditional" then
			local v1606 = p146.kind.value:encode()
			local v1607, v1608 = proto.writeTag(buf, n98, 2, proto.wireTypes.lengthDelimited)

			buf, n98 = proto.writeBuffer(v1607, v1608, v1606, buffer.len(v1606))
		elseif p146.kind.type == "binding_path" then
			local v1609, v1610 = proto.writeTag(buf, n98, 3, proto.wireTypes.lengthDelimited)

			buf, n98 = proto.writeString(v1609, v1610, p146.kind.value)
		end
	end

	local buf51 = buffer.create(n98)

	buffer.copy(buf51, 0, buf, 0, n98)

	return buf51
end
function t224.decode(p147: buffer) -- line: 9438
	-- upvalues: t224 (copy), proto (copy), t1 (copy)
	local v1613 = t224.new()
	local n99 = 0

	while n99 < buffer.len(p147) do
		local v1615, v1616

		v1615, v1616, n99 = proto.readTag(p147, n99)

		if v1616 == proto.wireTypes.varint then
			local v1617

			v1617, n99 = proto.readVarInt(p147, n99)
		elseif v1616 == proto.wireTypes.lengthDelimited then
			if v1615 == 1 then
				local v1618

				v1618, n99 = proto.readBuffer(p147, n99)
				v1613.kind = {
					type = "literal",
					value = buffer.tostring(v1618)
				}
			elseif v1615 == 2 then
				local v1619

				v1619, n99 = proto.readBuffer(p147, n99)
				v1613.kind = {
					type = "conditional",
					value = t1.InputSizeProp_ConditionalOptions.decode(v1619)
				}
			elseif v1615 == 3 then
				local v1620

				v1620, n99 = proto.readBuffer(p147, n99)
				v1613.kind = {
					type = "binding_path",
					value = buffer.tostring(v1620)
				}
			else
				local v1621, v1622 = proto.readVarInt(p147, n99)

				n99 = v1622 + v1621
			end
		elseif v1616 == proto.wireTypes.i32 then
			local v1623

			v1623, n99 = proto.readFixed32(p147, n99)
		elseif v1616 == proto.wireTypes.i64 then
			local v1624

			v1624, n99 = proto.readFixed64(p147, n99)
		else
			error("Unsupported wire type: " .. v1616)
		end
	end

	return v1613
end
function t224.jsonEncode(p148) -- line: 9492
	local t226 = {}

	if p148.kind ~= nil then
		if p148.kind.type == "literal" then
			t226.literal = p148.kind.value

			return t226
		end

		if p148.kind.type == "conditional" then
			t226.conditional = p148.kind.value:jsonEncode()

			return t226
		end

		if p148.kind.type == "binding_path" then
			t226.bindingPath = p148.kind.value
		end
	end

	return t226
end
function t224.jsonDecode(t227: {[any]: any}) -- line: 9508
	-- upvalues: t224 (copy), t1 (copy)
	local v1628 = t224.new()

	if t227.literal ~= nil then
		v1628.kind = {
			type = "literal",
			value = t227.literal
		}
	end

	if t227.conditional ~= nil then
		v1628.kind = {
			type = "conditional",
			value = t1.InputSizeProp_ConditionalOptions.jsonDecode(t227.conditional)
		}
	end

	if t227.binding_path ~= nil then
		v1628.kind = {
			type = "binding_path",
			value = t227.binding_path
		}
	end

	if t227.bindingPath ~= nil then
		v1628.kind = {
			type = "binding_path",
			value = t227.bindingPath
		}
	end

	return v1628
end

t224.descriptor = {
	name = "InputSizeProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.InputSizeProp"
}
t1.InputSizeProp = t224
typeRegistry.default:register(t1.InputSizeProp)

local t228 = {}

t228.__index = t228

function t228.new(t229: {[any]: any}?) -- line: 9547
	-- upvalues: t228 (copy)
	return (setmetatable({
		condition = if t229 ~= nil and t229.condition ~= nil then t229.condition else nil,
		kind = if t229 ~= nil and t229.kind ~= nil then t229.kind else nil
	}, t228))
end
function t228.encode(p149) -- line: 9556
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n100 = 0

	if p149.condition ~= nil then
		local v1633 = p149.condition:encode()
		local v1634, v1635 = proto.writeTag(buf, n100, 1, proto.wireTypes.lengthDelimited)

		buf, n100 = proto.writeBuffer(v1634, v1635, v1633, buffer.len(v1633))
	end

	if p149.kind ~= nil then
		if p149.kind.type == "literal" then
			local v1636, v1637 = proto.writeTag(buf, n100, 2, proto.wireTypes.lengthDelimited)

			buf, n100 = proto.writeString(v1636, v1637, p149.kind.value)
		elseif p149.kind.type == "binding_path" then
			local v1638, v1639 = proto.writeTag(buf, n100, 3, proto.wireTypes.lengthDelimited)

			buf, n100 = proto.writeString(v1638, v1639, p149.kind.value)
		end
	end

	local buf52 = buffer.create(n100)

	buffer.copy(buf52, 0, buf, 0, n100)

	return buf52
end
function t228.decode(p150: buffer) -- line: 9581
	-- upvalues: t228 (copy), proto (copy), prop_condition (copy)
	local v1642 = t228.new()
	local n101 = 0

	while n101 < buffer.len(p150) do
		local v1644, v1645

		v1644, v1645, n101 = proto.readTag(p150, n101)

		if v1645 == proto.wireTypes.varint then
			local v1646

			v1646, n101 = proto.readVarInt(p150, n101)
		elseif v1645 == proto.wireTypes.lengthDelimited then
			if v1644 == 1 then
				local v1647

				v1647, n101 = proto.readBuffer(p150, n101)
				v1642.condition = prop_condition.PropCondition.decode(v1647)
			elseif v1644 == 2 then
				local v1648

				v1648, n101 = proto.readBuffer(p150, n101)
				v1642.kind = {
					type = "literal",
					value = buffer.tostring(v1648)
				}
			elseif v1644 == 3 then
				local v1649

				v1649, n101 = proto.readBuffer(p150, n101)
				v1642.kind = {
					type = "binding_path",
					value = buffer.tostring(v1649)
				}
			else
				local v1650, v1651 = proto.readVarInt(p150, n101)

				n101 = v1651 + v1650
			end
		elseif v1645 == proto.wireTypes.i32 then
			local v1652

			v1652, n101 = proto.readFixed32(p150, n101)
		elseif v1645 == proto.wireTypes.i64 then
			local v1653

			v1653, n101 = proto.readFixed64(p150, n101)
		else
			error("Unsupported wire type: " .. v1645)
		end
	end

	return v1642
end
function t228.jsonEncode(p151) -- line: 9634
	local t230 = {}

	if p151.condition ~= nil then
		t230.condition = p151.condition:jsonEncode()
	end

	if p151.kind ~= nil then
		if p151.kind.type == "literal" then
			t230.literal = p151.kind.value

			return t230
		end

		if p151.kind.type == "binding_path" then
			t230.bindingPath = p151.kind.value
		end
	end

	return t230
end
function t228.jsonDecode(t231: {[any]: any}) -- line: 9652
	-- upvalues: t228 (copy), prop_condition (copy)
	local v1657 = t228.new()

	if t231.condition ~= nil then
		v1657.condition = prop_condition.PropCondition.jsonDecode(t231.condition)
	end

	if t231.literal ~= nil then
		v1657.kind = {
			type = "literal",
			value = t231.literal
		}
	end

	if t231.binding_path ~= nil then
		v1657.kind = {
			type = "binding_path",
			value = t231.binding_path
		}
	end

	if t231.bindingPath ~= nil then
		v1657.kind = {
			type = "binding_path",
			value = t231.bindingPath
		}
	end

	return v1657
end

t228.descriptor = {
	name = "InputSizeProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}
t1.InputSizeProp_ConditionalOption = t228
typeRegistry.default:register(t1.InputSizeProp_ConditionalOption)

local t232 = {}

t232.__index = t232

function t232.new(t233: {[any]: any}?) -- line: 9689
	-- upvalues: t232 (copy)
	return (setmetatable({
		options = if t233 ~= nil and t233.options ~= nil then t233.options else {}
	}, t232))
end
function t232.encode(p152) -- line: 9697
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n102 = 0

	if p152.options ~= nil and #p152.options > 0 then
		for _, v1663 in p152.options do
			local v1664 = v1663:encode()
			local v1665, v1666 = proto.writeTag(buf, n102, 1, proto.wireTypes.lengthDelimited)

			buf, n102 = proto.writeBuffer(v1665, v1666, v1664, buffer.len(v1664))
		end
	end

	local buf53 = buffer.create(n102)

	buffer.copy(buf53, 0, buf, 0, n102)

	return buf53
end
function t232.decode(p153: buffer) -- line: 9714
	-- upvalues: t232 (copy), proto (copy), t1 (copy)
	local v1669 = t232.new()
	local n103 = 0

	while n103 < buffer.len(p153) do
		local v1671, v1672

		v1671, v1672, n103 = proto.readTag(p153, n103)

		if v1672 == proto.wireTypes.varint then
			local v1673

			v1673, n103 = proto.readVarInt(p153, n103)
		elseif v1672 == proto.wireTypes.lengthDelimited then
			if v1671 == 1 then
				local v1674

				v1674, n103 = proto.readBuffer(p153, n103)
				table.insert(v1669.options, t1.InputSizeProp_ConditionalOption.decode(v1674))
			else
				local v1675, v1676 = proto.readVarInt(p153, n103)

				n103 = v1676 + v1675
			end
		elseif v1672 == proto.wireTypes.i32 then
			local v1677

			v1677, n103 = proto.readFixed32(p153, n103)
		elseif v1672 == proto.wireTypes.i64 then
			local v1678

			v1678, n103 = proto.readFixed64(p153, n103)
		else
			error("Unsupported wire type: " .. v1672)
		end
	end

	return v1669
end
function t232.jsonEncode(p154) -- line: 9757
	local t234 = {}

	if p154.options ~= nil and #p154.options > 0 then
		local t235 = {}

		for _, v1683 in p154.options do
			table.insert(t235, v1683:jsonEncode())
		end

		t234.options = t235
	end

	return t234
end
function t232.jsonDecode(t236: {[any]: any}) -- line: 9771
	-- upvalues: t232 (copy), t1 (copy)
	local v1685 = t232.new()

	if t236.options ~= nil then
		local t237 = {}

		for _, v1688 in t236.options do
			table.insert(t237, t1.InputSizeProp_ConditionalOption.jsonDecode(v1688))
		end

		v1685.options = t237
	end

	return v1685
end

t232.descriptor = {
	name = "InputSizeProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}
t1.InputSizeProp_ConditionalOptions = t232
typeRegistry.default:register(t1.InputSizeProp_ConditionalOptions)

local t238 = {}

t238.__index = t238

function t238.new(t239: {[any]: any}?) -- line: 9802
	-- upvalues: t238 (copy)
	return (setmetatable({
		kind = if t239 ~= nil and t239.kind ~= nil then t239.kind else nil
	}, t238))
end
function t238.encode(p155) -- line: 9808
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n104 = 0

	if p155.kind ~= nil then
		if p155.kind.type == "literal" then
			local v1693, v1694 = proto.writeTag(buf, n104, 1, proto.wireTypes.lengthDelimited)

			buf, n104 = proto.writeString(v1693, v1694, p155.kind.value)
		elseif p155.kind.type == "token" then
			local v1695, v1696 = proto.writeTag(buf, n104, 2, proto.wireTypes.lengthDelimited)

			buf, n104 = proto.writeString(v1695, v1696, p155.kind.value)
		elseif p155.kind.type == "conditional" then
			local v1697 = p155.kind.value:encode()
			local v1698, v1699 = proto.writeTag(buf, n104, 3, proto.wireTypes.lengthDelimited)

			buf, n104 = proto.writeBuffer(v1698, v1699, v1697, buffer.len(v1697))
		elseif p155.kind.type == "binding_path" then
			local v1700, v1701 = proto.writeTag(buf, n104, 4, proto.wireTypes.lengthDelimited)

			buf, n104 = proto.writeString(v1700, v1701, p155.kind.value)
		end
	end

	local buf54 = buffer.create(n104)

	buffer.copy(buf54, 0, buf, 0, n104)

	return buf54
end
function t238.decode(p156: buffer) -- line: 9834
	-- upvalues: t238 (copy), proto (copy), t1 (copy)
	local v1704 = t238.new()
	local n105 = 0

	while n105 < buffer.len(p156) do
		local v1706, v1707

		v1706, v1707, n105 = proto.readTag(p156, n105)

		if v1707 == proto.wireTypes.varint then
			local v1708

			v1708, n105 = proto.readVarInt(p156, n105)
		elseif v1707 == proto.wireTypes.lengthDelimited then
			if v1706 == 1 then
				local v1709

				v1709, n105 = proto.readBuffer(p156, n105)
				v1704.kind = {
					type = "literal",
					value = buffer.tostring(v1709)
				}
			elseif v1706 == 2 then
				local v1710

				v1710, n105 = proto.readBuffer(p156, n105)
				v1704.kind = {
					type = "token",
					value = buffer.tostring(v1710)
				}
			elseif v1706 == 3 then
				local v1711

				v1711, n105 = proto.readBuffer(p156, n105)
				v1704.kind = {
					type = "conditional",
					value = t1.UDimProp_ConditionalOptions.decode(v1711)
				}
			elseif v1706 == 4 then
				local v1712

				v1712, n105 = proto.readBuffer(p156, n105)
				v1704.kind = {
					type = "binding_path",
					value = buffer.tostring(v1712)
				}
			else
				local v1713, v1714 = proto.readVarInt(p156, n105)

				n105 = v1714 + v1713
			end
		elseif v1707 == proto.wireTypes.i32 then
			local v1715

			v1715, n105 = proto.readFixed32(p156, n105)
		elseif v1707 == proto.wireTypes.i64 then
			local v1716

			v1716, n105 = proto.readFixed64(p156, n105)
		else
			error("Unsupported wire type: " .. v1707)
		end
	end

	return v1704
end
function t238.jsonEncode(p157) -- line: 9892
	local t240 = {}

	if p157.kind ~= nil then
		if p157.kind.type == "literal" then
			t240.literal = p157.kind.value

			return t240
		end

		if p157.kind.type == "token" then
			t240.token = p157.kind.value

			return t240
		end

		if p157.kind.type == "conditional" then
			t240.conditional = p157.kind.value:jsonEncode()

			return t240
		end

		if p157.kind.type == "binding_path" then
			t240.bindingPath = p157.kind.value
		end
	end

	return t240
end
function t238.jsonDecode(t241: {[any]: any}) -- line: 9910
	-- upvalues: t238 (copy), t1 (copy)
	local v1720 = t238.new()

	if t241.literal ~= nil then
		v1720.kind = {
			type = "literal",
			value = t241.literal
		}
	end

	if t241.token ~= nil then
		v1720.kind = {
			type = "token",
			value = t241.token
		}
	end

	if t241.conditional ~= nil then
		v1720.kind = {
			type = "conditional",
			value = t1.UDimProp_ConditionalOptions.jsonDecode(t241.conditional)
		}
	end

	if t241.binding_path ~= nil then
		v1720.kind = {
			type = "binding_path",
			value = t241.binding_path
		}
	end

	if t241.bindingPath ~= nil then
		v1720.kind = {
			type = "binding_path",
			value = t241.bindingPath
		}
	end

	return v1720
end

t238.descriptor = {
	name = "UDimProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.UDimProp"
}
t1.UDimProp = t238
typeRegistry.default:register(t1.UDimProp)

local t242 = {}

t242.__index = t242

function t242.new(t243: {[any]: any}?) -- line: 9951
	-- upvalues: t242 (copy)
	return (setmetatable({
		condition = if t243 ~= nil and t243.condition ~= nil then t243.condition else nil,
		kind = if t243 ~= nil and t243.kind ~= nil then t243.kind else nil
	}, t242))
end
function t242.encode(p158) -- line: 9960
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n106 = 0

	if p158.condition ~= nil then
		local v1725 = p158.condition:encode()
		local v1726, v1727 = proto.writeTag(buf, n106, 1, proto.wireTypes.lengthDelimited)

		buf, n106 = proto.writeBuffer(v1726, v1727, v1725, buffer.len(v1725))
	end

	if p158.kind ~= nil then
		if p158.kind.type == "literal" then
			local v1728, v1729 = proto.writeTag(buf, n106, 2, proto.wireTypes.lengthDelimited)

			buf, n106 = proto.writeString(v1728, v1729, p158.kind.value)
		elseif p158.kind.type == "token" then
			local v1730, v1731 = proto.writeTag(buf, n106, 3, proto.wireTypes.lengthDelimited)

			buf, n106 = proto.writeString(v1730, v1731, p158.kind.value)
		elseif p158.kind.type == "binding_path" then
			local v1732, v1733 = proto.writeTag(buf, n106, 4, proto.wireTypes.lengthDelimited)

			buf, n106 = proto.writeString(v1732, v1733, p158.kind.value)
		end
	end

	local buf55 = buffer.create(n106)

	buffer.copy(buf55, 0, buf, 0, n106)

	return buf55
end
function t242.decode(p159: buffer) -- line: 9988
	-- upvalues: t242 (copy), proto (copy), prop_condition (copy)
	local v1736 = t242.new()
	local n107 = 0

	while n107 < buffer.len(p159) do
		local v1738, v1739

		v1738, v1739, n107 = proto.readTag(p159, n107)

		if v1739 == proto.wireTypes.varint then
			local v1740

			v1740, n107 = proto.readVarInt(p159, n107)
		elseif v1739 == proto.wireTypes.lengthDelimited then
			if v1738 == 1 then
				local v1741

				v1741, n107 = proto.readBuffer(p159, n107)
				v1736.condition = prop_condition.PropCondition.decode(v1741)
			elseif v1738 == 2 then
				local v1742

				v1742, n107 = proto.readBuffer(p159, n107)
				v1736.kind = {
					type = "literal",
					value = buffer.tostring(v1742)
				}
			elseif v1738 == 3 then
				local v1743

				v1743, n107 = proto.readBuffer(p159, n107)
				v1736.kind = {
					type = "token",
					value = buffer.tostring(v1743)
				}
			elseif v1738 == 4 then
				local v1744

				v1744, n107 = proto.readBuffer(p159, n107)
				v1736.kind = {
					type = "binding_path",
					value = buffer.tostring(v1744)
				}
			else
				local v1745, v1746 = proto.readVarInt(p159, n107)

				n107 = v1746 + v1745
			end
		elseif v1739 == proto.wireTypes.i32 then
			local v1747

			v1747, n107 = proto.readFixed32(p159, n107)
		elseif v1739 == proto.wireTypes.i64 then
			local v1748

			v1748, n107 = proto.readFixed64(p159, n107)
		else
			error("Unsupported wire type: " .. v1739)
		end
	end

	return v1736
end
function t242.jsonEncode(p160) -- line: 10046
	local t244 = {}

	if p160.condition ~= nil then
		t244.condition = p160.condition:jsonEncode()
	end

	if p160.kind ~= nil then
		if p160.kind.type == "literal" then
			t244.literal = p160.kind.value

			return t244
		end

		if p160.kind.type == "token" then
			t244.token = p160.kind.value

			return t244
		end

		if p160.kind.type == "binding_path" then
			t244.bindingPath = p160.kind.value
		end
	end

	return t244
end
function t242.jsonDecode(t245: {[any]: any}) -- line: 10066
	-- upvalues: t242 (copy), prop_condition (copy)
	local v1752 = t242.new()

	if t245.condition ~= nil then
		v1752.condition = prop_condition.PropCondition.jsonDecode(t245.condition)
	end

	if t245.literal ~= nil then
		v1752.kind = {
			type = "literal",
			value = t245.literal
		}
	end

	if t245.token ~= nil then
		v1752.kind = {
			type = "token",
			value = t245.token
		}
	end

	if t245.binding_path ~= nil then
		v1752.kind = {
			type = "binding_path",
			value = t245.binding_path
		}
	end

	if t245.bindingPath ~= nil then
		v1752.kind = {
			type = "binding_path",
			value = t245.bindingPath
		}
	end

	return v1752
end

t242.descriptor = {
	name = "UDimProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}
t1.UDimProp_ConditionalOption = t242
typeRegistry.default:register(t1.UDimProp_ConditionalOption)

local t246 = {}

t246.__index = t246

function t246.new(t247: {[any]: any}?) -- line: 10107
	-- upvalues: t246 (copy)
	return (setmetatable({
		options = if t247 ~= nil and t247.options ~= nil then t247.options else {}
	}, t246))
end
function t246.encode(p161) -- line: 10115
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n108 = 0

	if p161.options ~= nil and #p161.options > 0 then
		for _, v1758 in p161.options do
			local v1759 = v1758:encode()
			local v1760, v1761 = proto.writeTag(buf, n108, 1, proto.wireTypes.lengthDelimited)

			buf, n108 = proto.writeBuffer(v1760, v1761, v1759, buffer.len(v1759))
		end
	end

	local buf56 = buffer.create(n108)

	buffer.copy(buf56, 0, buf, 0, n108)

	return buf56
end
function t246.decode(p162: buffer) -- line: 10132
	-- upvalues: t246 (copy), proto (copy), t1 (copy)
	local v1764 = t246.new()
	local n109 = 0

	while n109 < buffer.len(p162) do
		local v1766, v1767

		v1766, v1767, n109 = proto.readTag(p162, n109)

		if v1767 == proto.wireTypes.varint then
			local v1768

			v1768, n109 = proto.readVarInt(p162, n109)
		elseif v1767 == proto.wireTypes.lengthDelimited then
			if v1766 == 1 then
				local v1769

				v1769, n109 = proto.readBuffer(p162, n109)
				table.insert(v1764.options, t1.UDimProp_ConditionalOption.decode(v1769))
			else
				local v1770, v1771 = proto.readVarInt(p162, n109)

				n109 = v1771 + v1770
			end
		elseif v1767 == proto.wireTypes.i32 then
			local v1772

			v1772, n109 = proto.readFixed32(p162, n109)
		elseif v1767 == proto.wireTypes.i64 then
			local v1773

			v1773, n109 = proto.readFixed64(p162, n109)
		else
			error("Unsupported wire type: " .. v1767)
		end
	end

	return v1764
end
function t246.jsonEncode(p163) -- line: 10175
	local t248 = {}

	if p163.options ~= nil and #p163.options > 0 then
		local t249 = {}

		for _, v1778 in p163.options do
			table.insert(t249, v1778:jsonEncode())
		end

		t248.options = t249
	end

	return t248
end
function t246.jsonDecode(t250: {[any]: any}) -- line: 10189
	-- upvalues: t246 (copy), t1 (copy)
	local v1780 = t246.new()

	if t250.options ~= nil then
		local t251 = {}

		for _, v1783 in t250.options do
			table.insert(t251, t1.UDimProp_ConditionalOption.jsonDecode(v1783))
		end

		v1780.options = t251
	end

	return v1780
end

t246.descriptor = {
	name = "UDimProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}
t1.UDimProp_ConditionalOptions = t246
typeRegistry.default:register(t1.UDimProp_ConditionalOptions)

local t252 = {}

t252.__index = t252

function t252.new(t253: {[any]: any}?) -- line: 10218
	-- upvalues: t252 (copy)
	return (setmetatable({
		kind = if t253 ~= nil and t253.kind ~= nil then t253.kind else nil
	}, t252))
end
function t252.encode(p164) -- line: 10224
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n110 = 0

	if p164.kind ~= nil then
		if p164.kind.type == "literal" then
			local v1788, v1789 = proto.writeTag(buf, n110, 1, proto.wireTypes.lengthDelimited)

			buf, n110 = proto.writeString(v1788, v1789, p164.kind.value)
		elseif p164.kind.type == "token" then
			local v1790, v1791 = proto.writeTag(buf, n110, 2, proto.wireTypes.lengthDelimited)

			buf, n110 = proto.writeString(v1790, v1791, p164.kind.value)
		elseif p164.kind.type == "conditional" then
			local v1792 = p164.kind.value:encode()
			local v1793, v1794 = proto.writeTag(buf, n110, 3, proto.wireTypes.lengthDelimited)

			buf, n110 = proto.writeBuffer(v1793, v1794, v1792, buffer.len(v1792))
		elseif p164.kind.type == "binding_path" then
			local v1795, v1796 = proto.writeTag(buf, n110, 4, proto.wireTypes.lengthDelimited)

			buf, n110 = proto.writeString(v1795, v1796, p164.kind.value)
		end
	end

	local buf57 = buffer.create(n110)

	buffer.copy(buf57, 0, buf, 0, n110)

	return buf57
end
function t252.decode(p165: buffer) -- line: 10250
	-- upvalues: t252 (copy), proto (copy), t1 (copy)
	local v1799 = t252.new()
	local n111 = 0

	while n111 < buffer.len(p165) do
		local v1801, v1802

		v1801, v1802, n111 = proto.readTag(p165, n111)

		if v1802 == proto.wireTypes.varint then
			local v1803

			v1803, n111 = proto.readVarInt(p165, n111)
		elseif v1802 == proto.wireTypes.lengthDelimited then
			if v1801 == 1 then
				local v1804

				v1804, n111 = proto.readBuffer(p165, n111)
				v1799.kind = {
					type = "literal",
					value = buffer.tostring(v1804)
				}
			elseif v1801 == 2 then
				local v1805

				v1805, n111 = proto.readBuffer(p165, n111)
				v1799.kind = {
					type = "token",
					value = buffer.tostring(v1805)
				}
			elseif v1801 == 3 then
				local v1806

				v1806, n111 = proto.readBuffer(p165, n111)
				v1799.kind = {
					type = "conditional",
					value = t1.UDim2Prop_ConditionalOptions.decode(v1806)
				}
			elseif v1801 == 4 then
				local v1807

				v1807, n111 = proto.readBuffer(p165, n111)
				v1799.kind = {
					type = "binding_path",
					value = buffer.tostring(v1807)
				}
			else
				local v1808, v1809 = proto.readVarInt(p165, n111)

				n111 = v1809 + v1808
			end
		elseif v1802 == proto.wireTypes.i32 then
			local v1810

			v1810, n111 = proto.readFixed32(p165, n111)
		elseif v1802 == proto.wireTypes.i64 then
			local v1811

			v1811, n111 = proto.readFixed64(p165, n111)
		else
			error("Unsupported wire type: " .. v1802)
		end
	end

	return v1799
end
function t252.jsonEncode(p166) -- line: 10308
	local t254 = {}

	if p166.kind ~= nil then
		if p166.kind.type == "literal" then
			t254.literal = p166.kind.value

			return t254
		end

		if p166.kind.type == "token" then
			t254.token = p166.kind.value

			return t254
		end

		if p166.kind.type == "conditional" then
			t254.conditional = p166.kind.value:jsonEncode()

			return t254
		end

		if p166.kind.type == "binding_path" then
			t254.bindingPath = p166.kind.value
		end
	end

	return t254
end
function t252.jsonDecode(t255: {[any]: any}) -- line: 10326
	-- upvalues: t252 (copy), t1 (copy)
	local v1815 = t252.new()

	if t255.literal ~= nil then
		v1815.kind = {
			type = "literal",
			value = t255.literal
		}
	end

	if t255.token ~= nil then
		v1815.kind = {
			type = "token",
			value = t255.token
		}
	end

	if t255.conditional ~= nil then
		v1815.kind = {
			type = "conditional",
			value = t1.UDim2Prop_ConditionalOptions.jsonDecode(t255.conditional)
		}
	end

	if t255.binding_path ~= nil then
		v1815.kind = {
			type = "binding_path",
			value = t255.binding_path
		}
	end

	if t255.bindingPath ~= nil then
		v1815.kind = {
			type = "binding_path",
			value = t255.bindingPath
		}
	end

	return v1815
end

t252.descriptor = {
	name = "UDim2Prop",
	fullName = "roblox.apppageplatform.shared.v1beta1.UDim2Prop"
}
t1.UDim2Prop = t252
typeRegistry.default:register(t1.UDim2Prop)

local t256 = {}

t256.__index = t256

function t256.new(t257: {[any]: any}?) -- line: 10367
	-- upvalues: t256 (copy)
	return (setmetatable({
		condition = if t257 ~= nil and t257.condition ~= nil then t257.condition else nil,
		kind = if t257 ~= nil and t257.kind ~= nil then t257.kind else nil
	}, t256))
end
function t256.encode(p167) -- line: 10376
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n112 = 0

	if p167.condition ~= nil then
		local v1820 = p167.condition:encode()
		local v1821, v1822 = proto.writeTag(buf, n112, 1, proto.wireTypes.lengthDelimited)

		buf, n112 = proto.writeBuffer(v1821, v1822, v1820, buffer.len(v1820))
	end

	if p167.kind ~= nil then
		if p167.kind.type == "literal" then
			local v1823, v1824 = proto.writeTag(buf, n112, 2, proto.wireTypes.lengthDelimited)

			buf, n112 = proto.writeString(v1823, v1824, p167.kind.value)
		elseif p167.kind.type == "token" then
			local v1825, v1826 = proto.writeTag(buf, n112, 3, proto.wireTypes.lengthDelimited)

			buf, n112 = proto.writeString(v1825, v1826, p167.kind.value)
		elseif p167.kind.type == "binding_path" then
			local v1827, v1828 = proto.writeTag(buf, n112, 4, proto.wireTypes.lengthDelimited)

			buf, n112 = proto.writeString(v1827, v1828, p167.kind.value)
		end
	end

	local buf58 = buffer.create(n112)

	buffer.copy(buf58, 0, buf, 0, n112)

	return buf58
end
function t256.decode(p168: buffer) -- line: 10404
	-- upvalues: t256 (copy), proto (copy), prop_condition (copy)
	local v1831 = t256.new()
	local n113 = 0

	while n113 < buffer.len(p168) do
		local v1833, v1834

		v1833, v1834, n113 = proto.readTag(p168, n113)

		if v1834 == proto.wireTypes.varint then
			local v1835

			v1835, n113 = proto.readVarInt(p168, n113)
		elseif v1834 == proto.wireTypes.lengthDelimited then
			if v1833 == 1 then
				local v1836

				v1836, n113 = proto.readBuffer(p168, n113)
				v1831.condition = prop_condition.PropCondition.decode(v1836)
			elseif v1833 == 2 then
				local v1837

				v1837, n113 = proto.readBuffer(p168, n113)
				v1831.kind = {
					type = "literal",
					value = buffer.tostring(v1837)
				}
			elseif v1833 == 3 then
				local v1838

				v1838, n113 = proto.readBuffer(p168, n113)
				v1831.kind = {
					type = "token",
					value = buffer.tostring(v1838)
				}
			elseif v1833 == 4 then
				local v1839

				v1839, n113 = proto.readBuffer(p168, n113)
				v1831.kind = {
					type = "binding_path",
					value = buffer.tostring(v1839)
				}
			else
				local v1840, v1841 = proto.readVarInt(p168, n113)

				n113 = v1841 + v1840
			end
		elseif v1834 == proto.wireTypes.i32 then
			local v1842

			v1842, n113 = proto.readFixed32(p168, n113)
		elseif v1834 == proto.wireTypes.i64 then
			local v1843

			v1843, n113 = proto.readFixed64(p168, n113)
		else
			error("Unsupported wire type: " .. v1834)
		end
	end

	return v1831
end
function t256.jsonEncode(p169) -- line: 10462
	local t258 = {}

	if p169.condition ~= nil then
		t258.condition = p169.condition:jsonEncode()
	end

	if p169.kind ~= nil then
		if p169.kind.type == "literal" then
			t258.literal = p169.kind.value

			return t258
		end

		if p169.kind.type == "token" then
			t258.token = p169.kind.value

			return t258
		end

		if p169.kind.type == "binding_path" then
			t258.bindingPath = p169.kind.value
		end
	end

	return t258
end
function t256.jsonDecode(t259: {[any]: any}) -- line: 10482
	-- upvalues: t256 (copy), prop_condition (copy)
	local v1847 = t256.new()

	if t259.condition ~= nil then
		v1847.condition = prop_condition.PropCondition.jsonDecode(t259.condition)
	end

	if t259.literal ~= nil then
		v1847.kind = {
			type = "literal",
			value = t259.literal
		}
	end

	if t259.token ~= nil then
		v1847.kind = {
			type = "token",
			value = t259.token
		}
	end

	if t259.binding_path ~= nil then
		v1847.kind = {
			type = "binding_path",
			value = t259.binding_path
		}
	end

	if t259.bindingPath ~= nil then
		v1847.kind = {
			type = "binding_path",
			value = t259.bindingPath
		}
	end

	return v1847
end

t256.descriptor = {
	name = "UDim2Prop_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}
t1.UDim2Prop_ConditionalOption = t256
typeRegistry.default:register(t1.UDim2Prop_ConditionalOption)

local t260 = {}

t260.__index = t260

function t260.new(t261: {[any]: any}?) -- line: 10523
	-- upvalues: t260 (copy)
	return (setmetatable({
		options = if t261 ~= nil and t261.options ~= nil then t261.options else {}
	}, t260))
end
function t260.encode(p170) -- line: 10531
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n114 = 0

	if p170.options ~= nil and #p170.options > 0 then
		for _, v1853 in p170.options do
			local v1854 = v1853:encode()
			local v1855, v1856 = proto.writeTag(buf, n114, 1, proto.wireTypes.lengthDelimited)

			buf, n114 = proto.writeBuffer(v1855, v1856, v1854, buffer.len(v1854))
		end
	end

	local buf59 = buffer.create(n114)

	buffer.copy(buf59, 0, buf, 0, n114)

	return buf59
end
function t260.decode(p171: buffer) -- line: 10548
	-- upvalues: t260 (copy), proto (copy), t1 (copy)
	local v1859 = t260.new()
	local n115 = 0

	while n115 < buffer.len(p171) do
		local v1861, v1862

		v1861, v1862, n115 = proto.readTag(p171, n115)

		if v1862 == proto.wireTypes.varint then
			local v1863

			v1863, n115 = proto.readVarInt(p171, n115)
		elseif v1862 == proto.wireTypes.lengthDelimited then
			if v1861 == 1 then
				local v1864

				v1864, n115 = proto.readBuffer(p171, n115)
				table.insert(v1859.options, t1.UDim2Prop_ConditionalOption.decode(v1864))
			else
				local v1865, v1866 = proto.readVarInt(p171, n115)

				n115 = v1866 + v1865
			end
		elseif v1862 == proto.wireTypes.i32 then
			local v1867

			v1867, n115 = proto.readFixed32(p171, n115)
		elseif v1862 == proto.wireTypes.i64 then
			local v1868

			v1868, n115 = proto.readFixed64(p171, n115)
		else
			error("Unsupported wire type: " .. v1862)
		end
	end

	return v1859
end
function t260.jsonEncode(p172) -- line: 10591
	local t262 = {}

	if p172.options ~= nil and #p172.options > 0 then
		local t263 = {}

		for _, v1873 in p172.options do
			table.insert(t263, v1873:jsonEncode())
		end

		t262.options = t263
	end

	return t262
end
function t260.jsonDecode(t264: {[any]: any}) -- line: 10605
	-- upvalues: t260 (copy), t1 (copy)
	local v1875 = t260.new()

	if t264.options ~= nil then
		local t265 = {}

		for _, v1878 in t264.options do
			table.insert(t265, t1.UDim2Prop_ConditionalOption.jsonDecode(v1878))
		end

		v1875.options = t265
	end

	return v1875
end

t260.descriptor = {
	name = "UDim2Prop_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}
t1.UDim2Prop_ConditionalOptions = t260
typeRegistry.default:register(t1.UDim2Prop_ConditionalOptions)

local t266 = {}

t266.__index = t266

function t266.new(t267: {[any]: any}?) -- line: 10634
	-- upvalues: t266 (copy)
	return (setmetatable({
		kind = if t267 ~= nil and t267.kind ~= nil then t267.kind else nil
	}, t266))
end
function t266.encode(p173) -- line: 10640
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n116 = 0

	if p173.kind ~= nil then
		if p173.kind.type == "literal" then
			local v1883, v1884 = proto.writeTag(buf, n116, 1, proto.wireTypes.lengthDelimited)

			buf, n116 = proto.writeString(v1883, v1884, p173.kind.value)
		elseif p173.kind.type == "token" then
			local v1885, v1886 = proto.writeTag(buf, n116, 2, proto.wireTypes.lengthDelimited)

			buf, n116 = proto.writeString(v1885, v1886, p173.kind.value)
		elseif p173.kind.type == "conditional" then
			local v1887 = p173.kind.value:encode()
			local v1888, v1889 = proto.writeTag(buf, n116, 3, proto.wireTypes.lengthDelimited)

			buf, n116 = proto.writeBuffer(v1888, v1889, v1887, buffer.len(v1887))
		elseif p173.kind.type == "binding_path" then
			local v1890, v1891 = proto.writeTag(buf, n116, 4, proto.wireTypes.lengthDelimited)

			buf, n116 = proto.writeString(v1890, v1891, p173.kind.value)
		end
	end

	local buf60 = buffer.create(n116)

	buffer.copy(buf60, 0, buf, 0, n116)

	return buf60
end
function t266.decode(p174: buffer) -- line: 10666
	-- upvalues: t266 (copy), proto (copy), t1 (copy)
	local v1894 = t266.new()
	local n117 = 0

	while n117 < buffer.len(p174) do
		local v1896, v1897

		v1896, v1897, n117 = proto.readTag(p174, n117)

		if v1897 == proto.wireTypes.varint then
			local v1898

			v1898, n117 = proto.readVarInt(p174, n117)
		elseif v1897 == proto.wireTypes.lengthDelimited then
			if v1896 == 1 then
				local v1899

				v1899, n117 = proto.readBuffer(p174, n117)
				v1894.kind = {
					type = "literal",
					value = buffer.tostring(v1899)
				}
			elseif v1896 == 2 then
				local v1900

				v1900, n117 = proto.readBuffer(p174, n117)
				v1894.kind = {
					type = "token",
					value = buffer.tostring(v1900)
				}
			elseif v1896 == 3 then
				local v1901

				v1901, n117 = proto.readBuffer(p174, n117)
				v1894.kind = {
					type = "conditional",
					value = t1.Vector2Prop_ConditionalOptions.decode(v1901)
				}
			elseif v1896 == 4 then
				local v1902

				v1902, n117 = proto.readBuffer(p174, n117)
				v1894.kind = {
					type = "binding_path",
					value = buffer.tostring(v1902)
				}
			else
				local v1903, v1904 = proto.readVarInt(p174, n117)

				n117 = v1904 + v1903
			end
		elseif v1897 == proto.wireTypes.i32 then
			local v1905

			v1905, n117 = proto.readFixed32(p174, n117)
		elseif v1897 == proto.wireTypes.i64 then
			local v1906

			v1906, n117 = proto.readFixed64(p174, n117)
		else
			error("Unsupported wire type: " .. v1897)
		end
	end

	return v1894
end
function t266.jsonEncode(p175) -- line: 10724
	local t268 = {}

	if p175.kind ~= nil then
		if p175.kind.type == "literal" then
			t268.literal = p175.kind.value

			return t268
		end

		if p175.kind.type == "token" then
			t268.token = p175.kind.value

			return t268
		end

		if p175.kind.type == "conditional" then
			t268.conditional = p175.kind.value:jsonEncode()

			return t268
		end

		if p175.kind.type == "binding_path" then
			t268.bindingPath = p175.kind.value
		end
	end

	return t268
end
function t266.jsonDecode(t269: {[any]: any}) -- line: 10742
	-- upvalues: t266 (copy), t1 (copy)
	local v1910 = t266.new()

	if t269.literal ~= nil then
		v1910.kind = {
			type = "literal",
			value = t269.literal
		}
	end

	if t269.token ~= nil then
		v1910.kind = {
			type = "token",
			value = t269.token
		}
	end

	if t269.conditional ~= nil then
		v1910.kind = {
			type = "conditional",
			value = t1.Vector2Prop_ConditionalOptions.jsonDecode(t269.conditional)
		}
	end

	if t269.binding_path ~= nil then
		v1910.kind = {
			type = "binding_path",
			value = t269.binding_path
		}
	end

	if t269.bindingPath ~= nil then
		v1910.kind = {
			type = "binding_path",
			value = t269.bindingPath
		}
	end

	return v1910
end

t266.descriptor = {
	name = "Vector2Prop",
	fullName = "roblox.apppageplatform.shared.v1beta1.Vector2Prop"
}
t1.Vector2Prop = t266
typeRegistry.default:register(t1.Vector2Prop)

local t270 = {}

t270.__index = t270

function t270.new(t271: {[any]: any}?) -- line: 10783
	-- upvalues: t270 (copy)
	return (setmetatable({
		condition = if t271 ~= nil and t271.condition ~= nil then t271.condition else nil,
		kind = if t271 ~= nil and t271.kind ~= nil then t271.kind else nil
	}, t270))
end
function t270.encode(p176) -- line: 10792
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n118 = 0

	if p176.condition ~= nil then
		local v1915 = p176.condition:encode()
		local v1916, v1917 = proto.writeTag(buf, n118, 1, proto.wireTypes.lengthDelimited)

		buf, n118 = proto.writeBuffer(v1916, v1917, v1915, buffer.len(v1915))
	end

	if p176.kind ~= nil then
		if p176.kind.type == "literal" then
			local v1918, v1919 = proto.writeTag(buf, n118, 2, proto.wireTypes.lengthDelimited)

			buf, n118 = proto.writeString(v1918, v1919, p176.kind.value)
		elseif p176.kind.type == "token" then
			local v1920, v1921 = proto.writeTag(buf, n118, 3, proto.wireTypes.lengthDelimited)

			buf, n118 = proto.writeString(v1920, v1921, p176.kind.value)
		elseif p176.kind.type == "binding_path" then
			local v1922, v1923 = proto.writeTag(buf, n118, 4, proto.wireTypes.lengthDelimited)

			buf, n118 = proto.writeString(v1922, v1923, p176.kind.value)
		end
	end

	local buf61 = buffer.create(n118)

	buffer.copy(buf61, 0, buf, 0, n118)

	return buf61
end
function t270.decode(p177: buffer) -- line: 10820
	-- upvalues: t270 (copy), proto (copy), prop_condition (copy)
	local v1926 = t270.new()
	local n119 = 0

	while n119 < buffer.len(p177) do
		local v1928, v1929

		v1928, v1929, n119 = proto.readTag(p177, n119)

		if v1929 == proto.wireTypes.varint then
			local v1930

			v1930, n119 = proto.readVarInt(p177, n119)
		elseif v1929 == proto.wireTypes.lengthDelimited then
			if v1928 == 1 then
				local v1931

				v1931, n119 = proto.readBuffer(p177, n119)
				v1926.condition = prop_condition.PropCondition.decode(v1931)
			elseif v1928 == 2 then
				local v1932

				v1932, n119 = proto.readBuffer(p177, n119)
				v1926.kind = {
					type = "literal",
					value = buffer.tostring(v1932)
				}
			elseif v1928 == 3 then
				local v1933

				v1933, n119 = proto.readBuffer(p177, n119)
				v1926.kind = {
					type = "token",
					value = buffer.tostring(v1933)
				}
			elseif v1928 == 4 then
				local v1934

				v1934, n119 = proto.readBuffer(p177, n119)
				v1926.kind = {
					type = "binding_path",
					value = buffer.tostring(v1934)
				}
			else
				local v1935, v1936 = proto.readVarInt(p177, n119)

				n119 = v1936 + v1935
			end
		elseif v1929 == proto.wireTypes.i32 then
			local v1937

			v1937, n119 = proto.readFixed32(p177, n119)
		elseif v1929 == proto.wireTypes.i64 then
			local v1938

			v1938, n119 = proto.readFixed64(p177, n119)
		else
			error("Unsupported wire type: " .. v1929)
		end
	end

	return v1926
end
function t270.jsonEncode(p178) -- line: 10878
	local t272 = {}

	if p178.condition ~= nil then
		t272.condition = p178.condition:jsonEncode()
	end

	if p178.kind ~= nil then
		if p178.kind.type == "literal" then
			t272.literal = p178.kind.value

			return t272
		end

		if p178.kind.type == "token" then
			t272.token = p178.kind.value

			return t272
		end

		if p178.kind.type == "binding_path" then
			t272.bindingPath = p178.kind.value
		end
	end

	return t272
end
function t270.jsonDecode(t273: {[any]: any}) -- line: 10898
	-- upvalues: t270 (copy), prop_condition (copy)
	local v1942 = t270.new()

	if t273.condition ~= nil then
		v1942.condition = prop_condition.PropCondition.jsonDecode(t273.condition)
	end

	if t273.literal ~= nil then
		v1942.kind = {
			type = "literal",
			value = t273.literal
		}
	end

	if t273.token ~= nil then
		v1942.kind = {
			type = "token",
			value = t273.token
		}
	end

	if t273.binding_path ~= nil then
		v1942.kind = {
			type = "binding_path",
			value = t273.binding_path
		}
	end

	if t273.bindingPath ~= nil then
		v1942.kind = {
			type = "binding_path",
			value = t273.bindingPath
		}
	end

	return v1942
end

t270.descriptor = {
	name = "Vector2Prop_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}
t1.Vector2Prop_ConditionalOption = t270
typeRegistry.default:register(t1.Vector2Prop_ConditionalOption)

local t274 = {}

t274.__index = t274

function t274.new(t275: {[any]: any}?) -- line: 10939
	-- upvalues: t274 (copy)
	return (setmetatable({
		options = if t275 ~= nil and t275.options ~= nil then t275.options else {}
	}, t274))
end
function t274.encode(p179) -- line: 10947
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n120 = 0

	if p179.options ~= nil and #p179.options > 0 then
		for _, v1948 in p179.options do
			local v1949 = v1948:encode()
			local v1950, v1951 = proto.writeTag(buf, n120, 1, proto.wireTypes.lengthDelimited)

			buf, n120 = proto.writeBuffer(v1950, v1951, v1949, buffer.len(v1949))
		end
	end

	local buf62 = buffer.create(n120)

	buffer.copy(buf62, 0, buf, 0, n120)

	return buf62
end
function t274.decode(p180: buffer) -- line: 10964
	-- upvalues: t274 (copy), proto (copy), t1 (copy)
	local v1954 = t274.new()
	local n121 = 0

	while n121 < buffer.len(p180) do
		local v1956, v1957

		v1956, v1957, n121 = proto.readTag(p180, n121)

		if v1957 == proto.wireTypes.varint then
			local v1958

			v1958, n121 = proto.readVarInt(p180, n121)
		elseif v1957 == proto.wireTypes.lengthDelimited then
			if v1956 == 1 then
				local v1959

				v1959, n121 = proto.readBuffer(p180, n121)
				table.insert(v1954.options, t1.Vector2Prop_ConditionalOption.decode(v1959))
			else
				local v1960, v1961 = proto.readVarInt(p180, n121)

				n121 = v1961 + v1960
			end
		elseif v1957 == proto.wireTypes.i32 then
			local v1962

			v1962, n121 = proto.readFixed32(p180, n121)
		elseif v1957 == proto.wireTypes.i64 then
			local v1963

			v1963, n121 = proto.readFixed64(p180, n121)
		else
			error("Unsupported wire type: " .. v1957)
		end
	end

	return v1954
end
function t274.jsonEncode(p181) -- line: 11007
	local t276 = {}

	if p181.options ~= nil and #p181.options > 0 then
		local t277 = {}

		for _, v1968 in p181.options do
			table.insert(t277, v1968:jsonEncode())
		end

		t276.options = t277
	end

	return t276
end
function t274.jsonDecode(t278: {[any]: any}) -- line: 11021
	-- upvalues: t274 (copy), t1 (copy)
	local v1970 = t274.new()

	if t278.options ~= nil then
		local t279 = {}

		for _, v1973 in t278.options do
			table.insert(t279, t1.Vector2Prop_ConditionalOption.jsonDecode(v1973))
		end

		v1970.options = t279
	end

	return v1970
end

t274.descriptor = {
	name = "Vector2Prop_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}
t1.Vector2Prop_ConditionalOptions = t274
typeRegistry.default:register(t1.Vector2Prop_ConditionalOptions)

local t280 = {}

t280.__index = t280

function t280.new(t281: {[any]: any}?) -- line: 11050
	-- upvalues: t280 (copy)
	return (setmetatable({
		kind = if t281 ~= nil and t281.kind ~= nil then t281.kind else nil
	}, t280))
end
function t280.encode(p182) -- line: 11056
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n122 = 0

	if p182.kind ~= nil then
		if p182.kind.type == "literal" then
			local v1978, v1979 = proto.writeTag(buf, n122, 1, proto.wireTypes.lengthDelimited)

			buf, n122 = proto.writeString(v1978, v1979, p182.kind.value)
		elseif p182.kind.type == "binding_path" then
			local v1980, v1981 = proto.writeTag(buf, n122, 2, proto.wireTypes.lengthDelimited)

			buf, n122 = proto.writeString(v1980, v1981, p182.kind.value)
		elseif p182.kind.type == "conditional" then
			local v1982 = p182.kind.value:encode()
			local v1983, v1984 = proto.writeTag(buf, n122, 3, proto.wireTypes.lengthDelimited)

			buf, n122 = proto.writeBuffer(v1983, v1984, v1982, buffer.len(v1982))
		end
	end

	local buf63 = buffer.create(n122)

	buffer.copy(buf63, 0, buf, 0, n122)

	return buf63
end
function t280.decode(p183: buffer) -- line: 11079
	-- upvalues: t280 (copy), proto (copy), t1 (copy)
	local v1987 = t280.new()
	local n123 = 0

	while n123 < buffer.len(p183) do
		local v1989, v1990

		v1989, v1990, n123 = proto.readTag(p183, n123)

		if v1990 == proto.wireTypes.varint then
			local v1991

			v1991, n123 = proto.readVarInt(p183, n123)
		elseif v1990 == proto.wireTypes.lengthDelimited then
			if v1989 == 1 then
				local v1992

				v1992, n123 = proto.readBuffer(p183, n123)
				v1987.kind = {
					type = "literal",
					value = buffer.tostring(v1992)
				}
			elseif v1989 == 2 then
				local v1993

				v1993, n123 = proto.readBuffer(p183, n123)
				v1987.kind = {
					type = "binding_path",
					value = buffer.tostring(v1993)
				}
			elseif v1989 == 3 then
				local v1994

				v1994, n123 = proto.readBuffer(p183, n123)
				v1987.kind = {
					type = "conditional",
					value = t1.IconProp_ConditionalOptions.decode(v1994)
				}
			else
				local v1995, v1996 = proto.readVarInt(p183, n123)

				n123 = v1996 + v1995
			end
		elseif v1990 == proto.wireTypes.i32 then
			local v1997

			v1997, n123 = proto.readFixed32(p183, n123)
		elseif v1990 == proto.wireTypes.i64 then
			local v1998

			v1998, n123 = proto.readFixed64(p183, n123)
		else
			error("Unsupported wire type: " .. v1990)
		end
	end

	return v1987
end
function t280.jsonEncode(p184) -- line: 11132
	local t282 = {}

	if p184.kind ~= nil then
		if p184.kind.type == "literal" then
			t282.literal = p184.kind.value

			return t282
		end

		if p184.kind.type == "binding_path" then
			t282.bindingPath = p184.kind.value

			return t282
		end

		if p184.kind.type == "conditional" then
			t282.conditional = p184.kind.value:jsonEncode()
		end
	end

	return t282
end
function t280.jsonDecode(t283: {[any]: any}) -- line: 11148
	-- upvalues: t280 (copy), t1 (copy)
	local v2002 = t280.new()

	if t283.literal ~= nil then
		v2002.kind = {
			type = "literal",
			value = t283.literal
		}
	end

	if t283.binding_path ~= nil then
		v2002.kind = {
			type = "binding_path",
			value = t283.binding_path
		}
	end

	if t283.bindingPath ~= nil then
		v2002.kind = {
			type = "binding_path",
			value = t283.bindingPath
		}
	end

	if t283.conditional ~= nil then
		v2002.kind = {
			type = "conditional",
			value = t1.IconProp_ConditionalOptions.jsonDecode(t283.conditional)
		}
	end

	return v2002
end

t280.descriptor = {
	name = "IconProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.IconProp"
}
t1.IconProp = t280
typeRegistry.default:register(t1.IconProp)

local t284 = {}

t284.__index = t284

function t284.new(t285: {[any]: any}?) -- line: 11185
	-- upvalues: t284 (copy)
	return (setmetatable({
		condition = if t285 ~= nil and t285.condition ~= nil then t285.condition else nil,
		kind = if t285 ~= nil and t285.kind ~= nil then t285.kind else nil
	}, t284))
end
function t284.encode(p185) -- line: 11194
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n124 = 0

	if p185.condition ~= nil then
		local v2007 = p185.condition:encode()
		local v2008, v2009 = proto.writeTag(buf, n124, 1, proto.wireTypes.lengthDelimited)

		buf, n124 = proto.writeBuffer(v2008, v2009, v2007, buffer.len(v2007))
	end

	if p185.kind ~= nil then
		if p185.kind.type == "literal" then
			local v2010, v2011 = proto.writeTag(buf, n124, 2, proto.wireTypes.lengthDelimited)

			buf, n124 = proto.writeString(v2010, v2011, p185.kind.value)
		elseif p185.kind.type == "binding_path" then
			local v2012, v2013 = proto.writeTag(buf, n124, 3, proto.wireTypes.lengthDelimited)

			buf, n124 = proto.writeString(v2012, v2013, p185.kind.value)
		end
	end

	local buf64 = buffer.create(n124)

	buffer.copy(buf64, 0, buf, 0, n124)

	return buf64
end
function t284.decode(p186: buffer) -- line: 11219
	-- upvalues: t284 (copy), proto (copy), prop_condition (copy)
	local v2016 = t284.new()
	local n125 = 0

	while n125 < buffer.len(p186) do
		local v2018, v2019

		v2018, v2019, n125 = proto.readTag(p186, n125)

		if v2019 == proto.wireTypes.varint then
			local v2020

			v2020, n125 = proto.readVarInt(p186, n125)
		elseif v2019 == proto.wireTypes.lengthDelimited then
			if v2018 == 1 then
				local v2021

				v2021, n125 = proto.readBuffer(p186, n125)
				v2016.condition = prop_condition.PropCondition.decode(v2021)
			elseif v2018 == 2 then
				local v2022

				v2022, n125 = proto.readBuffer(p186, n125)
				v2016.kind = {
					type = "literal",
					value = buffer.tostring(v2022)
				}
			elseif v2018 == 3 then
				local v2023

				v2023, n125 = proto.readBuffer(p186, n125)
				v2016.kind = {
					type = "binding_path",
					value = buffer.tostring(v2023)
				}
			else
				local v2024, v2025 = proto.readVarInt(p186, n125)

				n125 = v2025 + v2024
			end
		elseif v2019 == proto.wireTypes.i32 then
			local v2026

			v2026, n125 = proto.readFixed32(p186, n125)
		elseif v2019 == proto.wireTypes.i64 then
			local v2027

			v2027, n125 = proto.readFixed64(p186, n125)
		else
			error("Unsupported wire type: " .. v2019)
		end
	end

	return v2016
end
function t284.jsonEncode(p187) -- line: 11272
	local t286 = {}

	if p187.condition ~= nil then
		t286.condition = p187.condition:jsonEncode()
	end

	if p187.kind ~= nil then
		if p187.kind.type == "literal" then
			t286.literal = p187.kind.value

			return t286
		end

		if p187.kind.type == "binding_path" then
			t286.bindingPath = p187.kind.value
		end
	end

	return t286
end
function t284.jsonDecode(t287: {[any]: any}) -- line: 11290
	-- upvalues: t284 (copy), prop_condition (copy)
	local v2031 = t284.new()

	if t287.condition ~= nil then
		v2031.condition = prop_condition.PropCondition.jsonDecode(t287.condition)
	end

	if t287.literal ~= nil then
		v2031.kind = {
			type = "literal",
			value = t287.literal
		}
	end

	if t287.binding_path ~= nil then
		v2031.kind = {
			type = "binding_path",
			value = t287.binding_path
		}
	end

	if t287.bindingPath ~= nil then
		v2031.kind = {
			type = "binding_path",
			value = t287.bindingPath
		}
	end

	return v2031
end

t284.descriptor = {
	name = "IconProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}
t1.IconProp_ConditionalOption = t284
typeRegistry.default:register(t1.IconProp_ConditionalOption)

local t288 = {}

t288.__index = t288

function t288.new(t289: {[any]: any}?) -- line: 11327
	-- upvalues: t288 (copy)
	return (setmetatable({
		options = if t289 ~= nil and t289.options ~= nil then t289.options else {}
	}, t288))
end
function t288.encode(p188) -- line: 11335
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n126 = 0

	if p188.options ~= nil and #p188.options > 0 then
		for _, v2037 in p188.options do
			local v2038 = v2037:encode()
			local v2039, v2040 = proto.writeTag(buf, n126, 1, proto.wireTypes.lengthDelimited)

			buf, n126 = proto.writeBuffer(v2039, v2040, v2038, buffer.len(v2038))
		end
	end

	local buf65 = buffer.create(n126)

	buffer.copy(buf65, 0, buf, 0, n126)

	return buf65
end
function t288.decode(p189: buffer) -- line: 11352
	-- upvalues: t288 (copy), proto (copy), t1 (copy)
	local v2043 = t288.new()
	local n127 = 0

	while n127 < buffer.len(p189) do
		local v2045, v2046

		v2045, v2046, n127 = proto.readTag(p189, n127)

		if v2046 == proto.wireTypes.varint then
			local v2047

			v2047, n127 = proto.readVarInt(p189, n127)
		elseif v2046 == proto.wireTypes.lengthDelimited then
			if v2045 == 1 then
				local v2048

				v2048, n127 = proto.readBuffer(p189, n127)
				table.insert(v2043.options, t1.IconProp_ConditionalOption.decode(v2048))
			else
				local v2049, v2050 = proto.readVarInt(p189, n127)

				n127 = v2050 + v2049
			end
		elseif v2046 == proto.wireTypes.i32 then
			local v2051

			v2051, n127 = proto.readFixed32(p189, n127)
		elseif v2046 == proto.wireTypes.i64 then
			local v2052

			v2052, n127 = proto.readFixed64(p189, n127)
		else
			error("Unsupported wire type: " .. v2046)
		end
	end

	return v2043
end
function t288.jsonEncode(p190) -- line: 11395
	local t290 = {}

	if p190.options ~= nil and #p190.options > 0 then
		local t291 = {}

		for _, v2057 in p190.options do
			table.insert(t291, v2057:jsonEncode())
		end

		t290.options = t291
	end

	return t290
end
function t288.jsonDecode(t292: {[any]: any}) -- line: 11409
	-- upvalues: t288 (copy), t1 (copy)
	local v2059 = t288.new()

	if t292.options ~= nil then
		local t293 = {}

		for _, v2062 in t292.options do
			table.insert(t293, t1.IconProp_ConditionalOption.jsonDecode(v2062))
		end

		v2059.options = t293
	end

	return v2059
end

t288.descriptor = {
	name = "IconProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}
t1.IconProp_ConditionalOptions = t288
typeRegistry.default:register(t1.IconProp_ConditionalOptions)

local t294 = {}

t294.__index = t294

function t294.new(t295: {[any]: any}?) -- line: 11438
	-- upvalues: t294 (copy)
	return (setmetatable({
		kind = if t295 ~= nil and t295.kind ~= nil then t295.kind else nil
	}, t294))
end
function t294.encode(p191) -- line: 11444
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n128 = 0

	if p191.kind ~= nil then
		if p191.kind.type == "literal" then
			local v2067 = p191.kind.value:encode()
			local v2068, v2069 = proto.writeTag(buf, n128, 1, proto.wireTypes.lengthDelimited)

			buf, n128 = proto.writeBuffer(v2068, v2069, v2067, buffer.len(v2067))
		elseif p191.kind.type == "binding_path" then
			local v2070, v2071 = proto.writeTag(buf, n128, 2, proto.wireTypes.lengthDelimited)

			buf, n128 = proto.writeString(v2070, v2071, p191.kind.value)
		elseif p191.kind.type == "conditional" then
			local v2072 = p191.kind.value:encode()
			local v2073, v2074 = proto.writeTag(buf, n128, 3, proto.wireTypes.lengthDelimited)

			buf, n128 = proto.writeBuffer(v2073, v2074, v2072, buffer.len(v2072))
		end
	end

	local buf66 = buffer.create(n128)

	buffer.copy(buf66, 0, buf, 0, n128)

	return buf66
end
function t294.decode(p192: buffer) -- line: 11468
	-- upvalues: t294 (copy), proto (copy), t1 (copy)
	local v2077 = t294.new()
	local n129 = 0

	while n129 < buffer.len(p192) do
		local v2079, v2080

		v2079, v2080, n129 = proto.readTag(p192, n129)

		if v2080 == proto.wireTypes.varint then
			local v2081

			v2081, n129 = proto.readVarInt(p192, n129)
		elseif v2080 == proto.wireTypes.lengthDelimited then
			if v2079 == 1 then
				local v2082

				v2082, n129 = proto.readBuffer(p192, n129)
				v2077.kind = {
					type = "literal",
					value = t1.FoundationIconConfigProp_FoundationIconConfig.decode(v2082)
				}
			elseif v2079 == 2 then
				local v2083

				v2083, n129 = proto.readBuffer(p192, n129)
				v2077.kind = {
					type = "binding_path",
					value = buffer.tostring(v2083)
				}
			elseif v2079 == 3 then
				local v2084

				v2084, n129 = proto.readBuffer(p192, n129)
				v2077.kind = {
					type = "conditional",
					value = t1.FoundationIconConfigProp_ConditionalOptions.decode(v2084)
				}
			else
				local v2085, v2086 = proto.readVarInt(p192, n129)

				n129 = v2086 + v2085
			end
		elseif v2080 == proto.wireTypes.i32 then
			local v2087

			v2087, n129 = proto.readFixed32(p192, n129)
		elseif v2080 == proto.wireTypes.i64 then
			local v2088

			v2088, n129 = proto.readFixed64(p192, n129)
		else
			error("Unsupported wire type: " .. v2080)
		end
	end

	return v2077
end
function t294.jsonEncode(p193) -- line: 11527
	local t296 = {}

	if p193.kind ~= nil then
		if p193.kind.type == "literal" then
			t296.literal = p193.kind.value:jsonEncode()

			return t296
		end

		if p193.kind.type == "binding_path" then
			t296.bindingPath = p193.kind.value

			return t296
		end

		if p193.kind.type == "conditional" then
			t296.conditional = p193.kind.value:jsonEncode()
		end
	end

	return t296
end
function t294.jsonDecode(t297: {[any]: any}) -- line: 11543
	-- upvalues: t294 (copy), t1 (copy)
	local v2092 = t294.new()

	if t297.literal ~= nil then
		v2092.kind = {
			type = "literal",
			value = t1.FoundationIconConfigProp_FoundationIconConfig.jsonDecode(t297.literal)
		}
	end

	if t297.binding_path ~= nil then
		v2092.kind = {
			type = "binding_path",
			value = t297.binding_path
		}
	end

	if t297.bindingPath ~= nil then
		v2092.kind = {
			type = "binding_path",
			value = t297.bindingPath
		}
	end

	if t297.conditional ~= nil then
		v2092.kind = {
			type = "conditional",
			value = t1.FoundationIconConfigProp_ConditionalOptions.jsonDecode(t297.conditional)
		}
	end

	return v2092
end

t294.descriptor = {
	name = "FoundationIconConfigProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.FoundationIconConfigProp"
}
t1.FoundationIconConfigProp = t294
typeRegistry.default:register(t1.FoundationIconConfigProp)

local t298 = {}

t298.__index = t298

function t298.new(t299: {[any]: any}?) -- line: 11585
	-- upvalues: t298 (copy)
	return (setmetatable({
		condition = if t299 ~= nil and t299.condition ~= nil then t299.condition else nil,
		kind = if t299 ~= nil and t299.kind ~= nil then t299.kind else nil
	}, t298))
end
function t298.encode(p194) -- line: 11594
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n130 = 0

	if p194.condition ~= nil then
		local v2097 = p194.condition:encode()
		local v2098, v2099 = proto.writeTag(buf, n130, 1, proto.wireTypes.lengthDelimited)

		buf, n130 = proto.writeBuffer(v2098, v2099, v2097, buffer.len(v2097))
	end

	if p194.kind ~= nil then
		if p194.kind.type == "literal" then
			local v2100 = p194.kind.value:encode()
			local v2101, v2102 = proto.writeTag(buf, n130, 2, proto.wireTypes.lengthDelimited)

			buf, n130 = proto.writeBuffer(v2101, v2102, v2100, buffer.len(v2100))
		elseif p194.kind.type == "binding_path" then
			local v2103, v2104 = proto.writeTag(buf, n130, 3, proto.wireTypes.lengthDelimited)

			buf, n130 = proto.writeString(v2103, v2104, p194.kind.value)
		end
	end

	local buf67 = buffer.create(n130)

	buffer.copy(buf67, 0, buf, 0, n130)

	return buf67
end
function t298.decode(p195: buffer) -- line: 11622
	-- upvalues: t298 (copy), proto (copy), prop_condition (copy), t1 (copy)
	local v2107 = t298.new()
	local n131 = 0

	while n131 < buffer.len(p195) do
		local v2109, v2110

		v2109, v2110, n131 = proto.readTag(p195, n131)

		if v2110 == proto.wireTypes.varint then
			local v2111

			v2111, n131 = proto.readVarInt(p195, n131)
		elseif v2110 == proto.wireTypes.lengthDelimited then
			if v2109 == 1 then
				local v2112

				v2112, n131 = proto.readBuffer(p195, n131)
				v2107.condition = prop_condition.PropCondition.decode(v2112)
			elseif v2109 == 2 then
				local v2113

				v2113, n131 = proto.readBuffer(p195, n131)
				v2107.kind = {
					type = "literal",
					value = t1.FoundationIconConfigProp_FoundationIconConfig.decode(v2113)
				}
			elseif v2109 == 3 then
				local v2114

				v2114, n131 = proto.readBuffer(p195, n131)
				v2107.kind = {
					type = "binding_path",
					value = buffer.tostring(v2114)
				}
			else
				local v2115, v2116 = proto.readVarInt(p195, n131)

				n131 = v2116 + v2115
			end
		elseif v2110 == proto.wireTypes.i32 then
			local v2117

			v2117, n131 = proto.readFixed32(p195, n131)
		elseif v2110 == proto.wireTypes.i64 then
			local v2118

			v2118, n131 = proto.readFixed64(p195, n131)
		else
			error("Unsupported wire type: " .. v2110)
		end
	end

	return v2107
end
function t298.jsonEncode(p196) -- line: 11680
	local t300 = {}

	if p196.condition ~= nil then
		t300.condition = p196.condition:jsonEncode()
	end

	if p196.kind ~= nil then
		if p196.kind.type == "literal" then
			t300.literal = p196.kind.value:jsonEncode()

			return t300
		end

		if p196.kind.type == "binding_path" then
			t300.bindingPath = p196.kind.value
		end
	end

	return t300
end
function t298.jsonDecode(t301: {[any]: any}) -- line: 11700
	-- upvalues: t298 (copy), prop_condition (copy), t1 (copy)
	local v2122 = t298.new()

	if t301.condition ~= nil then
		v2122.condition = prop_condition.PropCondition.jsonDecode(t301.condition)
	end

	if t301.literal ~= nil then
		v2122.kind = {
			type = "literal",
			value = t1.FoundationIconConfigProp_FoundationIconConfig.jsonDecode(t301.literal)
		}
	end

	if t301.binding_path ~= nil then
		v2122.kind = {
			type = "binding_path",
			value = t301.binding_path
		}
	end

	if t301.bindingPath ~= nil then
		v2122.kind = {
			type = "binding_path",
			value = t301.bindingPath
		}
	end

	return v2122
end

t298.descriptor = {
	name = "FoundationIconConfigProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}
t1.FoundationIconConfigProp_ConditionalOption = t298
typeRegistry.default:register(t1.FoundationIconConfigProp_ConditionalOption)

local t302 = {}

t302.__index = t302

function t302.new(t303: {[any]: any}?) -- line: 11742
	-- upvalues: t302 (copy)
	return (setmetatable({
		options = if t303 ~= nil and t303.options ~= nil then t303.options else {}
	}, t302))
end
function t302.encode(p197) -- line: 11750
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n132 = 0

	if p197.options ~= nil and #p197.options > 0 then
		for _, v2128 in p197.options do
			local v2129 = v2128:encode()
			local v2130, v2131 = proto.writeTag(buf, n132, 1, proto.wireTypes.lengthDelimited)

			buf, n132 = proto.writeBuffer(v2130, v2131, v2129, buffer.len(v2129))
		end
	end

	local buf68 = buffer.create(n132)

	buffer.copy(buf68, 0, buf, 0, n132)

	return buf68
end
function t302.decode(p198: buffer) -- line: 11769
	-- upvalues: t302 (copy), proto (copy), t1 (copy)
	local v2134 = t302.new()
	local n133 = 0

	while n133 < buffer.len(p198) do
		local v2136, v2137

		v2136, v2137, n133 = proto.readTag(p198, n133)

		if v2137 == proto.wireTypes.varint then
			local v2138

			v2138, n133 = proto.readVarInt(p198, n133)
		elseif v2137 == proto.wireTypes.lengthDelimited then
			if v2136 == 1 then
				local v2139

				v2139, n133 = proto.readBuffer(p198, n133)
				table.insert(v2134.options, t1.FoundationIconConfigProp_ConditionalOption.decode(v2139))
			else
				local v2140, v2141 = proto.readVarInt(p198, n133)

				n133 = v2141 + v2140
			end
		elseif v2137 == proto.wireTypes.i32 then
			local v2142

			v2142, n133 = proto.readFixed32(p198, n133)
		elseif v2137 == proto.wireTypes.i64 then
			local v2143

			v2143, n133 = proto.readFixed64(p198, n133)
		else
			error("Unsupported wire type: " .. v2137)
		end
	end

	return v2134
end
function t302.jsonEncode(p199) -- line: 11814
	local t304 = {}

	if p199.options ~= nil and #p199.options > 0 then
		local t305 = {}

		for _, v2148 in p199.options do
			table.insert(t305, v2148:jsonEncode())
		end

		t304.options = t305
	end

	return t304
end
function t302.jsonDecode(t306: {[any]: any}) -- line: 11830
	-- upvalues: t302 (copy), t1 (copy)
	local v2150 = t302.new()

	if t306.options ~= nil then
		local t307 = {}

		for _, v2153 in t306.options do
			table.insert(t307, t1.FoundationIconConfigProp_ConditionalOption.jsonDecode(v2153))
		end

		v2150.options = t307
	end

	return v2150
end

t302.descriptor = {
	name = "FoundationIconConfigProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}
t1.FoundationIconConfigProp_ConditionalOptions = t302
typeRegistry.default:register(t1.FoundationIconConfigProp_ConditionalOptions)

local t308 = {}

t308.__index = t308

function t308.new(t309: {[any]: any}?) -- line: 11861
	-- upvalues: t308 (copy)
	return (setmetatable({
		name = if t309 ~= nil and t309.name ~= nil then t309.name else nil,
		variant = if t309 ~= nil and t309.variant ~= nil then t309.variant else nil
	}, t308))
end
function t308.encode(p200) -- line: 11870
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n134 = 0

	if p200.name ~= nil then
		local v2158 = p200.name:encode()
		local v2159, v2160 = proto.writeTag(buf, n134, 1, proto.wireTypes.lengthDelimited)

		buf, n134 = proto.writeBuffer(v2159, v2160, v2158, buffer.len(v2158))
	end

	if p200.variant ~= nil then
		local v2161 = p200.variant:encode()
		local v2162, v2163 = proto.writeTag(buf, n134, 2, proto.wireTypes.lengthDelimited)

		buf, n134 = proto.writeBuffer(v2162, v2163, v2161, buffer.len(v2161))
	end

	local buf69 = buffer.create(n134)

	buffer.copy(buf69, 0, buf, 0, n134)

	return buf69
end
function t308.decode(p201: buffer) -- line: 11893
	-- upvalues: t308 (copy), proto (copy), t1 (copy)
	local v2166 = t308.new()
	local n135 = 0

	while n135 < buffer.len(p201) do
		local v2168, v2169

		v2168, v2169, n135 = proto.readTag(p201, n135)

		if v2169 == proto.wireTypes.varint then
			local v2170

			v2170, n135 = proto.readVarInt(p201, n135)
		elseif v2169 == proto.wireTypes.lengthDelimited then
			if v2168 == 1 then
				local v2171

				v2171, n135 = proto.readBuffer(p201, n135)
				v2166.name = t1.StringProp.decode(v2171)
			elseif v2168 == 2 then
				local v2172

				v2172, n135 = proto.readBuffer(p201, n135)
				v2166.variant = t1.StringProp.decode(v2172)
			else
				local v2173, v2174 = proto.readVarInt(p201, n135)

				n135 = v2174 + v2173
			end
		elseif v2169 == proto.wireTypes.i32 then
			local v2175

			v2175, n135 = proto.readFixed32(p201, n135)
		elseif v2169 == proto.wireTypes.i64 then
			local v2176

			v2176, n135 = proto.readFixed64(p201, n135)
		else
			error("Unsupported wire type: " .. v2169)
		end
	end

	return v2166
end
function t308.jsonEncode(p202) -- line: 11943
	local t310 = {}

	if p202.name ~= nil then
		t310.name = p202.name:jsonEncode()
	end

	if p202.variant ~= nil then
		t310.variant = p202.variant:jsonEncode()
	end

	return t310
end
function t308.jsonDecode(t311: {[any]: any}) -- line: 11959
	-- upvalues: t308 (copy), t1 (copy)
	local v2180 = t308.new()

	if t311.name ~= nil then
		v2180.name = t1.StringProp.jsonDecode(t311.name)
	end

	if t311.variant ~= nil then
		v2180.variant = t1.StringProp.jsonDecode(t311.variant)
	end

	return v2180
end

t308.descriptor = {
	name = "FoundationIconConfigProp_FoundationIconConfig",
	fullName = "roblox.apppageplatform.shared.v1beta1.FoundationIconConfig"
}
t1.FoundationIconConfigProp_FoundationIconConfig = t308
typeRegistry.default:register(t1.FoundationIconConfigProp_FoundationIconConfig)

local t312 = {}

t312.__index = t312

function t312.new(t313: {[any]: any}?) -- line: 11989
	-- upvalues: t312 (copy)
	return (setmetatable({
		oneof_prop = if t313 ~= nil and t313.oneof_prop ~= nil then t313.oneof_prop else nil
	}, t312))
end
function t312.encode(p203) -- line: 11995
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n136 = 0

	if p203.oneof_prop ~= nil then
		if p203.oneof_prop.type == "string_prop" then
			local v2185 = p203.oneof_prop.value:encode()
			local v2186, v2187 = proto.writeTag(buf, n136, 1, proto.wireTypes.lengthDelimited)

			buf, n136 = proto.writeBuffer(v2186, v2187, v2185, buffer.len(v2185))
		elseif p203.oneof_prop.type == "int32_prop" then
			local v2188 = p203.oneof_prop.value:encode()
			local v2189, v2190 = proto.writeTag(buf, n136, 2, proto.wireTypes.lengthDelimited)

			buf, n136 = proto.writeBuffer(v2189, v2190, v2188, buffer.len(v2188))
		end
	end

	local buf70 = buffer.create(n136)

	buffer.copy(buf70, 0, buf, 0, n136)

	return buf70
end
function t312.decode(p204: buffer) -- line: 12016
	-- upvalues: t312 (copy), proto (copy), t1 (copy)
	local v2193 = t312.new()
	local n137 = 0

	while n137 < buffer.len(p204) do
		local v2195, v2196

		v2195, v2196, n137 = proto.readTag(p204, n137)

		if v2196 == proto.wireTypes.varint then
			local v2197

			v2197, n137 = proto.readVarInt(p204, n137)
		elseif v2196 == proto.wireTypes.lengthDelimited then
			if v2195 == 1 then
				local v2198

				v2198, n137 = proto.readBuffer(p204, n137)
				v2193.oneof_prop = {
					type = "string_prop",
					value = t1.StringProp.decode(v2198)
				}
			elseif v2195 == 2 then
				local v2199

				v2199, n137 = proto.readBuffer(p204, n137)
				v2193.oneof_prop = {
					type = "int32_prop",
					value = t1.Int32Prop.decode(v2199)
				}
			else
				local v2200, v2201 = proto.readVarInt(p204, n137)

				n137 = v2201 + v2200
			end
		elseif v2196 == proto.wireTypes.i32 then
			local v2202

			v2202, n137 = proto.readFixed32(p204, n137)
		elseif v2196 == proto.wireTypes.i64 then
			local v2203

			v2203, n137 = proto.readFixed64(p204, n137)
		else
			error("Unsupported wire type: " .. v2196)
		end
	end

	return v2193
end
function t312.jsonEncode(p205) -- line: 12064
	local t314 = {}

	if p205.oneof_prop ~= nil then
		if p205.oneof_prop.type == "string_prop" then
			t314.stringProp = p205.oneof_prop.value:jsonEncode()

			return t314
		end

		if p205.oneof_prop.type == "int32_prop" then
			t314.int32Prop = p205.oneof_prop.value:jsonEncode()
		end
	end

	return t314
end
function t312.jsonDecode(t315: {[any]: any}) -- line: 12078
	-- upvalues: t312 (copy), t1 (copy)
	local v2207 = t312.new()

	if t315.string_prop ~= nil then
		v2207.oneof_prop = {
			type = "string_prop",
			value = t1.StringProp.jsonDecode(t315.string_prop)
		}
	end

	if t315.stringProp ~= nil then
		v2207.oneof_prop = {
			type = "string_prop",
			value = t1.StringProp.jsonDecode(t315.stringProp)
		}
	end

	if t315.int32_prop ~= nil then
		v2207.oneof_prop = {
			type = "int32_prop",
			value = t1.Int32Prop.jsonDecode(t315.int32_prop)
		}
	end

	if t315.int32Prop ~= nil then
		v2207.oneof_prop = {
			type = "int32_prop",
			value = t1.Int32Prop.jsonDecode(t315.int32Prop)
		}
	end

	return v2207
end

t312.descriptor = {
	name = "IconSizeProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.IconSizeProp"
}
t1.IconSizeProp = t312
typeRegistry.default:register(t1.IconSizeProp)

local t316 = {}

t316.__index = t316

function t316.new(t317: {[any]: any}?) -- line: 12114
	-- upvalues: t316 (copy)
	return (setmetatable({
		kind = if t317 ~= nil and t317.kind ~= nil then t317.kind else nil
	}, t316))
end
function t316.encode(p206) -- line: 12120
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n138 = 0

	if p206.kind ~= nil then
		if p206.kind.type == "literal" then
			local v2212 = p206.kind.value:encode()
			local v2213, v2214 = proto.writeTag(buf, n138, 1, proto.wireTypes.lengthDelimited)

			buf, n138 = proto.writeBuffer(v2213, v2214, v2212, buffer.len(v2212))
		elseif p206.kind.type == "conditional" then
			local v2215 = p206.kind.value:encode()
			local v2216, v2217 = proto.writeTag(buf, n138, 2, proto.wireTypes.lengthDelimited)

			buf, n138 = proto.writeBuffer(v2216, v2217, v2215, buffer.len(v2215))
		end
	end

	local buf71 = buffer.create(n138)

	buffer.copy(buf71, 0, buf, 0, n138)

	return buf71
end
function t316.decode(p207: buffer) -- line: 12141
	-- upvalues: t316 (copy), proto (copy), t1 (copy)
	local v2220 = t316.new()
	local n139 = 0

	while n139 < buffer.len(p207) do
		local v2222, v2223

		v2222, v2223, n139 = proto.readTag(p207, n139)

		if v2223 == proto.wireTypes.varint then
			local v2224

			v2224, n139 = proto.readVarInt(p207, n139)
		elseif v2223 == proto.wireTypes.lengthDelimited then
			if v2222 == 1 then
				local v2225

				v2225, n139 = proto.readBuffer(p207, n139)
				v2220.kind = {
					type = "literal",
					value = t1.GradientProp_GradientData.decode(v2225)
				}
			elseif v2222 == 2 then
				local v2226

				v2226, n139 = proto.readBuffer(p207, n139)
				v2220.kind = {
					type = "conditional",
					value = t1.GradientProp_ConditionalOptions.decode(v2226)
				}
			else
				local v2227, v2228 = proto.readVarInt(p207, n139)

				n139 = v2228 + v2227
			end
		elseif v2223 == proto.wireTypes.i32 then
			local v2229

			v2229, n139 = proto.readFixed32(p207, n139)
		elseif v2223 == proto.wireTypes.i64 then
			local v2230

			v2230, n139 = proto.readFixed64(p207, n139)
		else
			error("Unsupported wire type: " .. v2223)
		end
	end

	return v2220
end
function t316.jsonEncode(p208) -- line: 12189
	local t318 = {}

	if p208.kind ~= nil then
		if p208.kind.type == "literal" then
			t318.literal = p208.kind.value:jsonEncode()

			return t318
		end

		if p208.kind.type == "conditional" then
			t318.conditional = p208.kind.value:jsonEncode()
		end
	end

	return t318
end
function t316.jsonDecode(t319: {[any]: any}) -- line: 12203
	-- upvalues: t316 (copy), t1 (copy)
	local v2234 = t316.new()

	if t319.literal ~= nil then
		v2234.kind = {
			type = "literal",
			value = t1.GradientProp_GradientData.jsonDecode(t319.literal)
		}
	end

	if t319.conditional ~= nil then
		v2234.kind = {
			type = "conditional",
			value = t1.GradientProp_ConditionalOptions.jsonDecode(t319.conditional)
		}
	end

	return v2234
end

t316.descriptor = {
	name = "GradientProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.GradientProp"
}
t1.GradientProp = t316
typeRegistry.default:register(t1.GradientProp)

local t320 = {}

t320.__index = t320

function t320.new(t321: {[any]: any}?) -- line: 12232
	-- upvalues: t320 (copy)
	return (setmetatable({
		condition = if t321 ~= nil and t321.condition ~= nil then t321.condition else nil,
		kind = if t321 ~= nil and t321.kind ~= nil then t321.kind else nil
	}, t320))
end
function t320.encode(p209) -- line: 12241
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n140 = 0

	if p209.condition ~= nil then
		local v2239 = p209.condition:encode()
		local v2240, v2241 = proto.writeTag(buf, n140, 1, proto.wireTypes.lengthDelimited)

		buf, n140 = proto.writeBuffer(v2240, v2241, v2239, buffer.len(v2239))
	end

	if p209.kind ~= nil and p209.kind.type == "literal" then
		local v2242 = p209.kind.value:encode()
		local v2243, v2244 = proto.writeTag(buf, n140, 2, proto.wireTypes.lengthDelimited)

		buf, n140 = proto.writeBuffer(v2243, v2244, v2242, buffer.len(v2242))
	end

	local buf72 = buffer.create(n140)

	buffer.copy(buf72, 0, buf, 0, n140)

	return buf72
end
function t320.decode(p210: buffer) -- line: 12264
	-- upvalues: t320 (copy), proto (copy), prop_condition (copy), t1 (copy)
	local v2247 = t320.new()
	local n141 = 0

	while n141 < buffer.len(p210) do
		local v2249, v2250

		v2249, v2250, n141 = proto.readTag(p210, n141)

		if v2250 == proto.wireTypes.varint then
			local v2251

			v2251, n141 = proto.readVarInt(p210, n141)
		elseif v2250 == proto.wireTypes.lengthDelimited then
			if v2249 == 1 then
				local v2252

				v2252, n141 = proto.readBuffer(p210, n141)
				v2247.condition = prop_condition.PropCondition.decode(v2252)
			elseif v2249 == 2 then
				local v2253

				v2253, n141 = proto.readBuffer(p210, n141)
				v2247.kind = {
					type = "literal",
					value = t1.GradientProp_GradientData.decode(v2253)
				}
			else
				local v2254, v2255 = proto.readVarInt(p210, n141)

				n141 = v2255 + v2254
			end
		elseif v2250 == proto.wireTypes.i32 then
			local v2256

			v2256, n141 = proto.readFixed32(p210, n141)
		elseif v2250 == proto.wireTypes.i64 then
			local v2257

			v2257, n141 = proto.readFixed64(p210, n141)
		else
			error("Unsupported wire type: " .. v2250)
		end
	end

	return v2247
end
function t320.jsonEncode(p211) -- line: 12312
	local t322 = {}

	if p211.condition ~= nil then
		t322.condition = p211.condition:jsonEncode()
	end

	if p211.kind ~= nil and p211.kind.type == "literal" then
		t322.literal = p211.kind.value:jsonEncode()
	end

	return t322
end
function t320.jsonDecode(t323: {[any]: any}) -- line: 12328
	-- upvalues: t320 (copy), prop_condition (copy), t1 (copy)
	local v2261 = t320.new()

	if t323.condition ~= nil then
		v2261.condition = prop_condition.PropCondition.jsonDecode(t323.condition)
	end

	if t323.literal ~= nil then
		v2261.kind = {
			type = "literal",
			value = t1.GradientProp_GradientData.jsonDecode(t323.literal)
		}
	end

	return v2261
end

t320.descriptor = {
	name = "GradientProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}
t1.GradientProp_ConditionalOption = t320
typeRegistry.default:register(t1.GradientProp_ConditionalOption)

local t324 = {}

t324.__index = t324

function t324.new(t325: {[any]: any}?) -- line: 12357
	-- upvalues: t324 (copy)
	return (setmetatable({
		options = if t325 ~= nil and t325.options ~= nil then t325.options else {}
	}, t324))
end
function t324.encode(p212) -- line: 12365
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n142 = 0

	if p212.options ~= nil and #p212.options > 0 then
		for _, v2267 in p212.options do
			local v2268 = v2267:encode()
			local v2269, v2270 = proto.writeTag(buf, n142, 1, proto.wireTypes.lengthDelimited)

			buf, n142 = proto.writeBuffer(v2269, v2270, v2268, buffer.len(v2268))
		end
	end

	local buf73 = buffer.create(n142)

	buffer.copy(buf73, 0, buf, 0, n142)

	return buf73
end
function t324.decode(p213: buffer) -- line: 12382
	-- upvalues: t324 (copy), proto (copy), t1 (copy)
	local v2273 = t324.new()
	local n143 = 0

	while n143 < buffer.len(p213) do
		local v2275, v2276

		v2275, v2276, n143 = proto.readTag(p213, n143)

		if v2276 == proto.wireTypes.varint then
			local v2277

			v2277, n143 = proto.readVarInt(p213, n143)
		elseif v2276 == proto.wireTypes.lengthDelimited then
			if v2275 == 1 then
				local v2278

				v2278, n143 = proto.readBuffer(p213, n143)
				table.insert(v2273.options, t1.GradientProp_ConditionalOption.decode(v2278))
			else
				local v2279, v2280 = proto.readVarInt(p213, n143)

				n143 = v2280 + v2279
			end
		elseif v2276 == proto.wireTypes.i32 then
			local v2281

			v2281, n143 = proto.readFixed32(p213, n143)
		elseif v2276 == proto.wireTypes.i64 then
			local v2282

			v2282, n143 = proto.readFixed64(p213, n143)
		else
			error("Unsupported wire type: " .. v2276)
		end
	end

	return v2273
end
function t324.jsonEncode(p214) -- line: 12425
	local t326 = {}

	if p214.options ~= nil and #p214.options > 0 then
		local t327 = {}

		for _, v2287 in p214.options do
			table.insert(t327, v2287:jsonEncode())
		end

		t326.options = t327
	end

	return t326
end
function t324.jsonDecode(t328: {[any]: any}) -- line: 12439
	-- upvalues: t324 (copy), t1 (copy)
	local v2289 = t324.new()

	if t328.options ~= nil then
		local t329 = {}

		for _, v2292 in t328.options do
			table.insert(t329, t1.GradientProp_ConditionalOption.jsonDecode(v2292))
		end

		v2289.options = t329
	end

	return v2289
end

t324.descriptor = {
	name = "GradientProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}
t1.GradientProp_ConditionalOptions = t324
typeRegistry.default:register(t1.GradientProp_ConditionalOptions)

local t330 = {}

t330.__index = t330

function t330.new(t331: {[any]: any}?) -- line: 12468
	-- upvalues: t330 (copy)
	return (setmetatable({
		start_color = if t331 ~= nil and t331.start_color ~= nil then t331.start_color else "",
		end_color = if t331 ~= nil and t331.end_color ~= nil then t331.end_color else "",
		start_opacity = if t331 ~= nil and t331.start_opacity ~= nil then t331.start_opacity else 0,
		end_opacity = if t331 ~= nil and t331.end_opacity ~= nil then t331.end_opacity else 0,
		degree = if t331 ~= nil and t331.degree ~= nil then t331.degree else 0,
		midpoint_percent = if t331 ~= nil and t331.midpoint_percent ~= nil then t331.midpoint_percent else 0
	}, t330))
end
function t330.encode(p215) -- line: 12481
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n144 = 0

	if p215.start_color ~= nil and p215.start_color ~= "" then
		local v2297, v2298 = proto.writeTag(buf, n144, 1, proto.wireTypes.lengthDelimited)

		buf, n144 = proto.writeString(v2297, v2298, p215.start_color)
	end

	if p215.end_color ~= nil and p215.end_color ~= "" then
		local v2299, v2300 = proto.writeTag(buf, n144, 2, proto.wireTypes.lengthDelimited)

		buf, n144 = proto.writeString(v2299, v2300, p215.end_color)
	end

	if p215.start_opacity ~= nil and p215.start_opacity ~= 0 then
		local v2301, v2302 = proto.writeTag(buf, n144, 3, proto.wireTypes.i32)

		buf, n144 = proto.writeFloat(v2301, v2302, p215.start_opacity)
	end

	if p215.end_opacity ~= nil and p215.end_opacity ~= 0 then
		local v2303, v2304 = proto.writeTag(buf, n144, 4, proto.wireTypes.i32)

		buf, n144 = proto.writeFloat(v2303, v2304, p215.end_opacity)
	end

	if p215.degree ~= nil and p215.degree ~= 0 then
		local v2305, v2306 = proto.writeTag(buf, n144, 5, proto.wireTypes.varint)

		buf, n144 = proto.writeVarInt(v2305, v2306, p215.degree)
	end

	if p215.midpoint_percent ~= nil and p215.midpoint_percent ~= 0 then
		local v2307, v2308 = proto.writeTag(buf, n144, 6, proto.wireTypes.i32)

		buf, n144 = proto.writeFloat(v2307, v2308, p215.midpoint_percent)
	end

	local buf74 = buffer.create(n144)

	buffer.copy(buf74, 0, buf, 0, n144)

	return buf74
end
function t330.decode(p216: buffer) -- line: 12520
	-- upvalues: t330 (copy), proto (copy)
	local v2311 = t330.new()
	local n145 = 0

	while n145 < buffer.len(p216) do
		local v2313, v2314

		v2313, v2314, n145 = proto.readTag(p216, n145)

		if v2314 == proto.wireTypes.varint then
			if v2313 == 5 then
				local v2315

				v2315, n145 = proto.readVarIntI32(p216, n145)
				v2311.degree = v2315
			else
				local v2316

				v2316, n145 = proto.readVarInt(p216, n145)
			end
		elseif v2314 == proto.wireTypes.lengthDelimited then
			if v2313 == 1 then
				local v2317

				v2317, n145 = proto.readBuffer(p216, n145)
				v2311.start_color = buffer.tostring(v2317)
			elseif v2313 == 2 then
				local v2318

				v2318, n145 = proto.readBuffer(p216, n145)
				v2311.end_color = buffer.tostring(v2318)
			else
				local v2319, v2320 = proto.readVarInt(p216, n145)

				n145 = v2320 + v2319
			end
		elseif v2314 == proto.wireTypes.i32 then
			if v2313 == 3 then
				local v2321

				v2321, n145 = proto.readFloat(p216, n145)
				v2311.start_opacity = v2321
			elseif v2313 == 4 then
				local v2322

				v2322, n145 = proto.readFloat(p216, n145)
				v2311.end_opacity = v2322
			elseif v2313 == 6 then
				local v2323

				v2323, n145 = proto.readFloat(p216, n145)
				v2311.midpoint_percent = v2323
			else
				local v2324

				v2324, n145 = proto.readFixed32(p216, n145)
			end
		elseif v2314 == proto.wireTypes.i64 then
			local v2325

			v2325, n145 = proto.readFixed64(p216, n145)
		else
			error("Unsupported wire type: " .. v2314)
		end
	end

	return v2311
end
function t330.jsonEncode(p217) -- line: 12588
	-- upvalues: proto (copy)
	local t332 = {}

	if p217.start_color ~= nil and p217.start_color ~= "" then
		t332.startColor = p217.start_color
	end

	if p217.end_color ~= nil and p217.end_color ~= "" then
		t332.endColor = p217.end_color
	end

	if p217.start_opacity ~= nil and p217.start_opacity ~= 0 then
		t332.startOpacity = proto.json.serializeNumber(p217.start_opacity)
	end

	if p217.end_opacity ~= nil and p217.end_opacity ~= 0 then
		t332.endOpacity = proto.json.serializeNumber(p217.end_opacity)
	end

	if p217.degree ~= nil and p217.degree ~= 0 then
		t332.degree = p217.degree
	end

	if p217.midpoint_percent ~= nil and p217.midpoint_percent ~= 0 then
		t332.midpointPercent = proto.json.serializeNumber(p217.midpoint_percent)
	end

	return t332
end
function t330.jsonDecode(t333: {[any]: any}) -- line: 12618
	-- upvalues: t330 (copy), proto (copy)
	local v2329 = t330.new()

	if t333.start_color ~= nil then
		v2329.start_color = t333.start_color
	end

	if t333.startColor ~= nil then
		v2329.start_color = t333.startColor
	end

	if t333.end_color ~= nil then
		v2329.end_color = t333.end_color
	end

	if t333.endColor ~= nil then
		v2329.end_color = t333.endColor
	end

	if t333.start_opacity ~= nil then
		v2329.start_opacity = proto.json.deserializeNumber(t333.start_opacity)
	end

	if t333.startOpacity ~= nil then
		v2329.start_opacity = proto.json.deserializeNumber(t333.startOpacity)
	end

	if t333.end_opacity ~= nil then
		v2329.end_opacity = proto.json.deserializeNumber(t333.end_opacity)
	end

	if t333.endOpacity ~= nil then
		v2329.end_opacity = proto.json.deserializeNumber(t333.endOpacity)
	end

	if t333.degree ~= nil then
		v2329.degree = t333.degree
	end

	if t333.midpoint_percent ~= nil then
		v2329.midpoint_percent = proto.json.deserializeNumber(t333.midpoint_percent)
	end

	if t333.midpointPercent ~= nil then
		v2329.midpoint_percent = proto.json.deserializeNumber(t333.midpointPercent)
	end

	return v2329
end

t330.descriptor = {
	name = "GradientProp_GradientData",
	fullName = "roblox.apppageplatform.shared.v1beta1.GradientData"
}
t1.GradientProp_GradientData = t330
typeRegistry.default:register(t1.GradientProp_GradientData)

local t334 = {}

t334.__index = t334

function t334.new(t335: {[any]: any}?) -- line: 12682
	-- upvalues: t334 (copy)
	return (setmetatable({
		kind = if t335 ~= nil and t335.kind ~= nil then t335.kind else nil
	}, t334))
end
function t334.encode(p218) -- line: 12688
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n146 = 0

	if p218.kind ~= nil then
		if p218.kind.type == "literal" then
			local v2334 = p218.kind.value:encode()
			local v2335, v2336 = proto.writeTag(buf, n146, 1, proto.wireTypes.lengthDelimited)

			buf, n146 = proto.writeBuffer(v2335, v2336, v2334, buffer.len(v2334))
		elseif p218.kind.type == "binding_path" then
			local v2337, v2338 = proto.writeTag(buf, n146, 2, proto.wireTypes.lengthDelimited)

			buf, n146 = proto.writeString(v2337, v2338, p218.kind.value)
		elseif p218.kind.type == "conditional" then
			local v2339 = p218.kind.value:encode()
			local v2340, v2341 = proto.writeTag(buf, n146, 3, proto.wireTypes.lengthDelimited)

			buf, n146 = proto.writeBuffer(v2340, v2341, v2339, buffer.len(v2339))
		end
	end

	local buf75 = buffer.create(n146)

	buffer.copy(buf75, 0, buf, 0, n146)

	return buf75
end
function t334.decode(p219: buffer) -- line: 12712
	-- upvalues: t334 (copy), proto (copy), t1 (copy)
	local v2344 = t334.new()
	local n147 = 0

	while n147 < buffer.len(p219) do
		local v2346, v2347

		v2346, v2347, n147 = proto.readTag(p219, n147)

		if v2347 == proto.wireTypes.varint then
			local v2348

			v2348, n147 = proto.readVarInt(p219, n147)
		elseif v2347 == proto.wireTypes.lengthDelimited then
			if v2346 == 1 then
				local v2349

				v2349, n147 = proto.readBuffer(p219, n147)
				v2344.kind = {
					type = "literal",
					value = t1.ArrayOfStructProp_ArrayOfStructs.decode(v2349)
				}
			elseif v2346 == 2 then
				local v2350

				v2350, n147 = proto.readBuffer(p219, n147)
				v2344.kind = {
					type = "binding_path",
					value = buffer.tostring(v2350)
				}
			elseif v2346 == 3 then
				local v2351

				v2351, n147 = proto.readBuffer(p219, n147)
				v2344.kind = {
					type = "conditional",
					value = t1.ArrayOfStructProp_ConditionalOptions.decode(v2351)
				}
			else
				local v2352, v2353 = proto.readVarInt(p219, n147)

				n147 = v2353 + v2352
			end
		elseif v2347 == proto.wireTypes.i32 then
			local v2354

			v2354, n147 = proto.readFixed32(p219, n147)
		elseif v2347 == proto.wireTypes.i64 then
			local v2355

			v2355, n147 = proto.readFixed64(p219, n147)
		else
			error("Unsupported wire type: " .. v2347)
		end
	end

	return v2344
end
function t334.jsonEncode(p220) -- line: 12766
	local t336 = {}

	if p220.kind ~= nil then
		if p220.kind.type == "literal" then
			t336.literal = p220.kind.value:jsonEncode()

			return t336
		end

		if p220.kind.type == "binding_path" then
			t336.bindingPath = p220.kind.value

			return t336
		end

		if p220.kind.type == "conditional" then
			t336.conditional = p220.kind.value:jsonEncode()
		end
	end

	return t336
end
function t334.jsonDecode(t337: {[any]: any}) -- line: 12782
	-- upvalues: t334 (copy), t1 (copy)
	local v2359 = t334.new()

	if t337.literal ~= nil then
		v2359.kind = {
			type = "literal",
			value = t1.ArrayOfStructProp_ArrayOfStructs.jsonDecode(t337.literal)
		}
	end

	if t337.binding_path ~= nil then
		v2359.kind = {
			type = "binding_path",
			value = t337.binding_path
		}
	end

	if t337.bindingPath ~= nil then
		v2359.kind = {
			type = "binding_path",
			value = t337.bindingPath
		}
	end

	if t337.conditional ~= nil then
		v2359.kind = {
			type = "conditional",
			value = t1.ArrayOfStructProp_ConditionalOptions.jsonDecode(t337.conditional)
		}
	end

	return v2359
end

t334.descriptor = {
	name = "ArrayOfStructProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.ArrayOfStructProp"
}
t1.ArrayOfStructProp = t334
typeRegistry.default:register(t1.ArrayOfStructProp)

local t338 = {}

t338.__index = t338

function t338.new(t339: {[any]: any}?) -- line: 12822
	-- upvalues: t338 (copy)
	return (setmetatable({
		condition = if t339 ~= nil and t339.condition ~= nil then t339.condition else nil,
		kind = if t339 ~= nil and t339.kind ~= nil then t339.kind else nil
	}, t338))
end
function t338.encode(p221) -- line: 12831
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n148 = 0

	if p221.condition ~= nil then
		local v2364 = p221.condition:encode()
		local v2365, v2366 = proto.writeTag(buf, n148, 1, proto.wireTypes.lengthDelimited)

		buf, n148 = proto.writeBuffer(v2365, v2366, v2364, buffer.len(v2364))
	end

	if p221.kind ~= nil then
		if p221.kind.type == "literal" then
			local v2367 = p221.kind.value:encode()
			local v2368, v2369 = proto.writeTag(buf, n148, 2, proto.wireTypes.lengthDelimited)

			buf, n148 = proto.writeBuffer(v2368, v2369, v2367, buffer.len(v2367))
		elseif p221.kind.type == "binding_path" then
			local v2370, v2371 = proto.writeTag(buf, n148, 3, proto.wireTypes.lengthDelimited)

			buf, n148 = proto.writeString(v2370, v2371, p221.kind.value)
		end
	end

	local buf76 = buffer.create(n148)

	buffer.copy(buf76, 0, buf, 0, n148)

	return buf76
end
function t338.decode(p222: buffer) -- line: 12857
	-- upvalues: t338 (copy), proto (copy), prop_condition (copy), t1 (copy)
	local v2374 = t338.new()
	local n149 = 0

	while n149 < buffer.len(p222) do
		local v2376, v2377

		v2376, v2377, n149 = proto.readTag(p222, n149)

		if v2377 == proto.wireTypes.varint then
			local v2378

			v2378, n149 = proto.readVarInt(p222, n149)
		elseif v2377 == proto.wireTypes.lengthDelimited then
			if v2376 == 1 then
				local v2379

				v2379, n149 = proto.readBuffer(p222, n149)
				v2374.condition = prop_condition.PropCondition.decode(v2379)
			elseif v2376 == 2 then
				local v2380

				v2380, n149 = proto.readBuffer(p222, n149)
				v2374.kind = {
					type = "literal",
					value = t1.ArrayOfStructProp_ArrayOfStructs.decode(v2380)
				}
			elseif v2376 == 3 then
				local v2381

				v2381, n149 = proto.readBuffer(p222, n149)
				v2374.kind = {
					type = "binding_path",
					value = buffer.tostring(v2381)
				}
			else
				local v2382, v2383 = proto.readVarInt(p222, n149)

				n149 = v2383 + v2382
			end
		elseif v2377 == proto.wireTypes.i32 then
			local v2384

			v2384, n149 = proto.readFixed32(p222, n149)
		elseif v2377 == proto.wireTypes.i64 then
			local v2385

			v2385, n149 = proto.readFixed64(p222, n149)
		else
			error("Unsupported wire type: " .. v2377)
		end
	end

	return v2374
end
function t338.jsonEncode(p223) -- line: 12910
	local t340 = {}

	if p223.condition ~= nil then
		t340.condition = p223.condition:jsonEncode()
	end

	if p223.kind ~= nil then
		if p223.kind.type == "literal" then
			t340.literal = p223.kind.value:jsonEncode()

			return t340
		end

		if p223.kind.type == "binding_path" then
			t340.bindingPath = p223.kind.value
		end
	end

	return t340
end
function t338.jsonDecode(t341: {[any]: any}) -- line: 12928
	-- upvalues: t338 (copy), prop_condition (copy), t1 (copy)
	local v2389 = t338.new()

	if t341.condition ~= nil then
		v2389.condition = prop_condition.PropCondition.jsonDecode(t341.condition)
	end

	if t341.literal ~= nil then
		v2389.kind = {
			type = "literal",
			value = t1.ArrayOfStructProp_ArrayOfStructs.jsonDecode(t341.literal)
		}
	end

	if t341.binding_path ~= nil then
		v2389.kind = {
			type = "binding_path",
			value = t341.binding_path
		}
	end

	if t341.bindingPath ~= nil then
		v2389.kind = {
			type = "binding_path",
			value = t341.bindingPath
		}
	end

	return v2389
end

t338.descriptor = {
	name = "ArrayOfStructProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}
t1.ArrayOfStructProp_ConditionalOption = t338
typeRegistry.default:register(t1.ArrayOfStructProp_ConditionalOption)

local t342 = {}

t342.__index = t342

function t342.new(t343: {[any]: any}?) -- line: 12968
	-- upvalues: t342 (copy)
	return (setmetatable({
		options = if t343 ~= nil and t343.options ~= nil then t343.options else {}
	}, t342))
end
function t342.encode(p224) -- line: 12976
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n150 = 0

	if p224.options ~= nil and #p224.options > 0 then
		for _, v2395 in p224.options do
			local v2396 = v2395:encode()
			local v2397, v2398 = proto.writeTag(buf, n150, 1, proto.wireTypes.lengthDelimited)

			buf, n150 = proto.writeBuffer(v2397, v2398, v2396, buffer.len(v2396))
		end
	end

	local buf77 = buffer.create(n150)

	buffer.copy(buf77, 0, buf, 0, n150)

	return buf77
end
function t342.decode(p225: buffer) -- line: 12993
	-- upvalues: t342 (copy), proto (copy), t1 (copy)
	local v2401 = t342.new()
	local n151 = 0

	while n151 < buffer.len(p225) do
		local v2403, v2404

		v2403, v2404, n151 = proto.readTag(p225, n151)

		if v2404 == proto.wireTypes.varint then
			local v2405

			v2405, n151 = proto.readVarInt(p225, n151)
		elseif v2404 == proto.wireTypes.lengthDelimited then
			if v2403 == 1 then
				local v2406

				v2406, n151 = proto.readBuffer(p225, n151)
				table.insert(v2401.options, t1.ArrayOfStructProp_ConditionalOption.decode(v2406))
			else
				local v2407, v2408 = proto.readVarInt(p225, n151)

				n151 = v2408 + v2407
			end
		elseif v2404 == proto.wireTypes.i32 then
			local v2409

			v2409, n151 = proto.readFixed32(p225, n151)
		elseif v2404 == proto.wireTypes.i64 then
			local v2410

			v2410, n151 = proto.readFixed64(p225, n151)
		else
			error("Unsupported wire type: " .. v2404)
		end
	end

	return v2401
end
function t342.jsonEncode(p226) -- line: 13036
	local t344 = {}

	if p226.options ~= nil and #p226.options > 0 then
		local t345 = {}

		for _, v2415 in p226.options do
			table.insert(t345, v2415:jsonEncode())
		end

		t344.options = t345
	end

	return t344
end
function t342.jsonDecode(t346: {[any]: any}) -- line: 13050
	-- upvalues: t342 (copy), t1 (copy)
	local v2417 = t342.new()

	if t346.options ~= nil then
		local t347 = {}

		for _, v2420 in t346.options do
			table.insert(t347, t1.ArrayOfStructProp_ConditionalOption.jsonDecode(v2420))
		end

		v2417.options = t347
	end

	return v2417
end

t342.descriptor = {
	name = "ArrayOfStructProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}
t1.ArrayOfStructProp_ConditionalOptions = t342
typeRegistry.default:register(t1.ArrayOfStructProp_ConditionalOptions)

local t348 = {}

t348.__index = t348

function t348.new(t349: {[any]: any}?) -- line: 13081
	-- upvalues: t348 (copy)
	return (setmetatable({
		entry = if t349 ~= nil and t349.entry ~= nil then t349.entry else {}
	}, t348))
end
function t348.encode(p227) -- line: 13089
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n152 = 0

	if p227.entry ~= nil and #p227.entry > 0 then
		for _, v2426 in p227.entry do
			local v2427 = v2426:encode()
			local v2428, v2429 = proto.writeTag(buf, n152, 1, proto.wireTypes.lengthDelimited)

			buf, n152 = proto.writeBuffer(v2428, v2429, v2427, buffer.len(v2427))
		end
	end

	local buf78 = buffer.create(n152)

	buffer.copy(buf78, 0, buf, 0, n152)

	return buf78
end
function t348.decode(p228: buffer) -- line: 13106
	-- upvalues: t348 (copy), proto (copy), struct (copy)
	local v2432 = t348.new()
	local n153 = 0

	while n153 < buffer.len(p228) do
		local v2434, v2435

		v2434, v2435, n153 = proto.readTag(p228, n153)

		if v2435 == proto.wireTypes.varint then
			local v2436

			v2436, n153 = proto.readVarInt(p228, n153)
		elseif v2435 == proto.wireTypes.lengthDelimited then
			if v2434 == 1 then
				local v2437

				v2437, n153 = proto.readBuffer(p228, n153)
				table.insert(v2432.entry, struct.Struct.decode(v2437))
			else
				local v2438, v2439 = proto.readVarInt(p228, n153)

				n153 = v2439 + v2438
			end
		elseif v2435 == proto.wireTypes.i32 then
			local v2440

			v2440, n153 = proto.readFixed32(p228, n153)
		elseif v2435 == proto.wireTypes.i64 then
			local v2441

			v2441, n153 = proto.readFixed64(p228, n153)
		else
			error("Unsupported wire type: " .. v2435)
		end
	end

	return v2432
end
function t348.jsonEncode(p229) -- line: 13149
	local t350 = {}

	if p229.entry ~= nil and #p229.entry > 0 then
		local t351 = {}

		for _, v2446 in p229.entry do
			table.insert(t351, v2446:jsonEncode())
		end

		t350.entry = t351
	end

	return t350
end
function t348.jsonDecode(t352: {[any]: any}) -- line: 13163
	-- upvalues: t348 (copy), struct (copy)
	local v2448 = t348.new()

	if t352.entry ~= nil then
		local t353 = {}

		for _, v2451 in t352.entry do
			table.insert(t353, struct.Struct.jsonDecode(v2451))
		end

		v2448.entry = t353
	end

	return v2448
end

t348.descriptor = {
	name = "ArrayOfStructProp_ArrayOfStructs",
	fullName = "roblox.apppageplatform.shared.v1beta1.ArrayOfStructs"
}
t1.ArrayOfStructProp_ArrayOfStructs = t348
typeRegistry.default:register(t1.ArrayOfStructProp_ArrayOfStructs)

local t354 = {}

t354.__index = t354

function t354.new(t355: {[any]: any}?) -- line: 13194
	-- upvalues: t354 (copy)
	return (setmetatable({
		kind = if t355 ~= nil and t355.kind ~= nil then t355.kind else nil
	}, t354))
end
function t354.encode(p230) -- line: 13200
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n154 = 0

	if p230.kind ~= nil then
		if p230.kind.type == "literal" then
			local v2456, v2457 = proto.writeTag(buf, n154, 1, proto.wireTypes.lengthDelimited)

			buf, n154 = proto.writeString(v2456, v2457, p230.kind.value)
		elseif p230.kind.type == "token" then
			local v2458, v2459 = proto.writeTag(buf, n154, 2, proto.wireTypes.lengthDelimited)

			buf, n154 = proto.writeString(v2458, v2459, p230.kind.value)
		elseif p230.kind.type == "conditional" then
			local v2460 = p230.kind.value:encode()
			local v2461, v2462 = proto.writeTag(buf, n154, 3, proto.wireTypes.lengthDelimited)

			buf, n154 = proto.writeBuffer(v2461, v2462, v2460, buffer.len(v2460))
		elseif p230.kind.type == "binding_path" then
			local v2463, v2464 = proto.writeTag(buf, n154, 4, proto.wireTypes.lengthDelimited)

			buf, n154 = proto.writeString(v2463, v2464, p230.kind.value)
		end
	end

	local buf79 = buffer.create(n154)

	buffer.copy(buf79, 0, buf, 0, n154)

	return buf79
end
function t354.decode(p231: buffer) -- line: 13226
	-- upvalues: t354 (copy), proto (copy), t1 (copy)
	local v2467 = t354.new()
	local n155 = 0

	while n155 < buffer.len(p231) do
		local v2469, v2470

		v2469, v2470, n155 = proto.readTag(p231, n155)

		if v2470 == proto.wireTypes.varint then
			local v2471

			v2471, n155 = proto.readVarInt(p231, n155)
		elseif v2470 == proto.wireTypes.lengthDelimited then
			if v2469 == 1 then
				local v2472

				v2472, n155 = proto.readBuffer(p231, n155)
				v2467.kind = {
					type = "literal",
					value = buffer.tostring(v2472)
				}
			elseif v2469 == 2 then
				local v2473

				v2473, n155 = proto.readBuffer(p231, n155)
				v2467.kind = {
					type = "token",
					value = buffer.tostring(v2473)
				}
			elseif v2469 == 3 then
				local v2474

				v2474, n155 = proto.readBuffer(p231, n155)
				v2467.kind = {
					type = "conditional",
					value = t1.UiScaledFloatProp_ConditionalOptions.decode(v2474)
				}
			elseif v2469 == 4 then
				local v2475

				v2475, n155 = proto.readBuffer(p231, n155)
				v2467.kind = {
					type = "binding_path",
					value = buffer.tostring(v2475)
				}
			else
				local v2476, v2477 = proto.readVarInt(p231, n155)

				n155 = v2477 + v2476
			end
		elseif v2470 == proto.wireTypes.i32 then
			local v2478

			v2478, n155 = proto.readFixed32(p231, n155)
		elseif v2470 == proto.wireTypes.i64 then
			local v2479

			v2479, n155 = proto.readFixed64(p231, n155)
		else
			error("Unsupported wire type: " .. v2470)
		end
	end

	return v2467
end
function t354.jsonEncode(p232) -- line: 13285
	local t356 = {}

	if p232.kind ~= nil then
		if p232.kind.type == "literal" then
			t356.literal = p232.kind.value

			return t356
		end

		if p232.kind.type == "token" then
			t356.token = p232.kind.value

			return t356
		end

		if p232.kind.type == "conditional" then
			t356.conditional = p232.kind.value:jsonEncode()

			return t356
		end

		if p232.kind.type == "binding_path" then
			t356.bindingPath = p232.kind.value
		end
	end

	return t356
end
function t354.jsonDecode(t357: {[any]: any}) -- line: 13303
	-- upvalues: t354 (copy), t1 (copy)
	local v2483 = t354.new()

	if t357.literal ~= nil then
		v2483.kind = {
			type = "literal",
			value = t357.literal
		}
	end

	if t357.token ~= nil then
		v2483.kind = {
			type = "token",
			value = t357.token
		}
	end

	if t357.conditional ~= nil then
		v2483.kind = {
			type = "conditional",
			value = t1.UiScaledFloatProp_ConditionalOptions.jsonDecode(t357.conditional)
		}
	end

	if t357.binding_path ~= nil then
		v2483.kind = {
			type = "binding_path",
			value = t357.binding_path
		}
	end

	if t357.bindingPath ~= nil then
		v2483.kind = {
			type = "binding_path",
			value = t357.bindingPath
		}
	end

	return v2483
end

t354.descriptor = {
	name = "UiScaledFloatProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.UiScaledFloatProp"
}
t1.UiScaledFloatProp = t354
typeRegistry.default:register(t1.UiScaledFloatProp)

local t358 = {}

t358.__index = t358

function t358.new(t359: {[any]: any}?) -- line: 13346
	-- upvalues: t358 (copy)
	return (setmetatable({
		condition = if t359 ~= nil and t359.condition ~= nil then t359.condition else nil,
		kind = if t359 ~= nil and t359.kind ~= nil then t359.kind else nil
	}, t358))
end
function t358.encode(p233) -- line: 13355
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n156 = 0

	if p233.condition ~= nil then
		local v2488 = p233.condition:encode()
		local v2489, v2490 = proto.writeTag(buf, n156, 1, proto.wireTypes.lengthDelimited)

		buf, n156 = proto.writeBuffer(v2489, v2490, v2488, buffer.len(v2488))
	end

	if p233.kind ~= nil then
		if p233.kind.type == "literal" then
			local v2491, v2492 = proto.writeTag(buf, n156, 2, proto.wireTypes.lengthDelimited)

			buf, n156 = proto.writeString(v2491, v2492, p233.kind.value)
		elseif p233.kind.type == "token" then
			local v2493, v2494 = proto.writeTag(buf, n156, 3, proto.wireTypes.lengthDelimited)

			buf, n156 = proto.writeString(v2493, v2494, p233.kind.value)
		elseif p233.kind.type == "binding_path" then
			local v2495, v2496 = proto.writeTag(buf, n156, 4, proto.wireTypes.lengthDelimited)

			buf, n156 = proto.writeString(v2495, v2496, p233.kind.value)
		end
	end

	local buf80 = buffer.create(n156)

	buffer.copy(buf80, 0, buf, 0, n156)

	return buf80
end
function t358.decode(p234: buffer) -- line: 13383
	-- upvalues: t358 (copy), proto (copy), prop_condition (copy)
	local v2499 = t358.new()
	local n157 = 0

	while n157 < buffer.len(p234) do
		local v2501, v2502

		v2501, v2502, n157 = proto.readTag(p234, n157)

		if v2502 == proto.wireTypes.varint then
			local v2503

			v2503, n157 = proto.readVarInt(p234, n157)
		elseif v2502 == proto.wireTypes.lengthDelimited then
			if v2501 == 1 then
				local v2504

				v2504, n157 = proto.readBuffer(p234, n157)
				v2499.condition = prop_condition.PropCondition.decode(v2504)
			elseif v2501 == 2 then
				local v2505

				v2505, n157 = proto.readBuffer(p234, n157)
				v2499.kind = {
					type = "literal",
					value = buffer.tostring(v2505)
				}
			elseif v2501 == 3 then
				local v2506

				v2506, n157 = proto.readBuffer(p234, n157)
				v2499.kind = {
					type = "token",
					value = buffer.tostring(v2506)
				}
			elseif v2501 == 4 then
				local v2507

				v2507, n157 = proto.readBuffer(p234, n157)
				v2499.kind = {
					type = "binding_path",
					value = buffer.tostring(v2507)
				}
			else
				local v2508, v2509 = proto.readVarInt(p234, n157)

				n157 = v2509 + v2508
			end
		elseif v2502 == proto.wireTypes.i32 then
			local v2510

			v2510, n157 = proto.readFixed32(p234, n157)
		elseif v2502 == proto.wireTypes.i64 then
			local v2511

			v2511, n157 = proto.readFixed64(p234, n157)
		else
			error("Unsupported wire type: " .. v2502)
		end
	end

	return v2499
end
function t358.jsonEncode(p235) -- line: 13441
	local t360 = {}

	if p235.condition ~= nil then
		t360.condition = p235.condition:jsonEncode()
	end

	if p235.kind ~= nil then
		if p235.kind.type == "literal" then
			t360.literal = p235.kind.value

			return t360
		end

		if p235.kind.type == "token" then
			t360.token = p235.kind.value

			return t360
		end

		if p235.kind.type == "binding_path" then
			t360.bindingPath = p235.kind.value
		end
	end

	return t360
end
function t358.jsonDecode(t361: {[any]: any}) -- line: 13461
	-- upvalues: t358 (copy), prop_condition (copy)
	local v2515 = t358.new()

	if t361.condition ~= nil then
		v2515.condition = prop_condition.PropCondition.jsonDecode(t361.condition)
	end

	if t361.literal ~= nil then
		v2515.kind = {
			type = "literal",
			value = t361.literal
		}
	end

	if t361.token ~= nil then
		v2515.kind = {
			type = "token",
			value = t361.token
		}
	end

	if t361.binding_path ~= nil then
		v2515.kind = {
			type = "binding_path",
			value = t361.binding_path
		}
	end

	if t361.bindingPath ~= nil then
		v2515.kind = {
			type = "binding_path",
			value = t361.bindingPath
		}
	end

	return v2515
end

t358.descriptor = {
	name = "UiScaledFloatProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}
t1.UiScaledFloatProp_ConditionalOption = t358
typeRegistry.default:register(t1.UiScaledFloatProp_ConditionalOption)

local t362 = {}

t362.__index = t362

function t362.new(t363: {[any]: any}?) -- line: 13504
	-- upvalues: t362 (copy)
	return (setmetatable({
		options = if t363 ~= nil and t363.options ~= nil then t363.options else {}
	}, t362))
end
function t362.encode(p236) -- line: 13512
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n158 = 0

	if p236.options ~= nil and #p236.options > 0 then
		for _, v2521 in p236.options do
			local v2522 = v2521:encode()
			local v2523, v2524 = proto.writeTag(buf, n158, 1, proto.wireTypes.lengthDelimited)

			buf, n158 = proto.writeBuffer(v2523, v2524, v2522, buffer.len(v2522))
		end
	end

	local buf81 = buffer.create(n158)

	buffer.copy(buf81, 0, buf, 0, n158)

	return buf81
end
function t362.decode(p237: buffer) -- line: 13529
	-- upvalues: t362 (copy), proto (copy), t1 (copy)
	local v2527 = t362.new()
	local n159 = 0

	while n159 < buffer.len(p237) do
		local v2529, v2530

		v2529, v2530, n159 = proto.readTag(p237, n159)

		if v2530 == proto.wireTypes.varint then
			local v2531

			v2531, n159 = proto.readVarInt(p237, n159)
		elseif v2530 == proto.wireTypes.lengthDelimited then
			if v2529 == 1 then
				local v2532

				v2532, n159 = proto.readBuffer(p237, n159)
				table.insert(v2527.options, t1.UiScaledFloatProp_ConditionalOption.decode(v2532))
			else
				local v2533, v2534 = proto.readVarInt(p237, n159)

				n159 = v2534 + v2533
			end
		elseif v2530 == proto.wireTypes.i32 then
			local v2535

			v2535, n159 = proto.readFixed32(p237, n159)
		elseif v2530 == proto.wireTypes.i64 then
			local v2536

			v2536, n159 = proto.readFixed64(p237, n159)
		else
			error("Unsupported wire type: " .. v2530)
		end
	end

	return v2527
end
function t362.jsonEncode(p238) -- line: 13572
	local t364 = {}

	if p238.options ~= nil and #p238.options > 0 then
		local t365 = {}

		for _, v2541 in p238.options do
			table.insert(t365, v2541:jsonEncode())
		end

		t364.options = t365
	end

	return t364
end
function t362.jsonDecode(t366: {[any]: any}) -- line: 13586
	-- upvalues: t362 (copy), t1 (copy)
	local v2543 = t362.new()

	if t366.options ~= nil then
		local t367 = {}

		for _, v2546 in t366.options do
			table.insert(t367, t1.UiScaledFloatProp_ConditionalOption.jsonDecode(v2546))
		end

		v2543.options = t367
	end

	return v2543
end

t362.descriptor = {
	name = "UiScaledFloatProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}
t1.UiScaledFloatProp_ConditionalOptions = t362
typeRegistry.default:register(t1.UiScaledFloatProp_ConditionalOptions)

local t368 = {}

t368.__index = t368

function t368.new(t369: {[any]: any}?) -- line: 13617
	-- upvalues: t368 (copy)
	return (setmetatable({
		kind = if t369 ~= nil and t369.kind ~= nil then t369.kind else nil
	}, t368))
end
function t368.encode(p239) -- line: 13623
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n160 = 0

	if p239.kind ~= nil then
		if p239.kind.type == "literal" then
			local v2551, v2552 = proto.writeTag(buf, n160, 1, proto.wireTypes.lengthDelimited)

			buf, n160 = proto.writeString(v2551, v2552, p239.kind.value)
		elseif p239.kind.type == "token" then
			local v2553, v2554 = proto.writeTag(buf, n160, 2, proto.wireTypes.lengthDelimited)

			buf, n160 = proto.writeString(v2553, v2554, p239.kind.value)
		elseif p239.kind.type == "conditional" then
			local v2555 = p239.kind.value:encode()
			local v2556, v2557 = proto.writeTag(buf, n160, 3, proto.wireTypes.lengthDelimited)

			buf, n160 = proto.writeBuffer(v2556, v2557, v2555, buffer.len(v2555))
		elseif p239.kind.type == "binding_path" then
			local v2558, v2559 = proto.writeTag(buf, n160, 4, proto.wireTypes.lengthDelimited)

			buf, n160 = proto.writeString(v2558, v2559, p239.kind.value)
		end
	end

	local buf82 = buffer.create(n160)

	buffer.copy(buf82, 0, buf, 0, n160)

	return buf82
end
function t368.decode(p240: buffer) -- line: 13649
	-- upvalues: t368 (copy), proto (copy), t1 (copy)
	local v2562 = t368.new()
	local n161 = 0

	while n161 < buffer.len(p240) do
		local v2564, v2565

		v2564, v2565, n161 = proto.readTag(p240, n161)

		if v2565 == proto.wireTypes.varint then
			local v2566

			v2566, n161 = proto.readVarInt(p240, n161)
		elseif v2565 == proto.wireTypes.lengthDelimited then
			if v2564 == 1 then
				local v2567

				v2567, n161 = proto.readBuffer(p240, n161)
				v2562.kind = {
					type = "literal",
					value = buffer.tostring(v2567)
				}
			elseif v2564 == 2 then
				local v2568

				v2568, n161 = proto.readBuffer(p240, n161)
				v2562.kind = {
					type = "token",
					value = buffer.tostring(v2568)
				}
			elseif v2564 == 3 then
				local v2569

				v2569, n161 = proto.readBuffer(p240, n161)
				v2562.kind = {
					type = "conditional",
					value = t1.UiScaledUDimProp_ConditionalOptions.decode(v2569)
				}
			elseif v2564 == 4 then
				local v2570

				v2570, n161 = proto.readBuffer(p240, n161)
				v2562.kind = {
					type = "binding_path",
					value = buffer.tostring(v2570)
				}
			else
				local v2571, v2572 = proto.readVarInt(p240, n161)

				n161 = v2572 + v2571
			end
		elseif v2565 == proto.wireTypes.i32 then
			local v2573

			v2573, n161 = proto.readFixed32(p240, n161)
		elseif v2565 == proto.wireTypes.i64 then
			local v2574

			v2574, n161 = proto.readFixed64(p240, n161)
		else
			error("Unsupported wire type: " .. v2565)
		end
	end

	return v2562
end
function t368.jsonEncode(p241) -- line: 13708
	local t370 = {}

	if p241.kind ~= nil then
		if p241.kind.type == "literal" then
			t370.literal = p241.kind.value

			return t370
		end

		if p241.kind.type == "token" then
			t370.token = p241.kind.value

			return t370
		end

		if p241.kind.type == "conditional" then
			t370.conditional = p241.kind.value:jsonEncode()

			return t370
		end

		if p241.kind.type == "binding_path" then
			t370.bindingPath = p241.kind.value
		end
	end

	return t370
end
function t368.jsonDecode(t371: {[any]: any}) -- line: 13726
	-- upvalues: t368 (copy), t1 (copy)
	local v2578 = t368.new()

	if t371.literal ~= nil then
		v2578.kind = {
			type = "literal",
			value = t371.literal
		}
	end

	if t371.token ~= nil then
		v2578.kind = {
			type = "token",
			value = t371.token
		}
	end

	if t371.conditional ~= nil then
		v2578.kind = {
			type = "conditional",
			value = t1.UiScaledUDimProp_ConditionalOptions.jsonDecode(t371.conditional)
		}
	end

	if t371.binding_path ~= nil then
		v2578.kind = {
			type = "binding_path",
			value = t371.binding_path
		}
	end

	if t371.bindingPath ~= nil then
		v2578.kind = {
			type = "binding_path",
			value = t371.bindingPath
		}
	end

	return v2578
end

t368.descriptor = {
	name = "UiScaledUDimProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.UiScaledUDimProp"
}
t1.UiScaledUDimProp = t368
typeRegistry.default:register(t1.UiScaledUDimProp)

local t372 = {}

t372.__index = t372

function t372.new(t373: {[any]: any}?) -- line: 13769
	-- upvalues: t372 (copy)
	return (setmetatable({
		condition = if t373 ~= nil and t373.condition ~= nil then t373.condition else nil,
		kind = if t373 ~= nil and t373.kind ~= nil then t373.kind else nil
	}, t372))
end
function t372.encode(p242) -- line: 13778
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n162 = 0

	if p242.condition ~= nil then
		local v2583 = p242.condition:encode()
		local v2584, v2585 = proto.writeTag(buf, n162, 1, proto.wireTypes.lengthDelimited)

		buf, n162 = proto.writeBuffer(v2584, v2585, v2583, buffer.len(v2583))
	end

	if p242.kind ~= nil then
		if p242.kind.type == "literal" then
			local v2586, v2587 = proto.writeTag(buf, n162, 2, proto.wireTypes.lengthDelimited)

			buf, n162 = proto.writeString(v2586, v2587, p242.kind.value)
		elseif p242.kind.type == "token" then
			local v2588, v2589 = proto.writeTag(buf, n162, 3, proto.wireTypes.lengthDelimited)

			buf, n162 = proto.writeString(v2588, v2589, p242.kind.value)
		elseif p242.kind.type == "binding_path" then
			local v2590, v2591 = proto.writeTag(buf, n162, 4, proto.wireTypes.lengthDelimited)

			buf, n162 = proto.writeString(v2590, v2591, p242.kind.value)
		end
	end

	local buf83 = buffer.create(n162)

	buffer.copy(buf83, 0, buf, 0, n162)

	return buf83
end
function t372.decode(p243: buffer) -- line: 13806
	-- upvalues: t372 (copy), proto (copy), prop_condition (copy)
	local v2594 = t372.new()
	local n163 = 0

	while n163 < buffer.len(p243) do
		local v2596, v2597

		v2596, v2597, n163 = proto.readTag(p243, n163)

		if v2597 == proto.wireTypes.varint then
			local v2598

			v2598, n163 = proto.readVarInt(p243, n163)
		elseif v2597 == proto.wireTypes.lengthDelimited then
			if v2596 == 1 then
				local v2599

				v2599, n163 = proto.readBuffer(p243, n163)
				v2594.condition = prop_condition.PropCondition.decode(v2599)
			elseif v2596 == 2 then
				local v2600

				v2600, n163 = proto.readBuffer(p243, n163)
				v2594.kind = {
					type = "literal",
					value = buffer.tostring(v2600)
				}
			elseif v2596 == 3 then
				local v2601

				v2601, n163 = proto.readBuffer(p243, n163)
				v2594.kind = {
					type = "token",
					value = buffer.tostring(v2601)
				}
			elseif v2596 == 4 then
				local v2602

				v2602, n163 = proto.readBuffer(p243, n163)
				v2594.kind = {
					type = "binding_path",
					value = buffer.tostring(v2602)
				}
			else
				local v2603, v2604 = proto.readVarInt(p243, n163)

				n163 = v2604 + v2603
			end
		elseif v2597 == proto.wireTypes.i32 then
			local v2605

			v2605, n163 = proto.readFixed32(p243, n163)
		elseif v2597 == proto.wireTypes.i64 then
			local v2606

			v2606, n163 = proto.readFixed64(p243, n163)
		else
			error("Unsupported wire type: " .. v2597)
		end
	end

	return v2594
end
function t372.jsonEncode(p244) -- line: 13864
	local t374 = {}

	if p244.condition ~= nil then
		t374.condition = p244.condition:jsonEncode()
	end

	if p244.kind ~= nil then
		if p244.kind.type == "literal" then
			t374.literal = p244.kind.value

			return t374
		end

		if p244.kind.type == "token" then
			t374.token = p244.kind.value

			return t374
		end

		if p244.kind.type == "binding_path" then
			t374.bindingPath = p244.kind.value
		end
	end

	return t374
end
function t372.jsonDecode(t375: {[any]: any}) -- line: 13884
	-- upvalues: t372 (copy), prop_condition (copy)
	local v2610 = t372.new()

	if t375.condition ~= nil then
		v2610.condition = prop_condition.PropCondition.jsonDecode(t375.condition)
	end

	if t375.literal ~= nil then
		v2610.kind = {
			type = "literal",
			value = t375.literal
		}
	end

	if t375.token ~= nil then
		v2610.kind = {
			type = "token",
			value = t375.token
		}
	end

	if t375.binding_path ~= nil then
		v2610.kind = {
			type = "binding_path",
			value = t375.binding_path
		}
	end

	if t375.bindingPath ~= nil then
		v2610.kind = {
			type = "binding_path",
			value = t375.bindingPath
		}
	end

	return v2610
end

t372.descriptor = {
	name = "UiScaledUDimProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}
t1.UiScaledUDimProp_ConditionalOption = t372
typeRegistry.default:register(t1.UiScaledUDimProp_ConditionalOption)

local t376 = {}

t376.__index = t376

function t376.new(t377: {[any]: any}?) -- line: 13927
	-- upvalues: t376 (copy)
	return (setmetatable({
		options = if t377 ~= nil and t377.options ~= nil then t377.options else {}
	}, t376))
end
function t376.encode(p245) -- line: 13935
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n164 = 0

	if p245.options ~= nil and #p245.options > 0 then
		for _, v2616 in p245.options do
			local v2617 = v2616:encode()
			local v2618, v2619 = proto.writeTag(buf, n164, 1, proto.wireTypes.lengthDelimited)

			buf, n164 = proto.writeBuffer(v2618, v2619, v2617, buffer.len(v2617))
		end
	end

	local buf84 = buffer.create(n164)

	buffer.copy(buf84, 0, buf, 0, n164)

	return buf84
end
function t376.decode(p246: buffer) -- line: 13952
	-- upvalues: t376 (copy), proto (copy), t1 (copy)
	local v2622 = t376.new()
	local n165 = 0

	while n165 < buffer.len(p246) do
		local v2624, v2625

		v2624, v2625, n165 = proto.readTag(p246, n165)

		if v2625 == proto.wireTypes.varint then
			local v2626

			v2626, n165 = proto.readVarInt(p246, n165)
		elseif v2625 == proto.wireTypes.lengthDelimited then
			if v2624 == 1 then
				local v2627

				v2627, n165 = proto.readBuffer(p246, n165)
				table.insert(v2622.options, t1.UiScaledUDimProp_ConditionalOption.decode(v2627))
			else
				local v2628, v2629 = proto.readVarInt(p246, n165)

				n165 = v2629 + v2628
			end
		elseif v2625 == proto.wireTypes.i32 then
			local v2630

			v2630, n165 = proto.readFixed32(p246, n165)
		elseif v2625 == proto.wireTypes.i64 then
			local v2631

			v2631, n165 = proto.readFixed64(p246, n165)
		else
			error("Unsupported wire type: " .. v2625)
		end
	end

	return v2622
end
function t376.jsonEncode(p247) -- line: 13995
	local t378 = {}

	if p247.options ~= nil and #p247.options > 0 then
		local t379 = {}

		for _, v2636 in p247.options do
			table.insert(t379, v2636:jsonEncode())
		end

		t378.options = t379
	end

	return t378
end
function t376.jsonDecode(t380: {[any]: any}) -- line: 14009
	-- upvalues: t376 (copy), t1 (copy)
	local v2638 = t376.new()

	if t380.options ~= nil then
		local t381 = {}

		for _, v2641 in t380.options do
			table.insert(t381, t1.UiScaledUDimProp_ConditionalOption.jsonDecode(v2641))
		end

		v2638.options = t381
	end

	return v2638
end

t376.descriptor = {
	name = "UiScaledUDimProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}
t1.UiScaledUDimProp_ConditionalOptions = t376
typeRegistry.default:register(t1.UiScaledUDimProp_ConditionalOptions)

local t382 = {}

t382.__index = t382

function t382.new(t383: {[any]: any}?) -- line: 14040
	-- upvalues: t382 (copy)
	return (setmetatable({
		kind = if t383 ~= nil and t383.kind ~= nil then t383.kind else nil
	}, t382))
end
function t382.encode(p248) -- line: 14046
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n166 = 0

	if p248.kind ~= nil then
		if p248.kind.type == "literal" then
			local v2646, v2647 = proto.writeTag(buf, n166, 1, proto.wireTypes.lengthDelimited)

			buf, n166 = proto.writeString(v2646, v2647, p248.kind.value)
		elseif p248.kind.type == "token" then
			local v2648, v2649 = proto.writeTag(buf, n166, 2, proto.wireTypes.lengthDelimited)

			buf, n166 = proto.writeString(v2648, v2649, p248.kind.value)
		elseif p248.kind.type == "conditional" then
			local v2650 = p248.kind.value:encode()
			local v2651, v2652 = proto.writeTag(buf, n166, 3, proto.wireTypes.lengthDelimited)

			buf, n166 = proto.writeBuffer(v2651, v2652, v2650, buffer.len(v2650))
		elseif p248.kind.type == "binding_path" then
			local v2653, v2654 = proto.writeTag(buf, n166, 4, proto.wireTypes.lengthDelimited)

			buf, n166 = proto.writeString(v2653, v2654, p248.kind.value)
		end
	end

	local buf85 = buffer.create(n166)

	buffer.copy(buf85, 0, buf, 0, n166)

	return buf85
end
function t382.decode(p249: buffer) -- line: 14072
	-- upvalues: t382 (copy), proto (copy), t1 (copy)
	local v2657 = t382.new()
	local n167 = 0

	while n167 < buffer.len(p249) do
		local v2659, v2660

		v2659, v2660, n167 = proto.readTag(p249, n167)

		if v2660 == proto.wireTypes.varint then
			local v2661

			v2661, n167 = proto.readVarInt(p249, n167)
		elseif v2660 == proto.wireTypes.lengthDelimited then
			if v2659 == 1 then
				local v2662

				v2662, n167 = proto.readBuffer(p249, n167)
				v2657.kind = {
					type = "literal",
					value = buffer.tostring(v2662)
				}
			elseif v2659 == 2 then
				local v2663

				v2663, n167 = proto.readBuffer(p249, n167)
				v2657.kind = {
					type = "token",
					value = buffer.tostring(v2663)
				}
			elseif v2659 == 3 then
				local v2664

				v2664, n167 = proto.readBuffer(p249, n167)
				v2657.kind = {
					type = "conditional",
					value = t1.UiScaledUDim2Prop_ConditionalOptions.decode(v2664)
				}
			elseif v2659 == 4 then
				local v2665

				v2665, n167 = proto.readBuffer(p249, n167)
				v2657.kind = {
					type = "binding_path",
					value = buffer.tostring(v2665)
				}
			else
				local v2666, v2667 = proto.readVarInt(p249, n167)

				n167 = v2667 + v2666
			end
		elseif v2660 == proto.wireTypes.i32 then
			local v2668

			v2668, n167 = proto.readFixed32(p249, n167)
		elseif v2660 == proto.wireTypes.i64 then
			local v2669

			v2669, n167 = proto.readFixed64(p249, n167)
		else
			error("Unsupported wire type: " .. v2660)
		end
	end

	return v2657
end
function t382.jsonEncode(p250) -- line: 14131
	local t384 = {}

	if p250.kind ~= nil then
		if p250.kind.type == "literal" then
			t384.literal = p250.kind.value

			return t384
		end

		if p250.kind.type == "token" then
			t384.token = p250.kind.value

			return t384
		end

		if p250.kind.type == "conditional" then
			t384.conditional = p250.kind.value:jsonEncode()

			return t384
		end

		if p250.kind.type == "binding_path" then
			t384.bindingPath = p250.kind.value
		end
	end

	return t384
end
function t382.jsonDecode(t385: {[any]: any}) -- line: 14149
	-- upvalues: t382 (copy), t1 (copy)
	local v2673 = t382.new()

	if t385.literal ~= nil then
		v2673.kind = {
			type = "literal",
			value = t385.literal
		}
	end

	if t385.token ~= nil then
		v2673.kind = {
			type = "token",
			value = t385.token
		}
	end

	if t385.conditional ~= nil then
		v2673.kind = {
			type = "conditional",
			value = t1.UiScaledUDim2Prop_ConditionalOptions.jsonDecode(t385.conditional)
		}
	end

	if t385.binding_path ~= nil then
		v2673.kind = {
			type = "binding_path",
			value = t385.binding_path
		}
	end

	if t385.bindingPath ~= nil then
		v2673.kind = {
			type = "binding_path",
			value = t385.bindingPath
		}
	end

	return v2673
end

t382.descriptor = {
	name = "UiScaledUDim2Prop",
	fullName = "roblox.apppageplatform.shared.v1beta1.UiScaledUDim2Prop"
}
t1.UiScaledUDim2Prop = t382
typeRegistry.default:register(t1.UiScaledUDim2Prop)

local t386 = {}

t386.__index = t386

function t386.new(t387: {[any]: any}?) -- line: 14192
	-- upvalues: t386 (copy)
	return (setmetatable({
		condition = if t387 ~= nil and t387.condition ~= nil then t387.condition else nil,
		kind = if t387 ~= nil and t387.kind ~= nil then t387.kind else nil
	}, t386))
end
function t386.encode(p251) -- line: 14201
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n168 = 0

	if p251.condition ~= nil then
		local v2678 = p251.condition:encode()
		local v2679, v2680 = proto.writeTag(buf, n168, 1, proto.wireTypes.lengthDelimited)

		buf, n168 = proto.writeBuffer(v2679, v2680, v2678, buffer.len(v2678))
	end

	if p251.kind ~= nil then
		if p251.kind.type == "literal" then
			local v2681, v2682 = proto.writeTag(buf, n168, 2, proto.wireTypes.lengthDelimited)

			buf, n168 = proto.writeString(v2681, v2682, p251.kind.value)
		elseif p251.kind.type == "token" then
			local v2683, v2684 = proto.writeTag(buf, n168, 3, proto.wireTypes.lengthDelimited)

			buf, n168 = proto.writeString(v2683, v2684, p251.kind.value)
		elseif p251.kind.type == "binding_path" then
			local v2685, v2686 = proto.writeTag(buf, n168, 4, proto.wireTypes.lengthDelimited)

			buf, n168 = proto.writeString(v2685, v2686, p251.kind.value)
		end
	end

	local buf86 = buffer.create(n168)

	buffer.copy(buf86, 0, buf, 0, n168)

	return buf86
end
function t386.decode(p252: buffer) -- line: 14229
	-- upvalues: t386 (copy), proto (copy), prop_condition (copy)
	local v2689 = t386.new()
	local n169 = 0

	while n169 < buffer.len(p252) do
		local v2691, v2692

		v2691, v2692, n169 = proto.readTag(p252, n169)

		if v2692 == proto.wireTypes.varint then
			local v2693

			v2693, n169 = proto.readVarInt(p252, n169)
		elseif v2692 == proto.wireTypes.lengthDelimited then
			if v2691 == 1 then
				local v2694

				v2694, n169 = proto.readBuffer(p252, n169)
				v2689.condition = prop_condition.PropCondition.decode(v2694)
			elseif v2691 == 2 then
				local v2695

				v2695, n169 = proto.readBuffer(p252, n169)
				v2689.kind = {
					type = "literal",
					value = buffer.tostring(v2695)
				}
			elseif v2691 == 3 then
				local v2696

				v2696, n169 = proto.readBuffer(p252, n169)
				v2689.kind = {
					type = "token",
					value = buffer.tostring(v2696)
				}
			elseif v2691 == 4 then
				local v2697

				v2697, n169 = proto.readBuffer(p252, n169)
				v2689.kind = {
					type = "binding_path",
					value = buffer.tostring(v2697)
				}
			else
				local v2698, v2699 = proto.readVarInt(p252, n169)

				n169 = v2699 + v2698
			end
		elseif v2692 == proto.wireTypes.i32 then
			local v2700

			v2700, n169 = proto.readFixed32(p252, n169)
		elseif v2692 == proto.wireTypes.i64 then
			local v2701

			v2701, n169 = proto.readFixed64(p252, n169)
		else
			error("Unsupported wire type: " .. v2692)
		end
	end

	return v2689
end
function t386.jsonEncode(p253) -- line: 14287
	local t388 = {}

	if p253.condition ~= nil then
		t388.condition = p253.condition:jsonEncode()
	end

	if p253.kind ~= nil then
		if p253.kind.type == "literal" then
			t388.literal = p253.kind.value

			return t388
		end

		if p253.kind.type == "token" then
			t388.token = p253.kind.value

			return t388
		end

		if p253.kind.type == "binding_path" then
			t388.bindingPath = p253.kind.value
		end
	end

	return t388
end
function t386.jsonDecode(t389: {[any]: any}) -- line: 14307
	-- upvalues: t386 (copy), prop_condition (copy)
	local v2705 = t386.new()

	if t389.condition ~= nil then
		v2705.condition = prop_condition.PropCondition.jsonDecode(t389.condition)
	end

	if t389.literal ~= nil then
		v2705.kind = {
			type = "literal",
			value = t389.literal
		}
	end

	if t389.token ~= nil then
		v2705.kind = {
			type = "token",
			value = t389.token
		}
	end

	if t389.binding_path ~= nil then
		v2705.kind = {
			type = "binding_path",
			value = t389.binding_path
		}
	end

	if t389.bindingPath ~= nil then
		v2705.kind = {
			type = "binding_path",
			value = t389.bindingPath
		}
	end

	return v2705
end

t386.descriptor = {
	name = "UiScaledUDim2Prop_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}
t1.UiScaledUDim2Prop_ConditionalOption = t386
typeRegistry.default:register(t1.UiScaledUDim2Prop_ConditionalOption)

local t390 = {}

t390.__index = t390

function t390.new(t391: {[any]: any}?) -- line: 14350
	-- upvalues: t390 (copy)
	return (setmetatable({
		options = if t391 ~= nil and t391.options ~= nil then t391.options else {}
	}, t390))
end
function t390.encode(p254) -- line: 14358
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n170 = 0

	if p254.options ~= nil and #p254.options > 0 then
		for _, v2711 in p254.options do
			local v2712 = v2711:encode()
			local v2713, v2714 = proto.writeTag(buf, n170, 1, proto.wireTypes.lengthDelimited)

			buf, n170 = proto.writeBuffer(v2713, v2714, v2712, buffer.len(v2712))
		end
	end

	local buf87 = buffer.create(n170)

	buffer.copy(buf87, 0, buf, 0, n170)

	return buf87
end
function t390.decode(p255: buffer) -- line: 14375
	-- upvalues: t390 (copy), proto (copy), t1 (copy)
	local v2717 = t390.new()
	local n171 = 0

	while n171 < buffer.len(p255) do
		local v2719, v2720

		v2719, v2720, n171 = proto.readTag(p255, n171)

		if v2720 == proto.wireTypes.varint then
			local v2721

			v2721, n171 = proto.readVarInt(p255, n171)
		elseif v2720 == proto.wireTypes.lengthDelimited then
			if v2719 == 1 then
				local v2722

				v2722, n171 = proto.readBuffer(p255, n171)
				table.insert(v2717.options, t1.UiScaledUDim2Prop_ConditionalOption.decode(v2722))
			else
				local v2723, v2724 = proto.readVarInt(p255, n171)

				n171 = v2724 + v2723
			end
		elseif v2720 == proto.wireTypes.i32 then
			local v2725

			v2725, n171 = proto.readFixed32(p255, n171)
		elseif v2720 == proto.wireTypes.i64 then
			local v2726

			v2726, n171 = proto.readFixed64(p255, n171)
		else
			error("Unsupported wire type: " .. v2720)
		end
	end

	return v2717
end
function t390.jsonEncode(p256) -- line: 14418
	local t392 = {}

	if p256.options ~= nil and #p256.options > 0 then
		local t393 = {}

		for _, v2731 in p256.options do
			table.insert(t393, v2731:jsonEncode())
		end

		t392.options = t393
	end

	return t392
end
function t390.jsonDecode(t394: {[any]: any}) -- line: 14432
	-- upvalues: t390 (copy), t1 (copy)
	local v2733 = t390.new()

	if t394.options ~= nil then
		local t395 = {}

		for _, v2736 in t394.options do
			table.insert(t395, t1.UiScaledUDim2Prop_ConditionalOption.jsonDecode(v2736))
		end

		v2733.options = t395
	end

	return v2733
end

t390.descriptor = {
	name = "UiScaledUDim2Prop_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}
t1.UiScaledUDim2Prop_ConditionalOptions = t390
typeRegistry.default:register(t1.UiScaledUDim2Prop_ConditionalOptions)

local t396 = {}

t396.__index = t396

function t396.new(t397: {[any]: any}?) -- line: 14463
	-- upvalues: t396 (copy)
	return (setmetatable({
		user_id = if t397 ~= nil and t397.user_id ~= nil then t397.user_id else nil,
		user_presence = if t397 ~= nil and t397.user_presence ~= nil then t397.user_presence else nil
	}, t396))
end
function t396.encode(p257) -- line: 14470
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n172 = 0

	if p257.user_id ~= nil then
		local v2741 = p257.user_id:encode()
		local v2742, v2743 = proto.writeTag(buf, n172, 1, proto.wireTypes.lengthDelimited)

		buf, n172 = proto.writeBuffer(v2742, v2743, v2741, buffer.len(v2741))
	end

	if p257.user_presence ~= nil then
		local v2744 = p257.user_presence:encode()
		local v2745, v2746 = proto.writeTag(buf, n172, 2, proto.wireTypes.lengthDelimited)

		buf, n172 = proto.writeBuffer(v2745, v2746, v2744, buffer.len(v2744))
	end

	local buf88 = buffer.create(n172)

	buffer.copy(buf88, 0, buf, 0, n172)

	return buf88
end
function t396.decode(p258: buffer) -- line: 14491
	-- upvalues: t396 (copy), proto (copy), t1 (copy)
	local v2749 = t396.new()
	local n173 = 0

	while n173 < buffer.len(p258) do
		local v2751, v2752

		v2751, v2752, n173 = proto.readTag(p258, n173)

		if v2752 == proto.wireTypes.varint then
			local v2753

			v2753, n173 = proto.readVarInt(p258, n173)
		elseif v2752 == proto.wireTypes.lengthDelimited then
			if v2751 == 1 then
				local v2754

				v2754, n173 = proto.readBuffer(p258, n173)
				v2749.user_id = t1.Int64Prop.decode(v2754)
			elseif v2751 == 2 then
				local v2755

				v2755, n173 = proto.readBuffer(p258, n173)
				v2749.user_presence = t1.StringProp.decode(v2755)
			else
				local v2756, v2757 = proto.readVarInt(p258, n173)

				n173 = v2757 + v2756
			end
		elseif v2752 == proto.wireTypes.i32 then
			local v2758

			v2758, n173 = proto.readFixed32(p258, n173)
		elseif v2752 == proto.wireTypes.i64 then
			local v2759

			v2759, n173 = proto.readFixed64(p258, n173)
		else
			error("Unsupported wire type: " .. v2752)
		end
	end

	return v2749
end
function t396.jsonEncode(p259) -- line: 14539
	local t398 = {}

	if p259.user_id ~= nil then
		t398.userId = p259.user_id:jsonEncode()
	end

	if p259.user_presence ~= nil then
		t398.userPresence = p259.user_presence:jsonEncode()
	end

	return t398
end
function t396.jsonDecode(t399: {[any]: any}) -- line: 14553
	-- upvalues: t396 (copy), t1 (copy)
	local v2763 = t396.new()

	if t399.user_id ~= nil then
		v2763.user_id = t1.Int64Prop.jsonDecode(t399.user_id)
	end

	if t399.userId ~= nil then
		v2763.user_id = t1.Int64Prop.jsonDecode(t399.userId)
	end

	if t399.user_presence ~= nil then
		v2763.user_presence = t1.StringProp.jsonDecode(t399.user_presence)
	end

	if t399.userPresence ~= nil then
		v2763.user_presence = t1.StringProp.jsonDecode(t399.userPresence)
	end

	return v2763
end

t396.descriptor = {
	name = "AvatarConfigProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.AvatarConfigProp"
}
t1.AvatarConfigProp = t396
typeRegistry.default:register(t1.AvatarConfigProp)

local t400 = {}

t400.__index = t400

function t400.new(t401: {[any]: any}?) -- line: 14589
	-- upvalues: t400 (copy)
	return (setmetatable({
		oneof_prop = if t401 ~= nil and t401.oneof_prop ~= nil then t401.oneof_prop else nil
	}, t400))
end
function t400.encode(p260) -- line: 14595
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n174 = 0

	if p260.oneof_prop ~= nil then
		if p260.oneof_prop.type == "user_id" then
			local v2768 = p260.oneof_prop.value:encode()
			local v2769, v2770 = proto.writeTag(buf, n174, 1, proto.wireTypes.lengthDelimited)

			buf, n174 = proto.writeBuffer(v2769, v2770, v2768, buffer.len(v2768))
		elseif p260.oneof_prop.type == "avatar_config" then
			local v2771 = p260.oneof_prop.value:encode()
			local v2772, v2773 = proto.writeTag(buf, n174, 2, proto.wireTypes.lengthDelimited)

			buf, n174 = proto.writeBuffer(v2772, v2773, v2771, buffer.len(v2771))
		end
	end

	local buf89 = buffer.create(n174)

	buffer.copy(buf89, 0, buf, 0, n174)

	return buf89
end
function t400.decode(p261: buffer) -- line: 14616
	-- upvalues: t400 (copy), proto (copy), t1 (copy)
	local v2776 = t400.new()
	local n175 = 0

	while n175 < buffer.len(p261) do
		local v2778, v2779

		v2778, v2779, n175 = proto.readTag(p261, n175)

		if v2779 == proto.wireTypes.varint then
			local v2780

			v2780, n175 = proto.readVarInt(p261, n175)
		elseif v2779 == proto.wireTypes.lengthDelimited then
			if v2778 == 1 then
				local v2781

				v2781, n175 = proto.readBuffer(p261, n175)
				v2776.oneof_prop = {
					type = "user_id",
					value = t1.Int64Prop.decode(v2781)
				}
			elseif v2778 == 2 then
				local v2782

				v2782, n175 = proto.readBuffer(p261, n175)
				v2776.oneof_prop = {
					type = "avatar_config",
					value = t1.AvatarConfigProp.decode(v2782)
				}
			else
				local v2783, v2784 = proto.readVarInt(p261, n175)

				n175 = v2784 + v2783
			end
		elseif v2779 == proto.wireTypes.i32 then
			local v2785

			v2785, n175 = proto.readFixed32(p261, n175)
		elseif v2779 == proto.wireTypes.i64 then
			local v2786

			v2786, n175 = proto.readFixed64(p261, n175)
		else
			error("Unsupported wire type: " .. v2779)
		end
	end

	return v2776
end
function t400.jsonEncode(p262) -- line: 14664
	local t402 = {}

	if p262.oneof_prop ~= nil then
		if p262.oneof_prop.type == "user_id" then
			t402.userId = p262.oneof_prop.value:jsonEncode()

			return t402
		end

		if p262.oneof_prop.type == "avatar_config" then
			t402.avatarConfig = p262.oneof_prop.value:jsonEncode()
		end
	end

	return t402
end
function t400.jsonDecode(t403: {[any]: any}) -- line: 14678
	-- upvalues: t400 (copy), t1 (copy)
	local v2790 = t400.new()

	if t403.user_id ~= nil then
		v2790.oneof_prop = {
			type = "user_id",
			value = t1.Int64Prop.jsonDecode(t403.user_id)
		}
	end

	if t403.userId ~= nil then
		v2790.oneof_prop = {
			type = "user_id",
			value = t1.Int64Prop.jsonDecode(t403.userId)
		}
	end

	if t403.avatar_config ~= nil then
		v2790.oneof_prop = {
			type = "avatar_config",
			value = t1.AvatarConfigProp.jsonDecode(t403.avatar_config)
		}
	end

	if t403.avatarConfig ~= nil then
		v2790.oneof_prop = {
			type = "avatar_config",
			value = t1.AvatarConfigProp.jsonDecode(t403.avatarConfig)
		}
	end

	return v2790
end

t400.descriptor = {
	name = "AvatarProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.AvatarProp"
}
t1.AvatarProp = t400
typeRegistry.default:register(t1.AvatarProp)

local t404 = {}

t404.__index = t404

function t404.new(t405: {[any]: any}?) -- line: 14716
	-- upvalues: t404 (copy)
	return (setmetatable({
		kind = if t405 ~= nil and t405.kind ~= nil then t405.kind else nil
	}, t404))
end
function t404.encode(p263) -- line: 14722
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n176 = 0

	if p263.kind ~= nil then
		if p263.kind.type == "literal" then
			local v2795 = p263.kind.value:encode()
			local v2796, v2797 = proto.writeTag(buf, n176, 1, proto.wireTypes.lengthDelimited)

			buf, n176 = proto.writeBuffer(v2796, v2797, v2795, buffer.len(v2795))
		elseif p263.kind.type == "binding_path" then
			local v2798, v2799 = proto.writeTag(buf, n176, 2, proto.wireTypes.lengthDelimited)

			buf, n176 = proto.writeString(v2798, v2799, p263.kind.value)
		elseif p263.kind.type == "conditional" then
			local v2800 = p263.kind.value:encode()
			local v2801, v2802 = proto.writeTag(buf, n176, 3, proto.wireTypes.lengthDelimited)

			buf, n176 = proto.writeBuffer(v2801, v2802, v2800, buffer.len(v2800))
		elseif p263.kind.type == "array_map" then
			local v2803 = p263.kind.value:encode()
			local v2804, v2805 = proto.writeTag(buf, n176, 4, proto.wireTypes.lengthDelimited)

			buf, n176 = proto.writeBuffer(v2804, v2805, v2803, buffer.len(v2803))
		end
	end

	local buf90 = buffer.create(n176)

	buffer.copy(buf90, 0, buf, 0, n176)

	return buf90
end
function t404.decode(p264: buffer) -- line: 14750
	-- upvalues: t404 (copy), proto (copy), t1 (copy)
	local v2808 = t404.new()
	local n177 = 0

	while n177 < buffer.len(p264) do
		local v2810, v2811

		v2810, v2811, n177 = proto.readTag(p264, n177)

		if v2811 == proto.wireTypes.varint then
			local v2812

			v2812, n177 = proto.readVarInt(p264, n177)
		elseif v2811 == proto.wireTypes.lengthDelimited then
			if v2810 == 1 then
				local v2813

				v2813, n177 = proto.readBuffer(p264, n177)
				v2808.kind = {
					type = "literal",
					value = t1.ArrayOfAvatarProp_ArrayOfAvatars.decode(v2813)
				}
			elseif v2810 == 2 then
				local v2814

				v2814, n177 = proto.readBuffer(p264, n177)
				v2808.kind = {
					type = "binding_path",
					value = buffer.tostring(v2814)
				}
			elseif v2810 == 3 then
				local v2815

				v2815, n177 = proto.readBuffer(p264, n177)
				v2808.kind = {
					type = "conditional",
					value = t1.ArrayOfAvatarProp_ConditionalOptions.decode(v2815)
				}
			elseif v2810 == 4 then
				local v2816

				v2816, n177 = proto.readBuffer(p264, n177)
				v2808.kind = {
					type = "array_map",
					value = t1.ArrayOfAvatarProp_ArrayMap.decode(v2816)
				}
			else
				local v2817, v2818 = proto.readVarInt(p264, n177)

				n177 = v2818 + v2817
			end
		elseif v2811 == proto.wireTypes.i32 then
			local v2819

			v2819, n177 = proto.readFixed32(p264, n177)
		elseif v2811 == proto.wireTypes.i64 then
			local v2820

			v2820, n177 = proto.readFixed64(p264, n177)
		else
			error("Unsupported wire type: " .. v2811)
		end
	end

	return v2808
end
function t404.jsonEncode(p265) -- line: 14809
	local t406 = {}

	if p265.kind ~= nil then
		if p265.kind.type == "literal" then
			t406.literal = p265.kind.value:jsonEncode()

			return t406
		end

		if p265.kind.type == "binding_path" then
			t406.bindingPath = p265.kind.value

			return t406
		end

		if p265.kind.type == "conditional" then
			t406.conditional = p265.kind.value:jsonEncode()

			return t406
		end

		if p265.kind.type == "array_map" then
			t406.arrayMap = p265.kind.value:jsonEncode()
		end
	end

	return t406
end
function t404.jsonDecode(t407: {[any]: any}) -- line: 14827
	-- upvalues: t404 (copy), t1 (copy)
	local v2824 = t404.new()

	if t407.literal ~= nil then
		v2824.kind = {
			type = "literal",
			value = t1.ArrayOfAvatarProp_ArrayOfAvatars.jsonDecode(t407.literal)
		}
	end

	if t407.binding_path ~= nil then
		v2824.kind = {
			type = "binding_path",
			value = t407.binding_path
		}
	end

	if t407.bindingPath ~= nil then
		v2824.kind = {
			type = "binding_path",
			value = t407.bindingPath
		}
	end

	if t407.conditional ~= nil then
		v2824.kind = {
			type = "conditional",
			value = t1.ArrayOfAvatarProp_ConditionalOptions.jsonDecode(t407.conditional)
		}
	end

	if t407.array_map ~= nil then
		v2824.kind = {
			type = "array_map",
			value = t1.ArrayOfAvatarProp_ArrayMap.jsonDecode(t407.array_map)
		}
	end

	if t407.arrayMap ~= nil then
		v2824.kind = {
			type = "array_map",
			value = t1.ArrayOfAvatarProp_ArrayMap.jsonDecode(t407.arrayMap)
		}
	end

	return v2824
end

t404.descriptor = {
	name = "ArrayOfAvatarProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.ArrayOfAvatarProp"
}
t1.ArrayOfAvatarProp = t404
typeRegistry.default:register(t1.ArrayOfAvatarProp)

local t408 = {}

t408.__index = t408

function t408.new(t409: {[any]: any}?) -- line: 14875
	-- upvalues: t408 (copy)
	return (setmetatable({
		condition = if t409 ~= nil and t409.condition ~= nil then t409.condition else nil,
		kind = if t409 ~= nil and t409.kind ~= nil then t409.kind else nil
	}, t408))
end
function t408.encode(p266) -- line: 14884
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n178 = 0

	if p266.condition ~= nil then
		local v2829 = p266.condition:encode()
		local v2830, v2831 = proto.writeTag(buf, n178, 1, proto.wireTypes.lengthDelimited)

		buf, n178 = proto.writeBuffer(v2830, v2831, v2829, buffer.len(v2829))
	end

	if p266.kind ~= nil then
		if p266.kind.type == "literal" then
			local v2832 = p266.kind.value:encode()
			local v2833, v2834 = proto.writeTag(buf, n178, 2, proto.wireTypes.lengthDelimited)

			buf, n178 = proto.writeBuffer(v2833, v2834, v2832, buffer.len(v2832))
		elseif p266.kind.type == "binding_path" then
			local v2835, v2836 = proto.writeTag(buf, n178, 3, proto.wireTypes.lengthDelimited)

			buf, n178 = proto.writeString(v2835, v2836, p266.kind.value)
		end
	end

	local buf91 = buffer.create(n178)

	buffer.copy(buf91, 0, buf, 0, n178)

	return buf91
end
function t408.decode(p267: buffer) -- line: 14910
	-- upvalues: t408 (copy), proto (copy), prop_condition (copy), t1 (copy)
	local v2839 = t408.new()
	local n179 = 0

	while n179 < buffer.len(p267) do
		local v2841, v2842

		v2841, v2842, n179 = proto.readTag(p267, n179)

		if v2842 == proto.wireTypes.varint then
			local v2843

			v2843, n179 = proto.readVarInt(p267, n179)
		elseif v2842 == proto.wireTypes.lengthDelimited then
			if v2841 == 1 then
				local v2844

				v2844, n179 = proto.readBuffer(p267, n179)
				v2839.condition = prop_condition.PropCondition.decode(v2844)
			elseif v2841 == 2 then
				local v2845

				v2845, n179 = proto.readBuffer(p267, n179)
				v2839.kind = {
					type = "literal",
					value = t1.ArrayOfAvatarProp_ArrayOfAvatars.decode(v2845)
				}
			elseif v2841 == 3 then
				local v2846

				v2846, n179 = proto.readBuffer(p267, n179)
				v2839.kind = {
					type = "binding_path",
					value = buffer.tostring(v2846)
				}
			else
				local v2847, v2848 = proto.readVarInt(p267, n179)

				n179 = v2848 + v2847
			end
		elseif v2842 == proto.wireTypes.i32 then
			local v2849

			v2849, n179 = proto.readFixed32(p267, n179)
		elseif v2842 == proto.wireTypes.i64 then
			local v2850

			v2850, n179 = proto.readFixed64(p267, n179)
		else
			error("Unsupported wire type: " .. v2842)
		end
	end

	return v2839
end
function t408.jsonEncode(p268) -- line: 14963
	local t410 = {}

	if p268.condition ~= nil then
		t410.condition = p268.condition:jsonEncode()
	end

	if p268.kind ~= nil then
		if p268.kind.type == "literal" then
			t410.literal = p268.kind.value:jsonEncode()

			return t410
		end

		if p268.kind.type == "binding_path" then
			t410.bindingPath = p268.kind.value
		end
	end

	return t410
end
function t408.jsonDecode(t411: {[any]: any}) -- line: 14981
	-- upvalues: t408 (copy), prop_condition (copy), t1 (copy)
	local v2854 = t408.new()

	if t411.condition ~= nil then
		v2854.condition = prop_condition.PropCondition.jsonDecode(t411.condition)
	end

	if t411.literal ~= nil then
		v2854.kind = {
			type = "literal",
			value = t1.ArrayOfAvatarProp_ArrayOfAvatars.jsonDecode(t411.literal)
		}
	end

	if t411.binding_path ~= nil then
		v2854.kind = {
			type = "binding_path",
			value = t411.binding_path
		}
	end

	if t411.bindingPath ~= nil then
		v2854.kind = {
			type = "binding_path",
			value = t411.bindingPath
		}
	end

	return v2854
end

t408.descriptor = {
	name = "ArrayOfAvatarProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}
t1.ArrayOfAvatarProp_ConditionalOption = t408
typeRegistry.default:register(t1.ArrayOfAvatarProp_ConditionalOption)

local t412 = {}

t412.__index = t412

function t412.new(t413: {[any]: any}?) -- line: 15021
	-- upvalues: t412 (copy)
	return (setmetatable({
		options = if t413 ~= nil and t413.options ~= nil then t413.options else {}
	}, t412))
end
function t412.encode(p269) -- line: 15029
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n180 = 0

	if p269.options ~= nil and #p269.options > 0 then
		for _, v2860 in p269.options do
			local v2861 = v2860:encode()
			local v2862, v2863 = proto.writeTag(buf, n180, 1, proto.wireTypes.lengthDelimited)

			buf, n180 = proto.writeBuffer(v2862, v2863, v2861, buffer.len(v2861))
		end
	end

	local buf92 = buffer.create(n180)

	buffer.copy(buf92, 0, buf, 0, n180)

	return buf92
end
function t412.decode(p270: buffer) -- line: 15046
	-- upvalues: t412 (copy), proto (copy), t1 (copy)
	local v2866 = t412.new()
	local n181 = 0

	while n181 < buffer.len(p270) do
		local v2868, v2869

		v2868, v2869, n181 = proto.readTag(p270, n181)

		if v2869 == proto.wireTypes.varint then
			local v2870

			v2870, n181 = proto.readVarInt(p270, n181)
		elseif v2869 == proto.wireTypes.lengthDelimited then
			if v2868 == 1 then
				local v2871

				v2871, n181 = proto.readBuffer(p270, n181)
				table.insert(v2866.options, t1.ArrayOfAvatarProp_ConditionalOption.decode(v2871))
			else
				local v2872, v2873 = proto.readVarInt(p270, n181)

				n181 = v2873 + v2872
			end
		elseif v2869 == proto.wireTypes.i32 then
			local v2874

			v2874, n181 = proto.readFixed32(p270, n181)
		elseif v2869 == proto.wireTypes.i64 then
			local v2875

			v2875, n181 = proto.readFixed64(p270, n181)
		else
			error("Unsupported wire type: " .. v2869)
		end
	end

	return v2866
end
function t412.jsonEncode(p271) -- line: 15089
	local t414 = {}

	if p271.options ~= nil and #p271.options > 0 then
		local t415 = {}

		for _, v2880 in p271.options do
			table.insert(t415, v2880:jsonEncode())
		end

		t414.options = t415
	end

	return t414
end
function t412.jsonDecode(t416: {[any]: any}) -- line: 15103
	-- upvalues: t412 (copy), t1 (copy)
	local v2882 = t412.new()

	if t416.options ~= nil then
		local t417 = {}

		for _, v2885 in t416.options do
			table.insert(t417, t1.ArrayOfAvatarProp_ConditionalOption.jsonDecode(v2885))
		end

		v2882.options = t417
	end

	return v2882
end

t412.descriptor = {
	name = "ArrayOfAvatarProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}
t1.ArrayOfAvatarProp_ConditionalOptions = t412
typeRegistry.default:register(t1.ArrayOfAvatarProp_ConditionalOptions)

local t418 = {}

t418.__index = t418

function t418.new(t419: {[any]: any}?) -- line: 15134
	-- upvalues: t418 (copy)
	return (setmetatable({
		array = if t419 ~= nil and t419.array ~= nil then t419.array else {}
	}, t418))
end
function t418.encode(p272) -- line: 15142
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n182 = 0

	if p272.array ~= nil and #p272.array > 0 then
		for _, v2891 in p272.array do
			local v2892 = v2891:encode()
			local v2893, v2894 = proto.writeTag(buf, n182, 1, proto.wireTypes.lengthDelimited)

			buf, n182 = proto.writeBuffer(v2893, v2894, v2892, buffer.len(v2892))
		end
	end

	local buf93 = buffer.create(n182)

	buffer.copy(buf93, 0, buf, 0, n182)

	return buf93
end
function t418.decode(p273: buffer) -- line: 15159
	-- upvalues: t418 (copy), proto (copy), t1 (copy)
	local v2897 = t418.new()
	local n183 = 0

	while n183 < buffer.len(p273) do
		local v2899, v2900

		v2899, v2900, n183 = proto.readTag(p273, n183)

		if v2900 == proto.wireTypes.varint then
			local v2901

			v2901, n183 = proto.readVarInt(p273, n183)
		elseif v2900 == proto.wireTypes.lengthDelimited then
			if v2899 == 1 then
				local v2902

				v2902, n183 = proto.readBuffer(p273, n183)
				table.insert(v2897.array, t1.AvatarProp.decode(v2902))
			else
				local v2903, v2904 = proto.readVarInt(p273, n183)

				n183 = v2904 + v2903
			end
		elseif v2900 == proto.wireTypes.i32 then
			local v2905

			v2905, n183 = proto.readFixed32(p273, n183)
		elseif v2900 == proto.wireTypes.i64 then
			local v2906

			v2906, n183 = proto.readFixed64(p273, n183)
		else
			error("Unsupported wire type: " .. v2900)
		end
	end

	return v2897
end
function t418.jsonEncode(p274) -- line: 15202
	local t420 = {}

	if p274.array ~= nil and #p274.array > 0 then
		local t421 = {}

		for _, v2911 in p274.array do
			table.insert(t421, v2911:jsonEncode())
		end

		t420.array = t421
	end

	return t420
end
function t418.jsonDecode(t422: {[any]: any}) -- line: 15216
	-- upvalues: t418 (copy), t1 (copy)
	local v2913 = t418.new()

	if t422.array ~= nil then
		local t423 = {}

		for _, v2916 in t422.array do
			table.insert(t423, t1.AvatarProp.jsonDecode(v2916))
		end

		v2913.array = t423
	end

	return v2913
end

t418.descriptor = {
	name = "ArrayOfAvatarProp_ArrayOfAvatars",
	fullName = "roblox.apppageplatform.shared.v1beta1.ArrayOfAvatars"
}
t1.ArrayOfAvatarProp_ArrayOfAvatars = t418
typeRegistry.default:register(t1.ArrayOfAvatarProp_ArrayOfAvatars)

local t424 = {}

t424.__index = t424

function t424.new(t425: {[any]: any}?) -- line: 15247
	-- upvalues: t424 (copy)
	return (setmetatable({
		kind = if t425 ~= nil and t425.kind ~= nil then t425.kind else nil,
		item_hydration_specs = if t425 ~= nil and t425.item_hydration_specs ~= nil then t425.item_hydration_specs else {},
		field_map = if t425 ~= nil and t425.field_map ~= nil then t425.field_map else nil
	}, t424))
end
function t424.encode(p275) -- line: 15259
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n184 = 0

	if p275.kind ~= nil and p275.kind.type == "binding_path" then
		local v2921, v2922 = proto.writeTag(buf, n184, 1, proto.wireTypes.lengthDelimited)

		buf, n184 = proto.writeString(v2921, v2922, p275.kind.value)
	end

	if p275.item_hydration_specs ~= nil and #p275.item_hydration_specs > 0 then
		for _, v2924 in p275.item_hydration_specs do
			local v2925 = v2924:encode()
			local v2926, v2927 = proto.writeTag(buf, n184, 3, proto.wireTypes.lengthDelimited)

			buf, n184 = proto.writeBuffer(v2926, v2927, v2925, buffer.len(v2925))
		end
	end

	if p275.field_map ~= nil then
		local v2928 = p275.field_map:encode()
		local v2929, v2930 = proto.writeTag(buf, n184, 4, proto.wireTypes.lengthDelimited)

		buf, n184 = proto.writeBuffer(v2929, v2930, v2928, buffer.len(v2928))
	end

	local buf94 = buffer.create(n184)

	buffer.copy(buf94, 0, buf, 0, n184)

	return buf94
end
function t424.decode(p276: buffer) -- line: 15289
	-- upvalues: t424 (copy), proto (copy), hydration_data_spec (copy), t1 (copy)
	local v2933 = t424.new()
	local n185 = 0

	while n185 < buffer.len(p276) do
		local v2935, v2936

		v2935, v2936, n185 = proto.readTag(p276, n185)

		if v2936 == proto.wireTypes.varint then
			local v2937

			v2937, n185 = proto.readVarInt(p276, n185)
		elseif v2936 == proto.wireTypes.lengthDelimited then
			if v2935 == 1 then
				local v2938

				v2938, n185 = proto.readBuffer(p276, n185)
				v2933.kind = {
					type = "binding_path",
					value = buffer.tostring(v2938)
				}
			elseif v2935 == 3 then
				local v2939

				v2939, n185 = proto.readBuffer(p276, n185)
				table.insert(v2933.item_hydration_specs, hydration_data_spec.HydrationDataSpec.decode(v2939))
			elseif v2935 == 4 then
				local v2940

				v2940, n185 = proto.readBuffer(p276, n185)
				v2933.field_map = t1.AvatarConfigProp.decode(v2940)
			else
				local v2941, v2942 = proto.readVarInt(p276, n185)

				n185 = v2942 + v2941
			end
		elseif v2936 == proto.wireTypes.i32 then
			local v2943

			v2943, n185 = proto.readFixed32(p276, n185)
		elseif v2936 == proto.wireTypes.i64 then
			local v2944

			v2944, n185 = proto.readFixed64(p276, n185)
		else
			error("Unsupported wire type: " .. v2936)
		end
	end

	return v2933
end
function t424.jsonEncode(p277) -- line: 15345
	local t426 = {}

	if p277.kind ~= nil and p277.kind.type == "binding_path" then
		t426.bindingPath = p277.kind.value
	end

	if p277.item_hydration_specs ~= nil and #p277.item_hydration_specs > 0 then
		local t427 = {}

		for _, v2949 in p277.item_hydration_specs do
			table.insert(t427, v2949:jsonEncode())
		end

		t426.itemHydrationSpecs = t427
	end

	if p277.field_map ~= nil then
		t426.fieldMap = p277.field_map:jsonEncode()
	end

	return t426
end
function t424.jsonDecode(t428: {[any]: any}) -- line: 15369
	-- upvalues: t424 (copy), hydration_data_spec (copy), t1 (copy)
	local v2951 = t424.new()

	if t428.binding_path ~= nil then
		v2951.kind = {
			type = "binding_path",
			value = t428.binding_path
		}
	end

	if t428.bindingPath ~= nil then
		v2951.kind = {
			type = "binding_path",
			value = t428.bindingPath
		}
	end

	if t428.item_hydration_specs ~= nil then
		local t429 = {}

		for _, v2954 in t428.item_hydration_specs do
			table.insert(t429, hydration_data_spec.HydrationDataSpec.jsonDecode(v2954))
		end

		v2951.item_hydration_specs = t429
	end

	if t428.itemHydrationSpecs ~= nil then
		local t430 = {}

		for _, v2957 in t428.itemHydrationSpecs do
			table.insert(t430, hydration_data_spec.HydrationDataSpec.jsonDecode(v2957))
		end

		v2951.item_hydration_specs = t430
	end

	if t428.field_map ~= nil then
		v2951.field_map = t1.AvatarConfigProp.jsonDecode(t428.field_map)
	end

	if t428.fieldMap ~= nil then
		v2951.field_map = t1.AvatarConfigProp.jsonDecode(t428.fieldMap)
	end

	return v2951
end

t424.descriptor = {
	name = "ArrayOfAvatarProp_ArrayMap",
	fullName = "roblox.apppageplatform.shared.v1beta1.ArrayMap"
}
t1.ArrayOfAvatarProp_ArrayMap = t424
typeRegistry.default:register(t1.ArrayOfAvatarProp_ArrayMap)

return {
	TranslationRef = t1.TranslationRef,
	StringFormat = t1.StringFormat,
	StringFormat_FormatArg = t1.StringFormat_FormatArg,
	StringFormat_FormatArg_Formatter = t1.StringFormat_FormatArg_Formatter,
	StringFormat_FormatArg_Formatter_DateConfig = t1.StringFormat_FormatArg_Formatter_DateConfig,
	StringFormat_FormatArg_Formatter_Type = t1.StringFormat_FormatArg_Formatter_Type,
	StringProp = t1.StringProp,
	StringProp_ConditionalOption = t1.StringProp_ConditionalOption,
	StringProp_ConditionalOptions = t1.StringProp_ConditionalOptions,
	FloatProp = t1.FloatProp,
	FloatProp_ConditionalOption = t1.FloatProp_ConditionalOption,
	FloatProp_ConditionalOptions = t1.FloatProp_ConditionalOptions,
	DoubleProp = t1.DoubleProp,
	DoubleProp_ConditionalOption = t1.DoubleProp_ConditionalOption,
	DoubleProp_ConditionalOptions = t1.DoubleProp_ConditionalOptions,
	Int32Prop = t1.Int32Prop,
	Int32Prop_ConditionalOption = t1.Int32Prop_ConditionalOption,
	Int32Prop_ConditionalOptions = t1.Int32Prop_ConditionalOptions,
	Int64Prop = t1.Int64Prop,
	Int64Prop_ConditionalOption = t1.Int64Prop_ConditionalOption,
	Int64Prop_ConditionalOptions = t1.Int64Prop_ConditionalOptions,
	BoolProp = t1.BoolProp,
	BoolProp_ConditionalOption = t1.BoolProp_ConditionalOption,
	BoolProp_ConditionalOptions = t1.BoolProp_ConditionalOptions,
	StructProp = t1.StructProp,
	StructProp_ConditionalOption = t1.StructProp_ConditionalOption,
	StructProp_ConditionalOptions = t1.StructProp_ConditionalOptions,
	ImageStringProp = t1.ImageStringProp,
	ImageStringProp_ConditionalOption = t1.ImageStringProp_ConditionalOption,
	ImageStringProp_ConditionalOptions = t1.ImageStringProp_ConditionalOptions,
	ImageSetProp = t1.ImageSetProp,
	ImageSetProp_ConditionalOption = t1.ImageSetProp_ConditionalOption,
	ImageSetProp_ConditionalOptions = t1.ImageSetProp_ConditionalOptions,
	ColorProp = t1.ColorProp,
	ColorProp_ConditionalOption = t1.ColorProp_ConditionalOption,
	ColorProp_ConditionalOptions = t1.ColorProp_ConditionalOptions,
	TypographyProp = t1.TypographyProp,
	TypographyProp_ConditionalOption = t1.TypographyProp_ConditionalOption,
	TypographyProp_ConditionalOptions = t1.TypographyProp_ConditionalOptions,
	TypographyFontProp = t1.TypographyFontProp,
	TypographyFontProp_ConditionalOption = t1.TypographyFontProp_ConditionalOption,
	TypographyFontProp_ConditionalOptions = t1.TypographyFontProp_ConditionalOptions,
	ColorStyleProp = t1.ColorStyleProp,
	ColorStyleProp_ConditionalOption = t1.ColorStyleProp_ConditionalOption,
	ColorStyleProp_ConditionalOptions = t1.ColorStyleProp_ConditionalOptions,
	FillBehaviorProp = t1.FillBehaviorProp,
	FillBehaviorProp_ConditionalOption = t1.FillBehaviorProp_ConditionalOption,
	FillBehaviorProp_ConditionalOptions = t1.FillBehaviorProp_ConditionalOptions,
	InputSizeProp = t1.InputSizeProp,
	InputSizeProp_ConditionalOption = t1.InputSizeProp_ConditionalOption,
	InputSizeProp_ConditionalOptions = t1.InputSizeProp_ConditionalOptions,
	UDimProp = t1.UDimProp,
	UDimProp_ConditionalOption = t1.UDimProp_ConditionalOption,
	UDimProp_ConditionalOptions = t1.UDimProp_ConditionalOptions,
	UDim2Prop = t1.UDim2Prop,
	UDim2Prop_ConditionalOption = t1.UDim2Prop_ConditionalOption,
	UDim2Prop_ConditionalOptions = t1.UDim2Prop_ConditionalOptions,
	Vector2Prop = t1.Vector2Prop,
	Vector2Prop_ConditionalOption = t1.Vector2Prop_ConditionalOption,
	Vector2Prop_ConditionalOptions = t1.Vector2Prop_ConditionalOptions,
	IconProp = t1.IconProp,
	IconProp_ConditionalOption = t1.IconProp_ConditionalOption,
	IconProp_ConditionalOptions = t1.IconProp_ConditionalOptions,
	FoundationIconConfigProp = t1.FoundationIconConfigProp,
	FoundationIconConfigProp_ConditionalOption = t1.FoundationIconConfigProp_ConditionalOption,
	FoundationIconConfigProp_ConditionalOptions = t1.FoundationIconConfigProp_ConditionalOptions,
	FoundationIconConfigProp_FoundationIconConfig = t1.FoundationIconConfigProp_FoundationIconConfig,
	IconSizeProp = t1.IconSizeProp,
	GradientProp = t1.GradientProp,
	GradientProp_ConditionalOption = t1.GradientProp_ConditionalOption,
	GradientProp_ConditionalOptions = t1.GradientProp_ConditionalOptions,
	GradientProp_GradientData = t1.GradientProp_GradientData,
	ArrayOfStructProp = t1.ArrayOfStructProp,
	ArrayOfStructProp_ConditionalOption = t1.ArrayOfStructProp_ConditionalOption,
	ArrayOfStructProp_ConditionalOptions = t1.ArrayOfStructProp_ConditionalOptions,
	ArrayOfStructProp_ArrayOfStructs = t1.ArrayOfStructProp_ArrayOfStructs,
	UiScaledFloatProp = t1.UiScaledFloatProp,
	UiScaledFloatProp_ConditionalOption = t1.UiScaledFloatProp_ConditionalOption,
	UiScaledFloatProp_ConditionalOptions = t1.UiScaledFloatProp_ConditionalOptions,
	UiScaledUDimProp = t1.UiScaledUDimProp,
	UiScaledUDimProp_ConditionalOption = t1.UiScaledUDimProp_ConditionalOption,
	UiScaledUDimProp_ConditionalOptions = t1.UiScaledUDimProp_ConditionalOptions,
	UiScaledUDim2Prop = t1.UiScaledUDim2Prop,
	UiScaledUDim2Prop_ConditionalOption = t1.UiScaledUDim2Prop_ConditionalOption,
	UiScaledUDim2Prop_ConditionalOptions = t1.UiScaledUDim2Prop_ConditionalOptions,
	AvatarConfigProp = t1.AvatarConfigProp,
	AvatarProp = t1.AvatarProp,
	ArrayOfAvatarProp = t1.ArrayOfAvatarProp,
	ArrayOfAvatarProp_ConditionalOption = t1.ArrayOfAvatarProp_ConditionalOption,
	ArrayOfAvatarProp_ConditionalOptions = t1.ArrayOfAvatarProp_ConditionalOptions,
	ArrayOfAvatarProp_ArrayOfAvatars = t1.ArrayOfAvatarProp_ArrayOfAvatars,
	ArrayOfAvatarProp_ArrayMap = t1.ArrayOfAvatarProp_ArrayMap
}
