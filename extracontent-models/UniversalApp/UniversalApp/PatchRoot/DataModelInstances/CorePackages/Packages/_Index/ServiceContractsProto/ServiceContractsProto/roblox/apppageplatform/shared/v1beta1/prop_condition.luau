local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 231
	-- upvalues: t2 (copy)
	return (setmetatable({
		kind = if t3 ~= nil and t3.kind ~= nil then t3.kind else nil
	}, t2))
end
function t2.encode(p1) -- line: 237
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.kind ~= nil then
		if p1.kind.type == "comparison" then
			local v16 = p1.kind.value:encode()
			local v17, v18 = proto.writeTag(buf, n1, 1, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v17, v18, v16, buffer.len(v16))
		elseif p1.kind.type == "is_null" then
			local v19 = p1.kind.value:encode()
			local v20, v21 = proto.writeTag(buf, n1, 2, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v20, v21, v19, buffer.len(v19))
		elseif p1.kind.type == "is_not_null" then
			local v22 = p1.kind.value:encode()
			local v23, v24 = proto.writeTag(buf, n1, 3, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v23, v24, v22, buffer.len(v22))
		elseif p1.kind.type == "and_condition" then
			local v25 = p1.kind.value:encode()
			local v26, v27 = proto.writeTag(buf, n1, 4, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v26, v27, v25, buffer.len(v25))
		elseif p1.kind.type == "or_condition" then
			local v28 = p1.kind.value:encode()
			local v29, v30 = proto.writeTag(buf, n1, 5, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v29, v30, v28, buffer.len(v28))
		elseif p1.kind.type == "is_empty" then
			local v31 = p1.kind.value:encode()
			local v32, v33 = proto.writeTag(buf, n1, 6, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v32, v33, v31, buffer.len(v31))
		elseif p1.kind.type == "is_not_empty" then
			local v34 = p1.kind.value:encode()
			local v35, v36 = proto.writeTag(buf, n1, 7, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v35, v36, v34, buffer.len(v34))
		end
	end

	local buf2 = buffer.create(n1)

	buffer.copy(buf2, 0, buf, 0, n1)

	return buf2
end
function t2.decode(p2: buffer) -- line: 278
	-- upvalues: t2 (copy), proto (copy), t1 (copy)
	local v39 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v41, v42

		v41, v42, n2 = proto.readTag(p2, n2)

		if v42 == proto.wireTypes.varint then
			local v43

			v43, n2 = proto.readVarInt(p2, n2)
		elseif v42 == proto.wireTypes.lengthDelimited then
			if v41 == 1 then
				local v44

				v44, n2 = proto.readBuffer(p2, n2)
				v39.kind = {
					type = "comparison",
					value = t1.ComparisonCondition.decode(v44)
				}
			elseif v41 == 2 then
				local v45

				v45, n2 = proto.readBuffer(p2, n2)
				v39.kind = {
					type = "is_null",
					value = t1.IsNullCondition.decode(v45)
				}
			elseif v41 == 3 then
				local v46

				v46, n2 = proto.readBuffer(p2, n2)
				v39.kind = {
					type = "is_not_null",
					value = t1.IsNotNullCondition.decode(v46)
				}
			elseif v41 == 4 then
				local v47

				v47, n2 = proto.readBuffer(p2, n2)
				v39.kind = {
					type = "and_condition",
					value = t1.AndCondition.decode(v47)
				}
			elseif v41 == 5 then
				local v48

				v48, n2 = proto.readBuffer(p2, n2)
				v39.kind = {
					type = "or_condition",
					value = t1.OrCondition.decode(v48)
				}
			elseif v41 == 6 then
				local v49

				v49, n2 = proto.readBuffer(p2, n2)
				v39.kind = {
					type = "is_empty",
					value = t1.IsEmptyCondition.decode(v49)
				}
			elseif v41 == 7 then
				local v50

				v50, n2 = proto.readBuffer(p2, n2)
				v39.kind = {
					type = "is_not_empty",
					value = t1.IsNotEmptyCondition.decode(v50)
				}
			else
				local v51, v52 = proto.readVarInt(p2, n2)

				n2 = v52 + v51
			end
		elseif v42 == proto.wireTypes.i32 then
			local v53

			v53, n2 = proto.readFixed32(p2, n2)
		elseif v42 == proto.wireTypes.i64 then
			local v54

			v54, n2 = proto.readFixed64(p2, n2)
		else
			error("Unsupported wire type: " .. v42)
		end
	end

	return v39
