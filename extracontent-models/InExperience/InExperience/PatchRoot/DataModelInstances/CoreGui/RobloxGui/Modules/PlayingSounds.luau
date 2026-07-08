local CoreGui = game:GetService("CoreGui")
local GetFFlagSoundTelemetryOsClock = require(CoreGui.RobloxGui.Modules.Flags.GetFFlagSoundTelemetryOsClock)
local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 9
	-- upvalues: t1 (copy)
	local t2 = {}

	setmetatable(t2, t1)
	t2.aggregatedData = p1
	t2.sounds = {}

	return t2
end
function t1.addSound(t3: {[any]: any}, s1: string, s2: string) -- line: 17
	-- upvalues: GetFFlagSoundTelemetryOsClock (copy)
	local v9 = t3.sounds[s1]

	if v9 == nil then
		if GetFFlagSoundTelemetryOsClock() then
			t3.sounds[s1] = {
				count = 0,
				maxLoopCount = 1,
				starttime = os.clock(),
				instances = {}
			}
		else
			t3.sounds[s1] = {
				count = 0,
				maxLoopCount = 1,
				starttime = os.time(),
				instances = {}
			}
		end

		v9 = t3.sounds[s1]
	end

	if v9.instances[s2] == nil then
		v9.instances[s2] = 1
		v9.count = v9.count + 1
	end
end
function t1.removeSound(t4: {[any]: any}, s3: string, s4: string) -- line: 37
	-- upvalues: GetFFlagSoundTelemetryOsClock (copy)
	local v13 = t4.sounds[s3]

	if v13 == nil then
		return
	end

	if v13.instances[s4] then
		v13.instances[s4] = nil
		v13.count = v13.count - 1
	end

	if v13.count == 0 then
		if GetFFlagSoundTelemetryOsClock() then
			t4.aggregatedData:addPlay(s3, math.round(os.clock() - v13.starttime), v13.maxLoopCount)
		else
			t4.aggregatedData:addPlay(s3, os.time() - v13.starttime, v13.maxLoopCount)
		end

		t4.sounds[s3] = nil
	end
end
function t1.loopSound(t5: {[any]: any}, s5: string, s6: string) -- line: 66
	local v17 = t5.sounds[s5]

	if v17 == nil or v17.instances[s6] == nil then
		return
	end

	local instances = v17.instances

	instances[s6] = instances[s6] + 1
	v17.maxLoopCount = math.max(v17.maxLoopCount, v17.instances[s6])
end

return t1
