local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 91
	-- upvalues: t2 (copy)
	return (setmetatable({
		id = if t3 ~= nil and t3.id ~= nil then t3.id else nil,
		name = if t3 ~= nil and t3.name ~= nil then t3.name else nil,
		description = if t3 ~= nil and t3.description ~= nil then t3.description else nil,
		root_place_id = if t3 ~= nil and t3.root_place_id ~= nil then t3.root_place_id else nil,
		creator_type = if t3 ~= nil and t3.creator_type ~= nil then t3.creator_type else nil,
		creator_id = if t3 ~= nil and t3.creator_id ~= nil then t3.creator_id else nil,
		player_count = if t3 ~= nil and t3.player_count ~= nil then t3.player_count else nil,
		total_up_votes = if t3 ~= nil and t3.total_up_votes ~= nil then t3.total_up_votes else nil,
		total_down_votes = if t3 ~= nil and t3.total_down_votes ~= nil then t3.total_down_votes else nil,
		is_voice_supported = if t3 ~= nil and t3.is_voice_supported ~= nil then t3.is_voice_supported else nil,
		is_camera_supported = if t3 ~= nil and t3.is_camera_supported ~= nil then t3.is_camera_supported else nil,
		localized_fiat_price = if t3 ~= nil and t3.localized_fiat_price ~= nil then t3.localized_fiat_price else nil,
		genre_l1 = if t3 ~= nil and t3.genre_l1 ~= nil then t3.genre_l1 else nil,
		genre_l2 = if t3 ~= nil and t3.genre_l2 ~= nil then t3.genre_l2 else nil,
		maximum_server_size = if t3 ~= nil and t3.maximum_server_size ~= nil then t3.maximum_server_size else nil,
		created_date = if t3 ~= nil and t3.created_date ~= nil then t3.created_date else nil,
		updated_date = if t3 ~= nil and t3.updated_date ~= nil then t3.updated_date else nil,
		favorite_count = if t3 ~= nil and t3.favorite_count ~= nil then t3.favorite_count else nil,
		total_visits = if t3 ~= nil and t3.total_visits ~= nil then t3.total_visits else nil,
		canonical_url_path = if t3 ~= nil and t3.canonical_url_path ~= nil then t3.canonical_url_path else nil,
		game_minimum_age = if t3 ~= nil and t3.game_minimum_age ~= nil then t3.game_minimum_age else nil,
		game_age_display_name = if t3 ~= nil and t3.game_age_display_name ~= nil then t3.game_age_display_name else nil,
		content_maturity = if t3 ~= nil and t3.content_maturity ~= nil then t3.content_maturity else nil,
		is_officially_licensed = if t3 ~= nil and t3.is_officially_licensed ~= nil then t3.is_officially_licensed else nil,
		refund_policy_text = if t3 ~= nil and t3.refund_policy_text ~= nil then t3.refund_policy_text else nil,
		refund_article_id = if t3 ~= nil and t3.refund_article_id ~= nil then t3.refund_article_id else nil,
		preview_video_id = if t3 ~= nil and t3.preview_video_id ~= nil then t3.preview_video_id else nil
	}, t2))
