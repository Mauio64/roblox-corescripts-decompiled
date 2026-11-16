local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local class = {}
class.__index = class

function class.new(data)
	local recommendation_type

	if data == nil or data.recommendation_type == nil then
		recommendation_type = assert(
			v.FriendRecommendationData_RecommendationType.fromNumber(0),
			"Enum has no 0 default"
		)
	else
		recommendation_type = data.recommendation_type
	end

	local context_type

	if not (data == nil or data.context_type == nil) then
		context_type = data.context_type
	end

	local mutual_friends_count

	if not (data == nil or data.mutual_friends_count == nil) then
		mutual_friends_count = data.mutual_friends_count
	end

	local contact_name

	if not (data == nil or data.contact_name == nil) then
		contact_name = data.contact_name
	end

	local avatar_thumbnail_url

	if not (data == nil or data.avatar_thumbnail_url == nil) then
		avatar_thumbnail_url = data.avatar_thumbnail_url
	end

	local headshot_thumbnail_url

	if not (data == nil or data.headshot_thumbnail_url == nil) then
		headshot_thumbnail_url = data.headshot_thumbnail_url
	end

	return (setmetatable({
		recommendation_type = recommendation_type,
		context_type = context_type,
		mutual_friends_count = mutual_friends_count,
		contact_name = contact_name,
		avatar_thumbnail_url = avatar_thumbnail_url,
		headshot_thumbnail_url = headshot_thumbnail_url
	}, class))
end

function class.encode(data)
	local v2 = buffer.create(0)
	local v3 = 0

	if
		data.recommendation_type ~= nil
		and (data.recommendation_type ~= nil and data.recommendation_type ~= 0 or data.recommendation_type ~= v.FriendRecommendationData_RecommendationType.fromNumber(0))
	then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(
			v4,
			v5,
			v.FriendRecommendationData_RecommendationType.toNumber(data.recommendation_type)
		)
	end

	if data.context_type ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.context_type)
	end

	if data.mutual_friends_count ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.mutual_friends_count)
	end

	if data.contact_name ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.contact_name)
	end

	if data.avatar_thumbnail_url ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 5, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.avatar_thumbnail_url)
	end

	if data.headshot_thumbnail_url ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 6, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.headshot_thumbnail_url)
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
				v5, v2 = proto.readVarIntI32(buf, v2)
				result.recommendation_type = v.FriendRecommendationData_RecommendationType.fromNumber(v5) or v5
			elseif v3 == 3 then
				local mutual_friends_count
				mutual_friends_count, v2 = proto.readVarIntI32(buf, v2)
				result.mutual_friends_count = mutual_friends_count
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.context_type = buffer.tostring(v5)
			elseif v3 == 4 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.contact_name = buffer.tostring(v5)
			elseif v3 == 5 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.avatar_thumbnail_url = buffer.tostring(v5)
			elseif v3 == 6 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.headshot_thumbnail_url = buffer.tostring(v5)
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

function class.jsonEncode(data)
	local v2 = {}

	if
		data.recommendation_type ~= nil
		and (data.recommendation_type ~= nil and data.recommendation_type ~= 0 or data.recommendation_type ~= v.FriendRecommendationData_RecommendationType.fromNumber(0))
	then
		local recommendationType

		if typeof(data.recommendation_type) == "number" then
			recommendationType = data.recommendation_type
		else
			recommendationType = v.FriendRecommendationData_RecommendationType.toNumber(data.recommendation_type)
		end

		v2.recommendationType = recommendationType
	end

	if data.context_type ~= nil then
		v2.contextType = data.context_type
	end

	if data.mutual_friends_count ~= nil then
		v2.mutualFriendsCount = data.mutual_friends_count
	end

	if data.contact_name ~= nil then
		v2.contactName = data.contact_name
	end

	if data.avatar_thumbnail_url ~= nil then
		v2.avatarThumbnailUrl = data.avatar_thumbnail_url
	end

	if data.headshot_thumbnail_url ~= nil then
		v2.headshotThumbnailUrl = data.headshot_thumbnail_url
	end

	return v2
