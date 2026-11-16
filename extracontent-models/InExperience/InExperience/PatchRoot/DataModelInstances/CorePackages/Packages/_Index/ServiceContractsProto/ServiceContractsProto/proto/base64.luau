--!native
local v = {}
local v2 = {}

for i = 1, 64 do
	local v3 = i - 1
	local v4 = string.byte("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/", i)

	v[v3] = v4
	v2[v4] = v3
end

v2[61] = 0

local function buildStringFromCodes(list)
	local v3 = {}

	for i = 1, #list, 4096 do
		table.insert(v3, (string.char(unpack(list, i, (math.min(i + 4096 - 1, #list))))))
	end

	return table.concat(v3, "")
end

local Base64 = {}

function Base64.encode(value: string)
	local count = #value
	local v3 = math.ceil(count / 3) * 4

	local v4 = count % 3

	if v4 == 0 then
		value ..= "\0"
	end

	local v5 = table.create(v3, 0)

	for i = 0, v3 / 4 - (v4 == 0 and 1 or 2) do
		local v6 = i * 4 + 1
		local v7 = bit32.rshift(string.unpack(">J", value, i * 3 + 1), 8)

		v5[v6] = v[bit32.rshift(v7, 18)]
		v5[v6 + 1] = v[bit32.band(bit32.rshift(v7, 12), 63)]
		v5[v6 + 2] = v[bit32.band(bit32.rshift(v7, 6), 63)]
		v5[v6 + 3] = v[bit32.band(v7, 63)]
	end

	if v4 == 1 then
		local v6 = string.byte(value, count)

		v5[v3 - 3] = v[bit32.rshift(v6, 2)]
		v5[v3 - 2] = v[bit32.band(bit32.lshift(v6, 4), 63)]
		v5[v3 - 1] = 61
		v5[v3] = 61
	elseif v4 == 2 then
		local v6 = string.unpack(">H", value, count - 1)

		v5[v3 - 3] = v[bit32.rshift(v6, 10)]
		v5[v3 - 2] = v[bit32.band(bit32.rshift(v6, 4), 63)]
		v5[v3 - 1] = v[bit32.band(bit32.lshift(v6, 2), 63)]
		v5[v3] = 61
	end

	return buildStringFromCodes(v5)
end

function Base64.decode(value: string)
	local count = #value
	local v3 = math.ceil(count / 4) * 3

	local v4 = string.byte(value, count - 1) == 61 and 2 or string.byte(value, count) == 61 and 1 or 0

	local v5 = table.create(v3 - v4, 0)

	for i = 0, v3 / 3 - 1 do
		local v6 = i * 4 + 1
		local v7 = i * 3 + 1

		local v8, v9, v10, v11 = string.byte(value, v6, v6 + 3)

		local v12 = bit32.bor(bit32.lshift(v2[v8], 18), bit32.lshift(v2[v9], 12), bit32.lshift(v2[v10], 6), v2[v11])

		v5[v7] = bit32.rshift(v12, 16)
		v5[v7 + 1] = bit32.band(bit32.rshift(v12, 8), 255)
		v5[v7 + 2] = bit32.band(v12, 255)
	end

	if v4 >= 1 then
		v5[v3] = nil

		if v4 >= 2 then
			v5[v3 - 1] = nil
		end
	end

	return buildStringFromCodes(v5)
end

return Base64
