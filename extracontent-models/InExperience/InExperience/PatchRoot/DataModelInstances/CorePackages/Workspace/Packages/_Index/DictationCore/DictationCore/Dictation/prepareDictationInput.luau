local function prepareDictationInput(p)
	local success, result = pcall(function(): boolean
		if not game:GetFastFlag("EnableManualVad") then
			return false
		end

		p.VoiceDetectedOverride = true
		return true
	end)

	return success and result
end

return prepareDictationInput
