local proto = require(script.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 41
	-- upvalues: t2 (copy)
	return (setmetatable({
		seconds = if t3 ~= nil and t3.seconds ~= nil then t3.seconds else 0,
		nanos = if t3 ~= nil and t3.nanos ~= nil then t3.nanos else 0
	}, t2))
end
function t2.encode(p1) -- line: 48
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.seconds ~= nil and p1.seconds ~= 0 then
		local v11, v12 = proto.writeTag(buf, n1, 1, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v11, v12, p1.seconds)
	end

	if p1.nanos ~= nil and p1.nanos ~= 0 then
		local v13, v14 = proto.writeTag(buf, n1, 2, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v13, v14, p1.nanos)
	end

	local buf2 = buffer.create(n1)

	buffer.copy(buf2, 0, buf, 0, n1)

	return buf2
end
function t2.decode(p2: buffer) -- line: 67
	-- upvalues: t2 (copy), proto (copy)
	local v17 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v19, v20

		v19, v20, n2 = proto.readTag(p2, n2)

		if v20 == proto.wireTypes.varint then
			if v19 == 1 then
				local v21

				v21, n2 = proto.readVarIntI64(p2, n2)
				v17.seconds = v21
			elseif v19 == 2 then
				local v22

				v22, n2 = proto.readVarIntI32(p2, n2)
				v17.nanos = v22
			else
				local v23

				v23, n2 = proto.readVarInt(p2, n2)
			end
		elseif v20 == proto.wireTypes.lengthDelimited then
			local v24, v25 = proto.readVarInt(p2, n2)

			n2 = v25 + v24
		elseif v20 == proto.wireTypes.i32 then
			local v26

			v26, n2 = proto.readFixed32(p2, n2)
		elseif v20 == proto.wireTypes.i64 then
			local v27

			v27, n2 = proto.readFixed64(p2, n2)
		else
			error("Unsupported wire type: " .. v20)
		end
	end

	return v17
end

local function serializeFractionalNanos(n3: number) -- line: 115
	if n3 % 1000000 == 0 then
		return string.format(".%03d", n3)
	end

	if n3 % 1000 == 0 then
		return string.format(".%06d", n3)
	end

	return string.format(".%09d", n3)
end
local function deserializeFractionalNanos(s1: string) -- line: 125
	local v30 = assert(tonumber(s1), "Invalid nanos string received, couldn't turn into a number")

	for i = #s1 + 1, 9 do
		v30 += 10 ^ (i - 1)
	end

	return v30
end

function t2.jsonEncode(p3) -- line: 134
	-- upvalues: serializeFractionalNanos (copy)
	if p3.seconds > 253402300799 then
		error("Invalid timestamp provided: years after 9999 are not supported")
	end

	if p3.seconds < -62135596800 then
		error("Invalid timestamp provided: years before 0001 are not supported")
	end

	local v33 = os.date("!*t", p3.seconds or 0)

	if v33 == nil then
		error("Invalid timestamp provided: exceeded supported timestamp range on this platform")
	end

	return string.format("%04d-%02d-%02dT%02d:%02d:%02d%sZ", v33.year, v33.month, v33.day, v33.hour, v33.min, v33.sec, if p3.nanos ~= 0 then serializeFractionalNanos(p3.nanos) else "")
end
function t2.jsonDecode(p4) -- line: 160
	-- upvalues: t2 (copy)
	local v35, v36, v37, v38, v39, v40, v41 = string.match(p4, "^([0-9]+)-([0-9]+)-([0-9]+)T([0-9]+):([0-9]+):([0-9]+)(.*)Z$")

	if v35 == nil or (v36 == nil or v37 == nil or v38 == nil or v39 == nil or v40 == nil or v41 == nil) then
		error("Invalid timestamp provided")
	end

	local n4 = 0

	if #v41 ~= 0 then
		local match = string.match(v41, "^%.([0-9]+)$")

		if match == nil then
			error("Invalid nanoseconds provided in timestamp: `" .. v41 .. "`")
		end

		n4 = assert(tonumber(match), "Invalid nanos string received, couldn't turn into a number")

		for i = #match + 1, 9 do
			n4 += 10 ^ (i - 1)
		end
	end

	local timestamp = os.time({
		year = assert(tonumber(v35), "Invalid formatted year"),
		month = assert(tonumber(v36), "Invalid formatted month"),
		day = assert(tonumber(v37), "Invalid formatted day"),
		hour = assert(tonumber(v38), "Invalid formatted hour"),
		min = assert(tonumber(v39), "Invalid formatted min"),
		sec = assert(tonumber(v40), "Invalid formatted sec")
	})

	return t2.new({
		seconds = timestamp,
		nanos = n4
	})
end

t2.descriptor = {
	name = "Timestamp",
	fullName = "google.protobuf.Timestamp"
}
t1.Timestamp = t2
typeRegistry.default:register(t1.Timestamp)

return {
	Timestamp = t1.Timestamp
}
