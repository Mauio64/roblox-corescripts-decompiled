local base64 = require(script.base64)

require(script.message)
require(script.typeRegistry)

local t1 = {}

local function readVarIntBytes(p1: buffer, n1: number) -- line: 21
	local n2 = 0
	local n3 = 0
	local n4 = 0

	repeat
		local v10 = buffer.readu8(p1, n1)
		local v11 = bit32.band(v10, 127)

		n2 = bit32.bor(n2, (bit32.lshift(v11, n4)))
		n3 = bit32.bor(n3, (bit32.lshift(v11, n4 - 32)))
		n4 += 7
		n1 += 1
	until not bit32.btest(v10, 128)

	return n2, n3, n1
end

function t1.readVarIntU64(p2: buffer, n5: number) -- line: 38
	-- upvalues: readVarIntBytes (copy)
	local v14, v15, v16 = readVarIntBytes(p2, n5)

	return v15 * 4294967296 + v14, v16
end
function t1.readVarIntU32(p3: buffer, n6: number) -- line: 45
	-- upvalues: readVarIntBytes (copy)
	local v19, _, v21 = readVarIntBytes(p3, n6)

	return v19, v21
end
function t1.readVarIntI64(p4: buffer, n7: number) -- line: 52
	-- upvalues: readVarIntBytes (copy)
	local v24, v25, v26 = readVarIntBytes(p4, n7)

	if v25 < 2147483648 then
		return v25 * 4294967296 + v24, v26
	end

	local v27 = bit32.bnot(v24) + 1
	local v28 = bit32.bnot(v25)

	if v27 > 4294967295 then
		v27 = 0
		v28 += 1
	end

	return -(v28 * 4294967296 + v27), v26
end
function t1.readVarIntI32(p5: buffer, n8: number) -- line: 71
	-- upvalues: readVarIntBytes (copy)
	local v31, _, v33 = readVarIntBytes(p5, n8)

	if v31 < 2147483648 then
		return v31, v33
	end

	return v31 - 4294967296, v33
end
function t1.readVarIntS64(p6: buffer, n9: number) -- line: 82
	-- upvalues: readVarIntBytes (copy)
	local v36, v37, v38 = readVarIntBytes(p6, n9)
	local v39 = bit32.btest(v36, 1)

	if v39 then
		v36 += 1

		if v36 > 4294967295 then
			v36 = 0
			v37 += 1
		end
	end

	if v37 > 4294967295 then
		return -9.223372036854776E+18, v38
	end

	local v40 = bit32.bor(bit32.rshift(v36, 1), (bit32.lshift(bit32.band(v37, 1), 31)))
	local v41 = bit32.rshift(v37, 1)

	if v39 then
		return -(v41 * 4294967296 + v40), v38
	end

	return v41 * 4294967296 + v40, v38
end
function t1.readVarIntS32(p7: buffer, n10: number) -- line: 113
	-- upvalues: readVarIntBytes (copy)
	local v44, _, v46 = readVarIntBytes(p7, n10)

	if bit32.btest(v44, 1) then
		return -(v44 + 1) / 2, v46
	end

	return v44 / 2, v46
end

t1.readVarInt = t1.readVarIntI64

function t1.readFloat(p8: buffer, n11: number) -- line: 126
	return buffer.readf32(p8, n11), n11 + 4
end
function t1.readDouble(p9: buffer, n12: number) -- line: 130
	return buffer.readf64(p9, n12), n12 + 8
end
function t1.readFixed32(p10: buffer, n13: number) -- line: 134
	return buffer.readu32(p10, n13), n13 + 4
end
function t1.readSignedFixed32(p11: buffer, n14: number) -- line: 138
	return buffer.readi32(p11, n14), n14 + 4
end
function t1.readFixed64(p12: buffer, n15: number) -- line: 143
	return assert(tonumber(string.format("%08x", (buffer.readu32(p12, n15 + 4))) .. string.format("%08x", (buffer.readu32(p12, n15))), 16), "Couldn't parse created hex"), n15 + 8
