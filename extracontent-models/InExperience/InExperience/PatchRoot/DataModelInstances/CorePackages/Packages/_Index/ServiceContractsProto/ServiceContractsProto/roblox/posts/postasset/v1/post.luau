local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local duration = require(script.Parent.Parent.Parent.Parent.Parent.google.protobuf.duration)

local class = {}
class.__index = class

function class.new(p)
	local metadata

	if not (p == nil or p.metadata == nil) then
		metadata = p.metadata
	end

	local v2 = {
		metadata = metadata,
		tracks = (p == nil or p.tracks == nil) and {} or p.tracks
	}
	return (setmetatable(v2, class))
end

function class:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.metadata ~= nil then
		local encoded = self.metadata:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.tracks ~= nil and #self.tracks > 0 then
		for _, track in self.tracks do
			local encoded = track:encode()
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
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
				result.metadata = v.PostMetadata.decode(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				table.insert(result.tracks, v.Track.decode(v5))
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

	if self.metadata ~= nil then
		v2.metadata = self.metadata:jsonEncode()
	end

	if self.tracks == nil or not (#self.tracks > 0) then
		return v2
	end

	local tracks = {}

	for _, track in self.tracks do
		table.insert(tracks, track:jsonEncode())
	end

	v2.tracks = tracks

	return v2
end

function class.jsonDecode(p)
	local v2 = class.new()

	if p.metadata ~= nil then
		v2.metadata = v.PostMetadata.jsonDecode(p.metadata)
	end

	if p.tracks == nil then
		return v2
	end

	local tracks = {}

	for _, track in p.tracks do
		table.insert(tracks, v.Track.jsonDecode(track))
	end

	v2.tracks = tracks

	return v2
end

class.descriptor = { name = "Post", fullName = "roblox.posts.postasset.v1.Post" }

v.Post = class

typeRegistry.default:register(v.Post)

local class2 = {}
class2.__index = class2

function class2.new(data)
	local origin

	if data == nil or data.origin == nil then
		origin = assert(v.PostOrigin.fromNumber(0), "Enum has no 0 default")
	else
		origin = data.origin
	end

	local v2 = {
		origin = origin,
		caption = (data == nil or data.caption == nil) and "" or data.caption,
		total_duration = 0,
		content_language = 0
	}
	local total_duration

	if not (data == nil or data.total_duration == nil) then
		total_duration = data.total_duration
	end

	v2.total_duration = total_duration
	v2.content_language = (data == nil or data.content_language == nil) and "" or data.content_language
	return (setmetatable(v2, class2))
end

function class2:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if
		self.origin ~= nil
		and (self.origin ~= nil and self.origin ~= 0 or self.origin ~= v.PostOrigin.fromNumber(0))
	then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, v.PostOrigin.toNumber(self.origin))
	end

	if self.caption ~= nil and self.caption ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.caption)
	end

	if self.total_duration ~= nil then
		local encoded = self.total_duration:encode()
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.content_language ~= nil and self.content_language ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.content_language)
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
			if v3 == 1 then
				local v5
				v5, v2 = proto.readVarIntI32(buf, v2)
				result.origin = v.PostOrigin.fromNumber(v5) or v5
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.caption = buffer.tostring(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.total_duration = duration.Duration.decode(v5)
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.content_language = buffer.tostring(v5)
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

function class2:jsonEncode()
	local v2 = {}

	if
		self.origin ~= nil
		and (self.origin ~= nil and self.origin ~= 0 or self.origin ~= v.PostOrigin.fromNumber(0))
	then
		local origin

		if typeof(self.origin) == "number" then
			origin = self.origin
		else
			origin = v.PostOrigin.toNumber(self.origin)
		end

		v2.origin = origin
	end

	if self.caption ~= nil and self.caption ~= "" then
		v2.caption = self.caption
	end

	if self.total_duration ~= nil then
		v2.totalDuration = self.total_duration:jsonEncode()
	end

	if self.content_language ~= nil and self.content_language ~= "" then
		v2.contentLanguage = self.content_language
	end

	return v2
end

function class2.jsonDecode(data)
	local v2 = class2.new()

	if data.origin ~= nil then
		local origin

		if typeof(data.origin) == "number" then
			origin = v.PostOrigin.fromNumber(data.origin) or data.origin
		else
			origin = v.PostOrigin.fromName(data.origin) or data.origin
		end

		v2.origin = origin
	end

	if data.caption ~= nil then
		v2.caption = data.caption
	end

	if data.total_duration ~= nil then
		v2.total_duration = duration.Duration.jsonDecode(data.total_duration)
	end

	if data.totalDuration ~= nil then
		v2.total_duration = duration.Duration.jsonDecode(data.totalDuration)
	end

	if data.content_language ~= nil then
		v2.content_language = data.content_language
	end

	if data.contentLanguage ~= nil then
		v2.content_language = data.contentLanguage
	end

	return v2
end

class2.descriptor = { name = "PostMetadata", fullName = "roblox.posts.postasset.v1.PostMetadata" }

v.PostMetadata = class2

typeRegistry.default:register(v.PostMetadata)

local class3 = {}
class3.__index = class3

function class3.new(p)
	local v3

	if p == nil or p.type == nil then
		v3 = assert(v.TrackType.fromNumber(0), "Enum has no 0 default")
	else
		v3 = p.type
	end

	local v2 = {
		type = v3,
		slots = (p == nil or p.slots == nil) and {} or p.slots
	}
	return (setmetatable(v2, class3))
end

function class3:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.type ~= nil and (self.type ~= nil and self.type ~= 0 or self.type ~= v.TrackType.fromNumber(0)) then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, v.TrackType.toNumber(self.type))
	end

	if self.slots ~= nil and #self.slots > 0 then
		for _, slot in self.slots do
			local encoded = slot:encode()
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
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
			if v3 == 1 then
				local v5
				v5, v2 = proto.readVarIntI32(buf, v2)
				result.type = v.TrackType.fromNumber(v5) or v5
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				table.insert(result.slots, v.Slot.decode(v5))
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

	if self.type ~= nil and (self.type ~= nil and self.type ~= 0 or self.type ~= v.TrackType.fromNumber(0)) then
		local v3

		if typeof(self.type) == "number" then
			v3 = self.type
		else
			v3 = v.TrackType.toNumber(self.type)
		end

		v2.type = v3
	end

	if self.slots == nil or not (#self.slots > 0) then
		return v2
	end

	local slots = {}

	for _, slot in self.slots do
		table.insert(slots, slot:jsonEncode())
	end

	v2.slots = slots

	return v2
end

function class3.jsonDecode(p)
	local v2 = class3.new()

	if p.type ~= nil then
		local v3

		if typeof(p.type) == "number" then
			v3 = v.TrackType.fromNumber(p.type) or p.type
		else
			v3 = v.TrackType.fromName(p.type) or p.type
		end

		v2.type = v3
	end

	if p.slots == nil then
		return v2
	end

	local slots = {}

	for _, slot in p.slots do
		table.insert(slots, v.Slot.jsonDecode(slot))
	end

	v2.slots = slots

	return v2
end

class3.descriptor = { name = "Track", fullName = "roblox.posts.postasset.v1.Track" }

v.Track = class3

typeRegistry.default:register(v.Track)

local class4 = {}
class4.__index = class4

function class4.new(data)
	local v2 = {
		slot_id = (data == nil or data.slot_id == nil) and "" or data.slot_id,
		time_range = 0,
		content = 0
	}
	local time_range

	if not (data == nil or data.time_range == nil) then
		time_range = data.time_range
	end

	v2.time_range = time_range
	local content

	if not (data == nil or data.content == nil) then
		content = data.content
	end

	v2.content = content
	return (setmetatable(v2, class4))
end

function class4:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.slot_id ~= nil and self.slot_id ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.slot_id)
	end

	if self.time_range ~= nil then
		local encoded = self.time_range:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.content ~= nil then
		if self.content.type == "visual" then
			local encoded = self.content.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 10, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.content.type == "audio" then
			local encoded = self.content.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 11, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.content.type == "experience_annotation" then
			local encoded = self.content.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 12, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.content.type == "avatar_annotation" then
			local encoded = self.content.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 13, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
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
				result.slot_id = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.time_range = v.TimeRange.decode(v5)
			elseif v3 == 10 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.content = { type = "visual", value = v.VisualSlot.decode(v5) }
			elseif v3 == 11 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.content = { type = "audio", value = v.AudioSlot.decode(v5) }
			elseif v3 == 12 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.content = {
					type = "experience_annotation",
					value = v.ExperienceAnnotationSlot.decode(v5)
				}
			elseif v3 == 13 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.content = {
					type = "avatar_annotation",
					value = v.AvatarAnnotationSlot.decode(v5)
				}
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

