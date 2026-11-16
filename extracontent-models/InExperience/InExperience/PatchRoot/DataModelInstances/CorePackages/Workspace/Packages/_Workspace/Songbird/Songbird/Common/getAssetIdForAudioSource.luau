local function getAssetIdForAudioSource(instance)
	local v

	if instance:IsA("Sound") then
		v = instance.SoundId
	elseif instance:IsA("AudioPlayer") then
		v = instance.Asset
	end

	return (tonumber((v:match("rbxassetid://(.+)"))))
end

return getAssetIdForAudioSource
