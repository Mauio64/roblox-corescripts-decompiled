local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

require(parent.MomentsTypes)

local GetFFlagMomentsTTSAudioOverlay = require(MomentsCreation.Flags.GetFFlagMomentsTTSAudioOverlay)
local MomentsCommon = require(parent.MomentsCommon)
local FFlagMomentsTextOverlayV2Redesign = MomentsCommon.Flags.FFlagMomentsTextOverlayV2Redesign

local FFlagMomentsCommentsCreatorControl = require(MomentsCreation.Flags.FFlagMomentsCommentsCreatorControl)
local FFlagMomentsCreationSessionId = require(MomentsCreation.Flags.FFlagMomentsCreationSessionId)

local function enumName(p) -- 4 equivalent calls inferred from this helper
	return if typeof(p) == "EnumItem" then p.Name else p
end

local function convertTextOverlayStyle(textOverlayStyle)
	local font

	if FFlagMomentsTextOverlayV2Redesign then
		font = textOverlayStyle.font
		font = enumName(font) -- inferred equivalent call
	else
		font = textOverlayStyle.font.Name
	end

	local v = {
		font = font,
		fontColor = { textOverlayStyle.fontColor.R, textOverlayStyle.fontColor.G, textOverlayStyle.fontColor.B },
		fontSize = textOverlayStyle.fontSize,
		textXAlignment = 0
	}
	local textXAlignment

	if FFlagMomentsTextOverlayV2Redesign then
		textXAlignment = textOverlayStyle.textXAlignment
		textXAlignment = enumName(textXAlignment) -- inferred equivalent call
	else
		textXAlignment = textOverlayStyle.textXAlignment.Name
	end

	v.textXAlignment = textXAlignment
	return v
end

local function convertTextOverlay(textOverlay)
	return {
		text = textOverlay.text,
		rotation = textOverlay.rotation,
		scale = textOverlay.scale,
		zIndex = textOverlay.zIndex,
		position = { textOverlay.position.X.Scale, textOverlay.position.Y.Scale },
		textOverlayStyle = convertTextOverlayStyle(textOverlay.textOverlayStyle)
	}
end

local function makePostMetadata(data, capture, creationSessionId: string?)
	local postMetadata = {}

	postMetadata.caption = data.description

	if FFlagMomentsCreationSessionId and creationSessionId ~= nil and creationSessionId ~= "" then
		postMetadata.creationSessionId = creationSessionId
	end

	if FFlagMomentsCommentsCreatorControl and data.commentsEnabled == false then
		postMetadata.commentsEnabled = false
	end

	if enumName(data.captureType) == Enum.CaptureType.Screenshot.Name then -- inferred equivalent call
		postMetadata.widthPixels = data.widthPixels
		postMetadata.heightPixels = data.heightPixels
	end

	if data.edits then
		if data.edits.music then
			postMetadata.music = {
				assetId = data.edits.music.assetId,
				startTime = data.edits.music.startTime
			}
		end

		if data.edits.trim then
			postMetadata.trim = {
				startTime = data.edits.trim.startTime,
				endTime = data.edits.trim.endTime
			}
		end

		if data.edits.textOverlays then
			local textOverlays = {}

			for _, textOverlay in data.edits.textOverlays do
				table.insert(textOverlays, convertTextOverlay(textOverlay))
			end

			postMetadata.textOverlays = textOverlays
		end

		if
			GetFFlagMomentsTTSAudioOverlay
			and data.edits.tts
			and data.edits.tts.text ~= nil
			and data.edits.tts.text ~= ""
		then
			local tts = data.edits.tts
			postMetadata.textToSpeech = {
				{
					text = tts.text,
					voiceId = tts.voiceId,
					pitch = 0,
					speed = 1,
					startTime = tts.startTime
				}
			}
		end
	end

	if not data.universeIdOverride then
		local _universeId = data.universeId
	end

	local experienceId = data.universeId

	if experienceId == nil or not (experienceId > 0) then
		experienceId = data.universeIdOverride
	end

	if experienceId and data.placeId then
		postMetadata.primaryCta = { experienceId = experienceId, placeId = data.placeId }
	end

	local v

	if FFlagMomentsTextOverlayV2Redesign then
		v = enumName(data.captureType) == Enum.CaptureType.Video.Name -- inferred equivalent call
	else
		v = data.captureType == Enum.CaptureType.Video
	end

	if v then
		postMetadata.durationSeconds = data.assetTotalDuration
	end

	if capture == nil then
		return postMetadata
	end

	postMetadata.media = {
		{
			capture = capture,
			widthPixels = postMetadata.widthPixels,
			heightPixels = postMetadata.heightPixels,
			durationSeconds = postMetadata.durationSeconds,
			trim = postMetadata.trim
		}
	}

	postMetadata.widthPixels = nil
	postMetadata.heightPixels = nil
	postMetadata.durationSeconds = nil
	postMetadata.trim = nil

	return postMetadata
end

return makePostMetadata