function class4:jsonEncode()
	local v2 = {}

	if self.slot_id ~= nil and self.slot_id ~= "" then
		v2.slotId = self.slot_id
	end

	if self.time_range ~= nil then
		v2.timeRange = self.time_range:jsonEncode()
	end

	if self.content == nil then
		return v2
	end

	if self.content.type == "visual" then
		v2.visual = self.content.value:jsonEncode()
		return v2
	end

	if self.content.type == "audio" then
		v2.audio = self.content.value:jsonEncode()
		return v2
	end

	if self.content.type == "experience_annotation" then
		v2.experienceAnnotation = self.content.value:jsonEncode()
		return v2
	elseif self.content.type == "avatar_annotation" then
		v2.avatarAnnotation = self.content.value:jsonEncode()
	end

	return v2
end

function class4.jsonDecode(data)
	local v2 = class4.new()

	if data.slot_id ~= nil then
		v2.slot_id = data.slot_id
	end

	if data.slotId ~= nil then
		v2.slot_id = data.slotId
	end

	if data.time_range ~= nil then
		v2.time_range = v.TimeRange.jsonDecode(data.time_range)
	end

	if data.timeRange ~= nil then
		v2.time_range = v.TimeRange.jsonDecode(data.timeRange)
	end

	if data.visual ~= nil then
		v2.content = {
			type = "visual",
			value = v.VisualSlot.jsonDecode(data.visual)
		}
	end

	if data.audio ~= nil then
		v2.content = {
			type = "audio",
			value = v.AudioSlot.jsonDecode(data.audio)
		}
	end

	if data.experience_annotation ~= nil then
		v2.content = {
			type = "experience_annotation",
			value = v.ExperienceAnnotationSlot.jsonDecode(data.experience_annotation)
		}
	end

	if data.experienceAnnotation ~= nil then
		v2.content = {
			type = "experience_annotation",
			value = v.ExperienceAnnotationSlot.jsonDecode(data.experienceAnnotation)
		}
	end

	if data.avatar_annotation ~= nil then
		v2.content = {
			type = "avatar_annotation",
			value = v.AvatarAnnotationSlot.jsonDecode(data.avatar_annotation)
		}
	end

	if data.avatarAnnotation ~= nil then
		v2.content = {
			type = "avatar_annotation",
			value = v.AvatarAnnotationSlot.jsonDecode(data.avatarAnnotation)
		}
	end

	return v2
end

class4.descriptor = { name = "Slot", fullName = "roblox.posts.postasset.v1.Slot" }

v.Slot = class4

typeRegistry.default:register(v.Slot)

local class5 = {}
class5.__index = class5

function class5.new(data)
	local v2 = {
		z_index = (data == nil or data.z_index == nil) and 0 or data.z_index,
		transform = 0,
		content = 0
	}
	local transform

	if not (data == nil or data.transform == nil) then
		transform = data.transform
	end

	v2.transform = transform
	local content

	if not (data == nil or data.content == nil) then
		content = data.content
	end

	v2.content = content
	return (setmetatable(v2, class5))
end

function class5:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.z_index ~= nil and self.z_index ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.z_index)
	end

	if self.transform ~= nil then
		local encoded = self.transform:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.content ~= nil then
		if self.content.type == "video" then
			local encoded = self.content.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 10, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.content.type == "image" then
			local encoded = self.content.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 11, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.content.type == "text_label" then
			local encoded = self.content.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 12, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		elseif self.content.type == "scene" then
			local encoded = self.content.value:encode()
			local v4, v5 = proto.writeTag(v2, v3, 13, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
		end
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
			if v3 == 1 then
				local z_index
				z_index, v2 = proto.readVarIntI32(buf, v2)
				result.z_index = z_index
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.transform = v.Transform.decode(v5)
			elseif v3 == 10 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.content = { type = "video", value = v.VideoSlot.decode(v5) }
			elseif v3 == 11 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.content = { type = "image", value = v.ImageSlot.decode(v5) }
			elseif v3 == 12 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.content = { type = "text_label", value = v.TextLabelSlot.decode(v5) }
			elseif v3 == 13 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.content = { type = "scene", value = v.SceneSlot.decode(v5) }
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

function class5:jsonEncode()
	local v2 = {}

	if self.z_index ~= nil and self.z_index ~= 0 then
		v2.zIndex = self.z_index
	end

	if self.transform ~= nil then
		v2.transform = self.transform:jsonEncode()
	end

	if self.content == nil then
		return v2
	end

	if self.content.type == "video" then
		v2.video = self.content.value:jsonEncode()
		return v2
	end

	if self.content.type == "image" then
		v2.image = self.content.value:jsonEncode()
		return v2
	end

	if self.content.type == "text_label" then
		v2.textLabel = self.content.value:jsonEncode()
		return v2
	elseif self.content.type == "scene" then
		v2.scene = self.content.value:jsonEncode()
	end

	return v2
end

function class5.jsonDecode(data)
	local v2 = class5.new()

	if data.z_index ~= nil then
		v2.z_index = data.z_index
	end

	if data.zIndex ~= nil then
		v2.z_index = data.zIndex
	end

	if data.transform ~= nil then
		v2.transform = v.Transform.jsonDecode(data.transform)
	end

	if data.video ~= nil then
		v2.content = {
			type = "video",
			value = v.VideoSlot.jsonDecode(data.video)
		}
	end

	if data.image ~= nil then
		v2.content = {
			type = "image",
			value = v.ImageSlot.jsonDecode(data.image)
		}
	end

	if data.text_label ~= nil then
		v2.content = {
			type = "text_label",
			value = v.TextLabelSlot.jsonDecode(data.text_label)
		}
	end

	if data.textLabel ~= nil then
		v2.content = {
			type = "text_label",
			value = v.TextLabelSlot.jsonDecode(data.textLabel)
		}
	end

	if data.scene ~= nil then
		v2.content = {
			type = "scene",
			value = v.SceneSlot.jsonDecode(data.scene)
		}
	end

	return v2
end

class5.descriptor = { name = "VisualSlot", fullName = "roblox.posts.postasset.v1.VisualSlot" }

v.VisualSlot = class5

typeRegistry.default:register(v.VisualSlot)

local class6 = {}
class6.__index = class6

function class6.new(p)
	local v2 = {
		asset_id = (p == nil or p.asset_id == nil) and 0 or p.asset_id,
		trim = 0
	}
	local trim

	if not (p == nil or p.trim == nil) then
		trim = p.trim
	end

	v2.trim = trim
	return (setmetatable(v2, class6))
end

function class6:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.asset_id ~= nil and self.asset_id ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.asset_id)
	end

	if self.trim ~= nil then
		local encoded = self.trim:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
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
			if v3 == 1 then
				local asset_id
				asset_id, v2 = proto.readVarIntI64(buf, v2)
				result.asset_id = asset_id
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.trim = v.TimeRange.decode(v5)
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

