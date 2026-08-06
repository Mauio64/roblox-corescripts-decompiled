local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local hydration_content_type = require(script.Parent.hydration_content_type)
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 75
	-- upvalues: hydration_content_type (copy), t2 (copy)
	return (setmetatable({
		content_type = if t3 ~= nil and t3.content_type ~= nil then t3.content_type else assert(hydration_content_type.HydrationContentType.fromNumber(0), "Enum has no 0 default"),
		id_binding = if t3 ~= nil and t3.id_binding ~= nil then t3.id_binding else nil,
		alias = if t3 ~= nil and t3.alias ~= nil then t3.alias else "",
		client_fetch = t3 ~= nil and (t3.client_fetch ~= nil and t3.client_fetch),
		required_fields = if t3 ~= nil and t3.required_fields ~= nil then t3.required_fields else {},
		required = t3 ~= nil and (t3.required ~= nil and t3.required),
		client_hints = if t3 ~= nil and t3.client_hints ~= nil then t3.client_hints else {}
	}, t2))
end
function t2.encode(p1) -- line: 92
	-- upvalues: hydration_content_type (copy), proto (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.content_type ~= nil and (p1.content_type ~= nil and p1.content_type ~= 0 or p1.content_type ~= hydration_content_type.HydrationContentType.fromNumber(0)) then
		local v11, v12 = proto.writeTag(buf, n1, 1, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v11, v12, hydration_content_type.HydrationContentType.toNumber(p1.content_type))
	end

	if p1.id_binding ~= nil then
		local v13 = p1.id_binding:encode()
		local v14, v15 = proto.writeTag(buf, n1, 2, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeBuffer(v14, v15, v13, buffer.len(v13))
	end

	if p1.alias ~= nil and p1.alias ~= "" then
		local v16, v17 = proto.writeTag(buf, n1, 3, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v16, v17, p1.alias)
	end

	if p1.client_fetch then
		local v18, v19 = proto.writeTag(buf, n1, 4, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v18, v19, not p1.client_fetch and 0 or 1)
	end

	if p1.required_fields ~= nil and #p1.required_fields > 0 then
		for _, v21 in p1.required_fields do
			local v22, v23 = proto.writeTag(buf, n1, 5, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeString(v22, v23, v21)
		end
	end

	if p1.required then
		local v24, v25 = proto.writeTag(buf, n1, 6, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v24, v25, not p1.required and 0 or 1)
	end

	if p1.client_hints ~= nil and #p1.client_hints > 0 then
		for _, v27 in p1.client_hints do
			local v28, v29 = proto.writeTag(buf, n1, 7, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeString(v28, v29, v27)
		end
	end

	local buf2 = buffer.create(n1)

	buffer.copy(buf2, 0, buf, 0, n1)

	return buf2
end
function t2.decode(p2: buffer) -- line: 154
	-- upvalues: t2 (copy), proto (copy), hydration_content_type (copy), t1 (copy)
	local v32 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v34, v35

		v34, v35, n2 = proto.readTag(p2, n2)

		if v35 == proto.wireTypes.varint then
			if v34 == 1 then
				local v36

				v36, n2 = proto.readVarIntI32(p2, n2)
				v32.content_type = hydration_content_type.HydrationContentType.fromNumber(v36) or v36
			elseif v34 == 4 then
				local v37

				v37, n2 = proto.readVarInt(p2, n2)
				v32.client_fetch = v37 ~= 0
			elseif v34 == 6 then
				local v38

				v38, n2 = proto.readVarInt(p2, n2)
				v32.required = v38 ~= 0
			else
				local v39

				v39, n2 = proto.readVarInt(p2, n2)
			end
		elseif v35 == proto.wireTypes.lengthDelimited then
			if v34 == 2 then
				local v40

				v40, n2 = proto.readBuffer(p2, n2)
				v32.id_binding = t1.IdBinding.decode(v40)
			elseif v34 == 3 then
				local v41

				v41, n2 = proto.readBuffer(p2, n2)
				v32.alias = buffer.tostring(v41)
			elseif v34 == 5 then
				local v42

				v42, n2 = proto.readBuffer(p2, n2)
				table.insert(v32.required_fields, buffer.tostring(v42))
			elseif v34 == 7 then
				local v43

				v43, n2 = proto.readBuffer(p2, n2)
				table.insert(v32.client_hints, buffer.tostring(v43))
			else
				local v44, v45 = proto.readVarInt(p2, n2)

				n2 = v45 + v44
			end
		elseif v35 == proto.wireTypes.i32 then
			local v46

			v46, n2 = proto.readFixed32(p2, n2)
		elseif v35 == proto.wireTypes.i64 then
			local v47

			v47, n2 = proto.readFixed64(p2, n2)
		else
			error("Unsupported wire type: " .. v35)
		end
	end

	return v32
end
function t2.jsonEncode(p3) -- line: 231
	-- upvalues: hydration_content_type (copy)
	local t4 = {}

	if p3.content_type ~= nil and (p3.content_type ~= nil and p3.content_type ~= 0 or p3.content_type ~= hydration_content_type.HydrationContentType.fromNumber(0)) then
		t4.contentType = if typeof(p3.content_type) ~= "number" then hydration_content_type.HydrationContentType.toNumber(p3.content_type) else p3.content_type
	end

	if p3.id_binding ~= nil then
		t4.idBinding = p3.id_binding:jsonEncode()
	end

	if p3.alias ~= nil and p3.alias ~= "" then
		t4.alias = p3.alias
	end

	if p3.client_fetch then
		t4.clientFetch = p3.client_fetch
	end

	if p3.required_fields ~= nil and #p3.required_fields > 0 then
		local t5 = {}

		for _, v52 in p3.required_fields do
			table.insert(t5, v52)
		end

		t4.requiredFields = t5
	end

	if p3.required then
		t4.required = p3.required
	end

	if p3.client_hints ~= nil and #p3.client_hints > 0 then
		local t6 = {}

		for _, v55 in p3.client_hints do
			table.insert(t6, v55)
		end

		t4.clientHints = t6
	end

	return t4
end
function t2.jsonDecode(t7: {[any]: any}) -- line: 284
	-- upvalues: t2 (copy), hydration_content_type (copy), t1 (copy)
	local v57 = t2.new()

	if t7.content_type ~= nil then
		v57.content_type = if typeof(t7.content_type) ~= "number" then hydration_content_type.HydrationContentType.fromName(t7.content_type) or t7.content_type else hydration_content_type.HydrationContentType.fromNumber(t7.content_type) or t7.content_type
	end

	if t7.contentType ~= nil then
		v57.content_type = if typeof(t7.contentType) ~= "number" then hydration_content_type.HydrationContentType.fromName(t7.contentType) or t7.contentType else hydration_content_type.HydrationContentType.fromNumber(t7.contentType) or t7.contentType
	end

	if t7.id_binding ~= nil then
		v57.id_binding = t1.IdBinding.jsonDecode(t7.id_binding)
	end

	if t7.idBinding ~= nil then
		v57.id_binding = t1.IdBinding.jsonDecode(t7.idBinding)
	end

	if t7.alias ~= nil then
		v57.alias = t7.alias
	end

	if t7.client_fetch ~= nil then
		v57.client_fetch = t7.client_fetch
	end

	if t7.clientFetch ~= nil then
		v57.client_fetch = t7.clientFetch
	end

	if t7.required_fields ~= nil then
		local t8 = {}

		for _, v60 in t7.required_fields do
			table.insert(t8, v60)
		end

		v57.required_fields = t8
	end

	if t7.requiredFields ~= nil then
		local t9 = {}

		for _, v63 in t7.requiredFields do
			table.insert(t9, v63)
		end

		v57.required_fields = t9
	end

	if t7.required ~= nil then
		v57.required = t7.required
	end

	if t7.client_hints ~= nil then
		local t10 = {}

		for _, v66 in t7.client_hints do
			table.insert(t10, v66)
		end

		v57.client_hints = t10
	end

	if t7.clientHints ~= nil then
		local t11 = {}

		for _, v69 in t7.clientHints do
			table.insert(t11, v69)
		end

		v57.client_hints = t11
	end

	return v57
end

t2.descriptor = {
	name = "HydrationDataSpec",
	fullName = "roblox.apppageplatform.shared.v1beta1.HydrationDataSpec"
}
t1.HydrationDataSpec = t2
typeRegistry.default:register(t1.HydrationDataSpec)

local t12 = {}

t12.__index = t12

function t12.new(t13: {[any]: any}?) -- line: 384
	-- upvalues: t12 (copy)
	return (setmetatable({
		kind = if t13 ~= nil and t13.kind ~= nil then t13.kind else nil
	}, t12))
end
function t12.encode(p4) -- line: 390
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n3 = 0

	if p4.kind ~= nil then
		if p4.kind.type == "literal" then
			local v74, v75 = proto.writeTag(buf, n3, 1, proto.wireTypes.lengthDelimited)

			buf, n3 = proto.writeString(v74, v75, p4.kind.value)
		elseif p4.kind.type == "input_path" then
			local v76, v77 = proto.writeTag(buf, n3, 2, proto.wireTypes.lengthDelimited)

			buf, n3 = proto.writeString(v76, v77, p4.kind.value)
		end
	end

	local buf3 = buffer.create(n3)

	buffer.copy(buf3, 0, buf, 0, n3)

	return buf3
end
function t12.decode(p5: buffer) -- line: 409
	-- upvalues: t12 (copy), proto (copy)
	local v80 = t12.new()
	local n4 = 0

	while n4 < buffer.len(p5) do
		local v82, v83

		v82, v83, n4 = proto.readTag(p5, n4)

		if v83 == proto.wireTypes.varint then
			local v84

			v84, n4 = proto.readVarInt(p5, n4)
		elseif v83 == proto.wireTypes.lengthDelimited then
			if v82 == 1 then
				local v85

				v85, n4 = proto.readBuffer(p5, n4)
				v80.kind = {
					type = "literal",
					value = buffer.tostring(v85)
				}
			elseif v82 == 2 then
				local v86

				v86, n4 = proto.readBuffer(p5, n4)
				v80.kind = {
					type = "input_path",
					value = buffer.tostring(v86)
				}
			else
				local v87, v88 = proto.readVarInt(p5, n4)

				n4 = v88 + v87
			end
		elseif v83 == proto.wireTypes.i32 then
			local v89

			v89, n4 = proto.readFixed32(p5, n4)
		elseif v83 == proto.wireTypes.i64 then
			local v90

			v90, n4 = proto.readFixed64(p5, n4)
		else
			error("Unsupported wire type: " .. v83)
		end
	end

	return v80
end
function t12.jsonEncode(p6) -- line: 457
	local t14 = {}

	if p6.kind ~= nil then
		if p6.kind.type == "literal" then
			t14.literal = p6.kind.value

			return t14
		end

		if p6.kind.type == "input_path" then
			t14.inputPath = p6.kind.value
		end
	end

	return t14
end
function t12.jsonDecode(t15: {[any]: any}) -- line: 471
	-- upvalues: t12 (copy)
	local v94 = t12.new()

	if t15.literal ~= nil then
		v94.kind = {
			type = "literal",
			value = t15.literal
		}
	end

	if t15.input_path ~= nil then
		v94.kind = {
			type = "input_path",
			value = t15.input_path
		}
	end

	if t15.inputPath ~= nil then
		v94.kind = {
			type = "input_path",
			value = t15.inputPath
		}
	end

	return v94
end

t12.descriptor = {
	name = "IdBinding",
	fullName = "roblox.apppageplatform.shared.v1beta1.IdBinding"
}
t1.IdBinding = t12
typeRegistry.default:register(t1.IdBinding)

return {
	HydrationDataSpec = t1.HydrationDataSpec,
	IdBinding = t1.IdBinding
}