end
function t1.readSignedFixed64(_: buffer, _: number) -- line: 151
	error("TODO: Read sfixed64")
end
function t1.readTag(p14: buffer, n17: number) -- line: 155
	-- upvalues: t1 (copy)
	local v61, v62 = t1.readVarInt(p14, n17)

	return bit32.rshift(v61, 3), bit32.band(v61, 7), v62
end
function t1.readBuffer(p15: buffer, n18: number) -- line: 160
	-- upvalues: t1 (copy)
	local v65, v66 = t1.readVarInt(p15, n18)
	local buf = buffer.create(v65)

	buffer.copy(buf, 0, p15, v66, v65)

	return buf, v66 + v65
end

local function reserveBuffer(p16: buffer, n19: number, n20: number) -- line: 167
	if n20 > buffer.len(p16) - n19 then
		local buf = buffer.create(3 ^ math.ceil((math.log(buffer.len(p16) + n20, 3))))

		buffer.copy(buf, 0, p16, 0, n19)

		return buf
	end

	return p16
end

t1.wireTypes = {
	varint = 0,
	i64 = 1,
	lengthDelimited = 2,
	sgroup = 3,
	egroup = 4,
	i32 = 5
}

function t1.writeVarInt(p17: buffer, n21: number, n22: number) -- line: 186
	-- upvalues: reserveBuffer (copy)
	if n22 >= 0 then
		repeat
			p17 = reserveBuffer(p17, n21, 1)

			local v75 = n22 % 128

			n22 //= 128
			buffer.writeu8(p17, n21, if n22 ~= 0 then v75 + 128 else v75)
			n21 += 1
		until n22 == 0
	else
		local v76 = -n22
		local v77 = bit32.bnot(v76 // 4294967296)
		local v78 = bit32.bnot(v76 % 4294967296) + 1

		if v78 == 4294967296 then
			v78 = 0
			v77 += 1
		end

		p17 = reserveBuffer(p17, n21, 10)
		buffer.writeu8(p17, n21, (bit32.bor(128, (bit32.band(v78, 127)))))
		buffer.writeu8(p17, n21 + 1, (bit32.bor(128, (bit32.band(bit32.rshift(v78, 7), 127)))))
		buffer.writeu8(p17, n21 + 2, (bit32.bor(128, (bit32.band(bit32.rshift(v78, 14), 127)))))
		buffer.writeu8(p17, n21 + 3, (bit32.bor(128, (bit32.band(bit32.rshift(v78, 21), 127)))))
		buffer.writeu8(p17, n21 + 4, (bit32.bor(128, bit32.lshift(bit32.band(v77, 7), 4), (bit32.rshift(v78, 28)))))
		buffer.writeu8(p17, n21 + 5, (bit32.bor(128, (bit32.band(bit32.rshift(v77, 3), 127)))))
		buffer.writeu8(p17, n21 + 6, (bit32.bor(128, (bit32.band(bit32.rshift(v77, 10), 127)))))
		buffer.writeu8(p17, n21 + 7, (bit32.bor(128, (bit32.band(bit32.rshift(v77, 17), 127)))))
		buffer.writeu8(p17, n21 + 8, (bit32.bor(128, (bit32.band(bit32.rshift(v77, 24), 127)))))
		buffer.writeu8(p17, n21 + 9, (bit32.rshift(v77, 31)))
		n21 += 10
	end

	return p17, n21
end
function t1.writeVarIntZigZag(p18: buffer, n23: number, n24: number) -- line: 225
	-- upvalues: reserveBuffer (copy)
	local v82 = n24 < 0
	local v83 = math.abs(n24)
	local v84 = v83 // 4294967296
	local v85 = v83 % 4294967296
	local v86 = bit32.extract(v85, 31)
	local v87 = bit32.lshift(v85, 1)
	local v88 = bit32.bor(bit32.lshift(v84, 1), v86)

	if v82 then
		v87 -= 1

		if v87 < 0 then
			v87 = 4294967295
			v88 -= 1
		end
	end

	repeat
		p18 = reserveBuffer(p18, n23, 1)

		local v89 = v87 % 128

		v87 = bit32.bor(bit32.rshift(v87, 7), (bit32.lshift(bit32.band(v88, 127), 25)))
		v88 = bit32.rshift(v88, 7)

		local v90 = v87 == 0 and v88 == 0

		buffer.writeu8(p18, n23, if not v90 then v89 + 128 else v89)
		n23 += 1
	until v90

	return p18, n23
end
function t1.writeFloat(p19: buffer, n25: number, n26: number) -- line: 259
	-- upvalues: reserveBuffer (copy)
	local v94 = reserveBuffer(p19, n25, 4)

	buffer.writef32(v94, n25, n26)

	return v94, n25 + 4
end
function t1.writeDouble(p20: buffer, n27: number, n28: number) -- line: 265
	-- upvalues: reserveBuffer (copy)
	local v98 = reserveBuffer(p20, n27, 8)

	buffer.writef64(v98, n27, n28)

	return v98, n27 + 8
end
function t1.writeFixed32(p21: buffer, n29: number, n30: number) -- line: 271
	-- upvalues: reserveBuffer (copy)
	local v102 = reserveBuffer(p21, n29, 4)

	buffer.writeu32(v102, n29, n30)

	return v102, n29 + 4
end
function t1.writeSignedFixed32(p22: buffer, n31: number, n32: number) -- line: 277
	-- upvalues: reserveBuffer (copy)
	local v106 = reserveBuffer(p22, n31, 4)

	buffer.writei32(v106, n31, n32)

	return v106, n31 + 4
end
function t1.writeFixed64(p23: buffer, n33: number, n34: number) -- line: 283
	-- upvalues: reserveBuffer (copy)
	local v110 = reserveBuffer(p23, n33, 8)
	local v111 = string.format("%016x", n34)

	buffer.writeu32(v110, n33, (assert(tonumber(v111:sub(9, 16), 16), "Couldn't parse created hex")))
	buffer.writeu32(v110, n33 + 4, (assert(tonumber(v111:sub(1, 8), 16), "Couldn't parse created hex")))

	return v110, n33 + 8
end
function t1.writeSignedFixed64(_: buffer, _: number, _: number) -- line: 294
	error("TODO: Write sfixed64")
end
function t1.writeTag(p25: buffer, n37: number, n38: number, n39: number) -- line: 298
	-- upvalues: t1 (copy)
	return t1.writeVarInt(p25, n37, bit32.lshift(n38, 3) + n39)
end
function t1.writeBuffer(p26: buffer, n40: number, p27: buffer, n41: number) -- line: 302
	-- upvalues: t1 (copy), reserveBuffer (copy)
	local v123, v124 = t1.writeVarInt(p26, n40, n41)
	local v125 = reserveBuffer(v123, v124, n41)

	buffer.copy(v125, v124, p27, 0, n41)

	return v125, v124 + n41
end
function t1.writeString(p28: buffer, n42: number, s1: string) -- line: 311
	-- upvalues: t1 (copy)
	return t1.writeBuffer(p28, n42, buffer.fromstring(s1), #s1)
end

t1.json = {}

function t1.json.serializeNumber(n43: number) -- line: 317
	if n43 == 1e999 then
		return "Infinity"
	end

	if n43 == -1e999 then
		return "-Infinity"
	end

	if n43 ~= n43 then
		return "NaN"
	end

	return n43
end
function t1.json.deserializeNumber(p29) -- line: 325
	if p29 == "Infinity" then
		return 1e999
	end

	if p29 == "-Infinity" then
		return -1e999
	end

	if p29 == "NaN" then
		return (0/0)
	end

	if typeof(p29) == "string" then
		local num = tonumber(p29)

		assert(num ~= nil, "Number given that could not be parsed")

		return num
	end

	return p29
end
function t1.json.serializeBuffer(p30: buffer) -- line: 341
	-- upvalues: base64 (copy)
	return base64.encode(buffer.tostring(p30))
end
function t1.json.deserializeBuffer(s2: string) -- line: 345
	-- upvalues: base64 (copy)
	return buffer.fromstring(base64.decode(s2))
end

return t1
