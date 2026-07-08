local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local background_layer = require(script.Parent.background_layer)
local catalog_sort_data = require(script.Parent.catalog_sort_data)
local hydration_data_spec = require(script.Parent.hydration_data_spec)
local prop_condition = require(script.Parent.prop_condition)
local prop_types = require(script.Parent.prop_types)
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 689
	-- upvalues: t2 (copy)
	return (setmetatable({
		content_type = if t3 ~= nil and t3.content_type ~= nil then t3.content_type else nil
	}, t2))
end
function t2.encode(p1) -- line: 695
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.content_type ~= nil then
		local v35 = p1.content_type:encode()
		local v36, v37 = proto.writeTag(buf, n1, 1, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeBuffer(v36, v37, v35, buffer.len(v35))
	end

	local buf2 = buffer.create(n1)

	buffer.copy(buf2, 0, buf, 0, n1)

	return buf2
end
function t2.decode(p2: buffer) -- line: 710
	-- upvalues: t2 (copy), proto (copy), prop_types (copy)
	local v40 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v42, v43

		v42, v43, n2 = proto.readTag(p2, n2)

		if v43 == proto.wireTypes.varint then
			local v44

			v44, n2 = proto.readVarInt(p2, n2)
		elseif v43 == proto.wireTypes.lengthDelimited then
			if v42 == 1 then
				local v45

				v45, n2 = proto.readBuffer(p2, n2)
				v40.content_type = prop_types.StringProp.decode(v45)
			else
				local v46, v47 = proto.readVarInt(p2, n2)

				n2 = v47 + v46
			end
		elseif v43 == proto.wireTypes.i32 then
			local v48

			v48, n2 = proto.readFixed32(p2, n2)
		elseif v43 == proto.wireTypes.i64 then
			local v49

			v49, n2 = proto.readFixed64(p2, n2)
		else
			error("Unsupported wire type: " .. v43)
		end
	end

	return v40
end
function t2.jsonEncode(p3) -- line: 753
	local t4 = {}

	if p3.content_type ~= nil then
		t4.contentType = p3.content_type:jsonEncode()
	end

	return t4
end
function t2.jsonDecode(t5: {[any]: any}) -- line: 763
	-- upvalues: t2 (copy), prop_types (copy)
	local v53 = t2.new()

	if t5.content_type ~= nil then
		v53.content_type = prop_types.StringProp.jsonDecode(t5.content_type)
	end

	if t5.contentType ~= nil then
		v53.content_type = prop_types.StringProp.jsonDecode(t5.contentType)
	end

	return v53
end

t2.descriptor = {
	name = "ItemFooter",
	fullName = "roblox.apppageplatform.shared.v1beta1.ItemFooter"
}
t1.ItemFooter = t2
typeRegistry.default:register(t1.ItemFooter)

local t6 = {}

t6.__index = t6

function t6.new(t7: {[any]: any}?) -- line: 793
	-- upvalues: t6 (copy)
	return (setmetatable({
		kind = if t7 ~= nil and t7.kind ~= nil then t7.kind else nil
	}, t6))
end
function t6.encode(p4) -- line: 799
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n3 = 0

	if p4.kind ~= nil then
		if p4.kind.type == "literal" then
			local v58 = p4.kind.value:encode()
			local v59, v60 = proto.writeTag(buf, n3, 1, proto.wireTypes.lengthDelimited)

			buf, n3 = proto.writeBuffer(v59, v60, v58, buffer.len(v58))
		elseif p4.kind.type == "binding_path" then
			local v61, v62 = proto.writeTag(buf, n3, 2, proto.wireTypes.lengthDelimited)

			buf, n3 = proto.writeString(v61, v62, p4.kind.value)
		elseif p4.kind.type == "conditional" then
			local v63 = p4.kind.value:encode()
			local v64, v65 = proto.writeTag(buf, n3, 3, proto.wireTypes.lengthDelimited)

			buf, n3 = proto.writeBuffer(v64, v65, v63, buffer.len(v63))
		elseif p4.kind.type == "array_map" then
			local v66 = p4.kind.value:encode()
			local v67, v68 = proto.writeTag(buf, n3, 4, proto.wireTypes.lengthDelimited)

			buf, n3 = proto.writeBuffer(v67, v68, v66, buffer.len(v66))
		end
	end

	local buf3 = buffer.create(n3)

	buffer.copy(buf3, 0, buf, 0, n3)

	return buf3
end
function t6.decode(p5: buffer) -- line: 827
	-- upvalues: t6 (copy), proto (copy), t1 (copy)
	local v71 = t6.new()
	local n4 = 0

	while n4 < buffer.len(p5) do
		local v73, v74

		v73, v74, n4 = proto.readTag(p5, n4)

		if v74 == proto.wireTypes.varint then
			local v75

			v75, n4 = proto.readVarInt(p5, n4)
		elseif v74 == proto.wireTypes.lengthDelimited then
			if v73 == 1 then
				local v76

				v76, n4 = proto.readBuffer(p5, n4)
				v71.kind = {
					type = "literal",
					value = t1.ArrayOfItemFooterProp_ArrayOfItemFooter.decode(v76)
				}
			elseif v73 == 2 then
				local v77

				v77, n4 = proto.readBuffer(p5, n4)
				v71.kind = {
					type = "binding_path",
					value = buffer.tostring(v77)
				}
			elseif v73 == 3 then
				local v78

				v78, n4 = proto.readBuffer(p5, n4)
				v71.kind = {
					type = "conditional",
					value = t1.ArrayOfItemFooterProp_ConditionalOptions.decode(v78)
				}
			elseif v73 == 4 then
				local v79

				v79, n4 = proto.readBuffer(p5, n4)
				v71.kind = {
					type = "array_map",
					value = t1.ArrayOfItemFooterProp_ArrayMap.decode(v79)
				}
			else
				local v80, v81 = proto.readVarInt(p5, n4)

				n4 = v81 + v80
			end
		elseif v74 == proto.wireTypes.i32 then
			local v82

			v82, n4 = proto.readFixed32(p5, n4)
		elseif v74 == proto.wireTypes.i64 then
			local v83

			v83, n4 = proto.readFixed64(p5, n4)
		else
			error("Unsupported wire type: " .. v74)
		end
	end

	return v71
end
function t6.jsonEncode(p6) -- line: 889
	local t8 = {}

	if p6.kind ~= nil then
		if p6.kind.type == "literal" then
			t8.literal = p6.kind.value:jsonEncode()

			return t8
		end

		if p6.kind.type == "binding_path" then
			t8.bindingPath = p6.kind.value

			return t8
		end

		if p6.kind.type == "conditional" then
			t8.conditional = p6.kind.value:jsonEncode()

			return t8
		end

		if p6.kind.type == "array_map" then
			t8.arrayMap = p6.kind.value:jsonEncode()
		end
	end

	return t8
end
function t6.jsonDecode(t9: {[any]: any}) -- line: 907
	-- upvalues: t6 (copy), t1 (copy)
	local v87 = t6.new()

	if t9.literal ~= nil then
		v87.kind = {
			type = "literal",
			value = t1.ArrayOfItemFooterProp_ArrayOfItemFooter.jsonDecode(t9.literal)
		}
	end

	if t9.binding_path ~= nil then
		v87.kind = {
			type = "binding_path",
			value = t9.binding_path
		}
	end

	if t9.bindingPath ~= nil then
		v87.kind = {
			type = "binding_path",
			value = t9.bindingPath
		}
	end

	if t9.conditional ~= nil then
		v87.kind = {
			type = "conditional",
			value = t1.ArrayOfItemFooterProp_ConditionalOptions.jsonDecode(t9.conditional)
		}
	end

	if t9.array_map ~= nil then
		v87.kind = {
			type = "array_map",
			value = t1.ArrayOfItemFooterProp_ArrayMap.jsonDecode(t9.array_map)
		}
	end

	if t9.arrayMap ~= nil then
		v87.kind = {
			type = "array_map",
			value = t1.ArrayOfItemFooterProp_ArrayMap.jsonDecode(t9.arrayMap)
		}
	end

	return v87
end

t6.descriptor = {
	name = "ArrayOfItemFooterProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.ArrayOfItemFooterProp"
}
t1.ArrayOfItemFooterProp = t6
typeRegistry.default:register(t1.ArrayOfItemFooterProp)

local t10 = {}

t10.__index = t10

function t10.new(t11: {[any]: any}?) -- line: 957
	-- upvalues: t10 (copy)
	return (setmetatable({
		condition = if t11 ~= nil and t11.condition ~= nil then t11.condition else nil,
		kind = if t11 ~= nil and t11.kind ~= nil then t11.kind else nil
	}, t10))
end
function t10.encode(p7) -- line: 966
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n5 = 0

	if p7.condition ~= nil then
		local v92 = p7.condition:encode()
		local v93, v94 = proto.writeTag(buf, n5, 1, proto.wireTypes.lengthDelimited)

		buf, n5 = proto.writeBuffer(v93, v94, v92, buffer.len(v92))
	end

	if p7.kind ~= nil then
		if p7.kind.type == "literal" then
			local v95 = p7.kind.value:encode()
			local v96, v97 = proto.writeTag(buf, n5, 2, proto.wireTypes.lengthDelimited)

			buf, n5 = proto.writeBuffer(v96, v97, v95, buffer.len(v95))
		elseif p7.kind.type == "binding_path" then
			local v98, v99 = proto.writeTag(buf, n5, 3, proto.wireTypes.lengthDelimited)

			buf, n5 = proto.writeString(v98, v99, p7.kind.value)
		end
	end

	local buf4 = buffer.create(n5)

	buffer.copy(buf4, 0, buf, 0, n5)

	return buf4
end
function t10.decode(p8: buffer) -- line: 992
	-- upvalues: t10 (copy), proto (copy), prop_condition (copy), t1 (copy)
	local v102 = t10.new()
	local n6 = 0

	while n6 < buffer.len(p8) do
		local v104, v105

		v104, v105, n6 = proto.readTag(p8, n6)

		if v105 == proto.wireTypes.varint then
			local v106

			v106, n6 = proto.readVarInt(p8, n6)
		elseif v105 == proto.wireTypes.lengthDelimited then
			if v104 == 1 then
				local v107

				v107, n6 = proto.readBuffer(p8, n6)
				v102.condition = prop_condition.PropCondition.decode(v107)
			elseif v104 == 2 then
				local v108

				v108, n6 = proto.readBuffer(p8, n6)
				v102.kind = {
					type = "literal",
					value = t1.ArrayOfItemFooterProp_ArrayOfItemFooter.decode(v108)
				}
			elseif v104 == 3 then
				local v109

				v109, n6 = proto.readBuffer(p8, n6)
				v102.kind = {
					type = "binding_path",
					value = buffer.tostring(v109)
				}
			else
				local v110, v111 = proto.readVarInt(p8, n6)

				n6 = v111 + v110
			end
		elseif v105 == proto.wireTypes.i32 then
			local v112

			v112, n6 = proto.readFixed32(p8, n6)
		elseif v105 == proto.wireTypes.i64 then
			local v113

			v113, n6 = proto.readFixed64(p8, n6)
		else
			error("Unsupported wire type: " .. v105)
		end
	end

	return v102
end
function t10.jsonEncode(p9) -- line: 1046
	local t12 = {}

	if p9.condition ~= nil then
		t12.condition = p9.condition:jsonEncode()
	end

	if p9.kind ~= nil then
		if p9.kind.type == "literal" then
			t12.literal = p9.kind.value:jsonEncode()

			return t12
		end

		if p9.kind.type == "binding_path" then
			t12.bindingPath = p9.kind.value
		end
	end

	return t12
end
function t10.jsonDecode(t13: {[any]: any}) -- line: 1064
	-- upvalues: t10 (copy), prop_condition (copy), t1 (copy)
	local v117 = t10.new()

	if t13.condition ~= nil then
		v117.condition = prop_condition.PropCondition.jsonDecode(t13.condition)
	end

	if t13.literal ~= nil then
		v117.kind = {
			type = "literal",
			value = t1.ArrayOfItemFooterProp_ArrayOfItemFooter.jsonDecode(t13.literal)
		}
	end

	if t13.binding_path ~= nil then
		v117.kind = {
			type = "binding_path",
			value = t13.binding_path
		}
	end

	if t13.bindingPath ~= nil then
		v117.kind = {
			type = "binding_path",
			value = t13.bindingPath
		}
	end

	return v117
end

t10.descriptor = {
	name = "ArrayOfItemFooterProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}
t1.ArrayOfItemFooterProp_ConditionalOption = t10
typeRegistry.default:register(t1.ArrayOfItemFooterProp_ConditionalOption)

local t14 = {}

t14.__index = t14

function t14.new(t15: {[any]: any}?) -- line: 1104
	-- upvalues: t14 (copy)
	return (setmetatable({
		options = if t15 ~= nil and t15.options ~= nil then t15.options else {}
	}, t14))
end
function t14.encode(p10) -- line: 1112
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n7 = 0

	if p10.options ~= nil and #p10.options > 0 then
		for _, v123 in p10.options do
			local v124 = v123:encode()
			local v125, v126 = proto.writeTag(buf, n7, 1, proto.wireTypes.lengthDelimited)

			buf, n7 = proto.writeBuffer(v125, v126, v124, buffer.len(v124))
		end
	end

	local buf5 = buffer.create(n7)

	buffer.copy(buf5, 0, buf, 0, n7)

	return buf5
end
function t14.decode(p11: buffer) -- line: 1131
	-- upvalues: t14 (copy), proto (copy), t1 (copy)
	local v129 = t14.new()
	local n8 = 0

	while n8 < buffer.len(p11) do
		local v131, v132

		v131, v132, n8 = proto.readTag(p11, n8)

		if v132 == proto.wireTypes.varint then
			local v133

			v133, n8 = proto.readVarInt(p11, n8)
		elseif v132 == proto.wireTypes.lengthDelimited then
			if v131 == 1 then
				local v134

				v134, n8 = proto.readBuffer(p11, n8)
				table.insert(v129.options, t1.ArrayOfItemFooterProp_ConditionalOption.decode(v134))
			else
				local v135, v136 = proto.readVarInt(p11, n8)

				n8 = v136 + v135
			end
		elseif v132 == proto.wireTypes.i32 then
			local v137

			v137, n8 = proto.readFixed32(p11, n8)
		elseif v132 == proto.wireTypes.i64 then
			local v138

			v138, n8 = proto.readFixed64(p11, n8)
		else
			error("Unsupported wire type: " .. v132)
		end
	end

	return v129
end
function t14.jsonEncode(p12) -- line: 1176
	local t16 = {}

	if p12.options ~= nil and #p12.options > 0 then
		local t17 = {}

		for _, v143 in p12.options do
			table.insert(t17, v143:jsonEncode())
		end

		t16.options = t17
	end

	return t16
end
function t14.jsonDecode(t18: {[any]: any}) -- line: 1192
	-- upvalues: t14 (copy), t1 (copy)
	local v145 = t14.new()

	if t18.options ~= nil then
		local t19 = {}

		for _, v148 in t18.options do
			table.insert(t19, t1.ArrayOfItemFooterProp_ConditionalOption.jsonDecode(v148))
		end

		v145.options = t19
	end

	return v145
end

t14.descriptor = {
	name = "ArrayOfItemFooterProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}
t1.ArrayOfItemFooterProp_ConditionalOptions = t14
typeRegistry.default:register(t1.ArrayOfItemFooterProp_ConditionalOptions)

local t20 = {}

t20.__index = t20

function t20.new(t21: {[any]: any}?) -- line: 1223
	-- upvalues: t20 (copy)
	return (setmetatable({
		array = if t21 ~= nil and t21.array ~= nil then t21.array else {}
	}, t20))
end
function t20.encode(p13) -- line: 1231
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n9 = 0

	if p13.array ~= nil and #p13.array > 0 then
		for _, v154 in p13.array do
			local v155 = v154:encode()
			local v156, v157 = proto.writeTag(buf, n9, 1, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v156, v157, v155, buffer.len(v155))
		end
	end

	local buf6 = buffer.create(n9)

	buffer.copy(buf6, 0, buf, 0, n9)

	return buf6
end
function t20.decode(p14: buffer) -- line: 1248
	-- upvalues: t20 (copy), proto (copy), t1 (copy)
	local v160 = t20.new()
	local n10 = 0

	while n10 < buffer.len(p14) do
		local v162, v163

		v162, v163, n10 = proto.readTag(p14, n10)

		if v163 == proto.wireTypes.varint then
			local v164

			v164, n10 = proto.readVarInt(p14, n10)
		elseif v163 == proto.wireTypes.lengthDelimited then
			if v162 == 1 then
				local v165

				v165, n10 = proto.readBuffer(p14, n10)
				table.insert(v160.array, t1.ItemFooter.decode(v165))
			else
				local v166, v167 = proto.readVarInt(p14, n10)

				n10 = v167 + v166
			end
		elseif v163 == proto.wireTypes.i32 then
			local v168

			v168, n10 = proto.readFixed32(p14, n10)
		elseif v163 == proto.wireTypes.i64 then
			local v169

			v169, n10 = proto.readFixed64(p14, n10)
		else
			error("Unsupported wire type: " .. v163)
		end
	end

	return v160
end
function t20.jsonEncode(p15) -- line: 1291
	local t22 = {}

	if p15.array ~= nil and #p15.array > 0 then
		local t23 = {}

		for _, v174 in p15.array do
			table.insert(t23, v174:jsonEncode())
		end

		t22.array = t23
	end

	return t22
end
function t20.jsonDecode(t24: {[any]: any}) -- line: 1305
	-- upvalues: t20 (copy), t1 (copy)
	local v176 = t20.new()

	if t24.array ~= nil then
		local t25 = {}

		for _, v179 in t24.array do
			table.insert(t25, t1.ItemFooter.jsonDecode(v179))
		end

		v176.array = t25
	end

	return v176
end

t20.descriptor = {
	name = "ArrayOfItemFooterProp_ArrayOfItemFooter",
	fullName = "roblox.apppageplatform.shared.v1beta1.ArrayOfItemFooter"
}
t1.ArrayOfItemFooterProp_ArrayOfItemFooter = t20
typeRegistry.default:register(t1.ArrayOfItemFooterProp_ArrayOfItemFooter)

local t26 = {}

t26.__index = t26

function t26.new(t27: {[any]: any}?) -- line: 1336
	-- upvalues: t26 (copy)
	return (setmetatable({
		kind = if t27 ~= nil and t27.kind ~= nil then t27.kind else nil,
		item_hydration_specs = if t27 ~= nil and t27.item_hydration_specs ~= nil then t27.item_hydration_specs else {},
		field_map = if t27 ~= nil and t27.field_map ~= nil then t27.field_map else nil
	}, t26))
end
function t26.encode(p16) -- line: 1348
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n11 = 0

	if p16.kind ~= nil then
		if p16.kind.type == "binding_path" then
			local v184, v185 = proto.writeTag(buf, n11, 1, proto.wireTypes.lengthDelimited)

			buf, n11 = proto.writeString(v184, v185, p16.kind.value)
		elseif p16.kind.type == "literal" then
			local v186 = p16.kind.value:encode()
			local v187, v188 = proto.writeTag(buf, n11, 2, proto.wireTypes.lengthDelimited)

			buf, n11 = proto.writeBuffer(v187, v188, v186, buffer.len(v186))
		end
	end

	if p16.item_hydration_specs ~= nil and #p16.item_hydration_specs > 0 then
		for _, v190 in p16.item_hydration_specs do
			local v191 = v190:encode()
			local v192, v193 = proto.writeTag(buf, n11, 3, proto.wireTypes.lengthDelimited)

			buf, n11 = proto.writeBuffer(v192, v193, v191, buffer.len(v191))
		end
	end

	if p16.field_map ~= nil then
		local v194 = p16.field_map:encode()
		local v195, v196 = proto.writeTag(buf, n11, 4, proto.wireTypes.lengthDelimited)

		buf, n11 = proto.writeBuffer(v195, v196, v194, buffer.len(v194))
	end

	local buf7 = buffer.create(n11)

	buffer.copy(buf7, 0, buf, 0, n11)

	return buf7
end
function t26.decode(p17: buffer) -- line: 1382
	-- upvalues: t26 (copy), proto (copy), t1 (copy), hydration_data_spec (copy)
	local v199 = t26.new()
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
				v199.kind = {
					type = "binding_path",
					value = buffer.tostring(v204)
				}
			elseif v201 == 2 then
				local v205

				v205, n12 = proto.readBuffer(p17, n12)
				v199.kind = {
					type = "literal",
					value = t1.ArrayOfItemFooterProp_ArrayMap_LiteralItems.decode(v205)
				}
			elseif v201 == 3 then
				local v206

				v206, n12 = proto.readBuffer(p17, n12)
				table.insert(v199.item_hydration_specs, hydration_data_spec.HydrationDataSpec.decode(v206))
			elseif v201 == 4 then
				local v207

				v207, n12 = proto.readBuffer(p17, n12)
				v199.field_map = t1.ItemFooter.decode(v207)
			else
				local v208, v209 = proto.readVarInt(p17, n12)

				n12 = v209 + v208
			end
		elseif v202 == proto.wireTypes.i32 then
			local v210

			v210, n12 = proto.readFixed32(p17, n12)
		elseif v202 == proto.wireTypes.i64 then
			local v211

			v211, n12 = proto.readFixed64(p17, n12)
		else
			error("Unsupported wire type: " .. v202)
		end
	end

	return v199
end
function t26.jsonEncode(p18) -- line: 1444
	local t28 = {}

	if p18.kind ~= nil then
		if p18.kind.type == "binding_path" then
			t28.bindingPath = p18.kind.value
		elseif p18.kind.type == "literal" then
			t28.literal = p18.kind.value:jsonEncode()
		end
	end

	if p18.item_hydration_specs ~= nil and #p18.item_hydration_specs > 0 then
		local t29 = {}

		for _, v216 in p18.item_hydration_specs do
			table.insert(t29, v216:jsonEncode())
		end

		t28.itemHydrationSpecs = t29
	end

	if p18.field_map ~= nil then
		t28.fieldMap = p18.field_map:jsonEncode()
	end

	return t28
end
function t26.jsonDecode(t30: {[any]: any}) -- line: 1470
	-- upvalues: t26 (copy), t1 (copy), hydration_data_spec (copy)
	local v218 = t26.new()

	if t30.binding_path ~= nil then
		v218.kind = {
			type = "binding_path",
			value = t30.binding_path
		}
	end

	if t30.bindingPath ~= nil then
		v218.kind = {
			type = "binding_path",
			value = t30.bindingPath
		}
	end

	if t30.literal ~= nil then
		v218.kind = {
			type = "literal",
			value = t1.ArrayOfItemFooterProp_ArrayMap_LiteralItems.jsonDecode(t30.literal)
		}
	end

	if t30.item_hydration_specs ~= nil then
		local t31 = {}

		for _, v221 in t30.item_hydration_specs do
			table.insert(t31, hydration_data_spec.HydrationDataSpec.jsonDecode(v221))
		end

		v218.item_hydration_specs = t31
	end

	if t30.itemHydrationSpecs ~= nil then
		local t32 = {}

		for _, v224 in t30.itemHydrationSpecs do
			table.insert(t32, hydration_data_spec.HydrationDataSpec.jsonDecode(v224))
		end

		v218.item_hydration_specs = t32
	end

	if t30.field_map ~= nil then
		v218.field_map = t1.ItemFooter.jsonDecode(t30.field_map)
	end

	if t30.fieldMap ~= nil then
		v218.field_map = t1.ItemFooter.jsonDecode(t30.fieldMap)
	end

	return v218
end

t26.descriptor = {
	name = "ArrayOfItemFooterProp_ArrayMap",
	fullName = "roblox.apppageplatform.shared.v1beta1.ArrayMap"
}
t1.ArrayOfItemFooterProp_ArrayMap = t26
typeRegistry.default:register(t1.ArrayOfItemFooterProp_ArrayMap)

local t33 = {}

t33.__index = t33

function t33.new(t34: {[any]: any}?) -- line: 1537
	-- upvalues: t33 (copy)
	return (setmetatable({
		items = if t34 ~= nil and t34.items ~= nil then t34.items else {}
	}, t33))
end
function t33.encode(p19) -- line: 1545
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n13 = 0

	if p19.items ~= nil and #p19.items > 0 then
		for _, v230 in p19.items do
			local v231 = v230:encode()
			local v232, v233 = proto.writeTag(buf, n13, 1, proto.wireTypes.lengthDelimited)

			buf, n13 = proto.writeBuffer(v232, v233, v231, buffer.len(v231))
		end
	end

	local buf8 = buffer.create(n13)

	buffer.copy(buf8, 0, buf, 0, n13)

	return buf8
end
function t33.decode(p20: buffer) -- line: 1564
	-- upvalues: t33 (copy), proto (copy), catalog_sort_data (copy)
	local v236 = t33.new()
	local n14 = 0

	while n14 < buffer.len(p20) do
		local v238, v239

		v238, v239, n14 = proto.readTag(p20, n14)

		if v239 == proto.wireTypes.varint then
			local v240

			v240, n14 = proto.readVarInt(p20, n14)
		elseif v239 == proto.wireTypes.lengthDelimited then
			if v238 == 1 then
				local v241

				v241, n14 = proto.readBuffer(p20, n14)
				table.insert(v236.items, catalog_sort_data.CatalogSortCardItemFooter.decode(v241))
			else
				local v242, v243 = proto.readVarInt(p20, n14)

				n14 = v243 + v242
			end
		elseif v239 == proto.wireTypes.i32 then
			local v244

			v244, n14 = proto.readFixed32(p20, n14)
		elseif v239 == proto.wireTypes.i64 then
			local v245

			v245, n14 = proto.readFixed64(p20, n14)
		else
			error("Unsupported wire type: " .. v239)
		end
	end

	return v236
end
function t33.jsonEncode(p21) -- line: 1612
	local t35 = {}

	if p21.items ~= nil and #p21.items > 0 then
		local t36 = {}

		for _, v250 in p21.items do
			table.insert(t36, v250:jsonEncode())
		end

		t35.items = t36
	end

	return t35
end
function t33.jsonDecode(t37: {[any]: any}) -- line: 1628
	-- upvalues: t33 (copy), catalog_sort_data (copy)
	local v252 = t33.new()

	if t37.items ~= nil then
		local t38 = {}

		for _, v255 in t37.items do
			table.insert(t38, catalog_sort_data.CatalogSortCardItemFooter.jsonDecode(v255))
		end

		v252.items = t38
	end

	return v252
end

t33.descriptor = {
	name = "ArrayOfItemFooterProp_ArrayMap_LiteralItems",
	fullName = "roblox.apppageplatform.shared.v1beta1.LiteralItems"
}
t1.ArrayOfItemFooterProp_ArrayMap_LiteralItems = t33
typeRegistry.default:register(t1.ArrayOfItemFooterProp_ArrayMap_LiteralItems)

local t39 = {}

t39.__index = t39

function t39.new(t40: {[any]: any}?) -- line: 1662
	-- upvalues: t39 (copy)
	return (setmetatable({
		thumbnail_aspect_ratio = if t40 ~= nil and t40.thumbnail_aspect_ratio ~= nil then t40.thumbnail_aspect_ratio else nil,
		background_layers = if t40 ~= nil and t40.background_layers ~= nil then t40.background_layers else nil
	}, t39))
end
function t39.encode(p22) -- line: 1671
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n15 = 0

	if p22.thumbnail_aspect_ratio ~= nil then
		local v260 = p22.thumbnail_aspect_ratio:encode()
		local v261, v262 = proto.writeTag(buf, n15, 1, proto.wireTypes.lengthDelimited)

		buf, n15 = proto.writeBuffer(v261, v262, v260, buffer.len(v260))
	end

	if p22.background_layers ~= nil then
		local v263 = p22.background_layers:encode()
		local v264, v265 = proto.writeTag(buf, n15, 2, proto.wireTypes.lengthDelimited)

		buf, n15 = proto.writeBuffer(v264, v265, v263, buffer.len(v263))
	end

	local buf9 = buffer.create(n15)

	buffer.copy(buf9, 0, buf, 0, n15)

	return buf9
end
function t39.decode(p23: buffer) -- line: 1692
	-- upvalues: t39 (copy), proto (copy), prop_types (copy), background_layer (copy)
	local v268 = t39.new()
	local n16 = 0

	while n16 < buffer.len(p23) do
		local v270, v271

		v270, v271, n16 = proto.readTag(p23, n16)

		if v271 == proto.wireTypes.varint then
			local v272

			v272, n16 = proto.readVarInt(p23, n16)
		elseif v271 == proto.wireTypes.lengthDelimited then
			if v270 == 1 then
				local v273

				v273, n16 = proto.readBuffer(p23, n16)
				v268.thumbnail_aspect_ratio = prop_types.StringProp.decode(v273)
			elseif v270 == 2 then
				local v274

				v274, n16 = proto.readBuffer(p23, n16)
				v268.background_layers = background_layer.ArrayOfBackgroundLayerProp.decode(v274)
			else
				local v275, v276 = proto.readVarInt(p23, n16)

				n16 = v276 + v275
			end
		elseif v271 == proto.wireTypes.i32 then
			local v277

			v277, n16 = proto.readFixed32(p23, n16)
		elseif v271 == proto.wireTypes.i64 then
			local v278

			v278, n16 = proto.readFixed64(p23, n16)
		else
			error("Unsupported wire type: " .. v271)
		end
	end

	return v268
end
function t39.jsonEncode(p24) -- line: 1742
	local t41 = {}

	if p24.thumbnail_aspect_ratio ~= nil then
		t41.thumbnailAspectRatio = p24.thumbnail_aspect_ratio:jsonEncode()
	end

	if p24.background_layers ~= nil then
		t41.backgroundLayers = p24.background_layers:jsonEncode()
	end

	return t41
end
function t39.jsonDecode(t42: {[any]: any}) -- line: 1756
	-- upvalues: t39 (copy), prop_types (copy), background_layer (copy)
	local v282 = t39.new()

	if t42.thumbnail_aspect_ratio ~= nil then
		v282.thumbnail_aspect_ratio = prop_types.StringProp.jsonDecode(t42.thumbnail_aspect_ratio)
	end

	if t42.thumbnailAspectRatio ~= nil then
		v282.thumbnail_aspect_ratio = prop_types.StringProp.jsonDecode(t42.thumbnailAspectRatio)
	end

	if t42.background_layers ~= nil then
		v282.background_layers = background_layer.ArrayOfBackgroundLayerProp.jsonDecode(t42.background_layers)
	end

	if t42.backgroundLayers ~= nil then
		v282.background_layers = background_layer.ArrayOfBackgroundLayerProp.jsonDecode(t42.backgroundLayers)
	end

	return v282
end

t39.descriptor = {
	name = "CardStyle",
	fullName = "roblox.apppageplatform.shared.v1beta1.CardStyle"
}
t1.CardStyle = t39
typeRegistry.default:register(t1.CardStyle)

local t43 = {}

t43.__index = t43

function t43.new(t44: {[any]: any}?) -- line: 1800
	-- upvalues: t43 (copy)
	return (setmetatable({
		kind = if t44 ~= nil and t44.kind ~= nil then t44.kind else nil
	}, t43))
end
function t43.encode(p25) -- line: 1806
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n17 = 0

	if p25.kind ~= nil then
		if p25.kind.type == "literal" then
			local v287 = p25.kind.value:encode()
			local v288, v289 = proto.writeTag(buf, n17, 1, proto.wireTypes.lengthDelimited)

			buf, n17 = proto.writeBuffer(v288, v289, v287, buffer.len(v287))
		elseif p25.kind.type == "binding_path" then
			local v290, v291 = proto.writeTag(buf, n17, 2, proto.wireTypes.lengthDelimited)

			buf, n17 = proto.writeString(v290, v291, p25.kind.value)
		elseif p25.kind.type == "conditional" then
			local v292 = p25.kind.value:encode()
			local v293, v294 = proto.writeTag(buf, n17, 3, proto.wireTypes.lengthDelimited)

			buf, n17 = proto.writeBuffer(v293, v294, v292, buffer.len(v292))
		end
	end

	local buf10 = buffer.create(n17)

	buffer.copy(buf10, 0, buf, 0, n17)

	return buf10
end
function t43.decode(p26: buffer) -- line: 1830
	-- upvalues: t43 (copy), proto (copy), t1 (copy)
	local v297 = t43.new()
	local n18 = 0

	while n18 < buffer.len(p26) do
		local v299, v300

		v299, v300, n18 = proto.readTag(p26, n18)

		if v300 == proto.wireTypes.varint then
			local v301

			v301, n18 = proto.readVarInt(p26, n18)
		elseif v300 == proto.wireTypes.lengthDelimited then
			if v299 == 1 then
				local v302

				v302, n18 = proto.readBuffer(p26, n18)
				v297.kind = {
					type = "literal",
					value = t1.CardStyle.decode(v302)
				}
			elseif v299 == 2 then
				local v303

				v303, n18 = proto.readBuffer(p26, n18)
				v297.kind = {
					type = "binding_path",
					value = buffer.tostring(v303)
				}
			elseif v299 == 3 then
				local v304

				v304, n18 = proto.readBuffer(p26, n18)
				v297.kind = {
					type = "conditional",
					value = t1.CardStyleProp_ConditionalOptions.decode(v304)
				}
			else
				local v305, v306 = proto.readVarInt(p26, n18)

				n18 = v306 + v305
			end
		elseif v300 == proto.wireTypes.i32 then
			local v307

			v307, n18 = proto.readFixed32(p26, n18)
		elseif v300 == proto.wireTypes.i64 then
			local v308

			v308, n18 = proto.readFixed64(p26, n18)
		else
			error("Unsupported wire type: " .. v300)
		end
	end

	return v297
end
function t43.jsonEncode(p27) -- line: 1884
	local t45 = {}

	if p27.kind ~= nil then
		if p27.kind.type == "literal" then
			t45.literal = p27.kind.value:jsonEncode()

			return t45
		end

		if p27.kind.type == "binding_path" then
			t45.bindingPath = p27.kind.value

			return t45
		end

		if p27.kind.type == "conditional" then
			t45.conditional = p27.kind.value:jsonEncode()
		end
	end

	return t45
end
function t43.jsonDecode(t46: {[any]: any}) -- line: 1900
	-- upvalues: t43 (copy), t1 (copy)
	local v312 = t43.new()

	if t46.literal ~= nil then
		v312.kind = {
			type = "literal",
			value = t1.CardStyle.jsonDecode(t46.literal)
		}
	end

	if t46.binding_path ~= nil then
		v312.kind = {
			type = "binding_path",
			value = t46.binding_path
		}
	end

	if t46.bindingPath ~= nil then
		v312.kind = {
			type = "binding_path",
			value = t46.bindingPath
		}
	end

	if t46.conditional ~= nil then
		v312.kind = {
			type = "conditional",
			value = t1.CardStyleProp_ConditionalOptions.jsonDecode(t46.conditional)
		}
	end

	return v312
end

t43.descriptor = {
	name = "CardStyleProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.CardStyleProp"
}
t1.CardStyleProp = t43
typeRegistry.default:register(t1.CardStyleProp)

local t47 = {}

t47.__index = t47

function t47.new(t48: {[any]: any}?) -- line: 1939
	-- upvalues: t47 (copy)
	return (setmetatable({
		condition = if t48 ~= nil and t48.condition ~= nil then t48.condition else nil,
		kind = if t48 ~= nil and t48.kind ~= nil then t48.kind else nil
	}, t47))
end
function t47.encode(p28) -- line: 1948
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n19 = 0

	if p28.condition ~= nil then
		local v317 = p28.condition:encode()
		local v318, v319 = proto.writeTag(buf, n19, 1, proto.wireTypes.lengthDelimited)

		buf, n19 = proto.writeBuffer(v318, v319, v317, buffer.len(v317))
	end

	if p28.kind ~= nil then
		if p28.kind.type == "literal" then
			local v320 = p28.kind.value:encode()
			local v321, v322 = proto.writeTag(buf, n19, 2, proto.wireTypes.lengthDelimited)

			buf, n19 = proto.writeBuffer(v321, v322, v320, buffer.len(v320))
		elseif p28.kind.type == "binding_path" then
			local v323, v324 = proto.writeTag(buf, n19, 3, proto.wireTypes.lengthDelimited)

			buf, n19 = proto.writeString(v323, v324, p28.kind.value)
		end
	end

	local buf11 = buffer.create(n19)

	buffer.copy(buf11, 0, buf, 0, n19)

	return buf11
end
function t47.decode(p29: buffer) -- line: 1974
	-- upvalues: t47 (copy), proto (copy), prop_condition (copy), t1 (copy)
	local v327 = t47.new()
	local n20 = 0

	while n20 < buffer.len(p29) do
		local v329, v330

		v329, v330, n20 = proto.readTag(p29, n20)

		if v330 == proto.wireTypes.varint then
			local v331

			v331, n20 = proto.readVarInt(p29, n20)
		elseif v330 == proto.wireTypes.lengthDelimited then
			if v329 == 1 then
				local v332

				v332, n20 = proto.readBuffer(p29, n20)
				v327.condition = prop_condition.PropCondition.decode(v332)
			elseif v329 == 2 then
				local v333

				v333, n20 = proto.readBuffer(p29, n20)
				v327.kind = {
					type = "literal",
					value = t1.CardStyle.decode(v333)
				}
			elseif v329 == 3 then
				local v334

				v334, n20 = proto.readBuffer(p29, n20)
				v327.kind = {
					type = "binding_path",
					value = buffer.tostring(v334)
				}
			else
				local v335, v336 = proto.readVarInt(p29, n20)

				n20 = v336 + v335
			end
		elseif v330 == proto.wireTypes.i32 then
			local v337

			v337, n20 = proto.readFixed32(p29, n20)
		elseif v330 == proto.wireTypes.i64 then
			local v338

			v338, n20 = proto.readFixed64(p29, n20)
		else
			error("Unsupported wire type: " .. v330)
		end
	end

	return v327
end
function t47.jsonEncode(p30) -- line: 2027
	local t49 = {}

	if p30.condition ~= nil then
		t49.condition = p30.condition:jsonEncode()
	end

	if p30.kind ~= nil then
		if p30.kind.type == "literal" then
			t49.literal = p30.kind.value:jsonEncode()

			return t49
		end

		if p30.kind.type == "binding_path" then
			t49.bindingPath = p30.kind.value
		end
	end

	return t49
end
function t47.jsonDecode(t50: {[any]: any}) -- line: 2045
	-- upvalues: t47 (copy), prop_condition (copy), t1 (copy)
	local v342 = t47.new()

	if t50.condition ~= nil then
		v342.condition = prop_condition.PropCondition.jsonDecode(t50.condition)
	end

	if t50.literal ~= nil then
		v342.kind = {
			type = "literal",
			value = t1.CardStyle.jsonDecode(t50.literal)
		}
	end

	if t50.binding_path ~= nil then
		v342.kind = {
			type = "binding_path",
			value = t50.binding_path
		}
	end

	if t50.bindingPath ~= nil then
		v342.kind = {
			type = "binding_path",
			value = t50.bindingPath
		}
	end

	return v342
end

t47.descriptor = {
	name = "CardStyleProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}
t1.CardStyleProp_ConditionalOption = t47
typeRegistry.default:register(t1.CardStyleProp_ConditionalOption)

local t51 = {}

t51.__index = t51

function t51.new(t52: {[any]: any}?) -- line: 2082
	-- upvalues: t51 (copy)
	return (setmetatable({
		options = if t52 ~= nil and t52.options ~= nil then t52.options else {}
	}, t51))
end
function t51.encode(p31) -- line: 2090
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n21 = 0

	if p31.options ~= nil and #p31.options > 0 then
		for _, v348 in p31.options do
			local v349 = v348:encode()
			local v350, v351 = proto.writeTag(buf, n21, 1, proto.wireTypes.lengthDelimited)

			buf, n21 = proto.writeBuffer(v350, v351, v349, buffer.len(v349))
		end
	end

	local buf12 = buffer.create(n21)

	buffer.copy(buf12, 0, buf, 0, n21)

	return buf12
end
function t51.decode(p32: buffer) -- line: 2107
	-- upvalues: t51 (copy), proto (copy), t1 (copy)
	local v354 = t51.new()
	local n22 = 0

	while n22 < buffer.len(p32) do
		local v356, v357

		v356, v357, n22 = proto.readTag(p32, n22)

		if v357 == proto.wireTypes.varint then
			local v358

			v358, n22 = proto.readVarInt(p32, n22)
		elseif v357 == proto.wireTypes.lengthDelimited then
			if v356 == 1 then
				local v359

				v359, n22 = proto.readBuffer(p32, n22)
				table.insert(v354.options, t1.CardStyleProp_ConditionalOption.decode(v359))
			else
				local v360, v361 = proto.readVarInt(p32, n22)

				n22 = v361 + v360
			end
		elseif v357 == proto.wireTypes.i32 then
			local v362

			v362, n22 = proto.readFixed32(p32, n22)
		elseif v357 == proto.wireTypes.i64 then
			local v363

			v363, n22 = proto.readFixed64(p32, n22)
		else
			error("Unsupported wire type: " .. v357)
		end
	end

	return v354
end
function t51.jsonEncode(p33) -- line: 2150
	local t53 = {}

	if p33.options ~= nil and #p33.options > 0 then
		local t54 = {}

		for _, v368 in p33.options do
			table.insert(t54, v368:jsonEncode())
		end

		t53.options = t54
	end

	return t53
end
function t51.jsonDecode(t55: {[any]: any}) -- line: 2164
	-- upvalues: t51 (copy), t1 (copy)
	local v370 = t51.new()

	if t55.options ~= nil then
		local t56 = {}

		for _, v373 in t55.options do
			table.insert(t56, t1.CardStyleProp_ConditionalOption.jsonDecode(v373))
		end

		v370.options = t56
	end

	return v370
end

t51.descriptor = {
	name = "CardStyleProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}
t1.CardStyleProp_ConditionalOptions = t51
typeRegistry.default:register(t1.CardStyleProp_ConditionalOptions)

local t57 = {}

t57.__index = t57

function t57.new(t58: {[any]: any}?) -- line: 2195
	-- upvalues: t57 (copy)
	return (setmetatable({
		id = if t58 ~= nil and t58.id ~= nil then t58.id else nil,
		type = if t58 ~= nil and t58.type ~= nil then t58.type else nil
	}, t57))
end
function t57.encode(p34) -- line: 2202
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n23 = 0

	if p34.id ~= nil then
		local v378 = p34.id:encode()
		local v379, v380 = proto.writeTag(buf, n23, 1, proto.wireTypes.lengthDelimited)

		buf, n23 = proto.writeBuffer(v379, v380, v378, buffer.len(v378))
	end

	if p34.type ~= nil then
		local v381 = p34.type:encode()
		local v382, v383 = proto.writeTag(buf, n23, 2, proto.wireTypes.lengthDelimited)

		buf, n23 = proto.writeBuffer(v382, v383, v381, buffer.len(v381))
	end

	local buf13 = buffer.create(n23)

	buffer.copy(buf13, 0, buf, 0, n23)

	return buf13
end
function t57.decode(p35: buffer) -- line: 2223
	-- upvalues: t57 (copy), proto (copy), prop_types (copy)
	local v386 = t57.new()
	local n24 = 0

	while n24 < buffer.len(p35) do
		local v388, v389

		v388, v389, n24 = proto.readTag(p35, n24)

		if v389 == proto.wireTypes.varint then
			local v390

			v390, n24 = proto.readVarInt(p35, n24)
		elseif v389 == proto.wireTypes.lengthDelimited then
			if v388 == 1 then
				local v391

				v391, n24 = proto.readBuffer(p35, n24)
				v386.id = prop_types.StringProp.decode(v391)
			elseif v388 == 2 then
				local v392

				v392, n24 = proto.readBuffer(p35, n24)
				v386.type = prop_types.StringProp.decode(v392)
			else
				local v393, v394 = proto.readVarInt(p35, n24)

				n24 = v394 + v393
			end
		elseif v389 == proto.wireTypes.i32 then
			local v395

			v395, n24 = proto.readFixed32(p35, n24)
		elseif v389 == proto.wireTypes.i64 then
			local v396

			v396, n24 = proto.readFixed64(p35, n24)
		else
			error("Unsupported wire type: " .. v389)
		end
	end

	return v386
end
function t57.jsonEncode(p36) -- line: 2271
	local t59 = {}

	if p36.id ~= nil then
		t59.id = p36.id:jsonEncode()
	end

	if p36.type ~= nil then
		t59.type = p36.type:jsonEncode()
	end

	return t59
end
function t57.jsonDecode(t60: {[any]: any}) -- line: 2285
	-- upvalues: t57 (copy), prop_types (copy)
	local v400 = t57.new()

	if t60.id ~= nil then
		v400.id = prop_types.StringProp.jsonDecode(t60.id)
	end

	if t60.type ~= nil then
		v400.type = prop_types.StringProp.jsonDecode(t60.type)
	end

	return v400
end

t57.descriptor = {
	name = "CatalogSortContent",
	fullName = "roblox.apppageplatform.shared.v1beta1.CatalogSortContent"
}
t1.CatalogSortContent = t57
typeRegistry.default:register(t1.CatalogSortContent)

local t61 = {}

t61.__index = t61

function t61.new(t62: {[any]: any}?) -- line: 2313
	-- upvalues: t61 (copy)
	return (setmetatable({
		kind = if t62 ~= nil and t62.kind ~= nil then t62.kind else nil
	}, t61))
end
function t61.encode(p37) -- line: 2321
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n25 = 0

	if p37.kind ~= nil then
		if p37.kind.type == "literal" then
			local v405 = p37.kind.value:encode()
			local v406, v407 = proto.writeTag(buf, n25, 1, proto.wireTypes.lengthDelimited)

			buf, n25 = proto.writeBuffer(v406, v407, v405, buffer.len(v405))
		elseif p37.kind.type == "binding_path" then
			local v408, v409 = proto.writeTag(buf, n25, 2, proto.wireTypes.lengthDelimited)

			buf, n25 = proto.writeString(v408, v409, p37.kind.value)
		elseif p37.kind.type == "conditional" then
			local v410 = p37.kind.value:encode()
			local v411, v412 = proto.writeTag(buf, n25, 3, proto.wireTypes.lengthDelimited)

			buf, n25 = proto.writeBuffer(v411, v412, v410, buffer.len(v410))
		elseif p37.kind.type == "array_map" then
			local v413 = p37.kind.value:encode()
			local v414, v415 = proto.writeTag(buf, n25, 4, proto.wireTypes.lengthDelimited)

			buf, n25 = proto.writeBuffer(v414, v415, v413, buffer.len(v413))
		end
	end

	local buf14 = buffer.create(n25)

	buffer.copy(buf14, 0, buf, 0, n25)

	return buf14
end
function t61.decode(p38: buffer) -- line: 2349
	-- upvalues: t61 (copy), proto (copy), t1 (copy)
	local v418 = t61.new()
	local n26 = 0

	while n26 < buffer.len(p38) do
		local v420, v421

		v420, v421, n26 = proto.readTag(p38, n26)

		if v421 == proto.wireTypes.varint then
			local v422

			v422, n26 = proto.readVarInt(p38, n26)
		elseif v421 == proto.wireTypes.lengthDelimited then
			if v420 == 1 then
				local v423

				v423, n26 = proto.readBuffer(p38, n26)
				v418.kind = {
					type = "literal",
					value = t1.ArrayOfCatalogSortContentProp_ArrayOfCatalogSortContent.decode(v423)
				}
			elseif v420 == 2 then
				local v424

				v424, n26 = proto.readBuffer(p38, n26)
				v418.kind = {
					type = "binding_path",
					value = buffer.tostring(v424)
				}
			elseif v420 == 3 then
				local v425

				v425, n26 = proto.readBuffer(p38, n26)
				v418.kind = {
					type = "conditional",
					value = t1.ArrayOfCatalogSortContentProp_ConditionalOptions.decode(v425)
				}
			elseif v420 == 4 then
				local v426

				v426, n26 = proto.readBuffer(p38, n26)
				v418.kind = {
					type = "array_map",
					value = t1.ArrayOfCatalogSortContentProp_ArrayMap.decode(v426)
				}
			else
				local v427, v428 = proto.readVarInt(p38, n26)

				n26 = v428 + v427
			end
		elseif v421 == proto.wireTypes.i32 then
			local v429

			v429, n26 = proto.readFixed32(p38, n26)
		elseif v421 == proto.wireTypes.i64 then
			local v430

			v430, n26 = proto.readFixed64(p38, n26)
		else
			error("Unsupported wire type: " .. v421)
		end
	end

	return v418
end
function t61.jsonEncode(p39) -- line: 2414
	local t63 = {}

	if p39.kind ~= nil then
		if p39.kind.type == "literal" then
			t63.literal = p39.kind.value:jsonEncode()

			return t63
		end

		if p39.kind.type == "binding_path" then
			t63.bindingPath = p39.kind.value

			return t63
		end

		if p39.kind.type == "conditional" then
			t63.conditional = p39.kind.value:jsonEncode()

			return t63
		end

		if p39.kind.type == "array_map" then
			t63.arrayMap = p39.kind.value:jsonEncode()
		end
	end

	return t63
end
function t61.jsonDecode(t64: {[any]: any}) -- line: 2432
	-- upvalues: t61 (copy), t1 (copy)
	local v434 = t61.new()

	if t64.literal ~= nil then
		v434.kind = {
			type = "literal",
			value = t1.ArrayOfCatalogSortContentProp_ArrayOfCatalogSortContent.jsonDecode(t64.literal)
		}
	end

	if t64.binding_path ~= nil then
		v434.kind = {
			type = "binding_path",
			value = t64.binding_path
		}
	end

	if t64.bindingPath ~= nil then
		v434.kind = {
			type = "binding_path",
			value = t64.bindingPath
		}
	end

	if t64.conditional ~= nil then
		v434.kind = {
			type = "conditional",
			value = t1.ArrayOfCatalogSortContentProp_ConditionalOptions.jsonDecode(t64.conditional)
		}
	end

	if t64.array_map ~= nil then
		v434.kind = {
			type = "array_map",
			value = t1.ArrayOfCatalogSortContentProp_ArrayMap.jsonDecode(t64.array_map)
		}
	end

	if t64.arrayMap ~= nil then
		v434.kind = {
			type = "array_map",
			value = t1.ArrayOfCatalogSortContentProp_ArrayMap.jsonDecode(t64.arrayMap)
		}
	end

	return v434
end

t61.descriptor = {
	name = "ArrayOfCatalogSortContentProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.ArrayOfCatalogSortContentProp"
}
t1.ArrayOfCatalogSortContentProp = t61
typeRegistry.default:register(t1.ArrayOfCatalogSortContentProp)

local t65 = {}

t65.__index = t65

function t65.new(t66: {[any]: any}?) -- line: 2488
	-- upvalues: t65 (copy)
	return (setmetatable({
		condition = if t66 ~= nil and t66.condition ~= nil then t66.condition else nil,
		kind = if t66 ~= nil and t66.kind ~= nil then t66.kind else nil
	}, t65))
end
function t65.encode(p40) -- line: 2497
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n27 = 0

	if p40.condition ~= nil then
		local v439 = p40.condition:encode()
		local v440, v441 = proto.writeTag(buf, n27, 1, proto.wireTypes.lengthDelimited)

		buf, n27 = proto.writeBuffer(v440, v441, v439, buffer.len(v439))
	end

	if p40.kind ~= nil then
		if p40.kind.type == "literal" then
			local v442 = p40.kind.value:encode()
			local v443, v444 = proto.writeTag(buf, n27, 2, proto.wireTypes.lengthDelimited)

			buf, n27 = proto.writeBuffer(v443, v444, v442, buffer.len(v442))
		elseif p40.kind.type == "binding_path" then
			local v445, v446 = proto.writeTag(buf, n27, 3, proto.wireTypes.lengthDelimited)

			buf, n27 = proto.writeString(v445, v446, p40.kind.value)
		end
	end

	local buf15 = buffer.create(n27)

	buffer.copy(buf15, 0, buf, 0, n27)

	return buf15
end
function t65.decode(p41: buffer) -- line: 2525
	-- upvalues: t65 (copy), proto (copy), prop_condition (copy), t1 (copy)
	local v449 = t65.new()
	local n28 = 0

	while n28 < buffer.len(p41) do
		local v451, v452

		v451, v452, n28 = proto.readTag(p41, n28)

		if v452 == proto.wireTypes.varint then
			local v453

			v453, n28 = proto.readVarInt(p41, n28)
		elseif v452 == proto.wireTypes.lengthDelimited then
			if v451 == 1 then
				local v454

				v454, n28 = proto.readBuffer(p41, n28)
				v449.condition = prop_condition.PropCondition.decode(v454)
			elseif v451 == 2 then
				local v455

				v455, n28 = proto.readBuffer(p41, n28)
				v449.kind = {
					type = "literal",
					value = t1.ArrayOfCatalogSortContentProp_ArrayOfCatalogSortContent.decode(v455)
				}
			elseif v451 == 3 then
				local v456

				v456, n28 = proto.readBuffer(p41, n28)
				v449.kind = {
					type = "binding_path",
					value = buffer.tostring(v456)
				}
			else
				local v457, v458 = proto.readVarInt(p41, n28)

				n28 = v458 + v457
			end
		elseif v452 == proto.wireTypes.i32 then
			local v459

			v459, n28 = proto.readFixed32(p41, n28)
		elseif v452 == proto.wireTypes.i64 then
			local v460

			v460, n28 = proto.readFixed64(p41, n28)
		else
			error("Unsupported wire type: " .. v452)
		end
	end

	return v449
end
function t65.jsonEncode(p42) -- line: 2583
	local t67 = {}

	if p42.condition ~= nil then
		t67.condition = p42.condition:jsonEncode()
	end

	if p42.kind ~= nil then
		if p42.kind.type == "literal" then
			t67.literal = p42.kind.value:jsonEncode()

			return t67
		end

		if p42.kind.type == "binding_path" then
			t67.bindingPath = p42.kind.value
		end
	end

	return t67
end
function t65.jsonDecode(t68: {[any]: any}) -- line: 2603
	-- upvalues: t65 (copy), prop_condition (copy), t1 (copy)
	local v464 = t65.new()

	if t68.condition ~= nil then
		v464.condition = prop_condition.PropCondition.jsonDecode(t68.condition)
	end

	if t68.literal ~= nil then
		v464.kind = {
			type = "literal",
			value = t1.ArrayOfCatalogSortContentProp_ArrayOfCatalogSortContent.jsonDecode(t68.literal)
		}
	end

	if t68.binding_path ~= nil then
		v464.kind = {
			type = "binding_path",
			value = t68.binding_path
		}
	end

	if t68.bindingPath ~= nil then
		v464.kind = {
			type = "binding_path",
			value = t68.bindingPath
		}
	end

	return v464
end

t65.descriptor = {
	name = "ArrayOfCatalogSortContentProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}
t1.ArrayOfCatalogSortContentProp_ConditionalOption = t65
typeRegistry.default:register(t1.ArrayOfCatalogSortContentProp_ConditionalOption)

local t69 = {}

t69.__index = t69

function t69.new(t70: {[any]: any}?) -- line: 2647
	-- upvalues: t69 (copy)
	return (setmetatable({
		options = if t70 ~= nil and t70.options ~= nil then t70.options else {}
	}, t69))
end
function t69.encode(p43) -- line: 2658
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n29 = 0

	if p43.options ~= nil and #p43.options > 0 then
		for _, v470 in p43.options do
			local v471 = v470:encode()
			local v472, v473 = proto.writeTag(buf, n29, 1, proto.wireTypes.lengthDelimited)

			buf, n29 = proto.writeBuffer(v472, v473, v471, buffer.len(v471))
		end
	end

	local buf16 = buffer.create(n29)

	buffer.copy(buf16, 0, buf, 0, n29)

	return buf16
end
function t69.decode(p44: buffer) -- line: 2677
	-- upvalues: t69 (copy), proto (copy), t1 (copy)
	local v476 = t69.new()
	local n30 = 0

	while n30 < buffer.len(p44) do
		local v478, v479

		v478, v479, n30 = proto.readTag(p44, n30)

		if v479 == proto.wireTypes.varint then
			local v480

			v480, n30 = proto.readVarInt(p44, n30)
		elseif v479 == proto.wireTypes.lengthDelimited then
			if v478 == 1 then
				local v481

				v481, n30 = proto.readBuffer(p44, n30)
				table.insert(v476.options, t1.ArrayOfCatalogSortContentProp_ConditionalOption.decode(v481))
			else
				local v482, v483 = proto.readVarInt(p44, n30)

				n30 = v483 + v482
			end
		elseif v479 == proto.wireTypes.i32 then
			local v484

			v484, n30 = proto.readFixed32(p44, n30)
		elseif v479 == proto.wireTypes.i64 then
			local v485

			v485, n30 = proto.readFixed64(p44, n30)
		else
			error("Unsupported wire type: " .. v479)
		end
	end

	return v476
end
function t69.jsonEncode(p45) -- line: 2722
	local t71 = {}

	if p45.options ~= nil and #p45.options > 0 then
		local t72 = {}

		for _, v490 in p45.options do
			table.insert(t72, v490:jsonEncode())
		end

		t71.options = t72
	end

	return t71
end
function t69.jsonDecode(t73: {[any]: any}) -- line: 2738
	-- upvalues: t69 (copy), t1 (copy)
	local v492 = t69.new()

	if t73.options ~= nil then
		local t74 = {}

		for _, v495 in t73.options do
			table.insert(t74, t1.ArrayOfCatalogSortContentProp_ConditionalOption.jsonDecode(v495))
		end

		v492.options = t74
	end

	return v492
end

t69.descriptor = {
	name = "ArrayOfCatalogSortContentProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}
t1.ArrayOfCatalogSortContentProp_ConditionalOptions = t69
typeRegistry.default:register(t1.ArrayOfCatalogSortContentProp_ConditionalOptions)

local t75 = {}

t75.__index = t75

function t75.new(t76: {[any]: any}?) -- line: 2771
	-- upvalues: t75 (copy)
	return (setmetatable({
		array = if t76 ~= nil and t76.array ~= nil then t76.array else {}
	}, t75))
end
function t75.encode(p46) -- line: 2782
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n31 = 0

	if p46.array ~= nil and #p46.array > 0 then
		for _, v501 in p46.array do
			local v502 = v501:encode()
			local v503, v504 = proto.writeTag(buf, n31, 1, proto.wireTypes.lengthDelimited)

			buf, n31 = proto.writeBuffer(v503, v504, v502, buffer.len(v502))
		end
	end

	local buf17 = buffer.create(n31)

	buffer.copy(buf17, 0, buf, 0, n31)

	return buf17
end
function t75.decode(p47: buffer) -- line: 2801
	-- upvalues: t75 (copy), proto (copy), t1 (copy)
	local v507 = t75.new()
	local n32 = 0

	while n32 < buffer.len(p47) do
		local v509, v510

		v509, v510, n32 = proto.readTag(p47, n32)

		if v510 == proto.wireTypes.varint then
			local v511

			v511, n32 = proto.readVarInt(p47, n32)
		elseif v510 == proto.wireTypes.lengthDelimited then
			if v509 == 1 then
				local v512

				v512, n32 = proto.readBuffer(p47, n32)
				table.insert(v507.array, t1.CatalogSortContent.decode(v512))
			else
				local v513, v514 = proto.readVarInt(p47, n32)

				n32 = v514 + v513
			end
		elseif v510 == proto.wireTypes.i32 then
			local v515

			v515, n32 = proto.readFixed32(p47, n32)
		elseif v510 == proto.wireTypes.i64 then
			local v516

			v516, n32 = proto.readFixed64(p47, n32)
		else
			error("Unsupported wire type: " .. v510)
		end
	end

	return v507
end
function t75.jsonEncode(p48) -- line: 2846
	local t77 = {}

	if p48.array ~= nil and #p48.array > 0 then
		local t78 = {}

		for _, v521 in p48.array do
			table.insert(t78, v521:jsonEncode())
		end

		t77.array = t78
	end

	return t77
end
function t75.jsonDecode(t79: {[any]: any}) -- line: 2862
	-- upvalues: t75 (copy), t1 (copy)
	local v523 = t75.new()

	if t79.array ~= nil then
		local t80 = {}

		for _, v526 in t79.array do
			table.insert(t80, t1.CatalogSortContent.jsonDecode(v526))
		end

		v523.array = t80
	end

	return v523
end

t75.descriptor = {
	name = "ArrayOfCatalogSortContentProp_ArrayOfCatalogSortContent",
	fullName = "roblox.apppageplatform.shared.v1beta1.ArrayOfCatalogSortContent"
}
t1.ArrayOfCatalogSortContentProp_ArrayOfCatalogSortContent = t75
typeRegistry.default:register(t1.ArrayOfCatalogSortContentProp_ArrayOfCatalogSortContent)

local t81 = {}

t81.__index = t81

function t81.new(t82: {[any]: any}?) -- line: 2894
	-- upvalues: t81 (copy)
	return (setmetatable({
		kind = if t82 ~= nil and t82.kind ~= nil then t82.kind else nil,
		item_hydration_specs = if t82 ~= nil and t82.item_hydration_specs ~= nil then t82.item_hydration_specs else {},
		field_map = if t82 ~= nil and t82.field_map ~= nil then t82.field_map else nil
	}, t81))
end
function t81.encode(p49) -- line: 2906
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n33 = 0

	if p49.kind ~= nil then
		if p49.kind.type == "binding_path" then
			local v531, v532 = proto.writeTag(buf, n33, 1, proto.wireTypes.lengthDelimited)

			buf, n33 = proto.writeString(v531, v532, p49.kind.value)
		elseif p49.kind.type == "literal" then
			local v533 = p49.kind.value:encode()
			local v534, v535 = proto.writeTag(buf, n33, 2, proto.wireTypes.lengthDelimited)

			buf, n33 = proto.writeBuffer(v534, v535, v533, buffer.len(v533))
		end
	end

	if p49.item_hydration_specs ~= nil and #p49.item_hydration_specs > 0 then
		for _, v537 in p49.item_hydration_specs do
			local v538 = v537:encode()
			local v539, v540 = proto.writeTag(buf, n33, 3, proto.wireTypes.lengthDelimited)

			buf, n33 = proto.writeBuffer(v539, v540, v538, buffer.len(v538))
		end
	end

	if p49.field_map ~= nil then
		local v541 = p49.field_map:encode()
		local v542, v543 = proto.writeTag(buf, n33, 4, proto.wireTypes.lengthDelimited)

		buf, n33 = proto.writeBuffer(v542, v543, v541, buffer.len(v541))
	end

	local buf18 = buffer.create(n33)

	buffer.copy(buf18, 0, buf, 0, n33)

	return buf18
end
function t81.decode(p50: buffer) -- line: 2940
	-- upvalues: t81 (copy), proto (copy), t1 (copy), hydration_data_spec (copy)
	local v546 = t81.new()
	local n34 = 0

	while n34 < buffer.len(p50) do
		local v548, v549

		v548, v549, n34 = proto.readTag(p50, n34)

		if v549 == proto.wireTypes.varint then
			local v550

			v550, n34 = proto.readVarInt(p50, n34)
		elseif v549 == proto.wireTypes.lengthDelimited then
			if v548 == 1 then
				local v551

				v551, n34 = proto.readBuffer(p50, n34)
				v546.kind = {
					type = "binding_path",
					value = buffer.tostring(v551)
				}
			elseif v548 == 2 then
				local v552

				v552, n34 = proto.readBuffer(p50, n34)
				v546.kind = {
					type = "literal",
					value = t1.ArrayOfCatalogSortContentProp_ArrayMap_LiteralItems.decode(v552)
				}
			elseif v548 == 3 then
				local v553

				v553, n34 = proto.readBuffer(p50, n34)
				table.insert(v546.item_hydration_specs, hydration_data_spec.HydrationDataSpec.decode(v553))
			elseif v548 == 4 then
				local v554

				v554, n34 = proto.readBuffer(p50, n34)
				v546.field_map = t1.CatalogSortContent.decode(v554)
			else
				local v555, v556 = proto.readVarInt(p50, n34)

				n34 = v556 + v555
			end
		elseif v549 == proto.wireTypes.i32 then
			local v557

			v557, n34 = proto.readFixed32(p50, n34)
		elseif v549 == proto.wireTypes.i64 then
			local v558

			v558, n34 = proto.readFixed64(p50, n34)
		else
			error("Unsupported wire type: " .. v549)
		end
	end

	return v546
end
function t81.jsonEncode(p51) -- line: 3004
	local t83 = {}

	if p51.kind ~= nil then
		if p51.kind.type == "binding_path" then
			t83.bindingPath = p51.kind.value
		elseif p51.kind.type == "literal" then
			t83.literal = p51.kind.value:jsonEncode()
		end
	end

	if p51.item_hydration_specs ~= nil and #p51.item_hydration_specs > 0 then
		local t84 = {}

		for _, v563 in p51.item_hydration_specs do
			table.insert(t84, v563:jsonEncode())
		end

		t83.itemHydrationSpecs = t84
	end

	if p51.field_map ~= nil then
		t83.fieldMap = p51.field_map:jsonEncode()
	end

	return t83
end
function t81.jsonDecode(t85: {[any]: any}) -- line: 3030
	-- upvalues: t81 (copy), t1 (copy), hydration_data_spec (copy)
	local v565 = t81.new()

	if t85.binding_path ~= nil then
		v565.kind = {
			type = "binding_path",
			value = t85.binding_path
		}
	end

	if t85.bindingPath ~= nil then
		v565.kind = {
			type = "binding_path",
			value = t85.bindingPath
		}
	end

	if t85.literal ~= nil then
		v565.kind = {
			type = "literal",
			value = t1.ArrayOfCatalogSortContentProp_ArrayMap_LiteralItems.jsonDecode(t85.literal)
		}
	end

	if t85.item_hydration_specs ~= nil then
		local t86 = {}

		for _, v568 in t85.item_hydration_specs do
			table.insert(t86, hydration_data_spec.HydrationDataSpec.jsonDecode(v568))
		end

		v565.item_hydration_specs = t86
	end

	if t85.itemHydrationSpecs ~= nil then
		local t87 = {}

		for _, v571 in t85.itemHydrationSpecs do
			table.insert(t87, hydration_data_spec.HydrationDataSpec.jsonDecode(v571))
		end

		v565.item_hydration_specs = t87
	end

	if t85.field_map ~= nil then
		v565.field_map = t1.CatalogSortContent.jsonDecode(t85.field_map)
	end

	if t85.fieldMap ~= nil then
		v565.field_map = t1.CatalogSortContent.jsonDecode(t85.fieldMap)
	end

	return v565
end

t81.descriptor = {
	name = "ArrayOfCatalogSortContentProp_ArrayMap",
	fullName = "roblox.apppageplatform.shared.v1beta1.ArrayMap"
}
t1.ArrayOfCatalogSortContentProp_ArrayMap = t81
typeRegistry.default:register(t1.ArrayOfCatalogSortContentProp_ArrayMap)

local t88 = {}

t88.__index = t88

function t88.new(t89: {[any]: any}?) -- line: 3100
	-- upvalues: t88 (copy)
	return (setmetatable({
		items = if t89 ~= nil and t89.items ~= nil then t89.items else {}
	}, t88))
end
function t88.encode(p52) -- line: 3111
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n35 = 0

	if p52.items ~= nil and #p52.items > 0 then
		for _, v577 in p52.items do
			local v578 = v577:encode()
			local v579, v580 = proto.writeTag(buf, n35, 1, proto.wireTypes.lengthDelimited)

			buf, n35 = proto.writeBuffer(v579, v580, v578, buffer.len(v578))
		end
	end

	local buf19 = buffer.create(n35)

	buffer.copy(buf19, 0, buf, 0, n35)

	return buf19
end
function t88.decode(p53: buffer) -- line: 3130
	-- upvalues: t88 (copy), proto (copy), catalog_sort_data (copy)
	local v583 = t88.new()
	local n36 = 0

	while n36 < buffer.len(p53) do
		local v585, v586

		v585, v586, n36 = proto.readTag(p53, n36)

		if v586 == proto.wireTypes.varint then
			local v587

			v587, n36 = proto.readVarInt(p53, n36)
		elseif v586 == proto.wireTypes.lengthDelimited then
			if v585 == 1 then
				local v588

				v588, n36 = proto.readBuffer(p53, n36)
				table.insert(v583.items, catalog_sort_data.CatalogSortContentData.decode(v588))
			else
				local v589, v590 = proto.readVarInt(p53, n36)

				n36 = v590 + v589
			end
		elseif v586 == proto.wireTypes.i32 then
			local v591

			v591, n36 = proto.readFixed32(p53, n36)
		elseif v586 == proto.wireTypes.i64 then
			local v592

			v592, n36 = proto.readFixed64(p53, n36)
		else
			error("Unsupported wire type: " .. v586)
		end
	end

	return v583
end
function t88.jsonEncode(p54) -- line: 3178
	local t90 = {}

	if p54.items ~= nil and #p54.items > 0 then
		local t91 = {}

		for _, v597 in p54.items do
			table.insert(t91, v597:jsonEncode())
		end

		t90.items = t91
	end

	return t90
end
function t88.jsonDecode(t92: {[any]: any}) -- line: 3194
	-- upvalues: t88 (copy), catalog_sort_data (copy)
	local v599 = t88.new()

	if t92.items ~= nil then
		local t93 = {}

		for _, v602 in t92.items do
			table.insert(t93, catalog_sort_data.CatalogSortContentData.jsonDecode(v602))
		end

		v599.items = t93
	end

	return v599
end

t88.descriptor = {
	name = "ArrayOfCatalogSortContentProp_ArrayMap_LiteralItems",
	fullName = "roblox.apppageplatform.shared.v1beta1.LiteralItems"
}
t1.ArrayOfCatalogSortContentProp_ArrayMap_LiteralItems = t88
typeRegistry.default:register(t1.ArrayOfCatalogSortContentProp_ArrayMap_LiteralItems)

local t94 = {}

t94.__index = t94

function t94.new(t95: {[any]: any}?) -- line: 3229
	-- upvalues: t94 (copy)
	return (setmetatable({
		background_layers = if t95 ~= nil and t95.background_layers ~= nil then t95.background_layers else nil
	}, t94))
end
function t94.encode(p55) -- line: 3235
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n37 = 0

	if p55.background_layers ~= nil then
		local v607 = p55.background_layers:encode()
		local v608, v609 = proto.writeTag(buf, n37, 1, proto.wireTypes.lengthDelimited)

		buf, n37 = proto.writeBuffer(v608, v609, v607, buffer.len(v607))
	end

	local buf20 = buffer.create(n37)

	buffer.copy(buf20, 0, buf, 0, n37)

	return buf20
end
function t94.decode(p56: buffer) -- line: 3250
	-- upvalues: t94 (copy), proto (copy), background_layer (copy)
	local v612 = t94.new()
	local n38 = 0

	while n38 < buffer.len(p56) do
		local v614, v615

		v614, v615, n38 = proto.readTag(p56, n38)

		if v615 == proto.wireTypes.varint then
			local v616

			v616, n38 = proto.readVarInt(p56, n38)
		elseif v615 == proto.wireTypes.lengthDelimited then
			if v614 == 1 then
				local v617

				v617, n38 = proto.readBuffer(p56, n38)
				v612.background_layers = background_layer.ArrayOfBackgroundLayerProp.decode(v617)
			else
				local v618, v619 = proto.readVarInt(p56, n38)

				n38 = v619 + v618
			end
		elseif v615 == proto.wireTypes.i32 then
			local v620

			v620, n38 = proto.readFixed32(p56, n38)
		elseif v615 == proto.wireTypes.i64 then
			local v621

			v621, n38 = proto.readFixed64(p56, n38)
		else
			error("Unsupported wire type: " .. v615)
		end
	end

	return v612
end
function t94.jsonEncode(p57) -- line: 3294
	local t96 = {}

	if p57.background_layers ~= nil then
		t96.backgroundLayers = p57.background_layers:jsonEncode()
	end

	return t96
end
function t94.jsonDecode(t97: {[any]: any}) -- line: 3304
	-- upvalues: t94 (copy), background_layer (copy)
	local v625 = t94.new()

	if t97.background_layers ~= nil then
		v625.background_layers = background_layer.ArrayOfBackgroundLayerProp.jsonDecode(t97.background_layers)
	end

	if t97.backgroundLayers ~= nil then
		v625.background_layers = background_layer.ArrayOfBackgroundLayerProp.jsonDecode(t97.backgroundLayers)
	end

	return v625
end

t94.descriptor = {
	name = "WidgetStyle",
	fullName = "roblox.apppageplatform.shared.v1beta1.WidgetStyle"
}
t1.WidgetStyle = t94
typeRegistry.default:register(t1.WidgetStyle)

local t98 = {}

t98.__index = t98

function t98.new(t99: {[any]: any}?) -- line: 3338
	-- upvalues: t98 (copy)
	return (setmetatable({
		kind = if t99 ~= nil and t99.kind ~= nil then t99.kind else nil
	}, t98))
end
function t98.encode(p58) -- line: 3344
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n39 = 0

	if p58.kind ~= nil then
		if p58.kind.type == "literal" then
			local v630 = p58.kind.value:encode()
			local v631, v632 = proto.writeTag(buf, n39, 1, proto.wireTypes.lengthDelimited)

			buf, n39 = proto.writeBuffer(v631, v632, v630, buffer.len(v630))
		elseif p58.kind.type == "binding_path" then
			local v633, v634 = proto.writeTag(buf, n39, 2, proto.wireTypes.lengthDelimited)

			buf, n39 = proto.writeString(v633, v634, p58.kind.value)
		elseif p58.kind.type == "conditional" then
			local v635 = p58.kind.value:encode()
			local v636, v637 = proto.writeTag(buf, n39, 3, proto.wireTypes.lengthDelimited)

			buf, n39 = proto.writeBuffer(v636, v637, v635, buffer.len(v635))
		end
	end

	local buf21 = buffer.create(n39)

	buffer.copy(buf21, 0, buf, 0, n39)

	return buf21
end
function t98.decode(p59: buffer) -- line: 3368
	-- upvalues: t98 (copy), proto (copy), t1 (copy)
	local v640 = t98.new()
	local n40 = 0

	while n40 < buffer.len(p59) do
		local v642, v643

		v642, v643, n40 = proto.readTag(p59, n40)

		if v643 == proto.wireTypes.varint then
			local v644

			v644, n40 = proto.readVarInt(p59, n40)
		elseif v643 == proto.wireTypes.lengthDelimited then
			if v642 == 1 then
				local v645

				v645, n40 = proto.readBuffer(p59, n40)
				v640.kind = {
					type = "literal",
					value = t1.WidgetStyle.decode(v645)
				}
			elseif v642 == 2 then
				local v646

				v646, n40 = proto.readBuffer(p59, n40)
				v640.kind = {
					type = "binding_path",
					value = buffer.tostring(v646)
				}
			elseif v642 == 3 then
				local v647

				v647, n40 = proto.readBuffer(p59, n40)
				v640.kind = {
					type = "conditional",
					value = t1.WidgetStyleProp_ConditionalOptions.decode(v647)
				}
			else
				local v648, v649 = proto.readVarInt(p59, n40)

				n40 = v649 + v648
			end
		elseif v643 == proto.wireTypes.i32 then
			local v650

			v650, n40 = proto.readFixed32(p59, n40)
		elseif v643 == proto.wireTypes.i64 then
			local v651

			v651, n40 = proto.readFixed64(p59, n40)
		else
			error("Unsupported wire type: " .. v643)
		end
	end

	return v640
end
function t98.jsonEncode(p60) -- line: 3422
	local t100 = {}

	if p60.kind ~= nil then
		if p60.kind.type == "literal" then
			t100.literal = p60.kind.value:jsonEncode()

			return t100
		end

		if p60.kind.type == "binding_path" then
			t100.bindingPath = p60.kind.value

			return t100
		end

		if p60.kind.type == "conditional" then
			t100.conditional = p60.kind.value:jsonEncode()
		end
	end

	return t100
end
function t98.jsonDecode(t101: {[any]: any}) -- line: 3438
	-- upvalues: t98 (copy), t1 (copy)
	local v655 = t98.new()

	if t101.literal ~= nil then
		v655.kind = {
			type = "literal",
			value = t1.WidgetStyle.jsonDecode(t101.literal)
		}
	end

	if t101.binding_path ~= nil then
		v655.kind = {
			type = "binding_path",
			value = t101.binding_path
		}
	end

	if t101.bindingPath ~= nil then
		v655.kind = {
			type = "binding_path",
			value = t101.bindingPath
		}
	end

	if t101.conditional ~= nil then
		v655.kind = {
			type = "conditional",
			value = t1.WidgetStyleProp_ConditionalOptions.jsonDecode(t101.conditional)
		}
	end

	return v655
end

t98.descriptor = {
	name = "WidgetStyleProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.WidgetStyleProp"
}
t1.WidgetStyleProp = t98
typeRegistry.default:register(t1.WidgetStyleProp)

local t102 = {}

t102.__index = t102

function t102.new(t103: {[any]: any}?) -- line: 3477
	-- upvalues: t102 (copy)
	return (setmetatable({
		condition = if t103 ~= nil and t103.condition ~= nil then t103.condition else nil,
		kind = if t103 ~= nil and t103.kind ~= nil then t103.kind else nil
	}, t102))
end
function t102.encode(p61) -- line: 3486
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n41 = 0

	if p61.condition ~= nil then
		local v660 = p61.condition:encode()
		local v661, v662 = proto.writeTag(buf, n41, 1, proto.wireTypes.lengthDelimited)

		buf, n41 = proto.writeBuffer(v661, v662, v660, buffer.len(v660))
	end

	if p61.kind ~= nil then
		if p61.kind.type == "literal" then
			local v663 = p61.kind.value:encode()
			local v664, v665 = proto.writeTag(buf, n41, 2, proto.wireTypes.lengthDelimited)

			buf, n41 = proto.writeBuffer(v664, v665, v663, buffer.len(v663))
		elseif p61.kind.type == "binding_path" then
			local v666, v667 = proto.writeTag(buf, n41, 3, proto.wireTypes.lengthDelimited)

			buf, n41 = proto.writeString(v666, v667, p61.kind.value)
		end
	end

	local buf22 = buffer.create(n41)

	buffer.copy(buf22, 0, buf, 0, n41)

	return buf22
end
function t102.decode(p62: buffer) -- line: 3512
	-- upvalues: t102 (copy), proto (copy), prop_condition (copy), t1 (copy)
	local v670 = t102.new()
	local n42 = 0

	while n42 < buffer.len(p62) do
		local v672, v673

		v672, v673, n42 = proto.readTag(p62, n42)

		if v673 == proto.wireTypes.varint then
			local v674

			v674, n42 = proto.readVarInt(p62, n42)
		elseif v673 == proto.wireTypes.lengthDelimited then
			if v672 == 1 then
				local v675

				v675, n42 = proto.readBuffer(p62, n42)
				v670.condition = prop_condition.PropCondition.decode(v675)
			elseif v672 == 2 then
				local v676

				v676, n42 = proto.readBuffer(p62, n42)
				v670.kind = {
					type = "literal",
					value = t1.WidgetStyle.decode(v676)
				}
			elseif v672 == 3 then
				local v677

				v677, n42 = proto.readBuffer(p62, n42)
				v670.kind = {
					type = "binding_path",
					value = buffer.tostring(v677)
				}
			else
				local v678, v679 = proto.readVarInt(p62, n42)

				n42 = v679 + v678
			end
		elseif v673 == proto.wireTypes.i32 then
			local v680

			v680, n42 = proto.readFixed32(p62, n42)
		elseif v673 == proto.wireTypes.i64 then
			local v681

			v681, n42 = proto.readFixed64(p62, n42)
		else
			error("Unsupported wire type: " .. v673)
		end
	end

	return v670
end
function t102.jsonEncode(p63) -- line: 3565
	local t104 = {}

	if p63.condition ~= nil then
		t104.condition = p63.condition:jsonEncode()
	end

	if p63.kind ~= nil then
		if p63.kind.type == "literal" then
			t104.literal = p63.kind.value:jsonEncode()

			return t104
		end

		if p63.kind.type == "binding_path" then
			t104.bindingPath = p63.kind.value
		end
	end

	return t104
end
function t102.jsonDecode(t105: {[any]: any}) -- line: 3583
	-- upvalues: t102 (copy), prop_condition (copy), t1 (copy)
	local v685 = t102.new()

	if t105.condition ~= nil then
		v685.condition = prop_condition.PropCondition.jsonDecode(t105.condition)
	end

	if t105.literal ~= nil then
		v685.kind = {
			type = "literal",
			value = t1.WidgetStyle.jsonDecode(t105.literal)
		}
	end

	if t105.binding_path ~= nil then
		v685.kind = {
			type = "binding_path",
			value = t105.binding_path
		}
	end

	if t105.bindingPath ~= nil then
		v685.kind = {
			type = "binding_path",
			value = t105.bindingPath
		}
	end

	return v685
end

t102.descriptor = {
	name = "WidgetStyleProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}
t1.WidgetStyleProp_ConditionalOption = t102
typeRegistry.default:register(t1.WidgetStyleProp_ConditionalOption)

local t106 = {}

t106.__index = t106

function t106.new(t107: {[any]: any}?) -- line: 3622
	-- upvalues: t106 (copy)
	return (setmetatable({
		options = if t107 ~= nil and t107.options ~= nil then t107.options else {}
	}, t106))
end
function t106.encode(p64) -- line: 3630
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n43 = 0

	if p64.options ~= nil and #p64.options > 0 then
		for _, v691 in p64.options do
			local v692 = v691:encode()
			local v693, v694 = proto.writeTag(buf, n43, 1, proto.wireTypes.lengthDelimited)

			buf, n43 = proto.writeBuffer(v693, v694, v692, buffer.len(v692))
		end
	end

	local buf23 = buffer.create(n43)

	buffer.copy(buf23, 0, buf, 0, n43)

	return buf23
end
function t106.decode(p65: buffer) -- line: 3647
	-- upvalues: t106 (copy), proto (copy), t1 (copy)
	local v697 = t106.new()
	local n44 = 0

	while n44 < buffer.len(p65) do
		local v699, v700

		v699, v700, n44 = proto.readTag(p65, n44)

		if v700 == proto.wireTypes.varint then
			local v701

			v701, n44 = proto.readVarInt(p65, n44)
		elseif v700 == proto.wireTypes.lengthDelimited then
			if v699 == 1 then
				local v702

				v702, n44 = proto.readBuffer(p65, n44)
				table.insert(v697.options, t1.WidgetStyleProp_ConditionalOption.decode(v702))
			else
				local v703, v704 = proto.readVarInt(p65, n44)

				n44 = v704 + v703
			end
		elseif v700 == proto.wireTypes.i32 then
			local v705

			v705, n44 = proto.readFixed32(p65, n44)
		elseif v700 == proto.wireTypes.i64 then
			local v706

			v706, n44 = proto.readFixed64(p65, n44)
		else
			error("Unsupported wire type: " .. v700)
		end
	end

	return v697
end
function t106.jsonEncode(p66) -- line: 3690
	local t108 = {}

	if p66.options ~= nil and #p66.options > 0 then
		local t109 = {}

		for _, v711 in p66.options do
			table.insert(t109, v711:jsonEncode())
		end

		t108.options = t109
	end

	return t108
end
function t106.jsonDecode(t110: {[any]: any}) -- line: 3704
	-- upvalues: t106 (copy), t1 (copy)
	local v713 = t106.new()

	if t110.options ~= nil then
		local t111 = {}

		for _, v716 in t110.options do
			table.insert(t111, t1.WidgetStyleProp_ConditionalOption.jsonDecode(v716))
		end

		v713.options = t111
	end

	return v713
end

t106.descriptor = {
	name = "WidgetStyleProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}
t1.WidgetStyleProp_ConditionalOptions = t106
typeRegistry.default:register(t1.WidgetStyleProp_ConditionalOptions)

return {
	ItemFooter = t1.ItemFooter,
	ArrayOfItemFooterProp = t1.ArrayOfItemFooterProp,
	ArrayOfItemFooterProp_ConditionalOption = t1.ArrayOfItemFooterProp_ConditionalOption,
	ArrayOfItemFooterProp_ConditionalOptions = t1.ArrayOfItemFooterProp_ConditionalOptions,
	ArrayOfItemFooterProp_ArrayOfItemFooter = t1.ArrayOfItemFooterProp_ArrayOfItemFooter,
	ArrayOfItemFooterProp_ArrayMap = t1.ArrayOfItemFooterProp_ArrayMap,
	ArrayOfItemFooterProp_ArrayMap_LiteralItems = t1.ArrayOfItemFooterProp_ArrayMap_LiteralItems,
	CardStyle = t1.CardStyle,
	CardStyleProp = t1.CardStyleProp,
	CardStyleProp_ConditionalOption = t1.CardStyleProp_ConditionalOption,
	CardStyleProp_ConditionalOptions = t1.CardStyleProp_ConditionalOptions,
	CatalogSortContent = t1.CatalogSortContent,
	ArrayOfCatalogSortContentProp = t1.ArrayOfCatalogSortContentProp,
	ArrayOfCatalogSortContentProp_ConditionalOption = t1.ArrayOfCatalogSortContentProp_ConditionalOption,
	ArrayOfCatalogSortContentProp_ConditionalOptions = t1.ArrayOfCatalogSortContentProp_ConditionalOptions,
	ArrayOfCatalogSortContentProp_ArrayOfCatalogSortContent = t1.ArrayOfCatalogSortContentProp_ArrayOfCatalogSortContent,
	ArrayOfCatalogSortContentProp_ArrayMap = t1.ArrayOfCatalogSortContentProp_ArrayMap,
	ArrayOfCatalogSortContentProp_ArrayMap_LiteralItems = t1.ArrayOfCatalogSortContentProp_ArrayMap_LiteralItems,
	WidgetStyle = t1.WidgetStyle,
	WidgetStyleProp = t1.WidgetStyleProp,
	WidgetStyleProp_ConditionalOption = t1.WidgetStyleProp_ConditionalOption,
	WidgetStyleProp_ConditionalOptions = t1.WidgetStyleProp_ConditionalOptions
}
