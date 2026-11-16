local parent = script.Parent
local parent2 = parent.Parent

local AppCommonLib = require(parent2.AppCommonLib)
local SharedFlags = require(parent2.SharedFlags)
local Signal = AppCommonLib.Signal

require(parent.PlatformLeaderboardTypes)
require(parent.PlatformLeaderboardFetcher)

local defineFastInt = game:DefineFastInt("PlatformLeaderboardConfigPollIntervalSeconds", 300)

local defineFastInt2 = game:DefineFastInt("PlatformLeaderboardConfigPollMaxJitterSeconds", 60)
local FFlagPlatformLeaderboardDebugLogging = SharedFlags.FFlagPlatformLeaderboardDebugLogging

local PlatformLeaderboardConfigService = {}
PlatformLeaderboardConfigService.__index = PlatformLeaderboardConfigService

function PlatformLeaderboardConfigService.new(fetcher)
	local object = setmetatable(
		{ _fetcher = fetcher, _config = nil, _configChanged = Signal.new(), _pollTimer = nil },
		PlatformLeaderboardConfigService
	)

	local success, result, config = pcall(fetcher.fetchConfig)

	if success and result then
		object._config = config
	end

	local thread = nil
	local function pollLoop()
		while object._pollTimer == thread do
			local v = math.random() * defineFastInt2
			task.wait(defineFastInt + v)
			local success2, result2, v2 = pcall(object._fetcher.fetchConfig)

			if success2 and result2 then
				object:updateConfig(v2)
			end
		end
	end

	thread = task.defer(function()
		if not pcall(pollLoop) and object._pollTimer == thread then
			if FFlagPlatformLeaderboardDebugLogging then
				warn("[PlatformLeaderboard] ConfigService poll loop terminated unexpectedly")
			end

			object._pollTimer = nil
		end
	end)
	object._pollTimer = thread

	return object
end

local function configsEqual(config, config2): boolean -- 1 equivalent call inferred from this helper
	if config == config2 then
		return true
	end

	if config == nil or config2 == nil then
		return false
	end

	return config.leaderboardId == config2.leaderboardId and config.unit == config2.unit
end

function PlatformLeaderboardConfigService:updateConfig(config)
	if configsEqual(self._config, config) then -- inferred equivalent call
		return
	end

	local _config = self._config
	self._config = config
	self._configChanged:fire(_config, self._config)
end

function PlatformLeaderboardConfigService:getConfig()
	return self._config
end

function PlatformLeaderboardConfigService:hasActiveConfig(): boolean
	return self._config ~= nil
end

function PlatformLeaderboardConfigService:onConfigChanged(callback)
	return self._configChanged:connect(callback)
end

function PlatformLeaderboardConfigService:teardown()
	local pollTimer = self._pollTimer
	self._pollTimer = nil

	if pollTimer and not pcall(task.cancel, pollTimer) and FFlagPlatformLeaderboardDebugLogging then
		warn("[PlatformLeaderboard] ConfigService teardown: failed to cancel poll timer")
	end
end

return PlatformLeaderboardConfigService
