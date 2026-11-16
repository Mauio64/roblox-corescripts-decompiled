require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsTypes")

local FFlagMomentsTTSDraftRestore = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsTTSDraftRestore")

local function encodeUDim2(p2)
	return {
		xScale = p2.X.Scale,
		xOffset = p2.X.Offset,
		yScale = p2.Y.Scale,
		yOffset = p2.Y.Offset
	}
end

local function encodeColor3(data)
	return { r = data.R, g = data.G, b = data.B }
end

local function encodeTextOverlay(data)
	local textOverlayStyle = data.textOverlayStyle

	local position = data.position
	local v5 = {
		position = {
			xScale = position.X.Scale,
			xOffset = position.X.Offset,
			yScale = position.Y.Scale,
			yOffset = position.Y.Offset
		},
		rotation = data.rotation,
		scale = data.scale,
		text = data.text,
		zIndex = data.zIndex,
		textOverlayStyle = 0
	}
	local v6 = {
		font = textOverlayStyle.font.Name,
		fontColor = 0,
		fontSize = 0,
		textXAlignment = 0
	}
	local fontColor = textOverlayStyle.fontColor
	v6.fontColor = { r = fontColor.R, g = fontColor.G, b = fontColor.B }
	v6.fontSize = textOverlayStyle.fontSize
	v6.textXAlignment = textOverlayStyle.textXAlignment.Name
	v5.textOverlayStyle = v6
	return v5
end

local function encodeStickerOverlay(data)
	local v5 = {
		stickerURI = data.stickerURI,
		position = 0,
		stickerSize = 0,
		rotation = 0,
		scale = 0,
		zIndex = 0
	}
	local position = data.position
	v5.position = {
		xScale = position.X.Scale,
		xOffset = position.X.Offset,
		yScale = position.Y.Scale,
		yOffset = position.Y.Offset
	}
	v5.stickerSize = data.stickerSize
	v5.rotation = data.rotation
	v5.scale = data.scale
	v5.zIndex = data.zIndex
	return v5
end

local function encodeVoice(data)
	return { text = data.text, voiceId = data.voiceId, startTime = data.startTime }
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

local function safeDecodeEnum(p2, value)
	if type(value) ~= "string" then
		return nil
	end

	local success, result = pcall(function()
		return p2[value]
	end)

	if success then
		return result
	end

	return nil
end

local function decodeTextOverlay(data)
	if type(data) ~= "table" or type(data.textOverlayStyle) ~= "table" then
		return nil
	end

	local textOverlayStyle = data.textOverlayStyle
	local v5 = decodeUDim2(data.position)
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

	if v5 == nil or result == nil or color == nil or result2 == nil then
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
			position = v5,
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

	local v5 = decodeUDim2(data.position)

	if v5 == nil or data.stickerURI ~= nil and type(data.stickerURI) ~= "string" then
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
			position = v5,
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
		return {
			text = voice.text,
			voiceId = voice.voiceId,
			startTime = voice.startTime
		}
	end

	return nil
end

return {
	serialize = function(data)
		local edits = data.edits

		local v5 = { trim = edits.trim, music = edits.music }

		if edits.text then
			local v6 = {}

			for k, v7 in edits.text do
				table.insert(v6, encodeTextOverlay(v7))
			end

			v5.text = v6
		end

		if edits.sticker then
			local v6 = {}

			for k, v7 in edits.sticker do
				local v8 = {
					stickerURI = v7.stickerURI,
					position = 0,
					stickerSize = 0,
					rotation = 0,
					scale = 0,
					zIndex = 0
				}
				local position = v7.position
				v8.position = {
					xScale = position.X.Scale,
					xOffset = position.X.Offset,
					yScale = position.Y.Scale,
					yOffset = position.Y.Offset
				}
				v8.stickerSize = v7.stickerSize
				v8.rotation = v7.rotation
				v8.scale = v7.scale
				v8.zIndex = v7.zIndex

				table.insert(v6, v8)
			end

			v5.sticker = v6
		end

		if FFlagMomentsTTSDraftRestore and edits.voice then
			local voice = edits.voice
			v5.voice = {
				text = voice.text,
				voiceId = voice.voiceId,
				startTime = voice.startTime
			}
		end

		return {
			userId = data.userId,
			captureRef = {
				localId = data.captureRef.localId,
				captureType = data.captureRef.captureType.Name
			},
			description = data.description,
			commentsEnabled = data.commentsEnabled,
			edits = v5,
			lastSaveTime = data.lastSaveTime
		}
	end,
	deserialize = function(data)
		if type(data) ~= "table" then
			return nil
		end

		local captureRef = data.captureRef

		if
			type(captureRef) ~= "table"
			or type(captureRef.localId) ~= "string"
			or captureRef.localId == ""
		then
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

		local v5 = {}

		if edits.trim ~= nil then
			local v6 = decodeTrim(edits.trim)

			if v6 == nil then
				return nil
			end

			v5.trim = v6
		end

		if edits.music ~= nil then
			local v6 = decodeMusic(edits.music)

			if v6 == nil then
				return nil
			end

			v5.music = v6
		end

		if edits.text ~= nil then
			if type(edits.text) ~= "table" then
				return nil
			end

			local v6 = {}

			for k, v7 in edits.text do
				local v8 = decodeTextOverlay(v7)

				if v8 == nil then
					return nil
				end

				table.insert(v6, v8)
			end

			v5.text = v6
		end

		if edits.sticker ~= nil then
			if type(edits.sticker) ~= "table" then
				return nil
			end

			local v6 = {}

			for k, v7 in edits.sticker do
				local v8 = decodeStickerOverlay(v7)

				if v8 == nil then
					return nil
				end

				table.insert(v6, v8)
			end

			v5.sticker = v6
		end

		if FFlagMomentsTTSDraftRestore and edits.voice ~= nil then
			v5.voice = decodeVoice(edits.voice)
		end

		if
			type(data.userId) ~= "string"
			or data.description ~= nil and type(data.description) ~= "string"
		then
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
				edits = v5,
				lastSaveTime = data.lastSaveTime
			}
		end

		return nil
	end
}
