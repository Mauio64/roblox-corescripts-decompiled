local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

require(parent.MomentsTypes)

local FFlagMomentsTTSDraftRestore = require(MomentsCreation.Flags.FFlagMomentsTTSDraftRestore)

local function encodeUDim2(position: UDim2) -- 2 equivalent calls inferred from this helper
	return {
		xScale = position.X.Scale,
		xOffset = position.X.Offset,
		yScale = position.Y.Scale,
		yOffset = position.Y.Offset
	}
end

local function encodeColor3(fontColor: Color3) -- 1 equivalent call inferred from this helper
	return { r = fontColor.R, g = fontColor.G, b = fontColor.B }
end

local function encodeTextOverlay(data)
	local textOverlayStyle = data.textOverlayStyle
	return {
		position = encodeUDim2(data.position), -- inferred equivalent call
		rotation = data.rotation,
		scale = data.scale,
		text = data.text,
		zIndex = data.zIndex,
		textOverlayStyle = {
			font = textOverlayStyle.font.Name,
			fontColor = encodeColor3(textOverlayStyle.fontColor), -- inferred equivalent call
			fontSize = textOverlayStyle.fontSize,
			textXAlignment = textOverlayStyle.textXAlignment.Name
		}
	}
end

local function encodeStickerOverlay(data) -- 1 equivalent call inferred from this helper
	return {
		stickerURI = data.stickerURI,
		position = encodeUDim2(data.position), -- inferred equivalent call
		stickerSize = data.stickerSize,
		rotation = data.rotation,
		scale = data.scale,
		zIndex = data.zIndex
	}
end

local function encodeVoice(voice) -- 1 equivalent call inferred from this helper
	return { text = voice.text, voiceId = voice.voiceId, startTime = voice.startTime }
end

local function decodeUDim2(position)
	if type(position) ~= "table" then
		return nil
	end

	if
		type(position.xScale) == "number"
		and type(position.xOffset) == "number"
		and type(position.yScale) == "number"
		and type(position.yOffset) == "number"
	then
		return UDim2.new(position.xScale, position.xOffset, position.yScale, position.yOffset)
	end

	return nil
end

local function decodeColor3(data)
	if type(data) ~= "table" then
		return nil
	end

	if type(data.r) == "number" and type(data.g) == "number" and type(data.b) == "number" then
		return Color3.new(data.r, data.g, data.b)
	end

	return nil
end

local function safeDecodeEnum(p, value)
	if type(value) ~= "string" then
		return nil
	end

	local success, result = pcall(function()
		return p[value]
	end)
	return if success then result else nil
end

local function decodeTextOverlay(data)
	if type(data) ~= "table" or type(data.textOverlayStyle) ~= "table" then
		return nil
	end

	local textOverlayStyle = data.textOverlayStyle
	local position = decodeUDim2(data.position)
	local font = Enum.Font
	local font2 = textOverlayStyle.font
	local result

	if type(font2) == "string" then
		local success
		success, result = pcall(function()
			return font[font2]
		end)

		if not success then
			result = nil
		end
	end

	local fontColor = textOverlayStyle.fontColor
	local color

	if
		type(fontColor) == "table"
		and type(fontColor.r) == "number"
		and type(fontColor.g) == "number"
		and type(fontColor.b) == "number"
	then
		color = Color3.new(fontColor.r, fontColor.g, fontColor.b)
	end

	local textXAlignment = Enum.TextXAlignment
	local textXAlignment2 = textOverlayStyle.textXAlignment
	local result2

	if type(textXAlignment2) == "string" then
		local success
		success, result2 = pcall(function()
			return textXAlignment[textXAlignment2]
		end)

		if not success then
			result2 = nil
		end
	end

	if position == nil or result == nil or color == nil or result2 == nil then
		return nil
	end

	if
		type(data.rotation) == "number"
		and type(data.scale) == "number"
		and type(data.text) == "string"
		and type(data.zIndex) == "number"
		and type(textOverlayStyle.fontSize) == "number"
	then
		return {
			position = position,
			rotation = data.rotation,
			scale = data.scale,
			text = data.text,
			zIndex = data.zIndex,
			textOverlayStyle = {
				font = result,
				fontColor = color,
				fontSize = textOverlayStyle.fontSize,
				textXAlignment = result2
			}
		}
	end

	return nil
end

