local function getAssetIdForAudioSource(p1) -- line: 1
	return (tonumber((((if not p1:IsA("Sound") then (if not p1:IsA("AudioPlayer") then nil else p1.Asset) else p1.SoundId)):match("rbxassetid://(.+)"))))
end

return getAssetIdForAudioSource
