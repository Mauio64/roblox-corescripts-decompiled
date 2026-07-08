local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local prop_condition = require(script.Parent.prop_condition)
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 197
	-- upvalues: t2 (copy)
	return (setmetatable({
		resource_identifier = if t3 ~= nil and t3.resource_identifier ~= nil then t3.resource_identifier else ""
	}, t2))
end
function t2.encode(p1) -- line: 205
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.resource_identifier ~= nil and p1.resource_identifier ~= "" then
		local v15, v16 = proto.writeTag(buf, n1, 1, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v15, v16, p1.resource_identifier)
	end

	local buf2 = buffer.create(n1)

	buffer.copy(buf2, 0, buf, 0, n1)

	return buf2
end
function t2.decode(p2: buffer) -- line: 219
	-- upvalues: t2 (copy), proto (copy)
	local v19 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v21, v22

		v21, v22, n2 = proto.readTag(p2, n2)

		if v22 == proto.wireTypes.varint then
			local v23

			v23, n2 = proto.readVarInt(p2, n2)
		elseif v22 == proto.wireTypes.lengthDelimited then
			if v21 == 1 then
				local v24

				v24, n2 = proto.readBuffer(p2, n2)
				v19.resource_identifier = buffer.tostring(v24)
			else
				local v25, v26 = proto.readVarInt(p2, n2)

				n2 = v26 + v25
			end
		elseif v22 == proto.wireTypes.i32 then
			local v27

			v27, n2 = proto.readFixed32(p2, n2)
		elseif v22 == proto.wireTypes.i64 then
			local v28

			v28, n2 = proto.readFixed64(p2, n2)
		else
			error("Unsupported wire type: " .. v22)
		end
	end

	return v19
end
function t2.jsonEncode(p3) -- line: 262
	local t4 = {}

	if p3.resource_identifier ~= nil and p3.resource_identifier ~= "" then
		t4.resourceIdentifier = p3.resource_identifier
	end

	return t4
end
function t2.jsonDecode(t5: {[any]: any}) -- line: 272
	-- upvalues: t2 (copy)
	local v32 = t2.new()

	if t5.resource_identifier ~= nil then
		v32.resource_identifier = t5.resource_identifier
	end

	if t5.resourceIdentifier ~= nil then
		v32.resource_identifier = t5.resourceIdentifier
	end

	return v32
end

t2.descriptor = {
	name = "ImageBackground",
	fullName = "roblox.apppageplatform.shared.v1beta1.ImageBackground"
}
t1.ImageBackground = t2
typeRegistry.default:register(t1.ImageBackground)

local t6 = {}

t6.__index = t6

function t6.new(t7: {[any]: any}?) -- line: 300
	-- upvalues: t6 (copy)
	return (setmetatable({
		kind = if t7 ~= nil and t7.kind ~= nil then t7.kind else nil
	}, t6))