end
function t2.jsonEncode(p3) -- line: 351
	local t4 = {}

	if p3.kind ~= nil then
		if p3.kind.type == "comparison" then
			t4.comparison = p3.kind.value:jsonEncode()

			return t4
		end

		if p3.kind.type == "is_null" then
			t4.isNull = p3.kind.value:jsonEncode()

			return t4
		end

		if p3.kind.type == "is_not_null" then
			t4.isNotNull = p3.kind.value:jsonEncode()

			return t4
		end

		if p3.kind.type == "and_condition" then
			t4.andCondition = p3.kind.value:jsonEncode()

			return t4
		end

		if p3.kind.type == "or_condition" then
			t4.orCondition = p3.kind.value:jsonEncode()

			return t4
		end

		if p3.kind.type == "is_empty" then
			t4.isEmpty = p3.kind.value:jsonEncode()

			return t4
		end

		if p3.kind.type == "is_not_empty" then
			t4.isNotEmpty = p3.kind.value:jsonEncode()
		end
	end

	return t4
end
function t2.jsonDecode(t5: {[any]: any}) -- line: 375
	-- upvalues: t2 (copy), t1 (copy)
	local v58 = t2.new()

	if t5.comparison ~= nil then
		v58.kind = {
			type = "comparison",
			value = t1.ComparisonCondition.jsonDecode(t5.comparison)
		}
	end

	if t5.is_null ~= nil then
		v58.kind = {
			type = "is_null",
			value = t1.IsNullCondition.jsonDecode(t5.is_null)
		}
	end

	if t5.isNull ~= nil then
		v58.kind = {
			type = "is_null",
			value = t1.IsNullCondition.jsonDecode(t5.isNull)
		}
	end

	if t5.is_not_null ~= nil then
		v58.kind = {
			type = "is_not_null",
			value = t1.IsNotNullCondition.jsonDecode(t5.is_not_null)
		}
	end

	if t5.isNotNull ~= nil then
		v58.kind = {
			type = "is_not_null",
			value = t1.IsNotNullCondition.jsonDecode(t5.isNotNull)
		}
	end

	if t5.and_condition ~= nil then
		v58.kind = {
			type = "and_condition",
			value = t1.AndCondition.jsonDecode(t5.and_condition)
		}
	end

	if t5.andCondition ~= nil then
		v58.kind = {
			type = "and_condition",
			value = t1.AndCondition.jsonDecode(t5.andCondition)
		}
	end

	if t5.or_condition ~= nil then
		v58.kind = {
			type = "or_condition",
			value = t1.OrCondition.jsonDecode(t5.or_condition)
		}
	end

	if t5.orCondition ~= nil then
		v58.kind = {
			type = "or_condition",
			value = t1.OrCondition.jsonDecode(t5.orCondition)
		}
	end

	if t5.is_empty ~= nil then
		v58.kind = {
			type = "is_empty",
			value = t1.IsEmptyCondition.jsonDecode(t5.is_empty)
		}
	end

	if t5.isEmpty ~= nil then
		v58.kind = {
			type = "is_empty",
			value = t1.IsEmptyCondition.jsonDecode(t5.isEmpty)
		}
	end

	if t5.is_not_empty ~= nil then
		v58.kind = {
			type = "is_not_empty",
			value = t1.IsNotEmptyCondition.jsonDecode(t5.is_not_empty)
		}
	end

	if t5.isNotEmpty ~= nil then
		v58.kind = {
			type = "is_not_empty",
			value = t1.IsNotEmptyCondition.jsonDecode(t5.isNotEmpty)
		}
	end

	return v58
end

t2.descriptor = {
	name = "PropCondition",
	fullName = "roblox.apppageplatform.shared.v1beta1.PropCondition"
}
t1.PropCondition = t2
typeRegistry.default:register(t1.PropCondition)

local t6 = {}

t6.__index = t6

function t6.new(t7: {[any]: any}?) -- line: 447
	-- upvalues: t1 (copy), t6 (copy)
	return (setmetatable({
		field = if t7 ~= nil and t7.field ~= nil then t7.field else "",
		op = if t7 ~= nil and t7.op ~= nil then t7.op else assert(t1.ComparisonCondition_Op.fromNumber(0), "Enum has no 0 default"),
		kind = if t7 ~= nil and t7.kind ~= nil then t7.kind else nil
	}, t6))
