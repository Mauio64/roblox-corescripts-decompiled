require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsTypes")

local GetFFlagMomentsTTSAudioOverlay = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/GetFFlagMomentsTTSAudioOverlay")
local fFlagMomentsTextOverlayV2Redesign = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon").Flags.FFlagMomentsTextOverlayV2Redesign

local FFlagMomentsCommentsCreatorControl = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsCommentsCreatorControl")
local FFlagMomentsCreationSessionId = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsCreationSessionId")

local function enumName(p2)
	if typeof(p2) == "EnumItem" then
		return p2.Name
	end

	return p2
end

local function convertTextOverlayStyle(textOverlayStyle)
	local v6

	if fFlagMomentsTextOverlayV2Redesign then
		v6 = textOverlayStyle.font

		if typeof(v6) == "EnumItem" then
			v6 = v6.Name
		end
	else
		v6 = textOverlayStyle.font.Name
	end

	local v5 = {
		font = v6,
		fontColor = {
			textOverlayStyle.fontColor.R,
			textOverlayStyle.fontColor.G,
			textOverlayStyle.fontColor.B
		},
		fontSize = textOverlayStyle.fontSize,
		textXAlignment = 0
	}
	local v7

	if fFlagMomentsTextOverlayV2Redesign then
		v7 = textOverlayStyle.textXAlignment

		if typeof(v7) == "EnumItem" then
			v7 = v7.Name
		end
	else
		v7 = textOverlayStyle.textXAlignment.Name
	end

	v5.textXAlignment = v7
	return v5
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

local function makePostMetadata(data, p2, creationSessionId)
	local postMetadata = {}

	postMetadata.caption = data.description

	if FFlagMomentsCreationSessionId and creationSessionId ~= nil and creationSessionId ~= "" then
		postMetadata.creationSessionId = creationSessionId
	end

	if FFlagMomentsCommentsCreatorControl and data.commentsEnabled == false then
		postMetadata.commentsEnabled = false
	end

	local v5 = data.captureType

	if typeof(v5) == "EnumItem" then
		v5 = v5.Name
	end

	if v5 == Enum.CaptureType.Screenshot.Name then
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
			local v6 = {}

			for k, textOverlay in data.edits.textOverlays do
				table.insert(v6, convertTextOverlay(textOverlay))
			end

			postMetadata.textOverlays = v6
		end

		if GetFFlagMomentsTTSAudioOverlay and data.edits.tts and data.edits.tts.text ~= nil and data.edits.tts.text ~= "" then
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
		local universeId = data.universeId
	end

	local v6 = data.universeId

	if v6 == nil or not (v6 > 0) then
		v6 = data.universeIdOverride
	end

	if v6 and data.placeId then
		postMetadata.primaryCta = { experienceId = v6, placeId = data.placeId }
	end

	local v7

	if fFlagMomentsTextOverlayV2Redesign then
		local v8 = data.captureType

		if typeof(v8) == "EnumItem" then
			v8 = v8.Name
		end

		v7 = v8 == Enum.CaptureType.Video.Name
	else
		v7 = data.captureType == Enum.CaptureType.Video
	end

	if v7 then
		postMetadata.durationSeconds = data.assetTotalDuration
	end

	if p2 == nil then
		return postMetadata
	end

	postMetadata.media = {
		{
			capture = p2,
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
