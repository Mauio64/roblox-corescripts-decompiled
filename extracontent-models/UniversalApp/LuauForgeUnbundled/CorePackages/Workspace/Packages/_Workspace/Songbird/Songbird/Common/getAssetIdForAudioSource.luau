local function getAssetIdForAudioSource(instance)
	local v5

	if instance:IsA("Sound") then
		v5 = instance.SoundId
	elseif instance:IsA("AudioPlayer") then
		v5 = instance.Asset
	end

	return (tonumber((v5:match("rbxassetid://(.+)"))))
end

return getAssetIdForAudioSource
