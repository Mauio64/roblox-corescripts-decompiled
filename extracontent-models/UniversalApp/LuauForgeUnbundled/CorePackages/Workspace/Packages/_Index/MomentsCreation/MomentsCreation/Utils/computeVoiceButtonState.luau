local function trimWhitespace(value)
	return (value:gsub("^%s*(.-)%s*$", "%1"))
end

local function computeVoiceButtonState(data)
	local v5 = data.ttsState == "loading"
	local v6 = data.ttsState == "error"
	local v7 = data.text:gsub("^%s*(.-)%s*$", "%1")
	local v8 = utf8.len(v7) or 0
	local v9 = v7 ~= data.lastGeneratedText

	local v10 = if v6 then data.errorReason == "moderated" and not v9 else v6

	local v11 = if v6 then data.errorReason == "tooManyDigits" and not v9 else v6
	local v12 = utf8.len(data.text) or 0
	local v13 = data.maxChars < v12

	local hasGenerated = data.hasGenerated or data.lastSavedText ~= ""
	local v14 = v8 == 0 and (hasGenerated and v9)

	local v15 = v7:match("%w") ~= nil
	local v16 = v8 > 0 and (not v13 and v15)
	local v17 = v6 and not (v10 or v11)

	if v14 or v16 then
		if v9 or v17 then
			v17 = not v5
		end
	else
		v17 = v16
	end

	local hasGenerated2 = data.hasGenerated or data.hasCleared
	local v18 = data.lastGeneratedText ~= data.lastSavedText
	local v19 = data.hasGenerated and (data.startTime or 0) ~= (data.lastSavedStartTime or 0)
	local v20 = data.hasGenerated and (data.voiceId or 0) ~= (data.lastSavedVoiceId or 0)

	if hasGenerated2 then
		if v18 or v19 or v20 then
			v20 = not (v9 or v5 or v6)
		end
	else
		v20 = hasGenerated2
	end

	return {
		isGenerating = v5,
		isError = v6,
		charCount = v12,
		isOverLimit = v13,
		canGenerate = v17,
		isModerated = v10,
		isTooManyDigits = v11,
		showSave = v20
	}
end

return computeVoiceButtonState