end
function t2.encode(p1) -- line: 133
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.id ~= nil then
		local v9, v10 = proto.writeTag(buf, n1, 1, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v9, v10, p1.id)
	end

	if p1.name ~= nil then
		local v11, v12 = proto.writeTag(buf, n1, 2, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v11, v12, p1.name)
	end

	if p1.description ~= nil then
		local v13, v14 = proto.writeTag(buf, n1, 3, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v13, v14, p1.description)
	end

	if p1.root_place_id ~= nil then
		local v15, v16 = proto.writeTag(buf, n1, 4, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v15, v16, p1.root_place_id)
	end

	if p1.creator_type ~= nil then
		local v17, v18 = proto.writeTag(buf, n1, 5, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v17, v18, p1.creator_type)
	end

	if p1.creator_id ~= nil then
		local v19, v20 = proto.writeTag(buf, n1, 6, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v19, v20, p1.creator_id)
	end

	if p1.player_count ~= nil then
		local v21, v22 = proto.writeTag(buf, n1, 7, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v21, v22, p1.player_count)
	end

	if p1.total_up_votes ~= nil then
		local v23, v24 = proto.writeTag(buf, n1, 8, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v23, v24, p1.total_up_votes)
	end

	if p1.total_down_votes ~= nil then
		local v25, v26 = proto.writeTag(buf, n1, 9, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v25, v26, p1.total_down_votes)
	end

	if p1.is_voice_supported ~= nil then
		local v27, v28 = proto.writeTag(buf, n1, 10, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v27, v28, not p1.is_voice_supported and 0 or 1)
	end

	if p1.is_camera_supported ~= nil then
		local v29, v30 = proto.writeTag(buf, n1, 11, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v29, v30, not p1.is_camera_supported and 0 or 1)
	end

	if p1.localized_fiat_price ~= nil then
		local v31, v32 = proto.writeTag(buf, n1, 12, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v31, v32, p1.localized_fiat_price)
	end

	if p1.genre_l1 ~= nil then
		local v33, v34 = proto.writeTag(buf, n1, 13, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v33, v34, p1.genre_l1)
	end

	if p1.genre_l2 ~= nil then
		local v35, v36 = proto.writeTag(buf, n1, 14, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v35, v36, p1.genre_l2)
	end

	if p1.maximum_server_size ~= nil then
		local v37, v38 = proto.writeTag(buf, n1, 15, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v37, v38, p1.maximum_server_size)
	end

	if p1.created_date ~= nil then
		local v39, v40 = proto.writeTag(buf, n1, 16, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v39, v40, p1.created_date)
	end

	if p1.updated_date ~= nil then
		local v41, v42 = proto.writeTag(buf, n1, 17, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v41, v42, p1.updated_date)
	end

	if p1.favorite_count ~= nil then
		local v43, v44 = proto.writeTag(buf, n1, 18, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v43, v44, p1.favorite_count)
	end

	if p1.total_visits ~= nil then
		local v45, v46 = proto.writeTag(buf, n1, 19, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v45, v46, p1.total_visits)
	end

	if p1.canonical_url_path ~= nil then
		local v47, v48 = proto.writeTag(buf, n1, 20, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v47, v48, p1.canonical_url_path)
	end

	if p1.game_minimum_age ~= nil then
		local v49, v50 = proto.writeTag(buf, n1, 21, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v49, v50, p1.game_minimum_age)
	end

	if p1.game_age_display_name ~= nil then
		local v51, v52 = proto.writeTag(buf, n1, 22, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v51, v52, p1.game_age_display_name)
	end

	if p1.content_maturity ~= nil then
		local v53, v54 = proto.writeTag(buf, n1, 23, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v53, v54, p1.content_maturity)
	end

	if p1.is_officially_licensed ~= nil then
		local v55, v56 = proto.writeTag(buf, n1, 24, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v55, v56, not p1.is_officially_licensed and 0 or 1)
	end

	if p1.refund_policy_text ~= nil then
		local v57, v58 = proto.writeTag(buf, n1, 25, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v57, v58, p1.refund_policy_text)
	end

	if p1.refund_article_id ~= nil then
		local v59, v60 = proto.writeTag(buf, n1, 26, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeString(v59, v60, p1.refund_article_id)
	end

	if p1.preview_video_id ~= nil then
		local v61, v62 = proto.writeTag(buf, n1, 27, proto.wireTypes.varint)

		buf, n1 = proto.writeVarInt(v61, v62, p1.preview_video_id)
	end

	local buf2 = buffer.create(n1)

	buffer.copy(buf2, 0, buf, 0, n1)

	return buf2
end
function t2.decode(p2: buffer) -- line: 277
	-- upvalues: t2 (copy), proto (copy)
	local v65 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v67, v68

		v67, v68, n2 = proto.readTag(p2, n2)

		if v68 == proto.wireTypes.varint then
			if v67 == 1 then
				local v69

				v69, n2 = proto.readVarIntI64(p2, n2)
				v65.id = v69
			elseif v67 == 4 then
				local v70

				v70, n2 = proto.readVarIntI64(p2, n2)
				v65.root_place_id = v70
			elseif v67 == 6 then
				local v71

				v71, n2 = proto.readVarIntI64(p2, n2)
				v65.creator_id = v71
			elseif v67 == 7 then
				local v72

				v72, n2 = proto.readVarIntI64(p2, n2)
				v65.player_count = v72
			elseif v67 == 8 then
				local v73

				v73, n2 = proto.readVarIntI64(p2, n2)
				v65.total_up_votes = v73
			elseif v67 == 9 then
				local v74

				v74, n2 = proto.readVarIntI64(p2, n2)
				v65.total_down_votes = v74
			elseif v67 == 10 then
				local v75

				v75, n2 = proto.readVarInt(p2, n2)
				v65.is_voice_supported = v75 ~= 0
			elseif v67 == 11 then
				local v76

				v76, n2 = proto.readVarInt(p2, n2)
				v65.is_camera_supported = v76 ~= 0
			elseif v67 == 15 then
				local v77

				v77, n2 = proto.readVarIntI64(p2, n2)
				v65.maximum_server_size = v77
			elseif v67 == 18 then
				local v78

				v78, n2 = proto.readVarIntI64(p2, n2)
				v65.favorite_count = v78
			elseif v67 == 19 then
				local v79

				v79, n2 = proto.readVarIntI64(p2, n2)
				v65.total_visits = v79
			elseif v67 == 21 then
				local v80

				v80, n2 = proto.readVarIntI32(p2, n2)
				v65.game_minimum_age = v80
			elseif v67 == 24 then
				local v81

				v81, n2 = proto.readVarInt(p2, n2)
				v65.is_officially_licensed = v81 ~= 0
			elseif v67 == 27 then
				local v82

				v82, n2 = proto.readVarIntI64(p2, n2)
				v65.preview_video_id = v82
			else
				local v83

				v83, n2 = proto.readVarInt(p2, n2)
			end
		elseif v68 == proto.wireTypes.lengthDelimited then
			if v67 == 2 then
				local v84

				v84, n2 = proto.readBuffer(p2, n2)
				v65.name = buffer.tostring(v84)
			elseif v67 == 3 then
				local v85

				v85, n2 = proto.readBuffer(p2, n2)
				v65.description = buffer.tostring(v85)
			elseif v67 == 5 then
				local v86

				v86, n2 = proto.readBuffer(p2, n2)
				v65.creator_type = buffer.tostring(v86)
			elseif v67 == 12 then
				local v87

				v87, n2 = proto.readBuffer(p2, n2)
				v65.localized_fiat_price = buffer.tostring(v87)
			elseif v67 == 13 then
				local v88

				v88, n2 = proto.readBuffer(p2, n2)
				v65.genre_l1 = buffer.tostring(v88)
			elseif v67 == 14 then
				local v89

				v89, n2 = proto.readBuffer(p2, n2)
				v65.genre_l2 = buffer.tostring(v89)
			elseif v67 == 16 then
				local v90

				v90, n2 = proto.readBuffer(p2, n2)
				v65.created_date = buffer.tostring(v90)
			elseif v67 == 17 then
				local v91

				v91, n2 = proto.readBuffer(p2, n2)
				v65.updated_date = buffer.tostring(v91)
			elseif v67 == 20 then
				local v92

				v92, n2 = proto.readBuffer(p2, n2)
				v65.canonical_url_path = buffer.tostring(v92)
			elseif v67 == 22 then
				local v93

				v93, n2 = proto.readBuffer(p2, n2)
				v65.game_age_display_name = buffer.tostring(v93)
			elseif v67 == 23 then
				local v94

				v94, n2 = proto.readBuffer(p2, n2)
				v65.content_maturity = buffer.tostring(v94)
			elseif v67 == 25 then
				local v95

				v95, n2 = proto.readBuffer(p2, n2)
				v65.refund_policy_text = buffer.tostring(v95)
			elseif v67 == 26 then
				local v96

				v96, n2 = proto.readBuffer(p2, n2)
				v65.refund_article_id = buffer.tostring(v96)
			else
				local v97, v98 = proto.readVarInt(p2, n2)

				n2 = v98 + v97
			end
		elseif v68 == proto.wireTypes.i32 then
			local v99

			v99, n2 = proto.readFixed32(p2, n2)
		elseif v68 == proto.wireTypes.i64 then
			local v100

			v100, n2 = proto.readFixed64(p2, n2)
		else
			error("Unsupported wire type: " .. v68)
		end
	end

	return v65
end
function t2.jsonEncode(p3) -- line: 450
	local t4 = {}

	if p3.id ~= nil then
		t4.id = p3.id
	end

	if p3.name ~= nil then
		t4.name = p3.name
	end

	if p3.description ~= nil then
		t4.description = p3.description
	end

	if p3.root_place_id ~= nil then
		t4.rootPlaceId = p3.root_place_id
	end

	if p3.creator_type ~= nil then
		t4.creatorType = p3.creator_type
	end

	if p3.creator_id ~= nil then
		t4.creatorId = p3.creator_id
	end

	if p3.player_count ~= nil then
		t4.playerCount = p3.player_count
	end

	if p3.total_up_votes ~= nil then
		t4.totalUpVotes = p3.total_up_votes
	end

	if p3.total_down_votes ~= nil then
		t4.totalDownVotes = p3.total_down_votes
	end

	if p3.is_voice_supported ~= nil then
		t4.isVoiceSupported = p3.is_voice_supported
	end

	if p3.is_camera_supported ~= nil then
		t4.isCameraSupported = p3.is_camera_supported
	end

	if p3.localized_fiat_price ~= nil then
		t4.localizedFiatPrice = p3.localized_fiat_price
	end

	if p3.genre_l1 ~= nil then
		t4.genreL1 = p3.genre_l1
	end

	if p3.genre_l2 ~= nil then
		t4.genreL2 = p3.genre_l2
	end

	if p3.maximum_server_size ~= nil then
		t4.maximumServerSize = p3.maximum_server_size
	end

	if p3.created_date ~= nil then
		t4.createdDate = p3.created_date
	end

	if p3.updated_date ~= nil then
		t4.updatedDate = p3.updated_date
	end

	if p3.favorite_count ~= nil then
		t4.favoriteCount = p3.favorite_count
	end

	if p3.total_visits ~= nil then
		t4.totalVisits = p3.total_visits
	end

	if p3.canonical_url_path ~= nil then
		t4.canonicalUrlPath = p3.canonical_url_path
	end

	if p3.game_minimum_age ~= nil then
		t4.gameMinimumAge = p3.game_minimum_age
	end

	if p3.game_age_display_name ~= nil then
		t4.gameAgeDisplayName = p3.game_age_display_name
	end

	if p3.content_maturity ~= nil then
		t4.contentMaturity = p3.content_maturity
	end

	if p3.is_officially_licensed ~= nil then
		t4.isOfficiallyLicensed = p3.is_officially_licensed
	end

	if p3.refund_policy_text ~= nil then
		t4.refundPolicyText = p3.refund_policy_text
	end

	if p3.refund_article_id ~= nil then
		t4.refundArticleId = p3.refund_article_id
	end

	if p3.preview_video_id ~= nil then
		t4.previewVideoId = p3.preview_video_id
	end

	return t4
end
function t2.jsonDecode(t5: {[any]: any}) -- line: 564
	-- upvalues: t2 (copy)
	local v104 = t2.new()

	if t5.id ~= nil then
		v104.id = t5.id
	end

	if t5.name ~= nil then
		v104.name = t5.name
	end

	if t5.description ~= nil then
		v104.description = t5.description
	end

	if t5.root_place_id ~= nil then
		v104.root_place_id = t5.root_place_id
	end

	if t5.rootPlaceId ~= nil then
		v104.root_place_id = t5.rootPlaceId
	end

	if t5.creator_type ~= nil then
		v104.creator_type = t5.creator_type
	end

	if t5.creatorType ~= nil then
		v104.creator_type = t5.creatorType
	end

	if t5.creator_id ~= nil then
		v104.creator_id = t5.creator_id
	end

	if t5.creatorId ~= nil then
		v104.creator_id = t5.creatorId
	end

	if t5.player_count ~= nil then
		v104.player_count = t5.player_count
	end

	if t5.playerCount ~= nil then
		v104.player_count = t5.playerCount
	end

	if t5.total_up_votes ~= nil then
		v104.total_up_votes = t5.total_up_votes
	end

	if t5.totalUpVotes ~= nil then
		v104.total_up_votes = t5.totalUpVotes
	end

	if t5.total_down_votes ~= nil then
		v104.total_down_votes = t5.total_down_votes
	end

	if t5.totalDownVotes ~= nil then
		v104.total_down_votes = t5.totalDownVotes
	end

	if t5.is_voice_supported ~= nil then
		v104.is_voice_supported = t5.is_voice_supported
	end

	if t5.isVoiceSupported ~= nil then
		v104.is_voice_supported = t5.isVoiceSupported
	end

	if t5.is_camera_supported ~= nil then
		v104.is_camera_supported = t5.is_camera_supported
	end

	if t5.isCameraSupported ~= nil then
		v104.is_camera_supported = t5.isCameraSupported
	end

	if t5.localized_fiat_price ~= nil then
		v104.localized_fiat_price = t5.localized_fiat_price
	end

	if t5.localizedFiatPrice ~= nil then
		v104.localized_fiat_price = t5.localizedFiatPrice
	end

	if t5.genre_l1 ~= nil then
		v104.genre_l1 = t5.genre_l1
	end

	if t5.genreL1 ~= nil then
		v104.genre_l1 = t5.genreL1
	end

	if t5.genre_l2 ~= nil then
		v104.genre_l2 = t5.genre_l2
	end

	if t5.genreL2 ~= nil then
		v104.genre_l2 = t5.genreL2
	end

	if t5.maximum_server_size ~= nil then
		v104.maximum_server_size = t5.maximum_server_size
	end

	if t5.maximumServerSize ~= nil then
		v104.maximum_server_size = t5.maximumServerSize
	end

	if t5.created_date ~= nil then
		v104.created_date = t5.created_date
	end

	if t5.createdDate ~= nil then
		v104.created_date = t5.createdDate
	end

	if t5.updated_date ~= nil then
		v104.updated_date = t5.updated_date
	end

	if t5.updatedDate ~= nil then
		v104.updated_date = t5.updatedDate
	end

	if t5.favorite_count ~= nil then
		v104.favorite_count = t5.favorite_count
	end

	if t5.favoriteCount ~= nil then
		v104.favorite_count = t5.favoriteCount
	end

	if t5.total_visits ~= nil then
		v104.total_visits = t5.total_visits
	end

	if t5.totalVisits ~= nil then
		v104.total_visits = t5.totalVisits
	end

	if t5.canonical_url_path ~= nil then
		v104.canonical_url_path = t5.canonical_url_path
	end

	if t5.canonicalUrlPath ~= nil then
		v104.canonical_url_path = t5.canonicalUrlPath
	end

	if t5.game_minimum_age ~= nil then
		v104.game_minimum_age = t5.game_minimum_age
	end

	if t5.gameMinimumAge ~= nil then
		v104.game_minimum_age = t5.gameMinimumAge
	end

	if t5.game_age_display_name ~= nil then
		v104.game_age_display_name = t5.game_age_display_name
	end

	if t5.gameAgeDisplayName ~= nil then
		v104.game_age_display_name = t5.gameAgeDisplayName
	end

	if t5.content_maturity ~= nil then
		v104.content_maturity = t5.content_maturity
	end

	if t5.contentMaturity ~= nil then
		v104.content_maturity = t5.contentMaturity
	end

	if t5.is_officially_licensed ~= nil then
		v104.is_officially_licensed = t5.is_officially_licensed
	end

	if t5.isOfficiallyLicensed ~= nil then
		v104.is_officially_licensed = t5.isOfficiallyLicensed
	end

	if t5.refund_policy_text ~= nil then
		v104.refund_policy_text = t5.refund_policy_text
	end

	if t5.refundPolicyText ~= nil then
		v104.refund_policy_text = t5.refundPolicyText
	end

	if t5.refund_article_id ~= nil then
		v104.refund_article_id = t5.refund_article_id
	end

	if t5.refundArticleId ~= nil then
		v104.refund_article_id = t5.refundArticleId
	end

	if t5.preview_video_id ~= nil then
		v104.preview_video_id = t5.preview_video_id
	end

	if t5.previewVideoId ~= nil then
		v104.preview_video_id = t5.previewVideoId
	end

	return v104
end

t2.descriptor = {
	name = "UniverseData",
	fullName = "roblox.apppageplatform.shared.v1beta1.UniverseData"
}
t1.UniverseData = t2
typeRegistry.default:register(t1.UniverseData)

return {
	UniverseData = t1.UniverseData
}