function class6:jsonEncode()
	local v2 = {}

	if self.asset_id ~= nil and self.asset_id ~= 0 then
		v2.assetId = self.asset_id
	end

	if self.trim ~= nil then
		v2.trim = self.trim:jsonEncode()
	end

	return v2
end

function class6.jsonDecode(data)
	local v2 = class6.new()

	if data.asset_id ~= nil then
		v2.asset_id = data.asset_id
	end

	if data.assetId ~= nil then
		v2.asset_id = data.assetId
	end

	if data.trim ~= nil then
		v2.trim = v.TimeRange.jsonDecode(data.trim)
	end

	return v2
end

class6.descriptor = { name = "VideoSlot", fullName = "roblox.posts.postasset.v1.VideoSlot" }

v.VideoSlot = class6

typeRegistry.default:register(v.VideoSlot)

local class7 = {}
class7.__index = class7

function class7.new(p)
	return (setmetatable({
		asset_id = (p == nil or p.asset_id == nil) and 0 or p.asset_id
	}, class7))
end

function class7:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.asset_id ~= nil and self.asset_id ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.asset_id)
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
			if v3 == 1 then
				local asset_id
				asset_id, v2 = proto.readVarIntI64(buf, v2)
				result.asset_id = asset_id
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

function class7:jsonEncode()
	local v2 = {}

	if self.asset_id ~= nil and self.asset_id ~= 0 then
		v2.assetId = self.asset_id
	end

	return v2
end

function class7.jsonDecode(p)
	local v2 = class7.new()

	if p.asset_id ~= nil then
		v2.asset_id = p.asset_id
	end

	if p.assetId ~= nil then
		v2.asset_id = p.assetId
	end

	return v2
end

class7.descriptor = { name = "ImageSlot", fullName = "roblox.posts.postasset.v1.ImageSlot" }

v.ImageSlot = class7

typeRegistry.default:register(v.ImageSlot)

local class8 = {}
class8.__index = class8

function class8.new(data)
	local v2 = {
		text = (data == nil or data.text == nil) and "" or data.text,
		font = 0,
		text_x_alignment = 0,
		font_color = 0,
		font_size = 0
	}
	local font

	if not (data == nil or data.font == nil) then
		font = data.font
	end

	v2.font = font
	local text_x_alignment

	if data == nil or data.text_x_alignment == nil then
		text_x_alignment = assert(v.TextXAlignment.fromNumber(0), "Enum has no 0 default")
	else
		text_x_alignment = data.text_x_alignment
	end

	v2.text_x_alignment = text_x_alignment
	local font_color

	if not (data == nil or data.font_color == nil) then
		font_color = data.font_color
	end

	v2.font_color = font_color
	v2.font_size = (data == nil or data.font_size == nil) and 0 or data.font_size
	return (setmetatable(v2, class8))
end

function class8:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.text ~= nil and self.text ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.text)
	end

	if self.font ~= nil then
		local encoded = self.font:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if
		self.text_x_alignment ~= nil
		and (self.text_x_alignment ~= nil and self.text_x_alignment ~= 0 or self.text_x_alignment ~= v.TextXAlignment.fromNumber(0))
	then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.varint)

		v2, v3 = proto.writeVarInt(v4, v5, v.TextXAlignment.toNumber(self.text_x_alignment))
	end

	if self.font_color ~= nil then
		local encoded = self.font_color:encode()
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.font_size ~= nil and self.font_size ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 5, proto.wireTypes.i32)
		v2, v3 = proto.writeFloat(v4, v5, self.font_size)
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class8.decode(buf: buffer)
	local result = class8.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			if v3 == 3 then
				local v5
				v5, v2 = proto.readVarIntI32(buf, v2)
				result.text_x_alignment = v.TextXAlignment.fromNumber(v5) or v5
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.text = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.font = v.FontInfo.decode(v5)
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.font_color = v.Color3.decode(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			if v3 == 5 then
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

function class8:jsonEncode()
	local v2 = {}

	if self.text ~= nil and self.text ~= "" then
		v2.text = self.text
	end

	if self.font ~= nil then
		v2.font = self.font:jsonEncode()
	end

	if
		self.text_x_alignment ~= nil
		and (self.text_x_alignment ~= nil and self.text_x_alignment ~= 0 or self.text_x_alignment ~= v.TextXAlignment.fromNumber(0))
	then
		local textXAlignment

		if typeof(self.text_x_alignment) == "number" then
			textXAlignment = self.text_x_alignment
		else
			textXAlignment = v.TextXAlignment.toNumber(self.text_x_alignment)
		end

		v2.textXAlignment = textXAlignment
	end

	if self.font_color ~= nil then
		v2.fontColor = self.font_color:jsonEncode()
	end

	if self.font_size ~= nil and self.font_size ~= 0 then
		v2.fontSize = proto.json.serializeNumber(self.font_size)
	end

	return v2
end

function class8.jsonDecode(data)
	local v2 = class8.new()

	if data.text ~= nil then
		v2.text = data.text
	end

	if data.font ~= nil then
		v2.font = v.FontInfo.jsonDecode(data.font)
	end

	if data.text_x_alignment ~= nil then
		local text_x_alignment

		if typeof(data.text_x_alignment) == "number" then
			text_x_alignment = v.TextXAlignment.fromNumber(data.text_x_alignment) or data.text_x_alignment
		else
			text_x_alignment = v.TextXAlignment.fromName(data.text_x_alignment) or data.text_x_alignment
		end

		v2.text_x_alignment = text_x_alignment
	end

	if data.textXAlignment ~= nil then
		local text_x_alignment

		if typeof(data.textXAlignment) == "number" then
			text_x_alignment = v.TextXAlignment.fromNumber(data.textXAlignment) or data.textXAlignment
		else
			text_x_alignment = v.TextXAlignment.fromName(data.textXAlignment) or data.textXAlignment
		end

		v2.text_x_alignment = text_x_alignment
	end

	if data.font_color ~= nil then
		v2.font_color = v.Color3.jsonDecode(data.font_color)
	end

	if data.fontColor ~= nil then
		v2.font_color = v.Color3.jsonDecode(data.fontColor)
	end

	if data.font_size ~= nil then
		v2.font_size = proto.json.deserializeNumber(data.font_size)
	end

	if data.fontSize ~= nil then
		v2.font_size = proto.json.deserializeNumber(data.fontSize)
	end

	return v2
end

class8.descriptor = { name = "TextLabelSlot", fullName = "roblox.posts.postasset.v1.TextLabelSlot" }

v.TextLabelSlot = class8

typeRegistry.default:register(v.TextLabelSlot)

local class9 = {}
class9.__index = class9

function class9.new(p)
	local v2 = {
		asset_id = (p == nil or p.asset_id == nil) and 0 or p.asset_id,
		rbxm_data = 0
	}
	local rbxm_data

	if p == nil or p.rbxm_data == nil then
		rbxm_data = buffer.create(0)
	else
		rbxm_data = p.rbxm_data
	end

	v2.rbxm_data = rbxm_data
	return (setmetatable(v2, class9))
end

function class9:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.asset_id ~= nil and self.asset_id ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.asset_id)
	end

	if self.rbxm_data ~= nil and buffer.len(self.rbxm_data) > 0 then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, self.rbxm_data, buffer.len(self.rbxm_data))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class9.decode(buf: buffer)
	local result = class9.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			if v3 == 1 then
				local asset_id
				asset_id, v2 = proto.readVarIntI64(buf, v2)
				result.asset_id = asset_id
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 2 then
				local rbxm_data
				rbxm_data, v2 = proto.readBuffer(buf, v2)
				result.rbxm_data = rbxm_data
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

