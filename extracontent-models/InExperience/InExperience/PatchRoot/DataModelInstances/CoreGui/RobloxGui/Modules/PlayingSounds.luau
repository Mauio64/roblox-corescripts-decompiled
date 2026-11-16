local CoreGui = game:GetService("CoreGui")
local GetFFlagSoundTelemetryOsClock = require(CoreGui.RobloxGui.Modules.Flags.GetFFlagSoundTelemetryOsClock)

local PlayingSounds = {}
PlayingSounds.__index = PlayingSounds

function PlayingSounds.new(aggregatedData)
	local v = {}
	setmetatable(v, PlayingSounds)
	v.aggregatedData = aggregatedData
	v.sounds = {}
	return v
end

function PlayingSounds.addSound(p, p2: string, p3: string)
	local v = p.sounds[p2]

	if v == nil then
		if GetFFlagSoundTelemetryOsClock() then
			p.sounds[p2] = { count = 0, starttime = os.clock(), maxLoopCount = 1, instances = {} }
		else
			p.sounds[p2] = { count = 0, starttime = os.time(), maxLoopCount = 1, instances = {} }
		end

		v = p.sounds[p2]
	end

	if v.instances[p3] == nil then
		v.instances[p3] = 1
		v.count += 1
	end
end

function PlayingSounds.removeSound(p, p2: string, p3: string)
	local sound = p.sounds[p2]

	if sound == nil then
		return
	end

	if sound.instances[p3] then
		sound.instances[p3] = nil
		sound.count -= 1
	end

	if sound.count == 0 then
		if GetFFlagSoundTelemetryOsClock() then
			p.aggregatedData:addPlay(p2, math.round(os.clock() - sound.starttime), sound.maxLoopCount)
		else
			p.aggregatedData:addPlay(p2, os.time() - sound.starttime, sound.maxLoopCount)
		end

		p.sounds[p2] = nil
	end
end

function PlayingSounds.loopSound(p, p2: string, p3: string)
	local sound = p.sounds[p2]

	if sound == nil or sound.instances[p3] == nil then
		return
	end

	sound.instances[p3] += 1
	sound.maxLoopCount = math.max(sound.maxLoopCount, sound.instances[p3])
end

return PlayingSounds
