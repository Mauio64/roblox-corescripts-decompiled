local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local hydration_content_type = require(script.Parent.hydration_content_type)
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 73
	-- upvalues: hydration_content_type (copy), t2 (copy)
	return (setmetatable({
		content_type = if t3 ~= nil and t3.content_type ~= nil then t3.content_type else assert(hydration_content_type.HydrationContentType.fromNumber(0), "Enum has no 0 default"),
		id_binding = if t3 ~= nil and t3.id_binding ~= nil then t3.id_binding else nil,
		alias = if t3 ~= nil and t3.alias ~= nil then t3.alias else "",
		client_fetch = t3 ~= nil and (t3.client_fetch ~= nil and t3.client_fetch),
		required_fields = if t3 ~= nil and t3.required_fields ~= nil then t3.required_fields else {},
		required = t3 ~= nil and (t3.required ~= nil and t3.required)
	}, t2))
end
function t2.encode(p1) -- line: 89
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

	local buf2 = buffer.create(n1)

	buffer.copy(buf2, 0, buf, 0, n1)

	return buf2
end
function t2.decode(p2: buffer) -- line: 144
	-- upvalues: t2 (copy), proto (copy), hydration_content_type (copy), t1 (copy)
	local v28 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v30, v31

		v30, v31, n2 = proto.readTag(p2, n2)

		if v31 == proto.wireTypes.varint then
			if v30 == 1 then
				local v32

				v32, n2 = proto.readVarIntI32(p2, n2)
				v28.content_type = hydration_content_type.HydrationContentType.fromNumber(v32) or v32
			elseif v30 == 4 then
				local v33

				v33, n2 = proto.readVarInt(p2, n2)
				v28.client_fetch = v33 ~= 0
			elseif v30 == 6 then
				local v34

				v34, n2 = proto.readVarInt(p2, n2)
				v28.required = v34 ~= 0
			else
				local v35

				v35, n2 = proto.readVarInt(p2, n2)
			end
		elseif v31 == proto.wireTypes.lengthDelimited then
			if v30 == 2 then
				local v36

				v36, n2 = proto.readBuffer(p2, n2)
				v28.id_binding = t1.IdBinding.decode(v36)
			elseif v30 == 3 then
				local v37

				v37, n2 = proto.readBuffer(p2, n2)
				v28.alias = buffer.tostring(v37)
			elseif v30 == 5 then
				local v38

				v38, n2 = proto.readBuffer(p2, n2)
				table.insert(v28.required_fields, buffer.tostring(v38))
			else
				local v39, v40 = proto.readVarInt(p2, n2)

				n2 = v40 + v39
			end
		elseif v31 == proto.wireTypes.i32 then
			local v41

			v41, n2 = proto.readFixed32(p2, n2)
		elseif v31 == proto.wireTypes.i64 then
			local v42

			v42, n2 = proto.readFixed64(p2, n2)
		else
			error("Unsupported wire type: " .. v31)
		end
	end

	return v28
end
function t2.jsonEncode(p3) -- line: 216
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

		for _, v47 in p3.required_fields do
			table.insert(t5, v47)
		end

		t4.requiredFields = t5
	end

	if p3.required then
		t4.required = p3.required
	end

	return t4
end
function t2.jsonDecode(t6: {[any]: any}) -- line: 261
	-- upvalues: t2 (copy), hydration_content_type (copy), t1 (copy)
	local v49 = t2.new()

	if t6.content_type ~= nil then
		v49.content_type = if typeof(t6.content_type) ~= "number" then hydration_content_type.HydrationContentType.fromName(t6.content_type) or t6.content_type else hydration_content_type.HydrationContentType.fromNumber(t6.content_type) or t6.content_type
	end

	if t6.contentType ~= nil then
		v49.content_type = if typeof(t6.contentType) ~= "number" then hydration_content_type.HydrationContentType.fromName(t6.contentType) or t6.contentType else hydration_content_type.HydrationContentType.fromNumber(t6.contentType) or t6.contentType
	end

	if t6.id_binding ~= nil then
		v49.id_binding = t1.IdBinding.jsonDecode(t6.id_binding)
	end

	if t6.idBinding ~= nil then
		v49.id_binding = t1.IdBinding.jsonDecode(t6.idBinding)
	end

	if t6.alias ~= nil then
		v49.alias = t6.alias
	end

	if t6.client_fetch ~= nil then
		v49.client_fetch = t6.client_fetch
	end

	if t6.clientFetch ~= nil then
		v49.client_fetch = t6.clientFetch
	end

	if t6.required_fields ~= nil then
		local t7 = {}

		for _, v52 in t6.required_fields do
			table.insert(t7, v52)
		end

		v49.required_fields = t7
	end

	if t6.requiredFields ~= nil then
		local t8 = {}

		for _, v55 in t6.requiredFields do
			table.insert(t8, v55)
		end

		v49.required_fields = t8
	end

	if t6.required ~= nil then
		v49.required = t6.required
	end

	return v49