function class9:jsonEncode()
	local v2 = {}

	if self.asset_id ~= nil and self.asset_id ~= 0 then
		v2.assetId = self.asset_id
	end

	if self.rbxm_data ~= nil and buffer.len(self.rbxm_data) > 0 then
		v2.rbxmData = proto.json.serializeBuffer(self.rbxm_data)
	end

	return v2
end

function class9.jsonDecode(data)
	local v2 = class9.new()

	if data.asset_id ~= nil then
		v2.asset_id = data.asset_id
	end

	if data.assetId ~= nil then
		v2.asset_id = data.assetId
	end

	if data.rbxm_data ~= nil then
		v2.rbxm_data = proto.json.deserializeBuffer(data.rbxm_data)
	end

	if data.rbxmData ~= nil then
		v2.rbxm_data = proto.json.deserializeBuffer(data.rbxmData)
	end

	return v2
end

class9.descriptor = { name = "SceneSlot", fullName = "roblox.posts.postasset.v1.SceneSlot" }

v.SceneSlot = class9

typeRegistry.default:register(v.SceneSlot)

local class10 = {}
class10.__index = class10

function class10.new(data)
	local v2 = {
		asset_id = (data == nil or data.asset_id == nil) and 0 or data.asset_id,
		trim = 0,
		audio_type = 0,
		source_trim = 0,
		context = 0
	}
	local trim

	if not (data == nil or data.trim == nil) then
		trim = data.trim
	end

	v2.trim = trim
	local audio_type

	if data == nil or data.audio_type == nil then
		audio_type = assert(v.AudioType.fromNumber(0), "Enum has no 0 default")
	else
		audio_type = data.audio_type
	end

	v2.audio_type = audio_type
	local source_trim

	if not (data == nil or data.source_trim == nil) then
		source_trim = data.source_trim
	end

	v2.source_trim = source_trim
	local context

	if not (data == nil or data.context == nil) then
		context = data.context
	end

	v2.context = context
	return (setmetatable(v2, class10))
end

