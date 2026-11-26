local function readVarint(buf, count)
	local v5 = 1
	local total = 0

	for i = 1, 10 do
		if buffer.len(buf) <= count then
			error("MomentScene protobuf ended inside a varint")
		end

		local v6 = buffer.readu8(buf, count)
		count += 1
		total += bit32.band(v6, 127) * v5

		if v6 < 128 then
			return total, count
		end

		v5 *= 128
	end

	error("MomentScene protobuf contains an invalid varint")
end

local function readLengthDelimited(buf, p2)
	local v5, v6 = readVarint(buf, p2)
	local v7 = v6 + v5

	if v5 < 0 or buffer.len(buf) < v7 then
		error("MomentScene protobuf contains an invalid byte field")
	end

	return buffer.readstring(buf, v6, v5), v7
end

local function skipField(buf, total, p2)
	if p2 == 0 then
		local v5, v6 = readVarint(buf, total)
		return v6
	end

	if p2 == 1 then
		total += 8
	else
		if p2 == 2 then
			local v5, v6 = readLengthDelimited(buf, total)
			return v6
		end

		if p2 == 5 then
			total += 4
		else
			error(`MomentScene protobuf uses unsupported wire type {p2}`)
		end
	end

	if buffer.len(buf) < total then
		error("MomentScene protobuf ended inside a fixed-width field")
	end

	return total
end

local function decodeMomentSceneProto(buf)
	local v5 = 0
	local result = {}

	while v5 < buffer.len(buf) do
		local v6, v7 = readVarint(buf, v5)
		local v8 = math.floor(v6 / 8)
		local v9 = v6 % 8

		if v8 == 0 then
			error("MomentScene protobuf contains field number zero")
		end

		if v8 == 1 or v8 == 5 then
			if v9 ~= 2 then
				error(`MomentScene protobuf field {v8} has the wrong wire type`)
			end

			local v10
			v10, v5 = readLengthDelimited(buf, v7)

			if v8 == 1 then
				result.camera_metadata = v10
			else
				result.emote_name = v10
			end
		elseif v8 >= 2 and v8 <= 4 then
			if v9 ~= 0 then
				error(`MomentScene protobuf field {v8} has the wrong wire type`)
			end

			local v10
			v10, v5 = readVarint(buf, v7)

			if v8 == 2 then
				result.outfit_id = v10
			elseif v8 == 3 then
				result.emote_asset_id = v10
			else
				result.background_asset_id = v10
			end
		else
			v5 = skipField(buf, v7, v9)
		end
	end

	return result
end

return decodeMomentSceneProto