end
function t6.encode(p4) -- line: 457
	-- upvalues: proto (copy), t1 (copy)
	local buf = buffer.create(0)
	local n3 = 0

	if p4.field ~= nil and p4.field ~= "" then
		local v63, v64 = proto.writeTag(buf, n3, 1, proto.wireTypes.lengthDelimited)

		buf, n3 = proto.writeString(v63, v64, p4.field)
	end

	if p4.op ~= nil and (p4.op ~= nil and p4.op ~= 0 or p4.op ~= t1.ComparisonCondition_Op.fromNumber(0)) then
		local v65, v66 = proto.writeTag(buf, n3, 2, proto.wireTypes.varint)

		buf, n3 = proto.writeVarInt(v65, v66, t1.ComparisonCondition_Op.toNumber(p4.op))
	end

	if p4.kind ~= nil then
		if p4.kind.type == "string_value" then
			local v67, v68 = proto.writeTag(buf, n3, 3, proto.wireTypes.lengthDelimited)

			buf, n3 = proto.writeString(v67, v68, p4.kind.value)
		elseif p4.kind.type == "bool_value" then
			local v69, v70 = proto.writeTag(buf, n3, 4, proto.wireTypes.varint)

			buf, n3 = proto.writeVarInt(v69, v70, not p4.kind.value and 0 or 1)
		elseif p4.kind.type == "int32_value" then
			local v71, v72 = proto.writeTag(buf, n3, 5, proto.wireTypes.varint)

			buf, n3 = proto.writeVarInt(v71, v72, p4.kind.value)
		elseif p4.kind.type == "int64_value" then
			local v73, v74 = proto.writeTag(buf, n3, 6, proto.wireTypes.varint)

			buf, n3 = proto.writeVarInt(v73, v74, p4.kind.value)
		elseif p4.kind.type == "float_value" then
			local v75, v76 = proto.writeTag(buf, n3, 7, proto.wireTypes.i32)

			buf, n3 = proto.writeFloat(v75, v76, p4.kind.value)
		elseif p4.kind.type == "double_value" then
			local v77, v78 = proto.writeTag(buf, n3, 8, proto.wireTypes.i64)

			buf, n3 = proto.writeDouble(v77, v78, p4.kind.value)
		end
	end

	local buf3 = buffer.create(n3)

	buffer.copy(buf3, 0, buf, 0, n3)

	return buf3
end
function t6.decode(p5: buffer) -- line: 501
	-- upvalues: t6 (copy), proto (copy), t1 (copy)
	local v81 = t6.new()
	local n4 = 0

	while n4 < buffer.len(p5) do
		local v83, v84

		v83, v84, n4 = proto.readTag(p5, n4)

		if v84 == proto.wireTypes.varint then
			if v83 == 2 then
				local v85

				v85, n4 = proto.readVarIntI32(p5, n4)
				v81.op = t1.ComparisonCondition_Op.fromNumber(v85) or v85
			elseif v83 == 4 then
				local v86

				v86, n4 = proto.readVarInt(p5, n4)
				v81.kind = {
					type = "bool_value",
					value = v86 ~= 0
				}
			elseif v83 == 5 then
				local v87

				v87, n4 = proto.readVarIntI32(p5, n4)
				v81.kind = {
					type = "int32_value",
					value = v87
				}
			elseif v83 == 6 then
				local v88

				v88, n4 = proto.readVarIntI64(p5, n4)
				v81.kind = {
					type = "int64_value",
					value = v88
				}
			else
				local v89

				v89, n4 = proto.readVarInt(p5, n4)
			end
		elseif v84 == proto.wireTypes.lengthDelimited then
			if v83 == 1 then
				local v90

				v90, n4 = proto.readBuffer(p5, n4)
				v81.field = buffer.tostring(v90)
			elseif v83 == 3 then
				local v91

				v91, n4 = proto.readBuffer(p5, n4)
				v81.kind = {
					type = "string_value",
					value = buffer.tostring(v91)
				}
			else
				local v92, v93 = proto.readVarInt(p5, n4)

				n4 = v93 + v92
			end
		elseif v84 == proto.wireTypes.i32 then
			if v83 == 7 then
				local v94

				v94, n4 = proto.readFloat(p5, n4)
				v81.kind = {
					type = "float_value",
					value = v94
				}
			else
				local v95

				v95, n4 = proto.readFixed32(p5, n4)
			end
		elseif v84 == proto.wireTypes.i64 then
			if v83 == 8 then
				local v96

				v96, n4 = proto.readDouble(p5, n4)
				v81.kind = {
					type = "double_value",
					value = v96
				}
			else
				local v97

				v97, n4 = proto.readFixed64(p5, n4)
			end
		else
			error("Unsupported wire type: " .. v84)
		end
	end

	return v81
