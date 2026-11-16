local PlatformLeaderboardClientStore

if game:DefineFastFlag("PlatformLeaderboardEnabled", false) then
	PlatformLeaderboardClientStore = require(script.PlatformLeaderboardClientStore)
else
	PlatformLeaderboardClientStore = nil
end

local platformLeaderboardClientStore = nil

local function getPlatformLeaderboardClientStore()
	if platformLeaderboardClientStore == nil and PlatformLeaderboardClientStore ~= nil then
		platformLeaderboardClientStore = PlatformLeaderboardClientStore.new()
	end

	return platformLeaderboardClientStore
end

local function reset()
	if platformLeaderboardClientStore ~= nil then
		platformLeaderboardClientStore:destroy()
		platformLeaderboardClientStore = nil
	end
end

return {
	["jest.config"] = script["jest.config"],
	PlatformLeaderboardClientStore = PlatformLeaderboardClientStore,
	getPlatformLeaderboardClientStore = getPlatformLeaderboardClientStore,
	reset = reset
}
