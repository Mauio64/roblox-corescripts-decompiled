local SceneUnderstanding = script:FindFirstAncestor("SceneUnderstanding")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local safelyAccessProperty = require(SceneUnderstanding.safelyAccessProperty)

local function getAudibleVolume(p1) -- line: 19
	-- upvalues: safelyAccessProperty (copy), UserGameSettings (copy)
	if not p1.IsPlaying then
		return 0
	end

	local v6 = safelyAccessProperty(UserGameSettings, "MasterVolume", 0)
	local v7 = safelyAccessProperty(p1, "RollOffGain", 0)

	return v6 * (not p1.SoundGroup and 1 or p1.SoundGroup.Volume) * p1.Volume * v7
end

return getAudibleVolume
