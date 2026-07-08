local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local Signal = require(scriptParentParent.AppCommonLib).Signal

require(scriptParent.PlatformLeaderboardTypes)
require(scriptParent.PlatformLeaderboardFetcher)

local v4 = game:DefineFastInt("PlatformLeaderboardConfigPollIntervalSeconds", 300)
local v5 = game:DefineFastInt("PlatformLeaderboardConfigPollMaxJitterSeconds", 60)
local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 48
	-- upvalues: Signal (copy), t1 (copy), v5 (copy), v4 (copy)
	local v9 = setmetatable({
		_config = nil,
		_pollTimer = nil,
		_fetcher = p1,
		_configChanged = Signal.new()
	}, t1)
	local ok, result, v12 = pcall(p1.fetchConfig)

	if ok and result then
		v9._config = v12
	end

	local thread = nil

	local function pollLoop() -- line: 62
		-- upvalues: v9 (copy), thread (ref), v5 (copy), v4 (copy)
		while v9._pollTimer == thread do
			local v27 = math.random() * v5

			task.wait(v4 + v27)

			local ok2, result2, v30 = pcall(v9._fetcher.fetchConfig)

			if ok2 and result2 then
				v9:updateConfig(v30)
			end
		end
	end

	thread = task.defer(function() -- line: 73
		-- upvalues: pollLoop (copy), v9 (copy), thread (ref)
		if not pcall(pollLoop) and v9._pollTimer == thread then
			warn("[PlatformLeaderboard] ConfigService poll loop terminated unexpectedly")
			v9._pollTimer = nil
		end
	end)
	v9._pollTimer = thread

	return v9
end

local function configsEqual(p2, p3) -- line: 85
	if p2 == p3 then
		return true
	end

	if p2 == nil or p3 == nil then
		return false
	end

	return p2.leaderboardId == p3.leaderboardId and p2.unit == p3.unit
end

function t1.updateConfig(p4, p5) -- line: 95
	local _config = p4._config

	if _config == p5 or _config ~= nil and (p5 ~= nil and (_config.leaderboardId == p5.leaderboardId and _config.unit == p5.unit)) then
		return
	end

	local _config2 = p4._config

	p4._config = p5
	p4._configChanged:fire(_config2, p4._config)
end
function t1.getConfig(p6) -- line: 104
	return p6._config
end
function t1.hasActiveConfig(p7) -- line: 108
	return p7._config ~= nil
end
function t1.onConfigChanged(t2: {[any]: any}, p8: ((...any) -> ...any)) -- line: 112
	return t2._configChanged:connect(p8)
end
function t1.teardown(p9) -- line: 118
	local _pollTimer = p9._pollTimer

	p9._pollTimer = nil

	if _pollTimer and not pcall(task.cancel, _pollTimer) then
		warn("[PlatformLeaderboard] ConfigService teardown: failed to cancel poll timer")
	end
end

return t1
