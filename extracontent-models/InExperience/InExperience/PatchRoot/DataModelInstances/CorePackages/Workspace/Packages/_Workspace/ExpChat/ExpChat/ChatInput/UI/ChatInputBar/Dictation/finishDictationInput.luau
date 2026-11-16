local function finishDictationInput(p)
	if p == nil then
		return false
	end

	local success, result = pcall(function(): boolean
		if not game:GetFastFlag("EnableManualVad") then
			return false
		end

		local v = p
		v.VoiceDetectedOverride = false
		v.DisableVoiceDetection = true
		return true
	end)

	return success and result
end

return finishDictationInput