end
function t6.jsonEncode(p6) -- line: 579
	-- upvalues: t1 (copy), proto (copy)
	local t8 = {}

	if p6.field ~= nil and p6.field ~= "" then
		t8.field = p6.field
	end

	if p6.op ~= nil and (p6.op ~= nil and p6.op ~= 0 or p6.op ~= t1.ComparisonCondition_Op.fromNumber(0)) then
		t8.op = if typeof(p6.op) ~= "number" then t1.ComparisonCondition_Op.toNumber(p6.op) else p6.op
	end

	if p6.kind ~= nil then
		if p6.kind.type == "string_value" then
			t8.stringValue = p6.kind.value

			return t8
		end

		if p6.kind.type == "bool_value" then
			t8.boolValue = p6.kind.value

			return t8
		end

		if p6.kind.type == "int32_value" then
			t8.int32Value = p6.kind.value

			return t8
		end

		if p6.kind.type == "int64_value" then
			t8.int64Value = p6.kind.value

			return t8
		end

		if p6.kind.type == "float_value" then
			t8.floatValue = proto.json.serializeNumber(p6.kind.value)

			return t8
		end

		if p6.kind.type == "double_value" then
			t8.doubleValue = proto.json.serializeNumber(p6.kind.value)
		end
	end

	return t8
end
function t6.jsonDecode(t9: {[any]: any}) -- line: 614
	-- upvalues: t6 (copy), t1 (copy), proto (copy)
	local v101 = t6.new()

	if t9.field ~= nil then
		v101.field = t9.field
	end

	if t9.op ~= nil then
		v101.op = if typeof(t9.op) ~= "number" then t1.ComparisonCondition_Op.fromName(t9.op) or t9.op else t1.ComparisonCondition_Op.fromNumber(t9.op) or t9.op
	end

	if t9.string_value ~= nil then
		v101.kind = {
			type = "string_value",
			value = t9.string_value
		}
	end

	if t9.stringValue ~= nil then
		v101.kind = {
			type = "string_value",
			value = t9.stringValue
		}
	end

	if t9.bool_value ~= nil then
		v101.kind = {
			type = "bool_value",
			value = t9.bool_value
		}
	end

	if t9.boolValue ~= nil then
		v101.kind = {
			type = "bool_value",
			value = t9.boolValue
		}
	end

	if t9.int32_value ~= nil then
		v101.kind = {
			type = "int32_value",
			value = t9.int32_value
		}
	end

	if t9.int32Value ~= nil then
		v101.kind = {
			type = "int32_value",
			value = t9.int32Value
		}
	end

	if t9.int64_value ~= nil then
		v101.kind = {
			type = "int64_value",
			value = t9.int64_value
		}
	end

	if t9.int64Value ~= nil then
		v101.kind = {
			type = "int64_value",
			value = t9.int64Value
		}
	end

	if t9.float_value ~= nil then
		v101.kind = {
			type = "float_value",
			value = proto.json.deserializeNumber(t9.float_value)
		}
	end

	if t9.floatValue ~= nil then
		v101.kind = {
			type = "float_value",
			value = proto.json.deserializeNumber(t9.floatValue)
		}
	end

	if t9.double_value ~= nil then
		v101.kind = {
			type = "double_value",
			value = proto.json.deserializeNumber(t9.double_value)
		}
	end

	if t9.doubleValue ~= nil then
		v101.kind = {
			type = "double_value",
			value = proto.json.deserializeNumber(t9.doubleValue)
		}
	end

	return v101
end