function class10:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.asset_id ~= nil and self.asset_id ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.asset_id)
	end

	if self.trim ~= nil then
		local encoded = self.trim:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if
		self.audio_type ~= nil
		and (self.audio_type ~= nil and self.audio_type ~= 0 or self.audio_type ~= v.AudioType.fromNumber(0))
	then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, v.AudioType.toNumber(self.audio_type))
	end

	if self.source_trim ~= nil then
		local encoded = self.source_trim:encode()
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.context ~= nil and self.context.type == "tts" then
		local encoded = self.context.value:encode()
		local v4, v5 = proto.writeTag(v2, v3, 10, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class10.decode(buf: buffer)
	local result = class10.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			if v3 == 1 then
				local asset_id
				asset_id, v2 = proto.readVarIntI64(buf, v2)
				result.asset_id = asset_id
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readVarIntI32(buf, v2)
				result.audio_type = v.AudioType.fromNumber(v5) or v5
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.trim = v.TimeRange.decode(v5)
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.source_trim = v.TimeRange.decode(v5)
			elseif v3 == 10 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.context = { type = "tts", value = v.TtsAudioContext.decode(v5) }
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

function class10:jsonEncode()
	local v2 = {}

	if self.asset_id ~= nil and self.asset_id ~= 0 then
		v2.assetId = self.asset_id
	end

	if self.trim ~= nil then
		v2.trim = self.trim:jsonEncode()
	end

	if
		self.audio_type ~= nil
		and (self.audio_type ~= nil and self.audio_type ~= 0 or self.audio_type ~= v.AudioType.fromNumber(0))
	then
		local audioType

		if typeof(self.audio_type) == "number" then
			audioType = self.audio_type
		else
			audioType = v.AudioType.toNumber(self.audio_type)
		end

		v2.audioType = audioType
	end

	if self.source_trim ~= nil then
		v2.sourceTrim = self.source_trim:jsonEncode()
	end

	if self.context ~= nil and self.context.type == "tts" then
		v2.tts = self.context.value:jsonEncode()
	end

	return v2
end

function class10.jsonDecode(data)
	local v2 = class10.new()

	if data.asset_id ~= nil then
		v2.asset_id = data.asset_id
	end

	if data.assetId ~= nil then
		v2.asset_id = data.assetId
	end

	if data.trim ~= nil then
		v2.trim = v.TimeRange.jsonDecode(data.trim)
	end

	if data.audio_type ~= nil then
		local audio_type

		if typeof(data.audio_type) == "number" then
			audio_type = v.AudioType.fromNumber(data.audio_type) or data.audio_type
		else
			audio_type = v.AudioType.fromName(data.audio_type) or data.audio_type
		end

		v2.audio_type = audio_type
	end

	if data.audioType ~= nil then
		local audio_type

		if typeof(data.audioType) == "number" then
			audio_type = v.AudioType.fromNumber(data.audioType) or data.audioType
		else
			audio_type = v.AudioType.fromName(data.audioType) or data.audioType
		end

		v2.audio_type = audio_type
	end

	if data.source_trim ~= nil then
		v2.source_trim = v.TimeRange.jsonDecode(data.source_trim)
	end

	if data.sourceTrim ~= nil then
		v2.source_trim = v.TimeRange.jsonDecode(data.sourceTrim)
	end

	if data.tts ~= nil then
		v2.context = {
			type = "tts",
			value = v.TtsAudioContext.jsonDecode(data.tts)
		}
	end

	return v2
end

class10.descriptor = { name = "AudioSlot", fullName = "roblox.posts.postasset.v1.AudioSlot" }

v.AudioSlot = class10

typeRegistry.default:register(v.AudioSlot)

local class11 = {}
class11.__index = class11

function class11.new(data)
	return (setmetatable({
		text = (data == nil or data.text == nil) and "" or data.text,
		voice_id = (data == nil or data.voice_id == nil) and 0 or data.voice_id,
		pitch = (data == nil or data.pitch == nil) and 0 or data.pitch,
		speed = (data == nil or data.speed == nil) and 0 or data.speed
	}, class11))
end

function class11:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.text ~= nil and self.text ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.text)
	end

	if self.voice_id ~= nil and self.voice_id ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.voice_id)
	end

	if self.pitch ~= nil and self.pitch ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.i64)
		v2, v3 = proto.writeDouble(v4, v5, self.pitch)
	end

	if self.speed ~= nil and self.speed ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.i64)
		v2, v3 = proto.writeDouble(v4, v5, self.speed)
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class11.decode(buf: buffer)
	local result = class11.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			if v3 == 2 then
				local voice_id
				voice_id, v2 = proto.readVarIntI64(buf, v2)
				result.voice_id = voice_id
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.text = buffer.tostring(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			if v3 == 3 then
				local pitch
				pitch, v2 = proto.readDouble(buf, v2)
				result.pitch = pitch
			elseif v3 == 4 then
				local speed
				speed, v2 = proto.readDouble(buf, v2)
				result.speed = speed
			else
				local _
				_, v2 = proto.readFixed64(buf, v2)
			end
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class11:jsonEncode()
	local v2 = {}

	if self.text ~= nil and self.text ~= "" then
		v2.text = self.text
	end

	if self.voice_id ~= nil and self.voice_id ~= 0 then
		v2.voiceId = self.voice_id
	end

	if self.pitch ~= nil and self.pitch ~= 0 then
		v2.pitch = proto.json.serializeNumber(self.pitch)
	end

	if self.speed ~= nil and self.speed ~= 0 then
		v2.speed = proto.json.serializeNumber(self.speed)
	end

	return v2
end

function class11.jsonDecode(data)
	local v2 = class11.new()

	if data.text ~= nil then
		v2.text = data.text
	end

	if data.voice_id ~= nil then
		v2.voice_id = data.voice_id
	end

	if data.voiceId ~= nil then
		v2.voice_id = data.voiceId
	end

	if data.pitch ~= nil then
		v2.pitch = proto.json.deserializeNumber(data.pitch)
	end

	if data.speed ~= nil then
		v2.speed = proto.json.deserializeNumber(data.speed)
	end

	return v2
end

class11.descriptor = {
	name = "TtsAudioContext",
	fullName = "roblox.posts.postasset.v1.TtsAudioContext"
}

v.TtsAudioContext = class11

typeRegistry.default:register(v.TtsAudioContext)

local class12 = {}
class12.__index = class12

function class12.new(p)
	return (setmetatable({
		universe_id = (p == nil or p.universe_id == nil) and 0 or p.universe_id,
		place_id = (p == nil or p.place_id == nil) and 0 or p.place_id
	}, class12))
end

function class12:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.universe_id ~= nil and self.universe_id ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.universe_id)
	end

	if self.place_id ~= nil and self.place_id ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.place_id)
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class12.decode(buf: buffer)
	local result = class12.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			if v3 == 1 then
				local universe_id
				universe_id, v2 = proto.readVarIntI64(buf, v2)
				result.universe_id = universe_id
			elseif v3 == 2 then
				local place_id
				place_id, v2 = proto.readVarIntI64(buf, v2)
				result.place_id = place_id
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

function class12:jsonEncode()
	local v2 = {}

	if self.universe_id ~= nil and self.universe_id ~= 0 then
		v2.universeId = self.universe_id
	end

	if self.place_id ~= nil and self.place_id ~= 0 then
		v2.placeId = self.place_id
	end

	return v2
end

function class12.jsonDecode(data)
	local v2 = class12.new()

	if data.universe_id ~= nil then
		v2.universe_id = data.universe_id
	end

	if data.universeId ~= nil then
		v2.universe_id = data.universeId
	end

	if data.place_id ~= nil then
		v2.place_id = data.place_id
	end

	if data.placeId ~= nil then
		v2.place_id = data.placeId
	end

	return v2
end

class12.descriptor = {
	name = "ExperienceAnnotationSlot",
	fullName = "roblox.posts.postasset.v1.ExperienceAnnotationSlot"
}

v.ExperienceAnnotationSlot = class12

typeRegistry.default:register(v.ExperienceAnnotationSlot)

local class13 = {}
class13.__index = class13

function class13.new(p)
	return (setmetatable({
		outfit_id = (p == nil or p.outfit_id == nil) and 0 or p.outfit_id
	}, class13))
end

function class13:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.outfit_id ~= nil and self.outfit_id ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, self.outfit_id)
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class13.decode(buf: buffer)
	local result = class13.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			if v3 == 1 then
				local outfit_id
				outfit_id, v2 = proto.readVarIntI64(buf, v2)
				result.outfit_id = outfit_id
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

function class13:jsonEncode()
	local v2 = {}

	if self.outfit_id ~= nil and self.outfit_id ~= 0 then
		v2.outfitId = self.outfit_id
	end

	return v2
end

function class13.jsonDecode(p)
	local v2 = class13.new()

	if p.outfit_id ~= nil then
		v2.outfit_id = p.outfit_id
	end

	if p.outfitId ~= nil then
		v2.outfit_id = p.outfitId
	end

	return v2
end

class13.descriptor = {
	name = "AvatarAnnotationSlot",
	fullName = "roblox.posts.postasset.v1.AvatarAnnotationSlot"
}

v.AvatarAnnotationSlot = class13

typeRegistry.default:register(v.AvatarAnnotationSlot)

local class14 = {}
class14.__index = class14

function class14.new(p)
	local offset_duration

	if not (p == nil or p.offset_duration == nil) then
		offset_duration = p.offset_duration
	end

	local duration2

	if not (p == nil or p.duration == nil) then
		duration2 = p.duration
	end

	return (setmetatable({ offset_duration = offset_duration, duration = duration2 }, class14))
end

