local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

require(script.Parent.custom_options)

local class = {}
class.__index = class

function class.new(data)
	local id

	if not (data == nil or data.id == nil) then
		id = data.id
	end

	local name

	if not (data == nil or data.name == nil) then
		name = data.name
	end

	local description

	if not (data == nil or data.description == nil) then
		description = data.description
	end

	local root_place_id

	if not (data == nil or data.root_place_id == nil) then
		root_place_id = data.root_place_id
	end

	local creator_type

	if not (data == nil or data.creator_type == nil) then
		creator_type = data.creator_type
	end

	local creator_id

	if not (data == nil or data.creator_id == nil) then
		creator_id = data.creator_id
	end

	local player_count

	if not (data == nil or data.player_count == nil) then
		player_count = data.player_count
	end

	local total_up_votes

	if not (data == nil or data.total_up_votes == nil) then
		total_up_votes = data.total_up_votes
	end

	local total_down_votes

	if not (data == nil or data.total_down_votes == nil) then
		total_down_votes = data.total_down_votes
	end

	local is_voice_supported

	if not (data == nil or data.is_voice_supported == nil) then
		is_voice_supported = data.is_voice_supported
	end

	local is_camera_supported

	if not (data == nil or data.is_camera_supported == nil) then
		is_camera_supported = data.is_camera_supported
	end

	local localized_fiat_price

	if not (data == nil or data.localized_fiat_price == nil) then
		localized_fiat_price = data.localized_fiat_price
	end

	local genre_l

	if not (data == nil or data.genre_l1 == nil) then
		genre_l = data.genre_l1
	end

	local genre_l2

	if not (data == nil or data.genre_l2 == nil) then
		genre_l2 = data.genre_l2
	end

	local maximum_server_size

	if not (data == nil or data.maximum_server_size == nil) then
		maximum_server_size = data.maximum_server_size
	end

	local created_date

	if not (data == nil or data.created_date == nil) then
		created_date = data.created_date
	end

	local updated_date

	if not (data == nil or data.updated_date == nil) then
		updated_date = data.updated_date
	end

	local favorite_count

	if not (data == nil or data.favorite_count == nil) then
		favorite_count = data.favorite_count
	end

	local total_visits

	if not (data == nil or data.total_visits == nil) then
		total_visits = data.total_visits
	end

	local canonical_url_path

	if not (data == nil or data.canonical_url_path == nil) then
		canonical_url_path = data.canonical_url_path
	end

	local game_minimum_age

	if not (data == nil or data.game_minimum_age == nil) then
		game_minimum_age = data.game_minimum_age
	end

	local game_age_display_name

	if not (data == nil or data.game_age_display_name == nil) then
		game_age_display_name = data.game_age_display_name
	end

	local content_maturity

	if not (data == nil or data.content_maturity == nil) then
		content_maturity = data.content_maturity
	end

	local is_officially_licensed

	if not (data == nil or data.is_officially_licensed == nil) then
		is_officially_licensed = data.is_officially_licensed
	end

	local refund_policy_text

	if not (data == nil or data.refund_policy_text == nil) then
		refund_policy_text = data.refund_policy_text
	end

	local refund_article_id

	if not (data == nil or data.refund_article_id == nil) then
		refund_article_id = data.refund_article_id
	end

	local preview_video_id

	if not (data == nil or data.preview_video_id == nil) then
		preview_video_id = data.preview_video_id
	end

	local creation_source

	if not (data == nil or data.creation_source == nil) then
		creation_source = data.creation_source
	end

	local promotional_text

	if not (data == nil or data.promotional_text == nil) then
		promotional_text = data.promotional_text
	end

	local moment_video_asset_id

	if not (data == nil or data.moment_video_asset_id == nil) then
		moment_video_asset_id = data.moment_video_asset_id
	end

	local is_community_licensed

	if not (data == nil or data.is_community_licensed == nil) then
		is_community_licensed = data.is_community_licensed
	end

	return (setmetatable({
		id = id,
		name = name,
		description = description,
		root_place_id = root_place_id,
		creator_type = creator_type,
		creator_id = creator_id,
		player_count = player_count,
		total_up_votes = total_up_votes,
		total_down_votes = total_down_votes,
		is_voice_supported = is_voice_supported,
		is_camera_supported = is_camera_supported,
		localized_fiat_price = localized_fiat_price,
		genre_l1 = genre_l,
		genre_l2 = genre_l2,
		maximum_server_size = maximum_server_size,
		created_date = created_date,
		updated_date = updated_date,
		favorite_count = favorite_count,
		total_visits = total_visits,
		canonical_url_path = canonical_url_path,
		game_minimum_age = game_minimum_age,
		game_age_display_name = game_age_display_name,
		content_maturity = content_maturity,
		is_officially_licensed = is_officially_licensed,
		refund_policy_text = refund_policy_text,
		refund_article_id = refund_article_id,
		preview_video_id = preview_video_id,
		creation_source = creation_source,
		promotional_text = promotional_text,
		moment_video_asset_id = moment_video_asset_id,
		is_community_licensed = is_community_licensed
	}, class))
