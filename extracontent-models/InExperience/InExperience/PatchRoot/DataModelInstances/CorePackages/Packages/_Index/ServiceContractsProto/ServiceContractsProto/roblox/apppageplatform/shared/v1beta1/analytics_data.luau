local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local prop_condition = require(script.Parent.prop_condition)
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 107
	-- upvalues: t2 (copy)
	return (setmetatable({
		kind = if t3 ~= nil and t3.kind ~= nil then t3.kind else nil
	}, t2))
end
function t2.encode(p1) -- line: 113
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.kind ~= nil then
		if p1.kind.type == "binding_path" then
			local v12, v13 = proto.writeTag(buf, n1, 1, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeString(v12, v13, p1.kind.value)
		elseif p1.kind.type == "literal" then
			local v14, v15 = proto.writeTag(buf, n1, 2, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeString(v14, v15, p1.kind.value)
		elseif p1.kind.type == "conditional" then
			local v16 = p1.kind.value:encode()
			local v17, v18 = proto.writeTag(buf, n1, 3, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v17, v18, v16, buffer.len(v16))
		end
	end

	local buf2 = buffer.create(n1)

	buffer.copy(buf2, 0, buf, 0, n1)

	return buf2
end
function t2.decode(p2: buffer) -- line: 136
	-- upvalues: t2 (copy), proto (copy), t1 (copy)
	local v21 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v23, v24

		v23, v24, n2 = proto.readTag(p2, n2)

		if v24 == proto.wireTypes.varint then
			local v25

			v25, n2 = proto.readVarInt(p2, n2)
		elseif v24 == proto.wireTypes.lengthDelimited then
			if v23 == 1 then
				local v26

				v26, n2 = proto.readBuffer(p2, n2)
				v21.kind = {
					type = "binding_path",
					value = buffer.tostring(v26)
				}
			elseif v23 == 2 then
				local v27

				v27, n2 = proto.readBuffer(p2, n2)
				v21.kind = {
					type = "literal",
					value = buffer.tostring(v27)
				}
			elseif v23 == 3 then
				local v28

				v28, n2 = proto.readBuffer(p2, n2)
				v21.kind = {
					type = "conditional",
					value = t1.AnalyticsDataField_ConditionalOptions.decode(v28)
				}
			else
				local v29, v30 = proto.readVarInt(p2, n2)

				n2 = v30 + v29
			end
		elseif v24 == proto.wireTypes.i32 then
			local v31

			v31, n2 = proto.readFixed32(p2, n2)
		elseif v24 == proto.wireTypes.i64 then
			local v32

			v32, n2 = proto.readFixed64(p2, n2)
		else
			error("Unsupported wire type: " .. v24)
		end
	end

	return v21
end
function t2.jsonEncode(p3) -- line: 190
	local t4 = {}

	if p3.kind ~= nil then
		if p3.kind.type == "binding_path" then
			t4.bindingPath = p3.kind.value

			return t4
		end

		if p3.kind.type == "literal" then
			t4.literal = p3.kind.value

			return t4
		end

		if p3.kind.type == "conditional" then
			t4.conditional = p3.kind.value:jsonEncode()
		end
	end

	return t4
end
function t2.jsonDecode(t5: {[any]: any}) -- line: 206
	-- upvalues: t2 (copy), t1 (copy)
	local v36 = t2.new()

	if t5.binding_path ~= nil then
		v36.kind = {
			type = "binding_path",
			value = t5.binding_path
		}
	end

	if t5.bindingPath ~= nil then
		v36.kind = {
			type = "binding_path",
			value = t5.bindingPath
		}
	end

	if t5.literal ~= nil then
		v36.kind = {
			type = "literal",
			value = t5.literal
		}
	end

	if t5.conditional ~= nil then
		v36.kind = {
			type = "conditional",
			value = t1.AnalyticsDataField_ConditionalOptions.jsonDecode(t5.conditional)
		}
	end

	return v36
end

t2.descriptor = {
	name = "AnalyticsDataField",
	fullName = "roblox.apppageplatform.shared.v1beta1.AnalyticsDataField"
}
t1.AnalyticsDataField = t2
typeRegistry.default:register(t1.AnalyticsDataField)

local t6 = {}

t6.__index = t6

function t6.new(t7: {[any]: any}?) -- line: 245
	-- upvalues: t6 (copy)
	return (setmetatable({
		condition = if t7 ~= nil and t7.condition ~= nil then t7.condition else nil,
		kind = if t7 ~= nil and t7.kind ~= nil then t7.kind else nil
	}, t6))
end
function t6.encode(p4) -- line: 254
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n3 = 0

	if p4.condition ~= nil then
		local v41 = p4.condition:encode()
		local v42, v43 = proto.writeTag(buf, n3, 1, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeBuffer(v42, v43, v41, buffer.len(v41))
	end

	if p4.kind ~= nil then
		if p4.kind.type == "literal" then
			local v44, v45 = proto.writeTag(buf, n3, 2, proto.wireTypes.lengthDelimited)

			buf, n3 = proto.writeString(v44, v45, p4.kind.value)
		elseif p4.kind.type == "binding_path" then
			local v46, v47 = proto.writeTag(buf, n3, 3, proto.wireTypes.lengthDelimited)

			buf, n3 = proto.writeString(v46, v47, p4.kind.value)
		end
	end

	local buf3 = buffer.create(n3)

	buffer.copy(buf3, 0, buf, 0, n3)

	return buf3
end
function t6.decode(p5: buffer) -- line: 279
	-- upvalues: t6 (copy), proto (copy), prop_condition (copy)
	local v50 = t6.new()
	local n4 = 0

	while n4 < buffer.len(p5) do
		local v52, v53

		v52, v53, n4 = proto.readTag(p5, n4)

		if v53 == proto.wireTypes.varint then
			local v54

			v54, n4 = proto.readVarInt(p5, n4)
		elseif v53 == proto.wireTypes.lengthDelimited then
			if v52 == 1 then
				local v55

				v55, n4 = proto.readBuffer(p5, n4)
				v50.condition = prop_condition.PropCondition.decode(v55)
			elseif v52 == 2 then
				local v56

				v56, n4 = proto.readBuffer(p5, n4)
				v50.kind = {
					type = "literal",
					value = buffer.tostring(v56)
				}
			elseif v52 == 3 then
				local v57

				v57, n4 = proto.readBuffer(p5, n4)
				v50.kind = {
					type = "binding_path",
					value = buffer.tostring(v57)
				}
			else
				local v58, v59 = proto.readVarInt(p5, n4)

				n4 = v59 + v58
			end
		elseif v53 == proto.wireTypes.i32 then
			local v60

			v60, n4 = proto.readFixed32(p5, n4)
		elseif v53 == proto.wireTypes.i64 then
			local v61

			v61, n4 = proto.readFixed64(p5, n4)
		else
			error("Unsupported wire type: " .. v53)
		end
	end

	return v50
end
function t6.jsonEncode(p6) -- line: 332
	local t8 = {}

	if p6.condition ~= nil then
		t8.condition = p6.condition:jsonEncode()
	end

	if p6.kind ~= nil then
		if p6.kind.type == "literal" then
			t8.literal = p6.kind.value

			return t8
		end

		if p6.kind.type == "binding_path" then
			t8.bindingPath = p6.kind.value
		end
	end

	return t8
end
function t6.jsonDecode(t9: {[any]: any}) -- line: 350
	-- upvalues: t6 (copy), prop_condition (copy)
	local v65 = t6.new()

	if t9.condition ~= nil then
		v65.condition = prop_condition.PropCondition.jsonDecode(t9.condition)
	end

	if t9.literal ~= nil then
		v65.kind = {
			type = "literal",
			value = t9.literal
		}
	end

	if t9.binding_path ~= nil then
		v65.kind = {
			type = "binding_path",
			value = t9.binding_path
		}
	end

	if t9.bindingPath ~= nil then
		v65.kind = {
			type = "binding_path",
			value = t9.bindingPath
		}
	end

	return v65
end

t6.descriptor = {
	name = "AnalyticsDataField_ConditionalOption",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOption"
}
t1.AnalyticsDataField_ConditionalOption = t6
typeRegistry.default:register(t1.AnalyticsDataField_ConditionalOption)

local t10 = {}

t10.__index = t10

function t10.new(t11: {[any]: any}?) -- line: 389
	-- upvalues: t10 (copy)
	return (setmetatable({
		options = if t11 ~= nil and t11.options ~= nil then t11.options else {}
	}, t10))
end
function t10.encode(p7) -- line: 397
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n5 = 0

	if p7.options ~= nil and #p7.options > 0 then
		for _, v71 in p7.options do
			local v72 = v71:encode()
			local v73, v74 = proto.writeTag(buf, n5, 1, proto.wireTypes.lengthDelimited)

			buf, n5 = proto.writeBuffer(v73, v74, v72, buffer.len(v72))
		end
	end

	local buf4 = buffer.create(n5)

	buffer.copy(buf4, 0, buf, 0, n5)

	return buf4
end
function t10.decode(p8: buffer) -- line: 414
	-- upvalues: t10 (copy), proto (copy), t1 (copy)
	local v77 = t10.new()
	local n6 = 0

	while n6 < buffer.len(p8) do
		local v79, v80

		v79, v80, n6 = proto.readTag(p8, n6)

		if v80 == proto.wireTypes.varint then
			local v81

			v81, n6 = proto.readVarInt(p8, n6)
		elseif v80 == proto.wireTypes.lengthDelimited then
			if v79 == 1 then
				local v82

				v82, n6 = proto.readBuffer(p8, n6)
				table.insert(v77.options, t1.AnalyticsDataField_ConditionalOption.decode(v82))
			else
				local v83, v84 = proto.readVarInt(p8, n6)

				n6 = v84 + v83
			end
		elseif v80 == proto.wireTypes.i32 then
			local v85

			v85, n6 = proto.readFixed32(p8, n6)
		elseif v80 == proto.wireTypes.i64 then
			local v86

			v86, n6 = proto.readFixed64(p8, n6)
		else
			error("Unsupported wire type: " .. v80)
		end
	end

	return v77
end
function t10.jsonEncode(p9) -- line: 457
	local t12 = {}

	if p9.options ~= nil and #p9.options > 0 then
		local t13 = {}

		for _, v91 in p9.options do
			table.insert(t13, v91:jsonEncode())
		end

		t12.options = t13
	end

	return t12
end
function t10.jsonDecode(t14: {[any]: any}) -- line: 471
	-- upvalues: t10 (copy), t1 (copy)
	local v93 = t10.new()

	if t14.options ~= nil then
		local t15 = {}

		for _, v96 in t14.options do
			table.insert(t15, t1.AnalyticsDataField_ConditionalOption.jsonDecode(v96))
		end

		v93.options = t15
	end

	return v93
end

t10.descriptor = {
	name = "AnalyticsDataField_ConditionalOptions",
	fullName = "roblox.apppageplatform.shared.v1beta1.ConditionalOptions"
}
t1.AnalyticsDataField_ConditionalOptions = t10
typeRegistry.default:register(t1.AnalyticsDataField_ConditionalOptions)

return {
	AnalyticsDataField = t1.AnalyticsDataField,
	AnalyticsDataField_ConditionalOption = t1.AnalyticsDataField_ConditionalOption,
	AnalyticsDataField_ConditionalOptions = t1.AnalyticsDataField_ConditionalOptions
}