end
function t6.encode(p4) -- line: 306
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n3 = 0

	if p4.kind ~= nil and p4.kind.type == "image_background" then
		local v37 = p4.kind.value:encode()
		local v38, v39 = proto.writeTag(buf, n3, 1, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeBuffer(v38, v39, v37, buffer.len(v37))
	end

	local buf3 = buffer.create(n3)

	buffer.copy(buf3, 0, buf, 0, n3)

	return buf3
end
function t6.decode(p5: buffer) -- line: 323
	-- upvalues: t6 (copy), proto (copy), t1 (copy)
	local v42 = t6.new()
	local n4 = 0

	while n4 < buffer.len(p5) do
		local v44, v45

		v44, v45, n4 = proto.readTag(p5, n4)

		if v45 == proto.wireTypes.varint then
			local v46

			v46, n4 = proto.readVarInt(p5, n4)
		elseif v45 == proto.wireTypes.lengthDelimited then
			if v44 == 1 then
				local v47

				v47, n4 = proto.readBuffer(p5, n4)
				v42.kind = {
					type = "image_background",
					value = t1.ImageBackground.decode(v47)
				}
			else
				local v48, v49 = proto.readVarInt(p5, n4)

				n4 = v49 + v48
			end
		elseif v45 == proto.wireTypes.i32 then
			local v50

			v50, n4 = proto.readFixed32(p5, n4)
		elseif v45 == proto.wireTypes.i64 then
			local v51

			v51, n4 = proto.readFixed64(p5, n4)
		else
			error("Unsupported wire type: " .. v45)
		end
	end

	return v42
end
function t6.jsonEncode(p6) -- line: 366
	local t8 = {}

	if p6.kind ~= nil and p6.kind.type == "image_background" then
		t8.imageBackground = p6.kind.value:jsonEncode()
	end

	return t8
end
function t6.jsonDecode(t9: {[any]: any}) -- line: 378
	-- upvalues: t6 (copy), t1 (copy)
	local v55 = t6.new()

	if t9.image_background ~= nil then
		v55.kind = {
			type = "image_background",
			value = t1.ImageBackground.jsonDecode(t9.image_background)
		}
	end

	if t9.imageBackground ~= nil then
		v55.kind = {
			type = "image_background",
			value = t1.ImageBackground.jsonDecode(t9.imageBackground)
		}
	end

	return v55
end

t6.descriptor = {
	name = "BackgroundLayer",
	fullName = "roblox.apppageplatform.shared.v1beta1.BackgroundLayer"
}
t1.BackgroundLayer = t6
typeRegistry.default:register(t1.BackgroundLayer)

local t10 = {}

t10.__index = t10

function t10.new(t11: {[any]: any}?) -- line: 408
	-- upvalues: t10 (copy)
	return (setmetatable({
		kind = if t11 ~= nil and t11.kind ~= nil then t11.kind else nil
	}, t10))
end
function t10.encode(p7) -- line: 416
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n5 = 0

	if p7.kind ~= nil then
		if p7.kind.type == "literal" then
			local v60 = p7.kind.value:encode()
			local v61, v62 = proto.writeTag(buf, n5, 1, proto.wireTypes.lengthDelimited)

			buf, n5 = proto.writeBuffer(v61, v62, v60, buffer.len(v60))
		elseif p7.kind.type == "binding_path" then
			local v63, v64 = proto.writeTag(buf, n5, 2, proto.wireTypes.lengthDelimited)

			buf, n5 = proto.writeString(v63, v64, p7.kind.value)
		elseif p7.kind.type == "conditional" then
			local v65 = p7.kind.value:encode()
			local v66, v67 = proto.writeTag(buf, n5, 3, proto.wireTypes.lengthDelimited)

			buf, n5 = proto.writeBuffer(v66, v67, v65, buffer.len(v65))
		end
	end

	local buf4 = buffer.create(n5)

	buffer.copy(buf4, 0, buf, 0, n5)

	return buf4
end
function t10.decode(p8: buffer) -- line: 440
	-- upvalues: t10 (copy), proto (copy), t1 (copy)
	local v70 = t10.new()
	local n6 = 0

	while n6 < buffer.len(p8) do
		local v72, v73

		v72, v73, n6 = proto.readTag(p8, n6)

		if v73 == proto.wireTypes.varint then
			local v74

			v74, n6 = proto.readVarInt(p8, n6)
		elseif v73 == proto.wireTypes.lengthDelimited then
			if v72 == 1 then
				local v75

				v75, n6 = proto.readBuffer(p8, n6)
				v70.kind = {
					type = "literal",
					value = t1.ArrayOfBackgroundLayerProp_ArrayOfBackgroundLayer.decode(v75)
				}
			elseif v72 == 2 then
				local v76

				v76, n6 = proto.readBuffer(p8, n6)
				v70.kind = {
					type = "binding_path",
					value = buffer.tostring(v76)
				}
			elseif v72 == 3 then
				local v77

				v77, n6 = proto.readBuffer(p8, n6)
				v70.kind = {
					type = "conditional",
					value = t1.ArrayOfBackgroundLayerProp_ConditionalOptions.decode(v77)
				}
			else
				local v78, v79 = proto.readVarInt(p8, n6)

				n6 = v79 + v78
			end
		elseif v73 == proto.wireTypes.i32 then
			local v80

			v80, n6 = proto.readFixed32(p8, n6)
		elseif v73 == proto.wireTypes.i64 then
			local v81

			v81, n6 = proto.readFixed64(p8, n6)
		else
			error("Unsupported wire type: " .. v73)
		end
	end

	return v70
end
function t10.jsonEncode(p9) -- line: 499
	local t12 = {}

	if p9.kind ~= nil then
		if p9.kind.type == "literal" then
			t12.literal = p9.kind.value:jsonEncode()

			return t12
		end

		if p9.kind.type == "binding_path" then
			t12.bindingPath = p9.kind.value

			return t12
		end

		if p9.kind.type == "conditional" then
			t12.conditional = p9.kind.value:jsonEncode()
		end
	end

	return t12
end
function t10.jsonDecode(t13: {[any]: any}) -- line: 515
	-- upvalues: t10 (copy), t1 (copy)
	local v85 = t10.new()

	if t13.literal ~= nil then
		v85.kind = {
			type = "literal",
			value = t1.ArrayOfBackgroundLayerProp_ArrayOfBackgroundLayer.jsonDecode(t13.literal)
		}
	end

	if t13.binding_path ~= nil then
		v85.kind = {
			type = "binding_path",
			value = t13.binding_path
		}
	end

	if t13.bindingPath ~= nil then
		v85.kind = {
			type = "binding_path",
			value = t13.bindingPath
		}
	end

	if t13.conditional ~= nil then
		v85.kind = {
			type = "conditional",
			value = t1.ArrayOfBackgroundLayerProp_ConditionalOptions.jsonDecode(t13.conditional)
		}
	end

	return v85
end

t10.descriptor = {
	name = "ArrayOfBackgroundLayerProp",
	fullName = "roblox.apppageplatform.shared.v1beta1.ArrayOfBackgroundLayerProp"
}
t1.ArrayOfBackgroundLayerProp = t10
typeRegistry.default:register(t1.ArrayOfBackgroundLayerProp)

local t14 = {}

t14.__index = t14

function t14.new(t15: {[any]: any}?) -- line: 557
	-- upvalues: t14 (copy)
	return (setmetatable({
		condition = if t15 ~= nil and t15.condition ~= nil then t15.condition else nil,
		kind = if t15 ~= nil and t15.kind ~= nil then t15.kind else nil
	}, t14))
end
function t14.encode(p10) -- line: 566
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n7 = 0

	if p10.condition ~= nil then
		local v90 = p10.condition:encode()
		local v91, v92 = proto.writeTag(buf, n7, 1, proto.wireTypes.lengthDelimited)

		buf, n7 = proto.writeBuffer(v91, v92, v90, buffer.len(v90))
	end

	if p10.kind ~= nil then
		if p10.kind.type == "literal" then
			local v93 = p10.kind.value:encode()
			local v94, v95 = proto.writeTag(buf, n7, 2, proto.wireTypes.lengthDelimited)

			buf, n7 = proto.writeBuffer(v94, v95, v93, buffer.len(v93))
		elseif p10.kind.type == "binding_path" then
			local v96, v97 = proto.writeTag(buf, n7, 3, proto.wireTypes.lengthDelimited)

			buf, n7 = proto.writeString(v96, v97, p10.kind.value)
		end
	end

	local buf5 = buffer.create(n7)

	buffer.copy(buf5, 0, buf, 0, n7)

	return buf5
end
function t14.decode(p11: buffer) -- line: 594
	-- upvalues: t14 (copy), proto (copy), prop_condition (copy), t1 (copy)
	local v100 = t14.new()
	local n8 = 0

	while n8 < buffer.len(p11) do
		local v102, v103

		v102, v103, n8 = proto.readTag(p11, n8)

		if v103 == proto.wireTypes.varint then
			local v104

			v104, n8 = proto.readVarInt(p11, n8)
		elseif v103 == proto.wireTypes.lengthDelimited then
			if v102 == 1 then
				local v105

				v105, n8 = proto.readBuffer(p11, n8)
				v100.condition = prop_condition.PropCondition.decode(v105)
			elseif v102 == 2 then
				local v106

				v106, n8 = proto.readBuffer(p11, n8)
				v100.kind = {
					type = "literal",
					value = t1.ArrayOfBackgroundLayerProp_ArrayOfBackgroundLayer.decode(v106)
				}
			elseif v102 == 3 then
				local v107

				v107, n8 = proto.readBuffer(p11, n8)
				v100.kind = {
					type = "binding_path",
					value = buffer.tostring(v107)
				}
			else
				local v108, v109 = proto.readVarInt(p11, n8)

				n8 = v109 + v108
			end
		elseif v103 == proto.wireTypes.i32 then
			local v110

			v110, n8 = proto.readFixed32(p11, n8)
		elseif v103 == proto.wireTypes.i64 then
			local v111

			v111, n8 = proto.readFixed64(p11, n8)
		else
			error("Unsupported wire type: " .. v103)
		end
	end

	return v100
end
function t14.jsonEncode(p12) -- line: 652
	local t16 = {}

	if p12.condition ~= nil then
		t16.condition = p12.condition:jsonEncode()
	end

	if p12.kind ~= nil then
		if p12.kind.type == "literal" then
			t16.literal = p12.kind.value:jsonEncode()

			return t16
		end

		if p12.kind.type == "binding_path" then
			t16.bindingPath = p12.kind.value
		end
	end

	return t16
end
function t14.jsonDecode(t17: {[any]: any}) -- line: 672
	-- upvalues: t14 (copy), prop_condition (copy), t1 (copy)
	local v115 = t14.new()

	if t17.condition ~= nil then
		v115.condition = prop_condition.PropCondition.jsonDecode(t17.condition)
	end

	if t17.literal ~= nil then
		v115.kind = {
			type = "literal",
			value = t1.ArrayOfBackgroundLayerProp_ArrayOfBackgroundLayer.jsonDecode(t17.literal)
		}
	end

	if t17.binding_path ~= nil then
		v115.kind = {
			type = "binding_path",
			value = t17.binding_path
		}
	end

	if t17.bindingPath ~= nil then
		v115.kind = {
			type = "binding_path",
			value = t17.bindingPath
		}
	end

	return v115
end

t14.descriptor = {
	name = "ArrayOfBackgroundLayerProp_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}
t1.ArrayOfBackgroundLayerProp_ConditionalOption = t14
typeRegistry.default:register(t1.ArrayOfBackgroundLayerProp_ConditionalOption)

local t18 = {}

t18.__index = t18

function t18.new(t19: {[any]: any}?) -- line: 714
	-- upvalues: t18 (copy)
	return (setmetatable({
		options = if t19 ~= nil and t19.options ~= nil then t19.options else {}
	}, t18))
end
function t18.encode(p13) -- line: 722
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n9 = 0

	if p13.options ~= nil and #p13.options > 0 then
		for _, v121 in p13.options do
			local v122 = v121:encode()
			local v123, v124 = proto.writeTag(buf, n9, 1, proto.wireTypes.lengthDelimited)

			buf, n9 = proto.writeBuffer(v123, v124, v122, buffer.len(v122))
		end
	end

	local buf6 = buffer.create(n9)

	buffer.copy(buf6, 0, buf, 0, n9)

	return buf6
end
function t18.decode(p14: buffer) -- line: 741
	-- upvalues: t18 (copy), proto (copy), t1 (copy)
	local v127 = t18.new()
	local n10 = 0

	while n10 < buffer.len(p14) do
		local v129, v130

		v129, v130, n10 = proto.readTag(p14, n10)

		if v130 == proto.wireTypes.varint then
			local v131

			v131, n10 = proto.readVarInt(p14, n10)
		elseif v130 == proto.wireTypes.lengthDelimited then
			if v129 == 1 then
				local v132

				v132, n10 = proto.readBuffer(p14, n10)
				table.insert(v127.options, t1.ArrayOfBackgroundLayerProp_ConditionalOption.decode(v132))
			else
				local v133, v134 = proto.readVarInt(p14, n10)

				n10 = v134 + v133
			end
		elseif v130 == proto.wireTypes.i32 then
			local v135

			v135, n10 = proto.readFixed32(p14, n10)
		elseif v130 == proto.wireTypes.i64 then
			local v136

			v136, n10 = proto.readFixed64(p14, n10)
		else
			error("Unsupported wire type: " .. v130)
		end
	end

	return v127
end
function t18.jsonEncode(p15) -- line: 786
	local t20 = {}

	if p15.options ~= nil and #p15.options > 0 then
		local t21 = {}

		for _, v141 in p15.options do
			table.insert(t21, v141:jsonEncode())
		end

		t20.options = t21
	end

	return t20
end
function t18.jsonDecode(t22: {[any]: any}) -- line: 802
	-- upvalues: t18 (copy), t1 (copy)
	local v143 = t18.new()

	if t22.options ~= nil then
		local t23 = {}

		for _, v146 in t22.options do
			table.insert(t23, t1.ArrayOfBackgroundLayerProp_ConditionalOption.jsonDecode(v146))
		end

		v143.options = t23
	end

	return v143
end

t18.descriptor = {
	name = "ArrayOfBackgroundLayerProp_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}
t1.ArrayOfBackgroundLayerProp_ConditionalOptions = t18
typeRegistry.default:register(t1.ArrayOfBackgroundLayerProp_ConditionalOptions)

local t24 = {}

t24.__index = t24

function t24.new(t25: {[any]: any}?) -- line: 834
	-- upvalues: t24 (copy)
	return (setmetatable({
		array = if t25 ~= nil and t25.array ~= nil then t25.array else {}
	}, t24))
end
function t24.encode(p16) -- line: 845
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n11 = 0

	if p16.array ~= nil and #p16.array > 0 then
		for _, v152 in p16.array do
			local v153 = v152:encode()
			local v154, v155 = proto.writeTag(buf, n11, 1, proto.wireTypes.lengthDelimited)

			buf, n11 = proto.writeBuffer(v154, v155, v153, buffer.len(v153))
		end
	end

	local buf7 = buffer.create(n11)

	buffer.copy(buf7, 0, buf, 0, n11)

	return buf7
end
function t24.decode(p17: buffer) -- line: 864
	-- upvalues: t24 (copy), proto (copy), t1 (copy)
	local v158 = t24.new()
	local n12 = 0

	while n12 < buffer.len(p17) do
		local v160, v161

		v160, v161, n12 = proto.readTag(p17, n12)

		if v161 == proto.wireTypes.varint then
			local v162

			v162, n12 = proto.readVarInt(p17, n12)
		elseif v161 == proto.wireTypes.lengthDelimited then
			if v160 == 1 then
				local v163

				v163, n12 = proto.readBuffer(p17, n12)
				table.insert(v158.array, t1.BackgroundLayer.decode(v163))
			else
				local v164, v165 = proto.readVarInt(p17, n12)

				n12 = v165 + v164
			end
		elseif v161 == proto.wireTypes.i32 then
			local v166

			v166, n12 = proto.readFixed32(p17, n12)
		elseif v161 == proto.wireTypes.i64 then
			local v167

			v167, n12 = proto.readFixed64(p17, n12)
		else
			error("Unsupported wire type: " .. v161)
		end
	end

	return v158
end
function t24.jsonEncode(p18) -- line: 909
	local t26 = {}

	if p18.array ~= nil and #p18.array > 0 then
		local t27 = {}

		for _, v172 in p18.array do
			table.insert(t27, v172:jsonEncode())
		end

		t26.array = t27
	end

	return t26
end
function t24.jsonDecode(t28: {[any]: any}) -- line: 925
	-- upvalues: t24 (copy), t1 (copy)
	local v174 = t24.new()

	if t28.array ~= nil then
		local t29 = {}

		for _, v177 in t28.array do
			table.insert(t29, t1.BackgroundLayer.jsonDecode(v177))
		end

		v174.array = t29
	end

	return v174
end

t24.descriptor = {
	name = "ArrayOfBackgroundLayerProp_ArrayOfBackgroundLayer",
	fullName = "roblox.apppageplatform.shared.v1beta1.ArrayOfBackgroundLayer"
}
t1.ArrayOfBackgroundLayerProp_ArrayOfBackgroundLayer = t24
typeRegistry.default:register(t1.ArrayOfBackgroundLayerProp_ArrayOfBackgroundLayer)

return {
	ImageBackground = t1.ImageBackground,
	BackgroundLayer = t1.BackgroundLayer,
	ArrayOfBackgroundLayerProp = t1.ArrayOfBackgroundLayerProp,
	ArrayOfBackgroundLayerProp_ConditionalOption = t1.ArrayOfBackgroundLayerProp_ConditionalOption,
	ArrayOfBackgroundLayerProp_ConditionalOptions = t1.ArrayOfBackgroundLayerProp_ConditionalOptions,
	ArrayOfBackgroundLayerProp_ArrayOfBackgroundLayer = t1.ArrayOfBackgroundLayerProp_ArrayOfBackgroundLayer
}
