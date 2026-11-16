local base64 = require(script.base64)
require(script.message)
require(script.typeRegistry)

local Proto = {}

local function readVarIntBytes(buf: buffer, count: number)
	local total = 0
	local v = 0
	local v2 = 0

	repeat
		local v3 = buffer.readu8(buf, count)
		local v4 = bit32.band(v3, 127)
		v = bit32.bor(v, (bit32.lshift(v4, total)))
		v2 = bit32.bor(v2, (bit32.lshift(v4, total - 32)))
		total += 7
		count += 1
	until not bit32.btest(v3, 128)

	return v, v2, count
end

function Proto.readVarIntU64(buf: buffer, p: number)
	local v, v2, v3 = readVarIntBytes(buf, p)

	return v2 * 4294967296 + v, v3
end

function Proto.readVarIntU32(buf: buffer, p: number)
	local v, _, v2 = readVarIntBytes(buf, p)

	return v, v2
end

function Proto.readVarIntI64(buf: buffer, p: number)
	local v, v2, v3 = readVarIntBytes(buf, p)

	if v2 < 2147483648 then
		return v2 * 4294967296 + v, v3
	end

	local v4 = bit32.bnot(v) + 1
	local v5 = bit32.bnot(v2)

	if v4 > 4294967295 then
		v5 += 1
		v4 = 0
	end

	return -(v5 * 4294967296 + v4), v3
end

function Proto.readVarIntI32(buf: buffer, p: number)
	local v, _, v2 = readVarIntBytes(buf, p)

	if v < 2147483648 then
		return v, v2
	end

	return v - 4294967296, v2
end

function Proto.readVarIntS64(buf: buffer, p: number)
	local v, v2, v3 = readVarIntBytes(buf, p)

	local v4 = bit32.btest(v, 1)

	if v4 then
		v += 1

		if v > 4294967295 then
			v2 += 1
			v = 0
		end
	end

	if v2 > 4294967295 then
		return -9.223372036854776e18, v3
	end

	local v5 = bit32.bor(bit32.rshift(v, 1), (bit32.lshift(bit32.band(v2, 1), 31)))
	local v6 = bit32.rshift(v2, 1)

	if v4 then
		return -(v6 * 4294967296 + v5), v3
	end

	return v6 * 4294967296 + v5, v3
end

function Proto.readVarIntS32(buf: buffer, p: number)
	local v, _, v2 = readVarIntBytes(buf, p)

	if bit32.btest(v, 1) then
		return -(v + 1) / 2, v2
	end

	return v / 2, v2
end

Proto.readVarInt = Proto.readVarIntI64

function Proto.readFloat(buf: buffer, offset: number)
	return buffer.readf32(buf, offset), offset + 4
end

function Proto.readDouble(buf: buffer, offset: number)
	return buffer.readf64(buf, offset), offset + 8
end

function Proto.readFixed32(buf: buffer, offset: number)
	return buffer.readu32(buf, offset), offset + 4
end

function Proto.readSignedFixed32(buf: buffer, offset: number)
	return buffer.readi32(buf, offset), offset + 4
end

function Proto.readFixed64(buf: buffer, offset: number)
	return
		assert(
			tonumber(
				string.format("%08x", (buffer.readu32(buf, offset + 4))) .. string.format("%08x", (buffer.readu32(buf, offset))),
				16
			),
			"Couldn't parse created hex"
		),
		offset + 8
end

function Proto.readSignedFixed64(_: buffer, _: number)
	error("TODO: Read sfixed64")
end

function Proto.readTag(buf: buffer, p: number)
	local varInt, v = Proto.readVarInt(buf, p)
	return bit32.rshift(varInt, 3), bit32.band(varInt, 7), v
end

function Proto.readBuffer(source: buffer, p: number)
	local varInt, v = Proto.readVarInt(source, p)
	local buf = buffer.create(varInt)
	buffer.copy(buf, 0, source, v, varInt)
	return buf, v + varInt
end

local function reserveBuffer(buf: buffer, count: number, p: number)
	if buffer.len(buf) - count < p then
		local buf2 = buffer.create(3 ^ math.ceil((math.log(buffer.len(buf) + p, 3))))
		buffer.copy(buf2, 0, buf, 0, count)
		return buf2
	end

	return buf
end

Proto.wireTypes = {
	varint = 0,
	i64 = 1,
	lengthDelimited = 2,
	sgroup = 3,
	egroup = 4,
	i32 = 5
}