end

t2.descriptor = {
	name = "HydrationDataSpec",
	fullName = "roblox.apppageplatform.shared.v1beta1.HydrationDataSpec"
}
t1.HydrationDataSpec = t2
typeRegistry.default:register(t1.HydrationDataSpec)

local t9 = {}

t9.__index = t9

function t9.new(t10: {[any]: any}?) -- line: 343
	-- upvalues: t9 (copy)
	return (setmetatable({
		kind = if t10 ~= nil and t10.kind ~= nil then t10.kind else nil
	}, t9))
end
function t9.encode(p4) -- line: 349
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n3 = 0

	if p4.kind ~= nil then
		if p4.kind.type == "literal" then
			local v60, v61 = proto.writeTag(buf, n3, 1, proto.wireTypes.lengthDelimited)

			buf, n3 = proto.writeString(v60, v61, p4.kind.value)
		elseif p4.kind.type == "input_path" then
			local v62, v63 = proto.writeTag(buf, n3, 2, proto.wireTypes.lengthDelimited)

			buf, n3 = proto.writeString(v62, v63, p4.kind.value)
		end
	end

	local buf3 = buffer.create(n3)

	buffer.copy(buf3, 0, buf, 0, n3)

	return buf3
end
function t9.decode(p5: buffer) -- line: 368
	-- upvalues: t9 (copy), proto (copy)
	local v66 = t9.new()
	local n4 = 0

	while n4 < buffer.len(p5) do
		local v68, v69

		v68, v69, n4 = proto.readTag(p5, n4)

		if v69 == proto.wireTypes.varint then
			local v70

			v70, n4 = proto.readVarInt(p5, n4)
		elseif v69 == proto.wireTypes.lengthDelimited then
			if v68 == 1 then
				local v71

				v71, n4 = proto.readBuffer(p5, n4)
				v66.kind = {
					type = "literal",
					value = buffer.tostring(v71)
				}
			elseif v68 == 2 then
				local v72

				v72, n4 = proto.readBuffer(p5, n4)
				v66.kind = {
					type = "input_path",
					value = buffer.tostring(v72)
				}
			else
				local v73, v74 = proto.readVarInt(p5, n4)

				n4 = v74 + v73
			end
		elseif v69 == proto.wireTypes.i32 then
			local v75

			v75, n4 = proto.readFixed32(p5, n4)
		elseif v69 == proto.wireTypes.i64 then
			local v76

			v76, n4 = proto.readFixed64(p5, n4)
		else
			error("Unsupported wire type: " .. v69)
		end
	end

	return v66
end
function t9.jsonEncode(p6) -- line: 416
	local t11 = {}

	if p6.kind ~= nil then
		if p6.kind.type == "literal" then
			t11.literal = p6.kind.value

			return t11
		end

		if p6.kind.type == "input_path" then
			t11.inputPath = p6.kind.value
		end
	end

	return t11
end
function t9.jsonDecode(t12: {[any]: any}) -- line: 430
	-- upvalues: t9 (copy)
	local v80 = t9.new()

	if t12.literal ~= nil then
		v80.kind = {
			type = "literal",
			value = t12.literal
		}
	end

	if t12.input_path ~= nil then
		v80.kind = {
			type = "input_path",
			value = t12.input_path
		}
	end

	if t12.inputPath ~= nil then
		v80.kind = {
			type = "input_path",
			value = t12.inputPath
		}
	end

	return v80
end

t9.descriptor = {
	name = "IdBinding",
	fullName = "roblox.apppageplatform.shared.v1beta1.IdBinding"
}
t1.IdBinding = t9
typeRegistry.default:register(t1.IdBinding)

return {
	HydrationDataSpec = t1.HydrationDataSpec,
	IdBinding = t1.IdBinding
}