function class14:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.offset_duration ~= nil then
		local encoded = self.offset_duration:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.duration ~= nil then
		local encoded = self.duration:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class14.decode(buf: buffer)
	local result = class14.new()
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
				result.offset_duration = duration.Duration.decode(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.duration = duration.Duration.decode(v5)
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

function class14:jsonEncode()
	local v2 = {}

	if self.offset_duration ~= nil then
		v2.offsetDuration = self.offset_duration:jsonEncode()
	end

	if self.duration ~= nil then
		v2.duration = self.duration:jsonEncode()
	end

	return v2
end

function class14.jsonDecode(data)
	local v2 = class14.new()

	if data.offset_duration ~= nil then
		v2.offset_duration = duration.Duration.jsonDecode(data.offset_duration)
	end

	if data.offsetDuration ~= nil then
		v2.offset_duration = duration.Duration.jsonDecode(data.offsetDuration)
	end

	if data.duration ~= nil then
		v2.duration = duration.Duration.jsonDecode(data.duration)
	end

	return v2
end

class14.descriptor = { name = "TimeRange", fullName = "roblox.posts.postasset.v1.TimeRange" }

v.TimeRange = class14

typeRegistry.default:register(v.TimeRange)

local class15 = {}
class15.__index = class15

function class15.new(data)
	local position

	if not (data == nil or data.position == nil) then
		position = data.position
	end

	local v2 = {
		position = position,
		rotation = (data == nil or data.rotation == nil) and 0 or data.rotation,
		scale = (data == nil or data.scale == nil) and 0 or data.scale
	}
	return (setmetatable(v2, class15))
end

function class15:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.position ~= nil then
		local encoded = self.position:encode()
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	if self.rotation ~= nil and self.rotation ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.i32)
		v2, v3 = proto.writeFloat(v4, v5, self.rotation)
	end

	if self.scale ~= nil and self.scale ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.i32)
		v2, v3 = proto.writeFloat(v4, v5, self.scale)
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class15.decode(buf: buffer)
	local result = class15.new()
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
				result.position = v.Vec2.decode(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			if v3 == 2 then
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

function class15:jsonEncode()
	local v2 = {}

	if self.position ~= nil then
		v2.position = self.position:jsonEncode()
	end

	if self.rotation ~= nil and self.rotation ~= 0 then
		v2.rotation = proto.json.serializeNumber(self.rotation)
	end

	if self.scale ~= nil and self.scale ~= 0 then
		v2.scale = proto.json.serializeNumber(self.scale)
	end

	return v2
end

function class15.jsonDecode(data)
	local v2 = class15.new()

	if data.position ~= nil then
		v2.position = v.Vec2.jsonDecode(data.position)
	end

	if data.rotation ~= nil then
		v2.rotation = proto.json.deserializeNumber(data.rotation)
	end

	if data.scale ~= nil then
		v2.scale = proto.json.deserializeNumber(data.scale)
	end

	return v2
end

class15.descriptor = { name = "Transform", fullName = "roblox.posts.postasset.v1.Transform" }

v.Transform = class15

typeRegistry.default:register(v.Transform)

local class16 = {}
class16.__index = class16

function class16.new(p)
	return (setmetatable({
		x = (p == nil or p.x == nil) and 0 or p.x,
		y = (p == nil or p.y == nil) and 0 or p.y
	}, class16))
end

function class16:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.x ~= nil and self.x ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.i32)
		v2, v3 = proto.writeFloat(v4, v5, self.x)
	end

	if self.y ~= nil and self.y ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.i32)
		v2, v3 = proto.writeFloat(v4, v5, self.y)
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class16.decode(buf: buffer)
	local result = class16.new()
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
				local v5
				v5, v2 = proto.readFloat(buf, v2)
				result.x = v5
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readFloat(buf, v2)
				result.y = v5
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

function class16:jsonEncode()
	local v2 = {}

	if self.x ~= nil and self.x ~= 0 then
		v2.x = proto.json.serializeNumber(self.x)
	end

	if self.y ~= nil and self.y ~= 0 then
		v2.y = proto.json.serializeNumber(self.y)
	end

	return v2
end

function class16.jsonDecode(p)
	local v2 = class16.new()

	if p.x ~= nil then
		v2.x = proto.json.deserializeNumber(p.x)
	end

	if p.y ~= nil then
		v2.y = proto.json.deserializeNumber(p.y)
	end

	return v2
end

class16.descriptor = { name = "Vec2", fullName = "roblox.posts.postasset.v1.Vec2" }

v.Vec2 = class16

typeRegistry.default:register(v.Vec2)

local class17 = {}
class17.__index = class17

function class17.new(data)
	return (setmetatable({
		r = (data == nil or data.r == nil) and 0 or data.r,
		g = (data == nil or data.g == nil) and 0 or data.g,
		b = (data == nil or data.b == nil) and 0 or data.b
	}, class17))
end

function class17:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.r ~= nil and self.r ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.i32)
		v2, v3 = proto.writeFloat(v4, v5, self.r)
	end

	if self.g ~= nil and self.g ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.i32)
		v2, v3 = proto.writeFloat(v4, v5, self.g)
	end

	if self.b ~= nil and self.b ~= 0 then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.i32)
		v2, v3 = proto.writeFloat(v4, v5, self.b)
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class17.decode(buf: buffer)
	local result = class17.new()
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
				local v5
				v5, v2 = proto.readFloat(buf, v2)
				result.r = v5
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readFloat(buf, v2)
				result.g = v5
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readFloat(buf, v2)
				result.b = v5
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

function class17:jsonEncode()
	local v2 = {}

	if self.r ~= nil and self.r ~= 0 then
		v2.r = proto.json.serializeNumber(self.r)
	end

	if self.g ~= nil and self.g ~= 0 then
		v2.g = proto.json.serializeNumber(self.g)
	end

	if self.b ~= nil and self.b ~= 0 then
		v2.b = proto.json.serializeNumber(self.b)
	end

	return v2
end

function class17.jsonDecode(data)
	local v2 = class17.new()

	if data.r ~= nil then
		v2.r = proto.json.deserializeNumber(data.r)
	end

	if data.g ~= nil then
		v2.g = proto.json.deserializeNumber(data.g)
	end

	if data.b ~= nil then
		v2.b = proto.json.deserializeNumber(data.b)
	end

	return v2
end

class17.descriptor = { name = "Color3", fullName = "roblox.posts.postasset.v1.Color3" }

v.Color3 = class17

typeRegistry.default:register(v.Color3)

local class18 = {}
class18.__index = class18

function class18.new(p)
	local font_source

	if not (p == nil or p.font_source == nil) then
		font_source = p.font_source
	end

	return (setmetatable({ font_source = font_source }, class18))
end

function class18:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.font_source ~= nil then
		if self.font_source.type == "enumerated_font" then
			local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)

			v2, v3 = proto.writeVarInt(v4, v5, v.EnumeratedFont.toNumber(self.font_source.value))
		elseif self.font_source.type == "family_asset_id" then
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.varint)
			v2, v3 = proto.writeVarInt(v4, v5, self.font_source.value)
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class18.decode(buf: buffer)
	local result = class18.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readVarIntI32(buf, v2)
				result.font_source = {
					type = "enumerated_font",
					value = v.EnumeratedFont.fromNumber(v5) or v5
				}
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readVarIntI64(buf, v2)
				result.font_source = { type = "family_asset_id", value = v5 }
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

