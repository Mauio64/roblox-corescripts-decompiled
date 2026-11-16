local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local class = {}
class.__index = class

function class.new(p)
	local v2 = {
		is_saved = p ~= nil and p.is_saved ~= nil and p.is_saved,
		collection_ids = (p == nil or p.collection_ids == nil) and {} or p.collection_ids
	}
	return (setmetatable(v2, class))
end

function class.encode(p)
	local v2 = buffer.create(0)
	local v3 = 0

	if p.is_saved then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, p.is_saved and 1 or 0)
	end

	if p.collection_ids ~= nil and #p.collection_ids > 0 then
		for _, collection_id in p.collection_ids do
			local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeString(v4, v5, collection_id)
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
			if v3 == 1 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.is_saved = v5 ~= 0
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				table.insert(result.collection_ids, buffer.tostring(v5))
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

function class.jsonEncode(p)
	local v2 = {}

	if p.is_saved then
		v2.isSaved = p.is_saved
	end

	if p.collection_ids == nil or not (#p.collection_ids > 0) then
		return v2
	end

	local collection_ids = {}

	for _, collection_id in p.collection_ids do
		table.insert(collection_ids, collection_id)
	end

	v2.collectionIds = collection_ids

	return v2
end

function class.jsonDecode(data)
	local v2 = class.new()

	if data.is_saved ~= nil then
		v2.is_saved = data.is_saved
	end

	if data.isSaved ~= nil then
		v2.is_saved = data.isSaved
	end

	if data.collection_ids ~= nil then
		local collection_ids = {}

		for _, collection_id in data.collection_ids do
			table.insert(collection_ids, collection_id)
		end

		v2.collection_ids = collection_ids
	end

	if data.collectionIds == nil then
		return v2
	end

	local collectionIds = {}

	for _, collectionId in data.collectionIds do
		table.insert(collectionIds, collectionId)
	end

	v2.collection_ids = collectionIds

	return v2
end

class.descriptor = {
	name = "UserLibrarySavedStateData",
	fullName = "roblox.apppageplatform.shared.v1beta1.UserLibrarySavedStateData"
}

v.UserLibrarySavedStateData = class

typeRegistry.default:register(v.UserLibrarySavedStateData)

return { UserLibrarySavedStateData = v.UserLibrarySavedStateData }
