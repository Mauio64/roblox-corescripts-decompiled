local function trimWhitespace(text: string) -- 1 equivalent call inferred from this helper
	return (text:gsub("^%s*(.-)%s*$", "%1"))
end

local function computeVoiceButtonState(data)
	local isGenerating = data.ttsState == "loading"
	local isError = data.ttsState == "error"

	local v = trimWhitespace(data.text) -- inferred equivalent call
	local v2 = utf8.len(v) or 0
	local v3 = v ~= data.lastGeneratedText
	local isModerated

	if isError then
		if data.errorReason == "moderated" then
			isModerated = not v3
		else
			isModerated = false
		end
	else
		isModerated = isError
	end

	local isTooManyDigits

	if isError then
		if data.errorReason == "tooManyDigits" then
			isTooManyDigits = not v3
		else
			isTooManyDigits = false
		end
	else
		isTooManyDigits = isError
	end

	local charCount = utf8.len(data.text) or 0
	local isOverLimit = data.maxChars < charCount

	local hasGenerated = data.hasGenerated or data.lastSavedText ~= ""
	local v4

	if v2 == 0 then
		v4 = hasGenerated and v3
	else
		v4 = false
	end

	local v5 = v:match("%w") ~= nil
	local v6

	if v2 > 0 then
		v6 = not isOverLimit and v5
	else
		v6 = false
	end

	local canGenerate = isError and not (isModerated or isTooManyDigits)

	if v4 or v6 then
		if v3 or canGenerate then
			canGenerate = not isGenerating
		end
	else
		canGenerate = v6
	end

	local hasGenerated2 = data.hasGenerated or data.hasCleared
	local v7 = data.lastGeneratedText ~= data.lastSavedText
	local v8 = data.hasGenerated and (data.startTime or 0) ~= (data.lastSavedStartTime or 0)
	local showSave = data.hasGenerated and (data.voiceId or 0) ~= (data.lastSavedVoiceId or 0)

	if hasGenerated2 then
		if v7 or v8 or showSave then
			showSave = not (v3 or isGenerating or isError)
		end
	else
		showSave = hasGenerated2
	end

	return {
		isGenerating = isGenerating,
		isError = isError,
		charCount = charCount,
		isOverLimit = isOverLimit,
		canGenerate = canGenerate,
		isModerated = isModerated,
		isTooManyDigits = isTooManyDigits,
		showSave = showSave
	}
end

return computeVoiceButtonState