function class18:jsonEncode()
	local v2 = {}

	if self.font_source == nil then
		return v2
	end

	if self.font_source.type == "enumerated_font" then
		local enumeratedFont

		if typeof(self.font_source.value) == "number" then
			enumeratedFont = self.font_source.value
		else
			enumeratedFont = v.EnumeratedFont.toNumber(self.font_source.value)
		end

		v2.enumeratedFont = enumeratedFont
		return v2
	end

	if self.font_source.type == "family_asset_id" then
		v2.familyAssetId = self.font_source.value
	end

	return v2
end

function class18.jsonDecode(data)
	local v2 = class18.new()

	if data.enumerated_font ~= nil then
		local v3

		if typeof(data.enumerated_font) == "number" then
			v3 = v.EnumeratedFont.fromNumber(data.enumerated_font) or data.enumerated_font
		else
			v3 = v.EnumeratedFont.fromName(data.enumerated_font) or data.enumerated_font
		end

		v2.font_source = { type = "enumerated_font", value = v3 }
	end

	if data.enumeratedFont ~= nil then
		local v3

		if typeof(data.enumeratedFont) == "number" then
			v3 = v.EnumeratedFont.fromNumber(data.enumeratedFont) or data.enumeratedFont
		else
			v3 = v.EnumeratedFont.fromName(data.enumeratedFont) or data.enumeratedFont
		end

		v2.font_source = { type = "enumerated_font", value = v3 }
	end

	if data.family_asset_id ~= nil then
		v2.font_source = { type = "family_asset_id", value = data.family_asset_id }
	end

	if data.familyAssetId ~= nil then
		v2.font_source = { type = "family_asset_id", value = data.familyAssetId }
	end

	return v2
end

class18.descriptor = { name = "FontInfo", fullName = "roblox.posts.postasset.v1.FontInfo" }

v.FontInfo = class18

typeRegistry.default:register(v.FontInfo)

v.PostOrigin = {
	fromNumber = function(p: number): nil | string
		if p == 0 then
			return "POST_ORIGIN_INVALID"
		elseif p == 1 then
			return "POST_ORIGIN_CAPTURE_VIDEO"
		elseif p == 2 then
			return "POST_ORIGIN_CAPTURE_SCREENSHOT"
		elseif p == 3 then
			return "POST_ORIGIN_INFLUENCER_UPLOAD"
		elseif p == 4 then
			return "POST_ORIGIN_AVATAR"
		end

		return nil
	end,
	toNumber = function(p)
		if p == "POST_ORIGIN_INVALID" then
			return 0
		elseif p == "POST_ORIGIN_CAPTURE_VIDEO" then
			return 1
		elseif p == "POST_ORIGIN_CAPTURE_SCREENSHOT" then
			return 2
		elseif p == "POST_ORIGIN_INFLUENCER_UPLOAD" then
			return 3
		elseif p == "POST_ORIGIN_AVATAR" then
			return 4
		end

		return p
	end,
	fromName = function(p: string): nil | string
		if p == "POST_ORIGIN_INVALID" then
			return "POST_ORIGIN_INVALID"
		elseif p == "POST_ORIGIN_CAPTURE_VIDEO" then
			return "POST_ORIGIN_CAPTURE_VIDEO"
		elseif p == "POST_ORIGIN_CAPTURE_SCREENSHOT" then
			return "POST_ORIGIN_CAPTURE_SCREENSHOT"
		elseif p == "POST_ORIGIN_INFLUENCER_UPLOAD" then
			return "POST_ORIGIN_INFLUENCER_UPLOAD"
		elseif p == "POST_ORIGIN_AVATAR" then
			return "POST_ORIGIN_AVATAR"
		end

		return nil
	end
}

v.TrackType = {
	fromNumber = function(p: number): nil | string
		if p == 0 then
			return "TRACK_TYPE_INVALID"
		elseif p == 1 then
			return "TRACK_TYPE_VISUAL"
		elseif p == 2 then
			return "TRACK_TYPE_AUDIO"
		elseif p == 3 then
			return "TRACK_TYPE_ANNOTATION"
		end

		return nil
	end,
	toNumber = function(p)
		if p == "TRACK_TYPE_INVALID" then
			return 0
		elseif p == "TRACK_TYPE_VISUAL" then
			return 1
		elseif p == "TRACK_TYPE_AUDIO" then
			return 2
		elseif p == "TRACK_TYPE_ANNOTATION" then
			return 3
		end

		return p
	end,
	fromName = function(p: string): nil | string
		if p == "TRACK_TYPE_INVALID" then
			return "TRACK_TYPE_INVALID"
		elseif p == "TRACK_TYPE_VISUAL" then
			return "TRACK_TYPE_VISUAL"
		elseif p == "TRACK_TYPE_AUDIO" then
			return "TRACK_TYPE_AUDIO"
		elseif p == "TRACK_TYPE_ANNOTATION" then
			return "TRACK_TYPE_ANNOTATION"
		end

		return nil
	end
}

v.AudioType = {
	fromNumber = function(p: number): nil | string
		if p == 0 then
			return "AUDIO_TYPE_INVALID"
		elseif p == 1 then
			return "AUDIO_TYPE_MUSIC"
		elseif p == 2 then
			return "AUDIO_TYPE_TTS"
		elseif p == 3 then
			return "AUDIO_TYPE_VOICE_OVER"
		end

		return nil
	end,
	toNumber = function(p)
		if p == "AUDIO_TYPE_INVALID" then
			return 0
		elseif p == "AUDIO_TYPE_MUSIC" then
			return 1
		elseif p == "AUDIO_TYPE_TTS" then
			return 2
		elseif p == "AUDIO_TYPE_VOICE_OVER" then
			return 3
		end

		return p
	end,
	fromName = function(p: string): nil | string
		if p == "AUDIO_TYPE_INVALID" then
			return "AUDIO_TYPE_INVALID"
		elseif p == "AUDIO_TYPE_MUSIC" then
			return "AUDIO_TYPE_MUSIC"
		elseif p == "AUDIO_TYPE_TTS" then
			return "AUDIO_TYPE_TTS"
		elseif p == "AUDIO_TYPE_VOICE_OVER" then
			return "AUDIO_TYPE_VOICE_OVER"
		end

		return nil
	end
}