local function decodeStickerOverlay(data)
	if type(data) ~= "table" then
		return nil
	end

	local position = decodeUDim2(data.position)

	if position == nil or data.stickerURI ~= nil and type(data.stickerURI) ~= "string" then
		return nil
	end

	if
		type(data.stickerSize) == "number"
		and type(data.rotation) == "number"
		and type(data.scale) == "number"
		and type(data.zIndex) == "number"
	then
		return {
			stickerURI = data.stickerURI,
			position = position,
			stickerSize = data.stickerSize,
			rotation = data.rotation,
			scale = data.scale,
			zIndex = data.zIndex
		}
	end

	return nil
end

local function decodeTrim(trim)
	if type(trim) ~= "table" then
		return nil
	end

	if type(trim.startTime) == "number" and type(trim.endTime) == "number" then
		return { startTime = trim.startTime, endTime = trim.endTime }
	end

	return nil
end

local function decodeMusic(music)
	if type(music) ~= "table" then
		return nil
	end

	if type(music.assetId) == "number" and type(music.startTime) == "number" then
		return { assetId = music.assetId, startTime = music.startTime }
	end

	return nil
end

local function decodeVoice(voice)
	if type(voice) ~= "table" then
		return nil
	end

	if
		type(voice.text) == "string"
		and voice.text ~= ""
		and type(voice.voiceId) == "number"
		and type(voice.startTime) == "number"
	then
		return { text = voice.text, voiceId = voice.voiceId, startTime = voice.startTime }
	end

	return nil
end

local MomentsDraftSerializer = {}

function MomentsDraftSerializer.serialize(data)
	local edits = data.edits

	local edits2 = { trim = edits.trim, music = edits.music }

	if edits.text then
		local text = {}

		for _, v in edits.text do
			table.insert(text, encodeTextOverlay(v))
		end

		edits2.text = text
	end

	if edits.sticker then
		local sticker = {}

		for _, v in edits.sticker do
			table.insert(sticker, encodeStickerOverlay(v)) -- inferred equivalent call
		end

		edits2.sticker = sticker
	end

	if FFlagMomentsTTSDraftRestore and edits.voice then
		edits2.voice = encodeVoice(edits.voice) -- inferred equivalent call
	end

	return {
		userId = data.userId,
		captureRef = {
			localId = data.captureRef.localId,
			captureType = data.captureRef.captureType.Name
		},
		description = data.description,
		commentsEnabled = data.commentsEnabled,
		edits = edits2,
		lastSaveTime = data.lastSaveTime
	}
end

function MomentsDraftSerializer.deserialize(data)
	if type(data) ~= "table" then
		return nil
	end

	local captureRef = data.captureRef

	if type(captureRef) ~= "table" or type(captureRef.localId) ~= "string" or captureRef.localId == "" then
		return nil
	end

	local captureType = Enum.CaptureType
	local captureType2 = captureRef.captureType
	local result

	if type(captureType2) == "string" then
		local success
		success, result = pcall(function()
			return captureType[captureType2]
		end)

		if not success then
			result = nil
		end
	end

	if result == nil then
		return nil
	end

	local edits = data.edits

	if type(edits) ~= "table" then
		return nil
	end

	local edits2 = {}

	if edits.trim ~= nil then
		local trim = decodeTrim(edits.trim)

		if trim == nil then
			return nil
		end

		edits2.trim = trim
	end

	if edits.music ~= nil then
		local music = decodeMusic(edits.music)

		if music == nil then
			return nil
		end

		edits2.music = music
	end

	if edits.text ~= nil then
		if type(edits.text) ~= "table" then
			return nil
		end

		local text = {}

		for _, v in edits.text do
			local v2 = decodeTextOverlay(v)

			if v2 == nil then
				return nil
			end

			table.insert(text, v2)
		end

		edits2.text = text
	end

	if edits.sticker ~= nil then
		if type(edits.sticker) ~= "table" then
			return nil
		end

		local sticker = {}

		for _, v in edits.sticker do
			local v2 = decodeStickerOverlay(v)

			if v2 == nil then
				return nil
			end

			table.insert(sticker, v2)
		end

		edits2.sticker = sticker
	end

	if FFlagMomentsTTSDraftRestore and edits.voice ~= nil then
		edits2.voice = decodeVoice(edits.voice)
	end

	if type(data.userId) ~= "string" or data.description ~= nil and type(data.description) ~= "string" then
		return nil
	end

	if data.commentsEnabled ~= nil and type(data.commentsEnabled) ~= "boolean" then
		return nil
	end

	if type(data.lastSaveTime) == "number" then
		return {
			userId = data.userId,
			captureRef = { localId = captureRef.localId, captureType = result },
			description = data.description,
			commentsEnabled = data.commentsEnabled,
			edits = edits2,
			lastSaveTime = data.lastSaveTime
		}
	end

	return nil
end

return MomentsDraftSerializer