t6.descriptor = {
	name = "ComparisonCondition",
	fullName = "roblox.apppageplatform.shared.v1beta1.ComparisonCondition"
}
t1.ComparisonCondition = t6
typeRegistry.default:register(t1.ComparisonCondition)
t1.ComparisonCondition_Op = {
	fromNumber = function(n5: number) -- line: 689
		if n5 == 0 then
			return "OP_INVALID"
		end

		if n5 == 1 then
			return "OP_LT"
		end

		if n5 == 2 then
			return "OP_LTE"
		end

		if n5 == 3 then
			return "OP_GT"
		end

		if n5 == 4 then
			return "OP_GTE"
		end

		if n5 == 5 then
			return "OP_E"
		end

		if n5 == 6 then
			return "OP_NE"
		end

		return nil
	end,
	toNumber = function(p7) -- line: 709
		if p7 == "OP_INVALID" then
			return 0
		end

		if p7 == "OP_LT" then
			return 1
		end

		if p7 == "OP_LTE" then
			return 2
		end

		if p7 == "OP_GT" then
			return 3
		end

		if p7 == "OP_GTE" then
			return 4
		end

		if p7 == "OP_E" then
			return 5
		end

		if p7 == "OP_NE" then
			return 6
		end

		return p7
	end,
	fromName = function(s1: string) -- line: 729
		if s1 == "OP_INVALID" then
			return "OP_INVALID"
		end

		if s1 == "OP_LT" then
			return "OP_LT"
		end

		if s1 == "OP_LTE" then
			return "OP_LTE"
		end

		if s1 == "OP_GT" then
			return "OP_GT"
		end

		if s1 == "OP_GTE" then
			return "OP_GTE"
		end

		if s1 == "OP_E" then
			return "OP_E"
		end

		if s1 == "OP_NE" then
			return "OP_NE"
		end

		return nil
	end
}

local t10 = {}

t10.__index = t10

function t10.new(t11: {[any]: any}?) -- line: 754
	-- upvalues: t10 (copy)
	return (setmetatable({
		field = if t11 ~= nil and t11.field ~= nil then t11.field else ""
	}, t10))
end
function t10.encode(p8) -- line: 760
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n6 = 0

	if p8.field ~= nil and p8.field ~= "" then
		local v109, v110 = proto.writeTag(buf, n6, 1, proto.wireTypes.lengthDelimited)

		buf, n6 = proto.writeString(v109, v110, p8.field)
	end

	local buf4 = buffer.create(n6)

	buffer.copy(buf4, 0, buf, 0, n6)

	return buf4
end
function t10.decode(p9: buffer) -- line: 774
	-- upvalues: t10 (copy), proto (copy)
	local v113 = t10.new()
	local n7 = 0

	while n7 < buffer.len(p9) do
		local v115, v116

		v115, v116, n7 = proto.readTag(p9, n7)

		if v116 == proto.wireTypes.varint then
			local v117

			v117, n7 = proto.readVarInt(p9, n7)
		elseif v116 == proto.wireTypes.lengthDelimited then
			if v115 == 1 then
				local v118

				v118, n7 = proto.readBuffer(p9, n7)
				v113.field = buffer.tostring(v118)
			else
				local v119, v120 = proto.readVarInt(p9, n7)

				n7 = v120 + v119
			end
		elseif v116 == proto.wireTypes.i32 then
			local v121

			v121, n7 = proto.readFixed32(p9, n7)
		elseif v116 == proto.wireTypes.i64 then
			local v122

			v122, n7 = proto.readFixed64(p9, n7)
		else
			error("Unsupported wire type: " .. v116)
		end
	end

	return v113
end
function t10.jsonEncode(p10) -- line: 817
	local t12 = {}

	if p10.field ~= nil and p10.field ~= "" then
		t12.field = p10.field
	end

	return t12
end
function t10.jsonDecode(t13: {[any]: any}) -- line: 827
	-- upvalues: t10 (copy)
	local v126 = t10.new()

	if t13.field ~= nil then
		v126.field = t13.field
	end

	return v126
end

t10.descriptor = {
	name = "IsNullCondition",
	fullName = "roblox.apppageplatform.shared.v1beta1.IsNullCondition"
}
t1.IsNullCondition = t10
typeRegistry.default:register(t1.IsNullCondition)

local t14 = {}

t14.__index = t14

function t14.new(t15: {[any]: any}?) -- line: 851
	-- upvalues: t14 (copy)
	return (setmetatable({
		field = if t15 ~= nil and t15.field ~= nil then t15.field else ""
	}, t14))
end
function t14.encode(p11) -- line: 857
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n8 = 0

	if p11.field ~= nil and p11.field ~= "" then
		local v131, v132 = proto.writeTag(buf, n8, 1, proto.wireTypes.lengthDelimited)

		buf, n8 = proto.writeString(v131, v132, p11.field)
	end

	local buf5 = buffer.create(n8)

	buffer.copy(buf5, 0, buf, 0, n8)

	return buf5
