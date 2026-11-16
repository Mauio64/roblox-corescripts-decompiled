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
	local v2 = tostring(nanos * math.sign(nanos))
	local v3 = 9 - #v2
	local v4 = string.rep("0", v3)

	while v2:sub(-1) == "0" do
		v2 = v2:sub(1, -2)
	end

	return `.{v4}{v2}s`
end

local function deserializeFractionalNanos(list: string) -- 1 equivalent call inferred from this helper
	local v2 = assert(tonumber(list), "Invalid nanos string received, couldn't turn into a number")

	for _ = #list + 1, 9 do
		v2 *= 10
	end

	return v2
end

function class.jsonEncode(p)
	local v2

	if p.seconds == nil then
		v2 = true
	elseif p.seconds >= -315576000000 then
		v2 = p.seconds <= 315576000000
	else
		v2 = false
	end

	assert(v2, "Seconds out of range")
	local v3

	if p.nanos == nil then
		v3 = true
	elseif p.nanos >= -999999999 then
		v3 = p.nanos <= 999999999
	else
		v3 = false
	end

	assert(v3, "Nanoseconds out of range")

	if p.nanos == nil or p.nanos == 0 or p.nanos % 1000000000 == 0 then
		return `{p.seconds}s`
	end

	local v4 = p.seconds == 0 and math.sign(p.nanos) == -1 and "-" or ""
	return string.format("%s%d%s", v4, p.seconds or 0, serializeFractionalNanos(p.nanos))
end

function class.jsonDecode(value)
	local v2 = string.match(value, "^([%-0-9]+)s$")

	local nanos = 0
	local seconds

	if v2 == nil then
		local v3, v4 = string.match(value, "^([%-0-9]+)%.([0-9]+)s$")
		assert(v3 ~= nil, "Invalid duration string received--seconds provided are invalid")
		assert(v4 ~= nil, "Invalid duration string received--nanos provided are invalid")

		seconds = assert(tonumber(v3), "Invalid duration string received--seconds provided are invalid")
		nanos = deserializeFractionalNanos(v4) * (v3:sub(1, 1) == "-" and -1 or 1) -- inferred equivalent call
	else
		seconds = assert(
			tonumber(v2),
			"Invalid duration string received--was formatted as just having seconds, but wasn't a properly formatted int"
		)
	end

	if seconds > 315576000000 then
		error(`Duration seconds cannot exceed {315576000000}`)
	elseif seconds < -315576000000 then
		error(`Duration seconds cannot be less than {-315576000000}`)
	end

	return class.new({ seconds = seconds, nanos = nanos })
end

class.descriptor = { name = "Duration", fullName = "google.protobuf.Duration" }

v.Duration = class

typeRegistry.default:register(v.Duration)

return { Duration = v.Duration }
