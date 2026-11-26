local defineFastInt = game:DefineFastInt("LuaAppSchedulerYieldInterval", -1)
local defineFastInt2 = game:DefineFastInt("LuaAppSchedulerDeferredWork", -1)
local defineFastInt3 = game:DefineFastInt("LuaAppSchedulerHeartbeatFrameMarker", -1)
local defineFastInt4 = game:DefineFastInt("LuaAppSchedulerTargetMsByHeartbeatDelta", -1)
local defineFastInt5 = game:DefineFastInt("LuaAppSchedulerNumberOfLookbackFrames", -1)
local defineFastInt6 = game:DefineFastInt("LuaAppSchedulerLookbackUseRingBuffer", -1)
local defineFastInt7 = game:DefineFastInt("LuaAppSchedulerDesiredFrameRate", -1)
local defineFastInt8 = game:DefineFastInt("LuaAppSchedulerMinimumFrameRate", -1)

local defineFastInt9 = game:DefineFastInt("LuaInExpSchedulerYieldInterval", -1)
local defineFastInt10 = game:DefineFastInt("LuaInExpSchedulerDeferredWork", -1)
local defineFastInt11 = game:DefineFastInt("LuaInExpSchedulerHeartbeatFrameMarker", -1)

local defineFastInt12 = game:DefineFastInt("LuaInExpSchedulerTargetMsByHeartbeatDelta", -1)
local defineFastInt13 = game:DefineFastInt("LuaInExpSchedulerNumberOfLookbackFrames", -1)
local defineFastInt14 = game:DefineFastInt("LuaInExpSchedulerLookbackUseRingBuffer", -1)
local defineFastInt15 = game:DefineFastInt("LuaInExpSchedulerDesiredFrameRate", -1)
local defineFastInt16 = game:DefineFastInt("LuaInExpSchedulerMinimumFrameRate", -1)

local function buildFlags(yieldInterval, defineFastInt17, defineFastInt18, defineFastInt19, numberOfLookbackFrames, defineFastInt20, desiredFrameRate, minimumFrameRate)
	local v5 = {}
	local flag

	if yieldInterval == -1 then
		flag = false
	else
		v5.yieldInterval = yieldInterval
		flag = true
	end

	if defineFastInt17 ~= -1 then
		v5.deferredWork = defineFastInt17 == 1
		flag = true
	end

	if defineFastInt18 ~= -1 then
		v5.heartbeatFrameMarker = defineFastInt18 == 1
		flag = true
	end

	if defineFastInt19 ~= -1 then
		v5.targetMsByHeartbeatDelta = defineFastInt19 == 1
		flag = true
	end

	if numberOfLookbackFrames ~= -1 then
		v5.numberOfLookbackFrames = numberOfLookbackFrames
		flag = true
	end

	if defineFastInt20 ~= -1 then
		v5.lookbackUseRingBuffer = defineFastInt20 == 1
		flag = true
	end

	if desiredFrameRate ~= -1 then
		v5.desiredFrameRate = desiredFrameRate
		flag = true
	end

	if minimumFrameRate ~= -1 then
		v5.minimumFrameRate = minimumFrameRate
		flag = true
	end

	if flag then
		return v5
	end

	return nil
end

return {
	getApp = function()
		return buildFlags(
			defineFastInt,
			defineFastInt2,
			defineFastInt3,
			defineFastInt4,
			defineFastInt5,
			defineFastInt6,
			defineFastInt7,
			defineFastInt8
		)
	end,
	getInExp = function()
		return buildFlags(
			defineFastInt9,
			defineFastInt10,
			defineFastInt11,
			defineFastInt12,
			defineFastInt13,
			defineFastInt14,
			defineFastInt15,
			defineFastInt16
		)
	end
}
