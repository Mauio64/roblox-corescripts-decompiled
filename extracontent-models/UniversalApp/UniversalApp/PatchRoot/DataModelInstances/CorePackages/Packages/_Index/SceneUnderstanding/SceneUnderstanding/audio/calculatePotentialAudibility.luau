local SceneUnderstanding = script:FindFirstAncestor("SceneUnderstanding")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local safelyAccessProperty = require(SceneUnderstanding.safelyAccessProperty)
local getOutputWires = require(SceneUnderstanding.wiring.getOutputWires)

require(SceneUnderstanding.wiring.types)

local toWirableInstance = require(SceneUnderstanding.wiring.toWirableInstance)

local function calculateSoundPotentialAudibility(p1) -- line: 13
	-- upvalues: safelyAccessProperty (copy)
	if not p1.IsPlaying then
		return 0
	end

	local v12 = safelyAccessProperty(p1, "RollOffGain", 0)
	local v13 = not p1.SoundGroup and 1 or p1.SoundGroup.Volume

	if v12 < 1 then
		v12 /= 10
	end

	return v13 * p1.Volume * v12
end
local function getOutputsOf(p2) -- line: 41
	-- upvalues: getOutputWires (copy), toWirableInstance (copy)
	if typeof(p2) == "Instance" and p2:IsA("AudioEmitter") then
		return (p2:GetInteractingListeners())
	end

	local t1 = {}

	for _, v17 in getOutputWires(p2) do
		local v18 = toWirableInstance(v17.TargetInstance)

		if v18 then
			table.insert(t1, v18)
		end
	end

	return t1
end
local function getAudibilityMultiplierFor(p3) -- line: 60
	local n1 = 0

	for _, v22 in p3:GetInteractingListeners() do
		n1 += v22:GetAudibilityFor(p3)
	end

	return n1
end
local function getAudibilityOf(p4, t2: {[any]: any}?) -- line: 68
	-- upvalues: getOutputsOf (copy), getAudibilityOf (copy)
	local v25 = t2 or {}

	if v25[p4] then
		return 0
	end

	v25[p4] = true

	local n2 = 1

	if typeof(p4) == "Instance" then
		if p4:IsA("AudioPlayer") or p4:IsA("AudioFader") then
			n2 = p4.Volume
		elseif p4:IsA("AudioEmitter") then
			n2 = 0

			for _, v28 in p4:GetInteractingListeners() do
				n2 += v28:GetAudibilityFor(p4)
			end
		elseif p4:IsA("AudioDeviceOutput") then
			return 1
		end
	end

	local n3 = 0

	for _, v31 in getOutputsOf(p4) do
		n3 += n2 * getAudibilityOf(v31, v25)
	end

	return n3
end
local function calculatePotentialAudibility(p5) -- line: 105
	-- upvalues: safelyAccessProperty (copy), UserGameSettings (copy), getAudibilityOf (copy)
	local v33 = safelyAccessProperty(UserGameSettings, "MasterVolume", 0)
	local n4

	if p5:IsA("Sound") then
		if not p5.IsPlaying then
			n4 = 0
		else
			local v35 = safelyAccessProperty(p5, "RollOffGain", 0)
			local v36 = not p5.SoundGroup and 1 or p5.SoundGroup.Volume

			if v35 < 1 then
				v35 /= 10
			end

			n4 = v36 * p5.Volume * v35
		end
	else
		n4 = getAudibilityOf(p5)
	end

	return v33 * n4
end

return calculatePotentialAudibility
