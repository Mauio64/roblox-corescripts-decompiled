local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local AppCommonLib = require(scriptParentParent.AppCommonLib)
local SharedFlags = require(scriptParentParent.SharedFlags)
local Signal = AppCommonLib.Signal

require(scriptParent.PlatformLeaderboardTypes)
require(scriptParent.PlatformLeaderboardFetcher)

local v6 = game:DefineFastInt("PlatformLeaderboardConfigPollIntervalSeconds", 300)
local v7 = game:DefineFastInt("PlatformLeaderboardConfigPollMaxJitterSeconds", 60)
local FFlagPlatformLeaderboardDebugLogging = SharedFlags.FFlagPlatformLeaderboardDebugLogging
local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 50
	-- upvalues: Signal (copy), t1 (copy), v7 (copy), v6 (copy), FFlagPlatformLeaderboardDebugLogging (copy)
	local v12 = setmetatable({
		_config = nil,
		_pollTimer = nil,
		_fetcher = p1,
		_configChanged = Signal.new()
	}, t1)
	local ok, result, v15 = pcall(p1.fetchConfig)

	if ok and result then
		v12._config = v15
	end

	local thread = nil

	local function pollLoop() -- line: 64
		-- upvalues: v12 (copy), thread (ref), v7 (copy), v6 (copy)
		while v12._pollTimer == thread do
			local v30 = math.random() * v7

			task.wait(v6 + v30)

			local ok2, result2, v33 = pcall(v12._fetcher.fetchConfig)

			if ok2 and result2 then
				v12:updateConfig(v33)
			end
		end
	end

	thread = task.defer(function() -- line: 75
		-- upvalues: pollLoop (copy), v12 (copy), thread (ref), FFlagPlatformLeaderboardDebugLogging (copy)
		if not pcall(pollLoop) and v12._pollTimer == thread then
			if FFlagPlatformLeaderboardDebugLogging then
				warn("[PlatformLeaderboard] ConfigService poll loop terminated unexpectedly")
			end

			v12._pollTimer = nil
		end
	end)
	v12._pollTimer = thread

	return v12
end

local function configsEqual(p2, p3) -- line: 89
	if p2 == p3 then
		return true
	end

	if p2 == nil or p3 == nil then
		return false
	end

	return p2.leaderboardId == p3.leaderboardId and p2.unit == p3.unit
end

function t1.updateConfig(p4, p5) -- line: 99
	local _config = p4._config

	if _config == p5 or _config ~= nil and (p5 ~= nil and (_config.leaderboardId == p5.leaderboardId and _config.unit == p5.unit)) then
		return
	end

	local _config2 = p4._config

	p4._config = p5
	p4._configChanged:fire(_config2, p4._config)
end
function t1.getConfig(p6) -- line: 108
	return p6._config
end
function t1.hasActiveConfig(p7) -- line: 112
	return p7._config ~= nil
end
function t1.onConfigChanged(t2: {[any]: any}, p8: ((...any) -> ...any)) -- line: 116
	return t2._configChanged:connect(p8)
end
function t1.teardown(p9) -- line: 122
	-- upvalues: FFlagPlatformLeaderboardDebugLogging (copy)
	local _pollTimer = p9._pollTimer

	p9._pollTimer = nil

	if _pollTimer and (not pcall(task.cancel, _pollTimer) and FFlagPlatformLeaderboardDebugLogging) then
		warn("[PlatformLeaderboard] ConfigService teardown: failed to cancel poll timer")
	end
end

return t1