end
function t14.decode(p12: buffer) -- line: 871
	-- upvalues: t14 (copy), proto (copy)
	local v135 = t14.new()
	local n9 = 0

	while n9 < buffer.len(p12) do
		local v137, v138

		v137, v138, n9 = proto.readTag(p12, n9)

		if v138 == proto.wireTypes.varint then
			local v139

			v139, n9 = proto.readVarInt(p12, n9)
		elseif v138 == proto.wireTypes.lengthDelimited then
			if v137 == 1 then
				local v140

				v140, n9 = proto.readBuffer(p12, n9)
				v135.field = buffer.tostring(v140)
			else
				local v141, v142 = proto.readVarInt(p12, n9)

				n9 = v142 + v141
			end
		elseif v138 == proto.wireTypes.i32 then
			local v143

			v143, n9 = proto.readFixed32(p12, n9)
		elseif v138 == proto.wireTypes.i64 then
			local v144

			v144, n9 = proto.readFixed64(p12, n9)
		else
			error("Unsupported wire type: " .. v138)
		end
	end

	return v135
end
function t14.jsonEncode(p13) -- line: 914
	local t16 = {}

	if p13.field ~= nil and p13.field ~= "" then
		t16.field = p13.field
	end

	return t16
end
function t14.jsonDecode(t17: {[any]: any}) -- line: 924
	-- upvalues: t14 (copy)
	local v148 = t14.new()

	if t17.field ~= nil then
		v148.field = t17.field
	end

	return v148
end

t14.descriptor = {
	name = "IsNotNullCondition",
	fullName = "roblox.apppageplatform.shared.v1beta1.IsNotNullCondition"
}
t1.IsNotNullCondition = t14
typeRegistry.default:register(t1.IsNotNullCondition)

local t18 = {}

t18.__index = t18

function t18.new(t19: {[any]: any}?) -- line: 948
	-- upvalues: t18 (copy)
	return (setmetatable({
		field = if t19 ~= nil and t19.field ~= nil then t19.field else ""
	}, t18))
end
function t18.encode(p14) -- line: 954
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n10 = 0

	if p14.field ~= nil and p14.field ~= "" then
		local v153, v154 = proto.writeTag(buf, n10, 1, proto.wireTypes.lengthDelimited)

		buf, n10 = proto.writeString(v153, v154, p14.field)
	end

	local buf6 = buffer.create(n10)

	buffer.copy(buf6, 0, buf, 0, n10)

	return buf6
end
function t18.decode(p15: buffer) -- line: 968
	-- upvalues: t18 (copy), proto (copy)
	local v157 = t18.new()
	local n11 = 0

	while n11 < buffer.len(p15) do
		local v159, v160

		v159, v160, n11 = proto.readTag(p15, n11)

		if v160 == proto.wireTypes.varint then
			local v161

			v161, n11 = proto.readVarInt(p15, n11)
		elseif v160 == proto.wireTypes.lengthDelimited then
			if v159 == 1 then
				local v162

				v162, n11 = proto.readBuffer(p15, n11)
				v157.field = buffer.tostring(v162)
			else
				local v163, v164 = proto.readVarInt(p15, n11)

				n11 = v164 + v163
			end
		elseif v160 == proto.wireTypes.i32 then
			local v165

			v165, n11 = proto.readFixed32(p15, n11)
		elseif v160 == proto.wireTypes.i64 then
			local v166

			v166, n11 = proto.readFixed64(p15, n11)
		else
			error("Unsupported wire type: " .. v160)
		end
	end

	return v157
end
function t18.jsonEncode(p16) -- line: 1011
	local t20 = {}

	if p16.field ~= nil and p16.field ~= "" then
		t20.field = p16.field
	end

	return t20
end
function t18.jsonDecode(t21: {[any]: any}) -- line: 1021
	-- upvalues: t18 (copy)
	local v170 = t18.new()

	if t21.field ~= nil then
		v170.field = t21.field
	end

	return v170
end

t18.descriptor = {
	name = "IsEmptyCondition",
	fullName = "roblox.apppageplatform.shared.v1beta1.IsEmptyCondition"
}
t1.IsEmptyCondition = t18
typeRegistry.default:register(t1.IsEmptyCondition)

local t22 = {}

