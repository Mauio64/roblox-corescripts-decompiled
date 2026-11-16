local parent = script:FindFirstAncestor("Moments").Parent

require(parent.MomentsTypes)
local SharedFlags = require(parent.SharedFlags)
local FFlagMomentsAvatarLookTryOn = SharedFlags.FFlagMomentsAvatarLookTryOn
local FFlagMomentsRenderAvatarPostsInFeed = SharedFlags.FFlagMomentsRenderAvatarPostsInFeed

local v = {
	TEXT_X_ALIGNMENT_LEFT = Enum.TextXAlignment.Left,
	TEXT_X_ALIGNMENT_CENTER = Enum.TextXAlignment.Center,
	TEXT_X_ALIGNMENT_RIGHT = Enum.TextXAlignment.Right
}

local function toEnumFont(value)
	if type(value) ~= "string" then
		return nil
	end

	local v2 = string.match(value, "^ENUMERATED_FONT_(.+)$")

	if v2 == nil or v2 == "INVALID" then
		return nil
	end

	local v3 = {}

	for k in string.gmatch(v2, "[^_]+") do
		table.insert(v3, string.upper((string.sub(k, 1, 1))) .. string.lower((string.sub(k, 2))))
	end

	local success, result = pcall(function()
		return Enum.Font[table.concat(v3)]
	end)
	return if success then result else nil
end

local function durationSeconds(p) -- 5 equivalent calls inferred from this helper
	if p == nil then
		return 0
	end

	return (p.seconds or 0) + (p.nanos or 0) / 1000000000
end

local function toTrim(trim) -- 1 equivalent call inferred from this helper
	if trim == nil then
		return nil
	end

	local startTime = durationSeconds(trim.offset_duration) -- inferred equivalent call
	local v2 = durationSeconds(trim.duration) -- inferred equivalent call

	if v2 <= 0 then
		return nil
	end

	return {
		startTime = startTime,
		endTime = startTime + v2
	}
end

local function toTextOverlay(value, value2, p)
	local transform = value.transform
	local udim

	if transform == nil or transform.position == nil then
		udim = UDim2.fromScale(0.5, 0.5)
	else
		udim = UDim2.fromScale(transform.position.x, transform.position.y)
	end

	local font_source

	if value2.font ~= nil then
		font_source = value2.font.font_source
	end

	local v2

	if not (font_source == nil or font_source.type ~= "enumerated_font") then
		v2 = toEnumFont(font_source.value)
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
	local textOverlayStyle = {
		font = v2 or p or Enum.Font.BuilderSansMedium,
		fontColor = 0,
		fontSize = 0,
		textXAlignment = 0
	}
	local fontColor

	if font_color == nil then
		fontColor = Color3.new(0, 0, 0)
	else
		fontColor = Color3.new(font_color.r, font_color.g, font_color.b)
	end

	textOverlayStyle.fontColor = fontColor

	textOverlayStyle.fontSize = not (value2.font_size > 0) and 16 or value2.font_size
	textOverlayStyle.textXAlignment = v[value2.text_x_alignment] or Enum.TextXAlignment.Center
	textOverlay.textOverlayStyle = textOverlayStyle

	textOverlay.zIndex = (type(value.z_index) ~= "number" or not (value.z_index > 0)) and 1 or value.z_index
	return textOverlay
end

local function musicStartTime(p, value) -- 1 equivalent call inferred from this helper
	local v2

	if value.source_trim == nil then
		v2 = p.time_range
	else
		v2 = value.source_trim
	end

	if v2 == nil then
		return 0
	end

	return durationSeconds(v2.offset_duration) -- inferred equivalent call
end

local function getTtsAssetAccessContext(edits, asset_id: number) -- 1 equivalent call inferred from this helper
	if edits == nil or edits.ttsAudios == nil then
		return nil
	end

	for _, ttsAudio in edits.ttsAudios do
		if ttsAudio.assetId == asset_id then
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
		clone.assetTotalDuration = durationSeconds(metadata.total_duration) -- inferred equivalent call
	end

	if metadata.origin ~= nil and metadata.origin ~= 0 and metadata.origin ~= "POST_ORIGIN_INVALID" then
		clone.hasAuthoritativePartnerUploadType = true
		clone.partnerUploadType = metadata.origin == "POST_ORIGIN_INFLUENCER_UPLOAD" and "influencer" or nil
	end
