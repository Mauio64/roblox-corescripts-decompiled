local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local class = {}
class.__index = class

function class.new(data)
	local moment_id

	if not (data == nil or data.moment_id == nil) then
		moment_id = data.moment_id
	end

	local asset_id

	if not (data == nil or data.asset_id == nil) then
		asset_id = data.asset_id
	end

	local creator_id

	if not (data == nil or data.creator_id == nil) then
		creator_id = data.creator_id
	end

	local status

	if not (data == nil or data.status == nil) then
		status = data.status
	end

	local metadata

	if not (data == nil or data.metadata == nil) then
		metadata = data.metadata
	end

	return (setmetatable({
		moment_id = moment_id,
		asset_id = asset_id,
		creator_id = creator_id,
		status = status,
		metadata = metadata
	}, class))
end

function class:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.moment_id ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.moment_id)
	end

	if self.asset_id ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.asset_id)
	end

	if self.creator_id ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.creator_id)
	end

	if self.status ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.status)
	end

	if self.metadata ~= nil then
		local encoded = self.metadata:encode()
		local v4, v5 = proto.writeTag(v2, v3, 5, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
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
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.moment_id = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.asset_id = buffer.tostring(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.creator_id = buffer.tostring(v5)
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.status = buffer.tostring(v5)
			elseif v3 == 5 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.metadata = v.MomentData_MomentMetadata.decode(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
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

function class:jsonEncode()
	local v2 = {}

	if self.moment_id ~= nil then
		v2.momentId = self.moment_id
	end

	if self.asset_id ~= nil then
		v2.assetId = self.asset_id
	end

	if self.creator_id ~= nil then
		v2.creatorId = self.creator_id
	end

	if self.status ~= nil then
		v2.status = self.status
	end

	if self.metadata ~= nil then
		v2.metadata = self.metadata:jsonEncode()
	end

	return v2
end

function class.jsonDecode(data)
	local v2 = class.new()

	if data.moment_id ~= nil then
		v2.moment_id = data.moment_id
	end

	if data.momentId ~= nil then
		v2.moment_id = data.momentId
	end

	if data.asset_id ~= nil then
		v2.asset_id = data.asset_id
	end

	if data.assetId ~= nil then
		v2.asset_id = data.assetId
	end

	if data.creator_id ~= nil then
		v2.creator_id = data.creator_id
	end

	if data.creatorId ~= nil then
		v2.creator_id = data.creatorId
	end

	if data.status ~= nil then
		v2.status = data.status
	end

	if data.metadata ~= nil then
		v2.metadata = v.MomentData_MomentMetadata.jsonDecode(data.metadata)
	end

	return v2
end

class.descriptor = {
	name = "MomentData",
	fullName = "roblox.apppageplatform.shared.v1beta1.MomentData"
}

v.MomentData = class

typeRegistry.default:register(v.MomentData)

local class2 = {}
class2.__index = class2

function class2.new(data)
	local asset_total_duration_seconds

	if not (data == nil or data.asset_total_duration_seconds == nil) then
		asset_total_duration_seconds = data.asset_total_duration_seconds
	end

	local capture_type

	if not (data == nil or data.capture_type == nil) then
		capture_type = data.capture_type
	end

	local description

	if not (data == nil or data.description == nil) then
		description = data.description
	end

	local capture_universe_id

	if not (data == nil or data.capture_universe_id == nil) then
		capture_universe_id = data.capture_universe_id
	end

	local capture_place_id

	if not (data == nil or data.capture_place_id == nil) then
		capture_place_id = data.capture_place_id
	end

	local edits

	if not (data == nil or data.edits == nil) then
		edits = data.edits
	end

	return (setmetatable({
		asset_total_duration_seconds = asset_total_duration_seconds,
		capture_type = capture_type,
		description = description,
		capture_universe_id = capture_universe_id,
		capture_place_id = capture_place_id,
		edits = edits
	}, class2))
end

function class2:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.asset_total_duration_seconds ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.i32)
		v2, v3 = proto.writeFloat(v4, v5, self.asset_total_duration_seconds)
	end

	if self.capture_type ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.capture_type)
	end

	if self.description ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.description)
	end

	if self.capture_universe_id ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.capture_universe_id)
	end

	if self.capture_place_id ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 5, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.capture_place_id)
	end

	if self.edits ~= nil then
		local encoded = self.edits:encode()
		local v4, v5 = proto.writeTag(v2, v3, 6, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class2.decode(buf: buffer)
	local result = class2.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.capture_type = buffer.tostring(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.description = buffer.tostring(v5)
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.capture_universe_id = buffer.tostring(v5)
			elseif v3 == 5 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.capture_place_id = buffer.tostring(v5)
			elseif v3 == 6 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.edits = v.MomentData_MomentMetadata_MomentEdits.decode(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			if v3 == 1 then
				local asset_total_duration_seconds
				asset_total_duration_seconds, v2 = proto.readFloat(buf, v2)
				result.asset_total_duration_seconds = asset_total_duration_seconds
			else
				local _
				_, v2 = proto.readFixed32(buf, v2)
			end
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class2:jsonEncode()
	local v2 = {}

	if self.asset_total_duration_seconds ~= nil then
		v2.assetTotalDurationSeconds = proto.json.serializeNumber(self.asset_total_duration_seconds)
	end

	if self.capture_type ~= nil then
		v2.captureType = self.capture_type
	end

	if self.description ~= nil then
		v2.description = self.description
	end

	if self.capture_universe_id ~= nil then
		v2.captureUniverseId = self.capture_universe_id
	end

	if self.capture_place_id ~= nil then
		v2.capturePlaceId = self.capture_place_id
	end

	if self.edits ~= nil then
		v2.edits = self.edits:jsonEncode()
	end

	return v2
end

function class2.jsonDecode(data)
	local v2 = class2.new()

	if data.asset_total_duration_seconds ~= nil then
		v2.asset_total_duration_seconds = proto.json.deserializeNumber(data.asset_total_duration_seconds)
	end

	if data.assetTotalDurationSeconds ~= nil then
		v2.asset_total_duration_seconds = proto.json.deserializeNumber(data.assetTotalDurationSeconds)
	end

	if data.capture_type ~= nil then
		v2.capture_type = data.capture_type
	end

	if data.captureType ~= nil then
		v2.capture_type = data.captureType
	end

	if data.description ~= nil then
		v2.description = data.description
	end

	if data.capture_universe_id ~= nil then
		v2.capture_universe_id = data.capture_universe_id
	end

	if data.captureUniverseId ~= nil then
		v2.capture_universe_id = data.captureUniverseId
	end

	if data.capture_place_id ~= nil then
		v2.capture_place_id = data.capture_place_id
	end

	if data.capturePlaceId ~= nil then
		v2.capture_place_id = data.capturePlaceId
	end

	if data.edits ~= nil then
		v2.edits = v.MomentData_MomentMetadata_MomentEdits.jsonDecode(data.edits)
	end

	return v2
end

class2.descriptor = {
	name = "MomentData_MomentMetadata",
	fullName = "roblox.apppageplatform.shared.v1beta1.MomentMetadata"
}

v.MomentData_MomentMetadata = class2

typeRegistry.default:register(v.MomentData_MomentMetadata)

local class3 = {}
class3.__index = class3

function class3.new(data)
	local music

	if not (data == nil or data.music == nil) then
		music = data.music
	end

	local trim

	if not (data == nil or data.trim == nil) then
		trim = data.trim
	end

	local v2 = {
		music = music,
		trim = trim,
		text_overlays = (data == nil or data.text_overlays == nil) and {} or data.text_overlays
	}
	return (setmetatable(v2, class3))
end

function class3:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.music ~= nil then
		local encoded = self.music:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.trim ~= nil then
		local encoded = self.trim:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.text_overlays ~= nil and #self.text_overlays > 0 then
		for _, text_overlay in self.text_overlays do
			local encoded = text_overlay:encode()
			local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class3.decode(buf: buffer)
	local result = class3.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.music = v.MomentData_MomentMetadata_MomentEdits_MusicEdit.decode(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.trim = v.MomentData_MomentMetadata_MomentEdits_TrimEdit.decode(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				table.insert(result.text_overlays, v.MomentData_MomentMetadata_MomentEdits_TextOverlay.decode(v5))
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
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

function class3:jsonEncode()
	local v2 = {}

	if self.music ~= nil then
		v2.music = self.music:jsonEncode()
	end

	if self.trim ~= nil then
		v2.trim = self.trim:jsonEncode()
	end

	if self.text_overlays == nil or not (#self.text_overlays > 0) then
		return v2
	end

	local textOverlays = {}

	for _, text_overlay in self.text_overlays do
		table.insert(textOverlays, text_overlay:jsonEncode())
	end

	v2.textOverlays = textOverlays

	return v2
end

function class3.jsonDecode(data)
	local v2 = class3.new()

	if data.music ~= nil then
		v2.music = v.MomentData_MomentMetadata_MomentEdits_MusicEdit.jsonDecode(data.music)
	end

	if data.trim ~= nil then
		v2.trim = v.MomentData_MomentMetadata_MomentEdits_TrimEdit.jsonDecode(data.trim)
	end

	if data.text_overlays ~= nil then
		local text_overlays = {}

		for _, text_overlay in data.text_overlays do
			table.insert(text_overlays, v.MomentData_MomentMetadata_MomentEdits_TextOverlay.jsonDecode(text_overlay))
		end

		v2.text_overlays = text_overlays
	end

	if data.textOverlays == nil then
		return v2
	end

	local text_overlays = {}

	for _, textOverlay in data.textOverlays do
		table.insert(text_overlays, v.MomentData_MomentMetadata_MomentEdits_TextOverlay.jsonDecode(textOverlay))
	end

	v2.text_overlays = text_overlays

	return v2
end

class3.descriptor = {
	name = "MomentData_MomentMetadata_MomentEdits",
	fullName = "roblox.apppageplatform.shared.v1beta1.MomentEdits"
}

v.MomentData_MomentMetadata_MomentEdits = class3

typeRegistry.default:register(v.MomentData_MomentMetadata_MomentEdits)

local class4 = {}
class4.__index = class4

function class4.new(p)
	local asset_id

	if not (p == nil or p.asset_id == nil) then
		asset_id = p.asset_id
	end

	local start_time_seconds

	if not (p == nil or p.start_time_seconds == nil) then
		start_time_seconds = p.start_time_seconds
	end

	return (setmetatable({ asset_id = asset_id, start_time_seconds = start_time_seconds }, class4))
end

function class4:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.asset_id ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.asset_id)
	end

	if self.start_time_seconds ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.i32)
		v2, v3 = proto.writeFloat(v4, v5, self.start_time_seconds)
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class4.decode(buf: buffer)
	local result = class4.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.asset_id = buffer.tostring(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			if v3 == 2 then
				local start_time_seconds
				start_time_seconds, v2 = proto.readFloat(buf, v2)
				result.start_time_seconds = start_time_seconds
			else
				local _
				_, v2 = proto.readFixed32(buf, v2)
			end
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class4:jsonEncode()
	local v2 = {}

	if self.asset_id ~= nil then
		v2.assetId = self.asset_id
	end

	if self.start_time_seconds ~= nil then
		v2.startTimeSeconds = proto.json.serializeNumber(self.start_time_seconds)
	end

	return v2
end

function class4.jsonDecode(data)
	local v2 = class4.new()

	if data.asset_id ~= nil then
		v2.asset_id = data.asset_id
	end

	if data.assetId ~= nil then
		v2.asset_id = data.assetId
	end

	if data.start_time_seconds ~= nil then
		v2.start_time_seconds = proto.json.deserializeNumber(data.start_time_seconds)
	end

	if data.startTimeSeconds ~= nil then
		v2.start_time_seconds = proto.json.deserializeNumber(data.startTimeSeconds)
	end

	return v2
end

class4.descriptor = {
	name = "MomentData_MomentMetadata_MomentEdits_MusicEdit",
	fullName = "roblox.apppageplatform.shared.v1beta1.MusicEdit"
}

v.MomentData_MomentMetadata_MomentEdits_MusicEdit = class4

typeRegistry.default:register(v.MomentData_MomentMetadata_MomentEdits_MusicEdit)

local class5 = {}
class5.__index = class5

function class5.new(p)
	local start_time_seconds

	if not (p == nil or p.start_time_seconds == nil) then
		start_time_seconds = p.start_time_seconds
	end

	local end_time_seconds

	if not (p == nil or p.end_time_seconds == nil) then
		end_time_seconds = p.end_time_seconds
	end

	return (setmetatable({
		start_time_seconds = start_time_seconds,
		end_time_seconds = end_time_seconds
	}, class5))
end

function class5:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.start_time_seconds ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.i32)
		v2, v3 = proto.writeFloat(v4, v5, self.start_time_seconds)
	end

	if self.end_time_seconds ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.i32)
		v2, v3 = proto.writeFloat(v4, v5, self.end_time_seconds)
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class5.decode(buf: buffer)
	local result = class5.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			local varInt, v5 = proto.readVarInt(buf, v2)

			v2 = v5 + varInt
		elseif v4 == proto.wireTypes.i32 then
			if v3 == 1 then
				local start_time_seconds
				start_time_seconds, v2 = proto.readFloat(buf, v2)
				result.start_time_seconds = start_time_seconds
			elseif v3 == 2 then
				local end_time_seconds
				end_time_seconds, v2 = proto.readFloat(buf, v2)
				result.end_time_seconds = end_time_seconds
			else
				local _
				_, v2 = proto.readFixed32(buf, v2)
			end
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class5:jsonEncode()
	local v2 = {}

	if self.start_time_seconds ~= nil then
		v2.startTimeSeconds = proto.json.serializeNumber(self.start_time_seconds)
	end

	if self.end_time_seconds ~= nil then
		v2.endTimeSeconds = proto.json.serializeNumber(self.end_time_seconds)
	end

	return v2
end

function class5.jsonDecode(data)
	local v2 = class5.new()

	if data.start_time_seconds ~= nil then
		v2.start_time_seconds = proto.json.deserializeNumber(data.start_time_seconds)
	end

	if data.startTimeSeconds ~= nil then
		v2.start_time_seconds = proto.json.deserializeNumber(data.startTimeSeconds)
	end

	if data.end_time_seconds ~= nil then
		v2.end_time_seconds = proto.json.deserializeNumber(data.end_time_seconds)
	end

	if data.endTimeSeconds ~= nil then
		v2.end_time_seconds = proto.json.deserializeNumber(data.endTimeSeconds)
	end

	return v2
end

class5.descriptor = {
	name = "MomentData_MomentMetadata_MomentEdits_TrimEdit",
	fullName = "roblox.apppageplatform.shared.v1beta1.TrimEdit"
}

v.MomentData_MomentMetadata_MomentEdits_TrimEdit = class5

typeRegistry.default:register(v.MomentData_MomentMetadata_MomentEdits_TrimEdit)

local class6 = {}
class6.__index = class6

function class6.new(data)
	local v2 = {
		position = (data == nil or data.position == nil) and {} or data.position,
		rotation = 0,
		scale = 0,
		text = 0,
		style = 0,
		z_index = 0
	}
	local rotation

	if not (data == nil or data.rotation == nil) then
		rotation = data.rotation
	end

	v2.rotation = rotation
	local scale

	if not (data == nil or data.scale == nil) then
		scale = data.scale
	end

	v2.scale = scale
	local text

	if not (data == nil or data.text == nil) then
		text = data.text
	end

	v2.text = text
	local style

	if not (data == nil or data.style == nil) then
		style = data.style
	end

	v2.style = style
	local z_index

	if not (data == nil or data.z_index == nil) then
		z_index = data.z_index
	end

	v2.z_index = z_index
	return (setmetatable(v2, class6))
end

function class6:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.position ~= nil and #self.position > 0 then
		local buf = buffer.create(0)
		local v4 = 0

		for _, v5 in self.position do
			buf, v4 = proto.writeFloat(buf, v4, v5)
		end

		local v5, v6 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v5, v6, buf, v4)
	end

	if self.rotation ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.i32)
		v2, v3 = proto.writeFloat(v4, v5, self.rotation)
	end

	if self.scale ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.i32)
		v2, v3 = proto.writeFloat(v4, v5, self.scale)
	end

	if self.text ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.text)
	end

	if self.style ~= nil then
		local encoded = self.style:encode()
		local v4, v5 = proto.writeTag(v2, v3, 5, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.z_index ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 6, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.z_index)
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class6.decode(buf: buffer)
	local result = class6.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			if v3 == 6 then
				local z_index
				z_index, v2 = proto.readVarIntI32(buf, v2)
				result.z_index = z_index
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)

				local v6 = v2 + v5

				while v2 < v6 do
					local v7
					v7, v2 = proto.readFloat(buf, v2)
					table.insert(result.position, v7)
				end
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.text = buffer.tostring(v5)
			elseif v3 == 5 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.style = v.MomentData_MomentMetadata_MomentEdits_TextOverlay_Style.decode(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readFloat(buf, v2)
				table.insert(result.position, v5)
			elseif v3 == 2 then
				local rotation
				rotation, v2 = proto.readFloat(buf, v2)
				result.rotation = rotation
			elseif v3 == 3 then
				local scale
				scale, v2 = proto.readFloat(buf, v2)
				result.scale = scale
			else
				local _
				_, v2 = proto.readFixed32(buf, v2)
			end
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class6:jsonEncode()
	local v2 = {}

	if self.position ~= nil and #self.position > 0 then
		local position = {}

		for _, v3 in self.position do
			table.insert(position, proto.json.serializeNumber(v3))
		end

		v2.position = position
	end

	if self.rotation ~= nil then
		v2.rotation = proto.json.serializeNumber(self.rotation)
	end

	if self.scale ~= nil then
		v2.scale = proto.json.serializeNumber(self.scale)
	end

	if self.text ~= nil then
		v2.text = self.text
	end

	if self.style ~= nil then
		v2.style = self.style:jsonEncode()
	end

	if self.z_index ~= nil then
		v2.zIndex = self.z_index
	end

	return v2
end

function class6.jsonDecode(data)
	local v2 = class6.new()

	if data.position ~= nil then
		local position = {}

		for _, v3 in data.position do
			table.insert(position, proto.json.deserializeNumber(v3))
		end

		v2.position = position
	end

	if data.rotation ~= nil then
		v2.rotation = proto.json.deserializeNumber(data.rotation)
	end

	if data.scale ~= nil then
		v2.scale = proto.json.deserializeNumber(data.scale)
	end

	if data.text ~= nil then
		v2.text = data.text
	end

	if data.style ~= nil then
		v2.style = v.MomentData_MomentMetadata_MomentEdits_TextOverlay_Style.jsonDecode(data.style)
	end

	if data.z_index ~= nil then
		v2.z_index = data.z_index
	end

	if data.zIndex ~= nil then
		v2.z_index = data.zIndex
	end

	return v2
end

class6.descriptor = {
	name = "MomentData_MomentMetadata_MomentEdits_TextOverlay",
	fullName = "roblox.apppageplatform.shared.v1beta1.TextOverlay"
}

v.MomentData_MomentMetadata_MomentEdits_TextOverlay = class6

typeRegistry.default:register(v.MomentData_MomentMetadata_MomentEdits_TextOverlay)

local class7 = {}
class7.__index = class7

function class7.new(data)
	local font

	if not (data == nil or data.font == nil) then
		font = data.font
	end

	local v2 = {
		font = font,
		font_color = (data == nil or data.font_color == nil) and {} or data.font_color,
		font_size = 0,
		text_x_alignment = 0
	}
	local font_size

	if not (data == nil or data.font_size == nil) then
		font_size = data.font_size
	end

	v2.font_size = font_size
	local text_x_alignment

	if not (data == nil or data.text_x_alignment == nil) then
		text_x_alignment = data.text_x_alignment
	end

	v2.text_x_alignment = text_x_alignment
	return (setmetatable(v2, class7))
end

function class7:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.font ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.font)
	end

	if self.font_color ~= nil and #self.font_color > 0 then
		local buf = buffer.create(0)
		local v4 = 0

		for _, v5 in self.font_color do
			buf, v4 = proto.writeFloat(buf, v4, v5)
		end

		local v5, v6 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v5, v6, buf, v4)
	end

	if self.font_size ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.i32)
		v2, v3 = proto.writeFloat(v4, v5, self.font_size)
	end

	if self.text_x_alignment ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.text_x_alignment)
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class7.decode(buf: buffer)
	local result = class7.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.font = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)

				local v6 = v2 + v5

				while v2 < v6 do
					local v7
					v7, v2 = proto.readFloat(buf, v2)
					table.insert(result.font_color, v7)
				end
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.text_x_alignment = buffer.tostring(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readFloat(buf, v2)
				table.insert(result.font_color, v5)
			elseif v3 == 3 then
				local font_size
				font_size, v2 = proto.readFloat(buf, v2)
				result.font_size = font_size
			else
				local _
				_, v2 = proto.readFixed32(buf, v2)
			end
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class7:jsonEncode()
	local v2 = {}

	if self.font ~= nil then
		v2.font = self.font
	end

	if self.font_color ~= nil and #self.font_color > 0 then
		local fontColor = {}

		for _, v3 in self.font_color do
			table.insert(fontColor, proto.json.serializeNumber(v3))
		end

		v2.fontColor = fontColor
	end

	if self.font_size ~= nil then
		v2.fontSize = proto.json.serializeNumber(self.font_size)
	end

	if self.text_x_alignment ~= nil then
		v2.textXAlignment = self.text_x_alignment
	end

	return v2
end

function class7.jsonDecode(data)
	local v2 = class7.new()

	if data.font ~= nil then
		v2.font = data.font
	end

	if data.font_color ~= nil then
		local font_color = {}

		for _, v3 in data.font_color do
			table.insert(font_color, proto.json.deserializeNumber(v3))
		end

		v2.font_color = font_color
	end

	if data.fontColor ~= nil then
		local font_color = {}

		for _, v3 in data.fontColor do
			table.insert(font_color, proto.json.deserializeNumber(v3))
		end

		v2.font_color = font_color
	end

	if data.font_size ~= nil then
		v2.font_size = proto.json.deserializeNumber(data.font_size)
	end

	if data.fontSize ~= nil then
		v2.font_size = proto.json.deserializeNumber(data.fontSize)
	end

	if data.text_x_alignment ~= nil then
		v2.text_x_alignment = data.text_x_alignment
	end

	if data.textXAlignment ~= nil then
		v2.text_x_alignment = data.textXAlignment
	end

	return v2
end

class7.descriptor = {
	name = "MomentData_MomentMetadata_MomentEdits_TextOverlay_Style",
	fullName = "roblox.apppageplatform.shared.v1beta1.Style"
}

v.MomentData_MomentMetadata_MomentEdits_TextOverlay_Style = class7

typeRegistry.default:register(v.MomentData_MomentMetadata_MomentEdits_TextOverlay_Style)

return {
	MomentData = v.MomentData,
	MomentData_MomentMetadata = v.MomentData_MomentMetadata,
	MomentData_MomentMetadata_MomentEdits = v.MomentData_MomentMetadata_MomentEdits,
	MomentData_MomentMetadata_MomentEdits_MusicEdit = v.MomentData_MomentMetadata_MomentEdits_MusicEdit,
	MomentData_MomentMetadata_MomentEdits_TrimEdit = v.MomentData_MomentMetadata_MomentEdits_TrimEdit,
	MomentData_MomentMetadata_MomentEdits_TextOverlay = v.MomentData_MomentMetadata_MomentEdits_TextOverlay,
	MomentData_MomentMetadata_MomentEdits_TextOverlay_Style = v.MomentData_MomentMetadata_MomentEdits_TextOverlay_Style
}