end

function class.jsonDecode(data)
	local v2 = class.new()

	if data.recommendation_type ~= nil then
		local recommendation_type

		if typeof(data.recommendation_type) == "number" then
			recommendation_type = v.FriendRecommendationData_RecommendationType.fromNumber(data.recommendation_type)
				or data.recommendation_type
		else
			recommendation_type = v.FriendRecommendationData_RecommendationType.fromName(data.recommendation_type)
				or data.recommendation_type
		end

		v2.recommendation_type = recommendation_type
	end

	if data.recommendationType ~= nil then
		local recommendation_type

		if typeof(data.recommendationType) == "number" then
			recommendation_type = v.FriendRecommendationData_RecommendationType.fromNumber(data.recommendationType)
				or data.recommendationType
		else
			recommendation_type = v.FriendRecommendationData_RecommendationType.fromName(data.recommendationType)
				or data.recommendationType
		end

		v2.recommendation_type = recommendation_type
	end

	if data.context_type ~= nil then
		v2.context_type = data.context_type
	end

	if data.contextType ~= nil then
		v2.context_type = data.contextType
	end

	if data.mutual_friends_count ~= nil then
		v2.mutual_friends_count = data.mutual_friends_count
	end

	if data.mutualFriendsCount ~= nil then
		v2.mutual_friends_count = data.mutualFriendsCount
	end

	if data.contact_name ~= nil then
		v2.contact_name = data.contact_name
	end

	if data.contactName ~= nil then
		v2.contact_name = data.contactName
	end

	if data.avatar_thumbnail_url ~= nil then
		v2.avatar_thumbnail_url = data.avatar_thumbnail_url
	end

	if data.avatarThumbnailUrl ~= nil then
		v2.avatar_thumbnail_url = data.avatarThumbnailUrl
	end

	if data.headshot_thumbnail_url ~= nil then
		v2.headshot_thumbnail_url = data.headshot_thumbnail_url
	end

	if data.headshotThumbnailUrl ~= nil then
		v2.headshot_thumbnail_url = data.headshotThumbnailUrl
	end

	return v2
end

class.descriptor = {
	name = "FriendRecommendationData",
	fullName = "roblox.apppageplatform.shared.v1beta1.FriendRecommendationData"
}

v.FriendRecommendationData = class

typeRegistry.default:register(v.FriendRecommendationData)

v.FriendRecommendationData_RecommendationType = {
	fromNumber = function(p: number): nil | string
		if p == 0 then
			return "RECOMMENDATION_TYPE_INVALID"
		elseif p == 1 then
			return "RECOMMENDATION_TYPE_USER"
		elseif p == 2 then
			return "RECOMMENDATION_TYPE_CONTACT"
		end

		return nil
	end,
	toNumber = function(p)
		if p == "RECOMMENDATION_TYPE_INVALID" then
			return 0
		elseif p == "RECOMMENDATION_TYPE_USER" then
			return 1
		elseif p == "RECOMMENDATION_TYPE_CONTACT" then
			return 2
		end

		return p
	end,
	fromName = function(p: string): nil | string
		if p == "RECOMMENDATION_TYPE_INVALID" then
			return "RECOMMENDATION_TYPE_INVALID"
		elseif p == "RECOMMENDATION_TYPE_USER" then
			return "RECOMMENDATION_TYPE_USER"
		elseif p == "RECOMMENDATION_TYPE_CONTACT" then
			return "RECOMMENDATION_TYPE_CONTACT"
		end

		return nil
	end
}

return {
	FriendRecommendationData = v.FriendRecommendationData,
	FriendRecommendationData_RecommendationType = v.FriendRecommendationData_RecommendationType
}
