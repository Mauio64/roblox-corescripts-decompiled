local SceneUnderstanding = script:FindFirstAncestor("SceneUnderstanding")

local UserGameSettings = UserSettings():GetService("UserGameSettings")

local safelyAccessProperty = require(SceneUnderstanding.safelyAccessProperty)
local getOutputWires = require(SceneUnderstanding.wiring.getOutputWires)
require(SceneUnderstanding.wiring.types)
local toWirableInstance = require(SceneUnderstanding.wiring.toWirableInstance)

local function calculateSoundPotentialAudibility(sound) -- 1 equivalent call inferred from this helper
	if not sound.IsPlaying then
		return 0
	end

	local v = safelyAccessProperty(sound, "RollOffGain", 0)

	local v2 = not sound.SoundGroup and 1 or sound.SoundGroup.Volume

	if v < 1 then
		v /= 10
	end

	return v2 * sound.Volume * v
end

local function getOutputsOf(audioEmitter)
	if typeof(audioEmitter) == "Instance" and audioEmitter:IsA("AudioEmitter") then
		return (audioEmitter:GetInteractingListeners())
	end

	local result = {}

	for _, v in getOutputWires(audioEmitter) do
		local v2 = toWirableInstance(v.TargetInstance)

		if v2 then
			table.insert(result, v2)
		end
	end

	return result
end

local function getAudibilityMultiplierFor(object)
	local audibilityMultiplierFor = 0

	for _, v in object:GetInteractingListeners() do
		audibilityMultiplierFor += v:GetAudibilityFor(object)
	end

	return audibilityMultiplierFor
end

local function getAudibilityOf(sound, options)
	local v = options or {}

	if v[sound] then
		return 0
	end

	v[sound] = true
	local v2 = 1

	if typeof(sound) == "Instance" then
		if sound:IsA("AudioPlayer") or sound:IsA("AudioFader") then
			v2 = sound.Volume
		elseif sound:IsA("AudioEmitter") then
			v2 = 0

			for _, v3 in sound:GetInteractingListeners() do
				v2 += v3:GetAudibilityFor(sound)
			end
		elseif sound:IsA("AudioDeviceOutput") then
			return 1
		end
	end

	local total = 0

	for _, v3 in getOutputsOf(sound) do
		total += v2 * getAudibilityOf(v3, v)
	end

	return total
end

local function calculatePotentialAudibility(sound)
	local v = safelyAccessProperty(UserGameSettings, "MasterVolume", 0)
	local v2

	if sound:IsA("Sound") then
		v2 = calculateSoundPotentialAudibility(sound) -- inferred equivalent call
	else
		v2 = getAudibilityOf(sound)
	end

	return v * v2
end

return calculatePotentialAudibility
