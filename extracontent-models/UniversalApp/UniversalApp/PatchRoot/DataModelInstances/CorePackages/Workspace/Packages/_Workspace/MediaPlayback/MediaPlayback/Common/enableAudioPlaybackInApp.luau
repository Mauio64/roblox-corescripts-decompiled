local SoundService = game:GetService("SoundService")

local function enableAudioPlaybackInApp() -- line: 25
	-- upvalues: SoundService (copy)
	if game:GetEngineFeature("SoundServiceSetSoundEnabled") then
		SoundService:SetSoundEnabled(true)
	end
end

return enableAudioPlaybackInApp
