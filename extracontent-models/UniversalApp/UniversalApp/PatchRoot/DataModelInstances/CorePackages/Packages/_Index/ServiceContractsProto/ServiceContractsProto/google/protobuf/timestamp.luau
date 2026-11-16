local proto = require(script.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local class = {}
class.__index = class

function class.new(p)
	return (setmetatable({
		seconds = (p == nil or p.seconds == nil) and 0 or p.seconds,
		nanos = (p == nil or p.nanos == nil) and 0 or p.nanos
	}, class))
end

function class.encode(p)
	local v2 = buffer.create(0)
	local v3 = 0

	if p.seconds ~= nil and p.seconds ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, p.seconds)
	end

	if p.nanos ~= nil and p.nanos ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, p.nanos)
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class.decode(buf: buffer)
	local result = class.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			if v3 == 1 then
				local seconds
				seconds, v2 = proto.readVarIntI64(buf, v2)
				result.seconds = seconds
			elseif v3 == 2 then
				local nanos
				nanos, v2 = proto.readVarIntI32(buf, v2)
				result.nanos = nanos
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			local varInt, v5 = proto.readVarInt(buf, v2)

			v2 = v5 + varInt
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

local function serializeFractionalNanos(nanos: number)
	if nanos % 1000000 == 0 then
		return string.format(".%03d", nanos)
	end

	if nanos % 1000 == 0 then
		return string.format(".%06d", nanos)
	end

	return string.format(".%09d", nanos)
end

local function deserializeFractionalNanos(list: string)
	local v2 = assert(tonumber(list), "Invalid nanos string received, couldn't turn into a number")

	for i = #list + 1, 9 do
		v2 += 10 ^ (i - 1)
	end

	return v2
end

function class.jsonEncode(p)
	if p.seconds > 253402300799 then
		error("Invalid timestamp provided: years after 9999 are not supported")
	end

	if p.seconds < -62135596800 then
		error("Invalid timestamp provided: years before 0001 are not supported")
	end

	local v2 = os.date("!*t", p.seconds or 0)

	if v2 == nil then
		error("Invalid timestamp provided: exceeded supported timestamp range on this platform")
	end

	return string.format(
		"%04d-%02d-%02dT%02d:%02d:%02d%sZ",
		v2.year,
		v2.month,
		v2.day,
		v2.hour,
		v2.min,
		v2.sec,
		p.nanos == 0 and "" or serializeFractionalNanos(p.nanos)
	)
end

function class.jsonDecode(value)
	local v2, v3, v4, v5, v6, v7, v8 = string.match(
		value,
		"^([0-9]+)-([0-9]+)-([0-9]+)T([0-9]+):([0-9]+):([0-9]+)(.*)Z$"
	)

	if v2 == nil or v3 == nil or v4 == nil or v5 == nil or v6 == nil or v7 == nil or v8 == nil then
		error("Invalid timestamp provided")
	end

	local nanos

	if #v8 == 0 then
		nanos = 0
	else
		local v9 = string.match(v8, "^%.([0-9]+)$")

		if v9 == nil then
			error("Invalid nanoseconds provided in timestamp: `" .. v8 .. "`")
		end

		nanos = assert(tonumber(v9), "Invalid nanos string received, couldn't turn into a number")

		for i = #v9 + 1, 9 do
			nanos += 10 ^ (i - 1)
		end
	end

	local seconds = os.time({
		year = assert(tonumber(v2), "Invalid formatted year"),
		month = assert(tonumber(v3), "Invalid formatted month"),
		day = assert(tonumber(v4), "Invalid formatted day"),
		hour = assert(tonumber(v5), "Invalid formatted hour"),
		min = assert(tonumber(v6), "Invalid formatted min"),
		sec = assert(tonumber(v7), "Invalid formatted sec")
	})

	return class.new({ seconds = seconds, nanos = nanos })
end

class.descriptor = { name = "Timestamp", fullName = "google.protobuf.Timestamp" }

v.Timestamp = class

typeRegistry.default:register(v.Timestamp)

return { Timestamp = v.Timestamp }
