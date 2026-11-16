require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsTypes")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags")
local fFlagMomentsAvatarLookTryOn = SharedFlags.FFlagMomentsAvatarLookTryOn
local fFlagMomentsRenderAvatarPostsInFeed = SharedFlags.FFlagMomentsRenderAvatarPostsInFeed

local v5 = {
	TEXT_X_ALIGNMENT_LEFT = Enum.TextXAlignment.Left,
	TEXT_X_ALIGNMENT_CENTER = Enum.TextXAlignment.Center,
	TEXT_X_ALIGNMENT_RIGHT = Enum.TextXAlignment.Right
}

local function toEnumFont(value)
	if type(value) ~= "string" then
		return nil
	end

	local v6 = string.match(value, "^ENUMERATED_FONT_(.+)$")

	if v6 == nil or v6 == "INVALID" then
		return nil
	end

	local v7 = {}

	for k in string.gmatch(v6, "[^_]+") do
		table.insert(v7, string.upper((string.sub(k, 1, 1))) .. string.lower((string.sub(k, 2))))
	end

	local success, result = pcall(function()
		return Enum.Font[table.concat(v7)]
	end)

	if success then
		return result
	end

	return nil
end

local function durationSeconds(p2)
	if p2 == nil then
		return 0
	end

	return (p2.seconds or 0) + (p2.nanos or 0) / 1000000000
end

local function toTrim(p2)
	if p2 == nil then
		return nil
	end

	local offset_duration = p2.offset_duration
	local v6 = offset_duration == nil and 0
		or (offset_duration.seconds or 0) + (offset_duration.nanos or 0) / 1000000000

	local duration = p2.duration
	local v7 = duration == nil and 0 or (duration.seconds or 0) + (duration.nanos or 0) / 1000000000

	if v7 <= 0 then
		return nil
	end

	return {
		startTime = v6,
		endTime = v6 + v7
	}
end

local function toTextOverlay(value, value2, p2)
	local transform = value.transform
	local udim

	if transform == nil or transform.position == nil then
		udim = UDim2.fromScale(0.5, 0.5)
	else
		udim = UDim2.fromScale(transform.position.x, transform.position.y)
	end

	local font_source = if value2.font ~= nil then value2.font.font_source else nil
	local v6

	if not (font_source == nil or font_source.type ~= "enumerated_font") then
		v6 = toEnumFont(font_source.value)
	end

	local font_color = value2.font_color

	local textOverlay = {
		position = udim,
		rotation = transform == nil and 0 or transform.rotation,
		scale = (transform == nil or transform.scale == 0) and 1 or transform.scale,
		text = value2.text,
		textOverlayStyle = 0,
		zIndex = 0
	}
	local v7 = {
		font = v6 or p2 or Enum.Font.BuilderSansMedium,
		fontColor = 0,
		fontSize = 0,
		textXAlignment = 0
	}
	local v8 = if font_color == nil then Color3.new(0, 0, 0) else Color3.new(font_color.r, font_color.g, font_color.b)
	v7.fontColor = v8

	v7.fontSize = not (value2.font_size > 0) and 16 or value2.font_size
	v7.textXAlignment = v5[value2.text_x_alignment] or Enum.TextXAlignment.Center
	textOverlay.textOverlayStyle = v7

	textOverlay.zIndex = (type(value.z_index) ~= "number" or not (value.z_index > 0)) and 1 or value.z_index
	return textOverlay
end

local function musicStartTime(p2, p3)
	local v6 = if p3.source_trim == nil then p2.time_range else p3.source_trim

	if v6 == nil then
		return 0
	end

	local offset_duration = v6.offset_duration

	if offset_duration == nil then
		return 0
	end

	return (offset_duration.seconds or 0) + (offset_duration.nanos or 0) / 1000000000
end

local function getTtsAssetAccessContext(p2, p3)
	if p2 == nil or p2.ttsAudios == nil then
		return nil
	end

	for k, ttsAudio in p2.ttsAudios do
		if ttsAudio.assetId == p3 then
			return ttsAudio.assetAccessContext
		end
	end

	return nil
end

local function applyPostMetadata(clone, metadata)
	if metadata == nil then
		return
	end

	if metadata.caption ~= nil and metadata.caption ~= "" then
		clone.description = metadata.caption
	end

	if metadata.total_duration ~= nil then
		local total_duration = metadata.total_duration
		clone.assetTotalDuration = total_duration == nil and 0
			or (total_duration.seconds or 0) + (total_duration.nanos or 0) / 1000000000
	end

	if metadata.origin ~= nil and metadata.origin ~= 0 and metadata.origin ~= "POST_ORIGIN_INVALID" then
		clone.hasAuthoritativePartnerUploadType = true
		clone.partnerUploadType = metadata.origin == "POST_ORIGIN_INFLUENCER_UPLOAD" and "influencer" or nil
	end
end