function Proto.writeVarInt(buf: buffer, offset: number, p: number)
	if p >= 0 then
		repeat
			buf = reserveBuffer(buf, offset, 1)
			local v = p % 128
			p //= 128

			if p ~= 0 then
				v += 128
			end

			buffer.writeu8(buf, offset, v)
			offset += 1
		until p == 0
	else
		local v = -p
		local v2 = bit32.bnot(v // 4294967296)
		local v3 = bit32.bnot(v % 4294967296) + 1

		if v3 == 4294967296 then
			v2 += 1
			v3 = 0
		end

		buf = reserveBuffer(buf, offset, 10)
		buffer.writeu8(buf, offset, (bit32.bor(128, (bit32.band(v3, 127)))))
		buffer.writeu8(buf, offset + 1, (bit32.bor(128, (bit32.band(bit32.rshift(v3, 7), 127)))))
		buffer.writeu8(buf, offset + 2, (bit32.bor(128, (bit32.band(bit32.rshift(v3, 14), 127)))))
		buffer.writeu8(buf, offset + 3, (bit32.bor(128, (bit32.band(bit32.rshift(v3, 21), 127)))))
		buffer.writeu8(buf, offset + 4, (bit32.bor(128, bit32.lshift(bit32.band(v2, 7), 4), (bit32.rshift(v3, 28)))))

		buffer.writeu8(buf, offset + 5, (bit32.bor(128, (bit32.band(bit32.rshift(v2, 3), 127)))))
		buffer.writeu8(buf, offset + 6, (bit32.bor(128, (bit32.band(bit32.rshift(v2, 10), 127)))))
		buffer.writeu8(buf, offset + 7, (bit32.bor(128, (bit32.band(bit32.rshift(v2, 17), 127)))))
		buffer.writeu8(buf, offset + 8, (bit32.bor(128, (bit32.band(bit32.rshift(v2, 24), 127)))))
		buffer.writeu8(buf, offset + 9, (bit32.rshift(v2, 31)))
		offset += 10
	end

	return buf, offset
end

function Proto.writeVarIntZigZag(buf: buffer, count: number, p: number)
	local v = p < 0
	local v2 = math.abs(p)

	local v3 = v2 // 4294967296
	local v4 = v2 % 4294967296

	local v5 = bit32.extract(v4, 31)
	local v6 = bit32.lshift(v4, 1)
	local v7 = bit32.bor(bit32.lshift(v3, 1), v5)

	if v then
		v6 -= 1

		if v6 < 0 then
			v7 -= 1
			v6 = 4294967295
		end
	end

	repeat
		buf = reserveBuffer(buf, count, 1)
		local v8 = v6 % 128
		v6 = bit32.bor(bit32.rshift(v6, 7), (bit32.lshift(bit32.band(v7, 127), 25)))
		v7 = bit32.rshift(v7, 7)
		local v9

		if v6 == 0 then
			v9 = v7 == 0
		else
			v9 = false
		end

		if not v9 then
			v8 += 128
		end

		buffer.writeu8(buf, count, v8)
		count += 1
	until v9

	return buf, count
end

function Proto.writeFloat(buf: buffer, offset: number, value: number)
	local v = reserveBuffer(buf, offset, 4)
	buffer.writef32(v, offset, value)
	return v, offset + 4
end

function Proto.writeDouble(buf: buffer, offset: number, value: number)
	local v = reserveBuffer(buf, offset, 8)
	buffer.writef64(v, offset, value)
	return v, offset + 8
end

function Proto.writeFixed32(buf: buffer, offset: number, value: number)
	local v = reserveBuffer(buf, offset, 4)
	buffer.writeu32(v, offset, value)
	return v, offset + 4
end

function Proto.writeSignedFixed32(buf: buffer, offset: number, value: number)
	local v = reserveBuffer(buf, offset, 4)
	buffer.writei32(v, offset, value)
	return v, offset + 4
end

function Proto.writeFixed64(buf: buffer, offset: number, p: number)
	local v = reserveBuffer(buf, offset, 8)

	local v2 = string.format("%016x", p)
	buffer.writeu32(v, offset, (assert(tonumber(v2:sub(9, 16), 16), "Couldn't parse created hex")))
	buffer.writeu32(v, offset + 4, (assert(tonumber(v2:sub(1, 8), 16), "Couldn't parse created hex")))

	return v, offset + 8
end

function Proto.writeSignedFixed64(_: buffer, _: number, _: number)
	error("TODO: Write sfixed64")
end

function Proto.writeTag(buf: buffer, p: number, p2: number, p3: number)
	return Proto.writeVarInt(buf, p, bit32.lshift(p2, 3) + p3)
end

function Proto.writeBuffer(buf: buffer, p: number, source: buffer, count: number)
	local v, v2 = Proto.writeVarInt(buf, p, count)

	local v3 = reserveBuffer(v, v2, count)
	buffer.copy(v3, v2, source, 0, count)

	return v3, v2 + count
end

function Proto.writeString(buf: buffer, p: number, str: string)
	return Proto.writeBuffer(buf, p, buffer.fromstring(str), #str)
end

Proto.json = {}

function Proto.json.serializeNumber(p: number)
	if p == 1e999 then
		return "Infinity"
	elseif p == -1e999 then
		return "-Infinity"
	end

	return if p == p then p else "NaN"
end

function Proto.json.deserializeNumber(value)
	if value == "Infinity" then
		return 1e999
	elseif value == "-Infinity" then
		return -1e999
	elseif value == "NaN" then
		return (0 / 0)
	end

	if typeof(value) ~= "string" then
		return value
	end

	local v = tonumber(value)
	assert(v ~= nil, "Number given that could not be parsed")
	return v
end

function Proto.json.serializeBuffer(buf: buffer)
	return base64.encode(buffer.tostring(buf))
end

function Proto.json.deserializeBuffer(p: string)
	return buffer.fromstring(base64.decode(p))
end

return Proto