end

local function deriveMomentFromPost(p, p2)
	local clone = table.clone(p.metadata)
	local edits = clone.edits
	local stickerOverlays

	if edits ~= nil then
		stickerOverlays = edits.stickerOverlays
	end

	local edits2 = { stickerOverlays = stickerOverlays }

	local ttsAudios = {}
	local assetId = nil
	local textOverlays = {}
	local v2 = false
	local captureType = nil

	for _, v3 in p2.tracks or {} do
		for _, v4 in v3.slots or {} do
			local content = v4.content

			if content == nil then
				continue
			end

			if content.type == "visual" then
				local value = content.value
				local content2 = value.content

				if content2 ~= nil then
					if content2.type == "video" and assetId == nil and content2.value.asset_id > 0 then
						assetId = content2.value.asset_id
						captureType = Enum.CaptureType.Video
						edits2.trim = toTrim(content2.value.trim) -- inferred equivalent call
					elseif content2.type == "image" and assetId == nil and content2.value.asset_id > 0 then
						assetId = content2.value.asset_id
						captureType = Enum.CaptureType.Screenshot
					elseif FFlagMomentsRenderAvatarPostsInFeed and content2.type == "scene" then
						v2 = true
					elseif content2.type == "text_label" then
						local v5 = #textOverlays + 1
						local v6

						if not (edits == nil or edits.textOverlays == nil) then
							v6 = edits.textOverlays[v5]
						end

						local v7

						if v6 ~= nil then
							v7 = v6.textOverlayStyle.font
						end

						table.insert(textOverlays, toTextOverlay(value, content2.value, v7))
					end
				end
			elseif content.type == "audio" then
				local value = content.value

				if value.audio_type == "AUDIO_TYPE_MUSIC" and edits2.music == nil and value.asset_id > 0 then
					edits2.music = {
						assetId = value.asset_id,
						startTime = musicStartTime(v4, value) -- inferred equivalent call
					}
				elseif
					value.audio_type == "AUDIO_TYPE_TTS"
					and value.context ~= nil
					and value.context.type == "tts"
					and value.asset_id > 0
				then
					local value2 = value.context.value
					local v5 = {
						text = value2.text,
						voiceId = value2.voice_id,
						startTime = 0,
						assetId = 0,
						assetAccessContext = 0
					}
					local startTime

					if v4.time_range == nil then
						startTime = 0
					else
						startTime = durationSeconds(v4.time_range.offset_duration) -- inferred equivalent call
					end

					v5.startTime = startTime

					v5.assetId = value.asset_id
					v5.assetAccessContext = getTtsAssetAccessContext(edits, value.asset_id) -- inferred equivalent call
					table.insert(ttsAudios, v5)
				end
			elseif content.type == "experience_annotation" then
				if content.value.universe_id > 0 then
					clone.universeId = content.value.universe_id
				end

				if content.value.place_id > 0 then
					clone.placeId = content.value.place_id
				end
			elseif
				FFlagMomentsAvatarLookTryOn
				and content.type == "avatar_annotation"
				and content.value.outfit_id > 0
			then
				clone.outfitId = content.value.outfit_id
			end
		end
	end

	if (assetId == nil or captureType == nil) and not (FFlagMomentsRenderAvatarPostsInFeed and v2) then
		return nil
	end

	if #textOverlays > 0 then
		edits2.textOverlays = textOverlays
	end

	if #ttsAudios > 0 then
		edits2.ttsAudios = ttsAudios
	end

	applyPostMetadata(clone, p2.metadata)

	if FFlagMomentsRenderAvatarPostsInFeed and captureType == nil then
		captureType = clone.captureType
	end

	clone.captureType = captureType

	clone.edits = edits2

	local clone2 = table.clone(p)

	if FFlagMomentsRenderAvatarPostsInFeed and assetId == nil then
		assetId = p.assetId
	end

	clone2.assetId = assetId

	clone2.metadata = clone
	return clone2
end

return deriveMomentFromPost