local function deriveMomentFromPost(p2, p3)
	local clone = table.clone(p2.metadata)
	local edits = clone.edits

	local v7 = if edits ~= nil then edits.stickerOverlays else nil
	local v6 = { stickerOverlays = v7 }

	local v8 = {}
	local v9 = nil
	local v10 = {}
	local v11 = false
	local v12 = nil

	for k, v13 in p3.tracks or {} do
		for k2, v14 in v13.slots or {} do
			local content = v14.content

			if content == nil then
				continue
			end

			if content.type == "visual" then
				local value = content.value
				local content2 = value.content

				if content2 ~= nil then
					if content2.type == "video" and v9 == nil and content2.value.asset_id > 0 then
						v9 = content2.value.asset_id
						v12 = Enum.CaptureType.Video
						local trim = content2.value.trim
						local v15

						if trim ~= nil then
							local offset_duration = trim.offset_duration
							local v16 = offset_duration == nil and 0
								or (offset_duration.seconds or 0) + (offset_duration.nanos or 0) / 1000000000

							local duration = trim.duration
							local v17 = duration == nil and 0
								or (duration.seconds or 0) + (duration.nanos or 0) / 1000000000

							v15 = not (v17 <= 0) and {
								startTime = v16,
								endTime = v16 + v17
							} or nil
						end

						v6.trim = v15
					elseif content2.type == "image" and v9 == nil and content2.value.asset_id > 0 then
						v9 = content2.value.asset_id
						v12 = Enum.CaptureType.Screenshot
					elseif fFlagMomentsRenderAvatarPostsInFeed and content2.type == "scene" then
						v11 = true
					elseif content2.type == "text_label" then
						local v15 = #v10 + 1
						local v16 = if not (edits == nil or edits.textOverlays == nil) then edits.textOverlays[v15] else nil

						local v17 = if v16 ~= nil then v16.textOverlayStyle.font else nil
						table.insert(v10, toTextOverlay(value, content2.value, v17))
					end
				end
			elseif content.type == "audio" then
				local value = content.value

				if value.audio_type == "AUDIO_TYPE_MUSIC" and v6.music == nil and value.asset_id > 0 then
					local v15 = { assetId = value.asset_id, startTime = 0 }
					local v16 = if value.source_trim == nil then v14.time_range else value.source_trim
					local v17

					if v16 == nil then
						v17 = 0
					else
						local offset_duration = v16.offset_duration
						v17 = offset_duration == nil and 0
							or (offset_duration.seconds or 0) + (offset_duration.nanos or 0) / 1000000000
					end

					v15.startTime = v17
					v6.music = v15
				elseif
					value.audio_type == "AUDIO_TYPE_TTS"
					and value.context ~= nil
					and value.context.type == "tts"
					and value.asset_id > 0
				then
					local value2 = value.context.value
					local v15 = {
						text = value2.text,
						voiceId = value2.voice_id,
						startTime = 0,
						assetId = 0,
						assetAccessContext = 0
					}
					local v16

					if v14.time_range == nil then
						v16 = 0
					else
						local offset_duration = v14.time_range.offset_duration
						v16 = offset_duration == nil and 0
							or (offset_duration.seconds or 0) + (offset_duration.nanos or 0) / 1000000000
					end

					v15.startTime = v16

					v15.assetId = value.asset_id
					local asset_id = value.asset_id
					local assetAccessContext

					if not (edits == nil or edits.ttsAudios == nil) then
						local flag = true

						for k3, ttsAudio in edits.ttsAudios do
							if ttsAudio.assetId == asset_id then
								assetAccessContext = ttsAudio.assetAccessContext
								flag = false
								break
							end
						end

						if flag then
							assetAccessContext = nil
						end
					end

					v15.assetAccessContext = assetAccessContext
					table.insert(v8, v15)
				end
			elseif content.type == "experience_annotation" then
				if content.value.universe_id > 0 then
					clone.universeId = content.value.universe_id
				end

				if content.value.place_id > 0 then
					clone.placeId = content.value.place_id
				end
			elseif
				fFlagMomentsAvatarLookTryOn
				and content.type == "avatar_annotation"
				and content.value.outfit_id > 0
			then
				clone.outfitId = content.value.outfit_id
			end
		end
	end

	if (v9 == nil or v12 == nil) and not (fFlagMomentsRenderAvatarPostsInFeed and v11) then
		return nil
	end

	if #v10 > 0 then
		v6.textOverlays = v10
	end

	if #v8 > 0 then
		v6.ttsAudios = v8
	end

	applyPostMetadata(clone, p3.metadata)

	if fFlagMomentsRenderAvatarPostsInFeed and v12 == nil then
		v12 = clone.captureType
	end

	clone.captureType = v12

	clone.edits = v6

	local clone2 = table.clone(p2)

	if fFlagMomentsRenderAvatarPostsInFeed and v9 == nil then
		v9 = p2.assetId
	end

	clone2.assetId = v9

	clone2.metadata = clone
	return clone2
end

return deriveMomentFromPost
