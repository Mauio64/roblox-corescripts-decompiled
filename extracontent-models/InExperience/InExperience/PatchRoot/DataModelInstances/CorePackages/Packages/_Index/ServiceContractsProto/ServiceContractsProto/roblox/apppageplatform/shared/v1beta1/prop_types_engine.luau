local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local prop_condition = require(script.Parent.prop_condition)
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 1202
	-- upvalues: t2 (copy)
	return (setmetatable({
		kind = if t3 ~= nil and t3.kind ~= nil then t3.kind else nil
	}, t2))
end
function t2.encode(p1) -- line: 1208
	-- upvalues: proto (copy), t1 (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.kind ~= nil then
		if p1.kind.type == "literal" then
			local v45, v46 = proto.writeTag(buf, n1, 1, proto.wireTypes.varint)

			buf, n1 = proto.writeVarInt(v45, v46, t1.AutomaticSize.toNumber(p1.kind.value))
		elseif p1.kind.type == "binding_path" then
			local v47, v48 = proto.writeTag(buf, n1, 2, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeString(v47, v48, p1.kind.value)
		elseif p1.kind.type == "conditional" then
			local v49 = p1.kind.value:encode()
			local v50, v51 = proto.writeTag(buf, n1, 3, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v50, v51, v49, buffer.len(v49))
		end
	end

	local buf2 = buffer.create(n1)

	buffer.copy(buf2, 0, buf, 0, n1)

	return buf2
end
function t2.decode(p2: buffer) -- line: 1232
	-- upvalues: t2 (copy), proto (copy), t1 (copy)
	local v54 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v56, v57

		v56, v57, n2 = proto.readTag(p2, n2)

		if v57 == proto.wireTypes.varint then
			if v56 == 1 then
				local v58

				v58, n2 = proto.readVarIntI32(p2, n2)
				v54.kind = {
					type = "literal",
					value = t1.AutomaticSize.fromNumber(v58) or v58
				}
			else
				local v59

				v59, n2 = proto.readVarInt(p2, n2)
			end
		elseif v57 == proto.wireTypes.lengthDelimited then
			if v56 == 2 then
				local v60

				v60, n2 = proto.readBuffer(p2, n2)
				v54.kind = {
					type = "binding_path",
					value = buffer.tostring(v60)
				}
			elseif v56 == 3 then
				local v61

				v61, n2 = proto.readBuffer(p2, n2)
				v54.kind = {
					type = "conditional",
					value = t1.AutomaticSizeProp_ConditionalOptions.decode(v61)
				}
			else
				local v62, v63 = proto.readVarInt(p2, n2)

				n2 = v63 + v62
			end
		elseif v57 == proto.wireTypes.i32 then
			local v64

			v64, n2 = proto.readFixed32(p2, n2)
		elseif v57 == proto.wireTypes.i64 then
			local v65

			v65, n2 = proto.readFixed64(p2, n2)
		else
			error("Unsupported wire type: " .. v57)
		end
	end

	return v54
end
function t2.jsonEncode(p3) -- line: 1289
	-- upvalues: t1 (copy)
	local t4 = {}

	if p3.kind ~= nil then
		if p3.kind.type == "literal" then
			t4.literal = if typeof(p3.kind.value) ~= "number" then t1.AutomaticSize.toNumber(p3.kind.value) else p3.kind.value

			return t4
		end

		if p3.kind.type == "binding_path" then
			t4.bindingPath = p3.kind.value

			return t4
		end

		if p3.kind.type == "conditional" then
			t4.conditional = p3.kind.value:jsonEncode()
		end
	end

	return t4
end
function t2.jsonDecode(t5: {[any]: any}) -- line: 1307
	-- upvalues: t2 (copy), t1 (copy)
	local v69 = t2.new()

	if t5.literal ~= nil then
		v69.kind = {
			type = "literal",
			value = if typeof(t5.literal) ~= "number" then t1.AutomaticSize.fromName(t5.literal) or t5.literal else t1.AutomaticSize.fromNumber(t5.literal) or t5.literal
		}
	end

	if t5.binding_path ~= nil then
		v69.kind = {
			type = "binding_path",
			value = t5.binding_path
		}
	end

	if t5.bindingPath ~= nil then
		v69.kind = {
			type = "binding_path",
			value = t5.bindingPath
		}
	end

	if t5.conditional ~= nil then
		v69.kind = {
			type = "conditional",
			value = t1.AutomaticSizeProp_ConditionalOptions.jsonDecode(t5.conditional)
		}
	end

	return v69
end

t2.descriptor = {
	name = "AutomaticSizeProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.AutomaticSizeProp"
}
t1.AutomaticSizeProp = t2
typeRegistry.default:register(t1.AutomaticSizeProp)

local t6 = {}

t6.__index = t6

function t6.new(t7: {[any]: any}?) -- line: 1351
	-- upvalues: t6 (copy)
	return (setmetatable({
		condition = if t7 ~= nil and t7.condition ~= nil then t7.condition else nil,
		kind = if t7 ~= nil and t7.kind ~= nil then t7.kind else nil
	}, t6))
end
function t6.encode(p4) -- line: 1360
	-- upvalues: proto (copy), t1 (copy)
	local buf = buffer.create(0)
	local n3 = 0

	if p4.condition ~= nil then
		local v74 = p4.condition:encode()
		local v75, v76 = proto.writeTag(buf, n3, 1, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeBuffer(v75, v76, v74, buffer.len(v74))
	end

	if p4.kind ~= nil then
		if p4.kind.type == "literal" then
			local v77, v78 = proto.writeTag(buf, n3, 2, proto.wireTypes.varint)

			buf, n3 = proto.writeVarInt(v77, v78, t1.AutomaticSize.toNumber(p4.kind.value))
		elseif p4.kind.type == "binding_path" then
			local v79, v80 = proto.writeTag(buf, n3, 3, proto.wireTypes.lengthDelimited)

			buf, n3 = proto.writeString(v79, v80, p4.kind.value)
		end
	end

	local buf3 = buffer.create(n3)

	buffer.copy(buf3, 0, buf, 0, n3)

	return buf3
end
function t6.decode(p5: buffer) -- line: 1386
	-- upvalues: t6 (copy), proto (copy), t1 (copy), prop_condition (copy)
	local v83 = t6.new()
	local n4 = 0

	while n4 < buffer.len(p5) do
		local v85, v86

		v85, v86, n4 = proto.readTag(p5, n4)

		if v86 == proto.wireTypes.varint then
			if v85 == 2 then
				local v87

				v87, n4 = proto.readVarIntI32(p5, n4)
				v83.kind = {
					type = "literal",
					value = t1.AutomaticSize.fromNumber(v87) or v87
				}
			else
				local v88

				v88, n4 = proto.readVarInt(p5, n4)
			end
		elseif v86 == proto.wireTypes.lengthDelimited then
			if v85 == 1 then
				local v89

				v89, n4 = proto.readBuffer(p5, n4)
				v83.condition = prop_condition.PropCondition.decode(v89)
			elseif v85 == 3 then
				local v90

				v90, n4 = proto.readBuffer(p5, n4)
				v83.kind = {
					type = "binding_path",
					value = buffer.tostring(v90)
				}
			else
				local v91, v92 = proto.readVarInt(p5, n4)

				n4 = v92 + v91
			end
		elseif v86 == proto.wireTypes.i32 then
			local v93

			v93, n4 = proto.readFixed32(p5, n4)
		elseif v86 == proto.wireTypes.i64 then
			local v94

			v94, n4 = proto.readFixed64(p5, n4)
		else
			error("Unsupported wire type: " .. v86)
		end
	end

	return v83
end
function t6.jsonEncode(p6) -- line: 1442
	-- upvalues: t1 (copy)
	local t8 = {}

	if p6.condition ~= nil then
		t8.condition = p6.condition:jsonEncode()
	end

	if p6.kind ~= nil then
		if p6.kind.type == "literal" then
			t8.literal = if typeof(p6.kind.value) ~= "number" then t1.AutomaticSize.toNumber(p6.kind.value) else p6.kind.value

			return t8
		end

		if p6.kind.type == "binding_path" then
			t8.bindingPath = p6.kind.value
		end
	end

	return t8
end
function t6.jsonDecode(t9: {[any]: any}) -- line: 1462
	-- upvalues: t6 (copy), prop_condition (copy), t1 (copy)
	local v98 = t6.new()

	if t9.condition ~= nil then
		v98.condition = prop_condition.PropCondition.jsonDecode(t9.condition)
	end

	if t9.literal ~= nil then
		v98.kind = {
			type = "literal",
			value = if typeof(t9.literal) ~= "number" then t1.AutomaticSize.fromName(t9.literal) or t9.literal else t1.AutomaticSize.fromNumber(t9.literal) or t9.literal
		}
	end

	if t9.binding_path ~= nil then
		v98.kind = {
			type = "binding_path",
			value = t9.binding_path
		}
	end

	if t9.bindingPath ~= nil then
		v98.kind = {
			type = "binding_path",
			value = t9.bindingPath
		}
	end

	return v98
end

t6.descriptor = {
	name = "AutomaticSizeProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}
t1.AutomaticSizeProp_ConditionalOption = t6
typeRegistry.default:register(t1.AutomaticSizeProp_ConditionalOption)

local t10 = {}

t10.__index = t10

function t10.new(t11: {[any]: any}?) -- line: 1506
	-- upvalues: t10 (copy)
	return (setmetatable({
		options = if t11 ~= nil and t11.options ~= nil then t11.options else {}
	}, t10))
end
function t10.encode(p7) -- line: 1514
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n5 = 0

	if p7.options ~= nil and #p7.options > 0 then
		for _, v104 in p7.options do
			local v105 = v104:encode()
			local v106, v107 = proto.writeTag(buf, n5, 1, proto.wireTypes.lengthDelimited)

			buf, n5 = proto.writeBuffer(v106, v107, v105, buffer.len(v105))
		end
	end

	local buf4 = buffer.create(n5)

	buffer.copy(buf4, 0, buf, 0, n5)

	return buf4
end
function t10.decode(p8: buffer) -- line: 1531
	-- upvalues: t10 (copy), proto (copy), t1 (copy)
	local v110 = t10.new()
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
				table.insert(v110.options, t1.AutomaticSizeProp_ConditionalOption.decode(v115))
			else
				local v116, v117 = proto.readVarInt(p8, n6)

				n6 = v117 + v116
			end
		elseif v113 == proto.wireTypes.i32 then
			local v118

			v118, n6 = proto.readFixed32(p8, n6)
		elseif v113 == proto.wireTypes.i64 then
			local v119

			v119, n6 = proto.readFixed64(p8, n6)
		else
			error("Unsupported wire type: " .. v113)
		end
	end

	return v110
end
function t10.jsonEncode(p9) -- line: 1574
	local t12 = {}

	if p9.options ~= nil and #p9.options > 0 then
		local t13 = {}

		for _, v124 in p9.options do
			table.insert(t13, v124:jsonEncode())
		end

		t12.options = t13
	end

	return t12
end
function t10.jsonDecode(t14: {[any]: any}) -- line: 1588
	-- upvalues: t10 (copy), t1 (copy)
	local v126 = t10.new()

	if t14.options ~= nil then
		local t15 = {}

		for _, v129 in t14.options do
			table.insert(t15, t1.AutomaticSizeProp_ConditionalOption.jsonDecode(v129))
		end

		v126.options = t15
	end

	return v126
end

t10.descriptor = {
	name = "AutomaticSizeProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}
t1.AutomaticSizeProp_ConditionalOptions = t10
typeRegistry.default:register(t1.AutomaticSizeProp_ConditionalOptions)

local t16 = {}

t16.__index = t16

function t16.new(t17: {[any]: any}?) -- line: 1619
	-- upvalues: t16 (copy)
	return (setmetatable({
		kind = if t17 ~= nil and t17.kind ~= nil then t17.kind else nil
	}, t16))
end
function t16.encode(p10) -- line: 1625
	-- upvalues: proto (copy), t1 (copy)
	local buf = buffer.create(0)
	local n7 = 0

	if p10.kind ~= nil then
		if p10.kind.type == "literal" then
			local v134, v135 = proto.writeTag(buf, n7, 1, proto.wireTypes.varint)

			buf, n7 = proto.writeVarInt(v134, v135, t1.TextTruncate.toNumber(p10.kind.value))
		elseif p10.kind.type == "binding_path" then
			local v136, v137 = proto.writeTag(buf, n7, 2, proto.wireTypes.lengthDelimited)

			buf, n7 = proto.writeString(v136, v137, p10.kind.value)
		elseif p10.kind.type == "conditional" then
			local v138 = p10.kind.value:encode()
			local v139, v140 = proto.writeTag(buf, n7, 3, proto.wireTypes.lengthDelimited)

			buf, n7 = proto.writeBuffer(v139, v140, v138, buffer.len(v138))
		end
	end

	local buf5 = buffer.create(n7)

	buffer.copy(buf5, 0, buf, 0, n7)

	return buf5
end
function t16.decode(p11: buffer) -- line: 1649
	-- upvalues: t16 (copy), proto (copy), t1 (copy)
	local v143 = t16.new()
	local n8 = 0

	while n8 < buffer.len(p11) do
		local v145, v146

		v145, v146, n8 = proto.readTag(p11, n8)

		if v146 == proto.wireTypes.varint then
			if v145 == 1 then
				local v147

				v147, n8 = proto.readVarIntI32(p11, n8)
				v143.kind = {
					type = "literal",
					value = t1.TextTruncate.fromNumber(v147) or v147
				}
			else
				local v148

				v148, n8 = proto.readVarInt(p11, n8)
			end
		elseif v146 == proto.wireTypes.lengthDelimited then
			if v145 == 2 then
				local v149

				v149, n8 = proto.readBuffer(p11, n8)
				v143.kind = {
					type = "binding_path",
					value = buffer.tostring(v149)
				}
			elseif v145 == 3 then
				local v150

				v150, n8 = proto.readBuffer(p11, n8)
				v143.kind = {
					type = "conditional",
					value = t1.TextTruncateProp_ConditionalOptions.decode(v150)
				}
			else
				local v151, v152 = proto.readVarInt(p11, n8)

				n8 = v152 + v151
			end
		elseif v146 == proto.wireTypes.i32 then
			local v153

			v153, n8 = proto.readFixed32(p11, n8)
		elseif v146 == proto.wireTypes.i64 then
			local v154

			v154, n8 = proto.readFixed64(p11, n8)
		else
			error("Unsupported wire type: " .. v146)
		end
	end

	return v143
end
function t16.jsonEncode(p12) -- line: 1706
	-- upvalues: t1 (copy)
	local t18 = {}

	if p12.kind ~= nil then
		if p12.kind.type == "literal" then
			t18.literal = if typeof(p12.kind.value) ~= "number" then t1.TextTruncate.toNumber(p12.kind.value) else p12.kind.value

			return t18
		end

		if p12.kind.type == "binding_path" then
			t18.bindingPath = p12.kind.value

			return t18
		end

		if p12.kind.type == "conditional" then
			t18.conditional = p12.kind.value:jsonEncode()
		end
	end

	return t18
end
function t16.jsonDecode(t19: {[any]: any}) -- line: 1724
	-- upvalues: t16 (copy), t1 (copy)
	local v158 = t16.new()

	if t19.literal ~= nil then
		v158.kind = {
			type = "literal",
			value = if typeof(t19.literal) ~= "number" then t1.TextTruncate.fromName(t19.literal) or t19.literal else t1.TextTruncate.fromNumber(t19.literal) or t19.literal
		}
	end

	if t19.binding_path ~= nil then
		v158.kind = {
			type = "binding_path",
			value = t19.binding_path
		}
	end

	if t19.bindingPath ~= nil then
		v158.kind = {
			type = "binding_path",
			value = t19.bindingPath
		}
	end

	if t19.conditional ~= nil then
		v158.kind = {
			type = "conditional",
			value = t1.TextTruncateProp_ConditionalOptions.jsonDecode(t19.conditional)
		}
	end

	return v158
end

t16.descriptor = {
	name = "TextTruncateProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.TextTruncateProp"
}
t1.TextTruncateProp = t16
typeRegistry.default:register(t1.TextTruncateProp)

local t20 = {}

t20.__index = t20

function t20.new(t21: {[any]: any}?) -- line: 1768
	-- upvalues: t20 (copy)
	return (setmetatable({
		condition = if t21 ~= nil and t21.condition ~= nil then t21.condition else nil,
		kind = if t21 ~= nil and t21.kind ~= nil then t21.kind else nil
	}, t20))
end
function t20.encode(p13) -- line: 1777
	-- upvalues: proto (copy), t1 (copy)
	local buf = buffer.create(0)
	local n9 = 0

	if p13.condition ~= nil then
		local v163 = p13.condition:encode()
		local v164, v165 = proto.writeTag(buf, n9, 1, proto.wireTypes.lengthDelimited)

		buf, n9 = proto.writeBuffer(v164, v165, v163, buffer.len(v163))
	end

	if p13.kind ~= nil then
		if p13.kind.type == "literal" then
			local v166, v167 = proto.writeTag(buf, n9, 2, proto.wireTypes.varint)

			buf, n9 = proto.writeVarInt(v166, v167, t1.TextTruncate.toNumber(p13.kind.value))
		elseif p13.kind.type == "binding_path" then
			local v168, v169 = proto.writeTag(buf, n9, 3, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeString(v168, v169, p13.kind.value)
		end
	end

	local buf6 = buffer.create(n9)

	buffer.copy(buf6, 0, buf, 0, n9)

	return buf6
end
function t20.decode(p14: buffer) -- line: 1803
	-- upvalues: t20 (copy), proto (copy), t1 (copy), prop_condition (copy)
	local v172 = t20.new()
	local n10 = 0

	while n10 < buffer.len(p14) do
		local v174, v175

		v174, v175, n10 = proto.readTag(p14, n10)

		if v175 == proto.wireTypes.varint then
			if v174 == 2 then
				local v176

				v176, n10 = proto.readVarIntI32(p14, n10)
				v172.kind = {
					type = "literal",
					value = t1.TextTruncate.fromNumber(v176) or v176
				}
			else
				local v177

				v177, n10 = proto.readVarInt(p14, n10)
			end
		elseif v175 == proto.wireTypes.lengthDelimited then
			if v174 == 1 then
				local v178

				v178, n10 = proto.readBuffer(p14, n10)
				v172.condition = prop_condition.PropCondition.decode(v178)
			elseif v174 == 3 then
				local v179

				v179, n10 = proto.readBuffer(p14, n10)
				v172.kind = {
					type = "binding_path",
					value = buffer.tostring(v179)
				}
			else
				local v180, v181 = proto.readVarInt(p14, n10)

				n10 = v181 + v180
			end
		elseif v175 == proto.wireTypes.i32 then
			local v182

			v182, n10 = proto.readFixed32(p14, n10)
		elseif v175 == proto.wireTypes.i64 then
			local v183

			v183, n10 = proto.readFixed64(p14, n10)
		else
			error("Unsupported wire type: " .. v175)
		end
	end

	return v172
end
function t20.jsonEncode(p15) -- line: 1859
	-- upvalues: t1 (copy)
	local t22 = {}

	if p15.condition ~= nil then
		t22.condition = p15.condition:jsonEncode()
	end

	if p15.kind ~= nil then
		if p15.kind.type == "literal" then
			t22.literal = if typeof(p15.kind.value) ~= "number" then t1.TextTruncate.toNumber(p15.kind.value) else p15.kind.value

			return t22
		end

		if p15.kind.type == "binding_path" then
			t22.bindingPath = p15.kind.value
		end
	end

	return t22
end
function t20.jsonDecode(t23: {[any]: any}) -- line: 1879
	-- upvalues: t20 (copy), prop_condition (copy), t1 (copy)
	local v187 = t20.new()

	if t23.condition ~= nil then
		v187.condition = prop_condition.PropCondition.jsonDecode(t23.condition)
	end

	if t23.literal ~= nil then
		v187.kind = {
			type = "literal",
			value = if typeof(t23.literal) ~= "number" then t1.TextTruncate.fromName(t23.literal) or t23.literal else t1.TextTruncate.fromNumber(t23.literal) or t23.literal
		}
	end

	if t23.binding_path ~= nil then
		v187.kind = {
			type = "binding_path",
			value = t23.binding_path
		}
	end

	if t23.bindingPath ~= nil then
		v187.kind = {
			type = "binding_path",
			value = t23.bindingPath
		}
	end

	return v187
end

t20.descriptor = {
	name = "TextTruncateProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}
t1.TextTruncateProp_ConditionalOption = t20
typeRegistry.default:register(t1.TextTruncateProp_ConditionalOption)

local t24 = {}

t24.__index = t24

function t24.new(t25: {[any]: any}?) -- line: 1923
	-- upvalues: t24 (copy)
	return (setmetatable({
		options = if t25 ~= nil and t25.options ~= nil then t25.options else {}
	}, t24))
end
function t24.encode(p16) -- line: 1931
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n11 = 0

	if p16.options ~= nil and #p16.options > 0 then
		for _, v193 in p16.options do
			local v194 = v193:encode()
			local v195, v196 = proto.writeTag(buf, n11, 1, proto.wireTypes.lengthDelimited)

			buf, n11 = proto.writeBuffer(v195, v196, v194, buffer.len(v194))
		end
	end

	local buf7 = buffer.create(n11)

	buffer.copy(buf7, 0, buf, 0, n11)

	return buf7
end
function t24.decode(p17: buffer) -- line: 1948
	-- upvalues: t24 (copy), proto (copy), t1 (copy)
	local v199 = t24.new()
	local n12 = 0

	while n12 < buffer.len(p17) do
		local v201, v202

		v201, v202, n12 = proto.readTag(p17, n12)

		if v202 == proto.wireTypes.varint then
			local v203

			v203, n12 = proto.readVarInt(p17, n12)
		elseif v202 == proto.wireTypes.lengthDelimited then
			if v201 == 1 then
				local v204

				v204, n12 = proto.readBuffer(p17, n12)
				table.insert(v199.options, t1.TextTruncateProp_ConditionalOption.decode(v204))
			else
				local v205, v206 = proto.readVarInt(p17, n12)

				n12 = v206 + v205
			end
		elseif v202 == proto.wireTypes.i32 then
			local v207

			v207, n12 = proto.readFixed32(p17, n12)
		elseif v202 == proto.wireTypes.i64 then
			local v208

			v208, n12 = proto.readFixed64(p17, n12)
		else
			error("Unsupported wire type: " .. v202)
		end
	end

	return v199
end
function t24.jsonEncode(p18) -- line: 1991
	local t26 = {}

	if p18.options ~= nil and #p18.options > 0 then
		local t27 = {}

		for _, v213 in p18.options do
			table.insert(t27, v213:jsonEncode())
		end

		t26.options = t27
	end

	return t26
end
function t24.jsonDecode(t28: {[any]: any}) -- line: 2005
	-- upvalues: t24 (copy), t1 (copy)
	local v215 = t24.new()

	if t28.options ~= nil then
		local t29 = {}

		for _, v218 in t28.options do
			table.insert(t29, t1.TextTruncateProp_ConditionalOption.jsonDecode(v218))
		end

		v215.options = t29
	end

	return v215
end

t24.descriptor = {
	name = "TextTruncateProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}
t1.TextTruncateProp_ConditionalOptions = t24
typeRegistry.default:register(t1.TextTruncateProp_ConditionalOptions)

local t30 = {}

t30.__index = t30

function t30.new(t31: {[any]: any}?) -- line: 2036
	-- upvalues: t30 (copy)
	return (setmetatable({
		kind = if t31 ~= nil and t31.kind ~= nil then t31.kind else nil
	}, t30))
end
function t30.encode(p19) -- line: 2042
	-- upvalues: proto (copy), t1 (copy)
	local buf = buffer.create(0)
	local n13 = 0

	if p19.kind ~= nil then
		if p19.kind.type == "literal" then
			local v223, v224 = proto.writeTag(buf, n13, 1, proto.wireTypes.varint)

			buf, n13 = proto.writeVarInt(v223, v224, t1.TextXAlignment.toNumber(p19.kind.value))
		elseif p19.kind.type == "binding_path" then
			local v225, v226 = proto.writeTag(buf, n13, 2, proto.wireTypes.lengthDelimited)

			buf, n13 = proto.writeString(v225, v226, p19.kind.value)
		elseif p19.kind.type == "conditional" then
			local v227 = p19.kind.value:encode()
			local v228, v229 = proto.writeTag(buf, n13, 3, proto.wireTypes.lengthDelimited)

			buf, n13 = proto.writeBuffer(v228, v229, v227, buffer.len(v227))
		end
	end

	local buf8 = buffer.create(n13)

	buffer.copy(buf8, 0, buf, 0, n13)

	return buf8
end
function t30.decode(p20: buffer) -- line: 2066
	-- upvalues: t30 (copy), proto (copy), t1 (copy)
	local v232 = t30.new()
	local n14 = 0

	while n14 < buffer.len(p20) do
		local v234, v235

		v234, v235, n14 = proto.readTag(p20, n14)

		if v235 == proto.wireTypes.varint then
			if v234 == 1 then
				local v236

				v236, n14 = proto.readVarIntI32(p20, n14)
				v232.kind = {
					type = "literal",
					value = t1.TextXAlignment.fromNumber(v236) or v236
				}
			else
				local v237

				v237, n14 = proto.readVarInt(p20, n14)
			end
		elseif v235 == proto.wireTypes.lengthDelimited then
			if v234 == 2 then
				local v238

				v238, n14 = proto.readBuffer(p20, n14)
				v232.kind = {
					type = "binding_path",
					value = buffer.tostring(v238)
				}
			elseif v234 == 3 then
				local v239

				v239, n14 = proto.readBuffer(p20, n14)
				v232.kind = {
					type = "conditional",
					value = t1.TextXAlignmentProp_ConditionalOptions.decode(v239)
				}
			else
				local v240, v241 = proto.readVarInt(p20, n14)

				n14 = v241 + v240
			end
		elseif v235 == proto.wireTypes.i32 then
			local v242

			v242, n14 = proto.readFixed32(p20, n14)
		elseif v235 == proto.wireTypes.i64 then
			local v243

			v243, n14 = proto.readFixed64(p20, n14)
		else
			error("Unsupported wire type: " .. v235)
		end
	end

	return v232
end
function t30.jsonEncode(p21) -- line: 2123
	-- upvalues: t1 (copy)
	local t32 = {}

	if p21.kind ~= nil then
		if p21.kind.type == "literal" then
			t32.literal = if typeof(p21.kind.value) ~= "number" then t1.TextXAlignment.toNumber(p21.kind.value) else p21.kind.value

			return t32
		end

		if p21.kind.type == "binding_path" then
			t32.bindingPath = p21.kind.value

			return t32
		end

		if p21.kind.type == "conditional" then
			t32.conditional = p21.kind.value:jsonEncode()
		end
	end

	return t32
end
function t30.jsonDecode(t33: {[any]: any}) -- line: 2141
	-- upvalues: t30 (copy), t1 (copy)
	local v247 = t30.new()

	if t33.literal ~= nil then
		v247.kind = {
			type = "literal",
			value = if typeof(t33.literal) ~= "number" then t1.TextXAlignment.fromName(t33.literal) or t33.literal else t1.TextXAlignment.fromNumber(t33.literal) or t33.literal
		}
	end

	if t33.binding_path ~= nil then
		v247.kind = {
			type = "binding_path",
			value = t33.binding_path
		}
	end

	if t33.bindingPath ~= nil then
		v247.kind = {
			type = "binding_path",
			value = t33.bindingPath
		}
	end

	if t33.conditional ~= nil then
		v247.kind = {
			type = "conditional",
			value = t1.TextXAlignmentProp_ConditionalOptions.jsonDecode(t33.conditional)
		}
	end

	return v247
end

t30.descriptor = {
	name = "TextXAlignmentProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.TextXAlignmentProp"
}
t1.TextXAlignmentProp = t30
typeRegistry.default:register(t1.TextXAlignmentProp)

local t34 = {}

t34.__index = t34

function t34.new(t35: {[any]: any}?) -- line: 2185
	-- upvalues: t34 (copy)
	return (setmetatable({
		condition = if t35 ~= nil and t35.condition ~= nil then t35.condition else nil,
		kind = if t35 ~= nil and t35.kind ~= nil then t35.kind else nil
	}, t34))
end
function t34.encode(p22) -- line: 2194
	-- upvalues: proto (copy), t1 (copy)
	local buf = buffer.create(0)
	local n15 = 0

	if p22.condition ~= nil then
		local v252 = p22.condition:encode()
		local v253, v254 = proto.writeTag(buf, n15, 1, proto.wireTypes.lengthDelimited)

		buf, n15 = proto.writeBuffer(v253, v254, v252, buffer.len(v252))
	end

	if p22.kind ~= nil then
		if p22.kind.type == "literal" then
			local v255, v256 = proto.writeTag(buf, n15, 2, proto.wireTypes.varint)

			buf, n15 = proto.writeVarInt(v255, v256, t1.TextXAlignment.toNumber(p22.kind.value))
		elseif p22.kind.type == "binding_path" then
			local v257, v258 = proto.writeTag(buf, n15, 3, proto.wireTypes.lengthDelimited)

			buf, n15 = proto.writeString(v257, v258, p22.kind.value)
		end
	end

	local buf9 = buffer.create(n15)

	buffer.copy(buf9, 0, buf, 0, n15)

	return buf9
end
function t34.decode(p23: buffer) -- line: 2220
	-- upvalues: t34 (copy), proto (copy), t1 (copy), prop_condition (copy)
	local v261 = t34.new()
	local n16 = 0

	while n16 < buffer.len(p23) do
		local v263, v264

		v263, v264, n16 = proto.readTag(p23, n16)

		if v264 == proto.wireTypes.varint then
			if v263 == 2 then
				local v265

				v265, n16 = proto.readVarIntI32(p23, n16)
				v261.kind = {
					type = "literal",
					value = t1.TextXAlignment.fromNumber(v265) or v265
				}
			else
				local v266

				v266, n16 = proto.readVarInt(p23, n16)
			end
		elseif v264 == proto.wireTypes.lengthDelimited then
			if v263 == 1 then
				local v267

				v267, n16 = proto.readBuffer(p23, n16)
				v261.condition = prop_condition.PropCondition.decode(v267)
			elseif v263 == 3 then
				local v268

				v268, n16 = proto.readBuffer(p23, n16)
				v261.kind = {
					type = "binding_path",
					value = buffer.tostring(v268)
				}
			else
				local v269, v270 = proto.readVarInt(p23, n16)

				n16 = v270 + v269
			end
		elseif v264 == proto.wireTypes.i32 then
			local v271

			v271, n16 = proto.readFixed32(p23, n16)
		elseif v264 == proto.wireTypes.i64 then
			local v272

			v272, n16 = proto.readFixed64(p23, n16)
		else
			error("Unsupported wire type: " .. v264)
		end
	end

	return v261
end
function t34.jsonEncode(p24) -- line: 2276
	-- upvalues: t1 (copy)
	local t36 = {}

	if p24.condition ~= nil then
		t36.condition = p24.condition:jsonEncode()
	end

	if p24.kind ~= nil then
		if p24.kind.type == "literal" then
			t36.literal = if typeof(p24.kind.value) ~= "number" then t1.TextXAlignment.toNumber(p24.kind.value) else p24.kind.value

			return t36
		end

		if p24.kind.type == "binding_path" then
			t36.bindingPath = p24.kind.value
		end
	end

	return t36
end
function t34.jsonDecode(t37: {[any]: any}) -- line: 2296
	-- upvalues: t34 (copy), prop_condition (copy), t1 (copy)
	local v276 = t34.new()

	if t37.condition ~= nil then
		v276.condition = prop_condition.PropCondition.jsonDecode(t37.condition)
	end

	if t37.literal ~= nil then
		v276.kind = {
			type = "literal",
			value = if typeof(t37.literal) ~= "number" then t1.TextXAlignment.fromName(t37.literal) or t37.literal else t1.TextXAlignment.fromNumber(t37.literal) or t37.literal
		}
	end

	if t37.binding_path ~= nil then
		v276.kind = {
			type = "binding_path",
			value = t37.binding_path
		}
	end

	if t37.bindingPath ~= nil then
		v276.kind = {
			type = "binding_path",
			value = t37.bindingPath
		}
	end

	return v276
end

t34.descriptor = {
	name = "TextXAlignmentProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}
t1.TextXAlignmentProp_ConditionalOption = t34
typeRegistry.default:register(t1.TextXAlignmentProp_ConditionalOption)

local t38 = {}

t38.__index = t38

function t38.new(t39: {[any]: any}?) -- line: 2340
	-- upvalues: t38 (copy)
	return (setmetatable({
		options = if t39 ~= nil and t39.options ~= nil then t39.options else {}
	}, t38))
end
function t38.encode(p25) -- line: 2348
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n17 = 0

	if p25.options ~= nil and #p25.options > 0 then
		for _, v282 in p25.options do
			local v283 = v282:encode()
			local v284, v285 = proto.writeTag(buf, n17, 1, proto.wireTypes.lengthDelimited)

			buf, n17 = proto.writeBuffer(v284, v285, v283, buffer.len(v283))
		end
	end

	local buf10 = buffer.create(n17)

	buffer.copy(buf10, 0, buf, 0, n17)

	return buf10
end
function t38.decode(p26: buffer) -- line: 2365
	-- upvalues: t38 (copy), proto (copy), t1 (copy)
	local v288 = t38.new()
	local n18 = 0

	while n18 < buffer.len(p26) do
		local v290, v291

		v290, v291, n18 = proto.readTag(p26, n18)

		if v291 == proto.wireTypes.varint then
			local v292

			v292, n18 = proto.readVarInt(p26, n18)
		elseif v291 == proto.wireTypes.lengthDelimited then
			if v290 == 1 then
				local v293

				v293, n18 = proto.readBuffer(p26, n18)
				table.insert(v288.options, t1.TextXAlignmentProp_ConditionalOption.decode(v293))
			else
				local v294, v295 = proto.readVarInt(p26, n18)

				n18 = v295 + v294
			end
		elseif v291 == proto.wireTypes.i32 then
			local v296

			v296, n18 = proto.readFixed32(p26, n18)
		elseif v291 == proto.wireTypes.i64 then
			local v297

			v297, n18 = proto.readFixed64(p26, n18)
		else
			error("Unsupported wire type: " .. v291)
		end
	end

	return v288
end
function t38.jsonEncode(p27) -- line: 2408
	local t40 = {}

	if p27.options ~= nil and #p27.options > 0 then
		local t41 = {}

		for _, v302 in p27.options do
			table.insert(t41, v302:jsonEncode())
		end

		t40.options = t41
	end

	return t40
end
function t38.jsonDecode(t42: {[any]: any}) -- line: 2422
	-- upvalues: t38 (copy), t1 (copy)
	local v304 = t38.new()

	if t42.options ~= nil then
		local t43 = {}

		for _, v307 in t42.options do
			table.insert(t43, t1.TextXAlignmentProp_ConditionalOption.jsonDecode(v307))
		end

		v304.options = t43
	end

	return v304
end

t38.descriptor = {
	name = "TextXAlignmentProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}
t1.TextXAlignmentProp_ConditionalOptions = t38
typeRegistry.default:register(t1.TextXAlignmentProp_ConditionalOptions)

local t44 = {}

t44.__index = t44

function t44.new(t45: {[any]: any}?) -- line: 2453
	-- upvalues: t44 (copy)
	return (setmetatable({
		kind = if t45 ~= nil and t45.kind ~= nil then t45.kind else nil
	}, t44))
end
function t44.encode(p28) -- line: 2459
	-- upvalues: proto (copy), t1 (copy)
	local buf = buffer.create(0)
	local n19 = 0

	if p28.kind ~= nil then
		if p28.kind.type == "literal" then
			local v312, v313 = proto.writeTag(buf, n19, 1, proto.wireTypes.varint)

			buf, n19 = proto.writeVarInt(v312, v313, t1.TextYAlignment.toNumber(p28.kind.value))
		elseif p28.kind.type == "binding_path" then
			local v314, v315 = proto.writeTag(buf, n19, 2, proto.wireTypes.lengthDelimited)

			buf, n19 = proto.writeString(v314, v315, p28.kind.value)
		elseif p28.kind.type == "conditional" then
			local v316 = p28.kind.value:encode()
			local v317, v318 = proto.writeTag(buf, n19, 3, proto.wireTypes.lengthDelimited)

			buf, n19 = proto.writeBuffer(v317, v318, v316, buffer.len(v316))
		end
	end

	local buf11 = buffer.create(n19)

	buffer.copy(buf11, 0, buf, 0, n19)

	return buf11
end
function t44.decode(p29: buffer) -- line: 2483
	-- upvalues: t44 (copy), proto (copy), t1 (copy)
	local v321 = t44.new()
	local n20 = 0

	while n20 < buffer.len(p29) do
		local v323, v324

		v323, v324, n20 = proto.readTag(p29, n20)

		if v324 == proto.wireTypes.varint then
			if v323 == 1 then
				local v325

				v325, n20 = proto.readVarIntI32(p29, n20)
				v321.kind = {
					type = "literal",
					value = t1.TextYAlignment.fromNumber(v325) or v325
				}
			else
				local v326

				v326, n20 = proto.readVarInt(p29, n20)
			end
		elseif v324 == proto.wireTypes.lengthDelimited then
			if v323 == 2 then
				local v327

				v327, n20 = proto.readBuffer(p29, n20)
				v321.kind = {
					type = "binding_path",
					value = buffer.tostring(v327)
				}
			elseif v323 == 3 then
				local v328

				v328, n20 = proto.readBuffer(p29, n20)
				v321.kind = {
					type = "conditional",
					value = t1.TextYAlignmentProp_ConditionalOptions.decode(v328)
				}
			else
				local v329, v330 = proto.readVarInt(p29, n20)

				n20 = v330 + v329
			end
		elseif v324 == proto.wireTypes.i32 then
			local v331

			v331, n20 = proto.readFixed32(p29, n20)
		elseif v324 == proto.wireTypes.i64 then
			local v332

			v332, n20 = proto.readFixed64(p29, n20)
		else
			error("Unsupported wire type: " .. v324)
		end
	end

	return v321
end
function t44.jsonEncode(p30) -- line: 2540
	-- upvalues: t1 (copy)
	local t46 = {}

	if p30.kind ~= nil then
		if p30.kind.type == "literal" then
			t46.literal = if typeof(p30.kind.value) ~= "number" then t1.TextYAlignment.toNumber(p30.kind.value) else p30.kind.value

			return t46
		end

		if p30.kind.type == "binding_path" then
			t46.bindingPath = p30.kind.value

			return t46
		end

		if p30.kind.type == "conditional" then
			t46.conditional = p30.kind.value:jsonEncode()
		end
	end

	return t46
end
function t44.jsonDecode(t47: {[any]: any}) -- line: 2558
	-- upvalues: t44 (copy), t1 (copy)
	local v336 = t44.new()

	if t47.literal ~= nil then
		v336.kind = {
			type = "literal",
			value = if typeof(t47.literal) ~= "number" then t1.TextYAlignment.fromName(t47.literal) or t47.literal else t1.TextYAlignment.fromNumber(t47.literal) or t47.literal
		}
	end

	if t47.binding_path ~= nil then
		v336.kind = {
			type = "binding_path",
			value = t47.binding_path
		}
	end

	if t47.bindingPath ~= nil then
		v336.kind = {
			type = "binding_path",
			value = t47.bindingPath
		}
	end

	if t47.conditional ~= nil then
		v336.kind = {
			type = "conditional",
			value = t1.TextYAlignmentProp_ConditionalOptions.jsonDecode(t47.conditional)
		}
	end

	return v336
end

t44.descriptor = {
	name = "TextYAlignmentProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.TextYAlignmentProp"
}
t1.TextYAlignmentProp = t44
typeRegistry.default:register(t1.TextYAlignmentProp)

local t48 = {}

t48.__index = t48

function t48.new(t49: {[any]: any}?) -- line: 2602
	-- upvalues: t48 (copy)
	return (setmetatable({
		condition = if t49 ~= nil and t49.condition ~= nil then t49.condition else nil,
		kind = if t49 ~= nil and t49.kind ~= nil then t49.kind else nil
	}, t48))
end
function t48.encode(p31) -- line: 2611
	-- upvalues: proto (copy), t1 (copy)
	local buf = buffer.create(0)
	local n21 = 0

	if p31.condition ~= nil then
		local v341 = p31.condition:encode()
		local v342, v343 = proto.writeTag(buf, n21, 1, proto.wireTypes.lengthDelimited)

		buf, n21 = proto.writeBuffer(v342, v343, v341, buffer.len(v341))
	end

	if p31.kind ~= nil then
		if p31.kind.type == "literal" then
			local v344, v345 = proto.writeTag(buf, n21, 2, proto.wireTypes.varint)

			buf, n21 = proto.writeVarInt(v344, v345, t1.TextYAlignment.toNumber(p31.kind.value))
		elseif p31.kind.type == "binding_path" then
			local v346, v347 = proto.writeTag(buf, n21, 3, proto.wireTypes.lengthDelimited)

			buf, n21 = proto.writeString(v346, v347, p31.kind.value)
		end
	end

	local buf12 = buffer.create(n21)

	buffer.copy(buf12, 0, buf, 0, n21)

	return buf12
end
function t48.decode(p32: buffer) -- line: 2637
	-- upvalues: t48 (copy), proto (copy), t1 (copy), prop_condition (copy)
	local v350 = t48.new()
	local n22 = 0

	while n22 < buffer.len(p32) do
		local v352, v353

		v352, v353, n22 = proto.readTag(p32, n22)

		if v353 == proto.wireTypes.varint then
			if v352 == 2 then
				local v354

				v354, n22 = proto.readVarIntI32(p32, n22)
				v350.kind = {
					type = "literal",
					value = t1.TextYAlignment.fromNumber(v354) or v354
				}
			else
				local v355

				v355, n22 = proto.readVarInt(p32, n22)
			end
		elseif v353 == proto.wireTypes.lengthDelimited then
			if v352 == 1 then
				local v356

				v356, n22 = proto.readBuffer(p32, n22)
				v350.condition = prop_condition.PropCondition.decode(v356)
			elseif v352 == 3 then
				local v357

				v357, n22 = proto.readBuffer(p32, n22)
				v350.kind = {
					type = "binding_path",
					value = buffer.tostring(v357)
				}
			else
				local v358, v359 = proto.readVarInt(p32, n22)

				n22 = v359 + v358
			end
		elseif v353 == proto.wireTypes.i32 then
			local v360

			v360, n22 = proto.readFixed32(p32, n22)
		elseif v353 == proto.wireTypes.i64 then
			local v361

			v361, n22 = proto.readFixed64(p32, n22)
		else
			error("Unsupported wire type: " .. v353)
		end
	end

	return v350
end
function t48.jsonEncode(p33) -- line: 2693
	-- upvalues: t1 (copy)
	local t50 = {}

	if p33.condition ~= nil then
		t50.condition = p33.condition:jsonEncode()
	end

	if p33.kind ~= nil then
		if p33.kind.type == "literal" then
			t50.literal = if typeof(p33.kind.value) ~= "number" then t1.TextYAlignment.toNumber(p33.kind.value) else p33.kind.value

			return t50
		end

		if p33.kind.type == "binding_path" then
			t50.bindingPath = p33.kind.value
		end
	end

	return t50
end
function t48.jsonDecode(t51: {[any]: any}) -- line: 2713
	-- upvalues: t48 (copy), prop_condition (copy), t1 (copy)
	local v365 = t48.new()

	if t51.condition ~= nil then
		v365.condition = prop_condition.PropCondition.jsonDecode(t51.condition)
	end

	if t51.literal ~= nil then
		v365.kind = {
			type = "literal",
			value = if typeof(t51.literal) ~= "number" then t1.TextYAlignment.fromName(t51.literal) or t51.literal else t1.TextYAlignment.fromNumber(t51.literal) or t51.literal
		}
	end

	if t51.binding_path ~= nil then
		v365.kind = {
			type = "binding_path",
			value = t51.binding_path
		}
	end

	if t51.bindingPath ~= nil then
		v365.kind = {
			type = "binding_path",
			value = t51.bindingPath
		}
	end

	return v365
end

t48.descriptor = {
	name = "TextYAlignmentProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}
t1.TextYAlignmentProp_ConditionalOption = t48
typeRegistry.default:register(t1.TextYAlignmentProp_ConditionalOption)

local t52 = {}

t52.__index = t52

function t52.new(t53: {[any]: any}?) -- line: 2757
	-- upvalues: t52 (copy)
	return (setmetatable({
		options = if t53 ~= nil and t53.options ~= nil then t53.options else {}
	}, t52))
end
function t52.encode(p34) -- line: 2765
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n23 = 0

	if p34.options ~= nil and #p34.options > 0 then
		for _, v371 in p34.options do
			local v372 = v371:encode()
			local v373, v374 = proto.writeTag(buf, n23, 1, proto.wireTypes.lengthDelimited)

			buf, n23 = proto.writeBuffer(v373, v374, v372, buffer.len(v372))
		end
	end

	local buf13 = buffer.create(n23)

	buffer.copy(buf13, 0, buf, 0, n23)

	return buf13
end
function t52.decode(p35: buffer) -- line: 2782
	-- upvalues: t52 (copy), proto (copy), t1 (copy)
	local v377 = t52.new()
	local n24 = 0

	while n24 < buffer.len(p35) do
		local v379, v380

		v379, v380, n24 = proto.readTag(p35, n24)

		if v380 == proto.wireTypes.varint then
			local v381

			v381, n24 = proto.readVarInt(p35, n24)
		elseif v380 == proto.wireTypes.lengthDelimited then
			if v379 == 1 then
				local v382

				v382, n24 = proto.readBuffer(p35, n24)
				table.insert(v377.options, t1.TextYAlignmentProp_ConditionalOption.decode(v382))
			else
				local v383, v384 = proto.readVarInt(p35, n24)

				n24 = v384 + v383
			end
		elseif v380 == proto.wireTypes.i32 then
			local v385

			v385, n24 = proto.readFixed32(p35, n24)
		elseif v380 == proto.wireTypes.i64 then
			local v386

			v386, n24 = proto.readFixed64(p35, n24)
		else
			error("Unsupported wire type: " .. v380)
		end
	end

	return v377
end
function t52.jsonEncode(p36) -- line: 2825
	local t54 = {}

	if p36.options ~= nil and #p36.options > 0 then
		local t55 = {}

		for _, v391 in p36.options do
			table.insert(t55, v391:jsonEncode())
		end

		t54.options = t55
	end

	return t54
end
function t52.jsonDecode(t56: {[any]: any}) -- line: 2839
	-- upvalues: t52 (copy), t1 (copy)
	local v393 = t52.new()

	if t56.options ~= nil then
		local t57 = {}

		for _, v396 in t56.options do
			table.insert(t57, t1.TextYAlignmentProp_ConditionalOption.jsonDecode(v396))
		end

		v393.options = t57
	end

	return v393
end

t52.descriptor = {
	name = "TextYAlignmentProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}
t1.TextYAlignmentProp_ConditionalOptions = t52
typeRegistry.default:register(t1.TextYAlignmentProp_ConditionalOptions)

local t58 = {}

t58.__index = t58

function t58.new(t59: {[any]: any}?) -- line: 2870
	-- upvalues: t58 (copy)
	return (setmetatable({
		kind = if t59 ~= nil and t59.kind ~= nil then t59.kind else nil
	}, t58))
end
function t58.encode(p37) -- line: 2876
	-- upvalues: proto (copy), t1 (copy)
	local buf = buffer.create(0)
	local n25 = 0

	if p37.kind ~= nil then
		if p37.kind.type == "literal" then
			local v401, v402 = proto.writeTag(buf, n25, 1, proto.wireTypes.varint)

			buf, n25 = proto.writeVarInt(v401, v402, t1.UIFlexMode.toNumber(p37.kind.value))
		elseif p37.kind.type == "binding_path" then
			local v403, v404 = proto.writeTag(buf, n25, 2, proto.wireTypes.lengthDelimited)

			buf, n25 = proto.writeString(v403, v404, p37.kind.value)
		elseif p37.kind.type == "conditional" then
			local v405 = p37.kind.value:encode()
			local v406, v407 = proto.writeTag(buf, n25, 3, proto.wireTypes.lengthDelimited)

			buf, n25 = proto.writeBuffer(v406, v407, v405, buffer.len(v405))
		end
	end

	local buf14 = buffer.create(n25)

	buffer.copy(buf14, 0, buf, 0, n25)

	return buf14
end
function t58.decode(p38: buffer) -- line: 2899
	-- upvalues: t58 (copy), proto (copy), t1 (copy)
	local v410 = t58.new()
	local n26 = 0

	while n26 < buffer.len(p38) do
		local v412, v413

		v412, v413, n26 = proto.readTag(p38, n26)

		if v413 == proto.wireTypes.varint then
			if v412 == 1 then
				local v414

				v414, n26 = proto.readVarIntI32(p38, n26)
				v410.kind = {
					type = "literal",
					value = t1.UIFlexMode.fromNumber(v414) or v414
				}
			else
				local v415

				v415, n26 = proto.readVarInt(p38, n26)
			end
		elseif v413 == proto.wireTypes.lengthDelimited then
			if v412 == 2 then
				local v416

				v416, n26 = proto.readBuffer(p38, n26)
				v410.kind = {
					type = "binding_path",
					value = buffer.tostring(v416)
				}
			elseif v412 == 3 then
				local v417

				v417, n26 = proto.readBuffer(p38, n26)
				v410.kind = {
					type = "conditional",
					value = t1.UIFlexModeProp_ConditionalOptions.decode(v417)
				}
			else
				local v418, v419 = proto.readVarInt(p38, n26)

				n26 = v419 + v418
			end
		elseif v413 == proto.wireTypes.i32 then
			local v420

			v420, n26 = proto.readFixed32(p38, n26)
		elseif v413 == proto.wireTypes.i64 then
			local v421

			v421, n26 = proto.readFixed64(p38, n26)
		else
			error("Unsupported wire type: " .. v413)
		end
	end

	return v410
end
function t58.jsonEncode(p39) -- line: 2956
	-- upvalues: t1 (copy)
	local t60 = {}

	if p39.kind ~= nil then
		if p39.kind.type == "literal" then
			t60.literal = if typeof(p39.kind.value) ~= "number" then t1.UIFlexMode.toNumber(p39.kind.value) else p39.kind.value

			return t60
		end

		if p39.kind.type == "binding_path" then
			t60.bindingPath = p39.kind.value

			return t60
		end

		if p39.kind.type == "conditional" then
			t60.conditional = p39.kind.value:jsonEncode()
		end
	end

	return t60
end
function t58.jsonDecode(t61: {[any]: any}) -- line: 2974
	-- upvalues: t58 (copy), t1 (copy)
	local v425 = t58.new()

	if t61.literal ~= nil then
		v425.kind = {
			type = "literal",
			value = if typeof(t61.literal) ~= "number" then t1.UIFlexMode.fromName(t61.literal) or t61.literal else t1.UIFlexMode.fromNumber(t61.literal) or t61.literal
		}
	end

	if t61.binding_path ~= nil then
		v425.kind = {
			type = "binding_path",
			value = t61.binding_path
		}
	end

	if t61.bindingPath ~= nil then
		v425.kind = {
			type = "binding_path",
			value = t61.bindingPath
		}
	end

	if t61.conditional ~= nil then
		v425.kind = {
			type = "conditional",
			value = t1.UIFlexModeProp_ConditionalOptions.jsonDecode(t61.conditional)
		}
	end

	return v425
end

t58.descriptor = {
	name = "UIFlexModeProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.UIFlexModeProp"
}
t1.UIFlexModeProp = t58
typeRegistry.default:register(t1.UIFlexModeProp)

local t62 = {}

t62.__index = t62

function t62.new(t63: {[any]: any}?) -- line: 3018
	-- upvalues: t62 (copy)
	return (setmetatable({
		condition = if t63 ~= nil and t63.condition ~= nil then t63.condition else nil,
		kind = if t63 ~= nil and t63.kind ~= nil then t63.kind else nil
	}, t62))
end
function t62.encode(p40) -- line: 3027
	-- upvalues: proto (copy), t1 (copy)
	local buf = buffer.create(0)
	local n27 = 0

	if p40.condition ~= nil then
		local v430 = p40.condition:encode()
		local v431, v432 = proto.writeTag(buf, n27, 1, proto.wireTypes.lengthDelimited)

		buf, n27 = proto.writeBuffer(v431, v432, v430, buffer.len(v430))
	end

	if p40.kind ~= nil then
		if p40.kind.type == "literal" then
			local v433, v434 = proto.writeTag(buf, n27, 2, proto.wireTypes.varint)

			buf, n27 = proto.writeVarInt(v433, v434, t1.UIFlexMode.toNumber(p40.kind.value))
		elseif p40.kind.type == "binding_path" then
			local v435, v436 = proto.writeTag(buf, n27, 3, proto.wireTypes.lengthDelimited)

			buf, n27 = proto.writeString(v435, v436, p40.kind.value)
		end
	end

	local buf15 = buffer.create(n27)

	buffer.copy(buf15, 0, buf, 0, n27)

	return buf15
end
function t62.decode(p41: buffer) -- line: 3052
	-- upvalues: t62 (copy), proto (copy), t1 (copy), prop_condition (copy)
	local v439 = t62.new()
	local n28 = 0

	while n28 < buffer.len(p41) do
		local v441, v442

		v441, v442, n28 = proto.readTag(p41, n28)

		if v442 == proto.wireTypes.varint then
			if v441 == 2 then
				local v443

				v443, n28 = proto.readVarIntI32(p41, n28)
				v439.kind = {
					type = "literal",
					value = t1.UIFlexMode.fromNumber(v443) or v443
				}
			else
				local v444

				v444, n28 = proto.readVarInt(p41, n28)
			end
		elseif v442 == proto.wireTypes.lengthDelimited then
			if v441 == 1 then
				local v445

				v445, n28 = proto.readBuffer(p41, n28)
				v439.condition = prop_condition.PropCondition.decode(v445)
			elseif v441 == 3 then
				local v446

				v446, n28 = proto.readBuffer(p41, n28)
				v439.kind = {
					type = "binding_path",
					value = buffer.tostring(v446)
				}
			else
				local v447, v448 = proto.readVarInt(p41, n28)

				n28 = v448 + v447
			end
		elseif v442 == proto.wireTypes.i32 then
			local v449

			v449, n28 = proto.readFixed32(p41, n28)
		elseif v442 == proto.wireTypes.i64 then
			local v450

			v450, n28 = proto.readFixed64(p41, n28)
		else
			error("Unsupported wire type: " .. v442)
		end
	end

	return v439
end
function t62.jsonEncode(p42) -- line: 3108
	-- upvalues: t1 (copy)
	local t64 = {}

	if p42.condition ~= nil then
		t64.condition = p42.condition:jsonEncode()
	end

	if p42.kind ~= nil then
		if p42.kind.type == "literal" then
			t64.literal = if typeof(p42.kind.value) ~= "number" then t1.UIFlexMode.toNumber(p42.kind.value) else p42.kind.value

			return t64
		end

		if p42.kind.type == "binding_path" then
			t64.bindingPath = p42.kind.value
		end
	end

	return t64
end
function t62.jsonDecode(t65: {[any]: any}) -- line: 3128
	-- upvalues: t62 (copy), prop_condition (copy), t1 (copy)
	local v454 = t62.new()

	if t65.condition ~= nil then
		v454.condition = prop_condition.PropCondition.jsonDecode(t65.condition)
	end

	if t65.literal ~= nil then
		v454.kind = {
			type = "literal",
			value = if typeof(t65.literal) ~= "number" then t1.UIFlexMode.fromName(t65.literal) or t65.literal else t1.UIFlexMode.fromNumber(t65.literal) or t65.literal
		}
	end

	if t65.binding_path ~= nil then
		v454.kind = {
			type = "binding_path",
			value = t65.binding_path
		}
	end

	if t65.bindingPath ~= nil then
		v454.kind = {
			type = "binding_path",
			value = t65.bindingPath
		}
	end

	return v454
end

t62.descriptor = {
	name = "UIFlexModeProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}
t1.UIFlexModeProp_ConditionalOption = t62
typeRegistry.default:register(t1.UIFlexModeProp_ConditionalOption)

local t66 = {}

t66.__index = t66

function t66.new(t67: {[any]: any}?) -- line: 3172
	-- upvalues: t66 (copy)
	return (setmetatable({
		options = if t67 ~= nil and t67.options ~= nil then t67.options else {}
	}, t66))
end
function t66.encode(p43) -- line: 3180
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n29 = 0

	if p43.options ~= nil and #p43.options > 0 then
		for _, v460 in p43.options do
			local v461 = v460:encode()
			local v462, v463 = proto.writeTag(buf, n29, 1, proto.wireTypes.lengthDelimited)

			buf, n29 = proto.writeBuffer(v462, v463, v461, buffer.len(v461))
		end
	end

	local buf16 = buffer.create(n29)

	buffer.copy(buf16, 0, buf, 0, n29)

	return buf16
end
function t66.decode(p44: buffer) -- line: 3197
	-- upvalues: t66 (copy), proto (copy), t1 (copy)
	local v466 = t66.new()
	local n30 = 0

	while n30 < buffer.len(p44) do
		local v468, v469

		v468, v469, n30 = proto.readTag(p44, n30)

		if v469 == proto.wireTypes.varint then
			local v470

			v470, n30 = proto.readVarInt(p44, n30)
		elseif v469 == proto.wireTypes.lengthDelimited then
			if v468 == 1 then
				local v471

				v471, n30 = proto.readBuffer(p44, n30)
				table.insert(v466.options, t1.UIFlexModeProp_ConditionalOption.decode(v471))
			else
				local v472, v473 = proto.readVarInt(p44, n30)

				n30 = v473 + v472
			end
		elseif v469 == proto.wireTypes.i32 then
			local v474

			v474, n30 = proto.readFixed32(p44, n30)
		elseif v469 == proto.wireTypes.i64 then
			local v475

			v475, n30 = proto.readFixed64(p44, n30)
		else
			error("Unsupported wire type: " .. v469)
		end
	end

	return v466
end
function t66.jsonEncode(p45) -- line: 3240
	local t68 = {}

	if p45.options ~= nil and #p45.options > 0 then
		local t69 = {}

		for _, v480 in p45.options do
			table.insert(t69, v480:jsonEncode())
		end

		t68.options = t69
	end

	return t68
end
function t66.jsonDecode(t70: {[any]: any}) -- line: 3254
	-- upvalues: t66 (copy), t1 (copy)
	local v482 = t66.new()

	if t70.options ~= nil then
		local t71 = {}

		for _, v485 in t70.options do
			table.insert(t71, t1.UIFlexModeProp_ConditionalOption.jsonDecode(v485))
		end

		v482.options = t71
	end

	return v482
end

t66.descriptor = {
	name = "UIFlexModeProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}
t1.UIFlexModeProp_ConditionalOptions = t66
typeRegistry.default:register(t1.UIFlexModeProp_ConditionalOptions)

local t72 = {}

t72.__index = t72

function t72.new(t73: {[any]: any}?) -- line: 3285
	-- upvalues: t72 (copy)
	return (setmetatable({
		kind = if t73 ~= nil and t73.kind ~= nil then t73.kind else nil
	}, t72))
end
function t72.encode(p46) -- line: 3291
	-- upvalues: proto (copy), t1 (copy)
	local buf = buffer.create(0)
	local n31 = 0

	if p46.kind ~= nil then
		if p46.kind.type == "literal" then
			local v490, v491 = proto.writeTag(buf, n31, 1, proto.wireTypes.varint)

			buf, n31 = proto.writeVarInt(v490, v491, t1.ScaleType.toNumber(p46.kind.value))
		elseif p46.kind.type == "binding_path" then
			local v492, v493 = proto.writeTag(buf, n31, 2, proto.wireTypes.lengthDelimited)

			buf, n31 = proto.writeString(v492, v493, p46.kind.value)
		elseif p46.kind.type == "conditional" then
			local v494 = p46.kind.value:encode()
			local v495, v496 = proto.writeTag(buf, n31, 3, proto.wireTypes.lengthDelimited)

			buf, n31 = proto.writeBuffer(v495, v496, v494, buffer.len(v494))
		end
	end

	local buf17 = buffer.create(n31)

	buffer.copy(buf17, 0, buf, 0, n31)

	return buf17
end
function t72.decode(p47: buffer) -- line: 3314
	-- upvalues: t72 (copy), proto (copy), t1 (copy)
	local v499 = t72.new()
	local n32 = 0

	while n32 < buffer.len(p47) do
		local v501, v502

		v501, v502, n32 = proto.readTag(p47, n32)

		if v502 == proto.wireTypes.varint then
			if v501 == 1 then
				local v503

				v503, n32 = proto.readVarIntI32(p47, n32)
				v499.kind = {
					type = "literal",
					value = t1.ScaleType.fromNumber(v503) or v503
				}
			else
				local v504

				v504, n32 = proto.readVarInt(p47, n32)
			end
		elseif v502 == proto.wireTypes.lengthDelimited then
			if v501 == 2 then
				local v505

				v505, n32 = proto.readBuffer(p47, n32)
				v499.kind = {
					type = "binding_path",
					value = buffer.tostring(v505)
				}
			elseif v501 == 3 then
				local v506

				v506, n32 = proto.readBuffer(p47, n32)
				v499.kind = {
					type = "conditional",
					value = t1.ScaleTypeProp_ConditionalOptions.decode(v506)
				}
			else
				local v507, v508 = proto.readVarInt(p47, n32)

				n32 = v508 + v507
			end
		elseif v502 == proto.wireTypes.i32 then
			local v509

			v509, n32 = proto.readFixed32(p47, n32)
		elseif v502 == proto.wireTypes.i64 then
			local v510

			v510, n32 = proto.readFixed64(p47, n32)
		else
			error("Unsupported wire type: " .. v502)
		end
	end

	return v499
end
function t72.jsonEncode(p48) -- line: 3371
	-- upvalues: t1 (copy)
	local t74 = {}

	if p48.kind ~= nil then
		if p48.kind.type == "literal" then
			t74.literal = if typeof(p48.kind.value) ~= "number" then t1.ScaleType.toNumber(p48.kind.value) else p48.kind.value

			return t74
		end

		if p48.kind.type == "binding_path" then
			t74.bindingPath = p48.kind.value

			return t74
		end

		if p48.kind.type == "conditional" then
			t74.conditional = p48.kind.value:jsonEncode()
		end
	end

	return t74
end
function t72.jsonDecode(t75: {[any]: any}) -- line: 3389
	-- upvalues: t72 (copy), t1 (copy)
	local v514 = t72.new()

	if t75.literal ~= nil then
		v514.kind = {
			type = "literal",
			value = if typeof(t75.literal) ~= "number" then t1.ScaleType.fromName(t75.literal) or t75.literal else t1.ScaleType.fromNumber(t75.literal) or t75.literal
		}
	end

	if t75.binding_path ~= nil then
		v514.kind = {
			type = "binding_path",
			value = t75.binding_path
		}
	end

	if t75.bindingPath ~= nil then
		v514.kind = {
			type = "binding_path",
			value = t75.bindingPath
		}
	end

	if t75.conditional ~= nil then
		v514.kind = {
			type = "conditional",
			value = t1.ScaleTypeProp_ConditionalOptions.jsonDecode(t75.conditional)
		}
	end

	return v514
end

t72.descriptor = {
	name = "ScaleTypeProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.ScaleTypeProp"
}
t1.ScaleTypeProp = t72
typeRegistry.default:register(t1.ScaleTypeProp)

local t76 = {}

t76.__index = t76

function t76.new(t77: {[any]: any}?) -- line: 3433
	-- upvalues: t76 (copy)
	return (setmetatable({
		condition = if t77 ~= nil and t77.condition ~= nil then t77.condition else nil,
		kind = if t77 ~= nil and t77.kind ~= nil then t77.kind else nil
	}, t76))
end
function t76.encode(p49) -- line: 3442
	-- upvalues: proto (copy), t1 (copy)
	local buf = buffer.create(0)
	local n33 = 0

	if p49.condition ~= nil then
		local v519 = p49.condition:encode()
		local v520, v521 = proto.writeTag(buf, n33, 1, proto.wireTypes.lengthDelimited)

		buf, n33 = proto.writeBuffer(v520, v521, v519, buffer.len(v519))
	end

	if p49.kind ~= nil then
		if p49.kind.type == "literal" then
			local v522, v523 = proto.writeTag(buf, n33, 2, proto.wireTypes.varint)

			buf, n33 = proto.writeVarInt(v522, v523, t1.ScaleType.toNumber(p49.kind.value))
		elseif p49.kind.type == "binding_path" then
			local v524, v525 = proto.writeTag(buf, n33, 3, proto.wireTypes.lengthDelimited)

			buf, n33 = proto.writeString(v524, v525, p49.kind.value)
		end
	end

	local buf18 = buffer.create(n33)

	buffer.copy(buf18, 0, buf, 0, n33)

	return buf18
end
function t76.decode(p50: buffer) -- line: 3467
	-- upvalues: t76 (copy), proto (copy), t1 (copy), prop_condition (copy)
	local v528 = t76.new()
	local n34 = 0

	while n34 < buffer.len(p50) do
		local v530, v531

		v530, v531, n34 = proto.readTag(p50, n34)

		if v531 == proto.wireTypes.varint then
			if v530 == 2 then
				local v532

				v532, n34 = proto.readVarIntI32(p50, n34)
				v528.kind = {
					type = "literal",
					value = t1.ScaleType.fromNumber(v532) or v532
				}
			else
				local v533

				v533, n34 = proto.readVarInt(p50, n34)
			end
		elseif v531 == proto.wireTypes.lengthDelimited then
			if v530 == 1 then
				local v534

				v534, n34 = proto.readBuffer(p50, n34)
				v528.condition = prop_condition.PropCondition.decode(v534)
			elseif v530 == 3 then
				local v535

				v535, n34 = proto.readBuffer(p50, n34)
				v528.kind = {
					type = "binding_path",
					value = buffer.tostring(v535)
				}
			else
				local v536, v537 = proto.readVarInt(p50, n34)

				n34 = v537 + v536
			end
		elseif v531 == proto.wireTypes.i32 then
			local v538

			v538, n34 = proto.readFixed32(p50, n34)
		elseif v531 == proto.wireTypes.i64 then
			local v539

			v539, n34 = proto.readFixed64(p50, n34)
		else
			error("Unsupported wire type: " .. v531)
		end
	end

	return v528
end
function t76.jsonEncode(p51) -- line: 3523
	-- upvalues: t1 (copy)
	local t78 = {}

	if p51.condition ~= nil then
		t78.condition = p51.condition:jsonEncode()
	end

	if p51.kind ~= nil then
		if p51.kind.type == "literal" then
			t78.literal = if typeof(p51.kind.value) ~= "number" then t1.ScaleType.toNumber(p51.kind.value) else p51.kind.value

			return t78
		end

		if p51.kind.type == "binding_path" then
			t78.bindingPath = p51.kind.value
		end
	end

	return t78
end
function t76.jsonDecode(t79: {[any]: any}) -- line: 3543
	-- upvalues: t76 (copy), prop_condition (copy), t1 (copy)
	local v543 = t76.new()

	if t79.condition ~= nil then
		v543.condition = prop_condition.PropCondition.jsonDecode(t79.condition)
	end

	if t79.literal ~= nil then
		v543.kind = {
			type = "literal",
			value = if typeof(t79.literal) ~= "number" then t1.ScaleType.fromName(t79.literal) or t79.literal else t1.ScaleType.fromNumber(t79.literal) or t79.literal
		}
	end

	if t79.binding_path ~= nil then
		v543.kind = {
			type = "binding_path",
			value = t79.binding_path
		}
	end

	if t79.bindingPath ~= nil then
		v543.kind = {
			type = "binding_path",
			value = t79.bindingPath
		}
	end

	return v543
end

t76.descriptor = {
	name = "ScaleTypeProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}
t1.ScaleTypeProp_ConditionalOption = t76
typeRegistry.default:register(t1.ScaleTypeProp_ConditionalOption)

local t80 = {}

t80.__index = t80

function t80.new(t81: {[any]: any}?) -- line: 3585
	-- upvalues: t80 (copy)
	return (setmetatable({
		options = if t81 ~= nil and t81.options ~= nil then t81.options else {}
	}, t80))
end
function t80.encode(p52) -- line: 3593
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n35 = 0

	if p52.options ~= nil and #p52.options > 0 then
		for _, v549 in p52.options do
			local v550 = v549:encode()
			local v551, v552 = proto.writeTag(buf, n35, 1, proto.wireTypes.lengthDelimited)

			buf, n35 = proto.writeBuffer(v551, v552, v550, buffer.len(v550))
		end
	end

	local buf19 = buffer.create(n35)

	buffer.copy(buf19, 0, buf, 0, n35)

	return buf19
end
function t80.decode(p53: buffer) -- line: 3610
	-- upvalues: t80 (copy), proto (copy), t1 (copy)
	local v555 = t80.new()
	local n36 = 0

	while n36 < buffer.len(p53) do
		local v557, v558

		v557, v558, n36 = proto.readTag(p53, n36)

		if v558 == proto.wireTypes.varint then
			local v559

			v559, n36 = proto.readVarInt(p53, n36)
		elseif v558 == proto.wireTypes.lengthDelimited then
			if v557 == 1 then
				local v560

				v560, n36 = proto.readBuffer(p53, n36)
				table.insert(v555.options, t1.ScaleTypeProp_ConditionalOption.decode(v560))
			else
				local v561, v562 = proto.readVarInt(p53, n36)

				n36 = v562 + v561
			end
		elseif v558 == proto.wireTypes.i32 then
			local v563

			v563, n36 = proto.readFixed32(p53, n36)
		elseif v558 == proto.wireTypes.i64 then
			local v564

			v564, n36 = proto.readFixed64(p53, n36)
		else
			error("Unsupported wire type: " .. v558)
		end
	end

	return v555
end
function t80.jsonEncode(p54) -- line: 3653
	local t82 = {}

	if p54.options ~= nil and #p54.options > 0 then
		local t83 = {}

		for _, v569 in p54.options do
			table.insert(t83, v569:jsonEncode())
		end

		t82.options = t83
	end

	return t82
end
function t80.jsonDecode(t84: {[any]: any}) -- line: 3667
	-- upvalues: t80 (copy), t1 (copy)
	local v571 = t80.new()

	if t84.options ~= nil then
		local t85 = {}

		for _, v574 in t84.options do
			table.insert(t85, t1.ScaleTypeProp_ConditionalOption.jsonDecode(v574))
		end

		v571.options = t85
	end

	return v571
end

t80.descriptor = {
	name = "ScaleTypeProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}
t1.ScaleTypeProp_ConditionalOptions = t80
typeRegistry.default:register(t1.ScaleTypeProp_ConditionalOptions)

local t86 = {}

t86.__index = t86

function t86.new(t87: {[any]: any}?) -- line: 3698
	-- upvalues: t86 (copy)
	return (setmetatable({
		kind = if t87 ~= nil and t87.kind ~= nil then t87.kind else nil
	}, t86))
end
function t86.encode(p55) -- line: 3704
	-- upvalues: proto (copy), t1 (copy)
	local buf = buffer.create(0)
	local n37 = 0

	if p55.kind ~= nil then
		if p55.kind.type == "literal" then
			local v579, v580 = proto.writeTag(buf, n37, 1, proto.wireTypes.varint)

			buf, n37 = proto.writeVarInt(v579, v580, t1.ResamplerMode.toNumber(p55.kind.value))
		elseif p55.kind.type == "binding_path" then
			local v581, v582 = proto.writeTag(buf, n37, 2, proto.wireTypes.lengthDelimited)

			buf, n37 = proto.writeString(v581, v582, p55.kind.value)
		elseif p55.kind.type == "conditional" then
			local v583 = p55.kind.value:encode()
			local v584, v585 = proto.writeTag(buf, n37, 3, proto.wireTypes.lengthDelimited)

			buf, n37 = proto.writeBuffer(v584, v585, v583, buffer.len(v583))
		end
	end

	local buf20 = buffer.create(n37)

	buffer.copy(buf20, 0, buf, 0, n37)

	return buf20
end
function t86.decode(p56: buffer) -- line: 3728
	-- upvalues: t86 (copy), proto (copy), t1 (copy)
	local v588 = t86.new()
	local n38 = 0

	while n38 < buffer.len(p56) do
		local v590, v591

		v590, v591, n38 = proto.readTag(p56, n38)

		if v591 == proto.wireTypes.varint then
			if v590 == 1 then
				local v592

				v592, n38 = proto.readVarIntI32(p56, n38)
				v588.kind = {
					type = "literal",
					value = t1.ResamplerMode.fromNumber(v592) or v592
				}
			else
				local v593

				v593, n38 = proto.readVarInt(p56, n38)
			end
		elseif v591 == proto.wireTypes.lengthDelimited then
			if v590 == 2 then
				local v594

				v594, n38 = proto.readBuffer(p56, n38)
				v588.kind = {
					type = "binding_path",
					value = buffer.tostring(v594)
				}
			elseif v590 == 3 then
				local v595

				v595, n38 = proto.readBuffer(p56, n38)
				v588.kind = {
					type = "conditional",
					value = t1.ResamplerModeProp_ConditionalOptions.decode(v595)
				}
			else
				local v596, v597 = proto.readVarInt(p56, n38)

				n38 = v597 + v596
			end
		elseif v591 == proto.wireTypes.i32 then
			local v598

			v598, n38 = proto.readFixed32(p56, n38)
		elseif v591 == proto.wireTypes.i64 then
			local v599

			v599, n38 = proto.readFixed64(p56, n38)
		else
			error("Unsupported wire type: " .. v591)
		end
	end

	return v588
end
function t86.jsonEncode(p57) -- line: 3785
	-- upvalues: t1 (copy)
	local t88 = {}

	if p57.kind ~= nil then
		if p57.kind.type == "literal" then
			t88.literal = if typeof(p57.kind.value) ~= "number" then t1.ResamplerMode.toNumber(p57.kind.value) else p57.kind.value

			return t88
		end

		if p57.kind.type == "binding_path" then
			t88.bindingPath = p57.kind.value

			return t88
		end

		if p57.kind.type == "conditional" then
			t88.conditional = p57.kind.value:jsonEncode()
		end
	end

	return t88
end
function t86.jsonDecode(t89: {[any]: any}) -- line: 3803
	-- upvalues: t86 (copy), t1 (copy)
	local v603 = t86.new()

	if t89.literal ~= nil then
		v603.kind = {
			type = "literal",
			value = if typeof(t89.literal) ~= "number" then t1.ResamplerMode.fromName(t89.literal) or t89.literal else t1.ResamplerMode.fromNumber(t89.literal) or t89.literal
		}
	end

	if t89.binding_path ~= nil then
		v603.kind = {
			type = "binding_path",
			value = t89.binding_path
		}
	end

	if t89.bindingPath ~= nil then
		v603.kind = {
			type = "binding_path",
			value = t89.bindingPath
		}
	end

	if t89.conditional ~= nil then
		v603.kind = {
			type = "conditional",
			value = t1.ResamplerModeProp_ConditionalOptions.jsonDecode(t89.conditional)
		}
	end

	return v603
end

t86.descriptor = {
	name = "ResamplerModeProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.ResamplerModeProp"
}
t1.ResamplerModeProp = t86
typeRegistry.default:register(t1.ResamplerModeProp)

local t90 = {}

t90.__index = t90

function t90.new(t91: {[any]: any}?) -- line: 3847
	-- upvalues: t90 (copy)
	return (setmetatable({
		condition = if t91 ~= nil and t91.condition ~= nil then t91.condition else nil,
		kind = if t91 ~= nil and t91.kind ~= nil then t91.kind else nil
	}, t90))
end
function t90.encode(p58) -- line: 3856
	-- upvalues: proto (copy), t1 (copy)
	local buf = buffer.create(0)
	local n39 = 0

	if p58.condition ~= nil then
		local v608 = p58.condition:encode()
		local v609, v610 = proto.writeTag(buf, n39, 1, proto.wireTypes.lengthDelimited)

		buf, n39 = proto.writeBuffer(v609, v610, v608, buffer.len(v608))
	end

	if p58.kind ~= nil then
		if p58.kind.type == "literal" then
			local v611, v612 = proto.writeTag(buf, n39, 2, proto.wireTypes.varint)

			buf, n39 = proto.writeVarInt(v611, v612, t1.ResamplerMode.toNumber(p58.kind.value))
		elseif p58.kind.type == "binding_path" then
			local v613, v614 = proto.writeTag(buf, n39, 3, proto.wireTypes.lengthDelimited)

			buf, n39 = proto.writeString(v613, v614, p58.kind.value)
		end
	end

	local buf21 = buffer.create(n39)

	buffer.copy(buf21, 0, buf, 0, n39)

	return buf21
end
function t90.decode(p59: buffer) -- line: 3882
	-- upvalues: t90 (copy), proto (copy), t1 (copy), prop_condition (copy)
	local v617 = t90.new()
	local n40 = 0

	while n40 < buffer.len(p59) do
		local v619, v620

		v619, v620, n40 = proto.readTag(p59, n40)

		if v620 == proto.wireTypes.varint then
			if v619 == 2 then
				local v621

				v621, n40 = proto.readVarIntI32(p59, n40)
				v617.kind = {
					type = "literal",
					value = t1.ResamplerMode.fromNumber(v621) or v621
				}
			else
				local v622

				v622, n40 = proto.readVarInt(p59, n40)
			end
		elseif v620 == proto.wireTypes.lengthDelimited then
			if v619 == 1 then
				local v623

				v623, n40 = proto.readBuffer(p59, n40)
				v617.condition = prop_condition.PropCondition.decode(v623)
			elseif v619 == 3 then
				local v624

				v624, n40 = proto.readBuffer(p59, n40)
				v617.kind = {
					type = "binding_path",
					value = buffer.tostring(v624)
				}
			else
				local v625, v626 = proto.readVarInt(p59, n40)

				n40 = v626 + v625
			end
		elseif v620 == proto.wireTypes.i32 then
			local v627

			v627, n40 = proto.readFixed32(p59, n40)
		elseif v620 == proto.wireTypes.i64 then
			local v628

			v628, n40 = proto.readFixed64(p59, n40)
		else
			error("Unsupported wire type: " .. v620)
		end
	end

	return v617
end
function t90.jsonEncode(p60) -- line: 3938
	-- upvalues: t1 (copy)
	local t92 = {}

	if p60.condition ~= nil then
		t92.condition = p60.condition:jsonEncode()
	end

	if p60.kind ~= nil then
		if p60.kind.type == "literal" then
			t92.literal = if typeof(p60.kind.value) ~= "number" then t1.ResamplerMode.toNumber(p60.kind.value) else p60.kind.value

			return t92
		end

		if p60.kind.type == "binding_path" then
			t92.bindingPath = p60.kind.value
		end
	end

	return t92
end
function t90.jsonDecode(t93: {[any]: any}) -- line: 3958
	-- upvalues: t90 (copy), prop_condition (copy), t1 (copy)
	local v632 = t90.new()

	if t93.condition ~= nil then
		v632.condition = prop_condition.PropCondition.jsonDecode(t93.condition)
	end

	if t93.literal ~= nil then
		v632.kind = {
			type = "literal",
			value = if typeof(t93.literal) ~= "number" then t1.ResamplerMode.fromName(t93.literal) or t93.literal else t1.ResamplerMode.fromNumber(t93.literal) or t93.literal
		}
	end

	if t93.binding_path ~= nil then
		v632.kind = {
			type = "binding_path",
			value = t93.binding_path
		}
	end

	if t93.bindingPath ~= nil then
		v632.kind = {
			type = "binding_path",
			value = t93.bindingPath
		}
	end

	return v632
end

t90.descriptor = {
	name = "ResamplerModeProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}
t1.ResamplerModeProp_ConditionalOption = t90
typeRegistry.default:register(t1.ResamplerModeProp_ConditionalOption)

local t94 = {}

t94.__index = t94

function t94.new(t95: {[any]: any}?) -- line: 4002
	-- upvalues: t94 (copy)
	return (setmetatable({
		options = if t95 ~= nil and t95.options ~= nil then t95.options else {}
	}, t94))
end
function t94.encode(p61) -- line: 4010
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n41 = 0

	if p61.options ~= nil and #p61.options > 0 then
		for _, v638 in p61.options do
			local v639 = v638:encode()
			local v640, v641 = proto.writeTag(buf, n41, 1, proto.wireTypes.lengthDelimited)

			buf, n41 = proto.writeBuffer(v640, v641, v639, buffer.len(v639))
		end
	end

	local buf22 = buffer.create(n41)

	buffer.copy(buf22, 0, buf, 0, n41)

	return buf22
end
function t94.decode(p62: buffer) -- line: 4027
	-- upvalues: t94 (copy), proto (copy), t1 (copy)
	local v644 = t94.new()
	local n42 = 0

	while n42 < buffer.len(p62) do
		local v646, v647

		v646, v647, n42 = proto.readTag(p62, n42)

		if v647 == proto.wireTypes.varint then
			local v648

			v648, n42 = proto.readVarInt(p62, n42)
		elseif v647 == proto.wireTypes.lengthDelimited then
			if v646 == 1 then
				local v649

				v649, n42 = proto.readBuffer(p62, n42)
				table.insert(v644.options, t1.ResamplerModeProp_ConditionalOption.decode(v649))
			else
				local v650, v651 = proto.readVarInt(p62, n42)

				n42 = v651 + v650
			end
		elseif v647 == proto.wireTypes.i32 then
			local v652

			v652, n42 = proto.readFixed32(p62, n42)
		elseif v647 == proto.wireTypes.i64 then
			local v653

			v653, n42 = proto.readFixed64(p62, n42)
		else
			error("Unsupported wire type: " .. v647)
		end
	end

	return v644
end
function t94.jsonEncode(p63) -- line: 4070
	local t96 = {}

	if p63.options ~= nil and #p63.options > 0 then
		local t97 = {}

		for _, v658 in p63.options do
			table.insert(t97, v658:jsonEncode())
		end

		t96.options = t97
	end

	return t96
end
function t94.jsonDecode(t98: {[any]: any}) -- line: 4084
	-- upvalues: t94 (copy), t1 (copy)
	local v660 = t94.new()

	if t98.options ~= nil then
		local t99 = {}

		for _, v663 in t98.options do
			table.insert(t99, t1.ResamplerModeProp_ConditionalOption.jsonDecode(v663))
		end

		v660.options = t99
	end

	return v660
end

t94.descriptor = {
	name = "ResamplerModeProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}
t1.ResamplerModeProp_ConditionalOptions = t94
typeRegistry.default:register(t1.ResamplerModeProp_ConditionalOptions)

local t100 = {}

t100.__index = t100

function t100.new(t101: {[any]: any}?) -- line: 4115
	-- upvalues: t100 (copy)
	return (setmetatable({
		kind = if t101 ~= nil and t101.kind ~= nil then t101.kind else nil
	}, t100))
end
function t100.encode(p64) -- line: 4121
	-- upvalues: proto (copy), t1 (copy)
	local buf = buffer.create(0)
	local n43 = 0

	if p64.kind ~= nil then
		if p64.kind.type == "literal" then
			local v668, v669 = proto.writeTag(buf, n43, 1, proto.wireTypes.varint)

			buf, n43 = proto.writeVarInt(v668, v669, t1.SizeConstraint.toNumber(p64.kind.value))
		elseif p64.kind.type == "binding_path" then
			local v670, v671 = proto.writeTag(buf, n43, 2, proto.wireTypes.lengthDelimited)

			buf, n43 = proto.writeString(v670, v671, p64.kind.value)
		elseif p64.kind.type == "conditional" then
			local v672 = p64.kind.value:encode()
			local v673, v674 = proto.writeTag(buf, n43, 3, proto.wireTypes.lengthDelimited)

			buf, n43 = proto.writeBuffer(v673, v674, v672, buffer.len(v672))
		end
	end

	local buf23 = buffer.create(n43)

	buffer.copy(buf23, 0, buf, 0, n43)

	return buf23
end
function t100.decode(p65: buffer) -- line: 4145
	-- upvalues: t100 (copy), proto (copy), t1 (copy)
	local v677 = t100.new()
	local n44 = 0

	while n44 < buffer.len(p65) do
		local v679, v680

		v679, v680, n44 = proto.readTag(p65, n44)

		if v680 == proto.wireTypes.varint then
			if v679 == 1 then
				local v681

				v681, n44 = proto.readVarIntI32(p65, n44)
				v677.kind = {
					type = "literal",
					value = t1.SizeConstraint.fromNumber(v681) or v681
				}
			else
				local v682

				v682, n44 = proto.readVarInt(p65, n44)
			end
		elseif v680 == proto.wireTypes.lengthDelimited then
			if v679 == 2 then
				local v683

				v683, n44 = proto.readBuffer(p65, n44)
				v677.kind = {
					type = "binding_path",
					value = buffer.tostring(v683)
				}
			elseif v679 == 3 then
				local v684

				v684, n44 = proto.readBuffer(p65, n44)
				v677.kind = {
					type = "conditional",
					value = t1.SizeConstraintProp_ConditionalOptions.decode(v684)
				}
			else
				local v685, v686 = proto.readVarInt(p65, n44)

				n44 = v686 + v685
			end
		elseif v680 == proto.wireTypes.i32 then
			local v687

			v687, n44 = proto.readFixed32(p65, n44)
		elseif v680 == proto.wireTypes.i64 then
			local v688

			v688, n44 = proto.readFixed64(p65, n44)
		else
			error("Unsupported wire type: " .. v680)
		end
	end

	return v677
end
function t100.jsonEncode(p66) -- line: 4202
	-- upvalues: t1 (copy)
	local t102 = {}

	if p66.kind ~= nil then
		if p66.kind.type == "literal" then
			t102.literal = if typeof(p66.kind.value) ~= "number" then t1.SizeConstraint.toNumber(p66.kind.value) else p66.kind.value

			return t102
		end

		if p66.kind.type == "binding_path" then
			t102.bindingPath = p66.kind.value

			return t102
		end

		if p66.kind.type == "conditional" then
			t102.conditional = p66.kind.value:jsonEncode()
		end
	end

	return t102
end
function t100.jsonDecode(t103: {[any]: any}) -- line: 4220
	-- upvalues: t100 (copy), t1 (copy)
	local v692 = t100.new()

	if t103.literal ~= nil then
		v692.kind = {
			type = "literal",
			value = if typeof(t103.literal) ~= "number" then t1.SizeConstraint.fromName(t103.literal) or t103.literal else t1.SizeConstraint.fromNumber(t103.literal) or t103.literal
		}
	end

	if t103.binding_path ~= nil then
		v692.kind = {
			type = "binding_path",
			value = t103.binding_path
		}
	end

	if t103.bindingPath ~= nil then
		v692.kind = {
			type = "binding_path",
			value = t103.bindingPath
		}
	end

	if t103.conditional ~= nil then
		v692.kind = {
			type = "conditional",
			value = t1.SizeConstraintProp_ConditionalOptions.jsonDecode(t103.conditional)
		}
	end

	return v692
end

t100.descriptor = {
	name = "SizeConstraintProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.SizeConstraintProp"
}
t1.SizeConstraintProp = t100
typeRegistry.default:register(t1.SizeConstraintProp)

local t104 = {}

t104.__index = t104

function t104.new(t105: {[any]: any}?) -- line: 4264
	-- upvalues: t104 (copy)
	return (setmetatable({
		condition = if t105 ~= nil and t105.condition ~= nil then t105.condition else nil,
		kind = if t105 ~= nil and t105.kind ~= nil then t105.kind else nil
	}, t104))
end
function t104.encode(p67) -- line: 4273
	-- upvalues: proto (copy), t1 (copy)
	local buf = buffer.create(0)
	local n45 = 0

	if p67.condition ~= nil then
		local v697 = p67.condition:encode()
		local v698, v699 = proto.writeTag(buf, n45, 1, proto.wireTypes.lengthDelimited)

		buf, n45 = proto.writeBuffer(v698, v699, v697, buffer.len(v697))
	end

	if p67.kind ~= nil then
		if p67.kind.type == "literal" then
			local v700, v701 = proto.writeTag(buf, n45, 2, proto.wireTypes.varint)

			buf, n45 = proto.writeVarInt(v700, v701, t1.SizeConstraint.toNumber(p67.kind.value))
		elseif p67.kind.type == "binding_path" then
			local v702, v703 = proto.writeTag(buf, n45, 3, proto.wireTypes.lengthDelimited)

			buf, n45 = proto.writeString(v702, v703, p67.kind.value)
		end
	end

	local buf24 = buffer.create(n45)

	buffer.copy(buf24, 0, buf, 0, n45)

	return buf24
end
function t104.decode(p68: buffer) -- line: 4299
	-- upvalues: t104 (copy), proto (copy), t1 (copy), prop_condition (copy)
	local v706 = t104.new()
	local n46 = 0

	while n46 < buffer.len(p68) do
		local v708, v709

		v708, v709, n46 = proto.readTag(p68, n46)

		if v709 == proto.wireTypes.varint then
			if v708 == 2 then
				local v710

				v710, n46 = proto.readVarIntI32(p68, n46)
				v706.kind = {
					type = "literal",
					value = t1.SizeConstraint.fromNumber(v710) or v710
				}
			else
				local v711

				v711, n46 = proto.readVarInt(p68, n46)
			end
		elseif v709 == proto.wireTypes.lengthDelimited then
			if v708 == 1 then
				local v712

				v712, n46 = proto.readBuffer(p68, n46)
				v706.condition = prop_condition.PropCondition.decode(v712)
			elseif v708 == 3 then
				local v713

				v713, n46 = proto.readBuffer(p68, n46)
				v706.kind = {
					type = "binding_path",
					value = buffer.tostring(v713)
				}
			else
				local v714, v715 = proto.readVarInt(p68, n46)

				n46 = v715 + v714
			end
		elseif v709 == proto.wireTypes.i32 then
			local v716

			v716, n46 = proto.readFixed32(p68, n46)
		elseif v709 == proto.wireTypes.i64 then
			local v717

			v717, n46 = proto.readFixed64(p68, n46)
		else
			error("Unsupported wire type: " .. v709)
		end
	end

	return v706
end
function t104.jsonEncode(p69) -- line: 4355
	-- upvalues: t1 (copy)
	local t106 = {}

	if p69.condition ~= nil then
		t106.condition = p69.condition:jsonEncode()
	end

	if p69.kind ~= nil then
		if p69.kind.type == "literal" then
			t106.literal = if typeof(p69.kind.value) ~= "number" then t1.SizeConstraint.toNumber(p69.kind.value) else p69.kind.value

			return t106
		end

		if p69.kind.type == "binding_path" then
			t106.bindingPath = p69.kind.value
		end
	end

	return t106
end
function t104.jsonDecode(t107: {[any]: any}) -- line: 4375
	-- upvalues: t104 (copy), prop_condition (copy), t1 (copy)
	local v721 = t104.new()

	if t107.condition ~= nil then
		v721.condition = prop_condition.PropCondition.jsonDecode(t107.condition)
	end

	if t107.literal ~= nil then
		v721.kind = {
			type = "literal",
			value = if typeof(t107.literal) ~= "number" then t1.SizeConstraint.fromName(t107.literal) or t107.literal else t1.SizeConstraint.fromNumber(t107.literal) or t107.literal
		}
	end

	if t107.binding_path ~= nil then
		v721.kind = {
			type = "binding_path",
			value = t107.binding_path
		}
	end

	if t107.bindingPath ~= nil then
		v721.kind = {
			type = "binding_path",
			value = t107.bindingPath
		}
	end

	return v721
end

t104.descriptor = {
	name = "SizeConstraintProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}
t1.SizeConstraintProp_ConditionalOption = t104
typeRegistry.default:register(t1.SizeConstraintProp_ConditionalOption)

local t108 = {}

t108.__index = t108

function t108.new(t109: {[any]: any}?) -- line: 4419
	-- upvalues: t108 (copy)
	return (setmetatable({
		options = if t109 ~= nil and t109.options ~= nil then t109.options else {}
	}, t108))
end
function t108.encode(p70) -- line: 4427
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n47 = 0

	if p70.options ~= nil and #p70.options > 0 then
		for _, v727 in p70.options do
			local v728 = v727:encode()
			local v729, v730 = proto.writeTag(buf, n47, 1, proto.wireTypes.lengthDelimited)

			buf, n47 = proto.writeBuffer(v729, v730, v728, buffer.len(v728))
		end
	end

	local buf25 = buffer.create(n47)

	buffer.copy(buf25, 0, buf, 0, n47)

	return buf25
end
function t108.decode(p71: buffer) -- line: 4444
	-- upvalues: t108 (copy), proto (copy), t1 (copy)
	local v733 = t108.new()
	local n48 = 0

	while n48 < buffer.len(p71) do
		local v735, v736

		v735, v736, n48 = proto.readTag(p71, n48)

		if v736 == proto.wireTypes.varint then
			local v737

			v737, n48 = proto.readVarInt(p71, n48)
		elseif v736 == proto.wireTypes.lengthDelimited then
			if v735 == 1 then
				local v738

				v738, n48 = proto.readBuffer(p71, n48)
				table.insert(v733.options, t1.SizeConstraintProp_ConditionalOption.decode(v738))
			else
				local v739, v740 = proto.readVarInt(p71, n48)

				n48 = v740 + v739
			end
		elseif v736 == proto.wireTypes.i32 then
			local v741

			v741, n48 = proto.readFixed32(p71, n48)
		elseif v736 == proto.wireTypes.i64 then
			local v742

			v742, n48 = proto.readFixed64(p71, n48)
		else
			error("Unsupported wire type: " .. v736)
		end
	end

	return v733
end
function t108.jsonEncode(p72) -- line: 4487
	local t110 = {}

	if p72.options ~= nil and #p72.options > 0 then
		local t111 = {}

		for _, v747 in p72.options do
			table.insert(t111, v747:jsonEncode())
		end

		t110.options = t111
	end

	return t110
end
function t108.jsonDecode(t112: {[any]: any}) -- line: 4501
	-- upvalues: t108 (copy), t1 (copy)
	local v749 = t108.new()

	if t112.options ~= nil then
		local t113 = {}

		for _, v752 in t112.options do
			table.insert(t113, t1.SizeConstraintProp_ConditionalOption.jsonDecode(v752))
		end

		v749.options = t113
	end

	return v749
end

t108.descriptor = {
	name = "SizeConstraintProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}
t1.SizeConstraintProp_ConditionalOptions = t108
typeRegistry.default:register(t1.SizeConstraintProp_ConditionalOptions)

local t114 = {}

t114.__index = t114

function t114.new(t115: {[any]: any}?) -- line: 4532
	-- upvalues: t114 (copy)
	return (setmetatable({
		kind = if t115 ~= nil and t115.kind ~= nil then t115.kind else nil
	}, t114))
end
function t114.encode(p73) -- line: 4538
	-- upvalues: proto (copy), t1 (copy)
	local buf = buffer.create(0)
	local n49 = 0

	if p73.kind ~= nil then
		if p73.kind.type == "literal" then
			local v757, v758 = proto.writeTag(buf, n49, 1, proto.wireTypes.varint)

			buf, n49 = proto.writeVarInt(v757, v758, t1.HorizontalAlignment.toNumber(p73.kind.value))
		elseif p73.kind.type == "binding_path" then
			local v759, v760 = proto.writeTag(buf, n49, 2, proto.wireTypes.lengthDelimited)

			buf, n49 = proto.writeString(v759, v760, p73.kind.value)
		elseif p73.kind.type == "conditional" then
			local v761 = p73.kind.value:encode()
			local v762, v763 = proto.writeTag(buf, n49, 3, proto.wireTypes.lengthDelimited)

			buf, n49 = proto.writeBuffer(v762, v763, v761, buffer.len(v761))
		end
	end

	local buf26 = buffer.create(n49)

	buffer.copy(buf26, 0, buf, 0, n49)

	return buf26
end
function t114.decode(p74: buffer) -- line: 4562
	-- upvalues: t114 (copy), proto (copy), t1 (copy)
	local v766 = t114.new()
	local n50 = 0

	while n50 < buffer.len(p74) do
		local v768, v769

		v768, v769, n50 = proto.readTag(p74, n50)

		if v769 == proto.wireTypes.varint then
			if v768 == 1 then
				local v770

				v770, n50 = proto.readVarIntI32(p74, n50)
				v766.kind = {
					type = "literal",
					value = t1.HorizontalAlignment.fromNumber(v770) or v770
				}
			else
				local v771

				v771, n50 = proto.readVarInt(p74, n50)
			end
		elseif v769 == proto.wireTypes.lengthDelimited then
			if v768 == 2 then
				local v772

				v772, n50 = proto.readBuffer(p74, n50)
				v766.kind = {
					type = "binding_path",
					value = buffer.tostring(v772)
				}
			elseif v768 == 3 then
				local v773

				v773, n50 = proto.readBuffer(p74, n50)
				v766.kind = {
					type = "conditional",
					value = t1.HorizontalAlignmentProp_ConditionalOptions.decode(v773)
				}
			else
				local v774, v775 = proto.readVarInt(p74, n50)

				n50 = v775 + v774
			end
		elseif v769 == proto.wireTypes.i32 then
			local v776

			v776, n50 = proto.readFixed32(p74, n50)
		elseif v769 == proto.wireTypes.i64 then
			local v777

			v777, n50 = proto.readFixed64(p74, n50)
		else
			error("Unsupported wire type: " .. v769)
		end
	end

	return v766
end
function t114.jsonEncode(p75) -- line: 4621
	-- upvalues: t1 (copy)
	local t116 = {}

	if p75.kind ~= nil then
		if p75.kind.type == "literal" then
			t116.literal = if typeof(p75.kind.value) ~= "number" then t1.HorizontalAlignment.toNumber(p75.kind.value) else p75.kind.value

			return t116
		end

		if p75.kind.type == "binding_path" then
			t116.bindingPath = p75.kind.value

			return t116
		end

		if p75.kind.type == "conditional" then
			t116.conditional = p75.kind.value:jsonEncode()
		end
	end

	return t116
end
function t114.jsonDecode(t117: {[any]: any}) -- line: 4639
	-- upvalues: t114 (copy), t1 (copy)
	local v781 = t114.new()

	if t117.literal ~= nil then
		v781.kind = {
			type = "literal",
			value = if typeof(t117.literal) ~= "number" then t1.HorizontalAlignment.fromName(t117.literal) or t117.literal else t1.HorizontalAlignment.fromNumber(t117.literal) or t117.literal
		}
	end

	if t117.binding_path ~= nil then
		v781.kind = {
			type = "binding_path",
			value = t117.binding_path
		}
	end

	if t117.bindingPath ~= nil then
		v781.kind = {
			type = "binding_path",
			value = t117.bindingPath
		}
	end

	if t117.conditional ~= nil then
		v781.kind = {
			type = "conditional",
			value = t1.HorizontalAlignmentProp_ConditionalOptions.jsonDecode(t117.conditional)
		}
	end

	return v781
end

t114.descriptor = {
	name = "HorizontalAlignmentProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.HorizontalAlignmentProp"
}
t1.HorizontalAlignmentProp = t114
typeRegistry.default:register(t1.HorizontalAlignmentProp)

local t118 = {}

t118.__index = t118

function t118.new(t119: {[any]: any}?) -- line: 4683
	-- upvalues: t118 (copy)
	return (setmetatable({
		condition = if t119 ~= nil and t119.condition ~= nil then t119.condition else nil,
		kind = if t119 ~= nil and t119.kind ~= nil then t119.kind else nil
	}, t118))
end
function t118.encode(p76) -- line: 4692
	-- upvalues: proto (copy), t1 (copy)
	local buf = buffer.create(0)
	local n51 = 0

	if p76.condition ~= nil then
		local v786 = p76.condition:encode()
		local v787, v788 = proto.writeTag(buf, n51, 1, proto.wireTypes.lengthDelimited)

		buf, n51 = proto.writeBuffer(v787, v788, v786, buffer.len(v786))
	end

	if p76.kind ~= nil then
		if p76.kind.type == "literal" then
			local v789, v790 = proto.writeTag(buf, n51, 2, proto.wireTypes.varint)

			buf, n51 = proto.writeVarInt(v789, v790, t1.HorizontalAlignment.toNumber(p76.kind.value))
		elseif p76.kind.type == "binding_path" then
			local v791, v792 = proto.writeTag(buf, n51, 3, proto.wireTypes.lengthDelimited)

			buf, n51 = proto.writeString(v791, v792, p76.kind.value)
		end
	end

	local buf27 = buffer.create(n51)

	buffer.copy(buf27, 0, buf, 0, n51)

	return buf27
end
function t118.decode(p77: buffer) -- line: 4720
	-- upvalues: t118 (copy), proto (copy), t1 (copy), prop_condition (copy)
	local v795 = t118.new()
	local n52 = 0

	while n52 < buffer.len(p77) do
		local v797, v798

		v797, v798, n52 = proto.readTag(p77, n52)

		if v798 == proto.wireTypes.varint then
			if v797 == 2 then
				local v799

				v799, n52 = proto.readVarIntI32(p77, n52)
				v795.kind = {
					type = "literal",
					value = t1.HorizontalAlignment.fromNumber(v799) or v799
				}
			else
				local v800

				v800, n52 = proto.readVarInt(p77, n52)
			end
		elseif v798 == proto.wireTypes.lengthDelimited then
			if v797 == 1 then
				local v801

				v801, n52 = proto.readBuffer(p77, n52)
				v795.condition = prop_condition.PropCondition.decode(v801)
			elseif v797 == 3 then
				local v802

				v802, n52 = proto.readBuffer(p77, n52)
				v795.kind = {
					type = "binding_path",
					value = buffer.tostring(v802)
				}
			else
				local v803, v804 = proto.readVarInt(p77, n52)

				n52 = v804 + v803
			end
		elseif v798 == proto.wireTypes.i32 then
			local v805

			v805, n52 = proto.readFixed32(p77, n52)
		elseif v798 == proto.wireTypes.i64 then
			local v806

			v806, n52 = proto.readFixed64(p77, n52)
		else
			error("Unsupported wire type: " .. v798)
		end
	end

	return v795
end
function t118.jsonEncode(p78) -- line: 4778
	-- upvalues: t1 (copy)
	local t120 = {}

	if p78.condition ~= nil then
		t120.condition = p78.condition:jsonEncode()
	end

	if p78.kind ~= nil then
		if p78.kind.type == "literal" then
			t120.literal = if typeof(p78.kind.value) ~= "number" then t1.HorizontalAlignment.toNumber(p78.kind.value) else p78.kind.value

			return t120
		end

		if p78.kind.type == "binding_path" then
			t120.bindingPath = p78.kind.value
		end
	end

	return t120
end
function t118.jsonDecode(t121: {[any]: any}) -- line: 4800
	-- upvalues: t118 (copy), prop_condition (copy), t1 (copy)
	local v810 = t118.new()

	if t121.condition ~= nil then
		v810.condition = prop_condition.PropCondition.jsonDecode(t121.condition)
	end

	if t121.literal ~= nil then
		v810.kind = {
			type = "literal",
			value = if typeof(t121.literal) ~= "number" then t1.HorizontalAlignment.fromName(t121.literal) or t121.literal else t1.HorizontalAlignment.fromNumber(t121.literal) or t121.literal
		}
	end

	if t121.binding_path ~= nil then
		v810.kind = {
			type = "binding_path",
			value = t121.binding_path
		}
	end

	if t121.bindingPath ~= nil then
		v810.kind = {
			type = "binding_path",
			value = t121.bindingPath
		}
	end

	return v810
end

t118.descriptor = {
	name = "HorizontalAlignmentProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}
t1.HorizontalAlignmentProp_ConditionalOption = t118
typeRegistry.default:register(t1.HorizontalAlignmentProp_ConditionalOption)

local t122 = {}

t122.__index = t122

function t122.new(t123: {[any]: any}?) -- line: 4844
	-- upvalues: t122 (copy)
	return (setmetatable({
		option = if t123 ~= nil and t123.option ~= nil then t123.option else {}
	}, t122))
end
function t122.encode(p79) -- line: 4852
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n53 = 0

	if p79.option ~= nil and #p79.option > 0 then
		for _, v816 in p79.option do
			local v817 = v816:encode()
			local v818, v819 = proto.writeTag(buf, n53, 1, proto.wireTypes.lengthDelimited)

			buf, n53 = proto.writeBuffer(v818, v819, v817, buffer.len(v817))
		end
	end

	local buf28 = buffer.create(n53)

	buffer.copy(buf28, 0, buf, 0, n53)

	return buf28
end
function t122.decode(p80: buffer) -- line: 4871
	-- upvalues: t122 (copy), proto (copy), t1 (copy)
	local v822 = t122.new()
	local n54 = 0

	while n54 < buffer.len(p80) do
		local v824, v825

		v824, v825, n54 = proto.readTag(p80, n54)

		if v825 == proto.wireTypes.varint then
			local v826

			v826, n54 = proto.readVarInt(p80, n54)
		elseif v825 == proto.wireTypes.lengthDelimited then
			if v824 == 1 then
				local v827

				v827, n54 = proto.readBuffer(p80, n54)
				table.insert(v822.option, t1.HorizontalAlignmentProp_ConditionalOption.decode(v827))
			else
				local v828, v829 = proto.readVarInt(p80, n54)

				n54 = v829 + v828
			end
		elseif v825 == proto.wireTypes.i32 then
			local v830

			v830, n54 = proto.readFixed32(p80, n54)
		elseif v825 == proto.wireTypes.i64 then
			local v831

			v831, n54 = proto.readFixed64(p80, n54)
		else
			error("Unsupported wire type: " .. v825)
		end
	end

	return v822
end
function t122.jsonEncode(p81) -- line: 4916
	local t124 = {}

	if p81.option ~= nil and #p81.option > 0 then
		local t125 = {}

		for _, v836 in p81.option do
			table.insert(t125, v836:jsonEncode())
		end

		t124.option = t125
	end

	return t124
end
function t122.jsonDecode(t126: {[any]: any}) -- line: 4932
	-- upvalues: t122 (copy), t1 (copy)
	local v838 = t122.new()

	if t126.option ~= nil then
		local t127 = {}

		for _, v841 in t126.option do
			table.insert(t127, t1.HorizontalAlignmentProp_ConditionalOption.jsonDecode(v841))
		end

		v838.option = t127
	end

	return v838
end

t122.descriptor = {
	name = "HorizontalAlignmentProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}
t1.HorizontalAlignmentProp_ConditionalOptions = t122
typeRegistry.default:register(t1.HorizontalAlignmentProp_ConditionalOptions)

local t128 = {}

t128.__index = t128

function t128.new(t129: {[any]: any}?) -- line: 4963
	-- upvalues: t128 (copy)
	return (setmetatable({
		kind = if t129 ~= nil and t129.kind ~= nil then t129.kind else nil
	}, t128))
end
function t128.encode(p82) -- line: 4969
	-- upvalues: proto (copy), t1 (copy)
	local buf = buffer.create(0)
	local n55 = 0

	if p82.kind ~= nil then
		if p82.kind.type == "literal" then
			local v846, v847 = proto.writeTag(buf, n55, 1, proto.wireTypes.varint)

			buf, n55 = proto.writeVarInt(v846, v847, t1.SelectionBehavior.toNumber(p82.kind.value))
		elseif p82.kind.type == "binding_path" then
			local v848, v849 = proto.writeTag(buf, n55, 2, proto.wireTypes.lengthDelimited)

			buf, n55 = proto.writeString(v848, v849, p82.kind.value)
		elseif p82.kind.type == "conditional" then
			local v850 = p82.kind.value:encode()
			local v851, v852 = proto.writeTag(buf, n55, 3, proto.wireTypes.lengthDelimited)

			buf, n55 = proto.writeBuffer(v851, v852, v850, buffer.len(v850))
		end
	end

	local buf29 = buffer.create(n55)

	buffer.copy(buf29, 0, buf, 0, n55)

	return buf29
end
function t128.decode(p83: buffer) -- line: 4993
	-- upvalues: t128 (copy), proto (copy), t1 (copy)
	local v855 = t128.new()
	local n56 = 0

	while n56 < buffer.len(p83) do
		local v857, v858

		v857, v858, n56 = proto.readTag(p83, n56)

		if v858 == proto.wireTypes.varint then
			if v857 == 1 then
				local v859

				v859, n56 = proto.readVarIntI32(p83, n56)
				v855.kind = {
					type = "literal",
					value = t1.SelectionBehavior.fromNumber(v859) or v859
				}
			else
				local v860

				v860, n56 = proto.readVarInt(p83, n56)
			end
		elseif v858 == proto.wireTypes.lengthDelimited then
			if v857 == 2 then
				local v861

				v861, n56 = proto.readBuffer(p83, n56)
				v855.kind = {
					type = "binding_path",
					value = buffer.tostring(v861)
				}
			elseif v857 == 3 then
				local v862

				v862, n56 = proto.readBuffer(p83, n56)
				v855.kind = {
					type = "conditional",
					value = t1.SelectionBehaviorProp_ConditionalOptions.decode(v862)
				}
			else
				local v863, v864 = proto.readVarInt(p83, n56)

				n56 = v864 + v863
			end
		elseif v858 == proto.wireTypes.i32 then
			local v865

			v865, n56 = proto.readFixed32(p83, n56)
		elseif v858 == proto.wireTypes.i64 then
			local v866

			v866, n56 = proto.readFixed64(p83, n56)
		else
			error("Unsupported wire type: " .. v858)
		end
	end

	return v855
end
function t128.jsonEncode(p84) -- line: 5052
	-- upvalues: t1 (copy)
	local t130 = {}

	if p84.kind ~= nil then
		if p84.kind.type == "literal" then
			t130.literal = if typeof(p84.kind.value) ~= "number" then t1.SelectionBehavior.toNumber(p84.kind.value) else p84.kind.value

			return t130
		end

		if p84.kind.type == "binding_path" then
			t130.bindingPath = p84.kind.value

			return t130
		end

		if p84.kind.type == "conditional" then
			t130.conditional = p84.kind.value:jsonEncode()
		end
	end

	return t130
end
function t128.jsonDecode(t131: {[any]: any}) -- line: 5070
	-- upvalues: t128 (copy), t1 (copy)
	local v870 = t128.new()

	if t131.literal ~= nil then
		v870.kind = {
			type = "literal",
			value = if typeof(t131.literal) ~= "number" then t1.SelectionBehavior.fromName(t131.literal) or t131.literal else t1.SelectionBehavior.fromNumber(t131.literal) or t131.literal
		}
	end

	if t131.binding_path ~= nil then
		v870.kind = {
			type = "binding_path",
			value = t131.binding_path
		}
	end

	if t131.bindingPath ~= nil then
		v870.kind = {
			type = "binding_path",
			value = t131.bindingPath
		}
	end

	if t131.conditional ~= nil then
		v870.kind = {
			type = "conditional",
			value = t1.SelectionBehaviorProp_ConditionalOptions.jsonDecode(t131.conditional)
		}
	end

	return v870
end

t128.descriptor = {
	name = "SelectionBehaviorProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.SelectionBehaviorProp"
}
t1.SelectionBehaviorProp = t128
typeRegistry.default:register(t1.SelectionBehaviorProp)

local t132 = {}

t132.__index = t132

function t132.new(t133: {[any]: any}?) -- line: 5114
	-- upvalues: t132 (copy)
	return (setmetatable({
		condition = if t133 ~= nil and t133.condition ~= nil then t133.condition else nil,
		kind = if t133 ~= nil and t133.kind ~= nil then t133.kind else nil
	}, t132))
end
function t132.encode(p85) -- line: 5123
	-- upvalues: proto (copy), t1 (copy)
	local buf = buffer.create(0)
	local n57 = 0

	if p85.condition ~= nil then
		local v875 = p85.condition:encode()
		local v876, v877 = proto.writeTag(buf, n57, 1, proto.wireTypes.lengthDelimited)

		buf, n57 = proto.writeBuffer(v876, v877, v875, buffer.len(v875))
	end

	if p85.kind ~= nil then
		if p85.kind.type == "literal" then
			local v878, v879 = proto.writeTag(buf, n57, 2, proto.wireTypes.varint)

			buf, n57 = proto.writeVarInt(v878, v879, t1.SelectionBehavior.toNumber(p85.kind.value))
		elseif p85.kind.type == "binding_path" then
			local v880, v881 = proto.writeTag(buf, n57, 3, proto.wireTypes.lengthDelimited)

			buf, n57 = proto.writeString(v880, v881, p85.kind.value)
		end
	end

	local buf30 = buffer.create(n57)

	buffer.copy(buf30, 0, buf, 0, n57)

	return buf30
end
function t132.decode(p86: buffer) -- line: 5149
	-- upvalues: t132 (copy), proto (copy), t1 (copy), prop_condition (copy)
	local v884 = t132.new()
	local n58 = 0

	while n58 < buffer.len(p86) do
		local v886, v887

		v886, v887, n58 = proto.readTag(p86, n58)

		if v887 == proto.wireTypes.varint then
			if v886 == 2 then
				local v888

				v888, n58 = proto.readVarIntI32(p86, n58)
				v884.kind = {
					type = "literal",
					value = t1.SelectionBehavior.fromNumber(v888) or v888
				}
			else
				local v889

				v889, n58 = proto.readVarInt(p86, n58)
			end
		elseif v887 == proto.wireTypes.lengthDelimited then
			if v886 == 1 then
				local v890

				v890, n58 = proto.readBuffer(p86, n58)
				v884.condition = prop_condition.PropCondition.decode(v890)
			elseif v886 == 3 then
				local v891

				v891, n58 = proto.readBuffer(p86, n58)
				v884.kind = {
					type = "binding_path",
					value = buffer.tostring(v891)
				}
			else
				local v892, v893 = proto.readVarInt(p86, n58)

				n58 = v893 + v892
			end
		elseif v887 == proto.wireTypes.i32 then
			local v894

			v894, n58 = proto.readFixed32(p86, n58)
		elseif v887 == proto.wireTypes.i64 then
			local v895

			v895, n58 = proto.readFixed64(p86, n58)
		else
			error("Unsupported wire type: " .. v887)
		end
	end

	return v884
end
function t132.jsonEncode(p87) -- line: 5205
	-- upvalues: t1 (copy)
	local t134 = {}

	if p87.condition ~= nil then
		t134.condition = p87.condition:jsonEncode()
	end

	if p87.kind ~= nil then
		if p87.kind.type == "literal" then
			t134.literal = if typeof(p87.kind.value) ~= "number" then t1.SelectionBehavior.toNumber(p87.kind.value) else p87.kind.value

			return t134
		end

		if p87.kind.type == "binding_path" then
			t134.bindingPath = p87.kind.value
		end
	end

	return t134
end
function t132.jsonDecode(t135: {[any]: any}) -- line: 5225
	-- upvalues: t132 (copy), prop_condition (copy), t1 (copy)
	local v899 = t132.new()

	if t135.condition ~= nil then
		v899.condition = prop_condition.PropCondition.jsonDecode(t135.condition)
	end

	if t135.literal ~= nil then
		v899.kind = {
			type = "literal",
			value = if typeof(t135.literal) ~= "number" then t1.SelectionBehavior.fromName(t135.literal) or t135.literal else t1.SelectionBehavior.fromNumber(t135.literal) or t135.literal
		}
	end

	if t135.binding_path ~= nil then
		v899.kind = {
			type = "binding_path",
			value = t135.binding_path
		}
	end

	if t135.bindingPath ~= nil then
		v899.kind = {
			type = "binding_path",
			value = t135.bindingPath
		}
	end

	return v899
end

t132.descriptor = {
	name = "SelectionBehaviorProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}
t1.SelectionBehaviorProp_ConditionalOption = t132
typeRegistry.default:register(t1.SelectionBehaviorProp_ConditionalOption)

local t136 = {}

t136.__index = t136

function t136.new(t137: {[any]: any}?) -- line: 5269
	-- upvalues: t136 (copy)
	return (setmetatable({
		options = if t137 ~= nil and t137.options ~= nil then t137.options else {}
	}, t136))
end
function t136.encode(p88) -- line: 5277
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n59 = 0

	if p88.options ~= nil and #p88.options > 0 then
		for _, v905 in p88.options do
			local v906 = v905:encode()
			local v907, v908 = proto.writeTag(buf, n59, 1, proto.wireTypes.lengthDelimited)

			buf, n59 = proto.writeBuffer(v907, v908, v906, buffer.len(v906))
		end
	end

	local buf31 = buffer.create(n59)

	buffer.copy(buf31, 0, buf, 0, n59)

	return buf31
end
function t136.decode(p89: buffer) -- line: 5296
	-- upvalues: t136 (copy), proto (copy), t1 (copy)
	local v911 = t136.new()
	local n60 = 0

	while n60 < buffer.len(p89) do
		local v913, v914

		v913, v914, n60 = proto.readTag(p89, n60)

		if v914 == proto.wireTypes.varint then
			local v915

			v915, n60 = proto.readVarInt(p89, n60)
		elseif v914 == proto.wireTypes.lengthDelimited then
			if v913 == 1 then
				local v916

				v916, n60 = proto.readBuffer(p89, n60)
				table.insert(v911.options, t1.SelectionBehaviorProp_ConditionalOption.decode(v916))
			else
				local v917, v918 = proto.readVarInt(p89, n60)

				n60 = v918 + v917
			end
		elseif v914 == proto.wireTypes.i32 then
			local v919

			v919, n60 = proto.readFixed32(p89, n60)
		elseif v914 == proto.wireTypes.i64 then
			local v920

			v920, n60 = proto.readFixed64(p89, n60)
		else
			error("Unsupported wire type: " .. v914)
		end
	end

	return v911
end
function t136.jsonEncode(p90) -- line: 5341
	local t138 = {}

	if p90.options ~= nil and #p90.options > 0 then
		local t139 = {}

		for _, v925 in p90.options do
			table.insert(t139, v925:jsonEncode())
		end

		t138.options = t139
	end

	return t138
end
function t136.jsonDecode(t140: {[any]: any}) -- line: 5357
	-- upvalues: t136 (copy), t1 (copy)
	local v927 = t136.new()

	if t140.options ~= nil then
		local t141 = {}

		for _, v930 in t140.options do
			table.insert(t141, t1.SelectionBehaviorProp_ConditionalOption.jsonDecode(v930))
		end

		v927.options = t141
	end

	return v927
end

t136.descriptor = {
	name = "SelectionBehaviorProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}
t1.SelectionBehaviorProp_ConditionalOptions = t136
typeRegistry.default:register(t1.SelectionBehaviorProp_ConditionalOptions)

local t142 = {}

t142.__index = t142

function t142.new(t143: {[any]: any}?) -- line: 5388
	-- upvalues: t142 (copy)
	return (setmetatable({
		kind = if t143 ~= nil and t143.kind ~= nil then t143.kind else nil
	}, t142))
end
function t142.encode(p91) -- line: 5394
	-- upvalues: proto (copy), t1 (copy)
	local buf = buffer.create(0)
	local n61 = 0

	if p91.kind ~= nil then
		if p91.kind.type == "literal" then
			local v935, v936 = proto.writeTag(buf, n61, 1, proto.wireTypes.varint)

			buf, n61 = proto.writeVarInt(v935, v936, t1.KeyCode.toNumber(p91.kind.value))
		elseif p91.kind.type == "binding_path" then
			local v937, v938 = proto.writeTag(buf, n61, 2, proto.wireTypes.lengthDelimited)

			buf, n61 = proto.writeString(v937, v938, p91.kind.value)
		elseif p91.kind.type == "conditional" then
			local v939 = p91.kind.value:encode()
			local v940, v941 = proto.writeTag(buf, n61, 3, proto.wireTypes.lengthDelimited)

			buf, n61 = proto.writeBuffer(v940, v941, v939, buffer.len(v939))
		end
	end

	local buf32 = buffer.create(n61)

	buffer.copy(buf32, 0, buf, 0, n61)

	return buf32
end
function t142.decode(p92: buffer) -- line: 5417
	-- upvalues: t142 (copy), proto (copy), t1 (copy)
	local v944 = t142.new()
	local n62 = 0

	while n62 < buffer.len(p92) do
		local v946, v947

		v946, v947, n62 = proto.readTag(p92, n62)

		if v947 == proto.wireTypes.varint then
			if v946 == 1 then
				local v948

				v948, n62 = proto.readVarIntI32(p92, n62)
				v944.kind = {
					type = "literal",
					value = t1.KeyCode.fromNumber(v948) or v948
				}
			else
				local v949

				v949, n62 = proto.readVarInt(p92, n62)
			end
		elseif v947 == proto.wireTypes.lengthDelimited then
			if v946 == 2 then
				local v950

				v950, n62 = proto.readBuffer(p92, n62)
				v944.kind = {
					type = "binding_path",
					value = buffer.tostring(v950)
				}
			elseif v946 == 3 then
				local v951

				v951, n62 = proto.readBuffer(p92, n62)
				v944.kind = {
					type = "conditional",
					value = t1.KeyCodeProp_ConditionalOptions.decode(v951)
				}
			else
				local v952, v953 = proto.readVarInt(p92, n62)

				n62 = v953 + v952
			end
		elseif v947 == proto.wireTypes.i32 then
			local v954

			v954, n62 = proto.readFixed32(p92, n62)
		elseif v947 == proto.wireTypes.i64 then
			local v955

			v955, n62 = proto.readFixed64(p92, n62)
		else
			error("Unsupported wire type: " .. v947)
		end
	end

	return v944
end
function t142.jsonEncode(p93) -- line: 5473
	-- upvalues: t1 (copy)
	local t144 = {}

	if p93.kind ~= nil then
		if p93.kind.type == "literal" then
			t144.literal = if typeof(p93.kind.value) ~= "number" then t1.KeyCode.toNumber(p93.kind.value) else p93.kind.value

			return t144
		end

		if p93.kind.type == "binding_path" then
			t144.bindingPath = p93.kind.value

			return t144
		end

		if p93.kind.type == "conditional" then
			t144.conditional = p93.kind.value:jsonEncode()
		end
	end

	return t144
end
function t142.jsonDecode(t145: {[any]: any}) -- line: 5491
	-- upvalues: t142 (copy), t1 (copy)
	local v959 = t142.new()

	if t145.literal ~= nil then
		v959.kind = {
			type = "literal",
			value = if typeof(t145.literal) ~= "number" then t1.KeyCode.fromName(t145.literal) or t145.literal else t1.KeyCode.fromNumber(t145.literal) or t145.literal
		}
	end

	if t145.binding_path ~= nil then
		v959.kind = {
			type = "binding_path",
			value = t145.binding_path
		}
	end

	if t145.bindingPath ~= nil then
		v959.kind = {
			type = "binding_path",
			value = t145.bindingPath
		}
	end

	if t145.conditional ~= nil then
		v959.kind = {
			type = "conditional",
			value = t1.KeyCodeProp_ConditionalOptions.jsonDecode(t145.conditional)
		}
	end

	return v959
end

t142.descriptor = {
	name = "KeyCodeProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.KeyCodeProp"
}
t1.KeyCodeProp = t142
typeRegistry.default:register(t1.KeyCodeProp)

local t146 = {}

t146.__index = t146

function t146.new(t147: {[any]: any}?) -- line: 5533
	-- upvalues: t146 (copy)
	return (setmetatable({
		condition = if t147 ~= nil and t147.condition ~= nil then t147.condition else nil,
		kind = if t147 ~= nil and t147.kind ~= nil then t147.kind else nil
	}, t146))
end
function t146.encode(p94) -- line: 5542
	-- upvalues: proto (copy), t1 (copy)
	local buf = buffer.create(0)
	local n63 = 0

	if p94.condition ~= nil then
		local v964 = p94.condition:encode()
		local v965, v966 = proto.writeTag(buf, n63, 1, proto.wireTypes.lengthDelimited)

		buf, n63 = proto.writeBuffer(v965, v966, v964, buffer.len(v964))
	end

	if p94.kind ~= nil then
		if p94.kind.type == "literal" then
			local v967, v968 = proto.writeTag(buf, n63, 2, proto.wireTypes.varint)

			buf, n63 = proto.writeVarInt(v967, v968, t1.KeyCode.toNumber(p94.kind.value))
		elseif p94.kind.type == "binding_path" then
			local v969, v970 = proto.writeTag(buf, n63, 3, proto.wireTypes.lengthDelimited)

			buf, n63 = proto.writeString(v969, v970, p94.kind.value)
		end
	end

	local buf33 = buffer.create(n63)

	buffer.copy(buf33, 0, buf, 0, n63)

	return buf33
end
function t146.decode(p95: buffer) -- line: 5567
	-- upvalues: t146 (copy), proto (copy), t1 (copy), prop_condition (copy)
	local v973 = t146.new()
	local n64 = 0

	while n64 < buffer.len(p95) do
		local v975, v976

		v975, v976, n64 = proto.readTag(p95, n64)

		if v976 == proto.wireTypes.varint then
			if v975 == 2 then
				local v977

				v977, n64 = proto.readVarIntI32(p95, n64)
				v973.kind = {
					type = "literal",
					value = t1.KeyCode.fromNumber(v977) or v977
				}
			else
				local v978

				v978, n64 = proto.readVarInt(p95, n64)
			end
		elseif v976 == proto.wireTypes.lengthDelimited then
			if v975 == 1 then
				local v979

				v979, n64 = proto.readBuffer(p95, n64)
				v973.condition = prop_condition.PropCondition.decode(v979)
			elseif v975 == 3 then
				local v980

				v980, n64 = proto.readBuffer(p95, n64)
				v973.kind = {
					type = "binding_path",
					value = buffer.tostring(v980)
				}
			else
				local v981, v982 = proto.readVarInt(p95, n64)

				n64 = v982 + v981
			end
		elseif v976 == proto.wireTypes.i32 then
			local v983

			v983, n64 = proto.readFixed32(p95, n64)
		elseif v976 == proto.wireTypes.i64 then
			local v984

			v984, n64 = proto.readFixed64(p95, n64)
		else
			error("Unsupported wire type: " .. v976)
		end
	end

	return v973
end
function t146.jsonEncode(p96) -- line: 5623
	-- upvalues: t1 (copy)
	local t148 = {}

	if p96.condition ~= nil then
		t148.condition = p96.condition:jsonEncode()
	end

	if p96.kind ~= nil then
		if p96.kind.type == "literal" then
			t148.literal = if typeof(p96.kind.value) ~= "number" then t1.KeyCode.toNumber(p96.kind.value) else p96.kind.value

			return t148
		end

		if p96.kind.type == "binding_path" then
			t148.bindingPath = p96.kind.value
		end
	end

	return t148
end
function t146.jsonDecode(t149: {[any]: any}) -- line: 5643
	-- upvalues: t146 (copy), prop_condition (copy), t1 (copy)
	local v988 = t146.new()

	if t149.condition ~= nil then
		v988.condition = prop_condition.PropCondition.jsonDecode(t149.condition)
	end

	if t149.literal ~= nil then
		v988.kind = {
			type = "literal",
			value = if typeof(t149.literal) ~= "number" then t1.KeyCode.fromName(t149.literal) or t149.literal else t1.KeyCode.fromNumber(t149.literal) or t149.literal
		}
	end

	if t149.binding_path ~= nil then
		v988.kind = {
			type = "binding_path",
			value = t149.binding_path
		}
	end

	if t149.bindingPath ~= nil then
		v988.kind = {
			type = "binding_path",
			value = t149.bindingPath
		}
	end

	return v988
end

t146.descriptor = {
	name = "KeyCodeProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}
t1.KeyCodeProp_ConditionalOption = t146
typeRegistry.default:register(t1.KeyCodeProp_ConditionalOption)

local t150 = {}

t150.__index = t150

function t150.new(t151: {[any]: any}?) -- line: 5685
	-- upvalues: t150 (copy)
	return (setmetatable({
		options = if t151 ~= nil and t151.options ~= nil then t151.options else {}
	}, t150))
end
function t150.encode(p97) -- line: 5693
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n65 = 0

	if p97.options ~= nil and #p97.options > 0 then
		for _, v994 in p97.options do
			local v995 = v994:encode()
			local v996, v997 = proto.writeTag(buf, n65, 1, proto.wireTypes.lengthDelimited)

			buf, n65 = proto.writeBuffer(v996, v997, v995, buffer.len(v995))
		end
	end

	local buf34 = buffer.create(n65)

	buffer.copy(buf34, 0, buf, 0, n65)

	return buf34
end
function t150.decode(p98: buffer) -- line: 5710
	-- upvalues: t150 (copy), proto (copy), t1 (copy)
	local v1000 = t150.new()
	local n66 = 0

	while n66 < buffer.len(p98) do
		local v1002, v1003

		v1002, v1003, n66 = proto.readTag(p98, n66)

		if v1003 == proto.wireTypes.varint then
			local v1004

			v1004, n66 = proto.readVarInt(p98, n66)
		elseif v1003 == proto.wireTypes.lengthDelimited then
			if v1002 == 1 then
				local v1005

				v1005, n66 = proto.readBuffer(p98, n66)
				table.insert(v1000.options, t1.KeyCodeProp_ConditionalOption.decode(v1005))
			else
				local v1006, v1007 = proto.readVarInt(p98, n66)

				n66 = v1007 + v1006
			end
		elseif v1003 == proto.wireTypes.i32 then
			local v1008

			v1008, n66 = proto.readFixed32(p98, n66)
		elseif v1003 == proto.wireTypes.i64 then
			local v1009

			v1009, n66 = proto.readFixed64(p98, n66)
		else
			error("Unsupported wire type: " .. v1003)
		end
	end

	return v1000
end
function t150.jsonEncode(p99) -- line: 5753
	local t152 = {}

	if p99.options ~= nil and #p99.options > 0 then
		local t153 = {}

		for _, v1014 in p99.options do
			table.insert(t153, v1014:jsonEncode())
		end

		t152.options = t153
	end

	return t152
end
function t150.jsonDecode(t154: {[any]: any}) -- line: 5767
	-- upvalues: t150 (copy), t1 (copy)
	local v1016 = t150.new()

	if t154.options ~= nil then
		local t155 = {}

		for _, v1019 in t154.options do
			table.insert(t155, t1.KeyCodeProp_ConditionalOption.jsonDecode(v1019))
		end

		v1016.options = t155
	end

	return v1016
end

t150.descriptor = {
	name = "KeyCodeProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}
t1.KeyCodeProp_ConditionalOptions = t150
typeRegistry.default:register(t1.KeyCodeProp_ConditionalOptions)

local t156 = {}

t156.__index = t156

function t156.new(t157: {[any]: any}?) -- line: 5796
	-- upvalues: t156 (copy)
	return (setmetatable({
		kind = if t157 ~= nil and t157.kind ~= nil then t157.kind else nil
	}, t156))
end
function t156.encode(p100) -- line: 5802
	-- upvalues: proto (copy), t1 (copy)
	local buf = buffer.create(0)
	local n67 = 0

	if p100.kind ~= nil then
		if p100.kind.type == "literal" then
			local v1024, v1025 = proto.writeTag(buf, n67, 1, proto.wireTypes.varint)

			buf, n67 = proto.writeVarInt(v1024, v1025, t1.VerticalAlignment.toNumber(p100.kind.value))
		elseif p100.kind.type == "binding_path" then
			local v1026, v1027 = proto.writeTag(buf, n67, 2, proto.wireTypes.lengthDelimited)

			buf, n67 = proto.writeString(v1026, v1027, p100.kind.value)
		elseif p100.kind.type == "conditional" then
			local v1028 = p100.kind.value:encode()
			local v1029, v1030 = proto.writeTag(buf, n67, 3, proto.wireTypes.lengthDelimited)

			buf, n67 = proto.writeBuffer(v1029, v1030, v1028, buffer.len(v1028))
		end
	end

	local buf35 = buffer.create(n67)

	buffer.copy(buf35, 0, buf, 0, n67)

	return buf35
end
function t156.decode(p101: buffer) -- line: 5826
	-- upvalues: t156 (copy), proto (copy), t1 (copy)
	local v1033 = t156.new()
	local n68 = 0

	while n68 < buffer.len(p101) do
		local v1035, v1036

		v1035, v1036, n68 = proto.readTag(p101, n68)

		if v1036 == proto.wireTypes.varint then
			if v1035 == 1 then
				local v1037

				v1037, n68 = proto.readVarIntI32(p101, n68)
				v1033.kind = {
					type = "literal",
					value = t1.VerticalAlignment.fromNumber(v1037) or v1037
				}
			else
				local v1038

				v1038, n68 = proto.readVarInt(p101, n68)
			end
		elseif v1036 == proto.wireTypes.lengthDelimited then
			if v1035 == 2 then
				local v1039

				v1039, n68 = proto.readBuffer(p101, n68)
				v1033.kind = {
					type = "binding_path",
					value = buffer.tostring(v1039)
				}
			elseif v1035 == 3 then
				local v1040

				v1040, n68 = proto.readBuffer(p101, n68)
				v1033.kind = {
					type = "conditional",
					value = t1.VerticalAlignmentProp_ConditionalOptions.decode(v1040)
				}
			else
				local v1041, v1042 = proto.readVarInt(p101, n68)

				n68 = v1042 + v1041
			end
		elseif v1036 == proto.wireTypes.i32 then
			local v1043

			v1043, n68 = proto.readFixed32(p101, n68)
		elseif v1036 == proto.wireTypes.i64 then
			local v1044

			v1044, n68 = proto.readFixed64(p101, n68)
		else
			error("Unsupported wire type: " .. v1036)
		end
	end

	return v1033
end
function t156.jsonEncode(p102) -- line: 5885
	-- upvalues: t1 (copy)
	local t158 = {}

	if p102.kind ~= nil then
		if p102.kind.type == "literal" then
			t158.literal = if typeof(p102.kind.value) ~= "number" then t1.VerticalAlignment.toNumber(p102.kind.value) else p102.kind.value

			return t158
		end

		if p102.kind.type == "binding_path" then
			t158.bindingPath = p102.kind.value

			return t158
		end

		if p102.kind.type == "conditional" then
			t158.conditional = p102.kind.value:jsonEncode()
		end
	end

	return t158
end
function t156.jsonDecode(t159: {[any]: any}) -- line: 5903
	-- upvalues: t156 (copy), t1 (copy)
	local v1048 = t156.new()

	if t159.literal ~= nil then
		v1048.kind = {
			type = "literal",
			value = if typeof(t159.literal) ~= "number" then t1.VerticalAlignment.fromName(t159.literal) or t159.literal else t1.VerticalAlignment.fromNumber(t159.literal) or t159.literal
		}
	end

	if t159.binding_path ~= nil then
		v1048.kind = {
			type = "binding_path",
			value = t159.binding_path
		}
	end

	if t159.bindingPath ~= nil then
		v1048.kind = {
			type = "binding_path",
			value = t159.bindingPath
		}
	end

	if t159.conditional ~= nil then
		v1048.kind = {
			type = "conditional",
			value = t1.VerticalAlignmentProp_ConditionalOptions.jsonDecode(t159.conditional)
		}
	end

	return v1048
end

t156.descriptor = {
	name = "VerticalAlignmentProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.VerticalAlignmentProp"
}
t1.VerticalAlignmentProp = t156
typeRegistry.default:register(t1.VerticalAlignmentProp)

local t160 = {}

t160.__index = t160

function t160.new(t161: {[any]: any}?) -- line: 5947
	-- upvalues: t160 (copy)
	return (setmetatable({
		condition = if t161 ~= nil and t161.condition ~= nil then t161.condition else nil,
		kind = if t161 ~= nil and t161.kind ~= nil then t161.kind else nil
	}, t160))
end
function t160.encode(p103) -- line: 5956
	-- upvalues: proto (copy), t1 (copy)
	local buf = buffer.create(0)
	local n69 = 0

	if p103.condition ~= nil then
		local v1053 = p103.condition:encode()
		local v1054, v1055 = proto.writeTag(buf, n69, 1, proto.wireTypes.lengthDelimited)

		buf, n69 = proto.writeBuffer(v1054, v1055, v1053, buffer.len(v1053))
	end

	if p103.kind ~= nil then
		if p103.kind.type == "literal" then
			local v1056, v1057 = proto.writeTag(buf, n69, 2, proto.wireTypes.varint)

			buf, n69 = proto.writeVarInt(v1056, v1057, t1.VerticalAlignment.toNumber(p103.kind.value))
		elseif p103.kind.type == "binding_path" then
			local v1058, v1059 = proto.writeTag(buf, n69, 3, proto.wireTypes.lengthDelimited)

			buf, n69 = proto.writeString(v1058, v1059, p103.kind.value)
		end
	end

	local buf36 = buffer.create(n69)

	buffer.copy(buf36, 0, buf, 0, n69)

	return buf36
end
function t160.decode(p104: buffer) -- line: 5982
	-- upvalues: t160 (copy), proto (copy), t1 (copy), prop_condition (copy)
	local v1062 = t160.new()
	local n70 = 0

	while n70 < buffer.len(p104) do
		local v1064, v1065

		v1064, v1065, n70 = proto.readTag(p104, n70)

		if v1065 == proto.wireTypes.varint then
			if v1064 == 2 then
				local v1066

				v1066, n70 = proto.readVarIntI32(p104, n70)
				v1062.kind = {
					type = "literal",
					value = t1.VerticalAlignment.fromNumber(v1066) or v1066
				}
			else
				local v1067

				v1067, n70 = proto.readVarInt(p104, n70)
			end
		elseif v1065 == proto.wireTypes.lengthDelimited then
			if v1064 == 1 then
				local v1068

				v1068, n70 = proto.readBuffer(p104, n70)
				v1062.condition = prop_condition.PropCondition.decode(v1068)
			elseif v1064 == 3 then
				local v1069

				v1069, n70 = proto.readBuffer(p104, n70)
				v1062.kind = {
					type = "binding_path",
					value = buffer.tostring(v1069)
				}
			else
				local v1070, v1071 = proto.readVarInt(p104, n70)

				n70 = v1071 + v1070
			end
		elseif v1065 == proto.wireTypes.i32 then
			local v1072

			v1072, n70 = proto.readFixed32(p104, n70)
		elseif v1065 == proto.wireTypes.i64 then
			local v1073

			v1073, n70 = proto.readFixed64(p104, n70)
		else
			error("Unsupported wire type: " .. v1065)
		end
	end

	return v1062
end
function t160.jsonEncode(p105) -- line: 6038
	-- upvalues: t1 (copy)
	local t162 = {}

	if p105.condition ~= nil then
		t162.condition = p105.condition:jsonEncode()
	end

	if p105.kind ~= nil then
		if p105.kind.type == "literal" then
			t162.literal = if typeof(p105.kind.value) ~= "number" then t1.VerticalAlignment.toNumber(p105.kind.value) else p105.kind.value

			return t162
		end

		if p105.kind.type == "binding_path" then
			t162.bindingPath = p105.kind.value
		end
	end

	return t162
end
function t160.jsonDecode(t163: {[any]: any}) -- line: 6058
	-- upvalues: t160 (copy), prop_condition (copy), t1 (copy)
	local v1077 = t160.new()

	if t163.condition ~= nil then
		v1077.condition = prop_condition.PropCondition.jsonDecode(t163.condition)
	end

	if t163.literal ~= nil then
		v1077.kind = {
			type = "literal",
			value = if typeof(t163.literal) ~= "number" then t1.VerticalAlignment.fromName(t163.literal) or t163.literal else t1.VerticalAlignment.fromNumber(t163.literal) or t163.literal
		}
	end

	if t163.binding_path ~= nil then
		v1077.kind = {
			type = "binding_path",
			value = t163.binding_path
		}
	end

	if t163.bindingPath ~= nil then
		v1077.kind = {
			type = "binding_path",
			value = t163.bindingPath
		}
	end

	return v1077
end

t160.descriptor = {
	name = "VerticalAlignmentProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}
t1.VerticalAlignmentProp_ConditionalOption = t160
typeRegistry.default:register(t1.VerticalAlignmentProp_ConditionalOption)

local t164 = {}

t164.__index = t164

function t164.new(t165: {[any]: any}?) -- line: 6102
	-- upvalues: t164 (copy)
	return (setmetatable({
		option = if t165 ~= nil and t165.option ~= nil then t165.option else {}
	}, t164))
end
function t164.encode(p106) -- line: 6110
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n71 = 0

	if p106.option ~= nil and #p106.option > 0 then
		for _, v1083 in p106.option do
			local v1084 = v1083:encode()
			local v1085, v1086 = proto.writeTag(buf, n71, 1, proto.wireTypes.lengthDelimited)

			buf, n71 = proto.writeBuffer(v1085, v1086, v1084, buffer.len(v1084))
		end
	end

	local buf37 = buffer.create(n71)

	buffer.copy(buf37, 0, buf, 0, n71)

	return buf37
end
function t164.decode(p107: buffer) -- line: 6129
	-- upvalues: t164 (copy), proto (copy), t1 (copy)
	local v1089 = t164.new()
	local n72 = 0

	while n72 < buffer.len(p107) do
		local v1091, v1092

		v1091, v1092, n72 = proto.readTag(p107, n72)

		if v1092 == proto.wireTypes.varint then
			local v1093

			v1093, n72 = proto.readVarInt(p107, n72)
		elseif v1092 == proto.wireTypes.lengthDelimited then
			if v1091 == 1 then
				local v1094

				v1094, n72 = proto.readBuffer(p107, n72)
				table.insert(v1089.option, t1.VerticalAlignmentProp_ConditionalOption.decode(v1094))
			else
				local v1095, v1096 = proto.readVarInt(p107, n72)

				n72 = v1096 + v1095
			end
		elseif v1092 == proto.wireTypes.i32 then
			local v1097

			v1097, n72 = proto.readFixed32(p107, n72)
		elseif v1092 == proto.wireTypes.i64 then
			local v1098

			v1098, n72 = proto.readFixed64(p107, n72)
		else
			error("Unsupported wire type: " .. v1092)
		end
	end

	return v1089
end
function t164.jsonEncode(p108) -- line: 6174
	local t166 = {}

	if p108.option ~= nil and #p108.option > 0 then
		local t167 = {}

		for _, v1103 in p108.option do
			table.insert(t167, v1103:jsonEncode())
		end

		t166.option = t167
	end

	return t166
end
function t164.jsonDecode(t168: {[any]: any}) -- line: 6190
	-- upvalues: t164 (copy), t1 (copy)
	local v1105 = t164.new()

	if t168.option ~= nil then
		local t169 = {}

		for _, v1108 in t168.option do
			table.insert(t169, t1.VerticalAlignmentProp_ConditionalOption.jsonDecode(v1108))
		end

		v1105.option = t169
	end

	return v1105
end

t164.descriptor = {
	name = "VerticalAlignmentProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}
t1.VerticalAlignmentProp_ConditionalOptions = t164
typeRegistry.default:register(t1.VerticalAlignmentProp_ConditionalOptions)
t1.AutomaticSize = {
	fromNumber = function(n73: number) -- line: 6218
		if n73 == 0 then
			return "AUTOMATIC_SIZE_INVALID"
		end

		if n73 == 1 then
			return "AUTOMATIC_SIZE_NONE"
		end

		if n73 == 2 then
			return "AUTOMATIC_SIZE_X"
		end

		if n73 == 3 then
			return "AUTOMATIC_SIZE_Y"
		end

		if n73 == 4 then
			return "AUTOMATIC_SIZE_XY"
		end

		return nil
	end,
	toNumber = function(p109) -- line: 6234
		if p109 == "AUTOMATIC_SIZE_INVALID" then
			return 0
		end

		if p109 == "AUTOMATIC_SIZE_NONE" then
			return 1
		end

		if p109 == "AUTOMATIC_SIZE_X" then
			return 2
		end

		if p109 == "AUTOMATIC_SIZE_Y" then
			return 3
		end

		if p109 == "AUTOMATIC_SIZE_XY" then
			return 4
		end

		return p109
	end,
	fromName = function(s1: string) -- line: 6250
		if s1 == "AUTOMATIC_SIZE_INVALID" then
			return "AUTOMATIC_SIZE_INVALID"
		end

		if s1 == "AUTOMATIC_SIZE_NONE" then
			return "AUTOMATIC_SIZE_NONE"
		end

		if s1 == "AUTOMATIC_SIZE_X" then
			return "AUTOMATIC_SIZE_X"
		end

		if s1 == "AUTOMATIC_SIZE_Y" then
			return "AUTOMATIC_SIZE_Y"
		end

		if s1 == "AUTOMATIC_SIZE_XY" then
			return "AUTOMATIC_SIZE_XY"
		end

		return nil
	end
}
t1.TextTruncate = {
	fromNumber = function(n74: number) -- line: 6268
		if n74 == 0 then
			return "TEXT_TRUNCATE_INVALID"
		end

		if n74 == 1 then
			return "TEXT_TRUNCATE_NONE"
		end

		if n74 == 2 then
			return "TEXT_TRUNCATE_AT_END"
		end

		if n74 == 3 then
			return "TEXT_TRUNCATE_SPLIT_WORD"
		end

		return nil
	end,
	toNumber = function(p110) -- line: 6282
		if p110 == "TEXT_TRUNCATE_INVALID" then
			return 0
		end

		if p110 == "TEXT_TRUNCATE_NONE" then
			return 1
		end

		if p110 == "TEXT_TRUNCATE_AT_END" then
			return 2
		end

		if p110 == "TEXT_TRUNCATE_SPLIT_WORD" then
			return 3
		end

		return p110
	end,
	fromName = function(s2: string) -- line: 6296
		if s2 == "TEXT_TRUNCATE_INVALID" then
			return "TEXT_TRUNCATE_INVALID"
		end

		if s2 == "TEXT_TRUNCATE_NONE" then
			return "TEXT_TRUNCATE_NONE"
		end

		if s2 == "TEXT_TRUNCATE_AT_END" then
			return "TEXT_TRUNCATE_AT_END"
		end

		if s2 == "TEXT_TRUNCATE_SPLIT_WORD" then
			return "TEXT_TRUNCATE_SPLIT_WORD"
		end

		return nil
	end
}
t1.TextXAlignment = {
	fromNumber = function(n75: number) -- line: 6312
		if n75 == 0 then
			return "TEXT_X_ALIGNMENT_INVALID"
		end

		if n75 == 1 then
			return "TEXT_X_ALIGNMENT_LEFT"
		end

		if n75 == 2 then
			return "TEXT_X_ALIGNMENT_CENTER"
		end

		if n75 == 3 then
			return "TEXT_X_ALIGNMENT_RIGHT"
		end

		return nil
	end,
	toNumber = function(p111) -- line: 6326
		if p111 == "TEXT_X_ALIGNMENT_INVALID" then
			return 0
		end

		if p111 == "TEXT_X_ALIGNMENT_LEFT" then
			return 1
		end

		if p111 == "TEXT_X_ALIGNMENT_CENTER" then
			return 2
		end

		if p111 == "TEXT_X_ALIGNMENT_RIGHT" then
			return 3
		end

		return p111
	end,
	fromName = function(s3: string) -- line: 6340
		if s3 == "TEXT_X_ALIGNMENT_INVALID" then
			return "TEXT_X_ALIGNMENT_INVALID"
		end

		if s3 == "TEXT_X_ALIGNMENT_LEFT" then
			return "TEXT_X_ALIGNMENT_LEFT"
		end

		if s3 == "TEXT_X_ALIGNMENT_CENTER" then
			return "TEXT_X_ALIGNMENT_CENTER"
		end

		if s3 == "TEXT_X_ALIGNMENT_RIGHT" then
			return "TEXT_X_ALIGNMENT_RIGHT"
		end

		return nil
	end
}
t1.TextYAlignment = {
	fromNumber = function(n76: number) -- line: 6356
		if n76 == 0 then
			return "TEXT_Y_ALIGNMENT_INVALID"
		end

		if n76 == 1 then
			return "TEXT_Y_ALIGNMENT_TOP"
		end

		if n76 == 2 then
			return "TEXT_Y_ALIGNMENT_CENTER"
		end

		if n76 == 3 then
			return "TEXT_Y_ALIGNMENT_BOTTOM"
		end

		return nil
	end,
	toNumber = function(p112) -- line: 6370
		if p112 == "TEXT_Y_ALIGNMENT_INVALID" then
			return 0
		end

		if p112 == "TEXT_Y_ALIGNMENT_TOP" then
			return 1
		end

		if p112 == "TEXT_Y_ALIGNMENT_CENTER" then
			return 2
		end

		if p112 == "TEXT_Y_ALIGNMENT_BOTTOM" then
			return 3
		end

		return p112
	end,
	fromName = function(s4: string) -- line: 6384
		if s4 == "TEXT_Y_ALIGNMENT_INVALID" then
			return "TEXT_Y_ALIGNMENT_INVALID"
		end

		if s4 == "TEXT_Y_ALIGNMENT_TOP" then
			return "TEXT_Y_ALIGNMENT_TOP"
		end

		if s4 == "TEXT_Y_ALIGNMENT_CENTER" then
			return "TEXT_Y_ALIGNMENT_CENTER"
		end

		if s4 == "TEXT_Y_ALIGNMENT_BOTTOM" then
			return "TEXT_Y_ALIGNMENT_BOTTOM"
		end

		return nil
	end
}
t1.UIFlexMode = {
	fromNumber = function(n77: number) -- line: 6400
		if n77 == 0 then
			return "UI_FLEX_MODE_INVALID"
		end

		if n77 == 1 then
			return "UI_FLEX_MODE_NONE"
		end

		if n77 == 2 then
			return "UI_FLEX_MODE_GROW"
		end

		if n77 == 3 then
			return "UI_FLEX_MODE_SHRINK"
		end

		if n77 == 4 then
			return "UI_FLEX_MODE_FILL"
		end

		if n77 == 5 then
			return "UI_FLEX_MODE_CUSTOM"
		end

		return nil
	end,
	toNumber = function(p113) -- line: 6418
		if p113 == "UI_FLEX_MODE_INVALID" then
			return 0
		end

		if p113 == "UI_FLEX_MODE_NONE" then
			return 1
		end

		if p113 == "UI_FLEX_MODE_GROW" then
			return 2
		end

		if p113 == "UI_FLEX_MODE_SHRINK" then
			return 3
		end

		if p113 == "UI_FLEX_MODE_FILL" then
			return 4
		end

		if p113 == "UI_FLEX_MODE_CUSTOM" then
			return 5
		end

		return p113
	end,
	fromName = function(s5: string) -- line: 6436
		if s5 == "UI_FLEX_MODE_INVALID" then
			return "UI_FLEX_MODE_INVALID"
		end

		if s5 == "UI_FLEX_MODE_NONE" then
			return "UI_FLEX_MODE_NONE"
		end

		if s5 == "UI_FLEX_MODE_GROW" then
			return "UI_FLEX_MODE_GROW"
		end

		if s5 == "UI_FLEX_MODE_SHRINK" then
			return "UI_FLEX_MODE_SHRINK"
		end

		if s5 == "UI_FLEX_MODE_FILL" then
			return "UI_FLEX_MODE_FILL"
		end

		if s5 == "UI_FLEX_MODE_CUSTOM" then
			return "UI_FLEX_MODE_CUSTOM"
		end

		return nil
	end
}
t1.ScaleType = {
	fromNumber = function(n78: number) -- line: 6456
		if n78 == 0 then
			return "SCALE_TYPE_INVALID"
		end

		if n78 == 1 then
			return "SCALE_TYPE_STRETCH"
		end

		if n78 == 2 then
			return "SCALE_TYPE_SLICE"
		end

		if n78 == 3 then
			return "SCALE_TYPE_TILE"
		end

		if n78 == 4 then
			return "SCALE_TYPE_FIT"
		end

		if n78 == 5 then
			return "SCALE_TYPE_CROP"
		end

		return nil
	end,
	toNumber = function(p114) -- line: 6474
		if p114 == "SCALE_TYPE_INVALID" then
			return 0
		end

		if p114 == "SCALE_TYPE_STRETCH" then
			return 1
		end

		if p114 == "SCALE_TYPE_SLICE" then
			return 2
		end

		if p114 == "SCALE_TYPE_TILE" then
			return 3
		end

		if p114 == "SCALE_TYPE_FIT" then
			return 4
		end

		if p114 == "SCALE_TYPE_CROP" then
			return 5
		end

		return p114
	end,
	fromName = function(s6: string) -- line: 6492
		if s6 == "SCALE_TYPE_INVALID" then
			return "SCALE_TYPE_INVALID"
		end

		if s6 == "SCALE_TYPE_STRETCH" then
			return "SCALE_TYPE_STRETCH"
		end

		if s6 == "SCALE_TYPE_SLICE" then
			return "SCALE_TYPE_SLICE"
		end

		if s6 == "SCALE_TYPE_TILE" then
			return "SCALE_TYPE_TILE"
		end

		if s6 == "SCALE_TYPE_FIT" then
			return "SCALE_TYPE_FIT"
		end

		if s6 == "SCALE_TYPE_CROP" then
			return "SCALE_TYPE_CROP"
		end

		return nil
	end
}
t1.ResamplerMode = {
	fromNumber = function(n79: number) -- line: 6512
		if n79 == 0 then
			return "RESAMPLER_MODE_INVALID"
		end

		if n79 == 1 then
			return "RESAMPLER_MODE_DEFAULT"
		end

		if n79 == 2 then
			return "RESAMPLER_MODE_PIXELATED"
		end

		return nil
	end,
	toNumber = function(p115) -- line: 6524
		if p115 == "RESAMPLER_MODE_INVALID" then
			return 0
		end

		if p115 == "RESAMPLER_MODE_DEFAULT" then
			return 1
		end

		if p115 == "RESAMPLER_MODE_PIXELATED" then
			return 2
		end

		return p115
	end,
	fromName = function(s7: string) -- line: 6536
		if s7 == "RESAMPLER_MODE_INVALID" then
			return "RESAMPLER_MODE_INVALID"
		end

		if s7 == "RESAMPLER_MODE_DEFAULT" then
			return "RESAMPLER_MODE_DEFAULT"
		end

		if s7 == "RESAMPLER_MODE_PIXELATED" then
			return "RESAMPLER_MODE_PIXELATED"
		end

		return nil
	end
}
t1.SizeConstraint = {
	fromNumber = function(n80: number) -- line: 6550
		if n80 == 0 then
			return "SIZE_CONSTRAINT_INVALID"
		end

		if n80 == 1 then
			return "SIZE_CONSTRAINT_RELATIVE_XY"
		end

		if n80 == 2 then
			return "SIZE_CONSTRAINT_RELATIVE_XX"
		end

		if n80 == 3 then
			return "SIZE_CONSTRAINT_RELATIVE_YY"
		end

		return nil
	end,
	toNumber = function(p116) -- line: 6564
		if p116 == "SIZE_CONSTRAINT_INVALID" then
			return 0
		end

		if p116 == "SIZE_CONSTRAINT_RELATIVE_XY" then
			return 1
		end

		if p116 == "SIZE_CONSTRAINT_RELATIVE_XX" then
			return 2
		end

		if p116 == "SIZE_CONSTRAINT_RELATIVE_YY" then
			return 3
		end

		return p116
	end,
	fromName = function(s8: string) -- line: 6578
		if s8 == "SIZE_CONSTRAINT_INVALID" then
			return "SIZE_CONSTRAINT_INVALID"
		end

		if s8 == "SIZE_CONSTRAINT_RELATIVE_XY" then
			return "SIZE_CONSTRAINT_RELATIVE_XY"
		end

		if s8 == "SIZE_CONSTRAINT_RELATIVE_XX" then
			return "SIZE_CONSTRAINT_RELATIVE_XX"
		end

		if s8 == "SIZE_CONSTRAINT_RELATIVE_YY" then
			return "SIZE_CONSTRAINT_RELATIVE_YY"
		end

		return nil
	end
}
t1.HorizontalAlignment = {
	fromNumber = function(n81: number) -- line: 6594
		if n81 == 0 then
			return "HORIZONTAL_ALIGNMENT_INVALID"
		end

		if n81 == 1 then
			return "HORIZONTAL_ALIGNMENT_LEFT"
		end

		if n81 == 2 then
			return "HORIZONTAL_ALIGNMENT_CENTER"
		end

		if n81 == 3 then
			return "HORIZONTAL_ALIGNMENT_RIGHT"
		end

		return nil
	end,
	toNumber = function(p117) -- line: 6608
		if p117 == "HORIZONTAL_ALIGNMENT_INVALID" then
			return 0
		end

		if p117 == "HORIZONTAL_ALIGNMENT_LEFT" then
			return 1
		end

		if p117 == "HORIZONTAL_ALIGNMENT_CENTER" then
			return 2
		end

		if p117 == "HORIZONTAL_ALIGNMENT_RIGHT" then
			return 3
		end

		return p117
	end,
	fromName = function(s9: string) -- line: 6622
		if s9 == "HORIZONTAL_ALIGNMENT_INVALID" then
			return "HORIZONTAL_ALIGNMENT_INVALID"
		end

		if s9 == "HORIZONTAL_ALIGNMENT_LEFT" then
			return "HORIZONTAL_ALIGNMENT_LEFT"
		end

		if s9 == "HORIZONTAL_ALIGNMENT_CENTER" then
			return "HORIZONTAL_ALIGNMENT_CENTER"
		end

		if s9 == "HORIZONTAL_ALIGNMENT_RIGHT" then
			return "HORIZONTAL_ALIGNMENT_RIGHT"
		end

		return nil
	end
}
t1.VerticalAlignment = {
	fromNumber = function(n82: number) -- line: 6638
		if n82 == 0 then
			return "VERTICAL_ALIGNMENT_INVALID"
		end

		if n82 == 1 then
			return "VERTICAL_ALIGNMENT_TOP"
		end

		if n82 == 2 then
			return "VERTICAL_ALIGNMENT_CENTER"
		end

		if n82 == 3 then
			return "VERTICAL_ALIGNMENT_BOTTOM"
		end

		return nil
	end,
	toNumber = function(p118) -- line: 6652
		if p118 == "VERTICAL_ALIGNMENT_INVALID" then
			return 0
		end

		if p118 == "VERTICAL_ALIGNMENT_TOP" then
			return 1
		end

		if p118 == "VERTICAL_ALIGNMENT_CENTER" then
			return 2
		end

		if p118 == "VERTICAL_ALIGNMENT_BOTTOM" then
			return 3
		end

		return p118
	end,
	fromName = function(s10: string) -- line: 6666
		if s10 == "VERTICAL_ALIGNMENT_INVALID" then
			return "VERTICAL_ALIGNMENT_INVALID"
		end

		if s10 == "VERTICAL_ALIGNMENT_TOP" then
			return "VERTICAL_ALIGNMENT_TOP"
		end

		if s10 == "VERTICAL_ALIGNMENT_CENTER" then
			return "VERTICAL_ALIGNMENT_CENTER"
		end

		if s10 == "VERTICAL_ALIGNMENT_BOTTOM" then
			return "VERTICAL_ALIGNMENT_BOTTOM"
		end

		return nil
	end
}
t1.SelectionBehavior = {
	fromNumber = function(n83: number) -- line: 6682
		if n83 == 0 then
			return "SELECTION_BEHAVIOR_INVALID"
		end

		if n83 == 1 then
			return "SELECTION_BEHAVIOR_ESCAPE"
		end

		if n83 == 2 then
			return "SELECTION_BEHAVIOR_STOP"
		end

		return nil
	end,
	toNumber = function(p119) -- line: 6694
		if p119 == "SELECTION_BEHAVIOR_INVALID" then
			return 0
		end

		if p119 == "SELECTION_BEHAVIOR_ESCAPE" then
			return 1
		end

		if p119 == "SELECTION_BEHAVIOR_STOP" then
			return 2
		end

		return p119
	end,
	fromName = function(s11: string) -- line: 6706
		if s11 == "SELECTION_BEHAVIOR_INVALID" then
			return "SELECTION_BEHAVIOR_INVALID"
		end

		if s11 == "SELECTION_BEHAVIOR_ESCAPE" then
			return "SELECTION_BEHAVIOR_ESCAPE"
		end

		if s11 == "SELECTION_BEHAVIOR_STOP" then
			return "SELECTION_BEHAVIOR_STOP"
		end

		return nil
	end
}
t1.KeyCode = {
	fromNumber = function(n84: number) -- line: 6720
		if n84 == 0 then
			return "KEY_CODE_INVALID"
		end

		if n84 == 1 then
			return "KEY_CODE_BUTTON_A"
		end

		if n84 == 2 then
			return "KEY_CODE_BUTTON_B"
		end

		if n84 == 3 then
			return "KEY_CODE_BUTTON_X"
		end

		if n84 == 4 then
			return "KEY_CODE_BUTTON_Y"
		end

		if n84 == 5 then
			return "KEY_CODE_BUTTON_L1"
		end

		if n84 == 6 then
			return "KEY_CODE_BUTTON_R1"
		end

		if n84 == 7 then
			return "KEY_CODE_BUTTON_L2"
		end

		if n84 == 8 then
			return "KEY_CODE_BUTTON_R2"
		end

		if n84 == 9 then
			return "KEY_CODE_BUTTON_L3"
		end

		if n84 == 10 then
			return "KEY_CODE_BUTTON_R3"
		end

		return nil
	end,
	toNumber = function(p120) -- line: 6748
		if p120 == "KEY_CODE_INVALID" then
			return 0
		end

		if p120 == "KEY_CODE_BUTTON_A" then
			return 1
		end

		if p120 == "KEY_CODE_BUTTON_B" then
			return 2
		end

		if p120 == "KEY_CODE_BUTTON_X" then
			return 3
		end

		if p120 == "KEY_CODE_BUTTON_Y" then
			return 4
		end

		if p120 == "KEY_CODE_BUTTON_L1" then
			return 5
		end

		if p120 == "KEY_CODE_BUTTON_R1" then
			return 6
		end

		if p120 == "KEY_CODE_BUTTON_L2" then
			return 7
		end

		if p120 == "KEY_CODE_BUTTON_R2" then
			return 8
		end

		if p120 == "KEY_CODE_BUTTON_L3" then
			return 9
		end

		if p120 == "KEY_CODE_BUTTON_R3" then
			return 10
		end

		return p120
	end,
	fromName = function(s12: string) -- line: 6776
		if s12 == "KEY_CODE_INVALID" then
			return "KEY_CODE_INVALID"
		end

		if s12 == "KEY_CODE_BUTTON_A" then
			return "KEY_CODE_BUTTON_A"
		end

		if s12 == "KEY_CODE_BUTTON_B" then
			return "KEY_CODE_BUTTON_B"
		end

		if s12 == "KEY_CODE_BUTTON_X" then
			return "KEY_CODE_BUTTON_X"
		end

		if s12 == "KEY_CODE_BUTTON_Y" then
			return "KEY_CODE_BUTTON_Y"
		end

		if s12 == "KEY_CODE_BUTTON_L1" then
			return "KEY_CODE_BUTTON_L1"
		end

		if s12 == "KEY_CODE_BUTTON_R1" then
			return "KEY_CODE_BUTTON_R1"
		end

		if s12 == "KEY_CODE_BUTTON_L2" then
			return "KEY_CODE_BUTTON_L2"
		end

		if s12 == "KEY_CODE_BUTTON_R2" then
			return "KEY_CODE_BUTTON_R2"
		end

		if s12 == "KEY_CODE_BUTTON_L3" then
			return "KEY_CODE_BUTTON_L3"
		end

		if s12 == "KEY_CODE_BUTTON_R3" then
			return "KEY_CODE_BUTTON_R3"
		end

		return nil
	end
}

return {
	AutomaticSizeProp = t1.AutomaticSizeProp,
	AutomaticSizeProp_ConditionalOption = t1.AutomaticSizeProp_ConditionalOption,
	AutomaticSizeProp_ConditionalOptions = t1.AutomaticSizeProp_ConditionalOptions,
	TextTruncateProp = t1.TextTruncateProp,
	TextTruncateProp_ConditionalOption = t1.TextTruncateProp_ConditionalOption,
	TextTruncateProp_ConditionalOptions = t1.TextTruncateProp_ConditionalOptions,
	TextXAlignmentProp = t1.TextXAlignmentProp,
	TextXAlignmentProp_ConditionalOption = t1.TextXAlignmentProp_ConditionalOption,
	TextXAlignmentProp_ConditionalOptions = t1.TextXAlignmentProp_ConditionalOptions,
	TextYAlignmentProp = t1.TextYAlignmentProp,
	TextYAlignmentProp_ConditionalOption = t1.TextYAlignmentProp_ConditionalOption,
	TextYAlignmentProp_ConditionalOptions = t1.TextYAlignmentProp_ConditionalOptions,
	UIFlexModeProp = t1.UIFlexModeProp,
	UIFlexModeProp_ConditionalOption = t1.UIFlexModeProp_ConditionalOption,
	UIFlexModeProp_ConditionalOptions = t1.UIFlexModeProp_ConditionalOptions,
	ScaleTypeProp = t1.ScaleTypeProp,
	ScaleTypeProp_ConditionalOption = t1.ScaleTypeProp_ConditionalOption,
	ScaleTypeProp_ConditionalOptions = t1.ScaleTypeProp_ConditionalOptions,
	ResamplerModeProp = t1.ResamplerModeProp,
	ResamplerModeProp_ConditionalOption = t1.ResamplerModeProp_ConditionalOption,
	ResamplerModeProp_ConditionalOptions = t1.ResamplerModeProp_ConditionalOptions,
	SizeConstraintProp = t1.SizeConstraintProp,
	SizeConstraintProp_ConditionalOption = t1.SizeConstraintProp_ConditionalOption,
	SizeConstraintProp_ConditionalOptions = t1.SizeConstraintProp_ConditionalOptions,
	HorizontalAlignmentProp = t1.HorizontalAlignmentProp,
	HorizontalAlignmentProp_ConditionalOption = t1.HorizontalAlignmentProp_ConditionalOption,
	HorizontalAlignmentProp_ConditionalOptions = t1.HorizontalAlignmentProp_ConditionalOptions,
	SelectionBehaviorProp = t1.SelectionBehaviorProp,
	SelectionBehaviorProp_ConditionalOption = t1.SelectionBehaviorProp_ConditionalOption,
	SelectionBehaviorProp_ConditionalOptions = t1.SelectionBehaviorProp_ConditionalOptions,
	KeyCodeProp = t1.KeyCodeProp,
	KeyCodeProp_ConditionalOption = t1.KeyCodeProp_ConditionalOption,
	KeyCodeProp_ConditionalOptions = t1.KeyCodeProp_ConditionalOptions,
	VerticalAlignmentProp = t1.VerticalAlignmentProp,
	VerticalAlignmentProp_ConditionalOption = t1.VerticalAlignmentProp_ConditionalOption,
	VerticalAlignmentProp_ConditionalOptions = t1.VerticalAlignmentProp_ConditionalOptions,
	AutomaticSize = t1.AutomaticSize,
	TextTruncate = t1.TextTruncate,
	TextXAlignment = t1.TextXAlignment,
	TextYAlignment = t1.TextYAlignment,
	UIFlexMode = t1.UIFlexMode,
	ScaleType = t1.ScaleType,
	ResamplerMode = t1.ResamplerMode,
	SizeConstraint = t1.SizeConstraint,
	HorizontalAlignment = t1.HorizontalAlignment,
	VerticalAlignment = t1.VerticalAlignment,
	SelectionBehavior = t1.SelectionBehavior,
	KeyCode = t1.KeyCode
}
