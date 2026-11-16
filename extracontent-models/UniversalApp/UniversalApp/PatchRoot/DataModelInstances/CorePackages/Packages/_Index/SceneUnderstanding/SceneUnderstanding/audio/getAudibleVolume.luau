local SceneUnderstanding = script:FindFirstAncestor("SceneUnderstanding")

local UserGameSettings = UserSettings():GetService("UserGameSettings")

local safelyAccessProperty = require(SceneUnderstanding.safelyAccessProperty)

local function getAudibleVolume(data)
	if not data.IsPlaying then
		return 0
	end

	local v = safelyAccessProperty(UserGameSettings, "MasterVolume", 0)
	local v2 = safelyAccessProperty(data, "RollOffGain", 0)

	return v * (not data.SoundGroup and 1 or data.SoundGroup.Volume) * data.Volume * v2
end

return getAudibleVolume
