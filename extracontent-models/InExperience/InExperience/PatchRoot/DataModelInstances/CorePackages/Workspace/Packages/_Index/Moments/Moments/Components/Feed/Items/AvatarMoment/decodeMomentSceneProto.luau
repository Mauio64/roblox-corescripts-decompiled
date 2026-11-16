local function readVarint(buf: buffer, count: number)
	local v = 1
	local total = 0

	for _ = 1, 10 do
		if buffer.len(buf) <= count then
			error("MomentScene protobuf ended inside a varint")
		end

		local v2 = buffer.readu8(buf, count)
		count += 1
		total += bit32.band(v2, 127) * v

		if v2 < 128 then
			return total, count
		end

		v *= 128
	end

	error("MomentScene protobuf contains an invalid varint")
end

local function readLengthDelimited(buf: buffer, p: number)
	local v, v2 = readVarint(buf, p)
	local v3 = v2 + v

	if v < 0 or buffer.len(buf) < v3 then
		error("MomentScene protobuf contains an invalid byte field")
	end

	return buffer.readstring(buf, v2, v), v3
end

local function skipField(buf: buffer, total: number, p: number)
	if p == 0 then
		local _, v = readVarint(buf, total)
		return v
	end

	if p == 1 then
		total += 8
	else
		if p == 2 then
			local _, v = readLengthDelimited(buf, total)
			return v
		end

		if p == 5 then
			total += 4
		else
			error(`MomentScene protobuf uses unsupported wire type {p}`)
		end
	end

	if buffer.len(buf) < total then
		error("MomentScene protobuf ended inside a fixed-width field")
	end

	return total
end

local function decodeMomentSceneProto(buf: buffer)
	local v = 0
	local result = {}

	while v < buffer.len(buf) do
		local v2, v3 = readVarint(buf, v)
		local v4 = math.floor(v2 / 8)
		local v5 = v2 % 8

		if v4 == 0 then
			error("MomentScene protobuf contains field number zero")
		end

		if v4 == 1 or v4 == 5 then
			if v5 ~= 2 then
				error(`MomentScene protobuf field {v4} has the wrong wire type`)
			end

			local v6
			v6, v = readLengthDelimited(buf, v3)

			if v4 == 1 then
				result.camera_metadata = v6
			else
				result.emote_name = v6
			end
		elseif v4 >= 2 and v4 <= 4 then
			if v5 ~= 0 then
				error(`MomentScene protobuf field {v4} has the wrong wire type`)
			end

			local v6
			v6, v = readVarint(buf, v3)

			if v4 == 2 then
				result.outfit_id = v6
			elseif v4 == 3 then
				result.emote_asset_id = v6
			else
				result.background_asset_id = v6
			end
		else
			v = skipField(buf, v3, v5)
		end
	end

	return result
end

return decodeMomentSceneProto