v.EnumeratedFont = {
	fromNumber = function(p: number): nil | string
		if p == 0 then
			return "ENUMERATED_FONT_INVALID"
		elseif p == 1 then
			return "ENUMERATED_FONT_GOTHAM_BOLD"
		elseif p == 2 then
			return "ENUMERATED_FONT_GOTHAM_BLACK"
		elseif p == 3 then
			return "ENUMERATED_FONT_SOURCE_SANS"
		elseif p == 4 then
			return "ENUMERATED_FONT_SOURCE_SANS_BOLD"
		elseif p == 5 then
			return "ENUMERATED_FONT_FREDOKA_ONE"
		elseif p == 6 then
			return "ENUMERATED_FONT_BANGERS"
		elseif p == 7 then
			return "ENUMERATED_FONT_BUILDER_SANS_MEDIUM"
		elseif p == 8 then
			return "ENUMERATED_FONT_LUCKIEST_GUY"
		elseif p == 9 then
			return "ENUMERATED_FONT_PERMANENT_MARKER"
		elseif p == 10 then
			return "ENUMERATED_FONT_CREEPSTER"
		elseif p == 11 then
			return "ENUMERATED_FONT_ARCADE"
		elseif p == 12 then
			return "ENUMERATED_FONT_SCI_FI"
		elseif p == 13 then
			return "ENUMERATED_FONT_INDIE_FLOWER"
		elseif p == 14 then
			return "ENUMERATED_FONT_GRENZE_GOTISCH"
		elseif p == 15 then
			return "ENUMERATED_FONT_SPECIAL_ELITE"
		end

		return nil
	end,
	toNumber = function(p)
		if p == "ENUMERATED_FONT_INVALID" then
			return 0
		elseif p == "ENUMERATED_FONT_GOTHAM_BOLD" then
			return 1
		elseif p == "ENUMERATED_FONT_GOTHAM_BLACK" then
			return 2
		elseif p == "ENUMERATED_FONT_SOURCE_SANS" then
			return 3
		elseif p == "ENUMERATED_FONT_SOURCE_SANS_BOLD" then
			return 4
		elseif p == "ENUMERATED_FONT_FREDOKA_ONE" then
			return 5
		elseif p == "ENUMERATED_FONT_BANGERS" then
			return 6
		elseif p == "ENUMERATED_FONT_BUILDER_SANS_MEDIUM" then
			return 7
		elseif p == "ENUMERATED_FONT_LUCKIEST_GUY" then
			return 8
		elseif p == "ENUMERATED_FONT_PERMANENT_MARKER" then
			return 9
		elseif p == "ENUMERATED_FONT_CREEPSTER" then
			return 10
		elseif p == "ENUMERATED_FONT_ARCADE" then
			return 11
		elseif p == "ENUMERATED_FONT_SCI_FI" then
			return 12
		elseif p == "ENUMERATED_FONT_INDIE_FLOWER" then
			return 13
		elseif p == "ENUMERATED_FONT_GRENZE_GOTISCH" then
			return 14
		elseif p == "ENUMERATED_FONT_SPECIAL_ELITE" then
			return 15
		end

		return p
	end,
	fromName = function(p: string): nil | string
		if p == "ENUMERATED_FONT_INVALID" then
			return "ENUMERATED_FONT_INVALID"
		elseif p == "ENUMERATED_FONT_GOTHAM_BOLD" then
			return "ENUMERATED_FONT_GOTHAM_BOLD"
		elseif p == "ENUMERATED_FONT_GOTHAM_BLACK" then
			return "ENUMERATED_FONT_GOTHAM_BLACK"
		elseif p == "ENUMERATED_FONT_SOURCE_SANS" then
			return "ENUMERATED_FONT_SOURCE_SANS"
		elseif p == "ENUMERATED_FONT_SOURCE_SANS_BOLD" then
			return "ENUMERATED_FONT_SOURCE_SANS_BOLD"
		elseif p == "ENUMERATED_FONT_FREDOKA_ONE" then
			return "ENUMERATED_FONT_FREDOKA_ONE"
		elseif p == "ENUMERATED_FONT_BANGERS" then
			return "ENUMERATED_FONT_BANGERS"
		elseif p == "ENUMERATED_FONT_BUILDER_SANS_MEDIUM" then
			return "ENUMERATED_FONT_BUILDER_SANS_MEDIUM"
		elseif p == "ENUMERATED_FONT_LUCKIEST_GUY" then
			return "ENUMERATED_FONT_LUCKIEST_GUY"
		elseif p == "ENUMERATED_FONT_PERMANENT_MARKER" then
			return "ENUMERATED_FONT_PERMANENT_MARKER"
		elseif p == "ENUMERATED_FONT_CREEPSTER" then
			return "ENUMERATED_FONT_CREEPSTER"
		elseif p == "ENUMERATED_FONT_ARCADE" then
			return "ENUMERATED_FONT_ARCADE"
		elseif p == "ENUMERATED_FONT_SCI_FI" then
			return "ENUMERATED_FONT_SCI_FI"
		elseif p == "ENUMERATED_FONT_INDIE_FLOWER" then
			return "ENUMERATED_FONT_INDIE_FLOWER"
		elseif p == "ENUMERATED_FONT_GRENZE_GOTISCH" then
			return "ENUMERATED_FONT_GRENZE_GOTISCH"
		elseif p == "ENUMERATED_FONT_SPECIAL_ELITE" then
			return "ENUMERATED_FONT_SPECIAL_ELITE"
		end

		return nil
	end
}

v.TextXAlignment = {
	fromNumber = function(p: number): nil | string
		if p == 0 then
			return "TEXT_X_ALIGNMENT_INVALID"
		elseif p == 1 then
			return "TEXT_X_ALIGNMENT_LEFT"
		elseif p == 2 then
			return "TEXT_X_ALIGNMENT_CENTER"
		elseif p == 3 then
			return "TEXT_X_ALIGNMENT_RIGHT"
		end

		return nil
	end,
	toNumber = function(p)
		if p == "TEXT_X_ALIGNMENT_INVALID" then
			return 0
		elseif p == "TEXT_X_ALIGNMENT_LEFT" then
			return 1
		elseif p == "TEXT_X_ALIGNMENT_CENTER" then
			return 2
		elseif p == "TEXT_X_ALIGNMENT_RIGHT" then
			return 3
		end

		return p
	end,
	fromName = function(p: string): nil | string
		if p == "TEXT_X_ALIGNMENT_INVALID" then
			return "TEXT_X_ALIGNMENT_INVALID"
		elseif p == "TEXT_X_ALIGNMENT_LEFT" then
			return "TEXT_X_ALIGNMENT_LEFT"
		elseif p == "TEXT_X_ALIGNMENT_CENTER" then
			return "TEXT_X_ALIGNMENT_CENTER"
		elseif p == "TEXT_X_ALIGNMENT_RIGHT" then
			return "TEXT_X_ALIGNMENT_RIGHT"
		end

		return nil
	end
}

return {
	Post = v.Post,
	PostMetadata = v.PostMetadata,
	Track = v.Track,
	Slot = v.Slot,
	VisualSlot = v.VisualSlot,
	VideoSlot = v.VideoSlot,
	ImageSlot = v.ImageSlot,
	TextLabelSlot = v.TextLabelSlot,
	SceneSlot = v.SceneSlot,
	AudioSlot = v.AudioSlot,
	TtsAudioContext = v.TtsAudioContext,
	ExperienceAnnotationSlot = v.ExperienceAnnotationSlot,
	AvatarAnnotationSlot = v.AvatarAnnotationSlot,
	TimeRange = v.TimeRange,
	Transform = v.Transform,
	Vec2 = v.Vec2,
	Color3 = v.Color3,
	FontInfo = v.FontInfo,
	PostOrigin = v.PostOrigin,
	TrackType = v.TrackType,
	AudioType = v.AudioType,
	EnumeratedFont = v.EnumeratedFont,
	TextXAlignment = v.TextXAlignment
}