end

function class.encode(data)
	local v2 = buffer.create(0)
	local v3 = 0

	if data.id ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.id)
	end

	if data.name ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.name)
	end

	if data.description ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.description)
	end

	if data.root_place_id ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 4, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.root_place_id)
	end

	if data.creator_type ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 5, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.creator_type)
	end

	if data.creator_id ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 6, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.creator_id)
	end

	if data.player_count ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 7, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.player_count)
	end

	if data.total_up_votes ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 8, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.total_up_votes)
	end

	if data.total_down_votes ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 9, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.total_down_votes)
	end

	if data.is_voice_supported ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 10, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.is_voice_supported and 1 or 0)
	end

	if data.is_camera_supported ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 11, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.is_camera_supported and 1 or 0)
	end

	if data.localized_fiat_price ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 12, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.localized_fiat_price)
	end

	if data.genre_l1 ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 13, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.genre_l1)
	end

	if data.genre_l2 ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 14, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.genre_l2)
	end

	if data.maximum_server_size ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 15, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.maximum_server_size)
	end

	if data.created_date ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 16, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.created_date)
	end

	if data.updated_date ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 17, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.updated_date)
	end

	if data.favorite_count ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 18, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.favorite_count)
	end

	if data.total_visits ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 19, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.total_visits)
	end

	if data.canonical_url_path ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 20, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.canonical_url_path)
	end

	if data.game_minimum_age ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 21, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.game_minimum_age)
	end

	if data.game_age_display_name ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 22, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.game_age_display_name)
	end

	if data.content_maturity ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 23, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.content_maturity)
	end

	if data.is_officially_licensed ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 24, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.is_officially_licensed and 1 or 0)
	end

	if data.refund_policy_text ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 25, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.refund_policy_text)
	end

	if data.refund_article_id ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 26, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.refund_article_id)
	end

	if data.preview_video_id ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 27, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.preview_video_id)
	end

	if data.creation_source ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 28, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.creation_source)
	end

	if data.promotional_text ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 29, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, data.promotional_text)
	end

	if data.moment_video_asset_id ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 30, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.moment_video_asset_id)
	end

	if data.is_community_licensed ~= nil then
		local v4, v5 = proto.writeTag(v2, v3, 31, proto.wireTypes.varint)
		v2, v3 = proto.writeVarInt(v4, v5, data.is_community_licensed and 1 or 0)
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
				local id
				id, v2 = proto.readVarIntI64(buf, v2)
				result.id = id
			elseif v3 == 4 then
				local root_place_id
				root_place_id, v2 = proto.readVarIntI64(buf, v2)
				result.root_place_id = root_place_id
			elseif v3 == 6 then
				local creator_id
				creator_id, v2 = proto.readVarIntI64(buf, v2)
				result.creator_id = creator_id
			elseif v3 == 7 then
				local player_count
				player_count, v2 = proto.readVarIntI64(buf, v2)
				result.player_count = player_count
			elseif v3 == 8 then
				local total_up_votes
				total_up_votes, v2 = proto.readVarIntI64(buf, v2)
				result.total_up_votes = total_up_votes
			elseif v3 == 9 then
				local total_down_votes
				total_down_votes, v2 = proto.readVarIntI64(buf, v2)
				result.total_down_votes = total_down_votes
			elseif v3 == 10 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.is_voice_supported = v5 ~= 0
			elseif v3 == 11 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.is_camera_supported = v5 ~= 0
			elseif v3 == 15 then
				local maximum_server_size
				maximum_server_size, v2 = proto.readVarIntI64(buf, v2)
				result.maximum_server_size = maximum_server_size
			elseif v3 == 18 then
				local favorite_count
				favorite_count, v2 = proto.readVarIntI64(buf, v2)
				result.favorite_count = favorite_count
			elseif v3 == 19 then
				local total_visits
				total_visits, v2 = proto.readVarIntI64(buf, v2)
				result.total_visits = total_visits
			elseif v3 == 21 then
				local game_minimum_age
				game_minimum_age, v2 = proto.readVarIntI32(buf, v2)
				result.game_minimum_age = game_minimum_age
			elseif v3 == 24 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.is_officially_licensed = v5 ~= 0
			elseif v3 == 27 then
				local preview_video_id
				preview_video_id, v2 = proto.readVarIntI64(buf, v2)
				result.preview_video_id = preview_video_id
			elseif v3 == 30 then
				local moment_video_asset_id
				moment_video_asset_id, v2 = proto.readVarIntI64(buf, v2)
				result.moment_video_asset_id = moment_video_asset_id
			elseif v3 == 31 then
				local v5
				v5, v2 = proto.readVarInt(buf, v2)
				result.is_community_licensed = v5 ~= 0
			else
				local _
				_, v2 = proto.readVarInt(buf, v2)
			end
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.name = buffer.tostring(v5)
			elseif v3 == 3 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.description = buffer.tostring(v5)
			elseif v3 == 5 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.creator_type = buffer.tostring(v5)
			elseif v3 == 12 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.localized_fiat_price = buffer.tostring(v5)
			elseif v3 == 13 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.genre_l1 = buffer.tostring(v5)
			elseif v3 == 14 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.genre_l2 = buffer.tostring(v5)
			elseif v3 == 16 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.created_date = buffer.tostring(v5)
			elseif v3 == 17 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.updated_date = buffer.tostring(v5)
			elseif v3 == 20 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.canonical_url_path = buffer.tostring(v5)
			elseif v3 == 22 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.game_age_display_name = buffer.tostring(v5)
			elseif v3 == 23 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.content_maturity = buffer.tostring(v5)
			elseif v3 == 25 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.refund_policy_text = buffer.tostring(v5)
			elseif v3 == 26 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.refund_article_id = buffer.tostring(v5)
			elseif v3 == 28 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.creation_source = buffer.tostring(v5)
			elseif v3 == 29 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.promotional_text = buffer.tostring(v5)
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

	if data.id ~= nil then
		v2.id = data.id
	end

	if data.name ~= nil then
		v2.name = data.name
	end

	if data.description ~= nil then
		v2.description = data.description
	end

	if data.root_place_id ~= nil then
		v2.rootPlaceId = data.root_place_id
	end

	if data.creator_type ~= nil then
		v2.creatorType = data.creator_type
	end

	if data.creator_id ~= nil then
		v2.creatorId = data.creator_id
	end

	if data.player_count ~= nil then
		v2.playerCount = data.player_count
	end

	if data.total_up_votes ~= nil then
		v2.totalUpVotes = data.total_up_votes
	end

	if data.total_down_votes ~= nil then
		v2.totalDownVotes = data.total_down_votes
	end

	if data.is_voice_supported ~= nil then
		v2.isVoiceSupported = data.is_voice_supported
	end

	if data.is_camera_supported ~= nil then
		v2.isCameraSupported = data.is_camera_supported
	end

	if data.localized_fiat_price ~= nil then
		v2.localizedFiatPrice = data.localized_fiat_price
	end

	if data.genre_l1 ~= nil then
		v2.genreL1 = data.genre_l1
	end

	if data.genre_l2 ~= nil then
		v2.genreL2 = data.genre_l2
	end

	if data.maximum_server_size ~= nil then
		v2.maximumServerSize = data.maximum_server_size
	end

	if data.created_date ~= nil then
		v2.createdDate = data.created_date
	end

	if data.updated_date ~= nil then
		v2.updatedDate = data.updated_date
	end

	if data.favorite_count ~= nil then
		v2.favoriteCount = data.favorite_count
	end

	if data.total_visits ~= nil then
		v2.totalVisits = data.total_visits
	end

	if data.canonical_url_path ~= nil then
		v2.canonicalUrlPath = data.canonical_url_path
	end

	if data.game_minimum_age ~= nil then
		v2.gameMinimumAge = data.game_minimum_age
	end

	if data.game_age_display_name ~= nil then
		v2.gameAgeDisplayName = data.game_age_display_name
	end

	if data.content_maturity ~= nil then
		v2.contentMaturity = data.content_maturity
	end

	if data.is_officially_licensed ~= nil then
		v2.isOfficiallyLicensed = data.is_officially_licensed
	end

	if data.refund_policy_text ~= nil then
		v2.refundPolicyText = data.refund_policy_text
	end

	if data.refund_article_id ~= nil then
		v2.refundArticleId = data.refund_article_id
	end

	if data.preview_video_id ~= nil then
		v2.previewVideoId = data.preview_video_id
	end

	if data.creation_source ~= nil then
		v2.creationSource = data.creation_source
	end

	if data.promotional_text ~= nil then
		v2.promotionalText = data.promotional_text
	end

	if data.moment_video_asset_id ~= nil then
		v2.momentVideoAssetId = data.moment_video_asset_id
	end

	if data.is_community_licensed ~= nil then
		v2.isCommunityLicensed = data.is_community_licensed
	end

	return v2
