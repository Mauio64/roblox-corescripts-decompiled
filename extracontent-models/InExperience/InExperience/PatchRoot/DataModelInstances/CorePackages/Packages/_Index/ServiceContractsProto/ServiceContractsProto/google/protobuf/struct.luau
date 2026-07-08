local proto = require(script.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 125
	-- upvalues: t2 (copy)
	return (setmetatable({
		fields = if t3 ~= nil and t3.fields ~= nil then t3.fields else {}
	}, t2))
end
function t2.encode(p1) -- line: 131
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.fields ~= nil and next(p1.fields) ~= nil then
		for v12, v13 in p1.fields do
			local buf2 = buffer.create(0)
			local v15, v16 = proto.writeTag(buf2, 0, 1, proto.wireTypes.lengthDelimited)
			local v17, v18 = proto.writeString(v15, v16, v12)
			local v19 = v13:encode()
			local v20, v21 = proto.writeTag(v17, v18, 2, proto.wireTypes.lengthDelimited)
			local v22, v23 = proto.writeBuffer(v20, v21, v19, buffer.len(v19))
			local v24, v25 = proto.writeTag(buf, n1, 1, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v24, v25, v22, v23)
		end
	end

	local buf3 = buffer.create(n1)

	buffer.copy(buf3, 0, buf, 0, n1)

	return buf3
end
function t2.decode(p2: buffer) -- line: 154
	-- upvalues: t2 (copy), proto (copy), t1 (copy)
	local v28 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v30, v31

		v30, v31, n2 = proto.readTag(p2, n2)

		if v31 == proto.wireTypes.varint then
			local v32

			v32, n2 = proto.readVarInt(p2, n2)
		elseif v31 == proto.wireTypes.lengthDelimited then
			if v30 == 1 then
				local v33

				v33, n2 = proto.readBuffer(p2, n2)

				local v34 = t1.Struct_FieldsEntry.decode(v33)
				local v35 = t1.Value.new()

				v28.fields[v34.key or ""] = v34.value or v35
			else
				local v36, v37 = proto.readVarInt(p2, n2)

				n2 = v37 + v36
			end
		elseif v31 == proto.wireTypes.i32 then
			local v38

			v38, n2 = proto.readFixed32(p2, n2)
		elseif v31 == proto.wireTypes.i64 then
			local v39

			v39, n2 = proto.readFixed64(p2, n2)
		else
			error("Unsupported wire type: " .. v31)
		end
	end

	return v28
end
function t2.jsonEncode(p3) -- line: 204
	-- upvalues: t1 (copy)
	local t4 = {}

	for v42, v43 in p3.fields do
		t4[v42] = t1.Value.jsonEncode(v43)
	end

	return t4
end
function t2.jsonDecode(t5: {[any]: any}) -- line: 214
	-- upvalues: t1 (copy), t2 (copy)
	local t6 = {}

	for v46, v47 in t5 do
		t6[v46] = t1.Value.jsonDecode(v47)
	end

	return t2.new({
		fields = t6
	})
end

t2.descriptor = {
	name = "Struct",
	fullName = "google.protobuf.Struct"
}
t1.Struct = t2
typeRegistry.default:register(t1.Struct)

local t7 = {}

t7.__index = t7

function t7.new(t8: {[any]: any}?) -- line: 240
	-- upvalues: t7 (copy)
	return (setmetatable({
		key = if t8 ~= nil and t8.key ~= nil then t8.key else "",
		value = if t8 ~= nil and t8.value ~= nil then t8.value else nil
	}, t7))
end
function t7.encode(p4) -- line: 247
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n3 = 0

	if p4.key ~= nil and p4.key ~= "" then
		local v52, v53 = proto.writeTag(buf, n3, 1, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeString(v52, v53, p4.key)
	end

	if p4.value ~= nil then
		local v54 = p4.value:encode()
		local v55, v56 = proto.writeTag(buf, n3, 2, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeBuffer(v55, v56, v54, buffer.len(v54))
	end

	local buf4 = buffer.create(n3)

	buffer.copy(buf4, 0, buf, 0, n3)

	return buf4
end
function t7.decode(p5: buffer) -- line: 267
	-- upvalues: t7 (copy), proto (copy), t1 (copy)
	local v59 = t7.new()
	local n4 = 0

	while n4 < buffer.len(p5) do
		local v61, v62

		v61, v62, n4 = proto.readTag(p5, n4)

		if v62 == proto.wireTypes.varint then
			local v63

			v63, n4 = proto.readVarInt(p5, n4)
		elseif v62 == proto.wireTypes.lengthDelimited then
			if v61 == 1 then
				local v64

				v64, n4 = proto.readBuffer(p5, n4)
				v59.key = buffer.tostring(v64)
			elseif v61 == 2 then
				local v65

				v65, n4 = proto.readBuffer(p5, n4)
				v59.value = t1.Value.decode(v65)
			else
				local v66, v67 = proto.readVarInt(p5, n4)

				n4 = v67 + v66
			end
		elseif v62 == proto.wireTypes.i32 then
			local v68

			v68, n4 = proto.readFixed32(p5, n4)
		elseif v62 == proto.wireTypes.i64 then
			local v69

			v69, n4 = proto.readFixed64(p5, n4)
		else
			error("Unsupported wire type: " .. v62)
		end
	end

	return v59
end
function t7.jsonEncode(p6) -- line: 315
	local t9 = {}

	if p6.key ~= nil and p6.key ~= "" then
		t9.key = p6.key
	end

	if p6.value ~= nil then
		t9.value = p6.value:jsonEncode()
	end

	return t9
end
function t7.jsonDecode(t10: {[any]: any}) -- line: 329
	-- upvalues: t7 (copy), t1 (copy)
	local v73 = t7.new()

	if t10.key ~= nil then
		v73.key = t10.key
	end

	if t10.value ~= nil then
		v73.value = t1.Value.jsonDecode(t10.value)
	end

	return v73
end

t7.descriptor = {
	name = "Struct_FieldsEntry",
	fullName = "google.protobuf.FieldsEntry"
}
t1.Struct_FieldsEntry = t7
typeRegistry.default:register(t1.Struct_FieldsEntry)

local t11 = {}

t11.__index = t11

function t11.new(t12: {[any]: any}?) -- line: 357
	-- upvalues: t11 (copy)
	return (setmetatable({
		kind = if t12 ~= nil and t12.kind ~= nil then t12.kind else nil
	}, t11))
end
function t11.encode(p7) -- line: 363
	-- upvalues: proto (copy), t1 (copy)
	local buf = buffer.create(0)
	local n5 = 0

	if p7.kind ~= nil then
		if p7.kind.type == "null_value" then
			local v78, v79 = proto.writeTag(buf, n5, 1, proto.wireTypes.varint)

			buf, n5 = proto.writeVarInt(v78, v79, t1.NullValue.toNumber(p7.kind.value))
		elseif p7.kind.type == "number_value" then
			local v80, v81 = proto.writeTag(buf, n5, 2, proto.wireTypes.i64)

			buf, n5 = proto.writeDouble(v80, v81, p7.kind.value)
		elseif p7.kind.type == "string_value" then
			local v82, v83 = proto.writeTag(buf, n5, 3, proto.wireTypes.lengthDelimited)

			buf, n5 = proto.writeString(v82, v83, p7.kind.value)
		elseif p7.kind.type == "bool_value" then
			local v84, v85 = proto.writeTag(buf, n5, 4, proto.wireTypes.varint)

			buf, n5 = proto.writeVarInt(v84, v85, not p7.kind.value and 0 or 1)
		elseif p7.kind.type == "struct_value" then
			local v86 = p7.kind.value:encode()
			local v87, v88 = proto.writeTag(buf, n5, 5, proto.wireTypes.lengthDelimited)

			buf, n5 = proto.writeBuffer(v87, v88, v86, buffer.len(v86))
		elseif p7.kind.type == "list_value" then
			local v89 = p7.kind.value:encode()
			local v90, v91 = proto.writeTag(buf, n5, 6, proto.wireTypes.lengthDelimited)

			buf, n5 = proto.writeBuffer(v90, v91, v89, buffer.len(v89))
		end
	end

	local buf5 = buffer.create(n5)

	buffer.copy(buf5, 0, buf, 0, n5)

	return buf5
end
function t11.decode(p8: buffer) -- line: 396
	-- upvalues: t11 (copy), proto (copy), t1 (copy)
	local v94 = t11.new()
	local n6 = 0

	while n6 < buffer.len(p8) do
		local v96, v97

		v96, v97, n6 = proto.readTag(p8, n6)

		if v97 == proto.wireTypes.varint then
			if v96 == 1 then
				local v98

				v98, n6 = proto.readVarIntI32(p8, n6)
				v94.kind = {
					type = "null_value",
					value = t1.NullValue.fromNumber(v98) or v98
				}
			elseif v96 == 4 then
				local v99

				v99, n6 = proto.readVarInt(p8, n6)
				v94.kind = {
					type = "bool_value",
					value = v99 ~= 0
				}
			else
				local v100

				v100, n6 = proto.readVarInt(p8, n6)
			end
		elseif v97 == proto.wireTypes.lengthDelimited then
			if v96 == 3 then
				local v101

				v101, n6 = proto.readBuffer(p8, n6)
				v94.kind = {
					type = "string_value",
					value = buffer.tostring(v101)
				}
			elseif v96 == 5 then
				local v102

				v102, n6 = proto.readBuffer(p8, n6)
				v94.kind = {
					type = "struct_value",
					value = t1.Struct.decode(v102)
				}
			elseif v96 == 6 then
				local v103

				v103, n6 = proto.readBuffer(p8, n6)
				v94.kind = {
					type = "list_value",
					value = t1.ListValue.decode(v103)
				}
			else
				local v104, v105 = proto.readVarInt(p8, n6)

				n6 = v105 + v104
			end
		elseif v97 == proto.wireTypes.i32 then
			local v106

			v106, n6 = proto.readFixed32(p8, n6)
		elseif v97 == proto.wireTypes.i64 then
			if v96 == 2 then
				local v107

				v107, n6 = proto.readDouble(p8, n6)
				v94.kind = {
					type = "number_value",
					value = v107
				}
			else
				local v108

				v108, n6 = proto.readFixed64(p8, n6)
			end
		else
			error("Unsupported wire type: " .. v97)
		end
	end

	return v94
end
function t11.jsonEncode(p9) -- line: 467
	-- upvalues: t1 (copy)
	local kind = p9.kind

	if kind == nil or kind.type == "null_value" then
		return nil
	end

	if kind.type == "number_value" or kind.type == "string_value" or kind.type == "bool_value" then
		return kind.value
	end

	if kind.type == "list_value" then
		return t1.ListValue.jsonEncode(kind.value)
	end

	if kind.type == "struct_value" then
		return t1.Struct.jsonEncode(kind.value)
	end

	return kind.type
end
function t11.jsonDecode(p10) -- line: 484
	-- upvalues: t11 (copy), t1 (copy)
	if p10 == nil then
		return t11.new({
			kind = {
				type = "null_value",
				value = "NULL_VALUE"
			}
		})
	end

	if typeof(p10) == "number" then
		return t11.new({
			kind = {
				type = "number_value",
				value = p10
			}
		})
	end

	if typeof(p10) == "string" then
		return t11.new({
			kind = {
				type = "string_value",
				value = p10
			}
		})
	end

	if typeof(p10) == "boolean" then
		return t11.new({
			kind = {
				type = "bool_value",
				value = p10
			}
		})
	end

	if typeof(p10) == "table" then
		local n7 = 0

		for _ in p10 do
			n7 += 1

			if n7 > #p10 then
				break
			end
		end

		if n7 == #p10 then
			return t11.new({
				kind = {
					type = "list_value",
					value = t1.ListValue.jsonDecode(p10)
				}
			})
		end

		return t11.new({
			kind = {
				type = "struct_value",
				value = t1.Struct.jsonDecode(p10)
			}
		})
	end

	error(`Unknown input type: { typeof(p10) }`)
end

t11.descriptor = {
	name = "Value",
	fullName = "google.protobuf.Value"
}
t1.Value = t11
typeRegistry.default:register(t1.Value)

local t13 = {}

t13.__index = t13

function t13.new(t14: {[any]: any}?) -- line: 530
	-- upvalues: t13 (copy)
	return (setmetatable({
		values = if t14 ~= nil and t14.values ~= nil then t14.values else {}
	}, t13))
end
function t13.encode(p11) -- line: 536
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n8 = 0

	if p11.values ~= nil and #p11.values > 0 then
		for _, v119 in p11.values do
			local v120 = v119:encode()
			local v121, v122 = proto.writeTag(buf, n8, 1, proto.wireTypes.lengthDelimited)

			buf, n8 = proto.writeBuffer(v121, v122, v120, buffer.len(v120))
		end
	end

	local buf6 = buffer.create(n8)

	buffer.copy(buf6, 0, buf, 0, n8)

	return buf6
end
function t13.decode(p12: buffer) -- line: 553
	-- upvalues: t13 (copy), proto (copy), t1 (copy)
	local v125 = t13.new()
	local n9 = 0

	while n9 < buffer.len(p12) do
		local v127, v128

		v127, v128, n9 = proto.readTag(p12, n9)

		if v128 == proto.wireTypes.varint then
			local v129

			v129, n9 = proto.readVarInt(p12, n9)
		elseif v128 == proto.wireTypes.lengthDelimited then
			if v127 == 1 then
				local v130

				v130, n9 = proto.readBuffer(p12, n9)
				table.insert(v125.values, t1.Value.decode(v130))
			else
				local v131, v132 = proto.readVarInt(p12, n9)

				n9 = v132 + v131
			end
		elseif v128 == proto.wireTypes.i32 then
			local v133

			v133, n9 = proto.readFixed32(p12, n9)
		elseif v128 == proto.wireTypes.i64 then
			local v134

			v134, n9 = proto.readFixed64(p12, n9)
		else
			error("Unsupported wire type: " .. v128)
		end
	end

	return v125
end
function t13.jsonEncode(p13) -- line: 596
	-- upvalues: t1 (copy)
	local t15 = {}

	for _, v138 in p13.values do
		table.insert(t15, t1.Value.jsonEncode(v138))
	end

	return t15
end
function t13.jsonDecode(p14) -- line: 606
	-- upvalues: t1 (copy), t13 (copy)
	local t16 = {}

	for _, v142 in p14 do
		table.insert(t16, t1.Value.jsonDecode(v142))
	end

	return t13.new({
		values = t16
	})
end

t13.descriptor = {
	name = "ListValue",
	fullName = "google.protobuf.ListValue"
}
t1.ListValue = t13
typeRegistry.default:register(t1.ListValue)
t1.NullValue = {
	fromNumber = function(n10: number) -- line: 631
		if n10 == 0 then
			return "NULL_VALUE"
		end

		return nil
	end,
	toNumber = function(p15) -- line: 639
		if p15 == "NULL_VALUE" then
			return 0
		end

		return p15
	end,
	fromName = function(s1: string) -- line: 647
		if s1 == "NULL_VALUE" then
			return "NULL_VALUE"
		end

		return nil
	end
}

return {
	Struct = t1.Struct,
	Value = t1.Value,
	ListValue = t1.ListValue,
	NullValue = t1.NullValue
}