t22.__index = t22

function t22.new(t23: {[any]: any}?) -- line: 1045
	-- upvalues: t22 (copy)
	return (setmetatable({
		field = if t23 ~= nil and t23.field ~= nil then t23.field else ""
	}, t22))
end
function t22.encode(p17) -- line: 1051
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n12 = 0

	if p17.field ~= nil and p17.field ~= "" then
		local v175, v176 = proto.writeTag(buf, n12, 1, proto.wireTypes.lengthDelimited)

		buf, n12 = proto.writeString(v175, v176, p17.field)
	end

	local buf7 = buffer.create(n12)

	buffer.copy(buf7, 0, buf, 0, n12)

	return buf7
end
function t22.decode(p18: buffer) -- line: 1065
	-- upvalues: t22 (copy), proto (copy)
	local v179 = t22.new()
	local n13 = 0

	while n13 < buffer.len(p18) do
		local v181, v182

		v181, v182, n13 = proto.readTag(p18, n13)

		if v182 == proto.wireTypes.varint then
			local v183

			v183, n13 = proto.readVarInt(p18, n13)
		elseif v182 == proto.wireTypes.lengthDelimited then
			if v181 == 1 then
				local v184

				v184, n13 = proto.readBuffer(p18, n13)
				v179.field = buffer.tostring(v184)
			else
				local v185, v186 = proto.readVarInt(p18, n13)

				n13 = v186 + v185
			end
		elseif v182 == proto.wireTypes.i32 then
			local v187

			v187, n13 = proto.readFixed32(p18, n13)
		elseif v182 == proto.wireTypes.i64 then
			local v188

			v188, n13 = proto.readFixed64(p18, n13)
		else
			error("Unsupported wire type: " .. v182)
		end
	end

	return v179
end
function t22.jsonEncode(p19) -- line: 1108
	local t24 = {}

	if p19.field ~= nil and p19.field ~= "" then
		t24.field = p19.field
	end

	return t24
end
function t22.jsonDecode(t25: {[any]: any}) -- line: 1118
	-- upvalues: t22 (copy)
	local v192 = t22.new()

	if t25.field ~= nil then
		v192.field = t25.field
	end

	return v192
end

t22.descriptor = {
	name = "IsNotEmptyCondition",
	fullName = "roblox.apppageplatform.shared.v1beta1.IsNotEmptyCondition"
}
t1.IsNotEmptyCondition = t22
typeRegistry.default:register(t1.IsNotEmptyCondition)

local t26 = {}

t26.__index = t26

function t26.new(t27: {[any]: any}?) -- line: 1142
	-- upvalues: t26 (copy)
	return (setmetatable({
		conditions = if t27 ~= nil and t27.conditions ~= nil then t27.conditions else {}
	}, t26))
end
function t26.encode(p20) -- line: 1148
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n14 = 0

	if p20.conditions ~= nil and #p20.conditions > 0 then
		for _, v198 in p20.conditions do
			local v199 = v198:encode()
			local v200, v201 = proto.writeTag(buf, n14, 1, proto.wireTypes.lengthDelimited)

			buf, n14 = proto.writeBuffer(v200, v201, v199, buffer.len(v199))
		end
	end

	local buf8 = buffer.create(n14)

	buffer.copy(buf8, 0, buf, 0, n14)

	return buf8
end
function t26.decode(p21: buffer) -- line: 1165
	-- upvalues: t26 (copy), proto (copy), t1 (copy)
	local v204 = t26.new()
	local n15 = 0

	while n15 < buffer.len(p21) do
		local v206, v207

		v206, v207, n15 = proto.readTag(p21, n15)

		if v207 == proto.wireTypes.varint then
			local v208

			v208, n15 = proto.readVarInt(p21, n15)
		elseif v207 == proto.wireTypes.lengthDelimited then
			if v206 == 1 then
				local v209

				v209, n15 = proto.readBuffer(p21, n15)
				table.insert(v204.conditions, t1.PropCondition.decode(v209))
			else
				local v210, v211 = proto.readVarInt(p21, n15)

				n15 = v211 + v210
			end
		elseif v207 == proto.wireTypes.i32 then
			local v212

			v212, n15 = proto.readFixed32(p21, n15)
		elseif v207 == proto.wireTypes.i64 then
			local v213

			v213, n15 = proto.readFixed64(p21, n15)
		else
			error("Unsupported wire type: " .. v207)
		end
	end

	return v204
