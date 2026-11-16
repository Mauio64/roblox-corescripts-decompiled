local byte = string.byte

local Utf8 = { INVALID = -1 }

local function isContinuation(p: number?): boolean -- 2 equivalent calls inferred from this helper
	return p ~= nil and p >= 128 and p <= 191
end

local function decode(value: string, p: number)
	local v = byte(value, p + 1)

	if v < 128 then
		return v, 1
	end

	local v2, v3, v4

	if v >= 194 and v <= 223 then
		v2 = v - 192
		v3 = 2
		v4 = 128
	elseif v >= 224 and v <= 239 then
		v2 = v - 224
		v3 = 3
		v4 = 2048
	elseif v >= 240 and v <= 244 then
		v2 = v - 240
		v3 = 4
		v4 = 65536
	else
		return -1, 1
	end

	for i = 1, v3 - 1 do
		local v5 = byte(value, p + 1 + i)

		if not isContinuation(v5) then -- inferred equivalent call
			return -1, 1
		end

		v2 = v2 * 64 + (v5 - 128)
	end

	if v2 < v4 or v2 > 1114111 or v2 >= 55296 and v2 <= 57343 then
		return -1, 1
	end

	return v2, v3
end

function Utf8.codePointAt(p: string, p2: number)
	return (decode(p, p2))
end

function Utf8.codePointBefore(value: string, p: number)
	local v = p - 1

	while v > 0 and p - 4 < v do
		if not isContinuation(byte(value, v + 1)) then -- inferred equivalent call
			break
		end

		v -= 1
	end

	local v2, v3 = decode(value, v)
	return if v + v3 == p then v2 else -1
end

return Utf8