end

function class.jsonDecode(data)
	local v2 = class.new()

	if data.id ~= nil then
		v2.id = data.id
	end

	if data.name ~= nil then
		v2.name = data.name
	end

	if data.description ~= nil then
		v2.description = data.description
	end

	if data.root_place_id ~= nil then
		v2.root_place_id = data.root_place_id
	end

	if data.rootPlaceId ~= nil then
		v2.root_place_id = data.rootPlaceId
	end

	if data.creator_type ~= nil then
		v2.creator_type = data.creator_type
	end

	if data.creatorType ~= nil then
		v2.creator_type = data.creatorType
	end

	if data.creator_id ~= nil then
		v2.creator_id = data.creator_id
	end

	if data.creatorId ~= nil then
		v2.creator_id = data.creatorId
	end

	if data.player_count ~= nil then
		v2.player_count = data.player_count
	end

	if data.playerCount ~= nil then
		v2.player_count = data.playerCount
	end

	if data.total_up_votes ~= nil then
		v2.total_up_votes = data.total_up_votes
	end

	if data.totalUpVotes ~= nil then
		v2.total_up_votes = data.totalUpVotes
	end

	if data.total_down_votes ~= nil then
		v2.total_down_votes = data.total_down_votes
	end

	if data.totalDownVotes ~= nil then
		v2.total_down_votes = data.totalDownVotes
	end

	if data.is_voice_supported ~= nil then
		v2.is_voice_supported = data.is_voice_supported
	end

	if data.isVoiceSupported ~= nil then
		v2.is_voice_supported = data.isVoiceSupported
	end

	if data.is_camera_supported ~= nil then
		v2.is_camera_supported = data.is_camera_supported
	end

	if data.isCameraSupported ~= nil then
		v2.is_camera_supported = data.isCameraSupported
	end

	if data.localized_fiat_price ~= nil then
		v2.localized_fiat_price = data.localized_fiat_price
	end

	if data.localizedFiatPrice ~= nil then
		v2.localized_fiat_price = data.localizedFiatPrice
	end

	if data.genre_l1 ~= nil then
		v2.genre_l1 = data.genre_l1
	end

	if data.genreL1 ~= nil then
		v2.genre_l1 = data.genreL1
	end

	if data.genre_l2 ~= nil then
		v2.genre_l2 = data.genre_l2
	end

	if data.genreL2 ~= nil then
		v2.genre_l2 = data.genreL2
	end

	if data.maximum_server_size ~= nil then
		v2.maximum_server_size = data.maximum_server_size
	end

	if data.maximumServerSize ~= nil then
		v2.maximum_server_size = data.maximumServerSize
	end

	if data.created_date ~= nil then
		v2.created_date = data.created_date
	end

	if data.createdDate ~= nil then
		v2.created_date = data.createdDate
	end

	if data.updated_date ~= nil then
		v2.updated_date = data.updated_date
	end

	if data.updatedDate ~= nil then
		v2.updated_date = data.updatedDate
	end

	if data.favorite_count ~= nil then
		v2.favorite_count = data.favorite_count
	end

	if data.favoriteCount ~= nil then
		v2.favorite_count = data.favoriteCount
	end

	if data.total_visits ~= nil then
		v2.total_visits = data.total_visits
	end

	if data.totalVisits ~= nil then
		v2.total_visits = data.totalVisits
	end

	if data.canonical_url_path ~= nil then
		v2.canonical_url_path = data.canonical_url_path
	end

	if data.canonicalUrlPath ~= nil then
		v2.canonical_url_path = data.canonicalUrlPath
	end

	if data.game_minimum_age ~= nil then
		v2.game_minimum_age = data.game_minimum_age
	end

	if data.gameMinimumAge ~= nil then
		v2.game_minimum_age = data.gameMinimumAge
	end

	if data.game_age_display_name ~= nil then
		v2.game_age_display_name = data.game_age_display_name
	end

	if data.gameAgeDisplayName ~= nil then
		v2.game_age_display_name = data.gameAgeDisplayName
	end

	if data.content_maturity ~= nil then
		v2.content_maturity = data.content_maturity
	end

	if data.contentMaturity ~= nil then
		v2.content_maturity = data.contentMaturity
	end

	if data.is_officially_licensed ~= nil then
		v2.is_officially_licensed = data.is_officially_licensed
	end

	if data.isOfficiallyLicensed ~= nil then
		v2.is_officially_licensed = data.isOfficiallyLicensed
	end

	if data.refund_policy_text ~= nil then
		v2.refund_policy_text = data.refund_policy_text
	end

	if data.refundPolicyText ~= nil then
		v2.refund_policy_text = data.refundPolicyText
	end

	if data.refund_article_id ~= nil then
		v2.refund_article_id = data.refund_article_id
	end

	if data.refundArticleId ~= nil then
		v2.refund_article_id = data.refundArticleId
	end

	if data.preview_video_id ~= nil then
		v2.preview_video_id = data.preview_video_id
	end

	if data.previewVideoId ~= nil then
		v2.preview_video_id = data.previewVideoId
	end

	if data.creation_source ~= nil then
		v2.creation_source = data.creation_source
	end

	if data.creationSource ~= nil then
		v2.creation_source = data.creationSource
	end

	if data.promotional_text ~= nil then
		v2.promotional_text = data.promotional_text
	end

	if data.promotionalText ~= nil then
		v2.promotional_text = data.promotionalText
	end

	if data.moment_video_asset_id ~= nil then
		v2.moment_video_asset_id = data.moment_video_asset_id
	end

	if data.momentVideoAssetId ~= nil then
		v2.moment_video_asset_id = data.momentVideoAssetId
	end

	if data.is_community_licensed ~= nil then
		v2.is_community_licensed = data.is_community_licensed
	end

	if data.isCommunityLicensed ~= nil then
		v2.is_community_licensed = data.isCommunityLicensed
	end

	return v2
end

class.descriptor = {
	name = "UniverseData",
	fullName = "roblox.apppageplatform.shared.v1beta1.UniverseData"
}

v.UniverseData = class

typeRegistry.default:register(v.UniverseData)

return { UniverseData = v.UniverseData }