end
function t26.jsonEncode(p22) -- line: 1208
	local t28 = {}

	if p22.conditions ~= nil and #p22.conditions > 0 then
		local t29 = {}

		for _, v218 in p22.conditions do
			table.insert(t29, v218:jsonEncode())
		end

		t28.conditions = t29
	end

	return t28
end
function t26.jsonDecode(t30: {[any]: any}) -- line: 1222
	-- upvalues: t26 (copy), t1 (copy)
	local v220 = t26.new()

	if t30.conditions ~= nil then
		local t31 = {}

		for _, v223 in t30.conditions do
			table.insert(t31, t1.PropCondition.jsonDecode(v223))
		end

		v220.conditions = t31
	end

	return v220
end

t26.descriptor = {
	name = "AndCondition",
	fullName = "roblox.apppageplatform.shared.v1beta1.AndCondition"
}
t1.AndCondition = t26
typeRegistry.default:register(t1.AndCondition)

local t32 = {}

t32.__index = t32

function t32.new(t33: {[any]: any}?) -- line: 1251
	-- upvalues: t32 (copy)
	return (setmetatable({
		conditions = if t33 ~= nil and t33.conditions ~= nil then t33.conditions else {}
	}, t32))
end
function t32.encode(p23) -- line: 1257
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n16 = 0

	if p23.conditions ~= nil and #p23.conditions > 0 then
		for _, v229 in p23.conditions do
			local v230 = v229:encode()
			local v231, v232 = proto.writeTag(buf, n16, 1, proto.wireTypes.lengthDelimited)

			buf, n16 = proto.writeBuffer(v231, v232, v230, buffer.len(v230))
		end
	end

	local buf9 = buffer.create(n16)

	buffer.copy(buf9, 0, buf, 0, n16)

	return buf9
end
function t32.decode(p24: buffer) -- line: 1274
	-- upvalues: t32 (copy), proto (copy), t1 (copy)
	local v235 = t32.new()
	local n17 = 0

	while n17 < buffer.len(p24) do
		local v237, v238

		v237, v238, n17 = proto.readTag(p24, n17)

		if v238 == proto.wireTypes.varint then
			local v239

			v239, n17 = proto.readVarInt(p24, n17)
		elseif v238 == proto.wireTypes.lengthDelimited then
			if v237 == 1 then
				local v240

				v240, n17 = proto.readBuffer(p24, n17)
				table.insert(v235.conditions, t1.PropCondition.decode(v240))
			else
				local v241, v242 = proto.readVarInt(p24, n17)

				n17 = v242 + v241
			end
		elseif v238 == proto.wireTypes.i32 then
			local v243

			v243, n17 = proto.readFixed32(p24, n17)
		elseif v238 == proto.wireTypes.i64 then
			local v244

			v244, n17 = proto.readFixed64(p24, n17)
		else
			error("Unsupported wire type: " .. v238)
		end
	end

	return v235
end
function t32.jsonEncode(p25) -- line: 1317
	local t34 = {}

	if p25.conditions ~= nil and #p25.conditions > 0 then
		local t35 = {}

		for _, v249 in p25.conditions do
			table.insert(t35, v249:jsonEncode())
		end

		t34.conditions = t35
	end

	return t34
end
function t32.jsonDecode(t36: {[any]: any}) -- line: 1331
	-- upvalues: t32 (copy), t1 (copy)
	local v251 = t32.new()

	if t36.conditions ~= nil then
		local t37 = {}

		for _, v254 in t36.conditions do
			table.insert(t37, t1.PropCondition.jsonDecode(v254))
		end

		v251.conditions = t37
	end

	return v251
end

t32.descriptor = {
	name = "OrCondition",
	fullName = "roblox.apppageplatform.shared.v1beta1.OrCondition"
}
t1.OrCondition = t32
typeRegistry.default:register(t1.OrCondition)

return {
	PropCondition = t1.PropCondition,
	ComparisonCondition = t1.ComparisonCondition,
	ComparisonCondition_Op = t1.ComparisonCondition_Op,
	IsNullCondition = t1.IsNullCondition,
	IsNotNullCondition = t1.IsNotNullCondition,
	IsEmptyCondition = t1.IsEmptyCondition,
	IsNotEmptyCondition = t1.IsNotEmptyCondition,
	AndCondition = t1.AndCondition,
	OrCondition = t1.OrCondition
}
