local v1 = game:DefineFastInt("LuaAppSchedulerYieldInterval", -1)
local v2 = game:DefineFastInt("LuaAppSchedulerDeferredWork", -1)
local v3 = game:DefineFastInt("LuaAppSchedulerHeartbeatFrameMarker", -1)
local v4 = game:DefineFastInt("LuaAppSchedulerTargetMsByHeartbeatDelta", -1)
local v5 = game:DefineFastInt("LuaAppSchedulerNumberOfLookbackFrames", -1)
local v6 = game:DefineFastInt("LuaAppSchedulerLookbackUseRingBuffer", -1)
local v7 = game:DefineFastInt("LuaAppSchedulerDesiredFrameRate", -1)
local v8 = game:DefineFastInt("LuaAppSchedulerMinimumFrameRate", -1)
local v9 = game:DefineFastInt("LuaInExpSchedulerYieldInterval", -1)
local v10 = game:DefineFastInt("LuaInExpSchedulerDeferredWork", -1)
local v11 = game:DefineFastInt("LuaInExpSchedulerHeartbeatFrameMarker", -1)
local v12 = game:DefineFastInt("LuaInExpSchedulerTargetMsByHeartbeatDelta", -1)
local v13 = game:DefineFastInt("LuaInExpSchedulerNumberOfLookbackFrames", -1)
local v14 = game:DefineFastInt("LuaInExpSchedulerLookbackUseRingBuffer", -1)
local v15 = game:DefineFastInt("LuaInExpSchedulerDesiredFrameRate", -1)
local v16 = game:DefineFastInt("LuaInExpSchedulerMinimumFrameRate", -1)

local function buildFlags(n1: number, n2: number, n3: number, n4: number, n5: number, n6: number, n7: number, n8: number) -- line: 36
	local t1 = {}
	local v27 = false

	if n1 ~= -1 then
		t1.yieldInterval = n1
		v27 = true
	end

	if n2 ~= -1 then
		t1.deferredWork = n2 == 1
		v27 = true
	end

	if n3 ~= -1 then
		t1.heartbeatFrameMarker = n3 == 1
		v27 = true
	end

	if n4 ~= -1 then
		t1.targetMsByHeartbeatDelta = n4 == 1
		v27 = true
	end

	if n5 ~= -1 then
		t1.numberOfLookbackFrames = n5
		v27 = true
	end

	if n6 ~= -1 then
		t1.lookbackUseRingBuffer = n6 == 1
		v27 = true
	end

	if n7 ~= -1 then
		t1.desiredFrameRate = n7
		v27 = true
	end

	if n8 ~= -1 then
		t1.minimumFrameRate = n8
		v27 = true
	end

	if v27 then
		return t1
	end

	return nil
end

return {
	getApp = function() -- line: 88
		-- upvalues: buildFlags (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy), v8 (copy)
		return (buildFlags(v1, v2, v3, v4, v5, v6, v7, v8))
	end,
	getInExp = function() -- line: 103
		-- upvalues: buildFlags (copy), v9 (copy), v10 (copy), v11 (copy), v12 (copy), v13 (copy), v14 (copy), v15 (copy), v16 (copy)
		return (buildFlags(v9, v10, v11, v12, v13, v14, v15, v16))
	end
}
